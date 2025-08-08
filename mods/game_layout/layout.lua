-- chunkname: @/modules/game_layout/layout.lua

g_layout = {
	editMode = false
}
GRID_SIZE = 5

function g_layout.init()
	connect(g_game, {
		onGameStart = g_layout.onGameStart
	})
	connect(g_game, {
		onGameEnd = g_layout.onGameEnd
	})

	if g_game.isOnline() then
		g_layout.onGameStart()
	end

	g_ui.importStyle("graphs.otui")

	local HUDPanel = modules.game_interface.getHUDPanel()
	local graphsWidget = HUDPanel:getChildById("performanceGraphs")

	if not graphsWidget then
		graphsWidget = g_ui.createWidget("PerformanceGraphsWidget", HUDPanel)

		g_app.setPerformanceGraphsWidget(graphsWidget)
	else
		graphsWidget:setStyle("PerformanceGraphsWidget")
	end
end

function g_layout.terminate()
	disconnect(g_game, {
		onGameStart = g_layout.onGameStart
	})
	disconnect(g_game, {
		onGameEnd = g_layout.onGameEnd
	})

	g_layout.backupSettings = nil
	g_layout.lastSavedSettings = nil

	if g_layout.restoreWindow then
		g_layout.restoreWindow:destroy()

		g_layout.restoreWindow = nil
	end
end

function g_layout.onGameStart()
	g_layout.lastSettingName = g_settings.get("account") .. g_game.getLocalPlayer():getName() .. "Layout"

	g_layout.load()

	local data = g_settings.getNode(g_layout.lastSettingName) or {}

	g_layout.backupSettings = data
end

function g_layout.onGameEnd()
	g_layout.save()

	if g_layout.restoreWindow then
		g_layout.restoreWindow:destroy()

		g_layout.restoreWindow = nil
	end

	g_layout.backupSettings = nil
	g_layout.lastSavedSettings = nil
end

function g_layout.getGridSize()
	return GRID_SIZE
end

function g_layout.setGridSize(val)
	GRID_SIZE = val
end

function g_layout.snapToGrid(pos)
	pos.x = pos.x + (pos.x % g_layout.getGridSize() == 0 and 0 or pos.x % GRID_SIZE >= GRID_SIZE / 2 and GRID_SIZE - pos.x % GRID_SIZE or -(pos.x % GRID_SIZE))
	pos.y = pos.y + (pos.y % GRID_SIZE == 0 and 0 or pos.y % GRID_SIZE >= GRID_SIZE / 2 and GRID_SIZE - pos.y % GRID_SIZE or -(pos.y % GRID_SIZE))

	return pos
end

function UIWidget:snapToGrid()
	self:setPosition(g_layout.snapToGrid(self:getPosition()))
end

function g_layout.loadAbilityBars(reset)
	local data = reset and {} or g_settings.getNode(g_layout.lastSettingName) or {}
	local interface = modules.game_interface
	local sHeight = interface.getRootPanel():getHeight()
	local sWidth = interface.getRootPanel():getWidth()
	local barWidth = 350
	local barHeight = 70
	local y = sHeight - barHeight - 100
	local firstBarX, secondBarX = 0, 0
	local verticalOffset = 0

	for category, bars in pairs(AbilityBar.barWidgets) do
		verticalOffset = 0

		for i, bar in pairs(bars) do
			local categoryIndex = tostring(category)
			local slotIndex = tostring(i)

			if data.abilityBars and data.abilityBars[categoryIndex] and data.abilityBars[categoryIndex][slotIndex] and data.abilityBars[categoryIndex][slotIndex].position then
				bar:setPosition(data.abilityBars[categoryIndex][slotIndex].position)

				if category ~= AbilityBarCategoryWeaponSkill and category ~= AbilityBarCategoryMountSkillWidget then
					AbilityBar.onLock(bar, false)
				end

				if data.abilityBars[categoryIndex][slotIndex].vertical then
					AbilityBar.onRotate(bar, true)
				end
			else
				local x = 0

				if i == 1 then
					firstBarX = sWidth / 2 - barWidth - 50
					x = firstBarX
				elseif i == 2 then
					secondBarX = sWidth / 2 + 50
					x = secondBarX
				else
					local offset = i % 2 == 1 and 1 or 0

					x = offset * firstBarX + (1 - offset) * secondBarX
				end

				bar:setPosition({
					x = x,
					y = y + verticalOffset
				})

				if category == AbilityBarCategoryMount then
					local firstSpellBarPos = AbilityBar.barWidgets[AbilityBarCategorySpell][1]:getPosition()

					bar:setPosition({
						x = firstSpellBarPos.x,
						y = firstSpellBarPos.y + barHeight
					})
				end

				bar:snapToGrid()
			end

			if i % 2 == 0 then
				verticalOffset = verticalOffset - barHeight
			end
		end
	end
end

function g_layout.loadWeaponSkillBar(reset)
	local data = reset and {} or g_settings.getNode(g_layout.lastSettingName) or {}
	local weaponSkillBar = AbilityBar.weaponSkillWidget
	local mostLeftPosition = {
		y = 0,
		x = 0
	}

	if not data.weaponSkillBar or not data.weaponSkillBar.position then
		local mostLeftX

		for category, bars in pairs(AbilityBar.barWidgets) do
			if category == AbilityBarCategorySpell then
				for i, bar in pairs(bars) do
					if i <= AbilityBar.numBarsVisible[category] then
						local position = bar:getPosition()

						if not mostLeftX or mostLeftX > position.x then
							mostLeftX = position.x
							mostLeftPosition.x = position.x
							mostLeftPosition.y = position.y
						end
					end
				end
			end
		end

		mostLeftPosition.x = math.max(0, mostLeftPosition.x - 24 - weaponSkillBar:getWidth())
		mostLeftPosition.y = mostLeftPosition.y - 25
	end

	weaponSkillBar:setPosition(data.weaponSkillBar and data.weaponSkillBar.position or mostLeftPosition)
	weaponSkillBar:snapToGrid()
end

function g_layout.loadMountToggleWidget(reset)
	local data = reset and {} or g_settings.getNode(g_layout.lastSettingName) or {}
	local mountToggleWidget = AbilityBar.mountSkillWidget
	local placePosition = {
		y = 0,
		x = 0
	}

	if not data.mountToggleWidget or not data.mountToggleWidget.position then
		local weaponSkillBar = AbilityBar.weaponSkillWidget

		placePosition = weaponSkillBar:getPosition()
		placePosition.x = placePosition.x + weaponSkillBar:getWidth() - 20
		placePosition.y = placePosition.y + weaponSkillBar:getHeight() - 15
	end

	mountToggleWidget:setPosition(data.mountToggleWidget and data.mountToggleWidget.position or placePosition)
	mountToggleWidget:snapToGrid()
end

function g_layout.loadHealthBars(reset)
	local data = reset and {} or g_settings.getNode(g_layout.lastSettingName) or {}
	local healthInfo = modules.game_healthinfo
	local interface = modules.game_interface
	local sHeight = interface.getRootPanel():getHeight()
	local sWidth = interface.getRootPanel():getWidth()
	local rWidth = healthInfo.resourceBars[1]:getWidth()
	local rHeight = healthInfo.resourceBars[1]:getHeight()
	local y = sHeight - rHeight - 55

	healthInfo.healthBar:setPosition(data.healthBar and data.healthBar.position or {
		y = 40,
		x = 5
	})
	healthInfo.manaBar:setPosition(data.manaBar and data.manaBar.position or {
		y = 90,
		x = 5
	})
	healthInfo.mountHud:setPosition(data.mountHud and data.mountHud.position or {
		y = 130,
		x = 5
	})
	healthInfo.resourceBars[1]:setPosition(data.resourceBars and data.resourceBars.position or {
		x = sWidth / 2 - rWidth / 2,
		y = y - rHeight / 4
	})
	healthInfo.experienceBar:setPosition(data.experienceBar and data.experienceBar.position or {
		x = sWidth / 2 - healthInfo.experienceBar:getWidth() / 2,
		y = sHeight - healthInfo.experienceBar:getHeight() - 60
	})
	healthInfo.healthBar:snapToGrid()
	healthInfo.manaBar:snapToGrid()
	healthInfo.mountHud:snapToGrid()
	healthInfo.resourceBars[1]:snapToGrid()
	healthInfo.experienceBar:snapToGrid()
end

function g_layout.loadTaskListHud(reset)
	local data = reset and {} or g_settings.getNode(g_layout.lastSettingName) or {}
	local taskListHud = modules.game_questlog.taskListHud
	local minimap = modules.game_minimap.minimapWindow
	local panelSize = modules.game_interface.getRootPanel():getSize()

	taskListHud:setPosition(data.taskListHud and data.taskListHud.position or {
		x = panelSize.width - taskListHud:getWidth(),
		y = BGS_DEMO and 45 or minimap:getHeight() + 45
	})
	taskListHud:snapToGrid()
end

function g_layout.loadMinimap(reset)
	local data = reset and {} or g_settings.getNode(g_layout.lastSettingName) or {}
	local minimap = modules.game_minimap.minimapWindow
	local panelSize = modules.game_interface.getRootPanel():getSize()

	minimap:setPosition(data.minimap and data.minimap.position or {
		y = 20,
		x = panelSize.width - 20 - minimap:getWidth()
	})
	minimap:snapToGrid()

	local buttonsData = data.minimap and data.minimap.buttons

	if not buttonsData then
		return
	end

	for _, child in pairs(minimap:getChildren()) do
		if child:getStyleName() == "MinimapToggleButton" then
			local buttonData = buttonsData[child:getId()]

			if buttonData then
				child:setAnglePosition(minimap.image, buttonData.angle, child.offset)
			end
		end
	end
end

function g_layout.loadPartyHud(reset)
	local data = reset and {} or g_settings.getNode(g_layout.lastSettingName) or {}
	local partyHud = modules.game_healthinfo.partyHud

	partyHud:setPosition(data.partyHud and data.partyHud.position or {
		y = 140,
		x = 5
	})
	partyHud:snapToGrid()
end

function g_layout.loadBanditAvatar(reset)
	local data = reset and {} or g_settings.getNode(g_layout.lastSettingName) or {}
	local module = modules.game_interactions

	if not module then
		return
	end

	local banditAvatar = modules.game_interactions.GameInteractions.bandit_avatar
	local panelSize = modules.game_interface.getRootPanel():getSize()
	local size = g_window.getSize()
	local heightScale = size.height / 1080
	local defaultPosition = {
		x = panelSize.width / 2 - banditAvatar:getWidth() / 2,
		y = panelSize.height / 2 - banditAvatar:getHeight() / 2 + 128 * heightScale
	}

	banditAvatar:setPosition(data.banditAvatar and data.banditAvatar.position or defaultPosition)
	banditAvatar:snapToGrid()
end

function g_layout.loadLootNotification(reset)
	local data = reset and {} or g_settings.getNode(g_layout.lastSettingName) or {}
	local module = modules.game_lootnotification

	if not module then
		return
	end

	local GameLootNotification = modules.game_lootnotification.GameLootNotification
	local panelSize = modules.game_interface.getRootPanel():getSize()
	local windowSize = GameLootNotification.window:getSize()
	local defaultPosition = {
		x = panelSize.width / 2 - GameLootNotification.window:getWidth() / 2 + windowSize.width * 1.3,
		y = panelSize.height / 2 - 150
	}

	GameLootNotification.window:setPosition(data.lootNotification and data.lootNotification.position or defaultPosition)
end

function g_layout.loadChannelingBar(reset)
	local data = reset and {} or g_settings.getNode(g_layout.lastSettingName) or {}
	local channelingBar = modules.game_channeling.channelingBarPanel
	local interface = modules.game_interface
	local sHeight = interface.getRootPanel():getHeight()
	local sWidth = interface.getRootPanel():getWidth()
	local barWidth = 206
	local barHeight = 26
	local y = sHeight - barHeight - 250
	local x = math.floor(sWidth / 2) - math.floor(barWidth / 2)

	channelingBar:setPosition(data.channelingBar and data.channelingBar.position or {
		x = x,
		y = y
	})
	channelingBar:snapToGrid()
end

function g_layout.loadDynamicEvents(reset)
	local data = reset and {} or g_settings.getNode(g_layout.lastSettingName) or {}
	local module = modules.game_questlog

	if not module then
		return
	end

	local window = module.DynamicEvent.window
	local rootPanel = modules.game_interface.getRootPanel()
	local y = 110
	local x = math.floor(rootPanel:getWidth() / 2) - math.floor(window:getWidth() / 2)

	window:setPosition(data.dynamicEventHUD and data.dynamicEventHUD.position or {
		x = x,
		y = y
	})
	window:snapToGrid()
end

function g_layout.loadBattleList(reset)
	local data = reset and {} or g_settings.getNode(g_layout.lastSettingName) or {}
	local module = modules.game_battle

	if not module then
		return
	end

	local window = module.BattleList.window
	local y = 250
	local x = 13

	window:setPosition(data.battleList and data.battleList.position or {
		x = x,
		y = y
	})
	window:snapToGrid()
end

function g_layout.loadTargetHud(reset)
	local data = reset and {} or g_settings.getNode(g_layout.lastSettingName) or {}
	local module = modules.game_targethud

	if not module then
		return
	end

	local window = module.GameTargetHud.window
	local hudPanel = modules.game_interface.getHUDPanel()
	local y = 10
	local x = hudPanel:getWidth() / 2 - window.content.targetHudBar:getWidth() / 2

	window:setPosition(data.targetHud and data.targetHud.position or {
		x = x,
		y = y
	})
	window:snapToGrid()
end

function g_layout.loadChat(reset)
	local data = reset and {} or g_settings.getNode(g_layout.lastSettingName) or {}
	local module = modules.game_chat

	if not module then
		return
	end

	local chat = module.GameChat.window
	local height = data.chat and data.chat.height or 400

	chat:setHeight(height)

	local width = data.chat and data.chat.width or 500

	chat:setWidth(width)

	chat.main.expandWidth = width

	chat:setPosition(data.chat and data.chat.position or {
		x = 15,
		y = modules.game_interface.getRootPanel():getHeight() - chat:getHeight() - 28
	})
	chat:snapToGrid()
end

function g_layout.loadLevelupNotification(reset)
	local data = reset and {} or g_settings.getNode(g_layout.lastSettingName) or {}
	local module = modules.game_levelup_notification

	if not module then
		return
	end

	local window = module.GameLevelUpNotification.windows.holder
	local rootPanel = modules.game_interface.getRootPanel()

	window:setPosition(data.levelupNotification and data.levelupNotification.position or {
		x = math.floor(rootPanel:getWidth() / 3),
		y = math.floor(rootPanel:getHeight() / 2) - math.floor(window:getHeight() / 2)
	})
end

function g_layout.loadConditions(reset)
	local data = reset and {} or g_settings.getNode(g_layout.lastSettingName) or {}
	local module = modules.game_conditions.GameConditions

	if not module then
		return
	end

	local buffWindow = module.buffWindow
	local debuffWindow = module.debuffWindow
	local rootPanel = modules.game_interface.getRootPanel()
	local y = 20
	local x = math.floor(rootPanel:getWidth()) - math.floor(buffWindow:getWidth()) - 300

	buffWindow:setPosition(data.conditions and data.conditions.buffWindow and data.conditions.buffWindow.position or {
		x = x,
		y = y
	})
	debuffWindow:setPosition(data.conditions and data.conditions.debuffWindow and data.conditions.debuffWindow.position or {
		x = x,
		y = math.max(y + 40 + debuffWindow:getHeight(), y + 40 + buffWindow:getHeight())
	})
end

function g_layout.loadPerformanceGraphs(reset)
	local graphsWidget = g_app.getPerformanceGraphsWidget()

	if not graphsWidget then
		return
	end

	local data = reset and {} or g_settings.getNode(g_layout.lastSettingName) or {}
	local interface = modules.game_interface
	local sHeight = interface.getRootPanel():getHeight()
	local sWidth = interface.getRootPanel():getWidth()

	graphsWidget:setPosition(data.performanceGraphs and data.performanceGraphs.position or {
		y = 20,
		x = sWidth - 660
	})

	if data.performanceGraphs and data.performanceGraphs.size then
		graphsWidget:setSize(data.performanceGraphs.size)
	end
end

function g_layout.load(reset)
	if reset then
		g_layout.backupSettings = g_settings.getNode(g_layout.lastSettingName) or {}
	end

	local data = reset and {} or g_settings.getNode(g_layout.lastSettingName) or {}
	local interface = modules.game_interface
	local sHeight = interface.getRootPanel():getHeight()
	local sWidth = interface.getRootPanel():getWidth()

	if not reset and data.lastResolution and (data.lastResolution.width ~= sWidth or data.lastResolution.height ~= sHeight) then
		data = {}
		reset = true
	end

	g_layout.loadHealthBars(reset)
	g_layout.loadAbilityBars(reset)
	g_layout.loadWeaponSkillBar(reset)
	g_layout.loadMountToggleWidget(reset)
	g_layout.loadTaskListHud(reset)
	g_layout.loadMinimap(reset)
	g_layout.loadPartyHud(reset)
	g_layout.loadBanditAvatar(reset)
	g_layout.loadLootNotification(reset)
	g_layout.loadChannelingBar(reset)
	g_layout.loadDynamicEvents(reset)
	g_layout.loadBattleList(reset)
	g_layout.loadLevelupNotification(reset)
	g_layout.loadConditions(reset)
	g_layout.loadTargetHud(reset)
	g_layout.loadPerformanceGraphs(reset)
	g_layout.loadChat(reset)
end

function g_layout.loadBackup(callback)
	if not g_layout.backupSettings then
		return
	end

	local function destroyWindow()
		if g_layout.restoreWindow ~= nil then
			g_layout.restoreWindow:destroy()

			g_layout.restoreWindow = nil
		end
	end

	destroyWindow()

	local function yesCallback()
		g_layout.save(true)
		g_settings.setNode(g_layout.lastSettingName, g_layout.backupSettings)
		g_layout.load()
		destroyWindow()

		if callback then
			callback()
		end
	end

	g_layout.restoreWindow = displayGeneralBox(tr("Last Load Restore"), tr("Are you sure you want to restore layout to the last load?"), {
		{
			text = tr("Yes"),
			callback = yesCallback
		},
		{
			text = tr("No"),
			callback = destroyWindow
		},
		anchor = AnchorHorizontalCenter
	}, yesCallback, destroyWindow)
end

function g_layout.restoreLastSaved(callback)
	if not g_layout.lastSavedSettings then
		return
	end

	local function destroyWindow()
		if g_layout.restoreWindow ~= nil then
			g_layout.restoreWindow:destroy()

			g_layout.restoreWindow = nil
		end
	end

	destroyWindow()

	local function yesCallback()
		g_settings.setNode(g_layout.lastSettingName, g_layout.lastSavedSettings)
		g_layout.load()
		destroyWindow()

		if callback then
			callback()
		end
	end

	g_layout.restoreWindow = displayGeneralBox(tr("Last Saved Restore"), tr("Are you sure you want to restore layout to the last saved?"), {
		{
			text = tr("Yes"),
			callback = yesCallback
		},
		{
			text = tr("No"),
			callback = destroyWindow
		},
		anchor = AnchorHorizontalCenter
	}, yesCallback, destroyWindow)
end

function g_layout.saveAbilityBars(data)
	for category, bars in pairs(AbilityBar.barWidgets) do
		data.abilityBars[category] = {}

		for i, bar in pairs(bars) do
			data.abilityBars[category][i] = {
				position = bar:getPosition(),
				vertical = bar.vertical,
				locked = bar.locked or false
			}
		end
	end
end

function g_layout.saveWeaponSkillBar(data)
	local weaponSkillBar = AbilityBar.weaponSkillWidget

	data.weaponSkillBar = {
		position = weaponSkillBar:getPosition()
	}
end

function g_layout.saveMountToggleWidget(data)
	local mountToggleWidget = AbilityBar.mountSkillWidget

	data.mountToggleWidget = {
		position = mountToggleWidget:getPosition()
	}
end

function g_layout.saveHealthBars(data)
	local healthInfo = modules.game_healthinfo
	local interface = modules.game_interface
	local sHeight = interface.getRootPanel():getHeight()
	local sWidth = interface.getRootPanel():getWidth()
	local rWidth = healthInfo.resourceBars[1]:getWidth()
	local rHeight = healthInfo.resourceBars[1]:getHeight()

	data.mountHud = {
		position = healthInfo.mountHud:getPosition()
	}
	data.manaBar = {
		position = healthInfo.manaBar:getPosition()
	}
	data.healthBar = {
		position = healthInfo.healthBar:getPosition()
	}
	data.resourceBars = {
		position = healthInfo.resourceBars[1]:getPosition()
	}
	data.experienceBar = {
		position = healthInfo.experienceBar:getPosition()
	}
end

function g_layout.saveTaskListHud(data)
	local taskListHud = modules.game_questlog.taskListHud

	data.taskListHud = {
		position = taskListHud:getPosition()
	}
end

function g_layout.saveMinimap(data)
	local minimap = modules.game_minimap.minimapWindow

	data.minimap = {
		position = minimap:getPosition()
	}

	for _, child in pairs(minimap:getChildren()) do
		if child:getStyleName() == "MinimapToggleButton" then
			data.minimap.buttons = data.minimap.buttons or {}
			data.minimap.buttons[child:getId()] = {
				angle = child.angle
			}
		end
	end
end

function g_layout.savePartyHud(data)
	local partyHud = modules.game_healthinfo.partyHud

	data.partyHud = {
		position = partyHud:getPosition()
	}
end

function g_layout.saveBanditAvatar(data)
	local interactions = modules.game_interactions.GameInteractions

	data.banditAvatar = {
		position = interactions.bandit_avatar:getPosition()
	}
end

function g_layout.saveLootNotification(data)
	local GameLootNotification = modules.game_lootnotification.GameLootNotification

	data.lootNotification = {
		position = GameLootNotification.window:getPosition()
	}
end

function g_layout.saveChannelingBar(data)
	local channelingBar = modules.game_channeling.channelingBarPanel

	data.channelingBar = {
		position = channelingBar:getPosition()
	}
end

function g_layout.saveDynamicEventHUD(data)
	local dynamicEventHUD = modules.game_questlog.DynamicEvent.window

	data.dynamicEventHUD = {
		position = dynamicEventHUD:getPosition()
	}
end

function g_layout.saveBattleList(data)
	local battleListWindow = modules.game_battle.BattleList.window

	data.battleList = {
		position = battleListWindow:getPosition()
	}
end

function g_layout.saveTargetHud(data)
	if not modules.game_targethud then
		return
	end

	local targetHudWindow = modules.game_targethud.GameTargetHud.window

	data.targetHud = {
		position = targetHudWindow:getPosition()
	}
end

function g_layout.saveChat(data)
	if not modules.game_chat then
		return
	end

	local chatWindow = modules.game_chat.GameChat.window

	data.chat = {
		position = chatWindow:getPosition(),
		width = chatWindow:getWidth(),
		height = chatWindow:getHeight()
	}
end

function g_layout.saveLevelupNotification(data)
	local levelupNotification = modules.game_levelup_notification.GameLevelUpNotification.windows.holder

	data.levelupNotification = {
		position = levelupNotification:getPosition()
	}
end

function g_layout.saveConditions(data)
	local GameConditions = modules.game_conditions.GameConditions

	data.conditions = {
		buffWindow = {
			position = GameConditions.buffWindow:getPosition()
		},
		debuffWindow = {
			position = GameConditions.debuffWindow:getPosition()
		}
	}
end

function g_layout.savePerformanceGraphs(data)
	local graphsWidget = g_app.getPerformanceGraphsWidget()

	if not graphsWidget then
		return
	end

	data.performanceGraphs = {
		position = graphsWidget:getPosition(),
		size = graphsWidget:getSize()
	}
end

function g_layout.save(storeLastSaved)
	local data = {
		abilityBars = {}
	}

	g_layout.saveHealthBars(data)
	g_layout.saveAbilityBars(data)
	g_layout.saveWeaponSkillBar(data)
	g_layout.saveMountToggleWidget(data)
	g_layout.saveTaskListHud(data)
	g_layout.saveMinimap(data)
	g_layout.savePartyHud(data)
	g_layout.saveBanditAvatar(data)
	g_layout.saveLootNotification(data)
	g_layout.saveChannelingBar(data)
	g_layout.saveDynamicEventHUD(data)
	g_layout.saveBattleList(data)
	g_layout.saveLevelupNotification(data)
	g_layout.saveConditions(data)
	g_layout.saveTargetHud(data)
	g_layout.savePerformanceGraphs(data)
	g_layout.saveChat(data)

	local interface = modules.game_interface
	local sHeight = interface.getRootPanel():getHeight()
	local sWidth = interface.getRootPanel():getWidth()

	data.lastResolution = {
		width = sWidth,
		height = sHeight
	}

	g_settings.setNode(g_layout.lastSettingName, data)
	g_settings.save()

	if storeLastSaved then
		g_layout.lastSavedSettings = data
	end

	return data
end

function g_layout.setEditMode(value)
	g_layout.editMode = value

	AbilityBar.update()
	modules.game_healthinfo.update()
	modules.game_questlog.update()
	modules.game_minimap.update()
	modules.game_interactions.GameInteractions:updateBanditAvatarLayoutChange()
	modules.game_lootnotification.update()
	modules.game_channeling.update()
	modules.game_battle.update()
	modules.game_levelup_notification.update()
	modules.game_conditions.update()

	if modules.game_targethud then
		modules.game_targethud.update()
	end

	if modules.game_chat then
		modules.game_chat.GameChat.update()
	end
end

function g_layout.isEditMode()
	return g_layout.editMode
end

function g_layout.onOpenWindow(window, fadeIn, notSave, dontFocus)
	if g_layout.openWindow == window then
		return
	end

	if not notSave then
		if g_layout.openWindow then
			g_layout.openWindow:hide()
		end

		g_layout.openWindow = window
	end

	window:show()
	window:raise()

	if not dontFocus then
		window:focus()
	end

	if fadeIn and fadeIn > 0 then
		g_effects.fadeIn(window, fadeIn)
	end
end

function g_layout.onCloseWindow(window)
	if not g_layout.openWindow then
		return
	end

	if not window and g_layout.openWindow then
		g_layout.openWindow = nil

		return
	end

	if window.onEscape then
		g_layout.openWindow = nil

		window.onEscape(window)
	else
		window:hide()
	end
end
