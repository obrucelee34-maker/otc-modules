-- chunkname: @/modules/game_interface/widgets/uiactionkey.lua

g_actionKey = {}

local actionKeyEvent, actionKeyCycleEvent, currentActionObject
local needActionKeyUpdate = true
local craftingIds = {
	34106,
	34053,
	34064,
	33999,
	34106,
	34017,
	34105,
	34352,
	34353,
	34354,
	34501,
	34502,
	33998,
	34000,
	34001,
	34063,
	34065,
	34062,
	34061,
	34060,
	34058,
	34059,
	34104,
	34107,
	34052,
	34055,
	34102,
	33997,
	34048,
	3458,
	34004,
	31853,
	34346,
	38724,
	34103,
	39267,
	38732,
	39343,
	38722,
	34051,
	39254,
	38725,
	39353,
	38723,
	39266,
	38721,
	39253,
	38731,
	34057,
	39342,
	38726,
	33996,
	39397,
	33925,
	33926,
	39168,
	39169,
	39170,
	39171,
	39172,
	39173,
	49713,
	49714,
	49715,
	49716,
	49717,
	49740,
	49743,
	39268
}

for _, id in ipairs(craftingIds) do
	craftingIds[id] = true
end

local tradepackIds = {
	33688,
	33689
}
local fishpackIds = {
	33693,
	33694
}
local culledEyePackIds = {
	47917,
	47919
}
local plunderChestIds = {
	48581,
	49360
}

for _, id in ipairs(tradepackIds) do
	tradepackIds[id] = true
end

for _, id in ipairs(fishpackIds) do
	fishpackIds[id] = true
end

for _, id in ipairs(culledEyePackIds) do
	culledEyePackIds[id] = true
end

for _, id in ipairs(plunderChestIds) do
	plunderChestIds[id] = true
end

function g_actionKey.init()
	connect(g_game, {
		onGameStart = onGameStart
	})
	connect(g_game, {
		onGameEnd = onGameEnd
	})
	connect(LocalPlayer, {
		onWalk = onWalk,
		onTeleport = onWalk,
		onPositionChange = onWalk,
		onTurn = onTurn,
		onHouseModeChange = onHouseModeChange
	})
	connect(Creature, {
		onTalkableChange = onTalkableChange
	})
	addEvent(function()
		actionKeyPanel = g_ui.createWidget("ActionKey")

		actionKeyPanel:setImageColor("#ffffff" .. string.format("%x", math.max(0, modules.game_settings.getOption("actionKeyOpacity") / 100) * 255))
	end)
end

function g_actionKey.terminate()
	disconnect(g_game, {
		onGameStart = onGameStart
	})
	disconnect(g_game, {
		onGameEnd = onGameEnd
	})
	disconnect(LocalPlayer, {
		onWalk = onWalk,
		onTeleport = onWalk,
		onPositionChange = onWalk,
		onTurn = onTurn,
		onHouseModeChange = onHouseModeChange
	})

	if actionKeyPanel then
		actionKeyPanel:destroy()

		actionKeyPanel = nil
	end

	g_actionKey = nil
end

function g_actionKey.show()
	if actionKeyEvent then
		removeEvent(actionKeyEvent)
	end

	if not modules.game_settings.getOption("showActionKey") then
		return
	end

	actionKeyEvent = scheduleEvent(function()
		g_game.setDrawingActionKey(true)

		actionKeyEvent = nil
	end, 200)
end

function g_actionKey.hide()
	if actionKeyEvent then
		removeEvent(actionKeyEvent)

		actionKeyEvent = nil
	end

	g_game.setDrawingActionKey(false)
end

local checkDirectionPriotity = {
	[North] = {
		{
			near = true,
			y = 0,
			x = 0
		},
		{
			near = true,
			y = -1,
			x = 0
		},
		{
			near = true,
			y = -1,
			x = 1
		},
		{
			near = true,
			y = -1,
			x = -1
		},
		{
			near = true,
			y = 0,
			x = -1
		},
		{
			near = true,
			y = 0,
			x = 1
		},
		{
			near = true,
			y = 1,
			x = 0
		},
		{
			near = true,
			y = 1,
			x = -1
		},
		{
			near = true,
			y = 1,
			x = 1
		},
		{
			x = 0,
			y = -2
		},
		{
			x = -1,
			y = -2
		},
		{
			x = 1,
			y = -2
		},
		{
			x = -2,
			y = -2
		},
		{
			x = 2,
			y = -2
		},
		{
			x = -2,
			y = -1
		},
		{
			x = 2,
			y = -1
		},
		{
			x = -2,
			y = 0
		},
		{
			x = 2,
			y = 0
		},
		{
			x = -2,
			y = 1
		},
		{
			x = 2,
			y = 1
		},
		{
			x = 0,
			y = 2
		},
		{
			x = -1,
			y = 2
		},
		{
			x = 1,
			y = 2
		},
		{
			x = -2,
			y = 2
		},
		{
			x = 2,
			y = 2
		}
	},
	[South] = {
		{
			near = true,
			y = 0,
			x = 0
		},
		{
			near = true,
			y = 1,
			x = 0
		},
		{
			near = true,
			y = 1,
			x = -1
		},
		{
			near = true,
			y = 1,
			x = 1
		},
		{
			near = true,
			y = 0,
			x = -1
		},
		{
			near = true,
			y = 0,
			x = 1
		},
		{
			near = true,
			y = -1,
			x = 0
		},
		{
			near = true,
			y = -1,
			x = -1
		},
		{
			near = true,
			y = -1,
			x = 1
		},
		{
			x = 0,
			y = 2
		},
		{
			x = -1,
			y = 2
		},
		{
			x = 1,
			y = 2
		},
		{
			x = -2,
			y = 2
		},
		{
			x = 2,
			y = 2
		},
		{
			x = -2,
			y = 1
		},
		{
			x = 2,
			y = 1
		},
		{
			x = -2,
			y = 0
		},
		{
			x = 2,
			y = 0
		},
		{
			x = -2,
			y = -1
		},
		{
			x = 2,
			y = -1
		},
		{
			x = 0,
			y = -2
		},
		{
			x = -1,
			y = -2
		},
		{
			x = 1,
			y = -2
		},
		{
			x = -2,
			y = -2
		},
		{
			x = 2,
			y = -2
		}
	},
	[West] = {
		{
			near = true,
			y = 0,
			x = 0
		},
		{
			near = true,
			y = 0,
			x = -1
		},
		{
			near = true,
			y = -1,
			x = -1
		},
		{
			near = true,
			y = 1,
			x = -1
		},
		{
			near = true,
			y = -1,
			x = 0
		},
		{
			near = true,
			y = 1,
			x = 0
		},
		{
			near = true,
			y = 0,
			x = 1
		},
		{
			near = true,
			y = -1,
			x = 1
		},
		{
			near = true,
			y = 1,
			x = 1
		},
		{
			x = -2,
			y = 0
		},
		{
			x = -2,
			y = -1
		},
		{
			x = -2,
			y = 1
		},
		{
			x = -2,
			y = -2
		},
		{
			x = -2,
			y = 2
		},
		{
			x = -1,
			y = -2
		},
		{
			x = -1,
			y = 2
		},
		{
			x = 0,
			y = -2
		},
		{
			x = 0,
			y = 2
		},
		{
			x = 1,
			y = -2
		},
		{
			x = 1,
			y = 2
		},
		{
			x = 2,
			y = 0
		},
		{
			x = 2,
			y = -1
		},
		{
			x = 2,
			y = 1
		},
		{
			x = 2,
			y = -2
		},
		{
			x = 2,
			y = 2
		}
	},
	[East] = {
		{
			near = true,
			y = 0,
			x = 0
		},
		{
			near = true,
			y = 0,
			x = 1
		},
		{
			near = true,
			y = -1,
			x = 1
		},
		{
			near = true,
			y = 1,
			x = 1
		},
		{
			near = true,
			y = -1,
			x = 0
		},
		{
			near = true,
			y = 1,
			x = 0
		},
		{
			near = true,
			y = 0,
			x = -1
		},
		{
			near = true,
			y = -1,
			x = -1
		},
		{
			near = true,
			y = 1,
			x = -1
		},
		{
			x = 2,
			y = 0
		},
		{
			x = 2,
			y = -1
		},
		{
			x = 2,
			y = 1
		},
		{
			x = 2,
			y = -2
		},
		{
			x = 2,
			y = 2
		},
		{
			x = 1,
			y = -2
		},
		{
			x = 1,
			y = 2
		},
		{
			x = 0,
			y = -2
		},
		{
			x = 0,
			y = 2
		},
		{
			x = -1,
			y = -2
		},
		{
			x = -1,
			y = 2
		},
		{
			x = -2,
			y = 0
		},
		{
			x = -2,
			y = -1
		},
		{
			x = -2,
			y = 1
		},
		{
			x = -2,
			y = -2
		},
		{
			x = -2,
			y = 2
		}
	}
}

checkDirectionPriotity[NorthEast] = checkDirectionPriotity[East]
checkDirectionPriotity[SouthEast] = checkDirectionPriotity[East]
checkDirectionPriotity[SouthWest] = checkDirectionPriotity[West]
checkDirectionPriotity[NorthWest] = checkDirectionPriotity[West]

local interactableIconsToProfession = {
	[50145] = ProfessionMining,
	[50149] = ProfessionMining,
	[50146] = ProfessionMining,
	[50147] = ProfessionMining,
	[50148] = ProfessionMining,
	[50150] = ProfessionMining,
	[50151] = ProfessionMining,
	[50152] = ProfessionMining,
	[50156] = ProfessionMining,
	[50153] = ProfessionMining,
	[50154] = ProfessionMining,
	[50155] = ProfessionMining,
	[50157] = ProfessionMining,
	[50158] = ProfessionMining,
	[50159] = ProfessionMining,
	[50163] = ProfessionMining,
	[50160] = ProfessionMining,
	[50161] = ProfessionMining,
	[50162] = ProfessionMining,
	[50164] = ProfessionMining,
	[50165] = ProfessionMining,
	[50173] = ProfessionMining,
	[50174] = ProfessionMining,
	[50175] = ProfessionMining,
	[50176] = ProfessionMining,
	[50177] = ProfessionMining,
	[50178] = ProfessionMining,
	[50179] = ProfessionMining,
	[50180] = ProfessionMining,
	[50181] = ProfessionMining,
	[50182] = ProfessionMining,
	[50183] = ProfessionMining,
	[50184] = ProfessionMining,
	[50185] = ProfessionMining,
	[50186] = ProfessionMining,
	[50166] = ProfessionMining,
	[50167] = ProfessionMining,
	[50168] = ProfessionMining,
	[50169] = ProfessionMining,
	[50170] = ProfessionMining,
	[50171] = ProfessionMining,
	[50172] = ProfessionMining,
	[50187] = ProfessionMining,
	[50188] = ProfessionMining,
	[50189] = ProfessionMining,
	[50190] = ProfessionMining,
	[50191] = ProfessionMining,
	[50192] = ProfessionMining,
	[50193] = ProfessionMining,
	[50201] = ProfessionMining,
	[50202] = ProfessionMining,
	[50203] = ProfessionMining,
	[50204] = ProfessionMining,
	[50205] = ProfessionMining,
	[50206] = ProfessionMining,
	[50207] = ProfessionMining,
	[50208] = ProfessionMining,
	[50209] = ProfessionMining,
	[50210] = ProfessionMining,
	[50211] = ProfessionMining,
	[50212] = ProfessionMining,
	[50213] = ProfessionMining,
	[50214] = ProfessionMining,
	[50194] = ProfessionMining,
	[50195] = ProfessionMining,
	[50196] = ProfessionMining,
	[50197] = ProfessionMining,
	[50198] = ProfessionMining,
	[50199] = ProfessionMining,
	[50200] = ProfessionMining,
	[50215] = ProfessionMining,
	[50216] = ProfessionMining,
	[50217] = ProfessionMining,
	[50218] = ProfessionMining,
	[50219] = ProfessionMining,
	[50220] = ProfessionMining,
	[50221] = ProfessionMining,
	[50229] = ProfessionMining,
	[50230] = ProfessionMining,
	[50231] = ProfessionMining,
	[50232] = ProfessionMining,
	[50233] = ProfessionMining,
	[50234] = ProfessionMining,
	[50235] = ProfessionMining,
	[50236] = ProfessionMining,
	[50237] = ProfessionMining,
	[50238] = ProfessionMining,
	[50239] = ProfessionMining,
	[50240] = ProfessionMining,
	[50241] = ProfessionMining,
	[50242] = ProfessionMining,
	[50222] = ProfessionMining,
	[50223] = ProfessionMining,
	[50224] = ProfessionMining,
	[50225] = ProfessionMining,
	[50226] = ProfessionMining,
	[50227] = ProfessionMining,
	[50228] = ProfessionMining,
	[50243] = ProfessionMining,
	[50244] = ProfessionMining,
	[50245] = ProfessionMining,
	[50246] = ProfessionMining,
	[50247] = ProfessionMining,
	[50248] = ProfessionMining,
	[50249] = ProfessionMining,
	[47924] = ProfessionMining,
	[47925] = ProfessionMining,
	[47926] = ProfessionMining,
	[47927] = ProfessionMining,
	[47928] = ProfessionMining,
	[47929] = ProfessionMining,
	[47921] = ProfessionMining,
	[47931] = ProfessionMining,
	[47935] = ProfessionMining,
	[47939] = ProfessionMining,
	[47943] = ProfessionMining,
	[47947] = ProfessionMining,
	[47922] = ProfessionMining,
	[47932] = ProfessionMining,
	[47936] = ProfessionMining,
	[47940] = ProfessionMining,
	[47944] = ProfessionMining,
	[47948] = ProfessionMining,
	[47920] = ProfessionMining,
	[47930] = ProfessionMining,
	[47934] = ProfessionMining,
	[47938] = ProfessionMining,
	[47942] = ProfessionMining,
	[47946] = ProfessionMining,
	[47923] = ProfessionMining,
	[47933] = ProfessionMining,
	[47937] = ProfessionMining,
	[47941] = ProfessionMining,
	[47945] = ProfessionMining,
	[47949] = ProfessionMining,
	[33847] = ProfessionMining,
	[28941] = ProfessionMining,
	[28942] = ProfessionMining,
	[28943] = ProfessionMining,
	[28944] = ProfessionMining,
	[28945] = ProfessionMining,
	[28946] = ProfessionMining,
	[28947] = ProfessionMining,
	[28948] = ProfessionMining,
	[28949] = ProfessionMining,
	[28950] = ProfessionMining,
	[28951] = ProfessionMining,
	[28952] = ProfessionMining,
	[28953] = ProfessionMining,
	[28954] = ProfessionMining,
	[28955] = ProfessionMining,
	[30069] = ProfessionMining,
	[30070] = ProfessionMining,
	[30071] = ProfessionMining,
	[30072] = ProfessionMining,
	[29258] = ProfessionWoodcutting,
	[29420] = ProfessionWoodcutting,
	[29291] = ProfessionWoodcutting,
	[18445] = ProfessionWoodcutting,
	[33264] = ProfessionWoodcutting,
	[29324] = ProfessionWoodcutting,
	[29260] = ProfessionWoodcutting,
	[33202] = ProfessionWoodcutting,
	[29293] = ProfessionWoodcutting,
	[34792] = ProfessionWoodcutting,
	[29326] = ProfessionWoodcutting,
	[29262] = ProfessionWoodcutting,
	[29397] = ProfessionWoodcutting,
	[29366] = ProfessionWoodcutting,
	[29328] = ProfessionWoodcutting,
	[33210] = ProfessionWoodcutting,
	[29401] = ProfessionWoodcutting,
	[34800] = ProfessionWoodcutting,
	[33276] = ProfessionWoodcutting,
	[29330] = ProfessionWoodcutting,
	[29299] = ProfessionWoodcutting,
	[29374] = ProfessionWoodcutting,
	[29332] = ProfessionWoodcutting,
	[29268] = ProfessionWoodcutting,
	[29409] = ProfessionWoodcutting,
	[29378] = ProfessionWoodcutting,
	[33284] = ProfessionWoodcutting,
	[29347] = ProfessionWoodcutting,
	[29270] = ProfessionWoodcutting,
	[33222] = ProfessionWoodcutting,
	[29413] = ProfessionWoodcutting,
	[33257] = ProfessionWoodcutting,
	[33819] = ProfessionWoodcutting,
	[29417] = ProfessionWoodcutting,
	[33195] = ProfessionWoodcutting,
	[29386] = ProfessionWoodcutting,
	[29355] = ProfessionWoodcutting,
	[33230] = ProfessionWoodcutting,
	[29307] = ProfessionWoodcutting,
	[29390] = ProfessionWoodcutting,
	[29276] = ProfessionWoodcutting,
	[33265] = ProfessionWoodcutting,
	[29425] = ProfessionWoodcutting,
	[33203] = ProfessionWoodcutting,
	[29394] = ProfessionWoodcutting,
	[34793] = ProfessionWoodcutting,
	[33238] = ProfessionWoodcutting,
	[3622] = ProfessionWoodcutting,
	[29398] = ProfessionWoodcutting,
	[3614] = ProfessionWoodcutting,
	[34797] = ProfessionWoodcutting,
	[33273] = ProfessionWoodcutting,
	[29336] = ProfessionWoodcutting,
	[29313] = ProfessionWoodcutting,
	[29249] = ProfessionWoodcutting,
	[34801] = ProfessionWoodcutting,
	[29340] = ProfessionWoodcutting,
	[29315] = ProfessionWoodcutting,
	[29251] = ProfessionWoodcutting,
	[33808] = ProfessionWoodcutting,
	[29375] = ProfessionWoodcutting,
	[29344] = ProfessionWoodcutting,
	[29317] = ProfessionWoodcutting,
	[33219] = ProfessionWoodcutting,
	[33812] = ProfessionWoodcutting,
	[29379] = ProfessionWoodcutting,
	[33285] = ProfessionWoodcutting,
	[29348] = ProfessionWoodcutting,
	[29319] = ProfessionWoodcutting,
	[33816] = ProfessionWoodcutting,
	[29414] = ProfessionWoodcutting,
	[3615] = ProfessionWoodcutting,
	[29288] = ProfessionWoodcutting,
	[18442] = ProfessionWoodcutting,
	[33258] = ProfessionWoodcutting,
	[29321] = ProfessionWoodcutting,
	[33820] = ProfessionWoodcutting,
	[29418] = ProfessionWoodcutting,
	[29290] = ProfessionWoodcutting,
	[18444] = ProfessionWoodcutting,
	[29259] = ProfessionWoodcutting,
	[29360] = ProfessionWoodcutting,
	[33266] = ProfessionWoodcutting,
	[29261] = ProfessionWoodcutting,
	[33204] = ProfessionWoodcutting,
	[29294] = ProfessionWoodcutting,
	[29364] = ProfessionWoodcutting,
	[29327] = ProfessionWoodcutting,
	[29263] = ProfessionWoodcutting,
	[3616] = ProfessionWoodcutting,
	[29296] = ProfessionWoodcutting,
	[34798] = ProfessionWoodcutting,
	[33274] = ProfessionWoodcutting,
	[29337] = ProfessionWoodcutting,
	[29265] = ProfessionWoodcutting,
	[33212] = ProfessionWoodcutting,
	[33805] = ProfessionWoodcutting,
	[34802] = ProfessionWoodcutting,
	[29341] = ProfessionWoodcutting,
	[29267] = ProfessionWoodcutting,
	[33809] = ProfessionWoodcutting,
	[29376] = ProfessionWoodcutting,
	[33282] = ProfessionWoodcutting,
	[29333] = ProfessionWoodcutting,
	[29269] = ProfessionWoodcutting,
	[33220] = ProfessionWoodcutting,
	[33813] = ProfessionWoodcutting,
	[29380] = ProfessionWoodcutting,
	[29349] = ProfessionWoodcutting,
	[29271] = ProfessionWoodcutting,
	[33817] = ProfessionWoodcutting,
	[29415] = ProfessionWoodcutting,
	[33193] = ProfessionWoodcutting,
	[29384] = ProfessionWoodcutting,
	[29353] = ProfessionWoodcutting,
	[33821] = ProfessionWoodcutting,
	[29306] = ProfessionWoodcutting,
	[29388] = ProfessionWoodcutting,
	[29357] = ProfessionWoodcutting,
	[29308] = ProfessionWoodcutting,
	[33201] = ProfessionWoodcutting,
	[33267] = ProfessionWoodcutting,
	[29302] = ProfessionWoodcutting,
	[29393] = ProfessionWoodcutting,
	[33255] = ProfessionWoodcutting,
	[29278] = ProfessionWoodcutting,
	[33247] = ProfessionWoodcutting,
	[33811] = ProfessionWoodcutting,
	[34795] = ProfessionWoodcutting,
	[33249] = ProfessionWoodcutting,
	[33237] = ProfessionWoodcutting,
	[33240] = ProfessionWoodcutting,
	[33239] = ProfessionWoodcutting,
	[33228] = ProfessionWoodcutting,
	[33229] = ProfessionWoodcutting,
	[33231] = ProfessionWoodcutting,
	[34799] = ProfessionWoodcutting,
	[33275] = ProfessionWoodcutting,
	[33211] = ProfessionWoodcutting,
	[33192] = ProfessionWoodcutting,
	[33822] = ProfessionWoodcutting,
	[33213] = ProfessionWoodcutting,
	[33806] = ProfessionWoodcutting,
	[34805] = ProfessionWoodcutting,
	[34803] = ProfessionWoodcutting,
	[34804] = ProfessionWoodcutting,
	[29257] = ProfessionWoodcutting,
	[33248] = ProfessionWoodcutting,
	[29255] = ProfessionWoodcutting,
	[29298] = ProfessionWoodcutting,
	[33810] = ProfessionWoodcutting,
	[29410] = ProfessionWoodcutting,
	[29407] = ProfessionWoodcutting,
	[33283] = ProfessionWoodcutting,
	[29406] = ProfessionWoodcutting,
	[29282] = ProfessionWoodcutting,
	[29358] = ProfessionWoodcutting,
	[33221] = ProfessionWoodcutting,
	[33814] = ProfessionWoodcutting,
	[29367] = ProfessionWoodcutting,
	[29373] = ProfessionWoodcutting,
	[3621] = ProfessionWoodcutting,
	[29411] = ProfessionWoodcutting,
	[33256] = ProfessionWoodcutting,
	[33807] = ProfessionWoodcutting,
	[33818] = ProfessionWoodcutting,
	[33815] = ProfessionWoodcutting,
	[33194] = ProfessionWoodcutting,
	[34794] = ProfessionWoodcutting,
	[29372] = ProfessionWoodcutting,
	[34796] = ProfessionWoodcutting,
	[29370] = ProfessionWoodcutting,
	[29368] = ProfessionWoodcutting,
	[34226] = ProfessionWoodcutting,
	[34227] = ProfessionWoodcutting,
	[34228] = ProfessionWoodcutting,
	[34235] = ProfessionWoodcutting,
	[34236] = ProfessionWoodcutting,
	[34237] = ProfessionWoodcutting,
	[34232] = ProfessionWoodcutting,
	[34233] = ProfessionWoodcutting,
	[34234] = ProfessionWoodcutting,
	[34229] = ProfessionWoodcutting,
	[34230] = ProfessionWoodcutting,
	[34231] = ProfessionWoodcutting,
	[34223] = ProfessionWoodcutting,
	[34224] = ProfessionWoodcutting,
	[34225] = ProfessionWoodcutting,
	[34242] = ProfessionWoodcutting,
	[34243] = ProfessionWoodcutting,
	[34244] = ProfessionWoodcutting,
	[29760] = ProfessionHusbandry,
	[29761] = ProfessionHusbandry,
	[29762] = ProfessionHusbandry,
	[29763] = ProfessionHusbandry,
	[29764] = ProfessionHusbandry,
	[29765] = ProfessionHusbandry,
	[29766] = ProfessionHusbandry,
	[29767] = ProfessionHusbandry,
	[29768] = ProfessionHusbandry,
	[29769] = ProfessionHusbandry,
	[29770] = ProfessionHusbandry,
	[29771] = ProfessionHusbandry,
	[29772] = ProfessionHusbandry,
	[29773] = ProfessionHusbandry,
	[29774] = ProfessionHusbandry,
	[29775] = ProfessionHusbandry,
	[29776] = ProfessionHusbandry,
	[29777] = ProfessionHusbandry,
	[29778] = ProfessionHusbandry,
	[29779] = ProfessionHusbandry,
	[29780] = ProfessionHusbandry,
	[29781] = ProfessionHusbandry,
	[29782] = ProfessionHusbandry,
	[29783] = ProfessionHusbandry,
	[34238] = ProfessionFarming,
	[34239] = ProfessionFarming,
	[34240] = ProfessionFarming,
	[25129] = ProfessionFarming,
	[25140] = ProfessionFarming,
	[25141] = ProfessionFarming,
	[25145] = ProfessionFarming,
	[25144] = ProfessionFarming,
	[25131] = ProfessionFarming,
	[25147] = ProfessionFarming,
	[25146] = ProfessionFarming,
	[25133] = ProfessionFarming,
	[26859] = ProfessionFarming,
	[26860] = ProfessionFarming,
	[26861] = ProfessionFarming,
	[25143] = ProfessionFarming,
	[25142] = ProfessionFarming,
	[25130] = ProfessionFarming,
	[30223] = ProfessionFarming,
	[30224] = ProfessionFarming,
	[30225] = ProfessionFarming,
	[25156] = ProfessionFarming,
	[25128] = ProfessionFarming,
	[30217] = ProfessionFarming,
	[30218] = ProfessionFarming,
	[30219] = ProfessionFarming,
	[30232] = ProfessionFarming,
	[30233] = ProfessionFarming,
	[30234] = ProfessionFarming,
	[30229] = ProfessionFarming,
	[30230] = ProfessionFarming,
	[30231] = ProfessionFarming,
	[30226] = ProfessionFarming,
	[30227] = ProfessionFarming,
	[30228] = ProfessionFarming,
	[30220] = ProfessionFarming,
	[30221] = ProfessionFarming,
	[30222] = ProfessionFarming,
	[12696] = ProfessionFarming,
	[12695] = ProfessionFarming,
	[12377] = ProfessionFarming,
	[30253] = ProfessionFarming,
	[30254] = ProfessionFarming,
	[30255] = ProfessionFarming,
	[30238] = ProfessionFarming,
	[30239] = ProfessionFarming,
	[30240] = ProfessionFarming,
	[34246] = ProfessionFarming,
	[30250] = ProfessionFarming,
	[30251] = ProfessionFarming,
	[30252] = ProfessionFarming,
	[34249] = ProfessionFarming,
	[30244] = ProfessionFarming,
	[30245] = ProfessionFarming,
	[30246] = ProfessionFarming,
	[30256] = ProfessionFarming,
	[30257] = ProfessionFarming,
	[30258] = ProfessionFarming,
	[34250] = ProfessionFarming,
	[30259] = ProfessionFarming,
	[30260] = ProfessionFarming,
	[30261] = ProfessionFarming,
	[30241] = ProfessionFarming,
	[30242] = ProfessionFarming,
	[30243] = ProfessionFarming,
	[34247] = ProfessionFarming,
	[30265] = ProfessionFarming,
	[30266] = ProfessionFarming,
	[30267] = ProfessionFarming,
	[26856] = ProfessionFarming,
	[26857] = ProfessionFarming,
	[26858] = ProfessionFarming,
	[30235] = ProfessionFarming,
	[30236] = ProfessionFarming,
	[30237] = ProfessionFarming,
	[34245] = ProfessionFarming,
	[30262] = ProfessionFarming,
	[30263] = ProfessionFarming,
	[30264] = ProfessionFarming,
	[30247] = ProfessionFarming,
	[30248] = ProfessionFarming,
	[30249] = ProfessionFarming,
	[34248] = ProfessionFarming,
	[30279] = ProfessionFarming,
	[30280] = ProfessionFarming,
	[30281] = ProfessionFarming,
	[38158] = ProfessionBreeding,
	[38159] = ProfessionBreeding,
	[38160] = ProfessionBreeding,
	[34390] = ProfessionHusbandry,
	[34391] = ProfessionHusbandry,
	[34392] = ProfessionHusbandry,
	[34393] = ProfessionHusbandry,
	[34394] = ProfessionHusbandry,
	[34395] = ProfessionHusbandry,
	[34396] = ProfessionHusbandry,
	[34397] = ProfessionHusbandry,
	[34398] = ProfessionHusbandry,
	[34386] = ProfessionHusbandry,
	[34387] = ProfessionHusbandry,
	[34388] = ProfessionHusbandry,
	[34389] = ProfessionHusbandry,
	[34416] = ProfessionHusbandry,
	[34417] = ProfessionHusbandry,
	[34418] = ProfessionHusbandry,
	[34419] = ProfessionHusbandry,
	[34420] = ProfessionHusbandry,
	[34421] = ProfessionHusbandry,
	[34422] = ProfessionHusbandry,
	[34423] = ProfessionHusbandry,
	[34424] = ProfessionHusbandry,
	[34412] = ProfessionHusbandry,
	[34413] = ProfessionHusbandry,
	[34414] = ProfessionHusbandry,
	[34415] = ProfessionHusbandry,
	[34373] = ProfessionHusbandry,
	[34374] = ProfessionHusbandry,
	[34375] = ProfessionHusbandry,
	[34376] = ProfessionHusbandry,
	[34377] = ProfessionHusbandry,
	[34378] = ProfessionHusbandry,
	[34379] = ProfessionHusbandry,
	[34380] = ProfessionHusbandry,
	[34381] = ProfessionHusbandry,
	[34382] = ProfessionHusbandry,
	[34383] = ProfessionHusbandry,
	[34384] = ProfessionHusbandry,
	[34385] = ProfessionHusbandry,
	[34399] = ProfessionHusbandry,
	[34400] = ProfessionHusbandry,
	[34401] = ProfessionHusbandry,
	[34402] = ProfessionHusbandry,
	[34403] = ProfessionHusbandry,
	[34404] = ProfessionHusbandry,
	[34405] = ProfessionHusbandry,
	[34406] = ProfessionHusbandry,
	[34407] = ProfessionHusbandry,
	[34408] = ProfessionHusbandry,
	[34409] = ProfessionHusbandry,
	[34410] = ProfessionHusbandry,
	[34411] = ProfessionHusbandry,
	[34461] = ProfessionHusbandry,
	[34462] = ProfessionHusbandry,
	[34463] = ProfessionHusbandry,
	[34464] = ProfessionHusbandry,
	[34465] = ProfessionHusbandry,
	[34466] = ProfessionHusbandry,
	[34467] = ProfessionHusbandry,
	[34468] = ProfessionHusbandry,
	[34469] = ProfessionHusbandry,
	[34470] = ProfessionHusbandry,
	[34471] = ProfessionHusbandry,
	[34472] = ProfessionHusbandry,
	[34473] = ProfessionHusbandry,
	[34584] = ProfessionHusbandry,
	[34585] = ProfessionHusbandry,
	[34586] = ProfessionHusbandry,
	[34587] = ProfessionHusbandry,
	[34588] = ProfessionHusbandry,
	[34589] = ProfessionHusbandry,
	[34590] = ProfessionHusbandry,
	[34591] = ProfessionHusbandry,
	[34592] = ProfessionHusbandry,
	[34593] = ProfessionHusbandry,
	[34594] = ProfessionHusbandry,
	[34595] = ProfessionHusbandry,
	[34596] = ProfessionHusbandry,
	[34610] = ProfessionHusbandry,
	[34611] = ProfessionHusbandry,
	[34612] = ProfessionHusbandry,
	[34613] = ProfessionHusbandry,
	[34614] = ProfessionHusbandry,
	[34615] = ProfessionHusbandry,
	[34616] = ProfessionHusbandry,
	[34617] = ProfessionHusbandry,
	[34618] = ProfessionHusbandry,
	[34619] = ProfessionHusbandry,
	[34620] = ProfessionHusbandry,
	[34621] = ProfessionHusbandry,
	[34622] = ProfessionHusbandry,
	[34623] = ProfessionHusbandry,
	[34624] = ProfessionHusbandry,
	[34625] = ProfessionHusbandry,
	[34626] = ProfessionHusbandry,
	[34627] = ProfessionHusbandry,
	[34628] = ProfessionHusbandry,
	[34629] = ProfessionHusbandry,
	[34630] = ProfessionHusbandry,
	[34631] = ProfessionHusbandry,
	[34632] = ProfessionHusbandry,
	[34633] = ProfessionHusbandry,
	[34634] = ProfessionHusbandry,
	[34635] = ProfessionHusbandry,
	[34597] = ProfessionHusbandry,
	[34598] = ProfessionHusbandry,
	[34599] = ProfessionHusbandry,
	[34600] = ProfessionHusbandry,
	[34601] = ProfessionHusbandry,
	[34602] = ProfessionHusbandry,
	[34603] = ProfessionHusbandry,
	[34604] = ProfessionHusbandry,
	[34605] = ProfessionHusbandry,
	[34606] = ProfessionHusbandry,
	[34607] = ProfessionHusbandry,
	[34608] = ProfessionHusbandry,
	[34609] = ProfessionHusbandry,
	[34636] = ProfessionHusbandry,
	[34637] = ProfessionHusbandry,
	[34638] = ProfessionHusbandry,
	[34639] = ProfessionHusbandry,
	[34640] = ProfessionHusbandry,
	[34641] = ProfessionHusbandry,
	[34642] = ProfessionHusbandry,
	[34643] = ProfessionHusbandry,
	[34644] = ProfessionHusbandry,
	[34645] = ProfessionHusbandry,
	[34646] = ProfessionHusbandry,
	[34647] = ProfessionHusbandry,
	[34648] = ProfessionHusbandry,
	[35064] = ProfessionHusbandry,
	[35065] = ProfessionHusbandry,
	[35066] = ProfessionHusbandry,
	[35067] = ProfessionHusbandry,
	[35038] = ProfessionHusbandry,
	[35039] = ProfessionHusbandry,
	[35040] = ProfessionHusbandry,
	[35041] = ProfessionHusbandry,
	[35055] = ProfessionHusbandry,
	[35056] = ProfessionHusbandry,
	[35057] = ProfessionHusbandry,
	[35058] = ProfessionHusbandry,
	[35059] = ProfessionHusbandry,
	[35060] = ProfessionHusbandry,
	[35061] = ProfessionHusbandry,
	[35062] = ProfessionHusbandry,
	[35063] = ProfessionHusbandry,
	[35029] = ProfessionHusbandry,
	[35030] = ProfessionHusbandry,
	[35031] = ProfessionHusbandry,
	[35032] = ProfessionHusbandry,
	[35033] = ProfessionHusbandry,
	[35034] = ProfessionHusbandry,
	[35035] = ProfessionHusbandry,
	[35036] = ProfessionHusbandry,
	[35037] = ProfessionHusbandry,
	[35077] = ProfessionHusbandry,
	[35078] = ProfessionHusbandry,
	[35079] = ProfessionHusbandry,
	[35080] = ProfessionHusbandry,
	[35051] = ProfessionHusbandry,
	[35052] = ProfessionHusbandry,
	[35053] = ProfessionHusbandry,
	[35054] = ProfessionHusbandry,
	[35068] = ProfessionHusbandry,
	[35069] = ProfessionHusbandry,
	[35070] = ProfessionHusbandry,
	[35071] = ProfessionHusbandry,
	[35072] = ProfessionHusbandry,
	[35073] = ProfessionHusbandry,
	[35074] = ProfessionHusbandry,
	[35075] = ProfessionHusbandry,
	[35076] = ProfessionHusbandry,
	[35042] = ProfessionHusbandry,
	[35043] = ProfessionHusbandry,
	[35044] = ProfessionHusbandry,
	[35045] = ProfessionHusbandry,
	[35046] = ProfessionHusbandry,
	[35047] = ProfessionHusbandry,
	[35048] = ProfessionHusbandry,
	[35049] = ProfessionHusbandry,
	[35050] = ProfessionHusbandry,
	[37440] = ProfessionHusbandry,
	[37441] = ProfessionHusbandry,
	[30008] = ProfessionFishing,
	[33500] = ProfessionFishing,
	[39219] = ProfessionFishing,
	[49412] = ProfessionHerbalism,
	[49413] = ProfessionHerbalism,
	[49414] = ProfessionHerbalism,
	[49388] = ProfessionHerbalism,
	[49389] = ProfessionHerbalism,
	[49390] = ProfessionHerbalism,
	[49409] = ProfessionHerbalism,
	[49410] = ProfessionHerbalism,
	[49411] = ProfessionHerbalism,
	[49391] = ProfessionHerbalism,
	[49392] = ProfessionHerbalism,
	[49393] = ProfessionHerbalism,
	[49385] = ProfessionHerbalism,
	[49386] = ProfessionHerbalism,
	[49387] = ProfessionHerbalism,
	[49400] = ProfessionHerbalism,
	[49401] = ProfessionHerbalism,
	[49402] = ProfessionHerbalism,
	[49394] = ProfessionHerbalism,
	[49395] = ProfessionHerbalism,
	[49396] = ProfessionHerbalism,
	[49403] = ProfessionHerbalism,
	[49404] = ProfessionHerbalism,
	[49405] = ProfessionHerbalism,
	[49418] = ProfessionHerbalism,
	[49419] = ProfessionHerbalism,
	[49420] = ProfessionHerbalism,
	[49406] = ProfessionHerbalism,
	[49407] = ProfessionHerbalism,
	[49408] = ProfessionHerbalism,
	[49415] = ProfessionHerbalism,
	[49416] = ProfessionHerbalism,
	[49417] = ProfessionHerbalism,
	[49397] = ProfessionHerbalism,
	[49398] = ProfessionHerbalism,
	[49399] = ProfessionHerbalism,
	[49430] = ProfessionHerbalism,
	[49431] = ProfessionHerbalism,
	[49432] = ProfessionHerbalism,
	[49421] = ProfessionHerbalism,
	[49422] = ProfessionHerbalism,
	[49423] = ProfessionHerbalism,
	[49436] = ProfessionHerbalism,
	[49437] = ProfessionHerbalism,
	[49438] = ProfessionHerbalism,
	[49439] = ProfessionHerbalism,
	[49440] = ProfessionHerbalism,
	[49441] = ProfessionHerbalism,
	[49442] = ProfessionHerbalism,
	[49443] = ProfessionHerbalism,
	[49444] = ProfessionHerbalism,
	[49427] = ProfessionHerbalism,
	[49428] = ProfessionHerbalism,
	[49429] = ProfessionHerbalism,
	[49451] = ProfessionHerbalism,
	[49452] = ProfessionHerbalism,
	[49453] = ProfessionHerbalism,
	[49424] = ProfessionHerbalism,
	[49425] = ProfessionHerbalism,
	[49426] = ProfessionHerbalism,
	[49448] = ProfessionHerbalism,
	[49449] = ProfessionHerbalism,
	[49450] = ProfessionHerbalism,
	[49454] = ProfessionHerbalism,
	[49455] = ProfessionHerbalism,
	[49456] = ProfessionHerbalism,
	[49433] = ProfessionHerbalism,
	[49434] = ProfessionHerbalism,
	[49435] = ProfessionHerbalism,
	[49445] = ProfessionHerbalism,
	[49446] = ProfessionHerbalism,
	[49447] = ProfessionHerbalism,
	[49370] = ProfessionHerbalism,
	[49362] = ProfessionHerbalism,
	[49369] = ProfessionHerbalism,
	[49363] = ProfessionHerbalism,
	[49361] = ProfessionHerbalism,
	[49366] = ProfessionHerbalism,
	[49364] = ProfessionHerbalism,
	[49367] = ProfessionHerbalism,
	[49372] = ProfessionHerbalism,
	[49368] = ProfessionHerbalism,
	[49371] = ProfessionHerbalism,
	[49365] = ProfessionHerbalism,
	[49376] = ProfessionHerbalism,
	[49373] = ProfessionHerbalism,
	[49378] = ProfessionHerbalism,
	[49379] = ProfessionHerbalism,
	[49380] = ProfessionHerbalism,
	[49375] = ProfessionHerbalism,
	[49383] = ProfessionHerbalism,
	[49374] = ProfessionHerbalism,
	[49382] = ProfessionHerbalism,
	[49384] = ProfessionHerbalism,
	[49377] = ProfessionHerbalism,
	[49381] = ProfessionHerbalism
}
local interactableProfessionIcons = {
	[ProfessionFishing] = "/images/ui/icons/interactions/fishing",
	[ProfessionMining] = "/images/ui/icons/interactions/mining",
	[ProfessionFarming] = "/images/ui/icons/interactions/farming",
	[ProfessionBreeding] = "/images/ui/icons/interactions/breeding",
	[ProfessionCarpentry] = "/images/ui/icons/interactions/carpentry",
	[ProfessionBlacksmithing] = "/images/ui/icons/interactions/blacksmithing",
	[ProfessionHusbandry] = "/images/ui/icons/interactions/husbandry",
	[ProfessionWeaving] = "/images/ui/icons/interactions/weaving",
	[ProfessionCooking] = "/images/ui/icons/interactions/cooking",
	[ProfessionWoodcutting] = "/images/ui/icons/interactions/woodcutting",
	[ProfessionHerbalism] = "/images/ui/icons/interactions/herbalism",
	[ProfessionAlchemy] = "/images/ui/icons/interactions/alchemy"
}
local interactableProfessionExtendedIcons = {
	[ProfessionFishing] = "/images/ui/icons/interactions/rounded/fishing",
	[ProfessionMining] = "/images/ui/icons/interactions/rounded/mining",
	[ProfessionWoodcutting] = "/images/ui/icons/interactions/rounded/woodcutting",
	[ProfessionHerbalism] = "/images/ui/icons/interactions/rounded/herbalism"
}

function onTurn()
	needActionKeyUpdate = true
end

function onWalk()
	needActionKeyUpdate = true
end

function onHouseModeChange()
	needActionKeyUpdate = true
end

function onTalkableChange()
	needActionKeyUpdate = true
end

function sortDistance(a, b)
	local player = g_game.getLocalPlayer()
	local position = player:getPosition()
	local aDistance = Position.distance(position, a:getPosition())
	local bDistance = Position.distance(position, b:getPosition())

	if aDistance == bDistance then
		return a:getName() > b:getName()
	else
		return aDistance < bDistance
	end
end

function findNpcsInteractable(creatures)
	for _, creature in ipairs(creatures) do
		if creature:isNpc() and creature:isTalkable() and not creature:isHidden() then
			return creature
		end
	end
end

function findObjectsInteractable(items, extended)
	local forceInteractionItem, doorItem

	for _, item in pairs(items) do
		if not extended then
			if item:isQuestItem() then
				if item:isTaskItem() then
					if item:isInteractable() then
						return item
					elseif not forceInteractionItem then
						forceInteractionItem = item
					end
				elseif not doorItem and table.contains(DoorsIds, item:getId()) then
					doorItem = item
				end
			elseif item:isInteractable() and not item:isOtherLandItem() and not craftingIds[item:getId()] then
				return item
			elseif item:isAlwaysInteractable() then
				return item, true
			end
		elseif extended then
			local tile = item:getTile()
			local treeStand = tile:getTreeStandUseThing()

			if treeStand and not item:isOtherLandItem() then
				return treeStand
			end
		end
	end

	if forceInteractionItem then
		return forceInteractionItem, true
	end

	if doorItem then
		return doorItem
	end
end

function findCraftingInteractable(items)
	for _, item in pairs(items) do
		if item:isInteractable() and craftingIds[item:getId()] then
			return item
		end
	end
end

function getInteractableIcon(itemId, actionId)
	if modules.game_highlight_sparkles.GameHighlightSparkles.isMapRewardActionId(actionId) then
		return
	end

	local profession = interactableIconsToProfession[itemId]

	if not profession then
		return
	end

	if profession == ProfessionWoodcutting and actionId ~= 0 then
		return
	end

	return interactableProfessionIcons[profession]
end

function getInteractableExtendedIcon(itemId, actionId)
	local profession = interactableIconsToProfession[itemId]

	if not profession then
		return
	end

	if profession == ProfessionWoodcutting and actionId ~= 0 then
		return
	end

	return interactableProfessionExtendedIcons[profession]
end

function onUpdateActionKey(force)
	local player = g_game.getLocalPlayer()

	if not player or player:isChanneling() or g_game.isInHouseMode() then
		if not g_actionKey.isObjectRemoved() then
			g_actionKey.removeAction()
		end

		return
	end

	if not force and not needActionKeyUpdate and not g_actionKey.isObjectRemoved() then
		return
	else
		needActionKeyUpdate = false
	end

	local craftProfession, craftStation

	for professionId = ProfessionFirst, ProfessionLast do
		local station = player:isInCraftingArea(professionId)

		if station then
			craftStation = station
			craftProfession = professionId

			break
		end
	end

	local action
	local playerPosition = player:getPosition()

	if not playerPosition then
		return
	end

	local position = {
		y = 0,
		x = 0,
		z = playerPosition.z
	}
	local offsetList = checkDirectionPriotity[player:getDirection()] or {}

	for _, offset in ipairs(offsetList) do
		position.x = playerPosition.x + offset.x
		position.y = playerPosition.y + offset.y

		local tile = g_map.getTile(position)

		if tile then
			if offset.near and modules.game_waypoints.GameWaypoints:positionHasWaypoint(position) then
				local ground = tile:getGround()

				if ground then
					action = {
						type = "waypoint",
						thing = ground
					}

					break
				end
			end

			local creatures = tile:getCreatures()
			local npc = findNpcsInteractable(creatures)

			if npc then
				action = {
					type = "npc",
					thing = npc
				}

				break
			end

			for _, creature in ipairs(creatures) do
				if creature:getType() == CreatureTypeWagonOwn then
					action = {
						type = "wagon",
						thing = creature
					}

					break
				end
			end

			local items

			if craftProfession then
				items = tile:getItems()

				local craftable = findCraftingInteractable(items)

				if craftable then
					action = {
						type = "craft",
						thing = craftable,
						professionId = craftProfession,
						icon = interactableProfessionIcons[craftProfession] or interactableIcons[craftable:getId()]
					}

					break
				end
			end

			if offset.near then
				local interactable, ignoreInteractable = findObjectsInteractable(items or tile:getItems())

				if interactable then
					action = {
						type = "interact",
						thing = interactable,
						ignoreInteractable = ignoreInteractable,
						icon = getInteractableIcon(interactable:getId(), interactable:getActionId())
					}

					break
				end
			end

			local interactable = findObjectsInteractable(items or tile:getItems(), true)

			if interactable then
				action = {
					type = "interact",
					force = true,
					thing = interactable,
					icon = getInteractableIcon(interactable:getId(), interactable:getActionId())
				}

				break
			end
		end
	end

	if not action and craftStation then
		local checkPosition = {
			y = 0,
			x = 0,
			z = playerPosition.z
		}
		local craftTables = {}

		for x = craftStation.from.x, craftStation.to.x do
			for y = craftStation.from.y, craftStation.to.y do
				checkPosition.x = x
				checkPosition.y = y

				local tile = g_map.getTile(checkPosition)

				if tile then
					local items = tile:getItems()
					local craftable = findCraftingInteractable(items)

					if craftable then
						table.insert(craftTables, craftable)
					end
				end
			end
		end

		if not table.empty(craftTables) then
			table.sort(craftTables, sortDistance)

			action = {
				type = "craft",
				thing = craftTables[1],
				professionId = craftProfession,
				icon = interactableProfessionIcons[craftProfession] or interactableIcons[craftTables[1]:getId()]
			}
		end
	end

	if not action then
		if currentActionObject then
			g_actionKey.removeAction()
		end

		return
	end

	local thing = action.thing

	if action.thing == currentActionObject then
		return
	end

	if action.type == "waypoint" then
		g_actionKey.setAction(thing, "Interact", function()
			modules.game_waypoints.GameWaypoints:show()
		end, true, {
			x = 54,
			y = 118
		})
	elseif action.type == "npc" then
		g_actionKey.setAction(thing, "Talk", function()
			local player = g_game.getLocalPlayer()

			if player and not player:isChanneling() then
				g_game.attack(thing)
			end
		end)
	elseif action.type == "wagon" then
		g_actionKey.setAction(thing, "Get on Wagon", function()
			sendOpcode(ExtendedIds.Wagon, {
				action = "on"
			})
		end)
	elseif action.type == "craft" then
		g_actionKey.setAction(thing, "Craft", function()
			local module = modules.game_professions.GameProfessions

			module:requestOpenCraftingWindow(action.professionId)
		end, false, nil, action.icon)
	elseif action.type == "interact" then
		if thing:isTradepackItem() then
			g_actionKey.setAction(thing, "Take", function()
				sendOpcode(ExtendedIds.Trading, {
					action = "take_tradepack",
					position = thing:getPosition()
				})
			end, false, nil, action.icon)

			return
		elseif thing:isFishpackItem() then
			g_actionKey.setAction(thing, "Take", function()
				sendOpcode(ExtendedIds.Trading, {
					action = "take_fishpack",
					position = thing:getPosition()
				})
			end, false, nil, action.icon)

			return
		end

		g_actionKey.setAction(thing, "Interact", function()
			if thing:isReplaced() then
				if type(thing.onReplacedUse) == "table" then
					for _, func in ipairs(thing.onReplacedUse) do
						func(thing, nil, nil, player:isWalking())
					end
				else
					thing:onReplacedUse(nil, nil, player:isWalking())
				end
			end

			g_game.use(thing)
		end, action.ignoreInteractable, nil, action.icon)
	end
end

function g_actionKey.isObjectRemoved()
	if not currentActionObject then
		return true
	end

	if currentActionObject:isCreature() then
		return currentActionObject:isRemoved()
	end

	local tile = currentActionObject:getTile()

	if tile then
		for _, item in pairs(tile:getItems()) do
			if currentActionObject == item then
				return false
			end
		end
	end

	return true
end

function onGameStart()
	if not actionKeyCycleEvent then
		addEvent(function()
			actionKeyCycleEvent = cycleEvent(onUpdateActionKey, 500)
		end)
	end
end

function onGameEnd()
	if actionKeyCycleEvent then
		removeEvent(actionKeyCycleEvent)

		actionKeyCycleEvent = nil
	end
end

function g_actionKey.setAction(object, text, callback, ignoreInteractable, margin, icon)
	if not object or not text or not callback then
		return
	end

	g_actionKey.removeAction()
	g_keyboard.bindKeyUp("F", function()
		if not IsTextEditActive() then
			callback()
		end
	end)

	if margin then
		if margin.x then
			actionKeyPanel:setMarginLeft(margin.x)
		end

		if margin.y then
			actionKeyPanel:setMarginTop(margin.y)
		end
	else
		actionKeyPanel:setMarginLeft(0)
		actionKeyPanel:setMarginTop(-10)
	end

	local iconHolder = actionKeyPanel:getChildById("iconHolder")

	if icon then
		iconHolder:getChildById("icon"):setImageSource(icon)
		iconHolder:setVisible(true)
	else
		iconHolder:setVisible(false)
	end

	object:setActionKeyWidget(actionKeyPanel, ignoreInteractable)
	actionKeyPanel:getChildById("text"):setText(text)
	g_effects.fadeIn(actionKeyPanel, 200)

	if text == "Craft" then
		modules.game_professions.GameProfessions.refreshOwnedMaterials()
	end

	currentActionObject = object
end

function g_actionKey.getAction()
	return actionKeyPanel:getText()
end

function g_actionKey.removeAction()
	g_keyboard.unbindKeyUp("F")

	if currentActionObject then
		currentActionObject:setActionKeyWidget(nil)

		currentActionObject = nil
	end

	if g_actionKey.getAction() == "Craft" then
		modules.game_professions.GameProfessions.refreshOwnedMaterials()
	end
end

function g_actionKey.setOpacity(value)
	addEvent(function()
		actionKeyPanel:setImageColor("#ffffff" .. string.format("%x", math.max(0, value / 100) * 255))
	end)
end

function Item:isQuestItem()
	local actionId, uniqueId, itemId = self:getActionId(), self:getUniqueId(), self:getId()

	return actionId >= 10000 and actionId <= 11000 or uniqueId >= 10000 and uniqueId <= 11000 or QuestItemsItemId[itemId] ~= nil
end

function Item:isTaskItem()
	local excludeAids, excludeUids = {
		10419,
		10420,
		10505,
		10506
	}, {
		10024,
		10181,
		10201
	}
	local actionId, uniqueId, itemId = self:getActionId(), self:getUniqueId(), self:getId()

	if QuestItemsActionId[actionId] and table.find(excludeAids, actionId) or QuestItemsUniqueId[uniqueId] and table.find(excludeUids, uniqueId) then
		return true
	end

	local conditions = {
		QuestItemsActionId[actionId],
		QuestItemsUniqueId[uniqueId],
		QuestItemsItemId[itemId]
	}

	for _, condition in pairs(conditions) do
		local valid = true

		if condition.itemId then
			if type(condition.itemId) == "table" then
				valid = table.contains(condition.itemId, itemId)
			else
				valid = itemId == condition.itemId
			end
		end

		if valid then
			if condition.mapReward then
				return modules.game_highlight_sparkles.GameHighlightSparkles.checkMapReward(self:getPosition())
			elseif condition.quest then
				if condition.hidden then
					return false
				end

				if condition.always then
					return true
				end

				if condition.afterComplete and modules.game_questlog.GameQuestLog:isQuestCompleted(condition.quest) then
					return true
				end

				if condition.isActive and modules.game_questlog.GameQuestLog:isQuestActive(condition.quest) then
					return true
				end

				if condition.taskId and modules.game_questlog.GameQuestLog:isQuestTasksActive(condition.quest, condition.taskId) then
					return true
				end
			elseif condition.event then
				if condition.always then
					return true
				end

				if condition.notActive and not modules.game_questlog.GameQuestLog:isEventActive(condition.event) then
					return true
				end

				if condition.taskId and modules.game_questlog.GameQuestLog:isEventStageActive(condition.event, condition.taskId) then
					return true
				end
			elseif condition.artifactRegion then
				if condition.always then
					return true
				end

				if condition.progress and modules.game_journal.GameJournal:getArtifactRegionProgress(condition.artifactRegion) >= condition.progress then
					return true
				end
			end
		end
	end

	return false
end

function Item:isAlwaysInteractable()
	return AlwaysInteractableActionId[self:getActionId()]
end

function Item:isTradepackItem()
	return self:isInteractable() and tradepackIds[self:getId()]
end

function Item:isFishpackItem()
	return self:isInteractable() and fishpackIds[self:getId()]
end

function Item:isCulledEyePack()
	return self:isInteractable() and culledEyePackIds[self:getId()]
end

function Item:isPlunderChest()
	return self:isInteractable() and plunderChestIds[self:getId()]
end

function Item:isOtherLandItem()
	local tile = self:getTile()

	return tile and tile:getProperty() ~= PropertyOwn and tile:getProperty() ~= PropertyNone
end

function Item:onAppear()
	if not self:isInteractable() or self:isOtherLandItem() then
		return
	end

	local icon = getInteractableExtendedIcon(self:getId(), self:getActionId())

	if icon then
		local widget = self:getInteractionWidget() or g_ui.createWidget("ActionIcon")

		if widget then
			widget:setImageSource(icon)
			widget:setImageColor("#ffffff" .. string.format("%x", math.max(0, modules.game_settings.getOption("actionKeyOpacity") / 100) * 255))
			self:setInteractionWidget(widget)
		end
	end

	self:onAppearTryReplace()
end

g_actionKey.init()
connect(g_app, {
	onTerminate = g_actionKey.terminate
})
