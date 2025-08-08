-- chunkname: @/modules/game_npcs/rangers_company_shop.lua

RangersCompanyShop = {
	shopsNames = {
		"RANGERS_COMPANY"
	},
	shopsWidgets = {}
}

function RangersCompanyShop.onGameEnd()
	return
end

function RangersCompanyShop:isVisible()
	return self.window and self.window:isVisible()
end

function RangersCompanyShop:init()
	connect(g_game, {
		onGameEnd = self.onGameEnd,
		onCoinBalance = self.onBalanceChange
	})
	connect(LocalPlayer, {
		onBountyMarksChange = self.onBountyMarksChange
	})

	self.window = GameNpc.panels[windowTypes.rangers_company_shop]

	self.window:setVisible(false)

	self.bottomPanel = self.window:recursiveGetChildById("bottomPanel")

	local itemQuality = RangersCompanyShop.window:recursiveGetChildById("itemQuality")

	itemQuality:setOn(false)
	addEvent(function()
		RangersCompanyShop:setupShopsWidgets()
	end)
end

function RangersCompanyShop:terminate()
	self.window:destroy()
	disconnect(g_game, {
		onGameEnd = self.onGameEnd,
		onCoinBalance = self.onBalanceChange
	})
	disconnect(LocalPlayer, {
		onBountyMarksChange = self.onBountyMarksChange
	})

	RangersCompanyShop = nil
end

function RangersCompanyShop:setupShopsWidgets()
	for _, name in pairs(self.shopsNames) do
		local shopInfo = SHOPS[name]

		if shopInfo then
			local widget = g_ui.createWidget("RangersCompanyShopItemsPanel", self.window)

			widget:setId(name)

			self.shopsWidgets[name] = widget

			for rankId, items in ipairs(shopInfo.items) do
				local rankPanel = g_ui.createWidget("RangersCompanyShopRankPanel", widget.itemsPanel)

				rankPanel:setId("rankPanel" .. rankId)
				rankPanel.name:setText(tr("Rank %i - %s", rankId, modules.game_rangerscompany.cfg.rankToName[rankId]))

				for index, info in ipairs(items) do
					local itemData = ITEMS[info.clientId]

					if itemData then
						local itemWidget = g_ui.createWidget("RangersCompanyShopItem", rankPanel.list)

						itemWidget.info = info

						itemWidget:setId("item" .. index)
						itemWidget.name:setText(itemData.name)

						itemWidget.item_cost = info.cost

						itemWidget.silver_price:setText(info.cost.silver or 0)
						itemWidget.bounty_price:setText(info.cost.bounty_marks or 0)

						itemWidget.category = rankId
						itemWidget.type = info.type

						local item = Item.createFromData(itemData)

						itemWidget.item:setItem(item)
						itemWidget.item:setCanHoverWhenDisabled(true)

						function itemWidget.onClick(widget)
							if self.lastItem then
								self.lastItem:setOn(false)
							end

							self.lastItem = widget

							widget:setOn(true)
							self.bottomPanel:setOn(true)
							self:onTradeItem(itemWidget)
						end
					end
				end

				rankPanel.list:update()
			end
		end
	end
end

function RangersCompanyShop:onTradeItem(widget)
	if not self.bottomPanel:isOn() then
		return
	end

	local buy_button = self.bottomPanel:getChildById("buyButton")
	local item = self.bottomPanel:getChildById("shopItemInfo")
	local value = RangersCompanyShop.window:recursiveGetChildById("cost")
	local count = RangersCompanyShop.window:recursiveGetChildById("count")
	local minus = RangersCompanyShop.window:recursiveGetChildById("minus")
	local plus = RangersCompanyShop.window:recursiveGetChildById("plus")
	local itemCost = widget.item_cost

	item.item:setItem(widget.item:getItem())
	item.name:setText(widget.name:getText())
	item.silver_price:setText(itemCost.silver)
	item.bounty_price:setText(itemCost.bounty_marks)

	if widget.type == "cosmetic" then
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

	value.silver_price:setText(itemCost.silver)
	value.bounty_price:setText(itemCost.bounty_marks)
	count:setText(widget.realCount or 1)
	self.onItemCountChange(count, count:getText())
	buy_button:show()

	function buy_button.onClick()
		GameNpc:sendOpcode({
			option = "npc_rangerscompany_shop_buy",
			action = "dialogue",
			dialogueId = GameNpc.dialogueId,
			npcName = GameNpc.npcName,
			name = widget.name:getText(),
			amount = tonumber(count:getText()) or 1
		})
	end
end

function RangersCompanyShop:onOpenNpcTrade(data)
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
	GameNpc:setTopPanelOn(true)
	self.bottomPanel:setChecked(false)
	self.bottomPanel:setOn(false)

	local search = RangersCompanyShop.window:recursiveGetChildById("textEdit")

	search:setText("", true)

	local itemsPanel = self.currentShopWidget:recursiveGetChildById("itemsPanel")

	for rankId, rankPanel in ipairs(itemsPanel:getChildren()) do
		local isLocked = rankId > data.rank

		rankPanel.name:setOn(not isLocked)
		rankPanel.lock_icon:setVisible(isLocked)

		for _, item in ipairs(rankPanel.list:getChildren()) do
			item:setEnabled(not isLocked)
		end

		if not isLocked and not rankPanel.expanded then
			rankPanel:onClick()
		elseif isLocked and rankPanel.expanded then
			rankPanel:onClick()
		end

		rankPanel.list:update()
	end

	GameNpc:setPanel("rangers_company_shop")
	self.window:show()
	self.window:raise()
	self.window:focus()
end

function RangersCompanyShop:buyItem()
	if self.bottomPanel:isOn() then
		g_game.buyItem(self.bottomPanel:recursiveGetChildById("item"):getItem(), self.bottomPanel:recursiveGetChildById("count"):getText(), true, false)
	end
end

function RangersCompanyShop:onSearchFilter(widget)
	if not self.currentShopWidget then
		return
	end

	local text = widget:getText()

	widget.placeholder:setVisible(text:len() == 0)

	for rankId, rankPanel in ipairs(self.currentShopWidget.itemsPanel:getChildren()) do
		local showRank = false

		for _, item in ipairs(rankPanel.list:getChildren()) do
			local name = item.name:getText():lower()
			local found = name:find(text:lower(), 1, true) ~= nil

			item:setVisible(found)

			item.hidden = not found

			if found then
				showRank = true
			end
		end

		local isLocked = rankPanel.lock_icon:isVisible()

		rankPanel:setVisible(showRank)
		rankPanel.list:update()
		rankPanel:setHeight(isLocked and rankPanel.shrinkedHeight or rankPanel.expandedHeight)

		if not rankPanel.expanded and showRank then
			rankPanel:onClick()
		elseif rankPanel.expanded and isLocked and (not showRank or text == "") then
			rankPanel:onClick()
		end
	end
end

function RangersCompanyShop.onBalanceChange(premium, balance)
	RangersCompanyShop.window:recursiveGetChildById("silver").silver_price:setText(balance)
end

function RangersCompanyShop.onItemCountChange(widget, text)
	local count = math.clamp(tonumber(text) or 0, 0, 1000)
	local silver_price = widget:getParent().silver_price._internal_value or 0

	RangersCompanyShop.window:recursiveGetChildById("cost").silver_price:setText(silver_price * count)

	local bounty_price = tonumber(widget:getParent().bounty_price:getText()) or 0

	RangersCompanyShop.window:recursiveGetChildById("cost").bounty_price:setText(bounty_price * count)
	widget:setText(count, true)
end

function RangersCompanyShop.onClose()
	if RangersCompanyShop.lastItem then
		RangersCompanyShop.lastItem:setOn(false)
	end

	RangersCompanyShop.lastItem = nil

	RangersCompanyShop.bottomPanel:setOn(false)

	local search = RangersCompanyShop.window:recursiveGetChildById("textEdit")

	search:setText("")
end

function RangersCompanyShop.onBountyMarksChange(player, bountyMarks)
	RangersCompanyShop.window:recursiveGetChildById("silver").bounty_price:setText(bountyMarks)
end
