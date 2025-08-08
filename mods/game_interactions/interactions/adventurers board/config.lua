-- chunkname: @/modules/game_interactions/interactions/adventurers board/config.lua

__env = __env or {}
quest_name = "Adventurers Board"
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
							text = tr(string.format("You are well on your way to becoming a famous adventurer, |%s|!", g_game.getCharacterName()))
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
					onVisibilityChange_adventurersBoard = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			displayInteraction = function(self)
				local window = modules.game_adventurers_board.GameAdventurersBoard.window

				if not window:isVisible() then
					addEvent(function()
						modules.game_menu.Menu.icon:setOn(true)
					end)

					local parentWidget = modules.game_menu.Menu.window:recursiveGetChildById("adventurers_board")
					local hotkeyCombo = GameHotkeyManager:getHotkeyMainKeyCombo(HOTKEYS_IDS.ADVENTURERS_BOARD, "Not assigned")

					GameInteractions:displayActionBox({
						preferSide = "top",
						keys = {
							hotkeyCombo,
							MouseLeftButton
						},
						text = tr(string.format("Click (|%s|) to open your Adventurer's Board.", hotkeyCombo)),
						parent = parentWidget
					})
					table.insert(self.disconnects, connect(parentWidget, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(window, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_adventurersBoard
					}))
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
				end
			end,
			onStartInteraction = function(self)
				addEvent(function()
					self.displayInteraction(self)
				end)
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_adventurersBoard = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local window = modules.game_adventurers_board.GameAdventurersBoard.window

				table.insert(self.disconnects, connect(window, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_adventurersBoard
				}))

				if not window:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				GameInteractions:displayDescriptionBox({
					preferSide = "left",
					pages = {
						{
							text = "Everyone builds their renown through the actions they take. And on the Adventurer's Board you will find a variety of requests to complete for great rewards!",
							callback = function(self)
								self.parent = window
								self.preferSide = "left"
							end
						},
						{
							text = "I'm talking about things like Experience and Bonded Infusions until level 60 that don't require silver to use! However, these infusions will make your items soulbound so keep that in mind.",
							callback = function(self)
								local middleRewardPanel = window.content.bottom_panel:getChildById("2").reward_panel

								self.parent = middleRewardPanel
								self.preferSide = "left"
							end
						},
						{
							text = "And more rewards are unlocked as you progress. At level 50 and over you will receive an Aether Rift Charge, and from 60 onwards Dawn Essence!"
						},
						{
							text = "Tasks range from practicing a profession to participating in events, hunting creatures and more! If you are having trouble, be sure to hover over the tooltip information icon for guidance.",
							callback = function(self)
								local infoIcon = window.content.bottom_panel:getChildById("2").category_info

								self.parent = infoIcon
								self.preferSide = "left"
							end
						},
						{
							text = "In case none of them appeal to you, remember that you can always reroll the tasks you haven't accepted once a day if you are a Patron, but you can only complete a maximum of 3 tasks per day.",
							callback = function(self)
								local refreshButton = window.content.top_info_panel.refresh_button

								self.parent = refreshButton
								self.preferSide = "left"
							end
						},
						{
							text = "Once you've decided on a task, click accept so that you can track your progress. After the task is completed you will automatically receive your rewards!",
							callback = function(self)
								local acceptButton = window.content.bottom_panel:getChildById("2").reward_panel.button_holder.accept_button

								self.parent = acceptButton
								self.preferSide = "left"
							end
						},
						{
							text = tr(string.format("With that, there's not much else I need to tell you. Be sure to check on your tasks daily and do your part for Ravendawn, |%s|!", g_game.getCharacterName())),
							callback = function(self)
								self.preferSide = "right"
								self.parent = GameInteractions.bandit_avatar

								function self.callbackOnClose()
									GameInteractions:completeInteraction(__env)
								end
							end
						}
					},
					parent = window,
					callbackOnClose = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
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
