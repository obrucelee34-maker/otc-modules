-- chunkname: @/modules/game_minimap/minimap.lua

minimapWindow = nil
defaultZoom = 200
zoom = defaultZoom
minZoom = 100
maxZoom = 400
zoomStep = 50
zoomDelta = {
	min = 1,
	max = 1
}
dragSpeed = 1
lastPositionOffset = {
	y = 0,
	x = 0,
	zoom = zoom
}
clipPosition = {
	y = 0,
	width = 200,
	height = 200,
	x = 0
}
isDragging = g_clock.millis()
minimapFlags = {}
tradepackPlayerFlags = {}
skullPlayerFlags = {}
buttons = {}
safeModeButtonPopup = nil
floorChangeFlags = {}
MAX_VISIBLE_RANGE = 150
MAX_VISIBLE_FLOOR_CHANGE_RANGE = 75

local directionAbbr = {
	[0] = "N",
	"E",
	"S",
	"W"
}

buttonsList = {
	"questTrackerButton",
	"teleportButton",
	"safeModeButton",
	"houseMakerButton",
	"channelSwitchButton",
	"battleListButton",
	"mailButton",
	"floorIndicatorButton"
}

local pvpModes = {
	skull = PvpOffensive,
	shield = PvpPeaceful,
	sword = PvpDefensive
}
local nextPvpModes = {
	[PvpPeaceful] = PvpDefensive,
	[PvpDefensive] = PvpOffensive,
	[PvpOffensive] = PvpPeaceful
}
local pvpButtons = {
	[PvpPeaceful] = {
		{
			tooltip = "Peaceful",
			color = "#A6AAB2",
			background = "icon_border_off",
			id = "shield",
			icon = "icon_shield"
		},
		{
			id = "sword",
			color = "#A6AAB2",
			tooltip = "Defensive",
			icon = "icon_sword"
		},
		{
			id = "skull",
			color = "#A6AAB2",
			tooltip = "Offensive",
			icon = "icon_skull"
		}
	},
	[PvpDefensive] = {
		{
			tooltip = "Defensive",
			color = "#1F2124",
			background = "icon_border_yellow",
			id = "sword",
			icon = "icon_sword"
		},
		{
			id = "shield",
			color = "#A6AAB2",
			tooltip = "Peaceful",
			icon = "icon_shield"
		},
		{
			id = "skull",
			color = "#A6AAB2",
			tooltip = "Offensive",
			icon = "icon_skull"
		}
	},
	[PvpOffensive] = {
		{
			tooltip = "Offensive",
			color = "#1F2124",
			background = "icon_border_red",
			id = "skull",
			icon = "icon_skull"
		},
		{
			id = "shield",
			color = "#A6AAB2",
			tooltip = "Peaceful",
			icon = "icon_shield"
		},
		{
			id = "sword",
			color = "#A6AAB2",
			tooltip = "Defensive",
			icon = "icon_sword"
		}
	}
}

FLOOR_INDICATOR_MODE_ENABLED = 1
FLOOR_INDICATOR_MODE_UNDERGROUND = 2
FLOOR_INDICATOR_MODE_DISABLED = 3

local floorIndicatorMode = FLOOR_INDICATOR_MODE_ENABLED
local nextFloorIndicatorModes = {
	[FLOOR_INDICATOR_MODE_ENABLED] = FLOOR_INDICATOR_MODE_UNDERGROUND,
	[FLOOR_INDICATOR_MODE_UNDERGROUND] = FLOOR_INDICATOR_MODE_DISABLED,
	[FLOOR_INDICATOR_MODE_DISABLED] = FLOOR_INDICATOR_MODE_ENABLED
}
local floorIndicatorButtons = {
	{
		{
			tooltip = "Enabled",
			color = "#1F2124",
			background = "icon_border_on",
			icon = "icon_floor_enabled",
			id = FLOOR_INDICATOR_MODE_ENABLED
		},
		{
			color = "#A6AAB2",
			tooltip = "Only Underground",
			icon = "icon_floor_underground",
			id = FLOOR_INDICATOR_MODE_UNDERGROUND
		},
		{
			color = "#A6AAB2",
			tooltip = "Disabled",
			icon = "icon_floor_disabled",
			id = FLOOR_INDICATOR_MODE_DISABLED
		}
	},
	{
		{
			tooltip = "Only Underground",
			color = "#1F2124",
			background = "icon_border_on",
			icon = "icon_floor_underground",
			id = FLOOR_INDICATOR_MODE_UNDERGROUND
		},
		{
			color = "#A6AAB2",
			tooltip = "Enabled",
			icon = "icon_floor_enabled",
			id = FLOOR_INDICATOR_MODE_ENABLED
		},
		{
			color = "#A6AAB2",
			tooltip = "Disabled",
			icon = "icon_floor_disabled",
			id = FLOOR_INDICATOR_MODE_DISABLED
		}
	},
	{
		{
			tooltip = "Disabled",
			color = "#1F2124",
			background = "icon_border_on",
			icon = "icon_floor_disabled",
			id = FLOOR_INDICATOR_MODE_DISABLED
		},
		{
			color = "#A6AAB2",
			tooltip = "Enabled",
			icon = "icon_floor_enabled",
			id = FLOOR_INDICATOR_MODE_ENABLED
		},
		{
			color = "#A6AAB2",
			tooltip = "Only Underground",
			icon = "icon_floor_underground",
			id = FLOOR_INDICATOR_MODE_UNDERGROUND
		}
	}
}

defaultMarginIcon = {
	[-1] = {
		top = -4,
		left = 0
	},
	[MAPMARK_PLAYER] = {
		top = -16,
		left = 0
	},
	[MAPMARK_PARTY_MEMBER] = {
		top = -16,
		left = 0
	},
	[MAPMARK_GUILD_WAR_FLAG_UNCLAIMED] = {
		top = -16,
		left = 0
	},
	[MAPMARK_GUILD_WAR_FLAG_OWN] = {
		top = -16,
		left = 0
	},
	[MAPMARK_GUILD_WAR_FLAG_OTHERS] = {
		top = -16,
		left = 0
	},
	[MAPMARK_FLOOR_CHANGE] = {
		top = -1,
		left = -1
	}
}

local onDragEnterMinimap, onDragMoveMinimap, onDragLeaveMinimap
local flagPool = {}
local POOL_CLEANUP_INTERVAL = 30000
local lastFlagUpdatePos

function getFlagFromPool()
	local flag = table.remove(flagPool)

	flag = flag or g_ui.createWidget("WorldMapIcon", minimapWindow.image)
	flag.hidden = false

	flag:show()

	return flag
end

function returnFlagToPool(flag)
	if not flag then
		return
	end

	if #flagPool < 100 then
		flag:hide()

		flag.hidden = true
		flag.position = nil
		flag.direction = nil

		table.insert(flagPool, flag)
	else
		flag:destroy()
	end
end

function createMinimapWidget()
	local minimapWindow = g_ui.createWidget("MinimapWindow", modules.game_interface.getHUDPanel())

	minimapWindow.image:setCircle(true)
	minimapWindow.image:setImageSize({
		width = 200,
		height = 200
	})
	minimapWindow.image:setTextureRadius(defaultZoom)
	connect(minimapWindow.image, "onDragEnter", onDragEnterMinimap)
	connect(minimapWindow.image, "onDragMove", onDragMoveMinimap)
	connect(minimapWindow.image, "onDragLeave", onDragLeaveMinimap)

	function minimapWindow.onMouseWheel(widget, mousePos, direction)
		if direction == MouseWheelDown then
			zoomOut()
		elseif direction == MouseWheelUp then
			zoomIn()
		end
	end

	minimapWindow.onDragEnter = onDragEnter
	minimapWindow.onDragMove = onDragMove

	if BGS_DEMO then
		function minimapWindow.onVisibilityChange(widget, visible)
			if visible then
				widget:hide()
			end
		end
	end

	return minimapWindow
end

function init()
	g_ui.importStyle("minimap.otui")

	minimapWindow = createMinimapWidget()

	updateTime(g_game.getTime())

	safeModeButtonPopup = minimapWindow.safeModeButtonPopup
	minimapWindow.safeModeButton.popup = safeModeButtonPopup

	connect(LocalPlayer, {
		onPositionChange = onPositionChange
	})
	connect(g_game, {
		onGameStart = onGameStart,
		onGameEnd = onGameEnd,
		onTimeChange = updateTime,
		onRemoveAutomapFlag = removeFlag
	})

	if g_game.isOnline() then
		onGameStart()
		onPositionChange(g_game.getLocalPlayer())
	end

	cleanupFlagPool()
end

function terminate()
	minimapWindow:destroy()

	minimapWindow = nil

	if safeModeButtonPopup then
		safeModeButtonPopup:destroy()

		safeModeButtonPopup = nil
	end

	removeEvent(timeEvent)

	timeEvent = nil

	for _, button in pairs(buttons) do
		if button and not button:isDestroyed() then
			button:destroy()
		end
	end

	disconnect(LocalPlayer, {
		onPositionChange = onPositionChange
	})
	disconnect(g_game, {
		onGameStart = onGameStart,
		onGameEnd = onGameEnd,
		onTimeChange = updateTime,
		onRemoveAutomapFlag = removeFlag
	})
end

function onPositionChange(player, newPos, oldPos)
	if not player then
		return
	end

	if not oldPos or newPos.z ~= oldPos.z then
		lastFlagUpdatePos = newPos

		onFloorChange(newPos, oldPos)
	elseif not lastFlagUpdatePos or not Position.isInRange(newPos, lastFlagUpdatePos, 5, 5) then
		lastFlagUpdatePos = newPos

		onFloorChange(newPos, oldPos)
	end

	if not minimapWindow.cross and newPos then
		local customMapOffset = g_worldMap.getCustomMapPositionOffset(newPos)

		newPos.x = newPos.x - customMapOffset.x
		newPos.y = newPos.y - customMapOffset.y

		local minimapFlag = g_ui.createWidget("MiniMapPlayerIcon", minimapWindow.image)

		minimapFlag.position = newPos
		minimapFlag.icon = MAPMARK_PLAYER
		minimapFlag.tooltip = player:getName()
		minimapFlag.additionalMarginTop = getFlagIconMargin(minimapFlag.icon, {
			top = -16
		}).top
		minimapFlag.additionalMarginLeft = getFlagIconMargin(minimapFlag.icon, {
			left = 0
		}).left

		addFlag(minimapFlag, true)

		minimapWindow.cross = minimapFlag
	end

	if minimapWindow.cross and not updateFlagPosition(oldPos, newPos, MAPMARK_PLAYER, player:getName()) then
		updateFlagPosition(minimapWindow.cross.position, newPos, MAPMARK_PLAYER, player:getName())
	end

	if isDragging > g_clock.millis() then
		return
	end

	lastPositionOffset.x = 0
	lastPositionOffset.y = 0

	updateMinimapClip(0, 0)
end

function updateMinimapClip(offsetX, offsetY)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local radius = minimapWindow.image:getImageWidth() / 2

	offsetX = offsetX * dragSpeed * zoom / radius + lastPositionOffset.x
	offsetY = offsetY * dragSpeed * zoom / radius + lastPositionOffset.y

	local playerPos = player:getPosition()

	playerPos.x = playerPos.x - g_worldMap.getCustomMapPositionOffset(playerPos).x

	g_worldMap.updateImageData(true)

	local x = (playerPos.x - g_worldMap.area.fromX) / (g_worldMap.area.toX - g_worldMap.area.fromX)
	local y = (playerPos.y - g_worldMap.area.fromY) / (g_worldMap.area.toY - g_worldMap.area.fromY)
	local textureWidth = minimapWindow.image:getImageTextureWidth()
	local textureHeight = minimapWindow.image:getImageTextureHeight()

	x = textureWidth * x
	y = textureHeight * y

	local minCoordX = zoom
	local maxCoordX = textureWidth - radius - zoom
	local minCoordY = zoom
	local maxCoordY = textureHeight - radius - zoom
	local coordX = x - offsetX - radius

	if minCoordX <= coordX and coordX <= maxCoordX then
		lastPositionOffset.x = offsetX
	else
		zoomIn()

		return
	end

	local coordY = y - offsetY - radius

	if minCoordY <= coordY and coordY <= maxCoordY then
		lastPositionOffset.y = offsetY
	else
		zoomIn()

		return
	end

	clipPosition.x = math.clamp(coordX, minCoordX, maxCoordX)
	clipPosition.y = math.clamp(coordY, minCoordY, maxCoordY)

	minimapWindow.image:setImageClip(clipPosition)
	updateMapFlags()
end

function onDragEnterMinimap(self, mousePos)
	isDragging = g_clock.millis() + 5000

	return true
end

function onDragMoveMinimap(self, mousePos, mouseMoved)
	isDragging = g_clock.millis() + 5000

	updateMinimapClip(mouseMoved.x, mouseMoved.y)

	return true
end

function onDragLeaveMinimap()
	isDragging = g_clock.millis()

	return true
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
	modules.game_house.GameHouse:updateLandTrackerWindow()
end

function update()
	local isEditMode = g_layout.isEditMode()

	minimapWindow:recursiveGetChildById("image"):setPhantom(isEditMode)
	minimapWindow:recursiveGetChildById("editModeBackground"):setVisible(isEditMode)
end

function onGameStart()
	connect(g_game, {
		onUpdateChannelInfo = updateChannelInfo
	})
	addEvent(function()
		local player = g_game.getLocalPlayer()

		if player then
			local position = player:getPosition()

			if position then
				onPositionChange(player, position, position)
			end
		end

		updateMapFlags()
	end)

	local char = g_game.getCharacterName()
	local minimap = g_settings.getNode("game_minimap")

	if minimap and minimap[char] then
		g_game.setPVPMode(minimap[char].pvpMode or PvpPeaceful)
	end

	setFloorIndicatorMode(g_settings.get("floorIndicatorMode") or 1)
	updateButtonsVisibility()
	minimapWindow:show()
end

function onGameEnd()
	for position, icons in pairs(minimapFlags) do
		for icon, widgets in pairs(icons) do
			for _, widget in pairs(widgets) do
				widget:destroy()
			end
		end
	end

	minimapFlags = {}

	for _, flag in pairs(tradepackPlayerFlags) do
		flag:destroy()

		flag = nil
	end

	tradepackPlayerFlags = {}

	for _, flag in pairs(skullPlayerFlags) do
		flag:destroy()

		flag = nil
	end

	skullPlayerFlags = {}

	minimapWindow:hide()
	disconnect(g_game, {
		onUpdateChannelInfo = updateChannelInfo
	})

	local char = g_game.getCharacterName()
	local minimap = g_settings.getNode("game_minimap") or {}

	minimap[char] = {
		pvpMode = g_game.getPVPMode()
	}

	g_settings.setNode("game_minimap", minimap)
	g_settings.save()

	minimapWindow.cross = nil

	updateRegionName()
end

function updateButtonsVisibility()
	if g_game.isAetherRiftChannel() or g_game.isGuildWarsChannel() then
		for _, buttonId in pairs(buttonsList) do
			if buttonId ~= "battleListButton" then
				local button = minimapWindow:recursiveGetChildById(buttonId)

				if button then
					button:setVisible(false)
				end
			end
		end
	else
		for _, buttonId in pairs(buttonsList) do
			local button = minimapWindow:recursiveGetChildById(buttonId)

			if button then
				button:setVisible(true)
			end
		end
	end
end

function zoomOut()
	zoom = math.min(maxZoom * zoomDelta.max, zoom + zoomStep)

	minimapWindow.image:setTextureRadius(zoom)
	updateMinimapClip(0, 0)
end

local zoomTries = 0

function zoomIn()
	local newZoom = math.max(minZoom * zoomDelta.min, zoom - zoomStep)

	if zoom == newZoom then
		zoomTries = zoomTries + 1

		if zoomTries > 5 then
			return
		end
	else
		zoomTries = 0
	end

	zoom = newZoom

	minimapWindow.image:setTextureRadius(zoom)
	updateMinimapClip(0, 0)
end

function autoWalk(widget, mousePos)
	local threshold = 8
	local centerX = minimapWindow.image:getX() + minimapWindow.image:getWidth() / 2 - threshold / 2
	local centerY = minimapWindow.image:getY() + minimapWindow.image:getHeight() / 2 - threshold / 2
	local radius = minimapWindow.image:getWidth() / 2
	local effectiveRadius = radius - threshold
	local dx = mousePos.x - centerX
	local dy = mousePos.y - centerY
	local distance = math.sqrt(dx * dx + dy * dy)

	if effectiveRadius < distance then
		return
	end

	if lastPositionOffset.x ~= 0 or lastPositionOffset.y ~= 0 then
		return
	end

	local player = g_game.getLocalPlayer()

	if player:isServerWalking() then
		g_game.stop()
	end

	if not player or FishFight.gameState == 1 or player:isChanneling() or modules.game_professions.minigameWindow:isVisible() or player:isInTutorialArea() then
		return
	end

	local relX = mousePos.x - minimapWindow.image:getX()
	local relY = mousePos.y - minimapWindow.image:getY()
	local playerPos = player:getPosition()

	local function getPositionBasedOnClickPosition(relativeClickPosition)
		local px = (playerPos.x - g_worldMap.area.fromX) / (g_worldMap.area.toX - g_worldMap.area.fromX)
		local py = (playerPos.y - g_worldMap.area.fromY) / (g_worldMap.area.toY - g_worldMap.area.fromY)

		px = px * minimapWindow.image:getImageTextureWidth()
		py = py * minimapWindow.image:getImageTextureHeight()

		local x = (radius - relativeClickPosition.x) * (zoom / radius)
		local y = (radius - relativeClickPosition.y) * (zoom / radius)
		local xx = px - x
		local yy = py - y
		local realX = g_worldMap.area.fromX + xx / minimapWindow.image:getImageTextureWidth() * (g_worldMap.area.toX - g_worldMap.area.fromX)
		local realY = g_worldMap.area.fromY + yy / minimapWindow.image:getImageTextureHeight() * (g_worldMap.area.toY - g_worldMap.area.fromY)

		return {
			x = realX,
			y = realY
		}
	end

	local realPos = getPositionBasedOnClickPosition({
		x = relX,
		y = relY
	})
	local destination = {
		x = realPos.x,
		y = realPos.y,
		z = player:getPosition().z
	}

	if player:isGamemaster() then
		g_game.talk(string.format("/pos %i, %i, %i", destination.x, destination.y, destination.z))

		return
	end

	player:autoWalk({
		x = realPos.x,
		y = realPos.y,
		z = playerPos.z
	}, nil, true)
end

local function isWithinCircle(point, center, radius)
	local dx = point.x - center.x
	local dy = point.y - center.y
	local distanceSquared = dx * dx + dy * dy

	return distanceSquared <= radius * radius
end

local function isRectWithinCircle(rect, center, radius)
	local topLeft = {
		x = rect.x,
		y = rect.y
	}
	local topRight = {
		x = rect.x + rect.width,
		y = rect.y
	}
	local bottomLeft = {
		x = rect.x,
		y = rect.y + rect.height
	}
	local bottomRight = {
		x = rect.x + rect.width,
		y = rect.y + rect.height
	}

	return isWithinCircle(topLeft, center, radius) and isWithinCircle(topRight, center, radius) and isWithinCircle(bottomLeft, center, radius) and isWithinCircle(bottomRight, center, radius)
end

local function isCircleWithinCircle(c1, c2)
	local distance = math.sqrt((c2.center.x - c1.center.x)^2 + (c2.center.y - c1.center.y)^2)
	local difference_in_radii = math.abs(c2.radius - c1.radius)

	return distance < difference_in_radii
end

function processFloorChangeFlag(widget)
	if not widget.position then
		return false
	end

	local player = g_game.getLocalPlayer()
	local playerPos = player and player:getPosition() or nil

	if not playerPos or widget.position.z ~= playerPos.z then
		return false
	end

	if not Position.isInRange(widget.position, playerPos, MAX_VISIBLE_FLOOR_CHANGE_RANGE, MAX_VISIBLE_FLOOR_CHANGE_RANGE) then
		return false
	end

	local key = Position.generateHash(widget.position)
	local flag = getFlag(widget.position, widget.icon, widget.description)

	if not flag then
		removeFlag(widget.position)

		flag = g_ui.createWidget("WorldMapIcon", minimapWindow.image)
		flag.icon = MAPMARK_FLOOR_CHANGE
		flag.position = widget.position
		flag.additionalMarginTop = getFlagIconMargin(flag.icon, {
			top = -1
		}).top
		flag.additionalMarginLeft = getFlagIconMargin(MAPMARK_FLOOR_CHANGE, {
			left = -1
		}).left
		minimapFlags[key] = minimapFlags[key] or {}
		minimapFlags[key][MAPMARK_FLOOR_CHANGE] = minimapFlags[key][MAPMARK_FLOOR_CHANGE] or {}
		minimapFlags[key][MAPMARK_FLOOR_CHANGE][widget.description or 1] = flag
	else
		minimapFlags[key] = minimapFlags[key] or {}
		minimapFlags[key][MAPMARK_FLOOR_CHANGE][widget.description or 1].hidden = false
	end

	return true
end

function getFlagIconMargin(icon, orDefault)
	return defaultMarginIcon[icon] or orDefault and orDefault or defaultMarginIcon[-1]
end

function processWorldMapFlag(widget)
	if not widget.icon then
		return false
	end

	local hidden = true

	if widget.icon == MAPMARK_MISSION_AVAILABLE then
		hidden = not g_worldMap.iconSettings.showMissionAvailable
	elseif widget.icon == MAPMARK_MISSION_COMPLETE then
		hidden = not g_worldMap.iconSettings.showMissionComplete
	elseif widget.icon == MAPMARK_HOUSE then
		hidden = not g_worldMap.iconSettings.showHouse
	elseif widget.icon == MAPMARK_SEAPORT then
		hidden = not g_worldMap.iconSettings.showSeaport
	elseif widget.icon == MAPMARK_TRADEPOST then
		hidden = not g_worldMap.iconSettings.showTradepost
	elseif widget.icon == MAPMARK_CRAFTING_STATION then
		hidden = not g_worldMap.iconSettings.showCraftingStation
	elseif widget.icon == MAPMARK_PVP_ARENA then
		hidden = not g_worldMap.iconSettings.showPvPArena
	elseif widget.icon == MAPMARK_RANGERS_COMPANY then
		hidden = not g_worldMap.iconSettings.showRangersCompanyOutpost
	elseif widget.icon == MAPMARK_NPC_BANK then
		hidden = not g_worldMap.iconSettings.showBank
	elseif widget.icon == MAPMARK_NPC_FISHPOST then
		hidden = not g_worldMap.iconSettings.showFishpost
	elseif widget.icon == MAPMARK_NPC_BUILDERS then
		hidden = not g_worldMap.iconSettings.showBuilders
	elseif widget.icon == MAPMARK_NPC_WAREHOUSE then
		hidden = not g_worldMap.iconSettings.showWarehouse
	elseif widget.icon == MAPMARK_RESPAWN_SHRINE then
		hidden = not g_worldMap.iconSettings.showRespawnShrine
	elseif widget.icon == MAPMARK_MARKET then
		hidden = not g_worldMap.iconSettings.showMarket
	elseif widget.icon == MAPMARK_MOA_MERCHANT then
		hidden = not g_worldMap.iconSettings.showMoaMerchant
	elseif widget.icon == MAPMARK_VENDOR then
		hidden = not g_worldMap.iconSettings.showVendors
	elseif widget.icon == MAPMARK_COLLECTOR then
		hidden = not g_worldMap.iconSettings.showCollectors
	elseif widget.icon == MAPMARK_COMPASS then
		hidden = g_worldMap.isCompassFlagHidden(widget)
	elseif widget.icon == MAPMARK_PARTY_MEMBER then
		hidden = false
	elseif widget.icon == MAPMARK_PLAYER or widget.icon >= MAPMARK_GUILD_WAR_TOWER_UNCLAIMED and widget.icon <= MAPMARK_GUILD_WAR_FLAG_OTHERS then
		hidden = false
	end

	if widget.position then
		local player = g_game.getLocalPlayer()
		local playerPos = player and player:getPosition() or nil

		if g_worldMap.displayCurrentFloorFlags and (not playerPos or widget.position.z ~= playerPos.z) and (not g_worldMap.displayCurrentFloorFlagsExceptions or not g_worldMap.displayCurrentFloorFlagsExceptions[widget.icon]) then
			hidden = true
		end

		local key = Position.generateHash(widget.position)
		local flag = getFlag(widget.position, widget.icon, widget.description)

		if not flag then
			removeFlag(widget.position)

			if widget and widget.icon ~= MAPMARK_REGION_CONFLICT and widget.icon ~= MAPMARK_DYNAMICEVENT and widget.icon ~= MAPMARK_PARTY_MEMBER and widget.icon ~= MAPMARK_PLAYER then
				flag = g_ui.createWidget("WorldMapIcon", minimapWindow.image)
				flag.icon = widget.icon
				flag.position = widget.position
				flag.region = widget.region or ""
				flag.alwaysShow = widget.alwaysShow

				flag:setTooltip(widget:getTooltip())

				flag.profession = widget.profession
				flag.compassSize = widget.compassSize
				flag.cullingSpawn = widget.cullingSpawn
				flag.additionalMarginTop = getFlagIconMargin(widget.icon).top
				flag.additionalMarginLeft = getFlagIconMargin(widget.icon).left
				minimapFlags[key] = minimapFlags[key] or {}
				minimapFlags[key][widget.icon] = minimapFlags[key][widget.icon] or {}
				minimapFlags[key][widget.icon][widget.description or 1] = flag
			end
		else
			minimapFlags[key] = minimapFlags[key] or {}
			minimapFlags[key][widget.icon] = minimapFlags[key][widget.icon] or {}
			minimapFlags[key][widget.icon][widget.description or 1].hidden = hidden
		end
	end

	return true
end

local min = math.min
local max = math.max
local ceil = math.ceil
local format = string.format
local defaultImageSize = {
	width = 16,
	height = 16
}
local minimumFloorChangeSize = 6

function updateFlag(widget, playerPos)
	local widgetPos = widget.position

	if not widgetPos or widget.hidden then
		widget:hide()

		return
	end

	local icon = widget.icon
	local zoomFactor = defaultZoom / zoom

	if icon == MAPMARK_COMPASS then
		local newSize = ceil(widget.compassSize * zoomFactor)

		widget:setImageSource(format(g_worldMap.getCompassTextureNameBySize(newSize), widget.cullingSpawn and "red" or "default"))
		widget:raise()
	elseif icon == MAPMARK_FLOOR_CHANGE then
		widget:setImageSource("/images/ui/windows/minimap/icons/small/floor_" .. (widget.direction == 1 and "down" or "up"))
	elseif tonumber(icon) then
		local iconType = widget.profession and g_worldMap.iconAssets[icon][widget.profession] or g_worldMap.iconAssets[icon]

		if iconType then
			widget:setImageSource("/images/ui/windows/minimap/icons/small/" .. iconType)
		end
	else
		widget:setImageSource(resolvepath(icon, 1))
	end

	if icon ~= MAPMARK_PARTY_MEMBER and icon ~= MAPMARK_PLAYER and (not (icon >= MAPMARK_GUILD_WAR_FLAG_UNCLAIMED) or not (icon <= MAPMARK_GUILD_WAR_FLAG_OTHERS)) then
		if icon == MAPMARK_FLOOR_CHANGE then
			local size = 6 * zoomFactor

			if size <= minimumFloorChangeSize or zoom > defaultZoom then
				widget:hide()

				return
			end

			widget:setSize({
				width = size,
				height = size
			})
		elseif icon == MAPMARK_COMPASS then
			local compassSize = widget.compassSize * zoomFactor

			widget:setSize({
				width = compassSize,
				height = compassSize
			})
		else
			local size = max(16, min(24, 24 * zoomFactor))

			widget:setSize({
				width = size,
				height = size
			})
		end
	end

	local g_worldMap_area = g_worldMap.area
	local image = minimapWindow.image
	local imageTextureWidth = image:getImageTextureWidth()
	local imageTextureHeight = image:getImageTextureHeight()
	local radius = image:getWidth() / 2
	local zoomRatio = zoom / radius
	local x = (widgetPos.x - g_worldMap_area.fromX) / (g_worldMap_area.toX - g_worldMap_area.fromX) * imageTextureWidth + lastPositionOffset.x
	local y = (widgetPos.y - g_worldMap_area.fromY) / (g_worldMap_area.toY - g_worldMap_area.fromY) * imageTextureHeight + lastPositionOffset.y
	local playerPosX = (playerPos.x - g_worldMap_area.fromX) / (g_worldMap_area.toX - g_worldMap_area.fromX) * imageTextureWidth
	local playerPosY = (playerPos.y - g_worldMap_area.fromY) / (g_worldMap_area.toY - g_worldMap_area.fromY) * imageTextureHeight
	local deltaX = playerPosX - x
	local deltaY = playerPosY - y
	local halfWidgetWidth = widget:getWidth() / 2
	local halfWidgetHeight = widget:getHeight() / 2
	local widgetMarginTop = radius - halfWidgetHeight - deltaY / zoomRatio + (widget.additionalMarginTop or 0)
	local widgetMarginLeft = radius - halfWidgetWidth - deltaX / zoomRatio + (widget.additionalMarginLeft or 0)

	if widgetMarginLeft < 0 or widgetMarginTop < 0 or widgetMarginTop > image:getHeight() or widgetMarginLeft > image:getWidth() then
		widget:hide()

		return
	end

	widget:setMarginTop(widgetMarginTop)
	widget:setMarginLeft(widgetMarginLeft)

	local border = minimapWindow.border
	local center = {
		x = border:getX() + border:getWidth() / 2,
		y = border:getY() + border:getHeight() / 2
	}
	local isVisible

	if icon == MAPMARK_COMPASS then
		local flagCenter = {
			x = widget:getX() + halfWidgetWidth,
			y = widget:getY() + halfWidgetHeight
		}

		isVisible = isCircleWithinCircle({
			center = flagCenter,
			radius = halfWidgetHeight
		}, {
			center = center,
			radius = radius
		})
	else
		isVisible = isRectWithinCircle({
			x = widget:getX(),
			y = widget:getY(),
			width = widget:getWidth(),
			height = widget:getHeight()
		}, center, radius)
	end

	if not isVisible then
		widget:hide()

		return
	end

	widget:show()

	if icon >= MAPMARK_GUILD_WAR_TOWER_UNCLAIMED and icon <= MAPMARK_GUILD_WAR_FLAG_OTHERS or icon == MAPMARK_PLAYER then
		widget:raise()
	end
end

function updateFloorChangeFlags(index)
	if updatingFloorChangeFlags and not index then
		if floorChangeUpdateEvent then
			removeEvent(floorChangeUpdateEvent)
		end

		floorChangeUpdateEvent = scheduleEvent(function()
			updateFloorChangeFlags()
		end, 10)

		return
	end

	updatingFloorChangeFlags = true

	local startTime = g_clock.millis()
	local player = g_game.getLocalPlayer()

	if not player then
		updatingFloorChangeFlags = false

		return
	end

	local playerPos = player:getPosition()

	if not playerPos then
		updatingFloorChangeFlags = false

		return
	end

	local max = #floorChangeFlags

	index = index or 1
	totalVisible = totalVisible or 0

	while index <= max and g_clock.millis() - startTime < 1 do
		updateFlag(floorChangeFlags[index], playerPos)

		index = index + 1
	end

	if index < max then
		scheduleEvent(function()
			updateFloorChangeFlags(index)
		end, 1)
	else
		updatingFloorChangeFlags = false
	end
end

function updateMapFlags()
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local playerPos = player:getPosition()

	if not playerPos then
		return
	end

	updateFloorChangeFlags()

	local occupiedFlags = {}

	for key, icons in pairs(minimapFlags) do
		for icon, descriptions in pairs(icons) do
			for description, flag in pairs(descriptions) do
				if icon ~= MAPMARK_PLAYER then
					if not flag.position or not Position.isInRange(flag.position, playerPos, MAX_VISIBLE_RANGE, MAX_VISIBLE_RANGE) then
						flag:destroy()

						minimapFlags[key][icon][description] = nil
					else
						local hash = Position.generateHash(flag.position)

						occupiedFlags[hash] = occupiedFlags[hash] or {}
						occupiedFlags[hash][icon] = occupiedFlags[hash][icon] or {}
						occupiedFlags[hash][icon][description or 1] = true

						updateFlag(flag, playerPos)
					end
				end
			end
		end
	end

	for _, widget in pairs(g_worldMap.flags) do
		if widget.position and Position.isInRange(widget.position, playerPos, MAX_VISIBLE_RANGE, MAX_VISIBLE_RANGE) then
			local hash = Position.generateHash(widget.position)

			if not occupiedFlags[hash] or not occupiedFlags[hash][widget.icon] or not occupiedFlags[hash][widget.icon][widget.description or 1] then
				processWorldMapFlag(widget)
			end
		end
	end

	for _, widget in pairs(g_worldMap.questFlags) do
		if widget.position and Position.isInRange(widget.position, playerPos, MAX_VISIBLE_RANGE, MAX_VISIBLE_RANGE) then
			local hash = Position.generateHash(widget.position)

			if not occupiedFlags[hash] or not occupiedFlags[hash][widget.icon] or not occupiedFlags[hash][widget.icon][widget.description or 1] then
				processWorldMapFlag(widget)
			end
		end
	end

	for _, widget in pairs(g_worldMap.compassHighlights) do
		if widget.position and Position.isInRange(widget.position, playerPos, MAX_VISIBLE_RANGE, MAX_VISIBLE_RANGE) then
			local hash = Position.generateHash(widget.position)

			if not occupiedFlags[hash] or not occupiedFlags[hash][widget.icon] or not occupiedFlags[hash][widget.icon][widget.description or 1] then
				processWorldMapFlag(widget)
			end
		end
	end

	local customMapOffset = g_worldMap.getCustomMapPositionOffset(playerPos)

	playerPos.x = playerPos.x - customMapOffset.x
	playerPos.y = playerPos.y - customMapOffset.y

	for _, flags in pairs({
		tradepackPlayerFlags,
		skullPlayerFlags
	}) do
		for _, widget in pairs(flags) do
			if widget.position then
				updateFlag(widget, playerPos)
			end
		end
	end
end

function updateRegionName(region, color)
	minimapWindow.topPanel.regionName:setVisible(region ~= "")
	minimapWindow.topPanel.regionName:setText(region)
	minimapWindow.topPanel.regionName:setColor(color)
end

function getRegionName()
	return minimapWindow.topPanel.regionName:getText()
end

function updateWindDirection()
	local player = g_game.getLocalPlayer()

	if not player or not player:isInShip() then
		minimapWindow.iconWind:hide()

		return
	end

	if not player:isInTutorialArea() then
		local direction = player:getDirection()

		if g_ships.windDirection == direction then
			minimapWindow.iconWind:setColor("green")
		else
			minimapWindow.iconWind:setColor("white")
		end
	else
		minimapWindow.iconWind:setColor("white")
	end

	g_ships.windDirection = g_ships.windDirection and g_ships.windDirection ~= Directions.Invalid and g_ships.windDirection or player:getWindDirection()

	minimapWindow.iconWind:setText(directionAbbr[g_ships.windDirection])
	minimapWindow.iconWind:show()
end

function toggleMinimapButton(id, value)
	local button = minimapWindow:recursiveGetChildById(id)

	if button then
		button:setOn(value)
	end
end

function getMinimapButton(id)
	return minimapWindow:recursiveGetChildById(id)
end

function updateTime(time)
	local pm = time.hour - 12 >= 0
	local hour = time.hour % 12 or 12

	if time.hour == 12 then
		hour = hour + 12
	end

	minimapWindow.topPanel.time:setText(string.format("%02.f:%02.f %s", hour, time.minute, pm and "PM" or "AM"))
end

function removeFlag(pos, icon, description)
	local flag = getFlag(pos, icon, description, true)

	if flag then
		flag:destroy()

		flag = nil
	end
end

function getFlag(pos, icon, description, pop)
	if not pos then
		return
	end

	local key = Position.generateHash(pos)
	local flag = minimapFlags[key] and minimapFlags[key][icon] and minimapFlags[key][icon][description or 1]

	if not flag then
		return nil
	end

	if pop then
		minimapFlags[key][icon][description or 1] = nil
	end

	return flag
end

function addFlag(widget, usePassedWidget)
	if not widget or not widget.position then
		return
	end

	local key = Position.generateHash(widget.position)

	minimapFlags[key] = minimapFlags[key] or {}
	minimapFlags[key][widget.icon] = minimapFlags[key][widget.icon] or {}

	local flag = minimapFlags[key][widget.icon][widget.tooltip or 1]

	if not flag then
		flag = usePassedWidget and widget or g_ui.createWidget("WorldMapIcon", minimapWindow.image)
		flag.icon = widget.icon
		flag.position = widget.position
		flag.region = widget.region

		flag:setTooltip(widget:getTooltip())

		flag.profession = widget.profession
		flag.compassSize = widget.compassSize
		flag.cullingSpawn = widget.cullingSpawn
		minimapFlags[key][widget.icon][widget.tooltip] = flag

		updateFlagPosition(widget.position, widget.position, flag.icon, flag.tooltip)
	end
end

function updateTradepackPlayerFlag(pid, position)
	local flag = tradepackPlayerFlags[pid]

	if not flag then
		flag = g_ui.createWidget("WorldMapIcon", minimapWindow.image)
		flag.icon = MAPMARK_TRADEPACK
		flag.position = position
		flag.profession = ProfessionNone
		tradepackPlayerFlags[pid] = flag

		function flag.onDestroy()
			tradepackPlayerFlags[pid] = nil
		end
	else
		flag.position = position
	end

	updateFlagPosition(flag.position, flag.position, flag.icon)
	updateMapFlags()
end

function updateSkullPlayerFlag(pid, position)
	local flag = skullPlayerFlags[pid]

	if not flag then
		flag = g_ui.createWidget("WorldMapIcon", minimapWindow.image)
		flag.icon = MAPMARK_MURDERER
		flag.position = position
		flag.profession = ProfessionNone
		skullPlayerFlags[pid] = flag

		function flag.onDestroy()
			skullPlayerFlags[pid] = nil
		end
	else
		flag.position = position
	end

	updateFlagPosition(flag.position, flag.position, flag.icon)
	updateMapFlags()
end

function updateFlagPosition(oldPos, newPos, icon, description)
	newPos = newPos or oldPos

	local player = g_game.getLocalPlayer()

	if not player then
		return false
	end

	local widget = getFlag(oldPos, icon, description)

	if not widget or not widget.position then
		return false
	end

	local customMapOffset = g_worldMap.getCustomMapPositionOffset(newPos)

	widget.position = {
		x = newPos.x - customMapOffset.x,
		y = newPos.y - customMapOffset.y,
		z = newPos.z
	}

	local imageWidth = minimapWindow.image:getImageTextureWidth()
	local imageHeight = minimapWindow.image:getImageTextureHeight()
	local areaWidth = g_worldMap.area.toX - g_worldMap.area.fromX
	local areaHeight = g_worldMap.area.toY - g_worldMap.area.fromY
	local x = math.floor(imageWidth * (widget.position.x - g_worldMap.area.fromX) / areaWidth)
	local y = math.floor(imageHeight * (widget.position.y - g_worldMap.area.fromY) / areaHeight)
	local playerPos = player:getPosition()
	local playerOffset = g_worldMap.getCustomMapPositionOffset(playerPos)
	local adjustedPlayerX = playerPos.x - playerOffset.x
	local adjustedPlayerY = playerPos.y - playerOffset.y
	local px = math.floor(imageWidth * (adjustedPlayerX - g_worldMap.area.fromX) / areaWidth)
	local py = math.floor(imageHeight * (adjustedPlayerY - g_worldMap.area.fromY) / areaHeight)
	local width = minimapWindow.image:getWidth()
	local radius = width / 2
	local zoomFactor = zoom / radius
	local marginTop = radius - widget:getHeight() / 2 - (py - y) / zoomFactor + (widget.additionalMarginTop or 0)
	local marginLeft = radius - widget:getWidth() / 2 - (px - x) / zoomFactor + (widget.additionalMarginLeft or 0)

	widget:setMarginTop(marginTop)
	widget:setMarginLeft(marginLeft)

	if not Position.equals(newPos, oldPos) then
		local oldKey = Position.generateHash(oldPos)
		local newKey = Position.generateHash(newPos)

		if minimapFlags[oldKey] and minimapFlags[oldKey][icon] then
			minimapFlags[oldKey][icon][description or 1] = nil
		end

		minimapFlags[newKey] = minimapFlags[newKey] or {}
		minimapFlags[newKey][icon] = minimapFlags[newKey][icon] or {}
		minimapFlags[newKey][icon][description or 1] = widget
	end

	if widget.hidden then
		widget:hide()

		return true
	end

	local center = {
		x = minimapWindow.border:getX() + minimapWindow.border:getWidth() / 2,
		y = minimapWindow.border:getY() + minimapWindow.border:getHeight() / 2
	}
	local isVisible = false

	if icon == MAPMARK_COMPASS then
		local flagCenter = {
			x = widget:getX() + halfWidgetWidth,
			y = widget:getY() + halfWidgetHeight
		}
		local flagRadius = widget:getHeight() / 2

		isVisible = isCircleWithinCircle({
			center = flagCenter,
			radius = flagRadius
		}, {
			center = center,
			radius = radius
		})
	else
		local rect = {
			x = widget:getX(),
			y = widget:getY(),
			width = widget:getWidth(),
			height = widget:getHeight()
		}

		isVisible = isRectWithinCircle(rect, center, radius)
	end

	if isVisible then
		widget:show()

		if widget.icon >= MAPMARK_GUILD_WAR_TOWER_UNCLAIMED and widget.icon <= MAPMARK_GUILD_WAR_FLAG_OTHERS or widget.icon == MAPMARK_PLAYER then
			widget:raise()
		end
	else
		widget:hide()
	end

	return true
end

function hide()
	if g_game.isInArenaMode() then
		minimapWindow:hide()
	end
end

function show()
	if not g_game.isInArenaMode() then
		minimapWindow:show()
	end
end

function getButton(id)
	return buttons[id] or minimapWindow:recursiveGetChildById(id)
end

function updateChannelInfo(info)
	info = info or G.lastChannelInfo

	if not info then
		return
	end

	G.lastChannelInfo = info

	local channelSwitchButton = getButton("channelSwitchButton")
	local hideCurrentChannel = modules.game_settings.getOption("hideCurrentChannel")

	if hideCurrentChannel then
		channelSwitchButton:setText("#")

		return
	end

	for _, channel in pairs(info) do
		if channel.id == G.currentChannelId then
			if bit.band(channel.flags, CHANNEL_FLAG_WARMODE) == CHANNEL_FLAG_WARMODE then
				channelSwitchButton:setText("W")

				break
			end

			if bit.band(channel.flags, CHANNEL_FLAG_PLUNDERMODE) == CHANNEL_FLAG_PLUNDERMODE then
				channelSwitchButton:setText("P")

				break
			end

			channelSwitchButton:setText("N")

			break
		end
	end
end

function UIWidget:setAnglePosition(parent, angle, additionalDistance)
	local parentWidth = parent:getWidth()
	local parentHeight = parent:getHeight()
	local parentPos = parent:getPosition()
	local parentCenter = {
		x = parentPos.x + parentWidth / 2,
		y = parentPos.y + parentHeight / 2
	}
	local parentRadius = parentWidth / 2 + (additionalDistance or 0) + 5

	self.additionalDistance = additionalDistance
	self.angle = angle

	local angle = math.rad(angle)
	local x = parentCenter.x + parentRadius * math.cos(angle)
	local y = parentCenter.y + parentRadius * math.sin(angle)
	local selfWidth = self:getWidth()
	local selfHeight = self:getHeight()

	self:setPosition({
		x = x - selfWidth / 2,
		y = y - selfHeight / 2
	})

	if self.positionChangeAngleEvent then
		for _, event in pairs(self.positionChangeAngleEvent) do
			event()
		end

		self.positionChangeAngleEvent = nil
	end

	local disconnects = connect(parent, {
		onGeometryChange = function()
			addEvent(function()
				self:setAnglePosition(parent, self.angle, self.additionalDistance)
			end)
		end
	})

	self.positionChangeAngleEvent = disconnects
end

function onMinimapButtonDragEnter(widget, mousePos)
	local minimapPos = minimapWindow.image:getPosition()
	local minimapCenter = {
		x = minimapPos.x + minimapWindow.image:getWidth() / 2,
		y = minimapPos.y + minimapWindow.image:getHeight() / 2
	}
	local angle = math.deg(math.atan2(mousePos.y - minimapCenter.y, mousePos.x - minimapCenter.x))

	widget:setAnglePosition(minimapWindow.image, angle, widget.additionalDistance)
	widget:raise()
end

function onPvpModeChange()
	local pvpMode = g_game.getPVPMode()
	local pvpButtonCfg = pvpButtons[pvpMode]

	if not pvpButtonCfg then
		return
	end

	local popupButton = safeModeButtonPopup or minimapWindow:recursiveGetChildById("safeModeButtonPopup")
	local minimapButton = getButton("safeModeButton")

	minimapButton:setTooltip(string.format("PvP Mode: %s", pvpButtonCfg[1].tooltip))
	minimapButton:setImageSource(string.format("/images/ui/windows/minimap/%s", pvpButtonCfg[1].background))
	minimapButton:setIcon(string.format("/images/ui/windows/minimap/%s", pvpButtonCfg[1].icon))
	minimapButton:setIconColor(pvpButtonCfg[1].color)

	local firstButton = popupButton:getChildByIndex(1)

	firstButton:setTooltip(string.format("%s", pvpButtonCfg[2].tooltip))
	firstButton:setId(pvpButtonCfg[2].id)
	firstButton:setIcon(string.format("/images/ui/windows/minimap/%s", pvpButtonCfg[2].icon))

	local secondButton = popupButton:getChildByIndex(2)

	secondButton:setTooltip(string.format("%s", pvpButtonCfg[3].tooltip))
	secondButton:setId(pvpButtonCfg[3].id)
	secondButton:setIcon(string.format("/images/ui/windows/minimap/%s", pvpButtonCfg[3].icon))
end

function onPvpButtonClicked(id)
	local pvpMode = pvpModes[id]

	if pvpMode then
		g_game.setPVPMode(pvpMode)
	end

	local minimapButton = getButton("safeModeButton")

	if minimapButton then
		minimapButton:setOn(false)
	end
end

function selectNextPvpMode()
	local pvpMode = g_game.getPVPMode()
	local nextPvpMode = nextPvpModes[pvpMode]

	if not nextPvpMode then
		return
	end

	g_game.setPVPMode(nextPvpMode)

	local minimapButton = getButton("safeModeButton")

	if minimapButton then
		minimapButton:setOn(false)
	end
end

function addFloorChangeFlag(pos, dir)
	local flag = getFlagFromPool()

	flag.icon = MAPMARK_FLOOR_CHANGE
	flag.position = pos
	flag.direction = dir
	flag.additionalMarginTop = getFlagIconMargin(flag.icon, {
		top = -1
	}).top
	flag.additionalMarginLeft = getFlagIconMargin(flag.icon, {
		left = -1
	}).left

	return flag
end

function onFloorChange(newPos, oldPos)
	if floorIndicatorMode == FLOOR_INDICATOR_MODE_DISABLED then
		for i = 1, #floorChangeFlags do
			local flag = floorChangeFlags[i]

			if flag then
				returnFlagToPool(flag)

				floorChangeFlags[i] = nil
			end
		end

		updateMapFlags()

		return
	end

	if floorIndicatorMode == FLOOR_INDICATOR_MODE_UNDERGROUND and newPos.z <= 7 then
		for i = 1, #floorChangeFlags do
			local flag = floorChangeFlags[i]

			if flag then
				returnFlagToPool(flag)

				floorChangeFlags[i] = nil
			end
		end

		updateMapFlags()

		return
	end

	local flags = floorChangeFlags
	local newFlags = FLOOR_CHANGE_POS[newPos.z]

	if not oldPos or newPos.z ~= oldPos.z then
		for i = 1, #flags do
			local flag = flags[i]

			if flag then
				returnFlagToPool(flag)

				flags[i] = nil
			end
		end

		if newFlags then
			for _, newFlag in ipairs(newFlags) do
				if Position.isInRange(newFlag.pos, newPos, MAX_VISIBLE_FLOOR_CHANGE_RANGE, MAX_VISIBLE_FLOOR_CHANGE_RANGE) then
					local flag = addFloorChangeFlag(newFlag.pos, newFlag.direction)

					table.insert(flags, flag)
				end
			end
		end

		updateMapFlags()

		return
	end

	if not newFlags then
		return
	end

	for i = #flags, 1, -1 do
		local flag = flags[i]

		if flag and flag.position and not Position.isInRange(flag.position, newPos, MAX_VISIBLE_FLOOR_CHANGE_RANGE, MAX_VISIBLE_FLOOR_CHANGE_RANGE) then
			returnFlagToPool(flag)
			table.remove(flags, i)
		end
	end

	local existingFlagPositions = {}

	for _, flag in ipairs(flags) do
		if flag and flag.position then
			local posHash = Position.generateHash(flag.position)

			existingFlagPositions[posHash] = true
		end
	end

	local newVisibleFlags = {}

	for _, newFlag in ipairs(newFlags) do
		local posHash = Position.generateHash(newFlag.pos)

		if Position.isInRange(newFlag.pos, newPos, MAX_VISIBLE_FLOOR_CHANGE_RANGE, MAX_VISIBLE_FLOOR_CHANGE_RANGE) and not existingFlagPositions[posHash] then
			table.insert(newVisibleFlags, newFlag)
		end
	end

	if #newVisibleFlags > 0 then
		addNewFlags(#flags + 1, #flags + #newVisibleFlags, newVisibleFlags)
	end
end

function addNewFlags(startIndex, endIndex, newFlags)
	local startTime = g_clock.millis()
	local batchSize = 10
	local currentIndex = startIndex
	local flagIndex = 1

	while currentIndex <= endIndex and g_clock.millis() - startTime < 1 do
		local endBatch = math.min(currentIndex + batchSize - 1, endIndex)

		for i = currentIndex, endBatch do
			local newFlag = newFlags[flagIndex]

			if newFlag then
				local flag = addFloorChangeFlag(newFlag.pos, newFlag.direction)

				floorChangeFlags[i] = flag
				flagIndex = flagIndex + 1
			end
		end

		currentIndex = endBatch + 1
	end

	if currentIndex <= endIndex then
		scheduleEvent(function()
			addNewFlags(currentIndex, endIndex, newFlags)
		end, 1)
	else
		updateMapFlags()
	end
end

function cleanupFlagPool()
	local maxPoolSize = 100

	while maxPoolSize < #flagPool do
		local flag = table.remove(flagPool)

		flag:destroy()
	end

	scheduleEvent(cleanupFlagPool, POOL_CLEANUP_INTERVAL)
end

function onFloorIndicatorButtonClicked(id)
	modules.game_settings.GameSettings:setScreenOption("floorIndicatorMode", tonumber(id))
end

function onFloorIndicatorDisplayChange(mode)
	local popupButton = minimapWindow:recursiveGetChildById("floorIndicatorButtonPopup")
	local buttonCfg = floorIndicatorButtons[mode]

	if not buttonCfg then
		return
	end

	local minimapButton = minimapWindow:recursiveGetChildById("floorIndicatorButton")

	minimapButton:setTooltip(string.format("Floor Change Indicators: %s", buttonCfg[1].tooltip))
	minimapButton:setImageSource(string.format("/images/ui/windows/minimap/%s", buttonCfg[1].background))
	minimapButton:setIcon(string.format("/images/ui/windows/minimap/%s", buttonCfg[1].icon))
	minimapButton:setIconColor(buttonCfg[1].color)

	local firstButton = popupButton:getChildByIndex(1)

	firstButton:setTooltip(string.format("%s", buttonCfg[2].tooltip))
	firstButton:setId(buttonCfg[2].id)
	firstButton:setIcon(string.format("/images/ui/windows/minimap/%s", buttonCfg[2].icon))

	local secondButton = popupButton:getChildByIndex(2)

	secondButton:setTooltip(string.format("%s", buttonCfg[3].tooltip))
	secondButton:setId(buttonCfg[3].id)
	secondButton:setIcon(string.format("/images/ui/windows/minimap/%s", buttonCfg[3].icon))
end

function getNextFloorIndicatorMode()
	local mode = tonumber(g_settings.get("floorIndicatorMode")) or 1
	local nextMode = nextFloorIndicatorModes[mode]

	if not nextMode then
		print("no next floor indicator mode for " .. mode)

		return
	end

	return nextMode
end

function setFloorIndicatorMode(mode)
	g_settings.set("floorIndicatorMode", mode)
	g_settings.save()
	onFloorIndicatorDisplayChange(mode)
	modules.game_settings.GameSettings:setScreenOption("floorIndicatorMode", mode, true)

	floorIndicatorMode = mode

	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local pos = player:getPosition()

	if not pos then
		return
	end

	onFloorChange(pos, pos)
end
