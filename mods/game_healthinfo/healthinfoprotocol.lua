-- chunkname: @/modules/game_healthinfo/healthinfoprotocol.lua

HealthinfoProtocol = {}

local protocol

local function parseMountStamina(protocol, msg)
	local stamina = msg:getU32()
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	player:setCurrentMountStamina(stamina)
	signalcall(LocalPlayer.onMountStaminaChange, player, stamina, player:getMaxCurrentMountStamina())

	return true
end

function initProtocol()
	connect(g_game, {
		onGameStart = HealthinfoProtocol.registerProtocol,
		onGameEnd = HealthinfoProtocol.unregisterProtocol
	})

	if g_game.isOnline() then
		HealthinfoProtocol.registerProtocol()
	end
end

function terminateProtocol()
	disconnect(g_game, {
		onGameStart = HealthinfoProtocol.registerProtocol,
		onGameEnd = HealthinfoProtocol.unregisterProtocol
	})
	HealthinfoProtocol.unregisterProtocol()

	HealthinfoProtocol = nil
end

function HealthinfoProtocol.updateProtocol(_protocol)
	protocol = _protocol
end

function HealthinfoProtocol.registerProtocol()
	ProtocolGame.registerOpcode(SERVER_OPCODE_MOUNTSTAMINA, parseMountStamina)
	HealthinfoProtocol.updateProtocol(g_game.getProtocolGame())
end

function HealthinfoProtocol.unregisterProtocol()
	ProtocolGame.unregisterOpcode(SERVER_OPCODE_MOUNTSTAMINA)
	HealthinfoProtocol.updateProtocol(nil)
end
