-- chunkname: @/modules/game_interactions/interactions/rangers company bounty board/config.lua

__env = __env or {}
quest_name = "Rangers Company Bounty Board"
current_task = 0
current_interaction = 0
tasks = {
	{
		{
			disconnects = {},
			callbacks = {
				LocalPlayer = {
					onPositionChange = function(player, pos)
						local self = tasks[__env.current_task][__env.current_interaction]
						local bountyBoardItem = self:findBountyBoard()

						if bountyBoardItem then
							if not self.displayingBoardInteraction then
								GameInteractions:closeActionBox()
								self:displayBoardInteraction(bountyBoardItem)
							end
						elseif not self.displayingCompassInteraction then
							GameInteractions:closeActionBox()
							self:displayCompassInteraction()
						end
					end
				},
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			findBountyBoard = function()
				local tile
				local items = g_map.findItemsById(38941, 1)

				if not table.empty(items) then
					local _, item = next(items)

					tile = g_map.getTile(item:getPosition())
				end

				local player = g_game.getLocalPlayer()

				if tile and Position.distance(tile:getPosition(), player:getPosition()) > 6 then
					tile = nil
				end

				return tile
			end,
			displayBoardInteraction = function(self, tile)
				self.displayingBoardInteraction = true
				self.displayingCompassInteraction = false

				GameInteractions:displayActionBox({
					preferSide = "top",
					text = "Press F to open the bounty board",
					bandit = true,
					keys = {
						"F"
					},
					tilePos = tile:getPosition()
				})
			end,
			displayCompassInteraction = function(self)
				self.displayingCompassInteraction = true
				self.displayingBoardInteraction = false

				local parent = modules.game_questlog.getQuestWidget("Keepers of Balance")

				if parent and parent.compass then
					GameInteractions:displayActionBox({
						text = "We need to find the nearest Rangers Company Outpost at once! Don't forget you can always check your compass for directions",
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
			onStartInteraction = function(self)
				self.displayingBoardInteraction = false
				self.displayingCompassInteraction = false

				local bountyBoardWindow = modules.game_rangerscompany.GameRangersCompany.bounty_window

				if bountyBoardWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)

					return
				end

				table.insert(self.disconnects, connect(LocalPlayer, {
					onPositionChange = self.callbacks.LocalPlayer.onPositionChange
				}))
				table.insert(self.disconnects, connect(bountyBoardWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
				}))

				local player = g_game.getLocalPlayer()

				self.callbacks.LocalPlayer.onPositionChange(player, player:getPosition())
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 0)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local bountyBoardWindow = modules.game_rangerscompany.GameRangersCompany.bounty_window

				if not bountyBoardWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 0)

					return
				end

				GameInteractions:displayDescriptionBox({
					preferSide = "top",
					bandit = true,
					pages = {
						{
							text = "So this is how a bounty board looks upclose!",
							callback = function(self)
								self.newParent = bountyBoardWindow
							end
						},
						{
							text = "It will give you three options of tasks based on the region it belongs to and your current effective level range.",
							callback = function(self)
								self.newParent = bountyBoardWindow
							end
						},
						{
							text = "Tasks may come in three models: short, normal and long.",
							callback = function(self)
								self.newParent = bountyBoardWindow.content.bottom_panel[1].type
							end
						},
						{
							text = "They are completed once a specific amount of experience points has been acquired from the targeted creature family within the region",
							callback = function(self)
								self.newParent = bountyBoardWindow.content.bottom_panel[1].description
							end
						},
						{
							text = "The longer and more difficult the task, the better the rewards that you will get.",
							callback = function(self)
								self.newParent = bountyBoardWindow.content.bottom_panel[1].reward_panel
							end
						},
						{
							text = "Prestige Points are what will make you progress towards the next ranks of the Rangers Company.",
							callback = function(self)
								self.newParent = bountyBoardWindow.content.bottom_panel[1].reward_panel["prestige points"]
							end
						},
						{
							text = "Bounty Marks are what you will be using to acquire some of the rarest items available at the Munk Quartermasters.",
							callback = function(self)
								self.newParent = bountyBoardWindow.content.bottom_panel[1].reward_panel["bounty marks"]
							end
						},
						{
							text = "You can also choose to have a new random set of tasks by a certain amount of silver.",
							callback = function(self)
								self.newParent = bountyBoardWindow.content.top_panel.refresh_button
							end
						},
						{
							text = "Each reroll will be more expensive than the last though",
							callback = function(self)
								self.bandit = true
								self.newParent = bountyBoardWindow.content.top_panel.refresh_button
							end
						},
						{
							text = "Once you accept a task, there's no way to reroll it anymore. You have to either complete or cancel it.",
							callback = function(self)
								self.bandit = false
								self.newParent = GameInteractions.bandit_avatar
							end
						},
						{
							text = "And once a task is either completed or canceled, you will have to wait for a cooldown before you are able to accept a new one.",
							callback = function(self)
								self.newParent = GameInteractions.bandit_avatar
							end
						},
						{
							text = tr("Alright, let's quit the chit-chat. It's time now, %s!", g_game.getCharacterName())
						}
					},
					parent = bountyBoardWindow,
					callbackOnClose = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				})
				table.insert(self.disconnects, connect(bountyBoardWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 0)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local bountyBoardWindow = modules.game_rangerscompany.GameRangersCompany.bounty_window

				if not bountyBoardWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 0)

					return
				end

				GameInteractions:displayActionBox({
					preferSide = "top",
					text = "Select one of the available tasks and give your first step as a member of the Rangers Company!",
					bandit = true,
					keys = {
						MouseLeftButton
					},
					parent = modules.game_rangerscompany.GameRangersCompany.bounty_window.content.bottom_panel[1].reward_panel.accept_button
				})
				table.insert(self.disconnects, connect(bountyBoardWindow, {
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
