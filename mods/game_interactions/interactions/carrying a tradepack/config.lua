-- chunkname: @/modules/game_interactions/interactions/carrying a tradepack/config.lua

__env = __env or {}
quest_name = "Carrying a tradepack"
current_task = 0
current_interaction = 0
tasks = {
	{
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						GameInteractions.action_window:setVisible(visible)
					end,
					onVisibilityChange_tradepacks = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local tradepacksWindow = modules.game_tradepacks.GameTradepacks.window

				if not tradepacksWindow:isVisible() then
					addEvent(function()
						modules.game_menu.Menu.icon:setOn(true)
					end)

					local parentWidget = modules.game_menu.Menu.window:recursiveGetChildById("tradepack")

					GameInteractions:displayActionBox({
						bandit = true,
						text = "Press T or Left-Click to open your Tradepacks menu",
						preferSide = "top",
						keys = {
							"T",
							MouseLeftButton
						},
						parent = parentWidget
					})
					table.insert(self.disconnects, connect(parentWidget, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(tradepacksWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_tradepacks
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
				}
			},
			onStartInteraction = function(self)
				GameInteractions:displayDescriptionBox({
					bandit = true,
					preferSide = "right",
					pages = {
						{
							text = "Everything inside this list can be crafted if you have the correct ingredients"
						}
					},
					parent = modules.game_tradepacks.GameTradepacks.list_panel,
					callbackOnClose = function(self)
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				})
				table.insert(self.disconnects, connect(modules.game_tradepacks.GameTradepacks.window, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				GameTradepacks = {
					onSelectTradepack = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
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
				local rightAttachedWindow = modules.game_tradepacks.GameTradepacks.rightAttachedWindow

				if rightAttachedWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)

					return
				end

				GameInteractions:displayActionBox({
					bandit = true,
					text = "Select any Tradepack from the list and have a look!",
					preferSide = "right",
					keys = {
						MouseLeftButton
					},
					parent = modules.game_tradepacks.GameTradepacks.list_panel
				})
				table.insert(self.disconnects, connect(modules.game_tradepacks.GameTradepacks, {
					onSelectTradepack = self.callbacks.GameTradepacks.onSelectTradepack
				}))
				table.insert(self.disconnects, connect(modules.game_tradepacks.GameTradepacks.window, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				GameTradepacks = {
					onDeSelectTradepack = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, 2)
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
				local rightAttachedWindow = modules.game_tradepacks.GameTradepacks.rightAttachedWindow

				if not rightAttachedWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 2)

					return
				end

				GameInteractions:displayDescriptionBox({
					bandit = true,
					preferSide = "top",
					pages = {
						{
							text = "A good thing to remember when you're deciding where to sell your supplies is the Tradeposts' demand!"
						},
						{
							text = "The green number indicates how much of the original price you'll receive in a specific Tradepost!"
						},
						{
							text = "And if you don't know where it is located, just click at the pinpoint on the right and the World Map will pop up to help you!"
						}
					},
					parent = rightAttachedWindow["Tradepost Location and Demand"],
					callbackOnClose = function(self)
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				})
				table.insert(self.disconnects, connect(modules.game_tradepacks.GameTradepacks, {
					onDeSelectTradepack = self.callbacks.GameTradepacks.onDeSelectTradepack
				}))
				table.insert(self.disconnects, connect(modules.game_tradepacks.GameTradepacks.window, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				GameTradepacks = {
					onOpenTradepackBags = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
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
				local rightAttachedWindow = modules.game_tradepacks.GameTradepacks.rightAttachedWindow

				if not rightAttachedWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 2)

					return
				end

				local leftAttachedWindow = modules.game_tradepacks.GameTradepacks.leftAttachedWindow

				if leftAttachedWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)

					return
				end

				local tradepacksWindow = modules.game_tradepacks.GameTradepacks.window

				GameInteractions:displayActionBox({
					bandit = true,
					text = "Now open your Tradepack Bags",
					preferSide = "top",
					keys = {
						MouseLeftButton
					},
					parent = tradepacksWindow:recursiveGetChildById("bagButton")
				})
				table.insert(self.disconnects, connect(modules.game_tradepacks.GameTradepacks, {
					onOpenTradepackBags = self.callbacks.GameTradepacks.onOpenTradepackBags
				}))
				table.insert(self.disconnects, connect(modules.game_tradepacks.GameTradepacks.window, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				GameTradepacks = {
					onCloseTradepackBags = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, 4)
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
				local leftAttachedWindow = modules.game_tradepacks.GameTradepacks.leftAttachedWindow

				if not leftAttachedWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 4)

					return
				end

				GameInteractions:displayDescriptionBox({
					bandit = true,
					preferSide = "left",
					pages = {
						{
							text = "Keep in mind you have only a single Tradepack slot in your character",
							callback = function(self)
								self.newParent = leftAttachedWindow:recursiveGetChildById("user")
							end
						},
						{
							text = "This means you can not have more than one Tradepack with you at a time",
							callback = function(self)
								self.newParent = leftAttachedWindow:recursiveGetChildById("user")
							end
						},
						{
							text = "But if you own a wagon or a ship, you'll be able to use their compartments and carry more!",
							callback = function(self)
								self.newParent = leftAttachedWindow:recursiveGetChildById("wagon")
							end
						},
						{
							text = "Well, I'm pretty sure you're good to start crafting and selling some packs for yourself now...",
							callback = function(self)
								self.newParent = GameInteractions.bandit_avatar
							end
						},
						{
							text = "Try it out whenever you can. The best way to learn is through practice!",
							callback = function(self)
								self.newParent = GameInteractions.bandit_avatar
							end
						}
					},
					parent = leftAttachedWindow:recursiveGetChildById("user"),
					callbackOnClose = function()
						GameInteractions:completeInteraction(__env)
					end
				})
				table.insert(self.disconnects, connect(modules.game_tradepacks.GameTradepacks, {
					onCloseTradepackBags = self.callbacks.GameTradepacks.onCloseTradepackBags
				}))
				table.insert(self.disconnects, connect(modules.game_tradepacks.GameTradepacks.window, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
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
