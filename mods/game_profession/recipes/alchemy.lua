-- chunkname: @/modules/game_profession/recipes/alchemy.lua

recipes = recipes or {}
recipes[ProfessionAlchemy] = {
	{
		quality = 100,
		durability = 4,
		index = 1,
		formatDescription = "potionquality",
		slotName = "",
		name = "Lesser Arcane Energy Tonic",
		progress = 50,
		profession = 11,
		clientId = 40844,
		itemId = 44296,
		experience = 430,
		amount = 3,
		description = "Increases Intelligence by {10} for 10 minutes.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 4,
			mass = 9
		},
		materials = {
			{
				clientId = 40370,
				name = "Refreshing Leaf",
				itemId = 43822,
				amount = 6
			},
			{
				clientId = 40339,
				name = "Earthy Stem",
				itemId = 43791,
				amount = 4
			},
			{
				clientId = 49644,
				name = "Purified Alcohol",
				itemId = 53097,
				amount = 1
			}
		}
	},
	{
		quality = 100,
		durability = 4,
		index = 2,
		formatDescription = "potionquality",
		slotName = "",
		name = "Lesser Strengthening Tonic",
		progress = 50,
		profession = 11,
		clientId = 40850,
		itemId = 44302,
		experience = 580,
		amount = 3,
		description = "Increases Might by {10} for 10 minutes.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 5,
			mass = 10
		},
		materials = {
			{
				clientId = 40370,
				name = "Refreshing Leaf",
				itemId = 43822,
				amount = 12
			},
			{
				clientId = 40371,
				name = "Thin Roots",
				itemId = 43823,
				amount = 6
			},
			{
				clientId = 49645,
				name = "Purified Oil",
				itemId = 53098,
				amount = 1
			}
		}
	},
	{
		quality = 100,
		durability = 5,
		index = 3,
		formatDescription = "potionquality",
		slotName = "",
		name = "Lesser Enlightenment Tonic",
		progress = 50,
		profession = 11,
		clientId = 40847,
		itemId = 44299,
		experience = 600,
		amount = 3,
		description = "Increases Wisdom by {10} for 10 minutes.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 6,
			mass = 11
		},
		materials = {
			{
				clientId = 40341,
				name = "Cerulean Cap",
				itemId = 43793,
				amount = 7
			},
			{
				clientId = 40370,
				name = "Refreshing Leaf",
				itemId = 43822,
				amount = 7
			},
			{
				clientId = 49644,
				name = "Purified Alcohol",
				itemId = 53097,
				amount = 1
			}
		}
	},
	{
		quality = 125,
		durability = 5,
		index = 4,
		formatDescription = "potionquality",
		slotName = "",
		name = "Lesser Rejuvenation Tonic",
		progress = 75,
		profession = 11,
		clientId = 40849,
		itemId = 44301,
		experience = 620,
		amount = 3,
		description = "Increases Health Regeneration by {25} for 10 minutes.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 7,
			mass = 12
		},
		materials = {
			{
				clientId = 40364,
				name = "Toadchew",
				itemId = 43816,
				amount = 8
			},
			{
				clientId = 40354,
				name = "Fungal Dust",
				itemId = 43806,
				amount = 9
			},
			{
				clientId = 49645,
				name = "Purified Oil",
				itemId = 53098,
				amount = 1
			}
		}
	},
	{
		quality = 145,
		durability = 5,
		index = 5,
		formatDescription = "potionquality",
		slotName = "",
		name = "Lesser Wellspring Tonic",
		progress = 95,
		profession = 11,
		clientId = 40845,
		itemId = 44297,
		experience = 680,
		amount = 3,
		description = "Increases Mana Regeneration by {20} for 10 minutes.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 8,
			mass = 13
		},
		materials = {
			{
				clientId = 40341,
				name = "Cerulean Cap",
				itemId = 43793,
				amount = 8
			},
			{
				clientId = 40354,
				name = "Fungal Dust",
				itemId = 43806,
				amount = 8
			},
			{
				clientId = 49644,
				name = "Purified Alcohol",
				itemId = 53097,
				amount = 1
			}
		}
	},
	{
		quality = 145,
		durability = 5,
		index = 6,
		formatDescription = "potionquality",
		slotName = "",
		name = "Lesser Mountainheart Tonic",
		progress = 95,
		profession = 11,
		clientId = 40848,
		itemId = 44300,
		experience = 730,
		amount = 3,
		description = "Increases Maximum Health by {200} for 10 minutes.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 9,
			mass = 14
		},
		materials = {
			{
				clientId = 40361,
				name = "Pirate's Bliss",
				itemId = 43813,
				amount = 7
			},
			{
				clientId = 40370,
				name = "Refreshing Leaf",
				itemId = 43822,
				amount = 4
			},
			{
				clientId = 49645,
				name = "Purified Oil",
				itemId = 53098,
				amount = 1
			}
		}
	},
	{
		quality = 175,
		durability = 5,
		index = 7,
		formatDescription = "potionquality",
		slotName = "",
		name = "Lesser Arcana Tonic",
		progress = 125,
		profession = 11,
		clientId = 40846,
		itemId = 44298,
		experience = 780,
		amount = 3,
		description = "Increases Maximum Mana by {150} for 10 minutes.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 11,
			mass = 16
		},
		materials = {
			{
				clientId = 40338,
				name = "Juicy Stem",
				itemId = 43790,
				amount = 7
			},
			{
				clientId = 40352,
				name = "Emerald Spores",
				itemId = 43804,
				amount = 7
			},
			{
				clientId = 49644,
				name = "Purified Alcohol",
				itemId = 53097,
				amount = 1
			}
		}
	},
	{
		quality = 175,
		durability = 5,
		index = 8,
		formatDescription = "potionquality",
		slotName = "",
		name = "Lesser Champion's Tonic",
		progress = 125,
		profession = 11,
		clientId = 40851,
		itemId = 44303,
		experience = 830,
		amount = 3,
		description = "Increases Attack Power by {7} for 10 minutes.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 14,
			mass = 19
		},
		materials = {
			{
				clientId = 40368,
				name = "Brightday",
				itemId = 43820,
				amount = 6
			},
			{
				clientId = 40363,
				name = "Shimmering Spores",
				itemId = 43815,
				amount = 10
			},
			{
				clientId = 49645,
				name = "Purified Oil",
				itemId = 53098,
				amount = 1
			}
		}
	},
	{
		quality = 200,
		durability = 5,
		index = 9,
		formatDescription = "potionquality",
		slotName = "",
		name = "Arcane Energy Tonic",
		progress = 150,
		profession = 11,
		clientId = 40858,
		itemId = 44310,
		experience = 1100,
		amount = 3,
		description = "Increases Intelligence by {20} for 10 minutes.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 16,
			mass = 21
		},
		materials = {
			{
				clientId = 40844,
				name = "Lesser Arcane Energy Tonic",
				itemId = 44296,
				amount = 1
			},
			{
				clientId = 40352,
				name = "Emerald Spores",
				itemId = 43804,
				amount = 14
			},
			{
				clientId = 40339,
				name = "Earthy Stem",
				itemId = 43791,
				amount = 14
			},
			{
				clientId = 49641,
				name = "Acid",
				itemId = 53094,
				amount = 1
			}
		}
	},
	{
		quality = 225,
		durability = 6,
		index = 10,
		formatDescription = "potionquality",
		slotName = "",
		name = "Strengthening Tonic",
		progress = 175,
		profession = 11,
		clientId = 40861,
		itemId = 44313,
		experience = 1200,
		amount = 3,
		description = "Increases Might by {20} for 10 minutes.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 17,
			mass = 22
		},
		materials = {
			{
				clientId = 40850,
				name = "Lesser Strengthening Tonic",
				itemId = 44302,
				amount = 1
			},
			{
				clientId = 40363,
				name = "Shimmering Spores",
				itemId = 43815,
				amount = 12
			},
			{
				clientId = 40339,
				name = "Earthy Stem",
				itemId = 43791,
				amount = 14
			},
			{
				clientId = 40835,
				name = "Alkali",
				itemId = 44287,
				amount = 1
			}
		}
	},
	{
		quality = 225,
		durability = 6,
		index = 11,
		formatDescription = "potionquality",
		slotName = "",
		name = "Enlightenment Tonic",
		progress = 175,
		profession = 11,
		clientId = 40856,
		itemId = 44308,
		experience = 1350,
		amount = 3,
		description = "Increases Wisdom by {20} for 10 minutes.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 19,
			mass = 24
		},
		materials = {
			{
				clientId = 40847,
				name = "Lesser Enlightenment Tonic",
				itemId = 44299,
				amount = 1
			},
			{
				clientId = 40367,
				name = "Bloody Bud",
				itemId = 43819,
				amount = 9
			},
			{
				clientId = 40372,
				name = "Thorny Roots",
				itemId = 43824,
				amount = 8
			},
			{
				clientId = 40835,
				name = "Alkali",
				itemId = 44287,
				amount = 1
			}
		}
	},
	{
		quality = 250,
		durability = 6,
		index = 12,
		formatDescription = "potionquality",
		slotName = "",
		name = "Rejuvenation Tonic",
		progress = 200,
		profession = 11,
		clientId = 40862,
		itemId = 44314,
		experience = 1500,
		amount = 3,
		description = "Increases Health Regeneration by {60} for 10 minutes.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 21,
			mass = 26
		},
		materials = {
			{
				clientId = 40849,
				name = "Lesser Rejuvenation Tonic",
				itemId = 44301,
				amount = 1
			},
			{
				clientId = 40357,
				name = "Juicy Roots",
				itemId = 43809,
				amount = 18
			},
			{
				clientId = 40335,
				name = "Green Cap",
				itemId = 43787,
				amount = 12
			},
			{
				clientId = 40835,
				name = "Alkali",
				itemId = 44287,
				amount = 1
			}
		}
	},
	{
		quality = 275,
		durability = 6,
		index = 13,
		formatDescription = "potionquality",
		slotName = "",
		name = "Wellspring Tonic",
		progress = 225,
		profession = 11,
		clientId = 40853,
		itemId = 44305,
		experience = 1500,
		amount = 3,
		description = "Increases Mana Regeneration by {45} for 10 minutes.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 22,
			mass = 27
		},
		materials = {
			{
				clientId = 40845,
				name = "Lesser Wellspring Tonic",
				itemId = 44297,
				amount = 1
			},
			{
				clientId = 40342,
				name = "Pirate's Cap",
				itemId = 43794,
				amount = 14
			},
			{
				clientId = 40371,
				name = "Thin Roots",
				itemId = 43823,
				amount = 11
			},
			{
				clientId = 49641,
				name = "Acid",
				itemId = 53094,
				amount = 1
			}
		}
	},
	{
		quality = 275,
		durability = 6,
		index = 14,
		formatDescription = "potionquality",
		slotName = "",
		name = "Mountainheart Tonic",
		progress = 225,
		profession = 11,
		clientId = 40854,
		itemId = 44306,
		experience = 1525,
		amount = 3,
		description = "Increases Maximum Health by {400} for 10 minutes.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 24,
			mass = 29
		},
		materials = {
			{
				clientId = 40848,
				name = "Lesser Mountainheart Tonic",
				itemId = 44300,
				amount = 1
			},
			{
				clientId = 40357,
				name = "Juicy Roots",
				itemId = 43809,
				amount = 16
			},
			{
				clientId = 40352,
				name = "Emerald Spores",
				itemId = 43804,
				amount = 14
			},
			{
				clientId = 40835,
				name = "Alkali",
				itemId = 44287,
				amount = 1
			}
		}
	},
	{
		quality = 300,
		durability = 7,
		index = 15,
		formatDescription = "potionquality",
		slotName = "",
		name = "Arcana Tonic",
		progress = 250,
		profession = 11,
		clientId = 40857,
		itemId = 44309,
		experience = 1550,
		amount = 3,
		description = "Increases Maximum Mana by {300} for 10 minutes.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 27,
			mass = 32
		},
		materials = {
			{
				clientId = 40846,
				name = "Lesser Arcana Tonic",
				itemId = 44298,
				amount = 1
			},
			{
				clientId = 40368,
				name = "Brightday",
				itemId = 43820,
				amount = 16
			},
			{
				clientId = 40354,
				name = "Fungal Dust",
				itemId = 43806,
				amount = 20
			},
			{
				clientId = 40835,
				name = "Alkali",
				itemId = 44287,
				amount = 1
			}
		}
	},
	{
		quality = 300,
		durability = 7,
		index = 16,
		formatDescription = "potionquality",
		slotName = "",
		name = "Champion's Tonic",
		progress = 250,
		profession = 11,
		clientId = 40855,
		itemId = 44307,
		experience = 1600,
		amount = 3,
		description = "Increases Attack Power by {12} for 10 minutes.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 28,
			mass = 33
		},
		materials = {
			{
				clientId = 40851,
				name = "Lesser Champion's Tonic",
				itemId = 44303,
				amount = 1
			},
			{
				clientId = 40364,
				name = "Toadchew",
				itemId = 43816,
				amount = 20
			},
			{
				clientId = 40338,
				name = "Juicy Stem",
				itemId = 43790,
				amount = 15
			},
			{
				clientId = 49641,
				name = "Acid",
				itemId = 53094,
				amount = 1
			}
		}
	},
	{
		quality = 300,
		durability = 7,
		index = 17,
		formatDescription = "potionquality",
		slotName = "",
		name = "Mana Surge Tonic",
		progress = 325,
		profession = 11,
		clientId = 49654,
		itemId = 53107,
		experience = 2200,
		amount = 3,
		description = "Restores {600} Mana every 30 seconds for 5 minutes. 10 minute cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 35,
			mass = 40
		},
		materials = {
			{
				clientId = 40853,
				name = "Wellspring Tonic",
				itemId = 44305,
				amount = 1
			},
			{
				clientId = 40367,
				name = "Bloody Bud",
				itemId = 43819,
				amount = 8
			},
			{
				clientId = 40345,
				name = "Dry Stem",
				itemId = 43797,
				amount = 8
			},
			{
				clientId = 49642,
				name = "Catalytic Solution",
				itemId = 53095,
				amount = 1
			}
		}
	},
	{
		quality = 350,
		durability = 8,
		index = 18,
		formatDescription = "potionquality",
		slotName = "",
		name = "Nimble Grace Tonic",
		progress = 400,
		profession = 11,
		clientId = 49656,
		itemId = 53109,
		experience = 2300,
		amount = 3,
		description = "Increases Movement Speed on foot by {10}% for the next 5 minutes. 10 minute cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 35,
			mass = 40
		},
		materials = {
			{
				clientId = 40855,
				name = "Champion's Tonic",
				itemId = 44307,
				amount = 1
			},
			{
				clientId = 40367,
				name = "Bloody Bud",
				itemId = 43819,
				amount = 8
			},
			{
				clientId = 40361,
				name = "Pirate's Bliss",
				itemId = 43813,
				amount = 13
			},
			{
				clientId = 49642,
				name = "Catalytic Solution",
				itemId = 53095,
				amount = 1
			}
		}
	},
	{
		quality = 350,
		durability = 8,
		index = 19,
		formatDescription = "potionquality",
		slotName = "",
		name = "Mighty Impact Tonic",
		progress = 400,
		profession = 11,
		clientId = 49655,
		itemId = 53108,
		experience = 2400,
		amount = 3,
		description = "Increases Impact by {50} for 5 minutes. 10 minute Cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 37,
			mass = 42
		},
		materials = {
			{
				clientId = 40855,
				name = "Champion's Tonic",
				itemId = 44307,
				amount = 1
			},
			{
				clientId = 40360,
				name = "Numbing Thorns",
				itemId = 43812,
				amount = 10
			},
			{
				clientId = 40338,
				name = "Juicy Stem",
				itemId = 43790,
				amount = 18
			},
			{
				clientId = 49642,
				name = "Catalytic Solution",
				itemId = 53095,
				amount = 1
			}
		}
	},
	{
		quality = 375,
		durability = 8,
		index = 20,
		formatDescription = "potionquality",
		slotName = "",
		name = "Precise Harmony Tonic",
		progress = 425,
		profession = 11,
		clientId = 49657,
		itemId = 53110,
		experience = 2500,
		amount = 3,
		description = "Restores {800} Health and {500} Mana every 30 seconds for 5 minutes. 10 minute cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 41,
			mass = 46
		},
		materials = {
			{
				clientId = 40853,
				name = "Wellspring Tonic",
				itemId = 44305,
				amount = 1
			},
			{
				clientId = 40862,
				name = "Rejuvenation Tonic",
				itemId = 44314,
				amount = 1
			},
			{
				clientId = 40370,
				name = "Refreshing Leaf",
				itemId = 43822,
				amount = 64
			},
			{
				clientId = 49642,
				name = "Catalytic Solution",
				itemId = 53095,
				amount = 1
			}
		}
	},
	{
		quality = 375,
		durability = 8,
		index = 21,
		formatDescription = "potionquality",
		slotName = "",
		name = "Luminous Tonic",
		progress = 425,
		profession = 11,
		clientId = 49653,
		itemId = 53106,
		experience = 2600,
		amount = 3,
		description = "Increases Healing Power and Precision by {20} for 5 minutes. 10 minute cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 43,
			mass = 48
		},
		materials = {
			{
				clientId = 40856,
				name = "Enlightenment Tonic",
				itemId = 44308,
				amount = 1
			},
			{
				clientId = 40336,
				name = "Crystal Cap",
				itemId = 43788,
				amount = 12
			},
			{
				clientId = 40339,
				name = "Earthy Stem",
				itemId = 43791,
				amount = 18
			},
			{
				clientId = 49642,
				name = "Catalytic Solution",
				itemId = 53095,
				amount = 1
			}
		}
	},
	{
		quality = 475,
		durability = 9,
		index = 22,
		formatDescription = "potionquality",
		slotName = "",
		name = "Iron Will Tonic",
		progress = 525,
		profession = 11,
		clientId = 49651,
		itemId = 53104,
		experience = 2700,
		amount = 3,
		description = "Reduces the duration of slows, stuns and snares by {20}% for 5 minutes. 10 minute cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 45,
			mass = 50
		},
		materials = {
			{
				clientId = 40861,
				name = "Strengthening Tonic",
				itemId = 44313,
				amount = 1
			},
			{
				clientId = 40355,
				name = "Glowing Spores",
				itemId = 43807,
				amount = 8
			},
			{
				clientId = 40347,
				name = "Chest Warmer",
				itemId = 43799,
				amount = 9
			},
			{
				clientId = 49642,
				name = "Catalytic Solution",
				itemId = 53095,
				amount = 1
			}
		}
	},
	{
		quality = 475,
		durability = 9,
		index = 23,
		formatDescription = "potionquality",
		slotName = "",
		name = "Profound Insight Tonic",
		progress = 525,
		profession = 11,
		clientId = 49658,
		itemId = 53111,
		experience = 2800,
		amount = 3,
		description = "Your damaging skills have a {25}% chance to reduce all your cooldowns by 1 second for the next 5 minutes. 10 minute cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 48,
			mass = 53
		},
		materials = {
			{
				clientId = 40857,
				name = "Arcana Tonic",
				itemId = 44309,
				amount = 1
			},
			{
				clientId = 40862,
				name = "Rejuvenation Tonic",
				itemId = 44314,
				amount = 1
			},
			{
				clientId = 40358,
				name = "Lizard's Delight",
				itemId = 43810,
				amount = 24
			},
			{
				clientId = 49642,
				name = "Catalytic Solution",
				itemId = 53095,
				amount = 1
			},
			{
				clientId = 40347,
				name = "Chest Warmer",
				itemId = 43799,
				amount = 7
			}
		}
	},
	{
		quality = 475,
		durability = 9,
		index = 24,
		formatDescription = "potionquality",
		slotName = "",
		name = "Light of Dawn Tonic",
		progress = 525,
		profession = 11,
		clientId = 49652,
		itemId = 53105,
		experience = 2875,
		amount = 3,
		description = "Your healing skills have a {25}% chance to remove one negative effect from the target for the next 5 minutes. 10 minute cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 51,
			mass = 56
		},
		materials = {
			{
				clientId = 40856,
				name = "Enlightenment Tonic",
				itemId = 44308,
				amount = 1
			},
			{
				clientId = 40355,
				name = "Glowing Spores",
				itemId = 43807,
				amount = 8
			},
			{
				clientId = 40356,
				name = "Hagthorn",
				itemId = 43808,
				amount = 8
			},
			{
				clientId = 49642,
				name = "Catalytic Solution",
				itemId = 53095,
				amount = 1
			}
		}
	},
	{
		quality = 525,
		durability = 9,
		index = 25,
		formatDescription = "potionquality",
		slotName = "",
		name = "Accurate Physique Tonic",
		progress = 575,
		profession = 11,
		clientId = 49659,
		itemId = 53112,
		experience = 2950,
		amount = 3,
		description = "Your basic attacks have a {25}% chance to increase your precision by 40 for 6 seconds for the next 5 minutes. 10 minute cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 53,
			mass = 58
		},
		materials = {
			{
				clientId = 40861,
				name = "Strengthening Tonic",
				itemId = 44313,
				amount = 1
			},
			{
				clientId = 40348,
				name = "Cold Roots",
				itemId = 43800,
				amount = 13
			},
			{
				clientId = 40341,
				name = "Cerulean Cap",
				itemId = 43793,
				amount = 20
			},
			{
				clientId = 49642,
				name = "Catalytic Solution",
				itemId = 53095,
				amount = 1
			}
		}
	},
	{
		quality = 525,
		durability = 10,
		index = 26,
		formatDescription = "potionquality",
		slotName = "",
		name = "Arcane Mastery Tonic",
		progress = 575,
		profession = 11,
		clientId = 49647,
		itemId = 53100,
		experience = 3150,
		amount = 3,
		description = "Your skills have a {25}% chance to increase your precision by 40 for 6 seconds for the next 5 minutes. 10 minute cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 55,
			mass = 60
		},
		materials = {
			{
				clientId = 40858,
				name = "Arcane Energy Tonic",
				itemId = 44310,
				amount = 1
			},
			{
				clientId = 40365,
				name = "Twisted Flower",
				itemId = 43817,
				amount = 5
			},
			{
				clientId = 40356,
				name = "Hagthorn",
				itemId = 43808,
				amount = 10
			},
			{
				clientId = 49642,
				name = "Catalytic Solution",
				itemId = 53095,
				amount = 1
			}
		}
	},
	{
		quality = 565,
		durability = 10,
		index = 27,
		formatDescription = "potionquality",
		slotName = "",
		name = "Dark Pact Tonic",
		progress = 615,
		profession = 11,
		clientId = 49650,
		itemId = 53103,
		experience = 3250,
		amount = 3,
		description = "You receive {50} damage and restores {30} mana per second for the next 20 seconds. 5 minute cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 57,
			mass = 62
		},
		materials = {
			{
				clientId = 49652,
				name = "Light of Dawn Tonic",
				itemId = 53105,
				amount = 1
			},
			{
				clientId = 49642,
				name = "Catalytic Solution",
				itemId = 53095,
				amount = 6
			},
			{
				clientId = 37605,
				name = "Bloody Chalice",
				itemId = 41057,
				amount = 20
			},
			{
				clientId = 49641,
				name = "Acid",
				itemId = 53094,
				amount = 4
			}
		}
	},
	{
		quality = 565,
		durability = 10,
		index = 28,
		formatDescription = "potionquality",
		slotName = "",
		name = "Chillguard Tonic",
		progress = 615,
		profession = 11,
		clientId = 49649,
		itemId = 53102,
		experience = 3550,
		amount = 3,
		description = "Any attack made against you for the next 5 minutes causes the attacker to be struck by a glacial force, taking {30} damage instantly and reducing their Haste by {15}% for 2 seconds. After 3 seconds they take and an additional {30} damage. This effect can happen every 6 seconds per enemy. 10 minute cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 59,
			mass = 64
		},
		materials = {
			{
				clientId = 40858,
				name = "Arcane Energy Tonic",
				itemId = 44310,
				amount = 1
			},
			{
				clientId = 40854,
				name = "Mountainheart Tonic",
				itemId = 44306,
				amount = 1
			},
			{
				clientId = 40351,
				name = "Dusk Dust",
				itemId = 43803,
				amount = 10
			},
			{
				clientId = 40348,
				name = "Cold Roots",
				itemId = 43800,
				amount = 10
			},
			{
				clientId = 49642,
				name = "Catalytic Solution",
				itemId = 53095,
				amount = 1
			}
		}
	},
	{
		quality = 565,
		durability = 10,
		index = 29,
		formatDescription = "potionquality",
		slotName = "",
		name = "Burning Aegis Tonic",
		progress = 615,
		profession = 11,
		clientId = 49648,
		itemId = 53101,
		experience = 3750,
		amount = 3,
		description = "Any melee attack made against you for the next 5 minutes causes the attacker to start burning, taking {30} damage every 2 seconds over 6 seconds. This effect can happen every 6 seconds per enemy. 10 minute cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 61,
			mass = 66
		},
		materials = {
			{
				clientId = 40857,
				name = "Arcana Tonic",
				itemId = 44309,
				amount = 1
			},
			{
				clientId = 40854,
				name = "Mountainheart Tonic",
				itemId = 44306,
				amount = 1
			},
			{
				clientId = 40351,
				name = "Dusk Dust",
				itemId = 43803,
				amount = 8
			},
			{
				clientId = 40369,
				name = "Fire Cap",
				itemId = 43821,
				amount = 9
			},
			{
				clientId = 49642,
				name = "Catalytic Solution",
				itemId = 53095,
				amount = 1
			}
		}
	},
	{
		itemId = 44333,
		experience = 330,
		durability = 4,
		index = 30,
		profession = 11,
		quality = 75,
		slotName = "",
		amount = 5,
		name = "Lesser Health Potion",
		progress = 25,
		description = "Restores {350} Health instantly. 45 second cooldown shared between Potions.",
		clientId = 40881,
		tier = -1,
		category = "Potion",
		level = {
			single = 2,
			mass = 7
		},
		materials = {
			{
				clientId = 40370,
				name = "Refreshing Leaf",
				itemId = 43822,
				amount = 4
			},
			{
				clientId = 40829,
				name = "Fish Roe",
				itemId = 44281,
				amount = 1
			},
			{
				clientId = 49644,
				name = "Purified Alcohol",
				itemId = 53097,
				amount = 1
			}
		}
	},
	{
		itemId = 44334,
		experience = 330,
		durability = 4,
		index = 31,
		profession = 11,
		quality = 75,
		slotName = "",
		amount = 5,
		name = "Lesser Mana Potion",
		progress = 25,
		description = "Restores {180} Mana instantly. 45 second cooldown shared between Potions.",
		clientId = 40882,
		tier = -1,
		category = "Potion",
		level = {
			single = 3,
			mass = 8
		},
		materials = {
			{
				clientId = 40339,
				name = "Earthy Stem",
				itemId = 43791,
				amount = 4
			},
			{
				clientId = 40830,
				name = "Fish Skin",
				itemId = 44282,
				amount = 1
			},
			{
				clientId = 49645,
				name = "Purified Oil",
				itemId = 53098,
				amount = 4
			}
		}
	},
	{
		itemId = 44335,
		experience = 365,
		durability = 5,
		index = 32,
		profession = 11,
		quality = 200,
		slotName = "",
		amount = 5,
		name = "Intermediate Health Potion",
		progress = 150,
		description = "Restores {550} Health instantly. 45 second cooldown shared between Potions.",
		clientId = 40883,
		tier = -1,
		category = "Potion",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 40881,
				name = "Lesser Health Potion",
				itemId = 44333,
				amount = 5
			},
			{
				clientId = 40364,
				name = "Toadchew",
				itemId = 43816,
				amount = 3
			},
			{
				clientId = 40829,
				name = "Fish Roe",
				itemId = 44281,
				amount = 2
			},
			{
				clientId = 40354,
				name = "Fungal Dust",
				itemId = 43806,
				amount = 2
			}
		}
	},
	{
		itemId = 44336,
		experience = 365,
		durability = 5,
		index = 33,
		profession = 11,
		quality = 200,
		slotName = "",
		amount = 5,
		name = "Intermediate Mana Potion",
		progress = 150,
		description = "Restores {300} Mana instantly. 45 second cooldown shared between Potions.",
		clientId = 40884,
		tier = -1,
		category = "Potion",
		level = {
			single = 12,
			mass = 17
		},
		materials = {
			{
				clientId = 40882,
				name = "Lesser Mana Potion",
				itemId = 44334,
				amount = 5
			},
			{
				clientId = 40341,
				name = "Cerulean Cap",
				itemId = 43793,
				amount = 4
			},
			{
				clientId = 40830,
				name = "Fish Skin",
				itemId = 44282,
				amount = 2
			},
			{
				clientId = 40357,
				name = "Juicy Roots",
				itemId = 43809,
				amount = 1
			}
		}
	},
	{
		itemId = 44337,
		experience = 435,
		durability = 6,
		index = 34,
		profession = 11,
		quality = 275,
		slotName = "",
		amount = 5,
		name = "Greater Health Potion",
		progress = 225,
		description = "Restores {850} Health instantly. 45 second cooldown shared between Potions.",
		clientId = 40885,
		tier = -1,
		category = "Potion",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 40883,
				name = "Intermediate Health Potion",
				itemId = 44335,
				amount = 5
			},
			{
				clientId = 40361,
				name = "Pirate's Bliss",
				itemId = 43813,
				amount = 3
			},
			{
				clientId = 40834,
				name = "Yellow Fish Roe",
				itemId = 44286,
				amount = 1
			},
			{
				clientId = 40354,
				name = "Fungal Dust",
				itemId = 43806,
				amount = 4
			}
		}
	},
	{
		itemId = 44338,
		experience = 435,
		durability = 6,
		index = 35,
		profession = 11,
		quality = 275,
		slotName = "",
		amount = 5,
		name = "Greater Mana Potion",
		progress = 225,
		description = "Restores {400} Mana instantly. 45 second cooldown shared between Potions.",
		clientId = 40886,
		tier = -1,
		category = "Potion",
		level = {
			single = 23,
			mass = 28
		},
		materials = {
			{
				clientId = 40884,
				name = "Intermediate Mana Potion",
				itemId = 44336,
				amount = 5
			},
			{
				clientId = 40338,
				name = "Juicy Stem",
				itemId = 43790,
				amount = 4
			},
			{
				clientId = 40826,
				name = "Fish Eye",
				itemId = 44278,
				amount = 1
			},
			{
				clientId = 40357,
				name = "Juicy Roots",
				itemId = 43809,
				amount = 2
			}
		}
	},
	{
		itemId = 44339,
		experience = 970,
		durability = 7,
		index = 36,
		profession = 11,
		quality = 375,
		slotName = "",
		amount = 5,
		name = "Major Health Potion",
		progress = 325,
		description = "Restores {1200} Health instantly. 45 second cooldown shared between Potions.",
		clientId = 40887,
		tier = -1,
		category = "Potion",
		level = {
			single = 31,
			mass = 36
		},
		materials = {
			{
				clientId = 40885,
				name = "Greater Health Potion",
				itemId = 44337,
				amount = 5
			},
			{
				clientId = 40368,
				name = "Brightday",
				itemId = 43820,
				amount = 3
			},
			{
				clientId = 40834,
				name = "Yellow Fish Roe",
				itemId = 44286,
				amount = 2
			},
			{
				clientId = 40354,
				name = "Fungal Dust",
				itemId = 43806,
				amount = 5
			}
		}
	},
	{
		itemId = 44340,
		experience = 970,
		durability = 7,
		index = 37,
		profession = 11,
		quality = 375,
		slotName = "",
		amount = 5,
		name = "Major Mana Potion",
		progress = 325,
		description = "Restores {550} Mana instantly. 45 second cooldown shared between Potions.",
		clientId = 40888,
		tier = -1,
		category = "Potion",
		level = {
			single = 32,
			mass = 37
		},
		materials = {
			{
				clientId = 40886,
				name = "Greater Mana Potion",
				itemId = 44338,
				amount = 5
			},
			{
				clientId = 40342,
				name = "Pirate's Cap",
				itemId = 43794,
				amount = 3
			},
			{
				clientId = 40826,
				name = "Fish Eye",
				itemId = 44278,
				amount = 2
			},
			{
				clientId = 40357,
				name = "Juicy Roots",
				itemId = 43809,
				amount = 3
			}
		}
	},
	{
		itemId = 44341,
		experience = 1570,
		durability = 8,
		index = 38,
		profession = 11,
		quality = 375,
		slotName = "",
		amount = 5,
		name = "Supreme Health Potion",
		progress = 425,
		description = "Restores {1600} Health instantly. 45 second cooldown shared between Potions.",
		clientId = 40889,
		tier = -1,
		category = "Potion",
		level = {
			single = 42,
			mass = 47
		},
		materials = {
			{
				clientId = 40887,
				name = "Major Health Potion",
				itemId = 44339,
				amount = 5
			},
			{
				clientId = 40347,
				name = "Chest Warmer",
				itemId = 43799,
				amount = 3
			},
			{
				clientId = 40833,
				name = "Red Fish Roe",
				itemId = 44285,
				amount = 2
			},
			{
				clientId = 40354,
				name = "Fungal Dust",
				itemId = 43806,
				amount = 6
			}
		}
	},
	{
		itemId = 44342,
		experience = 1570,
		durability = 9,
		index = 39,
		profession = 11,
		quality = 375,
		slotName = "",
		amount = 5,
		name = "Supreme Mana Potion",
		progress = 425,
		description = "Restores {800} Mana instantly. 45 second cooldown shared between Potions.",
		clientId = 40890,
		tier = -1,
		category = "Potion",
		level = {
			single = 45,
			mass = 50
		},
		materials = {
			{
				clientId = 40888,
				name = "Major Mana Potion",
				itemId = 44340,
				amount = 5
			},
			{
				clientId = 40355,
				name = "Glowing Spores",
				itemId = 43807,
				amount = 3
			},
			{
				clientId = 40828,
				name = "Fish Oil",
				itemId = 44280,
				amount = 1
			},
			{
				clientId = 40357,
				name = "Juicy Roots",
				itemId = 43809,
				amount = 3
			}
		}
	},
	{
		itemId = 44363,
		experience = 2210,
		durability = 10,
		index = 40,
		profession = 11,
		quality = 475,
		slotName = "",
		amount = 5,
		name = "Eternal Health Potion",
		progress = 525,
		description = "Restores {2000} Health instantly. 45 second cooldown shared between Potions.",
		clientId = 40911,
		tier = -1,
		category = "Potion",
		level = {
			single = 60,
			mass = 65
		},
		materials = {
			{
				clientId = 40889,
				name = "Supreme Health Potion",
				itemId = 44341,
				amount = 5
			},
			{
				clientId = 40348,
				name = "Cold Roots",
				itemId = 43800,
				amount = 4
			},
			{
				clientId = 40833,
				name = "Red Fish Roe",
				itemId = 44285,
				amount = 3
			},
			{
				clientId = 40354,
				name = "Fungal Dust",
				itemId = 43806,
				amount = 8
			}
		}
	},
	{
		itemId = 44364,
		experience = 2210,
		durability = 10,
		index = 41,
		profession = 11,
		quality = 475,
		slotName = "",
		amount = 5,
		name = "Eternal Mana Potion",
		progress = 525,
		description = "Restores {1000} Mana instantly. 45 second cooldown shared between Potions.",
		clientId = 40912,
		tier = -1,
		category = "Potion",
		level = {
			single = 63,
			mass = 68
		},
		materials = {
			{
				clientId = 40890,
				name = "Supreme Mana Potion",
				itemId = 44342,
				amount = 5
			},
			{
				clientId = 40366,
				name = "Wailing Leaf",
				itemId = 43818,
				amount = 3
			},
			{
				clientId = 40828,
				name = "Fish Oil",
				itemId = 44280,
				amount = 2
			},
			{
				clientId = 40357,
				name = "Juicy Roots",
				itemId = 43809,
				amount = 5
			}
		}
	},
	{
		itemId = 53098,
		experience = 260,
		durability = 4,
		index = 42,
		profession = 11,
		quality = 75,
		slotName = "",
		amount = 4,
		name = "Purified Oil",
		progress = 25,
		description = "Used in various recipes. A pristine and refined oil, meticulously filtered to remove all impurities.",
		clientId = 49645,
		tier = -1,
		category = "Material",
		level = {
			single = 1,
			mass = 6
		},
		materials = {
			{
				clientId = 34899,
				name = "Oil",
				itemId = 38331,
				amount = 3
			}
		}
	},
	{
		itemId = 53097,
		experience = 260,
		durability = 4,
		index = 43,
		profession = 11,
		quality = 75,
		slotName = "",
		amount = 1,
		name = "Purified Alcohol",
		progress = 25,
		description = "Used in various recipes. A highly refined alcohol, distilled to perfection for use in alchemical preparations..",
		clientId = 49644,
		tier = -1,
		category = "Material",
		level = {
			single = 1,
			mass = 6
		},
		materials = {
			{
				clientId = 49945,
				name = "Fermented Potato Pulp",
				itemId = 53398,
				amount = 1
			}
		}
	},
	{
		itemId = 53094,
		experience = 600,
		durability = 5,
		index = 44,
		profession = 11,
		quality = 100,
		slotName = "",
		amount = 4,
		name = "Acid",
		progress = 50,
		description = "Used in various recipes. A highly reactive and corrosive base, this potent acid is used in various alchemical processes to break down tough materials and catalyze powerful reactions.",
		clientId = 49641,
		tier = -1,
		category = "Material",
		level = {
			single = 4,
			mass = 9
		},
		materials = {
			{
				clientId = 40335,
				name = "Green Cap",
				itemId = 43787,
				amount = 14
			},
			{
				clientId = 40372,
				name = "Thorny Roots",
				itemId = 43824,
				amount = 5
			},
			{
				clientId = 40339,
				name = "Earthy Stem",
				itemId = 43791,
				amount = 5
			}
		}
	},
	{
		itemId = 44287,
		experience = 700,
		durability = 5,
		index = 45,
		profession = 11,
		quality = 100,
		slotName = "",
		amount = 4,
		name = "Alkali",
		progress = 50,
		description = "Used in various recipes. A strong, caustic base, this alkali is utilized in alchemical mixtures to neutralize acids and stabilize volatile compounds.",
		clientId = 40835,
		tier = -1,
		category = "Material",
		level = {
			single = 5,
			mass = 10
		},
		materials = {
			{
				clientId = 28946,
				name = "stone",
				itemId = 32378,
				amount = 22
			},
			{
				clientId = 40830,
				name = "Fish Skin",
				itemId = 44282,
				amount = 4
			}
		}
	},
	{
		itemId = 44290,
		experience = 1200,
		durability = 7,
		index = 46,
		profession = 11,
		quality = 275,
		slotName = "",
		amount = 3,
		name = "Poison Base",
		progress = 225,
		description = "Used in various recipes. A specialized alchemical base designed for the creation of toxic concoctions and venoms.",
		clientId = 40838,
		tier = -1,
		category = "Material",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 40344,
				name = "Toxic Stem",
				itemId = 43796,
				amount = 4
			},
			{
				clientId = 40826,
				name = "Fish Eye",
				itemId = 44278,
				amount = 4
			},
			{
				clientId = 40367,
				name = "Bloody Bud",
				itemId = 43819,
				amount = 4
			},
			{
				clientId = 40828,
				name = "Fish Oil",
				itemId = 44280,
				amount = 1
			}
		}
	},
	{
		itemId = 53095,
		experience = 1800,
		durability = 8,
		index = 47,
		profession = 11,
		quality = 400,
		slotName = "",
		amount = 2,
		name = "Catalytic Solution",
		progress = 350,
		description = "Used in various recipes. A chemically reactive base that accelerates the effects of alchemical mixtures it is added to.",
		clientId = 49642,
		tier = -1,
		category = "Material",
		level = {
			single = 35,
			mass = 40
		},
		materials = {
			{
				clientId = 40352,
				name = "Emerald Spores",
				itemId = 43804,
				amount = 8
			},
			{
				clientId = 28942,
				name = "cobalt ore",
				itemId = 32374,
				amount = 12
			},
			{
				clientId = 40350,
				name = "Dread Bloom",
				itemId = 43802,
				amount = 3
			},
			{
				clientId = 49641,
				name = "Acid",
				itemId = 53094,
				amount = 1
			},
			{
				clientId = 40827,
				name = "Fish Liver",
				itemId = 44279,
				amount = 3
			}
		}
	},
	{
		itemId = 44291,
		experience = 2600,
		durability = 10,
		index = 48,
		profession = 11,
		quality = 475,
		slotName = "",
		amount = 3,
		name = "Potent Poison Base",
		progress = 525,
		description = "Used in various recipes. This refined poison base is the pinnacle of potency, essential for crafting the deadliest and most nefarious toxins.",
		clientId = 40839,
		tier = -1,
		category = "Material",
		level = {
			single = 59,
			mass = 64
		},
		materials = {
			{
				clientId = 40838,
				name = "Poison Base",
				itemId = 44290,
				amount = 3
			},
			{
				clientId = 49641,
				name = "Acid",
				itemId = 53094,
				amount = 5
			},
			{
				clientId = 40343,
				name = "Withered Stem",
				itemId = 43795,
				amount = 16
			},
			{
				clientId = 37520,
				name = "Deadly Poison Extract",
				itemId = 40972,
				amount = 1
			},
			{
				clientId = 40827,
				name = "Fish Liver",
				itemId = 44279,
				amount = 10
			}
		}
	},
	{
		itemId = 53099,
		experience = 2900,
		durability = 10,
		index = 49,
		profession = 11,
		quality = 475,
		slotName = "",
		amount = 2,
		name = "Resonating Fluid",
		progress = 525,
		description = "Used in various recipes. This fluid is known for its ability to amplify and resonate with magical energies.",
		clientId = 49646,
		tier = -1,
		category = "Material",
		level = {
			single = 60,
			mass = 65
		},
		materials = {
			{
				clientId = 40359,
				name = "Mindbender",
				itemId = 43811,
				amount = 38
			},
			{
				clientId = 40355,
				name = "Glowing Spores",
				itemId = 43807,
				amount = 18
			},
			{
				clientId = 40835,
				name = "Alkali",
				itemId = 44287,
				amount = 4
			},
			{
				clientId = 37454,
				name = "Pure Mana Essence",
				itemId = 40906,
				amount = 1
			}
		}
	},
	{
		itemId = 53096,
		experience = 3100,
		durability = 10,
		index = 50,
		profession = 11,
		quality = 475,
		slotName = "",
		amount = 2,
		name = "Ethereal Solvent",
		progress = 525,
		description = "Used in various recipes. This ethereal liquid is designed to dissolve even the most resilient and mystical components.",
		clientId = 49643,
		tier = -1,
		category = "Material",
		level = {
			single = 60,
			mass = 65
		},
		materials = {
			{
				clientId = 40365,
				name = "Twisted Flower",
				itemId = 43817,
				amount = 12
			},
			{
				clientId = 40336,
				name = "Crystal Cap",
				itemId = 43788,
				amount = 16
			},
			{
				clientId = 49641,
				name = "Acid",
				itemId = 53094,
				amount = 2
			},
			{
				clientId = 46186,
				name = "Rotten Flesh",
				itemId = 49639,
				amount = 1
			}
		}
	},
	{
		quality = 275,
		durability = 7,
		index = 51,
		formatDescription = "potionquality",
		slotName = "",
		name = "Lingering Agony Poison",
		progress = 225,
		profession = 11,
		clientId = 49694,
		itemId = 53147,
		experience = 2250,
		amount = 3,
		description = "Your melee basic attacks for the next 10 seconds apply a poison that deals {50} damage every 2 seconds and reduces healing received by {30}% for 6 seconds. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 26,
			mass = 31
		},
		materials = {
			{
				clientId = 40838,
				name = "Poison Base",
				itemId = 44290,
				amount = 1
			},
			{
				clientId = 40350,
				name = "Dread Bloom",
				itemId = 43802,
				amount = 9
			},
			{
				clientId = 40352,
				name = "Emerald Spores",
				itemId = 43804,
				amount = 4
			}
		}
	},
	{
		quality = 275,
		durability = 7,
		index = 52,
		formatDescription = "potionquality",
		slotName = "",
		name = "Enfeebling Strike Poison",
		progress = 225,
		profession = 11,
		clientId = 49693,
		itemId = 53146,
		experience = 2300,
		amount = 3,
		description = "Your melee basic attacks for the next 10 seconds reduces the target's Weapon Power by {35} and reduce their Impact by {100} for 6 seconds. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 29,
			mass = 34
		},
		materials = {
			{
				clientId = 40838,
				name = "Poison Base",
				itemId = 44290,
				amount = 1
			},
			{
				clientId = 40346,
				name = "Ambar Dust",
				itemId = 43798,
				amount = 8
			},
			{
				clientId = 40363,
				name = "Shimmering Spores",
				itemId = 43815,
				amount = 9
			},
			{
				clientId = 40364,
				name = "Toadchew",
				itemId = 43816,
				amount = 12
			}
		}
	},
	{
		quality = 400,
		durability = 8,
		index = 53,
		formatDescription = "potionquality",
		slotName = "",
		name = "Mind Numbing Poison",
		progress = 350,
		profession = 11,
		clientId = 49696,
		itemId = 53149,
		experience = 2350,
		amount = 3,
		description = "Your melee basic attacks for the next 10 seconds reduces the target's Spell Power by {35} and increase their Global Cooldown by 200 milliseconds for 6 seconds. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 41,
			mass = 46
		},
		materials = {
			{
				clientId = 40838,
				name = "Poison Base",
				itemId = 44290,
				amount = 1
			},
			{
				clientId = 40358,
				name = "Lizard's Delight",
				itemId = 43810,
				amount = 20
			},
			{
				clientId = 40350,
				name = "Dread Bloom",
				itemId = 43802,
				amount = 4
			}
		}
	},
	{
		quality = 375,
		durability = 8,
		index = 54,
		formatDescription = "potionquality",
		slotName = "",
		name = "Crippling Chill Poison",
		progress = 325,
		profession = 11,
		clientId = 49690,
		itemId = 53143,
		experience = 2425,
		amount = 3,
		description = "Your melee basic attacks for the next 10 seconds slow the target by {25}% for 6 seconds. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 44,
			mass = 49
		},
		materials = {
			{
				clientId = 40838,
				name = "Poison Base",
				itemId = 44290,
				amount = 1
			},
			{
				clientId = 40345,
				name = "Dry Stem",
				itemId = 43797,
				amount = 8
			},
			{
				clientId = 40344,
				name = "Toxic Stem",
				itemId = 43796,
				amount = 5
			}
		}
	},
	{
		quality = 475,
		durability = 9,
		index = 55,
		formatDescription = "potionquality",
		slotName = "",
		name = "Mana Siphon Poison",
		progress = 525,
		profession = 11,
		clientId = 49695,
		itemId = 53148,
		experience = 2450,
		amount = 3,
		description = "Your melee basic attacks for the next 10 seconds drain {60} Mana per hit from the target and restore it to you. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 40838,
				name = "Poison Base",
				itemId = 44290,
				amount = 1
			},
			{
				clientId = 49642,
				name = "Catalytic Solution",
				itemId = 53095,
				amount = 1
			},
			{
				clientId = 40366,
				name = "Wailing Leaf",
				itemId = 43818,
				amount = 8
			}
		}
	},
	{
		quality = 475,
		durability = 10,
		index = 56,
		formatDescription = "potionquality",
		slotName = "",
		name = "Decaying Touch Poison",
		progress = 525,
		profession = 11,
		clientId = 49691,
		itemId = 53144,
		experience = 3400,
		amount = 3,
		description = "Your melee basic attacks for the next 10 seconds reduces the target's Defense Power by {45} and deal {40} damage per second for 6 seconds. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 56,
			mass = 61
		},
		materials = {
			{
				clientId = 40838,
				name = "Poison Base",
				itemId = 44290,
				amount = 2
			},
			{
				clientId = 40351,
				name = "Dusk Dust",
				itemId = 43803,
				amount = 6
			},
			{
				clientId = 40343,
				name = "Withered Stem",
				itemId = 43795,
				amount = 10
			},
			{
				clientId = 40342,
				name = "Pirate's Cap",
				itemId = 43794,
				amount = 12
			}
		}
	},
	{
		quality = 525,
		durability = 10,
		index = 57,
		formatDescription = "potionquality",
		slotName = "",
		name = "Divine Disruption Poison",
		progress = 575,
		profession = 11,
		clientId = 49692,
		itemId = 53145,
		experience = 3600,
		amount = 3,
		description = "Your melee basic attacks for the next 10 seconds reduces the target's Healing Power by {70} and healing received by {25}% for 6 seconds. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 62,
			mass = 67
		},
		materials = {
			{
				clientId = 40839,
				name = "Potent Poison Base",
				itemId = 44291,
				amount = 1
			},
			{
				clientId = 40337,
				name = "Shadow Stem",
				itemId = 43789,
				amount = 8
			},
			{
				clientId = 40359,
				name = "Mindbender",
				itemId = 43811,
				amount = 15
			},
			{
				clientId = 40368,
				name = "Brightday",
				itemId = 43820,
				amount = 14
			}
		}
	},
	{
		quality = 475,
		durability = 11,
		index = 58,
		formatDescription = "potionquality",
		slotName = "",
		name = "Bloodfrenzy Poison",
		progress = 525,
		profession = 11,
		clientId = 49689,
		itemId = 53142,
		experience = 4200,
		amount = 3,
		description = "Your melee basic attacks for the next 10 seconds increase your own haste by {75} and movement speed by {10}%, and causes the target to bleed for {70} damage every 2 seconds for 6 seconds. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 65,
			mass = 70
		},
		materials = {
			{
				clientId = 40839,
				name = "Potent Poison Base",
				itemId = 44291,
				amount = 1
			},
			{
				clientId = 49643,
				name = "Ethereal Solvent",
				itemId = 53096,
				amount = 1
			},
			{
				clientId = 40347,
				name = "Chest Warmer",
				itemId = 43799,
				amount = 9
			},
			{
				clientId = 40369,
				name = "Fire Cap",
				itemId = 43821,
				amount = 6
			}
		}
	},
	{
		quality = 275,
		durability = 7,
		index = 59,
		formatDescription = "potionquality",
		slotName = "",
		name = "Hexing Oil",
		progress = 225,
		profession = 11,
		clientId = 49684,
		itemId = 53137,
		experience = 2250,
		amount = 3,
		description = "Your ranged basic attacks for the next 10 seconds apply a poison that deals {40} damage every 2 seconds for 6 seconds and reduces healing received by {15}%. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 40838,
				name = "Poison Base",
				itemId = 44290,
				amount = 1
			},
			{
				clientId = 40350,
				name = "Dread Bloom",
				itemId = 43802,
				amount = 8
			},
			{
				clientId = 40352,
				name = "Emerald Spores",
				itemId = 43804,
				amount = 10
			}
		}
	},
	{
		quality = 275,
		durability = 7,
		index = 60,
		formatDescription = "potionquality",
		slotName = "",
		name = "Crimson Fatigue Oil",
		progress = 225,
		profession = 11,
		clientId = 49683,
		itemId = 53136,
		experience = 2300,
		amount = 3,
		description = "Your ranged basic attacks for the next 10 seconds reduces the target's Weapon Power by {35} and reduces their Impact by {60} for 6 seconds. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				clientId = 40838,
				name = "Poison Base",
				itemId = 44290,
				amount = 1
			},
			{
				clientId = 40346,
				name = "Ambar Dust",
				itemId = 43798,
				amount = 8
			},
			{
				clientId = 40363,
				name = "Shimmering Spores",
				itemId = 43815,
				amount = 9
			},
			{
				clientId = 40364,
				name = "Toadchew",
				itemId = 43816,
				amount = 12
			}
		}
	},
	{
		quality = 400,
		durability = 8,
		index = 61,
		formatDescription = "potionquality",
		slotName = "",
		name = "Arcane Weakness Oil",
		progress = 350,
		profession = 11,
		clientId = 49681,
		itemId = 53134,
		experience = 2350,
		amount = 3,
		description = "Your ranged basic attacks for the next 10 seconds reduces the target's Spell Power by {35} and increase their Global Cooldown by 150 milliseconds for 6 seconds. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 40,
			mass = 45
		},
		materials = {
			{
				clientId = 40838,
				name = "Poison Base",
				itemId = 44290,
				amount = 1
			},
			{
				clientId = 40358,
				name = "Lizard's Delight",
				itemId = 43810,
				amount = 22
			},
			{
				clientId = 40360,
				name = "Numbing Thorns",
				itemId = 43812,
				amount = 6
			}
		}
	},
	{
		quality = 375,
		durability = 9,
		index = 62,
		formatDescription = "potionquality",
		slotName = "",
		name = "Temporal Disruption Oil",
		progress = 325,
		profession = 11,
		clientId = 49688,
		itemId = 53141,
		experience = 2425,
		amount = 3,
		description = "Your ranged basic attacks for the next 10 seconds reduces target's Haste and increases yours by {75} for 6 seconds. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 46,
			mass = 51
		},
		materials = {
			{
				clientId = 40838,
				name = "Poison Base",
				itemId = 44290,
				amount = 1
			},
			{
				clientId = 40345,
				name = "Dry Stem",
				itemId = 43797,
				amount = 8
			},
			{
				clientId = 40344,
				name = "Toxic Stem",
				itemId = 43796,
				amount = 5
			}
		}
	},
	{
		quality = 475,
		durability = 9,
		index = 63,
		formatDescription = "potionquality",
		slotName = "",
		name = "Mana Drain Oil",
		progress = 525,
		profession = 11,
		clientId = 49685,
		itemId = 53138,
		experience = 2450,
		amount = 3,
		description = "Your ranged basic attacks for the next 10 seconds drain {40} Mana per hit from the target and restore it to you. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 51,
			mass = 56
		},
		materials = {
			{
				clientId = 40838,
				name = "Poison Base",
				itemId = 44290,
				amount = 1
			},
			{
				clientId = 49642,
				name = "Catalytic Solution",
				itemId = 53095,
				amount = 1
			},
			{
				clientId = 40366,
				name = "Wailing Leaf",
				itemId = 43818,
				amount = 8
			}
		}
	},
	{
		quality = 475,
		durability = 10,
		index = 64,
		formatDescription = "potionquality",
		slotName = "",
		name = "Corrosive Oil",
		progress = 525,
		profession = 11,
		clientId = 49682,
		itemId = 53135,
		experience = 3400,
		amount = 3,
		description = "Your ranged basic attacks for the next 10 seconds reduces the target's Defense Power by {35} and dealing {45} damage every 2 seconds for 6 seconds.",
		tier = -1,
		category = "Poison",
		level = {
			single = 55,
			mass = 60
		},
		materials = {
			{
				clientId = 40838,
				name = "Poison Base",
				itemId = 44290,
				amount = 2
			},
			{
				clientId = 49641,
				name = "Acid",
				itemId = 53094,
				amount = 4
			},
			{
				clientId = 40343,
				name = "Withered Stem",
				itemId = 43795,
				amount = 15
			},
			{
				clientId = 40342,
				name = "Pirate's Cap",
				itemId = 43794,
				amount = 15
			}
		}
	},
	{
		quality = 525,
		durability = 10,
		index = 65,
		formatDescription = "potionquality",
		slotName = "",
		name = "Necrotic Oil",
		progress = 575,
		profession = 11,
		clientId = 49686,
		itemId = 53139,
		experience = 3600,
		amount = 3,
		description = "Your ranged basic attacks for the next 10 seconds apply a stack of Necrotic Poison. Upon reaching 4 stacks, Necrotic Poison silences the target for {1.5} seconds. After this effect triggers, Necrotic Poison stacks cannot be applied for 1 minute.",
		tier = -1,
		category = "Poison",
		level = {
			single = 63,
			mass = 68
		},
		materials = {
			{
				clientId = 40839,
				name = "Potent Poison Base",
				itemId = 44291,
				amount = 1
			},
			{
				clientId = 40337,
				name = "Shadow Stem",
				itemId = 43789,
				amount = 8
			},
			{
				clientId = 40359,
				name = "Mindbender",
				itemId = 43811,
				amount = 25
			},
			{
				clientId = 40368,
				name = "Brightday",
				itemId = 43820,
				amount = 5
			}
		}
	},
	{
		quality = 525,
		durability = 11,
		index = 66,
		formatDescription = "potionquality",
		slotName = "",
		name = "Rapid Fire Oil",
		progress = 575,
		profession = 11,
		clientId = 49687,
		itemId = 53140,
		experience = 4200,
		amount = 3,
		description = "Your ranged basic attacks for the next 10 seconds increase your own haste by {60} and movement speed by {7}%, and causes the target to bleed for {60} damage every 2 seconds for 6 seconds. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 66,
			mass = 71
		},
		materials = {
			{
				clientId = 40839,
				name = "Potent Poison Base",
				itemId = 44291,
				amount = 1
			},
			{
				clientId = 49643,
				name = "Ethereal Solvent",
				itemId = 53096,
				amount = 1
			},
			{
				clientId = 40347,
				name = "Chest Warmer",
				itemId = 43799,
				amount = 9
			},
			{
				clientId = 40369,
				name = "Fire Cap",
				itemId = 43821,
				amount = 6
			}
		}
	},
	{
		itemId = 41615,
		experience = 6000,
		durability = 7,
		index = 67,
		profession = 11,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Mating Essence",
		progress = 400,
		description = "A funny-smelling liquid which makes moas become very welcoming to each other. Reduces Mating Phase duration By 6 Hours.",
		clientId = 38163,
		tier = -1,
		category = "Misc",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				clientId = 40360,
				name = "Numbing Thorns",
				itemId = 43812,
				amount = 18
			},
			{
				clientId = 40342,
				name = "Pirate's Cap",
				itemId = 43794,
				amount = 14
			},
			{
				clientId = 43664,
				name = "Attachment Feather",
				itemId = 47116,
				amount = 10
			}
		}
	},
	{
		itemId = 41618,
		experience = 9500,
		durability = 10,
		index = 68,
		profession = 11,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Unstable Breeding Concoction",
		progress = 700,
		description = "A chemical mix with a nasty feeling about it. Increases Mating Phase duration by 4 hours, but increases the chance at getting a moa offspring of a higher tier by 5%.",
		clientId = 38166,
		tier = -1,
		category = "Misc",
		level = {
			single = 58,
			mass = 63
		},
		materials = {
			{
				clientId = 40359,
				name = "Mindbender",
				itemId = 43811,
				amount = 25
			},
			{
				clientId = 40337,
				name = "Shadow Stem",
				itemId = 43789,
				amount = 22
			},
			{
				clientId = 43664,
				name = "Attachment Feather",
				itemId = 47116,
				amount = 30
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		itemId = 41616,
		index = 69,
		slotName = "",
		name = "Exotic Vitamin",
		progress = 900,
		profession = 11,
		clientId = 38164,
		durability = 11,
		experience = 16000,
		specialization = "Thaumaturgist",
		description = "An odd-looking vitamin supplement used by experienced moa breeders. Increases the chance of the offspring to be born with an ability by 10%.",
		tier = -1,
		category = "Misc",
		level = {
			single = 69,
			mass = 74
		},
		materials = {
			{
				clientId = 40340,
				name = "Rocky Cap",
				itemId = 43792,
				amount = 15
			},
			{
				clientId = 40362,
				name = "Purple Roots",
				itemId = 43814,
				amount = 20
			},
			{
				clientId = 43664,
				name = "Attachment Feather",
				itemId = 47116,
				amount = 50
			}
		}
	},
	{
		itemId = 53114,
		experience = 6500,
		durability = 11,
		index = 70,
		profession = 11,
		quality = 650,
		slotName = "",
		amount = 2,
		name = "Core Catalyst",
		progress = 600,
		description = "Used in various recipes. A potent ingredient mix that serves as a catalyst for Concoctionist Elixirs.",
		clientId = 49661,
		tier = -1,
		category = "Material",
		level = {
			single = 68,
			mass = 73
		},
		materials = {
			{
				clientId = 40362,
				name = "Purple Roots",
				itemId = 43814,
				amount = 8
			},
			{
				clientId = 40340,
				name = "Rocky Cap",
				itemId = 43792,
				amount = 6
			},
			{
				clientId = 40356,
				name = "Hagthorn",
				itemId = 43808,
				amount = 6
			},
			{
				clientId = 40353,
				name = "Flaming Spores",
				itemId = 43805,
				amount = 9
			},
			{
				clientId = 40373,
				name = "Truffle",
				itemId = 43825,
				amount = 16
			},
			{
				clientId = 49646,
				name = "Resonating Fluid",
				itemId = 53099,
				amount = 1
			}
		}
	},
	{
		quality = 0,
		durability = 10,
		specialization = "Concoctionist",
		index = 71,
		formatDescription = "potionquality",
		slotName = "",
		name = "Chef's Zeal Elixir",
		progress = 800,
		profession = 11,
		clientId = 49660,
		itemId = 53113,
		experience = 8500,
		amount = 1,
		description = "Increases Cooking labor by {45} for 5 minutes. 5 minute cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 49661,
				name = "Core Catalyst",
				itemId = 53114,
				amount = 1
			},
			{
				clientId = 35399,
				name = "Strawberry Whiskey",
				itemId = 38831,
				amount = 1
			},
			{
				clientId = 34848,
				name = "Bittersweet Roast",
				itemId = 38280,
				amount = 1
			},
			{
				clientId = 28753,
				name = "Pie",
				itemId = 32185,
				amount = 1
			},
			{
				clientId = 40353,
				name = "Flaming Spores",
				itemId = 43805,
				amount = 6
			}
		}
	},
	{
		quality = 0,
		durability = 10,
		specialization = "Concoctionist",
		index = 72,
		formatDescription = "potionquality",
		slotName = "",
		name = "Forgefire Elixir",
		progress = 800,
		profession = 11,
		clientId = 49662,
		itemId = 53115,
		experience = 8500,
		amount = 1,
		description = "Increases Blacksmithing labor by {45} for 5 minutes. 5 minute cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 49661,
				name = "Core Catalyst",
				itemId = 53114,
				amount = 1
			},
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 2
			},
			{
				clientId = 28428,
				name = "dense whetstone",
				itemId = 31860,
				amount = 1
			},
			{
				clientId = 28734,
				name = "nail",
				itemId = 32166,
				amount = 3
			},
			{
				clientId = 40353,
				name = "Flaming Spores",
				itemId = 43805,
				amount = 6
			}
		}
	},
	{
		quality = 0,
		durability = 10,
		specialization = "Concoctionist",
		index = 73,
		formatDescription = "potionquality",
		slotName = "",
		name = "Woodwhisper Elixir",
		progress = 800,
		profession = 11,
		clientId = 49664,
		itemId = 53117,
		experience = 8500,
		amount = 1,
		description = "Increases Carpentry labor by {45} for 5 minutes. 5 minute cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 49661,
				name = "Core Catalyst",
				itemId = 53114,
				amount = 1
			},
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 2
			},
			{
				clientId = 41848,
				name = "Heavy Plank",
				itemId = 45300,
				amount = 1
			},
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 1
			},
			{
				clientId = 40353,
				name = "Flaming Spores",
				itemId = 43805,
				amount = 6
			}
		}
	},
	{
		quality = 0,
		durability = 10,
		specialization = "Concoctionist",
		index = 74,
		formatDescription = "potionquality",
		slotName = "",
		name = "Threadmaster Elixir",
		progress = 800,
		profession = 11,
		clientId = 49663,
		itemId = 53116,
		experience = 8500,
		amount = 1,
		description = "Increases Weaving labor by {45} for 5 minutes. 5 minute cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 49661,
				name = "Core Catalyst",
				itemId = 53114,
				amount = 1
			},
			{
				clientId = 28965,
				name = "silk",
				itemId = 32397,
				amount = 1
			},
			{
				clientId = 35434,
				name = "Tanned Leather",
				itemId = 38866,
				amount = 1
			},
			{
				clientId = 28971,
				name = "coarse thread",
				itemId = 32403,
				amount = 1
			},
			{
				clientId = 40353,
				name = "Flaming Spores",
				itemId = 43805,
				amount = 6
			}
		}
	},
	{
		amount = 3,
		quality = 700,
		itemId = 44365,
		index = 75,
		slotName = "",
		name = "Transcendent Health Potion",
		progress = 600,
		profession = 11,
		clientId = 40913,
		durability = 11,
		experience = 4500,
		specialization = "Concoctionist",
		description = "Restores {2500} Health instantly. 45 second cooldown shared between Potions.",
		tier = -1,
		category = "Potion",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 40911,
				name = "Eternal Health Potion",
				itemId = 44363,
				amount = 1
			},
			{
				clientId = 49673,
				name = "Prime Extract",
				itemId = 53126,
				amount = 1
			},
			{
				clientId = 40349,
				name = "Crystal Leaf",
				itemId = 43801,
				amount = 2
			},
			{
				clientId = 40370,
				name = "Refreshing Leaf",
				itemId = 43822,
				amount = 4
			},
			{
				clientId = 40371,
				name = "Thin Roots",
				itemId = 43823,
				amount = 6
			}
		}
	},
	{
		amount = 3,
		quality = 700,
		itemId = 44366,
		index = 76,
		slotName = "",
		name = "Transcendent Mana Potion",
		progress = 600,
		profession = 11,
		clientId = 40914,
		durability = 11,
		experience = 4500,
		specialization = "Concoctionist",
		description = "Restores {1250} Mana instantly. 45 second cooldown shared between Potions.",
		tier = -1,
		category = "Potion",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 40912,
				name = "Eternal Mana Potion",
				itemId = 44364,
				amount = 1
			},
			{
				clientId = 49673,
				name = "Prime Extract",
				itemId = 53126,
				amount = 1
			},
			{
				clientId = 40362,
				name = "Purple Roots",
				itemId = 43814,
				amount = 2
			},
			{
				clientId = 40370,
				name = "Refreshing Leaf",
				itemId = 43822,
				amount = 4
			},
			{
				clientId = 40371,
				name = "Thin Roots",
				itemId = 43823,
				amount = 6
			}
		}
	},
	{
		itemId = 53126,
		experience = 6500,
		durability = 11,
		index = 77,
		profession = 11,
		quality = 650,
		slotName = "",
		amount = 2,
		name = "Prime Extract",
		progress = 600,
		description = "Used in various recipes. A concentrated decoction that serves as a base for Poisoner Hunting Oils.",
		clientId = 49673,
		tier = -1,
		category = "Material",
		level = {
			single = 68,
			mass = 73
		},
		materials = {
			{
				clientId = 40340,
				name = "Rocky Cap",
				itemId = 43792,
				amount = 12
			},
			{
				clientId = 40362,
				name = "Purple Roots",
				itemId = 43814,
				amount = 14
			},
			{
				clientId = 40349,
				name = "Crystal Leaf",
				itemId = 43801,
				amount = 16
			},
			{
				clientId = 40373,
				name = "Truffle",
				itemId = 43825,
				amount = 4
			},
			{
				clientId = 49646,
				name = "Resonating Fluid",
				itemId = 53099,
				amount = 2
			}
		}
	},
	{
		quality = 0,
		durability = 10,
		specialization = "Poisoner",
		index = 78,
		formatDescription = "potionquality",
		slotName = "",
		name = "Frollbane Hunting Oil",
		progress = 800,
		profession = 11,
		clientId = 49670,
		itemId = 53123,
		experience = 8500,
		amount = 1,
		description = "Increases Attack Power against creatures from the Frolls family by {25} for 10 minutes. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 49643,
				name = "Ethereal Solvent",
				itemId = 53096,
				amount = 1
			},
			{
				clientId = 49673,
				name = "Prime Extract",
				itemId = 53126,
				amount = 1
			},
			{
				clientId = 46128,
				name = "Froll Skull",
				itemId = 49581,
				amount = 1
			}
		}
	},
	{
		quality = 0,
		durability = 10,
		specialization = "Poisoner",
		index = 79,
		formatDescription = "potionquality",
		slotName = "",
		name = "Jackal's Special Hunting Oil",
		progress = 800,
		profession = 11,
		clientId = 49672,
		itemId = 53125,
		experience = 8500,
		amount = 1,
		description = "Increases Attack Power against creatures from the Djinns family by {25} for 10 minutes. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 49643,
				name = "Ethereal Solvent",
				itemId = 53096,
				amount = 1
			},
			{
				clientId = 49673,
				name = "Prime Extract",
				itemId = 53126,
				amount = 1
			},
			{
				clientId = 43979,
				name = "Beastly Distillate",
				itemId = 47431,
				amount = 1
			}
		}
	},
	{
		quality = 0,
		durability = 10,
		specialization = "Poisoner",
		index = 80,
		formatDescription = "potionquality",
		slotName = "",
		name = "Demonbane Hunting Oil",
		progress = 800,
		profession = 11,
		clientId = 49666,
		itemId = 53119,
		experience = 8500,
		amount = 1,
		description = "Increases Attack Power against creatures from the Demons family by {25} for 10 minutes. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 49643,
				name = "Ethereal Solvent",
				itemId = 53096,
				amount = 1
			},
			{
				clientId = 49673,
				name = "Prime Extract",
				itemId = 53126,
				amount = 1
			},
			{
				clientId = 46103,
				name = "Demon Core",
				itemId = 49556,
				amount = 1
			}
		}
	},
	{
		quality = 0,
		durability = 10,
		specialization = "Poisoner",
		index = 81,
		formatDescription = "potionquality",
		slotName = "",
		name = "Hag Hunting Oil",
		progress = 800,
		profession = 11,
		clientId = 49671,
		itemId = 53124,
		experience = 8500,
		amount = 1,
		description = "Increases Attack Power against creatures from the Crowmaidens family by {25} for 10 minutes. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 49643,
				name = "Ethereal Solvent",
				itemId = 53096,
				amount = 1
			},
			{
				clientId = 49673,
				name = "Prime Extract",
				itemId = 53126,
				amount = 1
			},
			{
				clientId = 39562,
				name = "Witchcraft Doll",
				itemId = 43014,
				amount = 1
			}
		}
	},
	{
		quality = 0,
		durability = 10,
		specialization = "Poisoner",
		index = 82,
		formatDescription = "potionquality",
		slotName = "",
		name = "Silkspinner's Hunting Oil",
		progress = 800,
		profession = 11,
		clientId = 49674,
		itemId = 53127,
		experience = 8500,
		amount = 1,
		description = "Increases Attack Power against creatures from the Arachnids family by {25} for 10 minutes. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 49643,
				name = "Ethereal Solvent",
				itemId = 53096,
				amount = 1
			},
			{
				clientId = 49673,
				name = "Prime Extract",
				itemId = 53126,
				amount = 1
			},
			{
				clientId = 37631,
				name = "Spider Fangs",
				itemId = 41083,
				amount = 1
			}
		}
	},
	{
		quality = 0,
		durability = 11,
		specialization = "Poisoner",
		index = 83,
		formatDescription = "potionquality",
		slotName = "",
		name = "Emberwing Hunting Oil",
		progress = 850,
		profession = 11,
		clientId = 49668,
		itemId = 53121,
		experience = 10800,
		amount = 1,
		description = "Increases Attack Power against creatures from the Emberscale Drakes family by {25} for 10 minutes. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 49643,
				name = "Ethereal Solvent",
				itemId = 53096,
				amount = 1
			},
			{
				clientId = 49673,
				name = "Prime Extract",
				itemId = 53126,
				amount = 1
			},
			{
				clientId = 37627,
				name = "Red Drake Scales",
				itemId = 41079,
				amount = 1
			},
			{
				clientId = 40369,
				name = "Fire Cap",
				itemId = 43821,
				amount = 6
			},
			{
				clientId = 40348,
				name = "Cold Roots",
				itemId = 43800,
				amount = 4
			},
			{
				clientId = 40358,
				name = "Lizard's Delight",
				itemId = 43810,
				amount = 13
			}
		}
	},
	{
		quality = 0,
		durability = 11,
		specialization = "Poisoner",
		index = 84,
		formatDescription = "potionquality",
		slotName = "",
		name = "Spellwing Hunting Oil",
		progress = 850,
		profession = 11,
		clientId = 49675,
		itemId = 53128,
		experience = 10800,
		amount = 1,
		description = "Increases Attack Power against creatures from the Spellslayer Drakes family by {25} for 10 minutes. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 49643,
				name = "Ethereal Solvent",
				itemId = 53096,
				amount = 1
			},
			{
				clientId = 49673,
				name = "Prime Extract",
				itemId = 53126,
				amount = 1
			},
			{
				clientId = 37529,
				name = "Manaproof Scale",
				itemId = 40981,
				amount = 1
			},
			{
				clientId = 40369,
				name = "Fire Cap",
				itemId = 43821,
				amount = 6
			},
			{
				clientId = 40348,
				name = "Cold Roots",
				itemId = 43800,
				amount = 4
			},
			{
				clientId = 40358,
				name = "Lizard's Delight",
				itemId = 43810,
				amount = 13
			}
		}
	},
	{
		quality = 0,
		durability = 11,
		specialization = "Poisoner",
		index = 85,
		formatDescription = "potionquality",
		slotName = "",
		name = "Chillwing Hunting Oil",
		progress = 850,
		profession = 11,
		clientId = 49665,
		itemId = 53118,
		experience = 10800,
		amount = 1,
		description = "Increases Attack Power against creatures from the Frostbound Drakes family by {25} for 10 minutes. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 49643,
				name = "Ethereal Solvent",
				itemId = 53096,
				amount = 1
			},
			{
				clientId = 49673,
				name = "Prime Extract",
				itemId = 53126,
				amount = 1
			},
			{
				clientId = 46135,
				name = "Frozen Drake Claw",
				itemId = 49588,
				amount = 1
			},
			{
				clientId = 40369,
				name = "Fire Cap",
				itemId = 43821,
				amount = 6
			},
			{
				clientId = 40348,
				name = "Cold Roots",
				itemId = 43800,
				amount = 4
			},
			{
				clientId = 40358,
				name = "Lizard's Delight",
				itemId = 43810,
				amount = 13
			}
		}
	},
	{
		quality = 0,
		durability = 11,
		specialization = "Poisoner",
		index = 86,
		formatDescription = "potionquality",
		slotName = "",
		name = "Venomwing Hunting Oil",
		progress = 850,
		profession = 11,
		clientId = 49677,
		itemId = 53130,
		experience = 10800,
		amount = 1,
		description = "Increases Attack Power against creatures from the Venomfang Drakes family by {25} for 10 minutes. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 49643,
				name = "Ethereal Solvent",
				itemId = 53096,
				amount = 1
			},
			{
				clientId = 49673,
				name = "Prime Extract",
				itemId = 53126,
				amount = 1
			},
			{
				clientId = 37568,
				name = "Green Drake Scales ",
				itemId = 41020,
				amount = 1
			},
			{
				clientId = 40369,
				name = "Fire Cap",
				itemId = 43821,
				amount = 6
			},
			{
				clientId = 40348,
				name = "Cold Roots",
				itemId = 43800,
				amount = 4
			},
			{
				clientId = 40358,
				name = "Lizard's Delight",
				itemId = 43810,
				amount = 13
			}
		}
	},
	{
		quality = 0,
		durability = 10,
		specialization = "Poisoner",
		index = 87,
		formatDescription = "potionquality",
		slotName = "",
		name = "Eyerend Hunting Oil",
		progress = 800,
		profession = 11,
		clientId = 49669,
		itemId = 53122,
		experience = 8500,
		amount = 1,
		description = "Increases Attack Power against creatures from the Gazers family by {25} for 10 minutes. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 49643,
				name = "Ethereal Solvent",
				itemId = 53096,
				amount = 1
			},
			{
				clientId = 49673,
				name = "Prime Extract",
				itemId = 53126,
				amount = 1
			},
			{
				clientId = 37467,
				name = "Gazer Eye",
				itemId = 40919,
				amount = 1
			}
		}
	},
	{
		quality = 0,
		durability = 10,
		specialization = "Poisoner",
		index = 88,
		formatDescription = "potionquality",
		slotName = "",
		name = "Djinn's Gift Hunting Oil",
		progress = 800,
		profession = 11,
		clientId = 49667,
		itemId = 53120,
		experience = 8500,
		amount = 1,
		description = "Increases Attack Power against creatures from the Jackals family by {25} for 10 minutes. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 49643,
				name = "Ethereal Solvent",
				itemId = 53096,
				amount = 1
			},
			{
				clientId = 49673,
				name = "Prime Extract",
				itemId = 53126,
				amount = 1
			},
			{
				clientId = 43978,
				name = "Aether Dust",
				itemId = 47430,
				amount = 1
			}
		}
	},
	{
		quality = 0,
		durability = 10,
		specialization = "Poisoner",
		index = 89,
		formatDescription = "potionquality",
		slotName = "",
		name = "Sporewalker's Hunting Oil",
		progress = 800,
		profession = 11,
		clientId = 49676,
		itemId = 53129,
		experience = 8500,
		amount = 1,
		description = "Increases Attack Power against creatures from the Sporewalkers family by {25} for 10 minutes. 1 minute cooldown in between all poisons.",
		tier = -1,
		category = "Poison",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 49643,
				name = "Ethereal Solvent",
				itemId = 53096,
				amount = 1
			},
			{
				clientId = 49673,
				name = "Prime Extract",
				itemId = 53126,
				amount = 1
			},
			{
				clientId = 39568,
				name = "Mutated Tissue",
				itemId = 43020,
				amount = 1
			}
		}
	},
	{
		itemId = 53131,
		experience = 6500,
		durability = 11,
		index = 90,
		profession = 11,
		quality = 650,
		slotName = "",
		amount = 2,
		name = "Core Essence",
		progress = 600,
		description = "Used in various recipes. A liquid magical essence serving as a core component for Thaumaturgy Enchanted Elixirs.",
		clientId = 49678,
		tier = -1,
		category = "Material",
		level = {
			single = 68,
			mass = 73
		},
		materials = {
			{
				clientId = 49642,
				name = "Catalytic Solution",
				itemId = 53095,
				amount = 4
			},
			{
				clientId = 49646,
				name = "Resonating Fluid",
				itemId = 53099,
				amount = 4
			},
			{
				clientId = 49643,
				name = "Ethereal Solvent",
				itemId = 53096,
				amount = 4
			},
			{
				clientId = 37471,
				name = "Ethereal Essence",
				itemId = 40923,
				amount = 4
			},
			{
				clientId = 40349,
				name = "Crystal Leaf",
				itemId = 43801,
				amount = 6
			},
			{
				clientId = 40373,
				name = "Truffle",
				itemId = 43825,
				amount = 4
			}
		}
	},
	{
		quality = 0,
		durability = 10,
		specialization = "Thaumaturgist",
		index = 91,
		formatDescription = "potionquality",
		slotName = "",
		name = "Wealthbringer's Tonic",
		progress = 800,
		profession = 11,
		clientId = 40877,
		itemId = 44329,
		experience = 10100,
		amount = 1,
		description = "Increases your drop rate from Creatures by {10}% for 10 minutes. 10 minute cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 40368,
				name = "Brightday",
				itemId = 43820,
				amount = 26
			},
			{
				clientId = 40346,
				name = "Ambar Dust",
				itemId = 43798,
				amount = 16
			},
			{
				clientId = 49678,
				name = "Core Essence",
				itemId = 53131,
				amount = 1
			}
		}
	},
	{
		quality = 0,
		durability = 10,
		specialization = "Thaumaturgist",
		index = 92,
		formatDescription = "potionquality",
		slotName = "",
		name = "Tonic of Forbidden Knowledge",
		progress = 800,
		profession = 11,
		clientId = 49679,
		itemId = 53132,
		experience = 10100,
		amount = 1,
		description = "Increases your Experience obtained from Creatures by {7}% for 10 minutes. 10 minute cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 40362,
				name = "Purple Roots",
				itemId = 43814,
				amount = 6
			},
			{
				clientId = 40365,
				name = "Twisted Flower",
				itemId = 43817,
				amount = 4
			},
			{
				clientId = 49678,
				name = "Core Essence",
				itemId = 53131,
				amount = 1
			},
			{
				clientId = 39556,
				name = "Bizarre Grimoire",
				itemId = 43008,
				amount = 1
			}
		}
	},
	{
		quality = 0,
		durability = 10,
		specialization = "Thaumaturgist",
		index = 93,
		formatDescription = "potionquality",
		slotName = "",
		name = "Purifying Tonic",
		progress = 800,
		profession = 11,
		clientId = 40878,
		itemId = 44330,
		experience = 8500,
		amount = 1,
		description = "Removes up to 2 harmful effect afflicting the user and restores {500} Health. 10 minute cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 40347,
				name = "Chest Warmer",
				itemId = 43799,
				amount = 14
			},
			{
				clientId = 40361,
				name = "Pirate's Bliss",
				itemId = 43813,
				amount = 10
			},
			{
				clientId = 49678,
				name = "Core Essence",
				itemId = 53131,
				amount = 1
			}
		}
	},
	{
		quality = 0,
		durability = 10,
		specialization = "Thaumaturgist",
		index = 94,
		formatDescription = "potionquality",
		slotName = "",
		name = "Detoxifying Tonic",
		progress = 800,
		profession = 11,
		clientId = 40873,
		itemId = 44325,
		experience = 8500,
		amount = 1,
		description = "Remove all Alchemy Poisons and Spell Oils effects affecting you and restores 200 Mana. 1 minute cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 40363,
				name = "Shimmering Spores",
				itemId = 43815,
				amount = 12
			},
			{
				clientId = 40362,
				name = "Purple Roots",
				itemId = 43814,
				amount = 9
			},
			{
				clientId = 49678,
				name = "Core Essence",
				itemId = 53131,
				amount = 1
			}
		}
	},
	{
		quality = 0,
		durability = 10,
		specialization = "Thaumaturgist",
		index = 95,
		formatDescription = "potionquality",
		slotName = "",
		name = "Swiftmoa Tonic",
		progress = 800,
		profession = 11,
		clientId = 40875,
		itemId = 44327,
		experience = 8500,
		amount = 1,
		description = "Remove any temporary reduction in Movement Speed from yourself and increases Movement Speed on foot by {10}% for 12 seconds. 10 minute cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 40356,
				name = "Hagthorn",
				itemId = 43808,
				amount = 12
			},
			{
				clientId = 40370,
				name = "Refreshing Leaf",
				itemId = 43822,
				amount = 24
			},
			{
				clientId = 49678,
				name = "Core Essence",
				itemId = 53131,
				amount = 1
			}
		}
	},
	{
		quality = 0,
		durability = 12,
		specialization = "Thaumaturgist",
		index = 96,
		formatDescription = "potionquality",
		slotName = "",
		name = "Tonic of Gold",
		progress = 900,
		profession = 11,
		clientId = 40874,
		itemId = 44326,
		experience = 12150,
		amount = 1,
		description = "Increases Might, Dexterity, Inteligence, Wisdom, and Vitality by {20} for 5 minutes. 10 minute cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 40353,
				name = "Flaming Spores",
				itemId = 43805,
				amount = 8
			},
			{
				clientId = 40369,
				name = "Fire Cap",
				itemId = 43821,
				amount = 6
			},
			{
				clientId = 40362,
				name = "Purple Roots",
				itemId = 43814,
				amount = 6
			},
			{
				clientId = 40352,
				name = "Emerald Spores",
				itemId = 43804,
				amount = 10
			},
			{
				clientId = 49678,
				name = "Core Essence",
				itemId = 53131,
				amount = 1
			}
		}
	},
	{
		quality = 0,
		durability = 11,
		specialization = "Thaumaturgist",
		index = 97,
		formatDescription = "potionquality",
		slotName = "",
		name = "Tonic of Undying",
		progress = 850,
		profession = 11,
		clientId = 49680,
		itemId = 53133,
		experience = 11800,
		amount = 1,
		description = "Increases Defense Power by {15} and healing received by 10% for 2 minutes. 10 minute cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 73,
			mass = 78
		},
		materials = {
			{
				clientId = 40355,
				name = "Glowing Spores",
				itemId = 43807,
				amount = 11
			},
			{
				clientId = 40340,
				name = "Rocky Cap",
				itemId = 43792,
				amount = 4
			},
			{
				clientId = 40356,
				name = "Hagthorn",
				itemId = 43808,
				amount = 8
			},
			{
				clientId = 40352,
				name = "Emerald Spores",
				itemId = 43804,
				amount = 10
			},
			{
				clientId = 49678,
				name = "Core Essence",
				itemId = 53131,
				amount = 1
			}
		}
	},
	{
		quality = 0,
		durability = 11,
		specialization = "Thaumaturgist",
		index = 98,
		formatDescription = "potionquality",
		slotName = "",
		name = "Tonic of Savage Instinct",
		progress = 850,
		profession = 11,
		clientId = 40879,
		itemId = 44331,
		experience = 11500,
		amount = 1,
		description = "Increases Attack Power by {15} and attack speed by 10% for 2 minutes. 10 minute cooldown.",
		tier = -1,
		category = "Elixir",
		level = {
			single = 71,
			mass = 76
		},
		materials = {
			{
				clientId = 40337,
				name = "Shadow Stem",
				itemId = 43789,
				amount = 10
			},
			{
				clientId = 40366,
				name = "Wailing Leaf",
				itemId = 43818,
				amount = 6
			},
			{
				clientId = 40348,
				name = "Cold Roots",
				itemId = 43800,
				amount = 6
			},
			{
				clientId = 40352,
				name = "Emerald Spores",
				itemId = 43804,
				amount = 10
			},
			{
				clientId = 49678,
				name = "Core Essence",
				itemId = 53131,
				amount = 1
			}
		}
	},
	{
		itemId = 53097,
		experience = 2000,
		durability = 7,
		index = 99,
		profession = 11,
		quality = 250,
		slotName = "",
		amount = 7,
		name = "Purified Alcohol",
		progress = 200,
		description = "Used in various recipes. A highly refined alcohol, distilled to perfection for use in alchemical preparations..",
		clientId = 49644,
		tier = -1,
		category = "Material",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				clientId = 49944,
				name = "Fermented Corn Pulp",
				itemId = 53397,
				amount = 1
			}
		}
	},
	{
		itemId = 53097,
		experience = 5000,
		durability = 10,
		index = 100,
		profession = 11,
		quality = 525,
		slotName = "",
		amount = 18,
		name = "Purified Alcohol",
		progress = 475,
		description = "Used in various recipes. A highly refined alcohol, distilled to perfection for use in alchemical preparations..",
		clientId = 49644,
		tier = -1,
		category = "Material",
		level = {
			single = 65,
			mass = 70
		},
		materials = {
			{
				clientId = 49946,
				name = "Fermented Wheat Pulp",
				itemId = 53399,
				amount = 1
			}
		}
	},
	{
		itemId = 54174,
		experience = 1500,
		durability = 7,
		index = 101,
		profession = 11,
		quality = 0,
		slotName = "",
		amount = 3,
		name = "Superior Moa Remedy",
		progress = 250,
		description = "Used to boost Moa's Immunity when they are born. ",
		clientId = 50721,
		tier = -1,
		category = "Misc",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 40897,
				name = "Immunizer Base",
				itemId = 44349,
				amount = 2
			},
			{
				clientId = 40829,
				name = "Fish Roe",
				itemId = 44281,
				amount = 3
			},
			{
				clientId = 38162,
				name = "Moa Remedy",
				itemId = 41614,
				amount = 1
			}
		}
	},
	{
		itemId = 54175,
		experience = 2900,
		durability = 7,
		index = 102,
		profession = 11,
		quality = 0,
		slotName = "",
		amount = 3,
		name = "Rustic Moa Balm",
		progress = 300,
		description = "Used to boost Moa's Immunity when they are born. ",
		clientId = 50722,
		tier = -1,
		category = "Misc",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				clientId = 40897,
				name = "Immunizer Base",
				itemId = 44349,
				amount = 4
			},
			{
				clientId = 40834,
				name = "Yellow Fish Roe",
				itemId = 44286,
				amount = 2
			},
			{
				clientId = 50721,
				name = "Superior Moa Remedy",
				itemId = 54174,
				amount = 1
			}
		}
	},
	{
		itemId = 54176,
		experience = 4500,
		durability = 7,
		index = 103,
		profession = 11,
		quality = 0,
		slotName = "",
		amount = 3,
		name = "Refined Moa Treatment",
		progress = 425,
		description = "Used to boost Moa's Immunity when they are born. ",
		clientId = 50723,
		tier = -1,
		category = "Misc",
		level = {
			single = 40,
			mass = 45
		},
		materials = {
			{
				clientId = 40897,
				name = "Immunizer Base",
				itemId = 44349,
				amount = 6
			},
			{
				clientId = 40833,
				name = "Red Fish Roe",
				itemId = 44285,
				amount = 2
			},
			{
				clientId = 50722,
				name = "Rustic Moa Balm",
				itemId = 54175,
				amount = 1
			}
		}
	},
	{
		itemId = 54177,
		experience = 5500,
		durability = 8,
		index = 104,
		profession = 11,
		quality = 0,
		slotName = "",
		amount = 3,
		name = "Strong Moa Panacea",
		progress = 550,
		description = "Used to boost Moa's Immunity when they are born. ",
		clientId = 50724,
		tier = -1,
		category = "Misc",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 40898,
				name = "Potent immunizer Base",
				itemId = 44350,
				amount = 1
			},
			{
				clientId = 40828,
				name = "Fish Oil",
				itemId = 44280,
				amount = 4
			},
			{
				clientId = 50723,
				name = "Refined Moa Treatment",
				itemId = 54176,
				amount = 1
			},
			{
				clientId = 38162,
				name = "Moa Remedy",
				itemId = 41614,
				amount = 1
			}
		}
	},
	{
		itemId = 54178,
		experience = 10000,
		durability = 9,
		index = 105,
		profession = 11,
		quality = 0,
		slotName = "",
		amount = 3,
		name = "Mystical Moa  Remedy",
		progress = 600,
		description = "Used to boost Moa's Immunity when they are born. ",
		clientId = 50725,
		tier = -1,
		category = "Misc",
		level = {
			single = 60,
			mass = 65
		},
		materials = {
			{
				clientId = 40898,
				name = "Potent immunizer Base",
				itemId = 44350,
				amount = 3
			},
			{
				clientId = 40831,
				name = "Luminous Sack",
				itemId = 44283,
				amount = 4
			},
			{
				clientId = 50724,
				name = "Strong Moa Panacea",
				itemId = 54177,
				amount = 1
			}
		}
	},
	{
		itemId = 54179,
		experience = 15000,
		durability = 10,
		index = 106,
		profession = 11,
		quality = 0,
		slotName = "",
		amount = 3,
		name = "Moa's Bliss",
		progress = 700,
		description = "Used to boost Moa's Immunity when they are born. ",
		clientId = 50726,
		tier = -1,
		category = "Misc",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 40898,
				name = "Potent immunizer Base",
				itemId = 44350,
				amount = 5
			},
			{
				clientId = 40825,
				name = "Black Fish Roe",
				itemId = 44277,
				amount = 4
			},
			{
				clientId = 50725,
				name = "Mystical Moa  Remedy",
				itemId = 54178,
				amount = 1
			},
			{
				clientId = 38162,
				name = "Moa Remedy",
				itemId = 41614,
				amount = 2
			}
		}
	},
	{
		itemId = 44349,
		experience = 1500,
		durability = 6,
		index = 107,
		profession = 11,
		quality = 200,
		slotName = "",
		amount = 3,
		name = "Immunizer Base",
		progress = 150,
		description = "Used to create Moa Remedies. ",
		clientId = 40897,
		tier = -1,
		category = "Material",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 40357,
				name = "Juicy Roots",
				itemId = 43809,
				amount = 13
			},
			{
				clientId = 40372,
				name = "Thorny Roots",
				itemId = 43824,
				amount = 13
			},
			{
				clientId = 40354,
				name = "Fungal Dust",
				itemId = 43806,
				amount = 13
			},
			{
				clientId = 40363,
				name = "Shimmering Spores",
				itemId = 43815,
				amount = 13
			}
		}
	},
	{
		itemId = 44350,
		experience = 6300,
		durability = 7,
		index = 108,
		profession = 11,
		quality = 400,
		slotName = "",
		amount = 3,
		name = "Potent immunizer Base",
		progress = 375,
		description = "Used to create Moa Remedies. ",
		clientId = 40898,
		tier = -1,
		category = "Material",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 40897,
				name = "Immunizer Base",
				itemId = 44349,
				amount = 5
			},
			{
				clientId = 40355,
				name = "Glowing Spores",
				itemId = 43807,
				amount = 35
			},
			{
				clientId = 40360,
				name = "Numbing Thorns",
				itemId = 43812,
				amount = 35
			}
		}
	}
}
questRecipes = questRecipes or {}
questRecipes[ProfessionAlchemy] = {}
