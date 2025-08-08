-- chunkname: @/modules/game_interactions/interactions/bandit's teachings/config.lua

__env = __env or {}
quest_name = "Bandit's Teachings"
current_task = 0
current_interaction = 0
tasks = {
	{
		{
			disconnects = {},
			callbacks = {
				Menu = {
					onMenuIconClick = function()
						return true
					end
				}
			},
			onStartInteraction = function(self)
				GameInteractions:displayDescriptionBox({
					preferSide = "left",
					pages = {
						{
							text = "Ravendawn is a world full of mysteries to unveil and places to explore"
						},
						{
							text = "During your journey, you will face things that might seem a little hard to understand at a first glance. Professions, ships, house building..."
						},
						{
							text = "But that's why I'm here though! Whenever things become more complicated, you can count on me to ease them for you",
							callback = function(self)
								self.newParent = GameInteractions.bandit_avatar
								self.preferSide = "left"
								self.bandit = false
							end
						},
						{
							text = "Also, Bandit's Teachings can be opened by clicking on this icon as well",
							callback = function(self)
								addEvent(function()
									modules.game_menu.Menu.icon:setOn(true)
								end)

								self.newParent = modules.game_menu.Menu.window:recursiveGetChildById("tutorial")
								self.preferSide = "top"
								self.bandit = true
							end
						},
						{
							text = tr("If you don't mind now, %s, I need to take some rest...", g_game.getCharacterName()),
							callback = function(self)
								addEvent(function()
									modules.game_menu.Menu.icon:setOn(true)
								end)

								self.newParent = modules.game_menu.Menu.window:recursiveGetChildById("tutorial")
							end
						}
					},
					parent = GameInteractions.bandit_avatar,
					callbackOnClose = function()
						GameInteractions:completeInteraction(__env)
					end
				})
				table.insert(self.disconnects, connect(modules.game_menu.Menu, {
					onMenuIconClick = self.callbacks.Menu.onMenuIconClick
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
