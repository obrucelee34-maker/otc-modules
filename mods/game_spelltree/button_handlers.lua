-- chunkname: @/modules/game_spelltree/button_handlers.lua

function archetypeButtonClicked(button)
	if button.archetypeLevel:isOn() then
		return
	end

	local archetypeName = button:getId():gsub("Button", "")
	local archetypeId = ArchetypeIds[archetypeName]

	GameArchetypeInfo:selectArchetype(archetypeId)
	GameArchetypeInfo:show()
end

function replaceArchetypeButtonClicked(button, isAetherRiftBuild)
	local popupWindow = button:getParent():getParent()

	for _, child in pairs(popupWindow:getChildById("archetypesPanel"):getChildren()) do
		if child:isChecked() then
			GameSpellTree:replaceActiveArchetypeConfirm(child.learnId, child.forgetId, isAetherRiftBuild)

			break
		end
	end

	GameSpellTree:destroyPopups()
end

function learnNewArchetype(button)
	GameSpellTree:destroyPopups()

	GameSpellTree.replaceArchetypePopup = g_ui.createWidget("NewArchetypeModal", GameSpellTree.window)
	GameSpellTree.replaceArchetypePopup.selectMultiple = false

	GameSpellTree.replaceArchetypePopup:setText(tr("Choose your new archetype"))
	GameSpellTree.replaceArchetypePopup:raise()

	local msg = "Select which archetype you want to learn."
	local descLabel = GameSpellTree.replaceArchetypePopup:getChildById("descriptionLabel")

	descLabel:setColoredText(GetHighlightedText(msg))
	GameSpellTree.replaceArchetypePopup:setWidth(descLabel:getWidth() + 24)

	local archetypesPanel = GameSpellTree.replaceArchetypePopup:getChildById("archetypesPanel")
	local index = 1

	archetypesPanel:destroyChildren()

	for archetypeId = ArchetypeNone + 1, ArchetypeLast - 1 do
		if g_game.getLocalPlayer() and not g_game.getLocalPlayer():isArchetypeActive(archetypeId) then
			local button = g_ui.createWidget("ReplaceArchetypeButton", archetypesPanel)

			button:setId("button" .. index)
			button:getChildById("archetypeLogo"):setImageSource(GameSpellTree:getArchetypeLogo(archetypeId, false, false))
			button:setTooltip(ArchetypeNames[archetypeId])

			button.archetypeId = archetypeId
			index = index + 1
		end
	end

	local childCount = archetypesPanel:getChildCount()
	local additionalRowsNeeded = math.floor((childCount - 1) / 3)

	if additionalRowsNeeded > 0 then
		archetypesPanel:setHeight(archetypesPanel:getHeight() + 96 * additionalRowsNeeded)
		GameSpellTree.replaceArchetypePopup:setHeight(GameSpellTree.replaceArchetypePopup:getHeight() + 96 * additionalRowsNeeded)
	end

	GameSpellTree.replaceArchetypePopup:getChildById("buttonsPanel"):getChildById("confirmButton").onClick = learnArchetypeButtonClicked

	signalcall(GameSpellTree.onReplaceArchetypePopup, GameSpellTree.replaceArchetypePopup)
	connect(GameSpellTree.replaceArchetypePopup, {
		onDestroy = function()
			GameSpellTree.replaceArchetypePopup = nil

			signalcall(GameSpellTree.onReplaceArchetypePopupDestroy)
		end
	})
end

function learnArchetypeButtonClicked(button)
	local popupWindow = button:getParent():getParent()
	local selectedArchetypeId

	for _, child in pairs(popupWindow:getChildById("archetypesPanel"):getChildren()) do
		if child:isChecked() then
			selectedArchetypeId = child.archetypeId

			break
		end
	end

	if not selectedArchetypeId then
		GameSpellTree:destroyPopups()

		return
	end

	GameArchetypeInfo:selectArchetype(selectedArchetypeId)
	GameArchetypeInfo:show()
	signalcall(GameSpellTree.onLearnArchetypeButtonClicked)
	GameSpellTree:destroyPopups(true)
end

function resetAbilities(button)
	GameSpellTree:resetArchetypesSkills()
end

function resetAbilitiesButtonClicked(button)
	local ids = {}
	local popupWindow = button:getParent():getParent()

	for _, child in pairs(popupWindow:getChildById("archetypesPanel"):getChildren()) do
		if child:isChecked() then
			ids[#ids + 1] = child.forgetId
		end
	end

	if #ids > 0 then
		if not GameSpellTree:isShowingAetherRiftBuild() then
			GameSpellTree:sendOpcode({
				action = "forget_archetype",
				ids = ids
			})
		else
			GameSpellTree:sendBuildOpcode({
				action = "forget_archetype",
				ids = ids
			})
		end
	end

	GameSpellTree:destroyPopups()
end

function spellClicked(button, mousePos, mouseButton)
	local spellId = tonumber((button:getId():gsub("spell", "")))
	local archetypeId = button.archetypeId

	if not button:isOn() then
		GameSpellTree:learnSkill(archetypeId, spellId)

		return
	end

	if not button.abilityTier or button.abilityTier > 3 then
		return
	end

	if button.lastClick and button.lastClick >= g_clock.millis() then
		return
	end

	GameSpellTree.lastClickEvent = scheduleEvent(function()
		if mouseButton == MouseRightButton then
			local menu = g_ui.createWidget("PopupMenu")

			menu:setId("archetypeSpellMenu")
			menu:addOption(tr("Add to action bar"), function()
				AbilityBar.addSpell(archetypeId, spellId)
			end, nil)
			menu:addSeparator()
			menu:addOption(tr("Upgrade skill"), function()
				GameSpellTree:upgradeSkill(button, archetypeId, spellId)
			end, nil)
			menu:display(g_window:getMousePosition())
		else
			GameSpellTree:upgradeSkill(button, archetypeId, spellId)
		end
	end, 200)
	button.lastClick = g_clock.millis() + 200
end

function legacySpellClicked(button, mousePos, mouseButton)
	if GameSpellTree:isShowingAetherRiftBuild() then
		return
	end

	local spellId = tonumber((button:getId():gsub("legacySpell", "")))
	local archetypeId = button.archetypeId

	if not button:isOn() then
		GameSpellTree:sendOpcode({
			action = "learn_legacy_skill",
			archetype = archetypeId,
			spell = spellId
		})

		return
	end

	if not button.spellInfo or not button.spellInfo.tier or button.spellInfo.tier >= 3 then
		return
	end

	if mouseButton == MouseRightButton then
		local menu = g_ui.createWidget("PopupMenu")

		menu:setId("archetypeSpellMenu")
		menu:addOption(tr("Add to action bar"), function()
			AbilityBar.addSpell(archetypeId, spellId, nil, true)
		end, nil)
		menu:addSeparator()
		menu:addOption(tr("Upgrade legacy skill"), function()
			GameSpellTree:sendOpcode({
				action = "upgrade_legacy_skill",
				archetype = archetypeId,
				spell = spellId
			})
		end, nil)
		menu:display(g_window:getMousePosition())
	else
		GameSpellTree:sendOpcode({
			action = "upgrade_legacy_skill",
			archetype = archetypeId,
			spell = spellId
		})
	end
end

function spellDoubleClicked(button)
	if not button:isOn() then
		return
	end

	if button.lastClick and button.lastClick > g_clock.millis() and GameSpellTree.lastClickEvent then
		removeEvent(GameSpellTree.lastClickEvent)

		GameSpellTree.lastClickEvent = nil
	end

	local spellId = tonumber((button:getId():gsub("spell", "")))
	local archetypeId = button.archetypeId

	AbilityBar.addSpell(archetypeId, spellId)
end

function legacySpellDoubleClicked(button)
	if not button:isOn() then
		return
	end

	local spellId = tonumber((button:getId():gsub("legacySpell", "")))
	local archetypeId = button.archetypeId

	AbilityBar.addSpell(archetypeId, spellId, nil, true)
end

function passiveClicked(button)
	local passiveId = button:getId():gsub("passive", "")

	passiveId = tonumber(passiveId)

	local archetypeId = button.archetypeId

	if not button:isOn() then
		GameSpellTree:learnPassive(archetypeId, passiveId)
	end
end

function archetypeLogoClicked(button)
	local archetypeName = button:getParent():getChildById("content"):getChildren()[1]:getId()
	local archetypeId = ArchetypeIds[archetypeName]

	GameSpellTree:sendOpcode({
		action = "forget_archetype",
		id = archetypeId
	})
end
