-- chunkname: @/modules/game_interactions/interactions/third archetype/config.lua

__env = __env or {}
quest_name = "Third Archetype"
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
							text = tr("Keep growing like this, %s, and soon I won't even recognize you anymore!", g_game.getCharacterName())
						},
						{
							text = "Our life in Lyderia doesn't feel so long ago, but already you're like a whole new person..."
						},
						{
							text = "With even more abilities at your fingertips, nothing will stand in your way!"
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
					onVisibilityChange_skilltree = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local skillTreeWindow = modules.game_spelltree.GameSpellTree.window

				if not skillTreeWindow:isVisible() then
					addEvent(function()
						modules.game_menu.Menu.icon:setOn(true)
					end)

					local parentWidget = modules.game_menu.Menu.window:recursiveGetChildById("skill_tree")

					GameInteractions:displayActionBox({
						preferSide = "top",
						text = "Press K or Left-Click to open your Skill Tree menu",
						bandit = true,
						keys = {
							"K",
							MouseLeftButton
						},
						parent = parentWidget
					})
					table.insert(self.disconnects, connect(parentWidget, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(skillTreeWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_skilltree
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
					onVisibilityChange_skilltree = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				},
				GameSpellTree = {
					onReplaceArchetypePopup = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				}
			},
			onStartInteraction = function(self)
				local skillTreeWindow = modules.game_spelltree.GameSpellTree.window

				if not skillTreeWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				local player = g_game.getLocalPlayer()

				if #player:getActiveArchetypes() > 2 then
					GameInteractions:advanceInteraction(__env, __env.current_task, 5)

					return
				end

				local popupBox = modules.game_spelltree.GameSpellTree.replaceArchetypePopup

				if popupBox and popupBox:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)

					return
				end

				GameInteractions:displayActionBox({
					preferSide = "top",
					text = "Click here to select your third and final archetype!",
					bandit = true,
					parent = skillTreeWindow:recursiveGetChildById("tree3"):recursiveGetChildById("option"),
					keys = {
						MouseLeftButton
					}
				})
				table.insert(self.disconnects, connect(skillTreeWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_skilltree
				}))
				table.insert(self.disconnects, connect(modules.game_spelltree.GameSpellTree, {
					onReplaceArchetypePopup = self.callbacks.GameSpellTree.onReplaceArchetypePopup
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_skilltree = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				},
				GameSpellTree = {
					onReplaceArchetypePopupDestroy = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, 2)
					end,
					onLearnArchetypeButtonClicked = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				}
			},
			onStartInteraction = function(self)
				local skillTreeWindow = modules.game_spelltree.GameSpellTree.window

				if not skillTreeWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				local popupBox = modules.game_spelltree.GameSpellTree.replaceArchetypePopup

				if not popupBox or not popupBox:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				GameInteractions:displayActionBox({
					preferSide = "left",
					text = "Now select the archetype you'd like to learn and confirm it!",
					bandit = true,
					parent = popupBox,
					keys = {
						MouseLeftButton
					}
				})
				table.insert(self.disconnects, connect(modules.game_spelltree.GameSpellTree.window, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_skilltree
				}))
				table.insert(self.disconnects, connect(modules.game_spelltree.GameSpellTree, {
					onReplaceArchetypePopupDestroy = self.callbacks.GameSpellTree.onReplaceArchetypePopupDestroy,
					onLearnArchetypeButtonClicked = self.callbacks.GameSpellTree.onLearnArchetypeButtonClicked
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_archetypePreview = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				},
				GameArchetypeInfo = {
					onConfirmLearnArchetypeButtonClicked = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				}
			},
			onStartInteraction = function(self)
				local archetypeInfoWindow = modules.game_spelltree.GameArchetypeInfo.window

				if not archetypeInfoWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				GameInteractions:displayActionBox({
					preferSide = "left",
					text = "Remember you can always preview the archetype's skills by selecting the one you want to see.",
					bandit = true,
					parent = archetypeInfoWindow,
					keys = {
						MouseLeftButton
					}
				})
				table.insert(self.disconnects, connect(modules.game_spelltree.GameArchetypeInfo.window, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_archetypePreview
				}))
				table.insert(self.disconnects, connect(modules.game_spelltree.GameArchetypeInfo, {
					onConfirmLearnArchetypeButtonClicked = self.callbacks.GameArchetypeInfo.onConfirmLearnArchetypeButtonClicked
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_skilltree = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local skillTreeWindow = modules.game_spelltree.GameSpellTree.window

				if not skillTreeWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				GameInteractions:displayDescriptionBox({
					preferSide = "left",
					bandit = true,
					pages = {
						{
							text = tr("Knowing three archetypes, %s, you finally have a class!", g_game.getCharacterName()),
							callback = function(self)
								self.newParent = skillTreeWindow:recursiveGetChildById("classNamePanel")
								self.preferSide = "left"
							end
						},
						{
							text = "Classes are titles to specific archetype combinations, which adds to your character's unique personality",
							callback = function(self)
								self.newParent = skillTreeWindow:recursiveGetChildById("classNamePanel")
								self.preferSide = "left"
							end
						},
						{
							text = "And keep in mind you can simply click here to reset one or more skill tree or change archetypes",
							callback = function(self)
								self.newParent = skillTreeWindow:recursiveGetChildById("resetArchetypes")
								self.preferSide = "top"
							end
						},
						{
							text = "And since it's free until legacy level 20, make sure to try out lots of different skills and classes until then!",
							callback = function(self)
								self.newParent = skillTreeWindow:recursiveGetChildById("resetArchetypes")
								self.preferSide = "top"
							end
						}
					},
					parent = skillTreeWindow:recursiveGetChildById("classNamePanel"),
					callbackOnClose = function()
						GameInteractions:completeInteraction(__env)
					end
				})
				table.insert(self.disconnects, connect(modules.game_spelltree.GameSpellTree.window, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_skilltree
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
