-- chunkname: @/modules/game_lootnotification/lootnotification.lua

GameLootNotification = {
	widgets = {},
	queue = {},
	events = {}
}

function GameLootNotification:loadConfig()
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

function GameLootNotification:init()
	if not self:loadConfig() then
		return false
	end

	g_ui.importStyle("styles/main.otui")

	local HUDPanel = modules.game_interface.getHUDPanel()

	self.window = g_ui.createWidget("GameLootNotificationWindow", HUDPanel)
	self.contentPanel = self.window.content

	for _ = 1, cfg.maxDisplayWidgets do
		local widget = g_ui.createWidget("GameLootNotificationWindowEntry")

		widget:hide()
		table.insert(self.widgets, widget)
	end

	self.window.onDragEnter = onDragEnter
	self.window.onDragMove = onDragMove

	connect(g_game, {
		onGameEnd = GameLootNotification.onGameEnd
	})

	if g_wwise then
		connect(g_wwise, {
			onSoundEventFinished = GameLootNotification.onSoundEventFinished
		})
	end

	ProtocolGame.registerExtendedOpcode(ExtendedIds.LootNotification, GameLootNotification.onExtendedOpcode)

	self.events[0] = cycleEvent(function()
		self:checkQueue()
	end, 1000)
end

function GameLootNotification:terminate()
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.LootNotification)
	disconnect(g_game, {
		onGameEnd = GameLootNotification.onGameEnd
	})

	if g_wwise then
		disconnect(g_wwise, {
			onSoundEventFinished = GameLootNotification.onSoundEventFinished
		})
	end

	self.window:destroy()

	self.window = nil

	for _, event in pairs(self.events) do
		removeEvent(event)
	end

	self.events = {}
	GameLootNotification = nil
end

function GameLootNotification.onGameEnd()
	local self = GameLootNotification

	for id, event in pairs(self.events) do
		if id ~= 0 then
			removeEvent(event)
		end
	end

	self.events = {}

	for _, child in ipairs(self.contentPanel:getChildren()) do
		g_effects.cancelFade(child)
		child:setOpacity(1)

		child.appearTime = nil

		child:setMarginTop(0)
		child:hide()
		self.contentPanel:removeChild(child)
		table.insert(self.widgets, child)
	end

	self.queue = {}
end

function GameLootNotification:testAddEntry(type)
	if type == cfg.LOOT_TYPE_ITEM then
		local data = {
			clientId = 29000,
			grade = 1,
			amount = 1,
			itemName = "Black Ash Bow",
			type = type
		}

		self:addLootEntry(data)
	else
		local data = {
			amount = 234,
			profession = ProfessionBlacksmithing,
			type = type
		}

		self:addLootEntry(data)
	end
end

function GameLootNotification:addLootEntry(data, fromQueue)
	local content = self.contentPanel

	if not fromQueue or content:getChildCount() >= cfg.maxDisplayWidgets then
		if #self.queue == 0 then
			scheduleEvent(function()
				self:checkQueue()
			end, 100)
		end

		self:addToQueue(data)

		return
	end

	local widget = table.remove(self.widgets)

	if data.type == cfg.LOOT_TYPE_ITEM then
		data.rarity = ItemRarityByItemId[data.clientId] or data.rarity

		widget.outfit:hide()
		widget.icon:hide()
		widget.item:setItemId(data.clientId)
		widget.item:show()
		widget.border:show()
		widget.border:setImageColor(forceColor or data.rarity and cfg.ItemQualityColors[data.rarity] or "white")
		widget.item:raise()
		widget.progress_panel:hide()
		widget.label:setText(data.itemName)
		widget.amount:setText(string.format("x%d", data.amount))
	elseif data.type == cfg.LOOT_TYPE_PROFESSION then
		widget.item:hide()
		widget.outfit:hide()

		local player = g_game.getLocalPlayer()

		if not player then
			return
		end

		widget.icon:setImageSource(string.format("/images/ui/windows/professions/icons/%s", string.lower(ProfessionNames[data.profession])))
		widget.icon:show()
		widget.label:setColoredText(GetHighlightedText(string.format("{[%d], #A556FF} %s", player:getProfessionLevel(data.profession), ProfessionNames[data.profession]), "white"))
		widget.amount:setColoredText(GetHighlightedText(string.format("{+%d, #77D463}", data.amount), "white"))
		widget.border:show()
		widget.border:raise()
		widget.border:setImageColor("white")
		widget.border:setOpacity(0)
		widget.progress_panel:show()
		widget.progress_panel:raise()
		widget.progress_panel.progress:setPercent(data.oldPercent)

		local cycles = 1 + (data.newLevel - data.oldLevel)
		local totalPercentChange = (cycles - 1) * 100 + data.newPercent - data.oldPercent
		local lastPercent = data.oldPercent
		local lastLevel = data.oldLevel
		local animationTime = 2000
		local startTime = 0
		local percentAdded = 0
		local cycle = 1

		local function updateProgressAndLabel(elapsed)
			local overallPercentChange = elapsed / animationTime * totalPercentChange
			local percentChange = overallPercentChange - percentAdded

			percentAdded = percentAdded + percentChange

			if percentAdded >= totalPercentChange then
				return
			end

			lastPercent = lastPercent + percentChange

			if lastPercent >= 100 then
				lastPercent = lastPercent - 100
				lastLevel = lastLevel + 1
			end

			widget.progress_panel.progress:setPercent(lastPercent)
			widget.label:setColoredText(GetHighlightedText(string.format("{[%d], #A556FF} %s", lastLevel, ProfessionNames[data.profession]), "white"))
		end

		scheduleEvent(function()
			startTime = g_clock.millis()

			g_effects.fadeIn(widget.border, 1000, nil, nil, function()
				g_effects.fadeOut(widget.border, 1000, nil, nil, nil, function(_, progress)
					local elapsed = g_clock.millis() - startTime

					updateProgressAndLabel(elapsed)
				end)
			end, function(_, progress)
				local elapsed = g_clock.millis() - startTime

				updateProgressAndLabel(elapsed)
			end)
		end, 1000)
	elseif data.type == cfg.LOOT_TYPE_DEFAULT then
		widget.item:hide()
		widget.border:hide()
		widget.outfit:hide()
		widget.progress_panel:hide()

		if data.source == "artifacts" then
			widget.icon:setImageSource(modules.game_journal.GameJournal:getArtifactImageSource(data.regionId, data.objectiveId))
			widget.label:setText(modules.game_journal.GameJournal:getArtifactName(data.regionId, data.objectiveId))
			widget.border:show()
			widget.border:setImageColor("#ce66a3")
		elseif data.source == "ravencard" then
			if not data.cardName then
				return
			end

			local path = "/images/ui/ravencards/illustrations/" .. data.cardName:lower():gsub(" ", "_") .. ".ktx"

			if not g_resources.fileExists(path) then
				return
			end

			widget.icon:setImageSource(path)
			widget.label:setText(data.cardName:titleCase())
			widget.border:show()
			widget.border:setImageColor(CardRarityToColor[data.cardRarity])
		else
			widget.icon:setImageSource(string.format("/images/ui/windows/loot_notification/icon_%s", data.icon))
			widget.label:setText(data.text)
		end

		widget.icon:show()

		local color = data.amountColor or "#77D463"

		widget.amount:setColoredText(GetHighlightedText(string.format("{+%d, %s}", data.amount, color), "white"))

		if data.rarity then
			widget.border:show()
			widget.border:setImageColor(cfg.ItemQualityColors[data.rarity])
		end
	elseif data.type == cfg.LOOT_TYPE_OUTFIT then
		widget.icon:hide()
		widget.item:hide()
		widget.border:hide()
		widget.progress_panel:hide()

		if data.source == "mount_armor" then
			if not data.mountArmor then
				return
			end

			widget.outfit.isCosmetic = true

			widget.outfit:setOutfit({
				mountBody = 3535,
				mount = 3535,
				category = ThingCategoryCreature,
				mountArmor = data.mountArmor
			})
		end

		if data.text then
			if not data.amount then
				widget.label:setWidth(200)
			end

			widget.label:setText(data.text:titleCase())
		end

		widget.outfit:show()

		if data.amount then
			local color = data.amountColor or "#77D463"

			widget.amount:setColoredText(GetHighlightedText(string.format("{+%d, %s}", data.amount, color), "white"))
		else
			widget.amount:hide()
		end

		if data.rarity then
			widget.border:show()
			widget.border:setImageColor(cfg.ItemQualityColors[data.rarity])
		end
	end

	if data.source then
		local source_image

		if cfg.allowedSourceIcon[data.source] then
			source_image = data.source
		end

		if not source_image and string.find(data.source, ";") then
			local source = string.split(data.source, ";")

			if cfg.allowedSourceIcon[source[1]] then
				source_image = source[1]
			end
		end

		if source_image then
			widget.source_icon:setImageSource(string.format("/images/ui/windows/loot_notification/%s_icon", source_image))
			widget.source_icon:show()

			widget.source = data.source
		else
			widget.source_icon:hide()

			widget.source = nil
		end
	else
		widget.source_icon:hide()

		widget.source = nil
	end

	widget.type = data.type

	local backgroundColor = data.rarity and cfg.ItemQualityColors[data.rarity] or data.cardRarity and CardRarityToColor[data.cardRarity] or "#000000"

	widget:setImageSource(string.format("/images/ui/windows/loot_notification/%s", backgroundColor))

	widget.rarity = data.rarity

	local timeToAppear = content:getChildCount() * 100

	content:addChild(widget)

	if timeToAppear > 0 then
		self.events[widget:getId()] = scheduleEvent(function()
			widget.appearTime = g_clock.millis()

			widget:setOpacity(1)
			g_effects.fadeIn(widget, 333)
			widget:show()
			self:handleSound(widget)
			self:checkQueue()
		end, timeToAppear)
	else
		widget.appearTime = g_clock.millis()

		widget:setOpacity(1)
		g_effects.fadeIn(widget, 333)
		widget:show()
		self:handleSound(widget)
		self:checkQueue()
	end

	if content:getChildIndex(widget) == 1 then
		self.events[widget:getId()] = scheduleEvent(function()
			self:handleHideAnimation(widget)
		end, cfg.entryVisibleDuration)
	end
end

function GameLootNotification:handleSound(widget)
	local soundTier = cfg.rarityToSoundTier[widget.rarity] or 1
	local soundEventId = cfg.soundEventsByTier[soundTier]

	if not self.currentPlayingSoundEventId and self.lastPlayingSoundEventId ~= soundEventId and soundEventId then
		self.currentPlayingSoundEventId = soundEventId
		self.lastPlayingSoundEventId = soundEventId

		g_sound.play(soundEventId)
	end
end

function GameLootNotification:handleHideAnimation(widget)
	local function finishCallback()
		widget:setMarginTop(0)
		widget:hide()

		local content = self.contentPanel

		content:removeChild(widget)
		table.insert(self.widgets, widget)
		self:checkQueue()
	end

	local function jobCallback(widget, progress)
		local content = self.contentPanel
		local index = content:getChildIndex(widget)
		local nextChild = content:getChildByIndex(index + 1)

		if nextChild then
			nextChild:setMarginTop(-progress * widget:getHeight())

			if progress >= 1 then
				nextChild:setMarginTop(0)

				self.events[nextChild:getId()] = scheduleEvent(function()
					self:handleHideAnimation(nextChild)
				end, math.max(100, nextChild.appearTime + cfg.entryVisibleDuration - g_clock.millis()))
			end
		end
	end

	g_effects.fadeOut(widget, 500, nil, false, finishCallback, jobCallback, 2)

	if not self.events[0] then
		self.events[0] = cycleEvent(function()
			self:checkQueue()
		end, 1000)
	end
end

function GameLootNotification:checkQueue()
	local content = self.contentPanel

	if not content then
		return
	end

	local firstChild = content:getFirstChild()

	if firstChild then
		if firstChild.appearTime then
			if not currentPlayingSoundEventId and g_clock.millis() - firstChild.appearTime > cfg.entryVisibleDuration * 3 then
				for id, event in pairs(self.events) do
					if id ~= 0 then
						removeEvent(event)
					end
				end

				self.events = {}

				for _, child in ipairs(self.contentPanel:getChildren()) do
					g_effects.cancelFade(child)
					child:setOpacity(1)

					child.appearTime = nil

					child:setMarginTop(0)
					child:hide()
					self.contentPanel:removeChild(child)
					table.insert(self.widgets, child)
				end
			end
		else
			self.onGameEnd()

			return
		end
	end

	if content:getChildCount() < cfg.maxDisplayWidgets and #self.queue > 0 then
		local data = table.remove(self.queue, 1)

		self:addLootEntry(data, true)
	end

	self.window:setHeight(content:getChildCount() * cfg.entryHeight + 32)
end

function GameLootNotification:addToQueue(data)
	for _, entry in ipairs(self.queue) do
		if entry.type == data.type and entry.source == data.source then
			if entry.type == cfg.LOOT_TYPE_ITEM then
				if entry.clientId == data.clientId and entry.itemName == data.itemName and entry.rarity == data.rarity then
					entry.amount = entry.amount + data.amount

					return
				end
			elseif entry.type == cfg.LOOT_TYPE_PROFESSION then
				if entry.profession == data.profession then
					entry.amount = entry.amount + data.amount

					return
				end
			elseif entry.type == cfg.LOOT_TYPE_DEFAULT and entry.source == data.source and entry.icon == data.icon and entry.text == data.text then
				entry.amount = entry.amount + data.amount

				return
			end
		end
	end

	table.insert(self.queue, data)
	table.sort(self.queue, function(a, b)
		local aType = type(a.rarity)
		local bType = type(b.rarity)

		if aType == "nil" and bType ~= "nil" then
			return false
		elseif aType ~= "nil" and bType == "nil" then
			return true
		elseif aType == "string" and bType ~= "string" then
			return true
		elseif aType ~= "string" and bType == "string" then
			return false
		elseif aType == "number" and bType == "number" then
			return a.rarity > b.rarity
		else
			return false
		end
	end)
end

function GameLootNotification:addFishRewardWindow(window)
	window:addAnchor(AnchorTop, self.window:getId(), AnchorBottom)
	window:addAnchor(AnchorHorizontalCenter, self.window:getId(), AnchorHorizontalCenter)
	window:setMarginLeft(15)
	window:setWidth(300)
	g_layout.onOpenWindow(window, 200, true)
	scheduleEvent(function()
		g_effects.fadeOut(window, 200, nil, true)
	end, cfg.entryVisibleDuration - 210)
end

function GameLootNotification.onExtendedOpcode(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.LootNotification or buffer == "" then
		return
	end

	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		return
	end

	if data.action == "loot_entry" then
		GameLootNotification:addLootEntry(data)
	end
end

function GameLootNotification.onSoundEventFinished(gameObjectId, eventId, playingId)
	if not cfg.soundEvents[eventId] then
		return
	end

	local self = GameLootNotification

	self.currentPlayingSoundEventId = nil
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

function update()
	local isEditMode = g_layout.isEditMode()
	local window = GameLootNotification.window
	local widget = window:recursiveGetChildById("editModeBackground")

	widget:setVisible(isEditMode)

	if not isEditMode then
		window:setPhantom(true)
	else
		window:setPhantom(false)
	end
end
