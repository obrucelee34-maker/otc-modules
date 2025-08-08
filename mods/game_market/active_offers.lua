-- chunkname: @/modules/game_market/active_offers.lua

function GameMarket:requestActiveOffers(newCacheIdentifier, resetPage)
	if not g_game.isOnline() then
		return
	end

	if not self:canPerformAction() then
		print("GameMarket.requestActiveOffers - unable to perform action")
	end

	self:displayLock(true)

	local itemName = self.activeOffersWindow.search_panel.search_panel.search_input_panel.input:getText():lower()
	local clientId = cfg.MarketableItemsByName[itemName]

	if #itemName > 0 and not clientId then
		self.activeOffersWindow.search_panel.search_panel.search_input_panel.input:setText("", true)
	end

	local filters = self.activeOffersWindow.filters

	if clientId then
		filters["client id"] = {}
		filters["client id"][clientId] = true
	else
		filters["client id"] = nil
	end

	if resetPage or self.activeOffersWindow.page == 0 then
		self.activeOffersWindow.page = 1
	end

	if newCacheIdentifier then
		self.activeOffersWindow.cacheIdentifier = os.time()
	end

	local data = {
		action = "fetch_active_offers",
		filters = self.activeOffersWindow.filters,
		order = {
			direction = self.activeOffersWindow.orderDirection,
			type = self.activeOffersWindow.orderType
		},
		page = self.activeOffersWindow.page,
		cacheIdentifier = self.activeOffersWindow.cacheIdentifier
	}

	self:sendOpcode(data)
end

function GameMarket:setActiveOffersSortOrder(orderDirection, orderType)
	if self.activeOffersWindow.orderDirection == orderDirection and self.activeOffersWindow.orderType == orderType then
		return
	end

	self.activeOffersWindow.orderDirection = orderDirection
	self.activeOffersWindow.orderType = cfg.activeOffersOrderType[orderType]

	if not self.activeOffersWindow.orderType then
		return
	end

	self:changeActiveOffersListPage(1, true)

	local headerPanel = self.window.content_active_offers.offers_panel.list_header
	local columns = headerPanel:getChildren()
	local sortingHeaderWidgets = {
		columns[1],
		columns[2],
		columns[6],
		columns[7],
		columns[8]
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

function GameMarket:changeActiveOffersListPage(direction, force)
	local max_pages = math.ceil(self.activeOffersWindow.totalOffers / cfg.offersPerPageActiveOffers)
	local oldPage = self.activeOffersWindow.page
	local newPage = self.activeOffersWindow.page

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

	self.activeOffersWindow.page = newPage

	self:updateActiveOffersListPagination()

	if not force and oldPage == newPage then
		return
	end

	self:requestActiveOffers(false)
end

function GameMarket:updateActiveOffersListPagination()
	local max_pages = math.ceil(self.activeOffersWindow.totalOffers / cfg.offersPerPageActiveOffers)

	self.activeOffersWindow.page = math.min(self.activeOffersWindow.page, max_pages)

	self.activeOffersWindow.paginationPanel.page_edit:setText(self.activeOffersWindow.page, true)
	self.activeOffersWindow.paginationPanel.page_edit:setCursorPos(-1)
	self.activeOffersWindow.paginationPanel.prev_button:setOn(self.activeOffersWindow.page > 1)
	self.activeOffersWindow.paginationPanel.next_button:setOn(max_pages > self.activeOffersWindow.page)
	self.activeOffersWindow.paginationPanel.prev_button:setEnabled(self.activeOffersWindow.page > 1)
	self.activeOffersWindow.paginationPanel.next_button:setEnabled(max_pages > self.activeOffersWindow.page)
	self.activeOffersWindow.paginationPanel.page_count:setText(tr(string.format("of |%i|", max_pages)), true)
end

function GameMarket:onActiveOffersSearchInputTextChange(widget, text)
	if self.activeOffersWindow.popupMenu then
		self.activeOffersWindow.popupMenu:destroy()

		self.activeOffersWindow.popupMenu = nil
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

	self.activeOffersWindow.popupMenu = g_ui.createWidget("SearchPopupMenu")
	self.activeOffersWindow.popupMenu.lastWidth = widget:getParent():getWidth()

	for index, match in ipairs(matches) do
		local item = self.activeOffersWindow.popupMenu:addOption(match:titleCase(), function()
			widget:setText(match:titleCase(), true)
			widget:setCursorPos(#match)
			widget:setEnabled(false)
			self:requestActiveOffers(true, true)
		end)

		if index > 20 then
			break
		end
	end

	local displayPos = widget:getParent():getPosition()

	displayPos.y = displayPos.y + widget:getHeight() + 15

	self.activeOffersWindow.popupMenu:setFocusable(false)
	self.activeOffersWindow.popupMenu:display(displayPos, nil, self.window)

	widget.searchPopupIndex = 0

	local disconnects = connect(widget, {
		onKeyPress = GameMarket.onActiveOffersSearchPopupMenuKeyPressed,
		onVisibilityChange = function(widget, visible)
			if not visible and self.activeOffersWindow.popupMenu then
				self.activeOffersWindow.popupMenu:destroy()

				self.activeOffersWindow.popupMenu = nil
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

	connect(self.activeOffersWindow.popupMenu, {
		onDestroy = function()
			for _, disconnect in ipairs(disconnects) do
				disconnect()
			end
		end
	})
end

function GameMarket.onActiveOffersSearchPopupMenuKeyPressed(widget, keyCode)
	local self = GameMarket

	if not self.activeOffersWindow.popupMenu then
		return
	end

	if keyCode == KeyEnter then
		local index = widget.searchPopupIndex

		if not index then
			return
		end

		local child = self.activeOffersWindow.popupMenu:getChildByIndex(index)

		if not child then
			return
		end

		widget:setText(child:getText(), true)
		widget:setCursorPos(#widget:getText())
		widget:setEnabled(false)
		self.activeOffersWindow.popupMenu:destroy()

		self.activeOffersWindow.popupMenu = nil

		self:requestActiveOffers(true, true)

		return
	end

	if keyCode == KeyEscape then
		self.activeOffersWindow.popupMenu:destroy()

		self.activeOffersWindow.popupMenu = nil

		widget:setText("", true)

		return
	end

	if keyCode ~= KeyTab then
		return
	end

	local index = widget.searchPopupIndex

	index = index or 1

	local currentChild = self.activeOffersWindow.popupMenu:getChildByIndex(index)

	if currentChild then
		currentChild:setOn(false)
	end

	if index + 1 > self.activeOffersWindow.popupMenu:getChildCount() then
		index = 0
	end

	local nextChild = self.activeOffersWindow.popupMenu:getChildByIndex(index + 1)

	if not nextChild then
		return
	end

	nextChild:setOn(true)

	widget.searchPopupIndex = index + 1
end

function GameMarket:clearActiveOffersSearchInput()
	if not self.activeOffersWindow.search_panel then
		return
	end

	self.activeOffersWindow.search_panel.search_panel.search_input_panel.input:setEnabled(true)
	self.activeOffersWindow.search_panel.search_panel.search_input_panel.clear_button:setVisible(false)
	self.activeOffersWindow.search_panel.search_panel.search_input_panel.input:setText("", true)
	self.activeOffersWindow.search_panel.search_panel.search_input_panel.input:setTextPreview(tr("Search..."))
	self:requestActiveOffers(true)
end

function GameMarket:clearAllActiveOffersFilters()
	self.activeOffersWindow.filters = {}

	if self.activeOffersWindow.popupMenu then
		if self.activeOffersWindow.popupMenu.clear_button then
			self.activeOffersWindow.popupMenu.clear_button:setEnabled(false)
		end

		for _, child in ipairs(self.activeOffersWindow.popupMenu:getChildren()) do
			if child.content then
				child.content.filters = nil

				child.content:destroyChildren()
				child:setHeight(30)
			end
		end
	end

	self.activeOffersWindow.search_panel.search_panel.filter_panel.indicative:setEnabled(false)
	self:requestActiveOffers(true)
end

function GameMarket:onActiveOffersFilterPanelClick(widget, state)
	if self.activeOffersWindow.popupMenu then
		self.activeOffersWindow.popupMenu:destroy()

		self.activeOffersWindow.popupMenu = nil
	end

	self.activeOffersWindow.popupMenu = g_ui.createWidget("FilterPopupMenu")
	self.activeOffersWindow.popupMenu.lastWidth = widget:getWidth()

	local disconnects = {}

	table.insert(disconnects, connect(self.activeOffersWindow.search_panel, {
		onVisibilityChange = function(widget, visible)
			if not visible and self.activeOffersWindow.popupMenu then
				self.activeOffersWindow.popupMenu:destroy()

				self.activeOffersWindow.popupMenu = nil
			end
		end
	}))
	table.insert(disconnects, connect(g_ui.getRootWidget(), {
		onMousePress = function(widget, mousePos)
			if not self.activeOffersWindow.popupMenu then
				return
			end

			if not self.activeOffersWindow.popupMenu:containsPoint(mousePos) then
				if self.activeOffersWindow.popupMenu.menu then
					if not self.activeOffersWindow.popupMenu.popup:containsPoint(mousePos) then
						self.activeOffersWindow.popupMenu.popup:destroy()

						self.activeOffersWindow.popupMenu.popup = nil
					end

					return
				end

				self.activeOffersWindow.popupMenu:destroy()

				self.activeOffersWindow.popupMenu = nil
			end
		end
	}))
	connect(self.activeOffersWindow.popupMenu, {
		onDestroy = function()
			widget:setOn(false)

			if self.activeOffersWindow.popupMenu.popup then
				self.activeOffersWindow.popupMenu.popup:destroy()

				self.activeOffersWindow.popupMenu.popup = nil
			end

			for _, widgets in ipairs(disconnects) do
				for _, disconnect in ipairs(widgets) do
					disconnect()
				end
			end
		end
	})

	for _, filter in ipairs(cfg.filtersOrder) do
		local optionWidget = self.activeOffersWindow.popupMenu:addOption(filter:titleCase(), function(option)
			if self.activeOffersWindow.popupMenu.currentSelectedOption then
				self.activeOffersWindow.popupMenu.currentSelectedOption:setOn(false)
			end

			option:setOn(true)

			self.activeOffersWindow.popupMenu.currentSelectedOption = option

			GameMarket:createActiveOffersExpandedFilterPopup(self.activeOffersWindow.popupMenu, option, filter)
		end, nil, true)

		optionWidget.filterName = filter

		self.activeOffersWindow.popupMenu:addSeparator()
	end

	local clearAllFiltersButton = g_ui.createWidget("FilterPopupMenuClearAll", self.activeOffersWindow.popupMenu)

	function clearAllFiltersButton.onClick()
		self:clearAllActiveOffersFilters()
	end

	local displayPos = widget:getPosition()

	displayPos.y = displayPos.y + widget:getHeight() + 4

	self.activeOffersWindow.popupMenu:setFocusable(false)
	self.activeOffersWindow.popupMenu:display(displayPos, true, self.window)
	self.activeOffersWindow.popupMenu.clear_button:setEnabled(not table.empty(self.activeOffersWindow.filters))

	for _, filter in ipairs(cfg.filtersOrder) do
		local filters = self.activeOffersWindow.filters[filter:lower()]

		if filters then
			local option = self.activeOffersWindow.popupMenu:getChildById(filter:lower())

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

function GameMarket:createActiveOffersExpandedFilterPopup(menu, parentOption, filterName)
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

		function option.checkbox.onCheckChange(widget, state)
			self:onActiveOffersFilterPanelCheckboxChange(widget, state)
		end

		option.filterName = optionName

		self:loadActiveOffersWindowFilterStates(filterName, option)
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

function GameMarket:onActiveOffersFilterPanelCheckboxChange(widget, state)
	if not self:canPerformAction() then
		widget:setChecked(not state, true)

		return
	end

	local categoryFilter = self.activeOffersWindow.popupMenu

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

	local totalAmountOfFilters = 0

	for _, filters in pairs(self.activeOffersWindow.filters) do
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
		return
	end

	local consideredFilter = totalAmountOfFilters + 1

	if not state then
		consideredFilter = totalAmountOfFilters - 1
	end

	local filterPanel = self.activeOffersWindow.search_panel.search_panel.filter_panel

	filterPanel.indicative:setEnabled(consideredFilter ~= 0)
	filterPanel.indicative:setText(consideredFilter)

	self.activeOffersWindow.filters[changedCategory] = self.activeOffersWindow.filters[changedCategory] or {}
	self.activeOffersWindow.filters[changedCategory][changedFilter] = state or nil

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

	if table.empty(self.activeOffersWindow.filters[changedCategory]) then
		self.activeOffersWindow.filters[changedCategory] = nil
	end

	categoryFilter.clear_button:setEnabled(not table.empty(self.activeOffersWindow.filters))
	self:requestActiveOffers(true)
end

function GameMarket:loadActiveOffersWindowFilterStates(parentCategory, optionWidget)
	local filters = self.activeOffersWindow.filters[parentCategory]

	if not filters then
		return
	end

	local filterName = optionWidget.filterName

	if filterName and filters[filterName] then
		optionWidget.checkbox:setChecked(true, true)
	end
end

function GameMarket:displayActiveOffers(offers, resultsAmount)
	offers = offers or {}

	local offerList = self.window.content_active_offers.offers_panel
	local numOffers = #offers
	local offersPerPage = cfg.offersPerPageActiveOffers

	self.activeOffersWindow.totalOffers = resultsAmount

	self:updateActiveOffersListPagination()

	for i, offer in ipairs(offers) do
		local widget = offerList:getChildById(string.format("offer_%d", i))

		widget:setEnabled(true)
		widget:setOpacity(1)

		function widget.onMousePress(widget, mousePos, mouseButton)
			if mouseButton == MouseRightButton then
				local menu = g_ui.createWidget("PopupMenu")

				menu:addOption("Cancel offer", function()
					self:displayLock(true)
					self:sendOpcode({
						action = "cancel_offer",
						offerId = offer.id
					})
					scheduleEvent(function()
						self:requestActiveOffers()
					end, 1000)
				end)
				menu:display(mousePos, nil, self.window)
			end
		end

		local columns = widget:getChildren()
		local transactionWidget = columns[1]
		local timeWidget = columns[2]
		local itemWidget = columns[3]
		local attribute1Widget = columns[4]
		local attribute2Widget = columns[5]
		local amountWidget = columns[6]
		local priceWidget = columns[7]
		local totalPriceWidget = columns[8]

		itemWidget.item.UUID = offer.itemUUID

		amountWidget.text:setText(offer.amount)
		priceWidget.text:setText(offer.price)
		priceWidget.icon:update()
		totalPriceWidget.text:setText(offer.totalPrice)
		totalPriceWidget.icon:update()
		transactionWidget.icon:setText(offer.offerType == OFFER_TYPE_SELL and "SELL" or "BUY")
		transactionWidget.icon:setImageColor(offer.offerType == OFFER_TYPE_SELL and "#FF5151" or "#77D463")
		transactionWidget.icon:setImageSource("/images/ui/windows/market/offer_type")
		transactionWidget.icon:setPadding(8)
		transactionWidget.icon:setPaddingLeft(10)
		transactionWidget.icon:setPaddingRight(10)
		transactionWidget.icon:setImageBorder(5)
		transactionWidget.icon:setColor("#000000")
		transactionWidget.icon:setTextHorizontalAutoResize(true)
		timeWidget.text:setText(SecondsToClock(offer.remainingTime))

		if offer.remainingTime <= 0 then
			timeWidget.text:setText("Processing...")
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
				timeWidget.text:setText("Processing...")
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

			while textSize > 300 do
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
