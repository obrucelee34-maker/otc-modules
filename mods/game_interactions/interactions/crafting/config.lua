-- chunkname: @/modules/game_interactions/interactions/crafting/config.lua

__env = __env or {}
quest_name = "Crafting"
current_task = 0
current_interaction = 0
itemsToInteractionType = {
	["Mystic Staff"] = "carpentry",
	["Oakwood Bow"] = "carpentry",
	["Wooden Buckler"] = "carpentry",
	["Skirmisher's Blade"] = "blacksmithing",
	["Shipbuilding Mallet"] = "blacksmithing",
	["Burnished Greatsword"] = "blacksmithing",
	["Wicked Axe"] = "blacksmithing",
	["Solid Mace"] = "blacksmithing",
	["Serrated Dagger"] = "blacksmithing",
	["Rough Greataxe"] = "blacksmithing",
	["Rough Sword"] = "blacksmithing",
	["Knotted Sceptre"] = "carpentry"
}

local function carpentryOrBlacksmithing()
	local type
	local tracker = modules.game_questlog

	if tracker.getQuestWidget("Crafting for a Reward") then
		local task = tracker.getQuestEntry("Crafting for a Reward", 2)
		local items = task.taskProgress

		for item, interactionType in pairs(itemsToInteractionType) do
			if string.find(items, item, 1, true) then
				type = interactionType

				break
			end
		end
	end

	return type
end

tasks = {
	{
		{
			disconnects = {},
			callbacks = {
				GameProfessions = {
					onOpenCraftingWindow = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end,
					onCraftEnd = function()
						GameInteractions:completeInteraction(__env)
					end
				}
			},
			onStartInteraction = function(self)
				local minigameWindow = modules.game_professions.minigameWindow

				if minigameWindow:isVisible() then
					scheduleEvent(function()
						GameInteractions:advanceInteraction(__env, __env.current_task, 5)
					end, 1000)

					return
				end

				GameInteractions:displayDescriptionBox({
					pages = {
						{
							text = "So you're crafting a weapon of your own, now? That's huge!"
						}
					},
					parent = GameInteractions.bandit_avatar,
					callbackOnClose = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				})
				table.insert(self.disconnects, connect(modules.game_professions.GameProfessions, {
					onCraftEnd = self.callbacks.GameProfessions.onCraftEnd
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				LocalPlayer = {
					onPositionChange = function(player, pos)
						local self = tasks[__env.current_task][__env.current_interaction]

						if Position.isInRange(pos, {
							y = 5061,
							x = 5290,
							z = 9
						}, 6, 6) then
							GameInteractions:closeActionBox()
							self:displayCraftingInteraction()
						else
							GameInteractions:closeDescriptionBox()
							self:displayCompassInteraction()
						end
					end
				},
				GameProfessions = {
					onOpenCraftingWindow = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end,
					onCraftEnd = function()
						GameInteractions:completeInteraction(__env)
					end
				}
			},
			displayCompassInteraction = function(self)
				local parent = modules.game_questlog.getQuestWidget("Crafting for a Reward")

				if parent and parent.compass then
					GameInteractions:displayActionBox({
						text = "We need to find the nearest Crafting Station at once! Don't forget you can always check your compass for directions",
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
			displayCraftingInteraction = function(self)
				local type = carpentryOrBlacksmithing()

				if not type then
					GameInteractions:advanceInteraction(__env, __env.current_task, 0)

					return
				end

				GameInteractions:displayDescriptionBox({
					bandit = true,
					pages = {
						{
							text = tr("%s", type == "carpentry" and "Do you see that table with nails and chisels all over? That's a Carpentry station!" or "Do you see that table with a big anvil right next to it? That's a Blacksmithing station!")
						},
						{
							text = tr("%s", type == "carpentry" and "And it's where you can craft any sort of wooden weapon, just like the one you chose!" or "And it's where you can craft any sort of metal weapon, just like the one you chose!")
						}
					},
					tilePos = type == "carpentry" and {
						y = 5061,
						x = 5289,
						z = 9
					} or {
						y = 5060,
						x = 5292,
						z = 9
					},
					callbackOnClose = function(self)
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end
				})
			end,
			onStartInteraction = function(self)
				local type = carpentryOrBlacksmithing()

				if not type then
					GameInteractions:advanceInteraction(__env, __env.current_task, 0)

					return
				end

				local craftingStationPos = type == "carpentry" and {
					y = 5061,
					x = 5289,
					z = 9
				} or {
					y = 5060,
					x = 5292,
					z = 9
				}
				local player = g_game.getLocalPlayer()

				if not player then
					return
				end

				if not Position.isInRange(player:getPosition(), craftingStationPos, 2, 2) then
					self:displayCraftingInteraction()

					return
				end

				local craftingWindow = modules.game_professions.GameProfessions.crafting_window.window

				if not craftingWindow:isVisible() then
					table.insert(self.disconnects, connect(LocalPlayer, {
						onPositionChange = self.callbacks.LocalPlayer.onPositionChange
					}))

					local player = g_game.getLocalPlayer()

					self.callbacks.LocalPlayer.onPositionChange(player, player:getPosition())
					table.insert(self.disconnects, connect(modules.game_professions.GameProfessions, {
						onOpenCraftingWindow = self.callbacks.GameProfessions.onOpenCraftingWindow,
						onCraftEnd = self.callbacks.GameProfessions.onCraftEnd
					}))
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				LocalPlayer = {
					onPositionChange = function(player, pos)
						local craftingStationPos = type == "carpentry" and {
							y = 5061,
							x = 5289,
							z = 9
						} or {
							y = 5060,
							x = 5292,
							z = 9
						}

						if not Position.isInRange(pos, craftingStationPos, 6, 6) then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				},
				GameProfessions = {
					onOpenCraftingWindow = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end,
					onCraftEnd = function()
						GameInteractions:completeInteraction(__env)
					end
				}
			},
			onStartInteraction = function(self)
				local type = carpentryOrBlacksmithing()

				if not type then
					GameInteractions:advanceInteraction(__env, __env.current_task, 0)

					return
				end

				local player = g_game.getLocalPlayer()

				if not player then
					return
				end

				local craftingWindow = modules.game_professions.GameProfessions.crafting_window.window

				if not craftingWindow:isVisible() then
					local craftingStationPos = type == "carpentry" and {
						y = 5061,
						x = 5289,
						z = 9
					} or {
						y = 5060,
						x = 5292,
						z = 9
					}
					local isInRange = Position.isInRange(player:getPosition(), craftingStationPos, 2, 2)

					GameInteractions:displayActionBox({
						bandit = true,
						text = tr("%s", isInRange and "Interact with the workstation" or "Get a little closer and interact with the workstation"),
						keys = {
							"F"
						},
						tilePos = craftingStationPos
					})
					table.insert(self.disconnects, connect(LocalPlayer, {
						onPositionChange = self.callbacks.LocalPlayer.onPositionChange
					}))
					table.insert(self.disconnects, connect(modules.game_professions.GameProfessions, {
						onOpenCraftingWindow = self.callbacks.GameProfessions.onOpenCraftingWindow,
						onCraftEnd = self.callbacks.GameProfessions.onCraftEnd
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
					onCloseCraftingWindow = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, 2)
					end,
					onCraftingWindowRecipeChange = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
					end,
					onCraftBegin = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						modules.game_professions.GameProfessions:hideCraftingWindow()
					end,
					onCraftEnd = function()
						GameInteractions:completeInteraction(__env)
					end
				}
			},
			onStartInteraction = function(self)
				local type = carpentryOrBlacksmithing()

				if not type then
					GameInteractions:advanceInteraction(__env, __env.current_task, 0)

					return
				end

				local craftingStationPos = type == "carpentry" and {
					y = 5061,
					x = 5289,
					z = 9
				} or {
					y = 5060,
					x = 5292,
					z = 9
				}
				local player = g_game.getLocalPlayer()

				if not player then
					return
				end

				if not Position.isInRange(player:getPosition(), craftingStationPos, 2, 2) then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				local craftingWindow = modules.game_professions.GameProfessions.crafting_window.window

				if not craftingWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 2)

					return
				end

				local minigameWindow = modules.game_professions.minigameWindow

				if minigameWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 5)

					return
				end

				GameInteractions:displayActionBox({
					bandit = true,
					text = "Now select the weapon you wish to craft from the list",
					keys = {
						MouseLeftButton
					},
					parent = craftingWindow
				})
				table.insert(self.disconnects, connect(modules.game_professions.GameProfessions, {
					onCloseCraftingWindow = self.callbacks.GameProfessions.onCloseCraftingWindow,
					onCraftingWindowRecipeChange = self.callbacks.GameProfessions.onCraftingWindowRecipeChange,
					onCraftBegin = self.callbacks.GameProfessions.onCraftBegin,
					onCraftEnd = self.callbacks.GameProfessions.onCraftEnd
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				GameProfessions = {
					onCraftBegin = function(data)
						GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						modules.game_professions.GameProfessions:hideCraftingWindow()
					end,
					onCloseCraftingWindow = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, 2)
					end,
					onCraftEnd = function()
						GameInteractions:completeInteraction(__env)
					end
				}
			},
			onStartInteraction = function(self)
				local minigameWindow = modules.game_professions.minigameWindow

				if minigameWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)

					return
				end

				local craftingWindow = modules.game_professions.GameProfessions.crafting_window.window

				if craftingWindow:isVisible() then
					GameInteractions:displayActionBox({
						preferSide = "top",
						text = "Since you have all the required materials, you can start crafting by simply clicking the button",
						bandit = true,
						parent = craftingWindow.button_panel.craft_button,
						keys = {
							MouseLeftButton
						}
					})
					table.insert(self.disconnects, connect(modules.game_professions.GameProfessions, {
						onCraftEnd = self.callbacks.GameProfessions.onCraftEnd,
						onCraftBegin = self.callbacks.GameProfessions.onCraftBegin,
						onCloseCraftingWindow = self.callbacks.GameProfessions.onCloseCraftingWindow
					}))
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, 2)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				GameProfessions = {
					onCraftEnd = function()
						GameInteractions:completeInteraction(__env)
					end,
					onCraftCancel = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, 2)
					end,
					onBeforeOpenCraftingWindow = function()
						return true
					end
				},
				UIWidget = {
					onDragEnter = function(widget)
						widget.draggingLock = g_clock.millis() + 100

						return false
					end
				}
			},
			onStartInteraction = function(self)
				local minigameWindow = modules.game_professions.minigameWindow

				if minigameWindow:isVisible() then
					local type = carpentryOrBlacksmithing()

					if not type then
						GameInteractions:advanceInteraction(__env, __env.current_task, 0)

						return
					end

					local _, abilitySlot = AbilityBar.getFirstOccupiedSlot(AbilityBarCategoryCrafting)

					GameInteractions:displayDescriptionBox({
						bandit = true,
						pages = {
							{
								text = "Now the fun part begins!",
								callback = function(self)
									self.newParent = abilitySlot
								end
							},
							{
								text = "You have a crafting skill called Synthesis, which increases your Progress",
								callback = function(self)
									self.newParent = abilitySlot
								end
							},
							{
								text = "When the Progress bar is filled completely, the item was successfully crafted!",
								callback = function(self)
									self.newParent = minigameWindow.progress
								end
							},
							{
								text = "But be careful! Synthesis also reduces your Labor and the item's Durability",
								callback = function(self)
									self.newParent = minigameWindow.durabilityPanel
								end
							},
							{
								text = "And if any of those goes to zero, the crafting fails and you lose the materials in the process!",
								callback = function(self)
									self.newParent = minigameWindow.laborPanel
								end
							},
							{
								text = tr("%s", type == "carpentry" and "But as your Carpentry levels up, you'll learn skills that increase labor and durability as well" or "But as your Blacksmithing levels up, you'll learn skills that increase labor and durability as well"),
								callback = function(self)
									self.newParent = minigameWindow.laborPanel
								end
							},
							{
								text = "Some skills even affect Quality, which allows you to craft items of superior grades!",
								callback = function(self)
									self.newParent = minigameWindow.quality
								end
							},
							{
								text = "Sometimes the Condition of your work changes as well, and in the future you'll be able to influence it with skills",
								callback = function(self)
									self.newParent = minigameWindow.quality
								end
							},
							{
								text = "The better the Condition, the faster your Progress and Quality bar will increase!",
								callback = function(self)
									self.newParent = minigameWindow.qualityName
								end
							},
							{
								text = "Now you know everything you need, it's time to craft! I'm anxious to see the result!",
								callback = function(self)
									self.newParent = GameInteractions.bandit_avatar
								end
							},
							{
								text = tr("%s", type == "carpentry" and "And remember! The Carpentry station is for wooden weapons only" or "And remember! The Blacksmithing station is for metal weapons only"),
								callback = function(self)
									self.newParent = GameInteractions.bandit_avatar
								end
							},
							{
								text = tr("%s", type == "carpentry" and "For the ones made of metal, like shields and swords, you need to use the Blacksmithing station" or "For the ones made of wood, like bows and staves, you need to use the Carpentry station"),
								callback = function(self)
									self.newParent = GameInteractions.bandit_avatar
								end
							}
						},
						callbackOnClose = function()
							GameInteractions:advanceInteraction(__env, __env.current_task, __env.current_interaction)
						end,
						parent = abilitySlot
					})
					table.insert(self.disconnects, connect(abilitySlot:recursiveGetChildById("icon"), {
						onDragEnter = self.callbacks.UIWidget.onDragEnter
					}, true))
					table.insert(self.disconnects, connect(modules.game_professions.GameProfessions, {
						onCraftEnd = self.callbacks.GameProfessions.onCraftEnd,
						onCraftCancel = self.callbacks.GameProfessions.onCraftCancel,
						onBeforeOpenCraftingWindow = self.callbacks.GameProfessions.onBeforeOpenCraftingWindow
					}))
				else
					GameInteractions:advanceInteraction(__env, __env.current_task, 2)
				end
			end
		},
		{
			disconnects = {},
			callbacks = {
				GameProfessions = {
					onCraftEnd = function()
						GameInteractions:completeInteraction(__env)
					end,
					onCraftCancel = function()
						GameInteractions:advanceInteraction(__env, __env.current_task, 2)
					end,
					onBeforeOpenCraftingWindow = function()
						return true
					end
				},
				UIWidget = {
					onDragEnter = function(widget)
						widget.draggingLock = g_clock.millis() + 100

						return false
					end
				}
			},
			onStartInteraction = function(self)
				local minigameWindow = modules.game_professions.minigameWindow

				if not minigameWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 0)

					return
				end

				table.insert(self.disconnects, connect(modules.game_professions.GameProfessions, {
					onCraftEnd = self.callbacks.GameProfessions.onCraftEnd,
					onCraftCancel = self.callbacks.GameProfessions.onCraftCancel,
					onBeforeOpenCraftingWindow = self.callbacks.GameProfessions.onBeforeOpenCraftingWindow
				}))

				local _, abilitySlot = AbilityBar.getFirstOccupiedSlot(AbilityBarCategoryCrafting)

				table.insert(self.disconnects, connect(abilitySlot:recursiveGetChildById("icon"), {
					onDragEnter = self.callbacks.UIWidget.onDragEnter
				}, true))
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
