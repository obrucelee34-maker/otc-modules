-- chunkname: @/modules/game_battle/battle_list.lua

BattleList = {
	updateInterval = 500,
	monsterFilter = 0,
	playerFilter = 0,
	sortingOrder = 1,
	sortingType = 1,
	isHoveringTheBattleList = false,
	DEBUG_MODE = false,
	creatures = {},
	widgetsByCreatureId = {},
	activeFilters = {},
	states = {
		attacking = 1,
		healing = 2,
		none = 0
	},
	filtersCategories = {
		"Players",
		"Monsters"
	},
	sortingCategories = {
		{
			name = "Health",
			sortType = 1
		},
		{
			name = "Level",
			sortType = 2
		},
		{
			name = "Name",
			sortType = 3
		},
		{
			name = "Distance",
			sortType = 4
		}
	},
	filtersForCategory = {
		players = {
			{
				name = "Party Members",
				filterId = 2
			},
			{
				name = "Player with Tradepack",
				filterId = 4
			},
			{
				name = "Player with Wagon",
				filterId = 8
			},
			{
				name = "Player with PK",
				filterId = 16
			},
			{
				name = "Other Players",
				filterId = 32
			}
		},
		monsters = {
			{
				name = "Bosses",
				filterId = 2
			},
			{
				name = "Non-Bosses",
				filterId = 4
			}
		}
	},
	SORTING_TYPE = {
		HEALTH = 1,
		DISTANCE = 4,
		NAME = 3,
		LEVEL = 2
	},
	SORTING_ORDER = {
		DESCENDING = 2,
		ASCENDING = 1
	},
	FILTERS = {
		PLAYERS = {
			OTHER_PLAYERS = 32,
			PLAYER_WITH_PK = 16,
			PLAYER_WITH_WAGON = 8,
			PLAYER_WITH_TRADEPACK = 4,
			PARTY_MEMBERS = 2,
			GUILD_MEMBERS = 1
		},
		MONSTERS = {
			BOSSES = 2,
			NON_BOSSES = 4
		}
	},
	AGGRO = {
		colors = {
			aggroHolder = "#d38e49",
			highestAggro = "#d94a4b",
			taunt = "#ED00D1",
			brackets = {
				{
					percent = 85,
					color = "#505157"
				},
				{
					percent = 100,
					color = "#77d463"
				},
				{
					percent = 120,
					color = "#f7d200"
				}
			}
		}
	}
}

local function debugPrint(...)
	if BattleList.DEBUG_MODE then
		print(...)
	end
end

function BattleList:init()
	g_ui.importStyle("styles/battle_list")

	local HUDPanel = modules.game_interface.getHUDPanel()

	self.window = g_ui.createWidget("BattleListWindow", HUDPanel)
	self.content = self.window:getChildById("content")
	self.window.onDragEnter = BattleList.onDragEnter
	self.window.onDragMove = BattleList.onDragMove

	connect(LocalPlayer, {
		onPositionChange = self.onPlayerPositionChange
	})
	connect(Creature, {
		onAppear = self.onAppear,
		onDisappear = self.onDisappear,
		onHiddenStatusChange = self.onHiddenStatusChange,
		onHealthPercentChange = self.onCreatureHealthPercentChange,
		onManaPercentChange = self.onCreatureManaPercentChange,
		onPositionChange = self.onCreaturePositionChange,
		onAggroChange = self.onCreatureAggroChange,
		onTargetChange = self.onCreatureTargetChange,
		onTauntChange = self.onCreatureTauntChange
	})
	connect(g_game, {
		onGameEnd = self.onGameEnd,
		onGameStart = self.onGameStart,
		onAttackingCreatureChange = self.onAttackingCreatureChange,
		onHealingCreatureChange = self.onHealingCreatureChange,
		onPartyAddMember = self.onPartyAddMember,
		onPartyRemoveMember = self.onPartyRemoveMember
	})

	local playersAllFlags = 0

	for i, filter in ipairs(self.filtersForCategory.players) do
		filter.index = i
		playersAllFlags = bit.bor(playersAllFlags, filter.filterId)
	end

	local monstersAllFlags = 0

	for i, filter in ipairs(self.filtersForCategory.monsters) do
		filter.index = i
		monstersAllFlags = bit.bor(monstersAllFlags, filter.filterId)
	end

	self.playersAllFlags = playersAllFlags
	self.monstersAllFlags = monstersAllFlags
	self.playerFilter = playersAllFlags
	self.monsterFilter = monstersAllFlags

	if g_game.isOnline() then
		self:loadSavedFilters()
		self:startChecking()
		update()
	end
end

function BattleList:terminate()
	disconnect(LocalPlayer, {
		onPositionChange = self.onPlayerPositionChange
	})
	disconnect(g_game, {
		onGameEnd = self.onGameEnd,
		onGameStart = self.onGameStart,
		onAttackingCreatureChange = self.onAttackingCreatureChange,
		onHealingCreatureChange = self.onHealingCreatureChange,
		onPartyAddMember = self.onPartyAddMember,
		onPartyRemoveMember = self.onPartyRemoveMember
	})
	disconnect(Creature, {
		onAppear = self.onAppear,
		onDisappear = self.onDisappear,
		onHiddenStatusChange = self.onHiddenStatusChange,
		onHealthPercentChange = self.onCreatureHealthPercentChange,
		onManaPercentChange = self.onCreatureManaPercentChange,
		onPositionChange = self.onCreaturePositionChange,
		onAggroChange = self.onCreatureAggroChange,
		onTargetChange = self.onCreatureTargetChange,
		onTauntChange = self.onCreatureTauntChange
	})
	self:stopChecking()

	for _, widget in pairs(self.widgetsByCreatureId) do
		if widget.updateWidthEvent then
			removeEvent(widget.updateWidthEvent)
		end
	end

	self.window:destroy()
end

function BattleList.onPartyAddMember(name, isOnline, healthPercent, manaPercent, position, channelId, outfit, temporaryOutfit)
	if name == g_game.getLocalPlayer():getName() or not isOnline then
		return
	end

	for _, widget in pairs(BattleList.widgetsByCreatureId) do
		if widget.name == name then
			widget.healthBar.mana:show()
			widget.healthBar.health:setOn(false)

			widget.healthBar.party = true

			BattleList:updateHealthBarBackground(widget)
		end
	end
end

function BattleList.onPartyRemoveMember(name)
	for _, widget in pairs(BattleList.widgetsByCreatureId) do
		if widget.name == name then
			widget.healthBar.mana:hide()
			widget.healthBar.health:setOn(true)

			widget.healthBar.party = false

			BattleList:updateHealthBarBackground(widget)
		end
	end
end

function BattleList.onCreatureHealthPercentChange(creature)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	if creature:getId() == player:getId() then
		return
	end

	local widget = BattleList.widgetsByCreatureId[creature:getId()]

	if not widget then
		return
	end

	debugPrint("[Creature] health change procedure called", creature:getName(), widget:getId())
	BattleList:updateCreatureWidget(widget, creature)
end

function BattleList.onCreatureManaPercentChange(creature)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	if creature:getId() == player:getId() then
		return
	end

	local widget = BattleList.widgetsByCreatureId[creature:getId()]

	if not widget then
		return
	end

	debugPrint("[Creature] mana change procedure called", creature:getName(), widget:getId())
	BattleList:updateCreatureWidget(widget, creature)
end

function BattleList.onCreatureAggroChange(creature, aggro, targetAggro, highestAggro)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local aggroColor
	local isTarget = creature:getAttackingCreatureId() == player:getId()
	local isTaunted = creature:isTaunted()

	if isTarget or isTaunted then
		aggroColor = BattleList:getAggroColor(0, isTarget, false, isTaunted)
	end

	if not aggroColor then
		if not aggro then
			aggro, targetAggro, highestAggro = creature:getAggroInfo()
		end

		if highestAggro and highestAggro > 0 then
			local aggroPercent = math.min(999, targetAggro > 0 and aggro / targetAggro * 100 or 0)

			aggroColor = BattleList:getAggroColor(aggroPercent, false, highestAggro == aggro, false)
		end
	end

	if aggroColor then
		creature:setAggroBorderColor(aggroColor)
		creature:setAggroBorderVisible(true)
	else
		creature:setAggroBorderVisible(false)
	end
end

function BattleList.onCreatureTargetChange(creature, targetId, oldTargetId)
	BattleList.onCreatureAggroChange(creature)
end

function BattleList.onCreatureTauntChange(creature, taunted)
	BattleList.onCreatureAggroChange(creature)
end

function BattleList:getAggroColor(aggroPercent, isAggroHolder, isHighestAggro, isTaunted)
	if isTaunted then
		return self.AGGRO.colors.taunt
	end

	if isAggroHolder then
		return self.AGGRO.colors.aggroHolder
	end

	for _, bracket in ipairs(self.AGGRO.colors.brackets) do
		if bracket.percent and aggroPercent < bracket.percent then
			return bracket.color
		end
	end

	if isHighestAggro then
		return self.AGGRO.colors.highestAggro
	else
		return self.AGGRO.colors.brackets[#self.AGGRO.colors.brackets].color
	end
end

function BattleList:show()
	if g_game.isInShip() then
		return
	end

	modules.game_minimap.toggleMinimapButton("battleListButton", true)
	self.window:raise()
	self.window:focus()
	self.window:show()
end

function BattleList:hide()
	modules.game_minimap.toggleMinimapButton("battleListButton", false)
	self.window:hide()
end

function BattleList:toggle()
	if self.window:isVisible() then
		self:hide()
	else
		self:show()
	end
end

function BattleList.onGameStart()
	BattleList:startChecking()
	BattleList:loadSavedFilters()
end

function BattleList.onGameEnd()
	BattleList:stopChecking()
	BattleList:saveFilters()
end

function BattleList.onAttackingCreatureChange()
	BattleList:updateTargets()
end

function BattleList.onHealingCreatureChange()
	BattleList:updateTargets()
end

function BattleList.onAppear(creature)
	local self = BattleList

	if not self:hasCreature(creature) then
		self:addCreature(creature)
	end
end

function BattleList.onDisappear(creature)
	local self = BattleList

	if self:hasCreature(creature) then
		creature:setAggroBorderVisible(false)
		self:removeCreature(creature:getId())
	end
end

function BattleList:startChecking()
	self:stopChecking()

	self.updateEvent = cycleEvent(function()
		self:sort()
	end, self.updateInterval)
end

function BattleList:stopChecking()
	if self.updateEvent then
		removeEvent(self.updateEvent)

		self.updateEvent = nil
	end
end

function BattleList.onHiddenStatusChange(creature, isHidden)
	local player = g_game.getLocalPlayer()

	if creature:getId() ~= player:getId() then
		BattleList.updateCreatureAvailability(creature)
	end
end

function BattleList.isCreatureAvailableForBeingDisplayed(creature)
	local player = g_game.getLocalPlayer()
	local playerPos = player:getPosition()

	if not player then
		return false
	end

	local creaturePos = creature:getPosition()

	if creaturePos and playerPos.z == creaturePos.z and Position.canSee(playerPos, creaturePos) and not creature:isHidden() then
		return true
	end

	return false
end

function BattleList.updateCreatureAvailability(creature)
	local widget = BattleList.widgetsByCreatureId[creature:getId()]

	if not widget then
		return false
	end

	local available = BattleList.isCreatureAvailableForBeingDisplayed(creature)

	if available then
		if widget.hidden then
			widget.hidden = false

			widget:show()
			BattleList:updateCreatureWidget(widget, creature)
			BattleList:sort()
		end

		BattleList:fitFilter(widget, creature)

		return true
	elseif not available and not widget.hidden then
		widget.hidden = true

		widget:hide()

		return true
	end

	return false
end

function BattleList.onCreaturePositionChange(creature, newPos)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local widget = BattleList.widgetsByCreatureId[creature:getId()]

	if not widget then
		return
	end

	local lastState = widget.hidden

	if creature:getId() == player:getId() then
		return
	end

	if not BattleList.updateCreatureAvailability(creature) and BattleList.sortingType == 4 then
		BattleList:updateCreatureWidget(widget, creature)
	end

	if lastState ~= widget.hidden then
		debugPrint("[Creature] The creature: ", creature:getName(), Position.tostring(newPos), widget.hidden and " is now hidden!" or " showed up!")
	end
end

function BattleList.onPlayerPositionChange(_, newPos, oldPos)
	local self = BattleList

	for creatureId, widget in pairs(self.widgetsByCreatureId) do
		local creature = g_map.getCreatureById(creatureId)

		if creature then
			local lastState = widget.hidden

			if not BattleList.updateCreatureAvailability(creature) and BattleList.sortingType == 4 then
				BattleList:updateCreatureWidget(widget, creature)
			end

			if lastState ~= widget.hidden then
				debugPrint("[Player] The creature: ", creature:getName(), Position.tostring(newPos), widget.hidden and " is now hidden!" or " showed up!")
			end
		end
	end
end

function BattleList:fitFilters()
	for creatureId, widget in pairs(self.widgetsByCreatureId) do
		local creature = g_map.getCreatureById(creatureId)

		if creature then
			self:fitFilter(widget, creature)
		end
	end
end

function BattleList:hasCreature(creature)
	return self.widgetsByCreatureId[creature:getId()]
end

function BattleList:addCreature(creature)
	local player = g_game.getLocalPlayer()

	if not player then
		debugPrint("[BattleList.addCreature] ERROR! 0")

		return
	end

	if creature:isNpc() then
		return
	end

	if player:getId() == creature:getId() then
		return
	end

	if player:isInDuel() and not g_game.isDuelParticipant(creature:getId()) then
		return
	end

	local hidden = false
	local creaturePos = creature:getPosition()
	local playerPos = player:getPosition()

	if not playerPos or playerPos.z ~= creaturePos.z or not Position.canSee(playerPos, creaturePos) then
		hidden = true
	end

	local widget = g_ui.createWidget("BattleListCreature", self.content.creatures.list)

	function widget.onMousePress(widget, mousePos, mouseButton)
		if g_keyboard.isCtrlPressed() then
			if mouseButton == MouseRightButton then
				local creature = g_map.getCreatureById(widget.creatureId)

				if creature then
					modules.game_interface.processMouseAction(mousePos, mouseButton, nil, creature, creature, creature, creature)
				end
			end
		elseif mouseButton == MouseLeftButton then
			self:doTargetAction(widget, false)
		elseif mouseButton == MouseRightButton then
			self:doTargetAction(widget, true)
		end
	end

	widget.creatureId = creature:getId()

	if hidden then
		widget:setVisible(not hidden)
	end

	widget.hidden = hidden
	self.widgetsByCreatureId[creature:getId()] = widget

	debugPrint("[Added] The creature: ", creature:getId(), creature:getName(), Position.tostring(creaturePos), " was added!", hidden and " as invisible!" or " as visible!")
	self.content.creatures.list:getLayout():update()
	self:updateCreatureWidget(widget, creature)
	self:updateTargets()

	if not hidden then
		self:sort()
	end
end

function BattleList:removeCreature(creatureId)
	local widget = self.widgetsByCreatureId[creatureId]

	if not widget then
		return
	end

	debugPrint("[Removed] The creature: ", creatureId, creatureId, " was removed!")

	if widget.updateWidthEvent then
		removeEvent(widget.updateWidthEvent)
	end

	widget:destroy()

	self.widgetsByCreatureId[creatureId] = nil
end

function BattleList:getDistance(p1, p2)
	if not p1 or not p2 then
		return 100
	end

	return p1.z ~= p2.z and 15 or 0 + math.max(math.abs(p1.x - p2.x), math.abs(p1.y - p2.y))
end

function BattleList:updateCreatureWidget(widget, creature)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	widget.healthPercent = creature:getHealthPercent()
	widget.manaPercent = creature:getManaPercent()
	widget.level = creature:getLevel()
	widget.distance = self:getDistance(player:getPosition(), creature:getPosition())
	widget.name = creature:getName()
	widget.creatureId = creature:getId()

	widget.healthBar.creatureName:setText(widget.name)

	local stringSize = string.len(widget.name)
	local averageWidthPerChar = widget.healthBar.creatureName:getTextSize().width / stringSize

	if widget.healthBar.creatureName:getTextSize().width > widget.healthBar.creatureName:getWidth() then
		local amountToBeReduced = math.floor((widget.healthBar.creatureName:getTextSize().width - widget.healthBar.creatureName:getWidth()) / averageWidthPerChar) + 3

		widget.healthBar.creatureName:setText(string.format("%s...", widget.name:sub(1, stringSize - amountToBeReduced)))
	end

	if creature:isPlayer() and creature:isPartyMember() then
		widget.healthBar.mana:show()
		widget.healthBar.health:setOn(false)

		widget.healthBar.party = true
	else
		widget.healthBar.mana:hide()
		widget.healthBar.health:setOn(true)

		widget.healthBar.party = false
	end

	local outfit = creature:getOutfit()

	outfit.wagonActive = 0

	widget.icon:setOutfit(outfit)

	local iconSize = widget.icon:getSize()
	local exactSize = math.max(TILE_SIZE, creature:getThingType():getExactSize())
	local scale = iconSize.width / exactSize - 0.08
	local offset = -4

	if exactSize > TILE_SIZE * 3 then
		scale = scale + 0.12
		offset = exactSize / 4
	elseif exactSize > TILE_SIZE * 2 then
		scale = scale + 0.25
		offset = exactSize / 2.8
	end

	widget.icon:setOutfitOffset({
		x = exactSize - TILE_SIZE - offset,
		y = exactSize - TILE_SIZE - offset
	})
	widget.icon:setOutfitScale(scale)
	self:updateHealthBarBackground(widget)
	self:fitFilter(widget, creature)
end

function BattleList:sort()
	debugPrint("[BattleList.sort] sorting!")

	if BattleList.isHoveringTheBattleList then
		return
	end

	local widgets = self.content.creatures.list:getChildren()

	table.sort(widgets, self.sortFunction)
	self.content.creatures.list:reorderChildren(widgets)
end

function BattleList.sortFunction(a, b)
	local self = BattleList

	if self.sortingType == self.SORTING_TYPE.NAME then
		local nameA = a.name:lower()
		local nameB = b.name:lower()

		if nameA == nameB then
			return a.creatureId < b.creatureId
		end

		if self.sortingOrder == self.SORTING_ORDER.DESCENDING then
			return nameB < nameA
		else
			return nameA < nameB
		end
	elseif self.sortingType == self.SORTING_TYPE.DISTANCE then
		if a.distance == b.distance then
			return a.creatureId < b.creatureId
		end

		if self.sortingOrder == self.SORTING_ORDER.DESCENDING then
			return a.distance < b.distance
		else
			return a.distance > b.distance
		end
	elseif self.sortingType == self.SORTING_TYPE.HEALTH then
		if a.healthPercent == b.healthPercent then
			return a.creatureId < b.creatureId
		end

		if self.sortingOrder == self.SORTING_ORDER.DESCENDING then
			return a.healthPercent < b.healthPercent
		else
			return a.healthPercent > b.healthPercent
		end
	elseif self.sortingType == self.SORTING_TYPE.LEVEL then
		if a.level == b.level then
			return a.creatureId < b.creatureId
		end

		if self.sortingOrder == self.SORTING_ORDER.DESCENDING then
			return a.level < b.level
		else
			return a.level > b.level
		end
	else
		return a.name:lower() < b.name:lower()
	end
end

function BattleList:fitFilter(widget, creature)
	if creature:isHidden() and not widget.hidden then
		widget.hidden = true

		widget:hide()

		return
	end

	if widget.hidden then
		if widget:isVisible() then
			widget:hide()
		end

		return
	end

	if (not table.empty(g_game.getDuelFriends()) or not table.empty(g_game.getDuelEnemies())) and not g_game.isDuelParticipant(creature:getId()) then
		if widget:isVisible() then
			widget:hide()
		end

		return
	end

	if creature:isPlayer() then
		local canSee = false

		canSee = bit.band(self.playerFilter, self.FILTERS.PLAYERS.PARTY_MEMBERS) == self.FILTERS.PLAYERS.PARTY_MEMBERS and creature:isPartyMember() or canSee
		canSee = bit.band(self.playerFilter, self.FILTERS.PLAYERS.PLAYER_WITH_TRADEPACK) == self.FILTERS.PLAYERS.PLAYER_WITH_TRADEPACK and creature:hasTradepacks() or canSee
		canSee = not canSee and bit.band(self.playerFilter, self.FILTERS.PLAYERS.PLAYER_WITH_WAGON) == self.FILTERS.PLAYERS.PLAYER_WITH_WAGON and creature:isWagonToggled() or canSee
		canSee = not canSee and bit.band(self.playerFilter, self.FILTERS.PLAYERS.PLAYER_WITH_PK) == self.FILTERS.PLAYERS.PLAYER_WITH_PK and creature:getSkull() > SkullNone or canSee
		canSee = not canSee and bit.band(self.playerFilter, self.FILTERS.PLAYERS.OTHER_PLAYERS) == self.FILTERS.PLAYERS.OTHER_PLAYERS and not creature:isPartyMember() and not creature:hasTradepacks() and not creature:isWagonToggled() and creature:getSkull() == SkullNone or canSee

		widget:setVisible(canSee)

		return
	elseif creature:isMonster() then
		local canSee = false

		canSee = bit.band(self.monsterFilter, self.FILTERS.MONSTERS.BOSSES) == self.FILTERS.MONSTERS.BOSSES and creature:isBoss() or canSee
		canSee = not canSee and bit.band(self.monsterFilter, self.FILTERS.MONSTERS.NON_BOSSES) == self.FILTERS.MONSTERS.NON_BOSSES and not creature:isBoss() or canSee

		widget:setVisible(canSee)

		return
	end
end

function BattleList.hoverCreatureOnBattleList(widget, isHovering)
	if isHovering then
		BattleList.isHoveringTheBattleList = true

		local target = g_map.getCreatureById(widget.creatureId)

		if target then
			modules.game_interface.addMouseAttackCandidate(target, true)
		end
	else
		BattleList.isHoveringTheBattleList = false

		modules.game_interface.clearMouseAttackCandidate(true)
	end
end

function BattleList:onSortPanelClick(widget, state)
	if self.popupMenu then
		self.popupMenu:destroy()

		self.popupMenu = nil
	end

	self.popupMenu = g_ui.createWidget("BattleListSortPopupMenu")

	local displayPos = widget:getPosition()

	displayPos.y = displayPos.y + widget:getHeight() + 4
	displayPos.x = displayPos.x + 10

	self.popupMenu:setFocusable(false)
	self.popupMenu:display(displayPos, true)

	local currentSortCategory = g_settings.getString("battle-order", self.sortingCategories[1].name:lower())

	for _, sortingCategory in ipairs(self.sortingCategories) do
		local categoryWidget = g_ui.createWidget("BattleListSortOption", self.popupMenu.content)

		categoryWidget:setId(sortingCategory.name:lower())
		categoryWidget.name:setText(sortingCategory.name:titleCase())

		function categoryWidget.onFocusChange(focusWidget, focused, reason)
			categoryWidget.name:setOn(focused)
			categoryWidget.radio:setOn(focused)

			if focused and reason ~= ActiveFocusReason then
				g_settings.set("battle-order", sortingCategory.name:lower())
				g_settings.save()

				self.sortingType = sortingCategory.sortType
			end

			self:sort()
		end
	end

	local toFocus = self.popupMenu.content:getChildById(currentSortCategory)

	if toFocus:isFocused() then
		toFocus.onFocusChange(toFocus, true)
	else
		toFocus:focus()
	end

	self:updateOrderDirection()
end

function BattleList:onFilterPanelClick(widget, state)
	if self.popupMenu then
		self.popupMenu:destroy()

		self.popupMenu = nil
	end

	self.popupMenu = g_ui.createWidget("BattleListFilterPopupMenu")
	self.popupMenu.lastWidth = widget:getWidth()

	local disconnects = {}

	table.insert(disconnects, connect(self.window, {
		onVisibilityChange = function(widget, visible)
			if not visible and self.popupMenu then
				self.popupMenu:destroy()

				self.popupMenu = nil
			end
		end
	}))
	table.insert(disconnects, connect(g_ui.getRootWidget(), {
		onMousePress = function(widget, mousePos)
			if not self.popupMenu then
				return
			end

			if not self.popupMenu:containsPoint(mousePos) then
				if self.popupMenu.menu then
					if not self.popupMenu.popup:containsPoint(mousePos) then
						self.popupMenu.popup:destroy()

						self.popupMenu.popup = nil
					end

					return
				end

				self.popupMenu:destroy()

				self.popupMenu = nil
			end
		end
	}))
	connect(self.popupMenu, {
		onDestroy = function()
			widget:setOn(false)

			if self.popupMenu.popup then
				self.popupMenu.popup:destroy()

				self.popupMenu.popup = nil
			end

			for _, widgets in ipairs(disconnects) do
				for _, disconnect in ipairs(widgets) do
					disconnect()
				end
			end
		end
	})

	for _, filter in ipairs(self.filtersCategories) do
		self.popupMenu:addOption(filter:titleCase(true), function(option)
			if self.popupMenu.currentSelectedOption then
				self.popupMenu.currentSelectedOption:setOn(false)
			end

			option:setOn(true)

			self.popupMenu.currentSelectedOption = option

			BattleList:createExpandedFilterPopup(self.popupMenu, option, filter)
		end, nil, true)
		self.popupMenu:addSeparator()
	end

	g_ui.createWidget("BattleListFilterPopupMenuClearAll", self.popupMenu)

	local displayPos = widget:getPosition()

	displayPos.y = displayPos.y + widget:getHeight() + 4
	displayPos.x = displayPos.x + 10

	self.popupMenu:setFocusable(false)
	self.popupMenu:display(displayPos, true)
	self.popupMenu.clear_button:setEnabled(not table.empty(self.activeFilters))

	for _, category in ipairs(self.filtersCategories) do
		category = category:lower()

		local filters = self.activeFilters[category]

		if filters then
			local option = self.popupMenu:getChildById(category)

			for _, filterConfig in ipairs(self.filtersForCategory[category]) do
				local filterName = filterConfig.name:lower()

				if filters[filterName] then
					local label = g_ui.createWidget("BattleListFilterPopupMenuSubItem", option.content)

					label:setText(string.format("    %s", tr(filterConfig.name)))
					label:setId(filterName)

					option.content.filters = option.content.filters or {}
					option.content.filters[filterName] = true
				end
			end

			local height = 30

			for _, child in ipairs(option.content:getChildren()) do
				height = height + child:getHeight()
			end

			option:setHeight(height)
		end
	end
end

function BattleList:onFilterPanelCheckboxChange(widget, state)
	local categoryFilter = self.popupMenu

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

	local changedCategory = selectedCategory:getId():lower()
	local changedFilter = widget:getParent():getId():lower()
	local filterConfig = widget:getParent().config

	self.activeFilters[changedCategory] = self.activeFilters[changedCategory] or {}
	self.activeFilters[changedCategory][changedFilter] = state and filterConfig or nil

	if changedCategory == "players" then
		if state then
			self.playerFilter = bit.bor(self.playerFilter, widget.filterId)
		else
			self.playerFilter = bit.band(self.playerFilter, bit.bnot(widget.filterId))
		end
	elseif changedCategory == "monsters" then
		if state then
			self.monsterFilter = bit.bor(self.monsterFilter, widget.filterId)
		else
			self.monsterFilter = bit.band(self.monsterFilter, bit.bnot(widget.filterId))
		end
	end

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

	if table.empty(self.activeFilters[changedCategory]) then
		self.activeFilters[changedCategory] = nil
	end

	categoryFilter.clear_button:setEnabled(not table.empty(self.activeFilters))
	self:fitFilters()
end

function BattleList:clearAllFilters()
	self.activeFilters = {}

	if not self.popupMenu then
		return
	end

	self.popupMenu.clear_button:setEnabled(false)

	for _, child in ipairs(self.popupMenu:getChildren()) do
		if child.content then
			child.content.filters = nil

			child.content:destroyChildren()
			child:setHeight(30)
		end
	end

	self.playerFilter = 0
	self.monsterFilter = 0

	self:fitFilters()
end

function BattleList:createExpandedFilterPopup(menu, parentOption, category)
	local options = self.filtersForCategory[category:lower()]

	if not options then
		return
	end

	menu.popup = g_ui.createWidget("BattleListFilterPopupMenu")

	for _, optionConfig in ipairs(options) do
		local option = menu.popup:addOption(optionConfig.name, function()
			return
		end, nil, true, "BattleListFilterPopupMenuButtonExpanded")

		option.checkbox.filterId = optionConfig.filterId
		option.config = optionConfig

		self:loadFilterStates(parentOption:getId():lower(), option)
	end

	connect(menu.popup, {
		onDestroy = function()
			parentOption:setOn(false)
		end
	})

	local displayPos = menu:getPosition()

	displayPos.x = displayPos.x + menu.popup:getWidth() + 5

	menu.popup:setFocusable(false)
	menu.popup:display(displayPos, true)
end

function BattleList:loadSavedFilters()
	self.playerFilter = g_settings.getNumber("battle-player-filter", self.playersAllFlags)
	self.monsterFilter = g_settings.getNumber("battle-monster-filter", self.monstersAllFlags)

	for category, categoryFilters in pairs(self.filtersForCategory) do
		local filters = {}
		local flags = category == "players" and self.playerFilter or self.monsterFilter

		for _, filter in ipairs(categoryFilters) do
			if bit.band(flags, filter.filterId) == filter.filterId then
				filters[filter.name:lower()] = filter
			end
		end

		if not table.empty(filters) then
			self.activeFilters[category:lower()] = filters
		end
	end

	local height = g_settings.getNumber("battle-list-height", 300)

	self.window:setHeight(height)

	local width = g_settings.getNumber("battle-list-width", 218)

	self.window:setWidth(width)
end

function BattleList:saveFilters()
	g_settings.set("battle-player-filter", self.playerFilter)
	g_settings.set("battle-monster-filter", self.monsterFilter)
	g_settings.set("battle-list-height", self.window:getHeight())
	g_settings.set("battle-list-width", self.window:getWidth())
	g_settings.save()
end

function BattleList:loadFilterStates(parentCategory, optionWidget)
	local filters = self.activeFilters[parentCategory]

	if not filters then
		return
	end

	local filterName = optionWidget:getId():lower()

	if filters[filterName] then
		optionWidget.checkbox:setChecked(true, true)
	end
end

function BattleList:doTargetAction(widget, attack)
	local creatureId = widget.creatureId
	local target = g_map.getCreatureById(creatureId)

	if not target then
		return
	end

	if g_game.isInCutsceneMode() or g_game.isInShip() then
		return
	end

	if attack and target:isPartyMember() and not g_game.isInDuelMode() then
		attack = false
	end

	if not attack and not target:isPlayer() then
		attack = true
	end

	if attack then
		local currentAttacking = g_game.getAttackingCreature()

		if currentAttacking and currentAttacking:getId() == creatureId then
			g_game.cancelAttack()

			return
		end

		if target:isPartyMember() and not g_game.isInDuelMode() or target:isInShip() then
			return
		end

		g_game.attack(target)
	else
		if not target:isPlayer() then
			return
		end

		local currentHealing = g_game.getHealingCreature()

		if currentHealing and currentHealing:getId() == target:getId() then
			g_game.heal()

			return
		end

		g_game.heal(target)
	end
end

function BattleList:updateTargets()
	if self.previousHealing then
		local widget = self.widgetsByCreatureId[self.previousHealing:getId()]

		if widget then
			widget.healthBar.healing = false

			self:updateHealthBarBackground(widget)
		end
	end

	if self.previousAttacking then
		local widget = self.widgetsByCreatureId[self.previousAttacking:getId()]

		if widget then
			widget.healthBar.attacking = false

			self:updateHealthBarBackground(widget)
		end
	end

	local attacking = g_game.getAttackingCreature()
	local healing = g_game.getHealingCreature()

	if healing then
		local widget = self.widgetsByCreatureId[healing:getId()]

		if widget then
			widget.healthBar.healing = true

			self:updateHealthBarBackground(widget)
		end
	end

	if attacking then
		local widget = self.widgetsByCreatureId[attacking:getId()]

		if widget then
			widget.healthBar.attacking = true

			self:updateHealthBarBackground(widget)
		end
	end

	self.previousAttacking = attacking
	self.previousHealing = healing
end

function BattleList:updateHealthBarBackground(widget)
	if widget.healthBar.party then
		if widget.healthBar.attacking then
			widget.healthBar:setImageSource("/images/ui/windows/battle/creature_background_hp_mp_attack")
		elseif widget.healthBar.healing then
			widget.healthBar:setImageSource("/images/ui/windows/battle/creature_background_hp_mp_heal")
		else
			widget.healthBar:setImageSource("/images/ui/windows/battle/creature_background_hp_mp")
		end
	elseif widget.healthBar.attacking then
		widget.healthBar:setImageSource("/images/ui/windows/battle/creature_background_hp_attack")
	elseif widget.healthBar.healing then
		widget.healthBar:setImageSource("/images/ui/windows/battle/creature_background_hp_heal")
	else
		widget.healthBar:setImageSource("/images/ui/windows/battle/creature_background_hp")
	end

	widget.updateWidthEvent = addEvent(function()
		self:onUpdateWidgetWidth(widget)
	end)
end

function BattleList:changeOrderDirection()
	if self.sortingOrder == self.SORTING_ORDER.ASCENDING then
		self.sortingOrder = self.SORTING_ORDER.DESCENDING
	else
		self.sortingOrder = self.SORTING_ORDER.ASCENDING
	end

	self:updateOrderDirection()
	self:sort()
end

function BattleList:onUpdateWidgetWidth(widget)
	if not widget.healthBar then
		return
	end

	if widget:getStyleName() == "BattleListCreature" then
		widget.healthBar.health:setWidth(widget.healthBar:getWidth() - 45)
		widget.healthBar.mana:setWidth(widget.healthBar:getWidth() - 45)

		if widget.healthPercent then
			widget.healthBar.health:setPercentage(widget.healthPercent, 100)

			if widget.healthBar.mana:isVisible() then
				widget.healthBar.mana:setPercentage(widget.manaPercent, 100)
			end
		end
	end
end

function BattleList:onUpdateWindowWidth()
	local children = self.window.content.creatures.list:getChildren()

	for _, child in pairs(children) do
		local creature = g_map.getCreatureById(child.creatureId)

		if not child.hidden and creature then
			BattleList:updateCreatureWidget(child, creature)
		end
	end
end

function BattleList:updateOrderDirection()
	local ascending = self.sortingOrder == self.SORTING_ORDER.ASCENDING

	self.popupMenu.header.orderDirectionIcon:setOn(ascending)
	self.popupMenu.header.orderDirection:setOn(ascending)
end

function update()
	local isEditMode = g_layout.isEditMode()

	BattleList.window:recursiveGetChildById("editModeBackground"):setVisible(isEditMode)
	BattleList.content:setPhantom(true)
end

function BattleList:onDragEnter(mousePos)
	if not g_layout.isEditMode() then
		return
	end

	local oldPos = self:getPosition()

	self.movingReference = {
		x = mousePos.x - oldPos.x,
		y = mousePos.y - oldPos.y
	}

	self:setPosition(oldPos)
	self:breakAnchors()

	return true
end

function BattleList:onDragMove(mousePos, mouseMoved)
	local pos = {
		x = mousePos.x - self.movingReference.x,
		y = mousePos.y - self.movingReference.y
	}

	g_layout.snapToGrid(pos)
	self:setPosition(pos)
	self:bindRectToParent()
end
