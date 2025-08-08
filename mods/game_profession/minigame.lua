-- chunkname: @/modules/game_profession/minigame.lua

minigameWindow = nil
cancelMinigameGeneralBox = nil

local previousQuality = ItemQualityNormal
local finishEvent, removedIngredients

function createMinigameWindow()
	minigameWindow = g_ui.createWidget("CraftingMinigame", modules.game_interface.getHUDPanel())

	minigameWindow:hide()
	minigameWindow.laborPanel.laborProgress:setTooltip("All skills require Labor to use. If you do not \nhave enough Labor to complete the craft, it will fail.")
	minigameWindow.durabilityPanel.durabilityProgress:setTooltip("If Durability reaches zero, the item will break. \nCertain unlockable skills repair durability while crafting, but require Labor to use.")
	minigameWindow.quality:setTooltip("As the Quality bar fills, the chance\n to craft higher grade items increases.")
	minigameWindow.progress:setTooltip("To finish a craft, the Progress bar \nmust be filled completely.")
	minigameWindow.qualityName:setTooltip("A craft with a better Condition provides higher \nefficiency bonuses to progress and quality skills.")
end

function updateMinigameInfo(info)
	removedIngredients = info.removedIngredients

	minigameWindow.progress:setPercentage(info.current.progress, info.progress)
	minigameWindow.progress.label:setText(string.format("%i/%i", math.min(info.progress, info.current.progress), info.progress))
	minigameWindow.durabilityPanel.durabilityProgress:setPercent(info.current.durability / info.durability * 100)
	minigameWindow.durabilityPanel.durability:setText(string.format("%i/%i", info.current.durability, info.durability))

	for _, child in ipairs(minigameWindow.durabilityPanel.durabilityProgress:getChildren()) do
		if child:getId():find("splitter", 1, true) then
			child:destroy()
		end
	end

	for i = 1, info.durability - 1 do
		local splitter = g_ui.createWidget("UIWidget", minigameWindow.durabilityPanel.durabilityProgress)

		splitter:setId("splitter" .. i)
		splitter:setWidth(2)
		splitter:addAnchor(AnchorLeft, "progress", AnchorLeft)
		splitter:addAnchor(AnchorTop, "progress", AnchorTop)
		splitter:addAnchor(AnchorBottom, "progress", AnchorBottom)
		splitter:setBackgroundColor("#25272C")
		splitter:setOpacity(1)

		local width = minigameWindow.durabilityPanel.durabilityProgress:getWidth()
		local marginLeft = minigameWindow.durabilityPanel.durabilityProgress.progress:getMarginLeft()
		local marginRight = minigameWindow.durabilityPanel.durabilityProgress.progress:getMarginRight()

		splitter:setMarginLeft(math.ceil(i * (width - marginLeft - marginRight) / info.durability) - 1)
	end

	minigameWindow.laborPanel.laborProgress:setPercent(info.current.labour / info.labour * 100)
	minigameWindow.laborPanel.labor:setText(string.format("%i/%i", info.current.labour, info.labour))
	minigameWindow.item.preview:setItemId(info.item.clientId)

	local recipe = table.findbyfield(recipes[info.professionId], "index", info.recipe)

	minigameWindow.item.preview:setTooltip(true)

	if not info.hasGrade then
		minigameWindow.item:setBorderColor(ItemQualityColors[info.current.quality])
	end

	if recipe then
		local tooltip = recipes[ProfessionLast + 1]

		minigameWindow.item.preview:getItem():setName(recipe.name:titleCase())
		minigameWindow.item.preview:getItem():setDescription(recipe.description or "")
		minigameWindow.item.preview:getItem():setQualityName(recipe.category:titleCase())

		if not info.hasGrade then
			minigameWindow.item.preview:getItem():setQuality(info.current.quality)
		end

		if info.current.quality ~= ItemQualityNormal then
			local color = info.current.quality and ItemQualityColors[info.current.quality] or ItemQualityColors[0]

			minigameWindow.item.outline:setVisible(true)

			if not info.hasGrade then
				minigameWindow.item.outline:setImageColor(color)
			end
		else
			minigameWindow.item.outline:setVisible(true)
		end

		local attr = tooltip[info.item.clientId]

		if attr then
			local tmpItem = minigameWindow.item.preview:getItem()

			tmpItem:setAttack(attr.attack)
			tmpItem:setDefense(attr.defense)
			tmpItem:setHealing(attr.healing)
			tmpItem:setLabor(attr.labor)
			tmpItem:setItemType(attr.type)
			tmpItem:setTier(attr.tier)
			tmpItem:setDurability(-1)
			tmpItem:setProfession(attr.profession)
			tmpItem:setMinReqLevel(attr.level)
			tmpItem:setMinReqLegacyLevel(attr.legacyLevel)

			tmpItem.isRecipe = true
		end
	end

	minigameWindow.qualityName:setText(ConditionNames[info.condition]:titleCase() .. " Condition")

	local maxQuality = 0

	for quality, _ in pairs(info.nextQuality) do
		maxQuality = math.max(maxQuality, quality)
	end

	if info.current.quality == (not info.hasGrade and ItemQualityArtisan) or info.current.quality == maxQuality then
		minigameWindow.quality:setPercentage(100, 100)
		minigameWindow.quality.label:setText("Max")
	else
		if not minigameWindow.quality.event and previousQuality ~= info.current.quality then
			minigameWindow.quality:setPercentage(100, 100, function()
				minigameWindow.quality:setPercent(0)
				minigameWindow.quality:setPercentage(info.current.qualityProgress, info.nextQuality[info.current.quality + 1] or info.current.qualityProgress)
				minigameWindow.quality.label:setText(string.format("%i/%i", math.min(info.nextQuality[info.current.quality + 1] or info.current.qualityProgress, info.current.qualityProgress), info.nextQuality[info.current.quality + 1] or info.current.qualityProgress))

				previousQuality = info.current.quality
			end)

			return
		end

		minigameWindow.quality:setPercentage(info.current.qualityProgress, info.nextQuality[info.current.quality + 1] or info.current.qualityProgress)
		minigameWindow.quality.label:setText(string.format("%i/%i", math.min(info.nextQuality[info.current.quality + 1] or info.current.qualityProgress, info.current.qualityProgress), info.nextQuality[info.current.quality + 1] or info.current.qualityProgress))

		previousQuality = info.current.quality
	end
end

function showMinigameWindow()
	minigameWindow:show()
end

function hideMinigameWindow()
	minigameWindow.item.preview:setItem(nil)
	minigameWindow:hide()
	AbilityBar.setState(g_game.isInShip() and AbilityBarCategoryShip or AbilityBarCategorySpell)
end

function onCraftBegin(data)
	if finishEvent then
		removeEvent(finishEvent)

		finishEvent = nil
	end

	if minigameWindow.quality.event then
		removeEvent(minigameWindow.quality.event)

		minigameWindow.quality.event = nil
	end

	if minigameWindow.progress.event then
		removeEvent(minigameWindow.progress.event)

		minigameWindow.progress.event = nil
	end

	previousQuality = ItemQualityNormal

	GameProfessions:hide()
	updateMinigameInfo(data.craftInfo)
	showMinigameWindow()
	AbilityBar.setState(AbilityBarCategoryCrafting)
	signalcall(GameProfessions.onCraftBegin, data)
end

function onCraftEnd(data)
	if minigameWindow.progress.event then
		finishEvent = scheduleEvent(function()
			onCraftEnd(data)
		end, 50)

		return
	end

	hideMinigameWindow()
	signalcall(GameProfessions.onCraftEnd, data)

	if data and data.craftInfo and data.craftInfo.succeeded then
		GameProfessions:iterateCategoryRecipeWidgets(data.profession, function(entry)
			if entry.recipe and entry.recipe.index == data.craftInfo.recipe then
				GameProfessions:updateEmblemProgress(entry, true)

				return true
			end
		end)
	end
end

function onCraftUpdate(data)
	showMinigameWindow()
	updateMinigameInfo(data.craftInfo)
end

function onCraftRemovedIngredients(data)
	removedIngredients = data.removedIngredients
end

function onCraft(data)
	if data.state == "begin" then
		onCraftBegin(data)
	elseif data.state == "end" then
		onCraftUpdate(data)
		onCraftEnd(data)
	elseif data.state == "removed_ingredients" then
		onCraftRemovedIngredients(data)
	elseif data.state == "cancel" then
		cancelCrafting(true)
	else
		onCraftUpdate(data)
	end
end

function cancelCrafting(force)
	if force then
		hideMinigameWindow()

		return
	end

	if removedIngredients then
		if cancelMinigameGeneralBox then
			return
		end

		local function destroyWindow()
			if cancelMinigameGeneralBox ~= nil then
				cancelMinigameGeneralBox:destroy()

				cancelMinigameGeneralBox = nil
			end
		end

		local function doCancelCrafting()
			sendCancelCraft()
			hideMinigameWindow()
			destroyWindow()
		end

		cancelMinigameGeneralBox = displayGeneralBox(tr("Cancel Craft"), tr("Are you sure you want to cancel your craft?\nYou will lose all the recipe ingredients."), {
			{
				text = tr("Yes"),
				callback = doCancelCrafting
			},
			{
				text = tr("No"),
				callback = destroyWindow
			},
			anchor = AnchorHorizontalCenter
		}, doCancelCrafting, destroyWindow)
	else
		sendCancelCraft()
		hideMinigameWindow()
	end

	signalcall(GameProfessions.onCraftCancel)
end
