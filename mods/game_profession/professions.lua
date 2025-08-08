-- chunkname: @/modules/game_profession/professions.lua

GameProfessions = {
	lastResetPointRequest = 0,
	quest = false,
	crafting_window = {
		amountToCraft = 1,
		panels = {}
	},
	panels = {},
	attached_panels = {},
	buttons = {},
	caughtFishes = {},
	requestProgressDataEvents = {}
}

function secondsToHours(seconds)
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds - hours * 3600) / 60)

	if hours > 0 then
		return string.format("%dh %dm", hours, minutes)
	else
		return string.format("%dm", minutes)
	end
end

function GameProfessions:loadConfig()
	for _, profession in pairs({
		"blacksmithing",
		"cooking",
		"farming",
		"fishing",
		"husbandry",
		"mining",
		"woodcutting",
		"carpentry",
		"weaving",
		"breeding",
		"herbalism",
		"alchemy"
	}) do
		dofile(string.format("recipes/%s.lua", profession))
	end

	dofile("recipes/tooltip.lua")

	local func, error = loadfile("config.lua")

	if not func then
		g_logger.fatal(error)

		return false
	end

	func()

	local env = getfenv(0)

	env.cfg = {}

	setmetatable(env.cfg, {
		__index = env
	})
	setfenv(func, env.cfg)

	return true
end

function GameProfessions:init()
	dofile("crafting_window.lua")
	self:loadConfig()
	dofile("opcode.lua")
	dofile("minigame.lua")
	g_ui.importStyle("styles/land_interactions.otui")
	g_ui.importStyle("styles/right_panel.otui")
	g_ui.importStyle("styles/passive_panel.otui")
	g_ui.importStyle("styles/left_panel.otui")
	g_ui.importStyle("styles/professions.otui")
	g_ui.importStyle("styles/main.otui")
	g_ui.importStyle("styles/minigame_styles.otui")
	g_ui.importStyle("styles/minigame.otui")
	g_ui.importStyle("styles/crafting_window.otui")
	initOpcode()
	createMinigameWindow()
	self:initializeCraftingWindow()

	self.window = g_ui.createWidget("GameProfessionsWindow", modules.game_interface.getHUDPanel())

	self.window:hide()

	self.attached_window = g_ui.createWidget("GameProfessionsPassiveWindow", modules.game_interface.getHUDPanel())

	self.attached_window:setAttachedTo(self.window)
	self.attached_window:hide()

	self.top_panel = self.window.content.top_panel

	connect(LocalPlayer, {
		onProfessionChange = GameProfessions.onProfessionChange
	})
	self:setupTopPanel()
	self:setupPanels()
	self:setupAttachedPanels()
	connect(Container, {
		onOpen = GameProfessions.refreshOwnedMaterials,
		onRemoveItem = GameProfessions.refreshOwnedMaterials,
		onUpdateItem = GameProfessions.refreshOwnedMaterials,
		onAddItem = GameProfessions.refreshOwnedMaterials
	})
	connect(g_game, {
		onEnterGame = GameProfessions.onEnterGame,
		onGameEnd = GameProfessions.onGameEnd
	})

	self.loadingFrames = {}

	for _ = 1, 30 do
		table.insert(self.loadingFrames, {
			size = {
				width = 25,
				height = 25
			},
			offset = {
				y = 0,
				x = 0
			}
		})
	end

	if g_game.isOnline() then
		local player = g_game.getLocalPlayer()

		for i = ProfessionFirst, ProfessionLast do
			GameProfessions.onProfessionChange(player, i, player:getProfessionLevel(i), player:getProfessionLevelPercent(i), 0, 0, 0, 0)
		end
	end

	self:selectPanel(cfg.professionOrder[1]:lower())
end

function GameProfessions:terminate()
	self.window:destroy()

	for _, event in ipairs(self.requestProgressDataEvents) do
		removeEvent(event)
	end

	self.requestProgressDataEvents = {}

	disconnect(LocalPlayer, {
		onProfessionChange = GameProfessions.onProfessionChange
	})
	disconnect(Container, {
		onOpen = GameProfessions.refreshOwnedMaterials,
		onRemoveItem = GameProfessions.refreshOwnedMaterials,
		onUpdateItem = GameProfessions.refreshOwnedMaterials,
		onAddItem = GameProfessions.refreshOwnedMaterials
	})
	disconnect(g_game, {
		onEnterGame = GameProfessions.onEnterGame,
		onGameEnd = GameProfessions.onGameEnd
	})
	terminateOpcode()
	self:terminateCraftingWindow()

	GameProfessions = nil
end

function GameProfessions.onProfessionChange(player, professionId, level, percent, oldLevel, oldPercent, exp, reqExp)
	local self = GameProfessions

	self.onCraftingProfessionChange(player, professionId, level, percent, oldLevel, oldPercent, exp, reqExp)

	local contentPanel = self.currentSelectedPanel and self.currentSelectedPanel.left_panel.content

	if contentPanel then
		local widget = contentPanel.panel_search.unlocked

		if level ~= oldLevel then
			GameProfessions:fitFilters(contentPanel.list, {
				Recipe = {
					Unlocked = true
				}
			})
		end
	end

	local professionName = ProfessionNames[professionId]:lower()

	player.professionData = player.professionData or {}
	player.professionData[professionId] = {
		level = level,
		oldPercent = oldPercent,
		percent = percent,
		exp = exp,
		reqExp = reqExp
	}

	local topPanelButton = self.top_panel:getChildByIndex(cfg.professionToOrder[professionName])

	topPanelButton.level:setText(level)
	topPanelButton.level_background.level_progress:setPercent(percent)

	local panel = self.panels[professionName]

	panel.left_panel.content.level.level_progress:setPercent(percent)
	panel.left_panel.content.experience:setColoredText(GetHighlightedText(string.format("{%i/, #ced2d9} {%i, #A556FF}", exp, reqExp)))
	panel.left_panel.content.level_rect:setText(level)

	if table.find(CraftingProfessions, professionId) then
		panel = self.crafting_window.panels[professionName]
		panel.level_progress = percent
		panel.level = level

		if self.crafting_window.selected_profession == professionId then
			self:updateCraftingWindowLevel()
		end
	end

	for _, panel in pairs(self.panels) do
		if panel.professionId == professionId then
			local categories = panel.left_panel.content.list

			for _, category in ipairs(categories:getChildren()) do
				for _, entry in ipairs(category.category:getChildren()) do
					if entry then
						local levelRequired = entry.recipe.level

						entry.level:setOn(not levelRequired or level >= levelRequired.single)
						entry.emblem:setVisible(entry.recipe.index and entry.level:isOn() and not entry.emblem.completed)
					end
				end
			end
		end
	end

	for _, panel in pairs(self.crafting_window.panels) do
		for _, category in ipairs(panel:getChildren()) do
			for _, entry in ipairs(category.category:getChildren()) do
				if entry then
					local levelRequired = entry.recipe.level

					entry.level:setOn(not levelRequired or level >= levelRequired.single)
					entry.emblem:setVisible(entry.recipe.index and entry.level:isOn() and not entry.emblem.completed)
				end
			end
		end
	end
end

function GameProfessions:setupTopPanel()
	local topPanel = self.top_panel

	if not topPanel then
		return
	end

	for i = ProfessionFirst, ProfessionLast do
		local professionName = ProfessionNames[i]:lower()
		local professionButton = topPanel:getChildByIndex(cfg.professionToOrder[professionName])

		self.buttons[professionName] = professionButton

		professionButton:setTooltip(professionName:titleCase())

		professionButton.clickSound = true
		professionButton.hoverSound = true

		function professionButton.onClick(widget)
			self:selectPanel(professionName)
		end
	end
end

function GameProfessions:setupPanels()
	local window = self.window

	if not window then
		return
	end

	local content = window.content

	for i = ProfessionFirst, ProfessionLast do
		local professionName = ProfessionNames[i]:lower()
		local panel = content[professionName]

		panel:setVisible(false)

		self.panels[professionName] = panel
		panel.professionId = ProfessionIds[professionName]
		panel.professionName = professionName

		local rightPanel = panel.right_panel

		if not table.find(CraftingProfessions, professionName) then
			rightPanel.bottom_panel.locate_station:destroy()
		else
			rightPanel.bottom_panel.passive_button:setMarginLeft(100)
			rightPanel.bottom_panel.locate_station:setMarginRight(100)
		end

		local text = professionToTitle[professionName:lower()]

		if text then
			panel.right_panel.content.materials_list_header.text:setText(text)
		end

		self:populateLeftPanel(professionName)

		if table.find(CraftingProfessions, professionName) then
			self:populateLeftPanel(professionName, self.crafting_window.panels[professionName], true)
		end
	end
end

function GameProfessions:setupAttachedPanels()
	local window = self.attached_window

	if not window then
		return
	end

	local currentSelectedPanelId = self.currentSelectedPanel and self.currentSelectedPanel:getId() or ""

	for i = ProfessionFirst, ProfessionLast do
		local professionName = ProfessionNames[i]:lower()
		local professionButton = window:getChildById(professionName)

		professionButton:setVisible(currentSelectedPanelId == professionName)

		self.attached_panels[professionName] = professionButton
	end
end

function GameProfessions:populateLeftPanel(name, panel, isCraftingWindow)
	local professionId = ProfessionIds[name]

	panel = panel or self.panels[name].left_panel.content.list

	local _recipes = {
		cfg.recipes[professionId],
		cfg.questRecipes[professionId]
	}

	for _, recipes in pairs(_recipes) do
		if recipes then
			local categories = {}

			if table.find(CraftingProfessions, professionId) then
				table.sort(recipes, function(a, b)
					return a.level.single < b.level.single
				end)
			elseif professionId == ProfessionBreeding then
				table.sort(recipes, function(a, b)
					return a.tier < b.tier
				end)
			else
				table.sort(recipes, function(a, b)
					return a.skillRequired and a.skillRequired < b.skillRequired
				end)
			end

			for _, recipe in ipairs(recipes) do
				local category = recipe.category or "Materials"

				if not categories[category] then
					categories[category] = {}
				end

				table.insert(categories[category], recipe)
			end

			local sortedCategories = {}

			for category, recipes in pairs(categories) do
				table.insert(sortedCategories, {
					category = category,
					recipes = recipes
				})
			end

			table.sort(sortedCategories, function(a, b)
				local _a = categoryIndexes[name] and categoryIndexes[name][a.category:lower()] or a.category
				local _b = categoryIndexes[name] and categoryIndexes[name][b.category:lower()] or b.category

				return tostring(_a) < tostring(_b)
			end)

			local tooltip = cfg.recipes[ProfessionLast + 1]

			for _, data in ipairs(sortedCategories) do
				local category = data.category
				local recipes = data.recipes
				local categoryWidget = g_ui.createWidget("GameProfessionsPanelLeftPanelListCategory", panel)

				categoryWidget.category:setText(tostring(category):titleCase())

				function categoryWidget.category.onVisibilityChange(widget, visible)
					if visible then
						widget:update()
					end
				end

				for index, recipe in ipairs(recipes) do
					local entryWidget = g_ui.createWidget("GameProfessionsPanelLeftPanelListEntry", categoryWidget.category)

					entryWidget:setText(recipe.name:titleCase())

					entryWidget.original_text = entryWidget:getText()
					entryWidget.recipe = recipe
					recipe.level = recipe.level or {}
					recipe.level.single = recipe.level.single or recipe.skillRequired or 1

					if recipe.level then
						entryWidget.level:setText(tr(string.format("%s |%s|", tr("Level"), recipe.level.single)))
					end

					local shrinked = false

					while entryWidget:getTextSize().width > entryWidget:getParent():getWidth() - 120 do
						entryWidget:setText(string.format("%s...", entryWidget:getText():sub(1, -5)))

						shrinked = true
					end

					if shrinked then
						entryWidget:setTooltip(entryWidget.original_text)
					end

					addEvent(function()
						local itemId = recipe.id or recipe.clientId

						if itemId then
							entryWidget.icon:setItemId(recipe.id or recipe.clientId)

							local tmpItem = entryWidget.icon:getItem()

							if not tmpItem then
								return
							end

							tmpItem:setName(recipe.name:titleCase())
							tmpItem:setDescription(recipe.description or "")
							tmpItem:setFormatDescription(recipe.formatDescription or "")
							tmpItem:setQualityName(tostring(category):titleCase())

							local attr = tooltip[recipe.clientId]

							if attr then
								tmpItem:setAttack(attr.attack)
								tmpItem:setDefense(attr.defense)
								tmpItem:setHealing(attr.healing)
								tmpItem:setLabor(attr.labor)
								tmpItem:setItemType(attr.type)
								tmpItem:setTier(attr.tier)
								tmpItem:setDurability(-1)
								tmpItem:setProfession(attr.profession)
								tmpItem:setMinReqLevel(attr.level)
								tmpItem:setMinReqLegacyLevel(attr.legacyLevel)

								tmpItem.isRecipe = true
							end

							if not tmpItem.isRecipe then
								entryWidget.icon:setPhantom(true)
							end
						else
							entryWidget.icon:setVisible(false)

							local tmpOutfit = entryWidget.outfit

							tmpOutfit:setVisible(true)
							tmpOutfit:setOutfit({
								lookType = 3541,
								category = ThingCategoryCreature
							})
						end

						if index == 1 then
							self:selectRecipe(professionId, recipe)

							if table.find(CraftingProfessions, professionId) then
								self:selectRecipe(professionId, recipe, true)
							end
						end
					end)

					entryWidget.clickSound = true

					function entryWidget.onClick(widget)
						self:selectRecipe(professionId, recipe, isCraftingWindow)
					end
				end

				categoryWidget.category:onSetup()
			end
		end
	end
end

function GameProfessions:selectPanel(name, internal)
	if signalcall(self.onSelectPanel, name) then
		return
	end

	if self.currentSelectedPanel then
		self.currentSelectedPanel:setVisible(false)
	end

	if self.currentSelectedAttachedPanel then
		self.currentSelectedAttachedPanel:setVisible(false)
	end

	self.professionId = ProfessionIds[name]
	self.professionName = name

	self.buttons[name]:setOn(true)

	self.currentSelectedPanel = self.panels[name]

	self.currentSelectedPanel:setVisible(true)

	self.currentSelectedAttachedPanel = self.attached_panels[name]

	self.currentSelectedAttachedPanel:setVisible(true)
	self.currentSelectedPanel.left_panel.content.title:setText(name:titleCase())

	if not self.buttons[name].passivesInitialized then
		self:sendOpcode({
			action = "passives",
			profession = self.professionId
		})
	end

	if not internal then
		self:sendOpcode({
			action = "check_quest"
		})
	end

	self:sendOpcode({
		action = "caught_fish"
	})

	if self.currentSelectedPanel.left_panel.content.list:getChildCount() > 0 then
		self:selectRecipe(self.professionId, self.currentSelectedPanel.left_panel.content.list:getFirstChild():getFirstChild():getFirstChild().recipe)
	end

	local panel = self.panels[name].left_panel.content.list

	if table.find(CraftingProfessions, name) then
		for _, category in ipairs(panel:getChildren()) do
			if self.quest then
				local itemsToCraft = self.quest

				for _, entry in ipairs(category.category:getChildren()) do
					if itemsToCraft[entry.recipe.itemId] then
						entry:setVisible(true)
					else
						entry:setVisible(false)
					end
				end

				category:setVisible(category.category:getText() == "Quest")
			else
				for _, entry in ipairs(category.category:getChildren()) do
					entry:setVisible(true)
				end

				category:setVisible(category.category:getText() ~= "Quest")
			end

			category.category:update()
		end
	end

	local contentPanel = self.currentSelectedPanel.left_panel.content
	local widget = contentPanel.panel_search.unlocked

	if widget and widget.checkbox:isChecked() then
		GameProfessions:fitFilters(contentPanel.list, {
			Recipe = {
				Unlocked = true
			}
		})
	end

	self:tryFetchProgressData()
end

function GameProfessions:tryFetchProgressData(professionId)
	professionId = professionId or self.professionId

	if EmblemProfessions[professionId] and not self.requestProgressDataEvents[professionId] then
		self:sendOpcode({
			action = "request_progress_data",
			professionId = professionId
		})
		self:loadingProgressData(professionId)

		self.requestProgressDataEvents[professionId] = scheduleEvent(function()
			self.requestProgressDataEvents[professionId] = nil
		end, 10000)

		return true
	end

	return false
end

function GameProfessions:updateEmblemProgress(widget, completed)
	if widget.animation then
		-- block empty
	end

	local recipe = widget.recipe

	if recipe and recipe.index then
		widget.emblem.completed = completed

		widget.emblem:setVisible(not widget.emblem.completed and widget.level:isOn())
	else
		widget.emblem.completed = nil

		widget.emblem:setVisible(widget.level:isOn())
	end
end

function GameProfessions:iterateCategoryRecipeWidgets(profession, callback)
	profession = type(profession) == "string" and profession or ProfessionNames[profession]:lower()

	local panel = self.panels[profession].left_panel.content.list

	if not panel then
		print("ERROR: iterateCategoryRecipeWidgets - no panel")

		return
	end

	for _, category in ipairs(panel:getChildren()) do
		for _, entry in ipairs(category.category:getChildren()) do
			if callback(entry) then
				break
			end
		end
	end

	panel = self.crafting_window.panels[profession]

	if panel then
		for _, category in ipairs(panel:getChildren()) do
			for _, entry in ipairs(category.category:getChildren()) do
				if entry and callback(entry) then
					break
				end
			end
		end
	end
end

function GameProfessions:updateProgressData(professionId, progressData)
	local ravencrestEmblems = table.fromBitsetString(progressData.ravencrestEmblems) or {}

	self:iterateCategoryRecipeWidgets(professionId, function(entry)
		self:updateEmblemProgress(entry, entry.recipe and entry.recipe.index and ravencrestEmblems[entry.recipe.index] or false)
	end)
end

function GameProfessions:loadingProgressData(professionId)
	local professionName = ProfessionNames[professionId]:lower()
	local panel = self.panels[professionName].left_panel.content.list

	if not panel then
		print("ERROR: loadingProgressData - no panel")

		return
	end
end

function GameProfessions:locateStation()
	local function show(position)
		if not position then
			return
		end

		g_worldMap.iconSettings.showTradepost = true

		g_worldMap.updateIconFilter("showCraftingStation")
		g_worldMap.updateVisibleMarks(true)

		g_worldMap.zoom = 10

		addEvent(function()
			g_worldMap.window:show()
			g_worldMap.window:raise()
			g_worldMap.updateMap()
			g_worldMap.centerOnPosition(position)
			addEvent(function()
				local flag = g_worldMap.getFlag(position, MAPMARK_CRAFTING_STATION)

				if flag then
					g_effects.startBlink(flag, 15000, 500, true)
				end
			end)
		end)
	end

	local player = g_game.getLocalPlayer()
	local pos = player:getPosition()
	local stations = {}

	for profession, data in pairs(CraftingStations) do
		if profession == self.professionId then
			for _, station in pairs(data) do
				table.insert(stations, {
					x = math.floor(station.from.x + (station.to.x - station.from.x) / 2),
					y = math.floor(station.from.y + (station.to.y - station.from.y) / 2),
					z = station.from.z
				})
			end
		end
	end

	if player.houseRooms then
		for houseId, rooms in pairs(player.houseRooms) do
			for roomIndex, roomData in pairs(rooms) do
				if roomData.profession == self.professionId then
					local station = roomData.area

					table.insert(stations, {
						x = station.from.x + (station.to.x - station.from.x) / 2,
						y = station.from.y + (station.to.y - station.from.y) / 2,
						z = station.from.z
					})
				end
			end
		end
	end

	table.sort(stations, function(a, b)
		return Position.distance(pos, a) < Position.distance(pos, b)
	end)
	show(stations[1])
end

function GameProfessions:getWidgetProfession(widget)
	local parent = widget:getParent()

	while parent do
		if parent.professionId then
			return parent.professionId
		end

		parent = parent:getParent()
	end

	return nil
end

function GameProfessions:onPassiveNodeClicked(widget, profession, type, index, level)
	if confirmationBox then
		confirmationBox:destroy()

		confirmationBox = nil
	end

	if type == "specialization" and self.buttons[ProfessionNames[profession]:lower()].specializationPicked or widget:getParent().link:isOn() then
		return
	end

	if level and level > g_game.getLocalPlayer():getProfessionLevel(profession) then
		return
	end

	local function yesCallback()
		self:sendOpcode({
			action = "learn_passive",
			professionId = profession,
			type = passiveNameType[type],
			index = index
		})
		confirmationBox:destroy()

		confirmationBox = nil
	end

	local function noCallback()
		confirmationBox:destroy()

		confirmationBox = nil
	end

	local txt = type == "specialization" and "You can choose only one specialization.\nDo you want to continue?" or "Passive points are allocated permanently.\nDo you want to continue?"

	confirmationBox = displayGeneralBox(tr("Confirm choice"), txt, {
		{
			text = tr("Yes"),
			callback = yesCallback
		},
		{
			text = tr("No"),
			callback = noCallback
		},
		anchor = AnchorHorizontalCenter
	}, yesCallback, noCallback, nil, self.window)
end

function GameProfessions:sendOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.Professions, g_game.serializeTable(data))
	end
end

function GameProfessions:parseOpcode(data)
	if data.action == "passives" then
		local totalPointsSpent = self:populatePassiveTree(data.professionId, data[data.professionId], data.professionLevel, data.points)

		self.buttons[ProfessionNames[data.professionId]:lower()].passivesInitialized = true

		self:updateResetPointsButtonAmount(data.professionId, totalPointsSpent)
	elseif data.action == "caught_fish" then
		self.caughtFishes = data

		for _, panel in pairs(self.panels) do
			if panel.professionId == ProfessionFishing then
				local categories = panel.left_panel.content.list

				for _, category in ipairs(categories:getChildren()) do
					for _, entry in ipairs(category.category:getChildren()) do
						local locked = not table.find(self.caughtFishes, entry.recipe.index)

						entry.icon:setColor(locked and "#010101" or "#FFFFFF")
						entry:setText(locked and "????" or entry.recipe.name:titleCase())

						entry.locked = locked
					end
				end
			end
		end
	end
end

function GameProfessions:resetPassiveTrees()
	for professionId = ProfessionFirst, ProfessionLast do
		local professionName = ProfessionNames[professionId]:lower()
		local tree = self.attached_panels[professionName]

		tree:destroy()

		self.attached_panels[professionName] = nil

		local widget = g_ui.createWidget("GameProfessionTree", self.attached_window)

		widget:setId(professionName)

		widget.professionId = professionId
		widget.professionName = professionName
	end

	self:setupAttachedPanels()
end

function GameProfessions:populatePassiveTree(professionId, data, professionLevel, points)
	local professionName = ProfessionNames[professionId]:lower()
	local tree = self.attached_panels[professionName]
	local oldPoints = tree.points.passivePoints

	tree.points:setText(points)
	signalcall(GameProfessions.onUpdatePassivePoints, professionId, oldPoints, points)

	self.buttons[professionName].specialization = {}

	for _, column in ipairs(tree:getChildren()) do
		for i, node in ipairs(column:getChildren()) do
			if node:getStyleName() == "ProfessionPassive" then
				if node.image then
					node.image:setOn(false)
					node.image:setText(node.level or "")
				end

				if node.link then
					node.link:setOn(false)
				end

				local columnId = column:getId()

				if node.text then
					node.text:setText(string.format("0 / %i", table.find({
						"specialization",
						"unique"
					}, columnId) and 1 or i % 2 == 0 and 1 or 2))
				end

				self.buttons[professionName].specializationPicked = nil
				self.buttons[professionName].specialization[i] = nil
			end
		end
	end

	local totalPointsSpent = 0

	for columnId, columnInfo in ipairs(data) do
		local passiveTypeName = passiveTypeName[columnId]
		local column = tree:getChildById(passiveTypeName)

		for _, node in ipairs(column:getChildren()) do
			if node.level and professionLevel >= node.level then
				node.image:setText("")
			end
		end

		for id, points in pairs(columnInfo) do
			local node = column:recursiveGetChildById(id)

			if node then
				totalPointsSpent = totalPointsSpent + points

				node.image:setOn(true)
				node.text:setText(string.format("%i / %i", points, table.find({
					5,
					6
				}, columnId) and 1 or id % 2 == 0 and 1 or 2))
				node.link:setOn(points == (id % 2 == 0 and 1 or 2))

				if passiveTypeName == "specialization" and node.image:isOn() then
					self.buttons[professionName].specializationPicked = true

					node.image:setText("")
				end

				if node.image:isOn() and (passiveTypeName == "unique" or passiveTypeName == "specialization") then
					local index = node.image:getTooltip():explode("\n\n")[1]

					self.buttons[professionName].specialization[index] = true
				end
			end
		end
	end

	return totalPointsSpent
end

function GameProfessions:getCountAndQualityCount(widget, material)
	local player = g_game.getLocalPlayer()

	if not player then
		return 0
	end

	local amount = 0
	local count = {
		[ItemQualityNormal] = player:getItemsCount(material.clientId, ItemQualityNormal),
		[ItemQualityHigh] = player:getItemsCount(material.clientId, ItemQualityHigh),
		[ItemQualitySuperior] = player:getItemsCount(material.clientId, ItemQualitySuperior),
		[ItemQualityArtisan] = player:getItemsCount(material.clientId, ItemQualityArtisan)
	}
	local quality_panel = widget.quality_panel
	local qualities = {
		[ItemQualityNormal] = true,
		[ItemQualityHigh] = quality_panel.HQ.checkbox:isChecked(),
		[ItemQualitySuperior] = quality_panel.SQ.checkbox:isChecked(),
		[ItemQualityArtisan] = quality_panel.AQ.checkbox:isChecked()
	}

	for index, value in pairs(qualities) do
		amount = (amount or 0) + (value and count[index] or 0)
	end

	return amount, count
end

function GameProfessions:getRecipeByMaterial(professionId, name)
	local recipes = recipes[professionId]

	if recipes and name then
		for _, recipe in pairs(recipes) do
			if recipe.name:lower() == name:lower() then
				return recipe
			end
		end
	end

	return nil
end

function GameProfessions:getRecipeByName(name)
	local tmpRecipes = cfg.craftingRecipesByName[name]

	tmpRecipes = tmpRecipes and recipes[tmpRecipes]

	if tmpRecipes then
		for _, recipe in pairs(tmpRecipes) do
			if recipe.name:lower() == name:lower() then
				return recipe
			end
		end
	end

	return nil
end

function GameProfessions:getExtraMaterialSwing(professionId, itemId)
	local swing = {
		0,
		0
	}

	if itemId == "gem" then
		return swing
	end

	local player = g_game.getLocalPlayer()

	if not player then
		return swing
	end

	local skillLevel = player:getProfessionLevel(professionId)

	if professionId == ProfessionMining then
		if skillLevel >= 10 then
			swing[2] = swing[2] + 1
		end

		if skillLevel >= 21 then
			swing[1] = swing[1] + 1
		end

		if skillLevel >= 31 then
			swing[2] = swing[2] + 1
		end

		if skillLevel >= 41 then
			swing[1] = swing[1] + 1
		end

		if skillLevel >= 51 then
			swing[2] = swing[2] + 1
		end

		if skillLevel >= 61 then
			swing[1] = swing[1] + 1
		end

		if skillLevel >= 71 then
			swing[2] = swing[2] + 1
		end

		if skillLevel >= 81 then
			swing[1] = swing[1] + 1
			swing[2] = swing[2] + 1
		end
	end

	return swing
end

function GameProfessions:fillMaterialWidget(widget, professionId, material)
	local itemid = material.id or material.clientId

	if itemid then
		if type(itemid) == "number" then
			widget.item:setItemId(itemid)
		else
			widget.item:setImageSource(string.format("/images/ui/windows/stats/%s", itemid))
		end

		widget.name:setText((material.name or tostring(material.id)):titleCase())

		if not table.find(CraftingProfessions, professionId) then
			local height = widget.quality_panel:getHeight()

			widget.quality_panel:destroy()
			widget:setMarginBottom(-height)
		end

		if material.count then
			local countSwing = self:getExtraMaterialSwing(professionId, itemid)

			widget.amount:setText(string.format("%s - %s", material.count[1] + countSwing[1], material.count[2] + countSwing[2]))
		end

		local oldRecipe, canInfuse = self:getRecipeByMaterial(professionId, material.name), false

		if oldRecipe and oldRecipe.tier and oldRecipe.tier > 0 then
			canInfuse = true
		end

		local rightPanel = self.panels[ProfessionNames[professionId]:lower()].right_panel
		local panel = rightPanel.content.materials_list

		panel.qualities = {}

		local player = g_game.getLocalPlayer()

		if player and widget.quality_panel then
			if canInfuse then
				local newHeight = widget:getHeight() - widget.quality_panel:getHeight()

				widget:setHeight(newHeight)
				widget.background:setMarginBottom(0)
				widget.quality_panel:setHeight(0)
			end

			local function check()
				if not player then
					return
				end

				local count, qualityCount = self:getCountAndQualityCount(widget, material)

				if material.amount then
					widget.amount:setText(string.format("%i / %i", count, material.amount))
					widget.amount:setOn(count >= material.amount)
				end

				local qualities = {
					[ItemQualityNormal] = true,
					[ItemQualityHigh] = not canInfuse and widget.quality_panel.HQ.checkbox:isChecked(),
					[ItemQualitySuperior] = not canInfuse and widget.quality_panel.SQ.checkbox:isChecked(),
					[ItemQualityArtisan] = not canInfuse and widget.quality_panel.AQ.checkbox:isChecked()
				}

				panel.qualities[material.itemId] = qualities

				for quality, count in pairs(qualityCount or {}) do
					local checkBox = widget.quality_panel[QualityAbbreviations[quality]]

					if checkBox then
						checkBox.text:setText(string.format("%i", count))
					end
				end
			end

			for _, cb in ipairs(widget.quality_panel:getChildren()) do
				function cb.checkbox.onCheckChange()
					check()
				end
			end

			widget.checkFunction = check

			check()
		end
	end
end

function GameProfessions:selectRecipe(professionId, recipe, isCraftingWindow)
	if isCraftingWindow then
		return self:selectCraftingWindowRecipe(professionId, recipe)
	end

	local player = g_game.getLocalPlayer()
	local professionLevel = player and player:getProfessionLevel(professionId)
	local panel = self.panels[ProfessionNames[professionId]:lower()].right_panel.content.top_panel

	self.panels[ProfessionNames[professionId]:lower()].recipe = recipe

	local tooltip = cfg.recipes[ProfessionLast + 1]

	panel.item:setItem(nil)
	panel.item:setItemId(recipe.id or recipe.clientId)

	local tmpItem = panel.item:getItem()

	if tmpItem then
		tmpItem:setName(recipe.name:titleCase())
		tmpItem:setDescription(recipe.description or "")
		tmpItem:setFormatDescription(recipe.formatDescription or "")
		tmpItem:setQualityName(tostring(recipe.category or "Materials"):titleCase())
	else
		panel.item:setVisible(false)

		local tmpOutfit = panel.outfit

		tmpOutfit:setVisible(true)
		tmpOutfit:setOutfit({
			lookType = 3541,
			category = ThingCategoryCreature
		})
	end

	recipe.level = recipe.level or {}
	recipe.level.single = recipe.level.single or recipe.skillRequired or 1

	if recipe.level then
		if recipe.level.single then
			panel.level:show()

			local color = professionLevel and professionLevel >= recipe.level.single and "#36F991" or "#ff5151"

			panel.level:setText(tr(string.format("Level required: |%i|", recipe.level.single)))
			panel.level:setColoredText(GetHighlightedText(tr(string.format("{Level required:, |#a6aab2|} {|%i|, |%s|}", recipe.level.single, color))))
		else
			panel.level:hide()
		end

		if recipe.level.mass then
			panel.mass_level:show()

			local color = professionLevel and professionLevel >= recipe.level.mass and "#36F991" or "#ff5151"

			panel.mass_level:setText(tr(string.format("Mass level required: |%i|", recipe.level.mass)))
			panel.mass_level:setColoredText(GetHighlightedText(tr(string.format("{Mass level required:, |#a6aab2|} {|%i|, |%s|}", recipe.level.mass, color))))
		else
			panel.mass_level:hide()
		end
	end

	local desc = panel.description

	if not recipe.level.mass then
		desc = panel.mass_level
	end

	if recipe.experience then
		desc:setColoredText(GetHighlightedText(string.format("{Experience:, |#a6aab2|} {|%i|xp, |#36F991|}", recipe.experience)))
		desc:setVisible(true)
	end

	if recipe.level.mass then
		if recipe.experience then
			local value = math.ceil(recipe.experience * cfg.costPerExperience)

			panel.tax_value:setText(value)
			panel.tax_value:setTextColor(player and value <= (player.silverBalance or 0) and "#36F991" or "#ff5151")
		end

		panel.tax:setVisible(recipe.experience)
		panel.silver_icon:setVisible(recipe.experience)
		panel.tax_value:setVisible(recipe.experience)
	end

	if recipe.specialization then
		if recipe.experience or recipe.level.mass then
			desc = panel.specialization
		end

		local hasSpec = self.buttons[ProfessionNames[professionId]:lower()].specialization

		hasSpec = hasSpec and hasSpec[recipe.specialization]

		local color = hasSpec and "#36F991" or "#ff5151"

		desc:setText(string.format("Requires: %s", recipe.specialization))
		desc:setColoredText(GetHighlightedText(string.format("{Requires:, #a6aab2} {%s, %s}", recipe.specialization, color)))
		desc:show()
	else
		panel.specialization:hide()
	end

	local locked = professionId == ProfessionFishing and recipe.index and not table.find(self.caughtFishes, recipe.index)

	panel.item:setColor(locked and "#010101" or "#FFFFFF")
	panel.name:setText(locked and "????" or recipe.name:titleCase(), false)
	panel.item:setPhantom(locked)
	panel:centerTextChildren()

	local attr = tooltip[recipe.clientId]

	if tmpItem and attr then
		tmpItem:setAttack(attr.attack)
		tmpItem:setDefense(attr.defense)
		tmpItem:setHealing(attr.healing)
		tmpItem:setLabor(attr.labor)
		tmpItem:setItemType(attr.type)
		tmpItem:setTier(attr.tier)
		tmpItem:setDurability(-1)
		tmpItem:setProfession(attr.profession)
		tmpItem:setMinReqLevel(attr.level)
		tmpItem:setMinReqLegacyLevel(attr.legacyLevel)

		tmpItem.isRecipe = true
	end

	local rightPanel = self.panels[ProfessionNames[professionId]:lower()].right_panel
	local secondaryList = rightPanel.content.secondary_list

	secondaryList:destroyChildren()

	panel = rightPanel.content.materials_list
	panel.qualities = {}

	panel:destroyChildren()

	local header = panel:getParent():getChildById(panel:getId() .. "_header")

	if recipe.growingTime then
		header.time:setText(secondsToHours(recipe.growingTime))
		header:setOn(true)
	end

	local materials = recipe.materials or recipe.items or {}

	for key, material in pairs(materials) do
		if type(key) ~= "string" then
			local widget = g_ui.createWidget("GameProfessionsPanelMiddlePanelMaterialsListItem", panel)

			self:fillMaterialWidget(widget, professionId, material)

			if locked then
				widget.item:setColor("#010101")
				widget.name:setText("????")
				widget.amount:setText("?/?")
			end
		else
			local count = table.size(materials)

			secondaryList:setVisible(count > 1)

			local list = (count == 1 or key == "gathering") and panel or secondaryList

			for _, v in ipairs(material) do
				local widget = g_ui.createWidget("GameProfessionsPanelMiddlePanelMaterialsListItem", list)

				self:fillMaterialWidget(widget, professionId, v)

				local upper = key:gsub("^%l", string.upper)
				local header = list:getParent():getChildById(list:getId() .. "_header")

				header.text:setText(upper)

				if recipe.time then
					header.time:setText(secondsToHours(recipe.time[key]))
					header:setOn(true)
				end
			end
		end
	end

	if professionId == ProfessionBreeding then
		local function getRarityName(value)
			for _, t in ipairs(cfg.chanceNameType) do
				if value >= t[2] then
					return t[1]
				end
			end
		end

		secondaryList:getLayout():setSpacing(1)
		secondaryList:getLayout():setFitChildren(true)
		secondaryList:getParent():getChildById(secondaryList:getId() .. "_header"):hide()
		secondaryList:setVisible(true)

		for _, attributes in pairs(recipe.attributes) do
			for key, attribute in pairs(attributes) do
				local formatted = traitToFormat[key]
				local tmpAttribute = breedingAttributes[key]
				local widget = g_ui.createWidget("GameProfessionsPanelRightPanelBreedingListEntry", secondaryList)

				widget:setText(tmpAttribute.name)
				widget.icon:setImageSource("/images/ui/windows/professions/attributes/" .. tmpAttribute.icon)
				widget.value:setText(type(attribute) == "table" and string.format("%d-%d%s", attribute[1], attribute[2], formatted or "") or string.format("%s%s", attribute, formatted or ""))
			end
		end

		local tertiaryList = rightPanel.content.tertiary_list

		tertiaryList:destroyChildren()
		tertiaryList:setVisible(true)

		for _, outfit in pairs(recipe.outfits) do
			local widget = g_ui.createWidget("GameProfessionsPanelRightPanelBreedingOutfitListEntry", tertiaryList)

			widget:setText(outfit.color:titleCase())
			widget.value:setText(getRarityName(outfit.chance))
			widget.outfit:setOutfit({
				category = ThingCategoryCreature,
				lookType = outfit.looktype
			})
		end
	end

	local left_panel = self.panels[ProfessionNames[professionId]:lower()].left_panel
	local categories = left_panel.content.list

	for _, category in ipairs(categories:getChildren()) do
		for _, entry in ipairs(category.category:getChildren()) do
			local hasIndex = entry.recipe.index

			if hasIndex and entry.recipe.index == recipe.index or not hasIndex and entry.recipe.name == recipe.name then
				entry:setOn(true)
			else
				entry:setOn(false)
			end
		end
	end
end

function GameProfessions.refreshOwnedMaterials()
	local self = GameProfessions

	if self.window:isVisible() then
		local panel = self.currentSelectedPanel.right_panel.content.materials_list

		for _, widget in ipairs(panel:getChildren()) do
			if widget.checkFunction then
				widget.checkFunction()
			end
		end
	end

	if self.crafting_window.window:isVisible() then
		local panel = self.crafting_window.window.info_panel.material_list

		for _, widget in ipairs(panel:getChildren()) do
			if widget.checkFunction then
				widget.checkFunction()
			end
		end

		self:fitFilters()
	end
end

function GameProfessions.onEnterGame()
	local self = GameProfessions

	self:selectPanel(self.currentSelectedPanel.professionName)
end

function GameProfessions.onGameEnd()
	local self = GameProfessions

	self:reset()
end

function GameProfessions:reset()
	for _, button in pairs(self.buttons) do
		button.specializationPicked = false
		button.passivesInitialized = false
	end

	self.quest = false

	self:resetPassiveTrees()
	cancelCrafting(true)

	for _, event in ipairs(self.requestProgressDataEvents) do
		removeEvent(event)
	end

	self.requestProgressDataEvents = {}
end

function GameProfessions.isEnabled()
	return not g_game.isAetherRiftChannel() and not g_game.isGuildWarsChannel()
end

function GameProfessions.toggle(mouseClick)
	if GameChat:isActive() or (type(mouseClick) ~= "boolean" or not mouseClick) and IsTextEditActive() then
		return
	end

	local self = GameProfessions

	if not self.window:isVisible() then
		if g_game:isInCutsceneMode() or not GameProfessions.isEnabled() then
			return
		end

		self:show()
	else
		self:hide()
	end
end

function GameProfessions:show(professionId, recipeName)
	self.window:show()
	self.window:raise()

	local professionName = self.currentSelectedPanel.professionName

	if professionId and ProfessionNames[professionId] then
		professionName = ProfessionNames[professionId]:lower()
	end

	self:selectPanel(professionName, true)
	self:refreshOwnedMaterials()

	if recipeName then
		self:selectRecipe(professionId, recipeName)
	end
end

function GameProfessions:hide()
	self.window:hide()
end

function GameProfessions:setQuest(data)
	self.quest = data and data.itemsIds

	self:selectPanel(self.currentSelectedPanel.professionName, true)
	self:selectCraftingWindowProfession(self.crafting_window.current_selected_profession or ProfessionBlacksmithing)
end

function GameProfessions:passiveSkills()
	if self.window:isVisible() and not self.attached_window:isVisible() then
		self.attached_window:show()
	else
		self.attached_window:hide()
	end
end

function GameProfessions:getProfessionButton(professionId)
	local topPanel = self.top_panel

	if not topPanel then
		return
	end

	return topPanel:getChildByIndex(cfg.professionToOrder[ProfessionNames[professionId]:lower()])
end

function GameProfessions:onSearchEditChange(text)
	local panel = self.currentSelectedPanel.left_panel.content.list
	local search = text:lower()

	for _, category in ipairs(panel:getChildren()) do
		category:setVisible(false)

		for _, entry in ipairs(category.category:getChildren()) do
			local name = entry:getText():lower()
			local found = name:lower():find(search, 1, true)

			if found then
				category:setVisible(self.quest and entry.recipe.category == "quest" or not self.quest and entry.recipe.category ~= "quest")

				local itemsToCraft = self.quest

				if itemsToCraft then
					found = itemsToCraft[entry.recipe.itemId] and true or false
				end
			end

			entry:setVisible(found)

			entry.hidden = not found

			category.category:update()
		end
	end
end

function GameProfessions:onResetPointsClicked(professionId)
	if g_clock.millis() - self.lastResetPointRequest < 1000 then
		return
	end

	self.lastResetPointRequest = g_clock.millis()

	self:sendOpcode({
		action = "reset_passives",
		professionId = professionId
	})
end

function GameProfessions:updateResetPointsButtonAmount(professionId, totalPointsSpent)
	local cost = totalPointsSpent * cfg.resetCost.dawnEssencePerPoint
	local passivesPanel = self.attached_panels[ProfessionNames[professionId]:lower()]
	local resetButton = passivesPanel.reset_points_panel.reset_points_button

	resetButton:setEnabled(cost > 0)
	resetButton:setText(cost)

	resetButton.cost = cost
end

function GameProfessions:updateMenuWidgetsTable(menuWidgetsTable)
	for professionId = ProfessionFirst, ProfessionLast do
		local t = {
			unlockLevel = 1,
			rootIndex = 4,
			name = "professions_" .. professionId,
			remove = GameProfessions.attached_panels[ProfessionNames[professionId]:lower()],
			icons = {
				{
					widget = "professions",
					offset = {
						y = -2,
						x = 4
					}
				},
				{
					widget = GameProfessions:getProfessionButton(professionId),
					offset = {
						y = -2,
						x = 4
					}
				},
				{
					widget = GameProfessions.window.content[ProfessionNames[professionId]:lower()].right_panel.bottom_panel.passive_button,
					offset = {
						y = -2,
						x = 4
					}
				}
			}
		}

		menuWidgetsTable[t.rootIndex].notifications[t.name] = t
	end
end
