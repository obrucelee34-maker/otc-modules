-- chunkname: @/modules/game_daily/daily.lua

GameDaily = {}

function GameDaily:init()
	ProtocolGame.registerExtendedOpcode(ExtendedIds.Daily, GameDaily.onExtendedOpcode)
end

function GameDaily:terminate()
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.Daily)

	GameDaily = nil
end

function GameDaily.onExtendedOpcode(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.Daily or buffer == "" then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		return
	end

	if data.action == "daily_reset" then
		signalcall(GameDaily.onDailyReset)
	end
end
