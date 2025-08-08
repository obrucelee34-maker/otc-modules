-- chunkname: @/modules/game_profession/opcode.lua

STABLE_STATE_IDLE = 0
STABLE_STATE_BREEDING = 1
STABLE_STATE_HATCHING = 2
STABLE_STATE_MATURING = 3

local landInteractionHotkeyIds = {
	HOTKEYS_IDS.LAND_INTERACTION_1,
	HOTKEYS_IDS.LAND_INTERACTION_2,
	HOTKEYS_IDS.LAND_INTERACTION_3,
	HOTKEYS_IDS.LAND_INTERACTION_4
}
local confirmationWindow

function initOpcode()
	ProtocolGame.registerExtendedOpcode(ExtendedIds.Professions, onExtendedOpcode)
	ProtocolGame.registerExtendedOpcode(ExtendedIds.Crafting, onCraftingOpcode)
end

function terminateOpcode()
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.Professions)
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.Crafting)

	local mountSelectionPanel = modules.game_interface.getHUDPanel():getChildById("mountSelectionPanel")

	if mountSelectionPanel then
		mountSelectionPanel:destroy()
	end

	if confirmationWindow then
		confirmationWindow:destroy()

		confirmationWindow = nil
	end
end

function getLandInteractionPanel()
	local HUDPanel = modules.game_interface.getHUDPanel()

	return HUDPanel and HUDPanel.landInteractionPanel
end

function onLandInteractionHotkeyPressed(hotkeyId)
	local landInteractionPanel = getLandInteractionPanel()

	if not landInteractionPanel then
		return
	end

	for _, widget in pairs(landInteractionPanel:getChildren()) do
		if widget.hotkeyId and widget.hotkeyId == hotkeyId then
			if widget.item then
				widget.item.onClick()
			end

			return
		end
	end
end

local function updateHotkey(hotkeyId, keyCombo, force)
	local landInteractionPanel = getLandInteractionPanel()

	if not landInteractionPanel then
		return
	end

	for _, widget in pairs(landInteractionPanel:getChildren()) do
		if widget.hotkeyId and (hotkeyId == -1 or widget.hotkeyId == hotkeyId) then
			widget.hotkey:setText(keyCombo or "")
		end
	end
end

local function destroyInteractionPanel()
	local HUDPanel = modules.game_interface.getHUDPanel()

	if HUDPanel.landInteractionPanel then
		HUDPanel.landInteractionPanel:destroyChildren()
		HUDPanel.landInteractionPanel:destroy()

		HUDPanel.landInteractionPanel = nil
	end
end

function onExtendedOpcode(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.Professions or buffer == "" then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		return
	end

	if data.action == "breeding_select_action" then
		onSelectBreedingAction(data)
	elseif data.action == "husbandry_select_action" or data.action == "farming_select_action" then
		local isHusbandry = data.action == "husbandry_select_action"

		if not data.options.gathering and not data.options.butchering and not data.options.affection and not data.options.feeding then
			return
		end

		local config = {
			{
				title = "Gathering",
				text = "Gather materials.",
				detailed_text = "Gather materials. This action can be performed multiple times, but will permanently block the Butchering option.",
				info = {
					{
						text = "Material to collect: ",
						value = function(value)
							return value
						end
					}
				},
				data = data.options.gathering
			},
			{
				blocked_text = "The selected animal has been raised for gathering. This option has become locked.",
				title = "Butchering",
				text = "Butcher for materials.",
				info = {
					{
						text = "Material to collect: ",
						value = function(value)
							return value
						end
					}
				},
				data = data.options.butchering
			},
			{
				text = "You can interact to increase the fertilizer drop rate.",
				title = "Affection",
				info = {
					{
						text = "Current affection bonus: ",
						value = function(value)
							return value
						end
					}
				},
				data = data.options.affection
			},
			{
				title = "Feeding",
				text = "This will be implemented on next alpha phase.",
				disabled = true,
				info = {
					{
						text = "Current feed bonus: ",
						value = function(value)
							return value
						end
					}
				},
				data = data.options.feeding
			},
			{
				text = "You can fertilize to increase the collected material.",
				title = "Fertilizer",
				info = {
					{
						text = "Current fertilize bonus: ",
						value = function(value)
							return value
						end
					}
				},
				data = data.options.fertilizer
			},
			{
				text = "You can water to increase the four leaf clover drop rate.",
				title = "Watering",
				info = {
					{
						text = "Current water bonus: ",
						value = function(value)
							return value
						end
					}
				},
				data = data.options.watering
			},
			{
				text = "You can prune to increase the dense log drop rate.",
				title = "Pruning",
				info = {
					{
						text = "Current pruning bonus: ",
						value = function(value)
							return value
						end
					}
				},
				data = data.options.pruning
			}
		}
		local widgets = {}

		for _, widgetCfg in ipairs(config) do
			if type(widgetCfg.data) == "table" then
				table.insert(widgets, widgetCfg)
			end
		end

		local HUDPanel = modules.game_interface.getHUDPanel()
		local gameMapPanel = modules.game_interface.getMapPanel()

		if HUDPanel.landInteractionPanel then
			destroyInteractionPanel()

			return
		end

		local interactionPanel = g_ui.createWidget(string.format("GameHouseInteractionWindow%d", table.size(widgets)), HUDPanel)

		if not interactionPanel then
			return
		end

		connect(LocalPlayer, {
			onPositionChange = destroyInteractionPanel
		})
		connect(GameHotkeyManager, {
			onHotkeyUpdate = updateHotkey
		})

		function interactionPanel:onDestroy()
			if self.timeEvent then
				removeEvent(self.timeEvent)

				self.timeEvent = nil
			end

			modules.game_interface.g_actionKey.show()
			disconnect(LocalPlayer, {
				onPositionChange = destroyInteractionPanel
			})
			disconnect(GameHotkeyManager, {
				onHotkeyUpdate = updateHotkey
			})
			signalcall(GameProfessions.onGatheringMenuClose)
		end

		modules.game_interface.g_actionKey.hide()

		interactionPanel.exitButton.onClick = destroyInteractionPanel
		interactionPanel.onEscape = destroyInteractionPanel

		function interactionPanel.timerJob()
			if interactionPanel.timeEvent then
				removeEvent(interactionPanel.timeEvent)

				interactionPanel.timeEvent = nil
			end

			for _, widget in pairs(interactionPanel:getChildren()) do
				if widget and widget.isGathering and widget.timeLeft then
					widget.item:setOn(widget.timeLeft <= 0)
					widget.item:setEnabled(widget.timeLeft <= 0)
					widget.label:setVisible(false)

					if widget.timeLeft > 0 then
						widget.timeLeft = widget.timeLeft - 1
					end
				end
			end

			interactionPanel.timeEvent = scheduleEvent(interactionPanel.timerJob, 1000)
		end

		local offset = {
			y = 0,
			x = 0
		}

		if data.options.name and string.find(data.options.name:lower(), "medium") then
			offset = {
				y = -58,
				x = -44
			}
		end

		local pos = modules.game_interface.getMapPanel():transformPositionTo2D(data.widgetPos or data.position)

		interactionPanel:move(pos.x + offset.x - interactionPanel:getWidth() / 2, pos.y + offset.y - interactionPanel:getHeight() / 2)

		for index, widgetCfg in ipairs(widgets) do
			local id, option = widgetCfg.title:lower(), widgetCfg.data

			if type(option) == "table" then
				local gatheringWidget = interactionPanel:getChildById("widget" .. index)

				gatheringWidget:setId(id .. "Widget")

				gatheringWidget.isGathering = true

				gatheringWidget.item:setImageSource("/images/ui/icons/circle_" .. (id == "gathering" and "blue" or "red"))

				if option.blocked then
					gatheringWidget.item:setOn(false)
					gatheringWidget.item:setEnabled(false)
					gatheringWidget.item:setCanHoverWhenDisabled(true)
					gatheringWidget.lock:setVisible(true)
				else
					gatheringWidget.timeLeft = option.timeLeft

					gatheringWidget.item:setOn(option.timeLeft > 0)
					gatheringWidget.item:setCanHoverWhenDisabled(false)
					gatheringWidget.lock:setVisible(false)
				end

				local items = option.items and option.items[1] or option and option[1]
				local clientId = items and items.clientId

				if clientId then
					gatheringWidget.item:setItemId(clientId)
				else
					gatheringWidget.item.icon:setImageSource("/images/ui/icons/" .. id)
				end

				gatheringWidget.item:setTitle(widgetCfg.title)

				gatheringWidget.item.tooltipAdvInfo = widgetCfg.info
				gatheringWidget.item.tooltip = option.detailed and widgetCfg.detailed_text or option.blocked and widgetCfg.blocked_text or widgetCfg.text

				gatheringWidget.progress:setCircle(true)

				if widgetCfg.text then
					function gatheringWidget.item.onHoverChange(widget, hovered)
						g_tooltip.onWidgetHoverChange(widget, hovered)
					end

					connect(gatheringWidget, {
						onDestroy = function(widget)
							if g_tooltip.getCurrentHoveredWidget() == widget.item then
								g_tooltip.hide()
							end
						end
					})
				end

				local time = option.timeLeft

				if time and time > 0 then
					gatheringWidget.progress:onSpellCooldown(option.time * 1000, nil, nil, time * 1000)
				end

				if not option.blocked then
					if option.stacks then
						gatheringWidget.label:setText(string.format("+%d%%", option.valuePerStack * 100 * option.stacks))
						gatheringWidget.item:setAdvancedTooltip(widgetCfg.info, gatheringWidget.label:getText(), "#e7b131")
					elseif widgetCfg.info then
						local info = table.copy(widgetCfg.info)

						option.items = option.items or option

						for _, item in ipairs(option.items) do
							table.insert(info, {
								text = info[1].text,
								value = function()
									return (type(item.amount) == "table" and string.format("%d-%d", unpack(item.amount)) or "0-" .. item.amount) .. " " .. item.name:titleCase()
								end
							})
						end

						table.remove(info, 1)
						gatheringWidget.item:setAdvancedTooltip(info, "", "#e7b131")
					end
				end

				gatheringWidget.clickSound = true

				function gatheringWidget.item.onClick()
					if not widgetCfg.disabled then
						interactionPanel:destroyChildren()
						interactionPanel:destroy()
						GameProfessions:sendOpcode({
							action = (isHusbandry and "husbandry_" or "farming_") .. id,
							position = data.position,
							itemId = data.itemId
						})
					end
				end

				gatheringWidget.hotkeyId = not option.blocked and landInteractionHotkeyIds[index]

				if gatheringWidget.hotkeyId then
					local keyCombo = GameHotkeyManager:getHotkeyMainKeyCombo(gatheringWidget.hotkeyId)

					if keyCombo then
						gatheringWidget.hotkey:setText(keyCombo)
						gatheringWidget.hotkey:setVisible(true)
					end
				else
					gatheringWidget.hotkey:setVisible(false)
				end

				g_effects.fadeIn(gatheringWidget, 250, 0, 0.9)
			end
		end

		interactionPanel.timerJob()
		signalcall(GameProfessions.onGatheringMenu, panel, isHusbandry and "husbandry" or "farming")
	elseif data.action == "passives" then
		GameProfessions:parseOpcode(data)
	elseif data.action == "caught_fish" then
		GameProfessions:parseOpcode(data)
	elseif data.action == "quests" then
		GameProfessions:setQuest(data)
	elseif data.action == "oversupply" then
		GameProfessions:updateCraftingWindowOversupply(data.oversupply)
	elseif data.action == "show_window" then
		GameProfessions:showCraftingWindow(data.professionId)
	elseif data.action == "progress_data" then
		GameProfessions:updateProgressData(data.professionId, data.progressData)
	end
end

function onCraftingOpcode(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.Crafting or buffer == "" then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		return
	end

	if data.action == "craft" then
		onCraft(data)
	end
end

function sendCraftingOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.Crafting, g_game.serializeTable(data))
	end
end

function sendCraftRequest(profession, index, qualities, amountToCraft, isQuest)
	sendCraftingOpcode({
		action = "craft",
		profession = profession,
		index = index,
		qualities = qualities,
		amountToCraft = amountToCraft,
		quest = isQuest
	})
end

function sendMinigameAbility(abilityId)
	sendCraftingOpcode({
		action = "craft",
		subaction = "input",
		ability = abilityId
	})
end

function sendCancelCraft()
	sendCraftingOpcode({
		subaction = "cancel",
		action = "craft"
	})
end

function onSelectBreedingAction(data)
	if g_game.isInHouseMode() then
		return
	end

	if data.subaction == "available_mounts" or data.subaction == "available_boosters" then
		return displayBreedingSelector(data)
	end

	local showDelay = 250
	local HUDPanel = modules.game_interface.getHUDPanel()
	local gameMapPanel = modules.game_interface.getMapPanel()

	if HUDPanel.landInteractionPanel then
		destroyInteractionPanel()

		return
	end

	local interactionPanel = g_ui.createWidget(string.format("GameHouseInteractionWindow%d", table.size(data.options)), HUDPanel)

	if not interactionPanel then
		return
	end

	connect(LocalPlayer, {
		onPositionChange = destroyInteractionPanel
	})

	function interactionPanel:onDestroy()
		if self.timeEvent then
			removeEvent(self.timeEvent)

			self.timeEvent = nil
		end

		modules.game_interface.g_actionKey.show()
		disconnect(LocalPlayer, {
			onPositionChange = destroyInteractionPanel
		})
	end

	local pos = gameMapPanel:transformPositionTo2D(data.position)

	interactionPanel:move(pos.x - interactionPanel:getWidth() / 2, pos.y - interactionPanel:getHeight() / 2)

	interactionPanel.exitButton.onClick = destroyInteractionPanel
	interactionPanel.onEscape = destroyInteractionPanel

	local function callback(widget, info)
		if table.find({
			STABLE_STATE_IDLE,
			STABLE_STATE_BREEDING,
			STABLE_STATE_HATCHING,
			STABLE_STATE_MATURING
		}, data.state) then
			function widget.item.onClick()
				GameProfessions:sendOpcode({
					action = info.action,
					subaction = info.subaction,
					position = data.position
				})
				destroyInteractionPanel()
			end
		end

		if data.canAddNeststring then
			addEvent(function()
				local widget1 = interactionPanel:getChildById("interationNestringWidget")
				local widget2 = interactionPanel:getChildById("neststringSeparator")

				if widget1 then
					widget1:setVisible(true)
				end

				if widget2 then
					widget2:setVisible(true)
				end

				for i = 1, 5 do
					local widget2 = interactionPanel:getChildById("AddNestringWidget" .. i)

					if widget2 then
						widget2:setVisible(true)
						widget2:setOn(false)

						function widget2.item:onDrop(widget, mousePos)
							local item = widget:isItem() and widget:getItem() or nil

							if item then
								GameProfessions:sendOpcode({
									action = "add_neststring",
									itemId = widget:getItem():getServerId(),
									quality = widget:getItem():getQuality(),
									position = data.position
								})
								destroyInteractionPanel()
							end

							return true
						end
					end
				end

				if data.neststrings then
					local i = 1

					for type, neststring in pairs(data.neststrings) do
						if neststring.clientId then
							local widget = interactionPanel:getChildById("AddNestringWidget" .. i)

							if widget then
								widget:setOn(true)
								widget.item:setItemId(neststring.clientId)
								widget.item:setTooltip(ITEMS[neststring.clientId].name)
								widget.item:getItem():setQuality(neststring.tier - 1)

								if QualityNames[neststring.tier - 1] then
									widget.item:getItem():setQualityName(QualityNames[neststring.tier - 1]:titleCase())
								end

								function widget.item.onClick()
									if widget.item:getItemId() > 0 then
										local function noCallback()
											if confirmationWindow then
												confirmationWindow:destroy()
											end
										end

										noCallback()

										local function yesCallback()
											noCallback()
											GameProfessions:sendOpcode({
												action = "remove_neststring",
												type = type,
												position = data.position
											})
											destroyInteractionPanel()
										end

										confirmationWindow = displayGeneralBox(tr("Remove Neststring"), tr(string.format("Are you sure you want to remove the neststring |%s|?", ITEMS[neststring.clientId].name)), {
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

									return true
								end
							end

							i = i + 1
						end
					end
				end
			end)
		end

		if table.find({
			STABLE_STATE_BREEDING,
			STABLE_STATE_HATCHING,
			STABLE_STATE_MATURING
		}, data.state) then
			widget.progress:setCircle(true)
			widget.progress:setPhantom(true)

			if info.timeLeft > 0 then
				widget.progress:onSpellCooldown(info.time * 1000, nil, nil, info.timeLeft * 1000)
			end

			info.timeLeft = info.timeLeft

			local function timerJob()
				widget.label:setText("")

				widget.timeEvent = scheduleEvent(function()
					local time = info.timeLeft

					if time > 0 then
						timerJob()
					else
						widget.timeEvent = nil

						widget.label:setText("")
					end
				end, 1000)
			end

			timerJob()
		end
	end

	for index, info in ipairs(data.options) do
		local widget = interactionPanel:getChildById("widget" .. index)

		widget:setId(info.action)
		widget.item:setOn(true)

		if info.icon then
			widget.item:setImageSource("/images/ui/windows/breeding/" .. info.icon)
		end

		g_effects.fadeIn(widget, showDelay, 0, 0.9)
		widget.label:setFont("myriad-pro-11")
		widget.label:setTextColor("white")

		function widget.onDestroy()
			if widget.timeEvent then
				removeEvent(widget.timeEvent)

				widget.timeEvent = nil
			end
		end

		local tooltip = {
			title = info.name,
			text = info.description,
			info = {}
		}

		if info.options then
			for _, option in ipairs(info.options) do
				table.insert(tooltip.info, {
					text = option.text,
					value = option.value and function()
						return option.value
					end
				})
			end
		end

		widget.item:setTitle(tooltip.title)

		widget.item.tooltip = tooltip.text

		widget.item:setAdvancedTooltip(tooltip.info, nil, "#e7b131")

		if tooltip.text then
			function widget.item.onHoverChange(widget, hovered)
				g_tooltip.onWidgetHoverChange(widget, hovered)
			end

			connect(widget, {
				onDestroy = function(widget)
					if g_tooltip.getCurrentHoveredWidget() == widget.item then
						g_tooltip.hide()
					end
				end
			})
		end

		widget.hotkeyId = landInteractionHotkeyIds[index]

		if widget.hotkeyId then
			local keyCombo = GameHotkeyManager:getHotkeyMainKeyCombo(widget.hotkeyId)

			if keyCombo then
				widget.hotkey:setText(keyCombo)
			end
		end

		callback(widget, info)
	end
end

function getBreedingSelectionPanel()
	local HUDPanel = modules.game_interface.getHUDPanel()

	return HUDPanel and HUDPanel:getChildById("landInteractionPanel")
end

function displayBreedingSelector(data)
	local HUDPanel = modules.game_interface.getHUDPanel()

	if HUDPanel.landInteractionPanel then
		destroyInteractionPanel()
	end

	connect(LocalPlayer, {
		onPositionChange = destroyInteractionPanel
	})

	local panel = g_ui.createWidget("BreedingSelectionWindow", HUDPanel)

	panel:setId("landInteractionPanel")

	panel.position = data.position

	local type = data.mounts and "mounts" or "items"

	if data.pagination then
		local paginationPanel = panel.contents.pagination_panel
		local pagination = data.pagination
		local total = data.total
		local paginationMax = #data.mounts
		local paginationEnd = total > pagination * 6 and pagination * 6 or total
		local paginationStart = (pagination - 1) * 6 + 1
		local paginationTotal = math.ceil(total / 6)

		paginationPanel.count:setText(tr(string.format("|%d-%d| of |%d|", paginationStart, paginationEnd, total)))
		paginationPanel.total:setText(paginationTotal)
		paginationPanel.current:setText(pagination)
		paginationPanel.back:setEnabled(pagination > 1)
		paginationPanel.next:setEnabled(pagination < paginationTotal)

		panel.currentPagination = pagination
		panel.currentTotalParts = total
	end

	if data.mounts then
		for _, mount in ipairs(data.mounts) do
			if not panel.action then
				panel.action = mount.sex == 0 and "request_female_mount" or "request_male_mount"

				panel.top_panel.title:setText(string.format("%s Moa Selection", mount.sex == 0 and "Female" or "Male"))
			end

			local widget = g_ui.createWidget("GameTransportAttachedWindowListMountButtonHolder", panel.contents.list)
			local content = widget.content
			local outfit = {
				mount = mount.outfit.mountBody,
				mountBody = mount.outfit.mountBody,
				mountArmor = mount.outfit.mountArmor,
				mountLightEffect = mount.outfit.mountLightEffect,
				mountFirstOrnament = mount.outfit.mountFirstOrnament,
				mountSecondOrnament = mount.outfit.mountSecondOrnament,
				category = ThingCategoryCreature
			}

			content.outfit.tooltipData = mount
			content.outfit.tooltipData.category = "mount"

			content.outfit:setOutfit(outfit)
			content.tierWidget.tierLabel:setText(tostring(mount.tier))
			content.bondWidget.bondLabel:setText(tostring(mount.bond.level))
			content.breedLimitWidget.breedLimitLabel:setText(string.format("%d/%d", mount.breedLimit.current, mount.breedLimit.total))
			content.breedLimitWidget:setVisible(true)
			content.release:setVisible(false)

			widget.mountData = mount

			if mount.name ~= "" then
				widget.namePanel.nameLabel:setText(mount.name)
			end

			function content.outfit.onClick()
				local parent = widget:getParent()

				for _, child in ipairs(parent:getChildren()) do
					child.content:setOn(false)
				end

				if panel.selectedMount == widget then
					panel.selectedMount = nil

					widget.content:setOn(false)

					return
				end

				panel.selectedMount = widget

				widget.content:setOn(true)
			end

			if data.mounts.selected == mount.id then
				panel.default = data.mounts.selected

				content.outfit:onClick()
			end

			content.outfit:setVisible(type == "mounts")
		end
	end

	if data.items then
		for _, item in ipairs(data.items) do
			local widget = g_ui.createWidget("BreedingSelectionWidget", panel.contents.list)

			widget.item:setItemId(item.clientId)

			local it = widget.item:getItem()

			widget.text:setText(item.name)
			it:setName(item.name)
			it:setDescription(item.description)

			widget.itemData = item

			function widget.onClick()
				local parent = widget:getParent()

				for _, child in ipairs(parent:getChildren()) do
					child:setOn(false)
				end

				if panel.selectedItem == widget then
					panel.selectedItem = nil

					widget:setOn(false)

					return
				end

				panel.selectedItem = widget

				widget:setOn(true)
			end

			if data.items.selected == item.id then
				widget:onClick()
			end

			widget.item:setVisible(type == "items")
		end
	end

	function panel.contents.button_panel.confirm_button:onClick()
		if type == "mounts" then
			local mount = panel.selectedMount and panel.selectedMount.mountData

			GameProfessions:sendOpcode({
				action = "select_mount",
				mount = mount and mount.id,
				remove = not mount and panel.default,
				position = data.position
			})
		else
			local item = panel.selectedItem and panel.selectedItem.itemData

			GameProfessions:sendOpcode({
				action = "select_booster",
				item = item and item.id,
				position = data.position
			})
		end

		panel:destroy()
	end
end

function requestPaginationMountList(pagination)
	local panel = modules.game_professions.getBreedingSelectionPanel()

	if panel then
		GameProfessions:sendOpcode({
			action = panel.action,
			position = panel.position,
			pagination = pagination
		})
	end
end
