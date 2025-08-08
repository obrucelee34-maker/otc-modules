-- chunkname: @/modules/game_interactions/interactions/tutorial_part_1/config.lua

__env = __env or {}
quest_name = "Dreams and Reflections"
current_task = 0
current_interaction = 0
goDownstairs = 1
talkToMom = 2
talkToNeighbor = 3
returnHome = 4
talkToDad = 5
equipWeapon = 6
attackScarecrow = 7
talkToDad2 = 8
talkToMom2 = 9
gatherStrawberry = 10
talkToMom3 = 11
eatCake = 12
talkToDad3 = 13
followDad = 14
killBettles = 15
talkToDad4 = 16
spendSkillPoint = 17
tryNewSkill = 18
talkToDad5 = 19
useCompass = 20
talkToLookout = 21
returnHome2 = 22
talkToDad6 = 23
tasks = {
	[goDownstairs] = {
		{
			disconnects = {},
			callbacks = {
				LocalPlayer = {
					onPositionChange = function(player, pos)
						if Position.equals(pos, {
							z = 6,
							y = 4647,
							x = 3219
						}) then
							GameInteractions:advanceInteraction(__env, goDownstairs, 1)
						end
					end
				}
			},
			onStartInteraction = function(self)
				GameInteractions:displayActionBox({
					text = "Use Arrows or WASD to move around",
					keys = {
						"arrows",
						"wasd"
					},
					creatureId = g_game.getLocalPlayer():getId()
				})
				table.insert(self.disconnects, connect(LocalPlayer, {
					onPositionChange = self.callbacks.LocalPlayer.onPositionChange
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				Item = {
					onReplacedUse = function(item)
						if item:getId() == 35685 then
							GameInteractions:advanceInteraction(__env, goDownstairs, 2)
						end
					end
				},
				LocalPlayer = {
					onPositionChange = function(player, pos)
						if Position.equals(pos, {
							z = 6,
							y = 4647,
							x = 3218
						}) then
							GameInteractions:advanceInteraction(__env, goDownstairs, 2)
						end
					end
				}
			},
			onStartInteraction = function(self)
				GameInteractions:displayActionBox({
					text = "Press F or Right-Click to interact with NPCs and world objects",
					keys = {
						"F",
						MouseRightButton
					},
					tilePos = {
						z = 6,
						y = 4647,
						x = 3218
					}
				})
				table.insert(self.disconnects, connect(Item, {
					onReplacedUse = self.callbacks.Item.onReplacedUse
				}))
				table.insert(self.disconnects, connect(LocalPlayer, {
					onPositionChange = self.callbacks.LocalPlayer.onPositionChange
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				LocalPlayer = {
					onPositionChange = function(player, pos)
						if Position.equals(pos, {
							z = 7,
							y = 4647,
							x = 3216
						}) then
							GameInteractions:advanceInteraction(__env, goDownstairs, 3)
						end
					end
				}
			},
			onStartInteraction = function(self)
				GameInteractions:displayActionBox({
					text = "Use Arrows or WASD to move downstairs",
					keys = {
						"arrows",
						"wasd"
					},
					tilePos = {
						z = 6,
						y = 4646,
						x = 3216
					}
				})
				table.insert(self.disconnects, connect(LocalPlayer, {
					onPositionChange = self.callbacks.LocalPlayer.onPositionChange
				}))
			end
		}
	},
	[talkToMom] = {
		{
			onStartInteraction = function(self)
				GameInteractions:displayActionBox({
					text = "Press F or Right-Click to interact with NPCs and world objects",
					keys = {
						"F",
						MouseRightButton
					},
					tilePos = {
						z = 7,
						y = 4646,
						x = 3222
					}
				})
			end
		}
	},
	[talkToNeighbor] = {
		{
			disconnects = {},
			callbacks = {
				Item = {
					onReplacedUse = function(item)
						if item:getId() == 35685 then
							GameInteractions:advanceInteraction(__env, talkToNeighbor, 1)
						end
					end
				},
				LocalPlayer = {
					onPositionChange = function(player, pos)
						if Position.equals(pos, {
							z = 7,
							y = 4650,
							x = 3223
						}) then
							GameInteractions:advanceInteraction(__env, talkToNeighbor, 1)
						end
					end
				}
			},
			onStartInteraction = function(self)
				GameInteractions:displayActionBox({
					text = "Press F or Right-Click to interact with NPCs and world objects",
					keys = {
						"F",
						MouseRightButton
					},
					tilePos = {
						z = 7,
						y = 4650,
						x = 3223
					}
				})
				table.insert(self.disconnects, connect(Item, {
					onReplacedUse = self.callbacks.Item.onReplacedUse
				}))
				table.insert(self.disconnects, connect(LocalPlayer, {
					onPositionChange = self.callbacks.LocalPlayer.onPositionChange
				}))
			end
		}
	},
	[equipWeapon] = {
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						GameInteractions.action_window:setVisible(visible)
					end,
					onVisibilityChange_inventory = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, equipWeapon, 1)
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
						text = "Press I or Left-Click to open your Inventory",
						preferSide = "top",
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
					GameInteractions:advanceInteraction(__env, equipWeapon, 1)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_inventory = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, equipWeapon, 0)
						end
					end,
					onVisibilityChange_questPanel = function(widget, visible)
						if visible then
							addEvent(function()
								modules.game_inventory.GameInventory:selectTab(InventorySlotBack, false, true)
							end)
						end
					end
				}
			},
			onStartInteraction = function(self)
				modules.game_inventory.GameInventory:selectTab(InventorySlotBack, false, true)
				GameInteractions:displayDescriptionBox({
					preferSide = "left",
					pages = {
						{
							text = "Here you can find all the items you're currently carrying"
						}
					},
					parent = modules.game_inventory.GameInventory.mainTab,
					callbackOnClose = function()
						GameInteractions:advanceInteraction(__env, equipWeapon, 2)
					end
				})

				local inventoryWindow = modules.game_inventory.GameInventory.window

				if not inventoryWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, equipWeapon, 0)
				else
					table.insert(self.disconnects, connect(inventoryWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_inventory
					}))
					table.insert(self.disconnects, connect(modules.game_inventory.GameInventory.questPanel, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_questPanel
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

						if item:getItem() == nil then
							GameInteractions:advanceInteraction(__env, equipWeapon, 2)
						end
					end
				},
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, equipWeapon, 0)
						end
					end,
					onVisibilityChange_questPanel = function(widget, visible)
						if visible then
							addEvent(function()
								modules.game_inventory.GameInventory:selectTab(InventorySlotBack, false, true)
							end)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local inventoryWindow = modules.game_inventory.GameInventory.window

				modules.game_inventory.GameInventory:selectTab(InventorySlotBack, false, true)

				if inventoryWindow:isVisible() then
					local parentWidget = modules.game_inventory.GameInventory:findItemWidgetByItemType("mainPanel", "weapon")

					if parentWidget then
						parentWidget.preventDragItem = true

						GameInteractions:displayActionBox({
							text = "Press Right-Click to equip your weapon",
							preferSide = "top",
							keys = {
								MouseRightButton
							},
							parent = parentWidget
						})
						table.insert(self.disconnects, connect(parentWidget, {
							onItemChange = self.callbacks.UIItem.onItemChange
						}))
					end

					table.insert(self.disconnects, connect(inventoryWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(modules.game_inventory.GameInventory.questPanel, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_questPanel
					}))
				else
					GameInteractions:advanceInteraction(__env, equipWeapon, 0)
				end
			end
		}
	},
	[attackScarecrow] = {
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, attackScarecrow, 1)
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
					table.insert(self.disconnects, connect(modules.game_inventory.GameInventory.window, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
				else
					GameInteractions:advanceInteraction(__env, attackScarecrow, 1)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				g_game = {
					onAttackingCreatureChange = function(creature)
						if creature and creature:getName():lower() == "scarecrow" then
							GameInteractions:advanceInteraction(__env, attackScarecrow, 2)
						elseif not creature then
							GameInteractions:advanceInteraction(__env, attackScarecrow, 1)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local target = g_game.getAttackingCreature()

				if not target or target:getName():lower() ~= "scarecrow" then
					GameInteractions:displayActionBox({
						text = "Press Tab to target the nearest creature or right-click on a specific target",
						keys = {
							"Tab",
							MouseRightButton
						},
						tilePos = {
							z = 7,
							y = 4643,
							x = 3226
						}
					})
					table.insert(self.disconnects, connect(g_game, {
						onAttackingCreatureChange = self.callbacks.g_game.onAttackingCreatureChange
					}))
				else
					GameInteractions:advanceInteraction(__env, attackScarecrow, 2)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				g_game = {
					onAttackingCreatureChange = function(creature)
						if not creature then
							GameInteractions:advanceInteraction(__env, attackScarecrow, 1)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local target = g_game.getAttackingCreature()

				if not target or target:getName():lower() ~= "scarecrow" then
					GameInteractions:advanceInteraction(__env, attackScarecrow, 1)
				end

				table.insert(self.disconnects, connect(g_game, {
					onAttackingCreatureChange = self.callbacks.g_game.onAttackingCreatureChange
				}))
			end
		}
	},
	[gatherStrawberry] = {
		{
			disconnects = {},
			callbacks = {},
			onStartInteraction = function(self)
				GameInteractions:displayActionBox({
					text = "Press F or Right-Click to interact with NPCs and world objects",
					keys = {
						"F",
						MouseRightButton
					},
					tilePos = {
						z = 7,
						y = 4654,
						x = 3224
					}
				})
			end
		}
	},
	[eatCake] = {
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						GameInteractions.action_window:setVisible(visible)
					end,
					onVisibilityChange_inventory = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, eatCake, 1)
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
						text = "Press I or Left-Click to open your Inventory",
						preferSide = "top",
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
					GameInteractions:advanceInteraction(__env, eatCake, 1)
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
							GameInteractions:advanceInteraction(__env, eatCake, 2)
						end
					end,
					onVisibilityChange_inventory = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, eatCake, 0)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local inventoryWindow = modules.game_inventory.GameInventory.window

				if inventoryWindow:isVisible() then
					GameInteractions:displayDescriptionBox({
						preferSide = "left",
						pages = {
							{
								text = "The Quest Bag is where you keep most of your quest-related items"
							}
						},
						parent = modules.game_inventory.GameInventory.questTab,
						callbackOnClose = function()
							GameInteractions:advanceInteraction(__env, eatCake, 2)
						end
					})
					table.insert(self.disconnects, connect(inventoryWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_inventory
					}))
				else
					GameInteractions:advanceInteraction(__env, eatCake, 0)
				end

				if not modules.game_inventory.GameInventory.questPanel:isVisible() then
					table.insert(self.disconnects, connect(modules.game_inventory.GameInventory.questPanel, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
				else
					GameInteractions:closeDescriptionBox()
					GameInteractions:advanceInteraction(__env, eatCake, 2)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, eatCake, 3)
						end
					end,
					onVisibilityChange_inventory = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, eatCake, 0)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local questPanel = modules.game_inventory.GameInventory.questPanel

				if not questPanel:isVisible() then
					GameInteractions:displayActionBox({
						text = "Left-Click on the Quest Bag to open it",
						preferSide = "right",
						keys = {
							MouseLeftButton
						},
						parent = modules.game_inventory.GameInventory.questTab
					})
					table.insert(self.disconnects, connect(questPanel, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
				else
					GameInteractions:advanceInteraction(__env, eatCake, 3)
				end

				local inventoryWindow = modules.game_inventory.GameInventory.window

				if not inventoryWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, eatCake, 0)
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
							GameInteractions:advanceInteraction(__env, eatCake, 0)
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
						if itemId == 35686 then
							GameInteractions:advanceInteraction(__env, eatCake, 4)
						end
					end
				}
			},
			displayInteraction = function(self)
				local inventoryWindow = modules.game_inventory.GameInventory.window

				if inventoryWindow:isVisible() then
					local parentWidget = modules.game_inventory.GameInventory:findItemWidgetByItemType("questPanel", "food")

					if parentWidget then
						parentWidget.preventDragItem = true

						GameInteractions:displayActionBox({
							text = "Press Right-Click to use a consumable item",
							preferSide = "top",
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
					GameInteractions:advanceInteraction(__env, eatCake, 0)
				end
			end,
			onStartInteraction = function(self)
				table.insert(self.disconnects, connect(g_game, {
					onUse = self.callbacks.g_game.onUse
				}))

				local inventoryWindow = modules.game_inventory.GameInventory.window

				if not inventoryWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, eatCake, 0)
				else
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
		}
	},
	[killBettles] = {
		{
			disconnects = {},
			callbacks = {
				g_game = {
					onAttackingCreatureChange = function(creature)
						if not creature then
							GameInteractions:advanceInteraction(__env, killBettles, 0)
						else
							GameInteractions:closeActionBox()
						end
					end
				},
				LocalPlayer = {
					onPositionChange = function(player)
						if not g_game.getAttackingCreature() then
							GameInteractions:advanceInteraction(__env, killBettles, 0)
						else
							GameInteractions:closeActionBox()
						end
					end
				}
			},
			onStartInteraction = function(self)
				local targets = {}
				local player = g_game.getLocalPlayer()
				local spectators = g_map.getSpectators(player:getPosition(), true)

				for _, creature in ipairs(spectators) do
					if creature:getName():lower():find("beetle") and creature:isMonster() then
						table.insert(targets, creature)
					end
				end

				table.sort(targets, function(a, b)
					return Position.distance(a:getPosition(), player:getPosition()) < Position.distance(b:getPosition(), player:getPosition())
				end)

				if #targets > 0 then
					local target = targets[1]

					GameInteractions:displayActionBox({
						text = "Press Tab to target the nearest creature or right-click on a specific target",
						keys = {
							"Tab",
							MouseRightButton
						},
						creatureId = target:getId(),
						offset = {
							x = -40,
							y = -32
						}
					})
				end

				table.insert(self.disconnects, connect(g_game, {
					onAttackingCreatureChange = self.callbacks.g_game.onAttackingCreatureChange
				}))
				table.insert(self.disconnects, connect(LocalPlayer, {
					onPositionChange = self.callbacks.LocalPlayer.onPositionChange
				}))
			end
		}
	},
	[spendSkillPoint] = {
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						GameInteractions.action_window:setVisible(visible)
					end,
					onVisibilityChange_skilltree = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, spendSkillPoint, 1)
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
						text = "Press K or Left-Click to open your Skill Tree",
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
					GameInteractions:advanceInteraction(__env, spendSkillPoint, 1)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, spendSkillPoint, 0)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local skillTreeWindow = modules.game_spelltree.GameSpellTree.window

				if not skillTreeWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, spendSkillPoint, 0)
				else
					GameInteractions:displayDescriptionBox({
						preferSide = "right",
						pages = {
							{
								text = "This is your Archetype's Skill Tree",
								callback = function(self)
									self.newParent = modules.game_spelltree.GameSpellTree.window:recursiveGetChildById("tree1")
									self.preferSide = "right"
								end
							},
							{
								text = "You'll unlock more Skill Trees upon choosing new Archetypes at higher levels",
								callback = function(self)
									self.newParent = modules.game_spelltree.GameSpellTree.window:recursiveGetChildById("tree2")
									self.preferSide = "left"
								end
							}
						},
						parent = modules.game_spelltree.GameSpellTree.window:recursiveGetChildById("tree1"),
						callbackOnClose = function()
							GameInteractions:advanceInteraction(__env, spendSkillPoint, 2)
						end
					})
					table.insert(self.disconnects, connect(skillTreeWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
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
							GameInteractions:advanceInteraction(__env, spendSkillPoint, 0)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local skillTreeWindow = modules.game_spelltree.GameSpellTree.window

				if not skillTreeWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, spendSkillPoint, 0)
				else
					local tree = modules.game_spelltree.GameSpellTree.window:recursiveGetChildById("tree1")
					local learnSpell = tree:recursiveGetChildById("spell1")
					local forceSpells = {
						"smite"
					}

					for i = 1, 15 do
						local spell = tree:recursiveGetChildById("spell" .. i)

						if spell and table.find(forceSpells, spell.spellInfo.name:lower()) then
							learnSpell = spell

							break
						end
					end

					GameInteractions:displayActionBox({
						text = "Left-Click the highlighted skill to learn it",
						preferSide = "top",
						keys = {
							MouseLeftButton
						},
						parent = learnSpell
					})
					table.insert(self.disconnects, connect(skillTreeWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
				end
			end
		}
	},
	[tryNewSkill] = {
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, tryNewSkill, 1)
						end
					end
				}
			},
			displayInteraction = function()
				GameInteractions:displayActionBox({
					text = "Press K or Esc to close your Skill Tree",
					keys = {
						"K",
						"Esc"
					},
					parent = modules.game_spelltree.GameSpellTree.window.top_panel.close_button
				})
			end,
			onStartInteraction = function(self)
				if modules.game_spelltree.GameSpellTree.window:isVisible() then
					self.displayInteraction()
					table.insert(self.disconnects, connect(modules.game_spelltree.GameSpellTree.window, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
				else
					GameInteractions:advanceInteraction(__env, tryNewSkill, 1)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onDragEnter = function(widget)
						widget.draggingLock = g_clock.millis() + 100

						return false
					end
				}
			},
			onStartInteraction = function(self)
				local _, abilitySlot = AbilityBar.getFirstOccupiedSlot(AbilityBarCategorySpell)

				if abilitySlot then
					GameInteractions:displayDescriptionBox({
						preferSide = "top",
						pages = {
							{
								text = "Your new skill has been added to your action bar"
							},
							{
								text = "In case it disappears for any reason, just double Left-Click on the skill in the skill tree to add it back"
							}
						},
						parent = abilitySlot,
						callbackOnClose = function()
							GameInteractions:advanceInteraction(__env, tryNewSkill, 2)
						end
					})
					table.insert(self.disconnects, connect(abilitySlot:recursiveGetChildById("icon"), {
						onDragEnter = self.callbacks.UIWidget.onDragEnter
					}, true))
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				g_game = {
					onAttackingCreatureChange = function(creature)
						if creature and creature:getName():lower() == "scarecrow" then
							GameInteractions:advanceInteraction(__env, tryNewSkill, 3)
						else
							GameInteractions:advanceInteraction(__env, tryNewSkill, 2)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local target = g_game.getAttackingCreature()

				if not target or target:getName():lower() ~= "scarecrow" then
					GameInteractions:displayActionBox({
						text = "Press Tab to target the nearest creature or right-click on a specific target",
						keys = {
							"Tab",
							MouseRightButton
						},
						tilePos = {
							z = 7,
							y = 4643,
							x = 3226
						}
					})
					table.insert(self.disconnects, connect(g_game, {
						onAttackingCreatureChange = self.callbacks.g_game.onAttackingCreatureChange
					}))
				else
					GameInteractions:advanceInteraction(__env, tryNewSkill, 3)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				g_game = {
					onAttackingCreatureChange = function(creature)
						if not creature or creature:getName():lower() ~= "scarecrow" then
							GameInteractions:advanceInteraction(__env, tryNewSkill, 3)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local target = g_game.getAttackingCreature()

				if not target or target:getName():lower() ~= "scarecrow" then
					GameInteractions:advanceInteraction(__env, tryNewSkill, 2)
				else
					local _, abilitySlot = AbilityBar.getFirstOccupiedSlot(AbilityBarCategorySpell)

					GameInteractions:displayActionBox({
						text = "Press 1 to use your new skill",
						preferSide = "top",
						keys = {
							"1"
						},
						parent = abilitySlot
					})
					table.insert(self.disconnects, connect(g_game, {
						onAttackingCreatureChange = self.callbacks.g_game.onAttackingCreatureChange
					}))
				end
			end
		}
	},
	[useCompass] = {
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, useCompass, 1)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local parent = modules.game_questlog.getQuestWidget(quest_name)

				if parent and parent.compass then
					GameInteractions:displayActionBox({
						text = "Click on the compass icon to track the chosen quest",
						preferSide = "left",
						keys = {
							MouseLeftButton
						},
						parent = parent.compass
					})
					table.insert(self.disconnects, connect(g_worldMap.window, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				g_worldMap = {
					onAddCompassHighlight = function(g_worldMap, flag)
						GameInteractions:displayDescriptionBox({
							preferSide = "top",
							pages = {
								{
									text = "This artifact points towards the area near your objective, but finding its exact location is up to you!"
								}
							},
							parent = flag,
							callbackOnClose = function()
								GameInteractions:advanceInteraction(__env, useCompass, 2)
							end
						})
					end
				},
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, useCompass, 1)
						end
					end
				}
			},
			onStartInteraction = function(self)
				table.insert(self.disconnects, connect(g_worldMap, {
					onAddCompassHighlight = self.callbacks.g_worldMap.onAddCompassHighlight
				}))
				table.insert(self.disconnects, connect(g_worldMap.window, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
				}))
			end
		}
	}
}
callbacks = {
	onTaskUpdate = function(task)
		local quest = task.quests and task.quests[1]

		if quest and quest.name:lower() == quest_name:lower() and quest.tasks then
			for _, task in pairs(quest.tasks) do
				if current_task ~= task.taskId then
					GameInteractions:closeActionBox()
					GameInteractions:closeDescriptionBox()
				end

				GameInteractions:advanceInteraction(__env, task.taskId, 0)

				break
			end
		end
	end,
	onGameStart = function()
		return
	end,
	onGameEnd = function()
		return
	end
}
