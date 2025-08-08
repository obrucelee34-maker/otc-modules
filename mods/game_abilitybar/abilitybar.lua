-- chunkname: @/modules/game_abilitybar/abilitybar.lua

local protocol = runinsandbox("abilitybarprotocol")
local assetPrefix = "/images/ui/icons/abilitybar/"
local lastHotkeyPress = 0
local cacheLoadingEnabled = not g_app.isProductionRelease()
local editingSlot, spellBatchEvent
local holdKeyAbilities = {}
local holdKeyEvents = {}
local excludeGlobalCooldownAbilities = {
	[105] = true,
	[56] = true,
	[104] = true,
	[81] = true,
	[78] = true,
	[50] = true,
	[47] = true,
	[142] = true,
	[110] = true,
	[28] = true,
	[141] = true,
	[109] = true,
	[140] = true,
	[59] = true,
	[85] = true,
	[35] = true,
	[60] = true,
	[91] = true,
	[114] = true,
	[53] = true,
	[67] = true
}
local freeRecastAbilities = {
	[59] = true,
	[106] = true,
	[76] = true,
	[50] = true,
	[53] = true
}
local lockWalkAbilities = {
	[115] = true,
	[121] = true,
	[126] = true
}

AbilityBar = {
	numSlots = 48,
	numSlotsPerBar = 6,
	mountKeysIndex = 7,
	spellBatchTime = 500,
	spellCharges = {},
	customGlobalCooldownAbilities = {},
	bars = {},
	barWidgets = {},
	callbacks = {},
	hotkeysInUse = {},
	weaponSkillHotkeyId = HOTKEYS_IDS.WEAPON_SKILL,
	mountSkillHotkeyId = HOTKEYS_IDS.MOUNT_DISMOUNT,
	barHotkeys = {
		{
			HOTKEYS_IDS.ACTION_BAR_1,
			HOTKEYS_IDS.ACTION_BAR_2,
			HOTKEYS_IDS.ACTION_BAR_3,
			HOTKEYS_IDS.ACTION_BAR_4,
			HOTKEYS_IDS.ACTION_BAR_5,
			HOTKEYS_IDS.ACTION_BAR_6
		},
		{
			HOTKEYS_IDS.ACTION_BAR_7,
			HOTKEYS_IDS.ACTION_BAR_8,
			HOTKEYS_IDS.ACTION_BAR_9,
			HOTKEYS_IDS.ACTION_BAR_10,
			HOTKEYS_IDS.ACTION_BAR_11,
			HOTKEYS_IDS.ACTION_BAR_12
		},
		{
			HOTKEYS_IDS.ACTION_BAR_13,
			HOTKEYS_IDS.ACTION_BAR_14,
			HOTKEYS_IDS.ACTION_BAR_15,
			HOTKEYS_IDS.ACTION_BAR_16,
			HOTKEYS_IDS.ACTION_BAR_17,
			HOTKEYS_IDS.ACTION_BAR_18
		},
		{
			HOTKEYS_IDS.ACTION_BAR_19,
			HOTKEYS_IDS.ACTION_BAR_20,
			HOTKEYS_IDS.ACTION_BAR_21,
			HOTKEYS_IDS.ACTION_BAR_22,
			HOTKEYS_IDS.ACTION_BAR_23,
			HOTKEYS_IDS.ACTION_BAR_24
		},
		{
			HOTKEYS_IDS.ACTION_BAR_25,
			HOTKEYS_IDS.ACTION_BAR_26,
			HOTKEYS_IDS.ACTION_BAR_27,
			HOTKEYS_IDS.ACTION_BAR_28,
			HOTKEYS_IDS.ACTION_BAR_29,
			HOTKEYS_IDS.ACTION_BAR_30
		},
		{
			HOTKEYS_IDS.ACTION_BAR_31,
			HOTKEYS_IDS.ACTION_BAR_32,
			HOTKEYS_IDS.ACTION_BAR_33,
			HOTKEYS_IDS.ACTION_BAR_34,
			HOTKEYS_IDS.ACTION_BAR_35,
			HOTKEYS_IDS.ACTION_BAR_36
		},
		{
			HOTKEYS_IDS.MOUNT_BAR_1,
			HOTKEYS_IDS.MOUNT_BAR_2,
			HOTKEYS_IDS.MOUNT_BAR_3,
			HOTKEYS_IDS.MOUNT_BAR_4,
			HOTKEYS_IDS.MOUNT_BAR_5,
			HOTKEYS_IDS.MOUNT_BAR_6
		},
		{
			HOTKEYS_IDS.ACTION_BAR_37,
			HOTKEYS_IDS.ACTION_BAR_38,
			HOTKEYS_IDS.ACTION_BAR_39,
			HOTKEYS_IDS.ACTION_BAR_40,
			HOTKEYS_IDS.ACTION_BAR_41,
			HOTKEYS_IDS.ACTION_BAR_42
		},
		{
			HOTKEYS_IDS.ACTION_BAR_43,
			HOTKEYS_IDS.ACTION_BAR_44,
			HOTKEYS_IDS.ACTION_BAR_45,
			HOTKEYS_IDS.ACTION_BAR_46,
			HOTKEYS_IDS.ACTION_BAR_47,
			HOTKEYS_IDS.ACTION_BAR_48
		}
	},
	assets = {
		[AbilityBarCategorySpell] = {
			"Precision Shot",
			"Concussive Shot",
			"Dragons Arrow",
			"Disengage",
			"Dawn Arrow",
			"Rain of Arrows",
			"Quick Fire",
			"Snaring Shot",
			"Viper Arrow",
			"Wind Arrow",
			"Icestorm",
			"Dragons Roar",
			"Fireball",
			"Firestorm",
			"Freezing Wind",
			"Frost Nova",
			"Frost Shards",
			"Frostbolt",
			"Erupt",
			"Pyroblast",
			"Arcane Beam",
			"Arcane Pulse",
			"Arcane Torrent",
			"Siphon",
			"Hex",
			"Leech",
			"Magic Rupture",
			"Shackles of Pain",
			"Shadowflare",
			"Time Warp",
			"Banner of Justice",
			"Banner of Protection",
			"Banner of Virtue",
			"Blessed Earth",
			"Safeguard",
			"Provoke",
			"Bash",
			"Spirit Hammer",
			"Spirit Shield",
			"Zealots Flame",
			"Air Aura",
			"Barrier",
			"Empower",
			"Haste",
			"Healing Air Sphere",
			"Party Recovery",
			"Windstrike Spirit",
			"Regenerate",
			"Cyclone",
			"Wind Wall",
			"Anti-Healing Venom",
			"Coup de Grace",
			"Crippling Dagger",
			"Death Blossom",
			"Shadowstrike",
			"Illusive",
			"Quick Slash",
			"Shadowbind",
			"Stalk",
			"Sinister Plot",
			"Brutal Strike",
			"Bull Rush",
			"Earthquake",
			"Feasting Strike",
			"Guillotine",
			"Fierce Leap",
			"Berserk",
			"Shieldbreak",
			"Fissure",
			"Spiked Chains",
			"Circle of Light",
			"Devotion",
			"Flash Heal",
			"Healing Channel",
			"Holy Force",
			"Dawn's Light",
			"Holy Shackles",
			"Living Saint",
			"Mend",
			"Smite",
			nil,
			"Combustion",
			"Flame Tornado",
			"Coldblast",
			"Teleport",
			"Force Push",
			"Curse",
			"Death Touch",
			"Mirror Image",
			"Spirits Resolve",
			"Unchained",
			nil,
			nil,
			nil,
			nil,
			nil,
			"Meteor Strike",
			"Frost Lance",
			"Purify",
			"Generous Influence",
			"Whirlwind",
			"Typhoon",
			"Eternal Worms",
			"Dispel",
			"Pummel",
			"Bladestorm",
			"Smiting Smash",
			"Unbreakable",
			"Venomous Weapons",
			"Shadow Kick",
			"Spirit Rangers",
			"Venom Grenade",
			"Revenge",
			"Shield Throw",
			[1061] = "Gauntlet of Skorn",
			[1057] = "Waterless Poppy Blossoms",
			[1053] = "Immaterial Bangle",
			[1056] = "Frost Ward",
			[1060] = "Garment of Skorn",
			[1049] = "Toxique N5",
			[1045] = "Ghostlamp",
			[1043] = "Shamanic Brooch",
			[1040] = "Omega Stone",
			[1044] = "Idol of Gluttony",
			[1048] = "Eau de Berserk",
			[1052] = "Corrupted Fang",
			[1038] = "Angerhorn Impaler",
			[1037] = "Sinister Sigil",
			[1034] = "Emergencial Campfire",
			[1033] = "Bear Trap",
			[2500] = "Dawn's Apotheosis",
			[2504] = "Celestial Barrage",
			[1011] = "Coal Goblin Gadget",
			[1013] = "Phosphorescent Shell",
			[1003] = "Health Potion",
			[1001] = "Slow Mending Potion",
			[1006] = "Regrowth Stone",
			[1028] = "Agent Medallion",
			[1019] = "Stepping Fuel",
			[1021] = "Bag of Caltrops",
			[1023] = "Hidden Blade",
			[1017] = "Duelist's Honor",
			[1025] = "Ships Glue Leftovers",
			[1026] = "Suspicious Milk",
			[1027] = "Musty Liquid",
			[1029] = "Dawn Bomb",
			[1030] = "Bloody Binding Stone",
			[1066] = "Golden Fleece",
			[1067] = "Slippery Sole",
			[1070] = "Titan's Antler",
			[1055] = "Toadish Cloak",
			[1051] = "Hypnotizing Stone",
			[1047] = "Eldritch Crow Mask",
			[1041] = "Torment Configuration",
			[1039] = "Goblin Bombs",
			[1035] = "Icedrop Solution",
			[1031] = "Iron Handcuffs",
			[1071] = "Everfilling Concoction",
			[1015] = "Javelin Quiver",
			[2501] = "Reaper's Eclipse",
			[2503] = "Eternal Retribution",
			[1009] = "Iron Blood Potion",
			[1069] = "Blessed Ironwood Stake",
			[1065] = "Saint Alsek's Cloak",
			[1063] = "Arrowcaller Horn",
			[1059] = "Bracelet of Skorn",
			[2505] = "Chaos Chains",
			[2507] = "Eye of the Storm",
			[2502] = "Cataclysm",
			[2506] = "Witch's Call",
			[1004] = "Vial Of Poison",
			[1007] = "Bag of Surprises",
			[1000] = "Friendship Amulet",
			[1002] = "Mana Potion",
			[1020] = "Aegis Rune",
			[1022] = "Emergency Blockage",
			[1016] = "Crystal of the Dawn",
			[1018] = "Exotic Incense",
			[1012] = "Venomous Goblin Gadget",
			[1014] = "Poisonpetal Seeds",
			[1008] = "Twilight Lamp",
			[1010] = "Mending Potion",
			[1054] = "Dunewalker Cloak",
			[1050] = "Dendrion's Memento",
			[1046] = "The Grim Smile",
			[1042] = "Ratoxin Bomb",
			[1036] = "Mysticap Fetish",
			[1032] = "Living Branches",
			[1024] = "Goblin Contraption",
			[1068] = "Blazing Stoneheart",
			[1064] = "Withered Demon Hand",
			[1062] = "Golden Maw",
			[1058] = "Reflective Carapace"
		},
		[AbilityBarCategoryCrafting] = {
			"Apprentice Synthesis",
			"Expert Synthesis",
			"Master Synthesis",
			"Artisan Synthesis",
			"Smither's Synthesis",
			"Apprentice Shine",
			"Expert Shine",
			"Master Shine",
			"Artisan Shine",
			"Carpenter's Shine",
			"Apprentice Touch",
			"Expert Touch",
			"Master Touch",
			"Artisan Touch",
			"Precision Touch",
			"Apprentice Mend",
			"Expert Mend",
			"Master Mend",
			"Artisan Mend",
			"Focused Mend",
			"New Tools",
			"Steady Hand",
			"Firm Grip",
			"Touch of Salt",
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			"Distill",
			"Stabilize Mixture"
		},
		[AbilityBarCategoryFishing] = {
			[50008] = "Loosen Line",
			[50007] = "Fishing Basket",
			[50009] = "Reinforced Nets",
			[50006] = "Master Reel",
			[50010] = "Sharp Harpoon",
			[50005] = "Harpoon",
			[50004] = "Expert Reel",
			[50003] = "Fishing Nets",
			[50002] = "Big Reel",
			[50001] = "Give Slack",
			[50000] = "Basic Reel"
		},
		[2657] = {
			name = "Rust Cannon",
			id = 81,
			description = ""
		},
		[5125] = {
			name = "Rust Cannon",
			id = 81,
			description = ""
		},
		[1795] = {
			name = "Small Cannon",
			id = 140,
			description = ""
		},
		[1798] = {
			name = "Small Cannon",
			id = 140,
			description = ""
		},
		[1801] = {
			name = "Small Cannon",
			id = 140,
			description = ""
		},
		[1796] = {
			name = "Medium Cannon",
			id = 141,
			description = ""
		},
		[1799] = {
			name = "Medium Cannon",
			id = 141,
			description = ""
		},
		[1802] = {
			name = "Medium Cannon",
			id = 141,
			description = ""
		},
		[1797] = {
			name = "Large Cannon",
			id = 142,
			description = ""
		},
		[1800] = {
			name = "Large Cannon",
			id = 142,
			description = ""
		},
		[1803] = {
			name = "Large Cannon",
			id = 142,
			description = ""
		},
		[1822] = {
			name = "Basic Water Pumps",
			id = 93,
			description = ""
		},
		[1823] = {
			name = "Efficient Water Pumps",
			id = 94,
			description = ""
		},
		[1824] = {
			name = "Advanced Water Pumps",
			id = 95,
			description = ""
		},
		[5805] = {
			name = "Superior Water Pumps",
			id = 117,
			description = ""
		},
		[5806] = {
			name = "Royal Water Pumps",
			id = 118,
			description = ""
		},
		[2848] = {
			name = "Small Siege Cannon",
			id = 92,
			description = ""
		},
		[5781] = {
			name = "Small Shrapnel Cannon",
			id = 139,
			description = ""
		},
		[5780] = {
			name = "Small Hullbreaker Cannon",
			id = 115,
			description = ""
		},
		[5477] = {
			name = "Small Drake Head",
			id = 116,
			description = ""
		},
		[5782] = {
			name = "Small Mortar Cannon",
			id = 138,
			description = ""
		},
		[5483] = {
			name = "Small Broadside Artillery",
			id = 129,
			description = ""
		},
		[5815] = {
			name = "Medium Siege Cannon",
			id = 119,
			description = ""
		},
		[5797] = {
			name = "Medium Shrapnel Cannon",
			id = 120,
			description = ""
		},
		[5795] = {
			name = "Medium Hullbreaker Cannon",
			id = 121,
			description = ""
		},
		[5817] = {
			name = "Medium Drake Head",
			id = 122,
			description = ""
		},
		[5799] = {
			name = "Medium Mortar Cannon",
			id = 123,
			description = ""
		},
		[5819] = {
			name = "Medium Broadside Artillery",
			id = 130,
			description = ""
		},
		[5816] = {
			name = "Large Siege Cannon",
			id = 124,
			description = ""
		},
		[5798] = {
			name = "Large Shrapnel Cannon",
			id = 125,
			description = ""
		},
		[5796] = {
			name = "Large Hullbreaker Cannon",
			id = 126,
			description = ""
		},
		[5818] = {
			name = "Large Drake Head",
			id = 127,
			description = ""
		},
		[5800] = {
			name = "Large Mortar Cannon",
			id = 128,
			description = ""
		},
		[5820] = {
			name = "Large Broadside Artillery",
			id = 131,
			description = ""
		},
		[5480] = {
			name = "Small Floating Mines",
			id = 135,
			description = ""
		},
		[5481] = {
			name = "Small Grappling Hooks",
			id = 132,
			description = ""
		},
		[5801] = {
			name = "Medium Floating Mines",
			id = 136,
			description = ""
		},
		[5803] = {
			name = "Medium Grappling Hooks",
			id = 133,
			description = ""
		},
		[5802] = {
			name = "Large Floating Mines",
			id = 137,
			description = ""
		},
		[5804] = {
			name = "Large Grappling Hooks",
			id = 134,
			description = ""
		},
		[1805] = {
			name = "Small Hull Mend",
			id = 143,
			description = ""
		},
		[5779] = {
			name = "Medium Hull Mend",
			id = 144,
			description = ""
		},
		[5124] = {
			name = "Basic Sail",
			id = 145,
			description = ""
		},
		[1813] = {
			name = "Small Sail",
			id = 146,
			description = ""
		},
		[1814] = {
			name = "Medium Sail",
			id = 147,
			description = ""
		},
		[1815] = {
			name = "Large Sail",
			id = 148,
			description = ""
		},
		[5482] = {
			name = "Merchant Sail",
			id = 149,
			description = ""
		},
		[5487] = {
			name = "Sturdy Sail",
			id = 150,
			description = ""
		},
		[5484] = {
			name = "Pirate Sail",
			id = 151,
			description = ""
		},
		[1819] = {
			name = "Simple Ship Emblems",
			id = 152,
			description = ""
		},
		[1820] = {
			name = "Shiny Ship Emblems",
			id = 153,
			description = ""
		},
		[1821] = {
			name = "Adorned Ship Emblems",
			id = 154,
			description = ""
		},
		[5479] = {
			name = "Deluxe Ship Emblems",
			id = 155,
			description = ""
		},
		[5478] = {
			name = "Graceful Ship Emblems",
			id = 156,
			description = ""
		},
		[1810] = {
			name = "Small Tradepack Container",
			id = 157,
			description = ""
		},
		[1811] = {
			name = "Medium Tradepack Container",
			id = 158,
			description = ""
		},
		[AbilityBarCategoryShip] = {
			[96] = "Repair",
			[131] = "Large Broadside Artillery",
			[81] = "Rust Cannon",
			[130] = "Medium Broadside Artillery",
			[129] = "Small Broadside Artillery",
			[128] = "Large Mortar Cannon",
			[119] = "Medium Siege Cannon",
			[143] = "Small Hull Mend",
			[142] = "Large Cannon",
			[118] = "Royal Water Pumps",
			[141] = "Medium Cannon",
			[140] = "Small Cannon",
			[117] = "Superior Water Pumps",
			[139] = "Small Shrapnel Cannon",
			[138] = "Small Mortar Cannon",
			[116] = "Small Drake Head",
			[137] = "Large Floating Mines",
			[136] = "Medium Floating Mines",
			[152] = "Simple Ship Emblems",
			[123] = "Medium Mortar Cannon",
			[153] = "Shiny Ship Emblems",
			[154] = "Adorned Ship Emblems",
			[122] = "Medium Drake Head",
			[155] = "Deluxe Ship Emblems",
			[156] = "Graceful Ship Emblems",
			[121] = "Medium Hullbreaker Cannon",
			[157] = "Small Tradepack Container",
			[158] = "Medium Tradepack Container",
			[120] = "Medium Shrapnel Cannon",
			[94] = "Efficient Water Pumps",
			[144] = "Medium Hull Mend",
			[127] = "Large Drake Head",
			[145] = "Basic Sail",
			[95] = "Advanced Water Pumps",
			[146] = "Small Sail",
			[126] = "Large Hullbreaker Cannon",
			[147] = "Medium Sail",
			[92] = "Small Siege Cannon",
			[148] = "Large Sail",
			[125] = "Large Shrapnel Cannon",
			[149] = "Merchant Sail",
			[93] = "Basic Water Pumps",
			[150] = "Sturdy Sail",
			[124] = "Large Siege Cannon",
			[151] = "Pirate Sail",
			[115] = "Small Hullbreaker Cannon",
			[135] = "Small Floating Mines",
			[134] = "Large Grappling Hooks",
			[133] = "Medium Grappling Hooks",
			[132] = "Small Grappling Hooks"
		},
		[AbilityBarCategoryWeaponSkill] = {
			[1553] = "Warforged Power Surge",
			[1551] = "Warforged Fencer's Escape",
			[1502] = "Blade Warding",
			[1509] = "Mace Toss",
			[1508] = "Whirl Slash",
			[1501] = "Fencer's Escape",
			[1552] = "Warforged Blade Warding",
			[1503] = "Power Surge",
			[1505] = "Mana Overcharge",
			[1500] = "Lethal Edge",
			[1506] = "Steady Stance",
			[1507] = "Rending Throw",
			[1555] = "Warforged Mana Overcharge",
			[1557] = "Warforged Rending Throw",
			[1550] = "Warforged Lethal Edge",
			[1558] = "Warforged Whirl Slash",
			[1559] = "Warforged Mace Toss",
			[1560] = "Warforged Mighty Smash",
			[1556] = "Warforged Steady Stance",
			[1554] = "Warforged Magic Ward",
			[1504] = "Magic Ward",
			[1510] = "Mighty Smash"
		},
		[AbilityBarCategoryMount] = {
			[1607] = "Stampede T2",
			[1602] = "Dash T3",
			[1605] = "Sprint T3",
			[1606] = "Stampede T1",
			[1601] = "Dash T2",
			[1600] = "Dash T1",
			[1603] = "Sprint T1",
			[1604] = "Sprint T2",
			[1609] = "Charge T1",
			[1610] = "Charge T2",
			[1611] = "Charge T3",
			[1608] = "Stampede T3"
		},
		[AbilityBarCategoryMountSkillWidget] = {
			[65535] = "Mount"
		}
	},
	numBarsVisible = {
		[AbilityBarCategoryNone] = 0,
		[AbilityBarCategorySpell] = 1,
		[AbilityBarCategoryCrafting] = 1,
		[AbilityBarCategoryFishing] = 2,
		[AbilityBarCategoryShip] = 2,
		[AbilityBarCategoryMount] = 1
	},
	state = AbilityBarCategoryNone,
	meleeAbilityQueue = {}
}
AbilityBar.assets[AbilityBarCategoryAetherRiftBuild] = AbilityBar.assets[AbilityBarCategorySpell]

local function sendOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.AbilityBar, g_game.serializeTable(data))
	end
end

local function toggleMount()
	local player = g_game.getLocalPlayer()

	if player:isChanneling() then
		return
	end

	if not player:isMounted() then
		modules.game_interface.sendOpcode(ExtendedIds.Mount, {
			action = "on"
		})
	elseif not player:isWagonToggled() then
		modules.game_interface.sendOpcode(ExtendedIds.Mount, {
			action = "off"
		})
	end
end

function AbilityBar.setSpellBatchingInterval(interval)
	AbilityBar.spellBatchTime = interval
end

function AbilityBar.init()
	g_ui.importStyle("abilitybar")
	ProtocolGame.registerExtendedOpcode(ExtendedIds.AbilityBar, AbilityBar.onExtendedOpcode)

	local numBars = AbilityBar.numSlots / AbilityBar.numSlotsPerBar

	for i = AbilityBarCategoryFirst, AbilityBarCategoryLast do
		AbilityBar.bars[i] = {}
		AbilityBar.barWidgets[i] = {}

		if i == AbilityBarCategoryWeaponSkill or i == AbilityBarCategoryMount or i == AbilityBarCategoryMountSkillWidget then
			AbilityBar.createBar(i, 1)
		else
			for j = 1, numBars do
				AbilityBar.createBar(i, j)
			end
		end
	end

	AbilityBar.setDefaultState()
	AbilityBar.setupHotkeys()
	connect(LocalPlayer, {
		onShipChange = AbilityBar.onShipChange,
		onPositionChange = AbilityBar.onPositionChange,
		onOutfitChange = AbilityBar.onOutfitChange,
		onTargetChange = AbilityBar.onTargetChange,
		onManaChange = AbilityBar.onManaChange
	})
	connect(g_game, {
		onGameStart = AbilityBar.online,
		onGameEnd = AbilityBar.hide,
		onSpellCooldown = AbilityBar.onSpellCooldown,
		onMultiUseCooldown = AbilityBar.onMultiUseCooldown,
		canUseAbility = AbilityBar.canUseAbility
	}, true)
	connect(GameHotkeyManager, {
		onHotkeyUpdate = AbilityBar.onHotkeyUpdate
	})
	connect(Container, {
		onOpen = AbilityBar.refreshOwnedItems,
		onRemoveItem = AbilityBar.refreshOwnedItems,
		onUpdateItem = AbilityBar.refreshOwnedItems,
		onAddItem = AbilityBar.refreshOwnedItems
	})

	if BGS_DEMO then
		AbilityBar.prepareBGSDemo()
	end

	protocol.initProtocol()

	if cacheLoadingEnabled and g_game.isOnline() then
		g_layout.loadAbilityBars()
		g_layout.loadWeaponSkillBar()
		g_layout.loadMountToggleWidget()
		addEvent(function()
			AbilityBar.loadFromCache()
		end)
	end
end

function AbilityBar.terminate()
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.AbilityBar)

	for barType, bars in pairs(AbilityBar.bars) do
		for _, bar in ipairs(bars) do
			if bar.widget then
				bar.widget:destroy()

				bar.widget = nil
			end
		end

		AbilityBar.bars[barType] = {}
	end

	for category, bars in pairs(AbilityBar.barWidgets) do
		for _, bar in pairs(bars) do
			bar:destroy()
		end

		AbilityBar.barWidgets[category] = {}
	end

	AbilityBar.weaponSkillWidget = nil
	AbilityBar.mountSkillWidget = nil

	disconnect(LocalPlayer, {
		onShipChange = AbilityBar.onShipChange,
		onPositionChange = AbilityBar.onPositionChange,
		onOutfitChange = AbilityBar.onOutfitChange,
		onTargetChange = AbilityBar.onTargetChange,
		onManaChange = AbilityBar.onManaChange
	})
	disconnect(g_game, {
		onGameStart = AbilityBar.online,
		onGameEnd = AbilityBar.offline,
		onSpellCooldown = AbilityBar.onSpellCooldown,
		onMultiUseCooldown = AbilityBar.onMultiUseCooldown,
		canUseAbility = AbilityBar.canUseAbility
	}, true)
	disconnect(Container, {
		onOpen = AbilityBar.refreshOwnedItems,
		onRemoveItem = AbilityBar.refreshOwnedItems,
		onUpdateItem = AbilityBar.refreshOwnedItems,
		onAddItem = AbilityBar.refreshOwnedItems
	})
	disconnect(GameHotkeyManager, {
		onHotkeyUpdate = AbilityBar.onHotkeyUpdate
	})

	if AbilityBar.positionStateEvent then
		removeEvent(AbilityBar.positionStateEvent)

		AbilityBar.positionStateEvent = nil
	end

	if AbilityBar.startDragEvent then
		removeEvent(AbilityBar.startDragEvent)

		AbilityBar.startDragEvent = nil
	end

	AbilityBar.resetMeleeQueue()
	protocol.terminateProtocol()
end

function AbilityBar.loadFromCache()
	if not g_game.isOnline() then
		return
	end

	local abilityBarCache = AbilityBar.getCache()

	if abilityBarCache.bars then
		for category, barCache in pairs(abilityBarCache.bars) do
			AbilityBar.fetchCategory(category, barCache)
		end
	end

	if abilityBarCache.numBarsVisible then
		for category, numBarsVisible in pairs(abilityBarCache.numBarsVisible) do
			AbilityBar.setNumBarsVisible(category, numBarsVisible)
		end
	end
end

function AbilityBar.online()
	AbilityBar.customGlobalCooldownAbilities = {}

	sendOpcode({
		action = "refresh",
		category = AbilityBar.state
	})
	addEvent(function()
		local player = g_game.getLocalPlayer()

		if player then
			AbilityBar.onOutfitChange(nil, player:getOutfit())
		end
	end)
end

function AbilityBar.show()
	AbilityBar.setDefaultState()
end

function AbilityBar.hide()
	for category, bars in pairs(AbilityBar.barWidgets) do
		for i, bar in pairs(bars) do
			bar:hide()
		end
	end
end

function AbilityBar.updateInterfaceHideElements(value)
	for _, bars in pairs(AbilityBar.barWidgets) do
		modules.game_menu.Menu.hideWindows(bars)
	end

	AbilityBar.setState(AbilityBar.state, true)
end

function AbilityBar.startClickResponseAnimation(widget, dontCancel)
	local parent = widget:getParent()

	if not parent then
		return
	end

	local clickResponseWidget = parent.clickResponse

	if not clickResponseWidget then
		return
	end

	if not dontCancel then
		g_effects.cancelFade(clickResponseWidget)
	elseif g_effects.hasFadeEvent(clickResponseWidget) then
		return
	end

	clickResponseWidget:setOpacity(1)
	g_effects.fadeOut(clickResponseWidget, 100, nil, false)
end

function AbilityBar.createBar(category, barIndex, vertical)
	local widget
	local numSlotsPerBar = AbilityBar.numSlotsPerBar

	if category == AbilityBarCategoryWeaponSkill then
		numSlotsPerBar = 1
		widget = g_ui.createWidget("WeaponSkillBar", modules.game_interface.getHUDPanel())
		AbilityBar.weaponSkillWidget = widget
	elseif category == AbilityBarCategoryMountSkillWidget then
		numSlotsPerBar = 1
		widget = g_ui.createWidget("MountSkillWidget", modules.game_interface.getHUDPanel())
		AbilityBar.mountSkillWidget = widget
	else
		widget = g_ui.createWidget(vertical and "AbilityBarVertical" or "AbilityBar", modules.game_interface.getHUDPanel())
	end

	if category == AbilityBarCategoryMount then
		AbilityBar.mountBarWidget = widget
	end

	widget:setId(string.format("barWidget_%d_%d", category, barIndex))

	widget.category = category
	widget.barIndex = barIndex
	widget.vertical = vertical == true
	AbilityBar.barWidgets[category][barIndex] = widget

	if category == AbilityBarCategoryFishing then
		widget:recursiveGetChildById("lockButton"):hide()
	end

	function widget:onDragMove(mousePos, mouseMoved)
		local pos = {
			x = mousePos.x - self.movingReference.x,
			y = mousePos.y - self.movingReference.y
		}

		g_layout.snapToGrid(pos)
		self:setPosition(pos)
		self:bindRectToParent()
	end

	if category ~= AbilityBarCategoryMount and category ~= AbilityBarCategoryMountSkillWidget and category ~= AbilityBarCategoryWeaponSkill then
		function widget:onPositionChange(position)
			for category in pairs(AbilityBar.barWidgets) do
				if category ~= AbilityBarCategoryWeaponSkill and category ~= AbilityBarCategoryMount and category ~= AbilityBarCategoryMountSkillWidget then
					local bar = AbilityBar.barWidgets[category][self.barIndex]

					if bar and not Position.equals(bar:getPosition(), position) then
						bar:setPosition(position)
						bar:bindRectToParent()
					end
				end
			end
		end
	end

	function widget:onDragEnter(mousePos)
		if not g_layout.isEditMode() then
			return false
		end

		self:breakAnchors()

		self.movingReference = {
			x = mousePos.x - self:getX(),
			y = mousePos.y - self:getY()
		}

		return true
	end

	for i = 1, numSlotsPerBar do
		local slot = widget:recursiveGetChildById("slot" .. tostring(i))
		local icon = slot:recursiveGetChildById("icon")
		local absoluteSlotIndex = AbilityBar.getAbsoluteSlotIndex(barIndex, i)

		function icon:onClick(mousePos)
			local slot, slotWidget = AbilityBar.getSlotByPosition(mousePos, category)
			local ability = AbilityBar.getAbilityId(category, absoluteSlotIndex)

			if slot then
				AbilityBar.onPreUseAbility(ability, slot, slotWidget, absoluteSlotIndex, category)

				if ability ~= 0 then
					AbilityBar.startClickResponseAnimation(icon)

					local isFreeRecast = freeRecastAbilities[ability] and AbilityBar.hasOverlayGlowBySlotIndex(category, absoluteSlotIndex)
					local isSpellCategory = category == AbilityBarCategorySpell or category == AbilityBarCategoryShip

					if isSpellCategory and not g_spells:canCastSpell(ability, isFreeRecast) then
						return false
					end

					local progress = slotWidget:recursiveGetChildById("progressRect")

					if (not progress or progress and not progress.event or slot.charges > 1 and not AbilityBar.isSpellChargeOnCooldown(ability, slot.charges)) and (not isSpellCategory or not modules.game_interface.handleCrosshair(ability)) then
						g_game.useAbility(category, absoluteSlotIndex)
					end
				elseif slot.clientId then
					AbilityBar.startClickResponseAnimation(icon)
					g_game.useInventoryItem(slot.clientId)
				end
			elseif category == AbilityBarCategoryMountSkillWidget then
				toggleMount()
				AbilityBar.startClickResponseAnimation(icon)
			end
		end

		slot.category = category
		slot.index = absoluteSlotIndex

		if category ~= AbilityBarCategoryWeaponSkill and category ~= AbilityBarCategoryMountSkillWidget then
			connect(icon, {
				onDragEnter = function(self, mousePos)
					if self.draggingLock and self.draggingLock - g_clock.millis() > 0 then
						return false
					end

					if not self:isVisible() or icon.abilityId == 0 then
						return false
					end

					local parentWidget = self:getParent():getParent():getParent()

					if parentWidget.locked or parentWidget.category == AbilityBarCategoryFishing or parentWidget.category == AbilityBarCategoryMount then
						return false
					end

					self.previousParent = self:getParent()

					modules.game_interface.getRootPanel():addChild(self)

					local oldPos = self:getPosition()

					self.movingReference = {
						x = mousePos.x - oldPos.x,
						y = mousePos.y - oldPos.y
					}

					self:setPosition(oldPos)
					self:breakAnchors()

					self.startMousePos = mousePos

					if self.startDragEvent then
						self.startDragEvent:cancel()

						self.startDragEvent = nil
					end

					self.startDragEvent = scheduleEvent(function()
						self.startDragEvent = nil
					end, 100)

					return true
				end,
				onDragLeave = function(self, droppedWidget, mousePos)
					self.previousParent:insertChild(1, self)
					self:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
					self:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
					self:setImageOffsetX(self.previousParent:getParent():getParent().vertical and 5 or 2)
					self:setImageOffsetY(self.previousParent:getParent():getParent().vertical and 1 or 0)

					local slot, slotWidget = AbilityBar.getSlot(category, absoluteSlotIndex)
					local newSlot, newSlotWidget = AbilityBar.getSlotByPosition(mousePos, category)
					local lock = false

					if newSlotWidget then
						if not newSlotWidget:isVisible() then
							newSlot = nil
						elseif slot.category and slot.category == AbilityBarCategoryMount then
							if newSlot.abilityId == 0 then
								newSlot = nil
							elseif not newSlotWidget or not newSlot.category or newSlot.category ~= AbilityBarCategoryMount then
								lock = true
							end
						end
					end

					if lock then
						return
					end

					if self.startMousePos or self.startDragEvent then
						return
					end

					if not newSlot then
						self:setVisible(false)
						self:setImageSource("")
						sendOpcode({
							action = "remove",
							category = slot.category,
							index = slot.index
						})
						signalcall(AbilityBar.onRemoveAbility, AbilityBar, slot.category, slot.index)

						return
					end

					AbilityBar.switchAbilities(slot, slotWidget, newSlot, newSlotWidget)
				end,
				onDragMove = function(self, mousePos, mouseMoved)
					if self.startDragEvent then
						return false
					end

					if self.startMousePos and Position.distance(self.startMousePos, mousePos) < 35 then
						return false
					end

					self.startMousePos = nil
					self.startDragEvent = nil

					local pos = {
						x = mousePos.x - self.movingReference.x,
						y = mousePos.y - self.movingReference.y
					}

					self:setPosition(pos)

					return true
				end
			})
		end
	end

	AbilityBar.updateInterfaceHideElements()
	AbilityBar.updateBarHotkeys(category, barIndex)

	return widget
end

function AbilityBar.onPreUseAbility(ability, slot, slotWidget, index, category)
	local player = g_game.getLocalPlayer()

	if not player or player:isInShip() then
		return
	end

	if slot and slot.abilityId then
		local range = slot.range and slot.range() or -1

		if range == 1 and slot.aggressive and slot.needTarget and not slot.selfTarget and player:getTargetCreature() and modules.game_settings.getOption("meleeAbilityQueue") then
			local progressRect = slotWidget:recursiveGetChildById("progressRect")
			local canQueueMelee = slotWidget and slotWidget.icon and not slotWidget.icon:isOn() or not progressRect or progressRect:isExplicitlyVisible()

			if canQueueMelee then
				AbilityBar.resetMeleeQueue()

				local queuedAbility = AbilityBar.meleeAbilityQueue

				queuedAbility.id = slot.abilityId

				function queuedAbility.condition(player, target)
					return player and target and Position.isInRange(player:getPosition(), target:getPosition(), 1, 1)
				end

				queuedAbility.timeoutEvent = scheduleEvent(function()
					AbilityBar.resetMeleeQueue()
				end, 10000)

				local barWidget = AbilityBar.getBarWidgetBySlotIndex(category, index)

				if barWidget then
					local overlay = slotWidget and barWidget:recursiveGetChildById(slotWidget:getId() .. "overlay")

					if overlay then
						local overlayQueued = overlay:getChildById("overlayQueued")

						g_effects.startFadeInOut(overlayQueued, 0, 100, 0.05, false, 0.6)
						overlayQueued:setVisible(true)
					end
				end

				queuedAbility.event = cycleEvent(function()
					AbilityBar.checkMeleeAttackQueue(player)
				end, 50, true)
			end
		end
	end
end

function AbilityBar.getAbilityId(category, absoluteSlotIndex)
	return AbilityBar.bars[category] and AbilityBar.bars[category][absoluteSlotIndex] and AbilityBar.bars[category][absoluteSlotIndex].abilityId or 0
end

function AbilityBar.getSlot(category, absoluteSlotIndex)
	if not category or not absoluteSlotIndex then
		return nil
	end

	local slot = AbilityBar.bars[category][absoluteSlotIndex]
	local index = AbilityBar.getBarSlotIndex(absoluteSlotIndex)
	local widgetBar = AbilityBar.getBarWidgetBySlotIndex(category, absoluteSlotIndex)
	local widget = widgetBar and widgetBar:recursiveGetChildById("slot" .. tostring(index)) or nil

	return slot, widget
end

function AbilityBar.getSlotByPosition(mousePos, category)
	for tmpCategory, bar in pairs(AbilityBar.bars) do
		if not category or tmpCategory == category then
			for i, slot in ipairs(bar) do
				local barWidget = AbilityBar.getBarWidgetBySlotIndex(tmpCategory, i)

				if barWidget then
					local slotWidget = barWidget:recursiveGetChildById("slot" .. tostring(AbilityBar.getBarSlotIndex(i)))
					local slotPosition = slotWidget:getPosition()

					if mousePos.x >= slotPosition.x and mousePos.x <= slotPosition.x + slotWidget:getWidth() and mousePos.y >= slotPosition.y and mousePos.y <= slotPosition.y + slotWidget:getHeight() then
						return slot, slotWidget
					end
				end
			end
		end
	end
end

function AbilityBar.getAbsoluteSlotIndex(barIndex, slotIndex)
	return (barIndex - 1) * AbilityBar.numSlotsPerBar + slotIndex
end

function AbilityBar.getBarSlotIndex(absoluteSlotIndex)
	local index = absoluteSlotIndex % AbilityBar.numSlotsPerBar

	if index == 0 then
		index = AbilityBar.numSlotsPerBar
	end

	return index
end

function AbilityBar.getBarWidgetBySlotIndex(category, absoluteSlotIndex)
	local barIndex = math.ceil(absoluteSlotIndex / AbilityBar.numSlotsPerBar)

	return AbilityBar.barWidgets[category][barIndex]
end

function AbilityBar.getAsset(category, abilityId, clientId, slotName)
	local assetName

	if clientId and slotName then
		assetName = assetPrefix .. slotName:lower()
	else
		assetName = AbilityBar.assets[category][abilityId]
		assetName = assetName and assetPrefix .. assetName:lower()
	end

	return assetName
end

function AbilityBar.getSlotByAbilityId(category, abilityId)
	for tmpCategory, bar in pairs(AbilityBar.bars) do
		if not category or tmpCategory == category then
			for i, slot in ipairs(bar) do
				local barWidget = AbilityBar.getBarWidgetBySlotIndex(tmpCategory, i)

				if barWidget then
					local slotWidget = barWidget:recursiveGetChildById("slot" .. tostring(AbilityBar.getBarSlotIndex(i)))

					if slot.abilityId == abilityId then
						return slot, slotWidget
					end
				end
			end
		end
	end
end

function AbilityBar.getSlotByName(category, name)
	for tmpCategory, bar in pairs(AbilityBar.bars) do
		if not category or tmpCategory == category then
			for i, slot in ipairs(bar) do
				local barWidget = AbilityBar.getBarWidgetBySlotIndex(tmpCategory, i)

				if barWidget then
					local slotWidget = barWidget:recursiveGetChildById("slot" .. tostring(AbilityBar.getBarSlotIndex(i)))

					if slot.name:lower() == name:lower() then
						return slot, slotWidget
					end
				end
			end
		end
	end
end

function AbilityBar.getFirstOccupiedSlot(category)
	for tmpCategory, bar in pairs(AbilityBar.bars) do
		if not category or tmpCategory == category then
			for i, slot in ipairs(bar) do
				local barWidget = AbilityBar.getBarWidgetBySlotIndex(tmpCategory, i)

				if barWidget then
					local slotWidget = barWidget:recursiveGetChildById("slot" .. tostring(AbilityBar.getBarSlotIndex(i)))

					if slot.abilityId ~= 0 then
						return slot, slotWidget
					end
				end
			end
		end
	end
end

function AbilityBar.getSecondOccupiedSlot(category)
	local total = 0

	for tmpCategory, bar in pairs(AbilityBar.bars) do
		if not category or tmpCategory == category then
			for i, slot in ipairs(bar) do
				local barWidget = AbilityBar.getBarWidgetBySlotIndex(tmpCategory, i)

				if barWidget then
					local slotWidget = barWidget:recursiveGetChildById("slot" .. tostring(AbilityBar.getBarSlotIndex(i)))

					if slot.abilityId ~= 0 then
						total = total + 1

						if total == 2 then
							return slot, slotWidget
						end
					end
				end
			end
		end
	end
end

function AbilityBar.hasOverlayGlowBySlotIndex(category, absoluteSlotIndex)
	local slot, slotWidget = AbilityBar.getSlot(category, absoluteSlotIndex)
	local barWidget = AbilityBar.getBarWidgetBySlotIndex(category, absoluteSlotIndex)
	local overlay = slotWidget and barWidget:recursiveGetChildById(slotWidget:getId() .. "overlay")

	return overlay and overlay:getChildById("overlayGlow"):isVisible() or false
end

function AbilityBar.onExtendedOpcode(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.AbilityBar or buffer == "" then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		return
	end

	if data.action == "fetch_category" then
		AbilityBar.fetchCategory(data.category, data.bar, data.forceChangeCategory)

		if cacheLoadingEnabled then
			AbilityBar.putCache("bars", table.recursivecopy(data.bar), data.category)
		end
	end
end

function AbilityBar.getCache()
	local cache = _G.__ABILITYBAR_CACHE or {}

	_G.__ABILITYBAR_CACHE = cache

	return cache
end

function AbilityBar.putCache(key, data, insertKey)
	local cache = AbilityBar.getCache()
	local cacheValue = cache[key]

	if insertKey then
		if not cacheValue then
			cacheValue = {}
			cache[key] = cacheValue
		end

		if type(cacheValue) == "table" then
			cacheValue[insertKey] = data
		else
			print("[ERROR] AbilityBar.putCache: cache value is not a table")
		end
	else
		cache[key] = data or AbilityBar[key]
	end

	return cache
end

function AbilityBar.clearCache(key, resetValue)
	local cache = AbilityBar.getCache()

	cache[key] = resetValue

	return cache
end

function AbilityBar.fetchCategory(category, bar, forceChangeCategory)
	local clientBar = AbilityBar.bars[category]

	if not clientBar then
		print("[ERROR] AbilityBar.onExtendedOpcode: category not found:", category)

		return
	end

	for i, slot in pairs(bar) do
		if not clientBar[i] then
			clientBar[i] = {}
		end

		clientBar[i].category = category
		clientBar[i].index = i
		clientBar[i].abilityId = slot.abilityId
		clientBar[i].name = slot.name
		clientBar[i].card = slot.card
		clientBar[i].clientId = slot.clientId
		clientBar[i].itemId = slot.itemId
		clientBar[i].charges = slot.charges or 1

		if slot.abilityId then
			local spell = g_spells:getSpell(slot.abilityId)
			local isLegacyAbility = slot.name and g_spells:isLegacyAbility(slot.name:lower())

			clientBar[i].range = function()
				local player = g_game.getLocalPlayer()

				return player and spell and player:getSpellRange(spell) or -1
			end
			clientBar[i].cost = spell and spell.cost or {}
			clientBar[i].abilityTier = slot.abilityTier and (isLegacyAbility and slot.abilityTier or slot.abilityTier + 1) or spell and spell.points and 1 or nil
			clientBar[i].needTarget = spell and spell.needTarget
			clientBar[i].aggressive = spell and spell.aggressive
			clientBar[i].selfTarget = spell and spell.selfTarget
			AbilityBar.spellCharges[slot.abilityId] = nil

			for chargeId = 1, clientBar[i].charges do
				AbilityBar.setChargeCooldown(slot.abilityId, 0, chargeId)
			end
		end

		if clientBar[i].abilityId ~= 0 or clientBar[i].itemId then
			AbilityBar.setupIcon(clientBar[i])
		else
			AbilityBar.removeIcon(clientBar[i])
		end
	end

	AbilityBar.mountSkillWidget:recursiveGetChildById("slot1overlay"):setOn(true)

	if forceChangeCategory then
		AbilityBar.setState(category, true)
	end
end

function AbilityBar.setupIcon(slot)
	local barWidget = AbilityBar.getBarWidgetBySlotIndex(slot.category, slot.index)
	local slotBarIndex = AbilityBar.getBarSlotIndex(slot.index)
	local asset = AbilityBar.getAsset(slot.category, slot.abilityId, slot.clientId, slot.name) or ""
	local slotWidget = barWidget:recursiveGetChildById("slot" .. tostring(slotBarIndex))
	local icon = slotWidget:recursiveGetChildById("icon")
	local overlay = slotWidget and barWidget:recursiveGetChildById(slotWidget:getId() .. "overlay")

	slotWidget:recursiveGetChildById("progressRect"):reset()
	slotWidget:recursiveGetChildById("progressRect"):setCircle(true)
	icon:setImageSource(asset:lower())
	icon:show()

	if slotWidget.charges then
		if slot.charges > 1 and (slot.category == AbilityBarCategorySpell or slot.category == AbilityBarCategoryShip) then
			slotWidget.charges:setText(AbilityBar.getAvailableSpellCharges(slot.abilityId))
			slotWidget.charges:show()
		else
			slotWidget.charges:hide()
		end
	end

	icon.isAbilityBar = true
	icon.abilityTooltip = true

	if slot.category == AbilityBarCategorySpell or slot.category == AbilityBarCategoryMount or slot.category == AbilityBarCategoryAetherRiftBuild then
		icon.abilityId = slot.clientId or slot.abilityId
		icon.abilityTier = slot.abilityTier
	elseif slot.name then
		icon.abilityId = slot.name:lower()
	end

	overlay:setOn(true)

	if slot.category == AbilityBarCategoryWeaponSkill then
		overlay:setChecked(slot.abilityId and slot.abilityId >= 1550)
	end

	if slot.clientId and slot.clientId ~= 0 then
		overlay.itemCount:setText(g_game.getLocalPlayer():getItemsCount(slot.clientId))
	else
		overlay.itemCount:setText()
	end

	AbilityBar.checkSlotState(slot, slotWidget)
end

function AbilityBar.removeIcon(slot)
	local barWidget = AbilityBar.getBarWidgetBySlotIndex(slot.category, slot.index)

	if not barWidget then
		return
	end

	local slotBarIndex = AbilityBar.getBarSlotIndex(slot.index)
	local slotWidget = barWidget:recursiveGetChildById("slot" .. tostring(slotBarIndex))
	local overlay = slotWidget and barWidget:recursiveGetChildById(slotWidget:getId() .. "overlay")

	slotWidget:recursiveGetChildById("progressRect"):reset()
	slotWidget:recursiveGetChildById("icon"):hide()
	overlay:setOn(false)

	if slot.category == AbilityBarCategoryWeaponSkill then
		overlay:setChecked(false)
	end

	if slotWidget.charges then
		slotWidget.charges:hide()
	end

	overlay.itemCount:setText()
	AbilityBar.resetSlotState(slot, slotWidget)
end

function AbilityBar.switchAbilities(slot, slotWidget, newSlot, newSlotWidget)
	local icon = slotWidget:recursiveGetChildById("icon")
	local clickResponse = slotWidget:recursiveGetChildById("clickResponse")
	local newIcon = newSlotWidget:recursiveGetChildById("icon")
	local newClickResponse = newSlotWidget:recursiveGetChildById("clickResponse")
	local imageSource = icon:getImageSource()
	local newImageSource = newIcon:getImageSource()
	local progress = slotWidget:recursiveGetChildById("progressRect")
	local newProgress = newSlotWidget:recursiveGetChildById("progressRect")

	icon:setImageSource(newImageSource:lower())
	icon:setVisible(newIcon:isVisible())
	icon:raise()
	progress:raise()
	clickResponse:raise()
	newIcon:setImageSource(imageSource:lower())
	newIcon:setVisible(true)
	newIcon:raise()
	newProgress:raise()
	newClickResponse:raise()
	AbilityBar.resetSlotState(slot, slotWidget)
	AbilityBar.resetSlotState(newSlot, newSlotWidget)
	sendOpcode({
		action = "switch",
		category = slot.category,
		from = slot.index,
		to = newSlot.index
	})
end

function AbilityBar.addAbility(category, abilityId, position)
	local index

	if position then
		local slot = AbilityBar.getSlotByPosition(position)

		if not slot then
			return
		end

		index = slot.index
	end

	sendOpcode({
		action = "add",
		category = category,
		abilityId = abilityId,
		index = index
	})
end

function AbilityBar.addSpell(archetype, abilityId, position, isLegacy)
	local index

	if position then
		local slot = AbilityBar.getSlotByPosition(position)

		if not slot then
			return
		end

		index = slot.index
	end

	local category = AbilityBarCategorySpell

	if modules.game_spelltree.GameSpellTree:isShowingAetherRiftBuild() then
		category = AbilityBarCategoryAetherRiftBuild
	end

	sendOpcode({
		action = "add",
		category = category,
		abilityId = abilityId,
		archetype = archetype,
		index = index,
		isLegacy = isLegacy
	})
end

function AbilityBar.addCraftingAbility(abilityType, abilityId, position)
	local index

	if position then
		local slot = AbilityBar.getSlotByPosition(position)

		if not slot then
			return
		end

		index = slot.index
	end

	sendOpcode({
		action = "add",
		category = AbilityBarCategoryCrafting,
		abilityId = abilityId,
		abilityType = abilityType,
		index = index
	})
end

function AbilityBar.addItem(clientId, position)
	local index

	if position then
		local slot = AbilityBar.getSlotByPosition(position)

		if not slot then
			return
		end

		index = slot.index
	end

	sendOpcode({
		action = "add",
		category = AbilityBarCategorySpell,
		clientId = clientId,
		index = index
	})
	signalcall(AbilityBar.onAddItem, AbilityBar, clientId, index)
end

function AbilityBar.setState(state, dontSend)
	AbilityBar.state = state

	local isEditMode = g_layout.isEditMode()

	if state ~= AbilityBarCategoryAetherRiftBuild and modules.game_spelltree and modules.game_spelltree.GameSpellTree:isShowingAetherRiftBuild() then
		modules.game_spelltree.GameSpellTree:setShowingAetherRiftBuild(false, true, true)
	end

	for category, bars in pairs(AbilityBar.barWidgets) do
		for i, bar in pairs(bars) do
			local icon = bar:recursiveGetChildById("icon")

			bar:setVisible((isEditMode and category == AbilityBarCategorySpell or category == state) and (icon and icon.abilityId and (category == AbilityBarCategoryFishing or category == AbilityBarCategoryCrafting) or i <= AbilityBar.numBarsVisible[category == AbilityBarCategoryAetherRiftBuild and AbilityBarCategorySpell or category]))
			bar:recursiveGetChildById("editModeBackground"):setVisible(isEditMode)
		end
	end

	if AbilityBar.weaponSkillWidget then
		AbilityBar.weaponSkillWidget:setVisible(state == AbilityBarCategorySpell or isEditMode)
		AbilityBar.weaponSkillWidget:recursiveGetChildById("editModeBackground"):setVisible(isEditMode)
	end

	if AbilityBar.mountSkillWidget then
		AbilityBar.mountSkillWidget:setVisible(state == AbilityBarCategorySpell and not g_game.isAetherRiftChannel() or isEditMode)
		AbilityBar.mountSkillWidget:recursiveGetChildById("editModeBackground"):setVisible(isEditMode)
	end

	if AbilityBar.mountBarWidget then
		AbilityBar.mountBarWidget:setVisible(state == AbilityBarCategorySpell and not g_game.isAetherRiftChannel() or isEditMode)
		AbilityBar.mountBarWidget:recursiveGetChildById("editModeBackground"):setVisible(isEditMode)
	end

	if not dontSend and state ~= AbilityBarCategoryAetherRiftBuild then
		sendOpcode({
			action = "category",
			category = AbilityBar.state
		})
	end

	if g_game.isOnline() then
		AbilityBar.onOutfitChange(nil, g_game.getLocalPlayer():getOutfit())
	end
end

function AbilityBar.setDefaultState()
	local isCrafting = modules.game_professions and modules.game_professions.minigameWindow:isVisible()

	if isCrafting then
		AbilityBar.setState(AbilityBarCategoryCrafting)

		return
	end

	local isFishing = FishFight and FishFight.gameState > 0

	if isFishing then
		AbilityBar.setState(AbilityBarCategoryFishing)

		return
	end

	local isShip = g_game.isInShip()

	if isShip then
		AbilityBar.setState(AbilityBarCategoryShip)

		return
	end

	AbilityBar.setState(AbilityBarCategorySpell)
end

function AbilityBar.reset()
	if AbilityBar.state == AbilityBarCategoryFishing then
		return
	end

	sendOpcode({
		action = "reset"
	})
end

function AbilityBar.setNumBarsVisible(category, value)
	AbilityBar.numBarsVisible[category] = value

	AbilityBar.setState(AbilityBar.state, true)

	if cacheLoadingEnabled then
		AbilityBar.putCache("numBarsVisible", value, category)
	end
end

function AbilityBar.update()
	AbilityBar.setState(AbilityBar.state, true)
end

function AbilityBar.onLock(widget, forceValue)
	local isLocked = widget.locked == true

	widget.locked = forceValue == nil and not isLocked or forceValue

	widget:recursiveGetChildById("lockButton"):setOn(not widget.locked)
end

function AbilityBar.onRotate(widget, forceVertical)
	local isVertical = widget.vertical == true

	if isVertical and forceVertical then
		return
	end

	local position = widget:getPosition()
	local verticalWidget = AbilityBar.createBar(widget.category, widget.barIndex, not widget.vertical)
	local hudPanelSize = modules.game_interface.getHUDPanel():getSize()
	local widgetSize = verticalWidget:getSize()

	if position.y + widgetSize.height > hudPanelSize.height then
		position.y = hudPanelSize.height - widgetSize.height
	end

	if position.x + widgetSize.width > hudPanelSize.width then
		position.x = hudPanelSize.width - widgetSize.width
	end

	verticalWidget:setPosition(position)
	widget:destroy()

	if verticalWidget.category ~= AbilityBarCategoryMount then
		for category in pairs(AbilityBar.barWidgets) do
			if category ~= AbilityBarCategoryWeaponSkill and category ~= AbilityBarCategoryMount and category ~= AbilityBarCategoryMountSkillWidget then
				local bar = AbilityBar.barWidgets[category][verticalWidget.barIndex]

				if bar and bar ~= verticalWidget then
					local verticalWidget1 = AbilityBar.createBar(bar.category, bar.barIndex, not bar.vertical)

					verticalWidget1:setPosition(position)
					bar:destroy()
				end
			end
		end

		sendOpcode({
			action = "refresh",
			category = AbilityBar.state
		})
	else
		sendOpcode({
			action = "refresh",
			category = AbilityBarCategoryMount
		})
	end

	AbilityBar.setState(AbilityBar.state, true)
	AbilityBar.onOutfitChange(nil, g_game.getLocalPlayer():getOutfit())
end

function AbilityBar.setChargeCooldown(spellId, cooldown, chargeId, spellWidget)
	AbilityBar.spellCharges[spellId] = AbilityBar.spellCharges[spellId] or {}
	AbilityBar.spellCharges[spellId][chargeId] = cooldown + g_clock.millis()

	if spellWidget and spellWidget.charges then
		spellWidget.charges:setText(AbilityBar.getAvailableSpellCharges(spellId))
	end
end

function AbilityBar.getAvailableSpellCharges(spellId)
	local charges = AbilityBar.spellCharges[spellId]

	if not charges then
		return 0
	end

	local count = 0

	for _, cooldown in ipairs(charges) do
		if cooldown <= g_clock.millis() then
			count = count + 1
		end
	end

	return count
end

function AbilityBar.onSpellHighlight(spellId, mapIcon, highlight)
	local state = AbilityBar.state

	if spellId >= 1500 and spellId < 1600 then
		state = AbilityBarCategoryWeaponSkill
	elseif spellId >= 1600 and spellId < 2500 then
		state = AbilityBarCategoryMount
	end

	for absoluteSlotIndex, slot in pairs(AbilityBar.bars[state]) do
		local ability = slot.abilityId
		local _, slotWidget = AbilityBar.getSlot(state, absoluteSlotIndex)
		local barWidget = AbilityBar.getBarWidgetBySlotIndex(AbilityBar.state, absoluteSlotIndex)
		local overlay = slotWidget and barWidget:recursiveGetChildById(slotWidget:getId() .. "overlay")

		if ability > 0 and overlay and ability == spellId then
			overlay:getChildById("overlayGlow"):setVisible(highlight)

			if mapIcon then
				g_game.addItemIcon(g_game.getLocalPlayer():getPosition(), SPELL_RECAST_ICON, 1, 100, false, AbilityBar.getAsset(AbilityBarCategorySpell, ability))
			end
		end
	end
end

function AbilityBar.onSpellCooldown(spellId, cooldown, castedSpellId, chargeId)
	local state = AbilityBar.state

	if spellId >= 1500 and spellId < 1600 then
		state = AbilityBarCategoryWeaponSkill
	elseif spellId >= 1600 and spellId < 2500 then
		state = AbilityBarCategoryMount
	end

	for absoluteSlotIndex, slot in pairs(AbilityBar.bars[state]) do
		local ability = slot.abilityId
		local slot, slotWidget = AbilityBar.getSlot(state, absoluteSlotIndex)
		local barWidget = AbilityBar.getBarWidgetBySlotIndex(AbilityBar.state, absoluteSlotIndex)
		local overlay = slotWidget and barWidget:recursiveGetChildById(slotWidget:getId() .. "overlay")
		local progressRect = slotWidget:recursiveGetChildById("progressRect")

		if ability > 0 and ability == spellId then
			AbilityBar.setChargeCooldown(ability, cooldown, chargeId, slotWidget)

			if cooldown == 0 then
				progressRect.currentCooldown = 0
				progressRect.cooldownRemainder = 0
			elseif progressRect.globalCooldown and slot.charges > 1 then
				local newCooldown = cooldown

				for i = 1, slot.charges do
					local cd = AbilityBar.spellCharges[spellId][i]

					if cd and cd > g_clock.millis() then
						newCooldown = cooldown - g_clock.millis()

						break
					end
				end

				progressRect.globalCooldown = false
				progressRect.currentCooldown = newCooldown
			end

			local function spellChargesWork()
				for i = 1, slot.charges do
					local cooldown = AbilityBar.spellCharges[spellId][i]

					if cooldown and cooldown > g_clock.millis() then
						progressRect:onSpellCooldown(cooldown - g_clock.millis(), false, spellChargesWork)

						break
					end
				end

				slotWidget.charges:setText(AbilityBar.getAvailableSpellCharges(spellId))
			end

			if slot.charges > 1 then
				progressRect:onSpellCooldown(cooldown, false, spellChargesWork)
			else
				progressRect:onSpellCooldown(cooldown)
			end

			if overlay then
				overlay:getChildById("overlayGlow"):setVisible(false)
			end

			AbilityBar.resetMeleeQueue()
		elseif spellId == 0 and ability > 0 then
			if not AbilityBar.isExcludedFromGlobalCooldown(ability) and cooldown >= 0 then
				if not progressRect.globalCooldown and cooldown >= progressRect.currentCooldown or progressRect.globalCooldown and cooldown >= progressRect.currentCooldown - 50 then
					if ability ~= castedSpellId then
						progressRect:onSpellCooldown(cooldown, true)
					end
				elseif progressRect.globalCooldown and spellId == 0 and cooldown == 0 then
					progressRect:removeSpellCooldown()
				end
			end

			if overlay and ability == castedSpellId then
				overlay:getChildById("overlayGlow"):setVisible(true)
				g_game.addItemIcon(g_game.getLocalPlayer():getPosition(), SPELL_RECAST_ICON, 1, 100, false, AbilityBar.getAsset(AbilityBarCategorySpell, ability))
			end
		end
	end
end

function AbilityBar.isExcludedFromGlobalCooldown(spellId)
	local customValue = AbilityBar.customGlobalCooldownAbilities[spellId]

	if type(customValue) == "boolean" then
		return customValue
	end

	return excludeGlobalCooldownAbilities[spellId]
end

function AbilityBar.onSpellIgnoreGlobalCooldown(spellId, value)
	if value == 0 then
		AbilityBar.customGlobalCooldownAbilities[spellId] = nil
	else
		AbilityBar.customGlobalCooldownAbilities[spellId] = value == 1
	end
end

function AbilityBar.setupHotkeys()
	local function bind(hotkeyId, barIndex, slotIndex, category)
		local absoluteSlotIndex = AbilityBar.getAbsoluteSlotIndex(barIndex, slotIndex)
		local slot, slotWidget = AbilityBar.getSlot(category, absoluteSlotIndex)

		AbilityBar.hotkeysInUse[hotkeyId] = {
			hotkeyId = hotkeyId,
			absoluteSlotIndex = absoluteSlotIndex,
			slot = slot,
			slotWidget = slotWidget,
			category = category
		}
	end

	bind(AbilityBar.weaponSkillHotkeyId, 1, 1, AbilityBarCategoryWeaponSkill)
	bind(AbilityBar.mountSkillHotkeyId, 1, 1, AbilityBarCategoryMountSkillWidget)

	for barIndex, bar in ipairs(AbilityBar.barHotkeys) do
		for slotIndex, hotkeyId in ipairs(bar) do
			if barIndex == AbilityBar.mountKeysIndex then
				bind(hotkeyId, 1, slotIndex, AbilityBarCategoryMount)
			else
				bind(hotkeyId, barIndex > AbilityBar.mountKeysIndex and barIndex - 1 or barIndex, slotIndex, AbilityBarCategorySpell)
			end
		end
	end
end

function AbilityBar.updateBarHotkeys(category, barIndex)
	local widget = AbilityBar.barWidgets[category][barIndex]

	if not widget then
		return
	end

	if barIndex >= AbilityBar.mountKeysIndex then
		barIndex = barIndex + 1
	end

	local numSlotsPerBar = AbilityBar.numSlotsPerBar

	if category == AbilityBarCategoryWeaponSkill or category == AbilityBarCategoryMountSkillWidget then
		numSlotsPerBar = 1
	end

	for i = 1, numSlotsPerBar do
		local slot = widget:recursiveGetChildById("slot" .. tostring(i))

		if not slot then
			return
		end

		local overlay = widget:recursiveGetChildById("slot" .. tostring(i) .. "overlay")
		local shortcut = overlay:recursiveGetChildById("shortcut")
		local hotkeyId

		if category == AbilityBarCategoryWeaponSkill then
			hotkeyId = AbilityBar.weaponSkillHotkeyId
		elseif category == AbilityBarCategoryMountSkillWidget then
			hotkeyId = AbilityBar.mountSkillHotkeyId
		elseif category == AbilityBarCategoryMount then
			hotkeyId = AbilityBar.barHotkeys[AbilityBar.mountKeysIndex][i]
		elseif AbilityBar.barHotkeys[barIndex] then
			hotkeyId = AbilityBar.barHotkeys[barIndex][i]
		end

		if hotkeyId then
			shortcut.hotkeyId = hotkeyId
		end
	end
end

function AbilityBar.hotkeyIdToAbsoluteSlotIndex(hotkeyId)
	local data = AbilityBar.hotkeysInUse[hotkeyId]

	if data then
		local category = data.category == AbilityBarCategorySpell and AbilityBar.state or data.category

		return data.absoluteSlotIndex, category
	end
end

function AbilityBar.isSpellChargeOnCooldown(spellId, totalCharges)
	if not AbilityBar.spellCharges[spellId] then
		return false
	end

	local isOnCooldown = true

	for i = 1, totalCharges do
		if not AbilityBar.spellCharges[spellId][i] or AbilityBar.spellCharges[spellId][i] <= g_clock.millis() then
			isOnCooldown = false

			break
		end
	end

	return isOnCooldown
end

function AbilityBar.onHotkeyUpdate(hotkeyId, keyCombo, force)
	local absoluteSlotIndex, category = AbilityBar.hotkeyIdToAbsoluteSlotIndex(hotkeyId)

	if not absoluteSlotIndex or not category then
		return
	end

	local slot, slotWidget = AbilityBar.getSlot(category, absoluteSlotIndex)

	if not slotWidget then
		return
	end

	local barWidget = AbilityBar.getBarWidgetBySlotIndex(category, absoluteSlotIndex)

	if not barWidget then
		return
	end

	if slotWidget and barWidget then
		local overlay = barWidget:recursiveGetChildById(slotWidget:getId() .. "overlay")
		local shortcut = overlay:recursiveGetChildById("shortcut")

		if force or shortcut:getText() == "" then
			shortcut:setText(keyCombo or "")
		end
	end
end

function AbilityBar.onHotkeyPressed(hotkeyId)
	local player = g_game.getLocalPlayer()

	if not player then
		return false
	end

	if spellBatchEvent then
		removeEvent(spellBatchEvent)

		spellBatchEvent = nil
	end

	local absoluteSlotIndex, category = AbilityBar.hotkeyIdToAbsoluteSlotIndex(hotkeyId)
	local ability = AbilityBar.getAbilityId(category, absoluteSlotIndex)
	local slot, slotWidget = AbilityBar.getSlot(category, absoluteSlotIndex)

	if not slotWidget then
		return
	end

	local isBladestorm = slot and slot.abilityId and slot.abilityId == 106
	local isIgnoreChannelingItem = slot and slot.clientId and table.contains(AbilityBarIgnoreChannelingItemIds, slot.clientId)

	if not isIgnoreChannelingItem and player:isChanneling() and not isBladestorm then
		return false
	end

	local icon = slotWidget.icon or slotWidget:recursiveGetChildById("icon")

	if icon and icon:getImageSource() and not icon:getImageSource():empty() then
		AbilityBar.startClickResponseAnimation(icon, true)
	end

	local progress = slotWidget:recursiveGetChildById("progressRect")
	local isFreeRecast = freeRecastAbilities[ability] and AbilityBar.hasOverlayGlowBySlotIndex(category, absoluteSlotIndex)

	if category == AbilityBarCategoryMountSkillWidget then
		toggleMount()

		return
	end

	local direction = InvalidDirection

	if modules.game_settings.getOption("mouseDirectionCasting") then
		local mapPanel = modules.game_interface.gameMapPanel
		local fromPos = player:getPosition()
		local toPos = mapPanel:getPosition(g_window.getMousePosition())

		if toPos and fromPos then
			direction = getServerDirectionFromPos(fromPos, player:getDirection(), toPos)
		end
	end

	AbilityBar.onPreUseAbility(ability, slot, slotWidget, absoluteSlotIndex, category)

	if ability > 0 and (not progress.event or slot.charges > 1 and not AbilityBar.isSpellChargeOnCooldown(ability, slot.charges)) then
		local isSpellCategory = category == AbilityBarCategorySpell or category == AbilityBarCategoryShip

		if isSpellCategory and not g_spells:canCastSpell(ability, isFreeRecast) then
			return false
		end

		if not isSpellCategory or not modules.game_interface.handleCrosshair(ability) then
			g_game.useAbility(category, absoluteSlotIndex, direction)
		end
	elseif not table.find(holdKeyAbilities, ability) and progress.event and progress.currentCooldown - AbilityBar.spellBatchTime <= 0 then
		spellBatchEvent = scheduleEvent(function()
			if category == AbilityBarCategorySpell and not g_spells:canCastSpell(ability, isFreeRecast) then
				return false
			end

			g_game.useAbility(category, absoluteSlotIndex, direction)
		end, progress.currentCooldown)
	elseif slot and slot.clientId then
		g_game.useInventoryItem(slot.clientId)
	end
end

function AbilityBar.onShipChange(player, shipType)
	if shipType ~= ShipTypes.None then
		addEvent(function()
			AbilityBar.setState(AbilityBarCategoryShip)
		end)
	else
		addEvent(function()
			AbilityBar.setDefaultState()
		end)
	end
end

function AbilityBar.onPositionChange(player)
	removeEvent(spellBatchEvent)

	spellBatchEvent = nil

	AbilityBar.onTargetPositionChange(player)

	if modules.game_settings.getOption("meleeAbilityQueue") then
		AbilityBar.checkMeleeAttackQueue(player)
	end
end

function AbilityBar.onTargetPositionChange(creature)
	if AbilityBar.positionStateEvent then
		removeEvent(AbilityBar.positionStateEvent)

		AbilityBar.positionStateEvent = nil
	end

	local player = creature:isLocalPlayer() and creature or g_game.getLocalPlayer()

	if not player or player:isInShip() then
		return
	end

	if player:getTargetCreature() then
		AbilityBar.positionStateEvent = scheduleEvent(function()
			local target = player:getTargetCreature()

			if player and target and g_game.isOnline() then
				AbilityBar.checkSlotStates(player, target)
			end
		end, 80)
	end
end

function AbilityBar.onManaChange(player, mana, maxMana)
	if player:isInShip() then
		return
	end

	AbilityBar.checkSlotStates(player, player:getTargetCreature())
end

function AbilityBar.checkMeleeAttackQueue(player)
	local queuedAbility = AbilityBar.meleeAbilityQueue

	if queuedAbility.id then
		if queuedAbility.condition(player, player:getTargetCreature()) then
			local category = AbilityBar.state or AbilityBarCategorySpell
			local slot, slotWidget = AbilityBar.getSlotByAbilityId(category, queuedAbility.id)
			local progressRect = slotWidget:recursiveGetChildById("progressRect")

			if not progressRect or not progressRect:isExplicitlyVisible() then
				g_game.useAbility(category, slot.index)
				AbilityBar.resetMeleeQueue()
			end
		end
	else
		AbilityBar.resetMeleeQueue()
	end
end

function AbilityBar.isSharingCooldown(first, second)
	for _, ids in ipairs(SharedCooldownClientIds) do
		if table.find(ids, first) and table.find(ids, second) then
			return true
		end
	end
end

function AbilityBar.onMultiUseCooldown(itemId, cooldown)
	local state = AbilityBar.state

	for absoluteSlotIndex in pairs(AbilityBar.bars[state]) do
		local slot, slotWidget = AbilityBar.getSlot(state, absoluteSlotIndex)
		local progressRect = slotWidget:recursiveGetChildById("progressRect")

		if slot.clientId == itemId or AbilityBar.isSharingCooldown(slot.clientId, itemId) then
			if cooldown == 0 then
				progressRect.currentCooldown = 0
				progressRect.cooldownRemainder = 0
			end

			progressRect:onSpellCooldown(cooldown)
		end
	end
end

function AbilityBar.canUseAbility(category, slotIndex)
	if modules.game_spelltree.GameSpellTree:isShowingAetherRiftBuild() then
		return false
	end

	if category == AbilityBarCategoryMountSkillWidget or category == AbilityBarCategoryWeaponSkill and AbilityBar.state == AbilityBarCategorySpell or category == AbilityBarCategoryMount and AbilityBar.state == AbilityBarCategorySpell then
		return true
	elseif category ~= AbilityBar.state then
		return false
	end

	local player = g_game.getLocalPlayer()
	local slot, slotWidget = AbilityBar.getSlot(category, slotIndex)

	if slot and slot.abilityId and lockWalkAbilities[slot.abilityId] then
		player:lockWalkTimed(400)
	end

	return true
end

function AbilityBar.updateMountIcon(outfit)
	AbilityBar.mountSkillWidget:recursiveGetChildById("icon"):setOutfit(outfit)
end

function AbilityBar.onOutfitChange(player, outfit, oldOutfit)
	if not AbilityBar.mountSkillWidget or not AbilityBar.mountBarWidget then
		return
	end

	if outfit.mountBody == 0 then
		AbilityBar.mountSkillWidget:hide()
	else
		AbilityBar.mountSkillWidget:show()
	end

	if outfit.mount == 0 then
		AbilityBar.mountBarWidget:hide()
	else
		AbilityBar.mountBarWidget:show()

		for _, child in pairs(AbilityBar.mountBarWidget.innerPanel:getChildren()) do
			if child:getStyleName() == "AbilityBarSlotOverlay" or child:getStyleName() == "AbilityBarSlotOverlayVertical" then
				child:setVisible(false)
			end
		end

		local width, height = 0, 0

		for _, widget in pairs(AbilityBar.bars[AbilityBarCategoryMount]) do
			if widget.abilityId ~= 0 then
				local slot, slotWidget = AbilityBar.getSlotByAbilityId(AbilityBarCategoryMount, widget.abilityId)

				width = width + slotWidget:getWidth()
				height = height + slotWidget:getHeight()

				AbilityBar.mountBarWidget:recursiveGetChildById("slot" .. tostring(slot.index) .. "overlay"):setVisible(true)
			end
		end

		if AbilityBar.mountBarWidget.vertical then
			AbilityBar.mountBarWidget:setHeight(math.max(35, height + 35))
		else
			AbilityBar.mountBarWidget:setWidth(math.max(35, width + 35))
		end
	end
end

function AbilityBar.onTargetChange(player, targetId, oldTargetId)
	if AbilityBar.targetOnPositionChangeDisconnect then
		for _, disconnect in pairs(AbilityBar.targetOnPositionChangeDisconnect) do
			disconnect()
		end

		AbilityBar.targetOnPositionChangeDisconnect = nil
	end

	AbilityBar.resetMeleeQueue()

	local target = g_map.getCreatureById(targetId)

	if not target then
		if oldTargetId then
			AbilityBar.resetSlotStates()
		end

		return
	end

	AbilityBar.targetOnPositionChangeDisconnect = connect(target, {
		onPositionChange = function(creature)
			AbilityBar.onTargetPositionChange(creature)
		end
	})

	AbilityBar.checkSlotStates(player, target)
end

function AbilityBar.checkSlotStates(player, target)
	target = target or player:getTargetCreature()

	local playerPos = player:getPosition()
	local targetPos = target and target:getPosition() or nil

	AbilityBar.forEachSlot(function(category, slot, widget)
		AbilityBar.checkSlotState(slot, widget, {
			player = player,
			target = target,
			playerPos = playerPos,
			targetPos = targetPos,
			category = category
		})
	end)
end

function AbilityBar.checkSlotState(slot, widget, data)
	if not widget then
		return
	end

	data = data or {}

	local player = data.player or g_game.getLocalPlayer()
	local target = data.target or player:getTargetCreature()
	local playerPos = data.playerPos or player:getPosition()
	local targetPos = data.targetPos or target and player:getId() ~= target:getId() and target:getPosition() or nil
	local hasMana = not slot.cost or not slot.cost.mana or player:getMana() >= math.floor(slot.cost.mana[1] / 100 * player:getBaseMaxMana())

	if not player:hasTarget(target) then
		if not player:getTargetCreature() then
			AbilityBar.applySlotStateStyle(slot, widget, hasMana)
		end

		return
	end

	local range = slot.range and slot.range() or -1
	local isInRange = range < 1 or not slot.needTarget or not targetPos or Position.isInRange(playerPos, targetPos, range, range)
	local active = isInRange and hasMana

	AbilityBar.applySlotStateStyle(slot, widget, active)
end

function AbilityBar.applySlotStateStyle(slot, widget, active)
	if not widget.icon then
		widget.icon = widget:recursiveGetChildById("icon")
	end

	if widget.icon then
		widget.icon:setOn(active)
	end
end

function AbilityBar.clearMeleeQueueEvents()
	if AbilityBar.meleeAbilityQueue.event then
		removeEvent(AbilityBar.meleeAbilityQueue.event)

		AbilityBar.meleeAbilityQueue.event = nil
	end

	if AbilityBar.meleeAbilityQueue.timeoutEvent then
		removeEvent(AbilityBar.meleeAbilityQueue.timeoutEvent)

		AbilityBar.meleeAbilityQueue.timeoutEvent = nil
	end
end

function AbilityBar.resetMeleeQueue()
	AbilityBar.clearMeleeQueueEvents()

	if not AbilityBar.meleeAbilityQueue.id then
		AbilityBar.meleeAbilityQueue = {}

		return
	end

	local category = AbilityBar.state or AbilityBarCategorySpell
	local slot, slotWidget = AbilityBar.getSlotByAbilityId(category, AbilityBar.meleeAbilityQueue.id)
	local barWidget = AbilityBar.getBarWidgetBySlotIndex(category, slot.index)

	if barWidget then
		local overlay = slotWidget and barWidget:recursiveGetChildById(slotWidget:getId() .. "overlay")

		if overlay then
			local overlayQueued = overlay:getChildById("overlayQueued")

			g_effects.stopFadeInOut(overlayQueued)
			overlayQueued:setVisible(false)
		end
	end

	AbilityBar.meleeAbilityQueue = {}
end

function AbilityBar.resetSlotStates()
	AbilityBar.forEachSlot(function(category, slot, widget)
		AbilityBar.resetSlotState(slot, widget)
	end)
end

function AbilityBar.resetSlotState(slot, slotWidget)
	if not slotWidget then
		return
	end

	if not slotWidget.icon then
		slotWidget.icon = slotWidget:recursiveGetChildById("icon")
	end

	if slotWidget.icon then
		slotWidget.icon:setOn(true)
	end
end

function AbilityBar.forEachSlot(iterator, category)
	category = category or AbilityBar.state

	if category == AbilityBarCategoryAll then
		for cat = AbilityBarCategoryFirst, AbilityBarCategoryLast do
			AbilityBar.forEachSlot(iterator, cat)
		end
	else
		for i = 1, AbilityBar.numSlots do
			local slot, widget = AbilityBar.getSlot(category, i)

			if slot then
				iterator(category, slot, widget)
			end
		end
	end
end

function AbilityBar.prepareBGSDemo()
	for category in pairs(AbilityBar.barWidgets) do
		for _, widget in pairs(AbilityBar.barWidgets[category]) do
			-- block empty
		end
	end
end

function AbilityBar.refreshOwnedItems()
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	for i = 1, AbilityBar.numSlots do
		local slot, slotWidget = AbilityBar.getSlot(AbilityBarCategorySpell, i)

		if slot and slotWidget then
			local overlay = AbilityBar.getBarWidgetBySlotIndex(AbilityBarCategorySpell, i):recursiveGetChildById(slotWidget:getId() .. "overlay")

			if overlay then
				overlay.itemCount:setText(slot.clientId and slot.clientId ~= 0 and player:getItemsCount(slot.clientId) or nil)
			end
		end
	end
end

function AbilityBar.offline()
	AbilityBar.setDefaultState()
	AbilityBar.resetSlotStates()
	AbilityBar.resetMeleeQueue()
end
