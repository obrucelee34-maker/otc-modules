-- chunkname: @/modules/game_interactions/interactions/equipping ravencards/config.lua

__env = __env or {}
quest_name = "Equipping Ravencards"
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
							text = "Now you got some RavenCards with you, it's time to learn how to properly equip them!"
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
					onArchetypeSpellsChange = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, 1)
					end
				}
			},
			onStartInteraction = function(self)
				local skillTreeWindow = modules.game_spelltree.GameSpellTree.window

				if not skillTreeWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				table.insert(self.disconnects, connect(skillTreeWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_skilltree
				}))

				local archetypes = g_game.getLocalPlayer():getActiveArchetypes()
				local hasAnySkill = false

				for _, id in pairs(archetypes) do
					if modules.game_spelltree.GameSpellTree:hasArchetypeSpellActive(id) then
						hasAnySkill = true

						break
					end
				end

				if not hasAnySkill then
					GameInteractions:displayActionBox({
						preferSide = "top",
						text = "You should learn at least one skill before equipping a card!",
						bandit = true,
						parent = skillTreeWindow:recursiveGetChildById("spell1"),
						keys = {
							MouseLeftButton
						}
					})
					table.insert(self.disconnects, connect(modules.game_spelltree.GameSpellTree, {
						onArchetypeSpellsChange = self.callbacks.GameSpellTree.onArchetypeSpellsChange
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
					onCardsToggled = function(state)
						if state then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end,
					onArchetypeSpellsChange = function()
						local archetypes = g_game.getLocalPlayer():getActiveArchetypes()
						local hasAnySkill = false

						for _, id in pairs(archetypes) do
							if modules.game_spelltree.GameSpellTree:hasArchetypeSpellActive(id) then
								hasAnySkill = true

								break
							end
						end

						if not hasAnySkill then
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

				if modules.game_spelltree.GameSpellTree.cardsToggled then
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)

					return
				end

				local archetypes = g_game.getLocalPlayer():getActiveArchetypes()
				local hasAnySkill = false

				for _, id in pairs(archetypes) do
					if modules.game_spelltree.GameSpellTree:hasArchetypeSpellActive(id) then
						hasAnySkill = true

						break
					end
				end

				if not hasAnySkill then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				GameInteractions:displayActionBox({
					preferSide = "top",
					text = "Then switch to the RavenCards menu...",
					bandit = true,
					parent = skillTreeWindow:recursiveGetChildById("cards_toggle_button"),
					keys = {
						MouseLeftButton
					}
				})
				table.insert(self.disconnects, connect(skillTreeWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_skilltree
				}))
				table.insert(self.disconnects, connect(modules.game_spelltree.GameSpellTree, {
					onCardsToggled = self.callbacks.GameSpellTree.onCardsToggled,
					onArchetypeSpellsChange = self.callbacks.GameSpellTree.onArchetypeSpellsChange
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				GameSpellTree = {
					onCardsToggled = function(state)
						if not state then
							GameInteractions:advanceInteraction(__env, __env.current_task, 2)
						end
					end,
					onOpenCardSelectionWindow = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				},
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

				if not modules.game_spelltree.GameSpellTree.cardsToggled then
					GameInteractions:advanceInteraction(__env, __env.current_task, 2)

					return
				end

				local player = g_game.getLocalPlayer()
				local archetypes = player:getActiveArchetypes()
				local parentWidget

				for _, id in pairs(archetypes) do
					if parentWidget then
						break
					end

					parentWidget = modules.game_spelltree.GameSpellTree:hasArchetypeSpellActive(id)
				end

				if not parentWidget then
					GameInteractions:advanceInteraction(__env, __env.current_task, 2)

					return
				end

				GameInteractions:displayActionBox({
					bandit = true,
					text = "And select a skill you already know",
					parent = parentWidget,
					keys = {
						MouseLeftButton
					}
				})
				table.insert(self.disconnects, connect(modules.game_spelltree.GameSpellTree, {
					onCardsToggled = self.callbacks.GameSpellTree.onCardsToggled,
					onOpenCardSelectionWindow = self.callbacks.GameSpellTree.onOpenCardSelectionWindow
				}))
				table.insert(self.disconnects, connect(skillTreeWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_skilltree
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				GameSpellTree = {
					onCardsToggled = function(state)
						if state then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end,
					onCloseCardSelectionWindow = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, 4)
					end
				}
			},
			onStartInteraction = function(self)
				local skillTreeWindow = modules.game_spelltree.GameSpellTree.window

				if not skillTreeWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				if not modules.game_spelltree.GameSpellTree.cardsToggled then
					GameInteractions:advanceInteraction(__env, __env.current_task, 2)

					return
				end

				local player = g_game.getLocalPlayer()
				local archetypes = player:getActiveArchetypes()
				local parentWidget

				for _, id in pairs(archetypes) do
					if not parentWidget then
						parentWidget = modules.game_spelltree.GameSpellTree:hasArchetypeSpellActive(id)

						break
					end
				end

				if not parentWidget then
					GameInteractions:advanceInteraction(__env, __env.current_task, 2)

					return
				end

				local cardSelectionWindow = modules.game_spelltree.GameSpellTree.cardSelectionWindow

				if not cardSelectionWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 3)

					return
				end

				GameInteractions:displayDescriptionBox({
					preferSide = "top",
					bandit = true,
					pages = {
						{
							text = "And once you own one of them, all you need to do is select the card in this window!"
						},
						{
							text = "Then, every time you cast that skill, you will also be summoning the effect of that RavenCard!"
						},
						{
							text = "There are plenty of cards to collect, and as you get stronger and unlock more skills, you will be able to change them the way you want!"
						}
					},
					parent = cardSelectionWindow,
					callbackOnClose = function()
						GameInteractions:completeInteraction(__env)
					end
				})
				table.insert(self.disconnects, connect(modules.game_spelltree.GameSpellTree, {
					onCardsToggled = self.callbacks.GameSpellTree.onCardsToggled,
					onCloseCardSelectionWindow = self.callbacks.GameSpellTree.onCloseCardSelectionWindow
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
