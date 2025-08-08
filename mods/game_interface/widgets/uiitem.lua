-- chunkname: @/modules/game_interface/widgets/uiitem.lua

local lastQuickItemAction = 0
local twoHandedWeapons = {
	"bow",
	"greataxe",
	"greatsword",
	"hammer",
	"light blade",
	"staff",
	"bracers",
	"gloves"
}

local function moveItemToEquipped(item)
	local player = g_game.getLocalPlayer()

	if not player or not item:isPickupable() or item:isStackable() then
		return
	end

	local slot = item:getSlotPosition()

	if slot == InventorySlotFingerLeft and player:getInventoryItem(InventorySlotFingerLeft) then
		slot = InventorySlotFingerRight
	end

	local leftHand = player:getInventoryItem(InventorySlotLeft)

	if leftHand and slot == InventorySlotLeft and not table.contains(twoHandedWeapons, item:getItemType()) and not table.contains(twoHandedWeapons, leftHand:getItemType()) and not player:getInventoryItem(InventorySlotRight) then
		slot = InventorySlotRight
	end

	g_game.move(item, {
		z = 0,
		x = 65535,
		y = slot
	}, item:getCount())
end

local function moveItemToContainerType(item, containerType, moveOptions)
	if not item:isPickupable() then
		return
	end

	for _, container in pairs(g_game.getContainers()) do
		if (container:getType() ~= CONTAINER_TYPE_INVENTORY or container:getGuid() == InventorySlotBack) and containerType[container:getType()] then
			local moved = false

			for slot = 0, container:getCapacity() - 1 do
				if not container:getItem(slot) then
					g_game.move(item, container:getSlotPosition(slot), item:getCount(), moveOptions)

					moved = true

					break
				end
			end

			if moved then
				break
			end
		end
	end
end

function UIItem:onDragEnter(mousePos)
	local item = self:getItem()

	if not item then
		return false
	end

	if self.draggingLock and self.draggingLock - g_clock.millis() > 0 then
		return false
	end

	if self.preventDragItem or self:isVirtual() and not self.canDragItem then
		return false
	end

	self.currentDragThing = item

	local itemCopy = g_ui.createWidget("DragItem", modules.game_interface.getRootPanel())

	itemCopy:setItem(self:getItem())
	itemCopy:raise()
	itemCopy:setSize({
		width = 64,
		height = 64
	})
	itemCopy:setPhantom(true)

	local oldPos = self:getPosition()

	self.movingReference = {
		x = mousePos.x - oldPos.x,
		y = mousePos.y - oldPos.y
	}

	itemCopy:setPosition(oldPos)
	itemCopy:breakAnchors()

	self.dragItem = itemCopy

	itemCopy:setOpacity(0.5)
	g_sound.play(2635589204)

	if self.hasHover then
		if self.hover then
			self.hover:setOn(true)
		end

		if itemCopy.hover then
			itemCopy.hover:setOn(true)
		end
	end

	g_mouse.pushCursor("target")

	return true
end

function UIItem:onDragMove(mousePos, mouseMoved)
	local pos = {
		x = mousePos.x - self.movingReference.x,
		y = mousePos.y - self.movingReference.y
	}

	self.dragItem:setPosition(pos)
	self.dragItem:bindRectToParent()

	return true
end

function UIItem:onDragLeave(droppedWidget, mousePos)
	local item = self:getItem()

	if not item then
		return false
	end

	if self:isVirtual() and not self.canDragItem then
		return false
	end

	if self.onDragDrop then
		self:onDragDrop(rootWidget:recursiveGetChildByPos(mousePos))
	end

	if self.hover and self.hasHover then
		self.hover:setOn(self:isHovered())
	end

	self.currentDragThing = nil

	g_mouse.popCursor("target")

	if self.dragItem then
		self.dragItem:destroy()

		self.dragItem = nil

		g_sound.play(1165005940)
	end

	if self.hoveredWho and self.hoveredWho ~= self then
		local hasItem = self.hoveredWho:getItem()

		if hasItem and not self.hoveredWho:isVirtual() and self.hoveredWho:isDraggable() and self.hoveredWho.hover and self.hoveredWho.hasHover then
			self.hoveredWho.hover:setOn(self.hoveredWho:isHovered())
		end
	end

	self.hoveredWho = nil

	return true
end

function UIItem:onDrop(widget, mousePos, forced)
	if not self:canAcceptDrop(widget, mousePos) and not forced then
		return false
	end

	local item = widget.currentDragThing

	if not item or not item:isItem() or widget:isVirtual() then
		return false
	end

	local itemPos = item:getPosition()
	local itemTile = item:getTile()

	if itemPos.x ~= 65535 and not itemTile then
		return false
	end

	local toPos = self.position

	if not toPos or Position.equals(toPos, itemPos) then
		local children = rootWidget:recursiveGetChildrenByPos(mousePos)

		for i = 1, #children do
			local child = children[i]

			if child ~= self and not child:isPhantom() and child._containerPosition then
				toPos = child._containerPosition

				break
			end
		end

		if not toPos then
			return false
		end
	end

	if item:getCount() > 1 then
		modules.game_interface.moveStackableItem(item, toPos)
	else
		g_game.move(item, toPos, 1)
	end

	return true
end

function UIItem:onDestroy()
	if self == g_ui.getDraggingWidget() and self.hoveredWho then
		-- block empty
	end

	if self.dragItem then
		self.dragItem:destroy()

		self.dragItem = nil
	end

	if self.hoveredWho then
		self.hoveredWho = nil
	end
end

function UIItem:onHoverChange(hovered)
	if hovered then
		g_sound.play(1149246562)
	end

	if self:isVirtual() or not self:isDraggable() then
		return
	end

	local draggingWidget = g_ui.getDraggingWidget()

	if draggingWidget then
		local gotItem

		if self ~= draggingWidget then
			local gotMap = draggingWidget:getClassName() == "UIGameMap"

			gotItem = draggingWidget:getClassName() == "UIItem" and not draggingWidget:isVirtual()

			if hovered and (gotItem or gotMap) then
				draggingWidget.hoveredWho = self
			else
				draggingWidget.hoveredWho = nil
			end
		end

		if self == draggingWidget or gotItem then
			return
		end
	end

	if self.hover and self.hasHover then
		self.hover:setOn(self:getItem() and self:isHovered())
	end
end

function UIItem:onMouseRelease(mousePosition, mouseButton)
	if self.dragItem then
		self.dragItem:destroy()

		self.dragItem = nil
	end

	g_mouse.popCursor("target")

	if self.cancelNextRelease then
		self.cancelNextRelease = false

		return true
	end

	if self:isVirtual() then
		return false
	end

	local item = self:getItem()

	if not item or not self:containsPoint(mousePosition) then
		return false
	end

	if not g_app.isMobile() and (g_mouse.isPressed(MouseLeftButton) and mouseButton == MouseRightButton or g_mouse.isPressed(MouseRightButton) and mouseButton == MouseLeftButton) then
		g_game.look(item)

		self.cancelNextRelease = true

		return true
	elseif modules.game_interface.processMouseAction(mousePosition, mouseButton, nil, item, item, nil, nil, self.isBackpackItem and self) then
		return true
	end

	return false
end

function UIItem:canAcceptDrop(widget, mousePos)
	if self:isVirtual() or not self:isDraggable() then
		return false
	end

	if not widget or not widget.currentDragThing then
		return false
	end

	local children = rootWidget:recursiveGetChildrenByPos(mousePos)

	for i = 1, #children do
		local child = children[i]

		if child == self then
			return true
		elseif not child:isPhantom() then
			return false
		end
	end

	error("Widget " .. self:getId() .. " not in drop list.")

	return false
end

function UIItem:onClick(mousePos)
	if not self.selectable or not self.editable then
		return
	end

	if modules.game_itemselector then
		modules.game_itemselector.show(self)
	end
end

function UIItem:onItemChange()
	local item = self:getItem()

	if self.hasBorder then
		local overlay = self:getChildById("outline")
		local frame = self:getChildById("frame")
		local quality = item and item:getQuality()
		local qualityName = item and item:getQualityName()
		local itemId = self:getItemId()
		local rarity = ItemRarityByItemId[itemId]
		local color = ItemQualityColors[rarity] or ItemQualityColors[qualityName] or ItemQualityColors[quality] or ItemQualityColors[0]

		self:setBorderColor(color)

		local overlayColor = itemId ~= 0 and self.hasOverlay and (ItemQualityColors[rarity] or ItemQualityNameOverlayColors[qualityName] or quality ~= ItemQualityNormal and (ItemQualityColors[qualityName] or ItemQualityColors[quality])) or false

		if overlayColor then
			overlay:setOn(true)
			overlay:setImageColor(overlayColor)
		else
			overlay:setOn(false)
		end

		local hasFrame = self.hasFrame and quality and quality >= ITEM_GRADE_LEGENDARY

		frame:setOn(hasFrame)
		frame:setImageSource(hasFrame and ItemQualityFrames[quality] or "")
	end

	if self.isInfusion or self.isWarforge then
		self.placeholder:setVisible(not self:getItem())

		if self.isInfusion then
			local parent = self:getParent()

			if self:getItem() then
				parent.progress_bg:setOn(true)
			else
				parent.progress_bg:setOn(false)
			end
		end
	end

	self:setFishingBait(item and item:isActiveFishingBait())
	self:setSoulbound(item and item:isSoulbound())
	self:setExpirationTime(item and item:getExpirationTime() or 0)
end

function UIItem:onDoubleClick(mousePos)
	if lastQuickItemAction > g_clock.millis() or self:isVirtual() or not self:isDraggable() then
		return
	end

	local item = self:getItem()

	if not item then
		return
	end

	local parent = self:getParent()

	if parent and parent:getId() == "item_holder" then
		local infusionModule = modules.game_infusion.GameInfusion
		local widget = infusionModule:getFirstEmptySlot()

		if widget then
			for _, func in ipairs(widget.onDrop) do
				func(widget, self)
			end
		end
	end

	lastQuickItemAction = g_clock.millis() + 400

	if g_keyboard.isAltPressed() then
		modules.game_interface.removeConfirm(item)

		return
	end
end

function UIItem:onMousePress(mousePos, button)
	if button ~= MouseRightButton or lastQuickItemAction > g_clock.millis() or self:isVirtual() or not self:isDraggable() then
		return
	end

	local item = self:getItem()

	if not item then
		return
	end

	lastQuickItemAction = g_clock.millis() + 400

	local parent = item:getParentContainer()

	if parent then
		local type = parent:getType()

		if type == CONTAINER_TYPE_HOUSE_DEPOT or type == CONTAINER_TYPE_DEPOT then
			moveItemToContainerType(item, {
				[CONTAINER_TYPE_INVENTORY] = true
			}, {
				bestContainer = true
			})
		elseif type == CONTAINER_TYPE_INVENTORY then
			if g_keyboard.isShiftPressed() then
				moveItemToContainerType(item, {
					[CONTAINER_TYPE_DEPOT] = true,
					[CONTAINER_TYPE_HOUSE_DEPOT] = true
				}, {
					bestContainer = true
				})
			else
				moveItemToEquipped(item)
			end
		end

		return
	end

	local player = g_game.getLocalPlayer()
	local isEquipped = player:getInventoryItem(item:getPosition().y)

	if isEquipped then
		moveItemToContainerType(item, {
			[CONTAINER_TYPE_INVENTORY] = true
		}, {
			bestContainer = true
		})
	end
end

function UIItem:isTradepack()
	return self.tooltipInfo
end

function UIItem:setFishingBait(isBait)
	if not self.hasProfessionIcon then
		return
	end

	if self.fishingProfessionIcon then
		self.fishingProfessionIcon:setVisible(isBait)
	end
end

function UIItem:setSoulbound(isSoulbound)
	if self.soulboundIcon then
		self.soulboundIcon:setVisible(isSoulbound)
	end
end

function UIItem:setExpirationTime(expirationTime)
	if self.expirationTime then
		self.expirationTime:setVisible(expirationTime and expirationTime > 0)

		if expirationTime and expirationTime > 0 then
			local timeNow = os.time(os.date("*t"))
			local timeRemaining = expirationTime - timeNow

			if timeRemaining > 0 then
				local daysRemaining = math.floor(timeRemaining / 86400)
				local hoursRemaining = math.floor(timeRemaining % 86400 / 3600)
				local minutesRemaining = math.floor(timeRemaining % 3600 / 60)

				if daysRemaining > 0 then
					self.expirationTime:setText(string.format("%dd", daysRemaining))
				elseif hoursRemaining > 0 then
					self.expirationTime:setText(string.format("%dh", hoursRemaining))
				else
					self.expirationTime:setText(string.format("%dm", minutesRemaining))
				end
			else
				self.expirationTime:setText("0m")
			end
		end
	end
end
