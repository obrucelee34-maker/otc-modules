-- chunkname: @/modules/game_interactions/interactions/reputation/config.lua

__env = __env or {}
quest_name = "Reputation"
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
							text = "Seems like that Fritz guy hates goblins like they were devils..."
						},
						{
							text = tr("But you handled that conversation pretty well, %s!", g_game.getCharacterName())
						},
						{
							text = "Just be careful! Sometimes, your answers can change the way people look at you..."
						},
						{
							text = "And little by little you may end up becoming well-known"
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
					onVisibilityChange_reputation = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local reputationWindow = modules.game_reputation.GameReputation.window

				if not reputationWindow:isVisible() then
					addEvent(function()
						modules.game_menu.Menu.icon:setOn(true)
					end)

					local parentWidget = modules.game_menu.Menu.window:recursiveGetChildById("reputation")

					GameInteractions:displayActionBox({
						preferSide = "top",
						text = "Press H or Left-Click to open your Reputation Tree",
						keys = {
							"H",
							MouseLeftButton
						},
						parent = parentWidget
					})
					table.insert(self.disconnects, connect(parentWidget, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(reputationWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_reputation
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
				}
			},
			onStartInteraction = function(self)
				local reputationWindow = modules.game_reputation.GameReputation.window

				if not reputationWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)
				else
					GameInteractions:displayDescriptionBox({
						preferSide = "top",
						bandit = true,
						pages = {
							{
								text = "Here in Ravendawn, many things you do will be reflected on one of these paths"
							},
							{
								text = "Order, Mercenary or Criminal"
							},
							{
								text = "And as you build up reputation points, you'll be able to unlock exclusive perks!"
							},
							{
								text = "So you better think twice before messing around with anyone, for some actions can be more impactful than you'd imagine!"
							}
						},
						parent = reputationWindow,
						callbackOnClose = function()
							GameInteractions:completeInteraction(__env)
						end
					})
					table.insert(self.disconnects, connect(reputationWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
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
