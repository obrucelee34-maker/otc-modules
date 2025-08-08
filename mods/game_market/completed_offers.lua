-- chunkname: @/modules/game_market/completed_offers.lua

function GameMarket:requestCompletedOffers(newCacheIdentifier, resetPage)
	if not g_game.isOnline() then
		return
	end

	if not self:canPerformAction() then
		print("GameMarket.requestCompletedOffers - unable to perform action")
	end

	self:displayLock(true)

	local itemName = self.completedOffersWindow.search_panel.search_panel.search_input_panel.input:getText():lower()
	local clientId = cfg.MarketableItemsByName[itemName]

	if #itemName > 0 and not clientId then
		self.completedOffersWindow.search_panel.search_panel.search_input_panel.input:setText("", true)
	end

	local filters = self.completedOffersWindow.filters

	if clientId then
		filters["client id"] = {}
		filters["client id"][clientId] = true
	else
		filters["client id"] = nil
	end

	if resetPage or self.completedOffersWindow.page == 0 then
		self.completedOffersWindow.page = 1
	end

	if newCacheIdentifier then
		self.completedOffersWindow.cacheIdentifier = os.time()
	end

	local data = {
		action = "fetch_completed_offers",
		filters = self.completedOffersWindow.filters,
		order = {
			direction = self.completedOffersWindow.orderDirection,
			type = self.completedOffersWindow.orderType
		},
		page = self.completedOffersWindow.page,
		cacheIdentifier = self.completedOffersWindow.cacheIdentifier
	}

	self:sendOpcode(data)
end

function GameMarket:setCompletedOffersSortOrder(orderDirection, orderType)
	if self.completedOffersWindow.orderDirection == orderDirection and self.completedOffersWindow.orderType == orderType then
		return
	end

	self.completedOffersWindow.orderDirection = orderDirection
	self.completedOffersWindow.orderType = cfg.completedOffersOrderType[orderType]

	if not self.completedOffersWindow.orderType then
		return
	end

	self:changeCompletedOffersListPage(1, true)

	local headerPanel = self.window.content_completed_offers.offers_panel.list_header
	local columns = headerPanel:getChildren()
	local sortingHeaderWidgets = {
		columns[1],
		columns[2],
		columns[3],
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

function GameMarket:changeCompletedOffersListPage(direction, force)
	local max_pages = math.ceil(self.completedOffersWindow.totalOffers / cfg.offersPerPageCompletedOffers)
	local oldPage = self.completedOffersWindow.page
	local newPage = self.completedOffersWindow.page

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

	self.completedOffersWindow.page = newPage

	self:updateCompletedOffersListPagination()

	if not force and oldPage == newPage then
		return
	end

	self:requestCompletedOffers(false)
end

function GameMarket:updateCompletedOffersListPagination()
	local max_pages = math.ceil(self.completedOffersWindow.totalOffers / cfg.offersPerPageCompletedOffers)

	self.completedOffersWindow.page = math.min(self.completedOffersWindow.page, max_pages)

	self.completedOffersWindow.paginationPanel.page_edit:setText(self.completedOffersWindow.page, true)
	self.completedOffersWindow.paginationPanel.page_edit:setCursorPos(-1)
	self.completedOffersWindow.paginationPanel.prev_button:setOn(self.completedOffersWindow.page > 1)
	self.completedOffersWindow.paginationPanel.next_button:setOn(max_pages > self.completedOffersWindow.page)
	self.completedOffersWindow.paginationPanel.prev_button:setEnabled(self.completedOffersWindow.page > 1)
	self.completedOffersWindow.paginationPanel.next_button:setEnabled(max_pages > self.completedOffersWindow.page)
	self.completedOffersWindow.paginationPanel.page_count:setText(tr(string.format("of |%i|", max_pages)), true)
end

function GameMarket:onCompletedOffersSearchInputTextChange(widget, text)
	if self.completedOffersWindow.popupMenu then
		self.completedOffersWindow.popupMenu:destroy()

		self.completedOffersWindow.popupMenu = nil
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

	self.completedOffersWindow.popupMenu = g_ui.createWidget("SearchPopupMenu")
	self.completedOffersWindow.popupMenu.lastWidth = widget:getParent():getWidth()

	for index, match in ipairs(matches) do
		local item = self.completedOffersWindow.popupMenu:addOption(match:titleCase(), function()
			widget:setText(match:titleCase(), true)
			widget:setCursorPos(#match)
			widget:setEnabled(false)
			self:requestCompletedOffers(true, true)
		end)

		if index > 20 then
			break
		end
	end

	local displayPos = widget:getParent():getPosition()

	displayPos.y = displayPos.y + widget:getHeight() + 15

	self.completedOffersWindow.popupMenu:setFocusable(false)
	self.completedOffersWindow.popupMenu:display(displayPos, nil, self.window)

	widget.searchPopupIndex = 0

	local disconnects = connect(widget, {
		onKeyPress = GameMarket.onCompletedOffersSearchPopupMenuKeyPressed,
		onVisibilityChange = function(widget, visible)
			if not visible and self.completedOffersWindow.popupMenu then
				self.completedOffersWindow.popupMenu:destroy()

				self.completedOffersWindow.popupMenu = nil
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

	connect(self.completedOffersWindow.popupMenu, {
		onDestroy = function()
			for _, disconnect in ipairs(disconnects) do
				disconnect()
			end
		end
	})
end

function GameMarket.onCompletedOffersSearchPopupMenuKeyPressed(widget, keyCode)
	local self = GameMarket

	if not self.completedOffersWindow.popupMenu then
		return
	end

	if keyCode == KeyEnter then
		local index = widget.searchPopupIndex

		if not index then
			return
		end

		local child = self.completedOffersWindow.popupMenu:getChildByIndex(index)

		if not child then
			return
		end

		widget:setText(child:getText(), true)
		widget:setCursorPos(#widget:getText())
		widget:setEnabled(false)
		self.completedOffersWindow.popupMenu:destroy()

		self.completedOffersWindow.popupMenu = nil

		self:requestCompletedOffers(true, true)

		return
	end

	if keyCode == KeyEscape then
		self.completedOffersWindow.popupMenu:destroy()

		self.completedOffersWindow.popupMenu = nil

		widget:setText("", true)

		return
	end

	if keyCode ~= KeyTab then
		return
	end

	local index = widget.searchPopupIndex

	index = index or 1

	local currentChild = self.completedOffersWindow.popupMenu:getChildByIndex(index)

	if currentChild then
		currentChild:setOn(false)
	end

	if index + 1 > self.completedOffersWindow.popupMenu:getChildCount() then
		index = 0
	end

	local nextChild = self.completedOffersWindow.popupMenu:getChildByIndex(index + 1)

	if not nextChild then
		return
	end

	nextChild:setOn(true)

	widget.searchPopupIndex = index + 1
end

function GameMarket:clearCompletedOffersSearchInput()
	if not self.completedOffersWindow.search_panel then
		return
	end

	self.completedOffersWindow.search_panel.search_panel.search_input_panel.input:setEnabled(true)
	self.completedOffersWindow.search_panel.search_panel.search_input_panel.clear_button:setVisible(false)
	self.completedOffersWindow.search_panel.search_panel.search_input_panel.input:setText("", true)
	self.completedOffersWindow.search_panel.search_panel.search_input_panel.input:setTextPreview(tr("Search..."))
	self:requestCompletedOffers(true)
end

function GameMarket:clearAllCompletedOffersFilters()
	self.completedOffersWindow.filters = {}

	if self.completedOffersWindow.popupMenu then
		if self.completedOffersWindow.popupMenu.clear_button then
			self.completedOffersWindow.popupMenu.clear_button:setEnabled(false)
		end

		for _, child in ipairs(self.completedOffersWindow.popupMenu:getChildren()) do
			if child.content then
				child.content.filters = nil

				child.content:destroyChildren()
				child:setHeight(30)
			end
		end
	end

	self.completedOffersWindow.search_panel.search_panel.filter_panel.indicative:setEnabled(false)
	self:requestCompletedOffers(true)
end

function GameMarket:onCompletedOffersFilterPanelClick(widget, state)
	if self.completedOffersWindow.popupMenu then
		self.completedOffersWindow.popupMenu:destroy()

		self.completedOffersWindow.popupMenu = nil
	end

	self.completedOffersWindow.popupMenu = g_ui.createWidget("FilterPopupMenu")
	self.completedOffersWindow.popupMenu.lastWidth = widget:getWidth()

	local disconnects = {}

	table.insert(disconnects, connect(self.completedOffersWindow.search_panel, {
		onVisibilityChange = function(widget, visible)
			if not visible and self.completedOffersWindow.popupMenu then
				self.completedOffersWindow.popupMenu:destroy()

				self.completedOffersWindow.popupMenu = nil
			end
		end
	}))
	table.insert(disconnects, connect(g_ui.getRootWidget(), {
		onMousePress = function(widget, mousePos)
			if not self.completedOffersWindow.popupMenu then
				return
			end

			if not self.completedOffersWindow.popupMenu:containsPoint(mousePos) then
				if self.completedOffersWindow.popupMenu.menu then
					if not self.completedOffersWindow.popupMenu.popup:containsPoint(mousePos) then
						self.completedOffersWindow.popupMenu.popup:destroy()

						self.completedOffersWindow.popupMenu.popup = nil
					end

					return
				end

				self.completedOffersWindow.popupMenu:destroy()

				self.completedOffersWindow.popupMenu = nil
			end
		end
	}))
	connect(self.completedOffersWindow.popupMenu, {
		onDestroy = function()
			widget:setOn(false)

			if self.completedOffersWindow.popupMenu.popup then
				self.completedOffersWindow.popupMenu.popup:destroy()

				self.completedOffersWindow.popupMenu.popup = nil
			end

			for _, widgets in ipairs(disconnects) do
				for _, disconnect in ipairs(widgets) do
					disconnect()
				end
			end
		end
	})

	for _, filter in ipairs(cfg.filtersOrder) do
		local optionWidget = self.completedOffersWindow.popupMenu:addOption(filter:titleCase(), function(option)
			if self.completedOffersWindow.popupMenu.currentSelectedOption then
				self.completedOffersWindow.popupMenu.currentSelectedOption:setOn(false)
			end

			option:setOn(true)

			self.completedOffersWindow.popupMenu.currentSelectedOption = option

			GameMarket:createCompletedOffersExpandedFilterPopup(self.completedOffersWindow.popupMenu, option, filter)
		end, nil, true)

		optionWidget.filterName = filter

		self.completedOffersWindow.popupMenu:addSeparator()
	end

	local clearAllFiltersButton = g_ui.createWidget("FilterPopupMenuClearAll", self.completedOffersWindow.popupMenu)

	function clearAllFiltersButton.onClick()
		self:clearAllCompletedOffersFilters()
	end

	local displayPos = widget:getPosition()

	displayPos.y = displayPos.y + widget:getHeight() + 4

	self.completedOffersWindow.popupMenu:setFocusable(false)
	self.completedOffersWindow.popupMenu:display(displayPos, true, self.window)
	self.completedOffersWindow.popupMenu.clear_button:setEnabled(not table.empty(self.completedOffersWindow.filters))

	for _, filter in ipairs(cfg.filtersOrder) do
		local filters = self.completedOffersWindow.filters[filter:lower()]

		if filters then
			local option = self.completedOffersWindow.popupMenu:getChildById(filter:lower())

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

function GameMarket:createCompletedOffersExpandedFilterPopup(menu, parentOption, filterName)
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
			self:onCompletedOffersFilterPanelCheckboxChange(widget, state)
		end

		option.filterName = optionName

		self:loadCompletedOffersWindowFilterStates(filterName, option)
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

function GameMarket:onCompletedOffersFilterPanelCheckboxChange(widget, state)
	if not self:canPerformAction() then
		widget:setChecked(not state, true)

		return
	end

	local categoryFilter = self.completedOffersWindow.popupMenu

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

	for _, filters in pairs(self.completedOffersWindow.filters) do
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

	local filterPanel = self.completedOffersWindow.search_panel.search_panel.filter_panel

	filterPanel.indicative:setEnabled(consideredFilter ~= 0)
	filterPanel.indicative:setText(consideredFilter)

	self.completedOffersWindow.filters[changedCategory] = self.completedOffersWindow.filters[changedCategory] or {}
	self.completedOffersWindow.filters[changedCategory][changedFilter] = state or nil

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

	if table.empty(self.completedOffersWindow.filters[changedCategory]) then
		self.completedOffersWindow.filters[changedCategory] = nil
	end

	categoryFilter.clear_button:setEnabled(not table.empty(self.completedOffersWindow.filters))
	self:requestCompletedOffers(true)
end

function GameMarket:loadCompletedOffersWindowFilterStates(parentCategory, optionWidget)
	local filters = self.completedOffersWindow.filters[parentCategory]

	if not filters then
		return
	end

	local filterName = optionWidget.filterName

	if filterName and filters[filterName] then
		optionWidget.checkbox:setChecked(true, true)
	end
end

function GameMarket:displayCompletedOffers(offers, resultsAmount)
	offers = offers or {}

	local offerList = self.window.content_completed_offers.offers_panel
	local numOffers = #offers
	local offersPerPage = cfg.offersPerPageCompletedOffers

	self.completedOffersWindow.totalOffers = resultsAmount

	self:updateCompletedOffersListPagination()

	for i, offer in ipairs(offers) do
		local widget = offerList:getChildById(string.format("offer_%d", i))

		widget:setEnabled(true)
		widget:setOpacity(1)

		local columns = widget:getChildren()
		local transactionWidget = columns[1]
		local statusWidget = columns[2]
		local dateWidget = columns[3]
		local itemWidget = columns[4]
		local attribute1Widget = columns[5]
		local attribute2Widget = columns[6]
		local amountWidget = columns[7]
		local priceWidget = columns[8]
		local totalPriceWidget = columns[9]
		local y, m, d = string.match(offer.timestamp, "(%d+)-(%d+)-(%d+)")

		dateWidget.text:setText(string.format("%s.%s.%s", d, m, y))

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
		statusWidget.text:setText(tr(cfg.offerStateText[offer.state]))
		statusWidget.text:setTextColor(cfg.offerStateColor[offer.state])

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
