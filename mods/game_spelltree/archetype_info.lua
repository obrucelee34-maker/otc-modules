-- chunkname: @/modules/game_spelltree/archetype_info.lua

GameArchetypeInfo = {}

local assets = ARCHETYPES_DATA

function GameArchetypeInfo.init()
	g_ui.importStyle("styles/archetype_info_modal.otui")

	GameArchetypeInfo.window = g_ui.createWidget("ArchetypeInfoModal", modules.game_interface.getHUDPanel())

	if not GameArchetypeInfo.window then
		print("Error >> Unable to Create the GameArchetypeInfo Window.")

		return
	end

	GameArchetypeInfo.window:hide()

	GameArchetypeInfo.skillsPanel = GameArchetypeInfo.window:recursiveGetChildById("skills_panel")
	GameArchetypeInfo.activeSkills = GameArchetypeInfo.skillsPanel.active_skills
	GameArchetypeInfo.passiveSkills = GameArchetypeInfo.skillsPanel.passive_skills
	GameArchetypeInfo.skillInfoPanel = GameArchetypeInfo.window:recursiveGetChildById("skill_information_panel")
	GameArchetypeInfo.skillInfo = GameArchetypeInfo.skillInfoPanel.content.info
	GameArchetypeInfo.skillPreview = GameArchetypeInfo.window:recursiveGetChildById("skill_preview")
	GameArchetypeInfo.backgroundPanel = GameArchetypeInfo.window:recursiveGetChildById("background_panel")
	GameArchetypeInfo.previewPanel = GameArchetypeInfo.window:recursiveGetChildById("preview_panel")
	GameArchetypeInfo.bottomPanel = GameArchetypeInfo.window:recursiveGetChildById("bottom_panel")
	GameArchetypeInfo.warningText = GameArchetypeInfo.bottomPanel.warning_text
end

function GameArchetypeInfo.terminate()
	if GameArchetypeInfo.window then
		GameArchetypeInfo.window:destroy()

		GameArchetypeInfo.window = nil
	end
end

function GameArchetypeInfo:selectArchetype(archetypeId)
	self.currentArchetypeId = archetypeId

	local archetypeName = assets[archetypeId].name

	self.window.top_panel.title:setText(archetypeName)
	self.window.top_panel.icon:setSize("20 20")
	self.window.top_panel.icon:setImageSource("/images/ui/icons/archetypes/20x20/" .. archetypeName:lower())
	self.backgroundPanel:setImageSource(string.format("/images/ui/windows/spelltree/archetype_backgrounds/%s", archetypeName:lower()))
	self.activeSkills:clearChildren()
	self.passiveSkills:clearChildren()

	for id, value in ipairs(assets[archetypeId].skills) do
		local skill = value.name:lower()
		local widget = g_ui.createWidget("ArchetypeInfoSkillToggle", self.activeSkills)

		widget:setId(skill)
		widget:setImageSource("/images/ui/icons/abilitybar/" .. skill)
	end

	for id, value in ipairs(assets[archetypeId].passives) do
		local skill = value.name:lower()
		local widget = g_ui.createWidget("ArchetypeInfoSkillToggle", self.passiveSkills)

		widget:setId(skill)
		widget:setImageSource("/images/ui/icons/abilitybar/" .. skill)
	end

	self.warningText:setColoredText(GetHighlightedText(tr(string.format("Are you sure you want to select {|%s|, #FFA851}?", archetypeName))))
	self:updateSkill(self.activeSkills:getFirstChild())
end

function GameArchetypeInfo:updateSkill(button)
	if button:isChecked() then
		return
	end

	if self.selectedSkillButton then
		self.selectedSkillButton:setChecked(false)
	end

	self.selectedSkillButton = button

	button:setChecked(true)

	local skill_name = button:getId()
	local spell, passiveName = g_spells:getSpell(skill_name)
	local isPassive = spell.id == nil

	if isPassive then
		spell = {
			name = passiveName:titleCase()
		}
	end

	self.skillInfo.icon:setImageSource(button:getImageSource())
	self.skillInfo.name:setText(spell.name)
	self.skillInfo.cast_type:setText(g_spells:getType(spell.name:lower()))
	self.skillInfo.target:setText(spell.crosshair and "Crosshair ability" or spell.needTarget and "Single target ability" or spell.selfTarget and not spell.needTarget and "Self target ability" or not spell.selfTarget and not spell.needTarget and "Self target ability")

	local description = g_spells:getSpellDescription(skill_name)

	if description then
		self.skillInfo.description_scrollable.description:setColoredText(GetHighlightedText(description))
	end

	self.previewPanel:setVisible(not isPassive)

	local path = "/data/images/ui/windows/spelltree/preview/" .. skill_name .. ".mp4"

	if g_resources.fileExists(path) or g_resources.fileExists(path .. ".mp4") then
		local lastSource = self.skillPreview:getImageSource()

		if lastSource then
			self.skillPreview:setImageSource(path)
			g_textures.unload(lastSource)
		end

		self.skillPreview:setImagePlaying(false)
		self.skillPreview:setImageAnimationRepeated(true)
		self.skillPreview:setVisible(true)
		self.skillPreview:setEnabled(true)
	else
		self.skillPreview:setVisible(false)
		self.skillPreview:setEnabled(false)
	end
end

function GameArchetypeInfo:hide()
	self.window:hide()
end

function GameArchetypeInfo:show()
	self.window:show()
	self.window:raise()
	self.window:focus()
end

function GameArchetypeInfo:isVisible()
	return self.window:isVisible()
end

function GameArchetypeInfo:cancel()
	self:hide()
end

function GameArchetypeInfo:confirm()
	if not self.currentArchetypeId then
		return
	end

	GameSpellTree:learnArchetype(self.currentArchetypeId)
	self:hide()
end
