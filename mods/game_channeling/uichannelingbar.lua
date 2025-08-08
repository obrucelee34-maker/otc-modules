-- chunkname: @/modules/game_channeling/uichannelingbar.lua

UIChannelingBar = extends(UIWidget, "UIChannelingBar")

local interval = 1
local maxOffset = 1

function UIChannelingBar.create()
	local bar = UIChannelingBar.internalCreate()

	bar.fill = bar:recursiveGetChildById("fill")
	bar.event = nil

	return bar
end

function UIChannelingBar:setPercent(percent)
	local widget = self.fill

	if not widget.originalSize then
		widget.originalSize = widget:getSize()
	end

	widget:setWidth(math.ceil((self:getWidth() - 28) * percent / 100))
end
