-- chunkname: @/modules/game_interactions/interactions/character interactions/config.lua

__env = __env or {}
quest_name = "Character Interactions"
current_task = 0
current_interaction = 0
tasks = {
	{
		{
			disconnects = {},
			callbacks = {},
			onStartInteraction = function(self)
				GameInteractions:displayDescriptionBox({
					preferSide = "right",
					pages = {
						{
							text = tr(string.format("No time to waste, |%s|!", g_game.getCharacterName()))
						},
						{
							text = "Did you know there's a whole set of actions you can perform by holding Ctrl and right-clicking a character?"
						},
						{
							text = "Try holding Ctrl and right-click someone, even yourself! You'll see a list of options..."
						},
						{
							text = "",
							callback = function()
								GameInteractions:closeDescriptionBox(true)
							end
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
				UIPopupMenu = {
					onGameMenuDisplay = function(popupMenu)
						if popupMenu:getId() == "thingMenu" then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local player = g_game.getLocalPlayer()

				if not player then
					return
				end

				GameInteractions:displayActionBox({
					preferSide = "right",
					text = "Press Ctrl + Right-Click to display menu.",
					bandit = true,
					keySpacer = "GameInteractionsKeySpacerPlus",
					keys = {
						"Ctrl",
						MouseRightButton
					},
					creatureId = player:getId(),
					callbackOnClose = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				})
				table.insert(self.disconnects, connect(UIPopupMenu, {
					onGameMenuDisplay = self.callbacks.UIPopupMenu.onGameMenuDisplay
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
							text = "While there's only a few actions you can take interacting with yourself, that completely changes when doing the same to other players"
						},
						{
							text = "With this same command, you are able to do things such as Follow and Trade with someone, or Invite them to your Party!"
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
