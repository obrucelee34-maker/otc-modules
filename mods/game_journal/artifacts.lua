-- chunkname: @/modules/game_journal/artifacts.lua

GameJournal.artifacts = {
	panels = {},
	fairyWidgets = {}
}

function GameJournal:initArtifacts()
	self.artifacts.window = self.artifact_panel
	GameJournal.artifacts.panels.overview = self.artifacts.window.overview_panel

	local left_panel = self.artifacts.window.left_panel

	for _, regionName in ipairs(cfg.artifacts.order) do
		local widget = g_ui.createWidget("GameJournalArtifactsPanelLeftPanelItem", left_panel)

		widget:setId(regionName:gsub(" ", "_"):lower())

		function widget:onClick()
			GameJournal:selectArtifactTab(widget:getId())
		end

		widget.name:setText(regionName)
		widget.icon_holder.icon_background:setImageSource("/images/ui/windows/journal/artifacts/small_icons/" .. regionName:gsub(" ", "_"):lower() .. "_on.png")
		widget.icon_holder.icon:setImageSource("/images/ui/windows/journal/artifacts/small_icons/" .. regionName:gsub(" ", "_"):lower() .. "_off.png")
		widget.icon_holder.icon:update()
		widget.icon_holder.icon_background:update()
		self:setArtifactIconProgress(widget, 0)

		local overviewWidgetEntry = g_ui.createWidget("GameJournalArtifactsPanelOverviewPanelItem", self.artifacts.panels.overview.content_panel)

		overviewWidgetEntry:setId(regionName:gsub(" ", "_"):lower())
		overviewWidgetEntry.name:setText(regionName)
		overviewWidgetEntry.icon_holder.icon_background:setImageSource("/images/ui/windows/journal/artifacts/big_icons/" .. regionName:gsub(" ", "_"):lower() .. "_on.png")
		overviewWidgetEntry.icon_holder.icon:setImageSource("/images/ui/windows/journal/artifacts/big_icons/" .. regionName:gsub(" ", "_"):lower() .. "_off.png")
		overviewWidgetEntry.icon_holder.icon:update()
		overviewWidgetEntry.icon_holder.icon_background:update()
		self:setArtifactIconProgress(overviewWidgetEntry, 0)

		function overviewWidgetEntry:onClick()
			GameJournal:selectArtifactTab(widget:getId())
		end

		local contentPanel = g_ui.createWidget("GameJournalArtifactsPanelContentPanel", self.artifacts.window)

		self.artifacts.panels[widget:getId()] = contentPanel

		contentPanel:setId(regionName:gsub(" ", "_"):lower())
		contentPanel.top_panel.title.text_holder.text:setText(regionName)
		contentPanel.top_panel.title.icon_holder.icon_background:setImageSource("/images/ui/windows/journal/artifacts/medium_icons/" .. regionName:gsub(" ", "_"):lower() .. "_on.png")
		contentPanel.top_panel.title.icon_holder.icon:setImageSource("/images/ui/windows/journal/artifacts/medium_icons/" .. regionName:gsub(" ", "_"):lower() .. "_off.png")
		contentPanel.top_panel.title.icon_holder.icon:update()
		contentPanel.top_panel.title.icon_holder.icon_background:update()
		self:setArtifactIconProgress(contentPanel.top_panel.title, 0)

		local rewardPanel = g_ui.createWidget("GameJournalArtifactsPanelMiddlePanel", contentPanel.content_panel)
		local config = cfg.artifacts.regions[regionName]

		if config then
			if config.type == cfg.PROGRESSION_TYPE_CUMULATIVE then
				for index, reward in ipairs(config.rewards) do
					local rewardWidget = g_ui.createWidget("GameJournalArtifactsPanelMiddlePanelCumulativeEntry", rewardPanel.content_panel)

					rewardWidget.description:setText(tr(reward.description))
					rewardWidget.requirement:setText(string.format("[0/%d]", reward.requirement))
					rewardWidget:setImageSource()
					rewardWidget.locate_button:setVisible(false)
					rewardWidget.fairy_button:setVisible(false)
					rewardWidget.icon_holder.icon:setImageSource(string.format("/images/ui/windows/journal/artifacts/small_icons/%s.png", config.artifact_icon or reward.artifact_icon))

					local dummyWidget = g_ui.createWidget("GameJournalArtifactsPanelMiddlePanelCumulativeEntry", rewardPanel.dummy_background_panel)

					dummyWidget.description:setText(tr(reward.description))
					dummyWidget.requirement:setText(string.format("[0/%d]", reward.requirement))
					dummyWidget.locate_button:hide()
					dummyWidget.fairy_button:hide()
					self:setArtifactRewardCompletion(regionName, index, false)
				end

				local acquirePanel = g_ui.createWidget("GameJournalArtifactsPanelRightPanel", contentPanel.content_panel)
				local scrollBar = g_ui.createWidget("GameJournalArtifactsPanelRightPanelScrollBar", contentPanel.content_panel)

				scrollBar:setId("scrollBar")
				acquirePanel:setVerticalScrollBar(scrollBar)

				for index, acquire in ipairs(config.acquire) do
					local acquireWidget = g_ui.createWidget("GameJournalArtifactsPanelRightPanelEntry", acquirePanel)

					acquireWidget.description:setText(acquire.limit > 1 and string.format("[x%d] %s", acquire.limit, tr(acquire.description)) or tr(acquire.description))
					acquireWidget.index:setText(string.format("%d.", index))

					function acquireWidget.locate_button.onClick()
						self:displayArtifactAcquireLocation(regionName, index, config)
					end

					acquireWidget.locate_button:setVisible(acquire.positions)
				end

				acquirePanel:getFirstChild().icon:setImageSource(string.format("/images/ui/windows/journal/artifacts/small_icons/%s.png", config.artifact_icon))
			elseif config.type == cfg.PROGRESSION_TYPE_NON_CUMULATIVE then
				for index, reward in ipairs(config.rewards) do
					local rewardWidget = g_ui.createWidget("GameJournalArtifactsPanelMiddlePanelNonCumulativeEntry", rewardPanel.content_panel)

					rewardWidget.text_holder.description:setText(tr(reward.description))
					rewardWidget.icon_holder.icon:setImageSource(string.format("/images/ui/windows/journal/artifacts/small_icons/%s.png", config.artifact_icon or reward.artifact_icon))

					if reward.total_artifacts then
						rewardWidget.requirement:setText(string.format("[%d/%d]", 0, reward.total_artifacts))
					else
						rewardWidget.requirement:setText()
					end

					rewardWidget.text_holder.subdescription:setText(tr(config.acquire[index].description))
					rewardWidget.locate_button:setVisible(reward.position)
					rewardWidget.fairy_button:setVisible(false)
					self:setArtifactRewardCompletion(regionName, index, false)
				end

				rewardPanel:addAnchor(AnchorRight, "parent", AnchorRight)
			end
		end
	end

	self:selectArtifactTab("overview")
end

function GameJournal.artifactsOnGameEnd()
	GameJournal.progress = nil
	GameJournal.completed_objectives = nil
	GameJournal.artifacts.fairyWidgets = {}
end

function GameJournal:setArtifactIconProgress(widget, progressPercent)
	local icon_background = widget.icon_holder.icon_background

	if progressPercent == 0 then
		icon_background:hide()
	else
		icon_background:show()
	end

	local height = icon_background:getHeight()

	if math.floor(height * progressPercent / 100) == 0 then
		icon_background:hide()
	else
		local width = icon_background:getWidth()
		local y = height - height * progressPercent / 100
		local rect = {
			x = 0,
			y = y,
			width = width,
			height = height - y
		}

		icon_background:setImageClip(rect)
		icon_background:setImageRect(rect)
	end

	if widget.progress then
		widget.progress:setText(progressPercent .. "%")
	elseif widget.progress_text then
		widget.progress_text:setColoredText(GetHighlightedText(string.format("{(|%d%%| completed), |%s|}", progressPercent, progressPercent == 100 and "#36F991" or "#A6AAB2")))
	elseif widget.text_holder then
		widget.text_holder.progress_text:setColoredText(GetHighlightedText(string.format("{(|%d%%| completed), |%s|}", progressPercent, progressPercent == 100 and "#36F991" or "#A6AAB2")))
	end
end

function GameJournal:selectArtifactTab(tabName)
	local widgetToSelect = self.artifacts.window.left_panel:getChildById(tabName:lower())

	if not widgetToSelect then
		return
	end

	if self.artifacts.selectedTab then
		self.artifacts.selectedTab:setOn(false)
	end

	if self.artifacts.selectedPanel then
		self.artifacts.selectedPanel:hide()
	end

	widgetToSelect:setOn(true)

	self.artifacts.selectedTab = widgetToSelect
	self.artifacts.selectedPanel = self.artifacts.panels[tabName]

	self.artifacts.selectedPanel:show()
end

function GameJournal:setArtifactRewardCompletion(regionName, rewardIndex, state, progressAmount)
	if state then
		if not self.completed_objectives then
			self.completed_objectives = {}
		end

		if not self.completed_objectives[regionName:lower()] then
			self.completed_objectives[regionName:lower()] = {}
		end

		self.completed_objectives[regionName:lower()][rewardIndex] = true
	end

	local panel = self.artifacts.panels[regionName:gsub(" ", "_"):lower()]

	if not panel then
		return
	end

	local rewardPanel = panel.content_panel.middle_panel.content_panel
	local rewardWidget = rewardPanel:getChildByIndex(rewardIndex)

	if not rewardWidget then
		return
	end

	local config = cfg.artifacts.regions[regionName:titleCase()]

	rewardWidget.icon_holder:setOn(state)

	if rewardWidget.description then
		rewardWidget.description:setOn(state)
	end

	rewardWidget.requirement:setOn(state)
	rewardWidget.locate_button:setVisible(state and (config.rewards[rewardIndex].position or config.rewards[rewardIndex].positions))

	function rewardWidget.locate_button.onClick()
		self:displayArtifactRewardLocation(regionName, rewardIndex, config)
	end

	local fairy = state and config.rewards[rewardIndex].fairy

	if fairy then
		self.artifacts.fairyWidgets[regionName:lower()] = rewardWidget
	end

	rewardWidget.fairy_button:setVisible(fairy)

	function rewardWidget.fairy_button.onClick(widget)
		if widget:isVisible() then
			self:displayArtifactFairyLocation(regionName, rewardIndex, config)
		end
	end

	if config.type == cfg.PROGRESSION_TYPE_CUMULATIVE then
		local dummyPanel = panel.content_panel.middle_panel.dummy_background_panel
		local dummyWidget = dummyPanel:getChildByIndex(rewardIndex)

		if not dummyWidget then
			return
		end

		if progressAmount then
			rewardWidget.requirement:setText(string.format("[%d/%d]", progressAmount, config.rewards[rewardIndex].requirement))
			dummyWidget.requirement:setText(string.format("[%d/%d]", progressAmount, config.rewards[rewardIndex].requirement))
		end

		local progressionPanel = panel.content_panel.middle_panel.progression_panel
		local progress_holder = progressionPanel.progress_holder
		local background = progress_holder.background
		local progress = progress_holder.fill
		local totalRewards = #config.rewards
		local height = 0

		for i = 1, totalRewards do
			local rewardWidget = rewardPanel:getChildByIndex(i)

			if rewardWidget then
				height = height + rewardWidget:getHeight()

				rewardWidget.icon_holder:raise()
			end
		end

		height = height + rewardPanel:getLayout():getSpacing() * (totalRewards - 1) - 12

		progress_holder:setHeight(height)
		background:setHeight(height)

		height = 0

		local totalCompleted = 0

		for i = 1, totalRewards do
			local rewardWidget = rewardPanel:getChildByIndex(i)

			if rewardWidget and rewardWidget.icon_holder:isOn() then
				totalCompleted = totalCompleted + 1
				height = height + rewardWidget:getHeight()
			end
		end

		height = height + rewardPanel:getLayout():getSpacing() * (totalCompleted - 1) - 12

		progress:setHeight(height)
	elseif config.type == cfg.PROGRESSION_TYPE_NON_CUMULATIVE then
		local progressionPanel = panel.content_panel.middle_panel.progression_panel

		progressionPanel:hide()

		local limit = config.rewards[rewardIndex].total_artifacts

		if progressAmount and limit then
			rewardWidget.requirement:setText(string.format("[%d/%d]", math.min(limit, progressAmount), limit))
		end
	end
end

function GameJournal:setArtifactAcquireProgress(regionName, index, remaining, ignoreProgressChange)
	local panel = self.artifacts.panels[regionName:gsub(" ", "_"):lower()]

	if not panel then
		return
	end

	local acquirePanel = panel.content_panel.right_panel
	local config = cfg.artifacts.regions[regionName:titleCase()]

	if not config then
		return
	end

	local acquire = config.acquire[index]

	if not acquire then
		return
	end

	local acquireWidget = acquirePanel:getChildByIndex(index + 1)

	if not acquireWidget then
		return
	end

	if remaining == 0 then
		if not ignoreProgressChange then
			acquireWidget.progress:setTextColor("#36F991")
			acquireWidget.progress:setText(tr("[Completed]"))
			acquireWidget.description:updateSize(true)
		end

		acquireWidget.icon:setOn(true)

		return
	end

	acquireWidget.icon:setOn(false)

	if not ignoreProgressChange then
		acquireWidget.progress:setTextColor("#FFA851")
		acquireWidget.progress:setText(tr(string.format("[|%s| remaining]", remaining)))
		acquireWidget.description:updateSize(true)
	end
end

function GameJournal:setupArtifactInfo(info)
	local regionName = cfg.regionIdToName[info.id]
	local config = cfg.artifacts.regions[regionName]

	if not config then
		return
	end

	local totalObtained = 0
	local fullyCompleted = 0

	if #info.objectives > 0 then
		for index, objective in ipairs(info.objectives) do
			if config.type == cfg.PROGRESSION_TYPE_CUMULATIVE then
				totalObtained = totalObtained + objective.progress

				self:setArtifactAcquireProgress(regionName, index, objective.limit - objective.progress, objective.limit == 1)
			elseif objective.limit == objective.progress then
				self:setArtifactRewardCompletion(regionName, index, true, fullyCompleted)

				fullyCompleted = fullyCompleted + 1
			else
				self:setArtifactRewardCompletion(regionName, index, false, fullyCompleted)
			end
		end
	elseif config.type == cfg.PROGRESSION_TYPE_CUMULATIVE then
		for index, objective in ipairs(config.acquire) do
			self:setArtifactAcquireProgress(regionName, index, objective.limit, objective.limit == 1)
		end
	else
		for index, objective in ipairs(config.rewards) do
			self:setArtifactRewardCompletion(regionName, index, false)
		end
	end

	for index, reward in ipairs(config.rewards) do
		if config.type == cfg.PROGRESSION_TYPE_CUMULATIVE then
			if totalObtained >= reward.requirement then
				self:setArtifactRewardCompletion(regionName, index, true, reward.requirement)

				fullyCompleted = fullyCompleted + 1
			else
				self:setArtifactRewardCompletion(regionName, index, false, totalObtained)
			end
		end
	end

	self:setArtifactionRegionIconProgress(regionName, math.floor(fullyCompleted / #config.rewards * 100))

	if not self.progress then
		self.progress = {}
	end

	self.progress[info.id] = totalObtained
	self.progress[regionName:lower()] = totalObtained
end

function GameJournal:setArtifactionRegionIconProgress(regionName, progress)
	local regionStringId = regionName:gsub(" ", "_"):lower()
	local widgets = {
		self.artifacts.window.left_panel:getChildById(regionStringId),
		self.artifacts.panels.overview.content_panel:getChildById(regionStringId),
		self.artifacts.panels[regionStringId].top_panel.title
	}

	for _, widget in ipairs(widgets) do
		self:setArtifactIconProgress(widget, progress)
	end
end

function GameJournal:displayArtifactRewardLocation(regionName, rewardIndex, config)
	local reward = config.rewards[rewardIndex]
	local positions = reward.position and {
		reward.position
	} or reward.positions

	if not positions then
		return
	end

	for index, position in ipairs(positions) do
		if not position.callback or position.callback() then
			local flag = g_worldMap.addCompassHighlight({
				pos = position,
				compassSize = position.size
			}, reward.description, index, "", true)

			flag.floorInfo = position.floorInfo

			connect(g_worldMap.window, {
				onVisibilityChange = function(widget, visible)
					if not visible then
						g_worldMap.removeCompassHighlight(flag)
					end
				end
			})
		end
	end

	g_worldMap.displayQuestTaskCompass(reward.description)
end

function GameJournal:displayArtifactAcquireLocation(regionName, acquireIndex, config)
	local acquire = config.acquire[acquireIndex]
	local positions = acquire.position and {
		acquire.position
	} or acquire.positions

	if not positions then
		return
	end

	for index, position in ipairs(positions) do
		if not position.callback or position.callback() then
			local flag = g_worldMap.addCompassHighlight({
				pos = position,
				compassSize = position.size
			}, acquire.description, index, "", true)

			flag.floorInfo = position.floorInfo

			connect(g_worldMap.window, {
				onVisibilityChange = function(widget, visible)
					if not visible then
						g_worldMap.removeCompassHighlight(flag)
					end
				end
			})
		end
	end

	g_worldMap.displayQuestTaskCompass(acquire.description)
end

function GameJournal:getArtifactImageSource(regionId, objectiveId)
	local config = cfg.artifacts.regions[cfg.regionIdToName[regionId]]

	if not config then
		return
	end

	local icon
	local objective = config.acquire[objectiveId]

	if objective then
		icon = objective.artifact_icon
	end

	local reward = config.rewards[objectiveId]

	if reward then
		icon = reward.artifact_icon
	end

	icon = icon or config.artifact_icon

	return string.format("/images/ui/windows/journal/artifacts/small_icons/%s.png", icon)
end

function GameJournal:getArtifactName(regionId, objectiveId)
	local config = cfg.artifacts.regions[cfg.regionIdToName[regionId]]

	if not config then
		return
	end

	local name
	local objective = config.acquire[objectiveId]

	if objective then
		name = objective.artifact_name
	end

	local reward = config.rewards[objectiveId]

	if reward then
		name = reward.artifact_name
	end

	name = name or config.artifact_name

	return name
end

function GameJournal:getArtifactRegionProgress(regionNameOrId)
	if not self.progress then
		return 0
	end

	local regionName = cfg.regionIdToName[regionNameOrId] and cfg.regionIdToName[regionNameOrId]:lower() or regionNameOrId:lower()

	return self.progress[regionName] or 0
end

function GameJournal:hasCompletedArtifactObjective(regionNameOrId, objectiveId)
	if not self.completed_objectives then
		return false
	end

	local regionName = cfg.regionIdToName[regionNameOrId] and cfg.regionIdToName[regionNameOrId]:lower() or regionNameOrId:lower()

	return self.completed_objectives[regionName] and self.completed_objectives[regionName][objectiveId]
end

function GameJournal:displayArtifactFairyLocation(regionName, acquireIndex, config)
	local reward = config.rewards[acquireIndex]
	local fairy = reward and reward.fairy

	if not fairy then
		return
	end

	for index, position in ipairs(fairy.positions) do
		if not position.callback or position.callback() then
			local flag = g_worldMap.addCompassHighlight({
				pos = position,
				compassSize = position.size
			}, fairy.description, index, "", true)

			flag.floorInfo = position.floorInfo

			connect(g_worldMap.window, {
				onVisibilityChange = function(widget, visible)
					if not visible then
						g_worldMap.removeCompassHighlight(flag)
					end
				end
			})
		end
	end

	g_worldMap.displayQuestTaskCompass(fairy.description)
end

function GameJournal:updateArtifactFairyButtons(regions)
	for _, widget in pairs(self.artifacts.fairyWidgets) do
		widget.fairy_button:setEnabled(true)
	end

	for region in pairs(regions or {}) do
		local widget = Regions[region] and self.artifacts.fairyWidgets[Regions[region].name:lower()]

		if widget then
			widget.fairy_button:setEnabled(false)
		end
	end
end
