-- chunkname: @/modules/game_questlog/dynamic_event.lua

DynamicEvent = {}

function DynamicEvent:init()
	g_ui.importStyle("styles/dynamic_event")

	local HUDPanel = modules.game_interface.getHUDPanel()

	self.window = g_ui.createWidget("DynamicEventWindow", HUDPanel)
	self.content = self.window:getChildById("content")
	self.window.onDragEnter = DynamicEvent.onDragEnter
	self.window.onDragMove = DynamicEvent.onDragMove

	if g_game.isOnline() then
		update()
	end
end

function DynamicEvent:test()
	self.content.header:hide()
end

function DynamicEvent:terminate()
	if self.timerEvent then
		removeEvent(self.timerEvent)

		self.timerEvent = nil
	end

	if self.moveEvent then
		removeEvent(self.moveEvent)

		self.moveEvent = nil
	end

	self.window:destroy()

	self.window = nil
end

function DynamicEvent:parseOpcode()
	return
end

function DynamicEvent:hide(cleanActiveEvent)
	if self.timerEvent then
		removeEvent(self.timerEvent)

		self.timerEvent = nil
	end

	g_effects.fadeOut(self.window.content, 1000, nil, false, function()
		self.window.content:hide()
	end)
	g_effects.fadeOut(self.window.toggleButton, 1000)

	if cleanActiveEvent then
		self.activeEvent = nil
	end
end

function DynamicEvent:parseData(action, events)
	if events.remove then
		self:hide(true)

		return
	end

	local event = events[1]

	if not event then
		self:hide(true)

		return
	end

	if not event.tasks then
		self:hide(true)

		return
	end

	local entry = event.tasks[1]

	if not entry then
		self:hide(true)

		return
	end

	local opened = self.window.content:isVisible() and not g_effects.isFading(self.window.content)

	self.activeEvent = event

	self:updateHeaderAndDescription(entry, event.name)
	self:updateProgress(entry)
	self:updateRewards(entry)
	self:updateTimer(entry)
	self:updateLevelSync(entry, event.name)

	if not opened then
		self.window:show()
		self.window.content:show()
		self:minimize()
		g_effects.fadeIn(self.window.content, 1000, nil, false, function()
			self.window:raise()
		end)
		g_effects.fadeIn(self.window.toggleButton, 1000)
		g_sound.play(CONST_SE_DYNAMIC_EVENT_STARTING)
	end
end

function DynamicEvent:updateHeaderAndDescription(entry, eventName)
	self.content.header:show()
	self.content.header.title:setText(eventName)
	self.content.header.title:setColoredText(GetHighlightedText(string.format("{[%s], white} {%s, #36F991}", entry.level, self.content.header.title:getText())))
	self.content.description:setText(entry.description)
end

function DynamicEvent:updateLevelSync(entry, eventName)
	if entry.levelSync ~= nil then
		self.content.header.syncButton:setOn(entry.levelSync)
		self.content.header.syncButton:show()

		function self.content.header.syncButton.onClick()
			modules.game_interface.sendOpcode(ExtendedIds.Quest, {
				type = "dynamic_event",
				action = entry.levelSync and "request_level_sync" or "request_level_unsync",
				eventName = eventName
			})
		end
	else
		self.content.header.syncButton:hide()
	end
end

function DynamicEvent:updateRewards(entry)
	if entry.scarcity and entry.scarcity > 0 then
		self.content.rewards.scarcity:setHeight(145)
		self.content.rewards.scarcity:show()
		self.content.rewards.list:hide()

		return
	end

	self.content.rewards.scarcity:hide()

	if entry.rewards then
		self.content.rewards.list:destroyChildren()
		self.content.rewards.list:show()

		if entry.rewards.experience then
			local reward = g_ui.createWidget("DynamicEventRewardItem", self.content.rewards.list)

			reward.item:setImageSource("/images/ui/icons/experience")
			reward.count:setText(format_number(entry.rewards.experience))
			reward.name:setText("Experience")
			reward:setId("experience")
		end

		if entry.rewards.silver then
			local reward = g_ui.createWidget("DynamicEventRewardItem", self.content.rewards.list)

			reward.item:setImageSource("/images/ui/icons/silver")
			reward.count:setText(format_number(entry.rewards.silver))
			reward.name:setText("Silver")
			reward:setId("silver")
		end

		if entry.rewards.professionExperience then
			for professionId = ProfessionFirst, ProfessionLast do
				if entry.rewards.professionExperience[professionId] then
					local name = ProfessionNames[professionId]
					local reward = g_ui.createWidget("DynamicEventRewardItem", self.content.rewards.list)

					reward.item:setImageSource(string.format("/images/ui/icons/%s", name:lower()))
					reward.count:setText(format_number(entry.rewards.professionExperience[professionId]))
					reward.name:setText(name)
					reward:setId(name)
				end
			end
		end

		if entry.rewards.items then
			for _, item in ipairs(entry.rewards.items) do
				if not item.hideReward then
					local reward = g_ui.createWidget("DynamicEventRewardItem", self.content.rewards.list)

					if item.customName then
						reward.item:setImageSource(string.format("/images/ui/windows/questlog/custom_reward_icons/%s", item.customName))
						reward.name:setText(item.customName:titleCase())
						reward.name:setTooltip(item.customName:titleCase())
					else
						reward.item:setItemId(item.clientId)
						reward.name:setText(item.name:titleCase())
						reward.name:setTooltip(item.name:titleCase())
					end

					if item.amount and not item.hideAmount then
						reward.count:setText(type(item.amount) == "table" and (item.amount.min and table.concat({
							item.amount.min,
							item.amount.max
						}, " - ") or table.concat(item.amount, " - ")) or item.amount)

						if reward.count:getText() == "" then
							reward.count:setText("0 - 1")
						end
					else
						reward.count:setVisible(false)
					end
				end
			end
		end
	end
end

function DynamicEvent:updateProgress(entry)
	self.content.progressInfo.current:setText(entry.name)

	if entry.progress and entry.progress ~= "" then
		self.content.progressInfo.current:setText(string.format("%s (%s%s)", self.content.progressInfo.current:getText(), entry.progress, tr(entry.progressString)))
	end

	if entry.eventProgress then
		self.content.progressInfo.total:setColoredText(GetHighlightedText(string.format("[{%d, #77D463} + {%d, #A556FF} / {%d, white}]", entry.eventProgress.personal or 0, entry.eventProgress.overall or 0, entry.eventProgress.goal)))
		self.content.progress:show()
		self.content.progress.overall:setPercent(math.floor(entry.eventProgress.overall / entry.eventProgress.goal * 100))

		if entry.eventProgress.personal then
			self.content.progress.individual:show()
			self.content.progress.individual:setPercent(math.floor(entry.eventProgress.personal / entry.eventProgress.goal * 100))
		else
			self.content.progress.individual:hide()
		end
	else
		self.content.progress:hide()
	end
end

function DynamicEvent:updateTimer(entry)
	if entry.remainingTime then
		local endTime = os.time() + entry.remainingTime

		self.content.timer.text:setText(SecondsToClock(entry.remainingTime))

		if self.timerEvent then
			removeEvent(self.timerEvent)

			self.timerEvent = nil
		end

		local function timerJob()
			if not self.content.timer then
				return
			end

			self.content.timer.text:setText(SecondsToClock(endTime - os.time()))

			self.timerEvent = scheduleEvent(function()
				local time = endTime - os.time()

				if time > 0 then
					timerJob()
				else
					self.timerEvent = nil
				end
			end, 1000)
		end

		timerJob()
	end
end

function DynamicEvent:isMinimized()
	return self.window.toggleButton:isOn()
end

function DynamicEvent:toggle()
	if self:isMinimized() then
		self:maximize()
	else
		self:minimize()
	end
end

function DynamicEvent:minimize()
	if self.moveEvent then
		removeEvent(self.moveEvent)

		self.moveEvent = nil
	end

	self.content.description:hide()
	self.content.progressInfo:hide()
	self.content.rewards:hide()
	self.window.toggleButton:setOn(true)
end

function DynamicEvent:maximize()
	self.content.description:show()
	self.content.progressInfo:show()
	self.content.rewards:show()
	self.window.toggleButton:setOn(false)

	if self.moveEvent then
		removeEvent(self.moveEvent)
	end

	self.moveEvent = scheduleEvent(function()
		local height = self.window:getHeight()
		local pos = self.window:getPosition()
		local parent = self.window:getParent()
		local parentHeight = parent:getHeight()

		if parentHeight < pos.y + height then
			self.window:setPosition({
				x = pos.x,
				y = parentHeight - height
			})
		end

		self.moveEvent = nil
	end, 10)
end

function DynamicEvent:onDragEnter(mousePos)
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

function DynamicEvent:onDragMove(mousePos, mouseMoved)
	local pos = {
		x = mousePos.x - self.movingReference.x,
		y = mousePos.y - self.movingReference.y
	}

	g_layout.snapToGrid(pos)
	self:setPosition(pos)
	self:bindRectToParent()
end

function DynamicEvent:update()
	local isEditMode = g_layout.isEditMode()

	self.window:recursiveGetChildById("editModeBackground"):setVisible(isEditMode)
	self.window:setPhantom(not isEditMode)
end
