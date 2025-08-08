-- chunkname: @/modules/game_interactions/interactions/first mount/config.lua

__env = __env or {}
quest_name = "First Mount"
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
							text = "This is such an exciting moment! You just received your first Moa!"
						},
						{
							text = "I told you about giant bird mounts when we first got to Ravendawn, remember?"
						},
						{
							text = "Full-grown Moas make the best mounts around here"
						},
						{
							text = "Atop one, you can pull tradecarts and travel much faster than you would on foot"
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
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				},
				GameTransport = {
					onCategoryChange = function(category, subcategory)
						if category ~= "mount" or subcategory ~= "mount" then
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

				modules.game_transport.GameTransport:hideAttachedWindow()

				local parentWidget = modules.game_transport.GameTransport.window.content.mount_panel.mount_content.button_panel.mount
				local parentPanel = modules.game_transport.GameTransport.window.content

				parentPanel:ensureChildVisible(parentWidget)
				GameInteractions:displayDescriptionBox({
					bandit = true,
					pages = {
						{
							text = "These slots represent your active mount and its equipped gear"
						},
						{
							text = "But since you're just getting started, there's not much to show..."
						}
					},
					parent = transportWindow.content.mount_panel.mount_content.button_panel.mount,
					callbackOnClose = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				})
				table.insert(self.disconnects, connect(transportWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_transport
				}))
				table.insert(self.disconnects, connect(parentPanel.verticalScrollBar, {
					onValueChange = function()
						parentPanel:ensureChildVisible(parentWidget)
					end
				}))
				table.insert(self.disconnects, connect(modules.game_transport.GameTransport.attachedWindow, {
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
					end,
					onVisibilityChange_transport = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				},
				GameTransport = {
					onCategoryChange = function(category, subcategory)
						if category ~= "mount" or subcategory ~= "mount" then
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

				local parentWidget = transportWindow.content.mount_panel.mount_content.button_panel.mount
				local parentPanel = transportWindow.content

				parentPanel:ensureChildVisible(parentWidget)
				GameInteractions:displayActionBox({
					preferSide = "top",
					text = "Click on the Mount slot",
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
						if outfit.mountBody ~= 0 then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end,
					onCategoryChange = function(category, subcategory)
						if category ~= "mount" or subcategory ~= "mount" then
							return true
						end

						return false
					end
				}
			},
			onStartInteraction = function(self)
				local attachedWindow = modules.game_transport.GameTransport.attachedWindow

				if not attachedWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 3)

					return
				end

				local parentWidget = attachedWindow.outfit_list:getFirstChild()

				if not parentWidget then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				GameInteractions:displayActionBox({
					preferSide = "top",
					text = "And select the moa as your active mount",
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
					onVisibilityChange_transport = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local transportWindow = modules.game_transport.GameTransport.window

				if not transportWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)

					return
				end

				local parentWidget = transportWindow.top_panel.close_button

				GameInteractions:displayActionBox({
					preferSide = "left",
					text = "You can now close the menu by pressing ESC or Y",
					bandit = true,
					keys = {
						MouseLeftButton,
						"ESC",
						"Y"
					},
					parent = parentWidget
				})
				table.insert(self.disconnects, connect(transportWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_transport
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				LocalPlayer = {
					onOutfitChange = function(outfit)
						if outfit.mount ~= 0 then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local keys, text
				local key = modules.game_hotkeys:getHotkeyMainKeyCombo(HOTKEYS_IDS.MOUNT_DISMOUNT)

				if string.find(key, "+", 1, true) and #key > 1 then
					keys = string.explode(key, "+")
					text = tr("Simply press %s in order to ride it!", table.concat(keys, " + "))
				else
					keys = {
						key
					}
					text = tr("Simply press %s in order to ride it!", key)
				end

				GameInteractions:displayActionBox({
					preferSide = "top",
					bandit = true,
					keys = keys,
					text = text,
					creatureId = g_game.getLocalPlayer():getId()
				})
				table.insert(self.disconnects, connect(LocalPlayer, {
					onOutfitChange = self.callbacks.LocalPlayer.onOutfitChange
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
							text = "But keep in mind Moas usually cannot be ridden into battle or inside buildings!"
						},
						{
							text = "And if engaged in combat, you will dismount automatically"
						},
						{
							text = "A moa is an essential companion in Ravendawn. So treat them well!"
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
