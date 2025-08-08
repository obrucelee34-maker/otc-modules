-- chunkname: @/modules/game_interactions/interactions/crafting a tradepack/config.lua

__env = __env or {}
quest_name = "Crafting a tradepack"
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
							text = "We got to learn how to craft a Tradepack before thinking about the coin..."
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
				LocalPlayer = {
					onPositionChange = function(player, pos)
						local self = tasks[__env.current_task][__env.current_interaction]

						if Position.isInRange(pos, {
							y = 5108,
							x = 5070,
							z = 6
						}, 6, 6) then
							if not self.displayingNPCInteraction then
								GameInteractions:closeActionBox()
								self:displayNPCInteraction()
							end
						elseif not self.displayingCompassInteraction then
							GameInteractions:closeActionBox()
							self:displayCompassInteraction()
						end
					end
				},
				g_game = {
					onOpenNpcWindow = function(npcName)
						if npcName:lower() == "munk merchant" then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			displayCompassInteraction = function(self)
				self.displayingCompassInteraction = true
				self.displayingNPCInteraction = false

				local parent = modules.game_questlog.getQuestWidget("The City of Ravencrest")

				if parent and parent.compass then
					GameInteractions:displayActionBox({
						text = "Let’s find the nearest Tradepost at once! Don’t forget you can always check your compass for directions",
						bandit = true,
						keys = {
							MouseLeftButton
						},
						parent = parent.compass
					})
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, 0)
				end
			end,
			displayNPCInteraction = function(self)
				self.displayingNPCInteraction = true
				self.displayingCompassInteraction = false

				GameInteractions:displayActionBox({
					preferSide = "top",
					text = "So talk with the Munk Merchant near the docks again!",
					bandit = true,
					keys = {
						"F",
						MouseRightButton
					},
					tilePos = {
						y = 5108,
						x = 5070,
						z = 6
					}
				})
			end,
			onStartInteraction = function(self)
				local npcWindow = modules.game_npcs.GameNpc.window

				if not npcWindow:isVisible() then
					table.insert(self.disconnects, connect(LocalPlayer, {
						onPositionChange = self.callbacks.LocalPlayer.onPositionChange
					}))
					table.insert(self.disconnects, connect(g_game, {
						onOpenNpcWindow = self.callbacks.g_game.onOpenNpcWindow
					}))

					local player = g_game.getLocalPlayer()

					self.callbacks.LocalPlayer.onPositionChange(player, player:getPosition())
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				g_game = {
					onCloseNpcWindow = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, 1)
					end,
					onNpcAnswer = function(id, text)
						if id ~= "npc_tradepost_craft" then
							return true
						end

						return false
					end
				},
				GameNpc = {
					onOpenTradepostCraft = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				}
			},
			onStartInteraction = function(self)
				local npcWindow = modules.game_npcs.GameNpc.window

				if npcWindow:isVisible() then
					local answersPanel = npcWindow.contentPanel:recursiveGetChildById("dialogueAnswerPanel")
					local widget

					if answersPanel then
						for _, child in ipairs(answersPanel:getChildren()) do
							if child:getId() == "npc_tradepost_craft" then
								widget = child

								break
							end
						end
					end

					if widget then
						GameInteractions:displayActionBox({
							bandit = true,
							text = "A Tradepost works both for crafting and selling a tradepack. But keep in mind a tradepack can't be sold in the same place that it was crafted",
							keys = {
								MouseLeftButton
							},
							parent = widget
						})
						table.insert(self.disconnects, connect(g_game, {
							onCloseNpcWindow = self.callbacks.g_game.onCloseNpcWindow,
							onNpcAnswer = self.callbacks.g_game.onNpcAnswer
						}))
						table.insert(self.disconnects, connect(modules.game_npcs.GameNpc, {
							onOpenTradepostCraft = self.callbacks.GameNpc.onOpenTradepostCraft
						}))
					else
						GameInteractions:advanceInteraction(__env, __env.current_task, 1)
					end
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				g_game = {
					onCloseNpcWindow = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, 1)
					end
				}
			},
			onStartInteraction = function(self)
				local npcWindow = modules.game_npcs.GameNpc.window

				if npcWindow:isVisible() then
					local tradepackList = modules.game_npcs.Tradepost.list_panel

					if tradepackList then
						GameInteractions:displayDescriptionBox({
							bandit = true,
							pages = {
								{
									text = "See there's a single item available? That's the only one you currently have the materials to craft."
								}
							},
							parent = tradepackList:getFirstChild(),
							callbackOnClose = function()
								GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
							end
						})
						table.insert(self.disconnects, connect(g_game, {
							onCloseNpcWindow = self.callbacks.g_game.onCloseNpcWindow
						}))
					else
						GameInteractions:advanceInteraction(__env, __env.current_task, 2)
					end
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, 2)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				g_game = {
					onCloseNpcWindow = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, 1)
					end
				}
			},
			onStartInteraction = function(self)
				local tradepost = modules.game_npcs.Tradepost
				local sell_button = tradepost.craftWindow:recursiveGetChildById("craftButton")

				if sell_button and sell_button:isVisible() then
					GameInteractions:displayActionBox({
						preferSide = "top",
						text = "Now let's craft a Farmer's Basics so we dont leave Father Richard waiting!",
						bandit = true,
						keys = {
							MouseLeftButton
						},
						parent = sell_button
					})
					table.insert(self.disconnects, connect(g_game, {
						onCloseNpcWindow = self.callbacks.g_game.onCloseNpcWindow
					}))
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, 3)
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
