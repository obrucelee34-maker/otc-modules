-- chunkname: @/modules/game_npcs/tradepost.lua

Tradepost = {
	sortDirection = "desc",
	primingTradepack = false,
	sortOption = "demand",
	sort_buttons = {},
	sortedRecipes = {},
	indexedRecipes = {},
	filters = {}
}

function Tradepost:loadConfig()
	dofile("/modules/game_tradepacks/recipes.lua")

	for category, recipes in pairs(cfg.recipes) do
		for _, recipe in ipairs(recipes) do
			recipe.demand = 0
			recipe.category = category

			table.insert(self.sortedRecipes, recipe)

			self.indexedRecipes[recipe.itemid] = recipe
		end
	end

	return true
end

function Tradepost:isVisible()
	return self.window and self.window:isVisible()
end

function Tradepost:init()
	self:loadConfig()
	connect(Container, {
		onOpen = Tradepost.refreshOwnedMaterials,
		onRemoveItem = Tradepost.refreshOwnedMaterials,
		onUpdateItem = Tradepost.refreshOwnedMaterials,
		onAddItem = Tradepost.refreshOwnedMaterials
	})
	connect(LocalPlayer, {
		onEffortChange = Tradepost.onEffortChange
	})

	self.craftWindow = GameNpc.panels[windowTypes.tradepost_craft]

	self.craftWindow:setVisible(false)

	self.craftWindow.onVisibilityChange = Tradepost.onVisibilityChange
	self.sellWindow = GameNpc.panels[windowTypes.tradepost_sell]

	self.sellWindow:setVisible(false)

	self.sort_buttons.demand = self.craftWindow.top_panel.demand
	self.sort_buttons.name = self.craftWindow.top_panel.name
	self.list_panel = self.craftWindow.list_panel
	self.search_panel = self.craftWindow.top_panel.search_panel
	self.bottom_panel = self.craftWindow.bottom_panel
	self.sell_list_panel = self.sellWindow.list_panel
	self.sell_bottom_panel = self.sellWindow.bottom_panel

	local HUDPanel = modules.game_interface.getHUDPanel()

	self.demand_panel = g_ui.createWidget("GameTradepostDemandPanel", HUDPanel)

	self:sort("demand")
	addEvent(function()
		self:populateList()
	end)
end

function Tradepost:terminate()
	self.craftWindow:destroy()
	self.sellWindow:destroy()

	if self.confirmWindow then
		self.confirmWindow:destroy()
	end

	disconnect(Container, {
		onOpen = Tradepost.refreshOwnedMaterials,
		onRemoveItem = Tradepost.refreshOwnedMaterials,
		onUpdateItem = Tradepost.refreshOwnedMaterials,
		onAddItem = Tradepost.refreshOwnedMaterials
	})
	connect(LocalPlayer, {
		onEffortChange = Tradepost.onEffortChange
	})

	Tradepost = nil
end

function Tradepost:onClose()
	self.sell_bottom_panel.widget = nil

	self.sell_list_panel:destroyChildren()

	if self.confirmWindow then
		self.confirmWindow:destroy()
	end
end

function Tradepost:onResize()
	if not self.craftWindow or not self.sellWindow then
		return
	end
end

function Tradepost:onOpenCraft(data)
	local npcNameLabel = GameNpc.window.topPanel:recursiveGetChildById("npcName")

	npcNameLabel:setText(data.tradepost)
	GameNpc:setPanel("tradepost_craft")

	self.quest = data.quest

	self:onSearchTextChanged(self.search_panel:getText())

	if self.bottom_panel.recipe then
		local recipe = self.bottom_panel.recipe

		self.bottom_panel.panel_top.demand:setText(recipe.active and recipe.demand or "Inactive")
		self.bottom_panel.panel_top.demand:setTooltip(recipe.active and "" or "This tradepack is not available to be crafted yet, it will unlock soon")
	end

	if g_game.isRavenQuest() then
		local primeTradepackAmount = data.primeTradepackAmount and math.max(0, data.primeTradepackAmount)

		self.bottom_panel.primeTradepackToggle.tooltip = tr("Tradepack Priming Charges: %d\nPriming increases the amount of gold you receive from delivering a tradepack by 100%%.", primeTradepackAmount)

		self.bottom_panel.primeTradepackLabel:setTooltip(self.bottom_panel.primeTradepackToggle.tooltip)

		if primeTradepackAmount == 0 then
			self:togglePrimeTradepack(false)
			self:enablePrimeTradepack(false)
		else
			self:enablePrimeTradepack(true)
		end
	else
		self.bottom_panel.primeTradepackToggle:setVisible(false)
		self.bottom_panel.primeTradepackLabel:setVisible(false)
	end

	signalcall(GameNpc.onOpenTradepostCraft)
	self.refreshOwnedMaterials()
end

function Tradepost:onOpenSell(data)
	self.refreshOwnedMaterials()

	local npcNameLabel = GameNpc.window.topPanel:recursiveGetChildById("npcName")

	npcNameLabel:setText(data.tradepost)
	GameNpc:setPanel("tradepost_sell")
	self:populateTradepacks(data)
	self:fitFilters()
	signalcall(GameNpc.onOpenTradepostSell)
end

function Tradepost.onVisibilityChange(window, visible)
	local self = Tradepost
	local tmpVisible = GameTradepacks.leftAttachedWindow:isVisible()

	if not visible then
		if not GameTradepacks.window:isVisible() then
			tmpVisible = false
		end

		if self.demand_panel:isVisible() then
			self.demand_panel:setVisible(false)
		end
	elseif GameTradepacks:canUpdateGlobalDemand() then
		GameTradepacks.lastGlobalDemandRequest = os.time()

		GameTradepacks:requestGlobalDemand()
	end

	GameTradepacks.leftAttachedWindow:setAttachedTo(visible and GameNpc.window or GameTradepacks.window)
	GameTradepacks.leftAttachedWindow:setOn(visible)
	GameNpc.window:recursiveGetChildById("bagButton"):setVisible(visible)
	addEvent(function()
		GameTradepacks:toggleLeftPanel(tmpVisible)
	end)
end

function Tradepost:sort(id, internal)
	local toggle = false

	if self.sort_buttons.current and not internal then
		if self.sort_buttons.current == self.sort_buttons[id] then
			toggle = true
		else
			self.sort_buttons.current:setChecked(false)
			self.sort_buttons.current:setOn(false)
		end
	end

	self.sort_buttons.current = self.sort_buttons[id]

	self.sort_buttons.current:setChecked(true)

	if toggle then
		self.sort_buttons.current:setOn(not self.sort_buttons.current:isOn())
	else
		self.sort_buttons.current:setOn(false)
	end

	self.sortOption = id
	self.sortDirection = self.sort_buttons.current:isOn() and "asc" or "desc"

	local children = self.list_panel:getChildren()

	if self.sortOption == "demand" then
		table.sort(children, function(a, b)
			if self.sortDirection == "asc" then
				return a.recipe.demand < b.recipe.demand
			else
				return a.recipe.demand > b.recipe.demand
			end
		end)
	elseif self.sortOption == "name" then
		table.sort(children, function(a, b)
			if self.sortDirection == "asc" then
				return a.recipe.name < b.recipe.name
			else
				return a.recipe.name > b.recipe.name
			end
		end)
	end

	self:populateList(children)
end

function Tradepost:onSearchTextChanged(text)
	for _, child in ipairs(self.list_panel:getChildren()) do
		if self.quest then
			if child.recipe.category == TRADEPACK_CATEGORY_QUEST then
				child:setVisible(not text or #text == 0 or string.find(string.lower(child.recipe.name), string.lower(text)))
			else
				child:hide()
			end
		else
			child:setVisible(not text or #text == 0 or string.find(string.lower(child.recipe.name), string.lower(text)))
		end
	end

	self:sort(self.sortOption, true)
end

function Tradepost:populateList(sort)
	local player = g_game.getLocalPlayer()

	if not sort then
		for _, recipe in ipairs(self.sortedRecipes) do
			local widget = g_ui.createWidget("GameTradepacksWindowListItem", self.list_panel)

			widget.recipe = recipe

			widget.name:setText(recipe.name)
			widget.item:setItemId(recipe.clientId)
			widget:setId(recipe.name:lower())

			for ___, material in ipairs(recipe.materials) do
				local material_widget = g_ui.createWidget("GameTradepacksWindowListMaterialItem", widget.material_list)

				material_widget.item:setItemId(material.clientId)
				material_widget:setTooltip(string.format("%ix %s", material.amount, material.name:titleCase()))

				material_widget.recipe = material

				if player then
					material_widget:setOn(player:getItemsCount(material.clientId) >= material.amount)
				end

				widget.expand_button:setVisible(false)

				widget.clickSound = true
				widget.hoverSound = true

				function widget.onClick()
					self:toggleBottomPanel(widget)
				end
			end
		end
	else
		self.list_panel:reorderChildren(sort)

		for _, widget in ipairs(sort) do
			widget.demand:setText(self.indexedRecipes[widget.recipe.itemid].active and self.indexedRecipes[widget.recipe.itemid].demand or "Inactive")
			widget.demand:setTooltip(self.indexedRecipes[widget.recipe.itemid].active and "" or "This tradepack is not available to be crafted yet, it will unlock soon")
		end
	end

	for _, child in ipairs(self.list_panel:getChildren()) do
		if child:isVisible() then
			self:toggleBottomPanel(child)

			return
		end
	end
end

function Tradepost:parseGlobalDemand(data)
	for _, recipe in ipairs(self.sortedRecipes) do
		for itemid, demand in pairs(data.demand) do
			if recipe.itemid == itemid then
				recipe.demand = demand
				recipe.active = data.active[itemid]
				self.indexedRecipes[itemid].demand = demand
				self.indexedRecipes[itemid].active = data.active[itemid]
			end
		end
	end

	self:sort(self.sortOption, true)
end

function Tradepost.refreshOwnedMaterials()
	local self = Tradepost

	if not self.craftWindow:isVisible() and not self.sellWindow:isVisible() then
		return
	end

	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	for _, widget in ipairs(self.list_panel:getChildren()) do
		for _, material in ipairs(widget.material_list:getChildren()) do
			local count = player:getItemsCount(material.recipe.clientId)

			material:setOn(count >= material.recipe.amount)
		end
	end

	local hasAllMaterials = true

	if self.bottom_panel:isVisible() then
		for _, material in ipairs(self.bottom_panel.materials:getChildren()) do
			local count = player:getItemsCount(material.recipe.clientId)

			material.amount:setText(string.format("%i / %i", count, material.recipe.amount))
			material.amount:setOn(count >= material.recipe.amount)

			if count < material.recipe.amount then
				hasAllMaterials = false
			end
		end
	end

	local canUseCertificate = player:getItemsCount(38523) > 0

	self.bottom_panel.useCertificateButton:setVisible(canUseCertificate)
	self.bottom_panel.craftButton:setChecked(canUseCertificate)
	self.bottom_panel.craftButton:setHovered(false)
	self.bottom_panel.craftButton:setEnabled(hasAllMaterials)
	self:fitFilters()
end

function Tradepost:toggleBottomPanel(widget)
	local recipe = widget.recipe

	if self.bottom_panel:isVisible() and self.bottom_panel.recipe and self.bottom_panel.recipe.itemid == recipe.itemid then
		self.bottom_panel:setVisible(false)
		widget:setOn(false)

		return
	end

	self.bottom_panel.recipe = recipe

	self.bottom_panel.effortPanel:setVisible(cfg.craftTradepackEffortCost > 0 and self.bottom_panel.recipe.category ~= TRADEPACK_CATEGORY_QUEST)

	if self.bottom_panel.widget then
		self.bottom_panel.widget:setOn(false)
	end

	self.bottom_panel.widget = widget

	widget:setOn(true)
	self.bottom_panel:setVisible(true)

	local list_item = self.bottom_panel.panel_top

	list_item.item:setItemId(recipe.clientId)
	list_item.name:setText(recipe.name)
	list_item.demand:setText(recipe.active and recipe.demand or "Inactive")
	list_item.demand:setTooltip(recipe.active and "" or "This tradepack is not available to be crafted yet, it will unlock soon")

	local materials_list = self.bottom_panel.materials
	local player = g_game.getLocalPlayer()
	local hasAllMaterials = true

	for index, material in ipairs(recipe.materials) do
		local material_widget = materials_list:getChildByIndex(index) or g_ui.createWidget("GameTradepacksWindowRightWindowListItem", materials_list)

		material_widget:show()
		material_widget.item:setItemId(material.clientId)
		material_widget.name:setText(material.name:titleCase())

		material_widget.recipe = material

		if player then
			local count = player:getItemsCount(material.clientId)

			material_widget.amount:setText(string.format("%i / %i", count, material.amount))
			material_widget.amount:setOn(count >= material.amount)

			if count < material.amount then
				hasAllMaterials = false
			end
		end
	end

	local canUseCertificate = player:getItemsCount(38523) > 0

	self.bottom_panel.useCertificateButton:setVisible(canUseCertificate and recipe.active)
	self.bottom_panel.craftButton:setChecked(canUseCertificate and recipe.active)
	self.bottom_panel.craftButton:setHovered(false)
	self.bottom_panel.craftButton:setEnabled(hasAllMaterials and recipe.active)

	for index = #recipe.materials + 1, #materials_list:getChildren() do
		materials_list:getChildByIndex(index):hide()
	end

	GameTradepacks:requestTradepack(recipe.itemid)
end

function Tradepost:onSetupCraftWindow(window)
	local name = window:recursiveGetChildById("name")
	local demand = window:recursiveGetChildById("demand")

	function self.search_panel.onTextChange()
		self:onSearchTextChanged(self.search_panel:getText())
	end

	function name.onClick()
		self:sort(name:getId())
	end

	function demand.onClick()
		self:sort(demand:getId())
	end
end

function Tradepost:getCurrentPack()
	local pack = {}
	local widget = self.sell_bottom_panel.widget

	if widget then
		pack = {
			uid = widget.uid
		}
	end

	local bottomPanel = self.bottom_panel

	if bottomPanel and bottomPanel:isVisible() then
		pack = {
			category = bottomPanel.recipe.category,
			id = bottomPanel.recipe.id
		}
	end

	return pack
end

function Tradepost:populateTradepacks(data)
	self.sell_bottom_panel.widget = nil

	self.sell_list_panel:destroyChildren()

	for _, tradepack in ipairs(data.tradepacks) do
		local widget = g_ui.createWidget("GameTradepostSellItem", self.sell_list_panel)

		widget.item:setTradepack(tradepack.pack)
		widget.name:setText(tradepack.pack.name)
		widget.price:setText(tradepack.turninPrice)

		widget.clientId = tradepack.pack.clientId
		widget.uid = tradepack.pack.uid
		widget.turninPrice = tradepack.turninPrice
		widget.clickSound = true

		function widget.onClick()
			self:populateSellInfo(widget)
		end

		if not self.sell_bottom_panel.widget then
			self:populateSellInfo(widget)
		end
	end
end

function Tradepost:populateSellInfo(widget)
	local bottomPanel = self.sell_bottom_panel

	if widget and widget ~= bottomPanel.widget then
		if bottomPanel.widget then
			bottomPanel.widget:setOn(false)
		end

		widget:setOn(true)
	else
		return
	end

	local tradepack = bottomPanel.tradepack

	tradepack.item:setItemId(widget.clientId)
	tradepack.name:setText(widget.name:getText())
	tradepack.price:setText(widget.price:getText())

	self.sell_bottom_panel.widget = widget

	self.sell_bottom_panel.effortPanel:setVisible(cfg.deliverTradepackEffortCost > 0 and widget.category ~= TRADEPACK_CATEGORY_QUEST)
end

function Tradepost:onTogglePrimeTradepack(widget)
	self.primingTradepack = widget:isOn()
end

function Tradepost:togglePrimeTradepack(state)
	local widget = self.bottom_panel.primeTradepackToggle

	if widget:isOn() ~= state then
		widget:onClick()
	end
end

function Tradepost:enablePrimeTradepack(state)
	local widget = self.bottom_panel.primeTradepackToggle

	widget:setEnabled(state)
end

function Tradepost:isPrimingTradepack()
	return self.primingTradepack
end

function Tradepost:requestCraftTradepack(useCertificate)
	if self.confirmWindow then
		self.confirmWindow:destroy()

		self.confirmWindow = nil
	end

	local function yesCallback()
		GameNpc:sendOpcode({
			option = "tradepost_craft_pack",
			action = "dialogue",
			dialogueId = GameNpc.dialogueId,
			npcName = GameNpc.npcName,
			pack = Tradepost:getCurrentPack(),
			primeTradepack = Tradepost:isPrimingTradepack(),
			useCertificate = useCertificate
		})

		if not self.confirmWindow then
			return
		end

		self.confirmWindow:destroy()

		self.confirmWindow = nil
	end

	local player = g_game.getLocalPlayer()

	if player:getLevel() < cfg.protectionLevel then
		local function noCallback()
			self.confirmWindow:destroy()

			self.confirmWindow = nil
		end

		self.confirmWindow = displayGeneralBox("Confirm", "Once crafted, the Tradepack will disable PvP protection as long as you are holding it. If you die when carrying a Tradepack, the Tradepack is dropped and anyone is able to pick up the Tradepack.\nAre you sure you want to perform this action?", {
			{
				text = tr("Yes"),
				callback = yesCallback
			},
			{
				text = tr("No"),
				callback = noCallback
			},
			anchor = AnchorHorizontalCenter
		}, yesCallback, noCallback, nil)

		self.confirmWindow:setDraggable(false)

		function self.confirmWindow:onVisibilityChange(visible)
			if not visible then
				noCallback()
			end
		end

		return
	end

	yesCallback()
end

function Tradepost.onEffortChange(localPlayer, effort)
	local self = Tradepost
	local bottomPanel = self.bottom_panel

	bottomPanel.effortPanel.value:setText(string.format("%s / %s", FormatCommaNumber(effort), FormatCommaNumber(cfg.craftTradepackEffortCost)))
	bottomPanel.effortPanel:setOn(effort >= cfg.craftTradepackEffortCost)

	local recipe = bottomPanel.recipe

	if recipe and recipe.category == TRADEPACK_CATEGORY_QUEST then
		bottomPanel.craftButton:setEnabled(true)
	else
		bottomPanel.craftButton:setEnabled(effort >= cfg.craftTradepackEffortCost)
	end

	if cfg.deliverTradepackEffortCost > 0 then
		bottomPanel = self.sell_bottom_panel

		bottomPanel.effortPanel.value:setText(string.format("%s / %s", FormatCommaNumber(effort), FormatCommaNumber(cfg.deliverTradepackEffortCost)))
		bottomPanel.effortPanel:setOn(effort >= cfg.deliverTradepackEffortCost)
	end
end

function Tradepost:hasRecipeMaterials(player, recipe)
	local materials = recipe.materials

	for _, material in ipairs(materials) do
		if player:getItemsCount(material.clientId) < material.amount then
			return false
		end
	end

	return true
end

function Tradepost:onFilterPanelClick(widget, state)
	if self.popupMenu then
		self.popupMenu:destroy()

		self.popupMenu = nil
	end

	self.popupMenu = g_ui.createWidget("FilterPopupMenu")

	self.popupMenu:setWidth(widget:getWidth())

	self.popupMenu.lastWidth = widget:getWidth()

	local disconnects = {}

	table.insert(disconnects, connect(self.search_panel, {
		onVisibilityChange = function(widget, visible)
			if not visible and self.popupMenu then
				self.popupMenu:destroy()

				self.popupMenu = nil
			end
		end
	}))
	table.insert(disconnects, connect(g_ui.getRootWidget(), {
		onMousePress = function(widget, mousePos)
			if not self.popupMenu then
				return
			end

			if not self.popupMenu:containsPoint(mousePos) then
				if self.popupMenu.menu then
					if not self.popupMenu.popup:containsPoint(mousePos) then
						self.popupMenu.popup:destroy()

						self.popupMenu.popup = nil
					end

					return
				end

				self.popupMenu:destroy()

				self.popupMenu = nil
			end
		end
	}))
	connect(self.popupMenu, {
		onDestroy = function()
			widget:setOn(false)

			if self.popupMenu.popup then
				self.popupMenu.popup:destroy()

				self.popupMenu.popup = nil
			end

			for _, widgets in ipairs(disconnects) do
				for _, disconnect in ipairs(widgets) do
					disconnect()
				end
			end
		end
	})

	for _, filter in ipairs(cfg.tradepostFiltersOrder) do
		self.popupMenu:addOption(filter, function(option)
			if self.popupMenu.currentSelectedOption then
				self.popupMenu.currentSelectedOption:setOn(false)
			end

			option:setOn(true)

			self.popupMenu.currentSelectedOption = option

			Tradepost:createExpandedFilterPopup(self.popupMenu, option, filter)
		end, nil, true)
		self.popupMenu:addSeparator()
	end

	g_ui.createWidget("TradepostFilterPopupMenuClearAll", self.popupMenu)

	local displayPos = widget:getPosition()

	displayPos.y = displayPos.y + widget:getHeight() + 4

	self.popupMenu:setFocusable(false)
	self.popupMenu:display(displayPos, true, self.window)
	self.popupMenu.clear_button:setEnabled(not table.empty(self.filters))

	for _, filter in ipairs(cfg.tradepostFiltersOrder) do
		local filters = self.filters[filter]

		if filters then
			local option = self.popupMenu:getChildById(filter:lower())

			for filterName in pairs(filters) do
				local label = g_ui.createWidget("FilterPopupMenuSubItem", option.content)

				label:setText(string.format("    %s", filterName))
				label:setId(filterName)

				option.content.filters = option.content.filters or {}
				option.content.filters[filterName] = true
			end

			local height = 30

			for _, child in ipairs(option.content:getChildren()) do
				height = height + child:getHeight()
			end

			option:setHeight(height)
		end
	end
end

function Tradepost:clearAllFilters()
	self.filters = {}

	if not self.popupMenu then
		return
	end

	self.popupMenu.clear_button:setEnabled(false)

	for _, child in ipairs(self.popupMenu:getChildren()) do
		if child.content then
			child.content.filters = nil

			child.content:destroyChildren()
			child:setHeight(30)
		end
	end

	self:fitFilters()
end

function Tradepost:createExpandedFilterPopup(menu, parentOption, filterName)
	local options = cfg.tradepostFilters[filterName]

	if not options then
		return
	end

	menu.popup = g_ui.createWidget("FilterPopupMenu")

	for _, optionName in ipairs(options) do
		local option = menu.popup:addOption(optionName, function()
			return
		end, nil, true, "TradepostFilterPopupMenuButtonExpanded")

		option.config = {
			name = optionName,
			index = _
		}

		self:loadFilterStates(string.titleCase(parentOption:getId(), true), option)
	end

	connect(menu.popup, {
		onDestroy = function()
			parentOption:setOn(false)
		end
	})

	local displayPos = menu:getPosition()

	displayPos.x = displayPos.x + menu:getWidth()
	displayPos.y = parentOption:getY()

	menu.popup:setFocusable(false)
	menu.popup:display(displayPos, true, nil)
end

function Tradepost:onFilterPanelCheckboxChange(widget, state)
	local categoryFilter = self.popupMenu

	if not categoryFilter then
		return
	end

	local filters = categoryFilter.popup

	if not filters then
		return
	end

	local selectedCategory = categoryFilter.currentSelectedOption

	if not selectedCategory then
		return
	end

	local changedCategory = string.titleCase(selectedCategory:getId(), true)
	local changedFilter = string.titleCase(widget:getParent():getId(), true)
	local filterConfig = widget:getParent().config

	self.filters[changedCategory] = self.filters[changedCategory] or {}
	self.filters[changedCategory][changedFilter] = state and true or nil

	if state and not selectedCategory.content.filters or not selectedCategory.content.filters[changedFilter] then
		local label = g_ui.createWidget("FilterPopupMenuSubItem", selectedCategory.content)

		label:setText(string.format("    %s", tr(filterConfig.name)))
		label:setId(changedFilter)

		selectedCategory.content.filters = selectedCategory.content.filters or {}
		selectedCategory.content.filters[changedFilter] = true

		selectedCategory.content:moveChildToIndex(label, math.min(filterConfig.index, selectedCategory.content:getChildCount()))
	elseif not state then
		local label = selectedCategory.content:getChildById(changedFilter)

		if label then
			label:destroy()

			selectedCategory.content.filters[changedFilter] = nil
		end
	end

	local height = 30

	for _, child in ipairs(selectedCategory.content:getChildren()) do
		height = height + child:getHeight()
	end

	selectedCategory:setHeight(height)

	if table.empty(self.filters[changedCategory]) then
		self.filters[changedCategory] = nil
	end

	categoryFilter.clear_button:setEnabled(not table.empty(self.filters))
	self:fitFilters()
end

function Tradepost:loadFilterStates(parentCategory, optionWidget)
	local filters = self.filters[parentCategory]

	if not filters then
		return
	end

	local filterName = string.titleCase(optionWidget:getId(), true)

	if filters[filterName] then
		optionWidget.checkbox:setChecked(true, true)
	end
end

function Tradepost:applyFilter(recipe, filters)
	local player = g_game.getLocalPlayer()

	for _, filter in ipairs(cfg.tradepostFiltersOrder) do
		local filters = filters and filters[filter] or self.filters[filter]
		local successFilter = 0

		if filters then
			for filterName in pairs(filters) do
				local callback = cfg.tradepostFiltersCallback[filter][filterName]

				if callback(player, recipe) then
					successFilter = successFilter + 1
				end
			end

			if successFilter == 0 then
				return false
			end
		end
	end

	return true
end

function Tradepost:fitFilters(panel, customFilters)
	local children = self.list_panel:getChildren()

	local function applyFilter(child)
		local filtered = self:applyFilter(child.recipe)

		child:setVisible(filtered)

		child.hiddenFiltered = not filtered

		if not filtered then
			local recipe = child.recipe

			if self.bottom_panel:isVisible() and self.bottom_panel.recipe and self.bottom_panel.recipe.itemid == recipe.itemid then
				self.bottom_panel:setVisible(false)
				child:setOn(false)
			end
		end
	end

	for _, child in ipairs(children) do
		if self.quest then
			if child.recipe.category == TRADEPACK_CATEGORY_QUEST then
				applyFilter(child)
			else
				child:setVisible(false)

				child.hiddenFiltered = true
			end
		else
			applyFilter(child)
		end
	end
end

function Tradepost:getCurrentTradepostId(position)
	if not position then
		local player = g_game.getLocalPlayer()

		if player then
			position = player:getPosition()
		end
	end

	if not position then
		return nil
	end

	for index, tradepost in ipairs(Tradeposts) do
		if Position.getDistanceBetween(position, tradepost.pos) <= 10 then
			return index
		end
	end

	return nil
end

function Tradepost:toggleDemandPanel()
	if self.demand_panel:isVisible() then
		self.demand_panel:setVisible(false)

		return
	end

	local currentTradepostId = self:getCurrentTradepostId()

	if currentTradepostId and currentTradepostId ~= self.demand_panel.currentTradepostId then
		self.demand_panel.currentTradepostId = currentTradepostId

		for _, item in ipairs(self.demand_panel["Tradepost Location and Demand"]:getChildren()) do
			local dist = TradepostsDistances[currentTradepostId] and TradepostsDistances[currentTradepostId][item.tradepost.tradepostId] or 0

			item.distance:setText(string.format("%i %s", dist, tr("steps")))
		end
	end

	self.demand_panel:setVisible(true)
end
