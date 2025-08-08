-- chunkname: @/modules/game_ambient_assets/ambient_assets.lua

GameAmbientAssets = {
	data = {}
}

function GameAmbientAssets:loadConfig()
	local func, error = loadfile("config.lua")

	if not func then
		g_logger.fatal(error)

		return false
	end

	func()

	local env = getfenv(0)

	env.cfg = {}

	setmetatable(env.cfg, {
		__index = env
	})
	setfenv(func, env.cfg)

	return true
end

function GameAmbientAssets:init()
	self:loadConfig()
	connect(Tile, {
		onAddAmbienceItem = self.onAddAmbienceItem,
		onRemoveAmbienceItem = self.onRemoveAmbienceItem
	})
	connect(LocalPlayer, {
		onPositionChange = self.onPositionChange
	})
	connect(g_game, {
		onGameStart = GameAmbientAssets.online
	})
end

function GameAmbientAssets:terminate()
	disconnect(Tile, {
		onAddAmbienceItem = self.onAddAmbienceItem,
		onRemoveAmbienceItem = self.onRemoveAmbienceItem
	})
	disconnect(LocalPlayer, {
		onPositionChange = self.onPositionChange
	})
	disconnect(g_game, {
		onGameStart = GameAmbientAssets.online
	})
end

function GameAmbientAssets.online()
	GameAmbientAssets.data = {}
end

function GameAmbientAssets.sendOpcode(data)
	local protocol = g_game.getProtocolGame()

	if protocol then
		protocol:sendExtendedOpcode(ExtendedIds.AmbientAssets, g_game.serializeTable(data))
	end
end

function GameAmbientAssets.onAddAmbienceItem(tile, thing)
	local itemId = thing:getId()

	if not cfg.disappearItems[itemId] then
		return
	end

	local position = tile:getPosition()
	local hash = Position.generateHash(position)

	if not GameAmbientAssets.data[hash] then
		GameAmbientAssets.data[hash] = {
			itemId = itemId,
			position = position
		}
	end
end

function GameAmbientAssets.onRemoveAmbienceItem(tile, thing)
	local itemId = thing:getId()

	if not cfg.disappearItems[itemId] then
		return
	end

	local position = tile:getPosition()
	local hash = Position.generateHash(position)

	if GameAmbientAssets.data[hash] then
		GameAmbientAssets.data[hash] = nil
	end
end

function GameAmbientAssets.onPositionChange(player, newPos, oldPos)
	for hash, info in pairs(GameAmbientAssets.data) do
		local distance = Position.getDistanceBetween(newPos, info.position)

		if distance <= cfg.disappearDistance then
			GameAmbientAssets.sendOpcode({
				action = "disappear",
				position = {
					x = info.position.x,
					y = info.position.y,
					z = info.position.z
				}
			})

			GameAmbientAssets.data[hash] = nil
		end
	end
end
