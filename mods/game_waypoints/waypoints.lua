-- chunkname: @/modules/game_waypoints/waypoints.lua

GameWaypoints = {
	maxDistanceFromShrine = 1,
	lastTravelTime = 0
}

function GameWaypoints:show()
	self.window:show()
	self.window:raise()
	self.window:focus()
	GameWaypoints:setupLocations()
end

function GameWaypoints:hide()
	self.window:hide()
end

function GameWaypoints.toggle(mouseClick)
	if GameChat:isActive() or (type(mouseClick) ~= "boolean" or not mouseClick) and IsTextEditActive() then
		return
	end

	if GameWaypoints.window:isVisible() then
		GameWaypoints:hide()
	else
		if g_game:isInCutsceneMode() then
			return
		end

		GameWaypoints:show()
	end
end

function GameWaypoints.init()
	connect(g_game, {
		onGameStart = GameWaypoints.onGameStart,
		onGameEnd = GameWaypoints.onGameEnd
	})
	connect(LocalPlayer, {
		onPositionChange = GameWaypoints.onPositionChange,
		onLevelChange = GameWaypoints.onLevelChange,
		onPremiumChange = GameWaypoints.onPremiumChange
	})
	dofile("config.lua")
	g_ui.importStyle("main.otui")

	GameWaypoints.window = g_ui.createWidget("WaypointsWindow", modules.game_interface.getHUDPanel())
	GameWaypoints.map = GameWaypoints.window.contentPanel.map
	GameWaypoints.locationsList = GameWaypoints.window.contentPanel.locations.list

	local path = g_worldMap.getMainMapImageSourcePath()

	GameWaypoints.map:setImageSource(path)

	local textureWidth = GameWaypoints.map:getImageTextureWidth()
	local textureHeight = GameWaypoints.map:getImageTextureHeight()

	GameWaypoints.map:setImageClip({
		y = 0,
		x = 0.15 * textureWidth,
		width = 0.7 * textureWidth,
		height = textureHeight
	})
	ProtocolGame.registerExtendedOpcode(ExtendedIds.Waypoints, GameWaypoints.onExtendedOpcode)
end

function GameWaypoints.onPositionChange(player, newPos, oldPos)
	if not GameWaypoints.window:isVisible() then
		return
	end

	GameWaypoints:setupLocations()
end

function GameWaypoints.onLevelChange(player, level, levelPercent, oldLevel, oldLevelPercent)
	if not GameWaypoints.window:isVisible() then
		return
	end

	GameWaypoints:setupLocations()
end

function GameWaypoints.onPremiumChange(player, premium)
	local panel = GameWaypoints.window.contentPanel.locations.non_premium_holder

	panel:setHeight(premium and 0 or panel.maximumHeight)

	if not GameWaypoints.window:isVisible() then
		return
	end

	GameWaypoints:setupLocations()
end

function GameWaypoints.terminate()
	disconnect(g_game, {
		onGameStart = GameWaypoints.onGameStart,
		onGameEnd = GameWaypoints.onGameEnd
	})
	disconnect(LocalPlayer, {
		onPositionChange = GameWaypoints.onPositionChange,
		onLevelChange = GameWaypoints.onLevelChange,
		onPremiumChange = GameWaypoints.onPremiumChange
	})
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.Waypoints)
	GameWaypoints.window:destroy()
end

function GameWaypoints.onGameStart()
	return
end

function GameWaypoints.onGameEnd()
	GameWaypoints:hide()
end

function GameWaypoints:sendExtendedOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.Waypoints, g_game.serializeTable(data))
	end
end

function GameWaypoints.onExtendedOpcode(protocol, opcode, buffer)
	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		return
	end

	local action = data.action

	if action == "close" then
		GameWaypoints:hide()
	end
end

function GameWaypoints:getNearestWaypoint(player)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local playerPosition = player:getPosition()

	for _, waypoint in ipairs(Waypoints) do
		local distance = Position.greaterDistance(playerPosition, waypoint.position)

		if distance <= self.maxDistanceFromShrine then
			return waypoint
		end
	end
end

function GameWaypoints:setupLocations()
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local playerLevel = player:getLevel()
	local nearestWaypoint = self:getNearestWaypoint(player)

	if not nearestWaypoint then
		self:hide()

		return
	end

	local isPremium = player:isPremium()

	if self.lastNearestWaypoint and self.lastNearestWaypoint.name == nearestWaypoint.name and self.lastLevel == playerLevel and self.isPremium == isPremium then
		return
	end

	self.lastLevel = playerLevel
	self.isPremium = isPremium
	self.lastNearestWaypoint = nearestWaypoint

	self.locationsList:destroyChildren()
	self.map:destroyChildren()

	local waypointArrow = g_ui.createWidget("WaypointArrow", self.map)
	local arrowAnimation = Animation.create({
		pauseWhenHidden = true,
		loop = -1,
		duration = 1500,
		framesCount = 36,
		canvas = waypointArrow
	})

	arrowAnimation:move({
		start = 1,
		finish = 17,
		offset = {
			bottom = 10
		}
	})
	arrowAnimation:move({
		start = 18,
		finish = 36,
		offset = {
			bottom = -10
		}
	})
	arrowAnimation:start()

	local focused = false

	for _, waypoint in ipairs(Waypoints) do
		local mapIcon = g_ui.createWidget("WaypointMapIcon", self.map)
		local locationWidget = g_ui.createWidget("WaypointListItem", self.locationsList)

		locationWidget.waypoint = waypoint

		function locationWidget.onFocusChange(widget, focused)
			widget.name:setOn(focused)
			widget.radio:setOn(focused)
			mapIcon:setOn(focused)

			if focused then
				waypointArrow:addAnchor(AnchorHorizontalCenter, mapIcon:getId(), AnchorHorizontalCenter)
				waypointArrow:addAnchor(AnchorBottom, mapIcon:getId(), AnchorTop)
				waypointArrow:raise()

				local panel = self.window.contentPanel.locations.non_premium_holder

				if panel:getHeight() > 0 then
					panel.price:setText(locationWidget.price:getText())
				end
			end
		end

		function mapIcon.onClick(widget)
			if not locationWidget:isEnabled() then
				return
			end

			locationWidget:focus()
			self.locationsList:ensureChildVisible(locationWidget)
		end

		locationWidget.name:setText(waypoint.name)

		if nearestWaypoint.name == waypoint.name then
			locationWidget.price:setText("You are here")
			locationWidget.price_icon:setWidth(0)
			locationWidget.price:setOn(true)
			locationWidget:disable()
			mapIcon:setChecked(true)
		else
			locationWidget.price:setText(WaypointsPriceFormula(playerLevel, Position.greaterDistance(nearestWaypoint.position, waypoint.position), isPremium))
			locationWidget.price_icon:setWidth(16)
			locationWidget.price:setOn(false)
			locationWidget.premium_icon:setVisible(isPremium)
			locationWidget.premium_label:setVisible(isPremium)
			locationWidget.price.crossover:setVisible(isPremium)
			locationWidget:enable()
		end

		if locationWidget:isEnabled() and not focused then
			if locationWidget:isFocused() then
				locationWidget.onFocusChange(locationWidget, true)
			else
				locationWidget:focus()
			end

			focused = true
		end

		local marginLeft, marginTop = self:calculateMarginFromPosition(waypoint.position)

		mapIcon:setMarginLeft(marginLeft - mapIcon:getWidth() / 2)
		mapIcon:setMarginTop(marginTop - mapIcon:getHeight() / 2)
	end
end

function GameWaypoints:travel()
	local focusedChild = self.locationsList:getFocusedChild()

	if not focusedChild then
		return
	end

	if self.lastTravelTime + 1000 > g_clock.millis() then
		return
	end

	self.lastTravelTime = g_clock.millis()

	self:sendExtendedOpcode({
		action = "travel",
		name = focusedChild.waypoint.name
	})
end

function GameWaypoints:positionHasWaypoint(pos)
	for _, waypoint in ipairs(Waypoints) do
		if Position.equals(pos, waypoint.position) then
			return true
		end
	end

	return false
end

function GameWaypoints:calculateMarginFromPosition(pos)
	local imageWidth = self.map:getImageTextureWidth()
	local imageHeight = self.map:getImageTextureHeight()
	local x = imageWidth * 0.5 - imageWidth / 2
	local y = imageHeight * 0.5 - imageHeight / 2
	local width = imageWidth
	local height = imageHeight
	local percentRect = {
		x = x / imageWidth,
		y = y / imageHeight,
		width = width / imageWidth,
		height = height / imageHeight
	}
	local worldAreaFromX = g_worldMap.area.fromX + 550
	local worldAreaToX = g_worldMap.area.toX - 550
	local worldAreaFromY = g_worldMap.area.fromY
	local worldAreaToY = g_worldMap.area.toY
	local mapPos = {
		x = (pos.x - worldAreaFromX) / (worldAreaToX - worldAreaFromX),
		y = (pos.y - worldAreaFromY) / (worldAreaToY - worldAreaFromY),
		z = pos.z
	}
	local worldSize = self.map:getSize()
	local pX = (mapPos.x - percentRect.x) / percentRect.width
	local pY = (mapPos.y - percentRect.y) / percentRect.height
	local marginLeft = pX * worldSize.width
	local marginTop = pY * worldSize.height

	return marginLeft, marginTop
end
