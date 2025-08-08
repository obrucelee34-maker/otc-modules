-- chunkname: @/modules/game_interactions/interactions/tutorial_part_2/config.lua

__env = __env or {}
quest_name = "A New Reality"
current_task = 0
current_interaction = 0
chooseOutfit = 1
goDownStairs = 2
talkToBandit = 3
searchHouse = 4
potionToActionBar = 5
talkToBandit2 = 6
talkToBandit3 = 7
gatherFlower = 8
deliverFlower = 9
talkToBandit4 = 10
spendSkillPoint = 11
findTheDock = 12
killRaiders = 13
goToDock = 14
boardShip = 15
sail = 16
defeatSeaMonster = 17
tasks = {
	[chooseOutfit] = {
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, chooseOutfit, 1)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local characterWindow = modules.game_character.GameCharacter.window

				if not characterWindow:isVisible() then
					GameInteractions:displayActionBox({
						text = "Press X to open your Character menu",
						keys = {
							"X"
						},
						creatureId = g_game.getLocalPlayer():getId()
					})
					table.insert(self.disconnects, connect(modules.game_character.GameCharacter.window, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
				else
					modules.game_character.GameCharacter:enableAllTabs()
					GameInteractions:advanceInteraction(__env, chooseOutfit, 1)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, chooseOutfit, 0)
						end
					end,
					onVisibilityChange_equipment = function(widget, visible)
						addEvent(function()
							modules.game_character.GameCharacter:selectTab("equipment")
						end)
					end
				}
			},
			onStartInteraction = function(self)
				local window = modules.game_character.GameCharacter.window

				if window:isVisible() then
					modules.game_character.GameCharacter:selectTab("equipment")
					modules.game_character.GameCharacter:disableAllTabs({
						"equipment"
					})
					GameInteractions:displayDescriptionBox({
						preferSide = "right",
						pages = {
							{
								text = "The sword and shield icons refer to your attack and defense power",
								callback = function(self)
									self.newParent = window.content.equipment_panel.stats_preview.defense_power
								end
							},
							{
								text = "While the bleeding sword stands for infamy, which you receive upon killing other players",
								callback = function(self)
									self.newParent = window.content.equipment_panel.stats_preview.infamy
								end
							}
						},
						parent = window.content.equipment_panel.stats_preview.defense_power,
						callbackOnClose = function()
							GameInteractions:advanceInteraction(__env, chooseOutfit, 2)
						end
					})
					table.insert(self.disconnects, connect(window, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(window.content.equipment_panel, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_equipment
					}))
				else
					GameInteractions:advanceInteraction(__env, chooseOutfit, 0)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, chooseOutfit, 3)
						else
							GameInteractions:advanceInteraction(__env, chooseOutfit, 2)
						end
					end,
					onVisibilityChange_character = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, chooseOutfit, 2)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local window = modules.game_character.GameCharacter.window

				if window:isVisible() then
					modules.game_character.GameCharacter:enableTab("stats")
					modules.game_character.GameCharacter:disableAllTabs({
						"stats"
					})
					GameInteractions:displayActionBox({
						text = "Now click at the Stats tab",
						keys = {
							MouseLeftButton
						},
						parent = window.panel_top.selection_panel.stats
					})
					table.insert(self.disconnects, connect(window.content.stats_panel, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(modules.game_character.GameCharacter.window, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_character
					}))
				else
					GameInteractions:advanceInteraction(__env, chooseOutfit, 0)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, chooseOutfit, 0)
						end
					end,
					onVisibilityChange_stats = function(widget, visible)
						if not visible then
							addEvent(function()
								modules.game_character.GameCharacter:selectTab("stats")
							end)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local window = modules.game_character.GameCharacter.window

				if window:isVisible() then
					GameInteractions:displayDescriptionBox({
						preferSide = "right",
						pages = {
							{
								text = "Distribute the two remaining points between Vitality, Might, Intelligence, Dexterity and Wisdom"
							},
							{
								text = "Every time your effective level increases, you receive 2 points to be distributed between these five stats..."
							},
							{
								text = "They influence directly in your attributes, which you can see in details below"
							},
							{
								text = "If you made a bad choice, don't worry! You can reset them for free until legacy level 20"
							}
						},
						parent = window.content.stats_panel.primary_stats,
						callbackOnClose = function()
							GameInteractions:advanceInteraction(__env, chooseOutfit, 4)
						end
					})
					table.insert(self.disconnects, connect(window, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(window.content.stats_panel, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_stats
					}))
				else
					GameInteractions:advanceInteraction(__env, chooseOutfit, 0)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, chooseOutfit, 5)
						else
							GameInteractions:advanceInteraction(__env, chooseOutfit, 4)
						end
					end,
					onVisibilityChange_character = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, chooseOutfit, 4)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local window = modules.game_character.GameCharacter.window

				if window:isVisible() then
					modules.game_character.GameCharacter:enableTab("customization")
					modules.game_character.GameCharacter:disableAllTabs({
						"customization"
					})
					GameInteractions:displayActionBox({
						text = "Now click at the Customization tab",
						keys = {
							MouseLeftButton
						},
						parent = window.panel_top.selection_panel.customization
					})
					table.insert(self.disconnects, connect(window.content.customization_panel, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(modules.game_character.GameCharacter.window, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_character
					}))
				else
					GameInteractions:advanceInteraction(__env, chooseOutfit, 0)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, chooseOutfit, 0)
						end
					end,
					onVisibilityChange_customization = function(widget, visible)
						if not visible then
							addEvent(function()
								modules.game_character.GameCharacter:selectTab("customization")
								modules.game_notification.GameNotification:display(NOTIFICATION_WARNING, "Tutorial", "Please select a color for your hair and clothes", 5000, 90)
							end)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local window = modules.game_character.GameCharacter.window

				if window:isVisible() then
					GameInteractions:displayDescriptionBox({
						preferSide = "right",
						pages = {
							{
								text = "Here you can change your look by choosing new colors to your hair and clothes",
								callback = function(self)
									self.newParent = modules.game_character.GameCharacter.window.content.customization_panel
								end
							},
							{
								text = "You can select the different parts of your outfit by clicking on 1 to 4",
								callback = function(self)
									self.newParent = modules.game_character.GameCharacter.window.content.customization_panel.color_selection_panel
								end
							},
							{
								text = "Try out some different looks before you move on!"
							}
						},
						parent = modules.game_character.GameCharacter.window.content.customization_panel,
						callbackOnClose = function()
							modules.game_character.GameCharacter:enableAllTabs()
						end
					})
					table.insert(self.disconnects, connect(window, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(window.content.customization_panel, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_customization
					}))
				else
					GameInteractions:advanceInteraction(__env, chooseOutfit, 0)
				end
			end
		}
	},
	[potionToActionBar] = {
		{
			disconnects = {},
			callbacks = {},
			onStartInteraction = function(self)
				modules.game_character.GameCharacter:enableAllTabs()
				GameInteractions:displayDescriptionBox({
					preferSide = "top",
					bandit = true,
					pages = {
						{
							text = "I knew you would find something useful in there! Always trust a dog's nose."
						}
					},
					tilePos = {
						z = 7,
						y = 4846,
						x = 3216
					},
					callbackOnClose = function()
						GameInteractions:advanceInteraction(__env, potionToActionBar, 1)
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
							GameInteractions:advanceInteraction(__env, potionToActionBar, 2)
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
					GameInteractions:advanceInteraction(__env, potionToActionBar, 2)
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
				UIItem = {
					onItemChange = function(item)
						item.preventDragItem = nil
					end
				},
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, potionToActionBar, 1)

							local parentWidget = modules.game_inventory.GameInventory:findItemWidgetByItemType("mainPanel", "potion")

							if parentWidget then
								parentWidget.preventDragItem = nil
							end
						else
							GameInteractions:advanceInteraction(__env, potionToActionBar, 1)
						end
					end,
					onVisibilityChange_mainPanel = function(widget, visible)
						addEvent(function()
							modules.game_inventory.GameInventory:selectTab(InventorySlotBack, false, true)
						end)
					end
				}
			},
			displayInteraction = function(self)
				local inventoryWindow = modules.game_inventory.GameInventory.window

				if inventoryWindow:isVisible() then
					local parentWidget = modules.game_inventory.GameInventory:findItemWidgetByItemType("mainPanel", "potion")

					if parentWidget then
						parentWidget.preventDragItem = true

						GameInteractions:displayActionBox({
							text = "Simply right-click the potions and choose to add them to your action bar",
							preferSide = "top",
							bandit = true,
							keys = {
								MouseRightButton
							},
							parent = parentWidget
						})
						table.insert(self.disconnects, connect(parentWidget, {
							onItemChange = self.callbacks.UIItem.onItemChange
						}))
						table.insert(self.disconnects, connect(modules.game_inventory.GameInventory.mainPanel, {
							onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_mainPanel
						}))
					end

					table.insert(self.disconnects, connect(modules.game_inventory.GameInventory.window, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
				else
					GameInteractions:advanceInteraction(__env, potionToActionBar, 0)
				end
			end,
			onStartInteraction = function(self)
				local inventoryWindow = modules.game_inventory.GameInventory.window

				if not inventoryWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, potionToActionBar, 0)
				else
					addEvent(function()
						modules.game_inventory.GameInventory:selectTab(InventorySlotBack, false, true)
					end)
					table.insert(self.disconnects, connect(g_game, {
						onRefreshItems = function()
							self:displayInteraction()
						end
					}))
				end

				table.insert(self.disconnects, connect(inventoryWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
				}))
			end
		}
	},
	[talkToBandit2] = {
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, talkToBandit2, 1)
						end
					end
				}
			},
			displayInteraction = function()
				GameInteractions:displayActionBox({
					text = "Press I or Esc to close your Inventory",
					bandit = true,
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
					GameInteractions:advanceInteraction(__env, talkToBandit2, 1)
				end
			end
		}
	},
	[spendSkillPoint] = {
		{
			disconnects = {},
			callbacks = {},
			onStartInteraction = function(self)
				local player = g_game.getLocalPlayer()
				local spectators = g_map.getSpectators(player:getPosition(), true)
				local target

				for _, spectator in pairs(spectators) do
					if spectator:isNpc() and spectator:getName():lower() == "bandit" then
						target = spectator

						break
					end
				end

				if target then
					GameInteractions:displayDescriptionBox({
						preferSide = "top",
						bandit = true,
						pages = {
							{
								text = "Hey... you seem different. Kind of like you were on your birthday, all those years ago!"
							},
							{
								text = "You cut the scarecrow clean in half, remember?"
							}
						},
						callbackOnClose = function()
							GameInteractions:advanceInteraction(__env, spendSkillPoint, 1)
						end,
						creatureId = target:getId()
					})
				end
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
							GameInteractions:advanceInteraction(__env, spendSkillPoint, 2)
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
						bandit = true,
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
					GameInteractions:advanceInteraction(__env, spendSkillPoint, 2)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, spendSkillPoint, 1)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local availableSpells = {
					"concussive shot",
					"holy shackles",
					"smiting smash",
					"shadowstrike",
					"whirlwind",
					"guillotine",
					"arcane torrent"
				}
				local learnedSpell, nextSpell
				local spellTreeWindow = modules.game_spelltree.GameSpellTree.window
				local spellTree = spellTreeWindow:recursiveGetChildById("tree1")

				if spellTreeWindow:isVisible() then
					for i = 1, 15 do
						local spell = spellTree:recursiveGetChildById("spell" .. i)

						if spell then
							if spell.spellInfo.enabled then
								learnedSpell = spell

								if spell.spellInfo.name:lower() == "fireball" then
									table.insert(availableSpells, "erupt")
								else
									table.insert(availableSpells, "frost shards")
								end
							end

							if table.find(availableSpells, spell.spellInfo.name:lower()) then
								nextSpell = spell

								break
							end
						end
					end

					if learnedSpell and nextSpell then
						GameInteractions:displayDescriptionBox({
							preferSide = "right",
							bandit = true,
							pages = {
								{
									text = "The skill you already have generates aether. A source of energy that powers up other skills!",
									callback = function(self)
										self.newParent = learnedSpell
									end
								},
								{
									text = "Now click the following skill to learn it too!",
									callback = function(self)
										self.newParent = nextSpell
									end
								}
							},
							parent = learnedSpell,
							callbackOnClose = function()
								GameInteractions:advanceInteraction(__env, spendSkillPoint, 3)
							end
						})
						table.insert(self.disconnects, connect(spellTreeWindow, {
							onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
						}))
					end
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
							GameInteractions:advanceInteraction(__env, spendSkillPoint, 1)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local spellTreeWindow = modules.game_spelltree.GameSpellTree.window

				if spellTreeWindow:isVisible() then
					local availableSpells = {
						"concussive shot",
						"holy shackles",
						"smiting smash",
						"shadowstrike",
						"whirlwind",
						"guillotine",
						"arcane torrent"
					}
					local learnedSpell, nextSpell
					local spellTree = spellTreeWindow:recursiveGetChildById("tree1")

					for i = 1, 15 do
						local spell = spellTree:recursiveGetChildById("spell" .. i)

						if spell then
							if spell.spellInfo.enabled then
								learnedSpell = spell

								if spell.spellInfo.name:lower() == "fireball" then
									table.insert(availableSpells, "erupt")
								else
									table.insert(availableSpells, "frost shards")
								end
							end

							if table.find(availableSpells, spell.spellInfo.name:lower()) then
								nextSpell = spell

								break
							end
						end
					end

					if learnedSpell and nextSpell then
						GameInteractions:displayActionBox({
							text = "Left-click the highlighted skill to learn it",
							preferSide = "right",
							bandit = true,
							keys = {
								MouseLeftButton
							},
							parent = nextSpell
						})
					end

					table.insert(self.disconnects, connect(spellTreeWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
				else
					GameInteractions:advanceInteraction(__env, spendSkillPoint, 1)
				end
			end
		}
	},
	[findTheDock] = {
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onGeometryChange = function(widget)
						if widget:getHeight() > 0 then
							GameInteractions:advanceInteraction(__env, findTheDock, 3)
						end
					end,
					onVisibilityChange = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, findTheDock, 1)
						end
					end
				}
			},
			onStartInteraction = function(self)
				table.insert(self.disconnects, connect(AbilityBar.weaponSkillWidget, {
					onGeometryChange = self.callbacks.UIWidget.onGeometryChange
				}))

				local skillTreeWindow = modules.game_spelltree.GameSpellTree.window

				if skillTreeWindow:isVisible() then
					GameInteractions:displayActionBox({
						text = "Now press K to close your Skill Tree",
						preferSide = "left",
						bandit = true,
						keys = {
							MouseLeftButton,
							"K",
							"ESC"
						},
						parent = skillTreeWindow.top_panel.close_button
					})
					table.insert(self.disconnects, connect(skillTreeWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
				else
					GameInteractions:advanceInteraction(__env, findTheDock, 1)
				end
			end
		},
		{
			callbacks = {
				UIWidget = {
					onGeometryChange = function(widget)
						if widget:getHeight() > 0 then
							GameInteractions:advanceInteraction(__env, findTheDock, 3)
						end
					end
				}
			},
			disconnects = {},
			onStartInteraction = function(self)
				local player = g_game.getLocalPlayer()
				local spectators = g_map.getSpectators(player:getPosition(), true)
				local target

				for _, spectator in pairs(spectators) do
					if spectator:isNpc() and spectator:getName():lower() == "bandit" then
						target = spectator

						break
					end
				end

				if target then
					GameInteractions:displayDescriptionBox({
						pages = {
							{
								text = "Your new ability consumes aether to increase its effectiveness, so don't forget to try it out!"
							},
							{
								text = "You can also manage the order of the items and skills in your ability bar!"
							},
							{
								text = "Just make sure to open the lock found in the top right corner of the bar first"
							}
						},
						creatureId = target:getId(),
						callbackOnClose = function(self)
							GameInteractions:advanceInteraction(__env, findTheDock, 2)
						end
					})
				end

				table.insert(self.disconnects, connect(AbilityBar.weaponSkillWidget, {
					onGeometryChange = self.callbacks.UIWidget.onGeometryChange
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onGeometryChange = function(widget)
						if widget:getHeight() > 0 then
							GameInteractions:advanceInteraction(__env, findTheDock, 3)
						end
					end
				}
			},
			onStartInteraction = function(self)
				table.insert(self.disconnects, connect(AbilityBar.weaponSkillWidget, {
					onGeometryChange = self.callbacks.UIWidget.onGeometryChange
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {},
			onStartInteraction = function(self)
				local player = g_game.getLocalPlayer()
				local spectators = g_map.getSpectators(player:getPosition(), true)
				local target

				for _, spectator in pairs(spectators) do
					if spectator:isNpc() and spectator:getName():lower() == "bandit" then
						target = spectator

						break
					end
				end

				if target then
					GameInteractions:displayDescriptionBox({
						bandit = true,
						preferSide = "top",
						pages = {
							{
								text = "I can hardly believe we're on our way to Ravendawn together!"
							},
							{
								text = "Leaving our home behind after all this time..."
							},
							{
								text = "Mom and Dad always warned us about the dangers of the wilderness"
							},
							{
								text = "So hold your weapon tight!"
							},
							{
								text = "Because at this point, you're probably capable of using its full potential"
							},
							{
								text = "Each weapon type has a unique skill which anyone who's ready can utilize"
							},
							{
								text = "Timing this skill with your other abilities could be the difference between life and death!"
							}
						},
						creatureId = target:getId(),
						callbackOnClose = function()
							GameInteractions:advanceInteraction(__env, findTheDock, 4)
						end
					})
				end
			end
		},
		{
			disconnects = {},
			callbacks = {},
			onStartInteraction = function(self)
				GameInteractions:displayDescriptionBox({
					bandit = true,
					preferSide = "top",
					pages = {
						{
							text = "Simply hover your mouse over the weapon skill to see what it does"
						},
						{
							text = "And next time you find yourself in danger, press R and try it out!"
						}
					},
					parent = AbilityBar.weaponSkillWidget
				})
			end
		}
	},
	[defeatSeaMonster] = {
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onDragEnter = function(widget)
						widget.draggingLock = g_clock.millis() + 100

						return false
					end
				},
				LocalPlayer = {
					onTeleport = function(player)
						GameInteractions:advanceInteraction(__env, defeatSeaMonster, 1)
					end
				}
			},
			onStartInteraction = function(self)
				local _, abilitySlot = AbilityBar.getFirstOccupiedSlot(AbilityBarCategoryShip)

				if abilitySlot then
					GameInteractions:displayDescriptionBox({
						preferSide = "top",
						pages = {
							{
								text = "Quick! Prepare the cannons and fire them at the monster before it's too late!"
							}
						},
						parent = abilitySlot,
						callbackOnClose = function()
							GameInteractions:advanceInteraction(__env, defeatSeaMonster, 1)
						end
					})
					table.insert(self.disconnects, connect(abilitySlot:recursiveGetChildById("icon"), {
						onDragEnter = self.callbacks.UIWidget.onDragEnter
					}, true))
					table.insert(self.disconnects, connect(LocalPlayer, {
						onTeleport = self.callbacks.LocalPlayer.onTeleport
					}))
				end
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
