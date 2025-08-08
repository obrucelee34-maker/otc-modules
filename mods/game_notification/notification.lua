-- chunkname: @/modules/game_notification/notification.lua

GameNotification = {
	startTime = 0,
	queue = {}
}

local typeToString = {
	[NOTIFICATION_INFO] = "info",
	[NOTIFICATION_WARNING] = "warning",
	[NOTIFICATION_ERROR] = "error",
	[NOTIFICATION_SUCCESS] = "success",
	[NOTIFICATION_REGION] = "region",
	[NOTIFICATION_STAFF] = "staff"
}
local typeToColor = {
	[NOTIFICATION_INFO] = "#ffffff",
	[NOTIFICATION_WARNING] = "#ffa851",
	[NOTIFICATION_ERROR] = "#ff5151",
	[NOTIFICATION_SUCCESS] = "#77d463",
	[NOTIFICATION_REGION] = function(state)
		if state == "conflict" then
			return "#ffa851"
		elseif state == "peace" then
			return "#5DA4FB"
		elseif state == "about_conflict" then
			return "#ffa851"
		elseif state == "warzone" then
			return "#FF5151"
		end
	end,
	[NOTIFICATION_STAFF] = "#A556FF"
}
local regionConflictDuration = 3600

function GameNotification:init()
	g_ui.importStyle("styles/base.otui")
	g_ui.importStyle("styles/region.otui")
	g_ui.importStyle("styles/screen.otui")

	self.screenMessage = g_ui.createWidget("GameNotificationScreenMessagePanel", modules.game_interface.getHUDPanel())

	self.screenMessage:hide()
	connect(g_game, {
		onGameEnd = GameNotification.onGameEnd
	})
end

function GameNotification:terminate(internal)
	if self.window then
		self.window:destroy()

		self.window = nil
	end

	if self.timerEvent then
		removeEvent(self.timerEvent)

		self.timerEvent = nil
	end

	if self.hideEvent then
		removeEvent(self.hideEvent)

		self.hideEvent = nil
	end

	if self.screenMessageEvent then
		self.screenMessage:hide()
		removeEvent(self.screenMessageEvent)

		self.screenMessageEvent = nil
	end

	if not internal then
		if self.screenMessage then
			self.screenMessage:destroy()

			self.screenMessage = nil
		end

		disconnect(g_game, {
			onGameEnd = GameNotification.onGameEnd
		})

		GameNotification = nil
	end
end

function GameNotification.onGameEnd()
	GameNotification:terminate(true)

	GameNotification.queue = {}
end

function GameNotification:addToQueue(type, title, text, duration, custom)
	if self.window then
		if self.window.data then
			if type == NOTIFICATION_STAFF or self.window.data.type == NOTIFICATION_REGION and type == NOTIFICATION_REGION then
				self.window:destroy()

				self.window = nil

				return false
			end

			if self.window.data.type == type and self.window.data.title == title and self.window.data.text == text then
				return true
			end
		end

		for index, data in ipairs(self.queue) do
			if self.window.data.type == type and data.title == title and data.text == text then
				return true
			elseif type == NOTIFICATION_REGION then
				table.remove(self.queue, index)

				break
			end
		end

		local data = {
			type = type,
			title = title,
			text = text,
			duration = duration,
			custom = custom
		}

		table.insert(self.queue, data)

		return true
	end

	return false
end

function GameNotification:timerWork(duration)
	duration = duration or 5000
	self.startTime = g_clock.millis()

	self.window.progress_bar:setPercent(100)

	local function progressWork()
		if not self.window then
			return
		end

		self.window.progress_bar:setPercent(100 * (duration - (g_clock.millis() - self.startTime)) / duration)

		if self.window.progress_bar:getPercent() == 0 then
			self.window:destroy()

			self.window = nil

			if #self.queue > 0 then
				local data = table.remove(self.queue, 1)

				if data.type == NOTIFICATION_REGION then
					self:displayRegionChange(data.title, data.text == "conflict", data.text == "about_conflict", data.text == "warzone", data.custom)
				else
					self:display(data.type, data.title, data.text, data.duration)
				end
			end
		end

		scheduleEvent(progressWork, 25)
	end

	self.hideEvent = scheduleEvent(progressWork, 25)

	progressWork()
end

function GameNotification:display(type, title, text, duration, height)
	if title == "" and text == "" then
		return
	end

	if self:addToQueue(type, title, text, duration) then
		return
	end

	if modules.game_settings.getOption("hideInterface") then
		return
	end

	local messagePanel = modules.game_interface.getMessagePanel()

	self.window = g_ui.createWidget("GameNotificationBase", messagePanel)
	self.window.data = {
		type = type,
		title = title,
		text = text,
		duration = duration
	}

	local titleWidget, textWidget, iconWidget

	if title then
		titleWidget = g_ui.createWidget("GameNotificationTitle", self.window)

		titleWidget:setText(tr(title))

		textWidget = g_ui.createWidget("GameNotificationText", self.window)

		local success, error = pcall(tr, text)

		if not success then
			text = tr(text:gsub("%%", "%%%%"))
		else
			text = error
		end

		textWidget:setText(text)
	else
		iconWidget = g_ui.createWidget("GameNotificationIcon", self.window)

		iconWidget:setImageSource(string.format("/images/ui/windows/notification/icon_%s", typeToString[type]))

		textWidget = g_ui.createWidget("GameNotificationIconText", self.window)

		local success, error = pcall(tr, text)

		if not success then
			text = tr(text:gsub("%%", "%%%%"))
		else
			text = error
		end

		textWidget:setText(text)
	end

	if type == NOTIFICATION_STAFF then
		local close = g_ui.createWidget("GameNotificationIconClose", self.window)

		function close.onClick()
			self.window:destroy()

			self.window = nil
		end

		textWidget:addAnchor(AnchorLeft, "icon", AnchorRight)
		textWidget:setMarginLeft(10)
		textWidget:setMarginBottom(5)
		g_sound.play(3877214891)
	end

	local color = typeToColor[type]

	self.window.color_edge:setImageColor(color)
	self.window.progress_bar.progress:setImageColor(color)

	if height then
		height = math.max(textWidget:getTextSize().height + textWidget:getMarginTop() + textWidget:getMarginBottom(), height)
	else
		height = (titleWidget and titleWidget:getHeight() + titleWidget:getMarginTop() or 0) + (textWidget and 55 + textWidget:getTextSize().height + textWidget:getMarginTop() + textWidget:getMarginBottom() or 0)
	end

	self.window:setHeight(height)

	local isPermanent = type == NOTIFICATION_STAFF or duration == 0

	if isPermanent then
		self.window.progress_bar:setVisible(false)
		self.window:show()
		self.window:getParent():raise()

		return
	end

	self:timerWork(duration)
	self.window:show()
	messagePanel:raise()
	messagePanel:getParent():raise()

	local panel = modules.game_interface.getMessagePanel()

	if panel._connections then
		for _, connection in pairs(panel._connections) do
			connection()
		end
	end

	local additionalMargin = signalcall(g_game.onGetNotificationWindowMargin)

	if additionalMargin then
		local margin = panel:getMarginTop()

		panel:setMarginTop(additionalMargin)

		panel._connections = connect(self.window, {
			onVisibilityChange = function(_, visible)
				if not visible then
					panel:setMarginTop(margin)
				end
			end
		})
	end
end

function GameNotification:hide()
	if self.window then
		if self.hideEvent then
			removeEvent(self.hideEvent)

			self.hideEvent = nil
		end

		if self.timerEvent then
			removeEvent(self.timerEvent)

			self.timerEvent = nil
		end

		self.window:destroy()

		self.window = nil

		if #self.queue > 0 then
			local data = table.remove(self.queue, 1)

			self:display(data.type, data.title, data.text, data.duration)
		end
	end
end

function GameNotification:displayRegionChange(regionName, pvp, aboutToPvp, warZone, time)
	local state = pvp and (warZone and "warzone" or "conflict") or "peace"
	local color = typeToColor[NOTIFICATION_REGION](state)
	local barColor = aboutToPvp and (warZone and "#FF5151" or "#FFA851") or "#5DA4FB"

	if self:addToQueue(NOTIFICATION_REGION, regionName, pvp and "conflict" or aboutToPvp and "about_conflict" or "peace", nil, time) then
		return
	end

	modules.game_minimap.updateRegionName(regionName, color)

	local soundId

	if self.lastRegionChangeData and self.lastRegionChangeData.regionName == regionName and self.lastRegionChangeData.pvp ~= pvp then
		soundId = pvp and CONST_SE_ZONE_PEACE_TO_PVP or CONST_SE_ZONE_PVP_TO_PEACE
	end

	self.lastRegionChangeData = {
		regionName = regionName,
		pvp = pvp,
		aboutToPvp = aboutToPvp,
		time = time
	}

	if soundId then
		g_sound.play(soundId)
	end

	if modules.game_settings.getOption("hideInterface") then
		return
	end

	self.window = g_ui.createWidget("GameNotificationRegionBase", modules.game_interface.getMessagePanel())
	self.window.data = {
		type = NOTIFICATION_REGION,
		title = regionName,
		text = pvp and (warZone and "warzone" or "conflict") or "peace",
		custom = time
	}
	self.window.region_title = g_ui.createWidget("GameNotificationRegionTitle", self.window)

	self.window.region_title:setText(regionName)

	if time > 0 then
		self.window.region_progress = g_ui.createWidget("GameNotificationRegionProgressBar", self.window.background)
		self.window.left_icon = g_ui.createWidget("GameNotificationRegionIconLeft", self.window.background)
		self.window.right_icon = g_ui.createWidget("GameNotificationRegionIconRight", self.window.background)
		self.window.region_timer = g_ui.createWidget("GameNotificationRegionTimer", self.window.background)
		self.window.region_state = g_ui.createWidget("GameNotificationRegionState", self.window.background)

		self.window.left_icon:setImageSource("/images/ui/icons/region_" .. state)
		self.window.right_icon:setImageSource("/images/ui/icons/region_" .. (aboutToPvp and "conflict" or "peace"))
		self.window.region_progress.progress:setBackgroundColor(barColor)

		self.window.region_progress.lastPercent = math.floor(time / regionConflictDuration * 100)

		self.window.region_progress.progress:setPercent(self.window.region_progress.lastPercent)

		self.window.region_timer.time = time

		function self.window.region_timer.doWork()
			if not self.window then
				return
			end

			self.window.region_timer:setText(SecondsToClock(self.window.region_timer.time))

			self.window.region_timer.time = self.window.region_timer.time - 1

			if self.window.region_timer.time == 0 then
				self.window:destroy()

				self.window = nil

				if #self.queue > 0 then
					local data = table.remove(self.queue, 1)

					self:display(data.type, data.title, data.text, data.duration)
				end

				return
			end

			self.window.timerEvent = scheduleEvent(self.window.region_timer.doWork, 1000)
		end

		self.window.region_timer.doWork()
	else
		self.window.background:setWidth(150)

		self.window.icon = g_ui.createWidget("GameNotificationRegionIconMiddle", self.window.background)
		self.window.region_state = g_ui.createWidget("GameNotificationRegionStateMiddle", self.window.background)

		self.window.icon:setImageSource("/images/ui/icons/region_" .. state)
	end

	self.window.region_state:setText(state:upper())
	self.window.region_state:setTextColor(color)

	function self.window.onDestroy()
		if self.window.timerEvent then
			removeEvent(self.window.timerEvent)

			self.window.timerEvent = nil
		end
	end

	self:timerWork()
end

function GameNotification:displayScreenMessage(text)
	if modules.game_settings.getOption("hideInterface") then
		return
	end

	if text == "" or g_game.getLocalPlayer():isChanneling() then
		return
	end

	if self.screenMessageEvent and self.screenMessage:getText() == text then
		return
	end

	if self.screenMessageEvent then
		removeEvent(self.screenMessageEvent)

		self.screenMessageEvent = nil
	end

	self.screenMessage:setText(tr(text))

	self.screenMessage.data = {
		type = type,
		text = text
	}

	self.screenMessage:show()
	g_effects.cancelFade(self.screenMessage)
	g_effects.fadeIn(self.screenMessage, 250)

	self.screenMessageEvent = scheduleEvent(function()
		g_effects.fadeOut(self.screenMessage, 250)

		self.screenMessageEvent = nil
	end, 1250)
end
