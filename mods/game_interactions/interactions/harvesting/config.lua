-- chunkname: @/modules/game_interactions/interactions/harvesting/config.lua

__env = __env or {}
quest_name = "Harvesting"
current_task = 0
current_interaction = 0
tasks = {
	{
		{
			disconnects = {},
			callbacks = {
				GameQuestLog = {
					onRemoveTask = function(questName, taskId)
						if questName:lower() == "the city of ravencrest" and taskId == 7 then
							GameInteractions:completeInteraction(__env)
						end
					end
				}
			},
			onStartInteraction = function(self)
				GameInteractions:displayDescriptionBox({
					pages = {
						{
							text = "Woah! That Munk's elixir really worked! Such a shame we can only use it once..."
						},
						{
							text = "But since the fields are ready, let's harvest them together!"
						}
					},
					parent = GameInteractions.bandit_avatar,
					callbackOnClose = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				})
				table.insert(self.disconnects, connect(modules.game_questlog.GameQuestLog, {
					onRemoveTask = self.callbacks.GameQuestLog.onRemoveTask
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				GameProfessions = {
					onGatheringMenu = function(widget, type)
						if type == "farming" then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction, {
								widget = widget
							})
						end
					end
				}
			},
			findPotato = function()
				local tile
				local items = g_map.findItemsById(25131, 1)

				if not table.empty(items) then
					local _, item = next(items)

					tile = g_map.getTile(item:getPosition())
				end

				return tile
			end,
			onStartInteraction = function(self)
				if rootWidget:recursiveGetChildById("landInteractionPanel") then
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction, {
						widget = rootWidget:recursiveGetChildById("landInteractionPanel")
					})

					return
				end

				local potatoTile = self.findPotato()

				if potatoTile then
					GameInteractions:displayActionBox({
						preferSide = "top",
						text = "In order to do that, right-click the potato bed",
						bandit = true,
						tilePos = potatoTile:getPosition(),
						keys = {
							MouseRightButton
						}
					})
					table.insert(self.disconnects, connect(modules.game_professions.GameProfessions, {
						onGatheringMenu = self.callbacks.GameProfessions.onGatheringMenu
					}))
				else
					GameInteractions:completeInteraction(__env)
					GameNotification:display(NOTIFICATION_ERROR, nil, "Interaction was cancelled because the potato bed was not found.")
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				LocalPlayer = {
					onPositionChange = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, 1)
					end,
					onChanneling = function(player, channelType, channelStatus, channelPercent, channelName, channelDuration, reversed, interruptible)
						if channelName:lower() == "gathering potato plant" then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				},
				GameProfessions = {
					onGatheringMenuClose = function()
						scheduleEvent(function()
							if __env.current_interaction == 3 then
								GameInteractions:advanceInteraction(__env, __env.current_task, 1)
							end
						end, 500)
					end
				}
			},
			onStartInteraction = function(self, args)
				local widget = args.widget

				if widget and not widget:isDestroyed() then
					GameInteractions:displayActionBox({
						preferSide = "top",
						text = "Each of these actions will have a different effect on your plantation, but you were asked to harvest them, so better stick to the first option for now!",
						bandit = true,
						keys = {
							MouseLeftButton
						},
						parent = widget:getFirstChild()
					})
					table.insert(self.disconnects, connect(LocalPlayer, {
						onPositionChange = self.callbacks.LocalPlayer.onPositionChange,
						onChanneling = self.callbacks.LocalPlayer.onChanneling
					}))
					table.insert(self.disconnects, connect(modules.game_professions.GameProfessions, {
						onGatheringMenuClose = self.callbacks.GameProfessions.onGatheringMenuClose
					}))
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				LocalPlayer = {
					onChanneling = function(player, channelType, channelStatus, channelPercent, channelName, channelDuration, reversed)
						if channelStatus == ChannelingStatusFinish and channelName and channelName:lower() == "gathering potato plant" then
							GameInteractions:completeInteraction(__env)
						elseif channelStatus == ChannelingStatusAbort then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				},
				GameQuestLog = {
					onRemoveTask = function(questName, taskId)
						if questName:lower() == "the city of ravencrest" and taskId == 7 then
							GameInteractions:completeInteraction(__env)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local minigameWindow = modules.game_channeling_minigame.minigameWindow

				if minigameWindow:isVisible() then
					GameInteractions:displayActionBox({
						preferSide = "top",
						text = "If you want to speed up the process, press F whenever the moving bar gets inside the green area",
						bandit = true,
						keys = {
							"F"
						},
						parent = modules.game_channeling_minigame.key
					})
					table.insert(self.disconnects, connect(LocalPlayer, {
						onChanneling = self.callbacks.LocalPlayer.onChanneling
					}))
					table.insert(self.disconnects, connect(modules.game_questlog.GameQuestLog, {
						onRemoveTask = self.callbacks.GameQuestLog.onRemoveTask
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
