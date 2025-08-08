-- chunkname: @/modules/game_waypoints/config.lua

distanceMultiplier = 0.025

local levelMultiplier = {
	{
		level = 10,
		multiplier = 0.5
	},
	{
		level = 20,
		multiplier = 1
	},
	{
		level = 30,
		multiplier = 1.5
	},
	{
		level = 40,
		multiplier = 2.7
	},
	{
		level = 50,
		multiplier = 4.5
	},
	{
		level = 60,
		multiplier = 9.6
	},
	{
		level = 70,
		multiplier = 16
	},
	{
		multiplier = 37,
		level = math.huge
	}
}

function getLevelMultiplier(level)
	local result = 0
	local remainingLevels = level
	local previousLevel = 0

	for _, range in ipairs(levelMultiplier) do
		local levelsInThisRange = math.min(level, range.level) - previousLevel

		result = result + levelsInThisRange * range.multiplier
		remainingLevels = remainingLevels - levelsInThisRange

		if remainingLevels <= 0 then
			break
		end

		previousLevel = range.level
	end

	return result
end

function WaypointsPriceFormula(playerLevel, distance, premium)
	return math.floor(distance * distanceMultiplier * getLevelMultiplier(playerLevel))
end
