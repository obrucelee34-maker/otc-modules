-- chunkname: @/modules/game_interactions/interactions/selling a tradepack/config.lua

__env = __env or {}
quest_name = "Selling a tradepack"
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
							text = "So all we need to do is take this bag of supplies to a merchant? That's easy money!"
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
				g_game = {
					onOpenNpcWindow = function(npcName)
						if npcName:lower() == "munk merchant" then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local parent = modules.game_questlog.getQuestWidget("The City of Ravencrest")

				if parent and parent.compass then
					local npcWindow = modules.game_npcs.GameNpc.window

					if not npcWindow:isVisible() then
						GameInteractions:displayActionBox({
							bandit = true,
							text = "Let's find the nearest Tradepost at once! Don't forget you can always check your compass for directions",
							keys = {
								MouseLeftButton
							},
							parent = parent.compass
						})
						table.insert(self.disconnects, connect(g_game, {
							onOpenNpcWindow = self.callbacks.g_game.onOpenNpcWindow
						}))
					else
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, 0)
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
						if id ~= "npc_tradepost_sell" then
							return true
						end

						return false
					end
				},
				GameNpc = {
					onOpenTradepostSell = function()
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
							if child:getId() == "npc_tradepost_sell" then
								widget = child

								break
							end
						end
					end

					if widget then
						GameInteractions:displayActionBox({
							bandit = true,
							text = "Now tell him you have a tradepack to sell",
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
							onOpenTradepostSell = self.callbacks.GameNpc.onOpenTradepostSell
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
					local tradepackList = modules.game_npcs.Tradepost.sell_list_panel

					if tradepackList then
						GameInteractions:displayDescriptionBox({
							bandit = true,
							pages = {
								{
									text = "That's how much he's willing to pay for a Simple Tradepack! Can you imagine once we're running the Farm by ourselves? "
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
				local sell_button = tradepost.sellWindow:recursiveGetChildById("sellButton")

				if sell_button and sell_button:isVisible() then
					GameInteractions:displayActionBox({
						preferSide = "top",
						text = "Let's sell this tradepack before the merchant changes his mind!",
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
