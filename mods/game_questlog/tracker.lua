-- chunkname: @/modules/game_questlog/tracker.lua

taskListHud = nil
taskListHudQuests = {}
settings = nil

local hiddenQuests = {}
local rangersCompanyQuests = {}

function getHiddenActiveQuestsSettings()
	settings = settings or g_settings.getNode("HiddenActiveQuests")

	local localPlayer = g_game.getLocalPlayer()
	local playerName = localPlayer:getName()

	if not settings then
		settings = {}
	end

	if not settings[playerName] then
		settings[playerName] = {}
	end

	return settings[playerName]
end

function saveHiddenActiveQuestsSettings()
	if settings then
		g_settings.setNode("HiddenActiveQuests", settings)
	end
end

local function resize()
	if g_game.isOnline() and taskListHud:isVisible() then
		local height = 10 + taskListHud.quests:getHeight()

		if height ~= taskListHud:getHeight() then
			taskListHud:setHeight(height)
		end
	end
end

function initQuestTracker()
	taskListHud = g_ui.createWidget("TaskListHUD", modules.game_interface.getHUDPanel())

	if BGS_DEMO then
		taskListHud:setVisible(false)
		taskListHud:setEnabled(false)
	end

	taskListHud.onDragEnter = onDragEnter
	taskListHud.onDragMove = onDragMove

	cycleEvent(resize, 100)
end

local function showTaskAtTheEnd(description)
	if not description then
		return false
	end

	if string.match(description, "^%(Optional%)") then
		return true
	end

	return false
end

function parseQuestTrackerData(data)
	if not taskListHud then
		taskListHud = g_ui.createWidget("TaskListHUD", modules.game_interface.getHUDPanel())
	end

	local function configureQuest(quest)
		local questWidget = getQuestWidget(quest.name)

		if questWidget then
			local tasks = {}

			if quest.tasks and not table.empty(quest.tasks) then
				local compassTaskId

				for index, task in ipairs(quest.tasks) do
					local entry = getQuestEntry(quest.name, task.name)

					if entry then
						updateQuestEntry(quest.name, task)
					else
						addQuestEntry(quest.name, task)
					end

					table.insert(tasks, task.name)

					if not showTaskAtTheEnd(task.name) then
						compassTaskId = index
					end
				end

				questWidget.compass.taskId = compassTaskId
			end

			for __, child in ipairs(questWidget.taskListPanel:getChildren()) do
				if not table.find(tasks, child:getId()) then
					removeQuestEntry(quest.name, child:getId())
				end
			end

			questWidget.compass.questName = quest.name
		else
			questWidget = addQuestWidget(quest.name, quest.rangers_company, quest.north_star)

			if questWidget then
				questWidget.quest = quest

				local compassTaskId

				for index, task in ipairs(quest.tasks) do
					addQuestEntry(quest.name, task)

					if not showTaskAtTheEnd(task.name) then
						compassTaskId = index
					end
				end

				questWidget.compass.taskId = compassTaskId
				questWidget.compass.questName = quest.name
			end
		end
	end

	if data.quests then
		if data.action == "task_details" and data.quests.completed then
			removeQuestWidget(data.quests.name)

			return
		end

		for _, quest in pairs(data.quests) do
			configureQuest(quest)
		end
	end

	if data.rangers_company and not table.empty(data.rangers_company) then
		if data.action == "task_details" and data.rangers_company.remove then
			removeQuestWidget(data.rangers_company.name)
			g_worldMap.removeCompassData(data.rangers_company.name, 1)

			return
		end

		local quest = data.rangers_company[1]

		quest.rangers_company = true
		quest.tasks = quest.tasks or {
			{
				state = 1,
				taskId = 1,
				name = quest.description,
				compassUnlocked = quest.compassUnlocked,
				compassData = quest.compassData,
				progress = quest.progress,
				family = quest.family,
				region = quest.region,
				level = quest.level
			}
		}

		configureQuest(data.rangers_company[1])
	end

	if data.north_star and not table.empty(data.north_star) then
		if data.action == "task_details" and data.north_star.remove then
			removeQuestWidget(data.north_star.name)

			return
		end

		local quest = data.north_star[1]

		quest.north_star = true
		quest.tasks = quest.tasks or {
			{
				compassUnlocked = false,
				north_star = true,
				state = 1,
				taskId = 1,
				name = quest.name,
				finished = quest.finished
			}
		}

		configureQuest(data.north_star[1])
	end

	if data.events then
		DynamicEvent:parseData(data.action, data.events)
	end

	update()
	fadeInOut(taskListHud.quests:getChildCount())
end

function fadeInOut(quests, scheduled)
	if quests == 0 then
		g_effects.fadeOut(taskListHud, 1000, nil, false, function()
			taskListHud:hide()
		end)
	elseif not taskListHud:isVisible() and modules.game_settings.getOption("showQuestTracker") and not BGS_DEMO then
		taskListHud:show()
		g_effects.fadeIn(taskListHud, 1000)
	end

	if not scheduled then
		scheduleEvent(function()
			if not taskListHud then
				return
			end

			fadeInOut(taskListHud.quests:getChildCount(), true)
		end, 1000)
	end
end

function getQuestWidget(questName)
	local widget = taskListHud.quests:recursiveGetChildById(questName)

	return widget
end

function addQuestWidget(questName, rangersCompany, northStar)
	if not questName then
		return
	end

	local widget = g_ui.createWidget("TaskListHUDQuest", taskListHud.quests)

	widget:hide()
	widget:setId(questName)
	widget.name:setText(tr(questName))

	if rangersCompany then
		widget.name:setText(tr("%s [%s]", questName, "Rangers Company"))
		widget.name:setTextColor("#A556FF")

		widget.rangersCompany = true
	elseif northStar then
		widget.name:setText(tr("%s [%s]", questName, "North Star"))
		widget.name:setTextColor("#FBFB79")

		widget.northStar = true
	else
		widget.name:setTextColor("#36F991")
	end

	local settings = getHiddenActiveQuestsSettings()
	local isHidden = settings[questName] or table.find(hiddenQuests, questName:lower())
	local activeQuestCount = 0

	for _, quest in ipairs(taskListHud.quests:getChildren()) do
		if quest:isVisible() then
			activeQuestCount = activeQuestCount + 1
		end
	end

	if activeQuestCount >= 5 and not northStar and not rangersCompany then
		isHidden = true
		settings[questName] = true

		saveHiddenActiveQuestsSettings()
	end

	widget:setVisible(not isHidden)

	widget.taskWidgets = {}

	local order = {}

	for _, child in ipairs(taskListHud.quests:getChildren()) do
		if child.northStar then
			table.insert(order, 0, child)
		elseif child.rangersCompany then
			table.insert(order, 1, child)
		else
			table.insert(order, child)
		end
	end

	taskListHud.quests:reorderChildren(order)

	return widget
end

function setQuestWidgetVisibility(questName, visible, widget, isUIInteraction)
	if not questName then
		return
	end

	if not taskListHud.quests then
		return
	end

	local quest = taskListHud.quests:getChildById(questName)

	if not quest then
		return
	end

	local settings = getHiddenActiveQuestsSettings()

	if visible then
		settings[questName] = nil

		if not table.find(hiddenQuests, questName:lower()) then
			quest:show()
		end
	else
		settings[questName] = true

		quest:hide()
	end

	if visible and widget then
		widget:setChecked(true)

		local questsVisible = 0

		for _, child in ipairs(taskListHud.quests:getChildren()) do
			if child:isVisible() and not child.northStar then
				questsVisible = questsVisible + 1
			end
		end

		local trackerWidget = getQuestWidget(questName)

		if questsVisible > 5 and not trackerWidget.northStar and not trackerWidget.rangersCompany then
			widget:setChecked(false)
			quest:hide()

			if isUIInteraction then
				GameNotification:display(NOTIFICATION_ERROR, nil, tr("You can have up to 5 quests selected at the same time."))
			end

			settings[questName] = true
		else
			settings[questName] = nil
		end
	end

	saveHiddenActiveQuestsSettings()
end

function removeQuestWidget(questName)
	local widget = getQuestWidget(questName)

	if widget then
		removeRangersCompanyEntry(widget)
		g_effects.fadeOut(widget, 1000, nil, true, function()
			fadeInOut(taskListHud.quests:getChildCount())
		end)
	end
end

function addQuestEntry(questName, entry)
	local parent = getQuestWidget(questName)

	if not parent then
		return nil
	end

	local widget = g_ui.createWidget("TaskListItemHUD", parent.taskListPanel)

	widget:setId(entry.name)
	widget:setText(tr(entry.name))

	if entry.progress then
		widget:setText(widget:getText() .. string.format(" (%s)", entry.progress))
	end

	widget.taskId = entry.taskId
	widget.questName = questName
	widget.taskDescription = entry.name
	widget.taskProgress = entry.progress
	widget.compassData = entry.compassData

	table.insert(parent.taskWidgets, widget)

	if not showTaskAtTheEnd(widget.taskDescription) then
		local children = parent.taskListPanel:getChildren()

		if #children > 1 then
			local newIndex

			for index = #children - 1, 1, -1 do
				local child = children[index]

				if not showTaskAtTheEnd(child.taskDescription) then
					break
				end

				newIndex = index
			end

			if newIndex then
				parent.taskListPanel:moveChildToIndex(widget, newIndex)
			end
		end
	end

	local compass = parent.compass

	if entry.compassUnlocked then
		compass:setSize({
			height = 32,
			width = 32
		})

		if widget.compassData then
			g_worldMap.addCompassData(widget.compassData, widget.questName, widget.taskId, widget.taskDescription, true)
		end
	else
		compass:setSize({
			height = 32,
			width = 0
		})
	end

	local custom_icon = parent.custom_icon

	if parent.northStar then
		custom_icon:setId("north_star")

		if parent.quest.finished then
			widget:setText("Click to Collect Your Rewards!")
			widget:setTextColor("#FEFEC6")
		else
			widget:setTextColor("white")
		end
	elseif parent.rangersCompany then
		widget.family = entry.family
		widget.region = entry.region

		custom_icon:setId("rangers_company")
		addRangersCompanyEntry(entry)
	end

	function widget.onClick()
		GameQuestLog:onTaskDescriptionClicked(widget.questName, widget.taskId, parent.quest)
	end

	scheduleEvent(function()
		parent:setHeight((parent.name and parent.name:getHeight() or 0) + (parent.taskListPanel and parent.taskListPanel:getHeight() or 0))
	end, 100)

	return widget
end

function addRangersCompanyEntry(task)
	if not rangersCompanyQuests[task.family] then
		rangersCompanyQuests[task.family] = {}
	end

	rangersCompanyQuests[task.family][task.region] = task.level
end

function removeRangersCompanyEntry(quest)
	local panel = quest.taskListPanel and quest.taskListPanel:getChildren()

	for _, task in pairs(panel or {}) do
		local family = task.family

		if family and rangersCompanyQuests[family] then
			local position = g_game.getLocalPlayer() and g_game.getLocalPlayer():getPosition()

			if position then
				local creatures = g_map.getSpectators(position, true)

				for _, creature in pairs(creatures) do
					if creature:isMonster() and (creature:getFamily() == family or creature:getSubFamily() == family) then
						creature:setIcon(0, false)
					end
				end
			end

			if table.size(rangersCompanyQuests[family]) <= 1 then
				rangersCompanyQuests[family] = nil
			else
				rangersCompanyQuests[family][task.region] = nil
			end
		end
	end
end

function getRangersCompanyQuests()
	return rangersCompanyQuests
end

function isMonsterInRangersCompanyQuests(monster)
	local tasks = rangersCompanyQuests

	if not table.empty(tasks) then
		local family = tasks[monster:getFamily()] or tasks[monster:getSubFamily()]

		if family then
			local currentRegion = modules.game_minimap.getRegionName()

			for region, requiredLevel in pairs(family) do
				local level = monster:getLevel()

				if level >= requiredLevel.min and level <= requiredLevel.max and region:lower() == currentRegion:lower() then
					return true
				end
			end
		end
	end

	return false
end

function getQuestEntry(questName, entryNameOrTaskId)
	local parent = getQuestWidget(questName)

	if not parent then
		return false
	end

	if type(entryNameOrTaskId) == "number" then
		for _, child in pairs(parent.taskListPanel:getChildren()) do
			if child.taskId == entryNameOrTaskId then
				return child
			end
		end
	end

	if type(entryNameOrTaskId) == "table" then
		for _, task in pairs(entryNameOrTaskId) do
			for _, child in pairs(parent.taskListPanel:getChildren()) do
				if child.taskId == task then
					return child
				end
			end
		end
	end

	local widget = parent.taskListPanel:recursiveGetChildById(entryNameOrTaskId)

	return widget
end

function updateQuestEntry(questName, entry)
	local parent = getQuestWidget(questName)

	if not parent then
		return nil
	end

	local widget = parent.taskListPanel:recursiveGetChildById(entry.name)

	if entry.north_star and entry.finished then
		widget:setText("Click to Collect Your Rewards!")
		widget:setTextColor("#FEFEC6")
	else
		widget:setText(tr(entry.name))
		widget:setTextColor("white")

		if entry.progress then
			widget:setText(widget:getText() .. string.format(" (%s)", entry.progress))
		end
	end

	widget.taskId = entry.taskId
	widget.questName = questName
	widget.taskDescription = entry.name
	widget.taskProgress = entry.progress

	scheduleEvent(function()
		parent:setHeight(parent.name:getHeight() + parent.taskListPanel:getHeight())
	end, 100)

	return widget
end

function removeQuestEntry(questName, entryName)
	local parent = getQuestWidget(questName)

	if not parent then
		return
	end

	local widget = parent.taskListPanel:recursiveGetChildById(entryName)

	if widget then
		signalcall(GameQuestLog.onRemoveTask, questName, widget.taskId)
		g_effects.fadeOut(widget, 1000, 0, true, function()
			scheduleEvent(function()
				if parent.name then
					parent:setHeight(parent.name:getHeight() + parent.taskListPanel:getHeight())
				end
			end, 10)
		end)
		widget:getParent():removeChild(widget)
	end
end

function onDragEnter(self, mousePos)
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

function onDragMove(self, mousePos, mouseMoved)
	local pos = {
		x = mousePos.x - self.movingReference.x,
		y = mousePos.y - self.movingReference.y
	}

	g_layout.snapToGrid(pos)
	self:setPosition(pos)
	self:bindRectToParent()
end

function toggleQuestTracker(value)
	if value then
		if g_game.isAetherRiftChannel() or g_game.isGuildWarsChannel() then
			return
		end

		fadeInOut(taskListHud.quests:getChildCount())
	else
		taskListHud:hide()
	end
end
