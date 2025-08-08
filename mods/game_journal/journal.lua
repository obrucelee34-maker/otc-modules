-- chunkname: @/modules/game_journal/journal.lua

GameJournal = {
	panels = {}
}

function GameJournal:loadConfig()
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

function GameJournal:init()
	self:loadConfig()
	g_ui.importStyle("styles/main.otui")
	g_ui.importStyle("styles/artifacts.otui")
	g_ui.importStyle("styles/top_panel.otui")
	g_ui.importStyle("styles/artifacts_middle_panel.otui")
	g_ui.importStyle("styles/artifacts_right_panel.otui")

	local HUDPanel = modules.game_interface.getHUDPanel()

	self.window = g_ui.createWidget("GameJournalWindow", HUDPanel)

	self.window:hide()

	self.artifact_panel = self.window.content.artifacts_panel
	self.panels.artifacts = self.artifact_panel
	self.top_panel = self.window.content.top_panel

	dofile("artifacts.lua")
	self:initArtifacts()
	self:selectTab("artifacts")
	connect(g_game, {
		onGameEnd = GameJournal.onGameEnd
	})
	ProtocolGame.registerExtendedOpcode(ExtendedIds.Journal, self.onExtendedOpcode)
end

function GameJournal:terminate()
	self.window:destroyChildren()
	self.window:destroy()
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.Journal)

	GameJournal = nil
end

function GameJournal.onGameEnd()
	GameJournal.artifactsOnGameEnd()
end

function GameJournal:selectTab(tabName)
	local widgetToSelect = self.top_panel:getChildById(tabName:lower())

	if not widgetToSelect then
		return
	end

	if self.selectedTab then
		self.selectedTab:setOn(false)
	end

	if self.selectedPanel then
		self.selectedPanel:hide()
	end

	widgetToSelect:setOn(true)

	self.selectedTab = widgetToSelect
	self.selectedPanel = self.panels[tabName]

	self.selectedPanel:show()
end

function GameJournal.onExtendedOpcode(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.Journal then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if not data or type(data) ~= "table" then
		return
	end

	if data.action == "artifact_info" then
		for region, artifacts in pairs(data.data) do
			GameJournal:setupArtifactInfo(artifacts)
		end
	elseif data.action == "artifact_region_info" then
		GameJournal:setupArtifactInfo(data.data)
	end
end

function GameJournal.isEnabled()
	return not g_game.isAetherRiftChannel() and not g_game.isGuildWarsChannel()
end

function GameJournal.toggle(mouseClick)
	if GameChat:isActive() or (type(mouseClick) ~= "boolean" or not mouseClick) and IsTextEditActive() then
		return
	end

	if GameJournal.window:isVisible() then
		GameJournal.window:hide()
	else
		if g_game:isInCutsceneMode() or not GameJournal.isEnabled() then
			return
		end

		GameJournal.window:show()
		GameJournal.window:raise()
	end
end
