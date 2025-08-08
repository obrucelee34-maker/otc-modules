-- chunkname: @/modules/game_walking/walking.lua

wsadWalking = false
nextWalkDir = nil
lastWalkDir = nil
lastFinishedStep = 0
autoWalkEvent = nil
firstStep = true
walkEvent = nil
walkLock = 0
lastWalk = 0
lastTurn = 0
lastTurnDirection = 0
lastStop = 0
lastManualWalk = 0
autoFinishNextServerWalk = 0
turnKeys = {}
walkPossible = true

local wasServerWalking = false

function init()
	connect(LocalPlayer, {
		onPositionChange = onPositionChange,
		onWalk = onWalk,
		onWalkFinish = onWalkFinish
	})
end

function terminate()
	disconnect(LocalPlayer, {
		onPositionChange = onPositionChange,
		onWalk = onWalk,
		onWalkFinish = onWalkFinish
	})
	removeEvent(autoWalkEvent)
end

function stopSmartWalk()
	smartWalkDirs = {}
	smartWalkDir = nil
end

function isWalkKeyPressed(dir)
	return DIRECTION_TO_HOTKEY_ID[dir] and GameHotkeyManager:isHotkeyPressed(DIRECTION_TO_HOTKEY_ID[dir], true)
end

function smartWalk(dir, ticks)
	if g_game.isPlacingHouse() or g_game.isMovingHouse() then
		local interface = modules.game_interface
		local mapPanel = interface.getMapPanel()

		if mapPanel.houseTile then
			interface.changeHousePlacingDirection(dir)

			return false
		elseif mapPanel.decorTile then
			interface.changeDecorPlacingDirection(dir)

			return false
		end
	end

	if g_game.isPlacingHouseRoom() then
		modules.game_interface.changeRoomPlacingDirection(dir)

		return false
	end

	if not walkPossible then
		return false
	end

	local smartWalkDir

	if modules.game_settings.getOption("smartWalk") then
		local up = isWalkKeyPressed(North)
		local down = isWalkKeyPressed(South)
		local left = isWalkKeyPressed(West)
		local right = isWalkKeyPressed(East)

		if up and right then
			smartWalkDir = NorthEast
		elseif up and left then
			smartWalkDir = NorthWest
		elseif down and right then
			smartWalkDir = SouthEast
		elseif down and left then
			smartWalkDir = SouthWest
		end
	end

	walk(smartWalkDir or dir, ticks)

	return true
end

function canChangeFloorDown(pos)
	pos.z = pos.z + 1
	toTile = g_map.getTile(pos)

	return toTile and toTile:hasElevation(3)
end

function canChangeFloorUp(pos)
	pos.z = pos.z - 1
	toTile = g_map.getTile(pos)

	return toTile and toTile:isWalkable()
end

function onPositionChange(player, newPos, oldPos)
	if not newPos or not oldPos then
		return
	end

	if newPos.z ~= oldPos.z then
		onTeleport(player, newPos, oldPos)
	end
end

function onWalk(player, newPos, oldPos)
	if autoFinishNextServerWalk + 200 > g_clock.millis() then
		player:finishServerWalking()
	end
end

function onTeleport(player, newPos, oldPos)
	if not newPos or not oldPos then
		return
	end

	if math.abs(newPos.x - oldPos.x) >= 3 or math.abs(newPos.y - oldPos.y) >= 3 or math.abs(newPos.z - oldPos.z) >= 2 then
		player:lockWalkTimed(math.max(g_settings.getNumber("walkTeleportDelay"), 100))
	else
		player:lockWalkTimed(math.max(g_settings.getNumber("walkStairsDelay"), 100))
	end

	nextWalkDir = nil
end

function onWalkFinish(player)
	lastFinishedStep = g_clock.millis()

	if nextWalkDir ~= nil then
		removeEvent(autoWalkEvent)

		autoWalkEvent = addEvent(function()
			if nextWalkDir ~= nil then
				walk(nextWalkDir, 0)
			end
		end, false)
	end
end

function walk(dir, ticks)
	lastManualWalk = g_clock.millis()

	local player = g_game.getLocalPlayer()

	if not player or g_game.isDead() or player:isDead() or player:isRushing() or player:isJumpingLocked() then
		return
	end

	if player:isServerWalking() then
		wasServerWalking = true
	end

	if wasServerWalking and not player:isServerWalking() then
		wasServerWalking = false

		g_game.stop()
		player:finishServerWalking()

		autoFinishNextServerWalk = g_clock.millis() + 200
	end

	if player:isWalkLocked() then
		nextWalkDir = nil

		return
	end

	if g_game.isInCutsceneMode() then
		nextWalkDir = nil

		return
	end

	if player:isDiagonalWalkLocked() and dir > West then
		if g_game.isInShip() then
			dir = player:getDirection()
		else
			nextWalkDir = nil

			return
		end
	end

	if g_game.isFollowing() then
		g_game.cancelFollow()
	end

	if player:isAutoWalking() and lastStop + 100 < g_clock.millis() then
		lastStop = g_clock.millis()

		player:stopAutoWalk()
		g_game.stop()
	end

	local dash = false
	local ignoredCanWalk = false

	if not g_game.getFeature(GameNewWalking) then
		dash = g_settings.getBoolean("dash", false)
	end

	local ticksToNextWalk = player:getStepTicksLeft()

	if not player:canWalk(dir) then
		if dash then
			ignoredCanWalk = true
		else
			if ticksToNextWalk < 500 and (lastWalkDir ~= dir or ticks == 0) then
				nextWalkDir = dir
			end

			if ticksToNextWalk < 30 and lastFinishedStep + 400 > g_clock.millis() and nextWalkDir == nil then
				nextWalkDir = dir
			end

			return
		end
	end

	if nextWalkDir ~= nil and nextWalkDir ~= lastWalkDir then
		dir = nextWalkDir
	end

	local toPos = player:getPrewalkingPosition(true)

	if not toPos then
		return
	end

	if dir == North then
		toPos.y = toPos.y - 1
	elseif dir == East then
		toPos.x = toPos.x + 1
	elseif dir == South then
		toPos.y = toPos.y + 1
	elseif dir == West then
		toPos.x = toPos.x - 1
	elseif dir == NorthEast then
		toPos.x = toPos.x + 1
		toPos.y = toPos.y - 1
	elseif dir == SouthEast then
		toPos.x = toPos.x + 1
		toPos.y = toPos.y + 1
	elseif dir == SouthWest then
		toPos.x = toPos.x - 1
		toPos.y = toPos.y + 1
	elseif dir == NorthWest then
		toPos.x = toPos.x - 1
		toPos.y = toPos.y - 1
	end

	local toTile = g_map.getTile(toPos)

	if walkLock >= g_clock.millis() and lastWalkDir == dir then
		nextWalkDir = nil

		return
	end

	if firstStep and lastWalkDir == dir and lastWalk + g_settings.getNumber("walkFirstStepDelay") > g_clock.millis() then
		firstStep = false
		walkLock = lastWalk + g_settings.getNumber("walkFirstStepDelay")

		return
	end

	if dash and lastWalkDir == dir and lastWalk + 50 > g_clock.millis() then
		return
	end

	firstStep = not player:isWalking() and lastFinishedStep + 100 < g_clock.millis() and walkLock + 100 < g_clock.millis()

	if player:isServerWalking() and not dash then
		walkLock = walkLock + math.max(g_settings.getNumber("walkFirstStepDelay"), 100)
	end

	nextWalkDir = nil

	removeEvent(autoWalkEvent)

	autoWalkEvent = nil

	local preWalked = false

	if toTile and toTile:isWalkable() then
		if not player:isServerWalking() and not ignoredCanWalk and toTile:isPrewalkable() then
			player:preWalk(dir)

			preWalked = true
		end
	else
		local playerTile = player:getTile()

		if playerTile and playerTile:hasElevation(3) and canChangeFloorUp(toPos) or canChangeFloorDown(toPos) or toTile and toTile:isEmpty() and not toTile:isBlocking() then
			player:lockWalkTimed(100)
		elseif player:isServerWalking() then
			g_game.stop()

			return
		elseif not toTile then
			player:lockWalkTimed(100)
		else
			return
		end
	end

	if player:isServerWalking() and not dash then
		g_game.stop()
		player:finishServerWalking()

		autoFinishNextServerWalk = g_clock.millis() + 200
	end

	g_game.walk(dir, preWalked)

	if not firstStep and lastWalkDir ~= dir then
		walkLock = g_clock.millis() + g_settings.getNumber("walkTurnDelay")
	end

	lastWalkDir = dir
	lastWalk = g_clock.millis()

	return true
end

function turn(dir, repeated)
	local player = g_game.getLocalPlayer()

	if not player or g_game.isInCutsceneMode() or player:isJumpingLocked() or player:isRushing() or player:isWalking() and player:getWalkDirection() == dir and not player:isServerWalking() then
		return
	end

	if g_game.isInShip() then
		local direction = player:getDirection()

		if direction == North or direction == South then
			if dir == North or dir == South then
				return
			end
		elseif (direction == West or direction == East) and (dir == West or dir == East) then
			return
		end
	end

	if not repeated or lastTurn + 100 < g_clock.millis() then
		g_game.turn(dir)

		lastTurn = g_clock.millis()

		if not repeated then
			lastTurn = g_clock.millis() + 50
		end

		lastTurnDirection = dir
		nextWalkDir = nil

		player:lockWalkTimed(g_settings.getNumber("walkCtrlTurnDelay"))
	end
end

function checkTurn()
	for keys, direction in pairs(TURN_KEYS) do
		if g_keyboard.areKeysPressed(keys) then
			turn(direction, false)
		end
	end
end

function setWalking(value)
	walkPossible = value
end

function isWalkingPossible()
	return walkPossible
end
