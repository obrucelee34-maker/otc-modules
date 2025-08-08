-- chunkname: @/modules/game_screenmessage/screenmessage.lua

GameScreenMessage = {
	defaultDuration = 6500
}

function GameScreenMessage:init()
	g_ui.importStyle("styles/base.otui")
	connect(g_game, {
		onGameEnd = GameScreenMessage.onGameEnd
	})
	connect(g_game, {
		onCutsceneModeChange = GameScreenMessage.onCutsceneModeChange
	})
end

function GameScreenMessage:terminate(internal)
	if self.window then
		self.window:destroy()

		self.window = nil
	end

	if self.timerEvent then
		removeEvent(self.timerEvent)

		self.timerEvent = nil
	end

	if not internal then
		disconnect(g_game, {
			onGameEnd = GameScreenMessage.onGameEnd
		})

		GameScreenMessage = nil
	end
end

function GameScreenMessage.onGameEnd()
	GameScreenMessage:terminate(true)
end

function GameScreenMessage:display(text, duration)
	if not text or text == "" then
		GameScreenMessage:hide()

		return
	end

	duration = duration or self.defaultDuration

	if not self.window then
		self.window = g_ui.createWidget("GameScreenMessageBase", rootWidget)
	end

	local textWidget = self.window:recursiveGetChildById("text")

	textWidget:setText(text)

	local height = math.max(self.window.minHeight, 55 + textWidget:getTextSize().height)

	self.window:setHeight(height)
	self.window:show()
	self.window:getParent():raise()

	if self.timerEvent then
		removeEvent(self.timerEvent)

		self.timerEvent = nil
	end

	if duration > 0 then
		self.timerEvent = scheduleEvent(function()
			self:hide()
		end, duration)
	end
end

function GameScreenMessage:hide()
	if self.window then
		if self.timerEvent then
			removeEvent(self.timerEvent)

			self.timerEvent = nil
		end

		self.window:destroy()

		self.window = nil
	end
end

function GameScreenMessage.onCutsceneModeChange(value)
	GameScreenMessage:hide()
end
