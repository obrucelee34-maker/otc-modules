-- chunkname: @/modules/game_market/market.lua

GameMarket = {
	premiumOnly = false,
	unlockTime = 0,
	customSetOrder = false,
	offerListWindow = {
		offerType = 0,
		totalOffers = 0,
		page = 1,
		categoryWidgets = {},
		selectedCategory = {},
		filters = {},
		currentOfferList = {}
	},
	activeOffersWindow = {
		totalOffers = 0,
		page = 1,
		filters = {},
		currentOfferList = {}
	},
	createOfferWindow = {
		totalOffers = 0,
		page = 1,
		currentOfferList = {},
		categoryWidgets = {},
		selectedCategory = {},
		attributes = {}
	},
	completedOffersWindow = {
		totalOffers = 0,
		page = 1,
		filters = {},
		currentOfferList = {}
	},
	protocolItems = {}
}

function GameMarket:loadConfig()
	local func, error = loadfile("config.lua")

	if not func then
		g_logger.fatal(error)

		return false
	end

	func()

	local env = getfenv(0)

	env.cfg = {}

	setmetatable(env.cfg, {
		__index = env
	})
	setfenv(func, env.cfg)

	return true
end

function GameMarket:init()
	self:loadConfig()
	dofile("active_offers.lua")
	dofile("new_offer.lua")
	dofile("completed_offers.lua")
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.Market)
	ProtocolGame.registerExtendedOpcode(ExtendedIds.Market, GameMarket.onExtendedOpcode)
	g_ui.importStyle("styles/main.otui")
	g_ui.importStyle("styles/categories.otui")
	g_ui.importStyle("styles/search_panel.otui")
	g_ui.importStyle("styles/offer_list.otui")
	g_ui.importStyle("styles/header_panel.otui")
	g_ui.importStyle("styles/interact_offer_window.otui")
	g_ui.importStyle("styles/active_offers.otui")
	g_ui.importStyle("styles/active_offers_search_panel.otui")
	g_ui.importStyle("styles/active_offer_list.otui")
	g_ui.importStyle("styles/create_offer_window.otui")
	g_ui.importStyle("styles/completed_offers.otui")
	g_ui.importStyle("styles/completed_offers_search_panel.otui")
	g_ui.importStyle("styles/completed_offer_list.otui")
	g_ui.importStyle("styles/create_offer_selection_window.otui")

	local HUDPanel = modules.game_interface.getHUDPanel()

	self.window = g_ui.createWidget("GameMarketWindow", HUDPanel)

	self.window:hide()

	local frames = {}

	for _ = 1, 30 do
		table.insert(frames, {
			size = {
				height = 200,
				width = 200
			},
			offset = {
				x = self.window.loading_icon:getWidth() / 2 - 115,
				y = self.window.loading_icon:getHeight() / 2 - 120
			}
		})
	end

	self.loadingAnimation = Animation.create({
		pauseWhenHidden = true,
		duration = 1000,
		loop = -1,
		imageSource = "/images/ui/loading/frame-%d",
		canvas = self.window.loading_icon,
		frames = frames,
		onStart = function(self, canvas)
			canvas:show()
			canvas:raise()
		end,
		onStop = function(self, canvas)
			canvas:hide()
		end
	})
	self.offerListWindow.categoriesPanel = self.window.content_list.categories
	self.offerListWindow.search_panel = self.window.content_list.search
	self.offerListWindow.paginationPanel = self.window.content_list.offers_panel.pagination_panel
	self.offerListWindow.interactOfferWindow = self.window.buy_offer_window

	self.offerListWindow.interactOfferWindow:hide()
	self:populateCategories()
	connect(g_game, {
		onGameStart = self.onGameStart,
		onGameEnd = self.onGameEnd,
		onProtocolItem = self.onProtocolItem,
		onCoinBalance = self.onBalanceChange,
		onRavencoinsBalanceChange = self.onRavencoinsBalanceChange
	})
	self:setSortOrder("desc", 6)
	self:selectPanel("marketplace")

	self.activeOffersWindow.search_panel = self.window.content_active_offers.search
	self.activeOffersWindow.paginationPanel = self.window.content_active_offers.offers_panel.pagination_panel
	self.activeOffersWindow.createOfferWindow = self.window.create_offer_window

	self.activeOffersWindow.createOfferWindow:hide()

	self.activeOffersWindow.selectionWindow = self.window.create_offer_selection_window

	self.activeOffersWindow.selectionWindow:hide()

	self.completedOffersWindow.search_panel = self.window.content_completed_offers.search
	self.completedOffersWindow.paginationPanel = self.window.content_completed_offers.offers_panel.pagination_panel

	self:setActiveOffersSortOrder("desc", 2)
	self:setCompletedOffersSortOrder("desc", 2)

	self.createOfferWindow.categoriesPanel = self.window.create_offer_window.content_buy_offers.select_item_panel.categories
	self.customSetOrder = false

	addEvent(function()
		self:setupCreateOfferCategoriesPanel()
	end)

	if not cfg.ENABLE_RAVENCOINS then
		self.window.header_panel.silver.ravencoin_amount:hide()
		self.window.header_panel.silver.premium_token_icon:hide()
	end
end

function GameMarket:terminate()
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.Market)

	if self.window then
		self.window:destroy()

		self.window = nil
	end

	if self.offerListWindow.popupMenu then
		self.offerListWindow.popupMenu:destroy()

		self.offerListWindow.popupMenu = nil
	end

	if self.activeOffersWindow.popupMenu then
		self.activeOffersWindow.popupMenu:destroy()

		self.activeOffersWindow.popupMenu = nil
	end

	disconnect(g_game, {
		onGameStart = self.onGameStart,
		onGameEnd = self.onGameEnd,
		onProtocolItem = self.onProtocolItem,
		onCoinBalance = self.onBalanceChange,
		onRavencoinsBalanceChange = self.onRavencoinsBalanceChange
	})
end

function GameMarket:show(premiumOnly)
	self.window:show()
	self.window:raise()
	self.window:focus()

	local selectedPanel

	for _, button in ipairs(self.window.header_panel:getChildren()) do
		if button:isOn() then
			selectedPanel = button:getId()

			break
		end
	end

	if premiumOnly then
		self:preparePremiumOnly()
	end

	self:selectPanel(selectedPanel or "marketplace", true)
	GameNpc:hide()
end

function GameMarket:hide()
	self.window:hide()

	local windows = {
		self.activeOffersWindow.createOfferWindow,
		self.offerListWindow.interactOfferWindow,
		self.activeOffersWindow.selectionWindow
	}

	for _, window in pairs(windows) do
		window:hide()
	end
end

function GameMarket:close()
	self.window:hide()
	GameNpc:ungreet()
end

function GameMarket.onExtendedOpcode(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.Market or buffer == "" then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		return
	end

	if data.action == "rollback" then
		addEvent(function()
			GameMarket:displayLock(false)
		end)
	elseif data.action == "fetch_offers" then
		GameMarket.unlockTime = g_clock.millis() + (data.lock or cfg.minLockDuration)
		GameMarket.offerListWindow.currentOfferList = data.offers

		function GameMarket.unlockCallback()
			GameMarket:displayOffers(data.offers, data.totalResults)
		end

		addEvent(function()
			GameMarket:displayLock(false)
		end)
	elseif data.action == "fetch_active_offers" then
		GameMarket.unlockTime = g_clock.millis() + (data.lock or cfg.minLockDuration)
		GameMarket.activeOffersWindow.currentOfferList = data.offers

		function GameMarket.unlockCallback()
			GameMarket:displayActiveOffers(data.offers, data.totalResults)
		end

		addEvent(function()
			GameMarket:displayLock(false)
		end)
	elseif data.action == "fetch_sell_offers" then
		GameMarket.unlockTime = g_clock.millis() + (data.lock or cfg.minLockDuration)

		function GameMarket.unlockCallback()
			GameMarket:displaySimilarSellOffers(data.offers, data.totalResults)
		end

		addEvent(function()
			GameMarket:displayLock(false)
		end)
	elseif data.action == "fetch_buy_offers" then
		GameMarket.unlockTime = g_clock.millis() + (data.lock or cfg.minLockDuration)

		function GameMarket.unlockCallback()
			GameMarket:displaySimilarBuyOffers(data.offers, data.totalResults)
		end

		addEvent(function()
			GameMarket:displayLock(false)
		end)
	elseif data.action == "fetch_completed_offers" then
		GameMarket.unlockTime = g_clock.millis() + (data.lock or cfg.minLockDuration)
		GameMarket.completedOffersWindow.currentOfferList = data.offers

		function GameMarket.unlockCallback()
			GameMarket:displayCompletedOffers(data.offers, data.totalResults)
		end

		addEvent(function()
			GameMarket:displayLock(false)
		end)
	end
end

function GameMarket:sendOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.Market, g_game.serializeTable(data))
	end
end

function GameMarket:populateCategories(premiumOnly)
	local categories = cfg.categories
	local order = cfg.categoriesOrder

	self.offerListWindow.categoriesPanel:destroyChildren()

	if not premiumOnly then
		local allItemsWidget = g_ui.createWidget("GameMarketCategoriesPanelCategoryElement", self.offerListWindow.categoriesPanel)

		allItemsWidget:setChecked(true)
		allItemsWidget:setText("All Items")

		allItemsWidget.categoryId = cfg.CATEGORY_ALL_ITEMS
		self.offerListWindow.categoryWidgets[cfg.CATEGORY_ALL_ITEMS] = allItemsWidget

		self:selectMarketCategory(cfg.CATEGORY_ALL_ITEMS, true)
	end

	if cfg.ENABLE_RAVENCOINS then
		local premiumTokenWidget = g_ui.createWidget("GameMarketCategoriesPanelCategory", self.offerListWindow.categoriesPanel)

		premiumTokenWidget.name:setText("RavenCoins")

		premiumTokenWidget.categoryId = cfg.CATEGORY_RAVENCOIN

		premiumTokenWidget.icon:setImageSource("/images/ui/windows/market/category_ravencoin")
		premiumTokenWidget:setChecked(true)
		premiumTokenWidget.button:hide()

		self.offerListWindow.categoryWidgets[cfg.CATEGORY_RAVENCOIN] = premiumTokenWidget
	end

	if not premiumOnly then
		for _, category in ipairs(order) do
			local categoryWidget = g_ui.createWidget("GameMarketCategoriesPanelCategory", self.offerListWindow.categoriesPanel)

			categoryWidget.name:setText(category:titleCase())
			categoryWidget.icon:setImageSource(string.format("/images/ui/windows/market/category_%s", category:gsub(" ", "_"):lower()))

			local subCategories = categories[category]

			if subCategories then
				local subOrder = {}

				for _, subCategory in pairs(subCategories) do
					table.insert(subOrder, subCategory)
				end

				table.sort(subOrder, function(a, b)
					return a.index < b.index
				end)

				for _, subCategory in ipairs(subOrder) do
					if cfg.categoriesById[subCategory.id] then
						local subCategoryWidget = g_ui.createWidget("GameMarketCategoriesPanelCategoryElement", categoryWidget.content)

						subCategoryWidget:setText(cfg.categoriesById[subCategory.id]:titleCase())

						subCategoryWidget.categoryId = subCategory.id
						self.offerListWindow.categoryWidgets[subCategory.id] = subCategoryWidget
					end
				end
			end
		end
	end
end

function GameMarket:minimizeAllMarketCategory()
	if not self.offerListWindow.categoriesPanel then
		return
	end

	for _, widget in ipairs(self.offerListWindow.categoriesPanel:getChildren()) do
		if widget:getStyleName() == "GameMarketCategoriesPanelCategory" and widget.button:isOn() then
			widget:onClick()
		end
	end
end

function GameMarket:selectMarketCategory(categoryId, skipRequest)
	local categoryWidget = self.offerListWindow.categoryWidgets[categoryId]

	if not categoryWidget then
		return
	end

	local selectedText = self.offerListWindow.search_panel.search_panel.search_input_panel.input:getText()
	local itemName = selectedText:lower()
	local clientId = cfg.MarketableItemsByName[itemName]

	if not clientId then
		local selectedText = self.offerListWindow.search_panel.search_panel.search_input_panel.input.selectedText

		if selectedText then
			local itemName = selectedText:lower()

			clientId = cfg.MarketableItemsByName[itemName]
		end
	end

	if clientId and not skipRequest then
		self:clearSearchInput(true)
	end

	local parentCategoryWidget = categoryWidget:getParent() and categoryWidget:getParent():getParent()

	if parentCategoryWidget and parentCategoryWidget:getStyleName() == "GameMarketCategoriesPanelCategory" then
		self:minimizeAllMarketCategory()

		if not parentCategoryWidget.button:isOn() then
			parentCategoryWidget:onClick()
		end
	end

	if self.offerListWindow.selectedCategory.id then
		if self.offerListWindow.selectedCategory.id == categoryId then
			return
		end

		self.offerListWindow.selectedCategory.widget:setOn(false)
	end

	self.offerListWindow.selectedCategory.id = categoryId
	self.offerListWindow.selectedCategory.widget = categoryWidget

	categoryWidget:setOn(true)

	if not skipRequest then
		self:requestSearch(true, true)
	end
end

function GameMarket:onSearchInputTextChange(widget, text)
	if self.offerListWindow.popupMenu then
		self.offerListWindow.popupMenu:destroy()

		self.offerListWindow.popupMenu = nil
	end

	if #text < 2 then
		return
	end

	local names = cfg.MarketableItemsByName
	local matches = {}

	for name in pairs(names) do
		if name:lower():find(text:lower()) then
			table.insert(matches, name)
		end
	end

	table.sort(matches, function(a, b)
		return a < b
	end)

	self.offerListWindow.popupMenu = g_ui.createWidget("SearchPopupMenu")
	self.offerListWindow.popupMenu.lastWidth = widget:getParent():getWidth()

	for index, match in ipairs(matches) do
		local item = self.offerListWindow.popupMenu:addOption(match:titleCase(), function()
			widget:setText(match:titleCase(), true)
			widget:setCursorPos(#match)
			widget:setEnabled(false)
			self:requestSearch(true, true, true)
		end)

		if index > 20 then
			break
		end
	end

	local displayPos = widget:getParent():getPosition()

	displayPos.y = displayPos.y + widget:getHeight() + 15

	self.offerListWindow.popupMenu:setFocusable(false)
	self.offerListWindow.popupMenu:display(displayPos, nil, self.window)

	widget.searchPopupIndex = 0

	local disconnects = connect(widget, {
		onKeyPress = GameMarket.onSearchPopupMenuKeyPressed,
		onVisibilityChange = function(widget, visible)
			if not visible and self.offerListWindow.popupMenu then
				self.offerListWindow.popupMenu:destroy()

				self.offerListWindow.popupMenu = nil
			end
		end
	})

	function widget.onMousePress(widget)
		local text = widget:getText()

		widget:setText()
		addEvent(function()
			widget:setText(text)
			widget:setCursorPos(#text)
		end)
	end

	connect(self.offerListWindow.popupMenu, {
		onDestroy = function()
			for _, disconnect in ipairs(disconnects) do
				disconnect()
			end
		end
	})
end

function GameMarket.onSearchPopupMenuKeyPressed(widget, keyCode)
	local self = GameMarket

	if not self.offerListWindow.popupMenu then
		return
	end

	if keyCode == KeyEnter then
		local index = widget.searchPopupIndex

		if not index then
			return
		end

		local child = self.offerListWindow.popupMenu:getChildByIndex(index)

		if not child then
			return
		end

		widget:setText(child:getText(), true)
		widget:setCursorPos(#widget:getText())
		widget:setEnabled(false)
		self.offerListWindow.popupMenu:destroy()

		self.offerListWindow.popupMenu = nil

		self:requestSearch(true, true, true)

		return
	end

	if keyCode == KeyEscape then
		self.offerListWindow.popupMenu:destroy()

		self.offerListWindow.popupMenu = nil

		widget:setText("", true)

		return
	end

	if keyCode ~= KeyTab then
		return
	end

	local index = widget.searchPopupIndex

	index = index or 1

	local currentChild = self.offerListWindow.popupMenu:getChildByIndex(index)

	if currentChild then
		currentChild:setOn(false)
	end

	if index + 1 > self.offerListWindow.popupMenu:getChildCount() then
		index = 0
	end

	local nextChild = self.offerListWindow.popupMenu:getChildByIndex(index + 1)

	if not nextChild then
		return
	end

	nextChild:setOn(true)

	widget.searchPopupIndex = index + 1
end

function GameMarket:onFilterPanelClick(widget, state)
	if self.offerListWindow.popupMenu then
		self.offerListWindow.popupMenu:destroy()

		self.offerListWindow.popupMenu = nil
	end

	self.offerListWindow.popupMenu = g_ui.createWidget("FilterPopupMenu")
	self.offerListWindow.popupMenu.lastWidth = widget:getWidth()

	local disconnects = {}

	table.insert(disconnects, connect(self.offerListWindow.search_panel, {
		onVisibilityChange = function(widget, visible)
			if not visible and self.offerListWindow.popupMenu then
				self.offerListWindow.popupMenu:destroy()

				self.offerListWindow.popupMenu = nil
			end
		end
	}))
	table.insert(disconnects, connect(g_ui.getRootWidget(), {
		onMousePress = function(widget, mousePos)
			if not self.offerListWindow.popupMenu then
				return
			end

			if not self.offerListWindow.popupMenu:containsPoint(mousePos) then
				if self.offerListWindow.popupMenu.menu then
					if not self.offerListWindow.popupMenu.popup:containsPoint(mousePos) then
						self.offerListWindow.popupMenu.popup:destroy()

						self.offerListWindow.popupMenu.popup = nil
					end

					return
				end

				self.offerListWindow.popupMenu:destroy()

				self.offerListWindow.popupMenu = nil
			end
		end
	}))
	connect(self.offerListWindow.popupMenu, {
		onDestroy = function()
			widget:setOn(false)

			if self.offerListWindow.popupMenu.popup then
				self.offerListWindow.popupMenu.popup:destroy()

				self.offerListWindow.popupMenu.popup = nil
			end

			for _, widgets in ipairs(disconnects) do
				for _, disconnect in ipairs(widgets) do
					disconnect()
				end
			end
		end
	})

	for _, filter in ipairs(cfg.filtersOrder) do
		local optionWidget = self.offerListWindow.popupMenu:addOption(filter:titleCase(), function(option)
			if self.offerListWindow.popupMenu.currentSelectedOption then
				self.offerListWindow.popupMenu.currentSelectedOption:setOn(false)
			end

			option:setOn(true)

			self.offerListWindow.popupMenu.currentSelectedOption = option

			GameMarket:createExpandedFilterPopup(self.offerListWindow.popupMenu, option, option.filterName)
		end, nil, true)

		optionWidget.filterName = filter

		optionWidget:setId(filter:lower())
		self.offerListWindow.popupMenu:addSeparator()
	end

	g_ui.createWidget("FilterPopupMenuClearAll", self.offerListWindow.popupMenu)

	local displayPos = widget:getPosition()

	displayPos.y = displayPos.y + widget:getHeight() + 4

	self.offerListWindow.popupMenu:setFocusable(false)
	self.offerListWindow.popupMenu:display(displayPos, true, self.window)
	self.offerListWindow.popupMenu.clear_button:setEnabled(not table.empty(self.offerListWindow.filters))

	function self.offerListWindow.popupMenu.clear_button.onClick()
		self:clearAllFilters()
	end

	for _, filter in ipairs(cfg.filtersOrder) do
		local filters = self.offerListWindow.filters[filter:lower()]

		if filters then
			local option = self.offerListWindow.popupMenu:getChildById(filter:lower())

			for filterName in pairs(filters) do
				local label = g_ui.createWidget("FilterPopupMenuSubItem", option.content)

				label:setText(string.format("    %s", filterName:titleCase()))
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

function GameMarket:createExpandedFilterPopup(menu, parentOption, filterName)
	if not filterName then
		return
	end

	filterName = filterName:lower()

	local options = cfg.filters[filterName]

	if not options then
		return
	end

	menu.popup = g_ui.createWidget("FilterPopupMenu")

	for _, optionName in ipairs(options) do
		local option = menu.popup:addOption(optionName:titleCase(), function()
			return
		end, nil, true, "FilterPopupMenuButtonExpanded")

		option.filterName = optionName

		function option.checkbox.onCheckChange(widget, state)
			self:onFilterPanelCheckboxChange(widget, state)
		end

		option:setId(optionName:lower())
		self:loadFilterStates(filterName, option)
	end

	connect(menu.popup, {
		onDestroy = function()
			parentOption:setOn(false)
		end
	})

	local displayPos = menu:getPosition()

	displayPos.x = displayPos.x + menu.popup:getWidth() + 5
	displayPos.y = parentOption:getY()

	menu.popup:setFocusable(false)
	menu.popup:display(displayPos, true, self.window)
end

function GameMarket:onFilterPanelCheckboxChange(widget, state)
	if not self:canPerformAction() then
		widget:setChecked(not state, true)

		return
	end

	local categoryFilter = self.offerListWindow.popupMenu

	if not categoryFilter then
		print("no category filter")

		return
	end

	local filters = categoryFilter.popup

	if not filters then
		print("no filters")

		return
	end

	local selectedCategory = categoryFilter.currentSelectedOption

	if not selectedCategory then
		print("no selected category")

		return
	end

	local totalAmountOfFilters = 0

	for _, filters in pairs(self.offerListWindow.filters) do
		totalAmountOfFilters = totalAmountOfFilters + table.size(filters)
	end

	if state and totalAmountOfFilters >= cfg.maximumFilterAmount then
		widget:setChecked(false, true)
		GameNotification:display(NOTIFICATION_ERROR, nil, string.format("You can only select up to %d filters at a time.", cfg.maximumFilterAmount))

		return
	end

	local changedCategory = selectedCategory.filterName
	local changedFilter = widget:getParent().filterName

	if not changedCategory or not changedFilter then
		print("no changed category or filter")

		return
	end

	local consideredFilter = totalAmountOfFilters + 1

	if not state then
		consideredFilter = totalAmountOfFilters - 1
	end

	self.window.content_list.search.filter_panel.indicative:setEnabled(consideredFilter ~= 0)
	self.window.content_list.search.filter_panel.indicative:setText(consideredFilter)

	self.offerListWindow.filters[changedCategory] = self.offerListWindow.filters[changedCategory] or {}
	self.offerListWindow.filters[changedCategory][changedFilter] = state or nil

	if state and not selectedCategory.content.filters or not selectedCategory.content.filters[changedFilter] then
		local label = g_ui.createWidget("FilterPopupMenuSubItem", selectedCategory.content)

		label:setText(string.format("    %s", changedFilter:titleCase()))
		label:setId(changedFilter)

		selectedCategory.content.filters = selectedCategory.content.filters or {}
		selectedCategory.content.filters[changedFilter] = true
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

	if table.empty(self.offerListWindow.filters[changedCategory]) then
		self.offerListWindow.filters[changedCategory] = nil
	end

	categoryFilter.clear_button:setEnabled(not table.empty(self.offerListWindow.filters))
	self:requestSearch(true)
end

function GameMarket:loadFilterStates(parentCategory, optionWidget)
	if not optionWidget.filterName then
		return
	end

	local filters = self.offerListWindow.filters[parentCategory]

	if not filters then
		return
	end

	if filters[optionWidget.filterName] then
		optionWidget.checkbox:setChecked(true, true)
	end
end

function GameMarket:clearAllFilters()
	self.offerListWindow.filters = {}

	if self.offerListWindow.popupMenu then
		if self.offerListWindow.popupMenu.clear_button then
			self.offerListWindow.popupMenu.clear_button:setEnabled(false)
		end

		for _, child in ipairs(self.offerListWindow.popupMenu:getChildren()) do
			if child.content then
				child.content.filters = nil

				child.content:destroyChildren()
				child:setHeight(30)
			end
		end
	end

	self.window.content_list.search.filter_panel.indicative:setEnabled(false)
	self:requestSearch(true)
end

function GameMarket:requestSearch(newCacheIdentifier, resetPage, isCustomItemSearch)
	if not g_game.isOnline() then
		return
	end

	if not self:canPerformAction() then
		print("GameMarket.requestSearch - cannot perform action")
	end

	self:displayLock(true)

	local itemName = self.offerListWindow.search_panel.search_panel.search_input_panel.input:getText():lower()
	local clientId = cfg.MarketableItemsByName[itemName]

	if #itemName > 0 and not clientId then
		self.offerListWindow.search_panel.search_panel.search_input_panel.input:setText("", true)
	end

	if clientId then
		local category = cfg.MarketableItemsByCategory[clientId]

		if category and category ~= self.offerListWindow.selectedCategory.id then
			self:selectMarketCategory(category, true)
		end
	end

	local filters = self.offerListWindow.filters

	if self.offerListWindow.selectedCategory.id ~= 0 then
		filters.category = {}
		filters.category[self.offerListWindow.selectedCategory.id] = true
	else
		filters.category = nil
	end

	if clientId then
		filters["client id"] = {}
		filters["client id"][clientId] = true
	else
		filters["client id"] = nil
	end

	if resetPage or self.offerListWindow.page == 0 then
		self.offerListWindow.page = 1
	end

	if newCacheIdentifier then
		self.offerListWindow.cacheIdentifier = os.time()
	end

	if isCustomItemSearch and not self.customSetOrder then
		self:setSortOrder("asc", 7, true)
	end

	local data = {
		action = "fetch_items",
		filters = self.offerListWindow.filters,
		order = {
			direction = self.offerListWindow.orderDirection,
			type = self.offerListWindow.orderType
		},
		page = self.offerListWindow.page,
		offerType = self.offerListWindow.offerType,
		cacheIdentifier = self.offerListWindow.cacheIdentifier
	}

	self:sendOpcode(data)
end

function GameMarket.onGameStart()
	return
end

function GameMarket.onGameEnd()
	local self = GameMarket

	self:clearAllFilters()
	self:clearAllActiveOffersFilters()

	self.protocolItems = {}

	self:hide()
end

function GameMarket:displayOffers(offers, resultsAmount)
	offers = offers or {}

	local offerList = self.window.content_list.offers_panel
	local numOffers = #offers
	local offersPerPage = cfg.offersPerPage

	self.offerListWindow.totalOffers = resultsAmount

	self:updateOfferListPagination()

	for i, offer in ipairs(offers) do
		local widget = offerList:getChildById(string.format("offer_%d", i))

		widget:setEnabled(true)
		widget:setOpacity(1)

		function widget.onClick()
			self:displayInteractOfferWindow(offer.id, offer.offerType)
		end

		local columns = widget:getChildren()
		local itemWidget = columns[1]
		local sellerWidget = columns[2]
		local attribute1Widget = columns[3]
		local attribute2Widget = columns[4]
		local amountWidget = columns[5]
		local timeWidget = columns[6]
		local priceWidget = columns[7]

		itemWidget.item:setIcon()
		itemWidget.item:setItem()
		itemWidget.text:setTextColor("#CED2D9")

		itemWidget.item.UUID = offer.itemUUID

		sellerWidget.text:setText(offer.sellerName)
		amountWidget.text:setText(offer.amount)
		priceWidget.text:setText(offer.price)
		priceWidget.icon:update()
		timeWidget.text:setText(SecondsToClock(offer.remainingTime))

		if offer.remainingTime <= 0 then
			timeWidget.text:setText("Expired")
		end

		function timeWidget.onDestroy()
			if timeWidget.timeEvent then
				removeEvent(timeWidget.timeEvent)

				timeWidget.timeEvent = nil
			end
		end

		timeWidget.onDestroy()

		local function timeEvent()
			local remainingTime = offer.remainingTime - 1

			if remainingTime <= 0 then
				remainingTime = 0

				removeEvent(timeWidget.timeEvent)

				timeWidget.timeEvent = nil

				widget:setEnabled(false)
			end

			offer.remainingTime = remainingTime

			timeWidget.text:setText(SecondsToClock(remainingTime))

			if offer.remainingTime <= 0 then
				timeWidget.text:setText("Expired")
			end
		end

		timeWidget.timeEvent = cycleEvent(timeEvent, 1000)

		timeEvent()

		local protocolItem = self.protocolItems[offer.itemUUID]

		if protocolItem then
			protocolItem:setCount(offer.amount)
			itemWidget.item:setItem(protocolItem)
			itemWidget.text:setText(string.format("%s%s", protocolItem:getTier() > 0 and string.format("[T%d] ", protocolItem:getTier()) or "", protocolItem:getName():titleCase()))

			local textSize = itemWidget.text:getTextSize().width

			while textSize > 190 do
				itemWidget.text:setText(string.format("%s...", itemWidget.text:getText():sub(1, -5)))

				textSize = itemWidget.text:getTextSize().width
			end

			if itemWidget:isEnabled() then
				itemWidget.text:setTextColor(ItemQualityColors[math.max(protocolItem:getGrade(), protocolItem:getQuality())])
			end

			local primaryAttributes = protocolItem:getPrimaryStats()

			for index, attributes in ipairs(primaryAttributes) do
				local attributeWidget = index == 1 and attribute1Widget or attribute2Widget

				attributeWidget.icon:setImageSource(string.format("/images/ui/windows/market/attribute_%s", attributes[1]))
				attributeWidget.icon:setText()
			end

			for index = #primaryAttributes + 1, 2 do
				local attributeWidget = index == 1 and attribute1Widget or attribute2Widget

				attributeWidget.icon:setImageSource()
				attributeWidget.icon:setText("-")
			end
		elseif offer.category == cfg.CATEGORY_RAVENCOIN then
			local item = Item.create(cfg.DUMMY_RAVENCOIN_ITEMID)

			item:setName("RavenCoin")
			item:setDescription("Can be used to purchase things in the RavenStore.")
			item:setQualityName("Premium Currency")
			itemWidget.item:setItem(item)
			itemWidget.text:setText("RavenCoin")
			itemWidget.text:setTextColor("#FEFEC6")

			offer.itemUUID = 1

			for index = 1, 2 do
				local attributeWidget = index == 1 and attribute1Widget or attribute2Widget

				attributeWidget.icon:setImageSource()
				attributeWidget.icon:setText("-")
			end

			self.protocolItems[1] = item
		end
	end

	for i = numOffers + 1, offersPerPage do
		local offerWidget = offerList:getChildById(string.format("offer_%d", i))

		offerWidget:setEnabled(false)
		offerWidget:setOpacity(0)
	end
end

function GameMarket.onProtocolItem(item)
	local self = GameMarket

	self.protocolItems[item:getUUID()] = item
end

function GameMarket:setSortOrder(orderDirection, orderType, skipRequest)
	if self.offerListWindow.orderDirection == orderDirection and self.offerListWindow.orderType == orderType then
		return
	end

	self.offerListWindow.orderDirection = orderDirection
	self.offerListWindow.orderType = cfg.orderType[orderType]

	if not self.offerListWindow.orderType then
		return
	end

	if not skipRequest then
		self:changeOfferListPage(1, true)

		self.customSetOrder = true
	end

	local headerPanel = self.window.content_list.offers_panel.list_header
	local columns = headerPanel:getChildren()
	local sortingHeaderWidgets = {
		columns[5],
		columns[6],
		columns[7]
	}

	for _, widget in ipairs(sortingHeaderWidgets) do
		widget.sort_button.desc:setOn(false)
		widget.sort_button.asc:setOn(false)
	end

	local sortingWidget = columns[orderType]

	if orderDirection == "desc" then
		sortingWidget.sort_button.desc:setOn(true)
	else
		sortingWidget.sort_button.asc:setOn(true)
	end
end

function GameMarket:clearSearchInput(skipRequest)
	if not self.offerListWindow.search_panel then
		return
	end

	self.offerListWindow.search_panel.search_panel.search_input_panel.input:setEnabled(true)
	self.offerListWindow.search_panel.search_panel.search_input_panel.clear_button:setVisible(false)
	self.offerListWindow.search_panel.search_panel.search_input_panel.input:setText("", true)
	self.offerListWindow.search_panel.search_panel.search_input_panel.input:setTextPreview(tr("Search..."))

	if not self.customSetOrder then
		self:setSortOrder("desc", 6, true)
	end

	if not skipRequest then
		self:requestSearch(true)
	end
end

function GameMarket:scheduleForABit(call, time)
	time = time or cfg.timeForReloadingAfterPageNumberChange

	if self.updatingPageEvent then
		removeEvent(self.updatingPageEvent)
	end

	self.updatingPageEvent = scheduleEvent(call, time)
end

function GameMarket:changeOfferListPage(direction, force)
	local max_pages = math.ceil(self.offerListWindow.totalOffers / cfg.offersPerPage)
	local oldPage = self.offerListWindow.page
	local newPage = self.offerListWindow.page

	if direction == "next" then
		if newPage < max_pages then
			newPage = newPage + 1
		end
	elseif direction == "previous" then
		if newPage > 1 then
			newPage = newPage - 1
		end
	else
		direction = tonumber(direction)

		if not direction then
			return
		end

		newPage = math.min(math.max(direction, 1), max_pages)
	end

	self.offerListWindow.page = newPage

	self:updateOfferListPagination()

	if not force and oldPage == newPage then
		return
	end

	self:requestSearch(false)
end

function GameMarket:updateOfferListPagination()
	local max_pages = math.ceil(self.offerListWindow.totalOffers / cfg.offersPerPage)

	self.offerListWindow.page = math.min(self.offerListWindow.page, max_pages)

	self.offerListWindow.paginationPanel.page_edit:setText(self.offerListWindow.page, true)
	self.offerListWindow.paginationPanel.page_edit:setCursorPos(-1)
	self.offerListWindow.paginationPanel.prev_button:setOn(self.offerListWindow.page > 1)
	self.offerListWindow.paginationPanel.next_button:setOn(max_pages > self.offerListWindow.page)
	self.offerListWindow.paginationPanel.prev_button:setEnabled(self.offerListWindow.page > 1)
	self.offerListWindow.paginationPanel.next_button:setEnabled(max_pages > self.offerListWindow.page)
	self.offerListWindow.paginationPanel.page_count:setText(tr(string.format("of |%i|", max_pages)), true)
end

function GameMarket:canPerformAction()
	if self.loadingAnimation:isRunning() then
		return false
	end

	return self.unlockTime < g_clock.millis()
end

function GameMarket:displayLock(locking)
	if not self.locked and locking then
		self.window:blockInputPanel(true)
		self.loadingAnimation:start()
		self.offerListWindow.paginationPanel.page_edit:setEditable(false)

		self.locked = true
		self.unlocksAt = g_clock.millis() + cfg.minLockDuration
	elseif self.locked and not locking then
		local ms = self.unlocksAt - g_clock.millis()

		local function call()
			if self.unlockCallback then
				self.unlockCallback()

				self.unlockCallback = nil
			end

			self.locked = false

			addEvent(function()
				local disableRemoval = false
				local windows = {
					self.activeOffersWindow.createOfferWindow,
					self.offerListWindow.interactOfferWindow,
					self.activeOffersWindow.selectionWindow
				}

				for _, window in pairs(windows) do
					if window:isVisible() then
						disableRemoval = true
					end
				end

				if not disableRemoval then
					self.window:blockInputPanel(false)
				end

				self.loadingAnimation:stop()
				self.offerListWindow.paginationPanel.page_edit:setEditable(true)
			end)
		end

		if ms > 16 then
			scheduleEvent(call, ms)
		else
			call()
		end
	end
end

function GameMarket:onOfferTypeChanged(type)
	self.offerListWindow.offerType = type

	self:requestSearch(true, true)

	local header_panel = self.window.content_list.offers_panel.list_header
	local columns = header_panel:getChildren()
	local sellerWidget = columns[2]

	if type == cfg.OFFER_TYPE_SELL then
		sellerWidget.title:setText("Seller")
	elseif type == cfg.OFFER_TYPE_BUY then
		sellerWidget.title:setText("Buyer")
	end
end

function GameMarket:selectPanel(panel, force)
	if self.activeOffersWindow.popupMenu then
		self.activeOffersWindow.popupMenu:destroy()

		self.activeOffersWindow.popupMenu = nil
	end

	if self.offerListWindow.popupMenu then
		self.offerListWindow.popupMenu:destroy()

		self.offerListWindow.popupMenu = nil
	end

	local panelWidget

	if panel == "marketplace" then
		panelWidget = self.window.content_list
	elseif panel == "my orders" then
		panelWidget = self.window.content_active_offers
	elseif panel == "completed orders" then
		panelWidget = self.window.content_completed_offers
	end

	if not panelWidget then
		return
	end

	if not force and self.currentSelectedPanel == panelWidget then
		return
	end

	for _, child in ipairs(self.window.header_panel:getChildren()) do
		child:setOn(false)
	end

	local headerButton = self.window.header_panel:getChildById(panel)

	if headerButton then
		headerButton:setOn(true)
	end

	if self.currentSelectedPanel then
		self.currentSelectedPanel:hide()
	end

	panelWidget:show()

	self.currentSelectedPanel = panelWidget

	if panel == "marketplace" then
		self:requestSearch(true, true)
	elseif panel == "my orders" then
		self:requestActiveOffers(true, true)
	elseif panel == "completed orders" then
		self:requestCompletedOffers(true, true)
	end
end

function GameMarket.onBalanceChange(premium, silver)
	local self = GameMarket

	self.window.header_panel.silver.silver_amount:setText(silver)
end

function GameMarket.onRavencoinsBalanceChange(amount)
	local self = GameMarket

	self.window.header_panel.silver.ravencoin_amount:setText(FormatCommaNumber(amount))

	self.ravencoinAmount = amount
end

function GameMarket:displayInteractOfferWindow(offerId, offerType)
	local window = self.offerListWindow.interactOfferWindow

	if not window then
		return
	end

	window.top_panel.title:setText(string.format("%s Item", self.offerListWindow.offerType == cfg.OFFER_TYPE_SELL and "Buy" or "Sell"))

	local offer

	for _, offerData in ipairs(self.offerListWindow.currentOfferList) do
		if offerData.id == offerId then
			offer = offerData

			break
		end
	end

	if not offer then
		return
	end

	local columns = window.content.offer:getChildren()
	local itemWidget = columns[1]
	local sellerWidget = columns[2]
	local amountWidget = columns[3]
	local priceWidget = columns[4]
	local item = self.protocolItems[offer.itemUUID]

	if item then
		local tier = item:getTier()

		item:setCount(offer.amount)
		itemWidget.item:setItem(item)
		itemWidget.text:setText(string.format("%s%s", tier > 0 and string.format("[T%d] ", tier) or "", item:getName():titleCase()))

		local textSize = itemWidget.text:getTextSize().width

		while textSize > 150 do
			itemWidget.text:setText(string.format("%s...", itemWidget.text:getText():sub(1, -5)))

			textSize = itemWidget.text:getTextSize().width
		end

		itemWidget.text:setTextColor(ItemQualityColors[math.max(item:getGrade(), item:getQuality())])
	end

	itemWidget.itemUUID = nil

	sellerWidget.text:setText(offer.sellerName)
	amountWidget.text:setText(offer.amount)
	priceWidget.text:setText(offer.price)
	priceWidget.icon:update()

	local detailsPanel = window.content.details_panel
	local amount_edit = detailsPanel.amount_panel.amount_edit
	local slider = detailsPanel.amount_panel.count_slider
	local button_plus = detailsPanel.amount_panel.button_plus
	local button_max = detailsPanel.amount_panel.button_max

	function button_max.onClick()
		slider:setValue(slider:getMaximum())
	end

	local total_price = detailsPanel.total_amount_panel.price

	total_price.pricePerPiece = offer.price

	total_price:setText(offer.price * offer.amount)

	local balance = detailsPanel.new_balance_panel.balance

	balance.offerType = offerType
	balance.amount = self.window.header_panel.silver.silver_amount:getText():gsub(",", "")

	local buy_button = detailsPanel.buy_button

	buy_button:setText(string.format("%s Now", self.offerListWindow.offerType == cfg.OFFER_TYPE_SELL and "Buy" or "Sell"))

	function buy_button.onClick()
		local amount = slider:getValue()

		if amount <= 0 then
			return
		end

		window:hide()
		self:displayLock(true)

		local data = {
			action = offerType == cfg.OFFER_TYPE_SELL and "buy_offer" or "sell_offer",
			offerId = offerId,
			amount = amount,
			itemUUID = itemWidget.itemUUID
		}

		self:sendOpcode(data)
		scheduleEvent(function()
			self:requestSearch(true)
		end, 1000)
	end

	local info_panel = window.content.info_panel

	if offerType == cfg.OFFER_TYPE_SELL then
		button_plus.maximumValue = offer.amount

		buy_button:setEnabled(true)
		amount_edit:setEditable(true)
		slider:setMinimum(1)
		slider:setMaximum(offer.amount)
		slider:setEnabled(offer.amount > 1)
		amount_edit:setText(0)
		slider:setValue(offer.amount, true)
		info_panel:hide()
		itemWidget.expandButton:hide()
	elseif offerType == cfg.OFFER_TYPE_BUY then
		local availableItemCount = 0
		local items = g_game.getLocalPlayer():getMatchingItems(self.protocolItems[offer.itemUUID])

		for _, item in ipairs(items) do
			availableItemCount = availableItemCount + item:getCount()
		end

		if offer.category == cfg.CATEGORY_RAVENCOIN then
			availableItemCount = tonumber(self.window.header_panel.silver.ravencoin_amount:getText())
		end

		button_plus.maximumValue = availableItemCount

		buy_button:setEnabled(availableItemCount > 0)
		amount_edit:setEditable(availableItemCount > 0)
		slider:setEnabled(availableItemCount > 1)
		slider:setMinimum(math.min(1, availableItemCount))
		slider:setMaximum(math.min(offer.amount, availableItemCount))
		amount_edit:setText(0)
		slider:setValue(availableItemCount, true)
		itemWidget.expandButton:hide()

		if availableItemCount == 0 then
			info_panel:setText("You don't have the item in your inventory to sell.")
			info_panel:show()
		else
			info_panel:hide()

			if availableItemCount > 1 and item and item:getTier() > 0 then
				itemWidget.expandButton:show()

				function itemWidget.expandButton.onClick()
					itemWidget.expandButton:setOn(true)

					local menu = g_ui.createWidget("ItemSelectionPopupMenu")

					for _, item in ipairs(items) do
						local option = menu:addOption("", function()
							itemWidget.item:setItem(item)

							itemWidget.itemUUID = item:getUUID()
						end, nil, false, "ItemSelectionPopupMenuButton")

						option.item:setItem(item)
						option.name:setText(string.format("%s%s", item:getTier() > 0 and string.format("[T%d] ", item:getTier()) or "", item:getName():titleCase()))
						option.name:setTextColor(ItemQualityColors[math.max(item:getGrade(), item:getQuality())])
						option:setWidth(itemWidget:getWidth() + 20)

						local textSize = option.name:getTextSize().width

						while textSize > 180 do
							option.name:setText(string.format("%s...", option.name:getText():sub(1, -5)))

							textSize = option.name:getTextSize().width
						end
					end

					menu:setWidth(itemWidget:getWidth() + 20)

					local displayPos = itemWidget:getPosition()

					displayPos.y = displayPos.y + itemWidget:getHeight() + 4

					menu:display(displayPos)

					function menu.onDestroy()
						itemWidget.expandButton:setOn(false)
					end
				end
			else
				itemWidget.expandButton:hide()
			end
		end
	end

	window:show()
	window:setHeight(248 + (info_panel:isVisible() and info_panel:getHeight() + 12 or 0))
	window:raise()
end

function GameMarket:preparePremiumOnly()
	self.premiumOnly = true
	self.premiumStoreDisconnects = connect(modules.game_premium_store.GamePremiumStore.window, {
		onVisibilityChange = function(premiumStore, visible)
			if not visible then
				self:resetPremiumOnly()
				self:hide()

				if self.premiumStoreDisconnects then
					for _, disconnect in pairs(self.premiumStoreDisconnects) do
						disconnect()
					end
				end
			end
		end
	})

	self:populateCategories(true)
	self:selectMarketCategory(cfg.CATEGORY_RAVENCOIN, true)

	local searchBars = {
		self.window.content_list.search.search_panel.search_input_panel.input,
		self.window.content_active_offers.search.search_panel.search_input_panel.input,
		self.window.content_completed_offers.search.search_panel.search_input_panel.input
	}

	for _, searchBar in ipairs(searchBars) do
		searchBar:setText("RavenCoin", true)
		searchBar:setCursorPos(#searchBar:getText())
		searchBar:getParent():setEnabled(false)
		searchBar:setEnabled(false)
	end

	local filterWidgets = {
		self.window.content_list.search.filter_panel,
		self.window.content_active_offers.search.search_panel.filter_panel,
		self.window.content_completed_offers.search.search_panel.filter_panel
	}

	for _, filterWidget in ipairs(filterWidgets) do
		filterWidget:setEnabled(false)
	end
end

function GameMarket:resetPremiumOnly()
	self.premiumOnly = false

	local searchBars = {
		self.window.content_list.search.search_panel.search_input_panel.input,
		self.window.content_active_offers.search.search_panel.search_input_panel.input,
		self.window.content_completed_offers.search.search_panel.search_input_panel.input
	}

	for _, searchBar in ipairs(searchBars) do
		searchBar:setText("", true)
		searchBar:setCursorPos(0)
		searchBar:getParent():setEnabled(true)
		searchBar:setEnabled(true)
	end

	local filterWidgets = {
		self.window.content_list.search.filter_panel,
		self.window.content_active_offers.search.search_panel.filter_panel,
		self.window.content_completed_offers.search.search_panel.filter_panel
	}

	for _, filterWidget in ipairs(filterWidgets) do
		filterWidget:setEnabled(true)
	end

	self:populateCategories()
	self:selectMarketCategory(cfg.CATEGORY_ALL_ITEMS, true)
end
