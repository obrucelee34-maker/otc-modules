-- chunkname: @/modules/game_questlog/questlog.lua

GameQuestLog = {
	eventSearchFilterDelay = 250,
	ascSorting = true,
	currentTab = {},
	protocolItems = {},
	questIdToName = {}
}

function GameQuestLog:init()
	g_ui.importStyle("styles/completed_quests")
	g_ui.importStyle("styles/current_quests")
	g_ui.importStyle("styles/main")
	g_ui.importStyle("styles/questinfo")
	g_ui.importStyle("styles/hudwindow")
	runinsandbox("tracker.lua")

	local HUDPanel = modules.game_interface.getHUDPanel()

	self.window = g_ui.createWidget("GameQuestLogWindow", HUDPanel)

	self.window:hide()

	self.expandedQuestInfoWindow = g_ui.createWidget("GameQuestInfoWindow", HUDPanel)

	self.expandedQuestInfoWindow:setAttachedTo(self.window)
	self.expandedQuestInfoWindow:setVisible(true)
	ProtocolGame.registerExtendedOpcode(ExtendedIds.Quest, self.onQuestExtendedOpcode)
	connect(g_game, {
		onGameEnd = GameQuestLog.offline,
		onGameStart = GameQuestLog.requestQuests,
		onProtocolItem = GameQuestLog.onProtocolItem
	})
	initQuestTracker()

	if g_game.isOnline() then
		self.requestQuests()
	end

	DynamicEvent:init()
end

function GameQuestLog:terminate()
	DynamicEvent:terminate()
	self.window:destroy()
	self.expandedQuestInfoWindow:destroy()
	removeEvent(self.eventSearchFilter)
	taskListHud:destroy()
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.Quest)
	disconnect(g_game, {
		onGameEnd = GameQuestLog.offline,
		onGameStart = GameQuestLog.requestQuests,
		onProtocolItem = GameQuestLog.onProtocolItem
	})
	saveHiddenActiveQuestsSettings()
end

function update()
	local isEditMode = g_layout.isEditMode()

	taskListHud:recursiveGetChildById("editModeBackground"):setVisible(isEditMode)
	taskListHud.quests:setPhantom(isEditMode)

	for _, child in ipairs(taskListHud.quests:getChildren()) do
		child:setPhantom(isEditMode)
		child.taskListPanel:setPhantom(isEditMode)
		child.name:setPhantom(isEditMode)

		for _, task in ipairs(child.taskListPanel:getChildren()) do
			task:setPhantom(isEditMode)
		end
	end

	DynamicEvent:update()
end

function GameQuestLog.offline()
	taskListHud:hide()
	taskListHud.quests:destroyChildren()
	GameQuestLog.window.content.completedquests_panel.panel:destroyChildren()
	GameQuestLog.window.content.currentquests_panel.panel:destroyChildren()
	GameQuestLog.window.gameQuestlogTopWidget.filterWidget.textEdit:setText("")

	GameQuestLog.protocolItems = nil
end

function GameQuestLog.isEnabled()
	return not g_game.isAetherRiftChannel() and not g_game.isGuildWarsChannel()
end

function GameQuestLog.toggle(mouseClick)
	if GameChat:isActive() or (type(mouseClick) ~= "boolean" or not mouseClick) and IsTextEditActive() then
		return
	end

	if not GameQuestLog.window:isVisible() then
		if g_game:isInCutsceneMode() or not GameQuestLog.isEnabled() then
			return
		end

		GameQuestLog.window.content.completedquests_panel.panel:destroyChildren()
		GameQuestLog.window.content.currentquests_panel.panel:destroyChildren()
		GameQuestLog.requestQuests()
		GameQuestLog.window:show()
		GameQuestLog.window:raise()
		GameQuestLog.window:focus()
	else
		GameQuestLog.window:hide()
	end
end

function GameQuestLog.open()
	if GameQuestLog.window:isVisible() then
		return
	end

	GameQuestLog.window.content.completedquests_panel.panel:destroyChildren()
	GameQuestLog.window.content.currentquests_panel.panel:destroyChildren()
	GameQuestLog.requestQuests()
	GameQuestLog.window:show()
	GameQuestLog.window:raise()
	GameQuestLog.window:focus()
end

function GameQuestLog.close()
	GameQuestLog.window:hide()
end

function GameQuestLog:selectTab(tabName)
	if self.currentTab.name == tabName then
		return
	end

	if self.currentTab.selectionWidget then
		self.currentTab.selectionWidget:setOn(false)
	end

	self.currentTab.name = tabName
	self.currentTab.selectionWidget = self.window.gameQuestlogTopWidget.selectionPanel[tabName]

	self.currentTab.selectionWidget:setOn(true)

	if self.currentTab.tabWidget then
		self.currentTab.tabWidget:hide()
	end

	self.currentTab.tabWidget = self.window.content[string.format("%s_panel", tabName)]

	self.currentTab.tabWidget:show()
	self.expandedQuestInfoWindow:hide()
	self:onSearchFilterChange(self.window.gameQuestlogTopWidget.filterWidget.textEdit:getText(), true)
	GameQuestLog:sortQuests()
end

function GameQuestLog:showQuestInfoWindow()
	self.expandedQuestInfoWindow:show()
	self.expandedQuestInfoWindow:followParent()
end

function GameQuestLog:hideQuestInfoWindow()
	if not self.expandedQuestInfoWindow then
		return
	end

	self.expandedQuestInfoWindow:hide()
end

local function callbackSearchFilter(widget, text)
	GameQuestLog.eventSearchFilter = nil
	text = text:lower()

	for _, child in ipairs(widget:getChildren()) do
		local questNameLabel = child.questNameLabel

		if questNameLabel then
			local _text = questNameLabel:getText():lower()

			child:setVisible(_text:find(text))
		end
	end
end

function GameQuestLog:onSearchFilterChange(text, withoutDelay)
	if not self.currentTab.tabWidget then
		return true
	end

	local widget = self.currentTab.tabWidget.panel

	removeEvent(self.eventSearchFilter)

	if withoutDelay then
		self.eventSearchFilter = nil

		callbackSearchFilter(widget, text)

		return true
	end

	self.eventSearchFilter = scheduleEvent(function()
		callbackSearchFilter(widget, text)
	end, self.eventSearchFilterDelay)
end

function GameQuestLog:sortQuests()
	if not self.currentTab.tabWidget then
		return true
	end

	if not self.sortFunction then
		return false
	end

	local widget = self.currentTab.tabWidget.panel
	local children = widget:getChildren()

	table.sort(children, function(a, b)
		local ret = self.sortFunction(a, b)

		if self.ascSorting then
			return ret[2]
		end

		return not ret[1] and not ret[2]
	end)
	widget:reorderChildren(children)
end

function GameQuestLog.requestQuests()
	local self = GameQuestLog
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.Quest, g_game.serializeTable({
			action = "quests"
		}))
	end
end

function GameQuestLog:requestQuestInfo(questId, questType)
	if not questId or not questType then
		return
	end

	local attachedWindow = self.expandedQuestInfoWindow

	attachedWindow.questId = questId
	attachedWindow.questType = questType

	if questType == "rangers_company" then
		self:onRangersCompanyQuestDetails()

		return
	elseif questType == "north_star" then
		self:onNorthStarQuestDetails()

		return
	end

	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.Quest, g_game.serializeTable({
			action = "details",
			id = questId,
			type = questType
		}))
	end
end

function GameQuestLog:requestCompass(questName, taskId)
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.Quest, g_game.serializeTable({
			action = "compass",
			questName = questName,
			taskId = taskId
		}))
	end
end

function GameQuestLog:removeQuestTaskCompass(questName, taskId)
	if not questName then
		return
	end

	g_worldMap.removeCompassData(questName, taskId)

	local widget = getQuestEntry(questName, taskId)

	if not widget then
		return
	end

	if not widget.compassData then
		return
	end

	widget.compassData = nil
end

function GameQuestLog:showQuestCompass(questName)
	if not questName then
		return
	end

	g_worldMap.displayQuestTaskCompass(questName)
end

function GameQuestLog:showQuestTaskCompass(questName, taskId)
	if not questName or not taskId then
		return
	end

	g_worldMap.displayQuestTaskCompass(questName, taskId)
end

function GameQuestLog:getQuestTaskCompassData(questName, taskId)
	local widget = getQuestEntry(questName, taskId)

	if not widget then
		return nil
	end

	return widget.compassData
end

function GameQuestLog:isQuestCompleted(questName)
	local completedWidget = GameQuestLog.window.content.completedquests_panel

	if not completedWidget then
		return nil
	end

	questName = GameQuestLog.questIdToName[questName] or questName

	return completedWidget.panel:getChildById(questName)
end

function GameQuestLog:isQuestActive(questName)
	local widget = getQuestWidget(questName)

	return widget and not widget.fadeEvent
end

function GameQuestLog:isQuestTasksActive(questName, tasks, ignoreFade)
	local widget = getQuestEntry(questName, tasks)

	return widget and (ignoreFade or not widget.fadeEvent)
end

function GameQuestLog:isEventActive(eventName)
	local activeEvent = DynamicEvent.activeEvent

	return activeEvent and activeEvent.name:lower() == eventName:lower()
end

function GameQuestLog:isEventStageActive(eventName, stages)
	if not self:isEventActive(eventName) then
		return false
	end

	local activeEvent = DynamicEvent.activeEvent
	local taskId = activeEvent and activeEvent.tasks and activeEvent.tasks[1] and (activeEvent.tasks[1].taskId or -1)

	if type(stages) == "table" then
		return table.contains(stages, taskId)
	else
		return stages == taskId
	end
end

function GameQuestLog.onQuests(data)
	if not data.quests then
		return
	end

	if data.quests.complete then
		local completedWidget = GameQuestLog.window.content.completedquests_panel

		completedWidget.panel:destroyChildren()

		for _, d in ipairs(data.quests.complete) do
			local widget = g_ui.createWidget("GameCharacterCompletedQuestsPanelWidget", completedWidget.panel)

			widget:setId(d.name)

			widget.level = d.level or 0
			widget.questType = "complete"
			widget.questId = d.id
			widget.questName = d.name

			widget.questNameLabel:setText(string.format("%s", d.name))

			GameQuestLog.questIdToName[d.id] = d.name
		end
	end

	local localPlayer = g_game.getLocalPlayer()
	local playerLevel = localPlayer and localPlayer:getLevel() or 0
	local currentWidget = GameQuestLog.window.content.currentquests_panel

	currentWidget.panel:destroyChildren()

	if data.quests.rangers_company and not table.empty(data.quests.rangers_company) then
		local task = data.quests.rangers_company[1]
		local widget = g_ui.createWidget("GameCharacterCurrentQuestsPanelWidget", currentWidget.panel)

		widget.questType = "rangers_company"
		widget.questId = 0
		widget.level = task.level
		widget.questName = task.name

		widget.questNameLabel:setColoredText(GetHighlightedText(string.format("%s {[%s], #36f991}", task.name, "Rangers Company"), "white"))

		if task.level and task.level.min and task.level.max then
			widget.questLevelLabel:setText(string.format("[%i-%i]", task.level.min, task.level.max))
			widget.questLevelLabel:setTextColor("#A6AAB2")
		else
			widget.questLevelLabel:setText("")
		end

		local isEnabled = not getHiddenActiveQuestsSettings()[widget.questName]

		if isEnabled then
			setQuestWidgetVisibility(widget.questName, true, widget.trackerCheckBox)
		else
			setQuestWidgetVisibility(widget.questName, false, widget.trackerCheckBox)
		end

		GameQuestLog.rangersCompanyTask = task
	end

	if data.quests.north_star and not table.empty(data.quests.north_star) then
		local task = data.quests.north_star[1]
		local widget = g_ui.createWidget("GameCharacterCurrentQuestsPanelWidget", currentWidget.panel)

		widget.questType = "north_star"
		widget.questId = task.questId
		widget.level = task.level
		widget.questName = task.name

		widget.questNameLabel:setColoredText(GetHighlightedText(tr("%s {[%s], #FBFB79}", task.name, "North Star"), "white"))

		if task.level and task.level.min and task.level.max then
			widget.questLevelLabel:setText(string.format("[%i-%i]", task.level.min, task.level.max))
			widget.questLevelLabel:setTextColor("#A6AAB2")
		else
			widget.questLevelLabel:setText("")
		end

		local isEnabled = not getHiddenActiveQuestsSettings()[widget.questName]

		if isEnabled then
			setQuestWidgetVisibility(widget.questName, true, widget.trackerCheckBox)
		else
			setQuestWidgetVisibility(widget.questName, false, widget.trackerCheckBox)
		end

		GameQuestLog.northStarTask = task
	end

	if data.quests.active then
		for _, d in ipairs(data.quests.active) do
			local widget = g_ui.createWidget("GameCharacterCurrentQuestsPanelWidget", currentWidget.panel)

			widget.questType = "active"
			widget.level = d.level or 0
			widget.questId = d.id
			widget.questName = d.name

			widget.questNameLabel:setText(d.name)
			widget.questLevelLabel:setText(string.format("[%d]", d.level))

			local levelColor = "#A6AAB2"

			if widget.level == playerLevel then
				levelColor = "#77D463"
			elseif playerLevel < widget.level then
				levelColor = "#FFA851"

				if widget.level - playerLevel > 10 then
					levelColor = "#C24242"
				end
			end

			widget.questLevelLabel:setTextColor(levelColor)

			local isEnabled = not getHiddenActiveQuestsSettings()[widget.questName]

			if isEnabled then
				setQuestWidgetVisibility(widget.questName, true, widget.trackerCheckBox)
			end

			GameQuestLog.questIdToName[d.id] = d.name
		end
	end
end

function GameQuestLog.onQuestDetails(data)
	local localPlayer = g_game.getLocalPlayer()
	local attachedWindow = GameQuestLog.expandedQuestInfoWindow
	local content = attachedWindow.content

	content.questName:setText(data.name)
	content.descriptionPanel.generalDescription:setText(data.description)

	local player = g_game.getLocalPlayer()

	if player then
		local playerLevel = player:getLevel()
		local levelColor = "#a0a0a0"

		if data.level == playerLevel then
			levelColor = "#77D463"
		elseif playerLevel < data.level then
			levelColor = "#FFA851"

			if data.level - playerLevel > 10 then
				levelColor = "#C24242"
			end
		end

		content.descriptionPanel.recommendedLevel:setColoredText(GetHighlightedText(tr(string.format("Level |{[%i], %s}|", data.level, levelColor))), "white")
	end

	content.taskListPanel:destroyChildren()

	for id, task in ipairs(data.tasks) do
		task.taskId = id

		local widget = g_ui.createWidget("TaskListWidget", content.taskListPanel)

		widget.taskListDescription:setText(task.name)
		widget.checkBox:setChecked(task.state == 2)
	end

	if not data.rewards or not data.rewards[1] then
		content.rewardsTopPanel:hide()
		content.rewardsListPanel:hide()
		content.rewardsOnlyListPanel:hide()
		content.rewardsOnlyListLabel:hide()
		content.rewardsListLabel:hide()
	else
		content.rewardsListPanel:setHeight(0)
		content.rewardsOnlyListPanel:setHeight(0)
		content.rewardsListPanel:destroyChildren()
		content.rewardsOnlyListPanel:destroyChildren()

		local hasNormalReward = false
		local hasOnlyReward = false

		GameQuestLog.protocolItems = {}

		for _, reward in ipairs(data.rewards) do
			local widget = g_ui.createWidget("RewardWidget", reward.only_one and content.rewardsOnlyListPanel or content.rewardsListPanel)

			if tonumber(reward.id) then
				widget.item:setItemId(reward.id)
				widget.item:getItem():setName(reward.name)
				widget.item:getItem():setCount(reward.amount)
				widget.itemName:setText(reward.name)
				widget.itemCount:setText(reward.amount)

				GameQuestLog.protocolItems[reward.uid] = widget
			elseif reward.id == "silver" or reward.id == "experience" or reward.id == "reputation" then
				widget.item:setImageSource("/images/ui/icons/" .. reward.id)
				widget.itemName:setText(reward.name:titleCase())
				widget.itemCount:setText(format_number(reward.amount))
			end

			while widget.itemName:getTextSize().width > widget.itemName:getWidth() - 10 do
				widget.itemName:setText(string.format("%s...", widget.itemName:getText():sub(1, -5)), true)
			end

			if not reward.only_one then
				hasNormalReward = true
			else
				hasOnlyReward = true
			end
		end

		content.rewardsListPanel:setVisible(hasNormalReward)
		content.rewardsListLabel:setVisible(hasNormalReward)
		content.rewardsOnlyListPanel:setVisible(hasOnlyReward)
		content.rewardsOnlyListLabel:setVisible(hasOnlyReward)
		content.rewardsListLabel:setMarginTop(hasOnlyReward and 10 or -27)
		content.rewardsTopPanel:show()
	end

	attachedWindow.questName = data.name
	attachedWindow.lastTask = data.tasks[#data.tasks]

	content.taskListTopPanel.locationIcon:setVisible(attachedWindow.lastTask and attachedWindow.lastTask.compassUnlocked or false)

	function content.taskListTopPanel.locationIcon.onClick()
		GameQuestLog:showQuestCompass(attachedWindow.questName)
	end

	content.north_star_premium_reward_panel:setVisible(false)
	content.npcOutfit:resetOutfit()
	content.npcOutfit:setImageSource()
	content.npcName:setText("-")
	content.taskListPanel:show()
	content.taskListTopPanel:show()
	content.north_star_reward_panel:hide()
	content.rangers_company_reward_panel:hide()
	content.rangers_company_progress_panel:hide()
	content.north_star_premium_reward_panel:setVisible(false)
	content.get_premium_button:setVisible(false)
	content:onLayoutUpdate()
	attachedWindow.complete_north_star_quest:hide()
	attachedWindow:show()
	attachedWindow:followParent()
end

function GameQuestLog.onProtocolItem(item)
	if not GameQuestLog.protocolItems then
		return
	end

	local uid = item and item:getUUID()
	local widget = uid and GameQuestLog.protocolItems[uid]

	if widget then
		widget.item:setItem(item)

		GameQuestLog.protocolItems[uid] = nil
	end
end

function GameQuestLog.onQuestExtendedOpcode(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.Quest then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if not data or type(data) ~= "table" then
		return
	end

	if data.action == "quests" then
		GameQuestLog.onQuests(data)

		if taskListHud or DynamicEvent.window then
			local tb = {
				quests = data.quests.active,
				events = data.quests.dynamic,
				rangers_company = data.quests.rangers_company,
				north_star = data.quests.north_star
			}

			parseQuestTrackerData(tb)
			signalcall(GameQuestLog.onQuestsUpdate, tb)
			modules.game_interface.onUpdateActionKey(true)
		end
	elseif data.action == "details" then
		GameQuestLog.onQuestDetails(data)
	elseif data.action == "task_details" then
		if taskListHud or DynamicEvent.window then
			local tb = {
				action = "task_details"
			}

			if data.type == "quest" then
				tb.quests = data
			elseif data.type == "event" then
				tb.events = data
			elseif data.type == "rangers_company" then
				tb.rangers_company = data
				GameQuestLog.rangersCompanyTask = GameQuestLog.rangersCompanyTask or {}

				for _, quest in ipairs(data) do
					for __, task in ipairs(quest.tasks) do
						if task.progressTable then
							GameQuestLog.rangersCompanyTask.progressTable = task.progressTable
							GameQuestLog.rangersCompanyTask.progress = task.progressString
						end
					end
				end
			elseif data.type == "north_star" then
				tb.north_star = data
				GameQuestLog.northStarTask = GameQuestLog.northStarTask or {}

				if #data > 0 then
					GameQuestLog.northStarTask.tasks = data[1].tasks

					GameQuestLog:hideQuestInfoWindow()
				end
			end

			parseQuestTrackerData(tb)
			signalcall(GameQuestLog.onTaskUpdate, tb)
			modules.game_interface.onUpdateActionKey(true)

			local attachedWindow = GameQuestLog.expandedQuestInfoWindow

			if attachedWindow:isVisible() then
				GameQuestLog:requestQuestInfo(attachedWindow.questId, attachedWindow.questType)
			end
		end
	elseif data.type == "dynamic_event" then
		if data.action == "parse_events_info" then
			g_worldMap.onEventInfoChange(data)
		end

		return
	elseif data.action == "compass" then
		if data.remove then
			GameQuestLog:removeQuestTaskCompass(data.quest, data.taskId)
		else
			GameQuestLog:showQuestCompass(data.quest)
		end
	elseif data.action == "map_mark" then
		g_worldMap.parseQuestMarkData(data)
	end
end

function GameQuestLog:onRangersCompanyQuestDetails()
	local data = self.rangersCompanyTask
	local window = self.expandedQuestInfoWindow
	local content = window.content

	content.questName:setText(data.name)
	content.descriptionPanel.generalDescription:setText(data.description)

	local player = g_game.getLocalPlayer()

	if player then
		local playerLevel = player:getLevel()
		local avgLevel = (data.level.min + data.level.max) / 2
		local levelColor = "#a0a0a0"

		if avgLevel == playerLevel then
			levelColor = "#77D463"
		elseif playerLevel < avgLevel then
			levelColor = "#FFA851"

			if avgLevel - playerLevel > 10 then
				levelColor = "#C24242"
			end
		end

		content.descriptionPanel.recommendedLevel:setColoredText(GetHighlightedText(tr(string.format("Level |{[%i-%i], %s}|", data.level.min, data.level.max, levelColor))), "white")
	end

	content.rangers_company_progress_panel.progress_text:setText(data.progress)
	content.rangers_company_progress_panel.progress:setPercent(data.progressTable[1] / data.progressTable[2] * 100)
	content.rangers_company_progress_panel:show()
	content.north_star_premium_reward_panel:setVisible(false)
	content.get_premium_button:setVisible(false)

	local category = modules.game_rangerscompany.cfg.familyNameToCategory[data.family]

	content.npcOutfit:setImageSource(string.format("/images/ui/windows/rangers_company/icon_%s", category))
	content.npcOutfit:setImageSize({
		height = 45,
		width = 45
	})

	local x = (content.npcOutfit:getWidth() - content.npcOutfit:getImageSize().width) / 2
	local y = (content.npcOutfit:getHeight() - content.npcOutfit:getImageSize().height) / 2

	content.npcOutfit:setImageOffset({
		x = x,
		y = y
	})
	content.npcName:setText(data.regionName)
	content.taskListPanel:destroyChildren()
	content.taskListPanel:hide()
	content.taskListTopPanel:hide()
	content.rangers_company_reward_panel:show()
	content.rangers_company_reward_panel:destroyChildren()

	for idx, name in ipairs({
		"prestige points",
		"bounty marks"
	}) do
		local widget = g_ui.createWidget("RewardWidget", content.rangers_company_reward_panel)

		widget.item:setImageSource(string.format("/images/ui/windows/rangers_company/icon_%s_big", name:gsub(" ", "_")))
		widget.itemName:setText(name:titleCase())
		widget.itemCount:setText(idx == 1 and data.rewards.prestige or data.rewards.marks)
		widget.item:setSize({
			height = 35,
			width = 35
		})
		widget.item:setMarginLeft(5)
	end

	content.north_star_reward_panel:hide()
	content.rewardsTopPanel:hide()
	content.rewardsListPanel:hide()
	content.rewardsOnlyListPanel:hide()
	content.rewardsOnlyListLabel:hide()
	content.rewardsListLabel:hide()
	window.complete_north_star_quest:hide()
	window:show()
	window:followParent()
end

function GameQuestLog:onNorthStarQuestDetails()
	local data = self.northStarTask
	local window = self.expandedQuestInfoWindow
	local content = window.content

	content.questName:setText(data.name)
	content.descriptionPanel.generalDescription:setText(data.name)

	local player = g_game.getLocalPlayer()

	if player then
		local playerLevel = player:getLevel()
		local avgLevel = (data.level.min + data.level.max) / 2
		local levelColor = "#a0a0a0"

		if avgLevel == playerLevel then
			levelColor = "#77D463"
		elseif playerLevel < avgLevel then
			levelColor = "#FFA851"

			if avgLevel - playerLevel > 10 then
				levelColor = "#C24242"
			end
		end

		content.descriptionPanel.recommendedLevel:setColoredText(GetHighlightedText(tr(string.format("Legacy Level |{[%i-%i], %s}|", data.level.min, data.level.max, levelColor))), "white")
	end

	content.rangers_company_progress_panel:hide()
	content.npcOutfit:setImageSource("/images/ui/windows/questlog/icon_north_star")
	content.npcOutfit:setImageSize({
		height = 45,
		width = 45
	})

	local x = (content.npcOutfit:getWidth() - content.npcOutfit:getImageSize().width) / 2
	local y = (content.npcOutfit:getHeight() - content.npcOutfit:getImageSize().height) / 2

	content.npcOutfit:setImageOffset({
		x = x,
		y = y
	})
	content.npcName:setText("-")
	content.taskListPanel:destroyChildren()
	content.taskListPanel:hide()
	content.taskListTopPanel:hide()
	content.rangers_company_reward_panel:hide()
	content.north_star_reward_panel:show()
	content.north_star_reward_panel:destroyChildren()

	for _, reward in ipairs(data.rewards) do
		local widget = g_ui.createWidget("RewardWidget", content.north_star_reward_panel)

		if reward.clientId then
			widget.item:setItemId(reward.clientId)
			widget.item:getItem():setName(reward.name)
			widget.item:getItem():setCount(tonumber(reward.amount))
			widget.itemName:setText(reward.name)
			widget.itemCount:setText(reward.amount)
		elseif reward.silver then
			widget.item:setImageSource("/images/ui/icons/silver_30")
			widget.itemName:setText("Silver")
			widget.itemCount:setText(reward.silver)
		elseif reward.ravencard_pack then
			widget.item:setImageSource(string.format("/images/ui/windows/ravencards/packs/%s", g_game.isRavenQuest() and "ravenquest_pack_1" or "pack_1"))
			widget.itemName:setText("RavenPacks")
			widget.itemCount:setText(reward.ravencard_pack)
			widget.item:setSize({
				height = 35,
				width = 24
			})
			widget.item:setMarginLeft(10)
		elseif reward.dawn_essence then
			widget.item:setImageSource("/images/ui/windows/premium_store/icon_dawn_essence")
			widget.itemName:setText("Dawn Essence")
			widget.itemCount:setText(reward.dawn_essence)
		end
	end

	content.north_star_premium_reward_panel:setVisible(data.premium_rewards)

	local isPremium = g_game.getLocalPlayer():isPremium()

	content.north_star_premium_reward_panel:setChecked(not isPremium)
	content.get_premium_button:setVisible(not isPremium)

	if data.premium_rewards then
		content.north_star_premium_reward_panel:destroyChildren()

		for _, reward in ipairs(data.premium_rewards) do
			local widget = g_ui.createWidget("RewardWidget", content.north_star_premium_reward_panel)

			if reward.clientId then
				widget.item:setItemId(reward.clientId)
				widget.item:getItem():setName(reward.name)
				widget.item:getItem():setCount(reward.amount)
				widget.itemName:setText(reward.name)
				widget.itemCount:setText(reward.amount)
			elseif reward.silver then
				widget.item:setImageSource("/images/ui/icons/silver_30")
				widget.itemName:setText("Silver")
				widget.itemCount:setText(reward.silver)
			elseif reward.ravencard_pack then
				widget.item:setImageSource(string.format("/images/ui/windows/ravencards/packs/%s", g_game.isRavenQuest() and "ravenquest_pack_1" or "pack_1"))
				widget.itemName:setText("RavenPacks")
				widget.itemCount:setText(reward.ravencard_pack)
				widget.item:setSize({
					height = 35,
					width = 24
				})
				widget.item:setMarginLeft(10)
			elseif reward.dawn_essence then
				widget.item:setImageSource("/images/ui/windows/premium_store/icon_dawn_essence")
				widget.itemName:setText("Dawn Essence")
				widget.itemCount:setText(reward.dawn_essence)
			end

			widget:setEnabled(isPremium)
		end
	end

	window.complete_north_star_quest:show()
	window.complete_north_star_quest:setEnabled(data.tasks[1].finished)
	content.rewardsTopPanel:hide()
	content.rewardsListPanel:hide()
	content.rewardsOnlyListPanel:hide()
	content.rewardsOnlyListLabel:hide()
	content.rewardsListLabel:hide()
	window:show()
	window:followParent()
end

function GameQuestLog:onTaskDescriptionClicked(questName, taskId, questData)
	if questData.north_star then
		self:completeNorthStarQuest()
	end
end

function GameQuestLog:completeNorthStarQuest()
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.NorthStar, g_game.serializeTable({
			action = "complete_quest"
		}))
	end
end

function GameQuestLog:onCustomIconClicked(id)
	if id == "north_star" then
		self:open()
		self:onNorthStarQuestDetails()
	elseif id == "rangers_company" then
		self:open()
		self:onRangersCompanyQuestDetails()
	end
end
