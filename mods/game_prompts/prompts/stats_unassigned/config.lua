-- chunkname: @/modules/game_prompts/prompts/stats_unassigned/config.lua

__env = __env or {}
client_only = true
save_progress = false
current_task = 0
current_prompt = 0
tasks = {
	{
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_menuWidget = function(widget, visible)
						if visible then
							GamePrompts:advancePrompt(__env, __env.current_task, __env.current_prompt)
						end
					end,
					onVisibilityChange_character = function(widget, visible)
						if visible then
							GamePrompts:completePrompt(__env)
						end
					end
				}
			},
			onStartPrompt = function(self)
				local characterWindow = modules.game_character.GameCharacter.window

				if characterWindow:isVisible() then
					GamePrompts:completePrompt(__env)

					return
				end

				table.insert(self.disconnects, connect(characterWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_character
				}))

				local menuWidget = modules.game_interface.gameHUDPanel:getChildById("menuWidget")

				if menuWidget:isExplicitlyVisible() then
					GamePrompts:advancePrompt(__env, __env.current_task, __env.current_prompt)
				else
					table.insert(self.disconnects, connect(menuWidget, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_menuWidget
					}))
					GamePrompts:displayActionBox(__env, {
						margin = 8,
						preferSide = "left",
						width = 360,
						keys = {},
						text = tr("You have unassigned attribute points"),
						parent = modules.game_interface.gameHUDPanel:getChildById("menuIcon"),
						closeButton = {
							customStyle = "GamePromptsMiddleCloseButton",
							top = AnchorTop,
							horizontalCenter = AnchorHorizontalCenter,
							margin = {
								top = -9
							}
						},
						onClick = function(widget)
							characterWindow:show()
						end
					})
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if not visible then
							GamePrompts:advancePrompt(__env, __env.current_task, 0)
						end
					end,
					onVisibilityChange_character = function(widget, visible)
						if visible then
							GamePrompts:completePrompt(__env)
						end
					end
				}
			},
			displayPrompt = function(self)
				local characterWindow = modules.game_character.GameCharacter.window

				if not characterWindow:isVisible() then
					local menuWidget = modules.game_interface.gameHUDPanel:getChildById("menuWidget")

					if not menuWidget:isExplicitlyVisible() then
						GamePrompts:advancePrompt(__env, __env.current_task, 0)

						return
					end

					local parentWidget = modules.game_menu.Menu.window:recursiveGetChildById("character")

					GamePrompts:displayActionBox(__env, {
						width = 360,
						preferSide = "top",
						keys = {},
						text = tr("You have unassigned attribute points"),
						parent = parentWidget,
						closeButton = {
							customStyle = "GamePromptsMiddleCloseButton",
							top = AnchorTop,
							horizontalCenter = AnchorHorizontalCenter,
							margin = {
								top = -9
							}
						},
						onClick = function(widget)
							characterWindow:show()
						end
					})
					table.insert(self.disconnects, connect(parentWidget, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(characterWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_character
					}))
				else
					GamePrompts:completePrompt(__env)
				end
			end,
			onStartPrompt = function(self)
				self.displayPrompt(self)
			end
		}
	}
}
callbacks = {
	onCustomPrompt = function(data)
		if current_task ~= data.stage then
			GamePrompts:closeActionBox()
			GamePrompts:closeDescriptionBox()
			GamePrompts:advancePrompt(__env, data.stage or 1, 0)
		else
			GamePrompts:advancePrompt(__env, data.stage or 1, data.prompt or 0)
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
