-- chunkname: @/modules/game_menu/menu.lua

Menu = {
	notifications = {}
}

function Menu.init()
	g_ui.importStyle("menu.otui")

	Menu.window = g_ui.createWidget("MenuWidget", modules.game_interface.getHUDPanel())
	Menu.icon = g_ui.createWidget("MenuIcon", modules.game_interface.getHUDPanel())
	Menu.minimizeButton = g_ui.createWidget("MenuMinimizeButton", modules.game_interface.getHUDPanel())
	Menu.tooltip = g_ui.createWidget("MenuTooltip", modules.game_interface.getHUDPanel())

	local menuIcon = g_ui.createWidget("MenuNotificationIcon", Menu.icon)

	menuIcon:setImageOffset({
		y = 16,
		x = -16
	})
	menuIcon:setVisible(false)
	connect(g_game, {
		onGameEnd = Menu.onGameEnd,
		onGameStart = Menu.onGameStart,
		onCutsceneModeChange = Menu.onCutsceneModeChange,
		onHouseModeChange = Menu.onHouseModeChange
	})

	Menu.lastWindowSize = g_window.getSize()

	Menu.onResize()
	connect(rootWidget, {
		onUIResize = Menu.onResize
	})
	connect(LocalPlayer, {
		onLevelChange = Menu.onLevelChange
	})
	g_keyboard.bindKeyDown("Escape", Menu.tryCloseWindow)
	addEvent(function()
		Menu.setup()
		Menu.setupNotifications()
		Menu.icon:setOn(true)
	end)
end

function Menu.terminate()
	Menu.window:destroy()
	Menu.icon:destroy()
	Menu.minimizeButton:destroy()
	Menu.tooltip:destroy()

	for id, notification in pairs(Menu.notifications) do
		notification.callback()

		Menu.notifications[id] = nil
	end

	for _, menu in ipairs(Menu.widgets) do
		for _, disconnects in ipairs(menu.callbacks or {}) do
			for _, disconnect in ipairs(disconnects) do
				disconnect()
			end
		end
	end

	disconnect(g_game, {
		onGameEnd = Menu.onGameEnd,
		onGameStart = Menu.onGameStart,
		onCutsceneModeChange = Menu.onCutsceneModeChange,
		onHouseModeChange = Menu.onHouseModeChange
	})
	disconnect(rootWidget, {
		onUIResize = Menu.onResize
	})
	disconnect(LocalPlayer, {
		onLevelChange = Menu.onLevelChange
	})
	g_keyboard.unbindKeyDown("Escape")
end

function Menu.setup()
	Menu.modules = {
		{
			unlockLevel = 1,
			name = "Character",
			icon = "character",
			callback = modules.game_character.GameCharacter.toggle,
			window = modules.game_character.GameCharacter.window
		},
		{
			unlockLevel = 1,
			name = "Inventory",
			icon = "inventory",
			callback = modules.game_inventory.GameInventory.toggle,
			window = modules.game_inventory.GameInventory.window
		},
		{
			separator = true,
			name = "Infusion",
			unlockLevel = 7,
			icon = "infusion",
			callback = modules.game_infusion.GameInfusion.toggle,
			window = modules.game_infusion.GameInfusion.window,
			enabledCallback = modules.game_infusion.GameInfusion.isEnabled
		},
		{
			unlockLevel = 10,
			name = "RavenCards",
			icon = "ravencards",
			callback = modules.game_cards.GameCards.toggleCollectionWindow,
			window = modules.game_cards.GameCards.collection_window,
			enabledCallback = modules.game_infusion.GameInfusion.isEnabled
		},
		{
			unlockLevel = 1,
			name = "Archetypes",
			icon = "skill_tree",
			callback = modules.game_spelltree.GameSpellTree.toggle,
			window = modules.game_spelltree.GameSpellTree.window
		},
		{
			unlockLevel = 5,
			name = "Professions",
			icon = "professions",
			callback = modules.game_professions.GameProfessions.toggle,
			window = modules.game_professions.GameProfessions.window,
			enabledCallback = modules.game_infusion.GameInfusion.isEnabled
		},
		{
			separator = true,
			name = "Reputation",
			unlockLevel = 5,
			icon = "reputation",
			callback = modules.game_reputation.GameReputation.toggle,
			window = modules.game_reputation.GameReputation.window,
			enabledCallback = modules.game_infusion.GameInfusion.isEnabled
		},
		{
			unlockLevel = 50,
			name = "Aether Rift",
			icon = "aether_rift",
			callback = modules.game_aether_rift.GameAetherRift.toggle,
			window = modules.game_aether_rift.GameAetherRift.window,
			enabledCallback = modules.game_aether_rift.GameAetherRift.isEnabled
		},
		{
			unlockLevel = 9,
			name = "Transport",
			icon = "transports",
			callback = modules.game_transport.GameTransport.toggle,
			window = modules.game_transport.GameTransport.window,
			enabledCallback = modules.game_infusion.GameInfusion.isEnabled
		},
		{
			unlockLevel = 1,
			name = "Map",
			icon = "map",
			callback = g_worldMap.toggle,
			window = g_worldMap.window
		},
		{
			unlockLevel = 1,
			name = "Quest",
			icon = "quests",
			callback = modules.game_questlog.GameQuestLog.toggle,
			window = modules.game_questlog.GameQuestLog.window,
			enabledCallback = modules.game_infusion.GameInfusion.isEnabled
		},
		{
			unlockLevel = 15,
			name = "Rangers Company",
			icon = "rangers_company",
			callback = function()
				modules.game_rangerscompany.GameRangersCompany.toggleRangersWindow()
			end,
			window = modules.game_rangerscompany.GameRangersCompany.rangers_window,
			enabledCallback = modules.game_infusion.GameInfusion.isEnabled
		},
		{
			disabled = true,
			name = "Adventurer's Board",
			unlockLevel = 15,
			icon = "adventurers_board",
			callback = function()
				modules.game_adventurers_board.GameAdventurersBoard.toggleAdventurersBoardWindow()
			end,
			window = modules.game_adventurers_board.GameAdventurersBoard.window,
			enabledCallback = modules.game_adventurers_board.GameAdventurersBoard.isEnabled
		},
		{
			unlockLevel = 6,
			name = "Tradepack",
			icon = "tradepack",
			callback = modules.game_tradepacks.GameTradepacks.toggle,
			window = modules.game_tradepacks.GameTradepacks.window,
			enabledCallback = modules.game_infusion.GameInfusion.isEnabled
		},
		{
			separator = true,
			name = "Journal",
			unlockLevel = 18,
			icon = "journal",
			callback = modules.game_journal.GameJournal.toggle,
			window = modules.game_journal.GameJournal.window,
			enabledCallback = modules.game_infusion.GameInfusion.isEnabled
		},
		{
			unlockLevel = 15,
			name = "Guild",
			icon = "guild",
			callback = modules.game_guild.GameGuild.toggle,
			window = modules.game_guild.GameGuild.window
		},
		{
			unlockLevel = 5,
			name = "Social",
			icon = "social",
			callback = modules.game_social.GameSocial.toggle,
			window = modules.game_social.GameSocial.window,
			enabledCallback = modules.game_social.GameSocial.isEnabled
		},
		{
			unlockLevel = 5,
			name = "Tutorial",
			icon = "tutorial",
			callback = modules.game_interactions.GameInteractions.toggleListWindow,
			window = modules.game_interactions.GameInteractions.list_window,
			enabledCallback = modules.game_interactions.GameInteractions.isEnabled
		},
		{
			name = "Redeem Rewards",
			icon = "redeem_rewards",
			callback = modules.game_redeem_rewards.GameRedeemRewards.toggle,
			window = modules.game_redeem_rewards.GameRedeemRewards.window
		},
		{
			unlockLevel = 5,
			name = "RavenStore",
			icon = "ravenstore",
			callback = function()
				modules.game_premium_store.GamePremiumStore:toggle()
			end,
			window = modules.game_premium_store.GamePremiumStore.window,
			enabledCallback = modules.game_premium_store.GamePremiumStore.isEnabled
		},
		{
			unlockLevel = 1,
			name = "Settings",
			icon = "settings",
			callback = modules.game_settings.GameSettings.toggle,
			window = modules.game_settings.GameSettings.window
		},
		{
			name = "Land Tracker",
			ignore = true,
			callback = modules.game_house.GameHouse.toggleLandTracker,
			window = modules.game_settings.GameHouse.land_tracker_window
		},
		{
			name = "Chat",
			ignore = true,
			callback = function()
				if modules.game_chat.GameChat.enabled and modules.game_chat.GameChat:canHide() then
					modules.game_chat.GameChat:disable()
				end
			end,
			window = modules.game_chat.GameChat.window
		},
		{
			ignore = true,
			unlockLevel = 1,
			name = "Feedback",
			callback = modules.game_feedback.toggle,
			window = modules.game_feedback.feedbackWindow
		},
		{
			ignore = true,
			unlockLevel = 1,
			name = "House",
			callback = function()
				modules.game_house.GameHouse:toggleHouseMode()
			end,
			window = modules.game_house.GameHouse.top_panel
		},
		{
			ignore = true,
			unlockLevel = 1,
			name = "CraftingWindow",
			callback = function()
				modules.game_professions.GameProfessions:hideCraftingWindow()
			end,
			window = modules.game_professions.GameProfessions.crafting_window.window
		},
		{
			ignore = true,
			unlockLevel = 1,
			name = "NPCWindow",
			callback = function()
				modules.game_npcs.GameNpc:onClose()
			end,
			window = modules.game_npcs.GameNpc.window
		},
		{
			ignore = true,
			unlockLevel = 1,
			name = "BountyWindow",
			callback = function()
				modules.game_rangerscompany.GameRangersCompany:closeBountyWindow()
			end,
			window = modules.game_rangerscompany.GameRangersCompany.bounty_window
		},
		{
			ignore = true,
			unlockLevel = 1,
			name = "CardOpeningWindow",
			callback = function()
				modules.game_cards.GameCards:hideAnimationPanel()
			end,
			window = modules.game_cards.GameCards.animation_panel
		},
		{
			ignore = true,
			unlockLevel = 1,
			name = "Report Player",
			callback = function()
				modules.game_player_report.GamePlayerReport:hide()
			end,
			window = modules.game_player_report.GamePlayerReport.window
		}
	}

	if g_game.isRavenQuest() then
		local ok, position = table.findbyfield(Menu.modules, "icon", "tutorial")

		if ok then
			table.insert(Menu.modules, position, {
				name = "Achievements (Ctrl+J)",
				icon = "achievements",
				callback = modules.game_achievements.GameAchievements.toggle,
				window = modules.game_achievements.GameAchievements.window
			})
		end
	end

	Menu.interfaces = {
		{
			windows = {
				Menu.window,
				Menu.icon or {}
			}
		},
		{
			windows = {
				modules.game_minimap.minimapWindow or {}
			}
		},
		{
			windows = {
				modules.game_chat.GameChat.window or {}
			}
		},
		{
			windows = {
				modules.game_questlog.taskListHud or {}
			}
		},
		{
			windows = {
				modules.game_battle.BattleList.window or {}
			}
		},
		{
			windows = {
				modules.game_healthinfo.healthBar or {},
				modules.game_healthinfo.manaBar or {},
				modules.game_healthinfo.experienceBar or {},
				modules.game_healthinfo.partyHud or {},
				modules.game_healthinfo.resourceBars[1] or {},
				modules.game_healthinfo.mountHud or {}
			}
		},
		{
			windows = {
				modules.game_lootnotification.GameLootNotification.window or {},
				modules.game_questlog.DynamicEvent.window or {},
				function()
					return modules.game_notification.GameNotification.window
				end,
				modules.game_notification.GameNotification.screenMessage or {},
				modules.game_interactions.GameInteractions.bandit_avatar or {},
				modules.game_interactions.GameInteractions.action_window or {},
				modules.game_interactions.GameInteractions.description_window or {},
				modules.game_interactions.GameInteractions.list_window or {},
				modules.game_prompts.GamePrompts.action_prompt or {},
				modules.game_prompts.GamePrompts.description_prompt or {}
			}
		},
		{
			windows = unpack(AbilityBar.barWidgets)
		},
		{
			callback = modules.game_abilitybar.AbilityBar.updateInterfaceHideElements
		},
		{
			windows = {
				modules.game_redeem_rewards.GameRedeemRewards.window or {}
			}
		}
	}

	local width = Menu.window.iconList:getMarginLeft() + Menu.window.iconList:getMarginRight()

	for _, d in ipairs(Menu.modules) do
		if not d.ignore then
			local widget = g_ui.createWidget("MenuWidgetIcon", Menu.window.iconList)

			widget:setId(d.icon)

			widget.iconDescription = d.name
			widget.hotkeyId = d.window and d.window.hotkeyId

			widget:setImageSource(string.format("/images/ui/windows/menu/icons/%s", d.icon))

			widget.onHoverChange = Menu.onIconHoverChange
			widget.hoverSound = true
			widget.clickSound = not d.window.isGeneralUIWindow

			function widget.onClick()
				if widget.lock:isVisible() then
					return
				end

				d.callback(true)
			end

			width = width + widget:getWidth() + Menu.window.iconList:getLayout():getSpacing()

			if d.separator then
				local separator = g_ui.createWidget("MenuSeparatorBar", Menu.window.iconList)

				width = width + separator:getWidth() + Menu.window.iconList:getLayout():getSpacing()
			end
		end
	end

	Menu.window:setWidth(width)

	local player = g_game.getLocalPlayer()

	if player then
		Menu.onLevelChange(player, player:getLevel())
	end
end

function Menu.setupNotifications()
	Menu.widgets = {
		{
			notifications = {
				["character stats"] = {
					name = "character stats",
					rootIndex = 1,
					unlockLevel = 1,
					remove = modules.game_character.GameCharacter.window.content.stats_panel,
					icons = {
						{
							widget = "character",
							offset = {
								y = -2,
								x = 4
							}
						},
						{
							widget = modules.game_character.GameCharacter.window.panel_top.selection_panel.stats,
							offset = {
								y = 8,
								x = -25
							}
						}
					}
				}
			},
			callbacks = {
				connect(modules.game_character.GameCharacter, {
					onUpdateAttributePoints = function(oldPoints, points)
						if oldPoints and oldPoints >= 0 and oldPoints < points then
							Menu:addNotification(Menu.widgets[1].notifications["character stats"])
						end
					end
				})
			}
		},
		{
			notifications = {
				["ravencard packs"] = {
					name = "ravencard packs",
					rootIndex = 2,
					unlockLevel = 10,
					remove = modules.game_character.GameCards.animation_panel.packs_panel,
					icons = {
						{
							widget = "ravencards",
							offset = {
								y = -2,
								x = 4
							}
						},
						{
							widget = modules.game_character.GameCards.header_panel.packs.holder.count_box,
							offset = {
								y = -12,
								x = 12
							}
						}
					}
				}
			},
			callbacks = {
				connect(modules.game_cards.GameCards, {
					onUpdateTotalPacks = function(oldPacks, packs)
						if oldPacks and oldPacks >= 0 and oldPacks < packs then
							Menu:addNotification(Menu.widgets[2].notifications["ravencard packs"])
						end
					end
				})
			}
		},
		{
			notifications = {
				archetypes = {
					name = "archetypes",
					rootIndex = 3,
					unlockLevel = 1,
					remove = modules.game_spelltree.GameSpellTree.archetypesPanel,
					icons = {
						{
							widget = "skill_tree",
							offset = {
								y = -2,
								x = 4
							}
						}
					}
				}
			},
			callbacks = {
				connect(modules.game_spelltree.GameSpellTree, {
					onUpdateSkillPoints = function(oldPoints, points)
						if oldPoints and oldPoints >= 0 and oldPoints < points then
							Menu:addNotification(Menu.widgets[3].notifications.archetypes)
						end
					end,
					onUnlockArchetype = function()
						Menu:addNotification(Menu.widgets[3].notifications.archetypes)
					end
				})
			}
		},
		{
			notifications = {
				addEvent(function()
					modules.game_professions.GameProfessions:updateMenuWidgetsTable(Menu.widgets)
				end)
			},
			callbacks = {
				connect(modules.game_professions.GameProfessions, {
					onUpdatePassivePoints = function(professionId, oldPoints, points)
						if oldPoints and oldPoints >= 0 and oldPoints < points then
							Menu:addNotification(Menu.widgets[4].notifications[string.format("professions_%d", professionId)])
						end
					end
				})
			}
		},
		{
			notifications = {
				["friends request"] = {
					name = "friends request",
					rootIndex = 5,
					unlockLevel = 1,
					remove = modules.game_social.GameSocial.window.content.friends_panel.content.request_panel,
					icons = {
						{
							widget = "social",
							offset = {
								y = -2,
								x = 4
							}
						},
						{
							widget = modules.game_social.GameSocial.window.selection_panel.friends,
							offset = {
								y = 4,
								x = -12
							}
						}
					}
				},
				["party request"] = {
					name = "party request",
					rootIndex = 5,
					unlockLevel = 1,
					remove = modules.game_social.GameSocial.window.content.party_panel.content.request_panel.list,
					icons = {
						{
							widget = "social",
							offset = {
								y = -2,
								x = 4
							}
						},
						{
							widget = modules.game_social.GameSocial.window.selection_panel.party,
							offset = {
								y = 4,
								x = -10
							}
						}
					}
				},
				["mail receive"] = {
					name = "mail receive",
					rootIndex = 5,
					unlockLevel = 1,
					remove = modules.game_social.GameSocial.window.content.mail_panel.content.messages_panel,
					icons = {
						{
							widget = "social",
							offset = {
								y = -2,
								x = 4
							}
						},
						{
							widget = modules.game_social.GameSocial.window.selection_panel.mail,
							offset = {
								y = 4,
								x = -12
							}
						},
						{
							widget = modules.game_minimap.minimapWindow.mailButton,
							offset = {
								y = 2,
								x = 2
							},
							size = {
								width = 7,
								height = 7
							}
						}
					}
				}
			},
			callbacks = {
				connect(modules.game_social.GameSocial, {
					onUpdateFriendsPanel = function(oldCount, count)
						if oldCount and oldCount >= 0 and oldCount < count then
							Menu:addNotification(Menu.widgets[5].notifications["friends request"])
						end
					end,
					onUpdatePartyPanel = function(oldCount, count)
						if oldCount and oldCount >= 0 and oldCount < count then
							Menu:addNotification(Menu.widgets[5].notifications["party request"])
						end
					end,
					onUpdateMailPanel = function(oldCount, count)
						if oldCount and oldCount >= 0 and oldCount < count then
							Menu:addNotification(Menu.widgets[5].notifications["mail receive"])
						end
					end
				})
			}
		},
		{
			notifications = {
				transport = {
					name = "transport",
					rootIndex = 6,
					unlockLevel = 1,
					remove = modules.game_transport.GameTransport.window,
					icons = {
						{
							widget = "transports",
							offset = {
								y = -2,
								x = 4
							}
						}
					}
				}
			},
			callbacks = {
				connect(modules.game_transport.GameTransport, {
					onUpdateTransport = function()
						Menu:addNotification(Menu.widgets[6].notifications.transport)
					end
				})
			}
		},
		{
			notifications = {
				reputation = {
					name = "reputation",
					rootIndex = 7,
					unlockLevel = 5,
					remove = modules.game_reputation.GameReputation.window,
					icons = {
						{
							widget = "reputation",
							offset = {
								y = -2,
								x = 4
							}
						}
					}
				}
			},
			callbacks = {
				connect(modules.game_reputation.GameReputation, {
					onUpdateReputationPoints = function(oldPoints, points)
						if oldPoints and oldPoints >= 0 and oldPoints < points then
							Menu:addNotification(Menu.widgets[7].notifications.reputation)
						end
					end
				})
			}
		},
		{
			notifications = {
				redeem_rewards = {
					rootIndex = 8,
					name = "redeem_rewards",
					remove = modules.game_redeem_rewards.GameRedeemRewards.window,
					icons = {
						{
							widget = "redeem_rewards",
							offset = {
								y = -2,
								x = 4
							}
						}
					}
				}
			},
			callbacks = {
				connect(modules.game_redeem_rewards.GameRedeemRewards, {
					onUpdateRedeemRewards = function(hasRewards)
						if hasRewards then
							Menu:addNotification(Menu.widgets[8].notifications.redeem_rewards)
						end
					end
				})
			}
		}
	}
end

function Menu.onIconHoverChange(widget, hovered)
	if hovered then
		local text = widget.iconDescription

		if widget.lock:isVisible() then
			if widget.disabled or not widget.unlockLevel then
				text = string.format("This menu option is currently disabled.")
			else
				text = string.format("This menu option will be unlocked at legacy level %d.", widget.unlockLevel)
			end
		elseif widget.hotkeyId then
			local hotkey = GameHotkeyManager:getHotkeyMainKeyCombo(widget.hotkeyId)

			if hotkey and hotkey ~= "" then
				text = string.format("%s (%s)", tr(text), hotkey)
			end
		end

		Menu.tooltip:setText(text)
		Menu.tooltip:raise()
		Menu.tooltip:show()
		Menu.tooltip:setAnchoredPosition(widget, AnchorTop, 30)
	else
		Menu.tooltip:hide()
	end
end

function Menu.onGameStart()
	if not g_game.isInCutsceneMode() then
		Menu.onCutsceneModeChange(false)
	end

	Menu.icon:setOn(false)
	Menu.closeAllWindows()

	local player = g_game.getLocalPlayer()

	if player then
		Menu.onLevelChange(player, player:getLevel())
	end

	local char = g_game.getCharacterName()
	local notifications = g_settings.getNode("game_menu")

	if notifications and notifications[char] then
		for index, t in pairs(notifications[char]) do
			local value = Menu.widgets[tonumber(index)]

			if value and value.notifications then
				for _, name in pairs(t) do
					Menu:addNotification(value.notifications[name])
				end
			end
		end
	end
end

function Menu.onGameEnd()
	Menu.closeAllWindows()

	if not modules.game_settings.getOption("hideInterface") then
		Menu.toggleInterface(false)
	end

	local char = g_game.getCharacterName()
	local notifications = g_settings.getNode("game_menu") or {}

	notifications[char] = {}

	for _, notification in pairs(Menu.notifications) do
		local t = notifications[char][notification.rootIndex] or {}

		table.insert(t, notification.name)

		notifications[char][notification.rootIndex] = t
	end

	g_settings.setNode("game_menu", notifications)
	g_settings.save()

	for id, notification in pairs(Menu.notifications) do
		notification.callback()

		Menu.notifications[id] = nil
	end

	addEvent(function()
		modules.game_professions.GameProfessions:updateMenuWidgetsTable(Menu.widgets)
	end)
end

function Menu.onResize(force)
	if not Menu.modules then
		return
	end

	local size = g_window.getSize()

	if not force and Menu.lastWindowSize.width == size.width and Menu.lastWindowSize.height == size.height then
		return
	end

	Menu.lastWindowSize = size

	local widthScale = size.width / 1920
	local heightScale = size.height / 1080

	if g_window.isMaximized() and (widthScale == 1 or heightScale == 1) then
		g_app.scale(1 * (Menu.scaleMultiplier or 1))

		return
	end

	local scale = math.min(1.35, math.min(widthScale, heightScale))

	scale = math.max(0.65, math.ceil(scale * 20) / 20)

	local platform = g_app.getOs()

	if platform ~= "mac" and platform ~= "linux" then
		g_app.scale(scale * (Menu.scaleMultiplier or 1))
	end
end

function Menu.tryCloseWindow()
	local panel = modules.game_interface.getHUDPanel()

	if not panel or not panel:isVisible() then
		return
	end

	table.sort(Menu.modules, function(a, b)
		return panel:getChildIndex(a.window) > panel:getChildIndex(b.window)
	end)

	for _, data in ipairs(Menu.modules) do
		if data.window and data.window:isVisible() then
			data.callback()

			return
		end
	end
end

function Menu.closeAllWindows(excludeList)
	for _, data in pairs(Menu.modules) do
		if data.window and data.window:isVisible() and (not excludeList or not table.contains(excludeList, data.name)) then
			data.callback()
		end
	end
end

function Menu.onInterfaceVisibilityChange(widget, visible)
	if Menu.isHiddingInterface and widget:isVisible() then
		widget:setVisible(false)
	end
end

function Menu.hideWindows(windows, ignoreShow)
	local lastWidget

	for _, widget in ipairs(windows) do
		local warn = true

		if type(widget) == "function" then
			widget = widget()
			warn = false
		end

		if widget and widget.show and widget.hide then
			lastWidget = widget

			if not Menu.isHiddingInterface then
				disconnect(widget, {
					onVisibilityChange = Menu.onInterfaceVisibilityChange
				})

				if widget.hideInterfaceOptionEnabled then
					widget:show()
				end

				widget.hideInterfaceOptionEnabled = nil
			elseif not widget.hideInterfaceOptionEnabled then
				widget.hideInterfaceOptionEnabled = widget:isVisible()

				widget:hide()
				connect(widget, {
					onVisibilityChange = Menu.onInterfaceVisibilityChange
				})
			end
		elseif warn then
			print(string.format("Menu.hideWindows: invalid widget after %s", lastWidget and lastWidget:getId() or "unknown"))
		end
	end
end

function Menu.updateInterfacesHideOption()
	for _, config in ipairs(Menu.interfaces) do
		if config.windows then
			Menu.hideWindows(config.windows)
		end

		if config.callback then
			config.callback()
		end
	end
end

function Menu.toggleInterface(value)
	Menu.isHiddingInterface = value

	addEvent(Menu.updateInterfacesHideOption)
end

function Menu.onWindowVisibilityChange(widget, visible)
	if widget.isHidding and visible then
		widget:setVisible(false)
	end
end

function Menu.toggleWindows(value, showAll, excludeList)
	for _, data in pairs(Menu.modules) do
		if not excludeList or not table.find(excludeList, data.name) then
			if not value then
				disconnect(data.window, {
					onVisibilityChange = Menu.onWindowVisibilityChange
				})

				if data.window.isHidding then
					if showAll and data.window.wasVisible then
						addEvent(function()
							data.window:show()
						end)
					end

					data.window.isHidding = nil
				end

				data.window.wasVisible = nil
			elseif not data.window.isHidding then
				data.window.wasVisible = data.window:isExplicitlyVisible()

				data.window:hide()
				connect(data.window, {
					onVisibilityChange = Menu.onWindowVisibilityChange
				})

				data.window.isHidding = true
			end
		end
	end
end

function Menu.onCutsceneModeChange(value)
	modules.game_interface.getHUDPanel():setVisible(not value)
end

function Menu.onHouseModeChange(value)
	if not modules.game_settings.getOption("hideInterface") then
		Menu.toggleInterface(value)
	end

	Menu.toggleWindows(value, true, {
		"House"
	})

	if not value then
		addEvent(function()
			Menu.icon:setOn(false)
		end)
	elseif Menu.minimizeButton:isVisible() then
		Menu.minimizeButton:hide()
	end
end

function Menu.onLevelChange(localPlayer, level)
	Menu.updateModulesVisibility(level)
end

function Menu.updateModulesVisibility(level)
	for _, data in pairs(Menu.modules) do
		local disabled = data.disabled or data.enabledCallback and not data.enabledCallback()

		if disabled or data.unlockLevel and level < data.unlockLevel then
			local widget = Menu.window:recursiveGetChildById(data.icon)

			if widget then
				widget.disabled = disabled
				widget.unlockLevel = data.unlockLevel

				widget.lock:show()
			end

			if data.window and not data.window.__menuDisconnects then
				local disconnects = connect(data.window, {
					onVisibilityChange = function(widget, visible)
						if visible then
							widget:hide()
						end
					end
				})

				data.window.__menuDisconnects = disconnects
			end
		else
			local widget = Menu.window:recursiveGetChildById(data.icon)

			if widget then
				widget.disabled = nil

				widget.lock:hide()
			end

			if data.window and data.window.__menuDisconnects then
				for _, disconnect in ipairs(data.window.__menuDisconnects) do
					disconnect()
				end

				data.window.__menuDisconnects = nil
			end
		end
	end
end

function Menu:addNotification(widgets)
	local removeWidget = widgets and widgets.remove

	if not removeWidget or removeWidget:isVisible() or Menu.notifications[removeWidget:getId()] then
		return
	end

	local player = widgets.unlockLevel and g_game.getLocalPlayer()

	if player and widgets.unlockLevel > player:getLevel() then
		return
	end

	local icons = {}

	for _, widget in ipairs(widgets.icons) do
		local currentWidget = widget.widget

		if type(currentWidget) == "string" then
			currentWidget = Menu.window.iconList:getChildById(currentWidget)
		end

		local icon = g_ui.createWidget("MenuNotificationIcon", currentWidget)

		if widget.offset then
			icon:setImageOffset(widget.offset)
		end

		if widget.size then
			icon:setImageSize(widget.size)
		end

		table.insert(icons, icon)
	end

	local function onRemoveVisibilityChange(widget, visible)
		if visible then
			for _, icon in ipairs(icons) do
				icon:destroy()
			end

			Menu.notifications[widget:getId()] = nil

			disconnect(widget, {
				onVisibilityChange = onRemoveVisibilityChange
			})

			if table.empty(Menu.notifications) then
				Menu.icon.notificationIcon:setVisible(false)
			end
		end
	end

	Menu.notifications[removeWidget:getId()] = {
		name = widgets.name,
		rootIndex = widgets.rootIndex,
		callback = function()
			onRemoveVisibilityChange(removeWidget, true)
		end
	}

	connect(removeWidget, {
		onVisibilityChange = onRemoveVisibilityChange
	}, true)
	Menu.icon.notificationIcon:setVisible(true)
end

function Menu:enableMenuItem(name)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	for _, data in pairs(Menu.modules) do
		if data.name == name then
			if data.disabled then
				data.disabled = false

				Menu.updateModulesVisibility(player:getLevel())
			end

			break
		end
	end
end
