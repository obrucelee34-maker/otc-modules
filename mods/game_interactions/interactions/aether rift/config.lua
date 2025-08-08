-- chunkname: @/modules/game_interactions/interactions/aether rift/config.lua

__env = __env or {}
quest_name = "Aether Rift"
current_task = 0
current_interaction = 0
tasks = {
	{
		{
			disconnects = {},
			callbacks = {},
			onStartInteraction = function(self)
				GameInteractions:displayDescriptionBox({
					preferSide = "right",
					pages = {
						{
							text = tr(string.format("Can you feel this strange energy, |%s|? I think it's coming from your bag!", g_game.getCharacterName()))
						},
						{
							text = "",
							callback = function()
								GameInteractions:closeDescriptionBox(true)
							end
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
						text = "Open your Inventory by pressing",
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
					onVisibilityChange_questPanel = function(widget, visible)
						if not visible then
							GameInteractions:displayActionBox({
								preferSide = "right",
								text = "And examine your Quest Items.",
								keys = {
									MouseLeftButton
								},
								parent = modules.game_inventory.GameInventory.questTab
							})
						else
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

				table.insert(self.disconnects, connect(questPanel, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_questPanel
				}))

				if questPanel:isVisible() then
					modules.game_inventory.GameInventory:selectTab(InventorySlotBack, false, true, true)
				else
					self.callbacks.UIWidget.onVisibilityChange_questPanel(questPanel, false)
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
					onVisibilityChange_inventory = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end,
					onVisibilityChange_questPanel = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 2)
						end
					end,
					onVisibilityChange_aetherRiftWindow = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			displayInteraction = function(self)
				local inventoryWindow = modules.game_inventory.GameInventory.window

				if inventoryWindow:isVisible() then
					local parentWidget = modules.game_inventory.GameInventory:findItemWidgetByName("questPanel", "aether essence trap")

					if parentWidget then
						parentWidget.preventDragItem = true

						GameInteractions:displayDescriptionBox({
							preferSide = "right",
							pages = {
								{
									text = "That's it! You've stumbled upon an Aether Essence Trap!"
								},
								{
									text = "",
									callback = function()
										GameInteractions:closeDescriptionBox(true)
									end
								}
							},
							parent = parentWidget,
							callbackOnClose = function()
								local hotkeyCombo = GameHotkeyManager:getHotkeyMainKeyCombo(HOTKEYS_IDS.AETHER_RIFT, "Not assigned")

								GameInteractions:displayActionBox({
									preferSide = "right",
									keys = {
										MouseRightButton,
										hotkeyCombo
									},
									text = tr(string.format("You may open it by right-clicking the item or pressing (|%s|).", hotkeyCombo)),
									parent = parentWidget
								})
							end
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
				local aetherRiftWindow = modules.game_aether_rift.GameAetherRift.window

				if aetherRiftWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)

					return
				end

				table.insert(self.disconnects, connect(aetherRiftWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_aetherRiftWindow
				}))

				local inventoryWindow = modules.game_inventory.GameInventory.window

				if not inventoryWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)
				elseif not modules.game_inventory.GameInventory.questPanel:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 2)
				else
					table.insert(self.disconnects, connect(g_game, {
						onRefreshItems = function()
							self:displayInteraction()
						end
					}))
					self:displayInteraction()
					table.insert(self.disconnects, connect(inventoryWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_inventory
					}))
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_aetherRiftWindow = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 3)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local riftWindow = modules.game_aether_rift.GameAetherRift.window

				table.insert(self.disconnects, connect(riftWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_aetherRiftWindow
				}))
				GameInteractions:displayDescriptionBox({
					preferSide = "right",
					pages = {
						{
							text = tr("These devices were created by the Lorekeep, and you can use it to create a passage to an Aether Rift!")
						},
						{
							text = tr("But only if you've stored enough charges from destroying Aether Stones.")
						},
						{
							text = tr("Beware, Aether Rifts are dangerous places, where powerful creatures lurk!")
						},
						{
							text = tr("And if you manage to make your way through it, I'm sure there will be valuable rewards waiting for you!")
						},
						{
							text = tr("But be careful now? This means you'll not be the only one after them!")
						},
						{
							text = tr("There are many rival adventurers that will be pursuing these rewards and you won't be certain if the Rift you invaded is empty or not!")
						},
						{
							text = tr("You must be ready to fight them because only one side will emerge triumphant!")
						},
						{
							text = "",
							callback = function()
								GameInteractions:closeDescriptionBox(true)
							end
						}
					},
					parent = riftWindow,
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
					onVisibilityChange_skilltree = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local skillTreeWindow = modules.game_spelltree.GameSpellTree.window

				if not skillTreeWindow:isVisible() then
					addEvent(function()
						modules.game_menu.Menu.icon:setOn(true)
					end)

					local parentWidget = modules.game_menu.Menu.window:recursiveGetChildById("skill_tree")

					GameInteractions:displayActionBox({
						bandit = true,
						text = "So open your skill tree by pressing (K)!",
						preferSide = "top",
						keys = {
							"K",
							MouseLeftButton
						},
						parent = parentWidget
					})
					table.insert(self.disconnects, connect(parentWidget, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(skillTreeWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_skilltree
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
					onVisibilityChange_skilltree = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 7)
						end
					end,
					onVisibilityChange_spellTreeSaveBuildSelectionPanel = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			onStartInteraction = function(self)
				if modules.game_spelltree.GameSpellTree:isShowingAetherRiftBuild() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 8)

					return
				end

				local skillTreeWindow = modules.game_spelltree.GameSpellTree.window

				if not skillTreeWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 5)

					return
				end

				table.insert(self.disconnects, connect(skillTreeWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_skilltree
				}))

				local buildSelectionPanel = skillTreeWindow:recursiveGetChildById("spellTreeSaveBuildSelectionPanel")

				if buildSelectionPanel:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
				else
					table.insert(self.disconnects, connect(buildSelectionPanel, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_spellTreeSaveBuildSelectionPanel
					}))
					GameInteractions:displayActionBox({
						preferSide = "bottom",
						text = "Now open your builds list ...",
						parent = modules.game_interface.gameHUDPanel:recursiveGetChildById("spellTreeSaveBuildPanel"),
						keys = {
							MouseLeftButton
						}
					})
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_skilltree = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 5)
						end
					end,
					onVisibilityChange_spellTreeSaveBuildSelectionPanel = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 6)
						end
					end
				},
				GameSpellTree = {
					onAetherRiftBuildLoaded = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				}
			},
			onStartInteraction = function(self)
				local skillTreeWindow = modules.game_spelltree.GameSpellTree.window

				if not skillTreeWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 5)

					return
				end

				table.insert(self.disconnects, connect(skillTreeWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_skilltree
				}))

				local buildSelectionPanel = skillTreeWindow:recursiveGetChildById("spellTreeSaveBuildSelectionPanel")

				table.insert(self.disconnects, connect(buildSelectionPanel, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_spellTreeSaveBuildSelectionPanel
				}))

				if buildSelectionPanel:isVisible() then
					GameInteractions:displayActionBox({
						preferSide = "right",
						text = "There are three slots with default builds specifically for Aether Rifts. Select any of them!",
						parent = buildSelectionPanel.content.aetherBuildSlot_2,
						keys = {
							MouseLeftButton
						}
					})
					table.insert(self.disconnects, connect(modules.game_spelltree.GameSpellTree, {
						onAetherRiftBuildLoaded = self.callbacks.GameSpellTree.onAetherRiftBuildLoaded
					}))
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, 6)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_skilltree = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 5)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local skillTreeWindow = modules.game_spelltree.GameSpellTree.window

				if not skillTreeWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 5)

					return
				end

				table.insert(self.disconnects, connect(skillTreeWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_skilltree
				}))

				local primaryPoints = modules.game_interface.gameHUDPanel:recursiveGetChildById("aether_rift_stats_panel").primary_panel.header.right_text

				if not primaryPoints then
					g_logger.error("Aether Rift primary points not found!")

					return
				end

				GameInteractions:displayDescriptionBox({
					preferSide = "left",
					pages = {
						{
							text = tr("Spend your primary points into the stats you want to have in the Aether Rift.")
						},
						{
							text = "",
							callback = function()
								GameInteractions:closeDescriptionBox(true)
							end
						}
					},
					parent = primaryPoints,
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
					onVisibilityChange_skilltree = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 5)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local skillTreeWindow = modules.game_spelltree.GameSpellTree.window

				if not skillTreeWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 5)

					return
				end

				table.insert(self.disconnects, connect(skillTreeWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_skilltree
				}))

				local secondaryPoints = modules.game_interface.gameHUDPanel:recursiveGetChildById("aether_rift_stats_panel").secondary_panel.header.right_text

				if not secondaryPoints then
					g_logger.error("Aether Rift secondary points not found!")
					GameInteractions:advanceInteraction(__env, __env.current_task, 5)

					return
				end

				GameInteractions:displayDescriptionBox({
					preferSide = "left",
					pages = {
						{
							text = tr("Spend your secondary points into the stats you want to have in the Aether Rift.")
						},
						{
							text = "",
							callback = function()
								GameInteractions:closeDescriptionBox(true)
							end
						}
					},
					parent = secondaryPoints,
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
					onVisibilityChange_skilltree = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 5)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local skillTreeWindow = modules.game_spelltree.GameSpellTree.window

				if not skillTreeWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 5)

					return
				end

				table.insert(self.disconnects, connect(skillTreeWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_skilltree
				}))

				local saveButton = modules.game_interface.gameHUDPanel:recursiveGetChildById("aether_rift_bottom_panel").save_stats_button

				if not saveButton then
					g_logger.error("Aether Rift save button not found!")
					GameInteractions:advanceInteraction(__env, __env.current_task, 5)

					return
				end

				GameInteractions:displayDescriptionBox({
					preferSide = "left",
					pages = {
						{
							text = tr("Be sure to save your changes when you're done!")
						},
						{
							text = tr("Aether Rifts don't follow the same rules as our world, and your level isn't that important inside ...")
						},
						{
							text = tr("The energies there force everyone onto even footing so that only the most skilled can claim victory.")
						},
						{
							text = tr("One last word of warning, the corrupted energies inside the Rift will begin to actively harm you if you stay too long. So fight hard and fight fast!")
						},
						{
							text = tr("Remember, you can always change the default build’s attribute and skill points to suit your needs. When you’re ready just save your choice and join an Aether Rift solo or with a friend! Good luck!"),
							callback = function()
								GameInteractions:closeDescriptionBox(true)
							end
						}
					},
					parent = saveButton,
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
