-- chunkname: @/modules/game_market/config.lua

dofile("marketable_items.lua")

ENABLE_RAVENCOINS = false
CATEGORY_ALL_ITEMS = 0
CATEGORY_RAVENCOIN = 127
DUMMY_RAVENCOIN_ITEMID = 1

if not ENABLE_RAVENCOINS then
	MarketableItemsByCategory[DUMMY_RAVENCOIN_ITEMID] = nil
	MarketableItemsById[DUMMY_RAVENCOIN_ITEMID] = nil
	MarketableItemsByTier[DUMMY_RAVENCOIN_ITEMID] = nil
	MarketableItemsByName.ravencoin = nil
end

maximumFilterAmount = 10
offersPerPage = 9
minLockDuration = 1500
offersPerPageActiveOffers = 8
offersPerPageCompletedOffers = 9
offersPerPageSimilarOffers = 4
minPricePerPiece = 20
timeForReloadingAfterPageNumberChange = 500
taxCreateSellOfferMultiplier = 1.04
taxCreateSellOfferPremiumMultiplier = 1.02
taxCreateBuyOfferMultiplier = 1.08
taxCreateBuyOfferPremiumMultiplier = 1.04
taxSellOfferMultiplier = 0.96
taxSellOfferPremiumMultiplier = 0.98
maximumPrimaryAttributes = {
	[0] = 0,
	0,
	1,
	1,
	2,
	2,
	2,
	2
}
maximumSecondaryAttributes = {
	[0] = 0,
	0,
	0,
	1,
	1,
	2,
	3,
	3
}
maximumExtraSecondaryAttributes = {
	[0] = 0,
	0,
	0,
	0,
	0,
	0,
	0,
	1
}
maximumCraftingAttributes = {
	0,
	1,
	2
}
orderType = {
	nil,
	nil,
	nil,
	nil,
	"amount",
	"time",
	"price"
}
offerType = {
	sell_offers = 0,
	buy_offers = 1
}
activeOffersOrderType = {
	"transaction",
	"time",
	nil,
	nil,
	nil,
	"amount",
	"price"
}
completedOffersOrderType = {
	"transaction",
	"status",
	"timestamp",
	nil,
	nil,
	"amount",
	"price"
}
similarOffersOrderType = {
	[2] = "amount",
	[3] = "price"
}
OFFER_STATE_ACTIVE = 1
OFFER_STATE_EXPIRED = 2
OFFER_STATE_BOUGHT_OUT = 3
OFFER_STATE_CANCELLED = 4
OFFER_STATE_COMPLETED = 5
HISTORY_TYPE_CREATE = 1
HISTORY_TYPE_CANCEL = 2
HISTORY_TYPE_BOUGHT = 3
HISTORY_TYPE_EXPIRE = 4
HISTORY_TYPE_COMPLETE = 5
HISTORY_TYPE_PREMIUM_COMPLETED_AWAITING = 6
HISTORY_TYPE_PREMIUM_EXPIRED_AWAITING = 7
offerStateText = {
	[HISTORY_TYPE_CANCEL] = "Cancelled",
	[HISTORY_TYPE_COMPLETE] = "Completed",
	[HISTORY_TYPE_EXPIRE] = "Expired",
	[HISTORY_TYPE_BOUGHT] = "Completed",
	[HISTORY_TYPE_PREMIUM_COMPLETED_AWAITING] = "Pending",
	[HISTORY_TYPE_PREMIUM_EXPIRED_AWAITING] = "Pending"
}
offerStateColor = {
	[HISTORY_TYPE_CANCEL] = "#fbfb79",
	[HISTORY_TYPE_COMPLETE] = "#77D463",
	[HISTORY_TYPE_EXPIRE] = "#FF5151",
	[HISTORY_TYPE_BOUGHT] = "#77D463",
	[HISTORY_TYPE_PREMIUM_COMPLETED_AWAITING] = "#fbfb79",
	[HISTORY_TYPE_PREMIUM_EXPIRED_AWAITING] = "#fbfb79"
}
OFFER_TYPE_SELL = 0
OFFER_TYPE_BUY = 1
categories = {
	weapons = {
		axes = {
			index = 1,
			id = 1
		},
		swords = {
			index = 2,
			id = 2
		},
		clubs = {
			index = 3,
			id = 3
		},
		daggers = {
			index = 4,
			id = 4
		},
		greataxes = {
			index = 5,
			id = 5
		},
		greatswords = {
			index = 6,
			id = 6
		},
		hammers = {
			index = 7,
			id = 7
		},
		["light blades"] = {
			index = 8,
			id = 8
		},
		["buckler shields"] = {
			index = 9,
			id = 9
		},
		["tower shields"] = {
			index = 10,
			id = 54
		},
		sceptres = {
			index = 11,
			id = 10
		},
		staves = {
			index = 12,
			id = 11
		},
		bows = {
			index = 13,
			id = 12
		}
	},
	equipment = {
		helmets = {
			index = 1,
			id = 13
		},
		armors = {
			index = 2,
			id = 14
		},
		legs = {
			index = 3,
			id = 15
		},
		boots = {
			index = 4,
			id = 16
		},
		amulets = {
			index = 5,
			id = 17
		},
		trinkets = {
			index = 6,
			id = 18
		},
		rings = {
			index = 7,
			id = 19
		}
	},
	["profession equipment"] = {
		fishing = {
			index = 1,
			id = 20
		},
		blacksmithing = {
			index = 2,
			id = 21
		},
		carpentry = {
			index = 3,
			id = 22
		},
		weaving = {
			index = 4,
			id = 23
		},
		cooking = {
			index = 5,
			id = 24
		},
		alchemy = {
			index = 6,
			id = 62
		}
	},
	enchantments = {
		weapons = {
			index = 1,
			id = 25
		},
		helmets = {
			index = 2,
			id = 26
		},
		armors = {
			index = 3,
			id = 27
		},
		legs = {
			index = 4,
			id = 28
		},
		boots = {
			index = 5,
			id = 29
		}
	},
	consumables = {
		["baked goods"] = {
			index = 1,
			id = 30
		},
		drinks = {
			index = 2,
			id = 31
		},
		meals = {
			index = 3,
			id = 32
		},
		potions = {
			index = 4,
			id = 33
		},
		elixirs = {
			index = 5,
			id = 34
		},
		poisons = {
			index = 6,
			id = 35
		},
		whetstones = {
			index = 7,
			id = 36
		},
		breeding = {
			index = 8,
			id = 37
		},
		["fishing bait"] = {
			index = 9,
			id = 57
		}
	},
	["raw materials"] = {
		mining = {
			index = 1,
			id = 38
		},
		woodcutting = {
			index = 2,
			id = 39
		},
		farming = {
			index = 3,
			id = 40
		},
		husbandry = {
			index = 4,
			id = 41
		},
		fishing = {
			index = 5,
			id = 42
		},
		herbalism = {
			index = 6,
			id = 60
		},
		breeding = {
			index = 7,
			id = 64
		},
		others = {
			index = 8,
			id = 58
		}
	},
	["refined materials"] = {
		blacksmithing = {
			index = 1,
			id = 43
		},
		carpentry = {
			index = 2,
			id = 44
		},
		weaving = {
			index = 3,
			id = 45
		},
		cooking = {
			index = 4,
			id = 46
		},
		alchemy = {
			index = 5,
			id = 61
		}
	},
	transports = {
		["ship parts"] = {
			index = 1,
			id = 47
		},
		["wagon parts"] = {
			index = 2,
			id = 48
		},
		moa = {
			index = 3,
			id = 55
		},
		["moa equipment"] = {
			index = 4,
			id = 52
		}
	},
	["cosmetic materials"] = {
		["outfit cosmetics"] = {
			index = 1,
			id = 53
		}
	},
	others = {
		infusions = {
			index = 1,
			id = 49
		},
		["creature products"] = {
			index = 2,
			id = 50
		},
		["creature trophies"] = {
			index = 3,
			id = 56
		},
		["ocean trophies"] = {
			index = 4,
			id = 63
		},
		["aether trophies"] = {
			index = 5,
			id = 59
		},
		["housing rooms"] = {
			index = 6,
			id = 51
		}
	}
}
categoriesById = {}

for category, subcategories in pairs(categories) do
	for subcategory, data in pairs(subcategories) do
		categoriesById[data.id] = subcategory
	end
end

gradeCompatibleCategories = {
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	9,
	10,
	11,
	12,
	13,
	14,
	15,
	16,
	20,
	21,
	22,
	23,
	24,
	54
}
craftingAttributesCompatibleCategories = {
	21,
	22,
	23,
	24
}
attributesCompatibleCategories = {
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	9,
	10,
	11,
	12,
	13,
	14,
	15,
	16,
	21,
	22,
	23,
	24,
	54
}
excludeGradeAndAttributesCategories = {
	17,
	18,
	19,
	25,
	26,
	27,
	28,
	29,
	33,
	53
}
extraSecondaryAttributesCompatibleTiers = {
	7
}
categoriesOrder = {
	"weapons",
	"equipment",
	"profession equipment",
	"enchantments",
	"consumables",
	"raw materials",
	"refined materials",
	"transports",
	"cosmetic materials",
	"others"
}
filtersOrder = {
	"primary attribute",
	"secondary attribute",
	"extra secondary",
	"armor type",
	"grade",
	"tier",
	"quality"
}
createOfferFiltersOrder = {
	"primary attribute",
	"secondary attribute"
}
filterExtraSecondaryName = "extra secondary"
filters = {
	["primary attribute"] = {
		"dexterity",
		"intelligence",
		"might",
		"vitality",
		"wisdom"
	},
	["secondary attribute"] = {
		"maximum health",
		"maximum mana",
		"weapon power",
		"spell power",
		"weapon defense",
		"spell defense",
		"haste",
		"healing power",
		"mana regeneration",
		"health regeneration",
		"impact",
		"precision"
	},
	["extra secondary"] = {
		"maximum health",
		"maximum mana",
		"weapon power",
		"spell power",
		"weapon defense",
		"spell defense",
		"haste",
		"healing power",
		"mana regeneration",
		"health regeneration",
		"impact",
		"precision"
	},
	["crafting attribute"] = {
		"touch",
		"synthesis"
	},
	["armor type"] = {
		"cloth",
		"leather",
		"plate"
	},
	grade = {
		"basic",
		"grand",
		"rare",
		"arcane",
		"celestial",
		"ascendant",
		"heroic",
		"mythic",
		"legendary",
		"legendary plus",
		"legendary max"
	},
	tier = {
		"tier 1",
		"tier 2",
		"tier 3",
		"tier 4",
		"tier 5",
		"tier 6",
		"tier 7"
	},
	quality = {
		"normal",
		"high",
		"superior",
		"artisan"
	}
}
