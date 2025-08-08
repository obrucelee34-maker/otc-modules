-- chunkname: @/modules/game_social/social.lua

GameSocial = {
	mailboxTotalMails = 0,
	mailUnreadCount = -1,
	partyRequestCount = -1,
	friendsRequestCount = -1,
	allowedLevelGap = 10,
	mailboxMailsPerPage = 14,
	mailboxPage = 1,
	ignoredPlayers = {}
}
STATUS_OFFLINE = 1
STATUS_ONLINE = 2
STATUS_ONLINE_OTHER_CHANNEL = 3

function GameSocial:init()
	g_ui.importStyle("styles/main.otui")
	g_ui.importStyle("styles/friends_panel.otui")
	g_ui.importStyle("styles/party_panel.otui")
	g_ui.importStyle("styles/mail_panel.otui")

	local HUDPanel = modules.game_interface.getHUDPanel()

	self.window = g_ui.createWidget("GameSocialWindow", HUDPanel)

	self.window:hide()

	self.friends_panel = g_ui.createWidget("GameSocialFriendsPanel", self.window.content)

	self.friends_panel:hide()

	self.party_panel = g_ui.createWidget("GameSocialPartyPanel", self.window.content)

	self.party_panel:hide()

	self.mail_panel = g_ui.createWidget("GameSocialMailPanel", self.window.content)

	self.mail_panel:hide()
	self:selectTab("friends")
	ProtocolGame.registerExtendedOpcode(ExtendedIds.Friends, GameSocial.onFriendsExtendedOpcode)
	ProtocolGame.registerExtendedOpcode(ExtendedIds.PartyManager, GameSocial.onPartyExtendedOpcode, "game_social")
	ProtocolGame.registerExtendedOpcode(ExtendedIds.Mailbox, GameSocial.onMailExtendedOpcode, "game_social")
	connect(g_game, {
		onGameStart = GameSocial.onGameStart,
		onGameEnd = GameSocial.onGameEnd
	})
end

function GameSocial:terminate()
	self.window:destroy()

	if self.confirmationWindow then
		self.confirmationWindow:destroy()

		self.confirmationWindow = nil
	end

	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.Friends)
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.PartyManager, "game_social")
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.Mailbox, "game_social")
	disconnect(g_game, {
		onGameStart = GameSocial.onGameStart,
		onGameEnd = GameSocial.onGameEnd
	})

	GameSocial = nil
end

function GameSocial.isEnabled()
	return not g_game.isAetherRiftChannel() and not g_game.isGuildWarsChannel()
end

function GameSocial.toggle(mouseClick)
	if GameChat:isActive() or (type(mouseClick) ~= "boolean" or not mouseClick) and IsTextEditActive() then
		return
	end

	if GameSocial.window:isVisible() then
		GameSocial.window:hide()
	else
		if g_game:isInCutsceneMode() or not GameSocial.isEnabled() then
			return
		end

		GameSocial.window:show()
		GameSocial.window:raise()
	end
end

function GameSocial:selectTab(tab)
	if self.current_panel then
		self.current_panel:hide()
	end

	if self.current_button then
		self.current_button:setOn(false)
	end

	local button = self.window.selection_panel[tab]

	button:setOn(true)

	self.current_button = button

	if tab == "friends" then
		self.current_panel = self.friends_panel
	elseif tab == "party" then
		self.current_panel = self.party_panel
	elseif tab == "mail" then
		self.current_panel = self.mail_panel
	end

	self.current_panel:show()
end

function GameSocial.onFriendsExtendedOpcode(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.Friends then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if not data or type(data) ~= "table" then
		return
	end

	if data.action == "friend_request" then
		GameSocial:addFriendRequest(data.data)
	elseif data.action == "friends_data" then
		GameSocial:updateFriendsPanel(data.data)
	elseif data.action == "friend_reject" then
		GameSocial:removeFriendRequest(data)
	elseif data.action == "friend_accept" then
		GameSocial:removeFriendRequest(data.data)
		GameSocial:addFriend(data.data)
	elseif data.action == "friend_status" then
		GameSocial:updateFriendStatus(data.data)
	elseif data.action == "friend_remove" then
		GameSocial:removeFriend(data)
	elseif data.action == "requests_config" then
		local widget, value = modules.game_settings.GameSettings:getSettingWidgetAndValue("acceptRequests", data.value)

		if widget and value then
			modules.game_settings.GameSettings.setWidgetValue(widget, value)
		end
	end
end

function GameSocial:sendFriendsOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.Friends, g_game.serializeTable(data))
	end
end

function GameSocial:addFriendRequest(data)
	local panel = self.window.content.friends_panel.content.request_panel.list
	local widget = g_ui.createWidget("GameSocialFriendsPanelRequest", panel)

	widget:setId(data.guid)
	widget.name:setText(data.name)

	widget.requestType = data.outgoing and "outgoing" or data.incoming and "incoming"

	widget.name:setText(string.format("%s %s", data.name:titleCase(), widget.requestType == "outgoing" and "(pending)" or ""))

	if widget.requestType == "outgoing" then
		widget.request_panel.accept_button:hide()
	end

	widget.data = data
	widget.data.guid = data.guid

	local oldCount = self.friendsRequestCount

	self.friendsRequestCount = panel:getChildCount()

	panel:getParent().counter:setText(string.format("%d", self.friendsRequestCount))
	panel:setup()
	signalcall(GameSocial.onUpdateFriendsPanel, oldCount, self.friendsRequestCount)
end

function GameSocial:removeFriendRequest(data)
	local panel = self.window.content.friends_panel.content.request_panel.list

	for _, child in pairs(panel:getChildren()) do
		if child.data.guid == data.guid then
			child:destroy()

			break
		end
	end

	self.friendsRequestCount = panel:getChildCount()

	panel:getParent().counter:setText(string.format("%d", panel:getChildCount()))
	panel:setup()
end

function GameSocial:removeFriend(data)
	local online_panel = self.window.content.friends_panel.content.online_panel.list
	local offline_panel = self.window.content.friends_panel.content.offline_panel.list
	local widget = online_panel[data.guid] or offline_panel[data.guid]

	if widget then
		local parent = widget:getParent()

		widget:destroy()
		parent:setup()
	end
end

function GameSocial:addFriend(data)
	local online_panel = self.window.content.friends_panel.content.online_panel.list
	local offline_panel = self.window.content.friends_panel.content.offline_panel.list
	local widget = g_ui.createWidget("GameSocialFriendsPanelFriend", data.status == STATUS_OFFLINE and offline_panel or online_panel)

	widget:setId(data.guid)

	widget.data = data
	widget.data.guid = data.guid

	widget.name:setText(data.name:titleCase(true))
	widget.icon:setOn(data.status ~= STATUS_OFFLINE)
	widget.icon:setChecked(data.status == STATUS_ONLINE_OTHER_CHANNEL)
	widget.options_panel.party_invite_button:setVisible(data.status ~= STATUS_OFFLINE)
	widget.options_panel.channel_swap_button:setVisible(data.status == STATUS_ONLINE_OTHER_CHANNEL)
	online_panel:setup()
	offline_panel:setup()
end

function GameSocial:updateFriendsPanel(data)
	local panel = self.window.content.friends_panel.content.request_panel.list

	panel:destroyChildren()

	for guid, friend in pairs(data.requests) do
		local widget = g_ui.createWidget("GameSocialFriendsPanelRequest", panel)

		widget:setId(guid)

		widget.data = friend
		widget.data.guid = guid
		widget.requestType = friend.outgoing and "outgoing" or friend.incoming and "incoming" or nil

		widget.name:setText(string.format("%s %s", friend.name:titleCase(true), widget.requestType == "outgoing" and "(pending)" or ""))

		if widget.requestType == "outgoing" then
			widget.request_panel.accept_button:hide()
		end
	end

	self.friendsRequestCount = panel:getChildCount()

	panel:getParent().counter:setText(string.format("%d", self.friendsRequestCount))
	panel:setup()

	local online_panel = self.window.content.friends_panel.content.online_panel.list
	local offline_panel = self.window.content.friends_panel.content.offline_panel.list

	online_panel:destroyChildren()
	offline_panel:destroyChildren()

	for guid, friend in pairs(data.friends) do
		local widget = g_ui.createWidget("GameSocialFriendsPanelFriend", friend.status == STATUS_OFFLINE and offline_panel or online_panel)

		widget:setId(guid)

		widget.data = friend
		widget.data.guid = guid

		widget.name:setText(friend.name:titleCase(true))
		widget.icon:setOn(friend.status ~= STATUS_OFFLINE)
		widget.icon:setChecked(friend.status == STATUS_ONLINE_OTHER_CHANNEL)
		widget.options_panel.party_invite_button:setVisible(friend.status ~= STATUS_OFFLINE)
		widget.options_panel.channel_swap_button:setVisible(friend.status == STATUS_ONLINE_OTHER_CHANNEL)
	end

	online_panel:setup()
	offline_panel:setup()
end

function GameSocial:onAddFriendButtonClicked()
	if self.popupBox then
		return
	end

	self.popupBox = displayTextInputBox(tr("Add Friend"), tr("Enter the name of the player you want to add to your friends list."), "", function(name)
		self.popupBox = nil

		if not name or name == "" then
			return
		end

		GameSocial:sendFriendsOpcode({
			action = "add_friend",
			name = name
		})

		return true
	end, function()
		self.popupBox = nil
	end)

	self.popupBox:setParent(self.window)
	self.popupBox:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
	self.popupBox:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
	self.popupBox.lineEdit:recursiveFocus()
end

function GameSocial:acceptFriendRequest(widget)
	GameSocial:sendFriendsOpcode({
		action = "accept_friend",
		guid = widget.data.guid
	})
end

function GameSocial:rejectFriendRequest(widget)
	GameSocial:sendFriendsOpcode({
		action = "reject_friend",
		guid = widget.data.guid
	})
end

function GameSocial:updateFriendStatus(data)
	local online_panel = self.window.content.friends_panel.content.online_panel.list
	local offline_panel = self.window.content.friends_panel.content.offline_panel.list
	local online = online_panel[data.guid]
	local offline = offline_panel[data.guid]
	local widget = online or offline

	if not widget then
		return
	end

	widget.icon:setOn(data.status ~= STATUS_OFFLINE)
	widget.icon:setChecked(G.currentChannelId ~= data.channelId)
	widget.options_panel.party_invite_button:setVisible(widget.icon:isOn())
	widget.options_panel.channel_swap_button:setVisible(widget.icon:isOn() and G.currentChannelId ~= data.channelId)
	widget:setParent(widget.icon:isOn() and online_panel or offline_panel)
	online_panel:setup()
	offline_panel:setup()
end

function GameSocial:onWhisperButtonClicked(widget)
	GameChat:whisperPlayer(widget.data.name)
end

function GameSocial:onRemoveFriendButtonClicked(widget)
	if self.confirmationWindow then
		self.confirmationWindow:destroy()

		self.confirmationWindow = nil
	end

	local function yesCallback()
		self.confirmationWindow:destroy()

		self.confirmationWindow = nil

		self:sendFriendsOpcode({
			action = "remove_friend",
			guid = widget.data.guid
		})
	end

	local function noCallback()
		self.confirmationWindow:destroy()

		self.confirmationWindow = nil
	end

	self.confirmationWindow = displayGeneralBox(tr("Remove Friend"), tr(string.format("Are you sure you want to remove |%s| from your friends list?", widget.data.name)), {
		{
			text = tr("Yes"),
			callback = yesCallback
		},
		{
			text = tr("No"),
			callback = noCallback
		},
		anchor = AnchorHorizontalCenter
	}, yesCallback, noCallback, nil, modules.game_interface.getRootPanel())
end

function GameSocial.onPartyExtendedOpcode(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.PartyManager then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if not data or type(data) ~= "table" then
		return
	end

	if data.action == "update_invitations" then
		GameSocial:updatePartyInvitationsPanel(data.invitations)
	elseif data.action == "remove_invitation" then
		GameSocial:removePartyInvitationFromPanel(data.partyId)
	elseif data.action == "update_party" or data.action == "close_party_control_window" then
		GameSocial:updatePartyPanel(data)
	end
end

function GameSocial:sendPartyOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if not protocolGame then
		return
	end

	protocolGame:sendExtendedOpcode(ExtendedIds.PartyManager, g_game.serializeTable(data))
end

function GameSocial:removePartyInvitationFromPanel(partyId)
	local panel = self.window.content.party_panel.content.request_panel.list

	for _, child in pairs(panel:getChildren()) do
		if child.data.partyId == partyId then
			child:destroy()

			break
		end
	end

	self.partyRequestCount = panel:getChildCount()

	panel:getParent().counter:setText(string.format("%d", self.partyRequestCount))
	panel:setup()
end

function GameSocial:updatePartyInvitationsPanel(data)
	local panel = self.window.content.party_panel.content.request_panel.list

	panel:destroyChildren()

	for _, invitation in pairs(data) do
		if not self:isIgnored(invitation.leaderName:titleCase()) then
			local widget = g_ui.createWidget("GameSocialFriendsPanelRequest", panel)

			widget.data = invitation

			widget.name:setText(invitation.leaderName:titleCase(true))

			local function destroyRequestModalDialog(invitation)
				local modalModule = modules.game_modaldialog
				local dialogs = modalModule.ModalDialog.windows

				for _, dialog in pairs(dialogs) do
					if dialog.messageLabel:getText():lower():startswith(invitation.leaderName:lower()) then
						modalModule.destroyDialog(dialog)
					end
				end
			end

			function widget.request_panel.accept_button.onClick()
				GameSocial:sendPartyOpcode({
					action = "execute_action",
					subAction = "acceptInvitation",
					partyId = invitation.partyId
				})
				destroyRequestModalDialog(invitation)
			end

			function widget.request_panel.reject_button.onClick()
				GameSocial:sendPartyOpcode({
					action = "execute_action",
					subAction = "declineInvitation",
					partyId = invitation.partyId
				})
				destroyRequestModalDialog(invitation)
			end
		end
	end

	local oldCount = self.partyRequestCount

	self.partyRequestCount = panel:getChildCount()

	panel:getParent().counter:setText(string.format("%d", self.partyRequestCount))
	panel:setup()
	signalcall(GameSocial.onUpdatePartyPanel, oldCount, self.partyRequestCount)
end

function GameSocial:stringToColorHex(value)
	local hash = 0

	for i = 1, #value do
		hash = hash + string.byte(value, i)
	end

	local r = math.floor(math.sin(hash) * 127 + 128)
	local g = math.floor(math.sin(hash + 1) * 127 + 128)
	local b = math.floor(math.sin(hash + 2) * 127 + 128)

	return string.format("#%02x%02x%02x", r, g, b)
end

function GameSocial:updatePartyPanel(data)
	local panel = self.window.content.party_panel.content.active_party_panel.list

	panel:destroyChildren()

	local parent = panel:getParent()
	local player = g_game.getLocalPlayer()
	local isLocalPlayerLeader = player:getName() == data.leaderName

	if data.members then
		local highestLevel = 0

		for _, member in ipairs(data.members) do
			local widget = g_ui.createWidget("GameSocialFriendsPanelPartyMember", panel)

			widget.data = member

			widget.name:setText(member.name)
			widget.icon:setImageColor(self:stringToColorHex(member.name))
			widget.leader:setVisible(data.leaderName == member.name)
			widget.options_panel.pass_leader_button:setVisible(isLocalPlayerLeader and member.name ~= player:getName())
			widget.options_panel.add_friend_button:setVisible(not self:isFriend(member.guid) and not member.name == player:getName())
			widget.options_panel.whisper_button:setVisible(member.name ~= player:getName())
			widget.options_panel.remove_button:setVisible(isLocalPlayerLeader or member.name == player:getName())
			widget.options_panel.remove_button:setChecked(member.name == player:getName())
			widget.options_panel.channel_swap_button:setVisible(member.channelId and member.channelId ~= G.currentChannelId)

			function widget.options_panel.onVisibilityChange(w, visible)
				widget.options_panel:setup()
				widget.class_panel:setVisible(not visible)
			end

			widget.options_panel:setup()

			local channelDesc = g_game.isWarmodeChannel(member.channelId) and "Warmode Channel" or g_game.isPlunderModeChannel() and "Plunder Channel" or "Normal Channel"

			widget.class_panel:setText(member.channelId and string.format("%s", channelDesc) or string.format("%s %s", member.class, string.format("[%d]", member.effectiveLevel)))

			highestLevel = math.max(highestLevel, member.effectiveLevel or 0)
		end

		parent.title:setText(string.format("%s [ %d / %d ]", tr("Active Party"), #data.members, data.maxAmountOfMembers))
		parent.level_range:setText(string.format("%s [ %d - %d ]", tr("EXP Range"), math.max(1, highestLevel - self.allowedLevelGap), highestLevel))
		self.window.content.party_panel.create_party_button:setVisible(#data.members == 0)
		self.window.content.party_panel.leave_party_button:setVisible(#data.members > 0)
		self.window.content.party_panel.invite_player_button:setVisible(#data.members > 0)
	else
		parent.title:setText(tr("Active Party"))
		parent.level_range:setText(nil)
		self.window.content.party_panel.create_party_button:setVisible(true)
		self.window.content.party_panel.leave_party_button:setVisible(false)
		self.window.content.party_panel.invite_player_button:setVisible(false)
	end

	panel:setup()
end

function GameSocial:isFriend(guid)
	local online_panel = self.window.content.friends_panel.content.online_panel.list
	local offline_panel = self.window.content.friends_panel.content.offline_panel.list

	return online_panel[guid] or offline_panel[guid]
end

function GameSocial:onPartyAddFriendButtonClicked(widget)
	GameSocial:sendFriendsOpcode({
		action = "add_friend",
		name = widget.data.name
	})
end

function GameSocial:onPassPartyLeadershipButtonClicked(widget)
	if self.popupBox then
		return
	end

	self.popupBox = displayGeneralBox(tr("Pass Leadership"), tr("Are you sure you want to pass leadership to |%s|?", widget.data.name), {
		{
			text = tr("Yes"),
			callback = function()
				GameSocial:sendPartyOpcode({
					action = "execute_action",
					subAction = "passLeadership",
					playerGuid = widget.data.guid
				})
				self.popupBox:destroy()

				self.popupBox = nil
			end
		},
		{
			text = tr("No"),
			callback = function()
				self.popupBox:destroy()

				self.popupBox = nil
			end
		}
	})
end

function GameSocial:onRemovePartyMemberButtonClicked(widget, isLeave)
	if self.popupBox then
		return
	end

	if isLeave then
		GameSocial:sendPartyOpcode({
			action = "leave_party"
		})
	else
		self.popupBox = displayGeneralBox(tr("Remove Member"), tr("Are you sure you want to remove |%s| from your party?", widget.data.name), {
			{
				text = tr("Yes"),
				callback = function()
					GameSocial:sendPartyOpcode({
						action = "execute_action",
						subAction = "kickPlayer",
						playerGuid = widget.data.guid
					})
					self.popupBox:destroy()

					self.popupBox = nil
				end
			},
			{
				text = tr("No"),
				callback = function()
					self.popupBox:destroy()

					self.popupBox = nil
				end
			}
		})
	end
end

function GameSocial:onCreatePartyButtonClicked()
	GameSocial:sendPartyOpcode({
		action = "create_party"
	})
end

function GameSocial:onLeavePartyButtonClicked()
	GameSocial:sendPartyOpcode({
		action = "leave_party"
	})
end

function GameSocial:onInvitePartyButtonClicked()
	if self.popupBox then
		return
	end

	self.popupBox = displayTextInputBox(tr("Invite Player"), tr("Enter the name of the player you want to invite to your party."), "", function(name)
		self.popupBox = nil

		if not name or name == "" then
			return
		end

		GameSocial:sendPartyOpcode({
			action = "invite_to_party",
			player = name
		})

		return true
	end, function()
		self.popupBox = nil
	end)

	self.popupBox:setParent(self.window)
	self.popupBox:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
	self.popupBox:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
	self.popupBox.lineEdit:recursiveFocus()
end

function GameSocial:invitePlayer(name)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	if not player:isPartyLeader() and not player:isPartyMember() then
		GameSocial:sendPartyOpcode({
			action = "create_party"
		})
	end

	GameSocial:sendPartyOpcode({
		action = "invite_to_party",
		player = name
	})
end

function GameSocial.onMailExtendedOpcode(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.Mailbox then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if not data or type(data) ~= "table" then
		return
	end

	if data.action == "messages" then
		GameSocial:updateMailPanel(data)
	elseif data.action == "open_mail" then
		GameSocial:setMailRead(data)
	elseif data.action == "new_mail" then
		GameSocial:addMail(data.message)
	end

	if data.total then
		GameSocial.mailboxTotalMails = data.total
	end

	if data.page then
		GameSocial.mailboxPage = data.page
	end

	GameSocial.canChangeMailboxPage = true

	GameSocial:updateMailboxPagination()
end

function GameSocial:sendMailOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if not protocolGame then
		return
	end

	self.canChangeMailboxPage = false

	protocolGame:sendExtendedOpcode(ExtendedIds.Mailbox, g_game.serializeTable(data))
end

function GameSocial:updateMailPanel(data)
	local panel = self.window.content.mail_panel.content.messages_panel

	panel:destroyChildren()

	if data.messages then
		local count = 0

		for _, message in ipairs(data.messages) do
			local widget = g_ui.createWidget("GameSocialFriendsPanelMailPanelItem", panel)

			widget:setId(message.id)

			widget.data = message

			widget.title:setText(message.title)
			widget.sender:setText(message.sender)
			widget.read:setOn(not message.unread)

			local function refreshMailDate(widget, message, dateText)
				local diff = os.difftime(os.time(), message.created_at)
				local days = math.floor(diff / 86400)
				local hours = math.floor((diff - days * 86400) / 3600)
				local minutes = math.floor((diff - days * 86400 - hours * 3600) / 60)

				if not dateText then
					if days > 0 then
						dateText = tr(string.format("|%d| |%s| ago", days, tr("day" .. (days > 1 and "s" or ""))))
					elseif hours > 0 then
						dateText = tr(string.format("|%d| |%s| ago", hours, tr("hour" .. (hours > 1 and "s" or ""))))
					elseif minutes > 0 then
						dateText = tr(string.format("|%d| |%s| ago", minutes, tr("minute" .. (minutes > 1 and "s" or ""))))
					else
						dateText = tr("Few seconds ago")
					end
				end

				widget.time_panel:setText(dateText)
			end

			refreshMailDate(widget, message)

			if message.unread then
				count = count + 1
			end

			widget.dateTimer = cycleEvent(function()
				refreshMailDate(widget, message)
			end, 5000)

			function widget.onDestroy()
				removeEvent(widget.dateTimer)
			end
		end

		local sortedChildren = panel:getChildren()

		table.sort(sortedChildren, function(a, b)
			if a.data.unread == b.data.unread then
				return a.data.created_at > b.data.created_at
			end

			return a.data.unread
		end)

		local oldCount = self.mailUnreadCount

		self.mailUnreadCount = count

		signalcall(GameSocial.onUpdateMailPanel, oldCount, self.mailUnreadCount)
		panel:reorderChildren(sortedChildren)
	end
end

function GameSocial:openMail(data)
	local messages_panel = self.window.content.mail_panel.content.messages_panel
	local mail_content_panel = self.window.content.mail_panel.mail_content

	messages_panel:hide()
	mail_content_panel:show()

	if data.unread then
		GameSocial:sendMailOpcode({
			action = "open_mail",
			id = data.id
		})
	end

	mail_content_panel.title:setText(data.title)
	mail_content_panel.sender:setText(data.sender)
	mail_content_panel.time:setText(os.date("%d %b %Y %H:%M", data.created_at))
	mail_content_panel.message:setText(data.message)
	self.mail_panel.pagination_panel:hide()
end

function GameSocial:closeMail()
	local messages_panel = self.window.content.mail_panel.content.messages_panel
	local mail_content_panel = self.window.content.mail_panel.mail_content

	messages_panel:show()
	mail_content_panel:hide()
	self.mail_panel.pagination_panel:show()
end

function GameSocial:setMailRead(data)
	local panel = self.window.content.mail_panel.content.messages_panel
	local widget = panel:getChildById(data.id)

	if widget then
		widget.data.unread = false

		widget.read:setOn(true)

		self.mailUnreadCount = math.max(0, self.mailUnreadCount - 1)
	end

	local sortedChildren = panel:getChildren()

	table.sort(sortedChildren, function(a, b)
		if a.data.unread == b.data.unread then
			return a.data.created_at > b.data.created_at
		end

		return a.data.unread
	end)
	panel:reorderChildren(sortedChildren)
end

function GameSocial:onRemoveMailButtonClicked(widget)
	self:sendMailOpcode({
		action = "remove_mail",
		id = widget.data.id
	})
end

function GameSocial:addMail(data)
	if self.mailboxPage > 1 then
		signalcall(GameSocial.onUpdateMailPanel, 0, 1)

		return
	end

	if data.total then
		self.mailboxTotalMails = data.total
	end

	self:updateMailboxPagination()

	local panel = self.window.content.mail_panel.content.messages_panel
	local widget = g_ui.createWidget("GameSocialFriendsPanelMailPanelItem", panel)

	widget:setId(data.id)

	widget.data = data

	widget.title:setText(data.title)
	widget.sender:setText(data.sender)
	widget.read:setOn(not data.unread)

	local function refreshMailDate(widget, data, dateText)
		local diff = os.difftime(os.time(), data.created_at)
		local days = math.floor(diff / 86400)
		local hours = math.floor((diff - days * 86400) / 3600)
		local minutes = math.floor((diff - days * 86400 - hours * 3600) / 60)

		if not dateText then
			if days > 0 then
				dateText = string.format("%d day%s ago", days, days > 1 and "s" or "")
			elseif hours > 0 then
				dateText = string.format("%d hour%s ago", hours, hours > 1 and "s" or "")
			elseif minutes > 0 then
				dateText = string.format("%d minute%s ago", minutes, minutes > 1 and "s" or "")
			else
				dateText = "Few seconds ago"
			end
		end

		widget.time_panel:setText(dateText)
	end

	refreshMailDate(widget, data, "Just now")

	local oldCount = self.mailUnreadCount

	if data.unread then
		self.mailUnreadCount = self.mailUnreadCount + 1
	end

	widget.dateTimer = cycleEvent(function()
		refreshMailDate(widget, data)
	end, 5000)

	function widget.onDestroy()
		removeEvent(widget.dateTimer)
	end

	function widget.onClick()
		GameSocial:openMail(data)
	end

	local sortedChildren = panel:getChildren()

	table.sort(sortedChildren, function(a, b)
		if a.data.unread == b.data.unread then
			return a.data.created_at > b.data.created_at
		end

		return a.data.unread
	end)
	signalcall(GameSocial.onUpdateMailPanel, oldCount, self.mailUnreadCount)
	panel:reorderChildren(sortedChildren)

	local outOfBondsChild = panel:getChildByIndex(15)

	if outOfBondsChild then
		outOfBondsChild:destroy()
	end
end

function GameSocial.onGameStart()
	local self = GameSocial

	self:updatePartyPanel({})
	self:updatePartyInvitationsPanel({})
	self:loadIgnoreds()
end

function GameSocial.onGameEnd()
	local self = GameSocial

	self:saveIgnoreds()
	self:closeMail()

	if self.confirmationWindow then
		self.confirmationWindow:destroy()

		self.confirmationWindow = nil
	end
end

function GameSocial:isIgnored(name)
	return self.ignoredPlayers[name]
end

function GameSocial:addIgnored(name)
	local panel = self.window.content.friends_panel.content.ignored_panel.list
	local widget = g_ui.createWidget("GameSocialFriendsPanelIgnored", panel)

	widget:setId("IgnoredPlayer" .. name)
	widget.name:setText(name)

	self.ignoredPlayers[name] = true
	self.playersIgnoredCount = panel:getChildCount()

	panel:getParent().counter:setText(string.format("%d", self.playersIgnoredCount))
	panel:setup()
end

function GameSocial:removeIgnored(name)
	local panel = self.window.content.friends_panel.content.ignored_panel.list

	for _, child in pairs(panel:getChildren()) do
		if child.name:getText() == name then
			self.ignoredPlayers[name] = nil

			child:destroy()

			break
		end
	end

	self.playersIgnoredCount = panel:getChildCount()

	panel:getParent().counter:setText(string.format("%d", panel:getChildCount()))
	panel:setup()
end

function GameSocial:saveIgnoreds()
	local chat = g_settings.getNode("game_social") or {}
	local char = g_game.getCharacterName()

	if not chat[char] then
		chat[char] = {}
	end

	chat[char].ignoredPlayers = self.ignoredPlayers
	self.ignoredPlayers = {}

	local ignored_panel = self.window.content.friends_panel.content.ignored_panel.list

	ignored_panel:destroyChildren()
	g_settings.setNode("game_social", chat)
	g_settings.save()
end

function GameSocial:loadIgnoreds()
	local chat = g_settings.getNode("game_social")
	local char = chat and g_game.getCharacterName()

	if char and chat[char] then
		self.ignoredPlayers = chat[char].ignoredPlayers
	end

	for name in pairs(self.ignoredPlayers) do
		self:addIgnored(name)
	end
end

function GameSocial:onChannelSwapButtonClicked(widget)
	modules.game_channel_selector.GameSwitchChannel:requestJoinFriendChannel(widget.data.guid)
end

function GameSocial:updateMailboxPagination()
	local max_pages = math.ceil(self.mailboxTotalMails / self.mailboxMailsPerPage)

	self.mailboxPage = math.min(self.mailboxPage, max_pages)

	self.mail_panel.pagination_panel.page_edit:setText(self.mailboxPage)
	self.mail_panel.pagination_panel.page_edit:setCursorPos(-1)
	self.mail_panel.pagination_panel.prev_button:setOn(self.mailboxPage > 1)
	self.mail_panel.pagination_panel.next_button:setOn(max_pages > self.mailboxPage)
	self.mail_panel.pagination_panel.prev_button:setEnabled(self.mailboxPage > 1)
	self.mail_panel.pagination_panel.next_button:setEnabled(max_pages > self.mailboxPage)
	self.mail_panel.pagination_panel.page_count:setText(tr(string.format("of |%i|", max_pages)))
end

function GameSocial:changeMailboxPage(direction)
	if not self.canChangeMailboxPage then
		return
	end

	local max_pages = math.ceil(self.mailboxTotalMails / self.mailboxMailsPerPage)

	if direction == "next" then
		self:sendMailOpcode({
			action = "request_page",
			page = self.mailboxPage + 1
		})
	elseif direction == "previous" then
		self:sendMailOpcode({
			action = "request_page",
			page = self.mailboxPage - 1
		})
	else
		direction = tonumber(direction)

		if not direction then
			return
		end

		self:sendMailOpcode({
			action = "request_page",
			page = math.clamp(direction, 1, max_pages)
		})
	end
end

function GameSocial:sendAcceptRequestsConfig(value)
	self:sendFriendsOpcode({
		action = "accept_requests_cfg",
		value = value
	})
end
