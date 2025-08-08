-- chunkname: @/modules/game_chat/widgets/uimessageinput.lua

UIMessageInput = extends(UITextEdit, "MessageInput")

function UIMessageInput.create()
	local messageInput = UIMessageInput.internalCreate()

	return messageInput
end

function UIMessageInput:onSetup()
	self:updateAnchors()
end

function UIMessageInput:updateAnchors()
	local inputType = self:getParent().inputType

	if inputType:isVisible() then
		self:addAnchor(AnchorLeft, inputType:getId(), AnchorRight)
	else
		self:addAnchor(AnchorLeft, "leftSection", AnchorRight)
	end
end
