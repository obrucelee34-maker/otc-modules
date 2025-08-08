-- chunkname: @/modules/game_profession/recipes/carpentry.lua

recipes = recipes or {}
recipes[ProfessionCarpentry] = {
	{
		itemId = 32176,
		experience = 440,
		durability = 4,
		index = 1,
		profession = 4,
		quality = 75,
		slotName = "",
		amount = 1,
		name = "rough plank",
		progress = 25,
		description = "Used in various recipes. Unpolished and rugged.",
		clientId = 28744,
		tier = -1,
		category = "planks",
		level = {
			single = 1,
			mass = 6
		},
		materials = {
			{
				clientId = 28977,
				name = "Small Log",
				itemId = 32409,
				amount = 6
			}
		}
	},
	{
		itemId = 32175,
		experience = 880,
		durability = 7,
		index = 2,
		profession = 4,
		quality = 150,
		slotName = "",
		amount = 1,
		name = "refined plank",
		progress = 150,
		description = "Used in various recipes. Meticulously processed for smoothness and uniformity.",
		clientId = 28743,
		tier = -1,
		category = "planks",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 45504,
				name = "Heavy Log",
				itemId = 48956,
				amount = 4
			}
		}
	},
	{
		itemId = 32177,
		experience = 1360,
		durability = 7,
		index = 3,
		profession = 4,
		quality = 200,
		slotName = "",
		amount = 1,
		name = "treated plank",
		progress = 225,
		description = "Used in various recipes. Enhanced for durability and resistance.",
		clientId = 28745,
		tier = -1,
		category = "planks",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 45504,
				name = "Heavy Log",
				itemId = 48956,
				amount = 6
			},
			{
				clientId = 34899,
				name = "Oil",
				itemId = 38331,
				amount = 2
			}
		}
	},
	{
		itemId = 32431,
		experience = 3680,
		durability = 4,
		index = 4,
		profession = 4,
		quality = 100,
		slotName = "bow",
		amount = 1,
		name = "Viper's Bow",
		progress = 100,
		description = "",
		clientId = 28999,
		tier = 2,
		category = "weapons",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28744,
				name = "rough plank",
				itemId = 32176,
				amount = 6
			},
			{
				clientId = 28971,
				name = "coarse thread",
				itemId = 32403,
				amount = 2
			},
			{
				clientId = 28998,
				name = "Oakwood Bow",
				itemId = 32430,
				amount = 1
			}
		}
	},
	{
		itemId = 32483,
		experience = 3680,
		durability = 4,
		index = 5,
		profession = 4,
		quality = 100,
		slotName = "staff",
		amount = 1,
		name = "Warlock Staff",
		progress = 100,
		description = "",
		clientId = 29051,
		tier = 2,
		category = "weapons",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28744,
				name = "rough plank",
				itemId = 32176,
				amount = 8
			},
			{
				clientId = 29050,
				name = "Mystic Staff",
				itemId = 32482,
				amount = 1
			}
		}
	},
	{
		itemId = 37423,
		experience = 1840,
		durability = 4,
		index = 6,
		profession = 4,
		quality = 100,
		slotName = "sceptre",
		amount = 1,
		name = "Tribal Sceptre",
		progress = 100,
		description = "",
		clientId = 33991,
		tier = 2,
		category = "weapons",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28744,
				name = "rough plank",
				itemId = 32176,
				amount = 4
			},
			{
				clientId = 33990,
				name = "Knotted Sceptre",
				itemId = 37422,
				amount = 1
			}
		}
	},
	{
		itemId = 32432,
		experience = 14000,
		durability = 5,
		index = 7,
		profession = 4,
		quality = 100,
		slotName = "bow",
		amount = 1,
		name = "Black Ash Bow",
		progress = 200,
		description = "",
		clientId = 29000,
		tier = 3,
		category = "weapons",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 28743,
				name = "refined plank",
				itemId = 32175,
				amount = 10
			},
			{
				clientId = 28972,
				name = "craftman's thread",
				itemId = 32404,
				amount = 5
			},
			{
				clientId = 28999,
				name = "Viper's Bow",
				itemId = 32431,
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
		itemId = 32484,
		experience = 14000,
		durability = 5,
		index = 8,
		profession = 4,
		quality = 100,
		slotName = "staff",
		amount = 1,
		name = "Cultist Staff",
		progress = 200,
		description = "",
		clientId = 29052,
		tier = 3,
		category = "weapons",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 28743,
				name = "refined plank",
				itemId = 32175,
				amount = 16
			},
			{
				clientId = 29051,
				name = "Warlock Staff",
				itemId = 32483,
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
		itemId = 37424,
		experience = 7000,
		durability = 5,
		index = 9,
		profession = 4,
		quality = 100,
		slotName = "sceptre",
		amount = 1,
		name = "Serpent Sceptre",
		progress = 200,
		description = "",
		clientId = 33992,
		tier = 3,
		category = "weapons",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 28743,
				name = "refined plank",
				itemId = 32175,
				amount = 10
			},
			{
				clientId = 33991,
				name = "Tribal Sceptre",
				itemId = 37423,
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
		itemId = 32433,
		experience = 38000,
		durability = 7,
		index = 10,
		profession = 4,
		quality = 100,
		slotName = "bow",
		amount = 1,
		name = "Bullseye Bow",
		progress = 350,
		description = "",
		clientId = 29001,
		tier = 4,
		category = "weapons",
		level = {
			single = 40,
			mass = 45
		},
		materials = {
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 18
			},
			{
				clientId = 28973,
				name = "fine thread",
				itemId = 32405,
				amount = 7
			},
			{
				clientId = 29000,
				name = "Black Ash Bow",
				itemId = 32432,
				amount = 1
			},
			{
				clientId = 38271,
				name = "Sturdy String",
				itemId = 41723,
				amount = 16
			}
		}
	},
	{
		itemId = 32485,
		experience = 38000,
		durability = 7,
		index = 11,
		profession = 4,
		quality = 100,
		slotName = "staff",
		amount = 1,
		name = "Celestial Staff",
		progress = 350,
		description = "",
		clientId = 29053,
		tier = 4,
		category = "weapons",
		level = {
			single = 40,
			mass = 45
		},
		materials = {
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 28
			},
			{
				clientId = 29052,
				name = "Cultist Staff",
				itemId = 32484,
				amount = 1
			},
			{
				clientId = 40264,
				name = "Ambersprite Shard",
				itemId = 43716,
				amount = 16
			}
		}
	},
	{
		itemId = 37425,
		experience = 19000,
		durability = 7,
		index = 12,
		profession = 4,
		quality = 100,
		slotName = "sceptre",
		amount = 1,
		name = "Crystal Sceptre",
		progress = 350,
		description = "",
		clientId = 33993,
		tier = 4,
		category = "weapons",
		level = {
			single = 40,
			mass = 45
		},
		materials = {
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 15
			},
			{
				clientId = 33992,
				name = "Serpent Sceptre",
				itemId = 37424,
				amount = 1
			},
			{
				clientId = 40264,
				name = "Ambersprite Shard",
				itemId = 43716,
				amount = 8
			}
		}
	},
	{
		itemId = 32434,
		experience = 79000,
		durability = 9,
		index = 13,
		profession = 4,
		quality = 100,
		slotName = "bow",
		amount = 1,
		name = "Predator Bow",
		progress = 525,
		description = "",
		clientId = 29002,
		tier = 5,
		category = "weapons",
		level = {
			single = 55,
			mass = 60
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 32
			},
			{
				clientId = 28969,
				name = "merchant's thread",
				itemId = 32401,
				amount = 14
			},
			{
				clientId = 29001,
				name = "Bullseye Bow",
				itemId = 32433,
				amount = 1
			},
			{
				clientId = 40272,
				name = "Hardwood",
				itemId = 43724,
				amount = 20
			}
		}
	},
	{
		itemId = 32486,
		experience = 79000,
		durability = 9,
		index = 14,
		profession = 4,
		quality = 100,
		slotName = "staff",
		amount = 1,
		name = "Lightshard Staff",
		progress = 525,
		description = "",
		clientId = 29054,
		tier = 5,
		category = "weapons",
		level = {
			single = 55,
			mass = 60
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 52
			},
			{
				clientId = 29053,
				name = "Celestial Staff",
				itemId = 32485,
				amount = 1
			},
			{
				clientId = 40270,
				name = "Enervating Core",
				itemId = 43722,
				amount = 20
			}
		}
	},
	{
		itemId = 37426,
		experience = 39500,
		durability = 9,
		index = 15,
		profession = 4,
		quality = 100,
		slotName = "sceptre",
		amount = 1,
		name = "Celestial Sceptre",
		progress = 525,
		description = "",
		clientId = 33994,
		tier = 5,
		category = "weapons",
		level = {
			single = 55,
			mass = 60
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 26
			},
			{
				clientId = 33993,
				name = "Crystal Sceptre",
				itemId = 37425,
				amount = 1
			},
			{
				clientId = 40270,
				name = "Enervating Core",
				itemId = 43722,
				amount = 10
			}
		}
	},
	{
		itemId = 32328,
		experience = 1040,
		durability = 4,
		index = 16,
		profession = 4,
		quality = 0,
		slotName = "fishing rod",
		amount = 1,
		name = "fishing stick",
		progress = 100,
		description = "",
		clientId = 28896,
		tier = 1,
		category = "fishing",
		level = {
			single = 3,
			mass = 8
		},
		materials = {
			{
				clientId = 28744,
				name = "rough plank",
				itemId = 32176,
				amount = 1
			},
			{
				clientId = 28971,
				name = "coarse thread",
				itemId = 32403,
				amount = 1
			}
		}
	},
	{
		itemId = 32330,
		experience = 2080,
		durability = 5,
		index = 17,
		profession = 4,
		quality = 0,
		slotName = "fishing rod",
		amount = 1,
		name = "fishing rod",
		progress = 200,
		description = "",
		clientId = 28898,
		tier = 2,
		category = "fishing",
		level = {
			single = 18,
			mass = 23
		},
		materials = {
			{
				clientId = 28744,
				name = "rough plank",
				itemId = 32176,
				amount = 2
			},
			{
				clientId = 28971,
				name = "coarse thread",
				itemId = 32403,
				amount = 2
			},
			{
				clientId = 28896,
				name = "fishing stick",
				itemId = 32328,
				amount = 1
			}
		}
	},
	{
		itemId = 32327,
		experience = 6240,
		durability = 6,
		index = 18,
		profession = 4,
		quality = 0,
		slotName = "fishing rod",
		amount = 1,
		name = "craftman's fishing rod",
		progress = 250,
		description = "",
		clientId = 28895,
		tier = 3,
		category = "fishing",
		level = {
			single = 28,
			mass = 33
		},
		materials = {
			{
				clientId = 28743,
				name = "refined plank",
				itemId = 32175,
				amount = 3
			},
			{
				clientId = 28972,
				name = "craftman's thread",
				itemId = 32404,
				amount = 3
			},
			{
				clientId = 28898,
				name = "fishing rod",
				itemId = 32330,
				amount = 1
			}
		}
	},
	{
		itemId = 32331,
		experience = 13600,
		durability = 7,
		index = 19,
		profession = 4,
		quality = 0,
		slotName = "fishing rod",
		amount = 1,
		name = "sailor's fishing rod",
		progress = 350,
		description = "",
		clientId = 28899,
		tier = 4,
		category = "fishing",
		level = {
			single = 43,
			mass = 48
		},
		materials = {
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 3
			},
			{
				clientId = 28973,
				name = "fine thread",
				itemId = 32405,
				amount = 5
			},
			{
				clientId = 28895,
				name = "craftman's fishing rod",
				itemId = 32327,
				amount = 1
			}
		}
	},
	{
		itemId = 32332,
		experience = 44800,
		durability = 9,
		index = 20,
		profession = 4,
		quality = 0,
		slotName = "fishing rod",
		amount = 1,
		name = "artisan fishing rod",
		progress = 525,
		description = "",
		clientId = 28900,
		tier = 5,
		category = "fishing",
		level = {
			single = 58,
			mass = 63
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 10
			},
			{
				clientId = 28969,
				name = "merchant's thread",
				itemId = 32401,
				amount = 12
			},
			{
				clientId = 28899,
				name = "sailor's fishing rod",
				itemId = 32331,
				amount = 1
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		itemId = 32329,
		index = 21,
		slotName = "fishing rod",
		name = "lightwood angler",
		progress = 600,
		profession = 4,
		clientId = 28897,
		durability = 12,
		experience = 70400,
		specialization = "Angler Carpenter",
		description = "",
		tier = 6,
		category = "fishing",
		level = {
			single = 72,
			mass = 77
		},
		materials = {
			{
				clientId = 45503,
				name = "Fine Plank",
				itemId = 48955,
				amount = 10
			},
			{
				clientId = 28970,
				name = "artisan thread",
				itemId = 32402,
				amount = 16
			},
			{
				clientId = 28900,
				name = "artisan fishing rod",
				itemId = 32332,
				amount = 1
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 40607,
		index = 22,
		slotName = "bow",
		name = "Marksman Bow",
		progress = 700,
		profession = 4,
		clientId = 37155,
		durability = 12,
		experience = 115200,
		specialization = "Fletcher",
		description = "",
		tier = 6,
		category = "weapons",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 45503,
				name = "Fine Plank",
				itemId = 48955,
				amount = 36
			},
			{
				clientId = 28970,
				name = "artisan thread",
				itemId = 32402,
				amount = 12
			},
			{
				clientId = 29002,
				name = "Predator Bow",
				itemId = 32434,
				amount = 1
			},
			{
				clientId = 40279,
				name = "Supernatural Thread",
				itemId = 43731,
				amount = 24
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 40602,
		index = 23,
		slotName = "staff",
		name = "Necromancer's Staff",
		progress = 700,
		profession = 4,
		clientId = 37150,
		durability = 12,
		experience = 115200,
		specialization = "Fletcher",
		description = "",
		tier = 6,
		category = "weapons",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 45503,
				name = "Fine Plank",
				itemId = 48955,
				amount = 52
			},
			{
				clientId = 29054,
				name = "Lightshard Staff",
				itemId = 32486,
				amount = 1
			},
			{
				clientId = 40273,
				name = "Mystical Crystal",
				itemId = 43725,
				amount = 24
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 40609,
		index = 24,
		slotName = "sceptre",
		name = "Crowbone Sceptre",
		progress = 700,
		profession = 4,
		clientId = 37157,
		durability = 12,
		experience = 57600,
		specialization = "Fletcher",
		description = "",
		tier = 6,
		category = "weapons",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 45503,
				name = "Fine Plank",
				itemId = 48955,
				amount = 26
			},
			{
				clientId = 33994,
				name = "Celestial Sceptre",
				itemId = 37426,
				amount = 1
			},
			{
				clientId = 40273,
				name = "Mystical Crystal",
				itemId = 43725,
				amount = 12
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		itemId = 40671,
		index = 25,
		slotName = "",
		name = "Armoires",
		progress = 600,
		profession = 4,
		clientId = 37219,
		durability = 12,
		experience = 17000,
		specialization = "Joiner",
		description = "Used in housing upgrades.",
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 10
			},
			{
				clientId = 40282,
				name = "Bolt",
				itemId = 43734,
				amount = 5
			}
		}
	},
	{
		itemId = 40731,
		experience = 28500,
		durability = 7,
		index = 26,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Square Table",
		progress = 350,
		description = "Used in housing upgrades.",
		clientId = 37279,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 45,
			mass = 50
		},
		materials = {
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 20
			},
			{
				clientId = 40282,
				name = "Bolt",
				itemId = 43734,
				amount = 4
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		itemId = 40735,
		index = 27,
		slotName = "",
		name = "Sturdy Square Table",
		progress = 600,
		profession = 4,
		clientId = 37283,
		durability = 12,
		experience = 40000,
		specialization = "Joiner",
		description = "Used in housing upgrades.",
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 25
			},
			{
				clientId = 40282,
				name = "Bolt",
				itemId = 43734,
				amount = 5
			}
		}
	},
	{
		itemId = 40676,
		experience = 4250,
		durability = 7,
		index = 28,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Cabinet",
		progress = 350,
		description = "Used in housing upgrades.",
		clientId = 37224,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 45,
			mass = 50
		},
		materials = {
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 3
			},
			{
				clientId = 28734,
				name = "nail",
				itemId = 32166,
				amount = 1
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		itemId = 40696,
		index = 29,
		slotName = "",
		name = "Loom",
		progress = 600,
		profession = 4,
		clientId = 37244,
		durability = 12,
		experience = 24000,
		specialization = "Joiner",
		description = "Used in housing upgrades.",
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 8
			},
			{
				clientId = 28969,
				name = "merchant's thread",
				itemId = 32401,
				amount = 5
			}
		}
	},
	{
		itemId = 40679,
		experience = 7200,
		durability = 5,
		index = 30,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Chair",
		progress = 200,
		description = "Used in housing upgrades.",
		clientId = 37227,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 28743,
				name = "refined plank",
				itemId = 32175,
				amount = 8
			},
			{
				clientId = 28734,
				name = "nail",
				itemId = 32166,
				amount = 2
			}
		}
	},
	{
		itemId = 40719,
		experience = 24000,
		durability = 5,
		index = 31,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Simple Bed",
		progress = 200,
		description = "Used in housing upgrades.",
		clientId = 37267,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 28743,
				name = "refined plank",
				itemId = 32175,
				amount = 10
			},
			{
				clientId = 28966,
				name = "simple cloth",
				itemId = 32398,
				amount = 15
			},
			{
				clientId = 28971,
				name = "coarse thread",
				itemId = 32403,
				amount = 10
			}
		}
	},
	{
		itemId = 40680,
		experience = 66000,
		durability = 7,
		index = 32,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Comfortable Bed",
		progress = 350,
		description = "Used in housing upgrades.",
		clientId = 37228,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 45,
			mass = 50
		},
		materials = {
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 12
			},
			{
				clientId = 40282,
				name = "Bolt",
				itemId = 43734,
				amount = 4
			},
			{
				clientId = 28964,
				name = "merchant's cloth",
				itemId = 32396,
				amount = 10
			},
			{
				clientId = 28969,
				name = "merchant's thread",
				itemId = 32401,
				amount = 10
			}
		}
	},
	{
		itemId = 40732,
		experience = 8000,
		durability = 5,
		index = 33,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Storage Container",
		progress = 200,
		description = "Used in housing upgrades.",
		clientId = 37280,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 28743,
				name = "refined plank",
				itemId = 32175,
				amount = 8
			},
			{
				clientId = 28734,
				name = "nail",
				itemId = 32166,
				amount = 1
			},
			{
				clientId = 28737,
				name = "iron bar",
				itemId = 32169,
				amount = 1
			}
		}
	},
	{
		itemId = 40742,
		experience = 26000,
		durability = 5,
		index = 34,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Work Bench",
		progress = 200,
		description = "Used in housing upgrades.",
		clientId = 37290,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 28743,
				name = "refined plank",
				itemId = 32175,
				amount = 20
			},
			{
				clientId = 28723,
				name = "iron ingot",
				itemId = 32155,
				amount = 8
			},
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 5
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
		itemId = 40739,
		experience = 50500,
		durability = 7,
		index = 35,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Superior Work Bench",
		progress = 350,
		description = "Used in housing upgrades.",
		clientId = 37287,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 45,
			mass = 50
		},
		materials = {
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 25
			},
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 8
			},
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 5
			},
			{
				clientId = 49616,
				name = "malleable screw",
				itemId = 53069,
				amount = 4
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		itemId = 40674,
		index = 36,
		slotName = "",
		name = "Artisan Work Bench",
		progress = 600,
		profession = 4,
		clientId = 37222,
		durability = 12,
		experience = 140000,
		specialization = "Joiner",
		description = "Used in housing upgrades.",
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 65
			},
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 15
			},
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 7
			},
			{
				clientId = 40282,
				name = "Bolt",
				itemId = 43734,
				amount = 4
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		itemId = 40683,
		index = 37,
		slotName = "",
		name = "Fireplace",
		progress = 600,
		profession = 4,
		clientId = 37231,
		durability = 12,
		experience = 27600,
		specialization = "Joiner",
		description = "Used in housing upgrades.",
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 18
			},
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
				amount = 5
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		itemId = 40697,
		index = 38,
		slotName = "",
		name = "Luxury Bed",
		progress = 600,
		profession = 4,
		clientId = 37245,
		durability = 12,
		experience = 133000,
		specialization = "Joiner",
		description = "Used in housing upgrades.",
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 25
			},
			{
				clientId = 40282,
				name = "Bolt",
				itemId = 43734,
				amount = 10
			},
			{
				clientId = 28962,
				name = "artisan cloth",
				itemId = 32394,
				amount = 20
			},
			{
				clientId = 28970,
				name = "artisan thread",
				itemId = 32402,
				amount = 10
			}
		}
	},
	{
		itemId = 40727,
		experience = 27000,
		durability = 4,
		index = 39,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Small Hull Frame",
		progress = 100,
		description = "Used for crafting Ships at the Ship Builder",
		clientId = 37275,
		tier = -1,
		category = "Ship Craft",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28744,
				name = "rough plank",
				itemId = 32176,
				amount = 50
			},
			{
				clientId = 28734,
				name = "nail",
				itemId = 32166,
				amount = 20
			},
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 5
			}
		}
	},
	{
		itemId = 40722,
		experience = 18000,
		durability = 4,
		index = 40,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Small Cargo Hold",
		progress = 100,
		description = "Used for crafting Ships at the Ship Builder",
		clientId = 37270,
		tier = -1,
		category = "Ship Craft",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28744,
				name = "rough plank",
				itemId = 32176,
				amount = 30
			},
			{
				clientId = 28734,
				name = "nail",
				itemId = 32166,
				amount = 20
			},
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 3
			}
		}
	},
	{
		itemId = 40726,
		experience = 18000,
		durability = 4,
		index = 41,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Small Gun Deck",
		progress = 100,
		description = "Used for crafting Ships at the Ship Builder",
		clientId = 37274,
		tier = -1,
		category = "Ship Craft",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28744,
				name = "rough plank",
				itemId = 32176,
				amount = 30
			},
			{
				clientId = 28734,
				name = "nail",
				itemId = 32166,
				amount = 20
			},
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 3
			}
		}
	},
	{
		itemId = 40725,
		experience = 18000,
		durability = 4,
		index = 42,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Small Fishing Storage",
		progress = 100,
		description = "Used for crafting Ships at the Ship Builder",
		clientId = 37273,
		tier = -1,
		category = "Ship Craft",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28744,
				name = "rough plank",
				itemId = 32176,
				amount = 30
			},
			{
				clientId = 28734,
				name = "nail",
				itemId = 32166,
				amount = 20
			},
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 3
			}
		}
	},
	{
		itemId = 40729,
		experience = 70000,
		durability = 6,
		index = 43,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Small Tradepack Container Kit",
		progress = 225,
		description = "Used for crafting ship cabins for your ship at the Ship Builder.",
		clientId = 37277,
		tier = -1,
		category = "Ship Module",
		level = {
			single = 35,
			mass = 40
		},
		materials = {
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 35
			},
			{
				clientId = 49616,
				name = "malleable screw",
				itemId = 53069,
				amount = 10
			},
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 10
			},
			{
				clientId = 40286,
				name = "Wooden Arch",
				itemId = 43738,
				amount = 2
			}
		}
	},
	{
		itemId = 40721,
		experience = 70000,
		durability = 6,
		index = 44,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Small Ammunition Cabin Kit",
		progress = 225,
		description = "Used for crafting ship cabins for your ship at the Ship Builder.",
		clientId = 37269,
		tier = -1,
		category = "Ship Module",
		level = {
			single = 35,
			mass = 40
		},
		materials = {
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 35
			},
			{
				clientId = 49616,
				name = "malleable screw",
				itemId = 53069,
				amount = 10
			},
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 10
			},
			{
				clientId = 40286,
				name = "Wooden Arch",
				itemId = 43738,
				amount = 2
			}
		}
	},
	{
		itemId = 40723,
		experience = 70000,
		durability = 6,
		index = 45,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Small Fishing Crane Kit",
		progress = 225,
		description = "Used for crafting ship cabins for your ship at the Ship Builder.",
		clientId = 37271,
		tier = -1,
		category = "Ship Module",
		level = {
			single = 35,
			mass = 40
		},
		materials = {
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 35
			},
			{
				clientId = 49616,
				name = "malleable screw",
				itemId = 53069,
				amount = 10
			},
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 10
			},
			{
				clientId = 40286,
				name = "Wooden Arch",
				itemId = 43738,
				amount = 2
			}
		}
	},
	{
		itemId = 40708,
		experience = 195000,
		durability = 6,
		index = 46,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Medium Hull Frame",
		progress = 200,
		description = "Used for crafting Ships at the Ship Builder",
		clientId = 37256,
		tier = -1,
		category = "Ship Craft",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 80
			},
			{
				clientId = 49616,
				name = "malleable screw",
				itemId = 53069,
				amount = 40
			},
			{
				clientId = 28737,
				name = "iron bar",
				itemId = 32169,
				amount = 15
			},
			{
				clientId = 40286,
				name = "Wooden Arch",
				itemId = 43738,
				amount = 8
			},
			{
				clientId = 37275,
				name = "Small Hull Frame",
				itemId = 40727,
				amount = 1
			}
		}
	},
	{
		itemId = 40703,
		experience = 100000,
		durability = 6,
		index = 47,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Medium Cargo Hold",
		progress = 200,
		description = "Used for crafting Ships at the Ship Builder",
		clientId = 37251,
		tier = -1,
		category = "Ship Craft",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 40
			},
			{
				clientId = 49616,
				name = "malleable screw",
				itemId = 53069,
				amount = 32
			},
			{
				clientId = 28737,
				name = "iron bar",
				itemId = 32169,
				amount = 10
			},
			{
				clientId = 40286,
				name = "Wooden Arch",
				itemId = 43738,
				amount = 3
			},
			{
				clientId = 37270,
				name = "Small Cargo Hold",
				itemId = 40722,
				amount = 1
			}
		}
	},
	{
		itemId = 40706,
		experience = 100000,
		durability = 6,
		index = 48,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Medium Fishing Storage",
		progress = 200,
		description = "Used for crafting Ships at the Ship Builder",
		clientId = 37254,
		tier = -1,
		category = "Ship Craft",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 40
			},
			{
				clientId = 49616,
				name = "malleable screw",
				itemId = 53069,
				amount = 40
			},
			{
				clientId = 28737,
				name = "iron bar",
				itemId = 32169,
				amount = 10
			},
			{
				clientId = 40286,
				name = "Wooden Arch",
				itemId = 43738,
				amount = 3
			},
			{
				clientId = 37273,
				name = "Small Fishing Storage",
				itemId = 40725,
				amount = 1
			}
		}
	},
	{
		itemId = 40707,
		experience = 100000,
		durability = 6,
		index = 49,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Medium Gun Deck",
		progress = 200,
		description = "Used for crafting Ships at the Ship Builder",
		clientId = 37255,
		tier = -1,
		category = "Ship Craft",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 40
			},
			{
				clientId = 49616,
				name = "malleable screw",
				itemId = 53069,
				amount = 40
			},
			{
				clientId = 28737,
				name = "iron bar",
				itemId = 32169,
				amount = 10
			},
			{
				clientId = 40286,
				name = "Wooden Arch",
				itemId = 43738,
				amount = 3
			},
			{
				clientId = 37274,
				name = "Small Gun Deck",
				itemId = 40726,
				amount = 1
			}
		}
	},
	{
		itemId = 40710,
		experience = 200000,
		durability = 9,
		index = 50,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Medium Tradepack Container Kit",
		progress = 525,
		description = "Used for crafting ship cabins for your ship at the Ship Builder.",
		clientId = 37258,
		tier = -1,
		category = "Ship Module",
		level = {
			single = 65,
			mass = 70
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 60
			},
			{
				clientId = 40282,
				name = "Bolt",
				itemId = 43734,
				amount = 30
			},
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 5
			},
			{
				clientId = 40285,
				name = "Supple Wooden Arch",
				itemId = 43737,
				amount = 3
			},
			{
				clientId = 37277,
				name = "Small Tradepack Container Kit",
				itemId = 40729,
				amount = 1
			}
		}
	},
	{
		itemId = 40702,
		experience = 200000,
		durability = 9,
		index = 51,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Medium Ammunition Cabin Kit",
		progress = 525,
		description = "Used for crafting ship cabins for your ship at the Ship Builder.",
		clientId = 37250,
		tier = -1,
		category = "Ship Module",
		level = {
			single = 65,
			mass = 70
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 60
			},
			{
				clientId = 40282,
				name = "Bolt",
				itemId = 43734,
				amount = 30
			},
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 5
			},
			{
				clientId = 40285,
				name = "Supple Wooden Arch",
				itemId = 43737,
				amount = 3
			},
			{
				clientId = 37269,
				name = "Small Ammunition Cabin Kit",
				itemId = 40721,
				amount = 1
			}
		}
	},
	{
		itemId = 40704,
		experience = 200000,
		durability = 9,
		index = 52,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Medium Fishing Crane Kit",
		progress = 525,
		description = "Used for crafting ship cabins for your ship at the Ship Builder.",
		clientId = 37252,
		tier = -1,
		category = "Ship Module",
		level = {
			single = 65,
			mass = 70
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 60
			},
			{
				clientId = 40282,
				name = "Bolt",
				itemId = 43734,
				amount = 30
			},
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 5
			},
			{
				clientId = 40285,
				name = "Supple Wooden Arch",
				itemId = 43737,
				amount = 3
			},
			{
				clientId = 37271,
				name = "Small Fishing Crane Kit",
				itemId = 40723,
				amount = 1
			}
		}
	},
	{
		itemId = 40693,
		experience = 600000,
		durability = 8,
		index = 53,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Large Hull Frame",
		progress = 525,
		description = "Used for crafting Ships at the Ship Builder",
		clientId = 37241,
		tier = -1,
		category = "Ship Craft",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 100
			},
			{
				clientId = 40282,
				name = "Bolt",
				itemId = 43734,
				amount = 150
			},
			{
				clientId = 40284,
				name = "Steel Bar",
				itemId = 43736,
				amount = 50
			},
			{
				clientId = 40285,
				name = "Supple Wooden Arch",
				itemId = 43737,
				amount = 20
			},
			{
				clientId = 37256,
				name = "Medium Hull Frame",
				itemId = 40708,
				amount = 1
			}
		}
	},
	{
		itemId = 40689,
		experience = 300000,
		durability = 8,
		index = 54,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Large Cargo Hold",
		progress = 525,
		description = "Used for crafting Ships at the Ship Builder",
		clientId = 37237,
		tier = -1,
		category = "Ship Craft",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 60
			},
			{
				clientId = 40282,
				name = "Bolt",
				itemId = 43734,
				amount = 80
			},
			{
				clientId = 40284,
				name = "Steel Bar",
				itemId = 43736,
				amount = 20
			},
			{
				clientId = 40285,
				name = "Supple Wooden Arch",
				itemId = 43737,
				amount = 8
			},
			{
				clientId = 37251,
				name = "Medium Cargo Hold",
				itemId = 40703,
				amount = 1
			}
		}
	},
	{
		itemId = 40692,
		experience = 300000,
		durability = 8,
		index = 55,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Large Gun Deck",
		progress = 525,
		description = "Used for crafting Ships at the Ship Builder",
		clientId = 37240,
		tier = -1,
		category = "Ship Craft",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 60
			},
			{
				clientId = 40282,
				name = "Bolt",
				itemId = 43734,
				amount = 80
			},
			{
				clientId = 40284,
				name = "Steel Bar",
				itemId = 43736,
				amount = 20
			},
			{
				clientId = 40285,
				name = "Supple Wooden Arch",
				itemId = 43737,
				amount = 8
			},
			{
				clientId = 37255,
				name = "Medium Gun Deck",
				itemId = 40707,
				amount = 1
			}
		}
	},
	{
		itemId = 40691,
		experience = 300000,
		durability = 8,
		index = 56,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Large Fishing Storage",
		progress = 525,
		description = "Used for crafting ship cabins for your ship at the Ship Builder.",
		clientId = 37239,
		tier = -1,
		category = "Ship Craft",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 60
			},
			{
				clientId = 40282,
				name = "Bolt",
				itemId = 43734,
				amount = 80
			},
			{
				clientId = 40284,
				name = "Steel Bar",
				itemId = 43736,
				amount = 20
			},
			{
				clientId = 40285,
				name = "Supple Wooden Arch",
				itemId = 43737,
				amount = 8
			},
			{
				clientId = 37254,
				name = "Medium Fishing Storage",
				itemId = 40706,
				amount = 1
			}
		}
	},
	{
		itemId = 40701,
		experience = 15000,
		durability = 4,
		index = 57,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Mast",
		progress = 100,
		description = "Used for crafting Ships at the Ship Builder",
		clientId = 37249,
		tier = -1,
		category = "Ship Craft",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28744,
				name = "rough plank",
				itemId = 32176,
				amount = 20
			},
			{
				clientId = 28734,
				name = "nail",
				itemId = 32166,
				amount = 20
			},
			{
				clientId = 49614,
				name = "bronze ingot",
				itemId = 53067,
				amount = 5
			}
		}
	},
	{
		itemId = 40681,
		experience = 2000,
		durability = 4,
		index = 58,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Common Wheel",
		progress = 100,
		description = "Used for crafting Wagons at the Wagon Crafter.",
		clientId = 37229,
		tier = -1,
		category = "Wagon Craft",
		level = {
			single = 9,
			mass = 14
		},
		materials = {
			{
				clientId = 28744,
				name = "rough plank",
				itemId = 32176,
				amount = 12
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
		itemId = 40736,
		experience = 24500,
		durability = 7,
		index = 59,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Sturdy Wheel",
		progress = 350,
		description = "Used for crafting Wagons at the Wagon Crafter.",
		clientId = 37284,
		tier = -1,
		category = "Wagon Craft",
		level = {
			single = 41,
			mass = 46
		},
		materials = {
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 15
			},
			{
				clientId = 40282,
				name = "Bolt",
				itemId = 43734,
				amount = 10
			},
			{
				clientId = 41847,
				name = "Dense Plank",
				itemId = 45299,
				amount = 10
			},
			{
				clientId = 40286,
				name = "Wooden Arch",
				itemId = 43738,
				amount = 4
			},
			{
				clientId = 40492,
				name = "Swift Wheel",
				itemId = 43944,
				amount = 1
			}
		}
	},
	{
		itemId = 40716,
		experience = 49000,
		durability = 8,
		index = 60,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Reinforced Wheel",
		progress = 525,
		description = "Used for crafting Wagons at the Wagon Crafter.",
		clientId = 37264,
		tier = -1,
		category = "Wagon Craft",
		level = {
			single = 59,
			mass = 64
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 15
			},
			{
				clientId = 40282,
				name = "Bolt",
				itemId = 43734,
				amount = 15
			},
			{
				clientId = 41848,
				name = "Heavy Plank",
				itemId = 45300,
				amount = 10
			},
			{
				clientId = 40285,
				name = "Supple Wooden Arch",
				itemId = 43737,
				amount = 4
			},
			{
				clientId = 37284,
				name = "Sturdy Wheel",
				itemId = 40736,
				amount = 1
			}
		}
	},
	{
		itemId = 40730,
		experience = 12000,
		durability = 4,
		index = 61,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Small Wagon Container",
		progress = 100,
		description = "Used for crafting Wagons at the Wagon Crafter.",
		clientId = 37278,
		tier = -1,
		category = "Wagon Craft",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28744,
				name = "rough plank",
				itemId = 32176,
				amount = 20
			},
			{
				clientId = 40283,
				name = "Common Plate",
				itemId = 43735,
				amount = 1
			}
		}
	},
	{
		itemId = 40711,
		experience = 75000,
		durability = 7,
		index = 62,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Medium Wagon Container",
		progress = 350,
		description = "Used for crafting Wagons at the Wagon Crafter.",
		clientId = 37259,
		tier = -1,
		category = "Wagon Craft",
		level = {
			single = 42,
			mass = 47
		},
		materials = {
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 20
			},
			{
				clientId = 28740,
				name = "reinforced plate",
				itemId = 32172,
				amount = 5
			},
			{
				clientId = 28737,
				name = "iron bar",
				itemId = 32169,
				amount = 5
			}
		}
	},
	{
		itemId = 40695,
		experience = 195000,
		durability = 8,
		index = 63,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Large Wagon Container",
		progress = 525,
		description = "Used for crafting Wagons at the Wagon Crafter.",
		clientId = 37243,
		tier = -1,
		category = "Wagon Craft",
		level = {
			single = 60,
			mass = 65
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 35
			},
			{
				clientId = 28740,
				name = "reinforced plate",
				itemId = 32172,
				amount = 15
			},
			{
				clientId = 40284,
				name = "Steel Bar",
				itemId = 43736,
				amount = 10
			}
		}
	},
	{
		itemId = 32430,
		experience = 1760,
		durability = 3,
		index = 64,
		profession = 4,
		quality = 100,
		slotName = "bow",
		amount = 1,
		name = "Oakwood Bow",
		progress = 50,
		description = "",
		clientId = 28998,
		tier = 1,
		category = "weapons",
		level = {
			single = 1,
			mass = 6
		},
		materials = {
			{
				clientId = 28744,
				name = "rough plank",
				itemId = 32176,
				amount = 3
			},
			{
				clientId = 28971,
				name = "coarse thread",
				itemId = 32403,
				amount = 1
			}
		}
	},
	{
		itemId = 32482,
		experience = 1760,
		durability = 3,
		index = 65,
		profession = 4,
		quality = 100,
		slotName = "staff",
		amount = 1,
		name = "Mystic Staff",
		progress = 50,
		description = "",
		clientId = 29050,
		tier = 1,
		category = "weapons",
		level = {
			single = 1,
			mass = 6
		},
		materials = {
			{
				clientId = 28744,
				name = "rough plank",
				itemId = 32176,
				amount = 4
			}
		}
	},
	{
		itemId = 37422,
		experience = 880,
		durability = 3,
		index = 66,
		profession = 4,
		quality = 100,
		slotName = "sceptre",
		amount = 1,
		name = "Knotted Sceptre",
		progress = 50,
		description = "",
		clientId = 33990,
		tier = 1,
		category = "weapons",
		level = {
			single = 1,
			mass = 6
		},
		materials = {
			{
				clientId = 28744,
				name = "rough plank",
				itemId = 32176,
				amount = 2
			}
		}
	},
	{
		itemId = 43738,
		experience = 4800,
		durability = 5,
		index = 67,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Wooden Arch",
		progress = 200,
		description = "Used in various recipes. A basic but sturdy wooden arch.",
		clientId = 40286,
		tier = -1,
		category = "Wagon Craft",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 28743,
				name = "refined plank",
				itemId = 32175,
				amount = 15
			},
			{
				clientId = 34899,
				name = "Oil",
				itemId = 38331,
				amount = 10
			}
		}
	},
	{
		itemId = 43737,
		experience = 7600,
		durability = 7,
		index = 68,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Supple Wooden Arch",
		progress = 350,
		description = "Used in various recipes. Crafted with precision, this arch combines flexibility with strength.",
		clientId = 40285,
		tier = -1,
		category = "Wagon Craft",
		level = {
			single = 45,
			mass = 50
		},
		materials = {
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 15
			},
			{
				clientId = 34899,
				name = "Oil",
				itemId = 38331,
				amount = 20
			}
		}
	},
	{
		itemId = 43944,
		experience = 6000,
		durability = 6,
		index = 69,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Swift Wheel",
		progress = 225,
		description = "Used for crafting Wagons at the Wagon Crafter.",
		clientId = 40492,
		tier = -1,
		category = "Wagon Craft",
		level = {
			single = 26,
			mass = 31
		},
		materials = {
			{
				clientId = 28743,
				name = "refined plank",
				itemId = 32175,
				amount = 10
			},
			{
				clientId = 49616,
				name = "malleable screw",
				itemId = 53069,
				amount = 8
			},
			{
				clientId = 41847,
				name = "Dense Plank",
				itemId = 45299,
				amount = 3
			},
			{
				clientId = 37229,
				name = "Common Wheel",
				itemId = 40681,
				amount = 1
			}
		}
	},
	{
		itemId = 43943,
		experience = 33000,
		durability = 6,
		index = 70,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Common Wagon Container",
		progress = 225,
		description = "Used for crafting Wagons at the Wagon Crafter.",
		clientId = 40491,
		tier = -1,
		category = "Wagon Craft",
		level = {
			single = 27,
			mass = 32
		},
		materials = {
			{
				clientId = 28743,
				name = "refined plank",
				itemId = 32175,
				amount = 25
			},
			{
				clientId = 40283,
				name = "Common Plate",
				itemId = 43735,
				amount = 3
			}
		}
	},
	{
		itemId = 45299,
		experience = 2000,
		durability = 4,
		index = 74,
		profession = 4,
		quality = 100,
		slotName = "",
		amount = 1,
		name = "Dense Plank",
		progress = 100,
		description = "Used in various recipes. Sturdy crafting material crafted from dense logs.",
		clientId = 41847,
		tier = -1,
		category = "planks",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 34371,
				name = "Dense Log",
				itemId = 37803,
				amount = 4
			}
		}
	},
	{
		itemId = 45300,
		experience = 4400,
		durability = 6,
		index = 75,
		profession = 4,
		quality = 250,
		slotName = "",
		amount = 1,
		name = "Heavy Plank",
		progress = 250,
		description = "Used in various recipes. Exceptionally robust crafting material forged from dense logs.",
		clientId = 41848,
		tier = -1,
		category = "planks",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				clientId = 34371,
				name = "Dense Log",
				itemId = 37803,
				amount = 8
			},
			{
				clientId = 34899,
				name = "Oil",
				itemId = 38331,
				amount = 2
			}
		}
	},
	{
		itemId = 46229,
		experience = 3600,
		durability = 4,
		index = 76,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Weak Table",
		progress = 100,
		description = "Used in housing upgrades.",
		clientId = 42777,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28744,
				name = "rough plank",
				itemId = 32176,
				amount = 8
			},
			{
				clientId = 28734,
				name = "nail",
				itemId = 32166,
				amount = 2
			}
		}
	},
	{
		itemId = 46234,
		experience = 41600,
		durability = 8,
		index = 77,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Sturdy Container",
		progress = 500,
		description = "Used in housing upgrades.",
		clientId = 42782,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 18
			},
			{
				clientId = 40283,
				name = "Common Plate",
				itemId = 43735,
				amount = 4
			}
		}
	},
	{
		itemId = 46233,
		experience = 8000,
		durability = 4,
		index = 78,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Frail Loom",
		progress = 100,
		description = "Used in housing upgrades.",
		clientId = 42781,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28744,
				name = "rough plank",
				itemId = 32176,
				amount = 10
			},
			{
				clientId = 28966,
				name = "simple cloth",
				itemId = 32398,
				amount = 6
			}
		}
	},
	{
		itemId = 46235,
		experience = 23000,
		durability = 6,
		index = 79,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Simple Loom",
		progress = 250,
		description = "Used in housing upgrades.",
		clientId = 42783,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 10
			},
			{
				clientId = 28973,
				name = "fine thread",
				itemId = 32405,
				amount = 5
			}
		}
	},
	{
		itemId = 47090,
		experience = 70000,
		durability = 6,
		index = 80,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Small Maintenance Unit Kit",
		progress = 225,
		description = "Used for crafting ship cabins for your ship at the Ship Builder.",
		clientId = 43638,
		tier = -1,
		category = "Ship Module",
		level = {
			single = 35,
			mass = 40
		},
		materials = {
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 35
			},
			{
				clientId = 49616,
				name = "malleable screw",
				itemId = 53069,
				amount = 10
			},
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 10
			},
			{
				clientId = 40286,
				name = "Wooden Arch",
				itemId = 43738,
				amount = 2
			}
		}
	},
	{
		itemId = 47087,
		experience = 200000,
		durability = 9,
		index = 81,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Medium Maintenance Unit Kit",
		progress = 525,
		description = "Used for crafting ship cabins for your ship at the Ship Builder.",
		clientId = 43635,
		tier = -1,
		category = "Ship Module",
		level = {
			single = 65,
			mass = 70
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 60
			},
			{
				clientId = 40282,
				name = "Bolt",
				itemId = 43734,
				amount = 30
			},
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 5
			},
			{
				clientId = 40285,
				name = "Supple Wooden Arch",
				itemId = 43737,
				amount = 3
			},
			{
				clientId = 43638,
				name = "Small Maintenance Unit Kit",
				itemId = 47090,
				amount = 1
			}
		}
	},
	{
		itemId = 48958,
		experience = 1500,
		durability = 8,
		index = 82,
		profession = 4,
		quality = 450,
		slotName = "",
		amount = 1,
		name = "Sturdy Plank",
		progress = 450,
		description = "Used in various recipes. A solid and dependable wooden plank.",
		clientId = 45506,
		tier = -1,
		category = "planks",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 45505,
				name = "Sturdy Log",
				itemId = 48957,
				amount = 5
			},
			{
				clientId = 34899,
				name = "Oil",
				itemId = 38331,
				amount = 4
			}
		}
	},
	{
		itemId = 48955,
		experience = 2200,
		durability = 9,
		index = 83,
		profession = 4,
		quality = 550,
		slotName = "",
		amount = 1,
		name = "Fine Plank",
		progress = 550,
		description = "Used in various recipes. A meticulously crafted wooden plank.",
		clientId = 45503,
		tier = -1,
		category = "planks",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 45502,
				name = "Fine Log",
				itemId = 48954,
				amount = 6
			},
			{
				clientId = 34899,
				name = "Oil",
				itemId = 38331,
				amount = 6
			}
		}
	},
	{
		itemId = 32460,
		experience = 880,
		durability = 3,
		index = 84,
		profession = 4,
		quality = 100,
		slotName = "buckler shield",
		amount = 1,
		name = "Wooden Buckler",
		progress = 50,
		description = "",
		clientId = 29028,
		tier = 1,
		category = "weapons",
		level = {
			single = 1,
			mass = 6
		},
		materials = {
			{
				clientId = 28744,
				name = "rough plank",
				itemId = 32176,
				amount = 2
			}
		}
	},
	{
		itemId = 32461,
		experience = 1840,
		durability = 4,
		index = 85,
		profession = 4,
		quality = 100,
		slotName = "buckler shield",
		amount = 1,
		name = "Sturdy Buckler",
		progress = 100,
		description = "",
		clientId = 29029,
		tier = 2,
		category = "weapons",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28744,
				name = "rough plank",
				itemId = 32176,
				amount = 3
			},
			{
				clientId = 35432,
				name = "Coarse Leather",
				itemId = 38864,
				amount = 1
			},
			{
				clientId = 29028,
				name = "Wooden Buckler",
				itemId = 32460,
				amount = 1
			}
		}
	},
	{
		itemId = 32462,
		experience = 7000,
		durability = 6,
		index = 86,
		profession = 4,
		quality = 100,
		slotName = "buckler shield",
		amount = 1,
		name = "Marauder's Shield",
		progress = 200,
		description = "",
		clientId = 29030,
		tier = 3,
		category = "weapons",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 28743,
				name = "refined plank",
				itemId = 32175,
				amount = 5
			},
			{
				clientId = 35433,
				name = "Craftman's Leather",
				itemId = 38865,
				amount = 2
			},
			{
				clientId = 29029,
				name = "Sturdy Buckler",
				itemId = 32461,
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
		itemId = 32463,
		experience = 19000,
		durability = 7,
		index = 87,
		profession = 4,
		quality = 100,
		slotName = "buckler shield",
		amount = 1,
		name = "Rune Shield",
		progress = 350,
		description = "",
		clientId = 29031,
		tier = 4,
		category = "weapons",
		level = {
			single = 40,
			mass = 45
		},
		materials = {
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 12
			},
			{
				clientId = 35434,
				name = "Tanned Leather",
				itemId = 38866,
				amount = 3
			},
			{
				clientId = 29030,
				name = "Marauder's Shield",
				itemId = 32462,
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
		itemId = 32464,
		experience = 39500,
		durability = 8,
		index = 88,
		profession = 4,
		quality = 100,
		slotName = "buckler shield",
		amount = 1,
		name = "Ravenguard's Shield",
		progress = 525,
		description = "",
		clientId = 29032,
		tier = 5,
		category = "weapons",
		level = {
			single = 55,
			mass = 60
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 20
			},
			{
				clientId = 35435,
				name = "Merchant's Leather",
				itemId = 38867,
				amount = 4
			},
			{
				clientId = 29031,
				name = "Rune Shield",
				itemId = 32463,
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
		amount = 1,
		quality = 100,
		itemId = 40601,
		index = 89,
		slotName = "buckler shield",
		name = "Nocturnal Shield",
		progress = 700,
		profession = 4,
		clientId = 37149,
		durability = 12,
		experience = 57600,
		specialization = "Fletcher",
		description = "",
		tier = 6,
		category = "weapons",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 45503,
				name = "Fine Plank",
				itemId = 48955,
				amount = 22
			},
			{
				clientId = 35436,
				name = "Artisan Leather",
				itemId = 38868,
				amount = 4
			},
			{
				clientId = 29032,
				name = "Ravenguard's Shield",
				itemId = 32464,
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
		itemId = 49694,
		experience = 880,
		durability = 3,
		index = 90,
		profession = 4,
		quality = 100,
		slotName = "tower shield",
		amount = 1,
		name = "Wooden Bulwark",
		progress = 50,
		description = "",
		clientId = 46241,
		tier = 1,
		category = "weapons",
		level = {
			single = 1,
			mass = 6
		},
		materials = {
			{
				clientId = 28744,
				name = "rough plank",
				itemId = 32176,
				amount = 2
			}
		}
	},
	{
		itemId = 49695,
		experience = 1840,
		durability = 4,
		index = 91,
		profession = 4,
		quality = 100,
		slotName = "tower shield",
		amount = 1,
		name = "Sentinel Shield",
		progress = 100,
		description = "",
		clientId = 46242,
		tier = 2,
		category = "weapons",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28744,
				name = "rough plank",
				itemId = 32176,
				amount = 3
			},
			{
				clientId = 28726,
				name = "copper ingot",
				itemId = 32158,
				amount = 1
			},
			{
				clientId = 46241,
				name = "Wooden Bulwark",
				itemId = 49694,
				amount = 1
			}
		}
	},
	{
		itemId = 49696,
		experience = 7000,
		durability = 6,
		index = 92,
		profession = 4,
		quality = 100,
		slotName = "tower shield",
		amount = 1,
		name = "Defender's Bulwark",
		progress = 200,
		description = "",
		clientId = 46243,
		tier = 3,
		category = "weapons",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 28743,
				name = "refined plank",
				itemId = 32175,
				amount = 6
			},
			{
				clientId = 28723,
				name = "iron ingot",
				itemId = 32155,
				amount = 3
			},
			{
				clientId = 46242,
				name = "Sentinel Shield",
				itemId = 49695,
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
		itemId = 49697,
		experience = 19000,
		durability = 7,
		index = 93,
		profession = 4,
		quality = 100,
		slotName = "tower shield",
		amount = 1,
		name = "Steelclad Bulwark",
		progress = 350,
		description = "",
		clientId = 46244,
		tier = 4,
		category = "weapons",
		level = {
			single = 40,
			mass = 45
		},
		materials = {
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 12
			},
			{
				clientId = 28724,
				name = "steel ingot",
				itemId = 32156,
				amount = 3
			},
			{
				clientId = 46243,
				name = "Defender's Bulwark",
				itemId = 49696,
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
		itemId = 49698,
		experience = 39500,
		durability = 8,
		index = 94,
		profession = 4,
		quality = 100,
		slotName = "tower shield",
		amount = 1,
		name = "King's Defender",
		progress = 525,
		description = "",
		clientId = 46245,
		tier = 5,
		category = "weapons",
		level = {
			single = 55,
			mass = 60
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 20
			},
			{
				clientId = 28725,
				name = "cobalt ingot",
				itemId = 32157,
				amount = 5
			},
			{
				clientId = 46244,
				name = "Steelclad Bulwark",
				itemId = 49697,
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
		amount = 1,
		quality = 100,
		itemId = 49699,
		index = 95,
		slotName = "tower shield",
		name = "Protector's Tower Shield",
		progress = 700,
		profession = 4,
		clientId = 46246,
		durability = 12,
		experience = 57600,
		specialization = "Fletcher",
		description = "",
		tier = 6,
		category = "weapons",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 45503,
				name = "Fine Plank",
				itemId = 48955,
				amount = 22
			},
			{
				clientId = 28727,
				name = "titanium ingot",
				itemId = 32159,
				amount = 5
			},
			{
				clientId = 46245,
				name = "King's Defender",
				itemId = 49698,
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
		itemId = 50733,
		experience = 3300,
		durability = 6,
		index = 96,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Protective Charm",
		progress = 225,
		description = "Used for housing craft.",
		clientId = 47280,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 4
			},
			{
				clientId = 28966,
				name = "simple cloth",
				itemId = 32398,
				amount = 2
			},
			{
				clientId = 49613,
				name = "arcane reflector",
				itemId = 53066,
				amount = 3
			}
		}
	},
	{
		itemId = 50739,
		experience = 10000,
		durability = 8,
		index = 97,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Warding Charm",
		progress = 350,
		description = "Used for housing craft.",
		clientId = 47286,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 6
			},
			{
				clientId = 28973,
				name = "fine thread",
				itemId = 32405,
				amount = 6
			},
			{
				clientId = 49613,
				name = "arcane reflector",
				itemId = 53066,
				amount = 10
			}
		}
	},
	{
		itemId = 50735,
		experience = 16000,
		durability = 12,
		index = 98,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Spellbound Charm",
		progress = 600,
		description = "Used for housing craft.",
		clientId = 47282,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 45503,
				name = "Fine Plank",
				itemId = 48955,
				amount = 8
			},
			{
				clientId = 28969,
				name = "merchant's thread",
				itemId = 32401,
				amount = 4
			},
			{
				clientId = 49613,
				name = "arcane reflector",
				itemId = 53066,
				amount = 20
			}
		}
	},
	{
		itemId = 50730,
		experience = 3500,
		durability = 4,
		index = 99,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Basic Stabilizer",
		progress = 100,
		description = "Used for housing craft.",
		clientId = 47277,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28744,
				name = "rough plank",
				itemId = 32176,
				amount = 8
			},
			{
				clientId = 28966,
				name = "simple cloth",
				itemId = 32398,
				amount = 6
			},
			{
				clientId = 49613,
				name = "arcane reflector",
				itemId = 53066,
				amount = 3
			}
		}
	},
	{
		itemId = 50731,
		experience = 10000,
		durability = 6,
		index = 100,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Energy Stabilizer",
		progress = 250,
		description = "Used for housing craft.",
		clientId = 47278,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				clientId = 28745,
				name = "treated plank",
				itemId = 32177,
				amount = 8
			},
			{
				clientId = 28973,
				name = "fine thread",
				itemId = 32405,
				amount = 5
			},
			{
				clientId = 49613,
				name = "arcane reflector",
				itemId = 53066,
				amount = 10
			}
		}
	},
	{
		itemId = 50728,
		experience = 16000,
		durability = 12,
		index = 101,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Arcane Stabilizer",
		progress = 600,
		description = "Used for housing craft.",
		clientId = 47275,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 85
		},
		materials = {
			{
				clientId = 45503,
				name = "Fine Plank",
				itemId = 48955,
				amount = 8
			},
			{
				clientId = 28969,
				name = "merchant's thread",
				itemId = 32401,
				amount = 4
			},
			{
				clientId = 49613,
				name = "arcane reflector",
				itemId = 53066,
				amount = 20
			}
		}
	},
	{
		itemId = 50738,
		experience = 4000,
		durability = 5,
		index = 102,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Wall Reinforcement",
		progress = 200,
		description = "Used for housing craft.",
		clientId = 47285,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 28743,
				name = "refined plank",
				itemId = 32175,
				amount = 6
			},
			{
				clientId = 49616,
				name = "malleable screw",
				itemId = 53069,
				amount = 10
			},
			{
				clientId = 28737,
				name = "iron bar",
				itemId = 32169,
				amount = 6
			}
		}
	},
	{
		itemId = 50737,
		experience = 16000,
		durability = 8,
		index = 103,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Wall Fortification",
		progress = 500,
		description = "Used for housing craft.",
		clientId = 47284,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 45503,
				name = "Fine Plank",
				itemId = 48955,
				amount = 12
			},
			{
				clientId = 40283,
				name = "Common Plate",
				itemId = 43735,
				amount = 6
			}
		}
	},
	{
		itemId = 51977,
		experience = 3850,
		durability = 10,
		index = 104,
		profession = 4,
		quality = 610,
		slotName = "",
		amount = 1,
		name = "glimmery plank",
		progress = 610,
		description = "Used in various recipes. There is a coat of light on the surface of the plank.",
		clientId = 48524,
		tier = -1,
		category = "planks",
		level = {
			single = 88,
			mass = 93
		},
		materials = {
			{
				clientId = 45503,
				name = "Fine Plank",
				itemId = 48955,
				amount = 3
			},
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 3
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
		itemId = 51991,
		index = 105,
		slotName = "bow",
		name = "Arclight Bow",
		progress = 870,
		profession = 4,
		clientId = 48538,
		durability = 15,
		experience = 154000,
		specialization = "Fletcher",
		description = "",
		tier = 7,
		category = "weapons",
		level = {
			single = 90,
			mass = 95
		},
		materials = {
			{
				clientId = 48524,
				name = "glimmery plank",
				itemId = 51977,
				amount = 28
			},
			{
				clientId = 48525,
				name = "glimmery thread",
				itemId = 51978,
				amount = 12
			},
			{
				clientId = 37155,
				name = "Marksman Bow",
				itemId = 40607,
				amount = 1
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 51992,
		index = 106,
		slotName = "staff",
		name = "Cosmic Staff",
		progress = 870,
		profession = 4,
		clientId = 48539,
		durability = 15,
		experience = 154000,
		specialization = "Fletcher",
		description = "",
		tier = 7,
		category = "weapons",
		level = {
			single = 90,
			mass = 95
		},
		materials = {
			{
				clientId = 48524,
				name = "glimmery plank",
				itemId = 51977,
				amount = 28
			},
			{
				clientId = 48522,
				name = "glimmery ingot",
				itemId = 51975,
				amount = 12
			},
			{
				clientId = 37150,
				name = "Necromancer's Staff",
				itemId = 40602,
				amount = 1
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 51996,
		index = 107,
		slotName = "sceptre",
		name = "Lunar Sceptre",
		progress = 870,
		profession = 4,
		clientId = 48543,
		durability = 15,
		experience = 77000,
		specialization = "Fletcher",
		description = "",
		tier = 7,
		category = "weapons",
		level = {
			single = 90,
			mass = 95
		},
		materials = {
			{
				clientId = 48524,
				name = "glimmery plank",
				itemId = 51977,
				amount = 14
			},
			{
				clientId = 48522,
				name = "glimmery ingot",
				itemId = 51975,
				amount = 6
			},
			{
				clientId = 37157,
				name = "Crowbone Sceptre",
				itemId = 40609,
				amount = 1
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 52001,
		index = 108,
		slotName = "buckler shield",
		name = "Void Buckler",
		progress = 870,
		profession = 4,
		clientId = 48548,
		durability = 15,
		experience = 77000,
		specialization = "Fletcher",
		description = "",
		tier = 7,
		category = "weapons",
		level = {
			single = 90,
			mass = 95
		},
		materials = {
			{
				clientId = 48524,
				name = "glimmery plank",
				itemId = 51977,
				amount = 14
			},
			{
				clientId = 48523,
				name = "glimmery leather",
				itemId = 51976,
				amount = 6
			},
			{
				clientId = 37149,
				name = "Nocturnal Shield",
				itemId = 40601,
				amount = 1
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		itemId = 51994,
		index = 109,
		slotName = "tower shield",
		name = "Imperial Bulwark",
		progress = 870,
		profession = 4,
		clientId = 48541,
		durability = 15,
		experience = 77000,
		specialization = "Fletcher",
		description = "",
		tier = 7,
		category = "weapons",
		level = {
			single = 90,
			mass = 95
		},
		materials = {
			{
				clientId = 48524,
				name = "glimmery plank",
				itemId = 51977,
				amount = 14
			},
			{
				clientId = 48522,
				name = "glimmery ingot",
				itemId = 51975,
				amount = 6
			},
			{
				clientId = 46246,
				name = "Protector's Tower Shield",
				itemId = 49699,
				amount = 1
			}
		}
	},
	{
		itemId = 53253,
		experience = 19500,
		durability = 5,
		index = 110,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Herb Mixing Table",
		progress = 200,
		description = "Used in housing upgrades. A set of basic materials to assist alchemy enthusiasts.",
		clientId = 49800,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 41847,
				name = "Dense Plank",
				itemId = 45299,
				amount = 6
			},
			{
				clientId = 47277,
				name = "Basic Stabilizer",
				itemId = 50730,
				amount = 1
			},
			{
				clientId = 49799,
				name = "Gemstone Dust",
				itemId = 53252,
				amount = 1
			}
		}
	},
	{
		itemId = 53266,
		experience = 64000,
		durability = 8,
		index = 111,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Preparation Table",
		progress = 425,
		description = "Used in housing upgrades. A set of intricate materials to assist alchemy enthusiasts.",
		clientId = 49813,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 41847,
				name = "Dense Plank",
				itemId = 45299,
				amount = 12
			},
			{
				clientId = 47278,
				name = "Energy Stabilizer",
				itemId = 50731,
				amount = 2
			},
			{
				clientId = 49799,
				name = "Gemstone Dust",
				itemId = 53252,
				amount = 5
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		itemId = 53245,
		index = 112,
		slotName = "",
		name = "Alchemist's Table",
		progress = 700,
		profession = 4,
		clientId = 49792,
		durability = 12,
		experience = 154000,
		specialization = "Joiner",
		description = "Used in housing upgrades. A prime set of materials for master alchemists.",
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 41847,
				name = "Dense Plank",
				itemId = 45299,
				amount = 25
			},
			{
				clientId = 47275,
				name = "Arcane Stabilizer",
				itemId = 50728,
				amount = 4
			},
			{
				clientId = 49799,
				name = "Gemstone Dust",
				itemId = 53252,
				amount = 10
			}
		}
	},
	{
		itemId = 53268,
		experience = 10000,
		durability = 5,
		index = 113,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Supply Locker",
		progress = 200,
		description = "Used in housing upgrades. A spacious container designed to securely store and organize all your essential materials and tools.",
		clientId = 49815,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 41847,
				name = "Dense Plank",
				itemId = 45299,
				amount = 3
			},
			{
				clientId = 28734,
				name = "nail",
				itemId = 32166,
				amount = 10
			},
			{
				clientId = 28737,
				name = "iron bar",
				itemId = 32169,
				amount = 3
			}
		}
	},
	{
		itemId = 53265,
		experience = 48000,
		durability = 8,
		index = 114,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Reinforced Locker",
		progress = 500,
		description = "Used in housing upgrades. A durable and secure container built to withstand heavy use, perfect for storing and protecting your valuable materials and tools.",
		clientId = 49812,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 41847,
				name = "Dense Plank",
				itemId = 45299,
				amount = 19
			},
			{
				clientId = 49616,
				name = "malleable screw",
				itemId = 53069,
				amount = 15
			},
			{
				clientId = 40284,
				name = "Steel Bar",
				itemId = 43736,
				amount = 10
			}
		}
	},
	{
		itemId = 53258,
		experience = 22500,
		durability = 6,
		index = 115,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Mystic Reinforcement",
		progress = 250,
		description = "Used in housing upgrades. Modestly enhances the magical protection of a room to allow arcane research.",
		clientId = 49805,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				clientId = 47280,
				name = "Protective Charm",
				itemId = 50733,
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
		itemId = 53261,
		experience = 52000,
		durability = 8,
		index = 116,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Mystic Barrier",
		progress = 425,
		description = "Used in housing upgrades. Enhances the magical protection of a room to allow arcane research.",
		clientId = 49808,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 47286,
				name = "Warding Charm",
				itemId = 50739,
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
		itemId = 53259,
		index = 117,
		slotName = "",
		name = "Mystic Fortification",
		progress = 700,
		profession = 4,
		clientId = 49806,
		durability = 12,
		experience = 96000,
		specialization = "Joiner",
		description = "Used in housing upgrades. Greatly enhances the magical protection of a room to allow arcane research.",
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 47282,
				name = "Spellbound Charm",
				itemId = 50735,
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
		itemId = 53260,
		experience = 36000,
		durability = 8,
		index = 118,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Mystic Tools",
		progress = 525,
		description = "Used in housing upgrades. Tools used by enchanters in their rituals.",
		clientId = 49807,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 45506,
				name = "Sturdy Plank",
				itemId = 48958,
				amount = 12
			},
			{
				clientId = 41847,
				name = "Dense Plank",
				itemId = 45299,
				amount = 3
			},
			{
				clientId = 49799,
				name = "Gemstone Dust",
				itemId = 53252,
				amount = 3
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		itemId = 53247,
		index = 119,
		slotName = "",
		name = "Arcanist Tools",
		progress = 700,
		profession = 4,
		clientId = 49794,
		durability = 12,
		experience = 91200,
		specialization = "Joiner",
		description = "Used in housing upgrades. Tools used to deepen the understanding of the arcane.",
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 45503,
				name = "Fine Plank",
				itemId = 48955,
				amount = 16
			},
			{
				clientId = 41847,
				name = "Dense Plank",
				itemId = 45299,
				amount = 4
			},
			{
				clientId = 49799,
				name = "Gemstone Dust",
				itemId = 53252,
				amount = 12
			}
		}
	},
	{
		itemId = 53254,
		experience = 15000,
		durability = 5,
		index = 120,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Magical Accoutrements",
		progress = 200,
		description = "Used in housing upgrades. An assortment of trinkets and tokens used in the pursuit of arcane knowledge.",
		clientId = 49801,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 47277,
				name = "Basic Stabilizer",
				itemId = 50730,
				amount = 3
			},
			{
				clientId = 47288,
				name = "Weak Racks",
				itemId = 50741,
				amount = 1
			}
		}
	},
	{
		itemId = 53267,
		experience = 43500,
		durability = 8,
		index = 121,
		profession = 4,
		quality = 0,
		slotName = "",
		amount = 1,
		name = "Spellcaster's Accoutrements",
		progress = 500,
		description = "Used in housing upgrades. A series of enigmatic sigils and symbols, each imbued with arcane power discernible only to the trained eye.",
		clientId = 49814,
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 47278,
				name = "Energy Stabilizer",
				itemId = 50731,
				amount = 3
			},
			{
				clientId = 47276,
				name = "Armory Racks",
				itemId = 50729,
				amount = 1
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		itemId = 53246,
		index = 122,
		slotName = "",
		name = "Arcane Accoutrements",
		progress = 700,
		profession = 4,
		clientId = 49793,
		durability = 12,
		experience = 85000,
		specialization = "Joiner",
		description = "Used in housing upgrades. Accoutrements of advanced complexity can be found here, only a master of the arcane would know how to wield them.",
		tier = -1,
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 47275,
				name = "Arcane Stabilizer",
				itemId = 50728,
				amount = 3
			},
			{
				clientId = 47281,
				name = "Reinforced Racks",
				itemId = 50734,
				amount = 1
			}
		}
	}
}
questRecipes = questRecipes or {}
questRecipes[ProfessionCarpentry] = {
	{
		itemId = 32430,
		experience = 0,
		durability = 3,
		index = 1,
		profession = 4,
		quality = 50,
		slotName = "bow",
		amount = 1,
		name = "Oakwood Bow",
		progress = 50,
		description = "",
		clientId = 28998,
		tier = 1,
		category = "quest",
		level = {
			single = 1
		},
		materials = {
			{
				clientId = 28744,
				name = "Rough Plank",
				itemId = 38876,
				amount = 5
			},
			{
				clientId = 28971,
				name = "Coarse Thread",
				itemId = 38877,
				amount = 3
			}
		}
	},
	{
		itemId = 32482,
		experience = 0,
		durability = 3,
		index = 2,
		profession = 4,
		quality = 50,
		slotName = "staff",
		amount = 1,
		name = "Mystic Staff",
		progress = 50,
		description = "",
		clientId = 29050,
		tier = 1,
		category = "quest",
		level = {
			single = 1
		},
		materials = {
			{
				clientId = 28744,
				name = "Rough Plank",
				itemId = 38876,
				amount = 9
			}
		}
	},
	{
		itemId = 37422,
		experience = 0,
		durability = 3,
		index = 3,
		profession = 4,
		quality = 50,
		slotName = "sceptre",
		amount = 1,
		name = "Knotted Sceptre",
		progress = 50,
		description = "",
		clientId = 33990,
		tier = 1,
		category = "quest",
		level = {
			single = 1
		},
		materials = {
			{
				clientId = 28744,
				name = "Rough Plank",
				itemId = 38876,
				amount = 5
			}
		}
	},
	{
		itemId = 32460,
		experience = 0,
		durability = 3,
		index = 4,
		profession = 4,
		quality = 50,
		slotName = "buckler shield",
		amount = 1,
		name = "Wooden Buckler",
		progress = 50,
		description = "",
		clientId = 29028,
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
	}
}
