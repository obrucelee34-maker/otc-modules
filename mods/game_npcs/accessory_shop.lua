-- chunkname: @/modules/game_npcs/accessory_shop.lua

AccessoryShop = {
	shopsNames = {
		"ACCESSORY"
	},
	shopsWidgets = {}
}

function AccessoryShop.onGameEnd()
	return
end

function AccessoryShop:isVisible()
	return self.window and self.window:isVisible()
end

function AccessoryShop:init()
	connect(g_game, {
		onGameEnd = self.onGameEnd,
		onCoinBalance = self.onBalanceChange
	})
	connect(LocalPlayer, {
		onBountyMarksChange = self.onBountyMarksChange
	})
	connect(Container, {
		onOpen = self.refreshItemList,
		onRemoveItem = self.refreshItemList,
		onUpdateItem = self.refreshItemList,
		onAddItem = self.refreshItemList
	})

	self.window = GameNpc.panels[windowTypes.accessory_shop]

	self.window:setVisible(false)

	self.bottomPanel = self.window:recursiveGetChildById("bottomPanel")

	addEvent(function()
		AccessoryShop:setupShopsWidgets()
	end)
end

function AccessoryShop:terminate()
	self.window:destroy()
	disconnect(g_game, {
		onGameStart = self.onGameStart,
		onCoinBalance = self.onBalanceChange
	})
	disconnect(LocalPlayer, {
		onBountyMarksChange = self.onBountyMarksChange
	})
	disconnect(Container, {
		onOpen = self.refreshItemList,
		onRemoveItem = self.refreshItemList,
		onUpdateItem = self.refreshItemList,
		onAddItem = self.refreshItemList
	})

	AccessoryShop = nil
end

function AccessoryShop:setupShopsWidgets()
	for _, name in pairs(self.shopsNames) do
		local shopInfo = SHOPS[name]

		if shopInfo then
			local widget = g_ui.createWidget("AccessoryShopItemsPanel", self.window)

			widget:setId(name)

			self.shopsWidgets[name] = widget

			local itemsPanel = widget:recursiveGetChildById("itemsPanel")

			for _, info in pairs(shopInfo.items) do
				local itemData = ITEMS[info.clientId]

				if itemData then
					local itemWidget = g_ui.createWidget("AccessoryShopItem", itemsPanel)

					itemWidget.info = info

					itemWidget.name:setText(itemData.name)

					local item = Item.createFromData(itemData)

					itemWidget.item:setItem(item)
					itemWidget:setVisible(false)

					function itemWidget.onClick(widget)
						if self.lastItem then
							self.lastItem:setOn(false)
						end

						local bottomPanel = self.window:recursiveGetChildById("bottomPanel")

						bottomPanel:setOn(true)
						widget:setOn(true)

						self.lastItem = widget

						self:onTradeItem(widget)
					end
				end
			end
		end
	end
end

function AccessoryShop:onTradeItem(widget)
	if not self.bottomPanel:isOn() then
		return
	end

	if not self.type then
		return
	end

	local info = widget.info

	if not info then
		return
	end

	if self.type == "buy" then
		if not info.buy then
			return
		end
	elseif not info.sell then
		return
	end

	local buy_button = self.bottomPanel:getChildById("buyButton")
	local sell_button = self.bottomPanel:getChildById("sellButton")
	local item = self.bottomPanel:getChildById("shopItemInfo")

	item.item:setItem(widget.item:getItem())
	item.name:setText(widget.name:getText())
	item.silver_price:setText(widget.silver_price:getText())
	item.bounty_price:setText(widget.bounty_price:getText())

	widget.realCount = 1
	item.realCount = widget.realCount

	if self.type == "buy" then
		sell_button:hide()
		buy_button:show()

		function buy_button.onClick()
			GameNpc:sendOpcode({
				action = "dialogue",
				option = "npc_accessory_shop_buy",
				dialogueId = GameNpc.dialogueId,
				npcName = GameNpc.npcName,
				name = widget.name:getText()
			})
		end
	else
		buy_button:hide()
		sell_button:show()

		function sell_button.onClick()
			GameNpc:sendOpcode({
				action = "dialogue",
				option = "npc_accessory_shop_sell",
				dialogueId = GameNpc.dialogueId,
				npcName = GameNpc.npcName,
				name = widget.name:getText()
			})
		end
	end
end

function AccessoryShop:setSelectedTab(type)
	local selectionPanel = self.window:recursiveGetChildById("accessory_shop_selection_panel")

	if not selectionPanel then
		return
	end

	if type == "buy" then
		selectionPanel.left_option:setOn(true)
		selectionPanel.right_option:setOn(false)
	else
		selectionPanel.left_option:setOn(false)
		selectionPanel.right_option:setOn(true)
	end

	self:onSelectTab(type)
end

function AccessoryShop:onSelectTab(type)
	if self.type and self.type == type then
		return
	end

	self.type = type

	if self.lastItem then
		self.lastItem:setOn(false)

		self.lastItem = nil
	end

	local search = AccessoryShop.window:recursiveGetChildById("textEdit")

	search:setText("")

	local itemsPanel = self.currentShopWidget:recursiveGetChildById("itemsPanel")

	for _, itemWidget in ipairs(itemsPanel:getChildren()) do
		local info = itemWidget.info

		if info then
			if type == "buy" then
				if info.buy then
					itemWidget:setVisible(true)
					itemWidget.silver_price:setText(info.buy.silver or 0)
					itemWidget.bounty_price:setText(info.buy.bounty_marks or 0)
				else
					itemWidget:setVisible(false)
				end
			elseif info.sell then
				itemWidget:setVisible(true)
				itemWidget.silver_price:setText(info.sell.silver or 0)
				itemWidget.bounty_price:setText(info.sell.bounty_marks or 0)
			else
				itemWidget:setVisible(false)
			end
		end
	end

	self.bottomPanel:setChecked(false)
	self.bottomPanel:setOn(false)
	self:refreshItemList()
end

function AccessoryShop:onOpenNpcTrade(data)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local shopIndex = data.shopIndex

	if not shopIndex then
		return
	end

	local shopWidget = self.shopsWidgets[shopIndex]

	if not shopWidget then
		return
	end

	local shopInfo = SHOPS[shopIndex]

	if not shopInfo then
		return
	end

	if self.currentShopWidget then
		self.currentShopWidget:setVisible(false)

		self.currentShopWidget = nil
	end

	self.currentShopInfo = shopInfo
	self.currentShopWidget = shopWidget

	self.currentShopWidget:setVisible(true)
	self.window:recursiveGetChildById("silver").bounty_price:setText(player:getBountyMarks())
	GameNpc:setTopPanelOn(true)

	self.type = nil

	self:setSelectedTab(data.shopType or "buy")
	GameNpc:setPanel("accessory_shop")
	self.window:show()
	self.window:raise()
	self.window:focus()
	self:refreshItemList()
end

function AccessoryShop.onClose()
	if AccessoryShop.lastItem then
		AccessoryShop.lastItem:setOn(false)

		AccessoryShop.lastItem = nil
	end

	AccessoryShop.bottomPanel:setOn(false)

	local search = AccessoryShop.window:recursiveGetChildById("textEdit")

	search:setText("")
end

function AccessoryShop.onBalanceChange(premium, balance)
	AccessoryShop.window:recursiveGetChildById("silver").silver_price:setText(balance)
end

function AccessoryShop.onBountyMarksChange(player, bountyMarks)
	AccessoryShop.window:recursiveGetChildById("silver").bounty_price:setText(bountyMarks)
end

function AccessoryShop:onSearchFilter(widget)
	local text = widget:getText()

	widget.placeholder:setVisible(text:len() == 0)
	AccessoryShop.refreshItemList()
end

function AccessoryShop:itemCheck(player, widget, searchText)
	local info = widget.info

	if not info then
		widget:setEnabled(false)
		widget:setVisible(false)

		return
	end

	if info.questId and not player:isQuestCompleted(info.questId) then
		widget:setEnabled(false)
		widget:setVisible(false)

		return
	end

	if self.type and self.type == "sell" and player:getItemsCount(info.clientId, nil, nil, true) == 0 then
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

function AccessoryShop.refreshItemList()
	local self = AccessoryShop

	if not self.window:isVisible() then
		return
	end

	if not self.currentShopWidget then
		return
	end

	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local searchText = self.window:recursiveGetChildById("textEdit"):getText()
	local itemsPanel = self.currentShopWidget:recursiveGetChildById("itemsPanel")

	for index, child in pairs(itemsPanel:getChildren()) do
		self:itemCheck(player, child, searchText)

		if self.lastItem and self.lastItem == child and not child:isEnabled() then
			self.lastItem:setOn(false)

			self.lastItem = nil

			local bottomPanel = self.window:recursiveGetChildById("bottomPanel")

			bottomPanel:setChecked(false)
			bottomPanel:setOn(false)
		end
	end
end

function AccessoryShop:onChangeTypeSelection()
	local selectionPanel = self.window:recursiveGetChildById("accessory_shop_selection_panel")

	if not selectionPanel then
		return
	end

	local type = selectionPanel.left_option:isOn() and "buy" or "sell"

	self:onSelectTab(type)
end
