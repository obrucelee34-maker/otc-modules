-- chunkname: @/modules/game_hotkey_manager/hotkey_manager.lua

GameHotkeyManager = GameHotkeyManager or {
	keyComboInterval = 100,
	maxKeyCombos = 2,
	customHotkeys = false,
	hotkeyDataByHotkeyId = {},
	keyComboData = {},
	lastKeyComboTime = {},
	reservedHotkeys = {
		"F",
		"Ctrl+Q",
		"Escape",
		"Enter",
		"Backspace",
		"Delete"
	}
}

function GameHotkeyManager.init()
	addEvent(function()
		GameHotkeyManager:setupData()
		GameHotkeyManager:setupHotkeys()
		modules.game_settings.GameSettings:populateHotkeys()
	end)
end

function GameHotkeyManager.terminate()
	GameHotkeyManager:unbindHotkeys()

	GameHotkeyManager = nil
end

function GameHotkeyManager:setupData()
	self.categories = {
		{
			keyComboInterval = 0,
			name = "Movement",
			ignoreHouseMode = true,
			notIgnoreAutoRepeat = true,
			hotkeys = {
				{
					name = "Walk North",
					id = HOTKEYS_IDS.WALK_NORTH,
					defaultKeys = {
						[1] = "W",
						[2] = "Up"
					},
					callback = GameHotkeyManager.walkHotkeyPressed
				},
				{
					name = "Walk East",
					id = HOTKEYS_IDS.WALK_EAST,
					defaultKeys = {
						[1] = "D",
						[2] = "Right"
					},
					callback = GameHotkeyManager.walkHotkeyPressed
				},
				{
					name = "Walk South",
					id = HOTKEYS_IDS.WALK_SOUTH,
					defaultKeys = {
						[1] = "S",
						[2] = "Down"
					},
					callback = GameHotkeyManager.walkHotkeyPressed
				},
				{
					name = "Walk West",
					id = HOTKEYS_IDS.WALK_WEST,
					defaultKeys = {
						[1] = "A",
						[2] = "Left"
					},
					callback = GameHotkeyManager.walkHotkeyPressed
				},
				{
					name = "North-East",
					id = HOTKEYS_IDS.WALK_NORTH_EAST,
					callback = GameHotkeyManager.walkHotkeyPressed
				},
				{
					name = "South-East",
					id = HOTKEYS_IDS.WALK_SOUTH_EAST,
					callback = GameHotkeyManager.walkHotkeyPressed
				},
				{
					name = "South-West",
					id = HOTKEYS_IDS.WALK_SOUTH_WEST,
					callback = GameHotkeyManager.walkHotkeyPressed
				},
				{
					name = "North-West",
					id = HOTKEYS_IDS.WALK_NORTH_WEST,
					callback = GameHotkeyManager.walkHotkeyPressed
				},
				{
					name = "Turn North",
					id = HOTKEYS_IDS.TURN_NORTH,
					defaultKeys = {
						[1] = "Ctrl+W",
						[2] = "Ctrl+Up"
					},
					callback = GameHotkeyManager.turnHotkeyPressed
				},
				{
					name = "Turn East",
					id = HOTKEYS_IDS.TURN_EAST,
					defaultKeys = {
						[1] = "Ctrl+D",
						[2] = "Ctrl+Right"
					},
					callback = GameHotkeyManager.turnHotkeyPressed
				},
				{
					name = "Turn South",
					id = HOTKEYS_IDS.TURN_SOUTH,
					defaultKeys = {
						[1] = "Ctrl+S",
						[2] = "Ctrl+Down"
					},
					callback = GameHotkeyManager.turnHotkeyPressed
				},
				{
					name = "Turn West",
					id = HOTKEYS_IDS.TURN_WEST,
					defaultKeys = {
						[1] = "Ctrl+A",
						[2] = "Ctrl+Left"
					},
					callback = GameHotkeyManager.turnHotkeyPressed
				}
			}
		},
		{
			name = "Action Bar",
			notIgnoreAutoRepeat = true,
			callback = GameHotkeyManager.actionKeyPressed,
			hotkeys = {
				{
					name = "Action Bar |1|",
					id = HOTKEYS_IDS.ACTION_BAR_1,
					defaultKeys = {
						[1] = "1"
					}
				},
				{
					name = "Action Bar |2|",
					id = HOTKEYS_IDS.ACTION_BAR_2,
					defaultKeys = {
						[1] = "2"
					}
				},
				{
					name = "Action Bar |3|",
					id = HOTKEYS_IDS.ACTION_BAR_3,
					defaultKeys = {
						[1] = "3"
					}
				},
				{
					name = "Action Bar |4|",
					id = HOTKEYS_IDS.ACTION_BAR_4,
					defaultKeys = {
						[1] = "4"
					}
				},
				{
					name = "Action Bar |5|",
					id = HOTKEYS_IDS.ACTION_BAR_5,
					defaultKeys = {
						[1] = "5"
					}
				},
				{
					name = "Action Bar |6|",
					id = HOTKEYS_IDS.ACTION_BAR_6,
					defaultKeys = {
						[1] = "6"
					}
				},
				{
					name = "Action Bar |7|",
					id = HOTKEYS_IDS.ACTION_BAR_7,
					defaultKeys = {
						[1] = "7"
					}
				},
				{
					name = "Action Bar |8|",
					id = HOTKEYS_IDS.ACTION_BAR_8,
					defaultKeys = {
						[1] = "8"
					}
				},
				{
					name = "Action Bar |9|",
					id = HOTKEYS_IDS.ACTION_BAR_9,
					defaultKeys = {
						[1] = "9"
					}
				},
				{
					name = "Action Bar |10|",
					id = HOTKEYS_IDS.ACTION_BAR_10,
					defaultKeys = {
						[1] = "0"
					}
				},
				{
					name = "Action Bar |11|",
					id = HOTKEYS_IDS.ACTION_BAR_11,
					defaultKeys = {
						[1] = "-"
					}
				},
				{
					name = "Action Bar |12|",
					id = HOTKEYS_IDS.ACTION_BAR_12,
					defaultKeys = {
						[1] = "="
					}
				},
				{
					name = "Action Bar |13|",
					id = HOTKEYS_IDS.ACTION_BAR_13,
					defaultKeys = {
						[1] = "Shift+1"
					}
				},
				{
					name = "Action Bar |14|",
					id = HOTKEYS_IDS.ACTION_BAR_14,
					defaultKeys = {
						[1] = "Shift+2"
					}
				},
				{
					name = "Action Bar |15|",
					id = HOTKEYS_IDS.ACTION_BAR_15,
					defaultKeys = {
						[1] = "Shift+3"
					}
				},
				{
					name = "Action Bar |16|",
					id = HOTKEYS_IDS.ACTION_BAR_16,
					defaultKeys = {
						[1] = "Shift+4"
					}
				},
				{
					name = "Action Bar |17|",
					id = HOTKEYS_IDS.ACTION_BAR_17,
					defaultKeys = {
						[1] = "Shift+5"
					}
				},
				{
					name = "Action Bar |18|",
					id = HOTKEYS_IDS.ACTION_BAR_18,
					defaultKeys = {
						[1] = "Shift+6"
					}
				},
				{
					name = "Action Bar |19|",
					id = HOTKEYS_IDS.ACTION_BAR_19,
					defaultKeys = {
						[1] = "Shift+7"
					}
				},
				{
					name = "Action Bar |20|",
					id = HOTKEYS_IDS.ACTION_BAR_20,
					defaultKeys = {
						[1] = "Shift+8"
					}
				},
				{
					name = "Action Bar |21|",
					id = HOTKEYS_IDS.ACTION_BAR_21,
					defaultKeys = {
						[1] = "Shift+9"
					}
				},
				{
					name = "Action Bar |22|",
					id = HOTKEYS_IDS.ACTION_BAR_22,
					defaultKeys = {
						[1] = "Shift+0"
					}
				},
				{
					name = "Action Bar |23|",
					id = HOTKEYS_IDS.ACTION_BAR_23,
					defaultKeys = {
						[1] = "Shift+-"
					}
				},
				{
					name = "Action Bar |24|",
					id = HOTKEYS_IDS.ACTION_BAR_24,
					defaultKeys = {
						[1] = "Shift+="
					}
				},
				{
					name = "Action Bar |25|",
					id = HOTKEYS_IDS.ACTION_BAR_25,
					defaultKeys = {
						[1] = "Ctrl+1"
					}
				},
				{
					name = "Action Bar |26|",
					id = HOTKEYS_IDS.ACTION_BAR_26,
					defaultKeys = {
						[1] = "Ctrl+2"
					}
				},
				{
					name = "Action Bar |27|",
					id = HOTKEYS_IDS.ACTION_BAR_27,
					defaultKeys = {
						[1] = "Ctrl+3"
					}
				},
				{
					name = "Action Bar |28|",
					id = HOTKEYS_IDS.ACTION_BAR_28,
					defaultKeys = {
						[1] = "Ctrl+4"
					}
				},
				{
					name = "Action Bar |29|",
					id = HOTKEYS_IDS.ACTION_BAR_29,
					defaultKeys = {
						[1] = "Ctrl+5"
					}
				},
				{
					name = "Action Bar |30|",
					id = HOTKEYS_IDS.ACTION_BAR_30,
					defaultKeys = {
						[1] = "Ctrl+6"
					}
				},
				{
					name = "Action Bar |31|",
					id = HOTKEYS_IDS.ACTION_BAR_31,
					defaultKeys = {
						[1] = "Ctrl+7"
					}
				},
				{
					name = "Action Bar |32|",
					id = HOTKEYS_IDS.ACTION_BAR_32,
					defaultKeys = {
						[1] = "Ctrl+8"
					}
				},
				{
					name = "Action Bar |33|",
					id = HOTKEYS_IDS.ACTION_BAR_33,
					defaultKeys = {
						[1] = "Ctrl+9"
					}
				},
				{
					name = "Action Bar |34|",
					id = HOTKEYS_IDS.ACTION_BAR_34,
					defaultKeys = {
						[1] = "Ctrl+0"
					}
				},
				{
					name = "Action Bar |35|",
					id = HOTKEYS_IDS.ACTION_BAR_35,
					defaultKeys = {
						[1] = "Ctrl+-"
					}
				},
				{
					name = "Action Bar |36|",
					id = HOTKEYS_IDS.ACTION_BAR_36,
					defaultKeys = {
						[1] = "Ctrl+="
					}
				},
				{
					name = "Action Bar |37|",
					id = HOTKEYS_IDS.ACTION_BAR_37,
					defaultKeys = {}
				},
				{
					name = "Action Bar |38|",
					id = HOTKEYS_IDS.ACTION_BAR_38,
					defaultKeys = {}
				},
				{
					name = "Action Bar |39|",
					id = HOTKEYS_IDS.ACTION_BAR_39,
					defaultKeys = {}
				},
				{
					name = "Action Bar |40|",
					id = HOTKEYS_IDS.ACTION_BAR_40,
					defaultKeys = {}
				},
				{
					name = "Action Bar |41|",
					id = HOTKEYS_IDS.ACTION_BAR_41,
					defaultKeys = {}
				},
				{
					name = "Action Bar |42|",
					id = HOTKEYS_IDS.ACTION_BAR_42,
					defaultKeys = {}
				},
				{
					name = "Action Bar |43|",
					id = HOTKEYS_IDS.ACTION_BAR_43,
					defaultKeys = {}
				},
				{
					name = "Action Bar |44|",
					id = HOTKEYS_IDS.ACTION_BAR_44,
					defaultKeys = {}
				},
				{
					name = "Action Bar |45|",
					id = HOTKEYS_IDS.ACTION_BAR_45,
					defaultKeys = {}
				},
				{
					name = "Action Bar |46|",
					id = HOTKEYS_IDS.ACTION_BAR_46,
					defaultKeys = {}
				},
				{
					name = "Action Bar |47|",
					id = HOTKEYS_IDS.ACTION_BAR_47,
					defaultKeys = {}
				},
				{
					name = "Action Bar |48|",
					id = HOTKEYS_IDS.ACTION_BAR_48,
					defaultKeys = {}
				},
				{
					name = "Mount Bar |1|",
					id = HOTKEYS_IDS.MOUNT_BAR_1,
					defaultKeys = {
						[1] = "Ctrl+F1"
					}
				},
				{
					name = "Mount Bar |2|",
					id = HOTKEYS_IDS.MOUNT_BAR_2,
					defaultKeys = {
						[1] = "Ctrl+F2"
					}
				},
				{
					name = "Mount Bar |3|",
					id = HOTKEYS_IDS.MOUNT_BAR_3,
					defaultKeys = {
						[1] = "Ctrl+F3"
					}
				},
				{
					name = "Mount Bar |4|",
					id = HOTKEYS_IDS.MOUNT_BAR_4,
					defaultKeys = {
						[1] = "Ctrl+F4"
					}
				},
				{
					name = "Mount Bar |5|",
					id = HOTKEYS_IDS.MOUNT_BAR_5,
					defaultKeys = {
						[1] = "Ctrl+F5"
					}
				},
				{
					name = "Mount Bar |6|",
					id = HOTKEYS_IDS.MOUNT_BAR_6,
					defaultKeys = {
						[1] = "Ctrl+F6"
					}
				},
				{
					name = "Weapon Skill",
					id = HOTKEYS_IDS.WEAPON_SKILL,
					defaultKeys = {
						[1] = "R"
					}
				},
				{
					name = "Mount/Dismount",
					ignoreAutoRepeat = true,
					id = HOTKEYS_IDS.MOUNT_DISMOUNT,
					defaultKeys = {
						[1] = "Ctrl+R"
					}
				}
			}
		},
		{
			keyComboInterval = 50,
			name = "Actions",
			hotkeys = {
				{
					name = "Next Target",
					id = HOTKEYS_IDS.NEXT_TARGET,
					defaultKeys = {
						[1] = "Tab"
					},
					callback = function()
						modules.game_battle.attackNextTarget()
					end
				},
				{
					name = "Next Player Target",
					id = HOTKEYS_IDS.NEXT_PLAYER_TARGET,
					defaultKeys = {
						[1] = "Shift+Tab"
					},
					callback = function()
						modules.game_battle.attackNextPlayer()
					end
				},
				{
					name = "Next Ally",
					id = HOTKEYS_IDS.NEXT_ALLY,
					defaultKeys = {
						[1] = "Ctrl+Tab"
					},
					callback = function()
						modules.game_battle.healNextTarget()
					end
				},
				{
					name = "Ally Switch (Click)",
					id = HOTKEYS_IDS.ALLY_TARGET_SWITCH_CLICK,
					defaultKeys = {
						[1] = "Space"
					},
					callback = function()
						modules.game_battle.healSwitchTarget()
					end
				},
				{
					hasRelease = true,
					name = "Ally Switch (Hold)",
					id = HOTKEYS_IDS.ALLY_TARGET_SWITCH_HOLD,
					defaultKeys = {
						[1] = "Ctrl+Space"
					},
					callback = function()
						modules.game_battle.healSwitchTarget()
					end
				},
				{
					name = "Land Interaction |1|",
					id = HOTKEYS_IDS.LAND_INTERACTION_1,
					callback = GameHotkeyManager.landInteractionHotkeyPressed,
					defaultKeys = {
						[1] = "F1"
					}
				},
				{
					name = "Land Interaction |2|",
					id = HOTKEYS_IDS.LAND_INTERACTION_2,
					callback = GameHotkeyManager.landInteractionHotkeyPressed,
					defaultKeys = {
						[1] = "F2"
					}
				},
				{
					name = "Land Interaction |3|",
					id = HOTKEYS_IDS.LAND_INTERACTION_3,
					callback = GameHotkeyManager.landInteractionHotkeyPressed,
					defaultKeys = {
						[1] = "F3"
					}
				},
				{
					name = "Land Interaction |4|",
					id = HOTKEYS_IDS.LAND_INTERACTION_4,
					callback = GameHotkeyManager.landInteractionHotkeyPressed,
					defaultKeys = {
						[1] = "F4"
					}
				}
			}
		},
		{
			name = "Interface",
			hotkeys = {
				{
					name = "Character",
					id = HOTKEYS_IDS.CHARACTER,
					defaultKeys = {
						[1] = "X"
					},
					callback = function()
						modules.game_character.GameCharacter.toggle()
					end
				},
				{
					name = "Inventory",
					id = HOTKEYS_IDS.INVENTORY,
					defaultKeys = {
						[1] = "I"
					},
					callback = function()
						modules.game_inventory.GameInventory.toggle()
					end
				},
				{
					name = "Infusion",
					id = HOTKEYS_IDS.INFUSION,
					defaultKeys = {
						[1] = "U"
					},
					callback = function()
						modules.game_infusion.GameInfusion.toggle()
					end
				},
				{
					name = "Ravencards",
					id = HOTKEYS_IDS.RAVENCARDS,
					defaultKeys = {
						[1] = "G"
					},
					callback = function()
						modules.game_cards.GameCards.toggleCollectionWindow()
					end
				},
				{
					name = "Archetypes",
					id = HOTKEYS_IDS.ARCHETYPES,
					defaultKeys = {
						[1] = "K"
					},
					callback = function()
						modules.game_spelltree.GameSpellTree.toggle()
					end
				},
				{
					name = "Professions",
					id = HOTKEYS_IDS.PROFESSIONS,
					defaultKeys = {
						[1] = "P"
					},
					callback = function()
						modules.game_professions.GameProfessions.toggle()
					end
				},
				{
					name = "Reputation",
					id = HOTKEYS_IDS.REPUTATION,
					defaultKeys = {
						[1] = "H"
					},
					callback = function()
						modules.game_reputation.GameReputation.toggle()
					end
				},
				{
					name = "Aether Rift",
					id = HOTKEYS_IDS.AETHER_RIFT,
					defaultKeys = {
						[1] = "Z"
					},
					callback = function()
						modules.game_aether_rift.GameAetherRift.toggle()
					end
				},
				{
					name = "Transport",
					id = HOTKEYS_IDS.TRANSPORT,
					defaultKeys = {
						[1] = "Y"
					},
					callback = function()
						modules.game_transport.GameTransport.toggle()
					end
				},
				{
					name = "Map",
					id = HOTKEYS_IDS.MAP,
					defaultKeys = {
						[1] = "M"
					},
					callback = function()
						g_worldMap.toggle()
					end
				},
				{
					name = "Quest",
					id = HOTKEYS_IDS.QUEST,
					defaultKeys = {
						[1] = "L"
					},
					callback = function()
						modules.game_questlog.GameQuestLog.toggle()
					end
				},
				{
					name = "Rangers Company",
					id = HOTKEYS_IDS.RANGERS_COMPANY,
					defaultKeys = {
						[1] = "B"
					},
					callback = function()
						modules.game_rangerscompany.GameRangersCompany.toggleRangersWindow()
					end
				},
				{
					name = "Adventurer's Board",
					id = HOTKEYS_IDS.ADVENTURERS_BOARD,
					defaultKeys = {
						[1] = "Ctrl+B"
					},
					callback = function()
						modules.game_adventurers_board.GameAdventurersBoard.toggleAdventurersBoardWindow()
					end
				},
				{
					name = "Tradepack",
					id = HOTKEYS_IDS.TRADEPACK,
					defaultKeys = {
						[1] = "T"
					},
					callback = function()
						modules.game_tradepacks.GameTradepacks.toggle()
					end
				},
				{
					name = "Journal",
					id = HOTKEYS_IDS.JOURNAL,
					defaultKeys = {
						[1] = "J"
					},
					callback = function()
						modules.game_journal.GameJournal.toggle()
					end
				},
				{
					name = "Guild",
					id = HOTKEYS_IDS.GUILD,
					defaultKeys = {
						[1] = "V"
					},
					callback = function()
						modules.game_guild.GameGuild.toggle()
					end
				},
				{
					name = "Social",
					id = HOTKEYS_IDS.SOCIAL,
					defaultKeys = {
						[1] = "N"
					},
					callback = function()
						modules.game_social.GameSocial.toggle()
					end
				},
				{
					name = "Tutorial",
					id = HOTKEYS_IDS.TUTORIAL,
					callback = function()
						modules.game_interactions.GameInteractions.toggleListWindow()
					end
				},
				{
					name = "Settings",
					id = HOTKEYS_IDS.SETTINGS,
					defaultKeys = {
						[1] = "O"
					},
					callback = function()
						modules.game_settings.GameSettings.toggle()
					end
				},
				{
					name = "Redeem Rewards",
					id = HOTKEYS_IDS.REDEEM_REWARDS,
					defaultKeys = {
						[1] = "Ctrl+X"
					},
					callback = function()
						modules.game_redeem_rewards.GameRedeemRewards.toggle()
					end
				},
				{
					name = "Quest Tracker",
					id = HOTKEYS_IDS.QUEST_TRACKER,
					callback = function()
						modules.game_settings.toggleOption("showQuestTracker")
					end
				},
				{
					name = "Report/Feedback",
					id = HOTKEYS_IDS.REPORT_FEEDBACK,
					callback = function()
						modules.game_feedback.toggle()
					end
				},
				{
					name = "Land Tracker",
					id = HOTKEYS_IDS.LAND_TRACKER,
					callback = function()
						modules.game_house.GameHouse:toggleHouseMode()
					end
				},
				{
					name = "Toggle PvP",
					id = HOTKEYS_IDS.TOGGLE_PVP,
					callback = function()
						modules.game_minimap.selectNextPvpMode()
					end
				},
				{
					name = "Toggle Floor Indicators",
					id = HOTKEYS_IDS.TOGGLE_FLOOR_INDICATOR,
					defaultKeys = {
						[1] = "Shift+F"
					},
					callback = function()
						modules.game_settings.GameSettings:setOption("floorIndicatorMode", modules.game_minimap.getNextFloorIndicatorMode())
					end
				}
			}
		},
		{
			name = "Misc",
			hotkeys = {
				{
					name = "Edit Mode",
					id = HOTKEYS_IDS.EDIT_MODE,
					callback = function()
						local key = "layoutEditMode"

						modules.game_settings.toggleOption(key)
					end
				},
				{
					name = "Hide Interface",
					id = HOTKEYS_IDS.HIDE_INTERFACE,
					callback = function()
						local key = "hideInterface"

						modules.game_settings.toggleOption(key)
					end
				},
				{
					name = "Toggle Performance Stats",
					id = HOTKEYS_IDS.PERFORMANCE_STATS,
					defaultKeys = {
						[1] = "Alt+F1"
					},
					callback = function()
						local enabled = g_extras.get("debugRender")
						local widget = g_app.getPerformanceGraphsWidget()

						if not widget then
							return
						end

						g_extras.set("debugRender", not enabled)
						widget:setVisible(not enabled)
					end
				}
			}
		}
	}
end

function GameHotkeyManager:getHotkeyDataByHotkeyId(hotkeyId)
	return self.hotkeyDataByHotkeyId[hotkeyId]
end

function GameHotkeyManager:getKeyComboData(keyCombo)
	return self.keyComboData[keyCombo]
end

function GameHotkeyManager:setupHotkeys()
	self.hotkeyDataByHotkeyId = {}
	self.keyComboData = {}

	local savedHotkeys = g_settings.getNode("game_hotkey_manager")

	self.customHotkeys = savedHotkeys ~= nil

	for _, category in ipairs(self.categories) do
		for _, hotkeyData in ipairs(category.hotkeys) do
			if not self.hotkeyDataByHotkeyId[hotkeyData.id] then
				self.hotkeyDataByHotkeyId[hotkeyData.id] = {
					category = category,
					hotkey = hotkeyData
				}
			end

			hotkeyData.keys = {}

			local mainKeyCombo

			for i = 1, self.maxKeyCombos do
				local keyCombo = savedHotkeys and savedHotkeys[tostring(hotkeyData.id)] and savedHotkeys[tostring(hotkeyData.id)][tostring(i)] or hotkeyData.defaultKeys and hotkeyData.defaultKeys[i]

				if keyCombo then
					if type(keyCombo) == "number" then
						keyCombo = tostring(keyCombo)
					end

					if keyCombo == "nil" then
						keyCombo = ""
					elseif keyCombo == "minus" then
						keyCombo = "-"
					elseif keyCombo == "plus" then
						keyCombo = "+"
					end

					if not mainKeyCombo and keyCombo ~= "" then
						mainKeyCombo = keyCombo
					end

					if not self.keyComboData[keyCombo] then
						hotkeyData.keys[i] = keyCombo

						if keyCombo ~= "" then
							self.keyComboData[keyCombo] = {
								category = category,
								hotkey = hotkeyData,
								index = i
							}

							self:bindKeyCombo(keyCombo, hotkeyData.hasRelease)
						end
					end
				end
			end

			signalcall(GameHotkeyManager.onHotkeyUpdate, hotkeyData.id, mainKeyCombo, true)
		end
	end
end

function GameHotkeyManager.saveHotkeys()
	local self = GameHotkeyManager
	local hotkeys = {}

	for _, hotkeyId in pairs(HOTKEYS_IDS) do
		local data = self:getHotkeyDataByHotkeyId(hotkeyId)
		local hotkeyData = data and data.hotkey

		if hotkeyData then
			for i = 1, self.maxKeyCombos do
				local keyCombo = hotkeyData.keys and hotkeyData.keys[i]

				if keyCombo and keyCombo ~= (hotkeyData.defaultKeys and hotkeyData.defaultKeys[i] or "") then
					local hotkeyIdKey = tostring(hotkeyId)

					if not hotkeys[hotkeyIdKey] then
						hotkeys[hotkeyIdKey] = {}
					end

					if keyCombo == "" then
						keyCombo = "nil"
					elseif keyCombo == "-" then
						keyCombo = "minus"
					elseif keyCombo == "+" then
						keyCombo = "plus"
					end

					hotkeys[hotkeyIdKey][tostring(i)] = keyCombo
				end
			end
		end
	end

	if table.empty(hotkeys) then
		self.customHotkeys = false

		g_settings.remove("game_hotkey_manager")
	else
		self.customHotkeys = true

		g_settings.setNode("game_hotkey_manager", hotkeys)
	end

	g_settings.save()
	modules.game_settings.GameSettings:updateHotkeyResetButton()
end

function GameHotkeyManager:hasCustomHotkeys()
	return self.customHotkeys
end

function GameHotkeyManager:unbindHotkeys()
	for keyCombo, keyComboData in pairs(self.keyComboData) do
		self:unbindKeyCombo(keyCombo, keyComboData.hotkey.hasRelease)
	end

	signalcall(GameHotkeyManager.onHotkeyUpdate, -1, "", true)
end

function GameHotkeyManager:resetHotkeys()
	g_settings.remove("game_hotkey_manager")
	g_settings.save()
	self:unbindHotkeys()
	self:setupHotkeys()
	modules.game_settings.GameSettings:populateHotkeys()
	modules.game_settings.GameSettings:updateHotkeyResetButton()
end

function GameHotkeyManager:isReservedHotkey(keyCombo)
	return table.contains(self.reservedHotkeys, keyCombo)
end

function GameHotkeyManager:bindKeyCombo(keyCombo, hasRelease)
	if isMouseCombo(keyCombo) then
		g_mouse.bindFocusPress(keyCombo, self.onMousePressed)

		if hasRelease then
			g_mouse.bindFocusRelease(keyCombo, self.onMouseUp)
		end
	else
		g_keyboard.bindKeyPress(keyCombo, self.onKeyPressed)

		if hasRelease then
			g_keyboard.bindKeyUp(keyCombo, self.onKeyUp)
		end
	end
end

function GameHotkeyManager:unbindKeyCombo(keyCombo, hasRelease)
	if isMouseCombo(keyCombo) then
		g_mouse.unbindFocusPress(keyCombo)

		if hasRelease then
			g_mouse.unbindFocusRelease(keyCombo)
		end
	else
		g_keyboard.unbindKeyPress(keyCombo)

		if hasRelease then
			g_keyboard.unbindKeyUp(keyCombo)
		end
	end
end

function GameHotkeyManager:setHotkeyKeyCombo(hotkeyId, keyCombo, index, force, save)
	local data = self:getHotkeyDataByHotkeyId(hotkeyId)

	if not data then
		return false
	end

	if keyCombo then
		local keyComboData = self:getKeyComboData(keyCombo)

		if keyComboData then
			if not force then
				return false
			end

			self:setHotkeyKeyCombo(keyComboData.hotkey.id, nil, keyComboData.index, true)
		end
	end

	keyCombo = keyCombo or ""

	local oldKeyCombo = data.hotkey.keys[index] or ""

	if oldKeyCombo == keyCombo then
		return false
	end

	if oldKeyCombo ~= "" then
		self:unbindKeyCombo(oldKeyCombo, data.hotkey.hasRelease)

		self.keyComboData[oldKeyCombo] = nil
	end

	data.hotkey.keys[index] = keyCombo

	if keyCombo ~= "" then
		self.keyComboData[keyCombo] = {
			category = data.category,
			hotkey = data.hotkey,
			index = index
		}

		self:bindKeyCombo(keyCombo, data.hotkey.hasRelease)
	end

	local mainKeyCombo, mainKeyComboIndex = self:getHotkeyMainKeyCombo(hotkeyId)

	if mainKeyCombo == "" or mainKeyComboIndex <= index then
		signalcall(GameHotkeyManager.onHotkeyUpdate, hotkeyId, keyCombo, true)
	end

	if save then
		self:saveHotkeys()
	end

	return true
end

function GameHotkeyManager:getHotkeyMainKeyCombo(hotkeyId, notFoundValue)
	local data = self:getHotkeyDataByHotkeyId(hotkeyId)

	if not data then
		return notFoundValue
	end

	for i = 1, self.maxKeyCombos do
		if data.hotkey.keys[i] and data.hotkey.keys[i] ~= "" then
			return data.hotkey.keys[i], i
		end
	end

	return notFoundValue or "", 0
end

function GameHotkeyManager:getHotkeyKeyCombo(hotkeyId, index)
	local data = self:getHotkeyDataByHotkeyId(hotkeyId)

	return data and data.hotkey.keys[index] or ""
end

function GameHotkeyManager:addDelayToHotkeys(delay)
	delay = delay or 200
	self.lastKeyComboTime = {}

	local time = g_clock.millis() + delay

	for _, category in ipairs(self.categories) do
		self.lastKeyComboTime[category.name] = time
	end
end

function GameHotkeyManager.onMousePressed(widget, mouseButton, keyboardModifiers, mouseCombo)
	GameHotkeyManager:onKeyComboPressed(mouseButton, mouseCombo, keyboardModifiers, 0)
end

function GameHotkeyManager.onMouseUp(widget, mouseButton, keyboardModifiers, mouseCombo)
	GameHotkeyManager:onKeyComboPressed(mouseButton, mouseCombo, keyboardModifiers, 0, true)
end

function GameHotkeyManager.onKeyPressed(widget, key, autoRepeatTicks, keyCombo, keyboardModifiers)
	GameHotkeyManager:onKeyComboPressed(key, keyCombo, keyboardModifiers, autoRepeatTicks)
end

function GameHotkeyManager.onKeyUp(widget, key, keyCombo, keyboardModifiers)
	GameHotkeyManager:onKeyComboPressed(key, keyCombo, keyboardModifiers, 0, true)
end

function GameHotkeyManager:onKeyComboPressed(key, keyCombo, keyboardModifiers, autoRepeatTicks, isRelease)
	return self:keyComboPressed({
		data = self:getKeyComboData(keyCombo),
		key = key,
		keyCombo = keyCombo,
		keyboardModifiers = keyboardModifiers,
		autoRepeatTicks = autoRepeatTicks,
		isRelease = isRelease
	})
end

function GameHotkeyManager:keyComboPressed(context)
	if GameChat:isActive() or IsTextEditActive() or g_game:isInCutsceneMode() or modules.game_settings.GameSettings:isEditingHotkey() then
		return
	end

	local data = context.data

	if not data then
		data = self:getKeyComboData(determineKeyComboDesc(key))

		if not data then
			return
		end
	end

	local ignoreHouseMode = data.category.ignoreHouseMode

	if not ignoreHouseMode and g_game.isInHouseMode() then
		return
	end

	local time = g_clock.millis()

	if not context.isRelease then
		local ignoreAutoRepeat = not data.category.notIgnoreAutoRepeat or not not data.hotkey.ignoreAutoRepeat

		if ignoreAutoRepeat and context.autoRepeatTicks and context.autoRepeatTicks > 0 then
			return
		end

		local keyComboInterval = data.category.keyComboInterval or self.keyComboInterval
		local lastKeyComboTime = self.lastKeyComboTime[data.category.name]

		if lastKeyComboTime and time < lastKeyComboTime + keyComboInterval then
			return
		end
	elseif not data.hotkey.hasRelease then
		return
	end

	self.lastKeyComboTime[data.category.name] = time

	local result

	if data.hotkey.callback then
		result = data.hotkey.callback(data.hotkey, context)
	elseif data.category.callback then
		result = data.category.callback(data.hotkey, context)
	end

	if result then
		context.data = self:getHotkeyDataByHotkeyId(data.hotkey.fallback)
		context.isFallback = true

		self:keyComboPressed(context)
	end
end

function GameHotkeyManager.actionKeyPressed(hotkeyData)
	modules.game_abilitybar.AbilityBar.onHotkeyPressed(hotkeyData.id)
end

function GameHotkeyManager:isHotkeyPressed(hotkeyId, ignoreModifiers)
	local data = GameHotkeyManager:getHotkeyDataByHotkeyId(hotkeyId)

	if not data then
		return false
	end

	local keys = data.hotkey.keys

	if not keys then
		return false
	end

	for _, keyCombo in pairs(keys) do
		if self:isKeyComboPressed(keyCombo, ignoreModifiers) then
			return true
		end
	end

	return false
end

function GameHotkeyManager:isKeyComboPressed(keyCombo, ignoreModifiers)
	if not keyCombo or keyCombo == "" then
		return false
	end

	if isMouseCombo(keyCombo) then
		if g_mouse.isComboPressed(keyCombo) then
			return true
		end
	elseif g_keyboard.isComboPressed(keyCombo, ignoreModifiers) then
		return true
	end

	return false
end

function GameHotkeyManager.walkHotkeyPressed(hotkeyData, context)
	local dir = HOTKEY_ID_TO_WALK_DIRECTION[hotkeyData.id]

	if not dir then
		return
	end

	smartWalk(dir)
end

function GameHotkeyManager.turnHotkeyPressed(hotkeyData, context)
	local dir = HOTKEY_ID_TO_TURN_DIRECTION[hotkeyData.id]

	if not dir then
		return
	end

	turn(dir, true)
end

function GameHotkeyManager.landInteractionHotkeyPressed(hotkeyData)
	modules.game_professions.onLandInteractionHotkeyPressed(hotkeyData.id)
end

function GameHotkeyManager.isWalkHotkey(keyCombo)
	local data = GameHotkeyManager:getKeyComboData(keyCombo)

	if not data then
		return false
	end

	local hotkey = data.hotkey

	if not hotkey then
		return false
	end

	return hotkey.id == HOTKEYS_IDS.WALK_NORTH or hotkey.id == HOTKEYS_IDS.WALK_EAST or hotkey.id == HOTKEYS_IDS.WALK_SOUTH or hotkey.id == HOTKEYS_IDS.WALK_WEST
end

function GameHotkeyManager.isTurnHotkey(keyCombo)
	local data = GameHotkeyManager:getKeyComboData(keyCombo)

	if not data then
		return false
	end

	local hotkey = data.hotkey

	if not hotkey then
		return false
	end

	return hotkey.id == HOTKEYS_IDS.TURN_NORTH or hotkey.id == HOTKEYS_IDS.TURN_EAST or hotkey.id == HOTKEYS_IDS.TURN_SOUTH or hotkey.id == HOTKEYS_IDS.TURN_WEST
end
