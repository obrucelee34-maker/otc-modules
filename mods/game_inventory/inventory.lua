-- chunkname: @/modules/game_inventory/inventory.lua

GameInventory = {
	currentFilterType = "all",
	inventoryInitialSize = 60,
	maxSlots = 180,
	slotsPerRow = 6,
	tabs = {},
	containers = {},
	pendingContainers = {},
	types = {
		[CONTAINER_TYPE_INVENTORY] = true,
		[CONTAINER_TYPE_QUEST] = true
	}
}

function GameInventory:loadConfig()
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

function GameInventory:init()
	self:loadConfig()
	g_ui.importStyle("styles/inventory.otui")
	g_ui.importStyle("styles/main.otui")

	self.window = g_ui.createWidget("GameInventoryWindow", modules.game_interface.getHUDPanel())

	self.window:hide()

	self.window.uiopensoundid = UI_INVENTORY_WINDOW_OPEN
	self.window.uiclosesoundid = UI_INVENTORY_WINDOW_CLOSE
	self.holderPanel = g_ui.createWidget("GameInventoryPanelHolder", self.window.content)
	self.unlockPanel = g_ui.createWidget("GameInventoryUnlockPanel", self.holderPanel)

	self.unlockPanel:hide()

	self.filterPanel = self.window:recursiveGetChildById("filter_panel")

	self:resetFilterPanel()

	self.bottomPanel = self.window:recursiveGetChildById("bottom_panel")
	self.mainTab = self.window.content.selection_panel.content.tab_bar:addTab("Main", g_ui.createWidget("GameInventoryPanel", self.holderPanel), nil, nil, nil)
	self.mainTab.id = InventorySlotBack
	self.mainTab.uiclicksoundid = UI_INVENTORY_NORMAL_BUTTON
	self.mainTab.extraWidth = 15

	self.mainTab:onTextChange(self.mainTab:getText())

	self.questTab = self.window.content.selection_panel.content.tab_bar:addTab("Quest", g_ui.createWidget("GameInventoryPanel", self.holderPanel), nil, nil, nil)
	self.questTab.id = InventorySlotQuestPouch
	self.questTab.uiclicksoundid = UI_INVENTORY_QUEST_BUTTON
	self.questTab.extraWidth = 15

	self.questTab:onTextChange(self.questTab:getText())

	self.addNewTab = self.window.content.selection_panel.content.tab_bar:addActionTab("", "GameInventoryTabBarAddButton", nil, nil, {
		onClick = function(widget)
			self:showAddNewTabDialog()
		end
	})

	ProtocolGame.registerExtendedOpcode(ExtendedIds.InventoryTabs, GameInventory.onExtendedOpcode, "game_inventory")

	self.mainPanel = self.mainTab.tabPanel
	self.questPanel = self.questTab.tabPanel
	self.purchaseWindow = g_ui.createWidget("GamePurchaseBackpackModal", modules.game_interface.getHUDPanel())

	function self.purchaseWindow.onEscape(widget)
		self.purchaseWindow:hide()
	end

	self.purchaseWindow:hide()

	self.editWindow = g_ui.createWidget("GameBackpackEditModal", modules.game_interface.getHUDPanel())

	function self.editWindow.onEnter(widget)
		self:createOrSaveTab()
	end

	function self.editWindow.onEscape(widget)
		self.editWindow:hide()
	end

	function self.editWindow.onVisibilityChange(widget, visible)
		if not visible then
			self.editWindow.content.editBackpackContent.nameTextEdit:setText("")
			self.editWindow.content.editBackpackContent.nameTextEdit:setTextPreview("")
			self.editWindow.content.editBackpackContent.categoryComboBox:clearSelectedOptions()
		end
	end

	self.editWindow:hide()

	local categoryComboBox = self.editWindow.content.editBackpackContent.categoryComboBox

	for _, category in ipairs(cfg.inventory.backpackCategoryNames) do
		local id = cfg.inventory.backpackCategoryIds[category]

		categoryComboBox:addOption(tr(category), {
			id = id
		})
	end

	connect(Container, {
		onOpen = GameInventory.onContainerOpen,
		onRemoveItem = GameInventory.onContainerRemoveItem,
		onUpdateItem = GameInventory.onContainerUpdateItem,
		onAddItem = GameInventory.onContainerAddItem
	})
	connect(g_game, {
		onGameStart = GameInventory.onGameStart,
		onGameEnd = GameInventory.onGameEnd,
		onCoinBalance = GameInventory.onBalanceChange,
		onGoldChange = GameInventory.onGoldChange
	})
	connect(LocalPlayer, {
		onLevelChange = GameInventory.onLevelChange,
		onActiveFishingBaitChange = GameInventory.onActiveFishingBaitChange
	})
	connect(ProtocolGame, {
		onSendExtendedOpcode = GameInventory.onSendExtendedOpcode
	})

	if g_game.isOnline() then
		self.onGameStart()
	end

	if not g_game.isRavenQuest() then
		self.bottomPanel.currency.gold:destroy()
	end
end

function GameInventory:terminate()
	self.window:destroy()

	if self.purchaseWindow then
		self.purchaseWindow:destroy()
	end

	if self.editWindow then
		self.editWindow:destroy()
	end

	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.InventoryTabs, "game_inventory")
	disconnect(Container, {
		onOpen = GameInventory.onContainerOpen,
		onRemoveItem = GameInventory.onContainerRemoveItem,
		onUpdateItem = GameInventory.onContainerUpdateItem,
		onAddItem = GameInventory.onContainerAddItem
	})
	disconnect(g_game, {
		onGameStart = GameInventory.onGameStart,
		onGameEnd = GameInventory.onGameEnd,
		onCoinBalance = GameInventory.onBalanceChange,
		onGoldChange = GameInventory.onGoldChange
	})
	disconnect(LocalPlayer, {
		onLevelChange = GameInventory.onLevelChange,
		onActiveFishingBaitChange = GameInventory.onActiveFishingBaitChange
	})
	disconnect(ProtocolGame, {
		onSendExtendedOpcode = GameInventory.onSendExtendedOpcode
	})

	GameInventory = nil
end

function GameInventory.onExtendedOpcode(protocol, opcode, buffer)
	local self = GameInventory

	if opcode ~= ExtendedIds.InventoryTabs or buffer == "" then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		print("Error: GameInventory.onExtendedOpcode - Invalid Data.", data)

		return
	end

	if data.action == "backpack_configs" then
		self:onBackpackConfigs(data)
	elseif data.action == "backpack_added" then
		self:onBackpackAdded(data)
	elseif data.action == "backpack_updated" then
		self:onBackpackUpdated(data)
	end
end

function GameInventory:showAddNewTabDialog()
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	if player:getLevel() >= cfg.inventory.backpackUnlockLevel then
		self.purchaseWindow:show()
		self.purchaseWindow:focus()
	end
end

function GameInventory.toggle(mouseClick)
	local self = GameInventory

	if GameChat:isActive() or (type(mouseClick) ~= "boolean" or not mouseClick) and IsTextEditActive() then
		return
	end

	if self.window:isVisible() then
		self.window:hide()
	else
		if g_game:isInCutsceneMode() then
			return
		end

		self.window:show()
		self.window:raise()

		local tabBar = self.window.content.selection_panel.content.tab_bar
		local tab = tabBar:getCurrentTab()

		if tab then
			tab.exclamation:hide()
		end

		addEvent(function()
			self:onTabBarScroll(tabBar)
		end)
	end
end

function GameInventory.show()
	local self = GameInventory

	self.window:show()
	self.window:raise()
end

function GameInventory.onGameStart()
	local self = GameInventory

	self.mainPanel.container = g_game.getContainerByGuidAndType(InventorySlotBack, CONTAINER_TYPE_INVENTORY)
	self.questPanel.container = g_game.getContainerByGuidAndType(InventorySlotQuestPouch, CONTAINER_TYPE_QUEST)

	if self.mainPanel.container then
		self.containers[self.mainPanel.container:getId()] = self.mainPanel
	end

	if self.questPanel.container then
		self.containers[self.questPanel.container:getId()] = self.questPanel
	end

	self.holderPanel:show()
	self:resetHighlightedItems(self.mainPanel)
	self:resetHighlightedItems(self.questPanel)

	local tabBar = self.window.content.selection_panel.content.tab_bar

	if tabBar then
		tabBar:scrollTo(0)
	end

	self:reloadInventory()

	local player = g_game.getLocalPlayer()

	if player then
		self.onLevelChange(player, player:getLevel())
	end
end

function GameInventory.onGameEnd()
	local self = GameInventory

	self:closeContainers()
	self:clearTabs()

	self.upgradeConfigs = nil

	if self.purchaseWindow then
		self.purchaseWindow:hide()
	end

	if self.editWindow then
		self.editWindow:hide()
	end

	if self.window:isVisible() then
		self.window:hide()
	end
end

function GameInventory:closeContainers()
	for _, panel in pairs(self.containers) do
		if panel ~= self.mainPanel and panel ~= self.questPanel and panel.container then
			g_game.close(panel.container)

			panel.container = nil
		end
	end

	if self.mainPanel.container then
		g_game.close(self.mainPanel.container)

		self.mainPanel.container = nil
	end

	if self.questPanel.container then
		g_game.close(self.questPanel.container)

		self.questPanel.container = nil
	end

	if self.currentInventory then
		self.currentInventory:hide()

		self.currentInventory = nil
	end
end

function GameInventory:loadContainer(container, panel)
	self.containers[container:getId()] = panel
	panel.container = container

	self:refreshContainerItems(panel)
end

function GameInventory:unloadContainer(containerOrId)
	containerOrId = type(containerOrId) == "number" and containerOrId or containerOrId:getId()

	local panel = self.containers[containerOrId]

	if panel then
		panel.container = nil
	end

	self.containers[containerOrId] = nil

	if self.currentInventory == panel then
		self:refreshContainerItems(panel)
	else
		self:clearContainerItems(panel)
	end
end

function GameInventory:selectContainer(panel)
	if not panel then
		print("Error: GameInventory.selectContainer - Invalid panel.")

		return
	end

	local container = panel.container

	if not container then
		print("Error: GameInventory.selectContainer - Invalid Container.", debug.traceback())

		return
	end

	local containerType = container:getType()

	if not self.types[containerType] then
		return
	end

	if self.currentInventory then
		self.currentInventory:hide()
	end

	self.currentInventory = panel

	panel:show()

	if self.currentInventory and self.unlockPanel then
		self.unlockPanel:removeAnchor(AnchorTop)
		self.unlockPanel:addAnchor(AnchorTop, self.currentInventory:getId(), AnchorBottom)
	end

	self:refreshContainerItems(panel)
	self:resetFilterPanel()
	self:updateCapacityLabel()
	self:applyInventoryFilter(self.currentFilterType)
end

function GameInventory:clearContainerItems(panel)
	if not panel then
		print("Error: GameInventory.clearContainerItems - Invalid panel.")

		return
	end

	for _, child in ipairs(panel:getChildren()) do
		child:setItem(nil)
		child:hide()
	end
end

function GameInventory:refreshContainerItems(panel)
	if not panel then
		return
	end

	local container = panel.container
	local maxSlots = container and math.max(container:getSize(), container:getCapacity()) - 1 or 0

	for _, child in ipairs(panel:getChildren()) do
		child:hide()
	end

	if container then
		for slot = 0, maxSlots do
			local itemWidget = panel:getChildByIndex(slot + 1) or g_ui.createWidget("InventoryItem", panel)

			itemWidget.position = container:getSlotPosition(slot)

			local item = container:getInventoryItem(slot)

			if item then
				itemWidget:setItem(item)
			else
				itemWidget:setItem(nil)
			end

			itemWidget:getChildById("lock"):setVisible(false)
			itemWidget:show()
		end
	end

	if container and container:getType() == CONTAINER_TYPE_INVENTORY then
		local updgradeConfig = self.upgradeConfigs and self.upgradeConfigs[container:getGuid()]

		updgradeConfig = updgradeConfig or {
			initialSize = self.inventoryInitialSize,
			slotsPerRow = self.slotsPerRow,
			maxRowsUnlocked = cfg.inventory.maxRowsUnlocked,
			silverUnlockRowCost = cfg.inventory.baseSilverUnlockCost,
			ravencoinUnlockRowCost = cfg.inventory.baseRavencoinCost
		}

		local rows = math.floor((math.max(container:getCapacity(), container:getLastItemIndex()) - updgradeConfig.initialSize) / updgradeConfig.slotsPerRow)

		if panel == self.currentInventory then
			if rows < updgradeConfig.maxRowsUnlocked then
				self.unlockPanel:setVisible(true)

				for i = 1, self.slotsPerRow do
					local itemWidget = self.unlockPanel.slots:getChildByIndex(i) or g_ui.createWidget("InventoryItem", self.unlockPanel.slots)

					itemWidget:show()
					itemWidget:setItem(nil)
					itemWidget:getChildById("lock"):setVisible(true)
					itemWidget:disable()
				end

				local cost = updgradeConfig.silverUnlockRowCost[rows + 1] or updgradeConfig.ravencoinUnlockRowCost
				local prefix = updgradeConfig.silverUnlockRowCost[rows + 1] and "Silver" or "RavenCoins"

				self.unlockPanel.unlock_button:setText(FormatCommaNumber(cost))
				self.unlockPanel.unlock_button:changeIcon(string.format("/images/ui/windows/inventory/%s", prefix == "Silver" and "icon_silver" or "icon_ravencoin"))
			else
				self.unlockPanel:setVisible(false)
			end
		else
			self.unlockPanel:setVisible(false)
		end
	else
		self.unlockPanel:setVisible(false)
	end

	if container then
		if panel == self.currentInventory then
			self:updateCapacityLabel()
		end

		signalcall(g_game.onRefreshItems, container)
	end
end

function GameInventory.onContainerOpen(container)
	local self = GameInventory
	local containerType = container:getType()

	if not self.types[containerType] then
		return
	end

	if not self.upgradeConfigs then
		table.insert(self.pendingContainers, container)

		return
	end

	local tab
	local guid = container:getGuid()

	if guid and guid > 0 then
		tab = self.tabs[guid]
	end

	if not tab then
		if self:isBackpack(guid) then
			print("Error: GameInventory.onContainerOpen - Invalid Tab.", guid)

			return
		end

		tab = containerType == CONTAINER_TYPE_QUEST and self.questTab or self.mainTab
	end

	tab._containerPosition = container:getSlotPosition(0)

	self:loadContainer(container, tab.tabPanel)

	local tabBar = self.window.content.selection_panel.content.tab_bar

	if tabBar:getCurrentTab() == tab then
		self:selectContainer(tab.tabPanel)
	end

	if not self.currentInventory then
		addEvent(function()
			self:onTabChange(self.mainTab)
		end)
	end
end

function GameInventory.onContainerUpdateItem(container, slot, item, oldItem)
	local self = GameInventory

	if not self.types[container:getType()] then
		return
	end

	local tab
	local panel = self.containers[container:getId()]

	if not panel then
		local containerGuid = container:getGuid()

		if containerGuid then
			tab = self.tabs[containerGuid]
		end
	else
		tab = panel.tab

		local widget = panel:getChildByIndex(slot + 1)

		if widget then
			widget:setItem(item)

			widget.position = container:getSlotPosition(slot)

			if item:getId() == oldItem:getId() and item:getCount() > oldItem:getCount() then
				widget.hover:setOn(self:canHighlightItem(item))
			end
		end

		if panel == self.currentInventory then
			self:updateCapacityLabel()
			self:applyInventoryFilter(self.currentFilterType)
		end
	end

	if tab and panel ~= self.currentInventory then
		tab.exclamation:show()
		self:onTabBarScroll(self.window.content.selection_panel.content.tab_bar)
	end

	signalcall(g_game.onUpdateItem, container, slot, item, oldItem)

	self.lastUpdatedItem = item

	addEvent(function()
		self.lastUpdatedItem = nil
	end)
end

function GameInventory.onContainerRemoveItem(container, slot, item)
	local self = GameInventory

	if not self.types[container:getType()] then
		return
	end

	local tab
	local panel = self.containers[container:getId()]

	if not panel then
		local containerGuid = container:getGuid()

		if containerGuid then
			tab = self.tabs[containerGuid]
		end
	else
		tab = panel.tab

		local widget = panel:getChildByIndex(slot + 1)

		if widget then
			widget:setItem(nil)
			widget:setHovered(false)
			widget.hover:setOn(false)
		end

		if panel == self.currentInventory then
			self:updateCapacityLabel()
			self:applyInventoryFilter(self.currentFilterType)
		end
	end

	signalcall(g_game.onRemoveItem, container, slot, item)

	self.lastRemovedItem = item

	addEvent(function()
		self.lastRemovedItem = nil
	end)
end

function GameInventory.onContainerAddItem(container, slot, item)
	local self = GameInventory

	if not self.types[container:getType()] then
		return
	end

	local tab
	local panel = self.containers[container:getId()]

	if not panel then
		local containerGuid = container:getGuid()

		if containerGuid then
			tab = self.tabs[containerGuid]
		end
	else
		tab = panel.tab

		local widget = panel:getChildByIndex(slot + 1)

		if widget then
			widget:setItem(item)
			widget.hover:setOn(self:canHighlightItem(item))
		end

		if panel == self.currentInventory then
			self:updateCapacityLabel()
			self:applyInventoryFilter(self.currentFilterType)
		end
	end

	if tab and panel ~= self.currentInventory then
		tab.exclamation:show()
		self:onTabBarScroll(self.window.content.selection_panel.content.tab_bar)
	end

	signalcall(g_game.onAddItem, container, slot, item)

	self.lastAddedItem = item

	addEvent(function()
		self.lastAddedItem = nil
	end)
end

function GameInventory:reloadInventory(tab)
	if not self.currentInventory then
		self:selectTab(tab or self.mainTab, true, true)
	end

	self:refreshContainerItems(self.currentInventory)
	self:resetFilterPanel()
	self:updateCapacityLabel()
	self:applyInventoryFilter("all")
end

function GameInventory:resetFilterPanel()
	for _, child in ipairs(self.filterPanel:getChildren()) do
		child:setOn(child:getId() == "sort" and child.enablingEvent == nil)
	end
end

function GameInventory:updateCapacityLabel()
	if not self.currentInventory then
		self.filterPanel:setText("0 / 0")

		return
	end

	local container = self.currentInventory.container

	if container then
		self.filterPanel:setText(container:getSize() .. " / " .. container:getCapacity())

		for i = math.max(container:getSize(), container:getCapacity()) + 1, self.currentInventory:getChildCount() do
			local itemWidget = self.currentInventory:getChildByIndex(i)

			if itemWidget and not itemWidget:getChildById("lock"):isVisible() then
				itemWidget:hide()
			end
		end
	else
		self.filterPanel:setText("0 / 0")
	end
end

function GameInventory:applyInventoryFilter(id)
	if not self.currentInventory then
		return
	end

	for _, child in ipairs(self.currentInventory:getChildren()) do
		if id == "all" then
			child:setEnabled(true)
		else
			local item = child:getItem()
			local filter = cfg.filter[id]

			if item and filter then
				child:setEnabled(filter(item))
			end
		end
	end

	for _, child in ipairs(self.filterPanel:getChildren()) do
		if child:getId() ~= "sort" then
			child:setOn(child:getId() == id)
		else
			child:setOn(child.enablingEvent == nil)
		end
	end

	self.currentFilterType = id
end

function GameInventory.onBalanceChange(premium, balance)
	local self = GameInventory
	local player = g_game.getLocalPlayer()

	player.silverBalance = balance

	self.bottomPanel.currency.silver:setText(balance)
end

function GameInventory.onGoldChange(balance)
	local self = GameInventory
	local player = g_game.getLocalPlayer()

	player.goldBalance = balance

	self.bottomPanel.currency.gold:setText(balance)
end

function GameInventory:findItemWidgetByItemType(panel, itemType)
	for _, child in ipairs(self[panel]:getChildren()) do
		local item = child:getItem()
		local filter = cfg.filter[itemType]

		if item and filter and filter(item) then
			return child
		end
	end

	return nil
end

function GameInventory:findItemWidgetByName(panel, itemName)
	for _, child in ipairs(self[panel]:getChildren()) do
		local item = child:getItem()

		if item and item:getName():lower() == itemName:lower() then
			return child
		end
	end

	return nil
end

function GameInventory:findItemTabWidgetByItemType(tabId, itemType)
	for _, child in ipairs(self.tabs[tabId].tabPanel:getChildren()) do
		local item = child:getItem()
		local filter = cfg.filter[itemType]

		if item and filter and filter(item) then
			return child
		end
	end

	return nil
end

function GameInventory:findItemTabWidgetByName(tabId, itemName)
	for _, child in ipairs(self.tabs[tabId].tabPanel:getChildren()) do
		local item = child:getItem()

		if item and item:getName():lower() == itemName:lower() then
			return child
		end
	end

	return nil
end

function GameInventory:findItemTabByItemType(itemType)
	local child = self:findItemWidgetByItemType("mainPanel", itemType)

	if child then
		return self.mainTab, child
	end

	local child = self:findItemWidgetByItemType("questPanel", itemType)

	if child then
		return self.questTab, child
	end

	for _, tab in pairs(self.tabs) do
		local tabId = tab.id
		local child = self:findItemTabWidgetByItemType(tabId, itemType)

		if child then
			return self.tabs[tabId], child
		end
	end

	return nil
end

function GameInventory:findItemTabByName(itemName)
	local child = self:findItemWidgetByName("mainPanel", itemName)

	if child then
		return self.mainTab, child
	end

	local child = self:findItemWidgetByName("questPanel", itemName)

	if child then
		return self.questTab, child
	end

	for _, tab in pairs(self.tabs) do
		local tabId = tab.id
		local child = self:findItemTabWidgetByName(tabId, itemName)

		if child then
			return self.tabs[tabId], child
		end
	end

	return nil
end

function GameInventory:canHighlightItem(item)
	local highlightItem = true

	if self.lastAddedItem and self.lastAddedItem:getId() == item:getId() then
		highlightItem = false
	end

	if highlightItem and self.lastRemovedItem and self.lastRemovedItem:getId() == item:getId() then
		highlightItem = false
	end

	if highlightItem and self.lastUpdatedItem and self.lastUpdatedItem:getId() == item:getId() then
		highlightItem = false
	end

	return highlightItem
end

function GameInventory:resetHighlightedItems(panel)
	if panel then
		for _, child in ipairs(panel:getChildren()) do
			if child.hover then
				child.hover:setOn(false)
			end
		end
	else
		for _, tab in pairs(self.tabs) do
			self:resetHighlightedItems(tab.tabPanel)
		end
	end
end

function GameInventory.onLevelChange(localPlayer, level)
	local self = GameInventory

	self.addNewTab:setOn(level >= cfg.inventory.backpackUnlockLevel)

	if self.addNewTab:isOn() then
		self.addNewTab:setTooltip("Unlock new backpack")
	else
		self.addNewTab:setTooltip(string.format("The possibility to add new Inventory Backpacks will be unlocked at Legacy Level |%s|.", cfg.inventory.backpackUnlockLevel))
	end

	local infusionButton = self.bottomPanel.button_panel.infusion

	if level >= 7 then
		infusionButton:setDisabled(false)
		infusionButton:setTooltip("Infusion")
	else
		infusionButton:setDisabled(true)
		infusionButton:setTooltip("This option will be unlocked at legacy level 7")
	end
end

function GameInventory:sendOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.Inventory, g_game.serializeTable(data))
	end
end

function GameInventory.onSendExtendedOpcode(protocol, opcode, buffer)
	local self = GameInventory

	if opcode ~= ExtendedIds.Inventory then
		return
	end

	local filterPanel = self.filterPanel

	if not filterPanel then
		return
	end

	local sort = filterPanel.sort

	if not sort:isOn() or sort.enablingEvent then
		return
	end

	sort:setOn(false)

	local lastTooltip = sort:getTooltip()

	sort:setTooltip("Must wait 5 seconds before sorting again")

	sort.enablingEvent = scheduleEvent(function()
		sort:setOn(true)
		sort:setTooltip(lastTooltip)

		sort.enablingEvent = nil
	end, 5000)
end

function GameInventory:unlockInventorySlotsRow()
	if not self.currentInventory then
		print("Error: GameInventory.unlockBankSlotsRow - Invalid Current Inventory.")

		return
	end

	if self.confirmationBox then
		self.confirmationBox:raise()
		self.confirmationBox:shake(4, 3)

		return
	end

	local container = self.currentInventory.container

	if not container or container:getType() ~= CONTAINER_TYPE_INVENTORY then
		print("Error: GameInventory.unlockBankSlotsRow - Invalid Container.")

		return
	end

	local function yesCallback()
		if not self.currentInventory or not self.currentInventory.container then
			print("Error: GameInventory.unlockBankSlotsRow - Invalid Current Inventory.")

			return
		end

		local containerId = self.currentInventory.container:getId()
		local containerGuid = self.currentInventory.container:getGuid()

		if self:isBackpack(containerGuid) then
			modules.game_npcs.GameBank:sendInventoryTabOpcode({
				action = "backpack_unlock_row",
				containerId = containerId
			})
		else
			modules.game_npcs.GameBank:sendOpcode({
				action = "unlock_inventory_row",
				containerId = containerId
			})
		end

		self.confirmationBox:destroy()

		self.confirmationBox = nil
	end

	local function noCallback()
		self.confirmationBox:destroy()

		self.confirmationBox = nil
	end

	local updgradeConfig = self.upgradeConfigs and self.upgradeConfigs[container:getGuid()]

	updgradeConfig = updgradeConfig or {
		initialSize = self.inventoryInitialSize,
		slotsPerRow = self.slotsPerRow,
		silverUnlockRowCost = cfg.inventory.baseSilverUnlockCost,
		ravencoinUnlockRowCost = cfg.inventory.baseRavencoinCost
	}

	local rows = math.floor((math.max(container:getCapacity(), container:getLastItemIndex()) - updgradeConfig.initialSize) / updgradeConfig.slotsPerRow)
	local cost = updgradeConfig.silverUnlockRowCost[rows + 1] or updgradeConfig.ravencoinUnlockRowCost
	local prefix = updgradeConfig.silverUnlockRowCost[rows + 1] and "Silver" or "RavenCoins"

	self.confirmationBox = displayGeneralBox(tr("Confirm choice"), tr(string.format("You are purchasing |%d| inventory slots for |%d| |%s|.\nDo you want to continue?", self.slotsPerRow * cfg.inventory.rowsPerUnlock, cost, prefix)), {
		{
			text = tr("Yes"),
			callback = yesCallback
		},
		{
			text = tr("No"),
			callback = noCallback
		},
		anchor = AnchorHorizontalCenter
	}, yesCallback, noCallback, nil, modules.game_interface.getRootPanel())
end

function GameInventory:isBackpack(containerGuid)
	return cfg.inventory.backpackSlots[containerGuid]
end

function GameInventory.onActiveFishingBaitChange(player, itemId, quality)
	local self = GameInventory

	for _, child in ipairs(self.mainPanel:getChildren()) do
		signalcall(UIItem.onItemChange, child)
	end
end

function GameInventory:selectTab(tab, dontShowInventory, scrollTo, forceSelect)
	local originalTab = tab

	if type(tab) == "number" then
		if tab == InventorySlotBack then
			tab = self.mainTab
		elseif tab == InventorySlotQuestPouch then
			tab = self.questTab
		else
			tab = self.tabs[tab]
		end
	end

	if not tab then
		print("Error: GameInventory.selectTab - Invalid Tab.", originalTab)

		return
	end

	local tabBar = self.window.content.selection_panel.content.tab_bar

	if tabBar:getCurrentTab() ~= tab or forceSelect then
		tabBar:selectTab(tab, false, scrollTo)
	end

	if not dontShowInventory and not self.window:isVisible() then
		self:show()
	end
end

function GameInventory:onTabChange(tab, lastTab)
	local isMain = tab.name:lower() == "main" or tab.name:lower() == "quest"

	if lastTab and lastTab.bottom_line then
		lastTab.bottom_line:setVisible(false)
	end

	tab.bottom_line:setVisible(true)

	if tab.tabPanel.container then
		self:selectContainer(tab.tabPanel)
	elseif not isMain then
		modules.game_npcs.GameBank:sendInventoryTabOpcode({
			action = "backpack_open",
			info = {
				id = tab.id
			}
		})
	end

	self.filterPanel.edit:setVisible(not isMain)

	self.filterPanel.edit.tab = tab

	tab.exclamation:hide()
end

function GameInventory:addTab(id, name, data)
	local tabBar = self.window.content.selection_panel.content.tab_bar
	local index = #tabBar.tabs - 1
	local tab = tabBar:addTab(name, g_ui.createWidget("GameInventoryPanel", self.holderPanel), nil, nil, nil, nil, index)

	tab:onTextChange(tab:getText())
	tab.tabPanel:setId(id)
	tabBar:onTabSizeChange()

	self.tabs[id] = tab
	tab.id = id
	tab.name = name
	tab.categories = self:convertCategoriesToOptions(data.categories)

	if table.size(self.tabs) >= cfg.bank.vaultLimit then
		tabBar:hideTab(self.addNewTab)
	else
		tabBar:showTab(self.addNewTab)
	end

	return tab
end

function GameInventory:clearTabs()
	local tabBar = self.window.content.selection_panel.content.tab_bar

	for _, tab in pairs(self.tabs) do
		if tab and tab.tabPanel.isTab then
			tabBar:removeTab(tab)
			tab:destroy()
		end
	end

	tabBar:onTabSizeChange()

	self.tabs = {}
end

function GameInventory:disableAllExcept(tabIds, enabled)
	for _, tab in pairs(self.tabs) do
		if not table.contains(tabIds, tab.id) then
			tab:setEnabled(enabled)
		end
	end
end

function GameInventory:disableTab(tabNameOrId, enabled)
	if type(tabNameOrId) == "string" then
		if tabNameOrId:lower() == self.mainTab.name:lower() then
			self.mainTab:setEnabled(enabled)

			return
		elseif tabNameOrId:lower() == self.questTab.name:lower() then
			self.questTab:setEnabled(enabled)

			return
		end

		for _, tab in pairs(self.tabs) do
			if tab.name:lower() == tabNameOrId:lower() then
				tab:setEnabled(enabled)
			end
		end
	else
		local tab = self.tabs[tabNameOrId]

		if tab then
			tab:setEnabled(enabled)
		end
	end
end

function GameInventory:acceptPurchaseUnlock()
	self.purchaseWindow:hide()

	self.editWindow.tab = nil

	self.editWindow.content.editBackpackContent.categoryComboBox:clearSelectedOptions()
	self.editWindow.content.editBackpackContent.nameTextEdit:setTextPreview(string.format("Backpack %s", table.size(self.tabs) + 1))
	self.editWindow:raise()
	self.editWindow:show()
end

function GameInventory:createOrSaveTab(tab)
	self.purchaseWindow:hide()

	local nameTextEdit = self.editWindow.content.editBackpackContent.nameTextEdit
	local name = nameTextEdit:getText()

	if name:empty() then
		name = nameTextEdit:getTextPreview()
	end

	local categoryComboBox = self.editWindow.content.editBackpackContent.categoryComboBox
	local categories = {}

	for _, option in ipairs(categoryComboBox:getSelectedOptions()) do
		table.insert(categories, option.data.id)
	end

	tab = tab or self.editWindow.tab

	if tab then
		modules.game_npcs.GameBank:sendInventoryTabOpcode({
			action = "backpack_update",
			info = {
				id = tab.id,
				name = name,
				categories = categories
			}
		})
	else
		modules.game_npcs.GameBank:sendInventoryTabOpcode({
			action = "backpack_unlock",
			info = {
				name = name,
				categories = categories
			}
		})
	end
end

function GameInventory:onBackpackConfigs(data)
	self.upgradeConfigs = data.upgradeConfigs

	if not data.containerConfigs then
		print("Error: GameInventory.onBackpackConfigs - Invalid Configs.", data.containerConfigs)

		return
	end

	local configs = {}

	for _, config in pairs(data.containerConfigs) do
		table.insert(configs, config)
	end

	table.sort(configs, function(a, b)
		return a.id < b.id
	end)

	for _, config in pairs(configs) do
		if not config.id then
			print("Error: GameInventory.onBackpackConfigs - Invalid Id.", config.id)

			return
		elseif not config.name then
			print("Error: GameInventory.onBackpackConfigs - Invalid Name.", config.name)

			return
		elseif not config.categories then
			print("Error: GameInventory.onBackpackConfigs - Invalid Categories.", config.categories)

			return
		end

		local tab = self.tabs[config.id]

		if not tab then
			tab = self:addTab(config.id, config.name, {
				categories = config.categories
			})
		else
			if tab.name ~= config.name then
				tab:setText(config.name)
			end

			tab.id = config.id
			tab.name = config.name
			tab.categories = self:convertCategoriesToOptions(config.categories)
		end
	end

	local tabBar = self.window.content.selection_panel.content.tab_bar

	if table.size(self.tabs) >= cfg.bank.vaultLimit then
		tabBar:hideTab(self.addNewTab)
	else
		tabBar:showTab(self.addNewTab)
	end

	addEvent(function()
		for _, container in ipairs(self.pendingContainers) do
			self.onContainerOpen(container)
		end

		self.pendingContainers = {}
	end)
end

function GameInventory:onBackpackAdded(data)
	local config = data.config

	if not config then
		print("Error: GameInventory.onBackpackAdded - Invalid Config.", config)

		return
	elseif not config.id then
		print("Error: GameInventory.onBackpackAdded - Invalid Id.", config.id)

		return
	end

	local tab = self.tabs[config.id]

	if tab then
		print("Error: GameInventory.onBackpackAdded - Tab Already Exists.", config.id)

		return
	end

	if not config.name then
		print("Error: GameInventory.onBackpackAdded - Invalid Name.", config.name)

		return
	elseif not config.categories then
		print("Error: GameInventory.onBackpackAdded - Invalid Categories.", config.categories)

		return
	end

	self:addTab(config.id, config.name, {
		categories = config.categories
	})
	self.editWindow:hide()
end

function GameInventory:onBackpackUpdated(data)
	local config = data.config

	if not config then
		print("Error: GameInventory.onBackpackUpdated - Invalid Config.", config)

		return
	elseif not config.id then
		print("Error: GameInventory.onBackpackUpdated - Invalid Id.", config.id)

		return
	end

	local tab = self.tabs[config.id]

	if not tab then
		print("Error: GameInventory.onBackpackAdded - Tab Not Found.", config.id)

		return
	end

	if not config.name then
		print("Error: GameInventory.onBackpackAdded - Invalid Name.", config.name)

		return
	elseif not config.categories then
		print("Error: GameInventory.onBackpackAdded - Invalid Categories.", config.categories)

		return
	end

	tab.id = config.id
	tab.name = config.name
	tab.categories = self:convertCategoriesToOptions(config.categories)

	tab:setText(config.name)
	self.editWindow:hide()
end

function GameInventory:convertCategoriesToOptions(categories)
	local options = {}

	for _, category in ipairs(categories) do
		local name = cfg.inventory.backpackCategoryNameIds[category]

		table.insert(options, {
			text = name,
			data = {
				id = category
			}
		})
	end

	return options
end

function GameInventory:editTab(tab)
	if not tab then
		print("Error: GameInventory.editTab - Invalid Tab.")

		return
	end

	if not tab.categories then
		print("Error: GameInventory.editTab - Invalid Tab Categories.")

		return
	end

	local nameTextEdit = self.editWindow.content.editBackpackContent.nameTextEdit

	nameTextEdit:setTextPreview(tab.name)
	nameTextEdit:setText(tab.name)

	local categoryComboBox = self.editWindow.content.editBackpackContent.categoryComboBox

	categoryComboBox:setSelectedOptions(tab.categories)

	self.editWindow.tab = tab

	self.editWindow:raise()
	self.editWindow:show()
end

function GameInventory:hideBackpackTabs()
	self.window.content.selection_panel:setHeight(0)
	self.window.content.selection_panel:hide()
end

function GameInventory:showBackpackTabs()
	self.window.content.selection_panel:setHeight(self.window.content.selection_panel.defaultHeight)
	self.window.content.selection_panel:show()
end

function GameInventory:onCategoryMenuSetup(menu)
	local categories = self:getUsedCategories()

	for _, child in ipairs(menu:getChildren()) do
		if not child:isChecked() then
			local enabled = not child.data or not categories[child.data.id]

			child:setOn(enabled)
			child:setEnabled(enabled)
		end
	end
end

function GameInventory:getUsedCategories()
	local categories = {}

	for _, tab in pairs(self.tabs) do
		for _, category in ipairs(tab.categories) do
			if not table.contains(categories, category.data.id) then
				categories[category.data.id] = true
			end
		end
	end

	return categories
end

function GameInventory:sortInventory()
	local container = self.currentInventory.container

	if not container then
		print("Error: GameInventory.sortInventory - Invalid Container.")

		return
	end

	local guid = container:getGuid()

	if not guid or guid == 0 then
		guid = InventorySlotBack
	elseif guid == 1 then
		guid = InventorySlotQuestPouch
	end

	self:sendOpcode({
		action = "inventory_reorder",
		slotId = guid,
		autoCategorize = g_keyboard.isCtrlPressed()
	})
end

function GameInventory:onTabBarScroll(tabBar, offset, margin, vertical)
	local parent = tabBar:getParent():getParent()

	parent.scroll_left.exclamation:hide()
	parent.scroll_right.exclamation:hide()

	for _, tab in pairs(self.tabs) do
		if tab.exclamation and tab.exclamation:isVisible() then
			local leftPos = parent.scroll_left:getPosition()
			local rightPos = parent.scroll_right:getPosition()
			local pos = tab.exclamation:getPosition()
			local leftDiff = pos.x - leftPos.x
			local rightDiff = rightPos.x - pos.x

			if rightDiff < 0 then
				parent.scroll_right.exclamation:show()
			elseif leftDiff < 0 then
				parent.scroll_left.exclamation:show()
			end
		end
	end

	signalcall(g_game.onTabBarScroll)
end

function GameInventory:isTabBarVisible(tabBar, tabId)
	local parent = tabBar:getParent():getParent()
	local tab

	if tabId == InventorySlotBack then
		tab = self.mainTab
	elseif tabId == InventorySlotQuestPouch then
		tab = self.questTab
	else
		tab = self.tabs[tabId]
	end

	if tab then
		local leftPos = parent.scroll_left:getPosition()
		local rightPos = parent.scroll_right:getPosition()
		local pos = tab:getPosition()
		local leftDiff = pos.x - leftPos.x
		local rightDiff = rightPos.x - pos.x

		if rightDiff < 0 then
			return rightDiff, "right"
		elseif leftDiff < 0 then
			return leftDiff, "left"
		end
	end

	return 0, nil
end
