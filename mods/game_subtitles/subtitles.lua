-- chunkname: @/modules/game_subtitles/subtitles.lua

GameSubtitles = {
	currentIndex = 1,
	nextChangeAfterMs = 0,
	subtitles = {}
}

function GameSubtitles:init()
	connect(g_game, {
		onPlayingVideoFrameChanged = self.onPlayingVideoFrameChanged,
		onPlayingVideoFinished = self.onPlayingVideoFinished
	})
	g_ui.importStyle("styles/main.otui")

	self.window = g_ui.createWidget("GameSubtitlesWindow", modules.game_interface.getRootPanel().overlay)

	connect(self.window:getParent(), {
		onVisibilityChange = function(window, visible)
			if not visible then
				self:reset()
			end
		end
	})
end

function GameSubtitles:terminate()
	disconnect(g_game, {
		onPlayingVideoFrameChanged = self.onPlayingVideoFrameChanged,
		onPlayingVideoFinished = self.onPlayingVideoFinished
	})

	if self.window then
		self.window:destroy()

		self.window = nil
	end

	self = nil
end

function GameSubtitles.onPlayingVideoFinished()
	local self = GameSubtitles

	self:reset()
end

function GameSubtitles:reset()
	self.currentVideoTextureName = nil
	self.currentIndex = 1
	self.nextChangeAfterMs = 0
	self.subtitles = {}

	self:setText("")
	self:hide()
end

function GameSubtitles.onPlayingVideoFrameChanged(videoTextureName, currentFrame, frameDelay)
	local self = GameSubtitles
	local locale = EnterGame.getLocale(true)

	if self.currentVideoTextureName ~= videoTextureName then
		self:reset()

		self.currentVideoTextureName = videoTextureName

		self:loadSubtitlesForVideo(videoTextureName)

		if not self.subtitles or not self.subtitles[locale] then
			return
		end
	end

	if not self.subtitles or not self.subtitles[locale] then
		return
	end

	if self.currentIndex > #self.subtitles[locale] then
		self:hide()

		return
	end

	local subtitle = self.subtitles[locale][self.currentIndex]
	local timeElapsed = currentFrame * frameDelay

	if timeElapsed >= subtitle.from and timeElapsed <= subtitle.to then
		self:setText(subtitle.text)
		self:show()
	elseif timeElapsed > subtitle.to then
		self.currentIndex = self.currentIndex + 1

		self:hide()
	end
end

function GameSubtitles:show()
	self.window:show()
end

function GameSubtitles:hide()
	self.window:hide()
end

function GameSubtitles:setText(text)
	self.window:setText(text)
end

function GameSubtitles:loadSubtitlesForVideo(videoTextureName)
	local videoName = videoTextureName:match("videos/(.+).mp4")

	if not videoName then
		return
	end

	local directories = g_resources.listDirectoryFiles(resolvepath("subtitles"))
	local files = g_resources.listDirectoryFiles(resolvepath("subtitles"))

	for _, file in ipairs(files) do
		print(file)

		if file:gsub(".lua", "") == videoName then
			local func, error = loadfile("subtitles/" .. file)

			if not func then
				g_logger.fatal(error)

				return false
			end

			setfenv(func, self)
			func()
		end
	end

	return true
end
