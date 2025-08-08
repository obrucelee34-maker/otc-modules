-- chunkname: @/modules/game_chat/config.lua

channelNames = {
	"general",
	"global",
	"system",
	"battle",
	"party",
	"guild",
	"lfg",
	"trade"
}
defaultSettings = {
	keepChatOpen = false,
	fontSize = 14,
	globalChat = "english",
	tabScrollButtons = true,
	alwaysShowTabNames = false,
	default = true,
	hidePopoutMessageDelay = 15500,
	backgroundOpacity = 80,
	opactity = 100,
	guildLoginNotifications = true,
	autoOpenPrivateMessages = true,
	hideNpcInGeneral = false,
	autoClearPopupMessages = false,
	channels = {
		general = {
			open = true
		},
		global = {
			open = true,
			inGeneral = modules.game_settings.getOption("showGlobalChatInGeneralChat")
		},
		system = {
			inGeneral = false,
			open = true
		},
		battle = {
			inGeneral = false,
			open = true
		},
		party = {
			inGeneral = true,
			open = false
		},
		guild = {
			inGeneral = true,
			open = false
		},
		lfg = {
			open = false,
			inGeneral = modules.game_settings.getOption("showLFGChatInGeneralChat")
		},
		trade = {
			inGeneral = false,
			open = true
		}
	},
	privateTabs = {},
	hideChatOnSend = not modules.game_settings.getOption("keepChatOpenAfterSending")
}
globalNameToLanguage = {
	global_br = "portuguese",
	global_en = "english",
	global_pl = "polish",
	global_es = "spanish"
}
channelConfigs = {
	general = {
		name = "general",
		tooltip = "General Chat",
		isTab = true
	},
	global = {
		name = "global",
		selection = {
			english = {
				shortCode = "en",
				buffer = "global_en",
				name = "english",
				tooltip = "English Global Chat",
				channelId = 8,
				hasSelection = true,
				order = 1
			},
			portuguese = {
				shortCode = "br",
				buffer = "global_br",
				name = "portuguese",
				tooltip = "Portuguese Global Chat",
				channelId = 9,
				hasSelection = true,
				order = 2
			},
			polish = {
				shortCode = "pl",
				buffer = "global_pl",
				name = "polish",
				tooltip = "Polish Global Chat",
				channelId = 10,
				hasSelection = true,
				order = 3
			},
			spanish = {
				shortCode = "es",
				buffer = "global_es",
				name = "spanish",
				tooltip = "Spanish Global Chat",
				channelId = 11,
				hasSelection = true,
				order = 4
			}
		}
	},
	system = {
		tooltip = "System Log",
		bufferSize = 50,
		name = "system",
		internal = true,
		isTab = true,
		minimizedNotification = false
	},
	battle = {
		tooltip = "Battle Log",
		bufferSize = 50,
		name = "battle",
		internal = true,
		isTab = true,
		minimizedNotification = false
	},
	party = {
		tooltip = "Party Chat",
		name = "party",
		channelId = 1,
		isTab = true,
		canShow = function(tab, player)
			return player and player:isPartyLeader() or player:isPartyMember()
		end
	},
	guild = {
		tooltip = "Guild Chat",
		name = "guild",
		channelId = 2,
		isTab = true,
		canShow = function(tab, player)
			return player and player:hasGuild()
		end
	},
	lfg = {
		name = "lfg",
		channelId = 12,
		isTab = true,
		tooltip = "Looking for Group"
	},
	trade = {
		name = "trade",
		channelId = 13,
		isTab = true,
		tooltip = "Trade"
	}
}
channelIdToBufferName = {}

for _, info in pairs(channelConfigs) do
	if info.selection then
		for _, selection in pairs(info.selection) do
			channelIdToBufferName[selection.channelId] = selection.buffer
		end
	elseif info.channelId then
		channelIdToBufferName[info.channelId] = info.name
	end
end

textModeSettings = {
	[TextTypes.TextTypeConsoleBlue] = {
		color = "#FCBE7F",
		tab = "system"
	},
	[TextTypes.TextTypeConsoleRed] = {
		color = "#FCBE7F",
		tab = "system"
	},
	[TextTypes.TextTypeDefault] = {
		color = "#FCBE7F",
		tab = "system"
	},
	[TextTypes.TextTypeWarning] = {
		color = "#FCBE7F",
		tab = "system",
		type = NOTIFICATION_WARNING
	},
	[TextTypes.TextTypeEventAdvance] = {
		color = "#FCBE7F",
		tab = "system",
		type = NOTIFICATION_INFO
	},
	[TextTypes.TextTypeSmall] = {
		color = "#FCBE7F",
		tab = "system"
	},
	[TextTypes.TextTypeInfoDescription] = {
		color = "#FCBE7F",
		tab = "system",
		type = NOTIFICATION_WARNING
	},
	[TextTypes.TextTypeDamageDealt] = {
		color = "#FCBE7F",
		tab = "battle"
	},
	[TextTypes.TextTypeDamageOthers] = {
		color = "#FCBE7F",
		tab = "battle"
	},
	[TextTypes.TextTypeDamageReceived] = {
		color = "#FCBE7F",
		tab = "battle"
	},
	[TextTypes.TextTypeHeal] = {
		color = "#FCBE7F",
		tab = "battle"
	},
	[TextTypes.TextTypeHealOthers] = {
		color = "#FCBE7F",
		tab = "battle"
	},
	[TextTypes.TextTypeExp] = {
		color = "#FCBE7F",
		tab = "battle"
	},
	[TextTypes.TextTypeExpOthers] = {
		color = "#FCBE7F",
		tab = "battle"
	},
	[TextTypes.TextTypeEventDefault] = {
		color = "#FCBE7F",
		tab = "battle"
	},
	[TextTypes.TextTypeLoot] = {
		color = "#FCBE7F",
		tab = "system"
	},
	[TextTypes.TextTypeConsoleOrange] = {
		color = "#FCBE7F",
		tab = "system"
	},
	[TextTypes.TextTypeConsoleWhite] = {
		color = "#FCBE7F",
		tab = "system"
	},
	[TextTypes.TextTypeEventOrange] = {
		color = "#FCBE7F",
		tab = "system"
	},
	[TextTypes.TextTypeLook] = {
		color = "#FCBE7F",
		tab = "system"
	},
	[TextTypes.TextTypeProgress] = {
		color = "#FCBE7F",
		tab = "system",
		type = NOTIFICATION_SUCCESS
	},
	[TextTypes.TextTypeBroadcast] = {
		color = "#FF5151",
		tab = "general",
		type = NOTIFICATION_STAFF
	},
	[TextTypes.TextTypeSpeechBubble] = {
		color = "#CED2D9",
		tab = "general"
	},
	[TextTypes.TextTypeError] = {
		color = "#FCBE7F",
		tab = "system",
		type = NOTIFICATION_ERROR
	},
	[TextTypes.TextTypeScreenBox] = {
		tab = "system"
	},
	[TextTypes.TextTypeScreenBoxNoDuration] = {
		tab = "system"
	},
	[TextTypes.TextTypeScreenError] = {
		tab = "system"
	}
}
talkModeSettings = {
	[TalkTypes.TalkTypeSay] = {
		tab = "general",
		color = {
			send = "#FFFFFF",
			receive = "#CED2D9"
		}
	},
	[TalkTypes.TalkTypePrivateFrom] = {
		private = true,
		ignoreSelf = true,
		color = {
			send = "#A556FF",
			receive = "#A556FF"
		}
	},
	[TalkTypes.TalkTypePrivateTo] = {
		private = true,
		color = {
			send = "#D3ACFF",
			receive = "#D3ACFF"
		}
	},
	[TalkTypes.TalkTypeChannelWhite] = {
		tab = "global",
		color = {
			send = "#FFFFFF",
			receive = "#CED2D9"
		}
	},
	[TalkTypes.TalkTypeChannelYellow] = {
		tab = "global",
		color = {
			send = "#FFFFFF",
			receive = "#CED2D9"
		}
	},
	[TalkTypes.TalkTypeChannelOrange] = {
		tab = "global",
		color = {
			send = "#FFFFFF",
			receive = "#CED2D9"
		}
	},
	[TalkTypes.TalkTypeGamemasterBroadcast] = {
		tab = "general",
		color = {
			send = "#FF5151",
			receive = "#FF5151"
		}
	},
	[TalkTypes.TalkTypeGameMasterPrivateFrom] = {
		private = true,
		ignoreSelf = true,
		color = {
			send = "#FF5151",
			receive = "#FF5151"
		}
	},
	[TalkTypes.TalkTypeGameMasterPrivateTo] = {
		private = true,
		color = {
			send = "#A2CAFB",
			receive = "#A2CAFB"
		}
	},
	[TalkTypes.TalkTypeChannelGold] = {
		tab = "global",
		color = {
			send = "#FFFFFF",
			receive = "#CED2D9"
		}
	},
	[TalkTypes.TalkTypeChannelGreen] = {
		tab = "global",
		color = {
			send = "#FFFFFF",
			receive = "#CED2D9"
		}
	}
}
chatMessageTitlePrefix = {
	global_es = "[Global-ES]",
	guild = "[Guild]",
	party = "[Party]",
	trade = "[Trade]",
	global_br = "[Global-BR]",
	global_en = "[Global-EN]",
	lfg = "[LFG]",
	global_pl = "[Global-PL]",
	private = "[Whisper]",
	general = "[General]"
}
defaultFont = "poppins"
defaultFontSize = 14
messageHistorySize = 50
messageBufferSize = 50
npcTextColor = "#FEFEC6"
partyTextColor = {
	send = "#A2CAFB",
	receive = "#5DA4FB"
}
guildTextColor = {
	send = "#ADD2A5",
	receive = "#77D463"
}
premiumTextColor = {
	send = "#F8D97F",
	receive = "#F7B900"
}
LFGTextColor = {
	send = "#FFFFFF",
	receive = "#CED2D9"
}
tradeTextColor = {
	send = "#FFFFFF",
	receive = "#CED2D9"
}
LuaChannelId = 7
PartyChannelId = 1
GuildChannelId = 2
LFGChannelId = 12
TradeChannelId = 13
talkTypes = {
	{
		name = "Local",
		color = "#CED2D9"
	},
	{
		name = "Whisper",
		color = "#A556FF"
	},
	{
		name = "Party",
		color = "#5DA4FB"
	},
	{
		name = "Guild",
		color = "#77D463"
	},
	{
		name = "Global",
		color = "#CED2D9"
	},
	{
		name = "Looking for Group",
		id = "lfg",
		color = "#CED2D9"
	},
	{
		name = "Trade",
		color = "#CED2D9"
	}
}
talkTypesColor = {}

for _, t in ipairs(talkTypes) do
	talkTypesColor[t.name] = t.color
end

TYPING_SFX = 899728676
SEND_MESSAGE_SFX = 3863070935
SEND_WHISPER_SFX = 2845289928
RECEIVE_WHISPER_SFX = 4234828879
