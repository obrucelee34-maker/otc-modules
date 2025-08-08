-- chunkname: @/modules/game_infusion/config.lua

stats = {
	[STAT_MAXHITPOINTS] = "Maximum Health",
	[STAT_MAXMANAPOINTS] = "Maximum Mana",
	[STAT_ATTACKSPEED] = "Attack Speed",
	[STAT_ATTACK] = "Attack",
	[STAT_PHYSICALATTACK] = "Weapon Power",
	[STAT_MAGICATTACK] = "Spell Power",
	[STAT_DEFENSE] = "Defense",
	[STAT_PHYSICALDEFENSE] = "Weapon Defense",
	[STAT_MAGICDEFENSE] = "Spell Defense",
	[STAT_MIGHT] = "Might",
	[STAT_DEXTERITY] = "Dexterity",
	[STAT_HASTE] = "Haste",
	[STAT_INTELLIGENCE] = "Intelligence",
	[STAT_WISDOM] = "Wisdom",
	[STAT_SPELLCOOLDOWN] = "Spell cooldown",
	[STAT_RANGEBONUS] = "Range bonus",
	[STAT_SPEED] = "Movement Speed",
	[STAT_HEAL] = "Heal Power",
	[STAT_MANA_REGENERATION] = "Mana Regeneration",
	[STAT_HEALTH_REGENERATION] = "Health Regeneration",
	[STAT_CRITICAL_CHANCE] = "Precision",
	[STAT_CRITICAL_DAMAGE] = "Impact",
	[STAT_VITALITY] = "Vitality"
}
craftingStats = {
	[CRAFTING_STAT_MEND] = "Mend",
	[CRAFTING_STAT_TOUCH] = "Touch",
	[CRAFTING_STAT_SYNTHESIS] = "Synthesis",
	[CRAFTING_STAT_CONDITION] = "Condition"
}
equipSlots = {
	InventorySlotHead,
	InventorySlotBody,
	InventorySlotLeft,
	InventorySlotRight,
	InventorySlotFeet,
	InventorySlotLeg,
	InventorySlotFishingRod,
	InventorySlotFishingHook
}
equipSlotToName = {
	[InventorySlotHead] = "helmet",
	[InventorySlotBody] = "armor",
	[InventorySlotRight] = "right_hand",
	[InventorySlotLeft] = "left_hand",
	[InventorySlotLeg] = "legs",
	[InventorySlotFeet] = "boots",
	[InventorySlotFishingRod] = "fishing_rod",
	[InventorySlotFishingHook] = "fishing_hook"
}
itemTypes = {
	helmet = {
		["leather helmet"] = 1,
		["plate helmet"] = 1,
		helmet = 1,
		["cloth helmet"] = 1
	},
	armor = {
		["cloth armor"] = 1,
		["leather armor"] = 1,
		["plate armor"] = 1,
		armor = 1
	},
	legs = {
		legs = 1,
		["cloth legs"] = 1,
		["leather legs"] = 1,
		["plate legs"] = 1
	},
	boots = {
		["plate boots"] = 1,
		boots = 1,
		["cloth boots"] = 1,
		["leather boots"] = 1
	},
	weapon = {
		["light blade"] = 1,
		hammer = 1,
		greatsword = 1,
		greataxe = 1,
		bow = 1,
		club = 1,
		["tower shield"] = 1,
		["buckler shield"] = 1,
		sceptre = 1,
		axe = 1,
		sword = 1,
		dagger = 1,
		staff = 1
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
	["fishing rod"] = function(item)
		return item:getItemType() == "fishing rod"
	end,
	["fishing hook"] = function(item)
		return item:getItemType() == "fishing hook"
	end
}
