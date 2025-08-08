-- chunkname: @/modules/game_healthinfo/healthinfo.lua

local protocol = runinsandbox("healthinfoprotocol")

resourceBarAssetPrefix = "/images/ui/windows/health_bars/"
archetypes = {
	colors = {
		{
			"#8300cf",
			"#160322"
		}
	},
	names = {
		[ArchetypeWarfare] = "Warfare",
		[ArchetypeArchery] = "Archery",
		[ArchetypeShadow] = "Shadow",
		[ArchetypeProtection] = "Protection",
		[ArchetypeWizardry] = "Wizardry",
		[ArchetypeHoly] = "Holy",
		[ArchetypeSpiritual] = "Spiritual",
		[ArchetypeWitchcraft] = "Witchcraft"
	},
	active = {},
	slots = {
		{
			active = false,
			id = 0
		}
	}
}

local updateEvents = {
	partyChangePosition = {
		delay = 500,
		count = 0,
		data = {}
	},
	partyChangeOutfit = {
		delay = 500,
		count = 0,
		data = {}
	}
}

function onDragEnter(self, mousePos)
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

function onDragLeave(self, droppedWidget, mousePos)
	return true
end

function onDragMove(self, mousePos, mouseMoved)
	local pos = {
		x = mousePos.x - self.movingReference.x,
		y = mousePos.y - self.movingReference.y
	}

	g_layout.snapToGrid(pos)
	self:setPosition(pos)
	self:bindRectToParent()
end

function onGeometryChange()
	local localPlayer = g_game.getLocalPlayer()

	if localPlayer then
		onLevelChange(localPlayer, localPlayer:getLevel(), localPlayer:getLevelPercent())
	end
end

function onGameEnd()
	if not partyHud or not partyPanel then
		return
	end

	for _, v in pairs(partyPanel:getChildren()) do
		v:destroy()
	end

	updateRestedExperienceBar(0, 0)
end

function onGameStart()
	updateRestedExperienceBar(0, 0)
end

healthBar = nil
manaBar = nil
experienceBar = nil
partyHud = nil
partyPanel = nil
mountHud = nil
resourceBars = {}

function init()
	connect(LocalPlayer, {
		onHealthChange = onHealthChange,
		onHealthPercentChange = onHealthPercentChange,
		onManaChange = onManaChange,
		onManaPercentChange = onManaPercentChange,
		onLevelChange = onLevelChange,
		onExperienceChange = onExperienceChange,
		onExperienceDebtChange = onExperienceDebtChange,
		onArchetypeActiveChange = onArchetypeActiveChange,
		onResourceChange = onArchetypeResourceChange,
		onOutfitChange = onOutfitChange,
		onMountStaminaChange = onMountStaminaChange
	})
	connect(g_game, {
		onGameEnd = onGameEnd,
		onGameStart = onGameStart,
		onHealingCreatureChange = onHealingCreatureChange,
		onPartyAddMember = onPartyAddMember,
		onPartyRemoveMember = onPartyRemoveMember,
		onPartyChangeHealth = onPartyChangeHealth,
		onPartyChangeMana = onPartyChangeMana,
		onPartyChangePosition = onPartyChangePosition,
		onPartyChangeState = onPartyChangeState,
		onPartyChangeOutfit = onPartyChangeOutfit
	})
	connect(Creature, {
		onShieldChange = onPartyShieldChange
	})
	g_ui.loadUI("healthbar")
	g_ui.loadUI("manabar")
	g_ui.loadUI("experiencebar")
	g_ui.loadUI("staminabar")

	healthBar = g_ui.createWidget("HealthBar", modules.game_interface.getHUDPanel())
	healthBar.onDragEnter = onDragEnter
	healthBar.onDragLeave = onDragLeave
	healthBar.onDragMove = onDragMove
	manaBar = g_ui.createWidget("ManaBar", modules.game_interface.getHUDPanel())
	manaBar.onDragEnter = onDragEnter
	manaBar.onDragLeave = onDragLeave
	manaBar.onDragMove = onDragMove
	experienceBar = g_ui.createWidget("ExperienceBar", modules.game_interface.getHUDPanel())
	experienceBar.onDragEnter = onDragEnter
	experienceBar.onDragLeave = onDragLeave
	experienceBar.onDragMove = onDragMove
	experienceBar.onGeometryChange = onGeometryChange
	partyHud = g_ui.loadUI("partyhud", modules.game_interface.getHUDPanel())
	partyHud.onDragEnter = onDragEnter
	partyHud.onDragLeave = onDragLeave
	partyHud.onDragMove = onDragMove
	partyPanel = partyHud:getChildById("partyPanel")
	mountHud = g_ui.createWidget("MountPanel", modules.game_interface.getHUDPanel())
	mountHud.onDragEnter = onDragEnter
	mountHud.onDragLeave = onDragLeave
	mountHud.onDragMove = onDragMove

	local bar = g_ui.loadUI("resourcebar", modules.game_interface.getHUDPanel())

	resourceBars[1] = bar
	bar.onDragEnter = onDragEnter
	bar.onDragLeave = onDragLeave
	bar.onDragMove = onDragMove
	archetypes.slots[1].widget = bar
	archetypes.slots[1].widget.setPercentage = function(self, value, maxValue)
		local bar = self:recursiveGetChildById("bar")
		local text = self:recursiveGetChildById("text")

		text:setText(value)

		self.oldValue = self.value or math.floor(value / 10)
		self.value = math.floor(value / 10)

		bar:show()

		if self.value == 10 then
			if self.animate_event then
				removeEvent(self.animate_event)

				self.animate_event = nil
			end

			bar:setImageSource(string.format("%s/aether_%d", resourceBarAssetPrefix, self.value))
		elseif self.value == 0 then
			if self.animate_event then
				removeEvent(self.animate_event)

				self.animate_event = nil
			end

			bar:hide()
		else
			self.animation_frame = self.animation_frame or 0

			function self.animation_func()
				bar:setImageSource(string.format("%s/aether_animation/%d/%s.png", resourceBarAssetPrefix, self.value, string.format("%02d", self.animation_frame)), true)

				self.animation_frame = self.animation_frame + 1

				if self.animation_frame > 31 then
					self.animation_frame = 0
				end

				self.animate_event = scheduleEvent(self.animation_func, 100)
			end

			if self.animate_event and self.oldValue == self.value then
				return
			end

			if self.animate_event then
				removeEvent(self.animate_event)

				self.animate_event = nil
			end

			self.animation_func()
		end
	end

	healthBar:show()
	manaBar:show()
	experienceBar:show()
	partyHud:show()
	resourceBars[1]:show()
	mountHud:show()

	if g_game.isOnline() then
		local localPlayer = g_game.getLocalPlayer()

		onHealthChange(localPlayer, localPlayer:getHealth(), localPlayer:getMaxHealth())
		onManaChange(localPlayer, localPlayer:getMana(), localPlayer:getMaxMana())
		onExperienceChange(localPlayer, localPlayer:getExperience(), 0, localPlayer:getNextLevelExp())
		onLevelChange(localPlayer, localPlayer:getLevel(), localPlayer:getLevelPercent())
		onExperienceDebtChange(localPlayer, localPlayer:getExperienceDebt())
		onOutfitChange(localPlayer, localPlayer:getOutfit())
		onMountStaminaChange(localPlayer, localPlayer:getCurrentMountStamina(), localPlayer:getMaxCurrentMountStamina())

		for _, archetypeId in ipairs(getLocalPlayerActiveArchetypes()) do
			local isActive = localPlayer:isArchetypeActive(archetypeId)

			onArchetypeActiveChange(localPlayer, archetypeId, isActive, isActive)
		end
	end

	protocol.initProtocol()
	ProtocolGame.registerExtendedOpcode(ExtendedIds.RestedExperience, onRestedExperienceExtendedOpcode)
end

function terminate()
	disconnect(LocalPlayer, {
		onHealthChange = onHealthChange,
		onHealthPercentChange = onHealthPercentChange,
		onManaChange = onManaChange,
		onManaPercentChange = onManaPercentChange,
		onLevelChange = onLevelChange,
		onExperienceChange = onExperienceChange,
		onArchetypeActiveChange = onArchetypeActiveChange,
		onResourceChange = onArchetypeResourceChange,
		onExperienceDebtChange = onExperienceDebtChange,
		onOutfitChange = onOutfitChange,
		onMountStaminaChange = onMountStaminaChange
	})
	disconnect(g_game, {
		onGameEnd = onGameEnd,
		onGameStart = onGameStart,
		onHealingCreatureChange = onHealingCreatureChange,
		onPartyAddMember = onPartyAddMember,
		onPartyRemoveMember = onPartyRemoveMember,
		onPartyChangeHealth = onPartyChangeHealth,
		onPartyChangeMana = onPartyChangeMana,
		onPartyChangePosition = onPartyChangePosition,
		onPartyChangeState = onPartyChangeState,
		onPartyChangeOutfit = onPartyChangeOutfit
	})
	disconnect(Creature, {
		onShieldChange = onPartyShieldChange
	})
	healthBar:destroy()
	manaBar:destroy()
	experienceBar:destroy()
	partyHud:destroy()
	mountHud:destroy()
	resourceBars[1]:destroy()

	archetypes.slots[1].widget = nil
	resourceBars = {}
	healthBar = nil
	manaBar = nil
	experienceBar = nil
	partyHud = nil
	mountHud = nil

	if updateEvents.partyChangePosition.event then
		removeEvent(updateEvents.partyChangePosition.event)
	end

	if updateEvents.partyChangeOutfit.event then
		removeEvent(updateEvents.partyChangeOutfit.event)
	end

	protocol.terminateProtocol()
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.RestedExperience)
end

local function commaformat(number)
	return string.format("%s", tostring(number)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

function onHealthChange(localPlayer, health, maxHealth)
	healthBar:setPercentage(health, maxHealth)
end

function onHealthPercentChange(localPlayer, healthPercent)
	healthBar:setPercentage(healthPercent)

	local maxHealth = localPlayer:getMaxHealth()

	if not maxHealth or maxHealth == 0 then
		healthBar:setPercentage(healthPercent)

		return
	end

	local health = math.floor(healthPercent / 100 * maxHealth)

	healthBar:setPercentage(health, maxHealth)
end

function onManaChange(localPlayer, mana, maxMana)
	manaBar:setPercentage(mana, maxMana)
end

function onManaPercentChange(localPlayer, manaPercent)
	local maxMana = localPlayer:getMaxMana()

	if not maxMana or maxMana == 0 then
		manaBar:setPercentage(manaPercent)

		return
	end

	local mana = math.floor(manaPercent / 100 * maxMana)

	manaBar:setPercentage(mana, maxMana)
end

function onArchetypeResourceChange(localPlayer, resource, maxResource)
	local slot = getResourceSlot()

	if slot then
		slot.widget:setPercentage(resource, maxResource)
	end
end

function onArchetypeActiveChange(localPlayer, id, isActive, oldIsActive)
	if isActive then
		activateArchetype(id)
	end
end

function getLocalPlayerActiveArchetypes()
	local localPlayer = g_game.getLocalPlayer()

	if localPlayer then
		return localPlayer:getActiveArchetypes()
	else
		return {}
	end
end

function getResourceSlot()
	return archetypes.slots[1]
end

function getUnoccupiedResourceSlot()
	local slot = getResourceSlot()

	if not slot.active then
		return slot
	end
end

function activateArchetype(archetypeId)
	local slot = getResourceSlot()

	slot.id = archetypeId
	slot.active = true

	if slot.widget then
		local localPlayer = g_game.getLocalPlayer()

		if localPlayer then
			local resource = localPlayer:getResource()
			local maxResource = localPlayer:getMaxResource()

			slot.widget:setPercentage(resource, maxResource)
		end
	end
end

function update()
	local isEditMode = g_layout.isEditMode()

	resourceBars[1]:recursiveGetChildById("editModeBackground"):setVisible(isEditMode)
	healthBar:recursiveGetChildById("editModeBackground"):setVisible(isEditMode)
	manaBar:recursiveGetChildById("editModeBackground"):setVisible(isEditMode)
	experienceBar:recursiveGetChildById("editModeBackground"):setVisible(isEditMode)
	mountHud:recursiveGetChildById("editModeBackground"):setVisible(isEditMode)

	local enabled = isEditMode and partyPanel:getChildCount() > 0

	partyHud:recursiveGetChildById("editModeBackground"):setVisible(enabled)
	partyHud:setPhantom(not enabled)

	for _, v in pairs(partyPanel:getChildren()) do
		v:setPhantom(enabled)
	end
end

function onLevelChange(localPlayer, value, percent)
	if not localPlayer then
		return
	end

	experienceBar:setPercentage(percent, 0)
	experienceBar:getChildById("icon"):getChildById("level"):setText(value)
	onExperienceChange(localPlayer, localPlayer:getExperience(), 0, localPlayer:getNextLevelExp())
end

function onExperienceChange(localPlayer, experience, oldExp, nextLevelExp)
	if not localPlayer then
		return
	end

	local text = string.format("Legacy Level %d [%d%%] - %d/%d\nDeath Debt [%d%%] - %d", localPlayer:getLevel(), localPlayer:getLevelPercent(), experience, nextLevelExp, localPlayer:getExperienceDebt() / nextLevelExp, localPlayer:getExperienceDebt())

	if onExperienceChangeCallback then
		onExperienceChangeCallback()

		onExperienceChangeCallback = nil
	end

	updateExperienceBarTooltip({
		experience = experience,
		nextLevelExp = nextLevelExp
	})
end

function onOutfitChange(localPlayer, outfit)
	mountHud:setVisible(outfit.mount ~= 0)

	local mountOutfit = {
		category = ThingCategoryCreature,
		mount = outfit.mountBody,
		mountBody = outfit.mountBody,
		mountLightEffect = outfit.mountLightEffect,
		mountFirstOrnament = outfit.mountFirstOrnament,
		mountSecondOrnament = outfit.mountSecondOrnament
	}

	mountHud.staminaBar.mount_icon:setOutfit(mountOutfit)
end

function onMountStaminaChange(localPlayer, stamina, maxStamina)
	if not stamina or not maxStamina then
		return
	end

	mountHud.staminaBar:setPercentage(stamina, maxStamina)
	mountHud.conditions.exhausted:setVisible(stamina == 0)

	local mountTier = localPlayer:getCurrentMountTier()
	local debuffValue = 0

	debuffValue = mountTier <= 3 and 10 or mountTier <= 6 and 25 or 35

	mountHud.conditions.exhausted:setTooltip(string.format("%s %d%%.", "Moa's total Speed and Strength reduced by", debuffValue))
end

function onHealingCreatureChange(creature, oldCreature)
	for _, v in pairs(partyPanel:getChildren()) do
		v:setOn(false)
	end

	if creature then
		local widget = partyPanel:getChildById(creature:getName())

		if widget then
			widget:setOn(true)
		end
	end
end

function onPartyAddMember(name, isOnline, healthPercent, manaPercent, position, channelId, outfit, temporaryOutfit)
	if name == g_game.getLocalPlayer():getName() or partyPanel:getChildById(name) then
		return
	end

	local count = partyPanel:getChildCount()
	local widget = g_ui.createWidget("PartyHealthBar", partyPanel)

	widget:setId(name)
	widget:getChildById("name"):setText(name)

	widget.name.fullName = name

	local textSize = widget.name:getTextSize().width

	while textSize > 80 do
		widget.name:setText(string.format("%s...", widget.name:getText():sub(1, -5)))

		textSize = widget.name:getTextSize().width
	end

	widget.position = position
	widget.healthPercent = math.min(100, healthPercent)
	widget.manaPercent = math.min(100, manaPercent)
	widget.channelId = channelId

	if isOnline then
		local flag = g_worldMap.addFlag(position, MAPMARK_PARTY_MEMBER, name, true, 1, 10, nil, nil, nil, "WorldMapPartyIcon", {
			top = -24,
			left = 3
		})

		if not flag then
			return
		end

		local useOutfit = outfit

		if outfit.shipBody == outfit.lookType then
			useOutfit = temporaryOutfit
		end

		local parsedOutfit = {
			lookType = useOutfit.lookType,
			primaryAddon = useOutfit.primaryAddon,
			secondaryAddon = useOutfit.secondaryAddon,
			bodyColor = useOutfit.bodyColor,
			headColor = useOutfit.headColor,
			legsColor = useOutfit.legsColor,
			feetColor = useOutfit.feetColor,
			category = ThingCategoryCreature
		}

		flag.partyOutfit:setOutfit(parsedOutfit)

		local minimapFlag = g_ui.createWidget("MiniMapPartyIcon", modules.game_minimap.minimapWindow.image)

		minimapFlag.partyOutfit:setOutfit(parsedOutfit)

		minimapFlag.position = {
			x = position.x - g_worldMap.getCustomMapPositionOffset(position).x,
			y = position.y,
			z = position.z
		}
		minimapFlag.icon = MAPMARK_PARTY_MEMBER
		minimapFlag.tooltip = name
		minimapFlag.additionalMarginLeft = 3
		minimapFlag.additionalMarginTop = -12

		modules.game_minimap.addFlag(minimapFlag, true)
		modules.game_minimap.updateMapFlags()
		widget.health:setPercentage(widget.healthPercent, 100)
		widget.mana:setPercentage(widget.manaPercent, 100)
		widget:setChecked(G.currentChannelId ~= widget.channelId)

		if widget:isChecked() then
			widget.channel.icon:setVisible(false)
			widget.channel:setText(widget.channelId)
		end
	else
		widget:disable()
		widget.health:setPercentage(100, 100)
		widget.mana:setPercentage(100, 100)
	end

	local height = 2

	for _, v in pairs(partyPanel:getChildren()) do
		height = height + v:getHeight() + v:getMarginTop() + v:getMarginBottom()
	end

	height = height + partyPanel:getLayout():getSpacing() * (partyPanel:getChildCount() - 1)

	partyHud:setHeight(height)

	if g_layout.isEditMode() and count < 1 then
		update()
	end
end

function onPartyRemoveMember(name)
	local widget = partyPanel:getChildById(name)

	if widget then
		if widget.position then
			g_worldMap.removeFlag(widget.position, MAPMARK_PARTY_MEMBER, name)
		end

		widget:destroy()
	end

	partyHud:setHeight(math.max(34, partyPanel:getChildCount() * 34))

	if g_layout.isEditMode() and partyPanel:getChildCount() < 1 then
		update()
	end
end

function onPartyChangeHealth(name, healthPercent)
	local widget = partyPanel:getChildById(name)

	if widget then
		widget.healthPercent = math.min(100, healthPercent)

		if widget:isEnabled() then
			widget.health:setPercentage(widget.healthPercent, 100)
		end
	end
end

function onPartyChangeMana(name, manaPercent)
	local widget = partyPanel:getChildById(name)

	if widget then
		widget.manaPercent = math.min(100, manaPercent)

		if widget:isEnabled() then
			widget.mana:setPercentage(widget.manaPercent, 100)
		end
	end
end

function onPartyChangePosition(name, position)
	if not updateEvents.partyChangePosition.data[name] then
		updateEvents.partyChangePosition.count = updateEvents.partyChangePosition.count + 1
	end

	updateEvents.partyChangePosition.data[name] = position

	scheduleUpdatePartyPosition()
end

function scheduleUpdatePartyPosition()
	if updateEvents.partyChangePosition.event then
		return
	end

	updateEvents.partyChangePosition.event = scheduleEvent(function()
		local counter = 0

		for _name, _ in pairs(updateEvents.partyChangePosition.data) do
			updatePartyPosition(_name)

			counter = counter + 1

			if counter >= 2 then
				break
			end
		end

		updateEvents.partyChangePosition.event = nil

		if updateEvents.partyChangePosition.count > 0 then
			scheduleUpdatePartyPosition()
		end
	end, updateEvents.partyChangePosition.delay)
end

function updatePartyPosition(name)
	local position = updateEvents.partyChangePosition.data[name]

	if not position then
		return
	end

	updateEvents.partyChangePosition.data[name] = nil
	updateEvents.partyChangePosition.count = updateEvents.partyChangePosition.count - 1

	local widget = partyPanel:getChildById(name)

	if not widget then
		return
	end

	local oldPos = widget.position

	widget.position = position

	local flag = g_worldMap.getFlag(oldPos, MAPMARK_PARTY_MEMBER, name)

	if not flag then
		oldPos.x = oldPos.x - g_worldMap.getCustomMapPositionOffset(oldPos).x
		flag = g_worldMap.getFlag(oldPos, MAPMARK_PARTY_MEMBER, name)

		if not flag then
			print(string.format("Failed to find flag for %s", name))

			return
		end
	end

	flag.position = position
	flag.pos = {
		x = (position.x - g_worldMap.getCustomMapPositionOffset(position).x - g_worldMap.area.fromX) / (g_worldMap.area.toX - g_worldMap.area.fromX),
		y = (position.y - g_worldMap.area.fromY) / (g_worldMap.area.toY - g_worldMap.area.fromY),
		z = position.z
	}

	g_worldMap.updateWidgetPosition(flag, g_worldMap.image:getSize(), g_worldMap.getMapRect())
	modules.game_minimap.updateFlagPosition({
		x = oldPos.x - g_worldMap.getCustomMapPositionOffset(oldPos).x,
		y = oldPos.y,
		z = oldPos.z
	}, position, MAPMARK_PARTY_MEMBER, name)
	modules.game_minimap.updateFlagPosition(oldPos, position, MAPMARK_PARTY_MEMBER, name)
	modules.game_minimap.updateMapFlags()
end

function onPartyChangeOutfit(name, outfit, temporaryOutfit)
	if not updateEvents.partyChangeOutfit.data[name] then
		updateEvents.partyChangeOutfit.count = updateEvents.partyChangePosition.count + 1
	end

	updateEvents.partyChangeOutfit.data[name] = {
		outfit,
		temporaryOutfit
	}

	scheduleUpdatePartyOutfit()
end

function scheduleUpdatePartyOutfit()
	if updateEvents.partyChangeOutfit.event then
		return
	end

	updateEvents.partyChangeOutfit.event = scheduleEvent(function()
		local counter = 0

		for _name, _ in pairs(updateEvents.partyChangeOutfit.data) do
			updatePartyOutfit(_name)

			counter = counter + 1

			if counter >= 2 then
				break
			end
		end

		updateEvents.partyChangeOutfit.event = nil

		if updateEvents.partyChangeOutfit.count > 0 then
			scheduleUpdatePartyOutfit()
		end
	end, updateEvents.partyChangeOutfit.delay)
end

function updatePartyOutfit(name)
	local outfits = updateEvents.partyChangeOutfit.data[name]

	if not outfits then
		return
	end

	local outfit = outfits[1]
	local temporaryOutfit = outfits[2]

	updateEvents.partyChangeOutfit.data[name] = nil
	updateEvents.partyChangeOutfit.count = updateEvents.partyChangePosition.count - 1

	local widget = partyPanel:getChildById(name)

	if not widget then
		return
	end

	local flag = g_worldMap.getFlag(widget.position, MAPMARK_PARTY_MEMBER, name)

	if not flag then
		return
	end

	local useOutfit = outfit

	if outfit.shipBody == outfit.lookType then
		useOutfit = temporaryOutfit
	end

	local parsedOutfit = {
		lookType = useOutfit.lookType,
		primaryAddon = useOutfit.primaryAddon,
		secondaryAddon = useOutfit.secondaryAddon,
		bodyColor = useOutfit.bodyColor,
		headColor = useOutfit.headColor,
		legsColor = useOutfit.legsColor,
		feetColor = useOutfit.feetColor,
		category = ThingCategoryCreature
	}

	flag.partyOutfit:setOutfit(parsedOutfit)
end

function onPartyChangeState(name, isOnline)
	local widget = partyPanel:getChildById(name)

	if not widget then
		return
	end

	if isOnline then
		widget:enable()
		widget:setPercentage(widget.healthPercent, 100)

		local flag = g_worldMap.addFlag(widget.position, MAPMARK_PARTY_MEMBER, name, true, nil, nil, nil, nil, nil, "WorldMapPartyIcon")

		if not flag then
			return
		end

		modules.game_minimap.addFlag(flag)
		modules.game_minimap.onPositionChange(g_game.getLocalPlayer(), widget.position, widget.position)
	else
		widget:disable()
		g_worldMap.removeFlag(widget.position, MAPMARK_PARTY_MEMBER, name)
		widget:setPercentage(0, 100)
	end
end

function setLifeManaBarSize(size)
	healthBar:setOn(size == "small")
	manaBar:setOn(size == "small")

	local player = g_game.getLocalPlayer()

	if player then
		onHealthChange(player, player:getHealth(), player:getMaxHealth())
		onManaChange(player, player:getMana(), player:getMaxMana())
	end
end

function setLifeManaBarType(type)
	if type == "vertical" then
		local widget = g_ui.createWidget("HealthBarVertical", modules.game_interface.getHUDPanel())

		widget:setId("healthBar")
		widget:setOn(healthBar:isOn())
		widget:setPosition(healthBar:getPosition())

		widget.onDragEnter = healthBar.onDragEnter
		widget.onDragLeave = healthBar.onDragLeave
		widget.onDragMove = healthBar.onDragMove

		healthBar:destroy()

		healthBar = widget
		widget = g_ui.createWidget("ManaBarVertical", modules.game_interface.getHUDPanel())

		widget:setId("manaBar")
		widget:setOn(manaBar:isOn())
		widget:setPosition(manaBar:getPosition())

		widget.onDragEnter = manaBar.onDragEnter
		widget.onDragLeave = manaBar.onDragLeave
		widget.onDragMove = manaBar.onDragMove

		manaBar:destroy()

		manaBar = widget

		if healthBar:getPosition().y + healthBar:getHeight() > g_window.getHeight() then
			healthBar:setY(g_window.getHeight() - healthBar:getHeight())
		end

		if manaBar:getPosition().y + manaBar:getHeight() > g_window.getHeight() then
			manaBar:setY(g_window.getHeight() - manaBar:getHeight())
		end

		if manaBar:getPosition().x + manaBar:getHeight() > healthBar:getPosition().x then
			manaBar:setX(healthBar:getPosition().x + manaBar:getWidth())
			manaBar:setY(healthBar:getPosition().y)
		elseif healthBar:getPosition().y + healthBar:getHeight() > manaBar:getPosition().y then
			healthBar:setX(manaBar:getPosition().x + healthBar:getWidth())
			healthBar:setY(manaBar:getPosition().y)
		end
	else
		local widget = g_ui.createWidget("HealthBar", modules.game_interface.getHUDPanel())

		widget:setId("healthBar")
		widget:setOn(healthBar:isOn())
		widget:setPosition(healthBar:getPosition())

		widget.onDragEnter = healthBar.onDragEnter
		widget.onDragLeave = healthBar.onDragLeave
		widget.onDragMove = healthBar.onDragMove

		healthBar:destroy()

		healthBar = widget
		widget = g_ui.createWidget("ManaBar", modules.game_interface.getHUDPanel())

		widget:setId("manaBar")
		widget:setOn(manaBar:isOn())
		widget:setPosition(manaBar:getPosition())

		widget.onDragEnter = manaBar.onDragEnter
		widget.onDragLeave = manaBar.onDragLeave
		widget.onDragMove = manaBar.onDragMove

		manaBar:destroy()

		manaBar = widget

		if manaBar:getPosition().x + manaBar:getWidth() > healthBar:getPosition().x then
			manaBar:setY(healthBar:getPosition().y + manaBar:getHeight())
			manaBar:setX(healthBar:getPosition().x)
		elseif healthBar:getPosition().y + healthBar:getHeight() > manaBar:getPosition().y then
			healthBar:setY(manaBar:getPosition().y + healthBar:getHeight())
			healthBar:setX(manaBar:getPosition().x)
		end
	end

	local player = g_game.getLocalPlayer()

	if player then
		onHealthChange(player, player:getHealth(), player:getMaxHealth())
		onManaChange(player, player:getMana(), player:getMaxMana())
	end

	update()
end

function onExperienceDebtChange(localPlayer, experienceDebt)
	addEvent(function()
		local parent = experienceBar
		local bar = experienceBar.debt
		local expBar = experienceBar:recursiveGetChildById("bar")
		local border = experienceBar:recursiveGetChildById("debtBorder")
		local experience = localPlayer:getExperience()
		local nextLevelExp = localPlayer:getNextLevelExp()
		local width = math.min(parent:getWidth() - expBar:getImageRect().width - 25, math.max(1, parent:getWidth() * (experienceDebt / nextLevelExp)))

		bar:setImageRect({
			x = 0,
			y = 0,
			height = 8,
			width = math.max(1, width)
		})
		border:setMarginLeft(width)
		border:setVisible(width > 0)
		bar:setVisible(width > 0)
		experienceBar.rightBorder:setOn(width > 0)
		updateExperienceBarTooltip({
			experienceDebt = experienceDebt
		})
	end)
end

function onPartyShieldChange(creature, shieldId)
	if not creature:isPartyMember() then
		return
	end

	local name = creature:getName()
	local widget = partyPanel:getChildById(name)

	if widget and G.currentChannelId == widget.channelId and not creature:isPartySharedExperienceActive() then
		widget.channel:setText("")
		widget.channel:setOn(true)
		widget.channel.icon:setVisible(true)
	end
end

function onRestedExperienceExtendedOpcode(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.RestedExperience then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		return
	end

	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	if data.action == "update" then
		function onExperienceChangeCallback()
			updateRestedExperienceBar(data.displayPercent, data.percent)
		end

		updateRestedExperienceBar(data.displayPercent, data.percent)
	end
end

function updateRestedExperienceBar(displayPercent, percent)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	updateExperienceBarTooltip({
		displayPercent = displayPercent,
		percent = percent
	})

	local parent = experienceBar
	local bar = experienceBar.rested
	local expBar = experienceBar:recursiveGetChildById("bar")
	local border = experienceBar:recursiveGetChildById("restBorder")

	if displayPercent <= 0 then
		bar:hide()
		border:hide()

		return
	end

	local progressWidth = parent:getWidth() - expBar:getImageRect().width - 25
	local width = math.min(progressWidth, math.max(1, (parent:getWidth() - 25) * math.min(1, displayPercent / 100)))

	bar:setImageRect({
		x = 0,
		y = 0,
		height = 8,
		width = math.floor(math.max(1, width))
	})
	border:setMarginLeft(width)
	border:setVisible(width > 0)
	bar:setVisible(width > 0)
end

function updateExperienceBarTooltip(data)
	addEvent(function()
		local player = g_game.getLocalPlayer()

		if not player then
			return
		end

		local text = string.format("%s %d [%d%%] - %d/%d\nDeath Debt - %d", tr("Legacy Level"), player:getLevel(), player:getLevelPercent(), player:getExperience(), player:getNextLevelExp(), player:getExperienceDebt())

		if data.percent and data.percent > 0 then
			text = text .. string.format("\nRested Experience - %d%%", data.percent)
		end

		if player:getExperienceDebt() <= 0 then
			experienceBar.debt:setVisible(false)
			experienceBar.debtBorder:setVisible(false)
			experienceBar.rightBorder:setOn(false)
		end

		experienceBar.experienceTooltip = {
			header = {
				level = GetHighlightedText(string.format("{%s %d, #FFA851} {[%d%%], white} - %d/%d", tr("Legacy Level"), player:getLevel(), player:getLevelPercent(), player:getExperience(), player:getNextLevelExp()), "#CED2D9"),
				death_penalty = string.format("%s - %d", tr("Death Penalty"), player:getExperienceDebt())
			},
			body = {
				rested_experience = data.percent or 0
			}
		}

		function experienceBar:onHoverChange(hovered)
			if hovered then
				g_gameTooltip.currentWidget = self

				g_gameTooltip.displayExperienceTooltip(self)
			end
		end
	end)
end

function isPlayerInParty()
	return partyPanel:getChildCount() > 0
end
