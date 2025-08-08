-- chunkname: @/modules/game_interactions/interactions/farming/config.lua

__env = __env or {}
quest_name = "Farming"
current_task = 0
current_interaction = 0
tasks = {
	{
		{
			disconnects = {},
			callbacks = {
				GameQuestLog = {
					onRemoveTask = function(questName, taskId)
						if questName:lower() == "the city of ravencrest" and taskId == 4 then
							GameInteractions:completeInteraction(__env)
						end
					end
				}
			},
			onStartInteraction = function(self)
				GameInteractions:displayDescriptionBox({
					pages = {
						{
							text = "Hey, buddy! I'm here to help you with that, so no worries!"
						}
					},
					parent = GameInteractions.bandit_avatar,
					callbackOnClose = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				})
				table.insert(self.disconnects, connect(modules.game_questlog.GameQuestLog, {
					onRemoveTask = self.callbacks.GameQuestLog.onRemoveTask
				}))
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
					end
				}
			},
			onStartInteraction = function(self)
				local infoWindow = modules.game_house.GameHouse.current_info_window

				if infoWindow then
					infoWindow:hide()
				end

				local houseWindow = modules.game_house.GameHouse.bottom_panel

				if not houseWindow:isVisible() then
					GameInteractions:displayActionBox({
						text = "To start managing your Farmland, click on that house button next to the minimap",
						bandit = true,
						keys = {
							MouseLeftButton
						},
						parent = modules.game_minimap.minimapWindow:recursiveGetChildById("houseMakerButton")
					})
					table.insert(self.disconnects, connect(houseWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
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
					end
				},
				GameHouse = {
					onSelectMenuWidget = function(self, widget)
						if widget:getId() ~= "farm" then
							return true
						end

						return false
					end,
					onSelectSubMenuWidget = function(self, menu, submenu)
						if menu:getId() ~= "farm" or submenu ~= "farming" then
							return true
						end

						return false
					end,
					onSelectListWidget = function()
						return true
					end
				}
			},
			onStartInteraction = function(self)
				local houseWindow = modules.game_house.GameHouse.bottom_panel

				if not houseWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)
				else
					GameInteractions:displayDescriptionBox({
						preferSide = "top",
						bandit = true,
						pages = {
							{
								text = "Placing crops and animal pens is really easy!"
							},
							{
								text = "Since you are already in the Farming section...",
								callback = function(self)
									self.newParent = houseWindow:recursiveGetChildById("filter_panel")
								end
							},
							{
								text = "You just need to choose which item you want from this list.",
								callback = function(self)
									self.newParent = houseWindow.middle_panel.content
								end
							}
						},
						parent = houseWindow:recursiveGetChildById("filter_panel"),
						callbackOnClose = function()
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					})
					table.insert(self.disconnects, connect(houseWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(modules.game_house.GameHouse, {
						onSelectMenuWidget = self.callbacks.GameHouse.onSelectMenuWidget
					}))
					table.insert(self.disconnects, connect(modules.game_house.GameHouse, {
						onSelectSubMenuWidget = self.callbacks.GameHouse.onSelectSubMenuWidget
					}))
					table.insert(self.disconnects, connect(modules.game_house.GameHouse, {
						onSelectListWidget = self.callbacks.GameHouse.onSelectListWidget
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
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				},
				GameHouse = {
					onSelectMenuWidget = function(self, widget)
						if widget:getId() ~= "farm" then
							return true
						end

						return false
					end,
					onSelectSubMenuWidget = function(self, menu, submenu)
						if menu:getId() ~= "farm" or submenu ~= "farming" then
							return true
						end

						return false
					end,
					onSelectListWidget = function()
						return true
					end
				}
			},
			onStartInteraction = function(self)
				local houseWindow = modules.game_house.GameHouse.bottom_panel

				if not houseWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)
				else
					GameInteractions:displayDescriptionBox({
						preferSide = "top",
						bandit = true,
						pages = {
							{
								text = "This icon on top of the frame is the amount of Effort required to place such item in the Community Land",
								callback = function(self)
									self.newParent = GameHouse:getListItemWidgetByName("potato")
									self.bandit = true
								end
							},
							{
								text = "Here is where you see your current Effort, and you can restore it by doing open-world activities such as quests and monster hunting!",
								callback = function(self)
									self.newParent = houseWindow:recursiveGetChildById("effort_amount")
									self.bandit = true
								end
							},
							{
								text = "Keep in mind once you buy a plot of land and build your own house, the Community Farm won't be available anymore",
								callback = function(self)
									self.newParent = GameInteractions.bandit_avatar
									self.bandit = false
								end
							},
							{
								text = "So practice on it as long as you can, that way you'll know exactly how to manage Effort on your own land!",
								callback = function(self)
									self.newParent = GameInteractions.bandit_avatar
									self.bandit = false
								end
							}
						},
						parent = GameHouse:getListItemWidgetByName("potato"),
						callbackOnClose = function()
							GameInteractions:advanceTask(__env)
						end
					})
					table.insert(self.disconnects, connect(houseWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(modules.game_house.GameHouse, {
						onSelectMenuWidget = self.callbacks.GameHouse.onSelectMenuWidget
					}))
					table.insert(self.disconnects, connect(modules.game_house.GameHouse, {
						onSelectSubMenuWidget = self.callbacks.GameHouse.onSelectSubMenuWidget
					}))
					table.insert(self.disconnects, connect(modules.game_house.GameHouse, {
						onSelectListWidget = self.callbacks.GameHouse.onSelectListWidget
					}))
				end
			end
		}
	},
	{
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				},
				GameQuestLog = {
					onRemoveTask = function(questName, taskId)
						if questName:lower() == "the city of ravencrest" and taskId == 5 then
							GameInteractions:completeInteraction(__env)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local houseWindow = modules.game_house.GameHouse.bottom_panel

				if not houseWindow:isVisible() then
					GameInteractions:displayActionBox({
						text = "To start managing your Farmland, click on that house button next to the minimap",
						bandit = true,
						keys = {
							MouseLeftButton
						},
						parent = modules.game_minimap.minimapWindow:recursiveGetChildById("houseMakerButton")
					})
					table.insert(self.disconnects, connect(houseWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(modules.game_questlog.GameQuestLog, {
						onRemoveTask = self.callbacks.GameQuestLog.onRemoveTask
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
							GameInteractions:advanceInteraction(__env, __env.current_task, 0)
						end
					end
				},
				GameHouse = {
					onSelectMenuWidget = function(self, widget)
						if widget:getId() ~= "farm" then
							return true
						end

						return false
					end,
					onSelectSubMenuWidget = function(self, menu, submenu)
						if menu:getId() ~= "farm" or submenu ~= "farming" then
							return true
						end

						return false
					end,
					onSelectListWidget = function(self, menu, widget)
						if menu ~= "farm" then
							return true
						end

						if widget.data.name:lower() == "potato" then
							addEvent(function()
								GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
							end)

							return false
						end

						return true
					end
				}
			},
			onStartInteraction = function(self)
				local houseWindow = modules.game_house.GameHouse.bottom_panel
				local parentWidget = modules.game_house.GameHouse:getListItemWidgetByName("potato")

				if houseWindow:isVisible() then
					if parentWidget then
						GameInteractions:displayActionBox({
							preferSide = "top",
							text = "Now, since the farmer asked for potatoes, you should start by selecting them in the list",
							bandit = true,
							keys = {
								MouseLeftButton
							},
							parent = parentWidget
						})
					else
						return scheduleEvent(function()
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction - 1)
						end, 500)
					end

					table.insert(self.disconnects, connect(houseWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(modules.game_house.GameHouse, {
						onSelectMenuWidget = self.callbacks.GameHouse.onSelectMenuWidget
					}))
					table.insert(self.disconnects, connect(modules.game_house.GameHouse, {
						onSelectSubMenuWidget = self.callbacks.GameHouse.onSelectSubMenuWidget
					}))
					table.insert(self.disconnects, connect(modules.game_house.GameHouse, {
						onSelectListWidget = self.callbacks.GameHouse.onSelectListWidget
					}))
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, 0)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				GameHouse = {
					onSelectMenuWidget = function(self, widget)
						if widget:getId() ~= "farm" then
							return true
						end

						return false
					end,
					onSelectSubMenuWidget = function(self, menu, submenu)
						if menu:getId() ~= "farm" or submenu ~= "farming" then
							return true
						end

						return false
					end,
					onSelectListWidget = function(self, menu, widget)
						return true
					end
				},
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				},
				g_game = {
					onStartFarmPlacing = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				}
			},
			onStartInteraction = function(self)
				local houseWindow = modules.game_house.GameHouse.current_info_window

				if houseWindow:isVisible() then
					GameInteractions:displayActionBox({
						preferSide = "right",
						text = "Oh! I guess the munk ain't charging us a thing this time. Let's not waste the opportunity!",
						bandit = true,
						keys = {
							MouseLeftButton
						},
						parent = houseWindow:recursiveGetChildById("place_button")
					})
					table.insert(self.disconnects, connect(modules.game_house.GameHouse, {
						onSelectMenuWidget = self.callbacks.GameHouse.onSelectMenuWidget
					}))
					table.insert(self.disconnects, connect(modules.game_house.GameHouse, {
						onSelectSubMenuWidget = self.callbacks.GameHouse.onSelectSubMenuWidget
					}))
					table.insert(self.disconnects, connect(modules.game_house.GameHouse, {
						onSelectListWidget = self.callbacks.GameHouse.onSelectListWidget
					}))
					table.insert(self.disconnects, connect(houseWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(g_game, {
						onStartFarmPlacing = self.callbacks.g_game.onStartFarmPlacing
					}))
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, 0)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				g_game = {
					onCancelFarmPlacing = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, 2)
					end,
					onPlaceFarm = function(position)
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction, {
							position = position
						})
						modules.game_house.GameHouse:exitHouseMode()
					end
				},
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 0)
						end
					end
				}
			},
			onStartInteraction = function(self)
				GameInteractions:displayActionBox({
					preferSide = "top",
					text = "Now place the potatoes on the garden bed, but be sure to leave room for the Pig Pen as well!",
					bandit = true,
					keys = {
						MouseLeftButton
					},
					tilePos = {
						y = 5129,
						x = 5171,
						z = 7
					}
				})
				table.insert(self.disconnects, connect(g_game, {
					onCancelFarmPlacing = self.callbacks.g_game.onCancelFarmPlacing
				}))
				table.insert(self.disconnects, connect(g_game, {
					onPlaceFarm = self.callbacks.g_game.onPlaceFarm
				}))
				table.insert(self.disconnects, connect(modules.game_house.GameHouse.bottom_panel, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {},
			onStartInteraction = function(self, args)
				GameInteractions:displayDescriptionBox({
					preferSide = "top",
					bandit = true,
					pages = {
						{
							text = "All that's left to do now is wait for them to grow and be ready for harvesting!"
						}
					},
					tilePos = args.position,
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
