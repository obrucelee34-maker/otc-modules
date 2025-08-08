-- chunkname: @/modules/game_prompts/prompts.lua

GamePrompts = {
	connections = {},
	custom_prompts = {
		active = {}
	}
}

function GamePrompts:loadPrompts()
	local directories = g_resources.listDirectoryFiles(resolvepath("prompts"))
	local env = getfenv(0)

	env.prompts = {}

	setmetatable(env.prompts, {
		__index = env
	})

	for _, directory in ipairs(directories) do
		local files = g_resources.listDirectoryFiles(resolvepath("prompts/" .. directory))

		for _, file in ipairs(files) do
			local func, error = loadfile("prompts/" .. directory .. "/" .. file)

			if not func then
				g_logger.fatal(error)

				return false
			end

			env.name = directory
			env.dont_show = {}
			env.save_progress = env.save_progress or true
			file = string.split(file, ".")[1]
			env.prompts[directory] = {}

			setmetatable(env.prompts[directory], {
				__index = env
			})
			setfenv(func, env.prompts[directory])

			env.prompts[directory].__env = env.prompts[directory]

			func()
		end
	end

	return true
end

function GamePrompts:init()
	self:loadConnections()
	self:loadPrompts()
	g_ui.importStyle("styles/action.otui")
	g_ui.importStyle("styles/description.otui")
	g_ui.importStyle("styles/additions.otui")

	self.action_prompt = g_ui.createWidget("GamePromptsActionWindow", modules.game_interface.getHUDPanel())

	self.action_prompt:hide()

	local setActionVisible = self.action_prompt.setVisible

	function self.action_prompt.setVisible(widget, visible)
		setActionVisible(widget, visible and GamePrompts:isPromptsEnabled() and not modules.game_settings.getOption("hideInterface"))
	end

	function self.action_prompt.onVisibilityChange(widget, visible)
		if not visible then
			if self.arrow_event then
				removeEvent(self.arrow_event)
			end
		else
			self:resizeActionBox()
		end
	end

	function self.action_prompt.show()
		self.action_prompt:setVisible(self:isPromptsEnabled() and not modules.game_settings.getOption("hideInterface"))
	end

	function self.action_prompt.hide()
		self.action_prompt:setVisible(false)
	end

	self.description_prompt = g_ui.createWidget("GamePromptsDescriptionWindow", modules.game_interface.getHUDPanel())

	self.description_prompt:hide()

	local setDescriptionVisible = self.description_prompt.setVisible

	function self.description_prompt.setVisible(widget, visible)
		setDescriptionVisible(widget, visible and GamePrompts:isPromptsEnabled() and not modules.game_settings.getOption("hideInterface"))
	end

	self.description_prompt.onPositionChange = self.onDescriptionBoxPositionChange

	function self.description_prompt.onVisibilityChange(widget, visible)
		if not visible then
			if self.arrow_event then
				removeEvent(self.arrow_event)
			end
		else
			self:resizeDescriptionBox()
		end
	end

	function self.description_prompt.show()
		self.description_prompt:setVisible(self:isPromptsEnabled() and not modules.game_settings.getOption("hideInterface"))
	end

	function self.description_prompt.hide()
		self.description_prompt:setVisible(false)
	end

	connect(g_game, {
		onMapKnown = self.onGameStart,
		onGameEnd = self.onGameEnd
	})

	if g_game.isOnline() then
		self.onGameStart()
	end
end

function GamePrompts:terminate()
	GamePrompts:closeActionBox()
	GamePrompts:closeDescriptionBox()
	self.action_prompt:destroy()
	self.description_prompt:destroy()

	if self.arrow_event then
		removeEvent(self.arrow_event)
	end

	disconnect(g_game, {
		onMapKnown = self.onGameStart,
		onGameEnd = self.onGameEnd
	})
	self:unloadConnections()
	self:disconnectAllPrompts()

	GamePrompts = nil
end

function GamePrompts:isPromptsEnabled()
	return true
end

function GamePrompts:displayDescriptionBox(data, forcePage)
	local window = self.description_prompt

	if not window or not self:isPromptsEnabled() then
		return
	end

	if window.tilePos then
		local tile = g_map.getTile(window.tilePos)

		if tile then
			tile:setPromptWidget(nil)
		end
	end

	if window.creatureId then
		local creature = g_map.getCreatureById(window.creatureId)

		if creature then
			creature:setPromptWidget(nil)
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

	content.text:setMarginTop(0)

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
				if pos.y - height - 20 > 0 then
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
				if pos.y + height + 20 > 0 then
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

			local checkHeight = window:getY() < 0

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

		table.insert(self.connections, connect(self.description_prompt, {
			onFocusChange = self.descriptionBoxFollowParent
		}))
		table.insert(self.connections, connect(data.parent, {
			onGeometryChange = self.descriptionBoxFollowParent,
			onVisibilityChange = function(widget, visible)
				if visible then
					self.description_prompt:show()

					if self.description_prompt.followParent then
						self.description_prompt.followParent()
					end

					addEvent(function()
						self.description_prompt:raise()
					end)
				else
					self.description_prompt:hide()
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
			tile:setPromptWidget(window)

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

			creature:setPromptWidget(window)
		end
	end

	addEvent(function()
		self:resizeDescriptionBox()
		self:changeDescriptionBoxPage(forcePage or 1)
		window:raise()
	end)
end

function GamePrompts:resizeDescriptionBox()
	local window = self.description_prompt

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

function GamePrompts:changeDescriptionBoxPage(direction, userInput)
	local window = self.description_prompt

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

function GamePrompts.onDescriptionBoxPositionChange(widget, position)
	local self = GamePrompts
	local window = self.description_prompt

	if not window then
		return
	end

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

function GamePrompts:animateArrow(arrow)
	local self = GamePrompts

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

function GamePrompts.descriptionBoxFollowParent()
	local self = GamePrompts
	local window = self.description_prompt

	if not window then
		return
	end

	if window.followParent then
		window:followParent()
	end
end

function GamePrompts.tileDescriptionBoundsCheck()
	local self = GamePrompts
	local window = self.description_prompt

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
		tile:setPromptWidget(nil)
		window:hide()

		return
	end

	if not Position.canSee(tile:getPosition(), player:getPosition()) then
		tile:setPromptWidget(nil)
		window:hide()
	else
		tile:setPromptWidget(window)
		window:show()

		local arrow = window.arrow_down

		if arrow then
			self:animateArrow(arrow)
		end
	end
end

function GamePrompts:closeDescriptionBox(userInput)
	local window = self.description_prompt

	if not window then
		return
	end

	if window.tilePos then
		local tile = g_map.getTile(window.tilePos)

		if tile then
			tile:setPromptWidget(nil)
		end
	end

	if window.creatureId then
		local creature = g_map.getCreatureById(window.creatureId)

		if creature then
			creature:setPromptWidget(nil)
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

function GamePrompts:closeActionBox()
	local window = self.action_prompt

	if not window then
		return
	end

	if window.tilePos then
		local tile = g_map.getTile(window.tilePos)

		if tile then
			tile:setPromptWidget(nil)
		end
	end

	if window.creatureId then
		local creature = g_map.getCreatureById(window.creatureId)

		if creature then
			creature:setPromptWidget(nil)
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

function GamePrompts:displayActionBox(env, data)
	local window = self.action_prompt

	if not window then
		return
	end

	window.env = env

	local content = window.content

	content.text:addAnchor(AnchorTop, "keys_panel", AnchorBottom)
	content.text:setText(data.text)

	local keys_panel = content.keys_panel

	keys_panel:destroyChildren()
	keys_panel:show()

	if table.size(data.keys) > 0 then
		for i, key in ipairs(data.keys) do
			local keyWidget

			if key == MouseLeftButton then
				keyWidget = g_ui.createWidget("GamePromptsMouseLeftKey", keys_panel)
			elseif key == MouseRightButton then
				keyWidget = g_ui.createWidget("GamePromptsMouseRightKey", keys_panel)
			elseif type(key) == "string" then
				if key:lower() == "arrows" then
					keyWidget = g_ui.createWidget("GamePromptsArrowKeys", keys_panel)
				elseif key:lower() == "wasd" then
					keyWidget = g_ui.createWidget("GamePromptsWASDKeys", keys_panel)
				else
					keyWidget = g_ui.createWidget("GamePromptsKey", keys_panel)

					keyWidget:setText(key)
				end
			end

			local spacer = data.keySpacer or "GamePromptsKeySpacer"

			if i < #data.keys then
				local separator = g_ui.createWidget(spacer, keys_panel)
			end
		end
	else
		keys_panel:hide()
		content.text:addAnchor(AnchorTop, "parent", AnchorTop)
	end

	content.keys_panel:setMarginTop(0)

	window.data = data

	if data.onClick then
		window.content.onClick = data.onClick
		window.content.text.onClick = data.onClick
	end

	local closeButton = window.close_button

	if closeButton and data.closeButton then
		if data.closeButton.customStyle then
			closeButton:setStyle(data.closeButton.customStyle)
		end

		closeButton:breakAnchors()

		if data.closeButton.top then
			closeButton:addAnchor(AnchorTop, "parent", data.closeButton.top)

			data.closeButton.static = true
		end

		if data.closeButton.bottom then
			closeButton:addAnchor(AnchorBottom, "parent", data.closeButton.bottom)

			data.closeButton.static = true
		end

		if data.closeButton.left then
			closeButton:addAnchor(AnchorLeft, "parent", data.closeButton.left)

			data.closeButton.static = true
		end

		if data.closeButton.right then
			closeButton:addAnchor(AnchorRight, "parent", data.closeButton.right)

			data.closeButton.static = true
		end

		if data.closeButton.horizontalCenter then
			closeButton:addAnchor(AnchorHorizontalCenter, "parent", data.closeButton.horizontalCenter)

			data.closeButton.static = true
		end

		if data.closeButton.verticalCenter then
			closeButton:addAnchor(AnchorVerticalCenter, "parent", data.closeButton.verticalCenter)

			data.closeButton.static = true
		end

		if data.closeButton.margin then
			if data.closeButton.margin.top then
				closeButton:setMarginTop(data.closeButton.margin.top)
			end

			if data.closeButton.margin.bottom then
				closeButton:setMarginBottom(data.closeButton.margin.bottom)
			end

			if data.closeButton.margin.left then
				closeButton:setMarginLeft(data.closeButton.margin.left)
			end

			if data.closeButton.margin.right then
				closeButton:setMarginRight(data.closeButton.margin.right)
			end
		end
	end

	window:setWidth(data.width or 400)
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
				local margin = data.margin or 50

				if pos.x - width - margin > 0 then
					local newPos = {
						x = pos.x - width - margin,
						y = pos.y + size.height / 2 - height / 2
					}

					window:setPosition(newPos)

					local arrow = window.arrow_right

					if arrow then
						arrowDirection = "right"
					end

					if closeButton and (not data.closeButton or not data.closeButton.static) then
						closeButton:breakAnchors()
						closeButton:addAnchor(AnchorTop, "parent", AnchorTop)
						closeButton:addAnchor(AnchorLeft, "parent", AnchorLeft)
					end

					return true
				end

				return false
			end

			local function checkRight()
				local margin = data.margin or 20

				if pos.x + size.width + width + margin < g_window.getWidth() then
					local newPos = {
						x = pos.x + size.width + margin,
						y = pos.y + size.height / 2 - height / 2
					}

					window:setPosition(newPos)

					local arrow = window.arrow_left

					if arrow then
						arrowDirection = "left"
					end

					if closeButton and (not data.closeButton or not data.closeButton.static) then
						closeButton:breakAnchors()
						closeButton:addAnchor(AnchorTop, "parent", AnchorTop)
						closeButton:addAnchor(AnchorRight, "parent", AnchorRight)
					end

					return true
				end

				return false
			end

			local function checkTop()
				local margin = data.margin or 20

				if pos.y - height - margin > 0 then
					local newPos = {
						x = pos.x + size.width / 2 - width / 2,
						y = pos.y - height - margin
					}

					window:setPosition(newPos)

					local arrow = window.arrow_down

					if arrow then
						arrowDirection = "down"
					end

					if closeButton and (not data.closeButton or not data.closeButton.static) then
						closeButton:breakAnchors()
						closeButton:addAnchor(AnchorTop, "parent", AnchorTop)
						closeButton:addAnchor(AnchorRight, "parent", AnchorRight)
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
				local margin = data.margin or 20

				if pos.y + height + margin > 0 then
					local newPos = {
						x = pos.x + size.width / 2 - width / 2,
						y = pos.y + size.height + margin
					}

					window:setPosition(newPos)

					local arrow = window.arrow_down

					if arrow then
						arrowDirection = "up"
					end

					if closeButton and (not data.closeButton or not data.closeButton.static) then
						closeButton:breakAnchors()
						closeButton:addAnchor(AnchorBottom, "parent", AnchorBottom)
						closeButton:addAnchor(AnchorRight, "parent", AnchorRight)
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

			local checkHeight = window:getY() - 20 + 20 < 0

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

		table.insert(self.connections, connect(self.action_prompt, {
			onFocusChange = self.actionBoxFollowParent
		}))
		table.insert(self.connections, connect(data.parent, {
			onGeometryChange = self.actionBoxFollowParent,
			onVisibilityChange = function(widget, visible)
				if visible then
					self.action_prompt:show()

					if self.action_prompt.followParent then
						self.action_prompt.followParent()
					end
				else
					self.action_prompt:hide()
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
			tile:setPromptWidget(window)
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

			creature:setPromptWidget(window)
		end
	end

	addEvent(function()
		window:raise()
	end)

	return window
end

function GamePrompts:resizeActionBox()
	local window = self.action_prompt

	if not window then
		return
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
		self.onDescriptionBoxPositionChange(window, window:getPosition())
	end)

	if window.followParent then
		window.followParent()
	end
end

function GamePrompts.actionBoxFollowParent()
	local self = GamePrompts
	local window = self.action_prompt

	if not window then
		return
	end

	if window.followParent then
		window:followParent()
	end
end

function GamePrompts.tileActionBoundsCheck()
	local self = GamePrompts
	local window = self.action_prompt

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
		tile:setPromptWidget(nil)
		window:hide()

		return
	end

	if not Position.canSee(tile:getPosition(), player:getPosition()) then
		tile:setPromptWidget(nil)
		window:hide()
	else
		tile:setPromptWidget(window)
		window:setMarginLeft(20)
		window:setMarginTop(-tile:getTopUseThing():getThingType():getExactHeight() - 40)
		window:show()

		local arrow = window.arrow_down

		if arrow then
			self:animateArrow(arrow)
		end
	end
end

function GamePrompts.creatureDescriptionBoundsCheck()
	local self = GamePrompts
	local window = self.description_prompt

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
		creature:setPromptWidget(nil)
		window:hide()

		return
	end

	if not Position.canSee(creature:getPosition(), player:getPosition()) then
		creature:setPromptWidget(nil)
		window:hide()
	else
		creature:setPromptWidget(window)
		window:setMarginLeft(20)
		window:setMarginTop(-creature:getThingType():getExactHeight() - 40)
		window:show()

		local arrow = window.arrow_down

		if arrow then
			self:animateArrow(arrow)
		end
	end
end

function GamePrompts.creatureActionBoundsCheck()
	local self = GamePrompts
	local window = self.action_prompt

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
		creature:setPromptWidget(nil)
		window:hide()

		return
	end

	if not Position.canSee(creature:getPosition(), player:getPosition()) then
		creature:setPromptWidget(nil)
		window:hide()
	else
		creature:setPromptWidget(window)
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

function GamePrompts.onGameEnd()
	local self = GamePrompts

	self:closeActionBox()
	self:closeDescriptionBox()
	self:disconnectAllPrompts()

	self.last_tile_pos = nil
	self.last_creature_id = nil
	self.custom_prompts = {
		active = {}
	}
end

function GamePrompts:loadConnections()
	return
end

function GamePrompts:unloadConnections()
	return
end

function GamePrompts:disconnectAllPrompts()
	for _, prompt in pairs(prompts) do
		prompt.current_task = 0
		prompt.current_prompt = 0

		if prompt.callbacks and prompt.callbacks.onGameEnd then
			prompt.callbacks.onGameEnd()
		end

		if prompt.tasks then
			for _, task in pairs(prompt.tasks) do
				for _, prompt in pairs(task) do
					if prompt.disconnects then
						for _, disconnectTable in pairs(prompt.disconnects) do
							for _, disconnect in pairs(disconnectTable) do
								disconnect()
							end
						end

						prompt.disconnects = {}
					end
				end
			end
		end
	end
end

function GamePrompts.onTaskUpdate(task)
	addEvent(function()
		for _, prompt in pairs(prompts) do
			if prompt.callbacks and prompt.callbacks.onTaskUpdate then
				prompt.callbacks.onTaskUpdate(task)
			end
		end
	end)
end

function GamePrompts:advancePrompt(env, currentTask, currentPrompt, args)
	self:closeActionBox()
	self:closeDescriptionBox()

	if env.tasks then
		for _, task in pairs(env.tasks) do
			for _, prompt in pairs(task) do
				if prompt.disconnects then
					for _, disconnectTable in pairs(prompt.disconnects) do
						for _, disconnect in pairs(disconnectTable) do
							disconnect()
						end
					end

					prompt.disconnects = {}
				end
			end
		end
	end

	if currentTask ~= env.current_task then
		env.current_task = currentTask
	end

	if env.current_prompt ~= currentPrompt then
		env.current_prompt = currentPrompt
	end

	env.current_prompt = env.current_prompt + 1

	if env.tasks[env.current_task] and env.tasks[env.current_task][env.current_prompt] then
		env.tasks[env.current_task][env.current_prompt].onStartPrompt(env.tasks[env.current_task][env.current_prompt], args)
	else
		env.current_prompt = 0
	end

	self:savePromptProgress(env, env.current_task, env.current_prompt, env.dont_show[g_game.getCharacterName()])
end

function GamePrompts:advanceTask(env)
	env.current_task = env.current_task + 1
	env.current_prompt = 0

	self:advancePrompt(env, env.current_task, env.current_prompt)
end

function GamePrompts:completePrompt(env)
	self:closeActionBox()
	self:closeDescriptionBox()

	local name = env

	if type(env) == "string" then
		env = prompts[env]
	end

	if not env then
		print("prompt not found", name)
	end

	if not self.custom_prompts.active[env.name] then
		print("prompt not active", env.name)

		return
	end

	if env.callbacks.onCompletePrompt then
		env.callbacks.onCompletePrompt()
	end

	self:disconnectAllPrompts()

	self.custom_prompts.active[env.name] = nil
end

function GamePrompts:savePromptProgress(env, currentTask, currentPrompt, dontShowAgain)
	if currentTask and env.current_task ~= currentTask then
		env.current_task = currentTask
	end

	if currentPrompt and env.current_prompt ~= currentPrompt then
		env.current_prompt = currentPrompt
	end

	local progress = {
		current_task = env.current_task,
		current_prompt = env.current_prompt,
		dont_show = dontShowAgain == nil and env.dont_show[g_game.getCharacterName()] or dontShowAgain
	}

	if not env.save_progress then
		progress.current_prompt = nil
		progress.current_task = nil
	end

	local promptsNode = g_settings.getNode("game_prompt") or {}

	promptsNode[g_game.getCharacterName()] = promptsNode[g_game.getCharacterName()] or {}
	promptsNode[g_game.getCharacterName()][env.name] = progress

	g_settings.setNode("game_prompt", promptsNode)
	g_settings.save()

	local prompt = prompts[env.name]

	if prompt then
		self:loadPromptProgress(env)
	end
end

function GamePrompts:loadPromptProgress(env)
	local name = g_game.getCharacterName()
	local prompts = g_settings.getNode("game_prompt") or {}

	prompts = prompts[name] or {}

	local prompt = prompts[env.name]

	if prompt then
		if env.save_progress then
			env.current_task = prompt.current_task
			env.current_prompt = prompt.current_prompt
		end

		env.dont_show[name] = prompt.dont_show
	end

	if not env.dont_show[name] and env.tasks and env.tasks[env.current_task] and env.tasks[env.current_task][env.current_prompt] and self:isPromptsEnabled() then
		env.tasks[env.current_task][env.current_prompt].onStartPrompt(env.tasks[env.current_task][env.current_prompt])
	end
end

function GamePrompts.onGameStart()
	local self = GamePrompts

	for _, prompt in pairs(prompts) do
		self:loadPromptProgress(prompt)

		if prompt.callbacks and prompt.callbacks.onGameStart then
			prompt.callbacks.onGameStart()
		end
	end
end

function GamePrompts:activatePrompt(data)
	if self.custom_prompts.active[data.name] then
		return
	end

	local prompt = prompts[data.name]

	if not prompt then
		return
	end

	if prompt.dont_show[g_game.getCharacterName()] then
		return
	end

	self.custom_prompts.active[data.name] = data

	self:checkCustomPromptTriggers(data)
end

function GamePrompts:checkCustomPromptTriggers(data)
	local prompt = prompts[data.name]

	if prompt and prompt.callbacks and prompt.callbacks.onCustomPrompt then
		prompt.callbacks.onCustomPrompt(data)
	end
end

function GamePrompts:startPrompt(name)
	return
end

function GamePrompts:cancelPrompt(env)
	if self.confirmation_box then
		self.confirmation_box:destroy()

		self.confirmation_box = nil
	end

	local function yesCallback(widget, dontShow)
		self.confirmation_box:destroy()

		self.confirmation_box = nil

		self:completePrompt(env)
		self:savePromptProgress(env, env.current_task, env.current_prompt, dontShow)
	end

	local function noCallback()
		self.confirmation_box:destroy()

		self.confirmation_box = nil
	end

	self.confirmation_box = displayConfirmBox(tr("Close Prompt"), tr("Are you sure you want to close this prompt?"), {
		{
			text = tr("Confirm"),
			callback = yesCallback
		},
		{
			text = tr("Cancel"),
			callback = noCallback
		},
		anchor = AnchorHorizontalCenter
	}, yesCallback, noCallback, nil, modules.game_interface.getRootPanel(), false, nil, tr("Do not show this prompt again"))
end

function GamePrompts.isEnabled()
	return not g_game.isAetherRiftChannel() and not g_game.isGuildWarsChannel()
end

function GamePrompts.hasActive()
	return #GamePrompts.custom_prompts.active > 0
end

function GamePrompts:restorePrompts()
	for _, prompt in pairs(prompts) do
		self:savePromptProgress(prompt, nil, nil, false)
		self:loadPromptProgress(prompt)
	end
end
