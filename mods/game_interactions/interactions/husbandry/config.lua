-- chunkname: @/modules/game_interactions/interactions/husbandry/config.lua

__env = __env or {}
quest_name = "Husbandry"
current_task = 0
current_interaction = 0
tasks = {
	{
		{
			disconnects = {},
			callbacks = {
				GameQuestLog = {
					onRemoveTask = function(questName, taskId)
						if questName:lower() == "the city of ravencrest" and taskId == 5 then
							GameInteractions:completeInteraction(__env)
						end
					end
				}
			},
			onStartInteraction = function(self)
				GameInteractions:displayDescriptionBox({
					pages = {
						{
							text = "Don't forget you were asked for a small pig pen as well... But no worries!"
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
						text = "Just open the Farm menu again...",
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
						if menu:getId() ~= "farm" or submenu ~= "husbandry" then
							return true
						end

						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)

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
					GameInteractions:displayActionBox({
						preferSide = "top",
						text = "And travel to the Husbandry tab",
						bandit = true,
						parent = houseWindow:recursiveGetChildById("husbandry"),
						keys = {
							MouseLeftButton
						}
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
						if menu:getId() ~= "farm" or submenu ~= "husbandry" then
							return true
						end

						return false
					end,
					onSelectListWidget = function(self, menu, widget)
						if menu ~= "farm" then
							return true
						end

						if widget.data.name:lower() == "small pig pen" then
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
				local parentWidget = modules.game_house.GameHouse:getListItemWidgetByName("small pig pen")

				if houseWindow:isVisible() then
					if parentWidget then
						GameInteractions:displayActionBox({
							preferSide = "top",
							text = "Select the Small Pig Pen from the list...",
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
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)
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
						if menu:getId() ~= "farm" or submenu ~= "husbandry" then
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
						text = "And place it just like you did with the potatoes!",
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
						GameInteractions:advanceInteraction(__env, __env.current_task, 4)
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
					text = "Keep in mind you gotta leave at least one empty tile between different products",
					bandit = true,
					keys = {
						MouseLeftButton
					},
					tilePos = {
						z = 7,
						y = 5129,
						x = 5171
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
			onStartInteraction = function(self)
				GameInteractions:displayDescriptionBox({
					pages = {
						{
							text = tr("This is looking great, %s I can almost feel like we're back at our old farm...", g_game.getCharacterName())
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
