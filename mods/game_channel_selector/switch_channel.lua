-- chunkname: @/modules/game_channel_selector/switch_channel.lua

GameSwitchChannel = {}

function GameSwitchChannel:init()
	g_ui.importStyle("switch_channel.otui")

	self.window = g_ui.createWidget("GameSwitchChannelWindow", modules.game_interface.getHUDPanel())

	function self.window:onVisibilityChange(visible)
		if visible then
			return
		end

		if self.confirmBox then
			self.confirmBox:destroy()

			self.confirmBox = nil
		end
	end

	connect(g_game, {
		onGameEnd = self.onGameEnd,
		onUpdateChannelInfo = self.onUpdateChannelInfo
	})
	ProtocolGame.registerExtendedOpcode(ExtendedIds.ChannelSelector, self.onExtendedOpcode)
end

function GameSwitchChannel:terminate()
	self.window:destroy()
	disconnect(g_game, {
		onGameEnd = self.onGameEnd,
		onUpdateChannelInfo = self.onUpdateChannelInfo
	})
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.ChannelSelector)

	GameSwitchChannel = nil
end

function GameSwitchChannel.onGameEnd()
	local self = GameSwitchChannel

	self.window:hide()
end

function GameSwitchChannel:show()
	if self.window:isVisible() then
		return
	end

	self.window:show()
	self.window:raise()
end

function GameSwitchChannel:hide()
	self.window:hide()
end

function GameSwitchChannel:toggle()
	if self.window:isVisible() then
		self:hide()

		return
	end

	self:show()
end

function GameSwitchChannel:sendOpcode(data)
	local protocol = g_game.getProtocolGame()

	if not protocol then
		return
	end

	protocol:sendExtendedOpcode(ExtendedIds.ChannelSelector, g_game.serializeTable(data))
end

function GameSwitchChannel:requestChangeChannel(warmode)
	self:sendOpcode({
		action = "change_channel",
		warmode = warmode
	})
end

function GameSwitchChannel:requestLeaveWarmode()
	self:sendOpcode({
		action = "leave_warmode"
	})
end

function GameSwitchChannel:requestLeavePlunderMode()
	self:sendOpcode({
		action = "leave_plundermode"
	})
end

function GameSwitchChannel.onExtendedOpcode(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.ChannelSelector then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		return
	end

	if data.action == "channel_info" then
		G.channelsInfo = data.channels

		signalcall(g_game.onUpdateChannelInfo, data.channels)
	end
end

function GameSwitchChannel.onUpdateChannelInfo(channelsInfo)
	local self = GameSwitchChannel
	local warmodeButton = self.window.content.warmode_button

	if warmodeButton then
		warmodeButton:setChecked(g_game.isWarmodeChannel())
	end

	local plunderButton = self.window.content.plundermode_button

	plunderButton:setChecked(g_game.isPlunderModeChannel())
end

function GameSwitchChannel:onChangeChannelsButtonClicked(warmode, ignoreConfirmation)
	if not warmode or warmode == 0 then
		self:requestChangeChannel(false)
	elseif warmode == CHANNEL_TYPE.WARMODE then
		self:onTryJoinWarmode(ignoreConfirmation)
	elseif warmode == CHANNEL_TYPE.PLUNDER then
		self:onTryJoinPlunderMode(ignoreConfirmation)
	end
end

function GameSwitchChannel:onLeaveWarmodeButtonClicked()
	self:requestLeaveWarmode()
end

function GameSwitchChannel:onTryJoinWarmode(ignoreConfirmation)
	self:requestChangeChannel(CHANNEL_TYPE.WARMODE)
end

function GameSwitchChannel:onLeavePlunderButtonClicked()
	self:requestLeavePlunderMode()
end

function GameSwitchChannel:onTryJoinPlunderMode(ignoreConfirmation)
	self:requestChangeChannel(CHANNEL_TYPE.PLUNDER)
end

function GameSwitchChannel:requestJoinFriendChannel(playerId)
	self:sendOpcode({
		action = "join_friend_channel",
		playerId = playerId
	})
end
