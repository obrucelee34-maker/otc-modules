-- chunkname: @/modules/game_hearthteleport/hearthteleport.lua

GameHearthTeleport = {
	cooldown = 0
}

function init()
	ProtocolGame.registerExtendedOpcode(ExtendedIds.HearthTeleport, GameHearthTeleport.onExtendedOpcode)
	connect(g_game, {
		onGameEnd = GameHearthTeleport.onGameEnd
	})
	connect(LocalPlayer, {
		onLevelChange = GameHearthTeleport.onLevelChange
	})
end

function terminate()
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.HearthTeleport)
	GameHearthTeleport:removeUpdateTooltipEvent()

	local teleportButton = modules.game_minimap.getMinimapButton("teleportButton")

	disconnect(g_game, {
		onGameEnd = GameHearthTeleport.onGameEnd
	})
	disconnect(teleportButton, {
		onHoverChange = GameHearthTeleport.onHoverChange
	})
	disconnect(LocalPlayer, {
		onLevelChange = GameHearthTeleport.onLevelChange
	})
end

function GameHearthTeleport.onGameEnd()
	GameHearthTeleport:removeUpdateTooltipEvent()
	GameHearthTeleport:setCooldown(0)
end

function GameHearthTeleport:teleport()
	local data = {
		action = "teleport"
	}

	self:sendExtendedOpcode(data)
end

function GameHearthTeleport:sendExtendedOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.HearthTeleport, g_game.serializeTable(data))
	end
end

function GameHearthTeleport.onExtendedOpcode(protocol, opcode, buffer)
	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		return
	end

	local action = data.action

	if action == "cooldown" then
		GameHearthTeleport:setCooldown(data.cooldown)
		GameHearthTeleport:updateCooldownTooltip()
	end
end

function GameHearthTeleport:removeUpdateTooltipEvent()
	if self.updateCooldownTooltipEvent then
		removeEvent(self.updateCooldownTooltipEvent)

		self.updateCooldownTooltipEvent = nil
	end
end

function GameHearthTeleport:setCooldown(cooldown)
	if cooldown > 0 then
		modules.game_minimap.toggleMinimapButton("teleportButton", true)
	else
		modules.game_minimap.toggleMinimapButton("teleportButton", false)
	end

	self.cooldown = os.time() + (cooldown or 0)
end

function GameHearthTeleport:updateCooldownTooltip()
	local cooldownButton = modules.game_minimap.getMinimapButton("teleportButton")

	if not cooldownButton then
		self:removeUpdateTooltipEvent()

		return
	end

	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	if player:getLevel() < 10 then
		cooldownButton:setTooltip(tr("This option will be unlocked at legacy level %d.", 10))

		return
	end

	local timeLeft = self.cooldown - os.time()

	if timeLeft > 0 then
		cooldownButton:setColoredTooltip(GetHighlightedText(tr(string.format("Teleport Cooldown: |{%s, #FFA851}|", SecondsToClock(timeLeft)))))
	else
		cooldownButton:setTooltip(tr("Teleport to Ravencrest"))
		self:removeUpdateTooltipEvent()
	end
end

function GameHearthTeleport.onHoverChange(widget, hovered)
	local self = GameHearthTeleport

	self:removeUpdateTooltipEvent()
	self:updateCooldownTooltip()

	if not hovered then
		return
	end

	self.updateCooldownTooltipEvent = cycleEvent(function()
		self:updateCooldownTooltip()
	end, 1000, true)
end

function GameHearthTeleport.onLevelChange(player, level, percent)
	local self = GameHearthTeleport
	local teleportButton = modules.game_minimap.getMinimapButton("teleportButton")

	if not teleportButton then
		return
	end

	local enabled = level >= 10

	self:updateCooldownTooltip()
	teleportButton:setEnabled(enabled)
end
