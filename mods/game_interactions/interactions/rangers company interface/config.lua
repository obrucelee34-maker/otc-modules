-- chunkname: @/modules/game_interactions/interactions/rangers company interface/config.lua

__env = __env or {}
quest_name = "Rangers Company Interface"
current_task = 0
current_interaction = 0
tasks = {
	{
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange = function(widget, visible)
						GameInteractions.action_window:setVisible(visible)
					end,
					onVisibilityChange_rangersCompany = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local rangersCompanyWindow = modules.game_rangerscompany.GameRangersCompany.rangers_window

				if not rangersCompanyWindow:isVisible() then
					addEvent(function()
						modules.game_menu.Menu.icon:setOn(true)
					end)

					local parentWidget = modules.game_menu.Menu.window:recursiveGetChildById("rangers_company")

					GameInteractions:displayActionBox({
						preferSide = "top",
						text = "You can open the Rangers Company interface anywhere in the world simply by pressing B",
						keys = {
							"B",
							MouseLeftButton
						},
						parent = parentWidget
					})
					table.insert(self.disconnects, connect(parentWidget, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(rangersCompanyWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_rangersCompany
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
				local rangersCompanyWindow = modules.game_rangerscompany.GameRangersCompany.rangers_window

				if not rangersCompanyWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 0)

					return
				end

				local expertiseBar = rangersCompanyWindow:recursiveGetChildById("progress_panel")
				local categoryList = rangersCompanyWindow:recursiveGetChildById("middle_panel")

				GameInteractions:displayDescriptionBox({
					preferSide = "top",
					bandit = true,
					pages = {
						{
							text = "See this expertise bar up there?",
							callback = function(self)
								self.newParent = expertiseBar
							end
						},
						{
							text = "Every time you manage to fill it by earning Prestige Points, you will earn a new expertise point.",
							callback = function(self)
								self.newParent = expertiseBar
							end
						},
						{
							text = "Expertise points are assigned automatically upon being received, and they give you different bonuses against certain creature categories.",
							callback = function(self)
								self.newParent = categoryList
								self.preferSide = "left"
							end
						},
						{
							text = "Every time you earn a new expertise point, you can reroll it only once by clicking on a button right next to the Category name and paying a hefty amount of silver."
						},
						{
							text = "The rerolled point will also be automatically and randomly assigned to one of the available creature categories."
						},
						{
							text = "By stacking up expertise points, you might be able to become a proficient monster hunter in many aspects!"
						}
					},
					parent = expertiseBar,
					callbackOnClose = function()
						GameInteractions:completeInteraction(__env)
					end
				})
				table.insert(self.disconnects, connect(rangersCompanyWindow, {
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
