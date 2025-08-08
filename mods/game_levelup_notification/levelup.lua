-- chunkname: @/modules/game_levelup_notification/levelup.lua

GameLevelUpNotification = {
	soundEffects = {
		legacy = 3700752057,
		effective = 4260963001
	},
	windows = {},
	queue = {}
}

function GameLevelUpNotification:init()
	g_ui.importStyle("styles/main.otui")

	self.windows.holder = g_ui.createWidget("GameLevelUpNotificationWindow", modules.game_interface.getHUDPanel())
	self.windows.legacy_level = self.windows.holder.content.legacy_level_notification
	self.windows.effective_level = self.windows.holder.content.effective_level_notification

	ProtocolGame.registerExtendedOpcode(ExtendedIds.LevelUpNotification, GameLevelUpNotification.onExtendedOpcode)

	self.windows.holder.onDragEnter = onDragEnter
	self.windows.holder.onDragMove = onDragMove

	connect(g_game, {
		onGameEnd = GameLevelUpNotification.onGameEnd
	})
end

function GameLevelUpNotification:terminate()
	if self.windows.legacy_level then
		self.windows.legacy_level:destroy()

		self.windows.legacy_level = nil
	end

	if self.windows.effective_level then
		self.windows.effective_level:destroy()

		self.windows.effective_level = nil
	end

	if self.windows.holder then
		self.windows.holder:destroy()

		self.windows.holder = nil
	end

	disconnect(g_game, {
		onGameEnd = GameLevelUpNotification.onGameEnd
	})
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.LevelUpNotification)

	GameLevelUpNotification = nil
end

function GameLevelUpNotification:addToQueue(type, level, showQuests)
	table.insert(self.queue, {
		type = type,
		level = level,
		showQuests = showQuests
	})
end

function GameLevelUpNotification:displayFromQueue()
	if #self.queue == 0 then
		return
	end

	local data = table.remove(self.queue, 1)

	self:display(data.type, data.level, data.showQuests)
end

function GameLevelUpNotification:display(type, level, showQuests)
	if not self.windows.holder:isVisible() then
		self.windows.holder:show()
	end

	if type == "legacy" then
		if self.windows.effective_level:isVisible() then
			self:addToQueue(type, level, showQuests)

			return
		end

		self.windows.legacy_level.level_text:setText(level)
		self.windows.legacy_level:show()
		self.windows.legacy_level.entry_quests:setVisible(showQuests)
		g_effects.fadeIn(self.windows.legacy_level, 500)
		g_sound.play(self.soundEffects.legacy, g_sound.localEmitterId)

		if self.legacy_event then
			removeEvent(self.legacy_event)
		end

		self.legacy_event = scheduleEvent(function()
			g_effects.fadeOut(self.windows.legacy_level, 500, nil, nil, function()
				self.windows.legacy_level:hide()
				self:displayFromQueue()
			end)

			self.legacy_event = nil
		end, 4500)

		if not self.effective_event then
			self.windows.effective_level:hide()
		end
	elseif type == "effective" then
		if self.windows.legacy_level:isVisible() then
			self:addToQueue(type, level, showQuests)

			return
		end

		self.windows.effective_level.level_text:setText(level)
		self.windows.effective_level:show()
		g_effects.fadeIn(self.windows.effective_level, 500)
		g_sound.play(self.soundEffects.effective, g_sound.localEmitterId)

		if self.effective_event then
			removeEvent(self.effective_event)
		end

		self.effective_event = scheduleEvent(function()
			g_effects.fadeOut(self.windows.effective_level, 500, nil, nil, function()
				self.windows.effective_level:hide()
				self:displayFromQueue()
			end)

			self.effective_event = nil
		end, 4500)

		if not self.legacy_event then
			self.windows.legacy_level:hide()
		end
	end
end

function GameLevelUpNotification.onExtendedOpcode(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.LevelUpNotification or buffer == "" then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		return
	end

	if data.action == "levelup" then
		GameLevelUpNotification:display(data.type, data.level, data.showQuests)
	end
end

function GameLevelUpNotification.onGameEnd()
	local self = GameLevelUpNotification

	self.queue = {}

	if self.legacy_event then
		removeEvent(self.legacy_event)

		self.legacy_event = nil
	end

	if self.effective_event then
		removeEvent(self.effective_event)

		self.effective_event = nil
	end

	g_effects.cancelFade(self.windows.legacy_level)
	g_effects.cancelFade(self.windows.effective_level)
	self.windows.legacy_level:hide()
	self.windows.effective_level:hide()
	self.windows.holder:hide()
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

function update()
	local isEditMode = g_layout.isEditMode()

	GameLevelUpNotification.windows.holder.editModeBackground:setVisible(isEditMode)
	GameLevelUpNotification.windows.holder:setPhantom(not isEditMode)
end
