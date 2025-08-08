-- chunkname: @/modules/game_channeling_minigame/minigame.lua

minigameWindow = nil
movingLine = nil
movingLineEvent = nil
movingLineStartEvent = nil
movingLineStartDelay = 500
rangeIndicator = nil
barContainer = nil
key = nil
hudPanel = modules.game_interface.getHUDPanel()
lastSendTime = 0

function init()
	g_ui.importStyle("minigame.otui")

	minigameWindow = g_ui.createWidget("ChannelingMinigame", hudPanel)
	rangeIndicator = minigameWindow.background.barContainer.rangeIndicator
	movingLine = minigameWindow.background.barContainer.movingLine
	key = g_ui.createWidget("ChannelingMiningameKey", hudPanel)

	key:addAnchor(AnchorBottom, "channelingMinigameWindow", AnchorTop)
	key:addAnchor(AnchorHorizontalCenter, "channelingMinigameWindow", AnchorHorizontalCenter)

	barContainer = minigameWindow.background.barContainer

	hide()
	ProtocolGame.registerExtendedOpcode(ExtendedIds.ChannelingMinigame, onExtendedOpcode)
	connect(g_game, {
		onGameStart = online,
		onGameEnd = offline
	})
	connect(LocalPlayer, {
		onChanneling = onChanneling
	})
	g_keyboard.bindKeyDown("F", sendInput)

	if g_game.isOnline() then
		online()
	end
end

function terminate()
	releaseEvent()
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.ChannelingMinigame)

	if minigameWindow then
		minigameWindow:destroyChildren()
		minigameWindow:destroy()

		minigameWindow = nil
	end

	disconnect(g_game, {
		onGameStart = online,
		onGameEnd = offline
	})
	disconnect(LocalPlayer, {
		onChanneling = onChanneling
	})
	g_keyboard.unbindKeyDown("F", sendInput)
end

function releaseEvent()
	if movingLineStartEvent then
		removeEvent(movingLineStartEvent)

		movingLineStartEvent = nil
	end

	if movingLineEvent then
		removeEvent(movingLineEvent)

		movingLineEvent = nil
	end
end

function show(force)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	if not force and not player:isChanneling() then
		return
	end

	g_layout.onOpenWindow(minigameWindow, 250, true, true)
	g_layout.onOpenWindow(key, 250, true, true)

	lastSendTime = g_clock.millis()
end

function hide()
	releaseEvent()
	g_effects.fadeOut(minigameWindow, 700)
	g_effects.fadeOut(key, 700)
end

function toggle()
	if minigameWindow:isVisible() then
		hide()
	else
		show()
	end
end

function online()
	hide()
end

function offline()
	hide()
end

function onChanneling(player, type, status, progress, name, duration, reversed, interruptible)
	if status == ChannelingStatusAbort or status == ChannelingStatusFinish then
		hide()
	end
end

function onExtendedOpcode(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.ChannelingMinigame then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		return
	end

	if data.action == "start" then
		onStart(data)
	elseif data.action == "hide" then
		onSuccessOrFailure(data.success)
		hide()

		if data.decrease then
			g_game.getLocalPlayer():updateChannelingProgress(data.decrease)
		end
	end
end

function sendOpcode(data)
	if lastSendTime + 250 > g_clock.millis() then
		return
	end

	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.ChannelingMinigame, g_game.serializeTable(data))

		lastSendTime = g_clock.millis()
	end
end

function onStart(data)
	key:setOn(false)
	minigameWindow:setImageSource("/images/ui/windows/gathering_minigame/background_border_normal")
	movingLine:setImageSource("/images/ui/windows/gathering_minigame/line")
	minigameWindow.stars:hide()
	minigameWindow.background.icon:setImageColor("#CED2D9")
	minigameWindow.background.icon:setImageSource(string.format("/images/ui/icons/interactions/%s", MinigameTypeToInteractionIcon[data.minigameType or -1] or ""))
	show(true)

	movingLine.state = true

	movingLine:setMarginLeft(5)
	releaseEvent()

	local rangeStart = data.range_start / 100 * barContainer:getWidth()

	rangeIndicator:setMarginLeft(rangeStart)

	local rangeEnd = data.range_end / 100 * barContainer:getWidth()

	rangeIndicator:setWidth(rangeEnd - rangeStart)

	movingLineStartEvent = scheduleEvent(function()
		if not g_game.isOnline() then
			return
		end

		movingLineEvent = cycleEvent(function()
			if not g_game.getLocalPlayer():isChanneling() then
				hide()

				return
			end

			local x = movingLine:getMarginLeft()
			local width = barContainer:getWidth()

			if width <= x and movingLine.state then
				movingLine.state = false
			elseif not movingLine.state and x <= 0 then
				movingLine.state = true
			end

			if movingLine.state then
				x = x + 1
			else
				x = x - 1
			end

			movingLine.value = math.floor(x / width * 100)

			movingLine:setMarginLeft(x)
		end, 5)
	end, movingLineStartDelay)
end

function sendInput()
	if not minigameWindow:isVisible() or minigameWindow.fadeEvent then
		return
	end

	key:setOn(true)
	sendOpcode({
		action = "input",
		value = movingLine.value
	})
	hide()
end

function onSuccessOrFailure(success)
	if success == true then
		minigameWindow:setImageSource("/images/ui/windows/gathering_minigame/background_border_success")
		movingLine:setImageSource("/images/ui/windows/gathering_minigame/line_success")
		minigameWindow.stars:show()
		minigameWindow.background.icon:setImageColor("#77D463")
	elseif success == false then
		minigameWindow:setImageSource("/images/ui/windows/gathering_minigame/background_border_fail")
		movingLine:setImageSource("/images/ui/windows/gathering_minigame/line_fail")
		minigameWindow.stars:hide()
		minigameWindow.background.icon:setImageColor("#FF5151")
	else
		minigameWindow:setImageSource("/images/ui/windows/gathering_minigame/background_border_normal")
		movingLine:setImageSource("/images/ui/windows/gathering_minigame/line")
		minigameWindow.stars:hide()
		minigameWindow.background.icon:setImageColor("#CED2D9")
	end
end
