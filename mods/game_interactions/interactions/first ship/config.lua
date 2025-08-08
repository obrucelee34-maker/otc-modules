-- chunkname: @/modules/game_interactions/interactions/first ship/config.lua

__env = __env or {}
quest_name = "First Ship"
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
							text = tr("Are you prepared to go back to the sea, %s?", g_game.getCharacterName())
						},
						{
							text = "I feel like that giant squid we once had to face is just one of the many dangers we could find around these waters..."
						},
						{
							text = "But if we're not brave enough to face them, we'll grow roots standing on the shore!"
						}
					},
					parent = GameInteractions.bandit_avatar,
					callbackOnClose = function()
						GameInteractions:closeDescriptionBox()
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
					onVisibilityChange_transport = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local transportWindow = modules.game_transport.GameTransport.window

				if transportWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)

					return
				end

				addEvent(function()
					modules.game_menu.Menu.icon:setOn(true)
				end)

				local parentWidget = modules.game_menu.Menu.window:recursiveGetChildById("transports")

				GameInteractions:displayActionBox({
					preferSide = "top",
					text = "Press Y or Left-Click to open your Transport menu",
					bandit = true,
					keys = {
						"Y",
						MouseLeftButton
					},
					parent = parentWidget
				})
				table.insert(self.disconnects, connect(parentWidget, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
				}))
				table.insert(self.disconnects, connect(transportWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_transport
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_attachedWindow = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 2)
						end
					end,
					onVisibilityChange_transport = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				},
				GameTransport = {
					onCategoryChange = function(category, subcategory)
						if category ~= "ship" or subcategory ~= "hull" then
							return true
						end

						return false
					end,
					onOutfitListUpdate = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				}
			},
			onStartInteraction = function(self)
				local transportWindow = modules.game_transport.GameTransport.window

				if not transportWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				local attachedWindow = modules.game_transport.GameTransport.attachedWindow

				if attachedWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)

					return
				end

				local parentWidget = transportWindow.content.ship_panel.ship_content.button_panel.hull
				local parentPanel = transportWindow.content

				parentPanel:ensureChildVisible(parentWidget)
				GameInteractions:displayActionBox({
					preferSide = "top",
					text = "Click on the Hull slot",
					bandit = true,
					keys = {
						MouseLeftButton
					},
					parent = parentWidget
				})
				table.insert(self.disconnects, connect(parentPanel.verticalScrollBar, {
					onValueChange = function()
						parentPanel:ensureChildVisible(parentWidget)
					end
				}))
				table.insert(self.disconnects, connect(transportWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_transport
				}))
				table.insert(self.disconnects, connect(attachedWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_attachedWindow
				}))
				table.insert(self.disconnects, connect(modules.game_transport.GameTransport, {
					onCategoryChange = self.callbacks.GameTransport.onCategoryChange,
					onOutfitListUpdate = self.callbacks.GameTransport.onOutfitListUpdate
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_attachedWindow = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 3)
						end
					end
				},
				GameTransport = {
					onUpdateOutfit = function(outfit)
						if outfit.shipBody ~= 0 then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end,
					onCategoryChange = function(category, subcategory)
						if category ~= "ship" or subcategory ~= "hull" then
							return true
						end

						return false
					end
				}
			},
			onStartInteraction = function(self)
				local attachedWindow = modules.game_transport.GameTransport.attachedWindow

				if not attachedWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 2)

					return
				end

				local parentWidget = attachedWindow.outfit_list:getFirstChild()

				if not parentWidget then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				GameInteractions:displayActionBox({
					preferSide = "top",
					text = "Select which hull you want for your ship",
					bandit = true,
					keys = {
						MouseLeftButton
					},
					parent = parentWidget
				})
				table.insert(self.disconnects, connect(attachedWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_attachedWindow
				}))
				table.insert(self.disconnects, connect(modules.game_transport.GameTransport, {
					onUpdateOutfit = self.callbacks.GameTransport.onUpdateOutfit,
					onCategoryChange = self.callbacks.GameTransport.onCategoryChange
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_attachedWindow = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 4)
						end
					end,
					onVisibilityChange_transport = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				},
				GameTransport = {
					onCategoryChange = function(category, subcategory)
						if category ~= "ship" or subcategory ~= "sail" then
							return true
						end

						return false
					end,
					onOutfitListUpdate = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				}
			},
			onStartInteraction = function(self)
				local transportWindow = modules.game_transport.GameTransport.window

				if not transportWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				local attachedWindow = modules.game_transport.GameTransport.attachedWindow

				if attachedWindow:isVisible() then
					modules.game_transport.GameTransport:hideAttachedWindow()
				end

				local parentWidget = transportWindow.content.ship_panel.ship_content.button_panel.sail
				local parentPanel = transportWindow.content

				parentPanel:ensureChildVisible(parentWidget)
				GameInteractions:displayActionBox({
					preferSide = "top",
					text = "Now do the same with the sail. Just click here...",
					bandit = true,
					keys = {
						MouseLeftButton
					},
					parent = parentWidget
				})
				table.insert(self.disconnects, connect(parentPanel.verticalScrollBar, {
					onValueChange = function()
						parentPanel:ensureChildVisible(parentWidget)
					end
				}))
				table.insert(self.disconnects, connect(transportWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_transport
				}))
				table.insert(self.disconnects, connect(attachedWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_attachedWindow
				}))
				table.insert(self.disconnects, connect(modules.game_transport.GameTransport, {
					onCategoryChange = self.callbacks.GameTransport.onCategoryChange,
					onOutfitListUpdate = self.callbacks.GameTransport.onOutfitListUpdate
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_attachedWindow = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 3)
						end
					end
				},
				GameTransport = {
					onUpdateOutfit = function(outfit)
						if outfit.shipBody ~= 0 then
							GameInteractions:advanceTask(__env)
						end
					end,
					onCategoryChange = function(category, subcategory)
						if category ~= "ship" or subcategory ~= "hull" then
							return true
						end

						return false
					end
				}
			},
			onStartInteraction = function(self)
				local attachedWindow = modules.game_transport.GameTransport.attachedWindow

				if not attachedWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 4)

					return
				end

				local parentWidget = attachedWindow.outfit_list:getFirstChild()

				if not parentWidget then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				GameInteractions:displayActionBox({
					preferSide = "top",
					text = "And select which sail you want.",
					bandit = true,
					keys = {
						MouseLeftButton
					},
					parent = parentWidget
				})
				table.insert(self.disconnects, connect(attachedWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_attachedWindow
				}))
				table.insert(self.disconnects, connect(modules.game_transport.GameTransport, {
					onUpdateOutfit = self.callbacks.GameTransport.onUpdateOutfit,
					onCategoryChange = self.callbacks.GameTransport.onCategoryChange
				}))
			end
		}
	},
	{
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						GameInteractions.action_window:setVisible(visible)
					end,
					onVisibilityChange_transport = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local transportWindow = modules.game_transport.GameTransport.window

				if transportWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)

					return
				end

				addEvent(function()
					modules.game_menu.Menu.icon:setOn(true)
				end)

				local parentWidget = modules.game_menu.Menu.window:recursiveGetChildById("transports")

				GameInteractions:displayActionBox({
					preferSide = "top",
					text = "Press Y or Left-Click to open your Transport menu",
					bandit = true,
					keys = {
						"Y",
						MouseLeftButton
					},
					parent = parentWidget
				})
				table.insert(self.disconnects, connect(parentWidget, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
				}))
				table.insert(self.disconnects, connect(transportWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_transport
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_transport = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 0)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local transportWindow = modules.game_transport.GameTransport.window

				if not transportWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 0)

					return
				end

				GameInteractions:displayDescriptionBox({
					preferSide = "top",
					bandit = true,
					pages = {
						{
							text = "Although a hull and a sail is everything you need to leave the dock, you can also upgrade your ship with cabins and cargo compartments"
						},
						{
							text = "By enhancing your ship, you upgrade their status such as health, speed and tradepack slots"
						},
						{
							text = "And all upgrades can be done by talking with a Ship Builder!"
						}
					},
					parent = modules.game_transport.GameTransport.window.content.ship_panel.ship_content.ship_preview_panel,
					callbackOnClose = function()
						GameInteractions:completeInteraction(__env)
					end
				})
				table.insert(self.disconnects, connect(transportWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_transport
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
