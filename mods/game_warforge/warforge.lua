-- chunkname: @/modules/game_warforge/warforge.lua

GameWarforge = {
	warforgedShardsAmount = 0
}

function GameWarforge:loadConfig()
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

function GameWarforge:init()
	self:loadConfig()
	g_ui.importStyle("styles/warforge.otui")
	g_ui.importStyle("styles/main.otui")

	self.window = g_ui.createWidget("GameWarforgeWindow", modules.game_interface.getHUDPanel())

	self.window:hide()

	self.item_slot = self.window.content.preview_panel.item
	self.preview_slot = self.window.content.preview_panel.preview
	self.info_panel = self.window.content.preview_panel.info
	self.options_panel = self.window.content.options_panel
	self.bottom_panel = self.window.content.bottom_panel
	self.warforge_button = self.bottom_panel.warforge_button
	self.item_stats_panel = self.window.content.item_stats_panel
	self.preview_stats_panel = self.window.content.preview_stats_panel
	self.item_stats_background = self.window.content.item_stats_background

	connect(LocalPlayer, {
		onPositionChange = GameWarforge.onPositionChange
	})
	connect(g_game, {
		onGameEnd = GameWarforge.onGameEnd,
		onProtocolItem = GameWarforge.onUpdatePreviewItem,
		onUpdateItem = GameWarforge.onItemChange,
		onAddItem = GameWarforge.onItemChange,
		onRemoveItem = GameWarforge.onItemChange
	})
	GameWarforge:setupDragAndDrop()
	ProtocolGame.registerExtendedOpcode(ExtendedIds.Warforge, GameWarforge.onExtendedOpcode, "game_warfoge")
end

function GameWarforge:terminate()
	self.window:destroy()
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.Warforge, "game_warfoge")
	disconnect(LocalPlayer, {
		onPositionChange = GameWarforge.onPositionChange
	})
	disconnect(g_game, {
		onGameEnd = GameWarforge.onGameEnd,
		onProtocolItem = GameWarforge.onUpdatePreviewItem,
		onUpdateItem = GameWarforge.onItemChange,
		onAddItem = GameWarforge.onItemChange,
		onRemoveItem = GameWarforge.onItemChange
	})

	GameWarforge = nil
end

function GameWarforge.onPositionChange(player, position)
	local self = GameWarforge

	if not self.window:isVisible() then
		return
	end

	if not self.open_position then
		return
	end

	if not Position.isInRange(position, self.open_position, 3, 3) then
		self:hide()
	end
end

function GameWarforge.onItemChange(container, slot, item)
	local self = GameWarforge

	if not self.window:isVisible() then
		return
	end

	if item:getId() == cfg.warforgeShardId then
		self:updateShardCount()

		return
	end

	local selectedItem = GameWarforge.item_slot.item:getItem()

	if not selectedItem then
		return
	end

	if selectedItem:getUUID() == item:getUUID() then
		self:removeItemFromSlot(self.item_slot.item)
	end
end

function GameWarforge:updateShardCount()
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	self.warforgedShardsAmount = player:getItemsCount(cfg.warforgeShardId)

	self:updateWarforgeCosts()
end

function GameWarforge.updateItems()
	local self = GameWarforge

	if not self.window:isVisible() then
		return
	end

	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	self.warforgedShardsAmount = player:getItemsCount(cfg.warforgeShardId)

	local selectedItem = GameWarforge.item_slot.item:getItem()

	if not selectedItem then
		return
	end

	local item = player:getItemByUUID(selectedItem:getUUID())

	if item then
		GameWarforge.item_slot.item:setItem(item)
		GameWarforge:updateStats(item, GameWarforge.item_slot)
		GameWarforge:requestUpgrade(true)
		GameWarforge:updateTopPanel()
	end
end

function GameWarforge.isEnabled()
	return not g_game.isAetherRiftChannel() and not g_game.isGuildWarsChannel()
end

function GameWarforge.toggle(mouseClick)
	if GameWarforge.window:isVisible() then
		GameWarforge.hide()
	else
		if g_game:isInCutsceneMode() or not GameWarforge.isEnabled() then
			return
		end

		GameWarforge:updateSelectedItems()
		GameWarforge.show()
	end
end

function GameWarforge.hide()
	GameWarforge.window:hide()
	GameWarforge:removeItemFromSlot(GameWarforge.item_slot.item)
end

function GameWarforge.show()
	GameWarforge.window:show()
	GameWarforge.window:raise()
end

function GameWarforge.isVisible()
	return GameWarforge.window:isVisible()
end

function GameWarforge.onGameEnd()
	GameWarforge.window:hide()
end

function GameWarforge:setupDragAndDrop()
	local function canDrop(widget, droppedWidget)
		local item_slot = self.item_slot.item:getItem()
		local preview_slot = self.preview_slot.item:getItem()

		if not droppedWidget or droppedWidget:getClassName() ~= "UIItem" then
			return false
		end

		local droppedItem = droppedWidget:getItem()

		if (item_slot or preview_slot) and item_slot == droppedItem or preview_slot == droppedItem then
			return false
		end

		if not droppedItem:canBeWarforged() then
			return false
		end

		if droppedItem:isWarforged() then
			return false
		end

		if not droppedItem.container then
			GameNotification:display(NOTIFICATION_INFO, nil, "You can't warforge equipped items.")

			return false
		end

		return true
	end

	local function onDrop(widget, droppedWidget, mousePos)
		if not canDrop(widget, droppedWidget) then
			return false
		end

		local droppedItem = droppedWidget:getItem()

		if droppedItem then
			widget.item:setItem(droppedItem)

			if widget:getId() == "item" then
				g_sound.play(cfg.soundIds.placeItem)
			end
		end

		self:updateStats(droppedItem, widget)
		self:updateTopPanel()
		self:requestUpgrade(true)
	end

	local function onMousePress(widget)
		GameWarforge:removeItemFromSlot(widget)
	end

	connect(self.item_slot, {
		onDrop = onDrop
	})
	connect(self.item_slot.item, {
		onMousePress = onMousePress
	})
end

function GameWarforge:removeItemFromSlot(widget)
	local item = widget:getItem()

	if item then
		widget:setItem(nil)

		local parent = widget:getParent()

		parent:setOn(false)
		self:updateStats(nil, parent)
		self:updateTopPanel()
		self:requestUpgrade(true)

		if parent:getParent() == self.slot_panel then
			self:updateStats(nil, self.preview_slot)
			self.preview_slot.item:setItem(nil)
			self:updateTopPanel({})
		end
	end
end

function GameWarforge.onExtendedOpcode(protocol, opcode, buffer)
	local self = GameWarforge

	if opcode ~= ExtendedIds.Warforge then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if not data or type(data) ~= "table" then
		return
	end

	if data.success == false then
		self:updateTopPanel()

		return
	end

	if data.action == "open_warforge_window" then
		if self.window:isVisible() then
			return
		end

		self.open_position = data.position

		self:updateShardCount()
		self:updateTopPanel()
		self:resetWarforgeCostsInfo()
		self:show()
	elseif data.action == "preview" then
		self.awaitingUUID = data.preview_uuid

		if data.costs then
			self:updateWarforgeCostsInfo(data.costs, data.hasGuildCharge)
		end
	elseif data.action == "reset" then
		self:removeItemFromSlot(self.item_slot.item)
		self:updateTopPanel()
		self:resetWarforgeCostsInfo()
	elseif data.action == "close" then
		self:hide()
	end
end

function GameWarforge.sendOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.Warforge, g_game.serializeTable(data))
	end
end

function GameWarforge:requestUpgrade(preview)
	self:requestWarforge(preview)
end

function GameWarforge:requestWarforge(preview)
	local item = self.item_slot.item:getItem()

	if not item then
		self:updateWarforgeButton()

		return
	end

	if self.confirmation_box then
		self.confirmation_box:destroy()

		self.confirmation_box = nil
	end

	local costData = self:getWarforgeSelectedCostData()

	if not preview and not costData then
		return
	end

	local function warforgeUpgrade()
		if self.confirmation_box then
			self.confirmation_box:destroy()

			self.confirmation_box = nil
		end

		if preview then
			GameWarforge.sendOpcode({
				action = "preview",
				itemSource = item:getUUID()
			})
		else
			GameWarforge.sendOpcode({
				action = "upgrade",
				itemSource = item:getUUID(),
				option = costData.option
			})
		end

		self:updateWarforgeButton()
	end

	local function cancel()
		if self.confirmation_box then
			self.confirmation_box:destroy()

			self.confirmation_box = nil
		end

		self:updateWarforgeButton()
	end

	if not preview then
		local msg = ""

		if costData.option == "charge" then
			msg = tr(string.format("Warforging has a cost of |%s| silver and |%d| Warforging Shards, to be deducted from your inventory. Warforging a weapon will consume a Warforging Charge at the Ravencrest forge or your Fort's forge. Do you wish to Warforge your weapon?", FormatCommaNumber(costData.silver), costData.shards))
		else
			msg = tr(string.format("Warforging has a cost of |%s| silver and |%d| Warforging Shards, to be deducted from your inventory. Do you wish to Warforge your weapon?", FormatCommaNumber(costData.silver), costData.shards))
		end

		self.confirmation_box = displayConfirmCheckBox(tr("Warforging Weapons"), msg, {
			{
				text = tr("Yes"),
				callback = warforgeUpgrade
			},
			{
				text = tr("No"),
				callback = cancel
			},
			anchor = AnchorHorizontalCenter
		}, warforgeUpgrade, cancel, nil, modules.game_interface.getRootPanel())
	else
		warforgeUpgrade()
	end

	self:updateWarforgeButton()
end

function GameWarforge:updateTopPanel(data)
	if self.confirmation_box then
		self.confirmation_box:destroy()

		self.confirmation_box = nil
	end

	local item = self.item_slot.item:getItem()

	if item then
		self.info_panel.arrow:setOn(true)

		local skillsIds = cfg.weaponTypeToSkillsIds[item:getItemType()]

		if skillsIds then
			local normalAbility = g_spells.spells[skillsIds[1]]

			self.item_slot.skill.icon:setImageSource("/images/ui/icons/abilitybar/" .. normalAbility.name:lower())

			self.item_slot.skill.icon.abilityTooltip = true
			self.item_slot.skill.icon.abilityId = normalAbility.name:lower()

			self.item_slot.skill.icon:show()

			local previewAbility = g_spells.spells[skillsIds[2]]

			self.preview_slot.skill.icon:setImageSource("/images/ui/icons/abilitybar/" .. previewAbility.name:lower())

			self.preview_slot.skill.icon.abilityTooltip = true
			self.preview_slot.skill.icon.abilityId = previewAbility.name:lower()

			self.preview_slot.skill.icon:show()
		end
	else
		self.info_panel.arrow:setOn(false)
		self:resetWarforgeCostsInfo()
		self.item_slot.skill.icon:hide()
		self.preview_slot.skill.icon:hide()
	end

	self:updateWarforgeButton()
end

function GameWarforge:updateStats(item, widget)
	local height = 20
	local background = self.item_stats_background
	local panel = widget == self.item_slot and self.item_stats_panel or widget == self.preview_slot and self.preview_stats_panel or nil

	if panel then
		panel.itemStats = {}

		panel:setVisible(item ~= nil)
		panel:destroyChildren()

		if item then
			local function getDiffValue(stat1, stat2)
				local diffValue = 0

				if panel == self.preview_stats_panel then
					diffValue = math.max(0, stat2 - (self.item_stats_panel.itemStats[stat1] or 0))
				else
					panel.itemStats[stat1] = stat2
				end

				return diffValue
			end

			local tier = item:getTier()
			local grade = item:getGrade()
			local itemTypeRaw = item:getItemType()
			local isFishingRod = itemTypeRaw == "fishing rod"
			local isFishingHook = itemTypeRaw == "fishing hook"
			local fishingDurability = isFishingRod and FishingStats.durabilityTable[tier][grade + 1] or 0
			local baseAttributes

			if self.currentMode == "infusion" then
				baseAttributes = {
					{
						"Attack",
						item:getAttack(),
						"#5DA4FB"
					},
					{
						"Defense",
						item:getDefense(),
						"#5DA4FB"
					},
					{
						"Healing Power",
						item:getHealing(),
						"#5DA4FB"
					},
					{
						"Labor",
						item:getLabor(),
						"#FFA851"
					},
					{
						"Durability",
						fishingDurability,
						"#FFA851"
					}
				}
			else
				baseAttributes = {
					{
						"Attack",
						item:getAttack(),
						"#5DA4FB"
					},
					{
						"Defense",
						item:getDefense(),
						"#5DA4FB"
					}
				}
			end

			local showDiff = panel == self.preview_stats_panel

			for _, stat in ipairs(baseAttributes) do
				if stat[2] > 0 then
					local diffValue = getDiffValue(stat[1], stat[2])
					local child = g_ui.createWidget("GameWarforgeStatsPanelItem", panel)

					child:setColoredText(GetHighlightedText(string.format("%s [%i] {%s, %s}", stat[1], stat[2], diffValue > 0 and string.format("+%d", diffValue) or "", stat[3])))
					child:setImageColor(stat[3])

					height = height + panel:getLayout():getSpacing() + child:getHeight()
				end
			end

			for _, stat in ipairs(item:getPrimaryStats()) do
				local diffValue = getDiffValue(stats[stat[1]], stat[2])
				local child = g_ui.createWidget("GameWarforgeStatsPanelItem", panel)

				child:setColoredText(GetHighlightedText(string.format("%s [%i] {%s, #77D463}", stats[stat[1]], stat[2], diffValue > 0 and string.format("+%d", diffValue) or "")))

				height = height + panel:getLayout():getSpacing() + child:getHeight()
			end

			for _, stat in ipairs(item:getCombinedSecondaryStats()) do
				local diffValue = getDiffValue(stats[stat[1]], stat[2])
				local child = g_ui.createWidget("GameWarforgeStatsPanelItem", panel)

				child:setColoredText(GetHighlightedText(string.format("%s [%i] {%s, #77D463}", stats[stat[1]], stat[2], diffValue > 0 and string.format("+%d", diffValue) or "")))

				height = height + panel:getLayout():getSpacing() + child:getHeight()
			end

			for _, stat in ipairs(item:getCraftingStats()) do
				local diffValue = getDiffValue(stats[stat[1]], stat[2])
				local child = g_ui.createWidget("GameWarforgeStatsPanelItem", panel)

				child:setColoredText(GetHighlightedText(string.format("%s [%i] {%s, #77D463}", craftingStats[stat[1]], stat[2], diffValue > 0 and string.format("+%d", diffValue) or "")))

				height = height + panel:getLayout():getSpacing() + child:getHeight()
			end

			local fishingAbilityBonus = (isFishingHook or isFishingRod) and FishingStats.abilityBonusTable[tier][grade + 1] or 0

			if fishingAbilityBonus > 0 then
				local diffValue = getDiffValue("Ability Bonus", fishingAbilityBonus)
				local child = g_ui.createWidget("GameWarforgeStatsPanelItem", panel)

				child:setColoredText(GetHighlightedText(string.format("%s [%i] {%s, #77D463}", "Ability Bonus", fishingAbilityBonus, diffValue > 0 and string.format("+%d", diffValue) or "")))

				height = height + panel:getLayout():getSpacing() + child:getHeight()
			end

			if table.empty(panel:getChildren()) then
				local child = g_ui.createWidget("GameWarforgeStatsPanelItem", panel)

				child:setText("No attributes")
				child:disable()
			end

			background:setHeight(height)
		end
	end

	self.item_stats_background:setOn(self.item_stats_panel:isVisible() or self.preview_stats_panel:isVisible())

	if widget == self.item_slot then
		self.preview_slot.item:setItem(nil)
		self.preview_stats_panel:setOn(false)
		self:updateStats(nil, self.preview_slot)
	end
end

function GameWarforge.onUpdatePreviewItem(item)
	if not item or item:getUUID() ~= GameWarforge.awaitingUUID then
		return
	end

	GameWarforge.preview_slot.item:setItem(item)
	GameWarforge:updateStats(item, GameWarforge.preview_slot)
	GameWarforge:updateTopPanel()
end

function GameWarforge:updateWarforgeButton()
	if not self.item_slot.item:getItem() then
		self.warforge_button:setEnabled(false)

		return
	end

	if self.confirmation_box then
		self.warforge_button:setEnabled(false)

		return
	end

	for _, option in ipairs(self.options_panel:getChildren()) do
		if option:isOn() then
			self.warforge_button:setEnabled(true)

			return
		end
	end

	self.warforge_button:setEnabled(false)
end

function GameWarforge:resetWarforgeCostsInfo()
	local normal_option = self.options_panel.normal_option

	normal_option:setOn(false)

	normal_option.costData = nil

	local charge_option = self.options_panel.charge_option

	charge_option:setOn(false)

	charge_option.costData = nil

	self:updateWarforgeCosts()
end

function GameWarforge:updateWarforgeCostsInfo(costs, hasGuildCharge)
	if self.confirmation_box then
		self.confirmation_box:destroy()

		self.confirmation_box = nil
	end

	local normal_option = self.options_panel.normal_option

	if not costs.normal then
		normal_option.costData = nil
	else
		normal_option.costData = costs.normal
		normal_option.costData.option = "normal"
	end

	local charge_option = self.options_panel.charge_option

	if not costs.charge then
		charge_option.costData = nil
	else
		charge_option.costData = costs.charge
		charge_option.costData.option = "charge"
		charge_option.costData.hasCharge = hasGuildCharge
	end

	self:updateWarforgeCosts()
end

function GameWarforge:updateWarforgeCosts()
	local shardsAmount = self.warforgedShardsAmount
	local normal_option = self.options_panel.normal_option
	local normalCostData = normal_option.costData

	if normalCostData then
		normal_option.amounts:setText(string.format("%d/%d", shardsAmount, normalCostData.shards))
		normal_option.cost:setText(string.format("-%s", FormatCommaNumber(normalCostData.silver)))
		normal_option.cost:setVisible(normalCostData.silver > 0)
		normal_option.free:setVisible(normalCostData.silver <= 0)

		if shardsAmount < normalCostData.shards then
			if normal_option:isOn() and self.confirmation_box then
				self.confirmation_box:destroy()

				self.confirmation_box = nil
			end

			normal_option:setEnabled(false)
		else
			normal_option:setEnabled(true)
		end
	else
		normal_option.amounts:setText(string.format("%d/X", shardsAmount))
		normal_option.cost:setText("-")
		normal_option.cost:setVisible(true)
		normal_option.free:setVisible(false)
		normal_option:setEnabled(false)
	end

	local charge_option = self.options_panel.charge_option
	local chargeCostData = charge_option.costData

	if chargeCostData then
		charge_option.amounts:setText(string.format("%d/%d", shardsAmount, chargeCostData.shards))
		charge_option.cost:setText(string.format("-%s", FormatCommaNumber(chargeCostData.silver)))
		charge_option.cost:setVisible(chargeCostData.silver > 0)
		charge_option.free:setVisible(chargeCostData.silver <= 0)

		if shardsAmount < chargeCostData.shards or not chargeCostData.hasCharge then
			if charge_option:isOn() and self.confirmation_box then
				self.confirmation_box:destroy()

				self.confirmation_box = nil
			end

			charge_option:setEnabled(false)
		else
			charge_option:setEnabled(true)
		end
	else
		charge_option.amounts:setText(string.format("%d/X", shardsAmount))
		charge_option.cost:setText("-")
		charge_option.cost:setVisible(true)
		charge_option.free:setVisible(false)
		charge_option:setEnabled(false)
	end

	local selectedCostData = self:getWarforgeSelectedCostData()

	if not selectedCostData then
		self.bottom_panel.silver:setText("-")
		self.bottom_panel.silver:setVisible(true)
		self.bottom_panel.free:setVisible(false)
	else
		self.bottom_panel.silver:setText(string.format("%s", FormatCommaNumber(selectedCostData.silver)))
		self.bottom_panel.silver:setVisible(selectedCostData.silver > 0)
		self.bottom_panel.free:setVisible(selectedCostData.silver <= 0)
	end

	self:updateWarforgeButton()
end

function GameWarforge:getWarforgeSelectedCostData()
	local normal_option = self.options_panel.normal_option
	local charge_option = self.options_panel.charge_option

	if normal_option:isOn() then
		return normal_option.costData
	end

	if charge_option:isOn() then
		return charge_option.costData
	end

	return nil
end

function GameWarforge:selectWarforgeOption(widget)
	local normal_option = self.options_panel.normal_option
	local charge_option = self.options_panel.charge_option

	widget = widget or normal_option

	if widget:isOn() then
		return
	end

	if widget == normal_option then
		normal_option:setOn(true)
		charge_option:setOn(false)
	else
		normal_option:setOn(false)
		charge_option:setOn(true)
	end

	if self.confirmation_box then
		self.confirmation_box:destroy()

		self.confirmation_box = nil
	end

	self:updateWarforgeCosts()
	self:updateWarforgeButton()
end
