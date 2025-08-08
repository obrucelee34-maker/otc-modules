-- chunkname: @/modules/game_playerdeath/playerdeath.lua

PlayerDeath = {
	spawnsOptions = {},
	deathTexts = {
		regular = {
			width = 0,
			height = 10,
			text = "As your soul departs, you feel the warmth of the Dawn, calling you back into the world."
		},
		unfair = {
			width = 0,
			height = 10,
			text = "As your soul departs, you feel the warmth of the Dawn, calling you back into the world."
		},
		blessed = {
			width = 0,
			height = 10,
			text = "As your soul departs, you feel the warmth of the Dawn, calling you back into the world."
		}
	}
}

function PlayerDeath.init()
	g_ui.importStyle("deathwindow")
	ProtocolGame.registerExtendedOpcode(ExtendedIds.RessurrectionSpawnPoint, PlayerDeath.onExtendedOpcode)
	connect(g_game, {
		onDeath = PlayerDeath.display,
		onGameEnd = PlayerDeath.reset
	})
end

function PlayerDeath.terminate()
	disconnect(g_game, {
		onDeath = PlayerDeath.display,
		onGameEnd = PlayerDeath.reset
	})
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.RessurrectionSpawnPoint)
	PlayerDeath:reset()
end

function PlayerDeath.onExtendedOpcode(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.RessurrectionSpawnPoint or buffer == "" then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		return
	end

	if data.action == "spawnOptions" then
		PlayerDeath.spawnsOptions = data.spawns
	elseif data.action == "death_penalty_window" then
		PlayerDeath:openPenaltyWindow(data.values)
	end
end

function PlayerDeath.reset()
	if PlayerDeath.windowEvent then
		removeEvent(PlayerDeath.windowEvent)

		PlayerDeath.windowEvent = nil
	end

	if PlayerDeath.window then
		PlayerDeath.window:destroy()

		PlayerDeath.window = nil
	end

	if PlayerDeath.penaltyWindow then
		PlayerDeath.penaltyWindow:destroy()

		PlayerDeath.penaltyWindow = nil
	end
end

function PlayerDeath.display(deathType, penalty)
	PlayerDeath.windowEvent = scheduleEvent(function()
		PlayerDeath:openWindow(deathType, penalty)
	end, 3000)
end

function PlayerDeath:cropMinimap(minimap, data)
	local area = data.area

	if not data.area or not data.area.center then
		minimap:setVisible(false)

		return
	end

	local mapData = g_worldMap.getMapImageData(area.center)
	local txtSize = g_graphics.getMaxTextureSize()
	local quality = txtSize <= 4096 and "l" or "m"
	local source = string.format("/images/%s", string.format(mapData.name, quality))

	if minimap:getImageSource() ~= source then
		minimap:setImageSource(source)
	end

	local parentSize = minimap:getParent():getSize()
	local imageWidth = minimap:getImageTextureWidth()
	local imageHeight = minimap:getImageTextureHeight()
	local topLeftX = (area.center.x - mapData.area.fromX) / (mapData.area.toX - mapData.area.fromX) * imageWidth
	local topLeftY = (area.center.y - mapData.area.fromY) / (mapData.area.toY - mapData.area.fromY) * imageHeight
	local width = parentSize.width * (imageWidth < 10240 and 2 or 1)
	local height = parentSize.height * (imageHeight < 5760 and 2 or 1)
	local ratio = math.min(parentSize.width / width, parentSize.height / height)
	local finalWidth = math.min(parentSize.width, width * ratio)
	local finalHeight = math.min(parentSize.height, height * ratio)

	minimap:setImageClip({
		x = topLeftX - width / 2,
		y = topLeftY - height / 2,
		width = width,
		height = height
	})
	minimap:setSize({
		width = finalWidth,
		height = finalHeight
	})
	minimap:setVisible(true)
end

function PlayerDeath:setupMapImage(data)
	if not data then
		return
	end

	local closestSpawnPoint = self.window:recursiveGetChildById("closestSpawnPoint")
	local text = string.format("The region's sanctuary is located at %s", data.name)
	local highlightText = GetHighlightedText(tr(string.format("The region's sanctuary is located at |{%s, #FFA851}|", data.name)))

	if #highlightText > 0 then
		closestSpawnPoint:setColoredText(highlightText)
	else
		closestSpawnPoint:setText(text or "")
	end

	data.position.x = data.position.x - g_worldMap.getCustomMapPositionOffset(data.position).x

	local area = {
		center = data.position,
		fromX = data.position.x - 10,
		fromY = data.position.y - 10,
		toX = data.position.x + 10,
		toY = data.position.y + 10
	}
	local minimap = self.window:recursiveGetChildById("minimap")

	self:cropMinimap(minimap, {
		area = area
	})
end

function PlayerDeath:openWindow(deathType, penalty)
	if self.window then
		self.window:destroy()

		self.window = nil

		return
	end

	self.fadeWindow = g_ui.createWidget("DeathFadeBackground", rootWidget)
	self.window = g_ui.createWidget("DeathWindow", rootWidget)

	function self.window.onDestroy()
		if self.fadeWindow then
			self.fadeWindow:destroy()

			self.fadeWindow = nil
		end
	end

	local textLabel = self.window:recursiveGetChildById("subtitle")

	if deathType == DeathType.Regular then
		if penalty == 100 then
			textLabel:setText(self.deathTexts.regular.text)
			self.window:setHeight(self.window.baseHeight + self.deathTexts.regular.height)
			self.window:setWidth(self.window.baseWidth + self.deathTexts.regular.width)
		else
			textLabel:setText(string.format(self.deathTexts.unfair.text, 100 - penalty))
			self.window:setHeight(self.window.baseHeight + self.deathTexts.unfair.height)
			self.window:setWidth(self.window.baseWidth + self.deathTexts.unfair.width)
		end
	elseif deathType == DeathType.Blessed then
		textLabel:setText(self.deathTexts.blessed.text)
		self.window:setHeight(self.window.baseHeight + self.deathTexts.blessed.height)
		self.window:setWidth(self.window.baseWidth + self.deathTexts.blessed.width)
	end

	local optionsPanel = self.window:recursiveGetChildById("buttonsPanel")

	for id, optionConfig in ipairs(self.spawnsOptions) do
		local option = g_ui.createWidget("SpawnOptionButton", optionsPanel)

		option:setText(optionConfig.name)

		local function optionCallback()
			g_game.selectSpawnPoint(id)
			g_game.getLocalPlayer():setHidden(false)

			if self.window then
				self.window:destroy()

				self.window = nil
			end
		end

		option.clickSound = true

		if id == 1 then
			self.window.onEnter = optionCallback
			self.window.onEscape = optionCallback
		end

		option:setOn(id > 1)

		option.onClick = optionCallback
	end

	if #self.spawnsOptions > 1 then
		for idx, child in ipairs(optionsPanel:getChildren()) do
			if child.__disconnects then
				for _, disconnect in ipairs(child.__disconnects) do
					disconnect()
				end
			end

			local disconnects = connect(child, {
				onHoverChange = function(widget, hovered)
					self:setupMapImage(self.spawnsOptions[idx])
				end
			})

			child.__disconnects = disconnects
		end
	end

	local data = self.spawnsOptions[#self.spawnsOptions]

	self:setupMapImage(data)
	g_effects.fadeIn(self.fadeWindow, 2000)
	g_effects.fadeIn(self.window, 2000)
end

function PlayerDeath:openPenaltyWindow(values)
	if self.penaltyWindow then
		self.penaltyWindow:destroy()

		self.penaltyWindow = nil

		return
	end

	if self.window then
		self.window:destroy()

		self.window = nil
	end

	self.fadeWindow = g_ui.createWidget("DeathFadeBackground", rootWidget)
	self.penaltyWindow = g_ui.createWidget("DeathPenaltyWindow", rootWidget)

	self.penaltyWindow.title:setText(values.title)
	self.penaltyWindow.subtitle:setText(values.message)

	if self.penaltyWindow.previousHeight then
		self.penaltyWindow:setHeight(self.penaltyWindow.previousHeight)

		self.penaltyWindow.previousHeight = nil
	end

	if not values.hideContent then
		self.penaltyWindow.middlePanel:show()
		self.penaltyWindow.closestSpawnPoint:show()
		self.penaltyWindow.closestSpawnPoint:setText(values.silverMsg)

		local leftPanel = self.penaltyWindow.middlePanel.leftPanel
		local rightPanel = self.penaltyWindow.middlePanel.rightPanel

		leftPanel.price:setText(string.format("%s EXP", formatNumber(values.deathDebt)))
		leftPanel.total:setText(string.format("%s%s EXP", leftPanel.total.baseText, formatNumber(values.totalDebt)))
		rightPanel.price:setText(string.format("%s", formatNumber(values.costDebt)))
		rightPanel.total:setText(string.format("%s%s", rightPanel.total.baseText, formatNumber(values.silverBalance)))
	else
		self.penaltyWindow.middlePanel:hide()
		self.penaltyWindow.closestSpawnPoint:hide()

		local heightToShrink = self.penaltyWindow.middlePanel:getHeight() + self.penaltyWindow.closestSpawnPoint:getHeight() + 30

		self.penaltyWindow.previousHeight = self.penaltyWindow:getHeight()

		self.penaltyWindow:setHeight(self.penaltyWindow:getHeight() - heightToShrink)
	end

	local buttonsPanel = self.penaltyWindow.buttonsPanel

	if not values.customButton then
		buttonsPanel.customButton:hide()
		buttonsPanel.silver:show()
		buttonsPanel.death:show()
	else
		buttonsPanel.customButton:show()
		buttonsPanel.silver:hide()
		buttonsPanel.death:hide()
		buttonsPanel.customButton:setText(values.button)

		buttonsPanel.customButton.clickSound = true

		function buttonsPanel.customButton.onClick()
			self:sendOpcode({
				action = "death_penalty_custom",
				id = values.callback
			})
		end
	end

	if values.extraButtons then
		for _, button in ipairs(values.extraButtons) do
			local extraButton = g_ui.createWidget(button.style or "SpawnOptionButton", buttonsPanel)

			extraButton:setText(button.text)

			extraButton.clickSound = button.clickSound ~= nil and button.clickSound or true

			function extraButton.onClick()
				self:sendOpcode({
					action = button.action or "death_penalty_custom",
					id = button.callback
				})
			end

			if button.tooltip then
				extraButton:setTooltip(button.tooltip)
			end
		end
	end

	if self.respawnTimeEvent then
		removeEvent(self.respawnTimeEvent)

		self.respawnTimeEvent = nil
	end

	local timerPanel = self.penaltyWindow.timerPanel

	if values.time then
		timerPanel:show()

		local remaining = os.time() + values.time

		local function updateTimer()
			local time = remaining - os.time()

			if time <= 0 then
				timerPanel:hide()

				return
			end

			timerPanel.timer:setText(string.format("%02d:%02d", time / 60, time % 60))

			self.respawnTimeEvent = scheduleEvent(updateTimer, 1000)
		end

		updateTimer()
	else
		timerPanel:hide()
	end

	local disconnects = connect(g_worldMap.window, {
		onVisibilityChange = function(widget, visible)
			if visible then
				local HUDPanel = modules.game_interface.getHUDPanel()

				if HUDPanel:hasChild(widget) then
					HUDPanel:removeChild(widget)
					rootWidget:addChild(widget)
				end
			elseif rootWidget:hasChild(widget) then
				rootWidget:removeChild(widget)
				modules.game_interface.getHUDPanel():addChild(widget)
			end
		end
	})

	function self.penaltyWindow.onDestroy()
		for _, disconnect in ipairs(disconnects) do
			disconnect()
		end

		if rootWidget:hasChild(g_worldMap.window) then
			rootWidget:removeChild(g_worldMap.window)
			modules.game_interface.getHUDPanel():addChild(g_worldMap.window)
		end

		if self.fadeWindow then
			self.fadeWindow:destroy()

			self.fadeWindow = nil
		end

		if self.respawnTimeEvent then
			removeEvent(self.respawnTimeEvent)

			self.respawnTimeEvent = nil
		end
	end
end

function PlayerDeath:sendOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.RessurrectionSpawnPoint, g_game.serializeTable(data))
	end

	self:reset()
end
