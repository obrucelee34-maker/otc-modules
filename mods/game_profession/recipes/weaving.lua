-- chunkname: @/modules/game_profession/recipes/weaving.lua

recipes = recipes or {}
recipes[ProfessionWeaving] = {
	{
		amount = 1,
		quality = 75,
		progress = 25,
		profession = 7,
		name = "Coarse Leather",
		description = "Used in various recipes. Its rough texture provides a sense of rugged resilience.",
		itemId = 38864,
		index = 1,
		experience = 610,
		durability = 4,
		tier = -1,
		clientId = 35432,
		slotName = "",
		category = "leather",
		level = {
			single = 1,
			mass = 6
		},
		materials = {
			{
				amount = 3,
				clientId = 35353,
				itemId = 38785,
				name = "Hide"
			}
		}
	},
	{
		amount = 1,
		quality = 150,
		progress = 150,
		profession = 7,
		name = "Craftman's Leather",
		description = "Used in various recipes. Skillfully treated and refined leather.",
		itemId = 38865,
		index = 2,
		experience = 1200,
		durability = 6,
		tier = -1,
		clientId = 35433,
		slotName = "",
		category = "leather",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				amount = 5,
				clientId = 35353,
				itemId = 38785,
				name = "Hide"
			}
		}
	},
	{
		amount = 1,
		quality = 200,
		progress = 225,
		profession = 7,
		name = "Tanned Leather",
		description = "Used in various recipes. Smooth and flexible, it's a display of a meticulous tanning process.",
		itemId = 38866,
		index = 3,
		experience = 1850,
		durability = 7,
		tier = -1,
		clientId = 35434,
		slotName = "",
		category = "leather",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				amount = 8,
				clientId = 35353,
				itemId = 38785,
				name = "Hide"
			}
		}
	},
	{
		amount = 1,
		quality = 425,
		progress = 450,
		profession = 7,
		name = "Merchant's Leather",
		description = "Used in various recipes. Its polished appearance signifies quality and sophistication.",
		itemId = 38867,
		index = 4,
		experience = 2400,
		durability = 8,
		tier = -1,
		clientId = 35435,
		slotName = "",
		category = "leather",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				amount = 10,
				clientId = 35353,
				itemId = 38785,
				name = "Hide"
			}
		}
	},
	{
		amount = 1,
		quality = 525,
		progress = 550,
		profession = 7,
		name = "Artisan Leather",
		description = "Used in various recipes. Masterfully crafted, it's reserved only for the finest creations.",
		itemId = 38868,
		index = 5,
		experience = 3050,
		durability = 9,
		tier = -1,
		clientId = 35436,
		slotName = "",
		category = "leather",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				amount = 13,
				clientId = 35353,
				itemId = 38785,
				name = "Hide"
			}
		}
	},
	{
		amount = 1,
		quality = 75,
		progress = 25,
		profession = 7,
		name = "coarse thread",
		description = "Used in various recipes. Despite its unrefined appearance, it's suitable for crafting durable items.",
		itemId = 32403,
		index = 6,
		experience = 610,
		durability = 4,
		tier = -1,
		clientId = 28971,
		slotName = "",
		category = "threads",
		level = {
			single = 1,
			mass = 6
		},
		materials = {
			{
				amount = 4,
				clientId = 28879,
				itemId = 32311,
				name = "cotton"
			}
		}
	},
	{
		amount = 1,
		quality = 150,
		progress = 150,
		profession = 7,
		name = "craftman's thread",
		description = "Used in various recipes. Stitching together sturdy creations, it stands up to the rigors of daily use.",
		itemId = 32404,
		index = 7,
		experience = 1200,
		durability = 6,
		tier = -1,
		clientId = 28972,
		slotName = "",
		category = "threads",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				amount = 8,
				clientId = 28879,
				itemId = 32311,
				name = "cotton"
			}
		}
	},
	{
		amount = 1,
		quality = 200,
		progress = 225,
		profession = 7,
		name = "fine thread",
		description = "Used in various recipes. Delicate and refined, its slender fibers allow for intricate stitching.",
		itemId = 32405,
		index = 8,
		experience = 1850,
		durability = 7,
		tier = -1,
		clientId = 28973,
		slotName = "",
		category = "threads",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				amount = 12,
				clientId = 28879,
				itemId = 32311,
				name = "cotton"
			}
		}
	},
	{
		amount = 1,
		quality = 425,
		progress = 450,
		profession = 7,
		name = "merchant's thread",
		description = "Used in various recipes. The lifeline of intricate textiles.",
		itemId = 32401,
		index = 9,
		experience = 2400,
		durability = 8,
		tier = -1,
		clientId = 28969,
		slotName = "",
		category = "threads",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				amount = 16,
				clientId = 28879,
				itemId = 32311,
				name = "cotton"
			}
		}
	},
	{
		amount = 1,
		quality = 525,
		progress = 550,
		profession = 7,
		name = "artisan thread",
		description = "Used in various recipes. The foundation for textiles that transcend to become works of art.",
		itemId = 32402,
		index = 10,
		experience = 3050,
		durability = 9,
		tier = -1,
		clientId = 28970,
		slotName = "",
		category = "threads",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				amount = 20,
				clientId = 28879,
				itemId = 32311,
				name = "cotton"
			}
		}
	},
	{
		amount = 1,
		quality = 75,
		progress = 25,
		profession = 7,
		name = "simple cloth",
		description = "Used in various recipes. Unassuming yet versatile, serves as the material for everyday textiles.",
		itemId = 32398,
		index = 11,
		experience = 610,
		durability = 4,
		tier = -1,
		clientId = 28966,
		slotName = "",
		category = "cloth",
		level = {
			single = 1,
			mass = 6
		},
		materials = {
			{
				amount = 4,
				clientId = 28425,
				itemId = 31857,
				name = "wool"
			}
		}
	},
	{
		amount = 1,
		quality = 150,
		progress = 150,
		profession = 7,
		name = "craftman's cloth",
		description = "Used in various recipes. Sturdy and reliable, a material for those who value utility in their creations.",
		itemId = 32395,
		index = 12,
		experience = 1200,
		durability = 6,
		tier = -1,
		clientId = 28963,
		slotName = "",
		category = "cloth",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				amount = 8,
				clientId = 28425,
				itemId = 31857,
				name = "wool"
			}
		}
	},
	{
		amount = 1,
		quality = 175,
		progress = 225,
		profession = 7,
		name = "silk",
		description = "Used in various recipes. Luxurious and smooth, Silk is the epitome of opulence in the textile world.",
		itemId = 32397,
		index = 13,
		experience = 1850,
		durability = 7,
		tier = -1,
		clientId = 28965,
		slotName = "",
		category = "cloth",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				amount = 12,
				clientId = 28425,
				itemId = 31857,
				name = "wool"
			}
		}
	},
	{
		amount = 1,
		quality = 425,
		progress = 450,
		profession = 7,
		name = "merchant's cloth",
		description = "Used in various recipes. Its subtle sheen and tasteful patterns carry an air of sophistication.",
		itemId = 32396,
		index = 14,
		experience = 2400,
		durability = 8,
		tier = -1,
		clientId = 28964,
		slotName = "",
		category = "cloth",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				amount = 16,
				clientId = 28425,
				itemId = 31857,
				name = "wool"
			}
		}
	},
	{
		amount = 1,
		quality = 525,
		progress = 550,
		profession = 7,
		name = "artisan cloth",
		description = "Used in various recipes. Its luxurious texture makes it perfect for creating fine garments.",
		itemId = 32394,
		index = 15,
		experience = 3050,
		durability = 9,
		tier = -1,
		clientId = 28962,
		slotName = "",
		category = "cloth",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				amount = 20,
				clientId = 28425,
				itemId = 31857,
				name = "wool"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 100,
		profession = 7,
		name = "Viper's Armor",
		description = "",
		itemId = 32030,
		index = 16,
		experience = 1280,
		durability = 4,
		tier = 2,
		clientId = 28598,
		slotName = "cloth armor",
		category = "armors",
		level = {
			single = 13,
			mass = 18
		},
		materials = {
			{
				amount = 1,
				clientId = 28966,
				itemId = 32398,
				name = "simple cloth"
			},
			{
				amount = 1,
				clientId = 28971,
				itemId = 32403,
				name = "coarse thread"
			},
			{
				amount = 1,
				clientId = 28589,
				itemId = 32021,
				name = "Shadecloth Armor"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 100,
		profession = 7,
		name = "Viper's Helmet",
		description = "",
		itemId = 32036,
		index = 17,
		experience = 1280,
		durability = 4,
		tier = 2,
		clientId = 28604,
		slotName = "cloth helmet",
		category = "armors",
		level = {
			single = 16,
			mass = 21
		},
		materials = {
			{
				amount = 1,
				clientId = 28966,
				itemId = 32398,
				name = "simple cloth"
			},
			{
				amount = 1,
				clientId = 28971,
				itemId = 32403,
				name = "coarse thread"
			},
			{
				amount = 1,
				clientId = 28595,
				itemId = 32027,
				name = "Shadecloth Helmet"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 100,
		profession = 7,
		name = "Viper's Legs",
		description = "",
		itemId = 32037,
		index = 18,
		experience = 1280,
		durability = 4,
		tier = 2,
		clientId = 28605,
		slotName = "cloth legs",
		category = "armors",
		level = {
			single = 19,
			mass = 24
		},
		materials = {
			{
				amount = 1,
				clientId = 28966,
				itemId = 32398,
				name = "simple cloth"
			},
			{
				amount = 1,
				clientId = 28971,
				itemId = 32403,
				name = "coarse thread"
			},
			{
				amount = 1,
				clientId = 28596,
				itemId = 32028,
				name = "Shadecloth Legs"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 100,
		profession = 7,
		name = "Viper's Boots",
		description = "",
		itemId = 32033,
		index = 19,
		experience = 1280,
		durability = 4,
		tier = 2,
		clientId = 28601,
		slotName = "cloth boots",
		category = "armors",
		level = {
			single = 22,
			mass = 27
		},
		materials = {
			{
				amount = 1,
				clientId = 28966,
				itemId = 32398,
				name = "simple cloth"
			},
			{
				amount = 1,
				clientId = 28971,
				itemId = 32403,
				name = "coarse thread"
			},
			{
				amount = 1,
				clientId = 28592,
				itemId = 32024,
				name = "Shadecloth Boots"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 225,
		profession = 7,
		name = "Profane Armor",
		description = "",
		itemId = 32039,
		index = 20,
		experience = 6000,
		durability = 7,
		tier = 3,
		clientId = 28607,
		slotName = "cloth armor",
		category = "armors",
		level = {
			single = 28,
			mass = 33
		},
		materials = {
			{
				amount = 3,
				clientId = 28963,
				itemId = 32395,
				name = "craftman's cloth"
			},
			{
				amount = 2,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			},
			{
				amount = 1,
				clientId = 28598,
				itemId = 32030,
				name = "Viper's Armor"
			},
			{
				amount = 3,
				clientId = 37479,
				itemId = 40931,
				name = "Shell Fragment"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 225,
		profession = 7,
		name = "Profane Helmet",
		description = "",
		itemId = 32045,
		index = 21,
		experience = 6000,
		durability = 7,
		tier = 3,
		clientId = 28613,
		slotName = "cloth helmet",
		category = "armors",
		level = {
			single = 31,
			mass = 36
		},
		materials = {
			{
				amount = 3,
				clientId = 28963,
				itemId = 32395,
				name = "craftman's cloth"
			},
			{
				amount = 2,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			},
			{
				amount = 1,
				clientId = 28604,
				itemId = 32036,
				name = "Viper's Helmet"
			},
			{
				amount = 3,
				clientId = 37479,
				itemId = 40931,
				name = "Shell Fragment"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 225,
		profession = 7,
		name = "Profane Legs",
		description = "",
		itemId = 32046,
		index = 22,
		experience = 6000,
		durability = 7,
		tier = 3,
		clientId = 28614,
		slotName = "cloth legs",
		category = "armors",
		level = {
			single = 34,
			mass = 39
		},
		materials = {
			{
				amount = 2,
				clientId = 28963,
				itemId = 32395,
				name = "craftman's cloth"
			},
			{
				amount = 3,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			},
			{
				amount = 1,
				clientId = 28605,
				itemId = 32037,
				name = "Viper's Legs"
			},
			{
				amount = 3,
				clientId = 37479,
				itemId = 40931,
				name = "Shell Fragment"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 225,
		profession = 7,
		name = "Profane Boots",
		description = "",
		itemId = 32042,
		index = 23,
		experience = 6000,
		durability = 7,
		tier = 3,
		clientId = 28610,
		slotName = "cloth boots",
		category = "armors",
		level = {
			single = 37,
			mass = 42
		},
		materials = {
			{
				amount = 2,
				clientId = 28963,
				itemId = 32395,
				name = "craftman's cloth"
			},
			{
				amount = 3,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			},
			{
				amount = 1,
				clientId = 28601,
				itemId = 32033,
				name = "Viper's Boots"
			},
			{
				amount = 3,
				clientId = 37479,
				itemId = 40931,
				name = "Shell Fragment"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 350,
		profession = 7,
		name = "Celestial Armor",
		description = "",
		itemId = 32048,
		index = 24,
		experience = 11000,
		durability = 7,
		tier = 4,
		clientId = 28616,
		slotName = "cloth armor",
		category = "armors",
		level = {
			single = 43,
			mass = 48
		},
		materials = {
			{
				amount = 3,
				clientId = 28965,
				itemId = 32397,
				name = "silk"
			},
			{
				amount = 3,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 28607,
				itemId = 32039,
				name = "Profane Armor"
			},
			{
				amount = 4,
				clientId = 37495,
				itemId = 40947,
				name = "Phantasmagorical Cloth"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 350,
		profession = 7,
		name = "Celestial Helmet",
		description = "",
		itemId = 32054,
		index = 25,
		experience = 11000,
		durability = 7,
		tier = 4,
		clientId = 28622,
		slotName = "cloth helmet",
		category = "armors",
		level = {
			single = 46,
			mass = 51
		},
		materials = {
			{
				amount = 3,
				clientId = 28965,
				itemId = 32397,
				name = "silk"
			},
			{
				amount = 3,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 28613,
				itemId = 32045,
				name = "Profane Helmet"
			},
			{
				amount = 4,
				clientId = 37495,
				itemId = 40947,
				name = "Phantasmagorical Cloth"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 350,
		profession = 7,
		name = "Celestial Legs",
		description = "",
		itemId = 32055,
		index = 26,
		experience = 11000,
		durability = 7,
		tier = 4,
		clientId = 28623,
		slotName = "cloth legs",
		category = "armors",
		level = {
			single = 49,
			mass = 54
		},
		materials = {
			{
				amount = 3,
				clientId = 28965,
				itemId = 32397,
				name = "silk"
			},
			{
				amount = 3,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 28614,
				itemId = 32046,
				name = "Profane Legs"
			},
			{
				amount = 4,
				clientId = 37495,
				itemId = 40947,
				name = "Phantasmagorical Cloth"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 350,
		profession = 7,
		name = "Celestial Boots",
		description = "",
		itemId = 32051,
		index = 27,
		experience = 11000,
		durability = 7,
		tier = 4,
		clientId = 28619,
		slotName = "cloth boots",
		category = "armors",
		level = {
			single = 52,
			mass = 57
		},
		materials = {
			{
				amount = 3,
				clientId = 28965,
				itemId = 32397,
				name = "silk"
			},
			{
				amount = 3,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 28610,
				itemId = 32042,
				name = "Profane Boots"
			},
			{
				amount = 4,
				clientId = 37495,
				itemId = 40947,
				name = "Phantasmagorical Cloth"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 525,
		profession = 7,
		name = "Mystic Armor",
		description = "",
		itemId = 32064,
		index = 28,
		experience = 24000,
		durability = 9,
		tier = 5,
		clientId = 28632,
		slotName = "cloth armor",
		category = "armors",
		level = {
			single = 58,
			mass = 63
		},
		materials = {
			{
				amount = 7,
				clientId = 28964,
				itemId = 32396,
				name = "merchant's cloth"
			},
			{
				amount = 3,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 28616,
				itemId = 32048,
				name = "Celestial Armor"
			},
			{
				amount = 5,
				clientId = 40271,
				itemId = 43723,
				name = "Greenweave Bolt"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 525,
		profession = 7,
		name = "Mystic Helmet",
		description = "",
		itemId = 32065,
		index = 29,
		experience = 24000,
		durability = 9,
		tier = 5,
		clientId = 28633,
		slotName = "cloth helmet",
		category = "armors",
		level = {
			single = 61,
			mass = 66
		},
		materials = {
			{
				amount = 7,
				clientId = 28964,
				itemId = 32396,
				name = "merchant's cloth"
			},
			{
				amount = 3,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 28622,
				itemId = 32054,
				name = "Celestial Helmet"
			},
			{
				amount = 5,
				clientId = 40271,
				itemId = 43723,
				name = "Greenweave Bolt"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 525,
		profession = 7,
		name = "Mystic Legs",
		description = "",
		itemId = 32063,
		index = 30,
		experience = 24000,
		durability = 9,
		tier = 5,
		clientId = 28631,
		slotName = "cloth legs",
		category = "armors",
		level = {
			single = 64,
			mass = 69
		},
		materials = {
			{
				amount = 3,
				clientId = 28964,
				itemId = 32396,
				name = "merchant's cloth"
			},
			{
				amount = 7,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 28623,
				itemId = 32055,
				name = "Celestial Legs"
			},
			{
				amount = 5,
				clientId = 40271,
				itemId = 43723,
				name = "Greenweave Bolt"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 525,
		profession = 7,
		name = "Mystic Boots",
		description = "",
		itemId = 32057,
		index = 31,
		experience = 24000,
		durability = 9,
		tier = 5,
		clientId = 28625,
		slotName = "cloth boots",
		category = "armors",
		level = {
			single = 67,
			mass = 72
		},
		materials = {
			{
				amount = 3,
				clientId = 28964,
				itemId = 32396,
				name = "merchant's cloth"
			},
			{
				amount = 7,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 28619,
				itemId = 32051,
				name = "Celestial Boots"
			},
			{
				amount = 5,
				clientId = 40271,
				itemId = 43723,
				name = "Greenweave Bolt"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 100,
		profession = 7,
		name = "Nomad Armor",
		description = "",
		itemId = 32075,
		index = 32,
		experience = 1280,
		durability = 4,
		tier = 2,
		clientId = 28643,
		slotName = "leather armor",
		category = "armors",
		level = {
			single = 13,
			mass = 18
		},
		materials = {
			{
				amount = 1,
				clientId = 35432,
				itemId = 38864,
				name = "Coarse Leather"
			},
			{
				amount = 1,
				clientId = 28971,
				itemId = 32403,
				name = "coarse thread"
			},
			{
				amount = 1,
				clientId = 28634,
				itemId = 32066,
				name = "Hide Armor"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 100,
		profession = 7,
		name = "Nomad Helmet",
		description = "",
		itemId = 32081,
		index = 33,
		experience = 1280,
		durability = 4,
		tier = 2,
		clientId = 28649,
		slotName = "leather helmet",
		category = "armors",
		level = {
			single = 16,
			mass = 21
		},
		materials = {
			{
				amount = 1,
				clientId = 35432,
				itemId = 38864,
				name = "Coarse Leather"
			},
			{
				amount = 1,
				clientId = 28971,
				itemId = 32403,
				name = "coarse thread"
			},
			{
				amount = 1,
				clientId = 28640,
				itemId = 32072,
				name = "Hide Helmet"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 100,
		profession = 7,
		name = "Nomad Legs",
		description = "",
		itemId = 32082,
		index = 34,
		experience = 1280,
		durability = 4,
		tier = 2,
		clientId = 28650,
		slotName = "leather legs",
		category = "armors",
		level = {
			single = 19,
			mass = 24
		},
		materials = {
			{
				amount = 1,
				clientId = 35432,
				itemId = 38864,
				name = "Coarse Leather"
			},
			{
				amount = 1,
				clientId = 28971,
				itemId = 32403,
				name = "coarse thread"
			},
			{
				amount = 1,
				clientId = 28641,
				itemId = 32073,
				name = "Hide Legs"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 100,
		profession = 7,
		name = "Nomad Boots",
		description = "",
		itemId = 32078,
		index = 35,
		experience = 1280,
		durability = 4,
		tier = 2,
		clientId = 28646,
		slotName = "leather boots",
		category = "armors",
		level = {
			single = 22,
			mass = 27
		},
		materials = {
			{
				amount = 1,
				clientId = 35432,
				itemId = 38864,
				name = "Coarse Leather"
			},
			{
				amount = 1,
				clientId = 28971,
				itemId = 32403,
				name = "coarse thread"
			},
			{
				amount = 1,
				clientId = 28637,
				itemId = 32069,
				name = "Hide Boots"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 225,
		profession = 7,
		name = "Bruiser's Armor",
		description = "",
		itemId = 32084,
		index = 36,
		experience = 6000,
		durability = 7,
		tier = 3,
		clientId = 28652,
		slotName = "leather armor",
		category = "armors",
		level = {
			single = 28,
			mass = 33
		},
		materials = {
			{
				amount = 3,
				clientId = 35433,
				itemId = 38865,
				name = "Craftman's Leather"
			},
			{
				amount = 2,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			},
			{
				amount = 1,
				clientId = 28643,
				itemId = 32075,
				name = "Nomad Armor"
			},
			{
				amount = 3,
				clientId = 37479,
				itemId = 40931,
				name = "Shell Fragment"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 225,
		profession = 7,
		name = "Bruiser's Helmet",
		description = "",
		itemId = 32090,
		index = 37,
		experience = 6000,
		durability = 7,
		tier = 3,
		clientId = 28658,
		slotName = "leather helmet",
		category = "armors",
		level = {
			single = 31,
			mass = 36
		},
		materials = {
			{
				amount = 3,
				clientId = 35433,
				itemId = 38865,
				name = "Craftman's Leather"
			},
			{
				amount = 2,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			},
			{
				amount = 1,
				clientId = 28649,
				itemId = 32081,
				name = "Nomad Helmet"
			},
			{
				amount = 3,
				clientId = 37479,
				itemId = 40931,
				name = "Shell Fragment"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 225,
		profession = 7,
		name = "Bruiser's Legs",
		description = "",
		itemId = 32091,
		index = 38,
		experience = 6000,
		durability = 7,
		tier = 3,
		clientId = 28659,
		slotName = "leather legs",
		category = "armors",
		level = {
			single = 34,
			mass = 39
		},
		materials = {
			{
				amount = 2,
				clientId = 35433,
				itemId = 38865,
				name = "Craftman's Leather"
			},
			{
				amount = 3,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			},
			{
				amount = 1,
				clientId = 28650,
				itemId = 32082,
				name = "Nomad Legs"
			},
			{
				amount = 3,
				clientId = 37479,
				itemId = 40931,
				name = "Shell Fragment"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 225,
		profession = 7,
		name = "Bruiser's Boots",
		description = "",
		itemId = 32087,
		index = 39,
		experience = 6000,
		durability = 7,
		tier = 3,
		clientId = 28655,
		slotName = "leather boots",
		category = "armors",
		level = {
			single = 37,
			mass = 42
		},
		materials = {
			{
				amount = 2,
				clientId = 35433,
				itemId = 38865,
				name = "Craftman's Leather"
			},
			{
				amount = 3,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			},
			{
				amount = 1,
				clientId = 28646,
				itemId = 32078,
				name = "Nomad Boots"
			},
			{
				amount = 3,
				clientId = 37479,
				itemId = 40931,
				name = "Shell Fragment"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 350,
		profession = 7,
		name = "Outlaw Armor",
		description = "",
		itemId = 32093,
		index = 40,
		experience = 11000,
		durability = 7,
		tier = 4,
		clientId = 28661,
		slotName = "leather armor",
		category = "armors",
		level = {
			single = 43,
			mass = 48
		},
		materials = {
			{
				amount = 3,
				clientId = 35434,
				itemId = 38866,
				name = "Tanned Leather"
			},
			{
				amount = 3,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 28652,
				itemId = 32084,
				name = "Bruiser's Armor"
			},
			{
				amount = 4,
				clientId = 37624,
				itemId = 41076,
				name = "Flexible Scale"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 350,
		profession = 7,
		name = "Outlaw Helmet",
		description = "",
		itemId = 32099,
		index = 41,
		experience = 11000,
		durability = 7,
		tier = 4,
		clientId = 28667,
		slotName = "leather helmet",
		category = "armors",
		level = {
			single = 46,
			mass = 51
		},
		materials = {
			{
				amount = 3,
				clientId = 35434,
				itemId = 38866,
				name = "Tanned Leather"
			},
			{
				amount = 3,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 28658,
				itemId = 32090,
				name = "Bruiser's Helmet"
			},
			{
				amount = 4,
				clientId = 37624,
				itemId = 41076,
				name = "Flexible Scale"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 350,
		profession = 7,
		name = "Outlaw Legs",
		description = "",
		itemId = 32100,
		index = 42,
		experience = 11000,
		durability = 7,
		tier = 4,
		clientId = 28668,
		slotName = "leather legs",
		category = "armors",
		level = {
			single = 49,
			mass = 54
		},
		materials = {
			{
				amount = 3,
				clientId = 35434,
				itemId = 38866,
				name = "Tanned Leather"
			},
			{
				amount = 3,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 28659,
				itemId = 32091,
				name = "Bruiser's Legs"
			},
			{
				amount = 4,
				clientId = 37624,
				itemId = 41076,
				name = "Flexible Scale"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 350,
		profession = 7,
		name = "Outlaw Boots",
		description = "",
		itemId = 32096,
		index = 43,
		experience = 11000,
		durability = 7,
		tier = 4,
		clientId = 28664,
		slotName = "leather boots",
		category = "armors",
		level = {
			single = 52,
			mass = 57
		},
		materials = {
			{
				amount = 3,
				clientId = 35434,
				itemId = 38866,
				name = "Tanned Leather"
			},
			{
				amount = 3,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 28655,
				itemId = 32087,
				name = "Bruiser's Boots"
			},
			{
				amount = 4,
				clientId = 37624,
				itemId = 41076,
				name = "Flexible Scale"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 525,
		profession = 7,
		name = "Studded Armor",
		description = "",
		itemId = 32102,
		index = 44,
		experience = 24000,
		durability = 9,
		tier = 5,
		clientId = 28670,
		slotName = "leather armor",
		category = "armors",
		level = {
			single = 58,
			mass = 63
		},
		materials = {
			{
				amount = 7,
				clientId = 35435,
				itemId = 38867,
				name = "Merchant's Leather"
			},
			{
				amount = 3,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 28661,
				itemId = 32093,
				name = "Outlaw Armor"
			},
			{
				amount = 5,
				clientId = 40266,
				itemId = 43718,
				name = "Composite Leather"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 525,
		profession = 7,
		name = "Studded Helmet",
		description = "",
		itemId = 32109,
		index = 45,
		experience = 24000,
		durability = 9,
		tier = 5,
		clientId = 28677,
		slotName = "leather helmet",
		category = "armors",
		level = {
			single = 61,
			mass = 66
		},
		materials = {
			{
				amount = 7,
				clientId = 35435,
				itemId = 38867,
				name = "Merchant's Leather"
			},
			{
				amount = 3,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 28667,
				itemId = 32099,
				name = "Outlaw Helmet"
			},
			{
				amount = 5,
				clientId = 40266,
				itemId = 43718,
				name = "Composite Leather"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 525,
		profession = 7,
		name = "Studded Legs",
		description = "",
		itemId = 32107,
		index = 46,
		experience = 24000,
		durability = 9,
		tier = 5,
		clientId = 28675,
		slotName = "leather legs",
		category = "armors",
		level = {
			single = 64,
			mass = 69
		},
		materials = {
			{
				amount = 3,
				clientId = 35435,
				itemId = 38867,
				name = "Merchant's Leather"
			},
			{
				amount = 7,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 28668,
				itemId = 32100,
				name = "Outlaw Legs"
			},
			{
				amount = 5,
				clientId = 40266,
				itemId = 43718,
				name = "Composite Leather"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 525,
		profession = 7,
		name = "Studded Boots",
		description = "",
		itemId = 32104,
		index = 47,
		experience = 24000,
		durability = 9,
		tier = 5,
		clientId = 28672,
		slotName = "leather boots",
		category = "armors",
		level = {
			single = 67,
			mass = 72
		},
		materials = {
			{
				amount = 3,
				clientId = 35435,
				itemId = 38867,
				name = "Merchant's Leather"
			},
			{
				amount = 7,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 28664,
				itemId = 32096,
				name = "Outlaw Boots"
			},
			{
				amount = 5,
				clientId = 40266,
				itemId = 43718,
				name = "Composite Leather"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 225,
		profession = 7,
		name = "Fry Cook Bracers",
		description = "",
		itemId = 38620,
		index = 48,
		experience = 19200,
		durability = 7,
		tier = 1,
		clientId = 35188,
		slotName = "crafting bracers",
		category = "crafting",
		level = {
			single = 22,
			mass = 27
		},
		materials = {
			{
				amount = 8,
				clientId = 28963,
				itemId = 32395,
				name = "craftman's cloth"
			},
			{
				amount = 8,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 200,
		profession = 7,
		name = "Fry Cook Helmet",
		description = "",
		itemId = 38621,
		index = 49,
		experience = 9600,
		durability = 6,
		tier = 1,
		clientId = 35189,
		slotName = "crafting helmet",
		category = "crafting",
		level = {
			single = 19,
			mass = 24
		},
		materials = {
			{
				amount = 5,
				clientId = 28963,
				itemId = 32395,
				name = "craftman's cloth"
			},
			{
				amount = 3,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 200,
		profession = 7,
		name = "Fry Cook Armor",
		description = "",
		itemId = 38618,
		index = 50,
		experience = 9600,
		durability = 6,
		tier = 1,
		clientId = 35186,
		slotName = "crafting armor",
		category = "crafting",
		level = {
			single = 16,
			mass = 21
		},
		materials = {
			{
				amount = 5,
				clientId = 28963,
				itemId = 32395,
				name = "craftman's cloth"
			},
			{
				amount = 3,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 150,
		profession = 7,
		name = "Fry Cook Legs",
		description = "",
		itemId = 38622,
		index = 51,
		experience = 9600,
		durability = 6,
		tier = 1,
		clientId = 35190,
		slotName = "crafting legs",
		category = "crafting",
		level = {
			single = 13,
			mass = 18
		},
		materials = {
			{
				amount = 3,
				clientId = 28963,
				itemId = 32395,
				name = "craftman's cloth"
			},
			{
				amount = 5,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 150,
		profession = 7,
		name = "Fry Cook Boots",
		description = "",
		itemId = 38619,
		index = 52,
		experience = 9600,
		durability = 6,
		tier = 1,
		clientId = 35187,
		slotName = "crafting boots",
		category = "crafting",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				amount = 3,
				clientId = 28963,
				itemId = 32395,
				name = "craftman's cloth"
			},
			{
				amount = 5,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 350,
		profession = 7,
		name = "Sous Chef Bracers",
		description = "",
		itemId = 38625,
		index = 53,
		experience = 38400,
		durability = 7,
		tier = 2,
		clientId = 35193,
		slotName = "crafting bracers",
		category = "crafting",
		level = {
			single = 42,
			mass = 47
		},
		materials = {
			{
				amount = 12,
				clientId = 28965,
				itemId = 32397,
				name = "silk"
			},
			{
				amount = 9,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 35188,
				itemId = 38620,
				name = "Fry Cook Bracers"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 350,
		profession = 7,
		name = "Sous Chef Helmet",
		description = "",
		itemId = 38626,
		index = 54,
		experience = 19200,
		durability = 7,
		tier = 2,
		clientId = 35194,
		slotName = "crafting helmet",
		category = "crafting",
		level = {
			single = 39,
			mass = 44
		},
		materials = {
			{
				amount = 8,
				clientId = 28965,
				itemId = 32397,
				name = "silk"
			},
			{
				amount = 3,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 35189,
				itemId = 38621,
				name = "Fry Cook Helmet"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 350,
		profession = 7,
		name = "Sous Chef Armor",
		description = "",
		itemId = 38623,
		index = 55,
		experience = 19200,
		durability = 7,
		tier = 2,
		clientId = 35191,
		slotName = "crafting armor",
		category = "crafting",
		level = {
			single = 36,
			mass = 41
		},
		materials = {
			{
				amount = 8,
				clientId = 28965,
				itemId = 32397,
				name = "silk"
			},
			{
				amount = 3,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 35186,
				itemId = 38618,
				name = "Fry Cook Armor"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 250,
		profession = 7,
		name = "Sous Chef Legs",
		description = "",
		itemId = 38627,
		index = 56,
		experience = 19200,
		durability = 7,
		tier = 2,
		clientId = 35195,
		slotName = "crafting legs",
		category = "crafting",
		level = {
			single = 33,
			mass = 38
		},
		materials = {
			{
				amount = 3,
				clientId = 28965,
				itemId = 32397,
				name = "silk"
			},
			{
				amount = 8,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 35190,
				itemId = 38622,
				name = "Fry Cook Legs"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 250,
		profession = 7,
		name = "Sous Chef Boots",
		description = "",
		itemId = 38624,
		index = 57,
		experience = 19200,
		durability = 7,
		tier = 2,
		clientId = 35192,
		slotName = "crafting boots",
		category = "crafting",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				amount = 3,
				clientId = 28965,
				itemId = 32397,
				name = "silk"
			},
			{
				amount = 8,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 35187,
				itemId = 38619,
				name = "Fry Cook Boots"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Master of Cuisine Bracers",
		description = "",
		itemId = 38630,
		index = 58,
		experience = 76800,
		durability = 9,
		tier = 3,
		clientId = 35198,
		slotName = "crafting bracers",
		category = "crafting",
		level = {
			single = 62,
			mass = 67
		},
		materials = {
			{
				amount = 16,
				clientId = 28964,
				itemId = 32396,
				name = "merchant's cloth"
			},
			{
				amount = 16,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 35193,
				itemId = 38625,
				name = "Sous Chef Bracers"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Master of Cuisine Helmet",
		description = "",
		itemId = 38631,
		index = 59,
		experience = 38400,
		durability = 9,
		tier = 3,
		clientId = 35199,
		slotName = "crafting helmet",
		category = "crafting",
		level = {
			single = 59,
			mass = 64
		},
		materials = {
			{
				amount = 12,
				clientId = 28964,
				itemId = 32396,
				name = "merchant's cloth"
			},
			{
				amount = 4,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 35194,
				itemId = 38626,
				name = "Sous Chef Helmet"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Master of Cuisine Armor",
		description = "",
		itemId = 38628,
		index = 60,
		experience = 38400,
		durability = 9,
		tier = 3,
		clientId = 35196,
		slotName = "crafting armor",
		category = "crafting",
		level = {
			single = 56,
			mass = 61
		},
		materials = {
			{
				amount = 12,
				clientId = 28964,
				itemId = 32396,
				name = "merchant's cloth"
			},
			{
				amount = 4,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 35191,
				itemId = 38623,
				name = "Sous Chef Armor"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Master of Cuisine Legs",
		description = "",
		itemId = 38632,
		index = 61,
		experience = 38400,
		durability = 8,
		tier = 3,
		clientId = 35200,
		slotName = "crafting legs",
		category = "crafting",
		level = {
			single = 53,
			mass = 58
		},
		materials = {
			{
				amount = 4,
				clientId = 28964,
				itemId = 32396,
				name = "merchant's cloth"
			},
			{
				amount = 12,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 35195,
				itemId = 38627,
				name = "Sous Chef Legs"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Master of Cuisine Boots",
		description = "",
		itemId = 38629,
		index = 62,
		experience = 38400,
		durability = 8,
		tier = 3,
		clientId = 35197,
		slotName = "crafting boots",
		category = "crafting",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				amount = 4,
				clientId = 28964,
				itemId = 32396,
				name = "merchant's cloth"
			},
			{
				amount = 12,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 35192,
				itemId = 38624,
				name = "Sous Chef Boots"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 225,
		profession = 7,
		name = "Loom Apprentice Gloves",
		description = "",
		itemId = 38635,
		index = 63,
		experience = 19200,
		durability = 7,
		tier = 1,
		clientId = 35203,
		slotName = "crafting gloves",
		category = "crafting",
		level = {
			single = 22,
			mass = 27
		},
		materials = {
			{
				amount = 8,
				clientId = 28963,
				itemId = 32395,
				name = "craftman's cloth"
			},
			{
				amount = 8,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 200,
		profession = 7,
		name = "Loom Apprentice Helmet",
		description = "",
		itemId = 38636,
		index = 64,
		experience = 9600,
		durability = 6,
		tier = 1,
		clientId = 35204,
		slotName = "crafting helmet",
		category = "crafting",
		level = {
			single = 19,
			mass = 24
		},
		materials = {
			{
				amount = 5,
				clientId = 28963,
				itemId = 32395,
				name = "craftman's cloth"
			},
			{
				amount = 3,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 200,
		profession = 7,
		name = "Loom Apprentice Armor",
		description = "",
		itemId = 38633,
		index = 65,
		experience = 9600,
		durability = 6,
		tier = 1,
		clientId = 35201,
		slotName = "crafting armor",
		category = "crafting",
		level = {
			single = 16,
			mass = 21
		},
		materials = {
			{
				amount = 5,
				clientId = 28963,
				itemId = 32395,
				name = "craftman's cloth"
			},
			{
				amount = 3,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 150,
		profession = 7,
		name = "Loom Apprentice Legs",
		description = "",
		itemId = 38637,
		index = 66,
		experience = 9600,
		durability = 6,
		tier = 1,
		clientId = 35205,
		slotName = "crafting legs",
		category = "crafting",
		level = {
			single = 13,
			mass = 18
		},
		materials = {
			{
				amount = 3,
				clientId = 28963,
				itemId = 32395,
				name = "craftman's cloth"
			},
			{
				amount = 5,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 150,
		profession = 7,
		name = "Loom Apprentice Boots",
		description = "",
		itemId = 38634,
		index = 67,
		experience = 9600,
		durability = 6,
		tier = 1,
		clientId = 35202,
		slotName = "crafting boots",
		category = "crafting",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				amount = 3,
				clientId = 28963,
				itemId = 32395,
				name = "craftman's cloth"
			},
			{
				amount = 5,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 350,
		profession = 7,
		name = "Threadspinner Gloves",
		description = "",
		itemId = 38640,
		index = 68,
		experience = 38400,
		durability = 7,
		tier = 2,
		clientId = 35208,
		slotName = "crafting gloves",
		category = "crafting",
		level = {
			single = 42,
			mass = 47
		},
		materials = {
			{
				amount = 12,
				clientId = 28965,
				itemId = 32397,
				name = "silk"
			},
			{
				amount = 9,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 35203,
				itemId = 38635,
				name = "Loom Apprentice Gloves"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 350,
		profession = 7,
		name = "Threadspinner Helmet",
		description = "",
		itemId = 38641,
		index = 69,
		experience = 19200,
		durability = 7,
		tier = 2,
		clientId = 35209,
		slotName = "crafting helmet",
		category = "crafting",
		level = {
			single = 39,
			mass = 44
		},
		materials = {
			{
				amount = 8,
				clientId = 28965,
				itemId = 32397,
				name = "silk"
			},
			{
				amount = 3,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 35204,
				itemId = 38636,
				name = "Loom Apprentice Helmet"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 350,
		profession = 7,
		name = "Threadspinner Armor",
		description = "",
		itemId = 38638,
		index = 70,
		experience = 19200,
		durability = 7,
		tier = 2,
		clientId = 35206,
		slotName = "crafting armor",
		category = "crafting",
		level = {
			single = 36,
			mass = 41
		},
		materials = {
			{
				amount = 8,
				clientId = 28965,
				itemId = 32397,
				name = "silk"
			},
			{
				amount = 3,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 35201,
				itemId = 38633,
				name = "Loom Apprentice Armor"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 250,
		profession = 7,
		name = "Threadspinner Legs",
		description = "",
		itemId = 38642,
		index = 71,
		experience = 19200,
		durability = 7,
		tier = 2,
		clientId = 35210,
		slotName = "crafting legs",
		category = "crafting",
		level = {
			single = 33,
			mass = 38
		},
		materials = {
			{
				amount = 3,
				clientId = 28965,
				itemId = 32397,
				name = "silk"
			},
			{
				amount = 8,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 35205,
				itemId = 38637,
				name = "Loom Apprentice Legs"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 250,
		profession = 7,
		name = "Threadspinner Boots",
		description = "",
		itemId = 38639,
		index = 72,
		experience = 19200,
		durability = 7,
		tier = 2,
		clientId = 35207,
		slotName = "crafting boots",
		category = "crafting",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				amount = 3,
				clientId = 28965,
				itemId = 32397,
				name = "silk"
			},
			{
				amount = 8,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 35202,
				itemId = 38634,
				name = "Loom Apprentice Boots"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Master Tailor Bracers",
		description = "",
		itemId = 38645,
		index = 73,
		experience = 76800,
		durability = 9,
		tier = 3,
		clientId = 35213,
		slotName = "crafting bracers",
		category = "crafting",
		level = {
			single = 62,
			mass = 67
		},
		materials = {
			{
				amount = 16,
				clientId = 28964,
				itemId = 32396,
				name = "merchant's cloth"
			},
			{
				amount = 16,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 35208,
				itemId = 38640,
				name = "Threadspinner Gloves"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Master Tailor Helmet",
		description = "",
		itemId = 38646,
		index = 74,
		experience = 38400,
		durability = 9,
		tier = 3,
		clientId = 35214,
		slotName = "crafting helmet",
		category = "crafting",
		level = {
			single = 59,
			mass = 64
		},
		materials = {
			{
				amount = 12,
				clientId = 28964,
				itemId = 32396,
				name = "merchant's cloth"
			},
			{
				amount = 4,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 35209,
				itemId = 38641,
				name = "Threadspinner Helmet"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Master Tailor Armor",
		description = "",
		itemId = 38643,
		index = 75,
		experience = 38400,
		durability = 9,
		tier = 3,
		clientId = 35211,
		slotName = "crafting armor",
		category = "crafting",
		level = {
			single = 56,
			mass = 61
		},
		materials = {
			{
				amount = 12,
				clientId = 28964,
				itemId = 32396,
				name = "merchant's cloth"
			},
			{
				amount = 4,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 35206,
				itemId = 38638,
				name = "Threadspinner Armor"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Master Tailor Legs",
		description = "",
		itemId = 38647,
		index = 76,
		experience = 38400,
		durability = 8,
		tier = 3,
		clientId = 35215,
		slotName = "crafting legs",
		category = "crafting",
		level = {
			single = 53,
			mass = 58
		},
		materials = {
			{
				amount = 4,
				clientId = 28964,
				itemId = 32396,
				name = "merchant's cloth"
			},
			{
				amount = 12,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 35210,
				itemId = 38642,
				name = "Threadspinner Legs"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Master Tailor Boots",
		description = "",
		itemId = 38644,
		index = 77,
		experience = 38400,
		durability = 8,
		tier = 3,
		clientId = 35212,
		slotName = "crafting boots",
		category = "crafting",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				amount = 4,
				clientId = 28964,
				itemId = 32396,
				name = "merchant's cloth"
			},
			{
				amount = 12,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 35207,
				itemId = 38639,
				name = "Threadspinner Boots"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 225,
		profession = 7,
		name = "Workshop Assistant Gloves",
		description = "",
		itemId = 38605,
		index = 78,
		experience = 19200,
		durability = 7,
		tier = 1,
		clientId = 35173,
		slotName = "crafting gloves",
		category = "crafting",
		level = {
			single = 22,
			mass = 27
		},
		materials = {
			{
				amount = 8,
				clientId = 35433,
				itemId = 38865,
				name = "Craftman's Leather"
			},
			{
				amount = 8,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 200,
		profession = 7,
		name = "Workshop Assistant Helmet",
		description = "",
		itemId = 38606,
		index = 79,
		experience = 9600,
		durability = 6,
		tier = 1,
		clientId = 35174,
		slotName = "crafting helmet",
		category = "crafting",
		level = {
			single = 19,
			mass = 24
		},
		materials = {
			{
				amount = 5,
				clientId = 35433,
				itemId = 38865,
				name = "Craftman's Leather"
			},
			{
				amount = 3,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 200,
		profession = 7,
		name = "Workshop Assistant Armor",
		description = "",
		itemId = 38603,
		index = 80,
		experience = 9600,
		durability = 6,
		tier = 1,
		clientId = 35171,
		slotName = "crafting armor",
		category = "crafting",
		level = {
			single = 16,
			mass = 21
		},
		materials = {
			{
				amount = 5,
				clientId = 35433,
				itemId = 38865,
				name = "Craftman's Leather"
			},
			{
				amount = 3,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 150,
		profession = 7,
		name = "Workshop Assistant Legs",
		description = "",
		itemId = 38607,
		index = 81,
		experience = 9600,
		durability = 6,
		tier = 1,
		clientId = 35175,
		slotName = "crafting legs",
		category = "crafting",
		level = {
			single = 13,
			mass = 18
		},
		materials = {
			{
				amount = 3,
				clientId = 35433,
				itemId = 38865,
				name = "Craftman's Leather"
			},
			{
				amount = 5,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 150,
		profession = 7,
		name = "Workshop Assistant Boots",
		description = "",
		itemId = 38604,
		index = 82,
		experience = 9600,
		durability = 6,
		tier = 1,
		clientId = 35172,
		slotName = "crafting boots",
		category = "crafting",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				amount = 3,
				clientId = 35433,
				itemId = 38865,
				name = "Craftman's Leather"
			},
			{
				amount = 5,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 350,
		profession = 7,
		name = "Woodworker Gloves",
		description = "",
		itemId = 38610,
		index = 83,
		experience = 38400,
		durability = 7,
		tier = 2,
		clientId = 35178,
		slotName = "crafting gloves",
		category = "crafting",
		level = {
			single = 42,
			mass = 47
		},
		materials = {
			{
				amount = 12,
				clientId = 35434,
				itemId = 38866,
				name = "Tanned Leather"
			},
			{
				amount = 9,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 35173,
				itemId = 38605,
				name = "Workshop Assistant Gloves"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 350,
		profession = 7,
		name = "Woodworker Helmet",
		description = "",
		itemId = 38611,
		index = 84,
		experience = 19200,
		durability = 7,
		tier = 2,
		clientId = 35179,
		slotName = "crafting helmet",
		category = "crafting",
		level = {
			single = 39,
			mass = 44
		},
		materials = {
			{
				amount = 8,
				clientId = 35434,
				itemId = 38866,
				name = "Tanned Leather"
			},
			{
				amount = 3,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 35174,
				itemId = 38606,
				name = "Workshop Assistant Helmet"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 350,
		profession = 7,
		name = "Woodworker Armor",
		description = "",
		itemId = 38608,
		index = 85,
		experience = 19200,
		durability = 7,
		tier = 2,
		clientId = 35176,
		slotName = "crafting armor",
		category = "crafting",
		level = {
			single = 36,
			mass = 41
		},
		materials = {
			{
				amount = 8,
				clientId = 35434,
				itemId = 38866,
				name = "Tanned Leather"
			},
			{
				amount = 3,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 35171,
				itemId = 38603,
				name = "Workshop Assistant Armor"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 250,
		profession = 7,
		name = "Woodworker Legs",
		description = "",
		itemId = 38612,
		index = 86,
		experience = 19200,
		durability = 7,
		tier = 2,
		clientId = 35180,
		slotName = "crafting legs",
		category = "crafting",
		level = {
			single = 33,
			mass = 38
		},
		materials = {
			{
				amount = 3,
				clientId = 35434,
				itemId = 38866,
				name = "Tanned Leather"
			},
			{
				amount = 8,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 35175,
				itemId = 38607,
				name = "Workshop Assistant Legs"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 250,
		profession = 7,
		name = "Woodworker Boots",
		description = "",
		itemId = 38609,
		index = 87,
		experience = 19200,
		durability = 7,
		tier = 2,
		clientId = 35177,
		slotName = "crafting boots",
		category = "crafting",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				amount = 3,
				clientId = 35434,
				itemId = 38866,
				name = "Tanned Leather"
			},
			{
				amount = 8,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 35172,
				itemId = 38604,
				name = "Workshop Assistant Boots"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Master Mason Gloves",
		description = "",
		itemId = 38615,
		index = 88,
		experience = 76800,
		durability = 9,
		tier = 3,
		clientId = 35183,
		slotName = "crafting gloves",
		category = "crafting",
		level = {
			single = 62,
			mass = 67
		},
		materials = {
			{
				amount = 16,
				clientId = 35435,
				itemId = 38867,
				name = "Merchant's Leather"
			},
			{
				amount = 16,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 35178,
				itemId = 38610,
				name = "Woodworker Gloves"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Master Mason Helmet",
		description = "",
		itemId = 38616,
		index = 89,
		experience = 38400,
		durability = 9,
		tier = 3,
		clientId = 35184,
		slotName = "crafting helmet",
		category = "crafting",
		level = {
			single = 59,
			mass = 64
		},
		materials = {
			{
				amount = 12,
				clientId = 35435,
				itemId = 38867,
				name = "Merchant's Leather"
			},
			{
				amount = 4,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 35179,
				itemId = 38611,
				name = "Woodworker Helmet"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Master Mason Armor",
		description = "",
		itemId = 38613,
		index = 90,
		experience = 38400,
		durability = 9,
		tier = 3,
		clientId = 35181,
		slotName = "crafting armor",
		category = "crafting",
		level = {
			single = 56,
			mass = 61
		},
		materials = {
			{
				amount = 12,
				clientId = 35435,
				itemId = 38867,
				name = "Merchant's Leather"
			},
			{
				amount = 4,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 35176,
				itemId = 38608,
				name = "Woodworker Armor"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Master Mason Legs",
		description = "",
		itemId = 38617,
		index = 91,
		experience = 38400,
		durability = 8,
		tier = 3,
		clientId = 35185,
		slotName = "crafting legs",
		category = "crafting",
		level = {
			single = 53,
			mass = 58
		},
		materials = {
			{
				amount = 4,
				clientId = 35435,
				itemId = 38867,
				name = "Merchant's Leather"
			},
			{
				amount = 12,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 35180,
				itemId = 38612,
				name = "Woodworker Legs"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Master Mason Boots",
		description = "",
		itemId = 38614,
		index = 92,
		experience = 38400,
		durability = 8,
		tier = 3,
		clientId = 35182,
		slotName = "crafting boots",
		category = "crafting",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				amount = 4,
				clientId = 35435,
				itemId = 38867,
				name = "Merchant's Leather"
			},
			{
				amount = 12,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 35177,
				itemId = 38609,
				name = "Woodworker Boots"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 225,
		profession = 7,
		name = "Apprentice Anvil Bracers",
		description = "",
		itemId = 38590,
		index = 93,
		experience = 19200,
		durability = 7,
		tier = 1,
		clientId = 35158,
		slotName = "crafting bracers",
		category = "crafting",
		level = {
			single = 22,
			mass = 27
		},
		materials = {
			{
				amount = 8,
				clientId = 35433,
				itemId = 38865,
				name = "Craftman's Leather"
			},
			{
				amount = 8,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 200,
		profession = 7,
		name = "Apprentice Anvil Helmet",
		description = "",
		itemId = 38591,
		index = 94,
		experience = 9600,
		durability = 6,
		tier = 1,
		clientId = 35159,
		slotName = "crafting helmet",
		category = "crafting",
		level = {
			single = 19,
			mass = 24
		},
		materials = {
			{
				amount = 5,
				clientId = 35433,
				itemId = 38865,
				name = "Craftman's Leather"
			},
			{
				amount = 3,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 200,
		profession = 7,
		name = "Apprentice Anvil Armor",
		description = "",
		itemId = 38588,
		index = 95,
		experience = 9600,
		durability = 6,
		tier = 1,
		clientId = 35156,
		slotName = "crafting armor",
		category = "crafting",
		level = {
			single = 16,
			mass = 21
		},
		materials = {
			{
				amount = 5,
				clientId = 35433,
				itemId = 38865,
				name = "Craftman's Leather"
			},
			{
				amount = 3,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 150,
		profession = 7,
		name = "Apprentice Anvil Legs",
		description = "",
		itemId = 38592,
		index = 96,
		experience = 9600,
		durability = 6,
		tier = 1,
		clientId = 35160,
		slotName = "crafting legs",
		category = "crafting",
		level = {
			single = 13,
			mass = 18
		},
		materials = {
			{
				amount = 3,
				clientId = 35433,
				itemId = 38865,
				name = "Craftman's Leather"
			},
			{
				amount = 5,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 150,
		profession = 7,
		name = "Apprentice Anvil Boots",
		description = "",
		itemId = 38589,
		index = 97,
		experience = 9600,
		durability = 6,
		tier = 1,
		clientId = 35157,
		slotName = "crafting boots",
		category = "crafting",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				amount = 3,
				clientId = 35433,
				itemId = 38865,
				name = "Craftman's Leather"
			},
			{
				amount = 5,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 350,
		profession = 7,
		name = "Silversmith Bracers",
		description = "",
		itemId = 38595,
		index = 98,
		experience = 38400,
		durability = 7,
		tier = 2,
		clientId = 35163,
		slotName = "crafting bracers",
		category = "crafting",
		level = {
			single = 42,
			mass = 47
		},
		materials = {
			{
				amount = 12,
				clientId = 35434,
				itemId = 38866,
				name = "Tanned Leather"
			},
			{
				amount = 9,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 35158,
				itemId = 38590,
				name = "Apprentice Anvil Bracers"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 350,
		profession = 7,
		name = "Silversmith Helmet",
		description = "",
		itemId = 38596,
		index = 99,
		experience = 19200,
		durability = 7,
		tier = 2,
		clientId = 35164,
		slotName = "crafting helmet",
		category = "crafting",
		level = {
			single = 39,
			mass = 44
		},
		materials = {
			{
				amount = 8,
				clientId = 35434,
				itemId = 38866,
				name = "Tanned Leather"
			},
			{
				amount = 3,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 35159,
				itemId = 38591,
				name = "Apprentice Anvil Helmet"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 350,
		profession = 7,
		name = "Silversmith Armor",
		description = "",
		itemId = 38593,
		index = 100,
		experience = 19200,
		durability = 7,
		tier = 2,
		clientId = 35161,
		slotName = "crafting armor",
		category = "crafting",
		level = {
			single = 36,
			mass = 41
		},
		materials = {
			{
				amount = 8,
				clientId = 35434,
				itemId = 38866,
				name = "Tanned Leather"
			},
			{
				amount = 3,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 35156,
				itemId = 38588,
				name = "Apprentice Anvil Armor"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 250,
		profession = 7,
		name = "Silversmith Legs",
		description = "",
		itemId = 38597,
		index = 101,
		experience = 19200,
		durability = 7,
		tier = 2,
		clientId = 35165,
		slotName = "crafting legs",
		category = "crafting",
		level = {
			single = 33,
			mass = 38
		},
		materials = {
			{
				amount = 3,
				clientId = 35434,
				itemId = 38866,
				name = "Tanned Leather"
			},
			{
				amount = 8,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 35160,
				itemId = 38592,
				name = "Apprentice Anvil Legs"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 250,
		profession = 7,
		name = "Silversmith Boots",
		description = "",
		itemId = 38594,
		index = 102,
		experience = 19200,
		durability = 7,
		tier = 2,
		clientId = 35162,
		slotName = "crafting boots",
		category = "crafting",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				amount = 3,
				clientId = 35434,
				itemId = 38866,
				name = "Tanned Leather"
			},
			{
				amount = 8,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 35157,
				itemId = 38589,
				name = "Apprentice Anvil Boots"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Forgemaster Bracers",
		description = "",
		itemId = 38600,
		index = 103,
		experience = 76800,
		durability = 9,
		tier = 3,
		clientId = 35168,
		slotName = "crafting bracers",
		category = "crafting",
		level = {
			single = 62,
			mass = 67
		},
		materials = {
			{
				amount = 16,
				clientId = 35435,
				itemId = 38867,
				name = "Merchant's Leather"
			},
			{
				amount = 16,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 35163,
				itemId = 38595,
				name = "Silversmith Bracers"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Forgemaster Helmet",
		description = "",
		itemId = 38601,
		index = 104,
		experience = 38400,
		durability = 9,
		tier = 3,
		clientId = 35169,
		slotName = "crafting helmet",
		category = "crafting",
		level = {
			single = 59,
			mass = 64
		},
		materials = {
			{
				amount = 12,
				clientId = 35435,
				itemId = 38867,
				name = "Merchant's Leather"
			},
			{
				amount = 4,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 35164,
				itemId = 38596,
				name = "Silversmith Helmet"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Forgemaster Armor",
		description = "",
		itemId = 38598,
		index = 105,
		experience = 38400,
		durability = 9,
		tier = 3,
		clientId = 35166,
		slotName = "crafting armor",
		category = "crafting",
		level = {
			single = 56,
			mass = 61
		},
		materials = {
			{
				amount = 12,
				clientId = 35435,
				itemId = 38867,
				name = "Merchant's Leather"
			},
			{
				amount = 4,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 35161,
				itemId = 38593,
				name = "Silversmith Armor"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Forgemaster Legs",
		description = "",
		itemId = 38602,
		index = 106,
		experience = 38400,
		durability = 8,
		tier = 3,
		clientId = 35170,
		slotName = "crafting legs",
		category = "crafting",
		level = {
			single = 53,
			mass = 58
		},
		materials = {
			{
				amount = 4,
				clientId = 35435,
				itemId = 38867,
				name = "Merchant's Leather"
			},
			{
				amount = 12,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 35165,
				itemId = 38597,
				name = "Silversmith Legs"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Forgemaster Boots",
		description = "",
		itemId = 38599,
		index = 107,
		experience = 38400,
		durability = 8,
		tier = 3,
		clientId = 35167,
		slotName = "crafting boots",
		category = "crafting",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				amount = 4,
				clientId = 35435,
				itemId = 38867,
				name = "Merchant's Leather"
			},
			{
				amount = 12,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 35162,
				itemId = 38594,
				name = "Silversmith Boots"
			}
		}
	},
	{
		amount = 1,
		quality = 75,
		progress = 25,
		profession = 7,
		name = "simple cloth",
		description = "Used in various recipes. Unassuming yet versatile, serves as the material for everyday textiles.",
		itemId = 32398,
		index = 108,
		experience = 610,
		durability = 4,
		tier = -1,
		clientId = 28966,
		slotName = "",
		category = "cloth",
		level = {
			single = 1,
			mass = 6
		},
		materials = {
			{
				amount = 8,
				clientId = 34475,
				itemId = 37907,
				name = "Spool of hair"
			}
		}
	},
	{
		amount = 1,
		quality = 150,
		progress = 150,
		profession = 7,
		name = "craftman's cloth",
		description = "Used in various recipes. Sturdy and reliable, a material for those who value utility in their creations.",
		itemId = 32395,
		index = 109,
		experience = 1200,
		durability = 6,
		tier = -1,
		clientId = 28963,
		slotName = "",
		category = "cloth",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				amount = 15,
				clientId = 34475,
				itemId = 37907,
				name = "Spool of hair"
			}
		}
	},
	{
		amount = 1,
		quality = 175,
		progress = 225,
		profession = 7,
		name = "silk",
		description = "Used in various recipes. Luxurious and smooth, Silk is the epitome of opulence in the textile world.",
		itemId = 32397,
		index = 110,
		experience = 1850,
		durability = 7,
		tier = -1,
		clientId = 28965,
		slotName = "",
		category = "cloth",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				amount = 23,
				clientId = 34475,
				itemId = 37907,
				name = "Spool of hair"
			}
		}
	},
	{
		amount = 1,
		quality = 425,
		progress = 450,
		profession = 7,
		name = "merchant's cloth",
		description = "Used in various recipes. Its subtle sheen and tasteful patterns carry an air of sophistication.",
		itemId = 32396,
		index = 111,
		experience = 2400,
		durability = 8,
		tier = -1,
		clientId = 28964,
		slotName = "",
		category = "cloth",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				amount = 30,
				clientId = 34475,
				itemId = 37907,
				name = "Spool of hair"
			}
		}
	},
	{
		amount = 1,
		quality = 525,
		progress = 550,
		profession = 7,
		name = "artisan cloth",
		description = "Used in various recipes. Its luxurious texture makes it perfect for creating fine garments.",
		itemId = 32394,
		index = 112,
		experience = 3050,
		durability = 9,
		tier = -1,
		clientId = 28962,
		slotName = "",
		category = "cloth",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				amount = 38,
				clientId = 34475,
				itemId = 37907,
				name = "Spool of hair"
			}
		}
	},
	{
		specialization = "Tailor",
		amount = 1,
		profession = 7,
		name = "Warlock Armor",
		description = "",
		tier = 6,
		slotName = "cloth armor",
		quality = 100,
		progress = 700,
		itemId = 40578,
		index = 113,
		experience = 33000,
		durability = 12,
		clientId = 37126,
		category = "armors",
		level = {
			single = 78,
			mass = 83
		},
		materials = {
			{
				amount = 7,
				clientId = 28962,
				itemId = 32394,
				name = "artisan cloth"
			},
			{
				amount = 4,
				clientId = 28970,
				itemId = 32402,
				name = "artisan thread"
			},
			{
				amount = 1,
				clientId = 28632,
				itemId = 32064,
				name = "Mystic Armor"
			},
			{
				amount = 6,
				clientId = 40281,
				itemId = 43733,
				name = "Winterwool"
			}
		}
	},
	{
		specialization = "Tailor",
		amount = 1,
		profession = 7,
		name = "Warlock Helmet",
		description = "",
		tier = 6,
		slotName = "cloth helmet",
		quality = 100,
		progress = 700,
		itemId = 40584,
		index = 114,
		experience = 33000,
		durability = 12,
		clientId = 37132,
		category = "armors",
		level = {
			single = 80,
			mass = 85
		},
		materials = {
			{
				amount = 7,
				clientId = 28962,
				itemId = 32394,
				name = "artisan cloth"
			},
			{
				amount = 4,
				clientId = 28970,
				itemId = 32402,
				name = "artisan thread"
			},
			{
				amount = 1,
				clientId = 28633,
				itemId = 32065,
				name = "Mystic Helmet"
			},
			{
				amount = 6,
				clientId = 40281,
				itemId = 43733,
				name = "Winterwool"
			}
		}
	},
	{
		specialization = "Tailor",
		amount = 1,
		profession = 7,
		name = "Warlock Legs",
		description = "",
		tier = 6,
		slotName = "cloth legs",
		quality = 100,
		progress = 700,
		itemId = 40585,
		index = 115,
		experience = 33000,
		durability = 12,
		clientId = 37133,
		category = "armors",
		level = {
			single = 82,
			mass = 87
		},
		materials = {
			{
				amount = 4,
				clientId = 28962,
				itemId = 32394,
				name = "artisan cloth"
			},
			{
				amount = 7,
				clientId = 28970,
				itemId = 32402,
				name = "artisan thread"
			},
			{
				amount = 1,
				clientId = 28631,
				itemId = 32063,
				name = "Mystic Legs"
			},
			{
				amount = 6,
				clientId = 40281,
				itemId = 43733,
				name = "Winterwool"
			}
		}
	},
	{
		specialization = "Tailor",
		amount = 1,
		profession = 7,
		name = "Warlock Boots",
		description = "",
		tier = 6,
		slotName = "cloth boots",
		quality = 100,
		progress = 700,
		itemId = 40599,
		index = 116,
		experience = 33000,
		durability = 12,
		clientId = 37147,
		category = "armors",
		level = {
			single = 84,
			mass = 89
		},
		materials = {
			{
				amount = 4,
				clientId = 28962,
				itemId = 32394,
				name = "artisan cloth"
			},
			{
				amount = 7,
				clientId = 28970,
				itemId = 32402,
				name = "artisan thread"
			},
			{
				amount = 1,
				clientId = 28625,
				itemId = 32057,
				name = "Mystic Boots"
			},
			{
				amount = 6,
				clientId = 40281,
				itemId = 43733,
				name = "Winterwool"
			}
		}
	},
	{
		specialization = "Patchworker",
		amount = 1,
		profession = 7,
		name = "Guerrila Armor",
		description = "",
		tier = 6,
		slotName = "leather armor",
		quality = 100,
		progress = 700,
		itemId = 40591,
		index = 117,
		experience = 33000,
		durability = 12,
		clientId = 37139,
		category = "armors",
		level = {
			single = 78,
			mass = 83
		},
		materials = {
			{
				amount = 7,
				clientId = 35436,
				itemId = 38868,
				name = "Artisan Leather"
			},
			{
				amount = 4,
				clientId = 28970,
				itemId = 32402,
				name = "artisan thread"
			},
			{
				amount = 1,
				clientId = 28670,
				itemId = 32102,
				name = "Studded Armor"
			},
			{
				amount = 6,
				clientId = 40269,
				itemId = 43721,
				name = "Draconic Hide"
			}
		}
	},
	{
		specialization = "Patchworker",
		amount = 1,
		profession = 7,
		name = "Guerrila Helmet",
		description = "",
		tier = 6,
		slotName = "leather helmet",
		quality = 100,
		progress = 700,
		itemId = 40593,
		index = 118,
		experience = 33000,
		durability = 12,
		clientId = 37141,
		category = "armors",
		level = {
			single = 81,
			mass = 86
		},
		materials = {
			{
				amount = 7,
				clientId = 35436,
				itemId = 38868,
				name = "Artisan Leather"
			},
			{
				amount = 4,
				clientId = 28970,
				itemId = 32402,
				name = "artisan thread"
			},
			{
				amount = 1,
				clientId = 28677,
				itemId = 32109,
				name = "Studded Helmet"
			},
			{
				amount = 6,
				clientId = 40269,
				itemId = 43721,
				name = "Draconic Hide"
			}
		}
	},
	{
		specialization = "Patchworker",
		amount = 1,
		profession = 7,
		name = "Guerrila Legs",
		description = "",
		tier = 6,
		slotName = "leather legs",
		quality = 100,
		progress = 700,
		itemId = 40594,
		index = 119,
		experience = 33000,
		durability = 12,
		clientId = 37142,
		category = "armors",
		level = {
			single = 84,
			mass = 89
		},
		materials = {
			{
				amount = 4,
				clientId = 35436,
				itemId = 38868,
				name = "Artisan Leather"
			},
			{
				amount = 7,
				clientId = 28970,
				itemId = 32402,
				name = "artisan thread"
			},
			{
				amount = 1,
				clientId = 28675,
				itemId = 32107,
				name = "Studded Legs"
			},
			{
				amount = 6,
				clientId = 40269,
				itemId = 43721,
				name = "Draconic Hide"
			}
		}
	},
	{
		specialization = "Patchworker",
		amount = 1,
		profession = 7,
		name = "Guerrila Boots",
		description = "",
		tier = 6,
		slotName = "leather boots",
		quality = 100,
		progress = 700,
		itemId = 40592,
		index = 120,
		experience = 33000,
		durability = 12,
		clientId = 37140,
		category = "armors",
		level = {
			single = 87,
			mass = 92
		},
		materials = {
			{
				amount = 4,
				clientId = 35436,
				itemId = 38868,
				name = "Artisan Leather"
			},
			{
				amount = 7,
				clientId = 28970,
				itemId = 32402,
				name = "artisan thread"
			},
			{
				amount = 1,
				clientId = 28672,
				itemId = 32104,
				name = "Studded Boots"
			},
			{
				amount = 6,
				clientId = 40269,
				itemId = 43721,
				name = "Draconic Hide"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 100,
		profession = 7,
		name = "Small Sail Kit",
		description = "Used for crafting a Sail at the Ship Builder.",
		itemId = 40728,
		index = 121,
		experience = 100000,
		durability = 4,
		tier = -1,
		clientId = 37276,
		slotName = "",
		category = "Ship Module",
		level = {
			single = 15,
			mass = 20
		},
		materials = {
			{
				amount = 60,
				clientId = 28966,
				itemId = 32398,
				name = "simple cloth"
			},
			{
				amount = 30,
				clientId = 35432,
				itemId = 38864,
				name = "Coarse Leather"
			},
			{
				amount = 75,
				clientId = 28971,
				itemId = 32403,
				name = "coarse thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 300,
		profession = 7,
		name = "Medium Sail Kit",
		description = "Used for crafting a Sail at the Ship Builder.",
		itemId = 40709,
		index = 122,
		experience = 488000,
		durability = 7,
		tier = -1,
		clientId = 37257,
		slotName = "",
		category = "Ship Module",
		level = {
			single = 35,
			mass = 40
		},
		materials = {
			{
				amount = 70,
				clientId = 28965,
				itemId = 32397,
				name = "silk"
			},
			{
				amount = 50,
				clientId = 35434,
				itemId = 38866,
				name = "Tanned Leather"
			},
			{
				amount = 90,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 37276,
				itemId = 40728,
				name = "Small Sail Kit"
			}
		}
	},
	{
		specialization = "Sailmaker",
		amount = 1,
		profession = 7,
		name = "Large Sail Kit",
		description = "Used for crafting a Sail at the Ship Builder.",
		tier = -1,
		slotName = "",
		quality = 0,
		progress = 525,
		itemId = 40694,
		index = 123,
		experience = 1272000,
		durability = 8,
		clientId = 37242,
		category = "Ship Module",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				amount = 75,
				clientId = 28964,
				itemId = 32396,
				name = "merchant's cloth"
			},
			{
				amount = 60,
				clientId = 35435,
				itemId = 38867,
				name = "Merchant's Leather"
			},
			{
				amount = 80,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 37257,
				itemId = 40709,
				name = "Medium Sail Kit"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 225,
		profession = 7,
		name = "Thread Spool",
		description = "Used in housing upgrades.",
		itemId = 40740,
		index = 124,
		experience = 9500,
		durability = 7,
		tier = -1,
		clientId = 37288,
		slotName = "",
		category = "Housing Craft",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				amount = 8,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Luxury Thread Spool",
		description = "Used in housing upgrades.",
		itemId = 40700,
		index = 125,
		experience = 60000,
		durability = 8,
		tier = -1,
		clientId = 37248,
		slotName = "",
		category = "Housing Craft",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				amount = 25,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 225,
		profession = 7,
		name = "Cloth Roll",
		description = "Used in housing upgrades.",
		itemId = 40678,
		index = 126,
		experience = 24000,
		durability = 7,
		tier = -1,
		clientId = 37226,
		slotName = "",
		category = "Housing Craft",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				amount = 15,
				clientId = 28963,
				itemId = 32395,
				name = "craftman's cloth"
			},
			{
				amount = 5,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Refined Cloth Roll",
		description = "Used in housing upgrades.",
		itemId = 40714,
		index = 127,
		experience = 60000,
		durability = 8,
		tier = -1,
		clientId = 37262,
		slotName = "",
		category = "Housing Craft",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				amount = 15,
				clientId = 28964,
				itemId = 32396,
				name = "merchant's cloth"
			},
			{
				amount = 5,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 550,
		profession = 7,
		name = "Luxury Cloth Roll",
		description = "Used in housing upgrades.",
		itemId = 40699,
		index = 128,
		experience = 101000,
		durability = 9,
		tier = -1,
		clientId = 37247,
		slotName = "",
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				amount = 20,
				clientId = 28962,
				itemId = 32394,
				name = "artisan cloth"
			},
			{
				amount = 15,
				clientId = 28970,
				itemId = 32402,
				name = "artisan thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 225,
		profession = 7,
		name = "Carpet",
		description = "Used in housing upgrades.",
		itemId = 40677,
		index = 129,
		experience = 18000,
		durability = 7,
		tier = -1,
		clientId = 37225,
		slotName = "",
		category = "Housing Craft",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				amount = 10,
				clientId = 28963,
				itemId = 32395,
				name = "craftman's cloth"
			},
			{
				amount = 5,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Luxury Carpet",
		description = "Used in housing upgrades.",
		itemId = 40698,
		index = 130,
		experience = 72000,
		durability = 8,
		tier = -1,
		clientId = 37246,
		slotName = "",
		category = "Housing Craft",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				amount = 15,
				clientId = 28964,
				itemId = 32396,
				name = "merchant's cloth"
			},
			{
				amount = 15,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 300,
		profession = 7,
		name = "Small Fishing Nets Kit",
		description = "Used for crafting ship modules for your ship at the Ship Builder",
		itemId = 40724,
		index = 131,
		experience = 74000,
		durability = 7,
		tier = -1,
		clientId = 37272,
		slotName = "",
		category = "Ship Module",
		level = {
			single = 35,
			mass = 40
		},
		materials = {
			{
				amount = 25,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 15,
				clientId = 35434,
				itemId = 38866,
				name = "Tanned Leather"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 500,
		profession = 7,
		name = "Medium Fishing Nets Kit",
		description = "Used for crafting ship modules for your ship at the Ship Builder",
		itemId = 40705,
		index = 132,
		experience = 300000,
		durability = 7,
		tier = -1,
		clientId = 37253,
		slotName = "",
		category = "Ship Module",
		level = {
			single = 45,
			mass = 50
		},
		materials = {
			{
				amount = 65,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 30,
				clientId = 35435,
				itemId = 38867,
				name = "Merchant's Leather"
			},
			{
				amount = 1,
				clientId = 37272,
				itemId = 40724,
				name = "Small Fishing Nets Kit"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 550,
		profession = 7,
		name = "Large Fishing Nets Kit",
		description = "Used for crafting ship modules for your ship at the Ship Builder",
		itemId = 40690,
		index = 133,
		experience = 1000000,
		durability = 9,
		tier = -1,
		clientId = 37238,
		slotName = "",
		category = "Ship Module",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				amount = 150,
				clientId = 28970,
				itemId = 32402,
				name = "artisan thread"
			},
			{
				amount = 80,
				clientId = 35436,
				itemId = 38868,
				name = "Artisan Leather"
			},
			{
				amount = 1,
				clientId = 37253,
				itemId = 40705,
				name = "Medium Fishing Nets Kit"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 50,
		profession = 7,
		name = "Shadecloth Armor",
		description = "",
		itemId = 32021,
		index = 134,
		experience = 640,
		durability = 3,
		tier = 1,
		clientId = 28589,
		slotName = "cloth armor",
		category = "armors",
		level = {
			single = 3,
			mass = 8
		},
		materials = {
			{
				amount = 1,
				clientId = 28966,
				itemId = 32398,
				name = "simple cloth"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 50,
		profession = 7,
		name = "Shadecloth Helmet",
		description = "",
		itemId = 32027,
		index = 135,
		experience = 640,
		durability = 3,
		tier = 1,
		clientId = 28595,
		slotName = "cloth helmet",
		category = "armors",
		level = {
			single = 5,
			mass = 10
		},
		materials = {
			{
				amount = 1,
				clientId = 28966,
				itemId = 32398,
				name = "simple cloth"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 50,
		profession = 7,
		name = "Shadecloth Legs",
		description = "",
		itemId = 32028,
		index = 136,
		experience = 640,
		durability = 3,
		tier = 1,
		clientId = 28596,
		slotName = "cloth legs",
		category = "armors",
		level = {
			single = 7,
			mass = 12
		},
		materials = {
			{
				amount = 1,
				clientId = 28966,
				itemId = 32398,
				name = "simple cloth"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 50,
		profession = 7,
		name = "Shadecloth Boots",
		description = "",
		itemId = 32024,
		index = 137,
		experience = 640,
		durability = 3,
		tier = 1,
		clientId = 28592,
		slotName = "cloth boots",
		category = "armors",
		level = {
			single = 9,
			mass = 14
		},
		materials = {
			{
				amount = 1,
				clientId = 28966,
				itemId = 32398,
				name = "simple cloth"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 50,
		profession = 7,
		name = "Hide Armor",
		description = "",
		itemId = 32066,
		index = 138,
		experience = 640,
		durability = 3,
		tier = 1,
		clientId = 28634,
		slotName = "leather armor",
		category = "armors",
		level = {
			single = 3,
			mass = 8
		},
		materials = {
			{
				amount = 1,
				clientId = 35432,
				itemId = 38864,
				name = "Coarse Leather"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 50,
		profession = 7,
		name = "Hide Helmet",
		description = "",
		itemId = 32072,
		index = 139,
		experience = 640,
		durability = 3,
		tier = 1,
		clientId = 28640,
		slotName = "leather helmet",
		category = "armors",
		level = {
			single = 5,
			mass = 10
		},
		materials = {
			{
				amount = 1,
				clientId = 35432,
				itemId = 38864,
				name = "Coarse Leather"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 50,
		profession = 7,
		name = "Hide Legs",
		description = "",
		itemId = 32073,
		index = 140,
		experience = 640,
		durability = 3,
		tier = 1,
		clientId = 28641,
		slotName = "leather legs",
		category = "armors",
		level = {
			single = 7,
			mass = 12
		},
		materials = {
			{
				amount = 1,
				clientId = 35432,
				itemId = 38864,
				name = "Coarse Leather"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 50,
		profession = 7,
		name = "Hide Boots",
		description = "",
		itemId = 32069,
		index = 141,
		experience = 640,
		durability = 3,
		tier = 1,
		clientId = 28637,
		slotName = "leather boots",
		category = "armors",
		level = {
			single = 9,
			mass = 14
		},
		materials = {
			{
				amount = 1,
				clientId = 35432,
				itemId = 38864,
				name = "Coarse Leather"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 100,
		profession = 7,
		name = "Cheap Rug",
		description = "Used in housing upgrades.",
		itemId = 46232,
		index = 142,
		experience = 4800,
		durability = 4,
		tier = -1,
		clientId = 42780,
		slotName = "",
		category = "Housing Craft",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				amount = 5,
				clientId = 28966,
				itemId = 32398,
				name = "simple cloth"
			},
			{
				amount = 3,
				clientId = 35432,
				itemId = 38864,
				name = "Coarse Leather"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 180,
		profession = 7,
		name = "Simple Saddle",
		description = "Together with 'Simple Headgear' can be crafted into a 'Simple Barding'.",
		itemId = 46698,
		index = 143,
		experience = 8000,
		durability = 7,
		tier = -1,
		clientId = 43246,
		slotName = "",
		category = "Moa Equipment",
		level = {
			single = 12,
			mass = 17
		},
		materials = {
			{
				amount = 4,
				clientId = 28726,
				itemId = 32158,
				name = "copper ingot"
			},
			{
				amount = 10,
				clientId = 35432,
				itemId = 38864,
				name = "Coarse Leather"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 200,
		profession = 7,
		name = "Composed Saddle",
		description = "Together with 'Composed Headgear' can be crafted into a 'Composed Barding'.",
		itemId = 46699,
		index = 144,
		experience = 13000,
		durability = 7,
		tier = -1,
		clientId = 43247,
		slotName = "",
		category = "Moa Equipment",
		level = {
			single = 24,
			mass = 29
		},
		materials = {
			{
				amount = 8,
				clientId = 28723,
				itemId = 32155,
				name = "iron ingot"
			},
			{
				amount = 11,
				clientId = 35432,
				itemId = 38864,
				name = "Coarse Leather"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 350,
		profession = 7,
		name = "Advanced Saddle",
		description = "Together with 'Advanced Headgear' can be crafted into a 'Advanced Barding'.",
		itemId = 46700,
		index = 145,
		experience = 32000,
		durability = 7,
		tier = -1,
		clientId = 43248,
		slotName = "",
		category = "Moa Equipment",
		level = {
			single = 36,
			mass = 41
		},
		materials = {
			{
				amount = 10,
				clientId = 28723,
				itemId = 32155,
				name = "iron ingot"
			},
			{
				amount = 20,
				clientId = 35433,
				itemId = 38865,
				name = "Craftman's Leather"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Artisan Saddle",
		description = "Together with 'Artisan Headgear' can be crafted into a 'Artisan Barding'.",
		itemId = 46701,
		index = 146,
		experience = 60000,
		durability = 8,
		tier = -1,
		clientId = 43249,
		slotName = "",
		category = "Moa Equipment",
		level = {
			single = 48,
			mass = 53
		},
		materials = {
			{
				amount = 12,
				clientId = 28724,
				itemId = 32156,
				name = "steel ingot"
			},
			{
				amount = 25,
				clientId = 35434,
				itemId = 38866,
				name = "Tanned Leather"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 650,
		profession = 7,
		name = "Superior Saddle",
		description = "Together with 'Superior Headgear' can be crafted into a 'Superior Barding'.",
		itemId = 46702,
		index = 147,
		experience = 77500,
		durability = 9,
		tier = -1,
		clientId = 43250,
		slotName = "",
		category = "Moa Equipment",
		level = {
			single = 60,
			mass = 65
		},
		materials = {
			{
				amount = 15,
				clientId = 28725,
				itemId = 32157,
				name = "cobalt ingot"
			},
			{
				amount = 22,
				clientId = 35435,
				itemId = 38867,
				name = "Merchant's Leather"
			}
		}
	},
	{
		specialization = "Patchworker",
		amount = 1,
		profession = 7,
		name = "War Saddle",
		description = "Together with 'War Headgear' can be crafted into a 'War Barding'.",
		tier = -1,
		slotName = "",
		quality = 0,
		progress = 750,
		itemId = 46703,
		index = 148,
		experience = 220000,
		durability = 12,
		clientId = 43251,
		category = "Moa Equipment",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				amount = 12,
				clientId = 28727,
				itemId = 32159,
				name = "titanium ingot"
			},
			{
				amount = 22,
				clientId = 35436,
				itemId = 38868,
				name = "Artisan Leather"
			},
			{
				amount = 10,
				clientId = 28951,
				itemId = 32383,
				name = "ruby"
			}
		}
	},
	{
		specialization = "Patchworker",
		amount = 1,
		profession = 7,
		name = "Explorer Saddle",
		description = "Together with 'Explorer Headgear' can be crafted into a 'Explorer Barding'.",
		tier = -1,
		slotName = "",
		quality = 0,
		progress = 750,
		itemId = 46704,
		index = 149,
		experience = 220000,
		durability = 12,
		clientId = 43252,
		category = "Moa Equipment",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				amount = 12,
				clientId = 28727,
				itemId = 32159,
				name = "titanium ingot"
			},
			{
				amount = 22,
				clientId = 35436,
				itemId = 38868,
				name = "Artisan Leather"
			},
			{
				amount = 10,
				clientId = 28952,
				itemId = 32384,
				name = "sapphire"
			}
		}
	},
	{
		specialization = "Patchworker",
		amount = 1,
		profession = 7,
		name = "Professional Saddle",
		description = "Together with 'Professional Headgear' can be crafted into a 'Professional Barding'.",
		tier = -1,
		slotName = "",
		quality = 0,
		progress = 750,
		itemId = 46705,
		index = 150,
		experience = 220000,
		durability = 12,
		clientId = 43253,
		category = "Moa Equipment",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				amount = 12,
				clientId = 28727,
				itemId = 32159,
				name = "titanium ingot"
			},
			{
				amount = 22,
				clientId = 35436,
				itemId = 38868,
				name = "Artisan Leather"
			},
			{
				amount = 10,
				clientId = 28953,
				itemId = 32385,
				name = "topaz"
			}
		}
	},
	{
		amount = 1,
		quality = 100,
		progress = 150,
		profession = 7,
		name = "Buoyant Plume",
		description = "Required for certain crafting recipes.",
		itemId = 51495,
		index = 151,
		experience = 2500,
		durability = 6,
		tier = -1,
		clientId = 48042,
		slotName = "",
		category = "Ingredient",
		level = {
			single = 16,
			mass = 21
		},
		materials = {
			{
				amount = 8,
				clientId = 35354,
				itemId = 38786,
				name = "Feather"
			}
		}
	},
	{
		amount = 50,
		profession = 7,
		name = "Flappy Lure",
		formatDescription = "quality",
		description = "Increases the weight of the next fish caught on your line by {30}%.",
		tier = -1,
		slotName = "",
		quality = 125,
		progress = 150,
		itemId = 51476,
		index = 152,
		experience = 4395,
		durability = 6,
		clientId = 48023,
		category = "fishing bait",
		level = {
			single = 17,
			mass = 22
		},
		materials = {
			{
				amount = 1,
				clientId = 48042,
				itemId = 51495,
				name = "Buoyant Plume"
			},
			{
				amount = 1,
				clientId = 47960,
				itemId = 51413,
				name = "Collagen"
			}
		}
	},
	{
		amount = 50,
		profession = 7,
		name = "Leafy Drifter",
		formatDescription = "quality",
		description = "Increases the weight of the next fish caught on your line by {50}%.",
		tier = -1,
		slotName = "",
		quality = 200,
		progress = 225,
		itemId = 51406,
		index = 153,
		experience = 8031,
		durability = 7,
		clientId = 47953,
		category = "fishing bait",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				amount = 2,
				clientId = 48042,
				itemId = 51495,
				name = "Buoyant Plume"
			},
			{
				amount = 1,
				clientId = 47960,
				itemId = 51413,
				name = "Collagen"
			},
			{
				amount = 1,
				clientId = 35354,
				itemId = 38786,
				name = "Feather"
			}
		}
	},
	{
		amount = 50,
		profession = 7,
		name = "Verdant Buoy",
		formatDescription = "quality",
		description = "Increases the weight of the next fish caught on your line by {70}%.",
		tier = -1,
		slotName = "",
		quality = 425,
		progress = 450,
		itemId = 51408,
		index = 154,
		experience = 11583,
		durability = 8,
		clientId = 47955,
		category = "fishing bait",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				amount = 3,
				clientId = 48042,
				itemId = 51495,
				name = "Buoyant Plume"
			},
			{
				amount = 1,
				clientId = 47960,
				itemId = 51413,
				name = "Collagen"
			},
			{
				amount = 3,
				clientId = 35354,
				itemId = 38786,
				name = "Feather"
			}
		}
	},
	{
		amount = 50,
		profession = 7,
		name = "Ruby Charmer",
		formatDescription = "quality",
		description = "Increases the weight of the next fish caught on your line by {90}%.",
		tier = -1,
		slotName = "",
		quality = 600,
		progress = 650,
		itemId = 51410,
		index = 155,
		experience = 15750,
		durability = 9,
		clientId = 47957,
		category = "fishing bait",
		level = {
			single = 68,
			mass = 73
		},
		materials = {
			{
				amount = 4,
				clientId = 48042,
				itemId = 51495,
				name = "Buoyant Plume"
			},
			{
				amount = 1,
				clientId = 47960,
				itemId = 51413,
				name = "Collagen"
			},
			{
				amount = 4,
				clientId = 35354,
				itemId = 38786,
				name = "Feather"
			}
		}
	},
	{
		amount = 1,
		quality = 610,
		progress = 610,
		profession = 7,
		name = "glimmery leather",
		description = "Used in various recipes.",
		itemId = 51976,
		index = 156,
		experience = 3850,
		durability = 10,
		tier = -1,
		clientId = 48523,
		slotName = "",
		category = "leather",
		level = {
			single = 88,
			mass = 93
		},
		materials = {
			{
				amount = 3,
				clientId = 35436,
				itemId = 38868,
				name = "Artisan Leather"
			},
			{
				amount = 1,
				clientId = 35435,
				itemId = 38867,
				name = "Merchant's Leather"
			},
			{
				amount = 1,
				clientId = 48510,
				itemId = 51963,
				name = "Binding Aether"
			}
		}
	},
	{
		amount = 1,
		quality = 610,
		progress = 610,
		profession = 7,
		name = "glimmery cloth",
		description = "Used in various recipes.",
		itemId = 51974,
		index = 157,
		experience = 3850,
		durability = 10,
		tier = -1,
		clientId = 48521,
		slotName = "",
		category = "cloth",
		level = {
			single = 88,
			mass = 93
		},
		materials = {
			{
				amount = 3,
				clientId = 28962,
				itemId = 32394,
				name = "artisan cloth"
			},
			{
				amount = 1,
				clientId = 28964,
				itemId = 32396,
				name = "merchant's cloth"
			},
			{
				amount = 1,
				clientId = 48510,
				itemId = 51963,
				name = "Binding Aether"
			}
		}
	},
	{
		amount = 1,
		quality = 610,
		progress = 610,
		profession = 7,
		name = "glimmery thread",
		description = "Used in various recipes.",
		itemId = 51978,
		index = 158,
		experience = 3850,
		durability = 10,
		tier = -1,
		clientId = 48525,
		slotName = "",
		category = "threads",
		level = {
			single = 88,
			mass = 93
		},
		materials = {
			{
				amount = 3,
				clientId = 28970,
				itemId = 32402,
				name = "artisan thread"
			},
			{
				amount = 1,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 48510,
				itemId = 51963,
				name = "Binding Aether"
			}
		}
	},
	{
		specialization = "Tailor",
		amount = 1,
		profession = 7,
		name = "Ethereal Armor",
		description = "",
		tier = 7,
		slotName = "cloth armor",
		quality = 100,
		progress = 870,
		itemId = 51979,
		index = 159,
		experience = 42350,
		durability = 15,
		clientId = 48526,
		category = "armors",
		level = {
			single = 93,
			mass = 98
		},
		materials = {
			{
				amount = 7,
				clientId = 48521,
				itemId = 51974,
				name = "glimmery cloth"
			},
			{
				amount = 4,
				clientId = 48525,
				itemId = 51978,
				name = "glimmery thread"
			},
			{
				amount = 1,
				clientId = 37126,
				itemId = 40578,
				name = "Warlock Armor"
			}
		}
	},
	{
		specialization = "Tailor",
		amount = 1,
		profession = 7,
		name = "Ethereal Helmet",
		description = "",
		tier = 7,
		slotName = "cloth helmet",
		quality = 100,
		progress = 870,
		itemId = 51981,
		index = 160,
		experience = 42350,
		durability = 15,
		clientId = 48528,
		category = "armors",
		level = {
			single = 96,
			mass = 101
		},
		materials = {
			{
				amount = 7,
				clientId = 48521,
				itemId = 51974,
				name = "glimmery cloth"
			},
			{
				amount = 4,
				clientId = 48525,
				itemId = 51978,
				name = "glimmery thread"
			},
			{
				amount = 1,
				clientId = 37132,
				itemId = 40584,
				name = "Warlock Helmet"
			}
		}
	},
	{
		specialization = "Tailor",
		amount = 1,
		profession = 7,
		name = "Ethereal Legs",
		description = "",
		tier = 7,
		slotName = "cloth legs",
		quality = 100,
		progress = 870,
		itemId = 51982,
		index = 161,
		experience = 42350,
		durability = 15,
		clientId = 48529,
		category = "armors",
		level = {
			single = 99,
			mass = 104
		},
		materials = {
			{
				amount = 4,
				clientId = 48521,
				itemId = 51974,
				name = "glimmery cloth"
			},
			{
				amount = 7,
				clientId = 48525,
				itemId = 51978,
				name = "glimmery thread"
			},
			{
				amount = 1,
				clientId = 37133,
				itemId = 40585,
				name = "Warlock Legs"
			}
		}
	},
	{
		specialization = "Tailor",
		amount = 1,
		profession = 7,
		name = "Ethereal Boots",
		description = "",
		tier = 7,
		slotName = "cloth boots",
		quality = 100,
		progress = 870,
		itemId = 51980,
		index = 162,
		experience = 42350,
		durability = 15,
		clientId = 48527,
		category = "armors",
		level = {
			single = 102,
			mass = 107
		},
		materials = {
			{
				amount = 4,
				clientId = 48521,
				itemId = 51974,
				name = "glimmery cloth"
			},
			{
				amount = 7,
				clientId = 48525,
				itemId = 51978,
				name = "glimmery thread"
			},
			{
				amount = 1,
				clientId = 37147,
				itemId = 40599,
				name = "Warlock Boots"
			}
		}
	},
	{
		specialization = "Patchworker",
		amount = 1,
		profession = 7,
		name = "Inquisitor Armor",
		description = "",
		tier = 7,
		slotName = "leather armor",
		quality = 100,
		progress = 870,
		itemId = 51987,
		index = 163,
		experience = 42350,
		durability = 15,
		clientId = 48534,
		category = "armors",
		level = {
			single = 93,
			mass = 98
		},
		materials = {
			{
				amount = 7,
				clientId = 48523,
				itemId = 51976,
				name = "glimmery leather"
			},
			{
				amount = 4,
				clientId = 48525,
				itemId = 51978,
				name = "glimmery thread"
			},
			{
				amount = 1,
				clientId = 37139,
				itemId = 40591,
				name = "Guerrila Armor"
			}
		}
	},
	{
		specialization = "Patchworker",
		amount = 1,
		profession = 7,
		name = "Inquisitor Helmet",
		description = "",
		tier = 7,
		slotName = "leather helmet",
		quality = 100,
		progress = 870,
		itemId = 51989,
		index = 164,
		experience = 42350,
		durability = 15,
		clientId = 48536,
		category = "armors",
		level = {
			single = 96,
			mass = 101
		},
		materials = {
			{
				amount = 7,
				clientId = 48523,
				itemId = 51976,
				name = "glimmery leather"
			},
			{
				amount = 4,
				clientId = 48525,
				itemId = 51978,
				name = "glimmery thread"
			},
			{
				amount = 1,
				clientId = 37141,
				itemId = 40593,
				name = "Guerrila Helmet"
			}
		}
	},
	{
		specialization = "Patchworker",
		amount = 1,
		profession = 7,
		name = "Inquisitor Legs",
		description = "",
		tier = 7,
		slotName = "leather legs",
		quality = 100,
		progress = 870,
		itemId = 51990,
		index = 165,
		experience = 42350,
		durability = 15,
		clientId = 48537,
		category = "armors",
		level = {
			single = 99,
			mass = 104
		},
		materials = {
			{
				amount = 4,
				clientId = 48523,
				itemId = 51976,
				name = "glimmery leather"
			},
			{
				amount = 7,
				clientId = 48525,
				itemId = 51978,
				name = "glimmery thread"
			},
			{
				amount = 1,
				clientId = 37142,
				itemId = 40594,
				name = "Guerrila Legs"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 150,
		profession = 7,
		name = "Herb Mixer Boots",
		description = "",
		itemId = 53041,
		index = 166,
		experience = 9600,
		durability = 6,
		tier = 1,
		clientId = 49588,
		slotName = "crafting boots",
		category = "crafting",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				amount = 3,
				clientId = 28963,
				itemId = 32395,
				name = "craftman's cloth"
			},
			{
				amount = 5,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 150,
		profession = 7,
		name = "Herb Mixer Legs",
		description = "",
		itemId = 53044,
		index = 167,
		experience = 9600,
		durability = 6,
		tier = 1,
		clientId = 49591,
		slotName = "crafting legs",
		category = "crafting",
		level = {
			single = 13,
			mass = 18
		},
		materials = {
			{
				amount = 3,
				clientId = 28963,
				itemId = 32395,
				name = "craftman's cloth"
			},
			{
				amount = 5,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 200,
		profession = 7,
		name = "Herb Mixer Tunic",
		description = "",
		itemId = 53045,
		index = 168,
		experience = 9600,
		durability = 6,
		tier = 1,
		clientId = 49592,
		slotName = "crafting armor",
		category = "crafting",
		level = {
			single = 16,
			mass = 21
		},
		materials = {
			{
				amount = 5,
				clientId = 28963,
				itemId = 32395,
				name = "craftman's cloth"
			},
			{
				amount = 3,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 200,
		profession = 7,
		name = "Herb Mixer Coif",
		description = "",
		itemId = 53043,
		index = 169,
		experience = 9600,
		durability = 6,
		tier = 1,
		clientId = 49590,
		slotName = "crafting helmet",
		category = "crafting",
		level = {
			single = 19,
			mass = 24
		},
		materials = {
			{
				amount = 5,
				clientId = 28963,
				itemId = 32395,
				name = "craftman's cloth"
			},
			{
				amount = 3,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 225,
		profession = 7,
		name = "Herb Mixer Gloves",
		description = "",
		itemId = 53042,
		index = 170,
		experience = 19200,
		durability = 7,
		tier = 1,
		clientId = 49589,
		slotName = "crafting gloves",
		category = "crafting",
		level = {
			single = 22,
			mass = 27
		},
		materials = {
			{
				amount = 8,
				clientId = 28963,
				itemId = 32395,
				name = "craftman's cloth"
			},
			{
				amount = 8,
				clientId = 28972,
				itemId = 32404,
				name = "craftman's thread"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 250,
		profession = 7,
		name = "Alchemy Adept Boots",
		description = "",
		itemId = 53046,
		index = 171,
		experience = 19200,
		durability = 7,
		tier = 2,
		clientId = 49593,
		slotName = "crafting boots",
		category = "crafting",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				amount = 3,
				clientId = 28965,
				itemId = 32397,
				name = "silk"
			},
			{
				amount = 8,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 49588,
				itemId = 53041,
				name = "Herb Mixer Boots"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 250,
		profession = 7,
		name = "Alchemy Adept Legs",
		description = "",
		itemId = 53049,
		index = 172,
		experience = 19200,
		durability = 7,
		tier = 2,
		clientId = 49596,
		slotName = "crafting legs",
		category = "crafting",
		level = {
			single = 33,
			mass = 38
		},
		materials = {
			{
				amount = 3,
				clientId = 28965,
				itemId = 32397,
				name = "silk"
			},
			{
				amount = 8,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 49591,
				itemId = 53044,
				name = "Herb Mixer Legs"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 350,
		profession = 7,
		name = "Alchemy Adept Tunic",
		description = "",
		itemId = 53050,
		index = 173,
		experience = 19200,
		durability = 7,
		tier = 2,
		clientId = 49597,
		slotName = "crafting armor",
		category = "crafting",
		level = {
			single = 36,
			mass = 41
		},
		materials = {
			{
				amount = 8,
				clientId = 28965,
				itemId = 32397,
				name = "silk"
			},
			{
				amount = 3,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 49592,
				itemId = 53045,
				name = "Herb Mixer Tunic"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 350,
		profession = 7,
		name = "Alchemy Adept Coif",
		description = "",
		itemId = 53048,
		index = 174,
		experience = 19200,
		durability = 7,
		tier = 2,
		clientId = 49595,
		slotName = "crafting helmet",
		category = "crafting",
		level = {
			single = 39,
			mass = 44
		},
		materials = {
			{
				amount = 8,
				clientId = 28965,
				itemId = 32397,
				name = "silk"
			},
			{
				amount = 3,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 49590,
				itemId = 53043,
				name = "Herb Mixer Coif"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 350,
		profession = 7,
		name = "Alchemy Adept Gloves",
		description = "",
		itemId = 53047,
		index = 175,
		experience = 38400,
		durability = 7,
		tier = 2,
		clientId = 49594,
		slotName = "crafting gloves",
		category = "crafting",
		level = {
			single = 42,
			mass = 47
		},
		materials = {
			{
				amount = 12,
				clientId = 28965,
				itemId = 32397,
				name = "silk"
			},
			{
				amount = 9,
				clientId = 28973,
				itemId = 32405,
				name = "fine thread"
			},
			{
				amount = 1,
				clientId = 49589,
				itemId = 53042,
				name = "Herb Mixer Gloves"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Brewmaster Boots",
		description = "",
		itemId = 53051,
		index = 176,
		experience = 38400,
		durability = 8,
		tier = 3,
		clientId = 49598,
		slotName = "crafting boots",
		category = "crafting",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				amount = 4,
				clientId = 28964,
				itemId = 32396,
				name = "merchant's cloth"
			},
			{
				amount = 12,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 49593,
				itemId = 53046,
				name = "Alchemy Adept Boots"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Brewmaster Legs",
		description = "",
		itemId = 53054,
		index = 177,
		experience = 38400,
		durability = 8,
		tier = 3,
		clientId = 49601,
		slotName = "crafting legs",
		category = "crafting",
		level = {
			single = 53,
			mass = 58
		},
		materials = {
			{
				amount = 4,
				clientId = 28964,
				itemId = 32396,
				name = "merchant's cloth"
			},
			{
				amount = 12,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 49596,
				itemId = 53049,
				name = "Alchemy Adept Legs"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Brewmaster Tunic",
		description = "",
		itemId = 53055,
		index = 178,
		experience = 38400,
		durability = 9,
		tier = 3,
		clientId = 49602,
		slotName = "crafting armor",
		category = "crafting",
		level = {
			single = 56,
			mass = 61
		},
		materials = {
			{
				amount = 12,
				clientId = 28964,
				itemId = 32396,
				name = "merchant's cloth"
			},
			{
				amount = 4,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 49597,
				itemId = 53050,
				name = "Alchemy Adept Tunic"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Brewmaster Coif",
		description = "",
		itemId = 53053,
		index = 179,
		experience = 38400,
		durability = 9,
		tier = 3,
		clientId = 49600,
		slotName = "crafting helmet",
		category = "crafting",
		level = {
			single = 59,
			mass = 64
		},
		materials = {
			{
				amount = 12,
				clientId = 28964,
				itemId = 32396,
				name = "merchant's cloth"
			},
			{
				amount = 4,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 49595,
				itemId = 53048,
				name = "Alchemy Adept Coif"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 525,
		profession = 7,
		name = "Brewmaster Gloves",
		description = "",
		itemId = 53052,
		index = 180,
		experience = 76800,
		durability = 9,
		tier = 3,
		clientId = 49599,
		slotName = "crafting gloves",
		category = "crafting",
		level = {
			single = 62,
			mass = 67
		},
		materials = {
			{
				amount = 16,
				clientId = 28964,
				itemId = 32396,
				name = "merchant's cloth"
			},
			{
				amount = 16,
				clientId = 28969,
				itemId = 32401,
				name = "merchant's thread"
			},
			{
				amount = 1,
				clientId = 49594,
				itemId = 53047,
				name = "Alchemy Adept Gloves"
			}
		}
	},
	{
		amount = 1,
		quality = 0,
		progress = 550,
		profession = 7,
		name = "Refined Covering",
		description = "Used in housing upgrades. An iridescent fabric, bestowing a sense of royalty upon any room adorned with it.",
		itemId = 53264,
		index = 181,
		experience = 101750,
		durability = 9,
		tier = -1,
		clientId = 49811,
		slotName = "",
		category = "Housing Craft",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				amount = 15,
				clientId = 28970,
				itemId = 32402,
				name = "artisan thread"
			},
			{
				amount = 14,
				clientId = 49799,
				itemId = 53252,
				name = "Gemstone Dust"
			}
		}
	},
	{
		specialization = "Patchworker",
		amount = 1,
		profession = 7,
		name = "Inquisitor Boots",
		description = "",
		tier = 7,
		slotName = "leather boots",
		quality = 100,
		progress = 870,
		itemId = 51988,
		index = 182,
		experience = 42350,
		durability = 15,
		clientId = 48535,
		category = "armors",
		level = {
			single = 102,
			mass = 107
		},
		materials = {
			{
				amount = 4,
				clientId = 48523,
				itemId = 51976,
				name = "glimmery leather"
			},
			{
				amount = 7,
				clientId = 48525,
				itemId = 51978,
				name = "glimmery thread"
			},
			{
				amount = 1,
				clientId = 37140,
				itemId = 40592,
				name = "Guerrila Boots"
			}
		}
	}
}
questRecipes = questRecipes or {}
questRecipes[ProfessionWeaving] = {
	{
		amount = 1,
		quality = 50,
		progress = 50,
		profession = 7,
		name = "Shadecloth Armor",
		description = "",
		itemId = 32021,
		index = 1,
		experience = 0,
		durability = 3,
		tier = 1,
		clientId = 28589,
		slotName = "cloth armor",
		category = "quest",
		level = {
			single = 1
		},
		materials = {
			{
				amount = 1,
				clientId = 28966,
				itemId = 38881,
				name = "Simple Cloth"
			},
			{
				amount = 1,
				clientId = 28971,
				itemId = 38880,
				name = "Coarse Thread"
			}
		}
	},
	{
		amount = 1,
		quality = 50,
		progress = 50,
		profession = 7,
		name = "Shadecloth Helmet",
		description = "",
		itemId = 32027,
		index = 2,
		experience = 0,
		durability = 3,
		tier = 1,
		clientId = 28595,
		slotName = "cloth helmet",
		category = "quest",
		level = {
			single = 1
		},
		materials = {
			{
				amount = 1,
				clientId = 28966,
				itemId = 38885,
				name = "Simple Cloth"
			},
			{
				amount = 1,
				clientId = 28971,
				itemId = 38884,
				name = "Coarse Thread"
			}
		}
	},
	{
		amount = 1,
		quality = 50,
		progress = 50,
		profession = 7,
		name = "Shadecloth Legs",
		description = "",
		itemId = 32028,
		index = 3,
		experience = 0,
		durability = 3,
		tier = 1,
		clientId = 28596,
		slotName = "cloth legs",
		category = "quest",
		level = {
			single = 1
		},
		materials = {
			{
				amount = 1,
				clientId = 28966,
				itemId = 38889,
				name = "Simple Cloth"
			},
			{
				amount = 1,
				clientId = 28971,
				itemId = 38888,
				name = "Coarse Thread"
			}
		}
	},
	{
		amount = 1,
		quality = 50,
		progress = 50,
		profession = 7,
		name = "Shadecloth Boots",
		description = "",
		itemId = 32024,
		index = 4,
		experience = 0,
		durability = 3,
		tier = 1,
		clientId = 28592,
		slotName = "cloth boots",
		category = "quest",
		level = {
			single = 1
		},
		materials = {
			{
				amount = 1,
				clientId = 28966,
				itemId = 38893,
				name = "Simple Cloth"
			},
			{
				amount = 1,
				clientId = 28971,
				itemId = 38892,
				name = "Coarse Thread"
			}
		}
	},
	{
		amount = 1,
		quality = 50,
		progress = 50,
		profession = 7,
		name = "Hide Armor",
		description = "",
		itemId = 32066,
		index = 5,
		experience = 0,
		durability = 3,
		tier = 1,
		clientId = 28634,
		slotName = "leather armor",
		category = "quest",
		level = {
			single = 1
		},
		materials = {
			{
				amount = 1,
				clientId = 35432,
				itemId = 38879,
				name = "Coarse Leather"
			},
			{
				amount = 1,
				clientId = 28971,
				itemId = 38880,
				name = "Coarse Thread"
			}
		}
	},
	{
		amount = 1,
		quality = 50,
		progress = 50,
		profession = 7,
		name = "Hide Helmet",
		description = "",
		itemId = 32072,
		index = 6,
		experience = 0,
		durability = 3,
		tier = 1,
		clientId = 28640,
		slotName = "leather helmet",
		category = "quest",
		level = {
			single = 1
		},
		materials = {
			{
				amount = 1,
				clientId = 35432,
				itemId = 38883,
				name = "Coarse Leather"
			},
			{
				amount = 1,
				clientId = 28971,
				itemId = 38884,
				name = "Coarse Thread"
			}
		}
	},
	{
		amount = 1,
		quality = 50,
		progress = 50,
		profession = 7,
		name = "Hide Legs",
		description = "",
		itemId = 32073,
		index = 7,
		experience = 0,
		durability = 3,
		tier = 1,
		clientId = 28641,
		slotName = "leather legs",
		category = "quest",
		level = {
			single = 1
		},
		materials = {
			{
				amount = 1,
				clientId = 35432,
				itemId = 38887,
				name = "Coarse Leather"
			},
			{
				amount = 1,
				clientId = 28971,
				itemId = 38888,
				name = "Coarse Thread"
			}
		}
	},
	{
		amount = 1,
		quality = 50,
		progress = 50,
		profession = 7,
		name = "Hide Boots",
		description = "",
		itemId = 32069,
		index = 8,
		experience = 0,
		durability = 3,
		tier = 1,
		clientId = 28637,
		slotName = "leather boots",
		category = "quest",
		level = {
			single = 1
		},
		materials = {
			{
				amount = 1,
				clientId = 35432,
				itemId = 38891,
				name = "Coarse Leather"
			},
			{
				amount = 1,
				clientId = 28971,
				itemId = 38892,
				name = "Coarse Thread"
			}
		}
	}
}
