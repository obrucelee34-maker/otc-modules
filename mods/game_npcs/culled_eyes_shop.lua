-- chunkname: @/modules/game_npcs/culled_eyes_shop.lua

CulledEyesShop = {}

function CulledEyesShop.onGameEnd()
	return
end

function CulledEyesShop:isVisible()
	return self.window and self.window:isVisible()
end

function CulledEyesShop:init()
	connect(g_game, {
		onGameEnd = self.onGameEnd,
		onDawnEssenceBalanceChange = self.onDawnEssenceBalanceChange
	})
	connect(Container, {
		onRemoveItem = self.refreshItemList
	})

	self.window = GameNpc.panels[windowTypes.culled_eyes_shop]

	self.window:setVisible(false)
end

function CulledEyesShop:terminate()
	self.window:destroy()
	disconnect(g_game, {
		onGameStart = self.onGameStart,
		onDawnEssenceBalanceChange = self.onDawnEssenceBalanceChange
	})
	disconnect(Container, {
		onRemoveItem = self.refreshItemList
	})

	CulledEyesShop = nil
end

function CulledEyesShop:onTradeItem(widget)
	local bottomPanel = self.window:recursiveGetChildById("bottomPanel")

	if bottomPanel and bottomPanel:isOn() then
		local sell_button = bottomPanel:getChildById("sellButton")
		local item = bottomPanel:getChildById("shopItemInfo")
		local value = CulledEyesShop.window:recursiveGetChildById("cost")

		item.item:setItem(widget.item:getItem())
		item.name:setText(widget.name:getText())
		item.dawn_essence_price:setText(widget.dawn_essence_price:getText())
		item.experience:setText(widget.experience:getText())
		value.dawn_essence_price:setText(widget.dawn_essence_price:getText())
		value.experience:setText(widget.experience:getText())
		sell_button:show()

		function sell_button.onClick()
			GameNpc:sendOpcode({
				action = "dialogue",
				option = "npc_culled_eyes_sell",
				dialogueId = GameNpc.dialogueId,
				npcName = GameNpc.npcName,
				itemUUID = widget.item:getItem():getUUID()
			})
		end
	end
end

function CulledEyesShop:onOpenNpcTrade(data)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local itemsPanel = CulledEyesShop.window:recursiveGetChildById("itemsPanel")

	GameNpc:setTopPanelOn(true)

	local bottomPanel = CulledEyesShop.window:recursiveGetChildById("bottomPanel")

	bottomPanel:setChecked(false)
	bottomPanel:setOn(false)

	local itemQuality = CulledEyesShop.window:recursiveGetChildById("itemQuality")

	itemQuality:setOn(false)

	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	itemsPanel:destroyChildren()

	for _, info in ipairs(data.items) do
		local widget = g_ui.createWidget("CulledEyesShopItem", itemsPanel)
		local item = player:getItemByUUID(info.itemUUID)

		widget.item:setItem(item)
		widget.name:setText(item:getName())
		widget.dawn_essence_price:setText(info.dawnEssence)
		widget.experience:setText(info.experience)

		function widget.onClick()
			if CulledEyesShop.lastItem then
				CulledEyesShop.lastItem:setOn(false)
			end

			local bottomPanel = CulledEyesShop.window:recursiveGetChildById("bottomPanel")

			bottomPanel:setOn(true)
			widget:setOn(true)

			CulledEyesShop.lastItem = widget

			CulledEyesShop:onTradeItem(widget)
		end
	end

	GameNpc:setPanel("culled_eyes_shop")
	self.window:show()
	self.window:raise()
	self.window:focus()
end

function CulledEyesShop:onSearchFilter(widget)
	local text = widget:getText()

	widget.placeholder:setVisible(text:len() == 0)

	for rankId, itemWidget in ipairs(CulledEyesShop.window.itemsPanel:getChildren()) do
		local name = itemWidget.name:getText():lower()
		local found = name:find(text:lower(), 1, true) ~= nil

		itemWidget:setVisible(found)

		itemWidget.hidden = not found
	end
end

function CulledEyesShop.onDawnEssenceBalanceChange(amount)
	local bottomPanel = CulledEyesShop.window:recursiveGetChildById("bottomPanel")
	local dawnEssence = bottomPanel.dawn_essence.dawn_essence_price

	dawnEssence:setText(amount)
	bottomPanel.dawn_essence.experience_icon:hide()
	bottomPanel.dawn_essence.experience:hide()
end

function CulledEyesShop.onClose()
	if CulledEyesShop.lastItem then
		CulledEyesShop.lastItem:setOn(false)
	end

	CulledEyesShop.lastItem = nil

	local bottomPanel = CulledEyesShop.window:recursiveGetChildById("bottomPanel")

	if bottomPanel:isOn() then
		bottomPanel:setOn(false)
	end

	local search = CulledEyesShop.window:recursiveGetChildById("textEdit")

	search:setText("")
end

function CulledEyesShop.refreshItemList(container, slot, item)
	if not CulledEyesShop.window then
		return
	end

	local itemsPanel = CulledEyesShop.window:recursiveGetChildById("itemsPanel")

	for _, itemWidget in ipairs(itemsPanel:getChildren()) do
		if itemWidget.item:getItem():getUUID() == item:getUUID() then
			itemWidget:destroy()
			CulledEyesShop:trySelectFirstItem()

			return
		end
	end
end

function CulledEyesShop.trySelectFirstItem()
	local itemsPanel = CulledEyesShop.window:recursiveGetChildById("itemsPanel")
	local firstItem

	for _, itemWidget in ipairs(itemsPanel:getChildren()) do
		if not itemWidget.hidden then
			firstItem = itemWidget

			break
		end
	end

	if firstItem then
		firstItem:onClick()
	else
		local bottomPanel = CulledEyesShop.window:recursiveGetChildById("bottomPanel")

		bottomPanel:setOn(false)
	end
end
