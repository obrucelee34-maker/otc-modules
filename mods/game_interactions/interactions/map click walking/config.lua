-- chunkname: @/modules/game_interactions/interactions/map click walking/config.lua

__env = __env or {}
quest_name = "Map Click Walking"
current_task = 0
current_interaction = 0
tasks = {
	{
		{
			disconnects = {},
			callbacks = {},
			onStartInteraction = function(self)
				GameInteractions:displayDescriptionBox({
					preferSide = "left",
					pages = {
						{
							text = tr("You're taking your first steps into a wider world, %s! And your minimap is a valuable tool.", g_game.getCharacterName())
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
				g_game = {
					onAutoWalk = function(dirs, fromMinimap)
						if fromMinimap then
							GameInteractions:advanceTask(__env)
						end
					end
				}
			},
			onStartInteraction = function(self)
				GameInteractions:displayActionBox({
					preferSide = "left",
					keys = {
						MouseLeftButton
					},
					text = tr("Try it out! Click on any land on your minimap and watch yourself go."),
					parent = modules.game_minimap.minimapWindow
				})
				table.insert(self.disconnects, connect(g_game, {
					onAutoWalk = self.callbacks.g_game.onAutoWalk
				}))
			end
		}
	},
	{
		{
			disconnects = {},
			callbacks = {},
			onStartInteraction = function(self)
				GameInteractions:displayDescriptionBox({
					preferSide = "left",
					pages = {
						{
							text = "However, if you want to walk short distances, you can simply click on any tile on your screen!"
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
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			onStartInteraction = function(self)
				if modules.game_settings.getOption("enableMapClick") then
					GameInteractions:advanceTask(__env)

					return
				end

				local settingsWindow = modules.game_settings.GameSettings.window

				if not settingsWindow:isVisible() then
					addEvent(function()
						modules.game_menu.Menu.icon:setOn(true)
					end)

					local parentWidget = modules.game_menu.Menu.window:recursiveGetChildById("settings")
					local hotkeyCombo = GameHotkeyManager:getHotkeyMainKeyCombo(HOTKEYS_IDS.SETTINGS, "Not assigned")

					GameInteractions:displayActionBox({
						preferSide = "top",
						width = 220,
						keys = {
							hotkeyCombo,
							MouseLeftButton
						},
						text = tr(string.format("To do that, you must activate this setting by clicking (|%s|) or the settings icon here.", hotkeyCombo)),
						parent = parentWidget
					})
					table.insert(self.disconnects, connect(settingsWindow, {
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
					end,
					onStateChange = function(widget, value)
						if value then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				},
				GameSettings = {
					onOptionChange = function(option, value)
						if option == "enableMapClick" and value then
							GameInteractions:advanceTask(__env)
						end
					end
				}
			},
			onStartInteraction = function(self)
				if modules.game_settings.getOption("enableMapClick") then
					GameInteractions:advanceTask(__env)

					return
				end

				local settingsWindow = modules.game_settings.GameSettings.window

				if not settingsWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				local gameOptionsTab = modules.game_settings.GameSettings:getTabButtonByName("Game")

				if gameOptionsTab:isOn() then
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)

					return
				end

				table.insert(self.disconnects, connect(settingsWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
				}))
				table.insert(self.disconnects, connect(gameOptionsTab, {
					onStateChange = self.callbacks.UIWidget.onStateChange
				}))
				table.insert(self.disconnects, connect(modules.game_settings.GameSettings, {
					onOptionChange = self.callbacks.GameSettings.onOptionChange
				}))
				GameInteractions:displayActionBox({
					preferSide = "left",
					text = tr("Then navigate to the \"Game\" menu."),
					parent = gameOptionsTab,
					keys = {
						MouseLeftButton
					}
				})
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
					onStateChange = function(widget, value)
						if not value then
							GameInteractions:advanceInteraction(__env, __env.current_task, 2)
						end
					end
				},
				GameSettings = {
					onOptionChange = function(option, value)
						if option == "enableMapClick" and value then
							GameInteractions:advanceTask(__env)
						end
					end
				}
			},
			onStartInteraction = function(self)
				if modules.game_settings.getOption("enableMapClick") then
					GameInteractions:advanceTask(__env)

					return
				end

				local settingsWindow = modules.game_settings.GameSettings.window

				if not settingsWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				local gameOptionsTab = modules.game_settings.GameSettings:getTabButtonByName("Game")

				if not gameOptionsTab:isOn() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 2)

					return
				end

				addEvent(function()
					local enableMapClickOption = settingsWindow:recursiveGetChildById("enableMapClick")

					if not enableMapClickOption then
						GameInteractions:advanceInteraction(__env, __env.current_task, 2)

						return
					end

					table.insert(self.disconnects, connect(settingsWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(gameOptionsTab, {
						onStateChange = self.callbacks.UIWidget.onStateChange
					}))
					table.insert(self.disconnects, connect(modules.game_settings.GameSettings, {
						onOptionChange = self.callbacks.GameSettings.onOptionChange
					}))
					GameInteractions:displayActionBox({
						preferSide = "left",
						text = tr("And activate the \"Click to move\" option!"),
						parent = enableMapClickOption,
						keys = {
							MouseLeftButton
						}
					})
				end)
			end
		}
	},
	{
		{
			disconnects = {},
			callbacks = {},
			onStartInteraction = function(self)
				GameInteractions:displayDescriptionBox({
					preferSide = "left",
					bandit = true,
					pages = {
						{
							text = tr("Woof woof!")
						}
					},
					parent = modules.game_minimap.minimapWindow,
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
