-- chunkname: @/modules/game_spelltree/tree.lua

GameSpellTree.tree = {
	cfg = {
		numRows = 5,
		numColumns = 5,
		archetypes = {
			[ArchetypeWizardry] = {
				0,
				1,
				0,
				2,
				0,
				0,
				3,
				0,
				4,
				0,
				11,
				5,
				0,
				6,
				12,
				0,
				7,
				0,
				8,
				0,
				0,
				9,
				0,
				10,
				0
			},
			[ArchetypeHoly] = {
				0,
				1,
				0,
				2,
				0,
				0,
				3,
				4,
				5,
				0,
				0,
				6,
				7,
				8,
				0,
				0,
				9,
				0,
				10,
				0,
				0,
				11,
				0,
				12,
				0
			},
			[ArchetypeArchery] = {
				0,
				0,
				1,
				0,
				0,
				0,
				2,
				3,
				4,
				0,
				0,
				5,
				6,
				7,
				0,
				0,
				8,
				9,
				10,
				0,
				0,
				11,
				0,
				12,
				0
			},
			[ArchetypeWarfare] = {
				0,
				0,
				1,
				0,
				0,
				0,
				2,
				0,
				3,
				0,
				4,
				5,
				6,
				7,
				0,
				0,
				8,
				9,
				10,
				0,
				0,
				11,
				0,
				12,
				0
			},
			[ArchetypeProtection] = {
				0,
				0,
				1,
				0,
				0,
				0,
				2,
				3,
				4,
				0,
				0,
				5,
				6,
				7,
				0,
				0,
				8,
				9,
				10,
				0,
				0,
				11,
				0,
				12,
				0
			},
			[ArchetypeShadow] = {
				0,
				0,
				1,
				0,
				0,
				0,
				2,
				0,
				3,
				0,
				4,
				5,
				6,
				7,
				0,
				0,
				8,
				9,
				10,
				0,
				0,
				11,
				0,
				12,
				0
			},
			[ArchetypeSpiritual] = {
				0,
				0,
				1,
				0,
				0,
				0,
				2,
				3,
				4,
				0,
				0,
				5,
				6,
				7,
				0,
				0,
				8,
				9,
				10,
				0,
				0,
				11,
				0,
				12,
				0
			},
			[ArchetypeWitchcraft] = {
				0,
				0,
				1,
				0,
				2,
				0,
				0,
				3,
				0,
				4,
				0,
				0,
				5,
				6,
				7,
				0,
				0,
				8,
				0,
				9,
				0,
				0,
				10,
				11,
				12
			}
		},
		connections = {}
	}
}
GameSpellTree.archetypeBuilds = {
	initialSize = 1,
	baseRavencoinCost = 750,
	maxSlotsUnlocked = 10,
	baseSilverUnlockCost = {
		100,
		25000,
		100000,
		250000,
		500000,
		500000,
		500000,
		500000,
		500000
	}
}

function GameSpellTree:createTreePanel(archetypeId, parent)
	local panel = g_ui.createWidget("ArchetypeTree", parent)
	local archetypeName = ArchetypeNames[archetypeId]:lower()

	panel:setId(string.format("%sTree", archetypeName))

	local cfg = self.tree.cfg
	local spells = cfg.archetypes[archetypeId]
	local connections = cfg.connections[archetypeId]
	local emptyColumns = {}
	local numEmptyColumns = 0

	for column = 1, cfg.numColumns do
		local empty = true

		for row = 1, cfg.numRows do
			if spells[(row - 1) * cfg.numColumns + column] ~= 0 then
				empty = false

				break
			end
		end

		if empty then
			emptyColumns[column] = true
			numEmptyColumns = numEmptyColumns + 1
		end
	end

	local spellsPanel = panel.spellsPanel
	local spacingColumn, spacingRow = 30, 30

	for i = 1, #spells do
		local widgetId = string.format("spell%d", spells[i])

		if connections then
			local connectionsIndexed = {}

			for _, data in ipairs(connections) do
				connectionsIndexed[data.from] = data.to
			end

			if connectionsIndexed[spells[i]] then
				local isConnectionDiagonal = type(connectionsIndexed[spells[i]]) == "table"
				local link

				if not isConnectionDiagonal then
					link = g_ui.createWidget("SpellLinkVertical", spellsPanel)

					link:addAnchor(AnchorHorizontalCenter, widgetId, AnchorHorizontalCenter)
					link:addAnchor(AnchorTop, widgetId, AnchorBottom)
					link:addAnchor(AnchorBottom, string.format("spell%d", connectionsIndexed[spells[i]]), AnchorTop)
					link:setId(string.format("%slink", widgetId, spells[i]))
				else
					for index, data in ipairs(connectionsIndexed[spells[i]]) do
						link = g_ui.createWidget("SpellLinkDiagonal", spellsPanel)

						local linkParentId = string.format("spell%d", data.link)
						local reverseAnchors = connectionsIndexed[spells[i]][index].reverseAnchors
						local anchorLeft, anchorTop, anchorRight, anchorBottom = AnchorLeft, AnchorTop, AnchorRight, AnchorBottom

						if reverseAnchors then
							anchorLeft, anchorTop, anchorRight, anchorBottom = AnchorRight, AnchorBottom, AnchorLeft, AnchorTop
						end

						if not reverseAnchors and index == 1 or reverseAnchors and index == 2 then
							link:addAnchor(anchorLeft, widgetId, AnchorHorizontalCenter)
							link:addAnchor(anchorTop, linkParentId, AnchorVerticalCenter)
							link:addAnchor(anchorRight, linkParentId, AnchorHorizontalCenter)
							link:addAnchor(anchorBottom, widgetId, AnchorVerticalCenter)
							link:setId(string.format("%slink1", linkParentId))
						elseif not reverseAnchors and index == 2 or reverseAnchors and index == 1 then
							link:addAnchor(anchorRight, linkParentId, AnchorHorizontalCenter)
							link:addAnchor(anchorBottom, linkParentId, AnchorVerticalCenter)
							link:addAnchor(anchorLeft, widgetId, AnchorHorizontalCenter)
							link:addAnchor(anchorTop, widgetId, AnchorVerticalCenter)
							link:setRotation(data.rotation or 0)
							link:setId(string.format("%slink1", linkParentId))
						end
					end
				end
			end
		end
	end

	for i = 1, #spells do
		local row = math.floor((i - 1) / cfg.numColumns)
		local column = (i - 1) % cfg.numColumns
		local widgetId = string.format("spell%d", spells[i])
		local widget = g_ui.createWidget("ArchetypeSpell", spellsPanel)

		g_ui.createWidget("ArchetypeSpellOverlay", widget)
		widget:setId(widgetId)

		widget.archetypeId = archetypeId

		widget:setEnabled(false)
		widget:addAnchor(AnchorLeft, "parent", AnchorLeft)
		widget:addAnchor(AnchorTop, "parent", AnchorTop)

		local numNonEmptyColumns = cfg.numColumns - numEmptyColumns
		local emptyColumnsOffset = 0

		for j = 1, column do
			if emptyColumns[j] then
				emptyColumnsOffset = emptyColumnsOffset + 1
			end
		end

		local marginLeft = (spellsPanel:getWidth() - numNonEmptyColumns * widget:getWidth() - (numNonEmptyColumns - 1) * spacingColumn) / 2

		marginLeft = marginLeft + (column - emptyColumnsOffset) * widget:getWidth() + (column - emptyColumnsOffset) * spacingColumn

		local marginTop = row * widget:getHeight() + row * spacingRow

		widget:setMarginTop(marginTop)
		widget:setMarginLeft(marginLeft)
	end
end
