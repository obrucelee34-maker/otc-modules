-- chunkname: @/modules/game_worldmap/worldmap.lua

local defaultMarks = {}

for _, port in pairs(Ports) do
	table.insert(defaultMarks, {
		maxZoom = 10,
		minZoom = 3,
		pos = port.pos,
		type = MAPMARK_SEAPORT,
		description = port.description
	})
end

for id, event in pairs(DynamicEvents) do
	table.insert(defaultMarks, {
		maxZoom = 10,
		minZoom = 1,
		pos = event.pos,
		type = MAPMARK_DYNAMICEVENT,
		description = event.name,
		onClick = function(widget)
			onDynamicEventClicked(widget, id)
		end
	})
end

for id, region in pairs(Regions) do
	table.insert(defaultMarks, {
		style = "WorldMapIconAndBottomText",
		maxZoom = 10,
		minZoom = 1,
		pos = region.pos,
		type = MAPMARK_REGION_CONFLICT,
		description = region.name,
		data = region.data,
		onHoverChange = function(widget, hovered)
			onConflictIconClicked(widget, id, nil, hovered)
		end
	})
end

for profession, data in pairs(CraftingStations) do
	for _, station in pairs(data) do
		local pos = {
			x = station.from.x + math.floor((station.to.x - station.from.x) / 2),
			y = station.from.y + math.floor((station.to.y - station.from.y) / 2),
			z = station.from.z
		}

		table.insert(defaultMarks, {
			maxZoom = 10,
			minZoom = 3,
			pos = pos,
			type = MAPMARK_CRAFTING_STATION,
			description = string.format("%s %s", ProfessionNames[profession], "Station"),
			profession = profession
		})
	end
end

table.insert(defaultMarks, {
	maxZoom = 10,
	minZoom = 3,
	description = "Market",
	pos = {
		z = 6,
		y = 5108,
		x = 5146
	},
	type = MAPMARK_MARKET
})
table.insert(defaultMarks, {
	maxZoom = 10,
	minZoom = 3,
	description = "Moa Merchant",
	pos = {
		z = 7,
		y = 5201,
		x = 5173
	},
	type = MAPMARK_MOA_MERCHANT
})

for _, npc in ipairs(GeneralNpcs) do
	local data = {
		pos = npc.pos,
		type = npc.type,
		description = npc.description,
		minZoom = npc.minZoom or 3,
		maxZoom = npc.maxZoom or 10
	}

	if npc.type == MAPMARK_TRADEPOST then
		function data.onClick(widget)
			onTradepostClicked(widget, npc.tradepostId)
		end
	end

	table.insert(defaultMarks, data)
end

for _, waypoint in ipairs(Waypoints) do
	table.insert(defaultMarks, {
		maxZoom = 10,
		minZoom = 3,
		description = "Respawn Shrine",
		pos = waypoint.position,
		type = MAPMARK_RESPAWN_SHRINE
	})
end

local defaultZones = {}

for id, data in pairs(ZonesInfo) do
	table.insert(defaultZones, {
		pos = data.pos,
		type = MAPMARK_ZONE,
		name = data.name,
		wordBreaks = data.wordBreaks,
		minLevel = data.minLevel,
		maxLevel = data.maxLevel
	})
end

iconFilterPanel = nil
clickableAreas = {}

local tradepackList, sortNameButton, sortDemandButton

searchEdit = nil
lastSortButton = nil

local sortedRecipes = {}
local searchRecipes = {}
local sort = {
	type = "",
	direction = "descending"
}
local tradepostPanel, regionInfoPanel, houseInfoPanel, dynamicEventInfoPanel
local tradepackWidgets = {}
local lastPostId = 0
local lastRegionId = 0
local lastEventId = 0
local regionConflictTimerEvent, houseTimerEvent, playerCurrentFloor
local regionConflictDuration = 3600
local regionConflictDescription = {
	peace_warzone = "This region is in a state of peace, but soon transitioning into a warzone. Players cannot commit murder until the timer reaches zero. Once the region becomes a warzone, players will be able to engage in combat. Infamy is not gained for killing players, and players who are already \"murderers\" do not lose infamy when killed.",
	conflict = "This region is currently in conflict. Murder can be committed by players during this time.",
	peace_warmode = "This region is currently in peace. No murder can be committed by players during this time.",
	peace = "This region is currently in peace. No murder can be committed by players during this time.",
	warzone_peace = "This region is a warzone, but transitioning into a state of peace. Players can engage in combat and commit murder until the timer reaches 0. Infamy is not gained for killing players, and players who are already \"murderers\" do not lose infamy when killed.",
	warzone = "This region is a warzone. Players can freely engage in combat and commit murder without consequences. Infamy is not gained for killing players, and players who are already \"murderers\" do not lose infamy when killed.",
	conflict_peace_warmode = "This region is currently in conflict, but going into peace soon. Murder can be committed by players until the timer goes to 0.",
	conflict_peace = "This region is currently in conflict, but going into peace soon. Murder can be committed by players until the timer goes to 0.",
	peace_conflict_warmode = "This region is currently in peace, but going into conflict soon. No murder can be committed by players until the timer goes to 0.",
	peace_conflict = "This region is currently in peace, but going into conflict soon. No murder can be committed by players until the timer goes to 0.",
	conflict_warmode = "This region is currently in conflict. Murder can be committed by players during this time."
}
local regionConflictBottomText = {
	warzone = "Monsters provide 5% increased experience and silver during the conflict in this region.",
	conflict = "Monsters provide 5% increased experience and silver during the conflict in this region.",
	warzone_peace = "Monsters will cease to provide the additional 5% experience and silver.",
	conflict_peace = "Monsters will cease to provide the additional 5% experience and silver.",
	peace_warzone = "Monsters will provide 5% increased experience and silver when the conflict starts.",
	peace_conflict = "Monsters will provide 5% increased experience and silver when the conflict starts."
}
local landSizeToIcon = {
	[10] = MAPMARK_SMALL_LAND,
	[12] = MAPMARK_MEDIUM_LAND,
	[15] = MAPMARK_LARGE_LAND,
	[22] = MAPMARK_STRONGHOLD,
	[30] = MAPMARK_FORT
}
local landIconToWidgetSize = {
	[MAPMARK_SMALL_LAND] = 20,
	[MAPMARK_MEDIUM_LAND] = 24,
	[MAPMARK_LARGE_LAND] = 28,
	[MAPMARK_STRONGHOLD] = 32,
	[MAPMARK_FORT] = 34
}
local compassSizeToImage = {
	{
		name = "/images/ui/icons/compass/%s/compass_highlight_1",
		size = 55
	},
	{
		name = "/images/ui/icons/compass/%s/compass_highlight_2",
		size = 85
	},
	{
		name = "/images/ui/icons/compass/%s/compass_highlight_3",
		size = 125
	},
	{
		name = "/images/ui/icons/compass/%s/compass_highlight_4",
		size = 200
	},
	{
		name = "/images/ui/icons/compass/%s/compass_highlight_5",
		size = 300
	},
	{
		name = "/images/ui/icons/compass/%s/compass_highlight_6",
		size = 450
	},
	{
		name = "/images/ui/icons/compass/%s/compass_highlight_7"
	}
}
local mapImageSource = {
	guildWarsMap = {
		displayFlags = true,
		name = "guild_wars.ktx",
		hideZones = true,
		area = {
			realFromX = 868,
			fromY = 939,
			toX = 1423,
			realToX = 1198,
			fromX = 643,
			toY = 1348
		},
		minimapZoom = {
			max = 400,
			default = 200,
			min = 100
		},
		callback = function(lastSource)
			g_textures.unload(lastSource)
		end
	},
	aetherRiftMap = {
		displayFlags = false,
		name = "aether_rift.ktx",
		hideZones = true,
		area = {
			realFromX = 0,
			fromY = 0,
			toX = 232,
			realToX = 173,
			fromX = -59,
			toY = 153
		},
		minimapZoom = {
			max = 400,
			default = 200,
			min = 100
		},
		callback = function(lastSource)
			g_textures.unload(lastSource)
		end
	},
	{
		name = "tutorial_p1_%s.ktx",
		displayFlags = false,
		tutorial = true,
		inside = {
			from = {
				z = 0,
				y = 4550,
				x = 3165
			},
			to = {
				z = 15,
				y = 4700,
				x = 3388
			}
		},
		area = {
			fromY = 4543,
			fromX = 3097,
			toY = 4723,
			toX = 3426
		},
		minimapZoom = {
			max = 800,
			default = 400,
			min = 300
		},
		callback = function(lastSource)
			g_textures.unload(lastSource)
		end
	},
	{
		name = "tutorial_p2_%s.ktx",
		displayFlags = false,
		tutorial = true,
		inside = {
			from = {
				z = 0,
				y = 4750,
				x = 3165
			},
			to = {
				z = 15,
				y = 5150,
				x = 3388
			}
		},
		area = {
			fromY = 4740,
			fromX = 3093,
			toY = 4920,
			toX = 3420
		},
		minimapZoom = {
			max = 800,
			default = 400,
			min = 300
		},
		callback = function(lastSource)
			g_textures.unload(lastSource)
		end
	},
	{
		displayFlags = true,
		name = "floor%i_%s.ktx",
		displayCurrentFloorFlags = true,
		area = {
			fromY = 3800,
			fromX = 3046,
			toY = 6122,
			toX = 7174
		},
		minimapZoom = {
			max = 400,
			default = 200,
			min = 100
		},
		displayCurrentFloorFlagsExceptions = {
			[MAPMARK_COMPASS] = true
		}
	},
	{
		main = true,
		name = "minimap_%s.ktx",
		displayFlags = true,
		area = {
			fromY = 3800,
			fromX = 3046,
			toY = 6122,
			toX = 7174
		},
		minimapZoom = {
			max = 400,
			default = 200,
			min = 100
		},
		callback = function(lastSource, quality)
			return
		end
	}
}

g_worldMap = {
	globalFont = "myriad-pro-semibold-",
	zoom = 1,
	fullmapView = false,
	maxZoom = 10,
	minZoom = 1,
	startPos = {
		x = 0,
		y = 0
	},
	centerPos = {
		x = 0.5,
		y = 0.5
	},
	flags = {},
	landFlags = {},
	questFlags = {},
	alternatives = {},
	levelBrackets = {},
	zoneFlags = {},
	regionConflictInfo = {},
	area = {},
	compassHighlights = {},
	zoneCfg = {
		fontMinSize = 12,
		font = "vollkorn-sc-bold-bordered-",
		minZoom = 5,
		fullmapViewExtraFontSize = 6,
		fontMaxSize = 24
	},
	regionCfg = {
		fontMinSize = 10,
		font = "vollkorn-sc-bold-bordered-",
		maxZoom = 5,
		fullmapViewExtraFontSize = 4,
		fontMaxSize = 22
	},
	iconSettings = {
		showCollectors = true,
		showVendors = true,
		showMoaMerchant = true,
		showMarket = true,
		showRespawnShrine = true,
		showWarehouse = true,
		showBuilders = true,
		showFishpost = true,
		showBank = true,
		showAutomaticHighlights = true,
		showRangersCompanyOutpost = true,
		showPvPArena = true,
		showSeaport = true,
		showHouse = true,
		showTradepost = true,
		showCraftingStation = true,
		showLevelBrackets = true,
		showZoneNames = true,
		showMissionAvailable = true,
		showMissionComplete = true
	},
	landViewerSettings = {
		showFort = true,
		showStronghold = true,
		showLargeEstate = true,
		showMediumEstate = true,
		showSmallEstate = true
	},
	iconAssets = {
		[MAPMARK_MISSION_COMPLETE] = "mission_complete",
		[MAPMARK_MISSION_AVAILABLE] = "mission_available",
		[MAPMARK_HOUSE] = "house",
		[MAPMARK_SEAPORT] = "seaport",
		[MAPMARK_TRADEPOST] = "tradepost",
		[MAPMARK_CRAFTING_STATION] = {
			[ProfessionBlacksmithing] = "crafting_blacksmithing",
			[ProfessionCarpentry] = "crafting_carpentry",
			[ProfessionCooking] = "crafting_cooking",
			[ProfessionWeaving] = "crafting_weaving",
			[ProfessionAlchemy] = "crafting_alchemy"
		},
		[MAPMARK_LAND] = "house",
		[MAPMARK_MURDERER] = "murderer",
		[MAPMARK_TRADEPACK] = "tradepack",
		[MAPMARK_SMALL_LAND] = "small_land",
		[MAPMARK_MEDIUM_LAND] = "medium_land",
		[MAPMARK_LARGE_LAND] = "large_land",
		[MAPMARK_FORT] = "fort",
		[MAPMARK_STRONGHOLD] = "stronghold",
		[MAPMARK_PVP_ARENA] = "pvp_arena",
		[MAPMARK_PARTY_MEMBER] = "cross_party",
		[MAPMARK_RANGERS_COMPANY] = "rangers_company_outpost",
		[MAPMARK_REPUTATION_NPC_1] = "criminal_icon",
		[MAPMARK_REPUTATION_NPC_2] = "mercenary_icon",
		[MAPMARK_REPUTATION_NPC_3] = "order_icon",
		[MAPMARK_COMPASS] = "compass_highlight_1",
		[MAPMARK_NPC_BANK] = "npc_bank",
		[MAPMARK_NPC_FISHPOST] = "npc_fishpost",
		[MAPMARK_NPC_BUILDERS] = "npc_builder",
		[MAPMARK_NPC_WAREHOUSE] = "npc_warehouse",
		[MAPMARK_RESPAWN_SHRINE] = "respawn_shrine",
		[MAPMARK_MARKET] = "market",
		[MAPMARK_MOA_MERCHANT] = "moa_merchant",
		[MAPMARK_VENDOR] = "vendors",
		[MAPMARK_COLLECTOR] = "vendors",
		[MAPMARK_GUILD_WAR_TOWER_UNCLAIMED] = "tower_unclaimed",
		[MAPMARK_GUILD_WAR_TOWER_OWN] = "tower_own",
		[MAPMARK_GUILD_WAR_TOWER_OTHERS] = "tower_others",
		[MAPMARK_GUILD_WAR_FLAG_UNCLAIMED] = "flag_unclaimed",
		[MAPMARK_GUILD_WAR_FLAG_OWN] = "flag_own",
		[MAPMARK_GUILD_WAR_FLAG_OTHERS] = "flag_others"
	},
	defaultMinZoomIcon = {
		[MAPMARK_HOUSE] = 3,
		[MAPMARK_RESPAWN_SHRINE] = function()
			return g_game.isGuildWarsChannel() and 1 or 3
		end,
		[MAPMARK_GUILD_WAR_TOWER_UNCLAIMED] = 1,
		[MAPMARK_GUILD_WAR_TOWER_OWN] = 1,
		[MAPMARK_GUILD_WAR_TOWER_OTHERS] = 1,
		[MAPMARK_GUILD_WAR_FLAG_UNCLAIMED] = 1,
		[MAPMARK_GUILD_WAR_FLAG_OWN] = 1,
		[MAPMARK_GUILD_WAR_FLAG_OTHERS] = 1
	},
	defaultMarginIcon = {
		[MAPMARK_GUILD_WAR_FLAG_UNCLAIMED] = {
			top = -20,
			left = 3
		},
		[MAPMARK_GUILD_WAR_FLAG_OWN] = {
			top = -20,
			left = 3
		},
		[MAPMARK_GUILD_WAR_FLAG_OTHERS] = {
			top = -20,
			left = 3
		}
	}
}

local flagsToHideOnWindowHide = {
	[MAPMARK_DYNAMICEVENT] = true
}

function g_worldMap.getCustomMapPositionOffset(position)
	local offset = {
		x = 0,
		y = 0
	}

	if g_game.isGuildWarsChannel() then
		local mapInfo = mapImageSource.guildWarsMap
		local area = mapInfo.area

		if position.x > area.realToX then
			local distanceToOriginalMapLeft = position.x - area.realFromX
			local amountOfMaps = math.floor(distanceToOriginalMapLeft / (area.realToX - area.realFromX))
			local distanceToCurrentMapLeft = distanceToOriginalMapLeft - amountOfMaps * (area.realToX - area.realFromX)

			offset.x = distanceToOriginalMapLeft - distanceToCurrentMapLeft
		end
	elseif g_game.isAetherRiftChannel() then
		local mapInfo = mapImageSource.aetherRiftMap
		local area = mapInfo.area

		if not mapInfo.offsetX then
			mapInfo.offsetX = math.ceil((area.realToX - area.realFromX) / 16) * 16
		end

		local amountOfMaps = math.floor(position.x / mapInfo.offsetX)

		if amountOfMaps > 0 then
			offset.x = amountOfMaps * mapInfo.offsetX
		end
	end

	return offset
end

function g_worldMap.getMapImageData(position)
	if g_game.isGuildWarsChannel() then
		return mapImageSource.guildWarsMap
	end

	if g_game.isAetherRiftChannel() then
		return mapImageSource.aetherRiftMap
	end

	if position then
		for _, data in ipairs(mapImageSource) do
			if data.inside and Position.isInArea(position, data.inside.from, data.inside.to) then
				return data
			end
		end
	end

	local data = mapImageSource[#mapImageSource]

	if position and position.z > 7 then
		data = mapImageSource[#mapImageSource - 1]
	end

	return data
end

function g_worldMap.loadDefaultMarks()
	g_worldMap.destroyMarks(g_worldMap.flags)
	g_worldMap.destroyMarks(g_worldMap.questFlags)

	for _, mark in ipairs(defaultMarks) do
		g_worldMap.addFlag(mark.pos, mark.type, mark.description, false, mark.minZoom, mark.maxZoom, mark.onClick, mark.profession, mark.data, mark.style, nil, true, mark.onHoverChange)
	end

	g_worldMap.destroyMarks(g_worldMap.zoneFlags)

	g_worldMap.zoneFlags = {}

	for _, zoneInfo in ipairs(defaultZones) do
		g_worldMap.addZone(zoneInfo.pos, zoneInfo.name, zoneInfo.wordBreaks, zoneInfo.minLevel, zoneInfo.maxLevel)
	end

	g_worldMap.cross:raise()
end

function g_worldMap.destroyMarks(table)
	for index, value in pairs(table) do
		value:destroy()
	end

	table = {}
end

function g_worldMap.updateVisibleMarks(updatePosition)
	for _, mark in pairs(g_worldMap.flags) do
		if g_worldMap.displayFlags then
			mark.icon = tonumber(mark.icon)

			if mark.icon ~= MAPMARK_DYNAMICEVENT then
				if mark.icon == MAPMARK_MISSION_AVAILABLE and not g_worldMap.iconSettings.showMissionAvailable then
					mark:hide()

					mark.hidden = not g_worldMap.iconSettings.showMissionAvailable
				elseif mark.icon == MAPMARK_MISSION_COMPLETE and not g_worldMap.iconSettings.showMissionComplete then
					mark:hide()

					mark.hidden = not g_worldMap.iconSettings.showMissionComplete
				elseif mark.icon == MAPMARK_CRAFTING_STATION and not g_worldMap.showCraftingStation then
					mark:hide()

					mark.hidden = not g_worldMap.iconSettings.showCraftingStation
				elseif mark.icon == MAPMARK_HOUSE and not g_worldMap.iconSettings.showHouse then
					mark:hide()

					mark.hidden = not g_worldMap.iconSettings.showHouse
				elseif mark.icon == MAPMARK_SEAPORT and not g_worldMap.iconSettings.showSeaport then
					mark:hide()

					mark.hidden = not g_worldMap.iconSettings.showSeaport
				elseif mark.icon == MAPMARK_TRADEPOST and not g_worldMap.iconSettings.showTradepost then
					mark:hide()

					mark.hidden = not g_worldMap.iconSettings.showTradepost
				elseif mark.icon == MAPMARK_PVP_ARENA and not g_worldMap.iconSettings.showPvPArena then
					mark:hide()

					mark.hidden = not g_worldMap.iconSettings.showPvPArena
				elseif mark.icon == MAPMARK_RANGERS_COMPANY and not g_worldMap.iconSettings.showRangersCompanyOutpost then
					mark:hide()

					mark.hidden = not g_worldMap.iconSettings.showRangersCompanyOutpost
				elseif mark.icon == MAPMARK_NPC_BANK and not g_worldMap.iconSettings.showBank then
					mark:hide()

					mark.hidden = not g_worldMap.iconSettings.showBank
				elseif mark.icon == MAPMARK_NPC_FISHPOST and not g_worldMap.iconSettings.showFishpost then
					mark:hide()

					mark.hidden = not g_worldMap.iconSettings.showFishpost
				elseif mark.icon == MAPMARK_NPC_BUILDERS and not g_worldMap.iconSettings.showBuilders then
					mark:hide()

					mark.hidden = not g_worldMap.iconSettings.showBuilders
				elseif mark.icon == MAPMARK_NPC_WAREHOUSE and not g_worldMap.iconSettings.showWarehouse then
					mark:hide()

					mark.hidden = not g_worldMap.iconSettings.showWarehouse
				elseif mark.icon == MAPMARK_RESPAWN_SHRINE and not g_worldMap.iconSettings.showRespawnShrine then
					mark:hide()

					mark.hidden = not g_worldMap.iconSettings.showRespawnShrine
				elseif mark.icon == MAPMARK_MARKET and not g_worldMap.iconSettings.showMarket then
					mark:hide()

					mark.hidden = not g_worldMap.iconSettings.showMarket
				elseif mark.icon == MAPMARK_MOA_MERCHANT and not g_worldMap.iconSettings.showMoaMerchant then
					mark:hide()

					mark.hidden = not g_worldMap.iconSettings.showMoaMerchant
				elseif mark.icon == MAPMARK_VENDOR and not g_worldMap.iconSettings.showVendors then
					mark:hide()

					mark.hidden = not g_worldMap.iconSettings.showVendors
				elseif mark.icon == MAPMARK_COLLECTOR and not g_worldMap.iconSettings.showCollectors then
					mark:hide()

					mark.hidden = not g_worldMap.iconSettings.showCollectors
				elseif mark.icon == MAPMARK_COMPASS then
					mark.hidden = g_worldMap.isCompassFlagHidden(mark)

					mark:hide()
				elseif g_worldMap.zoom >= mark.zoom.min and g_worldMap.zoom <= mark.zoom.max then
					mark.hidden = false

					mark:show()
				end
			end

			if g_worldMap.displayCurrentFloorFlags and playerCurrentFloor and mark.position.z ~= playerCurrentFloor and (not g_worldMap.displayCurrentFloorFlagsExceptions or not g_worldMap.displayCurrentFloorFlagsExceptions[mark.icon]) then
				mark.hidden = true

				mark:hide()
			end
		elseif mark:getStyleName() ~= "WorldMapCompassHighlight" then
			mark.hidden = true

			mark:hide()
		end
	end

	for _, zoneFlag in pairs(g_worldMap.zoneFlags) do
		if not g_worldMap.hideZones and (g_worldMap.iconSettings.showZoneNames or g_worldMap.iconSettings.showLevelBrackets) and (not playerCurrentFloor or playerCurrentFloor <= 7 or zoneFlag.position.z == playerCurrentFloor) then
			zoneFlag.hidden = false

			zoneFlag:show()

			if g_worldMap.iconSettings.showZoneNames then
				zoneFlag.name:show()
			else
				zoneFlag.name:hide()
			end

			if g_worldMap.iconSettings.showLevelBrackets then
				zoneFlag.level:show()
			else
				zoneFlag.level:hide()
			end

			g_worldMap.updateZoneFlag(zoneFlag, true)
		else
			zoneFlag.hidden = true

			zoneFlag:hide()
		end
	end

	if updatePosition then
		addEvent(function()
			g_worldMap.updateMap()
		end)
		modules.game_minimap.updateMapFlags()
	end
end

local checkBoxIdToName = {
	showCollectors = "Collectors",
	showVendors = "Vendors",
	showMoaMerchant = "Moa Merchant",
	showMarket = "Market",
	showRespawnShrine = "Waypoints",
	showWarehouse = "Warehouses",
	showBuilders = "Builders",
	showFishpost = "Fishposts",
	showBank = "Bank",
	showAutomaticHighlights = "Compass Highlights",
	showRangersCompanyOutpost = "Rangers Company",
	showPvPArena = "PvP Arena",
	showSeaport = "Seaports",
	showHouse = "House",
	showTradepost = "Tradeposts",
	showCraftingStation = "Crafting Stations",
	showLevelBrackets = "Level Brackets",
	showZoneNames = "Zone Names",
	showMissionAvailable = "Missions Available",
	showMissionComplete = "Missions Complete"
}

function getCheckBoxName(key)
	return checkBoxIdToName[key]
end

function g_worldMap.init()
	g_ui.importStyle("region_info.otui")
	g_ui.importStyle("worldmap.otui")

	g_worldMap.window = g_ui.createWidget("WorldMapPanel", modules.game_interface.getHUDPanel())

	connect(g_worldMap.window, {
		onVisibilityChange = function(widget, visible)
			if visible then
				onShow()
			else
				onHide()
			end
		end,
		onPositionChange = function()
			if tradepostPanel and tradepostPanel:isVisible() then
				tradepostPanel:hide()
			end

			if regionInfoPanel and regionInfoPanel:isVisible() then
				g_worldMap.hideRegionInfoPanel()
			end

			if houseInfoPanel and houseInfoPanel:isVisible() then
				houseInfoPanel:hide()
			end

			if dynamicEventInfoPanel and dynamicEventInfoPanel:isVisible() then
				dynamicEventInfoPanel:hide()
			end
		end
	})

	g_worldMap.window.uiopensoundid = UI_WORLDMAP_WINDOW_OPEN
	g_worldMap.window.uiclosesoundid = UI_WORLDMAP_WINDOW_CLOSE

	g_worldMap.window:hide()

	g_worldMap.window.onGeometryChange = onGeometryChange
	g_worldMap.image = g_worldMap.window:recursiveGetChildById("image")
	g_worldMap.cross = g_worldMap.window:recursiveGetChildById("cross")
	g_worldMap.cross.pos = {
		x = 0,
		y = 0
	}
	g_worldMap.infoPanel = g_worldMap.window:recursiveGetChildById("infoPanel")
	iconFilterPanel = g_worldMap.window:recursiveGetChildById("iconFilterPanel")
	landViewerPanel = g_worldMap.window:recursiveGetChildById("landViewerPanel")

	function landViewerPanel.onVisibilityChange(widget, visible)
		if not visible then
			g_worldMap:destroyLandFlags()

			local toggleWidget = g_worldMap.window.contentPanel.filterWindow.selectPanel.zoneViewToggle

			if toggleWidget:isOn() then
				toggleWidget:onClick()
			end
		end
	end

	landViewerRegionComboBox = landViewerPanel:recursiveGetChildById("regionComboBox")

	g_worldMap.updateImageData()

	local iconFilterChildren = {}
	local contentPanel = iconFilterPanel:recursiveGetChildById("contentPanel")

	for key in pairs(g_worldMap.iconSettings) do
		g_worldMap.iconSettings[key] = g_settings.getBoolean(key, true)

		for _, widget in pairs(contentPanel:getChildren()) do
			if widget:getStyleName() == "WorldMapCheckBoxPanel" and widget:getId() == key then
				local checkbox = widget:recursiveGetChildById("checkbox")

				function checkbox.onCheckChange()
					g_worldMap.iconSettings[key] = checkbox:isChecked()

					g_worldMap.updateVisibleMarks(true)
					g_settings.set(key, checkbox:isChecked())
					g_settings.save()
				end

				checkbox:setChecked(g_worldMap.iconSettings[key])
				widget:recursiveGetChildById("description"):setText(getCheckBoxName(key))

				if not widget.ignoreSortFilter then
					table.insert(iconFilterChildren, widget)
					contentPanel:removeChild(widget)
				end

				break
			end
		end
	end

	table.sort(iconFilterChildren, function(a, b)
		return a:recursiveGetChildById("description"):getText() < b:recursiveGetChildById("description"):getText()
	end)

	for _, widget in ipairs(iconFilterChildren) do
		contentPanel:addChild(widget)
	end

	for key in pairs(g_worldMap.landViewerSettings) do
		g_worldMap.landViewerSettings[key] = g_settings.getBoolean(key)

		for _, widget in pairs(landViewerPanel:recursiveGetChildById("contentPanel"):getChildren()) do
			if widget:getStyleName() == "WorldMapCheckBoxPanel" and widget:getId() == key then
				local checkbox = widget:recursiveGetChildById("checkbox")

				function checkbox.onCheckChange()
					g_worldMap.landViewerSettings[key] = checkbox:isChecked()

					g_worldMap.updateVisibleLandMarks()
					g_settings.set(key, checkbox:isChecked())
					g_settings.save()
				end

				checkbox:setChecked(g_worldMap.landViewerSettings[key])

				break
			end
		end
	end

	tradepostPanel = g_worldMap.window:recursiveGetChildById("tradepostPanel")
	tradepackList = g_worldMap.window:recursiveGetChildById("tradepackPanel")
	sortNameButton = g_worldMap.window:recursiveGetChildById("sortNameButton")
	sortDemandButton = g_worldMap.window:recursiveGetChildById("sortDemandButton")
	searchEdit = g_worldMap.window:recursiveGetChildById("searchEdit")
	lastSortButton = sortNameButton
	regionInfoPanel = g_worldMap.window:recursiveGetChildById("regionInfoPanel")
	houseInfoPanel = g_worldMap.window:recursiveGetChildById("houseInfoPanel")
	dynamicEventInfoPanel = g_worldMap.window:recursiveGetChildById("dynamicEventInfoPanel")
	sortedRecipes = modules.game_tradepacks.GameTradepacks.sortedRecipes

	onSort(lastSortButton, nil, true)
	connect(g_worldMap.image, {
		onMouseWheel = g_worldMap.onMouseWheel,
		onDragEnter = g_worldMap.onDragEnter,
		onDragMove = g_worldMap.onDragMove,
		onDragLeave = g_worldMap.onDragLeave,
		onGeometryChange = g_worldMap.updateMap,
		onClick = g_worldMap.onClick
	})
	connect(g_game, {
		onGameStart = g_worldMap.online,
		onGameEnd = g_worldMap.offline,
		onAddAutomapFlag = g_worldMap.addFlag,
		onRemoveAutomapFlag = g_worldMap.removeFlag
	})
	connect(LocalPlayer, {
		onPositionChange = g_worldMap.onPositionChangeEvent,
		onOutfitChange = g_worldMap.onOutfitChange,
		onEffectiveLevelChange = g_worldMap.onEffectiveLevelChange
	})

	if g_game.isOnline() then
		g_worldMap.updateMap()
	end

	g_worldMap.loadDefaultMarks()
end

function g_worldMap.terminate()
	disconnect(g_worldMap.image, {
		onMouseWheel = g_worldMap.onMouseWheel,
		onDragEnter = g_worldMap.onDragEnter,
		onDragMove = g_worldMap.onDragMove,
		onDragLeave = g_worldMap.onDragLeave,
		onGeometryChange = g_worldMap.updateMap,
		onClick = g_worldMap.onClick
	})
	disconnect(g_game, {
		onGameStart = g_worldMap.online,
		onGameEnd = g_worldMap.offline,
		onAddAutomapFlag = g_worldMap.addFlag,
		onRemoveAutomapFlag = g_worldMap.removeFlag
	})
	disconnect(LocalPlayer, {
		onPositionChange = g_worldMap.onPositionChangeEvent,
		onOutfitChange = g_worldMap.onOutfitChange,
		onEffectiveLevelChange = g_worldMap.onEffectiveLevelChange
	})
	g_worldMap.cancelUpdateMapEvents()

	for _, widget in pairs(g_worldMap.alternatives) do
		widget:destroy()
	end

	removeEvent(regionConflictTimerEvent)

	g_worldMap.alternatives = {}
	g_worldMap.flags = {}

	if g_worldMap.flagWindow then
		g_worldMap.flagWindow:destroy()

		g_worldMap.flagWindow = nil
	end

	if g_worldMap.button then
		g_worldMap.button:destroy()

		g_worldMap.button = nil
	end

	if g_worldMap.window then
		g_worldMap.window:destroy()

		g_worldMap.window = nil
	end

	removeEvent(houseTimerEvent)
end

function g_worldMap.onGameStart()
	if g_game.getLocalPlayer() then
		g_worldMap.updateMap()
	end
end

function g_worldMap.online()
	g_worldMap.updateMap()
	g_worldMap.loadDefaultMarks()

	g_worldMap.compassHighlights = {}

	addEvent(function()
		g_worldMap.updateVisibleMarks(true)

		local player = g_game.getLocalPlayer()

		if player then
			g_worldMap.onOutfitChange(player)
			g_worldMap.onEffectiveLevelChange(player, player:getEffectiveLevel())
		end
	end)
end

function g_worldMap.offline()
	g_worldMap.clearFlags()

	if g_worldMap.fullmapView then
		g_worldMap.toggleFullMap()
	end

	g_worldMap.window:hide()
	g_worldMap.destroyHighlights()
end

function g_worldMap.toggle(mouseClick)
	if GameChat:isActive() or (type(mouseClick) ~= "boolean" or not mouseClick) and IsTextEditActive() then
		return
	end

	local window = g_worldMap.window

	if not window then
		return
	end

	if window:isVisible() then
		window:hide()
	else
		if g_game:isInCutsceneMode() then
			return
		end

		window:show()
		window:raise()
		window:focus()
	end
end

function g_worldMap.onMiniWindowClose()
	if g_worldMap.button then
		g_worldMap.button:setOn(false)
	end
end

function g_worldMap.clearMinimapWidgets()
	g_worldMap.image:destroyChildren()
end

function g_worldMap.clearClickableAreas()
	clickableAreas = {}
end

function g_worldMap.clearInfoPanel()
	g_worldMap.infoPanel:destroyChildren()
end

function g_worldMap.showInfoPanel()
	g_worldMap.infoPanel:show()
	g_worldMap.window.closeInfoPanelButton:show()
end

function g_worldMap.hideInfoPanel()
	g_worldMap.infoPanel:hide()
	g_worldMap.window.closeInfoPanelButton:hide()
end

function g_worldMap.addMinimapIcon(posX, posY, minZoom, maxZoom, image)
	local widget = g_ui.createWidget("WorldMapIcon", g_worldMap.image)

	widget.pos = {
		x = posX,
		y = posY
	}
	widget.zoom = {
		min = minZoom,
		max = maxZoom
	}

	widget:setImageSource(image)

	return widget
end

function g_worldMap.addMinimapText(posX, posY, minZoom, maxZoom, text)
	local widget = g_ui.createWidget("WorldMapText", g_worldMap.image)

	widget.pos = {
		z = 7,
		x = (posX - g_worldMap.area.fromX) / (g_worldMap.area.toX - g_worldMap.area.fromX),
		y = (posY - g_worldMap.area.fromY) / (g_worldMap.area.toY - g_worldMap.area.fromY)
	}
	widget.zoom = {
		min = minZoom,
		max = maxZoom
	}

	widget:setText(text)
	g_worldMap.updateWidgetPosition(widget, g_worldMap.image:getSize(), g_worldMap.getMapRect())

	return widget
end

function g_worldMap.addLevelBracket(pos, text, minZoom, maxZoom)
	local levelBracket = g_worldMap.addMinimapText(pos.x, pos.y, minZoom, maxZoom, text)

	levelBracket.realPos = {
		x = pos.x,
		y = pos.y,
		z = pos.z
	}
	levelBracket.zoom = {
		min = minZoom,
		max = maxZoom
	}

	table.insert(g_worldMap.levelBrackets, levelBracket)

	return levelBracket
end

local function insert_line_breaks(str, positions)
	if not positions or #positions == 0 then
		return str
	end

	local words = {}

	for word in str:gmatch("%S+") do
		table.insert(words, word)
	end

	local output

	for idx, word in ipairs(words) do
		if not output then
			output = word
		elseif table.contains(positions, idx - 1) then
			output = output .. "\n" .. word
		else
			output = output .. " " .. word
		end
	end

	return output
end

function g_worldMap.addZone(pos, name, wordBreaks, minLevel, maxLevel)
	local flag = g_ui.createWidget("WorldMapZone", g_worldMap.image)

	flag.pos = {
		x = (pos.x - g_worldMap.area.fromX) / (g_worldMap.area.toX - g_worldMap.area.fromX),
		y = (pos.y - g_worldMap.area.fromY) / (g_worldMap.area.toY - g_worldMap.area.fromY),
		z = pos.z
	}

	local displayName = insert_line_breaks(name, wordBreaks) or name

	flag:setId(name)

	flag.icon = MAPMARK_ZONE

	flag.name:setText(displayName)

	if minLevel and maxLevel then
		flag.minLevel = minLevel
		flag.maxLevel = maxLevel
		flag.averageLevel = (minLevel + maxLevel) / 2

		flag.level:setText(string.format("[%d-%d]", minLevel, maxLevel))
	else
		flag.name:setTextColor("white")

		flag.name.extraFontSize = 1

		flag.level:setVisible(false)
	end

	flag.position = pos
	flag.zoom = {
		min = g_worldMap.maxZoom / 2,
		max = g_worldMap.maxZoom
	}

	g_worldMap.updateWidgetPosition(flag, g_worldMap.image:getSize(), g_worldMap.getMapRect())
	table.insert(g_worldMap.zoneFlags, flag)

	return flag
end

function g_worldMap.addInfoPanelText(text)
	local widget = g_ui.createWidget("InfoPanelLabel", g_worldMap.infoPanel)

	widget:setText(text)

	return widget
end

function g_worldMap.addClickableArea(x1, y1, x2, y2, callback)
	table.insert(clickableAreas, {
		x1 = x1,
		y1 = y1,
		x2 = x2,
		y2 = y2,
		callback = callback
	})
end

function g_worldMap.updatePlayerPosition()
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local pos = player:getPosition()

	if pos == nil then
		return
	end

	pos.x = pos.x - g_worldMap.getCustomMapPositionOffset(pos).x
	g_worldMap.cross.pos = {
		x = (pos.x - g_worldMap.area.fromX) / (g_worldMap.area.toX - g_worldMap.area.fromX),
		y = (pos.y - g_worldMap.area.fromY) / (g_worldMap.area.toY - g_worldMap.area.fromY)
	}
	g_worldMap.cross.realPos = {
		x = pos.x,
		y = pos.y
	}
end

function g_worldMap.updateWidgetPosition(widget, worldSize, mapPercentRect)
	local pX = (widget.pos.x - mapPercentRect.x) / mapPercentRect.width
	local pY = (widget.pos.y - mapPercentRect.y) / mapPercentRect.height

	if not g_worldMap.displayFlags and widget ~= g_worldMap.cross and widget:getStyleName() ~= "WorldMapCompassHighlight" or pX < -0.1 or pX > 1.1 or pY < -0.1 or pY > 1.1 then
		widget:hide()

		return
	end

	if widget.zoom and (widget.zoom.min > g_worldMap.zoom or widget.zoom.max < g_worldMap.zoom) then
		g_effects.stopBlink(widget)
		widget:hide()

		return
	end

	local player = g_game.getLocalPlayer()

	if widget.icon == MAPMARK_MISSION_AVAILABLE or widget.icon == MAPMARK_DYNAMICEVENT then
		if widget.icon == MAPMARK_MISSION_AVAILABLE and not g_worldMap.iconSettings.showMissionAvailable then
			widget.hidden = true
		elseif widget.alwaysShow then
			widget.hidden = false
		else
			local distance = Position.distance(widget.position, player and player:getPosition() or widget.position)
			local maxDist = widget.icon == MAPMARK_DYNAMICEVENT and 100 or 9999

			if maxDist < distance then
				widget.hidden = true
			else
				widget.hidden = false

				if widget.icon == MAPMARK_DYNAMICEVENT then
					if not widget.eventInfo or widget.eventInfo.inactive then
						widget.hidden = true
					elseif widget.eventInfo.eventProgress then
						widget.hidden = widget.eventInfo.eventProgress.overall >= widget.eventInfo.eventProgress.goal
					end
				end
			end
		end
	end

	if not widget:getTooltip() and widget:getText() then
		widget:setFont(g_worldMap.zoom < 2 and g_worldMap.globalFont .. "18" or g_worldMap.zoom < 3 and g_worldMap.globalFont .. "21" or g_worldMap.zoom < 5 and g_worldMap.globalFont .. "24" or g_worldMap.zoom < 6 and g_worldMap.globalFont .. "28" or g_worldMap.globalFont .. "30")
	end

	widget:setVisible(not widget.hidden)

	if widget:getStyleName() == "WorldMapCompassHighlight" then
		local p = worldSize.height / (mapPercentRect.height * (g_worldMap.area.toY - g_worldMap.area.fromY))
		local newSize = math.ceil(widget.compassSize * p)

		g_worldMap.updateCompassHighlightWidgetSize(widget, newSize)
	end

	if widget.icon == MAPMARK_ZONE then
		g_worldMap.updateZoneFlag(widget)
	end

	if widget.icon == MAPMARK_REGION_CONFLICT then
		g_worldMap.updateRegionFlag(widget)
	end

	widget:setMarginLeft(worldSize.width * pX - widget:getWidth() / 2 + (widget.margin and widget.margin.left or 0))
	widget:setMarginTop(worldSize.height * pY - widget:getHeight() / 2 + (widget.margin and widget.margin.top or 0))
end

function g_worldMap.getMainMapImageSourcePath()
	for _, data in ipairs(mapImageSource) do
		if data.main then
			local txtSize = g_graphics.getMaxTextureSize()
			local quality = txtSize <= 4096 and "l" or "m"
			local source = string.format("/images/%s", string.format(data.name, quality))

			return source
		end
	end

	return ""
end

function g_worldMap.updateImageData(ignoreUpdateVisibleMarks)
	local player = g_game.getLocalPlayer()
	local playerPos = player and player:getPosition() or nil
	local data = g_worldMap.getMapImageData(playerPos)

	if data then
		g_worldMap.imageData = data
		g_worldMap.area = data.area
		g_worldMap.displayFlags = data.displayFlags
		g_worldMap.hideZones = data.hideZones
		g_worldMap.displayCurrentFloorFlags = data.displayCurrentFloorFlags
		g_worldMap.displayCurrentFloorFlagsExceptions = data.displayCurrentFloorFlagsExceptions

		local txtSize = g_graphics.getMaxTextureSize()
		local qualityString = txtSize <= 4096 and "l" or "m"
		local source

		if not g_game.isRavenQuest() and not data.main and playerPos and playerPos.z > 7 then
			source = string.format("/images/%s", string.format(data.name, playerPos.z, qualityString))
		else
			source = string.format("/images/%s", string.format(data.name, qualityString))
		end

		local oldSource = g_worldMap.image:getImageSource()

		if oldSource == source then
			return
		end

		for _, flag in pairs(g_worldMap.flags) do
			if flag.icon ~= MAPMARK_DYNAMICEVENT then
				local pos = flag.position

				flag.pos = {
					x = (pos.x - g_worldMap.area.fromX) / (g_worldMap.area.toX - g_worldMap.area.fromX),
					y = (pos.y - g_worldMap.area.fromY) / (g_worldMap.area.toY - g_worldMap.area.fromY),
					z = pos.z
				}
			end
		end

		local minimap = modules.game_minimap

		function minimap.minimapWindow.image.onImageChange()
			minimap.defaultZoom = data.minimapZoom.default
			minimap.minZoom = data.minimapZoom.min
			minimap.maxZoom = data.minimapZoom.max

			if not minimap.zoom or minimap.zoom < minimap.minZoom or minimap.zoom > minimap.maxZoom then
				minimap.zoom = data.minimapZoom.default
			end

			minimap.minimapWindow.image:setTextureRadius(minimap.zoom)
			addEvent(function()
				minimap.updateMinimapClip(0, 0)
			end)
		end

		if player then
			g_worldMap.image:setImageSource(source, false, true)

			function g_worldMap.image.onImageChange()
				minimap.minimapWindow.image:setImageSource(source, false, true)
			end

			if data.callback then
				addEvent(function()
					data.callback(oldSource, qualityString)
				end)
			end
		end
	end
end

function g_worldMap.onPositionChangeEvent(player, newPos, oldPos)
	if newPos and (not oldPos or newPos.z == oldPos.z) and not oldPos then
		-- block empty
	end

	g_worldMap.updateMapEventNewPos = newPos
	g_worldMap.updateMapEventOldPos = oldPos

	if g_worldMap.updateMapEvent then
		return
	end

	g_worldMap.updateMapEvent = scheduleEvent(function()
		local newPos = g_worldMap.updateMapEventNewPos
		local oldPos = g_worldMap.updateMapEventOldPos

		if newPos and oldPos and newPos.z ~= oldPos.z then
			g_worldMap.updateVisibleMarks(true)
		end

		g_worldMap.updateMap(nil, nil, true)

		g_worldMap.updateMapEvent = nil
		g_worldMap.updateMapEventNewPos = nil
		g_worldMap.updateMapEventOldPos = nil
	end, 350)
end

function g_worldMap.onFloorChange(player, newPos, oldPos)
	local txtSize = g_graphics.getMaxTextureSize()
	local quality = txtSize <= 4096 and "l" or "m"
	local player = g_game.getLocalPlayer()

	if player then
		local playerPos = player:getPosition()
		local floor = playerPos.z

		for i = 8, 15 do
			if i < floor - 1 or i > floor + 1 then
				g_textures.unload(string.format("/images/floor%i_%s.ktx", i, quality))
			end
		end

		for i = -1, 1 do
			local targetFloor = floor + i

			if targetFloor >= 8 and targetFloor <= 15 then
				g_textures.preload(string.format("/images/floor%i_%s.ktx", targetFloor, quality))
			end
		end

		if floor <= 8 then
			g_textures.preload(string.format("/images/minimap_%s.ktx", quality))
		else
			g_textures.unload(string.format("/images/minimap_%s.ktx", quality))
		end
	else
		for i = 8, 15 do
			g_textures.unload(string.format("/images/floor%i_%s.ktx", i, quality))
		end
	end
end

function g_worldMap.cancelUpdateMapEvents()
	local isDragging

	if g_worldMap.updateMapEvent then
		g_worldMap.updateMapEvent:cancel()

		g_worldMap.updateMapEvent = nil
	end

	if g_worldMap.zoomChangeEvent then
		g_worldMap.zoomChangeEvent:cancel()

		g_worldMap.zoomChangeEvent = nil
	end

	if g_worldMap.dragMoveEvent then
		g_worldMap.dragMoveEvent:cancel()

		g_worldMap.dragMoveEvent = nil
		isDragging = true
	end

	return isDragging
end

function g_worldMap.updateMap(correction, isDragging, walking)
	isDragging = g_worldMap.cancelUpdateMapEvents() or isDragging

	if not correction and not isDragging then
		g_worldMap.updateImageData()

		local player = g_game.getLocalPlayer()
		local playerPos = player and player:getPosition() or nil

		if playerPos and (not playerCurrentFloor or playerPos.z ~= playerCurrentFloor) then
			playerCurrentFloor = playerPos.z

			g_worldMap.updateVisibleCompassHighlightFlags()
		end
	end

	local worldSize = g_worldMap.image:getSize()
	local imageWidth = g_worldMap.image:getImageTextureWidth()
	local imageHeight = g_worldMap.image:getImageTextureHeight()
	local p = 1

	if g_worldMap.fullmapView then
		p = imageWidth / imageHeight / (worldSize.width / worldSize.height)
		g_worldMap.zoom = math.max(g_worldMap.zoom, p)
	end

	local x = imageWidth * g_worldMap.centerPos.x - imageWidth / (g_worldMap.zoom * 2)
	local y = imageHeight * g_worldMap.centerPos.y - imageHeight / (g_worldMap.zoom * 2)
	local width = imageWidth / g_worldMap.zoom
	local height = imageHeight / g_worldMap.zoom * p

	if not correction and (x < 0 or imageWidth < x + width or y < 0 or imageHeight < y + height) then
		if x < 0 then
			g_worldMap.centerPos.x = g_worldMap.centerPos.x - x / imageWidth
		elseif imageWidth < x + width then
			g_worldMap.centerPos.x = g_worldMap.centerPos.x - (x + width - imageWidth) / imageWidth
		end

		if y < 0 then
			g_worldMap.centerPos.y = g_worldMap.centerPos.y - y / imageHeight
		elseif imageHeight < y + height then
			g_worldMap.centerPos.y = g_worldMap.centerPos.y - (y + height - imageHeight) / imageHeight
		end

		return g_worldMap.updateMap(true)
	end

	g_worldMap.image:setImageClip({
		x = x,
		y = y,
		width = width,
		height = height
	})

	if g_worldMap.window:isVisible() then
		local percentRect = {
			x = x / imageWidth,
			y = y / imageHeight,
			width = width / imageWidth,
			height = height / imageHeight
		}

		g_worldMap.updatePlayerPosition()
		g_worldMap.updateWidgetPosition(g_worldMap.cross, worldSize, percentRect)

		for _, child in ipairs(g_worldMap.image:getChildren()) do
			if (child.icon and (child.icon == MAPMARK_MISSION_AVAILABLE or child.icon == MAPMARK_DYNAMICEVENT) or child:isVisible() and not child.position or not child.hidden) and (child.icon ~= MAPMARK_DYNAMICEVENT or child.eventInfo and child.eventInfo.timer - os.time() > 0) then
				g_worldMap.updateWidgetPosition(child, worldSize, percentRect)
			end
		end
	end

	if not walking then
		if tradepostPanel and tradepostPanel:isVisible() then
			tradepostPanel:hide()
		end

		if regionInfoPanel and regionInfoPanel:isVisible() then
			g_worldMap.hideRegionInfoPanel()
		end

		if houseInfoPanel and houseInfoPanel:isVisible() then
			houseInfoPanel:hide()
		end

		if dynamicEventInfoPanel and dynamicEventInfoPanel:isVisible() then
			dynamicEventInfoPanel:hide()
		end
	end
end

function g_worldMap.zoomIn()
	local zoom = math.min(10, g_worldMap.zoom * 15 / 10)

	if zoom == g_worldMap.zoom then
		return
	end

	g_worldMap.zoom = zoom

	g_worldMap.updateMap()
end

function g_worldMap.zoomOut()
	local zoom = math.max(1, g_worldMap.zoom * 10 / 15)

	if zoom == g_worldMap.zoom then
		return
	end

	g_worldMap.zoom = zoom

	g_worldMap.updateMap()
end

function g_worldMap.onMouseWheel(widget, mousePos, direction)
	if landViewerPanel:isOn() then
		g_worldMap.resetLandViwerPanel()
	end

	local zoom = g_worldMap.zoom

	if direction == MouseWheelUp then
		zoom = math.min(g_worldMap.maxZoom, g_worldMap.zoom * 11 / 10)
	elseif direction == MouseWheelDown then
		zoom = math.max(g_worldMap.minZoom, g_worldMap.zoom * 10 / 11)
	end

	if zoom == g_worldMap.zoom then
		return
	end

	local rect = widget:getRect()
	local offset = {
		x = (mousePos.x - rect.x) / rect.width,
		y = (mousePos.y - rect.y) / rect.height
	}
	local imageWidth = g_worldMap.image:getImageTextureWidth()
	local imageHeight = g_worldMap.image:getImageTextureHeight()
	local widthChange = imageWidth * (1 / zoom - 1 / g_worldMap.zoom)
	local heightChange = imageHeight * (1 / zoom - 1 / g_worldMap.zoom)
	local centerChangeX = widthChange / imageWidth * (0.5 - offset.x)
	local centerChangeY = heightChange / imageHeight * (0.5 - offset.y)

	g_worldMap.centerPos.x = g_worldMap.centerPos.x + centerChangeX
	g_worldMap.centerPos.y = g_worldMap.centerPos.y + centerChangeY
	g_worldMap.zoom = zoom

	g_worldMap.onZoomChangeEvent()
end

function g_worldMap.onZoomChangeEvent()
	if g_worldMap.zoomChangeEvent then
		return
	end

	g_worldMap.zoomChangeEvent = scheduleEvent(function()
		g_worldMap.zoomChangeEvent = nil

		g_worldMap.updateMap()
	end, 20)
end

function g_worldMap.onDragEnter(widget, pos)
	if landViewerPanel:isOn() then
		g_worldMap.resetLandViwerPanel()
	end

	g_worldMap.startPos = {
		x = pos.x,
		y = pos.y
	}

	return true
end

function g_worldMap.onDragMove(widget, pos, moved)
	if landViewerPanel:isOn() then
		g_worldMap.resetLandViwerPanel()
	end

	local worldSize = g_worldMap.image:getSize()

	g_worldMap.centerPos.x = g_worldMap.centerPos.x - moved.x / (worldSize.width * g_worldMap.zoom)
	g_worldMap.centerPos.y = g_worldMap.centerPos.y - moved.y / (worldSize.height * g_worldMap.zoom)

	g_worldMap.onDragMoveEvent()

	return true
end

function g_worldMap.onDragMoveEvent()
	if g_worldMap.dragMoveEvent then
		return
	end

	g_worldMap.dragMoveEvent = scheduleEvent(function()
		g_worldMap.dragMoveEvent = nil

		g_worldMap.updateMap(false, true)
	end, 20)
end

function g_worldMap.onDragLeave(widget, pos)
	return true
end

function g_worldMap.onClick(widget, mousePos)
	local percentRect = g_worldMap.getMapRect()
	local rect = widget:getRect()
	local offset = {
		x = (mousePos.x - rect.x) / rect.width,
		y = (mousePos.y - rect.y) / rect.height
	}

	offset.x = percentRect.x + offset.x * percentRect.width
	offset.y = percentRect.y + offset.y * percentRect.height

	local clicked = false

	return clicked
end

function g_worldMap.toggleFullMap()
	if not g_worldMap.fullmapView then
		g_worldMap.fullmapView = true

		g_worldMap.window:breakAnchors()
		g_worldMap.window.edge_top:hide()
		g_worldMap.window:fill("parent")
		g_worldMap.window.top_panel:setHeight(0)
		g_worldMap.window.top_panel:hide()
		g_worldMap.window.contentPanel:recursiveGetChildById("topMenu"):setHeight(47)
	else
		g_worldMap.fullmapView = false

		g_worldMap.window:breakAnchors()
		g_worldMap.window.edge_top:show()
		g_worldMap.window:setSize({
			width = g_worldMap.window.width,
			height = g_worldMap.window.height
		})
		g_worldMap.window:centerIn("parent")
		g_worldMap.window.top_panel:setHeight(47)
		g_worldMap.window.top_panel:show()
		g_worldMap.window.contentPanel:recursiveGetChildById("topMenu"):setHeight(0)
	end

	local fullMapButton = g_worldMap.window:recursiveGetChildById("fullMapButton")

	if fullMapButton then
		fullMapButton:setIcon(g_worldMap.fullmapView and "/images/ui/icons/icon_reduce" or "/images/ui/icons/icon_expansion")
	end

	g_worldMap.onFullmapViewChange()
	g_worldMap.updateMap()
end

function g_worldMap.getStatusIconPath(status, small)
	return "/images/ui/windows/worldmap/status_icons/region_" .. status .. (not small and "" or "_small")
end

function g_worldMap.onFullmapViewChange()
	for _, flag in pairs(g_worldMap.flags) do
		if flag.icon == MAPMARK_REGION_CONFLICT and flag.regionInfo and flag.regionInfo.state then
			flag.iconImage:setImageSource(g_worldMap.getStatusIconPath(flag.regionInfo.state, not g_worldMap.fullmapView))
			flag.iconActive:setImageSource(g_worldMap.getStatusIconPath("active_border", not g_worldMap.fullmapView))
		end
	end
end

function g_worldMap.getButton()
	return g_worldMap.button
end

function g_worldMap.addFlag(pos, icon, description, temporary, minZoom, maxZoom, callback, profession, data, style, margin, ignoreRaise, hoverCallback)
	data = data or {}

	if temporary == nil then
		temporary = true
	end

	if not pos or not icon then
		return
	end

	if g_worldMap.isQuestFlag(icon) then
		g_worldMap.addQuestFlag(pos, icon, description)
	end

	local flag = g_worldMap.getFlag(pos, icon, description)

	if flag or not icon then
		return
	end

	local customMinZoom = g_worldMap.defaultMinZoomIcon[icon]

	if customMinZoom and type(customMinZoom) == "function" then
		customMinZoom = customMinZoom()
	end

	minZoom = minZoom or customMinZoom or 5
	maxZoom = maxZoom or 10
	temporary = temporary or false
	flag = g_ui.createWidget(style or "WorldMapIcon", g_worldMap.image)
	flag.margin = margin or g_worldMap.defaultMarginIcon[icon]
	flag.minimapPosition = pos
	flag.customPositionOffset = g_worldMap.getCustomMapPositionOffset(pos)
	flag.position = {
		x = pos.x,
		y = pos.y,
		z = pos.z
	}
	flag.position.x = flag.position.x - flag.customPositionOffset.x
	flag.pos = {
		x = (flag.position.x - g_worldMap.area.fromX) / (g_worldMap.area.toX - g_worldMap.area.fromX),
		y = (flag.position.y - g_worldMap.area.fromY) / (g_worldMap.area.toY - g_worldMap.area.fromY),
		z = flag.position.z
	}
	flag.zoom = {
		min = minZoom,
		max = maxZoom
	}
	flag.description = description
	flag.icon = icon
	flag.temporary = temporary
	flag.profession = profession
	flag.data = data

	if type(tonumber(icon)) == "number" then
		local iconType = flag.profession and g_worldMap.iconAssets[icon][flag.profession] or g_worldMap.iconAssets[icon]

		if iconType and type(iconType) == "string" then
			flag:setImageSource("/images/ui/windows/minimap/icons/small/" .. iconType)
		elseif icon == MAPMARK_REGION_CONFLICT then
			if not flag.regionInfo then
				flag.regionInfo = {}
			end

			if not flag.regionInfo.state then
				flag.regionInfo.state = "peace"
			end

			flag.iconImage:setImageSource(g_worldMap.getStatusIconPath(flag.regionInfo.state, not g_worldMap.fullmapView))
			flag.frame.text:setText(flag.data and flag.data.displayName or flag.description)
		elseif icon == MAPMARK_DYNAMICEVENT then
			flag:setImageSource("/images/ui/windows/minimap/icons/small/dynamic_event")
		end
	else
		flag:setImageSource(resolvepath(icon, 1))
	end

	flag:setTooltip(description)

	function flag.onDestroy()
		table.removevalue(g_worldMap.flags, flag)
	end

	if callback then
		flag.nosound = false

		function flag.onClick(widget)
			callback(widget)
		end
	end

	if hoverCallback then
		flag.nosound = false

		function flag.onHoverChange(widget, hovered)
			hoverCallback(widget, hovered)
		end
	end

	g_worldMap.updateWidgetPosition(flag, g_worldMap.image:getSize(), g_worldMap.getMapRect())
	table.insert(g_worldMap.flags, flag)
	modules.game_minimap.updateMapFlags()

	if not ignoreRaise then
		g_worldMap.cross:raise()
	end

	return flag
end

function g_worldMap.onFlagMouseRelease(widget, pos, button)
	if button == MouseRightButton then
		local menu = g_ui.createWidget("PopupMenu")

		menu:setGameMenu(true)
		menu:addOption(tr("Delete mark"), function()
			widget:destroy()
		end)
		menu:display(pos)

		return true
	end

	return false
end

function g_worldMap.getFlag(pos, icon, description)
	local posOffset = pos.x - g_worldMap.getCustomMapPositionOffset(pos).x

	for _, flag in pairs(g_worldMap.flags) do
		if (flag.position.x == posOffset or flag.position.x == pos.x) and flag.position.y == pos.y and flag.position.z == pos.z and (not icon or icon == flag.icon) and (not description or description == flag.description) then
			return flag
		end
	end

	return nil
end

function g_worldMap.removeFlag(pos, icon, description)
	local flag = g_worldMap.getFlag(pos, icon, description)

	if not flag then
		local posOffset = {
			x = pos.x - g_worldMap.getCustomMapPositionOffset(pos).x,
			y = pos.y,
			z = pos.z
		}

		flag = g_worldMap.getFlag(posOffset, icon, description)

		if not flag then
			print("flag not found")

			return
		end
	end

	flag:destroy()

	flag = nil

	modules.game_minimap.removeFlag(pos, icon, description)
	modules.game_minimap.updateMapFlags()
end

function g_worldMap.clearFlags()
	while #g_worldMap.flags > 0 do
		for _, flag in pairs(g_worldMap.flags) do
			flag:destroy()

			flag = nil
		end
	end

	for _, questFlag in pairs(g_worldMap.flags) do
		questFlag:destroy()

		questFlag = nil
	end

	modules.game_minimap.updateMapFlags()
end

function g_worldMap.getMapRect()
	local worldSize = g_worldMap.image:getSize()
	local imageWidth = g_worldMap.image:getImageTextureWidth()
	local imageHeight = g_worldMap.image:getImageTextureHeight()
	local x = imageWidth * g_worldMap.centerPos.x - imageWidth / (g_worldMap.zoom * 2)
	local y = imageHeight * g_worldMap.centerPos.y - imageHeight / (g_worldMap.zoom * 2)
	local width = imageWidth / g_worldMap.zoom
	local height = imageHeight / g_worldMap.zoom
	local percentRect = {
		x = x / imageWidth,
		y = y / imageHeight,
		width = width / imageWidth,
		height = height / imageHeight
	}

	return percentRect
end

function resizeToResolution(force)
	return
end

function onGeometryChange(widget, oldRect, newRect)
	g_worldMap.onPositionChangeEvent()
end

function onShow()
	onMenuToggle()
end

function onHide()
	g_worldMap.destroyHighlights(true)
	tradepostPanel:hide()
	dynamicEventInfoPanel:hide()

	for _, flag in pairs(g_worldMap.flags) do
		if flag.icon and flagsToHideOnWindowHide[flag.icon] then
			flag.hidden = true

			flag:setVisible(false)
		end
	end
end

function onMenuToggle()
	local player = g_game.getLocalPlayer()

	if player then
		local pos = player:getPosition()

		if pos then
			g_worldMap.centerOnPosition(pos)
		end

		g_worldMap.destroyHighlights(true)

		local gameInterface = modules.game_interface

		gameInterface.sendOpcode(ExtendedIds.Regions, {
			action = "request_region_conflicts"
		})
		gameInterface.sendOpcode(ExtendedIds.Quest, {
			type = "dynamic_event",
			action = "request_events_info"
		})
	end
end

function onTradepostClicked(widget, postId)
	if tradepostPanel:isVisible() and lastPostId == postId then
		tradepostPanel:hide()
		rootWidget:removeChild(tradepostPanel)
		g_tooltip.display(widget:getTooltip())

		return
	end

	lastPostId = postId

	modules.game_tradepacks.GameTradepacks:sendOpcode({
		action = "request_post_demand",
		post = postId
	})
	g_tooltip.hide()
	tradepostPanel:setText(Tradeposts[postId].name)
	tradepostPanel:setWidth(math.max(300, tradepostPanel:getTextSize().width + 20))
	tradepostPanel:show()

	local pos = widget and widget:getPosition() or g_window.getMousePosition()

	tradepostPanel:setPosition({
		x = pos.x,
		y = pos.y
	})

	local windowSize = g_window.getSize()
	local panelSize = tradepostPanel:getSize()

	pos.x = pos.x + 30

	if windowSize.width - (pos.x + panelSize.width) < 10 then
		pos.x = pos.x - panelSize.width - 3
	else
		pos.x = pos.x + 10
	end

	if windowSize.height - (pos.y + panelSize.height) < 10 then
		pos.y = pos.y - panelSize.height - 3
	else
		pos.y = pos.y + 10
	end

	tradepostPanel:setPosition(pos)

	if not rootWidget:hasChild(tradepostPanel) then
		rootWidget:addChild(tradepostPanel)
	end

	onSort(lastSortButton, nil, true)
end

function setDemand(widget, demand)
	local demandLabel = widget:getChildById("demand")

	demandLabel:setText(string.format("Demand: %i%%", demand))
	demandLabel:show()
end

function populateTradepackList(table)
	table = table or sortedRecipes

	tradepackList:destroyChildren()

	tradepackWidgets = {}

	for _, recipe in ipairs(table) do
		local widget = g_ui.createWidget("TradepackItem", tradepackList)

		widget:getChildById("name"):setText(recipe.name)

		local item = widget:getChildById("item")

		item:setItemId(recipe.clientId)
		item:setPhantom(true)

		widget.clientId = recipe.clientId
		widget.name = recipe.name

		if recipe.demand then
			widget.demand = recipe.demand

			setDemand(widget, recipe.demand)
		end

		tradepackWidgets[recipe.itemid] = widget
	end
end

function onSort(widget, recipes, isSearch)
	widget = widget or sortNameButton

	local sortType = widget:getId() == "sortNameButton" and "name" or "demand"

	if not isSearch and lastSortButton == widget then
		sort.direction = sort.direction == "descending" and "ascending" or "descending"
		widget.direction = sort.direction

		widget:setIcon("/images/ui/windows/tradepack/sort_" .. sort.direction)
	end

	local search = searchEdit:getText()

	if search ~= "" then
		searchRecipes = {}

		for _, recipe in ipairs(sortedRecipes) do
			if recipe.name:lower():find(search:lower(), 1, true) then
				table.insert(searchRecipes, recipe)
			end
		end

		recipes = searchRecipes
	end

	recipes = recipes or sortedRecipes

	if sortType == "name" then
		sortNameButton:setOn(true)
		sortDemandButton:setOn(false)

		sort.direction = widget.direction

		table.sort(recipes, function(a, b)
			if sort.direction == "descending" then
				return a.name > b.name
			else
				return a.name < b.name
			end
		end)
	else
		sortNameButton:setOn(false)
		sortDemandButton:setOn(true)

		widget.direction = sort.direction

		table.sort(recipes, function(a, b)
			if sort.direction == "descending" then
				return a.demand > b.demand
			else
				return a.demand < b.demand
			end
		end)
	end

	sort.name = sortType
	lastSortButton = widget

	populateTradepackList(recipes)
	tradepackList:setMarginRight(tradepackList:getChildCount() < 5 and 0 or 15)
end

function parsePostDemand(demand)
	for _, recipe in ipairs(sortedRecipes) do
		for itemid, info in pairs(demand) do
			if recipe.itemid == itemid then
				price = info.price
				recipe.demand = info.price

				local widget = tradepackWidgets[itemid]

				if widget then
					widget.demand = info.price

					setDemand(widget, info.price)
				end
			end
		end
	end
end

function g_worldMap.centerOnPosition(position, zoom)
	if zoom then
		g_worldMap.zoom = zoom
	end

	position.x = position.x - g_worldMap.getCustomMapPositionOffset(position).x
	g_worldMap.centerPos.x = (position.x - g_worldMap.area.fromX) / (g_worldMap.area.toX - g_worldMap.area.fromX)
	g_worldMap.centerPos.y = (position.y - g_worldMap.area.fromY) / (g_worldMap.area.toY - g_worldMap.area.fromY)

	g_worldMap.updateMap()
end

function g_worldMap.updateIconFilter(iconId)
	for _, widget in pairs(iconFilterPanel:recursiveGetChildById("contentPanel"):getChildren()) do
		if widget:getStyleName() == "WorldMapCheckBoxPanel" and widget:getId() == iconId then
			local checkbox = widget:recursiveGetChildById("checkbox")

			checkbox:setChecked(g_worldMap.iconSettings[iconId])

			break
		end
	end
end

function g_worldMap.hideRegionInfoPanel()
	if not regionInfoPanel then
		return
	end

	if regionInfoPanel:isVisible() then
		regionInfoPanel:hide()

		if regionInfoPanel.activeWidget then
			regionInfoPanel.activeWidget.iconActive:hide()

			regionInfoPanel.activeWidget = nil
		end
	end
end

function onConflictIconClicked(widget, regionId, forceUpdate, hovered)
	if not hovered and regionInfoPanel:isVisible() then
		g_worldMap.hideRegionInfoPanel()

		return
	end

	if not forceUpdate and regionInfoPanel:isVisible() and lastRegionId == regionId then
		g_worldMap.hideRegionInfoPanel()

		return
	end

	lastRegionId = regionId

	g_tooltip.hide()

	regionInfoPanel.activeWidget = widget

	widget.iconActive:show()
	regionInfoPanel:show()

	local pos = widget and widget:getPosition() or g_window.getMousePosition()

	regionInfoPanel:setPosition({
		x = pos.x,
		y = pos.y
	})

	local titleText = regionInfoPanel:recursiveGetChildById("title_text")
	local status = regionInfoPanel:recursiveGetChildById("status")
	local statusNormal = regionInfoPanel:recursiveGetChildById("status_normal")
	local statusTimer = status:recursiveGetChildById("status_timer")
	local timer = statusTimer:recursiveGetChildById("timer")
	local statusIconLeft = status:recursiveGetChildById("status_icon_left")
	local statusIconRight = status:recursiveGetChildById("status_icon_right")
	local description = regionInfoPanel:recursiveGetChildById("description")
	local bottomPanel = regionInfoPanel:recursiveGetChildById("bottom_panel")
	local bottomText = bottomPanel:recursiveGetChildById("bottom_text")

	titleText:setText(Regions[regionId].name)

	if not widget.regionInfo or not widget.regionInfo.timer then
		g_worldMap.hideRegionInfoPanel()

		return
	end

	timer.time = widget.regionInfo.timer - os.time()

	removeEvent(regionConflictTimerEvent)
	timer:setText(SecondsToClock(timer.time))

	local currentStatus = "peace"

	if widget.regionInfo.pvp then
		currentStatus = widget.regionInfo.warZone and "warzone" or "conflict"
	end

	local nextStatus = "peace"

	if widget.regionInfo.aboutToPvp then
		nextStatus = widget.regionInfo.warZone and "warzone" or "conflict"
	end

	local icon = widget.regionInfo.pvp and "conflict" or "peace"

	statusIconLeft:setImageSource(g_worldMap.getStatusIconPath(currentStatus))
	statusIconRight:setImageSource(g_worldMap.getStatusIconPath(nextStatus))

	local postfix = (g_game.isWarmodeChannel() or g_game.isPlunderModeChannel()) and "_warmode" or ""
	local type = widget.regionInfo.state .. postfix

	description:setText(regionConflictDescription[type] or "")

	if regionConflictBottomText[type] then
		bottomText:setText(regionConflictBottomText[type])
		bottomPanel:setVisible(true)
	else
		bottomPanel:setVisible(false)
	end

	if timer.time > 0 then
		status:setHeight(statusTimer:getHeight())
		statusTimer:show()
		statusNormal:hide()

		statusTimer.progress.lastPercent = math.floor(timer.time / regionConflictDuration * 100)

		statusTimer.progress.bar:setPercent(statusTimer.progress.lastPercent)

		local barColor = "#5DA4FB"

		if nextStatus == "conflict" then
			barColor = "#FFA851"
		elseif nextStatus == "warzone" then
			barColor = "#FF5151"
		end

		statusTimer.progress.bar:setBackgroundColor(barColor)

		local function timerJob()
			if not widget or not widget.regionInfo or not statusTimer then
				return
			end

			timer.time = widget.regionInfo.timer - os.time()

			timer:setText(SecondsToClock(timer.time))

			local newPercent = math.floor(timer.time / regionConflictDuration * 100)

			if not statusTimer.progress.lastPercent or statusTimer.progress.lastPercent ~= newPercent then
				statusTimer.progress.lastPercent = newPercent

				statusTimer.progress.bar:setPercent(newPercent)
			end

			regionConflictTimerEvent = scheduleEvent(function()
				if timer.time > 0 then
					timerJob()
				else
					regionConflictTimerEvent = nil
				end
			end, 1000)
		end

		regionConflictTimerEvent = scheduleEvent(function()
			timerJob()
		end, 1000)
	else
		removeEvent(regionConflictTimerEvent)
		statusTimer:hide()

		timer.time = 0

		timer:setText("")
		statusIconLeft:setImageSource("")
		statusIconRight:setImageSource("")
		status:setHeight(statusNormal:getHeight())
		statusNormal:show()
		statusNormal.status_icon:setImageSource(g_worldMap.getStatusIconPath(currentStatus))
		statusNormal.status_text:setText(currentStatus:gsub("^%l", string.upper))
	end

	addEvent(function()
		if not g_worldMap.window or not g_worldMap.image then
			return
		end

		local imageRect = g_worldMap.image:getRect()
		local height = 0

		for _, child in ipairs(regionInfoPanel:getChildren()) do
			if child:isVisible() then
				height = height + child:getHeight() + child:getMarginTop() + child:getMarginBottom()
			end
		end

		regionInfoPanel:setHeight(height)

		local panelSize = regionInfoPanel:getSize()

		pos.x = pos.x + 30

		if imageRect.x + imageRect.width - (pos.x + panelSize.width) < 10 then
			pos.x = pos.x - panelSize.width - 40
		else
			pos.x = pos.x + 10
		end

		if imageRect.y + imageRect.height - (pos.y + panelSize.height) < 10 then
			pos.y = pos.y - panelSize.height - 3

			if pos.y < imageRect.y then
				pos.y = imageRect.y + 10
			end
		else
			pos.y = pos.y + 10
		end

		regionInfoPanel:setPosition(pos)
	end)
end

function g_worldMap.onRegionConflictInfoChange()
	for regionId, regionInfo in pairs(g_worldMap.regionConflictInfo) do
		if Regions[regionId] then
			local state = "peace"

			if regionInfo.pvp then
				state = regionInfo.warZone and (regionInfo.timer > 0 and regionInfo.timer <= 900 and "warzone_peace" or "warzone") or regionInfo.timer > 0 and regionInfo.timer <= 900 and "conflict_peace" or "conflict"
			end

			if regionInfo.aboutToPvp then
				state = regionInfo.warZone and "peace_warzone" or "peace_conflict"
			end

			local flag = g_worldMap.getFlag(Regions[regionId].pos, MAPMARK_REGION_CONFLICT)

			if flag then
				flag.iconImage:setImageSource(g_worldMap.getStatusIconPath(state, not g_worldMap.fullmapView))

				flag.regionInfo = regionInfo
				flag.regionInfo.state = state
				flag.regionInfo.timer = os.time() + flag.regionInfo.timer

				if regionInfoPanel:isVisible() and lastRegionId == regionId then
					onConflictIconClicked(flag, regionId, true, true)
				end
			end
		end
	end
end

function g_worldMap.loadHouseMarks(houses)
	for _, house in ipairs(houses) do
		local flag = g_worldMap.getFlag(house.position, MAPMARK_HOUSE)

		if flag then
			function flag.onClick(widget)
				onHouseClicked(flag, house)
			end
		end
	end
end

function onHouseClicked(widget, house, forceUpdate)
	local houseId = house.id

	if not forceUpdate and houseInfoPanel:isVisible() and lastHouseId == houseId then
		houseInfoPanel:hide()
		g_tooltip.display(widget:getTooltip())

		return
	end

	lastHouseId = houseId

	g_tooltip.hide()

	houseInfoPanel.houseId = houseId

	houseInfoPanel:setText("House")
	houseInfoPanel:show()

	local pos = widget and widget:getPosition() or g_window.getMousePosition()

	houseInfoPanel:setPosition({
		x = pos.x,
		y = pos.y
	})

	local timer = houseInfoPanel:recursiveGetChildById("timer")
	local iconLeft = houseInfoPanel:recursiveGetChildById("iconLeft")
	local iconRight = houseInfoPanel:recursiveGetChildById("iconRight")
	local description = houseInfoPanel:recursiveGetChildById("description")

	timer.time = house.cooldownTime - os.time()

	removeEvent(houseTimerEvent)
	timer:setText(SecondsToClock(timer.time))
	iconLeft:setImageSource("")
	iconRight:setImageSource("")
	description:setText("Teleport Home")
	description:setOn(true)

	if timer.time > 0 then
		timer:show()
		iconLeft:setImageSource("/images/ui/windows/minimap/icons/house")
		iconRight:setImageSource("/images/ui/windows/minimap/icons/house")
		description:setMarginTop(10)
		description:setOn(false)

		local function timerJob()
			timer.time = house.cooldownTime - os.time()

			timer:setText(SecondsToClock(timer.time))

			houseTimerEvent = scheduleEvent(function()
				if timer.time > 0 then
					timerJob()
				else
					houseTimerEvent = nil

					if houseInfoPanel:isVisible() then
						onHouseClicked(widget, house, true)
					end
				end
			end, 1000)
		end

		houseTimerEvent = scheduleEvent(timerJob, 1000)
	else
		removeEvent(houseTimerEvent)

		timer.time = 0

		timer:hide()
		timer:setText("")
		iconLeft:setImageSource("")
		iconRight:setImageSource("")
		description:setMarginTop(-30)
	end

	addEvent(function()
		local windowSize = g_window.getSize()
		local height = 0

		for _, child in ipairs(houseInfoPanel:getChildren()) do
			height = height + child:getHeight() + child:getMarginTop()
		end

		houseInfoPanel:setHeight(height - 30)

		local panelSize = houseInfoPanel:getSize()

		pos.x = pos.x + 30

		if windowSize.width - (pos.x + panelSize.width) < 10 then
			pos.x = pos.x - panelSize.width - 3
		else
			pos.x = pos.x + 10
		end

		if windowSize.height - (pos.y + panelSize.height) < 10 then
			pos.y = pos.y - panelSize.height - 3
		else
			pos.y = pos.y + 10
		end

		houseInfoPanel:setPosition(pos)
	end)
end

function onDynamicEventClicked(widget, eventId, forceUpdate)
	if not forceUpdate and dynamicEventInfoPanel:isVisible() and lastEventId == eventId then
		dynamicEventInfoPanel:hide()
		rootWidget:removeChild(dynamicEventInfoPanel)
		g_tooltip.display(widget:getTooltip())

		return
	end

	lastEventId = eventId

	g_tooltip.hide()
	dynamicEventInfoPanel:setText(DynamicEvents[eventId].name)
	dynamicEventInfoPanel:setWidth(math.max(300, dynamicEventInfoPanel:getTextSize().width + 20))
	dynamicEventInfoPanel:show()

	local pos = widget and widget:getPosition() or g_window.getMousePosition()

	dynamicEventInfoPanel:setPosition({
		x = pos.x,
		y = pos.y
	})

	local windowSize = g_window.getSize()
	local panelSize = dynamicEventInfoPanel:getSize()

	pos.x = pos.x + 30

	if windowSize.width - (pos.x + panelSize.width) < 10 then
		pos.x = pos.x - panelSize.width - 3
	else
		pos.x = pos.x + 10
	end

	if windowSize.height - (pos.y + panelSize.height) < 10 then
		pos.y = pos.y - panelSize.height - 3
	else
		pos.y = pos.y + 10
	end

	dynamicEventInfoPanel:setPosition(pos)

	if not rootWidget:hasChild(dynamicEventInfoPanel) then
		rootWidget:addChild(dynamicEventInfoPanel)
	end

	local timer = dynamicEventInfoPanel:recursiveGetChildById("timer")
	local description = dynamicEventInfoPanel:recursiveGetChildById("description")
	local level = dynamicEventInfoPanel:recursiveGetChildById("level")
	local scarcityWidget = dynamicEventInfoPanel:recursiveGetChildById("scarcity")

	timer.time = widget.eventInfo.timer - os.time()

	removeEvent(eventInfoTimerEvent)
	timer:setText(SecondsToClock(timer.time))
	description:setText(widget.eventInfo.description)
	level:setText(string.format("Lv. %i", widget.eventInfo.level))

	if widget.eventInfo then
		local scarcityRemainingTime = widget.eventInfo.scarcity or 0

		if scarcityRemainingTime > 0 then
			scarcityWidget:setHeight(145)
			scarcityWidget:show()

			timer.scarcityTime = os.time() + scarcityRemainingTime
		else
			scarcityWidget:setHeight(0)
			scarcityWidget:hide()
		end

		if timer.time > 0 then
			timer:show()
			description:setMarginTop(10)

			local function timerJob()
				if not widget or not widget.eventInfo then
					return
				end

				if timer.scarcityTime and timer.scarcityTime <= os.time() then
					scarcityWidget:setHeight(0)
					scarcityWidget:hide()

					timer.scarcityTime = nil
				end

				timer.time = widget.eventInfo.timer - os.time()

				timer:setText(SecondsToClock(timer.time))

				eventInfoTimerEvent = scheduleEvent(function()
					if timer.time > 0 then
						timerJob()
					else
						onDynamicEventClicked(widget, eventId, true)
					end
				end, 1000)
			end

			eventInfoTimerEvent = scheduleEvent(function()
				timerJob()
			end, 1000)
		else
			removeEvent(eventInfoTimerEvent)

			eventInfoTimerEvent = nil

			local flag = g_worldMap.getFlag(DynamicEvents[eventId].pos, MAPMARK_DYNAMICEVENT)

			if flag then
				flag:hide()
			end

			dynamicEventInfoPanel:hide()
		end

		local eventProgress = widget.eventInfo.eventProgress

		if eventProgress then
			dynamicEventInfoPanel.progressBox:show()
			dynamicEventInfoPanel.progressBox.overallProgressBar:setPercent(eventProgress.overall / eventProgress.goal * 100)

			if eventProgress.personal then
				dynamicEventInfoPanel.progressBox.personalProgressBar:show()
				dynamicEventInfoPanel.progressBox.personalProgressBar:setPercent(eventProgress.personal / eventProgress.goal * 100)
			else
				dynamicEventInfoPanel.progressBox.personalProgressBar:hide()
			end
		else
			dynamicEventInfoPanel.progressBox:hide()
		end
	end

	local heightChildren = {
		"progressBox",
		"level",
		"description",
		"scarcity"
	}
	local height = 0

	for _, child in ipairs(dynamicEventInfoPanel:getChildren()) do
		if table.find(heightChildren, child:getId()) then
			height = height + child:getHeight() + child:getMarginTop() + child:getMarginBottom()
		end
	end

	dynamicEventInfoPanel:setHeight(height)
end

function g_worldMap.hideDynamicEvents()
	for _, info in pairs(DynamicEvents) do
		local flag = g_worldMap.getFlag(info.pos, MAPMARK_DYNAMICEVENT)

		if flag then
			flag:hide()

			flag.hidden = true

			if flag.eventInfo then
				flag.eventInfo.inactive = true
			end
		end
	end
end

function g_worldMap.onEventInfoChange(data)
	g_worldMap.hideDynamicEvents()

	for eventId, eventInfo in pairs(data.events) do
		if DynamicEvents[eventId] then
			local flag = g_worldMap.getFlag(DynamicEvents[eventId].pos, MAPMARK_DYNAMICEVENT)

			if flag then
				flag:setImageSource("/images/ui/windows/minimap/icons/small/dynamic_event")

				flag.eventInfo = eventInfo
				flag.eventInfo.inactive = false
				flag.eventInfo.timer = eventInfo.endTimestamp

				if dynamicEventInfoPanel:isVisible() and lastEventId == eventId then
					onDynamicEventClicked(flag, eventId, true)
				end
			end
		end
	end

	g_worldMap.updateMap()
end

function g_worldMap.displayRegionLandInfo(region, landInfo)
	g_worldMap.destroyLandFlags()

	local regions

	if type(region) == "table" then
		regions = region
	elseif type(region) == "number" then
		regions = {
			region
		}
	end

	if not regions then
		return
	end

	local centerPos
	local invalid = true

	for _, regionId in ipairs(regions) do
		if LandPlots[regionId] then
			centerPos = Regions[regionId].pos
			invalid = false

			break
		end
	end

	if invalid then
		return
	end

	g_worldMap.zoom = 4

	for _, regionId in ipairs(regions) do
		if LandPlots[regionId] then
			for _, data in pairs(LandPlots[regionId]) do
				if landInfo[data.index] == 0 then
					local flag = g_worldMap.addLandFlag(data.pos, landSizeToIcon[data.size], "", true, 4, 10)

					if flag then
						flag.size = data.size
					end
				end
			end
		end
	end

	g_worldMap.updateVisibleLandMarks()
	g_worldMap.updateMap()
	g_worldMap.centerOnPosition(centerPos)
end

function g_worldMap.addLandFlag(pos, icon, description, temporary, minZoom, maxZoom, callback, profession)
	if temporary == nil then
		temporary = true
	end

	if not pos or not icon then
		return
	end

	minZoom = minZoom or 5
	maxZoom = maxZoom or 10
	temporary = temporary or false

	local flag = g_ui.createWidget("WorldMapIcon", g_worldMap.image)

	flag.pos = {
		x = (pos.x - g_worldMap.area.fromX) / (g_worldMap.area.toX - g_worldMap.area.fromX),
		y = (pos.y - g_worldMap.area.fromY) / (g_worldMap.area.toY - g_worldMap.area.fromY),
		z = pos.z
	}
	flag.position = pos
	flag.zoom = {
		min = minZoom,
		max = maxZoom
	}
	flag.description = description
	flag.icon = icon
	flag.temporary = temporary
	flag.profession = profession

	if type(tonumber(icon)) == "number" then
		local iconType = flag.profession and g_worldMap.iconAssets[icon][flag.profession] or g_worldMap.iconAssets[icon]

		if iconType then
			flag:setImageSource("/images/ui/windows/minimap/icons/small/" .. iconType)
		end
	end

	flag:setTooltip(description)

	if callback then
		flag.nosound = false

		function flag.onClick(widget)
			callback(widget)
		end
	end

	g_worldMap.updateWidgetPosition(flag, g_worldMap.image:getSize(), g_worldMap.getMapRect())
	table.insert(g_worldMap.landFlags, flag)

	return flag
end

function g_worldMap.destroyLandFlags()
	for _, flag in ipairs(g_worldMap.landFlags) do
		flag:destroy()
	end

	g_worldMap.landFlags = {}
end

function g_worldMap.resetLandViwerPanel()
	local currentOption = landViewerRegionComboBox and landViewerRegionComboBox:getCurrentOption()

	if currentOption and currentOption.text ~= "Select region" then
		g_worldMap.destroyLandFlags()
		landViewerRegionComboBox:setCurrentOption("Select region")
	end
end

function landViewerRegionChanged(widget)
	local regionId = RegionNameToId[widget:getText()]

	modules.game_house.GameHouse:sendOpcode({
		action = "land_info",
		region = regionId
	})
end

function g_worldMap.updateVisibleLandMarks()
	for _, mark in pairs(g_worldMap.landFlags) do
		mark.icon = tonumber(mark.icon)

		if landIconToWidgetSize[mark.icon] then
			if mark.size == 10 and not g_worldMap.landViewerSettings.showSmallEstate then
				mark:hide()

				mark.hidden = not g_worldMap.landViewerSettings.showSmallEstate
			elseif mark.size == 12 and not g_worldMap.landViewerSettings.showMediumEstate then
				mark:hide()

				mark.hidden = not g_worldMap.landViewerSettings.showMediumEstate
			elseif mark.size == 15 and not g_worldMap.landViewerSettings.showLargeEstate then
				mark:hide()

				mark.hidden = not g_worldMap.landViewerSettings.showLargeEstate
			elseif mark.size == 22 and not g_worldMap.landViewerSettings.showStronghold then
				mark:hide()

				mark.hidden = not g_worldMap.landViewerSettings.showStronghold
			elseif mark.size == 30 and not g_worldMap.landViewerSettings.showFort then
				mark:hide()

				mark.hidden = not g_worldMap.landViewerSettings.showFort
			else
				mark:show()

				mark.hidden = false
			end
		end
	end

	g_worldMap.updateMap()
end

function g_worldMap.updateZoneFlag(widget, visibilityChange)
	if g_worldMap.zoom < g_worldMap.zoneCfg.minZoom then
		return
	end

	local fontPercent = 1 - (g_worldMap.maxZoom - g_worldMap.zoom) / (g_worldMap.maxZoom - g_worldMap.zoneCfg.minZoom)
	local fontSize = math.round(g_worldMap.zoneCfg.fontMinSize + (g_worldMap.zoneCfg.fontMaxSize - g_worldMap.zoneCfg.fontMinSize) * fontPercent)

	if g_worldMap.fullmapView then
		fontSize = fontSize + g_worldMap.zoneCfg.fullmapViewExtraFontSize
	end

	if not widget.fontSize or widget.fontSize ~= fontSize then
		widget.fontSize = fontSize

		widget.name:setFont(g_worldMap.zoneCfg.font .. fontSize + (widget.name.extraFontSize or 0))
		widget.level:setFont(g_worldMap.zoneCfg.font .. fontSize)

		if widget.name:isVisible() then
			widget:setSize(widget.name:getSize())
		else
			widget:setSize({
				height = 1,
				width = widget.name:getWidth()
			})
		end
	elseif visibilityChange then
		if widget.name:isVisible() then
			widget:setSize(widget.name:getSize())
		else
			widget:setSize({
				height = 1,
				width = widget.name:getWidth()
			})
		end
	end
end

function g_worldMap.updateRegionFlag(widget)
	if g_worldMap.zoom > g_worldMap.regionCfg.maxZoom then
		widget.frame:setVisible(false)

		return
	end

	widget.frame:setVisible(true)

	local fontPercent = (g_worldMap.zoom - g_worldMap.minZoom) / (g_worldMap.regionCfg.maxZoom - g_worldMap.minZoom)
	local fontSize = math.round(g_worldMap.regionCfg.fontMinSize + (g_worldMap.regionCfg.fontMaxSize - g_worldMap.regionCfg.fontMinSize) * fontPercent)

	if g_worldMap.fullmapView then
		fontSize = fontSize + g_worldMap.regionCfg.fullmapViewExtraFontSize
	end

	if not widget.frame.fontSize or widget.frame.fontSize ~= fontSize then
		widget.frame.fontSize = fontSize

		widget.frame.text:setFont(g_worldMap.regionCfg.font .. fontSize)
	end
end

function g_worldMap.canShowCompassFlagOnFloor(flag, floor)
	if not floor then
		return false
	end

	local floorInfo = flag.floorInfo

	if not floorInfo then
		return true
	end

	if floorInfo.all then
		return true
	end

	if floorInfo.at then
		if type(floorInfo.at) == "table" then
			if table.contains(floorInfo.at, floor) then
				return true
			end
		elseif floorInfo.at == floor then
			return true
		end
	end

	if floorInfo.from and floorInfo.to then
		if floor >= floorInfo.from and floor <= floorInfo.to then
			return true
		end
	else
		if floorInfo.from and floor >= floorInfo.from then
			return true
		end

		if floorInfo.to and floor <= floorInfo.to then
			return true
		end
	end

	if floorInfo.between and floor >= floorInfo.between[1] and floor <= floorInfo.between[2] then
		return true
	end

	return false
end

function g_worldMap.isCompassFlagHidden(flag)
	return not g_worldMap.iconSettings.showAutomaticHighlights and flag.automatic or not g_worldMap.canShowCompassFlagOnFloor(flag, playerCurrentFloor)
end

function g_worldMap.getCompassTextureNameBySize(size)
	for _, data in ipairs(compassSizeToImage) do
		if not data.size or size <= data.size then
			return data.name
		end
	end

	return nil
end

function g_worldMap.updateCompassHighlightWidgetSize(widget, newSize)
	if not widget.currentSize or widget.currentSize ~= newSize then
		local imageName

		for _, data in ipairs(compassSizeToImage) do
			if not data.size or newSize <= data.size then
				imageName = data.name

				break
			end
		end

		if imageName and (not widget.imageName or widget.imageName ~= imageName) then
			imageName = string.format(imageName, widget.cullingSpawn and "red" or "default")

			widget:setImageSource(imageName)

			widget.imageName = imageName
		end

		widget:setSize({
			width = newSize,
			height = newSize
		})

		widget.currentSize = newSize

		widget:raise()

		return true
	end

	return false
end

function g_worldMap.updateVisibleCompassHighlightFlags()
	if not playerCurrentFloor then
		return
	end

	for _, flag in pairs(g_worldMap.compassHighlights) do
		flag.hidden = g_worldMap.isCompassFlagHidden(flag)

		if flag.hidden then
			flag:hide()
		else
			flag:show()
			flag:raise()
		end
	end

	modules.game_minimap.updateMapFlags()
end

function g_worldMap.displayQuestTaskCompass(questName, taskId)
	local questFlags = {}

	for _, flag in pairs(g_worldMap.compassHighlights) do
		if flag.questName == questName and (not taskId or flag.taskId == taskId) and g_worldMap.canShowCompassFlagOnFloor(flag, playerCurrentFloor) then
			table.insert(questFlags, flag)
		end
	end

	if #questFlags == 0 then
		return
	end

	local centerPos

	if #questFlags > 1 then
		local minX, minY, maxX, maxY

		for _, flag in ipairs(questFlags) do
			local radius = (flag.compassSize and flag.compassSize / 2 or 0) + 5

			if not minX or minX > flag.position.x - radius then
				minX = flag.position.x - radius
			end

			if not minY or minY > flag.position.y - radius then
				minY = flag.position.y - radius
			end

			if not maxX or maxX < flag.position.x + radius then
				maxX = flag.position.x + radius
			end

			if not maxY or maxY < flag.position.y + radius then
				maxY = flag.position.y + radius
			end
		end

		local flagsRect = {
			x = minX + (maxX - minX) / 2,
			y = minY + (maxY - minY) / 2,
			width = maxX - minX,
			height = maxY - minY
		}
		local worldSize = g_worldMap.image:getSize()
		local imageWidth = g_worldMap.image:getImageTextureWidth()
		local imageHeight = g_worldMap.image:getImageTextureHeight()
		local pWidth = worldSize.width / imageWidth * (g_worldMap.area.toX - g_worldMap.area.fromX)
		local pHeight = worldSize.height / imageHeight * (g_worldMap.area.toY - g_worldMap.area.fromY)
		local flagsRectZoom = g_worldMap.maxZoom / math.max(flagsRect.width / pWidth, flagsRect.height / pHeight)

		flagsRectZoom = math.max(flagsRectZoom, g_worldMap.minZoom)
		g_worldMap.zoom = math.min(5, flagsRectZoom)
		centerPos = {
			x = flagsRect.x,
			y = flagsRect.y,
			flagsRect.z
		}
	else
		g_worldMap.zoom = 5
		centerPos = questFlags[1].position
	end

	g_worldMap.window:show()
	g_worldMap.window:raise()
	g_worldMap.window:focus()

	for _, flag in ipairs(questFlags) do
		if flag and g_worldMap.canShowCompassFlagOnFloor(flag, playerCurrentFloor) then
			flag.hidden = false
			flag.automatic = false

			flag:show()
			g_effects.startBlink(flag, 15000, 500, true)
		end
	end

	g_worldMap.centerOnPosition(centerPos)
	addEvent(function()
		modules.game_minimap.updateMapFlags()
	end)
end

function g_worldMap.addCompassData(data, questName, taskId, taskDescription, automatic)
	if data then
		if data.pos then
			data = {
				data
			}
		end

		for _, compass in ipairs(data) do
			local flag = g_worldMap.displayPositionFromCompass(compass, questName, taskId, taskDescription, automatic)

			if flag and data.cullingSpawn then
				flag.cullingSpawn = true
			end
		end
	end

	if not automatic then
		g_worldMap.displayQuestTaskCompass(questName, taskId)
	else
		addEvent(function()
			modules.game_minimap.updateMapFlags()
		end)
	end
end

function g_worldMap.removeCompassData(questName, taskId)
	for _, flag in pairs(g_worldMap.compassHighlights) do
		if flag.questName == questName and (not taskId or flag.taskId == taskId) then
			g_worldMap.removeCompassHighlight(flag)
		end
	end

	addEvent(function()
		modules.game_minimap.updateMapFlags()
	end)
end

function g_worldMap.displayPositionFromCompass(compass, questName, taskId, taskDescription, automatic)
	local pos = compass.pos

	if not pos then
		return
	end

	local currentFlag = g_worldMap.getCompassHighlight(pos)

	currentFlag = currentFlag or g_worldMap.addCompassHighlight(compass, questName, taskId, taskDescription, automatic)

	return currentFlag
end

function g_worldMap.addCompassHighlight(compass, questName, taskId, taskDescription, automatic)
	g_worldMap.updateImageData()

	local flag = g_ui.createWidget("WorldMapCompassHighlight", g_worldMap.image)

	flag.pos = {
		x = (compass.pos.x - g_worldMap.area.fromX) / (g_worldMap.area.toX - g_worldMap.area.fromX),
		y = (compass.pos.y - g_worldMap.area.fromY) / (g_worldMap.area.toY - g_worldMap.area.fromY),
		z = compass.pos.z
	}
	flag.position = compass.pos
	flag.zoom = {
		min = 0,
		max = 20
	}
	flag.questName = questName
	flag.taskId = taskId
	flag.floorInfo = compass.floorInfo

	local size = compass.size or (compass.sizeIndex and CompassSize[compass.sizeIndex] or CompassDefaultSize) + 2
	local description = tr(questName) .. "\n" .. tr(taskDescription)

	flag.description = description
	flag.icon = MAPMARK_COMPASS
	flag.temporary = true
	flag.automatic = automatic
	flag.compassSize = size

	flag:setTooltip(flag.description:wrap(7))

	function flag.onDestroy()
		table.removevalue(g_worldMap.flags, flag)
	end

	flag:setSize({
		width = size,
		height = size
	})
	table.insert(g_worldMap.flags, flag)

	g_worldMap.compassHighlights[Position.generateHash(flag.position)] = flag

	addEvent(function()
		g_worldMap.updateMap()
	end)
	signalcall(g_worldMap.onAddCompassHighlight, g_worldMap, flag)

	return flag
end

function g_worldMap.getCompassHighlight(pos)
	return g_worldMap.compassHighlights[Position.generateHash(pos)]
end

function g_worldMap.removeCompassHighlight(flag)
	local pos = flag.position

	if not pos then
		return
	end

	local f = g_worldMap.getFlag(pos, flag.icon, flag.description)

	if f then
		g_worldMap.removeFlag(pos, flag.icon, flag.description)

		g_worldMap.compassHighlights[Position.generateHash(pos)] = nil

		return
	end

	g_worldMap.compassHighlights[Position.generateHash(pos)] = nil

	flag:destroy()
end

function g_worldMap.destroyHighlights(onlyNonAutomatic)
	if table.empty(g_worldMap.compassHighlights) then
		return
	end

	for _, flag in pairs(g_worldMap.compassHighlights) do
		if onlyNonAutomatic and not flag.automatic then
			flag.automatic = true
		elseif not onlyNonAutomatic then
			g_worldMap.removeCompassHighlight(flag)
		end
	end

	if onlyNonAutomatic then
		modules.game_minimap.updateMapFlags()
	end
end

function g_worldMap.parseQuestMarkData(data)
	if data.type == "update_all" then
		for _, flag in pairs(g_worldMap.questFlags) do
			modules.game_minimap.removeFlag(flag.position, flag.icon, flag.description)
			flag:destroy()

			flag = nil
		end

		g_worldMap.questFlags = {}

		for _, mark in ipairs(data.marks) do
			g_worldMap.addQuestFlag(mark.pos, mark.type, mark.description, mark.region, mark.alwaysShow, true)
		end

		modules.game_minimap.updateMapFlags()
	elseif data.type == "add" then
		g_worldMap.addQuestFlag(data.mark.pos, data.mark.type, data.mark.description, data.mark.region, data.mark.alwaysShow)
	elseif data.type == "remove" then
		g_worldMap.removeQuestFlag(data.mark.pos, data.mark.type, data.mark.description)
	end
end

function g_worldMap.isQuestFlag(icon)
	if not icon then
		return
	end

	return table.contains({
		MAPMARK_MISSION_AVAILABLE,
		MAPMARK_MISSION_IN_PROGRESS,
		MAPMARK_MISSION_COMPLETE
	}, icon)
end

function g_worldMap.createQuestFlag(pos, icon, description, region, alwaysShow)
	local flag = g_ui.createWidget("WorldMapIcon", g_worldMap.image)

	flag.pos = {
		x = (pos.x - g_worldMap.area.fromX) / (g_worldMap.area.toX - g_worldMap.area.fromX),
		y = (pos.y - g_worldMap.area.fromY) / (g_worldMap.area.toY - g_worldMap.area.fromY),
		z = pos.z
	}
	flag.position = pos
	flag.icon = icon
	flag.description = description
	flag.region = region
	flag.alwaysShow = alwaysShow
	flag.zoom = {
		min = 5,
		max = 10
	}
	flag.temporary = true

	flag:setImageSource("/images/ui/windows/minimap/icons/small/" .. g_worldMap.iconAssets[icon])
	flag:setTooltip(description)

	function flag.onDestroy()
		g_worldMap.questFlags[Position.generateHash(pos)] = nil

		removeNpcIconByPos(pos)
	end

	return flag
end

function g_worldMap.getQuestFlag(pos, icon, description)
	local flag = g_worldMap.questFlags[Position.generateHash(pos)]

	if not flag then
		return nil
	end

	if icon and icon ~= flag.icon or description and description ~= flag.description then
		return nil
	end

	return flag
end

function g_worldMap.addQuestFlag(pos, icon, description, region, alwaysShow, notUpdateMiniMap)
	if not pos or not icon or not description then
		return
	end

	local flag = g_worldMap.getQuestFlag(pos, icon, description)

	if flag then
		if icon == flag.icon and description == flag.description then
			return
		end

		flag:destroy()
	end

	flag = g_worldMap.createQuestFlag(pos, icon, description, region, alwaysShow)

	g_worldMap.updateWidgetPosition(flag, g_worldMap.image:getSize(), g_worldMap.getMapRect())

	g_worldMap.questFlags[Position.generateHash(pos)] = flag

	if not notUpdateMiniMap then
		modules.game_minimap.updateMapFlags()
	end

	if icon == MAPMARK_MISSION_AVAILABLE then
		setNpcIconByPos(pos, NpcIcons.QuestAvailable)
	elseif icon == MAPMARK_MISSION_COMPLETE then
		setNpcIconByPos(pos, NpcIcons.QuestActive)
	else
		removeNpcIconByPos(pos)
	end

	return flag
end

function g_worldMap.removeQuestFlag(pos, icon, description)
	if not pos then
		return
	end

	local flag = g_worldMap.getQuestFlag(pos, icon, description)

	if flag then
		flag:destroy()

		flag = nil

		modules.game_minimap.removeFlag(pos, icon, description)
		modules.game_minimap.updateMapFlags()
	end
end

function g_worldMap.onOutfitChange(player)
	local useOutfit = player:getOutfit()

	if useOutfit.shipBody == useOutfit.lookType then
		useOutfit = player:getTemporaryOutfit()
	end

	for key, value in pairs(useOutfit) do
		local val = table.find(MOUNTS_PLAYER_LOOK, value)

		if val then
			useOutfit[key] = val
		end
	end

	local parsedOutfit = {
		wagonActive = 0,
		mount = 0,
		lookType = useOutfit.lookType,
		primaryAddon = useOutfit.primaryAddon,
		secondaryAddon = useOutfit.secondaryAddon,
		bodyColor = useOutfit.bodyColor,
		headColor = useOutfit.headColor,
		legsColor = useOutfit.legsColor,
		feetColor = useOutfit.feetColor,
		category = ThingCategoryCreature
	}

	g_worldMap.cross.playerOutfit:setOutfit(parsedOutfit)
	addEvent(function()
		local minimap = modules.game_minimap.minimapWindow

		if minimap and minimap.cross then
			minimap.cross.playerOutfit:setOutfit(parsedOutfit)
		end
	end)
end

function g_worldMap.onEffectiveLevelChange(player, level)
	for _, zoneFlag in pairs(g_worldMap.zoneFlags) do
		if zoneFlag.minLevel and zoneFlag.maxLevel then
			local monsterDiff = g_hud.getGameInteger(HudGameIntegers.MonsterLevelDiff)

			if monsterDiff < level - zoneFlag.maxLevel then
				zoneFlag.level:setTextColor(g_hud.getGameColor(HudGameColors.NameColorMonsterWeak))
			elseif monsterDiff < zoneFlag.minLevel - level then
				zoneFlag.level:setTextColor(g_hud.getGameColor(HudGameColors.NameColorMonsterHigh))
			else
				zoneFlag.level:setTextColor(g_hud.getGameColor(HudGameColors.NameColorMonsterNormal))
			end
		end
	end
end

function g_worldMap.addCullingSpawn(data)
	data.compassData.cullingSpawn = true

	g_worldMap.addCompassData(data.compassData, data.name, 1, "", true)
end

function g_worldMap.removeCullingSpawn(data)
	g_worldMap.removeCompassData(data.name, 1)
end

function g_worldMap.updateZoneWarsFlagCarrierPosition(icon, description, fromPosition, toPosition)
	local flag = g_worldMap.getFlag(fromPosition, icon, description)

	if not flag then
		fromPosition.x = fromPosition.x - g_worldMap.getCustomMapPositionOffset(fromPosition).x
		flag = g_worldMap.getFlag(fromPosition, icon, description)

		if not flag then
			return
		end
	end

	flag.position = toPosition
	flag.pos = {
		x = (toPosition.x - g_worldMap.getCustomMapPositionOffset(toPosition).x - g_worldMap.area.fromX) / (g_worldMap.area.toX - g_worldMap.area.fromX),
		y = (toPosition.y - g_worldMap.area.fromY) / (g_worldMap.area.toY - g_worldMap.area.fromY),
		z = toPosition.z
	}

	g_worldMap.updateWidgetPosition(flag, g_worldMap.image:getSize(), g_worldMap.getMapRect())
	flag:raise()
	modules.game_minimap.updateFlagPosition(fromPosition, toPosition, icon, description)
	modules.game_minimap.updateMapFlags()
end
