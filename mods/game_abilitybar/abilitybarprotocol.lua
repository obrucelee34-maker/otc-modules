-- chunkname: @/modules/game_abilitybar/abilitybarprotocol.lua

AbilityBarProtocol = {}

local function parseHighlightSpell(protocol, msg)
	local spellId = msg:getU16()
	local mapIcons = msg:getU8() == 1
	local highlight = msg:getU8() == 1

	AbilityBar.onSpellHighlight(spellId, mapIcons, highlight)

	return true
end

local function parseSpellIgnoreGlobalCooldown(protocol, msg)
	local spellId = msg:getU16()
	local value = msg:getU8()

	AbilityBar.onSpellIgnoreGlobalCooldown(spellId, value)

	return true
end

function initProtocol()
	connect(g_game, {
		onGameStart = AbilityBarProtocol.registerProtocols,
		onGameEnd = AbilityBarProtocol.unregisterProtocols
	})

	if g_game.isOnline() then
		AbilityBarProtocol.registerProtocols()
	end
end

function terminateProtocol()
	disconnect(g_game, {
		onGameStart = AbilityBarProtocol.registerProtocols,
		onGameEnd = AbilityBarProtocol.unregisterProtocols
	})
	AbilityBarProtocol.unregisterProtocols()

	AbilityBarProtocol = nil
end

function AbilityBarProtocol.registerProtocols()
	ProtocolGame.registerOpcode(SERVER_OPCODE_SPELLHIGHLIGHT, parseHighlightSpell)
	ProtocolGame.registerOpcode(SERVER_OPCODE_SPELLIGNOREGLOBALCOOLDOWN, parseSpellIgnoreGlobalCooldown)
end

function AbilityBarProtocol.unregisterProtocols()
	ProtocolGame.unregisterOpcode(SERVER_OPCODE_SPELLHIGHLIGHT)
	ProtocolGame.unregisterOpcode(SERVER_OPCODE_SPELLIGNOREGLOBALCOOLDOWN)
end
