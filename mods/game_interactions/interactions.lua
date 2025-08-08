-- chunkname: @/modules/game_interactions/interactions.lua

GameInteractions = {
	hideTutorials = false,
	wasBanditVisibleBeforeLayoutChange = false,
	connections = {},
	custom_interactions = {
		available = {}
	},
	custom_display_names = {}
}

function GameInteractions:loadInteractions()
	local directories = g_resources.listDirectoryFiles(resolvepath("interactions"))
	local env = getfenv(0)

	env.interactions = {}

	setmetatable(env.interactions, {
		__index = env
	})

	for _, directory in ipairs(directories) do
		local files = g_resources.listDirectoryFiles(resolvepath("interactions/" .. directory))

		for _, file in ipairs(files) do
			local func, error = loadfile("interactions/" .. directory .. "/" .. file)

			if not func then
				g_logger.fatal(error)

				return false
			end

			file = string.split(file, ".")[1]
			env.interactions[directory] = {}

			setmetatable(env.interactions[directory], {
				__index = env
			})
			setfenv(func, env.interactions[directory])

			env.interactions[directory].__env = env.interactions[directory]

			func()
		end
	end

	for _, interaction in pairs(env.interactions) do
		if interaction.quest_name and interaction.display_name then
			self.custom_display_names[interaction.quest_name:lower()] = interaction.display_name
		end
	end

	return true
end

function GameInteractions:init()
	dofile("config.lua")
	self:loadConnections()
	self:loadInteractions()
	g_ui.importStyle("styles/action.otui")
	g_ui.importStyle("styles/description.otui")
	g_ui.importStyle("styles/additions.otui")
	g_ui.importStyle("styles/list_window.otui")

	self.action_window = g_ui.createWidget("GameInteractionsActionWindow", modules.game_interface.getHUDPanel())

	self.action_window:hide()

	local setActionVisible = self.action_window.setVisible

	function self.action_window.setVisible(widget, visible)
		setActionVisible(widget, visible and GameInteractions:isTutorialEnabled())
	end

	function self.action_window.onVisibilityChange(widget, visible)
		if not visible then
			if self.arrow_event then
				removeEvent(self.arrow_event)
			end
		else
			self:resizeActionBox()
		end
	end

	function self.action_window.show()
		if self.description_window:isVisible() then
			return
		end

		self.action_window:setVisible(self:isTutorialEnabled())
	end

	function self.action_window.hide()
		self.action_window:setVisible(false)
	end

	self.description_window = g_ui.createWidget("GameInteractionsDescriptionWindow", modules.game_interface.getHUDPanel())

	self.description_window:hide()

	local setDescriptionVisible = self.description_window.setVisible

	function self.description_window.setVisible(widget, visible)
		setDescriptionVisible(widget, visible and GameInteractions:isTutorialEnabled())
	end

	self.description_window.onPositionChange = self.onDescriptionBoxPositionChange

	function self.description_window.onVisibilityChange(widget, visible)
		if not visible then
			if self.arrow_event then
				removeEvent(self.arrow_event)
			end
		else
			self:resizeDescriptionBox()
		end
	end

	function self.description_window.show()
		if self.action_window:isVisible() then
			return
		end

		self.description_window:setVisible(self:isTutorialEnabled())
	end

	function self.description_window.hide()
		self.description_window:setVisible(false)
	end

	self.list_window = g_ui.createWidget("GameInteractionsListWindow", modules.game_interface.getHUDPanel())

	self.list_window:hide()

	self.bandit_avatar = g_ui.createWidget("GameInteractionsBanditAvatar", modules.game_interface.getHUDPanel())

	self.bandit_avatar:setOn(true)
	self.bandit_avatar.border:show()

	local banditAvatarSetVisible = self.bandit_avatar.setVisible

	function self.bandit_avatar.setVisible(widget, visible)
		banditAvatarSetVisible(widget, visible and (self.custom_interactions.active or not table.empty(self.custom_interactions.available)))
	end

	connect(self.bandit_avatar, {
		onDragMove = self.onBanditAvatarDragMove,
		onDragEnter = self.onBanditAvatarDragEnter,
		onClick = self.onBanditAvatarClick,
		onVisibilityChange = self.onBanditAvatarVisibilityChange
	})
	connect(g_game, {
		onMapKnown = self.onGameStart,
		onGameEnd = self.onGameEnd
	})
	connect(modules.game_questlog.GameQuestLog, {
		onQuestsUpdate = self.onQuestsUpdate
	})

	self.border_animation = Animation.create({
		duration = 2500,
		imageSource = "/images/ui/windows/interactions/animations/bandit_border/border_highlight_%02d",
		pauseWhenHidden = true,
		loop = -1,
		framesCount = 49,
		canvas = self.bandit_avatar.border_highlight,
		frames = FramesDataset.border_highlight,
		onResume = function(self)
			return
		end
	})

	self.border_animation:start()
	self.border_animation:pause()

	self.exclamation_animation = Animation.create({
		duration = 2500,
		pauseWhenHidden = true,
		loop = -1,
		framesCount = 49,
		canvas = self.bandit_avatar.exclamation,
		onResume = function(self)
			return
		end
	})

	self.exclamation_animation:move({
		start = 1,
		finish = 25,
		offset = {
			bottom = 15
		}
	})
	self.exclamation_animation:move({
		start = 26,
		finish = 49,
		offset = {
			bottom = -15
		}
	})
	self.exclamation_animation:start()
	ProtocolGame.registerExtendedOpcode(ExtendedIds.Interactions, self.onExtendedOpcode)

	if g_game.isOnline() then
		g_layout.loadBanditAvatar()
		self.onGameStart()
	end
end

function GameInteractions:terminate()
	GameInteractions:closeActionBox()
	GameInteractions:closeDescriptionBox()
	self.action_window:destroy()
	self.description_window:destroy()
	self.list_window:destroy()

	if self.arrow_event then
		removeEvent(self.arrow_event)
	end

	disconnect(g_game, {
		onMapKnown = self.onGameStart,
		onGameEnd = self.onGameEnd
	})
	disconnect(self.bandit_avatar, {
		onDragMove = self.onBanditAvatarDragMove,
		onDragEnter = self.onBanditAvatarDragEnter,
		onClick = self.onBanditAvatarClick,
		onVisibilityChange = self.onBanditAvatarVisibilityChange
	})

	if self.bandit_avatar.shakeEvent then
		removeEvent(self.bandit_avatar.shakeEvent)
	end

	self.bandit_avatar:destroy()
	self:unloadConnections()
	self:disconnectAllInteractions()
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.Interactions)

	GameInteractions = nil
end

function GameInteractions:isTutorialEnabled()
	return not modules.game_settings.getOption("hideBanditTutorial")
end

function GameInteractions:displayDescriptionBox(data, forcePage)
	local window = self.description_window

	if not window or not self:isTutorialEnabled() then
		return
	end

	if window.tilePos then
		local tile = g_map.getTile(window.tilePos)

		if tile then
			tile:setInteractionWidget(nil)
		end
	end

	if window.creatureId then
		local creature = g_map.getCreatureById(window.creatureId)

		if creature then
			creature:setInteractionWidget(nil)
		end
	end

	if not data.pages or #data.pages == 0 then
		return
	end

	local content = window.content

	content.text:setText(data.pages[1].text)

	local button_panel = content.button_panel

	if #data.pages > 1 then
		button_panel.page_text:setText(tr(string.format("|%i| of |%i|", 1, #data.pages)))
		button_panel.page_text:show()
		button_panel.prev_button:show()
		button_panel.prev_button:setEnabled(false)
		button_panel.next_button:show()
		button_panel.prev_button:setOn(false)
		button_panel.next_button:setOn(true)
		button_panel.prev_button:setEnabled(true)
	else
		button_panel.page_text:hide()
		button_panel.prev_button:hide()
		button_panel.next_button:hide()
	end

	window.bandit_avatar:setVisible(data.bandit and not modules.game_settings.getOption("hideBanditTutorial"))
	content.text:setMarginTop(data.bandit and 10 or 0)

	window.pages = data.pages
	window.currentPage = 1
	window.data = data
	window.followParent = nil

	window:show()

	for _, name in ipairs({
		"arrow_left",
		"arrow_right",
		"arrow_down",
		"arrow_up"
	}) do
		local arrow = window[name]

		if arrow then
			arrow:hide()
		end
	end

	if data.parent then
		local function followParent()
			if not data.parent then
				return
			end

			for _, name in ipairs({
				"arrow_left",
				"arrow_right",
				"arrow_down",
				"arrow_up"
			}) do
				local arrow = window[name]

				if arrow then
					arrow:hide()
				end
			end

			local arrowDirection
			local pos = data.parent:getPosition()
			local size = data.parent:getSize()
			local width = window:getWidth()
			local height = window:getHeight()

			local function checkLeft()
				if pos.x - width - 50 > 0 then
					local newPos = {
						x = pos.x - width - 50,
						y = pos.y + size.height / 2 - height / 2
					}

					window:setPosition(newPos)

					local arrow = window.arrow_right

					if arrow then
						arrowDirection = "right"
					end

					return true
				end

				return false
			end

			local function checkRight()
				if pos.x + size.width + width + 50 < g_window.getWidth() then
					local newPos = {
						x = pos.x + size.width + 50,
						y = pos.y + size.height / 2 - height / 2
					}

					window:setPosition(newPos)

					local arrow = window.arrow_left

					if arrow then
						arrowDirection = "left"
					end

					return true
				end

				return false
			end

			local function checkTop()
				if pos.y - height - (window.bandit_avatar:isVisible() and window.bandit_avatar:getHeight() or 20) > 0 then
					local newPos = {
						x = pos.x + size.width / 2 - width / 2,
						y = pos.y - height - 20
					}

					window:setPosition(newPos)

					local arrow = window.arrow_down

					if arrow then
						arrowDirection = "down"
					end

					if newPos.x < 0 then
						newPos.x = newPos.x + width / 2 - arrow:getWidth()

						window:setPosition(newPos)
						arrow:breakAnchors()
						arrow:addAnchor(AnchorLeft, "parent", AnchorLeft)
						arrow:addAnchor(AnchorVerticalCenter, "parent", AnchorBottom)
						arrow:setMarginLeft(20)
						arrow:setMarginRight(0)
					elseif newPos.x + width > g_window.getWidth() then
						newPos.x = newPos.x - width / 2 + arrow:getWidth()

						window:setPosition(newPos)
						arrow:breakAnchors()
						arrow:addAnchor(AnchorRight, "parent", AnchorRight)
						arrow:addAnchor(AnchorVerticalCenter, "parent", AnchorBottom)
						arrow:setMarginLeft(0)
						arrow:setMarginRight(20)
					else
						arrow:breakAnchors()
						arrow:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
						arrow:addAnchor(AnchorVerticalCenter, "parent", AnchorBottom)
						arrow:setMarginLeft(0)
						arrow:setMarginRight(0)
					end

					return true
				end

				return false
			end

			local function checkBottom()
				if pos.y + height + (window.bandit_avatar:isVisible() and window.bandit_avatar:getHeight() or 20) > 0 then
					local newPos = {
						x = pos.x + size.width / 2 - width / 2,
						y = pos.y + size.height + 20
					}

					window:setPosition(newPos)

					local arrow = window.arrow_down

					if arrow then
						arrowDirection = "up"
					end

					if newPos.x < 0 then
						newPos.x = newPos.x + width / 2 - arrow:getWidth()

						window:setPosition(newPos)
						arrow:breakAnchors()
						arrow:addAnchor(AnchorLeft, "parent", AnchorLeft)
						arrow:addAnchor(AnchorVerticalCenter, "parent", AnchorTop)
						arrow:setMarginLeft(20)
						arrow:setMarginRight(0)
					elseif newPos.x + width > g_window.getWidth() then
						newPos.x = newPos.x - width / 2 + arrow:getWidth()

						window:setPosition(newPos)
						arrow:breakAnchors()
						arrow:addAnchor(AnchorRight, "parent", AnchorRight)
						arrow:addAnchor(AnchorVerticalCenter, "parent", AnchorTop)
						arrow:setMarginLeft(0)
						arrow:setMarginRight(20)
					else
						arrow:breakAnchors()
						arrow:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
						arrow:addAnchor(AnchorVerticalCenter, "parent", AnchorTop)
						arrow:setMarginLeft(0)
						arrow:setMarginRight(0)
					end

					return true
				end

				return false
			end

			local checkOrder = {
				{
					checkLeft,
					"left"
				},
				{
					checkRight,
					"right"
				},
				{
					checkTop,
					"top"
				},
				{
					checkBottom,
					"bottom"
				}
			}

			table.sort(checkOrder, function(a, b)
				return a[2] == window.data.preferSide and true or false
			end)

			for _, check in ipairs(checkOrder) do
				if check[1]() then
					break
				end
			end

			local checkHeight = window:getY() - (window.bandit_avatar:isVisible() and window.bandit_avatar:getHeight() or 20) + 20 < 0

			if not arrowDirection or checkHeight then
				local arrow = window.arrow_up

				if not arrow then
					return
				end

				local newPos = {
					x = pos.x + size.width / 2 - width / 2,
					y = pos.y + size.height + 20
				}

				if arrowDirection == "right" then
					newPos.x = newPos.x - width / 2 + arrow:getWidth()

					window:setPosition(newPos)
					arrow:breakAnchors()
					arrow:addAnchor(AnchorRight, "parent", AnchorRight)
					arrow:addAnchor(AnchorVerticalCenter, "parent", AnchorTop)
					arrow:setMarginLeft(0)
					arrow:setMarginRight(20)
				elseif arrowDirection == "left" then
					newPos.x = newPos.x + width / 2 - arrow:getWidth()

					window:setPosition(newPos)
					arrow:breakAnchors()
					arrow:addAnchor(AnchorLeft, "parent", AnchorLeft)
					arrow:addAnchor(AnchorVerticalCenter, "parent", AnchorTop)
					arrow:setMarginLeft(20)
					arrow:setMarginRight(0)
				end

				arrowDirection = "up"
			end

			local arrow = window["arrow_" .. arrowDirection]

			if arrow then
				arrow.reverseAnimation = false

				arrow:show()
				self:animateArrow(arrow)
			end
		end

		followParent()

		window.followParent = followParent
		window.parent = data.parent

		table.insert(self.connections, connect(self.description_window, {
			onFocusChange = self.descriptionBoxFollowParent
		}))

		local topParent = data.parent:getTopParent(modules.game_interface.getHUDPanel())

		table.insert(self.connections, connect(topParent, {
			onRaise = function()
				addEvent(function()
					self.description_window:raise()
				end)
			end
		}))
		table.insert(self.connections, connect(data.parent, {
			onGeometryChange = self.descriptionBoxFollowParent,
			onVisibilityChange = function(widget, visible)
				if visible and self.bandit_avatar:isVisible() then
					self.description_window:show()

					if self.description_window.followParent then
						self.description_window.followParent()
					end

					addEvent(function()
						self.description_window:raise()
					end)
				else
					self.description_window:hide()
				end
			end
		}))
	elseif data.tilePos then
		local tile = g_map.getTile(data.tilePos)

		if tile then
			table.insert(self.connections, connect(LocalPlayer, {
				onPositionChange = self.tileDescriptionBoundsCheck
			}))

			window.tilePos = data.tilePos

			window:setMarginLeft(20)
			window:setMarginTop(-tile:getTopUseThing():getThingType():getExactHeight() - 40)
			tile:setInteractionWidget(window)

			local arrow = window.arrow_down

			if arrow then
				arrow:breakAnchors()
				arrow:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
				arrow:addAnchor(AnchorVerticalCenter, "parent", AnchorBottom)
				arrow:setMarginLeft(0)
				arrow:setMarginRight(0)

				arrow.reverseAnimation = false

				arrow:show()
				self:animateArrow(arrow)
			end

			self:tileDescriptionBoundsCheck()
		end
	elseif data.creatureId then
		local creature = g_map.getCreatureById(data.creatureId)

		table.insert(self.connections, connect(creature, {
			onPositionChange = self.creatureDescriptionBoundsCheck
		}))
		table.insert(self.connections, connect(LocalPlayer, {
			onPositionChange = self.creatureDescriptionBoundsCheck
		}))

		window.creatureId = data.creatureId

		local arrow = window.arrow_down

		if arrow then
			arrow.reverseAnimation = false

			arrow:show()
			self:animateArrow(arrow)
		end

		if creature then
			window:setMarginLeft(20)
			window:setMarginTop(-creature:getThingType():getExactHeight() - 40)

			if data.offset then
				window:setMarginLeft(window:getMarginLeft() + data.offset.x)
				window:setMarginTop(window:getMarginTop() + data.offset.y)
			end

			creature:setInteractionWidget(window)
		end
	end

	addEvent(function()
		self:resizeDescriptionBox()
		self:changeDescriptionBoxPage(forcePage or 1)
		window:raise()
	end)
end

function GameInteractions:resizeDescriptionBox()
	local window = self.description_window

	if not window then
		return
	end

	local content = window.content
	local height = window.content:getPaddingTop() + window:getPaddingBottom() + 15

	for _, child in ipairs(content:getChildren()) do
		if child:isVisible() then
			height = height + child:getHeight() + child:getMarginTop() + child:getMarginBottom()
		end
	end

	window:setHeight(height)
	addEvent(function()
		self.onDescriptionBoxPositionChange(window, window:getPosition())
	end)

	if window.followParent then
		window.followParent()
	end
end

function GameInteractions:changeDescriptionBoxPage(direction, userInput)
	local window = self.description_window

	if not window then
		return
	end

	if tonumber(direction) then
		window.currentPage = direction
	end

	local button_panel = window.content.button_panel
	local currentPage = window.currentPage or 1
	local pages = window.pages
	local nextPage = currentPage + (direction == "next" and 1 or direction == "previous" and -1 or 0)

	if nextPage > #pages then
		nextPage = #pages
	elseif nextPage < 1 then
		nextPage = 1
	end

	window.currentPage = nextPage

	window.content.text:setText(pages[nextPage].text)
	button_panel.page_text:setText(tr(string.format("|%i| of |%i|", nextPage, #pages)))
	button_panel.prev_button:setOn(nextPage > 1)
	button_panel.prev_button:setEnabled(window.currentPage > 1)
	button_panel.next_button:setOn(nextPage < #pages)
	button_panel.next_button:setEnabled(window.currentPage < #pages)

	if userInput and pages[nextPage].callback then
		pages[nextPage].callback(window.data)
	end

	if window.data.newParent ~= nil then
		window.parent = window.data.newParent
		window.data.newParent = nil
		window.data.parent = window.parent

		self:closeDescriptionBox()
		self:displayDescriptionBox(window.data, window.currentPage)

		return
	end

	button_panel.close_button:setVisible(nextPage == #pages)
	button_panel:update()
	window:raise()
	self:resizeDescriptionBox()
end

function GameInteractions.onDescriptionBoxPositionChange(widget, position)
	local self = GameInteractions
	local window = self.description_window

	if not window then
		return
	end

	local bandit = window.bandit_avatar

	if not bandit or not bandit:isVisible() then
		return
	end

	local x = position.x + widget:getWidth() / 2 - bandit:getWidth() / 2
	local y = position.y - bandit:getHeight() / 2 - 20

	bandit:setPosition({
		x = x,
		y = y
	})
	bandit:raise()

	for _, name in ipairs({
		"arrow_left",
		"arrow_right",
		"arrow_down",
		"arrow_up"
	}) do
		local arrow = window[name]

		if arrow and arrow:isVisible() then
			self:animateArrow(arrow)
		end
	end
end

function GameInteractions:animateArrow(arrow)
	local self = GameInteractions

	if self.arrow_event then
		removeEvent(self.arrow_event)
	end

	local direction = arrow:getId():match("arrow_(%a+)")
	local xChange = direction == "left" and -1 or direction == "right" and 1 or 0
	local yChange = direction == "up" and -1 or direction == "down" and 1 or 0
	local maxChange = 5
	local change = 0

	self.arrow_event = cycleEvent(function()
		if change == maxChange then
			arrow.reverseAnimation = true
		elseif change == 0 then
			arrow.reverseAnimation = false
		end

		if arrow.reverseAnimation then
			change = change - 1
		else
			change = change + 1
		end

		local x = xChange * change
		local y = yChange * change

		arrow:setImageOffset({
			x = x,
			y = y
		})
	end, 150)
end

function GameInteractions.descriptionBoxFollowParent()
	local self = GameInteractions
	local window = self.description_window

	if not window then
		return
	end

	window:raise()

	if window.followParent then
		window:followParent()
	end
end

function GameInteractions.tileDescriptionBoundsCheck()
	local self = GameInteractions
	local window = self.description_window

	if not window then
		return
	end

	if not window.tilePos then
		window:hide()

		return
	end

	local tile = g_map.getTile(window.tilePos)

	if not tile then
		window:hide()

		return
	end

	local player = g_game.getLocalPlayer()

	if not player then
		tile:setInteractionWidget(nil)
		window:hide()

		return
	end

	if not Position.canSee(tile:getPosition(), player:getPosition()) then
		tile:setInteractionWidget(nil)
		window:hide()
	else
		tile:setInteractionWidget(window)
		window:show()

		local arrow = window.arrow_down

		if arrow then
			self:animateArrow(arrow)
		end
	end
end

function GameInteractions:closeDescriptionBox(userInput)
	local window = self.description_window

	if not window then
		return
	end

	if window.tilePos then
		local tile = g_map.getTile(window.tilePos)

		if tile then
			tile:setInteractionWidget(nil)
		end
	end

	if window.creatureId then
		local creature = g_map.getCreatureById(window.creatureId)

		if creature then
			creature:setInteractionWidget(nil)
		end
	end

	for _, disconnectTable in pairs(self.connections) do
		for _, disconnect in pairs(disconnectTable) do
			disconnect()
		end
	end

	self.connections = {}

	window:hide()

	if userInput and window.data and window.data.callbackOnClose then
		local func = window.data.callbackOnClose

		window.data.callbackOnClose = nil

		func()
	end
end

function GameInteractions:closeActionBox()
	local window = self.action_window

	if not window then
		return
	end

	if window.tilePos then
		local tile = g_map.getTile(window.tilePos)

		if tile then
			tile:setInteractionWidget(nil)
		end
	end

	if window.creatureId then
		local creature = g_map.getCreatureById(window.creatureId)

		if creature then
			creature:setInteractionWidget(nil)
		end
	end

	for _, disconnectTable in pairs(self.connections) do
		for _, disconnect in pairs(disconnectTable) do
			disconnect()
		end
	end

	self.connections = {}

	window:hide()
end

function GameInteractions:displayActionBox(data)
	local window = self.action_window

	if not window then
		return
	end

	local content = window.content

	content.text:setText(data.text)

	local keys_panel = content.keys_panel

	keys_panel:destroyChildren()

	for i, key in ipairs(data.keys) do
		local keyWidget

		if key == MouseLeftButton then
			keyWidget = g_ui.createWidget("GameInteractionsMouseLeftKey", keys_panel)
		elseif key == MouseRightButton then
			keyWidget = g_ui.createWidget("GameInteractionsMouseRightKey", keys_panel)
		elseif type(key) == "string" then
			if key:lower() == "arrows" then
				keyWidget = g_ui.createWidget("GameInteractionsArrowKeys", keys_panel)
			elseif key:lower() == "wasd" then
				keyWidget = g_ui.createWidget("GameInteractionsWASDKeys", keys_panel)
			else
				keyWidget = g_ui.createWidget("GameInteractionsKey", keys_panel)

				keyWidget:setText(key)
			end
		end

		local spacer = data.keySpacer or "GameInteractionsKeySpacer"

		if i < #data.keys then
			local separator = g_ui.createWidget(spacer, keys_panel)
		end
	end

	window.bandit_avatar:setVisible(data.bandit and not modules.game_settings.getOption("hideBanditTutorial"))
	content.keys_panel:setMarginTop(data.bandit and 10 or 0)

	window.data = data

	window:show()
	keys_panel:update()
	self:resizeActionBox()

	for _, name in ipairs({
		"arrow_left",
		"arrow_right",
		"arrow_down",
		"arrow_up"
	}) do
		local arrow = window[name]

		if arrow then
			arrow:hide()
		end
	end

	if data.parent then
		local function followParent()
			for _, name in ipairs({
				"arrow_left",
				"arrow_right",
				"arrow_down",
				"arrow_up"
			}) do
				local arrow = window[name]

				if arrow then
					arrow:hide()
				end
			end

			local arrowDirection
			local pos = data.parent:getPosition()
			local size = data.parent:getSize()
			local width = window:getWidth()
			local height = window:getHeight()

			local function checkLeft()
				if pos.x - width - 50 > 0 then
					local newPos = {
						x = pos.x - width - 50,
						y = pos.y + size.height / 2 - height / 2
					}

					window:setPosition(newPos)

					local arrow = window.arrow_right

					if arrow then
						arrowDirection = "right"
					end

					return true
				end

				return false
			end

			local function checkRight()
				if pos.x + size.width + width + 20 < g_window.getWidth() then
					local newPos = {
						x = pos.x + size.width + 20,
						y = pos.y + size.height / 2 - height / 2
					}

					window:setPosition(newPos)

					local arrow = window.arrow_left

					if arrow then
						arrowDirection = "left"
					end

					return true
				end

				return false
			end

			local function checkTop()
				if pos.y - height - (window.bandit_avatar:isVisible() and window.bandit_avatar:getHeight() or 20) > 0 then
					local newPos = {
						x = pos.x + size.width / 2 - width / 2,
						y = pos.y - height - 20
					}

					window:setPosition(newPos)

					local arrow = window.arrow_down

					if arrow then
						arrowDirection = "down"
					end

					if newPos.x < 0 then
						newPos.x = newPos.x + width / 2 - arrow:getWidth()

						window:setPosition(newPos)
						arrow:breakAnchors()
						arrow:addAnchor(AnchorLeft, "parent", AnchorLeft)
						arrow:addAnchor(AnchorVerticalCenter, "parent", AnchorBottom)
						arrow:setMarginLeft(20)
						arrow:setMarginRight(0)
					elseif newPos.x + width > g_window.getWidth() then
						newPos.x = newPos.x - width / 2 + arrow:getWidth()

						window:setPosition(newPos)
						arrow:breakAnchors()
						arrow:addAnchor(AnchorRight, "parent", AnchorRight)
						arrow:addAnchor(AnchorVerticalCenter, "parent", AnchorBottom)
						arrow:setMarginLeft(0)
						arrow:setMarginRight(20)
					else
						arrow:breakAnchors()
						arrow:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
						arrow:addAnchor(AnchorVerticalCenter, "parent", AnchorBottom)
						arrow:setMarginLeft(0)
						arrow:setMarginRight(0)
					end

					return true
				end

				return false
			end

			local function checkBottom()
				if pos.y + height + (window.bandit_avatar:isVisible() and window.bandit_avatar:getHeight() or 20) > 0 then
					local newPos = {
						x = pos.x + size.width / 2 - width / 2,
						y = pos.y + size.height + 20
					}

					window:setPosition(newPos)

					local arrow = window.arrow_down

					if arrow then
						arrowDirection = "up"
					end

					if newPos.x < 0 then
						newPos.x = newPos.x + width / 2 - arrow:getWidth()

						window:setPosition(newPos)
						arrow:breakAnchors()
						arrow:addAnchor(AnchorLeft, "parent", AnchorLeft)
						arrow:addAnchor(AnchorVerticalCenter, "parent", AnchorTop)
						arrow:setMarginLeft(20)
						arrow:setMarginRight(0)
					elseif newPos.x + width > g_window.getWidth() then
						newPos.x = newPos.x - width / 2 + arrow:getWidth()

						window:setPosition(newPos)
						arrow:breakAnchors()
						arrow:addAnchor(AnchorRight, "parent", AnchorRight)
						arrow:addAnchor(AnchorVerticalCenter, "parent", AnchorTop)
						arrow:setMarginLeft(0)
						arrow:setMarginRight(20)
					else
						arrow:breakAnchors()
						arrow:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
						arrow:addAnchor(AnchorVerticalCenter, "parent", AnchorTop)
						arrow:setMarginLeft(0)
						arrow:setMarginRight(0)
					end

					return true
				end

				return false
			end

			local checkOrder = {
				{
					checkLeft,
					"left"
				},
				{
					checkRight,
					"right"
				},
				{
					checkTop,
					"top"
				},
				{
					checkBottom,
					"bottom"
				}
			}

			table.sort(checkOrder, function(a, b)
				return a[2] == window.data.preferSide and true or false
			end)

			for _, check in ipairs(checkOrder) do
				if check[1]() then
					break
				end
			end

			local checkHeight = window:getY() - (window.bandit_avatar:isVisible() and window.bandit_avatar:getHeight() or 20) + 20 < 0

			if not arrowDirection or checkHeight then
				local arrow = window.arrow_up

				if not arrow then
					return
				end

				local newPos = {
					x = pos.x + size.width / 2 - width / 2,
					y = pos.y + size.height + 20
				}

				if arrowDirection == "right" then
					newPos.x = newPos.x - width / 2 + arrow:getWidth()

					window:setPosition(newPos)
					arrow:breakAnchors()
					arrow:addAnchor(AnchorRight, "parent", AnchorRight)
					arrow:addAnchor(AnchorVerticalCenter, "parent", AnchorTop)
					arrow:setMarginLeft(0)
					arrow:setMarginRight(20)
				elseif arrowDirection == "left" then
					newPos.x = newPos.x + width / 2 - arrow:getWidth()

					window:setPosition(newPos)
					arrow:breakAnchors()
					arrow:addAnchor(AnchorLeft, "parent", AnchorLeft)
					arrow:addAnchor(AnchorVerticalCenter, "parent", AnchorTop)
					arrow:setMarginLeft(20)
					arrow:setMarginRight(0)
				end

				arrowDirection = "up"
			end

			local arrow = window["arrow_" .. arrowDirection]

			if arrow then
				arrow.reverseAnimation = false

				arrow:show()
				self:animateArrow(arrow)
			end
		end

		followParent()

		window.followParent = followParent
		window.parent = data.parent

		table.insert(self.connections, connect(self.action_window, {
			onFocusChange = self.actionBoxFollowParent
		}))

		local topParent = data.parent:getTopParent(modules.game_interface.getHUDPanel())

		table.insert(self.connections, connect(topParent, {
			onRaise = function()
				addEvent(function()
					self.action_window:raise()
				end)
			end
		}))
		table.insert(self.connections, connect(data.parent, {
			onGeometryChange = self.actionBoxFollowParent,
			onVisibilityChange = function(widget, visible)
				if visible then
					self.action_window:show()

					if self.action_window.followParent then
						self.action_window.followParent()
					end

					addEvent(function()
						self.action_window:raise()
					end)
				else
					self.action_window:hide()
				end
			end
		}))
	elseif data.tilePos then
		table.insert(self.connections, connect(LocalPlayer, {
			onPositionChange = self.tileActionBoundsCheck
		}))

		local arrow = window.arrow_down

		if arrow then
			arrow:breakAnchors()
			arrow:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
			arrow:addAnchor(AnchorVerticalCenter, "parent", AnchorBottom)
			arrow:setMarginLeft(0)
			arrow:setMarginRight(0)

			arrow.reverseAnimation = false

			arrow:show()
			self:animateArrow(arrow)
		end

		window.tilePos = data.tilePos

		local tile = g_map.getTile(data.tilePos)

		if tile then
			window:setMarginLeft(20)
			window:setMarginTop(-tile:getTopUseThing():getThingType():getExactHeight() - 40)
			tile:setInteractionWidget(window)
			window:show()
			self:tileActionBoundsCheck()
		else
			window:hide()
		end
	elseif data.creatureId then
		local creature = g_map.getCreatureById(data.creatureId)

		table.insert(self.connections, connect(creature, {
			onPositionChange = self.creatureActionBoundsCheck
		}))
		table.insert(self.connections, connect(LocalPlayer, {
			onPositionChange = self.creatureActionBoundsCheck
		}))

		window.creatureId = data.creatureId

		local arrow = window.arrow_down

		if arrow then
			arrow:breakAnchors()
			arrow:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
			arrow:addAnchor(AnchorVerticalCenter, "parent", AnchorBottom)
			arrow:setMarginLeft(0)
			arrow:setMarginRight(0)

			arrow.reverseAnimation = false

			arrow:show()
			self:animateArrow(arrow)
		end

		if creature then
			window:setMarginLeft(20)
			window:setMarginTop(-creature:getThingType():getExactHeight() - 40)

			if data.offset then
				window.offset = data.offset

				window:setMarginLeft(window:getMarginLeft() + data.offset.x)
				window:setMarginTop(window:getMarginTop() + data.offset.y)
			end

			creature:setInteractionWidget(window)
		end
	end

	addEvent(function()
		window:raise()
	end)
end

function GameInteractions:resizeActionBox()
	local window = self.action_window

	if not window then
		return
	end

	local widthChanged = false

	if window.realWidth then
		window:setWidth(window.realWidth)

		window.realWidth = nil
		widthChanged = true
	end

	if window.data and window.data.width then
		window.realWidth = window:getWidth()

		window:setWidth(window.data.width)

		widthChanged = true
	end

	local content = window.content
	local height = window.content:getPaddingTop() + window:getPaddingBottom() + 5

	for _, child in ipairs(content:getChildren()) do
		if child:isVisible() then
			height = height + child:getHeight() + child:getMarginTop() + child:getMarginBottom()
		end
	end

	window:setHeight(height)
	addEvent(function()
		if widthChanged then
			height = window.content:getPaddingTop() + window:getPaddingBottom() + 5

			for _, child in ipairs(content:getChildren()) do
				if child:isVisible() then
					height = height + child:getHeight() + child:getMarginTop() + child:getMarginBottom()
				end
			end

			window:setHeight(height)
		end

		self.onDescriptionBoxPositionChange(window, window:getPosition())
	end)

	if window.followParent then
		window.followParent()
	end
end

function GameInteractions.actionBoxFollowParent()
	local self = GameInteractions
	local window = self.action_window

	if not window then
		return
	end

	window:raise()

	if window.followParent then
		window:followParent()
	end
end

function GameInteractions.tileActionBoundsCheck()
	local self = GameInteractions
	local window = self.action_window

	if not window then
		return
	end

	if not window.tilePos then
		window:hide()

		return
	end

	local tile = g_map.getTile(window.tilePos)

	if not tile then
		window:hide()

		return
	end

	local player = g_game.getLocalPlayer()

	if not player then
		tile:setInteractionWidget(nil)
		window:hide()

		return
	end

	if not Position.canSee(tile:getPosition(), player:getPosition()) then
		tile:setInteractionWidget(nil)
		window:hide()
	else
		tile:setInteractionWidget(window)
		window:setMarginLeft(20)
		window:setMarginTop(-tile:getTopUseThing():getThingType():getExactHeight() - 40)
		window:show()

		local arrow = window.arrow_down

		if arrow then
			self:animateArrow(arrow)
		end
	end
end

function GameInteractions.creatureDescriptionBoundsCheck()
	local self = GameInteractions
	local window = self.description_window

	if not window then
		return
	end

	if not window.creatureId then
		window:hide()

		return
	end

	local creature = g_map.getCreatureById(window.creatureId)

	if not creature then
		window:hide()

		return
	end

	local player = g_game.getLocalPlayer()

	if not player then
		creature:setInteractionWidget(nil)
		window:hide()

		return
	end

	if not Position.canSee(creature:getPosition(), player:getPosition()) then
		creature:setInteractionWidget(nil)
		window:hide()
	else
		creature:setInteractionWidget(window)
		window:setMarginLeft(20)
		window:setMarginTop(-creature:getThingType():getExactHeight() - 40)
		window:show()

		local arrow = window.arrow_down

		if arrow then
			self:animateArrow(arrow)
		end
	end
end

function GameInteractions.creatureActionBoundsCheck()
	local self = GameInteractions
	local window = self.action_window

	if not window then
		return
	end

	if not window.creatureId then
		window:hide()

		return
	end

	local creature = g_map.getCreatureById(window.creatureId)

	if not creature then
		window:hide()

		return
	end

	local player = g_game.getLocalPlayer()

	if not player then
		creature:setInteractionWidget(nil)
		window:hide()

		return
	end

	if not Position.canSee(creature:getPosition(), player:getPosition()) then
		creature:setInteractionWidget(nil)
		window:hide()
	else
		creature:setInteractionWidget(window)
		window:setMarginLeft(20)
		window:setMarginTop(-creature:getThingType():getExactHeight() - 40)

		if window.data.offset then
			window:setMarginLeft(window:getMarginLeft() + window.data.offset.x)
			window:setMarginTop(window:getMarginTop() + window.data.offset.y)
		end

		window:show()

		local arrow = window.arrow_down

		if arrow then
			self:animateArrow(arrow)
		end
	end
end

function GameInteractions.onGameEnd()
	local self = GameInteractions

	self:closeActionBox()
	self:closeDescriptionBox()
	self:disconnectAllInteractions()

	self.last_tile_pos = nil
	self.last_creature_id = nil
	self.wasBanditVisibleBeforeLayoutChange = nil
	self.custom_interactions = {
		available = {}
	}
end

function GameInteractions:loadConnections()
	connect(modules.game_questlog.GameQuestLog, {
		onTaskUpdate = self.onTaskUpdate
	})
end

function GameInteractions:unloadConnections()
	disconnect(modules.game_questlog.GameQuestLog, {
		onTaskUpdate = self.onTaskUpdate
	})
end

function GameInteractions:disconnectAllInteractions()
	for _, interaction in pairs(interactions) do
		interaction.current_task = 0
		interaction.current_interaction = 0

		if interaction.callbacks and interaction.callbacks.onGameEnd then
			interaction.callbacks.onGameEnd()
		end

		if interaction.tasks then
			for _, task in pairs(interaction.tasks) do
				for _, interaction in pairs(task) do
					if interaction.disconnects then
						for _, disconnectTable in pairs(interaction.disconnects) do
							for _, disconnect in pairs(disconnectTable) do
								disconnect()
							end
						end

						interaction.disconnects = {}
					end
				end
			end
		end
	end
end

function GameInteractions.onTaskUpdate(task)
	addEvent(function()
		for _, interaction in pairs(interactions) do
			if interaction.callbacks and interaction.callbacks.onTaskUpdate then
				interaction.callbacks.onTaskUpdate(task)
			end
		end
	end)
end

function GameInteractions.onCustomInteraction(data)
	local self = GameInteractions
	local interaction = self.custom_interactions.active

	if not interaction then
		return
	end

	if interaction.callbacks and interaction.callbacks.onCustomInteraction then
		interaction.callbacks.onCustomInteraction(data)
	end
end

function GameInteractions:advanceInteraction(env, currentTask, currentInteraction, args)
	self:closeActionBox()
	self:closeDescriptionBox()

	if env.tasks then
		for _, task in pairs(env.tasks) do
			for _, interaction in pairs(task) do
				if interaction.disconnects then
					for _, disconnectTable in pairs(interaction.disconnects) do
						for _, disconnect in pairs(disconnectTable) do
							disconnect()
						end
					end

					interaction.disconnects = {}
				end
			end
		end
	end

	if currentTask ~= env.current_task then
		env.current_task = currentTask
	end

	if env.current_interaction ~= currentInteraction then
		env.current_interaction = currentInteraction
	end

	env.current_interaction = env.current_interaction + 1

	if env.callbacks.onCustomInteraction then
		self:sendOpcode({
			action = "advance_interaction",
			interactionName = env.quest_name,
			stage = env.current_task
		})
	end

	if env.tasks[env.current_task] and env.tasks[env.current_task][env.current_interaction] and self:isTutorialEnabled() then
		env.tasks[env.current_task][env.current_interaction].onStartInteraction(env.tasks[env.current_task][env.current_interaction], args)
	else
		env.current_interaction = 0
	end

	self:saveInteractionProgress(env, env.current_task, env.current_interaction)
end

function GameInteractions:advanceTask(env)
	env.current_task = env.current_task + 1
	env.current_interaction = 0

	if not env.tasks[env.current_task] then
		self:sendOpcode({
			action = "complete_interaction",
			interactionName = env.quest_name
		})
	end

	self:advanceInteraction(env, env.current_task, env.current_interaction)
end

function GameInteractions:completeInteraction(env)
	self:closeActionBox()
	self:closeDescriptionBox()

	if env.callbacks.onCompleteInteraction then
		env.callbacks.onCompleteInteraction()
	end

	self:sendOpcode({
		action = "complete_interaction",
		interactionName = env.quest_name
	})
	self:disconnectAllInteractions()

	self.custom_interactions.available[env.quest_name] = nil
	self.custom_interactions.active = nil

	addEvent(function()
		self:configureListWindow()
	end)
end

function GameInteractions:saveInteractionProgress(env, currentTask, currentInteraction)
	if env.current_task ~= currentTask then
		env.current_task = currentTask
	end

	if env.current_interaction ~= currentInteraction then
		env.current_interaction = currentInteraction
	end

	local progress = {
		current_task = env.current_task,
		current_interaction = env.current_interaction
	}
	local interactions = g_settings.getNode("tutorial_interaction") or {}

	interactions[g_game.getCharacterName()] = interactions[g_game.getCharacterName()] or {}
	interactions[g_game.getCharacterName()][env.quest_name] = progress

	g_settings.setNode("tutorial_interaction", interactions)
	g_settings.save()
end

function GameInteractions.onQuestsUpdate(data)
	local self = GameInteractions

	self.onGameStart()
end

function GameInteractions:loadInteractionProgress(env)
	local interactions = g_settings.getNode("tutorial_interaction") or {}

	interactions = interactions[g_game.getCharacterName()] or {}

	local progress = interactions[env.quest_name]
	local questLog = modules.game_questlog.GameQuestLog

	if questLog and questLog:isQuestActive(env.quest_name) then
		if progress and questLog:isQuestTasksActive(env.quest_name, progress.current_task, true) then
			env.current_task = progress.current_task
			env.current_interaction = progress.current_interaction
		else
			env.current_interaction = 0
			env.current_task = 0

			for taskId in pairs(env.tasks) do
				if questLog:isQuestTasksActive(env.quest_name, taskId, true) then
					env.current_task = taskId
					env.current_interaction = 1

					break
				end
			end
		end
	end

	if env.tasks and env.tasks[env.current_task] and env.tasks[env.current_task][env.current_interaction] and self:isTutorialEnabled() then
		env.tasks[env.current_task][env.current_interaction].onStartInteraction(env.tasks[env.current_task][env.current_interaction])
	end
end

function GameInteractions.onGameStart()
	local self = GameInteractions

	for _, interaction in pairs(interactions) do
		self:loadInteractionProgress(interaction)

		if interaction.callbacks and interaction.callbacks.onGameStart then
			interaction.callbacks.onGameStart()
		end
	end
end

function GameInteractions:updateBanditAvatarLayoutChange()
	local isEditMode = g_layout.isEditMode()

	if isEditMode then
		self.wasBanditVisibleBeforeLayoutChange = isEditMode and self.bandit_avatar:isVisible()
	end

	self.bandit_avatar:setVisible(not modules.game_settings.getOption("hideBanditTutorial") and (not isEditMode and self.wasBanditVisibleBeforeLayoutChange or isEditMode))
	self.bandit_avatar.editModeBackground:setVisible(isEditMode)
end

function GameInteractions:onBanditAvatarDragEnter(mousePos)
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

function GameInteractions:onBanditAvatarDragMove(mousePos, mouseMoved)
	local pos = {
		x = mousePos.x - self.movingReference.x,
		y = mousePos.y - self.movingReference.y
	}

	g_layout.snapToGrid(pos)
	self:setPosition(pos)
	self:bindRectToParent()
end

function GameInteractions.onExtendedOpcode(protocol, opcode, buffer)
	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		return
	end

	local self = GameInteractions

	if data.action == "interactions" then
		self.custom_interactions.available = data.interactions.availableInteractions
		self.custom_interactions.active = data.interactions.activeInteraction

		self:checkCustomInteractionTriggers()
	elseif data.action == "unlock_interaction" then
		self.custom_interactions.available[data.interactionName] = data.interaction

		self:checkCustomInteractionTriggers()
	elseif data.action == "activate_interaction" then
		if data.interaction == nil then
			local interaction = interactions[self.custom_interactions.active.name]

			if interaction then
				self:advanceInteraction(interaction, 99, 0)
			end
		elseif (not self.custom_interactions.active or self.custom_interactions.active.name ~= data.interaction.name) and self.custom_interactions.active then
			local interaction = interactions[self.custom_interactions.active.name]

			if interaction then
				self:advanceInteraction(interaction, 99, 0)
			end
		end

		self.custom_interactions.active = data.interaction

		self:checkCustomInteractionTriggers()
	elseif data.action == "complete_interaction" and self.custom_interactions.active and self.custom_interactions.active.name:lower() == data.interaction:lower() and self.custom_interactions.active then
		local interaction = interactions[self.custom_interactions.active.name]

		if interaction then
			self:advanceInteraction(interaction, 99, 0)
		end

		self.custom_interactions.active = nil

		self:checkCustomInteractionTriggers()
	end

	addEvent(function()
		self:configureListWindow()
	end)
end

function GameInteractions:sendOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.Interactions, g_game.serializeTable(data))
	end
end

function GameInteractions:checkCustomInteractionTriggers(dontUpdateVisibility)
	if self.bandit_avatar.shakeEvent then
		removeEvent(self.bandit_avatar.shakeEvent)

		self.bandit_avatar.shakeEvent = nil
	end

	if not dontUpdateVisibility then
		self.bandit_avatar:setVisible(false)
	end

	self.wasBanditVisibleBeforeLayoutChange = false

	if self.custom_interactions.active then
		if not dontUpdateVisibility then
			self.bandit_avatar:setVisible(not modules.game_settings.getOption("hideBanditTutorial"))
		end

		self.wasBanditVisibleBeforeLayoutChange = true

		local interaction = interactions[self.custom_interactions.active.name]

		if interaction and interaction.callbacks and interaction.callbacks.onCustomInteraction then
			interaction.callbacks.onCustomInteraction(self.custom_interactions.active)
		end
	elseif not table.empty(self.custom_interactions.available) then
		if not dontUpdateVisibility then
			self.bandit_avatar:setVisible(not modules.game_settings.getOption("hideBanditTutorial"))
		end

		self.wasBanditVisibleBeforeLayoutChange = true

		self:banditShake()
	end
end

function GameInteractions:banditShake()
	local widget = self.bandit_avatar.bandit

	if not widget or not widget:isVisible() then
		return
	end

	if self.shakeEvent then
		return
	end

	local function shake(self, n, intensity, internal)
		if not internal and self.shakeEvent then
			return
		end

		intensity, n = intensity or 2, n or 10

		self:setImageOffset({
			x = 0,
			y = 0
		})

		if n > 0 then
			local offset = n % 2 == 0 and intensity or -intensity

			self:setImageOffset({
				y = 0,
				x = self:getImageOffsetX() + offset
			})

			self.shakeEvent = scheduleEvent(function()
				shake(self, n - 1, intensity, true)
			end, 100)
		else
			self.shakeEvent = nil
		end
	end

	shake(widget, 5, 1)
	scheduleEvent(function()
		self:banditShake()
	end, 10000)
end

function GameInteractions:configureListWindow()
	self.list_window.content:destroyChildren()

	local options = {}
	local height = 0

	if self.custom_interactions.available then
		for interactionName, data in pairs(self.custom_interactions.available) do
			if not data.hide then
				local widget = g_ui.createWidget("GameInteractionsListWindowEntry", self.list_window.content)

				widget.name.interactionName = interactionName:lower()
				widget.name.displayName = self.custom_display_names[widget.name.interactionName] and self.custom_display_names[widget.name.interactionName]:titleCase() or interactionName:titleCase()

				widget.name:setText(widget.name.displayName)
				widget.name:update()
				table.insert(options, widget)

				height = height + widget:getHeight()
			end
		end

		table.sort(options, function(a, b)
			return self.custom_interactions.available[a.name.interactionName].index < self.custom_interactions.available[b.name.interactionName].index
		end)
	end

	local anyStarted = self.custom_interactions.active ~= nil and not self.custom_interactions.active.hide

	if anyStarted then
		local widget = g_ui.createWidget("GameInteractionsListWindowEntry", self.list_window.content)

		widget.name.interactionName = self.custom_interactions.active.name:lower()
		widget.name.displayName = self.custom_display_names[widget.name.interactionName] and self.custom_display_names[widget.name.interactionName]:titleCase() or self.custom_interactions.active.name:titleCase()

		widget.name:setText(widget.name.displayName)
		widget.name:update()

		height = height + widget:getHeight()

		table.insert(options, 1, widget)
	end

	self.list_window.content:reorderChildren(options)

	local children = self.list_window.content:getChildren()

	if #children > 0 then
		for _, child in ipairs(children) do
			if anyStarted and child.name.interactionName == self.custom_interactions.active.name:lower() then
				child.start_button:setEnabled(false)
				child.cancel_button:setEnabled(true)
				child.active:setVisible(true)
			else
				child.start_button:setEnabled(not anyStarted)
				child.cancel_button:setEnabled(false)
				child.active:setVisible(false)
			end
		end
	else
		self.bandit_avatar:setVisible(false)
	end

	if #options == 0 then
		local widget = g_ui.createWidget("GameInteractionsListWindowEmpty", self.list_window.content)

		height = height + widget:getHeight() + 10
	end

	addEvent(function()
		if not self.list_window.minSize then
			return
		end

		self.list_window:setHeight(self.list_window.minSize.height + height + self.list_window.content:getLayout():getSpacing() * (#options - 1))
	end)
end

function GameInteractions.onBanditAvatarClick()
	local self = GameInteractions

	if not table.empty(self.custom_interactions.available) then
		if not self.list_window:isVisible() then
			self.toggleListWindow()
		else
			local window = GameInteractions.list_window

			if window then
				window:raise()
			end
		end
	end
end

function GameInteractions.onBanditAvatarVisibilityChange(widget, visible)
	local self = GameInteractions

	if not visible then
		self:closeActionBox()
		self:closeDescriptionBox()
	else
		self:checkCustomInteractionTriggers(true)
	end
end

function GameInteractions.toggleListWindow(mouseClick)
	if GameChat:isActive() or (type(mouseClick) ~= "boolean" or not mouseClick) and IsTextEditActive() then
		return
	end

	local window = GameInteractions.list_window

	if not window then
		return
	end

	if window:isVisible() then
		window:hide()
	else
		if g_game:isInCutsceneMode() then
			return
		end

		window:show()
		window:raise()
		GameInteractions:configureListWindow()
	end
end

function GameInteractions:startInteraction(name)
	self:sendOpcode({
		action = "start_interaction",
		interactionName = name
	})
end

function GameInteractions:cancelInteraction(name)
	if self.confirmation_box then
		self.confirmation_box:destroy()

		self.confirmation_box = nil
	end

	local function yesCallback()
		self.confirmation_box:destroy()

		self.confirmation_box = nil

		self:sendOpcode({
			action = "skip_interaction",
			interactionName = name
		})
	end

	local function noCallback()
		self.confirmation_box:destroy()

		self.confirmation_box = nil
	end

	self.confirmation_box = displayGeneralBox(tr("Cancel Interaction"), tr("Are you sure you want to cancel this interaction?"), {
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

function GameInteractions.isEnabled()
	return not g_game.isAetherRiftChannel() and not g_game.isGuildWarsChannel()
end
