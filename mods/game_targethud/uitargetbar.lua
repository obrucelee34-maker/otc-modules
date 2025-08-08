-- chunkname: @/modules/game_targethud/uitargetbar.lua

UITargetBar = extends(UIWidget, "UITargetBar")

function UITargetBar.create()
	local bar = UITargetBar.internalCreate()

	bar.event = nil

	return bar
end

function UITargetBar:setPercent(percent)
	local widget = self.fill

	if not widget.originalSize then
		widget.originalSize = widget:getSize()
	end

	widget:setWidth(math.ceil((self:getWidth() - 28) * percent / 100))
end

function UITargetBar:setName(name)
	self.name:setText(name)

	local stringSize = string.len(name)
	local averageWidthPerChar = self.name:getTextSize().width / stringSize

	if self.name:getTextSize().width > self.name:getWidth() then
		local amountToBeReduced = math.floor((self.name:getTextSize().width - self.name:getWidth()) / averageWidthPerChar) + 3

		self.name:setText(string.format("%s...", name:sub(1, stringSize - amountToBeReduced)))
	end
end

function UITargetBar:setIconTexture(texture)
	self.icon:setImageSource(texture)
end

function UITargetBar:setFrameTexture(frameTexture, glowTexture)
	local framePath = frameTexture.image
	local frameSize = frameTexture.size

	self.frame_overlay:setImageSource(framePath)
	self.frame_overlay:setSize(frameSize)

	if glowTexture then
		local glowPath = glowTexture.image
		local glowSize = glowTexture.size

		self.frame_glow_overlay:setImageSource(glowPath)
		self.frame_glow_overlay:setSize(glowSize)
	end
end

function UITargetBar:setFrameColor(color)
	self.frame_glow_overlay:setImageColor(color or "White")
end

function UITargetBar:setPortrait(creature)
	local outfit = creature:getOutfit()

	self.portrait:setOutfit(outfit)

	local size = self.portrait:getSize()
	local exactSize = math.max(TILE_SIZE, creature:getThingType():getExactSize())
	local scale = size.width / exactSize
	local offset = 4

	if exactSize > TILE_SIZE * 3 then
		scale = scale + 0.03
		offset = exactSize / 4
	elseif exactSize > TILE_SIZE * 2 then
		if creature:isPlayer() then
			scale = scale + 0.2
			offset = exactSize / 3.3
		else
			scale = scale + 0.25
			offset = exactSize / 2.8
		end
	else
		scale = scale + 0.05
	end

	self.portrait:setOutfitOffset({
		x = exactSize - TILE_SIZE - offset,
		y = exactSize - TILE_SIZE - offset
	})
	self.portrait:setOutfitScale(scale)
end
