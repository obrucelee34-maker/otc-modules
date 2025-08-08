-- chunkname: @/modules/game_dialogueviewer/dialogueviewer.lua

GameDialogueViewer = {}

function GameDialogueViewer:init()
	g_ui.importStyle("styles/main.otui")

	local HUDPanel = modules.game_interface.getHUDPanel()

	self.window = g_ui.createWidget("GameDialogueViewerWindow", HUDPanel)

	self.window:hide()
	connect(self.window, {
		onVisibilityChange = function(self, visible)
			if not visible then
				ProtocolGame.unregisterExtendedOpcode(ExtendedIds.DialogueViewer)
			else
				ProtocolGame.registerExtendedOpcode(ExtendedIds.DialogueViewer, GameDialogueViewer.onExtendedOpcode)
				GameDialogueViewer:sendFetchNpcsRequest()
			end
		end
	})
	g_keyboard.bindKeyDown("Ctrl+Alt+4", self.toggle)
end

function GameDialogueViewer:terminate()
	if self.window then
		self.window:hide()
		self.window:destroy()

		self.window = nil
	end

	g_keyboard.unbindKeyDown("Ctrl+Alt+4")

	GameDialogueViewer = nil
end

function GameDialogueViewer.toggle()
	local self = GameDialogueViewer
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	if not player:isGamemaster() then
		self.window:hide()

		return
	end

	if self.window:isVisible() then
		self.window:hide()
	else
		self.window:show()
	end
end

function GameDialogueViewer.onExtendedOpcode(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.DialogueViewer or buffer == "" then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		return
	end

	local self = GameDialogueViewer

	if data.action == "fetch_npcs" then
		self:setupNpcListPanel(data)
	elseif data.action == "npc" then
		self:setupNpcDialoguePanel(data)
	end
end

function GameDialogueViewer:sendOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if not protocolGame then
		return
	end

	protocolGame:sendExtendedOpcode(ExtendedIds.DialogueViewer, g_game.serializeTable(data))
end

function GameDialogueViewer:sendFetchNpcsRequest()
	self:sendOpcode({
		action = "fetch_npcs"
	})
end

function GameDialogueViewer:setupNpcListPanel(data)
	local npcListPanel = self.window.content.npcListPanel

	npcListPanel:destroyChildren()

	for _, npc in ipairs(data.npcs) do
		local npcWidget = g_ui.createWidget("GameDialogueViewerWindowNpcListPanelItem", npcListPanel)

		npcWidget:setId(npc)
		npcWidget:setText(npc)

		function npcWidget.onClick()
			self:sendRequestNpcDialogue(npc)

			if self.lastSelectedNpc then
				self.lastSelectedNpc:setOn(false)
			end

			npcWidget:setOn(true)

			self.lastSelectedNpc = npcWidget
		end
	end
end

function GameDialogueViewer:sendRequestNpcDialogue(npc)
	self:sendOpcode({
		action = "npc",
		npc = npc
	})
end

function GameDialogueViewer:setupNpcDialoguePanel(data)
	local npcDialoguePanel = self.window.content.dialogueListPanel

	npcDialoguePanel:destroyChildren()

	local locale = EnterGame.getLocale()

	for _, info in pairs(data.info) do
		local npcDialogueWidget = g_ui.createWidget("GameDialogueViewerWindowDialogueListPanelItem", npcDialoguePanel)

		for __, dialogue in ipairs(info) do
			local questionWidget = g_ui.createWidget("GameDialogueViewerWindowNpcListPanelItem", npcDialogueWidget)

			if locale ~= "en-GB" and dialogue.translation then
				questionWidget:setText(string.format("[%d] %s", __, dialogue.translation[locale] or dialogue.say))

				if not dialogue.translation[locale] then
					questionWidget:setChecked(true)
				end
			else
				questionWidget:setText(string.format("[%d] %s", __, dialogue.say))
			end

			local answers = dialogue.answers

			if answers then
				for ___, answer in ipairs(answers) do
					local answerWidget = g_ui.createWidget("GameDialogueViewerWindowNpcListPanelItem", npcDialogueWidget)

					if locale ~= "en-GB" and answer.translation then
						answerWidget:setText(string.format("    [%d] %s", ___, answer.translation[locale] or answer.say))

						if not answer.translation[locale] then
							answerWidget:setChecked(true)
						end
					else
						answerWidget:setText(string.format("    [%d] %s", ___, answer.say))
					end
				end
			end
		end
	end
end

function GameDialogueViewer:searchNpcList(text)
	local npcListPanel = self.window.content.npcListPanel
	local children = npcListPanel:getChildren()

	for _, child in ipairs(children) do
		if child:getText():lower():find(text:lower()) then
			child:setVisible(true)
		else
			child:setVisible(false)
		end
	end
end

function GameDialogueViewer:searchDialogueList(text)
	local npcDialoguePanel = self.window.content.dialogueListPanel
	local children = npcDialoguePanel:getChildren()

	for _, child in ipairs(children) do
		local grandChildren = child:getChildren()

		for __, grandChild in ipairs(grandChildren) do
			if grandChild:getText():lower():find(text:lower()) then
				grandChild:setVisible(true)
			else
				grandChild:setVisible(false)
			end
		end
	end
end
