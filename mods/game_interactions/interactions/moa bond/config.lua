-- chunkname: @/modules/game_interactions/interactions/moa bond/config.lua

__env = __env or {}
quest_name = "Moa Bond"
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
							text = "Since you have a dependable moa by your side now, we should talk about how to properly take care of them!"
						},
						{
							text = "Moas are very efficient mounts, that's for sure. But they are also very emotional creatures!"
						},
						{
							text = "The more time you spend riding a moa, the stronger your bond will become. Let me show you."
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

				if not transportWindow:isVisible() then
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
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
				end
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
				}
			},
			onStartInteraction = function(self)
				local transportModule = modules.game_transport.GameTransport
				local transportWindow = transportModule.window

				if transportWindow:isVisible() then
					GameInteractions:displayDescriptionBox({
						preferSide = "top",
						bandit = true,
						pages = {
							{
								text = "This bar represents your Moa's Bond Level, which is how strong the relation between you two currently is."
							},
							{
								text = "The higher your bond, the better are the benefits it provides you."
							},
							{
								text = "You can always check the many features unlocked through Bond Level in the informative icon."
							},
							{
								text = "A Moa will gain Bond Experience while you're riding it, but only when its stamina bar is not depleted."
							}
						},
						parent = transportWindow:recursiveGetChildById("mount_top_panel"),
						callbackOnClose = function()
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					})
					table.insert(self.disconnects, connect(transportWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_transport
					}))
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				Player = {
					onOutfitChange_transport = function(player, outfit)
						if outfit.mount ~= 0 then
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

				local abilitySlot = AbilityBar.mountSkillWidget

				if player:getOutfit().mount == 0 then
					GameInteractions:displayActionBox({
						preferSide = "top",
						text = "Press Ctrl+R or Left-Click to mount.",
						bandit = true,
						keys = {
							"Ctrl+R",
							MouseLeftButton
						},
						parent = abilitySlot
					})
					table.insert(self.disconnects, connect(LocalPlayer, {
						onOutfitChange = self.callbacks.Player.onOutfitChange_transport
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
					onVisibilityChange_stamina = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local player = g_game.getLocalPlayer()

				if not player then
					return
				end

				local healthInfoModule = modules.game_healthinfo
				local mountHud = healthInfoModule.mountHud

				if mountHud:isVisible() then
					GameInteractions:displayDescriptionBox({
						preferSide = "top",
						bandit = true,
						pages = {
							{
								text = "This gauge below your health and mana represents how much stamina your active Moa currently has."
							},
							{
								text = "If the stamina runs out, it will fall into the \"Hungry\" status and must be fed!"
							},
							{
								text = "To feed a moa, simply acquire Moa Rations from the vendor and use them from your inventory tab."
							},
							{
								text = "A skilled cook can craft sophisticated rations that restore even more stamina and grant your Moa temporary bonuses!"
							},
							{
								text = "You can also give them Moa Treats to make them Bond faster with you. They love those!"
							},
							{
								text = "However, Treats can't be bought or crafted, and only found throughout your adventures. So be on the lookout for those!"
							},
							{
								text = "Last but not least: if a moa is passed down to a new owner, its Bond Level will go back to 1. Keep this in mind!"
							},
							{
								text = tr("Quite the lesson, huh, %s? I'm sure you'll be forging a solid bond with your trusty moas! See you later.", player:getName())
							}
						},
						parent = mountHud.staminaBar,
						callbackOnClose = function()
							GameInteractions:completeInteraction(__env)
						end
					})
					table.insert(self.disconnects, connect(mountHud, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_stamina
					}))
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)
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
