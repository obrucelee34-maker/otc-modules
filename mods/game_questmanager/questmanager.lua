-- chunkname: @/modules/game_questmanager/questmanager.lua

local onReceiveQuests, questManagerWindow, allQuests, tasksPanel, positionList, creaturesList, textFilter, totalQuestsLabel, questListScrollbar
local loaded = false
local binded = false

function init()
	if g_game.isOnline() then
		local localPlayer = g_game.getLocalPlayer()

		onGamemasterChange(localPlayer, localPlayer:isGamemaster())
	end

	connect(LocalPlayer, {
		onGamemasterChange = onGamemasterChange
	})
end

function bindHotkey()
	if binded then
		return
	end

	g_keyboard.bindKeyDown("Ctrl+Alt+2", toggle)

	binded = true
end

function unbindHotkey()
	if not binded then
		return
	end

	g_keyboard.unbindKeyDown("Ctrl+Alt+2")

	binded = false
end

function onGamemasterChange(player, gamemaster)
	if gamemaster then
		bindHotkey()
	else
		unbindHotkey()
	end

	if loaded then
		return
	end

	if not gamemaster then
		return
	end

	connect(g_game, {
		onGameEnd = close
	})
	g_ui.importStyle("questmanager")
	ProtocolGame.registerExtendedOpcode(ExtendedIds.QuestManager, onExtendedOpcode)

	questManagerWindow = g_ui.createWidget("QuestManagerWindow", modules.game_interface.getHUDPanel())
	allQuests = questManagerWindow:recursiveGetChildById("allQuests")
	tasksPanel = questManagerWindow:recursiveGetChildById("tasksPanel")
	positionList = questManagerWindow:recursiveGetChildById("positionList")
	creaturesList = questManagerWindow:recursiveGetChildById("creaturesList")
	textFilter = questManagerWindow:recursiveGetChildById("textFilter")
	totalQuestsLabel = questManagerWindow:recursiveGetChildById("totalQuestsLabel")
	loaded = true
end

function terminate()
	if loaded then
		questManagerWindow:destroy()
		ProtocolGame.unregisterExtendedOpcode(ExtendedIds.QuestManager)
		disconnect(g_game, {
			onGameEnd = close
		})
	end

	disconnect(LocalPlayer, {
		onGamemasterChange = onGamemasterChange
	})
	unbindHotkey()

	loaded = false
end

function toggle()
	local localPlayer = g_game.getLocalPlayer()

	if not loaded or not localPlayer or not localPlayer:isGamemaster() then
		return
	end

	if questManagerWindow:isVisible() then
		hide()
	else
		show()
	end
end

function show()
	requestQuests()
	questManagerWindow:show()
end

function hide()
	if questManagerWindow then
		questManagerWindow:hide()
	end
end

function close()
	hide()
end

function onExtendedOpcode(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.QuestManager or buffer == "" then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		return
	end

	if data.action == "quests" then
		onReceiveQuests(data.quests)
	elseif data.action == "tasks" then
		onReceiveQuestTasks(data.questName, data.tasks)
	elseif data.action == "extras" then
		onReceiveQuestExtraInfo(data.questName, data)
	end
end

function sendOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.QuestManager, g_game.serializeTable(data))
	end
end

function requestQuests()
	local localPlayer = g_game.getLocalPlayer()

	if not localPlayer or not localPlayer:isGamemaster() then
		return
	end

	sendOpcode({
		action = "manager"
	})
end

function requestQuestTasks(questName)
	local localPlayer = g_game.getLocalPlayer()

	if not localPlayer or not localPlayer:isGamemaster() then
		return
	end

	sendOpcode({
		action = "tasks",
		questName = questName
	})
end

local function sortByLevel(a, b)
	local aLevel = a.req and a.req.level or 0
	local bLevel = b.req and b.req.level or 0

	return aLevel < bLevel
end

function onReceiveQuests(quests)
	allQuests:destroyChildren()
	tasksPanel:destroyChildren()
	creaturesList:destroyChildren()
	positionList:destroyChildren()
	table.sort(quests, sortByLevel)

	for _, questData in ipairs(quests) do
		local widget = g_ui.createWidget("ManagerQuestName", allQuests)
		local checkbox = widget:getChildById("checkbox")
		local name = widget:getChildById("name")
		local level = questData.req and questData.req.level or 0
		local otherQuest = "none"

		if questData.req and questData.req.quest then
			if type(questData.req.quest) == "table" then
				otherQuest = table.concat(questData.req.quest, ", ")
			else
				otherQuest = questData.req.quest
			end
		end

		widget:setId(questData.name)
		name:setText(questData.name .. string.format("\n(Lvl: %d - Req: %s)", level, otherQuest))
		checkbox:setChecked(questData.completed)

		widget.questData = questData

		function checkbox.onCheckChange()
			completeQuest(checkbox, widget)
		end

		addEvent(function()
			widget:setHeight(math.max(30, name:getTextSize().height + 15))
		end)
	end

	onQuestSearch(textFilter:getText())
end

function onReceiveQuestTasks(questName, tasks)
	tasksPanel:destroyChildren()

	for id, task in ipairs(tasks) do
		local taskItem = g_ui.createWidget("ManagerTaskListItem", tasksPanel)
		local checkbox = taskItem:getChildById("checkbox")
		local description = taskItem:getChildById("description")
		local location = ""

		checkbox:setChecked(task.completed)
		description:setText(tr("[%d] %s", id, task.description))

		taskItem.task = task
		taskItem.tasks = tasks
		taskItem.questName = questName

		function checkbox.onCheckChange()
			completeQuestTasks(checkbox, taskItem)
		end

		addEvent(function()
			taskItem:setHeight(math.max(30, description:getTextSize().height))
		end)
	end
end

function onReceiveQuestExtraInfo(questName, info)
	creaturesList:destroyChildren()

	if info.creatures then
		for _, name in ipairs(info.creatures) do
			local widget = g_ui.createWidget("ManagerQuestActionCreature", creaturesList)

			widget:setText(name)

			widget.name = name
			widget.questName = questName
		end
	end

	positionList:destroyChildren()

	if info.positions then
		for id, pos in ipairs(info.positions) do
			local widget = g_ui.createWidget("ManagerQuestActionPosition", positionList)

			widget:setText(string.format("[%i]: %i, %i, %i", id, pos.x, pos.y, pos.z))

			widget.pos = pos
		end
	end
end

function selectQuest(button)
	local quests = allQuests:getChildren()

	for _, value in ipairs(quests) do
		value:getChildById("name"):setOn(false)
	end

	creaturesList:setText()
	positionList:destroyChildren()
	button:setOn(true)
	requestQuestTasks(button:getParent():getId())
end

function onQuestSearch(text)
	local searchFilter = text:lower()
	local total = 0

	for _, label in pairs(allQuests:getChildren()) do
		local searchCondition = searchFilter == "" or searchFilter ~= "" and string.find(label:getChildById("name"):getText():lower(), searchFilter) ~= nil

		label:setVisible(searchCondition)

		if searchCondition then
			total = total + 1
		end
	end

	totalQuestsLabel:setText(string.format("Total: %d", total))
end

function goToTaskPosition(taskItem)
	local player = g_game.getLocalPlayer()

	if not player or not taskItem.task or not taskItem.task.pos then
		return
	end

	local destination = taskItem.task.pos

	if player:isGamemaster() then
		g_game.talk(string.format("/pos %i, %i, %i", destination.x, destination.y, destination.z))

		return
	end
end

function goToActionPosition(listItem)
	local player = g_game.getLocalPlayer()

	if not player or not listItem.pos then
		return
	end

	local destination = listItem.pos

	if player:isGamemaster() then
		g_game.talk(string.format("/pos %i, %i, %i", destination.x, destination.y, destination.z))

		return
	end
end

function summonCreature(listItem)
	local player = g_game.getLocalPlayer()

	if not player or not listItem.name then
		return
	end

	local monsterName = listItem.name

	if player:isGamemaster() then
		local level = 1

		for _, label in pairs(allQuests:getChildren()) do
			if label.questData and label.questData.name == listItem.questName then
				level = label.questData.req and label.questData.req.level or 1

				break
			end
		end

		g_game.talk(string.format("/m %s, %d", monsterName, level))

		return
	end
end

function completeQuest(checkbox, config)
	local checked = checkbox:isChecked()

	if not config.questData then
		return
	end

	sendOpcode({
		action = "complete_quest",
		questName = config.questData.name,
		reset = not checked
	})
end

function completeQuestTasks(checkbox, config)
	local checked = checkbox:isChecked()

	if not config.questName then
		return
	end

	sendOpcode({
		action = "complete_tasks",
		questName = config.questName,
		taskId = config.task.id,
		reset = not checked
	})
end

function resetAllQuests()
	sendOpcode({
		action = "reset_all"
	})
end
