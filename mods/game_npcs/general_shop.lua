-- chunkname: @/modules/game_npcs/general_shop.lua

GeneralShop = {
	shopsNames = {
		"CREATURE_DROPS",
		"BASIC_POTIONS",
		"BASIC_BLACKSMITH",
		"BASIC_TAVERN",
		"AHIROM",
		"GREEDY_JACKSON",
		"KARAKASH",
		"NELSON",
		"SONI",
		"STEIGARD",
		"THRAIN_DARKHAMMER"
	},
	shopsWidgets = {}
}

function GeneralShop:isVisible()
	return self.window and self.window:isVisible()
end

function GeneralShop:init()
	connect(g_game, {
		onCoinBalance = self.onBalanceChange
	})
	connect(Container, {
		onOpen = self.refreshItemList,
		onRemoveItem = self.refreshItemList,
		onUpdateItem = self.refreshItemList,
		onAddItem = self.refreshItemList
	})

	self.window = GameNpc.panels[windowTypes.general_shop]

	self.window:setVisible(false)

	self.searchWidget = self.window:recursiveGetChildById("textEdit")
	self.bottomPanel = self.window:recursiveGetChildById("bottomPanel")
	self.buy_button = self.bottomPanel:recursiveGetChildById("buyButton")
	self.sell_button = self.bottomPanel:recursiveGetChildById("sellButton")
	self.shopItemInfo = self.bottomPanel:recursiveGetChildById("shopItemInfo")
	self.itemQuality = self.bottomPanel:recursiveGetChildById("itemQuality")
	self.silverBalance = self.bottomPanel:recursiveGetChildById("silver_balance")
	self.totalCost = self.bottomPanel:recursiveGetChildById("total_cost")

	connect(self.bottomPanel, {
		onVisibilityChange = function(widget, visible)
			for _, child in pairs(widget:getChildren()) do
				child:setVisible(visible)
			end
		end
	})
	addEvent(function()
		GeneralShop:setupShopsWidgets()
		GeneralShop:populateItemsRarity(ItemsShopQuality)
	end)
end

function GeneralShop:terminate()
	self.window:destroy()
	disconnect(g_game, {
		onCoinBalance = self.onBalanceChange
	})
	disconnect(Container, {
		onOpen = self.refreshItemList,
		onRemoveItem = self.refreshItemList,
		onUpdateItem = self.refreshItemList,
		onAddItem = self.refreshItemList
	})

	GeneralShop = nil
end

function GeneralShop:setupShopsWidgets()
	for _, name in ipairs(self.shopsNames) do
		local shopInfo = SHOPS[name]

		if shopInfo then
			table.sort(shopInfo.items, function(a, b)
				local itemDataA = ITEMS[a.clientId]
				local itemDataB = ITEMS[b.clientId]

				if not itemDataA or not itemDataB then
					return a.clientId < b.clientId
				end

				if a.buy and not b.buy then
					return true
				elseif not a.buy and b.buy then
					return false
				end

				if a.sell and not b.sell then
					return true
				elseif not a.sell and b.sell then
					return false
				end

				if a.buy and b.buy and a.buy ~= b.buy then
					return a.buy < b.buy
				end

				if a.sell and b.sell and a.sell ~= b.sell then
					return a.sell < b.sell
				end

				return itemDataA.name < itemDataB.name
			end)

			local widget = g_ui.createWidget("GeneralShopItemsPanel", self.window)

			widget:setId(name)

			self.shopsWidgets[name] = widget
			shopInfo.types = {}

			local itemsPanel = widget:recursiveGetChildById("itemsPanel")

			for _, info in ipairs(shopInfo.items) do
				local itemData = ITEMS[info.clientId]

				if itemData then
					local itemWidget = g_ui.createWidget("GeneralShopItem", itemsPanel)

					itemWidget.info = info

					itemWidget.name:setText(itemData.name)

					local item = Item.createFromData(itemData)

					itemWidget.item:setItem(item)
					itemWidget:setVisible(false)

					function itemWidget.onClick(widget)
						if self.lastItem then
							self.lastItem:setOn(false)
						end

						widget:setOn(true)

						self.lastItem = widget

						self:onTradeItem(widget)
					end

					if info.buy then
						shopInfo.types.buy = true
					end

					if info.sell then
						shopInfo.types.sell = true
					end
				end
			end
		end
	end
end

function GeneralShop:populateItemsRarity(values)
	local comboBox = self.window:recursiveGetChildById("comboBox")

	for _, option in ipairs(values) do
		comboBox:addOption(option.name, nil, true)
	end

	comboBox.onOptionChange = GeneralShop.onQualityChange
end

function GeneralShop:onTradeItem(widget)
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

	self.shopItemInfo.info = info

	self.shopItemInfo.item:setItem(widget.item:getItem())
	self.shopItemInfo.name:setText(widget.name:getText())

	self.shopItemInfo.real_count = self.type == "sell" and widget.real_count or nil
	self.shopItemInfo.silver_price.real_value = widget.silver_price.real_value

	self.shopItemInfo.silver_price:setText(math.floor(widget.silver_price.real_value))

	if self.type == "buy" then
		self.onItemCountChange(self.shopItemInfo.count_panel.count, 1)
		self.sell_button:hide()
		self.buy_button:show()

		function self.buy_button.onClick()
			GameNpc:sendOpcode({
				option = "npc_general_shop_buy",
				action = "dialogue",
				dialogueId = GameNpc.dialogueId,
				npcName = GameNpc.npcName,
				name = widget.name:getText(),
				amount = tonumber(self.shopItemInfo.count_panel.count:getText()) or 1
			})
		end
	else
		self.onItemCountChange(self.shopItemInfo.count_panel.count, self.shopItemInfo.real_count)
		self.buy_button:hide()
		self.sell_button:show()

		function self.sell_button.onClick()
			GameNpc:sendOpcode({
				action = "dialogue",
				option = "npc_general_shop_sell",
				dialogueId = GameNpc.dialogueId,
				npcName = GameNpc.npcName,
				name = widget.name:getText(),
				serverId = info.id,
				amount = tonumber(self.shopItemInfo.count_panel.count:getText()) or 1,
				quality = self:hasQuality() and self.currentQuality or self.shopItemInfo.info.quality
			})
		end
	end

	self:updateBottomPanel()
end

function GeneralShop:updateSelectedTab()
	local selectionPanel = self.window:recursiveGetChildById("general_shop_selection_panel")

	if not selectionPanel then
		return
	end

	if self.type == "buy" then
		selectionPanel.left_option:setOn(true)
		selectionPanel.right_option:setOn(false)
	else
		selectionPanel.left_option:setOn(false)
		selectionPanel.right_option:setOn(true)
	end

	local hasBothTypes = self.currentShopInfo.types.buy and self.currentShopInfo.types.sell

	selectionPanel:setVisible(hasBothTypes)
	selectionPanel:setHeight(hasBothTypes and 40 or 0)
end

function GeneralShop:updateItem(itemWidget)
	local info = itemWidget.info

	if not info then
		return
	end

	local hasQuality = self:hasQuality()
	local quality = info.quality or hasQuality and self.currentQuality
	local qualityMultiplier = quality and self.currentShopInfo.qualityMultiplier and self.currentShopInfo.qualityMultiplier[self.type] and self.currentShopInfo.qualityMultiplier[self.type][quality] or 1
	local qualityName = quality and QualityNames[quality] and QualityNames[quality]:titleCase() or "Basic"
	local item = itemWidget.item:getItem()

	item:setQuality(quality or 0)
	item:setQualityName(qualityName)

	if self.type == "buy" then
		itemWidget.silver_price.real_value = math.round(info.buy * qualityMultiplier)

		itemWidget.silver_price:setText(itemWidget.silver_price.real_value)
	else
		itemWidget.silver_price.real_value = math.round(info.sell * qualityMultiplier)

		itemWidget.silver_price:setText(itemWidget.silver_price.real_value)
	end
end

function GeneralShop:updateBottomPanel()
	if self.type == "buy" and not self.lastItem then
		self.bottomPanel:setVisible(false)

		return
	end

	self.bottomPanel:setVisible(true)
	self.bottomPanel.shopItemInfoHolder:setVisible(self.lastItem ~= nil)
	self.bottomPanel.itemQualityHolder:setVisible(self:hasQuality())
	self.buy_button:setVisible(self.type == "buy")
	self.buy_button:setEnabled(self.type == "buy" and self.lastItem ~= nil)
	self.sell_button:setVisible(self.type == "sell")
	self.sell_button:setEnabled(self.type == "sell" and self.lastItem ~= nil)

	if not self.lastItem then
		self.totalCost.silver:setText(0)
	end
end

function GeneralShop:onOpenNpcTrade(data)
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

	self.searchWidget:setText("", true)

	if self.currentShopWidget then
		self.currentShopWidget:setVisible(false)

		self.currentShopWidget = nil
	end

	self.currentShopIndex = shopIndex
	self.currentShopInfo = shopInfo
	self.currentShopWidget = shopWidget

	self.currentShopWidget:setVisible(true)

	self.type = data.shopType or "buy"

	if self.type == "buy" and not self.currentShopInfo.types.buy then
		self.type = "sell"
	end

	if self.type == "sell" and not self.currentShopInfo.types.sell then
		self.type = "buy"
	end

	if self.lastItem then
		self.lastItem:setOn(false)

		self.lastItem = nil
	end

	self.currentQuality = ItemsShopQuality[1].quality

	self.itemQuality.comboBox:setOption(ItemsShopQuality[1].name, true)
	self:updateSelectedTab()
	GameNpc:setPanel("general_shop")
	self.window:show()
	self.window:raise()
	self.window:focus()
	self:refreshItemList()

	if shopIndex == "CREATURE_DROPS" then
		self:findQualityWithItems()
	end
end

function GeneralShop.onClose()
	if GeneralShop.lastItem then
		GeneralShop.lastItem:setOn(false)

		GeneralShop.lastItem = nil
	end

	GeneralShop.bottomPanel:setVisible(false)
	GeneralShop.searchWidget:setText("", true)
end

function GeneralShop:hasQuality()
	return self.currentShopInfo and self.currentShopInfo.qualityMultiplier and self.currentShopInfo.qualityMultiplier[self.type]
end

function GeneralShop.onBalanceChange(premium, balance)
	GeneralShop.silverBalance.silver:setText(balance)
end

function GeneralShop:onSearchFilter(widget)
	local text = widget:getText()

	widget.placeholder:setVisible(text:len() == 0)
	GeneralShop.refreshItemList()
end

function GeneralShop.onQualityChange(widget)
	local self = GeneralShop
	local currentIndex = widget:getCurrentOptionIndex()
	local selectedQuality = ItemsShopQuality[currentIndex]

	if not selectedQuality then
		return
	end

	if self.currentQuality == selectedQuality.quality then
		return
	end

	if self.lastItem then
		self.lastItem:setOn(false)

		self.lastItem = nil
	end

	self.currentQuality = selectedQuality.quality

	self:refreshItemList()
end

function GeneralShop.onItemCountChange(widget, text)
	local parent = widget:getParent():getParent()
	local count = math.clamp(tonumber(text) or 0, 0, parent.real_count or 100)
	local price = parent.silver_price.real_value

	GeneralShop.totalCost.silver:setText(math.floor(price * count))
	widget:setText(count, true)
end

function GeneralShop:requirementsCheck(player, info)
	local repRequirement = info.rep

	if repRequirement and repRequirement.totalExperience and player:getTotalAcquiredReputationExperience() < repRequirement.totalExperience then
		return false
	end

	local artifactRequirement = info.artifact

	if artifactRequirement and artifactRequirement.regionId then
		if artifactRequirement.progress and player:getArtifactRegionProgress(artifactRequirement.regionId) < artifactRequirement.progress then
			return false
		end

		if artifactRequirement.objectiveId and not player:hasCompletedArtifactObjective(artifactRequirement.regionId, artifactRequirement.objectiveId) then
			return false
		end
	end

	local questRequirement = info.quest

	if questRequirement and questRequirement.questId and questRequirement.taskId then
		local questName = modules.game_questlog.GameQuestLog.questIdToName[questRequirement.questId]

		if questName and not player:isTaskActive(questName, questRequirement.taskId) then
			return false
		end
	end

	return true
end

function GeneralShop:itemCheck(player, widget, searchText)
	if not widget.info then
		widget:setEnabled(false)
		widget:setVisible(false)

		return
	end

	if not widget.info[self.type] then
		widget:setEnabled(false)
		widget:setVisible(false)

		return
	end

	if not self:requirementsCheck(player, widget.info) then
		widget:setEnabled(false)
		widget:setVisible(false)

		return
	end

	if self.type and self.type == "sell" then
		widget.real_count = player:getItemsCount(widget.info.clientId, self.currentQuality, nil, true)

		if widget.real_count == 0 then
			widget:setEnabled(false)
			widget:setVisible(false)

			return
		end
	end

	self:updateItem(widget)
	widget:setEnabled(true)

	if not searchText or searchText == "" then
		widget:setVisible(true)
	else
		local name = widget.name:getText():lower()
		local found = name:find(searchText:lower(), 1, true) ~= nil

		widget:setVisible(found)
	end
end

function GeneralShop.refreshItemList()
	local self = GeneralShop

	if not self.window:isVisible() then
		return
	end

	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local searchText = self.searchWidget:getText()
	local itemsPanel = self.currentShopWidget:recursiveGetChildById("itemsPanel")
	local firstChild

	for _, child in pairs(itemsPanel:getChildren()) do
		self:itemCheck(player, child, searchText)

		if not firstChild and child:isVisible() then
			firstChild = child
		end
	end

	if self.lastItem and not self.lastItem:isEnabled() then
		self.lastItem:setOn(false)

		self.lastItem = nil
	end

	if self.lastItem then
		if self.type == "sell" then
			local real_count = self.lastItem.real_count

			self.shopItemInfo.real_count = real_count

			local currentCount = tonumber(self.shopItemInfo.count_panel.count:getText()) or 0

			if real_count < currentCount then
				self.onItemCountChange(self.shopItemInfo.count_panel.count, real_count)
			end
		end
	elseif firstChild then
		self:trySelectFirstItem(firstChild)
	end

	self:updateBottomPanel()
end

function GeneralShop:trySelectFirstItem(firstChild)
	if not self.currentShopWidget then
		return
	end

	if self.lastItem then
		return
	end

	if not firstChild then
		local itemsPanel = self.currentShopWidget:recursiveGetChildById("itemsPanel")

		for _, child in pairs(itemsPanel:getChildren()) do
			if child:isVisible() then
				firstChild = child

				break
			end
		end
	end

	if firstChild then
		firstChild.onClick(firstChild)
	end
end

function GeneralShop:findQualityWithItems()
	if self.lastItem then
		return
	end

	if not self:hasQuality() then
		return
	end

	local currentQuality = self.currentQuality

	for _, qualityData in ipairs(ItemsShopQuality) do
		if qualityData.quality ~= currentQuality then
			self.currentQuality = qualityData.quality

			self:refreshItemList()

			if self.lastItem then
				self.itemQuality.comboBox:setOption(qualityData.name, true)

				break
			end
		end
	end

	if not self.lastItem and self.currentShopIndex == "CREATURE_DROPS" then
		local player, creature = g_game.getLocalPlayer(), g_map.getCreatureById(GameNpc.npcId)

		if creature and creature:isNpc() then
			local message = string.format("Hey %s, you don't have any Creature Products with you! Come back if you have any products you wish to sell.", player:getName())

			GameChat.onTalk(creature:getName(), nil, TalkTypes.TalkTypeSay, message, nil, creature:getPosition(), creature:getId(), nil, nil, nil, nil)
		end

		GameNpc:onClose(nil, nil, true)
	end
end

function GeneralShop:onChangeTypeSelection()
	local selectionPanel = self.window:recursiveGetChildById("general_shop_selection_panel")

	if not selectionPanel then
		return
	end

	self.type = selectionPanel.left_option:isOn() and "buy" or "sell"

	if self.lastItem then
		self.lastItem:setOn(false)

		self.lastItem = nil
	end

	self:refreshItemList()
end
