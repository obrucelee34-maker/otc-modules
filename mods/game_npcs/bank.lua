-- chunkname: @/modules/game_npcs/bank.lua

GameBank = {
	page = 0,
	currentFilterType = "all",
	itemsPerPage = 0,
	maxPages = 0,
	defaultNpcName = "Munk Keeper",
	inboxDepotInitialSize = 100,
	bankDepotInitialSize = 70,
	maxSlots = 210,
	slotsPerRow = 7,
	tabs = {},
	containers = {},
	types = {
		[CONTAINER_TYPE_DEPOT] = true,
		[CONTAINER_TYPE_HOUSE_DEPOT] = true,
		[CONTAINER_TYPE_INBOX] = true
	},
	defaultNpcPreview = {
		lookType = 4822,
		category = ThingCategoryCreature
	}
}

function GameBank:init()
	self.window = GameNpc.panels[windowTypes.bank]

	self.window:hide()

	self.holderPanel = g_ui.createWidget("GameBankItemsPanelHolder", self.window)
	self.unlockPanel = g_ui.createWidget("GameBankUnlockPanel", self.holderPanel)

	self.unlockPanel:hide()

	self.paginationPanel = g_ui.createWidget("GameBankPaginationPanel", self.window)

	self.paginationPanel:hide()

	self.filterPanel = self.window:recursiveGetChildById("filter_panel")

	self:resetFilterPanel()

	self.bottomPanel = self.window:recursiveGetChildById("bottom_panel")
	self.purchaseWindow = g_ui.createWidget("GamePurchaseVaultModal", modules.game_interface.getHUDPanel())

	function self.purchaseWindow.onEscape(widget)
		self.purchaseWindow:hide()
	end

	self.purchaseWindow:hide()

	self.editWindow = g_ui.createWidget("GameEditVaultModal", modules.game_interface.getHUDPanel())

	function self.editWindow.onEnter(widget)
		self:createOrSaveTab()
	end

	function self.editWindow.onEscape(widget)
		self.editWindow:hide()
	end

	function self.editWindow.onVisibilityChange(widget, visible)
		if not visible then
			self.editWindow.content.editVaultContent.nameTextEdit:setText("")
			self.editWindow.content.editVaultContent.nameTextEdit:setTextPreview("")
			self.editWindow.content.editVaultContent.categoryComboBox:clearSelectedOptions()
		end
	end

	self.editWindow:hide()

	local categoryComboBox = self.editWindow.content.editVaultContent.categoryComboBox

	for _, category in ipairs(cfg.bank.vaultCategoryNames) do
		local id = cfg.bank.vaultCategoryIds[category]

		categoryComboBox:addOption(tr(category), {
			id = id
		})
	end

	connect(Container, {
		onOpen = GameBank.onContainerOpen,
		onRemoveItem = GameBank.onContainerRemoveItem,
		onUpdateItem = GameBank.onContainerUpdateItem,
		onAddItem = GameBank.onContainerAddItem
	})
	connect(ProtocolGame, {
		onSendExtendedOpcode = GameBank.onSendExtendedOpcode
	})
	connect(g_game, {
		onGameStart = GameBank.onGameStart,
		onGameEnd = GameBank.onGameEnd,
		onCoinBalance = GameBank.onBalanceChange
	})
	connect(LocalPlayer, {
		onLevelChange = GameBank.onPlayerLevelChange
	})
	connect(GameBank.window, {
		onVisibilityChange = GameBank.onVisibilityChange
	})

	self.mainTab = self.window.top_panel.content.tab_bar:addTab("Main", g_ui.createWidget("GameBankItemsPanel", self.holderPanel), nil, nil, nil)
	self.mainTab.extraWidth = 15

	self.mainTab:onTextChange(self.mainTab:getText())

	self.mainPanel = self.mainTab.tabPanel
	self.currentInventory = self.mainTab.tabPanel
	self.addNewTab = self.window.top_panel.content.tab_bar:addActionTab("", "GameBankTabBarAddButton", nil, nil, {
		onClick = function(widget)
			self:showAddNewTabDialog()
		end
	})

	ProtocolGame.registerExtendedOpcode(ExtendedIds.InventoryTabs, GameBank.onExtendedOpcode, "game_npcs")

	if g_game.isOnline() then
		addEvent(function()
			GameBank.onGameStart()
		end)
	end
end

function GameBank:terminate()
	self.window:destroy()

	if self.purchaseWindow then
		self.purchaseWindow:destroy()
	end

	if self.editWindow then
		self.editWindow:destroy()
	end

	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.InventoryTabs, "game_npcs")
	disconnect(Container, {
		onOpen = GameBank.onContainerOpen,
		onRemoveItem = GameBank.onContainerRemoveItem,
		onUpdateItem = GameBank.onContainerUpdateItem,
		onAddItem = GameBank.onContainerAddItem
	})
	disconnect(g_game, {
		onGameStart = GameBank.onGameStart,
		onGameEnd = GameBank.onGameEnd,
		onCoinBalance = GameBank.onBalanceChange
	})
	disconnect(LocalPlayer, {
		onPositionChange = GameBank.onPlayerPositionChange,
		onLevelChange = GameBank.onPlayerLevelChange
	})
	disconnect(ProtocolGame, {
		onSendExtendedOpcode = GameBank.onSendExtendedOpcode
	})
	disconnect(GameBank.window, {
		onVisibilityChange = GameBank.onVisibilityChange
	})

	GameBank = nil
end

function GameBank.onExtendedOpcode(protocol, opcode, buffer)
	local self = GameBank

	if opcode ~= ExtendedIds.InventoryTabs or buffer == "" then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		print("Error: GameBank.onExtendedOpcode - Invalid Data.", data)

		return
	end

	if data.action == "vault_configs" then
		self:onVaultConfigs(data)
	elseif data.action == "vault_added" then
		self:onVaultAdded(data)
	elseif data.action == "vault_updated" then
		self:onVaultUpdated(data)
	end
end

function GameBank:showAddNewTabDialog()
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	if player:getLevel() >= cfg.bank.vaultUnlockLevel then
		self.purchaseWindow:show()
		self.purchaseWindow:focus()
	end
end

function GameBank.show()
	local self = GameBank

	GameNpc:show()
	self.window:show()
	self.window:raise()
	GameNpc:setPanel("bank")
	GameNpc:setTopPanelOn(true)
	addEvent(function()
		self:selectTab(self.mainTab, true)
	end)
end

function GameBank.toggle(mouseClick)
	local self = GameBank

	if GameChat:isActive() or (type(mouseClick) ~= "boolean" or not mouseClick) and IsTextEditActive() then
		return
	end

	if self.window:isVisible() then
		self.window:hide()
		self.purchaseWindow:hide()
		self.editWindow:hide()
	elseif not g_game:isInCutsceneMode() then
		self.window:show()
		self.window:raise()
	end
end

function GameBank.onVisibilityChange(widget, visible)
	local self = GameBank

	if visible then
		return
	end

	local container = self.currentInventory and self.currentInventory.container

	if not container then
		return
	end

	if not self.types[container:getType()] then
		return
	end

	g_game.close(container)
end

function GameBank.onContainerOpen(container)
	local self = GameBank
	local containerType = container:getType()

	if not self.types[containerType] then
		return
	end

	local tab
	local guid = container:getGuid()

	if guid and guid > 0 then
		tab = self.tabs[guid]
	end

	if not tab then
		if self:isVault(guid) then
			print("Error: GameBank.onContainerOpen - Invalid Tab.", guid)

			return
		end

		tab = self.mainTab
	end

	tab._containerPosition = container:getSlotPosition(0)

	self:loadContainer(container, tab.tabPanel)

	local tabBar = self.window.top_panel.content.tab_bar

	if tabBar:getCurrentTab() == tab then
		self:selectContainer(tab.tabPanel)
	end

	if not self.currentInventory then
		addEvent(function()
			self:onTabChange(self.mainTab)
		end)
	end
end

function GameBank.onContainerUpdateItem(container, slot, item, oldItem)
	local self = GameBank

	if not self.types[container:getType()] then
		return
	end

	if not container:hasPages() then
		slot = slot + 1
	end

	local panel = self.containers[container:getId()]

	if not panel then
		print("Error: GameBank.onContainerUpdateItem - Invalid Panel.")

		return
	end

	local widget = panel:getChildByIndex(slot)

	if widget then
		widget:setItem(item)
	end

	if panel == self.currentInventory then
		self:updateCapacityLabel()
		self:applyBankFilter(self.currentFilterType)
	else
		self:selectTab(panel.tab, true)
	end
end

function GameBank.onContainerAddItem(container, slot, item)
	local self = GameBank

	if not self.types[container:getType()] then
		return
	end

	if not container:hasPages() then
		slot = slot + 1
	end

	local panel = self.containers[container:getId()]

	if not panel then
		print("Error: GameBank.onContainerAddItem - Invalid Panel.")

		return
	end

	local widget = panel:getChildByIndex(slot)

	if widget then
		widget:setItem(item)
	end

	if panel == self.currentInventory then
		self:updateCapacityLabel()
		self:applyBankFilter(self.currentFilterType)
	else
		self:selectTab(panel.tab, true)
	end
end

function GameBank.onContainerRemoveItem(container, slot, item)
	local self = GameBank

	if not self.types[container:getType()] then
		return
	end

	if not container:hasPages() then
		slot = slot + 1
	end

	local panel = self.containers[container:getId()]

	if not panel then
		print("Error: GameBank.onContainerRemoveItem - Invalid Panel.")

		return
	end

	local widget = panel:getChildByIndex(slot)

	if widget then
		widget:setItem(nil)
		widget:setHovered(false)
	end

	modules.game_inventory.GameInventory.lastAddedItem = item

	addEvent(function()
		modules.game_inventory.GameInventory.lastAddedItem = nil
	end)

	if panel == self.currentInventory then
		self:updateCapacityLabel()
		self:applyBankFilter(self.currentFilterType)
	end
end

function GameBank:loadContainer(container, panel)
	self.containers[container:getId()] = panel
	panel.container = container
end

function GameBank:unloadContainer(containerOrId)
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

function GameBank:selectContainer(panel)
	if not panel then
		print("Error: GameBank.selectContainer - Invalid Current Inventory.")

		return
	end

	local container = panel.container

	if not container then
		print("Error: GameBank.selectContainer - Invalid Container.", debug.traceback())

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

	if not self.window:isVisible() and containerType == CONTAINER_TYPE_DEPOT then
		self.show()
	end

	self:updateStorageSelectionPanel(containerType)

	if containerType == CONTAINER_TYPE_INBOX then
		self.itemsPerPage = container:getPageCapacity()
		self.page = container:getCurrentPage()
		self.maxPages = math.floor((container:getSize() - 1) / self.itemsPerPage)

		if self.mainTab.tabPanel ~= self.currentInventory then
			self:selectTab(self.mainTab, true)

			return
		end

		self:hideVaultTabs()
	else
		self:showVaultTabs()
	end

	GameNpc:setPanel("bank")

	local npcNameLabel = GameNpc.window.topPanel:recursiveGetChildById("npcName")
	local npcPreview = GameNpc.window.topPanel:recursiveGetChildById("npcPreview")

	if containerType == CONTAINER_TYPE_HOUSE_DEPOT then
		npcNameLabel:setText("Storage Chest")
		npcNameLabel:setOn(true)
		npcPreview:resetOutfit()
		npcPreview:setImageSource(nil)
		self:hideVaultTabs()
	elseif npcNameLabel:getText() == "Storage Chest" then
		npcNameLabel:setText(self.defaultNpcName)
		npcPreview:setAutoResize(true)
		npcPreview:setScale(1.5)
		npcPreview:setOutfit(self.defaultNpcPreview)
	end

	local height = npcPreview:getHeight() + npcNameLabel:getHeight() + npcNameLabel:getMarginTop() + 10

	GameNpc.window.topPanel:setHeight(height)
	self:refreshContainerItems(panel)
	self:resetFilterPanel()
	self:updateCapacityLabel()
	self:applyBankFilter(self.currentFilterType)

	if not hasConnect(LocalPlayer, "onPositionChange", self.onPlayerPositionChange) then
		connect(LocalPlayer, {
			onPositionChange = self.onPlayerPositionChange
		})
	end

	if containerType == CONTAINER_TYPE_INBOX then
		GameBank:updateContainerPagination()
	end
end

function GameBank:refreshContainerItems(panel)
	if not panel then
		print("Error: GameBank.refreshContainerItems - Invalid panel.")

		return
	end

	local container = panel.container
	local index = 0
	local maxSlots = container and math.max(container:getCapacity() - 1, container:getLastItemIndex()) or 0

	if container and container:hasPages() then
		maxSlots = container:getLastItemIndex()
		index = maxSlots - container:getPageCapacity()
	end

	for _, child in ipairs(panel:getChildren()) do
		child:hide()
	end

	if container then
		for slot = index, maxSlots do
			local itemWidget

			if container:getType() == CONTAINER_TYPE_INBOX then
				itemWidget = panel:getChildByIndex(slot) or g_ui.createWidget("BankItem", panel)
			else
				itemWidget = panel:getChildByIndex(slot + 1) or g_ui.createWidget("BankItem", panel)
			end

			itemWidget:setId(slot)

			itemWidget.position = container:getSlotPosition(slot)

			itemWidget:show()

			local item = container:getInventoryItem(slot)

			if item then
				itemWidget:setItem(item)
			else
				itemWidget:setItem(nil)

				if container:getType() == CONTAINER_TYPE_INBOX then
					itemWidget:hide()
				end
			end

			itemWidget:getChildById("lock"):setVisible(false)
		end
	end

	if container and container:getType() == CONTAINER_TYPE_DEPOT then
		local updgradeConfig = self.upgradeConfigs and self.upgradeConfigs[container:getGuid()]

		updgradeConfig = updgradeConfig or {
			initialSize = self.bankDepotInitialSize,
			slotsPerRow = self.slotsPerRow,
			maxRowsUnlocked = cfg.bank.maxRowsUnlocked,
			silverUnlockRowCost = cfg.bank.baseSilverUnlockCost,
			ravencoinUnlockRowCost = cfg.bank.baseRavencoinCost
		}

		local rows = math.floor((math.max(container:getCapacity(), container:getLastItemIndex()) - updgradeConfig.initialSize) / updgradeConfig.slotsPerRow)

		if panel == self.currentInventory then
			if rows < updgradeConfig.maxRowsUnlocked then
				self.unlockPanel:setVisible(true)

				for i = 1, self.slotsPerRow do
					local itemWidget = self.unlockPanel.slots:getChildByIndex(i) or g_ui.createWidget("BankItem", self.unlockPanel.slots)

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
		if container:getType() ~= CONTAINER_TYPE_INBOX then
			for i = math.max(container:getCapacity(), container:getLastItemIndex() + 1) + 1, panel:getChildCount() do
				local itemWidget = panel:getChildByIndex(i)

				if itemWidget then
					itemWidget:hide()
				end
			end

			self.paginationPanel:hide()
		else
			self.paginationPanel:show()
		end
	end
end

function GameBank:clearContainerItems(panel)
	if not panel then
		print("Error: GameBank.clearContainerItems - Invalid panel.")

		return
	end

	for _, child in ipairs(panel:getChildren()) do
		child:setItem(nil)
		child:hide()
	end
end

function GameBank.onGameStart()
	local self = GameBank

	self.currentInventory = self.mainTab.tabPanel

	self.currentInventory:show()

	if #g_game.getContainers() > 0 and self.currentInventory then
		self.currentInventory.container = g_game.getContainerByType(CONTAINER_TYPE_DEPOT)
		self.containers[self.currentInventory.container:getId()] = self.currentInventory
	end

	local tabBar = self.window.top_panel.content.tab_bar

	if tabBar then
		tabBar:scrollTo(0)
	end

	self:reloadInventory()
end

function GameBank.onGameEnd()
	local self = GameBank

	disconnect(LocalPlayer, {
		onPositionChange = GameBank.onPlayerPositionChange
	})

	if self.purchaseWindow then
		self.purchaseWindow:hide()
	end

	if self.editWindow then
		self.editWindow:hide()
	end

	self:closeContainers()
	self:clearTabs()
end

function GameBank.onPlayerPositionChange()
	local self = GameBank

	if not self.window:isVisible() then
		return
	end

	self:closeContainers()
	GameNpc:onClose()
end

function GameBank.onPlayerLevelChange(localPlayer, level)
	local self = GameBank

	self.addNewTab:setOn(level >= cfg.bank.vaultUnlockLevel)

	if self.addNewTab:isOn() then
		self.addNewTab:setTooltip("Unlock new vault")
	else
		self.addNewTab:setTooltip(string.format("The possibility to add new Bank Vaults will be unlocked at Legacy Level |%s|.", cfg.bank.vaultUnlockLevel))
	end
end

function GameBank:closeContainers()
	for _, panel in pairs(self.containers) do
		if panel.container then
			g_game.close(panel.container)

			panel.container = nil
		end
	end

	if self.mainTab.tabPanel.container then
		g_game.close(self.mainTab.tabPanel.container)

		self.mainTab.tabPanel.container = nil
	end

	if self.currentInventory then
		self.currentInventory:hide()
	end
end

function GameBank:reloadInventory()
	if not self.currentInventory then
		print("Error: GameBank.reloadInventory - Invalid Current Inventory.")

		return
	end

	self:refreshContainerItems(self.currentInventory)
	self:resetFilterPanel()
	self:updateCapacityLabel()
	self:applyBankFilter("all")
end

function GameBank:resetFilterPanel()
	for _, child in ipairs(self.filterPanel:getChildren()) do
		child:setOn(child:getId() == "sort" and child.enablingEvent == nil)
	end
end

function GameBank:updateCapacityLabel()
	local container = self.currentInventory.container

	if not container then
		self.filterPanel:setText("0 / 0")

		return
	end

	if container:getType() == CONTAINER_TYPE_INBOX then
		self.filterPanel:setText(container:getSize() .. " / " .. container:getLastItemIndex() + 1)

		return
	end

	self.filterPanel:setText(container:getSize() .. " / " .. container:getCapacity())
end

function GameBank:applyBankFilter(id)
	for _, child in ipairs(self.currentInventory:getChildren()) do
		if id == "all" then
			child:setEnabled(true)
		else
			local item = child:getItem()
			local filter = modules.game_inventory.cfg.filter[id]

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

function GameBank.onBalanceChange(premium, balance)
	local self = GameBank
	local player = g_game.getLocalPlayer()

	player.silverBalance = balance

	self.bottomPanel.currency.silver:setText(balance)
end

function GameBank:unlockBankSlotsRow()
	if not self.currentInventory then
		print("Error: GameBank.unlockBankSlotsRow - Invalid Current Inventory.")

		return
	end

	if self.confirmationBox then
		self.confirmationBox:raise()
		self.confirmationBox:shake(4, 3)

		return
	end

	local container = self.currentInventory.container

	if not container then
		print("Error: GameBank.unlockBankSlotsRow - Invalid Container.")

		return
	end

	local function yesCallback()
		if not self.currentInventory or not self.currentInventory.container then
			print("Error: GameBank.unlockBankSlotsRow - Invalid Current Inventory.")

			return
		end

		local containerId = self.currentInventory.container:getId()
		local containerGuid = self.currentInventory.container:getGuid()

		if self:isVault(containerGuid) then
			self:sendInventoryTabOpcode({
				action = "vault_unlock_row",
				containerId = containerId
			})
		else
			self:sendOpcode({
				action = "unlock_bank_row",
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
		initialSize = self.bankDepotInitialSize,
		slotsPerRow = self.slotsPerRow,
		silverUnlockRowCost = cfg.bank.baseSilverUnlockCost,
		ravencoinUnlockRowCost = cfg.bank.baseRavencoinCost
	}

	local rows = math.floor((math.max(container:getCapacity(), container:getLastItemIndex()) - updgradeConfig.initialSize) / updgradeConfig.slotsPerRow)
	local cost = updgradeConfig.silverUnlockRowCost[rows + 1] or updgradeConfig.ravencoinUnlockRowCost
	local prefix = updgradeConfig.silverUnlockRowCost[rows + 1] and "Silver" or "RavenCoins"

	self.confirmationBox = displayGeneralBox(tr("Confirm choice"), string.format("You are purchasing |%d| bank slots for |%d| |%s|.\nDo you want to continue?", updgradeConfig.slotsPerRow * cfg.bank.rowsPerUnlock, cost, prefix), {
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

function GameBank:isVault(containerGuid)
	return containerGuid >= cfg.bank.firstVaultId and containerGuid <= cfg.bank.lastVaultId
end

function GameBank:sendInventoryTabOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.InventoryTabs, g_game.serializeTable(data))
	end
end

function GameBank:sendOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.Bank, g_game.serializeTable(data))
	end
end

function GameBank.onSendExtendedOpcode(protocol, opcode, buffer)
	local self = GameBank

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

function GameBank:updateStorageSelectionPanel(containerType)
	if not containerType then
		return
	end

	local storageSelectionPanel = GameNpc.window:recursiveGetChildById("storage_selection_panel")

	if not storageSelectionPanel then
		return
	end

	if containerType == CONTAINER_TYPE_DEPOT or containerType == CONTAINER_TYPE_HOUSE_DEPOT then
		storageSelectionPanel:setVisible(true)
		storageSelectionPanel.left_option:setOn(containerType == CONTAINER_TYPE_DEPOT)
		storageSelectionPanel.right_option:setOn(containerType == CONTAINER_TYPE_HOUSE_DEPOT)

		if containerType == CONTAINER_TYPE_HOUSE_DEPOT then
			if self.mainPanel ~= self.currentInventory then
				self:selectTab(self.mainTab, true)
			end

			self:hideVaultTabs()
		end

		if containerType == CONTAINER_TYPE_HOUSE_DEPOT or GameHouse:playerHasHouseStorage() then
			storageSelectionPanel.right_option.disabled = nil

			storageSelectionPanel.right_option:setTooltip("")
		else
			storageSelectionPanel.right_option.disabled = true

			storageSelectionPanel.right_option:setTooltip("You need to own a house with storage to access this tab.")
		end
	else
		storageSelectionPanel:setVisible(false)
	end

	self.filterPanel.sort:setVisible(containerType ~= CONTAINER_TYPE_INBOX)
end

function GameBank:onChangeStorageSelection()
	local storageSelectionPanel = GameNpc.window:recursiveGetChildById("storage_selection_panel")

	if not storageSelectionPanel then
		return
	end

	local storageType = storageSelectionPanel.left_option:isOn() and "bank" or "house"

	if storageType == "bank" then
		self.unlockPanel:show()
	else
		self.unlockPanel:hide()
	end

	self:closeContainers()
	self:sendOpcode({
		action = "change_storage_selection",
		storageType = storageType
	})

	if storageType == "house" then
		self:hideVaultTabs()

		if self.mainPanel ~= self.currentInventory then
			self:selectTab(self.mainTab, true)
		end
	else
		self:showVaultTabs()
	end
end

function GameBank:changeContainerPage(direction)
	if not self.currentInventory or not self.currentInventory.container then
		print("Error: GameBank.changeContainerPage - Invalid Current Inventory.")

		return
	end

	local max_pages = self.maxPages

	if direction == "next" then
		if max_pages > self.page then
			self.page = self.page + 1
		end
	elseif direction == "previous" then
		if self.page > 0 then
			self.page = self.page - 1
		end
	else
		direction = tonumber(direction)

		if not direction then
			return
		end

		self.page = math.min(math.max(direction, 0), max_pages)
	end

	self:updateContainerPagination()
	g_game.changeContainerPage(self.currentInventory.container, self.page)
end

function GameBank:updateContainerPagination()
	if not self.currentInventory or not self.currentInventory.container then
		print("Error: GameBank.updateContainerPagination - Invalid Current Inventory.")

		return
	end

	local max_pages = self.maxPages

	if max_pages < self.page then
		g_game.changeContainerPage(self.currentInventory.container, max_pages)
	end

	self.page = math.min(self.page, max_pages)

	self.paginationPanel.page_edit:setText(self.page + 1, true)
	self.paginationPanel.page_edit:setCursorPos(-1)
	self.paginationPanel.prev_button:setOn(self.page > 0)
	self.paginationPanel.next_button:setOn(max_pages > self.page)
	self.paginationPanel.prev_button:setEnabled(self.page > 0)
	self.paginationPanel.next_button:setEnabled(max_pages > self.page)
	self.paginationPanel.page_count:setText(tr(string.format("of |%i|", max_pages + 1)))
end

function GameBank:selectTab(tab, scrollTo)
	tab = type(tab) == "number" and self.tabs[tab] or tab

	if not tab then
		print("Error: GameBank.selectTab - Invalid Tab.", tab)

		return
	end

	self.window.top_panel.content.tab_bar:selectTab(tab, false, scrollTo)
end

function GameBank:onTabChange(tab, lastTab)
	local isMain = tab.name:lower() == "main"

	if lastTab and lastTab.bottom_line then
		lastTab.bottom_line:setVisible(false)
	end

	tab.bottom_line:setVisible(true)

	if tab.tabPanel.container then
		self:selectContainer(tab.tabPanel)
	elseif not isMain then
		self:sendInventoryTabOpcode({
			action = "vault_open",
			info = {
				id = tab.id
			}
		})
	end

	self.filterPanel.edit:setVisible(not isMain)

	self.filterPanel.edit.tab = tab
end

function GameBank:addTab(id, name, data)
	local tabBar = self.window.top_panel.content.tab_bar
	local index = #tabBar.tabs - 1
	local tab = tabBar:addTab(name, g_ui.createWidget("GameBankItemsPanel", self.holderPanel), nil, nil, nil, nil, index)

	tab:onTextChange(tab:getText())
	tab.tabPanel:setId(id)

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

function GameBank:clearTabs()
	local tabBar = self.window.top_panel.content.tab_bar

	for _, tab in pairs(self.tabs) do
		if tab and tab.tabPanel.isTab then
			tabBar:removeTab(tab)
			tab:destroy()
		end
	end

	self.tabs = {}
end

function GameBank:acceptPurchaseUnlock()
	self.purchaseWindow:hide()

	self.editWindow.tab = nil

	self.editWindow.content.editVaultContent.categoryComboBox:clearSelectedOptions()
	self.editWindow.content.editVaultContent.nameTextEdit:setTextPreview(string.format("Vault %s", table.size(self.tabs) + 1))
	self.editWindow:raise()
	self.editWindow:show()
end

function GameBank:createOrSaveTab(tab)
	self.purchaseWindow:hide()

	local nameTextEdit = self.editWindow.content.editVaultContent.nameTextEdit
	local name = nameTextEdit:getText()

	if name:empty() then
		name = nameTextEdit:getTextPreview()
	end

	local categoryComboBox = self.editWindow.content.editVaultContent.categoryComboBox
	local categories = {}

	for _, option in ipairs(categoryComboBox:getSelectedOptions()) do
		table.insert(categories, option.data.id)
	end

	tab = tab or self.editWindow.tab

	if tab then
		if tab.name ~= name then
			tab:setText(name)
		end

		self:sendInventoryTabOpcode({
			action = "vault_update",
			info = {
				id = tab.id,
				name = name,
				categories = categories
			}
		})
	else
		self:sendInventoryTabOpcode({
			action = "vault_unlock",
			info = {
				name = name,
				categories = categories
			}
		})
	end
end

function GameBank:onVaultConfigs(data)
	self.upgradeConfigs = data.upgradeConfigs

	if not data.containerConfigs then
		print("Error: GameBank.onVaultConfigs - Invalid Configs.", data.containerConfigs)

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
			print("Error: GameBank.onVaultConfigs - Invalid Id.", config.id)

			return
		elseif not config.name then
			print("Error: GameBank.onVaultConfigs - Invalid Name.", config.name)

			return
		elseif not config.categories then
			print("Error: GameBank.onVaultConfigs - Invalid Categories.", config.categories)

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

	local tabBar = self.window.top_panel.content.tab_bar

	if table.size(self.tabs) >= cfg.bank.vaultLimit then
		tabBar:hideTab(self.addNewTab)
	else
		tabBar:showTab(self.addNewTab)
	end
end

function GameBank:onVaultAdded(data)
	local config = data.config

	if not config then
		print("Error: GameBank.onVaultAdded - Invalid Config.", config)

		return
	elseif not config.id then
		print("Error: GameBank.onVaultAdded - Invalid Id.", config.id)

		return
	end

	local tab = self.tabs[config.id]

	if tab then
		print("Error: GameBank.onVaultAdded - Tab Already Exists.", config.id)

		return
	end

	if not config.name then
		print("Error: GameBank.onVaultAdded - Invalid Name.", config.name)

		return
	elseif not config.categories then
		print("Error: GameBank.onVaultAdded - Invalid Categories.", config.categories)

		return
	end

	self:addTab(config.id, config.name, {
		categories = config.categories
	})
	self.editWindow:hide()
end

function GameBank:onVaultUpdated(data)
	local config = data.config

	if not config then
		print("Error: GameBank.onVaultUpdated - Invalid Config.", config)

		return
	elseif not config.id then
		print("Error: GameBank.onVaultUpdated - Invalid Id.", config.id)

		return
	end

	local tab = self.tabs[config.id]

	if not tab then
		print("Error: GameBank.onVaultAdded - Tab Not Found.", config.id)

		return
	end

	if not config.name then
		print("Error: GameBank.onVaultAdded - Invalid Name.", config.name)

		return
	elseif not config.categories then
		print("Error: GameBank.onVaultAdded - Invalid Categories.", config.categories)

		return
	end

	tab.id = config.id
	tab.name = config.name
	tab.categories = self:convertCategoriesToOptions(config.categories)

	self.editWindow:hide()
end

function GameBank:convertCategoriesToOptions(categories)
	local options = {}

	for _, category in ipairs(categories) do
		local name = cfg.bank.vaultCategoryNameIds[category]

		table.insert(options, {
			text = name,
			data = {
				id = category
			}
		})
	end

	return options
end

function GameBank:editTab(tab)
	if not tab then
		print("Error: GameBank.editTab - Invalid Tab.")

		return
	end

	if not tab.categories then
		print("Error: GameBank.editTab - Invalid Tab Categories.")

		return
	end

	local nameTextEdit = self.editWindow.content.editVaultContent.nameTextEdit

	nameTextEdit:setTextPreview(tab.name)
	nameTextEdit:setText(tab.name)

	local categoryComboBox = self.editWindow.content.editVaultContent.categoryComboBox

	categoryComboBox:setSelectedOptions(tab.categories)

	self.editWindow.tab = tab

	self.editWindow:raise()
	self.editWindow:show()
end

function GameBank:hideVaultTabs()
	self.window.top_panel:setHeight(0)
	self.window.top_panel:hide()
end

function GameBank:showVaultTabs()
	self.window.top_panel:setHeight(self.window.top_panel.defaultHeight)
	self.window.top_panel:show()
end

function GameBank:onCategoryMenuSetup(menu)
	local categories = self:getUsedCategories()

	for _, child in ipairs(menu:getChildren()) do
		if not child:isChecked() then
			local enabled = not child.data or not categories[child.data.id]

			child:setOn(enabled)
			child:setEnabled(enabled)
		end
	end
end

function GameBank:getUsedCategories()
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

function GameBank:sortBank()
	if self.currentInventory then
		modules.game_inventory.GameInventory:sendOpcode({
			action = "bank_reorder",
			containerId = self.currentInventory.container:getId(),
			autoCategorize = g_keyboard.isCtrlPressed()
		})
	else
		print("Error: GameBank.sortBank - Invalid Current Inventory.")
	end
end
