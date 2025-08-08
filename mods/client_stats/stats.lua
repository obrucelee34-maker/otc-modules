-- chunkname: @/modules/client_stats/stats.lua

local statsWindow, luaStats, luaCallback, mainStats, dispatcherStats, render, atlas, adaptiveRender, slowMain, slowRender, widgetsInfo, packets, slowPackets, updateEvent, monitorEvent
local iter = 0
local fps = {}
local ping = {}

function init()
	if not g_stats then
		return
	end

	statsWindow = g_ui.displayUI("stats")

	statsWindow:hide()
	g_keyboard.bindKeyDown("Ctrl+Alt+3", toggle)

	luaStats = statsWindow:recursiveGetChildById("luaStats")
	luaCallback = statsWindow:recursiveGetChildById("luaCallback")
	mainStats = statsWindow:recursiveGetChildById("mainStats")
	dispatcherStats = statsWindow:recursiveGetChildById("dispatcherStats")
	render = statsWindow:recursiveGetChildById("render")
	atlas = statsWindow:recursiveGetChildById("atlas")
	packets = statsWindow:recursiveGetChildById("packets")
	adaptiveRender = statsWindow:recursiveGetChildById("adaptiveRender")
	slowMain = statsWindow:recursiveGetChildById("slowMain")
	slowRender = statsWindow:recursiveGetChildById("slowRender")
	slowPackets = statsWindow:recursiveGetChildById("slowPackets")
	widgetsInfo = statsWindow:recursiveGetChildById("widgetsInfo")

	g_stats.resetSleepTime()

	updateEvent = scheduleEvent(update, 2000)
	monitorEvent = scheduleEvent(monitor, 1000)
end

function terminate()
	if not g_stats then
		return
	end

	statsWindow:destroy()
	g_keyboard.unbindKeyDown("Ctrl+Alt+3")
	removeEvent(updateEvent)
	removeEvent(monitorEvent)
end

function toggle()
	local localPlayer = g_game.getLocalPlayer()

	if not localPlayer or not localPlayer:isGamemaster() then
		return
	end

	if statsWindow:isVisible() then
		statsWindow:hide()
	else
		statsWindow:show()
		statsWindow:raise()
		statsWindow:focus()
	end
end

function monitor()
	if #fps > 1000 then
		fps = {}
	end

	if #ping > 1000 then
		ping = {}
	end

	table.insert(fps, g_app.getFps())
	table.insert(ping, g_game.getPing())

	monitorEvent = scheduleEvent(monitor, 1000)
end

function update()
	updateEvent = scheduleEvent(update, 150)

	if not statsWindow:isVisible() then
		return
	end

	iter = (iter + 1) % 9

	if iter == 0 then
		statsWindow.debugPanel.sleepTime:setText("GFPS: " .. g_app.getGraphicsFps() .. " PFPS: " .. g_app.getProcessingFps())
		statsWindow.debugPanel.luaRamUsage:setText("Ram usage by lua: " .. gcinfo() .. " kb")
	elseif iter == 1 then
		local adaptive = "Adaptive: " .. g_adaptiveRenderer.getLevel() .. " | " .. g_adaptiveRenderer.getDebugInfo()

		adaptiveRender:setText(adaptive)
		atlas:setText("Atlas: " .. g_atlas.getStats())
	elseif iter == 2 then
		render:setText(g_stats.get(2, 10, true))
		mainStats:setText(g_stats.get(1, 5, true))
		dispatcherStats:setText(g_stats.get(3, 5, true))
	elseif iter == 3 then
		luaStats:setText(g_stats.get(4, 5, true))
		luaCallback:setText(g_stats.get(5, 5, true))
	elseif iter == 4 then
		slowMain:setText(g_stats.getSlow(3, 10, 10, true) .. "\n\n\n" .. g_stats.getSlow(1, 20, 20, true))
	elseif iter == 5 then
		slowRender:setText(g_stats.getSlow(2, 10, 10, true))
	elseif iter == 6 then
		-- block empty
	elseif iter == 7 then
		packets:setText(g_stats.get(6, 10, true))
		slowPackets:setText(g_stats.getSlow(6, 10, 10, true))
	elseif iter == 8 and g_proxy then
		local text = ""
		local proxiesDebug = g_proxy.getProxiesDebugInfo()

		for proxy_name, proxy_debug in pairs(proxiesDebug) do
			text = text .. proxy_name .. " - " .. proxy_debug .. "\n"
		end

		statsWindow.debugPanel.proxies:setText(text)
	end
end
