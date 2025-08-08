-- chunkname: @/modules/game_npcs/warehouse.lua

PortWarehouse = {}

function PortWarehouse.onGameEnd()
	PortWarehouse:resetInfo()
end

function PortWarehouse:isVisible()
	return self.window and self.window:isVisible()
end

function PortWarehouse:init()
	connect(g_game, {
		onGameEnd = self.onGameEnd
	})

	self.window = GameNpc.panels[windowTypes.warehouse]

	self.window:setVisible(false)
end

function PortWarehouse:terminate()
	self.window:destroy()
	disconnect(g_game, {
		onGameStart = self.onGameStart
	})

	PortWarehouse = nil
end

function PortWarehouse:resetInfo()
	local playerPanel = self.window:recursiveGetChildById("playerPanel")
	local warehousePanel = self.window:recursiveGetChildById("warehousePanel")

	if not table.empty(playerPanel.items:getChildren()) then
		playerPanel.items:destroyChildren()
	end

	if not table.empty(warehousePanel.items:getChildren()) then
		warehousePanel.items:destroyChildren()
	end
end

function PortWarehouse:onResize()
	if not self.window then
		return
	end
end

function PortWarehouse:onOpen(data)
	local localPlayer = g_game.getLocalPlayer()

	if not localPlayer or type(data) ~= "table" then
		return
	end

	local npcPreview = GameNpc.window.topPanel:recursiveGetChildById("npcPreview")
	local playerPanel = self.window:recursiveGetChildById("playerPanel")
	local warehousePanel = self.window:recursiveGetChildById("warehousePanel")

	playerPanel.topPanel.outfit:setOutfit(localPlayer:getOutfit())
	playerPanel.topPanel.name:setText(localPlayer:getName():upper())
	warehousePanel.topPanel.outfit:setOutfit(npcPreview:getOutfit())
	self:resetInfo()

	local tradepacks = data.tradepacks

	for index, pack in ipairs(tradepacks.player.packs) do
		local widget = g_ui.createWidget("GameWarehouseItem", playerPanel.items)

		widget:setTradepack(pack)

		function widget:onDragDrop(widget)
			local item = widget and widget:isItem() and widget:getItem()
			local droppedWidget = self:getItem()

			if item and droppedWidget then
				GameNpc:sendOpcode({
					option = "warehouse_switch_index",
					action = "dialogue",
					dialogueId = GameNpc.dialogueId,
					npcName = GameNpc.npcName,
					pack = {
						uid = item.tooltipInfo.uid,
						targetUid = droppedWidget.tooltipInfo.uid
					}
				})
			elseif droppedWidget and widget and widget:isItem() then
				self.onClick()
			end
		end

		widget.clickSound = true

		function widget.onClick()
			GameNpc:sendOpcode({
				option = "warehouse_deposit",
				action = "dialogue",
				dialogueId = GameNpc.dialogueId,
				npcName = GameNpc.npcName,
				pack = {
					uid = pack.uid
				}
			})
		end
	end

	for index, pack in ipairs(tradepacks.warehouse.packs) do
		local widget = g_ui.createWidget("GameWarehouseItem", warehousePanel.items)

		widget:setTradepack(pack)

		function widget:onDragDrop(widget)
			local item = widget and widget:isItem() and widget:getItem()
			local droppedWidget = self:getItem()

			if item and droppedWidget then
				GameNpc:sendOpcode({
					option = "warehouse_switch_index",
					action = "dialogue",
					dialogueId = GameNpc.dialogueId,
					npcName = GameNpc.npcName,
					pack = {
						uid = item.tooltipInfo.uid,
						targetUid = droppedWidget.tooltipInfo.uid
					}
				})
			elseif droppedWidget and widget and widget:isItem() then
				self.onClick()
			end
		end

		widget.clickSound = true

		function widget.onClick()
			GameNpc:sendOpcode({
				option = "warehouse_withdraw",
				action = "dialogue",
				dialogueId = GameNpc.dialogueId,
				npcName = GameNpc.npcName,
				pack = {
					uid = pack.uid
				}
			})
		end
	end

	local minSize = 10

	for p = 1, 2 do
		local panel = p == 1 and playerPanel.items or warehousePanel.items
		local size = #panel:getChildren()
		local size, maxCapacity = size, p == 1 and tradepacks.player.maxCapacity or tradepacks.warehouse.maxCapacity

		if size < minSize then
			for i = 1, minSize - size do
				g_ui.createWidget("GameWarehouseItem", panel)
			end
		end

		local children = panel:getChildren()

		for i = 1, #children do
			children[i]:setEnabled(i <= maxCapacity)
		end
	end

	GameNpc:setTopPanelOn(false)
	GameNpc:setPanel("warehouse")
end
