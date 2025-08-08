-- chunkname: @/modules/game_npcs/rangers_company_specialshop.lua

RangersCompanySpecialShop = {
	shopsNames = {
		"RANGERS_COMPANY"
	},
	shopsWidgets = {},
	updateTimeLeftToDailyReset = {
		widgetsToUpdate = {}
	}
}

function RangersCompanySpecialShop.onGameEnd()
	return
end

function RangersCompanySpecialShop:isVisible()
	return self.window and self.window:isVisible()
end

function RangersCompanySpecialShop:init()
	connect(g_game, {
		onGameEnd = self.onGameEnd,
		onCoinBalance = self.onBalanceChange
	})
	connect(LocalPlayer, {
		onBountyMarksChange = self.onBountyMarksChange
	})

	self.window = GameNpc.panels[windowTypes.rangers_company_specialshop]

	self.window:setVisible(false)

	self.bottomPanel = self.window:recursiveGetChildById("bottomPanel")

	local itemQuality = RangersCompanySpecialShop.window:recursiveGetChildById("itemQuality")

	itemQuality:setOn(false)
	addEvent(function()
		RangersCompanySpecialShop:setupShopsWidgets()
	end)
end

function RangersCompanySpecialShop:terminate()
	self.window:destroy()
	disconnect(g_game, {
		onGameEnd = self.onGameEnd,
		onCoinBalance = self.onBalanceChange
	})
	disconnect(LocalPlayer, {
		onBountyMarksChange = self.onBountyMarksChange
	})

	RangersCompanySpecialShop = nil
end

function RangersCompanySpecialShop:setupShopsWidgets()
	for _, name in pairs(self.shopsNames) do
		local shopInfo = SHOPS[name]

		if shopInfo then
			local widget = g_ui.createWidget("RangersCompanyShopItemsPanel", self.window)

			widget:setId(name)

			self.shopsWidgets[name] = widget

			for category, offers in pairs(shopInfo.specialOffers) do
				local categoryPanel = g_ui.createWidget("RangersCompanySpecialShopRankPanel", widget.itemsPanel)

				categoryPanel:setId("category_panel" .. category)

				local name = category

				if offers.dailyLimit then
					name = name .. string.format(" Limited Shop (Update Daily)")
				end

				categoryPanel.dailyLimit = offers.dailyLimit

				categoryPanel.limit_square_box:setText(string.format("0/%d", offers.dailyLimit))
				categoryPanel.name:setText(tr(name))

				categoryPanel.category = category

				for index, info in ipairs(offers) do
					local itemData = ITEMS[info.clientId]

					if itemData then
						local itemWidget = g_ui.createWidget("RangersCompanyShopItem", categoryPanel.list)

						itemWidget.info = info

						itemWidget:setId("item" .. index)
						itemWidget.name:setText(itemData.name)

						itemWidget.item_cost = info.cost

						itemWidget.silver_price:setText(info.cost.silver or 0)
						itemWidget.bounty_price:setText(info.cost.bounty_marks or 0)

						itemWidget.category = category
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

				categoryPanel.list:update()
			end
		end
	end
end

function RangersCompanySpecialShop:onTradeItem(widget)
	if not self.bottomPanel:isOn() then
		return
	end

	local buy_button = self.bottomPanel:getChildById("buyButton")
	local item = self.bottomPanel:getChildById("shopItemInfo")
	local value = RangersCompanySpecialShop.window:recursiveGetChildById("cost")
	local count = RangersCompanySpecialShop.window:recursiveGetChildById("count")
	local minus = RangersCompanySpecialShop.window:recursiveGetChildById("minus")
	local plus = RangersCompanySpecialShop.window:recursiveGetChildById("plus")
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
			option = "npc_rangerscompany_specialshop_buy",
			action = "dialogue",
			dialogueId = GameNpc.dialogueId,
			npcName = GameNpc.npcName,
			name = widget.name:getText(),
			amount = tonumber(count:getText()) or 1
		})
	end
end

local resetLimitSquareBoxes = false

local function updateTimeLeftToDailyReset()
	local self = RangersCompanySpecialShop

	if not self.updateTimeLeftToDailyReset.event then
		return
	end

	if not self:isVisible() then
		self.updateTimeLeftToDailyReset.event = nil
		self.updateTimeLeftToDailyReset.widgetsToUpdate = {}

		return
	end

	if resetLimitSquareBoxes then
		for shopName, widget in pairs(self.shopsWidgets) do
			for _, categoryPanel in ipairs(widget.itemsPanel:getChildren()) do
				categoryPanel.limit_square_box:setText("0/0")
			end
		end

		resetLimitSquareBoxes = false
	end

	local now = os.time()
	local timeLeft = self.dailyResetInternalEndTime - now

	if timeLeft <= 0 then
		self.dailyResetInternalEndTime = now + 86400
		resetLimitSquareBoxes = true
	end

	local text = os.date("!%H:%M:%S", timeLeft)

	for _, widget in ipairs(self.updateTimeLeftToDailyReset.widgetsToUpdate) do
		widget:setText(text)
	end

	self.updateTimeLeftToDailyReset.event = scheduleEvent(updateTimeLeftToDailyReset, 1000)
end

function RangersCompanySpecialShop:onOpenNpcTrade(data)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local shopIndex = data.shopIndex

	if not shopIndex then
		return
	end

	if not data.timeLeftToDailyReset then
		return
	end

	self.dailyResetInternalEndTime = data.timeLeftToDailyReset + os.time()

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

	local search = RangersCompanySpecialShop.window:recursiveGetChildById("textEdit")

	search:setText("", true)

	local itemsPanel = self.currentShopWidget:recursiveGetChildById("itemsPanel")

	if self.updateTimeLeftToDailyReset.event then
		removeEvent(self.updateTimeLeftToDailyReset.event)

		self.updateTimeLeftToDailyReset.event = nil
		self.updateTimeLeftToDailyReset.widgetsToUpdate = {}
	end

	for idx, categoryPanel in ipairs(itemsPanel:getChildren()) do
		local isLocked = false

		if categoryPanel.dailyLimit then
			categoryPanel.clock_text:setText(os.date("!%H:%M:%S", self.dailyResetInternalEndTime - os.time()))
			table.insert(self.updateTimeLeftToDailyReset.widgetsToUpdate, categoryPanel.clock_text)
		end

		local categoryStorage = data.categoriesStorage[categoryPanel.category]

		if categoryStorage then
			categoryPanel.limit_square_box:setText(string.format("%d/%d", categoryStorage.count, categoryPanel.dailyLimit))
		end

		categoryPanel.name:setOn(not isLocked)
		categoryPanel.lock_icon:setVisible(isLocked)

		for _, item in ipairs(categoryPanel.list:getChildren()) do
			item:setEnabled(not isLocked)
		end

		if not isLocked and not categoryPanel.expanded then
			categoryPanel:onClick()
		elseif isLocked and categoryPanel.expanded then
			categoryPanel:onClick()
		end

		categoryPanel.list:update()
	end

	self.updateTimeLeftToDailyReset.event = scheduleEvent(updateTimeLeftToDailyReset, 1000)

	GameNpc:setPanel("rangers_company_specialshop")
	self.window:show()
	self.window:raise()
	self.window:focus()
end

function RangersCompanySpecialShop:buyItem()
	if self.bottomPanel:isOn() then
		g_game.buyItem(self.bottomPanel:recursiveGetChildById("item"):getItem(), self.bottomPanel:recursiveGetChildById("count"):getText(), true, false)
	end
end

function RangersCompanySpecialShop:onSearchFilter(widget)
	if not self.currentShopWidget then
		return
	end

	local text = widget:getText()
	local parent = widget:getParent()

	parent.placeholder:setVisible(text:len() == 0)

	for _, categoryPanel in ipairs(self.currentShopWidget.itemsPanel:getChildren()) do
		local showCategory = false

		for _, item in ipairs(categoryPanel.list:getChildren()) do
			local name = item.name:getText():lower()
			local found = name:find(text:lower(), 1, true) ~= nil

			item:setVisible(found)

			item.hidden = not found

			if found then
				showCategory = true
			end
		end

		local isLocked = categoryPanel.lock_icon:isVisible()

		categoryPanel:setVisible(showCategory)
		categoryPanel.list:update()
		categoryPanel:setHeight(isLocked and categoryPanel.shrinkedHeight or categoryPanel.expandedHeight)

		if not categoryPanel.expanded and showCategory then
			categoryPanel:onClick()
		elseif categoryPanel.expanded and isLocked and (not showCategory or text == "") then
			categoryPanel:onClick()
		end
	end
end

function RangersCompanySpecialShop.onBalanceChange(premium, balance)
	RangersCompanySpecialShop.window:recursiveGetChildById("silver").silver_price:setText(balance)
end

function RangersCompanySpecialShop.onItemCountChange(widget, text)
	local count = math.clamp(tonumber(text) or 0, 0, 1000)
	local silver_price = widget:getParent().silver_price._internal_value or 0

	RangersCompanySpecialShop.window:recursiveGetChildById("cost").silver_price:setText(silver_price * count)

	local bounty_price = tonumber(widget:getParent().bounty_price:getText()) or 0

	RangersCompanySpecialShop.window:recursiveGetChildById("cost").bounty_price:setText(bounty_price * count)
	widget:setText(count, true)
end

function RangersCompanySpecialShop.onClose()
	if RangersCompanySpecialShop.lastItem then
		RangersCompanySpecialShop.lastItem:setOn(false)
	end

	RangersCompanySpecialShop.lastItem = nil

	RangersCompanySpecialShop.bottomPanel:setOn(false)

	local search = RangersCompanySpecialShop.window:recursiveGetChildById("textEdit")

	search:setText("")
end

function RangersCompanySpecialShop.onBountyMarksChange(player, bountyMarks)
	RangersCompanySpecialShop.window:recursiveGetChildById("silver").bounty_price:setText(bountyMarks)
end

function RangersCompanySpecialShop:updateLimits(data)
	local itemsPanel = self.currentShopWidget:recursiveGetChildById("itemsPanel")

	for _, categoryPanel in ipairs(itemsPanel:getChildren()) do
		local categoryStorage = data.storage[categoryPanel.category]

		if categoryStorage then
			categoryPanel.limit_square_box:setText(string.format("%d/%d", categoryStorage.count, categoryPanel.dailyLimit))
		end
	end
end
