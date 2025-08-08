-- chunkname: @/modules/game_interface/gameinterface.lua

gameRootPanel = nil
gameMapPanel = nil
gameRightPanel = nil
gameLeftPanel = nil
gameBottomPanel = nil
gameChatPanel = nil
gameMessagePanel = nil
gameWindowPanel = nil
gameHUDPanel = nil
gameFadePanel = nil
gameOverlayPanel = nil
logoutButton = nil
mouseGrabberWidget = nil
countWindow = nil
logoutWindow = nil
adviceWindow = nil
exitWindow = nil
bottomSplitter = nil
limitedZoom = false
currentViewMode = 0
hookedMenuOptions = {
	category = {},
	individual = {}
}
lastUsePosition = nil
centerLabel = nil
centerLabelEvent = nil
countdownLabel = nil
ReplacedThings = {}
mouseAttackCandidate = nil
mouseAttackCandidateIsCustom = nil
gameEscMenu = nil
enemyWidget = g_ui.createWidget("UIWidget")
exchangeGiftPopup = nil
TextEditWidgets = nil

local currentShader = 0
local currentRegion = {}
local shaderFadeEvent, regionNameEvent, shaderQueue, regionNameQueue, regionNameFadeOutEvent, regionTimerEvent
local lastClicked = 0
local fadeEvent

cachedShader = 0
spellCursor = {
	isDirectional = false,
	currentType = "circle",
	size = 1,
	crosshairEventInterval = 100,
	direction = Directions.Invalid,
	circle = {
		originalOffset = {
			x = 175,
			y = 175
		},
		originalSize = {
			height = 320,
			width = 320,
			border = {
				x = 40,
				y = 40
			}
		},
		offset = {
			x = 175,
			y = 175
		},
		size = {
			width = 320,
			height = 320
		}
	},
	rect = {
		originalOffset = {
			x = 0,
			y = 0
		},
		originalSize = {
			height = 96,
			width = 96,
			border = {
				x = 0,
				y = 0
			}
		},
		offset = {
			x = 0,
			y = 0
		},
		size = {
			width = 96,
			height = 96
		}
	}
}
chatPanelSize = {
	width = 200,
	height = 200
}
escMenuButtons = {
	{
		style = "GameEscMenuButtonPremium",
		name = "RavenStore",
		callback = function()
			modules.game_premium_store.GamePremiumStore:open()

			return true
		end
	},
	{
		style = "GameEscMenuButton",
		icon = "icon_settings",
		name = "Settings",
		callback = function()
			modules.game_settings.GameSettings:show()

			return true
		end
	},
	{
		style = "GameEscMenuButton",
		icon = "icon_graphics",
		name = "Graphics",
		callback = function()
			modules.game_settings.GameSettings:show()
			modules.game_settings.GameSettings:selectTab(1)

			return true
		end
	},
	{
		style = "GameEscMenuButton",
		icon = "icon_audio",
		name = "Audio / Language",
		callback = function()
			modules.game_settings.GameSettings:show()
			modules.game_settings.GameSettings:selectTab(2)

			return true
		end
	},
	{
		style = "GameEscMenuButton",
		icon = "icon_windows",
		name = "Windows",
		callback = function()
			modules.game_settings.GameSettings:show()
			modules.game_settings.GameSettings:selectTab(3)

			return true
		end
	},
	{
		style = "GameEscMenuButton",
		icon = "icon_misc",
		name = "Game",
		callback = function()
			modules.game_settings.GameSettings:show()
			modules.game_settings.GameSettings:selectTab(4)

			return true
		end
	},
	{
		style = "GameEscMenuButton",
		icon = "icon_hotkey",
		name = "Hotkeys",
		callback = function()
			modules.game_settings.GameSettings:show()
			modules.game_settings.GameSettings:selectTab(5)

			return true
		end
	},
	{
		style = "GameEscMenuSeparator"
	},
	{
		style = "GameEscMenuButton",
		icon = "icon_feedback",
		name = "Bug Report",
		callback = function()
			modules.game_feedback.show()

			return true
		end
	},
	{
		style = "GameEscMenuButton",
		iconPath = "/images/ui/windows/redeem_rewards/redeem_rewards_icon",
		name = "Redeem Rewards",
		callback = function()
			modules.game_redeem_rewards.GameRedeemRewards:open()

			return true
		end
	},
	{
		style = "GameEscMenuSeparator"
	},
	{
		style = "GameEscMenuButton",
		icon = "icon_logout",
		name = "Logout",
		callback = function()
			modules.game_interface.tryLogout(true)

			return true
		end
	},
	{
		style = "GameEscMenuButton",
		icon = "icon_close",
		name = "Exit Game",
		callback = function()
			modules.game_interface.tryExit()

			return true
		end
	}
}

function sendOpcode(opcode, data)
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(opcode, g_game.serializeTable(data))
	end
end

function clearMouseAttackCandidate(clearCustom)
	if mouseAttackCandidateIsCustom and not clearCustom then
		return
	end

	if mouseAttackCandidate and mouseAttackCandidate ~= g_game.getAttackingCreature() and g_game.getFollowingCreature() ~= mouseAttackCandidate then
		mouseAttackCandidate:setEnemyWidget(nil)

		mouseAttackCandidate = nil
	end
end

function addMouseAttackCandidate(creature, custom)
	local oldMouseAttackCandidate = mouseAttackCandidate

	mouseAttackCandidate = creature
	mouseAttackCandidateIsCustom = custom

	if mouseAttackCandidate and g_game.getAttackingCreature() ~= mouseAttackCandidate and g_game.getFollowingCreature() ~= mouseAttackCandidate then
		local size = math.max(1, mouseAttackCandidate:getThingType():getWidth())
		local newSize = TILE_SIZE * size
		local imageSource = "/images/game/targetselector/white" .. newSize

		enemyWidget:setImageSource(imageSource)
		enemyWidget:setImageColor("yellow")
		mouseAttackCandidate:setEnemyWidget(enemyWidget)
	end

	if oldMouseAttackCandidate and oldMouseAttackCandidate ~= mouseAttackCandidate and oldMouseAttackCandidate ~= g_game.getAttackingCreature() then
		oldMouseAttackCandidate:setEnemyWidget(nil)
	end
end

function updateMouseAttackCandidate()
	local creature = getMouseAttackCandidate()

	if creature then
		addMouseAttackCandidate(creature)
	else
		clearMouseAttackCandidate()
	end
end

function onSpellCursorMove(widget, mousePos, mouseMoved, updatePosition)
	local x = mousePos.x - spellCursor[spellCursor.currentType].offset.x
	local y = mousePos.y - spellCursor[spellCursor.currentType].offset.y
	local pos = {
		x = x,
		y = y
	}

	if spellCursor.widget and (spellCursor.widget:isVisible() or updatePosition) then
		spellCursor.widget:setPosition(pos)
		spellCursor.widget:setWidth(spellCursor[spellCursor.currentType].size.width)
		spellCursor.widget:setHeight(spellCursor[spellCursor.currentType].size.height)
	end
end

function setCrosshairOffset(tileSize, xOffset, yOffset)
	if type(tileSize) == "table" then
		spellCursor.widget:setImageOffsetX(xOffset - tileSize.width * 2)
		spellCursor.widget:setImageOffsetY(yOffset - tileSize.height * 2)
	else
		spellCursor.widget:setImageOffset({
			x = xOffset - tileSize * 2,
			y = yOffset - tileSize * 2
		})
	end
end

function resizeSpellCursor(tileSize, isDirectional, direction)
	local xOffset, yOffset = 16, 16

	if isDirectional then
		local mousePosition = g_window.getMousePosition()

		direction = direction or Directions.Invalid

		if direction == Directions.Invalid then
			local tile = gameMapPanel:getTile(mousePosition)

			if tile then
				direction = getDirectionFromPos(g_game.getLocalPlayer():getPosition(), tile:getPosition())
			end
		end

		if direction == Directions.Invalid then
			return
		end

		if direction == Directions.NorthEast or direction == Directions.SouthEast then
			direction = Directions.East
		elseif direction == Directions.NorthWest or direction == Directions.SouthWest then
			direction = Directions.West
		end

		spellCursor.direction = direction

		local layout = direction == Directions.North or direction == Directions.South and "horizontal" or "vertical"
		local width = layout == "vertical" and tileSize.width * 32 + 4 or tileSize.height * 32 + 16
		local height = layout == "vertical" and tileSize.height * 32 + 16 or tileSize.width * 32 + 4

		xOffset = 18
		yOffset = 22
		spellCursor[spellCursor.currentType].size = {
			width = width,
			height = height
		}
	else
		local originalOffset = spellCursor[spellCursor.currentType].originalSize.border.x
		local originalSize = spellCursor[spellCursor.currentType].originalSize.width - originalOffset
		local newSize = tileSize * 32

		spellCursor[spellCursor.currentType].size = {
			width = newSize,
			height = newSize
		}
	end

	spellCursor.widget:setImageSource(string.format("/images/crosshair/%s/%d", spellCursor.currentType, type(tileSize) == "number" and tileSize or 1))
	spellCursor.widget:setSize(spellCursor[spellCursor.currentType].size)
	setCrosshairOffset(tileSize, xOffset, yOffset)

	spellCursor[spellCursor.currentType].offset = {
		x = spellCursor[spellCursor.currentType].size.width * spellCursor[spellCursor.currentType].originalOffset.x / spellCursor[spellCursor.currentType].originalSize.width,
		y = spellCursor[spellCursor.currentType].size.height * spellCursor[spellCursor.currentType].originalOffset.y / spellCursor[spellCursor.currentType].originalSize.width
	}
end

function onCrosshairMouseWheel(widget, mousePos, direction)
	if spellCursor.direction == Directions.North or spellCursor.direction == Directions.South then
		spellCursor.direction = Directions.East
	else
		spellCursor.direction = Directions.North
	end

	resizeSpellCursor(spellCursor.size, spellCursor.isDirectional, spellCursor.direction)
end

local function getDistanceBetween(p1, p2)
	if not p1 or not p2 or p1.z ~= p2.z then
		return 100
	end

	return math.max(math.abs(p1.x - p2.x), math.abs(p1.y - p2.y))
end

function isSpellCursorInRange(tile)
	local spell = spellCursor.spell and g_spells:getSpell(spellCursor.spell)

	if not spell then
		return true
	end

	if tile then
		local player = g_game.getLocalPlayer()

		if player and getDistanceBetween(player:getPosition(), tile:getPosition()) <= spell.range then
			return true
		end
	end

	return false
end

function showSpellCursor()
	spellCursor.widget:setVisible(true)

	local spell = spellCursor.spell and g_spells:getSpell(spellCursor.spell)
	local range = spell and spell.range or -1

	gameMapPanel:setCrosshair(spellCursor.widget, range, modules.game_settings.getOption("preciseCrosshair"))

	if spellCursor.isDirectional then
		gameMapPanel.onMouseWheel = onCrosshairMouseWheel
	end

	resizeSpellCursor(spellCursor.size, spellCursor.isDirectional, spellCursor.direction)
end

function hideSpellCursor()
	spellCursor.widget:setVisible(false)
	gameMapPanel:setCrosshair(nil)

	gameMapPanel.onMouseWheel = nil
end

function handleCrosshair(ability)
	local spell = g_spells:getSpell(ability)

	if not spell then
		return false
	end

	local quickcastType = spell.quickcastType or ""

	if spellCursor.spell and spellCursor.spell:lower() == spell.name:lower() and quickcastType ~= "disabled" then
		local target = spell.aggressive and g_game.getAttackingCreature() or g_game.getHealingCreature()

		if not target and quickcastType == "banner" then
			target = g_game.getLocalPlayer()
		end

		if target then
			local tile = target:getTile()

			if tile then
				local protocolGame = g_game.getProtocolGame()

				if protocolGame then
					local position = tile:getPosition()

					if position then
						if quickcastType == "banner" then
							local posX, posY, posZ = position.x, position.y, position.z

							for x = 1, -1, -1 do
								for y = 1, -1, -1 do
									local toPosition = {
										x = posX + x,
										y = posY + y,
										z = posZ
									}
									local toTile = g_map.getTile(toPosition)

									if toTile and not toTile:getTopCreature() and toTile:isWalkable() then
										position = toPosition

										break
									end
								end
							end
						end

						local data = {
							spell = spellCursor.spell,
							pos = {
								x = position.x,
								y = position.y,
								z = position.z
							},
							direction = spellCursor.direction
						}

						protocolGame:sendExtendedOpcode(ExtendedIds.Crosshair, g_game.serializeTable(data))
					end
				end

				hideSpellCursor()
				g_mouse.popCursor("target")
				mouseGrabberWidget:ungrabMouse()
				gameMapPanel:blockNextMouseRelease(true)

				spellCursor.spell = nil
				mouseGrabberWidget.onMouseRelease = onMouseGrabberRelease
				mouseGrabberWidget.onTouchRelease = mouseGrabberWidget.onMouseRelease

				return true
			end
		end
	end

	return false
end

local function onCrosshair(protocol, opcode, buffer)
	gameMapPanel:blockNextMouseRelease()

	if opcode ~= ExtendedIds.Crosshair then
		return
	end

	if g_ui.isMouseGrabbed() then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		return
	end

	g_mouse.popCursor("target")
	mouseGrabberWidget:ungrabMouse()

	function mouseGrabberWidget:onMouseRelease(mousePosition, mouseButton)
		if mouseButton == MouseLeftButton then
			local clickedWidget = modules.game_interface.getRootPanel():recursiveGetChildByPos(mousePosition, false, true)

			if clickedWidget then
				local tile = gameMapPanel:getCrosshairTile()

				if not tile then
					if clickedWidget:getId() == "icon" then
						local slot = clickedWidget:getParent()

						if slot and slot.category and slot.index and slot.category == AbilityBarCategorySpell then
							local ability = AbilityBar.getAbilityId(slot.category, slot.index)

							if ability ~= 0 and handleCrosshair(ability) then
								return
							end
						end
					end

					local player = g_game.getLocalPlayer()

					if player then
						tile = gameMapPanel:getTile({
							x = mousePosition.x,
							y = mousePosition.y,
							z = player:getPosition().z
						})
					end
				end

				if tile then
					if not isSpellCursorInRange(tile) then
						GameNotification:displayScreenMessage("The target is too far away!")

						return
					end

					local protocolGame = g_game.getProtocolGame()

					if protocolGame then
						local position = tile:getPosition()

						if position then
							local data = {
								spell = data.spell,
								pos = {
									x = position.x,
									y = position.y,
									z = position.z
								},
								direction = spellCursor.direction
							}

							protocolGame:sendExtendedOpcode(ExtendedIds.Crosshair, g_game.serializeTable(data))
						end
					end
				end
			end
		end

		hideSpellCursor()
		g_mouse.popCursor("target")
		self:ungrabMouse()
		gameMapPanel:blockNextMouseRelease(true)

		spellCursor.spell = nil
		self.onMouseRelease = onMouseGrabberRelease
		self.onTouchRelease = self.onMouseRelease
	end

	mouseGrabberWidget.onTouchRelease = mouseGrabberWidget.onMouseRelease
	spellCursor.currentType = data.type or "circle"
	spellCursor.isDirectional = data.directional or false
	spellCursor.size = data.size or 1
	spellCursor.spell = data.spell

	resizeSpellCursor(data.size, data.directional)
	showSpellCursor()
	mouseGrabberWidget:grabMouse()
	g_mouse.pushCursor("target")
end

local function onFairyLight(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.FairyLight then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		return
	end

	if data.action == "update_light_radius" then
		g_game.setFairyLightIntensity(data.value)
		addEvent(function()
			modules.game_journal.GameJournal:updateArtifactFairyButtons(data.regions)
		end)
	end
end

function init()
	g_ui.importStyle("styles/countwindow")
	g_ui.importStyle("styles/actionkey")
	g_ui.importStyle("styles/escmenu")
	g_ui.importStyle("styles/custompopup")
	ProtocolGame.registerExtendedOpcode(ExtendedIds.Crosshair, onCrosshair)
	ProtocolGame.registerExtendedOpcode(ExtendedIds.FairyLight, onFairyLight)
	connect(g_game, {
		onGameStart = onGameStart,
		onGameEnd = onGameEnd,
		onLoginAdvice = onLoginAdvice,
		onScreenFade = onScreenFade,
		onGroupFlagsChange = onGroupFlagsChange,
		onEquippedItems = resetItemsCache
	}, true)
	connect(g_app, {
		onRun = load,
		onExit = save
	})
	connect(LocalPlayer, {
		onRushOffsetChange = onRushOffsetChange,
		onPositionChange = onPositionChange,
		onViewDisplacementOffsetChange = onViewDisplacementOffsetChange
	})
	connect(Container, {
		onOpen = resetItemsCache,
		onRemoveItem = removeItemFromCache,
		onUpdateItem = updateItemInCache,
		onAddItem = addItemToCache
	}, true)
	connect(g_map, {
		onReplaceThing = onReplaceThing
	})
	connect(Creature, {
		onPositionChange = updateMouseAttackCandidate
	})

	gameRootPanel = g_ui.displayUI("gameinterface")

	gameRootPanel:hide()
	gameRootPanel:lower()

	spellCursor.widget = g_ui.createWidget("UIWidget")

	spellCursor.widget:setImageSource("/images/crosshair/circle/10")
	spellCursor.widget:setPhantom(true)
	spellCursor.widget:setVisible(false)
	spellCursor.widget:setFocusable(false)

	houseModeWidget = g_ui.createWidget("UIWidget")

	houseModeWidget:setImageSource("/images/crosshair/circle/1")
	houseModeWidget:setImageOffset({
		x = 16,
		y = 16
	})
	houseModeWidget:setWidth(32)
	houseModeWidget:setHeight(32)
	houseModeWidget:setPhantom(true)
	houseModeWidget:setVisible(false)
	houseModeWidget:setFocusable(false)

	mouseGrabberWidget = gameRootPanel:getChildById("mouseGrabber")
	mouseGrabberWidget.onMouseRelease = onMouseGrabberRelease
	mouseGrabberWidget.onTouchRelease = mouseGrabberWidget.onMouseRelease
	bottomSplitter = gameRootPanel:getChildById("bottomSplitter")
	gameMapPanel = gameRootPanel:getChildById("gameMapPanel")
	gameRightPanel = gameRootPanel:getChildById("gameRightPanel")
	gameLeftPanel = gameRootPanel:getChildById("gameLeftPanel")
	gameBottomPanel = gameRootPanel:getChildById("gameBottomPanel")
	gameChatPanel = gameRootPanel:getChildById("gameChatPanel")
	gameHUDPanel = gameRootPanel:getChildById("gameHUDPanel")
	gameMessagePanel = gameHUDPanel:getChildById("gameMessagePanel")
	gameWindowPanel = gameRootPanel:getChildById("gameWindowPanel")
	gameFadePanel = gameMapPanel:getChildById("fadePanel")
	gameOverlayPanel = gameRootPanel:getChildById("gameOverlayPanel")

	gameChatPanel:focus()
	connect(gameLeftPanel, {
		onVisibilityChange = onLeftPanelVisibilityChange
	})

	gameChatPanel.onDragEnter = onDragGameChatPanelEnter
	gameChatPanel.onDragLeave = onDragGameChatPanelLeave
	gameChatPanel.onDragMove = onDragGameChatPanelMove

	if gameChatPanel:getHeight() == 0 or gameChatPanel:getWidth() == 0 then
		gameChatPanel:setHeight(chatPanelSize.height)
		gameChatPanel:setWidth(chatPanelSize.width)
	end

	centerLabel = gameRootPanel:getChildById("centerLabel")

	centerLabel:hide()

	countdownLabel = gameRootPanel:getChildById("countdownLabel")

	countdownLabel:hide()

	gameEscMenu = g_ui.createWidget("GameEscMenu", gameHUDPanel)

	gameEscMenu:hide()
	setupEscMenu()
	refreshViewMode()
	connect(rootWidget, {
		onMouseMove = onSpellCursorMove
	})
	connect(gameHUDPanel, {
		onGeometryChange = onHUDPanelResize
	})
	connect(gameMapPanel, {
		onVisibleDimensionChange = function()
			if not g_game.isOnline() then
				return
			end

			addEvent(function()
				if AbilityBar then
					local slot = AbilityBar.getSlotByAbilityId(AbilityBarCategoryShip, 1)

					if slot then
						AbilityBar.setupIcon(slot)
					end
				end
			end)
		end
	})
	g_keyboard.bindKeyPress("PageUp", function()
		if g_game.isInHouseMode() and lastClicked < g_clock.millis() then
			local houseFloor = math.max(gameMapPanel.maxFloors or 0, g_game.getHouseFloor() - 1)

			GameHouse:onUpdateEditingFloor(houseFloor)

			lastClicked = g_clock.millis() + 200
		end
	end, gameMapPanel)
	g_keyboard.bindKeyPress("PageDown", function()
		if g_game.isInHouseMode() and lastClicked < g_clock.millis() then
			local houseFloor = math.max(gameMapPanel.maxFloors or 0, g_game.getHouseFloor() + 1)

			GameHouse:onUpdateEditingFloor(houseFloor)

			lastClicked = g_clock.millis() + 200
		end
	end, gameMapPanel)
	g_keyboard.bindKeyDown("Escape", function()
		if lastClicked < g_clock.millis() then
			lastClicked = g_clock.millis() + 200

			if gameEscMenu:isVisible() then
				gameEscMenu:hide()

				return
			end

			local panels = {
				rootWidget,
				gameMapPanel,
				gameHUDPanel
			}

			for _, panel in ipairs(panels) do
				for _, window in ipairs(panel:getChildren()) do
					if window.onEscape and window:isVisible() then
						return
					end
				end
			end

			if modules.game_chat.GameChat:isActive() then
				return
			end

			gameEscMenu:show()
			gameEscMenu:raise()
		end
	end, gameRootPanel)

	if g_game.isOnline() then
		show()
	end

	gameMapPanel:setAutoRepeatDelay(50)
	gameRootPanel:setAutoRepeatDelay(50)
	rootWidget:setAutoRepeatDelay(50)
end

function getLastUsePosition()
	return lastUsePosition
end

function getButton()
	return logoutButton
end

function setupEscMenu()
	for _, button in ipairs(escMenuButtons) do
		if button.style ~= "GameEscMenuSeparator" then
			local widget = g_ui.createWidget(button.style, gameEscMenu.list)

			widget:setText(button.name)

			if button.icon then
				widget:setIcon("/images/ui/windows/esc_menu/" .. button.icon)
			elseif button.iconPath then
				widget:setIcon(button.iconPath)
			end

			function widget.onClick()
				if button.callback and button.callback() then
					gameEscMenu:hide()
				end
			end
		else
			g_ui.createWidget(button.style, gameEscMenu.list)
		end
	end
end

function terminate()
	hide()
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.Crosshair, onCrosshair)
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.FairyLight, onFairyLight)

	hookedMenuOptions = {
		category = {},
		individual = {}
	}
	markThing = nil

	disconnect(g_game, {
		onGameStart = onGameStart,
		onGameEnd = onGameEnd,
		onLoginAdvice = onLoginAdvice,
		onScreenFade = onScreenFade,
		onGroupFlagsChange = onGroupFlagsChange,
		onEquippedItems = resetItemsCache
	})
	disconnect(LocalPlayer, {
		onRushOffsetChange = onRushOffsetChange,
		onPositionChange = onPositionChange,
		onViewDisplacementOffsetChange = onViewDisplacementOffsetChange
	})
	disconnect(Container, {
		onOpen = resetItemsCache,
		onRemoveItem = removeItemFromCache,
		onUpdateItem = updateItemInCache,
		onAddItem = addItemToCache
	})
	disconnect(Creature, {
		onPositionChange = updateMouseAttackCandidate
	})
	disconnect(gameLeftPanel, {
		onVisibilityChange = onLeftPanelVisibilityChange
	})
	disconnect(gameMapPanel, {
		onGeometryChange = refreshViewMode
	})
	disconnect(g_game, {
		onMapChangeAwareRange = refreshViewMode
	})
	disconnect(rootWidget, {
		onMouseMove = onSpellCursorMove
	})
	disconnect(gameHUDPanel, {
		onGeometryChange = onHUDPanelResize
	})
	disconnect(g_map, {
		onReplaceThing = onReplaceThing
	})

	if logoutButton then
		logoutButton:destroy()

		logoutButton = nil
	end

	if gameEscMenu then
		gameEscMenu:destroy()

		gameEscMenu = nil
	end

	if gameRootPanel then
		gameRootPanel:destroy()

		gameRootPanel = nil
	end

	if spellCursor.widget then
		spellCursor.widget:destroy()
	end

	if houseModeWidget then
		houseModeWidget:destroy()
	end
end

function onGameStart()
	if not TextEditWidgets then
		TextEditWidgets = g_ui.getTextEditWidgets()
	end

	gameMapPanel:focus()
	show()
	g_keyboard.bindKeyDown("Ctrl+Q", function()
		modules.game_interface.tryLogout(true)
	end)

	currentShader = 0

	getMapPanel():setShader(currentShader)

	currentRegion = {
		name = "",
		timer = 0,
		aboutToPvp = false,
		pvp = false
	}

	if g_game.isChangingChannel() then
		modules.game_interface.hideFadePanel(1500)
	end

	local module = g_modules.getModule("game_interactions")

	if module then
		module:load()
	end
end

function onGameEnd()
	hide()
	g_keyboard.unbindKeyDown("Ctrl+Q")
	getMapPanel():cancelShake()
	g_game.setReplacingItems(false)

	savedPositionToReplaceIds = {}

	if Tutorial then
		Tutorial.highlightNpcNames = {}
	end

	ReplacedThings = {}
	gameMapPanel.canDragEnter = nil

	local module = g_modules.getModule("game_interactions")

	if module then
		addEvent(function()
			module:unload()
		end)
	end
end

function show()
	connect(g_app, {
		onClose = tryExit
	})
	modules.client_background.hide()
	gameRootPanel:show()
	gameRootPanel:focus()
	gameMapPanel:followCreature(g_game.getLocalPlayer())
	addEvent(function()
		local player = g_game.getLocalPlayer()

		if not limitedZoom or player and player:isGamemaster() then
			gameMapPanel:setMaxZoomOut(513)
			gameMapPanel:setLimitVisibleRange(false)
		else
			gameMapPanel:setMaxZoomOut(11)
			gameMapPanel:setLimitVisibleRange(true)
		end

		hideFadePanel(1500)
	end)
end

function hide()
	disconnect(g_app, {
		onClose = tryExit
	})

	if logoutWindow then
		logoutWindow:destroy()

		logoutWindow = nil
	end

	if exitWindow then
		exitWindow:destroy()

		exitWindow = nil
	end

	if countWindow then
		countWindow:destroy()

		countWindow = nil
	end

	if not g_game.isChangingChannel() then
		gameRootPanel:hide()
		modules.client_background.show()
	else
		modules.game_interface.showFadePanel(500)
	end
end

function save()
	local settings = {}

	settings.gameChatPanelPos = gameChatPanel:getPosition()
	settings.gameChatPanelWidth = gameChatPanel:getWidth()
	settings.gameChatPanelHeight = gameChatPanel:getHeight()

	if gameChatPanel:getPosition().y + gameChatPanel:getHeight() >= gameChatPanel:getParent():getHeight() - 1 then
		settings.gameChatPanelAnchored = true
	else
		settings.gameChatPanelAnchored = false
	end

	local healthInfoWindow = gameRootPanel:recursiveGetChildById("healthInfoWindow")

	if healthInfoWindow then
		settings.healthInfoWindowPos = healthInfoWindow:getPosition()
		settings.healthInfoWindowWidth = healthInfoWindow:getWidth()
	end

	g_settings.setNode("game_interface", settings)
end

function load()
	local settings = g_settings.getNode("game_interface")

	if settings then
		if settings.gameChatPanelPos then
			gameChatPanel:setPosition(settings.gameChatPanelPos)
		else
			gameChatPanel:addAnchor(AnchorBottom, "parent", AnchorBottom)
		end

		if settings.gameChatPanelWidth then
			gameChatPanel:setWidth(settings.gameChatPanelWidth > 0 and settings.gameChatPanelWidth or chatPanelSize.width)
		end

		if settings.gameChatPanelHeight then
			gameChatPanel:setHeight(settings.gameChatPanelWidth > 0 and settings.gameChatPanelHeight or chatPanelSize.height)
		end

		if settings.gameChatPanelAnchored then
			gameChatPanel:addAnchor(AnchorBottom, "parent", AnchorBottom)
		end

		local healthInfoWindow = gameRootPanel:recursiveGetChildById("healthInfoWindow")

		if healthInfoWindow then
			if settings.healthInfoWindowPos then
				healthInfoWindow:setPosition(settings.healthInfoWindowPos)
			else
				healthInfoWindow:addAnchor(AnchorTop, "parent", AnchorTop)
				healthInfoWindow:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
			end

			if settings.healthInfoWindowWidth and settings.healthInfoWindowWidth >= 150 then
				healthInfoWindow:setWidth(settings.healthInfoWindowWidth)
			else
				healthInfoWindow:setWidth(450)
			end
		else
			resetWindows()
		end
	else
		resetWindows()
	end
end

function resetWindows()
	gameChatPanel:addAnchor(AnchorBottom, "parent", AnchorBottom)

	local healthInfoWindow = gameRootPanel:recursiveGetChildById("healthInfoWindow")

	if healthInfoWindow then
		healthInfoWindow:addAnchor(AnchorTop, "parent", AnchorTop)
		healthInfoWindow:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
		healthInfoWindow:setWidth(450)
	end
end

function onLoginAdvice(message)
	if not adviceWindow then
		adviceWindow = displayInfoBox(tr("For Your Information"), message)

		function adviceWindow.onOk()
			adviceWindow = nil
		end
	end
end

function forceExit()
	g_game.cancelLogin()
	scheduleEvent(exit, 10)

	return true
end

function tryExit()
	if exitWindow then
		return true
	end

	local function exitFunc()
		g_game.logout()
		forceExit()
	end

	local function logoutFunc()
		g_game.logout()
		exitWindow:destroy()

		exitWindow = nil
	end

	local function cancelFunc()
		exitWindow:destroy()

		exitWindow = nil
	end

	exitWindow = displayGeneralBox(tr("Exit Game"), tr("If you shut down the program, your character might stay in the game.\nClick on 'Logout' to ensure that you character leaves the game properly.\nClick on 'Exit' if you want to exit the program without logging out your character."), {
		{
			text = tr("Force Exit"),
			callback = exitFunc
		},
		{
			text = tr("Logout"),
			callback = logoutFunc
		},
		{
			text = tr("Cancel"),
			callback = cancelFunc
		},
		anchor = AnchorHorizontalCenter
	}, logoutFunc, cancelFunc)

	return true
end

function tryLogout(prompt)
	if type(prompt) ~= "boolean" then
		prompt = true
	end

	if not g_game.isOnline() then
		exit()

		return
	end

	if logoutWindow then
		return
	end

	if g_game.isInCutsceneMode() then
		return false
	end

	if g_game.isAetherRiftChannel() then
		modules.game_aether_rift.GameAetherRift:leaveRequest()

		return
	end

	local msg, yesCallback

	if not g_game.isConnectionOk() then
		msg = "Your connection is failing, if you logout now your character will be still online, do you want to force logout?"

		function yesCallback()
			g_game.forceLogout()

			if logoutWindow then
				logoutWindow:destroy()

				logoutWindow = nil
			end
		end
	else
		msg = "Are you sure you want to logout?"

		function yesCallback()
			g_game.logout()

			if logoutWindow then
				logoutWindow:destroy()

				logoutWindow = nil
			end
		end
	end

	local function noCallback()
		logoutWindow:destroy()

		logoutWindow = nil
	end

	if prompt then
		logoutWindow = displayGeneralBox(tr("Logout"), tr(msg), {
			{
				text = tr("Yes"),
				callback = yesCallback
			},
			{
				text = tr("No"),
				callback = noCallback
			},
			anchor = AnchorHorizontalCenter
		}, yesCallback, noCallback)
	else
		yesCallback()
	end
end

function setScreenshotMode(setOn)
	if setOn then
		disconnect(gameMapPanel, {
			onGeometryChange = refreshViewMode
		})
		disconnect(g_game, {
			onMapChangeAwareRange = refreshViewMode
		})
	else
		connect(gameMapPanel, {
			onGeometryChange = refreshViewMode
		})
		connect(g_game, {
			onMapChangeAwareRange = refreshViewMode
		})
	end

	gameMapPanel:setKeepAspectRatio(false)

	if setOn then
		gameMapPanel:fill(nil)
		gameMapPanel:setWidth(962)
		gameMapPanel:setHeight(514)
		gameMapPanel:addAnchor(AnchorTop, "parent", AnchorTop)
		gameMapPanel:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
	else
		gameMapPanel:setWidth(nil)
		gameMapPanel:setHeight(nil)
		gameMapPanel:setMarginTop(0)
		gameMapPanel:breakAnchors()
		gameMapPanel:fill("parent")
	end

	gameMapPanel:setOn(true)
	g_damageNumbers.setScreenshotMode(setOn)
	g_gameTooltip.hide()

	if not modules.game_settings.getOption("hideInterface") then
		modules.game_menu.Menu.toggleInterface(setOn)
	end
end

function addToPanels(uiWidget)
	function uiWidget.onRemoveFromContainer(widget)
		if gameLeftPanel:isOn() then
			if widget:getParent():getId() == "gameRightPanel" then
				if gameLeftPanel:getEmptySpaceHeight() - widget:getHeight() >= 0 then
					widget:setParent(gameLeftPanel)
				end
			elseif widget:getParent():getId() == "gameLeftPanel" and gameRightPanel:getEmptySpaceHeight() - widget:getHeight() >= 0 then
				widget:setParent(gameRightPanel)
			end
		end
	end

	if not gameLeftPanel:isOn() then
		uiWidget:setParent(gameRightPanel)

		return
	end

	if gameRightPanel:getEmptySpaceHeight() - uiWidget:getHeight() >= 0 then
		uiWidget:setParent(gameRightPanel)
	else
		uiWidget:setParent(gameLeftPanel)
	end
end

function onMouseGrabberRelease(self, mousePosition, mouseButton)
	if mouseButton == MouseTouch then
		return
	end

	if selectedThing == nil then
		return false
	end

	if mouseButton == MouseLeftButton then
		local clickedWidget = gameRootPanel:recursiveGetChildByPos(mousePosition, false)

		if clickedWidget and selectedType == "use" then
			lastUsePosition = mousePosition

			onUseWith(clickedWidget, mousePosition)
		end
	end

	if selectedThing:isLandItem() then
		g_game.modifyLand(false)

		gameMapPanel.landTile = nil
		gameMapPanel.landSize = nil

		gameMapPanel:releaseLandTiles()
	elseif selectedThing:isHouseItem() then
		g_game.placeHouse(false)

		gameMapPanel.houseTile = nil
		gameMapPanel.houseModel = nil

		gameMapPanel:releaseHouseTiles()
	end

	selectedThing = nil

	g_mouse.popCursor("target")
	self:ungrabMouse()
	gameMapPanel:blockNextMouseRelease(true)

	return true
end

function onUseWith(clickedWidget, mousePosition)
	if clickedWidget:getClassName() == "UIGameMap" then
		local tile = clickedWidget:getTile(mousePosition)

		if tile then
			if selectedThing:isFluidContainer() then
				g_game.useWith(selectedThing, tile:getTopMultiUseThing(), selectedSubtype)
			else
				g_game.useWith(selectedThing, tile:getTopUseThing(), selectedSubtype)
			end
		end
	elseif clickedWidget:getClassName() == "UIItem" and not clickedWidget:isVirtual() then
		g_game.useWith(selectedThing, clickedWidget:getItem(), selectedSubtype)
	elseif clickedWidget:getClassName() == "UICreatureButton" then
		local creature = clickedWidget:getCreature()

		if creature then
			g_game.useWith(selectedThing, creature, selectedSubtype)
		end
	end
end

function startUseWith(thing, subType)
	gameMapPanel:blockNextMouseRelease()

	if not thing then
		return
	end

	if g_ui.isMouseGrabbed() then
		if selectedThing then
			selectedThing = thing
			selectedType = "use"
		end

		return
	end

	if mouseGrabberWidget.onMouseRelease == nil then
		mouseGrabberWidget.onMouseRelease = onMouseGrabberRelease
		mouseGrabberWidget.onTouchRelease = mouseGrabberWidget.onMouseRelease
	end

	if thing:isLandItem() then
		g_game.modifyLand(true)

		gameMapPanel.landTile = nil
		gameMapPanel.landSize = thing:getLandSize()

		gameMapPanel:onMouseMove(g_window:getMousePosition())
	elseif thing:isHouseItem() then
		g_game.placeHouse(true)

		gameMapPanel.houseTile = nil
		gameMapPanel.houseModel = HOUSE_MODELS[thing:getHouseModel()]

		gameMapPanel:onMouseMove(g_window:getMousePosition())
	end

	selectedType = "use"
	selectedThing = thing
	selectedSubtype = subType or 0

	mouseGrabberWidget:grabMouse()
	g_mouse.pushCursor("target")
end

function isMenuHookCategoryEmpty(category)
	if category then
		for _, opt in pairs(category) do
			if opt then
				return false
			end
		end
	end

	return true
end

function addMenuHook(category, name, callback, condition, shortcut, afterOption)
	local data

	if category then
		data = table.getOrCreate(table.getOrCreate(hookedMenuOptions.category, category, {}), name, {})
	else
		data = table.getOrCreate(hookedMenuOptions.individual, name, {})
	end

	data.callback = callback
	data.condition = condition
	data.shortcut = shortcut
	data.afterOption = afterOption
end

function removeMenuHook(category, name)
	if category then
		if not name then
			hookedMenuOptions.category[category] = nil
		else
			hookedMenuOptions.category[category][name] = nil
		end
	else
		hookedMenuOptions.individual[name] = nil
	end
end

function addUseMenu(menu, useThing, skipTradepackCheck)
	if not useThing or not useThing:isItem() then
		return false
	end

	local localPlayer = g_game.getLocalPlayer()
	local localPosition = localPlayer:getPosition()
	local thingPosition = useThing:getPosition()

	if thingPosition.x == 65535 and thingPosition.y >= 64 and useThing:isItem() and useThing:isStackable() and useThing:getCount() > 1 then
		local bulkUseConfig = BULK_USE_ITEMS[useThing:getId()]

		if bulkUseConfig then
			local limit = math.min(bulkUseConfig.limit, useThing:getCount())
			local amountStr = limit == -1 and "All" or tostring(limit)
			local useOption = bulkUseConfig.optionPrefix or "Use"
			local useTitle = tr("%s %s%s", bulkUseConfig.optionPrefix, useThing:getName(), "s")
			local useDescription = string.format("Are you sure you want to %s |%sx %s|?", useOption:lower(), amountStr, useThing:getName())

			menu:addOption(tr("%s %s", useOption, amountStr), function()
				local confirmBox

				local function noCallback()
					if confirmBox then
						confirmBox:destroy()
					end
				end

				local function yesCallback()
					g_game.useBulk(useThing, limit)
					noCallback()
				end

				confirmBox = displayGeneralBox(tr(useTitle), tr(useDescription), {
					{
						text = tr("Yes"),
						callback = yesCallback
					},
					{
						text = tr("No"),
						callback = noCallback
					},
					anchor = AnchorHorizontalCenter
				}, yesCallback, noCallback, nil, modules.game_interface.getRootPanel())
			end)
		end
	end

	if not Position.isInRange(localPosition, useThing:getPosition(), 1, 1) then
		return
	end

	local upFloorIds = {
		1386,
		3678,
		8599,
		5543,
		22845,
		36086
	}
	local actionUniqueId = ContextMenuUniqueId[useThing:getUniqueId()]
	local actionActionId = ContextMenuActionId[useThing:getActionId()]

	if table.contains(upFloorIds, useThing:getServerId()) then
		menu:addOption(tr("Go upstairs"), function()
			g_game.use(useThing)
		end)
	elseif useThing:getPosition().x == 65535 then
		menu:addOption(tr("Use"), function()
			g_game.use(useThing)
		end)
	elseif actionActionId and actionActionId.quest then
		local tracker = modules.game_questlog

		if tracker and tracker.getQuestWidget(actionActionId.quest) then
			menu:addOption(actionActionId.text, function()
				g_game.use(useThing)
			end)
		end
	elseif actionUniqueId and actionUniqueId.quest then
		local tracker = modules.game_questlog

		if tracker and tracker.getQuestWidget(actionUniqueId.quest) then
			menu:addOption(actionUniqueId.text, function()
				g_game.use(useThing)
			end)
		end
	end

	local isTradepack = useThing:isTradepackItem()
	local isFishpack = useThing:isFishpackItem()
	local culledEyePackItem = useThing:isCulledEyePack() and useThing
	local plunderChestItem = useThing:isPlunderChest() and useThing

	if not isTradepack and not isFishpack and not culledEyePackItem and not plunderChestItem then
		local tile = g_map.getTile(useThing:getPosition())

		for _, item in ipairs(tile:getItems()) do
			if item:isTradepackItem() then
				isTradepack = true

				break
			elseif item:isFishpackItem() then
				isFishpack = true

				break
			elseif item:isCulledEyePack() then
				culledEyePackItem = item

				break
			elseif item:isPlunderChest() then
				plunderChestItem = item

				break
			end
		end
	end

	local range = localPlayer:isInShip() and 2 or 1

	if isFishpack and Position.isInRange(localPosition, useThing:getPosition(), range, range) then
		menu:addOption(tr("Take Fishpack"), function()
			sendOpcode(ExtendedIds.Trading, {
				action = "take_fishpack",
				position = useThing:getPosition()
			})
		end)
	elseif skipTradepackCheck or isTradepack and Position.isInRange(localPosition, useThing:getPosition(), range, range) then
		menu:addOption(tr("Take Tradepack"), function()
			sendOpcode(ExtendedIds.Trading, {
				action = "take_tradepack",
				position = useThing:getPosition()
			})
		end)
	elseif culledEyePackItem and Position.isInRange(localPosition, useThing:getPosition(), range, range) then
		menu:addOption(tr("Take Culled Eyes"), function()
			g_game.use(culledEyePackItem)
		end)
	elseif plunderChestItem and Position.isInRange(localPosition, useThing:getPosition(), range, range) then
		menu:addOption(tr("Take Plunder"), function()
			g_game.use(plunderChestItem)
		end)
	end

	return true
end

function addLookMenu(menu, lookThing)
	if not lookThing then
		return false
	end

	if not lookThing:isCreature() and lookThing:getPosition().x == 65535 then
		menu:addSeparator()
		menu:addOption(tr("Destroy Item"), function()
			removeConfirm(lookThing)
		end)
	end

	local parentContainer = lookThing:getParentContainer()

	if parentContainer and parentContainer:hasParent() then
		menu:addOption(tr("Move up"), function()
			g_game.moveToParentContainer(lookThing, lookThing:getCount())
		end)
	end

	return true
end

function addSelfMenu(menu, creatureThing)
	if not creatureThing:isLocalPlayer() then
		return false
	end

	local localPlayer = g_game.getLocalPlayer()

	if not g_game.isInShip() then
		if not localPlayer:isMounted() then
			if not g_game.isAetherRiftChannel() then
				menu:addOption(tr("Mount"), function()
					sendOpcode(ExtendedIds.Mount, {
						action = "on"
					})
				end)
			end
		elseif not localPlayer:isWagonToggled() then
			menu:addOption(tr("Dismount"), function()
				sendOpcode(ExtendedIds.Mount, {
					action = "off"
				})
			end)
		end

		if not localPlayer:isWagonSummoned() and not localPlayer:isWagonToggled() and not g_game.isAetherRiftChannel() and not g_game.isGuildWarsChannel() then
			menu:addOption(tr("Create Wagon"), function()
				sendOpcode(ExtendedIds.Wagon, {
					action = "create"
				})
			end)
		end

		if localPlayer:isWagonToggled() then
			menu:addOption(tr("Get off Wagon"), function()
				sendOpcode(ExtendedIds.Wagon, {
					action = "off"
				})
			end)
		end
	end

	menu:addOption(tr("Look"), function()
		g_game.look(localPlayer)
	end)

	if creatureThing:isPartyMember() and not g_game.isInArenaMode() and not g_game.isAetherRiftChannel() and not g_game.isGuildWarsChannel() then
		menu:addOption(tr("Leave Party"), function()
			g_game.partyLeave()
		end)
	end

	return true
end

function addOtherPlayerMenu(menu, creatureThing)
	if not creatureThing:isPlayer() then
		return false
	end

	local localPlayer = g_game.getLocalPlayer()

	menu:addSeparator()

	local creatureName = creatureThing:getName()

	if (not localPlayer:isPartyMember() or localPlayer:isPartyLeader()) and not creatureThing:isPartyMember() and not g_game.isAetherRiftChannel() and not g_game.isGuildWarsChannel() then
		menu:addOption(tr("Invite to Party"), function()
			modules.game_social.GameSocial:invitePlayer(creatureName)
		end)
	end

	menu:addOption(tr(string.format("Message to |%s|", creatureName)), function()
		GameChat:whisperPlayer(creatureName)
	end)
	menu:addOption(tr(string.format("Trade with |%s|", creatureName)), function()
		g_game.requestTrade(creatureThing)
	end)
	menu:addOption(tr("Look"), function()
		g_game.look(creatureThing)
	end)

	local localPlayerShield = localPlayer:getShield()
	local creatureShield = creatureThing:getShield()

	if not g_game.isInArenaMode() then
		-- block empty
	end
end

function addWagonMenu(menu, creatureThing)
	local creatureType = creatureThing:getType()

	if creatureType ~= CreatureTypeWagonOwn and creatureType ~= CreatureTypeWagonOther then
		return false
	end

	local localPlayer = g_game.getLocalPlayer()
	local localPosition = localPlayer:getPosition()

	if creatureThing:getPosition().z == localPosition.z and creatureType ~= CreatureTypeWagonOwn then
		if g_game.getAttackingCreature() ~= creatureThing then
			menu:addOption(tr("Attack"), function()
				g_game.attack(creatureThing)
			end)
		else
			menu:addOption(tr("Stop Attack"), function()
				g_game.cancelAttack()
			end)
		end
	end

	if Position.isInRange(localPosition, creatureThing:getPosition(), 3, 3) then
		if creatureType == CreatureTypeWagonOwn then
			if menu:getChildCount() > 0 then
				menu:addSeparator()
			end

			menu:addOption(tr("Get on Wagon"), function()
				sendOpcode(ExtendedIds.Wagon, {
					action = "on"
				})
			end)
			menu:addOption(tr("Remove Wagon"), function()
				sendOpcode(ExtendedIds.Wagon, {
					action = "remove"
				})
			end)
			menu:addOption(tr("Move Packs"), function()
				sendOpcode(ExtendedIds.Trading, {
					type = "wagon",
					action = "move"
				})
			end)
		elseif creatureType == CreatureTypeWagonOther then
			if menu:getChildCount() > 0 then
				menu:addSeparator()
			end

			menu:addOption(tr("Inspect Packs"), function()
				sendOpcode(ExtendedIds.Trading, {
					type = "wagon",
					action = "inspect",
					id = creatureThing:getId()
				})
			end)
		end
	end

	return true
end

function addCreatureMenu(menu, creatureThing)
	if not creatureThing or creatureThing:isHidden() then
		return
	end

	if not addSelfMenu(menu, creatureThing) then
		if not addWagonMenu(menu, creatureThing) then
			local localPlayer = g_game.getLocalPlayer()
			local localPosition = localPlayer:getPosition()

			if creatureThing:getPosition().z == localPosition.z then
				if not creatureThing:isNpc() and not g_game.isInShip() then
					if g_game.getAttackingCreature() ~= creatureThing then
						menu:addOption(tr("Attack"), function()
							g_game.attack(creatureThing)
						end)
					else
						menu:addOption(tr("Stop Attack"), function()
							g_game.cancelAttack()
						end)
					end
				end

				if creatureThing:isPlayer() then
					if g_game.getFollowingCreature() ~= creatureThing then
						menu:addOption(tr("Follow"), function()
							g_game.follow(creatureThing)
						end)
					else
						menu:addOption(tr("Stop Follow"), function()
							g_game.cancelFollow()
						end)
					end

					if not g_game.isInShip() then
						if g_game.getHealingCreature() ~= creatureThing then
							menu:addOption(tr("Heal"), function()
								g_game.heal(creatureThing)
							end)
						else
							menu:addOption(tr("Stop Healing"), function()
								g_game.cancelHealing()
							end)
						end
					end
				end
			end
		end

		addOtherPlayerMenu(menu, creatureThing)
	end

	if #menu:getChildren() >= 1 then
		menu:addSeparator()
	end

	menu:addOption(tr("Copy Name"), function()
		g_window.setClipboardText(creatureThing:getName())
	end)

	if creatureThing:isPlayer() and not creatureThing:isLocalPlayer() then
		local name = creatureThing:getName()
		local social = modules.game_social.GameSocial

		if not social:isIgnored(name) then
			menu:addOption(tr("Ignore Player"), function()
				social:addIgnored(name)
			end)
		else
			menu:addOption(tr("Remove from Ignored List"), function()
				social:removeIgnored(name)
			end)
		end

		menu:addOption(tr("Report Player"), function()
			modules.game_player_report.GamePlayerReport:requestReportWindow(creatureThing:getName())
		end)
	end
end

function createThingMenu(menuPosition, lookThing, useThing, creatureThing, backpackItem)
	if not g_game.isOnline() then
		return
	end

	local menu = g_ui.createWidget("PopupMenu")

	menu:setId("thingMenu")
	menu:setGameMenu(true)

	local classic = modules.game_settings.getOption("classicControl")
	local shortcut

	addUseMenu(menu, useThing)

	if backpackItem then
		menu:addOption(tr("Remove"), function()
			modules.game_backpack.removeConfirm(backpackItem.backpackId, backpackItem)
		end, nil)
	end

	addCreatureMenu(menu, creatureThing)

	local function getAfterOption(afterOption, optionName)
		return type(afterOption) == "function" and function()
			return afterOption(menu, optionName, lookThing, useThing, creatureThing)
		end or afterOption
	end

	for _, category in pairs(hookedMenuOptions.category) do
		local options = {}

		for name, opt in pairs(category) do
			if opt and opt.condition(menuPosition, lookThing, useThing, creatureThing) then
				table.insert(options, {
					name = name,
					callback = function()
						opt.callback(menuPosition, lookThing, useThing, creatureThing)
					end,
					shortcut = opt.shortcut,
					afterOption = getAfterOption(opt.afterOption, name)
				})
			end
		end

		if not table.empty(options) then
			menu:addSeparator()

			for _, opt in ipairs(options) do
				menu:addOption(opt.name, opt.callback, opt.shortcut, nil, nil, opt.afterOption)
			end
		end
	end

	for name, opt in pairs(hookedMenuOptions.individual) do
		if opt and opt.condition(menuPosition, lookThing, useThing, creatureThing) then
			menu:addOption(name, function()
				opt.callback(menuPosition, lookThing, useThing, creatureThing)
			end, opt.shortcut, nil, nil, getAfterOption(opt.afterOption, name))
		end
	end

	local thing = lookThing or useThing or creatureThing

	if thing and string.find(g_app.getCompactName(), "_test") then
		menu:addOption(tr("Copy Position"), function()
			g_window.setClipboardText(string.format("%d, %d, %d", thing:getPosition().x, thing:getPosition().y, thing:getPosition().z))
		end, nil)
	end

	menu:display(menuPosition)
end

function getMouseAttackCandidate()
	if not g_game.isOnline() or g_game.isInCutsceneMode() or g_game.isInShip() or g_game.isInHouseMode() then
		return
	end

	if not gameMapPanel:isHovered() then
		return
	end

	local mousePosition = g_window.getMousePosition()
	local offsets = {
		{
			x = 0,
			y = 0
		},
		{
			x = -1,
			y = -1
		},
		{
			x = 0,
			y = -1
		},
		{
			x = 1,
			y = -1
		},
		{
			x = -1,
			y = 0
		},
		{
			x = 1,
			y = 0
		},
		{
			x = -1,
			y = 1
		},
		{
			x = 0,
			y = 1
		},
		{
			x = 1,
			y = 1
		}
	}
	local pos = gameMapPanel:getPosition(mousePosition)
	local stretchFactor = gameMapPanel:getStretchFactor()

	if pos then
		local tile = g_map.getTile(pos)

		if tile then
			local creatures = {}

			for _, point in ipairs(offsets) do
				local tile = g_map.getTile({
					x = pos.x + point.x,
					y = pos.y + point.y,
					z = pos.z
				})

				if tile then
					local tileCreatures = tile:getCreatures()

					table.insertall(tileCreatures, tile:getWalkingCreatures())

					for _, creature in ipairs(tileCreatures) do
						local thingType = creature:getThingType()

						if thingType and not creature:isHidden() and creature:isInteractable() then
							local width = TILE_SIZE * stretchFactor.x
							local height = TILE_SIZE * stretchFactor.y
							local creatureTopLeftCorner = gameMapPanel:transformPositionTo2D(creature:getPosition())
							local creatureCenter = {
								x = creatureTopLeftCorner.x + width / 2,
								y = creatureTopLeftCorner.y + height / 2
							}
							local distanceX = math.abs(creatureCenter.x - mousePosition.x)
							local distanceY = math.abs(creatureCenter.y - mousePosition.y)

							table.insert(creatures, {
								creature = creature,
								distanceX = distanceX,
								distanceY = distanceY,
								width = width,
								height = height
							})
						end
					end
				end
			end

			table.sort(creatures, function(a, b)
				return a.distanceX < b.distanceX and a.distanceY < b.distanceY
			end)

			for _, creature in ipairs(creatures) do
				if creature.creature ~= g_game.getLocalPlayer() and (not creature.creature:isNpc() and modules.game_settings.getOption("closestTargetRange") or creature.distanceX <= creature.width / 2 and creature.distanceY <= creature.height / 2 or g_map.getTile(creature.creature:getPosition()) == tile) then
					return creature.creature
				end
			end
		end
	end

	return nil
end

function targetAround()
	if mouseAttackCandidate then
		if BGS_DEMO and mouseAttackCandidate == g_game.getAttackingCreature() then
			return true
		end

		g_game.attack(mouseAttackCandidate)
		mouseAttackCandidate:setEnemyWidget(nil)

		return true
	end

	return false
end

function processMouseAction(menuPosition, mouseButton, autoWalkPos, lookThing, useThing, creatureThing, attackCreature, backpackItem)
	local keyboardModifiers = g_keyboard.getModifiers()
	local player = g_game.getLocalPlayer()

	if not player then
		return false
	end

	if g_game.isInCutsceneMode() then
		return false
	end

	if player:isInShip() then
		return g_ships.processMouseAction(menuPosition, mouseButton, autoWalkPos, lookThing, useThing, creatureThing, attackCreature)
	end

	if player:isTrading() and keyboardModifiers == KeyboardNoModifier and mouseButton == MouseRightButton and not g_mouse.isPressed(MouseLeftButton) then
		-- block empty
	elseif modules.game_settings.getOption("closestTargetRange") and keyboardModifiers == KeyboardNoModifier and mouseButton == MouseRightButton and not g_mouse.isPressed(MouseLeftButton) and gameMapPanel:isHovered() and targetAround() then
		return true
	elseif useThing and keyboardModifiers == KeyboardNoModifier and mouseButton == MouseRightButton and not g_mouse.isPressed(MouseLeftButton) then
		local menu = g_ui.createWidget("PopupMenu")

		menu:setGameMenu(true)

		if attackCreature and addWagonMenu(menu, attackCreature) or creatureThing and addWagonMenu(menu, creatureThing) then
			menu:display()

			return true
		elseif attackCreature and not attackCreature:isHidden() and attackCreature ~= player then
			g_game.attack(attackCreature)

			return true
		elseif creatureThing and not creatureThing:isHidden() and creatureThing ~= player and creatureThing:getPosition().z == autoWalkPos.z then
			g_game.attack(creatureThing)

			return true
		elseif useThing:isContainer() then
			if useThing:getParentContainer() then
				g_game.open(useThing, useThing:getParentContainer())

				return true
			else
				g_game.open(useThing)

				return true
			end
		elseif useThing:isMultiUse() then
			startUseWith(useThing)

			return true
		else
			if useThing and useThing:getPosition().x ~= 65535 and mouseButton == MouseRightButton then
				local isTradepack = useThing:isTradepack()

				if not isTradepack then
					local tile = g_map.getTile(useThing:getPosition())

					for _, item in ipairs(tile:getItems()) do
						if item:isTradepack() then
							isTradepack = true

							break
						end
					end
				end

				if isTradepack and Position.isInRange(g_game.getLocalPlayer():getPosition(), useThing:getPosition(), 1, 1) then
					local menu = g_ui.createWidget("PopupMenu")

					menu:setGameMenu(true)
					addUseMenu(menu, useThing, true)
					menu:display()

					return true
				end
			end

			if useThing and table.find(AbilityBarSupportedItemIds, useThing:getId()) then
				local menu = g_ui.createWidget("PopupMenu")

				menu:setGameMenu(true)
				menu:addOption("Add to action bar", function()
					AbilityBar.addItem(useThing:getId())
				end)
				menu:addSeparator()
				menu:addOption("Use", function()
					g_game.use(useThing)
				end)

				g_gameTooltip.disableTooltip = true

				connect(menu, "onDestroy", function()
					g_gameTooltip.disableTooltip = false
				end)
				menu:display()

				return true
			end

			if useThing and FishingBaitClientIds[useThing:getId()] then
				local menu = g_ui.createWidget("PopupMenu")

				menu:setGameMenu(true)

				if not useThing:isActiveFishingBait() then
					menu:addOption("Set as Fishing Rod Bait", function()
						sendOpcode(ExtendedIds.FishFight, {
							action = "select_bait",
							itemUUID = useThing:getUUID()
						})
					end)
				else
					menu:addOption("Remove Fishing Rod Bait", function()
						sendOpcode(ExtendedIds.FishFight, {
							action = "remove_bait"
						})
					end)
				end

				menu:display()

				return true
			end

			if useThing:isReplaced() then
				if type(useThing.onReplacedUse) == "table" then
					for _, func in ipairs(useThing.onReplacedUse) do
						func(useThing, nil, nil, player:isWalking())
					end
				else
					useThing:onReplacedUse(nil, nil, player:isWalking())
				end
			end

			local useThingPos = useThing:getPosition()

			if Position.isMapPosition(useThing:getPosition()) and useThingPos.z ~= player:getPosition().z then
				local tile = g_map.getTile(Position.goDown(useThingPos, player:getPosition().z - useThingPos.z))

				if tile then
					useThing = tile:getTopUseThing()
				else
					return true
				end
			end

			g_game.use(useThing)

			return true
		end

		return true
	elseif lookThing and keyboardModifiers == KeyboardShiftModifier and (mouseButton == MouseLeftButton or mouseButton == MouseRightButton) then
		g_game.look(lookThing)

		return true
	elseif lookThing and (g_mouse.isPressed(MouseLeftButton) and mouseButton == MouseRightButton or g_mouse.isPressed(MouseRightButton) and mouseButton == MouseLeftButton) then
		g_game.look(lookThing)

		return true
	elseif useThing and keyboardModifiers == KeyboardCtrlModifier and (mouseButton == MouseLeftButton or mouseButton == MouseRightButton) then
		createThingMenu(menuPosition, lookThing, useThing, creatureThing)

		return true
	elseif attackCreature and not attackCreature:isHidden() and g_keyboard.isAltPressed() and mouseButton == MouseRightButton then
		g_game.attack(attackCreature)

		return true
	elseif creatureThing and not creatureThing:isHidden() and creatureThing:getPosition().z == autoWalkPos.z and g_keyboard.isAltPressed() and (mouseButton == MouseLeftButton or mouseButton == MouseRightButton) then
		if mouseButton == MouseRightButton then
			g_game.attack(creatureThing)
		elseif mouseButton == MouseLeftButton and creatureThing:isPlayer() then
			g_game.heal(creatureThing)
		end

		return true
	elseif creatureThing and creatureThing:isPlayer() and not creatureThing:isHidden() and keyboardModifiers == KeyboardNoModifier and mouseButton == MouseLeftButton and not g_mouse.isPressed(MouseRightButton) then
		g_game.heal(creatureThing)

		return true
	end

	if autoWalkPos and keyboardModifiers == KeyboardNoModifier and (mouseButton == MouseLeftButton or mouseButton == MouseTouch2 or mouseButton == MouseTouch3) and modules.game_house.GameHouse:checkLandPlotTileDescriptionClick(g_map.getTile(autoWalkPos), menuPosition) then
		return true
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

function moveStackableItem(item, toPos, moveOptions)
	if countWindow then
		return
	end

	if modules.game_settings.getOption("dragStackControl") then
		if g_keyboard.isCtrlPressed() then
			g_game.move(item, toPos, item:getCount(), moveOptions)

			return
		elseif g_keyboard.isShiftPressed() then
			g_game.move(item, toPos, 1, moveOptions)

			return
		end
	elseif g_keyboard.isShiftPressed() then
		g_game.move(item, toPos, 1, moveOptions)

		return
	elseif not g_keyboard.isCtrlPressed() then
		g_game.move(item, toPos, item:getCount(), moveOptions)

		return
	end

	local count = item:getCount()

	countWindow = g_ui.createWidget("CountWindow", rootWidget)

	local itembox = countWindow:getChildById("item")
	local scrollbar = countWindow:getChildById("countScrollBar")

	itembox:setItemId(item:getId())
	itembox:setItemCount(count)
	scrollbar:setMaximum(count)
	scrollbar:setMinimum(1)
	scrollbar:setValue(count)

	local spinbox = countWindow:getChildById("spinBox")

	spinbox:setMaximum(count)
	spinbox:setMinimum(0)
	spinbox:setValue(0)
	spinbox:hideButtons()
	spinbox:focus()

	spinbox.firstEdit = true

	local function spinBoxValueChange(self, value)
		spinbox.firstEdit = false

		scrollbar:setValue(value)
	end

	spinbox.onValueChange = spinBoxValueChange

	local function check()
		if spinbox.firstEdit then
			spinbox:setValue(spinbox:getMaximum())

			spinbox.firstEdit = false
		end
	end

	g_keyboard.bindKeyPress("Up", function()
		check()
		spinbox:up()
	end, spinbox)
	g_keyboard.bindKeyPress("Down", function()
		check()
		spinbox:down()
	end, spinbox)
	g_keyboard.bindKeyPress("Right", function()
		check()
		spinbox:up()
	end, spinbox)
	g_keyboard.bindKeyPress("Left", function()
		check()
		spinbox:down()
	end, spinbox)
	g_keyboard.bindKeyPress("Tab", function()
		check()
		spinbox:setValue(spinbox:getValue() + 10)
	end, spinbox)
	g_keyboard.bindKeyPress("PageUp", function()
		check()
		spinbox:setValue(spinbox:getValue() + 10)
	end, spinbox)
	g_keyboard.bindKeyPress("PageDown", function()
		check()
		spinbox:setValue(spinbox:getValue() - 10)
	end, spinbox)
	g_keyboard.bindKeyPress("Shift+Tab", function()
		check()
		spinbox:setValue(spinbox:getValue() - 10)
	end, spinbox)

	function scrollbar:onValueChange(value)
		itembox:setItemCount(value)

		spinbox.onValueChange = nil

		spinbox:setValue(value)

		spinbox.onValueChange = spinBoxValueChange
	end

	local okButton = countWindow:getChildById("buttonOk")

	local function moveFunc()
		g_game.move(item, toPos, itembox:getItemCount(), moveOptions)
		okButton:getParent():destroy()

		countWindow = nil

		return true
	end

	local cancelButton = countWindow:getChildById("buttonCancel")

	local function cancelFunc()
		cancelButton:getParent():destroy()

		countWindow = nil
	end

	countWindow.onEnter = moveFunc
	countWindow.onEscape = cancelFunc
	okButton.clickSound = true
	okButton.onClick = moveFunc
	cancelButton.clickSound = true
	cancelButton.onClick = cancelFunc

	if g_keyboard.isKeyPressed("Enter") then
		scheduleEvent(moveFunc, 100)
	end
end

function removeConfirm(item)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local deleteDisallowedQualityNames = {
		Tradepack = true,
		["Quest Item"] = true
	}
	local exceptionItemNames = {
		["Culled Eye"] = true
	}

	if (player:getLevel() < 5 or deleteDisallowedQualityNames[item:getQualityName()]) and not exceptionItemNames[item:getName()] then
		return
	end

	if countWindow then
		countWindow:destroy()

		countWindow = nil
	end

	local function yesCallback()
		if countWindow then
			countWindow:destroy()

			countWindow = nil
		end

		if item:getCount() > 1 then
			modules.game_interface.removeStackableItem(item)
		else
			g_game.remove(item)
		end
	end

	local function noCallback()
		if countWindow then
			countWindow:destroy()

			countWindow = nil
		end
	end

	local itemCount = item:getCount()

	countWindow = displayGeneralBox(tr("Destroy Item"), tr(string.format("Are you sure you would like to destroy |%s||%s|? This cannot be undone.", itemCount > 1 and itemCount .. "x " or "", item:getName())), {
		{
			text = tr("Yes"),
			callback = yesCallback
		},
		{
			text = tr("No"),
			callback = noCallback
		},
		anchor = AnchorHorizontalCenter
	}, yesCallback, noCallback)
end

function removeStackableItem(item)
	if countWindow then
		return
	end

	if modules.game_settings.getOption("dragStackControl") then
		if g_keyboard.isCtrlPressed() then
			g_game.remove(item, item:getCount())

			return
		elseif g_keyboard.isShiftPressed() then
			g_game.remove(item, 1)

			return
		end
	elseif g_keyboard.isShiftPressed() then
		g_game.remove(item, 1)

		return
	elseif not g_keyboard.isCtrlPressed() then
		g_game.remove(item, item:getCount())

		return
	end

	local count = item:getCount()

	countWindow = g_ui.createWidget("CountWindow", rootWidget)

	countWindow:setText("Destroy Stackable")

	local itembox = countWindow:getChildById("item")
	local scrollbar = countWindow:getChildById("countScrollBar")

	itembox:setItemId(item:getId())
	itembox:setItemCount(count)
	scrollbar:setMaximum(count)
	scrollbar:setMinimum(1)
	scrollbar:setValue(count)

	local spinbox = countWindow:getChildById("spinBox")

	spinbox:setMaximum(count)
	spinbox:setMinimum(0)
	spinbox:setValue(0)
	spinbox:hideButtons()
	spinbox:focus()

	spinbox.firstEdit = true

	local function spinBoxValueChange(self, value)
		spinbox.firstEdit = false

		scrollbar:setValue(value)
	end

	spinbox.onValueChange = spinBoxValueChange

	local function check()
		if spinbox.firstEdit then
			spinbox:setValue(spinbox:getMaximum())

			spinbox.firstEdit = false
		end
	end

	g_keyboard.bindKeyPress("Up", function()
		check()
		spinbox:up()
	end, spinbox)
	g_keyboard.bindKeyPress("Down", function()
		check()
		spinbox:down()
	end, spinbox)
	g_keyboard.bindKeyPress("Right", function()
		check()
		spinbox:up()
	end, spinbox)
	g_keyboard.bindKeyPress("Left", function()
		check()
		spinbox:down()
	end, spinbox)
	g_keyboard.bindKeyPress("Tab", function()
		check()
		spinbox:setValue(spinbox:getValue() + 10)
	end, spinbox)
	g_keyboard.bindKeyPress("PageUp", function()
		check()
		spinbox:setValue(spinbox:getValue() + 10)
	end, spinbox)
	g_keyboard.bindKeyPress("PageDown", function()
		check()
		spinbox:setValue(spinbox:getValue() - 10)
	end, spinbox)
	g_keyboard.bindKeyPress("Shift+Tab", function()
		check()
		spinbox:setValue(spinbox:getValue() - 10)
	end, spinbox)

	function scrollbar:onValueChange(value)
		itembox:setItemCount(value)

		spinbox.onValueChange = nil

		spinbox:setValue(value)

		spinbox.onValueChange = spinBoxValueChange
	end

	local okButton = countWindow:getChildById("buttonOk")

	local function moveFunc()
		g_game.remove(item, itembox:getItemCount())
		okButton:getParent():destroy()

		countWindow = nil
	end

	local cancelButton = countWindow:getChildById("buttonCancel")

	local function cancelFunc()
		cancelButton:getParent():destroy()

		countWindow = nil
	end

	countWindow.onEnter = moveFunc
	countWindow.onEscape = cancelFunc
	okButton.clickSound = true
	okButton.onClick = moveFunc
	cancelButton.clickSound = true
	cancelButton.onClick = cancelFunc

	if g_keyboard.isKeyPressed("Enter") then
		scheduleEvent(moveFunc, 100)
	end
end

function getCurrentRegion()
	return currentRegion
end

function getRootPanel()
	return gameRootPanel
end

function getMapPanel()
	return gameMapPanel
end

function getRightPanel()
	return gameRightPanel
end

function getLeftPanel()
	return gameLeftPanel
end

function getBottomPanel()
	return gameBottomPanel
end

function getChatPanel()
	return gameChatPanel
end

function getMessagePanel()
	return gameMessagePanel
end

function getWindowPanel()
	return getRootPanel()
end

function getHUDPanel()
	return gameHUDPanel
end

function getOverlayPanel()
	return gameOverlayPanel
end

function onLeftPanelVisibilityChange(leftPanel, visible)
	if not visible and g_game.isOnline() then
		local children = leftPanel:getChildren()

		for i = 1, #children do
			children[i]:setParent(gameRightPanel)
		end
	end
end

function refreshViewMode()
	local mode = g_map.getViewMode()

	if mode == ViewModePlayer then
		gameMapPanel:setVisibleDimension({
			width = 25,
			height = 13
		})
	elseif mode == ViewModeShip then
		gameMapPanel:setVisibleDimension({
			width = 37,
			height = 19
		})
	elseif mode == ViewModeAnchor then
		gameMapPanel:setVisibleDimension({
			width = 31,
			height = 17
		})
	elseif mode == ViewModeHouse then
		gameMapPanel:setVisibleDimension({
			width = 37,
			height = 19
		})
	end

	gameMapPanel:setKeepAspectRatio(false)
	gameMapPanel:setLimitVisibleRange(false)
	gameMapPanel:setZoom(16)
	gameRightPanel:setOn(true)
	gameRightPanel:setImageColor("alpha")
	gameLeftPanel:setOn(true)
	gameLeftPanel:setVisible(true)
	gameLeftPanel:setImageColor("alpha")
	gameBottomPanel:setImageColor("#ffffff88")
	gameMapPanel:fill("parent")
	gameRootPanel:fill("parent")
end

function limitZoom()
	limitedZoom = true
end

function onDragGameChatPanelEnter(self, mousePos)
	local oldPos = self:getPosition()

	self.movingReference = {
		x = mousePos.x - oldPos.x,
		y = mousePos.y - oldPos.y
	}

	self:setPosition(oldPos)
	self:breakAnchors()

	return true
end

function onDragGameChatPanelLeave(self, droppedWidget, mousePos)
	if self:getPosition().y + self:getHeight() >= self:getParent():getHeight() - 4 then
		self:addAnchor(AnchorBottom, "parent", AnchorBottom)
	end

	return true
end

function onDragGameChatPanelMove(self, mousePos, mouseMoved)
	local pos = {
		x = mousePos.x - self.movingReference.x,
		y = mousePos.y - self.movingReference.y
	}

	self:setPosition(pos)
	self:bindRectToParent()

	return true
end

function onRushOffsetChange(player, x, y)
	if x == 0 and y == 0 then
		if gameMapPanel then
			gameMapPanel:followCreature(player)
		end

		return
	end

	local pos = player:getPosition()
	local xOffset = math.floor(math.abs(x) / 32)
	local yOffset = math.floor(math.abs(y) / 32)

	pos.x = pos.x + xOffset * (x >= 0 and 1 or -1)
	pos.y = pos.y + yOffset * (y >= 0 and 1 or -1)

	if gameMapPanel then
		gameMapPanel:setCameraPosition(pos)
	end
end

function onViewDisplacementOffsetChange(player, x, y)
	if x == 0 and y == 0 then
		if gameMapPanel then
			gameMapPanel:followCreature(player)
		end

		return
	end

	local pos = player:getPosition()
	local xOffset = math.floor(math.abs(x) / 32)
	local yOffset = math.floor(math.abs(y) / 32)

	pos.x = pos.x + xOffset * (x >= 0 and 1 or -1)
	pos.y = pos.y + yOffset * (y >= 0 and 1 or -1)

	if gameMapPanel then
		gameMapPanel:setCameraPosition(pos)
	end
end

function onGroupFlagsChange(flags)
	gameMapPanel.canDragEnter = Bit.hasBit(flags, 2097152)
end

function onScreenFade(fadeIn, fadeOut, interval)
	local fadeOut = fadeOut or fadeIn
	local interval = interval or 500

	if fadeIn > 0 then
		if not gameFadePanel:isVisible() then
			showFadePanel(fadeIn)

			fadeEvent = scheduleEvent(function()
				hideFadePanel(fadeIn)

				fadeEvent = nil
			end, fadeOut + interval)
		else
			hideFadePanel(fadeIn)
		end

		return
	end

	hideFadePanel(1000)
end

function showFadePanel(duration)
	duration = duration or 1000

	gameFadePanel:show()
	g_effects.fadeIn(gameFadePanel, duration)
end

function hideFadePanel(duration)
	duration = duration or 1000

	g_effects.fadeOut(gameFadePanel, duration, nil, false, function()
		gameFadePanel:hide()
	end)
end

function cancelFade()
	if fadeEvent then
		removeEvent(fadeEvent)

		fadeEvent = nil
	end

	g_effects.cancelFade(gameFadePanel)
	gameFadePanel:setOpacity(1)
	gameFadePanel:hide()
end

function onHUDPanelResize(widget, oldRect, newRect)
	g_layout.load(true)
end

function focusMapPanel()
	if not gameRootPanel or not gameMapPanel or gameRootPanel:getFocusedChild() == gameMapPanel then
		return
	end

	gameRootPanel:focusChild(gameMapPanel, MouseFocusReason)
end

local function setShaderOpacity(newShader, opacity, increment)
	g_shaders.setOpacity(currentShader, opacity)

	opacity = math.max(0, math.min(1, opacity + (increment and 0.05 or -0.05)))

	if increment and opacity < 1 then
		shaderFadeEvent = scheduleEvent(function()
			setShaderOpacity(newShader, opacity, increment)
		end, 25)
	elseif not increment and opacity > (newShader == ShaderNone and 0 or 0) then
		shaderFadeEvent = scheduleEvent(function()
			setShaderOpacity(newShader, opacity, increment)
		end, 25)
	elseif currentShader ~= newShader then
		local oldShader = currentShader

		currentShader = newShader

		getMapPanel():setShader(newShader)
		g_shaders.setOpacity(newShader, oldShader ~= ShaderNone and 0 or 0)

		shaderFadeEvent = scheduleEvent(function()
			setShaderOpacity(newShader, oldShader ~= ShaderNone and 0 or 0, true)
		end, 25)
	else
		removeEvent(shaderFadeEvent)

		shaderFadeEvent = nil

		if shaderQueue then
			shaderQueue()

			shaderQueue = nil
		end
	end
end

function UIGameMap.onRegionChange(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.Regions then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		return
	end

	if data.action == "region_change" then
		if data.shader then
			onShaderChange(data)
		end

		if data.name then
			GameNotification:displayRegionChange(data.name, data.pvp, data.aboutToPvp, data.warZone, data.timer)
		end

		signalcall(g_game.onRegionChange, data)
	elseif data.action == "parse_region_conflicts" then
		g_worldMap.regionConflictInfo = data.regions

		g_worldMap.onRegionConflictInfoChange()
	elseif data.action == "add_culling_spawn" then
		g_worldMap.addCullingSpawn(data)
	elseif data.action == "remove_culling_spawn" then
		g_worldMap.removeCullingSpawn(data)
	end
end

function onShaderChange(data, settings)
	cachedShader = data.shader or 0
	currentShader = settings and 0 or currentShader

	if not modules.game_settings.getOption("displayWeatherEffects") or g_game.isInHouseMode() then
		currentShader = 0

		if shaderFadeEvent then
			removeEvent(shaderFadeEvent)

			shaderFadeEvent = nil
		end

		shaderQueue = nil

		return
	end

	if shaderFadeEvent then
		function shaderQueue()
			onShaderChange(data)
		end

		return
	end

	local shader = data.shader or 0

	if currentShader ~= shader and not shaderFadeEvent then
		shaderFadeEvent = setShaderOpacity(shader, 1, false)
	end
end

addEvent(function()
	ProtocolGame.registerExtendedOpcode(ExtendedIds.Regions, UIGameMap.onRegionChange)
end)

function resetRegionInfo()
	local panel = modules.game_textmessage.messagesPanel
	local widget = panel:getChildById("regionPanel")

	g_effects.cancelFade(widget)
	widget:setHeight(0)

	if shaderFadeEvent then
		removeEvent(shaderFadeEvent)

		shaderFadeEvent = nil
	end

	if regionNameEvent then
		removeEvent(regionNameEvent)

		regionNameEvent = nil
	end

	shaderQueue = nil
	regionNameQueue = nil

	if regionNameFadeOutEvent then
		removeEvent(regionNameFadeOutEvent)

		regionNameFadeOutEvent = nil
	end

	if regionTimerEvent then
		removeEvent(regionTimerEvent)

		regionTimerEvent = nil
	end
end

function focusHUDPanel()
	if not g_game.isOnline() then
		return
	end

	if not gameHUDPanel:isFocused() then
		gameHUDPanel:focus()
	end
end

function resetHUDPanelFocus()
	if not g_game.isOnline() then
		return
	end

	if GameChat:isActive() then
		return
	end

	gameMapPanel:focus()
end

function toggleHouseModeCrosshair(toggle)
	if toggle then
		houseModeWidget:setVisible(true)
		gameMapPanel:setCrosshair(houseModeWidget)
	else
		houseModeWidget:setVisible(false)
		gameMapPanel:setCrosshair(nil)
	end
end

function startLandModify(startClaim)
	g_mouse.popCursor("target")
	mouseGrabberWidget:ungrabMouse()

	function mouseGrabberWidget:onMouseRelease(mousePosition, mouseButton)
		if mouseButton == MouseLeftButton then
			if not gameMapPanel.canPlaceHouse then
				if g_game.isPlacingHouse() then
					GameNotification:display(NOTIFICATION_ERROR, nil, "You can't place a house in this land.")
				else
					GameNotification:display(NOTIFICATION_ERROR, nil, "You can't claim this land.")
				end

				return
			end

			if g_game.isModifyingLand() and not g_game.isPlacingHouse() then
				return startHousePlacing()
			end

			local landTile, houseTile = gameMapPanel.landTile, gameMapPanel.houseTile

			if not landTile or not houseTile then
				return
			end

			GameHouse:sendOpcode({
				action = "house_claim_land",
				landPos = {
					x = landTile:getPosition().x,
					y = landTile:getPosition().y,
					z = landTile:getPosition().z
				},
				landIndex = gameMapPanel.landIndex,
				housePos = {
					x = houseTile:getPosition().x,
					y = houseTile:getPosition().y,
					z = houseTile:getPosition().z
				},
				houseDir = gameMapPanel.houseDirection
			})
		end

		releaseLandModify()
		releaseHousePlacing()
		g_mouse.popCursor("target")
		self:ungrabMouse()
		gameMapPanel:blockNextMouseRelease(true)

		self.onMouseRelease = onMouseGrabberRelease
		self.onTouchRelease = self.onMouseRelease
	end

	mouseGrabberWidget.onTouchRelease = mouseGrabberWidget.onMouseRelease

	mouseGrabberWidget:grabMouse()
	g_mouse.pushCursor("target")
	g_game.modifyLand(true)

	gameMapPanel.landTile = nil
	gameMapPanel.landSize = 1
	gameMapPanel.landIndex = nil
	gameMapPanel.houseModelId = nil
	gameMapPanel.maxFloors = nil
	gameMapPanel.canPlaceHouse = nil

	gameMapPanel:onMouseMove(g_window:getMousePosition())

	if not startClaim then
		GameNotification:display(NOTIFICATION_INFO, nil, "Choose a position to claim your land.")
	else
		mouseGrabberWidget:onMouseRelease(g_window:getMousePosition(), MouseLeftButton)
	end
end

function releaseLandModify()
	g_game.modifyLand(false)
	g_game.setModifyLandColor("alpha")

	gameMapPanel.landTile = nil
	gameMapPanel.landSize = nil
	gameMapPanel.landIndex = nil
	gameMapPanel.landCenter = nil
	gameMapPanel.houseModelId = nil
	gameMapPanel.maxFloors = nil
	gameMapPanel.canPlaceHouse = nil

	gameMapPanel:releaseLandTiles()
end

function startHousePlacing(tile)
	if not HOUSE_MODELS[gameMapPanel.houseModelId] then
		GameNotification:display(NOTIFICATION_ERROR, nil, "Sorry, you need to be closer to the land plot.")

		return
	end

	g_game.placeHouse(true)

	gameMapPanel.houseTile = nil
	gameMapPanel.houseDirection = South
	gameMapPanel.houseModel = HOUSE_MODELS[gameMapPanel.houseModelId][gameMapPanel.houseDirection]

	gameMapPanel:onMouseMove(g_window:getMousePosition())
	GameHouse:sendOpcode({
		action = "house_start_placing",
		pos = gameMapPanel.landCenter or gameMapPanel.landTile:getPosition()
	})
	GameNotification:display(NOTIFICATION_INFO, nil, "Choose a position to place your house.\nYou can use your directional keys to change the direction of your house.")
end

function releaseHousePlacing()
	g_game.placeHouse(false)
	g_game.setModifyLandColor("alpha")

	gameMapPanel.houseTile = nil
	gameMapPanel.houseModel = nil
	gameMapPanel.houseDirection = nil
	gameMapPanel.canPlaceHouse = nil

	gameMapPanel:releaseHouseTiles()
end

function startHouseMoving(info)
	if not info then
		return
	end

	if info.isCommunityHouse or info.isGuildHouse then
		return
	end

	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local playerPos = player:getPosition()

	if math.abs(playerPos.x - info.position.x) > 15 or math.abs(playerPos.y - info.position.y) > 15 then
		GameNotification:display(NOTIFICATION_ERROR, nil, "You need to be closer to the land.")

		return
	end

	local entryTile = g_map.getTile(info.position)

	if not entryTile then
		return
	end

	g_mouse.popCursor("target")
	mouseGrabberWidget:ungrabMouse()

	function mouseGrabberWidget:onMouseRelease(mousePosition, mouseButton)
		if mouseButton == MouseLeftButton then
			if not gameMapPanel.canPlaceHouse then
				GameNotification:display(NOTIFICATION_ERROR, nil, "You cannot place your house in this position. Please find a valid position to relocate your house or free up space to place your house here.")

				return
			end

			local houseInfo, houseTile = gameMapPanel.houseMoveInfo, gameMapPanel.houseTile

			if not houseInfo or not houseTile then
				return
			end

			GameHouse:sendOpcode({
				action = "house_move_land",
				landId = houseInfo.land_id,
				landPos = houseInfo.position,
				housePos = {
					x = houseTile:getPosition().x,
					y = houseTile:getPosition().y,
					z = houseTile:getPosition().z
				},
				houseDir = gameMapPanel.houseDirection
			})
		end

		releaseHouseMoving()
		g_mouse.popCursor("target")
		self:ungrabMouse()
		gameMapPanel:blockNextMouseRelease(true)

		self.onMouseRelease = onMouseGrabberRelease
		self.onTouchRelease = self.onMouseRelease
	end

	mouseGrabberWidget.onTouchRelease = mouseGrabberWidget.onMouseRelease

	mouseGrabberWidget:grabMouse()
	g_mouse.pushCursor("target")
	g_game.setHouseFloor(info.position.z)
	g_game.moveHouse(true)

	gameMapPanel.houseMoveInfo = table.copy(info)
	gameMapPanel.houseModelId = info.model
	gameMapPanel.houseTile = nil
	gameMapPanel.houseDirection = South
	gameMapPanel.houseModel = HOUSE_MODELS[gameMapPanel.houseModelId][South]

	gameMapPanel:onCurrentHouseTiles(entryTile)
	gameMapPanel:onMouseMove(g_window:getMousePosition())
	GameNotification:display(NOTIFICATION_INFO, nil, "Choose a position to move your house.")
	GameHouse:sendOpcode({
		action = "house_start_moving",
		landId = info.land_id,
		houseId = info.id
	})
end

function releaseHouseMoving()
	g_game.moveHouse(false)

	gameMapPanel.houseMoveInfo = nil
	gameMapPanel.houseModelId = nil
	gameMapPanel.houseTile = nil
	gameMapPanel.houseModel = nil
	gameMapPanel.houseDirection = nil
	gameMapPanel.canPlaceHouse = nil

	gameMapPanel:releaseCurrentHouseTiles()
	gameMapPanel:releaseHouseTiles()
end

function onRoomReplace(data)
	if gameMapPanel.confirmationBox then
		gameMapPanel.confirmationBox:destroy()

		gameMapPanel.confirmationBox = nil
	end

	local function yesCallback()
		gameMapPanel.confirmationBox:destroy()

		gameMapPanel.confirmationBox = nil

		GameHouse:sendOpcode(data)
	end

	local function noCallback()
		gameMapPanel.confirmationBox:destroy()

		gameMapPanel.confirmationBox = nil
	end

	gameMapPanel.confirmationBox = displayGeneralBox(tr("House Room"), "House room will be replaced permanently.\nDo you want to continue?", {
		{
			text = tr("Yes"),
			callback = yesCallback
		},
		{
			text = tr("No"),
			callback = noCallback
		},
		anchor = AnchorHorizontalCenter
	}, yesCallback, noCallback, nil, modules.game_interface.getRootPanel())
end

function startRoomPlacing(room)
	g_mouse.popCursor("target")
	mouseGrabberWidget:ungrabMouse()

	function mouseGrabberWidget:onMouseRelease(mousePosition, mouseButton)
		if mouseButton == MouseLeftButton then
			if not gameMapPanel.canPlaceHouseRoom then
				GameNotification:display(NOTIFICATION_ERROR, nil, "You can't place a room in this position.")

				return
			end

			local roomTile = gameMapPanel.houseRoomTile

			if not roomTile then
				return
			end

			local player = g_game.getLocalPlayer()
			local houseFloor = g_game.getHouseFloor()
			local playerPos = player:getPosition()
			local offset = houseFloor == -1 and 0 or playerPos.z - houseFloor
			local data = {
				action = "house_modify_room",
				index = gameMapPanel.houseRoomModelId,
				position = {
					x = roomTile:getPosition().x + offset,
					y = roomTile:getPosition().y + offset,
					z = roomTile:getPosition().z
				},
				direction = gameMapPanel.houseRoomDirection
			}

			if roomTile:getTileType() ~= TileType.Room or DEPOT_MODEL_IDS[room.model] then
				GameHouse:sendOpcode(data)
			else
				onRoomReplace(data)
			end
		end

		releaseRoomPlacing()
		g_mouse.popCursor("target")
		self:ungrabMouse()
		gameMapPanel:blockNextMouseRelease(true)

		self.onMouseRelease = onMouseGrabberRelease
		self.onTouchRelease = self.onMouseRelease
	end

	mouseGrabberWidget.onTouchRelease = mouseGrabberWidget.onMouseRelease

	mouseGrabberWidget:grabMouse()
	g_mouse.pushCursor("target")
	g_game.placeHouseRoom(true)

	gameMapPanel.houseRoomTile = nil
	gameMapPanel.houseRoomModel = ROOM_MODELS[room.model][South]
	gameMapPanel.houseRoomModelId = room.model
	gameMapPanel.houseRoomDirection = South

	gameMapPanel:onMouseMove(g_window:getMousePosition())
	GameNotification:display(NOTIFICATION_INFO, nil, "Choose a position to place your house room.\nYou can use your directional keys to change the direction of your room.")
end

function releaseRoomPlacing()
	g_game.placeHouseRoom(false)
	g_game.setModifyRoomColor("alpha")

	gameMapPanel.houseRoomTile = nil
	gameMapPanel.houseRoomModel = nil
	gameMapPanel.houseRoomModelId = nil
	gameMapPanel.houseRoomDirection = nil
	gameMapPanel.canPlaceHouseRoom = nil

	gameMapPanel:releaseRoomTiles()
end

function changeHousePlacingDirection(dir)
	if not g_game.isPlacingHouse() and not g_game.isMovingHouse() then
		return
	end

	local model = gameMapPanel.houseModelId and HOUSE_MODELS[gameMapPanel.houseModelId][dir]

	if model then
		gameMapPanel:releaseHouseTiles()

		gameMapPanel.houseTile = nil
		gameMapPanel.houseModel = model
		gameMapPanel.houseDirection = dir

		gameMapPanel:onMouseMove(g_window:getMousePosition())
	end
end

function changeRoomPlacingDirection(dir)
	if not g_game.isPlacingHouseRoom() then
		return
	end

	local model = gameMapPanel.houseRoomModelId and ROOM_MODELS[gameMapPanel.houseRoomModelId][dir]

	if model then
		gameMapPanel:releaseRoomTiles()

		gameMapPanel.houseRoomTile = nil
		gameMapPanel.houseRoomModel = model
		gameMapPanel.houseRoomDirection = dir

		gameMapPanel:onMouseMove(g_window:getMousePosition())
	end
end

function changeDecorPlacingDirection(dir)
	if not g_game.isPlacingHouse() then
		return
	end

	if not gameMapPanel.decorModelId or not DECOR_MODELS[gameMapPanel.decorModelId].directions then
		return
	end

	local model = DECOR_MODELS[gameMapPanel.decorModelId].directions[dir]

	if model then
		gameMapPanel:releaseDecorTiles()

		gameMapPanel.decorTile = nil
		gameMapPanel.decorModel = model
		gameMapPanel.decorDirection = dir

		gameMapPanel:onMouseMove(g_window:getMousePosition())
	end
end

function releaseFarmPlacing()
	g_game.placeHouse(false)

	gameMapPanel.farmTile = nil
	gameMapPanel.farmModel = nil
	gameMapPanel.canPlaceFarm = nil
	gameMapPanel.houseDirection = nil

	gameMapPanel:releaseFarmTiles()
end

function releaseDecorPlacing()
	g_game.placeHouse(false)

	gameMapPanel.decorTile = nil
	gameMapPanel.decorModel = nil
	gameMapPanel.canPlaceDecor = nil

	gameMapPanel:releaseDecorTiles()
end

function startFarmPlacing(farm)
	if not farm or not farm.skillRequired or not farm.index then
		return
	end

	g_mouse.popCursor("target")
	mouseGrabberWidget:ungrabMouse()
	g_game.placeHouse(true)

	gameMapPanel.farmTile = nil
	gameMapPanel.farmModel = FARM_MODELS[farm.model]

	gameMapPanel:onMouseMove(g_window:getMousePosition())
	GameNotification:display(NOTIFICATION_INFO, nil, string.format("Choose a position to place your |%s|.", farm.name))

	function mouseGrabberWidget:onMouseRelease(mousePosition, mouseButton)
		if mouseButton == MouseLeftButton then
			if not gameMapPanel.canPlaceFarm then
				if g_game.isPlacingHouse() then
					GameNotification:display(NOTIFICATION_ERROR, nil, "You can't place in this land.")
				end

				return
			end

			local farmTile = gameMapPanel.farmTile

			if farmTile then
				GameHouse:sendOpcode({
					action = "house_place_farm",
					farmType = farm.skillRequired[1],
					farmIndex = farm.index,
					farmPos = {
						x = farmTile:getPosition().x,
						y = farmTile:getPosition().y,
						z = farmTile:getPosition().z
					},
					landId = GameHouse:getSelectedLandId()
				})
				gameMapPanel:onFarmTiles(true)
				signalcall(g_game.onPlaceFarm, farmTile:getPosition())
			end

			return
		end

		releaseFarmPlacing()
		g_mouse.popCursor("target")
		self:ungrabMouse()
		gameMapPanel:blockNextMouseRelease(true)

		self.onMouseRelease = onMouseGrabberRelease
		self.onTouchRelease = self.onMouseRelease

		signalcall(g_game.onCancelFarmPlacing)
	end

	mouseGrabberWidget.onTouchRelease = mouseGrabberWidget.onMouseRelease

	mouseGrabberWidget:grabMouse()
	g_mouse.pushCursor("target")
	signalcall(g_game.onStartFarmPlacing)
end

function startSeedPlacing(seed)
	g_game.placeHouse(true)

	gameMapPanel.farmTile = nil
	gameMapPanel.farmModel = FARM_MODELS[seed.model]

	gameMapPanel:onMouseMove(g_window:getMousePosition())
	GameNotification:display(NOTIFICATION_INFO, nil, string.format("Choose a farming bed to plant |%s|.", seed.name))
	g_mouse.popCursor("target")
	mouseGrabberWidget:ungrabMouse()

	function mouseGrabberWidget:onMouseRelease(mousePosition, mouseButton)
		if mouseButton == MouseLeftButton then
			if not gameMapPanel.canPlaceFarm then
				if g_game.isPlacingHouse() then
					GameNotification:display(NOTIFICATION_ERROR, nil, string.format("You can't place |%s| on this farming bed.", seed.name))
				end

				return
			end

			local seedTile = gameMapPanel.farmTile

			if not seedTile then
				return
			end

			GameHouse:sendOpcode({
				action = "house_place_seed",
				farmIndex = seed.index,
				farmPos = {
					x = seedTile:getPosition().x,
					y = seedTile:getPosition().y,
					z = seedTile:getPosition().z
				},
				landId = GameHouse:getSelectedLandId()
			})
			gameMapPanel:onFarmTiles(true)

			return
		end

		releaseFarmPlacing()
		g_mouse.popCursor("target")
		self:ungrabMouse()
		gameMapPanel:blockNextMouseRelease(true)

		self.onMouseRelease = onMouseGrabberRelease
		self.onTouchRelease = self.onMouseRelease
	end

	mouseGrabberWidget.onTouchRelease = mouseGrabberWidget.onMouseRelease

	mouseGrabberWidget:grabMouse()
	g_mouse.pushCursor("target")
end

function startDecorPlacing(decor)
	g_game.placeHouse(true)

	gameMapPanel.decorTile = nil
	gameMapPanel.decorModel = DECOR_MODELS[decor.id].directions and DECOR_MODELS[decor.id].directions[South] or DECOR_MODELS[decor.id]
	gameMapPanel.decorModelId = decor.id
	gameMapPanel.decorDirection = South

	gameMapPanel:onMouseMove(g_window:getMousePosition())
	GameNotification:display(NOTIFICATION_INFO, nil, string.format("Choose position to place your |%s.%s|", decor.name, DECOR_MODELS[decor.id].directions and tr("\nYou can use your directional keys to change the direction of the decoration.") or ""))
	g_mouse.popCursor("target")
	mouseGrabberWidget:ungrabMouse()

	function mouseGrabberWidget:onMouseRelease(mousePosition, mouseButton)
		if mouseButton == MouseLeftButton then
			if not gameMapPanel.canPlaceDecor then
				if g_game.isPlacingHouse() then
					GameNotification:display(NOTIFICATION_ERROR, nil, string.format("You can't place |%s| at this position.", decor.name))
				end

				return
			end

			local decorTile = gameMapPanel.decorTile

			if not decorTile then
				return
			end

			local player = g_game.getLocalPlayer()
			local houseFloor = g_game.getHouseFloor()
			local playerPos = player:getPosition()
			local offset = houseFloor == -1 and 0 or playerPos.z - houseFloor

			GameHouse:sendOpcode({
				action = "house_place_decor",
				decorId = decor.itemId,
				decorPos = {
					x = decorTile:getPosition().x + offset,
					y = decorTile:getPosition().y + offset,
					z = decorTile:getPosition().z
				},
				decorDir = gameMapPanel.decorDirection
			})
			gameMapPanel:onDecorTiles(true)
		end

		releaseDecorPlacing()
		g_mouse.popCursor("target")
		self:ungrabMouse()
		gameMapPanel:blockNextMouseRelease(true)

		self.onMouseRelease = onMouseGrabberRelease
		self.onTouchRelease = self.onMouseRelease
	end

	mouseGrabberWidget.onTouchRelease = mouseGrabberWidget.onMouseRelease

	mouseGrabberWidget:grabMouse()
	g_mouse.pushCursor("target")
end

function startItemRemoving()
	g_game.placeHouse(true)
	toggleHouseModeCrosshair(true)

	gameMapPanel.itemTile = nil
	gameMapPanel.itemModel = true

	gameMapPanel:onMouseMove(g_window:getMousePosition())
	GameNotification:display(NOTIFICATION_INFO, nil, "Choose an object to remove.")
	g_mouse.popCursor("target")
	mouseGrabberWidget:ungrabMouse()

	function mouseGrabberWidget:onMouseRelease(mousePosition, mouseButton)
		if mouseButton == MouseLeftButton then
			if not gameMapPanel.canRemoveItem then
				if g_game.isPlacingHouse() then
					GameNotification:display(NOTIFICATION_ERROR, nil, "You can't remove this object.")
				end

				return
			end

			local tile = gameMapPanel.itemTile

			if not tile then
				return
			end

			GameHouse:sendOpcode({
				action = "house_remove_item",
				itemPos = {
					x = tile:getPosition().x,
					y = tile:getPosition().y,
					z = tile:getPosition().z
				}
			})
			gameMapPanel:onMouseMove(g_window:getMousePosition())

			return
		end

		releaseItemPlacing()
		g_mouse.popCursor("target")
		self:ungrabMouse()
		gameMapPanel:blockNextMouseRelease(true)

		self.onMouseRelease = onMouseGrabberRelease
		self.onTouchRelease = self.onMouseRelease
	end

	mouseGrabberWidget.onTouchRelease = mouseGrabberWidget.onMouseRelease

	mouseGrabberWidget:grabMouse()
	g_mouse.pushCursor("target")
end

function releaseItemPlacing()
	g_game.placeHouse(false)
	toggleHouseModeCrosshair(false)

	gameMapPanel.itemTile = nil
	gameMapPanel.itemModel = nil
	gameMapPanel.canRemoveItem = nil

	gameMapPanel:releaseMarkedItem()
end

function releaseHouseMode()
	if gameMapPanel.landTile then
		releaseLandModify()
	end

	if gameMapPanel.houseTile then
		releaseHousePlacing()
		releaseHouseMoving()
	end

	if gameMapPanel.houseRoomTile then
		releaseRoomPlacing()
	end

	if gameMapPanel.farmTile then
		releaseFarmPlacing()
	end

	if gameMapPanel.itemTile then
		releaseItemPlacing()
	end

	if gameMapPanel.decorTile then
		releaseDecorPlacing()
	end

	g_mouse.popCursor("target")
	mouseGrabberWidget:ungrabMouse()
	gameMapPanel:blockNextMouseRelease(true)
	hideSpellCursor()

	mouseGrabberWidget.onMouseRelease = onMouseGrabberRelease
	mouseGrabberWidget.onTouchRelease = mouseGrabberWidget.onMouseRelease

	resetHUDPanelFocus()
end

function showCenterLabel(text, delay)
	if centerLabelEvent then
		callEvent(centerLabelEvent)

		centerLabelEvent = nil
	end

	centerLabel:setVisible(true)
	centerLabel:setText(text)
	g_effects.fadeIn(centerLabel, 1000)

	centerLabelEvent = scheduleEvent(function()
		centerLabel:setVisible(false)
		centerLabel:setText("")

		centerLabelEvent = nil
	end, delay or 5000)
end

function showArenaCountdown(count, start, tickSfxId)
	if tickSfxId then
		g_sound.play(tickSfxId)
	end

	countdownLabel:setTextColor(count <= 10 and "#e06253" or "#FCBB1F")
	countdownLabel:setOpacity(1)
	countdownLabel:show()
	countdownLabel:setText(count)
	g_effects.fadeOut(countdownLabel, 1000, nil, false, function()
		if count > 1 then
			showArenaCountdown(count - 1, start, tickSfxId)
		else
			start = start or {}

			showArenaStartMessage(start.message or "Fight!", start)
		end
	end, function(widget)
		widget:setFont(string.format("saira-stencil-one-%i", (count <= 10 and 70 or 50) + widget:getOpacity() * 10))
	end)
end

function showArenaStartMessage(message, options)
	countdownLabel:setTextColor(options.color and options.color or "#e06253")
	countdownLabel:setOpacity(1)
	countdownLabel:show()
	countdownLabel:setText(message)
	g_effects.fadeOut(countdownLabel, 1000, nil, false, function()
		if options.callback then
			options.callback()
		end
	end, function(widget)
		widget:setFont(string.format("saira-stencil-one-%i", (options.opacity or 70) + widget:getOpacity() * 10))
	end)
end

function showCountdownMessage(message, options)
	options = options or {}

	countdownLabel:setTextColor(options.color and options.color or "#e06253")
	countdownLabel:setOpacity(1)
	countdownLabel:show()
	countdownLabel:setText(message)
	g_effects.cancelFade(countdownLabel)
	g_effects.fadeOut(countdownLabel, 1000, nil, false, function()
		if options.callback then
			options.callback()
		end
	end, function(widget)
		widget:setFont(string.format("saira-stencil-one-%i", (options.opacity or 70) + widget:getOpacity() * 10))
	end)
end

function hideArenaCountdown()
	if not countdownLabel then
		return
	end

	if countdownLabel.fadeEvent then
		removeEvent(countdownLabel.fadeEvent)

		countdownLabel.fadeEvent = nil
	end

	countdownLabel:setOpacity(0)
end

function onReplaceThing(pos, clientId, duration, replaceId, internal)
	local tile = g_map.getTile(pos)

	if tile then
		for _, item in ipairs(tile:getItems()) do
			if item:isHidden() and clientId == 0 then
				item:setHidden(false)

				ReplacedThings[pos] = nil

				break
			end

			if item:getId() == clientId then
				if not item:isHidden() and replaceId == 0 then
					item.replaced = replaceId

					item:setHidden(true)
				elseif replaceId ~= 0 and clientId ~= 0 then
					item:setId(replaceId)
				end

				if not internal then
					ReplacedThings[pos] = {
						pos,
						clientId,
						duration,
						replaceId
					}

					if duration > 0 then
						scheduleEvent(function()
							onReplaceThing(pos, replaceId, 0, clientId, true)
						end, duration)
					end

					break
				end

				ReplacedThings[pos] = nil

				break
			end
		end
	elseif internal then
		ReplacedThings[pos] = nil
	end
end

function onPositionChange(player, newPos, oldPos)
	for pos, data in pairs(table.copy(ReplacedThings)) do
		if Position.canSee(newPos, pos) then
			onReplaceThing(unpack(data))

			ReplacedThings[pos] = nil
		end
	end
end

function resetItemsCache()
	local player = g_game.getLocalPlayer()

	player.itemsCache = nil
	player.itemsCache = player:getItems()
end

function removeItemFromCache(container, slot, item)
	if container:getType() == CONTAINER_TYPE_INBOX then
		return
	end

	local player = g_game.getLocalPlayer()

	if not player.itemsCache then
		resetItemsCache()
	end

	local UUID = item:getUUID()

	for i, cachedItem in ipairs(player.itemsCache) do
		if cachedItem:getUUID() == item:getUUID() then
			table.remove(player.itemsCache, i)

			break
		end
	end
end

function addItemToCache(container, slot, item)
	if container:getType() == CONTAINER_TYPE_INBOX then
		return
	end

	local player = g_game.getLocalPlayer()

	if not player.itemsCache then
		resetItemsCache()
	end

	local containerType = container:getType()

	if containerType == CONTAINER_TYPE_INVENTORY or containerType == CONTAINER_TYPE_QUEST then
		item.container = container

		table.insert(player.itemsCache, item)
	end
end

function updateItemInCache(container, slot, item)
	if container:getType() == CONTAINER_TYPE_INBOX then
		return
	end

	local player = g_game.getLocalPlayer()

	if not player.itemsCache then
		resetItemsCache()
	end

	local UUID = item:getUUID()

	for i, cachedItem in ipairs(player.itemsCache) do
		if cachedItem:getUUID() == item:getUUID() then
			item.container = cachedItem.container
			player.itemsCache[i] = item

			break
		end
	end
end

function createExchangeGiftPopup(creatureThing)
	if exchangeGiftPopup then
		exchangeGiftPopup:destroy()

		exchangeGiftPopup = nil
	end

	exchangeGiftPopup = g_ui.createWidget("ExchangeGiftPopupWindow", gameHUDPanel)
	exchangeGiftPopup.creatureThing = creatureThing

	exchangeGiftPopup:raise()
end

function onExchangeGiftButtonClick(button)
	local value = tonumber(exchangeGiftPopup:recursiveGetChildById("textEdit"):getText())

	if value then
		sendOpcode(ExtendedIds.GameEvents, {
			action = "player_exchange_gift",
			creatureId = exchangeGiftPopup.creatureThing:getId(),
			count = value
		})
	end

	if exchangeGiftPopup then
		exchangeGiftPopup:destroy()

		exchangeGiftPopup = nil
	end
end
