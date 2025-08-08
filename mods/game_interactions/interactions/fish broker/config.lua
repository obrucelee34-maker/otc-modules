-- chunkname: @/modules/game_interactions/interactions/fish broker/config.lua

__env = __env or {}
quest_name = "Fish Broker"
display_name = "Fishpost"
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
							text = "You caught it! You've got a fresh flopping fish on your back. Yum!"
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
					onVisibilityChange_inventory = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			onStartInteraction = function(self)
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

				local tab, child = modules.game_inventory.GameInventory:findItemTabByName("shrimp")

				if not tab then
					GameInteractions:completeInteraction(__env)
					GameNotification:display(NOTIFICATION_ERROR, nil, "You don't have any shrimp, interaction was cancelled.")

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
							text = "And navigate to the bag where your catch is located!",
							keys = {
								MouseLeftButton
							},
							parent = scroll
						})
					else
						GameInteractions:displayActionBox({
							preferSide = "top",
							text = "And navigate to the bag where your catch is located!",
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
				}
			},
			onStartInteraction = function(self)
				self:displayInventoryInteraction()
				table.insert(self.disconnects, connect(g_game, {
					onRefreshItems = function()
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

				local tab, child = modules.game_inventory.GameInventory:findItemTabByName("shrimp")

				if not tab or not child then
					GameInteractions:completeInteraction(__env)
					GameNotification:display(NOTIFICATION_ERROR, nil, "You don't have any shrimp, interaction was cancelled.")

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
				GameInteractions:displayDescriptionBox({
					bandit = true,
					pages = {
						{
							text = "You can sell your catch at the closest Fishpost. Most ports have them nearby!",
							callback = function(self)
								self.bandit = true
								self.newParent = child
							end
						},
						{
							text = "But you can also use their services to create ingredients for cooking and alchemy!",
							callback = function(self)
								self.bandit = true
							end
						}
					},
					parent = child,
					callbackOnClose = function()
						GameInteractions:completeInteraction(__env)
					end
				})
				table.insert(self.disconnects, connect(parentPanel.verticalScrollBar, {
					onValueChange = function()
						parentPanel:ensureChildVisible(child)
					end
				}))
				table.insert(self.disconnects, connect(modules.game_inventory.GameInventory.window, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
				}))
				table.insert(self.disconnects, connect(itemTab.tabPanel, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_inventory
				}))
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
