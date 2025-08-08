-- chunkname: @/modules/client_background/background.lua

local background

function init()
	background = g_ui.displayUI("background")

	background:lower()
	connect(g_game, {
		onGameStart = hide
	})
	connect(g_game, {
		onGameEnd = show
	})
end

function terminate()
	disconnect(g_game, {
		onGameStart = hide
	})
	disconnect(g_game, {
		onGameEnd = show
	})

	if background then
		background:destroy()

		background = nil
	end
end

function hide()
	background:hide()
end

function show()
	if not g_game.isChangingChannel() then
		background:show()
	end
end

function hideVersionLabel()
	return
end

function setVersionText(text)
	return
end

function getBackground()
	return background
end
