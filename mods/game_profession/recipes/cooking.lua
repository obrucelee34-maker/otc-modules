-- chunkname: @/modules/game_profession/recipes/cooking.lua

recipes = recipes or {}
recipes[ProfessionCooking] = {
	{
		quality = 50,
		durability = 4,
		index = 1,
		formatDescription = "foodquality",
		slotName = "",
		name = "Beer",
		progress = 75,
		profession = 8,
		clientId = 28760,
		itemId = 32192,
		experience = 600,
		amount = 5,
		description = "Channel and restore {50} Health and Mana per second for 15 seconds. Being damaged cancels the effect. 15 seconds cooldown.",
		tier = -1,
		category = "drinks",
		level = {
			single = 5,
			mass = 10
		},
		materials = {
			{
				clientId = 28881,
				name = "wheat",
				itemId = 32313,
				amount = 4
			}
		}
	},
	{
		quality = 125,
		durability = 7,
		index = 2,
		formatDescription = "foodquality",
		slotName = "",
		name = "Wine",
		progress = 200,
		profession = 8,
		clientId = 28882,
		itemId = 32314,
		experience = 1800,
		amount = 5,
		description = "Channel and restore {175} Health and Mana per second for 15 seconds. Being damaged cancels the effect. 15 seconds cooldown.",
		tier = -1,
		category = "drinks",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 28831,
				name = "grape",
				itemId = 32263,
				amount = 4
			},
			{
				clientId = 42107,
				name = "Brewer Yeast",
				itemId = 45559,
				amount = 2
			}
		}
	},
	{
		quality = 140,
		durability = 7,
		index = 3,
		formatDescription = "foodquality",
		slotName = "",
		name = "Whiskey",
		progress = 200,
		profession = 8,
		clientId = 28761,
		itemId = 32193,
		experience = 2000,
		amount = 5,
		description = "Increase Mana Regeneration and Health Regeneration by {12} for 30 minutes.",
		tier = -1,
		category = "drinks",
		level = {
			single = 22,
			mass = 27
		},
		materials = {
			{
				clientId = 28866,
				name = "corn",
				itemId = 32298,
				amount = 6
			},
			{
				clientId = 42107,
				name = "Brewer Yeast",
				itemId = 45559,
				amount = 1
			}
		}
	},
	{
		quality = 50,
		durability = 4,
		index = 4,
		formatDescription = "foodquality",
		slotName = "",
		name = "Vodka",
		progress = 75,
		profession = 8,
		clientId = 28767,
		itemId = 32199,
		experience = 250,
		amount = 5,
		description = "Increase Mana Regeneration and Health Regeneration by {4} for 30 minutes.",
		tier = -1,
		category = "drinks",
		level = {
			single = 1,
			mass = 6
		},
		materials = {
			{
				clientId = 28874,
				name = "potato",
				itemId = 32306,
				amount = 5
			}
		}
	},
	{
		quality = 175,
		durability = 7,
		index = 5,
		formatDescription = "foodquality",
		slotName = "",
		name = "Rum",
		progress = 250,
		profession = 8,
		clientId = 28883,
		itemId = 32315,
		experience = 3750,
		amount = 5,
		description = "Increase Mana Regeneration and Health Regeneration by {20} for 30 minutes.",
		tier = -1,
		category = "drinks",
		level = {
			single = 32,
			mass = 37
		},
		materials = {
			{
				clientId = 28822,
				name = "apple",
				itemId = 32254,
				amount = 3
			},
			{
				clientId = 42107,
				name = "Brewer Yeast",
				itemId = 45559,
				amount = 2
			}
		}
	},
	{
		quality = 125,
		durability = 7,
		index = 6,
		formatDescription = "foodquality",
		slotName = "",
		name = "Bun",
		progress = 200,
		profession = 8,
		clientId = 28754,
		itemId = 32186,
		experience = 1800,
		amount = 5,
		description = "Increase Defense Power by {6} for 30 minutes.",
		tier = -1,
		category = "baked goods",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 33553,
				name = "Ground Flour",
				itemId = 36985,
				amount = 8
			},
			{
				clientId = 42106,
				name = "Basic Seasoning",
				itemId = 45558,
				amount = 1
			},
			{
				clientId = 28929,
				name = "milk",
				itemId = 32361,
				amount = 2
			}
		}
	},
	{
		quality = 140,
		durability = 7,
		index = 7,
		formatDescription = "foodquality",
		slotName = "",
		name = "Scone",
		progress = 200,
		profession = 8,
		clientId = 28759,
		itemId = 32191,
		experience = 2750,
		amount = 5,
		description = "Increase Defense Power by {8} for 30 minutes.",
		tier = -1,
		category = "baked goods",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 33553,
				name = "Ground Flour",
				itemId = 36985,
				amount = 4
			},
			{
				clientId = 28929,
				name = "milk",
				itemId = 32361,
				amount = 5
			},
			{
				clientId = 42106,
				name = "Basic Seasoning",
				itemId = 45558,
				amount = 1
			}
		}
	},
	{
		quality = 175,
		durability = 7,
		index = 8,
		formatDescription = "foodquality",
		slotName = "",
		name = "Muffin",
		progress = 250,
		profession = 8,
		clientId = 28765,
		itemId = 32197,
		experience = 4000,
		amount = 5,
		description = "Increase Defense Power by {12} for 30 minutes.",
		tier = -1,
		category = "baked goods",
		level = {
			single = 35,
			mass = 40
		},
		materials = {
			{
				clientId = 33553,
				name = "Ground Flour",
				itemId = 36985,
				amount = 10
			},
			{
				clientId = 28929,
				name = "milk",
				itemId = 32361,
				amount = 2
			},
			{
				clientId = 44381,
				name = "Honey",
				itemId = 47833,
				amount = 6
			}
		}
	},
	{
		quality = 250,
		durability = 7,
		index = 9,
		formatDescription = "foodquality",
		slotName = "",
		name = "Croissant",
		progress = 375,
		profession = 8,
		clientId = 28756,
		itemId = 32188,
		experience = 6800,
		amount = 5,
		description = "Increase Defense Power by {16} for 30 minutes.",
		tier = -1,
		category = "baked goods",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 42118,
				name = "Rich Flour",
				itemId = 45570,
				amount = 8
			},
			{
				clientId = 42749,
				name = "Butter",
				itemId = 46201,
				amount = 6
			},
			{
				clientId = 44381,
				name = "Honey",
				itemId = 47833,
				amount = 3
			}
		}
	},
	{
		quality = 400,
		durability = 9,
		specialization = "Pastry Expert",
		index = 10,
		formatDescription = "foodquality",
		slotName = "",
		name = "Danish",
		progress = 550,
		profession = 8,
		clientId = 28757,
		itemId = 32189,
		experience = 14500,
		amount = 5,
		description = "Increase Defense Power by {25} for 30 minutes.",
		tier = -1,
		category = "baked goods",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 42118,
				name = "Rich Flour",
				itemId = 45570,
				amount = 16
			},
			{
				clientId = 42749,
				name = "Butter",
				itemId = 46201,
				amount = 10
			},
			{
				clientId = 44381,
				name = "Honey",
				itemId = 47833,
				amount = 8
			},
			{
				clientId = 28827,
				name = "strawberry",
				itemId = 32259,
				amount = 8
			}
		}
	},
	{
		quality = 140,
		durability = 7,
		index = 11,
		formatDescription = "foodquality",
		slotName = "",
		name = "Cookies",
		progress = 200,
		profession = 8,
		clientId = 28766,
		itemId = 32198,
		experience = 2000,
		amount = 5,
		description = "Increase Attack Power by {6} for 30 minutes.",
		tier = -1,
		category = "baked goods",
		level = {
			single = 22,
			mass = 27
		},
		materials = {
			{
				clientId = 33553,
				name = "Ground Flour",
				itemId = 36985,
				amount = 8
			},
			{
				clientId = 42106,
				name = "Basic Seasoning",
				itemId = 45558,
				amount = 1
			},
			{
				clientId = 42749,
				name = "Butter",
				itemId = 46201,
				amount = 2
			}
		}
	},
	{
		quality = 150,
		durability = 7,
		index = 12,
		formatDescription = "foodquality",
		slotName = "",
		name = "Deluxe Cookies",
		progress = 225,
		profession = 8,
		clientId = 28764,
		itemId = 32196,
		experience = 3100,
		amount = 5,
		description = "Increase Attack Power by {8} for 30 minutes.",
		tier = -1,
		category = "baked goods",
		level = {
			single = 27,
			mass = 32
		},
		materials = {
			{
				clientId = 33553,
				name = "Ground Flour",
				itemId = 36985,
				amount = 12
			},
			{
				clientId = 42749,
				name = "Butter",
				itemId = 46201,
				amount = 2
			},
			{
				clientId = 33551,
				name = "salt",
				itemId = 36983,
				amount = 1
			}
		}
	},
	{
		quality = 200,
		durability = 7,
		index = 13,
		formatDescription = "foodquality",
		slotName = "",
		name = "Cake",
		progress = 300,
		profession = 8,
		clientId = 28755,
		itemId = 32187,
		experience = 4450,
		amount = 5,
		description = "Increase Attack Power by {12} for 30 minutes.",
		tier = -1,
		category = "baked goods",
		level = {
			single = 37,
			mass = 42
		},
		materials = {
			{
				clientId = 33553,
				name = "Ground Flour",
				itemId = 36985,
				amount = 14
			},
			{
				clientId = 28929,
				name = "milk",
				itemId = 32361,
				amount = 5
			},
			{
				clientId = 28928,
				name = "egg",
				itemId = 32360,
				amount = 4
			}
		}
	},
	{
		quality = 325,
		durability = 8,
		index = 14,
		formatDescription = "foodquality",
		slotName = "",
		name = "Deluxe Cake",
		progress = 450,
		profession = 8,
		clientId = 28758,
		itemId = 32190,
		experience = 7400,
		amount = 5,
		description = "Increase Attack Power by {16} for 30 minutes.",
		tier = -1,
		category = "baked goods",
		level = {
			single = 52,
			mass = 57
		},
		materials = {
			{
				clientId = 42118,
				name = "Rich Flour",
				itemId = 45570,
				amount = 15
			},
			{
				clientId = 28929,
				name = "milk",
				itemId = 32361,
				amount = 4
			},
			{
				clientId = 28928,
				name = "egg",
				itemId = 32360,
				amount = 4
			},
			{
				clientId = 44381,
				name = "Honey",
				itemId = 47833,
				amount = 1
			}
		}
	},
	{
		quality = 450,
		durability = 10,
		specialization = "Pastry Expert",
		index = 15,
		formatDescription = "foodquality",
		slotName = "",
		name = "Pie",
		progress = 600,
		profession = 8,
		clientId = 28753,
		itemId = 32185,
		experience = 16500,
		amount = 5,
		description = "Increase Attack Power by {25} for 30 minutes.",
		tier = -1,
		category = "baked goods",
		level = {
			single = 72,
			mass = 77
		},
		materials = {
			{
				clientId = 42118,
				name = "Rich Flour",
				itemId = 45570,
				amount = 12
			},
			{
				clientId = 42749,
				name = "Butter",
				itemId = 46201,
				amount = 12
			},
			{
				clientId = 28928,
				name = "egg",
				itemId = 32360,
				amount = 2
			},
			{
				clientId = 28824,
				name = "sunberry",
				itemId = 32256,
				amount = 10
			}
		}
	},
	{
		quality = 200,
		durability = 7,
		index = 16,
		formatDescription = "foodquality",
		slotName = "",
		name = "Settler's Stew",
		progress = 300,
		profession = 8,
		clientId = 34866,
		itemId = 38298,
		experience = 4450,
		amount = 5,
		description = "Increase Intelligence by {20} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 37,
			mass = 42
		},
		materials = {
			{
				clientId = 28874,
				name = "potato",
				itemId = 32306,
				amount = 14
			},
			{
				clientId = 28878,
				name = "bean",
				itemId = 32310,
				amount = 20
			},
			{
				clientId = 42106,
				name = "Basic Seasoning",
				itemId = 45558,
				amount = 4
			}
		}
	},
	{
		quality = 400,
		durability = 9,
		index = 17,
		formatDescription = "foodquality",
		slotName = "",
		name = "Sailor's Seastew",
		progress = 550,
		profession = 8,
		clientId = 34865,
		itemId = 38297,
		experience = 13000,
		amount = 5,
		description = "Increase Wisdom by {40} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 69,
			mass = 74
		},
		materials = {
			{
				clientId = 40825,
				name = "Black Fish Roe",
				itemId = 44277,
				amount = 10
			},
			{
				clientId = 28863,
				name = "brocolli",
				itemId = 32295,
				amount = 10
			},
			{
				clientId = 28871,
				name = "pea",
				itemId = 32303,
				amount = 16
			}
		}
	},
	{
		quality = 140,
		durability = 7,
		index = 18,
		formatDescription = "foodquality",
		slotName = "",
		name = "Roasted Chicken and Veggies",
		progress = 200,
		profession = 8,
		clientId = 34861,
		itemId = 38293,
		experience = 2350,
		amount = 5,
		description = "Increase Dexterity by {10} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 23,
			mass = 28
		},
		materials = {
			{
				clientId = 28750,
				name = "chicken",
				itemId = 32182,
				amount = 1
			},
			{
				clientId = 28865,
				name = "carrot",
				itemId = 32297,
				amount = 1
			},
			{
				clientId = 28927,
				name = "cheese",
				itemId = 32359,
				amount = 1
			}
		}
	},
	{
		quality = 400,
		durability = 9,
		index = 19,
		formatDescription = "foodquality",
		slotName = "",
		name = "Firered Chicken Kebab",
		progress = 550,
		profession = 8,
		clientId = 34857,
		itemId = 38289,
		experience = 11000,
		amount = 5,
		description = "Increase Might by {40} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 66,
			mass = 71
		},
		materials = {
			{
				clientId = 28750,
				name = "chicken",
				itemId = 32182,
				amount = 8
			},
			{
				clientId = 28869,
				name = "garlic",
				itemId = 32301,
				amount = 2
			},
			{
				clientId = 28832,
				name = "orange",
				itemId = 32264,
				amount = 1
			},
			{
				clientId = 42126,
				name = "Spicy Seasoning",
				itemId = 45578,
				amount = 1
			}
		}
	},
	{
		quality = 140,
		durability = 7,
		index = 20,
		formatDescription = "foodquality",
		slotName = "",
		name = "Charred Meat Kebab",
		progress = 200,
		profession = 8,
		clientId = 34849,
		itemId = 38281,
		experience = 2000,
		amount = 5,
		description = "Increase Intelligence by {10} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 22,
			mass = 27
		},
		materials = {
			{
				clientId = 28931,
				name = "beef",
				itemId = 32363,
				amount = 2
			},
			{
				clientId = 28865,
				name = "carrot",
				itemId = 32297,
				amount = 3
			},
			{
				clientId = 28864,
				name = "cabbage",
				itemId = 32296,
				amount = 1
			}
		}
	},
	{
		quality = 400,
		durability = 9,
		index = 21,
		formatDescription = "foodquality",
		slotName = "",
		name = "Lyderian Chopped Tenderloin",
		progress = 550,
		profession = 8,
		clientId = 34859,
		itemId = 38291,
		experience = 11500,
		amount = 5,
		description = "Increase Intelligence by {40} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 67,
			mass = 72
		},
		materials = {
			{
				clientId = 28931,
				name = "beef",
				itemId = 32363,
				amount = 8
			},
			{
				clientId = 28869,
				name = "garlic",
				itemId = 32301,
				amount = 8
			},
			{
				clientId = 42126,
				name = "Spicy Seasoning",
				itemId = 45578,
				amount = 2
			}
		}
	},
	{
		quality = 125,
		durability = 7,
		index = 22,
		formatDescription = "foodquality",
		slotName = "",
		name = "Smoked Sausage",
		progress = 200,
		profession = 8,
		clientId = 34869,
		itemId = 38301,
		experience = 1850,
		amount = 5,
		description = "Increase Might by {10} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 21,
			mass = 26
		},
		materials = {
			{
				clientId = 28932,
				name = "shank",
				itemId = 32364,
				amount = 1
			},
			{
				clientId = 42106,
				name = "Basic Seasoning",
				itemId = 45558,
				amount = 3
			},
			{
				clientId = 28874,
				name = "potato",
				itemId = 32306,
				amount = 4
			},
			{
				clientId = 28872,
				name = "pepper",
				itemId = 32304,
				amount = 2
			}
		}
	},
	{
		quality = 350,
		durability = 9,
		index = 23,
		formatDescription = "foodquality",
		slotName = "",
		name = "Acornchar Sausage",
		progress = 500,
		profession = 8,
		clientId = 34847,
		itemId = 38279,
		experience = 7650,
		amount = 5,
		description = "Increase Dexterity by {30} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 53,
			mass = 58
		},
		materials = {
			{
				clientId = 28932,
				name = "shank",
				itemId = 32364,
				amount = 5
			},
			{
				clientId = 42112,
				name = "Gourmet Seasoning",
				itemId = 45564,
				amount = 4
			},
			{
				clientId = 28829,
				name = "acorn",
				itemId = 32261,
				amount = 1
			}
		}
	},
	{
		quality = 175,
		durability = 7,
		index = 24,
		formatDescription = "foodquality",
		slotName = "",
		name = "Rum Downslider",
		progress = 250,
		profession = 8,
		clientId = 34864,
		itemId = 38296,
		experience = 4000,
		amount = 5,
		description = "Increase Vitality by {20} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 35,
			mass = 40
		},
		materials = {
			{
				clientId = 40829,
				name = "Fish Roe",
				itemId = 44281,
				amount = 10
			},
			{
				clientId = 28864,
				name = "cabbage",
				itemId = 32296,
				amount = 4
			},
			{
				clientId = 42123,
				name = "Seafood Seasoning",
				itemId = 45575,
				amount = 5
			}
		}
	},
	{
		quality = 400,
		durability = 9,
		index = 25,
		formatDescription = "foodquality",
		slotName = "",
		name = "Freshfish Roll",
		progress = 550,
		profession = 8,
		clientId = 34853,
		itemId = 38285,
		experience = 7800,
		amount = 5,
		description = "Increase Wisdom by {30} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 54,
			mass = 59
		},
		materials = {
			{
				clientId = 40833,
				name = "Red Fish Roe",
				itemId = 44285,
				amount = 14
			},
			{
				clientId = 28927,
				name = "cheese",
				itemId = 32359,
				amount = 2
			},
			{
				clientId = 42112,
				name = "Gourmet Seasoning",
				itemId = 45564,
				amount = 2
			}
		}
	},
	{
		quality = 225,
		durability = 7,
		index = 26,
		formatDescription = "foodquality",
		slotName = "",
		name = "Fillet Lucien",
		progress = 350,
		profession = 8,
		clientId = 34852,
		itemId = 38284,
		experience = 5000,
		amount = 5,
		description = "Increase Wisdom by {20} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 39,
			mass = 44
		},
		materials = {
			{
				clientId = 28931,
				name = "beef",
				itemId = 32363,
				amount = 5
			},
			{
				clientId = 33553,
				name = "Ground Flour",
				itemId = 36985,
				amount = 3
			},
			{
				clientId = 28928,
				name = "egg",
				itemId = 32360,
				amount = 1
			},
			{
				clientId = 28875,
				name = "pumpkin",
				itemId = 32307,
				amount = 1
			}
		}
	},
	{
		quality = 400,
		durability = 9,
		index = 27,
		formatDescription = "foodquality",
		slotName = "",
		name = "Rohna Roasted Ham",
		progress = 550,
		profession = 8,
		clientId = 34862,
		itemId = 38294,
		experience = 12500,
		amount = 5,
		description = "Increase Dexterity by {40} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 68,
			mass = 73
		},
		materials = {
			{
				clientId = 28932,
				name = "shank",
				itemId = 32364,
				amount = 10
			},
			{
				clientId = 42126,
				name = "Spicy Seasoning",
				itemId = 45578,
				amount = 2
			},
			{
				clientId = 28870,
				name = "onion",
				itemId = 32302,
				amount = 5
			}
		}
	},
	{
		quality = 140,
		durability = 7,
		index = 28,
		formatDescription = "foodquality",
		slotName = "",
		name = "Ravendawnian Porridge",
		progress = 200,
		profession = 8,
		clientId = 34860,
		itemId = 38292,
		experience = 2500,
		amount = 5,
		description = "Increase Wisdom by {10} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 24,
			mass = 29
		},
		materials = {
			{
				clientId = 28881,
				name = "wheat",
				itemId = 32313,
				amount = 5
			},
			{
				clientId = 28822,
				name = "apple",
				itemId = 32254,
				amount = 1
			},
			{
				clientId = 28929,
				name = "milk",
				itemId = 32361,
				amount = 2
			}
		}
	},
	{
		quality = 400,
		durability = 9,
		index = 29,
		formatDescription = "foodquality",
		slotName = "",
		name = "Sweetened Beans",
		progress = 550,
		profession = 8,
		clientId = 34870,
		itemId = 38302,
		experience = 10000,
		amount = 5,
		description = "Increase Vitality by {40} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 65,
			mass = 70
		},
		materials = {
			{
				clientId = 28878,
				name = "bean",
				itemId = 32310,
				amount = 18
			},
			{
				clientId = 28822,
				name = "apple",
				itemId = 32254,
				amount = 5
			},
			{
				clientId = 28823,
				name = "banana",
				itemId = 32255,
				amount = 2
			}
		}
	},
	{
		quality = 125,
		durability = 7,
		index = 30,
		formatDescription = "foodquality",
		slotName = "",
		name = "Fruit Pancakes",
		progress = 200,
		profession = 8,
		clientId = 34855,
		itemId = 38287,
		experience = 1800,
		amount = 5,
		description = "Increase Vitality by {10} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 28929,
				name = "milk",
				itemId = 32361,
				amount = 1
			},
			{
				clientId = 28928,
				name = "egg",
				itemId = 32360,
				amount = 2
			},
			{
				clientId = 33553,
				name = "Ground Flour",
				itemId = 36985,
				amount = 4
			},
			{
				clientId = 28831,
				name = "grape",
				itemId = 32263,
				amount = 2
			}
		}
	},
	{
		quality = 325,
		durability = 8,
		index = 31,
		formatDescription = "foodquality",
		slotName = "",
		name = "Lucien's Waffles",
		progress = 450,
		profession = 8,
		clientId = 34858,
		itemId = 38290,
		experience = 7400,
		amount = 5,
		description = "Increase Intelligence by {30} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 52,
			mass = 57
		},
		materials = {
			{
				clientId = 28866,
				name = "corn",
				itemId = 32298,
				amount = 6
			},
			{
				clientId = 28928,
				name = "egg",
				itemId = 32360,
				amount = 8
			},
			{
				clientId = 42118,
				name = "Rich Flour",
				itemId = 45570,
				amount = 10
			},
			{
				clientId = 28827,
				name = "strawberry",
				itemId = 32259,
				amount = 8
			}
		}
	},
	{
		quality = 200,
		durability = 7,
		index = 32,
		formatDescription = "foodquality",
		slotName = "",
		name = "Dwarven Purple Shank",
		progress = 300,
		profession = 8,
		clientId = 34851,
		itemId = 38283,
		experience = 4800,
		amount = 5,
		description = "Increase Dexterity by {20} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 38,
			mass = 43
		},
		materials = {
			{
				clientId = 28932,
				name = "shank",
				itemId = 32364,
				amount = 3
			},
			{
				clientId = 28831,
				name = "grape",
				itemId = 32263,
				amount = 2
			},
			{
				clientId = 28828,
				name = "watermelon",
				itemId = 32260,
				amount = 2
			}
		}
	},
	{
		quality = 400,
		durability = 9,
		specialization = "Gourmet Chef",
		index = 33,
		formatDescription = "foodquality",
		slotName = "",
		name = "Bittersweet Roast",
		progress = 550,
		profession = 8,
		clientId = 34848,
		itemId = 38280,
		experience = 14500,
		amount = 5,
		description = "Increase Vitality, Might, Intelligence, Dexterity and Wisdom by {10} for 30 minutes",
		tier = -1,
		category = "meals",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 28931,
				name = "beef",
				itemId = 32363,
				amount = 10
			},
			{
				clientId = 28863,
				name = "brocolli",
				itemId = 32295,
				amount = 3
			},
			{
				clientId = 28830,
				name = "cherry",
				itemId = 32262,
				amount = 5
			}
		}
	},
	{
		quality = 175,
		durability = 7,
		index = 34,
		formatDescription = "foodquality",
		slotName = "",
		name = "Shaked Fruitmilk",
		progress = 250,
		profession = 8,
		clientId = 34868,
		itemId = 38300,
		experience = 4200,
		amount = 5,
		description = "Increase Might by {20} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 36,
			mass = 41
		},
		materials = {
			{
				clientId = 28929,
				name = "milk",
				itemId = 32361,
				amount = 6
			},
			{
				clientId = 28827,
				name = "strawberry",
				itemId = 32259,
				amount = 3
			},
			{
				clientId = 28825,
				name = "blueberry",
				itemId = 32257,
				amount = 15
			}
		}
	},
	{
		quality = 250,
		durability = 7,
		index = 35,
		formatDescription = "foodquality",
		slotName = "",
		name = "Frozen Sweet Berries",
		progress = 375,
		profession = 8,
		clientId = 34854,
		itemId = 38286,
		experience = 7200,
		amount = 5,
		description = "Increase Might by {30} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 51,
			mass = 56
		},
		materials = {
			{
				clientId = 28825,
				name = "blueberry",
				itemId = 32257,
				amount = 12
			},
			{
				clientId = 28830,
				name = "cherry",
				itemId = 32262,
				amount = 4
			},
			{
				clientId = 28826,
				name = "moonberry",
				itemId = 32258,
				amount = 4
			}
		}
	},
	{
		quality = 500,
		durability = 12,
		specialization = "Gourmet Chef",
		index = 36,
		formatDescription = "foodquality",
		slotName = "",
		name = "Iced Fruitmilk",
		progress = 650,
		profession = 8,
		clientId = 34856,
		itemId = 38288,
		experience = 17500,
		amount = 5,
		description = "Increases Movement Speed on foot by {10}% for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 28929,
				name = "milk",
				itemId = 32361,
				amount = 10
			},
			{
				clientId = 28832,
				name = "orange",
				itemId = 32264,
				amount = 5
			},
			{
				clientId = 28824,
				name = "sunberry",
				itemId = 32256,
				amount = 5
			},
			{
				clientId = 28826,
				name = "moonberry",
				itemId = 32258,
				amount = 3
			}
		}
	},
	{
		quality = 100,
		durability = 4,
		index = 37,
		formatDescription = "",
		slotName = "",
		name = "Ground Flour",
		progress = 100,
		profession = 8,
		clientId = 33553,
		itemId = 36985,
		experience = 1800,
		amount = 20,
		description = "Used in various recipes. Its powdery texture holds the potential to create uncountable dishes.",
		tier = -1,
		category = "ingredient",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28866,
				name = "corn",
				itemId = 32298,
				amount = 21
			}
		}
	},
	{
		quality = 100,
		durability = 4,
		index = 38,
		formatDescription = "",
		slotName = "",
		name = "Ground Flour",
		progress = 100,
		profession = 8,
		clientId = 33553,
		itemId = 36985,
		experience = 900,
		amount = 10,
		description = "Used in various recipes. Its powdery texture holds the potential to create uncountable dishes.",
		tier = -1,
		category = "ingredient",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28881,
				name = "wheat",
				itemId = 32313,
				amount = 19
			}
		}
	},
	{
		quality = 50,
		durability = 3,
		index = 39,
		formatDescription = "",
		slotName = "",
		name = "Oil",
		progress = 50,
		profession = 8,
		clientId = 34899,
		itemId = 38331,
		experience = 275,
		amount = 1,
		description = "Used in various recipes. Its viscosity imparts a peculiar sensation on the skin.",
		tier = -1,
		category = "ingredient",
		level = {
			single = 1,
			mass = 6
		},
		materials = {
			{
				clientId = 28866,
				name = "corn",
				itemId = 32298,
				amount = 3
			}
		}
	},
	{
		quality = 200,
		durability = 6,
		index = 40,
		formatDescription = "",
		slotName = "",
		name = "Basic Animal Feed",
		progress = 150,
		profession = 8,
		clientId = 34896,
		itemId = 38328,
		experience = 1800,
		amount = 3,
		description = "Used to create Rations for Moas.",
		tier = -1,
		category = "misc",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 28932,
				name = "shank",
				itemId = 32364,
				amount = 6
			},
			{
				clientId = 28864,
				name = "cabbage",
				itemId = 32296,
				amount = 2
			},
			{
				clientId = 28865,
				name = "carrot",
				itemId = 32297,
				amount = 5
			}
		}
	},
	{
		quality = 400,
		durability = 7,
		index = 41,
		formatDescription = "",
		slotName = "",
		name = "Complex Animal Feed",
		progress = 375,
		profession = 8,
		clientId = 34897,
		itemId = 38329,
		experience = 6800,
		amount = 3,
		description = "Used to create Rations for Moas.",
		tier = -1,
		category = "misc",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 28931,
				name = "beef",
				itemId = 32363,
				amount = 10
			},
			{
				clientId = 28863,
				name = "brocolli",
				itemId = 32295,
				amount = 5
			},
			{
				clientId = 28871,
				name = "pea",
				itemId = 32303,
				amount = 4
			},
			{
				clientId = 28875,
				name = "pumpkin",
				itemId = 32307,
				amount = 3
			}
		}
	},
	{
		quality = 500,
		durability = 9,
		index = 42,
		formatDescription = "",
		slotName = "",
		name = "Spiced Oil",
		progress = 500,
		profession = 8,
		clientId = 34900,
		itemId = 38332,
		experience = 9400,
		amount = 1,
		description = "Used in various recipes. Aromatic whispers emanate from the bottle.",
		tier = -1,
		category = "ingredient",
		level = {
			single = 62,
			mass = 67
		},
		materials = {
			{
				clientId = 34899,
				name = "Oil",
				itemId = 38331,
				amount = 6
			},
			{
				clientId = 28872,
				name = "pepper",
				itemId = 32304,
				amount = 6
			},
			{
				clientId = 34370,
				name = "Three-Leaf Clover",
				itemId = 37802,
				amount = 5
			}
		}
	},
	{
		quality = 50,
		durability = 4,
		index = 43,
		formatDescription = "foodquality",
		slotName = "",
		name = "Apple Cider",
		progress = 75,
		profession = 8,
		clientId = 35397,
		itemId = 38829,
		experience = 1250,
		amount = 5,
		description = "Channel and restore {100} Health and Mana per second for 15 seconds. Being damaged cancels the effect. 15 seconds cooldown.",
		tier = -1,
		category = "drinks",
		level = {
			single = 17,
			mass = 22
		},
		materials = {
			{
				clientId = 28822,
				name = "apple",
				itemId = 32254,
				amount = 1
			},
			{
				clientId = 28881,
				name = "wheat",
				itemId = 32313,
				amount = 2
			}
		}
	},
	{
		quality = 225,
		durability = 7,
		index = 44,
		formatDescription = "foodquality",
		slotName = "",
		name = "Blueberry Wine",
		progress = 350,
		profession = 8,
		clientId = 35400,
		itemId = 38832,
		experience = 5300,
		amount = 5,
		description = "Channel and restore {325} Health and Mana per second for 15 seconds. Being damaged cancels the effect. 15 seconds cooldown.",
		tier = -1,
		category = "drinks",
		level = {
			single = 40,
			mass = 45
		},
		materials = {
			{
				clientId = 28831,
				name = "grape",
				itemId = 32263,
				amount = 10
			},
			{
				clientId = 28825,
				name = "blueberry",
				itemId = 32257,
				amount = 20
			},
			{
				clientId = 42107,
				name = "Brewer Yeast",
				itemId = 45559,
				amount = 2
			}
		}
	},
	{
		quality = 450,
		durability = 10,
		specialization = "Sommelier",
		index = 45,
		formatDescription = "foodquality",
		slotName = "",
		name = "Strawberry Whiskey",
		progress = 600,
		profession = 8,
		clientId = 35399,
		itemId = 38831,
		experience = 16500,
		amount = 5,
		description = "Increase Mana Regeneration and Health Regeneration by {48} for 30 minutes.",
		tier = -1,
		category = "drinks",
		level = {
			single = 72,
			mass = 77
		},
		materials = {
			{
				clientId = 28866,
				name = "corn",
				itemId = 32298,
				amount = 24
			},
			{
				clientId = 28827,
				name = "strawberry",
				itemId = 32259,
				amount = 35
			},
			{
				clientId = 42107,
				name = "Brewer Yeast",
				itemId = 45559,
				amount = 7
			},
			{
				clientId = 44381,
				name = "Honey",
				itemId = 47833,
				amount = 10
			}
		}
	},
	{
		quality = 400,
		durability = 9,
		index = 46,
		formatDescription = "foodquality",
		slotName = "",
		name = "Banana Vodka",
		progress = 550,
		profession = 8,
		clientId = 35398,
		itemId = 38830,
		experience = 8400,
		amount = 5,
		description = "Increase Mana Regeneration and Health Regeneration by {36} for 30 minutes.",
		tier = -1,
		category = "drinks",
		level = {
			single = 57,
			mass = 62
		},
		materials = {
			{
				clientId = 28874,
				name = "potato",
				itemId = 32306,
				amount = 25
			},
			{
				clientId = 28823,
				name = "banana",
				itemId = 32255,
				amount = 5
			},
			{
				clientId = 42107,
				name = "Brewer Yeast",
				itemId = 45559,
				amount = 2
			}
		}
	},
	{
		quality = 400,
		durability = 9,
		index = 47,
		formatDescription = "foodquality",
		slotName = "",
		name = "Spiced Rum",
		progress = 550,
		profession = 8,
		clientId = 35401,
		itemId = 38833,
		experience = 8000,
		amount = 5,
		description = "Channel and restore {400} Health and Mana per second for 15 seconds. Being damaged cancels the effect. 15 seconds cooldown.",
		tier = -1,
		category = "drinks",
		level = {
			single = 55,
			mass = 60
		},
		materials = {
			{
				clientId = 28822,
				name = "apple",
				itemId = 32254,
				amount = 6
			},
			{
				clientId = 28872,
				name = "pepper",
				itemId = 32304,
				amount = 6
			},
			{
				clientId = 42107,
				name = "Brewer Yeast",
				itemId = 45559,
				amount = 2
			}
		}
	},
	{
		quality = 500,
		durability = 12,
		specialization = "Gourmet Chef",
		index = 48,
		formatDescription = "foodquality",
		slotName = "",
		name = "Shanks n' Mash",
		progress = 650,
		profession = 8,
		clientId = 35402,
		itemId = 38834,
		experience = 17500,
		amount = 5,
		description = "Increase Vitality, Might, Intelligence, Dexterity and Wisdom by {15} for 30 minutes",
		tier = -1,
		category = "meals",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 28932,
				name = "shank",
				itemId = 32364,
				amount = 15
			},
			{
				clientId = 28869,
				name = "garlic",
				itemId = 32301,
				amount = 15
			},
			{
				clientId = 28929,
				name = "milk",
				itemId = 32361,
				amount = 8
			}
		}
	},
	{
		quality = 75,
		durability = 5,
		index = 50,
		formatDescription = "foodquality",
		slotName = "",
		name = "Corn Chowder",
		progress = 125,
		profession = 8,
		clientId = 42109,
		itemId = 45561,
		experience = 850,
		amount = 5,
		description = "Increase Wisdom by {4} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 8,
			mass = 13
		},
		materials = {
			{
				clientId = 28866,
				name = "corn",
				itemId = 32298,
				amount = 3
			},
			{
				clientId = 28874,
				name = "potato",
				itemId = 32306,
				amount = 1
			}
		}
	},
	{
		quality = 125,
		durability = 6,
		index = 51,
		formatDescription = "foodquality",
		slotName = "",
		name = "Butter",
		progress = 175,
		profession = 8,
		clientId = 42749,
		itemId = 46201,
		experience = 1150,
		amount = 2,
		description = "Used in various recipes. A creamy and rich delight churned from milk.",
		tier = -1,
		category = "ingredient",
		level = {
			single = 15,
			mass = 20
		},
		materials = {
			{
				clientId = 28929,
				name = "milk",
				itemId = 32361,
				amount = 7
			}
		}
	},
	{
		quality = 50,
		durability = 4,
		index = 52,
		formatDescription = "foodquality",
		slotName = "",
		name = "Corn on a Cob",
		progress = 75,
		profession = 8,
		clientId = 42110,
		itemId = 45562,
		experience = 500,
		amount = 5,
		description = "Increase Defense Power by {1} for 30 minutes.",
		tier = -1,
		category = "baked goods",
		level = {
			single = 3,
			mass = 8
		},
		materials = {
			{
				clientId = 28866,
				name = "corn",
				itemId = 32298,
				amount = 2
			}
		}
	},
	{
		quality = 100,
		durability = 6,
		index = 53,
		formatDescription = "foodquality",
		slotName = "",
		name = "Glademire Crackers",
		progress = 175,
		profession = 8,
		clientId = 42748,
		itemId = 46200,
		experience = 1150,
		amount = 5,
		description = "Increase Healing Power by {4} for 30 minutes.",
		tier = -1,
		category = "baked goods",
		level = {
			single = 15,
			mass = 20
		},
		materials = {
			{
				clientId = 33553,
				name = "Ground Flour",
				itemId = 36985,
				amount = 9
			},
			{
				clientId = 42106,
				name = "Basic Seasoning",
				itemId = 45558,
				amount = 3
			}
		}
	},
	{
		quality = 75,
		durability = 5,
		index = 54,
		formatDescription = "foodquality",
		slotName = "",
		name = "Corn Salad",
		progress = 125,
		profession = 8,
		clientId = 42128,
		itemId = 45580,
		experience = 850,
		amount = 5,
		description = "Increase Vitality by {4} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 8,
			mass = 13
		},
		materials = {
			{
				clientId = 28866,
				name = "corn",
				itemId = 32298,
				amount = 3
			},
			{
				clientId = 28874,
				name = "potato",
				itemId = 32306,
				amount = 1
			}
		}
	},
	{
		quality = 325,
		durability = 7,
		index = 55,
		formatDescription = "foodquality",
		slotName = "",
		name = "Rich Flour",
		progress = 350,
		profession = 8,
		clientId = 42118,
		itemId = 45570,
		experience = 6000,
		amount = 20,
		description = "Used in various recipes. A finely milled flour, imbued with fine ingredients.",
		tier = -1,
		category = "ingredient",
		level = {
			single = 45,
			mass = 50
		},
		materials = {
			{
				clientId = 33553,
				name = "Ground Flour",
				itemId = 36985,
				amount = 34
			},
			{
				clientId = 34370,
				name = "Three-Leaf Clover",
				itemId = 37802,
				amount = 3
			}
		}
	},
	{
		quality = 150,
		durability = 7,
		index = 56,
		formatDescription = "foodquality",
		slotName = "",
		name = "Cornbread",
		progress = 225,
		profession = 8,
		clientId = 42111,
		itemId = 45563,
		experience = 3000,
		amount = 5,
		description = "Increase Healing Power by {8} for 30 minutes.",
		tier = -1,
		category = "baked goods",
		level = {
			single = 26,
			mass = 31
		},
		materials = {
			{
				clientId = 33553,
				name = "Ground Flour",
				itemId = 36985,
				amount = 15
			},
			{
				clientId = 28866,
				name = "corn",
				itemId = 32298,
				amount = 6
			},
			{
				clientId = 42106,
				name = "Basic Seasoning",
				itemId = 45558,
				amount = 1
			}
		}
	},
	{
		quality = 400,
		durability = 9,
		specialization = "Sommelier",
		index = 57,
		formatDescription = "foodquality",
		slotName = "",
		name = "Eclipse",
		progress = 550,
		profession = 8,
		clientId = 42723,
		itemId = 46175,
		experience = 14500,
		amount = 5,
		description = "Channel and restore {600} Health and Mana per second for 15 seconds. Being damaged cancels the effect. 15 seconds cooldown.",
		tier = -1,
		category = "drinks",
		level = {
			single = 70,
			mass = 75
		},
		materials = {
			{
				clientId = 28826,
				name = "moonberry",
				itemId = 32258,
				amount = 13
			},
			{
				clientId = 28824,
				name = "sunberry",
				itemId = 32256,
				amount = 13
			},
			{
				clientId = 42107,
				name = "Brewer Yeast",
				itemId = 45559,
				amount = 4
			}
		}
	},
	{
		quality = 150,
		durability = 7,
		index = 58,
		formatDescription = "foodquality",
		slotName = "",
		name = "Gourmet Seasoning",
		progress = 175,
		profession = 8,
		clientId = 42112,
		itemId = 45564,
		experience = 2750,
		amount = 5,
		description = "Used in various recipes. A highly sophisticated blend of flavorful herbs and spices.",
		tier = -1,
		category = "ingredient",
		level = {
			single = 25,
			mass = 30
		},
		materials = {
			{
				clientId = 33551,
				name = "salt",
				itemId = 36983,
				amount = 8
			},
			{
				clientId = 28870,
				name = "onion",
				itemId = 32302,
				amount = 4
			}
		}
	},
	{
		quality = 100,
		durability = 6,
		index = 59,
		formatDescription = "foodquality",
		slotName = "",
		name = "Landing Brandy",
		progress = 150,
		profession = 8,
		clientId = 42724,
		itemId = 46176,
		experience = 900,
		amount = 5,
		description = "Increase Mana Regeneration and Health Regeneration by {8} for 30 minutes.",
		tier = -1,
		category = "drinks",
		level = {
			single = 10,
			mass = 15
		},
		materials = {
			{
				clientId = 28822,
				name = "apple",
				itemId = 32254,
				amount = 1
			}
		}
	},
	{
		quality = 125,
		durability = 7,
		index = 60,
		formatDescription = "foodquality",
		slotName = "",
		name = "Loaf Bread",
		progress = 200,
		profession = 8,
		clientId = 42113,
		itemId = 45565,
		experience = 1850,
		amount = 5,
		description = "Increase Healing Power by {6} for 30 minutes.",
		tier = -1,
		category = "baked goods",
		level = {
			single = 21,
			mass = 26
		},
		materials = {
			{
				clientId = 33553,
				name = "Ground Flour",
				itemId = 36985,
				amount = 13
			},
			{
				clientId = 42106,
				name = "Basic Seasoning",
				itemId = 45558,
				amount = 2
			},
			{
				clientId = 28929,
				name = "milk",
				itemId = 32361,
				amount = 1
			}
		}
	},
	{
		quality = 100,
		durability = 6,
		index = 61,
		formatDescription = "foodquality",
		slotName = "",
		name = "Lyderian Fries",
		progress = 175,
		profession = 8,
		clientId = 42114,
		itemId = 45566,
		experience = 1500,
		amount = 5,
		description = "Increase Might by {6} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 18,
			mass = 23
		},
		materials = {
			{
				clientId = 28874,
				name = "potato",
				itemId = 32306,
				amount = 13
			},
			{
				clientId = 34899,
				name = "Oil",
				itemId = 38331,
				amount = 3
			}
		}
	},
	{
		quality = 75,
		durability = 5,
		index = 62,
		formatDescription = "foodquality",
		slotName = "",
		name = "Mashed Potatoes",
		progress = 125,
		profession = 8,
		clientId = 42115,
		itemId = 45567,
		experience = 850,
		amount = 5,
		description = "Increase Might by {4} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 8,
			mass = 13
		},
		materials = {
			{
				clientId = 28874,
				name = "potato",
				itemId = 32306,
				amount = 10
			},
			{
				clientId = 42106,
				name = "Basic Seasoning",
				itemId = 45558,
				amount = 3
			}
		}
	},
	{
		quality = 100,
		durability = 6,
		index = 63,
		formatDescription = "foodquality",
		slotName = "",
		name = "Omelet",
		progress = 175,
		profession = 8,
		clientId = 42116,
		itemId = 45568,
		experience = 1500,
		amount = 5,
		description = "Increase Dexterity by {6} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 18,
			mass = 23
		},
		materials = {
			{
				clientId = 28928,
				name = "egg",
				itemId = 32360,
				amount = 2
			},
			{
				clientId = 28929,
				name = "milk",
				itemId = 32361,
				amount = 2
			},
			{
				clientId = 42106,
				name = "Basic Seasoning",
				itemId = 45558,
				amount = 1
			}
		}
	},
	{
		quality = 150,
		durability = 7,
		index = 64,
		formatDescription = "",
		slotName = "",
		name = "Orange Liqueur",
		progress = 225,
		profession = 8,
		clientId = 42721,
		itemId = 46173,
		experience = 3500,
		amount = 5,
		description = "Channel and restore {250} Health and Mana per second for 15 seconds. Being damaged cancels the effect. 15 seconds cooldown.",
		tier = -1,
		category = "drinks",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				clientId = 28832,
				name = "orange",
				itemId = 32264,
				amount = 2
			},
			{
				clientId = 42107,
				name = "Brewer Yeast",
				itemId = 45559,
				amount = 1
			}
		}
	},
	{
		quality = 50,
		durability = 4,
		index = 65,
		formatDescription = "foodquality",
		slotName = "",
		name = "Potato Bread",
		progress = 75,
		profession = 8,
		clientId = 42117,
		itemId = 45569,
		experience = 550,
		amount = 5,
		description = "Increase Healing Power by {1} for 30 minutes.",
		tier = -1,
		category = "baked goods",
		level = {
			single = 4,
			mass = 9
		},
		materials = {
			{
				clientId = 28874,
				name = "potato",
				itemId = 32306,
				amount = 6
			},
			{
				clientId = 28866,
				name = "corn",
				itemId = 32298,
				amount = 1
			}
		}
	},
	{
		quality = 100,
		durability = 6,
		index = 67,
		formatDescription = "foodquality",
		slotName = "",
		name = "Rohna Crackers",
		progress = 175,
		profession = 8,
		clientId = 42119,
		itemId = 45571,
		experience = 1100,
		amount = 5,
		description = "Increase Defense Power by {4} for 30 minutes.",
		tier = -1,
		category = "baked goods",
		level = {
			single = 14,
			mass = 19
		},
		materials = {
			{
				clientId = 33553,
				name = "Ground Flour",
				itemId = 36985,
				amount = 6
			},
			{
				clientId = 42749,
				name = "Butter",
				itemId = 46201,
				amount = 1
			}
		}
	},
	{
		quality = 400,
		durability = 9,
		specialization = "Pastry Expert",
		index = 68,
		formatDescription = "foodquality",
		slotName = "",
		name = "Rye Bread",
		progress = 550,
		profession = 8,
		clientId = 42120,
		itemId = 45572,
		experience = 15500,
		amount = 5,
		description = "Increase Healing Power by {25} for 30 minutes.",
		tier = -1,
		category = "baked goods",
		level = {
			single = 71,
			mass = 76
		},
		materials = {
			{
				clientId = 42118,
				name = "Rich Flour",
				itemId = 45570,
				amount = 14
			},
			{
				clientId = 42749,
				name = "Butter",
				itemId = 46201,
				amount = 6
			},
			{
				clientId = 28928,
				name = "egg",
				itemId = 32360,
				amount = 10
			},
			{
				clientId = 28871,
				name = "pea",
				itemId = 32303,
				amount = 25
			}
		}
	},
	{
		quality = 100,
		durability = 6,
		index = 69,
		formatDescription = "foodquality",
		slotName = "",
		name = "Sajecho Hardtack",
		progress = 175,
		profession = 8,
		clientId = 42121,
		itemId = 45573,
		experience = 1000,
		amount = 5,
		description = "Increase Attack Power by {4} for 30 minutes.",
		tier = -1,
		category = "baked goods",
		level = {
			single = 13,
			mass = 18
		},
		materials = {
			{
				clientId = 33553,
				name = "Ground Flour",
				itemId = 36985,
				amount = 6
			},
			{
				clientId = 40832,
				name = "Orange Scales",
				itemId = 44284,
				amount = 3
			}
		}
	},
	{
		quality = 75,
		durability = 5,
		index = 70,
		formatDescription = "foodquality",
		slotName = "",
		name = "Scrambled Eggs",
		progress = 125,
		profession = 8,
		clientId = 42122,
		itemId = 45574,
		experience = 850,
		amount = 5,
		description = "Increase Dexterity by {4} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 8,
			mass = 13
		},
		materials = {
			{
				clientId = 28928,
				name = "egg",
				itemId = 32360,
				amount = 3
			},
			{
				clientId = 42106,
				name = "Basic Seasoning",
				itemId = 45558,
				amount = 1
			}
		}
	},
	{
		quality = 50,
		durability = 3,
		index = 71,
		formatDescription = "foodquality",
		slotName = "",
		name = "Seafood Seasoning",
		progress = 50,
		profession = 8,
		clientId = 42123,
		itemId = 45575,
		experience = 600,
		amount = 5,
		description = "Used in various recipes. This flavorful blend captures the essence of the sea.",
		tier = -1,
		category = "ingredient",
		level = {
			single = 5,
			mass = 10
		},
		materials = {
			{
				clientId = 33551,
				name = "salt",
				itemId = 36983,
				amount = 1
			},
			{
				clientId = 40832,
				name = "Orange Scales",
				itemId = 44284,
				amount = 5
			}
		}
	},
	{
		quality = 100,
		durability = 6,
		index = 72,
		formatDescription = "foodquality",
		slotName = "",
		name = "Silky Scrambled Eggs",
		progress = 175,
		profession = 8,
		clientId = 42124,
		itemId = 45576,
		experience = 1500,
		amount = 5,
		description = "Increase Wisdom by {6} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 18,
			mass = 23
		},
		materials = {
			{
				clientId = 28928,
				name = "egg",
				itemId = 32360,
				amount = 4
			},
			{
				clientId = 42749,
				name = "Butter",
				itemId = 46201,
				amount = 1
			}
		}
	},
	{
		quality = 250,
		durability = 7,
		index = 73,
		formatDescription = "foodquality",
		slotName = "",
		name = "Sourdought Bagel",
		progress = 375,
		profession = 8,
		clientId = 42125,
		itemId = 45577,
		experience = 7200,
		amount = 5,
		description = "Increase Healing Power by {16} for 30 minutes.",
		tier = -1,
		category = "baked goods",
		level = {
			single = 51,
			mass = 56
		},
		materials = {
			{
				clientId = 42118,
				name = "Rich Flour",
				itemId = 45570,
				amount = 13
			},
			{
				clientId = 28929,
				name = "milk",
				itemId = 32361,
				amount = 5
			},
			{
				clientId = 42112,
				name = "Gourmet Seasoning",
				itemId = 45564,
				amount = 2
			}
		}
	},
	{
		quality = 550,
		durability = 9,
		index = 74,
		formatDescription = "foodquality",
		slotName = "",
		name = "Spicy Seasoning",
		progress = 550,
		profession = 8,
		clientId = 42126,
		itemId = 45578,
		experience = 10000,
		amount = 5,
		description = "Used in various recipes. Ignite your taste buds with this fiery fusion of spices.",
		tier = -1,
		category = "ingredient",
		level = {
			single = 65,
			mass = 70
		},
		materials = {
			{
				clientId = 33551,
				name = "salt",
				itemId = 36983,
				amount = 8
			},
			{
				clientId = 28872,
				name = "pepper",
				itemId = 32304,
				amount = 10
			},
			{
				clientId = 34370,
				name = "Three-Leaf Clover",
				itemId = 37802,
				amount = 4
			}
		}
	},
	{
		quality = 100,
		durability = 6,
		index = 75,
		formatDescription = "foodquality",
		slotName = "",
		name = "Steamed Carrots",
		progress = 175,
		profession = 8,
		clientId = 42127,
		itemId = 45579,
		experience = 1500,
		amount = 5,
		description = "Increase Vitality by {6} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 18,
			mass = 23
		},
		materials = {
			{
				clientId = 28865,
				name = "carrot",
				itemId = 32297,
				amount = 10
			},
			{
				clientId = 42106,
				name = "Basic Seasoning",
				itemId = 45558,
				amount = 4
			}
		}
	},
	{
		quality = 250,
		durability = 7,
		index = 76,
		formatDescription = "foodquality",
		slotName = "",
		name = "Blueberry Pie",
		progress = 375,
		profession = 8,
		clientId = 42725,
		itemId = 46177,
		experience = 6800,
		amount = 5,
		description = "Increase Vitality by {30} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 42749,
				name = "Butter",
				itemId = 46201,
				amount = 5
			},
			{
				clientId = 42118,
				name = "Rich Flour",
				itemId = 45570,
				amount = 5
			},
			{
				clientId = 28825,
				name = "blueberry",
				itemId = 32257,
				amount = 34
			}
		}
	},
	{
		quality = 250,
		durability = 7,
		index = 77,
		formatDescription = "foodquality",
		slotName = "",
		name = "Boozemelon",
		progress = 375,
		profession = 8,
		clientId = 42722,
		itemId = 46174,
		experience = 5500,
		amount = 5,
		description = "Increase Mana Regeneration and Health Regeneration by {24} for 30 minutes.",
		tier = -1,
		category = "drinks",
		level = {
			single = 42,
			mass = 47
		},
		materials = {
			{
				clientId = 28828,
				name = "watermelon",
				itemId = 32260,
				amount = 3
			},
			{
				clientId = 28875,
				name = "pumpkin",
				itemId = 32307,
				amount = 1
			},
			{
				clientId = 42107,
				name = "Brewer Yeast",
				itemId = 45559,
				amount = 3
			}
		}
	},
	{
		quality = 150,
		durability = 7,
		index = 78,
		formatDescription = "foodquality",
		slotName = "",
		name = "Brewer Yeast",
		progress = 200,
		profession = 8,
		clientId = 42107,
		itemId = 45559,
		experience = 1800,
		amount = 5,
		description = "Used in various recipes. A vital ingredient in the art of brewing.",
		tier = -1,
		category = "ingredient",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 40832,
				name = "Orange Scales",
				itemId = 44284,
				amount = 20
			},
			{
				clientId = 28881,
				name = "wheat",
				itemId = 32313,
				amount = 14
			}
		}
	},
	{
		quality = 100,
		durability = 6,
		index = 79,
		formatDescription = "foodquality",
		slotName = "",
		name = "Carrot Soup",
		progress = 175,
		profession = 8,
		clientId = 42108,
		itemId = 45560,
		experience = 1500,
		amount = 5,
		description = "Increase Intelligence by {6} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 18,
			mass = 23
		},
		materials = {
			{
				clientId = 28865,
				name = "carrot",
				itemId = 32297,
				amount = 6
			},
			{
				clientId = 28874,
				name = "potato",
				itemId = 32306,
				amount = 2
			},
			{
				clientId = 28750,
				name = "chicken",
				itemId = 32182,
				amount = 1
			}
		}
	},
	{
		quality = 75,
		durability = 5,
		index = 80,
		formatDescription = "foodquality",
		slotName = "",
		name = "Apple Puree",
		progress = 125,
		profession = 8,
		clientId = 42103,
		itemId = 45555,
		experience = 850,
		amount = 5,
		description = "Increase Intelligence by {4} for 30 minutes.",
		tier = -1,
		category = "meals",
		level = {
			single = 8,
			mass = 13
		},
		materials = {
			{
				clientId = 28822,
				name = "apple",
				itemId = 32254,
				amount = 1
			}
		}
	},
	{
		quality = 200,
		durability = 7,
		index = 81,
		formatDescription = "foodquality",
		slotName = "",
		name = "Bagel",
		progress = 275,
		profession = 8,
		clientId = 42104,
		itemId = 45556,
		experience = 4200,
		amount = 5,
		description = "Increase Healing Power by {12} for 30 minutes.",
		tier = -1,
		category = "baked goods",
		level = {
			single = 36,
			mass = 41
		},
		materials = {
			{
				clientId = 33553,
				name = "Ground Flour",
				itemId = 36985,
				amount = 12
			},
			{
				clientId = 28928,
				name = "egg",
				itemId = 32360,
				amount = 6
			},
			{
				clientId = 42112,
				name = "Gourmet Seasoning",
				itemId = 45564,
				amount = 3
			}
		}
	},
	{
		quality = 50,
		durability = 4,
		index = 82,
		formatDescription = "foodquality",
		slotName = "",
		name = "Baked Potatoes",
		progress = 75,
		profession = 8,
		clientId = 42105,
		itemId = 45557,
		experience = 325,
		amount = 5,
		description = "Increase Attack Power by {1} for 30 minutes.",
		tier = -1,
		category = "baked goods",
		level = {
			single = 2,
			mass = 7
		},
		materials = {
			{
				clientId = 28874,
				name = "potato",
				itemId = 32306,
				amount = 7
			}
		}
	},
	{
		quality = 50,
		durability = 3,
		index = 83,
		formatDescription = "foodquality",
		slotName = "",
		name = "Basic Seasoning",
		progress = 50,
		profession = 8,
		clientId = 42106,
		itemId = 45558,
		experience = 600,
		amount = 5,
		description = "Used in various recipes. Essential flavor enhancer for a wide range of dishes.",
		tier = -1,
		category = "ingredient",
		level = {
			single = 5,
			mass = 10
		},
		materials = {
			{
				clientId = 33551,
				name = "salt",
				itemId = 36983,
				amount = 1
			},
			{
				clientId = 28750,
				name = "chicken",
				itemId = 32182,
				amount = 1
			}
		}
	},
	{
		quality = 150,
		durability = 7,
		index = 84,
		formatDescription = "rationquality",
		slotName = "",
		name = "Superior Ration",
		progress = 200,
		profession = 8,
		clientId = 50715,
		itemId = 54168,
		experience = 1800,
		amount = 5,
		description = "Increases Speed by {8} and Strength by {6} for the next 7500 steps. Restores 100% of the Moa's Stamina, if the moa consuming this is a higher tier than the ration, restores 4000 stamina instead.",
		tier = -1,
		category = "misc",
		level = {
			single = 20,
			mass = 25
		},
		materials = {
			{
				clientId = 34896,
				name = "Basic Animal Feed",
				itemId = 38328,
				amount = 3
			},
			{
				clientId = 38161,
				name = "Moa Ration",
				itemId = 41613,
				amount = 1
			}
		}
	},
	{
		quality = 225,
		durability = 7,
		index = 85,
		formatDescription = "rationquality",
		slotName = "",
		name = "Rustic Ration",
		progress = 250,
		profession = 8,
		clientId = 50716,
		itemId = 54169,
		experience = 3500,
		amount = 5,
		description = "Increases Speed by {12} and Strength by {8} for the next 10000 steps. Restores 100% of the Moa's Stamina, if the moa consuming this is a higher tier than the ration, restores 6500 stamina instead. ",
		tier = -1,
		category = "misc",
		level = {
			single = 30,
			mass = 35
		},
		materials = {
			{
				clientId = 34896,
				name = "Basic Animal Feed",
				itemId = 38328,
				amount = 5
			},
			{
				clientId = 43664,
				name = "Attachment Feather",
				itemId = 47116,
				amount = 1
			},
			{
				clientId = 50715,
				name = "Superior Ration",
				itemId = 54168,
				amount = 2
			}
		}
	},
	{
		quality = 350,
		durability = 7,
		index = 86,
		formatDescription = "rationquality",
		slotName = "",
		name = "Gourmet Ration",
		progress = 375,
		profession = 8,
		clientId = 50717,
		itemId = 54170,
		experience = 5300,
		amount = 5,
		description = "Increases Speed by {18} and Strength by {12} for the next 13000 steps. Restores 100% of the Moa's Stamina, if the moa consuming this is a higher tier than the ration, restores 9000 stamina instead. ",
		tier = -1,
		category = "misc",
		level = {
			single = 40,
			mass = 45
		},
		materials = {
			{
				clientId = 34896,
				name = "Basic Animal Feed",
				itemId = 38328,
				amount = 7
			},
			{
				clientId = 38161,
				name = "Moa Ration",
				itemId = 41613,
				amount = 1
			},
			{
				clientId = 50716,
				name = "Rustic Ration",
				itemId = 54169,
				amount = 2
			}
		}
	},
	{
		quality = 500,
		durability = 8,
		index = 87,
		formatDescription = "rationquality",
		slotName = "",
		name = "Seafood Extravaganza",
		progress = 500,
		profession = 8,
		clientId = 50718,
		itemId = 54171,
		experience = 6800,
		amount = 5,
		description = "Increases Speed by {23} and Strength by {16} for the next 16000 steps. Restores 100% of the Moa's Stamina, if the moa consuming this is a higher tier than the ration, restores 12000 stamina instead. ",
		tier = -1,
		category = "misc",
		level = {
			single = 50,
			mass = 55
		},
		materials = {
			{
				clientId = 34897,
				name = "Complex Animal Feed",
				itemId = 38329,
				amount = 2
			},
			{
				clientId = 43664,
				name = "Attachment Feather",
				itemId = 47116,
				amount = 1
			},
			{
				clientId = 50717,
				name = "Gourmet Ration",
				itemId = 54170,
				amount = 2
			}
		}
	},
	{
		quality = 550,
		durability = 9,
		index = 88,
		formatDescription = "rationquality",
		slotName = "",
		name = "Uncanny Ration",
		progress = 550,
		profession = 8,
		clientId = 50719,
		itemId = 54172,
		experience = 8750,
		amount = 5,
		description = "Increases Speed by {28} and Strength by {20} for the next 20000 steps. Restores 100% of the Moa's Stamina, if the moa consuming this is a higher tier than the ration, restores 15000 stamina instead. ",
		tier = -1,
		category = "misc",
		level = {
			single = 60,
			mass = 65
		},
		materials = {
			{
				clientId = 34897,
				name = "Complex Animal Feed",
				itemId = 38329,
				amount = 4
			},
			{
				clientId = 38161,
				name = "Moa Ration",
				itemId = 41613,
				amount = 1
			},
			{
				clientId = 50718,
				name = "Seafood Extravaganza",
				itemId = 54171,
				amount = 2
			}
		}
	},
	{
		quality = 650,
		durability = 10,
		index = 89,
		formatDescription = "rationquality",
		slotName = "",
		name = "Moa's Delight",
		progress = 650,
		profession = 8,
		clientId = 50720,
		itemId = 54173,
		experience = 17500,
		amount = 5,
		description = "Increases Speed by {35} and Strength by {25} for the next 25000 steps. Restores 100% of the Moa's Stamina, if the moa consuming this is a higher tier than the ration, restores 20000 stamina instead. ",
		tier = -1,
		category = "misc",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 34897,
				name = "Complex Animal Feed",
				itemId = 38329,
				amount = 6
			},
			{
				clientId = 43664,
				name = "Attachment Feather",
				itemId = 47116,
				amount = 2
			},
			{
				clientId = 50719,
				name = "Uncanny Ration",
				itemId = 54172,
				amount = 2
			}
		}
	},
	{
		quality = 100,
		durability = 4,
		index = 90,
		formatDescription = "",
		slotName = "",
		name = "Collagen",
		progress = 100,
		profession = 8,
		clientId = 47960,
		itemId = 51413,
		experience = 930,
		amount = 1,
		description = "Required for certain crafting recipes.",
		tier = -1,
		category = "ingredient",
		level = {
			single = 11,
			mass = 16
		},
		materials = {
			{
				clientId = 28932,
				name = "shank",
				itemId = 32364,
				amount = 5
			}
		}
	},
	{
		quality = 275,
		durability = 7,
		index = 91,
		formatDescription = "",
		slotName = "",
		name = "Concentrated Collagen",
		progress = 300,
		profession = 8,
		clientId = 47959,
		itemId = 51412,
		experience = 5000,
		amount = 1,
		description = "Required for certain crafting recipes.",
		tier = -1,
		category = "ingredient",
		level = {
			single = 39,
			mass = 44
		},
		materials = {
			{
				clientId = 47960,
				name = "Collagen",
				itemId = 51413,
				amount = 10
			},
			{
				clientId = 28932,
				name = "shank",
				itemId = 32364,
				amount = 8
			}
		}
	},
	{
		quality = 100,
		durability = 6,
		index = 92,
		formatDescription = "quality",
		slotName = "",
		name = "Gummy Wriggler",
		progress = 150,
		profession = 8,
		clientId = 47951,
		itemId = 51404,
		experience = 960,
		amount = 50,
		description = "Increases the weight of the next fish caught on your line by {20}%.",
		tier = -1,
		category = "fishing bait",
		level = {
			single = 12,
			mass = 17
		},
		materials = {
			{
				clientId = 47960,
				name = "Collagen",
				itemId = 51413,
				amount = 1
			},
			{
				clientId = 28865,
				name = "carrot",
				itemId = 32297,
				amount = 1
			}
		}
	},
	{
		quality = 140,
		durability = 7,
		index = 93,
		formatDescription = "quality",
		slotName = "",
		name = "Gelatinous Pupa",
		progress = 200,
		profession = 8,
		clientId = 47952,
		itemId = 51405,
		experience = 2350,
		amount = 50,
		description = "Increases the weight of the next fish caught on your line by {40}%.",
		tier = -1,
		category = "fishing bait",
		level = {
			single = 23,
			mass = 28
		},
		materials = {
			{
				clientId = 47960,
				name = "Collagen",
				itemId = 51413,
				amount = 2
			},
			{
				clientId = 28832,
				name = "orange",
				itemId = 32264,
				amount = 1
			}
		}
	},
	{
		quality = 225,
		durability = 7,
		index = 94,
		formatDescription = "quality",
		slotName = "",
		name = "Plump Jellygrub",
		progress = 350,
		profession = 8,
		clientId = 47954,
		itemId = 51407,
		experience = 5300,
		amount = 50,
		description = "Increases the weight of the next fish caught on your line by {60}%.",
		tier = -1,
		category = "fishing bait",
		level = {
			single = 40,
			mass = 45
		},
		materials = {
			{
				clientId = 47960,
				name = "Collagen",
				itemId = 51413,
				amount = 3
			},
			{
				clientId = 28823,
				name = "banana",
				itemId = 32255,
				amount = 2
			}
		}
	},
	{
		quality = 350,
		durability = 8,
		index = 95,
		formatDescription = "quality",
		slotName = "",
		name = "Blobby Beetle",
		progress = 500,
		profession = 8,
		clientId = 47956,
		itemId = 51409,
		experience = 9250,
		amount = 50,
		description = "Increases the weight of the next fish caught on your line by {80}%.",
		tier = -1,
		category = "fishing bait",
		level = {
			single = 61,
			mass = 66
		},
		materials = {
			{
				clientId = 47959,
				name = "Concentrated Collagen",
				itemId = 51412,
				amount = 1
			},
			{
				clientId = 28826,
				name = "moonberry",
				itemId = 32258,
				amount = 11
			}
		}
	},
	{
		quality = 600,
		durability = 10,
		index = 96,
		formatDescription = "quality",
		slotName = "",
		name = "Chewy Jellyworm",
		progress = 600,
		profession = 8,
		clientId = 47958,
		itemId = 51411,
		experience = 17500,
		amount = 50,
		description = "Increases the weight of the next fish caught on your line by {100}%.",
		tier = -1,
		category = "fishing bait",
		level = {
			single = 75,
			mass = 80
		},
		materials = {
			{
				clientId = 47959,
				name = "Concentrated Collagen",
				itemId = 51412,
				amount = 2
			},
			{
				clientId = 28824,
				name = "sunberry",
				itemId = 32256,
				amount = 5
			}
		}
	},
	{
		quality = 0,
		durability = 6,
		index = 97,
		formatDescription = "quality",
		slotName = "",
		name = "Shrimp Bait",
		progress = 150,
		profession = 8,
		clientId = 49336,
		itemId = 52789,
		experience = 1000,
		amount = 50,
		description = "Sets the chance of the next fish caught on your line being a Shrimp to 20% when fishing in the ocean.",
		tier = -1,
		category = "fishing bait",
		level = {
			single = 13,
			mass = 18
		},
		materials = {
			{
				clientId = 47960,
				name = "Collagen",
				itemId = 51413,
				amount = 1
			},
			{
				clientId = 49875,
				name = "Exotic Fin",
				itemId = 53328,
				amount = 3
			}
		}
	},
	{
		quality = 0,
		durability = 6,
		index = 98,
		formatDescription = "quality",
		slotName = "",
		name = "Catfish Bait",
		progress = 175,
		profession = 8,
		clientId = 49331,
		itemId = 52784,
		experience = 1500,
		amount = 50,
		description = "Sets the chance of the next fish caught on your line being a Catfish to 20% when fishing in the ocean.",
		tier = -1,
		category = "fishing bait",
		level = {
			single = 18,
			mass = 23
		},
		materials = {
			{
				clientId = 47960,
				name = "Collagen",
				itemId = 51413,
				amount = 1
			},
			{
				clientId = 49881,
				name = "Jellyfish Remains",
				itemId = 53334,
				amount = 3
			}
		}
	},
	{
		quality = 0,
		durability = 7,
		index = 99,
		formatDescription = "quality",
		slotName = "",
		name = "Tench Fish Bait",
		progress = 200,
		profession = 8,
		clientId = 49339,
		itemId = 52792,
		experience = 2350,
		amount = 50,
		description = "Sets the chance of the next fish caught on your line being a Tench Fish to 20% when fishing in the ocean.",
		tier = -1,
		category = "fishing bait",
		level = {
			single = 23,
			mass = 28
		},
		materials = {
			{
				clientId = 47960,
				name = "Collagen",
				itemId = 51413,
				amount = 2
			},
			{
				clientId = 49875,
				name = "Exotic Fin",
				itemId = 53328,
				amount = 5
			}
		}
	},
	{
		quality = 0,
		durability = 7,
		index = 100,
		formatDescription = "quality",
		slotName = "",
		name = "Rainbow Fish Bait",
		progress = 225,
		profession = 8,
		clientId = 49333,
		itemId = 52786,
		experience = 3200,
		amount = 50,
		description = "Sets the chance of the next fish caught on your line being a Rainbow Fish to 20% when fishing in the ocean.",
		tier = -1,
		category = "fishing bait",
		level = {
			single = 28,
			mass = 33
		},
		materials = {
			{
				clientId = 47960,
				name = "Collagen",
				itemId = 51413,
				amount = 2
			},
			{
				clientId = 49890,
				name = "Stolen Spices",
				itemId = 53343,
				amount = 3
			}
		}
	},
	{
		quality = 0,
		durability = 8,
		index = 101,
		formatDescription = "quality",
		slotName = "",
		name = "Scale Fish Bait",
		progress = 250,
		profession = 8,
		clientId = 49335,
		itemId = 52788,
		experience = 3750,
		amount = 50,
		description = "Sets the chance of the next fish caught on your line being a Scale Fish to 20% when fishing in the ocean.",
		tier = -1,
		category = "fishing bait",
		level = {
			single = 32,
			mass = 37
		},
		materials = {
			{
				clientId = 47960,
				name = "Collagen",
				itemId = 51413,
				amount = 3
			},
			{
				clientId = 49871,
				name = "Caudal Fin",
				itemId = 53324,
				amount = 3
			}
		}
	},
	{
		quality = 0,
		durability = 8,
		index = 102,
		formatDescription = "quality",
		slotName = "",
		name = "Princess Fish Bait",
		progress = 300,
		profession = 8,
		clientId = 49332,
		itemId = 52785,
		experience = 4450,
		amount = 50,
		description = "Sets the chance of the next fish caught on your line being a Princess Fish to 20% when fishing in the ocean.",
		tier = -1,
		category = "fishing bait",
		level = {
			single = 37,
			mass = 42
		},
		materials = {
			{
				clientId = 47960,
				name = "Collagen",
				itemId = 51413,
				amount = 3
			},
			{
				clientId = 49884,
				name = "Narwhal Blubber",
				itemId = 53337,
				amount = 3
			}
		}
	},
	{
		quality = 0,
		durability = 9,
		index = 103,
		formatDescription = "quality",
		slotName = "",
		name = "Sky Fish Bait",
		progress = 450,
		profession = 8,
		clientId = 49337,
		itemId = 52790,
		experience = 6500,
		amount = 50,
		description = "Sets the chance of the next fish caught on your line being a Sky Fish to 20% when fishing in the ocean.",
		tier = -1,
		category = "fishing bait",
		level = {
			single = 47,
			mass = 52
		},
		materials = {
			{
				clientId = 47959,
				name = "Concentrated Collagen",
				itemId = 51412,
				amount = 1
			},
			{
				clientId = 49879,
				name = "Inc Sack",
				itemId = 53332,
				amount = 3
			}
		}
	},
	{
		quality = 0,
		durability = 9,
		index = 104,
		formatDescription = "quality",
		slotName = "",
		name = "Star Fish Bait",
		progress = 550,
		profession = 8,
		clientId = 49338,
		itemId = 52791,
		experience = 8400,
		amount = 50,
		description = "Sets the chance of the next fish caught on your line being a Star Fish to 20% when fishing in the ocean.",
		tier = -1,
		category = "fishing bait",
		level = {
			single = 57,
			mass = 62
		},
		materials = {
			{
				clientId = 47959,
				name = "Concentrated Collagen",
				itemId = 51412,
				amount = 1
			},
			{
				clientId = 49877,
				name = "Foreign Alcohol",
				itemId = 53330,
				amount = 3
			}
		}
	},
	{
		quality = 0,
		durability = 10,
		index = 105,
		formatDescription = "quality",
		slotName = "",
		name = "Rainbow Flounder Bait",
		progress = 600,
		profession = 8,
		clientId = 49334,
		itemId = 52787,
		experience = 11500,
		amount = 50,
		description = "Sets the chance of the next fish caught on your line being a Rainbow Flounder to 20% when fishing in the ocean.",
		tier = -1,
		category = "fishing bait",
		level = {
			single = 67,
			mass = 72
		},
		materials = {
			{
				clientId = 47959,
				name = "Concentrated Collagen",
				itemId = 51412,
				amount = 2
			},
			{
				clientId = 49888,
				name = "Seahunter Eye",
				itemId = 53341,
				amount = 3
			}
		}
	},
	{
		quality = 0,
		durability = 10,
		index = 106,
		formatDescription = "quality",
		slotName = "",
		name = "Tiger Shark Bait",
		progress = 650,
		profession = 8,
		clientId = 49340,
		itemId = 52793,
		experience = 18000,
		amount = 50,
		description = "Sets the chance of the next fish caught on your line being a Tiger Shark to 20% when fishing in the ocean.",
		tier = -1,
		category = "fishing bait",
		level = {
			single = 77,
			mass = 82
		},
		materials = {
			{
				clientId = 47959,
				name = "Concentrated Collagen",
				itemId = 51412,
				amount = 2
			},
			{
				clientId = 49885,
				name = "Orca Blubber",
				itemId = 53338,
				amount = 3
			}
		}
	},
	{
		quality = 50,
		durability = 3,
		index = 107,
		formatDescription = "",
		slotName = "",
		name = "Fermented Potato Pulp",
		progress = 50,
		profession = 8,
		clientId = 49945,
		itemId = 53398,
		experience = 275,
		amount = 1,
		description = "Used for refining into alcohol. By mashing potatoes freshly harvested from the ground and adding water, any cook can produce this simple fermentation.",
		tier = -1,
		category = "ingredient",
		level = {
			single = 1,
			mass = 6
		},
		materials = {
			{
				clientId = 28874,
				name = "potato",
				itemId = 32306,
				amount = 16
			}
		}
	},
	{
		quality = 200,
		durability = 7,
		index = 108,
		formatDescription = "",
		slotName = "",
		name = "Fermented Corn Pulp",
		progress = 275,
		profession = 8,
		clientId = 49944,
		itemId = 53397,
		experience = 2000,
		amount = 1,
		description = "Used for refining into alcohol. With the proper balance between corn and the fermenting agent, seasoned cooks maximize the fermentation process.",
		tier = -1,
		category = "ingredient",
		level = {
			single = 35,
			mass = 40
		},
		materials = {
			{
				clientId = 28866,
				name = "corn",
				itemId = 32298,
				amount = 14
			},
			{
				clientId = 40833,
				name = "Red Fish Roe",
				itemId = 44285,
				amount = 9
			}
		}
	},
	{
		quality = 400,
		durability = 10,
		index = 109,
		formatDescription = "",
		slotName = "",
		name = "Fermented Wheat Pulp",
		progress = 450,
		profession = 8,
		clientId = 49946,
		itemId = 53399,
		experience = 5000,
		amount = 1,
		description = "Used for refining into alcohol. It's easy to beat wheat into a pulp, but only master cooks can expertly craft it into a superior fermenting base with minimal waste.",
		tier = -1,
		category = "ingredient",
		level = {
			single = 65,
			mass = 70
		},
		materials = {
			{
				clientId = 28881,
				name = "wheat",
				itemId = 32313,
				amount = 35
			},
			{
				clientId = 40828,
				name = "Fish Oil",
				itemId = 44280,
				amount = 25
			}
		}
	}
}
questRecipes = questRecipes or {}
questRecipes[ProfessionCooking] = {}
