-- chunkname: @/modules/game_interactions/interactions/trinket/config.lua

__env = __env or {}
quest_name = "Trinket"
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
							text = "Oh, I see your bag is getting more and more stuffed!"
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
							GameInteractions:advanceInteraction(__env, __env.current_task, 3)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local player = g_game.getLocalPlayer()
				local equippedTrinket = player:getInventoryItem(InventorySlotTrinket)

				if equippedTrinket then
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
					GameInteractions:advanceInteraction(__env, __env.current_task, 3)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_character = function(self, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 3)
						end
					end
				}
			},
			onStartInteraction = function(self)
				modules.game_inventory.GameInventory:selectTab(InventorySlotBack, false, true, true)

				local player = g_game.getLocalPlayer()
				local equippedTrinket = player:getInventoryItem(InventorySlotTrinket)

				if not equippedTrinket then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				local characterWindow = modules.game_character.GameCharacter.window

				if not characterWindow:isVisible() then
					addEvent(function()
						modules.game_menu.Menu.icon:setOn(true)
					end)

					local parentWidget = modules.game_menu.Menu.window:recursiveGetChildById("character")

					GameInteractions:displayActionBox({
						preferSide = "top",
						text = "Press X or Left-Click to open your Character menu",
						bandit = true,
						keys = {
							"X",
							MouseLeftButton
						},
						parent = parentWidget
					})
					table.insert(self.disconnects, connect(characterWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_character
					}))
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, 3)
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

				local tab, child = modules.game_inventory.GameInventory:findItemTabByItemType("trinket")

				if not tab then
					GameInteractions:completeInteraction(__env)
					GameNotification:display(NOTIFICATION_ERROR, nil, "You don't have any trinket, interaction was cancelled.")

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
							text = "And move to the bag where your new item is!",
							keys = {
								MouseLeftButton
							},
							parent = scroll
						})
					else
						GameInteractions:displayActionBox({
							preferSide = "top",
							text = "And move to the bag where your new item is!",
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
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end,
					onVisibilityChange_character = function(self, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end,
					onDragEnter = function(widget)
						widget.draggingLock = g_clock.millis() + 100

						return false
					end
				},
				UIItem = {
					onItemChange = function(self, item, oldItem)
						scheduleEvent(function()
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end, 1000)
					end
				}
			},
			onStartInteraction = function(self)
				self:displayInventoryInteraction()

				local player = g_game.getLocalPlayer()
				local equippedTrinket = player:getInventoryItem(InventorySlotTrinket)

				if equippedTrinket then
					local characterWindow = modules.game_character.GameCharacter.window

					if not characterWindow:isVisible() then
						GameInteractions:advanceInteraction(__env, __env.current_task, 1)

						return
					end

					modules.game_character.GameCharacter:selectTab("equipment")

					local itemSlot = characterWindow:recursiveGetChildById("trinket")

					GameInteractions:displayDescriptionBox({
						bandit = true,
						pages = {
							{
								text = "This is what's called a trinket!"
							},
							{
								text = "And it's not just a simple gear, as they give you a unique bonus!"
							},
							{
								text = "Some trinkets have passive effects, meaning you can benefit from them just by having it equipped"
							},
							{
								text = "But other effects must be activated through the action bar"
							},
							{
								text = "Just keep in mind active effects have a cooldown time, So you have to wait a while before using them again!"
							},
							{
								text = "To equip a trinket, just (right-click) it like any other gear"
							},
							{
								text = "Make sure you test every trinket you receive in the future. It's the only way to learn which one suits you the best!"
							}
						},
						parent = itemSlot,
						callbackOnClose = function()
							GameInteractions:completeInteraction(__env)
						end
					})
					table.insert(self.disconnects, connect(characterWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_character
					}))
					table.insert(self.disconnects, connect(itemSlot, {
						onDragEnter = self.callbacks.UIWidget.onDragEnter,
						onItemChange = self.callbacks.UIItem.onItemChange
					}, true))
				else
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

				local tab, child = modules.game_inventory.GameInventory:findItemTabByItemType("trinket")

				if not tab or not child then
					GameInteractions:completeInteraction(__env)
					GameNotification:display(NOTIFICATION_ERROR, nil, "You don't have any trinket, interaction was cancelled.")

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
							text = "This is what's called a trinket!"
						},
						{
							text = "And it's not just a simple gear, as they give you a unique bonus!"
						},
						{
							text = "Some trinkets have passive effects, meaning you can benefit from them just by having it equipped"
						},
						{
							text = "But other effects must be activated through the action bar"
						},
						{
							text = "Just keep in mind active effects have a cooldown time, So you have to wait a while before using them again!"
						},
						{
							text = "To equip a trinket, just (right-click) it like any other gear"
						},
						{
							text = "Make sure you test every trinket you receive in the future. It's the only way to learn which one suits you the best!"
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
				table.insert(self.disconnects, connect(inventoryWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_inventory
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
