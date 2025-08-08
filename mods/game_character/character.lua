-- chunkname: @/modules/game_character/character.lua

GameCharacter = {
	pointsAvailable = -1,
	pointsAllocated = 0,
	currentTab = {},
	attributes = {
		intelligence = 0,
		might = 0,
		wisdom = 0,
		dexterity = 0
	}
}

function GameCharacter:loadConfig()
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

function GameCharacter:init()
	g_ui.importStyle("styles/customization")
	g_ui.importStyle("styles/equipment")
	g_ui.importStyle("styles/stats")
	g_ui.importStyle("styles/main")
	g_ui.importStyle("styles/effects")
	self:loadConfig()

	local HUDPanel = modules.game_interface.getHUDPanel()

	self.window = g_ui.createWidget("GameCharacterWindow", HUDPanel)

	self.window:hide()
	connect(self.window, {
		onVisibilityChange = function(widget, visible)
			if not self.window then
				return
			end

			if visible then
				self:enableAllTabs()
			elseif self.pointsAvailable > 0 then
				self:showStatsUnassignedPrompt()
			else
				self:hideStatsUnassignedPrompt()
			end
		end
	})

	self.expandedOutfitWindow = g_ui.createWidget("GameCharacterCustomizationPanelOutfits", HUDPanel)

	self.expandedOutfitWindow:setAttachedTo(self.window)
	self.expandedOutfitWindow:setVisible(false)
	connect(self.window.content.customization_panel, {
		onVisibilityChange = function(widget, visible)
			if not visible then
				self.expandedOutfitWindow:hide()
			end
		end
	})
	connect(self.expandedOutfitWindow, {
		onVisibilityChange = function(widget, visible)
			if visible then
				self.expandedEffectWindow:hide()
			end
		end
	})

	self.expandedEffectWindow = g_ui.createWidget("GameCharacterCustomizationPanelEffects", HUDPanel)

	self.expandedEffectWindow:setAttachedTo(self.window)
	self.expandedEffectWindow:setVisible(false)
	connect(self.window.content.customization_panel, {
		onVisibilityChange = function(widget, visible)
			if not visible then
				self.expandedEffectWindow:hide()
			end
		end
	})
	connect(self.expandedEffectWindow, {
		onVisibilityChange = function(widget, visible)
			if visible then
				self.expandedOutfitWindow:hide()
			end
		end
	})

	self.colorSelectionPanel = self.window:recursiveGetChildById("color_selection_panel")
	self.colorSelectionRadioGroup = UIRadioGroup.create()

	for _, child in ipairs(self.colorSelectionPanel:getChildren()) do
		self.colorSelectionRadioGroup:addWidget(child)
		connect(child, {
			onCheckChange = function(widget, checked)
				child.radio:setChecked(checked)

				self.selectedColorGroup = tonumber(widget:getId())
			end
		})
	end

	self.colorSelectionRadioGroup:selectWidget(self.colorSelectionPanel:getFirstChild())

	self.colorBoxHolder = self.window:recursiveGetChildById("color_box_holder")
	self.colorBoxHolder.orderedWidgets = {}

	for i = 0, 6 do
		for j = 0, 18 do
			local colorCode = i * 19 + j
			local color = getOutfitColor(colorCode)
			local colorBox = g_ui.createWidget("GameCharacterCustomizationPanelColorBox", self.colorBoxHolder)

			colorBox:setBackgroundColor(color)

			colorBox.colorCode = colorCode
			colorBox.color = color

			connect(colorBox, {
				onMousePress = function(widget, mousePos, mouseButton)
					if mouseButton == MouseLeftButton then
						self:updateColorSelection(colorBox)
					end
				end
			})
			table.insert(self.colorBoxHolder.orderedWidgets, colorBox)
		end
	end

	self.colorBoxHolder:centerInParent()
	connect(self.colorBoxHolder, {
		onGeometryChange = function(widget)
			widget:centerInParent()
			widget:reorderChildren(widget.orderedWidgets)
		end
	})
	connect(Creature, {
		onTitleChange = GameCharacter.onTitleChange
	})
	connect(LocalPlayer, {
		onArchetypeLevelChange = GameCharacter.onArchetypeLevelChange,
		onArchetypeActiveChange = GameCharacter.onArchetypeActiveChange,
		onInventoryChange = GameCharacter.onInventoryChange,
		onOutfitChange = GameCharacter.onOutfitChange,
		onStatsChange = GameCharacter.onStatsChange,
		onAttackSpeedChange = GameCharacter.onAttackSpeedChange,
		onBaseAttackSpeedChange = GameCharacter.onBaseAttackSpeedChange,
		onEffectiveChannelTimeChange = GameCharacter.onEffectiveChannelTimeChange,
		onEffectiveGlobalCooldownChange = GameCharacter.onEffectiveGlobalCooldownChange,
		onCriticalDamageChange = GameCharacter.onCriticalDamageChange,
		onCriticalChanceChange = GameCharacter.onCriticalChanceChange,
		onEffectiveLevelChange = GameCharacter.onEffectiveLevelChange
	})
	connect(g_game, {
		onGameStart = GameCharacter.onGameStart,
		onGameEnd = GameCharacter.onGameEnd,
		onInfamyChange = GameCharacter.onInfamyChange
	})

	self.customizationTab = self.window:recursiveGetChildById("customization")

	if g_game.isInShip() then
		self.customizationTab:setEnabled(false)
	end

	self:selectTab("equipment")

	if g_game.isOnline() then
		GameCharacter.onGameStart()
		self:sendTitleOpcode({
			action = "titles"
		})
	end

	ProtocolGame.registerExtendedOpcode(ExtendedIds.LevelAttributes, GameCharacter.onLevelAttributesExtendedOpcode)
	ProtocolGame.registerExtendedOpcode(ExtendedIds.OutfitManagement, GameCharacter.onOutfitManagementExtendedOpcode, "game_character")
	ProtocolGame.registerExtendedOpcode(ExtendedIds.Titles, GameCharacter.onTitlesExtendedOpcode)
end

function GameCharacter:terminate()
	self.window:destroy()

	if self.confirmOutfitBox then
		self.confirmOutfitBox:destroy()

		self.confirmOutfitBox = nil
	end

	disconnect(LocalPlayer, {
		onArchetypeLevelChange = GameCharacter.onArchetypeLevelChange,
		onArchetypeActiveChange = GameCharacter.onArchetypeActiveChange,
		onInventoryChange = GameCharacter.onInventoryChange,
		onOutfitChange = GameCharacter.onOutfitChange,
		onStatsChange = GameCharacter.onStatsChange,
		onAttackSpeedChange = GameCharacter.onAttackSpeedChange,
		onBaseAttackSpeedChange = GameCharacter.onBaseAttackSpeedChange,
		onEffectiveChannelTimeChange = GameCharacter.onEffectiveChannelTimeChange,
		onEffectiveGlobalCooldownChange = GameCharacter.onEffectiveGlobalCooldownChange,
		onCriticalDamageChange = GameCharacter.onCriticalDamageChange,
		onCriticalChanceChange = GameCharacter.onCriticalChanceChange,
		onEffectiveLevelChange = GameCharacter.onEffectiveLevelChange
	})
	disconnect(Creature, {
		onTitleChange = GameCharacter.onTitleChange
	})
	disconnect(g_game, {
		onGameStart = GameCharacter.onGameStart,
		onGameEnd = GameCharacter.onGameEnd,
		onInfamyChange = GameCharacter.onInfamyChange
	})
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.LevelAttributes)
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.OutfitManagement, "game_character")
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.Titles)

	GameCharacter = nil
end

function GameCharacter:showStatsUnassignedPrompt()
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local GamePrompts = modules.game_prompts.GamePrompts

	if player:getLevel() > 10 then
		GamePrompts:activatePrompt({
			name = "stats_unassigned"
		})
	end
end

function GameCharacter:hideStatsUnassignedPrompt()
	local GamePrompts = modules.game_prompts.GamePrompts

	GamePrompts:completePrompt("stats_unassigned")
end

function GameCharacter:selectTab(tabName)
	if self.currentTab.name == tabName or tabName == "customization" and g_game.isInShip() then
		return
	end

	if self.currentTab.selectionWidget then
		self.currentTab.selectionWidget:setOn(false)
	end

	self.currentTab.name = tabName
	self.currentTab.selectionWidget = self.window.panel_top.selection_panel[tabName]

	self.currentTab.selectionWidget:setOn(true)

	if self.currentTab.tabWidget then
		self.currentTab.tabWidget:hide()
	end

	self.currentTab.tabWidget = self.window.content[string.format("%s_panel", tabName)]

	self.currentTab.tabWidget:show()

	if tabName == "stats" then
		self:requestAttributePoints()
	end
end

function GameCharacter:disableTab(tabName)
	local tab = self.window.panel_top.selection_panel[tabName]

	tab:setEnabled(false)
end

function GameCharacter:disableAllTabs(exceptionList)
	local selectionPanel = self.window and self.window.panel_top and self.window.panel_top.selection_panel or nil

	if selectionPanel then
		for _, tab in ipairs(selectionPanel:getChildren()) do
			if not exceptionList or not table.find(exceptionList, tab:getId()) then
				tab:setEnabled(false)
			end
		end
	end
end

function GameCharacter:enableTab(tabName)
	local tab = self.window.panel_top.selection_panel[tabName]

	tab:setEnabled(true)
end

function GameCharacter:enableAllTabs(exceptionList)
	local selectionPanel = self.window and self.window.panel_top and self.window.panel_top.selection_panel or nil

	if selectionPanel then
		for _, tab in ipairs(selectionPanel:getChildren()) do
			if not exceptionList or not table.find(exceptionList, tab:getId()) then
				tab:setEnabled(true)
			end
		end
	end
end

function GameCharacter.onGameStart()
	local player = g_game.getLocalPlayer()
	local topPanel = GameCharacter.window.panel_top

	topPanel.name:setText(g_game.getCharacterName())
	topPanel.title:setText(GameCharacter:getArchetypeClassName(player))
	GameCharacter.onArchetypeActiveChange(player)

	for _, archetype in pairs(player:getActiveArchetypes()) do
		GameCharacter.onArchetypeLevelChange(player, archetype, player:getArchetypeLevel(archetype), player:getArchetypeLevelPercent(archetype))
	end

	for slot = InventorySlotFirst, InventorySlotLast do
		GameCharacter.onInventoryChange(player, slot, player:getInventoryItem(slot))
	end

	addEvent(function()
		for stat = StatsFirst, StatsLast do
			GameCharacter.onStatsChangeUpdate(player, stat, player:getStats(stat), 0, true)
		end
	end)
	GameCharacter.onAttackSpeedChange(player, player:getAttackSpeed(), player:getAttackSpeed(), player:getBaseAttackSpeed())
	GameCharacter.onEffectiveChannelTimeChange(player, player:getEffectiveChannelTime())
	GameCharacter.onEffectiveGlobalCooldownChange(player, player:getEffectiveGlobalCooldown())
	GameCharacter.onCriticalDamageChange(player, player:getCriticalDamage())
	GameCharacter.onCriticalChanceChange(player, player:getCriticalChance())
	GameCharacter.onOutfitChange(player, player:getOutfit())
	GameCharacter.window:hide()
	GameCharacter:updateStatusPanelVisibility()
end

function GameCharacter.onGameEnd()
	if GameCharacter.window then
		GameCharacter:enableAllTabs()
	end

	GameCharacter:clearAttributes()
	GameCharacter.window:hide()
end

function GameCharacter:updateStatusPanelVisibility()
	local panel = GameCharacter.window.content.stats_panel

	if g_game.isAetherRiftChannel() then
		panel.attribute_points:setVisible(false)

		local attributesPanel = panel.primary_stats.primary_attribute_panel

		for _, attribute in pairs(attributesPanel.statNames) do
			local widget = attributesPanel[attribute]

			widget.minus:setVisible(false)
			widget.plus:setVisible(false)
		end
	else
		panel.attribute_points:setVisible(true)
	end
end

function GameCharacter.onArchetypeLevelChange(player, id, level, percent)
	local panel = GameCharacter.window.panel_top.archetypes
	local icon = panel:recursiveGetChildById(ArchetypeNames[id]:lower())

	if icon then
		icon.progress:setPercent(percent)
	end

	local progress, count = 0, 0

	for _, archetypeId in ipairs(player:getActiveArchetypes()) do
		progress = progress + player:getArchetypeLevelPercent(archetypeId)
		count = count + 1
	end

	GameCharacter.window.panel_top.level.level_progress:setPercent(progress / math.max(1, count))
end

function GameCharacter.onEffectiveLevelChange(player, level, oldLevel)
	GameCharacter.window.panel_top.level_rect:setText(level)
end

function GameCharacter.onArchetypeActiveChange(player)
	local panel = GameCharacter.window.panel_top.archetypes
	local activeArchetypes = player:getActiveArchetypes()

	for i, archetypeId in ipairs(activeArchetypes) do
		local widget = panel:getChildByIndex(i)

		widget:setId(ArchetypeNames[archetypeId]:lower())

		widget.archetype = widget:getId()

		widget:setupVisuals()
	end

	if #activeArchetypes < 3 then
		for i = #activeArchetypes + 1, 3 do
			local widget = panel:getChildByIndex(i)

			widget:setId("empty")

			widget.archetype = nil

			widget:setupVisuals()
		end
	end

	GameCharacter.window.panel_top.title:setText(GameCharacter:getArchetypeClassName(g_game.getLocalPlayer()))
end

function GameCharacter:getArchetypeClassName(player, activeArchetypes)
	activeArchetypes = activeArchetypes or player:getActiveArchetypes()

	if #activeArchetypes == 1 then
		return "Apprentice"
	elseif #activeArchetypes == 2 then
		return "Novice"
	end

	for className, classes in pairs(cfg.classes) do
		local found = true

		for _, archetypeId in ipairs(activeArchetypes) do
			if not table.find(classes, archetypeId) then
				found = false

				break
			end
		end

		if found then
			return className
		end
	end

	return "none"
end

function GameCharacter.onInventoryChange(player, slot, item, oldItem)
	local panel = GameCharacter.window.content.equipment_panel.equipments
	local slotName = panel.slotNames[slot]

	if not slotName then
		return
	end

	local widget = panel[slotName]

	if not widget then
		return
	end

	widget:setItem(item)
	widget.placeholder:setVisible(item == nil)
	signalcall(g_game.onEquippedItems, player, item, oldItem)

	if oldItem then
		modules.game_inventory.GameInventory.lastAddedItem = oldItem

		addEvent(function()
			modules.game_inventory.GameInventory.lastAddedItem = nil
		end)
	end
end

function GameCharacter.onOutfitChange(player, outfit, oldOutfit)
	if not outfit then
		return
	end

	if not oldOutfit or outfit.lookType ~= oldOutfit.lookType then
		GameCharacter.expandedOutfitWindow:hide()
	end

	if outfit.mount ~= 0 and GameCharacter.lookType then
		outfit.lookType = GameCharacter.lookType
		outfit.primaryAddon = GameCharacter.primaryAddon
		outfit.secondaryAddon = GameCharacter.secondaryAddon
	else
		GameCharacter.lookType = outfit.lookType
		GameCharacter.primaryAddon = outfit.primaryAddon
		GameCharacter.secondaryAddon = outfit.secondaryAddon
	end

	if g_game.isInShip() then
		if GameCharacter.customizationTab:isEnabled() then
			GameCharacter.customizationTab:setEnabled(false)
		end

		if GameCharacter.currentTab.name == "customization" then
			GameCharacter:selectTab("equipment")
		end
	elseif not GameCharacter.customizationTab:isEnabled() then
		GameCharacter.customizationTab:setEnabled(true)
	end

	local widget = GameCharacter.window.content.equipment_panel.outfit_preview
	local tempOutfit = player:getTemporaryOutfit()
	local outfit = {
		lookType = g_game.isInShip() and tempOutfit.lookType or outfit.lookType,
		primaryAddon = outfit.primaryAddon,
		secondaryAddon = outfit.secondaryAddon,
		secondaryShader = outfit.secondaryShader,
		bodyColor = outfit.bodyColor,
		headColor = outfit.headColor,
		legsColor = outfit.legsColor,
		feetColor = outfit.feetColor,
		category = ThingCategoryCreature
	}

	widget:setOutfit(outfit)

	widget = GameCharacter.window.content.customization_panel.outfit_preview.outfit

	widget:setOutfit(outfit)

	local panel = GameCharacter.colorSelectionPanel

	for index, color in ipairs({
		outfit.headColor,
		outfit.bodyColor,
		outfit.legsColor,
		outfit.feetColor
	}) do
		local widget = panel:getChildByIndex(index)

		widget.colorBorder:setBorderColor(getOutfitColor(color))
	end

	panel = GameCharacter.expandedOutfitWindow:recursiveGetChildById("outfit_list")

	for _, child in ipairs(panel:getChildren()) do
		local childOutfit = child.outfit:getOutfit()

		childOutfit.bodyColor = outfit.bodyColor
		childOutfit.headColor = outfit.headColor
		childOutfit.legsColor = outfit.legsColor
		childOutfit.feetColor = outfit.feetColor

		child.outfit:setOutfit(childOutfit)
	end
end

function GameCharacter.onStatsChange(player, stat, value, oldValue, internal)
	if internal and stat ~= StatsLast then
		return
	end

	addEvent(function()
		for stat = StatsFirst, StatsLast do
			GameCharacter.onStatsChangeUpdate(player, stat, player:getStats(stat))
		end
	end)
end

function GameCharacter.onStatsChangeUpdate(player, stat, value, oldValue, internal)
	local panel = GameCharacter.window.content.equipment_panel.stats_preview
	local statName = panel.statNames[stat] or ""
	local widget = panel[statName]

	if widget then
		widget.value:setText(value)
	end

	panel = GameCharacter.window.content.stats_panel.primary_stats.power_panel
	statName = panel.statNames[stat]
	widget = panel[statName]

	if widget then
		widget.value:setText(value)
	end

	panel = GameCharacter.window.content.stats_panel.primary_stats.primary_attribute_panel
	statName = panel.statNames[stat] or ""
	widget = panel[statName]

	if widget then
		widget.value:setText(value)
	end

	panel = GameCharacter.window.content.stats_panel.secondary_stats.content

	local statInfo = panel.statNames[stat] or {}

	widget = panel[statInfo.widgetId]

	if widget then
		if statInfo.base then
			widget.base:setText(value)

			widget.baseValue = value
		end

		if statInfo.bonus then
			widget.bonus:setText(value)

			widget.bonusValue = value
		end

		if statInfo.total then
			widget.total:setText(value)

			widget.totalValue = value

			local rawValue = widget.baseValue + widget.bonusValue

			widget.total:setOn(value < rawValue)

			if value < rawValue then
				if stat == StatsMaxHealthEffective or stat == StatsMaxManaEffective then
					local tooltipScaledAttributeValues = "You've reached the softcap.\nAny additional points invested will have reduced benefits towards your current value %i, resulting in %i."

					widget.total:setTooltip(string.format(tooltipScaledAttributeValues, rawValue, value))
				else
					local multiplier = 7
					local tooltipScaledAttributeValues = "You've reached the softcap of %i points for this attribute at your current effective level.\nAny additional points invested will have reduced benefits towards your current value %i, resulting in %i."

					widget.total:setTooltip(string.format(tooltipScaledAttributeValues, player:getEffectiveLevel() * multiplier, rawValue, value))
				end
			else
				widget.total:setTooltip()
			end
		end
	end
end

function GameCharacter.onInfamyChange(infamy)
	local panel = GameCharacter.window.content.equipment_panel.stats_preview.infamy

	panel.value:setText(infamy)
	GameCharacter.updateInfamyDebuffTooltip(infamy)
end

function GameCharacter.updateInfamyDebuffTooltip(infamy)
	local panel = GameCharacter.window.content.equipment_panel.stats_preview.infamy

	if infamy < cfg.pvpReduction[#cfg.pvpReduction].points then
		panel:setTooltip("Infamy")

		return
	end

	local text = "Infamy - Debuffs\n\n"

	if infamy >= cfg.maxInfamyPoints then
		text = text .. cfg.messages.block
	else
		local reduction = 0

		for _, value in ipairs(cfg.pvpReduction) do
			if infamy >= value.points then
				reduction = value.reduction

				break
			end
		end

		if reduction > 0 then
			text = text .. string.format(cfg.messages.damage, reduction)
		end
	end

	local debt = 0

	for _, value in ipairs(cfg.experienceDebt) do
		if infamy >= value.points then
			debt = value.debt

			break
		end
	end

	if debt > 0 then
		text = text .. "\n" .. string.format(cfg.messages.experience, debt)
	end

	panel:setTooltip(text)
end

function GameCharacter.onHealthChange(player, health, maxHealth, oldHealth, oldMaxHealth)
	if oldMaxHealth ~= maxHealth then
		local panel = GameCharacter.window.content.stats_panel.secondary_stats.content
		local widget = panel.maximum_health

		widget.base:setText(player:getStats(StatsMaxHealthBase))
		widget.bonus:setText(maxHealth - player:getStats(StatsMaxHealthBase))
		widget.total:setText(maxHealth)
	end
end

function GameCharacter.onManaChange(player, mana, maxMana, oldMana, oldMaxMana)
	if oldMaxMana ~= maxMana then
		local panel = GameCharacter.window.content.stats_panel.secondary_stats.content
		local widget = panel.maximum_mana

		widget.base:setText(player:getStats(StatsMaxManaBase))
		widget.bonus:setText(maxMana - player:getStats(StatsMaxManaBase))
		widget.total:setText(maxMana)
	end
end

function GameCharacter:addAttribute(widget, attribute, remove, loopCount)
	if not remove and (self.pointsAvailable <= 0 or self.attributes[attribute] + 1 > self.pointsAvailable or self.pointsAllocated >= self.pointsAvailable) then
		return
	elseif remove and self.attributes[attribute] <= 0 then
		return
	end

	local plusWidget = widget.plus
	local minusWidget = widget.minus

	self.attributes[attribute] = self.attributes[attribute] + (remove and -1 or 1)
	self.pointsAllocated = self.pointsAllocated + (remove and -1 or 1)

	plusWidget:setEnabled(self.attributes[attribute] < self.pointsAvailable)

	if self.attributes[attribute] > 0 then
		plusWidget:setText("+" .. self.attributes[attribute])
		minusWidget:setEnabled(true)
		self:toggleSaveButton(true)
	else
		plusWidget:setText(nil)
		minusWidget:setEnabled(false)
	end

	if self.pointsAllocated <= 0 then
		self:toggleSaveButton(false)
	end

	local panel = GameCharacter.window.content.stats_panel.attribute_points.points

	panel:setText(tr("You have %i point%s available", self.pointsAvailable - self.pointsAllocated, self.pointsAvailable - self.pointsAllocated == 1 and "" or "s"))

	local panel = GameCharacter.window.content.stats_panel.primary_stats.primary_attribute_panel

	for _, attribute in pairs(panel.statNames) do
		local widget = panel[attribute]

		widget.plus:setEnabled(self.pointsAllocated < self.pointsAvailable)
	end

	if loopCount == nil then
		loopCount = g_keyboard.isShiftPressed() and 10 or 1
	end

	loopCount = loopCount - 1

	if loopCount > 0 then
		return self:addAttribute(widget, attribute, remove, loopCount)
	end
end

function GameCharacter:removeAttribute(widget, attribute)
	if self.attributes[attribute] <= 0 then
		return
	end

	self:addAttribute(widget, attribute, true)
end

function GameCharacter:saveAttributes()
	self:sendLevelAttributesOpcode({
		action = "attributes",
		attributes = self.attributes
	})
	self:clearAttributes()
	self:requestAttributePoints()
end

function GameCharacter:requestAttributePoints()
	self:sendLevelAttributesOpcode({
		action = "request_points"
	})
end

function GameCharacter:sendLevelAttributesOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.LevelAttributes, g_game.serializeTable(data))
	end
end

function GameCharacter:clearAttributes()
	local panel = GameCharacter.window.content.stats_panel.primary_stats.primary_attribute_panel

	for _, attribute in pairs(panel.statNames) do
		local widget = panel[attribute]

		widget.plus:setText(nil)
		widget.minus:setText(nil)

		GameCharacter.attributes[attribute] = 0
		GameCharacter.pointsAllocated = 0
		GameCharacter.pointsAvailable = 0
	end

	self:toggleSaveButton(false)
end

function GameCharacter:toggleSaveButton(on)
	local panel = GameCharacter.window.content.stats_panel.save_button_panel

	panel:setOn(on)
end

function GameCharacter.onTitlesExtendedOpcode(protocol, opcode, buffer)
	if opcode == ExtendedIds.Titles then
		local data = g_game.unserializeTable(buffer)

		if not data or type(data) ~= "table" then
			return
		end

		if data.action == "titles" then
			GameCharacter:updateTitles(data.title, data.titles)
		end
	end
end

function GameCharacter.onLevelAttributesExtendedOpcode(protocol, opcode, buffer)
	if opcode == ExtendedIds.LevelAttributes then
		local data = g_game.unserializeTable(buffer)

		if not data or type(data) ~= "table" then
			return
		end

		if data.action == "points" then
			GameCharacter:updateAvailableAttributePoints(data.points)
		end
	end
end

function GameCharacter:updateAvailableAttributePoints(points)
	local oldPoints = self.pointsAvailable

	self:clearAttributes()

	self.pointsAvailable = points

	local panel = GameCharacter.window.content.stats_panel.attribute_points.points

	panel:setText(tr("You have %i point%s available", points, points == 1 and "" or "s"))

	local panel = GameCharacter.window.content.stats_panel.primary_stats.primary_attribute_panel

	for _, attribute in pairs(panel.statNames) do
		local widget = panel[attribute]

		widget.minus:setVisible(points > 0)
		widget.minus:setEnabled(self.attributes[attribute] > 0)
		widget.plus:setVisible(points > 0)
		widget.plus:setEnabled(points > self.attributes[attribute])
	end

	if self.pointsAvailable > 0 then
		self:showStatsUnassignedPrompt()
	else
		self:hideStatsUnassignedPrompt()
	end

	signalcall(GameCharacter.onUpdateAttributePoints, oldPoints, points)
end

function GameCharacter.toggle()
	if GameCharacter.window:isVisible() then
		GameCharacter.window:hide()

		if GameCharacter.confirmOutfitBox then
			GameCharacter.confirmOutfitBox:destroy()

			GameCharacter.confirmOutfitBox = nil
		end
	else
		GameCharacter.window:show()
		GameCharacter.window:raise()
	end
end

function GameCharacter:toggleOutfitWindow()
	if self.expandedOutfitWindow:isVisible() then
		self.expandedOutfitWindow:hide()
	else
		self.expandedOutfitWindow:show()
		self:selectOutfitCategory("body")
	end

	self.expandedOutfitWindow:followParent()
end

function GameCharacter:selectOutfitCategory(outfitCategory)
	if self.selectedOutfitCategory == outfitCategory then
		return
	end

	local panel = self.expandedOutfitWindow:recursiveGetChildById(outfitCategory)

	if not panel then
		return
	end

	if self.selectedOutfitCategory then
		local previousPanel = self.expandedOutfitWindow:recursiveGetChildById(self.selectedOutfitCategory)

		if previousPanel then
			previousPanel:setOn(false)
		end
	end

	panel:setOn(true)

	self.selectedOutfitCategory = outfitCategory

	self:requestOutfitList(outfitCategory)

	panel = self.expandedOutfitWindow:recursiveGetChildById("outfit_list")

	panel:destroyChildren()
end

function GameCharacter:requestOutfitList(outfitCategory)
	self:sendOutfitManagementOpcode({
		action = "request_outfits",
		category = outfitCategory
	})
end

function GameCharacter.requestResetStats()
	GameCharacter:sendLevelAttributesOpcode({
		action = "reset_stats"
	})
end

function GameCharacter:selectOutfit(widget, internal)
	if self.selectedOutfitWidget == widget then
		return
	end

	if widget.overlay and widget.overlay:isVisible() then
		return
	end

	if self.selectedOutfitWidget then
		self.selectedOutfitWidget:setOn(false)
	end

	self.selectedOutfitWidget = widget

	widget:setOn(true)

	if not internal then
		self:sendOutfitManagementOpcode({
			action = "select_outfit",
			category = self.selectedOutfitCategory,
			outfitId = widget.outfitId
		})
	end
end

function GameCharacter.onOutfitManagementExtendedOpcode(protocol, opcode, buffer)
	if opcode == ExtendedIds.OutfitManagement then
		local data = g_game.unserializeTable(buffer)

		if not data or type(data) ~= "table" then
			return
		end

		if data.action == "request_outfits" then
			GameCharacter:updateOutfitList(data.category, data.outfits)
		elseif data.action == "unlocked_addons" then
			GameCharacter:onUnlockedAddons(data.addonsIds)
		elseif data.action == "request_effects" then
			GameCharacter:updateEffectList(data.category, data.effects)
		end
	end
end

function GameCharacter:sendOutfitManagementOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.OutfitManagement, g_game.serializeTable(data))
	end
end

function GameCharacter:updateOutfitList(outfitCategory, outfits)
	local panel = self.expandedOutfitWindow:recursiveGetChildById("outfit_list")

	if not panel then
		return
	end

	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	panel:destroyChildren()

	local currentOutfit = player:getOutfit()
	local isPremium = player:isPremium()

	for index, outfit in ipairs(outfits) do
		local widget = g_ui.createWidget("GameCharacterCustomizationPanelOutfitsListButtonHolder", panel)

		widget.outfit:setOutfit({
			lookType = outfit.lookType,
			primaryAddon = outfit.primaryAddon,
			secondaryAddon = outfit.secondaryAddon,
			category = ThingCategoryCreature,
			headColor = currentOutfit.headColor,
			bodyColor = currentOutfit.bodyColor,
			legsColor = currentOutfit.legsColor,
			feetColor = currentOutfit.feetColor
		})

		widget.realOutfitId = outfit.id
		widget.outfitId = index
		widget.ravencoinPrice = outfit.price

		local tier3Outfit = outfitCategory ~= "body" and cfg.tier3Cosmetics[widget.realOutfitId] or false
		local premiumAccess = tier3Outfit and isPremium

		widget.premium:setVisible(tier3Outfit)

		local overlayVisible = outfit.unlocked == false or tier3Outfit and not premiumAccess

		widget.overlay:setVisible(overlayVisible)

		if outfit.unlocked == true and tier3Outfit and not premiumAccess then
			widget.overlay:setTooltip("You have unlocked this cosmetic addon, but only Patron accounts are able to equip it.")
			widget.overlay.compass:setVisible(false)
			widget.overlay.lock:setVisible(false)
		end

		local showOverlayText = true

		if outfit.unlocked == false and outfit.price then
			showOverlayText = false

			widget.overlay.unlock_button:setVisible(true)
			widget.overlay.compass:setVisible(false)
		end

		local lookType = outfit.lookType

		if self.selectedOutfitCategory == "body" then
			widget.outfitId = outfit.lookType

			widget.overlay.compass:setVisible(false)

			if currentOutfit.lookType == outfit.lookType then
				self:selectOutfit(widget, true)
			end
		elseif self.selectedOutfitCategory == "head" then
			lookType = outfit.primaryAddon

			if currentOutfit.primaryAddon == outfit.primaryAddon then
				self:selectOutfit(widget, true)
			end
		elseif self.selectedOutfitCategory == "weapon" then
			lookType = outfit.secondaryAddon

			if currentOutfit.secondaryAddon == outfit.secondaryAddon then
				self:selectOutfit(widget, true)
			end
		end

		local cfg = lookType and OutfitAddons[lookType]

		widget.name = cfg and cfg.name or "Unknown"

		if showOverlayText then
			widget.overlay_text:setText(widget.name)
			widget.overlay_text:setVisible(true)

			local textSize = widget.overlay_text:getTextSize().width

			while textSize > 125 do
				widget.overlay_text:setText(string.format("%s...", widget.overlay_text:getText():sub(1, -5)))

				textSize = widget.overlay_text:getTextSize().width
			end
		end
	end
end

function GameCharacter:onUnlockedAddons(addonsIds)
	local panel = self.expandedOutfitWindow:recursiveGetChildById("outfit_list")

	if not panel then
		return
	end

	if not panel:isVisible() then
		return
	end

	if not self.selectedOutfitCategory then
		return
	end

	if self.selectedOutfitCategory ~= "head" and self.selectedOutfitCategory ~= "weapon" then
		return
	end

	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local isPremium = player:isPremium()

	for _, widget in ipairs(panel:getChildren()) do
		if widget.realOutfitId and table.contains(addonsIds, widget.realOutfitId) then
			local tier3Outfit = cfg.tier3Cosmetics[widget.realOutfitId] or false
			local premiumAccess = tier3Outfit and isPremium
			local overlayVisible = tier3Outfit and not premiumAccess

			widget.overlay:setVisible(overlayVisible)
			widget.overlay.unlock_button:setVisible(false)

			if tier3Outfit and not premiumAccess then
				widget.overlay:setTooltip("You have unlocked this cosmetic addon, but only Patron accounts are able to equip it.")
				widget.overlay.compass:setVisible(false)
				widget.overlay.lock:setVisible(false)
			end

			widget.overlay_text:setText(widget.name)
			widget.overlay_text:setVisible(true)

			local textSize = widget.overlay_text:getTextSize().width

			while textSize > 125 do
				widget.overlay_text:setText(string.format("%s...", widget.overlay_text:getText():sub(1, -5)))

				textSize = widget.overlay_text:getTextSize().width
			end
		end
	end
end

function GameCharacter:updateColorSelection(widget, internal)
	local panel = self.colorBoxHolder

	if not panel then
		return
	end

	if self.selectedColorWidget then
		self.selectedColorWidget:setOn(false)
	end

	self.selectedColorWidget = widget

	widget:setOn(true)

	if not internal then
		self:sendOutfitManagementOpcode({
			action = "select_color",
			color = widget.colorCode,
			category = self.selectedColorGroup
		})
	end
end

function GameCharacter.onBaseAttackSpeedChange(player, baseAttackSpeed)
	GameCharacter.onAttackSpeedChange(player, player:getAttackSpeed(), player:getAttackSpeed(), baseAttackSpeed)
end

function GameCharacter.onAttackSpeedChange(player, attackSpeed, oldAttackSpeed, baseAttackSpeed)
	local panel = GameCharacter.window.content.stats_panel.secondary_stats.content
	local widget = panel.attack_speed

	baseAttackSpeed = baseAttackSpeed or player:getBaseAttackSpeed()

	widget.base:setText(string.format("%.1f", baseAttackSpeed / 1000))

	local bonus = baseAttackSpeed - attackSpeed

	widget.bonus:setText(bonus < 1 and 0 or string.format("%.2f", -bonus / 1000))
	widget.total:setText(string.format("%.2f", attackSpeed / 1000))

	if attackSpeed <= cfg.minAttackSpeed * baseAttackSpeed / cfg.baseAttackSpeed then
		widget.total:setTooltip(cfg.maxStatsTooltip)
		widget.total:setChecked(true)
	else
		widget.total:setTooltip()
		widget.total:setChecked(false)
	end
end

function GameCharacter.onEffectiveChannelTimeChange(player, channelTimePercent)
	local panel = GameCharacter.window.content.stats_panel.secondary_stats.content
	local widget = panel.casting_time

	widget.base:setText("100")

	local bonus = 100 - channelTimePercent

	widget.bonus:setText(bonus == 0 and 0 or -bonus)
	widget.total:setText(channelTimePercent)

	if channelTimePercent <= cfg.minChannelingTimePercent then
		widget.total:setTooltip(cfg.maxStatsTooltip)
		widget.total:setChecked(true)
	else
		widget.total:setTooltip()
		widget.total:setChecked(false)
	end
end

function GameCharacter.onEffectiveGlobalCooldownChange(player, cooldown)
	local panel = GameCharacter.window.content.stats_panel.secondary_stats.content
	local widget = panel.global_cooldown
	local bonus = cfg.baseGlobalCooldown - cooldown

	widget.base:setText(string.format("%.1f", cfg.baseGlobalCooldown / 1000))
	widget.bonus:setText(bonus == 0 and 0 or string.format("%.2f", -bonus / 1000))
	widget.total:setText(string.format("%.2f", cooldown / 1000))

	if cooldown <= cfg.minGlobalCooldown then
		widget.total:setTooltip(cfg.maxStatsTooltip)
		widget.total:setChecked(true)
	else
		widget.total:setTooltip()
		widget.total:setChecked(false)
	end
end

function GameCharacter.onCriticalDamageChange(player, criticalDamage)
	local panel = GameCharacter.window.content.stats_panel.secondary_stats.content
	local widgets = {
		[panel.critical_damage_percent] = criticalDamage
	}

	for widget, percent in pairs(widgets) do
		widget.base:setText((cfg.baseCriticalDamage - 1) * 100)

		local bonus = percent - cfg.baseCriticalDamage

		widget.bonus:setText(bonus < 0.1 and 0 or string.format("%.1f", bonus * 100))
		widget.total:setText(percent < 0.1 and 0 or string.format("%.1f", (percent - 1) * 100))

		if percent >= cfg.maxCriticalDamage then
			widget.total:setTooltip(cfg.maxStatsTooltip)
			widget.total:setChecked(true)
		else
			widget.total:setTooltip()
			widget.total:setChecked(false)
		end
	end
end

function GameCharacter.onCriticalChanceChange(player, criticalChance)
	local panel = GameCharacter.window.content.stats_panel.secondary_stats.content
	local widgets = {
		[panel.critical_chance_percent] = criticalChance
	}

	for widget, percent in pairs(widgets) do
		widget.base:setText(cfg.baseCriticalChance)

		local bonus = percent - cfg.baseCriticalChance

		widget.bonus:setText(bonus < 0.1 and 0 or string.format("%.1f", bonus))
		widget.total:setText(percent < 0.1 and 0 or string.format("%.1f", percent))

		if percent >= cfg.maxCriticalChance then
			widget.total:setTooltip(cfg.maxStatsTooltip)
			widget.total:setChecked(true)
		else
			widget.total:setTooltip()
			widget.total:setChecked(false)
		end
	end
end

function GameCharacter:sendTitleOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.Titles, g_game.serializeTable(data))
	end
end

function GameCharacter.onTitleChange(creature, id)
	if id == 0 then
		id = cfg.TITLE_NONE
	end

	local title = cfg.titles[id]

	if not title or id == cfg.TITLE_NONE then
		creature:setTitleCachedText("")

		return
	end

	creature:setTitleCachedText(title.name)
end

function GameCharacter:updateTitles(title, titles)
	local topPanel = GameCharacter.window.panel_top
	local combobox = topPanel.combobox

	combobox:clearOptions()

	combobox.onOptionChange = nil

	combobox:addOption(tr("None"), {
		color = "#7E828B",
		id = cfg.TITLE_NONE
	})

	for _, id in ipairs(titles) do
		local _title = cfg.titles[id]

		if _title then
			combobox:addOption(_title.name, {
				id = id
			})

			if id == title then
				combobox:setCurrentOption(_title.name)
			end
		end
	end

	function combobox.onOptionChange(_, text, data)
		self:sendTitleOpcode({
			action = "change_title",
			id = data.id or -1
		})
	end
end

function GameCharacter:onCompassClicked(parent, force)
	if self.confirmBox then
		self.confirmBox:destroy()

		self.confirmBox = nil
	end

	local realOutfitId = parent.realOutfitId

	if not force and cfg.tier3Cosmetics[realOutfitId] and not g_game.getLocalPlayer():isPremium() then
		local function yesCallback()
			self.confirmBox:destroy()

			self.confirmBox = nil

			self:onCompassClicked(parent, true)
		end

		local function noCallback()
			self.confirmBox:destroy()

			self.confirmBox = nil
		end

		self.confirmBox = displayGeneralBox(tr("Warning"), "This cosmetic requires an active Patron Account to be equipped.", {
			{
				text = tr("Locate NPC"),
				callback = yesCallback
			},
			{
				text = tr("Cancel"),
				callback = noCallback
			},
			anchor = AnchorHorizontalCenter
		}, yesCallback, noCallback, nil, modules.game_interface.getRootPanel())

		return
	end

	local id

	if self.selectedOutfitCategory == "head" then
		id = parent.outfit:getOutfit().primaryAddon
	elseif self.selectedOutfitCategory == "weapon" then
		id = parent.outfit:getOutfit().secondaryAddon
	end

	local highlight = id and highlights[id]
	local positions = highlight and (highlight.position and {
		highlight.position
	} or highlight.positions)

	if not positions then
		return
	end

	for index, position in ipairs(positions) do
		if not position.callback or position.callback() then
			local flag = g_worldMap.addCompassHighlight({
				pos = position,
				compassSize = position.size
			}, highlight.description, index, "", true)

			flag.floorInfo = position.floorInfo

			connect(g_worldMap.window, {
				onVisibilityChange = function(widget, visible)
					if not visible then
						g_worldMap.removeCompassHighlight(flag)
					end
				end
			})
		end
	end

	g_worldMap.displayQuestTaskCompass(highlight.description)
end

function GameCharacter:onUnlockClicked(parent, force)
	local price = parent.ravencoinPrice

	if not price then
		return
	end

	if self.confirmOutfitBox then
		self.confirmOutfitBox:destroy()

		self.confirmOutfitBox = nil
	end

	if not force then
		local function yesCallback()
			self.confirmOutfitBox:destroy()

			self.confirmOutfitBox = nil

			self:onUnlockClicked(parent, true)
		end

		local function noCallback()
			self.confirmOutfitBox:destroy()

			self.confirmOutfitBox = nil
		end

		self.confirmOutfitBox = g_ui.createWidget("UnlockOutfitModal", modules.game_interface.getHUDPanel())

		if not self.confirmOutfitBox then
			return
		end

		self.confirmOutfitBox:setText("Unlock Outfit")

		local coloredText = GetHighlightedText(string.format("Are you sure you want to unlock {%s, #36F991} for {%d, #FEFEC6} RavenCoins?", parent.name, price))

		self.confirmOutfitBox.panel.text:setColoredText(coloredText)
		self.confirmOutfitBox.panel.preview.outfit:setOutfit(parent.outfit:getOutfit())

		local confirmButton = self.confirmOutfitBox:getChildById("buttonsPanel"):getChildById("confirmButton")

		confirmButton.onClick = yesCallback

		local cancelButton = self.confirmOutfitBox:getChildById("buttonsPanel"):getChildById("cancelButton")

		cancelButton.onClick = noCallback

		self.confirmOutfitBox:raise()
		self.confirmOutfitBox:focus()

		self.confirmOutfitBox.onFocusChange = noCallback

		return
	end

	self:sendOutfitManagementOpcode({
		action = "unlock_outfit_cosmetic",
		id = parent.realOutfitId
	})
end

function GameCharacter:toggleEffectWindow()
	if self.expandedEffectWindow:isVisible() then
		self.expandedEffectWindow:hide()
	else
		self.expandedEffectWindow:show()
		self:selectEffectCategory("weapon shine")
	end

	self.expandedEffectWindow:followParent()
end

function GameCharacter:selectEffectCategory(effectCategory)
	if self.selectedEffectCategory == effectCategory then
		self:requestEffectList(effectCategory)

		return
	end

	local panel = self.expandedEffectWindow:recursiveGetChildById(effectCategory)

	if not panel then
		return
	end

	if self.selectedEffectCategory then
		local previousPanel = self.expandedEffectWindow:recursiveGetChildById(self.selectedEffectCategory)

		if previousPanel then
			previousPanel:setOn(false)
		end
	end

	panel:setOn(true)

	self.selectedEffectCategory = effectCategory

	self:requestEffectList(effectCategory)

	panel = self.expandedEffectWindow:recursiveGetChildById("effect_list")

	panel:destroyChildren()
end

function GameCharacter:requestEffectList(effectCategory)
	self:sendOutfitManagementOpcode({
		action = "request_effects",
		category = effectCategory
	})
end

function GameCharacter:selectEffect(widget, internal)
	if widget.overlay and widget.overlay:isVisible() then
		return
	end

	if self.selectedEffectWidget == widget then
		if self.selectedEffectWidget then
			self.selectedEffectWidget:setOn(false)
		end

		self.selectedEffectWidget = nil

		self:sendOutfitManagementOpcode({
			action = "select_effect",
			outfitId = 0,
			category = self.selectedEffectCategory
		})

		return
	end

	if self.selectedEffectWidget then
		self.selectedEffectWidget:setOn(false)
	end

	self.selectedEffectWidget = widget

	widget:setOn(true)

	if not internal then
		self:sendOutfitManagementOpcode({
			action = "select_effect",
			category = self.selectedEffectCategory,
			outfitId = widget.outfitId
		})
	end
end

function GameCharacter:updateEffectList(effectCategory, effects)
	local panel = self.expandedEffectWindow:recursiveGetChildById("effect_list")

	if not panel then
		return
	end

	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	panel:destroyChildren()

	local currentOutfit = player:getOutfit()

	if effectCategory == "weapon shine" then
		for index, effect in ipairs(effects) do
			local widget = g_ui.createWidget("GameCharacterCustomizationPanelEffectsListButtonHolder", panel)

			widget.outfit:setOutfit({
				lookType = effect.lookType,
				primaryAddon = effect.primaryAddon,
				secondaryAddon = effect.secondaryAddon,
				secondaryShader = effect.weaponShader,
				category = ThingCategoryCreature,
				headColor = currentOutfit.headColor,
				bodyColor = currentOutfit.bodyColor,
				legsColor = currentOutfit.legsColor,
				feetColor = currentOutfit.feetColor
			})

			widget.name = effect.name
			widget.realOutfitId = effect.id
			widget.outfitId = index
			widget.ravencoinPrice = effect.price

			widget.overlay:setVisible(effect.unlocked == false)
			widget.overlay.unlock_button:setVisible(false)
			widget.overlay.compass:setVisible(false)
			widget.premium:setVisible(false)
			widget.overlay_text:setText(widget.name)
			widget.overlay_text:setVisible(true)

			local textSize = widget.overlay_text:getTextSize().width

			while textSize > 125 do
				widget.overlay_text:setText(string.format("%s...", widget.overlay_text:getText():sub(1, -5)))

				textSize = widget.overlay_text:getTextSize().width
			end

			if currentOutfit.secondaryShader == effect.weaponShader then
				self:selectOutfit(widget, true)
			end
		end
	elseif effectCategory == "teleport" then
		for index, effect in ipairs(effects) do
			local widget = g_ui.createWidget("GameCharacterCustomizationPanelEffectsListButtonHolder", panel)

			widget.outfit:setImageSource(string.format("/images/ui/windows/character/teleport/%d", effect.id))

			widget.name = effect.name
			widget.realOutfitId = effect.id
			widget.outfitId = index
			widget.ravencoinPrice = effect.price

			widget.overlay:setVisible(effect.unlocked == false)
			widget.overlay.unlock_button:setVisible(false)
			widget.overlay.compass:setVisible(false)
			widget.premium:setVisible(false)
			widget.overlay_text:setText(widget.name)
			widget.overlay_text:setVisible(true)

			local textSize = widget.overlay_text:getTextSize().width

			while textSize > 125 do
				widget.overlay_text:setText(string.format("%s...", widget.overlay_text:getText():sub(1, -5)))

				textSize = widget.overlay_text:getTextSize().width
			end

			if effect.selected then
				self:selectOutfit(widget, true)
			end
		end
	end
end
