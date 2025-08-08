-- chunkname: @/modules/client/client.lua

local musicFilename = "/sounds/startup"
local musicChannel

function setMusic(filename)
	musicFilename = filename

	if not g_game.isOnline() and musicChannel ~= nil then
		musicChannel:stop()
		musicChannel:enqueue(musicFilename, 3)
	end
end

function reloadScripts()
	if g_game.getFeature(GameNoDebug) then
		return
	end

	g_textures.clearCache()
	g_modules.reloadModules()

	local script = "/" .. g_app.getCompactName() .. "rc.lua"

	if g_resources.fileExists(script) then
		dofile(script)
	end

	local message = tr("All modules and scripts were reloaded.")

	GameNotification:display(NOTIFICATION_INFO, nil, message)
	print(message)
end

function startup()
	G.UUID = g_settings.getString("report-uuid")

	if not G.UUID or #G.UUID ~= 36 then
		G.UUID = g_crypt.genUUID()

		g_settings.set("report-uuid", G.UUID)
	end

	if DEMO_VERSION and DemoScreen then
		DemoScreen:show()
	else
		EnterGame.firstShow()
	end
end

function init()
	connect(g_app, {
		onRun = startup,
		onExit = exit
	})
	connect(g_game, {
		onGameStart = onGameStart,
		onGameEnd = onGameEnd
	})

	if not Updater then
		g_window.setMinimumSize({
			height = 720,
			width = 1280
		})

		local size = {
			height = 720,
			width = 1280
		}

		size = g_settings.getSize("window-size", size)

		g_window.resize(size)

		local displaySize = g_window.getDisplaySize()
		local defaultPos = {
			x = (displaySize.width - size.width) / 2,
			y = (displaySize.height - size.height) / 2
		}
		local pos = g_settings.getPoint("window-pos", defaultPos)

		pos.x = math.max(pos.x, 0)
		pos.y = math.max(pos.y, 0)

		g_window.move(pos)

		local maximized = g_settings.getBoolean("window-maximized", false)

		if maximized then
			g_window.maximize()
		end
	end

	if not g_crypt.setMachineUUID(g_settings.get("uuid")) then
		g_settings.set("uuid", g_crypt.getMachineUUID())
		g_settings.save()
	end
end

function terminate()
	disconnect(g_app, {
		onRun = startup,
		onExit = exit
	})
	disconnect(g_game, {
		onGameStart = onGameStart,
		onGameEnd = onGameEnd
	})
	g_settings.set("window-size", g_window.getUnmaximizedSize())
	g_settings.set("window-pos", g_window.getUnmaximizedPos())
	g_settings.set("window-maximized", g_window.isMaximized())
end

function exit()
	g_logger.info("Exiting application..")
end

function onGameStart()
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	g_window.setTitle(APP_TITLE .. " - " .. player:getName())
end

function onGameEnd()
	g_window.setTitle(APP_TITLE)
end
