-- chunkname: @/modules/game_sounds/sounds.lua

SWITCH_GROUP_FOOTSTEP = 442453602
SWITCH_FOOTSTEP_DIRT = 2195636714
SWITCH_FOOTSTEP_GRASS = 4248645337
SWITCH_FOOTSTEP_SAND = 803837735
SWITCH_FOOTSTEP_SNOW = 787898836
SWITCH_FOOTSTEP_STONE = 1216965916
SWITCH_FOOTSTEP_WATER = 2654748154
SWITCH_FOOTSTEP_WOOD = 2058049674
SWITCH_FOOTSTEP_FOREST = 491961918
SWITCH_FOOTSTEP_MOSS = 2927316363
SWITCH_FOOTSTEP_ICE = 344481046
EVENT_AMBIANCE_BEES = 4236470071
EVENT_AMBIANCE_DESERT = 3710773947
EVENT_AMBIANCE_DOCK = 3550670165
EVENT_AMBIANCE_FADE = 3519436098
EVENT_AMBIANCE_FIRE_LANTERN = 430171897
EVENT_AMBIANCE_FIRE_SMALL = 1312909528
EVENT_AMBIANCE_FOREST = 576612531
EVENT_AMBIANCE_JUNGLE = 3458040963
EVENT_AMBIANCE_NATURE_BIRDS = 2244390260
EVENT_AMBIANCE_NATURE_CRICKETS = 2643647896
EVENT_AMBIANCE_NATURE_WIND_DESERT = 2044549898
EVENT_AMBIANCE_NATURE_WIND_MOUNTAINS = 1429036299
EVENT_AMBIANCE_NATURE_WIND_SNOW = 3840040116
EVENT_AMBIANCE_NATURE_WIND_TREES_RUSTLING = 371239405
EVENT_AMBIANCE_RAIN_HEAVY = 42869514
EVENT_AMBIANCE_RAIN_HEAVY_FADE = 65048047
EVENT_AMBIANCE_RAIN_LIGHT = 1459644335
EVENT_AMBIANCE_RAIN_LIGHT_FADE = 1189854320
EVENT_AMBIANCE_SHIP = 2475813806
EVENT_AMBIANCE_TOWN_BLACKSMITH = 3249562593
EVENT_AMBIANCE_TOWN_CHIMNEY = 4230115304
EVENT_AMBIANCE_TOWN_MARKETPLACE = 3812923292
EVENT_AMBIANCE_TOWN_RAVENCREST = 563039996
EVENT_AMBIANCE_TOWN_TAVERN = 1476716309
EVENT_AMBIANCE_WATER_CALM_POSITIONAL = 1645804590
EVENT_AMBIANCE_WATER_FOUNTAIN_POSITIONAL = 3530391769
EVENT_AMBIANCE_WATER_OCEAN = 4138114698
EVENT_AMBIANCE_WATER_RIVER_SMALL = 2959215674
EVENT_AMBIANCE_WATER_WATERFALL = 2586460602
EVENT_ARROW_IMPACT = 2441116921
EVENT_BOW_CHARGE = 2260571858
EVENT_BOW_RELEASE = 3821338389
EVENT_MAGIC_FIREBALL_CASTING = 2494789284
EVENT_MAGIC_FIREBALL_LAUNCH = 647786996
EVENT_MAGIC_ICEBALL_CASTING = 3370598399
EVENT_MAGIC_ICEBALL_CASTING_LAUNCH = 3407522619
EVENT_MUSIC = 202194903
EVENT_MUSIC_FADE = 2748083475
EVENT_PLAYER_FOOTSTEP = 2453392179
EVENT_SMALL_CREATURE_FOOTSTEP = 2108904927
EVENT_MEDIUM_CREATURE_FOOTSTEP = 3964217241
EVENT_BIG_CREATURE_FOOTSTEP = 486288035
EVENT_SWORD_IMPACT_SMALL = 1006039825
EVENT_MUSIC_PLAYLIST_TEMPORARY = 1604018434
EVENT_MUSIC_GUILD_WARS = 3060909529
EVENT_MUSIC_AETHER_RIFT = 794718825
EVENT_MUSIC_AETHER_RIFT_BOSS_BATTLE = 1918952090
EVENT_MUSIC_AETHER_ECHO_EASY = 83593967
EVENT_MUSIC_AETHER_ECHO_MEDIUM = 1782952361
EVENT_MUSIC_AETHER_ECHO_HARD = 2986800604
EVENT_MUSIC_AETHER_ECHO_MADNESS = 335367941
PARAM_DAY_NIGHT_CYCLE = 671444909
VOLUME_AMBIANCE = 1663494310
VOLUME_MASTER = 3695994288
VOLUME_MUSIC = 3891337659
VOLUME_SFX = 3673881719
VOLUME_UI = 4212040332
VOLUME_VOICE = 3676256460
VOLUME_CONTROL = 4194816893
SOUND_CHANGE_PER_TILE = 0.1
FOOTSTEP_MAX_VOLUME = 0.5
FOOTSTEP_CHANGE_PER_TILE = 0.05
CONST_SE_PROFESSION_FADE = 1061120233
CONST_SE_MUSIC_FADE = 2748083475
CONST_SE_CASTING_STOP = 1403532631
CONST_SE_CHANNEL_MAGIC_ITEM_FADE = 394169660
CONST_SE_MINING = 2823440819
CONST_SE_WOODCUTTING = 4184701604
CONST_SE_DYNAMIC_EVENT_STARTING = 768002248
CONST_SE_ZONE_PEACE_TO_PVP = 3624410068
CONST_SE_ZONE_PVP_TO_PEACE = 3266013748
FOOTSTEP_TYPES = {
	BIG_CREATURE = 4,
	MEDIUM_CREATURE = 3,
	SMALL_CREATURE = 2,
	PLAYER = 1
}
CONST_ALL_GAME_OBJECTS = g_wwise and g_wwise.getAllObjectsConst() or -1

local minimized = false
local lastClickEvent = 0
local lastHoverEvent = 0
local lastVisibilityChangeEvent = 0

g_sound = {
	ravencardsAnimationEmitterId = 300,
	channelId = 0,
	channelName = "",
	localEmitterId = 200,
	listenerId = 100,
	initialized = false,
	playingIDs = {},
	regionSounds = {},
	loadedSoundbanks = {},
	ambienceSounds = {},
	positionIndexed = {},
	positionSounds = {
		{
			soundId = 983855968,
			position = {
				x = 3274,
				z = 8,
				y = 5607
			}
		},
		{
			soundId = 983855968,
			position = {
				x = 3280,
				z = 8,
				y = 5598
			}
		},
		{
			soundId = 983855968,
			position = {
				x = 3289,
				z = 8,
				y = 5591
			}
		},
		{
			soundId = 983855968,
			position = {
				x = 3284,
				z = 8,
				y = 5584
			}
		},
		{
			soundId = 983855968,
			position = {
				x = 3280,
				z = 8,
				y = 5572
			}
		},
		{
			soundId = 983855968,
			position = {
				x = 3271,
				z = 8,
				y = 5572
			}
		},
		{
			soundId = 983855968,
			position = {
				x = 3264,
				z = 8,
				y = 5576
			}
		},
		{
			soundId = 983855968,
			position = {
				x = 3255,
				z = 8,
				y = 5576
			}
		},
		{
			soundId = 983855968,
			position = {
				x = 3250,
				z = 8,
				y = 5571
			}
		},
		{
			soundId = 983855968,
			position = {
				x = 3264,
				z = 8,
				y = 5562
			}
		},
		{
			soundId = 2977901581,
			position = {
				x = 3260,
				z = 8,
				y = 5545
			}
		},
		{
			soundId = 2977901581,
			position = {
				x = 3266,
				z = 8,
				y = 5551
			}
		},
		{
			soundId = 2977901581,
			position = {
				x = 3265,
				z = 8,
				y = 5539
			}
		},
		{
			soundId = 2977901581,
			position = {
				x = 3279,
				z = 8,
				y = 5541
			}
		},
		{
			soundId = 2977901581,
			position = {
				x = 3283,
				z = 8,
				y = 5530
			}
		},
		{
			soundId = 2977901581,
			position = {
				x = 3268,
				z = 8,
				y = 5520
			}
		},
		{
			soundId = 2977901581,
			position = {
				x = 3270,
				z = 8,
				y = 5504
			}
		},
		{
			soundId = 2977901581,
			position = {
				x = 3282,
				z = 8,
				y = 5498
			}
		},
		{
			soundId = 2977901581,
			position = {
				x = 3262,
				z = 8,
				y = 5496
			}
		},
		{
			soundId = 2977901581,
			position = {
				x = 3269,
				z = 8,
				y = 5488
			}
		},
		{
			soundId = 2977901581,
			position = {
				x = 3278,
				z = 8,
				y = 5491
			}
		}
	},
	footStepTypeToSoundId = {
		[FOOTSTEP_TYPES.PLAYER] = EVENT_PLAYER_FOOTSTEP,
		[FOOTSTEP_TYPES.SMALL_CREATURE] = EVENT_SMALL_CREATURE_FOOTSTEP,
		[FOOTSTEP_TYPES.MEDIUM_CREATURE] = EVENT_MEDIUM_CREATURE_FOOTSTEP,
		[FOOTSTEP_TYPES.BIG_CREATURE] = EVENT_BIG_CREATURE_FOOTSTEP
	},
	feetSounds = {
		grass = {
			soundId = EVENT_PLAYER_FOOTSTEP,
			switchId = SWITCH_FOOTSTEP_GRASS,
			switchGroup = SWITCH_GROUP_FOOTSTEP
		},
		dirt = {
			soundId = EVENT_PLAYER_FOOTSTEP,
			switchId = SWITCH_FOOTSTEP_DIRT,
			switchGroup = SWITCH_GROUP_FOOTSTEP
		},
		sand = {
			soundId = EVENT_PLAYER_FOOTSTEP,
			switchId = SWITCH_FOOTSTEP_SAND,
			switchGroup = SWITCH_GROUP_FOOTSTEP
		},
		snow = {
			soundId = EVENT_PLAYER_FOOTSTEP,
			switchId = SWITCH_FOOTSTEP_SNOW,
			switchGroup = SWITCH_GROUP_FOOTSTEP
		},
		stone = {
			soundId = EVENT_PLAYER_FOOTSTEP,
			switchId = SWITCH_FOOTSTEP_STONE,
			switchGroup = SWITCH_GROUP_FOOTSTEP
		},
		wood = {
			soundId = EVENT_PLAYER_FOOTSTEP,
			switchId = SWITCH_FOOTSTEP_WOOD,
			switchGroup = SWITCH_GROUP_FOOTSTEP
		},
		water = {
			soundId = EVENT_PLAYER_FOOTSTEP,
			switchId = SWITCH_FOOTSTEP_WATER,
			switchGroup = SWITCH_GROUP_FOOTSTEP
		},
		moss = {
			soundId = EVENT_PLAYER_FOOTSTEP,
			switchId = SWITCH_FOOTSTEP_MOSS,
			switchGroup = SWITCH_GROUP_FOOTSTEP
		},
		forest = {
			soundId = EVENT_PLAYER_FOOTSTEP,
			switchId = SWITCH_FOOTSTEP_FOREST,
			switchGroup = SWITCH_GROUP_FOOTSTEP
		},
		ice = {
			soundId = EVENT_PLAYER_FOOTSTEP,
			switchId = SWITCH_FOOTSTEP_ICE,
			switchGroup = SWITCH_GROUP_FOOTSTEP
		}
	},
	channeling = {
		fireball = EVENT_MAGIC_FIREBALL_CASTING,
		frostbolt = EVENT_MAGIC_ICEBALL_CASTING
	},
	regions = {
		town = {
			from = {
				x = 5106,
				z = 1,
				y = 5100
			},
			to = {
				x = 5172,
				z = 6,
				y = 5140
			},
			soundId = EVENT_AMBIANCE_TOWN_RAVENCREST
		},
		meadow = {
			from = {
				x = 5175,
				z = 1,
				y = 5055
			},
			to = {
				x = 5226,
				z = 7,
				y = 5124
			},
			soundId = EVENT_AMBIANCE_NATURE_BIRDS
		},
		dock = {
			from = {
				x = 5085,
				z = 4,
				y = 5100
			},
			to = {
				x = 5105,
				z = 7,
				y = 5115
			},
			soundId = EVENT_AMBIANCE_DOCK
		},
		tavern = {
			from = {
				x = 5140,
				z = 5,
				y = 5086
			},
			to = {
				x = 5161,
				z = 7,
				y = 5100
			},
			sounds = {
				EVENT_AMBIANCE_TOWN_TAVERN,
				EVENT_AMBIANCE_FIRE_SMALL
			}
		},
		forest = {
			from = {
				x = 5174,
				z = 7,
				y = 5085
			},
			to = {
				x = 5250,
				z = 9,
				y = 5140
			},
			soundId = EVENT_AMBIANCE_FOREST
		},
		desert = {
			from = {
				x = 4950,
				z = 7,
				y = 5331
			},
			to = {
				x = 5150,
				z = 7,
				y = 5531
			},
			soundId = EVENT_AMBIANCE_DESERT
		},
		["astor demon lava"] = {
			from = {
				x = 3256,
				z = 8,
				y = 5484
			},
			to = {
				x = 3291,
				z = 8,
				y = 5555
			},
			soundId = EVENT_AMBIANCE_DESERT
		},
		["astor demon dungeon"] = {
			soundId = 452043504,
			from = {
				x = 3238,
				z = 8,
				y = 5554
			},
			to = {
				x = 3291,
				z = 8,
				y = 5623
			}
		}
	}
}

function g_sound:loadConfig()
	local func, error = loadfile("config.lua")

	if not func then
		g_logger.fatal(error)

		return false
	end

	func()

	local env = getfenv(0)

	env.cfg = {}

	setmetatable(env.cfg, {
		__index = env
	})
	setfenv(func, env.cfg)

	return true
end

function g_sound.isLocalEmitter(emitterId)
	return emitterId == g_sound.localEmitterId or emitterId == g_sound.ravencardsAnimationEmitterId
end

function g_sound.init()
	if not g_sound or g_sound.initialized or g_wwise == nil then
		return
	end

	g_sound.loadConfig()

	g_sound.positionIndexed = {}

	for _, sound in ipairs(g_sound.positionSounds) do
		g_sound.positionIndexed[Position.generateHash(sound.position)] = sound.soundId
	end

	connect(g_map, {
		onEffect = g_sound.onEffect,
		onSoundEffect = g_sound.onSoundEffect,
		onMissile = g_sound.onMissile
	})
	connect(Creature, {
		onPositionChange = g_sound.onPositionChange,
		onChannelingSound = g_sound.onChanneling,
		onDisappear = g_sound.removeGameObject,
		onFrameSound = g_sound.onFrameSound
	})
	connect(LocalPlayer, {
		onPositionChange = g_sound.onPositionChange,
		onShipChange = g_sound.onShipChange
	})
	connect(g_game, {
		onGameStart = g_sound.online,
		onGameEnd = g_sound.offline,
		onTimeChange = g_sound.onTimeChange,
		onStopSoundEffect = g_sound.stopSoundEffect,
		onDeath = g_sound.onDeath,
		onRegionChange = g_sound.onRegionChange
	})
	connect(Tile, {
		onAddAmbienceSound = g_sound.onAddAmbienceSound,
		onRemoveAmbienceSound = g_sound.onRemoveAmbienceSound,
		onAppear = g_sound.onAddPositionSound,
		onDisappear = g_sound.onRemovePositionSound
	})
	connect(g_app, {
		onMinimize = g_sound.onMinimize
	})
	connect(UIWidget, {
		onHoverChange = g_sound.onWidgetHover,
		onClick = g_sound.onWidgetClick
	})
	g_wwise.addGameObject(g_sound.listenerId, "Listener")
	g_wwise.addGameObject(g_sound.localEmitterId, "LocalEmitterId")
	g_wwise.addGameObject(g_sound.ravencardsAnimationEmitterId, "RavencardsAnimationEmitterId")
	g_sound.play(EVENT_MUSIC)

	g_sound.initialized = true
	g_sound.cleanupEvent = cycleEvent(function()
		g_sound.tryUnloadSoundbanks()
	end, 5000)
end

function g_sound.terminate()
	if g_wwise == nil then
		return
	end

	g_sound.action(EVENT_MUSIC)
	disconnect(g_map, {
		onEffect = g_sound.onEffect,
		onSoundEffect = g_sound.onSoundEffect,
		onMissile = g_sound.onMissile
	})
	disconnect(Creature, {
		onPositionChange = g_sound.onPositionChange,
		onChannelingSound = g_sound.onChanneling
	})
	disconnect(LocalPlayer, {
		onPositionChange = g_sound.onPositionChange,
		onShipChange = g_sound.onShipChange
	})
	disconnect(g_game, {
		onGameStart = g_sound.online,
		onGameEnd = g_sound.offline,
		onTimeChange = g_sound.onTimeChange,
		onStopSoundEffect = g_sound.stopSoundEffect,
		onDeath = g_sound.onDeath,
		onRegionChange = g_sound.onRegionChange
	})
	disconnect(Tile, {
		onAddAmbienceSound = g_sound.onAddAmbienceSound
	})
	disconnect(g_app, {
		onMinimize = g_sound.onMinimize
	})
	disconnect(UIWidget, {
		onHoverChange = g_sound.onWidgetHover,
		onClick = g_sound.onWidgetClick
	})

	g_sound.initialized = false
end

function g_sound.onMinimize(visible)
	minimized = not visible
end

function g_sound.online()
	g_sound.action(EVENT_MUSIC)
	g_sound.resetPlaylistMusic()
	scheduleEvent(function()
		local player = g_game.getLocalPlayer()

		if player then
			g_sound.onRegionSound(player)
		end
	end, 1000)
end

function g_sound.offline()
	g_sound.stopPlaylistMusic()
	g_sound.resetAmbienceSounds()
	g_sound.resetPlayingIDs()

	g_sound.region = nil

	g_sound.play(EVENT_AMBIANCE_FADE)
	g_sound.play(CONST_SE_MUSIC_FADE)
	g_sound.play(CONST_SE_MUSIC_FADE, g_sound.localEmitterId)
	g_sound.play(CONST_SE_PROFESSION_FADE)
	g_sound.play(CONST_SE_PROFESSION_FADE, g_sound.localEmitterId)
	g_sound.play(CONST_SE_CHANNEL_MAGIC_ITEM_FADE)
	g_sound.play(CONST_SE_CHANNEL_MAGIC_ITEM_FADE, g_sound.localEmitterId)
	g_sound.play(EVENT_MUSIC)
end

function g_sound.getDefaultPlaylistMusic()
	if g_game.isGuildWarsChannel() then
		return EVENT_MUSIC_GUILD_WARS
	end

	if g_game.isAetherRiftChannel() then
		return EVENT_MUSIC_AETHER_RIFT
	end

	return g_sound.getRegionalMusic(g_sound.getCurrentRegion())
end

function g_sound.stopPlaylistMusic()
	if g_sound.playlistMusic then
		g_wwise.stopEvent(g_sound.playlistMusic, 500)

		g_sound.playlistMusic = nil
	end
end

function g_sound.setPlaylistMusic(eventMusicId)
	if g_sound.playlistMusic then
		g_wwise.stopEvent(g_sound.playlistMusic, 4000)

		g_sound.playlistMusic = g_sound.play(eventMusicId)

		g_wwise.setRTPCValueByPlayingID(VOLUME_CONTROL, 0, g_sound.playlistMusic)
		scheduleEvent(function()
			g_wwise.setRTPCValueByPlayingID(VOLUME_CONTROL, 1, g_sound.playlistMusic, 4000)
		end, 4000)

		return
	end

	g_sound.playlistMusic = g_sound.play(eventMusicId)
end

function g_sound.resetPlaylistMusic()
	g_sound.setPlaylistMusic(g_sound.getDefaultPlaylistMusic())
end

function g_sound.onSoundEffect(isPositional, soundId, from, to, emitterId, volumeBoost)
	if g_wwise.isPaused() then
		return
	end

	if isPositional and to then
		g_sound.play(soundId, emitterId, to, nil, nil, volumeBoost)
	else
		g_sound.play(soundId, emitterId, from, nil, nil, volumeBoost)
	end
end

function g_sound.onEffect(effect)
	if g_wwise.isPaused() then
		return
	end

	local soundId = effect:getSoundId()
	local soundName = effect:getSoundName()

	if soundId == 0 and soundName == "" then
		return
	end

	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local position = player:getPosition()
	local effectPosition = effect:getPosition()

	if soundId > 0 then
		g_sound.play(soundId)
	elseif soundName ~= "" then
		g_sound.play(soundName)
	end
end

function g_sound.onMissile(missile)
	if g_wwise.isPaused() then
		return
	end

	local soundId = missile:getSoundId()
	local soundName = missile:getSoundName()
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	if soundId == 0 and soundName == "" then
		return
	end

	local position = player:getPosition()
	local source = missile:getSource()
	local destination = missile:getDestination()

	if soundId > 0 then
		g_sound.play(soundId)
	elseif soundName ~= "" then
		g_sound.play(soundName)
	end
end

function g_sound.isInRange(region, pos)
	if type(pos) ~= "table" then
		return false
	end

	return pos.x >= region.from.x and pos.y >= region.from.y and pos.z >= region.from.z and pos.x <= region.to.x and pos.y <= region.to.y and pos.z <= region.to.z
end

function g_sound.onRegionSound(creature)
	if not creature or not creature:isLocalPlayer() then
		return
	end

	local position = creature:getPosition()

	if not position then
		return
	end

	if g_sound.region and g_sound.isInRange(g_sound.region, position) then
		return
	end

	local region

	for name, tmpRegion in pairs(g_sound.regions) do
		if g_sound.isInRange(tmpRegion, position) then
			if tmpRegion.name == nil then
				tmpRegion.name = name
			end

			region = tmpRegion

			break
		end
	end

	if g_sound.region ~= region then
		if #g_sound.regionSounds > 0 then
			for _, soundId in ipairs(g_sound.regionSounds) do
				g_sound.action(soundId)
			end

			g_sound.regionSounds = {}
		end

		g_sound.region = region

		if g_sound.region then
			if g_sound.region.soundId then
				table.insert(g_sound.regionSounds, g_sound.region.soundId)
			elseif g_sound.region.sounds then
				for _, soundId in ipairs(g_sound.region.sounds) do
					table.insert(g_sound.regionSounds, soundId)
				end
			end

			if #g_sound.regionSounds > 0 then
				for _, soundId in ipairs(g_sound.regionSounds) do
					g_sound.play(soundId)
				end
			end
		end
	end
end

function g_sound.onPositionChange(creature, newPos, oldPos, tile)
	if g_wwise.isPaused() or not tile or not creature then
		return
	end

	g_sound.onRegionSound(creature)

	if creature:isHidden() or creature:isWalkingAnimationLocked() or creature:isJumping() then
		return
	end

	local soundId = tile:getSoundId()
	local soundName = tile:getSoundName()
	local soundCategory = tile:getSoundCategory()
	local switchId = tile:getSwitchId()
	local switchGroup = tile:getSwitchGroup()
	local stepSoundType = creature:getStepSoundType()

	if soundCategory ~= "" then
		local foot = g_sound.feetSounds[soundCategory]

		if foot then
			soundId = foot.soundId or 0
			soundName = foot.soundName or ""
			switchId = foot.switchId or 0
			switchGroup = foot.switchGroup or 0
		end
	end

	if g_sound.footStepTypeToSoundId[stepSoundType] then
		soundId = g_sound.footStepTypeToSoundId[stepSoundType]
	end

	if soundId == 0 and soundName == "" and switchId == 0 then
		return
	end

	local maxVolume = FOOTSTEP_MAX_VOLUME

	if creature ~= g_game.getLocalPlayer() then
		maxVolume = maxVolume / 2
	end

	local stepChange = FOOTSTEP_CHANGE_PER_TILE

	if not oldPos and not creature:isLocalPlayer() then
		return
	end

	if switchId > 0 then
		g_sound.play(switchId, creature:getId(), newPos, maxVolume, stepChange)
		g_sound.switch(switchGroup, switchId, creature:getId())
	end

	if soundId > 0 then
		g_sound.play(soundId, creature:getId(), newPos, maxVolume, stepChange)
	elseif soundName ~= "" then
		g_sound.play(soundName, creature:getId(), newPos, maxVolume, stepChange)
	end
end

function g_sound.removeGameObject(creature)
	g_wwise.removeGameObject(creature:getId())
end

function g_sound.onChanneling(creature, channelStatus)
	return
end

function g_sound.setVolume(channel, volume)
	if g_wwise then
		g_wwise.setRTPCValue(channel, volume, CONST_ALL_GAME_OBJECTS)
	end
end

function g_sound.reloadBanks()
	g_wwise.pauseSounds()
	g_wwise.removeSoundBanks()
	g_wwise.resumeSounds()
end

function g_sound.onShipChange(player, shipType)
	if shipType ~= ShipTypes.None then
		g_sound.play(EVENT_AMBIANCE_SHIP)
		g_sound.play(EVENT_AMBIANCE_WATER_OCEAN)
	else
		g_sound.action(EVENT_AMBIANCE_SHIP)
		g_sound.action(EVENT_AMBIANCE_WATER_OCEAN)
	end

	g_sound.resetPlaylistMusic()
end

function g_sound.onUI(actionType)
	g_sound.play(actionType)
end

function g_sound.onTimeChange(time)
	g_wwise.setRTPCValue(PARAM_DAY_NIGHT_CYCLE, time.hour, CONST_ALL_GAME_OBJECTS)
end

function g_sound.stopSoundEffect(pos, soundEffect, emitterId)
	local playingID = g_sound.getPlayingID(soundEffect, emitterId)

	if playingID then
		g_wwise.stopEvent(playingID.id, 500)
		g_sound.removePlayingID(soundEffect, emitterId)
	end
end

function g_sound.play(eventId, emitterId, pos, maxVolume, stepChange, volumeBoost, isAmbientSound)
	if not g_wwise or minimized or g_wwise.isPaused() or eventId == nil then
		return
	end

	local ref = {}

	local function depthToPosition(creature, newPos, oldPos)
		local emitterId = ref.emitterId
		local volume

		if not g_sound.getPlayingID(eventId, emitterId) or not pos or not oldPos then
			volume = 0
		else
			volume = volume or math.min(1, math.max(0.05, maxVolume + (1 - Position.distance(pos, oldPos)) * stepChange))

			if not Position.canSee(pos, oldPos) or pos.z ~= oldPos.z then
				volume = 0
			end
		end

		local playingID = ref.playingID or 0

		if playingID == 0 then
			return
		end

		g_wwise.setRTPCValueByPlayingID(VOLUME_CONTROL, volume + (volume ~= 0 and volumeBoost and volumeBoost / 100 or 0), playingID)
	end

	maxVolume = maxVolume or 1
	stepChange = stepChange or SOUND_CHANGE_PER_TILE

	local localPlayer = g_game.getLocalPlayer()
	local localPlayerPos = localPlayer and localPlayer:getPosition()
	local disconnects
	local connected = false

	if not g_sound.isLocalEmitter(emitterId) then
		if emitterId and emitterId > 0 then
			local creature = g_map.getCreatureById(emitterId)

			if not creature then
				if localPlayer:getId() ~= emitterId then
					connected = true
					disconnects = connect(LocalPlayer, {
						onPositionChange = depthToPosition
					})
				end

				if not isAmbientSound and disconnects then
					scheduleEvent(function()
						for _, callback in pairs(disconnects) do
							callback()
						end
					end, 15000)
				end
			end

			if not g_wwise.gameObjectExists(emitterId) then
				g_wwise.addGameObject(emitterId, tostring(emitterId))
			end
		else
			emitterId = g_sound.listenerId
		end
	end

	if not connected and not g_sound.isLocalEmitter(emitterId) and pos and localPlayer and localPlayer:getId() ~= emitterId then
		local disconnects = connect(LocalPlayer, {
			onPositionChange = depthToPosition
		})

		if disconnects then
			scheduleEvent(function()
				for _, callback in pairs(disconnects) do
					callback()
				end
			end, 15000)
		end

		connected = true
	end

	local playingID = 0

	g_sound.tryLoadSoundbank(eventId)

	if type(eventId) == "number" then
		playingID = g_wwise.postEvent(eventId, emitterId)
	elseif type(eventId) == "string" then
		playingID = g_wwise.postEventEx(eventId, emitterId)
	end

	g_sound.addPlayingID(eventId, emitterId, playingID, disconnects)

	ref.playingID = playingID
	ref.emitterId = emitterId

	if connected then
		depthToPosition(localPlayer, localPlayerPos, localPlayerPos)
	else
		g_wwise.setRTPCValueByPlayingID(VOLUME_CONTROL, 1, playingID)
	end

	return playingID
end

function g_sound.action(eventId, actionType, transitionDuration, emitterId)
	if not g_wwise or eventId == nil then
		return
	end

	if type(eventId) == "number" then
		g_wwise.executeActionOnEvent(eventId, actionType or 0, emitterId or g_sound.listenerId, transitionDuration or 1000)
	elseif type(eventId) == "string" then
		g_wwise.executeActionOnEventEx(eventId, actionType or 0, emitterId or g_sound.listenerId, transitionDuration or 1000)
	end
end

function g_sound.switch(groupId, stateId, emitterId)
	g_wwise.setSwitch(groupId, stateId, emitterId or g_sound.listenerId)
end

function g_sound.onWidgetHover(widget, hovered)
	if not widget.nosound and hovered and widget.hoverSound then
		if lastHoverEvent + 5 > g_clock.millis() then
			return
		end

		lastHoverEvent = g_clock.millis()

		g_sound.play(UI_HOVER)
	end
end

function g_sound.onWidgetClick(widget)
	if not widget.nosound and widget.clickSound then
		if lastClickEvent + 5 > g_clock.millis() then
			return
		end

		lastClickEvent = g_clock.millis()

		local soundId = widget.uiclicksoundid or UI_CLICK

		g_sound.play(soundId)
	end
end

function g_sound.onWidgetVisibilityChange(widget, visible)
	if not widget.nosound and widget.isGeneralUIWindow then
		if lastVisibilityChangeEvent + 5 > g_clock.millis() then
			return
		end

		lastVisibilityChangeEvent = g_clock.millis()

		if visible then
			local soundId = widget.uiopensoundid or UI_GENERAL_WINDOW_OPEN

			g_sound.play(soundId)
		else
			local soundId = widget.uiclosesoundid or UI_GENERAL_WINDOW_CLOSE

			g_sound.play(soundId)
		end
	end
end

function g_sound.onFrameSound(creature, sound, x, y, z)
	if creature then
		g_sound.play(sound, creature:getId(), creature:getPosition())
	else
		local pos = {
			x = x,
			y = y,
			z = z
		}

		g_sound.play(sound, tonumber(string.format("%i%i%i", x, y, z)), pos)

		if table.find({
			CONST_SE_WOODCUTTING,
			CONST_SE_MINING
		}, sound) then
			modules.game_icons.g_icons.onGatheringScreenshake(pos)
		end

		if sound == CONST_SE_WOODCUTTING then
			modules.game_icons.g_icons.onWoodcuttingEffect(pos)
		end
	end
end

function g_sound.onAddAmbienceSound(tile, thing)
	local soundId = thing:getSoundId()
	local position = tile:getPosition()
	local hash = Position.generateHash(position)

	if g_sound.ambienceSounds[hash] and g_sound.ambienceSounds[hash][soundId] then
		return
	end

	if g_sound.play(soundId, hash, position, nil, nil, nil, true) then
		if not g_sound.ambienceSounds[hash] then
			g_sound.ambienceSounds[hash] = {}
		end

		g_sound.ambienceSounds[hash][soundId] = true
	end
end

function g_sound.onRemoveAmbienceSound(tile, thing)
	local soundId = thing:getSoundId()
	local position = tile:getPosition()
	local hash = Position.generateHash(position)

	g_sound.stopSoundEffect(position, soundId, hash)

	if g_sound.ambienceSounds[hash] and g_sound.ambienceSounds[hash][soundId] then
		g_sound.ambienceSounds[hash][soundId] = nil
	end
end

function g_sound.onPositionSound(creature)
	if not creature or not creature:isLocalPlayer() then
		return
	end
end

function g_sound.onAddPositionSound(tile)
	local position = tile:getPosition()
	local hash = Position.generateHash(position)
	local soundId = g_sound.positionIndexed[hash]

	if not soundId then
		return
	end

	g_sound.play(soundId, hash, position, nil, nil, nil, true)
end

function g_sound.onRemovePositionSound(tile)
	return
end

function g_sound.tryLoadSoundbank(eventId)
	if not g_wwise then
		return
	end

	local soundbank = cfg.SoundEvents[eventId]

	if not soundbank then
		return
	end

	if not g_sound.loadedSoundbanks[soundbank] then
		g_wwise.addSoundBank(soundbank)
	end

	g_sound.loadedSoundbanks[soundbank] = os.time()
end

function g_sound.tryUnloadSoundbanks()
	for soundbank, loadedTime in pairs(g_sound.loadedSoundbanks) do
		if os.time() - loadedTime > 60 and not soundbank:find("_ost", 1, true) and soundbank ~= "trailer.bnk" and soundbank ~= "main.bnk" and not soundbank:find("music", 1, true) and not soundbank:find("ambience", 1, true) then
			g_wwise.removeSoundBank(soundbank)

			g_sound.loadedSoundbanks[soundbank] = nil
		end
	end
end

function g_sound.addPlayingID(soundEffect, emitterId, playingID, disconnectCallbacks)
	if not g_sound.playingIDs[soundEffect] then
		g_sound.playingIDs[soundEffect] = {}
	end

	g_sound.playingIDs[soundEffect][emitterId] = {
		id = playingID,
		disconnectCallbacks = disconnectCallbacks
	}
end

function g_sound.removePlayingID(soundEffect, emitterId)
	local playingID = g_sound.playingIDs[soundEffect][emitterId]

	if not playingID then
		return
	end

	if playingID.disconnectCallbacks then
		for _, callback in pairs(playingID.disconnectCallbacks) do
			callback()
		end
	end

	g_sound.playingIDs[soundEffect][emitterId] = nil
end

function g_sound.getPlayingID(soundEffect, emitterId)
	if not g_sound.playingIDs[soundEffect] then
		return
	end

	return g_sound.playingIDs[soundEffect][emitterId]
end

function g_sound.resetPlayingIDs()
	for soundEffect, emitterIds in pairs(g_sound.playingIDs) do
		for emitterId, playingID in pairs(emitterIds) do
			g_sound.stopSoundEffect(nil, soundEffect, emitterId)
		end
	end
end

function g_sound.resetAmbienceSounds()
	for hash, soundEffects in pairs(g_sound.ambienceSounds) do
		for soundEffect in pairs(soundEffects) do
			g_sound.stopSoundEffect(nil, soundEffect, hash)
		end
	end

	g_sound.ambienceSounds = {}
end

function g_sound.onDeath()
	g_sound:offline()
	g_sound:online()
end

function g_sound.onRegionChange(data)
	if data.name then
		local currentEventId = g_sound.getRegionalMusic(g_sound.getCurrentRegion())

		g_sound.currentRegion = data.name

		local newEventId = g_sound.getRegionalMusic(g_sound.getCurrentRegion())

		if newEventId ~= currentEventId then
			g_sound.setPlaylistMusic(newEventId)
		end
	end
end

function g_sound.getCurrentRegion()
	if g_game.isInShip() then
		return "Ocean"
	end

	return g_sound.currentRegion
end

function g_sound.getRegionalMusic(region)
	return cfg.RegionalMusic[region]
end
