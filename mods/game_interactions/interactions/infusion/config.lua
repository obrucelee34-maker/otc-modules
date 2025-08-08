-- chunkname: @/modules/game_interactions/interactions/infusion/config.lua

__env = __env or {}
quest_name = "Infusion"
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
							text = "Infusing your equipment is the best way to make them stronger and receive more benefits!"
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
					onVisibilityChange_infusion = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local infusionWindow = modules.game_infusion.GameInfusion.window

				if not infusionWindow:isVisible() then
					addEvent(function()
						modules.game_menu.Menu.icon:setOn(true)
					end)

					local parentWidget = modules.game_menu.Menu.window:recursiveGetChildById("infusion")

					GameInteractions:displayActionBox({
						preferSide = "top",
						text = "Press U or Left-Click to open your Infusion menu",
						bandit = true,
						keys = {
							"U",
							MouseLeftButton
						},
						parent = parentWidget
					})
					table.insert(self.disconnects, connect(parentWidget, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(infusionWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_infusion
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
					onVisibilityChange_infusion = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local infusionModule = modules.game_infusion.GameInfusion
				local infusionWindow = infusionModule.window

				if infusionWindow:isVisible() then
					GameInteractions:displayDescriptionBox({
						preferSide = "right",
						bandit = true,
						pages = {
							{
								text = "So, this is where the magic happens!"
							}
						},
						parent = infusionModule.inventory_items_panel.header,
						callbackOnClose = function()
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					})
					table.insert(self.disconnects, connect(infusionWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_infusion
					}))
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_infusion = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				},
				GameInfusion = {
					onItemDrop = function(item)
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				}
			},
			onStartInteraction = function(self)
				local infusionModule = modules.game_infusion.GameInfusion
				local infusionWindow = infusionModule.window

				if not infusionWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				local item_slot = infusionModule.item_slot

				if item_slot.item:getItem() then
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)

					return
				end

				GameInteractions:displayActionBox({
					preferSide = "right",
					text = "Whenever you want to enhance an item with Infusions, you should first select it with a double-click.",
					bandit = true,
					keys = {
						MouseLeftButton
					},
					parent = infusionModule.inventory_items_panel.header
				})
				table.insert(self.disconnects, connect(modules.game_infusion.GameInfusion, {
					onItemDrop = self.callbacks.GameInfusion.onItemDrop
				}))
				table.insert(self.disconnects, connect(infusionWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_infusion
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_infusion = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local infusionModule = modules.game_infusion.GameInfusion
				local infusionWindow = infusionModule.window

				if infusionWindow:isVisible() then
					GameInteractions:displayDescriptionBox({
						preferSide = "top",
						bandit = true,
						pages = {
							{
								text = "This list right here is where everything you want to use as Infusion will be displayed!"
							},
							{
								text = "Infusion stones and scrolls are the best sources of power, but any old gear will do! Isn't that neat?",
								callback = function(self)
									self.newParent = infusionModule.inventory_items_panel
								end
							}
						},
						parent = infusionModule.slot_panel,
						callbackOnClose = function()
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					})
					table.insert(self.disconnects, connect(infusionWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_infusion
					}))
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_infusion = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				},
				GameInfusion = {
					onItemDrop = function(item)
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				}
			},
			onStartInteraction = function(self)
				local infusionModule = modules.game_infusion.GameInfusion
				local infusionWindow = infusionModule.window

				if not infusionWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				local hasItemInSlot = false

				for _, child in ipairs(infusionModule.slot_panel:getChildren()) do
					local childItem = child.item:getItem()

					if childItem then
						hasItemInSlot = true

						break
					end
				end

				if hasItemInSlot then
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)

					return
				end

				GameInteractions:displayActionBox({
					preferSide = "right",
					text = "Double-click to select the item you wanna use to make your gear stronger.",
					bandit = true,
					keys = {
						MouseLeftButton
					},
					parent = infusionModule.inventory_items_panel
				})
				table.insert(self.disconnects, connect(modules.game_infusion.GameInfusion, {
					onSlotItemDrop = self.callbacks.GameInfusion.onItemDrop
				}))
				table.insert(self.disconnects, connect(infusionWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_infusion
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_infusion = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end,
					onVisibilityChange_inventory = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 3)
						end
					end,
					onVisibilityChange_character = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 4)
						end
					end
				},
				GameInfusion = {
					onSlotItemDrop = function(item)
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end,
					onRemoveItem = function(widget)
						if widget == modules.game_infusion.GameInfusion.item_slot.item then
							GameInteractions:advanceInteraction(__env, __env.current_task, 5)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local infusionModule = modules.game_infusion.GameInfusion
				local infusionWindow = infusionModule.window

				if not infusionWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				local inventoryWindow = modules.game_inventory.GameInventory.window

				if not inventoryWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 3)

					return
				end

				local characterWindow = modules.game_character.GameCharacter.window

				if not characterWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 4)

					return
				end

				local item_slot = infusionModule.item_slot

				if not item_slot.item:getItem() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 5)

					return
				end

				for _, child in ipairs(infusionModule.slot_panel:getChildren()) do
					local childItem = child.item:getItem()

					if childItem then
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)

						return
					end
				end

				GameInteractions:displayActionBox({
					preferSide = "top",
					text = "Do the same to a gear or Infusion stone, and drag it into the slots list",
					bandit = true,
					keys = {
						MouseLeftButton
					},
					parent = infusionModule.slot_panel
				})
				table.insert(self.disconnects, connect(modules.game_infusion.GameInfusion, {
					onSlotItemDrop = self.callbacks.GameInfusion.onSlotItemDrop,
					onRemoveItem = self.callbacks.GameInfusion.onRemoveItem
				}))
				table.insert(self.disconnects, connect(infusionWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_infusion
				}))
				table.insert(self.disconnects, connect(inventoryWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_inventory
				}))
				table.insert(self.disconnects, connect(characterWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_character
				}))
			end
		},
		[7] = {
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_infusion = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local infusionModule = modules.game_infusion.GameInfusion
				local infusionWindow = infusionModule.window

				if infusionWindow:isVisible() then
					GameInteractions:displayDescriptionBox({
						preferSide = "top",
						bandit = true,
						pages = {
							{
								text = "Here's a preview of how much stronger the item will get after spending the silver to complete the Infusion..."
							},
							{
								text = "Remember, though, you'll only see the improvement when the item is receiving enough experience to upgrade."
							},
							{
								text = "Infusions grant diverse amounts of experience, but you can always see the total sum here.",
								callback = function(self)
									self.newParent = infusionModule.bottom_panel.values.xp_button
								end
							},
							{
								text = "As well as the total amount of silver you must pay to complete the infusion.",
								callback = function(self)
									self.newParent = infusionModule.bottom_panel.values.silver_button
								end
							},
							{
								text = "When you're satisfied with the shown result, all you gotta do is perform the Infusion and test your improved gear out in the field!",
								callback = function(self)
									self.newParent = infusionModule.infuse_button
								end
							}
						},
						parent = infusionModule.preview_slot,
						callbackOnClose = function()
							GameInteractions:completeInteraction(__env)
						end
					})
					table.insert(self.disconnects, connect(infusionWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_infusion
					}))
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)
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
