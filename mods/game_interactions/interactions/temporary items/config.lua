-- chunkname: @/modules/game_interactions/interactions/temporary items/config.lua

__env = __env or {}
quest_name = "Temporary Items"
current_task = 0
current_interaction = 0
tasks = {
	{
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
			onStartInteraction = function(self)
				local slot, slotWidget = AbilityBar.getSlotByName(AbilityBarCategorySpell, "rusty old trap")

				if slot and slotWidget then
					return GameInteractions:completeInteraction(__env)
				end

				local inventoryWindow = modules.game_inventory.GameInventory.window

				if not inventoryWindow:isVisible() then
					addEvent(function()
						modules.game_menu.Menu.icon:setOn(true)
					end)

					local parentWidget = modules.game_menu.Menu.window:recursiveGetChildById("inventory")

					GameInteractions:displayActionBox({
						preferSide = "top",
						text = "This quest requires a special item! Press I or left-click to open your inventory",
						bandit = true,
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
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
				end
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
							GameInteractions:advanceInteraction(__env, __env.current_task, 0)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local questPanel = modules.game_inventory.GameInventory.questPanel

				if not questPanel:isVisible() then
					GameInteractions:displayActionBox({
						preferSide = "right",
						text = "Left-Click to check your Quest Items!",
						bandit = true,
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
					GameInteractions:advanceInteraction(__env, __env.current_task, 0)
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
							GameInteractions:advanceInteraction(__env, __env.current_task, 0)
						end
					end,
					onVisibilityChange_questPanel = function(widget, visible)
						addEvent(function()
							modules.game_inventory.GameInventory:selectTab(InventorySlotQuestPouch, false, true)
						end)
					end
				},
				AbilityBar = {
					onAddItem = function(self, clientId, index)
						if clientId == 37125 then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			displayInteraction = function(self)
				local inventoryWindow = modules.game_inventory.GameInventory.window

				if inventoryWindow:isVisible() then
					local parentWidget = modules.game_inventory.GameInventory:findItemWidgetByName("questPanel", "rusty old trap")

					if parentWidget then
						parentWidget.preventDragItem = true

						GameInteractions:displayActionBox({
							preferSide = "top",
							text = "This is the item I was talking about. Right click and add it to the action bar",
							bandit = true,
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
						table.insert(self.disconnects, connect(AbilityBar, {
							onAddItem = self.callbacks.AbilityBar.onAddItem
						}))
					end

					table.insert(self.disconnects, connect(modules.game_inventory.GameInventory.window, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, 0)
				end
			end,
			onStartInteraction = function(self)
				local inventoryWindow = modules.game_inventory.GameInventory.window

				if not inventoryWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 0)
				else
					local slot, slotWidget = AbilityBar.getSlotByName(AbilityBarCategorySpell, "rusty old trap")

					if slot and slotWidget then
						return GameInteractions:advanceInteraction(__env, __env.current_task, 3)
					end

					addEvent(function()
						modules.game_inventory.GameInventory:selectTab(InventorySlotQuestPouch, false, true)
					end)
					table.insert(self.disconnects, connect(g_game, {
						onRefreshItems = function()
							self:displayInteraction()
						end
					}))
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			displayInteraction = function()
				GameInteractions:displayActionBox({
					text = "Press I or Esc to close your Inventory",
					keys = {
						"I",
						"Esc"
					},
					parent = modules.game_inventory.GameInventory.window.top_panel.close_button
				})
			end,
			onStartInteraction = function(self)
				if modules.game_inventory.GameInventory.window:isVisible() then
					self.displayInteraction()
					table.insert(self.disconnects, connect(modules.game_inventory.GameInventory.window.top_panel, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {},
			onStartInteraction = function(self)
				GameInteractions:displayDescriptionBox({
					pages = {
						{
							text = "Some quest items are only available during certain quests, others will be with you for the rest of your adventure!"
						}
					},
					parent = GameInteractions.bandit_avatar,
					callbackOnClose = function()
						GameInteractions:completeInteraction(__env)
					end
				})
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
