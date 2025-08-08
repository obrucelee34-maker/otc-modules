-- chunkname: @/modules/game_profession/crafting_window.lua

function GameProfessions:initializeCraftingWindow()
	local HUDPanel = modules.game_interface.getHUDPanel()

	self.crafting_window.filters = {}
	self.crafting_window.window = g_ui.createWidget("GameProfessionsCraftingWindow", HUDPanel)

	self.crafting_window.window:hide()

	self.crafting_window.current_sort_button = self.crafting_window.window.search_panel.level
	self.crafting_window.current_sort_type = self.crafting_window.current_sort_button:getId()
	self.crafting_window.current_sort_direction = "asc"

	for i = ProfessionFirst, ProfessionLast do
		if table.find(CraftingProfessions, i) then
			self.crafting_window.panels[ProfessionNames[i]:lower()] = g_ui.createWidget("GameProfessionsCraftingWindowRecipeList", self.crafting_window.window)

			local panel = self.crafting_window.panels[ProfessionNames[i]:lower()]

			panel:addAnchor(AnchorBottom, "info_panel", AnchorTop)

			panel.professionId = i

			local scrollBar = g_ui.createWidget("GameProfessionsPanelLeftPanelListScrollBar", self.crafting_window.window)

			addEvent(function()
				panel:setVerticalScrollBar(scrollBar)
			end)
			panel:hide()
		end
	end

	connect(g_game, {
		onOpenNpcWindow = GameProfessions.onOpenNpcWindow,
		onCloseNpcWindow = GameProfessions.onCloseNpcWindow
	})
	connect(self, {
		onCraftEnd = GameProfessions.onCraftEnd
	})
end

function GameProfessions:terminateCraftingWindow()
	self.crafting_window.window:destroy()

	self.crafting_window.window = nil

	disconnect(g_game, {
		onOpenNpcWindow = GameProfessions.onOpenNpcWindow,
		onCloseNpcWindow = GameProfessions.onCloseNpcWindow
	})
	disconnect(LocalPlayer, {
		onPositionChange = GameProfessions.onLocalPlayerPositionChange
	})
	disconnect(self, {
		onCraftEnd = GameProfessions.onCraftEnd
	})
end

function GameProfessions:onCraftEnd()
	self = GameProfessions

	if not self.crafting_window.window:isVisible() then
		return
	end

	self:sendOpcode({
		action = "oversupply",
		amount = self.crafting_window.amountToCraft,
		experience = self.crafting_window.recipe.experience
	})
end

function GameProfessions:selectCraftingWindowProfession(professionId)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	self.crafting_window.selected_panel = self.crafting_window.panels[ProfessionNames[professionId]:lower()]
	self.crafting_window.current_selected_profession = professionId

	if self.crafting_window.selected_profession ~= professionId then
		self.crafting_window.selected_profession = professionId

		self:selectFirstCraftingWindowRecipe()
	end

	self:updateCraftingWindowLevel()

	local professionLevel = player:getProfessionLevel(professionId)

	for _, panel in pairs(self.crafting_window.panels) do
		panel:setVisible(panel == self.crafting_window.selected_panel)

		if panel == self.crafting_window.selected_panel then
			for _, category in ipairs(panel:getChildren()) do
				if self.quest then
					category:setVisible(category.category:getText() == "Quest")

					local itemsToCraft = self.quest

					if category.category:getText() == "Quest" then
						for _, entry in ipairs(category.category:getChildren()) do
							if itemsToCraft[entry.recipe.itemId] then
								entry.level:setOn(professionLevel >= entry.recipe.level.single)
								entry:setVisible(true)
							else
								entry:setVisible(false)
							end
						end
					end
				else
					category:setVisible(category.category:getText() ~= "Quest")

					if category:isVisible() then
						for _, entry in ipairs(category.category:getChildren()) do
							entry.level:setOn(professionLevel >= entry.recipe.level.single)
							entry:setVisible(true)
						end
					end
				end

				category.category:update()
			end
		end
	end

	self.crafting_window.window.top_panel.title:setText(string.format("%s Station", ProfessionNames[professionId]))
	self.crafting_window.window.top_panel.icon:setImageSource("/images/ui/windows/professions/icons/" .. ProfessionNames[professionId]:lower())
	self:fitFilters()
end

function GameProfessions:hasRecipeMaterials(player, recipe)
	local materials = recipe.materials or recipe.items

	for _, material in ipairs(materials) do
		if (player:getItemsCount(material.clientId) or 0) < material.amount then
			return false
		end
	end

	return true
end

function GameProfessions:selectCraftingWindowRecipe(professionId, recipe, internal)
	local panel = self.crafting_window.window.info_panel

	self.crafting_window.recipe = recipe

	if not internal then
		self:updateCraftingWindowAmountToCraft(1)
	end

	local tooltip = cfg.recipes[ProfessionLast + 1]

	panel.item_info.item:setItem(nil)
	panel.item_info.item:setItemId(recipe.id or recipe.clientId)
	panel.item_info.item.amount:setText(string.format("x%d", recipe.amount or 1))

	local tmpItem = panel.item_info.item:getItem()

	tmpItem:setName(recipe.name:titleCase())
	tmpItem:setDescription(recipe.description or "")
	tmpItem:setFormatDescription(recipe.formatDescription or "")
	tmpItem:setQualityName(tostring(recipe.category or "Materials"):titleCase())

	if recipe.level then
		if recipe.level.single then
			panel.item_info.level_single:show()
			panel.item_info.level_single:setText(recipe.level.single)
		else
			panel.item_info.level_single:hide()
		end

		if recipe.level.mass then
			panel.item_info.level_mass:show()
			panel.item_info.level_mass:setText(recipe.level.mass)
		else
			panel.item_info.level_mass:hide()
		end
	end

	if recipe.specialization then
		local hasSpec = self.buttons[ProfessionNames[professionId]:lower()].specialization

		hasSpec = hasSpec and hasSpec[recipe.specialization]

		local color = hasSpec and "#36F991" or "#ff5151"

		panel.item_info.specialization:setText(string.format("Requires: %s", recipe.specialization))
		panel.item_info.specialization:setColoredText(GetHighlightedText(string.format("{Requires:, #a6aab2} {%s, %s}", recipe.specialization, color)))
		panel.item_info.specialization:show()
	else
		panel.item_info.specialization:hide()
	end

	panel.item_info.name:setText(recipe.name:titleCase(), false)
	GameProfessions:updateCraftingWindowRecipeTaxValue()

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

	panel = panel.material_list
	panel.qualities = {}

	if not internal then
		panel:destroyChildren()
	end

	local materials = recipe.materials or recipe.items
	local player = g_game.getLocalPlayer()

	for _, material in ipairs(materials) do
		local itemid = material.id or material.clientId
		local widget = panel:getChildById(itemid) or g_ui.createWidget("GameProfessionsPanelMiddlePanelMaterialsListItem", panel)

		if itemid then
			widget:setId(itemid)

			if type(itemid) == "number" then
				widget.item:setItemId(itemid)
				widget.item:setPhantom(false)
				widget.item:setTooltip(false)

				function widget.item.onClick()
					local recipe = self:getRecipeByName(material.name)

					if not recipe then
						return
					end

					if recipe.profession == professionId then
						self:selectCraftingWindowRecipe(professionId, recipe, internal)
					else
						self:show(recipe.profession, recipe)
					end
				end
			else
				widget.item:setImageSource(string.format("/images/ui/windows/stats/%s", itemid))
			end

			widget.name:setText((material.name or tostring(material.id)):titleCase())

			if material.count then
				widget.amount:setText(string.format("%s - %s", material.count[1], material.count[2]))
			end

			local oldRecipe, canInfuse = self:getRecipeByMaterial(professionId, material.name), false

			if oldRecipe and oldRecipe.tier and oldRecipe.tier > 0 then
				canInfuse = true
			end

			local amountToCraft = math.max(1, self.crafting_window.amountToCraft)

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
						widget.amount:setText(string.format("%i / %i", count, material.amount * amountToCraft))
						widget.amount:setOn(count >= material.amount)
					end

					local qualities = {
						[ItemQualityNormal] = true,
						[ItemQualityHigh] = not canInfuse and widget.quality_panel.HQ.checkbox:isChecked(),
						[ItemQualitySuperior] = not canInfuse and widget.quality_panel.SQ.checkbox:isChecked(),
						[ItemQualityArtisan] = not canInfuse and widget.quality_panel.AQ.checkbox:isChecked()
					}

					panel.qualities[material.itemId] = qualities

					if qualityCount then
						for quality, count in pairs(qualityCount) do
							local checkBox = widget.quality_panel[QualityAbbreviations[quality]]

							if checkBox then
								checkBox.text:setText(string.format("%i", count))
							end
						end
					end

					local craftButton = self.crafting_window.window.button_panel.craft_button
					local isInCraftingArea = player:isInCraftingArea(professionId)
					local hasMaterials = count >= material.amount
					local hasProfessionLevel = player:getProfessionLevel(professionId) >= recipe.level.single

					craftButton:setEnabled(isInCraftingArea and hasMaterials and hasProfessionLevel)

					hasProfessionLevel = recipe.level.mass and player:getProfessionLevel(professionId) >= recipe.level.mass
					hasMaterials = count >= material.amount * amountToCraft

					self:setCraftingWindowMassCraftEnabled(hasProfessionLevel)

					for _, material in ipairs(materials) do
						local widget = panel:getChildById(material.id or material.clientId)

						if widget then
							local count, qualityCount = self:getCountAndQualityCount(widget, material)

							if count < material.amount * amountToCraft then
								self:updateCraftingWindowAmountToCraft(math.floor(count / material.amount))
								craftButton:setEnabled(math.floor(count / material.amount) > 0)

								return
							end
						end
					end

					function craftButton.onClick()
						sendCraftRequest(recipe.profession, recipe.index, panel.qualities, amountToCraft, recipe.category == "quest")
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

	local list_panel = self.crafting_window.panels[ProfessionNames[professionId]:lower()]

	for _, category in ipairs(list_panel:getChildren()) do
		for _, entry in ipairs(category.category:getChildren()) do
			if entry.recipe.index and entry.recipe.index == recipe.index then
				entry:setOn(true)
			else
				entry:setOn(false)
			end
		end
	end

	signalcall(self.onCraftingWindowRecipeChange, recipe)
end

function GameProfessions:updateCraftingWindowRecipeTaxValue()
	local recipe = self.crafting_window.recipe

	if not recipe then
		return
	end

	local panel = self.crafting_window.window.info_panel

	if not panel then
		return
	end

	local amountToCraft = math.max(1, self.crafting_window.amountToCraft)

	panel.item_info.experience:setText((recipe.experience or 0) * amountToCraft)

	local taxValue = math.ceil((recipe.experience or 0) * cfg.costPerExperience * amountToCraft)

	panel.item_info.tax_value:setText(taxValue)

	panel.item_info.tax_value.originalValue = taxValue

	local oversuppy_panel = self.crafting_window.window.info_panel.oversupply_panel
	local oversupply = oversuppy_panel.oversupply

	if oversupply then
		local experience = (recipe.experience or 0) * amountToCraft

		taxValue = oversupply.totalSilver or math.ceil(taxValue + oversupply.taxIncrease * experience / 100)

		panel.item_info.tax_value:setText(taxValue)
	end
end

function GameProfessions:requestOpenCraftingWindow(professionId)
	self:sendOpcode({
		action = "request_open_window",
		professionId = professionId
	})
end

function GameProfessions:showCraftingWindow(professionId)
	if not professionId then
		return
	end

	if signalcall(self.onBeforeOpenCraftingWindow) then
		return
	end

	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	if self.crafting_window.was_visible_before_npc or self.crafting_window.window:isVisible() or not player:isInCraftingArea(professionId) then
		return
	end

	self.crafting_window.window:expand(nil, function()
		self.crafting_window.window:show()
		self.crafting_window.window:raise()
		self.crafting_window.window:focus()
		self:selectCraftingWindowProfession(professionId)
		self:sortCraftingWindow(self.crafting_window.current_sort_button, self.crafting_window.current_sort_type, self.crafting_window.current_sort_direction)
		self:onCraftingWindowSearchEditChange("")
		self:selectFirstCraftingWindowRecipe()
	end)

	local openWindowSound = cfg.professionIdToSound[professionId]

	if openWindowSound then
		g_sound.play(openWindowSound)
	end

	connect(LocalPlayer, {
		onPositionChange = GameProfessions.onLocalPlayerPositionChange
	})
	signalcall(self.onOpenCraftingWindow)
	self:refreshOwnedMaterials()
	self:tryFetchProgressData(professionId)
end

function GameProfessions:hideCraftingWindow()
	if self.crafting_window.window:isVisible() then
		self.crafting_window.window:collapse(nil, function()
			signalcall(self.onCloseCraftingWindow)
		end)
	end

	disconnect(LocalPlayer, {
		onPositionChange = GameProfessions.onLocalPlayerPositionChange
	})
	self.crafting_window.window.search_panel.search_panel:setText("")
end

function GameProfessions.onOpenNpcWindow()
	local self = GameProfessions

	if self.crafting_window.window:isVisible() then
		self.crafting_window.was_visible_before_npc = true

		self.crafting_window.window:hide()
	end
end

function GameProfessions.onCloseNpcWindow()
	local self = GameProfessions

	if self.crafting_window.was_visible_before_npc then
		self.crafting_window.was_visible_before_npc = false

		self.crafting_window.window:expand(nil, function()
			self.crafting_window.window:show()
			self.crafting_window.window:raise()
			self.crafting_window.window:focus()
		end)
	end
end

function GameProfessions.onLocalPlayerPositionChange(player, position)
	local self = GameProfessions

	if not self.crafting_window.window:isVisible() then
		return
	end

	if not player:isInCraftingArea(self.crafting_window.selected_profession) then
		self:hideCraftingWindow()
	end
end

function GameProfessions:updateCraftingWindowLevel()
	local panel = self.crafting_window.selected_panel
	local top_panel = self.crafting_window.window.top_panel

	top_panel.level.level_progress:setPercent(panel.level_progress or 0)
	top_panel.level_rect:setText(panel.level or 0)
end

function GameProfessions:onCraftingWindowSearchEditChange(text)
	local panel = self.crafting_window.selected_panel
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

function GameProfessions:onCraftWindowFilterPanelClick(widget, state)
	if self.crafting_window.popupMenu then
		self.crafting_window.popupMenu:destroy()

		self.crafting_window.popupMenu = nil
	end

	self.crafting_window.popupMenu = g_ui.createWidget("FilterPopupMenu")

	self.crafting_window.popupMenu:setWidth(widget:getWidth())

	self.crafting_window.popupMenu.lastWidth = widget:getWidth()

	local disconnects = {}

	table.insert(disconnects, connect(self.crafting_window.window.search_panel, {
		onVisibilityChange = function(widget, visible)
			if not visible and self.crafting_window.popupMenu then
				self.crafting_window.popupMenu:destroy()

				self.crafting_window.popupMenu = nil
			end
		end
	}))
	table.insert(disconnects, connect(g_ui.getRootWidget(), {
		onMousePress = function(widget, mousePos)
			if not self.crafting_window.popupMenu then
				return
			end

			if not self.crafting_window.popupMenu:containsPoint(mousePos) then
				if self.crafting_window.popupMenu.menu then
					if not self.crafting_window.popupMenu.popup:containsPoint(mousePos) then
						self.crafting_window.popupMenu.popup:destroy()

						self.crafting_window.popupMenu.popup = nil
					end

					return
				end

				self.crafting_window.popupMenu:destroy()

				self.crafting_window.popupMenu = nil
			end
		end
	}))
	connect(self.crafting_window.popupMenu, {
		onDestroy = function()
			widget:setOn(false)

			if self.crafting_window.popupMenu.popup then
				self.crafting_window.popupMenu.popup:destroy()

				self.crafting_window.popupMenu.popup = nil
			end

			for _, widgets in ipairs(disconnects) do
				for _, disconnect in ipairs(widgets) do
					disconnect()
				end
			end
		end
	})

	for _, filter in ipairs(cfg.craftingFiltersOrder) do
		self.crafting_window.popupMenu:addOption(filter, function(option)
			if self.crafting_window.popupMenu.currentSelectedOption then
				self.crafting_window.popupMenu.currentSelectedOption:setOn(false)
			end

			option:setOn(true)

			self.crafting_window.popupMenu.currentSelectedOption = option

			GameProfessions:createExpandedFilterPopup(self.crafting_window.popupMenu, option, filter)
		end, nil, true)
		self.crafting_window.popupMenu:addSeparator()
	end

	g_ui.createWidget("CraftingFilterPopupMenuClearAll", self.crafting_window.popupMenu)

	local displayPos = widget:getPosition()

	displayPos.y = displayPos.y + widget:getHeight() + 4

	self.crafting_window.popupMenu:setFocusable(false)
	self.crafting_window.popupMenu:display(displayPos, true, self.crafting_window.window)
	self.crafting_window.popupMenu.clear_button:setEnabled(not table.empty(self.crafting_window.filters))

	for _, filter in ipairs(cfg.craftingFiltersOrder) do
		local filters = self.crafting_window.filters[filter]

		if filters then
			local option = self.crafting_window.popupMenu:getChildById(filter:lower())

			for filterName in pairs(filters) do
				local label = g_ui.createWidget("FilterPopupMenuSubItem", option.content)

				label:setText(string.format("    %s", filterName))
				label:setId(filterName)

				option.content.filters = option.content.filters or {}
				option.content.filters[filterName] = true
			end

			local height = 30

			for _, child in ipairs(option.content:getChildren()) do
				height = height + child:getHeight()
			end

			option:setHeight(height)
		end
	end
end

function GameProfessions:clearAllFilters()
	self.crafting_window.filters = {}

	if not self.crafting_window.popupMenu then
		return
	end

	self.crafting_window.popupMenu.clear_button:setEnabled(false)

	for _, child in ipairs(self.crafting_window.popupMenu:getChildren()) do
		if child.content then
			child.content.filters = nil

			child.content:destroyChildren()
			child:setHeight(30)
		end
	end

	self:fitFilters()
end

function GameProfessions:createExpandedFilterPopup(menu, parentOption, filterName)
	local options = cfg.craftingFilters[filterName]

	if not options then
		return
	end

	menu.popup = g_ui.createWidget("FilterPopupMenu")

	for _, optionName in ipairs(options) do
		local option = menu.popup:addOption(optionName, function()
			return
		end, nil, true, "CraftinFilterPopupMenuButtonExpanded")

		option.config = {
			name = optionName,
			index = _
		}

		self:loadFilterStates(string.titleCase(parentOption:getId(), true), option)
	end

	connect(menu.popup, {
		onDestroy = function()
			parentOption:setOn(false)
		end
	})

	local displayPos = menu:getPosition()

	displayPos.x = displayPos.x + menu.popup:getWidth() + 5
	displayPos.y = parentOption:getY()

	menu.popup:setFocusable(false)
	menu.popup:display(displayPos, true, self.crafting_window.window)
end

function GameProfessions:onFilterPanelCheckboxChange(widget, state)
	local categoryFilter = self.crafting_window.popupMenu

	if not categoryFilter then
		return
	end

	local filters = categoryFilter.popup

	if not filters then
		return
	end

	local selectedCategory = categoryFilter.currentSelectedOption

	if not selectedCategory then
		return
	end

	local changedCategory = string.titleCase(selectedCategory:getId(), true)
	local changedFilter = string.titleCase(widget:getParent():getId(), true)
	local filterConfig = widget:getParent().config

	self.crafting_window.filters[changedCategory] = self.crafting_window.filters[changedCategory] or {}
	self.crafting_window.filters[changedCategory][changedFilter] = state and true or nil

	if state and not selectedCategory.content.filters or not selectedCategory.content.filters[changedFilter] then
		local label = g_ui.createWidget("FilterPopupMenuSubItem", selectedCategory.content)

		label:setText(string.format("    %s", tr(filterConfig.name)))
		label:setId(changedFilter)

		selectedCategory.content.filters = selectedCategory.content.filters or {}
		selectedCategory.content.filters[changedFilter] = true

		selectedCategory.content:moveChildToIndex(label, math.min(filterConfig.index, selectedCategory.content:getChildCount()))
	elseif not state then
		local label = selectedCategory.content:getChildById(changedFilter)

		if label then
			label:destroy()

			selectedCategory.content.filters[changedFilter] = nil
		end
	end

	local height = 30

	for _, child in ipairs(selectedCategory.content:getChildren()) do
		height = height + child:getHeight()
	end

	selectedCategory:setHeight(height)

	if table.empty(self.crafting_window.filters[changedCategory]) then
		self.crafting_window.filters[changedCategory] = nil
	end

	categoryFilter.clear_button:setEnabled(not table.empty(self.crafting_window.filters))
	self:fitFilters()
end

function GameProfessions:loadFilterStates(parentCategory, optionWidget)
	local filters = self.crafting_window.filters[parentCategory]

	if not filters then
		return
	end

	local filterName = string.titleCase(optionWidget:getId(), true)

	if filters[filterName] then
		optionWidget.checkbox:setChecked(true, true)
	end
end

function GameProfessions:applyFilter(recipe, filters)
	local player = g_game.getLocalPlayer()

	for _, filter in ipairs(cfg.craftingFiltersOrder) do
		local filters = filters and filters[filter] or self.crafting_window.filters[filter]

		if filters then
			local successFilter = 0

			for filterName in pairs(filters) do
				local callback = cfg.craftingFiltersCallback[filter][filterName]

				if callback(player, recipe) then
					successFilter = successFilter + 1
				end
			end

			if successFilter == 0 then
				return false
			end
		end
	end

	return true
end

function GameProfessions:fitFilters(panel, customFilters)
	local panel = panel or self.crafting_window.selected_panel

	if not panel then
		return
	end

	for _, category in ipairs(panel:getChildren()) do
		local professionLevel
		local atLeastOneUnlocked = false

		if self.quest then
			category:setVisible(category.category:getText() == "Quest")

			for _, entry in ipairs(category.category:getChildren()) do
				local itemsToCraft = self.quest

				if category.category:getText() == "Quest" and itemsToCraft[entry.recipe.itemId] then
					professionLevel = professionLevel or g_game.getLocalPlayer():getProfessionLevel(entry.recipe.profession)
					entry.locked = not self:applyFilter(entry.recipe, customFilters)
					atLeastOneUnlocked = atLeastOneUnlocked or not entry.locked
				end
			end
		else
			for _, entry in ipairs(category.category:getChildren()) do
				professionLevel = professionLevel or g_game.getLocalPlayer():getProfessionLevel(entry.recipe.profession)
				entry.locked = not self:applyFilter(entry.recipe, customFilters)
				atLeastOneUnlocked = atLeastOneUnlocked or not entry.locked
			end

			category:setVisible(category.category:getText() ~= "Quest" and atLeastOneUnlocked)
		end

		category.category:update()
	end
end

function GameProfessions.onCraftingProfessionChange(player, professionId, level, percent, oldLevel, oldPercent, exp, reqExp)
	local self = GameProfessions
	local panel = self.crafting_window.selected_panel

	if not panel or not panel:isVisible() then
		return
	end

	if level ~= oldLevel then
		self:fitFilters()
	end
end

function GameProfessions:sortCraftingWindow(widget, sortType, sortDirection)
	local panel = self.crafting_window.selected_panel
	local categories = panel:getChildren()

	widget.sortDirection = sortDirection == "asc" and "desc" or "asc"

	for _, category in ipairs(categories) do
		local entries = category.category:getChildren()

		table.sort(entries, function(a, b)
			if sortType == "name" then
				return a:getText():lower() < b:getText():lower()
			elseif sortType == "level" then
				return a.recipe.level.single < b.recipe.level.single
			end

			return false
		end)

		if sortDirection == "desc" then
			entries = table.reverse(entries)
		end

		category.category:reorderChildren(entries)
		category.category:update()
	end

	if self.crafting_window.current_sort_button then
		self.crafting_window.current_sort_button:setChecked(false)
	end

	self.crafting_window.current_sort_button = widget

	self.crafting_window.current_sort_button:setOn(sortDirection == "asc")
	self.crafting_window.current_sort_button:setChecked(true)

	self.crafting_window.current_sort_type = sortType
	self.crafting_window.current_sort_direction = sortDirection
end

function GameProfessions:updateCraftingWindowOversupply(data)
	local panel = self.crafting_window.window.info_panel.oversupply_panel

	panel:setVisible(data.taxIncrease > 0 or data.threshold > data.baseValue)

	local percent = panel.oversupply_percent
	local bar = panel.progress_fill

	percent:setText(string.format("+ %.1f%%", data.taxIncrease))

	local clip = {
		y = 0,
		x = 0,
		width = math.min(bar:getWidth() - bar:getMarginLeft(), data.percent * bar:getWidth() / 100),
		height = bar:getHeight()
	}

	bar:setImageClip(clip)
	bar:setImageSize({
		width = clip.width,
		height = clip.height
	})
	bar:setTooltip(string.format("%i / %i", data.threshold, data.baseValue))

	panel.oversupply = data

	GameProfessions:updateCraftingWindowRecipeTaxValue()

	local infoIcon = panel.info_icon

	infoIcon:setColoredTooltip(GetHighlightedText(string.format(infoIcon.tooltipFormat, data.baseValue + data.baseValue * 0.1, data.taxIncrease, data.hourlyDecrease, data.baseValue, data.taxIncrease + cfg.costPerExperience * 100, cfg.costPerExperience * 100, data.taxIncrease)), "#CED2D9")
end

function GameProfessions:setCraftingWindowMassCraftEnabled(state)
	local panel = self.crafting_window.window.mass_craft_panel

	if state then
		panel.locked:hide()
		panel.slider_panel:show()
	else
		panel.locked:show()
		panel.slider_panel:hide()

		if not self.crafting_window.recipe then
			return
		end

		local requiredLevel = self.crafting_window.recipe.level.mass

		if not requiredLevel then
			panel.locked.text:setText(string.format("Mass Craft is not available for this recipe"))
		else
			panel.locked.text:setText(tr(string.format("Mass Craft unlocks at level |%i|", requiredLevel)))
		end
	end

	panel.state = state
end

function GameProfessions:updateCraftingWindowAmountToCraft(amount)
	if not self.crafting_window.selected_panel then
		return
	end

	local panel = self.crafting_window.window.mass_craft_panel.slider_panel
	local slider = panel.count_slider

	if amount == 0 then
		slider:setValue(1)

		return
	end

	local professionLevel = self.crafting_window.selected_panel.level
	local massCraftLevel = self.crafting_window.recipe.level.mass or 0
	local maximumAmount = math.min(50, 5 + math.max(0, math.floor(professionLevel - massCraftLevel) * 3))

	slider:setMaximum(maximumAmount)
	slider:setMinimum(1)
	slider:setValue(amount)

	self.crafting_window.amountToCraft = amount

	panel.max_text:setText(string.format("Max: [%i]", maximumAmount))
	self:selectCraftingWindowRecipe(self.crafting_window.current_selected_profession, self.crafting_window.recipe, true)

	if self.crafting_window.oversupplyUpdateEvent then
		removeEvent(self.crafting_window.oversupplyUpdateEvent)

		self.crafting_window.oversupplyUpdateEvent = nil
	end

	self.crafting_window.oversupplyUpdateEvent = scheduleEvent(function()
		self:sendOpcode({
			action = "oversupply",
			amount = self.crafting_window.amountToCraft,
			experience = self.crafting_window.recipe.experience
		})

		self.crafting_window.oversupplyUpdateEvent = nil
	end, 100)
end

function GameProfessions:selectFirstCraftingWindowRecipe()
	local panel = self.crafting_window.selected_panel

	if not panel then
		return
	end

	local firstEntry

	for _, category in ipairs(panel:getChildren()) do
		firstEntry = firstEntry or category.category:getFirstChild()

		for _, entry in ipairs(category.category:getChildren()) do
			if self.quest and entry.recipe.category ~= "quest" then
				break
			end

			if not entry.hidden then
				entry:onClick()

				return
			end
		end
	end

	if firstEntry then
		firstEntry:onClick()
	end
end
