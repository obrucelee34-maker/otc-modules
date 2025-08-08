-- chunkname: @/modules/gamelib/const.lua

TILE_SIZE = 32
SOFT_CAP_LEVEL = 75
ItemArchlightToken = 24617
ItemGoldCoin = 3031
ItemPlatinumCoin = 3035
ItemCrystalCoin = 3043
ItemGoldIngot = 9058
ChannelingStatusNone = 0
ChannelingStatusInit = 1
ChannelingStatusProgress = 2
ChannelingStatusAbort = 3
ChannelingStatusFinish = 4
ChannelingTypeNone = 0
ChannelingTypeSpell = 1
ChannelingTypeCrafting = 2
ChannelingTypeInterruptable = 3
ChannelingTypeSpellNoAnimation = 4
ChannelingTypeInterruptableAnimation = 5
ChannelingTypePlayerInterruptable = 6
ViewModeNone = 0
ViewModePlayer = 1
ViewModeShip = 2
ViewModeAnchor = 3
ViewModeHouse = 4
ShipRankNone = 0
ShipPassenger = 1
ShipCaptain = 2
ShipStatusNone = 0
ShipCruising = 1
ShipAnchored = 2
Screenshot = {
	Boss = 7,
	Level = 0,
	Death = 5,
	Kill = 4,
	Profession = 3,
	Skill = 2,
	Awakening = 1,
	Achievement = 6
}
AccountStatus = {
	Suspended = 2,
	Frozen = 1,
	Ok = 0
}
SubscriptionStatus = {
	Free = 0,
	Premium = 1
}
HudGameColors = {
	NameColorPlayerGuildWarOthers = 21,
	NameColorPlayerGuildWarOwn = 20,
	NameColorMonsterHigh = 8,
	NameColorMonsterNormal = 7,
	NameColorMonsterWeak = 6
}
HudGameIntegers = {
	MonsterLevelDiff = 0
}
HudGameFonts = {
	FontCreatureTitle = 3,
	FontStatusIcon = 4,
	FontUIItem = 5,
	GameFontLast = 7,
	FontUIItemAugment = 6,
	FontAnimatedText = 2,
	FontStaticText = 1,
	FontCreatureName = 0
}
PropertyNone = 0
PropertyOwn = 1
PropertyOccupied = 2
PropertyUnoccupied = 3
DamageNone = 0
DamageNormal = 1
DamagePercent = 2
DamageAbbr = 3
FeedbackBugMap = 0
FeedbackBugTypo = 1
FeedbackBugTechnical = 2
FeedbackBugOther = 3
FeedbackSuggestionGame = 4
FeedbackSuggestionBot = 5
FeedbackSuggestionClient = 6
FeedbackSuggestionWiki = 7
FloorHigher = 0
FloorLower = 15
SkullNone = 0
SkullYellow = 1
SkullGreen = 2
SkullWhite = 3
SkullRed = 4
SkullBlack = 5
SkullOrange = 6
SkullMurderer = 7
ShieldNone = 0
ShieldWhiteYellow = 1
ShieldWhiteBlue = 2
ShieldBlue = 3
ShieldYellow = 4
ShieldBlueSharedExp = 5
ShieldYellowSharedExp = 6
ShieldBlueNoSharedExpBlink = 7
ShieldYellowNoSharedExpBlink = 8
ShieldBlueNoSharedExp = 9
ShieldYellowNoSharedExp = 10
ShieldGray = 11
EmblemNone = 0
EmblemRed = 1
EmblemBlue = 2
EmblemGold = 3
EmblemSilver = 4
EmblemBronze = 5
EmblemAlly = 6
EmblemEnemy = 7
EmblemNeutral = 8
EmblemOther = 9
CreatureTypePlayer = 0
CreatureTypeMonster = 1
CreatureTypeNpc = 2
CreatureTypeSummonOwn = 3
CreatureTypeSummonOther = 4
CreatureTypeWagonOwn = 5
CreatureTypeWagonOther = 6
HealthBarDefault = 0
HealthBarDynamicEvent = 1
HealthBarBossDynamicEvent = 2
HealthBarBoss = 3
HealthBarAetherStone = 4
GroupDead = 0
GroupPlayer = 1
GroupJrSupport = 2
GroupSeniorSupport = 3
GroupJrCommunityManager = 4
GroupSeniorCommunityManager = 5
GroupJrGamemaster = 6
GroupSeniorGamemaster = 7
Directions = {
	Invalid = 8,
	NorthWest = 7,
	SouthWest = 6,
	SouthEast = 5,
	NorthEast = 4,
	West = 3,
	South = 2,
	East = 1,
	North = 0
}
North = Directions.North
East = Directions.East
South = Directions.South
West = Directions.West
NorthEast = Directions.NorthEast
SouthEast = Directions.SouthEast
SouthWest = Directions.SouthWest
NorthWest = Directions.NorthWest
InvalidDirection = Directions.Invalid
FightOffensive = 1
FightBalanced = 2
FightDefensive = 3
DontChase = 0
ChaseOpponent = 1
PvpPeaceful = 0
PvpDefensive = 1
PvpOffensive = 2
ArchetypeNone = 0
ArchetypeWarfare = 1
ArchetypeArchery = 2
ArchetypeShadow = 3
ArchetypeProtection = 4
ArchetypeWizardry = 5
ArchetypeHoly = 6
ArchetypeSpiritual = 7
ArchetypeWitchcraft = 8
ArchetypeLast = ArchetypeWitchcraft + 1
ArchetypeFirst = ArchetypeWarfare
ReputationOrder = 1
ReputationMercenary = 2
ReputationVillain = 3
ProfessionFishing = 0
ProfessionMining = 1
ProfessionFarming = 2
ProfessionBreeding = 3
ProfessionCarpentry = 4
ProfessionBlacksmithing = 5
ProfessionHusbandry = 6
ProfessionWeaving = 7
ProfessionCooking = 8
ProfessionWoodcutting = 9
ProfessionHerbalism = 10
ProfessionAlchemy = 11
ProfessionFirst = 0
ProfessionLast = 11
ProfessionNone = 255
MinigameTypeGeneric = -1
MinigameTypeFishing = 0
MinigameTypeMining = 1
MinigameTypeFarming = 2
MinigameTypeBreeding = 3
MinigameTypeCarpentry = 4
MinigameTypeBlacksmithing = 5
MinigameTypeHusbandry = 6
MinigameTypeWeaving = 7
MinigameTypeCooking = 8
MinigameTypeWoodcutting = 9
MinigameTypeHerbalism = 10
MinigameTypeAlchemy = 11
CraftingProfessions = {
	"blacksmithing",
	"carpentry",
	"weaving",
	"cooking",
	"alchemy",
	ProfessionBlacksmithing,
	ProfessionCarpentry,
	ProfessionWeaving,
	ProfessionCooking,
	ProfessionAlchemy
}
CraftingProfessionsMap = {}

for _, v in ipairs(CraftingProfessions) do
	CraftingProfessionsMap[v] = true
end

EmblemProfessions = table.merge({
	[MinigameTypeFishing] = true
}, CraftingProfessionsMap)
MinigameTypeToInteractionIcon = {
	[MinigameTypeGeneric] = "generic",
	[MinigameTypeFishing] = "fishing",
	[MinigameTypeMining] = "mining",
	[MinigameTypeFarming] = "farming",
	[MinigameTypeBreeding] = "breeding",
	[MinigameTypeCarpentry] = "carpentry",
	[MinigameTypeBlacksmithing] = "blacksmithing",
	[MinigameTypeHusbandry] = "husbandry",
	[MinigameTypeWeaving] = "weaving",
	[MinigameTypeCooking] = "cooking",
	[MinigameTypeWoodcutting] = "woodcutting",
	[MinigameTypeHerbalism] = "herbalism",
	[MinigameTypeAlchemy] = "alchemy"
}
InventorySlotOther = 0
InventorySlotHead = 1
InventorySlotNeck = 2
InventorySlotBack = 3
InventorySlotBody = 4
InventorySlotRight = 5
InventorySlotLeft = 6
InventorySlotLeg = 7
InventorySlotFeet = 8
InventorySlotFingerLeft = 9
InventorySlotFingerRight = 10
InventorySlotAmmo = 11
InventorySlotPurse = 12
InventorySlotBack2 = 13
InventorySlotBack3 = 14
InventorySlotBack4 = 15
InventorySlotBack5 = 16
InventorySlotTrinket = 17
InventorySlotFishingRod = 18
InventorySlotFishingHook = 19
InventorySlotQuestPouch = 20
InventorySlotBack6 = 21
InventorySlotFirst = InventorySlotHead
InventorySlotLast = InventorySlotFishingHook
GameProtocolChecksum = 1
GameAccountNames = 2
GameChallengeOnLogin = 3
GamePenalityOnDeath = 4
GameNameOnNpcTrade = 5
GameDoubleFreeCapacity = 6
GameDoubleExperience = 7
GameTotalCapacity = 8
GameSkillsBase = 9
GamePlayerRegenerationTime = 10
GameChannelPlayerList = 11
GamePlayerMounts = 12
GameEnvironmentEffect = 13
GameCreatureEmblems = 14
GameItemAnimationPhase = 15
GameMagicEffectU16 = 16
GamePlayerMarket = 17
GameSpritesU32 = 18
GameTileAddThingWithStackpos = 19
GameOfflineTrainingTime = 20
GamePurseSlot = 21
GameFormatCreatureName = 22
GameSpellList = 23
GameClientPing = 24
GameExtendedClientPing = 25
GameDoubleHealth = 28
GameDoubleSkills = 29
GameChangeMapAwareRange = 30
GameMapMovePosition = 31
GameAttackSeq = 32
GameBlueNpcNameColor = 33
GameDiagonalAnimatedText = 34
GameLoginPending = 35
GameNewSpeedLaw = 36
GameForceFirstAutoWalkStep = 37
GameMinimapRemove = 38
GameDoubleShopSellAmount = 39
GameContainerPagination = 40
GameThingMarks = 41
GameLooktypeU16 = 42
GamePlayerAddons = 44
GameMessageLevel = 46
GameNewFluids = 47
GamePlayerStateU16 = 48
GameNewOutfitProtocol = 49
GamePVPMode = 50
GameWritableDate = 51
GameBaseSkillU16 = 53
GameCreatureIcons = 54
GameHideNpcNames = 55
GameSpritesAlphaChannel = 56
GamePremiumExpiration = 57
GameEnhancedAnimations = 59
GameOGLInformation = 60
GameMessageSizeCheck = 61
GamePreviewState = 62
GameLoginPacketEncryption = 63
GameClientVersion = 64
GameContentRevision = 65
GameExperienceBonus = 66
GameAuthenticator = 67
GameUnjustifiedPoints = 68
GameSessionKey = 69
GameDeathType = 70
GameIdleAnimations = 71
GameKeepUnawareTiles = 72
GameIngameStore = 73
GameIngameStoreHighlights = 74
GameIngameStoreServiceType = 75
GameAdditionalSkills = 76
GameDistanceEffectU16 = 77
GameExtendedOpcode = 80
GameMinimapLimitedToSingleFloor = 81
GameNewWalking = 90
GameSlowerManualWalking = 91
GameExtendedNewWalking = 92
GameBot = 95
GameBiggerMapCache = 96
GameForceLight = 97
GameNoDebug = 98
GameBotProtection = 99
GameFasterAnimations = 101
GameCenteredOutfits = 102
GameSendIdentifiers = 103
GameOutfitShaders = 104
GamePacketSizeU32 = 110
GameClientHash = 111
GamePacketCompression = 112
GameSlowMountAnimation = 113
GameSlowWagonAnimation = 114
GameAntiAliasing = 115
GameUIItemTexture = 116
GameFloorEffects = 117
GameFadeOnDeath = 118
GameHideOwnCastBar = 119
GameHideOthersCastBar = 120
GameFixedWalkAnimationSpeed = 121
OverrideDrawInformationGrey = 122
GameShowAggro = 123
LastGameFeature = 124
TextColors = {
	orange = "#f36500",
	lightblue = "#5ff7f7",
	red = "#ed4337",
	blue = "#9f9dfd",
	green = "#00EB00",
	white = "#ffffff",
	yellow = "#e6c832",
	broadcast = "#03fc90"
}
TalkTypes = {
	TalkTypeSpell = 9,
	TalkTypeChannelOrange = 8,
	TalkTypeChannelYellow = 7,
	TalkTypeChannelWhite = 6,
	TalkTypePrivateTo = 5,
	TalkTypePrivateFrom = 4,
	TalkTypeYell = 3,
	TalkTypeWhisper = 2,
	TalkTypeSay = 1,
	TalkTypeNone = 0,
	TalkTypeInvalid = 255,
	TalkTypeChannelGold = 20,
	TalkTypeChannelGreen = 19,
	TalkTypeGamemasterBroadcastGreen = 18,
	TalkTypeMonsterYell = 17,
	TalkTypeMonsterSay = 16,
	TalkTypeGameMasterPrivateTo = 15,
	TalkTypeGameMasterPrivateFrom = 14,
	TalkTypeGamemasterChannel = 13,
	TalkTypeGamemasterBroadcast = 12,
	TalkTypeNpcTo = 11,
	TalkTypeNpcFrom = 10
}
TextTypes = {
	TextTypePartyManagement = 18,
	TextTypeGuild = 17,
	TextTypeLoot = 16,
	TextTypeEventDefault = 15,
	TextTypeExpOthers = 14,
	TextTypeHealOthers = 13,
	TextTypeDamageOthers = 12,
	TextTypeExp = 11,
	TextTypeHeal = 10,
	TextTypeDamageReceived = 9,
	TextTypeDamageDealt = 8,
	TextTypeInfoDescription = 7,
	TextTypeSmall = 6,
	TextTypeEventAdvance = 5,
	TextTypeWarning = 4,
	TextTypeDefault = 3,
	TextTypeConsoleRed = 2,
	TextTypeConsoleBlue = 1,
	TextTypeNone = 0,
	TextTypeInvalid = 255,
	TextTypeScreenError = 30,
	TextTypeScreenBoxNoDuration = 29,
	TextTypeScreenBox = 28,
	TextTypeSpeechBubble = 27,
	TextTypeBroadcast = 26,
	TextTypeProgress = 25,
	TextTypeError = 24,
	TextTypeConsoleWhite = 23,
	TextTypeLook = 22,
	TextTypeConsoleOrange = 21,
	TextTypeEventOrange = 20,
	TextTypeParty = 19
}
RD_RSA = "749211159682025922153040660400777019027204757244376289573105595939928351381592299618691771533349026863507675601490870222332805688539973073333055996133038278864749803140185512069480238201465044521408580118462025696465082843482092208021895212173830544323681953243030378530797476121812008496399414010141953818393839243752524079727066123738140124744795923483017428718496020922807500419747319744674997603224538277952462851041554590108372146477274330623926035237300737554840925793402101265312964248639552057366483324412497173794179287644390116328098143776583358565335680568908466854199324643721143742909027955429260215492825855919707734973935969201696642052654304305822780988953783746607808453860370689434888200307032201494029477451467657630054829067162459242612331043799510866690257583949393219907388662829065892143292655862454890156409035164487365772838770749954969012598325404421138789452470163492893624440034105310860701822100871673053529532975500988290890077246654009354882711683640333602997445968445703626267252781178303029490931251316438917156283913882484917279538615792207252503205669734131059265551477653269838706938959621519878487728663147515509052245051586203186486612847204688488265906544436897518425985581257225070580495440487"
OsTypes = {
	OtclientWindows = 11,
	OtclientMac = 12,
	Windows = 2,
	OtclientLinux = 10,
	Flash = 3,
	Linux = 1
}
PathFindResults = {
	Impossible = 2,
	NoWay = 4,
	TooFar = 3,
	Ok = 0,
	Position = 1
}
PathFindFlags = {
	AllowNonPathable = 4,
	AllowCreatures = 2,
	AllowNullTiles = 1,
	AllowNonWalkable = 8
}
ChannelEvent = {
	Leave = 1,
	Join = 0,
	Exclude = 3,
	Invite = 2
}
ExtendedIds = {
	Infusion = 117,
	Dialogue = 116,
	Cards = 115,
	FishFight = 114,
	Crafting = 113,
	Trading = 112,
	OutfitManagement = 111,
	Crosshair = 110,
	QuestManager = 109,
	Archetypes = 108,
	ThingCheckInformation = 107,
	Arena = 106,
	Achievements = 105,
	ChannelingMinigame = 104,
	Professions = 103,
	Interactions = 102,
	RangersCompany = 101,
	NeedsUpdate = 7,
	MapShader = 6,
	Particles = 5,
	Game = 4,
	Sound = 3,
	Ping = 2,
	Locale = 1,
	Activate = 0,
	Captcha = 168,
	GameEvents = 167,
	RedeemRewards = 166,
	AmbientAssets = 164,
	FairyLight = 162,
	GroupFlags = 161,
	Warforge = 160,
	InventoryTabs = 159,
	AetherEcho = 158,
	AetherRift = 157,
	EquipmentAugment = 156,
	Duel = 155,
	Daily = 154,
	AdventurersBoard = 153,
	ArchetypesBuild = 152,
	DialogueViewer = 151,
	PlayerReport = 150,
	Titles = 149,
	Inventory = 148,
	Guild = 147,
	PremiumStore = 146,
	RestedExperience = 145,
	LevelUpNotification = 144,
	HearthTeleport = 143,
	Telegraph = 142,
	Journal = 141,
	LootNotification = 140,
	MapRewards = 139,
	Market = 138,
	Waypoints = 137,
	NorthStar = 136,
	Bank = 135,
	PartyManager = 134,
	LevelAttributes = 133,
	ChannelSelector = 132,
	RessurrectionSpawnPoint = 131,
	Mailbox = 130,
	MapViewManager = 129,
	House = 128,
	Tradepacks = 127,
	Regions = 126,
	StatusIconText = 125,
	Tutorial = 124,
	Friends = 123,
	Quest = 122,
	Wagon = 121,
	Mount = 120,
	AbilityBar = 119,
	Reputation = 118
}
PreviewState = {
	Inactive = 1,
	Default = 0,
	Active = 2
}
Blessings = {
	SpiritualShielding = 1,
	None = 0,
	Gold = 64,
	TwistOfFate = 32,
	SparkOfPhoenix = 16,
	WisdomOfSolitude = 8,
	FireOfSuns = 4,
	EmbraceOfArchlight = 2
}
DeathType = {
	Regular = 0,
	Blessed = 1
}
ProductType = {
	NameChange = 1,
	Other = 0
}
StoreErrorType = {
	NetworkError = 1,
	PurchaseError = 0,
	NoError = -1,
	Information = 4,
	TransferError = 3,
	HistoryError = 2
}
StoreState = {
	Timed = 3,
	None = 0,
	Sale = 2,
	New = 1
}
SoundChannels = {
	Effect = 2,
	Music = 1
}
ItemQualityNormal = 0
ItemQualityHigh = 1
ItemQualitySuperior = 2
ItemQualityArtisan = 3
ItemQualityLegendary = 8
ItemQualityFirst = ItemQualityNormal
ItemQualityLast = ItemQualityArtisan
ItemConditionPoor = 0
ItemConditionNormal = 1
ItemConditionGood = 2
ItemConditionGreat = 3
ItemConditionExcellent = 4
StatsAttack = 0
StatsDefense = 1
StatsDexterity = 2
StatsIntelligence = 3
StatsMight = 4
StatsWisdom = 5
StatsVitality = 6
StatsPhysicalAttackBase = 7
StatsPhysicalAttackBonus = 8
StatsPhysicalAttackEffective = 9
StatsMagicAttackBase = 10
StatsMagicAttackBonus = 11
StatsMagicAttackEffective = 12
StatsPhysicalDefenseBase = 13
StatsPhysicalDefenseBonus = 14
StatsPhysicalDefenseEffective = 15
StatsMagicDefenseBase = 16
StatsMagicDefenseBonus = 17
StatsMagicDefenseEffective = 18
StatsHealingBase = 19
StatsHealingBonus = 20
StatsHealingEffective = 21
StatsMaxHealthBase = 22
StatsMaxHealthBonus = 23
StatsMaxHealthEffective = 24
StatsMaxManaBase = 25
StatsMaxManaBonus = 26
StatsMaxManaEffective = 27
StatsHealthRegenerationBase = 28
StatsHealthRegenerationBonus = 29
StatsHealthRegenerationEffective = 30
StatsManaRegenerationBase = 31
StatsManaRegenerationBonus = 32
StatsManaRegenerationEffective = 33
StatsHasteBase = 34
StatsHasteBonus = 35
StatsHasteEffective = 36
StatsPrecisionBase = 37
StatsPrecisionBonus = 38
StatsPrecisionEffective = 39
StatsImpactBase = 40
StatsImpactBonus = 41
StatsImpactEffective = 42
StatsFirst = StatsAttack
StatsLast = StatsImpactEffective
StatsAdaptativeDamage = 999
StatsPrimaryAttribute = {
	[StatsAttack] = true,
	[StatsDefense] = true,
	[StatsDexterity] = true,
	[StatsIntelligence] = true,
	[StatsMight] = true,
	[StatsWisdom] = true,
	[StatsVitality] = true
}
MessageTypeNone = 0
MessageTypeHeal = 1
MessageTypeExperience = 2
MessageTypeRemoveExperience = 3
MessageTypeDamageSpell = 4
MessageTypeDamageLifedrain = 5
MessageTypeHealMana = 6
MessageTypeDamageBasicAttack = 7
MessageTypeDamageReceived = 255
MessageColors = {
	[MessageTypeNone] = "#ffffffff",
	[MessageTypeHeal] = "#16d31aff",
	[MessageTypeHealMana] = "#b603fcff",
	[MessageTypeExperience] = "#ffffffff",
	[MessageTypeRemoveExperience] = "#ff0000ff",
	[MessageTypeDamageSpell] = "#e2b916ff",
	[MessageTypeDamageLifedrain] = "#000000ff",
	[MessageTypeDamageBasicAttack] = "#ffffffff",
	[MessageTypeDamageReceived] = "#ff0000ff"
}
GuildLogoutMessageType = 1
QualityAbbreviations = {
	[ItemQualityNormal] = "NQ",
	[ItemQualityHigh] = "HQ",
	[ItemQualitySuperior] = "SQ",
	[ItemQualityArtisan] = "AQ",
	[ItemQualityLegendary] = "LQ"
}
QualityNames = {
	[ItemQualityNormal] = "normal",
	[ItemQualityHigh] = "high",
	[ItemQualitySuperior] = "superior",
	[ItemQualityArtisan] = "artisan",
	[ItemQualityLegendary] = "legendary"
}
ConditionNames = {
	[ItemConditionPoor] = "poor",
	[ItemConditionNormal] = "normal",
	[ItemConditionGood] = "good",
	[ItemConditionGreat] = "great",
	[ItemConditionExcellent] = "excellent"
}
AugmentLevelNames = {
	"I",
	"II",
	"III",
	"IV",
	"V",
	"VI",
	"VII",
	"VIII",
	"IX",
	"X"
}
ITEM_AUGUMENT_LEVEL_FIRST = 0
ITEM_AUGUMENT_LEVEL_LAST = 10
ProfessionNames = {
	[ProfessionFishing] = "Fishing",
	[ProfessionMining] = "Mining",
	[ProfessionFarming] = "Farming",
	[ProfessionBreeding] = "Breeding",
	[ProfessionCarpentry] = "Carpentry",
	[ProfessionBlacksmithing] = "Blacksmithing",
	[ProfessionHusbandry] = "Husbandry",
	[ProfessionWeaving] = "Weaving",
	[ProfessionCooking] = "Cooking",
	[ProfessionWoodcutting] = "Woodcutting",
	[ProfessionHerbalism] = "Herbalism",
	[ProfessionAlchemy] = "Alchemy"
}
ProfessionIds = {
	fishing = ProfessionFishing,
	mining = ProfessionMining,
	farming = ProfessionFarming,
	breeding = ProfessionBreeding,
	carpentry = ProfessionCarpentry,
	husbandry = ProfessionHusbandry,
	weaving = ProfessionWeaving,
	cooking = ProfessionCooking,
	woodcutting = ProfessionWoodcutting,
	blacksmithing = ProfessionBlacksmithing,
	herbalism = ProfessionHerbalism,
	alchemy = ProfessionAlchemy
}
ArchetypeNames = {
	[ArchetypeWarfare] = "Warfare",
	[ArchetypeArchery] = "Archery",
	[ArchetypeShadow] = "Shadow",
	[ArchetypeProtection] = "Protection",
	[ArchetypeWizardry] = "Wizardry",
	[ArchetypeHoly] = "Holy",
	[ArchetypeSpiritual] = "Spiritual",
	[ArchetypeWitchcraft] = "Witchcraft"
}
ArchetypeIds = {
	warfare = ArchetypeWarfare,
	archery = ArchetypeArchery,
	shadow = ArchetypeShadow,
	protection = ArchetypeProtection,
	wizardry = ArchetypeWizardry,
	holy = ArchetypeHoly,
	spiritual = ArchetypeSpiritual,
	witchcraft = ArchetypeWitchcraft
}
ArchetypeFlags = {
	Protection = 8,
	Shadow = 4,
	Archery = 2,
	Warfare = 1,
	None = 0,
	Witchcraft = 128,
	Spiritual = 64,
	Holy = 32,
	Wizardry = 16
}
ReputationNames = {
	[ReputationVillain] = "Villain",
	[ReputationMercenary] = "Mercenary",
	[ReputationOrder] = "Order"
}
REPUTATION_NPC_TIER_1_EXPERIENCE = 1000
REPUTATION_NPC_TIER_2_EXPERIENCE = 3000
REPUTATION_NPC_TIER_3_EXPERIENCE = 7000
AbilityBarCategoryNone = 0
AbilityBarCategorySpell = 1
AbilityBarCategoryCrafting = 2
AbilityBarCategoryFishing = 3
AbilityBarCategoryShip = 4
AbilityBarCategoryWeaponSkill = 5
AbilityBarCategoryMount = 6
AbilityBarCategoryAetherRiftBuild = 7
AbilityBarCategoryMountSkillWidget = 8
AbilityBarCategoryFirst = 1
AbilityBarCategoryLast = 8
AbilityBarCategoryAll = -1
AbilityBarCategoryNames = {
	[AbilityBarCategorySpell] = "Spells",
	[AbilityBarCategoryCrafting] = "Crafting",
	[AbilityBarCategoryFishing] = "Fishing",
	[AbilityBarCategoryShip] = "Ship",
	[AbilityBarCategoryWeaponSkill] = "Weapon Skill",
	[AbilityBarCategoryAetherRiftBuild] = "Aether Rift Spells",
	[AbilityBarCategoryMount] = "Mount"
}
AbilityTypeSynthesis = 1
AbilityTypeShine = 2
AbilityTypeTouch = 3
AbilityTypeMend = 4
AbilityTypeFishing = 5
AbilityTypeBuff = 6
AbilityTypeFirst = 1
AbilityTypeLast = 6
AbilityTypeNames = {
	[AbilityTypeSynthesis] = "Synthesis",
	[AbilityTypeShine] = "Shine",
	[AbilityTypeTouch] = "Touch",
	[AbilityTypeMend] = "Mend",
	[AbilityTypeFishing] = "Fishing",
	[AbilityTypeBuff] = "Buff"
}
AbilityNames = {
	[AbilityTypeSynthesis] = {
		"Apprentice Synthesis",
		"Expert Synthesis",
		"Master Synthesis",
		"Artisan Synthesis",
		"Smither's Synthesis"
	},
	[AbilityTypeShine] = {
		"Apprentice Shine",
		"Expert Shine",
		"Master Shine",
		"Artisan Shine",
		"Carpenter's Shine"
	},
	[AbilityTypeTouch] = {
		"Apprentice Touch",
		"Expert Touch",
		"Master Touch",
		"Artisan Touch",
		"Precision Touch"
	},
	[AbilityTypeMend] = {
		"Apprentice Mend",
		"Expert Mend",
		"Master Mend",
		"Artisan Mend",
		"Focused Mend"
	},
	[AbilityTypeFishing] = {
		"Basic Reel",
		"Give Slack",
		"Big Reel",
		"Fishing Nets",
		"Expert Reel",
		"Harpoon",
		"Master Reel",
		"Fishing Basket",
		"Loosen Line",
		"Reinforced Nets",
		"Sharp Harpoon"
	},
	[AbilityTypeBuff] = {
		"New Tools",
		"Steady Hand",
		"Firm Grip",
		"Touch of Salt",
		"Distill",
		"Stabilize Mixture"
	}
}
ShaderNone = 0
ShaderLightBlue = 1
ShaderBlue = 2
ShaderRed = 3
ShaderDarkRed = 4
ShaderPurple = 5
ShaderWhite = 6
ShaderLightBlueStatic = 7
ShaderBlueStatic = 8
ShaderRedStatic = 9
ShaderDarkRedStatic = 10
ShaderPurpleStatic = 11
ShaderWhiteStatic = 12
ShaderMapLightFog = 13
ShaderMapHeavyFog = 14
ShaderMapLightRain = 15
ShaderMapHeavyRain = 16
ShaderMapHeavyRainLightning = 17
ShaderMapLightSandstorm = 18
ShaderMapHeavySandstorm = 19
ShaderMapLightSandstormDistortion = 20
ShaderMapHeavySandstormDistortion = 21
ShaderMapDistortion = 22
ShaderMapLightSnow = 23
ShaderMapHeavySnow = 24
ShaderWidgetGlow = 25
ShaderWidgetGrayscale = 26
ShaderAetherEnhancement = 27
ShaderMapSepia = 28
ShaderRage = 29
ShaderGreen = 30
ShaderGreenStatic = 31
ShaderYellow = 32
ShaderYellowStatic = 33
ShaderFreeze = 34
ShaderCreatureHighlight = 35
ShaderGreenOutfit = 36
ShaderPurpleOutfit = 37
ShaderDarkGreen = 38
ShaderDarkGreenStatic = 39
ShaderForestGreen = 40
ShaderMud = 41
WeaponShader1 = 42
WeaponShader2 = 43
WeaponShader3 = 44
MAPMARK_MISSION_COMPLETE = 0
MAPMARK_MISSION_AVAILABLE = 1
MAPMARK_MISSION_IN_PROGRESS = 2
MAPMARK_FISHING_AREA = 3
MAPMARK_TRADEPOST = 4
MAPMARK_HOUSE = 5
MAPMARK_SEAPORT = 6
MAPMARK_REGION_CONFLICT = 7
MAPMARK_DYNAMICEVENT = 8
MAPMARK_CRAFTING_STATION = 9
MAPMARK_LAND = 10
MAPMARK_COMPASS = 11
MAPMARK_MURDERER = 12
MAPMARK_TRADEPACK = 13
MAPMARK_SMALL_LAND = 14
MAPMARK_MEDIUM_LAND = 15
MAPMARK_LARGE_LAND = 16
MAPMARK_FORT = 17
MAPMARK_STRONGHOLD = 18
MAPMARK_PVP_ARENA = 19
MAPMARK_PARTY_MEMBER = 20
MAPMARK_RANGERS_COMPANY = 21
MAPMARK_REPUTATION_NPC_1 = 22
MAPMARK_REPUTATION_NPC_2 = 23
MAPMARK_REPUTATION_NPC_3 = 24
MAPMARK_NPC_BANK = 25
MAPMARK_NPC_FISHPOST = 26
MAPMARK_NPC_BUILDERS = 27
MAPMARK_NPC_WAREHOUSE = 28
MAPMARK_RESPAWN_SHRINE = 29
MAPMARK_MARKET = 30
MAPMARK_MOA_MERCHANT = 31
MAPMARK_PLAYER = 32
MAPMARK_ZONE = 33
MAPMARK_VENDOR = 34
MAPMARK_COLLECTOR = 35
MAPMARK_GUILD_WAR_TOWER_UNCLAIMED = 36
MAPMARK_GUILD_WAR_TOWER_OWN = 37
MAPMARK_GUILD_WAR_TOWER_OTHERS = 38
MAPMARK_GUILD_WAR_FLAG_UNCLAIMED = 39
MAPMARK_GUILD_WAR_FLAG_OWN = 40
MAPMARK_GUILD_WAR_FLAG_OTHERS = 41
MAPMARK_FLOOR_CHANGE = 42
MAPMARK_FIRST = MAPMARK_MISSION_COMPLETE
MAPMARK_LAST = MAPMARK_GUILD_WAR_FLAG_OTHERS
STAT_MAXHITPOINTS = 0
STAT_MAXMANAPOINTS = 1
STAT_ATTACKSPEED = 2
STAT_ATTACK = 3
STAT_PHYSICALATTACK = 4
STAT_MAGICATTACK = 5
STAT_DEFENSE = 6
STAT_PHYSICALDEFENSE = 7
STAT_MAGICDEFENSE = 8
STAT_MIGHT = 9
STAT_DEXTERITY = 10
STAT_HASTE = 11
STAT_INTELLIGENCE = 12
STAT_WISDOM = 13
STAT_SPELLCOOLDOWN = 14
STAT_RANGEBONUS = 15
STAT_HEAL = 16
STAT_SPEED = 17
STAT_MANA_REGENERATION = 18
STAT_CRITICAL_CHANCE = 19
STAT_CRITICAL_DAMAGE = 20
STAT_HEALTH_HEALING_PERCENT = 21
STAT_VITALITY = 22
STAT_HEALTH_REGENERATION = 23
CRAFTING_STAT_MEND = 0
CRAFTING_STAT_TOUCH = 1
CRAFTING_STAT_SYNTHESIS = 2
CRAFTING_STAT_CONDITION = 3
ITEM_GRADE_BASIC = 0
ITEM_GRADE_GRAND = 1
ITEM_GRADE_RARE = 2
ITEM_GRADE_ARCANE = 3
ITEM_GRADE_CELESTIAL = 4
ITEM_GRADE_ASCENDANT = 5
ITEM_GRADE_HEROIC = 6
ITEM_GRADE_MYTHIC = 7
ITEM_GRADE_LEGENDARY = 8
ITEM_GRADE_LEGENDARYPLUS = 9
ITEM_GRADE_LEGENDARYMAX = 10
ITEM_GRADE_FIRST = ITEM_GRADE_BASIC
ITEM_GRADE_LAST = ITEM_GRADE_LEGENDARYMAX
ItemGradeNames = {
	[ITEM_GRADE_BASIC] = "Basic",
	[ITEM_GRADE_GRAND] = "Grand",
	[ITEM_GRADE_RARE] = "Rare",
	[ITEM_GRADE_ARCANE] = "Arcane",
	[ITEM_GRADE_CELESTIAL] = "Celestial",
	[ITEM_GRADE_ASCENDANT] = "Ascendant",
	[ITEM_GRADE_HEROIC] = "Heroic",
	[ITEM_GRADE_MYTHIC] = "Mythic",
	[ITEM_GRADE_LEGENDARY] = "Legendary",
	[ITEM_GRADE_LEGENDARYPLUS] = "Legendary Plus",
	[ITEM_GRADE_LEGENDARYMAX] = "Legendary Max"
}
FishQualityNames = {
	[0] = "Average",
	"High",
	"Superior",
	"Artisan"
}
ItemQualityFrames = {
	[9] = "/images/ui/items/legendary/2",
	[10] = "/images/ui/items/legendary/3",
	[8] = "/images/ui/items/legendary/1"
}
SILVER_ICON_ID = 99
REPUTATION_ORDER_ICON_ID = 100
REPUTATION_MERCENARY_ICON_ID = 101
REPUTATION_CRIMINAL_ICON_ID = 102
INFAMY_ICON_ID = 103
LEVEL_UP_ICON_ID = 104
SPELL_RECAST_ICON = 105
SALT_WATER = 0
OCEAN_SHORE = 1
FRESH_WATER = 2
TradeState = {
	None = 0,
	Transfer = 4,
	Acknowledge = 3,
	Accept = 2,
	Initiated = 1
}
TRADEPACK_CATEGORY_DEFAULT = 1
TRADEPACK_CATEGORY_QUEST = 2
TRADEPACK_STORAGE_PLAYER = 1
TRADEPACK_STORAGE_SHIP = 2
TRADEPACK_STORAGE_WAGON = 3
TRADEPACK_STORAGE_FIRST = TRADEPACK_STORAGE_PLAYER
TRADEPACK_STORAGE_LAST = TRADEPACK_STORAGE_WAGON
SPECIAL_STATUS_ICON_NONE = 0
SPECIAL_STATUS_ICON_CULLING_EYE = 1
SPECIAL_STATUS_ICON_LEGENDARY_FISH = 2
REPUTATION_ORDER = 1
REPUTATION_MERCENARY = 2
REPUTATION_CRIMINAL = 3
REPUTATION_FIRST = REPUTATION_ORDER
REPUTATION_LAST = REPUTATION_CRIMINAL
REPUTATION_PATH_DEFAULT = 1
REPUTATION_PATH_LEFT = 2
REPUTATION_PATH_MIDDLE = 3
REPUTATION_PATH_RIGHT = 4
REPUTATION_PATH_FIRST = REPUTATION_PATH_DEFAULT
REPUTATION_PATH_LAST = REPUTATION_PATH_RIGHT
FishTypeNames = {
	[OCEAN_SHORE] = "Shoreline Fish",
	[FRESH_WATER] = "Fresh Water Fish",
	[SALT_WATER] = "Salt Water Fish"
}
FishingStats = {
	abilityBonusTable = {
		{
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
			15
		},
		{
			10,
			11,
			12,
			13,
			14,
			15,
			16,
			17,
			18,
			19,
			20
		},
		{
			15,
			16,
			17,
			18,
			19,
			20,
			21,
			22,
			23,
			24,
			25
		},
		{
			20,
			21,
			22,
			23,
			24,
			25,
			26,
			27,
			28,
			29,
			30
		},
		{
			25,
			26,
			27,
			28,
			29,
			30,
			31,
			32,
			33,
			34,
			35
		},
		{
			30,
			31,
			32,
			33,
			34,
			35,
			36,
			37,
			38,
			39,
			40
		}
	},
	durabilityTable = {
		{
			500,
			510,
			520,
			530,
			540,
			550,
			560,
			570,
			580,
			590,
			600
		},
		{
			750,
			760,
			770,
			780,
			790,
			800,
			810,
			820,
			830,
			840,
			850
		},
		{
			1000,
			1100,
			1200,
			1300,
			1400,
			1500,
			1600,
			1700,
			1800,
			1900,
			2000
		},
		{
			1250,
			1350,
			1450,
			1550,
			1650,
			1750,
			1850,
			1950,
			2050,
			2150,
			2250
		},
		{
			1500,
			1600,
			1700,
			1800,
			1900,
			2000,
			2100,
			2200,
			2300,
			2400,
			2500
		},
		{
			1750,
			1850,
			1950,
			2050,
			2150,
			2250,
			2350,
			2450,
			2550,
			2650,
			2750
		}
	}
}
Ports = {
	{
		minZoom = 3,
		description = "Ravencrest Port",
		maxZoom = 10,
		pos = {
			y = 5107,
			x = 5058,
			z = 6
		},
		type = MAPMARK_SEAPORT
	},
	{
		minZoom = 3,
		description = "Margrove Port",
		maxZoom = 10,
		pos = {
			y = 4866,
			x = 4875,
			z = 7
		},
		type = MAPMARK_SEAPORT
	},
	{
		minZoom = 3,
		description = "Barnsley Port",
		maxZoom = 10,
		pos = {
			y = 4990,
			x = 5025,
			z = 6
		},
		type = MAPMARK_SEAPORT
	},
	{
		minZoom = 3,
		description = "Sajecho Port",
		maxZoom = 10,
		pos = {
			y = 5008,
			x = 4785,
			z = 6
		},
		type = MAPMARK_SEAPORT
	},
	{
		minZoom = 3,
		description = "Orca Bay Port",
		maxZoom = 10,
		pos = {
			y = 5341,
			x = 4673,
			z = 6
		},
		type = MAPMARK_SEAPORT
	},
	{
		minZoom = 3,
		description = "Eelsnout Port",
		maxZoom = 10,
		pos = {
			y = 5274,
			x = 4439,
			z = 6
		},
		type = MAPMARK_SEAPORT
	},
	{
		minZoom = 3,
		description = "Roatuga Port",
		maxZoom = 10,
		pos = {
			y = 5081,
			x = 4254,
			z = 6
		},
		type = MAPMARK_SEAPORT
	},
	{
		minZoom = 3,
		description = "Seabreeze Port",
		maxZoom = 10,
		pos = {
			y = 5165,
			x = 3982,
			z = 6
		},
		type = MAPMARK_SEAPORT
	},
	{
		minZoom = 3,
		description = "Northern Hook Port",
		maxZoom = 10,
		pos = {
			y = 4873,
			x = 4083,
			z = 6
		},
		type = MAPMARK_SEAPORT
	},
	{
		minZoom = 3,
		description = "Mount Shiver Northern Dock",
		maxZoom = 10,
		pos = {
			y = 4882,
			x = 4336,
			z = 6
		},
		type = MAPMARK_SEAPORT
	},
	{
		minZoom = 3,
		description = "Hogula Port",
		maxZoom = 10,
		pos = {
			y = 5495,
			x = 4360,
			z = 6
		},
		type = MAPMARK_SEAPORT
	},
	{
		minZoom = 3,
		description = "Rumalos Abandoned Dock",
		maxZoom = 10,
		pos = {
			y = 5594,
			x = 3932,
			z = 6
		},
		type = MAPMARK_SEAPORT
	},
	{
		minZoom = 3,
		description = "Gilead Port",
		maxZoom = 10,
		pos = {
			y = 5935,
			x = 4287,
			z = 6
		},
		type = MAPMARK_SEAPORT
	},
	{
		minZoom = 3,
		description = "Vikkar Bay Port",
		maxZoom = 10,
		pos = {
			y = 4361,
			x = 4636,
			z = 6
		},
		type = MAPMARK_SEAPORT
	},
	{
		minZoom = 3,
		description = "Newvik Port",
		maxZoom = 10,
		pos = {
			y = 4258,
			x = 4310,
			z = 6
		},
		type = MAPMARK_SEAPORT
	},
	{
		minZoom = 3,
		description = "Saint Alsek Port",
		maxZoom = 10,
		pos = {
			y = 4190,
			x = 4114,
			z = 6
		},
		type = MAPMARK_SEAPORT
	},
	{
		minZoom = 3,
		description = "Forgotten Wharf",
		maxZoom = 10,
		pos = {
			y = 4634,
			x = 5883,
			z = 6
		},
		type = MAPMARK_SEAPORT
	},
	{
		minZoom = 3,
		description = "Bog's Berth Dock",
		maxZoom = 10,
		pos = {
			y = 4682,
			x = 5993,
			z = 6
		},
		type = MAPMARK_SEAPORT
	}
}
GeneralNpcs = {
	{
		description = "Collector",
		type = MAPMARK_COLLECTOR,
		pos = {
			y = 5307,
			x = 4700,
			z = 7
		}
	},
	{
		description = "Collector",
		type = MAPMARK_COLLECTOR,
		pos = {
			y = 5085,
			x = 5116,
			z = 6
		}
	},
	{
		description = "Collector",
		type = MAPMARK_COLLECTOR,
		pos = {
			y = 5544,
			x = 5366,
			z = 6
		}
	},
	{
		description = "Bank",
		type = MAPMARK_NPC_BANK,
		pos = {
			y = 5111,
			x = 5115,
			z = 6
		}
	},
	{
		description = "Builder",
		type = MAPMARK_NPC_BUILDERS,
		pos = {
			y = 4974,
			x = 5029,
			z = 7
		}
	},
	{
		description = "Builder",
		type = MAPMARK_NPC_BUILDERS,
		pos = {
			y = 5111,
			x = 5069,
			z = 6
		}
	},
	{
		description = "Builder",
		type = MAPMARK_NPC_BUILDERS,
		pos = {
			y = 5112,
			x = 5081,
			z = 6
		}
	},
	{
		description = "Builder",
		type = MAPMARK_NPC_BUILDERS,
		pos = {
			y = 5206,
			x = 5132,
			z = 7
		}
	},
	{
		description = "Fishpost",
		type = MAPMARK_NPC_FISHPOST,
		pos = {
			y = 5152,
			x = 3983,
			z = 6
		}
	},
	{
		description = "Fishpost",
		type = MAPMARK_NPC_FISHPOST,
		pos = {
			y = 5495,
			x = 4355,
			z = 6
		}
	},
	{
		description = "Fishpost",
		type = MAPMARK_NPC_FISHPOST,
		pos = {
			y = 5335,
			x = 4664,
			z = 7
		}
	},
	{
		description = "Fishpost",
		type = MAPMARK_NPC_FISHPOST,
		pos = {
			y = 4868,
			x = 4879,
			z = 7
		}
	},
	{
		description = "Fishpost",
		type = MAPMARK_NPC_FISHPOST,
		pos = {
			y = 5097,
			x = 5052,
			z = 6
		}
	},
	{
		description = "Warehouse",
		type = MAPMARK_NPC_WAREHOUSE,
		pos = {
			y = 5593,
			x = 3940,
			z = 7
		}
	},
	{
		description = "Warehouse",
		type = MAPMARK_NPC_WAREHOUSE,
		pos = {
			y = 5159,
			x = 3981,
			z = 6
		}
	},
	{
		description = "Warehouse",
		type = MAPMARK_NPC_WAREHOUSE,
		pos = {
			y = 4189,
			x = 4118,
			z = 6
		}
	},
	{
		description = "Warehouse",
		type = MAPMARK_NPC_WAREHOUSE,
		pos = {
			y = 5934,
			x = 4286,
			z = 6
		}
	},
	{
		description = "Warehouse",
		type = MAPMARK_NPC_WAREHOUSE,
		pos = {
			y = 4260,
			x = 4310,
			z = 7
		}
	},
	{
		description = "Warehouse",
		type = MAPMARK_NPC_WAREHOUSE,
		pos = {
			y = 5500,
			x = 4358,
			z = 7
		}
	},
	{
		description = "Warehouse",
		type = MAPMARK_NPC_WAREHOUSE,
		pos = {
			y = 5270,
			x = 4438,
			z = 7
		}
	},
	{
		description = "Warehouse",
		type = MAPMARK_NPC_WAREHOUSE,
		pos = {
			y = 4360,
			x = 4637,
			z = 7
		}
	},
	{
		description = "Warehouse",
		type = MAPMARK_NPC_WAREHOUSE,
		pos = {
			y = 5337,
			x = 4671,
			z = 6
		}
	},
	{
		description = "Warehouse",
		type = MAPMARK_NPC_WAREHOUSE,
		pos = {
			y = 5006,
			x = 4790,
			z = 6
		}
	},
	{
		description = "Warehouse",
		type = MAPMARK_NPC_WAREHOUSE,
		pos = {
			y = 4865,
			x = 4880,
			z = 7
		}
	},
	{
		description = "Warehouse",
		type = MAPMARK_NPC_WAREHOUSE,
		pos = {
			y = 4988,
			x = 5026,
			z = 7
		}
	},
	{
		description = "Warehouse",
		type = MAPMARK_NPC_WAREHOUSE,
		pos = {
			y = 5115,
			x = 5066,
			z = 6
		}
	},
	{
		description = "Harbor Island Outpost",
		type = MAPMARK_RANGERS_COMPANY,
		pos = {
			y = 5131,
			x = 4005,
			z = 7
		}
	},
	{
		description = "Gilead Island Outpost",
		type = MAPMARK_RANGERS_COMPANY,
		pos = {
			y = 5594,
			x = 4205,
			z = 7
		}
	},
	{
		description = "Glaceforde Outpost",
		type = MAPMARK_RANGERS_COMPANY,
		pos = {
			y = 4475,
			x = 4436,
			z = 6
		}
	},
	{
		description = "Sajecho Island Outpost",
		type = MAPMARK_RANGERS_COMPANY,
		pos = {
			y = 5131,
			x = 4725,
			z = 7
		}
	},
	{
		description = "Rohna Woods Outpost",
		type = MAPMARK_RANGERS_COMPANY,
		pos = {
			y = 4976,
			x = 5058,
			z = 7
		}
	},
	{
		description = "Elder Coast Outpost",
		type = MAPMARK_RANGERS_COMPANY,
		pos = {
			y = 4664,
			x = 5281,
			z = 7
		}
	},
	{
		description = "South Glademire Outpost",
		type = MAPMARK_RANGERS_COMPANY,
		pos = {
			y = 5039,
			x = 5340,
			z = 7
		}
	},
	{
		description = "Hadarak Desert Outpost",
		type = MAPMARK_RANGERS_COMPANY,
		pos = {
			y = 5356,
			x = 5466,
			z = 7
		}
	},
	{
		description = "Forsaken Mountains Outpost",
		type = MAPMARK_RANGERS_COMPANY,
		pos = {
			y = 4857,
			x = 5478,
			z = 7
		}
	},
	{
		description = "Zephyr Vale Outpost",
		type = MAPMARK_RANGERS_COMPANY,
		pos = {
			y = 5250,
			x = 5848,
			z = 6
		}
	},
	{
		description = "Frost Steppes Outpost",
		type = MAPMARK_RANGERS_COMPANY,
		pos = {
			y = 4164,
			x = 5993,
			z = 6
		}
	},
	{
		description = "Seabreeze Tradepost",
		tradepostId = 4,
		type = MAPMARK_TRADEPOST,
		pos = {
			y = 5154,
			x = 3956,
			z = 6
		}
	},
	{
		description = "Gilead Tradepost",
		tradepostId = 7,
		type = MAPMARK_TRADEPOST,
		pos = {
			y = 5853,
			x = 4349,
			z = 7
		}
	},
	{
		description = "Glaceforde Tradepost",
		tradepostId = 8,
		type = MAPMARK_TRADEPOST,
		pos = {
			y = 4367,
			x = 4602,
			z = 7
		}
	},
	{
		description = "Orca Bay Tradepost",
		tradepostId = 3,
		type = MAPMARK_TRADEPOST,
		pos = {
			y = 5311,
			x = 4669,
			z = 7
		}
	},
	{
		description = "Margrove Tradepost",
		tradepostId = 2,
		type = MAPMARK_TRADEPOST,
		pos = {
			y = 4875,
			x = 4898,
			z = 7
		}
	},
	{
		description = "Tarmire Tradepost",
		tradepostId = 5,
		type = MAPMARK_TRADEPOST,
		pos = {
			y = 5500,
			x = 4967,
			z = 7
		}
	},
	{
		description = "Ravencrest Tradepost",
		tradepostId = 9,
		type = MAPMARK_TRADEPOST,
		pos = {
			y = 5108,
			x = 5070,
			z = 6
		}
	},
	{
		description = "Riverend Tradepost",
		tradepostId = 1,
		type = MAPMARK_TRADEPOST,
		pos = {
			y = 5150,
			x = 5483,
			z = 7
		}
	},
	{
		description = "Darzuac Tradepost",
		tradepostId = 6,
		type = MAPMARK_TRADEPOST,
		pos = {
			y = 5685,
			x = 5557,
			z = 7
		}
	},
	{
		description = "Defiance Tradepost",
		tradepostId = 10,
		type = MAPMARK_TRADEPOST,
		pos = {
			y = 5200,
			x = 5844,
			z = 7
		}
	},
	{
		description = "Kari'vir Tradepost",
		tradepostId = 12,
		type = MAPMARK_TRADEPOST,
		pos = {
			y = 4131,
			x = 5926,
			z = 5
		}
	},
	{
		description = "Dras Ashar Tradepost",
		tradepostId = 11,
		type = MAPMARK_TRADEPOST,
		pos = {
			y = 5686,
			x = 6340,
			z = 7
		}
	},
	{
		description = "Vendor",
		type = MAPMARK_VENDOR,
		pos = {
			y = 5133,
			x = 3938,
			z = 5
		}
	},
	{
		description = "Vendor",
		type = MAPMARK_VENDOR,
		pos = {
			y = 5134,
			x = 3964,
			z = 4
		}
	},
	{
		description = "Vendor",
		type = MAPMARK_VENDOR,
		pos = {
			y = 5868,
			x = 4311,
			z = 6
		}
	},
	{
		description = "Vendor",
		type = MAPMARK_VENDOR,
		pos = {
			y = 4493,
			x = 4413,
			z = 6
		}
	},
	{
		description = "Vendor",
		type = MAPMARK_VENDOR,
		pos = {
			y = 5298,
			x = 4682,
			z = 7
		}
	},
	{
		description = "Vendor",
		type = MAPMARK_VENDOR,
		pos = {
			y = 5090,
			x = 4764,
			z = 7
		}
	},
	{
		description = "Vendor",
		type = MAPMARK_VENDOR,
		pos = {
			y = 5519,
			x = 4937,
			z = 6
		}
	},
	{
		description = "Vendor",
		type = MAPMARK_VENDOR,
		pos = {
			y = 5111,
			x = 5099,
			z = 6
		}
	},
	{
		description = "Vendor",
		type = MAPMARK_VENDOR,
		pos = {
			y = 5112,
			x = 5107,
			z = 6
		}
	},
	{
		description = "Vendor",
		type = MAPMARK_VENDOR,
		pos = {
			y = 5095,
			x = 5117,
			z = 6
		}
	},
	{
		description = "Vendor",
		type = MAPMARK_VENDOR,
		pos = {
			y = 5088,
			x = 5143,
			z = 6
		}
	},
	{
		description = "Vendor",
		type = MAPMARK_VENDOR,
		pos = {
			y = 5201,
			x = 5173,
			z = 7
		}
	},
	{
		description = "Vendor",
		type = MAPMARK_VENDOR,
		pos = {
			y = 5507,
			x = 5361,
			z = 7
		}
	},
	{
		description = "Vendor",
		type = MAPMARK_VENDOR,
		pos = {
			y = 5689,
			x = 5523,
			z = 6
		}
	},
	{
		description = "Vendor",
		type = MAPMARK_VENDOR,
		pos = {
			y = 5710,
			x = 5529,
			z = 6
		}
	},
	{
		description = "Vendor",
		type = MAPMARK_VENDOR,
		pos = {
			y = 5700,
			x = 5551,
			z = 6
		}
	},
	{
		description = "Vendor",
		type = MAPMARK_VENDOR,
		pos = {
			y = 5227,
			x = 5629,
			z = 4
		}
	},
	{
		description = "Vendor",
		type = MAPMARK_VENDOR,
		pos = {
			y = 5229,
			x = 5663,
			z = 5
		}
	},
	{
		description = "Vendor",
		type = MAPMARK_VENDOR,
		pos = {
			y = 5548,
			x = 5841,
			z = 8
		}
	}
}
Tradeposts = {}

for _, npcConfig in ipairs(GeneralNpcs) do
	if npcConfig.tradepostId then
		npcConfig.name = npcConfig.description
		Tradeposts[npcConfig.tradepostId] = npcConfig
	end
end

TradepostsDistances = {
	{
		0,
		1008,
		1336,
		2228,
		1299,
		956,
		3540,
		1928,
		650,
		493,
		1954,
		1527
	},
	{
		1008,
		0,
		1205,
		1789,
		1437,
		1618,
		2993,
		920,
		603,
		1501,
		2616,
		2061
	},
	{
		1336,
		1205,
		0,
		980,
		1520,
		1701,
		2292,
		1831,
		686,
		1829,
		2699,
		2724
	},
	{
		2228,
		1789,
		980,
		0,
		2412,
		2593,
		1972,
		1511,
		1578,
		2721,
		3591,
		3616
	},
	{
		1299,
		1437,
		1520,
		2412,
		0,
		991,
		3724,
		2201,
		834,
		1630,
		1989,
		2826
	},
	{
		956,
		1618,
		1701,
		2593,
		991,
		0,
		3905,
		2382,
		1015,
		1287,
		1233,
		2483
	},
	{
		3540,
		2993,
		2292,
		1972,
		3724,
		3905,
		0,
		2715,
		2890,
		4033,
		4903,
		4928
	},
	{
		1928,
		920,
		1831,
		1511,
		2201,
		2382,
		2715,
		0,
		1367,
		2421,
		3380,
		2981
	},
	{
		650,
		603,
		686,
		1578,
		834,
		1015,
		2890,
		1367,
		0,
		1143,
		2013,
		2038
	},
	{
		493,
		1501,
		1829,
		2721,
		1630,
		1287,
		4033,
		2421,
		1143,
		0,
		2285,
		2020
	},
	{
		1954,
		2616,
		2699,
		3591,
		1989,
		1233,
		4903,
		3380,
		2013,
		2285,
		0,
		3481
	},
	{
		1527,
		2061,
		2724,
		3616,
		2826,
		2483,
		4928,
		2981,
		2038,
		2020,
		3481,
		0
	}
}
RegionRavencrest = 1
RegionSouthGlademire = 2
RegionNorthGlademire = 4
RegionRohnaWoods = 8
RegionForsakenMountains = 16
RegionSajechoIsland = 32
RegionBuildingBrush = 64
RegionHarborIsland = 128
RegionHadarakDesert = 256
RegionIceContinent = 512
RegionLyderia = 1024
RegionGileadIsland = 2048
RegionElderCoast = 16384
RegionCrowhollowBog = 32768
RegionZephyrVale = 65536
RegionFieldsOfDespair = 131072
RegionTheBlotch = 262144
RegionNorthSteppes = 1048576
Regions = {
	[RegionRavencrest] = {
		name = "Glademire",
		pos = {
			y = 5003,
			x = 5299,
			z = 7
		}
	},
	[RegionSouthGlademire] = {
		name = "Glademire",
		pos = {
			y = 5003,
			x = 5299,
			z = 7
		}
	},
	[RegionNorthGlademire] = {
		name = "Glademire",
		pos = {
			y = 5003,
			x = 5299,
			z = 7
		}
	},
	[RegionRohnaWoods] = {
		name = "Rohna Woods",
		pos = {
			y = 4845,
			x = 5013,
			z = 7
		}
	},
	[RegionForsakenMountains] = {
		name = "Forsaken Mountains",
		pos = {
			y = 4803,
			x = 5445,
			z = 7
		},
		data = {
			displayName = "Forsaken\nMountains"
		}
	},
	[RegionSajechoIsland] = {
		name = "Sajecho Island",
		pos = {
			y = 5164,
			x = 4653,
			z = 7
		}
	},
	[RegionHarborIsland] = {
		name = "Harbor Island",
		pos = {
			y = 5014,
			x = 4095,
			z = 7
		}
	},
	[RegionHadarakDesert] = {
		name = "Hadarak Desert",
		pos = {
			y = 5497,
			x = 5524,
			z = 7
		}
	},
	[RegionGileadIsland] = {
		name = "Gilead Island",
		pos = {
			y = 5670,
			x = 4193,
			z = 7
		}
	},
	[RegionIceContinent] = {
		name = "Glaceforde",
		pos = {
			y = 4239,
			x = 4385,
			z = 7
		}
	},
	[RegionCrowhollowBog] = {
		name = "Crowhollow Bog",
		pos = {
			y = 4893,
			x = 5725,
			z = 7
		},
		data = {
			displayName = "Crowhollow\nBog"
		}
	},
	[RegionZephyrVale] = {
		name = "Zephyr Vale",
		pos = {
			y = 5109,
			x = 5886,
			z = 7
		}
	},
	[RegionFieldsOfDespair] = {
		name = "Fields of Despair",
		pos = {
			y = 4594,
			x = 5755,
			z = 7
		},
		data = {
			displayName = "Fields of\nDespair"
		}
	},
	[RegionTheBlotch] = {
		name = "The Blotch",
		pos = {
			y = 4744,
			x = 6015,
			z = 7
		}
	},
	[RegionElderCoast] = {
		name = "Elder Coast",
		pos = {
			y = 4600,
			x = 5231,
			z = 7
		}
	},
	[RegionNorthSteppes] = {
		name = "Frost Steppes",
		pos = {
			y = 4289,
			x = 5547,
			z = 7
		}
	}
}
RegionsAsc = {}

for id, region in pairs(Regions) do
	region.id = id

	table.insert(RegionsAsc, region)
end

table.sort(RegionsAsc, function(regionA, regionB)
	return regionA.name < regionB.name
end)

RegionNameToId = {
	Ravencrest = RegionRavencrest,
	["South Glademire"] = RegionSouthGlademire,
	["North Glademire"] = RegionNorthGlademire,
	["Rohna Woods"] = RegionRohnaWoods,
	["Forsaken Mountains"] = RegionForsakenMountains,
	["Sajecho Island"] = RegionSajechoIsland,
	["Harbor Island"] = RegionHarborIsland,
	["Hadarak Desert"] = RegionHadarakDesert,
	["Gilead Island"] = RegionGileadIsland,
	Lyderia = RegionLyderia,
	Glaceforde = RegionIceContinent,
	["Crowhollow Bog"] = RegionCrowhollowBog,
	["Zephyr Vale"] = RegionZephyrVale,
	Glademire = {
		RegionRavencrest,
		RegionSouthGlademire,
		RegionNorthGlademire
	},
	["Fields of Despair"] = RegionFieldsOfDespair,
	["The Blotch"] = RegionTheBlotch,
	["Elder Coast"] = RegionElderCoast,
	["Frost Steppes"] = RegionNorthSteppes
}
DynamicEvents = {
	{
		name = "Mounted Vengeance",
		pos = {
			y = 5316,
			x = 5442,
			z = 7
		}
	},
	{
		name = "Thirsty Bandits",
		pos = {
			y = 5076,
			x = 5236,
			z = 7
		}
	},
	{
		name = "Flower Power",
		pos = {
			y = 4988,
			x = 5160,
			z = 7
		}
	},
	{
		name = "For The Love of Demons",
		pos = {
			y = 5043,
			x = 5334,
			z = 7
		}
	},
	{
		name = "A Troll's Favorite Food",
		pos = {
			y = 5153,
			x = 5491,
			z = 7
		}
	},
	{
		name = "Goblins Attack!",
		pos = {
			y = 4978,
			x = 5031,
			z = 7
		}
	},
	{
		name = "Killer Bees",
		pos = {
			y = 4928,
			x = 4940,
			z = 5
		}
	},
	{
		name = "In The Spider's Web",
		pos = {
			y = 4903,
			x = 5008,
			z = 7
		}
	},
	{
		name = "Souls of the Forest",
		pos = {
			y = 4838,
			x = 5013,
			z = 7
		}
	},
	{
		name = "Trespassers Will Be Shot",
		pos = {
			y = 4802,
			x = 4996,
			z = 7
		}
	},
	{
		name = "Open Waters",
		pos = {
			y = 5071,
			x = 4301,
			z = 7
		}
	},
	{
		name = "Greedy Gliders",
		pos = {
			y = 5102,
			x = 4768,
			z = 7
		}
	},
	{
		name = "Piss Drunk Patrons",
		pos = {
			y = 5137,
			x = 3956,
			z = 6
		}
	},
	{
		name = "Raiders of the Wastes",
		pos = {
			y = 5329,
			x = 5238,
			z = 7
		}
	},
	{
		name = "Dangerous Denizens",
		pos = {
			y = 5338,
			x = 4996,
			z = 7
		}
	},
	{
		name = "Amphibious Assassins",
		pos = {
			y = 5512,
			x = 5340,
			z = 7
		}
	},
	{
		name = "Windy Canyon Clash",
		pos = {
			y = 5493,
			x = 5218,
			z = 7
		}
	},
	{
		name = "The Elderwood Grotto",
		pos = {
			y = 5264,
			x = 5368,
			z = 7
		}
	},
	{
		name = "Up From the Deep",
		pos = {
			y = 5146,
			x = 5496,
			z = 7
		}
	},
	{
		name = "Hidden Grounds",
		pos = {
			y = 4921,
			x = 4919,
			z = 7
		}
	},
	{
		name = "The Dark Lighthouse",
		pos = {
			y = 4964,
			x = 4981,
			z = 7
		}
	},
	{
		name = "Lit Beacons",
		pos = {
			y = 4813,
			x = 5106,
			z = 7
		}
	},
	{
		name = "Never Enough Furs",
		pos = {
			y = 4855,
			x = 4922,
			z = 7
		}
	},
	{
		name = "As Above So Below",
		pos = {
			y = 4904,
			x = 5209,
			z = 7
		}
	},
	{
		name = "The Shroom Shaman",
		pos = {
			y = 5063,
			x = 5269,
			z = 7
		}
	},
	{
		name = "The Astronomer's Prediction",
		pos = {
			y = 5266,
			x = 5158,
			z = 7
		}
	},
	[28] = {
		name = "Hexs Heavy Price",
		pos = {
			y = 5486,
			x = 5335,
			z = 7
		}
	},
	[30] = {
		name = "The Bone Carver",
		pos = {
			y = 5550,
			x = 5207,
			z = 7
		}
	},
	[31] = {
		name = "She Sells Seashells",
		pos = {
			y = 5474,
			x = 4874,
			z = 7
		}
	},
	[32] = {
		name = "Look Don't Touch",
		pos = {
			y = 5030,
			x = 4738,
			z = 7
		}
	},
	[33] = {
		name = "Ghost of The Old Mariner",
		pos = {
			y = 4907,
			x = 3983,
			z = 7
		}
	},
	[35] = {
		name = "The Murmuring Tree",
		pos = {
			y = 5237,
			x = 5261,
			z = 7
		}
	},
	[36] = {
		name = "What Does The Fox Say",
		pos = {
			y = 5461,
			x = 5261,
			z = 7
		}
	},
	[38] = {
		name = "Misty Waters",
		pos = {
			y = 5019,
			x = 4659,
			z = 7
		}
	},
	[39] = {
		name = "Swarming Spread",
		pos = {
			y = 5052,
			x = 3998,
			z = 7
		}
	},
	[40] = {
		name = "A Mushroom Cut In Half",
		pos = {
			y = 5073,
			x = 5325,
			z = 7
		}
	},
	[41] = {
		name = "A Usual Day At The Workshop",
		pos = {
			y = 5132,
			x = 4782,
			z = 7
		}
	},
	[42] = {
		name = "Hunters Under The Sunheat",
		pos = {
			y = 5471,
			x = 5236,
			z = 7
		}
	},
	[43] = {
		name = "Man Corrupted Grounds",
		pos = {
			y = 5119,
			x = 5261,
			z = 7
		}
	},
	[44] = {
		name = "Creepy Howls Under The Moon",
		pos = {
			y = 4959,
			x = 5184,
			z = 7
		}
	},
	[45] = {
		name = "A Sludging Mess",
		pos = {
			y = 5509,
			x = 4953,
			z = 7
		}
	},
	[46] = {
		name = "Possessed by Resentment",
		pos = {
			y = 5016,
			x = 3958,
			z = 7
		}
	},
	[47] = {
		name = "The Champion's Den",
		pos = {
			y = 5524,
			x = 4998,
			z = 2
		}
	},
	[48] = {
		name = "As Sharp as Wind",
		pos = {
			y = 5582,
			x = 5383,
			z = 7
		}
	},
	[49] = {
		name = "Night Sacrifice",
		pos = {
			y = 5566,
			x = 4376,
			z = 4
		}
	},
	[50] = {
		name = "The Hoarder's Stash",
		pos = {
			y = 5876,
			x = 4282,
			z = 6
		}
	},
	[51] = {
		name = "Fishy Secrets",
		pos = {
			y = 5828,
			x = 4239,
			z = 10
		}
	},
	[52] = {
		name = "Starving Crawlers",
		pos = {
			y = 4295,
			x = 4490,
			z = 7
		}
	},
	[53] = {
		name = "Frolls Over the Bridge",
		pos = {
			y = 4344,
			x = 4090,
			z = 5
		}
	},
	[54] = {
		name = "Picky Eaters",
		pos = {
			y = 4483,
			x = 4236,
			z = 7
		}
	},
	[55] = {
		name = "Aggressive Preservation",
		pos = {
			y = 4484,
			x = 4236,
			z = 7
		}
	},
	[56] = {
		name = "Magical Pheromones",
		pos = {
			y = 4293,
			x = 4174,
			z = 7
		}
	},
	[57] = {
		name = "Twisted Hybridization",
		pos = {
			y = 4294,
			x = 4174,
			z = 7
		}
	},
	[58] = {
		name = "Risky Business",
		pos = {
			y = 5511,
			x = 4071,
			z = 7
		}
	},
	[59] = {
		name = "Praise the Sun",
		pos = {
			y = 5647,
			x = 4388,
			z = 6
		}
	},
	[60] = {
		name = "Undead Harvesting",
		pos = {
			y = 4243,
			x = 4823,
			z = 9
		}
	},
	[61] = {
		name = "Ice Cold Enemies",
		pos = {
			y = 4202,
			x = 4772,
			z = 7
		}
	},
	[62] = {
		name = "Lady of the Snow",
		pos = {
			y = 4305,
			x = 4510,
			z = 7
		}
	},
	[63] = {
		name = "Extremist Naturalists",
		pos = {
			y = 5568,
			x = 4113,
			z = 7
		}
	},
	[64] = {
		name = "Humanity Lost",
		pos = {
			y = 4761,
			x = 5479,
			z = 7
		}
	},
	[65] = {
		name = "Living Tale",
		pos = {
			y = 5476,
			x = 4172,
			z = 7
		}
	},
	[66] = {
		name = "Tool Appropriation",
		pos = {
			y = 4403,
			x = 4248,
			z = 7
		}
	},
	[67] = {
		name = "Foreigner's Plague",
		pos = {
			y = 4353,
			x = 4614,
			z = 7
		}
	},
	[68] = {
		name = "Reel Big Fish",
		pos = {
			y = 5873,
			x = 4044,
			z = 7
		}
	},
	[69] = {
		name = "Keeper of the Lamp",
		pos = {
			y = 4318,
			x = 4830,
			z = 7
		}
	},
	[70] = {
		name = "Tower of the Everliving",
		pos = {
			y = 5214,
			x = 4530,
			z = 1
		}
	},
	[71] = {
		name = "Overrun Hideout",
		pos = {
			y = 5439,
			x = 4946,
			z = 7
		}
	},
	[72] = {
		name = "The Red Count",
		pos = {
			y = 4735,
			x = 5416,
			z = 3
		}
	},
	[74] = {
		name = "Toxicity",
		pos = {
			y = 4777,
			x = 5823,
			z = 7
		}
	},
	[75] = {
		name = "Chain Reaction",
		pos = {
			y = 4938,
			x = 5703,
			z = 7
		}
	},
	[76] = {
		name = "No Rest for the Wicked",
		pos = {
			y = 5032,
			x = 5481,
			z = 7
		}
	},
	[77] = {
		name = "The Muddy Catch",
		pos = {
			y = 4896,
			x = 5759,
			z = 7
		}
	},
	[78] = {
		name = "A Bad Hookup",
		pos = {
			y = 4897,
			x = 5759,
			z = 7
		}
	},
	[79] = {
		name = "Reaping Harvest",
		pos = {
			y = 5185,
			x = 5841,
			z = 7
		}
	},
	[80] = {
		name = "Daughters of Slaughter I",
		pos = {
			y = 4724,
			x = 5729,
			z = 9
		}
	},
	[81] = {
		name = "Daughters of Slaughter II",
		pos = {
			y = 4781,
			x = 5638,
			z = 9
		}
	},
	[82] = {
		name = "Daughters of Slaughter III",
		pos = {
			y = 4903,
			x = 5710,
			z = 9
		}
	},
	[83] = {
		name = "The Corvine Bride",
		pos = {
			y = 4810,
			x = 5795,
			z = 10
		}
	},
	[84] = {
		name = "Horn of Rage",
		pos = {
			y = 5463,
			x = 5685,
			z = 9
		}
	},
	[85] = {
		name = "Drunken Ritual",
		pos = {
			y = 5060,
			x = 5212,
			z = 7
		}
	},
	[86] = {
		name = "Fear the Reaper",
		pos = {
			y = 4899,
			x = 5707,
			z = 7
		}
	},
	[87] = {
		name = "Raiders' Reunion",
		pos = {
			y = 5546,
			x = 5786,
			z = 7
		}
	},
	[88] = {
		name = "Turmoil in Orkwatch",
		pos = {
			y = 5523,
			x = 5489,
			z = 7
		}
	},
	[89] = {
		name = "An Escort to Truce",
		pos = {
			y = 5155,
			x = 5825,
			z = 7
		}
	},
	[90] = {
		name = "Orcultist Society",
		pos = {
			y = 5432,
			x = 5830,
			z = 7
		}
	},
	[91] = {
		name = "Parching Gaze",
		pos = {
			y = 5622,
			x = 6011,
			z = 8
		}
	},
	[92] = {
		name = "An Escort to Bastion",
		pos = {
			y = 5182,
			x = 5792,
			z = 7
		}
	},
	[93] = {
		name = "An Escort to Defiance",
		pos = {
			y = 5248,
			x = 5771,
			z = 7
		}
	},
	[94] = {
		name = "A Dance with Ghosts",
		pos = {
			y = 4772,
			x = 6032,
			z = 7
		}
	},
	[95] = {
		name = "Masked Onslaught",
		pos = {
			y = 5242,
			x = 5752,
			z = 7
		}
	},
	[96] = {
		name = "Scales of Corruption",
		pos = {
			y = 4680,
			x = 6113,
			z = 9
		}
	},
	[97] = {
		name = "The Caw of Yl'zogog",
		pos = {
			y = 4752,
			x = 5958,
			z = 14
		}
	},
	[98] = {
		name = "Tainted Breed",
		pos = {
			y = 4700,
			x = 6098,
			z = 6
		}
	},
	[99] = {
		name = "Just a Drop",
		pos = {
			y = 5316,
			x = 5675,
			z = 7
		}
	},
	[100] = {
		name = "The Wizard Frozen in Time",
		pos = {
			y = 4327,
			x = 4829,
			z = 0
		}
	},
	[101] = {
		name = "Defiance Calls for Aid",
		pos = {
			y = 5280,
			x = 5736,
			z = 7
		}
	},
	[102] = {
		name = "Children of the Damned",
		pos = {
			y = 4550,
			x = 5689,
			z = 7
		}
	},
	[103] = {
		name = "Sealed Under the Dark",
		pos = {
			y = 4640,
			x = 5851,
			z = 9
		}
	},
	[104] = {
		name = "Tax Collection",
		pos = {
			y = 5002,
			x = 5903,
			z = 6
		}
	},
	[105] = {
		name = "Sealed Amidst the Fire",
		pos = {
			y = 4481,
			x = 5863,
			z = 10
		}
	},
	[106] = {
		name = "Salt Water Pit",
		pos = {
			y = 4998,
			x = 4213,
			z = 10
		}
	},
	[107] = {
		name = "Trench Warfare",
		pos = {
			y = 5479,
			x = 5930,
			z = 7
		}
	},
	[108] = {
		name = "The Whirlwind General",
		pos = {
			y = 5455,
			x = 5905,
			z = 7
		}
	},
	[109] = {
		name = "The Sandswept Sentinel",
		pos = {
			y = 5507,
			x = 5938,
			z = 7
		}
	},
	[110] = {
		name = "Shackled Memories",
		pos = {
			y = 5608,
			x = 3987,
			z = 7
		}
	},
	[111] = {
		name = "Gritty General",
		pos = {
			y = 4900,
			x = 4339,
			z = 7
		}
	},
	[112] = {
		name = "When the Eastern Blows",
		pos = {
			y = 4867,
			x = 6079,
			z = 6
		}
	},
	[113] = {
		name = "The Colossus of the Quorras",
		pos = {
			y = 5400,
			x = 6021,
			z = 10
		}
	},
	[114] = {
		name = "Clash of the Elements",
		pos = {
			y = 5563,
			x = 5916,
			z = 11
		}
	},
	[115] = {
		name = "In the Eye of the Storm",
		pos = {
			y = 5571,
			x = 6035,
			z = 2
		}
	},
	[116] = {
		name = "Unweaving Magic",
		pos = {
			y = 5391,
			x = 5956,
			z = 7
		}
	},
	[117] = {
		name = "The Husk of Skorn",
		pos = {
			y = 4521,
			x = 6126,
			z = 5
		}
	},
	[118] = {
		name = "Ancestral Feud",
		pos = {
			y = 4922,
			x = 5519,
			z = 7
		}
	},
	[119] = {
		name = "A Bloody Reception",
		pos = {
			y = 4736,
			x = 5415,
			z = 5
		}
	},
	[120] = {
		name = "The Blackscale Terror",
		pos = {
			y = 5287,
			x = 5410,
			z = 9
		}
	},
	[121] = {
		name = "Pieces on a Chessboard",
		pos = {
			y = 4521,
			x = 6098,
			z = 3
		}
	},
	[122] = {
		name = "The Woodland Wardens",
		pos = {
			y = 4108,
			x = 5205,
			z = 7
		}
	},
	[123] = {
		name = "Survival of the Fittest",
		pos = {
			y = 4327,
			x = 5739,
			z = 7
		}
	},
	[124] = {
		name = "Forest of Wrath",
		pos = {
			y = 4108,
			x = 5205,
			z = 7
		}
	},
	[125] = {
		name = "Shadows From Our Past",
		pos = {
			y = 4597,
			x = 5092,
			z = 7
		}
	},
	[126] = {
		name = "Downright Mayhem",
		pos = {
			y = 4593,
			x = 5283,
			z = 9
		}
	},
	[127] = {
		name = "Suffering From Heartburn",
		pos = {
			y = 4473,
			x = 5327,
			z = 10
		}
	},
	[128] = {
		name = "Primal Stampede",
		pos = {
			y = 4254,
			x = 5475,
			z = 7
		}
	},
	[129] = {
		name = "Blood Bowl",
		pos = {
			y = 4241,
			x = 5326,
			z = 6
		}
	},
	[130] = {
		name = "Prison on the Peak",
		pos = {
			y = 3965,
			x = 5800,
			z = 3
		}
	},
	[131] = {
		name = "Winter Night Ritual",
		pos = {
			y = 4270,
			x = 5581,
			z = 7
		}
	},
	[132] = {
		name = "Green Tide Crashing",
		pos = {
			y = 4257,
			x = 5744,
			z = 7
		}
	},
	[133] = {
		name = "A Bloody Infestation",
		pos = {
			y = 4666,
			x = 5543,
			z = 10
		}
	}
}
CraftingStations = {
	[ProfessionBlacksmithing] = {
		{
			from = {
				y = 5110,
				x = 5098,
				z = 6
			},
			to = {
				y = 5116,
				x = 5104,
				z = 6
			}
		},
		{
			from = {
				y = 4973,
				x = 5037,
				z = 7
			},
			to = {
				y = 4976,
				x = 5040,
				z = 7
			}
		},
		{
			from = {
				y = 5060,
				x = 5291,
				z = 9
			},
			to = {
				y = 5062,
				x = 5293,
				z = 9
			}
		},
		{
			from = {
				y = 5033,
				x = 5339,
				z = 7
			},
			to = {
				y = 5036,
				x = 5344,
				z = 7
			}
		},
		{
			from = {
				y = 5290,
				x = 4700,
				z = 7
			},
			to = {
				y = 5293,
				x = 4703,
				z = 7
			}
		},
		{
			from = {
				y = 5120,
				x = 3946,
				z = 6
			},
			to = {
				y = 5124,
				x = 3950,
				z = 6
			}
		},
		{
			from = {
				y = 5533,
				x = 5366,
				z = 6
			},
			to = {
				y = 5535,
				x = 5368,
				z = 6
			}
		},
		{
			from = {
				y = 5702,
				x = 5508,
				z = 6
			},
			to = {
				y = 5708,
				x = 5512,
				z = 6
			}
		},
		{
			from = {
				y = 5486,
				x = 4961,
				z = 6
			},
			to = {
				y = 5488,
				x = 4964,
				z = 6
			}
		},
		{
			from = {
				y = 4864,
				x = 5361,
				z = 7
			},
			to = {
				y = 4866,
				x = 5363,
				z = 7
			}
		},
		{
			from = {
				y = 5597,
				x = 3971,
				z = 7
			},
			to = {
				y = 5602,
				x = 3973,
				z = 7
			}
		},
		{
			from = {
				y = 4420,
				x = 4214,
				z = 7
			},
			to = {
				y = 4424,
				x = 4218,
				z = 7
			}
		},
		{
			from = {
				y = 4460,
				x = 4322,
				z = 7
			},
			to = {
				y = 4464,
				x = 4325,
				z = 7
			}
		},
		{
			from = {
				y = 5238,
				x = 5639,
				z = 5
			},
			to = {
				y = 5241,
				x = 5643,
				z = 5
			}
		},
		{
			from = {
				y = 4953,
				x = 5710,
				z = 6
			},
			to = {
				y = 4958,
				x = 5715,
				z = 7
			}
		},
		{
			from = {
				y = 4923,
				x = 6025,
				z = 4
			},
			to = {
				y = 4926,
				x = 6028,
				z = 4
			}
		},
		{
			from = {
				y = 4943,
				x = 6036,
				z = 7
			},
			to = {
				y = 4944,
				x = 6039,
				z = 7
			}
		},
		{
			from = {
				y = 4944,
				x = 6034,
				z = 7
			},
			to = {
				y = 4947,
				x = 6035,
				z = 7
			}
		},
		{
			from = {
				y = 4551,
				x = 5412,
				z = 12
			},
			to = {
				y = 4554,
				x = 5414,
				z = 12
			}
		},
		{
			from = {
				y = 4815,
				x = 5367,
				z = 10
			},
			to = {
				y = 4817,
				x = 5370,
				z = 10
			}
		}
	},
	[ProfessionCooking] = {
		{
			from = {
				y = 5087,
				x = 5154,
				z = 6
			},
			to = {
				y = 5090,
				x = 5158,
				z = 6
			}
		},
		{
			from = {
				y = 5044,
				x = 5108,
				z = 7
			},
			to = {
				y = 5047,
				x = 5110,
				z = 7
			}
		},
		{
			from = {
				y = 4983,
				x = 5037,
				z = 7
			},
			to = {
				y = 4986,
				x = 5040,
				z = 7
			}
		},
		{
			from = {
				y = 5153,
				x = 5497,
				z = 7
			},
			to = {
				y = 5155,
				x = 5499,
				z = 7
			}
		},
		{
			from = {
				y = 5098,
				x = 4800,
				z = 6
			},
			to = {
				y = 5103,
				x = 4805,
				z = 6
			}
		},
		{
			from = {
				y = 5083,
				x = 4217,
				z = 6
			},
			to = {
				y = 5087,
				x = 4220,
				z = 6
			}
		},
		{
			from = {
				y = 5133,
				x = 3982,
				z = 6
			},
			to = {
				y = 5136,
				x = 3985,
				z = 6
			}
		},
		{
			from = {
				y = 5291,
				x = 4941,
				z = 5
			},
			to = {
				y = 5292,
				x = 4946,
				z = 5
			}
		},
		{
			from = {
				y = 5714,
				x = 5528,
				z = 6
			},
			to = {
				y = 5716,
				x = 5531,
				z = 6
			}
		},
		{
			from = {
				y = 4864,
				x = 5403,
				z = 7
			},
			to = {
				y = 4866,
				x = 5406,
				z = 7
			}
		},
		{
			from = {
				y = 5501,
				x = 4272,
				z = 7
			},
			to = {
				y = 5504,
				x = 4279,
				z = 7
			}
		},
		{
			from = {
				y = 4504,
				x = 4367,
				z = 7
			},
			to = {
				y = 4508,
				x = 4371,
				z = 7
			}
		},
		{
			from = {
				y = 4331,
				x = 4614,
				z = 7
			},
			to = {
				y = 4335,
				x = 4618,
				z = 7
			}
		},
		{
			from = {
				y = 5238,
				x = 5628,
				z = 6
			},
			to = {
				y = 5241,
				x = 5632,
				z = 6
			}
		},
		{
			from = {
				y = 4964,
				x = 5711,
				z = 6
			},
			to = {
				y = 4966,
				x = 5713,
				z = 6
			}
		},
		{
			from = {
				y = 4915,
				x = 6054,
				z = 6
			},
			to = {
				y = 4919,
				x = 6059,
				z = 6
			}
		},
		{
			from = {
				y = 4565,
				x = 5396,
				z = 13
			},
			to = {
				y = 4569,
				x = 5399,
				z = 13
			}
		},
		{
			from = {
				y = 4149,
				x = 5934,
				z = 6
			},
			to = {
				y = 4151,
				x = 5936,
				z = 6
			}
		}
	},
	[ProfessionCarpentry] = {
		{
			from = {
				y = 5125,
				x = 5129,
				z = 6
			},
			to = {
				y = 5129,
				x = 5137,
				z = 6
			}
		},
		{
			from = {
				y = 4853,
				x = 4950,
				z = 7
			},
			to = {
				y = 4857,
				x = 4955,
				z = 7
			}
		},
		{
			from = {
				y = 5061,
				x = 5286,
				z = 9
			},
			to = {
				y = 5063,
				x = 5289,
				z = 9
			}
		},
		{
			from = {
				y = 5094,
				x = 4621,
				z = 7
			},
			to = {
				y = 5099,
				x = 4628,
				z = 7
			}
		},
		{
			from = {
				y = 5140,
				x = 3958,
				z = 6
			},
			to = {
				y = 5142,
				x = 3965,
				z = 6
			}
		},
		{
			from = {
				y = 5519,
				x = 5395,
				z = 6
			},
			to = {
				y = 5521,
				x = 5399,
				z = 6
			}
		},
		{
			from = {
				y = 5698,
				x = 5530,
				z = 6
			},
			to = {
				y = 5701,
				x = 5540,
				z = 6
			}
		},
		{
			from = {
				y = 4835,
				x = 5469,
				z = 7
			},
			to = {
				y = 4838,
				x = 5471,
				z = 7
			}
		},
		{
			from = {
				y = 4835,
				x = 5495,
				z = 7
			},
			to = {
				y = 4838,
				x = 5497,
				z = 7
			}
		},
		{
			from = {
				y = 5880,
				x = 4330,
				z = 7
			},
			to = {
				y = 5884,
				x = 4334,
				z = 7
			}
		},
		{
			from = {
				y = 5880,
				x = 4330,
				z = 7
			},
			to = {
				y = 5884,
				x = 4334,
				z = 7
			}
		},
		{
			from = {
				y = 4173,
				x = 4124,
				z = 5
			},
			to = {
				y = 4176,
				x = 4127,
				z = 5
			}
		},
		{
			from = {
				y = 4349,
				x = 4616,
				z = 7
			},
			to = {
				y = 4352,
				x = 4618,
				z = 7
			}
		},
		{
			from = {
				y = 5250,
				x = 5606,
				z = 6
			},
			to = {
				y = 5253,
				x = 5611,
				z = 6
			}
		},
		{
			from = {
				y = 4983,
				x = 6030,
				z = 7
			},
			to = {
				y = 4988,
				x = 6034,
				z = 7
			}
		},
		{
			from = {
				y = 4990,
				x = 6029,
				z = 7
			},
			to = {
				y = 4994,
				x = 6035,
				z = 7
			}
		},
		{
			from = {
				y = 4965,
				x = 5695,
				z = 6
			},
			to = {
				y = 4970,
				x = 5699,
				z = 6
			}
		},
		{
			from = {
				y = 4129,
				x = 5965,
				z = 6
			},
			to = {
				y = 4131,
				x = 5967,
				z = 6
			}
		},
		{
			from = {
				y = 4816,
				x = 5364,
				z = 10
			},
			to = {
				y = 4821,
				x = 5366,
				z = 10
			}
		}
	},
	[ProfessionWeaving] = {
		{
			from = {
				y = 5111,
				x = 5159,
				z = 6
			},
			to = {
				y = 5116,
				x = 5164,
				z = 6
			}
		},
		{
			from = {
				y = 5046,
				x = 5152,
				z = 7
			},
			to = {
				y = 5049,
				x = 5155,
				z = 7
			}
		},
		{
			from = {
				y = 4862,
				x = 4888,
				z = 7
			},
			to = {
				y = 4864,
				x = 4891,
				z = 7
			}
		},
		{
			from = {
				y = 5033,
				x = 5339,
				z = 6
			},
			to = {
				y = 5036,
				x = 5344,
				z = 6
			}
		},
		{
			from = {
				y = 5244,
				x = 4463,
				z = 7
			},
			to = {
				y = 5247,
				x = 4466,
				z = 7
			}
		},
		{
			from = {
				y = 5153,
				x = 3961,
				z = 6
			},
			to = {
				y = 5159,
				x = 3965,
				z = 6
			}
		},
		{
			from = {
				y = 5431,
				x = 5157,
				z = 6
			},
			to = {
				y = 5435,
				x = 5160,
				z = 6
			}
		},
		{
			from = {
				y = 5713,
				x = 5546,
				z = 6
			},
			to = {
				y = 5716,
				x = 5550,
				z = 6
			}
		},
		{
			from = {
				y = 5482,
				x = 4249,
				z = 7
			},
			to = {
				y = 5484,
				x = 4254,
				z = 7
			}
		},
		{
			from = {
				y = 4184,
				x = 4145,
				z = 6
			},
			to = {
				y = 4187,
				x = 4148,
				z = 6
			}
		},
		{
			from = {
				y = 4484,
				x = 4371,
				z = 7
			},
			to = {
				y = 4486,
				x = 4374,
				z = 7
			}
		},
		{
			from = {
				y = 4420,
				x = 4219,
				z = 6
			},
			to = {
				y = 4424,
				x = 4222,
				z = 6
			}
		},
		{
			from = {
				y = 5242,
				x = 5660,
				z = 5
			},
			to = {
				y = 5244,
				x = 5663,
				z = 5
			}
		},
		{
			from = {
				y = 4942,
				x = 6016,
				z = 6
			},
			to = {
				y = 4947,
				x = 6020,
				z = 6
			}
		},
		{
			from = {
				y = 5076,
				x = 5749,
				z = 7
			},
			to = {
				y = 5079,
				x = 5752,
				z = 7
			}
		},
		{
			from = {
				y = 4571,
				x = 5102,
				z = 7
			},
			to = {
				y = 4575,
				x = 5106,
				z = 7
			}
		},
		{
			from = {
				y = 4814,
				x = 5384,
				z = 10
			},
			to = {
				y = 4817,
				x = 5386,
				z = 10
			}
		}
	},
	[ProfessionAlchemy] = {
		{
			from = {
				y = 5093,
				x = 5113,
				z = 5
			},
			to = {
				y = 5098,
				x = 5119,
				z = 5
			}
		},
		{
			from = {
				y = 5093,
				x = 5113,
				z = 6
			},
			to = {
				y = 5098,
				x = 5119,
				z = 6
			}
		},
		{
			from = {
				y = 5223,
				x = 5626,
				z = 4
			},
			to = {
				y = 5232,
				x = 5633,
				z = 4
			}
		},
		{
			from = {
				y = 5715,
				x = 5555,
				z = 5
			},
			to = {
				y = 5720,
				x = 5562,
				z = 5
			}
		},
		{
			from = {
				y = 4364,
				x = 4621,
				z = 7
			},
			to = {
				y = 4371,
				x = 4628,
				z = 7
			}
		},
		{
			from = {
				y = 5274,
				x = 4718,
				z = 6
			},
			to = {
				y = 5279,
				x = 4723,
				z = 6
			}
		},
		{
			from = {
				y = 4815,
				x = 5380,
				z = 10
			},
			to = {
				y = 4817,
				x = 5382,
				z = 10
			}
		}
	}
}
ZonesInfo = {
	{
		name = "Slums",
		maxLevel = 6,
		minLevel = 4,
		pos = {
			y = 5050,
			x = 5131,
			z = 7
		}
	},
	{
		name = "Ravencrest Grove",
		maxLevel = 32,
		minLevel = 6,
		wordBreaks = {
			1
		},
		pos = {
			y = 5071,
			x = 5207,
			z = 7
		}
	},
	{
		name = "Hookmask Camps",
		maxLevel = 10,
		minLevel = 7,
		wordBreaks = {
			1
		},
		pos = {
			y = 4999,
			x = 5208,
			z = 7
		}
	},
	{
		name = "Morninglight Mounds",
		maxLevel = 10,
		minLevel = 7,
		wordBreaks = {
			1
		},
		pos = {
			y = 4956,
			x = 5189,
			z = 7
		}
	},
	{
		name = "Ravencrest",
		pos = {
			y = 5141,
			x = 5122,
			z = 7
		}
	},
	{
		name = "Oakwood",
		maxLevel = 14,
		minLevel = 10,
		pos = {
			y = 4798,
			x = 5129,
			z = 7
		}
	},
	{
		name = "Azog Hills",
		maxLevel = 18,
		minLevel = 13,
		wordBreaks = {
			1
		},
		pos = {
			y = 4791,
			x = 5070,
			z = 7
		}
	},
	{
		name = "Barrendon Mines",
		maxLevel = 38,
		minLevel = 14,
		wordBreaks = {
			1
		},
		pos = {
			y = 4880,
			x = 5099,
			z = 7
		}
	},
	{
		name = "Siren Hills",
		maxLevel = 15,
		minLevel = 13,
		wordBreaks = {
			1
		},
		pos = {
			y = 4966,
			x = 5108,
			z = 7
		}
	},
	{
		name = "Greenshriek Hills",
		maxLevel = 16,
		minLevel = 13,
		wordBreaks = {
			1
		},
		pos = {
			y = 4951,
			x = 5034,
			z = 7
		}
	},
	{
		name = "Corvo Lighthouse",
		maxLevel = 79,
		minLevel = 11,
		wordBreaks = {
			1
		},
		pos = {
			y = 4945,
			x = 4960,
			z = 7
		}
	},
	{
		name = "Saltdusk Keep",
		maxLevel = 18,
		minLevel = 15,
		wordBreaks = {
			1
		},
		pos = {
			y = 4902,
			x = 4886,
			z = 7
		}
	},
	{
		name = "Furpack Hills",
		maxLevel = 18,
		minLevel = 15,
		wordBreaks = {
			1
		},
		pos = {
			y = 4838,
			x = 4919,
			z = 7
		}
	},
	{
		name = "Bentbow Hideout",
		maxLevel = 19,
		minLevel = 16,
		wordBreaks = {
			1
		},
		pos = {
			y = 4784,
			x = 5000,
			z = 7
		}
	},
	{
		name = "Rohna Woods",
		maxLevel = 55,
		minLevel = 12,
		wordBreaks = {
			1
		},
		pos = {
			y = 4874,
			x = 5012,
			z = 7
		}
	},
	{
		name = "Deep Rohna",
		maxLevel = 38,
		minLevel = 36,
		wordBreaks = {
			1
		},
		pos = {
			y = 4696,
			x = 4961,
			z = 7
		}
	},
	{
		name = "Margrove",
		pos = {
			y = 4871,
			x = 4914,
			z = 7
		}
	},
	{
		name = "Barnsley",
		pos = {
			y = 4996,
			x = 5037,
			z = 7
		}
	},
	{
		name = "Warlord's Rest",
		maxLevel = 30,
		minLevel = 8,
		pos = {
			y = 4904,
			x = 5214,
			z = 7
		}
	},
	{
		name = "Stonecrush Ruins",
		maxLevel = 11,
		minLevel = 8,
		wordBreaks = {
			1
		},
		pos = {
			y = 4854,
			x = 5169,
			z = 7
		}
	},
	{
		name = "Leapwater Marsh",
		maxLevel = 21,
		minLevel = 17,
		wordBreaks = {
			1
		},
		pos = {
			y = 4838,
			x = 5282,
			z = 7
		}
	},
	{
		name = "Ellesmera",
		maxLevel = 38,
		minLevel = 18,
		pos = {
			y = 4770,
			x = 5233,
			z = 7
		}
	},
	{
		name = "Sporeswamp Flats",
		maxLevel = 8,
		minLevel = 6,
		wordBreaks = {
			1
		},
		pos = {
			y = 5065,
			x = 5293,
			z = 7
		}
	},
	{
		name = "Sporeswamp Mines",
		maxLevel = 17,
		minLevel = 16,
		wordBreaks = {
			1
		},
		pos = {
			y = 5112,
			x = 5262,
			z = 7
		}
	},
	{
		name = "Chapel of Skorn",
		maxLevel = 44,
		minLevel = 17,
		pos = {
			y = 5007,
			x = 5387,
			z = 7
		}
	},
	{
		name = "Witches Crag",
		maxLevel = 19,
		minLevel = 17,
		wordBreaks = {
			1
		},
		pos = {
			y = 5133,
			x = 5323,
			z = 7
		}
	},
	{
		name = "Glademire Swamps",
		maxLevel = 18,
		minLevel = 16,
		wordBreaks = {
			1
		},
		pos = {
			y = 5076,
			x = 5420,
			z = 7
		}
	},
	{
		name = "Tarnag Mountain",
		maxLevel = 78,
		minLevel = 19,
		wordBreaks = {
			1
		},
		pos = {
			y = 5053,
			x = 5536,
			z = 7
		}
	},
	{
		name = "Aspen Woods",
		maxLevel = 18,
		minLevel = 17,
		wordBreaks = {
			1
		},
		pos = {
			y = 5133,
			x = 5382,
			z = 7
		}
	},
	{
		name = "Whispering Fountains",
		maxLevel = 35,
		minLevel = 23,
		wordBreaks = {
			1
		},
		pos = {
			y = 5233,
			x = 5281,
			z = 7
		}
	},
	{
		name = "Dalgon Canyon",
		maxLevel = 79,
		minLevel = 22,
		wordBreaks = {
			1
		},
		pos = {
			y = 5252,
			x = 5461,
			z = 7
		}
	},
	{
		name = "Glademire Fort",
		wordBreaks = {
			1
		},
		pos = {
			y = 5039,
			x = 5335,
			z = 7
		}
	},
	{
		name = "Riverend Post",
		wordBreaks = {
			1
		},
		pos = {
			y = 5155,
			x = 5490,
			z = 7
		}
	},
	{
		name = "The High Jungles",
		maxLevel = 23,
		minLevel = 21,
		wordBreaks = {
			2
		},
		pos = {
			y = 5036,
			x = 4774,
			z = 7
		}
	},
	{
		name = "Maud Isle",
		maxLevel = 24,
		minLevel = 22,
		wordBreaks = {
			1
		},
		pos = {
			y = 5051,
			x = 4703,
			z = 7
		}
	},
	{
		name = "Sajecho Ruins",
		maxLevel = 25,
		minLevel = 23,
		wordBreaks = {
			1
		},
		pos = {
			y = 5064,
			x = 4829,
			z = 7
		}
	},
	{
		name = "Skimcoast Cliffs",
		maxLevel = 26,
		minLevel = 24,
		pos = {
			y = 5111,
			x = 4737,
			z = 7
		}
	},
	{
		name = "Dead Man's Shore",
		maxLevel = 27,
		minLevel = 25,
		wordBreaks = {
			2
		},
		pos = {
			y = 5044,
			x = 4647,
			z = 7
		}
	},
	{
		name = "Sawcutt Lumber",
		maxLevel = 27,
		minLevel = 25,
		wordBreaks = {
			1
		},
		pos = {
			y = 5084,
			x = 4615,
			z = 7
		}
	},
	{
		name = "Gob' Gurzak",
		maxLevel = 27,
		minLevel = 25,
		pos = {
			y = 5127,
			x = 4668,
			z = 7
		}
	},
	{
		name = "Silkveil Overgrowth",
		maxLevel = 29,
		minLevel = 27,
		wordBreaks = {
			1
		},
		pos = {
			y = 5180,
			x = 4695,
			z = 7
		}
	},
	{
		name = "Tower of the Everliving",
		maxLevel = 31,
		minLevel = 29,
		wordBreaks = {
			1,
			3
		},
		pos = {
			y = 5217,
			x = 4522,
			z = 7
		}
	},
	{
		name = "Sajecho Village",
		wordBreaks = {
			1
		},
		pos = {
			y = 5082,
			x = 4759,
			z = 7
		}
	},
	{
		name = "Orca Bay",
		wordBreaks = {
			1
		},
		pos = {
			y = 5296,
			x = 4691,
			z = 7
		}
	},
	{
		name = "Eelsnout",
		pos = {
			y = 5251,
			x = 4456,
			z = 7
		}
	},
	{
		name = "Mount Shiver",
		maxLevel = 52,
		minLevel = 25,
		pos = {
			y = 4909,
			x = 4336,
			z = 7
		}
	},
	{
		name = "Shacklehold",
		maxLevel = 75,
		minLevel = 32,
		pos = {
			y = 4941,
			x = 4202,
			z = 7
		}
	},
	{
		name = "Turtleshell Hills",
		maxLevel = 30,
		minLevel = 28,
		wordBreaks = {
			1
		},
		pos = {
			y = 4985,
			x = 4148,
			z = 7
		}
	},
	{
		name = "Rockjaw Mounds",
		maxLevel = 32,
		minLevel = 29,
		wordBreaks = {
			1
		},
		pos = {
			y = 5043,
			x = 4111,
			z = 7
		}
	},
	{
		name = "Camp Clew",
		maxLevel = 34,
		minLevel = 33,
		wordBreaks = {
			1
		},
		pos = {
			y = 5059,
			x = 4049,
			z = 7
		}
	},
	{
		name = "Sweet Sugar Plantation",
		maxLevel = 32,
		minLevel = 30,
		wordBreaks = {
			2
		},
		pos = {
			y = 4944,
			x = 4042,
			z = 7
		}
	},
	{
		name = "Gallowstown",
		maxLevel = 33,
		minLevel = 32,
		pos = {
			y = 4906,
			x = 3987,
			z = 7
		}
	},
	{
		name = "Beacon Hills",
		maxLevel = 41,
		minLevel = 33,
		wordBreaks = {
			1
		},
		pos = {
			y = 4981,
			x = 3939,
			z = 7
		}
	},
	{
		name = "Brinewind Points",
		maxLevel = 34,
		minLevel = 33,
		wordBreaks = {
			1
		},
		pos = {
			y = 5028,
			x = 3950,
			z = 7
		}
	},
	{
		name = "Seabreeze",
		pos = {
			y = 5134,
			x = 3955,
			z = 7
		}
	},
	{
		name = "Port Roatuga",
		wordBreaks = {
			1
		},
		pos = {
			y = 5084,
			x = 4224,
			z = 7
		}
	},
	{
		name = "Hook's End",
		pos = {
			y = 4884,
			x = 4084,
			z = 7
		}
	},
	{
		name = "Thurin's Meadow",
		maxLevel = 77,
		minLevel = 31,
		wordBreaks = {
			1
		},
		pos = {
			y = 5258,
			x = 5733,
			z = 7
		}
	},
	{
		name = "Fort Mercury",
		maxLevel = 38,
		minLevel = 33,
		pos = {
			y = 5321,
			x = 5707,
			z = 7
		}
	},
	{
		name = "Aurum Hold",
		maxLevel = 86,
		minLevel = 39,
		wordBreaks = {
			1
		},
		pos = {
			y = 5096,
			x = 5961,
			z = 7
		}
	},
	{
		name = "Feral Woods",
		maxLevel = 38,
		minLevel = 35,
		wordBreaks = {
			1
		},
		pos = {
			y = 5113,
			x = 5889,
			z = 7
		}
	},
	{
		name = "Silvercliff Hills",
		maxLevel = 86,
		minLevel = 40,
		wordBreaks = {
			1
		},
		pos = {
			y = 5021,
			x = 5882,
			z = 7
		}
	},
	{
		name = "Firslight",
		maxLevel = 47,
		minLevel = 44,
		pos = {
			y = 4947,
			x = 6030,
			z = 7
		}
	},
	{
		name = "Bastion",
		pos = {
			y = 5237,
			x = 5634,
			z = 7
		}
	},
	{
		name = "Defiance",
		pos = {
			y = 5228,
			x = 5839,
			z = 7
		}
	},
	{
		name = "Truce",
		pos = {
			y = 5085,
			x = 5764,
			z = 7
		}
	},
	{
		name = "Hadarak Oasis",
		maxLevel = 35,
		minLevel = 34,
		wordBreaks = {
			1
		},
		pos = {
			y = 5306,
			x = 5211,
			z = 7
		}
	},
	{
		name = "Jaffar Hills",
		maxLevel = 38,
		minLevel = 35,
		wordBreaks = {
			1
		},
		pos = {
			y = 5324,
			x = 5327,
			z = 7
		}
	},
	{
		name = "Mount Minos",
		maxLevel = 84,
		minLevel = 36,
		wordBreaks = {
			1
		},
		pos = {
			y = 5377,
			x = 5177,
			z = 7
		}
	},
	{
		name = "Chainbreaker Camp",
		maxLevel = 36,
		minLevel = 35,
		wordBreaks = {
			1
		},
		pos = {
			y = 5383,
			x = 5264,
			z = 7
		}
	},
	{
		name = "Windy Canyon",
		maxLevel = 49,
		minLevel = 36,
		wordBreaks = {
			1
		},
		pos = {
			y = 5463,
			x = 5236,
			z = 7
		}
	},
	{
		name = "Tar Graveyard",
		maxLevel = 42,
		minLevel = 38,
		wordBreaks = {
			1
		},
		pos = {
			y = 5483,
			x = 5053,
			z = 7
		}
	},
	{
		name = "Drake's Claws",
		maxLevel = 47,
		minLevel = 44,
		pos = {
			y = 5570,
			x = 5066,
			z = 7
		}
	},
	{
		name = "Ivory Halls",
		maxLevel = 43,
		minLevel = 40,
		wordBreaks = {
			1
		},
		pos = {
			y = 5433,
			x = 4951,
			z = 7
		}
	},
	{
		name = "Tarmire Peaks",
		maxLevel = 44,
		minLevel = 39,
		wordBreaks = {
			1
		},
		pos = {
			y = 5530,
			x = 4987,
			z = 7
		}
	},
	{
		name = "Sharpa Keys",
		maxLevel = 80,
		minLevel = 41,
		wordBreaks = {
			1
		},
		pos = {
			y = 5463,
			x = 4873,
			z = 7
		}
	},
	{
		name = "The Spine",
		maxLevel = 41,
		minLevel = 37,
		pos = {
			y = 5421,
			x = 5340,
			z = 7
		}
	},
	{
		name = "Glimmering Pools",
		maxLevel = 67,
		minLevel = 36,
		pos = {
			y = 5568,
			x = 5372,
			z = 7
		}
	},
	{
		name = "Tuskan Highlands",
		maxLevel = 82,
		minLevel = 36,
		pos = {
			y = 5550,
			x = 5201,
			z = 7
		}
	},
	{
		name = "Tarmire",
		pos = {
			y = 5507,
			x = 4958,
			z = 7
		}
	},
	{
		name = "Dras Marna",
		wordBreaks = {
			1
		},
		pos = {
			y = 5440,
			x = 5167,
			z = 6
		}
	},
	{
		name = "Dras Narda",
		wordBreaks = {
			1
		},
		pos = {
			y = 5516,
			x = 5354,
			z = 6
		}
	},
	{
		name = "High Galdoz",
		maxLevel = 43,
		minLevel = 38,
		wordBreaks = {
			1
		},
		pos = {
			y = 5398,
			x = 5447,
			z = 3
		}
	},
	{
		name = "Orkwatch",
		maxLevel = 40,
		minLevel = 37,
		pos = {
			y = 5500,
			x = 5493,
			z = 7
		}
	},
	{
		name = "Buried Nest",
		maxLevel = 37,
		minLevel = 35,
		wordBreaks = {
			1
		},
		pos = {
			y = 5372,
			x = 5595,
			z = 7
		}
	},
	{
		name = "Broken Horn Bludd",
		maxLevel = 57,
		minLevel = 38,
		wordBreaks = {
			2
		},
		pos = {
			y = 5409,
			x = 5685,
			z = 7
		}
	},
	{
		name = "Hoovestep Mound",
		maxLevel = 57,
		minLevel = 38,
		wordBreaks = {
			1
		},
		pos = {
			y = 5514,
			x = 5588,
			z = 7
		}
	},
	{
		name = "Orkvesh",
		maxLevel = 75,
		minLevel = 52,
		pos = {
			y = 5431,
			x = 5832,
			z = 7
		}
	},
	{
		name = "Mirage Peaks",
		maxLevel = 71,
		minLevel = 57,
		wordBreaks = {
			1
		},
		pos = {
			y = 5612,
			x = 5875,
			z = 7
		}
	},
	{
		name = "Hadarak Ruins",
		maxLevel = 82,
		minLevel = 44,
		wordBreaks = {
			1
		},
		pos = {
			y = 5542,
			x = 5783,
			z = 7
		}
	},
	{
		name = "Riftsand Trenches",
		maxLevel = 72,
		minLevel = 70,
		wordBreaks = {
			1
		},
		pos = {
			y = 5475,
			x = 5932,
			z = 7
		}
	},
	{
		name = "Sandscar Sanctuary",
		maxLevel = 74,
		minLevel = 71,
		wordBreaks = {
			1
		},
		pos = {
			y = 5539,
			x = 6003,
			z = 7
		}
	},
	{
		name = "Arid Ranges",
		maxLevel = 73,
		minLevel = 70,
		wordBreaks = {
			1
		},
		pos = {
			y = 5469,
			x = 6037,
			z = 7
		}
	},
	{
		name = "Temple of Quorras",
		maxLevel = 74,
		minLevel = 71,
		wordBreaks = {
			2
		},
		pos = {
			y = 5377,
			x = 5955,
			z = 7
		}
	},
	{
		name = "Hogfort",
		maxLevel = 64,
		minLevel = 61,
		pos = {
			y = 5571,
			x = 6340,
			z = 7
		}
	},
	{
		name = "Mirage Oasis",
		maxLevel = 67,
		minLevel = 61,
		wordBreaks = {
			1
		},
		pos = {
			y = 5427,
			x = 6292,
			z = 7
		}
	},
	{
		name = "Ruins of Sahan",
		maxLevel = 57,
		minLevel = 54,
		wordBreaks = {
			2
		},
		pos = {
			y = 5775,
			x = 6169,
			z = 7
		}
	},
	{
		name = "Chittering Caves",
		maxLevel = 63,
		minLevel = 58,
		wordBreaks = {
			1
		},
		pos = {
			y = 5615,
			x = 6209,
			z = 7
		}
	},
	{
		name = "Darzuac",
		pos = {
			y = 5700,
			x = 5540,
			z = 7
		}
	},
	{
		name = "Dras Ashar",
		wordBreaks = {
			1
		},
		pos = {
			y = 5686,
			x = 6332,
			z = 7
		}
	},
	{
		name = "Shellshore Cove",
		maxLevel = 80,
		minLevel = 47,
		wordBreaks = {
			1
		},
		pos = {
			y = 5452,
			x = 4231,
			z = 7
		}
	},
	{
		name = "Addler's Nest",
		maxLevel = 48,
		minLevel = 47,
		wordBreaks = {
			1
		},
		pos = {
			y = 5476,
			x = 4145,
			z = 7
		}
	},
	{
		name = "Abandoned Mines",
		maxLevel = 73,
		minLevel = 49,
		wordBreaks = {
			1
		},
		pos = {
			y = 5529,
			x = 4081,
			z = 7
		}
	},
	{
		name = "The Flooded Maw",
		maxLevel = 49,
		minLevel = 47,
		wordBreaks = {
			1,
			2
		},
		pos = {
			y = 5617,
			x = 4271,
			z = 7
		}
	},
	{
		name = "Mossgrove Terrace",
		maxLevel = 49,
		minLevel = 47,
		wordBreaks = {
			1
		},
		pos = {
			y = 5568,
			x = 4374,
			z = 7
		}
	},
	{
		name = "Ruins of Gilead",
		maxLevel = 82,
		minLevel = 47,
		wordBreaks = {
			2
		},
		pos = {
			y = 5717,
			x = 4324,
			z = 7
		}
	},
	{
		name = "Sunchase Plateau",
		maxLevel = 52,
		minLevel = 48,
		wordBreaks = {
			1
		},
		pos = {
			y = 5669,
			x = 4078,
			z = 7
		}
	},
	{
		name = "Fernscale Thicket",
		maxLevel = 51,
		minLevel = 48,
		wordBreaks = {
			1
		},
		pos = {
			y = 5722,
			x = 4015,
			z = 7
		}
	},
	{
		name = "Mycelium Marsh",
		maxLevel = 50,
		minLevel = 48,
		wordBreaks = {
			1
		},
		pos = {
			y = 5742,
			x = 4094,
			z = 7
		}
	},
	{
		name = "Reptile's Enclave",
		maxLevel = 60,
		minLevel = 57,
		wordBreaks = {
			1
		},
		pos = {
			y = 5767,
			x = 4179,
			z = 7
		}
	},
	{
		name = "Ancient Ruins",
		maxLevel = 79,
		minLevel = 47,
		wordBreaks = {
			1
		},
		pos = {
			y = 5818,
			x = 4272,
			z = 7
		}
	},
	{
		name = "Gilead",
		pos = {
			y = 5867,
			x = 4336,
			z = 7
		}
	},
	{
		name = "Rumalos",
		pos = {
			y = 5608,
			x = 3984,
			z = 7
		}
	},
	{
		name = "Hogula",
		pos = {
			y = 5492,
			x = 4268,
			z = 7
		}
	},
	{
		name = "Sombershade",
		maxLevel = 47,
		minLevel = 45,
		pos = {
			y = 4849,
			x = 5378,
			z = 7
		}
	},
	{
		name = "Twilight Pass",
		maxLevel = 47,
		minLevel = 45,
		pos = {
			y = 4883,
			x = 5398,
			z = 7
		}
	},
	{
		name = "Stormcoast Ruins",
		maxLevel = 54,
		minLevel = 50,
		wordBreaks = {
			1
		},
		pos = {
			y = 4917,
			x = 5518,
			z = 7
		}
	},
	{
		name = "Greypike Castle",
		maxLevel = 56,
		minLevel = 48,
		wordBreaks = {
			1
		},
		pos = {
			y = 4742,
			x = 5415,
			z = 7
		}
	},
	{
		name = "Forgotten Graveyard",
		maxLevel = 54,
		minLevel = 50,
		wordBreaks = {
			1
		},
		pos = {
			y = 4758,
			x = 5484,
			z = 7
		}
	},
	{
		name = "Fangwatch",
		pos = {
			y = 4849,
			x = 5483,
			z = 7
		}
	},
	{
		name = "Deathold",
		maxLevel = 60,
		minLevel = 56,
		pos = {
			y = 5002,
			x = 5489,
			z = 7
		}
	},
	{
		name = "Horror's Nest",
		maxLevel = 52,
		minLevel = 50,
		wordBreaks = {
			1
		},
		pos = {
			y = 4980,
			x = 5555,
			z = 7
		}
	},
	{
		name = "Whispering Thicket",
		maxLevel = 49,
		minLevel = 47,
		wordBreaks = {
			1
		},
		pos = {
			y = 4912,
			x = 5590,
			z = 7
		}
	},
	{
		name = "Wraithveil Hollows",
		maxLevel = 62,
		minLevel = 57,
		wordBreaks = {
			1
		},
		pos = {
			y = 4829,
			x = 5644,
			z = 7
		}
	},
	{
		name = "Dreadmist Hollows",
		maxLevel = 62,
		minLevel = 56,
		wordBreaks = {
			1
		},
		pos = {
			y = 4790,
			x = 5738,
			z = 7
		}
	},
	{
		name = "Bogheart",
		maxLevel = 53,
		minLevel = 49,
		pos = {
			y = 4836,
			x = 5823,
			z = 7
		}
	},
	{
		name = "Blightwhiskers Warrens",
		maxLevel = 52,
		minLevel = 49,
		wordBreaks = {
			1
		},
		pos = {
			y = 4777,
			x = 5830,
			z = 7
		}
	},
	{
		name = "Crowhollow Bog",
		maxLevel = 51,
		minLevel = 48,
		wordBreaks = {
			1
		},
		pos = {
			y = 4893,
			x = 5705,
			z = 7
		}
	},
	{
		name = "Weeping Cavern",
		maxLevel = 83,
		minLevel = 64,
		wordBreaks = {
			1
		},
		pos = {
			y = 4907,
			x = 5827,
			z = 7
		}
	},
	{
		name = "Woodhaven",
		pos = {
			y = 4955,
			x = 5702,
			z = 7
		}
	},
	{
		name = "Sovereign's Crown",
		maxLevel = 74,
		minLevel = 67,
		wordBreaks = {
			1
		},
		pos = {
			y = 4649,
			x = 5504,
			z = 7
		}
	},
	{
		name = "Horncrest Knolls",
		maxLevel = 56,
		minLevel = 54,
		pos = {
			y = 4487,
			x = 5542,
			z = 7
		}
	},
	{
		name = "Bleak Hill",
		maxLevel = 54,
		minLevel = 52,
		wordBreaks = {
			1
		},
		pos = {
			y = 4560,
			x = 5658,
			z = 7
		}
	},
	{
		name = "The Burrows",
		maxLevel = 57,
		minLevel = 54,
		wordBreaks = {
			1
		},
		pos = {
			y = 4503,
			x = 5733,
			z = 7
		}
	},
	{
		name = "Ananda's Fall",
		maxLevel = 57,
		minLevel = 53,
		pos = {
			y = 4592,
			x = 5783,
			z = 7
		}
	},
	{
		name = "Fiend's Eye",
		maxLevel = 53,
		minLevel = 51,
		wordBreaks = {
			1
		},
		pos = {
			y = 4459,
			x = 5770,
			z = 7
		}
	},
	{
		name = "Twisted Steps",
		maxLevel = 57,
		minLevel = 54,
		wordBreaks = {
			1
		},
		pos = {
			y = 4469,
			x = 5859,
			z = 7
		}
	},
	{
		name = "Scarred Vale",
		maxLevel = 55,
		minLevel = 51,
		pos = {
			y = 4538,
			x = 5839,
			z = 7
		}
	},
	{
		name = "Master's Overlook",
		maxLevel = 62,
		minLevel = 59,
		wordBreaks = {
			1
		},
		pos = {
			y = 4589,
			x = 5979,
			z = 7
		}
	},
	{
		name = "Hope's Leap",
		maxLevel = 58,
		minLevel = 55,
		wordBreaks = {
			1
		},
		pos = {
			y = 4385,
			x = 5948,
			z = 7
		}
	},
	{
		name = "Skorn's Desolation",
		maxLevel = 82,
		minLevel = 55,
		wordBreaks = {
			1
		},
		pos = {
			y = 4484,
			x = 6021,
			z = 7
		}
	},
	{
		name = "Castle of Skorn",
		maxLevel = 85,
		minLevel = 56,
		wordBreaks = {
			2
		},
		pos = {
			y = 4511,
			x = 6089,
			z = 7
		}
	},
	{
		name = "Forsaken Wharf",
		wordBreaks = {
			1
		},
		pos = {
			y = 4619,
			x = 5884,
			z = 7
		}
	},
	{
		name = "Hag's Folly",
		maxLevel = 75,
		minLevel = 72,
		wordBreaks = {
			1
		},
		pos = {
			y = 4694,
			x = 5982,
			z = 7
		}
	},
	{
		name = "Festering Wetlands",
		maxLevel = 83,
		minLevel = 74,
		wordBreaks = {
			1
		},
		pos = {
			y = 4740,
			x = 5965,
			z = 7
		}
	},
	{
		name = "Fort Mosshold",
		maxLevel = 76,
		minLevel = 74,
		wordBreaks = {
			1
		},
		pos = {
			y = 4798,
			x = 5995,
			z = 7
		}
	},
	{
		name = "Ruins of Greenburg",
		maxLevel = 75,
		minLevel = 73,
		wordBreaks = {
			2
		},
		pos = {
			y = 4754,
			x = 6030,
			z = 7
		}
	},
	{
		name = "The Plagued Hill",
		maxLevel = 76,
		minLevel = 74,
		wordBreaks = {
			2
		},
		pos = {
			y = 4694,
			x = 6088,
			z = 7
		}
	},
	{
		name = "Castle Thergard",
		maxLevel = 80,
		minLevel = 74,
		wordBreaks = {
			1
		},
		pos = {
			y = 4308,
			x = 4837,
			z = 7
		}
	},
	{
		name = "Okkar Hills",
		maxLevel = 75,
		minLevel = 72,
		pos = {
			y = 4137,
			x = 4803,
			z = 7
		}
	},
	{
		name = "Deadbane Halls",
		maxLevel = 82,
		minLevel = 70,
		wordBreaks = {
			1
		},
		pos = {
			y = 4236,
			x = 4698,
			z = 7
		}
	},
	{
		name = "Frozen Crypts",
		maxLevel = 59,
		minLevel = 56,
		wordBreaks = {
			1
		},
		pos = {
			y = 4317,
			x = 4581,
			z = 7
		}
	},
	{
		name = "Howling Hills",
		maxLevel = 72,
		minLevel = 49,
		wordBreaks = {
			1
		},
		pos = {
			y = 4158,
			x = 4485,
			z = 7
		}
	},
	{
		name = "Chattering Mounds",
		maxLevel = 50,
		minLevel = 47,
		wordBreaks = {
			1
		},
		pos = {
			y = 4296,
			x = 4482,
			z = 7
		}
	},
	{
		name = "Frostclaw Cliff",
		maxLevel = 71,
		minLevel = 68,
		wordBreaks = {
			1
		},
		pos = {
			y = 4152,
			x = 4375,
			z = 7
		}
	},
	{
		name = "Snowdeep Mines",
		maxLevel = 53,
		minLevel = 47,
		wordBreaks = {
			1
		},
		pos = {
			y = 4236,
			x = 4392,
			z = 7
		}
	},
	{
		name = "Darkhollow Ruins",
		maxLevel = 50,
		minLevel = 47,
		wordBreaks = {
			1
		},
		pos = {
			y = 4396,
			x = 4440,
			z = 7
		}
	},
	{
		name = "Shrieking Pass",
		maxLevel = 51,
		minLevel = 47,
		wordBreaks = {
			1
		},
		pos = {
			y = 4419,
			x = 4375,
			z = 7
		}
	},
	{
		name = "Snowfall Outpost",
		maxLevel = 52,
		minLevel = 49,
		wordBreaks = {
			1
		},
		pos = {
			y = 4401,
			x = 4252,
			z = 7
		}
	},
	{
		name = "Chillpike Maws",
		maxLevel = 52,
		minLevel = 49,
		pos = {
			y = 4475,
			x = 4236,
			z = 7
		}
	},
	{
		name = "Umberfrost Gorge",
		maxLevel = 53,
		minLevel = 49,
		wordBreaks = {
			1
		},
		pos = {
			y = 4371,
			x = 4148,
			z = 7
		}
	},
	{
		name = "Blizzard's Nest",
		maxLevel = 55,
		minLevel = 51,
		wordBreaks = {
			1
		},
		pos = {
			y = 4285,
			x = 4176,
			z = 7
		}
	},
	{
		name = "The Perishing Pass",
		maxLevel = 68,
		minLevel = 64,
		pos = {
			y = 4091,
			x = 4270,
			z = 7
		}
	},
	{
		name = "Chillmane Crag",
		maxLevel = 62,
		minLevel = 58,
		wordBreaks = {
			1
		},
		pos = {
			y = 4000,
			x = 4289,
			z = 7
		}
	},
	{
		name = "Matchwood",
		maxLevel = 84,
		minLevel = 45,
		pos = {
			y = 4492,
			x = 4396,
			z = 7
		}
	},
	{
		name = "Vikkar Bay",
		wordBreaks = {
			1
		},
		pos = {
			y = 4358,
			x = 4616,
			z = 7
		}
	},
	{
		name = "Newvik",
		pos = {
			y = 4279,
			x = 4306,
			z = 7
		}
	},
	{
		name = "Wolfhold",
		pos = {
			y = 4421,
			x = 4201,
			z = 7
		}
	},
	{
		name = "Far Naddod",
		wordBreaks = {
			1
		},
		pos = {
			y = 4110,
			x = 4603,
			z = 7
		}
	},
	{
		name = "Saint Alsek",
		wordBreaks = {
			1
		},
		pos = {
			y = 4179,
			x = 4130,
			z = 7
		}
	},
	{
		name = "Thormarok Mountain",
		maxLevel = 64,
		minLevel = 55,
		wordBreaks = {
			1
		},
		pos = {
			y = 4610,
			x = 5342,
			z = 7
		}
	},
	{
		name = "Cragspear",
		maxLevel = 59,
		minLevel = 53,
		pos = {
			y = 4702,
			x = 5300,
			z = 7
		}
	},
	{
		name = "Gloomwood",
		maxLevel = 65,
		minLevel = 57,
		pos = {
			y = 4630,
			x = 5127,
			z = 7
		}
	},
	{
		name = "Thickbark Grove",
		maxLevel = 71,
		minLevel = 55,
		wordBreaks = {
			1
		},
		pos = {
			y = 4678,
			x = 5140,
			z = 7
		}
	},
	{
		name = "Crowfell",
		maxLevel = 76,
		minLevel = 72,
		pos = {
			y = 4526,
			x = 5033,
			z = 7
		}
	},
	{
		name = "Ellesset",
		pos = {
			y = 4592,
			x = 5092,
			z = 7
		}
	},
	{
		name = "Envoy's Rest",
		wordBreaks = {
			1
		},
		pos = {
			y = 4638,
			x = 5285,
			z = 7
		}
	},
	{
		name = "Coldstring Burrows",
		maxLevel = 75,
		minLevel = 68,
		wordBreaks = {
			1
		},
		pos = {
			y = 4392,
			x = 5214,
			z = 7
		}
	},
	{
		name = "Albino Forest",
		maxLevel = 73,
		minLevel = 69,
		wordBreaks = {
			1
		},
		pos = {
			y = 4119,
			x = 5186,
			z = 7
		}
	},
	{
		name = "Yorn'omaala",
		maxLevel = 70,
		minLevel = 67,
		pos = {
			y = 4213,
			x = 5304,
			z = 7
		}
	},
	{
		name = "Frosthenge",
		maxLevel = 68,
		minLevel = 65,
		pos = {
			y = 4295,
			x = 5507,
			z = 7
		}
	},
	{
		name = "Wintry Plains",
		maxLevel = 62,
		minLevel = 59,
		pos = {
			y = 4373,
			x = 5498,
			z = 7
		}
	},
	{
		name = "Ito'yami",
		maxLevel = 66,
		minLevel = 64,
		pos = {
			y = 4252,
			x = 5754,
			z = 7
		}
	},
	{
		name = "The Fingers",
		maxLevel = 73,
		minLevel = 70,
		pos = {
			y = 4117,
			x = 5751,
			z = 7
		}
	},
	{
		name = "Titan Claws",
		maxLevel = 85,
		minLevel = 74,
		wordBreaks = {
			1
		},
		pos = {
			y = 3977,
			x = 5805,
			z = 7
		}
	},
	{
		name = "Dimlight Camps",
		maxLevel = 67,
		minLevel = 64,
		wordBreaks = {
			1
		},
		pos = {
			y = 4102,
			x = 6035,
			z = 7
		}
	},
	{
		name = "Wild Tundra",
		maxLevel = 69,
		minLevel = 67,
		pos = {
			y = 4330,
			x = 5255,
			z = 7
		}
	},
	{
		name = "Icesteps",
		maxLevel = 68,
		minLevel = 66,
		pos = {
			y = 4245,
			x = 5471,
			z = 7
		}
	},
	{
		name = "Hunting Marches",
		maxLevel = 62,
		minLevel = 60,
		wordBreaks = {
			1
		},
		pos = {
			y = 4304,
			x = 5603,
			z = 7
		}
	},
	{
		name = "Kari'vir",
		pos = {
			y = 4137,
			x = 5961,
			z = 7
		}
	}
}
FISHFIGHT_STATE_NORMAL = 0
FISHFIGHT_STATE_AGGRESSIVE = 1
FISHFIGHT_STATE_TIRED = 2
FISHFIGHT_STATE_TIRED_2 = 3
FISHFIGHT_STATE_TIRED_3 = 4
FISHFIGHT_STATE_TIRED_4 = 5
FISHFIGHT_STATE_TIRED_5 = 6
FISHFIGHT_STATE_LAST = FISHFIGHT_STATE_TIRED_5
FARM_TILE_ITEM = 34099
FARM_BLOCKING_ITEM = 30278
TileType = {
	Room = 3,
	RoomEmpty = 2,
	None = 0,
	CommunityPlot = 6,
	House = 1,
	GuildPlot = 5,
	LandPlot = 4
}
HOUSE_MODELS = {
	SMALL = {
		WOODEN_HOUSE = 3,
		WOODEN_CABIN = 2,
		SHACK = 1
	},
	MEDIUM = {
		WOODEN_HOUSE = 6,
		WOODEN_CABIN = 5,
		SHACK = 4,
		STONE_HOUSE = 7
	},
	LARGE = {
		WOODEN_HOUSE = 10,
		WOODEN_CABIN = 9,
		SHACK = 8,
		STONE_MANSION = 12,
		STONE_HOUSE = 11
	},
	STRONGHOLD = {
		SHACK = 13,
		STONE = 15,
		WOOD = 14
	},
	FORT = {
		DARKWOOD = 19,
		STONE = 16,
		WOOD = 17,
		SANDSTONE = 18
	}
}
HouseModels = {
	MediumWoodenCabin = 5,
	MediumShack = 4,
	SmallWoodenHouse = 3,
	SmallWoodenCabin = 2,
	SmallShack = 1,
	FortDarkWood = 19,
	FortSandStone = 18,
	FortWood = 17,
	FortStone = 16,
	StrongholdStone = 15,
	StrongholdWood = 14,
	StrongholdShack = 13,
	LargeStoneMansion = 12,
	LargeStoneHouse = 11,
	LargeWoodenHouse = 10,
	LargeWoodenCabin = 9,
	LargeShack = 8,
	MediumStoneHouse = 7,
	MediumWoodenHouse = 6
}
HouseModelsBySize = {
	[10] = HouseModels.SmallShack,
	[12] = HouseModels.MediumShack,
	[15] = HouseModels.LargeShack,
	[22] = HouseModels.StrongholdShack,
	[30] = HouseModels.FortStone
}
ContextMenuActionId = {
	[10003] = {
		quest = "The Perils of Rohna Woods",
		text = "Search the pile of trash"
	},
	[10020] = {
		quest = "The Mountain King",
		text = "Search the rubbish pile"
	},
	[10254] = {
		quest = "Bloodsport",
		text = "Search crate"
	},
	[10255] = {
		quest = "Bloodsport",
		text = "Search crate"
	},
	[10250] = {
		quest = "Feeding the Troll",
		text = "Deliver rations"
	},
	[10256] = {
		quest = "Feeding the Troll",
		text = "Deliver rations"
	},
	[10038] = {
		quest = "Merchant's Misfortune",
		text = "Recover wood"
	},
	[10225] = {
		quest = "The Long Road Home",
		text = "Gather Flower"
	},
	[10259] = {
		quest = "The Long Road Home",
		text = "Pick up the trash"
	},
	[10219] = {
		quest = "Under the Sands of Time",
		text = "Open the chest"
	},
	[10569] = {
		quest = "Under the Sands of Time",
		text = "Open the chest"
	},
	[10030] = {
		quest = "Sugarcane Infestation",
		text = "Place Scarecrow"
	},
	[10183] = {
		quest = "Hunting Zedeno",
		text = "Search the rubbish"
	},
	[10184] = {
		quest = "Hunting Zedeno",
		text = "Search the rubbish"
	},
	[10185] = {
		quest = "Hunting Zedeno",
		text = "Search the rubbish"
	},
	[10022] = {
		quest = "The Cursed Crew",
		text = "Dig Up the Possessed Doll"
	},
	[10136] = {
		quest = "A Most Wondrous Cloak",
		text = "Search the furniture"
	}
}
ContextMenuUniqueId = {
	[10063] = {
		quest = "The Rites of Skorn",
		text = "Recover bone"
	},
	[10079] = {
		quest = "The Mountain King",
		text = "Search the rubbise pile"
	},
	[10086] = {
		quest = "A Goblin Obsession",
		text = "Recover the bones"
	}
}
QuestItemsActionId = {
	[10373] = {
		mapReward = true
	},
	[10559] = {
		event = "Drunken Ritual",
		always = true
	},
	[10560] = {
		always = true,
		event = "Drunken Ritual",
		itemId = {
			1638,
			1640
		}
	},
	[10188] = {
		afterComplete = true,
		quest = "Running Out Of Stock",
		taskId = {
			2,
			3,
			4,
			5,
			6
		}
	},
	[10004] = {
		afterComplete = true,
		quest = "Raiding the Raiders",
		taskId = {
			11,
			12,
			13,
			14,
			15,
			16
		}
	},
	[10202] = {
		taskId = 1,
		quest = "A Merchant and His Bellyache"
	},
	[10001] = {
		taskId = 8,
		quest = "Cult of the Arrow"
	},
	[10002] = {
		taskId = 14,
		quest = "Cult of the Arrow"
	},
	[10000] = {
		taskId = 4,
		quest = "Mixed Bloodlines"
	},
	[10193] = {
		taskId = 3,
		quest = "Mortal Enemies"
	},
	[10194] = {
		taskId = 3,
		quest = "Mortal Enemies"
	},
	[10195] = {
		taskId = 3,
		quest = "Mortal Enemies"
	},
	[10196] = {
		taskId = 3,
		quest = "Mortal Enemies"
	},
	[10197] = {
		taskId = 3,
		quest = "Mortal Enemies"
	},
	[10198] = {
		taskId = 3,
		quest = "Mortal Enemies"
	},
	[10199] = {
		taskId = 3,
		quest = "Mortal Enemies"
	},
	[10200] = {
		taskId = 3,
		quest = "Mortal Enemies"
	},
	[10234] = {
		taskId = 4,
		quest = "Mortal Enemies"
	},
	[10235] = {
		taskId = 4,
		quest = "Mortal Enemies"
	},
	[10236] = {
		taskId = 4,
		quest = "Mortal Enemies"
	},
	[10237] = {
		taskId = 4,
		quest = "Mortal Enemies"
	},
	[10238] = {
		taskId = 4,
		quest = "Mortal Enemies"
	},
	[10239] = {
		taskId = 4,
		quest = "Mortal Enemies"
	},
	[10240] = {
		taskId = 4,
		quest = "Mortal Enemies"
	},
	[10241] = {
		taskId = 4,
		quest = "Mortal Enemies"
	},
	[10242] = {
		taskId = 4,
		quest = "Mortal Enemies"
	},
	[10243] = {
		taskId = 4,
		quest = "Mortal Enemies"
	},
	[10244] = {
		taskId = 4,
		quest = "Mortal Enemies"
	},
	[10245] = {
		taskId = 4,
		quest = "Mortal Enemies"
	},
	[10246] = {
		taskId = 4,
		quest = "Mortal Enemies"
	},
	[10247] = {
		taskId = 4,
		quest = "Mortal Enemies"
	},
	[10248] = {
		taskId = 4,
		quest = "Mortal Enemies"
	},
	[10009] = {
		quest = "Mortal Enemies",
		taskId = {
			6,
			7
		}
	},
	[10003] = {
		taskId = 1,
		quest = "The Perils of Rohna Woods"
	},
	[10008] = {
		taskId = 6,
		quest = "The Perils of Rohna Woods"
	},
	[10345] = {
		taskId = 3,
		quest = "Unpaid Dues"
	},
	[10346] = {
		afterComplete = true,
		quest = "Unpaid Dues",
		taskId = {
			1,
			2,
			3,
			4
		}
	},
	[10265] = {
		taskId = 5,
		quest = "Missing in Action"
	},
	[10111] = {
		taskId = 5,
		quest = "Swamp Fever"
	},
	[10112] = {
		taskId = 5,
		quest = "Swamp Fever"
	},
	[10113] = {
		taskId = 5,
		quest = "Swamp Fever"
	},
	[10114] = {
		taskId = 5,
		quest = "Swamp Fever"
	},
	[10115] = {
		taskId = 5,
		quest = "Swamp Fever"
	},
	[10116] = {
		taskId = 5,
		quest = "Swamp Fever"
	},
	[10117] = {
		taskId = 5,
		quest = "Swamp Fever"
	},
	[10007] = {
		taskId = 7,
		quest = "Swamp Fever"
	},
	[10055] = {
		taskId = 9,
		quest = "Swamp Fever"
	},
	[10192] = {
		taskId = 11,
		quest = "Swamp Fever"
	},
	[10266] = {
		taskId = 3,
		quest = "The Best Antidote"
	},
	[10502] = {
		taskId = 9,
		quest = "The Best Antidote"
	},
	[10020] = {
		taskId = 2,
		quest = "The Mountain King"
	},
	[10142] = {
		taskId = 7,
		quest = "The Mountain King"
	},
	[10899] = {
		taskId = 5,
		quest = "The Tree of Life"
	},
	[10900] = {
		taskId = 5,
		quest = "The Tree of Life"
	},
	[10018] = {
		taskId = 8,
		quest = "The Tree of Life"
	},
	[10147] = {
		itemId = 1628,
		quest = "A Revenge For Old Debts",
		always = true
	},
	[10186] = {
		itemId = 1628,
		quest = "A Revenge For Old Debts",
		always = true
	},
	[10165] = {
		taskId = 6,
		quest = "A Revenge For Old Debts"
	},
	[10166] = {
		taskId = 6,
		quest = "A Revenge For Old Debts"
	},
	[10146] = {
		taskId = 6,
		quest = "A Revenge For Old Debts"
	},
	[10171] = {
		taskId = 13,
		quest = "A Revenge For Old Debts"
	},
	[10150] = {
		taskId = 14,
		quest = "A Revenge For Old Debts"
	},
	[10877] = {
		afterComplete = true,
		quest = "A Revenge For Old Debts",
		taskId = {
			17,
			18,
			19,
			20
		}
	},
	[10152] = {
		taskId = 19,
		quest = "A Revenge For Old Debts"
	},
	[10168] = {
		taskId = 4,
		quest = "High Class Hostages"
	},
	[10183] = {
		taskId = 3,
		quest = "Hunting Zedeno"
	},
	[10184] = {
		taskId = 3,
		quest = "Hunting Zedeno"
	},
	[10185] = {
		taskId = 3,
		quest = "Hunting Zedeno"
	},
	[10178] = {
		taskId = 1,
		quest = "Restoring the Natural Balance"
	},
	[10691] = {
		taskId = 3,
		quest = "Restoring the Natural Balance"
	},
	[10162] = {
		itemId = 34195,
		always = true,
		event = "Salt Water Pit"
	},
	[10163] = {
		event = "Salt Water Pit",
		taskId = 1
	},
	[10154] = {
		taskId = 8,
		quest = "Reviving The Glory Days"
	},
	[10029] = {
		taskId = 3,
		quest = "Sugarcane Infestation"
	},
	[10030] = {
		taskId = 9,
		quest = "Sugarcane Infestation"
	},
	[10155] = {
		afterComplete = true,
		quest = "The Lighthouse Mystery",
		taskId = {
			1,
			5,
			6,
			7,
			8,
			9,
			10,
			11,
			12
		}
	},
	[10174] = {
		taskId = 1,
		quest = "The Lighthouse Mystery"
	},
	[10156] = {
		taskId = 3,
		quest = "The Lighthouse Mystery"
	},
	[10160] = {
		taskId = 8,
		quest = "The Lighthouse Mystery"
	},
	[10191] = {
		afterComplete = true,
		quest = "The Lighthouse Mystery",
		taskId = {
			6,
			7,
			8,
			9,
			10,
			11,
			12
		}
	},
	[10254] = {
		taskId = 1,
		quest = "Bloodsport"
	},
	[10255] = {
		taskId = 1,
		quest = "Bloodsport"
	},
	[10211] = {
		taskId = 3,
		quest = "Bloodsport"
	},
	[10229] = {
		quest = "Clean Waters",
		taskId = {
			1,
			7
		}
	},
	[10230] = {
		quest = "Clean Waters",
		taskId = {
			1,
			7
		}
	},
	[10231] = {
		quest = "Clean Waters",
		taskId = {
			1,
			7
		}
	},
	[10232] = {
		quest = "Clean Waters",
		taskId = {
			1,
			7
		}
	},
	[10233] = {
		taskId = 5,
		quest = "Clean Waters"
	},
	[10250] = {
		taskId = 3,
		quest = "Feeding the Troll"
	},
	[10256] = {
		taskId = 3,
		quest = "Feeding the Troll"
	},
	[10251] = {
		taskId = 8,
		quest = "Feeding the Troll"
	},
	[10038] = {
		taskId = 2,
		quest = "Merchant's Misfortune"
	},
	[10040] = {
		taskId = 4,
		quest = "Merchant's Misfortune"
	},
	[10253] = {
		taskId = 6,
		quest = "Merchant's Misfortune"
	},
	[10039] = {
		taskId = 8,
		quest = "Merchant's Misfortune"
	},
	[10037] = {
		taskId = 1,
		quest = "The Long Road Home"
	},
	[10224] = {
		taskId = 3,
		quest = "The Long Road Home"
	},
	[10225] = {
		taskId = 5,
		quest = "The Long Road Home"
	},
	[10259] = {
		taskId = 7,
		quest = "The Long Road Home"
	},
	[10210] = {
		quest = "Tuskan Trashers",
		taskId = {
			7,
			10
		}
	},
	[10219] = {
		quest = "Under The Sands Of Time",
		taskId = {
			3,
			10
		}
	},
	[10569] = {
		taskId = 3,
		quest = "Under The Sands Of Time"
	},
	[10090] = {
		taskId = 6,
		quest = "Under The Sands Of Time"
	},
	[10091] = {
		taskId = 6,
		quest = "Under The Sands Of Time"
	},
	[10092] = {
		taskId = 6,
		quest = "Under The Sands Of Time"
	},
	[10093] = {
		taskId = 6,
		quest = "Under The Sands Of Time"
	},
	[10094] = {
		taskId = 6,
		quest = "Under The Sands Of Time"
	},
	[10095] = {
		taskId = 6,
		quest = "Under The Sands Of Time"
	},
	[10096] = {
		taskId = 6,
		quest = "Under The Sands Of Time"
	},
	[10097] = {
		taskId = 6,
		quest = "Under The Sands Of Time"
	},
	[10098] = {
		taskId = 6,
		quest = "Under The Sands Of Time"
	},
	[10099] = {
		taskId = 8,
		quest = "Under The Sands Of Time"
	},
	[10100] = {
		taskId = 8,
		quest = "Under The Sands Of Time"
	},
	[10218] = {
		taskId = 10,
		quest = "Under The Sands Of Time"
	},
	[10141] = {
		taskId = 17,
		quest = "Ghaz At The Gates"
	},
	[10173] = {
		taskId = 19,
		quest = "Ghaz At The Gates"
	},
	[10257] = {
		taskId = 19,
		quest = "Ghaz At The Gates"
	},
	[10947] = {
		always = true,
		quest = "Ghaz At The Gates"
	},
	[10228] = {
		taskId = 5,
		quest = "The Genie's Game"
	},
	[10281] = {
		event = "The Champion's Den",
		taskId = 2
	},
	[10312] = {
		itemId = 42004,
		always = true,
		event = "Tower of the Everliving"
	},
	[10313] = {
		itemId = 42004,
		always = true,
		event = "Tower of the Everliving"
	},
	[10314] = {
		itemId = 42004,
		always = true,
		event = "Tower of the Everliving"
	},
	[10315] = {
		itemId = 42004,
		always = true,
		event = "Tower of the Everliving"
	},
	[10328] = {
		itemId = 2114,
		always = true,
		event = "Tower of the Everliving"
	},
	[10753] = {
		itemId = 34820,
		always = true,
		event = "Tower of the Everliving"
	},
	[10260] = {
		event = "The Bone Carver",
		always = true
	},
	[10261] = {
		event = "She Sells Seashells",
		taskId = 1
	},
	[10085] = {
		taskId = 3,
		quest = "A Goblin Obsession"
	},
	[10086] = {
		quest = "A Goblin Obsession",
		taskId = {
			9,
			10,
			11,
			12,
			13
		}
	},
	[10032] = {
		afterComplete = true,
		quest = "A Goblin Obsession",
		taskId = {
			10,
			11,
			12,
			13
		}
	},
	[10854] = {
		afterComplete = true,
		quest = "A Goblin Obsession",
		taskId = {
			10,
			11,
			12,
			13
		}
	},
	[10135] = {
		taskId = 2,
		quest = "A Most Wondrous Cloak"
	},
	[10182] = {
		taskId = 9,
		quest = "A Most Wondrous Cloak"
	},
	[10136] = {
		taskId = 10,
		quest = "A Most Wondrous Cloak"
	},
	[10138] = {
		quest = "A Most Wondrous Cloak",
		taskId = {
			15,
			16
		}
	},
	[10871] = {
		quest = "A Most Wondrous Cloak",
		taskId = {
			15,
			16
		}
	},
	[10143] = {
		taskId = 6,
		quest = "The Reliant Shipwright"
	},
	[10144] = {
		taskId = 10,
		quest = "The Reliant Shipwright"
	},
	[10419] = {
		quest = "Night Sacrifice",
		taskId = {
			2,
			3,
			4,
			5
		}
	},
	[10420] = {
		quest = "The Hoarder's Stash",
		taskId = {
			0,
			1,
			2,
			3
		}
	},
	[10511] = {
		itemId = 38954,
		always = true,
		event = "Risky Business"
	},
	[10349] = {
		event = "Extremist Naturalists",
		notActive = true
	},
	[10777] = {
		event = "Gritty General",
		always = true
	},
	[10778] = {
		event = "Gritty General",
		notActive = true
	},
	[10515] = {
		quest = "Everlasting Freedom",
		taskId = {
			2,
			4
		}
	},
	[10522] = {
		taskId = 8,
		quest = "Everlasting Freedom"
	},
	[10525] = {
		taskId = 8,
		quest = "Everlasting Freedom"
	},
	[10526] = {
		taskId = 8,
		quest = "Everlasting Freedom"
	},
	[10527] = {
		taskId = 8,
		quest = "Everlasting Freedom"
	},
	[10530] = {
		always = true,
		quest = "Everlasting Freedom"
	},
	[10517] = {
		always = true,
		quest = "Everlasting Freedom"
	},
	[10518] = {
		always = true,
		quest = "Everlasting Freedom"
	},
	[10519] = {
		always = true,
		quest = "Everlasting Freedom"
	},
	[10520] = {
		always = true,
		quest = "Everlasting Freedom"
	},
	[10521] = {
		always = true,
		quest = "Everlasting Freedom"
	},
	[10531] = {
		always = true,
		quest = "Everlasting Freedom"
	},
	[10553] = {
		taskId = 3,
		quest = "A Recipe for Dissolution"
	},
	[10577] = {
		taskId = 9,
		quest = "A Recipe for Dissolution"
	},
	[10537] = {
		taskId = 14,
		quest = "A Recipe for Dissolution"
	},
	[10538] = {
		always = true,
		quest = "A Recipe for Dissolution"
	},
	[10576] = {
		always = true,
		quest = "A Recipe for Dissolution"
	},
	[10532] = {
		quest = "A Recipe for Dissolution",
		taskId = 7,
		itemId = {
			38924,
			38926
		}
	},
	[10654] = {
		event = "Defiance Calls for Aid!",
		taskId = 2
	},
	[10655] = {
		event = "Defiance Calls for Aid!",
		taskId = 3
	},
	[10656] = {
		event = "Defiance Calls for Aid!",
		taskId = 4
	},
	[10657] = {
		event = "Defiance Calls for Aid!",
		taskId = 5
	},
	[10692] = {
		event = "Tax Collection",
		notActive = true
	},
	[10671] = {
		itemId = 42751,
		always = true,
		event = "Just a Drop"
	},
	[10789] = {
		always = true,
		quest = "Into the Rising Sun"
	},
	[10794] = {
		taskId = 24,
		quest = "Into the Rising Sun"
	},
	[10795] = {
		always = true,
		quest = "Into the Rising Sun"
	},
	[10784] = {
		itemId = 2114,
		always = true,
		event = "When the Eastern Wind Blows"
	},
	[10785] = {
		itemId = 2114,
		always = true,
		event = "When the Eastern Wind Blows"
	},
	[10786] = {
		itemId = 2114,
		always = true,
		event = "When the Eastern Wind Blows"
	},
	[10787] = {
		itemId = 2114,
		always = true,
		event = "When the Eastern Wind Blows"
	},
	[10788] = {
		itemId = 2114,
		always = true,
		event = "When the Eastern Wind Blows"
	},
	[10223] = {
		quest = "The Disappearance of Lord Shopan",
		taskId = {
			8,
			9
		}
	},
	[10221] = {
		taskId = 2,
		quest = "The Disappearance of Lord Shopan"
	},
	[10022] = {
		taskId = 10,
		quest = "The Cursed Crew"
	},
	[10131] = {
		taskId = 3,
		quest = "Lords of Blood: Part I"
	},
	[10133] = {
		taskId = 4,
		quest = "Lords of Blood: Part II"
	},
	[10134] = {
		taskId = 4,
		quest = "Lords of Blood: Part II"
	},
	[10571] = {
		taskId = 2,
		quest = "Lords of Blood: Part III"
	},
	[10278] = {
		taskId = 3,
		quest = "Realm of the Red Council"
	},
	[10128] = {
		quest = "Realm of the Red Council",
		taskId = {
			5,
			6
		}
	},
	[10106] = {
		taskId = 1,
		quest = "The Guildmaster"
	},
	[10108] = {
		taskId = 3,
		quest = "The Guildmaster"
	},
	[10109] = {
		quest = "The Guildmaster",
		taskId = {
			4,
			13
		}
	},
	[10882] = {
		quest = "The Guildmaster",
		taskId = {
			5,
			6
		}
	},
	[10883] = {
		taskId = 7,
		quest = "The Guildmaster"
	},
	[10884] = {
		taskId = 7,
		quest = "The Guildmaster"
	},
	[10885] = {
		taskId = 7,
		quest = "The Guildmaster"
	},
	[10120] = {
		taskId = 10,
		quest = "The Guildmaster"
	},
	[10731] = {
		quest = "The Guildmaster",
		taskId = {
			11,
			12
		}
	},
	[10046] = {
		taskId = 4,
		quest = "The Relics of Whistler Lapland"
	},
	[10052] = {
		taskId = 1,
		quest = "The Slayer's Guild"
	},
	[10283] = {
		taskId = 3,
		quest = "The Slayer's Guild"
	},
	[10053] = {
		quest = "The Slayer's Guild",
		taskId = {
			5,
			6
		}
	},
	[10054] = {
		quest = "The Slayer's Guild",
		taskId = {
			5,
			6
		}
	},
	[10341] = {
		quest = "Whistler's Relics: The Stake",
		taskId = {
			1,
			2
		}
	},
	[10343] = {
		quest = "Whistler's Relics: The Stake",
		taskId = {
			1,
			3
		}
	},
	[10047] = {
		quest = "Whistler's Relics: The Ring",
		taskId = {
			3,
			4
		}
	},
	[10048] = {
		taskId = 3,
		quest = "Whistler's Relics: The Ring"
	},
	[10049] = {
		taskId = 3,
		quest = "Whistler's Relics: The Ring"
	},
	[10050] = {
		taskId = 3,
		quest = "Whistler's Relics: The Ring"
	},
	[10051] = {
		taskId = 3,
		quest = "Whistler's Relics: The Ring"
	},
	[10043] = {
		taskId = 2,
		quest = "Legend Of The Dragonforge"
	},
	[10285] = {
		taskId = 2,
		quest = "Legend Of The Dragonforge"
	},
	[10302] = {
		taskId = 10,
		quest = "Legend Of The Dragonforge"
	},
	[10262] = {
		event = "The Astronomer's Prediction",
		taskId = {
			1,
			2,
			3
		}
	},
	[10512] = {
		event = "Overrun Hideout",
		always = true
	},
	[10642] = {
		taskId = 2,
		quest = "Lords of Blood: Part III"
	},
	[10564] = {
		quest = "The Scent of Love",
		taskId = {
			3,
			5
		}
	},
	[10734] = {
		event = "Trench Warfare",
		taskId = 5
	},
	[10735] = {
		event = "Trench Warfare",
		taskId = 5
	},
	[10736] = {
		itemId = 34905,
		event = "Trench Warfare",
		taskId = 5
	},
	[10686] = {
		event = "Trench Warfare",
		taskId = 5
	},
	[10687] = {
		event = "Trench Warfare",
		taskId = 5
	},
	[10805] = {
		event = "A Sludging Mess",
		always = true
	},
	[10798] = {
		taskId = 10,
		quest = "Trials of the Dunes"
	},
	[10801] = {
		taskId = 20,
		quest = "Trials of the Dunes"
	},
	[10802] = {
		taskId = 20,
		quest = "Trials of the Dunes"
	},
	[10803] = {
		taskId = 20,
		quest = "Trials of the Dunes"
	},
	[10737] = {
		taskId = 5,
		quest = "Sands of Conquest"
	},
	[10738] = {
		taskId = 5,
		quest = "Sands of Conquest"
	},
	[10740] = {
		taskId = 8,
		quest = "Sands of Conquest"
	},
	[10741] = {
		taskId = 8,
		quest = "Sands of Conquest"
	},
	[10742] = {
		taskId = 12,
		quest = "Sands of Conquest"
	},
	[10743] = {
		taskId = 12,
		quest = "Sands of Conquest"
	},
	[10744] = {
		taskId = 12,
		quest = "Sands of Conquest"
	},
	[10808] = {
		taskId = 5,
		quest = "Veil of Scars"
	},
	[10832] = {
		taskId = 5,
		quest = "Veil of Scars"
	},
	[10809] = {
		taskId = 7,
		quest = "Veil of Scars"
	},
	[10810] = {
		taskId = 12,
		quest = "Veil of Scars"
	},
	[10811] = {
		taskId = 12,
		quest = "Veil of Scars"
	},
	[10812] = {
		event = "Unweaving Magic",
		taskId = 1
	},
	[10771] = {
		event = "In the Eye of the Storm",
		taskId = {
			1,
			3
		}
	},
	[10284] = {
		event = "Ancestral Feud",
		notActive = true
	},
	[10335] = {
		taskId = 1,
		quest = "Treasures From The Past"
	},
	[10340] = {
		taskId = 8,
		quest = "Banana Pirates"
	},
	[10330] = {
		quest = "Working Conditions",
		taskId = {
			1,
			2,
			3,
			4,
			5,
			6
		}
	},
	[10351] = {
		taskId = 4,
		quest = "Creating Value"
	},
	[10352] = {
		taskId = 4,
		quest = "Creating Value"
	},
	[10353] = {
		taskId = 4,
		quest = "Creating Value"
	},
	[10354] = {
		taskId = 4,
		quest = "Creating Value"
	},
	[10355] = {
		taskId = 6,
		quest = "Creating Value"
	},
	[10356] = {
		taskId = 6,
		quest = "Creating Value"
	},
	[10336] = {
		quest = "Conditions And Results",
		taskId = {
			3,
			7
		}
	},
	[10337] = {
		quest = "Conditions And Results",
		taskId = {
			3,
			7
		}
	},
	[10338] = {
		quest = "Conditions And Results",
		taskId = {
			3,
			7
		}
	},
	[10274] = {
		quest = "Dreams and Reflections",
		taskId = {
			10,
			11
		}
	},
	[10282] = {
		quest = "Chaotically Brilliant",
		taskId = {
			9,
			10,
			11,
			12
		}
	},
	[10216] = {
		quest = "Chaotically Brilliant",
		taskId = {
			9,
			10,
			11
		}
	},
	[10286] = {
		taskId = 9,
		quest = "A New Reality"
	},
	[10287] = {
		taskId = 8,
		quest = "A New Reality"
	},
	[10583] = {
		quest = "A Cold Burial",
		taskId = {
			5,
			13
		}
	},
	[10582] = {
		taskId = 10,
		quest = "A Cold Burial"
	},
	[10584] = {
		taskId = 22,
		quest = "A Cold Burial"
	},
	[10585] = {
		taskId = 26,
		quest = "A Cold Burial"
	},
	[10474] = {
		event = "Tool Appropriation",
		taskId = 1
	},
	[10483] = {
		event = "Foreigner's Plague",
		taskId = {
			3,
			4,
			5,
			6,
			7,
			11
		}
	},
	[10484] = {
		event = "Foreigner's Plague",
		taskId = 3
	},
	[10485] = {
		event = "Foreigner's Plague",
		taskId = 4
	},
	[10486] = {
		event = "Foreigner's Plague",
		taskId = 5
	},
	[10476] = {
		event = "Foreigner's Plague",
		taskId = 6
	},
	[10477] = {
		itemId = 32087,
		event = "Foreigner's Plague",
		taskId = 7
	},
	[10478] = {
		event = "Foreigner's Plague",
		taskId = 7
	},
	[10479] = {
		event = "Foreigner's Plague",
		taskId = 10
	},
	[10480] = {
		event = "Foreigner's Plague",
		taskId = 11
	},
	[10469] = {
		quest = "Under the Halls' Shadows",
		taskId = {
			4,
			6
		}
	},
	[10481] = {
		event = "Undead Harvesting",
		taskId = {
			2,
			3,
			4,
			5
		}
	},
	[10506] = {
		event = "Ice Cold Enemies"
	},
	[10472] = {
		event = "Lady of the Snow",
		notActive = true
	},
	[10490] = {
		always = true,
		event = "Keepers of the Lamp",
		itemId = {
			8008,
			8009
		}
	},
	[10491] = {
		event = "Keepers of the Lamp",
		taskId = 2
	},
	[10640] = {
		always = true,
		quest = "A Tomb of Stone and Ice"
	},
	[10452] = {
		always = true,
		quest = "A Tomb of Stone and Ice"
	},
	[10456] = {
		quest = "A Tomb of Stone and Ice",
		taskId = {
			14,
			15
		}
	},
	[10699] = {
		itemId = 34905,
		quest = "A Tomb of Stone and Ice",
		always = true
	},
	[10700] = {
		itemId = 34905,
		quest = "A Tomb of Stone and Ice",
		always = true
	},
	[10701] = {
		itemId = 34905,
		quest = "A Tomb of Stone and Ice",
		always = true
	},
	[10702] = {
		itemId = 34905,
		quest = "A Tomb of Stone and Ice",
		always = true
	},
	[10703] = {
		itemId = 34905,
		quest = "A Tomb of Stone and Ice",
		always = true
	},
	[10704] = {
		itemId = 34905,
		quest = "A Tomb of Stone and Ice",
		always = true
	},
	[10705] = {
		itemId = 34905,
		quest = "A Tomb of Stone and Ice",
		always = true
	},
	[10706] = {
		itemId = 34905,
		quest = "A Tomb of Stone and Ice",
		always = true
	},
	[10707] = {
		itemId = 34905,
		quest = "A Tomb of Stone and Ice",
		always = true
	},
	[10710] = {
		itemId = 32321,
		event = "The Wizard Frozen in Time",
		notActive = true
	},
	[10713] = {
		itemId = 34905,
		event = "The Wizard Frozen in Time",
		taskId = 3
	},
	[10714] = {
		event = "The Wizard Frozen in Time",
		taskId = 3
	},
	[10471] = {
		taskId = 11,
		quest = "Missing Cargo"
	},
	[10494] = {
		quest = "Missing Cargo",
		taskId = {
			11,
			13
		}
	},
	[10541] = {
		taskId = 10,
		quest = "Welcome to the Bog"
	},
	[10542] = {
		taskId = 13,
		quest = "Welcome to the Bog"
	},
	[10554] = {
		taskId = 1,
		quest = "Green Sabbath"
	},
	[10555] = {
		taskId = 16,
		quest = "Green Sabbath"
	},
	[10596] = {
		always = true,
		quest = "Green Sabbath"
	},
	[10548] = {
		taskId = 21,
		quest = "Green Sabbath"
	},
	[10562] = {
		event = "Daughters of Slaughter I",
		hidden = true
	},
	[10563] = {
		event = "Daughters of Slaughter II",
		always = true
	},
	[10694] = {
		event = "Daughters of Slaughter III",
		always = true
	},
	[10853] = {
		event = "The Corvine Bride",
		always = true
	},
	[10602] = {
		taskId = 5,
		quest = "Shadows and Dead Trees"
	},
	[10717] = {
		afterComplete = true,
		quest = "Rotten Roots, Hollow Hearts",
		taskId = {
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
			17,
			18
		}
	},
	[10724] = {
		taskId = 9,
		quest = "Rotten Roots, Hollow Hearts"
	},
	[10726] = {
		quest = "Rotten Roots, Hollow Hearts",
		taskId = {
			11,
			14,
			16
		}
	},
	[10727] = {
		taskId = 13,
		quest = "Rotten Roots, Hollow Hearts"
	},
	[10729] = {
		afterComplete = true,
		quest = "Rotten Roots, Hollow Hearts",
		taskId = {
			17,
			18
		}
	},
	[10633] = {
		event = "Scales of Corruption",
		notActive = true,
		taskId = {
			1,
			2
		}
	},
	[10749] = {
		event = "Tainted Breed",
		taskId = 2
	},
	[10636] = {
		event = "The Caw of Yl'zogog",
		always = true
	},
	[10617] = {
		taskId = 10,
		quest = "A Feast for Crows"
	},
	[10618] = {
		taskId = 11,
		quest = "A Feast for Crows"
	},
	[10619] = {
		taskId = 11,
		quest = "A Feast for Crows"
	},
	[10620] = {
		taskId = 11,
		quest = "A Feast for Crows"
	},
	[10621] = {
		taskId = 13,
		quest = "A Feast for Crows"
	},
	[10622] = {
		quest = "A Feast for Crows",
		taskId = {
			15,
			16
		}
	},
	[10623] = {
		taskId = 16,
		quest = "A Feast for Crows"
	},
	[10624] = {
		always = true,
		quest = "A Feast for Crows"
	},
	[10625] = {
		taskId = 21,
		quest = "A Feast for Crows"
	},
	[10628] = {
		taskId = 25,
		quest = "A Feast for Crows"
	},
	[10630] = {
		afterComplete = true,
		quest = "A Feast for Crows",
		taskId = {
			30,
			31,
			32,
			33,
			34
		}
	},
	[10766] = {
		always = true,
		quest = "A Feast for Crows"
	},
	[10681] = {
		event = "Sealed Under the Dark",
		always = true
	},
	[10674] = {
		event = "Sealed Under the Dark",
		always = true
	},
	[10675] = {
		event = "Sealed Under the Dark",
		always = true
	},
	[10676] = {
		event = "Sealed Under the Dark",
		always = true
	},
	[10677] = {
		event = "Sealed Under the Dark",
		always = true
	},
	[10678] = {
		event = "Sealed Under the Dark",
		taskId = 1
	},
	[10680] = {
		event = "Sealed Under the Dark",
		taskId = 2
	},
	[10682] = {
		event = "Sealed Amidst the Fire",
		always = true
	},
	[10683] = {
		event = "Sealed Amidst the Fire",
		taskId = 1
	},
	[10684] = {
		event = "Sealed Amidst the Fire",
		taskId = 2
	},
	[10650] = {
		always = true,
		quest = "Raiders of the Wicked Seals"
	},
	[10659] = {
		taskId = 8,
		quest = "Raiders of the Wicked Seals"
	},
	[10774] = {
		taskId = 8,
		quest = "Raiders of the Wicked Seals"
	},
	[10775] = {
		taskId = 8,
		quest = "Raiders of the Wicked Seals"
	},
	[10652] = {
		itemId = 2114,
		quest = "Raiders of the Wicked Seals",
		taskId = 10
	},
	[10850] = {
		taskId = 11,
		quest = "Raiders of the Wicked Seals"
	},
	[10661] = {
		always = true,
		quest = "Raiders of the Wicked Seals"
	},
	[10757] = {
		always = true,
		quest = "Raiders of the Wicked Seals"
	},
	[10758] = {
		always = true,
		quest = "Raiders of the Wicked Seals"
	},
	[10837] = {
		always = true,
		quest = "Raiders of the Wicked Seals"
	},
	[10839] = {
		always = true,
		quest = "Raiders of the Wicked Seals"
	},
	[10840] = {
		always = true,
		quest = "Raiders of the Wicked Seals"
	},
	[10841] = {
		always = true,
		quest = "Raiders of the Wicked Seals"
	},
	[10842] = {
		always = true,
		quest = "Raiders of the Wicked Seals"
	},
	[10843] = {
		always = true,
		quest = "Raiders of the Wicked Seals"
	},
	[10844] = {
		always = true,
		quest = "Raiders of the Wicked Seals"
	},
	[10845] = {
		always = true,
		quest = "Raiders of the Wicked Seals"
	},
	[10846] = {
		always = true,
		quest = "Raiders of the Wicked Seals"
	},
	[10847] = {
		always = true,
		quest = "Raiders of the Wicked Seals"
	},
	[10849] = {
		always = true,
		quest = "Raiders of the Wicked Seals"
	},
	[10848] = {
		always = true,
		quest = "Raiders of the Wicked Seals"
	},
	[10759] = {
		itemId = 32328,
		quest = "Raiders of the Wicked Seals",
		always = true
	},
	[10838] = {
		event = "The Husk of Skorn",
		always = true
	},
	[10953] = {
		event = "Pieces on a Chessboard",
		always = true
	},
	[10954] = {
		event = "Pieces on a Chessboard",
		always = true
	},
	[10931] = {
		event = "Suffering from Heartburn",
		taskId = 4
	},
	[10804] = {
		always = true,
		artifactRegion = "Hadarak Desert"
	},
	[10828] = {
		artifactRegion = "Hadarak Desert",
		always = true,
		itemId = {
			39209,
			39210
		}
	},
	[10806] = {
		always = true,
		artifactRegion = "Zephyr Vale"
	},
	[10977] = {
		progress = 1,
		artifactRegion = "Deadlands"
	},
	[10982] = {
		always = true,
		artifactRegion = "Deadlands"
	}
}
QuestItemsUniqueId = {
	[10447] = {
		event = "Thirsty Bandits",
		always = true
	},
	[10008] = {
		taskId = 2,
		quest = "Bandit Breakdown"
	},
	[10024] = {
		quest = "Bandit Breakdown",
		taskId = {
			6,
			7,
			8
		}
	},
	[10009] = {
		taskId = 6,
		quest = "Cult of the Arrow"
	},
	[10011] = {
		taskId = 12,
		quest = "Cult of the Arrow"
	},
	[10065] = {
		quest = "Cult of the Arrow",
		taskId = {
			15,
			16
		}
	},
	[10007] = {
		taskId = 5,
		quest = "Mixed Bloodlines"
	},
	[10022] = {
		taskId = 7,
		quest = "Mixed Bloodlines"
	},
	[10053] = {
		taskId = 2,
		quest = "Raiding the Raiders"
	},
	[10162] = {
		quest = "Raiding the Raiders",
		taskId = {
			15,
			16
		}
	},
	[10048] = {
		taskId = 4,
		quest = "The Lighthouse Keeper"
	},
	[10020] = {
		quest = "The Perils of Rohna Woods",
		taskId = {
			4,
			5,
			6,
			7
		}
	},
	[10021] = {
		taskId = 4,
		quest = "The Perils of Rohna Woods"
	},
	[10136] = {
		taskId = 6,
		quest = "The Perils of Rohna Woods"
	},
	[10138] = {
		event = "The Dark Lighthouse",
		taskId = 1
	},
	[10139] = {
		event = "The Dark Lighthouse",
		taskId = 2
	},
	[10140] = {
		itemId = 2114,
		event = "Lit Beacons",
		notActive = true
	},
	[10141] = {
		itemId = 2114,
		event = "Lit Beacons",
		notActive = true
	},
	[10142] = {
		itemId = 2114,
		event = "Lit Beacons",
		notActive = true
	},
	[10054] = {
		taskId = 2,
		quest = "Missing in Action"
	},
	[10074] = {
		taskId = 9,
		quest = "Swamp Fever"
	},
	[10063] = {
		taskId = 9,
		quest = "The Rites of Skorn"
	},
	[10064] = {
		taskId = 13,
		quest = "The Rites of Skorn"
	},
	[10079] = {
		taskId = 2,
		quest = "The Mountain King"
	},
	[10080] = {
		quest = "The Mountain King",
		taskId = {
			5,
			8,
			11,
			12
		}
	},
	[10075] = {
		quest = "The Tree of Life",
		taskId = {
			1,
			6,
			10
		}
	},
	[10001] = {
		always = true,
		quest = "A Revenge For Old Debts"
	},
	[10002] = {
		always = true,
		quest = "A Revenge For Old Debts"
	},
	[10004] = {
		always = true,
		quest = "A Revenge For Old Debts"
	},
	[10168] = {
		always = true,
		quest = "A Revenge For Old Debts"
	},
	[10169] = {
		always = true,
		quest = "A Revenge For Old Debts"
	},
	[10171] = {
		itemId = 33924,
		quest = "A Revenge For Old Debts",
		taskId = 12
	},
	[10084] = {
		taskId = 4,
		quest = "High Class Hostages"
	},
	[10181] = {
		quest = "High Class Hostages",
		taskId = {
			7,
			18,
			19
		}
	},
	[10082] = {
		taskId = 5,
		quest = "Hunting Zedeno"
	},
	[10281] = {
		itemId = 1912,
		event = "Horn of Rage",
		notActive = true
	},
	[10081] = {
		taskId = 7,
		quest = "The Cursed Crew"
	},
	[10088] = {
		taskId = 1,
		quest = "The Long Road Home"
	},
	[10089] = {
		taskId = 3,
		quest = "The Long Road Home"
	},
	[10091] = {
		taskId = 7,
		quest = "The Long Road Home"
	},
	[10166] = {
		taskId = 1,
		quest = "Tuskan Trashers"
	},
	[10193] = {
		taskId = 3,
		quest = "Under The Sands Of Time"
	},
	[10143] = {
		taskId = 14,
		quest = "Under The Sands Of Time"
	},
	[10115] = {
		quest = "Ghaz At The Gates",
		taskId = {
			16,
			17,
			18,
			19
		}
	},
	[10117] = {
		quest = "Ghaz At The Gates",
		taskId = {
			18,
			19
		}
	},
	[10127] = {
		quest = "The Genie's Game",
		taskId = {
			7,
			8,
			9
		}
	},
	[10451] = {
		taskId = 5,
		quest = "Trials of the Dunes"
	},
	[10453] = {
		taskId = 7,
		quest = "Trials of the Dunes"
	},
	[10454] = {
		taskId = 16,
		quest = "Trials of the Dunes"
	},
	[10456] = {
		event = "The Colossus of Quorras",
		notActive = true
	},
	[10457] = {
		event = "Clash of the Elements",
		notActive = true
	},
	[10458] = {
		event = "In the Eye of the Storm",
		always = true
	},
	[10085] = {
		taskId = 3,
		quest = "A Goblin Obsession"
	},
	[10086] = {
		taskId = 12,
		quest = "A Goblin Obsession"
	},
	[10421] = {
		itemId = 34905,
		taskId = 1,
		event = "Tower of the Everliving"
	},
	[10422] = {
		itemId = 34905,
		taskId = 1,
		event = "Tower of the Everliving"
	},
	[10423] = {
		itemId = 34905,
		taskId = 1,
		event = "Tower of the Everliving"
	},
	[10424] = {
		itemId = 34905,
		taskId = 1,
		event = "Tower of the Everliving"
	},
	[10425] = {
		itemId = 34905,
		taskId = 1,
		event = "Tower of the Everliving"
	},
	[10426] = {
		itemId = 34905,
		taskId = 1,
		event = "Tower of the Everliving"
	},
	[10427] = {
		itemId = 34905,
		taskId = 1,
		event = "Tower of the Everliving"
	},
	[10428] = {
		itemId = 34905,
		taskId = 1,
		event = "Tower of the Everliving"
	},
	[10429] = {
		itemId = 34905,
		taskId = 1,
		event = "Tower of the Everliving"
	},
	[10196] = {
		taskId = 1,
		quest = "The Ipsy Dipsy Spider"
	},
	[10195] = {
		taskId = 5,
		quest = "The Ipsy Dipsy Spider"
	},
	[10188] = {
		taskId = 11,
		quest = "Treacherous Night"
	},
	[10189] = {
		taskId = 16,
		quest = "Treacherous Night"
	},
	[10194] = {
		taskId = 12,
		quest = "The Disappearance of Lord Shopan"
	},
	[10132] = {
		taskId = 5,
		quest = "Whistler's Relics: The Stake"
	},
	[10163] = {
		quest = "Lords of Blood: Part I",
		taskId = {
			4,
			5,
			6
		}
	},
	[10164] = {
		event = "A Bloody Reception",
		notActive = true
	},
	[10208] = {
		isActive = true,
		quest = "Lords of Blood: Part III",
		afterComplete = true
	},
	[10209] = {
		isActive = true,
		quest = "Lords of Blood: Part III",
		afterComplete = true
	},
	[10210] = {
		isActive = true,
		quest = "Lords of Blood: Part III",
		afterComplete = true
	},
	[10211] = {
		isActive = true,
		quest = "Lords of Blood: Part III",
		afterComplete = true
	},
	[10212] = {
		isActive = true,
		quest = "Lords of Blood: Part III",
		afterComplete = true
	},
	[10214] = {
		isActive = true,
		quest = "Lords of Blood: Part III",
		afterComplete = true
	},
	[10215] = {
		isActive = true,
		quest = "Lords of Blood: Part III",
		afterComplete = true
	},
	[10216] = {
		isActive = true,
		quest = "Lords of Blood: Part III",
		afterComplete = true
	},
	[10217] = {
		isActive = true,
		quest = "Lords of Blood: Part III",
		afterComplete = true
	},
	[10218] = {
		isActive = true,
		quest = "Lords of Blood: Part III",
		afterComplete = true
	},
	[10219] = {
		isActive = true,
		quest = "Lords of Blood: Part III",
		afterComplete = true
	},
	[10220] = {
		isActive = true,
		quest = "Lords of Blood: Part III",
		afterComplete = true
	},
	[10222] = {
		isActive = true,
		quest = "Lords of Blood: Part III",
		afterComplete = true
	},
	[10223] = {
		isActive = true,
		quest = "Lords of Blood: Part III",
		afterComplete = true
	},
	[10224] = {
		isActive = true,
		quest = "Lords of Blood: Part III",
		afterComplete = true
	},
	[10226] = {
		isActive = true,
		quest = "Lords of Blood: Part III",
		afterComplete = true
	},
	[10227] = {
		isActive = true,
		quest = "Lords of Blood: Part III",
		afterComplete = true
	},
	[10228] = {
		isActive = true,
		quest = "Lords of Blood: Part III",
		afterComplete = true
	},
	[10231] = {
		isActive = true,
		quest = "Lords of Blood: Part III",
		afterComplete = true
	},
	[10232] = {
		isActive = true,
		quest = "Lords of Blood: Part III",
		afterComplete = true
	},
	[10233] = {
		isActive = true,
		quest = "Lords of Blood: Part III",
		afterComplete = true
	},
	[10282] = {
		itemId = 38746,
		taskId = 1,
		event = "The Red Count",
		notActive = true
	},
	[10283] = {
		itemId = 38746,
		taskId = 1,
		event = "The Red Count",
		notActive = true
	},
	[10284] = {
		itemId = 38746,
		taskId = 1,
		event = "The Red Count",
		notActive = true
	},
	[10285] = {
		itemId = 38746,
		taskId = 1,
		event = "The Red Count",
		notActive = true
	},
	[10286] = {
		itemId = 38746,
		taskId = 1,
		event = "The Red Count",
		notActive = true
	},
	[10287] = {
		itemId = 38746,
		taskId = 1,
		event = "The Red Count",
		notActive = true
	},
	[10288] = {
		itemId = 38746,
		event = "The Red Count",
		taskId = 2
	},
	[10149] = {
		taskId = 9,
		quest = "The Guildmaster"
	},
	[10131] = {
		quest = "Whistler's Relics: The Stake",
		taskId = {
			1,
			3
		}
	},
	[10199] = {
		taskId = 1,
		quest = "Dreams and Reflections"
	},
	[10201] = {
		taskId = 3,
		quest = "Dreams and Reflections"
	},
	[10182] = {
		taskId = 2,
		quest = "Squatter's Rights"
	},
	[10183] = {
		taskId = 2,
		quest = "Squatter's Rights"
	},
	[10184] = {
		taskId = 2,
		quest = "Squatter's Rights"
	},
	[10121] = {
		itemId = 34195,
		quest = "Legend Of The Dragonforge",
		afterComplete = true,
		taskId = {
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
			17,
			18,
			19
		}
	},
	[10204] = {
		taskId = 4,
		quest = "A New Reality"
	},
	[10431] = {
		always = true,
		quest = "Into the Rising Sun"
	},
	[10434] = {
		always = true,
		quest = "Into the Rising Sun"
	},
	[10436] = {
		always = true,
		quest = "Into the Rising Sun"
	},
	[10441] = {
		always = true,
		quest = "Into the Rising Sun"
	},
	[10438] = {
		taskId = 1,
		quest = "Into the Rising Sun"
	},
	[10432] = {
		taskId = 3,
		quest = "Into the Rising Sun"
	},
	[10433] = {
		taskId = 3,
		quest = "Into the Rising Sun"
	},
	[10435] = {
		taskId = 9,
		quest = "Into the Rising Sun"
	},
	[10437] = {
		taskId = 22,
		quest = "Into the Rising Sun"
	},
	[10440] = {
		taskId = 24,
		quest = "Into the Rising Sun"
	},
	[10234] = {
		taskId = 1,
		quest = "No Common Adventure"
	},
	[10235] = {
		taskId = 1,
		quest = "No Common Adventure"
	},
	[10236] = {
		taskId = 1,
		quest = "No Common Adventure"
	},
	[10237] = {
		taskId = 1,
		quest = "No Common Adventure"
	},
	[10238] = {
		taskId = 1,
		quest = "No Common Adventure"
	},
	[10252] = {
		quest = "The Lost Expedition",
		taskId = {
			5,
			6,
			7
		}
	},
	[10248] = {
		taskId = 4,
		quest = "A Trapper's Last Days"
	},
	[10253] = {
		taskId = 13,
		quest = "A Trapper's Last Days"
	},
	[10269] = {
		taskId = 1,
		quest = "Missing Cargo"
	},
	[10271] = {
		taskId = 14,
		quest = "Missing Cargo"
	},
	[10625] = {
		quest = "Under the Halls' Shadows",
		taskId = {
			4,
			6
		}
	},
	[10266] = {
		taskId = 7,
		quest = "Under the Halls' Shadows"
	},
	[10272] = {
		event = "Foreigner's Plague",
		taskId = 7
	},
	[10273] = {
		event = "Foreigner's Plague",
		taskId = 10
	},
	[10289] = {
		event = "Magical Pheromones",
		notActive = true
	},
	[10256] = {
		always = true,
		quest = "A Tomb of Stone and Ice"
	},
	[10257] = {
		taskId = 9,
		quest = "A Tomb of Stone and Ice"
	},
	[10258] = {
		always = true,
		quest = "A Tomb of Stone and Ice"
	},
	[10301] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10302] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10303] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10304] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10305] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10306] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10307] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10309] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10310] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10311] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10312] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10313] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10314] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10315] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10316] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10317] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10318] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10319] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10320] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10321] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10323] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10324] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10325] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10326] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10327] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10328] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10329] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10330] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10331] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10332] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10333] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10334] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10335] = {
		always = true,
		event = "Sealed Under the Dark",
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10337] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10338] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10339] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10340] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10341] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10342] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10343] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10344] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10345] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10346] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10347] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10348] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10349] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10350] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10351] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10352] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10353] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10354] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10355] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10356] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10357] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10358] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10359] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10360] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10361] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10362] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10363] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10364] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10365] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10366] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10367] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10369] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10370] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10371] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10372] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10373] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10374] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10377] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10378] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10379] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10380] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10381] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10382] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10383] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10384] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10387] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10388] = {
		quest = "Raiders of the Wicked Seals",
		always = true,
		itemId = {
			40569,
			40570,
			40571,
			40572
		}
	},
	[10396] = {
		itemId = 32328,
		quest = "Raiders of the Wicked Seals",
		always = true
	},
	[10397] = {
		itemId = 32328,
		quest = "Raiders of the Wicked Seals",
		always = true
	},
	[10398] = {
		itemId = 32328,
		quest = "Raiders of the Wicked Seals",
		always = true
	},
	[10413] = {
		itemId = 34905,
		quest = "Raiders of the Wicked Seals",
		always = true
	},
	[10414] = {
		itemId = 34905,
		quest = "Raiders of the Wicked Seals",
		always = true
	},
	[10415] = {
		itemId = 34905,
		quest = "Raiders of the Wicked Seals",
		always = true
	},
	[10416] = {
		itemId = 34905,
		quest = "Raiders of the Wicked Seals",
		always = true
	},
	[10417] = {
		itemId = 34905,
		quest = "Raiders of the Wicked Seals",
		always = true
	},
	[10418] = {
		itemId = 34905,
		quest = "Raiders of the Wicked Seals",
		always = true
	},
	[10419] = {
		itemId = 34905,
		quest = "Raiders of the Wicked Seals",
		always = true
	},
	[10420] = {
		itemId = 34905,
		quest = "Raiders of the Wicked Seals",
		always = true
	},
	[10459] = {
		always = true,
		event = "The Husk of Skorn",
		itemId = {
			32328,
			32305
		}
	},
	[10460] = {
		always = true,
		event = "The Husk of Skorn",
		itemId = {
			32328,
			32305
		}
	},
	[10461] = {
		always = true,
		event = "The Husk of Skorn",
		itemId = {
			32328,
			32305
		}
	},
	[10462] = {
		always = true,
		event = "The Husk of Skorn",
		itemId = {
			32328,
			32305
		}
	},
	[10493] = {
		itemId = 34905,
		always = true,
		event = "Pieces on a Chessboard"
	},
	[10494] = {
		itemId = 34905,
		always = true,
		event = "Pieces on a Chessboard"
	},
	[10495] = {
		event = "Prison on the Peak",
		taskId = 3
	},
	[10488] = {
		event = "Winter Night Ritual",
		notActive = true,
		taskId = {
			1,
			2
		}
	}
}
QuestItemsItemId = {
	[3623] = {
		taskId = 1,
		quest = "Running Out Of Stock"
	},
	[3624] = {
		taskId = 1,
		quest = "Running Out Of Stock"
	},
	[34323] = {
		taskId = 2,
		quest = "Running Out Of Stock"
	},
	[34214] = {
		taskId = 7,
		quest = "Sugarcane Infestation"
	},
	[34215] = {
		taskId = 7,
		quest = "Sugarcane Infestation"
	},
	[34216] = {
		taskId = 7,
		quest = "Sugarcane Infestation"
	},
	[34217] = {
		taskId = 7,
		quest = "Sugarcane Infestation"
	},
	[34218] = {
		taskId = 7,
		quest = "Sugarcane Infestation"
	},
	[34817] = {
		quest = "Ghaz At The Gates",
		taskId = {
			4,
			6,
			8,
			10
		}
	},
	[34816] = {
		taskId = 12,
		quest = "Ghaz At The Gates"
	},
	[35572] = {
		quest = "The Guildmaster",
		taskId = {
			5,
			6,
			7
		}
	},
	[35576] = {
		quest = "The Guildmaster",
		taskId = {
			5,
			6,
			7,
			11
		}
	},
	[35573] = {
		quest = "The Guildmaster",
		taskId = {
			5,
			6,
			7
		}
	},
	[35574] = {
		quest = "The Guildmaster",
		taskId = {
			5,
			6,
			7
		}
	},
	[36801] = {
		taskId = 5,
		quest = "Working Conditions"
	}
}
AlwaysInteractableActionId = {
	[25565] = true,
	[25567] = true,
	[25566] = true
}
CraftingQuests = {
	["Raiding the Raiders"] = 7,
	["Crafting for a Reward"] = 2,
	["The Rites of Skorn"] = 1,
	["Mortal Enemies"] = 9,
	["Bandit Breakdown"] = 8
}
SharedCooldownClientIds = {
	{
		35442,
		35443,
		35444,
		35445,
		35446,
		35447,
		35448,
		35449,
		35450,
		35451,
		35452,
		35453,
		35454,
		35455,
		35456,
		35457,
		35458,
		35459,
		35460,
		35461,
		40881,
		40882,
		40883,
		40884,
		40885,
		40886,
		40887,
		40888,
		40889,
		40890,
		40911,
		40912,
		40913,
		40914
	},
	{
		36954,
		39079,
		37053,
		37004,
		37046,
		36995,
		49694,
		49693,
		49696,
		49690,
		49695,
		49691,
		49692,
		49689,
		49684,
		49683,
		49681,
		49688,
		49685,
		49682,
		49686,
		49687,
		49670,
		49672,
		49666,
		49671,
		49674,
		49668,
		49675,
		49665,
		49677,
		49669,
		49667,
		49676
	},
	{
		28760,
		35397,
		28882,
		42721,
		35400,
		35401,
		42723
	}
}
AbilityBarIgnoreChannelingItemIds = {
	35442,
	35443,
	35444,
	35445,
	35446,
	35447,
	35448,
	35449,
	35450,
	35451,
	35452,
	35453,
	35454,
	35455,
	35456,
	35457,
	35458,
	35459,
	35460,
	35461,
	40881,
	40882,
	40883,
	40884,
	40885,
	40886,
	40887,
	40888,
	40889,
	40890,
	40911,
	40912,
	40913,
	40914
}
AbilityBarSupportedItemIds = {
	35442,
	35443,
	35444,
	35445,
	35446,
	35447,
	35448,
	35449,
	35450,
	35451,
	35452,
	35453,
	35454,
	35455,
	35456,
	35457,
	35458,
	35459,
	35460,
	35461,
	40881,
	40882,
	40883,
	40884,
	40885,
	40886,
	40887,
	40888,
	40889,
	40890,
	40911,
	40912,
	40913,
	40914,
	36940,
	36941,
	36947,
	36948,
	36989,
	36990,
	36998,
	36995,
	37040,
	37041,
	37045,
	37046,
	39073,
	39102,
	37006,
	39100,
	39080,
	39093,
	37053,
	39096,
	39076,
	39087,
	36957,
	36956,
	37005,
	39085,
	39092,
	39077,
	39084,
	39098,
	39074,
	39075,
	39070,
	37004,
	36954,
	39094,
	39079,
	37054,
	34868,
	34869,
	34870,
	35397,
	35398,
	35399,
	35400,
	35401,
	35402,
	42748,
	42103,
	42104,
	42105,
	42108,
	42109,
	42110,
	42111,
	42113,
	42114,
	42115,
	42116,
	42117,
	42119,
	42120,
	42121,
	42122,
	42124,
	42125,
	42127,
	42128,
	42722,
	42723,
	42724,
	34864,
	34865,
	34866,
	34851,
	34852,
	34853,
	34854,
	34855,
	34856,
	34857,
	34858,
	34859,
	34860,
	34861,
	34862,
	28753,
	28754,
	28755,
	28756,
	28757,
	28758,
	28759,
	28760,
	28761,
	28764,
	28765,
	28766,
	28767,
	28882,
	28883,
	34847,
	34848,
	34849,
	42721,
	42725,
	40844,
	40850,
	40847,
	40849,
	40845,
	40848,
	40846,
	40851,
	40858,
	40861,
	40856,
	40862,
	40853,
	40854,
	40857,
	40855,
	49654,
	49656,
	49655,
	49657,
	49653,
	49651,
	49658,
	49652,
	49659,
	49647,
	49650,
	49649,
	49648,
	49660,
	49662,
	49664,
	49663,
	40877,
	49679,
	40878,
	40873,
	40875,
	40874,
	49680,
	40879,
	49694,
	49693,
	49696,
	49690,
	49695,
	49691,
	49692,
	49689,
	49684,
	49683,
	49681,
	49688,
	49685,
	49682,
	49686,
	49687,
	49670,
	49672,
	49666,
	49671,
	49674,
	49668,
	49675,
	49665,
	49677,
	49669,
	49667,
	49676,
	51706,
	51709,
	51708,
	51705,
	51707,
	37125,
	43989,
	34746,
	38161,
	50715,
	50716,
	50717,
	50718,
	50719,
	50720,
	28426,
	28427,
	35437,
	35438,
	28428,
	38263
}
MODAL_CUSTOMID_TEMPORARY = 1501
MODAL_CUSTOMID_DEATHPENALTY = 1502
MODAL_CUSTOMID_LEARNARCHETYPE = 1503
MODAL_CUSTOMID_DUEL = 1504
MODAL_CUSTOMID_WARMODE_INFO = 1505
MODAL_CUSTOMID_PLUNDER_INFO = 1506
MODAL_CUSTOMID_CONFIRM_CHECKBOX = 1507
MODAL_CUSTOMID_CONFIRM = 1508

if g_game.isRavenQuest() then
	dofile("/modules/gamelib/lands_ravenquest.lua")
else
	dofile("/modules/gamelib/lands.lua")
end

dofile("/modules/gamelib/floor_change_pos.lua")

REPUTATION_ORDER = 1
REPUTATION_MERCENARY = 2
REPUTATION_CRIMINAL = 3
ReputationToName = {
	[REPUTATION_ORDER] = "Order",
	[REPUTATION_MERCENARY] = "Mercenary",
	[REPUTATION_CRIMINAL] = "Criminal"
}
NameToReputation = {
	Order = REPUTATION_ORDER,
	Mercenary = REPUTATION_MERCENARY,
	Criminal = REPUTATION_CRIMINAL
}
ButtonToColor = {
	yes = "PrimaryButton",
	confirm = "PrimaryButton",
	["for�ar sa�da"] = "DangerButton",
	apply = "PrimaryButton",
	["^pagar .*$"] = "PrimaryButton",
	sim = "PrimaryButton",
	aplicar = "PrimaryButton",
	["encerrar sess�o"] = "WarningButton",
	confirmar = "PrimaryButton",
	["force exit"] = "DangerButton",
	no = "DangerButton",
	n�o = "DangerButton",
	clear = "DangerButton",
	logout = "WarningButton",
	["^pay .*$"] = "PrimaryButton"
}
TRAIT_NONE = 0
TRAIT_NIGHTWALKER = 1
TRAIT_SUNSTRIDER = 2
TRAIT_WAYFARER = 3
TRAIT_SAND_WANDERER = 4
TRAIT_PLAINS_RIDER = 5
TRAIT_KING_OF_THE_TUNDRA = 6
TRAIT_WARBROOD = 7
TRAIT_CAVE_DELVER = 8
TRAIT_PATHFINDER = 9
MOUNT_ABILITY_DASH_T1 = 1600
MOUNT_ABILITY_DASH_T2 = 1601
MOUNT_ABILITY_DASH_T3 = 1602
MOUNT_ABILITY_SPRINT_T1 = 1603
MOUNT_ABILITY_SPRINT_T2 = 1604
MOUNT_ABILITY_SPRINT_T3 = 1605
MOUNT_ABILITY_STAMPEDE_T1 = 1606
MOUNT_ABILITY_STAMPEDE_T2 = 1607
MOUNT_ABILITY_STAMPEDE_T3 = 1608
MOUNT_ABILITY_CHARGE_T1 = 1609
MOUNT_ABILITY_CHARGE_T2 = 1610
MOUNT_ABILITY_CHARGE_T3 = 1611
ITEM_QUALITY_NORMAL = 0
ITEM_QUALITY_HIGH = 1
ITEM_QUALITY_SUPERIOR = 2
ITEM_QUALITY_ARTISAN = 3
ITEM_QUALITY_FIRST = ITEM_QUALITY_NORMAL
ITEM_QUALITY_LAST = ITEM_QUALITY_ARTISAN
ItemQualityNames = {
	[ITEM_QUALITY_NORMAL] = "Normal",
	[ITEM_QUALITY_HIGH] = "High",
	[ITEM_QUALITY_SUPERIOR] = "Superior",
	[ITEM_QUALITY_ARTISAN] = "Artisan"
}
QUALITY_EFFECTIVENESS = {
	[ITEM_QUALITY_NORMAL] = 1,
	[ITEM_QUALITY_HIGH] = 1.15,
	[ITEM_QUALITY_SUPERIOR] = 1.3,
	[ITEM_QUALITY_ARTISAN] = 1.45
}
RATION_EFFECTIVENESS = {
	[ITEM_QUALITY_NORMAL] = 1,
	[ITEM_QUALITY_HIGH] = 1.03,
	[ITEM_QUALITY_SUPERIOR] = 1.06,
	[ITEM_QUALITY_ARTISAN] = 1.12
}
QUALITY_EFFECTIVENESS_BY_TYPE = {
	foodquality = QUALITY_EFFECTIVENESS,
	potionquality = QUALITY_EFFECTIVENESS,
	rationquality = RATION_EFFECTIVENESS
}
CHANNEL_FLAG_NONE = 0
CHANNEL_FLAG_PUBLIC = 1
CHANNEL_FLAG_OPTIONAL = 2
CHANNEL_FLAG_ONLINE = 4
CHANNEL_FLAG_WARMODE = 8
CHANNEL_FLAG_GUILDWARS = 16
CHANNEL_FLAG_PLUNDERMODE = 32
CHANNEL_FLAG_AETHER_RIFT = 64
CHANNEL_TYPE = {
	NORMAL = 0,
	PLUNDER = 2,
	WARMODE = 1
}
CardRarityToName = {
	"Common",
	"Uncommon",
	"Grand",
	"Rare",
	"Arcane",
	"Mythic",
	"Legendary"
}
ItemQualityColors = {
	["Aether Rift Charge"] = "#8244C5",
	["Dawn Essence"] = "#8244C5",
	Ravenpack = "#8244C5",
	["Ocean Trophy"] = "#FBFB79",
	["Aether Trophy"] = "#FBFB79",
	["Creature Trophy"] = "#FBFB79",
	["Quest Item"] = "#FBFB79",
	["Mount Armor"] = "#FF6EF0",
	[ITEM_GRADE_BASIC] = "#D2D7D8",
	[ITEM_GRADE_GRAND] = "#77D463",
	[ITEM_GRADE_RARE] = "#02CCA8",
	[ITEM_GRADE_ARCANE] = "#52A8F7",
	[ITEM_GRADE_CELESTIAL] = "#FF6EF0",
	[ITEM_GRADE_ASCENDANT] = "#FAEC2F",
	[ITEM_GRADE_HEROIC] = "#FFB451",
	[ITEM_GRADE_MYTHIC] = "#FF7B00",
	[ITEM_GRADE_LEGENDARY] = "#FF5151",
	[ITEM_GRADE_LEGENDARYPLUS] = "#FF5151",
	[ITEM_GRADE_LEGENDARYMAX] = "#FF5151"
}
ItemRarityByItemId = {
	[48513] = 7,
	[49943] = 8,
	[48520] = 2,
	[48511] = 4,
	[48519] = 1,
	[49904] = 3,
	[48518] = 3,
	[49902] = 4,
	[48517] = 4,
	[49905] = 6,
	[48516] = 1,
	[49903] = 8,
	[48515] = 2,
	[48512] = 8,
	[48514] = 3
}
ItemQualityNameOverlayColors = {
	["Ocean Trophy"] = "#FF5151",
	["Aether Trophy"] = "#FF5151",
	["Creature Trophy"] = "#FF5151"
}
ItemNameOverlayColors = {
	["Cosmetic Material"] = "#FBFB79"
}
CARD_RARITY_COMMON = 1
CARD_RARITY_UNCOMMON = 2
CARD_RARITY_GRAND = 3
CARD_RARITY_RARE = 4
CARD_RARITY_ARCANE = 5
CARD_RARITY_MYTHIC = 6
CARD_RARITY_LEGENDARY = 7
CardRarityToColor = {
	[CARD_RARITY_COMMON] = "#d2d7d8",
	[CARD_RARITY_UNCOMMON] = "#77D463",
	[CARD_RARITY_GRAND] = "#02CCA8",
	[CARD_RARITY_RARE] = "#52A8F7",
	[CARD_RARITY_ARCANE] = "#FF6EF0",
	[CARD_RARITY_MYTHIC] = "#FFA851",
	[CARD_RARITY_LEGENDARY] = "#FF5151"
}
CARD_RARITY_START = CARD_RARITY_COMMON
CARD_RARITY_END = CARD_RARITY_LEGENDARY
ARCHETYPE_PASSIVE_COST = 2
ARCHETYPES_DATA = {
	[ArchetypeWarfare] = {
		name = "Warfare",
		description = "With a ravenous appetite for bloodshed, {Warfare, #E7B131} is the favored archetype of orcs and barbarians. Users of this archetype specialize in {brute force combat, #E7B131}, able to draw upon the lifeblood they've spilled to {heal, #E7B131} themselves and {strengthen, #E7B131} their savage attacks. A Warfare user in the throes of bloodlust and hatred is a terrible sight to behold.",
		skills = {
			{
				name = "Brutal Strike",
				slot = 1,
				row = 1,
				cost = 1
			},
			{
				name = "Guillotine",
				slot = 2,
				row = 2,
				cost = 2
			},
			{
				name = "Shieldbreak",
				slot = 3,
				row = 2,
				cost = 2
			},
			{
				name = "Bull Rush",
				slot = 4,
				row = 3,
				cost = 3
			},
			{
				name = "Pummel",
				slot = 5,
				row = 3,
				cost = 3
			},
			{
				name = "Feasting Strike",
				slot = 6,
				row = 3,
				cost = 3
			},
			{
				name = "Bladestorm",
				slot = 7,
				row = 3,
				cost = 3
			},
			{
				name = "Fissure",
				slot = 8,
				row = 4,
				cost = 4
			},
			{
				name = "Spiked Chains",
				slot = 9,
				row = 4,
				cost = 4
			},
			{
				name = "Earthquake",
				slot = 10,
				row = 4,
				cost = 4
			},
			{
				name = "Fierce Leap",
				slot = 11,
				row = 5,
				cost = 5
			},
			{
				name = "Berserk",
				slot = 12,
				row = 5,
				cost = 5
			}
		},
		legacySkills = {
			{
				name = "Chaos Chains"
			}
		},
		passives = {
			{
				name = "Savagery",
				cost = 2
			},
			{
				name = "Bloodlust",
				cost = 2
			},
			{
				name = "Hatred",
				cost = 2
			},
			{
				name = "Bloodseeker",
				cost = 2
			},
			{
				name = "Concentrated Impact",
				cost = 2
			},
			{
				name = "Bloodbath",
				cost = 2
			}
		},
		outfit = {
			male = {
				category = 1,
				feetColor = 76,
				legsColor = 132,
				bodyColor = 115,
				headColor = 114,
				secondaryAddon = 2273,
				primaryAddon = 2268,
				lookType = 2267
			},
			female = {
				category = 1,
				feetColor = 76,
				legsColor = 132,
				bodyColor = 115,
				headColor = 114,
				secondaryAddon = 2765,
				primaryAddon = 2780,
				lookType = 2760
			}
		}
	},
	[ArchetypeArchery] = {
		name = "Archery",
		description = "With the eyes of a hawk and the swiftness of a falcon, {Archery, #E7B131} users outpace their opponents with {speed and vision, #E7B131}. {Ranged combat, #E7B131} is this archetype's specialty, empowering its users with an array of {deadly arrows, #E7B131} to be shot from afar. And if an enemy gets too close an Archery user can draw upon {disengage abilities, #E7B131} to {slow, #E7B131} their opponent and create enough separation for a killing shot. The Rohna Brotherhood has been able to evade the Ravenguard for decades, largely due to the strength of this archetype.",
		skills = {
			{
				name = "Wind Arrow",
				slot = 1,
				row = 1,
				cost = 1
			},
			{
				name = "Viper Arrow",
				slot = 2,
				row = 2,
				cost = 2
			},
			{
				name = "Concussive Shot",
				slot = 3,
				row = 2,
				cost = 2
			},
			{
				name = "Quick Fire",
				slot = 4,
				row = 2,
				cost = 2
			},
			{
				name = "Precision Shot",
				slot = 5,
				row = 3,
				cost = 3
			},
			{
				name = "Snaring Shot",
				slot = 6,
				row = 3,
				cost = 3
			},
			{
				name = "Disengage",
				slot = 7,
				row = 3,
				cost = 3
			},
			{
				name = "Rain of Arrows",
				slot = 8,
				row = 4,
				cost = 4
			},
			{
				name = "Dawn Arrow",
				slot = 8,
				row = 4,
				cost = 4
			},
			{
				name = "Venom Grenade",
				slot = 10,
				row = 4,
				cost = 4
			},
			{
				name = "Dragons Arrow",
				slot = 11,
				row = 5,
				cost = 5
			},
			{
				name = "Spirit Rangers",
				slot = 12,
				row = 5,
				cost = 5
			}
		},
		legacySkills = {
			{
				name = "Celestial Barrage"
			}
		},
		passives = {
			{
				name = "Fleetfooted",
				cost = 2
			},
			{
				name = "Clever Adaptation",
				cost = 2
			},
			{
				name = "Clear Focus",
				cost = 2
			},
			{
				name = "Careful Aim",
				cost = 2
			},
			{
				name = "Marked for Death",
				cost = 2
			},
			{
				name = "Blitz",
				cost = 2
			}
		},
		outfit = {
			male = {
				category = 1,
				feetColor = 115,
				legsColor = 114,
				bodyColor = 120,
				headColor = 60,
				secondaryAddon = 2284,
				primaryAddon = 2279,
				lookType = 2278
			},
			female = {
				category = 1,
				feetColor = 115,
				legsColor = 114,
				bodyColor = 120,
				headColor = 60,
				secondaryAddon = 2578,
				primaryAddon = 2573,
				lookType = 2572
			}
		}
	},
	[ArchetypeProtection] = {
		name = "Protection",
		description = "Strong-footed and brave, these users never lose their {unbreakable spirit, #E7B131} in the heat of battle. The preferred archetype of the mighty Ravenguard, users of {Protection, #E7B131} are often found in the vanguard of armies, {defending their allies, #E7B131} and bashing in the skulls of their enemies. Their {morale in battle, #E7B131} is legendary, a powerful force which affects friend and foe alike.",
		skills = {
			{
				name = "Bash",
				slot = 1,
				row = 1,
				cost = 1
			},
			{
				name = "Spirits Resolve",
				slot = 2,
				row = 2,
				cost = 2
			},
			{
				name = "Smiting Smash",
				slot = 3,
				row = 2,
				cost = 2
			},
			{
				name = "Shield Throw",
				slot = 4,
				row = 2,
				cost = 2
			},
			{
				name = "Revenge",
				slot = 5,
				row = 3,
				cost = 3
			},
			{
				name = "Provoke",
				slot = 6,
				row = 3,
				cost = 3
			},
			{
				name = "Blessed Earth",
				slot = 7,
				row = 3,
				cost = 3
			},
			{
				name = "Banner of Protection",
				slot = 8,
				row = 4,
				cost = 4
			},
			{
				name = "Spirit Shield",
				slot = 9,
				row = 4,
				cost = 4
			},
			{
				name = "Safeguard",
				slot = 10,
				row = 4,
				cost = 4
			},
			{
				name = "Unchained",
				slot = 11,
				row = 5,
				cost = 5
			},
			{
				name = "Unbreakable",
				slot = 12,
				row = 5,
				cost = 5
			}
		},
		legacySkills = {
			{
				name = "Eternal Retribution"
			}
		},
		passives = {
			{
				name = "Devout Protector",
				cost = 2
			},
			{
				name = "Strong Footed",
				cost = 2
			},
			{
				name = "Undying Will",
				cost = 2
			},
			{
				name = "Divine Purpose",
				cost = 2
			},
			{
				name = "Guardian",
				cost = 2
			},
			{
				name = "Giant's Blood",
				cost = 2
			}
		},
		outfit = {
			male = {
				category = 1,
				feetColor = 79,
				legsColor = 19,
				bodyColor = 38,
				headColor = 115,
				secondaryAddon = 5952,
				primaryAddon = 5794,
				lookType = 2290
			},
			female = {
				category = 1,
				feetColor = 79,
				legsColor = 19,
				bodyColor = 38,
				headColor = 115,
				secondaryAddon = 5940,
				primaryAddon = 5788,
				lookType = 2608
			}
		}
	},
	[ArchetypeShadow] = {
		name = "Shadow",
		description = "Using the shadows as a cloak, users of this archetype prefer to extinguish the lives of their victims without ever being seen. The {Shadow, #E7B131} archetype makes use of {toxins and deception, #E7B131} to {weaken targets, #E7B131} before dealing a fatal blow. Shadow users are heralds of death by the time you've seen one, you're already dead.",
		skills = {
			{
				name = "Quick Slash",
				slot = 1,
				row = 1,
				cost = 1
			},
			{
				name = "Shadowstrike",
				slot = 2,
				row = 2,
				cost = 2
			},
			{
				name = "Shadow Kick",
				slot = 3,
				row = 2,
				cost = 2
			},
			{
				name = "Coup de Grace",
				slot = 4,
				row = 3,
				cost = 3
			},
			{
				name = "Stalk",
				slot = 5,
				row = 3,
				cost = 3
			},
			{
				name = "Crippling Dagger",
				slot = 6,
				row = 3,
				cost = 3
			},
			{
				name = "Shadowbind",
				slot = 7,
				row = 3,
				cost = 3
			},
			{
				name = "Anti-Healing Venom",
				slot = 8,
				row = 4,
				cost = 4
			},
			{
				name = "Venomous Weapons",
				slot = 9,
				row = 4,
				cost = 4
			},
			{
				name = "Sinister Plot",
				slot = 10,
				row = 4,
				cost = 4
			},
			{
				name = "Death Blossom",
				slot = 11,
				row = 5,
				cost = 5
			},
			{
				name = "Illusive",
				slot = 12,
				row = 5,
				cost = 5
			}
		},
		legacySkills = {
			{
				name = "Reaper's Eclipse"
			}
		},
		passives = {
			{
				name = "Deadly Duelist",
				cost = 2
			},
			{
				name = "Lethal Toxins",
				cost = 2
			},
			{
				name = "Shadow Proficiency",
				cost = 2
			},
			{
				name = "Killer Instinct",
				cost = 2
			},
			{
				name = "Trickster",
				cost = 2
			},
			{
				name = "Cheap Shot",
				cost = 2
			}
		},
		outfit = {
			male = {
				category = 1,
				feetColor = 95,
				legsColor = 127,
				bodyColor = 89,
				headColor = 114,
				secondaryAddon = 2331,
				primaryAddon = 2326,
				lookType = 2325
			},
			female = {
				category = 1,
				feetColor = 95,
				legsColor = 127,
				bodyColor = 89,
				headColor = 114,
				secondaryAddon = 2676,
				primaryAddon = 2667,
				lookType = 2666
			}
		}
	},
	[ArchetypeWizardry] = {
		name = "Wizardry",
		description = "Bending the {elements, #E7B131} to their will, {Wizardry, #E7B131} users harness the power of {Ice and Fire, #E7B131} to devastate their enemies. Whether igniting foes in flames or ensnaring them in ice, Wizardry users call upon powerful {single-target and area spells, #E7B131} to deal {massive amounts of damage, #E7B131} on the battlefield. With the potential to single-handedly shift the tide of battle, a user of this archetype is truly an {arcane force, #E7B131} to be reckoned with.",
		skills = {
			{
				name = "Fireball",
				slot = 1,
				row = 1,
				cost = 1
			},
			{
				name = "Frostbolt",
				slot = 2,
				row = 1,
				cost = 1
			},
			{
				name = "Erupt",
				slot = 3,
				row = 2,
				cost = 2
			},
			{
				name = "Frost Shards",
				slot = 4,
				row = 2,
				cost = 2
			},
			{
				name = "Combustion",
				slot = 5,
				row = 3,
				cost = 3
			},
			{
				name = "Frost Lance",
				slot = 6,
				row = 3,
				cost = 3
			},
			{
				name = "Flame Tornado",
				slot = 7,
				row = 4,
				cost = 4
			},
			{
				name = "Coldblast",
				slot = 8,
				row = 4,
				cost = 4
			},
			{
				name = "Meteor Strike",
				slot = 9,
				row = 5,
				cost = 5
			},
			{
				name = "Icestorm",
				slot = 10,
				row = 5,
				cost = 5
			},
			{
				name = "Pyroblast",
				slot = 11,
				row = 3,
				cost = 3
			},
			{
				name = "Teleport",
				slot = 12,
				row = 3,
				cost = 3
			}
		},
		legacySkills = {
			{
				name = "Cataclysm"
			}
		},
		passives = {
			{
				name = "Frost Armor",
				cost = 2
			},
			{
				name = "Havoc",
				cost = 2
			},
			{
				name = "Flow of Magic",
				cost = 2
			},
			{
				name = "Amplification",
				cost = 2
			},
			{
				name = "Hot Headed",
				cost = 2
			},
			{
				name = "Fire Shield",
				cost = 2
			}
		},
		outfit = {
			male = {
				category = 1,
				feetColor = 77,
				legsColor = 19,
				bodyColor = 115,
				headColor = 19,
				secondaryAddon = 2345,
				primaryAddon = 2339,
				lookType = 2338
			},
			female = {
				category = 1,
				feetColor = 77,
				legsColor = 19,
				bodyColor = 115,
				headColor = 19,
				secondaryAddon = 2695,
				primaryAddon = 2689,
				lookType = 2688
			}
		}
	},
	[ArchetypeHoly] = {
		name = "Holy",
		description = "Channeling the {restorative light, #E7B131} of the Dawn, {Holy, #E7B131} is the primary {healing, #E7B131} archetype in the world of Ravendawn. While this archetype focuses on keeping its user and their allies alive on the field of battle, the full power of the Dawn should not be underestimated... skilled users can call down its {holy force, #E7B131} to smite their enemies where they stand.",
		skills = {
			{
				name = "Flash Heal",
				slot = 1,
				row = 1,
				cost = 1
			},
			{
				name = "Smite",
				slot = 2,
				row = 1,
				cost = 1
			},
			{
				name = "Dawn's Light",
				slot = 3,
				row = 2,
				cost = 2
			},
			{
				name = "Mend",
				slot = 4,
				row = 2,
				cost = 2
			},
			{
				name = "Holy Shackles",
				slot = 5,
				row = 2,
				cost = 2
			},
			{
				name = "Healing Channel",
				slot = 6,
				row = 3,
				cost = 3
			},
			{
				name = "Devotion",
				slot = 7,
				row = 3,
				cost = 3
			},
			{
				name = "Holy Force",
				slot = 8,
				row = 3,
				cost = 3
			},
			{
				name = "Circle of Light",
				slot = 9,
				row = 4,
				cost = 4
			},
			{
				name = "Purify",
				slot = 10,
				row = 4,
				cost = 4
			},
			{
				name = "Generous Influence",
				slot = 11,
				row = 5,
				cost = 5
			},
			{
				name = "Living Saint",
				slot = 12,
				row = 5,
				cost = 5
			}
		},
		legacySkills = {
			{
				name = "Dawn's Apotheosis"
			}
		},
		passives = {
			{
				name = "Sacred Spirit",
				cost = 2
			},
			{
				name = "Prophet",
				cost = 2
			},
			{
				name = "Invigorated Healing",
				cost = 2
			},
			{
				name = "Healing Attunement",
				cost = 2
			},
			{
				name = "Healing Bond",
				cost = 2
			},
			{
				name = "Devout Healer",
				cost = 2
			}
		},
		outfit = {
			male = {
				category = 1,
				feetColor = 38,
				legsColor = 24,
				bodyColor = 23,
				headColor = 50,
				secondaryAddon = 2740,
				primaryAddon = 2735,
				lookType = 2734
			},
			female = {
				category = 1,
				feetColor = 38,
				legsColor = 24,
				bodyColor = 23,
				headColor = 50,
				secondaryAddon = 2358,
				primaryAddon = 2352,
				lookType = 2351
			}
		}
	},
	[ArchetypeWitchcraft] = {
		name = "Witchcraft",
		description = "An archetype said to have originated from ancient vampiric cults, {Witchcraft, #E7B131} users mix {occult powers, #E7B131} with the ability to {gain strength from the weaknesses of others, #E7B131}. There is no one better than a Witchcraft user at {finding an enemy's flaw, #E7B131} and exploiting it to their advantage... which makes them incredibly dangerous foes.",
		skills = {
			{
				name = "Arcane Pulse",
				slot = 1,
				row = 1,
				cost = 1
			},
			{
				name = "Curse",
				slot = 2,
				row = 1,
				cost = 1
			},
			{
				name = "Arcane Torrent",
				slot = 3,
				row = 2,
				cost = 2
			},
			{
				name = "Leech",
				slot = 4,
				row = 2,
				cost = 2
			},
			{
				name = "Eternal Worms",
				slot = 5,
				row = 3,
				cost = 3
			},
			{
				name = "Siphon",
				slot = 6,
				row = 3,
				cost = 3
			},
			{
				name = "Magic Rupture",
				slot = 7,
				row = 3,
				cost = 3
			},
			{
				name = "Shackles of Pain",
				slot = 8,
				row = 4,
				cost = 4
			},
			{
				name = "Dispel",
				slot = 9,
				row = 4,
				cost = 4
			},
			{
				name = "Mirror Image",
				slot = 10,
				row = 5,
				cost = 5
			},
			{
				name = "Death Touch",
				slot = 11,
				row = 5,
				cost = 5
			},
			{
				name = "Hex",
				slot = 12,
				row = 5,
				cost = 5
			}
		},
		legacySkills = {
			{
				name = "Witch's Call"
			}
		},
		passives = {
			{
				name = "Exploitation",
				cost = 2
			},
			{
				name = "Cursed Touch",
				cost = 2
			},
			{
				name = "Witchcraft Mastery",
				cost = 2
			},
			{
				name = "Arcane Corruption",
				cost = 2
			},
			{
				name = "Creeping Death",
				cost = 2
			},
			{
				name = "Bloodmancer",
				cost = 2
			}
		},
		outfit = {
			male = {
				category = 1,
				feetColor = 76,
				legsColor = 48,
				bodyColor = 87,
				headColor = 49,
				secondaryAddon = 2726,
				primaryAddon = 2717,
				lookType = 2714
			},
			female = {
				category = 1,
				feetColor = 76,
				legsColor = 48,
				bodyColor = 87,
				headColor = 49,
				secondaryAddon = 2319,
				primaryAddon = 2313,
				lookType = 2312
			}
		}
	},
	[ArchetypeSpiritual] = {
		name = "Spiritual",
		description = "Users of the {Spiritual, #E7B131} archetype have a {supernatural calm, #E7B131}, able to focus intensely upon the invisible threads that tie the world together. With a honed mind, they can {summon these forces, #E7B131} to aid their allies protecting them with barriers of wind, {hastening, #E7B131} their movements, and {refreshing, #E7B131} their dwindling stores of mana. An adept of Spiritual Magic is an invaluable member to any team.",
		skills = {
			{
				name = "Cyclone",
				slot = 1,
				row = 1,
				cost = 1
			},
			{
				name = "Regenerate",
				slot = 2,
				row = 2,
				cost = 2
			},
			{
				name = "Whirlwind",
				slot = 3,
				row = 2,
				cost = 2
			},
			{
				name = "Barrier",
				slot = 4,
				row = 2,
				cost = 2
			},
			{
				name = "Windstrike Spirit",
				slot = 5,
				row = 3,
				cost = 3
			},
			{
				name = "Force Push",
				slot = 6,
				row = 3,
				cost = 3
			},
			{
				name = "Wind Wall",
				slot = 7,
				row = 3,
				cost = 3
			},
			{
				name = "Party Recovery",
				slot = 8,
				row = 4,
				cost = 4
			},
			{
				name = "Air Aura",
				slot = 9,
				row = 4,
				cost = 4
			},
			{
				name = "Haste",
				slot = 10,
				row = 4,
				cost = 4
			},
			{
				name = "Healing Air Sphere",
				slot = 11,
				row = 5,
				cost = 5
			},
			{
				name = "Typhoon",
				slot = 12,
				row = 5,
				cost = 5
			}
		},
		legacySkills = {
			{
				name = "Eye of the Storm"
			}
		},
		passives = {
			{
				name = "Meditate",
				cost = 2
			},
			{
				name = "Wind Mastery",
				cost = 2
			},
			{
				name = "Lingering Impact",
				cost = 2
			},
			{
				name = "Celerity",
				cost = 2
			},
			{
				name = "Sins of the Many",
				cost = 2
			},
			{
				name = "The Cost of Restoration",
				cost = 2
			}
		},
		outfit = {
			male = {
				category = 1,
				feetColor = 36,
				legsColor = 19,
				bodyColor = 71,
				headColor = 57,
				secondaryAddon = 2822,
				primaryAddon = 2818,
				lookType = 2817
			},
			female = {
				category = 1,
				feetColor = 36,
				legsColor = 19,
				bodyColor = 71,
				headColor = 57,
				secondaryAddon = 2307,
				primaryAddon = 2302,
				lookType = 2301
			}
		}
	}
}
EquipmentTypesToBonus = {
	["leather armor"] = "leather",
	["plate armor"] = "plate",
	["cloth helmet"] = "cloth",
	["leather helmet"] = "leather",
	["plate helmet"] = "plate",
	["cloth boots"] = "cloth",
	["leather boots"] = "leather",
	["plate boots"] = "plate",
	["cloth legs"] = "cloth",
	["leather legs"] = "leather",
	["plate legs"] = "plate",
	["cloth armor"] = "cloth"
}
EquipmentSetBonus = {}

addEvent(function()
	EquipmentSetBonus = {
		plate = {
			{
				count = 2,
				list = {
					"+3%% " .. tr("Maximum Health"),
					"+4%% " .. tr("Healing Received"),
					"+5%% " .. tr("Weapon Defense")
				}
			},
			{
				count = 4,
				list = {
					"+6%% " .. tr("Maximum Health"),
					"+8%% " .. tr("Healing Received"),
					"+10%% " .. tr("Weapon Defense")
				}
			}
		},
		leather = {
			{
				count = 2,
				list = {
					"+4%% " .. tr("Critical Chance"),
					tr("Reduces Stun/Slow/Snare Durations by") .. " 10%%"
				}
			},
			{
				count = 4,
				list = {
					"+8%% " .. tr("Critical Chance"),
					tr("Reduces Stun/Slow/Snare Durations by") .. " 20%%"
				}
			}
		},
		cloth = {
			{
				count = 2,
				list = {
					"+5%% " .. tr("Attack Speed/Casting Time/Global Cooldown"),
					"+7%% " .. tr("Spell Defense")
				}
			},
			{
				count = 4,
				list = {
					"+10%% " .. tr("Attack Speed/Casting Time/Global Cooldown"),
					"+15%% " .. tr("Spell Defense")
				}
			}
		}
	}
end)

RingIdToRingSet = {
	[49323] = "Sage Force",
	[49319] = "Mind Seer",
	[49325] = "Mind Seer",
	[49311] = "Dark Might",
	[49317] = "Sage Force",
	[49329] = "Void Weave",
	[49315] = "Eldritch Fortitude",
	[49321] = "Void Weave",
	[49313] = "Dark Might",
	[49327] = "Eldritch Fortitude"
}
RingSetBonus = {
	["Dark Might"] = {
		list = {
			"Increases Movement Speed by 15% After Killing a Creature for 3 Seconds"
		}
	},
	["Sage Force"] = {
		list = {
			"Restores 5% Maximum Mana when Killing a Creature of Similar Level"
		}
	},
	["Mind Seer"] = {
		list = {
			"Creature Loot Drop Rate Increased by 15%"
		}
	},
	["Eldritch Fortitude"] = {
		list = {
			"Restores 2.5% Maximum Health when Killing a Creature of Similar Level"
		}
	},
	["Void Weave"] = {
		list = {
			"Increases Silver Dropped from Creatures by 50%"
		}
	}
}
ItemsShopQuality = {
	{
		name = "Normal",
		color = "",
		price = 0.7,
		quality = ITEM_QUALITY_NORMAL
	},
	{
		name = "High",
		color = "",
		price = 0.9,
		quality = ITEM_QUALITY_HIGH
	},
	{
		name = "Superior",
		color = "",
		price = 1.1,
		quality = ITEM_QUALITY_SUPERIOR
	},
	{
		name = "Artisan",
		color = "",
		price = 1.3,
		quality = ITEM_QUALITY_ARTISAN
	}
}
PriceMultiplierByQuality = {}

for index, value in ipairs(ItemsShopQuality) do
	PriceMultiplierByQuality[value.quality] = SHOPS.CREATURE_DROPS.qualityMultiplier.sell[value.quality] or value.price
end

ItemPrices = {}

for _, info in ipairs(SHOPS.CREATURE_DROPS.items) do
	ItemPrices[info.clientId] = {
		sell = info.sell
	}
end

ShipParts = {
	[2851] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 100,
		speed = 0,
		health = 0,
		name = "Double Fishing Hook",
		description = "Increases the damage dealt by your fishing skills by 20%.",
		type = "cabin"
	},
	[5806] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 300,
		speed = 0,
		health = 0,
		name = "Royal Water Pumps",
		description = "Removes any Movement Speed slowing effect from yourself. Provides a short burst of 100 movement speed for 10 seconds.",
		type = "auxiliary"
	},
	[5484] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 200,
		speed = 75,
		health = 0,
		name = "Pirate Sail",
		description = "Your cannons deal 10% more damage to players ships.",
		type = "sail"
	},
	[1801] = {
		cargoslots = 1,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 500,
		speed = 150,
		health = 6000,
		name = "Small Galleon",
		description = "Reduces damage taken by 10%.",
		type = "hull"
	},
	[5125] = {
		cargoslots = 0,
		fishcapacity = 2,
		packcapacity = 0,
		weight = 500,
		speed = 150,
		health = 3200,
		name = "Basic Ship",
		description = "Basic ship that gets you going.",
		type = "hull"
	},
	[1795] = {
		cargoslots = 1,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 500,
		speed = 150,
		health = 4800,
		name = "Small Fishing Ship",
		description = "Increases the damage dealt by your fishing skills by 10%.",
		type = "hull"
	},
	[1817] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 200,
		speed = 0,
		health = 1000,
		name = "Sturdy Plating",
		description = "The added plating increases the health of your ship.",
		type = "auxiliary"
	},
	[1821] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 200,
		speed = 0,
		health = 0,
		name = "Adorned Ship Emblems",
		description = "Dispense smoke from your emblems to cover your ship, making creatures ignore it for the next 12 seconds. Dealing damage to creatures ends the effect.",
		type = "auxiliary"
	},
	[1811] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 2,
		weight = 100,
		speed = 0,
		health = 0,
		name = "Medium Tradepack Container",
		description = "Moderately increases your capacity to carry tradepacks.",
		type = "cabin"
	},
	[1813] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 100,
		speed = 40,
		health = 0,
		name = "Small Sail",
		description = "Slightly increases ship speed.",
		type = "sail"
	},
	[5815] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 200,
		speed = 0,
		health = 0,
		name = "Medium Siege Cannon",
		description = "Fires a heavy cannon ball that deals between 250 to 500 damage. If it hits the center it deals 60% more damage.",
		type = "auxiliary"
	},
	[5799] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 300,
		speed = 0,
		health = 0,
		name = "Medium Mortar Cannon",
		description = "Channels for 1 second with a 50% movement speed reduction. When the channel ends, fires an explosive projectile at the selected area, dealing 1050 to 1500 damage in a medium area.",
		type = "auxiliary"
	},
	[5485] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 500,
		speed = 0,
		health = 4000,
		name = "Warship Plating",
		description = "The added plating increases the health of your ship.",
		type = "auxiliary"
	},
	[2852] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 300,
		speed = 0,
		health = 1500,
		name = "Reinforced Plating",
		description = "The added plating increases the health of your ship.",
		type = "auxiliary"
	},
	[5816] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 200,
		speed = 0,
		health = 0,
		name = "Large Siege Cannon",
		description = "Fires a heavy cannon ball that deals between 300 to 600 damage. If it hits the center it deals 60% more damage.",
		type = "auxiliary"
	},
	[5800] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 300,
		speed = 0,
		health = 0,
		name = "Large Mortar Cannon",
		description = "Channels for 1 second with a 50% movement speed reduction. When the channel ends, fires an explosive projectile at the selected area, dealing 1500 to 2100 damage in a medium area.",
		type = "auxiliary"
	},
	[5478] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 300,
		speed = 0,
		health = 0,
		name = "Graceful Ship Emblems",
		description = "Dispense smoke from your emblems to cover your ship, making creatures ignore it for the next 20 seconds. Dealing damage to creatures ends the effect.",
		type = "auxiliary"
	},
	[5817] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 250,
		speed = 0,
		health = 0,
		name = "Medium Drake Head",
		description = "Fires a scorching flame ahead of the ship, applying Drake Head Flame to targets hit, burning them for 720 damage and then 92 damage per second for 10 seconds. Targets hit suffer 45% reduced healing efficiency for the duration.",
		type = "auxiliary"
	},
	[5801] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 200,
		speed = 0,
		health = 0,
		name = "Medium Floating Mines",
		description = "Leaves explosive mines in a line behind your ship, lasting for 10 seconds. If a target goes into one, they explode causing 1800 to 2340 damage while also slowing the target by 40% for 4 seconds.",
		type = "auxiliary"
	},
	[5487] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 300,
		speed = 75,
		health = 0,
		name = "Sturdy Sail",
		description = "Slowing effects on your ship are reduced by 30%.",
		type = "sail"
	},
	[2849] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 50,
		speed = 0,
		health = 0,
		name = "Fishing Hook",
		description = "Increases the damage dealt by your fishing skills by 10%.",
		type = "cabin"
	},
	[5818] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 250,
		speed = 0,
		health = 0,
		name = "Large Drake Head",
		description = "Fires a scorching flame ahead of the ship, applying Drake Head Flame to targets hit, burning them for 960 damage and then 92 damage per second for 10 seconds. Targets hit suffer 60% reduced healing efficiency for the duration.",
		type = "auxiliary"
	},
	[5802] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 200,
		speed = 0,
		health = 0,
		name = "Large Floating Mines",
		description = "Leaves explosive mines in a line behind your ship, lasting for 10 seconds.If a target goes into one, they explode causing 2250 to 2975 damage while also slowing the target by 50% for 4 seconds.",
		type = "auxiliary"
	},
	[5480] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 200,
		speed = 0,
		health = 0,
		name = "Small Floating Mines",
		description = "Leaves explosive mines in a line behind your ship, lasting for 10 seconds.If a target goes into one, they explode causing 900 to 1200 damage while also slowing the target by 30% for 4 seconds.",
		type = "auxiliary"
	},
	[1800] = {
		cargoslots = 3,
		fishcapacity = 0,
		packcapacity = 3,
		weight = 600,
		speed = 150,
		health = 7200,
		name = "Large Merchant Ship",
		description = "Significantly increases your capacity to carry tradepacks.",
		type = "hull"
	},
	[1804] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 50,
		speed = 0,
		health = 0,
		name = "Small Ammunitions Cabin",
		description = "Increases the damage of your regular cannon by 10%.",
		type = "cabin"
	},
	[1798] = {
		cargoslots = 1,
		fishcapacity = 0,
		packcapacity = 1,
		weight = 500,
		speed = 150,
		health = 4800,
		name = "Small Merchant Ship",
		description = "Slightly increases your capacity to carry tradepacks.",
		type = "hull"
	},
	[1796] = {
		cargoslots = 2,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 550,
		speed = 150,
		health = 6000,
		name = "Medium Fishing Ship",
		description = "Increases the damage dealt by your fishing skills by 20%.",
		type = "hull"
	},
	[1820] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 150,
		speed = 0,
		health = 0,
		name = "Shiny Ship Emblems",
		description = "Dispense smoke from your emblems to cover your ship, making creatures ignore it for the next 8 seconds. Dealing damage to creatures ends the effect.",
		type = "auxiliary"
	},
	[1810] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 1,
		weight = 50,
		speed = 0,
		health = 0,
		name = "Small Tradepack Container",
		description = "Slightly increases your capacity to carry tradepacks.",
		type = "cabin"
	},
	[1814] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 150,
		speed = 55,
		health = 0,
		name = "Medium Sail",
		description = "Moderately increases ship speed.",
		type = "sail"
	},
	[5819] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 300,
		speed = 0,
		health = 0,
		name = "Medium Broadside Artillery",
		description = "Fires a barrage of cannon shots from both sides of the ship, dealing 270 to 600 damage damage. Landing shots from Broadside Artillery increases the damage of the next barrage by 10% for 5 seconds, this effect stacks up to 2 times. This weapon has 3 charges.",
		type = "auxiliary"
	},
	[5795] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 400,
		speed = 0,
		health = 0,
		name = "Medium Hullbreaker Cannon",
		description = "Fires a devastating blast ahead of your ship, dealing between 1500 to 2000 damage to the afflicted ship or creature and slowing them by 40% for 7 seconds. Targets at the center take full damage and slow, while those at the edges take half instead.",
		type = "auxiliary"
	},
	[1824] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 200,
		speed = 0,
		health = 0,
		name = "Advanced Water Pumps",
		description = "Provides a short burst of 75 movement speed for 10 seconds.",
		type = "auxiliary"
	},
	[2657] = {
		cargoslots = 0,
		fishcapacity = 2,
		packcapacity = 0,
		weight = 500,
		speed = 150,
		health = 1000,
		name = "Starter Ship",
		description = "Basic ship that gets you going.",
		type = "hull"
	},
	[5780] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 400,
		speed = 0,
		health = 0,
		name = "Small Hullbreaker Cannon",
		description = "Fires a devastating blast ahead of your ship, dealing between 1000 to 1500 damage to the afflicted ship or creature and slowing them by 30% for 7 seconds. Targets at the center take full damage and slow, while those at the edges take half instead.",
		type = "auxiliary"
	},
	[2850] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 100,
		speed = 0,
		health = 0,
		name = "Medium Ammunitions Cabin",
		description = "Increases the damage of your regular cannon by 20%",
		type = "cabin"
	},
	[5820] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 300,
		speed = 0,
		health = 0,
		name = "Large Broadside Artillery",
		description = "Fires a barrage of cannon shots from both sides of the ship, dealing 340 to 825 damage. Landing shots from Broadside Artillery increases the damage of the next barrage by 15% for 5 seconds, this effect stacks up to 2 times. This weapon has 3 charges.",
		type = "auxiliary"
	},
	[5796] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 400,
		speed = 0,
		health = 0,
		name = "Large Hullbreaker Cannon",
		description = "Fires a devastating blast ahead of your ship, dealing between 2000 to 2500 damage to the afflicted ship or creature and slowing them by 50% for 7 seconds. Targets at the center take full damage and slow, while those at the edges take half instead.",
		type = "auxiliary"
	},
	[5482] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 200,
		speed = 50,
		health = 0,
		name = "Merchant Sail",
		description = "Increases speed by 50 when carrying tradepacks outside combat.",
		type = "sail"
	},
	[5804] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 50,
		speed = 0,
		health = 0,
		name = "Large Grappling Hooks",
		description = "Fires three grappling hooks in front of the ship, dealing 250 to 500 damage and snaring the first target hit for 5 seconds. Targets snared by Large Grappling Hooks receive 20% additional damage from ships.",
		type = "auxiliary"
	},
	[5803] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 50,
		speed = 0,
		health = 0,
		name = "Medium Grappling Hooks",
		description = "Fires three grappling hooks in front of the ship, dealing 200 to 400 damage and snaring the first target hit for 4 seconds. Targets snared by Medium Grappling Hooks receive 15% additional damage from ships.",
		type = "auxiliary"
	},
	[5481] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 50,
		speed = 0,
		health = 0,
		name = "Small Grappling Hooks",
		description = "Fires three grappling hooks in front of the ship, dealing 150 to 300 damage and snaring the first target hit for 3 seconds. Targets snared by Small Grappling Hooks receive 10% additional damage from ships.",
		type = "auxiliary"
	},
	[5798] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 200,
		speed = 0,
		health = 0,
		name = "Large Shrapnel Cannon",
		description = "Fires a cloud of shrapnel projectiles, dealing between 175 to 275 damage while applying a Damaged Sail stack. Each stack slows the afflicted target by 12% for 20 seconds. Stacks up to 3 times. New stacks do not refresh this duration.",
		type = "auxiliary"
	},
	[5797] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 200,
		speed = 0,
		health = 0,
		name = "Medium Shrapnel Cannon",
		description = "Fires a cloud of shrapnel projectiles, dealing between 150 to 225 damage damage while applying a Damaged Sail stack. Each stack slows the afflicted target by 10% for 20 seconds. Stacks up to 3 times. New stacks do not refresh this duration.",
		type = "auxiliary"
	},
	[1823] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 150,
		speed = 0,
		health = 0,
		name = "Efficient Water Pumps",
		description = "Provides a short burst of 50 movement speed for 10 seconds.",
		type = "auxiliary"
	},
	[1797] = {
		cargoslots = 3,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 600,
		speed = 150,
		health = 7200,
		name = "Large Fishing Ship",
		description = "Increases the damage dealt by your fishing skills by 30%.",
		type = "hull"
	},
	[5477] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 250,
		speed = 0,
		health = 0,
		name = "Small Drake Head",
		description = "Fires a scorching flame ahead of the ship, applying Drake Head Flame to targets hit, burning them for 560 damage and then 70 damage per second for 10 seconds. Targets hit suffer 35% reduced healing efficiency for the duration.",
		type = "auxiliary"
	},
	[2853] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 100,
		speed = 0,
		health = 0,
		name = "Small Fishing Nets",
		description = "Reduces the time it takes for a fish to bite by 5 seconds.",
		type = "auxiliary"
	},
	[5486] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 400,
		speed = 0,
		health = 2500,
		name = "Fortified Plating",
		description = "The added plating increases the health of your ship.",
		type = "auxiliary"
	},
	[5479] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 250,
		speed = 0,
		health = 0,
		name = "Deluxe Ship Emblems",
		description = "Dispense smoke from your emblems to cover your ship, making creatures ignore it for the next 16 seconds. Dealing damage to creatures ends the effect.",
		type = "auxiliary"
	},
	[5781] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 200,
		speed = 0,
		health = 0,
		name = "Small Shrapnel Cannon",
		description = "Fires a cloud of shrapnel projectiles, dealing between 125 to 175 damage while applying a Damaged Sail stack. Each stack slows the afflicted target by 8% for 20 seconds. Stacks up to 3 times. New stacks do not refresh this duration.",
		type = "auxiliary"
	},
	[5779] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 100,
		speed = 0,
		health = 0,
		name = "Medium Maintenance Unit",
		description = "This cabin gives you access to the Medium Hull Mend. Medium Hull Mend repairs your ship by 4% of its maximum health per second during 10 seconds. 150 seconds cooldown.",
		type = "cabin"
	},
	[1805] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 50,
		speed = 0,
		health = 0,
		name = "Small Maintenance Unit",
		description = "This cabin gives you access to the Small Hull Mend. Small Hull Mend repairs your ship by 2.5% of its maximum health per second during 10 seconds. 150 seconds cooldown.",
		type = "cabin"
	},
	[5805] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 250,
		speed = 0,
		health = 0,
		name = "Superior Water Pumps",
		description = "Provides a short burst of 100 movement speed for 10 seconds.",
		type = "auxiliary"
	},
	[5483] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 300,
		speed = 0,
		health = 0,
		name = "Small Broadside Artillery",
		description = "Fires a barrage of cannon shots from both sides of the ship, dealing 200 to 450 damage. Landing shots from Broadside Artillery increases the damage of the next barrage by 7% for 5 seconds, this effect stacks up to 2 times. This weapon has 3 charges.",
		type = "auxiliary"
	},
	[1822] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 100,
		speed = 0,
		health = 0,
		name = "Basic Water Pumps",
		description = "Provides a short burst of 25 movement speed for 10 seconds.",
		type = "auxiliary"
	},
	[1819] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 100,
		speed = 0,
		health = 0,
		name = "Simple Ship Emblems",
		description = "Dispense smoke from your emblems to cover your ship, making creatures ignore it for the next 5 seconds. Dealing damage to creatures ends the effect.",
		type = "auxiliary"
	},
	[2848] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 200,
		speed = 0,
		health = 0,
		name = "Small Siege Cannon",
		description = "Fires a heavy cannon ball that deals between 200 to 400 damage. If it hits the center it deals 60% more damage.",
		type = "auxiliary"
	},
	[1816] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 100,
		speed = 0,
		health = 500,
		name = "Minor Plating",
		description = "The added plating increases the health of your ship.",
		type = "auxiliary"
	},
	[2855] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 200,
		speed = 0,
		health = 0,
		name = "Large Fishing Nets",
		description = "Reduces the time it takes for a fish to bite by 30 seconds.",
		type = "auxiliary"
	},
	[2854] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 150,
		speed = 0,
		health = 0,
		name = "Medium Fishing Nets",
		description = "Reduces the time it takes for a fish to bite by 15 seconds.",
		type = "auxiliary"
	},
	[5124] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 50,
		speed = 30,
		health = 0,
		name = "Basic Sail",
		description = "Basic sail that gets you going.",
		type = "sail"
	},
	[1815] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 200,
		speed = 70,
		health = 0,
		name = "Large Sail",
		description = "Significantly increases ship speed.",
		type = "sail"
	},
	[1803] = {
		cargoslots = 3,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 600,
		speed = 150,
		health = 8400,
		name = "Large Galleon",
		description = "Reduces damage taken by 20%.",
		type = "hull"
	},
	[1802] = {
		cargoslots = 2,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 550,
		speed = 150,
		health = 7200,
		name = "Medium Galleon",
		description = "Reduces damage taken by 15%.",
		type = "hull"
	},
	[1799] = {
		cargoslots = 2,
		fishcapacity = 0,
		packcapacity = 2,
		weight = 550,
		speed = 150,
		health = 6000,
		name = "Medium Merchant Ship",
		description = "Moderately increases your capacity to carry tradepacks.",
		type = "hull"
	},
	[5782] = {
		cargoslots = 0,
		fishcapacity = 0,
		packcapacity = 0,
		weight = 300,
		speed = 0,
		health = 0,
		name = "Small Mortar Cannon",
		description = "Channels for 1 second with a 50% movement speed reduction. When the channel ends, fires an explosive projectile at the selected area, dealing 750 to 1050 damage in a medium area.",
		type = "auxiliary"
	}
}
ShipCosmetics = {
	[2415] = {
		name = "Founder's Ship",
		type = "ship cosmetic",
		description = "Sail with the confidence of a monarch as your Crown Companion Ship cuts through the waves, a symbol of your high standing with Ravendawn's crown."
	},
	[2655] = {
		name = "Dark Ritualist Ship",
		type = "ship cosmetic",
		description = "Cloaked in shadows and adorned with haunting symbols, roam the seas striking fear into the hearts of all who cross your path."
	},
	[6091] = {
		name = "Trailblazer Ship",
		type = "ship cosmetic",
		description = "Set sail on daring expeditions across the uncharted seas of Ravendawn aboard the Trailblazer Ship. Fearlessly lead the way and carve a path through the unknown with unwavering resolve."
	},
	[6163] = {
		name = "Carnival Ship",
		type = "ship cosmetic",
		description = "Embark on a whimsical voyage across the seas of Ravendawn with the majestic Carnival Ship, adorned with vibrant streamers and dazzling colors to inspire awe in your admirers and terror in your foes!"
	},
	[6418] = {
		name = "Cinderskull Boat",
		type = "ship cosmetic",
		description = "The burning skull at the head of this boat is often the last sight for those unfortunate enough to witness them. Known to be boarded by undead crews, to wrestle control of such a vessel is an impressive feat for any adventurer."
	},
	[8767] = {
		name = "Kingmaker Ship",
		type = "ship cosmetic",
		description = "With its gleaming hull cutting through the waves, the Kingmaker Ship charges forward, forging a path to victory through your steadfast command. Outsmart your opponents on the high seas with the elegance and prowess of a tried and tested captain."
	},
	[8745] = {
		name = "War Rider Ship",
		type = "ship cosmetic",
		description = "Conquer the seas at the helm of this formidable vessel. The War Rider Ship will triumphantly surmount the waves and stand against any opponent, leaving only splinters in its wake. Command a mighty fleet to victory, with your flagship leading the charge and striking fear into the enemy!"
	}
}
OutfitAddons = {
	[2357] = {
		name = "Sanctified Adorning",
		id = 81
	},
	[2349] = {
		name = "Igneas Ice Staff",
		id = 74
	},
	[2268] = {
		name = "Default",
		id = 1
	},
	[2276] = {
		name = "Darksteel Axe",
		id = 9
	},
	[2325] = {
		name = "Shadow",
		id = 6
	},
	[2292] = {
		name = "Magical Sigils",
		id = 28
	},
	[2309] = {
		name = "Royal Rapier",
		id = 39
	},
	[2762] = {
		name = "Ornamental Helmet",
		id = 155
	},
	[2738] = {
		name = "Blessed Hood",
		id = 144
	},
	[2722] = {
		name = "Livingthorn Staff",
		id = 139
	},
	[5959] = {
		name = "Back Stabba",
		id = 194
	},
	[2690] = {
		name = "Not-so-Magical Hat",
		id = 118
	},
	[5736] = {
		name = "Winged Protector",
		id = 88
	},
	[2675] = {
		name = "Serrated Blades",
		id = 113
	},
	[5927] = {
		name = "Bull's Fury",
		id = 185
	},
	[2611] = {
		name = "Bandit Breaker",
		id = 95
	},
	[2358] = {
		name = "Default",
		id = 82
	},
	[2350] = {
		name = "Demonskull staff",
		id = 75
	},
	[2342] = {
		name = "Enchanted Hat",
		id = 67
	},
	[2277] = {
		name = "Ominous Axe",
		id = 10
	},
	[2285] = {
		name = "Curved Bow",
		id = 17
	},
	[5737] = {
		name = "Knight's Helmet",
		id = 89
	},
	[2310] = {
		name = "Bloodletter",
		id = 40
	},
	[2763] = {
		name = "Thergardian Helmet",
		id = 156
	},
	[2739] = {
		name = "Dawn's Guider",
		id = 145
	},
	[2723] = {
		name = "Ravensong Enchanter",
		id = 138
	},
	[5961] = {
		name = "Night's Crest",
		id = 195
	},
	[2691] = {
		name = "Starseeker Hat",
		id = 119
	},
	[5738] = {
		name = "Bestial Maw",
		id = 90
	},
	[2676] = {
		name = "Default",
		id = 112
	},
	[2668] = {
		name = "Shadow Veil",
		id = 108
	},
	[2612] = {
		name = "Snowfall Endurer",
		id = 96
	},
	[2359] = {
		name = "Intact Arms",
		id = 83
	},
	[2351] = {
		name = "Holy",
		id = 8
	},
	[2580] = {
		name = "Elderbark Bow",
		id = 103
	},
	[2278] = {
		name = "Archer",
		id = 2
	},
	[2327] = {
		name = "Shadow Veil",
		id = 53
	},
	[5739] = {
		name = "Iceguard",
		id = 91
	},
	[2302] = {
		name = "Default",
		id = 32
	},
	[2780] = {
		name = "Default",
		id = 153
	},
	[2764] = {
		name = "Wyrmskull Visage",
		id = 157
	},
	[2740] = {
		name = "Default",
		id = 147
	},
	[2724] = {
		name = "Skulls of Possession",
		id = 137
	},
	[5963] = {
		name = "Back Stabba",
		id = 196
	},
	[2692] = {
		name = "Enchanted Hat",
		id = 120
	},
	[5740] = {
		name = "Draconic Crown",
		id = 92
	},
	[5899] = {
		name = "Wanderer's Veil",
		id = 190
	},
	[2669] = {
		name = "Stalker's Cowl",
		id = 109
	},
	[5952] = {
		name = "Default",
		id = 178
	},
	[2274] = {
		name = "Skullsplitter Axe",
		id = 7
	},
	[5788] = {
		name = "Default",
		id = 179
	},
	[2360] = {
		name = "Lustrous Protection",
		id = 84
	},
	[2352] = {
		name = "Default",
		id = 76
	},
	[2344] = {
		name = "Bright Robes",
		id = 69
	},
	[2581] = {
		name = "Drakebane",
		id = 104
	},
	[2328] = {
		name = "Stalker's Cowl",
		id = 54
	},
	[2320] = {
		name = "Dream Catcher",
		id = 49
	},
	[2573] = {
		name = "Default",
		id = 98
	},
	[2303] = {
		name = "Nobility Sign",
		id = 33
	},
	[5602] = {
		name = "Two-Handed Sword",
		id = 17
	},
	[2317] = {
		name = "Ritualistic Headdress",
		id = 46
	},
	[5932] = {
		name = "Trailblazer's Hat",
		id = 191
	},
	[2816] = {
		name = "Fear's Edge",
		id = 172
	},
	[2343] = {
		name = "Powerhold",
		id = 68
	},
	[2824] = {
		name = "Royal Rapier",
		id = 170
	},
	[2765] = {
		name = "Default",
		id = 158
	},
	[2741] = {
		name = "Intact Arms",
		id = 148
	},
	[5773] = {
		name = "Knight's Helmet",
		id = 23
	},
	[2725] = {
		name = "Dream Catcher",
		id = 136
	},
	[2823] = {
		name = "Brighthold",
		id = 169
	},
	[2822] = {
		name = "Default",
		id = 168
	},
	[5965] = {
		name = "Night's Crest",
		id = 193
	},
	[2693] = {
		name = "Powerhold",
		id = 121
	},
	[5857] = {
		name = "Trailblazer's Hat",
		id = 181
	},
	[2840] = {
		name = "Cavalier's Beret",
		id = 167
	},
	[2821] = {
		name = "Nobility Sign",
		id = 166
	},
	[2820] = {
		name = "Wanderer's Cap",
		id = 165
	},
	[2670] = {
		name = "Iron mask",
		id = 110
	},
	[2819] = {
		name = "Lucky Hat",
		id = 164
	},
	[2818] = {
		name = "Default",
		id = 163
	},
	[2817] = {
		name = "Spiritual",
		id = 16
	},
	[5906] = {
		name = "Ramshead Axe",
		id = 188
	},
	[2332] = {
		name = "Serrated Blades",
		id = 58
	},
	[5774] = {
		name = "Bestial Maw",
		id = 24
	},
	[2353] = {
		name = "Intact Haircut",
		id = 77
	},
	[2345] = {
		name = "Default",
		id = 70
	},
	[2582] = {
		name = "Wolfsfang Bow",
		id = 105
	},
	[2272] = {
		name = "Wyrmskull Visage",
		id = 5
	},
	[2280] = {
		name = "Elven Haircut",
		id = 12
	},
	[2288] = {
		name = "Wolfsfang Bow",
		id = 20
	},
	[2305] = {
		name = "Wanderer's Cap",
		id = 35
	},
	[2282] = {
		name = "Dashing Headgear",
		id = 14
	},
	[2700] = {
		name = "Demonskull staff",
		id = 128
	},
	[2295] = {
		name = "Draconic Arms",
		id = 31
	},
	[5913] = {
		name = "Bull's Fury",
		id = 187
	},
	[2335] = {
		name = "Abyssal Blades",
		id = 61
	},
	[2758] = {
		name = "Sanctified Adorning",
		id = 146
	},
	[2766] = {
		name = "Skullsplitter Axe",
		id = 159
	},
	[2742] = {
		name = "Lustrous Protection",
		id = 149
	},
	[5775] = {
		name = "Iceguard",
		id = 25
	},
	[2726] = {
		name = "Default",
		id = 135
	},
	[2734] = {
		name = "Holy",
		id = 14
	},
	[2339] = {
		name = "Default",
		id = 64
	},
	[2718] = {
		name = "Bone Mask",
		id = 132
	},
	[2694] = {
		name = "Bright Robes",
		id = 122
	},
	[2301] = {
		name = "Spiritual",
		id = 4
	},
	[2699] = {
		name = "Igneas Ice Staff",
		id = 127
	},
	[2338] = {
		name = "Wizard",
		id = 7
	},
	[2287] = {
		name = "Drakebane",
		id = 19
	},
	[2671] = {
		name = "Dark Shroud",
		id = 111
	},
	[2286] = {
		name = "Elderbark Bow",
		id = 18
	},
	[2319] = {
		name = "Default",
		id = 48
	},
	[2631] = {
		name = "Relic of Light",
		id = 87
	},
	[2294] = {
		name = "Snowfall Endurer",
		id = 30
	},
	[5776] = {
		name = "Draconic Crown",
		id = 26
	},
	[2362] = {
		name = "Pristine Relic",
		id = 86
	},
	[2354] = {
		name = "Bright Tiara",
		id = 78
	},
	[2346] = {
		name = "Crystal Eye Staff",
		id = 71
	},
	[2583] = {
		name = "Arcana Bow",
		id = 106
	},
	[2273] = {
		name = "Default",
		id = 6
	},
	[2322] = {
		name = "Ravensong Enchanter",
		id = 51
	},
	[2575] = {
		name = "Marksman Hat",
		id = 100
	},
	[2306] = {
		name = "Cavalier's Hat",
		id = 36
	},
	[2815] = {
		name = "Bloodletter",
		id = 171
	},
	[2716] = {
		name = "Living Thorns",
		id = 131
	},
	[5920] = {
		name = "Ramshead Axe",
		id = 186
	},
	[2715] = {
		name = "Strange Garb",
		id = 130
	},
	[2717] = {
		name = "Default",
		id = 129
	},
	[2714] = {
		name = "Witchcraft",
		id = 13
	},
	[2767] = {
		name = "Ornate Waraxe",
		id = 160
	},
	[2743] = {
		name = "Brightstar",
		id = 150
	},
	[2698] = {
		name = "Light's Catalyst",
		id = 126
	},
	[2340] = {
		name = "Not-so-Magical Hat",
		id = 65
	},
	[2735] = {
		name = "Default",
		id = 141
	},
	[2289] = {
		name = "Arcana Bow",
		id = 21
	},
	[2719] = {
		name = "Ritualistic Headdress",
		id = 133
	},
	[2695] = {
		name = "Default",
		id = 123
	},
	[2361] = {
		name = "Brightstar",
		id = 85
	},
	[2672] = {
		name = "Hidden Blades",
		id = 115
	},
	[2284] = {
		name = "Default",
		id = 16
	},
	[5937] = {
		name = "Exorcist's Saber",
		id = 192
	},
	[2667] = {
		name = "Default",
		id = 107
	},
	[2318] = {
		name = "Ravencloth",
		id = 47
	},
	[2613] = {
		name = "Draconic Arms",
		id = 97
	},
	[2321] = {
		name = "Skulls of Possession",
		id = 50
	},
	[5858] = {
		name = "Exorcist's Saber",
		id = 182
	},
	[2608] = {
		name = "Protection",
		id = 9
	},
	[2315] = {
		name = "Living thorns",
		id = 44
	},
	[2355] = {
		name = "Dawn's Guider",
		id = 79
	},
	[2347] = {
		name = "Wildfire Staff",
		id = 72
	},
	[2576] = {
		name = "Dashing Headgear",
		id = 62
	},
	[2331] = {
		name = "Default",
		id = 57
	},
	[2323] = {
		name = "Livingthorn Staff",
		id = 197
	},
	[2290] = {
		name = "Protection",
		id = 3
	},
	[2307] = {
		name = "Default",
		id = 37
	},
	[2314] = {
		name = "Strange Garb",
		id = 43
	},
	[2313] = {
		name = "Default",
		id = 42
	},
	[2312] = {
		name = "Witchcraft",
		id = 5
	},
	[2768] = {
		name = "Darksteel Axe",
		id = 161
	},
	[2572] = {
		name = "Archer",
		id = 10
	},
	[2304] = {
		name = "Lucky Hat",
		id = 34
	},
	[2760] = {
		name = "Warfare",
		id = 15
	},
	[2736] = {
		name = "Intact Haircut",
		id = 142
	},
	[2744] = {
		name = "Pristine Relic",
		id = 151
	},
	[2720] = {
		name = "Ravencloth",
		id = 134
	},
	[2293] = {
		name = "Bandit Breaker",
		id = 29
	},
	[2291] = {
		name = "Golden Protector",
		id = 27
	},
	[2329] = {
		name = "Iron mask",
		id = 55
	},
	[2688] = {
		name = "Wizard",
		id = 12
	},
	[2696] = {
		name = "Crystal Eye Staff",
		id = 124
	},
	[2673] = {
		name = "Curved Blades",
		id = 114
	},
	[2279] = {
		name = "Default",
		id = 11
	},
	[2271] = {
		name = "Thergardian Helmet",
		id = 4
	},
	[5772] = {
		name = "Winged Protector",
		id = 22
	},
	[5601] = {
		name = "Default",
		id = 183
	},
	[2281] = {
		name = "Marksman Hat",
		id = 13
	},
	[2267] = {
		name = "Warfare",
		id = 1
	},
	[2311] = {
		name = "Fear's Edge",
		id = 41
	},
	[2609] = {
		name = "Golden Protector",
		id = 93
	},
	[2283] = {
		name = "Trapper Hood",
		id = 15
	},
	[2356] = {
		name = "Blessed Hood",
		id = 80
	},
	[2348] = {
		name = "Light's Catalyst",
		id = 73
	},
	[2577] = {
		name = "Trapper Hood",
		id = 63
	},
	[2275] = {
		name = "Ornate Waraxe",
		id = 8
	},
	[2324] = {
		name = "Hex Staff",
		id = 198
	},
	[2316] = {
		name = "Bone Crown",
		id = 45
	},
	[2308] = {
		name = "Brighthold",
		id = 38
	},
	[2326] = {
		name = "Default",
		id = 52
	},
	[5940] = {
		name = "Default",
		id = 180
	},
	[2330] = {
		name = "Dark Shroud",
		id = 56
	},
	[2769] = {
		name = "Ominous Axe",
		id = 162
	},
	[2333] = {
		name = "Curved Blades",
		id = 59
	},
	[2334] = {
		name = "Hidden Blades",
		id = 60
	},
	[2761] = {
		name = "Dwarven Braiding",
		id = 154
	},
	[2737] = {
		name = "Bright Tiara",
		id = 143
	},
	[2745] = {
		name = "Relic of Light",
		id = 152
	},
	[2721] = {
		name = "Hex Staff",
		id = 140
	},
	[2270] = {
		name = "Ornamental Helmet",
		id = 3
	},
	[5794] = {
		name = "Default",
		id = 177
	},
	[2341] = {
		name = "Starseeker Hat",
		id = 66
	},
	[2689] = {
		name = "Default",
		id = 117
	},
	[2697] = {
		name = "Wildfire Staff",
		id = 125
	},
	[2674] = {
		name = "Abyssal Blades",
		id = 116
	},
	[5893] = {
		name = "Wanderer's Veil",
		id = 189
	},
	[2574] = {
		name = "Elven Haircut",
		id = 99
	},
	[2666] = {
		name = "Shadow",
		id = 11
	},
	[5603] = {
		name = "Default",
		id = 184
	},
	[2269] = {
		name = "Dwarven Beard",
		id = 2
	},
	[2578] = {
		name = "Default",
		id = 101
	},
	[2579] = {
		name = "Curved Bow",
		id = 102
	},
	[2610] = {
		name = "Magical Sigils",
		id = 94
	},
	[6174] = {
		name = "Two-Handed Sword",
		id = 18
	},
	[6153] = {
		name = "Rebel Punk",
		id = 200
	},
	[6154] = {
		name = "Aspiring Warrior",
		id = 201
	},
	[6155] = {
		name = "Esteemed Adventurer",
		id = 202
	},
	[6156] = {
		name = "General's Cut",
		id = 203
	},
	[6157] = {
		name = "Headhunter",
		id = 204
	},
	[6158] = {
		name = "Crimson Claymore",
		id = 205
	},
	[6159] = {
		name = "Strifeblade",
		id = 206
	},
	[6160] = {
		name = "Crescent Sun",
		id = 207
	},
	[6161] = {
		name = "Dreadbane Reaver",
		id = 208
	},
	[6162] = {
		name = "Dragonfang",
		id = 209
	},
	[6199] = {
		name = "Default",
		id = 210
	},
	[6200] = {
		name = "Rebel Punk",
		id = 211
	},
	[6201] = {
		name = "Aspiring Warrior",
		id = 212
	},
	[6202] = {
		name = "Esteemed Adventurer",
		id = 213
	},
	[6203] = {
		name = "Warmaiden",
		id = 214
	},
	[6204] = {
		name = "Headhunter",
		id = 215
	},
	[6229] = {
		name = "Default",
		id = 216
	},
	[6230] = {
		name = "Crimson Claymore",
		id = 217
	},
	[6231] = {
		name = "Strifeblade",
		id = 218
	},
	[6232] = {
		name = "Crescent Sun",
		id = 219
	},
	[6233] = {
		name = "Dreadbane Reaver",
		id = 220
	},
	[6234] = {
		name = "Dragonfang",
		id = 221
	},
	[7264] = {
		name = "Elder Helm",
		id = 294
	},
	[7338] = {
		name = "Elder Helm",
		id = 300
	},
	[7294] = {
		name = "Berserker Horns",
		id = 295
	},
	[7368] = {
		name = "Berserker Horns",
		id = 301
	},
	[7309] = {
		name = "Dreadmask",
		id = 296
	},
	[7383] = {
		name = "Dreadmask",
		id = 302
	},
	[7257] = {
		name = "The Pendulum",
		id = 297
	},
	[7331] = {
		name = "The Pendulum",
		id = 303
	},
	[7287] = {
		name = "Toxic Despoiler",
		id = 298
	},
	[7361] = {
		name = "Toxic Despoiler",
		id = 304
	},
	[7301] = {
		name = "Infernal Punisher",
		id = 299
	},
	[7376] = {
		name = "Infernal Punisher",
		id = 305
	},
	[7485] = {
		name = "Trapper Hood II",
		id = 312
	},
	[7479] = {
		name = "Trapper Hood II",
		id = 315
	},
	[7486] = {
		name = "Dashing Headgear II",
		id = 313
	},
	[7480] = {
		name = "Dashing Headgear II",
		id = 316
	},
	[7487] = {
		name = "Wanderer's Veil II",
		id = 314
	},
	[7481] = {
		name = "Wanderer's Veil II",
		id = 317
	},
	[6811] = {
		name = "Amber Arc",
		id = 257
	},
	[6793] = {
		name = "Amber Arc",
		id = 254
	},
	[6805] = {
		name = "Royal Sharpshooter",
		id = 258
	},
	[6787] = {
		name = "Royal Sharpshooter",
		id = 255
	},
	[6817] = {
		name = "Mystwood Azure",
		id = 259
	},
	[6799] = {
		name = "Mystwood Azure",
		id = 256
	},
	[6472] = {
		name = "Lionheart Visor",
		id = 223
	},
	[6681] = {
		name = "Lionheart Visor",
		id = 239
	},
	[6505] = {
		name = "Necrotic Guard",
		id = 225
	},
	[6711] = {
		name = "Necrotic Guard",
		id = 241
	},
	[6523] = {
		name = "Radiant Plate",
		id = 226
	},
	[6726] = {
		name = "Radiant Plate",
		id = 242
	},
	[6570] = {
		name = "Oathbreaker Helm",
		id = 229
	},
	[6771] = {
		name = "Oathbreaker Helm",
		id = 245
	},
	[6474] = {
		name = "Verdant Vindicator",
		id = 231
	},
	[6691] = {
		name = "Verdant Vindicator",
		id = 247
	},
	[6507] = {
		name = "Necrotic Armament",
		id = 233
	},
	[6721] = {
		name = "Necrotic Armament",
		id = 249
	},
	[6525] = {
		name = "Radiant Aegis",
		id = 234
	},
	[6736] = {
		name = "Radiant Aegis",
		id = 250
	},
	[6572] = {
		name = "Oathbreaker Arms",
		id = 237
	},
	[6781] = {
		name = "Oathbreaker Arms",
		id = 253
	},
	[7527] = {
		name = "Wanderer's Cap II",
		id = 321
	},
	[7533] = {
		name = "Wanderer's Cap II",
		id = 318
	},
	[7528] = {
		name = "Cavalier's Hat II",
		id = 322
	},
	[7534] = {
		name = "Cavalier's Beret II",
		id = 319
	},
	[7529] = {
		name = "Trailblazer's Hat II",
		id = 323
	},
	[7535] = {
		name = "Trailblazer's Hat II",
		id = 320
	},
	[6631] = {
		name = "White Fang",
		id = 263
	},
	[6626] = {
		name = "White Fang",
		id = 260
	},
	[6651] = {
		name = "Zephyr's Zing",
		id = 264
	},
	[6646] = {
		name = "Zephyr's Zing",
		id = 261
	},
	[6661] = {
		name = "Blood Lance",
		id = 265
	},
	[6656] = {
		name = "Blood Lance",
		id = 262
	},
	[7100] = {
		name = "Moonlight Coronet",
		id = 280
	},
	[7024] = {
		name = "Moonlight Coronet",
		id = 272
	},
	[7120] = {
		name = "Briarwood Regalia",
		id = 281
	},
	[7039] = {
		name = "Briarwood Regalia",
		id = 273
	},
	[7138] = {
		name = "Shadow Plume",
		id = 282
	},
	[7057] = {
		name = "Shadow Plume",
		id = 274
	},
	[7159] = {
		name = "Bloodskull",
		id = 283
	},
	[7078] = {
		name = "Bloodskull",
		id = 275
	},
	[7101] = {
		name = "Silverthorn Staff",
		id = 284
	},
	[7025] = {
		name = "Silverthorn Staff",
		id = 276
	},
	[7121] = {
		name = "Thornhart Staff",
		id = 285
	},
	[7040] = {
		name = "Thornhart Staff",
		id = 277
	},
	[7139] = {
		name = "Soul Snare",
		id = 286
	},
	[7058] = {
		name = "Soul Snare",
		id = 278
	},
	[7160] = {
		name = "Cerberus Whisper",
		id = 287
	},
	[7079] = {
		name = "Cerberus Whisper",
		id = 279
	},
	[7521] = {
		name = "Iron mask II",
		id = 324
	},
	[7515] = {
		name = "Iron mask II",
		id = 327
	},
	[7522] = {
		name = "Dark Shroud II",
		id = 325
	},
	[7516] = {
		name = "Dark Shroud II",
		id = 328
	},
	[7523] = {
		name = "Night's Crest II",
		id = 326
	},
	[7517] = {
		name = "Night's Crest II",
		id = 329
	},
	[7198] = {
		name = "Final Flash",
		id = 288
	},
	[7229] = {
		name = "Final Flash",
		id = 291
	},
	[7205] = {
		name = "Twilight Terrors",
		id = 289
	},
	[7237] = {
		name = "Twilight Terrors",
		id = 292
	},
	[7217] = {
		name = "Dual Destinies",
		id = 290
	},
	[7248] = {
		name = "Dual Destinies",
		id = 293
	},
	[7581] = {
		name = "Enchanted Hat II",
		id = 331
	},
	[7575] = {
		name = "Enchanted Hat II",
		id = 334
	},
	[7582] = {
		name = "Bright Robes II",
		id = 332
	},
	[7576] = {
		name = "Bright Robes II",
		id = 335
	},
	[7583] = {
		name = "Powerhold II",
		id = 333
	},
	[7577] = {
		name = "Powerhold II",
		id = 336
	},
	[6827] = {
		name = "Unholy Catalyst",
		id = 306
	},
	[6837] = {
		name = "Unholy Catalyst",
		id = 309
	},
	[7172] = {
		name = "Sunfire Staff",
		id = 307
	},
	[7182] = {
		name = "Sunfire Staff",
		id = 310
	},
	[6847] = {
		name = "Netherflame",
		id = 308
	},
	[6857] = {
		name = "Netherflame",
		id = 311
	},
	[7545] = {
		name = "Esteemed Adventurer II",
		id = 337
	},
	[7539] = {
		name = "Esteemed Adventurer II",
		id = 340
	},
	[7546] = {
		name = "General's Cut II",
		id = 338
	},
	[7540] = {
		name = "Warmaiden II",
		id = 341
	},
	[7547] = {
		name = "Headhunter II",
		id = 339
	},
	[7541] = {
		name = "Headhunter II",
		id = 342
	},
	[6863] = {
		name = "Heartstone Cleaver",
		id = 266
	},
	[6881] = {
		name = "Heartstone Cleaver",
		id = 269
	},
	[6869] = {
		name = "Gilded Phoenix",
		id = 267
	},
	[6887] = {
		name = "Gilded Phoenix",
		id = 270
	},
	[6875] = {
		name = "Voidbringer",
		id = 268
	},
	[6893] = {
		name = "Voidbringer",
		id = 271
	},
	[7447] = {
		name = "Pilgrim Hood",
		id = 343
	},
	[7673] = {
		name = "Watcher's Eye",
		id = 344
	},
	[7607] = {
		name = "Void Ward",
		id = 345
	},
	[7448] = {
		name = "Crusader Regalia",
		id = 346
	},
	[7409] = {
		name = "Unholy Crucible",
		id = 347
	},
	[7608] = {
		name = "Cosmic Chalice",
		id = 348
	},
	[7736] = {
		name = "Pilgrim Hood",
		id = 349
	},
	[7423] = {
		name = "Watcher's Eye",
		id = 350
	},
	[7634] = {
		name = "Void Ward",
		id = 351
	},
	[7476] = {
		name = "Crusader Regalia",
		id = 352
	},
	[7429] = {
		name = "Unholy Crucible",
		id = 353
	},
	[7635] = {
		name = "Cosmic Chalice",
		id = 354
	},
	[6639] = {
		name = "Two-Handed Hammer",
		id = 20
	},
	[7894] = {
		name = "Default",
		id = 366
	},
	[7889] = {
		name = "Knight's Pauldrons",
		id = 367
	},
	[7890] = {
		name = "Noble Shoulderguards",
		id = 368
	},
	[7891] = {
		name = "Paladin's Protectors",
		id = 369
	},
	[7974] = {
		name = "Ancient Sunscale",
		id = 384
	},
	[7892] = {
		name = "Thergardian Plate",
		id = 370
	},
	[7989] = {
		name = "Battlemaster Mail",
		id = 386
	},
	[7893] = {
		name = "Doomskull",
		id = 371
	},
	[8004] = {
		name = "Spectral Hauberk",
		id = 388
	},
	[6621] = {
		name = "Default",
		id = 372
	},
	[6616] = {
		name = "Sledge",
		id = 373
	},
	[6617] = {
		name = "Nadziak",
		id = 374
	},
	[6618] = {
		name = "Paladin's Justice",
		id = 375
	},
	[7982] = {
		name = "The Redeemer",
		id = 385
	},
	[6619] = {
		name = "Icebreaker",
		id = 376
	},
	[7997] = {
		name = "Dreadnought",
		id = 387
	},
	[6620] = {
		name = "Bonecrusher",
		id = 377
	},
	[8012] = {
		name = "Monstrosity's End",
		id = 389
	},
	[6237] = {
		name = "Two-Handed Hammer",
		id = 19
	},
	[6401] = {
		name = "Default",
		id = 355
	},
	[6396] = {
		name = "Knight's Pauldrons",
		id = 356
	},
	[6397] = {
		name = "Noble Shoulderguards",
		id = 357
	},
	[6398] = {
		name = "Paladin's Protectors",
		id = 358
	},
	[6908] = {
		name = "Ancient Sunscale",
		id = 382
	},
	[6399] = {
		name = "Thergardian Plate",
		id = 359
	},
	[7766] = {
		name = "Battlemaster Mail",
		id = 378
	},
	[6400] = {
		name = "Doomskull",
		id = 360
	},
	[7781] = {
		name = "Spectral Hauberk",
		id = 380
	},
	[6341] = {
		name = "Default",
		id = 361
	},
	[6342] = {
		name = "Sledge",
		id = 362
	},
	[7967] = {
		name = "Nadziak",
		id = 454
	},
	[6343] = {
		name = "Paladin's Justice",
		id = 363
	},
	[6907] = {
		name = "The Redeemer",
		id = 383
	},
	[6344] = {
		name = "Icebreaker",
		id = 364
	},
	[7765] = {
		name = "Dreadnought",
		id = 379
	},
	[6440] = {
		name = "Bonecrusher",
		id = 365
	},
	[7780] = {
		name = "Monstrosity's End",
		id = 381
	},
	[7947] = {
		name = "Mace and Shield",
		id = 21
	},
	[7948] = {
		name = "Default",
		id = 390
	},
	[7949] = {
		name = "Golden Helm",
		id = 391
	},
	[7950] = {
		name = "Knightly Plume",
		id = 392
	},
	[7951] = {
		name = "Justiciar Crest",
		id = 393
	},
	[8270] = {
		name = "Courageous Visage",
		id = 414
	},
	[7952] = {
		name = "Runeguard",
		id = 394
	},
	[8280] = {
		name = "Riftsands Protector",
		id = 416
	},
	[7953] = {
		name = "Ethereal Oath",
		id = 395
	},
	[8290] = {
		name = "Darkness Chosen",
		id = 418
	},
	[8300] = {
		name = "Spectral Visage",
		id = 420
	},
	[7954] = {
		name = "Default",
		id = 396
	},
	[7955] = {
		name = "Golden Guardian",
		id = 397
	},
	[7956] = {
		name = "Sworn Defender",
		id = 398
	},
	[7957] = {
		name = "Providence",
		id = 399
	},
	[8271] = {
		name = "Courageous Arms",
		id = 415
	},
	[7958] = {
		name = "Runic Protector",
		id = 400
	},
	[8281] = {
		name = "Riftsands Guardian",
		id = 417
	},
	[7959] = {
		name = "Eldritch Gift",
		id = 401
	},
	[8291] = {
		name = "Darkness Binding",
		id = 419
	},
	[8301] = {
		name = "Spectral Armaments",
		id = 421
	},
	[8039] = {
		name = "Mace and Shield",
		id = 22
	},
	[8044] = {
		name = "Default",
		id = 402
	},
	[8057] = {
		name = "Golden Helm",
		id = 403
	},
	[8070] = {
		name = "Knightly Plume",
		id = 404
	},
	[8083] = {
		name = "Justiciar Crest",
		id = 405
	},
	[8313] = {
		name = "Courageous Visage",
		id = 422
	},
	[8096] = {
		name = "Runeguard",
		id = 406
	},
	[8326] = {
		name = "Riftsands Protector",
		id = 424
	},
	[8109] = {
		name = "Ethereal Oath",
		id = 407
	},
	[8339] = {
		name = "Darkness Chosen",
		id = 426
	},
	[8352] = {
		name = "Spectral Visage",
		id = 428
	},
	[8049] = {
		name = "Default",
		id = 408
	},
	[8062] = {
		name = "Golden Guardian",
		id = 409
	},
	[8075] = {
		name = "Sworn Defender",
		id = 410
	},
	[8088] = {
		name = "Providence",
		id = 411
	},
	[8314] = {
		name = "Courageous Arms",
		id = 423
	},
	[8101] = {
		name = "Runic Protector",
		id = 412
	},
	[8327] = {
		name = "Riftsands Guardian",
		id = 425
	},
	[8114] = {
		name = "Eldritch Gift",
		id = 413
	},
	[8340] = {
		name = "Darkness Binding",
		id = 427
	},
	[8353] = {
		name = "Spectral Armaments",
		id = 429
	},
	[8124] = {
		name = "Dual Wield Axe",
		id = 23
	},
	[8136] = {
		name = "Default",
		id = 430
	},
	[8148] = {
		name = "Simple Fur Padding",
		id = 431
	},
	[8160] = {
		name = "Fine Fur Cloak",
		id = 432
	},
	[8178] = {
		name = "Predator Cape",
		id = 433
	},
	[8196] = {
		name = "Apex Mantle",
		id = 434
	},
	[8214] = {
		name = "Dread Carapace",
		id = 435
	},
	[8221] = {
		name = "Default",
		id = 436
	},
	[8222] = {
		name = "Berserker Hatchets",
		id = 437
	},
	[8223] = {
		name = "Blacksteel Axes",
		id = 438
	},
	[8224] = {
		name = "Bloody Reavers",
		id = 439
	},
	[8225] = {
		name = "Twin Suns",
		id = 440
	},
	[8226] = {
		name = "Corpse Cleavers",
		id = 441
	},
	[8694] = {
		name = "Alpha Cloak",
		id = 460
	},
	[8623] = {
		name = "Coral Crown",
		id = 458
	},
	[8641] = {
		name = "Infernal Carapace",
		id = 459
	},
	[8603] = {
		name = "Grove Terrors",
		id = 455
	},
	[8622] = {
		name = "Coral Rippers",
		id = 456
	},
	[8640] = {
		name = "Hellfire Hackers",
		id = 457
	},
	[8482] = {
		name = "Dual Wield Axe",
		id = 24
	},
	[8495] = {
		name = "Default",
		id = 442
	},
	[8508] = {
		name = "Simple Fur Padding",
		id = 443
	},
	[8526] = {
		name = "Fine Fur Cloak",
		id = 444
	},
	[8545] = {
		name = "Predator Cape",
		id = 445
	},
	[8564] = {
		name = "Apex Mantle",
		id = 446
	},
	[8583] = {
		name = "Dread Carapace",
		id = 447
	},
	[8494] = {
		name = "Default",
		id = 448
	},
	[8507] = {
		name = "Berserker Hatchets",
		id = 449
	},
	[8525] = {
		name = "Blacksteel Axes",
		id = 450
	},
	[8544] = {
		name = "Bloody Reavers",
		id = 451
	},
	[8563] = {
		name = "Twin Suns",
		id = 452
	},
	[8582] = {
		name = "Corpse Cleavers",
		id = 453
	},
	[8695] = {
		name = "Alpha Cloak",
		id = 461
	},
	[8673] = {
		name = "Coral Circlet",
		id = 462
	},
	[8692] = {
		name = "Infernal Carapace",
		id = 463
	},
	[8654] = {
		name = "Grove Terrors",
		id = 465
	},
	[8672] = {
		name = "Coral Rippers",
		id = 466
	},
	[8691] = {
		name = "Hellfire Hackers",
		id = 467
	},
	[8416] = {
		name = "Necromancer Jukes",
		id = 25
	},
	[8425] = {
		name = "Default",
		id = 468
	}
}
WagonParts = {
	[3012] = {
		name = "Old Wagon",
		weight = 100,
		health = 2100,
		tier = 1,
		capacity = 1
	},
	[5304] = {
		name = "Small Wagon",
		weight = 110,
		health = 2800,
		tier = 2,
		capacity = 2
	},
	[3015] = {
		name = "Common Wagon",
		weight = 120,
		health = 3500,
		tier = 3,
		capacity = 3
	},
	[5301] = {
		name = "Medium Wagon",
		weight = 130,
		health = 4500,
		tier = 4,
		capacity = 4
	},
	[3018] = {
		name = "Deluxe Wagon",
		weight = 140,
		health = 6000,
		tier = 5,
		capacity = 5
	}
}
WagonCosmetics = {
	[3006] = {
		name = "Founder's Wagon",
		type = "wagon skin",
		description = "Become the envy of the realm as you travel in luxury and style. The golden raven upon your wagon clearly demonstrating your ties to the royal court in Ravencrest."
	},
	[3009] = {
		name = "Dark Ritualist Wagon",
		type = "wagon skin",
		description = "Transforms your mundane transport into a chariot of shadows, as you traverse the realms through the darkness."
	},
	[6090] = {
		name = "Trailblazer Wagon",
		type = "wagon skin",
		description = "Based on designs that the first settlers of Ravendawn used to claim these wild, untamed lands, travel in style and security as you continue their great legacy!"
	},
	[6097] = {
		name = "Adventurer Wagon",
		type = "wagon skin",
		description = "From bustling trade routes to the challenges of open wilderness, the rugged yet luxurious Adventurer Wagon offers all the comforts any daring adventurer needs to make their journeys a thrilling breeze."
	},
	[6166] = {
		name = "Carnival Wagon",
		type = "wagon skin",
		description = "From its intricately decorated exterior to its plush, velvet interior, every detail of the Carnival Wagon is a delight of joy and merriment. Bring the festivity wherever your travels take you!"
	},
	[6421] = {
		name = "Cinderskull Wagon",
		type = "wagon skin",
		description = "The bell tolls for all who still draw breath. Ward off bandits and children everywhere with this terrifying carriage of fire and occult fashions."
	},
	[8771] = {
		name = "Kingmaker Wagon",
		type = "wagon skin",
		description = "A chariot fit for kings. The fine craftsmanship and regal adornment of the Kingmaker Wagon reflect a dedication to greatness and brilliance on the battlefield. This bastion on wheels will ensure your supplies and gear are well protected while you plan your strategy and command your forces."
	},
	[8748] = {
		name = "War Rider Wagon",
		type = "wagon skin",
		description = "Victory loves preparation, the War Rider Wagon guarantees both. Either for hauling your bearings and supplies to distant battlefields, or securing the well-earned spoils of war, this moving fortress is made for mighty warlords. Ready for war, ready for glory!"
	}
}
MoaEquipment = {
	[5565] = {
		name = "Basic Barding",
		type = "moa equipment",
		description = "Uncomplicated yet dependable, crafted for comfort and control, ensuring a smooth ride for both rider and Moa. No additional effect."
	},
	[5520] = {
		name = "Simple Barding",
		type = "moa equipment",
		description = "A humble moa gear which concedes minor protection and mobility to the wearer. Increases moa speed by 4, moa strength by 5 and reduces the chance of being dismounted by 5%."
	},
	[5522] = {
		name = "Composed Barding",
		type = "moa equipment",
		description = "Moa gear which gives regular benefits despite its ordinary design. Increases moa speed by 7, moa strength by 8 and reduces the chance of being dismounted by 10%."
	},
	[5527] = {
		name = "Advanced Barding",
		type = "moa equipment",
		description = "Though not extraordinary, this moa gear was clearly crafted by skilled hands. Increases moa speed by 10, moa strength by 12 and reduces the chance of being dismounted by 15%."
	},
	[5532] = {
		name = "Artisan Barding",
		type = "moa equipment",
		description = "Clearly designed by very capable hands, this moa gear provides balanced benefits to its wearer. Increases moa speed by 14, moa strength by 18 and reduces the chance of being dismounted by 20%."
	},
	[5537] = {
		name = "Superior Barding",
		type = "moa equipment",
		description = "Top-notch moa gear crafted by a sound professional using high quality materials. Increases moa speed by 20, moa strength by 23 and reduces the chance of being dismounted by 25%."
	},
	[6076] = {
		name = "War Barding",
		type = "moa equipment",
		description = "Giving enough protection and mobility for the most extreme situations, this gear could easily be used by someone riding straight to the battlefield. Increases moa speed by 26, moa strength by 28 and reduces the chance of being dismounted by 40%."
	},
	[6074] = {
		name = "Explorer Barding",
		type = "moa equipment",
		description = "Ideal for anyone venturing into uncharted territory, this gear will never leave the mounter helpless while still providing superb mobility. Increases moa speed by 35 moa strength by 26 and reduces the chance of being dismounted by 28%."
	},
	[6075] = {
		name = "Professional Barding",
		type = "moa equipment",
		description = "An indispensable asset for anyone carrying out trading duties, this gear enhances the moa's weight carrying capabilities. Increases moa speed by 28, moa strength by 37 and reduces the chance of being dismounted by 31%."
	}
}
MoaCosmetics = {
	[0] = {
		name = "Moonlight Moa",
		type = "moa skin",
		description = "A celestial creature adorned in the luminescent glow of the night sky. Its feathers, bathed in silver and opalescent hues, capture the essence of moonbeams weaving through the night."
	},
	[2413] = {
		name = "Radiant Moa Armor",
		type = "moa skin",
		description = "This proud and resplendent armor will single you out as a true aristocrat of the realm. How you wield this honor is for you to decide."
	},
	[2662] = {
		name = "Dark Ritualist Moa Armor",
		type = "moa skin",
		description = "Transform your moa into a shadow steed with the Dark Ritualist Armor, woven from shadow silk and adorned with ancient glyphs, this armor is sure to spread terror among your enemies."
	},
	[5562] = {
		name = "Pathfinder Moa Armor",
		type = "moa skin",
		description = "Crafted from durable materials and adorned with practical yet stylish details, this armor ensures your moa is ready for the challenges of unexplored realms with style."
	},
	[5563] = {
		name = "Noble Moa Armor",
		type = "moa skin",
		description = "Show off the high pedigree and experience of your moa with this highly sought after armor. The sturdy, yet flexible material is adorned with golden stitching and prestigious symbols of royal authority."
	},
	[5564] = {
		name = "Royal Moa Armor",
		type = "moa skin",
		description = "Bestow regal grace upon your feathered companion with the Royal Moa Armor, a majestic ensemble that transforms your moa into a symbol of aristocratic grandeur."
	},
	[6033] = {
		name = "Legendary Moa Armor",
		type = "moa skin",
		description = "This piece of master craftsmanship date back to Lucien's landing, when Saint Dunstan used the very rays of the Dawn itself to bind the metal together. According to legend he only made enough to outfit the first Ravenscout expedition and today we have but a few sets remaining."
	},
	[6167] = {
		name = "Carnival Moa Armor",
		type = "moa skin",
		description = "An energetic ensemble of vibrant colors and extravagance, don your Moa with this exquisite Carnival Moa Armor and your beloved riding companion will be the center of attention at any festival."
	},
	[6092] = {
		name = "Trailblazer Moa Armor",
		type = "moa skin",
		description = "This interlocking, flexible armor keeps your Moa comfortable, yet protected. It is the natural choice of the highest ranking Ravenscouts for a reason."
	},
	[6098] = {
		name = "Adventurer Moa Armor",
		type = "moa skin",
		description = "Outfit your feathered companion with the Adventurer Moa Armor and claim your place in the annals of history as you seek to uncover the secrets hidden across Ravendawn!"
	},
	[6415] = {
		name = "Cinderskull Moa Armor",
		type = "moa skin",
		description = "Some breeders become so attached to their treasure Moas that they simply cannot let them go, even in death. With the application of dark magic, you too can tear a hole in the fabric of reality to restore your beloved companion to a burning un-life."
	},
	[8768] = {
		name = "Kingmaker Moa",
		type = "moa skin",
		description = "Embrace the spirit of a true champion with the Kingmaker Moa. This noble steed will carry you gracefully into every battle, as you command your allies with unwavering resolve and peerless tactics, leading your forces to glory and victory."
	},
	[8742] = {
		name = "War Rider Moa",
		type = "moa skin",
		description = "Arise, arise, riders of Ravendawn! Great battles await, for glory and honor! Lead the vanguard and conquer the battlefield with the War Rider Moa. This fearless steed will charge forward to victory as you outmaneuver your opponents with style and inspire those under your command."
	},
	[9385] = {
		name = "Year 1 Anniversary Armor",
		type = "moa skin",
		description = "Fancy dress has a different meaning for Moas."
	}
}
MoaTraits = {
	[TRAIT_NONE] = {
		name = "None",
		description = ""
	},
	[TRAIT_NIGHTWALKER] = {
		name = "Nightwalker",
		description = "This mount was born with nocturnal habits, gaining +20 speed and +10 strength during nighttime."
	},
	[TRAIT_SUNSTRIDER] = {
		name = "Sunstrider",
		description = "This mount was born with a passion for sunlight, gaining +20 speed and +10 strength during daytime."
	},
	[TRAIT_WAYFARER] = {
		name = "Wayfarer",
		description = "This mount was born with a natural talent for treading civilized paths, gaining +10 speed and +10 strength when traveling main roads."
	},
	[TRAIT_SAND_WANDERER] = {
		name = "Sand Wanderer",
		description = "This mount was born with desertic ascendance, gaining +25 speed and +10 strength when traveling through desertic terrain."
	},
	[TRAIT_PLAINS_RIDER] = {
		name = "Plains Rider",
		description = "This mount was born with a joyful love for lush grasslands, gaining +25 speed and +10 strength when traveling through grasslands."
	},
	[TRAIT_KING_OF_THE_TUNDRA] = {
		name = "King of the Tundra",
		description = "This mount was born with glacial ascendance, gaining +25 speed and +10 strength when traveling through glacial ambience."
	},
	[TRAIT_WARBROOD] = {
		name = "Warbrood",
		description = "This mount was born with a superb constitution, giving its mounter -20% chance of being dismounted when receiving damage."
	},
	[TRAIT_CAVE_DELVER] = {
		name = "Cave Delver",
		description = "This mount was born with the ability to enter and wander through underground ambience."
	},
	[TRAIT_PATHFINDER] = {
		name = "Pathfinder",
		description = "This mount was born as a natural explorer, gaining +7 speed and +5 strength when walking anywhere in the world."
	}
}
FishToSlice = {
	[28907] = 40832,
	[28905] = 40829,
	[28925] = 40825,
	[28924] = 40831,
	[28919] = 40833,
	[28904] = 40829,
	[28918] = 40827,
	[28920] = 40828,
	[28921] = 40831,
	[28911] = 40830,
	[28922] = 40828,
	[28913] = 40834,
	[28914] = 40826,
	[28926] = 40825,
	[28910] = 40826,
	[28912] = 40833,
	[28916] = 40833,
	[28917] = 40834,
	[38528] = 40828,
	[28908] = 40830,
	[39281] = 40828,
	[28915] = 40827,
	[28906] = 40832
}
FishSlices = {
	[40832] = {
		name = "Orange Scales",
		id = 40832,
		description = "Vibrant orange scales with a subtle oceanic aroma, perfect for adding a unique zest to any dish."
	},
	[40829] = {
		name = "Fish Roe",
		id = 40829,
		description = "Small, soft, and bursting with a salty, oceanic flavor. Often used as a garnish or added to sauces."
	},
	[40830] = {
		name = "Fish Skin",
		id = 40830,
		description = "This tough, leathery skin is covered in small, iridescent scales and has a slimy texture."
	},
	[40834] = {
		name = "Yellow Fish Roe",
		id = 40834,
		description = "Delicate, buttery eggs with a mild flavor, perfect for enhancing the taste of seafood."
	},
	[40826] = {
		name = "Fish Eye",
		id = 40826,
		description = "These eerie orbs can be used in divination, or ground into a fine powder for use in potions and elixirs."
	},
	[40833] = {
		name = "Red Fish Roe",
		id = 40833,
		description = "A rare delicacy prized for its brilliant red hue and subtle oceanic flavor. A must-have for any upscale dining"
	},
	[40827] = {
		name = "Fish Liver",
		id = 40827,
		description = "A slimy and pungent organ that can be used in alchemical preparations. It is said to have powerful effects on the mind and body."
	},
	[40828] = {
		name = "Fish Oil",
		id = 40828,
		description = "Rich in nutrients, fish liver can be distilled into a potent oil for medicinal purposes."
	},
	[40831] = {
		name = "Luminous Sack",
		id = 40831,
		description = "This bioluminescent organ can be used as a light source or crushed into a fine powder for magical effects."
	},
	[40825] = {
		name = "Black Fish Roe",
		id = 40825,
		description = "Plump, glossy eggs bursting with umami flavor and a velvety texture, prized by chefs for their exceptional quality."
	}
}
CompassSize = {
	7,
	17,
	31,
	51,
	71,
	101,
	151,
	201,
	251
}
CompassDefaultSize = CompassSize[5]
Waypoints = {
	{
		name = "Firslight",
		level = 0,
		offset = {
			y = 260,
			x = 497
		},
		position = {
			y = 4999,
			x = 6032,
			z = 4
		}
	},
	{
		name = "Saint Alsek",
		level = 0,
		offset = {
			y = 108,
			x = 90
		},
		position = {
			y = 4185,
			x = 4132,
			z = 6
		}
	},
	{
		name = "Kabbar Palace",
		level = 0,
		position = {
			y = 5292,
			x = 4938,
			z = 3
		}
	},
	{
		name = "Dras Ashar",
		level = 0,
		position = {
			y = 5688,
			x = 6335,
			z = 8
		}
	},
	{
		name = "Ravencrest",
		level = 0,
		offset = {
			y = 285,
			x = 310
		},
		position = {
			y = 5092,
			x = 5132,
			z = 6
		}
	},
	{
		name = "North Glademire",
		level = 8,
		offset = {
			y = 233,
			x = 335
		},
		position = {
			y = 4853,
			x = 5239,
			z = 5
		}
	},
	{
		name = "Rohna Woods",
		level = 10,
		offset = {
			y = 235,
			x = 270
		},
		position = {
			y = 4880,
			x = 4953,
			z = 7
		}
	},
	{
		name = "Forsaken Mountains",
		level = 45,
		offset = {
			y = 225,
			x = 390
		},
		position = {
			y = 4851,
			x = 5473,
			z = 6
		}
	},
	{
		name = "Sajecho Island",
		level = 20,
		offset = {
			y = 275,
			x = 225
		},
		position = {
			y = 5064,
			x = 4737,
			z = 6
		}
	},
	{
		name = "Harbor Island",
		level = 30,
		offset = {
			y = 290,
			x = 50
		},
		position = {
			y = 5116,
			x = 3962,
			z = 4
		}
	},
	{
		name = "Hadarak Desert",
		level = 35,
		offset = {
			y = 420,
			x = 410
		},
		position = {
			y = 5701,
			x = 5567,
			z = 5
		}
	},
	{
		name = "Gilead Island",
		level = 45,
		offset = {
			y = 455,
			x = 135
		},
		position = {
			y = 5865,
			x = 4356,
			z = 7
		}
	},
	{
		name = "Glaceforde",
		level = 45,
		offset = {
			y = 110,
			x = 193
		},
		position = {
			y = 4381,
			x = 4604,
			z = 6
		}
	},
	{
		name = "Zephyr Vale",
		level = 30,
		offset = {
			y = 310,
			x = 475
		},
		position = {
			y = 5236,
			x = 5845,
			z = 6
		}
	},
	{
		name = "Crowhollow Bog",
		level = 45,
		offset = {
			y = 250,
			x = 440
		},
		position = {
			y = 4947,
			x = 5718,
			z = 6
		}
	},
	{
		name = "Fields of Despair",
		level = 55,
		offset = {
			y = 158,
			x = 495
		},
		position = {
			y = 4612,
			x = 6000,
			z = 10
		}
	},
	{
		name = "The Blotch",
		level = 74,
		offset = {
			y = 188,
			x = 500
		},
		position = {
			y = 4695,
			x = 5998,
			z = 7
		}
	},
	{
		name = "Elder Coast",
		level = 55,
		offset = {
			y = 110,
			x = 193
		},
		position = {
			y = 4656,
			x = 5242,
			z = 6
		}
	},
	{
		name = "Frost Steppes",
		level = 60,
		offset = {
			y = 110,
			x = 193
		},
		position = {
			y = 4157,
			x = 5952,
			z = 4
		}
	},
	{
		name = "South Glademire",
		level = 15,
		offset = {
			y = 110,
			x = 193
		},
		position = {
			y = 5029,
			x = 5320,
			z = 5
		}
	},
	{
		name = "Bastion",
		level = 30,
		offset = {
			y = 110,
			x = 193
		},
		position = {
			y = 5221,
			x = 5635,
			z = 7
		}
	},
	{
		name = "Dras Marna",
		level = 35,
		offset = {
			y = 110,
			x = 193
		},
		position = {
			y = 5545,
			x = 5387,
			z = 4
		}
	},
	{
		name = "Rumalos",
		level = 50,
		offset = {
			y = 110,
			x = 193
		},
		position = {
			y = 5603,
			x = 4017,
			z = 6
		}
	},
	{
		name = "Eelsnout",
		level = 25,
		offset = {
			y = 110,
			x = 193
		},
		position = {
			y = 5273,
			x = 4460,
			z = 5
		}
	},
	{
		name = "Hogula",
		level = 40,
		offset = {
			y = 110,
			x = 193
		},
		position = {
			y = 5496,
			x = 4204,
			z = 5
		}
	}
}
ContainerTypeInventory = 0
ContainerTypePouch = 1
ContainerTypeDepot = 2
ContainerTypeHouseDepot = 3
ContainerTypeInbox = 4
DoorsIds = {
	1628,
	1629,
	1630,
	1630,
	1631,
	1632,
	1633,
	1633,
	1638,
	1639,
	1639,
	1640,
	1641,
	1642,
	1644,
	1645,
	1646,
	1647,
	1648,
	1649,
	1650,
	1651,
	1652,
	1652,
	1653,
	1654,
	1655,
	1655,
	1656,
	1657,
	1658,
	1659,
	1668,
	1669,
	1670,
	1670,
	1671,
	1672,
	1673,
	1673,
	1682,
	1683,
	1684,
	1684,
	1685,
	1686,
	1691,
	1692,
	1693,
	1693,
	1694,
	1695,
	2177,
	2178,
	2179,
	2180,
	4911,
	4911,
	4912,
	4913,
	4914,
	4914,
	5006,
	5007,
	5082,
	5083,
	5084,
	5085,
	5097,
	5098,
	5099,
	5099,
	5100,
	5101,
	5106,
	5107,
	5108,
	5108,
	5109,
	5110,
	5115,
	5116,
	5117,
	5117,
	5118,
	5119,
	5124,
	5125,
	5126,
	5126,
	5127,
	5128,
	5133,
	5134,
	5135,
	5135,
	5136,
	5137,
	5138,
	5138,
	5139,
	5140,
	5141,
	5141,
	5142,
	5143,
	5144,
	5144,
	5277,
	5278,
	5279,
	5279,
	5280,
	5281,
	5282,
	5282,
	5283,
	5284,
	5285,
	5286,
	5514,
	5515,
	5516,
	5517,
	5732,
	5733,
	5734,
	5734,
	5735,
	5736,
	5737,
	5737,
	6191,
	6192,
	6193,
	6193,
	6194,
	6195,
	6196,
	6196,
	6197,
	6198,
	6199,
	6200,
	6248,
	6249,
	6250,
	6250,
	6251,
	6252,
	6253,
	6253,
	6254,
	6255,
	6256,
	6257,
	6795,
	6796,
	6797,
	6798,
	6799,
	6800,
	6801,
	6802,
	6891,
	6892,
	6893,
	6893,
	6894,
	6895,
	6900,
	6901,
	6902,
	6902,
	6903,
	6904,
	7033,
	7034,
	7035,
	7035,
	7036,
	7037,
	7042,
	7043,
	7044,
	7044,
	7045,
	7046,
	7054,
	7055,
	7056,
	7057,
	7711,
	7712,
	7713,
	7713,
	7714,
	7715,
	7716,
	7716,
	7717,
	7718,
	7719,
	7720,
	8249,
	8250,
	8251,
	8251,
	8252,
	8253,
	8254,
	8254,
	8255,
	8256,
	8257,
	8258,
	8351,
	8352,
	8353,
	8353,
	8354,
	8355,
	8356,
	8356,
	8357,
	8358,
	8359,
	8360,
	9351,
	9352,
	9353,
	9353,
	9354,
	9355,
	9356,
	9356,
	9357,
	9358,
	9359,
	9360,
	9551,
	9552,
	9553,
	9553,
	9554,
	9555,
	9560,
	9561,
	9562,
	9562,
	9563,
	9564,
	9858,
	9859,
	9860,
	9860,
	9863,
	9864,
	9865,
	9866,
	9867,
	9868,
	9869,
	9869,
	9872,
	9873,
	9874,
	9875,
	11136,
	11137,
	11138,
	11138,
	11139,
	11140,
	11141,
	11142,
	11143,
	11144,
	11145,
	11145,
	11146,
	11147,
	11148,
	11149,
	11232,
	11233,
	11234,
	11234,
	11237,
	11238,
	11239,
	11240,
	11241,
	11242,
	11243,
	11243,
	11246,
	11247,
	11248,
	11249,
	12033,
	12034,
	12035,
	12036,
	13135,
	13136,
	13137,
	13137,
	15687,
	15688,
	15890,
	15891,
	15892,
	15893,
	17560,
	17561,
	17562,
	17562,
	17563,
	17564,
	17565,
	17566,
	17567,
	17568,
	17569,
	17570,
	17571,
	17571,
	17572,
	17573,
	17574,
	17575,
	17576,
	17577,
	17700,
	17701,
	17702,
	17702,
	17703,
	17704,
	17705,
	17706,
	17707,
	17708,
	17709,
	17710,
	17711,
	17711,
	17712,
	17713,
	17714,
	17715,
	17716,
	17717,
	17993,
	17994,
	17995,
	17995,
	17996,
	17997,
	17998,
	17999,
	18000,
	18001,
	18002,
	18003,
	18004,
	18004,
	18005,
	18006,
	18007,
	18008,
	18009,
	18010,
	20443,
	20444,
	20445,
	20445,
	20452,
	20453,
	20454,
	20454,
	31155,
	31156,
	31157,
	31158,
	31159,
	31160,
	31161,
	31162,
	31163,
	31164,
	31165,
	31166,
	31167,
	31168,
	31169,
	31170,
	31171,
	31172,
	31173,
	31174,
	31992,
	31993,
	31994,
	31995,
	33081,
	33082,
	33083,
	33084
}
CONDITION_NONE = 0
CONDITION_SPELL = 1
CONDITION_PHYSICAL = 2
CONDITION_HASTE = 4
CONDITION_PARALYZE = 8
CONDITION_OUTFIT = 16
CONDITION_INVISIBLE = 32
CONDITION_LIGHT = 64
CONDITION_BLIND = 128
CONDITION_INFIGHT = 256
CONDITION_DRUNK = 512
CONDITION_REGENERATION = 1024
CONDITION_MUTED = 2048
CONDITION_CHANNELMUTEDTICKS = 4096
CONDITION_YELLTICKS = 8192
CONDITION_ATTRIBUTES = 16384
CONDITION_PACIFIED = 32768
CONDITION_STUN = 65536
CONDITION_SNARE = 131072
CONDITION_INPVP = 262144
CONDITION_MANADRAIN = 524288
STAT_MAXHITPOINTS = 0
STAT_MAXMANAPOINTS = 1
STAT_ATTACKSPEED = 2
STAT_ATTACK = 3
STAT_PHYSICALATTACK = 4
STAT_MAGICATTACK = 5
STAT_DEFENSE = 6
STAT_PHYSICALDEFENSE = 7
STAT_MAGICDEFENSE = 8
STAT_MIGHT = 9
STAT_DEXTERITY = 10
STAT_HASTE = 11
STAT_INTELLIGENCE = 12
STAT_WISDOM = 13
STAT_SPELLCOOLDOWN = 14
STAT_RANGEBONUS = 15
STAT_HEAL = 16
STAT_SPEED = 17
STAT_MANA_REGENERATION = 18
STAT_CRITICAL_CHANCE = 19
STAT_CRITICAL_DAMAGE = 20
STAT_HEALTH_HEALING_PERCENT = 21
STAT_VITALITY = 22
STAT_HEALTH_REGENERATION = 23
HOTKEYS_IDS = {
	MAP = 63,
	TRANSPORT = 62,
	REPUTATION = 61,
	PROFESSIONS = 60,
	ARCHETYPES = 59,
	RAVENCARDS = 58,
	INFUSION = 57,
	INVENTORY = 56,
	CHARACTER = 55,
	ALLY_TARGET_SWITCH_CLICK = 54,
	NEXT_ALLY = 53,
	NEXT_PLAYER_TARGET = 52,
	NEXT_TARGET = 51,
	LAND_INTERACTION_4 = 50,
	LAND_INTERACTION_3 = 49,
	LAND_INTERACTION_2 = 48,
	LAND_INTERACTION_1 = 47,
	MOUNT_DISMOUNT = 46,
	WEAPON_SKILL = 45,
	ACTION_BAR_36 = 44,
	ACTION_BAR_35 = 43,
	ACTION_BAR_34 = 42,
	ACTION_BAR_33 = 41,
	ACTION_BAR_32 = 40,
	ACTION_BAR_31 = 39,
	ACTION_BAR_30 = 38,
	ACTION_BAR_29 = 37,
	ACTION_BAR_28 = 36,
	ACTION_BAR_27 = 35,
	ACTION_BAR_26 = 34,
	ACTION_BAR_25 = 33,
	ACTION_BAR_24 = 32,
	ACTION_BAR_23 = 31,
	ACTION_BAR_22 = 30,
	ACTION_BAR_21 = 29,
	ACTION_BAR_20 = 28,
	ACTION_BAR_19 = 27,
	ACTION_BAR_18 = 26,
	ACTION_BAR_17 = 25,
	ACTION_BAR_16 = 24,
	ACTION_BAR_15 = 23,
	ACTION_BAR_14 = 22,
	ACTION_BAR_13 = 21,
	ACTION_BAR_12 = 20,
	ACTION_BAR_11 = 19,
	ACTION_BAR_10 = 18,
	ACTION_BAR_9 = 17,
	ACTION_BAR_8 = 16,
	ACTION_BAR_7 = 15,
	ACTION_BAR_6 = 14,
	ACTION_BAR_5 = 13,
	ACTION_BAR_4 = 12,
	ACTION_BAR_3 = 11,
	ACTION_BAR_2 = 10,
	ACTION_BAR_1 = 9,
	WALK_NORTH_WEST = 8,
	WALK_SOUTH_WEST = 7,
	WALK_SOUTH_EAST = 6,
	WALK_NORTH_EAST = 5,
	WALK_WEST = 4,
	MOUNT_BAR_4 = 95,
	MOUNT_BAR_5 = 96,
	MOUNT_BAR_6 = 97,
	GUILD = 98,
	WALK_SOUTH = 3,
	WALK_EAST = 2,
	WALK_NORTH = 1,
	JOURNAL = 99,
	ALLY_TARGET_SWITCH_HOLD = 100,
	ADVENTURERS_BOARD = 101,
	PERFORMANCE_STATS = 102,
	AETHER_RIFT = 103,
	ACTION_BAR_37 = 104,
	ACTION_BAR_38 = 105,
	ACTION_BAR_39 = 106,
	ACTION_BAR_40 = 107,
	ACTION_BAR_41 = 108,
	ACTION_BAR_42 = 109,
	ACTION_BAR_43 = 110,
	ACTION_BAR_44 = 111,
	ACTION_BAR_45 = 112,
	ACTION_BAR_46 = 113,
	ACTION_BAR_47 = 114,
	ACTION_BAR_48 = 115,
	TOGGLE_FLOOR_INDICATOR = 121,
	REDEEM_REWARDS = 122,
	MOUNT_BAR_3 = 94,
	MOUNT_BAR_2 = 93,
	MOUNT_BAR_1 = 92,
	TURN_WEST = 91,
	TURN_SOUTH = 90,
	TURN_EAST = 89,
	TURN_NORTH = 88,
	TOGGLE_AUDIO = 87,
	HIDE_INTERFACE = 86,
	EDIT_MODE = 85,
	TOGGLE_CURSOR = 84,
	PRIVATE_CHAT_PREVIOUS = 83,
	PRIVATE_CHAT_NEXT = 82,
	PARTY_CHAT = 81,
	GLOBAL_CHAT = 80,
	LOCAL_CHAT = 79,
	CYCLE_CHAT_PREVIOUS = 78,
	CYCLE_CHAT_NEXT = 77,
	OPEN_CHAT = 76,
	ZOOM_OUT_MINIMAP = 75,
	ZOOM_IN_MINIMAP = 74,
	TOGGLE_PVP = 73,
	LAND_TRACKER = 72,
	REPORT_FEEDBACK = 71,
	QUEST_TRACKER = 70,
	SETTINGS = 69,
	TUTORIAL = 68,
	SOCIAL = 67,
	TRADEPACK = 66,
	RANGERS_COMPANY = 65,
	QUEST = 64
}
HOTKEY_ID_TO_WALK_DIRECTION = {
	[HOTKEYS_IDS.WALK_NORTH] = North,
	[HOTKEYS_IDS.WALK_EAST] = East,
	[HOTKEYS_IDS.WALK_SOUTH] = South,
	[HOTKEYS_IDS.WALK_WEST] = West,
	[HOTKEYS_IDS.WALK_NORTH_WEST] = NorthWest,
	[HOTKEYS_IDS.WALK_NORTH_EAST] = NorthEast,
	[HOTKEYS_IDS.WALK_SOUTH_WEST] = SouthWest,
	[HOTKEYS_IDS.WALK_SOUTH_EAST] = SouthEast
}
DIRECTION_TO_HOTKEY_ID = {
	[North] = HOTKEYS_IDS.WALK_NORTH,
	[East] = HOTKEYS_IDS.WALK_EAST,
	[South] = HOTKEYS_IDS.WALK_SOUTH,
	[West] = HOTKEYS_IDS.WALK_WEST,
	[NorthWest] = HOTKEYS_IDS.WALK_NORTH_WEST,
	[NorthEast] = HOTKEYS_IDS.WALK_NORTH_EAST,
	[SouthWest] = HOTKEYS_IDS.WALK_SOUTH_WEST,
	[SouthEast] = HOTKEYS_IDS.WALK_SOUTH_EAST
}
HOTKEY_ID_TO_TURN_DIRECTION = {
	[HOTKEYS_IDS.TURN_NORTH] = North,
	[HOTKEYS_IDS.TURN_EAST] = East,
	[HOTKEYS_IDS.TURN_SOUTH] = South,
	[HOTKEYS_IDS.TURN_WEST] = West
}
MOUNTS_PLAYER_LOOK = {
	[2610] = 2621,
	[2578] = 2590,
	[5961] = 5960,
	[6711] = 6710,
	[2821] = 2832,
	[5963] = 5962,
	[2695] = 2708,
	[7515] = 7518,
	[2674] = 2685,
	[7547] = 7550,
	[2689] = 2702,
	[2700] = 2713,
	[7997] = 7995,
	[2698] = 2711,
	[2721] = 2810,
	[5773] = 5767,
	[2737] = 2749,
	[8654] = 8312,
	[7040] = 7038,
	[2692] = 2705,
	[6817] = 6816,
	[8526] = 8519,
	[6721] = 6720,
	[6472] = 6469,
	[2308] = 2505,
	[2291] = 2448,
	[2324] = 2542,
	[2818] = 2829,
	[2340] = 2636,
	[8270] = 8268,
	[2356] = 2527,
	[6474] = 6470,
	[2609] = 2620,
	[7673] = 7669,
	[6398] = 6386,
	[7577] = 7580,
	[6621] = 6609,
	[5858] = 5860,
	[2576] = 2588,
	[2817] = 2828,
	[2673] = 2684,
	[7039] = 7037,
	[6525] = 6521,
	[6556] = 6552,
	[6572] = 6568,
	[7481] = 7484,
	[2720] = 2733,
	[7528] = 7531,
	[2736] = 2748,
	[6656] = 6655,
	[6397] = 6385,
	[7576] = 7579,
	[2768] = 2778,
	[7608] = 7605,
	[7479] = 7482,
	[6751] = 6750,
	[2307] = 2504,
	[2290] = 2443,
	[2323] = 2543,
	[7448] = 7445,
	[2339] = 2634,
	[7480] = 7483,
	[2355] = 2526,
	[2675] = 2686,
	[2608] = 2619,
	[2577] = 2589,
	[6651] = 6650,
	[7575] = 7578,
	[6619] = 6607,
	[7607] = 7604,
	[5937] = 5936,
	[2613] = 2624,
	[2672] = 2683,
	[7582] = 7585,
	[6523] = 6520,
	[7447] = 7444,
	[2289] = 2497,
	[2735] = 2747,
	[5774] = 5768,
	[7383] = 7381,
	[5777] = 5771,
	[2767] = 2777,
	[2303] = 2500,
	[8582] = 8575,
	[6618] = 6606,
	[7100] = 7098,
	[6458] = 6455,
	[2815] = 2826,
	[2306] = 2503,
	[6781] = 6780,
	[2322] = 2544,
	[2816] = 2827,
	[2338] = 2633,
	[2573] = 2585,
	[2354] = 2525,
	[7182] = 7180,
	[5776] = 5770,
	[6908] = 6904,
	[2575] = 2587,
	[2840] = 2841,
	[6617] = 6605,
	[2671] = 2682,
	[6202] = 6196,
	[2719] = 2732,
	[6661] = 6660,
	[7541] = 7544,
	[2285] = 2493,
	[2718] = 2731,
	[7736] = 7733,
	[2734] = 2746,
	[7959] = 7946,
	[5775] = 5769,
	[7025] = 7023,
	[2766] = 2776,
	[2312] = 2535,
	[6811] = 6810,
	[6616] = 6604,
	[2317] = 2541,
	[6456] = 6453,
	[2318] = 2539,
	[2305] = 2502,
	[2574] = 2586,
	[2321] = 2545,
	[2272] = 2552,
	[6233] = 6227,
	[7476] = 7473,
	[2353] = 2524,
	[7635] = 7632,
	[2572] = 2584,
	[8640] = 8633,
	[7894] = 7868,
	[6554] = 6551,
	[7120] = 7118,
	[2670] = 2681,
	[6200] = 6194,
	[7101] = 7099,
	[7139] = 7141,
	[7539] = 7542,
	[7766] = 7764,
	[2717] = 2730,
	[6487] = 6484,
	[2273] = 2554,
	[7957] = 7944,
	[7634] = 7631,
	[2275] = 2556,
	[7160] = 7162,
	[6646] = 6645,
	[2276] = 2557,
	[9084] = 9082,
	[5932] = 5931,
	[6199] = 6193,
	[7257] = 7255,
	[2304] = 2501,
	[5741] = 5735,
	[2287] = 2495,
	[6681] = 6680,
	[2271] = 2553,
	[7287] = 7285,
	[2352] = 2523,
	[5772] = 5766,
	[7301] = 7299,
	[7159] = 7161,
	[7892] = 7866,
	[5913] = 5911,
	[2765] = 2775,
	[2669] = 2680,
	[8083] = 8084,
	[5899] = 5898,
	[2688] = 2701,
	[5740] = 5734,
	[2824] = 2825,
	[2716] = 2729,
	[6230] = 6224,
	[5906] = 5904,
	[5038] = 5036,
	[5940] = 5942,
	[8178] = 8176,
	[7409] = 7408,
	[7891] = 7865,
	[2780] = 2781,
	[8114] = 8115,
	[6160] = 6145,
	[7545] = 7548,
	[7546] = 7549,
	[2302] = 2499,
	[5739] = 5733,
	[2286] = 2494,
	[2335] = 2519,
	[2270] = 2551,
	[2351] = 2522,
	[7954] = 7941,
	[7376] = 7374,
	[6875] = 6873,
	[6237] = 6243,
	[7890] = 7864,
	[2329] = 2513,
	[7523] = 7526,
	[2668] = 2679,
	[6399] = 6387,
	[7248] = 7249,
	[8049] = 8050,
	[5738] = 5732,
	[7535] = 7538,
	[2715] = 2728,
	[6401] = 6389,
	[5794] = 5793,
	[7953] = 7940,
	[6869] = 6868,
	[8694] = 8709,
	[2763] = 2773,
	[7889] = 7863,
	[6805] = 6804,
	[6174] = 6173,
	[6837] = 6835,
	[7264] = 7262,
	[6741] = 6740,
	[2301] = 2498,
	[5737] = 5731,
	[7534] = 7537,
	[2334] = 2517,
	[2269] = 2550,
	[2350] = 2645,
	[7952] = 7939,
	[6201] = 6195,
	[8692] = 8685,
	[6203] = 6197,
	[6204] = 6198,
	[6229] = 6223,
	[8564] = 8557,
	[2667] = 2678,
	[6231] = 6225,
	[6232] = 6226,
	[6162] = 6147,
	[5736] = 5730,
	[7533] = 7536,
	[2714] = 2727,
	[2319] = 2546,
	[7951] = 7938,
	[2320] = 2547,
	[7540] = 7543,
	[2725] = 2814,
	[2762] = 2772,
	[6881] = 6880,
	[7058] = 7060,
	[7309] = 7307,
	[6887] = 6886,
	[6893] = 6891,
	[6639] = 6637,
	[6161] = 6146,
	[6771] = 6770,
	[2284] = 2492,
	[2333] = 2518,
	[2268] = 2549,
	[2349] = 2642,
	[6489] = 6486,
	[7121] = 7119,
	[7765] = 7763,
	[6396] = 6384,
	[6153] = 6138,
	[7057] = 7059,
	[5603] = 5600,
	[2666] = 2677,
	[2764] = 2774,
	[5893] = 5892,
	[7893] = 7867,
	[2697] = 2710,
	[5959] = 5958,
	[2316] = 2540,
	[5952] = 5951,
	[6706] = 6705,
	[2288] = 2496,
	[2745] = 2757,
	[2342] = 2637,
	[2761] = 2771,
	[8622] = 8325,
	[7974] = 7972,
	[5602] = 5599,
	[8271] = 8269,
	[8494] = 8489,
	[8044] = 8045,
	[6159] = 6144,
	[7024] = 7022,
	[2283] = 2491,
	[2332] = 2520,
	[2267] = 2548,
	[2348] = 2644,
	[8004] = 8002,
	[8012] = 8010,
	[7948] = 7935,
	[6541] = 6537,
	[7949] = 7936,
	[7950] = 7937,
	[5601] = 5598,
	[8075] = 8076,
	[7338] = 7336,
	[6736] = 6735,
	[6158] = 6143,
	[2696] = 2709,
	[7529] = 7532,
	[7138] = 7140,
	[8300] = 8298,
	[7947] = 7934,
	[6863] = 6862,
	[2744] = 2756,
	[2822] = 2833,
	[2760] = 2770,
	[6799] = 6798,
	[7955] = 7942,
	[7956] = 7943,
	[2274] = 2555,
	[7958] = 7945,
	[6847] = 6845,
	[6157] = 6142,
	[2315] = 2538,
	[2282] = 2490,
	[2331] = 2521,
	[2341] = 2635,
	[2347] = 2643,
	[7982] = 7980,
	[8280] = 8278,
	[7368] = 7366,
	[6539] = 6536,
	[9126] = 9124,
	[8290] = 8288,
	[8291] = 8289,
	[6907] = 6903,
	[8301] = 8299,
	[2699] = 2712,
	[6766] = 6765,
	[8057] = 8058,
	[7527] = 7530,
	[6507] = 6503,
	[2693] = 2706,
	[8096] = 8097,
	[8109] = 8110,
	[6570] = 6567,
	[2743] = 2755,
	[5857] = 5859,
	[6400] = 6388,
	[8327] = 8325,
	[6234] = 6228,
	[5920] = 5918,
	[8088] = 8089,
	[8101] = 8102,
	[6155] = 6140,
	[2314] = 2536,
	[2281] = 2489,
	[2330] = 2514,
	[2583] = 2595,
	[2346] = 2641,
	[6156] = 6141,
	[2362] = 2533,
	[8314] = 8312,
	[8326] = 8324,
	[2631] = 2534,
	[8062] = 8063,
	[8339] = 8337,
	[8340] = 8338,
	[8352] = 8350,
	[8039] = 8040,
	[6154] = 6139,
	[8353] = 8351,
	[2694] = 2707,
	[6505] = 6502,
	[7429] = 7428,
	[8124] = 8122,
	[2726] = 2809,
	[8136] = 8134,
	[2742] = 2754,
	[8148] = 8146,
	[2758] = 2759,
	[7361] = 7359,
	[6827] = 6825,
	[8070] = 8071,
	[8482] = 8480,
	[6440] = 6333,
	[7237] = 7236,
	[2313] = 2537,
	[2280] = 2488,
	[2823] = 2834,
	[2582] = 2594,
	[2345] = 2640,
	[7205] = 7206,
	[2361] = 2532,
	[8672] = 8665,
	[8221] = 8130,
	[8223] = 8154,
	[6631] = 6630,
	[8544] = 8537,
	[6344] = 6332,
	[8226] = 8208,
	[5927] = 5925,
	[8416] = 8415,
	[8623] = 8324,
	[6666] = 6665,
	[7172] = 7170,
	[9085] = 9083,
	[8224] = 8172,
	[6857] = 6855,
	[8641] = 8634,
	[2741] = 2753,
	[7217] = 7218,
	[6793] = 6792,
	[8196] = 8194,
	[8495] = 8490,
	[6343] = 6331,
	[7331] = 7329,
	[7781] = 7777,
	[8508] = 8503,
	[2295] = 2451,
	[7522] = 7525,
	[2279] = 2487,
	[2581] = 2593,
	[2344] = 2639,
	[8222] = 8142,
	[2360] = 2531,
	[5788] = 5787,
	[2328] = 2512,
	[8545] = 8538,
	[2769] = 2779,
	[7079] = 7081,
	[6342] = 6330,
	[8583] = 8576,
	[7780] = 7776,
	[7989] = 7987,
	[8507] = 8502,
	[7521] = 7524,
	[8525] = 8518,
	[6696] = 6695,
	[8225] = 8190,
	[2724] = 2813,
	[2343] = 2638,
	[2740] = 2752,
	[8695] = 8714,
	[5965] = 5964,
	[9112] = 9110,
	[7078] = 7080,
	[6341] = 6329,
	[8214] = 8212,
	[6676] = 6675,
	[2311] = 2508,
	[2294] = 2646,
	[2327] = 2511,
	[2278] = 2486,
	[2580] = 2592,
	[8691] = 8684,
	[2359] = 2530,
	[8603] = 8598,
	[2612] = 2623,
	[8425] = 8424,
	[9056] = 9054,
	[7583] = 7586,
	[8313] = 8311,
	[9071] = 9069,
	[6726] = 6725,
	[6620] = 6608,
	[2676] = 2687,
	[9099] = 9097,
	[2691] = 2704,
	[9113] = 9111,
	[9127] = 9125,
	[7487] = 7490,
	[2723] = 2812,
	[8160] = 8158,
	[2739] = 2751,
	[7423] = 7421,
	[9141] = 9139,
	[6626] = 6625,
	[9070] = 9068,
	[2277] = 2558,
	[9098] = 9096,
	[8673] = 8666,
	[2310] = 2507,
	[2293] = 2450,
	[2326] = 2510,
	[2820] = 2831,
	[2579] = 2591,
	[7486] = 7489,
	[2358] = 2529,
	[8281] = 8279,
	[2611] = 2622,
	[9140] = 9138,
	[7581] = 7584,
	[7517] = 7520,
	[6756] = 6755,
	[7294] = 7292,
	[2690] = 2703,
	[7198] = 7199,
	[8563] = 8556,
	[7485] = 7488,
	[2722] = 2811,
	[5050] = 5048,
	[2738] = 2750,
	[6787] = 6786,
	[7516] = 7519,
	[2309] = 2506,
	[2292] = 2449,
	[2325] = 2509,
	[2819] = 2830,
	[6691] = 6690,
	[7229] = 7230,
	[2357] = 2528
}
FishingBaitClientIds = {
	[49334] = true,
	[49333] = true,
	[49332] = true,
	[49331] = true,
	[48042] = true,
	[48023] = true,
	[47958] = true,
	[47957] = true,
	[49340] = true,
	[47956] = true,
	[49339] = true,
	[47955] = true,
	[49338] = true,
	[47954] = true,
	[49337] = true,
	[47953] = true,
	[49336] = true,
	[47952] = true,
	[49335] = true,
	[47951] = true
}
BULK_USE_ITEMS = {
	[43577] = {
		limit = 100,
		optionPrefix = "Open"
	},
	[43578] = {
		limit = 100,
		optionPrefix = "Open"
	},
	[43579] = {
		limit = 100,
		optionPrefix = "Open"
	},
	[43639] = {
		limit = 100,
		optionPrefix = "Use"
	},
	[43648] = {
		limit = 100,
		optionPrefix = "Use"
	},
	[43644] = {
		limit = 100,
		optionPrefix = "Use"
	},
	[43647] = {
		limit = 100,
		optionPrefix = "Use"
	},
	[47912] = {
		limit = 10,
		optionPrefix = "Use"
	},
	[50526] = {
		limit = 100,
		optionPrefix = "Open"
	},
	[51054] = {
		limit = 100,
		optionPrefix = "Open"
	},
	[51051] = {
		limit = 100,
		optionPrefix = "Open"
	}
}
ShipTypes = {
	Fishing = 2,
	None = 0,
	Galleon = 4,
	Merchant = 3,
	Basic = 1
}
InfusionsIds = {
	[26554] = true,
	[50023] = true,
	[43982] = true,
	[50022] = true,
	[50020] = true,
	[43981] = true,
	[50021] = true,
	[43980] = true,
	[33859] = true,
	[33858] = true
}
PrepaidInfusionsIds = {
	[48457] = true,
	[48452] = true,
	[48456] = true,
	[48455] = true,
	[48454] = true,
	[48453] = true
}
AugmentableItemSlots = {
	[InventorySlotHead] = true,
	[InventorySlotBody] = true,
	[InventorySlotRight] = true,
	[InventorySlotLeft] = true,
	[InventorySlotLeg] = true,
	[InventorySlotFeet] = true
}
AugmentingStonesId = 49330
WeaponTypes = {
	axe = true,
	club = true,
	sword = true,
	["light blade"] = true,
	sceptre = true,
	dagger = true,
	bow = true,
	staff = true,
	greataxe = true,
	greatsword = true,
	hammer = true,
	["tower shield"] = true,
	["buckler shield"] = true
}
TwoHandedWeaponTypes = {
	bow = true,
	staff = true,
	greataxe = true,
	greatsword = true,
	hammer = true,
	["light blade"] = true
}
WeaponRanges = {
	axe = 1,
	club = 1,
	sword = 1,
	["light blade"] = 1,
	sceptre = 7,
	dagger = 1,
	bow = 6,
	staff = 7,
	greataxe = 1,
	greatsword = 1,
	hammer = 1,
	["tower shield"] = 1,
	["buckler shield"] = 1
}
HelmetTypes = {
	["cloth helmet"] = 1,
	["leather helmet"] = 1,
	["plate helmet"] = 1
}
ArmorTypes = {
	["leather armor"] = 1,
	["plate armor"] = 1,
	["cloth armor"] = 1
}
LegsTypes = {
	["cloth legs"] = 1,
	["leather legs"] = 1,
	["plate legs"] = 1
}
BootsTypes = {
	["cloth boots"] = 1,
	["leather boots"] = 1,
	["plate boots"] = 1
}
EquipmentTypes = {}

for _, t in ipairs({
	HelmetTypes,
	ArmorTypes,
	LegsTypes,
	BootsTypes
}) do
	for k, _ in pairs(t) do
		EquipmentTypes[k] = 1
	end
end
