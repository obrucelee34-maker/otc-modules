-- chunkname: @/modules/game_npcs/moa_exchange_shop.lua

MoaExchange = {
	selectedMounts = {},
	exchangeBreedingLevelRequired = {
		nil,
		20,
		30,
		40,
		55,
		70
	}
}

function MoaExchange:init()
	connect(g_game, {
		onGameEnd = self.onGameEnd
	})

	self.window = GameNpc.panels[windowTypes.moa_exchange_shop]

	self.window:setVisible(false)
end

function MoaExchange:terminate()
	self.window:destroy()
	disconnect(g_game, {
		onGameEnd = self.onGameEnd
	})

	MoaExchange = nil
end

function MoaExchange.onGameEnd()
	MoaExchange:onClose()
end

function MoaExchange:onClose()
	if self.confirmationBox then
		self.confirmationBox:destroy()

		self.confirmationBox = nil
	end

	MoaExchange:resetInfo()

	self.currentPagination = nil
	self.currentTotalParts = nil
	self.selectedMountTier = nil
	self.selectedMounts = {}
end

function MoaExchange:isVisible()
	return self.window and self.window:isVisible()
end

function MoaExchange:resetInfo(isPagination)
	local itemsPanel = self.window.list

	if itemsPanel and not table.empty(itemsPanel:getChildren()) then
		itemsPanel:destroyChildren()
	end
end

function MoaExchange:show(data)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	if not data.mounts then
		return
	end

	self:resetInfo()
	GameNpc:setPanel("moa_exchange_shop")

	if data.pagination then
		local paginationPanel = self.window:recursiveGetChildById("pagination_panel")
		local pagination = data.pagination
		local total = data.total
		local paginationMax = #data.mounts
		local paginationEnd = total > pagination * 9 and pagination * 9 or total
		local paginationStart = (pagination - 1) * 9 + 1
		local paginationTotal = math.ceil(total / 9)

		paginationPanel.count:setText(tr(string.format("|%d-%d| of |%d|", paginationStart, paginationEnd, total)))
		paginationPanel.total:setText(paginationTotal)
		paginationPanel.current:setText(pagination)
		paginationPanel.back:setEnabled(pagination > 1)
		paginationPanel.next:setEnabled(pagination < paginationTotal)

		self.currentPagination = pagination
		self.currentTotalParts = total
	end

	local breedingLevel = player:getProfessionLevel(ProfessionBreeding)

	for _, mount in ipairs(data.mounts) do
		local widget = g_ui.createWidget("GameTransportAttachedWindowListMountButtonHolder", self.window.list)
		local content = widget.content

		widget:setImageSource("/images/ui/windows/npcs/main/BgGeneralIcon")
		widget:setImageBorder(10)

		local outfit = {
			mount = mount.outfit.mountBody,
			mountBody = mount.outfit.mountBody,
			mountArmor = mount.outfit.mountArmor,
			mountLightEffect = mount.outfit.mountLightEffect,
			mountFirstOrnament = mount.outfit.mountFirstOrnament,
			mountSecondOrnament = mount.outfit.mountSecondOrnament,
			category = ThingCategoryCreature
		}
		local id = mount.id
		local tier = mount.tier

		content.outfit.tooltipData = mount
		content.outfit.tooltipData.category = "mount"

		content.outfit:setOutfit(outfit)
		content.tierWidget.tierLabel:setText(tostring(tier))
		content.bondWidget.bondLabel:setText(tostring(mount.bond.level))
		content.breedLimitWidget.breedLimitLabel:setText(string.format("%d/%d", mount.breedLimit.current, mount.breedLimit.total))
		content.breedLimitWidget:setVisible(true)
		content.release:setVisible(false)
		widget:setId(id)

		widget.mountData = mount

		if mount.name ~= "" then
			widget.namePanel.nameLabel:setText(mount.name)
		end

		widget.hasBreedingLevelRequired = breedingLevel >= self.exchangeBreedingLevelRequired[tier]

		if not widget.hasBreedingLevelRequired then
			content:setEnabled(false)
			widget.tooltipPanel:setVisible(true)
			widget.tooltipPanel:setTooltip(tr("You need a Breeding Level of at least %d to exchange Tier %d Moas.", self.exchangeBreedingLevelRequired[tier], tier))
		else
			if self.selectedMounts[id] then
				self.selectedMounts[id] = widget

				widget.content:setOn(true)
			end

			function content.outfit.onClick()
				if not self.selectedMounts[id] then
					self.selectedMountTier = tier
					self.selectedMounts[id] = widget

					widget.content:setOn(true)
				else
					self.selectedMounts[id] = nil

					widget.content:setOn(false)
				end

				local size = table.size(self.selectedMounts)

				if size == 0 then
					self.selectedMountTier = nil
				end

				self:updateMountList()
			end
		end
	end

	self:updateMountList()
end

function MoaExchange:updateMountList()
	local size = table.size(self.selectedMounts)

	for _, child in ipairs(self.window.list:getChildren()) do
		if child.hasBreedingLevelRequired then
			child.content:setEnabled(size == 0 or self.selectedMountTier == child.mountData.tier)
		end
	end

	local button = self.window:recursiveGetChildById("exchangeButton")

	if button then
		button:setEnabled(size > 0 and size % 2 == 0)
	end

	local cost = cfg.moaExchangeSilverCost[self.selectedMountTier] or 0

	if cost then
		button:setText(FormatCommaNumber(cost * (size / 2)))
	end

	local rewardPanel = self.window:recursiveGetChildById("reward_panel")

	if rewardPanel then
		rewardPanel.count:setText(math.max(0, (size - size % 2) / 2))
	end
end

function MoaExchange:getMounts()
	local ids = {}

	for id in pairs(self.selectedMounts) do
		table.insert(ids, id)
	end

	return ids
end

function MoaExchange:requestPaginationMountList(pagination)
	GameNpc:sendOpcode({
		option = "npc_moa_exchange",
		action = "dialogue",
		dialogueId = GameNpc.dialogueId,
		npcName = GameNpc.npcName,
		pagination = pagination
	})
end

function MoaExchange:requestMoaExchange()
	if self.confirmationBox then
		self.confirmationBox:destroy()

		self.confirmationBox = nil
	end

	local function yesCallback()
		GameNpc:sendOpcode({
			option = "npc_moa_exchange_confirm",
			action = "dialogue",
			dialogueId = GameNpc.dialogueId,
			npcName = GameNpc.npcName,
			mounts = self:getMounts()
		})

		self.selectedMounts = {}

		self.confirmationBox:destroy()

		self.confirmationBox = nil
	end

	local function noCallback()
		self.confirmationBox:destroy()

		self.confirmationBox = nil
	end

	local cost = cfg.moaExchangeSilverCost[self.selectedMountTier]

	if cost then
		local size = table.size(self.selectedMounts)

		self.confirmationBox = displayGeneralBox(tr("Moa Exchange"), string.format("This will exchange %d of your Moas for %d new random one%s that can't be bred. You will be charged a %s silver fee for this exchange. Are you sure?", size, size / 2, size / 2 > 1 and "s" or "", FormatCommaNumber(cost * (size / 2))), {
			{
				text = tr("Confirm"),
				callback = yesCallback
			},
			{
				text = tr("Cancel"),
				callback = noCallback
			},
			anchor = AnchorHorizontalCenter
		}, yesCallback, noCallback, nil, modules.game_interface.getRootPanel())
	end
end
