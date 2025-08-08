-- chunkname: @/modules/game_npcs/npc.lua

GameNpc = {
	canSendAnswer = true,
	panels = {}
}

function GameNpc:loadConfig()
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

function GameNpc.onExtendedOpcode(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.Dialogue then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		return
	end

	local action = data.action

	if action and callbacks[action] then
		callbacks[action](data)
	end

	if data.question and data.question.hash then
		GameVoiceActing:onDialogueVoice(data.question.hash)
	end
end

function GameNpc.onGameStart()
	return
end

function GameNpc.onGameEnd()
	GameNpc:onClose(nil, true)
end

function GameNpc:init()
	self:loadConfig()

	local HUDPanel = modules.game_interface.getHUDPanel()

	g_ui.importStyle("styles/main.otui")
	g_ui.importStyle("styles/dialogue.otui")
	g_ui.importStyle("styles/itemshop.otui")
	g_ui.importStyle("styles/warehouse.otui")
	g_ui.importStyle("styles/tradepost.otui")
	g_ui.importStyle("styles/fishpost.otui")
	g_ui.importStyle("styles/bank.otui")
	g_ui.importStyle("styles/rangers_company_shop.otui")
	g_ui.importStyle("styles/rangers_company_specialshop.otui")
	g_ui.importStyle("styles/gear_breakdown_shop.otui")
	g_ui.importStyle("styles/culled_eyes_shop.otui")
	g_ui.importStyle("styles/accessory_shop.otui")
	g_ui.importStyle("styles/moa_exchange_shop.otui")
	g_ui.importStyle("styles/harvest_shop.otui")
	g_ui.importStyle("styles/general_shop.otui")
	connect(g_game, {
		onGameStart = GameNpc.onGameStart,
		onGameEnd = GameNpc.onGameEnd
	})

	self.window = g_ui.createWidget("GameNpcWindow", HUDPanel)

	self.window:setVisible(false)

	self.window.onEscape = self.hide

	for _, panel in pairs(windowTypes) do
		GameNpc.panels[panel] = g_ui.createWidget(panel, self.window.contentPanel)

		GameNpc.panels[panel]:setVisible(false)
	end

	ProtocolGame.registerExtendedOpcode(ExtendedIds.Dialogue, GameNpc.onExtendedOpcode, "game_npcs")

	if g_game.isOnline() then
		GameNpc.onGameStart()
	end
end

function GameNpc:terminate()
	GameNpc:onClose()
	self.window:destroy()

	local HUDPanel = modules.game_interface.getHUDPanel()

	disconnect(g_game, {
		onGameStart = GameNpc.onGameStart,
		onGameEnd = GameNpc.onGameEnd
	})
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.Dialogue, "game_npcs")

	GameNpc = nil
end

function GameNpc:show()
	self.window:setVisible(true)
	self.window:raise()
	self.window:focus()
end

function GameNpc:hide()
	self.window:setVisible(false)
end

function GameNpc:isVisible()
	return self.window and self.window:isVisible()
end

function GameNpc:setPanel(id)
	local newPanel = windowTypes[id] and self.panels[windowTypes[id]]

	if not newPanel then
		return
	end

	for _, panel in pairs(self.panels) do
		if panel ~= newPanel then
			panel:setVisible(false)
		elseif not panel:isVisible() then
			panel:setVisible(true)
		end
	end
end

function GameNpc:onGreet(data)
	local npcName = data.npcName
	local npcQuestion = data.question
	local npcOutfit = data.npcOutfit
	local npcDialogueId = data.dialogueId
	local npcNameLabel = self.window.topPanel:recursiveGetChildById("npcName")
	local npcPreview = self.window.topPanel:recursiveGetChildById("npcPreview")
	local npcQuestionLabel = self.window.contentPanel:recursiveGetChildById("questionLabel")
	local npcQuestionNameLabel = self.window.contentPanel:recursiveGetChildById("questionName")
	local npcAnswersPanel = self.window.contentPanel:recursiveGetChildById("dialogueAnswerPanel")
	local npcLogPanel = self.window.contentPanel:recursiveGetChildById("dialogueLogPanel")
	local storageSelectionPanel = self.window:recursiveGetChildById("storage_selection_panel")

	if storageSelectionPanel then
		storageSelectionPanel:setVisible(false)
	end

	local children = npcLogPanel:getChildren()

	for _, child in ipairs(children) do
		if child:getId() ~= "dummy" then
			child:destroy()
		end
	end

	npcLogPanel:setHeight(0)

	local npcId = npcName

	if type(npcName) == "number" then
		local creature = g_map.getCreatureById(npcName)

		if not creature or not creature:isNpc() then
			return
		end

		npcName = creature:getDisplayName()
		npcOutfit = creature:getOutfit()
	elseif type(npcName) == "string" and not npcOutfit then
		local creatures = g_map.getSpectatorsInRange(g_game.getLocalPlayer():getPosition(), false, 5, 5)

		for _, creature in pairs(creatures) do
			if creature:isNpc() and creature:getDisplayName():lower() == npcName:lower() then
				npcId = creature:getId()
				npcOutfit = creature:getOutfit()

				break
			end
		end
	end

	if type(npcName) ~= "string" then
		return
	end

	self.npcId = npcId
	self.npcName = npcName
	self.npcQuestion = npcQuestion
	self.dialogueId = npcDialogueId
	self.canSendAnswer = true

	npcNameLabel:setText(npcName:upper())
	npcQuestionLabel:setText(tr(npcQuestion.say))
	npcQuestionNameLabel:setText(npcName:upper())
	npcPreview:resetOutfit()
	npcPreview:setImageSource("")

	if npcOutfit then
		if type(npcOutfit) == "string" then
			npcPreview:setAutoResize(false)
			npcPreview:setSize({
				width = 100,
				height = 100
			})
			npcPreview:setImageSource("/images/ui/portraits/" .. npcOutfit:lower())
		else
			npcPreview:setAutoResize(true)
			npcPreview:setScale(1.5)
			npcPreview:setOutfit(npcOutfit)
		end
	end

	local height = npcPreview:getHeight() + npcNameLabel:getHeight() + npcNameLabel:getMarginTop() + 10

	self.window.topPanel:setHeight(height)
	self:setTopPanelOn(true)
	self:setPanel("dialogue")

	if self:isVisible() and not self.window:isCollapsing() then
		self:setAnswers(data.answers)

		return
	end

	self.window:expand(nil, function()
		self.window.contentPanel:setVisible(true)
		self.window.topPanel.npcName:setVisible(true)
		self.window.topPanel.closeButton:setVisible(true)
		self.window:raise()
		self.window:focus()
		self:setAnswers(data.answers)
		signalcall(g_game.onOpenNpcWindow, npcName)
	end)
end

function GameNpc:show()
	self.window:expand(nil, function()
		self.window.contentPanel:setVisible(true)
		self.window.topPanel.npcName:setVisible(true)
		self.window.topPanel.closeButton:setVisible(true)
		self.window:raise()
		self.window:focus()
	end)
end

function GameNpc:onReply(data)
	local npcQuestionLabel = self.window.contentPanel:recursiveGetChildById("questionLabel")
	local npcAnswersPanel = self.window.contentPanel:recursiveGetChildById("dialogueAnswerPanel")
	local npcLogPanel = self.window.contentPanel:recursiveGetChildById("dialogueLogPanel")
	local npcLogScrollbar = self.window.contentPanel:recursiveGetChildById("logBoxScrollBar")
	local answer = npcAnswersPanel:getChildById(self.lastAnswer)

	self:logText({
		color = "#919295",
		text = string.format("%s - %s", "YOU", answer.text:getText()),
		icon = answer.icon:getImageSource()
	})
	self:logText({
		color = "#7B7062",
		icon = "",
		text = string.format("{%s, #ffa85180} - \"%s\"", self.npcName:upper(), self.npcQuestion.say)
	})

	self.npcQuestion = data.question
	self.canSendAnswer = true

	npcQuestionLabel:setText(data.question.say)
	self:setAnswers(data.answers)

	local height = npcLogPanel:getPaddingTop() + npcLogPanel:getPaddingBottom()

	for _, child in ipairs(npcLogPanel:getChildren()) do
		height = height + child:getHeight() + child:getMarginTop() + child:getMarginBottom()
	end

	npcLogPanel:setHeight(height)
end

function GameNpc:ungreet()
	self:sendOpcode({
		action = "ungreet"
	})
end

function GameNpc:onClose(dontSend, closeGame, hideUngreetMessage)
	if not dontSend then
		self:sendOpcode({
			action = "ungreet",
			hideUngreetMessage = hideUngreetMessage
		})
	end

	if g_game.isOnline() then
		modules.game_interface.focusMapPanel()
	end

	self.window.contentPanel:setVisible(false)
	self.window.topPanel.npcName:setVisible(false)
	self.window.topPanel.closeButton:setVisible(false)

	if self.window:isVisible() and not self.window:isCollapsing() then
		self.window:collapse(nil, function()
			signalcall(g_game.onCloseNpcWindow)
		end)
	end

	if closeGame then
		self.window:hide()
	end

	if self.confirmationWindow then
		self.confirmationWindow:destroy()

		self.confirmationWindow = nil
	end

	self.dialogueId = nil
	self.npcId = nil
	self.npcName = nil
	self.npcQuestion = nil
	self.lastAnswer = nil
	self.canSendAnswer = true
	self.restoreAfterCutscene = nil

	BuilderShop:hide()
	ItemShop.onClose()
	Tradepost:onClose()
	RangersCompanyShop:onClose()
	MoaExchange:onClose()

	local market = modules.game_market

	if market then
		market.GameMarket:hide()
	end

	local aetherEcho = modules.game_aether_echo

	if aetherEcho then
		aetherEcho.GameAetherEcho:closeAetherEchoWindow(true)
	end
end

function GameNpc:setAnswers(answers)
	local npcAnswersPanel = self.window.contentPanel:recursiveGetChildById("dialogueAnswerPanel")
	local children = npcAnswersPanel:getChildren()

	if #children > 0 then
		npcAnswersPanel:destroyChildren()
	end

	for i = 1, #answers do
		local answer = answers[i]

		if not modules.game_questlog.getQuestEntry("The City of Ravencrest", 10) or answer[2] ~= "I want to craft a tradepack." then
			local button = g_ui.createWidget("GameDialogueButton", npcAnswersPanel)

			button.icon = button:getChildById("icon")
			button.text = button:getChildById("text")

			local count = npcAnswersPanel:getChildCount()

			button:setId(answer[1])
			button:addAnchor(AnchorTop, count == 1 and "parent" or "prev", count == 1 and AnchorTop or AnchorBottom)
			button.text:setText(answer[2])

			local icon = answer[3]

			button.icon:setImageSource(icon and "/images/ui/windows/npcs/main/" .. icons[icon] or "")
			button.icon:setEnabled(icon and true or false)

			button.confirmMessage = answer[6]

			self:buttonResized(button)
		end
	end

	local height = npcAnswersPanel:getPaddingTop() + npcAnswersPanel:getPaddingBottom()

	for _, child in ipairs(npcAnswersPanel:getChildren()) do
		height = height + child:getHeight() + child:getMarginTop() + child:getMarginBottom()
	end

	npcAnswersPanel:setHeight(height)
end

function GameNpc:logText(data)
	local npcLogPanel = self.window.contentPanel:recursiveGetChildById("dialogueLogPanel")
	local button = g_ui.createWidget("GameDialogueLogButton", npcLogPanel)

	button.icon = button:getChildById("icon")
	button.text = button:getChildById("text")

	button:addAnchor(AnchorTop, "prev", AnchorBottom)
	button:getParent():moveChildToIndex(button, 2)

	local text = data.text

	if data.icon ~= "" then
		text = text:sub(1, 5) .. "           " .. text:sub(6)
	end

	button.text:setText(text)
	button.text:setColor(data.color)

	if data.color == "#7B7062" then
		local highlightData = GetHighlightedText(text, "#7B7062")

		if #highlightData > 0 then
			button.text:setColoredText(highlightData)
		end
	end

	button.icon:setImageSource(data.icon or "")
	button.icon:setEnabled(data.icon ~= "")
	self:buttonResized(button, true)
	button:setHeight(button:getHeight() + 5)
end

function GameNpc:sendOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.Dialogue, g_game.serializeTable(data))
	end
end

function GameNpc:buttonResized(button, forced)
	local parent, widget = button:getParent(), button.text

	if not parent or not widget then
		return
	end

	local maxWidth = parent:getWidth() - parent:getPaddingLeft() - parent:getPaddingRight()
	local size = widget:getWidth() + widget:getMarginLeft() + widget:getMarginRight()

	size = size + button:getPaddingLeft() + button:getPaddingRight() + button.icon:getWidth()
	size = size + button.icon:getMarginLeft()

	local width = math.min(maxWidth, size + 30)

	button:setWidth(width)
	button:setImageOffset({
		x = 30,
		y = 4
	})

	if not forced and size < maxWidth then
		return
	end

	if not widget:getTextWrap() then
		widget:setTextWrap(true)
	end

	button:setHeight(2 + widget:getHeight())
	button:setImageOffset({
		x = 8,
		y = -1
	})
end

function GameNpc:buttonClicked(button, id, text)
	if signalcall(g_game.onNpcAnswer, id, text) then
		return
	end

	if not self.canSendAnswer then
		return
	end

	if not id then
		self:onClose()
	end

	if self.confirmationWindow then
		self.confirmationWindow:destroy()

		self.confirmationWindow = nil
	end

	local option = tonumber(id) or id
	local confirmMessage = button.confirmMessage

	if confirmMessage then
		local function yesCallback()
			if self.confirmationWindow then
				self.confirmationWindow:destroy()

				self.confirmationWindow = nil
			end

			self:sendOpcode({
				action = "dialogue",
				dialogueId = self.dialogueId,
				npcName = self.npcName,
				option = option
			})

			self.lastAnswer = id
			self.canSendAnswer = false
		end

		local function noCallback()
			self.confirmationWindow:destroy()

			self.confirmationWindow = nil
		end

		self.confirmationWindow = displayGeneralBox(tr(confirmMessage.title or "Confirm"), tr(confirmMessage.text), {
			{
				text = tr("Yes"),
				callback = yesCallback
			},
			{
				text = tr("No"),
				callback = noCallback
			},
			anchor = AnchorHorizontalCenter
		}, yesCallback, noCallback, nil, modules.game_interface.getRootPanel())
	else
		self:sendOpcode({
			action = "dialogue",
			dialogueId = self.dialogueId,
			npcName = self.npcName,
			option = option
		})

		self.lastAnswer = id
		self.canSendAnswer = false
	end
end

function GameNpc:setTopPanelOn(value)
	return self.window and self.window.topPanel:setOn(value)
end
