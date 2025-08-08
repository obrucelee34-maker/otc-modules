-- chunkname: @/modules/updater/updater.lua

Updater = {
	maxRetries = 5
}

local updaterWindow, loadModulesFunction, scheduledEvent
local httpOperationId = 0
local downloadingFiles = {}
local maxConcurrentDownloads = 8
local finishedDownloadCount = 0
local downloadedIndexes = {}
local displayingDownloadProgress = false

local function initAppWindow()
	if g_resources.getLayout() == "mobile" then
		g_window.setMinimumSize({
			width = 640,
			height = 360
		})
	else
		g_window.setMinimumSize({
			width = 1280,
			height = 720
		})
	end

	local size = {
		width = 1280,
		height = 720
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

	g_window.setTitle(APP_TITLE)
	g_window.setIcon(APP_ICON, APP_ICON .. "_small")

	if g_app.isMobile() then
		scheduleEvent(function()
			g_app.scale(5)
		end, 10)

		return
	end
end

local function loadModules()
	if loadModulesFunction then
		local tmpLoadFunc = loadModulesFunction

		loadModulesFunction = nil

		tmpLoadFunc()
	end
end

local function downloadFiles(url, fallbackUrl, files, index, retries, doneCallback)
	if not updaterWindow then
		return
	end

	local entry = files[index]

	if finishedDownloadCount == #files then
		return doneCallback()
	end

	if not entry then
		return
	end

	if downloadedIndexes[index] then
		return downloadFiles(url, fallbackUrl, files, index + 1, 0, doneCallback)
	end

	local file = entry[1]
	local file_checksum = entry[2]

	if #downloadingFiles < maxConcurrentDownloads then
		table.insert(downloadingFiles, index)
	else
		return
	end

	if not displayingDownloadProgress then
		displayingDownloadProgress = index

		if retries > 0 then
			print("Retrying download of " .. file .. " (" .. retries .. " retries)")
			updaterWindow.downloadStatus:setText(tr("Downloading file: %i / %i (%i retry)", finishedDownloadCount + 1, #files, retries))
		else
			updaterWindow.downloadStatus:setText(tr("Downloading file: %i / %i", finishedDownloadCount + 1, #files))
		end

		updaterWindow.downloadProgress:setPercent(0)
		updaterWindow.mainProgress:setPercent(math.floor(100 * (finishedDownloadCount + 1) / #files))
		updaterWindow.downloadProgress:setText("Downloading...")
	end

	local gotProgressUpdate = false

	downloadedIndexes[index] = true
	httpOperationId = HTTP.download(string.format("%s%s", retries > 0 and fallbackUrl or url, file), file, function(file, checksum, err)
		if not err and checksum ~= file_checksum then
			err = "File checksum doesn't match. Please try again later."
		end

		if err then
			if retries >= Updater.maxRetries then
				Updater.error("Download Error: " .. err)
				g_logger.error(err)
			else
				scheduledEvent = scheduleEvent(function()
					table.remove(downloadingFiles, table.find(downloadingFiles, index))

					downloadedIndexes[index] = nil
					displayingDownloadProgress = false

					downloadFiles(url, fallbackUrl, files, index, retries + 1, doneCallback)
				end, 250)
			end

			return
		end

		local prefix = "/downloads"

		if not file:starts("/") then
			prefix = "/downloads/"
		end

		g_resources.makeDir("/downloads")

		local status, result = pcall(function()
			local dir = file:match("(.+)/[^/]*$")

			if file:ends(".bnk") then
				if dir then
					g_resources.makeDir(dir)
				end

				local fileName = string.format("%s/%s", prefix, file):gsub("//", "/")

				g_resources.writeFileContents(file, g_resources.readFileContents(fileName))
				g_http.removeFile(file)
			else
				if dir then
					local dirName = string.format("%s/%s", prefix, dir):gsub("//", "/")

					g_resources.makeDir(dirName)
				end

				local fileName = string.format("%s/%s", prefix, file):gsub("//", "/")

				g_resources.writeFileContents(fileName, g_resources.readFileContents(fileName))
			end
		end)

		if not status then
			g_logger.fatal(string.format("Couldn't write to path: %s", file))
		end

		table.remove(downloadingFiles, table.find(downloadingFiles, index))

		finishedDownloadCount = finishedDownloadCount + 1

		if displayingDownloadProgress == index then
			displayingDownloadProgress = false
		end

		downloadFiles(url, fallbackUrl, files, index + 1, 0, doneCallback)
	end, function(progress, speed, totalsize)
		if not gotProgressUpdate then
			downloadFiles(url, fallbackUrl, files, index, 0, doneCallback)
		end

		gotProgressUpdate = true

		if displayingDownloadProgress and displayingDownloadProgress ~= index then
			return
		end

		displayingDownloadProgress = index

		if retries > 0 then
			print("Retrying download of " .. file .. " (" .. retries .. " retries)")
			updaterWindow.downloadStatus:setText(tr("Downloading file: %i / %i (%i retry)", finishedDownloadCount + 1, #files, retries))
		else
			updaterWindow.downloadStatus:setText(tr("Downloading file: %i / %i", finishedDownloadCount + 1, #files))
		end

		updaterWindow.mainProgress:setPercent(math.floor(100 * (finishedDownloadCount + 1) / #files))
		updaterWindow.downloadProgress:setPercent(progress)

		if speed > 0 then
			local displaySpeed = string.format("%.02f", speed / 1024 / 1024) .. " MB/s"
			local remainingTime = (totalsize - progress / 100 * totalsize) / speed
			local alpha = 0.5

			averageRemainingTime = alpha * remainingTime + (1 - alpha) * (averageRemainingTime or remainingTime)

			local displayRemainingTime = averageRemainingTime > 1 and string.format(" (%s)", SecondsToTime(averageRemainingTime)) or ""

			updaterWindow.downloadProgress:setText(displaySpeed .. displayRemainingTime)
		else
			updaterWindow.downloadProgress:setText("Downloading...")
		end
	end) or 0
end

local function updateFiles(data, keepCurrentFiles)
	if not updaterWindow then
		return
	end

	if type(data) ~= "table" then
		return Updater.error("Invalid data.")
	end

	if data.minClientVersion and data.minClientVersion > APP_GAME_VERSION then
		return Updater.error("Please download a new client from our website.")
	end

	if type(data.error) == "string" and data.error:len() > 0 then
		return Updater.error(data.error)
	end

	if not data.files or type(data.url) ~= "string" or data.url:len() < 4 or type(data.fallbackUrl) ~= "string" or data.fallbackUrl:len() < 4 then
		return Updater.error("Invalid data.")
	end

	if data.keepFiles then
		keepCurrentFiles = true
	end

	local newFiles = false
	local finalFiles = {}
	local localFiles = g_resources.filesChecksums()
	local toUpdate = {}

	for file, checksum in pairs(localFiles) do
		if keepCurrentFiles or string.find(file, "data/things") then
			table.insert(finalFiles, file)
		end
	end

	for file, checksum in pairs(data.files) do
		table.insert(finalFiles, file)

		if not localFiles[file] or localFiles[file] ~= checksum then
			table.insert(toUpdate, {
				file,
				checksum
			})

			newFiles = true
		end
	end

	local binary

	if type(data.binary) == "table" and data.binary.file:len() > 1 then
		local selfChecksum = g_resources.selfChecksum()

		if selfChecksum:len() > 0 and selfChecksum ~= data.binary.checksum then
			binary = data.binary.file

			table.insert(toUpdate, {
				binary,
				data.binary.checksum
			})
		end
	end

	if #toUpdate == 0 then
		updaterWindow.mainProgress:setPercent(100)

		if g_resources.directoryExists("/downloads", true) then
			updaterWindow.status:setText(tr("Finalizing update"))
			updaterWindow.mainProgress:setPercent(100)
			updaterWindow.downloadProgress:hide()
			updaterWindow.downloadStatus:hide()
			g_resources.updateData(finalFiles, false)
			g_app.restart()
		end

		scheduledEvent = scheduleEvent(Updater.abort, 20)

		return
	end

	local forceRestart = true
	local reloadModules = false
	local forceRestartPattern = {
		"init.lua",
		"corelib",
		"updater",
		"otmod",
		"sounds"
	}

	for _, file in ipairs(toUpdate) do
		for __, pattern in ipairs(forceRestartPattern) do
			if string.find(file[1], pattern) then
				forceRestart = true
			end

			if not string.find(file[1], "data/things") then
				reloadModules = true
			end
		end
	end

	updaterWindow.status:setText(tr("Updating %i files", #toUpdate))
	updaterWindow.mainProgress:setPercent(0)
	updaterWindow.downloadProgress:setPercent(0)
	updaterWindow.downloadProgress:show()
	updaterWindow.downloadStatus:show()
	downloadFiles(data.url, data.fallbackUrl, toUpdate, 1, 0, function()
		updaterWindow.status:setText(tr("Finalizing update"))
		updaterWindow.mainProgress:setPercent(100)
		updaterWindow.downloadProgress:hide()
		updaterWindow.downloadStatus:hide()

		scheduledEvent = scheduleEvent(function()
			local restart = true

			if newFiles then
				g_resources.updateData(finalFiles, false)
			end

			if binary then
				g_resources.updateExecutable(binary)
			end

			if restart then
				g_app.restart()
			else
				if reloadModules then
					g_modules.reloadModules()
				end

				Updater.abort()
			end
		end, 100)
	end)
end

function Updater.init(loadModulesFunc)
	loadModulesFunction = loadModulesFunc

	initAppWindow()
	os.remove(g_resources.getBinaryName() .. ".old")
	Updater.check(not g_resources.isLoadedFromArchive())
end

function Updater.terminate()
	loadModulesFunction = nil

	Updater.abort()
end

function Updater.abort()
	HTTP.cancel(httpOperationId)
	removeEvent(scheduledEvent)

	if g_sound then
		g_sound.action(EVENT_MUSIC)
	end

	if updaterWindow then
		updaterWindow.status:setText(tr("Loading game files"))
		updaterWindow.mainProgress:setPercent(50)
		updaterWindow.downloadProgress:hide()
		updaterWindow.downloadStatus:hide()
	end

	scheduleEvent(function()
		loadModules()
		g_game.setClientVersion(APP_GAME_VERSION)
		g_game.setProtocolVersion(APP_PROTOCOL_VERSION)

		if EnterGame then
			EnterGame.hide()
		end

		updaterWindow.mainProgress:setPercent(100)
		scheduleEvent(function()
			if EnterGame then
				EnterGame.firstShow()
			end

			if updaterWindow then
				updaterWindow:destroy()

				updaterWindow = nil
			end
		end, 1000)
	end, 1000)
end

function Updater.check(test)
	if updaterWindow then
		return
	end

	if EnterGame then
		EnterGame.hide()
	end

	updaterWindow = g_ui.displayUI("updater")

	updaterWindow.title:setText(g_game.isRavenQuest() and "Updating RavenQuest" or "Updating Ravendawn")
	updaterWindow:show()
	updaterWindow:focus()
	updaterWindow:raise()

	finishedDownloadCount = 0
	downloadedIndexes = {}
	displayingDownloadProgress = false

	if test then
		updaterWindow.mainProgress:setPercent(100)

		scheduledEvent = scheduleEvent(Updater.abort, 1000)

		return
	end

	if not g_resources.firstLaunchComplete() then
		Updater.unpackToUserDir()

		return
	end

	local updateData

	local function progressUpdater(value)
		removeEvent(scheduledEvent)

		if value == 100 then
			return Updater.error(tr("Connection timeout."))
		end

		if updateData and (value > 60 or not g_app.isMobile()) then
			return updateFiles(updateData)
		end

		scheduledEvent = scheduleEvent(function()
			progressUpdater(value + 1)
		end, 200)

		updaterWindow.mainProgress:setPercent(value)
	end

	progressUpdater(0)

	httpOperationId = HTTP.getJSON(Services.updater, function(data, err)
		if err then
			return Updater.error(err)
		end

		if g_modules.getModule("game_interface"):isLoaded() then
			updaterWindow.mainProgress:setPercent(100)
			updaterWindow.status:setText(string.format("Restarting %s...", g_game.isRavenQuest() and "RavenQuest" or "Ravendawn"))
			scheduleEvent(function()
				g_app.restart()
			end, 1000)

			return
		end

		updateData = data
	end) or 0
end

function Updater.error(message)
	removeEvent(scheduledEvent)

	if not updaterWindow then
		return
	end

	displayErrorBox(tr("Updater Error"), message).onOk = function()
		g_app.exit()
	end
end

function Updater.unpackToUserDir()
	updaterWindow.mainProgress:setPercent(0)
	updaterWindow.status:setText("Preparing for first launch. Please wait.")

	local function work()
		local files = {}

		for file, checksum in pairs(g_resources.filesChecksums()) do
			table.insert(files, file)
		end

		g_resources.updateData(files, false)
		updaterWindow.mainProgress:setPercent(50)
		scheduleEvent(function()
			g_resources.updateExecutable(g_resources.getBinaryName())
			updaterWindow.mainProgress:setPercent(100)
			updaterWindow.status:setText(string.format("Restarting %s...", g_game.isRavenQuest() and "RavenQuest" or "Ravendawn"))

			local init = g_resources.writeFileContents("/.initcomplete")

			if not init then
				g_logger.fatal(string.format("Couldn't write to path: %s", g_resources.getUserDir() .. "/.initcomplete"))
			end

			scheduleEvent(function()
				g_app.restart()
			end, 1000)
		end, 1000)
	end

	scheduleEvent(function()
		work()
	end, 5000)
end
