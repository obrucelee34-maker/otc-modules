-- chunkname: @/modules/game_npcs/harvest_shop.lua

HarvestShop = {}

function HarvestShop.onGameEnd()
	return
end

function HarvestShop:isVisible()
	return self.window and self.window:isVisible()
end

function HarvestShop:init()
	connect(g_game, {
		onGameEnd = self.onGameEnd,
		onProtocolItem = self.onProtocolItem
	})
	connect(Container, {
		onOpen = self.refreshItemList,
		onRemoveItem = self.refreshItemList,
		onUpdateItem = self.refreshItemList,
		onAddItem = self.refreshItemList
	})

	self.window = GameNpc.panels[windowTypes.harvest_shop]

	self.window:setVisible(false)
end

function HarvestShop:terminate()
	self.window:destroy()
	disconnect(g_game, {
		onGameStart = self.onGameStart,
		onProtocolItem = self.onProtocolItem
	})
	disconnect(Container, {
		onRemoveItem = self.refreshItemList
	})

	HarvestShop = nil
end

function HarvestShop:onTradeItem(widget)
	local bottomPanel = self.window:recursiveGetChildById("bottomPanel")

	if not bottomPanel or not bottomPanel:isOn() then
		return
	end

	local info = self.data and self.data[widget.item:getItem():getId()]

	if not info then
		return
	end

	local item = bottomPanel:getChildById("shopItemInfo")
	local value = self.window:recursiveGetChildById("cost")
	local count = self.window:recursiveGetChildById("count")
	local minus = self.window:recursiveGetChildById("minus")
	local plus = self.window:recursiveGetChildById("plus")
	local buy_button = bottomPanel:getChildById("buyButton")
	local sell_button = bottomPanel:getChildById("sellButton")

	buy_button:show()
	sell_button:hide()
	item.item:setItem(widget.item:getItem())
	item.name:setText(widget.name:getText())
	item.currency_price:setText(widget.currency_price:getText())

	if widget.type == "decoration" then
		widget.realCount = 1

		count:hide()
		minus:hide()
		plus:hide()
	else
		count:show()
		minus:show()
		plus:show()
	end

	item.realCount = widget.realCount
	item.realValue = tonumber(widget.currency_price:getText())

	count:setText(widget.realCount or 1)
	self.onItemCountChange(item, count:getText())

	function buy_button.onClick()
		GameNpc:sendOpcode({
			option = "npc_event_shop_buy",
			action = "dialogue",
			dialogueId = GameNpc.dialogueId,
			npcName = GameNpc.npcName,
			name = item.name:getText(),
			amount = tonumber(item.count:getText())
		})
	end
end

function HarvestShop:setSelectedTab(type)
	local selectionPanel = self.window:recursiveGetChildById("harvest_shop_selection_panel")

	if not selectionPanel then
		return
	end

	selectionPanel.left_option:setOn(true)
	selectionPanel.right_option:setOn(false)
	selectionPanel.right_option:setEnabled(false)

	self.type = type
end

function HarvestShop:onOpenNpcTrade(data)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	self.data = {}

	self.window:recursiveGetChildById("silver").currency_price:setText(data.coins)
	self.window:recursiveGetChildById("silver").currency_icon:setItemId(data.clientId)

	local itemsPanel = HarvestShop.window:recursiveGetChildById("itemsPanel")
	local bottomPanel = self.window:recursiveGetChildById("bottomPanel")

	bottomPanel:setOn(false)
	GameNpc:setTopPanelOn(true)
	itemsPanel:destroyChildren()

	for index, info in ipairs(data.items) do
		if info.clientId then
			self.data[info.clientId] = info

			local itemWidget = g_ui.createWidget("HarvestShopItem", itemsPanel)

			itemWidget.item:setItemId(info.clientId)
			itemWidget.name:setText(info.name)
			itemWidget.currency_price:setText(info.price)
			itemWidget.currency_icon:setItemId(data.clientId)

			itemWidget.type = info.type

			itemWidget:setVisible(false)

			function itemWidget.onClick(widget)
				if self.lastItem then
					self.lastItem:setOn(false)
				end

				bottomPanel:setOn(true)
				widget:setOn(true)

				self.lastItem = widget

				self:onTradeItem(widget)
			end
		end
	end

	self.type = nil

	self:setSelectedTab(data.shopType or "buy")
	GameNpc:setPanel("harvest_shop")
	self.window:show()
	self.window:raise()
	self.window:focus()
	self:refreshItemList()
end

function HarvestShop.onClose()
	if HarvestShop.lastItem then
		HarvestShop.lastItem:setOn(false)

		HarvestShop.lastItem = nil
	end

	local bottomPanel = HarvestShop.window:recursiveGetChildById("bottomPanel")

	if bottomPanel:isOn() then
		bottomPanel:setOn(false)
	end

	local search = HarvestShop.window:recursiveGetChildById("textEdit")

	search:setText("")
end

function HarvestShop:onSearchFilter(widget)
	local text = widget:getText()

	widget.placeholder:setVisible(text:len() == 0)
	HarvestShop.refreshItemList()
end

function HarvestShop.onItemCountChange(widget, text)
	local count = math.clamp(tonumber(text) or 0, 0, 1000)
	local currency_price = widget.realValue or 0
	local countLabel = HarvestShop.window:recursiveGetChildById("count")

	HarvestShop.window:recursiveGetChildById("shopItemInfo").currency_price:setText(currency_price * count)
	countLabel:setText(count, true)
end

function HarvestShop:itemCheck(widget, searchText)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	if self.type and self.type == "sell" and player:getItemsCount(widget.item:getItem():getId(), nil, nil, true) == 0 then
		widget:setEnabled(false)
		widget:setVisible(false)
	else
		widget:setEnabled(true)

		if not searchText or searchText == "" then
			widget:setVisible(true)
		else
			local name = widget.name:getText():lower()
			local found = name:find(searchText:lower(), 1, true) ~= nil

			widget:setVisible(found)
		end
	end
end

function HarvestShop.refreshItemList()
	local self = HarvestShop

	if not self.window:isVisible() then
		return
	end

	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local searchText = self.window:recursiveGetChildById("textEdit"):getText()
	local itemsPanel = self.window:recursiveGetChildById("itemsPanel")

	for index, child in pairs(itemsPanel:getChildren()) do
		self:itemCheck(child, searchText)

		if self.lastItem and self.lastItem == child and not child:isEnabled() then
			self.lastItem:setOn(false)

			self.lastItem = nil

			local bottomPanel = self.window:recursiveGetChildById("bottomPanel")

			bottomPanel:setChecked(false)
			bottomPanel:setOn(false)
		end
	end
end

function HarvestShop.onProtocolItem(item)
	local self = HarvestShop
	local panel = self.window and self.window:recursiveGetChildById("itemsPanel")

	if not panel then
		return
	end

	for _, itemWidget in ipairs(panel:getChildren()) do
		if itemWidget.item:getItem():getId() == item:getId() then
			itemWidget.item:setItem(item)

			break
		end
	end
end

function HarvestShop:onUpdateHarvestCoins(value)
	HarvestShop.window:recursiveGetChildById("silver").currency_price:setText(value)
end
