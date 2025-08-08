-- chunkname: @/modules/game_redeem_rewards/redeem_rewards.lua

GameRedeemRewards = {}

function GameRedeemRewards:init()
	g_ui.importStyle("styles/main.otui")

	local HUDPanel = modules.game_interface.getHUDPanel()

	self.window = g_ui.createWidget("GameRedeemRewardsWindow", HUDPanel)
	self.window.hotkeyId = HOTKEYS_IDS.REDEEM_REWARDS

	ProtocolGame.registerExtendedOpcode(ExtendedIds.RedeemRewards, self.onExtendedOpcode)
	self.window:hide()
	connect(g_game, {
		onEnterGame = self.onEnterGame,
		onGameEnd = self.onGameEnd
	})
end

function GameRedeemRewards:terminate()
	self.window:destroy()

	self.window = nil

	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.RedeemRewards)

	GameRedeemRewards = nil

	disconnect(g_game, {
		onEnterGame = self.onEnterGame,
		onGameEnd = self.onGameEnd
	})
end

function GameRedeemRewards.onEnterGame()
	GameRedeemRewards:sendOpcode({
		action = "has_rewards"
	})
end

function GameRedeemRewards.onGameEnd()
	GameRedeemRewards.window:hide()
end

function GameRedeemRewards.toggle()
	local self = GameRedeemRewards

	if self.window:isHidden() then
		self:open()
	else
		self.window:hide()
	end
end

function GameRedeemRewards:open()
	self:sendOpcode({
		action = "rewards"
	})
end

function GameRedeemRewards.onExtendedOpcode(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.RedeemRewards then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if not data or type(data) ~= "table" then
		return
	end

	if data.action == "rewards" then
		GameRedeemRewards:loadRewards(data.rewards)
	elseif data.action == "has_rewards" then
		signalcall(GameRedeemRewards.onUpdateRedeemRewards, data.value)
	end
end

function GameRedeemRewards:sendOpcode(data)
	local protocol = g_game.getProtocolGame()

	if protocol then
		protocol:sendExtendedOpcode(ExtendedIds.RedeemRewards, g_game.serializeTable(data))
	end
end

function GameRedeemRewards:loadRewards(rewards)
	self.window:show()
	self.window:raise()

	local hasRewards = not not rewards and #rewards ~= 0

	self.window.disclaimer_panel:setVisible(hasRewards)
	self.window.content:setVisible(hasRewards)
	self.window.no_items_panel:setVisible(not hasRewards)

	if not hasRewards then
		return
	end

	local listPanel = self.window.content

	listPanel:destroyChildren()

	for _, reward in ipairs(rewards) do
		local item = g_ui.createWidget("GameRedeemRewardsWindowListItem", listPanel)

		if reward.clientId then
			item.item:setItemId(reward.clientId)
		elseif reward.name:find("Ravenpack", 1, true) then
			item.item:setItemId(0)
			item.item:setImageSource("/images/ui/windows/loot_notification/icon_ravenpack")

			local textureSize = item.item:getImageTextureSize()

			item.item:setImageSize(textureSize)

			local size = item.item:getSize()
			local offset = {
				x = (size.width - textureSize.width) / 2,
				y = (size.height - textureSize.height) / 2
			}

			item.item:setImageOffset(offset)
		end

		item.name:setText(reward.name)

		function item.redeem_button.onClick()
			self:sendOpcode({
				action = "redeem",
				rewardId = reward.id
			})
		end
	end
end
