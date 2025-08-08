-- chunkname: @/modules/game_market/new_offer.lua

function GameMarket:displayCreateOfferSelectionWindow()
	local window = self.activeOffersWindow.selectionWindow

	if not window then
		return
	end

	if not cfg.ENABLE_RAVENCOINS then
		self:displayCreateOfferWindow("items")

		return
	end

	if self.premiumOnly then
		self:displayCreateOfferWindow("ravencoins")

		return
	end

	window:show()
	window:raise()
end

function GameMarket:displayCreateOfferWindow(offerType)
	local window = self.activeOffersWindow.createOfferWindow

	if not window then
		return
	end

	local itemDropPanel = window.content_sell_offers.left_panel.place_item_panel

	itemDropPanel.onDrop = self.onCreateOfferDropItem

	if offerType == "ravencoins" then
		local dummyWidget = g_ui.createWidget("Item")
		local dummyItem = Item.create(cfg.DUMMY_RAVENCOIN_ITEMID)

		g_things.getThingType(cfg.DUMMY_RAVENCOIN_ITEMID, ThingCategoryItem):setStackable(true)
		dummyItem:setCount(self.ravencoinAmount or 0)
		dummyItem:setName("RavenCoin")
		dummyItem:setQualityName("Premium Currency")
		dummyItem:setDescription("Can be used to purchase things in the RavenStore.")
		dummyItem:setUUID("ravencoin")
		dummyWidget:setItem(dummyItem)

		self.ravencoinTransaction = true

		connect(window, {
			onVisibilityChange = function(widget, visible)
				if not visible then
					dummyWidget:destroy()
				end
			end
		})

		itemDropPanel.onDrop = nil

		addEvent(function()
			self.onCreateOfferDropItem(itemDropPanel, dummyWidget, true)
		end)
	else
		self.ravencoinTransaction = false
	end

	self:selectCreateOfferPanel("sell_offers")
	self:setSimilarOffersSortOrder("asc", 3)
	window.place_offer_panel.place_offer_button:setEnabled(false)
	window:show()
	window:raise()
end

function GameMarket:hideCreateOfferWindow()
	local window = self.activeOffersWindow.createOfferWindow

	if not window then
		return
	end

	self:clearCreateOfferItem()

	if self.createOfferWindow.popupMenu then
		self.createOfferWindow.popupMenu:destroy()

		self.createOfferWindow.popupMenu = nil
	end

	window:hide()
end

function GameMarket:selectCreateOfferPanel(panel)
	local window = self.activeOffersWindow.createOfferWindow

	if not window then
		return
	end

	local buttonName

	if panel == "sell_offers" then
		window.content_sell_offers:show()
		window.content_buy_offers:hide()

		buttonName = "Place Sell Offer"

		window.type_panel.sell_offers:setOn(true)
		window.type_panel.buy_offers:setOn(false)
	else
		window.content_sell_offers:hide()
		window.content_buy_offers:show()

		if self.ravencoinTransaction then
			self:selectCreateOfferSelectPremiumToken()
		else
			window.content_buy_offers.select_item_panel:show()
			window.content_buy_offers.left_panel:hide()
			window.content_buy_offers.right_panel:hide()
		end

		buttonName = "Place Buy Offer"

		window.type_panel.sell_offers:setOn(false)
		window.type_panel.buy_offers:setOn(true)
	end

	window.place_offer_panel.place_offer_button:setText(buttonName)

	function window.place_offer_panel.place_offer_button.onClick()
		self:onCreateOfferButtonClick(panel)
	end

	self.createOfferWindow.type = panel
	self.createOfferWindow.page = 1
	self.createOfferWindow.orderDirection = "asc"
	self.createOfferWindow.orderType = "price"
	self.createOfferWindow.totalOffers = 0
	self.createOfferWindow.cacheIdentifier = nil
	self.createOfferWindow.paginationPanel = window["content_" .. panel].right_panel.pagination_panel

	if not self.ravencoinTransaction then
		self:clearCreateOfferItem()
		self:updateSimilarOffersListPagination()
	end

	self:setSimilarOffersSortOrder("asc", 3, true)
end

function GameMarket.onCreateOfferDropItem(widget, droppedWidget)
	local self = GameMarket
	local window = self.activeOffersWindow.createOfferWindow

	if not window then
		return
	end

	local item = droppedWidget:getItem()

	if not item then
		return
	end

	self:clearCreateOfferItem()

	local itemDropPanel = window.content_sell_offers.left_panel.place_item_panel

	itemDropPanel.parentItemWidget = droppedWidget

	itemDropPanel:setChecked(true)
	itemDropPanel.item:setItem(item)
	itemDropPanel.text:hide()

	local disconnects = connect(droppedWidget, {
		onItemChange = function()
			GameMarket:clearCreateOfferItem()
		end
	})

	itemDropPanel.droppedWidgetDisconnects = disconnects

	itemDropPanel.item_name:setText(item:getName():titleCase())
	itemDropPanel.item_name:setTextColor(ItemQualityColors[math.max(item:getGrade(), item:getQuality())])
	itemDropPanel.item_grade:setText(item:getQualityName())
	itemDropPanel.item_grade:setColor(ItemQualityColors[math.max(item:getGrade(), item:getQuality())])

	local itemTypeRaw = item:getItemType()
	local itemType = itemTypeRaw:titleCase()
	local profession = item:getProfession()
	local hasProfession = profession and profession ~= ProfessionNone
	local professionName = hasProfession and ProfessionNames[profession] or ""

	itemType = professionName ~= "" and professionName .. " " .. itemType or itemType

	local tier = item:getTier()
	local warforged = item:isWarforged()

	itemDropPanel.item_type:setText(string.format("[T%d] %s%s", tier, itemType, warforged and " (Warforged)" or ""))
	itemDropPanel.item_type:setVisible(tier >= 0)

	local quantityPanel = window.content_sell_offers.left_panel.quantity_panel

	quantityPanel.amount_panel.minimum = 1
	quantityPanel.amount_panel.maximum = item:getCount()

	local amountEdit = window.content_sell_offers.left_panel.quantity_panel.amount_panel.amount_edit

	amountEdit:setText(item:getCount())

	local priceEdit = window.content_sell_offers.left_panel.price_panel.price_input

	disconnects = connect(priceEdit, {
		onTextChange = function(widget, text)
			local price = tonumber(text) or 0

			if price < cfg.minPricePerPiece then
				price = 0
			end

			local player = g_game.getLocalPlayer()
			local tax = player:isPremium() and cfg.taxSellOfferPremiumMultiplier or cfg.taxSellOfferMultiplier
			local totalPrice = math.floor(price * (tonumber(amountEdit:getText()) or 0) * tax)
			local totalPriceWidget = window.content_sell_offers.left_panel.price_panel.total_amount_panel.price

			totalPriceWidget:setText(totalPrice)
		end
	})
	priceEdit.disconnects = disconnects
	disconnects = connect(amountEdit, {
		onTextChange = function(widget, text)
			local price = tonumber(priceEdit:getText()) or 0

			if price < cfg.minPricePerPiece then
				price = 0
			end

			local player = g_game.getLocalPlayer()
			local tax = player:isPremium() and cfg.taxSellOfferPremiumMultiplier or cfg.taxSellOfferMultiplier
			local totalPrice = math.floor(price * (tonumber(text) or 0) * tax)
			local totalPriceWidget = window.content_sell_offers.left_panel.price_panel.total_amount_panel.price

			totalPriceWidget:setText(totalPrice)
		end
	})
	amountEdit.disconnects = disconnects

	self:requestSimilarOffers("sell_offers", true)
	window.place_offer_panel.place_offer_button:setEnabled(true)
end

function GameMarket:clearCreateOfferItem()
	local window = self.activeOffersWindow.createOfferWindow

	if not window then
		return
	end

	local itemDropPanel = window.content_sell_offers.left_panel.place_item_panel

	itemDropPanel.text:show()
	itemDropPanel:setChecked(false)
	itemDropPanel.item:setItem(nil)
	itemDropPanel.item_name:setText("")
	itemDropPanel.item_grade:setText("")
	itemDropPanel.item_type:setText("")

	if itemDropPanel.droppedWidgetDisconnects then
		for _, disconnect in pairs(itemDropPanel.droppedWidgetDisconnects) do
			disconnect()
		end
	end

	local quantityPanel = window.content_sell_offers.left_panel.quantity_panel

	quantityPanel.amount_panel.minimum = 0
	quantityPanel.amount_panel.maximum = 0

	local amountEdit = window.content_sell_offers.left_panel.quantity_panel.amount_panel.amount_edit

	amountEdit:setText("0")

	if amountEdit.disconnects then
		for _, disconnect in pairs(amountEdit.disconnects) do
			disconnect()
		end
	end

	local priceEdit = window.content_sell_offers.left_panel.price_panel.price_input

	if priceEdit.disconnects then
		for _, disconnect in pairs(priceEdit.disconnects) do
			disconnect()
		end
	end

	priceEdit:setText()

	local rightPanel = window.content_sell_offers.right_panel

	for i = 1, 4 do
		local offerPanel = rightPanel["offer_" .. i]

		offerPanel:hide()
	end

	local noOffersLabel = rightPanel.no_offers_label

	noOffersLabel:show()

	self.createOfferWindow.totalOffers = 0

	self:updateSimilarOffersListPagination()

	itemDropPanel = window.content_buy_offers.left_panel.place_item_panel

	itemDropPanel.item:setItem(nil)
	itemDropPanel.item_name:setText("")
	itemDropPanel.item_grade:setText("")
	itemDropPanel.item_type:setText("")
	itemDropPanel.item_name:setTextColor("#ffffff")
	itemDropPanel.item_grade:setTextColor("#ffffff")

	local rarityPanel = self.activeOffersWindow.createOfferWindow.content_buy_offers.left_panel.details_panel

	rarityPanel.rarity_panel.text:setTextColor("#ffffff")
	self:clearBuyOfferAttributes()

	priceEdit = self.activeOffersWindow.createOfferWindow.content_buy_offers.left_panel.quantity_panel.price_panel.price_input

	priceEdit:setText()

	local amountPanel = self.activeOffersWindow.createOfferWindow.content_buy_offers.left_panel.quantity_panel.amount_panel

	amountEdit = amountPanel.amount_edit

	amountEdit:setText("1")

	amountPanel.minimum = 1
	amountPanel.maximum = 1

	window.content_buy_offers.select_item_panel:show()
	window.content_buy_offers.left_panel:hide()
	window.content_buy_offers.right_panel:hide()
	window.place_offer_panel.place_offer_button:setEnabled(false)
end

function GameMarket:onCreateOfferButtonClick(panel)
	local window = self.activeOffersWindow.createOfferWindow

	if not window then
		return
	end

	panel = panel:gsub(" ", "_")

	local panelWidget = window["content_" .. panel]
	local itemPanel = panelWidget.left_panel.place_item_panel
	local item = itemPanel.item:getItem()

	if not item then
		return
	end

	local data = {}

	if panel == "buy_offers" then
		data = {
			clientId = item:getId(),
			action = "create_" .. panel,
			amount = tonumber(panelWidget.left_panel.quantity_panel.amount_panel.amount_edit:getText()),
			price = tonumber(panelWidget.left_panel.quantity_panel.price_panel.price_input:getText()),
			attributes = self.createOfferWindow.attributes,
			quality = item:getQuality()
		}
	else
		data = {
			itemUUID = item:getUUID(),
			amount = tonumber(panelWidget.left_panel.quantity_panel.amount_panel.amount_edit:getText()),
			price = tonumber(panelWidget.left_panel.price_panel.price_input:getText()),
			action = "create_" .. panel
		}
	end

	if data.attributes then
		local totalPrimaryAttributes = 0
		local totalSecondaryAttributes = 0
		local totalExtraSecondaryAttributes = 0
		local totalCraftingAttributes = 0
		local tier = cfg.MarketableItemsByTier[item:getId()]

		if tier then
			for name, filters in pairs(self.createOfferWindow.attributes) do
				if name == "primary attribute" then
					totalPrimaryAttributes = totalPrimaryAttributes + table.size(filters)
				elseif name == "secondary attribute" then
					totalSecondaryAttributes = totalSecondaryAttributes + table.size(filters)
				elseif name == cfg.filterExtraSecondaryName then
					totalExtraSecondaryAttributes = totalExtraSecondaryAttributes + table.size(filters)
				elseif name == "crafting attribute" then
					totalCraftingAttributes = totalCraftingAttributes + table.size(filters)
				end
			end

			if table.find(cfg.craftingAttributesCompatibleCategories, cfg.MarketableItemsByCategory[item:getId()]) then
				if totalCraftingAttributes ~= cfg.maximumCraftingAttributes[tier] then
					GameNotification:display(NOTIFICATION_ERROR, nil, string.format("You must select exactly %d crafting attributes for this item.", cfg.maximumCraftingAttributes[tier]))

					return
				end
			elseif table.find(cfg.attributesCompatibleCategories, cfg.MarketableItemsByCategory[item:getId()]) then
				if totalPrimaryAttributes ~= cfg.maximumPrimaryAttributes[tier] then
					GameNotification:display(NOTIFICATION_ERROR, nil, string.format("You must select exactly %d primary attributes for this item.", cfg.maximumPrimaryAttributes[tier]))

					return
				end

				if totalSecondaryAttributes ~= cfg.maximumSecondaryAttributes[tier] then
					GameNotification:display(NOTIFICATION_ERROR, nil, string.format("You must select exactly %d secondary attributes for this item.", cfg.maximumSecondaryAttributes[tier]))

					return
				end

				if totalExtraSecondaryAttributes ~= cfg.maximumExtraSecondaryAttributes[tier] then
					GameNotification:display(NOTIFICATION_ERROR, nil, string.format("You must select exactly %d extra secondary attributes for this item.", cfg.maximumExtraSecondaryAttributes[tier]))

					return
				end
			end
		end
	end

	if not data.price or data.price < cfg.minPricePerPiece then
		GameNotification:display(NOTIFICATION_ERROR, nil, "Price per piece must be at least " .. cfg.minPricePerPiece .. " silver.")

		return
	end

	if data.amount < 1 then
		GameNotification:display(NOTIFICATION_ERROR, nil, "Amount must be at least 1.")

		return
	end

	window:hide()
	self:clearCreateOfferItem()
	self:displayLock(true)
	self:sendOpcode(data)
	scheduleEvent(function()
		self:requestActiveOffers(true)
	end, 1000)
end

function GameMarket:displaySimilarSellOffers(offers, resultsAmount)
	self.window:blockInputPanel(true)

	offers = offers or {}

	local window = self.activeOffersWindow.createOfferWindow

	if not window then
		return
	end

	window:raise()

	local offerList = window.content_sell_offers.right_panel
	local numOffers = #offers
	local offersPerPage = cfg.offersPerPageSimilarOffers

	self.createOfferWindow.totalOffers = resultsAmount

	if self.createOfferWindow.page == 0 then
		self.createOfferWindow.page = 1
	end

	self:updateSimilarOffersListPagination()

	for i, offer in ipairs(offers) do
		local widget = offerList:getChildById(string.format("offer_%d", i))

		widget:setEnabled(true)
		widget:setOpacity(1)
		widget:show()

		local columns = widget:getChildren()
		local itemWidget = columns[1]
		local amountWidget = columns[2]
		local priceWidget = columns[3]

		itemWidget.item.UUID = offer.itemUUID

		amountWidget.text:setText(offer.amount)
		priceWidget.text:setText(offer.price)
		priceWidget.icon:update()

		local protocolItem = self.protocolItems[offer.itemUUID]

		if protocolItem then
			protocolItem:setCount(1)
			itemWidget.item:setItem(protocolItem)
		elseif offer.category == cfg.CATEGORY_RAVENCOIN then
			local item = Item.create(cfg.DUMMY_RAVENCOIN_ITEMID)

			item:setName("RavenCoin")
			item:setDescription("Can be used to purchase things in the RavenStore.")
			item:setQualityName("Premium Currency")
			itemWidget.item:setItem(item)

			offer.itemUUID = 1
			self.protocolItems[1] = item
		end
	end

	for i = numOffers + 1, offersPerPage do
		local offerWidget = offerList:getChildById(string.format("offer_%d", i))

		offerWidget:setEnabled(false)
		offerWidget:setOpacity(0)
	end

	if numOffers > 0 then
		offerList.no_offers_label:hide()

		for i = 1, offersPerPage do
			local offerWidget = offerList:getChildById(string.format("offer_%d", i))

			offerWidget:show()
		end
	else
		offerList.no_offers_label:show()

		for i = 1, offersPerPage do
			local offerWidget = offerList:getChildById(string.format("offer_%d", i))

			offerWidget:hide()
		end
	end
end

function GameMarket:requestSimilarOffers(panel, newCacheIdentifier)
	local window = self.activeOffersWindow.createOfferWindow

	if not window then
		return
	end

	panel = panel:gsub(" ", "_")

	local panelWidget = window["content_" .. panel]
	local itemPanel = panelWidget.left_panel.place_item_panel
	local item = itemPanel.item:getItem()

	if not item then
		return
	end

	if not self:canPerformAction() then
		print("GameMarket.requestSimilarOffers - unable to perform action")
	end

	self:displayLock(true)

	if newCacheIdentifier then
		self.createOfferWindow.cacheIdentifier = os.time()
	end

	local data = {
		clientId = item:getId(),
		action = "fetch_" .. panel,
		cacheIdentifier = newCacheIdentifier,
		page = math.max(1, self.createOfferWindow.page),
		order = {
			direction = self.createOfferWindow.orderDirection,
			type = self.createOfferWindow.orderType
		}
	}

	self:sendOpcode(data)
end

function GameMarket:setSimilarOffersSortOrder(orderDirection, orderType, force)
	local window = self.activeOffersWindow.createOfferWindow

	if not window then
		return
	end

	if not force and self.createOfferWindow.orderDirection == orderDirection and self.createOfferWindow.orderType == orderType then
		return
	end

	self.createOfferWindow.orderDirection = orderDirection
	self.createOfferWindow.orderType = cfg.similarOffersOrderType[orderType]

	if not self.createOfferWindow.orderType then
		return
	end

	self:changeSimilarOffersListPage(1, true)

	local headerPanel = window["content_" .. self.createOfferWindow.type].right_panel.list_header
	local columns = headerPanel:getChildren()
	local sortingHeaderWidgets = {
		columns[2],
		columns[3]
	}

	for _, widget in ipairs(sortingHeaderWidgets) do
		widget.sort_button.desc:setOn(false)
		widget.sort_button.asc:setOn(false)

		function widget.sort_button.desc.onClick(widget)
			local parent = widget:getParent():getParent()

			self:setSimilarOffersSortOrder("desc", parent:getParent():getChildIndex(parent))
		end

		function widget.sort_button.asc.onClick(widget)
			local parent = widget:getParent():getParent()

			self:setSimilarOffersSortOrder("asc", parent:getParent():getChildIndex(parent))
		end

		function widget.onClick(widget)
			self:setSimilarOffersSortOrder(widget.sort_button.asc:isOn() and "desc" or "asc", widget:getParent():getChildIndex(widget))
		end
	end

	local sortingWidget = columns[orderType]

	if orderDirection == "desc" then
		sortingWidget.sort_button.desc:setOn(true)
	else
		sortingWidget.sort_button.asc:setOn(true)
	end
end

function GameMarket:changeSimilarOffersListPage(direction, force)
	local max_pages = math.ceil(self.createOfferWindow.totalOffers / cfg.offersPerPageSimilarOffers)
	local oldPage = self.createOfferWindow.page
	local newPage = self.createOfferWindow.page

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

	self.createOfferWindow.page = newPage

	self:updateSimilarOffersListPagination()

	if not force and oldPage == newPage then
		return
	end

	self:requestSimilarOffers(self.createOfferWindow.type, false)
end

function GameMarket:updateSimilarOffersListPagination()
	local max_pages = math.ceil(self.createOfferWindow.totalOffers / cfg.offersPerPageSimilarOffers)

	self.createOfferWindow.page = math.min(self.createOfferWindow.page, max_pages)

	self.createOfferWindow.paginationPanel.page_edit:setText(self.createOfferWindow.page, true)
	self.createOfferWindow.paginationPanel.page_edit:setCursorPos(-1)
	self.createOfferWindow.paginationPanel.prev_button:setOn(self.createOfferWindow.page > 1)
	self.createOfferWindow.paginationPanel.next_button:setOn(max_pages > self.createOfferWindow.page)
	self.createOfferWindow.paginationPanel.prev_button:setEnabled(self.createOfferWindow.page > 1)
	self.createOfferWindow.paginationPanel.next_button:setEnabled(max_pages > self.createOfferWindow.page)
	self.createOfferWindow.paginationPanel.page_count:setText(tr(string.format("of |%i|", max_pages)), true)
end

function GameMarket:setupCreateOfferCategoriesPanel()
	local categories = cfg.categories
	local order = cfg.categoriesOrder

	local function callback(widget)
		self:selectCreateOfferSelectItemCategory(widget.categoryId)
	end

	for _, category in ipairs(order) do
		local categoryWidget = g_ui.createWidget("GameMarketCategoriesPanelCategory", self.createOfferWindow.categoriesPanel)

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
					self.createOfferWindow.categoryWidgets[subCategory.id] = subCategoryWidget
					subCategoryWidget.onClick = callback
				end
			end
		end
	end

	self:selectCreateOfferSelectItemCategory(1)
end

function GameMarket:selectCreateOfferSelectItemCategory(categoryId)
	local categoryWidget = self.createOfferWindow.categoryWidgets[categoryId]

	if not categoryWidget then
		return
	end

	if self.createOfferWindow.selectedCategory.id then
		if self.createOfferWindow.selectedCategory.id == categoryId then
			return
		end

		self.createOfferWindow.selectedCategory.widget:setOn(false)
	end

	self.createOfferWindow.selectedCategory.id = categoryId
	self.createOfferWindow.selectedCategory.widget = categoryWidget

	categoryWidget:setOn(true)

	local window = self.activeOffersWindow.createOfferWindow

	if not window then
		return
	end

	local panel = window.content_buy_offers.select_item_panel.list_panel

	panel:destroyChildren()
	g_ui.createWidget("GameMarketCreateOfferWindowListHeader", panel)

	local items = {}

	for name, id in pairs(cfg.MarketableItemsByName) do
		if cfg.MarketableItemsByCategory[id] == categoryId then
			table.insert(items, {
				name = name,
				id = id,
				tier = cfg.MarketableItemsByTier[id]
			})
		end
	end

	table.sort(items, function(a, b)
		if not a.tier or not b.tier then
			return a.name < b.name
		end

		if a.tier == b.tier then
			return a.name < b.name
		end

		return a.tier < b.tier
	end)

	for _, item in ipairs(items) do
		local widget = g_ui.createWidget("GameMarketCreateOfferWindowListItemPanel", panel)
		local columns = widget:getChildren()
		local itemWidget = columns[1]
		local tierWidget = columns[2]

		itemWidget.item:setPhantom(true)
		itemWidget.text:setText(item.name:titleCase())
		itemWidget.item:setItemId(item.id)
		tierWidget.text:setText(item.tier and string.format("T%d", item.tier) or "-")

		function widget.onClick(widget)
			self:selectCreateOfferSelectItem(item.id)
		end
	end
end

function GameMarket:selectCreateOfferSelectPremiumToken()
	local window = self.activeOffersWindow.createOfferWindow

	if not window then
		return
	end

	window.content_buy_offers.select_item_panel:hide()

	local leftPanel = window.content_buy_offers.left_panel
	local rightPanel = window.content_buy_offers.right_panel

	leftPanel:show()
	rightPanel:show()

	local itemPanel = leftPanel.place_item_panel

	itemPanel:setChecked(true)

	local itemWidget = itemPanel.item
	local dummyItem = Item.create(cfg.DUMMY_RAVENCOIN_ITEMID)

	dummyItem:setName("RavenCoin")
	dummyItem:setDescription("Can be used to purchase things in the RavenStore.")
	itemWidget:setItem(dummyItem)
	itemWidget:setPhantom(true)
	itemPanel.item_name:setText("RavenCoin")
	itemPanel.item_grade:setText("Premium Currency")
	itemPanel.item_type:setText()

	local rarityPanel = self.activeOffersWindow.createOfferWindow.content_buy_offers.left_panel.details_panel
	local attributesPanel = self.activeOffersWindow.createOfferWindow.content_buy_offers.left_panel.details_panel.attributes_panel

	rarityPanel.rarity_panel:setEnabled(false)
	attributesPanel:setEnabled(false)

	local amountPanel = leftPanel.quantity_panel.amount_panel

	amountPanel.minimum = 1
	amountPanel.maximum = 1000

	self:clearCreateOfferSearchInput()
	window.place_offer_panel.place_offer_button:setEnabled(true)
end

function GameMarket:selectCreateOfferSelectItem(itemId)
	local window = self.activeOffersWindow.createOfferWindow

	if not window then
		return
	end

	window.content_buy_offers.select_item_panel:hide()

	local leftPanel = window.content_buy_offers.left_panel
	local rightPanel = window.content_buy_offers.right_panel

	leftPanel:show()
	rightPanel:show()

	local itemPanel = leftPanel.place_item_panel

	itemPanel:setChecked(true)

	local itemWidget = itemPanel.item

	itemWidget:setItemId(itemId)
	itemWidget:setPhantom(true)
	itemPanel.item_name:setText(cfg.MarketableItemsById[itemId]:titleCase())
	itemPanel.item_grade:setText("Basic")

	local tier = cfg.MarketableItemsByTier[itemId]

	itemPanel.item_type:setText(string.format("%s", tier and string.format("Tier %d", tier) or ""))

	local itemMarketCategory = cfg.MarketableItemsByCategory[itemId]
	local rarityPanel = self.activeOffersWindow.createOfferWindow.content_buy_offers.left_panel.details_panel
	local excludeGrade = table.find(cfg.excludeGradeAndAttributesCategories, itemMarketCategory)

	rarityPanel.rarity_panel:setEnabled(not excludeGrade)

	if table.find(cfg.gradeCompatibleCategories, itemMarketCategory) then
		rarityPanel.rarity_label:setText("Grade")

		rarityPanel.rarity_label.rarity_option = "grade"

		rarityPanel.rarity_panel.text:setText("Select Grade")
	else
		rarityPanel.rarity_label:setText("Quality")

		rarityPanel.rarity_label.rarity_option = "quality"

		rarityPanel.rarity_panel.text:setText("Select Quality")
	end

	local isAttributeCompatible = table.find(cfg.attributesCompatibleCategories, itemMarketCategory)
	local attributesPanel = self.activeOffersWindow.createOfferWindow.content_buy_offers.left_panel.details_panel.attributes_panel

	attributesPanel:setEnabled(isAttributeCompatible)

	local amountPanel = leftPanel.quantity_panel.amount_panel

	amountPanel.minimum = 1

	local item = itemWidget:getItem()

	amountPanel.maximum = (item:isStackable() or item:getId() == cfg.DUMMY_RAVENCOIN_ITEMID) and 1000 or 1

	self:requestSimilarOffers("buy_offers", true)
	self:clearCreateOfferSearchInput()
	window.place_offer_panel.place_offer_button:setEnabled(true)
end

function GameMarket:displaySimilarBuyOffers(offers, resultsAmount)
	self.window:blockInputPanel(true)

	offers = offers or {}

	local window = self.activeOffersWindow.createOfferWindow

	if not window then
		return
	end

	window:raise()

	local offerList = window.content_buy_offers.right_panel
	local numOffers = #offers
	local offersPerPage = cfg.offersPerPageSimilarOffers

	self.createOfferWindow.totalOffers = resultsAmount

	if self.createOfferWindow.page == 0 then
		self.createOfferWindow.page = 1
	end

	self:updateSimilarOffersListPagination()

	for i, offer in ipairs(offers) do
		local widget = offerList:getChildById(string.format("offer_%d", i))

		widget:setEnabled(true)
		widget:setOpacity(1)
		widget:show()

		local columns = widget:getChildren()
		local itemWidget = columns[1]
		local amountWidget = columns[2]
		local priceWidget = columns[3]

		itemWidget.item.UUID = offer.itemUUID

		amountWidget.text:setText(offer.amount)
		priceWidget.text:setText(offer.price)
		priceWidget.icon:update()

		local protocolItem = self.protocolItems[offer.itemUUID]

		if protocolItem then
			protocolItem:setCount(1)
			itemWidget.item:setItem(protocolItem)
		else
			local item = Item.create(cfg.DUMMY_RAVENCOIN_ITEMID)

			item:setName("RavenCoin")
			item:setDescription("Can be used to purchase things in the RavenStore.")
			item:setQualityName("Premium Currency")
			itemWidget.item:setItem(item)

			offer.itemUUID = 1
			self.protocolItems[1] = item
		end
	end

	for i = numOffers + 1, offersPerPage do
		local offerWidget = offerList:getChildById(string.format("offer_%d", i))

		offerWidget:setEnabled(false)
		offerWidget:setOpacity(0)
	end

	if numOffers > 0 then
		offerList.no_offers_label:hide()

		for i = 1, offersPerPage do
			local offerWidget = offerList:getChildById(string.format("offer_%d", i))

			offerWidget:show()
		end
	else
		offerList.no_offers_label:show()

		for i = 1, offersPerPage do
			local offerWidget = offerList:getChildById(string.format("offer_%d", i))

			offerWidget:hide()
		end
	end
end

function GameMarket:onCreateOfferSearchInputTextChange(widget, text)
	if self.createOfferWindow.popupMenu then
		self.createOfferWindow.popupMenu:destroy()

		self.createOfferWindow.popupMenu = nil
	end

	if #text < 2 then
		return
	end

	local names = cfg.MarketableItemsByName
	local matches = {}

	for name in pairs(names) do
		if name:lower():find(text:lower()) and name ~= "ravencoin" then
			table.insert(matches, name)
		end
	end

	table.sort(matches, function(a, b)
		return a < b
	end)

	self.createOfferWindow.popupMenu = g_ui.createWidget("SearchPopupMenu")
	self.createOfferWindow.popupMenu.lastWidth = widget:getParent():getWidth()

	for index, match in ipairs(matches) do
		local item = self.createOfferWindow.popupMenu:addOption(match:titleCase(), function()
			widget:setText(match:titleCase(), true)
			widget:setCursorPos(#match)
			widget:setEnabled(false)
			self:selectCreateOfferSelectItem(cfg.MarketableItemsByName[match:lower()])
		end)

		if index > 20 then
			break
		end
	end

	local displayPos = widget:getParent():getPosition()

	displayPos.y = displayPos.y + widget:getHeight() + 15

	self.createOfferWindow.popupMenu:setFocusable(false)
	self.createOfferWindow.popupMenu:display(displayPos, nil, self.window)

	widget.searchPopupIndex = 0

	local disconnects = connect(widget, {
		onKeyPress = GameMarket.onCreateOfferSearchPopupMenuKeyPressed,
		onVisibilityChange = function(widget, visible)
			if not visible and self.createOfferWindow.popupMenu then
				self.createOfferWindow.popupMenu:destroy()

				self.createOfferWindow.popupMenu = nil
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

	connect(self.createOfferWindow.popupMenu, {
		onDestroy = function()
			for _, disconnect in ipairs(disconnects) do
				disconnect()
			end
		end
	})
end

function GameMarket.onCreateOfferSearchPopupMenuKeyPressed(widget, keyCode)
	local self = GameMarket

	if not self.createOfferWindow.popupMenu then
		return
	end

	if keyCode == KeyEnter then
		local index = widget.searchPopupIndex

		if not index then
			return
		end

		local child = self.createOfferWindow.popupMenu:getChildByIndex(index)

		if not child then
			return
		end

		widget:setText(child:getText(), true)
		widget:setCursorPos(#widget:getText())
		widget:setEnabled(false)
		self.createOfferWindow.popupMenu:destroy()

		self.createOfferWindow.popupMenu = nil

		self:selectCreateOfferSelectItem(cfg.MarketableItemsByName[widget:getText():lower()])

		return
	end

	if keyCode == KeyEscape then
		self.createOfferWindow.popupMenu:destroy()

		self.createOfferWindow.popupMenu = nil

		widget:setText("", true)

		return
	end

	if keyCode ~= KeyTab then
		return
	end

	local index = widget.searchPopupIndex

	index = index or 1

	local currentChild = self.createOfferWindow.popupMenu:getChildByIndex(index)

	if currentChild then
		currentChild:setOn(false)
	end

	if index + 1 > self.createOfferWindow.popupMenu:getChildCount() then
		index = 0
	end

	local nextChild = self.createOfferWindow.popupMenu:getChildByIndex(index + 1)

	if not nextChild then
		return
	end

	nextChild:setOn(true)

	widget.searchPopupIndex = index + 1
end

function GameMarket:clearCreateOfferSearchInput()
	local window = self.activeOffersWindow.createOfferWindow

	if not window then
		return
	end

	local inputPanel = window.content_buy_offers.select_item_panel.search.search_panel.search_input_panel.input

	inputPanel:setEnabled(true)
	inputPanel:setText("", true)
end

function GameMarket:onCreateBuyOfferRarityListBoxClick(widget)
	if self.createOfferWindow.popupMenu then
		self.createOfferWindow.popupMenu:destroy()

		self.createOfferWindow.popupMenu = nil
	end

	self.createOfferWindow.popupMenu = g_ui.createWidget("FilterPopupMenu")
	self.createOfferWindow.popupMenu.lastWidth = widget:getWidth()

	local disconnects = {}

	table.insert(disconnects, connect(g_ui.getRootWidget(), {
		onMousePress = function(widget, mousePos)
			if not self.createOfferWindow.popupMenu then
				return
			end

			if not self.createOfferWindow.popupMenu:containsPoint(mousePos) then
				if self.createOfferWindow.popupMenu.menu then
					if not self.createOfferWindow.popupMenu.popup:containsPoint(mousePos) then
						self.createOfferWindow.popupMenu.popup:destroy()

						self.createOfferWindow.popupMenu.popup = nil
					end

					return
				end

				self.createOfferWindow.popupMenu:destroy()

				self.createOfferWindow.popupMenu = nil
			end
		end
	}))
	connect(self.createOfferWindow.popupMenu, {
		onDestroy = function()
			widget:setOn(false)

			if self.createOfferWindow.popupMenu.popup then
				self.createOfferWindow.popupMenu.popup:destroy()

				self.createOfferWindow.popupMenu.popup = nil
			end

			for _, widgets in ipairs(disconnects) do
				for _, disconnect in ipairs(widgets) do
					disconnect()
				end
			end
		end
	})

	local rarityPanel = self.activeOffersWindow.createOfferWindow.content_buy_offers.left_panel.details_panel
	local itemPanel = self.activeOffersWindow.createOfferWindow.content_buy_offers.left_panel.place_item_panel
	local itemId = itemPanel.item:getItemId()
	local rarityOption = rarityPanel.rarity_label.rarity_option

	if rarityOption == "quality" then
		for i = ITEM_QUALITY_FIRST, ITEM_QUALITY_LAST do
			local quality = ItemQualityNames[i]
			local option = self.createOfferWindow.popupMenu:addOption(quality, function(option)
				if self.createOfferWindow.popupMenu.currentSelectedOption then
					self.createOfferWindow.popupMenu.currentSelectedOption:setOn(false)
				end

				option:setOn(true)

				self.createOfferWindow.popupMenu.currentSelectedOption = option

				rarityPanel.rarity_panel.text:setText(quality)
				rarityPanel.rarity_panel.text:setTextColor(ItemQualityColors[i])
				self:updateCreateBuyOfferItemRarity(i, "quality")
			end, nil, false, "GameMarketRarityPopupMenuButton")

			option:setChecked(true)
			option:setTextColor(ItemQualityColors[i])

			option.textColor = ItemQualityColors[i]
		end
	elseif rarityOption == "grade" then
		for i = ITEM_GRADE_FIRST, ITEM_GRADE_LAST do
			local grade = ItemGradeNames[i]
			local option = self.createOfferWindow.popupMenu:addOption(grade, function(option)
				if self.createOfferWindow.popupMenu.currentSelectedOption then
					self.createOfferWindow.popupMenu.currentSelectedOption:setOn(false)
				end

				option:setOn(true)

				self.createOfferWindow.popupMenu.currentSelectedOption = option

				rarityPanel.rarity_panel.text:setText(grade)
				rarityPanel.rarity_panel.text:setTextColor(ItemQualityColors[i])
				self:updateCreateBuyOfferItemRarity(i, "grade")
			end, nil, false, "GameMarketRarityPopupMenuButton")

			option:setChecked(true)
			option:setTextColor(ItemQualityColors[i])

			option.textColor = ItemQualityColors[i]
		end
	end

	local displayPos = widget:getPosition()

	displayPos.y = displayPos.y + widget:getHeight() + 4

	self.createOfferWindow.popupMenu:setFocusable(false)
	self.createOfferWindow.popupMenu:display(displayPos, true, self.window)
end

function GameMarket:updateCreateBuyOfferItemRarity(value, type)
	local window = self.activeOffersWindow.createOfferWindow

	if not window then
		return
	end

	local itemPanel = window.content_buy_offers.left_panel.place_item_panel
	local item = itemPanel.item:getItem()

	if not item then
		return
	end

	item:setQuality(value)
	item:setQualityName(type == "quality" and ItemQualityNames[value] or ItemGradeNames[value])
	itemPanel.item:onItemChange()
	itemPanel.item_name:setTextColor(ItemQualityColors[math.max(item:getGrade(), item:getQuality())])
	itemPanel.item_grade:setText(item:getQualityName())
	itemPanel.item_grade:setTextColor(ItemQualityColors[math.max(item:getGrade(), item:getQuality())])
end

function GameMarket:onCreateBuyOfferAttributesListBoxClick(widget)
	if self.createOfferWindow.popupMenu then
		self.createOfferWindow.popupMenu:destroy()

		self.createOfferWindow.popupMenu = nil
	end

	self.createOfferWindow.popupMenu = g_ui.createWidget("FilterPopupMenu")
	self.createOfferWindow.popupMenu.lastWidth = widget:getWidth()

	local disconnects = {}

	table.insert(disconnects, connect(g_ui.getRootWidget(), {
		onMousePress = function(widget, mousePos)
			if not self.createOfferWindow.popupMenu then
				return
			end

			if not self.createOfferWindow.popupMenu:containsPoint(mousePos) then
				if self.createOfferWindow.popupMenu.menu then
					if not self.createOfferWindow.popupMenu.popup:containsPoint(mousePos) then
						self.createOfferWindow.popupMenu.popup:destroy()

						self.createOfferWindow.popupMenu.popup = nil
					end

					return
				end

				self.createOfferWindow.popupMenu:destroy()

				self.createOfferWindow.popupMenu = nil
			end
		end
	}))
	connect(self.createOfferWindow.popupMenu, {
		onDestroy = function()
			widget:setOn(false)

			if self.createOfferWindow.popupMenu.popup then
				self.createOfferWindow.popupMenu.popup:destroy()

				self.createOfferWindow.popupMenu.popup = nil
			end

			for _, widgets in ipairs(disconnects) do
				for _, disconnect in ipairs(widgets) do
					disconnect()
				end
			end
		end
	})

	local item = self.activeOffersWindow.createOfferWindow.content_buy_offers.left_panel.place_item_panel.item:getItem()
	local tier = cfg.MarketableItemsByTier[item:getId()] or -1
	local isCraftingAttributeCompatible = table.find(cfg.craftingAttributesCompatibleCategories, cfg.MarketableItemsByCategory[item:getId()])
	local order

	if isCraftingAttributeCompatible then
		order = {
			"crafting attribute"
		}
	else
		order = table.copy(cfg.createOfferFiltersOrder)

		if table.find(cfg.extraSecondaryAttributesCompatibleTiers, tier) then
			table.insert(order, cfg.filterExtraSecondaryName)
		end
	end

	for _, filter in ipairs(order) do
		local widgetOption = self.createOfferWindow.popupMenu:addOption(filter:titleCase(), function(option)
			if self.createOfferWindow.popupMenu.currentSelectedOption then
				self.createOfferWindow.popupMenu.currentSelectedOption:setOn(false)
			end

			option:setOn(true)

			self.createOfferWindow.popupMenu.currentSelectedOption = option

			GameMarket:createBuyOfferExpandedFilterPopup(self.createOfferWindow.popupMenu, option, filter)
		end, nil, true)

		widgetOption.filterName = filter

		self.createOfferWindow.popupMenu:addSeparator()

		if filter == cfg.filterExtraSecondaryName then
			widgetOption:setEnabled(self.createOfferWindow.attributes["secondary attribute"] and not table.empty(self.createOfferWindow.attributes["secondary attribute"]))
		end
	end

	g_ui.createWidget("FilterPopupMenuClearAll", self.createOfferWindow.popupMenu)

	local displayPos = widget:getPosition()

	displayPos.y = displayPos.y + widget:getHeight() + 4

	self.createOfferWindow.popupMenu:setFocusable(false)
	self.createOfferWindow.popupMenu:display(displayPos, true, self.window)
	self.createOfferWindow.popupMenu.clear_button:setEnabled(not table.empty(self.createOfferWindow.attributes))

	function self.createOfferWindow.popupMenu.clear_button.onClick()
		self:clearBuyOfferAttributes()
	end

	for _, filter in ipairs(order) do
		local filters = self.createOfferWindow.attributes[filter:lower()]

		if filters then
			local option = self.createOfferWindow.popupMenu:getChildById(filter:lower())

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

function GameMarket:createBuyOfferExpandedFilterPopup(menu, parentOption, filterName)
	filterName = filterName:lower()

	local options = cfg.filters[filterName]

	if not options then
		return
	end

	if filterName == cfg.filterExtraSecondaryName then
		options = {}

		local possibleOptions = self.createOfferWindow.attributes["secondary attribute"]

		if possibleOptions then
			for optionName in pairs(possibleOptions) do
				table.insert(options, optionName)
			end
		end
	end

	menu.popup = g_ui.createWidget("FilterPopupMenu")

	for _, optionName in ipairs(options) do
		local option = menu.popup:addOption(optionName:titleCase(), function()
			return
		end, nil, true, "GameMarketAttributesPopupMenuButtonExpanded")

		option.filterName = optionName

		self:loadBuyOfferFilterStates(filterName, option)
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

function GameMarket:loadBuyOfferFilterStates(parentCategory, optionWidget)
	local filters = self.createOfferWindow.attributes[parentCategory]

	if not filters then
		return
	end

	local filterName = optionWidget.filterName

	if filterName and filters[filterName] then
		optionWidget.checkbox:setChecked(true, true)
	end
end

function GameMarket:onAttributesListCheckboxChange(widget, state)
	local categoryFilter = self.createOfferWindow.popupMenu

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

	local changedCategory = selectedCategory.filterName

	if not changedCategory then
		return
	end

	local totalPrimaryAttributes = changedCategory == "primary attribute" and (state and 1 or -1) or 0
	local totalSecondaryAttributes = changedCategory == "secondary attribute" and (state and 1 or -1) or 0
	local totalExtraSecondaryAttributes = changedCategory == cfg.filterExtraSecondaryName and (state and 1 or -1) or 0
	local totalCraftingAttributes = changedCategory == "crafting attribute" and (state and 1 or -1) or 0

	for name, filters in pairs(self.createOfferWindow.attributes) do
		if name == "primary attribute" then
			totalPrimaryAttributes = totalPrimaryAttributes + table.size(filters)
		elseif name == "secondary attribute" then
			totalSecondaryAttributes = totalSecondaryAttributes + table.size(filters)
		elseif name == cfg.filterExtraSecondaryName then
			totalExtraSecondaryAttributes = totalExtraSecondaryAttributes + table.size(filters)
		elseif name == "crafting attribute" then
			totalCraftingAttributes = totalCraftingAttributes + table.size(filters)
		end
	end

	local item = self.activeOffersWindow.createOfferWindow.content_buy_offers.left_panel.place_item_panel.item:getItem()

	if not item then
		return
	end

	local tier = cfg.MarketableItemsByTier[item:getId()]

	if not tier then
		return
	end

	if totalPrimaryAttributes > cfg.maximumPrimaryAttributes[tier] then
		widget:setChecked(false, true)
		GameNotification:display(NOTIFICATION_ERROR, nil, string.format("This item can't have more than %d primary attributes.", cfg.maximumPrimaryAttributes[tier]))

		return
	end

	if totalSecondaryAttributes > cfg.maximumSecondaryAttributes[tier] then
		widget:setChecked(false, true)
		GameNotification:display(NOTIFICATION_ERROR, nil, string.format("This item can't have more than %s secondary attributes.", cfg.maximumSecondaryAttributes[tier]))

		return
	end

	if totalExtraSecondaryAttributes > cfg.maximumExtraSecondaryAttributes[tier] then
		widget:setChecked(false, true)
		GameNotification:display(NOTIFICATION_ERROR, nil, string.format("This item can't have more than %s extra secondary attributes.", cfg.maximumExtraSecondaryAttributes[tier]))

		return
	end

	if cfg.maximumCraftingAttributes[tier] and totalCraftingAttributes > cfg.maximumCraftingAttributes[tier] then
		widget:setChecked(false, true)
		GameNotification:display(NOTIFICATION_ERROR, nil, string.format("This item can't have more than %s crafting attributes.", cfg.maximumCraftingAttributes[tier]))

		return
	end

	local changedFilter = widget:getParent().filterName

	if not changedFilter then
		return
	end

	self.createOfferWindow.attributes[changedCategory] = self.createOfferWindow.attributes[changedCategory] or {}
	self.createOfferWindow.attributes[changedCategory][changedFilter] = state or nil

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

	if changedCategory == "secondary attribute" then
		local extraSecondaryCategory = self.createOfferWindow.popupMenu:getChildById(cfg.filterExtraSecondaryName)

		if extraSecondaryCategory then
			extraSecondaryCategory:setEnabled(not table.empty(self.createOfferWindow.attributes["secondary attribute"]))

			if not state then
				local extraSecondaryFilters = self.createOfferWindow.attributes[cfg.filterExtraSecondaryName]

				if extraSecondaryFilters and extraSecondaryFilters[changedFilter] then
					extraSecondaryFilters[changedFilter] = nil

					local label = extraSecondaryCategory.content:getChildById(changedFilter)

					if label then
						label:destroy()

						extraSecondaryCategory.content.filters[changedFilter] = nil
					end
				end

				local height = 30

				for _, child in ipairs(extraSecondaryCategory.content:getChildren()) do
					height = height + child:getHeight()
				end

				extraSecondaryCategory:setHeight(height)

				if table.empty(self.createOfferWindow.attributes[cfg.filterExtraSecondaryName]) then
					self.createOfferWindow.attributes[cfg.filterExtraSecondaryName] = nil
				end
			end
		end
	end

	local height = 30

	for _, child in ipairs(selectedCategory.content:getChildren()) do
		height = height + child:getHeight()
	end

	selectedCategory:setHeight(height)

	if table.empty(self.createOfferWindow.attributes[changedCategory]) then
		self.createOfferWindow.attributes[changedCategory] = nil
	end

	categoryFilter.clear_button:setEnabled(not table.empty(self.createOfferWindow.attributes))

	function categoryFilter.clear_button.onClick()
		self:clearBuyOfferAttributes()
	end
end

function GameMarket:clearBuyOfferAttributes()
	self.createOfferWindow.attributes = {}

	if not self.createOfferWindow.popupMenu then
		return
	end

	if self.createOfferWindow.popupMenu.clear_button then
		self.createOfferWindow.popupMenu.clear_button:setEnabled(false)
	end

	for _, child in ipairs(self.createOfferWindow.popupMenu:getChildren()) do
		if child.content then
			child.content.filters = nil

			child.content:destroyChildren()
			child:setHeight(30)
		end
	end
end
