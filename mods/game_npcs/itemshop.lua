-- chunkname: @/modules/game_npcs/itemshop.lua

ItemShop = {
	widgets = {}
}

local function getCount(widget, quality)
	local player = g_game.getLocalPlayer()

	if not player or not widget then
		return 0
	end

	local itemId = tonumber(widget) and widget or widget.getItemId and widget:getItemId() or 0

	return player:getItemsCount(itemId, quality)
end

function ItemShop.onGameEnd()
	ItemShop.cosmetic = nil
end

function ItemShop:isVisible()
	return self.window and self.window:isVisible()
end

function ItemShop:init()
	connect(g_game, {
		onGameEnd = self.onGameEnd,
		onOpenNpcTrade = self.onOpenNpcTrade,
		onCoinBalance = self.onBalanceChange
	})
	connect(Container, {
		onOpen = self.refreshItemList,
		onRemoveItem = self.refreshItemList,
		onUpdateItem = self.refreshItemList,
		onAddItem = self.refreshItemList
	})

	self.window = GameNpc.panels[windowTypes.itemshop]

	self.window:setVisible(false)
	ItemShop.populateItemsRarity(self, ItemsShopQuality)
end

function ItemShop:terminate()
	self.window:destroy()
	disconnect(g_game, {
		onGameStart = self.onGameStart,
		onOpenNpcTrade = self.onOpenNpcTrade,
		onCoinBalance = self.onBalanceChange
	})
	disconnect(Container, {
		onOpen = self.refreshItemList,
		onRemoveItem = self.refreshItemList,
		onUpdateItem = self.refreshItemList,
		onAddItem = self.refreshItemList
	})

	ItemShop = nil
end

function ItemShop:onTradeItem(widget, buying)
	local bottomPanel = self.window:recursiveGetChildById("bottomPanel")

	if bottomPanel and bottomPanel:isOn() then
		bottomPanel:getChildById("buyButton"):setVisible(buying)
		bottomPanel:getChildById("sellButton"):setVisible(not buying)

		local item = bottomPanel:getChildById("shopItemInfo")
		local value = ItemShop.window:recursiveGetChildById("cost").value
		local count = ItemShop.window:recursiveGetChildById("count")

		item:getChildById("item"):show()
		item:getChildById("item"):setItem(widget.item)
		item:getChildById("name"):setText(widget.name)
		item:getChildById("price"):setText(widget.price)

		item.priceValue = widget.price
		item.realCount = widget.realCount

		value:setText(widget.price)
		count:setText(widget.realCount or 1)
	end
end

function ItemShop:onResize()
	if not self.window then
		return
	end

	local itemsPanel = self.window:recursiveGetChildById("itemsPanel")
	local maxWidth = itemsPanel:getWidth() - itemsPanel:getPaddingLeft() - itemsPanel:getPaddingRight() - itemsPanel:getLayout():getCellSpacing().width

	itemsPanel:getLayout():setCellWidth(math.floor(maxWidth / 2))
end

function ItemShop:createShopItem(buying, item, index, itemsPanel, quality)
	local shopQuality = quality or ItemsShopQuality[1]
	local qualityPrice = shopQuality.price
	local widget = itemsPanel:getChildById("ItemShop" .. item[2]) or g_ui.createWidget("ShopItem", itemsPanel)

	widget.item = item[1]
	widget.name = item[2]
	widget.weight = item[3] / 100
	widget.realPrice = buying and item[4] or item[5]
	widget.price = buying and widget.realPrice or math.round(widget.realPrice * qualityPrice)

	widget:setId("ItemShop" .. widget.name)
	widget:getChildById("item"):show()
	widget:getChildById("item"):setItem(widget.item)
	widget:getChildById("name"):setText(widget.name)
	widget:getChildById("price"):setText(widget.price)
	widget:getChildById("item"):getItem():setQuality(shopQuality.quality)
	widget:getChildById("item"):getItem():setQualityName(shopQuality.name)

	function widget:enableCheck()
		if ItemShop.type ~= "sell" then
			self:setEnabled(true)
			self:setVisible(true)

			return
		end

		local comboBox = ItemShop.window:recursiveGetChildById("comboBox")
		local selectedQuality = table.findbyfield(ItemsShopQuality, "name", comboBox:getCurrentOption().data.quality)
		local playerCount = getCount(self:getChildById("item"), selectedQuality.quality)

		self.realCount = playerCount

		self:setEnabled(playerCount > 0)
		self:setVisible(playerCount > 0)
	end

	widget:enableCheck()

	local function showShopPopup()
		local bottomPanel = ItemShop.window:recursiveGetChildById("bottomPanel")
		local lastItem = ItemShop.lastItem

		if widget ~= lastItem then
			if lastItem then
				lastItem:setOn(false)
			end

			widget:setOn(true)
		else
			return
		end

		widget:enableCheck()

		if not bottomPanel:isOn() then
			bottomPanel:setOn(true)
		end

		ItemShop.lastItem = widget

		ItemShop:onTradeItem(widget, buying)
	end

	widget.onClick = showShopPopup
	widget:getChildById("item").onClick = showShopPopup
	widget.clickSound = true

	table.insert(ItemShop.widgets, widget)
end

function ItemShop.onOpenNpcTrade(buyCurrency, sellCurrency, items, isCosmetic)
	ItemShop.refreshItemList()

	local comboBox = ItemShop.window:recursiveGetChildById("comboBox")
	local itemsPanel = ItemShop.window:recursiveGetChildById("itemsPanel")
	local maxWidth = itemsPanel:getWidth() - itemsPanel:getPaddingLeft() - itemsPanel:getPaddingRight() - itemsPanel:getLayout():getCellSpacing().width

	itemsPanel:getLayout():setCellWidth(math.floor(maxWidth / 2))

	ItemShop.cosmetic = isCosmetic

	GameNpc:setTopPanelOn(true)
	GameNpc:setPanel("itemshop")

	local buyItems = {}
	local unactiveSellItems = {}
	local activeSellItems = {
		[ItemQualityNormal] = {},
		[ItemQualityHigh] = {},
		[ItemQualitySuperior] = {},
		[ItemQualityArtisan] = {}
	}
	local hasItemToSell = false

	for _, item in ipairs(items) do
		if item[5] > 0 then
			local itemId = item[1] and item[1]:getId()

			for quality = ItemQualityFirst, ItemQualityLast do
				local playerCount = getCount(itemId, quality)

				hasItemToSell = hasItemToSell or playerCount > 0

				table.insert(playerCount > 0 and activeSellItems[quality] or unactiveSellItems, item)
			end
		else
			table.insert(buyItems, item)
		end
	end

	if hasItemToSell then
		ItemShop.type = "sell"

		local selectedQuality = ItemsShopQuality[1]

		for quality = ItemQualityFirst, ItemQualityLast do
			if not table.empty(activeSellItems[quality]) then
				selectedQuality = ItemsShopQuality[quality + 1]

				comboBox:setCurrentOption(selectedQuality.name)

				break
			end
		end

		for quality = ItemQualityFirst, ItemQualityLast do
			for _, item in ipairs(activeSellItems[quality]) do
				ItemShop:createShopItem(false, item, nil, itemsPanel, selectedQuality)
			end
		end

		for index, item in ipairs(unactiveSellItems) do
			local n = math.ceil(index / 10)

			scheduleEvent(function()
				if ItemShop.type and ItemShop.type == "sell" then
					ItemShop:createShopItem(false, item, nil, itemsPanel, selectedQuality)
				end
			end, n * 100)
		end
	else
		ItemShop.type = "buy"

		for _, item in ipairs(buyItems) do
			ItemShop:createShopItem(true, item, index, itemsPanel)
		end
	end

	if not hasItemToSell and table.size(buyItems) == 0 then
		local player, creature = g_game.getLocalPlayer(), g_map.getCreatureById(GameNpc.npcId)

		if creature and creature:isNpc() then
			local message = string.format("Hey %s, you don't have any Creature Products with you! Come back if you have any products you wish to sell.", player:getName())

			GameChat.onTalk(creature:getName(), nil, TalkTypes.TalkTypeSay, message, nil, creature:getPosition(), creature:getId(), nil, nil, nil, nil)
		end

		GameNpc:onClose(nil, nil, true)

		return
	end

	ItemShop.reorder()

	local bottomPanel = ItemShop.window:recursiveGetChildById("bottomPanel")

	bottomPanel:setChecked(ItemShop.type == "sell")

	local itemQuality = ItemShop.window:recursiveGetChildById("itemQuality")

	itemQuality:setOn(ItemShop.type == "sell")

	local count = ItemShop.window:recursiveGetChildById("count")

	ItemShop.onItemCountChange(count, count:getText())
end

function ItemShop:buyItem()
	local bottomPanel = ItemShop.window:recursiveGetChildById("bottomPanel")

	if bottomPanel and bottomPanel:isOn() then
		g_game.buyItem(bottomPanel:recursiveGetChildById("item"):getItem(), bottomPanel:recursiveGetChildById("count"):getText(), true, false)
	end
end

function ItemShop:sellItem()
	local bottomPanel = ItemShop.window:recursiveGetChildById("bottomPanel")
	local comboBox = self.window:recursiveGetChildById("comboBox")

	if bottomPanel and bottomPanel:isOn() and comboBox then
		local selectedQuality = table.findbyfield(ItemsShopQuality, "name", comboBox:getCurrentOption().data.quality)

		if not selectedQuality then
			return
		end

		g_game.sellItem(bottomPanel:recursiveGetChildById("item"):getItem(), bottomPanel:recursiveGetChildById("count"):getText(), true, selectedQuality.quality)
	end
end

function ItemShop:onSearchFilter(widget)
	local text = widget:getText()

	widget.placeholder:setVisible(text:len() == 0)

	for _, widget in ipairs(ItemShop.widgets) do
		local name = widget.name:lower()
		local found = name:find(text:lower(), 1, true)

		widget:setVisible(found ~= nil)
	end
end

function ItemShop.onBalanceChange(premium, balance)
	local silver = ItemShop.window:recursiveGetChildById("silver")

	silver.value:setText(formatNumber(balance))
	silver:align()
end

function ItemShop.onQualityChange(widget)
	local selectedQuality = table.findbyfield(ItemsShopQuality, "name", widget:getCurrentOption().data.quality)

	if not selectedQuality then
		return
	end

	local quality = selectedQuality.quality
	local qualityName = selectedQuality.name
	local bottomPanel = ItemShop.window:recursiveGetChildById("bottomPanel")
	local itemsPanel = ItemShop.window:recursiveGetChildById("itemsPanel")

	for _, child in ipairs(itemsPanel:getChildren()) do
		child.price = math.round(child.realPrice * selectedQuality.price)

		child:getChildById("price"):setText(child.price)

		local info = bottomPanel:getChildById("shopItemInfo")
		local childItem = child:getChildById("item")

		if info and info:getChildById("item"):getItemId() == childItem:getItemId() then
			info.price:setText(child.price)
		end

		childItem:getItem():setQuality(quality)
		childItem:getItem():setQualityName(qualityName)
	end

	ItemShop.refreshItemList()
end

function ItemShop:populateItemsRarity(values)
	local comboBox = self.window:recursiveGetChildById("comboBox")

	for _, option in ipairs(values) do
		comboBox:addOption(tr(option.name), {
			quality = option.name
		}, true)
	end

	comboBox.onOptionChange = ItemShop.onQualityChange
end

function ItemShop.onItemCountChange(widget, text)
	local count = math.clamp(tonumber(text) or 0, 0, 1000)
	local price = tonumber(widget:getParent().price._internal_value)

	ItemShop.window:recursiveGetChildById("cost").value:setText(math.floor(price * count))
	widget:setText(count, true)
end

function ItemShop.refreshItemList()
	if not ItemShop.window:isVisible() then
		return
	end

	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local itemsPanel = ItemShop.window:recursiveGetChildById("itemsPanel")

	if not ItemShop.type == "sell" or not itemsPanel:isVisible() then
		return
	end

	for index, child in pairs(itemsPanel:getChildren()) do
		child:enableCheck()

		if child:isEnabled() and child == ItemShop.lastItem then
			ItemShop:onTradeItem(child, ItemShop.type == "buy")
		end
	end

	addEvent(ItemShop.reorder)

	local count = ItemShop.window:recursiveGetChildById("count")

	ItemShop.onItemCountChange(count, count:getText())
end

function ItemShop.reorder()
	local itemsPanel = ItemShop.window:recursiveGetChildById("itemsPanel")
	local widgets = itemsPanel:getChildren()

	table.sort(widgets, function(a, b)
		if a:isEnabled() and not b:isEnabled() then
			return true
		elseif not a:isEnabled() and b:isEnabled() then
			return false
		end

		if a.price == b.price then
			return a.name < b.name
		end

		return a.price < b.price
	end)
	itemsPanel:reorderChildren(widgets)

	if not ItemShop.lastItem or not ItemShop.lastItem:isEnabled() then
		local child = itemsPanel:getFirstChild()

		if child then
			child:onClick()
		end
	end
end

function ItemShop.onClose()
	ItemShop.lastItem = nil
	ItemShop.type = nil
	ItemShop.cosmetic = nil

	local bottomPanel = ItemShop.window:recursiveGetChildById("bottomPanel")

	if bottomPanel:isOn() then
		bottomPanel:setOn(false)
	end

	local itemsPanel = ItemShop.window:recursiveGetChildById("itemsPanel")

	itemsPanel:destroyChildren()

	ItemShop.widgets = {}

	local comboBox = ItemShop.window:recursiveGetChildById("comboBox")

	comboBox:setCurrentOption(1)
	ItemShop.window:recursiveGetChildById("cost").value:setText(0)

	local search = ItemShop.window:recursiveGetChildById("textEdit")

	search:setText("")
end
