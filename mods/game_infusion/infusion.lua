-- chunkname: @/modules/game_infusion/infusion.lua

GameInfusion = {
	itemCount = 0,
	augmentingStonesAmount = 0,
	currentMode = "infusion",
	currentFilterType = "all",
	containers = {}
}
CONST_SE_AUGMENTING_FAIL = 2096430246
CONST_SE_AUGMENTING_SUCCESS = {
	2936557323,
	2936557323,
	2936557323,
	2936557320,
	2936557320,
	2936557320,
	2936557321,
	2936557321,
	2936557321,
	2936557326
}

function GameInfusion:loadConfig()
	local func, error = loadfile("config.lua")

	if not func then
		g_logger.fatal(error)

		return false
	end

	func()

	local env = getfenv(0)

	env.cfg = {}

	setmetatable(env.cfg, {
		__index = env
	})
	setfenv(func, env.cfg)

	return true
end

function GameInfusion:resetFilterPanel()
	for _, child in ipairs(self.inventory_filter_panel:getChildren()) do
		child:setOn(self.inventory_filter_panel:getChildIndex(child) == 1)
	end
end

function GameInfusion:applyInfusionFilter(id)
	for _, child in ipairs(self.inventory_items_panel.item_holder:getChildren()) do
		local item = child:getItem()

		if id == "all" then
			child:setEnabled(not self:isItemAddedToSlot(item))
		else
			local filter = cfg.filter[id]

			if item and filter then
				child:setEnabled(filter(item) and not self:isItemAddedToSlot(item))
			end
		end
	end

	for _, child in ipairs(self.inventory_filter_panel:getChildren()) do
		child:setOn(child:getId() == id)
	end

	self.currentFilterType = id
end

function GameInfusion:updateSelectedItems()
	for _, child in ipairs(self.equipped_items_panel.item_holder:getChildren()) do
		local item = child:getItem()

		child:setEnabled(not item or not self:isItemAddedToSlot(item))
	end

	for _, child in ipairs(self.inventory_items_panel.item_holder:getChildren()) do
		local item = child:getItem()

		child:setEnabled(not item or not self:isItemAddedToSlot(item))
	end

	self:updateInfuseButton()
end

function GameInfusion:updateCapacityLabel(text)
	self.inventory_items_panel.filter_panel:setText(text or "0 / 0")
end

function GameInfusion.onInventoryItemChange(player, currentItem, oldItem)
	local self = GameInfusion
	local player = player or g_game.getLocalPlayer()

	if not player then
		return
	end

	local panel = self.equipped_items_panel.item_holder
	local infusionItems = {}

	for _, slot in ipairs(equipSlots) do
		local name = equipSlotToName[slot]
		local itemWidget = panel:getChildById(name) or g_ui.createWidget("GameInfusionEquipmentPanelSlot", panel)

		itemWidget:setId(name)
		itemWidget.placeholder:setImageSource(string.format("/images/ui/windows/character/%s", itemWidget:getId()))

		local textureSize = {
			width = itemWidget.placeholder:getImageTextureWidth(),
			height = itemWidget.placeholder:getImageTextureHeight()
		}

		itemWidget.placeholder:setSize(textureSize)
		itemWidget:setItem(nil)
		itemWidget:show()

		local item = player:getInventoryItem(slot)

		if item and item:isInfusionMaterial() then
			table.insert(infusionItems, {
				item = item,
				slot = slot,
				type = item:getItemType()
			})
		end
	end

	for _, item in ipairs(infusionItems) do
		local id = equipSlotToName[item.slot]
		local itemWidget = id and panel:getChildById(id)

		if itemWidget then
			itemWidget.slot = item.slot

			itemWidget:setItem(item.item)
		end
	end

	if not oldItem then
		return
	end

	local itemUUID = oldItem:getUUID()
	local slotItem = self.item_slot.item:getItem()

	if slotItem and slotItem:getUUID() == itemUUID then
		if not currentItem or currentItem:getUUID() ~= itemUUID then
			self:removeItemFromSlot(self.item_slot.item)
		else
			self:onUpdateInfusionItem()
		end

		return
	end
end

function GameInfusion.onInventoryUpdateItem(container, slot, item, oldItem)
	local self = GameInfusion

	self:onContainerItemChange(container, slot, item, true)

	if oldItem then
		self:removeContainerItem(container, oldItem)
		self:addContainerItem(container, item, slot)
	else
		self:refreshContainerItem(container, item)
	end
end

function GameInfusion.onInventoryAddItem(container, slot, item)
	local self = GameInfusion

	self:addContainerItem(container, item, slot)
end

function GameInfusion.onInventoryRemoveItem(container, slot, item)
	local self = GameInfusion

	self:onContainerItemChange(container, slot, item)
	self:removeContainerItem(container, item)
end

function GameInfusion:init()
	self:loadConfig()
	g_ui.importStyle("styles/infusion.otui")
	g_ui.importStyle("styles/main.otui")

	self.window = g_ui.createWidget("GameInfusionWindow", modules.game_interface.getHUDPanel())

	self.window:hide()
	connect(self.window, {
		onVisibilityChange = function(self)
			local inventory = modules.game_inventory.GameInventory

			inventory:disableTab("quest", not self:isVisible())

			if self:isVisible() then
				inventory:selectTab(InventorySlotBack)
			end
		end
	})

	self.item_slot = self.window.content.right_panel.preview_panel.item
	self.preview_slot = self.window.content.right_panel.preview_panel.preview
	self.info_panel = self.window.content.right_panel.preview_panel.info
	self.slot_panel = self.window.content.right_panel.slot_panel
	self.augmenting_options_panel = self.window.content.right_panel.augmenting_options_panel
	self.bottom_panel = self.window.content.bottom_panel
	self.infuse_button = self.bottom_panel.infuse_button
	self.item_stats_panel = self.window.content.right_panel.item_stats_panel
	self.preview_stats_panel = self.window.content.right_panel.preview_stats_panel
	self.item_stats_background = self.window.content.right_panel.item_stats_background
	self.equipped_items_panel = self.window.content.left_panel.equipped_items_panel
	self.inventory_items_panel = self.window.content.left_panel.inventory_items_panel
	self.inventory_filter_panel = self.window.content.left_panel:recursiveGetChildById("filter_panel")

	self:resetFilterPanel()
	connect(Container, {
		onOpen = GameInfusion.onContainerOpen
	})
	connect(g_game, {
		onProtocolItem = GameInfusion.onUpdatePreviewItem,
		onGameEnd = GameInfusion.offline,
		onRefreshItems = GameInfusion.onInventoryRefreshItems,
		onUpdateItem = GameInfusion.onInventoryUpdateItem,
		onAddItem = GameInfusion.onInventoryAddItem,
		onRemoveItem = GameInfusion.onInventoryRemoveItem,
		onEquippedItems = GameInfusion.onInventoryItemChange
	})
	GameInfusion:setupDragAndDrop()
	ProtocolGame.registerExtendedOpcode(ExtendedIds.Infusion, GameInfusion.onExtendedOpcode, "game_infusion")
	ProtocolGame.registerExtendedOpcode(ExtendedIds.EquipmentAugment, GameInfusion.onExtendedOpcodeEquipmentAugment, "game_infusion")
end

function GameInfusion:terminate()
	self.window:destroy()
	self:clearContainers()
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.Infusion, "game_infusion")
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.EquipmentAugment, "game_infusion")
	disconnect(Container, {
		onOpen = GameInfusion.onContainerOpen
	})
	disconnect(g_game, {
		onProtocolItem = GameInfusion.onUpdatePreviewItem,
		onGameEnd = GameInfusion.offline,
		onRefreshItems = GameInfusion.onInventoryRefreshItems,
		onUpdateItem = GameInfusion.onInventoryUpdateItem,
		onAddItem = GameInfusion.onInventoryAddItem,
		onRemoveItem = GameInfusion.onInventoryRemoveItem,
		onEquippedItems = GameInfusion.onInventoryItemChange
	})

	GameInfusion = nil
end

function GameInfusion.isEnabled()
	return not g_game.isAetherRiftChannel() and not g_game.isGuildWarsChannel()
end

function GameInfusion.toggle(mouseClick)
	if GameChat:isActive() or (type(mouseClick) ~= "boolean" or not mouseClick) and IsTextEditActive() then
		return
	end

	if GameInfusion.window:isVisible() then
		GameInfusion.hide()
	else
		if g_game:isInCutsceneMode() or not GameInfusion.isEnabled() then
			return
		end

		GameInfusion:updateSelectedItems()
		GameInfusion.show()
	end
end

function GameInfusion.hide()
	GameInfusion.window:hide()
	GameInfusion:resetSlots()
end

function GameInfusion.show()
	GameInfusion.window:show()
	GameInfusion.window:raise()
end

function GameInfusion.isVisible()
	return GameInfusion.window:isVisible()
end

function GameInfusion.offline()
	GameInfusion:resetSlots()
	GameInfusion:clearContainers()
	GameInfusion.window:hide()
end

function GameInfusion:setupDragAndDrop()
	local function canDrop(widget, droppedWidget)
		local item_slot = self.item_slot.item:getItem()
		local preview_slot = self.preview_slot.item:getItem()

		if not droppedWidget or droppedWidget:getClassName() ~= "UIItem" then
			return false
		end

		local droppedItem = droppedWidget:getItem()

		if (item_slot or preview_slot) and item_slot == droppedItem or preview_slot == droppedItem then
			return false
		end

		if GameInfusion:isInfusionMode() then
			if not droppedItem:canInfuse() then
				return false
			end

			for _, child in ipairs(self.slot_panel:getChildren()) do
				local childItem = child.item:getItem()

				if childItem and childItem == droppedItem then
					return false
				end
			end
		elseif not droppedItem:canUpgradeAugment() then
			return false
		end

		return true
	end

	local function onSlotDrop(widget, droppedWidget)
		local droppedItem = droppedWidget:getItem()

		if not droppedItem then
			return false
		end

		local ret, msg = GameInfusion:isValidInfusionMaterial(droppedItem)

		if not ret then
			if msg then
				GameNotification:display(NOTIFICATION_ERROR, nil, msg)
			end

			return false
		end

		for _, child in ipairs(self.slot_panel:getChildren()) do
			local childItem = child.item:getItem()

			if childItem then
				if childItem:getUUID() == droppedItem:getUUID() then
					return false
				elseif not g_game.getLocalPlayer():getItemByUUID(childItem:getUUID()) then
					child.item:setItem(nil)
					child:setOn(false)
				end
			end
		end

		local widget = widget:isItem() and widget or widget.item

		if not widget then
			return
		end

		widget:setItem(droppedItem)

		local parent = widget:getParent()

		parent:setOn(true)
		self:requestUpgrade(true)

		if self:isInfusionMode() then
			signalcall(self.onSlotItemDrop, droppedItem)
		end

		self:updateSelectedItems()

		return true
	end

	local function onDrop(widget, droppedWidget, mousePos)
		if not canDrop(widget, droppedWidget) then
			return false
		end

		local droppedItem = droppedWidget:getItem()

		if droppedItem then
			widget.item:setItem(droppedItem)
		end

		if self:isInfusionMode() then
			self:checkResourceSlots()
		end

		self:updateStats(droppedItem, widget)
		self:updateTopPanel()
		self:requestUpgrade(true)

		if self:isInfusionMode() then
			signalcall(self.onItemDrop, droppedItem)
		end

		self:updateSelectedItems()
	end

	local function onMousePress(widget)
		GameInfusion:removeItemFromSlot(widget)
	end

	connect(self.item_slot, {
		onDrop = onDrop
	})
	connect(self.item_slot.item, {
		onMousePress = onMousePress
	})

	for _, child in ipairs(self.slot_panel:getChildren()) do
		connect(child, {
			onDrop = onSlotDrop,
			onMousePress = onMousePress
		})
		connect(child.item, {
			onDrop = onSlotDrop,
			onMousePress = onMousePress
		})
	end
end

function GameInfusion:isValidInfusionMaterial(item)
	if not item then
		return false
	end

	if not item:isInfusionMaterial() then
		return false
	end

	local sourceItem = self.item_slot.item:getItem()

	if not sourceItem then
		return true
	end

	if item:getUUID() == sourceItem:getUUID() then
		return false
	end

	if not item:isAugmented() then
		return true
	end

	local ret, msg = self:isSameAugmentType(sourceItem, item)

	if not ret then
		return false, msg
	end

	return true
end

function GameInfusion:isSameAugmentType(sourceItem, otherItem)
	if not sourceItem:isAugmentable() or not otherItem:isAugmentable() then
		return false, "Using Augmented Gear as Infusion material to Gear that can't be augmented is not allowed."
	end

	local sourceType = sourceItem:isTwoHandedWeapon() and "Two-Handed Weapon" or sourceItem:isOneHandedWeapon() and "One-Handed Weapon" or "Equipment"
	local otherType = otherItem:isTwoHandedWeapon() and "Two-Handed Weapon" or otherItem:isOneHandedWeapon() and "One-Handed Weapon" or "Equipment"

	if sourceType ~= otherType then
		return false, string.format("Using Augmented |%s| as Infusion material is only permitted on the same gear type.", otherType)
	end

	return true
end

function GameInfusion:checkResourceSlots()
	local item = self.item_slot.item:getItem()

	if not item then
		return
	end

	local removed = false

	for _, widget in ipairs(self.slot_panel:getChildren()) do
		local widgetItem = widget.item:getItem()

		if widgetItem and not self:isValidInfusionMaterial(widgetItem) then
			widget.item:setItem(nil)
			widget:setOn(false)
			self:updateStats(nil, widget)

			removed = true
		end
	end

	if removed then
		self:updateTopPanel()
		self:updateSelectedItems()
	end
end

function GameInfusion:removeItemFromSlot(widget)
	local widget = widget:isItem() and widget or widget.item

	if not widget then
		return
	end

	local item = widget:getItem()

	if item then
		widget:setItem(nil)

		local parent = widget:getParent()

		parent:setOn(false)
		self:updateStats(nil, parent)
		self:updateTopPanel()
		self:requestUpgrade(true)
		signalcall(self.onRemoveItem, widget)

		if parent:getParent() == self.slot_panel then
			self:updateStats(nil, self.preview_slot)
			self.preview_slot.item:setItem(nil)
			self:updateTopPanel({})
		end

		self:applyInfusionFilter(self.currentFilterType)
		self:updateSelectedItems()
	end
end

function GameInfusion.onExtendedOpcode(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.Infusion then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if not data or type(data) ~= "table" then
		return
	end

	if not GameInfusion:isInfusionMode() then
		return
	end

	if data.success == false then
		GameInfusion:updateTopPanel()
	end

	if data.success == true then
		for _, container in pairs(g_game.getContainers()) do
			if container:getType() == CONTAINER_TYPE_INVENTORY then
				g_game.refreshContainer(container)
			end
		end

		GameInfusion:updateSlots()
		GameInfusion:updateTopPanel({})
	elseif data.action == "preview" then
		GameInfusion.awaitingUUID = data.preview_uuid

		if data.resources then
			GameInfusion:updateSlots(data.resources)
			GameInfusion:updateTopPanel(data.resources)
		end
	end
end

function GameInfusion.onExtendedOpcodeEquipmentAugment(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.EquipmentAugment then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if not data or type(data) ~= "table" then
		return
	end

	if not GameInfusion:isAugmentingMode() then
		return
	end

	if data.action == "augment_preview" then
		GameInfusion.awaitingUUID = data.preview_uuid

		if data.costs then
			GameInfusion:updateAugmentCostsInfo(data.costs)
		end
	elseif data.action == "augment_upgrade" then
		GameInfusion:onAugmentUpgrade(data.success, data.augmentLevel)
	elseif data.action == "reset_augment" then
		GameInfusion.item_slot.item:setItem(nil)
		GameInfusion:updateTopPanel()
		GameInfusion:resetAugmentCostsInfo()
	end
end

function GameInfusion.sendOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.Infusion, g_game.serializeTable(data))
	end
end

function GameInfusion.sendOpcodeEquipmentAugment(data)
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.EquipmentAugment, g_game.serializeTable(data))
	end
end

function GameInfusion:requestUpgrade(preview)
	if self:isInfusionMode() then
		self:requestInfusion(preview)
	else
		self:requestAugmenting(preview)
	end
end

function GameInfusion:requestInfusion(preview, ignoreResourceCheck)
	if self.confirmation_box then
		return
	end

	local item = self.item_slot.item:getItem()

	if not item then
		self:updateInfuseButton()

		return
	end

	if self.confirmation_box then
		self.confirmation_box:destroy()

		self.confirmation_box = nil
	end

	local isSoulbound = item:isSoulbound()
	local usingInfusedResource = false
	local usingBondedResource = false
	local usingBondedInfusion = false
	local usingAugmentedResource = false
	local usingWarforgedResource = false
	local resources = {}

	for _, child in ipairs(self.slot_panel:getChildren()) do
		local childItem = child.item:getItem()

		if childItem then
			table.insert(resources, {
				uuid = childItem:getUUID(),
				count = childItem:getCount(),
				slot = child:getId()
			})

			if not usingInfusedResource and childItem:getTotalExperience() > 0 and not childItem:hasBondedExperience() then
				usingInfusedResource = true
			end

			if not usingBondedInfusion and PrepaidInfusionsIds[childItem:getId()] then
				usingBondedInfusion = true
			end

			if not usingBondedResource and childItem:hasBondedExperience() then
				usingBondedResource = true
			end

			if not usingAugmentedResource and childItem:isAugmented() then
				usingAugmentedResource = true
			end

			if not usingWarforgedResource and childItem:isWarforged() then
				usingWarforgedResource = true
			end
		end
	end

	if #resources == 0 then
		self:updateInfuseButton()

		return
	end

	local function infuse()
		if self.confirmation_box then
			self.confirmation_box:destroy()

			self.confirmation_box = nil
		end

		GameInfusion.sendOpcode({
			action = preview and "preview" or "infuse",
			itemSource = item:getUUID(),
			resources = resources
		})
		self:updateInfuseButton()
	end

	local function cancel()
		if self.confirmation_box then
			self.confirmation_box:destroy()

			self.confirmation_box = nil
		end

		self:updateInfuseButton()
	end

	if not preview and not ignoreResourceCheck and (not isSoulbound and (usingBondedInfusion or usingBondedResource) or usingInfusedResource or usingAugmentedResource or usingWarforgedResource) then
		local title = "Infusion Confirmation"
		local msg = tr("Special Material Used:")

		if usingAugmentedResource then
			msg = msg .. "\n" .. tr("-Augmented Gear")
		end

		if usingInfusedResource then
			msg = msg .. "\n" .. tr("-Infused Gear")
		end

		if usingBondedResource then
			msg = msg .. "\n" .. tr("-Bonded Gear")
		end

		if usingBondedInfusion then
			msg = msg .. "\n" .. tr("-Bonded Infusions")
		end

		if usingWarforgedResource then
			msg = msg .. "\n" .. tr("-Warforged Gear")
		end

		if usingBondedResource or usingBondedInfusion or usingAugmentedResource or usingWarforgedResource and not item:isWarforged() then
			msg = msg .. "\n\n" .. tr("Consequences:")

			if not isSoulbound and (usingBondedResource or usingBondedInfusion or usingAugmentedResource) then
				msg = msg .. "\n" .. tr("-Soulbound Gear Status Applied")
			end

			if usingAugmentedResource then
				msg = msg .. "\n" .. tr("-Only Highest Augment Level is Applied")
			end

			if usingBondedResource or usingBondedInfusion then
				msg = msg .. "\n" .. tr("-Bonded Gear Status Applied")
			end

			if usingWarforgedResource and not item:isWarforged() then
				msg = msg .. "\n" .. tr("-Warforged Status is not Transferred")
			end
		end

		self.confirmation_box = displayConfirmCheckBox(tr(title), msg, {
			{
				text = tr("Yes"),
				callback = infuse
			},
			{
				text = tr("No"),
				callback = cancel
			},
			anchor = AnchorHorizontalCenter
		}, infuse, cancel, nil, modules.game_interface.getRootPanel())
	else
		infuse()
	end

	self:updateInfuseButton()
end

function GameInfusion:updateTopPanel(data)
	if self.confirmation_box then
		self.confirmation_box:destroy()

		self.confirmation_box = nil
	end

	local panel = self.info_panel
	local item = self.item_slot.item:getItem()

	if self:isInfusionMode() then
		if item then
			local exp = item:getExperience()
			local requiredExp = item:getRequiredExperience()

			self.item_slot.progress:setPercentage(exp / requiredExp * 100)
		else
			self.item_slot.progress:setPercentage(0)
		end

		if data then
			local xpValue = data and data.totalExp or 0
			local silverValue = data and data.totalCost or 0

			self.bottom_panel.values.xp_button:setText(string.format("%s%s", xpValue > 0 and "+" or "", xpValue))
			self.bottom_panel.values.silver_button:setText(string.format("%s%s", silverValue > 0 and "-" or "", FormatCommaNumber(silverValue)))
			panel.arrow:setOn(self.bottom_panel.values.xp_button:getText() ~= "0")
		else
			local preview = self.preview_slot.item:getItem()

			if preview then
				local exp = preview:getExperience()
				local requiredExp = preview:getRequiredExperience()

				self.preview_slot.progress:setPercentage(exp / requiredExp * 100)
			else
				self.preview_slot.progress:setPercentage(0)
			end
		end
	elseif self:isAugmentingMode() then
		if item then
			panel.arrow:setOn(true)
		else
			panel.arrow:setOn(false)
			self:resetAugmentCostsInfo()
		end
	end

	self:updateInfuseButton()
end

function GameInfusion:updateSlots(data)
	local player = g_game.getLocalPlayer()

	for _, child in ipairs(self.slot_panel:getChildren()) do
		child.item:setItem(nil)
		child:setOn(false)
	end

	if not data then
		return
	end

	for _, resource in ipairs(data) do
		local slot = self.slot_panel:getChildById(resource.slot)

		if slot then
			slot.item:setItem(player:getItemByUUID(resource.uuid))
			slot:setOn(true)
			slot.exp:setText(resource.exp)
			slot.cost:setText(string.format("%s%s", resource.cost > 0 and "-" or "", FormatCommaNumber(resource.cost or 0)))
		end
	end
end

function GameInfusion:updateStats(item, widget)
	local height = 20
	local background = self.item_stats_background
	local panel = widget == self.item_slot and self.item_stats_panel or widget == self.preview_slot and self.preview_stats_panel or nil

	if panel then
		panel.itemStats = {}

		panel:setVisible(item ~= nil)
		panel:destroyChildren()

		if item then
			local function getDiffValue(stat1, stat2)
				local diffValue = 0

				if panel == self.preview_stats_panel then
					diffValue = math.max(0, stat2 - (self.item_stats_panel.itemStats[stat1] or 0))
				else
					panel.itemStats[stat1] = stat2
				end

				return diffValue
			end

			local tier = item:getTier()
			local grade = item:getGrade()
			local itemTypeRaw = item:getItemType()
			local isFishingRod = itemTypeRaw == "fishing rod"
			local isFishingHook = itemTypeRaw == "fishing hook"
			local fishingDurability = isFishingRod and FishingStats.durabilityTable[tier][grade + 1] or 0
			local baseAttributes

			if self.currentMode == "infusion" then
				baseAttributes = {
					{
						"Attack",
						item:getAttack(),
						"#5DA4FB"
					},
					{
						"Defense",
						item:getDefense(),
						"#5DA4FB"
					},
					{
						"Healing Power",
						item:getHealing(),
						"#5DA4FB"
					},
					{
						"Labor",
						item:getLabor(),
						"#FFA851"
					},
					{
						"Durability",
						fishingDurability,
						"#FFA851"
					}
				}
			else
				baseAttributes = {
					{
						"Attack",
						item:getAttack(),
						"#5DA4FB"
					},
					{
						"Defense",
						item:getDefense(),
						"#5DA4FB"
					}
				}
			end

			local showDiff = panel == self.preview_stats_panel

			for _, stat in ipairs(baseAttributes) do
				if stat[2] > 0 then
					local diffValue = getDiffValue(stat[1], stat[2])
					local child = g_ui.createWidget("GameInfusionStatsPanelItem", panel)

					child:setColoredText(GetHighlightedText(string.format("%s [%i] {%s, %s}", stat[1], stat[2], diffValue > 0 and string.format("+%d", diffValue) or "", stat[3])))
					child:setImageColor(stat[3])

					height = height + panel:getLayout():getSpacing() + child:getHeight()
				end
			end

			if self.currentMode == "infusion" then
				for _, stat in ipairs(item:getPrimaryStats()) do
					local diffValue = getDiffValue(stats[stat[1]], stat[2])
					local child = g_ui.createWidget("GameInfusionStatsPanelItem", panel)

					child:setColoredText(GetHighlightedText(string.format("%s [%i] {%s, #77D463}", stats[stat[1]], stat[2], diffValue > 0 and string.format("+%d", diffValue) or "")))

					height = height + panel:getLayout():getSpacing() + child:getHeight()
				end

				for _, stat in ipairs(item:getCombinedSecondaryStats()) do
					local diffValue = getDiffValue(stats[stat[1]], stat[2])
					local child = g_ui.createWidget("GameInfusionStatsPanelItem", panel)

					child:setColoredText(GetHighlightedText(string.format("%s [%i] {%s, #77D463}", stats[stat[1]], stat[2], diffValue > 0 and string.format("+%d", diffValue) or "")))

					height = height + panel:getLayout():getSpacing() + child:getHeight()
				end

				for _, stat in ipairs(item:getCraftingStats()) do
					local diffValue = getDiffValue(stats[stat[1]], stat[2])
					local child = g_ui.createWidget("GameInfusionStatsPanelItem", panel)

					child:setColoredText(GetHighlightedText(string.format("%s [%i] {%s, #77D463}", craftingStats[stat[1]], stat[2], diffValue > 0 and string.format("+%d", diffValue) or "")))

					height = height + panel:getLayout():getSpacing() + child:getHeight()
				end

				local fishingAbilityBonus = (isFishingHook or isFishingRod) and FishingStats.abilityBonusTable[tier][grade + 1] or 0

				if fishingAbilityBonus > 0 then
					local diffValue = getDiffValue("Ability Bonus", fishingAbilityBonus)
					local child = g_ui.createWidget("GameInfusionStatsPanelItem", panel)

					child:setColoredText(GetHighlightedText(string.format("%s [%i] {%s, #77D463}", "Ability Bonus", fishingAbilityBonus, diffValue > 0 and string.format("+%d", diffValue) or "")))

					height = height + panel:getLayout():getSpacing() + child:getHeight()
				end
			end

			if table.empty(panel:getChildren()) then
				local child = g_ui.createWidget("GameInfusionStatsPanelItem", panel)

				child:setText("No attributes")
				child:disable()
			end

			background:setHeight(height)
		end
	end

	self.item_stats_background:setOn(self.item_stats_panel:isVisible() or self.preview_stats_panel:isVisible())

	if widget == self.item_slot then
		self.preview_slot.item:setItem(nil)
		self.preview_stats_panel:setOn(false)
		self:updateStats(nil, self.preview_slot)
	end
end

function GameInfusion:getContainerData(cid)
	return self.containers[cid]
end

function GameInfusion:getOrCreateContainerData(cid, container, reset)
	local containerData = self.containers[cid]

	if not containerData or reset then
		containerData = {
			augmentingStonesAmount = 0,
			container = not reset and container or g_game.getContainer(cid),
			items = {}
		}
		self.containers[cid] = containerData
	end

	return containerData
end

function GameInfusion:clearContainers()
	for _, containerData in pairs(self.containers) do
		for _, item in pairs(containerData.items) do
			if item and item.widget then
				item.widget:destroy()

				item.widget = nil
			end
		end
	end

	self.containers = {}
end

function GameInfusion.onInventoryRefreshItems(container)
	local self = GameInfusion

	self:refreshContainer(container)
end

function GameInfusion.refreshContainers()
	local self = GameInfusion

	self.itemCount = 0
	self.augmentingStonesAmount = 0

	for _, containerData in pairs(self.containers) do
		self:refreshContainer(containerData.container, containerData)
	end
end

function GameInfusion:refreshContainer(container, containerData)
	containerData = containerData or self:getContainerData(container:getId())

	if containerData then
		for _, item in pairs(containerData.items) do
			if item and item.widget then
				item.widget:destroy()

				item.widget = nil
				self.itemCount = math.max(0, self.itemCount - 1)
			end
		end

		containerData.items = {}
		self.augmentingStonesAmount = math.max(0, self.augmentingStonesAmount - containerData.augmentingStonesAmount)
		containerData.augmentingStonesAmount = 0
	end

	containerData = self:getOrCreateContainerData(container:getId(), nil, true)
	container = containerData.container

	for slot = 0, math.max(container:getSize(), container:getCapacity()) - 1 do
		local item = container:getInventoryItem(slot)

		if item then
			self:addContainerItem(container, item, slot, containerData)
		end
	end
end

function GameInfusion:removeContainerItem(container, item, dontUpdateDisplay, containerData)
	if not item then
		print("ERROR: GameInfusion.removeContainerItem: item is nil")

		return
	end

	containerData = containerData or self:getOrCreateContainerData(container:getId(), container)

	local items = containerData.items
	local itemData = items[item:getUUID()]

	if itemData then
		if itemData.widget then
			itemData.widget:destroy()

			itemData.widget = nil
		end

		items[item:getUUID()] = nil
		self.itemCount = self.itemCount - 1

		if item:isAugmentingMaterial() then
			containerData.augmentingStonesAmount = containerData.augmentingStonesAmount - item:getCount()
			self.augmentingStonesAmount = self.augmentingStonesAmount - item:getCount()
		end

		if not dontUpdateDisplay then
			self:updateCapacityLabel(string.format("%d / %d", self.itemCount, self.itemCount))
			self:applyInfusionFilter(self.currentFilterType)
			self:updateSelectedItems()
			self:updateAugmentCosts()
		end

		return true
	end
end

function GameInfusion:refreshContainerItem(container, item, containerData)
	if not item then
		print("ERROR: GameInfusion.refreshContainerItem: item is nil")

		return
	end

	containerData = containerData or self:getOrCreateContainerData(container:getId(), container)

	local items = containerData.items
	local itemData = items[item:getUUID()]

	if itemData then
		self:addContainerItem(container, item, itemData.slot, containerData)
	end
end

function GameInfusion:addContainerItem(container, item, slot, containerData)
	if not item then
		print("ERROR: GameInfusion.addContainerItem: item is nil")

		return
	end

	containerData = containerData or self:getOrCreateContainerData(container:getId(), container)

	local items = containerData.items
	local exists = items[item:getUUID()] and not self:removeContainerItem(container, item, true, containerData)

	if exists then
		print("ERROR: GameInfusion.addContainerItem: item already exists")

		return
	end

	if self:isInfusionMode() and item:isInfusionMaterial() or self:isAugmentingMode() and (item:canUpgradeAugment() or item:isAugmentingMaterial()) then
		local itemWidget = g_ui.createWidget("GameInfusionInventoryItem", self.inventory_items_panel.item_holder)

		itemWidget:show()
		itemWidget:setItem(item)

		itemWidget.slot = slot

		if item:isAugmentingMaterial() then
			containerData.augmentingStonesAmount = containerData.augmentingStonesAmount + item:getCount()
			self.augmentingStonesAmount = self.augmentingStonesAmount + item:getCount()
		end

		items[item:getUUID()] = {
			item = item,
			widget = itemWidget,
			slot = slot,
			type = item:getItemType()
		}
		self.itemCount = self.itemCount + 1

		self:updateCapacityLabel(string.format("%d / %d", self.itemCount, self.itemCount))
	end

	self:applyInfusionFilter(self.currentFilterType)
	self:updateSelectedItems()
	self:updateAugmentCosts()
end

function GameInfusion.onContainerOpen(container)
	local self = GameInfusion

	if container:getType() == CONTAINER_TYPE_INVENTORY then
		self.onUpdateInfusionItem(container)
		self:refreshContainer(container)
	end
end

function GameInfusion.onUpdateInfusionItem(container)
	if not GameInfusion.window:isVisible() then
		return
	end

	local selectedItem = GameInfusion.item_slot.item:getItem()

	if not selectedItem then
		return
	end

	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local item = player:getItemByUUID(selectedItem:getUUID())

	if item then
		GameInfusion.item_slot.item:setItem(item)
		GameInfusion:updateStats(item, GameInfusion.item_slot)
		GameInfusion:requestUpgrade(true)
		GameInfusion:updateTopPanel()
	end
end

function GameInfusion.onUpdatePreviewItem(item)
	if not item or item:getUUID() ~= GameInfusion.awaitingUUID then
		return
	end

	GameInfusion.preview_slot.item:setItem(item)
	GameInfusion:updateStats(item, GameInfusion.preview_slot)
	GameInfusion:updateTopPanel()
end

function GameInfusion.onContainerRemoveItem(container, slot, item)
	local self = GameInfusion

	self:onContainerItemChange(container, slot, item)
	self:removeContainerItem(container, item)
end

function GameInfusion.onContainerUpdateItem(container, slot, item, oldItem)
	local self = GameInfusion

	self:onContainerItemChange(container, slot, item, true)

	if oldItem then
		self:removeContainerItem(container, oldItem)
		self:addContainerItem(container, item, slot)
	else
		self:refreshContainerItem(container, item)
	end
end

function GameInfusion:onContainerItemChange(container, slot, item, ignoreMainSlot)
	if not GameInfusion.isVisible() then
		return
	end

	local itemUUID = item:getUUID()

	if not ignoreMainSlot then
		local slotItem = self.item_slot.item:getItem(item)

		if slotItem and slotItem:getUUID() == itemUUID then
			self:removeItemFromSlot(self.item_slot.item)

			return
		end
	end

	for _, child in ipairs(self.slot_panel:getChildren()) do
		local slotItem = child.item and child.item:getItem()

		if slotItem and slotItem:getUUID() == itemUUID then
			self:removeItemFromSlot(child.item)

			return
		end
	end
end

function GameInfusion:resetSlots()
	for _, child in ipairs(self.slot_panel:getChildren()) do
		child.item:setItem(nil)
		child:setOn(false)
	end

	self.item_slot.item:setItem(nil)
	self.item_slot:setOn(false)
	self:updateStats(nil, self.item_slot)
	self:updateTopPanel()
	self.preview_slot.item:setItem(nil)
	self:updateTopPanel({})
	self:updateSelectedItems()
	self:resetAugmentCostsInfo()
	self:updateInfuseButton()
end

function GameInfusion:getFirstEmptySlot()
	local slot = self.item_slot.item

	if not slot:getItem() then
		return slot:getParent()
	end

	for _, child in ipairs(self.slot_panel:getChildren()) do
		slot = child.item

		if not slot:getItem() then
			return slot
		end
	end

	return nil
end

function GameInfusion:isItemAddedToSlot(item)
	if not item then
		return false
	end

	local slotItem = self.item_slot.item:getItem()

	if slotItem and slotItem:getUUID() == item:getUUID() then
		return true
	end

	for _, child in ipairs(self.slot_panel:getChildren()) do
		local childItem = child.item:getItem()

		if childItem and childItem:getUUID() == item:getUUID() then
			return true
		end
	end

	return false
end

function GameInfusion:updateInfuseButton()
	if not self.item_slot.item:getItem() then
		self.infuse_button:setEnabled(false)

		return
	end

	if self.confirmation_box then
		self.infuse_button:setEnabled(false)

		return
	end

	if self:isInfusionMode() then
		for _, child in ipairs(self.slot_panel:getChildren()) do
			if child.item:getItem() ~= nil then
				self.infuse_button:setEnabled(true)

				return
			end
		end

		self.infuse_button:setEnabled(false)
	elseif self:isAugmentingMode() then
		for _, option in ipairs(self.augmenting_options_panel:getChildren()) do
			if option:isOn() then
				self.infuse_button:setEnabled(true)

				return
			end
		end

		self.infuse_button:setEnabled(false)
	end
end

function GameInfusion:onChangeMode()
	local modeSelectionPanel = self.window:recursiveGetChildById("mode_selection_panel")

	if not modeSelectionPanel then
		return
	end

	local mode = modeSelectionPanel.left_option:isOn() and "infusion" or "augmenting_stone"

	self:setMode(mode, true)
end

function GameInfusion:isInfusionMode()
	return self.currentMode == "infusion"
end

function GameInfusion:isAugmentingMode()
	return self.currentMode == "augmenting_stone"
end

function GameInfusion:setMode(mode, fromClick)
	if self.currentMode == mode then
		return
	end

	self.currentMode = mode

	if not fromClick then
		local modeSelectionPanel = self.window:recursiveGetChildById("mode_selection_panel")

		if modeSelectionPanel then
			modeSelectionPanel.left_option:setOn(self:isInfusionMode())
			modeSelectionPanel.right_option:setOn(not self:isInfusionMode())
		end
	end

	self:resetSlots()

	if self:isInfusionMode() then
		self.augmenting_options_panel:hide()
		self.slot_panel:show()
		self.bottom_panel.values.xp_button:show()
		self.item_slot.progress_bg:show()
		self.item_slot.progress:show()
		self.preview_slot.progress_bg:show()
		self.preview_slot.progress:show()
	else
		self.slot_panel:hide()
		self.augmenting_options_panel:show()
		self.bottom_panel.values.xp_button:hide()
		self.item_slot.progress_bg:hide()
		self.item_slot.progress:hide()
		self.preview_slot.progress_bg:hide()
		self.preview_slot.progress:hide()
	end

	if self.confirmation_box then
		self.confirmation_box:destroy()

		self.confirmation_box = nil
	end

	self:refreshContainers()
	self:updateInfuseButton()
end

function GameInfusion:requestAugmenting(preview)
	local item = self.item_slot.item:getItem()

	if not item then
		self:updateInfuseButton()

		return
	end

	if self.confirmation_box then
		self.confirmation_box:destroy()

		self.confirmation_box = nil
	end

	local costData = self:getAugmentSelectedCostData()

	if not preview and not costData then
		return
	end

	local function augmentUpgrade()
		if self.confirmation_box then
			self.confirmation_box:destroy()

			self.confirmation_box = nil
		end

		if preview then
			GameInfusion.sendOpcodeEquipmentAugment({
				action = "augment_preview",
				itemSource = item:getUUID()
			})
		else
			GameInfusion.sendOpcodeEquipmentAugment({
				action = "augment_upgrade",
				itemSource = item:getUUID(),
				option = costData.option
			})
		end

		self:updateInfuseButton()
	end

	local function cancel()
		if self.confirmation_box then
			self.confirmation_box:destroy()

			self.confirmation_box = nil
		end

		self:updateInfuseButton()
	end

	if not preview then
		local msg = ""

		if costData.option == "guaranteed" then
			msg = tr(string.format("Are you sure you want to spend |%d| Augmenting Stones and |%d| Silver to guarantee your upgrade? This process will make the item Soulbound.", costData.stones, costData.silver))
		else
			msg = tr(string.format("Are you sure you want to spend |%d| Augmenting Stones and |%d| Silver for a chance to upgrade? This process will make the item Soulbound.", costData.stones, costData.silver))
		end

		self.confirmation_box = displayConfirmCheckBox(tr("Confirmation"), msg, {
			{
				text = tr("Yes"),
				callback = augmentUpgrade
			},
			{
				text = tr("No"),
				callback = cancel
			},
			anchor = AnchorHorizontalCenter
		}, augmentUpgrade, cancel, nil, modules.game_interface.getRootPanel())
	else
		augmentUpgrade()
	end

	self:updateInfuseButton()
end

function GameInfusion:onAugmentUpgrade(success, augmentLevel)
	if not success then
		g_sound.play(CONST_SE_AUGMENTING_FAIL)

		return
	end

	self:onUpdateInfusionItem()

	local successSound = CONST_SE_AUGMENTING_SUCCESS[augmentLevel]

	if successSound then
		g_sound.play(successSound)
	end
end

function GameInfusion:resetAugmentCostsInfo()
	local single_option = self.augmenting_options_panel.single_option

	single_option:show()
	single_option:setOn(false)

	single_option.costData = nil

	local guaranteed_option = self.augmenting_options_panel.guaranteed_option

	guaranteed_option:show()
	guaranteed_option:setOn(false)

	guaranteed_option.costData = nil

	self:updateAugmentCosts()
end

function GameInfusion:updateAugmentCostsInfo(costs)
	if self.confirmation_box then
		self.confirmation_box:destroy()

		self.confirmation_box = nil
	end

	local single_option = self.augmenting_options_panel.single_option

	if not costs.single then
		single_option:hide()

		single_option.costData = nil
	else
		single_option:show()

		single_option.costData = costs.single
		single_option.costData.option = "single"
	end

	local guaranteed_option = self.augmenting_options_panel.guaranteed_option

	if not costs.guaranteed then
		guaranteed_option:hide()

		guaranteed_option.costData = nil
	else
		guaranteed_option:show()

		guaranteed_option.costData = costs.guaranteed
		guaranteed_option.costData.option = "guaranteed"
	end

	self:updateAugmentCosts()
end

function GameInfusion:updateAugmentCosts()
	local stonesAmount = self.augmentingStonesAmount
	local single_option = self.augmenting_options_panel.single_option
	local singleCostData = single_option.costData

	if singleCostData then
		single_option.amounts:setText(string.format("%d/%d", stonesAmount, singleCostData.stones))
		single_option.description:setText(string.format("%d%% %s", singleCostData.chance, tr("chance to success")))
		single_option.cost:setText(string.format("-%s", FormatCommaNumber(singleCostData.silver)))

		if stonesAmount < singleCostData.stones then
			if single_option:isOn() and self.confirmation_box then
				self.confirmation_box:destroy()

				self.confirmation_box = nil
			end

			single_option:setEnabled(false)
		else
			single_option:setEnabled(true)
		end
	else
		single_option.amounts:setText(string.format("%d/X", stonesAmount))
		single_option.description:setText(tr("|X%%| chance to success"))
		single_option.cost:setText("-")
		single_option:setEnabled(false)
	end

	local guaranteed_option = self.augmenting_options_panel.guaranteed_option
	local guaranteedCostData = guaranteed_option.costData

	if guaranteedCostData then
		guaranteed_option.amounts:setText(string.format("%d/%d", stonesAmount, guaranteedCostData.stones))
		guaranteed_option.cost:setText(string.format("-%s", FormatCommaNumber(guaranteedCostData.silver)))

		if stonesAmount < guaranteedCostData.stones then
			if guaranteed_option:isOn() and self.confirmation_box then
				self.confirmation_box:destroy()

				self.confirmation_box = nil
			end

			guaranteed_option:setEnabled(false)
		else
			guaranteed_option:setEnabled(true)
		end
	else
		guaranteed_option.amounts:setText(string.format("%d/X", stonesAmount))
		guaranteed_option.cost:setText("-")
		guaranteed_option:setEnabled(false)
	end

	if not self:isAugmentingMode() then
		return
	end

	local selectedCostData = self:getAugmentSelectedCostData()

	if not selectedCostData then
		self.bottom_panel.values.silver_button:setText("0")
	else
		self.bottom_panel.values.silver_button:setText(string.format("-%s", FormatCommaNumber(selectedCostData.silver)))
	end

	self:updateInfuseButton()
end

function GameInfusion:getAugmentSelectedCostData()
	local single_option = self.augmenting_options_panel.single_option
	local guaranteed_option = self.augmenting_options_panel.guaranteed_option

	if single_option:isOn() then
		return single_option.costData
	end

	if guaranteed_option:isOn() then
		return guaranteed_option.costData
	end

	return nil
end

function GameInfusion:selectAugmentOption(widget)
	local single_option = self.augmenting_options_panel.single_option
	local guaranteed_option = self.augmenting_options_panel.guaranteed_option

	widget = widget or single_option

	if widget:isOn() then
		return
	end

	if widget == single_option then
		single_option:setOn(true)
		guaranteed_option:setOn(false)
	else
		single_option:setOn(false)
		guaranteed_option:setOn(true)
	end

	if self.confirmation_box then
		self.confirmation_box:destroy()

		self.confirmation_box = nil
	end

	self:updateAugmentCosts()
	self:updateInfuseButton()
end
