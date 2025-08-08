-- chunkname: @/modules/game_lootnotification/config.lua

maxDisplayWidgets = 6
entryVisibleDuration = 3000
entryHeight = 40
LOOT_TYPE_DEFAULT = 1
LOOT_TYPE_ITEM = 2
LOOT_TYPE_PROFESSION = 3
LOOT_TYPE_OUTFIT = 4
ItemQualityColors = table.copy(ItemQualityColors)
ItemQualityColors[0] = "#000000"
allowedSourceIcon = {
	rangers_company = true,
	artifacts = true,
	dynamic_event = true
}
soundEvents = {
	[1699745885] = 2,
	[1699745886] = 1,
	[1699745884] = 3,
	[1699745883] = 4
}
soundEventsByTier = {
	1699745886,
	1699745885,
	1699745884,
	1699745883
}
rarityToSound = {
	[0] = soundEventsByTier[1],
	soundEventsByTier[2],
	soundEventsByTier[2],
	soundEventsByTier[3],
	soundEventsByTier[4],
	soundEventsByTier[4],
	soundEventsByTier[4],
	soundEventsByTier[4],
	["Quest Item"] = soundEventsByTier[2],
	Ravenpack = soundEventsByTier[4],
	["Dawn Essence"] = soundEventsByTier[4],
	["Creature Trophy"] = soundEventsByTier[4],
	["Ocean Trophy"] = soundEventsByTier[4],
	["Cosmetic Material"] = soundEventsByTier[4],
	["Aether Rift Charge"] = soundEventsByTier[4],
	["Mount Armor"] = soundEventsByTier[4]
}
rarityToSoundTier = {
	[0] = 1,
	2,
	2,
	3,
	4,
	4,
	4,
	4,
	["Ocean Trophy"] = 4,
	["Creature Trophy"] = 4,
	["Dawn Essence"] = 4,
	Ravenpack = 4,
	["Quest Item"] = 2,
	["Mount Armor"] = 4,
	["Aether Rift Charge"] = 4,
	["Cosmetic Material"] = 4
}
