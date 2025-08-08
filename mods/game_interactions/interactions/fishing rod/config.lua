-- chunkname: @/modules/game_interactions/interactions/fishing rod/config.lua

__env = __env or {}
quest_name = "Fishing Rod"
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
							text = tr("Hey, %s. That's a fishing rod that you're carrying, isn't it?", g_game.getCharacterName())
						},
						{
							text = "Did you know you have a specific slot for that, along with your gear?"
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
					onVisibilityChange_inventory = function(self, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 2)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local player = g_game.getLocalPlayer()
				local equippedFishingRod = player:getInventoryItem(InventorySlotFishingRod)

				if equippedFishingRod then
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)

					return
				end

				local inventoryWindow = modules.game_inventory.GameInventory.window

				if not inventoryWindow:isVisible() then
					addEvent(function()
						modules.game_menu.Menu.icon:setOn(true)
					end)

					local parentWidget = modules.game_menu.Menu.window:recursiveGetChildById("inventory")

					GameInteractions:displayActionBox({
						preferSide = "top",
						text = "Press I or Left-Click to open your Inventory menu",
						bandit = true,
						keys = {
							"I",
							MouseLeftButton
						},
						parent = parentWidget
					})
					table.insert(self.disconnects, connect(inventoryWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_inventory
					}))
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, 2)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end,
					onVisibilityChange_inventory = function(self, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						else
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			onStartInteraction = function(self)
				table.insert(self.disconnects, connect(g_game, {
					onRefreshItems = function()
						self:displayInventoryInteraction()
					end,
					onTabBarScroll = function()
						self:displayInventoryInteraction()
					end
				}))
			end,
			displayInventoryInteraction = function(self)
				local inventoryWindow = modules.game_inventory.GameInventory.window

				if not inventoryWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				local tab, child = modules.game_inventory.GameInventory:findItemTabByItemType("fishing rod")

				if not tab then
					GameInteractions:completeInteraction(__env)
					GameNotification:display(NOTIFICATION_ERROR, nil, "You don't have any fishing rod, interaction was cancelled.")

					return
				end

				local itemTab

				if type(tab.id) == "number" then
					if tab.id == InventorySlotBack then
						itemTab = modules.game_inventory.GameInventory.mainTab
					elseif tab.id == InventorySlotQuestPouch then
						itemTab = modules.game_inventory.GameInventory.questTab
					else
						itemTab = modules.game_inventory.GameInventory.tabs[tab.id]
					end
				end

				if not itemTab then
					GameNotification:display(NOTIFICATION_ERROR, nil, "An error ocurred, interaction was cancelled.")

					return
				end

				if not itemTab.tabPanel:isVisible() then
					local margin, direction = modules.game_inventory.GameInventory:isTabBarVisible(tab.tabBar, tab.id)

					if margin ~= 0 then
						local parent = tab.tabBar:getParent():getParent()
						local scroll

						if direction == "right" then
							scroll = parent.scroll_right
						elseif direction == "left" then
							scroll = parent.scroll_left
						else
							GameNotification:display(NOTIFICATION_ERROR, nil, "An error ocurred, interaction was cancelled.")

							return
						end

						GameInteractions:displayActionBox({
							preferSide = "top",
							text = "And move to the bag where your items are located.",
							keys = {
								MouseLeftButton
							},
							parent = scroll
						})
					else
						GameInteractions:displayActionBox({
							preferSide = "top",
							text = "And move to the bag where your items are located.",
							keys = {
								MouseLeftButton
							},
							parent = itemTab
						})
					end

					table.insert(self.disconnects, connect(modules.game_inventory.GameInventory.window, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(itemTab.tabPanel, {
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
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end,
					onVisibilityChange_inventory = function(self, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 2)
						end
					end
				},
				UIItem = {
					onItemChange = function(self, item, oldItem)
						scheduleEvent(function()
							GameInteractions:advanceInteraction(__env, __env.current_task, 4)
						end, 1000)
					end
				}
			},
			onStartInteraction = function(self)
				local player = g_game.getLocalPlayer()
				local equippedFishingRod = player:getInventoryItem(InventorySlotFishingRod)

				if equippedFishingRod then
					GameInteractions:advanceInteraction(__env, __env.current_task, 4)
				else
					self:displayInventoryInteraction()
					table.insert(self.disconnects, connect(g_game, {
						onRefreshItems = function()
							self:displayInventoryInteraction()
						end
					}))
				end
			end,
			displayInventoryInteraction = function(self)
				local inventoryWindow = modules.game_inventory.GameInventory.window

				if not inventoryWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				local tab, child = modules.game_inventory.GameInventory:findItemTabByItemType("fishing rod")

				if not tab or not child then
					GameInteractions:completeInteraction(__env)
					GameNotification:display(NOTIFICATION_ERROR, nil, "You don't have any fishing rod, interaction was cancelled.")

					return
				end

				local itemTab

				if type(tab.id) == "number" then
					if tab.id == InventorySlotBack then
						itemTab = modules.game_inventory.GameInventory.mainTab
					elseif tab.id == InventorySlotQuestPouch then
						itemTab = modules.game_inventory.GameInventory.questTab
					else
						itemTab = modules.game_inventory.GameInventory.tabs[tab.id]
					end
				end

				if not itemTab then
					GameNotification:display(NOTIFICATION_ERROR, nil, "An error ocurred, interaction was cancelled.")

					return
				end

				local parentPanel = child:getParent():getParent()

				parentPanel:ensureChildVisible(child)
				GameInteractions:displayActionBox({
					preferSide = "top",
					text = " Right-click the fishing rod in order to equip them!",
					bandit = true,
					keys = {
						MouseRightButton
					},
					parent = child
				})
				table.insert(self.disconnects, connect(parentPanel.verticalScrollBar, {
					onValueChange = function()
						parentPanel:ensureChildVisible(child)
					end
				}))
				table.insert(self.disconnects, connect(child, {
					onItemChange = self.callbacks.UIItem.onItemChange
				}, true))
				table.insert(self.disconnects, connect(modules.game_inventory.GameInventory.window, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
				}))
				table.insert(self.disconnects, connect(itemTab.tabPanel, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_inventory
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_inventory = function(self, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local player = g_game.getLocalPlayer()
				local equippedFishingHook = player:getInventoryItem(InventorySlotFishingHook)

				if equippedFishingHook then
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)

					return
				end

				local inventoryWindow = modules.game_inventory.GameInventory.window

				if not inventoryWindow:isVisible() then
					addEvent(function()
						modules.game_menu.Menu.icon:setOn(true)
					end)

					local parentWidget = modules.game_menu.Menu.window:recursiveGetChildById("inventory")

					GameInteractions:displayActionBox({
						preferSide = "top",
						text = "Press I or Left-Click to open your Inventory menu",
						bandit = true,
						keys = {
							"I",
							MouseLeftButton
						},
						parent = parentWidget
					})
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
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end,
					onVisibilityChange_inventory = function(self, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						else
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			onStartInteraction = function(self)
				self:displayInventoryInteraction()
				table.insert(self.disconnects, connect(g_game, {
					onRefreshItems = function()
						self:displayInventoryInteraction()
					end,
					onTabBarScroll = function()
						self:displayInventoryInteraction()
					end
				}))
			end,
			displayInventoryInteraction = function(self)
				local inventoryWindow = modules.game_inventory.GameInventory.window

				if not inventoryWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				local tab, child = modules.game_inventory.GameInventory:findItemTabByItemType("fishing hook")

				if not tab then
					GameInteractions:completeInteraction(__env)
					GameNotification:display(NOTIFICATION_ERROR, nil, "You don't have any fishing hook, interaction was cancelled.")

					return
				end

				local itemTab

				if type(tab.id) == "number" then
					if tab.id == InventorySlotBack then
						itemTab = modules.game_inventory.GameInventory.mainTab
					elseif tab.id == InventorySlotQuestPouch then
						itemTab = modules.game_inventory.GameInventory.questTab
					else
						itemTab = modules.game_inventory.GameInventory.tabs[tab.id]
					end
				end

				if not itemTab then
					GameNotification:display(NOTIFICATION_ERROR, nil, "An error ocurred, interaction was cancelled.")

					return
				end

				if not itemTab.tabPanel:isVisible() then
					local margin, direction = modules.game_inventory.GameInventory:isTabBarVisible(tab.tabBar, tab.id)

					if margin ~= 0 then
						local parent = tab.tabBar:getParent():getParent()
						local scroll

						if direction == "right" then
							scroll = parent.scroll_right
						elseif direction == "left" then
							scroll = parent.scroll_left
						else
							GameNotification:display(NOTIFICATION_ERROR, nil, "An error ocurred, interaction was cancelled.")

							return
						end

						GameInteractions:displayActionBox({
							preferSide = "top",
							text = "Now move to this bag, where your fishing hook is.",
							keys = {
								MouseLeftButton
							},
							parent = scroll
						})
					else
						GameInteractions:displayActionBox({
							preferSide = "top",
							text = "Now move to this bag, where your fishing hook is.",
							keys = {
								MouseLeftButton
							},
							parent = itemTab
						})
					end

					table.insert(self.disconnects, connect(modules.game_inventory.GameInventory.window, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(itemTab.tabPanel, {
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
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end,
					onVisibilityChange_inventory = function(self, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 5)
						end
					end
				},
				UIItem = {
					onItemChange = function(self, item, oldItem)
						scheduleEvent(function()
							GameInteractions:advanceInteraction(__env, __env.current_task, 7)
						end, 1000)
					end
				}
			},
			onStartInteraction = function(self)
				local player = g_game.getLocalPlayer()
				local equippedFishingHook = player:getInventoryItem(InventorySlotFishingHook)

				if equippedFishingHook then
					GameInteractions:advanceInteraction(__env, __env.current_task, 5)
				else
					self:displayInventoryInteraction()
					table.insert(self.disconnects, connect(g_game, {
						onRefreshItems = function()
							self:displayInventoryInteraction()
						end
					}))
				end
			end,
			displayInventoryInteraction = function(self)
				local inventoryWindow = modules.game_inventory.GameInventory.window

				if not inventoryWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				local tab, child = modules.game_inventory.GameInventory:findItemTabByItemType("fishing hook")

				if not tab or not child then
					GameInteractions:completeInteraction(__env)
					GameNotification:display(NOTIFICATION_ERROR, nil, "You don't have any fishing hook, interaction was cancelled.")

					return
				end

				local itemTab

				if type(tab.id) == "number" then
					if tab.id == InventorySlotBack then
						itemTab = modules.game_inventory.GameInventory.mainTab
					elseif tab.id == InventorySlotQuestPouch then
						itemTab = modules.game_inventory.GameInventory.questTab
					else
						itemTab = modules.game_inventory.GameInventory.tabs[tab.id]
					end
				end

				if not itemTab then
					GameNotification:display(NOTIFICATION_ERROR, nil, "An error ocurred, interaction was cancelled.")

					return
				end

				local parentPanel = child:getParent():getParent()

				parentPanel:ensureChildVisible(child)
				GameInteractions:displayActionBox({
					preferSide = "top",
					text = "Now equip the fishing hook with a right-click as well",
					bandit = true,
					keys = {
						MouseRightButton
					},
					parent = child
				})
				table.insert(self.disconnects, connect(parentPanel.verticalScrollBar, {
					onValueChange = function()
						parentPanel:ensureChildVisible(child)
					end
				}))
				table.insert(self.disconnects, connect(child, {
					onItemChange = self.callbacks.UIItem.onItemChange
				}, true))
				table.insert(self.disconnects, connect(modules.game_inventory.GameInventory.window, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
				}))
				table.insert(self.disconnects, connect(itemTab.tabPanel, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_inventory
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {},
			onStartInteraction = function(self)
				GameInteractions:displayDescriptionBox({
					pages = {
						{
							text = "These may be quite rustic, but I'm sure you can find or even craft better ones with time"
						},
						{
							text = "Well, you're all equipped, now!"
						},
						{
							text = "So all you've gotta do is toss the line into the water above a school of fish"
						},
						{
							text = "Sooner or later, one will bite!"
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
