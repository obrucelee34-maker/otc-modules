-- chunkname: @/modules/game_profession/config.lua

professionOrder = {
	"Mining",
	"Woodcutting",
	"Farming",
	"Husbandry",
	"Fishing",
	"Blacksmithing",
	"Carpentry",
	"Weaving",
	"Cooking",
	"Breeding"
}
costPerExperience = 0.06
massCraftAmount = 10
professionIdToSound = {
	[ProfessionBlacksmithing] = 4147687917,
	[ProfessionCarpentry] = 2031244303,
	[ProfessionCooking] = 2339140365,
	[ProfessionWeaving] = 122785042,
	[ProfessionAlchemy] = 3150443978
}
resetCost = {
	dawnEssencePerPoint = 50
}
professionToOrder = {
	breeding = 11,
	cooking = 10,
	weaving = 9,
	carpentry = 8,
	blacksmithing = 7,
	fishing = 6,
	husbandry = 5,
	farming = 4,
	woodcutting = 3,
	herbalism = 2,
	mining = 1,
	alchemy = 12
}
professionToTitle = {
	breeding = "Attribute Ranges",
	cooking = "Materials",
	weaving = "Materials",
	carpentry = "Materials",
	blacksmithing = "Materials",
	fishing = "Slices",
	alchemy = "Materials"
}
traitToFormat = {
	weight = "kg",
	abilityChancePercent = "%",
	traitChancePercent = "%",
	height = "cm"
}
breedingAttributes = {
	strength = {
		icon = "strength",
		name = "Strength"
	},
	weight = {
		icon = "weight",
		name = "Weight"
	},
	traitChancePercent = {
		icon = "trait",
		name = "Trait Chance"
	},
	abilityTierCap = {
		icon = "ability",
		name = "Ability Tier Cap"
	},
	maxAbilities = {
		icon = "ability",
		name = "Ability Number"
	},
	abilityChancePercent = {
		icon = "ability",
		name = "Ability Chance"
	},
	height = {
		icon = "height",
		name = "Height"
	},
	speed = {
		icon = "speed",
		name = "Speed"
	}
}
passiveDescription = {
	mining = {
		experience = {
			text = "Increases mining experience gain by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		speed = {
			text = "Increases mining speed by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		resources = {
			text = "Grants %d%% chance to get a Plentiful Harvest when Mining, increasing the amount of materials by 50%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		rarity = {
			text = "Increases chance to yield gems from mining by %d%%.",
			values = {
				small = 5,
				medium = 8
			}
		},
		unique = {
			[1] = "Unlocks Swift Quarrying\n\nAfter mining a node you have a chance to gain 20% movement speed and mining speed buff for 30 seconds.",
			[2] = "Unlocks Gemstone Whisper\n\nAfter mining a node you have a chance to obtain a Miner's Blessing for 5 minutes, guaranteeing a higher tier on your next prospect."
		}
	},
	herbalism = {
		experience = {
			text = "Increases herbalism experience gain by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		speed = {
			text = "Increases herbalism speed by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		resources = {
			text = "Grants %d%% chance to get a Plentiful Harvest when gathering Herbalism crops in your land, increasing the amount of materials by 50%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		rarity = {
			text = "Increases chance to yield truffles from herbalism by %d%%.",
			values = {
				small = 5,
				medium = 8
			}
		},
		unique = {
			[1] = "Unlocks New Sprout\n\n2% chance to leave a new herb or mushroom behind for free when gathering on land.",
			[2] = "Unlocks Meticulous Herbalist\n\n10% for higher tier materials when gathering on land."
		}
	},
	woodcutting = {
		experience = {
			text = "Increases woodcutting experience gain by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		speed = {
			text = "Increases woodcutting speed by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		resources = {
			text = "Grants %d%% chance to get a Plentiful Harvest when cutting trees in your land, increasing the amount of materials by 50%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		rarity = {
			text = "Increases chance to yield dense log from woodcutting in your land by %d%%.",
			values = {
				small = 5,
				medium = 8
			}
		},
		unique = {
			[1] = "Unlocks Dense Timber\n\n1% chance your cutdown tree in Open World is all dense logs instead of normal logs.",
			[2] = "Unlocks Seasoned Lumberjack\n\n10% chance the quality of your logs are higher tier."
		}
	},
	farming = {
		experience = {
			text = "Increases farming experience gain by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		speed = {
			text = "Increases harvesting speed by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		resources = {
			text = "Grants %d%% chance to get a Plentiful Harvest when gathering Farming crops, increasing the amount of materials by 50%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		rarity = {
			text = "Increases chance to yield three-leaf clover from harvesting by %d%%.",
			values = {
				small = 5,
				medium = 8
			}
		},
		unique = {
			[1] = "Spicy Flavors\n\nUnlocks the planting of Peppers.",
			[2] = "Cherry-Picking\n\nUnlocks the planting of Cherries."
		}
	},
	husbandry = {
		experience = {
			text = "Increases husbandry experience gain by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		speed = {
			text = "Increases gathering and butchering speed by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		resources = {
			text = "Grants %d%% chance to get a Plentiful Harvest when gathering from Husbandry animals, increasing the amount of materials by 50%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		rarity = {
			text = "Increases chance to yield fertilizer from gathering animals by %d%%.",
			values = {
				small = 5,
				medium = 8
			}
		},
		unique = {
			[1] = "Beekeeper\n\nUnlocks the cultivation of Bee Hives.",
			[2] = "Fermenting Barrels\n\nUnlocks the use of fermentation to turn Milk into Cheese."
		}
	},
	fishing = {
		experience = {
			text = "Increases fishing experience gain by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		speed = {
			text = "Increases speed of getting fish on the line by %d%%.",
			values = {
				small = 5,
				medium = 8
			}
		},
		resources = {
			text = "Fishing abilities deal %d%% more damage.",
			values = {
				small = 3,
				medium = 5
			}
		},
		rarity = {
			text = "Increases fish weight by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		unique = {
			[1] = "Unlocks Swift Angler\n\nCatching a fish has a 20% chance to increase the speed of your next cast within 3 minutes by 80%.",
			[2] = "Unlocks Fortune Fisher\n\n1% Chance to fish up a treasure chest with your fish based on the weight of the fish."
		}
	},
	cooking = {
		experience = {
			text = "Increases cooking experience gain by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		speed = {
			text = "Increases cooking labor by %d.",
			values = {
				small = 5,
				medium = 8
			}
		},
		resources = {
			text = "Increases effectiveness of Synthesis abilities by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		rarity = {
			text = "Increases effectiveness of Touch abilities by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		unique = {
			[1] = "Unlocks Focused Mend\n\nRestores 4 durability, 100% chance of success.",
			[2] = "Unlocks Touch of Salt\n\nIncreases effectiveness of Touch abilities by 20% for the next 3 turns."
		},
		specialization = {
			"Sommelier\n\nUnlocks advanced Drink recipes.",
			"Pastry Expert\n\nUnlocks advanced Baked Goods recipes.",
			"Gourmet Chef\n\nUnlocks advanced Meals recipes."
		}
	},
	blacksmithing = {
		experience = {
			text = "Increases blacksmithing experience gain by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		speed = {
			text = "Increases blacksmithing labor by %d.",
			values = {
				small = 5,
				medium = 8
			}
		},
		resources = {
			text = "Increases effectiveness of Synthesis abilities by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		rarity = {
			text = "Increases effectiveness of Touch abilities by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		unique = {
			[1] = "Unlocks Smither's Synthesis\n\nAdds 200 crafting progress. 75% chance of success.",
			[2] = "Unlocks Firm Grip\n\nIncreases effectiveness of Synthesis abilities by 20% for next 3 performed actions."
		},
		specialization = {
			"Dwarven Weaponsmith\n\nUnlocks advanced Weapon recipes.",
			"Dwarven Armorsmith\n\nUnlocks advanced Plate Armor recipes.",
			"Craftsman\n\nUnlocks advanced recipes for Fishing Hook and consumables."
		}
	},
	carpentry = {
		experience = {
			text = "Increases carpentry experience gain by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		speed = {
			text = "Increases carpentry labor by %d.",
			values = {
				small = 5,
				medium = 8
			}
		},
		resources = {
			text = "Increases effectiveness of Synthesis abilities by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		rarity = {
			text = "Increases effectiveness of Touch abilities by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		unique = {
			[1] = "Unlocks Carpenter's Shine\n\nIncreases next crafting condition quality chance by 100%. 75% chance of success.",
			[2] = "Unlocks New Tools\n\nCrafting durability won't be reduced for next 3 performed actions."
		},
		specialization = {
			"Angler Carpenter\n\nUnlocks advanced Fishing Rod recipes",
			"Fletcher\n\nUnlocks advanced Weapon recipes.",
			"Joiner\n\nUnlocks advanced Furniture recipes used in housing."
		}
	},
	weaving = {
		experience = {
			text = "Increases weaving experience gain by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		speed = {
			text = "Increases weaving labor by %d.",
			values = {
				small = 5,
				medium = 8
			}
		},
		resources = {
			text = "Increases effectiveness of Synthesis abilities by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		rarity = {
			text = "Increases effectiveness of Touch abilities by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		unique = {
			[1] = "Unlocks Precision Touch\n\nAdds 200 crafting quality. 75% chance of success.",
			[2] = "Unlocks Steady Hand\n\nIncreases the success chance of the next action by 30%."
		},
		specialization = {
			"Tailor\n\nUnlocks advanced Cloth Armor recipes",
			"Patchworker\n\nUnlocks advanced Leather Armor recipes.",
			"Sailmaker\n\nUnlocks advanced Sail recipes."
		}
	},
	breeding = {
		experience = {
			text = "Increases breeding experience gain by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		speed = {
			text = "Feeding a Moa during Maturing Phase decreases its time by %d minutes.",
			values = {
				small = 30,
				medium = 90
			}
		},
		resources = {
			text = "Increases the chance at breeding a Moa with a trait by %d%%.",
			values = {
				small = 2,
				medium = 5
			}
		},
		rarity = {
			text = "Increases maximum tier swing by %d%%.",
			values = {
				small = 2,
				medium = 4
			}
		},
		unique = {
			[1] = "Unlocks Attentive Breeder\n\nIncreases the chance of a moa being born with an ability by 10%.",
			[2] = "Unlocks Genetic Mastermind\n\nIncreases the chance of a moa being born with a trait by 15%."
		}
	},
	alchemy = {
		experience = {
			text = "Increases alchemy experience gain by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		speed = {
			text = "Increases alchemy labor by %d.",
			values = {
				small = 5,
				medium = 8
			}
		},
		resources = {
			text = "Increases effectiveness of Synthesis abilities by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		rarity = {
			text = "Increases effectiveness of Touch abilities by %d%%.",
			values = {
				small = 3,
				medium = 5
			}
		},
		unique = {
			[1] = "Unlocks Stabilize Mixture\n\nIf you critically strike within the next 4 actions, the item's durability will be restored by 3.",
			[2] = "Unlocks Distil\n\nEnhances your critical strike chance by 30% for the next 5 turns."
		},
		specialization = {
			"Poisoner\n\nUnlocks advanced recipes for poisons.",
			"Concoctionist\n\nUnlocks advanced recipes for potions.",
			"Thaumaturgist\n\nUnlocks advanced recipes for elixirs."
		}
	}
}
passiveTypeName = {
	"experience",
	"speed",
	"resources",
	"rarity",
	"unique",
	"specialization"
}
passiveNameType = {
	speed = 2,
	unique = 5,
	specialization = 6,
	experience = 1,
	rarity = 4,
	resources = 3
}
categoryIndexes = {
	cooking = {
		["baked goods"] = 2,
		ingredient = 1,
		misc = 6,
		["fishing bait"] = 5,
		meals = 4,
		drinks = 3
	},
	weaving = {
		armor = 4,
		threads = 3,
		leather = 2,
		cloth = 1,
		["ship attachments"] = 7,
		housing = 6,
		["crafting garments"] = 5
	},
	carpentry = {
		["ship attachments"] = 7,
		["wagon components"] = 5,
		["housing components"] = 4,
		weapons = 2,
		planks = 1,
		fishing = 3,
		["ship components"] = 6
	},
	blacksmithing = {
		whetstones = 4,
		fishing = 6,
		materials = 5,
		weapons = 2,
		armors = 3,
		ingots = 1,
		["housing components"] = 7,
		["ship attachments"] = 8
	},
	alchemy = {
		potion = 2,
		material = 1,
		misc = 5,
		poison = 4,
		elixir = 3
	}
}
chanceNameType = {
	{
		"Common",
		37.5
	},
	{
		"Uncommon",
		15
	},
	{
		"Rare",
		3
	},
	{
		"Very-Rare",
		0.6
	},
	{
		"Ultra-Rare",
		0.3
	},
	{
		"Mythic-Rare",
		0.1
	}
}
craftingRecipesByName = {}

for i = ProfessionFirst, ProfessionLast do
	local recipes = recipes[i]

	for _, recipe in pairs(recipes or {}) do
		craftingRecipesByName[recipe.name] = i
	end
end

craftingFiltersOrder = {
	"Recipe",
	"Materials"
}
craftingFilters = {
	Recipe = {
		[1] = "Locked",
		[2] = "Unlocked"
	},
	Materials = {
		[1] = "Available",
		[2] = "Unvailable"
	}
}
craftingFiltersCallback = {
	Recipe = {
		Locked = function(player, recipe)
			return recipe.level.single > player:getProfessionLevel(recipe.profession)
		end,
		Unlocked = function(player, recipe)
			return recipe.level.single <= player:getProfessionLevel(recipe.profession)
		end
	},
	Materials = {
		Available = function(player, recipe)
			return GameProfessions:hasRecipeMaterials(player, recipe)
		end,
		Unvailable = function(player, recipe)
			return not GameProfessions:hasRecipeMaterials(player, recipe)
		end
	}
}
