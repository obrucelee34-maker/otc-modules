-- chunkname: @/modules/game_channeling/channeling.lua

channelingBarPanel = nil
channelingBar = nil

local duration = 0

function getChannelingBarPanel()
	return channelingBarPanel
end

function init()
	local hudPanel = modules.game_interface.getHUDPanel()

	g_ui.importStyle("channeling.otui")

	channelingBarPanel = g_ui.createWidget("ChannelingBarPanel", hudPanel)
	channelingBar = channelingBarPanel:recursiveGetChildById("channelingBar")

	channelingBarPanel:hide()

	channelingBarPanel.onDragEnter = onDragEnter
	channelingBarPanel.onDragMove = onDragMove

	connect(LocalPlayer, {
		onWalk = onWalk,
		onTeleport = onWalk,
		onPositionChange = onWalk,
		onChanneling = onChanneling
	})
	connect(g_game, {
		onGameEnd = cancelChannel
	})
end

function terminate()
	channelingBarPanel:destroy()
	disconnect(LocalPlayer, {
		onWalk = onWalk,
		onTeleport = onWalk,
		onPositionChange = onWalk,
		onChanneling = onChanneling
	})
	disconnect(g_game, {
		onGameEnd = cancelChannel
	})
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

	channelingBarPanel:recursiveGetChildById("editModeBackground"):setVisible(isEditMode)
	channelingBarPanel:setPhantom(not isEditMode)

	if isEditMode then
		show()
	else
		hide()
	end
end

function cancelChannel()
	g_game.getLocalPlayer():setChanneling(0)
end

function resizeChannelingBarPanel()
	local padding = channelingBarPanel:getWidth() - channelingBar:getWidth()

	channelingBar:setWidth(channelingBar:getWidth() / 3)

	for _, widgetName in ipairs({
		"fill",
		"frame",
		"background"
	}) do
		local widget = channelingBar:recursiveGetChildById(widgetName)

		widget:setWidth(widget:getWidth() / 3)
		widget:setMarginLeft(widget:getMarginLeft() / 3)
	end

	channelingBarPanel:setWidth(channelingBar:getWidth() + padding)
end

function onWalk(player, newPos, oldPos)
	return
end

function hide()
	modules.game_interface.g_actionKey.show()

	if not g_layout.isEditMode() then
		g_effects.fadeOut(channelingBarPanel, 100)
	end
end

function show()
	if not modules.game_settings.getOption("displayOwnHUD") or modules.game_settings.getOption("displayOwnCastBar") < 3 then
		return
	end

	modules.game_interface.g_actionKey.hide()
	channelingBarPanel:recursiveGetChildById("duration"):setVisible(channelingBar:recursiveGetChildById("name"):getText():lower() ~= "waiting for fish")
	channelingBarPanel:show()
	channelingBarPanel:raise()
	channelingBarPanel:setOpacity(1)
end

function onChanneling(player, channelType, channelStatus, channelPercent, channelName, channelDuration, reversed, interruptible)
	if channelStatus == ChannelingStatusInit or channelStatus == ChannelingStatusProgress then
		if g_game.getFollowingCreature() then
			g_game.cancelFollow()
		end

		if channelName and channelName ~= "" then
			channelingBar.name:setText(channelName)

			local textSize = channelingBar.name:getTextSize().width

			while textSize > 105 do
				channelingBar.name:setText(string.format("%s...", channelingBar.name:getText():sub(1, -5)))

				textSize = channelingBar.name:getTextSize().width
			end
		end

		if channelDuration then
			duration = channelDuration
		end

		channelingBar:setPercent(channelPercent)

		local path = string.format("/images/ui/icons/abilitybar/%s.png", channelName:lower())

		if g_resources.fileExists(path) then
			channelingBar.icon:setImageSource(path)
			channelingBar.icon:setVisible(true)
			channelingBar.frame_overlay:setVisible(true)
			channelingBar.frame_left:setOn(false)
			channelingBar.background:setOn(false)
		else
			channelingBar.icon:setVisible(false)
			channelingBar.frame_overlay:setVisible(false)
			channelingBar.frame_left:setOn(true)
			channelingBar.background:setOn(true)
		end

		if duration then
			local remaining = duration * (1 - channelPercent / 100) / 1000

			remaining = reversed and math.ceil(channelDuration / 100 - remaining * 10) / 10 or math.ceil(remaining * 10) / 10

			channelingBarPanel:recursiveGetChildById("duration"):setText(remaining == math.floor(remaining) and remaining .. ".0" or remaining)
		end

		show()
	elseif channelStatus == ChannelingStatusAbort then
		hide()
	elseif channelStatus == ChannelingStatusFinish then
		channelingBarPanel:recursiveGetChildById("duration"):setText("0.0")
		hide()
		scheduleEvent(function()
			modules.game_interface.onUpdateActionKey(true)
		end, 500)
	end
end
