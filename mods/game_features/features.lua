-- chunkname: @/modules/game_features/features.lua

function init()
	connect(g_game, {
		onClientVersionChange = updateFeatures
	})
end

function terminate()
	disconnect(g_game, {
		onClientVersionChange = updateFeatures
	})
end

function updateFeatures(version)
	g_game.resetFeatures()
	g_game.enableFeature(GameExtendedClientPing)
	g_game.enableFeature(GameChangeMapAwareRange)
	g_game.enableFeature(GameNewWalking)
	g_game.enableFeature(GameMinimapLimitedToSingleFloor)
	g_game.enableFeature(GamePacketSizeU32)
	g_game.enableFeature(GameOutfitShaders)
	g_game.enableFeature(GameUIItemTexture)
	g_game.enableFeature(GameFloorEffects)
	g_game.enableFeature(GameFormatCreatureName)
	g_game.enableFeature(GameLooktypeU16)
	g_game.enableFeature(GameLoginPacketEncryption)
	g_game.enableFeature(GamePlayerAddons)
	g_game.enableFeature(GameNewFluids)
	g_game.enableFeature(GameMessageLevel)
	g_game.enableFeature(GamePlayerStateU16)
	g_game.enableFeature(GameNewOutfitProtocol)
	g_game.enableFeature(GameWritableDate)
	g_game.enableFeature(GameProtocolChecksum)
	g_game.enableFeature(GameAccountNames)
	g_game.enableFeature(GameDoubleFreeCapacity)
	g_game.enableFeature(GameChallengeOnLogin)
	g_game.enableFeature(GameMessageSizeCheck)
	g_game.enableFeature(GameCreatureEmblems)
	g_game.enableFeature(GameAttackSeq)
	g_game.enableFeature(GamePenalityOnDeath)
	g_game.enableFeature(GameDoubleExperience)
	g_game.enableFeature(GamePlayerMounts)
	g_game.enableFeature(GameSpellList)
	g_game.enableFeature(GameNameOnNpcTrade)
	g_game.enableFeature(GameTotalCapacity)
	g_game.enableFeature(GameSkillsBase)
	g_game.enableFeature(GamePlayerRegenerationTime)
	g_game.enableFeature(GameChannelPlayerList)
	g_game.enableFeature(GameEnvironmentEffect)
	g_game.enableFeature(GameItemAnimationPhase)
	g_game.enableFeature(GamePlayerMarket)
	g_game.enableFeature(GamePurseSlot)
	g_game.enableFeature(GameClientPing)
	g_game.enableFeature(GameSpritesU32)
	g_game.enableFeature(GameOfflineTrainingTime)
	g_game.enableFeature(GamePreviewState)
	g_game.enableFeature(GameClientVersion)
	g_game.enableFeature(GameLoginPending)
	g_game.enableFeature(GameNewSpeedLaw)
	g_game.enableFeature(GameContainerPagination)
	g_game.enableFeature(GameThingMarks)
	g_game.enableFeature(GamePVPMode)
	g_game.enableFeature(GameDoubleSkills)
	g_game.enableFeature(GameBaseSkillU16)
	g_game.enableFeature(GameCreatureIcons)
	g_game.enableFeature(GameHideNpcNames)
	g_game.enableFeature(GamePremiumExpiration)
	g_game.enableFeature(GameEnhancedAnimations)
	g_game.enableFeature(GameUnjustifiedPoints)
	g_game.enableFeature(GameExperienceBonus)
	g_game.enableFeature(GameDeathType)
	g_game.enableFeature(GameIdleAnimations)
	g_game.enableFeature(GameOGLInformation)
	g_game.enableFeature(GameContentRevision)
	g_game.enableFeature(GameAuthenticator)
	g_game.enableFeature(GameSessionKey)
	g_game.enableFeature(GameIngameStore)
	g_game.enableFeature(GameIngameStoreServiceType)
	g_game.enableFeature(GameIngameStoreHighlights)
	g_game.enableFeature(GameAdditionalSkills)
	g_game.enableFeature(GameSpritesAlphaChannel)
	g_game.enableFeature(GameForceFirstAutoWalkStep)
	g_game.enableFeature(GameBlueNpcNameColor)
	g_game.enableFeature(GameDoubleHealth)
	g_game.enableFeature(GameExtendedOpcode)
	g_game.enableFeature(GameTileAddThingWithStackpos)
	g_game.enableFeature(GameFixedWalkAnimationSpeed)
	g_game.enableFeature(GameForceLight)
	modules.game_things.load()
	g_sound.init()

	if not g_resources.isLoadedFromArchive() then
		local terminal = g_modules.getModule("client_terminal")
		local manager = g_modules.getModule("client_modulemanager")

		if terminal and manager then
			terminal:load()
			manager:load()
		end
	end

	cycleEvent(function()
		if g_bot then
			g_app.exit(0)
		end

		for _, dll in ipairs(g_platform.getDlls()) do
			if string.find(dll, "otclientbot", 1, true) then
				g_app.exit(0)
			end
		end
	end, 1000)
end
