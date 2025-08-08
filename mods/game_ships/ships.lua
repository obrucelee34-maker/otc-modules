-- chunkname: @/modules/game_ships/ships.lua

local iconNames = {
	[North] = "/images/ui/icons/icon_map_up",
	[South] = "/images/ui/icons/icon_map_down",
	[East] = "/images/ui/icons/icon_map_right",
	[West] = "/images/ui/icons/icon_map_left"
}
local shipTypeIcons = {
	[ShipTypes.Basic] = "/images/ui/icons/ship_basic",
	[ShipTypes.Fishing] = "/images/ui/icons/ship_fishing",
	[ShipTypes.Merchant] = "/images/ui/icons/ship_merchant",
	[ShipTypes.Galleon] = "/images/ui/icons/ship_galleon"
}

g_ships = {}

function g_ships.init()
	g_ships.windWidget = g_ships.createWindIcon(North)
	g_ships.windDirection = nil

	connect(g_game, {
		onGameStart = online,
		onGameEnd = offline
	})
	connect(LocalPlayer, {
		onShipChange = g_ships.onShipChange,
		onWindChange = g_ships.onWindChange,
		onPositionChange = g_ships.onPositionChange,
		onTurn = g_ships.onTurn
	})
	connect(Creature, {
		onShipChange = g_ships.onCreatureShipChange
	})

	if g_game.isOnline() then
		local player = g_game.getLocalPlayer()

		if player then
			modules.game_minimap.updateWindDirection()
		end
	end
end

function g_ships.terminate()
	g_ships.windDirection = nil

	if g_ships.windWidget then
		g_ships.windWidget:destroy()

		g_ships.windWidget = nil
	end

	disconnect(LocalPlayer, {
		onShipChange = g_ships.onShipChange,
		onWindChange = g_ships.onWindChange,
		onPositionChange = g_ships.onPositionChange,
		onTurn = g_ships.onTurn
	})
	disconnect(Creature, {
		onShipChange = g_ships.onCreatureShipChange
	})
	disconnect(g_game, {
		onGameStart = online,
		onGameEnd = offline
	})
end

function online()
	g_ships.windDirection = nil
end

function offline()
	g_ships.windDirection = nil

	g_game.setShip(0)
	AbilityBar.setDefaultState()
end

function g_ships.setShipIcon(creature, ship)
	local shipIcon = shipTypeIcons[ship]

	if shipIcon then
		creature:setShipTypeTexture(shipIcon)
	end
end

function g_ships.onCreatureShipChange(creature, ship)
	g_ships.setShipIcon(creature, ship)
end

function g_ships.onWindChange(player, direction)
	g_ships.windDirection = player:isInShip() and direction or nil

	modules.game_minimap.updateWindDirection()
end

function g_ships.onShipChange(player, ship)
	local battle = modules.game_battle.BattleList

	if not ship or ship == 0 then
		g_ships.windDirection = nil

		modules.game_interface.hideSpellCursor()
		g_mouse.popCursor()

		if not battle.wasHidden then
			battle:show()
		end

		return
	else
		battle.wasHidden = not battle.window:isVisible()

		battle:hide()
		g_ships.setShipIcon(player, ship)
	end

	if not modules.game_walking.isWalkingPossible() then
		modules.game_walking.setWalking(true)
	end

	modules.game_minimap.updateWindDirection()
	modules.game_interface.getLeftPanel():hide()
	modules.game_interface.getRightPanel():hide()
end

function g_ships.onPositionChange(player, newPos, oldPos)
	modules.game_minimap.updateWindDirection()
end

function g_ships.onTurn(player, direction)
	modules.game_minimap.updateWindDirection()
end

function g_ships.processMouseAction(menuPosition, mouseButton, autoWalkPos, lookThing, useThing, creatureThing, attackCreature, backpackItem)
	local keyboardModifiers = g_keyboard.getModifiers()

	if lookThing and keyboardModifiers == KeyboardShiftModifier and (mouseButton == MouseLeftButton or mouseButton == MouseRightButton) then
		g_game.look(lookThing)

		return true
	elseif useThing and keyboardModifiers == KeyboardCtrlModifier and (mouseButton == MouseLeftButton or mouseButton == MouseRightButton) then
		modules.game_interface.createThingMenu(menuPosition, lookThing, useThing, creatureThing)

		return true
	elseif useThing and mouseButton == MouseRightButton then
		local isTradepack = false

		if useThing:getPosition().x ~= 65535 then
			isTradepack = useThing:isTradepack()

			if not isTradepack then
				local tile = g_map.getTile(useThing:getPosition())

				for _, item in ipairs(tile:getItems()) do
					if item:isTradepack() then
						isTradepack = true

						break
					end
				end
			end
		end

		if isTradepack and Position.isInRange(g_game.getLocalPlayer():getPosition(), useThing:getPosition(), 2, 2) then
			local menu = g_ui.createWidget("PopupMenu")

			menu:setGameMenu(true)
			modules.game_interface.addUseMenu(menu, useThing, true)
			menu:display()

			return true
		end

		if useThing and FishingBaitClientIds[useThing:getId()] then
			local menu = g_ui.createWidget("PopupMenu")

			menu:setGameMenu(true)

			if not useThing:isActiveFishingBait() then
				menu:addOption("Set as Fishing Rod Bait", function()
					modules.game_interface.sendOpcode(ExtendedIds.FishFight, {
						action = "select_bait",
						itemUUID = useThing:getUUID()
					})
				end)
			else
				menu:addOption("Remove Fishing Rod Bait", function()
					modules.game_interface.sendOpcode(ExtendedIds.FishFight, {
						action = "remove_bait"
					})
				end)
			end

			menu:display()

			return true
		end

		if useThing and mouseButton == MouseRightButton then
			if useThing:isContainer() then
				g_game.open(useThing)
			elseif useThing:isMultiUse() then
				modules.game_interface.startUseWith(useThing)
			else
				g_game.use(useThing)
			end
		end

		return true
	elseif lookThing and (g_mouse.isPressed(MouseLeftButton) and mouseButton == MouseRightButton or g_mouse.isPressed(MouseRightButton) and mouseButton == MouseLeftButton) then
		g_game.look(lookThing)

		return true
	end

	local player = g_game.getLocalPlayer()

	if not player then
		return false
	end

	if modules.game_settings.getOption("enableMapClick") then
		player:stopAutoWalk()

		if autoWalkPos and keyboardModifiers == KeyboardNoModifier and (mouseButton == MouseLeftButton or mouseButton == MouseTouch2 or mouseButton == MouseTouch3) then
			local autoWalkTile = g_map.getTile(autoWalkPos)

			if autoWalkTile and not autoWalkTile:isWalkable(true) then
				return false
			end

			player:autoWalk(autoWalkPos)

			return true
		end
	end

	return false
end

function g_ships.toggle()
	return
end

function g_ships.createWindIcon(windDirection)
	local widget = g_ui.createWidget("UIWidget")

	widget:setVisible(true)
	widget:setFocusable(false)
	widget:setImageSource(iconNames[windDirection])
	widget:setSize({
		height = 32,
		width = 32
	})
	widget:setImageSize({
		height = 32,
		width = 32
	})
	widget:setImageRect({
		y = -32,
		x = 0,
		height = 32,
		width = 32
	})

	return widget
end

function g_ships.getReverseDirection(dir)
	if dir == North then
		return South
	elseif dir == South then
		return North
	elseif dir == West then
		return East
	elseif dir == East then
		return West
	end

	return dir
end

function g_ships.updateWindIcon(direction)
	if not g_ships.windWidget then
		g_ships.createWindIcon(direction)
	end

	local imageName = iconNames[direction]

	if g_ships.windWidget:getImageSource() ~= imageName then
		g_ships.windWidget:setImageSource(imageName)
	end

	if g_ships.windDirection == direction then
		g_ships.windWidget:setOpacity(0.5)
		g_ships.windWidget:setImageColor("green")
	else
		g_ships.windWidget:setOpacity(1)
		g_ships.windWidget:setImageColor("white")
	end
end
