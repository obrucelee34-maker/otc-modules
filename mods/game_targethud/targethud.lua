-- chunkname: @/modules/game_targethud/targethud.lua

CreatureType = {
	Boss = 3,
	Monster = 2,
	Player = 1
}
GameTargetHud = {
	configs = {
		[CreatureType.Player] = {
			size = {
				width = 200
			},
			frame = {
				image = "/images/ui/windows/targethud/circle_overlay",
				size = {
					height = 36,
					width = 36
				}
			},
			glow = {
				image = "/images/ui/windows/targethud/circle_glow",
				size = {
					height = 45,
					width = 45
				}
			}
		},
		[CreatureType.Monster] = {
			size = {
				width = 200
			},
			frame = {
				image = "/images/ui/windows/targethud/circle_overlay",
				size = {
					height = 36,
					width = 36
				}
			},
			glow = {
				image = "/images/ui/windows/targethud/circle_glow",
				size = {
					height = 45,
					width = 45
				}
			}
		},
		[CreatureType.Boss] = {
			size = {
				width = 380
			},
			frame = {
				image = "/images/ui/windows/targethud/boss_frame",
				size = {
					height = 38,
					width = 43
				}
			},
			glow = {
				image = "/images/ui/windows/targethud/boss_glow",
				size = {
					height = 50,
					width = 55
				}
			}
		}
	}
}

function init()
	if modules.game_settings and not modules.game_settings.getOption("displayTargetHud") then
		addEvent(function()
			GameTargetHud:unload()
		end)

		return
	end

	g_ui.importStyle("targethud.otui")

	local hudPanel = modules.game_interface.getHUDPanel()

	GameTargetHud.window = g_ui.createWidget("TargetHudBarPanel", hudPanel)
	GameTargetHud.window.onDragEnter = onDragEnter
	GameTargetHud.window.onDragMove = onDragMove
	GameTargetHud.window.onDragLeave = onDragLeave
	GameTargetHud.content = GameTargetHud.window.content
	GameTargetHud.targetHudBar = GameTargetHud.content.targetHudBar

	function GameTargetHud.targetHudBar.onDestroy()
		GameTargetHud:disconnect(GameTargetHud.creature)
	end

	GameTargetHud.statusIcons = GameTargetHud.content.statusIcons
	GameTargetHud.aggroHolderHudBar = GameTargetHud.content.aggroHolderHudBar
	GameTargetHud.mainAggro = GameTargetHud.content.main_aggro
	GameTargetHud.highestAggro = GameTargetHud.content.highest_aggro

	GameTargetHud:hide()
	GameTargetHud:hideAggroUI()
	connect(g_game, {
		onGameEnd = GameTargetHud.onGameEnd,
		onAttackingCreatureChange = GameTargetHud.onAttackingCreatureChange
	})

	local target = g_game.getAttackingCreature()

	if target then
		GameTargetHud.onAttackingCreatureChange(target)
	end

	if g_game.isOnline() then
		g_layout.loadTargetHud()
		update()
	end
end

function terminate()
	disconnect(g_game, {
		onGameEnd = GameTargetHud.onGameEnd,
		onAttackingCreatureChange = GameTargetHud.onAttackingCreatureChange
	})
	GameTargetHud:disconnect()

	if GameTargetHud.window then
		GameTargetHud.window:destroy()

		GameTargetHud.window = nil
	end

	GameTargetHud.targetHudBar = nil
	GameTargetHud.statusIcons = nil
end

function GameTargetHud.onGameEnd()
	GameTargetHud:hide()
end

function GameTargetHud.onAttackingCreatureChange(creature, oldCreature)
	local self = GameTargetHud

	if self.creature then
		self:disconnect()
	end

	if not creature then
		self:hide()

		return
	elseif creature:isNpc() then
		return
	end

	self:connect(creature)
	self:show()
end

function GameTargetHud:connect(creature)
	if not creature then
		return
	end

	self.creature = creature

	local type = self:getCreatureType(creature)
	local config = self.configs[type]

	self.targetHudBar:setWidth(config.size.width)
	self.targetHudBar:setFrameTexture(config.frame, config.glow)
	self.targetHudBar:setPortrait(creature)
	self.targetHudBar:setName(creature:getName())
	self.targetHudBar:setPercent(creature:getHealthPercent())

	if creature:isBoss() then
		self.targetHudBar:setIconTexture(MonsterIconPaths[HealthBarBoss])
	elseif creature:isMonster() and creature:getIcon() ~= 0 then
		self.targetHudBar:setIconTexture(creature:getIconTexturePath())
	elseif creature:isPlayer() and creature:getSkull() ~= 0 then
		self.targetHudBar:setIconTexture(creature:getSkullTexturePath())
	else
		self.targetHudBar:setIconTexture("")
	end

	local statusIcons = creature:getStatusIcons()

	for icon, state in pairs(statusIcons) do
		if state then
			self.onAddStatusIcon(creature, icon, StatusImages[icon])

			local text = creature:getStatusIconText(icon)

			if text then
				self.onSetStatusIconText(creature, icon, text)
			end
		else
			self.onRemoveStatusIcon(creature, icon)
		end
	end

	connect(creature, {
		onHealthPercentChange = self.onHealthPercentChange,
		onIconTextureChange = self.onIconTextureChange,
		onSkullTextureChange = self.onSkullTextureChange,
		onSkullChange = self.onSkullChange,
		onIconChange = self.onIconChange,
		onAddStatusIcon = self.onAddStatusIcon,
		onRemoveStatusIcon = self.onRemoveStatusIcon,
		onSetStatusIconText = self.onSetStatusIconText,
		onTargetChange = self.onTargetChange,
		onAggroChange = self.onAggroChange,
		onTauntChange = self.onTauntChange,
		onDeath = self.onDeath
	})
	self.targetHudBar:show()
	self:updateAggroHolderHud()
	self.onAggroChange()
end

function GameTargetHud:disconnect()
	if not self.creature then
		return
	end

	if self.targetHudBar then
		self.targetHudBar:setName("")
	end

	if self.statusIcons then
		self.statusIcons:clearChildren()
	end

	disconnect(self.creature, {
		onHealthPercentChange = self.onHealthPercentChange,
		onIconTextureChange = self.onIconTextureChange,
		onSkullTextureChange = self.onSkullTextureChange,
		onSkullChange = self.onSkullChange,
		onIconChange = self.onIconChange,
		onAddStatusIcon = self.onAddStatusIcon,
		onRemoveStatusIcon = self.onRemoveStatusIcon,
		onSetStatusIconText = self.onSetStatusIconText,
		onTargetChange = self.onTargetChange,
		onAggroChange = self.onAggroChange,
		onDeath = self.onDeath
	})

	self.creature = nil

	self:updateAggroHolderHud()
end

function GameTargetHud:getCreatureType(creature)
	if creature:isPlayer() then
		return CreatureType.Player
	elseif creature:isBoss() then
		return CreatureType.Boss
	end

	return CreatureType.Monster
end

function GameTargetHud.onHealthPercentChange(creature, healthPercent)
	local self = GameTargetHud

	self.targetHudBar:setPercent(healthPercent)
end

function GameTargetHud.onAddStatusIcon(creature, icon, imagePath)
	local self = GameTargetHud
	local iconWidget = self.statusIcons:getChildById("icon" .. icon)

	if iconWidget then
		return
	end

	iconWidget = g_ui.createWidget("TargetHudStatusIcon", self.statusIcons)

	iconWidget:setId("icon" .. icon)
	iconWidget.icon:setImageSource(imagePath)
end

function GameTargetHud.onRemoveStatusIcon(creature, icon)
	local self = GameTargetHud
	local iconWidget = self.statusIcons:getChildById("icon" .. icon)

	if iconWidget then
		iconWidget:destroy()
	end
end

function GameTargetHud.onSetStatusIconText(creature, icon, text)
	local self = GameTargetHud
	local iconWidget = self.statusIcons:getChildById("icon" .. icon)

	if iconWidget then
		local font = g_hud.getGameFontName(HudGameFonts.FontStatusIcon)

		iconWidget.text:setFont(font)
		iconWidget.text:setText(text)
	else
		g_logger.warning("No icon widget found for icon " .. icon)
	end
end

function GameTargetHud.onIconTextureChange(creature, texturePath)
	local self = GameTargetHud

	if creature:isMonster() and not creature:isBoss() then
		self.targetHudBar:setIconTexture(texturePath)
	end
end

function GameTargetHud.onIconChange(creature, icon, oldIcon)
	local self = GameTargetHud

	if creature:isMonster() and not creature:isBoss() then
		if icon > 0 then
			self.targetHudBar:setIconTexture(creature:getIconTexturePath())
		else
			self.targetHudBar:setIconTexture("")
		end
	end
end

function GameTargetHud.onSkullTextureChange(creature, texturePath)
	local self = GameTargetHud

	if creature:isPlayer() then
		self.targetHudBar:setIconTexture(texturePath)
	end
end

function GameTargetHud.onSkullChange(creature, skull, oldSkull)
	local self = GameTargetHud

	if creature:isPlayer() then
		if skull > 0 then
			self.targetHudBar:setIconTexture(creature:getSkullTexturePath())
		else
			self.targetHudBar:setIconTexture("")
		end
	end
end

function GameTargetHud:onUpdateAggroFeature()
	self:updateAggroHolderHud()

	if not g_game.getFeature(GameShowAggro) then
		self:hideAggroUI()
	else
		self.onAggroChange()
	end
end

function GameTargetHud:hideAggroUI()
	self.mainAggro:hide()
	self.highestAggro:hide()
	self.targetHudBar.frame_glow_overlay:hide()
end

function GameTargetHud:showAggroUI()
	self.mainAggro:show()
	self.highestAggro:show()
	self.targetHudBar.frame_glow_overlay:show()
end

function GameTargetHud.onTargetChange(creature, targetId, oldTargetId)
	GameTargetHud:updateAggroHolderHud()
end

function GameTargetHud.onAggroChange(creature, aggro, targetAggro, highestAggro)
	if not g_game.getFeature(GameShowAggro) then
		return
	end

	local self = GameTargetHud

	if not self.creature then
		return
	end

	if not aggro then
		aggro, targetAggro, highestAggro = self.creature:getAggroInfo()
	end

	local mainAggroColor
	local isTarget = self.aggroHolder and self.aggroHolder:isLocalPlayer()
	local isTaunted = self.creature:isTaunted()

	if isTarget or isTaunted then
		mainAggroColor = self:getAggroColor(0, isTarget, false, isTaunted)
	end

	if highestAggro and highestAggro > 0 then
		local aggroPercent = math.min(999, targetAggro > 0 and aggro / targetAggro * 100 or 0)
		local highestAggroPercent = math.min(999, targetAggro > 0 and highestAggro / targetAggro * 100 or 0)

		mainAggroColor = mainAggroColor or self:getAggroColor(aggroPercent, isTarget, aggro == highestAggro, isTaunted)

		local highestAggroColor = self:getAggroColor(highestAggroPercent, isTaunted, true, isTaunted)

		self.mainAggro.value:setText(string.format("%s%d%%", aggroPercent == 999 and "+" or "", aggroPercent))
		self.mainAggro.glow:setImageColor(mainAggroColor)
		self.highestAggro.value:setText(string.format("%s%d%%", aggroPercent == 999 and "+" or "", highestAggroPercent))
		self.highestAggro.glow:setImageColor(highestAggroColor)
		self.mainAggro:setVisible(true)
		self.highestAggro:setVisible(true)
	else
		self.mainAggro:setVisible(false)
		self.highestAggro:setVisible(false)
	end

	if mainAggroColor then
		self.targetHudBar:setFrameColor(mainAggroColor)
		self.targetHudBar.frame_glow_overlay:setVisible(true)
	else
		self.targetHudBar.frame_glow_overlay:setVisible(false)
	end
end

function GameTargetHud:getAggroColor(aggroPercent, isAggroHolder, isHighestAggro, taunted)
	return modules.game_battle.BattleList:getAggroColor(aggroPercent, isAggroHolder, isHighestAggro, taunted)
end

function GameTargetHud.onTauntChange(creature)
	local self = GameTargetHud

	if not self.creature then
		return
	end

	self.onAggroChange()
end

function GameTargetHud.onDeath(creature)
	local self = GameTargetHud

	self:disconnect()
	self:hide()
end

function GameTargetHud:updateAggroHolderHud()
	if self.aggroHolder then
		self:disconnectAggroHolder()
	end

	if not g_game.getFeature(GameShowAggro) then
		self.aggroHolderHudBar:hide()

		return
	end

	if not self.creature then
		self.aggroHolderHudBar:hide()

		return
	end

	local aggroHolderId = self.creature:getAttackingCreatureId()

	if aggroHolderId == 0 then
		self.aggroHolderHudBar:hide()

		return
	end

	local aggroHolder = g_map.getCreatureById(aggroHolderId)

	if not aggroHolder then
		self.aggroHolderHudBar:hide()

		return
	end

	if aggroHolder:isRemoved() or aggroHolder:isDead() then
		self.aggroHolderHudBar:hide()

		return
	end

	self.aggroHolder = aggroHolder

	self.aggroHolderHudBar.name:setText(aggroHolder:getName())
	self.aggroHolderHudBar.health:setPercentage(aggroHolder:getHealthPercent(), 100)
	self.aggroHolderHudBar:show()
	self:connectAggroHolder()
end

function GameTargetHud:connectAggroHolder()
	if not self.aggroHolder then
		return
	end

	connect(self.aggroHolder, {
		onHealthPercentChange = self.onAggroHolderHealthPercentChange,
		onDeath = self.onAggroHolderDeath
	})
end

function GameTargetHud:disconnectAggroHolder()
	if not self.aggroHolder then
		return
	end

	disconnect(self.aggroHolder, {
		onHealthPercentChange = self.onAggroHolderHealthPercentChange,
		onDeath = self.onAggroHolderDeath
	})

	self.aggroHolder = nil
end

function GameTargetHud.onAggroHolderHealthPercentChange(creature, healthPercent)
	local self = GameTargetHud

	self.aggroHolderHudBar.health:setPercentage(healthPercent, 100)
end

function GameTargetHud.onAggroHolderDeath(creature)
	local self = GameTargetHud

	self:updateAggroHolderHud()
end

function GameTargetHud:show()
	self.window:show()
	self.window:raise()
end

function GameTargetHud:hide()
	self.window:hide()
end

function GameTargetHud:unload()
	local module = g_modules.getModule("game_targethud")

	if module then
		module:unload()
	end
end

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

function onDragMove(self, mousePos, mouseMoved)
	local pos = {
		x = mousePos.x - self.movingReference.x,
		y = mousePos.y - self.movingReference.y
	}

	g_layout.snapToGrid(pos)
	self:setPosition(pos)
	self:bindRectToParent()
end

function onDragLeave(self, droppedWidget, mousePos)
	if not g_layout.isEditMode() then
		return true
	end

	g_layout.save()

	return true
end

function update()
	local window = GameTargetHud.window

	if not window then
		return
	end

	local isEditMode = g_layout.isEditMode()
	local visible = window:isVisible()

	if isEditMode and not visible then
		window:show()

		GameTargetHud.hideWindowOnEditModeOff = true
	elseif not isEditMode and GameTargetHud.hideWindowOnEditModeOff then
		if not GameTargetHud.creature then
			window:hide()
		end

		GameTargetHud.hideWindowOnEditModeOff = false
	end

	local editModePanel = GameTargetHud.window:recursiveGetChildById("editModeBackground")

	editModePanel:setVisible(isEditMode)
	GameTargetHud.content:setPhantom(isEditMode)

	for _, child in pairs(GameTargetHud.content:getChildren()) do
		child:setPhantom(isEditMode)
	end
end
