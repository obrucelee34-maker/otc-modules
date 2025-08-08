-- chunkname: @/modules/game_npcs/config.lua

icons = {
	"order",
	"mercenary",
	"villain",
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	"message",
	"history",
	"shop"
}
callbacks = {
	npc_greet = function(data)
		GameNpc:onGreet(data)
	end,
	npc_reply = function(data)
		GameNpc:onReply(data)
	end,
	npc_ungreet = function(data)
		GameNpc:onClose(true)
	end,
	npc_warehouse = function(data)
		PortWarehouse:onOpen(data)
	end,
	npc_tradepost_craft = function(data)
		Tradepost:onOpenCraft(data)
	end,
	npc_tradepost_sell = function(data)
		Tradepost:onOpenSell(data)
	end,
	npc_fishpost = function(data)
		Fishpost:onOpen(data)
	end,
	npc_builder = function(data)
		BuilderShop:show(data)
	end,
	npc_arena = function(data)
		modules.game_arena.show()
	end,
	house_depot = function(data)
		GameBank.show()
	end,
	npc_rangerscompany_shop = function(data)
		RangersCompanyShop:onOpenNpcTrade(data)
	end,
	npc_rangerscompany_specialshop = function(data)
		RangersCompanySpecialShop:onOpenNpcTrade(data)
	end,
	npc_rangerscompany_specialshop_limits = function(data)
		RangersCompanySpecialShop:updateLimits(data)
	end,
	npc_marketplace = function(data)
		modules.game_market.GameMarket:show()
	end,
	npc_gear_breakdown = function(data)
		GearBreakdownShop:onOpenNpcTrade(data)
	end,
	npc_culled_eyes = function(data)
		CulledEyesShop:onOpenNpcTrade(data)
	end,
	npc_accessory_shop = function(data)
		AccessoryShop:onOpenNpcTrade(data)
	end,
	npc_moa_exchange = function(data)
		MoaExchange:show(data)
	end,
	npc_aether_echo = function(data)
		modules.game_aether_echo.GameAetherEcho:configureAetherEchoWindow(data.difficulty, true)
	end,
	npc_event_shop = function(data)
		HarvestShop:onOpenNpcTrade(data)
	end,
	npc_event_coins = function(data)
		HarvestShop:onUpdateHarvestCoins(data.coins)
	end,
	npc_general_shop = function(data)
		GeneralShop:onOpenNpcTrade(data)
	end
}
windowTypes = {
	moa_exchange_shop = "GameMoaExchangeShopPanel",
	tradepost_craft = "GameTradepostCraftPanel",
	accessory_shop = "GameAccessoryShopPanel",
	warehouse = "GameWarehousePanel",
	culled_eyes_shop = "GameCulledEyesShopPanel",
	itemshop = "GameItemShopPanel",
	gear_breakdown_shop = "GameGearBreakdownShopPanel",
	bank = "GameBankPanel",
	rangers_company_specialshop = "GameRangersCompanySpecialShopPanel",
	dialogue = "GameDialoguePanel",
	rangers_company_shop = "GameRangersCompanyShopPanel",
	harvest_shop = "GameHarvestShopPanel",
	general_shop = "GameGeneralShopPanel",
	fishpost = "GameFishpostPanel",
	tradepost_sell = "GameTradepostSellPanel"
}
bank = {
	lastVaultId = 504,
	firstVaultId = 500,
	maxRowsUnlocked = 25,
	rowsPerUnlock = 1,
	vaultLimit = 5,
	vaultUnlockLevel = 15,
	baseRavencoinCost = 300,
	baseSilverUnlockCost = {
		1500,
		3000,
		5000
	},
	vaultCategoryNames = {
		"Equipment",
		"Profession Equipment",
		"Enchantments",
		"Consumables",
		"Gathered Materials",
		"Crafted Materials",
		"Transport",
		"Cosmetics",
		"Creature Products",
		"Infusions"
	},
	vaultCategoryIds = {
		Infusions = 12,
		["Creature Products"] = 11,
		Cosmetics = 9,
		Transport = 8,
		["Crafted Materials"] = 7,
		["Gathered Materials"] = 6,
		Consumables = 5,
		Enchantments = 4,
		["Profession Equipment"] = 3,
		Equipment = 13
	},
	vaultCategoryNameIds = {}
}

for k, v in pairs(bank.vaultCategoryIds) do
	bank.vaultCategoryNameIds[v] = k
end

moaExchangeSilverCost = {
	nil,
	5000,
	20000,
	40000,
	70000,
	120000
}
protectionLevel = 20
deliverTradepackEffortCost = 0
craftTradepackEffortCost = 1000
tradepostFiltersOrder = {
	"Recipes",
	"Materials"
}
tradepostFilters = {
	Recipes = {
		[1] = "Locked",
		[2] = "Unlocked"
	},
	Materials = {
		[1] = "Available",
		[2] = "Unvailable"
	}
}
tradepostFiltersCallback = {
	Recipes = {
		Locked = function(player, recipe)
			return not recipe.active or not recipe.demand
		end,
		Unlocked = function(player, recipe)
			return recipe.active and recipe.demand
		end
	},
	Materials = {
		Available = function(player, recipe)
			return Tradepost:hasRecipeMaterials(player, recipe)
		end,
		Unvailable = function(player, recipe)
			return not Tradepost:hasRecipeMaterials(player, recipe)
		end
	}
}
