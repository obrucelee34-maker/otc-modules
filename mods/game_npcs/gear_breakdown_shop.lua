-- chunkname: @/modules/game_npcs/gear_breakdown_shop.lua

GearBreakdownShop = {
	itemTypeToDawnEssence = {
		weapon = {
			4,
			8,
			40,
			90,
			290,
			530,
			1720
		},
		armor = {
			2,
			4,
			20,
			45,
			145,
			265,
			860
		}
	}
}

function GearBreakdownShop.onGameEnd()
	return
end

function GearBreakdownShop:isVisible()
	return self.window and self.window:isVisible()
end

function GearBreakdownShop:init()
	connect(g_game, {
		onGameEnd = self.onGameEnd,
		onDawnEssenceBalanceChange = self.onDawnEssenceBalanceChange
	})
	connect(Container, {
		onRemoveItem = self.refreshItemList
	})

	self.window = GameNpc.panels[windowTypes.gear_breakdown_shop]

	self.window:setVisible(false)
end

function GearBreakdownShop:terminate()
	self.window:destroy()
	disconnect(g_game, {
		onGameEnd = self.onGameEnd,
		onDawnEssenceBalanceChange = self.onDawnEssenceBalanceChange
	})
	disconnect(Container, {
		onRemoveItem = self.refreshItemList
	})

	GearBreakdownShop = nil
end

function GearBreakdownShop:onTradeItem(widget)
	local bottomPanel = self.window:recursiveGetChildById("bottomPanel")

	if bottomPanel and bottomPanel:isOn() then
		local sell_button = bottomPanel:getChildById("breakButton")
		local item = bottomPanel:getChildById("shopItemInfo")
		local value = GearBreakdownShop.window:recursiveGetChildById("cost")

		item.item:setItem(widget.item:getItem())
		item.name:setText(widget.name:getText())
		item.dawn_essence_price:setText(widget.dawn_essence_price:getText())
		value.dawn_essence_price:setText(widget.dawn_essence_price:getText())
		sell_button:show()

		function sell_button.onClick()
			GameNpc:sendOpcode({
				action = "dialogue",
				option = "npc_gear_breakdown_sell",
				dialogueId = GameNpc.dialogueId,
				npcName = GameNpc.npcName,
				itemUUID = widget.item:getItem():getUUID()
			})
		end
	end
end

function GearBreakdownShop:getBreakdownItems()
	local player = g_game.getLocalPlayer()

	if not player then
		return {}
	end

	local items = player:getItems(nil, nil, nil, nil, true)
	local infos = {}

	for _, item in pairs(items) do
		local tier = item:getTier()
		local equipmentType = item:isWeapon() and "weapon" or item:isEquipment() and "armor"

		if tier > 0 and equipmentType and not item:isSoulbound() and item:getGrade() == ITEM_GRADE_FIRST and item:getTotalExperience() == 0 and item:getProfession() == ProfessionNone then
			local dawn_essence = self.itemTypeToDawnEssence[equipmentType] and self.itemTypeToDawnEssence[equipmentType][tier] or 0

			if item:isTwoHandedWeapon() then
				dawn_essence = dawn_essence * 2
			end

			if dawn_essence > 0 then
				table.insert(infos, {
					item = item,
					dawnEssence = dawn_essence
				})
			end
		end
	end

	return infos
end

function GearBreakdownShop:onOpenNpcTrade(data)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local itemsPanel = GearBreakdownShop.window:recursiveGetChildById("itemsPanel")

	GameNpc:setTopPanelOn(true)

	local bottomPanel = GearBreakdownShop.window:recursiveGetChildById("bottomPanel")

	bottomPanel:setChecked(false)
	bottomPanel:setOn(false)

	local itemQuality = GearBreakdownShop.window:recursiveGetChildById("itemQuality")

	itemQuality:setOn(false)
	itemsPanel:destroyChildren()

	local items = self:getBreakdownItems()

	for _, info in ipairs(items) do
		local widget = g_ui.createWidget("GearBreakdownShopItem", itemsPanel)

		widget.item:setItem(info.item)
		widget.name:setText(info.item:getName())
		widget.dawn_essence_price:setText(info.dawnEssence)

		function widget.onClick()
			if GearBreakdownShop.lastItem then
				GearBreakdownShop.lastItem:setOn(false)
			end

			local bottomPanel = GearBreakdownShop.window:recursiveGetChildById("bottomPanel")

			bottomPanel:setOn(true)
			widget:setOn(true)

			GearBreakdownShop.lastItem = widget

			GearBreakdownShop:onTradeItem(widget)
		end
	end

	GameNpc:setPanel("gear_breakdown_shop")
	self.window:show()
	self.window:raise()
	self.window:focus()
end

function GearBreakdownShop:onSearchFilter(widget)
	local text = widget:getText()

	widget.placeholder:setVisible(text:len() == 0)

	for rankId, itemWidget in ipairs(GearBreakdownShop.window.itemsPanel:getChildren()) do
		local name = itemWidget.name:getText():lower()
		local found = name:find(text:lower(), 1, true) ~= nil

		itemWidget:setVisible(found)

		itemWidget.hidden = not found
	end
end

function GearBreakdownShop.onDawnEssenceBalanceChange(amount)
	local bottomPanel = GearBreakdownShop.window:recursiveGetChildById("bottomPanel")
	local dawnEssence = bottomPanel.dawn_essence.dawn_essence_price

	dawnEssence:setText(amount)
end

function GearBreakdownShop.onClose()
	if GearBreakdownShop.lastItem then
		GearBreakdownShop.lastItem:setOn(false)
	end

	GearBreakdownShop.lastItem = nil

	local bottomPanel = GearBreakdownShop.window:recursiveGetChildById("bottomPanel")

	if bottomPanel:isOn() then
		bottomPanel:setOn(false)
	end

	local search = GearBreakdownShop.window:recursiveGetChildById("textEdit")

	search:setText("")
end

function GearBreakdownShop.refreshItemList(container, slot, item)
	if not GearBreakdownShop.window then
		return
	end

	local itemsPanel = GearBreakdownShop.window:recursiveGetChildById("itemsPanel")

	for _, itemWidget in ipairs(itemsPanel:getChildren()) do
		if itemWidget.item:getItem():getUUID() == item:getUUID() then
			itemWidget:destroy()
			GearBreakdownShop:trySelectFirstItem()

			return
		end
	end
end

function GearBreakdownShop.trySelectFirstItem()
	local itemsPanel = GearBreakdownShop.window:recursiveGetChildById("itemsPanel")
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
		local bottomPanel = GearBreakdownShop.window:recursiveGetChildById("bottomPanel")

		bottomPanel:setOn(false)
	end
end
