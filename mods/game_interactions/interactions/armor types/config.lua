-- chunkname: @/modules/game_interactions/interactions/armor types/config.lua

__env = __env or {}
quest_name = "Armor Types"
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
							text = tr("You're getting used to this new world pretty quickly, %s!", g_game.getCharacterName())
						},
						{
							text = "Now you have a fine weapon and a good set of skills, I suggest you take a look at that armor of yours..."
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
					onVisibilityChange_character = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local characterWindow = modules.game_character.GameCharacter.window

				if not characterWindow:isVisible() then
					addEvent(function()
						modules.game_menu.Menu.icon:setOn(true)
					end)

					local parentWidget = modules.game_menu.Menu.window:recursiveGetChildById("character")

					GameInteractions:displayActionBox({
						bandit = true,
						text = "Press X or Left-Click to open your Character menu",
						preferSide = "top",
						keys = {
							"X",
							MouseLeftButton
						},
						parent = parentWidget
					})
					table.insert(self.disconnects, connect(parentWidget, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(characterWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_character
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
				local characterWindow = modules.game_character.GameCharacter.window

				if not characterWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				local helmetSlot = modules.game_character.GameCharacter.window:recursiveGetChildById("helmet")

				GameInteractions:displayDescriptionBox({
					pages = {
						{
							text = "There are three categories of armors: cloth, leather and plate, also known as light, medium and heavy"
						},
						{
							text = "You can wear up to four different parts of armor: helmet, torso, legs and boots"
						},
						{
							text = "However, keep in mind you receive a specific bonus for every two pieces of armor of the same category you have equipped!"
						},
						{
							text = "Cloth armors increase Haste and Magical Defense Power"
						},
						{
							text = "Leather armors increase Critical Chance and reduce durations of Stun and Slow effects"
						},
						{
							text = "Plate armors increase maximum health, healing received and Physical Defense Power"
						},
						{
							text = "You better be careful while choosing which one to wear, because it may be the difference between life and death!"
						}
					},
					parent = helmetSlot,
					callbackOnClose = function()
						GameInteractions:completeInteraction(__env)
					end
				})
				table.insert(self.disconnects, connect(characterWindow, {
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
