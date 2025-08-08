-- chunkname: @/modules/game_profession/recipes/blacksmithing.lua

recipes = recipes or {}
recipes[ProfessionBlacksmithing] = {
	{
		itemId = 32158,
		experience = 480,
		durability = 4,
		index = 1,
		profession = 5,
		quality = 75,
		slotName = "",
		amount = 1,
		name = "copper ingot",
		progress = 25,
		description = "Used in various recipes. Symbolizes malleability and conductivity.",
		clientId = 28726,
		tier = -1,
		category = "ingots",
		level = {
			single = 1,
			mass = 6
		},
		materials = {
			{
				clientId = 28944,
				name = "copper ore",
				itemId = 32376,
				amount = 5
			}
		}
	},
	{
		itemId = 32155,
		experience = 800,
		durability = 7,
		index = 2,
		profession = 5,
		quality = 175,
		slotName = "",
		amount = 1,
		name = "iron ingot",
		progress = 175,
		description = "Used in various recipes. A versatile metallic ingot.",
		clientId = 28723,
		tier = -1,
		category = "ingots",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 28943,
				name = "iron ore",
				itemId = 32375,
				amount = 5
			}
		}
	},
	{
		itemId = 32156,
		experience = 1150,
		durability = 7,
		index = 3,
		profession = 5,
		quality = 200,
		slotName = "",
		amount = 1,
		name = "steel ingot",
		progress = 225,
		description = "Used in various recipes. Forged from a mix of metals.",
		clientId = 28724,
		tier = -1,
		category = "ingots",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				clientId = 28943,
				name = "iron ore",
				itemId = 32375,
				amount = 5
			},
			{
				clientId = 28941,
				name = "coal",
				itemId = 32373,
				amount = 2
			}
		}
	},
	{
		itemId = 32157,
		experience = 1650,
		durability = 8,
		index = 4,
		profession = 5,
		quality = 450,
		slotName = "",
		amount = 1,
		name = "cobalt ingot",
		progress = 450,
		description = "Used in various recipes. A rare blue-hued metal.",
		clientId = 28725,
		tier = -1,
		category = "ingots",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 28942,
				name = "cobalt ore",
				itemId = 32374,
				amount = 5
			},
			{
				clientId = 28941,
				name = "coal",
				itemId = 32373,
				amount = 3
			}
		}
	},
	{
		itemId = 32159,
		experience = 2600,
		durability = 9,
		index = 5,
		profession = 5,
		quality = 550,
		slotName = "",
		amount = 1,
		name = "titanium ingot",
		progress = 550,
		description = "Used in various recipes. Lightweight yet sturdy, resilient and versatile.",
		clientId = 28727,
		tier = -1,
		category = "ingots",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 28947,
				name = "titanium ore",
				itemId = 32379,
				amount = 5
			},
			{
				clientId = 28941,
				name = "coal",
				itemId = 32373,
				amount = 4
			}
		}
	},
	{
		itemId = 32492,
		experience = 2160,
		durability = 4,
		index = 6,
		profession = 5,
		quality = 100,
		slotName = "sword",
		amount = 1,
		name = "Warden's Sword",
		progress = 100,
		description = "",
		clientId = 29060,
		tier = 2,
		category = "weapons",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 2
			},
			{
				clientId = 35432,
				name = "Coarse Leather",
				itemId = 38864,
				amount = 1
			},
			{
				clientId = 29059,
				name = "Rough Sword",
				itemId = 32491,
				amount = 1
			}
		}
	},
	{
		itemId = 32425,
		experience = 2160,
		durability = 4,
		index = 7,
		profession = 5,
		quality = 100,
		slotName = "axe",
		amount = 1,
		name = "Marauder's Axe",
		progress = 100,
		description = "",
		clientId = 28993,
		tier = 2,
		category = "weapons",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 2
			},
			{
				clientId = 28743,
				name = "refined plank",
				itemId = 32175,
				amount = 1
			},
			{
				clientId = 28992,
				name = "Wicked Axe",
				itemId = 32424,
				amount = 1
			}
		}
	},
	{
		itemId = 32437,
		experience = 2160,
		durability = 4,
		index = 8,
		profession = 5,
		quality = 100,
		slotName = "club",
		amount = 1,
		name = "Studded Flail",
		progress = 100,
		description = "",
		clientId = 29005,
		tier = 2,
		category = "weapons",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 2
			},
			{
				clientId = 28743,
				name = "refined plank",
				itemId = 32175,
				amount = 1
			},
			{
				clientId = 29004,
				name = "Solid Mace",
				itemId = 32436,
				amount = 1
			}
		}
	},
	{
		itemId = 32443,
		experience = 2160,
		durability = 4,
		index = 9,
		profession = 5,
		quality = 100,
		slotName = "dagger",
		amount = 1,
		name = "Noble Dagger",
		progress = 100,
		description = "",
		clientId = 29011,
		tier = 2,
		category = "weapons",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 2
			},
			{
				clientId = 35432,
				name = "Coarse Leather",
				itemId = 38864,
				amount = 1
			},
			{
				clientId = 29010,
				name = "Serrated Dagger",
				itemId = 32442,
				amount = 1
			}
		}
	},
	{
		itemId = 32412,
		experience = 4320,
		durability = 4,
		index = 11,
		profession = 5,
		quality = 100,
		slotName = "greataxe",
		amount = 1,
		name = "Warrior's Greataxe",
		progress = 100,
		description = "",
		clientId = 28980,
		tier = 2,
		category = "weapons",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 4
			},
			{
				clientId = 28743,
				name = "refined plank",
				itemId = 32175,
				amount = 2
			},
			{
				clientId = 28978,
				name = "Rough Greataxe",
				itemId = 32410,
				amount = 1
			}
		}
	},
	{
		itemId = 32418,
		experience = 4320,
		durability = 4,
		index = 12,
		profession = 5,
		quality = 100,
		slotName = "greatsword",
		amount = 1,
		name = "Valiant Greatsword",
		progress = 100,
		description = "",
		clientId = 28986,
		tier = 2,
		category = "weapons",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 4
			},
			{
				clientId = 35432,
				name = "Coarse Leather",
				itemId = 38864,
				amount = 2
			},
			{
				clientId = 28985,
				name = "Burnished Greatsword",
				itemId = 32417,
				amount = 1
			}
		}
	},
	{
		itemId = 32449,
		experience = 4320,
		durability = 4,
		index = 13,
		profession = 5,
		quality = 100,
		slotName = "hammer",
		amount = 1,
		name = "Crushing Hammer",
		progress = 100,
		description = "",
		clientId = 29017,
		tier = 2,
		category = "weapons",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 4
			},
			{
				clientId = 28743,
				name = "refined plank",
				itemId = 32175,
				amount = 2
			},
			{
				clientId = 29016,
				name = "Shipbuilding Mallet",
				itemId = 32448,
				amount = 1
			}
		}
	},
	{
		itemId = 32493,
		experience = 7000,
		durability = 6,
		index = 14,
		profession = 5,
		quality = 100,
		slotName = "sword",
		amount = 1,
		name = "Lawbreaker's Sword",
		progress = 200,
		description = "",
		clientId = 29061,
		tier = 3,
		category = "weapons",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 28723,
				name = "iron ingot",
				itemId = 32155,
				amount = 5
			},
			{
				clientId = 35433,
				name = "Craftman's Leather",
				itemId = 38865,
				amount = 3
			},
			{
				clientId = 29060,
				name = "Warden's Sword",
				itemId = 32492,
				amount = 1
			},
			{
				clientId = 37478,
				name = "Ripper Fang",
				itemId = 40930,
				amount = 6
			}
		}
	},
	{
		itemId = 32426,
		experience = 7000,
		durability = 6,
		index = 15,
		profession = 5,
		quality = 100,
		slotName = "axe",
		amount = 1,
		name = "Dread Axe",
		progress = 200,
		description = "",
		clientId = 28994,
		tier = 3,
		category = "weapons",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 28723,
				name = "iron ingot",
				itemId = 32155,
				amount = 5
			},
			{
				clientId = 28743,
				name = "refined plank",
				itemId = 32175,
				amount = 4
			},
			{
				clientId = 28993,
				name = "Marauder's Axe",
				itemId = 32425,
				amount = 1
			},
			{
				clientId = 43212,
				name = "Sea Cured Leather",
				itemId = 46664,
				amount = 6
			}
		}
	},
	{
		itemId = 32438,
		experience = 7000,
		durability = 6,
		index = 16,
		profession = 5,
		quality = 100,
		slotName = "club",
		amount = 1,
		name = "Shieldbreaker's Flail",
		progress = 200,
		description = "",
		clientId = 29006,
		tier = 3,
		category = "weapons",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 28723,
				name = "iron ingot",
				itemId = 32155,
				amount = 5
			},
			{
				clientId = 28743,
				name = "refined plank",
				itemId = 32175,
				amount = 4
			},
			{
				clientId = 29005,
				name = "Studded Flail",
				itemId = 32437,
				amount = 1
			},
			{
				clientId = 43212,
				name = "Sea Cured Leather",
				itemId = 46664,
				amount = 6
			}
		}
	},
	{
		itemId = 32444,
		experience = 7000,
		durability = 6,
		index = 17,
		profession = 5,
		quality = 100,
		slotName = "dagger",
		amount = 1,
		name = "Ice Dagger",
		progress = 200,
		description = "",
		clientId = 29012,
		tier = 3,
		category = "weapons",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 28723,
				name = "iron ingot",
				itemId = 32155,
				amount = 5
			},
			{
				clientId = 35433,
				name = "Craftman's Leather",
				itemId = 38865,
				amount = 3
			},
			{
				clientId = 29011,
				name = "Noble Dagger",
				itemId = 32443,
				amount = 1
			},
			{
				clientId = 37478,
				name = "Ripper Fang",
				itemId = 40930,
				amount = 6
			}
		}
	},
	{
		itemId = 32413,
		experience = 14000,
		durability = 6,
		index = 19,
		profession = 5,
		quality = 100,
		slotName = "greataxe",
		amount = 1,
		name = "Savage Battle Axe",
		progress = 200,
		description = "",
		clientId = 28981,
		tier = 3,
		category = "weapons",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 28723,
				name = "iron ingot",
				itemId = 32155,
				amount = 10
			},
			{
				clientId = 28743,
				name = "refined plank",
				itemId = 32175,
				amount = 8
			},
			{
				clientId = 28980,
				name = "Warrior's Greataxe",
				itemId = 32412,
				amount = 1
			},
			{
				clientId = 43212,
				name = "Sea Cured Leather",
				itemId = 46664,
				amount = 12
			}
		}
	},
	{
		itemId = 32419,
		experience = 14000,
		durability = 6,
		index = 20,
		profession = 5,
		quality = 100,
		slotName = "greatsword",
		amount = 1,
		name = "Heroic Greatsword",
		progress = 200,
		description = "",
		clientId = 28987,
		tier = 3,
		category = "weapons",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 28723,
				name = "iron ingot",
				itemId = 32155,
				amount = 10
			},
			{
				clientId = 35433,
				name = "Craftman's Leather",
				itemId = 38865,
				amount = 6
			},
			{
				clientId = 28986,
				name = "Valiant Greatsword",
				itemId = 32418,
				amount = 1
			},
			{
				clientId = 37478,
				name = "Ripper Fang",
				itemId = 40930,
				amount = 12
			}
		}
	},
	{
		itemId = 32450,
		experience = 14000,
		durability = 6,
		index = 21,
		profession = 5,
		quality = 100,
		slotName = "hammer",
		amount = 1,
		name = "Punisher's Gavel",
		progress = 200,
		description = "",
		clientId = 29018,
		tier = 3,
		category = "weapons",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 28723,
				name = "iron ingot",
				itemId = 32155,
				amount = 10
			},
			{
				clientId = 28743,
				name = "refined plank",
				itemId = 32175,
				amount = 8
			},
			{
				clientId = 29017,
				name = "Crushing Hammer",
				itemId = 32449,
				amount = 1
			},
			{
				clientId = 43212,
				name = "Sea Cured Leather",
				itemId = 46664,
				amount = 12
			}
		}
	},
	{
		itemId = 32494,
		experience = 20000,
		durability = 7,
		index = 22,
		profession = 5,
		quality = 100,
		slotName = "sword",
		amount = 1,
		name = "Guardian's Longsword",
		progress = 350,
		description = "",
		clientId = 29062,
		tier = 4,
		category = "weapons",
		level = {
			single = 40,
			mass = 45
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 10
			},
			{
				clientId = 35434,
				name = "Tanned Leather",
				itemId = 38866,
				amount = 5
			},
			{
				clientId = 29061,
				name = "Lawbreaker's Sword",
				itemId = 32493,
				amount = 1
			},
			{
				clientId = 38268,
				name = "Thin Blade",
				itemId = 41720,
				amount = 8
			}
		}
	},
	{
		itemId = 32427,
		experience = 20000,
		durability = 7,
		index = 23,
		profession = 5,
		quality = 100,
		slotName = "axe",
		amount = 1,
		name = "Stormcarver Axe",
		progress = 350,
		description = "",
		clientId = 28995,
		tier = 4,
		category = "weapons",
		level = {
			single = 40,
			mass = 45
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 10
			},
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 7
			},
			{
				clientId = 28994,
				name = "Dread Axe",
				itemId = 32426,
				amount = 1
			},
			{
				clientId = 38272,
				name = "Metallic Core",
				itemId = 41724,
				amount = 8
			}
		}
	},
	{
		itemId = 32439,
		experience = 20000,
		durability = 7,
		index = 24,
		profession = 5,
		quality = 100,
		slotName = "club",
		amount = 1,
		name = "Ravenguard Morningstar",
		progress = 350,
		description = "",
		clientId = 29007,
		tier = 4,
		category = "weapons",
		level = {
			single = 40,
			mass = 45
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 10
			},
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 7
			},
			{
				clientId = 29006,
				name = "Shieldbreaker's Flail",
				itemId = 32438,
				amount = 1
			},
			{
				clientId = 37483,
				name = "Rough Steel Plate",
				itemId = 40935,
				amount = 8
			}
		}
	},
	{
		itemId = 32445,
		experience = 20000,
		durability = 7,
		index = 25,
		profession = 5,
		quality = 100,
		slotName = "dagger",
		amount = 1,
		name = "Heartstopper Dagger",
		progress = 350,
		description = "",
		clientId = 29013,
		tier = 4,
		category = "weapons",
		level = {
			single = 40,
			mass = 45
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 10
			},
			{
				clientId = 35434,
				name = "Tanned Leather",
				itemId = 38866,
				amount = 5
			},
			{
				clientId = 29012,
				name = "Ice Dagger",
				itemId = 32444,
				amount = 1
			},
			{
				clientId = 38265,
				name = "Cunning Handle",
				itemId = 41717,
				amount = 8
			}
		}
	},
	{
		itemId = 32414,
		experience = 40000,
		durability = 7,
		index = 27,
		profession = 5,
		quality = 100,
		slotName = "greataxe",
		amount = 1,
		name = "Hangman's Greataxe",
		progress = 350,
		description = "",
		clientId = 28982,
		tier = 4,
		category = "weapons",
		level = {
			single = 40,
			mass = 45
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 20
			},
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 14
			},
			{
				clientId = 28981,
				name = "Savage Battle Axe",
				itemId = 32413,
				amount = 1
			},
			{
				clientId = 38272,
				name = "Metallic Core",
				itemId = 41724,
				amount = 16
			}
		}
	},
	{
		itemId = 32420,
		experience = 40000,
		durability = 7,
		index = 28,
		profession = 5,
		quality = 100,
		slotName = "greatsword",
		amount = 1,
		name = "Bonebiter Greatsword",
		progress = 350,
		description = "",
		clientId = 28988,
		tier = 4,
		category = "weapons",
		level = {
			single = 40,
			mass = 45
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 20
			},
			{
				clientId = 35434,
				name = "Tanned Leather",
				itemId = 38866,
				amount = 10
			},
			{
				clientId = 28987,
				name = "Heroic Greatsword",
				itemId = 32419,
				amount = 1
			},
			{
				clientId = 38268,
				name = "Thin Blade",
				itemId = 41720,
				amount = 16
			}
		}
	},
	{
		itemId = 32451,
		experience = 40000,
		durability = 7,
		index = 29,
		profession = 5,
		quality = 100,
		slotName = "hammer",
		amount = 1,
		name = "Lawgiver's Warhammer",
		progress = 350,
		description = "",
		clientId = 29019,
		tier = 4,
		category = "weapons",
		level = {
			single = 40,
			mass = 45
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 20
			},
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 14
			},
			{
				clientId = 29018,
				name = "Punisher's Gavel",
				itemId = 32450,
				amount = 1
			},
			{
				clientId = 37483,
				name = "Rough Steel Plate",
				itemId = 40935,
				amount = 16
			}
		}
	},
	{
		itemId = 32495,
		experience = 40000,
		durability = 8,
		index = 30,
		profession = 5,
		quality = 100,
		slotName = "sword",
		amount = 1,
		name = "Crusader's Longsword",
		progress = 525,
		description = "",
		clientId = 29063,
		tier = 5,
		category = "weapons",
		level = {
			single = 55,
			mass = 60
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 14
			},
			{
				clientId = 35435,
				name = "Merchant's Leather",
				itemId = 38867,
				amount = 7
			},
			{
				clientId = 29062,
				name = "Guardian's Longsword",
				itemId = 32494,
				amount = 1
			},
			{
				clientId = 40265,
				name = "Ancient Metallic Scrap",
				itemId = 43717,
				amount = 10
			}
		}
	},
	{
		itemId = 32428,
		experience = 40000,
		durability = 8,
		index = 31,
		profession = 5,
		quality = 100,
		slotName = "axe",
		amount = 1,
		name = "Hellblade Axe",
		progress = 525,
		description = "",
		clientId = 28996,
		tier = 5,
		category = "weapons",
		level = {
			single = 55,
			mass = 60
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 14
			},
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 11
			},
			{
				clientId = 28995,
				name = "Stormcarver Axe",
				itemId = 32427,
				amount = 1
			},
			{
				clientId = 40268,
				name = "Cutting Edge Scrap",
				itemId = 43720,
				amount = 10
			}
		}
	},
	{
		itemId = 32440,
		experience = 40000,
		durability = 8,
		index = 32,
		profession = 5,
		quality = 100,
		slotName = "club",
		amount = 1,
		name = "Enforcer's Mace",
		progress = 525,
		description = "",
		clientId = 29008,
		tier = 5,
		category = "weapons",
		level = {
			single = 55,
			mass = 60
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 14
			},
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 11
			},
			{
				clientId = 29007,
				name = "Ravenguard Morningstar",
				itemId = 32439,
				amount = 1
			},
			{
				clientId = 40274,
				name = "Heavy Metal Chunks",
				itemId = 43726,
				amount = 10
			}
		}
	},
	{
		itemId = 32446,
		experience = 40000,
		durability = 8,
		index = 33,
		profession = 5,
		quality = 100,
		slotName = "dagger",
		amount = 1,
		name = "Assassin's Dagger",
		progress = 525,
		description = "",
		clientId = 29014,
		tier = 5,
		category = "weapons",
		level = {
			single = 55,
			mass = 60
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 14
			},
			{
				clientId = 35435,
				name = "Merchant's Leather",
				itemId = 38867,
				amount = 7
			},
			{
				clientId = 29013,
				name = "Heartstopper Dagger",
				itemId = 32445,
				amount = 1
			},
			{
				clientId = 40280,
				name = "Twisted Blades",
				itemId = 43732,
				amount = 10
			}
		}
	},
	{
		itemId = 32415,
		experience = 80000,
		durability = 8,
		index = 35,
		profession = 5,
		quality = 100,
		slotName = "greataxe",
		amount = 1,
		name = "Orcish Battle Axe",
		progress = 525,
		description = "",
		clientId = 28983,
		tier = 5,
		category = "weapons",
		level = {
			single = 55,
			mass = 60
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 28
			},
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 22
			},
			{
				clientId = 28982,
				name = "Hangman's Greataxe",
				itemId = 32414,
				amount = 1
			},
			{
				clientId = 40268,
				name = "Cutting Edge Scrap",
				itemId = 43720,
				amount = 20
			}
		}
	},
	{
		itemId = 32421,
		experience = 80000,
		durability = 8,
		index = 36,
		profession = 5,
		quality = 100,
		slotName = "greatsword",
		amount = 1,
		name = "Samurai's Daikatana",
		progress = 525,
		description = "",
		clientId = 28989,
		tier = 5,
		category = "weapons",
		level = {
			single = 55,
			mass = 60
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 28
			},
			{
				clientId = 35435,
				name = "Merchant's Leather",
				itemId = 38867,
				amount = 14
			},
			{
				clientId = 28988,
				name = "Bonebiter Greatsword",
				itemId = 32420,
				amount = 1
			},
			{
				clientId = 40265,
				name = "Ancient Metallic Scrap",
				itemId = 43717,
				amount = 20
			}
		}
	},
	{
		itemId = 32452,
		experience = 80000,
		durability = 8,
		index = 37,
		profession = 5,
		quality = 100,
		slotName = "hammer",
		amount = 1,
		name = "Dwarven Warhammer",
		progress = 525,
		description = "",
		clientId = 29020,
		tier = 5,
		category = "weapons",
		level = {
			single = 55,
			mass = 60
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 28
			},
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 22
			},
			{
				clientId = 29019,
				name = "Lawgiver's Warhammer",
				itemId = 32451,
				amount = 1
			},
			{
				clientId = 40274,
				name = "Heavy Metal Chunks",
				itemId = 43726,
				amount = 20
			}
		}
	},
	{
		itemId = 32119,
		experience = 1200,
		durability = 4,
		index = 38,
		profession = 5,
		quality = 100,
		slotName = "plate armor",
		amount = 1,
		name = "Crescent Armor",
		progress = 100,
		description = "",
		clientId = 28687,
		tier = 2,
		category = "armors",
		level = {
			single = 13,
			mass = 18
		},
		materials = {
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 2
			},
			{
				clientId = 35432,
				name = "Coarse Leather",
				itemId = 38864,
				amount = 1
			},
			{
				clientId = 28678,
				name = "Pliant Armor",
				itemId = 32110,
				amount = 1
			}
		}
	},
	{
		itemId = 32120,
		experience = 1200,
		durability = 4,
		index = 39,
		profession = 5,
		quality = 100,
		slotName = "plate helmet",
		amount = 1,
		name = "Crescent Helmet",
		progress = 100,
		description = "",
		clientId = 28688,
		tier = 2,
		category = "armors",
		level = {
			single = 16,
			mass = 21
		},
		materials = {
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 2
			},
			{
				clientId = 35432,
				name = "Coarse Leather",
				itemId = 38864,
				amount = 1
			},
			{
				clientId = 28684,
				name = "Pliant Helmet",
				itemId = 32116,
				amount = 1
			}
		}
	},
	{
		itemId = 32123,
		experience = 1200,
		durability = 4,
		index = 40,
		profession = 5,
		quality = 100,
		slotName = "plate legs",
		amount = 1,
		name = "Crescent Legs",
		progress = 100,
		description = "",
		clientId = 28691,
		tier = 2,
		category = "armors",
		level = {
			single = 19,
			mass = 24
		},
		materials = {
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 2
			},
			{
				clientId = 35432,
				name = "Coarse Leather",
				itemId = 38864,
				amount = 1
			},
			{
				clientId = 28685,
				name = "Pliant Legs",
				itemId = 32117,
				amount = 1
			}
		}
	},
	{
		itemId = 32127,
		experience = 1200,
		durability = 4,
		index = 41,
		profession = 5,
		quality = 100,
		slotName = "plate boots",
		amount = 1,
		name = "Crescent Boots",
		progress = 100,
		description = "",
		clientId = 28695,
		tier = 2,
		category = "armors",
		level = {
			single = 22,
			mass = 27
		},
		materials = {
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 2
			},
			{
				clientId = 35432,
				name = "Coarse Leather",
				itemId = 38864,
				amount = 1
			},
			{
				clientId = 28681,
				name = "Pliant Boots",
				itemId = 32113,
				amount = 1
			}
		}
	},
	{
		itemId = 32128,
		experience = 5800,
		durability = 7,
		index = 42,
		profession = 5,
		quality = 100,
		slotName = "plate armor",
		amount = 1,
		name = "Harbinger Armor",
		progress = 200,
		description = "",
		clientId = 28696,
		tier = 3,
		category = "armors",
		level = {
			single = 28,
			mass = 33
		},
		materials = {
			{
				clientId = 28723,
				name = "iron ingot",
				itemId = 32155,
				amount = 4
			},
			{
				clientId = 35433,
				name = "Craftman's Leather",
				itemId = 38865,
				amount = 2
			},
			{
				clientId = 28687,
				name = "Crescent Armor",
				itemId = 32119,
				amount = 1
			},
			{
				clientId = 37479,
				name = "Shell Fragment",
				itemId = 40931,
				amount = 3
			}
		}
	},
	{
		itemId = 32134,
		experience = 5800,
		durability = 7,
		index = 43,
		profession = 5,
		quality = 100,
		slotName = "plate helmet",
		amount = 1,
		name = "Harbinger Helmet",
		progress = 200,
		description = "",
		clientId = 28702,
		tier = 3,
		category = "armors",
		level = {
			single = 31,
			mass = 36
		},
		materials = {
			{
				clientId = 28723,
				name = "iron ingot",
				itemId = 32155,
				amount = 4
			},
			{
				clientId = 35433,
				name = "Craftman's Leather",
				itemId = 38865,
				amount = 2
			},
			{
				clientId = 28688,
				name = "Crescent Helmet",
				itemId = 32120,
				amount = 1
			},
			{
				clientId = 37479,
				name = "Shell Fragment",
				itemId = 40931,
				amount = 3
			}
		}
	},
	{
		itemId = 32135,
		experience = 5800,
		durability = 7,
		index = 44,
		profession = 5,
		quality = 100,
		slotName = "plate legs",
		amount = 1,
		name = "Harbinger Legs",
		progress = 200,
		description = "",
		clientId = 28703,
		tier = 3,
		category = "armors",
		level = {
			single = 34,
			mass = 39
		},
		materials = {
			{
				clientId = 28723,
				name = "iron ingot",
				itemId = 32155,
				amount = 4
			},
			{
				clientId = 35433,
				name = "Craftman's Leather",
				itemId = 38865,
				amount = 2
			},
			{
				clientId = 28691,
				name = "Crescent Legs",
				itemId = 32123,
				amount = 1
			},
			{
				clientId = 37479,
				name = "Shell Fragment",
				itemId = 40931,
				amount = 3
			}
		}
	},
	{
		itemId = 32131,
		experience = 5800,
		durability = 7,
		index = 45,
		profession = 5,
		quality = 100,
		slotName = "plate boots",
		amount = 1,
		name = "Harbinger Boots",
		progress = 200,
		description = "",
		clientId = 28699,
		tier = 3,
		category = "armors",
		level = {
			single = 37,
			mass = 42
		},
		materials = {
			{
				clientId = 28723,
				name = "iron ingot",
				itemId = 32155,
				amount = 4
			},
			{
				clientId = 35433,
				name = "Craftman's Leather",
				itemId = 38865,
				amount = 2
			},
			{
				clientId = 28695,
				name = "Crescent Boots",
				itemId = 32127,
				amount = 1
			},
			{
				clientId = 37479,
				name = "Shell Fragment",
				itemId = 40931,
				amount = 3
			}
		}
	},
	{
		itemId = 32137,
		experience = 11300,
		durability = 7,
		index = 46,
		profession = 5,
		quality = 100,
		slotName = "plate armor",
		amount = 1,
		name = "Enforcer Armor",
		progress = 350,
		description = "",
		clientId = 28705,
		tier = 4,
		category = "armors",
		level = {
			single = 43,
			mass = 48
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 6
			},
			{
				clientId = 35434,
				name = "Tanned Leather",
				itemId = 38866,
				amount = 3
			},
			{
				clientId = 28696,
				name = "Harbinger Armor",
				itemId = 32128,
				amount = 1
			},
			{
				clientId = 38267,
				name = "Internal Padding",
				itemId = 41719,
				amount = 4
			}
		}
	},
	{
		itemId = 32143,
		experience = 11300,
		durability = 7,
		index = 47,
		profession = 5,
		quality = 100,
		slotName = "plate helmet",
		amount = 1,
		name = "Enforcer Helmet",
		progress = 350,
		description = "",
		clientId = 28711,
		tier = 4,
		category = "armors",
		level = {
			single = 46,
			mass = 51
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 6
			},
			{
				clientId = 35434,
				name = "Tanned Leather",
				itemId = 38866,
				amount = 3
			},
			{
				clientId = 28702,
				name = "Harbinger Helmet",
				itemId = 32134,
				amount = 1
			},
			{
				clientId = 38267,
				name = "Internal Padding",
				itemId = 41719,
				amount = 4
			}
		}
	},
	{
		itemId = 32144,
		experience = 11300,
		durability = 7,
		index = 48,
		profession = 5,
		quality = 100,
		slotName = "plate legs",
		amount = 1,
		name = "Enforcer Legs",
		progress = 350,
		description = "",
		clientId = 28712,
		tier = 4,
		category = "armors",
		level = {
			single = 49,
			mass = 54
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 6
			},
			{
				clientId = 35434,
				name = "Tanned Leather",
				itemId = 38866,
				amount = 3
			},
			{
				clientId = 28703,
				name = "Harbinger Legs",
				itemId = 32135,
				amount = 1
			},
			{
				clientId = 38267,
				name = "Internal Padding",
				itemId = 41719,
				amount = 4
			}
		}
	},
	{
		itemId = 32140,
		experience = 11300,
		durability = 7,
		index = 49,
		profession = 5,
		quality = 100,
		slotName = "plate boots",
		amount = 1,
		name = "Enforcer Boots",
		progress = 350,
		description = "",
		clientId = 28708,
		tier = 4,
		category = "armors",
		level = {
			single = 52,
			mass = 57
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 6
			},
			{
				clientId = 35434,
				name = "Tanned Leather",
				itemId = 38866,
				amount = 3
			},
			{
				clientId = 28699,
				name = "Harbinger Boots",
				itemId = 32131,
				amount = 1
			},
			{
				clientId = 38267,
				name = "Internal Padding",
				itemId = 41719,
				amount = 4
			}
		}
	},
	{
		itemId = 32146,
		experience = 24000,
		durability = 9,
		index = 50,
		profession = 5,
		quality = 100,
		slotName = "plate armor",
		amount = 1,
		name = "Protector's Armor",
		progress = 525,
		description = "",
		clientId = 28714,
		tier = 5,
		category = "armors",
		level = {
			single = 58,
			mass = 63
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 9
			},
			{
				clientId = 35435,
				name = "Merchant's Leather",
				itemId = 38867,
				amount = 4
			},
			{
				clientId = 28705,
				name = "Enforcer Armor",
				itemId = 32137,
				amount = 1
			},
			{
				clientId = 37507,
				name = "Ancient Ingot",
				itemId = 40959,
				amount = 5
			}
		}
	},
	{
		itemId = 32152,
		experience = 24000,
		durability = 9,
		index = 51,
		profession = 5,
		quality = 100,
		slotName = "plate helmet",
		amount = 1,
		name = "Protector's Helmet",
		progress = 525,
		description = "",
		clientId = 28720,
		tier = 5,
		category = "armors",
		level = {
			single = 61,
			mass = 66
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 9
			},
			{
				clientId = 35435,
				name = "Merchant's Leather",
				itemId = 38867,
				amount = 4
			},
			{
				clientId = 28711,
				name = "Enforcer Helmet",
				itemId = 32143,
				amount = 1
			},
			{
				clientId = 37507,
				name = "Ancient Ingot",
				itemId = 40959,
				amount = 5
			}
		}
	},
	{
		itemId = 32153,
		experience = 24000,
		durability = 9,
		index = 52,
		profession = 5,
		quality = 100,
		slotName = "plate legs",
		amount = 1,
		name = "Protector's Legs",
		progress = 525,
		description = "",
		clientId = 28721,
		tier = 5,
		category = "armors",
		level = {
			single = 64,
			mass = 69
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 9
			},
			{
				clientId = 35435,
				name = "Merchant's Leather",
				itemId = 38867,
				amount = 4
			},
			{
				clientId = 28712,
				name = "Enforcer Legs",
				itemId = 32144,
				amount = 1
			},
			{
				clientId = 37507,
				name = "Ancient Ingot",
				itemId = 40959,
				amount = 5
			}
		}
	},
	{
		itemId = 32149,
		experience = 24000,
		durability = 9,
		index = 53,
		profession = 5,
		quality = 100,
		slotName = "plate boots",
		amount = 1,
		name = "Protector's Boots",
		progress = 525,
		description = "",
		clientId = 28717,
		tier = 5,
		category = "armors",
		level = {
			single = 67,
			mass = 72
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 9
			},
			{
				clientId = 35435,
				name = "Merchant's Leather",
				itemId = 38867,
				amount = 4
			},
			{
				clientId = 28708,
				name = "Enforcer Boots",
				itemId = 32140,
				amount = 1
			},
			{
				clientId = 37507,
				name = "Ancient Ingot",
				itemId = 40959,
				amount = 5
			}
		}
	},
	{
		quality = 50,
		durability = 4,
		index = 54,
		formatDescription = "quality",
		slotName = "",
		name = "whetstone",
		progress = 75,
		profession = 5,
		clientId = 28426,
		itemId = 31858,
		experience = 180,
		amount = 1,
		description = "Increases Attack Power of your equipped weapons by {1} for 30 minutes. This effect is doubled for two-handed weapons.",
		tier = -1,
		category = "whetstones",
		level = {
			single = 3,
			mass = 8
		},
		materials = {
			{
				clientId = 28946,
				name = "stone",
				itemId = 32378,
				amount = 3
			}
		}
	},
	{
		quality = 150,
		durability = 6,
		index = 55,
		formatDescription = "quality",
		slotName = "",
		name = "coarse whetstone",
		progress = 175,
		profession = 5,
		clientId = 28427,
		itemId = 31859,
		experience = 550,
		amount = 1,
		description = "Increases Attack Power of your equipped weapons by {3} for 30 minutes. This effect is doubled for two-handed weapons.",
		tier = -1,
		category = "whetstones",
		level = {
			single = 18,
			mass = 23
		},
		materials = {
			{
				clientId = 28946,
				name = "stone",
				itemId = 32378,
				amount = 6
			},
			{
				clientId = 28941,
				name = "coal",
				itemId = 32373,
				amount = 1
			}
		}
	},
	{
		quality = 200,
		durability = 7,
		index = 56,
		formatDescription = "quality",
		slotName = "",
		name = "Heavy Whetstone",
		progress = 225,
		profession = 5,
		clientId = 35437,
		itemId = 38869,
		experience = 960,
		amount = 1,
		description = "Increases Attack Power of your equipped weapons by {5} for 30 minutes. This effect is doubled for two-handed weapons.",
		tier = -1,
		category = "whetstones",
		level = {
			single = 33,
			mass = 38
		},
		materials = {
			{
				clientId = 28946,
				name = "stone",
				itemId = 32378,
				amount = 10
			},
			{
				clientId = 28941,
				name = "coal",
				itemId = 32373,
				amount = 2
			}
		}
	},
	{
		quality = 325,
		durability = 8,
		index = 57,
		formatDescription = "quality",
		slotName = "",
		name = "Solid Whetstone",
		progress = 350,
		profession = 5,
		clientId = 35438,
		itemId = 38870,
		experience = 1450,
		amount = 1,
		description = "Increases Attack Power of your equipped weapons by {7} for 30 minutes. This effect is doubled for two-handed weapons.",
		tier = -1,
		category = "whetstones",
		level = {
			single = 48,
			mass = 53
		},
		materials = {
			{
				clientId = 28946,
				name = "stone",
				itemId = 32378,
				amount = 15
			},
			{
				clientId = 28941,
				name = "coal",
				itemId = 32373,
				amount = 3
			}
		}
	},
	{
		quality = 450,
		durability = 9,
		specialization = "Craftsman",
		index = 58,
		formatDescription = "quality",
		slotName = "",
		name = "dense whetstone",
		progress = 500,
		profession = 5,
		clientId = 28428,
		itemId = 31860,
		experience = 2400,
		amount = 1,
		description = "Increases Attack Power of your equipped weapons by {10} for 30 minutes. This effect is doubled for two-handed weapons.",
		tier = -1,
		category = "whetstones",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 28946,
				name = "stone",
				itemId = 32378,
				amount = 25
			},
			{
				clientId = 28941,
				name = "coal",
				itemId = 32373,
				amount = 5
			}
		}
	},
	{
		itemId = 32320,
		experience = 2000,
		durability = 4,
		index = 59,
		profession = 5,
		quality = 0,
		slotName = "fishing hook",
		amount = 1,
		name = "copper fishing hook",
		progress = 100,
		description = "",
		clientId = 28888,
		tier = 1,
		category = "fishing",
		level = {
			single = 7,
			mass = 12
		},
		materials = {
			{
				clientId = 28726,
				name = "copper ingot",
				itemId = 32158,
				amount = 4
			}
		}
	},
	{
		itemId = 32318,
		experience = 4800,
		durability = 7,
		index = 60,
		profession = 5,
		quality = 0,
		slotName = "fishing hook",
		amount = 1,
		name = "complex fishing hook",
		progress = 200,
		description = "",
		clientId = 28886,
		tier = 2,
		category = "fishing",
		level = {
			single = 22,
			mass = 27
		},
		materials = {
			{
				clientId = 28723,
				name = "iron ingot",
				itemId = 32155,
				amount = 6
			},
			{
				clientId = 28888,
				name = "copper fishing hook",
				itemId = 32320,
				amount = 1
			}
		}
	},
	{
		itemId = 32316,
		experience = 11500,
		durability = 7,
		index = 61,
		profession = 5,
		quality = 0,
		slotName = "fishing hook",
		amount = 1,
		name = "steel fishing hook",
		progress = 350,
		description = "",
		clientId = 28884,
		tier = 3,
		category = "fishing",
		level = {
			single = 37,
			mass = 42
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 10
			},
			{
				clientId = 28886,
				name = "complex fishing hook",
				itemId = 32318,
				amount = 1
			}
		}
	},
	{
		itemId = 32319,
		experience = 21450,
		durability = 8,
		index = 62,
		profession = 5,
		quality = 0,
		slotName = "fishing hook",
		amount = 1,
		name = "cobalt fishing hook",
		progress = 475,
		description = "",
		clientId = 28887,
		tier = 4,
		category = "fishing",
		level = {
			single = 52,
			mass = 57
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 13
			},
			{
				clientId = 28884,
				name = "steel fishing hook",
				itemId = 32316,
				amount = 1
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		itemId = 32317,
		index = 63,
		slotName = "fishing hook",
		name = "titanium fishing hook",
		progress = 600,
		profession = 5,
		clientId = 28885,
		durability = 9,
		experience = 39000,
		specialization = "Craftsman",
		description = "",
		tier = 5,
		category = "fishing",
		level = {
			single = 72,
			mass = 77
		},
		materials = {
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 15
			},
			{
				clientId = 28887,
				name = "cobalt fishing hook",
				itemId = 32319,
				amount = 1
			}
		}
	},
	{
		itemId = 40560,
		experience = 4320,
		durability = 4,
		index = 64,
		profession = 5,
		quality = 100,
		slotName = "light blade",
		amount = 1,
		name = "Swashbuckler's Blade",
		progress = 100,
		description = "",
		clientId = 37108,
		tier = 2,
		category = "weapons",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 4
			},
			{
				clientId = 35432,
				name = "Coarse Leather",
				itemId = 38864,
				amount = 2
			},
			{
				clientId = 37107,
				name = "Skirmisher's Blade",
				itemId = 40559,
				amount = 1
			}
		}
	},
	{
		itemId = 40561,
		experience = 14000,
		durability = 6,
		index = 65,
		profession = 5,
		quality = 100,
		slotName = "light blade",
		amount = 1,
		name = "Serpentine Blade",
		progress = 200,
		description = "",
		clientId = 37109,
		tier = 3,
		category = "weapons",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 28723,
				name = "iron ingot",
				itemId = 32155,
				amount = 10
			},
			{
				clientId = 35433,
				name = "Craftman's Leather",
				itemId = 38865,
				amount = 5
			},
			{
				clientId = 37108,
				name = "Swashbuckler's Blade",
				itemId = 40560,
				amount = 1
			},
			{
				clientId = 37478,
				name = "Ripper Fang",
				itemId = 40930,
				amount = 12
			}
		}
	},
	{
		itemId = 40562,
		experience = 40000,
		durability = 7,
		index = 66,
		profession = 5,
		quality = 100,
		slotName = "light blade",
		amount = 1,
		name = "Duelist's Companion",
		progress = 350,
		description = "",
		clientId = 37110,
		tier = 4,
		category = "weapons",
		level = {
			single = 40,
			mass = 45
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 20
			},
			{
				clientId = 35434,
				name = "Tanned Leather",
				itemId = 38866,
				amount = 10
			},
			{
				clientId = 37109,
				name = "Serpentine Blade",
				itemId = 40561,
				amount = 1
			},
			{
				clientId = 38265,
				name = "Cunning Handle",
				itemId = 41717,
				amount = 16
			}
		}
	},
	{
		itemId = 40563,
		experience = 80000,
		durability = 8,
		index = 67,
		profession = 5,
		quality = 100,
		slotName = "light blade",
		amount = 1,
		name = "Ornamented Saber",
		progress = 525,
		description = "",
		clientId = 37111,
		tier = 5,
		category = "weapons",
		level = {
			single = 55,
			mass = 60
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 28
			},
			{
				clientId = 35435,
				name = "Merchant's Leather",
				itemId = 38867,
				amount = 14
			},
			{
				clientId = 37110,
				name = "Duelist's Companion",
				itemId = 40562,
				amount = 1
			},
			{
				clientId = 40280,
				name = "Twisted Blades",
				itemId = 43732,
				amount = 20
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 40610,
		index = 68,
		slotName = "sword",
		name = "Champion's Longsword",
		progress = 700,
		profession = 5,
		clientId = 37158,
		durability = 12,
		experience = 62000,
		specialization = "Dwarven Weaponsmith",
		description = "",
		tier = 6,
		category = "weapons",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 15
			},
			{
				clientId = 35436,
				name = "Artisan Leather",
				itemId = 38868,
				amount = 7
			},
			{
				clientId = 29063,
				name = "Crusader's Longsword",
				itemId = 32495,
				amount = 1
			},
			{
				clientId = 40267,
				name = "Crude Runed Tip",
				itemId = 43719,
				amount = 12
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 40606,
		index = 69,
		slotName = "axe",
		name = "Dragonbane Axe",
		progress = 700,
		profession = 5,
		clientId = 37154,
		durability = 12,
		experience = 62000,
		specialization = "Dwarven Weaponsmith",
		description = "",
		tier = 6,
		category = "weapons",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 15
			},
			{
				clientId = 45503,
				name = "Fine Plank",
				itemId = 48955,
				amount = 10
			},
			{
				clientId = 28996,
				name = "Hellblade Axe",
				itemId = 32428,
				amount = 1
			},
			{
				clientId = 40278,
				name = "Sturdy Joint",
				itemId = 43730,
				amount = 12
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 40608,
		index = 70,
		slotName = "club",
		name = "Skullbasher Mace",
		progress = 700,
		profession = 5,
		clientId = 37156,
		durability = 12,
		experience = 62000,
		specialization = "Dwarven Weaponsmith",
		description = "",
		tier = 6,
		category = "weapons",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 15
			},
			{
				clientId = 45503,
				name = "Fine Plank",
				itemId = 48955,
				amount = 10
			},
			{
				clientId = 29008,
				name = "Enforcer's Mace",
				itemId = 32440,
				amount = 1
			},
			{
				clientId = 40275,
				name = "Polished Plate Scraps",
				itemId = 43727,
				amount = 12
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 40603,
		index = 71,
		slotName = "dagger",
		name = "Ritual Dagger",
		progress = 700,
		profession = 5,
		clientId = 37151,
		durability = 12,
		experience = 62000,
		specialization = "Dwarven Weaponsmith",
		description = "",
		tier = 6,
		category = "weapons",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 15
			},
			{
				clientId = 35436,
				name = "Artisan Leather",
				itemId = 38868,
				amount = 7
			},
			{
				clientId = 29014,
				name = "Assassin's Dagger",
				itemId = 32446,
				amount = 1
			},
			{
				clientId = 40277,
				name = "Sharp Edges",
				itemId = 43729,
				amount = 12
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 40564,
		index = 73,
		slotName = "light blade",
		name = "Scarlet Thorn",
		progress = 700,
		profession = 5,
		clientId = 37112,
		durability = 12,
		experience = 124000,
		specialization = "Dwarven Weaponsmith",
		description = "",
		tier = 6,
		category = "weapons",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 30
			},
			{
				clientId = 35436,
				name = "Artisan Leather",
				itemId = 38868,
				amount = 14
			},
			{
				clientId = 37111,
				name = "Ornamented Saber",
				itemId = 40563,
				amount = 1
			},
			{
				clientId = 40277,
				name = "Sharp Edges",
				itemId = 43729,
				amount = 24
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 40600,
		index = 74,
		slotName = "greataxe",
		name = "Nocturnal Greataxe",
		progress = 700,
		profession = 5,
		clientId = 37148,
		durability = 12,
		experience = 124000,
		specialization = "Dwarven Weaponsmith",
		description = "",
		tier = 6,
		category = "weapons",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 30
			},
			{
				clientId = 45503,
				name = "Fine Plank",
				itemId = 48955,
				amount = 20
			},
			{
				clientId = 28983,
				name = "Orcish Battle Axe",
				itemId = 32415,
				amount = 1
			},
			{
				clientId = 40278,
				name = "Sturdy Joint",
				itemId = 43730,
				amount = 24
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 40605,
		index = 75,
		slotName = "greatsword",
		name = "Magister's Greatsword",
		progress = 700,
		profession = 5,
		clientId = 37153,
		durability = 12,
		experience = 124000,
		specialization = "Dwarven Weaponsmith",
		description = "",
		tier = 6,
		category = "weapons",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 30
			},
			{
				clientId = 35436,
				name = "Artisan Leather",
				itemId = 38868,
				amount = 14
			},
			{
				clientId = 28989,
				name = "Samurai's Daikatana",
				itemId = 32421,
				amount = 1
			},
			{
				clientId = 40267,
				name = "Crude Runed Tip",
				itemId = 43719,
				amount = 24
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 40604,
		index = 76,
		slotName = "hammer",
		name = "Soulwarden's Hammer",
		progress = 700,
		profession = 5,
		clientId = 37152,
		durability = 12,
		experience = 124000,
		specialization = "Dwarven Weaponsmith",
		description = "",
		tier = 6,
		category = "weapons",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 30
			},
			{
				clientId = 45503,
				name = "Fine Plank",
				itemId = 48955,
				amount = 20
			},
			{
				clientId = 29020,
				name = "Dwarven Warhammer",
				itemId = 32452,
				amount = 1
			},
			{
				clientId = 40275,
				name = "Polished Plate Scraps",
				itemId = 43727,
				amount = 24
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 40595,
		index = 77,
		slotName = "plate armor",
		name = "Chivalry Armor",
		progress = 700,
		profession = 5,
		clientId = 37143,
		durability = 12,
		experience = 33000,
		specialization = "Dwarven Armorsmith",
		description = "",
		tier = 6,
		category = "armors",
		level = {
			single = 78,
			mass = 83
		},
		materials = {
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 10
			},
			{
				clientId = 35436,
				name = "Artisan Leather",
				itemId = 38868,
				amount = 3
			},
			{
				clientId = 28714,
				name = "Protector's Armor",
				itemId = 32146,
				amount = 1
			},
			{
				clientId = 40276,
				name = "Reflective Husk",
				itemId = 43728,
				amount = 6
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 40598,
		index = 78,
		slotName = "plate helmet",
		name = "Chivalry Helmet",
		progress = 700,
		profession = 5,
		clientId = 37146,
		durability = 12,
		experience = 33000,
		specialization = "Dwarven Armorsmith",
		description = "",
		tier = 6,
		category = "armors",
		level = {
			single = 80,
			mass = 85
		},
		materials = {
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 10
			},
			{
				clientId = 35436,
				name = "Artisan Leather",
				itemId = 38868,
				amount = 3
			},
			{
				clientId = 28720,
				name = "Protector's Helmet",
				itemId = 32152,
				amount = 1
			},
			{
				clientId = 40276,
				name = "Reflective Husk",
				itemId = 43728,
				amount = 6
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 40597,
		index = 79,
		slotName = "plate legs",
		name = "Chivalry Legs",
		progress = 700,
		profession = 5,
		clientId = 37145,
		durability = 12,
		experience = 33000,
		specialization = "Dwarven Armorsmith",
		description = "",
		tier = 6,
		category = "armors",
		level = {
			single = 82,
			mass = 87
		},
		materials = {
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 10
			},
			{
				clientId = 35436,
				name = "Artisan Leather",
				itemId = 38868,
				amount = 3
			},
			{
				clientId = 28721,
				name = "Protector's Legs",
				itemId = 32153,
				amount = 1
			},
			{
				clientId = 40276,
				name = "Reflective Husk",
				itemId = 43728,
				amount = 6
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 40596,
		index = 80,
		slotName = "plate boots",
		name = "Chivalry Boots",
		progress = 700,
		profession = 5,
		clientId = 37144,
		durability = 12,
		experience = 33000,
		specialization = "Dwarven Armorsmith",
		description = "",
		tier = 6,
		category = "armors",
		level = {
			single = 84,
			mass = 89
		},
		materials = {
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 10
			},
			{
				clientId = 35436,
				name = "Artisan Leather",
				itemId = 38868,
				amount = 3
			},
			{
				clientId = 28717,
				name = "Protector's Boots",
				itemId = 32149,
				amount = 1
			},
			{
				clientId = 40276,
				name = "Reflective Husk",
				itemId = 43728,
				amount = 6
			}
		}
	},
	{
		itemId = 40686,
		experience = 111000,
		durability = 7,
		index = 81,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Forging Tools",
		progress = 350,
		description = "Used in housing upgrades.",
		clientId = 37234,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 60
			},
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 40
			},
			{
				clientId = 28941,
				name = "coal",
				itemId = 32373,
				amount = 20
			},
			{
				clientId = 35433,
				name = "Craftman's Leather",
				itemId = 38865,
				amount = 10
			}
		}
	},
	{
		itemId = 40737,
		experience = 210000,
		durability = 8,
		index = 82,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Superior Forging Tools",
		progress = 525,
		description = "Used in housing upgrades.",
		clientId = 37285,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 65
			},
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 70
			},
			{
				clientId = 28941,
				name = "coal",
				itemId = 32373,
				amount = 30
			},
			{
				clientId = 35433,
				name = "Craftman's Leather",
				itemId = 38865,
				amount = 15
			}
		}
	},
	{
		itemId = 40672,
		experience = 300000,
		durability = 12,
		index = 83,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Artisan Forging Tools",
		progress = 700,
		description = "Used in housing upgrades.",
		clientId = 37220,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 70
			},
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 60
			},
			{
				clientId = 28941,
				name = "coal",
				itemId = 32373,
				amount = 40
			},
			{
				clientId = 35433,
				name = "Craftman's Leather",
				itemId = 38865,
				amount = 25
			}
		}
	},
	{
		itemId = 40741,
		experience = 100000,
		durability = 7,
		index = 84,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Woodwork Tools",
		progress = 350,
		description = "Used in housing upgrades.",
		clientId = 37289,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 70
			},
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 30
			}
		}
	},
	{
		itemId = 40688,
		experience = 240000,
		durability = 12,
		index = 85,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Improved Woodwork Tools",
		progress = 700,
		description = "Used in housing upgrades.",
		clientId = 37236,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 90
			},
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 35
			}
		}
	},
	{
		itemId = 40669,
		experience = 92100,
		durability = 7,
		index = 86,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Anvil",
		progress = 350,
		description = "Used in housing upgrades.",
		clientId = 37217,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 60
			},
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 35
			}
		}
	},
	{
		itemId = 40685,
		experience = 215000,
		durability = 12,
		index = 87,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Forgemaster Anvil",
		progress = 700,
		description = "Used in housing upgrades.",
		clientId = 37233,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 75
			},
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 36
			}
		}
	},
	{
		itemId = 40687,
		experience = 27500,
		durability = 7,
		index = 88,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Furnace",
		progress = 350,
		description = "Used in housing upgrades.",
		clientId = 37235,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 18
			},
			{
				clientId = 28737,
				name = "iron bar",
				itemId = 32169,
				amount = 5
			},
			{
				clientId = 28946,
				name = "stone",
				itemId = 32378,
				amount = 20
			},
			{
				clientId = 28941,
				name = "coal",
				itemId = 32373,
				amount = 10
			}
		}
	},
	{
		itemId = 40684,
		experience = 88500,
		durability = 12,
		index = 89,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Forge",
		progress = 700,
		description = "Used in housing upgrades.",
		clientId = 37232,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 40
			},
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 6
			},
			{
				clientId = 28737,
				name = "iron bar",
				itemId = 32169,
				amount = 5
			},
			{
				clientId = 28946,
				name = "stone",
				itemId = 32378,
				amount = 20
			},
			{
				clientId = 28941,
				name = "coal",
				itemId = 32373,
				amount = 10
			}
		}
	},
	{
		itemId = 40733,
		experience = 70000,
		durability = 7,
		index = 90,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Stove",
		progress = 350,
		description = "Used in housing upgrades.",
		clientId = 37281,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 28723,
				name = "iron ingot",
				itemId = 32155,
				amount = 45
			},
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 30
			},
			{
				clientId = 28737,
				name = "iron bar",
				itemId = 32169,
				amount = 15
			},
			{
				clientId = 28941,
				name = "coal",
				itemId = 32373,
				amount = 10
			},
			{
				clientId = 28946,
				name = "stone",
				itemId = 32378,
				amount = 10
			}
		}
	},
	{
		itemId = 32172,
		experience = 9000,
		durability = 7,
		index = 91,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "reinforced plate",
		progress = 200,
		description = "Used in various recipes. The backbone of many structures in Ravendawn.",
		clientId = 28740,
		tier = -1,
		category = "Misc",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 28723,
				name = "iron ingot",
				itemId = 32155,
				amount = 15
			},
			{
				clientId = 28743,
				name = "refined plank",
				itemId = 32175,
				amount = 15
			},
			{
				clientId = 49616,
				name = "malleable screw",
				itemId = 53069,
				amount = 10
			}
		}
	},
	{
		itemId = 40738,
		experience = 260500,
		durability = 8,
		index = 92,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Superior Stove",
		progress = 525,
		description = "Used in housing upgrades.",
		clientId = 37286,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 85
			},
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 50
			},
			{
				clientId = 28737,
				name = "iron bar",
				itemId = 32169,
				amount = 30
			},
			{
				clientId = 28941,
				name = "coal",
				itemId = 32373,
				amount = 20
			},
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 35
			}
		}
	},
	{
		itemId = 40673,
		experience = 410000,
		durability = 12,
		index = 93,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Artisan Stove",
		progress = 700,
		description = "Used in housing upgrades.",
		clientId = 37221,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 100
			},
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 60
			},
			{
				clientId = 28737,
				name = "iron bar",
				itemId = 32169,
				amount = 40
			},
			{
				clientId = 28941,
				name = "coal",
				itemId = 32373,
				amount = 30
			},
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 35
			}
		}
	},
	{
		itemId = 40712,
		experience = 185000,
		durability = 6,
		index = 94,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Minor Shielding Kit",
		progress = 225,
		description = "Used for crafting ship modules for your ship at the Ship Builder",
		clientId = 37260,
		tier = -1,
		category = "Ship Module",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 150
			},
			{
				clientId = 28723,
				name = "iron ingot",
				itemId = 32155,
				amount = 110
			}
		}
	},
	{
		itemId = 40734,
		experience = 725000,
		durability = 7,
		index = 95,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Sturdy Shielding Kit",
		progress = 500,
		description = "Used for crafting ship modules for your ship at the Ship Builder",
		clientId = 37282,
		tier = -1,
		category = "Ship Module",
		level = {
			single = 45,
			mass = 50
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 210
			},
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 180
			},
			{
				clientId = 37260,
				name = "Minor Shielding Kit",
				itemId = 40712,
				amount = 1
			}
		}
	},
	{
		itemId = 40715,
		experience = 1200000,
		durability = 12,
		index = 96,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Reinforced Shielding Kit",
		progress = 700,
		description = "Used for crafting ship modules for your ship at the Ship Builder",
		clientId = 37263,
		tier = -1,
		category = "Ship Module",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 205
			},
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 60
			},
			{
				clientId = 37282,
				name = "Sturdy Shielding Kit",
				itemId = 40734,
				amount = 1
			}
		}
	},
	{
		itemId = 40718,
		experience = 55500,
		durability = 6,
		index = 97,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Small Cannon Kit",
		progress = 225,
		description = "Used for crafting ship modules for your ship at the Ship Builder",
		clientId = 37266,
		tier = -1,
		category = "Ship Module",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 35
			},
			{
				clientId = 28723,
				name = "iron ingot",
				itemId = 32155,
				amount = 15
			},
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 15
			}
		}
	},
	{
		itemId = 40720,
		experience = 101500,
		durability = 6,
		index = 98,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Simple Ship Emblems Kit",
		progress = 225,
		description = "Used for crafting ship modules for your ship at the Ship Builder",
		clientId = 37268,
		tier = -1,
		category = "Ship Module",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 90
			},
			{
				clientId = 28723,
				name = "iron ingot",
				itemId = 32155,
				amount = 30
			},
			{
				clientId = 28941,
				name = "coal",
				itemId = 32373,
				amount = 100
			}
		}
	},
	{
		itemId = 40717,
		experience = 250500,
		durability = 7,
		index = 99,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Shiny Ship Emblems Kit",
		progress = 500,
		description = "Used for crafting ship modules for your ship at the Ship Builder",
		clientId = 37265,
		tier = -1,
		category = "Ship Module",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 115
			},
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 15
			},
			{
				clientId = 37268,
				name = "Simple Ship Emblems Kit",
				itemId = 40720,
				amount = 1
			}
		}
	},
	{
		itemId = 40670,
		experience = 532500,
		durability = 12,
		index = 100,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Adorned Ship Emblems Kit",
		progress = 700,
		description = "Used for crafting ship modules for your ship at the Ship Builder",
		clientId = 37218,
		tier = -1,
		category = "Ship Module",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 100
			},
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 45
			},
			{
				clientId = 37265,
				name = "Shiny Ship Emblems Kit",
				itemId = 40717,
				amount = 1
			}
		}
	},
	{
		itemId = 40675,
		experience = 100000,
		durability = 6,
		index = 101,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Basic Water Pumps Kit",
		progress = 225,
		description = "Used for crafting ship modules for your ship at the Ship Builder.",
		clientId = 37223,
		tier = -1,
		category = "Ship Module",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 90
			},
			{
				clientId = 28723,
				name = "iron ingot",
				itemId = 32155,
				amount = 30
			},
			{
				clientId = 28941,
				name = "coal",
				itemId = 32373,
				amount = 100
			}
		}
	},
	{
		itemId = 40682,
		experience = 250000,
		durability = 7,
		index = 102,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Enhanced Water Pumps Kit",
		progress = 500,
		description = "Used for crafting ship modules for your ship at the Ship Builder.",
		clientId = 37230,
		tier = -1,
		category = "Ship Module",
		level = {
			single = 45,
			mass = 50
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 70
			},
			{
				clientId = 40284,
				name = "Steel Bar",
				itemId = 43736,
				amount = 50
			},
			{
				clientId = 37223,
				name = "Basic Water Pumps Kit",
				itemId = 40675,
				amount = 1
			}
		}
	},
	{
		itemId = 40713,
		experience = 545000,
		durability = 12,
		index = 103,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Pressurized Water Pumps Kit",
		progress = 700,
		description = "Used for crafting ship modules for your ship at the Ship Builder",
		clientId = 37261,
		tier = -1,
		category = "Ship Module",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 85
			},
			{
				clientId = 40284,
				name = "Steel Bar",
				itemId = 43736,
				amount = 100
			},
			{
				clientId = 37230,
				name = "Enhanced Water Pumps Kit",
				itemId = 40682,
				amount = 1
			}
		}
	},
	{
		itemId = 32166,
		experience = 160,
		durability = 4,
		index = 104,
		profession = 5,
		quality = 75,
		slotName = "",
		amount = 1,
		name = "nail",
		progress = 50,
		description = "Used in various recipes. A basic yet crucial component for construction.",
		clientId = 28734,
		tier = -1,
		category = "Misc",
		level = {
			single = 2,
			mass = 7
		},
		materials = {
			{
				clientId = 28726,
				name = "copper ingot",
				itemId = 32158,
				amount = 1
			}
		}
	},
	{
		itemId = 32169,
		experience = 800,
		durability = 7,
		index = 105,
		profession = 5,
		quality = 225,
		slotName = "",
		amount = 1,
		name = "iron bar",
		progress = 200,
		description = "Used in various recipes. Forged with strength and versatility in mind.",
		clientId = 28737,
		tier = -1,
		category = "Misc",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 28723,
				name = "iron ingot",
				itemId = 32155,
				amount = 1
			}
		}
	},
	{
		itemId = 32436,
		experience = 800,
		durability = 3,
		index = 106,
		profession = 5,
		quality = 100,
		slotName = "club",
		amount = 1,
		name = "Solid Mace",
		progress = 50,
		description = "",
		clientId = 29004,
		tier = 1,
		category = "weapons",
		level = {
			single = 1,
			mass = 6
		},
		materials = {
			{
				clientId = 28726,
				name = "copper ingot",
				itemId = 32158,
				amount = 2
			}
		}
	},
	{
		itemId = 32491,
		experience = 800,
		durability = 3,
		index = 107,
		profession = 5,
		quality = 100,
		slotName = "sword",
		amount = 1,
		name = "Rough Sword",
		progress = 50,
		description = "",
		clientId = 29059,
		tier = 1,
		category = "weapons",
		level = {
			single = 1,
			mass = 6
		},
		materials = {
			{
				clientId = 28726,
				name = "copper ingot",
				itemId = 32158,
				amount = 2
			}
		}
	},
	{
		itemId = 32424,
		experience = 800,
		durability = 3,
		index = 108,
		profession = 5,
		quality = 100,
		slotName = "axe",
		amount = 1,
		name = "Wicked Axe",
		progress = 50,
		description = "",
		clientId = 28992,
		tier = 1,
		category = "weapons",
		level = {
			single = 1,
			mass = 6
		},
		materials = {
			{
				clientId = 28726,
				name = "copper ingot",
				itemId = 32158,
				amount = 2
			}
		}
	},
	{
		itemId = 32442,
		experience = 800,
		durability = 3,
		index = 109,
		profession = 5,
		quality = 100,
		slotName = "dagger",
		amount = 1,
		name = "Serrated Dagger",
		progress = 50,
		description = "",
		clientId = 29010,
		tier = 1,
		category = "weapons",
		level = {
			single = 1,
			mass = 6
		},
		materials = {
			{
				clientId = 28726,
				name = "copper ingot",
				itemId = 32158,
				amount = 2
			}
		}
	},
	{
		itemId = 32410,
		experience = 1600,
		durability = 3,
		index = 111,
		profession = 5,
		quality = 100,
		slotName = "greataxe",
		amount = 1,
		name = "Rough Greataxe",
		progress = 50,
		description = "",
		clientId = 28978,
		tier = 1,
		category = "weapons",
		level = {
			single = 1,
			mass = 6
		},
		materials = {
			{
				clientId = 28726,
				name = "copper ingot",
				itemId = 32158,
				amount = 4
			}
		}
	},
	{
		itemId = 32417,
		experience = 1600,
		durability = 3,
		index = 112,
		profession = 5,
		quality = 100,
		slotName = "greatsword",
		amount = 1,
		name = "Burnished Greatsword",
		progress = 50,
		description = "",
		clientId = 28985,
		tier = 1,
		category = "weapons",
		level = {
			single = 1,
			mass = 6
		},
		materials = {
			{
				clientId = 28726,
				name = "copper ingot",
				itemId = 32158,
				amount = 4
			}
		}
	},
	{
		itemId = 40559,
		experience = 1600,
		durability = 3,
		index = 113,
		profession = 5,
		quality = 100,
		slotName = "light blade",
		amount = 1,
		name = "Skirmisher's Blade",
		progress = 50,
		description = "",
		clientId = 37107,
		tier = 1,
		category = "weapons",
		level = {
			single = 1,
			mass = 6
		},
		materials = {
			{
				clientId = 28726,
				name = "copper ingot",
				itemId = 32158,
				amount = 4
			}
		}
	},
	{
		itemId = 32448,
		experience = 1600,
		durability = 3,
		index = 114,
		profession = 5,
		quality = 100,
		slotName = "hammer",
		amount = 1,
		name = "Shipbuilding Mallet",
		progress = 50,
		description = "",
		clientId = 29016,
		tier = 1,
		category = "weapons",
		level = {
			single = 1,
			mass = 6
		},
		materials = {
			{
				clientId = 28726,
				name = "copper ingot",
				itemId = 32158,
				amount = 4
			}
		}
	},
	{
		itemId = 32110,
		experience = 600,
		durability = 3,
		index = 115,
		profession = 5,
		quality = 100,
		slotName = "plate armor",
		amount = 1,
		name = "Pliant Armor",
		progress = 50,
		description = "",
		clientId = 28678,
		tier = 1,
		category = "armors",
		level = {
			single = 3,
			mass = 8
		},
		materials = {
			{
				clientId = 28726,
				name = "copper ingot",
				itemId = 32158,
				amount = 2
			}
		}
	},
	{
		itemId = 32116,
		experience = 600,
		durability = 3,
		index = 116,
		profession = 5,
		quality = 100,
		slotName = "plate helmet",
		amount = 1,
		name = "Pliant Helmet",
		progress = 50,
		description = "",
		clientId = 28684,
		tier = 1,
		category = "armors",
		level = {
			single = 5,
			mass = 10
		},
		materials = {
			{
				clientId = 28726,
				name = "copper ingot",
				itemId = 32158,
				amount = 2
			}
		}
	},
	{
		itemId = 32117,
		experience = 600,
		durability = 3,
		index = 117,
		profession = 5,
		quality = 100,
		slotName = "plate legs",
		amount = 1,
		name = "Pliant Legs",
		progress = 50,
		description = "",
		clientId = 28685,
		tier = 1,
		category = "armors",
		level = {
			single = 7,
			mass = 12
		},
		materials = {
			{
				clientId = 28726,
				name = "copper ingot",
				itemId = 32158,
				amount = 2
			}
		}
	},
	{
		itemId = 32113,
		experience = 600,
		durability = 3,
		index = 118,
		profession = 5,
		quality = 100,
		slotName = "plate boots",
		amount = 1,
		name = "Pliant Boots",
		progress = 50,
		description = "",
		clientId = 28681,
		tier = 1,
		category = "armors",
		level = {
			single = 9,
			mass = 14
		},
		materials = {
			{
				clientId = 28726,
				name = "copper ingot",
				itemId = 32158,
				amount = 2
			}
		}
	},
	{
		itemId = 43734,
		experience = 390,
		durability = 7,
		index = 119,
		profession = 5,
		quality = 200,
		slotName = "",
		amount = 1,
		name = "Bolt",
		progress = 225,
		description = "Used in various recipes. A small piece, integral in connecting larger ones.",
		clientId = 40282,
		tier = -1,
		category = "Misc",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 1
			}
		}
	},
	{
		itemId = 43736,
		experience = 750,
		durability = 7,
		index = 120,
		profession = 5,
		quality = 400,
		slotName = "",
		amount = 1,
		name = "Steel Bar",
		progress = 350,
		description = "Used in various recipes. Cold, hard, and unyielding - the essence of strength.",
		clientId = 40284,
		tier = -1,
		category = "Misc",
		level = {
			single = 45,
			mass = 50
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 2
			}
		}
	},
	{
		itemId = 43735,
		experience = 3600,
		durability = 3,
		index = 121,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Common Plate",
		progress = 50,
		description = "Used in various recipes. A humble slab of metal, awaiting purpose.",
		clientId = 40283,
		tier = -1,
		category = "Misc",
		level = {
			single = 4,
			mass = 9
		},
		materials = {
			{
				clientId = 28726,
				name = "copper ingot",
				itemId = 32158,
				amount = 10
			},
			{
				clientId = 28744,
				name = "rough plank",
				itemId = 32176,
				amount = 10
			},
			{
				clientId = 28734,
				name = "nail",
				itemId = 32166,
				amount = 10
			}
		}
	},
	{
		itemId = 45302,
		experience = 400,
		durability = 4,
		index = 122,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Stone Block",
		progress = 100,
		description = "Used in various recipes. Solid building material, ideal for constructing robust houses.",
		clientId = 41850,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28946,
				name = "stone",
				itemId = 32378,
				amount = 20
			}
		}
	},
	{
		itemId = 45298,
		experience = 920,
		durability = 7,
		index = 123,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Dense Block",
		progress = 225,
		description = "Used in various recipes. Massive construction material painstakingly hewn from solid stone.",
		clientId = 41846,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				clientId = 28946,
				name = "stone",
				itemId = 32378,
				amount = 40
			},
			{
				clientId = 28941,
				name = "coal",
				itemId = 32373,
				amount = 2
			}
		}
	},
	{
		itemId = 45301,
		experience = 24000,
		durability = 8,
		index = 124,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Royal Ornaments",
		progress = 450,
		description = "Used in various recipes. Formed by skillfully combining an array of precious gems, radiating elegance.",
		clientId = 41849,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 28948,
				name = "amethyst",
				itemId = 32380,
				amount = 1
			},
			{
				clientId = 28949,
				name = "citrine",
				itemId = 32381,
				amount = 1
			},
			{
				clientId = 28952,
				name = "sapphire",
				itemId = 32384,
				amount = 1
			},
			{
				clientId = 28950,
				name = "emerald",
				itemId = 32382,
				amount = 1
			},
			{
				clientId = 28951,
				name = "ruby",
				itemId = 32383,
				amount = 1
			},
			{
				clientId = 28953,
				name = "topaz",
				itemId = 32385,
				amount = 1
			}
		}
	},
	{
		itemId = 46230,
		experience = 25400,
		durability = 4,
		index = 125,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Malleable Anvil",
		progress = 75,
		description = "Used in housing upgrades.",
		clientId = 42778,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 30
			},
			{
				clientId = 28723,
				name = "iron ingot",
				itemId = 32155,
				amount = 7
			}
		}
	},
	{
		itemId = 46236,
		experience = 7150,
		durability = 4,
		index = 126,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Basic Tools",
		progress = 100,
		description = "Used in housing upgrades.",
		clientId = 42784,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28726,
				name = "copper ingot",
				itemId = 32158,
				amount = 10
			},
			{
				clientId = 28744,
				name = "rough plank",
				itemId = 32176,
				amount = 4
			},
			{
				clientId = 35432,
				name = "Coarse Leather",
				itemId = 38864,
				amount = 1
			}
		}
	},
	{
		itemId = 46690,
		experience = 7250,
		durability = 7,
		index = 127,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Simple Headgear",
		progress = 200,
		description = "Together with 'Simple Saddle' can be crafted into a 'Simple Barding'.",
		clientId = 43238,
		tier = -1,
		category = "Moa Equipment",
		level = {
			single = 12,
			mass = 17
		},
		materials = {
			{
				clientId = 28726,
				name = "copper ingot",
				itemId = 32158,
				amount = 10
			},
			{
				clientId = 35432,
				name = "Coarse Leather",
				itemId = 38864,
				amount = 4
			}
		}
	},
	{
		itemId = 46691,
		experience = 13000,
		durability = 7,
		index = 128,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Composed Headgear",
		progress = 200,
		description = "Together with 'Composed Saddle' can be crafted into a 'Composed Barding'.",
		clientId = 43239,
		tier = -1,
		category = "Moa Equipment",
		level = {
			single = 24,
			mass = 29
		},
		materials = {
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 12
			},
			{
				clientId = 35432,
				name = "Coarse Leather",
				itemId = 38864,
				amount = 8
			}
		}
	},
	{
		itemId = 46692,
		experience = 23000,
		durability = 7,
		index = 129,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Advanced Headgear",
		progress = 350,
		description = "Together with 'Advanced Saddle' can be crafted into a 'Advanced Barding'.",
		clientId = 43240,
		tier = -1,
		category = "Moa Equipment",
		level = {
			single = 36,
			mass = 41
		},
		materials = {
			{
				clientId = 28723,
				name = "iron ingot",
				itemId = 32155,
				amount = 18
			},
			{
				clientId = 35433,
				name = "Craftman's Leather",
				itemId = 38865,
				amount = 7
			}
		}
	},
	{
		itemId = 46693,
		experience = 60200,
		durability = 8,
		index = 130,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Artisan Headgear",
		progress = 525,
		description = "Together with 'Artisan Saddle' can be crafted into a 'Artisan Barding'.",
		clientId = 43241,
		tier = -1,
		category = "Moa Equipment",
		level = {
			single = 48,
			mass = 53
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 25
			},
			{
				clientId = 35434,
				name = "Tanned Leather",
				itemId = 38866,
				amount = 17
			}
		}
	},
	{
		itemId = 46694,
		experience = 82000,
		durability = 9,
		index = 131,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Superior Headgear",
		progress = 650,
		description = "Together with 'Superior Saddle' can be crafted into a 'Superior Barding'.",
		clientId = 43242,
		tier = -1,
		category = "Moa Equipment",
		level = {
			single = 60,
			mass = 65
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 25
			},
			{
				clientId = 35435,
				name = "Merchant's Leather",
				itemId = 38867,
				amount = 17
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		itemId = 46695,
		index = 132,
		slotName = "",
		name = "War Headgear",
		progress = 750,
		profession = 5,
		clientId = 43243,
		durability = 12,
		experience = 150000,
		specialization = "Craftsman",
		description = "Together with 'War Saddle' can be crafted into a 'War Barding'.",
		tier = -1,
		category = "Moa Equipment",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 20
			},
			{
				clientId = 35436,
				name = "Artisan Leather",
				itemId = 38868,
				amount = 12
			},
			{
				clientId = 28951,
				name = "ruby",
				itemId = 32383,
				amount = 10
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		itemId = 46696,
		index = 133,
		slotName = "",
		name = "Explorer Headgear",
		progress = 750,
		profession = 5,
		clientId = 43244,
		durability = 12,
		experience = 150000,
		specialization = "Craftsman",
		description = "Together with 'Explorer Saddle' can be crafted into a 'Explorer Barding'.",
		tier = -1,
		category = "Moa Equipment",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 20
			},
			{
				clientId = 35436,
				name = "Artisan Leather",
				itemId = 38868,
				amount = 12
			},
			{
				clientId = 28952,
				name = "sapphire",
				itemId = 32384,
				amount = 10
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		itemId = 46697,
		index = 134,
		slotName = "",
		name = "Professional Headgear",
		progress = 750,
		profession = 5,
		clientId = 43245,
		durability = 12,
		experience = 150000,
		specialization = "Craftsman",
		description = "Together with 'Professional Saddle' can be crafted into a 'Professional Barding'.",
		tier = -1,
		category = "Moa Equipment",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 20
			},
			{
				clientId = 35436,
				name = "Artisan Leather",
				itemId = 38868,
				amount = 12
			},
			{
				clientId = 28953,
				name = "topaz",
				itemId = 32385,
				amount = 10
			}
		}
	},
	{
		itemId = 47089,
		experience = 190000,
		durability = 7,
		index = 135,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Medium Cannon Kit",
		progress = 500,
		description = "",
		clientId = 43637,
		tier = -1,
		category = "Ship Module",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 75
			},
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 18
			},
			{
				clientId = 40284,
				name = "Steel Bar",
				itemId = 43736,
				amount = 25
			},
			{
				clientId = 37266,
				name = "Small Cannon Kit",
				itemId = 40718,
				amount = 1
			}
		}
	},
	{
		itemId = 47088,
		experience = 495000,
		durability = 9,
		index = 136,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Large Cannon Kit",
		progress = 650,
		description = "",
		clientId = 43636,
		tier = -1,
		category = "Ship Module",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 100
			},
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 36
			},
			{
				clientId = 40284,
				name = "Steel Bar",
				itemId = 43736,
				amount = 60
			},
			{
				clientId = 43637,
				name = "Medium Cannon Kit",
				itemId = 47089,
				amount = 1
			}
		}
	},
	{
		itemId = 50741,
		experience = 4900,
		durability = 5,
		index = 137,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Weak Racks",
		progress = 200,
		description = "Used for housing craft.",
		clientId = 47288,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 15
			},
			{
				clientId = 49799,
				name = "Gemstone Dust",
				itemId = 53252,
				amount = 1
			},
			{
				clientId = 28734,
				name = "nail",
				itemId = 32166,
				amount = 5
			}
		}
	},
	{
		itemId = 50729,
		experience = 13500,
		durability = 7,
		index = 138,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Armory Racks",
		progress = 350,
		description = "Used for housing craft.",
		clientId = 47276,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 22
			},
			{
				clientId = 49799,
				name = "Gemstone Dust",
				itemId = 53252,
				amount = 3
			},
			{
				clientId = 49616,
				name = "malleable screw",
				itemId = 53069,
				amount = 40
			}
		}
	},
	{
		itemId = 50734,
		experience = 37533,
		durability = 12,
		index = 139,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Reinforced Racks",
		progress = 700,
		description = "Used for housing craft.",
		clientId = 47281,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 22
			},
			{
				clientId = 49799,
				name = "Gemstone Dust",
				itemId = 53252,
				amount = 8
			},
			{
				clientId = 40282,
				name = "Bolt",
				itemId = 43734,
				amount = 60
			}
		}
	},
	{
		itemId = 50732,
		experience = 70000,
		durability = 8,
		index = 140,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Gear Maintenance Tools",
		progress = 525,
		description = "Used for housing craft.",
		clientId = 47279,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 20
			},
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 12
			},
			{
				clientId = 28941,
				name = "coal",
				itemId = 32373,
				amount = 30
			},
			{
				clientId = 35433,
				name = "Craftman's Leather",
				itemId = 38865,
				amount = 15
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		itemId = 50736,
		index = 141,
		slotName = "",
		name = "Thief Tools",
		progress = 700,
		profession = 5,
		clientId = 47283,
		durability = 12,
		experience = 220000,
		specialization = "Craftsman",
		description = "Used for housing craft.",
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 55
			},
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 36
			},
			{
				clientId = 28941,
				name = "coal",
				itemId = 32373,
				amount = 40
			},
			{
				clientId = 35433,
				name = "Craftman's Leather",
				itemId = 38865,
				amount = 25
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		itemId = 50740,
		index = 142,
		slotName = "",
		name = "Warmonger Tools",
		progress = 700,
		profession = 5,
		clientId = 47287,
		durability = 12,
		experience = 220000,
		specialization = "Craftsman",
		description = "Used for housing craft.",
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 55
			},
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 36
			},
			{
				clientId = 28941,
				name = "coal",
				itemId = 32373,
				amount = 40
			},
			{
				clientId = 35433,
				name = "Craftman's Leather",
				itemId = 38865,
				amount = 25
			}
		}
	},
	{
		itemId = 53067,
		experience = 660,
		durability = 7,
		index = 143,
		profession = 5,
		quality = 150,
		slotName = "",
		amount = 1,
		name = "bronze ingot",
		progress = 150,
		description = "Used in various recipes. Malleable, yet resistant.",
		clientId = 49614,
		tier = -1,
		category = "ingots",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28944,
				name = "copper ore",
				itemId = 32376,
				amount = 2
			},
			{
				clientId = 44285,
				name = "Tin Ore",
				itemId = 47737,
				amount = 3
			}
		}
	},
	{
		itemId = 53069,
		experience = 220,
		durability = 7,
		index = 144,
		profession = 5,
		quality = 225,
		slotName = "",
		amount = 1,
		name = "malleable screw",
		progress = 200,
		description = "Used in various recipes. Used to fix things in place.",
		clientId = 49616,
		tier = -1,
		category = "Misc",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 1
			}
		}
	},
	{
		itemId = 53066,
		experience = 1100,
		durability = 4,
		index = 145,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "arcane reflector",
		progress = 100,
		description = "Used in various recipes. Said to reflect magic.",
		clientId = 49613,
		tier = -1,
		category = "Misc",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 5
			}
		}
	},
	{
		itemId = 51975,
		experience = 3850,
		durability = 10,
		index = 146,
		profession = 5,
		quality = 610,
		slotName = "",
		amount = 1,
		name = "glimmery ingot",
		progress = 610,
		description = "Used in various recipes. It shines without the need of light.",
		clientId = 48522,
		tier = -1,
		category = "ingots",
		level = {
			single = 88,
			mass = 93
		},
		materials = {
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 3
			},
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 2
			},
			{
				clientId = 48510,
				name = "Binding Aether",
				itemId = 51963,
				amount = 1
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 52003,
		index = 147,
		slotName = "sword",
		name = "Warlord's Longsword",
		progress = 870,
		profession = 5,
		clientId = 48550,
		durability = 15,
		experience = 77000,
		specialization = "Dwarven Weaponsmith",
		description = "",
		tier = 7,
		category = "weapons",
		level = {
			single = 90,
			mass = 95
		},
		materials = {
			{
				clientId = 48522,
				name = "glimmery ingot",
				itemId = 51975,
				amount = 13
			},
			{
				clientId = 48523,
				name = "glimmery leather",
				itemId = 51976,
				amount = 7
			},
			{
				clientId = 37158,
				name = "Champion's Longsword",
				itemId = 40610,
				amount = 1
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 51993,
		index = 148,
		slotName = "axe",
		name = "Doomgem Axe",
		progress = 870,
		profession = 5,
		clientId = 48540,
		durability = 15,
		experience = 77000,
		specialization = "Dwarven Weaponsmith",
		description = "",
		tier = 7,
		category = "weapons",
		level = {
			single = 90,
			mass = 95
		},
		materials = {
			{
				clientId = 48522,
				name = "glimmery ingot",
				itemId = 51975,
				amount = 15
			},
			{
				clientId = 48523,
				name = "glimmery leather",
				itemId = 51976,
				amount = 5
			},
			{
				clientId = 37154,
				name = "Dragonbane Axe",
				itemId = 40606,
				amount = 1
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 52000,
		index = 149,
		slotName = "club",
		name = "Tyrant's Mace",
		progress = 870,
		profession = 5,
		clientId = 48547,
		durability = 15,
		experience = 77000,
		specialization = "Dwarven Weaponsmith",
		description = "",
		tier = 7,
		category = "weapons",
		level = {
			single = 90,
			mass = 95
		},
		materials = {
			{
				clientId = 48522,
				name = "glimmery ingot",
				itemId = 51975,
				amount = 15
			},
			{
				clientId = 48523,
				name = "glimmery leather",
				itemId = 51976,
				amount = 5
			},
			{
				clientId = 37156,
				name = "Skullbasher Mace",
				itemId = 40608,
				amount = 1
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 51998,
		index = 150,
		slotName = "dagger",
		name = "Soulstealer's Blade",
		progress = 870,
		profession = 5,
		clientId = 48545,
		durability = 15,
		experience = 77000,
		specialization = "Dwarven Weaponsmith",
		description = "",
		tier = 7,
		category = "weapons",
		level = {
			single = 90,
			mass = 95
		},
		materials = {
			{
				clientId = 48522,
				name = "glimmery ingot",
				itemId = 51975,
				amount = 13
			},
			{
				clientId = 48523,
				name = "glimmery leather",
				itemId = 51976,
				amount = 7
			},
			{
				clientId = 37151,
				name = "Ritual Dagger",
				itemId = 40603,
				amount = 1
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 52002,
		index = 151,
		slotName = "light blade",
		name = "Voidborne Blade",
		progress = 870,
		profession = 5,
		clientId = 48549,
		durability = 15,
		experience = 154000,
		specialization = "Dwarven Weaponsmith",
		description = "",
		tier = 7,
		category = "weapons",
		level = {
			single = 90,
			mass = 95
		},
		materials = {
			{
				clientId = 48522,
				name = "glimmery ingot",
				itemId = 51975,
				amount = 26
			},
			{
				clientId = 48523,
				name = "glimmery leather",
				itemId = 51976,
				amount = 14
			},
			{
				clientId = 37112,
				name = "Scarlet Thorn",
				itemId = 40564,
				amount = 1
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 51997,
		index = 152,
		slotName = "greataxe",
		name = "Runic Greataxe",
		progress = 870,
		profession = 5,
		clientId = 48544,
		durability = 15,
		experience = 154000,
		specialization = "Dwarven Weaponsmith",
		description = "",
		tier = 7,
		category = "weapons",
		level = {
			single = 90,
			mass = 95
		},
		materials = {
			{
				clientId = 48522,
				name = "glimmery ingot",
				itemId = 51975,
				amount = 30
			},
			{
				clientId = 48523,
				name = "glimmery leather",
				itemId = 51976,
				amount = 10
			},
			{
				clientId = 37148,
				name = "Nocturnal Greataxe",
				itemId = 40600,
				amount = 1
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 51999,
		index = 153,
		slotName = "greatsword",
		name = "Twilight Greatsword",
		progress = 870,
		profession = 5,
		clientId = 48546,
		durability = 15,
		experience = 154000,
		specialization = "Dwarven Weaponsmith",
		description = "",
		tier = 7,
		category = "weapons",
		level = {
			single = 90,
			mass = 95
		},
		materials = {
			{
				clientId = 48522,
				name = "glimmery ingot",
				itemId = 51975,
				amount = 26
			},
			{
				clientId = 48523,
				name = "glimmery leather",
				itemId = 51976,
				amount = 14
			},
			{
				clientId = 37153,
				name = "Magister's Greatsword",
				itemId = 40605,
				amount = 1
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 51995,
		index = 154,
		slotName = "hammer",
		name = "Indomitable Hammer",
		progress = 870,
		profession = 5,
		clientId = 48542,
		durability = 15,
		experience = 154000,
		specialization = "Dwarven Weaponsmith",
		description = "",
		tier = 7,
		category = "weapons",
		level = {
			single = 90,
			mass = 95
		},
		materials = {
			{
				clientId = 48522,
				name = "glimmery ingot",
				itemId = 51975,
				amount = 30
			},
			{
				clientId = 48523,
				name = "glimmery leather",
				itemId = 51976,
				amount = 10
			},
			{
				clientId = 37152,
				name = "Soulwarden's Hammer",
				itemId = 40604,
				amount = 1
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 51983,
		index = 155,
		slotName = "plate armor",
		name = "Indomitable Armor",
		progress = 870,
		profession = 5,
		clientId = 48530,
		durability = 15,
		experience = 42350,
		specialization = "Dwarven Armorsmith",
		description = "",
		tier = 7,
		category = "armors",
		level = {
			single = 93,
			mass = 98
		},
		materials = {
			{
				clientId = 48522,
				name = "glimmery ingot",
				itemId = 51975,
				amount = 7
			},
			{
				clientId = 48523,
				name = "glimmery leather",
				itemId = 51976,
				amount = 4
			},
			{
				clientId = 37143,
				name = "Chivalry Armor",
				itemId = 40595,
				amount = 1
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 51985,
		index = 156,
		slotName = "plate helmet",
		name = "Indomitable Helmet",
		progress = 870,
		profession = 5,
		clientId = 48532,
		durability = 15,
		experience = 42350,
		specialization = "Dwarven Armorsmith",
		description = "",
		tier = 7,
		category = "armors",
		level = {
			single = 96,
			mass = 101
		},
		materials = {
			{
				clientId = 48522,
				name = "glimmery ingot",
				itemId = 51975,
				amount = 7
			},
			{
				clientId = 48523,
				name = "glimmery leather",
				itemId = 51976,
				amount = 4
			},
			{
				clientId = 37146,
				name = "Chivalry Helmet",
				itemId = 40598,
				amount = 1
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 51986,
		index = 157,
		slotName = "plate legs",
		name = "Indomitable Legs",
		progress = 870,
		profession = 5,
		clientId = 48533,
		durability = 15,
		experience = 42350,
		specialization = "Dwarven Armorsmith",
		description = "",
		tier = 7,
		category = "armors",
		level = {
			single = 99,
			mass = 104
		},
		materials = {
			{
				clientId = 48522,
				name = "glimmery ingot",
				itemId = 51975,
				amount = 4
			},
			{
				clientId = 48523,
				name = "glimmery leather",
				itemId = 51976,
				amount = 7
			},
			{
				clientId = 37145,
				name = "Chivalry Legs",
				itemId = 40597,
				amount = 1
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 51984,
		index = 158,
		slotName = "plate boots",
		name = "Indomitable Boots",
		progress = 870,
		profession = 5,
		clientId = 48531,
		durability = 15,
		experience = 42350,
		specialization = "Dwarven Armorsmith",
		description = "",
		tier = 7,
		category = "armors",
		level = {
			single = 102,
			mass = 107
		},
		materials = {
			{
				clientId = 48522,
				name = "glimmery ingot",
				itemId = 51975,
				amount = 4
			},
			{
				clientId = 48523,
				name = "glimmery leather",
				itemId = 51976,
				amount = 7
			},
			{
				clientId = 37144,
				name = "Chivalry Boots",
				itemId = 40596,
				amount = 1
			}
		}
	},
	{
		itemId = 53248,
		experience = 8800,
		durability = 4,
		index = 159,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Basic Distilary Station",
		progress = 100,
		description = "Used in housing upgrades. A small circuit of receptacles and tubes.",
		clientId = 49795,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28726,
				name = "copper ingot",
				itemId = 32158,
				amount = 10
			},
			{
				clientId = 49799,
				name = "Gemstone Dust",
				itemId = 53252,
				amount = 1
			},
			{
				clientId = 47277,
				name = "Basic Stabilizer",
				itemId = 50730,
				amount = 1
			}
		}
	},
	{
		itemId = 53249,
		experience = 48750,
		durability = 7,
		index = 160,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Condensing Station",
		progress = 350,
		description = "Used in housing upgrades. A circuit featuring a station for properly condensing gases into liquids with minimal loss.",
		clientId = 49796,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 25
			},
			{
				clientId = 49799,
				name = "Gemstone Dust",
				itemId = 53252,
				amount = 5
			},
			{
				clientId = 47278,
				name = "Energy Stabilizer",
				itemId = 50731,
				amount = 1
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		itemId = 53251,
		index = 161,
		slotName = "",
		name = "Distilary Station",
		progress = 700,
		profession = 5,
		clientId = 49798,
		durability = 12,
		experience = 121250,
		specialization = "Craftsman",
		description = "Used in housing upgrades. An intricate circuit of vials and metallic tubes designed to perfectly control the temperature of gases and liquids.",
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 25
			},
			{
				clientId = 49799,
				name = "Gemstone Dust",
				itemId = 53252,
				amount = 20
			},
			{
				clientId = 47275,
				name = "Arcane Stabilizer",
				itemId = 50728,
				amount = 1
			}
		}
	},
	{
		itemId = 53252,
		experience = 4000,
		durability = 4,
		index = 162,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Gemstone Dust",
		progress = 100,
		description = "Used in various recipes. The powder is so fine and iridescent that it's impossible to tell which gem it came from.",
		clientId = 49799,
		tier = -1,
		category = "Misc",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28951,
				name = "ruby",
				itemId = 32383,
				amount = 1
			}
		}
	},
	{
		itemId = 53252,
		experience = 4000,
		durability = 4,
		index = 163,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Gemstone Dust",
		progress = 100,
		description = "Used in various recipes. The powder is so fine and iridescent that it's impossible to tell which gem it came from.",
		clientId = 49799,
		tier = -1,
		category = "Misc",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28952,
				name = "sapphire",
				itemId = 32384,
				amount = 1
			}
		}
	},
	{
		itemId = 53252,
		experience = 4000,
		durability = 4,
		index = 164,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Gemstone Dust",
		progress = 100,
		description = "Used in various recipes. The powder is so fine and iridescent that it's impossible to tell which gem it came from.",
		clientId = 49799,
		tier = -1,
		category = "Misc",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28953,
				name = "topaz",
				itemId = 32385,
				amount = 1
			}
		}
	},
	{
		itemId = 53252,
		experience = 4000,
		durability = 4,
		index = 165,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Gemstone Dust",
		progress = 100,
		description = "Used in various recipes. The powder is so fine and iridescent that it's impossible to tell which gem it came from.",
		clientId = 49799,
		tier = -1,
		category = "Misc",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28950,
				name = "emerald",
				itemId = 32382,
				amount = 1
			}
		}
	},
	{
		itemId = 53252,
		experience = 4000,
		durability = 4,
		index = 166,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Gemstone Dust",
		progress = 100,
		description = "Used in various recipes. The powder is so fine and iridescent that it's impossible to tell which gem it came from.",
		clientId = 49799,
		tier = -1,
		category = "Misc",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28948,
				name = "amethyst",
				itemId = 32380,
				amount = 1
			}
		}
	},
	{
		itemId = 53252,
		experience = 4000,
		durability = 4,
		index = 167,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Gemstone Dust",
		progress = 100,
		description = "Used in various recipes. The powder is so fine and iridescent that it's impossible to tell which gem it came from.",
		clientId = 49799,
		tier = -1,
		category = "Misc",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28949,
				name = "citrine",
				itemId = 32381,
				amount = 1
			}
		}
	},
	{
		itemId = 53257,
		experience = 20000,
		durability = 6,
		index = 168,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Metallic Reinforcement",
		progress = 250,
		description = "Used in housing upgrades. Modestly enhances the protection of a room to withstand heavy training.",
		clientId = 49804,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				clientId = 47288,
				name = "Weak Racks",
				itemId = 50741,
				amount = 2
			},
			{
				clientId = 47285,
				name = "Wall Reinforcement",
				itemId = 50738,
				amount = 4
			}
		}
	},
	{
		itemId = 53255,
		experience = 47000,
		durability = 8,
		index = 169,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Metallic Barrier",
		progress = 425,
		description = "Used in housing upgrades. Enhances the protection of a room to withstand heavy training.",
		clientId = 49802,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 47276,
				name = "Armory Racks",
				itemId = 50729,
				amount = 2
			},
			{
				clientId = 47285,
				name = "Wall Reinforcement",
				itemId = 50738,
				amount = 8
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		itemId = 53256,
		index = 170,
		slotName = "",
		name = "Metallic Fortification",
		progress = 700,
		profession = 5,
		clientId = 49803,
		durability = 12,
		experience = 1300000,
		specialization = "Craftsman",
		description = "Used in housing upgrades. Greatly enhances the protection of a room to withstand heavy training.",
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 47281,
				name = "Reinforced Racks",
				itemId = 50734,
				amount = 2
			},
			{
				clientId = 47284,
				name = "Wall Fortification",
				itemId = 50737,
				amount = 4
			}
		}
	},
	{
		itemId = 53262,
		experience = 17450,
		durability = 5,
		index = 171,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Pathfinder's Gear",
		progress = 200,
		description = "Used in housing upgrades. A basic bundle of equipment to aid explorers in their journal.",
		clientId = 49809,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 47288,
				name = "Weak Racks",
				itemId = 50741,
				amount = 3
			},
			{
				clientId = 47277,
				name = "Basic Stabilizer",
				itemId = 50730,
				amount = 1
			}
		}
	},
	{
		itemId = 53263,
		experience = 48375,
		durability = 8,
		index = 172,
		profession = 5,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Pioneer's Gear",
		progress = 500,
		description = "Used in housing upgrades. A diverse array of equipment to enhance various physical training sessions.",
		clientId = 49810,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 47276,
				name = "Armory Racks",
				itemId = 50729,
				amount = 3
			},
			{
				clientId = 47278,
				name = "Energy Stabilizer",
				itemId = 50731,
				amount = 1
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		itemId = 53250,
		index = 173,
		slotName = "",
		name = "Conqueror's Gear",
		progress = 700,
		profession = 5,
		clientId = 49797,
		durability = 12,
		experience = 125000,
		specialization = "Craftsman",
		description = "Used in housing upgrades. A vast array of equipment acquired through perilous adventures across the land, symbolizing an epic conquest.",
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 47281,
				name = "Reinforced Racks",
				itemId = 50734,
				amount = 3
			},
			{
				clientId = 47275,
				name = "Arcane Stabilizer",
				itemId = 50728,
				amount = 1
			}
		}
	}
}
questRecipes = questRecipes or {}
questRecipes[ProfessionBlacksmithing] = {
	{
		itemId = 32417,
		experience = 0,
		durability = 3,
		index = 1,
		profession = 5,
		quality = 50,
		slotName = "greatsword",
		amount = 1,
		name = "Burnished Greatsword",
		progress = 50,
		description = "",
		clientId = 28985,
		tier = 1,
		category = "quest",
		level = {
			single = 1
		},
		materials = {
			{
				clientId = 28726,
				name = "Copper Ingot",
				itemId = 38874,
				amount = 4
			},
			{
				clientId = 35432,
				name = "Coarse Leather",
				itemId = 38875,
				amount = 4
			}
		}
	},
	{
		itemId = 32491,
		experience = 0,
		durability = 3,
		index = 2,
		profession = 5,
		quality = 50,
		slotName = "sword",
		amount = 1,
		name = "Rough Sword",
		progress = 50,
		description = "",
		clientId = 29059,
		tier = 1,
		category = "quest",
		level = {
			single = 1
		},
		materials = {
			{
				clientId = 28726,
				name = "Copper Ingot",
				itemId = 38874,
				amount = 2
			},
			{
				clientId = 35432,
				name = "Coarse Leather",
				itemId = 38875,
				amount = 2
			}
		}
	},
	{
		itemId = 32424,
		experience = 0,
		durability = 3,
		index = 3,
		profession = 5,
		quality = 50,
		slotName = "axe",
		amount = 1,
		name = "Wicked Axe",
		progress = 50,
		description = "",
		clientId = 28992,
		tier = 1,
		category = "quest",
		level = {
			single = 1
		},
		materials = {
			{
				clientId = 28726,
				name = "Copper Ingot",
				itemId = 38874,
				amount = 3
			},
			{
				clientId = 35432,
				name = "Coarse Leather",
				itemId = 38875,
				amount = 1
			}
		}
	},
	{
		itemId = 32436,
		experience = 0,
		durability = 3,
		index = 4,
		profession = 5,
		quality = 50,
		slotName = "club",
		amount = 1,
		name = "Solid Mace",
		progress = 50,
		description = "",
		clientId = 29004,
		tier = 1,
		category = "quest",
		level = {
			single = 1
		},
		materials = {
			{
				clientId = 28726,
				name = "Copper Ingot",
				itemId = 38874,
				amount = 3
			},
			{
				clientId = 35432,
				name = "Coarse Leather",
				itemId = 38875,
				amount = 1
			}
		}
	},
	{
		itemId = 32442,
		experience = 0,
		durability = 3,
		index = 5,
		profession = 5,
		quality = 50,
		slotName = "dagger",
		amount = 1,
		name = "Serrated Dagger",
		progress = 50,
		description = "",
		clientId = 29010,
		tier = 1,
		category = "quest",
		level = {
			single = 1
		},
		materials = {
			{
				clientId = 28726,
				name = "Copper Ingot",
				itemId = 38874,
				amount = 2
			},
			{
				clientId = 35432,
				name = "Coarse Leather",
				itemId = 38875,
				amount = 2
			}
		}
	},
	{
		itemId = 32410,
		experience = 0,
		durability = 3,
		index = 7,
		profession = 5,
		quality = 50,
		slotName = "greataxe",
		amount = 1,
		name = "Rough Greataxe",
		progress = 50,
		description = "",
		clientId = 28978,
		tier = 1,
		category = "quest",
		level = {
			single = 1
		},
		materials = {
			{
				clientId = 28726,
				name = "Copper Ingot",
				itemId = 38874,
				amount = 6
			},
			{
				clientId = 35432,
				name = "Coarse Leather",
				itemId = 38875,
				amount = 2
			}
		}
	},
	{
		itemId = 32448,
		experience = 0,
		durability = 3,
		index = 8,
		profession = 5,
		quality = 50,
		slotName = "hammer",
		amount = 1,
		name = "Shipbuilding Mallet",
		progress = 50,
		description = "",
		clientId = 29016,
		tier = 1,
		category = "quest",
		level = {
			single = 1
		},
		materials = {
			{
				clientId = 28726,
				name = "Copper Ingot",
				itemId = 38874,
				amount = 6
			},
			{
				clientId = 35432,
				name = "Coarse Leather",
				itemId = 38875,
				amount = 2
			}
		}
	},
	{
		itemId = 32110,
		experience = 0,
		durability = 3,
		index = 9,
		profession = 5,
		quality = 50,
		slotName = "plate armor",
		amount = 1,
		name = "Pliant Armor",
		progress = 50,
		description = "",
		clientId = 28678,
		tier = 1,
		category = "quest",
		level = {
			single = 1
		},
		materials = {
			{
				clientId = 28726,
				name = "Copper Ingot",
				itemId = 38878,
				amount = 1
			},
			{
				clientId = 35432,
				name = "Coarse Leather",
				itemId = 38879,
				amount = 1
			}
		}
	},
	{
		itemId = 32116,
		experience = 0,
		durability = 3,
		index = 10,
		profession = 5,
		quality = 50,
		slotName = "plate helmet",
		amount = 1,
		name = "Pliant Helmet",
		progress = 50,
		description = "",
		clientId = 28684,
		tier = 1,
		category = "quest",
		level = {
			single = 1
		},
		materials = {
			{
				clientId = 28726,
				name = "Copper Ingot",
				itemId = 38882,
				amount = 1
			},
			{
				clientId = 35432,
				name = "Coarse Leather",
				itemId = 38883,
				amount = 1
			}
		}
	},
	{
		itemId = 32117,
		experience = 0,
		durability = 3,
		index = 11,
		profession = 5,
		quality = 50,
		slotName = "plate legs",
		amount = 1,
		name = "Pliant Legs",
		progress = 50,
		description = "",
		clientId = 28685,
		tier = 1,
		category = "quest",
		level = {
			single = 1
		},
		materials = {
			{
				clientId = 28726,
				name = "Copper Ingot",
				itemId = 38886,
				amount = 1
			},
			{
				clientId = 35432,
				name = "Coarse Leather",
				itemId = 38887,
				amount = 1
			}
		}
	},
	{
		itemId = 32113,
		experience = 0,
		durability = 3,
		index = 12,
		profession = 5,
		quality = 50,
		slotName = "plate boots",
		amount = 1,
		name = "Pliant Boots",
		progress = 50,
		description = "",
		clientId = 28681,
		tier = 1,
		category = "quest",
		level = {
			single = 1
		},
		materials = {
			{
				clientId = 28726,
				name = "Copper Ingot",
				itemId = 38890,
				amount = 1
			},
			{
				clientId = 35432,
				name = "Coarse Leather",
				itemId = 38891,
				amount = 1
			}
		}
	},
	{
		itemId = 40559,
		experience = 0,
		durability = 3,
		index = 13,
		profession = 5,
		quality = 50,
		slotName = "light blade",
		amount = 1,
		name = "Skirmisher's Blade",
		progress = 50,
		description = "",
		clientId = 37107,
		tier = 1,
		category = "quest",
		level = {
			single = 1
		},
		materials = {
			{
				clientId = 28726,
				name = "Copper Ingot",
				itemId = 38874,
				amount = 4
			},
			{
				clientId = 35432,
				name = "Coarse Leather",
				itemId = 38875,
				amount = 4
			}
		}
	}
}
