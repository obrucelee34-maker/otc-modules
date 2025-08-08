-- chunkname: @/modules/game_inventory/config.lua

local foodClientIds = {
	[34863] = true,
	[28882] = true,
	[28767] = true,
	[28760] = true,
	[28757] = true,
	[34855] = true,
	[34856] = true,
	[28759] = true,
	[28758] = true,
	[34860] = true,
	[35402] = true,
	[34870] = true,
	[34850] = true,
	[34869] = true,
	[35403] = true,
	[34868] = true,
	[34866] = true,
	[34867] = true,
	[28765] = true,
	[28756] = true,
	[34858] = true,
	[34865] = true,
	[35401] = true,
	[34864] = true,
	[28766] = true,
	[28883] = true,
	[28754] = true,
	[34862] = true,
	[35399] = true,
	[34861] = true,
	[28755] = true,
	[28753] = true,
	[35686] = true,
	[34859] = true,
	[35400] = true,
	[34857] = true,
	[35398] = true,
	[35397] = true,
	[34854] = true,
	[34853] = true,
	[34852] = true,
	[34851] = true,
	[28764] = true,
	[34849] = true,
	[34848] = true,
	[34847] = true,
	[33969] = true,
	[28761] = true
}

itemTypes = {
	helmet = {
		["cloth helmet"] = 1,
		["leather helmet"] = 1,
		["plate helmet"] = 1,
		helmet = 1
	},
	armor = {
		["cloth armor"] = 1,
		["leather armor"] = 1,
		["plate armor"] = 1,
		armor = 1
	},
	legs = {
		["cloth legs"] = 1,
		["leather legs"] = 1,
		["plate legs"] = 1,
		legs = 1
	},
	boots = {
		["cloth boots"] = 1,
		["leather boots"] = 1,
		["plate boots"] = 1,
		boots = 1
	},
	weapon = {
		axe = 1,
		sword = 1,
		dagger = 1,
		["buckler shield"] = 1,
		staff = 1,
		["light blade"] = 1,
		["tower shield"] = 1,
		club = 1,
		hammer = 1,
		greatsword = 1,
		greataxe = 1,
		bow = 1,
		sceptre = 1
	}
}
filter = {
	all = function()
		return true
	end,
	infusion = function(item)
		if item:getItemType() == "" and item:getName():lower():find("infusion", 1, true) then
			return true
		end
	end,
	potion = function(item)
		if item:getItemType() == "" and item:getName():lower():find("potion", 1, true) then
			return true
		end
	end,
	food = function(item)
		return foodClientIds[item:getId()]
	end,
	helmet = function(item)
		if itemTypes.helmet[item:getItemType()] then
			return true
		end
	end,
	armor = function(item)
		if itemTypes.armor[item:getItemType()] then
			return true
		end
	end,
	legs = function(item)
		if itemTypes.legs[item:getItemType()] then
			return true
		end
	end,
	boots = function(item)
		if itemTypes.boots[item:getItemType()] then
			return true
		end
	end,
	weapon = function(item)
		if itemTypes.weapon[item:getItemType()] then
			return true
		end
	end,
	trinket = function(item)
		return item:getItemType() == "trinket"
	end,
	["fishing rod"] = function(item)
		return item:getItemType() == "fishing rod"
	end,
	["fishing hook"] = function(item)
		return item:getItemType() == "fishing hook"
	end,
	["land deed"] = function(item)
		if item:getItemType() == "" and item:getName():lower():find("land deed", 1, true) then
			return true
		end
	end
}
inventory = {
	rowsPerUnlock = 1,
	baseRavencoinCost = 400,
	backpackUnlockLevel = 15,
	backpackLimit = 5,
	maxRowsUnlocked = 22,
	baseSilverUnlockCost = {
		2500,
		5000,
		10000,
		15000,
		20000
	},
	backpackSlots = {
		[InventorySlotBack2] = true,
		[InventorySlotBack3] = true,
		[InventorySlotBack4] = true,
		[InventorySlotBack5] = true,
		[InventorySlotBack6] = true
	},
	backpackCategoryNames = {
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
	backpackCategoryIds = {
		["Crafted Materials"] = 7,
		["Gathered Materials"] = 6,
		Consumables = 5,
		Enchantments = 4,
		["Profession Equipment"] = 3,
		Equipment = 13,
		Infusions = 12,
		["Creature Products"] = 11,
		Cosmetics = 9,
		Transport = 8
	},
	backpackCategoryNameIds = {}
}

for k, v in pairs(inventory.backpackCategoryIds) do
	inventory.backpackCategoryNameIds[v] = k
end
