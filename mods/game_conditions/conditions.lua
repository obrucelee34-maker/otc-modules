-- chunkname: @/modules/game_conditions/conditions.lua

GameConditions = {}

local function formatTime(seconds)
	if seconds < 60 then
		return tostring(math.ceil(seconds) .. "s")
	elseif seconds < 3600 then
		return tostring(math.ceil(seconds / 60) .. "m")
	elseif seconds < 86400 then
		return tostring(math.ceil(seconds / 3600) .. "h")
	else
		return tostring(math.ceil(seconds / 86400) .. "d")
	end

	return tostring(math.ceil(seconds) .. "s")
end

function GameConditions:loadConfig()
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

function GameConditions:init()
	if not self:loadConfig() then
		return
	end

	g_ui.importStyle("styles/main.otui")

	local HUDPanel = modules.game_interface.getHUDPanel()

	self.buffWindow = g_ui.createWidget("GameConditionsWindow", HUDPanel)

	self.buffWindow:setId("buffWindow")

	self.debuffWindow = g_ui.createWidget("GameConditionsWindow", HUDPanel)

	self.debuffWindow:setId("debuffWindow")

	self.buffWindow.onDragEnter = onBuffWindowDragEnter
	self.buffWindow.onDragMove = onBuffWindowDragMove
	self.debuffWindow.onDragEnter = onDebuffWindowDragEnter
	self.debuffWindow.onDragMove = onDebuffWindowDragMove

	connect(LocalPlayer, {
		onAddCondition = self.onAddCondition,
		onRemoveCondition = self.onRemoveCondition
	})
	connect(g_game, {
		onGameStart = self.onGameStart,
		onGameEnd = self.onGameEnd
	})
end

function GameConditions:terminate()
	disconnect(LocalPlayer, {
		onAddCondition = self.onAddCondition,
		onRemoveCondition = self.onRemoveCondition
	})
	disconnect(g_game, {
		onGameStart = self.onGameStart,
		onGameEnd = self.onGameEnd
	})
	self.buffWindow:destroy()
	self.debuffWindow:destroy()
end

function GameConditions.onAddCondition(localPlayer, condition)
	local self = GameConditions
	local debuff = condition.negative
	local widgetId = string.format("%d_%d", condition.type, condition.subId)
	local existing = debuff and self.debuffWindow.content:getChildById(widgetId) or self.buffWindow.content:getChildById(widgetId)
	local window = debuff and self.debuffWindow or self.buffWindow

	if not existing then
		local conditionWidget = self:createConditionWidget(condition)

		window.content:addChild(conditionWidget)
	else
		self:createConditionWidget(condition, existing)
	end
end

function GameConditions.onRemoveCondition(localPlayer, condition)
	local self = GameConditions
	local debuff = condition.negative
	local window = debuff and self.debuffWindow or self.buffWindow
	local conditionWidget = window.content:getChildById(string.format("%d_%d", condition.type, condition.subId))

	if conditionWidget then
		conditionWidget:destroy()
	end
end

function GameConditions:createConditionWidget(condition, existingWidget)
	local widget = existingWidget or g_ui.createWidget("GameConditionsWindowCondition")

	widget:setId(string.format("%d_%d", condition.type, condition.subId))

	if condition.spellName == "" then
		local conditionData = cfg.conditions[condition.subId]

		if conditionData then
			local icon = string.format("/images/ui/icons/abilitybar/%s.png", conditionData.name:lower())

			if g_resources.fileExists(icon) then
				widget.icon:setImageSource(icon)
			else
				widget.icon:setImageSource()
			end
		end
	else
		local icon = string.format("/images/ui/icons/abilitybar/%s.png", condition.spellName:lower())

		if g_resources.fileExists(icon) then
			widget.icon:setImageSource(icon)
		else
			local name = string.explode(tr(condition.spellName), "\n\n")[1]
			local path = string.format("/images/ui/icons/abilitybar/%s.png", name and name:lower() or "")

			if g_resources.fileExists(path) then
				widget.icon:setImageSource(path)
			else
				widget.icon:setImageSource()
			end
		end
	end

	widget.progress:setCircle(true)

	if condition.ticks > 0 then
		widget.progress:onSpellCooldown(condition.ticks, nil, function()
			widget:destroy()
		end, nil, function(cd)
			widget.duration:setText(formatTime(cd / 1000))
		end)
		widget.duration:setOn(condition.negative)
	else
		widget.progress:setPercent(100)
	end

	local description, icon = self:getConditionDescriptionAndIcon(condition)

	widget:setTooltip(description)

	if widget.icon:getImageSource() == "" and icon then
		icon = string.format("/images/ui/windows/conditions/%s_%s.png", icon:lower(), condition.negative and "negative" or "positive")

		if g_resources.fileExists(icon) then
			widget.icon:setImageSource(icon)
		else
			widget.icon:setImageSource("/images/ui/icons/abilitybar/unknown.png")
		end
	elseif widget.icon:getImageSource() == "" then
		local conditionData = cfg.conditions[condition.subId]

		if conditionData then
			local icon = string.format("/images/ui/windows/conditions/%s_%s.png", conditionData.name:lower(), condition.negative and "negative" or "positive")

			if g_resources.fileExists(icon) then
				widget.icon:setImageSource(icon)
			else
				widget.icon:setImageSource("/images/ui/icons/abilitybar/unknown.png")
			end
		end
	end

	return widget
end

function GameConditions.onGameStart()
	local self = GameConditions
end

function GameConditions.onGameEnd()
	local self = GameConditions

	self.buffWindow.content:destroyChildren()
	self.debuffWindow.content:destroyChildren()
end

function GameConditions:getConditionDescriptionAndIcon(condition)
	local icon
	local description = condition.spellName ~= "" and string.format("%s\n", tr(condition.spellName)) or nil
	local conditionData = cfg.conditions[condition.subId]

	if (not description or conditionData and conditionData.append) and conditionData then
		local appendText = pcalltr(description)

		description = conditionData.name and not string.empty(conditionData.name) and string.format("%s\n", tr(conditionData.name)) or ""

		if conditionData.description and not string.empty(conditionData.description) then
			description = description .. string.format("%s\n", pcalltr(conditionData.description))
		end

		if appendText then
			description = description .. appendText
		end
	end

	local conditionType = condition.type
	local additionalDescription = ""

	if conditionType == CONDITION_SPELL or conditionType == CONDITION_PHYSICAL or conditionType == CONDITION_MANADRAIN then
		additionalDescription = string.format("Deals %d damage every %d seconds.\n", math.abs(condition.damage), condition.ticks / 1000)
		icon = "over_time"
	elseif conditionType == CONDITION_REGENERATION then
		if condition.healthGain > 0 and condition.manaGain == 0 then
			additionalDescription = additionalDescription .. string.format("Regenerates %d health every %d second%s.\n", condition.healthGain, condition.healthTicks / 1000, condition.healthTicks > 1000 and "s" or "")
		elseif condition.manaGain > 0 and condition.healthGain == 0 then
			additionalDescription = additionalDescription .. string.format("Regenerates %d mana every %d second%s.\n", condition.manaGain, condition.manaTicks / 1000, condition.manaTicks > 1000 and "s" or "")
		elseif condition.healthGain > 0 and condition.manaGain > 0 then
			additionalDescription = additionalDescription .. string.format("Regenerates %d health every %d second%s and %d mana every %d second%s.\n", condition.healthGain, condition.healthTicks / 1000, condition.healthTicks > 1000 and "s" or "", condition.manaGain, condition.manaTicks / 1000, condition.manaTicks > 1000 and "s" or "")
		elseif condition.statsRegen > 0 or condition.statsHealthRegen > 0 or condition.statsManaRegen > 0 then
			local healthRegen = condition.statsRegen + condition.statsHealthRegen
			local manaRegen = condition.statsRegen + condition.statsManaRegen

			if healthRegen > 0 and manaRegen > 0 then
				additionalDescription = additionalDescription .. string.format("Regenerates %d health and %d mana every 3 seconds.\n", healthRegen, manaRegen)
			elseif healthRegen > 0 then
				additionalDescription = additionalDescription .. string.format("Regenerates %d health every 3 seconds.\n", healthRegen)
			elseif manaRegen > 0 then
				additionalDescription = additionalDescription .. string.format("Regenerates %d mana every 3 seconds.\n", manaRegen)
			end
		elseif condition.healthGainPercent > 0 and condition.manaGainPercent == 0 then
			additionalDescription = additionalDescription .. string.format("Regenerates %d%% health every %d second%s.\n", condition.healthGainPercent, condition.healthTicks / 1000, condition.healthTicks > 1000 and "s" or "")
		elseif condition.manaGainPercent > 0 and condition.healthGainPercent == 0 then
			additionalDescription = additionalDescription .. string.format("Regenerates %d%% mana every %d second%s.\n", condition.manaGainPercent, condition.manaTicks / 1000, condition.manaTicks > 1000 and "s" or "")
		elseif condition.healthGainPercent > 0 and condition.manaGainPercent > 0 then
			additionalDescription = additionalDescription .. string.format("Regenerates %d%% health every %d second%s and %d%% mana every %d second%s.\n", condition.healthGainPercent, condition.healthTicks / 1000, condition.healthTicks > 1000 and "s" or "", condition.manaGainPercent, condition.manaTicks / 1000, condition.manaTicks > 1000 and "s" or "")
		end

		icon = "over_time"
	elseif conditionType == CONDITION_ATTRIBUTES then
		local counter = 0

		for stat, value in ipairs(condition.stats) do
			if value ~= 0 then
				local isReversed = stat - 1 == STAT_ATTACKSPEED
				local isPositiveValue = value > 0
				local increase = isReversed and (isPositiveValue and "decreased" or "increased") or isPositiveValue and "increased" or "decreased"

				additionalDescription = additionalDescription .. string.format("%s %s by %d%s.\n", cfg.StatNames[stat - 1], increase, math.abs(value), cfg.PercentStats[stat - 1] and "%" or "")
				icon = tostring(stat - 1)
				counter = counter + 1
			end
		end

		if counter > 1 or not icon then
			icon = "generic_stats"
		end
	elseif conditionType == CONDITION_HASTE or conditionType == CONDITION_PARALYZE then
		additionalDescription = string.format("Movement speed %s by %d.", conditionType == CONDITION_HASTE and "increased" or "decreased", math.abs(condition.speedDelta))
		icon = "speed"
	elseif conditionType == CONDITION_STUN then
		additionalDescription = "Unable to perform any action."
		icon = "stun"
	elseif conditionType == CONDITION_SNARE then
		additionalDescription = "Unable to move."
		icon = "snare"
	elseif conditionType == CONDITION_DRUNK then
		additionalDescription = "Movement is unsteady."
		icon = "confusion"
	elseif conditionType == CONDITION_PACIFIED then
		additionalDescription = "Unable to attack or cast spells."
		icon = "stun"
	elseif conditionType == CONDITION_INPVP then
		additionalDescription = "Marked for PvP."
	elseif conditionType == CONDITION_INFIGHT then
		additionalDescription = "In combat."
	end

	if not description then
		description = additionalDescription
	else
		description = description .. "\n" .. additionalDescription
	end

	while description:ends("\n") do
		description = description:sub(1, -2)
	end

	if conditionData and conditionData.icon then
		icon = conditionData.icon
	end

	return description, icon
end

function update()
	local isEditMode = g_layout.isEditMode()
	local buffWindow = GameConditions.buffWindow
	local debuffWindow = GameConditions.debuffWindow

	buffWindow:setPhantom(not isEditMode)
	debuffWindow:setPhantom(not isEditMode)
	buffWindow:recursiveGetChildById("editModeBackground"):setVisible(isEditMode)
	debuffWindow:recursiveGetChildById("editModeBackground"):setVisible(isEditMode)
	buffWindow:setHeight(math.max(45, GameConditions.buffWindow:getHeight()))
	debuffWindow:setHeight(math.max(45, GameConditions.debuffWindow:getHeight()))
end

function onBuffWindowDragEnter(self, mousePos)
	if not g_layout.isEditMode() then
		return
	end

	local oldPos = self:getPosition()

	self.movingReference = {
		x = mousePos.x - oldPos.x,
		y = mousePos.y - oldPos.y
	}

	self:setPosition(oldPos)
	self:breakAnchors()

	return true
end

function onDebuffWindowDragEnter(self, mousePos)
	if not g_layout.isEditMode() then
		return
	end

	local oldPos = self:getPosition()

	self.movingReference = {
		x = mousePos.x - oldPos.x,
		y = mousePos.y - oldPos.y
	}

	self:setPosition(oldPos)
	self:breakAnchors()

	return true
end

function onBuffWindowDragMove(self, mousePos, mouseMoved)
	local pos = {
		x = mousePos.x - self.movingReference.x,
		y = mousePos.y - self.movingReference.y
	}

	g_layout.snapToGrid(pos)
	self:setPosition(pos)
	self:bindRectToParent()
end

function onDebuffWindowDragMove(self, mousePos, mouseMoved)
	local pos = {
		x = mousePos.x - self.movingReference.x,
		y = mousePos.y - self.movingReference.y
	}

	g_layout.snapToGrid(pos)
	self:setPosition(pos)
	self:bindRectToParent()
end
