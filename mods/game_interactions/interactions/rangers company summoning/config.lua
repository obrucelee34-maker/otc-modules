-- chunkname: @/modules/game_interactions/interactions/rangers company summoning/config.lua

__env = __env or {}
quest_name = "Rangers Company Summoning"
current_task = 0
current_interaction = 0
tasks = {
	{
		{
			disconnects = {},
			callbacks = {},
			onStartInteraction = function(self)
				GameInteractions:displayDescriptionBox({
					pages = {
						{
							text = "Wait, was that a carrier-crow!? I've never seen something like it!"
						}
					},
					parent = GameInteractions.bandit_avatar,
					callbackOnClose = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				})
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						GameInteractions.action_window:setVisible(visible)
					end,
					onVisibilityChange_inventory = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			displayInteraction = function(self)
				local inventoryWindow = modules.game_inventory.GameInventory.window

				if not inventoryWindow:isVisible() then
					addEvent(function()
						modules.game_menu.Menu.icon:setOn(true)
					end)

					local parentWidget = modules.game_menu.Menu.window:recursiveGetChildById("inventory")

					GameInteractions:displayActionBox({
						preferSide = "top",
						text = "Press I or Left-Click to open your Inventory",
						keys = {
							"I",
							MouseLeftButton
						},
						parent = parentWidget
					})
					table.insert(self.disconnects, connect(parentWidget, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(inventoryWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_inventory
					}))
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)
				end
			end,
			onStartInteraction = function(self)
				addEvent(function()
					self.displayInteraction(self)
				end)
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end,
					onVisibilityChange_inventory = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local questPanel = modules.game_inventory.GameInventory.questPanel

				if not questPanel:isVisible() then
					GameInteractions:displayActionBox({
						preferSide = "right",
						text = "Left-Click on the Quest Bag to open it",
						keys = {
							MouseLeftButton
						},
						parent = modules.game_inventory.GameInventory.questTab
					})
					modules.game_inventory.GameInventory:selectTab(InventorySlotBack, false, true, true)
					table.insert(self.disconnects, connect(questPanel, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
				else
					modules.game_inventory.GameInventory:selectTab(InventorySlotQuestPouch, false, true)
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
				end

				local inventoryWindow = modules.game_inventory.GameInventory.window

				if not inventoryWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)
				else
					table.insert(self.disconnects, connect(inventoryWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_inventory
					}))
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIItem = {
					onItemChange = function(item)
						item.preventDragItem = nil
					end
				},
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end,
					onVisibilityChange_questPanel = function(widget, visible)
						addEvent(function()
							modules.game_inventory.GameInventory:selectTab(InventorySlotQuestPouch, false, true)
						end)
					end
				},
				g_game = {
					onUse = function(pos, itemId)
						if itemId == 39433 then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			displayInteraction = function(self)
				local inventoryWindow = modules.game_inventory.GameInventory.window

				if inventoryWindow:isVisible() then
					local parentWidget = modules.game_inventory.GameInventory:findItemWidgetByName("questPanel", "rangers summoning")

					if parentWidget then
						parentWidget.preventDragItem = true

						GameInteractions:displayActionBox({
							preferSide = "top",
							text = "It looks like a summoning letter!? I wonder who's that from...",
							keys = {
								MouseRightButton
							},
							parent = parentWidget
						})
						table.insert(self.disconnects, connect(parentWidget, {
							onItemChange = self.callbacks.UIItem.onItemChange
						}))
						table.insert(self.disconnects, connect(modules.game_inventory.GameInventory.questPanel, {
							onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_questPanel
						}))
					end

					table.insert(self.disconnects, connect(modules.game_inventory.GameInventory.window, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)
				end
			end,
			onStartInteraction = function(self)
				table.insert(self.disconnects, connect(g_game, {
					onUse = self.callbacks.g_game.onUse
				}))

				local inventoryWindow = modules.game_inventory.GameInventory.window

				if not inventoryWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)
				else
					addEvent(function()
						modules.game_inventory.GameInventory:selectTab(InventorySlotBack, false, true, true)
					end)
					table.insert(self.disconnects, connect(g_game, {
						onRefreshItems = function()
							self:displayInteraction()
						end
					}))
				end
			end
		}
	}
}
callbacks = {
	onCustomInteraction = function(data)
		if current_task ~= data.stage then
			GameInteractions:closeActionBox()
			GameInteractions:closeDescriptionBox()
			GameInteractions:advanceInteraction(__env, data.stage or 1, 0)
		else
			GameInteractions:advanceInteraction(__env, data.stage or 1, data.interaction or 0)
		end
	end,
	onTaskUpdate = function(task)
		return
	end,
	onGameStart = function()
		return
	end,
	onGameEnd = function()
		return
	end
}
