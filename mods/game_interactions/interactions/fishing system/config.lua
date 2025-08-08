-- chunkname: @/modules/game_interactions/interactions/fishing system/config.lua

__env = __env or {}
quest_name = "Fishing System"
current_task = 0
current_interaction = 0
tasks = {
	{
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_fishfight = function(self, visible)
						if visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 1)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local fishFightWindow = modules.game_fishfight.FishFight.window

				if fishFightWindow:isVisible() then
					GameInteractions:advanceInteraction(__env, __env.current_task, 1)

					return
				end

				GameInteractions:displayDescriptionBox({
					pages = {
						{
							text = "Oh, you need to be fishing to start this interaction. Try finding a fishing pool."
						}
					},
					parent = GameInteractions.bandit_avatar,
					callbackOnClose = function()
						return
					end
				})
				table.insert(self.disconnects, connect(fishFightWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_fishfight
				}))
			end
		},
		{
			disconnects = {},
			callbacks = {
				UIWidget = {
					onVisibilityChange_fishfight = function(self, visible)
						if not visible then
							GameInteractions:advanceInteraction(__env, __env.current_task, 0)
						end
					end
				}
			},
			onStartInteraction = function(self)
				local fishFightWindow = modules.game_fishfight.FishFight.window

				if not fishFightWindow:isVisible() then
					return
				end

				local _, abilityFirstSlot = AbilityBar.getFirstOccupiedSlot(AbilityBarCategoryFishing)
				local _, abilitySecondSlot = AbilityBar.getSecondOccupiedSlot(AbilityBarCategoryFishing)
				local durabilityBar = fishFightWindow:recursiveGetChildById("durabilityBar")
				local durabilityLoss = fishFightWindow:recursiveGetChildById("durabilityLoss")
				local dummyBehaviourIcon = fishFightWindow:recursiveGetChildById("dummyBehaviourIcon")

				GameInteractions:displayDescriptionBox({
					pages = {
						{
							text = "Oh, this is the moment I've been waiting for a long time!"
						},
						{
							text = "If you want to catch that fish, make sure to hold on tight until the fishing bar is complete!"
						},
						{
							text = "To fill up the fishing bar, you must use your skills to \"deal damage\" to the fish",
							callback = function(self)
								self.newParent = GameInteractions.bandit_avatar
							end
						},
						{
							text = "The first skill is called Basic Reel, which is stronger but reduces the fishing rod's durability",
							callback = function(self)
								self.newParent = abilityFirstSlot
							end
						},
						{
							text = "The other skill is Give Slack, which deals less damage but increases durability instead",
							callback = function(self)
								self.newParent = abilitySecondSlot
							end
						},
						{
							text = "Also, the longer you take to catch a fish, the more fatigued you become"
						},
						{
							text = "So always be aware of the fishing rod icon...",
							callback = function(self)
								self.newParent = abilitySecondSlot
							end
						},
						{
							text = "Because durability is represented by a red bar coming from the left",
							callback = function(self)
								self.newParent = durabilityBar
								self.preferSide = "left"
							end
						},
						{
							text = "And fatigue is represented by a white bar coming from the right side",
							callback = function(self)
								self.newParent = durabilityLoss
								self.preferSide = "right"
							end
						},
						{
							text = "If your fatigue surpasses durability, the line snaps and you lose the fish!"
						},
						{
							text = "One last thing to keep in mind - the fish will behave differently from time to time!"
						},
						{
							text = "So you've got to keep your eyes open to best determine which skills fit the situation...",
							callback = function(self)
								self.newParent = durabilityLoss
								self.preferSide = "right"
							end
						},
						{
							text = "If a blue fish is displayed right below the rod, it means you'll deal more damage to the fish!",
							callback = function(self)
								self.newParent = dummyBehaviourIcon
								self.preferSide = "left"
							end
						},
						{
							text = "But if the icon is a red fish, it means your rod's durability will run out faster"
						},
						{
							text = "Now let's stop talking and jump into action before they escape the hook!"
						}
					},
					parent = GameInteractions.bandit_avatar,
					callbackOnClose = function()
						GameInteractions:completeInteraction(__env)
					end
				})
				table.insert(self.disconnects, connect(fishFightWindow, {
					onVisibilityChange = self.callbacks.UIWidget.onVisibilityChange_fishfight
				}))
			end
		}
	}
}
callbacks = {
	onCustomInteraction = function(data)
		if current_task ~= data.stage then
			GameInteractions:closeActionBox()
			GameInteractions:closeDescriptionBox()
			GameInteractions:advanceInteraction(__env, data.stage or 1, 0)
		else
			GameInteractions:advanceInteraction(__env, data.stage or 1, data.interaction or 0)
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
