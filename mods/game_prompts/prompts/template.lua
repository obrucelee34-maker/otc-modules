-- chunkname: @/modules/game_prompts/prompts/template.lua

__env = __env or {}
quest_name = ""
current_task = 0
current_prompt = 0
tasks = {}
callbacks = {
	onCustomPrompt = function(data)
		if current_task ~= data.stage then
			GamePrompts:closeActionBox()
			GamePrompts:closeDescriptionBox()
			GamePrompts:advancePrompt(__env, data.stage or 1, 0)
		else
			GamePrompts:advancePrompt(__env, data.stage or 1, data.prompt or 0)
		end
	end,
	onTaskUpdate = function(task)
		return
	end,
	onGameStart = function()
		return
	end,
	onGameEnd = function()
		return
	end
}
