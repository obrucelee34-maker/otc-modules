-- chunkname: @/modules/game_settings/settings.lua

local localeSetConfirmBox

GameSettings = GameSettings or {}
LanguageAppearOrder = {
	"en-GB",
	"pt-BR"
}
LanguageSelectOrder = {
	"English",
	"Portugu\xEAs (Brasil)"
}
GameSettings.settingsWidgets = {
	slider = {},
	trueFalseSelect = {},
	comboBox = {}
}
GameSettings.settingsWidgetsById = {}
GameSettings.defaultOptions = {
	numBarsCrafting = 0,
	numBarsSpell = 2,
	displayBarHeaders = true,
	hideOthersDamage = false,
	damageView = 2,
	lookMessageWindow = false,
	smallUI = false,
	showCopyWarning = true,
	dragStackControl = true,
	effectsSpeed = 75,
	arcsTransparency = 100,
	otherWindowTransparancy = 100,
	mapWindowTransparancy = 100,
	inventoryWindowTransparancy = 100,
	healthWindowTransparancy = 100,
	chatWindowTransparancy = 100,
	displayOtherCastBar = true,
	displayOwnCastBar = 4,
	displayOtherAuras = true,
	displayOtherIcons = true,
	displayOtherManas = true,
	displayOtherHealths = true,
	displayOtherNames = true,
	displayOtherHUD = true,
	displayAura = true,
	displayIcons = true,
	displayMana = true,
	displayHealth = true,
	displayName = true,
	displayOwnHUD = true,
	displayArcs = false,
	displayBars = true,
	displayMiscMissiles = true,
	displayMonsterMissiles = true,
	displayPlayerMissiles = true,
	displayOwnMissiles = true,
	displayMissiles = true,
	displayMiscEffects = true,
	displayMonsterEffects = true,
	displayPlayerEffects = true,
	displayOwnEffects = true,
	displayEffects = true,
	displayText = true,
	showCasino = true,
	showMinimap = true,
	showVip = true,
	showInventory = true,
	showHome = true,
	showQuestLog = true,
	showStore = true,
	showSpells = true,
	showBattle = true,
	showPlayerInfo = true,
	showFeedback = true,
	showLeaderboard = true,
	showAutoLoot = true,
	showHotkeys = true,
	showLogout = true,
	showActionMessagesOfOthersInConsole = true,
	showActionMessagesInConsole = true,
	showActionsOfOthersOnScreen = false,
	showActionsOnScreen = false,
	showSpellsOfOthersOnScreen = true,
	showSpellsOnScreen = true,
	showPrivateMessagesOnScreen = true,
	showPrivateMessagesInConsole = true,
	showLevelsInConsole = true,
	showTimestampsInConsole = true,
	showInfoMessagesInConsole = true,
	showEventMessagesInConsole = true,
	showStatusMessagesInConsole = true,
	volumeVoice = 50,
	volumeUI = 50,
	volumeSFX = 50,
	volumeMusic = 50,
	volumeAmbiance = 50,
	volumeMaster = 50,
	walkCtrlTurnDelay = 0,
	walkTeleportDelay = 100,
	walkStairsDelay = 100,
	walkTurnDelay = 0,
	walkFirstStepDelay = 0,
	wasdWalking = false,
	ignoreServerDirection = true,
	keyboardDelay = 80,
	hotkeyDelay = 30,
	ignoreDuelInvites = false,
	hideCurrentChannel = false,
	preciseCrosshair = true,
	meleeAbilityQueue = true,
	mouseDirectionCasting = false,
	quickLooting = false,
	closestTargetRange = true,
	quickTargetRange = 5,
	showActionKey = true,
	quickTargetKey = "Tab",
	quickTarget = true,
	displayTargetHud = true,
	UIScale = 50,
	antiAliasing = false,
	floorFading = 500,
	ambientLight = 0,
	optimizationLevel = 1,
	backgroundFrameRate = 200,
	screenshotMode = false,
	enableLights = true,
	autoChaseOverride = true,
	dash = true,
	fasterWalkAnimation = false,
	slowWalk = false,
	smartWalk = true,
	classicControl = false,
	fullscreen = true,
	showPing = false,
	showFps = false,
	floorIndicatorMode = 1,
	threatIndicators = false,
	showActionBarTooltips = true,
	enableMapClick = false,
	spellBatchingInterval = 500,
	lifeManaBarType = 1,
	lifeManaBarSize = 1,
	showMessage = true,
	hideInterface = false,
	showFort = true,
	showStronghold = true,
	showLargeEstate = true,
	showMediumEstate = true,
	showSmallEstate = true,
	displayWeatherEffects = true,
	showSeaport = true,
	showHouse = true,
	showTradepost = true,
	showCraftingStation = true,
	showLevelBrackets = true,
	showZoneNames = true,
	showMissionAvailable = true,
	showMissionComplete = true,
	actionKeyOpacity = 80,
	vsync = true,
	hideBanditTutorial = false,
	chatBubbleFadeTime = "Normal",
	chatBubbleOpacity = 80,
	showLFGChatInGeneralChat = false,
	showGlobalChatInGeneralChat = false,
	showChatBubble = true,
	showQuestTracker = true,
	drawShineStairs = true,
	packOpeningAnimation = true,
	screenShake = true,
	drawResourceBars = true,
	drawManaBars = true,
	drawHealthBars = true,
	drawTitles = true,
	drawNames = true,
	layoutEditMode = false
}
GameSettings.loadOnOnline = {
	hideInterface = false,
	layoutEditMode = false
}
GameSettings.checkOnOnline = {
	"threatIndicators"
}
GameSettings.options = {}
GameSettings.extraOptions = {}
GameSettings.order = {
	"Graphics",
	"Audio & Language",
	"Windows",
	"Game",
	"Hotkeys"
}
GameSettings.settings = {
	["Audio & Language"] = {
		{
			type = "SettingsSliderOption",
			id = "volumeMaster",
			min = 0,
			max = 100,
			suffix = "%",
			text = "Master volume"
		},
		{
			type = "SettingsSliderOption",
			id = "volumeAmbiance",
			min = 0,
			max = 100,
			suffix = "%",
			text = "Ambience volume"
		},
		{
			type = "SettingsSliderOption",
			id = "volumeMusic",
			min = 0,
			max = 100,
			suffix = "%",
			text = "Music volume"
		},
		{
			type = "SettingsSliderOption",
			id = "volumeSFX",
			min = 0,
			max = 100,
			suffix = "%",
			text = "SFX volume"
		},
		{
			type = "SettingsSliderOption",
			id = "volumeUI",
			min = 0,
			max = 100,
			suffix = "%",
			text = "UI volume"
		},
		{
			type = "SettingsSliderOption",
			id = "volumeVoice",
			min = 0,
			max = 100,
			suffix = "%",
			text = "Voice volume"
		},
		{
			type = "GameSettingsComboBoxOption",
			id = "locale",
			text = "Select your language",
			requireRestart = true,
			values = LanguageSelectOrder
		}
	},
	Graphics = {
		{
			type = "GameSettingsTrueFalseOption",
			id = "fullscreen",
			text = "Fullscreen"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "antiAliasing",
			text = "Anti-aliasing"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "vsync",
			text = "Vertical-sync"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "displayWeatherEffects",
			text = "Display weather effects"
		},
		{
			type = "SettingsSliderOption",
			id = "floorFading",
			min = 0,
			max = 1000,
			suffix = " ms",
			text = "Floor fading"
		},
		{
			type = "SettingsSliderOption",
			id = "backgroundFrameRate",
			min = 10,
			max = 200,
			suffix = " fps",
			text = "Framerate limit"
		},
		{
			suffix = " %",
			id = "UIScale",
			max = 100,
			type = "SettingsSliderOption",
			text = "UI Scale",
			applyValueChange = true,
			width = 100,
			min = 0,
			displayFormat = function(value)
				return (0.75 + value / 100 * 0.5) * 100
			end
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "drawNames",
			text = "Draw names"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "drawTitles",
			text = "Draw titles"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "drawHealthBars",
			text = "Draw health bars"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "drawManaBars",
			text = "Draw mana bars"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "drawResourceBars",
			text = "Draw aether bars"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "screenShake",
			text = "Screen shake"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "packOpeningAnimation",
			text = "Pack Opening Animation"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "drawShineStairs",
			text = "Draw Shine Stairs"
		}
	},
	Windows = {
		{
			type = "GameSettingsComboBoxOption",
			id = "numBarsSpell",
			text = "Extra action bars",
			values = {
				0,
				1,
				2,
				3,
				4,
				5,
				6,
				7
			}
		},
		{
			type = "GameSettingsEditInterfaceOption",
			id = "layoutEditMode",
			text = "Edit UI"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "showQuestTracker",
			text = "Show quest tracker"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "showActionKey",
			text = "Show action key"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "showChatBubble",
			text = "Show chat bubbles"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "hideBanditTutorial",
			disabledValue = false,
			hideWhenDisabled = false,
			text = "Hide bandit tutorial",
			requireLevel = 15
		},
		{
			type = "GameSettingsComboBoxOption",
			id = "lifeManaBarSize",
			text = "Life/mana bar size",
			values = {
				"Large",
				"Small"
			}
		},
		{
			type = "GameSettingsComboBoxOption",
			id = "lifeManaBarType",
			text = "Life/mana bar type",
			values = {
				"Horizontal",
				"Vertical"
			}
		},
		{
			type = "SettingsSliderOption",
			id = "actionKeyOpacity",
			min = 0,
			max = 100,
			suffix = " %",
			text = "Action key opacity"
		},
		{
			type = "SettingsSliderOption",
			id = "chatBubbleOpacity",
			min = 0,
			max = 100,
			suffix = " %",
			text = "Chat bubble opacity"
		},
		{
			type = "GameSettingsComboBoxOption",
			id = "chatBubbleFadeTime",
			text = "Chat bubble fading",
			values = {
				"Slow",
				"Normal",
				"Fast"
			}
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "hideInterface",
			text = "Hide interface elements"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "screenshotMode",
			text = "Screenshot mode"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "showActionBarTooltips",
			text = "Action Bar Tooltips"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "threatIndicators",
			text = "Threat Indicators"
		},
		{
			type = "GameSettingsComboBoxOption",
			id = "acceptRequests",
			descWidth = 230,
			text = "Party/Trade/Guild Requests",
			values = {
				"Everyone",
				"Friends",
				"No One"
			}
		},
		{
			type = "GameSettingsRestorePromptsButton"
		}
	},
	Game = {
		{
			type = "GameSettingsComboBoxOption",
			id = "floorIndicatorMode",
			text = "Floor Indicators",
			values = {
				"Enabled",
				"Only Underground",
				"Disabled"
			}
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "displayTargetHud",
			text = "Display target HUD"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "quickTarget",
			text = "Quick targeting"
		},
		{
			type = "GameSettingsComboBoxOption",
			id = "quickTargetRange",
			text = "Targeting detect range",
			suffix = "  tiles",
			values = {
				1,
				2,
				3,
				4,
				5,
				6,
				7,
				8,
				9,
				10
			}
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "mouseDirectionCasting",
			text = "Mouse direction casting"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "closestTargetRange",
			text = "Targeting closest target"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "enableMapClick",
			text = "Click to move"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "smartWalk",
			text = "Smart walking"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "dragStackControl",
			text = "CTRL to drag full stacks"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "displayOtherCastBar",
			text = "Show others cast bar"
		},
		{
			type = "GameSettingsComboBoxOption",
			id = "displayOwnCastBar",
			text = "Show own cast bar",
			values = {
				"None",
				"Small",
				"Big",
				"Both"
			}
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "hideCurrentChannel",
			text = "Hide current channel"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "ignoreDuelInvites",
			text = "Ignore duel invites"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "meleeAbilityQueue",
			text = "Melee skill queue"
		},
		{
			type = "GameSettingsTrueFalseOption",
			id = "preciseCrosshair",
			text = "Precise Crosshair"
		},
		{
			type = "SettingsSliderOption",
			id = "spellBatchingInterval",
			min = 100,
			max = 1500,
			suffix = " ms",
			text = "Spell batching interval"
		}
	},
	Hotkeys = {}
}
GameSettings.settingsById = {}

for _, tab in pairs(GameSettings.settings) do
	for _, setting in pairs(tab) do
		if setting.id then
			GameSettings.settingsById[setting.id] = setting
		end
	end
end

GameSettings.playerSettings = {}

for _, tab in pairs(GameSettings.settings) do
	for _, setting in pairs(tab) do
		if (setting.requireLevel or setting.perPlayer or GameSettings.playerSettings[setting.id] ~= nil) and setting.id then
			GameSettings.playerSettings[setting.id] = setting
		end
	end
end

function GameSettings.init()
	g_ui.importStyle("styles/left_panel.otui")
	g_ui.importStyle("styles/right_panel.otui")
	g_ui.importStyle("styles/main.otui")
	g_ui.importStyle("styles/hotkeys.otui")

	GameSettings.window = g_ui.createWidget("GameSettingsWindow", modules.game_interface.getHUDPanel())

	GameSettings.window:hide()

	GameSettings.window.hotkeyId = HOTKEYS_IDS.SETTINGS
	GameSettings.content = GameSettings.window:recursiveGetChildById("content")
	GameSettings.leftPanel = GameSettings.window:recursiveGetChildById("leftPanel")
	GameSettings.rightPanel = nil
	GameSettings.rightBottomPanel = nil
	GameSettings.resetButton = GameSettings.window:recursiveGetChildById("resetButton")

	function GameSettings.resetButton.onClick()
		local function destroyWindow()
			if GameSettings.resetWindow ~= nil then
				GameSettings.resetWindow:destroy()

				GameSettings.resetWindow = nil
			end
		end

		local function resetAllSettings()
			GameSettings:resetSettings()
			destroyWindow()
		end

		destroyWindow()

		GameSettings.resetWindow = displayGeneralBox(tr("Reset Settings"), tr("Are you sure you want to reset all settings?"), {
			{
				text = tr("Yes"),
				callback = resetAllSettings
			},
			{
				text = tr("No"),
				callback = destroyWindow
			},
			anchor = AnchorHorizontalCenter
		}, resetAllSettings, destroyWindow)
	end

	for k, v in pairs(GameSettings.defaultOptions) do
		g_settings.setDefault(k, v)

		GameSettings.options[k] = v
	end

	for _, v in ipairs(g_extras.getAll()) do
		GameSettings.extraOptions[v] = g_extras.get(v)

		g_settings.setDefault("extras_" .. v, GameSettings.extraOptions[v])
	end

	GameSettings:setup()
	GameSettings:populateSettings()

	if g_game.isOnline() then
		GameSettings:onGameStart()
	end

	connect(g_game, {
		onGameStart = GameSettings.onGameStart,
		onGameEnd = GameSettings.onGameEnd
	})
	connect(LocalPlayer, {
		onLevelChange = GameSettings.onLevelChange
	})
end

function GameSettings.terminate()
	for _, tab in ipairs(GameSettings.tabs) do
		tab.panel:destroy()

		if tab.bottomPanel then
			tab.bottomPanel:destroy()
		end
	end

	GameSettings:resetEditHotkey()
	GameSettings.window:destroy()

	if GameSettings.resetWindow then
		GameSettings.resetWindow:destroy()
	end

	disconnect(g_game, {
		onGameStart = GameSettings.onGameStart,
		onGameEnd = GameSettings.onGameEnd
	})
	disconnect(LocalPlayer, {
		onLevelChange = GameSettings.onLevelChange
	})
end

function GameSettings:show()
	self.window:show()
	self.window:raise()
	self.window:focus()
end

function GameSettings:hide()
	self:resetEditHotkey()
	self.window:hide()
end

function GameSettings.toggle(mouseClick)
	if GameChat:isActive() or (type(mouseClick) ~= "boolean" or not mouseClick) and IsTextEditActive() then
		return
	end

	if not GameSettings.window then
		GameSettings.init()

		return
	end

	if GameSettings.window:isVisible() then
		GameSettings:hide()
	else
		if g_game:isInCutsceneMode() then
			return
		end

		GameSettings:show()
	end
end

function GameSettings.onLevelChange(localPlayer, level)
	for _, tab in pairs(GameSettings.settings) do
		for _, setting in pairs(tab) do
			if setting.requireLevel then
				local widget = setting.widget
				local enabled = level >= setting.requireLevel

				if widget and widget:isEnabled() ~= enabled then
					if setting.hideWhenDisabled then
						widget:setVisible(enabled)
					else
						widget:setEnabled(enabled)

						if not enabled then
							widget:recursiveGetChildById("description"):setText(string.format("%s. %s", setting.text, string.format("\n(Disabled until level %s)", setting.requireLevel)))
						end
					end

					if not enabled then
						GameSettings.setWidgetValue(widget, setting.disabledValue)
					else
						widget:recursiveGetChildById("description"):setText(setting.text)
					end
				end
			end
		end
	end
end

function GameSettings:getSettingWidgetAndValue(settingId, valueIdx)
	for _, tab in pairs(self.settings) do
		for _, setting in pairs(tab) do
			if setting.id == settingId then
				return setting.widget, setting.values[valueIdx]
			end
		end
	end

	return nil, nil
end

function GameSettings.setWidgetValue(widget, value)
	if value == nil then
		return
	end

	local styleName = widget:getStyleName()

	if styleName == "GameSettingsTrueFalseOption" or styleName == "GameSettingsEditInterfaceOption" then
		local trueFalseSelect = widget.trueFalseSelect

		if value and not trueFalseSelect:isOn() then
			trueFalseSelect:onClick()
		elseif value == false and trueFalseSelect:isOn() then
			trueFalseSelect:onClick()
		end
	elseif styleName == "SettingsSliderOption" then
		widget.slider:setValue(value)
	elseif styleName == "GameSettingsComboBoxOption" then
		widget.comboBox:setCurrentOption(value)
	end
end

function GameSettings.onGameStart()
	GameSettings:loadOnOnlineSettings()
	GameSettings:loadPlayerSettings()

	local player = g_game.getLocalPlayer()

	GameSettings.onLevelChange(player, player:getLevel())
end

function GameSettings:loadOnOnlineSettings()
	for k, v in pairs(GameSettings.loadOnOnline) do
		if type(v) == "boolean" then
			GameSettings:setOption(k, v, true, true)
			GameSettings:setScreenOption(k, v, true)
		elseif type(v) == "number" then
			GameSettings:setOption(k, v, true, true)
			GameSettings:setScreenOption(k, v, true)
		end
	end

	for _, k in ipairs(GameSettings.checkOnOnline) do
		GameSettings:setOption(k, g_settings.getBoolean(k), true, true)
	end
end

function GameSettings:loadPlayerSettings()
	for k, setting in pairs(self.playerSettings) do
		local node = g_settings.getNode(setting.id) or {}
		local value = node[g_game.getCharacterName()]

		if value ~= nil then
			GameSettings:setOption(setting.id, value, true, true)

			local widget = self.settingsWidgetsById[setting.id]

			if widget then
				GameSettings.setWidgetValue(widget, value)
			end
		end
	end
end

function GameSettings.onGameEnd()
	GameSettings:hide()
end

function GameSettings:setup()
	for k, v in pairs(GameSettings.defaultOptions) do
		if type(v) == "boolean" then
			self:setOption(k, g_settings.getBoolean(k), true, true)
		elseif type(v) == "number" then
			self:setOption(k, g_settings.getNumber(k), true, true)
		elseif type(v) == "string" then
			self:setOption(k, g_settings.getString(k), true, true)
		end
	end
end

function GameSettings:selectTab(id)
	if type(id) == "string" then
		id = tonumber(id)
	end

	if self.currentTab == id then
		return
	end

	self:resetEditHotkey()

	if self.currentTab and self.currentTab > 0 and self.currentTab <= #self.tabs then
		self.tabs[self.currentTab].button:setOn(false)
		self.tabs[self.currentTab].button.text:setOn(false)
		self.tabs[self.currentTab].button.icon:setOn(false)
	end

	if self.rightPanel then
		self.rightPanel.verticalScrollBar:hide()
		self.content:removeChild(self.rightPanel)
	end

	if self.rightBottomPanel then
		self.content:removeChild(self.rightBottomPanel)
	end

	self.tabs[id].button:setOn(true)
	self.tabs[id].button.text:setOn(true)
	self.tabs[id].button.icon:setOn(true)

	self.currentTab = id
	self.rightPanel = self.tabs[id].panel
	self.rightBottomPanel = self.tabs[id].bottomPanel

	self.content:addChild(self.rightPanel)
	self.rightPanel:fill("parent")
	self.rightPanel:addAnchor(AnchorLeft, "prev", AnchorRight)
	self.rightPanel.verticalScrollBar:show()

	local scrollbarMargin = 25

	if self.rightBottomPanel then
		self.content:addChild(self.rightBottomPanel)
		self.rightBottomPanel:addAnchor(AnchorBottom, "parent", AnchorBottom)
		self.rightBottomPanel:addAnchor(AnchorRight, "parent", AnchorRight)
		self.rightBottomPanel:addAnchor(AnchorLeft, "prev", AnchorLeft)

		local bottomMargin = self.rightBottomPanel:getHeight() + self.rightBottomPanel:getMarginBottom() + 3

		self.rightPanel:setMarginBottom(bottomMargin)

		scrollbarMargin = scrollbarMargin + bottomMargin
	end

	self.rightPanel.verticalScrollBar:setMarginBottom(scrollbarMargin)
end

function GameSettings:getOption(key)
	return self.options[key]
end

function GameSettings:setOption(key, value, force, dontSave)
	if self.extraOptions[key] ~= nil then
		g_extras.set(key, value)
		g_settings.set("extras_" .. key, value)

		if key == "debugProxy" and modules.game_proxy then
			if value then
				modules.game_proxy.show()
			else
				modules.game_proxy.hide()
			end
		end

		return
	end

	if modules.game_interface == nil then
		return
	end

	if not force and self.options[key] == value then
		return
	end

	local gameMapPanel = modules.game_interface.getMapPanel()
	local rootPanel = modules.game_interface.getRootPanel()
	local oldValue = self.options[key]

	self.options[key] = value

	if key == "vsync" then
		g_window.setVerticalSync(value)
	elseif key == "showFps" then
		-- block empty
	elseif key == "showPing" then
		-- block empty
	elseif key == "fullscreen" then
		g_window.setFullscreen(value)
	elseif key == "volumeSFX" then
		if g_sound ~= nil then
			g_sound.setVolume(VOLUME_SFX, value)
		end
	elseif key == "volumeUI" then
		if g_sound ~= nil then
			g_sound.setVolume(VOLUME_UI, value)
		end
	elseif key == "volumeVoice" then
		if g_sound ~= nil then
			g_sound.setVolume(VOLUME_VOICE, value)
		end
	elseif key == "volumeMaster" then
		if g_sound ~= nil then
			g_sound.setVolume(VOLUME_MASTER, value)
		end
	elseif key == "volumeMusic" then
		if g_sound ~= nil then
			g_sound.setVolume(VOLUME_MUSIC, value)
		end
	elseif key == "volumeAmbiance" then
		if g_sound ~= nil then
			g_sound.setVolume(VOLUME_AMBIANCE, value)
		end
	elseif key == "locale" then
		local locale = LanguageAppearOrder[tonumber(value)]

		if locale == "pt-BR" then
			return EnterGame.confirmPTBRLocale(locale, oldValue)
		end

		EnterGame.setLocale(locale)

		return
	elseif key == "backgroundFrameRate" then
		local text, v = value, value

		if value <= 0 or value >= 201 then
			text = "Unlimited"
			v = 0
		end

		g_app.setMaxFps(v)
	elseif key == "UIScale" then
		local scale = 0.75 + value / 100 * 0.5
		local menu = modules.game_menu.Menu

		menu.scaleMultiplier = scale

		menu.onResize(true)
	elseif key == "enableLights" then
		gameMapPanel:setDrawLights(value and self.defaultOptions.ambientLight < 100)
	elseif key == "floorFading" then
		gameMapPanel:setFloorFading(value)
	elseif key == "ambientLight" then
		gameMapPanel:setMinimumAmbientLight(value / 100)
		gameMapPanel:setDrawLights(self.defaultOptions.enableLights and value < 100)
	elseif key == "drawNames" then
		gameMapPanel:setDrawNames(value)
	elseif key == "drawTitles" then
		gameMapPanel:setDrawTitles(value)
	elseif key == "drawHealthBars" then
		gameMapPanel:setDrawHealthBars(value)
	elseif key == "drawManaBars" then
		gameMapPanel:setDrawManaBars(value)
	elseif key == "drawResourceBars" then
		gameMapPanel:setDrawResourceBars(value)
	elseif key == "optimizationLevel" then
		g_adaptiveRenderer.setLevel(value)
	elseif key == "chatWindowTransparancy" then
		local miniWindow

		miniWindow = rootPanel:recursiveGetChildById("gameChatPanel")

		if miniWindow then
			miniWindow:setOpacity(value / 100)
		end
	elseif key == "healthWindowTransparancy" then
		local miniWindow

		miniWindow = rootPanel:recursiveGetChildById("healthInfoWindow")

		if miniWindow then
			miniWindow:setOpacity(value / 100)
		end
	elseif key == "inventoryWindowTransparancy" then
		local miniWindow

		miniWindow = rootPanel:recursiveGetChildById("inventoryWindow")

		if miniWindow then
			miniWindow:setOpacity(value / 100)
		end
	elseif key == "mapWindowTransparancy" then
		local miniWindow

		miniWindow = rootPanel:recursiveGetChildById("minimapWindow")

		if miniWindow then
			miniWindow:setOpacity(value / 100)
		end
	elseif key == "otherWindowTransparancy" then
		local miniWindow

		miniWindow = rootPanel:recursiveGetChildById("professionWindow")

		if miniWindow then
			miniWindow:setOpacity(value / 100)
		end

		miniWindow = rootPanel:recursiveGetChildById("vipWindow")

		if miniWindow then
			miniWindow:setOpacity(value / 100)
		end

		miniWindow = rootPanel:recursiveGetChildById("battleWindow")

		if miniWindow then
			miniWindow:setOpacity(value / 100)
		end

		miniWindow = rootPanel:recursiveGetChildById("skillWindow")

		if miniWindow then
			miniWindow:setOpacity(value / 100)
		end

		miniWindow = rootPanel:recursiveGetChildById("spelllistWindow")

		if miniWindow then
			miniWindow:setOpacity(value / 100)
		end

		miniWindow = rootPanel:recursiveGetChildById("badgeWindow")

		if miniWindow then
			miniWindow:setOpacity(value / 100)
		end

		for _, child in pairs(rootPanel:getChildren()) do
			if child:getId():startswith("container") then
				child:setOpacity(value / 100)
			end
		end

		for _, child in pairs(rootPanel:getChildById("gameLeftPanel"):getChildren()) do
			if child:getId():startswith("container") then
				child:setOpacity(value / 100)
			end
		end

		for _, child in pairs(rootPanel:getChildById("gameRightPanel"):getChildren()) do
			if child:getId():startswith("container") then
				child:setOpacity(value / 100)
			end
		end
	elseif key == "arcsTransparency" then
		-- block empty
	elseif key == "displayBars" then
		self:enableBars(value)

		if value then
			self:enableArcs(false)
		else
			self:enableArcs(true)
		end
	elseif key == "displayArcs" then
		self:enableArcs(value)

		if value then
			self:enableBars(false)
		else
			self:enableBars(true)
		end
	elseif key == "displayOwnHUD" then
		self:setOption("displayName", value, force, dontSave)
		self:setOption("displayHealth", value, force, dontSave)
		self:setOption("displayMana", value, force, dontSave)
		self:setOption("displayIcons", value, force, dontSave)
		self:setOption("displayAura", value, force, dontSave)
	elseif key == "displayName" then
		g_game.setDrawOwnName(value)
	elseif key == "displayIcons" then
		g_game.setDrawOwnIcons(value)
	elseif key == "displayHealth" then
		if self:getOption("displayArcs") then
			-- block empty
		else
			g_game.setDrawOwnHealth(value)
		end
	elseif key == "displayMana" then
		if self:getOption("displayArcs") then
			-- block empty
		else
			g_game.setDrawOwnMana(value)
		end
	elseif key == "displayAura" then
		g_game.setDrawOwnAura(value)
	elseif key == "floorIndicatorMode" then
		modules.game_minimap.setFloorIndicatorMode(tonumber(value))
	elseif key == "displayOwnCastBar" then
		if not g_game.getFeature(GameHideOwnCastBar) and (value == 1 or value == 3) then
			g_game.enableFeature(GameHideOwnCastBar)
		elseif g_game.getFeature(GameHideOwnCastBar) and (value == 2 or value == 4) then
			g_game.disableFeature(GameHideOwnCastBar)
		end
	elseif key == "displayOtherCastBar" then
		if g_game.getFeature(GameHideOthersCastBar) and value then
			g_game.disableFeature(GameHideOthersCastBar)
		else
			g_game.enableFeature(GameHideOthersCastBar)
		end
	elseif key == "hideCurrentChannel" then
		modules.game_minimap.updateChannelInfo()
	elseif key == "lifeManaBarSize" then
		modules.game_healthinfo.setLifeManaBarSize(value == 1 and "large" or "small")
	elseif key == "lifeManaBarType" then
		modules.game_healthinfo.setLifeManaBarType(value == 1 and "horizontal" or "vertical")
	elseif key == "displayOtherHUD" then
		self:setOption("displayOtherNames", value, force, dontSave)
		self:setOption("displayOtherHealths", value, force, dontSave)
		self:setOption("displayOtherManas", value, force, dontSave)
		self:setOption("displayOtherIcons", value, force, dontSave)
		self:setOption("displayOtherAuras", value, force, dontSave)
	elseif key == "displayOtherNames" then
		g_game.setDrawOtherNames(value)
	elseif key == "displayOtherIcons" then
		g_game.setDrawOtherIcons(value)
	elseif key == "displayOtherHealths" then
		g_game.setDrawOtherHealths(value)
	elseif key == "displayOtherManas" then
		g_game.setDrawOtherManas(value)
	elseif key == "displayOtherAuras" then
		g_game.setDrawOtherAuras(value)
	elseif key == "displayText" then
		gameMapPanel:setDrawTexts(value)
	elseif key == "displayEffects" then
		g_game.setDrawEffects(value)
	elseif key == "displayOwnEffects" then
		g_game.setDrawOwnEffects(value)
	elseif key == "displayPlayerEffects" then
		g_game.setDrawPlayerEffects(value)
	elseif key == "displayMonsterEffects" then
		g_game.setDrawMonsterEffects(value)
	elseif key == "displayMiscEffects" then
		g_game.setDrawMiscEffects(value)
	elseif key == "displayMissiles" then
		g_game.setDrawMissiles(value)
	elseif key == "displayOwnMissiles" then
		g_game.setDrawOwnMissiles(value)
	elseif key == "displayPlayerMissiles" then
		g_game.setDrawPlayerMissiles(value)
	elseif key == "displayMonsterMissiles" then
		g_game.setDrawMonsterMissiles(value)
	elseif key == "displayMiscMissiles" then
		g_game.setDrawMiscMissiles(value)
	elseif key == "effectsSpeed" then
		g_game.setEffectDuration(value)
	elseif key == "screenshotMode" then
		addEvent(function()
			modules.game_interface.setScreenshotMode(value)
		end)
	elseif key == "dash" then
		if value then
			g_game.setMaxPreWalkingSteps(2)
		else
			g_game.setMaxPreWalkingSteps(1)
		end
	elseif key == "slowWalk" then
		if value then
			g_game.enableFeature(GameSlowerManualWalking)
		else
			g_game.disableFeature(GameSlowerManualWalking)
		end
	elseif key == "fasterWalkAnimation" then
		if value then
			g_game.enableFeature(GameFasterAnimations)
		else
			g_game.disableFeature(GameFasterAnimations)
		end
	elseif key == "antiAliasing" then
		g_app.setMapSmooth(value)
	elseif key == "damageView" then
		local newValue = value - 1

		g_game.setDamageView(newValue)
	elseif key == "hideOthersDamage" then
		g_game.hideOthersDamage(value)
	elseif key:startswith("numBars") then
		if not AbilityBar then
			return
		end

		if key == "numBarsSpell" then
			AbilityBar.setNumBarsVisible(AbilityBarCategorySpell, value)
			AbilityBar.setNumBarsVisible(AbilityBarCategoryCrafting, value)
		end
	elseif key == "layoutEditMode" then
		g_layout.setEditMode(value)
	elseif key == "showQuestTracker" then
		modules.game_minimap.toggleMinimapButton("questTrackerButton", value)
		modules.game_questlog.toggleQuestTracker(value)
	elseif key == "hideInterface" then
		modules.game_menu.Menu.toggleInterface(value)
	elseif key == "displayWeatherEffects" then
		if not value then
			modules.game_interface.getMapPanel():setShader(0)
		else
			modules.game_interface.onShaderChange({
				shader = modules.game_interface.cachedShader
			}, true)
		end
	elseif key == "showActionKey" then
		if not value then
			modules.game_interface.g_actionKey.hide()
		else
			modules.game_interface.g_actionKey.show()
		end
	elseif key == "actionKeyOpacity" then
		modules.game_interface.g_actionKey.setOpacity(value)
	elseif key == "spellBatchingInterval" then
		AbilityBar.setSpellBatchingInterval(value)
	elseif key == "displayTargetHud" then
		self:toggleModule("game_targethud", value)
	elseif key == "hideBanditTutorial" then
		if modules.game_interactions then
			local bandit_avatar = modules.game_interactions.GameInteractions.bandit_avatar

			bandit_avatar:setVisible(not value)
		end
	elseif key == "threatIndicators" then
		if value then
			g_game.enableFeature(GameShowAggro)
		else
			g_game.disableFeature(GameShowAggro)
		end

		if modules.game_targethud then
			modules.game_targethud.GameTargetHud:onUpdateAggroFeature()
		end
	elseif key == "acceptRequests" then
		modules.game_social.GameSocial:sendAcceptRequestsConfig(value)
	elseif key == "drawShineStairs" then
		g_game.setDrawShineStairs(value)
	end

	signalcall(GameSettings.onOptionChange, key, value, oldValue)

	if not dontSave then
		if self.playerSettings[key] then
			local node = g_settings.getNode(key) or {}

			node[g_game.getCharacterName()] = value

			g_settings.setNode(key, node)
		else
			g_settings.set(key, value)
		end

		g_settings.save()
	end
end

function GameSettings:toggleModule(moduleName, enabled)
	local module = g_modules.getModule(moduleName)

	if module then
		local loaded = module:isLoaded()

		if not enabled and loaded then
			module:unload()
		elseif not loaded then
			module:load()
		end
	end
end

function GameSettings:enableBars(value)
	if value then
		g_game.setDrawOwnMana(self:getOption("displayMana"))
		g_game.setDrawOwnHealth(self:getOption("displayHealth"))
	else
		g_game.setDrawOwnMana(false)
		g_game.setDrawOwnHealth(false)
	end
end

function GameSettings:enableArcs(value)
	return
end

function GameSettings:resetSettings()
	for k, v in pairs(self.defaultOptions) do
		if self.options[k] ~= v and not self:setScreenOption(k, v) then
			self.options[k] = v

			g_settings.set(k, v)
		end
	end

	g_layout.load(true)
end

function GameSettings:setScreenOption(k, v, dontSignal)
	if self.settingsWidgets.trueFalseSelect[k] then
		if self.settingsWidgets.trueFalseSelect[k]:isOn() ~= v then
			self.settingsWidgets.trueFalseSelect[k]:onClick()
		end
	elseif self.settingsWidgets.slider[k] then
		self.settingsWidgets.slider[k]:setValue(v)
	elseif self.settingsWidgets.comboBox[k] then
		if type(v) == "string" then
			self.settingsWidgets.comboBox[k]:setOption(v)
		elseif type(v) == "number" and self.settingsWidgets.comboBox[k].currentIndex ~= v then
			self.settingsWidgets.comboBox[k]:setCurrentIndex(v, dontSignal)
		end
	else
		return false
	end

	return true
end

function GameSettings:populateSettings()
	self.leftPanel:clearChildren()

	self.tabs = {}

	for i = 1, #self.order do
		local tabButton = g_ui.createWidget("SelectButton", self.leftPanel)
		local name = self.order[i]

		tabButton:setId(i)
		tabButton:setText(tr(name))

		function tabButton.onClick(widget)
			GameSettings:selectTab(widget:getId())
		end

		local tabPanel = g_ui.createWidget("GameSettingsRightPanel")
		local scrollBar = g_ui.createWidget("GameSettingsRightPanelScrollBar", self.window)

		tabPanel:setVerticalScrollBar(scrollBar)

		for index, setting in ipairs(self.settings[name]) do
			local widget = g_ui.createWidget(setting.type, tabPanel)

			if setting.id then
				self.settingsWidgetsById[setting.id] = widget
			end

			if setting.descWidth then
				widget:recursiveGetChildById("description"):setWidth(setting.descWidth)
			end

			setting.widget = widget

			local styleName = widget:getStyleName()

			if styleName == "GameSettingsTrueFalseOption" or styleName == "GameSettingsEditInterfaceOption" then
				widget:recursiveGetChildById("description"):setText(tr(setting.text))
				widget:setId(setting.id)

				local trueFalseSelect = widget:recursiveGetChildById("trueFalseSelect")

				if self:getOption(setting.id) then
					trueFalseSelect:onClick()
				end

				function trueFalseSelect.onStateChange(widget, value)
					GameSettings:setOption(setting.id, value, false, not widget:isEnabled())
				end

				self.settingsWidgets.trueFalseSelect[setting.id] = trueFalseSelect
			elseif styleName == "SettingsSliderOption" then
				widget:recursiveGetChildById("description"):setText(setting.text)
				widget:setId(setting.id)

				local slider = widget:recursiveGetChildById("slider")

				if setting.width then
					slider:setWidth(setting.width)
				end

				slider:setMinimum(setting.min or 0)
				slider:setMaximum(setting.max or 100)
				slider:setSymbol(setting.suffix or nil)
				slider:setValue(self:getOption(setting.id) or slider:getMinimum())

				slider.displayFormat = setting.displayFormat

				if not setting.applyValueChange then
					function slider.onValueChange(widget, value)
						GameSettings:setOption(setting.id, value, false, not widget:isEnabled())
					end
				else
					local applyButton = g_ui.createWidget("SuccessButton", widget)

					applyButton:setText("Apply")

					applyButton.resizeText = true

					applyButton:addAnchor(AnchorRight, "parent", AnchorRight)
					applyButton:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)

					function applyButton.onClick()
						GameSettings:setOption(setting.id, slider:getValue(), false, not widget:isEnabled())
					end
				end

				self.settingsWidgets.slider[setting.id] = slider
			elseif styleName == "GameSettingsComboBoxOption" then
				widget:recursiveGetChildById("description"):setText(setting.text)
				widget:setId(setting.id)

				local comboBox = widget:recursiveGetChildById("comboBox")
				local sufix = setting.suffix or ""

				for _, option in ipairs(setting.values) do
					comboBox:addOption(tr(option) .. tr(sufix), nil, true)
				end

				self.settingsWidgets.comboBox[setting.id] = comboBox

				self:setScreenOption(setting.id, self:getOption(setting.id))

				local settingsOption = widget

				function comboBox.onOptionChange(widget, value)
					GameSettings:setOption(setting.id, widget:getOption(value), false, not widget:isEnabled())

					if settingsOption.restartBtn then
						settingsOption.restartBtn:setVisible(true)
					end
				end

				if setting.requireRestart then
					local restartBtn = g_ui.createWidget("DangerButton", widget)

					restartBtn:setFont("poppins-12")
					restartBtn:setText("Restart")
					restartBtn:setWidth(86)
					restartBtn:setHeight(40)
					restartBtn:addAnchor(AnchorLeft, "prev", AnchorRight)
					restartBtn:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
					restartBtn:setMarginLeft(5)

					function restartBtn.onClick()
						local function yesCallback()
							if g_game.isOnline() then
								local isInPz = g_game.getLocalPlayer():hasStatusIcon(StatusIcons.SafeZone)

								if not isInPz then
									displayErrorBox(tr("Error"), tr("You must be on a safe zone in order to restart the client."), nil, nil, true)

									if localeSetConfirmBox then
										localeSetConfirmBox:destroy()

										localeSetConfirmBox = nil
									end

									return
								end

								g_game.logout()
							end

							scheduleEvent(function()
								g_app.restart()
							end, 300)

							if localeSetConfirmBox then
								localeSetConfirmBox:destroy()

								localeSetConfirmBox = nil
							end
						end

						local function noCallback()
							if localeSetConfirmBox then
								localeSetConfirmBox:destroy()

								localeSetConfirmBox = nil
							end
						end

						localeSetConfirmBox = displayGeneralBox(tr("Game Restart Pending"), tr("In order for the locale change to be applied in full, it is required to restart the game client.\nDo you want to restart it now?"), {
							{
								text = tr("Yes"),
								callback = yesCallback
							},
							{
								text = tr("No"),
								callback = noCallback
							},
							anchor = AnchorHorizontalCenter
						}, yesCallback, noCallback, nil, rootWidget)

						rootWidget:blockInputPanel(true)

						function localeSetConfirmBox.onDestroy()
							rootWidget:blockInputPanel(false)
						end

						localeSetConfirmBox:raise()
					end

					restartBtn:setVisible(false)

					widget.restartBtn = restartBtn
				end
			elseif styleName == "GameSettingsButtonOption" then
				widget:setId(setting.id)

				local button = widget:recursiveGetChildById("button")

				button:setText(setting.text)

				function button.onClick(widget)
					GameSettings:setOption(setting.id, true, true, not widget:isEnabled())
				end
			end
		end

		table.insert(self.tabs, {
			button = tabButton,
			panel = tabPanel,
			name = name
		})
	end

	self:selectTab(1)
end

function GameSettings:populateHotkeys()
	local tabData = self:getTabDataByName("Hotkeys")

	if not tabData then
		return
	end

	local tabPanel = tabData.panel

	if not tabPanel then
		return
	end

	self:resetEditHotkey()

	if #tabPanel:getChildren() == 0 then
		for _, category in ipairs(GameHotkeyManager.categories) do
			local categoryWidget = g_ui.createWidget("GameSettingsHotkeysCategory", tabPanel)

			categoryWidget:setId(category.name)
			categoryWidget.header.name:setText(tr(category.name))

			for _, hotkeyData in ipairs(category.hotkeys) do
				local categoryItem = g_ui.createWidget("GameSettingsHotkeysCategoryItem", categoryWidget.content)

				categoryItem:setId(hotkeyData.id)
				categoryItem.name:setText(tr(hotkeyData.name))

				categoryItem.hotkeyId = hotkeyData.id

				for i = 1, 2 do
					local keyWidget = categoryItem:getChildById("key" .. i)

					if keyWidget then
						local keyCombo = hotkeyData.keys[i]

						if keyCombo and keyCombo ~= "" then
							keyWidget:setText(keyCombo)
						end
					end
				end
			end
		end
	else
		for _, category in pairs(tabPanel:getChildren()) do
			for _, categoryItem in pairs(category.content:getChildren()) do
				for i = 1, 2 do
					local keyWidget = categoryItem:getChildById("key" .. i)

					if keyWidget then
						local keyCombo = GameHotkeyManager:getHotkeyKeyCombo(categoryItem.hotkeyId, i)

						keyWidget:setText(keyCombo)
					end
				end
			end
		end
	end

	if not tabData.bottomPanel then
		tabData.bottomPanel = g_ui.createWidget("GameSettingsHotkeysBottomContent")

		self:updateHotkeyResetButton()
	end
end

function GameSettings:updateHotkeyResetButton()
	local tabData = self:getTabDataByName("Hotkeys")

	if not tabData then
		return
	end

	local tabBottomPanel = tabData.bottomPanel

	if not tabBottomPanel then
		return
	end

	local resetButton = tabBottomPanel:recursiveGetChildById("reset_button")

	if not resetButton then
		return
	end

	resetButton:setEnabled(GameHotkeyManager:hasCustomHotkeys())
end

function GameSettings:resetHotkeys()
	GameHotkeyManager:resetHotkeys()
end

function GameSettings:resetEditHotkey()
	if not self.editHotkeyWindow then
		return
	end

	GameHotkeyManager:addDelayToHotkeys()
	self.editHotkeyWindow:ungrabKeyboard()

	self.editHotkeyWindow.onKeyDown = nil
	self.editHotkeyWindow.onMouseFocusPress = nil

	local oldText = self.editHotkeyWindow.oldText

	if oldText then
		self.editHotkeyWindow:setText(oldText)
	end

	self.editHotkeyWindow:setChecked(false)
	self.editHotkeyWindow:setOn(false)

	self.editHotkeyWindow = nil

	if self.confirmHotkeyOverwrite then
		self.confirmHotkeyOverwrite:destroy()

		self.confirmHotkeyOverwrite = nil
	end
end

function GameSettings:isEditingHotkey()
	return self.editHotkeyWindow ~= nil
end

function GameSettings:editHotkey(hotkeyWidget)
	if self.editHotkeyWindow then
		local same = self.editHotkeyWindow == hotkeyWidget

		self:resetEditHotkey()

		if same then
			return
		end
	end

	self.editHotkeyWindow = hotkeyWidget
	self.editHotkeyWindow.oldText = self.editHotkeyWindow:getText()

	self.editHotkeyWindow:setOn(true)
	self.editHotkeyWindow:grabKeyboard()

	self.editHotkeyWindow.onKeyDown = GameSettings.hotkeyKeyboardCapture
	self.editHotkeyWindow.onMouseFocusPress = GameSettings.hotkeyMouseCapture

	self.editHotkeyWindow:raise()
	self.editHotkeyWindow:focus()
end

function GameSettings.hotkeyMouseCapture(assignWindow, mouseButton, keyboardModifiers)
	if not table.contains({
		MouseMidButton,
		MouseXButton1,
		MouseXButton2
	}, mouseButton) then
		local widget = rootWidget:recursiveGetChildByPos(g_window.getMousePosition())
		local reset = true

		if widget then
			if GameSettings.editHotkeyWindow and widget == GameSettings.editHotkeyWindow then
				reset = false
			elseif GameSettings.confirmHotkeyOverwrite and (widget == GameSettings.confirmHotkeyOverwrite or widget:isRecursiveChildOf(GameSettings.confirmHotkeyOverwrite)) then
				reset = false
			end
		end

		if reset then
			GameSettings:resetEditHotkey()
		end

		return
	end

	local mouseCombo = determineMouseComboDesc(mouseButton, keyboardModifiers)

	if not mouseCombo then
		return
	end

	GameSettings:hotkeyCapture(assignWindow, mouseCombo)
end

function GameSettings.hotkeyKeyboardCapture(assignWindow, keyCode, keyboardModifiers)
	local keyCombo = determineKeyComboDesc(keyCode, keyboardModifiers)

	if not keyCombo then
		return
	end

	GameSettings:hotkeyCapture(assignWindow, keyCombo)
end

function GameSettings:hotkeyCapture(assignWindow, keyCombo)
	if not self.editHotkeyWindow then
		return
	end

	if self.confirmHotkeyOverwrite then
		return
	end

	if self.editHotkeyWindow.oldText == keyCombo then
		addEvent(function()
			self:resetEditHotkey()
		end)

		return
	end

	if keyCombo == KeyCodeDescs[KeyEscape] then
		self:resetEditHotkey()

		return
	end

	local hotkeyId = self.editHotkeyWindow:getParent().hotkeyId
	local index = tonumber(self.editHotkeyWindow:getId():match("key(%d)"))

	if not hotkeyId or not index then
		self:resetEditHotkey()

		return
	end

	if keyCombo == KeyCodeDescs[KeyDelete] or keyCombo == KeyCodeDescs[KeyBackspace] then
		if GameHotkeyManager:setHotkeyKeyCombo(hotkeyId, nil, index, nil, true) then
			self.editHotkeyWindow.oldText = ""
		end

		self:resetEditHotkey()

		return
	end

	if GameHotkeyManager:isReservedHotkey(keyCombo) then
		return
	end

	self.editHotkeyWindow:setText(keyCombo)

	local keyComboData = GameHotkeyManager:getKeyComboData(keyCombo)

	if not keyComboData then
		addEvent(function()
			if GameHotkeyManager:setHotkeyKeyCombo(hotkeyId, keyCombo, index, nil, true) then
				self.editHotkeyWindow.oldText = nil
			end

			self:resetEditHotkey()
		end)

		return
	end

	self.editHotkeyWindow:setChecked(true)
	self.editHotkeyWindow:ungrabMouse()

	self.editHotkeyWindow.onMousePress = nil

	local function yesCallback()
		self.confirmHotkeyOverwrite:destroy()

		self.confirmHotkeyOverwrite = nil

		local oldKeyComboCategoryName = keyComboData.category.name
		local oldKeyComboHotkeyId = keyComboData.hotkey.id
		local oldKeyComboIndex = keyComboData.index

		if GameHotkeyManager:setHotkeyKeyCombo(hotkeyId, keyCombo, index, true, true) then
			self.editHotkeyWindow.oldText = nil
		end

		self:resetEditHotkey()

		local panel = self:getTabPanelByName("Hotkeys")
		local categoryPanel = panel and panel:recursiveGetChildById(oldKeyComboCategoryName)
		local hotkeyPanel = categoryPanel and categoryPanel:recursiveGetChildById(oldKeyComboHotkeyId)
		local hotkeyWidget = hotkeyPanel and hotkeyPanel:recursiveGetChildById("key" .. oldKeyComboIndex)

		if hotkeyWidget then
			hotkeyWidget:setText("")
		end
	end

	local function noCallback()
		self.confirmHotkeyOverwrite:destroy()

		self.confirmHotkeyOverwrite = nil

		self:resetEditHotkey()
	end

	local text = string.format("{\"|%s|\", #FF5151} is currently assigned to {|%s| (|%s|), #FF5151}.\nWould you like to overwrite it?", keyCombo, keyComboData.hotkey.name, keyComboData.category.name)

	self.confirmHotkeyOverwrite = displayGeneralBox(tr("Overwrite Hotkey"), tr(text), {
		{
			text = tr("Confirm"),
			callback = yesCallback
		},
		{
			text = tr("Cancel"),
			callback = noCallback
		},
		anchor = AnchorHorizontalCenter
	}, yesCallback, noCallback, nil, modules.game_interface.getRootPanel())
end

function GameSettings:getTabPanelByName(name)
	for _, tab in ipairs(self.tabs) do
		if tab.name == name then
			return tab.panel
		end
	end
end

function GameSettings:getTabDataByName(name)
	for _, tab in ipairs(self.tabs) do
		if tab.name == name then
			return tab
		end
	end
end

function GameSettings:getTabButtonByName(name)
	local i

	for index, orderName in ipairs(self.order) do
		if orderName == name then
			i = index

			break
		end
	end

	if not i then
		return nil
	end

	return self.leftPanel:getChildById(i)
end

function getOption(key)
	return GameSettings:getOption(key)
end

function toggleOption(key)
	GameSettings:setScreenOption(key, not GameSettings.options[key])
end

function resizeToResolution(self)
	return
end

function showEscapeButton(self, value)
	return
end
