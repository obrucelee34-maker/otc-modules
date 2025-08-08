-- chunkname: @/modules/game_interactions/interactions/second archetype/config.lua

__env = __env or {}
quest_name = "Second Archetype"
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
							text = tr("Dang %s, another level? That means...", g_game.getCharacterName())
						},
						{
							text = "You can improve your skills even further by choosing another archetype!"
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

				if #player:getActiveArchetypes() > 1 then
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
					text = "Click here to choose your second archetype",
					bandit = true,
					parent = skillTreeWindow:recursiveGetChildById("tree2"):recursiveGetChildById("option"),
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

				GameInteractions:displayDescriptionBox({
					bandit = true,
					pages = {
						{
							text = "Remember you can always preview the archetype's skills by selecting the one you want to see."
						}
					},
					parent = archetypeInfoWindow,
					callbackOnClose = function()
						GameInteractions:displayActionBox({
							preferSide = "left",
							text = "And if you regret the choice you make you can change later, so don't worry!",
							bandit = true,
							parent = archetypeInfoWindow,
							keys = {
								MouseLeftButton
							}
						})
					end
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
					preferSide = "top",
					bandit = true,
					pages = {
						{
							text = "Remember, remaining skill points can be used on any skill tree. Don't forget to spend them!",
							callback = function(self)
								self.newParent = skillTreeWindow:recursiveGetChildById("pointsPanel")
							end
						},
						{
							text = "If you learn a skill you don't like, click on \"Reset Archetypes\" and select an Archetype to redistribute the points",
							callback = function(self)
								self.newParent = skillTreeWindow:recursiveGetChildById("resetArchetypes")
							end
						},
						{
							text = "It's free up to Legacy Level 20, so take your time and experiment!",
							callback = function(self)
								self.newParent = skillTreeWindow:recursiveGetChildById("resetArchetypes")
							end
						}
					},
					parent = skillTreeWindow:recursiveGetChildById("pointsPanel"),
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
