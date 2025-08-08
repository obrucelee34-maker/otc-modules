-- chunkname: @/modules/game_spelltree/spelltree.lua

GameSpellTree = GameSpellTree or {
	buildsLoaded = false,
	cardsToggled = false,
	maxUnlockSkillSpentPoints = 50,
	requiredPointsSpentPerPassive = 6,
	showingAetherRiftBuild = false,
	currentSelectedCard = {},
	activePassivesPerArchetype = {},
	aetherRiftStatsInfo = {
		baseAttackSpeed = 2000,
		globalCooldownLimit = 1000,
		level = 75,
		criticalDamageLimit = 2,
		baseCriticalDamage = 0.25,
		criticalChanceLimit = 100,
		baseCriticalChance = 10,
		baseRegen = 5,
		baseMaxMana = 1150,
		baseMaxHealth = 4525,
		baseDefense = 300,
		baseAttack = 300,
		powerMultiplier = 7,
		globalCooldownValue = 1500
	}
}
assetPathLogo = "/images/ui/icons/archetypes/"
assetPathAbilityIcon = "/images/ui/icons/abilitybar/"
archetypePanelNames = {
	[ArchetypeWarfare] = "WarfarePanel",
	[ArchetypeArchery] = "ArcheryPanel",
	[ArchetypeShadow] = "ShadowPanel",
	[ArchetypeProtection] = "ProtectionPanel",
	[ArchetypeWizardry] = "WizardryPanel",
	[ArchetypeHoly] = "HolyPanel",
	[ArchetypeSpiritual] = "SpiritualPanel",
	[ArchetypeWitchcraft] = "WitchcraftPanel"
}
archetypeSlots = {}

local archetypeColors = {
	[ArchetypeWarfare] = "#f68300",
	[ArchetypeHoly] = "#d2d490",
	[ArchetypeSpiritual] = "#dc0233",
	[ArchetypeArchery] = "#8fd932",
	[ArchetypeShadow] = "#c568ae",
	[ArchetypeProtection] = "#fff20e",
	[ArchetypeWizardry] = "#4706a0",
	[ArchetypeWitchcraft] = "#0a5fb3"
}

function GameSpellTree:init()
	ProtocolGame.registerExtendedOpcode(ExtendedIds.Archetypes, GameSpellTree.onExtendedOpcode)
	ProtocolGame.registerExtendedOpcode(ExtendedIds.ArchetypesBuild, GameSpellTree.onExtendedOpcodeBuild)
	g_ui.importStyle("styles/styles.otui")
	g_ui.importStyle("styles/replace_active_archetype_modal.otui")
	g_ui.importStyle("styles/cards.otui")
	g_ui.importStyle("styles/archetype_tree.otui")
	g_ui.importStyle("styles/save_build.otui")
	g_ui.importStyle("styles/edit_build.otui")
	g_ui.importStyle("styles/aether_rift_stats.otui")
	g_ui.importStyle("styles/spelltree.otui")
	g_ui.importStyle("main.otui")
	dofile("tree.lua")

	self.window = g_ui.createWidget("SpellTreeWindow", modules.game_interface.getHUDPanel())
	self.saveBuildPanel = g_ui.createWidget("SaveBuildPanel", modules.game_interface.getHUDPanel())
	self.contentPanel = self.window:recursiveGetChildById("contentPanel")
	self.archetypesPanel = self.window:recursiveGetChildById("archetypesPanel")
	self.resetArchetypes = self.window:recursiveGetChildById("resetArchetypes")
	self.skillPointsLabel = self.contentPanel:getChildById("pointsPanel"):getChildById("skillPointsLabel")
	self.legacySkillPointsLabel = self.contentPanel:getChildById("pointsPanel"):getChildById("legacySkillPointsLabel")
	self.effectiveLevel = self.contentPanel:recursiveGetChildById("effectiveLevel")
	self.infoIcon = self.contentPanel:recursiveGetChildById("infoIcon")
	self.cardSelectionWindow = g_ui.createWidget("CardSelectionWindow", self.window)
	self.saveBuildSelectionPanel = g_ui.createWidget("SaveBuildSelectionPanel", self.window)
	self.aetherRiftStatsWindow = g_ui.createWidget("GameSpelltreeAetherRiftStatsWindow", modules.game_interface.getHUDPanel())

	self.aetherRiftStatsWindow:setAttachedTo(self.window)
	self.aetherRiftStatsWindow:setVisible(false)
	connect(self.window, {
		onVisibilityChange = function(widget, visible)
			if not visible then
				self.cardSelectionWindow:hide()
				widget:blockInputPanel(false)
			else
				self:sendBuildOpcode({
					action = "fetch_builds"
				})
			end

			addEvent(function()
				self:updateBuildPanelsVisibility()
			end)
		end
	})
	self.infoIcon:setTooltip(tr("Your effective level is the average\n level of your active archetypes\n\nYou start with 1 skill point at level 1, and gain \n1 additional skill every effective level."))

	self.archetypeSlots = {}

	for i = 1, 3 do
		self.archetypeSlots[i] = self.window:recursiveGetChildById("tree" .. i)
	end

	connect(g_game, {
		onGameStart = self.onGameStart,
		onGameEnd = self.onGameEnd,
		onCoinBalance = self.onBalanceChange
	})
	connect(LocalPlayer, {
		onLevelChange = self.onLevelChange,
		onArchetypeActiveChange = self.onArchetypeActiveChange,
		onArchetypeLevelChange = self.onArchetypeLevelChange,
		onEffectiveLevelChange = self.onEffectiveLevelChange,
		onBaseAttackSpeedChange = self.onBaseAttackSpeedChange,
		onPositionChange = self.onPlayerPositionChange
	})
	connect(GameCards, {
		onRemoveCard = self.onRemoveCard,
		onAddCard = self.onAddCard,
		onReceiveSpellCards = self.onReceiveSpellCards
	})
end

function GameSpellTree:terminate()
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.Archetypes)
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.ArchetypesBuild)

	if self.window then
		self.window:destroy()

		self.window = nil
	end

	if self.saveBuildPanel then
		self.saveBuildPanel:destroy()

		self.saveBuildPanel = nil
	end

	if self.saveBuildSelectionPanel then
		self.saveBuildSelectionPanel:destroy()

		self.saveBuildSelectionPanel = nil
	end

	if self.confirmationBox then
		self.confirmationBox:destroy()

		self.confirmationBox = nil
	end

	self:destroyPopups()

	self.contentPanel = nil

	disconnect(g_game, {
		onGameStart = self.onGameStart,
		onGameEnd = self.onGameEnd,
		onCoinBalance = self.onBalanceChange
	})
	disconnect(LocalPlayer, {
		onLevelChange = self.onLevelChange,
		onArchetypeActiveChange = self.onArchetypeActiveChange,
		onArchetypeLevelChange = self.onArchetypeLevelChange,
		onEffectiveLevelChange = self.onEffectiveLevelChange,
		onBaseAttackSpeedChange = self.onBaseAttackSpeedChange,
		onPositionChange = self.onPlayerPositionChange
	})
	disconnect(GameCards, {
		onRemoveCard = self.onRemoveCard,
		onAddCard = self.onAddCard,
		onReceiveSpellCards = self.onReceiveSpellCards
	})
end

function GameSpellTree.onBalanceChange(premium, amount)
	GameSpellTree.contentPanel.currencyPanel:recursiveGetChildById("currencyAmount"):setText(FormatCommaNumber(amount))
end

function GameSpellTree.onLevelChange(localPlayer, currentLevel)
	if not localPlayer then
		return
	end

	addEvent(function()
		local levelToUnlockArchetypes = {
			7,
			15
		}

		for archetypeIndex, levelToUnlock in ipairs(levelToUnlockArchetypes) do
			local slot = GameSpellTree.archetypeSlots[archetypeIndex + 1]

			if slot then
				if not slot:getChildById("slotContent") then
					local slotContent = g_ui.createWidget("EmptySpellTreeContent", slot)

					if levelToUnlock <= currentLevel then
						if not slotContent:getChildById("option"):isOn() then
							signalcall(GameSpellTree.onUnlockArchetype)
						end

						slotContent:getChildById("option"):setOn(true)
						slotContent:getChildById("label"):setText(tr("Choose your archetype"))
					else
						slotContent:getChildById("option"):setOn(false)
						slotContent:getChildById("label"):setText(tr("Unlocks at level %s", levelToUnlock))
					end
				elseif slot:getChildById("slotContent"):getStyleName() == "EmptySpellTreeContent" then
					local slotContent = slot:getChildById("slotContent")

					if levelToUnlock <= currentLevel then
						if not slotContent:getChildById("option"):isOn() then
							signalcall(GameSpellTree.onUnlockArchetype)
						end

						slotContent:getChildById("option"):setOn(true)
						slotContent:getChildById("label"):setText(tr("Choose your archetype"))
					else
						slotContent:getChildById("option"):setOn(false)
						slotContent:getChildById("label"):setText(tr("Unlocks at level %s", levelToUnlock))
					end
				end
			end
		end
	end)
end

function GameSpellTree.toggle(mouseClick)
	if GameChat:isActive() or (type(mouseClick) ~= "boolean" or not mouseClick) and IsTextEditActive() then
		return
	end

	if GameSpellTree.window:isVisible() then
		GameSpellTree:hide(true)
	else
		if g_game:isInCutsceneMode() then
			return
		end

		GameSpellTree:show()
	end
end

function GameSpellTree:show()
	self.window:show()
	self.window:raise()
	self.window:focus()
end

function GameSpellTree:hide(isEscape)
	if isEscape and self.cardSelectionWindow:isVisible() then
		self.cardSelectionWindow:hide()
		self.window:blockInputPanel(false)

		return
	end

	self.window:hide()
end

function GameSpellTree:sendOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.Archetypes, g_game.serializeTable(data))
	end
end

function GameSpellTree:sendBuildOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.ArchetypesBuild, g_game.serializeTable(data))
	end
end

function GameSpellTree.onGameStart()
	GameSpellTree.showingAetherRiftBuild = false

	GameSpellTree:resetActiveArchetypes()

	local player = g_game.getLocalPlayer()

	if player then
		GameSpellTree.onLevelChange(g_game.getLocalPlayer(), player:getLevel())
	end

	addEvent(function()
		local player = g_game.getLocalPlayer()

		if not player then
			return
		end

		local archetypes = player:getActiveArchetypes()

		table.sort(archetypes)

		for _, archetypeId in ipairs(archetypes) do
			GameSpellTree:requestArchetypeDetails(archetypeId)
		end
	end)
end

function GameSpellTree.onGameEnd()
	GameSpellTree:toggleCards(false)
	GameSpellTree:hide()

	GameSpellTree.buildsLoaded = false

	GameSpellTree:updateBuildPanelsVisibility()
end

function GameSpellTree:resetActiveArchetypes()
	for i = 1, 8 do
		GameSpellTree.onArchetypeActiveChange(nil, i, false)
	end
end

function GameSpellTree.onArchetypeActiveChange(localPlayer, id, isActive, force)
	if not force and GameSpellTree:isShowingAetherRiftBuild() then
		return
	end

	if isActive then
		if GameSpellTree:addArchetype(id) then
			GameSpellTree:requestArchetypeDetails(id)
		end
	else
		GameSpellTree:removeArchetype(id)
	end
end

function GameSpellTree:updatePanelArchetypeInfo(archetypeName, level, active, force)
	if not archetypeName then
		return
	end

	local button = GameSpellTree.archetypesPanel:recursiveGetChildById(archetypeName:lower())

	if not button then
		return
	end

	if level then
		button:getChildById("archetypeLevel"):setText(level)
	end

	if not force and self:isShowingAetherRiftBuild() then
		return
	end

	if active then
		button:recursiveGetChildById("archetypeImage"):setImageSource(string.format("/images/ui/icons/archetypes/45x45/%s", archetypeName:lower()))
		button:getChildById("archetypeLevel"):setOn(true)
		button:getChildById("background"):setOn(true)
		button:getChildById("background"):setChecked(false)
	else
		button:recursiveGetChildById("archetypeImage"):setImageSource(string.format("/images/ui/icons/archetypes/45x45/%s_disabled", archetypeName:lower()))
		button:getChildById("archetypeLevel"):setOn(false)
		button:getChildById("background"):setOn(false)
		button:getChildById("background"):setChecked(false)
	end
end

function GameSpellTree.onArchetypeLevelChange(localPlayer, archetypeId, level, percent)
	if localPlayer:isArchetypeActive(archetypeId) then
		local archetypeName = ArchetypeNames[archetypeId]

		localPlayer:setArchetypeLevel(archetypeId, level, true)
		GameSpellTree:updatePanelArchetypeInfo(archetypeName, level, true)
	end
end

function GameSpellTree:getWindow()
	return self.window
end

function GameSpellTree.onExtendedOpcode(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.Archetypes or buffer == "" then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		return
	end

	if data.action == "fetch_skills" then
		GameSpellTree:enableDisableArchetypeSpells(data.archetype, data.skills, data.legacySkills)
		GameSpellTree:updateArchetypeIcon(data.archetype, data.level, data.percentage)
		GameSpellTree:updateResetAbilitiesEnabled()
		GameSpellTree:refreshPassivesHighlight(data.archetype)
	elseif data.action == "fetch_passives" then
		GameSpellTree:enableDisableArchetypePassives(data.archetype, data.passives)
	elseif data.action == "fetch_class" then
		GameSpellTree:setPlayerClass(data.class)
	elseif data.action == "replace_active_archetype" then
		GameSpellTree:replaceActiveArchetype(data.idLearn, data.archetypes, data.msg)
	elseif data.action == "experience" then
		GameSpellTree:updateArchetypeIcon(data.archetype, data.level, data.percentage)
	elseif data.action == "fetch_active_archetypes" then
		GameSpellTree:updateActiveArchetypesIcon(data.archetypes)
	elseif data.action == "fetch_inactive_archetypes" then
		GameSpellTree:updateInactiveArchetypesIcon(data.archetypes)
	end

	if data.skillPoints then
		GameSpellTree:setSkillPoints(data.skillPoints, nil, nil, data.skillPointsSpent)
	end

	if data.legacySkillPoints then
		GameSpellTree:setLegacySkillPoints(data.legacySkillPoints)
	end
end

function GameSpellTree:canAddArchetype(archetype)
	local panelName = archetypePanelNames[archetype]

	if not panelName then
		return false
	end

	if self:getSlotByArchetype(archetype) then
		return false
	end

	local slot = self:getEmptyArchetypeSlot()

	if not slot then
		return false
	end

	return true
end

function GameSpellTree:addArchetype(archetype)
	local panelName = archetypePanelNames[archetype]

	if not panelName then
		return false
	end

	if self:getSlotByArchetype(archetype) then
		return false
	end

	local slot = self:getEmptyArchetypeSlot()

	if not slot then
		return false
	end

	self:addArchetypeToSlot(panelName, archetype, slot)

	return true
end

function GameSpellTree:requestArchetypeDetails(archetype)
	self:sendOpcode({
		action = "fetch_skills",
		archetype = archetype
	})
	self:sendOpcode({
		action = "fetch_passives",
		archetype = archetype
	})
	self:sendOpcode({
		action = "fetch_class",
		archetype = archetype
	})
	self:sendOpcode({
		action = "fetch_inactive_archetypes"
	})
end

function GameSpellTree:requestArchetypesDetails()
	self:sendOpcode({
		action = "fetch_archetypes"
	})
end

function GameSpellTree:addArchetypeToSlot(panelName, archetype, slot)
	local slotContent = g_ui.createWidget("ActiveSpellTreeContent", slot)
	local panel = g_ui.createWidget("SpellTree", slotContent:getChildById("tree"))

	panel.archetype = archetype

	self:createTreePanel(archetype, panel:recursiveGetChildById("content"))
end

function GameSpellTree:removeArchetype(archetype)
	local slot = self:getSlotByArchetype(archetype)

	if slot then
		slot:getChildById("slotContent"):destroy()
	end
end

function GameSpellTree:getEmptyArchetypeSlot()
	for _, slot in pairs(self.archetypeSlots) do
		if not slot:getChildById("slotContent") then
			return slot
		end

		if slot:getChildById("slotContent"):getStyleName() ~= "ActiveSpellTreeContent" then
			slot:getChildById("slotContent"):destroy()

			return slot
		end
	end
end

function GameSpellTree:getArchetypeLogo(archetype, active, small)
	local archetypeName = ArchetypeNames[archetype]

	if not archetypeName then
		return
	end

	local assetPathLogo = assetPathLogo
	local suffix = not active and "_disabled" or ""

	if small then
		assetPathLogo = assetPathLogo .. "28x28/"
	else
		assetPathLogo = assetPathLogo .. "45x45/"
		suffix = ""
	end

	return assetPathLogo .. archetypeName:lower() .. suffix
end

function GameSpellTree:getSlotByArchetype(archetype)
	for _, slot in pairs(self.archetypeSlots) do
		local slotContent = slot:getChildById("slotContent")

		if slotContent then
			local tree = slotContent:getChildById("tree")

			if tree and tree:getChildByIndex(1) and tree:getChildByIndex(1).archetype and tree:getChildByIndex(1).archetype == archetype then
				return slot
			end
		end
	end
end

function GameSpellTree:getActiveArchetypes()
	local archetypes = {}

	for i, slot in ipairs(self.archetypeSlots) do
		local slotContent = slot:getChildById("slotContent")

		if slotContent and slotContent:getChildById("tree") then
			local panel = slotContent:getChildById("tree"):getChildByIndex(1)

			if panel and panel.archetype then
				archetypes[i] = panel.archetype
			end
		end
	end

	return archetypes
end

function GameSpellTree:getSpellTreeWidgetByArchetype(archetype)
	local slot = self:getSlotByArchetype(archetype)

	if not slot then
		return nil
	end

	return slot:getChildById("slotContent"):getChildById("tree"):recursiveGetChildById("content")
end

function GameSpellTree:printChildren(widget)
	widget = widget or self.window

	for _, child in pairs(widget:getChildren()) do
		GameSpellTree:printChildren(child)
		print(string.format("> %s is child from %s", child:getId(), widget:getId()))
	end
end

function GameSpellTree:updateArchetypeIcon(archetype, level, percent)
	local slot = self:getSlotByArchetype(archetype)

	if not slot then
		return
	end

	local slotContent = slot:getChildById("slotContent")

	if not slotContent then
		return
	end

	slotContent:getChildById("backgroundImage"):setImageSource(string.format("/images/ui/windows/spelltree/archetype_backgrounds/%s", ArchetypeNames[archetype]:lower()))

	local logo = slotContent:getChildById("header"):getChildById("archetypeIcon")

	if level then
		if not self:isShowingAetherRiftBuild() then
			if level >= SOFT_CAP_LEVEL then
				logo:setTooltip(string.format("%s\n%s: %i (Max)", ArchetypeNames[archetype], tr("Level"), level))
			else
				logo:setTooltip(string.format("%s\n%s: %i (%i%%)", ArchetypeNames[archetype], tr("Level"), level, percent))
			end
		else
			logo:removeTooltip()
		end

		slotContent:getChildById("header"):recursiveGetChildById("archetypeLevel"):setText(level)
	end

	slotContent:getChildById("header"):getChildById("archetypeName"):setText(ArchetypeNames[archetype])

	local progress = slotContent:getChildById("progressBar"):getChildById("innerProgressBar")

	if not self:isShowingAetherRiftBuild() then
		progress:setWidth(148 * (percent / 100))
		progress:setVisible(true)
	else
		progress:setVisible(false)
	end

	logo:setImageSource(string.format("/images/ui/icons/archetypes/45x45/%s", ArchetypeNames[archetype]:lower()))

	logo.clickSound = true
	logo.hoverSound = true

	if logo.__disconnects then
		for _, disconnect in ipairs(logo.__disconnects) do
			disconnect()
		end
	end

	local disconnects = connect(logo, {
		onHoverChange = function(widget, hovered)
			if hovered then
				g_sound.onWidgetHover(widget, hovered)
				logo:setOpacity(1)
				progress:setOpacity(1)
			else
				logo:setOpacity(1)
				progress:setOpacity(0.9)
			end
		end
	})

	logo.__disconnects = disconnects

	function logo.onDestroy()
		if logo.__disconnects then
			for _, disconnect in ipairs(logo.__disconnects) do
				disconnect()
			end
		end
	end
end

function GameSpellTree:updateActiveArchetypesIcon(archetypes)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	for _, info in ipairs(archetypes) do
		self.onArchetypeLevelChange(player, info.archetype, info.level, info.percentage)
	end
end

function GameSpellTree:updateInactiveArchetypesIcon(archetypes)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	for _, config in ipairs(archetypes) do
		player:setArchetypeLevel(config.archetype, config.level, false)

		local archetypeName = ArchetypeNames[config.archetype]

		GameSpellTree:updatePanelArchetypeInfo(archetypeName, config.level, false)
	end
end

function GameSpellTree:enableDisableArchetypeSpells(archetype, spells, legacySpells)
	self:toggleCards(false)

	local tree = self:getSpellTreeWidgetByArchetype(archetype)

	if not tree then
		self:addArchetype(archetype)

		tree = self:getSpellTreeWidgetByArchetype(archetype)
	end

	if not tree then
		return
	end

	for _, spell in ipairs(spells) do
		self:configureSpell(tree, spell)
	end

	if legacySpells then
		for _, spell in ipairs(legacySpells) do
			self:configureLegacySpell(tree, spell, archetype)
		end
	end

	signalcall(self.onArchetypeSpellsChange, archetype, spells)
end

function GameSpellTree:getDefaultArchetypeData(archetype, isAetherRiftBuild)
	local archInfo = ARCHETYPES_DATA[archetype]

	if not archInfo then
		return
	end

	local defaultInfo = {
		skills = {},
		legacySkills = {},
		passives = {}
	}

	for index, spell in ipairs(archInfo.skills) do
		table.insert(defaultInfo.skills, {
			enabled = false,
			index = index,
			name = spell.name
		})
	end

	for index, legacySpell in ipairs(archInfo.legacySkills) do
		table.insert(defaultInfo.legacySkills, {
			enabled = false,
			index = index,
			name = legacySpell.name,
			isAetherRiftBuild = isAetherRiftBuild
		})
	end

	for index, passive in ipairs(archInfo.passives) do
		table.insert(defaultInfo.passives, {
			enabled = false,
			index = index,
			name = passive.name
		})
	end

	return defaultInfo
end

function GameSpellTree:updateResetAbilitiesEnabled()
	local canReset = false

	if not g_game.isAetherRiftChannel() then
		for _, archetype in pairs(self:getActiveArchetypes()) do
			local enabled = self:hasArchetypeSpellActive(archetype)

			if enabled then
				canReset = true

				break
			end
		end
	end

	self.resetArchetypes:setEnabled(canReset)
end

function GameSpellTree:getSpellsForArchetype(archetype)
	local spells = {}
	local tree = self:getSpellTreeWidgetByArchetype(archetype)

	if not tree then
		return nil
	end

	for i = 1, 15 do
		local spell = tree:recursiveGetChildById("spell" .. i)

		if spell and spell.spellInfo.enabled then
			spells[i] = spell.spellInfo.name
		end
	end

	return spells
end

function GameSpellTree:refreshPassivesHighlight(archetype)
	local tree = self:getSpellTreeWidgetByArchetype(archetype)

	if not tree then
		return
	end

	local spentPoints = self:getArchetypeSpentSkillPoints(archetype)

	for i = 1, 6 do
		local widget = tree:recursiveGetChildById("passive" .. i)

		if widget then
			local highlight = widget:getChildById("highlight")

			if widget:isOn() then
				highlight:setVisible(false)
			else
				highlight:setVisible(spentPoints >= ((self.activePassivesPerArchetype[archetype] or 0) + 1) * self.requiredPointsSpentPerPassive)
			end
		end
	end
end

function GameSpellTree:enableDisableArchetypePassives(archetype, spells)
	local tree = self:getSpellTreeWidgetByArchetype(archetype)

	if not tree then
		self:addArchetype(archetype)

		tree = self:getSpellTreeWidgetByArchetype(archetype)

		if not tree then
			return
		end
	end

	self.activePassivesPerArchetype[archetype] = 0

	for _, spell in ipairs(spells) do
		local widget = tree:recursiveGetChildById("passive" .. spell.index)

		if not widget then
			return
		end

		widget:setOn(spell.enabled)

		self.activePassivesPerArchetype[archetype] = self.activePassivesPerArchetype[archetype] + (spell.enabled and 1 or 0)

		widget:setImageSource(assetPathAbilityIcon .. spell.name:lower())

		local ability = g_spells:getSpell(spell.name:lower())

		if ability then
			widget.abilityTooltip = true
			widget.abilityId = spell.name:lower()
			widget.archetypeId = archetype
		end
	end

	self:refreshPassivesHighlight(archetype)
end

function GameSpellTree:hasLearnedPassive(archetype, name)
	local tree = self:getSpellTreeWidgetByArchetype(archetype)

	if not tree then
		return false
	end

	for i = 1, 5 do
		local widget = tree:recursiveGetChildById("passive" .. i)

		if widget and widget.abilityId == name and widget:isOn() then
			return true
		end
	end

	return false
end

function GameSpellTree.onEffectiveLevelChange(player, level, oldLevel)
	GameSpellTree:setSkillPoints(nil, level)
	addEvent(function()
		local spectators = g_map.getSpectators(player:getPosition(), false)

		for _, creature in ipairs(spectators) do
			if creature:isMonster() then
				creature:setName(creature:getName())
			end
		end
	end)
end

function GameSpellTree:setSkillPoints(skillPoints, effectiveLevel, force, skillPointsSpent)
	if not force and self:isShowingAetherRiftBuild() then
		return
	end

	if skillPoints then
		local oldPoints = self.skillPointsLabel.skillPoints or -1

		self.skillPointsLabel.skillPoints = skillPoints

		if not self:isShowingAetherRiftBuild() then
			signalcall(self.onUpdateSkillPoints, oldPoints, skillPoints)
		end
	end

	if skillPointsSpent then
		self.skillPointsLabel.skillPointsSpent = skillPointsSpent
	end

	self.skillPointsLabel:setText(skillPoints or self.skillPointsLabel.skillPoints or 0)
	self.effectiveLevel:setText(effectiveLevel or g_game.getLocalPlayer():getEffectiveLevel())
end

function GameSpellTree:setLegacySkillPoints(legacySkillPoints, force)
	if not force and self:isShowingAetherRiftBuild() then
		return
	end

	self.legacySkillPointsLabel:setText(legacySkillPoints or 0)
end

function GameSpellTree:setPlayerClass(className)
	if not g_game.getLocalPlayer() then
		className = "Unknown"
	end

	if className == "" then
		local amountOfArchetypes = #g_game.getLocalPlayer():getActiveArchetypes()

		if amountOfArchetypes == 1 then
			className = "Apprentice"
		elseif amountOfArchetypes == 2 then
			className = "Novice"
		end
	end

	self.contentPanel.topPanel:recursiveGetChildById("className"):setText(className)
end

function GameSpellTree:replaceActiveArchetype(idToLearn, idsToForget, msg, isAetherRiftBuild)
	self:destroyPopups()

	self.replaceArchetypePopup = g_ui.createWidget("ReplaceArchetypeModal", modules.game_interface.getHUDPanel())
	self.replaceArchetypePopup.selectMultiple = false

	self.replaceArchetypePopup:raise()
	self.replaceArchetypePopup:setText(tr("Replace Archetype"))
	connect(self.replaceArchetypePopup, {
		onDestroy = function()
			if self.replaceArchetypeConfirmationPopup then
				self.replaceArchetypeConfirmationPopup:destroy()
			end
		end
	})

	local descLabel = self.replaceArchetypePopup:getChildById("descriptionLabel")

	descLabel:setColoredText(GetHighlightedText(msg))
	self.replaceArchetypePopup:setWidth(descLabel:getWidth() + 24)

	local archetypesPanel = self.replaceArchetypePopup:getChildById("archetypesPanel")
	local index = 1

	archetypesPanel:destroyChildren()

	for forgetId in pairs(idsToForget) do
		local button = g_ui.createWidget("ReplaceArchetypeButton", archetypesPanel)

		button:setId("button" .. index)
		button:getChildById("archetypeLogo"):setImageSource(self:getArchetypeLogo(forgetId, false, false))
		button:setTooltip(ArchetypeNames[forgetId])

		button.forgetId = forgetId
		button.learnId = idToLearn
		index = index + 1
	end

	local confirmButton = self.replaceArchetypePopup:getChildById("buttonsPanel"):getChildById("confirmButton")

	function confirmButton.onClick()
		local player = g_game.getLocalPlayer()

		if not player then
			return
		end

		if self.replaceArchetypeConfirmationPopup then
			self.replaceArchetypeConfirmationPopup:destroy()
		end

		local idToForget

		for _, child in pairs(archetypesPanel:getChildren()) do
			if child:isChecked() then
				idToForget = child.forgetId
			end
		end

		local slotContent = self.archetypesPanel:recursiveGetChildById(ArchetypeNames[idToLearn]:lower())
		local sum = slotContent and slotContent:getChildById("archetypeLevel"):getText() or 0

		for index, archetype in pairs(idsToForget) do
			if index ~= idToForget then
				local slotContent = self.archetypesPanel:recursiveGetChildById(ArchetypeNames[archetype.id]:lower())

				sum = sum + (slotContent and slotContent:getChildById("archetypeLevel"):getText() or 0)
			end
		end

		if player:getEffectiveLevel() > math.floor(sum / 3) then
			self.replaceArchetypeConfirmationPopup = g_ui.createWidget("ReplaceArchetypeConfirmationModal", modules.game_interface.getHUDPanel())

			self.replaceArchetypeConfirmationPopup:setText(tr("Replace Archetype"))
			self.replaceArchetypeConfirmationPopup:raise()

			self.replaceArchetypeConfirmationPopup:getChildById("buttonsPanel"):getChildById("confirmButton").onClick = function()
				replaceArchetypeButtonClicked(confirmButton, isAetherRiftBuild)
			end
		else
			replaceArchetypeButtonClicked(confirmButton, isAetherRiftBuild)
		end
	end

	self:refreshPassivesHighlight(idToLearn)
end

function GameSpellTree:hasArchetypeSpellActive(archetype)
	local tree = self:getSpellTreeWidgetByArchetype(archetype)

	if not tree then
		return nil
	end

	for i = 1, 15 do
		local spell = tree:recursiveGetChildById("spell" .. i)

		if spell and spell.spellInfo and spell.spellInfo.enabled then
			return spell
		end
	end

	return nil
end

function GameSpellTree:resetArchetypesSkills()
	self:destroyPopups()

	self.replaceArchetypePopup = g_ui.createWidget("ReplaceArchetypeModal", modules.game_interface.getHUDPanel())
	self.replaceArchetypePopup.selectMultiple = true

	self.replaceArchetypePopup:setText(tr("Reset Archetypes"))
	self.replaceArchetypePopup:raise()

	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local cost = player:getLevel() <= 20 and 0 or player:getLevel() * 10
	local msg = tr(string.format("Select which archetypes you want to reset the skill points, for each one selected you will be charged |{%i silver, #FFA851}|.", cost))

	if cost == 0 then
		msg = tr("Select which archetypes you want to reset the skill points. This action is free until legacy level 20.")
	end

	if self:isShowingAetherRiftBuild() then
		msg = "Select which archetypes you want to reset the skill points."
	end

	local descLabel = self.replaceArchetypePopup:getChildById("descriptionLabel")

	descLabel:setColoredText(GetHighlightedText(msg))
	self.replaceArchetypePopup:setWidth(descLabel:getWidth() + 24)

	local archetypesPanel = self.replaceArchetypePopup:getChildById("archetypesPanel")
	local index = 1

	archetypesPanel:destroyChildren()

	for _, forgetId in pairs(self:getActiveArchetypes()) do
		local enabled = self:hasArchetypeSpellActive(forgetId)

		if enabled then
			local button = g_ui.createWidget("ReplaceArchetypeButton", archetypesPanel)

			button:setId("button" .. index)
			button:getChildById("archetypeLogo"):setImageSource(self:getArchetypeLogo(forgetId, false, false))
			button:setTooltip(ArchetypeNames[forgetId])

			button.forgetId = forgetId
		end

		index = index + 1
	end

	self.replaceArchetypePopup:getChildById("buttonsPanel"):getChildById("confirmButton").onClick = resetAbilitiesButtonClicked
end

function GameSpellTree:configureSpell(tree, spell)
	local widget = tree:recursiveGetChildById("spell" .. spell.index)
	local link = tree:recursiveGetChildById("spell" .. spell.index .. "link")

	if link then
		link:setOn(spell.enabled)
	end

	widget:setEnabled(true)

	link = tree:recursiveGetChildById("spell" .. spell.index .. "link1")

	if link then
		link:setOn(spell.enabled)
	end

	local tier = spell.enabled and (tonumber(spell.tier) and spell.tier + 1 or 1) or 0

	widget:setOn(spell.enabled)

	widget.spellInfo = spell

	widget:recursiveGetChildById("bottom_points"):setImageSource(string.format("/images/ui/windows/spelltree/spell_bottom_points_%d", tier))
	widget:setImageSource(assetPathAbilityIcon .. spell.name:lower())

	local ability = g_spells:getSpell(spell.name:lower())

	if ability then
		widget.abilityTooltip = true
		widget.abilityId = ability.id
		widget.abilityPoints = ability.points
		widget.abilityTier = tier
	end

	addEvent(function()
		if widget then
			self:configureCard(spell, widget)
		end
	end)
end

function GameSpellTree:configureLegacySpell(tree, spell, archetype)
	local isAetherRiftBuild = spell.isAetherRiftBuild or g_game.isAetherRiftChannel()
	local widget = tree:recursiveGetChildById("legacySpell" .. spell.index)

	widget.archetypeId = archetype

	widget:setEnabled(not isAetherRiftBuild)
	widget:setOn(spell.enabled)

	widget.spellInfo = spell

	widget:setImageSource(assetPathAbilityIcon .. spell.name:lower())

	local overlayWidget = tree:recursiveGetChildById("legacySpellOverlay" .. spell.index)

	if not spell.enabled then
		overlayWidget.bottom_points:setImageSource("/images/ui/windows/spelltree/legacy_spell_bottom_points_0")
	else
		overlayWidget.bottom_points:setImageSource("/images/ui/windows/spelltree/legacy_spell_bottom_points_" .. (spell.tier or 0))
	end

	local lockWidget = tree:recursiveGetChildById("legacySpellLock" .. spell.index)

	lockWidget:setVisible(isAetherRiftBuild)

	if isAetherRiftBuild then
		return
	end

	local ability = g_spells:getSpell(spell.name:lower())

	if ability then
		widget.abilityTooltip = true
		widget.abilityTooltipTierDetails = true
		widget.abilityId = ability.id
		widget.abilityTier = spell.tier

		g_abilityTooltip.checkTooltipUpdate(widget)
	end
end

function GameSpellTree:configureCard(spell, widget)
	if spell.card then
		spell.card.spellInfo = widget.spellInfo
	end

	local smallCardWidget
	local parent = widget:getParent()

	if not parent then
		return
	end

	if parent then
		smallCardWidget = parent:recursiveGetChildById("card_holder_on" .. spell.index)
	end

	if not smallCardWidget then
		smallCardWidget = g_ui.createWidget("ArchetypeSpellCardSmall", widget:getParent())

		smallCardWidget.add_card:setOn(not spell.enabled)
		smallCardWidget:setId("card_holder_on" .. spell.index)
		smallCardWidget:addAnchor(AnchorVerticalCenter, "spell" .. spell.index, AnchorVerticalCenter)
		smallCardWidget:addAnchor(AnchorHorizontalCenter, "spell" .. spell.index, AnchorHorizontalCenter)
	end

	smallCardWidget:setOn(spell.enabled and not spell.card)
	smallCardWidget.add_card:setOn(not spell.enabled)

	smallCardWidget.cardData = spell.card
	smallCardWidget.spellInfo = spell

	smallCardWidget:setVisible(self.cardsToggled)
	smallCardWidget.card_image:setVisible(spell.card)

	if spell.card then
		local path = "/images/ui/ravencards/illustrations/" .. spell.card.name:lower():gsub(" ", "_") .. ".ktx"

		if g_resources.fileExists(path) then
			smallCardWidget.card_image:setImageSource(path)
		else
			smallCardWidget.card_image:setImageSource("/images/ui/ravencards/illustrations/rat_scavenger.ktx")
		end
	end

	if spell.card then
		smallCardWidget.abilityTooltip = true
		smallCardWidget.ravenCardAbilityInfo = {
			name = spell.card.name,
			description = g_ravencards:getCardDescription(spell.card.name, spell.card.rarity + (spell.tier or 0)),
			rarity = spell.card.rarity,
			extraRarity = spell.tier
		}
	else
		smallCardWidget.abilityTooltip = false
		smallCardWidget.ravenCardAbilityInfo = nil
	end

	local microCardWidget = parent:recursiveGetChildById("card_holder_off" .. spell.index)

	if not microCardWidget then
		microCardWidget = g_ui.createWidget("ArchetypeSpellCardMicro", parent)

		microCardWidget:setId("card_holder_off" .. spell.index)
		microCardWidget:setVisible(not self.cardsToggled)

		function microCardWidget.updateCardWidget()
			microCardWidget:breakAnchors()

			if not self.cardsToggled then
				microCardWidget:addAnchor(AnchorTop, "spell" .. spell.index, AnchorTop)
				microCardWidget:addAnchor(AnchorRight, "spell" .. spell.index, AnchorRight)
				microCardWidget:setMarginTop(-10)
				microCardWidget:setMarginRight(-5)
				microCardWidget:lower()
			else
				microCardWidget:addAnchor(AnchorHorizontalCenter, "spell" .. spell.index, AnchorHorizontalCenter)
				microCardWidget:addAnchor(AnchorVerticalCenter, "spell" .. spell.index, AnchorBottom)
				microCardWidget:setMarginTop(0)
				microCardWidget:setMarginRight(0)
				microCardWidget:raise()
			end
		end

		microCardWidget.ability.spellInfo = {
			enabled = spell.enabled,
			index = spell.index,
			name = spell.name
		}

		microCardWidget.ability:setImageSource(widget:getImageSource())
		microCardWidget.ability:setVisible(self.cardsToggled)
		microCardWidget.add_card:setVisible(not self.cardsToggled)
		microCardWidget:setChecked(self.cardsToggled)
	end

	microCardWidget.ability:setOn(spell.enabled)
	microCardWidget:setOn(spell.enabled and not spell.card)
	microCardWidget.add_card:setOn(not spell.enabled)

	microCardWidget.cardData = spell.card

	microCardWidget.card_image:setVisible(not self.cardsToggled and spell.card)
	microCardWidget.updateCardWidget()

	if spell.card then
		local path = "/images/ui/ravencards/illustrations/" .. spell.card.name:lower():gsub(" ", "_") .. ".ktx"

		if g_resources.fileExists(path) then
			microCardWidget.card_image:setImageSource(path)
		else
			microCardWidget.card_image:setImageSource("/images/ui/ravencards/illustrations/rat_scavenger.ktx")
		end
	end
end

function GameSpellTree:selectCard(spellInfo, cardData)
	if self.confirmationBox or not spellInfo.enabled or self.cardSelectionWindow:isVisible() then
		return
	end

	local isAetherRiftBuild = self:isShowingAetherRiftBuild()

	if cardData then
		local function yesCallback()
			self.confirmationBox:destroy()

			self.confirmationBox = nil

			GameCards:removeCard(cardData, isAetherRiftBuild)
		end

		local function noCallback()
			self.confirmationBox:destroy()

			self.confirmationBox = nil
		end

		self.confirmationBox = displayGeneralBox(tr("Remove Card"), tr("Do you really want to remove the card from this skill?"), {
			{
				text = tr("Yes"),
				callback = yesCallback
			},
			{
				text = tr("No"),
				callback = noCallback
			}
		}, yesCallback, noCallback, nil, self.window)

		return
	end

	GameCards:requestSpellCards(spellInfo, isAetherRiftBuild)
end

function GameSpellTree:toggleCards(state)
	if signalcall(self.canToggleCards, state) then
		return
	end

	local button = self.window:recursiveGetChildById("cards_toggle_button")

	if state ~= nil then
		local currentState = button:isOn()

		if currentState ~= state then
			button:onClick()
		end

		return
	end

	button:onClick()
end

function GameSpellTree:onToggleCards()
	local button = self.window:recursiveGetChildById("cards_toggle_button")
	local state = button:isOn()

	self.cardsToggled = state

	for _, archetype in pairs(self:getActiveArchetypes()) do
		local tree = self:getSpellTreeWidgetByArchetype(archetype)

		if not tree then
			return
		end

		for i = 1, 12 do
			local cardWidget = tree:recursiveGetChildById("card_holder_off" .. i)

			if cardWidget then
				cardWidget:setChecked(state)
			end

			cardWidget = tree:recursiveGetChildById("card_holder_on" .. i)

			if cardWidget then
				cardWidget:setVisible(state)
			end

			local spellWidget = tree:recursiveGetChildById("spell" .. i)

			if spellWidget then
				spellWidget:setVisible(not state)
			end
		end
	end

	signalcall(self.onCardsToggled, state)
end

function GameSpellTree.onRemoveCard(spell)
	local self = GameSpellTree
	local archetype = spell.archetype
	local spellName = spell.name
	local tree = self:getSpellTreeWidgetByArchetype(archetype)

	if not tree then
		return
	end

	for i = 1, 12 do
		local widget = tree:recursiveGetChildById("spell" .. i)

		if widget and widget.spellInfo and widget.spellInfo.name:lower() == spellName:lower() then
			widget.spellInfo.card = nil

			self:configureCard(widget.spellInfo, widget)

			break
		end
	end
end

function GameSpellTree.onAddCard(spell, cardData)
	local self = GameSpellTree
	local archetype = spell.archetype
	local spellName = spell.name
	local tree = self:getSpellTreeWidgetByArchetype(archetype)

	if not tree then
		return
	end

	for i = 1, 12 do
		local widget = tree:recursiveGetChildById("spell" .. i)

		if widget and widget.spellInfo and widget.spellInfo.name:lower() == spellName:lower() then
			widget.spellInfo.card = cardData

			self:configureCard(widget.spellInfo, widget)

			break
		end
	end
end

function GameSpellTree.onReceiveSpellCards(spell, cards)
	local self = GameSpellTree
	local window = self.cardSelectionWindow

	if not window then
		return
	end

	self.window:blockInputPanel(true, window)

	self.currentSelectedCard = {
		spellName = spell.name
	}

	window.content.confirm_button:setEnabled(false)

	window.iconPath = assetPathAbilityIcon .. spell.name:lower()

	window.top_panel.icon:onSetup()
	window.content.label:setText(tr(string.format(window.content.label.formatText, spell.name)))

	local left_card = window.content.left_card_holder.card_holder
	local right_card = window.content.right_card_holder.card_holder
	local widgets = {
		left_card,
		right_card
	}

	for _, widget in ipairs(widgets) do
		widget.cardData = nil

		widget.lock:setVisible(true)
		widget.background:setOn(false)
		widget:setEnabled(false)
		widget:grayOut(true)
		widget.card:setRarity(1)

		widget.abilityTooltip = nil

		for __, child in ipairs(widget.rarity_background:getChildren()) do
			child:setEnabled(false)
			child.background:setOn(false)
			child.icon:setImageSource("/images/ui/ravencards/gem_disabled")
		end
	end

	if cards and #cards > 0 then
		for i, card in ipairs(cards) do
			local highestRarity = 1

			for r = 7, 1, -1 do
				if card.rarities[r] then
					highestRarity = r

					break
				end
			end

			local extraRarity = card.extraRarity or 0
			local atLeastOneRarityUnlocked = not table.empty(card.rarities)

			widgets[i].cardData = card

			widgets[i].lock:setVisible(not atLeastOneRarityUnlocked)
			widgets[i]:setEnabled(atLeastOneRarityUnlocked)
			widgets[i].card:setName(card.name)
			widgets[i]:grayOut(not atLeastOneRarityUnlocked)

			widgets[i].abilityTooltip = true
			widgets[i].ravenCardAbilityInfo = {
				name = card.name,
				description = g_ravencards:getCardDescription(card.name, highestRarity + extraRarity),
				rarity = highestRarity,
				extraRarity = extraRarity
			}

			widgets[i].card:setRarity(highestRarity)

			for index, child in ipairs(widgets[i].rarity_background:getChildren()) do
				local unlocked = card.rarities[index] and card.rarities[index] >= 1

				child:setEnabled(unlocked)
				child.icon:setImageSource(unlocked and "/images/ui/ravencards/gem_" .. index or "/images/ui/ravencards/gem_disabled")
			end
		end
	end

	window:show()

	function window.onVisibilityChange(window, visible)
		if not visible then
			window.onVisibilityChange = nil

			GameSpellTree.window:blockInputPanel(false)
			signalcall(GameSpellTree.onCloseCardSelectionWindow)
		end
	end

	signalcall(self.onOpenCardSelectionWindow)
end

function GameSpellTree:changeCurrentSelectedCardRarity(rarity)
	self.currentSelectedCard.rarity = rarity

	self.cardSelectionWindow.content.confirm_button:setEnabled(rarity ~= nil)
end

function GameSpellTree:changeCurrentSelectedCard(cardName)
	self.currentSelectedCard.cardName = cardName

	self:changeCurrentSelectedCardRarity(nil)
end

function GameSpellTree:changeCurrentSelectedCardSpell(spellName)
	self.currentSelectedCard.spellName = spellName
end

function GameSpellTree:confirmCardSelection()
	self.cardSelectionWindow:hide()
	GameCards:selectSpellCard(self.currentSelectedCard.spellName, self.currentSelectedCard.cardName, self.currentSelectedCard.rarity, self:isShowingAetherRiftBuild())
end

function GameSpellTree:destroyPopups(ignoreArchetypeInfo)
	if self.replaceArchetypePopup then
		self.replaceArchetypePopup:destroy()

		self.replaceArchetypePopup = nil
	end

	if not ignoreArchetypeInfo and GameArchetypeInfo:isVisible() then
		GameArchetypeInfo:hide()
	end
end

function GameSpellTree:getArchetypeSpentSkillPoints(archetype)
	local tree = self:getSpellTreeWidgetByArchetype(archetype)

	if not tree then
		return 0
	end

	local spent = 0

	for i = 1, 15 do
		local spell = tree:recursiveGetChildById("spell" .. i)

		if spell and spell.spellInfo and spell.spellInfo.enabled then
			local ability = g_spells:getSpell(spell.spellInfo.name:lower())

			if ability then
				spent = spent + ability.points
			end
		end
	end

	return spent
end

function GameSpellTree:calculateActiveArchetypeSkillPointContribution()
	local player = g_game.getLocalPlayer()

	if not player then
		return 0
	end

	local archetypes = player:getActiveArchetypes()
	local effectiveLevel = player:getEffectiveLevel()
	local total = 1 + effectiveLevel
	local distributed = 0
	local contribution = {}
	local totalArchetypeLevel = 0

	for _, archetype in ipairs(archetypes) do
		local archetypeLevel = player:getArchetypeLevel(archetype)

		totalArchetypeLevel = totalArchetypeLevel + archetypeLevel
	end

	for _, archetype in ipairs(archetypes) do
		local archetypeLevel = player:getArchetypeLevel(archetype)
		local archetypeContribution = math.floor(archetypeLevel / totalArchetypeLevel * total)

		contribution[archetype] = (contribution[archetype] or 0) + archetypeContribution
		distributed = distributed + archetypeContribution
	end

	for _, archetype in ipairs(archetypes) do
		local archetypeLevel = player:getArchetypeLevel(archetype)

		if total < distributed then
			contribution[archetype] = contribution[archetype] - (distributed - total)
		end
	end

	return contribution
end

function GameSpellTree:getInactiveArchetypeBonus(archetypeLevel)
	local player = g_game.getLocalPlayer()

	if not player then
		return 0
	end

	local bonusPoints = 0

	if archetypeLevel >= 30 then
		local additionalLevels = archetypeLevel - 30

		bonusPoints = math.floor(additionalLevels / 5)
		bonusPoints = bonusPoints + 3
	elseif archetypeLevel >= 20 then
		bonusPoints = bonusPoints + 2
	elseif archetypeLevel >= 10 then
		bonusPoints = bonusPoints + 1
	end

	return bonusPoints
end

function GameSpellTree:displaySkillPointsTooltip(widget, hovered)
	if not hovered then
		if widget.skillPointsTooltip then
			widget.skillPointsTooltip:destroy()

			widget.skillPointsTooltip = nil

			if widget.skillPointsTooltipEvent then
				removeEvent(widget.skillPointsTooltipEvent)

				widget.skillPointsTooltipEvent = nil
			end
		end

		return
	end

	if widget.skillPointsTooltip then
		return
	end

	local tooltip = g_ui.createWidget("GameSpellTreeSkillPointsTooltip", rootWidget)

	widget.skillPointsTooltip = tooltip

	connect(widget, {
		onVisibilityChange = function(widget, visible)
			if not visible then
				tooltip:destroy()
			end
		end
	})

	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local archetypes = player:getActiveArchetypes()
	local activeArchetypesContribution = self:calculateActiveArchetypeSkillPointContribution()
	local activeArchetypesContent = tooltip.skill_points.active_archetypes

	for index, archetype in ipairs(archetypes) do
		local widget = g_ui.createWidget("GameSpellTreeSkillPointsTooltipContentItem", activeArchetypesContent)

		widget.icon:setImageSource(self:getArchetypeLogo(archetype, true, true))
		widget.text:setColoredText(GetHighlightedText(tr(string.format("[|%d|] |%s| {+|%d| point|%s|, white}", player:getArchetypeLevel(archetype), ArchetypeNames[archetype], activeArchetypesContribution[archetype], activeArchetypesContribution[archetype] > 1 and "s" or ""), "#CED2D9")))
	end

	local totalActiveArchetypesContribution = tooltip.skill_points.active_points

	totalActiveArchetypesContribution:setColoredText(GetHighlightedText(tr(string.format("Current: {+|%d| |%s|, #77D463}", player:getEffectiveLevel(), tr("point" .. (player:getEffectiveLevel() ~= 1 and "s" or ""))))))

	local inactiveArchetypesContent = tooltip.skill_points.inactive_archetypes
	local counter = 0
	local totalBonusPoints = 0
	local archetypeLevels = player:getArchetypesLevels()

	for archetype = ArchetypeFirst, ArchetypeLast - 1 do
		if not table.find(archetypes, archetype) then
			counter = counter + 1

			local widget = g_ui.createWidget("GameSpellTreeSkillPointsTooltipContentItem", inactiveArchetypesContent)

			widget.icon:setImageSource(self:getArchetypeLogo(archetype, true, true))

			local bonus = self:getInactiveArchetypeBonus(archetypeLevels[archetype].level)

			totalBonusPoints = totalBonusPoints + bonus

			widget.text:setColoredText(GetHighlightedText(string.format("[|%d|] |%s| {+|%d| point|%s|, white}", archetypeLevels[archetype].level, ArchetypeNames[archetype], bonus, bonus ~= 1 and "s" or ""), "#CED2D9"))
		end
	end

	local totalInactiveArchetypesContribution = tooltip.skill_points.inactive_points

	totalInactiveArchetypesContribution:setColoredText(GetHighlightedText(tr(string.format("Inactive: {+|%d| |%s|, #77D463}", totalBonusPoints, tr("point" .. (totalBonusPoints ~= 1 and "s" or ""))))))

	local totalPoints = player:getEffectiveLevel() + totalBonusPoints

	tooltip.skill_points.footer:setColoredText(GetHighlightedText(tr(string.format("Total: {|%d| |%s|, #77D463}", totalPoints, tr("point" .. (totalPoints > 1 and "s" or ""))))))
	tooltip.skill_points.points_available:setText(string.format("Available Skill Points: %d", self.skillPointsLabel.skillPoints))

	if self.skillPointsLabel.skillPointsSpent then
		tooltip.skill_points.points_spent:setText(string.format("Points Spent: %d/%d", self.skillPointsLabel.skillPointsSpent, self.maxUnlockSkillSpentPoints))
	end

	tooltip:setVisible(false)

	widget.skillPointsTooltipEvent = scheduleEvent(function()
		local tooltip = widget.skillPointsTooltip

		if not tooltip then
			return
		end

		tooltip:setVisible(true)

		local tooltipSize = tooltip:getSize()
		local pos = widget:getPosition()
		local size = widget:getSize()
		local tooltipPos = {
			x = pos.x + size.width + 5,
			y = pos.y + widget:getHeight() - tooltipSize.height
		}

		GameSpellTree.setTooltipPosition(tooltip, tooltipPos)
	end, 10)
end

function GameSpellTree.setTooltipPosition(tooltip, tooltipPos)
	local screen = g_window.getSize()
	local tooltipSize = tooltip:getSize()
	local mult = math.min(screen.height / 1080, screen.width / 1920)

	screen = {
		width = screen.width / mult,
		height = screen.height / mult
	}

	local UIScale = 0.75 + modules.game_settings.getOption("UIScale") / 100 * 0.5

	tooltipPos = {
		x = tooltipPos.x * UIScale,
		y = tooltipPos.y * UIScale
	}
	tooltipSize = {
		width = tooltipSize.width * UIScale,
		height = tooltipSize.height * UIScale
	}

	local margin = 10 * UIScale

	if tooltipPos.y + tooltipSize.height + margin > screen.height then
		tooltipPos.y = screen.height - tooltipSize.height - margin
	end

	tooltipPos = {
		x = tooltipPos.x / UIScale,
		y = tooltipPos.y / UIScale
	}

	tooltip:setPosition(tooltipPos)
end

function GameSpellTree:displayLegacySkillPointsTooltip(widget, hovered)
	if not hovered then
		if widget.legacySkillPointsTooltip then
			widget.legacySkillPointsTooltip:destroy()

			widget.legacySkillPointsTooltip = nil

			if widget.legacySkillPointsTooltipEvent then
				removeEvent(widget.legacySkillPointsTooltipEvent)

				widget.legacySkillPointsTooltipEvent = nil
			end
		end

		return
	end

	if widget.legacySkillPointsTooltip then
		return
	end

	local tooltip = g_ui.createWidget("GameSpellTreeLegacySkillPointsTooltip", rootWidget)

	widget.legacySkillPointsTooltip = tooltip

	connect(widget, {
		onVisibilityChange = function(widget, visible)
			if not visible then
				tooltip:destroy()
			end
		end
	})

	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local playerLevel = player:getLevel()
	local totalLegacyPoints = playerLevel > SOFT_CAP_LEVEL and playerLevel - SOFT_CAP_LEVEL or 0

	tooltip.legacy_skill_points.footer:setColoredText(GetHighlightedText(tr(string.format("Total: {%d %s, #77D463}", totalLegacyPoints, tr("point" .. (totalLegacyPoints > 1 and "s" or ""))))))
	tooltip:setVisible(false)

	widget.legacySkillPointsTooltipEvent = scheduleEvent(function()
		local tooltip = widget.legacySkillPointsTooltip

		if not tooltip then
			return
		end

		tooltip:setVisible(true)

		local tooltipSize = tooltip:getSize()
		local pos = widget:getPosition()
		local size = widget:getSize()
		local tooltipPos = {
			x = pos.x + size.width + 5,
			y = pos.y + widget:getHeight() - tooltipSize.height
		}

		GameSpellTree.setTooltipPosition(tooltip, tooltipPos)
	end, 10)
end

function GameSpellTree.onExtendedOpcodeBuild(protocol, opcode, buffer)
	local self = GameSpellTree

	if opcode ~= ExtendedIds.ArchetypesBuild or buffer == "" then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		return
	end

	if data.action == "fetch_builds" then
		self.buildsLoaded = true

		local topPanel = self.saveBuildPanel
		local selectionPanel = self.saveBuildSelectionPanel

		selectionPanel.content:destroyChildren()

		local function setArchetypeIcons(children, archetypes)
			table.sort(archetypes)

			for k, v in ipairs(children) do
				local archetypeId = archetypes[k]

				if archetypeId then
					v:setImageSource(string.format("/images/ui/icons/archetypes/28x28/%s", ArchetypeNames[archetypeId]:lower()))
				else
					v:setImageSource("/images/ui/windows/spelltree/save_build/archetype_slot_empty")
				end
			end
		end

		local size = 0
		local aetherRiftBuilds = data.aetherRiftBuilds
		local aetherRiftBuildCount = 0

		if aetherRiftBuilds then
			size = #aetherRiftBuilds.slots

			for index, slot in ipairs(aetherRiftBuilds.slots) do
				aetherRiftBuildCount = aetherRiftBuildCount + 1

				local widget = g_ui.createWidget("AetherBuildSelectionWidget", selectionPanel.content)

				widget:setId(string.format("aetherBuildSlot_%d", index))
				widget.name:setText(slot.name)
				widget.current_build_tag:setVisible(index == aetherRiftBuilds.currentBuildId)
				widget.button:setOn(index == aetherRiftBuilds.currentBuildId and self:isShowingAetherRiftBuild())

				widget.archetypes = slot.archetypes
				widget.aetherBuildId = index
				widget.isAetherRiftBuild = true

				setArchetypeIcons(widget.archetype_icons:getChildren(), slot.archetypes)
			end
		end

		local builds = data.builds

		size = size + #builds.slots

		for index, slot in ipairs(builds.slots) do
			local widget = g_ui.createWidget("SaveBuildSelectionWidget", selectionPanel.content)

			widget:setId(string.format("buildSlot_%d", index))
			widget.name:setText(slot.name)
			widget.current_build_tag:setVisible(index == builds.currentBuildId)
			widget.button:setOn(index == builds.currentBuildId and not self:isShowingAetherRiftBuild())

			widget.archetypes = slot.archetypes
			widget.buildId = index

			setArchetypeIcons(widget.archetype_icons:getChildren(), slot.archetypes)
		end

		local active = self:isShowingAetherRiftBuild() and aetherRiftBuilds and aetherRiftBuilds.slots[aetherRiftBuilds.currentBuildId] or builds.slots[builds.currentBuildId]

		if active then
			topPanel.currentAetherRiftBuildId = aetherRiftBuilds and aetherRiftBuilds.currentBuildId
			topPanel.currentBuildId = builds.currentBuildId

			topPanel.button:setEnabled(#active.archetypes >= 3)
			topPanel.name:setText(active.name)
			topPanel.info:setVisible(self:isShowingAetherRiftBuild())
			setArchetypeIcons(topPanel.archetype_icons:getChildren(), active.archetypes)
		end

		local maxSlots = self.archetypeBuilds.maxSlotsUnlocked
		local height = size < maxSlots and 50 or 0

		selectionPanel.bottom_panel:setHeight(height)
		selectionPanel.bottom_panel.name:setText("Build " .. size + 1)

		selectionPanel.content.unlockBuildCost = self.archetypeBuilds.baseSilverUnlockCost[math.max(1, size - aetherRiftBuildCount)]

		selectionPanel.bottom_panel.unlock_button:setText(FormatCommaNumber(selectionPanel.content.unlockBuildCost))
		selectionPanel:setHeight(height + 50 * size)

		if self:isShowingAetherRiftBuild() and not self.aetherRiftStatsWindow:isVisible() and self.window:isVisible() then
			self.aetherRiftStatsWindow:setVisible(true)
			self.aetherRiftStatsWindow:followParent()
		end

		self:updateBuildPanelsVisibility()
	elseif data.action == "aether_rift_build" then
		self:showAetherRiftBuild(data.data)
	elseif data.action == "replace_active_archetype" then
		GameSpellTree:replaceActiveArchetype(data.idLearn, data.archetypes, data.msg, true)
	elseif data.action == "remove_active_card" then
		local spell = g_spells:getSpell(data.spellId)

		if spell then
			self.onRemoveCard(spell)
		end
	elseif data.action == "add_active_card" then
		local spell = g_spells:getSpell(data.spellId)

		if spell then
			self.onAddCard(spell, data.card)
		end
	end
end

function GameSpellTree:onEditBuildWindow(widget)
	self.saveBuildEditNameWindow = self.saveBuildEditNameWindow or g_ui.createWidget("SaveBuildEditNameWindow", self.window)

	self.saveBuildEditNameWindow:setVisible(true)

	function self.saveBuildEditNameWindow.onDestroy()
		self.saveBuildEditNameWindow = nil
	end

	local textEdit = self.saveBuildEditNameWindow:recursiveGetChildById("textEdit")

	textEdit:setText(widget.name:getText())

	textEdit.buildId = widget.buildId
end

function GameSpellTree:changeBuildSelection(buildId, aetherBuildId)
	if buildId then
		self:sendBuildOpcode({
			action = "change_build_selection",
			buildId = buildId
		})
	elseif aetherBuildId then
		self:sendBuildOpcode({
			action = "select_aether_build",
			aetherBuildId = aetherBuildId
		})
	end
end

function GameSpellTree:onReplaceBuildWindow(widget)
	local topPanel = self.saveBuildPanel

	if topPanel.currentBuildId == widget.buildId then
		if self:isShowingAetherRiftBuild() then
			self:setShowingAetherRiftBuild(false)
		end

		return
	end

	self.saveBuildReplaceWindow = self.saveBuildReplaceWindow or g_ui.createWidget("SaveBuildReplaceWindow", self.window)

	function self.saveBuildReplaceWindow.onDestroy()
		self.saveBuildReplaceWindow = nil
	end

	local cost = g_game.getLocalPlayer():getLevel() * 10
	local middlePanel = self.saveBuildReplaceWindow.middlePanel

	middlePanel.descriptionLabel:setColoredText(GetHighlightedText(tr(string.format("Would you like to swap your current Archetypes Build for |{%s, #FFA851}| at the cost of |{%d Silver, #FFA851}|?", widget.name:getText(), cost))))
	middlePanel.archetypesLabel:setText(tr("New Archetypes:"))

	for k, v in ipairs(self.saveBuildReplaceWindow.middlePanel.archetype_icons:getChildren()) do
		local archetypeId = widget.archetypes[k]

		if archetypeId then
			v:setImageSource(string.format("/images/ui/icons/archetypes/90x90/%s", ArchetypeNames[archetypeId]:lower()))
		end
	end

	local buttonsPanel = self.saveBuildReplaceWindow.buttonsPanel

	buttonsPanel.confirmButton:setVisible(true)
	buttonsPanel.confirmButton:setText(FormatCommaNumber(cost))

	buttonsPanel.confirmButton.buildId = widget.buildId

	buttonsPanel.confirmAetherRiftButton:setVisible(false)
end

function GameSpellTree:changeBuildName()
	local panel = self.saveBuildEditNameWindow:recursiveGetChildById("textEdit")
	local name = panel:getText() or ""
	local buildId = panel.buildId

	if self.saveBuildEditNameWindow then
		self.saveBuildEditNameWindow:destroy()
	end

	if self.confirmationBox then
		self.confirmationBox:destroy()

		self.confirmationBox = nil
	end

	local function yesCallback()
		self.confirmationBox:destroy()

		self.confirmationBox = nil

		self:sendBuildOpcode({
			action = "change_build_name",
			buildId = buildId,
			name = name
		})
	end

	local function noCallback()
		self.confirmationBox:destroy()

		self.confirmationBox = nil
	end

	self.confirmationBox = displayGeneralBox(tr("Build Name"), tr("Are you sure you want to rename this build?"), {
		{
			text = tr("Yes"),
			callback = yesCallback
		},
		{
			text = tr("No"),
			callback = noCallback
		},
		anchor = AnchorHorizontalCenter
	}, yesCallback, noCallback, nil, modules.game_interface.getRootPanel())
end

function GameSpellTree:unlockBuildSlot()
	if self.confirmationBox then
		self.confirmationBox:destroy()

		self.confirmationBox = nil
	end

	local function yesCallback()
		self.confirmationBox:destroy()

		self.confirmationBox = nil

		self:sendBuildOpcode({
			action = "unlock_build_slot"
		})
	end

	local function noCallback()
		self.confirmationBox:destroy()

		self.confirmationBox = nil
	end

	local cost = self.saveBuildSelectionPanel.content.unlockBuildCost

	if not cost then
		noCallback()

		return
	end

	self.confirmationBox = displayGeneralBox(tr("Confirm choice"), tr(string.format("You are purchasing a build slot for |%s| Silver.\nDo you want to continue?", FormatCommaNumber(cost))), {
		{
			text = tr("Yes"),
			callback = yesCallback
		},
		{
			text = tr("No"),
			callback = noCallback
		},
		anchor = AnchorHorizontalCenter
	}, yesCallback, noCallback, nil, modules.game_interface.getRootPanel())
end

function GameSpellTree:updateBuildPanelsVisibility()
	local visible = self.buildsLoaded and self.window and self.window:isVisible() and not g_game.isAetherRiftChannel()

	if self.saveBuildPanel then
		self.saveBuildPanel:setVisible(visible)
	end

	if self.saveBuildSelectionPanel then
		self.saveBuildSelectionPanel:setVisible(false)
	end
end

function GameSpellTree:onSelectAetherRiftBuild(widget)
	local topPanel = self.saveBuildPanel

	if self:isShowingAetherRiftBuild() and topPanel.currentAetherRiftBuildId and topPanel.currentAetherRiftBuildId == widget.aetherBuildId then
		return
	end

	self.saveBuildReplaceWindow = self.saveBuildReplaceWindow or g_ui.createWidget("SaveBuildReplaceWindow", self.window)

	function self.saveBuildReplaceWindow.onDestroy()
		self.saveBuildReplaceWindow = nil
	end

	local middlePanel = self.saveBuildReplaceWindow.middlePanel

	if topPanel.currentAetherRiftBuildId ~= widget.aetherBuildId then
		middlePanel.descriptionLabel:setColoredText(GetHighlightedText(tr(string.format("Would you like to swap your current Aether Rift Build for {|%s|, #BA7DFF}?", widget.name:getText()))))
		middlePanel.archetypesLabel:setText(tr("New Archetypes:"))
	else
		middlePanel.descriptionLabel:setColoredText(GetHighlightedText(tr("Would you like to show your current {Aether Rift Build, #BA7DFF}?")))
		middlePanel.archetypesLabel:setText(tr("Archetypes:"))
	end

	for k, v in ipairs(self.saveBuildReplaceWindow.middlePanel.archetype_icons:getChildren()) do
		local archetypeId = widget.archetypes[k]

		if archetypeId then
			v:setImageSource(string.format("/images/ui/icons/archetypes/90x90/%s", ArchetypeNames[archetypeId]:lower()))
		end
	end

	local buttonsPanel = self.saveBuildReplaceWindow.buttonsPanel

	buttonsPanel.confirmAetherRiftButton:setVisible(true)

	buttonsPanel.confirmAetherRiftButton.aetherBuildId = widget.aetherBuildId

	buttonsPanel.confirmButton:setVisible(false)
end

function GameSpellTree:isShowingAetherRiftBuild()
	return self.showingAetherRiftBuild
end

function GameSpellTree:setShowingAetherRiftBuild(value, ignoreAbilityBar, force)
	if self.showingAetherRiftBuild == value then
		return
	end

	self.showingAetherRiftBuild = value

	self.saveBuildPanel.info:setVisible(value)

	if value then
		AbilityBar.setState(AbilityBarCategoryAetherRiftBuild, true)
		self.aetherRiftStatsWindow:setVisible(true)
		self.aetherRiftStatsWindow:followParent()
	else
		self:resetActiveArchetypes()
		self:restoreCurrentBuildWidget()

		if not ignoreAbilityBar then
			AbilityBar.setDefaultState()
		end

		self.aetherRiftStatsWindow:setVisible(false)

		if force then
			GameNotification:display(NOTIFICATION_INFO, nil, "Your Aether Rift build has been reverted.")
		end
	end
end

function GameSpellTree:restoreCurrentBuildWidget()
	local topPanel = self.saveBuildPanel
	local selectionPanel = self.saveBuildSelectionPanel

	local function setArchetypeIcons(children, archetypes)
		table.sort(archetypes)

		for k, v in ipairs(children) do
			local archetypeId = archetypes[k]

			if archetypeId then
				v:setImageSource(string.format("/images/ui/icons/archetypes/28x28/%s", ArchetypeNames[archetypeId]:lower()))
			else
				v:setImageSource("/images/ui/windows/spelltree/save_build/archetype_slot_empty")
			end
		end
	end

	local activeWidget
	local widgets = selectionPanel.content:getChildren()

	for _, widget in ipairs(widgets) do
		if not widget.isAetherRiftBuild then
			if topPanel.currentBuildId == widget.buildId then
				widget.button:setOn(true)

				activeWidget = widget
			end
		else
			widget.button:setOn(false)
		end
	end

	if activeWidget then
		topPanel.name:setText(activeWidget.name:getText())
		setArchetypeIcons(topPanel.archetype_icons:getChildren(), activeWidget.archetypes)
	end

	self:requestArchetypesDetails()
end

function GameSpellTree:updateCurrentAetherRiftBuildWidget(aetherRiftBuildId, archetypesIds)
	local topPanel = self.saveBuildPanel
	local selectionPanel = self.saveBuildSelectionPanel

	local function setArchetypeIcons(children, archetypes)
		table.sort(archetypes)

		for k, v in ipairs(children) do
			local archetypeId = archetypes[k]

			if archetypeId then
				v:setImageSource(string.format("/images/ui/icons/archetypes/28x28/%s", ArchetypeNames[archetypeId]:lower()))
			else
				v:setImageSource("/images/ui/windows/spelltree/save_build/archetype_slot_empty")
			end
		end
	end

	local activeWidget
	local widgets = selectionPanel.content:getChildren()

	for _, widget in ipairs(widgets) do
		if widget.isAetherRiftBuild then
			if widget.aetherBuildId == aetherRiftBuildId then
				activeWidget = widget

				widget.current_build_tag:setVisible(self:isShowingAetherRiftBuild())
				widget.button:setOn(true)

				widget.archetypes = archetypesIds

				setArchetypeIcons(widget.archetype_icons:getChildren(), widget.archetypes)
			else
				widget.current_build_tag:setVisible(false)
				widget.button:setOn(false)
			end
		elseif self:isShowingAetherRiftBuild() then
			widget.button:setOn(false)
		end
	end

	if activeWidget then
		topPanel.currentAetherRiftBuildId = aetherRiftBuildId

		topPanel.name:setText(activeWidget.name:getText())
		setArchetypeIcons(topPanel.archetype_icons:getChildren(), activeWidget.archetypes)
	end
end

function GameSpellTree:showAetherRiftBuild(data)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	self:setShowingAetherRiftBuild(true)

	if data.remainingPoints then
		self:setSkillPoints(data.remainingPoints, nil, true, data.totalSpentPoints)
		self:setLegacySkillPoints(0)
	end

	table.sort(data.archetypes, function(a, b)
		return a.id < b.id
	end)

	local activeArchetypesIds = {}

	for _, archetypeData in ipairs(data.archetypes) do
		table.insert(activeArchetypesIds, archetypeData.id)
	end

	data.activeArchetypesIds = activeArchetypesIds

	self:updateCurrentAetherRiftBuildWidget(data.buildId, activeArchetypesIds)

	local currentActiveArchetypes = self:getActiveArchetypes()

	for slotIndex, currentActiveArchetype in pairs(currentActiveArchetypes) do
		if activeArchetypesIds[slotIndex] ~= currentActiveArchetype then
			GameSpellTree.onArchetypeActiveChange(nil, currentActiveArchetype, false, true)
		end
	end

	local archetypesLevels = player:getArchetypesLevels()

	for _, archetypeData in ipairs(data.archetypes) do
		local defaultArchetypeData = self:getDefaultArchetypeData(archetypeData.id, true)

		if defaultArchetypeData then
			for _, skill in pairs(archetypeData.skills) do
				defaultArchetypeData.skills[skill.index] = skill
			end

			for _, passive in pairs(archetypeData.passives) do
				defaultArchetypeData.passives[passive.index] = passive
			end

			self:enableDisableArchetypeSpells(archetypeData.id, defaultArchetypeData.skills, defaultArchetypeData.legacySkills)
			self:enableDisableArchetypePassives(archetypeData.id, defaultArchetypeData.passives)
			self:updateArchetypeIcon(archetypeData.id, archetypesLevels[archetypeData.id].level)
		end
	end

	for archetypeId = ArchetypeFirst, ArchetypeLast - 1 do
		local archetypeName = ArchetypeNames[archetypeId]

		if table.find(activeArchetypesIds, archetypeId) then
			self:updatePanelArchetypeInfo(archetypeName, nil, true, true)
		else
			self:updatePanelArchetypeInfo(archetypeName, nil, false, true)
		end
	end

	self:setPlayerClass(data.class)

	if data.stats then
		self:updateAetherRiftStats(data.stats)
	end

	self:updateResetAbilitiesEnabled()

	self.currentAetherBuildData = data

	signalcall(GameSpellTree.onAetherRiftBuildLoaded, data)
end

function GameSpellTree:learnArchetype(archetypeId)
	if not GameSpellTree:isShowingAetherRiftBuild() then
		signalcall(GameArchetypeInfo.onConfirmLearnArchetypeButtonClicked)
		GameSpellTree:sendOpcode({
			action = "learn_archetype",
			id = archetypeId
		})
	else
		GameSpellTree:sendBuildOpcode({
			action = "learn_archetype",
			id = archetypeId
		})
	end
end

function GameSpellTree:learnSkill(archetypeId, spellId)
	if not self:isShowingAetherRiftBuild() then
		self:sendOpcode({
			action = "learn_skill",
			archetype = archetypeId,
			spell = spellId
		})
	else
		self:sendBuildOpcode({
			action = "learn_skill",
			archetype = archetypeId,
			spell = spellId
		})
	end
end

function GameSpellTree:learnPassive(archetypeId, passiveId)
	if not self:isShowingAetherRiftBuild() then
		self:sendOpcode({
			action = "learn_passive",
			archetype = archetypeId,
			passive = passiveId
		})
	else
		self:sendBuildOpcode({
			action = "learn_passive",
			archetype = archetypeId,
			passive = passiveId
		})
	end
end

function GameSpellTree:replaceActiveArchetypeConfirm(idLearn, idForget, isAetherRiftBuild)
	if (not isAetherRiftBuild or not self:isShowingAetherRiftBuild()) and (isAetherRiftBuild or not not self:isShowingAetherRiftBuild()) then
		return
	end

	if not self:isShowingAetherRiftBuild() then
		self:sendOpcode({
			action = "replace_active_archetype_confirm",
			idLearn = idLearn,
			idForget = idForget
		})
	else
		self:sendBuildOpcode({
			action = "replace_active_archetype_confirm",
			idLearn = idLearn,
			idForget = idForget
		})
	end
end

function GameSpellTree:updateAetherRiftStats(stats)
	local statsWindow = self.aetherRiftStatsWindow

	if not statsWindow then
		return
	end

	stats = stats or {}

	local powerAttributesPanel = statsWindow:recursiveGetChildById("aether_rift_power_panel")

	for attributeId, widgetId in pairs(powerAttributesPanel.statNames) do
		local widget = powerAttributesPanel:getChildById(widgetId)
		local value = self:getAetherRiftStaticStatValue(stats, attributeId)

		widget.value:setText(value)
	end

	local primaryPanel = statsWindow:recursiveGetChildById("primary_panel")
	local primaryAttributesPanel = primaryPanel:getChildById("primary_attributes_panel")
	local usedPrimaryPoints = 0

	for attributeId, widgetId in pairs(primaryAttributesPanel.statNames) do
		local value = stats.primary and stats.primary[attributeId] or 0
		local widget = primaryAttributesPanel:getChildById(widgetId)

		widget.value:setText(value)

		usedPrimaryPoints = usedPrimaryPoints + value
	end

	local availablePrimaryPoints = 600 - usedPrimaryPoints

	primaryPanel.header.points:setText(availablePrimaryPoints)

	local secondaryPanel = statsWindow:recursiveGetChildById("secondary_panel")
	local secondaryAttributesPanel = secondaryPanel:getChildById("secondary_attributes_panel")
	local usedSecondaryPoints = 0

	for attributeId, widgetId in pairs(secondaryAttributesPanel.statNames) do
		local value = stats.secondary and stats.secondary[attributeId] or 0
		local widget = secondaryAttributesPanel:getChildById(widgetId)

		widget.value:setText(value)

		usedSecondaryPoints = usedSecondaryPoints + value
	end

	local availableSecondaryPoints = 300 - usedSecondaryPoints

	secondaryPanel.header.points:setText(availableSecondaryPoints)

	for _, widget in ipairs(primaryAttributesPanel:getChildren()) do
		local value = tonumber(widget.value:getText()) or 0

		widget.minus:setEnabled(value > 0)
		widget.plus:setEnabled(availablePrimaryPoints > 0)

		widget.minus.pendingPoints = nil
		widget.plus.pendingPoints = nil

		widget.minus_text:setText("")
		widget.plus_text:setText("")
	end

	for _, widget in ipairs(secondaryAttributesPanel:getChildren()) do
		local value = tonumber(widget.value:getText()) or 0

		widget.minus:setEnabled(value > 0)
		widget.plus:setEnabled(availableSecondaryPoints > 0)
		widget.minus_text:setText("")
		widget.plus_text:setText("")

		widget.minus.pendingPoints = nil
		widget.plus.pendingPoints = nil
	end

	local saveButton = statsWindow:recursiveGetChildById("save_stats_button")

	saveButton:setEnabled(false)

	local resetButton = statsWindow:recursiveGetChildById("reset_stats_button")

	resetButton:setEnabled(usedPrimaryPoints > 0 or usedSecondaryPoints > 0)
	self:updateAetherRiftStaticStats()
end

function GameSpellTree:updateAetherRiftStaticStats()
	local stats = self:getAetherRiftStats()

	if not stats then
		return
	end

	local statsWindow = self.aetherRiftStatsWindow

	if not statsWindow then
		return
	end

	local staticAttributesPanel = statsWindow:recursiveGetChildById("static_attributes_panel")

	for attributeId, widgetId in pairs(staticAttributesPanel.statNames) do
		local widget = staticAttributesPanel:getChildById(widgetId)
		local rawValue = self:getAetherRiftStaticStatValue(stats, attributeId)
		local value = self:getAetherRiftStaticStatSoftcapValue(attributeId, rawValue)

		widget.value:setText(value)

		if value < rawValue then
			widget.value:setOn(true)

			if attributeId == STAT_MAXHITPOINTS or attributeId == STAT_MAXMANAPOINTS then
				local tooltipScaledAttributeValues = "You've reached the softcap.\nAny additional points invested will have reduced benefits towards your current value %i, resulting in %i."

				widget.value:setTooltip(string.format(tooltipScaledAttributeValues, rawValue, value))
			else
				local limit = self.aetherRiftStatsInfo.level * self.aetherRiftStatsInfo.powerMultiplier
				local tooltipScaledAttributeValues = "You've reached the softcap of %i points for this attribute.\nAny additional points invested will have reduced benefits towards your current value %i, resulting in %i."

				widget.value:setTooltip(string.format(tooltipScaledAttributeValues, limit, rawValue, value))
			end
		else
			widget.value:setOn(false)
			widget.value:setTooltip()
		end
	end

	for _, subStatId in ipairs(staticAttributesPanel.subStatIds) do
		local widget = staticAttributesPanel:getChildById(subStatId)
		local value = self:getAetherRiftStaticSubStatValue(stats, subStatId)

		widget.value:setText(value)
	end
end

function GameSpellTree:getAetherRiftStaticStatValue(stats, statId)
	if statId == STAT_ATTACK then
		return self.aetherRiftStatsInfo.baseAttack
	end

	if statId == STAT_DEFENSE then
		return self.aetherRiftStatsInfo.baseDefense
	end

	if statId == STAT_PHYSICALATTACK then
		return self:getAetherRiftStaticStatValue(stats, STAT_ATTACK) + math.floor((stats[STAT_MIGHT] or 0) / 2)
	end

	if statId == STAT_MAGICATTACK then
		return self:getAetherRiftStaticStatValue(stats, STAT_ATTACK) + math.floor((stats[STAT_INTELLIGENCE] or 0) / 2)
	end

	if statId == STAT_PHYSICALDEFENSE then
		return self:getAetherRiftStaticStatValue(stats, STAT_DEFENSE) + math.floor((stats[STAT_DEXTERITY] or 0) / 4) + math.floor((stats[STAT_VITALITY] or 0) / 8) + math.floor((stats[STAT_MIGHT] or 0) / 8)
	end

	if statId == STAT_MAGICDEFENSE then
		return self:getAetherRiftStaticStatValue(stats, STAT_DEFENSE) + math.floor((stats[STAT_WISDOM] or 0) / 4) + math.floor((stats[STAT_VITALITY] or 0) / 8) + math.floor((stats[STAT_DEXTERITY] or 0) / 8) + math.floor((stats[STAT_INTELLIGENCE] or 0) / 8)
	end

	if statId == STAT_HEAL then
		local baseHealing = 15 + math.floor((self:getAetherRiftStaticStatValue(stats, STAT_ATTACK) + self:getAetherRiftStaticStatValue(stats, STAT_DEFENSE)) * 0.1)

		return baseHealing + (stats[STAT_HEAL] or 0) + math.floor((stats[STAT_INTELLIGENCE] or 0) * 0.1) + math.floor((stats[STAT_WISDOM] or 0) * 0.75)
	end

	if statId == STAT_MAXHITPOINTS then
		local baseMaxHealth = self.aetherRiftStatsInfo.baseMaxHealth

		return baseMaxHealth + (stats[STAT_VITALITY] or 0) * 15
	end

	if statId == STAT_MAXMANAPOINTS then
		local baseMaxMana = self.aetherRiftStatsInfo.baseMaxMana

		return baseMaxMana + (stats[STAT_WISDOM] or 0) * 10
	end

	if statId == STAT_HEALTH_REGENERATION then
		local baseRegen = self.aetherRiftStatsInfo.baseRegen

		return baseRegen + math.floor((stats[STAT_VITALITY] or 0) * 0.5) + math.floor((stats[STAT_MIGHT] or 0) * 0.2)
	end

	if statId == STAT_MANA_REGENERATION then
		local baseRegen = self.aetherRiftStatsInfo.baseRegen

		return baseRegen + math.floor((stats[STAT_WISDOM] or 0) * 0.5) + math.floor((stats[STAT_INTELLIGENCE] or 0) * 0.15)
	end

	if statId == STAT_CRITICAL_CHANCE then
		return stats[STAT_CRITICAL_CHANCE] or 0
	end

	if statId == STAT_CRITICAL_DAMAGE then
		return stats[STAT_CRITICAL_DAMAGE] or 0
	end

	if statId == STAT_HASTE then
		return stats[STAT_DEXTERITY] or 0
	end

	return 0
end

function GameSpellTree:getAetherRiftStaticSubStatValue(stats, subStatId)
	if subStatId == "critical_chance_percent" then
		local attribute = self:getAetherRiftStaticStatSoftcapValue(STAT_CRITICAL_CHANCE, self:getAetherRiftStaticStatValue(stats, STAT_CRITICAL_CHANCE))
		local value = math.min(self.aetherRiftStatsInfo.criticalChanceLimit, self.aetherRiftStatsInfo.baseCriticalChance + 45 * attribute / (attribute + self:getAetherRiftPowerLimit() / 2))

		return string.format("%.1f", value)
	end

	if subStatId == "critical_damage_percent" then
		local attribute = self:getAetherRiftStaticStatSoftcapValue(STAT_CRITICAL_DAMAGE, self:getAetherRiftStaticStatValue(stats, STAT_CRITICAL_DAMAGE))
		local value = math.min(self.aetherRiftStatsInfo.criticalDamageLimit, self.aetherRiftStatsInfo.baseCriticalDamage + 75 * attribute / (attribute + self:getAetherRiftPowerLimit() / 2) / 100) * 100

		return string.format("%.1f", value)
	end

	if subStatId == "attack_speed" then
		local attribute = self:getAetherRiftStaticStatSoftcapValue(STAT_HASTE, self:getAetherRiftStaticStatValue(stats, STAT_HASTE))
		local attackSpeedIncrease = 45 * attribute / (attribute + self:getAetherRiftPowerLimit() / 3)
		local attackSpeed = self.aetherRiftStatsInfo.baseAttackSpeed * (1 - attackSpeedIncrease / 100) / 1000

		return string.format("%.2f", attackSpeed)
	end

	if subStatId == "global_cooldown" then
		local attribute = self:getAetherRiftStaticStatSoftcapValue(STAT_HASTE, self:getAetherRiftStaticStatValue(stats, STAT_HASTE))
		local globalCooldownDecrease = 25 * attribute / (attribute + self:getAetherRiftPowerLimit() / 3)
		local outCooldown = math.max(self.aetherRiftStatsInfo.globalCooldownLimit, self.aetherRiftStatsInfo.globalCooldownValue * (1 - globalCooldownDecrease / 100))

		return string.format("%.2f", outCooldown / 1000)
	end

	if subStatId == "casting_time" then
		local attribute = self:getAetherRiftStaticStatSoftcapValue(STAT_HASTE, self:getAetherRiftStaticStatValue(stats, STAT_HASTE))
		local channelingTimeDecrease = 45 * attribute / (attribute + self:getAetherRiftPowerLimit() / 3)
		local time = 100 * (1 - channelingTimeDecrease / 100)

		return math.floor(time)
	end

	return 0
end

function GameSpellTree:getAetherRiftPowerLimit()
	return self.aetherRiftStatsInfo.level * self.aetherRiftStatsInfo.powerMultiplier
end

function GameSpellTree:getAetherRiftStaticStatSoftcapValue(statId, value)
	local limit = self:getAetherRiftPowerLimit()
	local multiplier = 1
	local base = 0

	if statId == STAT_MAXHITPOINTS then
		base = self.aetherRiftStatsInfo.baseMaxHealth
		value = value - base
		multiplier = 10
	elseif statId == STAT_MAXMANAPOINTS then
		base = self.aetherRiftStatsInfo.baseMaxMana
		value = value - base
		multiplier = 5
	end

	limit = limit * multiplier

	if value <= limit then
		return base + value
	end

	local reductionPerPoint = 1 / (limit * 0.3) / 2
	local extraLimitPower = 0

	for extraPoint = 1, value - limit do
		local extraValue = 1 - extraPoint * reductionPerPoint

		if extraValue <= 0 then
			break
		end

		extraLimitPower = extraLimitPower + extraValue
	end

	return math.floor(base + limit + extraLimitPower)
end

function GameSpellTree:addAetherRiftAttribute(widget, remove)
	local attributesPanel = widget:getParent()
	local panel = attributesPanel:getParent()
	local availablePoints = tonumber(panel.header.points:getText()) or 0
	local amount = g_keyboard.isShiftPressed() and 10 or 1
	local plusWidget = widget.plus
	local minusWidget = widget.minus
	local plusWidgetText = widget.plus_text
	local minusWidgetText = widget.minus_text
	local realPoints = tonumber(widget.value:getText()) or 0
	local points = realPoints + (plusWidget.pendingPoints or 0) - (minusWidget.pendingPoints or 0)

	if not remove and availablePoints < amount then
		if availablePoints <= 0 then
			return
		end

		amount = availablePoints
	elseif remove and points < amount then
		if points <= 0 then
			return
		end

		amount = points
	end

	points = points + (remove and -amount or amount)
	plusWidget.pendingPoints = nil
	minusWidget.pendingPoints = nil

	local pointsDiff = points - realPoints

	if pointsDiff > 0 then
		plusWidgetText:setText("+" .. pointsDiff)
		minusWidgetText:setText("")

		plusWidget.pendingPoints = pointsDiff
	elseif pointsDiff < 0 then
		minusWidgetText:setText(pointsDiff)
		plusWidgetText:setText("")

		minusWidget.pendingPoints = -pointsDiff
	else
		minusWidgetText:setText("")
		plusWidgetText:setText("")
	end

	availablePoints = availablePoints - (remove and -amount or amount)

	panel.header.points:setText(availablePoints)

	for _, attributeWidget in ipairs(attributesPanel:getChildren()) do
		attributeWidget.plus:setEnabled(availablePoints > 0)
		attributeWidget.minus:setEnabled(points > 0)
	end

	self:checkAetherRiftSaveStatsButton()
end

function GameSpellTree:removeAetherRiftAttribute(widget)
	self:addAetherRiftAttribute(widget, true)
end

function GameSpellTree:getAetherRiftStats(includePending)
	local statsWindow = self.aetherRiftStatsWindow

	if not statsWindow then
		return
	end

	local stats = {}
	local primaryAttributesPanel = statsWindow:recursiveGetChildById("primary_attributes_panel")

	for attributeId, widgetId in pairs(primaryAttributesPanel.statNames) do
		local widget = primaryAttributesPanel:getChildById(widgetId)
		local points = tonumber(widget.value:getText()) or 0

		if includePending then
			points = points + (widget.plus.pendingPoints or 0) - (widget.minus.pendingPoints or 0)
		end

		if points > 0 then
			stats[attributeId] = points
		end
	end

	local secondaryAttributesPanel = statsWindow:recursiveGetChildById("secondary_attributes_panel")

	for attributeId, widgetId in pairs(secondaryAttributesPanel.statNames) do
		local widget = secondaryAttributesPanel:getChildById(widgetId)
		local points = tonumber(widget.value:getText()) or 0

		if includePending then
			points = points + (widget.plus.pendingPoints or 0) - (widget.minus.pendingPoints or 0)
		end

		if points > 0 then
			stats[attributeId] = points
		end
	end

	return stats
end

function GameSpellTree:resetAetherRiftStats()
	self:sendBuildOpcode({
		action = "save_aether_rift_stats",
		stats = {}
	})
end

function GameSpellTree:saveAetherRiftStats()
	local stats = self:getAetherRiftStats(true)

	if not stats then
		return
	end

	self:sendBuildOpcode({
		action = "save_aether_rift_stats",
		stats = stats
	})
end

function GameSpellTree:checkAetherRiftSaveStatsButton()
	local statsWindow = self.aetherRiftStatsWindow

	if not statsWindow then
		return
	end

	local saveButton = statsWindow:recursiveGetChildById("save_stats_button")
	local primaryAttributesPanel = statsWindow:recursiveGetChildById("primary_attributes_panel")

	for _, widget in ipairs(primaryAttributesPanel:getChildren()) do
		if widget.minus.pendingPoints and widget.minus.pendingPoints ~= 0 then
			saveButton:setEnabled(true)

			return
		end

		if widget.plus.pendingPoints and widget.plus.pendingPoints ~= 0 then
			saveButton:setEnabled(true)

			return
		end
	end

	local secondaryAttributesPanel = statsWindow:recursiveGetChildById("secondary_attributes_panel")

	for _, widget in ipairs(secondaryAttributesPanel:getChildren()) do
		if widget.minus.pendingPoints and widget.minus.pendingPoints ~= 0 then
			saveButton:setEnabled(true)

			return
		end

		if widget.plus.pendingPoints and widget.plus.pendingPoints ~= 0 then
			saveButton:setEnabled(true)

			return
		end
	end

	saveButton:setEnabled(false)
end

function GameSpellTree.onBaseAttackSpeedChange(player, baseAttackSpeed)
	local self = GameSpellTree

	self.aetherRiftStatsInfo.baseAttackSpeed = baseAttackSpeed

	if self:isShowingAetherRiftBuild() then
		self:updateAetherRiftStaticStats()
	end
end

function GameSpellTree.onPlayerPositionChange(player, newPos, oldPos)
	local self = GameSpellTree

	if not self:isShowingAetherRiftBuild() then
		return
	end

	addEvent(function()
		local player = g_game.getLocalPlayer()

		if not player then
			return
		end

		if player:hasStatusIcon(StatusIcons.SafeZone) then
			return
		end

		self:setShowingAetherRiftBuild(false, nil, true)
	end)
end

local normalStatToRiftStat = {
	[StatsMagicAttackEffective] = STAT_MAGICATTACK,
	[StatsPhysicalAttackEffective] = STAT_PHYSICALATTACK,
	[StatsHealingEffective] = STAT_HEAL,
	[StatsDefense] = STAT_DEFENSE,
	[StatsAttack] = STAT_ATTACK,
	[StatsPhysicalDefenseEffective] = STAT_PHYSICALDEFENSE,
	[StatsMagicDefenseEffective] = STAT_MAGICDEFENSE
}

function GameSpellTree:getPlayerAetherRiftBuildStats(player, statId)
	local stats = self:getAetherRiftStats()

	if not stats then
		return
	end

	local riftStatId = normalStatToRiftStat[statId]

	if not riftStatId then
		return
	end

	local rawValue = self:getAetherRiftStaticStatValue(stats, riftStatId)
	local value = self:getAetherRiftStaticStatSoftcapValue(riftStatId, rawValue)

	return value
end

function GameSpellTree:upgradeSkill(widget, archetypeId, spellId)
	local currentTier = widget.abilityTier

	if not currentTier or currentTier > 3 then
		return
	end

	if self.confirmation_box then
		self.confirmation_box:destroy()

		self.confirmation_box = nil
	end

	local function yesCallback()
		if self.confirmation_box then
			self.confirmation_box:destroy()

			self.confirmation_box = nil
		end

		if not self:isShowingAetherRiftBuild() then
			self:sendOpcode({
				action = "upgrade_skill",
				archetypeId = archetypeId,
				spellId = spellId
			})
		else
			self:sendBuildOpcode({
				action = "upgrade_skill",
				archetypeId = archetypeId,
				spellId = spellId
			})
		end
	end

	local function noCallback()
		if self.confirmation_box then
			self.confirmation_box:destroy()

			self.confirmation_box = nil
		end
	end

	self.confirmation_box = displayGeneralBox("Upgrade Skill", tr(string.format("Would you like to spend {|%d| skill points, #FFA851} to upgrade {|%s|, #FFA851} to Level |%d|?", widget.abilityPoints * currentTier, widget.spellInfo.name, currentTier + 1)), {
		{
			text = tr("Yes"),
			callback = yesCallback
		},
		{
			text = tr("No"),
			callback = noCallback
		},
		anchor = AnchorHorizontalCenter
	}, yesCallback, noCallback, nil, modules.game_interface.getRootPanel())
end
