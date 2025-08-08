-- chunkname: @/modules/game_chat/chat.lua

GameChat = {
	hidePopoutMessage = false,
	enabled = false,
	messageQueueSize = 0,
	currentTalkType = "Local",
	messageHistoryPos = 0,
	tabs = {},
	privateTabs = {},
	messageHistory = {},
	currentTab = {
		name = "general",
		messageBuffer = {},
		hiddenMessageBuffer = {}
	},
	messageBufferPanels = {},
	messageBuffers = {},
	reusableWidgets = {},
	hotkeyDisconnects = {},
	events = {},
	global = {
		channelId = 0
	}
}

function GameChat:loadConfig()
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

function GameChat:init()
	if not self:loadConfig() then
		return false
	end

	self:loadSettings()
	g_ui.importStyle("styles/chat.otui")

	self.window = g_ui.createWidget("ChatWindow", modules.game_interface.getHUDPanel())

	self.window:hide()
	self.window:setAutoRepeatDelay(500)

	self.window.onDragEnter = GameChat.onDragEnter
	self.window.onDragMove = GameChat.onDragMove
	self.window.onDragLeave = GameChat.onDragLeave

	table.insert(self.hotkeyDisconnects, g_keyboard.bindKeyDown("Enter", function()
		self:sendMessage()
	end))
	table.insert(self.hotkeyDisconnects, g_keyboard.bindKeyDown("Tab", function()
		if self:isActive() or self:isFocused() then
			self:selectNextTab()
		end
	end))
	table.insert(self.hotkeyDisconnects, g_keyboard.bindKeyDown("Shift+Tab", function()
		if self:isActive() or self:isFocused() then
			self:selectPreviousTab()
		end
	end))
	table.insert(self.hotkeyDisconnects, g_keyboard.bindKeyUp("Shift+Up", function()
		if self:isActive() or self:isFocused() then
			self:navigateMessageHistory(1)
		end
	end))
	table.insert(self.hotkeyDisconnects, g_keyboard.bindKeyUp("Shift+Down", function()
		if self:isActive() or self:isFocused() then
			self:navigateMessageHistory(-1)
		end
	end))
	table.insert(self.hotkeyDisconnects, g_keyboard.bindKeyUp("Escape", function()
		if self:isActive() or self:isFocused() then
			if self:canHide() then
				self:disable()
			else
				local mapPanel = modules.game_interface.gameMapPanel

				if mapPanel then
					mapPanel:focus()
				end
			end
		end
	end))

	local textEdit = self.window.main.bottomPanel.messageInput

	g_keyboard.bindKeyPress("Ctrl+C", function()
		GameChat:copyCorrectSelectionToClipboard()
	end, textEdit)

	for _ in pairs(self.messageBufferPanels) do
		for __ = 1, cfg.messageBufferSize do
			local widget = g_ui.createWidget("ChatMessage")

			widget:hide()
			table.insert(self.reusableWidgets, widget)
		end
	end

	connect(rootWidget, {
		onMousePress = GameChat.onMousePress
	})
	connect(g_game, {
		onTalk = GameChat.onTalk,
		onTextMessage = GameChat.onTextMessage,
		onGameStart = GameChat.onGameStart,
		onGameEnd = GameChat.onGameEnd,
		onReplaceChatMessage = GameChat.onReplaceChatMessage
	})
	connect(self.window, {
		onPositionChange = GameChat.onPositionChange
	})

	local chatTabBar = self.window.main.topPanel.content.chatTabBar

	connect(chatTabBar, {
		onTabChange = GameChat.onTabChange,
		onRemoveTab = GameChat.onTabRemove
	})

	local messageInput = self.window.main.bottomPanel.messageInput

	messageInput:setAutoRepeatDelay(500)
	connect(messageInput, {
		onKeyPress = GameChat.onTextInputKeyPress
	})

	for _, id in ipairs(cfg.channelNames) do
		local tab = chatTabBar:addTab("", g_ui.createWidget("Chat" .. id:titleCase(true) .. "TabPanel", self.window.main.bodyPanel), nil, nil, nil, {
			onCreate = function(tab)
				tab.name = id
			end,
			onDestroy = function(tab)
				return
			end
		})
		local config = self:getChannelConfig(id)

		function tab.canShow(tab, player)
			return not config or not config.canShow or config.canShow(tab, player)
		end

		self.tabs[id] = tab
	end

	addEvent(function()
		self:setupMessageBuffers()

		if self:canHide() then
			self:shrink()
		end

		if g_game.isOnline() then
			g_layout.loadChat()
			self:onGameStart()
		end
	end)
end

function GameChat:terminate()
	if self.windowChangeEvent then
		removeEvent(self.windowChangeEvent)
	end

	disconnect(rootWidget, {
		onMousePress = GameChat.onMousePress
	})
	disconnect(g_game, {
		onTalk = GameChat.onTalk,
		onTextMessage = GameChat.onTextMessage,
		onGameStart = GameChat.onGameStart,
		onGameEnd = GameChat.onGameEnd
	})
	disconnect(self.window, {
		onPositionChange = GameChat.onPositionChange
	})
	disconnect(self.window.main.topPanel.content.chatTabBar, {
		onTabChange = GameChat.onTabChange,
		onRemoveTab = GameChat.onTabRemove
	})
	disconnect(self.window.main.bottomPanel.messageInput, {
		onKeyPress = GameChat.onTextInputKeyPress
	})

	for _, hotkey in pairs(self.hotkeyDisconnects) do
		for _, disconnect in pairs(hotkey) do
			disconnect()
		end
	end

	for _, privateTab in pairs(GameChat.privateTabs) do
		privateTab:destroy()
	end

	if self.window then
		self.window:destroy()

		self.window = nil
	end

	if self.resetWindow then
		self.resetWindow:destroy()

		self.resetWindow = nil
	end

	for _, widget in pairs(self.reusableWidgets) do
		widget:destroy()
	end

	self.reusableWidgets = {}
	GameChat = nil
end

function GameChat:isEnabled()
	return self.enabled
end

function GameChat:isActive()
	if g_layout.isEditMode() then
		return false
	end

	if self.settings.keepChatOpen then
		return IsTextEditActive()
	end

	return self.enabled
end

function GameChat:isFocused()
	return self.window.focused or self:isActive()
end

function GameChat:canHide()
	return not self.settings.keepChatOpen and not self.window.main.settingsPanel:isVisible() and not g_layout.isEditMode()
end

function GameChat:loadSettings()
	self.settings = g_settings.getNode("GameChat") or cfg.defaultSettings

	for k, setting in pairs(cfg.defaultSettings) do
		if self.settings[k] == nil then
			self.settings[k] = setting
		end
	end
end

function GameChat:resetSettings()
	local function destroyWindow()
		if self.resetWindow ~= nil then
			self.resetWindow:destroy()

			self.resetWindow = nil
		end
	end

	destroyWindow()

	local function yesCallback()
		self.settings = table.recursivecopy(cfg.defaultSettings)

		self:setupSettings()
		destroyWindow()
	end

	self.resetWindow = displayGeneralBox(tr("Reset Settings"), tr("Are you sure you want to reset all chat settings?"), {
		{
			text = tr("Yes"),
			callback = yesCallback
		},
		{
			text = tr("No"),
			callback = destroyWindow
		},
		anchor = AnchorHorizontalCenter
	}, yesCallback, destroyWindow)
end

function GameChat:setupSettings()
	if not self.settings then
		print("GameChat.setupSettings - settings not found")

		return
	end

	local globalConfig = self:getChannelConfig("global")

	globalConfig = globalConfig or {
		selection = {}
	}

	local settingsPanel = self.window.main.settingsPanel.settings

	if not settingsPanel.__setup then
		local globalChatLanguage = settingsPanel.globalChatLanguage
		local options = {}

		for _, option in pairs(globalConfig.selection) do
			table.insert(options, option)
		end

		table.sort(options, function(a, b)
			return a.order < b.order
		end)
		globalChatLanguage.comboBox:clearOptions()

		for _, option in ipairs(options) do
			globalChatLanguage.comboBox:addOption(option.name:titleCase(), {
				icon = string.format("/images/ui/windows/chat/flags/%s_large", option.shortCode),
				language = option.name
			})
		end

		globalChatLanguage.comboBox.onOptionChange = self.setGlobalChatLanguage

		globalChatLanguage.comboBox:setOption(self.settings.globalChat:titleCase())
		self:setGlobalChatLanguage(self.settings.globalChat, {
			language = self.settings.globalChat
		})

		local fontIndex = table.find(settingsPanel.fontSize:getOptions(), self.settings.fontSize)

		fontIndex = fontIndex or settingsPanel.fontSize.defaultValue + 1

		settingsPanel.fontSize.slider:setValue(fontIndex - 1)
		settingsPanel.opacity.slider:setValue(self.settings.opactity)
		settingsPanel.backgroundOpacity.slider:setValue(self.settings.backgroundOpacity)
		settingsPanel.hidePopoutMessageDelay.slider:setValue(self.settings.hidePopoutMessageDelay)

		self.popoutMessageHideDelayMax = settingsPanel.hidePopoutMessageDelay.slider.maximum

		local function updateTabs(widget, on)
			local chatTabBar = self.window.main.topPanel.content.chatTabBar

			for _, tab in pairs(chatTabBar.tabs) do
				self:updateTabDisplay(chatTabBar, on and tab or nil, tab)
			end

			chatTabBar:updateTabs()
		end

		self:setupTrueFalseSetting("hideChatOnSend", settingsPanel, function(widget, on)
			if not on and self.settings.keepChatOpen then
				self.window.main.bottomPanel.messageInput:setTextPreview(tr("Press \"Enter\" to write."))
			else
				self.window.main.bottomPanel.messageInput:setTextPreview(tr("Type your message."))
			end
		end)
		self:setupTrueFalseSetting("keepChatOpen", settingsPanel, function(widget, on)
			if on and not self.settings.hideChatOnSend then
				self.window.main.bottomPanel.messageInput:setTextPreview(tr("Press \"Enter\" to write."))
			else
				self.window.main.bottomPanel.messageInput:setTextPreview(tr("Type your message."))
			end
		end)
		self:setupTrueFalseSetting("autoClearPopupMessages", settingsPanel)
		self:setupTrueFalseSetting("hideNpcInGeneral", settingsPanel)
		self:setupTrueFalseSetting("autoOpenPrivateMessages", settingsPanel)
		self:setupTrueFalseSetting("guildLoginNotifications", settingsPanel)
		self:setupTrueFalseSetting("alwaysShowTabNames", settingsPanel, updateTabs)
		self:setupTrueFalseSetting("tabScrollButtons", settingsPanel, function(widget, on)
			local topPanel = self.window.main.topPanel

			if on then
				topPanel.scrollLeft:show()
				topPanel.scrollLeft:setWidth(25)
				topPanel.scrollRight:show()
				topPanel.scrollRight:setWidth(25)
			else
				topPanel.scrollLeft:hide()
				topPanel.scrollLeft:setWidth(0)
				topPanel.scrollRight:hide()
				topPanel.scrollRight:setWidth(0)
			end
		end)
		updateTabs()

		settingsPanel.__setup = true
	end

	for name, channel in pairs(self.settings.channels) do
		local config = self:getChannelConfig(name)
		local enabled = config and (config.enabled or config.enabled == nil)

		self:openChannelTab(name, channel.open and enabled)

		local inGeneralChat = settingsPanel.inGeneralChat[name]

		if inGeneralChat then
			if enabled then
				inGeneralChat.checkBox:setChecked(channel.inGeneral)

				function inGeneralChat.checkBox.onCheckChange(widget, checked)
					channel.inGeneral = checked

					self:saveSettings()
				end
			else
				inGeneralChat:hide()
			end
		end

		local openChat = settingsPanel.openChats[name]

		if openChat then
			if enabled then
				openChat.checkBox:setChecked(channel.open)

				function openChat.checkBox.onCheckChange(widget, checked)
					self:openChannelTab(name, checked)

					channel.open = checked

					self:saveSettings()
				end
			else
				openChat:hide()
			end
		end
	end

	self.allowSave = true

	if self.settings.default then
		self:saveSettings()
	end
end

function GameChat:setupTrueFalseSetting(name, settingsPanel, callback)
	settingsPanel = settingsPanel or self.window.main.settingsPanel.settings

	local widget = settingsPanel[name]

	if not widget then
		print("GameChat.setupTrueFalseSetting - setting widget not found", name)

		return
	end

	local setting = self.settings[name]

	if setting == nil then
		print("GameChat.setupTrueFalseSetting - setting not found", name)

		return
	end

	if widget.trueFalseSelect:isOn() ~= setting then
		widget.trueFalseSelect:onClick()
	end

	connect(widget.trueFalseSelect, {
		onStateChange = function(widget)
			self.settings[name] = widget:isOn()

			self:saveSettings()

			if callback then
				callback(widget, widget:isOn())
			end
		end
	})

	if callback then
		callback(widget, setting)
	end
end

function GameChat:saveSettings()
	if not self.allowSave then
		return
	end

	self.settings.default = false

	g_settings.setNode("GameChat", self.settings)

	if self.saveEvent then
		removeEvent(self.saveEvent)

		self.saveEvent = nil
	end

	self.saveEvent = scheduleEvent(function()
		g_settings.save()
	end, 200)
end

function GameChat:getChannelSettings(channelName)
	return self.settings.channels[channelName]
end

function GameChat:openChannelTab(channelName, open, dontUpdateSettings, selectAfter)
	local tab = self.tabs[channelName]

	if not tab then
		print("GameChat.openChannelTab - tab not found", channelName)

		return
	end

	local player = g_game.getLocalPlayer()

	if open and tab.hidden and not tab:canShow(player) then
		return
	end

	if open and not tab.hidden then
		return
	elseif not open and tab.hidden then
		return
	end

	local chatTabBar = self.window.main.topPanel.content.chatTabBar

	if not open then
		chatTabBar:hideTab(tab)
	elseif tab.hidden then
		chatTabBar:showTab(tab, 40)
	end

	self:updateTabDisplay(chatTabBar, nil, tab)

	if not dontUpdateSettings then
		local settings = self:getChannelSettings(channelName)

		if settings then
			settings.open = open

			self:saveSettings()
		end
	end

	if selectAfter then
		addEvent(function()
			self:selectTab(tab)
		end)
	end
end

function GameChat:toggleSettings(hightlightSetting)
	local settingsPanel = self.window.main.settingsPanel
	local visible = not settingsPanel:isVisible()

	settingsPanel:setVisible(visible)

	if visible then
		settingsPanel:raise()

		if hightlightSetting then
			local targetWidget = type(hightlightSetting) == "string" and settingsPanel:recursiveGetChildById(hightlightSetting) or hightlightSetting

			if targetWidget then
				g_effects.startBlink(targetWidget, 2000, 230, true)
			end
		end
	elseif not g_layout.isEditMode() then
		self.window.main.bottomPanel.messageInput:setEnabled(true)
		self.window.main.bottomPanel.messageInput:recursiveFocus(ActiveFocusReason)
	end
end

function GameChat:setFontSize(fontSize)
	self.settings.fontSize = fontSize

	local font = self:getFont()

	for _, tab in pairs(self.tabs) do
		self:setWidgetFont(tab.tabPanel, font)
	end

	for _, tab in pairs(self.privateTabs) do
		self:setWidgetFont(tab.tabPanel, font)
	end

	self:saveSettings()
end

function GameChat:setWidgetFont(widget, font)
	font = font or self:getFont()

	widget:setFont(font)
	widget:updateLayout()

	for _, child in pairs(widget:recursiveGetChildren()) do
		child:setFont(font)
		child:updateLayout()
	end
end

function GameChat:getFont()
	local fontSize = self.settings.fontSize or cfg.defaultFontSize

	return cfg.defaultFont .. "-" .. fontSize
end

function GameChat:setOpacity(opacity)
	self.window.opacityWidgets = self.window.opacityWidgets or self.window:recursiveGetChildrenByField("configurableOpacity", true, false)

	for _, child in pairs(self.window.opacityWidgets) do
		child:setOpacity(opacity)
	end

	self.settings.opactity = opacity * 100

	self:saveSettings()
end

function GameChat:setBackgroundOpacity(opacity)
	self.window.main.background:setOpacity(opacity)

	self.settings.backgroundOpacity = opacity * 100

	self:saveSettings()
end

function GameChat:setPopoutMessageHideDelay(delay)
	self.settings.hidePopoutMessageDelay = delay

	local togglePopupButton = self.window.minimized:recursiveGetChildById("togglePopupButton")

	if delay == 0 then
		self:togglePopupChat(false)
		togglePopupButton:setOn(true)

		togglePopupButton.enabled = false

		togglePopupButton:setTooltip(tr("Disabled in chat settings\n(Hide Popout Message)"))
	else
		if not togglePopupButton.enabled then
			self:togglePopupChat(true)

			togglePopupButton.enabled = true

			togglePopupButton:setOn(false)
			togglePopupButton:setTooltip(togglePopupButton:getTooltipMessage())
		end

		if self.popoutMessageHideDelayMax then
			if delay >= self.popoutMessageHideDelayMax then
				self:clearPopoutMessageEvents(true)
			else
				self:clearPopoutMessageEvents(false, {
					delay = delay
				})
			end
		end
	end

	self:saveSettings()
end

function GameChat:togglePopupChat(toggle)
	self.hidePopoutMessage = not toggle

	if self.currentTab.hiddenBufferPanel then
		if toggle then
			if self.window.main:isExplicitlyVisible() then
				self.currentTab.hiddenBufferPanel:show()
				self.currentTab.hiddenBufferPanel:setOpacity(1)
				self:clearPopoutMessageEvents(false, {})
			else
				self.currentTab.hiddenBufferPanel:show()
				g_effects.fadeIn(self.currentTab.hiddenBufferPanel, 200)
				self:clearPopoutMessageEvents(false, {
					delay = self.settings.hidePopoutMessageDelay
				})
			end
		else
			self:clearPopoutMessageEvents(true)

			if self.window.main:isExplicitlyVisible() then
				self.currentTab.hiddenBufferPanel:hide()
				self.currentTab.hiddenBufferPanel:setOpacity(0)
			else
				g_effects.fadeOut(self.currentTab.hiddenBufferPanel, 200, 0, false, function(widget)
					widget:hide()
				end)
			end
		end
	end
end

function GameChat:clearPopoutMessageEvents(resetOpacity, reconfigure)
	if self.currentTab.hiddenBufferPanel then
		for _, child in ipairs(self.currentTab.hiddenBufferPanel:getChildren()) do
			if child.fadeOut then
				removeEvent(child.fadeOut)

				child.fadeOut = nil
			end

			if child.fadeEvent then
				removeEvent(child.fadeEvent)

				child.fadeEvent = nil

				if child.fadeOutCallback then
					child.fadeOutCallback = nil
				end

				if resetOpacity then
					child:setOpacity(1)
				end
			end

			if reconfigure then
				child:setOpacity(1)
				self:configureHiddenPanelMessage(child, reconfigure.panel or self.currentTab.messageBufferPanel, reconfigure.delay or 5000)
			end
		end
	end
end

function GameChat:getChannelConfig(channelName, selectionName)
	channelName = channelName:lower()
	selectionName = selectionName and selectionName:lower() or nil

	if not selectionName then
		local language = globalNameToLanguage[channelName]

		if language then
			channelName = "global"
			selectionName = language
		end
	end

	local config = cfg.channelConfigs[channelName]

	if not config then
		return
	end

	if selectionName then
		config = config.selection[selectionName]

		if not config then
			print("unhandled subchannel: " .. selectionName)

			return
		end
	end

	return config
end

function GameChat:setGlobalChannelId(channelName)
	local config = self:getChannelConfig("global", channelName)

	if not config then
		return
	end

	self.global.channelId = config.channelId
end

function GameChat.setGlobalChatLanguage(widget, optionText, data)
	local self = GameChat
	local config = self:getChannelConfig("global", data.language)

	if not config then
		return
	end

	local tab = self.tabs.global

	if not tab then
		print("GameChat.setGlobalChatLanguage - tab not found", "global")

		return
	end

	tab:setImageSource(string.format("/images/ui/windows/chat/icon_%s", config.buffer))
	tab:setTooltip(config.tooltip)

	tab.name = config.buffer

	self:setGlobalChannelId(data.language)

	self.global.channelName = config.buffer
	self.settings.globalChat = data.language

	self:saveSettings()

	if self.currentTab.name and self.currentTab.name:starts("global") then
		self:selectTab(tab, true, true)
	end
end

function GameChat.onTalk(name, level, mode, text, channelId, pos, senderId, hash, senderPremium, groupId, creatureType, messageType, tabName)
	local self = GameChat
	local config = cfg.talkModeSettings[mode]

	if not config then
		print("unhandled message mode: " .. mode, text)

		return
	end

	local social = modules.game_social.GameSocial

	if social:isIgnored(name) then
		return
	end

	name = name and name:lower()

	local tab

	for _, info in pairs(cfg.channelConfigs) do
		if info.selection then
			for _, selection in pairs(info.selection) do
				if selection.channelId and selection.channelId == channelId then
					tab = selection.buffer
					config.channelId = channelId

					break
				end
			end
		end

		if info.channelId and info.channelId == channelId then
			tab = info.name
			config.channelId = channelId

			break
		end
	end

	tab = tab or config.tab

	local forceToGeneral = false

	if not tab and config.private then
		tab = tabName or name

		local player = g_game.getLocalPlayer()

		if player and player:getName():lower() == tab then
			return
		end

		if not self.privateTabs[tab] then
			if self.settings.autoOpenPrivateMessages then
				self:addPrivateTab(tab, true)

				forceToGeneral = true
			else
				self.unansweredSender = tab:titleCase(true)
			end

			local info = cfg.channelConfigs.general

			config.channelId = info.channelId
		end
	elseif tab and tab == "guild" and messageType == GuildLogoutMessageType and not self.settings.guildLoginNotifications then
		return
	end

	if creatureType == CreatureTypeNpc then
		text = tr(text)
	end

	local customTextColor

	if mode == TalkTypes.TalkTypeSay then
		local creature = g_map.getCreatureById(senderId)

		if creature then
			local speechBubble = g_ui.createWidget("SpeechBubble")

			speechBubble:setValue(not creature:isPlayer() and pcalltr(text) or text)
			speechBubble:setHash(hash)
			speechBubble:setOwner(creature)
			speechBubble:display(creature)

			if creature:isNpc() then
				customTextColor = cfg.npcTextColor
			end

			if senderPremium then
				local player = g_game.getLocalPlayer()
				local isMessageSent = player and player:getName():lower() == name:lower()
				local textColor = isMessageSent and cfg.premiumTextColor.send or cfg.premiumTextColor.receive

				speechBubble.text:setTextColor(textColor)
			end
		end
	end

	self:addMessageWidget(name:titleCase(true), text, tab, config, senderId, customTextColor, senderPremium, nil, name, groupId, forceToGeneral)
end

function GameChat.onTextMessage(mode, text)
	if #text == 0 then
		if mode == TextTypes.TextTypeScreenBox or mode == TextTypes.TextTypeScreenBoxNoDuration then
			GameScreenMessage:hide()
		end

		return
	end

	local config = cfg.textModeSettings[mode]

	if not config then
		print("unhandled message mode: " .. mode, text)

		return
	end

	local tab = config.tab or "general"

	if mode == TextTypes.TextTypeSpeechBubble then
		local player = g_game.getLocalPlayer()

		if player then
			local speechBubble = g_ui.createWidget("SpeechBubble")

			speechBubble:setValue(pcalltr(text))

			local textColor = config.color

			if player:isPremium() then
				textColor = cfg.premiumTextColor.send
			end

			speechBubble:display(player, textColor, true)
		end
	end

	if mode == TextTypes.TextTypeScreenBox or mode == TextTypes.TextTypeScreenBoxNoDuration then
		GameScreenMessage:display(text, mode == TextTypes.TextTypeScreenBoxNoDuration and -1 or nil)

		return
	end

	if mode == TextTypes.TextTypeScreenError then
		GameNotification:displayScreenMessage(text)

		return
	end

	if tab ~= "battle" and config.type then
		GameNotification:display(config.type, nil, text)
	end

	if text:find("%%") and not text:find("%%%%") then
		text = text:gsub("%%", "%%%%")
	end

	text = tr(text)
	GameChat.messageQueueSize = GameChat.messageQueueSize + 1
	GameChat.events[GameChat.messageQueueSize] = scheduleEvent(function()
		GameChat:addMessageWidget(text, nil, tab, config, nil, config.color)
	end, math.max(100, GameChat.messageQueueSize * 100))
end

function GameChat:getTabWidgetByName(name)
	name = name:starts("global_") and "global" or name:lower()

	return self.tabs[name] or self.privateTabs[name]
end

function GameChat:selectTab(tab, virtual, force)
	if not self.enabled and not force then
		return false
	end

	if not tab then
		print("tab not found", debug.traceback())

		return false
	end

	if type(tab) == "string" then
		tab = self:getTabWidgetByName(tab:lower())
	end

	if not tab or not tab.name then
		print("tab not found", tab and tab.name or "nil", debug.traceback())

		return false
	end

	if not virtual and (self.currentTab.name ~= tab.name or force) then
		if not tab:isVisible() and tab.name ~= "general" then
			self:selectTab("general", virtual, force)
		else
			tab:getParent():selectTab(tab)
		end

		return true
	end

	if self.currentTab.hiddenBufferPanel then
		for _, child in ipairs(self.currentTab.hiddenBufferPanel:getChildren()) do
			if child.fadeOut then
				removeEvent(child.fadeOut)

				child.fadeOut = nil
			end

			if child.fadeEvent then
				removeEvent(child.fadeEvent)

				child.fadeEvent = nil

				if child.fadeOutCallback then
					child.fadeOutCallback = nil
				end

				child:setOpacity(1)
			end

			if self.settings.autoClearPopupMessages then
				self.currentTab.hiddenBufferPanel:removeChild(child)
				child.buffer:addChild(child)
				child:setOn(false)
			end
		end
	end

	self.window.main.bottomPanel.inputType:setVisible(tab.name == "general")

	local scrollBar

	if self.currentTab.messageBufferPanel then
		self.currentTab.messageBufferPanel:hide()
		self.currentTab.messageBufferPanel:updateScrollBars()
	end

	if self.currentTab.widget then
		self.currentTab.widget:setOn(false)
	end

	self.currentTab.name = tab.name
	self.currentTab.widget = self:getTabWidgetByName(tab.name)

	tab:setChecked(true)

	if not tab.private then
		self.currentTab.widget:setOn(true)

		self.currentTab.private = false
	else
		if not self.privateTabs[tab.name] then
			self:selectTab("general", virtual)

			return true
		end

		self.currentTab.private = true
	end

	self.currentTab.messageBufferPanel = tab.private and self.privateTabs[tab.name].messageBufferPanel or self.messageBufferPanels[tab.name]

	if self.currentTab.messageBufferPanel then
		self.currentTab.messageBufferPanel:show()
		self.currentTab.messageBufferPanel:updateScrollBars()

		scrollBar = self.currentTab.messageBufferPanel.verticalScrollBar

		if scrollBar then
			scrollBar:increment(999999)
		end
	end

	self:clearNotifications(self.currentTab.name, self.currentTab.private)

	local textEditActive = true

	if not tab.private then
		for _, tab in pairs(self.privateTabs) do
			-- block empty
		end
	else
		textEditActive = true
	end

	local config = not self.currentTab.private and self:getChannelConfig(tab.name) or nil

	if config then
		self.currentTab.channelId = config.channelId
	end

	self.window.main.bottomPanel.messageInput:setOn(textEditActive)

	if textEditActive and not g_layout.isEditMode() then
		self.window.main.bottomPanel.messageInput:setEnabled(true)
		self.window.main.bottomPanel.messageInput:recursiveFocus(ActiveFocusReason)
	end

	self:resetTextInputPrefix()

	local icon = tab:getImageSource()

	if icon and not icon:empty() then
		self.window.minimized.sidePanel.topPanel.currentChat.icon:setImageSource(icon)
		self.window.minimized.sidePanel.topPanel.currentChat:setText("")
	else
		self.window.minimized.sidePanel.topPanel.currentChat.icon:setImageSource("")
		self.window.minimized.sidePanel.topPanel.currentChat:setText(tab:getText():shortCode())
	end

	if not self.settings.autoClearPopupMessages and self.currentTab.hiddenBufferPanel then
		self.currentTab.hiddenBufferPanel:destroyChildren()

		if self.currentTab.messageBufferPanel then
			for _, child in ipairs(self.currentTab.messageBufferPanel:getChildren()) do
				local widget = self:copyMessageWidget(child, self.currentTab.hiddenBufferPanel, nil)

				self:configureHiddenPanelMessage(widget, self.currentTab.messageBufferPanel)
			end
		end
	end

	if tab.name == "party" then
		local player = g_game.getLocalPlayer()

		if not player then
			return true
		end

		local isPartyMember = player:isPartyMember()

		if not isPartyMember then
			self:resetMessageBuffer("party")
		end
	end

	return true
end

function GameChat:chatMessageGetSelection(focusedChild)
	local widget = focusedChild:getFocusedChild()

	if not widget then
		return false
	end

	if widget.hasSelection and widget:hasSelection() then
		return widget:getSelection()
	end

	return false
end

function GameChat:copyCorrectSelectionToClipboard()
	local textEdit = self.window.main.bottomPanel.messageInput

	if textEdit:hasSelection() then
		return false
	end

	local currentBuffer = self.currentTab.messageBufferPanel

	if not currentBuffer then
		return false
	end

	local focusedChild = currentBuffer:getFocusedChild()

	if not focusedChild then
		return false
	end

	local selection = self:chatMessageGetSelection(focusedChild)

	if selection then
		g_window.setClipboardText(selection)

		return true
	end

	return false
end

function GameChat:sendMessage()
	if not self.enabled then
		if not IsTextEditActive() then
			self:enable()
		end

		return
	end

	local textEdit = self.window.main.bottomPanel.messageInput

	if self.settings.keepChatOpen and not g_layout.isEditMode() then
		textEdit:setEnabled(true)
		textEdit:recursiveFocus(ActiveFocusReason)
	end

	local message = textEdit:getText()

	if message then
		message = message:trim()
	else
		message = ""
	end

	if #message == 0 then
		if self:canHide() then
			self:disable()
		end

		return
	end

	if not textEdit:isEnabled() then
		return
	end

	local player = g_game.getLocalPlayer()
	local prefix = textEdit:getParent().inputType

	if prefix and prefix.name or self.currentTab.private then
		local name = prefix and prefix.name and prefix.name:lower() or self.currentTab.name

		self:whisperPlayer(name)
		g_game.talkPrivate(TalkTypes.TalkTypePrivateTo, name, message)
		self.onTalk(player:getName(), player:getLevel(), TalkTypes.TalkTypePrivateTo, message, nil, player:getPosition(), player:getId(), nil, player:isPremium(), player:getGroupId(), CreatureTypePlayer, 0, name)
	elseif message:sub(1, 5) == "/lua " then
		local code = message:sub(6)

		g_game.talkChannel(TalkTypes.TalkTypeChannelWhite, cfg.LuaChannelId, code)
	elseif self.currentTab.name:starts("global") or self.currentTalkType:lower() == "global" then
		g_game.talkChannel(TalkTypes.TalkTypeChannelWhite, self.global.channelId, message)
	elseif self.currentTab.name == "party" or self.currentTab.name == "general" and self.currentTalkType:lower() == "party" then
		self:openChannelTab("party", player:isPartyMember())

		local config = cfg.channelConfigs.party

		g_game.talkChannel(TalkTypes.TalkTypeChannelYellow, config.channelId, message)
	elseif self.currentTab.name == "guild" or self.currentTab.name == "general" and self.currentTalkType:lower() == "guild" then
		local config = cfg.channelConfigs.guild

		g_game.talkChannel(TalkTypes.TalkTypeChannelYellow, config.channelId, message)
	elseif self.currentTab.name == "lfg" or self.currentTab.name == "general" and self.currentTalkType:lower() == "looking for group" then
		local config = cfg.channelConfigs.lfg

		g_game.talkChannel(TalkTypes.TalkTypeChannelYellow, config.channelId, message)
	elseif self.currentTab.name == "trade" or self.currentTab.name == "general" and self.currentTalkType:lower() == "trade" then
		local config = cfg.channelConfigs.trade

		g_game.talkChannel(TalkTypes.TalkTypeChannelYellow, config.channelId, message)
	elseif self.currentTab.private then
		g_game.talkPrivate(TalkTypes.TalkTypePrivateTo, self.currentTab.name, message)
		addEvent(function()
			self.onTalk(player:getName(), player:getLevel(), TalkTypes.TalkTypeGameMasterPrivateFrom, message, nil, player:getPosition(), player:getId(), player:isPremium(), 0, 0, self.currentTab.name)
		end)
	else
		g_game.talk(message)
	end

	if self.settings.hideChatOnSend and not self.window.main.settingsPanel:isVisible() and not g_layout.isEditMode() then
		self:disable()
	end

	self:addToMessageHistory(message)
	textEdit:setText(nil)
	self:resetTextInputPrefix()
	self:resetMessageHistoryPos()
end

function GameChat:addToMessageHistory(message)
	local history = self.messageHistory

	table.insert(history, 1, message)

	if #history > cfg.messageHistorySize then
		table.remove(history)
	end
end

function GameChat:navigateMessageHistory(direction)
	local history = self.messageHistory

	if #history == 0 then
		return
	end

	if not self.window.main.bottomPanel.messageInput:isOn() then
		return
	end

	self.messageHistoryPos = self.messageHistoryPos + direction

	if self.messageHistoryPos > #history then
		self.messageHistoryPos = #history
	end

	if self.messageHistoryPos < 1 then
		self.window.main.bottomPanel.messageInput:setText(nil)

		self.messageHistoryPos = 0

		return
	end

	self.window.main.bottomPanel.messageInput:setText(history[self.messageHistoryPos])
end

function GameChat:setupMessageBuffers()
	local bodyPanel = self.window.main.bodyPanel

	for id, config in pairs(cfg.channelConfigs) do
		if config.selection then
			local tabPanel = bodyPanel:recursiveGetChildById(string.format("%sTabPanel", id))

			if tabPanel then
				for _, selection in pairs(config.selection) do
					self.messageBuffers[selection.buffer] = {}
					self.messageBufferPanels[selection.buffer] = tabPanel:recursiveGetChildById(selection.buffer)
				end
			else
				print("message buffer panel not found", id, debug.traceback())
			end
		else
			self.messageBuffers[id] = {}
			self.messageBufferPanels[id] = self.tabs[id].tabPanel:recursiveGetChildById(string.format("%sMessagePanel", id))
		end
	end

	self.currentTab.hiddenBufferPanel = self.window.minimized.hiddenMessagePanel
end

function GameChat:resetMessageHistoryPos()
	self.messageHistoryPos = 0
end

function GameChat:resetMessageBuffer(tab)
	self.messageBuffers[tab] = {}

	local bufferPanel = tab and self.messageBufferPanels[tab] or self.currentTab.messageBufferPanel

	if bufferPanel then
		for _, widget in ipairs(bufferPanel:getChildren()) do
			bufferPanel:removeChild(widget)

			self.reusableWidgets[#self.reusableWidgets + 1] = widget
		end
	end
end

function GameChat:resetAllMessageBuffers()
	for name in pairs(self.messageBuffers) do
		self:resetMessageBuffer(name)
	end

	self:clearAllNotifications()
end

function GameChat:addToMessageBuffer(widget, tab, limit, private)
	local buffer = self.messageBuffers[tab] or private and self.privateTabs[tab] and self.privateTabs[tab].messageBuffer or nil

	if not buffer then
		print("buffer not found", tab, debug.traceback())

		return
	end

	table.insert(buffer, widget)

	if limit <= #buffer then
		local messageWidget = table.remove(buffer, 1)

		removeEvent(messageWidget.fadeOut)
		removeEvent(messageWidget.fadeOutEvent)
		messageWidget:setOn(false)
		messageWidget:getParent():removeChild(messageWidget)
		table.insert(self.reusableWidgets, messageWidget)
	end
end

function GameChat:getOrCreateMessageWidget(parent, config)
	config = config or {}

	if not config.font then
		config.font = self:getFont()
	end

	if #self.reusableWidgets == 0 then
		local widget

		if parent then
			widget = g_ui.createWidget("ChatMessage", parent)
		else
			widget = g_ui.createWidget("ChatMessage")
		end

		self:setWidgetFont(widget, config.font)

		return widget
	end

	local widget = table.remove(self.reusableWidgets, #self.reusableWidgets)

	self:setWidgetFont(widget, config.font)
	widget:show()
	widget.text:show()

	if parent then
		parent:addChild(widget)
	end

	return widget
end

function GameChat:addMessageWidget(title, text, tab, config, senderId, customTextColor, isPremium, internalGeneralChatMessage, name, groupId, forceToGeneral)
	if not text then
		self.messageQueueSize = self.messageQueueSize - 1
	end

	if senderId and self:isNpcId(senderId) and self.settings.hideNpcInGeneral then
		return
	end

	config.font = self:getFont()
	config.groupId = groupId
	tab = tab:lower()

	local tabWidget = tab and (config.private and self.privateTabs[tab] or self.messageBufferPanels[tab]) or nil

	if not tabWidget and not config.private then
		print("tab widget not found", tab, debug.traceback())
	end

	local buffer = tabWidget and (config.private and self.privateTabs[tab].messageBufferPanel or self.messageBufferPanels[tab])

	if not buffer then
		tab = "general"
		buffer = self.messageBufferPanels[tab]
	end

	local widget = self:getOrCreateMessageWidget(buffer, config)

	widget.buffer = buffer

	widget.text:setText(text)
	widget.title.time:setText(os.date("%I:%M %p"))

	local channelPrefix = cfg.chatMessageTitlePrefix[tab] or cfg.chatMessageTitlePrefix[config.private and "private" or ""] or ""
	local player = g_game.getLocalPlayer()

	if player then
		if config.private then
			if senderId and (senderId == 0 or senderId ~= player:getId()) then
				g_sound.play(cfg.RECEIVE_WHISPER_SFX)
			else
				g_sound.play(cfg.SEND_WHISPER_SFX)
			end
		elseif senderId and senderId > 0 and senderId == player:getId() then
			g_sound.play(cfg.SEND_MESSAGE_SFX)
		end
	end

	function widget.onMousePress(widget, mousePos, mouseButton)
		if mouseButton == MouseRightButton then
			local menu = g_ui.createWidget("PopupMenu")
			local player = g_game.getLocalPlayer()

			if player and senderId and senderId > 0 and senderId ~= player:getId() then
				if self:isPlayerId(senderId) then
					menu:addOption(tr("Whisper"), function()
						self:whisperPlayer(title)
					end)

					if name then
						local social = modules.game_social.GameSocial

						if not social:isIgnored(name:titleCase(true)) then
							menu:addOption(tr("Ignore Player"), function()
								social:addIgnored(name:titleCase(true))
							end)
						else
							menu:addOption(tr("Remove from Ignored List"), function()
								social:removeIgnored(name:titleCase(true))
							end)
						end
					end

					menu:addOption(tr("Report Player"), function()
						modules.game_player_report.GamePlayerReport:requestReportWindow(title)
					end)
					menu:addSeparator()
				end

				menu:addOption(tr("Copy Name"), function()
					g_window.setClipboardText(widget.title:getText())
				end)
			end

			menu:addOption(tr("Copy Message"), function()
				local w = widget.text:isVisible() and widget.text or widget.title

				g_window.setClipboardText(w:getText())
			end)

			local selection = self:chatMessageGetSelection(widget)

			if selection then
				menu:addOption(tr("Copy selection"), function()
					g_window.setClipboardText(selection)

					return true
				end)
			end

			menu:display(mousePos)

			return true
		end
	end

	local isMessageSent = player and player:getName():lower() == title:lower()
	local textColor = customTextColor or isMessageSent and config.color.send or config.color.receive

	if tab == "party" then
		textColor = isMessageSent and cfg.partyTextColor.send or cfg.partyTextColor.receive

		self:openChannelTab("party", true, true, true)
	elseif tab == "guild" then
		textColor = isMessageSent and cfg.guildTextColor.send or cfg.guildTextColor.receive
	elseif tab == "lfg" then
		if isPremium then
			textColor = isMessageSent and cfg.premiumTextColor.send or cfg.premiumTextColor.receive
		else
			textColor = isMessageSent and cfg.LFGTextColor.send or cfg.LFGTextColor.receive
		end
	elseif tab == "trade" then
		textColor = isMessageSent and cfg.tradeTextColor.send or cfg.tradeTextColor.receive
	elseif tab:starts("global") and isPremium then
		textColor = isMessageSent and cfg.premiumTextColor.send or cfg.premiumTextColor.receive
	elseif tab == "general" and isPremium and not config.private then
		textColor = isMessageSent and cfg.premiumTextColor.send or cfg.premiumTextColor.receive
	end

	if isMessageSent then
		title = "You"
	end

	widget.text:setVisible(text ~= nil)
	widget.title:setColor(textColor)
	widget.text:setColor(textColor)
	self:configureTitleIcon(widget.title.title_icon, groupId)

	if channelPrefix ~= "" then
		channelPrefix = string.format("%s ", channelPrefix)
	end

	if string.sub(title, 1, 4) == "Loot" then
		widget.title:setColoredText(GetHighlightedText(string.format("%s%s", channelPrefix, title or ""), textColor))
	else
		widget.title:setText(string.format("%s%s", channelPrefix, title or ""))
	end

	self:addToMessageBuffer(widget, tab, config.bufferSize or cfg.messageBufferSize, tab ~= "general" and config.private)

	if player and player:getId() ~= senderId and (not tab:starts("global_") or self.global.channelName == tab) then
		self:addNotification(tab, tab ~= "general" and config.private, textColor)
	end

	if title == "" and tab == "guild" then
		widget.title:setText(text)
		widget.title:setColor("#FCBE7F")
		widget.text:setVisible(false)
	end

	if (not self.settings.autoClearPopupMessages or not self.enabled) and self.currentTab.name == tab then
		local hiddenWidget = widget

		if self.settings.autoClearPopupMessages then
			buffer:removeChild(hiddenWidget)
		else
			hiddenWidget = self:copyMessageWidget(widget, nil, config)
		end

		self.currentTab.hiddenBufferPanel:addChild(hiddenWidget)
		self:configureHiddenPanelMessage(hiddenWidget, buffer)
	end

	if title == "" and tab == "guild" then
		return
	end

	if not internalGeneralChatMessage and tab ~= "general" and (forceToGeneral or self:canAddToGeneralChat(tab, senderId, config.private)) then
		GameChat:addGeneralChatWidget(widget, config)
	end
end

function GameChat:canAddToGeneralChat(name, senderId, private)
	local isGlobal = name:starts("global_")
	local configName = isGlobal and "global" or name:lower()
	local channel = self.settings.channels[configName]

	if isGlobal and name ~= self.global.channelName then
		return false
	end

	if private then
		return false
	end

	if not channel or channel.inGeneral then
		return not senderId or not self:isNpcId(senderId) or not self.settings.hideNpcInGeneral
	end

	return false
end

function GameChat:copyMessageWidget(originalWidget, parent, config, linkToOriginal)
	local newWidget = self:getOrCreateMessageWidget(parent, config)

	newWidget.title:setText(originalWidget.title:getText())
	newWidget.title:setColor(originalWidget.title:getColor())

	newWidget.title.title_icon.type = originalWidget.title.title_icon.type

	newWidget.title.title_icon:setVisible(originalWidget.title.title_icon:isVisible())
	newWidget.title.time:setText(originalWidget.title.time:getText())
	newWidget.text:setText(originalWidget.text:getText())
	newWidget.text:setColor(originalWidget.text:getColor())
	newWidget.text:setVisible(not originalWidget.text:getText():empty())

	newWidget.onMousePress = originalWidget.onMousePress
	newWidget.buffer = originalWidget.buffer

	if linkToOriginal then
		connect(originalWidget, {
			onDestroy = function(widget)
				if newWidget and not newWidget:isDestroyed() then
					newWidget:destroy()
				end
			end
		})
	end

	return newWidget
end

function GameChat:addGeneralChatWidget(originalWidget, config)
	local buffer = self.messageBufferPanels.general
	local widget = self:copyMessageWidget(originalWidget, buffer, config)

	if (not self.settings.autoClearPopupMessages or not self.enabled) and self.currentTab.name == "general" then
		local hiddenWidget = widget

		hiddenWidget.buffer = buffer

		if self.settings.autoClearPopupMessages then
			buffer:removeChild(widget)
		else
			hiddenWidget = self:copyMessageWidget(widget, self.currentTab.hiddenBufferPanel, config)
		end

		self:configureHiddenPanelMessage(hiddenWidget, buffer)
	end

	self:addToMessageBuffer(widget, "general", cfg.messageBufferSize)
end

function GameChat:addPrivateTab(name, dontOpen)
	name = name:lower()

	local chatTabBar = self.window.main.topPanel.content.chatTabBar
	local tab = self.privateTabs[name]

	if not tab then
		local panel = g_ui.createWidget("ChatPrivateTabPanel", self.window.main.bodyPanel)

		tab = chatTabBar:addTab("", panel, nil, "ChatPrivateCloseButton", "ChatPrivateNotificationButton", {
			onCreate = function(tab)
				tab:setId(tab:getId() .. name)

				tab.ignoreTr = true

				tab:setText(name:titleCase(true))
				tab:setOn(true)

				tab.name = name
				tab.playerName = name
				tab.private = true
			end,
			onDestroy = function(tab)
				self:removePrivateTab(name)
			end
		})
		self.privateTabs[name] = tab

		self:setupPrivateMessageBuffer(tab)
	end

	if not dontOpen then
		addEvent(function()
			self:selectTab(name)
		end)
	else
		local closeButton = tab.closeButton

		closeButton:setStyle("ChatPrivateNotificationButton")
		tab:setChecked(false)
		addEvent(function()
			if tab:isVisible() then
				closeButton:show()
				closeButton:raise()
			end
		end)
	end
end

function GameChat:removePrivateTab(name)
	if self.currentTab.name:lower() == name:lower() then
		self:selectTab("general")
	end

	for _, widget in ipairs(self.privateTabs[name:lower()].messageBuffer) do
		local parent = widget:getParent()

		if parent then
			parent:removeChild(widget)
		end

		self.reusableWidgets[#self.reusableWidgets + 1] = widget
	end

	self.privateTabs[name:lower()] = nil
end

function GameChat:setupPrivateMessageBuffer(tab)
	local panel = tab.tabPanel:recursiveGetChildById("privateMessagePanel")

	panel:setId(tab.name .. "MessagePanel")

	tab.messageBufferPanel = panel
	tab.messageBuffer = {}
end

function GameChat:configureHiddenPanelMessage(hiddenWidget, buffer, hideDelay)
	hiddenWidget:setOn(true)

	hideDelay = hideDelay or self.settings.hidePopoutMessageDelay

	if not self.hidePopoutMessage and hideDelay < self.popoutMessageHideDelayMax then
		hiddenWidget.fadeOut = scheduleEvent(function()
			g_effects.fadeOut(hiddenWidget, 1000, nil, false, function()
				if not hiddenWidget then
					return
				end

				hiddenWidget.fadeOutEvent = nil

				if hiddenWidget:getParent() == self.currentTab.hiddenBufferPanel and self.settings.autoClearPopupMessages then
					self.currentTab.hiddenBufferPanel:removeChild(hiddenWidget)
					buffer:addChild(hiddenWidget)
					hiddenWidget:setOn(false)
					hiddenWidget:setOpacity(1)
				end
			end)

			hiddenWidget.fadeOut = nil
		end, hideDelay)
	elseif hiddenWidget.fadeOut then
		removeEvent(hiddenWidget.fadeOut)

		hiddenWidget.fadeOut = nil
	end
end

function GameChat:configureTitleIcon(icon, groupId)
	icon.type = nil
	groupId = groupId or 0

	if groupId >= 4 then
		icon.type = "staff"
	elseif groupId >= 2 then
		icon.type = "tutor"
	elseif isPremium then
		icon.type = "premium"
	end

	icon:setVisible(icon.type ~= nil)
end

function GameChat:addNotification(tab, private, textColor)
	local hasNotification = false

	if self.currentTab.name ~= tab or not self.enabled and self.currentTab.hiddenBufferPanel:getOpacity() < 1 then
		local tabName = tab

		if type(tab) == "string" then
			tab = self:getTabWidgetByName(tab:starts("global_") and "global" or tab:lower())
		end

		if not tab then
			print("GameChat.addNotification - no tab found", tabName, private)

			return
		end

		local channelConfig = self:getChannelConfig(tab.name)

		if not channelConfig or channelConfig.minimizedNotification or channelConfig.minimizedNotification == nil then
			tab.notificationCount = (tab.notificationCount or 0) + 1
		else
			tab.notificationCount = 0
		end

		if not private then
			if tab.notification then
				tab.notification.count = (tab.notification.count or 0) + 1

				tab.notification:setImageColor(textColor)
				tab.notification:setText(string.format("%s", tab.notification.count <= 99 and tab.notification.count or "..."))
				tab.notification:show()
			else
				tab:setOn(true)
			end

			hasNotification = true
		else
			tab.closeButton.count = (tab.closeButton.count or 0) + 1

			tab.closeButton:setText(string.format("%s", tab.closeButton.count <= 99 and tab.closeButton.count or "..."))
			tab:setOn(true)

			hasNotification = true
		end
	end

	if hasNotification then
		local ping = self.window.minimized.sidePanel.topPanel.ping

		ping:setVisible(self:getTabsWithNotificationsCount() > 0)
	end
end

function GameChat:getTabsWithNotificationsCount()
	local count = 0

	for name, tab in pairs(self.tabs) do
		if not tab.hidden and tab.notificationCount and tab.notificationCount > 0 then
			count = count + 1
		end
	end

	for name, tab in pairs(self.privateTabs) do
		if not tab.hidden and tab.notificationCount and tab.notificationCount > 0 then
			count = count + 1
		end
	end

	return count
end

function GameChat:clearNotifications(tab, private)
	if type(tab) == "string" then
		tab = self:getTabWidgetByName(tab:starts("global_") and "global" or tab:lower())
	end

	if not tab then
		print("no tab to clear notifications", tab)

		return
	end

	local hadNotification = (tab.notificationCount or 0) > 0

	tab.notificationCount = 0

	if not private then
		tab:setOn(false)

		if tab.notification then
			hadNotification = tab.notification.count and tab.notification.count > 0
			tab.notification.count = 0

			tab.notification:hide()
		end
	else
		hadNotification = tab.closeButton.count and tab.closeButton.count > 0
		tab.closeButton.count = 0

		if self.currentTab.name ~= tab.name then
			tab.closeButton:setText("0")
			tab:setOn(true)
		else
			tab:setOn(false)
		end
	end

	if hadNotification then
		local ping = self.window.minimized.sidePanel.topPanel.ping

		ping:setVisible(self:getTabsWithNotificationsCount() > 0)
	end
end

function GameChat:clearAllNotifications()
	for name in pairs(self.messageBufferPanels) do
		self:clearNotifications(name)
	end

	for name in pairs(self.privateTabs) do
		self:clearNotifications(name, true)
	end
end

function GameChat.onGameStart()
	GameChat:setupSettings()

	local player = g_game.getLocalPlayer()

	connect(player, {
		onPartyJoin = GameChat.onPartyJoin,
		onPartyLeave = GameChat.onPartyLeave,
		onGuildChange = GameChat.onGuildChange
	})

	if player and player:getName() ~= GameChat.lastCharacterName then
		GameChat:resetAllMessageBuffers()
	end

	GameChat.lastCharacterName = player:getName()

	GameChat:display()
end

function GameChat.onGameEnd()
	local self = GameChat
	local player = g_game.getLocalPlayer()

	disconnect(player, {
		onPartyJoin = self.onPartyJoin,
		onPartyLeave = self.onPartyLeave,
		onGuildChange = self.onGuildChange
	})
	self.window:hide()

	self.currentTab.name = "general"
	self.currentTab.widget = nil
	self.currentTab.private = nil

	if self.currentTab.hiddenBufferPanel then
		self.currentTab.hiddenBufferPanel:destroyChildren()
	end

	if self.resetWindow then
		self.resetWindow:destroy()

		self.resetWindow = nil
	end

	if player and player:getName() ~= GameChat.lastCharacterName then
		for _, privateTab in pairs(self.privateTabs) do
			privateTab:destroy()
		end
	end

	for _, event in pairs(self.events) do
		removeEvent(event)
	end

	self.events = {}
end

function GameChat:display()
	self.window:show()
	self:selectTab(self.currentTab.name, false, true)

	local player = g_game.getLocalPlayer()

	if player then
		local partyPanel = self.messageBufferPanels.party

		self:openChannelTab("party", player:isPartyMember() or #partyPanel:getChildren() > 0)
		self:openChannelTab("guild", player:hasGuild())
	end

	if self:canHide() then
		self:shrink()
	end
end

function GameChat:expand(instant)
	if self.enabled then
		return
	end

	self.sizeEventType = "expand"

	if self.windowChangeEvent then
		return
	end

	self.window.focused = true

	self.window:setPhantom(true)

	if not instant then
		self.window.main:removeAnchor(AnchorRight)

		local expandWidth = self.window.main.expandWidth or 500
		local stepMod = math.min(3, expandWidth / 500)
		local step = math.max(30, 30 * math.max(0, stepMod))

		scheduleEvent(function()
			self.window.minimized:setVisible(false)
			self.window.main:setVisible(true)
		end, step)

		if self.currentTab.messageBufferPanel then
			self.currentTab.messageBufferPanel:show()
		end

		self.enabled = true
		self.windowChangeEvent = cycleEvent(function()
			self.window.main:setWidth(math.min(expandWidth, self.window.main:getWidth() + step))

			if self.window.main:getWidth() >= expandWidth then
				removeEvent(self.windowChangeEvent)

				self.windowChangeEvent = nil

				self.window.main:setOn(true)
				self:selectTab(self.currentTab.name or "general", false, true)
				addEvent(function()
					modules.game_interface.focusHUDPanel()

					if not g_layout.isEditMode() then
						self.window.main.bottomPanel.messageInput:setEnabled(true)
						self.window.main.bottomPanel.messageInput:recursiveFocus(ActiveFocusReason)
					end
				end)
				self.window:setPhantom(false)
				self.window.main:addAnchor(AnchorRight, "parent", AnchorRight)
			end
		end, 10)
	else
		self.windowChangeEvent = nil

		self.window.minimized:setVisible(false)
		self.window.main:setVisible(true)
		self.window.main:setOn(true)

		self.enabled = true

		self:selectTab(self.currentTab.name or "general", false, true)
		addEvent(function()
			modules.game_interface.focusHUDPanel()

			if not g_layout.isEditMode() then
				self.window.main.bottomPanel.messageInput:setEnabled(true)
				self.window.main.bottomPanel.messageInput:recursiveFocus(ActiveFocusReason)
			end
		end)
		self.window:setPhantom(false)
		self.window.main:addAnchor(AnchorRight, "parent", AnchorRight)
	end
end

function GameChat:shrink(instant, force)
	if not force and not self.enabled or not self:canHide() then
		return
	end

	if not self.window.main:isOn() then
		return
	end

	self.window:setPhantom(false)

	if self.windowChangeEvent then
		removeEvent(self.windowChangeEvent)
	end

	self.sizeEventType = "shrink"
	self.enabled = false

	self.window.main:setOn(false)

	self.window.main.expandWidth = self.window.main:getWidth()

	if self.currentTab.messageBufferPanel then
		self.currentTab.messageBufferPanel:hide()
	end

	if self.currentTab.hiddenBufferPanel and self.hidePopoutMessage then
		self.currentTab.hiddenBufferPanel:hide()
	end

	local shrinkWidth = self.window.main.shrinkWidth or 50

	if instant then
		removeEvent(self.windowChangeEvent)

		self.windowChangeEvent = nil

		self.window.main:setWidth(shrinkWidth)
		self.window.main:addAnchor(AnchorRight, "parent", AnchorRight)
		self.window.main:setVisible(false)
		self.window:setPhantom(true)
		self.window.minimized:setVisible(true)
		modules.game_interface.resetHUDPanelFocus()
	else
		self.window.main:removeAnchor(AnchorRight)

		local stepMod = math.min(3, self.window.main:getWidth() / 500)
		local step = math.max(30, 30 * math.max(0, stepMod))

		self.windowChangeEvent = cycleEvent(function()
			self.window.main:setWidth(math.max(shrinkWidth, self.window.main:getWidth() - step))

			if self.window.main:getWidth() <= shrinkWidth then
				removeEvent(self.windowChangeEvent)

				self.windowChangeEvent = nil
				self.enabled = false

				self.window:setPhantom(true)
				self.window.main:setVisible(false)
				self.window.minimized:setVisible(true)
				modules.game_interface.resetHUDPanelFocus()
			end
		end, 10)
	end
end

function GameChat.onPositionChange(widget, position)
	local self = GameChat

	if self.window:containsPoint(g_window.getMousePosition()) then
		self:expand(true)
	else
		self:expand(true)

		if self:canHide() then
			self:shrink(true, true)
		end
	end
end

function GameChat.onMousePress(widget, position, button)
	local self = GameChat

	self.window.focused = self.window:containsPoint(position)

	if not self.window.focused and self.enabled then
		if self:canHide() then
			self:disable()
		else
			self.window.main.bottomPanel.messageInput:setEnabled(false)
			modules.game_interface.resetHUDPanelFocus()
		end
	elseif self.enabled then
		self.window.main.bottomPanel.messageInput:setEnabled(true)
	end
end

function GameChat:toggle()
	if self.enabled and self:canHide() then
		self:shrink()
	else
		self:expand()
	end
end

function GameChat:enable(notInstant)
	if self.enabled then
		return
	end

	self:expand(not notInstant)
end

function GameChat:disable()
	if not self.enabled then
		return
	end

	self:shrink()
	modules.game_interface.resetHUDPanelFocus()
end

function GameChat:disableOrHideSettings()
	if self.enabled then
		self:disable()
	elseif self.window.main.settingsPanel:isVisible() then
		self.window.main.settingsPanel:hide()
		addEvent(function()
			self:disable()
		end)
	end
end

function GameChat.onTabChange(tabBar, tab, lastTab)
	local self = GameChat

	if not self:selectTab(tab, true) and lastTab and not lastTab.hidden then
		addEvent(function()
			tabBar:selectTab(lastTab, true)
			tabBar:scrollTo(lastTab)
		end)
	else
		if lastTab then
			lastTab:setChecked(false)
		end

		tab:setChecked(true)
		addEvent(function()
			if self.enabled then
				if not g_layout.isEditMode() then
					self.window.main.bottomPanel.messageInput:setEnabled(true)
					self.window.main.bottomPanel.messageInput:recursiveFocus(ActiveFocusReason)
				end

				tabBar:scrollTo(tab)
			end
		end)
	end

	addEvent(function()
		GameChat:updateTabDisplay(tabBar, tab, lastTab)
	end)
end

function GameChat.onTabRemove(tabBar, tab)
	local self = GameChat
	local tab = tab:getText():lower()

	if tab == "general" then
		return
	end

	if self.privateTabs[tab] then
		self.privateTabs[tab]:destroy()

		self.privateTabs[tab] = nil
	end

	self:resetMessageBuffer(tab)
end

function GameChat:onTextInputChange(textInputWidget, text)
	local command = string.match(text, "^/([%w]+)")

	if command then
		local command = string.lower(command)

		text = string.sub(text, #command + 3)

		if command == "w" or command == "whisper" then
			local name = string.match(text, "^\"([^\"]+)\" ")

			if not name and not text:find("\"", 1, true) then
				name = string.match(text, "^([^%s]+) ")
			end

			if name and #name <= 20 then
				self:setTextInputPrefix(name)
			end
		elseif command == "r" or command == "reply" then
			if self.unansweredSender then
				self:addPrivateTab(self.unansweredSender)
				self.window.main.bottomPanel.messageInput:setText(nil)

				self.unansweredSender = nil
			end
		elseif command == "p" or command == "party" then
			local player = g_game.getLocalPlayer()

			if player and player:isPartyMember() then
				self:selectTab("party")
				self:onChangeInputType("Party", cfg.talkTypesColor.Party)
				self.window.main.bottomPanel.messageInput:setText(nil)
			end
		end
	end

	g_sound.play(cfg.TYPING_SFX)
end

function GameChat.onTextInputKeyPress(textInputWidget, keyCode, modifiers)
	if keyCode == KeyBackspace and textInputWidget:getText():len() == 0 then
		GameChat:resetTextInputPrefix()
	end

	GameChat:enable()
end

function GameChat:setTextInputPrefix(name)
	local prefix = self.window.main.bottomPanel.inputType

	prefix:setText("@To \"" .. name .. "\": ")
	prefix:setTextColor(cfg.talkTypesColor.Whisper)
	prefix:setOn(true)

	prefix.name = name

	self.window.main.bottomPanel.messageInput:setText(nil)
end

function GameChat:resetTextInputPrefix()
	local prefix = self.window.main.bottomPanel.inputType

	prefix:setText(nil)
	prefix:setOn(false)

	prefix.name = nil

	self.window.main.bottomPanel.inputType:setVisible(self.currentTab.name == "general")

	if not self.window.main.bottomPanel.inputType:isOn() then
		self:onChangeInputType(self.currentTalkType, cfg.talkTypesColor[self.currentTalkType])
	end
end

function GameChat:changeInputType(widget)
	local menu = g_ui.createWidget("ChatPopupMenu")

	for _, talkType in ipairs(cfg.talkTypes) do
		local add = true

		if talkType.name == "Party" then
			local player = g_game.getLocalPlayer()

			if not player or not player:isPartyMember() then
				add = false
			end
		elseif talkType.name == "Guild" then
			local player = g_game.getLocalPlayer()

			if not player or not player:hasGuild() then
				add = false
			end
		end

		if add then
			local id = talkType.id or talkType.name:lower()
			local config = self:getChannelConfig(id)

			if not config or config.enabled == nil or config.enabled then
				local option = menu:addOption(talkType.name, function()
					self:onChangeInputType(talkType.name, talkType.color)
				end)

				if option then
					option:setTextColor(talkType.color)
				end
			end
		end
	end

	menu:setGameMenu(true)
	addEvent(function()
		local pos = widget:getPosition()

		pos.y = pos.y - menu:getHeight()

		menu:display(pos)
	end)
end

function GameChat:updateTabDisplay(tabBar, tab, lastTab)
	if lastTab then
		if not lastTab.private and not self.settings.alwaysShowTabNames and tabBar:getCurrentTab() ~= lastTab then
			lastTab:setText("")
			lastTab:setWidth(40)
		end

		if lastTab.tabPanel then
			lastTab.tabPanel:hide()
		end
	end

	if tab and not tab.private then
		tab:setText(tr(tab.activeText))
		tab:setWidth(tab:getTextSize().width + 50)
	end

	if tabBar.updateTabs then
		tabBar:updateTabs()
		tabBar:onTabSizeChange()
	end

	if tab and tab.tabPanel then
		tab.tabPanel:show()
	end
end

function GameChat:onChangeInputType(talkType, color)
	self.currentTalkType = talkType

	local inputType = self.window.main.bottomPanel.inputType
	local messageInput = self.window.main.bottomPanel.messageInput

	inputType:setOn(false)
	inputType:setText(talkType)
	inputType:setTextColor(color)

	if not g_layout.isEditMode() then
		messageInput:setEnabled(true)
		messageInput:recursiveFocus(ActiveFocusReason)
	end

	if messageInput.lastPreview then
		messageInput:setTextPreview(messageInput.lastPreview)
	end

	if not inputType:isVisible() then
		return
	end

	if talkType == "Whisper" then
		messageInput.lastPreview = messageInput:getTextPreview()

		messageInput:setTextPreview("/w \"Name\"")
	end
end

function GameChat:selectNextTab()
	local tabBar = self.window.main.topPanel.content.chatTabBar

	if tabBar then
		tabBar:selectNextTab()
	end
end

function GameChat:selectPreviousTab()
	local tabBar = self.window.main.topPanel.content.chatTabBar

	if tabBar then
		tabBar:selectPrevTab()
	end
end

function GameChat.onReplaceChatMessage(from, channelId, originalMessage, newMessage, receiver)
	local self = GameChat
	local buffer = self.messageBufferPanels.general

	for _, widget in ipairs(buffer:getChildren()) do
		if widget.text:getText() == originalMessage then
			widget.text:setText(newMessage)

			break
		end
	end

	local buffer = self.currentTab.hiddenBufferPanel

	for _, widget in ipairs(buffer:getChildren()) do
		if widget.text:getText() == originalMessage then
			widget.text:setText(newMessage)

			break
		end
	end

	if receiver and #receiver > 0 then
		local receiver = receiver:lower()

		if not self.privateTabs[receiver] then
			receiver = from:lower()

			if not self.privateTabs[receiver] then
				return
			end
		end

		local buffer = self.privateTabs[receiver].messageBufferPanel

		for _, widget in ipairs(buffer:getChildren()) do
			if widget.text:getText() == originalMessage then
				widget.text:setText(newMessage)

				break
			end
		end
	end

	local tab = cfg.channelIdToBufferName[channelId]

	if not tab then
		return
	end

	tab = tab:lower()

	if not self.messageBuffers[tab] then
		return
	end

	local buffer = self.messageBufferPanels[tab]

	for _, widget in ipairs(buffer:getChildren()) do
		if widget.text:getText() == originalMessage then
			widget.text:setText(newMessage)

			break
		end
	end
end

function GameChat:whisperPlayer(name)
	name = name:lower()

	self:enable()

	if not self.privateTabs[name] then
		self:addPrivateTab(name, true)
	end

	self:selectTab(name)
end

function GameChat:isPlayerId(id)
	return id >= 268435456 and id <= 1073741824
end

function GameChat:isNpcId(id)
	return id >= 2147483648
end

function GameChat.onPartyJoin(player)
	local self = GameChat

	if player ~= g_game.getLocalPlayer() then
		return
	end

	self:openChannelTab("party", true, false, true)
end

function GameChat.onPartyLeave(player)
	local self = GameChat

	if player ~= g_game.getLocalPlayer() then
		return
	end

	if self:getChannelSettings("party").open then
		return
	end

	local messageBuffer = self.messageBufferPanels.party

	if #messageBuffer:getChildren() < 1 then
		self:openChannelTab("party", false)
	end
end

function GameChat.onGuildChange(player, guildId, oldGuildId)
	local self = GameChat

	if player ~= g_game.getLocalPlayer() then
		return
	end

	self:openChannelTab("guild", guildId > 0)
end

function GameChat:onDragEnter(mousePos)
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

function GameChat:onDragMove(mousePos, mouseMoved)
	local pos = {
		x = mousePos.x - self.movingReference.x,
		y = mousePos.y - self.movingReference.y
	}

	g_layout.snapToGrid(pos)
	self:setPosition(pos)
	self:bindRectToParent()
end

function GameChat:onDragLeave(droppedWidget, mousePos)
	if not g_layout.isEditMode() then
		return true
	end

	g_layout.save()

	return true
end

function GameChat.update()
	local isEditMode = g_layout.isEditMode()
	local editModePanel = GameChat.window:recursiveGetChildById("editModeBackground")

	editModePanel:setVisible(isEditMode)
	GameChat.window.main:setPhantom(isEditMode)
	GameChat.window.main.bodyPanel:setVisible(not isEditMode)

	if isEditMode then
		GameChat:enable()
	elseif GameChat:canHide() then
		GameChat:disable()
	end

	GameChat.window.main.settingsPanel:setVisible(false)
	addEvent(function()
		modules.game_interface.resetHUDPanelFocus()
	end)
end
