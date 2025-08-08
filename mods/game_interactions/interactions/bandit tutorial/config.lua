-- chunkname: @/modules/game_interactions/interactions/bandit tutorial/config.lua

__env = __env or {}
quest_name = "Bandit Tutorial"
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
							text = "Ah, now I can finally rest"
						},
						{
							text = tr("But don't worry, %s! I promise to stay alert!", g_game.getCharacterName())
						},
						{
							text = "And whenever you need a hand with something, I can come to your aid!"
						}
					},
					parent = GameInteractions.bandit_avatar,
					callbackOnClose = function(self)
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				})
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_tutorial = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local tutorialWindow = modules.game_interactions.GameInteractions.list_window

				if not tutorialWindow:isVisible() then
					GameInteractions:displayActionBox({
						bandit = true,
						text = "Just click right here...",
						preferSide = "top",
						keys = {
							MouseLeftButton
						},
						parent = GameInteractions.bandit_avatar
					})
					table.insert(self.disconnects, connect(tutorialWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_tutorial
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
					onVisibilityChange_tutorial = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local tutorialWindow = modules.game_interactions.GameInteractions.list_window

				if not tutorialWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				GameInteractions:displayDescriptionBox({
					bandit = true,
					preferSide = "top",
					pages = {
						{
							text = "And you will see a list of all subjects we haven't talked about yet!"
						}
					},
					parent = tutorialWindow.content,
					callbackOnClose = function(self)
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				})
				table.insert(self.disconnects, connect(tutorialWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_tutorial
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_tutorial = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end,
					onClick = function(widget, mousePos, mouseButton)
						GameInteractions:completeInteraction(__env)
					end
				}
			},
			onStartInteraction = function(self)
				local tutorialWindow = modules.game_interactions.GameInteractions.list_window

				if not tutorialWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				local parentWidget = tutorialWindow.content:getFirstChild().start_button

				GameInteractions:displayActionBox({
					preferSide = "top",
					text = "Now click right here to select the unstarted topic",
					bandit = true,
					parent = parentWidget,
					keys = {
						MouseLeftButton
					}
				})
				table.insert(self.disconnects, connect(tutorialWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_tutorial,
					onClick = self.callbacks.UIWidget.onClick
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
