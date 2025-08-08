-- chunkname: @/modules/game_interactions/interactions/butchering/config.lua

__env = __env or {}
quest_name = "Butchering"
current_task = 0
current_interaction = 0
tasks = {
	{
		{
			disconnects = {},
			callbacks = {
				GameQuestLog = {
					onRemoveTask = function(questName, taskId)
						if questName:lower() == "the city of ravencrest" and taskId == 8 then
							GameInteractions:completeInteraction(__env)
						end
					end
				}
			},
			onStartInteraction = function(self)
				GameInteractions:displayDescriptionBox({
					pages = {
						{
							text = "Great job!"
						},
						{
							text = "Now that you've learned how to harvest, it's time to do the same with the pigs"
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
						if type == "husbandry" then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction, {
								widget = widget
							})
						end
					end
				}
			},
			findPig = function()
				local tile
				local items = g_map.findItemsById(34400, 1)

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

				local pigPen = self.findPig()

				if pigPen then
					GameInteractions:displayActionBox({
						bandit = true,
						text = "Right-click their pen!",
						preferSide = "top",
						tilePos = pigPen:getPosition(),
						keys = {
							MouseRightButton
						}
					})
					table.insert(self.disconnects, connect(modules.game_professions.GameProfessions, {
						onGatheringMenu = self.callbacks.GameProfessions.onGatheringMenu
					}))
				else
					GameInteractions:completeInteraction(__env)
					GameNotification:display(NOTIFICATION_ERROR, nil, "Interaction was cancelled because the pig pen was not found.")
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
						if channelName:lower():find("butchering", 1, true) then
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
						text = "Your options to manage livestock are different from a vegetable bed",
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
					onChanneling = function(player, channelType, channelStatus, channelPercent, channelName, channelDuration, reversed, interruptible)
						if channelStatus == ChannelingStatusFinish and channelName and channelName:lower():find("butchering", 1, true) then
							GameInteractions:completeInteraction(__env)
						elseif channelStatus == ChannelingStatusAbort then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				},
				GameQuestLog = {
					onRemoveTask = function(questName, taskId)
						if questName:lower() == "the city of ravencrest" and taskId == 8 then
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
						text = "But in order to get meat, you'll need to butcher the pig like the farmer said",
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
