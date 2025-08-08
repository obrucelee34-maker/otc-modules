-- chunkname: @/modules/game_interactions/interactions/opening ravencards/config.lua

__env = __env or {}
quest_name = "Opening Ravencards"
current_task = 0
current_interaction = 0
tasks = {
	{
		{
			disconnects = {},
			callbacks = {},
			onStartInteraction = function(self)
				local cardsModule = modules.game_cards.GameCards

				if #cardsModule.cards > 0 then
					GameInteractions:completeInteraction(__env)
					GameNotification:display(NOTIFICATION_ERROR, nil, "Interaction was cancelled because you already opened a RavenCard pack.")

					return
				end

				GameInteractions:displayDescriptionBox({
					bandit = true,
					pages = {
						{
							text = tr("Woah, you just don't stop getting stronger, %s!", g_game.getCharacterName())
						},
						{
							text = "I found a pack of cards in the streets when we first got to Ravencrest..."
						},
						{
							text = "And I think it's time for you to have it!"
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
					onVisibilityChange_cards = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local cardsModule = modules.game_cards.GameCards

				if not cardsModule.total_packs or cardsModule.total_packs == 0 then
					GameInteractions:completeInteraction(__env)
					GameNotification:display(NOTIFICATION_ERROR, nil, "Interaction was cancelled because you don't have any RavenCards packs.")

					return
				end

				local cardsWindow = modules.game_cards.GameCards.collection_window

				if not cardsWindow:isVisible() then
					addEvent(function()
						modules.game_menu.Menu.icon:setOn(true)
					end)

					local parentWidget = modules.game_menu.Menu.window:recursiveGetChildById("ravencards")

					GameInteractions:displayActionBox({
						preferSide = "top",
						text = "Press G or Left-Click to open your RavenCards menu",
						bandit = true,
						keys = {
							"G",
							MouseLeftButton
						},
						parent = parentWidget
					})
					table.insert(self.disconnects, connect(parentWidget, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange
					}))
					table.insert(self.disconnects, connect(cardsWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_cards
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
					onVisibilityChange_cards = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end,
					onVisibilityChange_packs = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local cardsWindow = modules.game_cards.GameCards.collection_window

				if not cardsWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				GameInteractions:displayActionBox({
					preferSide = "top",
					text = "We need to open up a pack of cards before anything else, so click on the Packs tab!",
					bandit = true,
					keys = {
						MouseLeftButton
					},
					parent = cardsWindow.content.header_panel.packs
				})
				table.insert(self.disconnects, connect(cardsWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_cards
				}))
				table.insert(self.disconnects, connect(modules.game_cards.GameCards.animation_panel, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_packs
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_cards = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				},
				GameCards = {
					onAnimationPanelClose = function()
						return true
					end,
					onAnimationStart = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				}
			},
			onStartInteraction = function(self)
				local animationWindow = modules.game_cards.GameCards.animation_panel

				if not animationWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				GameInteractions:displayActionBox({
					preferSide = "top",
					text = "Since a Standard Pack is already selected, all you have to do now is open it!",
					bandit = true,
					keys = {
						MouseLeftButton
					},
					parent = modules.game_cards.GameCards.animation_panel.button_panel.open_pack
				})
				table.insert(self.disconnects, connect(animationWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_cards
				}))
				table.insert(self.disconnects, connect(modules.game_cards.GameCards, {
					onAnimationPanelClose = self.callbacks.GameCards.onAnimationPanelClose,
					onAnimationStart = self.callbacks.GameCards.onAnimationStart
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				GameCards = {
					onAnimationPanelClose = function()
						return true
					end,
					onAnimationEnd = function()
						local self = tasks[__env.current_task][__env.current_interaction]

						self:displayInteraction()
					end
				}
			},
			onStartInteraction = function(self)
				table.insert(self.disconnects, connect(modules.game_cards.GameCards, {
					onAnimationPanelClose = self.callbacks.GameCards.onAnimationPanelClose,
					onAnimationEnd = self.callbacks.GameCards.onAnimationEnd
				}))
			end,
			displayInteraction = function(self)
				local parentWidget = modules.game_cards.GameCards.animations[1]

				if not parentWidget then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				GameInteractions:displayDescriptionBox({
					preferSide = "top",
					bandit = true,
					pages = {
						{
							text = "Every pack comes with five RavenCards. And don't mistake them for simple collectable tokens!"
						},
						{
							text = "Each RavenCard affects a specific skill from a specific Archetype, changing the way it works!"
						}
					},
					parent = parentWidget.vfx.card,
					callbackOnClose = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				})
			end
		},
		{
			callbacks = {
				UIWidget = {
					onVisibilityChange_cards = function(widget, visible)
						if not visible then
							GameInteractions:advanceTask(__env)
						end
					end
				}
			},
			disconnects = {},
			onStartInteraction = function(self)
				local animationWindow = modules.game_cards.GameCards.animation_panel

				if not animationWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)

					return
				end

				GameInteractions:displayActionBox({
					preferSide = "left",
					text = "Now press ESC or left mouse button to close this window",
					bandit = true,
					keys = {
						"ESC",
						MouseLeftButton
					},
					parent = modules.game_cards.GameCards.animation_panel.close_button
				})
				table.insert(self.disconnects, connect(animationWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_cards
				}))
			end
		}
	},
	{
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_collection = function(widget, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local cardsWindow = modules.game_cards.GameCards.collection_window

				if not cardsWindow:isVisible() then
					addEvent(function()
						modules.game_menu.Menu.icon:setOn(true)
					end)

					local parentWidget = modules.game_menu.Menu.window:recursiveGetChildById("ravencards")

					GameInteractions:displayActionBox({
						preferSide = "top",
						text = "Press G or Left-Click to open your RavenCards menu",
						bandit = true,
						keys = {
							"G",
							MouseLeftButton
						},
						parent = parentWidget
					})
					table.insert(self.disconnects, connect(cardsWindow, {
						onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_collection
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
					onVisibilityChange_collection = function(widget, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 0)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local cardsWindow = modules.game_cards.GameCards.collection_window

				if not cardsWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 0)

					return
				end

				GameInteractions:displayDescriptionBox({
					preferSide = "top",
					bandit = true,
					pages = {
						{
							text = "Inside of this list you will find your whole collection of cards!",
							callback = function(self)
								self.newParent = cardsWindow.content.view_panel.list_layout
								self.preferSide = "top"
							end
						},
						{
							text = "And you can also filter them by Rarity, Archetype or choose a specific Skill once an Archetype is already selected",
							callback = function(self)
								self.newParent = cardsWindow.content.filter_panel
								self.preferSide = "right"
							end
						}
					},
					parent = cardsWindow.content.view_panel.list_layout,
					callbackOnClose = function()
						GameInteractions:completeInteraction(__env)
					end
				})
				table.insert(self.disconnects, connect(cardsWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_collection
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
