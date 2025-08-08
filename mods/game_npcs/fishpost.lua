-- chunkname: @/modules/game_npcs/fishpost.lua

Fishpost = {}

function Fishpost.onGameEnd()
	Fishpost:resetInfo()
end

function Fishpost:isVisible()
	return self.window and self.window:isVisible()
end

function Fishpost:init()
	connect(g_game, {
		onGameEnd = self.onGameEnd
	})

	self.window = GameNpc.panels[windowTypes.fishpost]

	self.window:setVisible(false)
end

function Fishpost:terminate()
	self.window:destroy()
	disconnect(g_game, {
		onGameStart = self.onGameStart
	})

	Fishpost = nil
end

function Fishpost:onResize()
	if not self.window then
		return
	end

	local itemsPanel = self.window:recursiveGetChildById("itemsPanel")
	local maxWidth = itemsPanel:getWidth() - itemsPanel:getPaddingLeft() - itemsPanel:getPaddingRight() - itemsPanel:getLayout():getCellSpacing().width

	itemsPanel:getLayout():setCellWidth(math.floor(maxWidth / 2))
end

function Fishpost:resetInfo()
	if self.lastItem then
		self.lastItem = nil
	end

	local itemsPanel = self.window:recursiveGetChildById("itemsPanel")

	if not table.empty(itemsPanel:getChildren()) then
		itemsPanel:destroyChildren()
	end

	local search = self.window:recursiveGetChildById("textEdit")

	search:setText("")
end

function Fishpost:onOpen(data)
	self:resetInfo()
	GameNpc:setPanel("fishpost")

	local itemsPanel = self.window:recursiveGetChildById("itemsPanel")

	for _, pack in ipairs(data.packs) do
		local widget = g_ui.createWidget("GameFishpostItem", itemsPanel)

		for k, v in pairs(pack) do
			widget[k] = v
		end

		local nameLabel = widget:getChildById("name")
		local priceLabel = widget:getChildById("price")
		local choppedLabel = widget:getChildById("chopped")
		local qualityLabel = widget:getChildById("quality")
		local iconChopped = widget:getChildById("iconChopped")
		local item = widget:getChildById("item")
		local _item = Item.create(widget.clientId)

		_item:setAdditionalAttributes(json.encode(pack))
		_item:setUUID(pack.UUID)
		_item:setQuality(widget.quality)
		_item:setName(pack.name)
		item:setItem(_item)
		nameLabel:setText(pack.name)
		priceLabel:setText(math.floor(pack.price))
		choppedLabel:setText(math.round(pack.chopped))
		widget:setId(pack.UUID)

		local fishId = _item:getId()
		local sliceId = FishToSlice[fishId]
		local slice = sliceId and FishSlices[sliceId]

		if slice then
			local _item = Item.create(sliceId)

			_item:setName(slice.name)
			_item:setDescription(slice.description)
			iconChopped:setItem(_item)
		end

		widget.clickSound = true

		function widget.onClick()
			if not widget:isChecked() then
				self:onDisplayFish(widget)
			end
		end

		if not self.lastItem then
			self:onDisplayFish(widget)
		end
	end
end

function Fishpost:onDisplayFish(widget)
	if widget == self.lastItem then
		return
	end

	if self.lastItem then
		self.lastItem:setOn(false)
	end

	local weight = widget.item.weightLabel:getText()
	local bottomPanel = self.window:recursiveGetChildById("bottomPanel")
	local item = bottomPanel:getChildById("fishpostItemInfo")
	local slicePanel = bottomPanel.slicePanel
	local sellPanel = bottomPanel.sellPanel
	local fish = widget.item:getItem()

	item:getChildById("item"):show()
	item:getChildById("item"):setItem(fish)
	item:getChildById("name"):setText(widget.name)
	item:getChildById("weightLabel"):setText(weight)

	local fishId = fish:getId()
	local sliceId = FishToSlice[fishId]
	local slice = sliceId and FishSlices[sliceId]

	if slice then
		local _item = Item.create(sliceId)

		_item:setName(slice.name)
		_item:setDescription(slice.description)
		slicePanel.icon:setItem(_item)
	end

	slicePanel.value:setText(math.round(widget.chopped))
	sellPanel.value:setText(math.round(widget.price))

	local quality = QualityNames[widget.quality]

	if quality then
		item:getChildById("quality"):setText(quality:gsub("^%l", string.upper))
		item:getChildById("quality"):setColor(ItemQualityColors[widget.quality])
	end

	self.lastItem = widget

	widget:setOn(true)
end

function Fishpost:getCurrentPack()
	local pack = {}

	if self.lastItem then
		pack = {
			index = self.lastItem.index,
			UUID = self.lastItem:getId()
		}
	end

	return pack
end

function Fishpost:onSearchFilter(text)
	local itemsPanel = self.window:recursiveGetChildById("itemsPanel")

	for _, widget in ipairs(itemsPanel:getChildren()) do
		if text == "" then
			widget:setVisible(true)
		else
			widget:setVisible(widget.name:lower():find(text:lower(), 1, true) ~= nil)
		end
	end
end
