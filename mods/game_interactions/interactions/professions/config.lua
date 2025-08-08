-- chunkname: @/modules/game_interactions/interactions/professions/config.lua

__env = __env or {}
quest_name = "Professions"
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
							text = "Did you notice that you earn experience points every time you gather something?"
						},
						{
							text = "Depending on what you harvest, those points are assigned to the related Profession!"
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
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 0)
						end
					end,
					onVisibilityChange_professions = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local professionsWindow = modules.game_professions.GameProfessions.window

				if not professionsWindow:isVisible() then
					addEvent(function()
						modules.game_menu.Menu.icon:setOn(true)
					end)

					local parentWidget = modules.game_menu.Menu.window:recursiveGetChildById("professions")

					GameInteractions:displayActionBox({
						preferSide = "top",
						text = "Press P or Left-Click to open your Professions menu",
						bandit = true,
						keys = {
							"P",
							MouseLeftButton
						},
						parent = parentWidget
					})
					table.insert(self.disconnects, connect(parentWidget, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(professionsWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_professions
					}))
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				GameProfessions = {
					onSelectPanel = function(name)
						if name == "farming" then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)

							return false
						end

						return true
					end
				},
				UIWidget = {
					onVisibilityChange_professions = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local professionsWindow = modules.game_professions.GameProfessions.window

				if professionsWindow:isVisible() then
					if modules.game_professions.GameProfessions.panels.farming:isVisible() then
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)

						return
					end

					GameInteractions:displayActionBox({
						preferSide = "top",
						text = "Now access the Farming tab",
						bandit = true,
						keys = {
							MouseLeftButton
						},
						parent = modules.game_professions.GameProfessions.top_panel.farming
					})
					table.insert(self.disconnects, connect(professionsWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_professions
					}))
					table.insert(self.disconnects, connect(modules.game_professions.GameProfessions, {
						onSelectPanel = self.callbacks.GameProfessions.onSelectPanel
					}))
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				GameProfessions = {
					onSelectPanel = function()
						return true
					end
				},
				UIWidget = {
					onVisibilityChange_professions = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local professionsWindow = modules.game_professions.GameProfessions.window
				local panel = modules.game_professions.GameProfessions.panels.farming

				if professionsWindow:isVisible() then
					GameInteractions:displayDescriptionBox({
						preferSide = "top",
						bandit = true,
						pages = {
							{
								text = "Here you can see your Profession level and current experience",
								callback = function(self)
									self.newParent = panel:recursiveGetChildById("level")
									self.preferSide = "top"
								end
							},
							{
								text = "This list has everything you're able to plant. Most of them are unavailable at the moment though",
								callback = function(self)
									self.newParent = panel.left_panel:recursiveGetChildById("list")
									self.preferSide = "right"
								end
							},
							{
								text = "But as you become a more experienced farmer, more stuff will come up!",
								callback = function(self)
									self.newParent = panel.left_panel:recursiveGetChildById("list")
									self.preferSide = "right"
								end
							},
							{
								text = "Professions also have a passive skill tree which influences your progression directly",
								callback = function(self)
									self.newParent = panel.right_panel
									self.preferSide = "top"
								end
							},
							{
								text = "Every three Profession levels, you'll receive a new skill point to spend on a passive skill!",
								callback = function(self)
									self.newParent = panel.right_panel
									self.preferSide = "top"
								end
							},
							{
								text = "Take as much time as you need to learn what they can do!",
								callback = function(self)
									self.newParent = panel.right_panel
									self.preferSide = "top"
								end
							}
						},
						parent = panel:recursiveGetChildById("level"),
						callbackOnClose = function()
							GameInteractions:completeInteraction(__env)
						end
					})
					table.insert(self.disconnects, connect(modules.game_professions.GameProfessions, {
						onSelectPanel = self.callbacks.GameProfessions.onSelectPanel
					}))
					table.insert(self.disconnects, connect(professionsWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_professions
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
