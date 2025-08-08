-- chunkname: @/modules/game_duel/duel.lua

g_duel = {}
testing = not g_app.isProductionRelease()
disableTargetChecks = false
invited = nil
duelModal = nil
CONST_SE_DUEL_COUNTDOWN_TICK = 4122876304
CONST_SE_DUEL_START = 823118004
CONST_SE_DUEL_VICTORY = 970880490
CONST_SE_DUEL_DEFEAT = 1617361545

function init()
	connect(g_game, {
		onDuelModeChange = onDuelModeChange,
		onHealCreature = onHealCreature,
		onAttackCreature = onAttackCreature,
		onSetupModalDialog = onSetupModalDialog,
		onDestroyModalDialog = onDestroyModalDialog
	})

	leave = rateLimit(g_duel.leave, 1000)
	invite = rateLimit(g_duel.invite, 2000)
	accept = rateLimit(g_duel.accept, 2000)

	ProtocolGame.registerExtendedOpcode(ExtendedIds.Duel, onExtendedOpcode)
	modules.game_interface.addMenuHook(nil, tr("Invite to Duel"), function(menuPosition, lookThing, useThing, player)
		invite(player)
	end, function(menuPosition, lookThing, useThing, creatureThing)
		return not invited and creatureThing and creatureThing:isPlayer() and creatureThing:getId() ~= g_game.getLocalPlayer():getId() and not g_game.isDuelParticipant(creatureThing:getId()) and not g_game.isAetherRiftChannel() and not g_game.isGuildWarsChannel()
	end, nil, function(menu, optionName, lookThing, useThing, creatureThing)
		local index = menu:getChildIndex(menu:recursiveGetChildById(string.format("message to %s", creatureThing:getName():lower())))

		return index ~= -1 and index - 1 or -1
	end)
	modules.game_interface.addMenuHook(nil, tr("Accept Duel"), function(menuPosition, lookThing, useThing, player)
		accept(invited.duelId)
	end, function(menuPosition, lookThing, useThing, creatureThing)
		return invited and invited.id == creatureThing:getId() and not invited and creatureThing and creatureThing:isPlayer() and creatureThing:getId() ~= g_game.getLocalPlayer():getId() and not g_game.isDuelParticipant(creatureThing:getId())
	end, nil, function(menu, optionName, lookThing, useThing, creatureThing)
		local index = menu:getChildIndex(menu:recursiveGetChildById(string.format("message to %s", creatureThing:getName():lower())))

		return index ~= -1 and index - 1 or -1
	end)
	modules.game_interface.addMenuHook(nil, tr("Accept Duel"), function(menuPosition, lookThing, useThing, player)
		accept(invited.duelId)
	end, function(menuPosition, lookThing, useThing, creatureThing)
		return invited and invited.id == creatureThing:getId() and creatureThing and creatureThing:isPlayer() and creatureThing:getId() ~= g_game.getLocalPlayer():getId() and not g_game.isDuelParticipant(creatureThing:getId()) and not g_game.isAetherRiftChannel() and not g_game.isGuildWarsChannel()
	end, nil, function(menu, optionName, lookThing, useThing, creatureThing)
		local index = menu:getChildIndex(menu:recursiveGetChildById(string.format("message to %s", creatureThing:getName():lower())))

		return index ~= -1 and index - 1 or -1
	end)
	modules.game_interface.addMenuHook("duel", tr("Leave Duel"), function(menuPosition, lookThing, useThing, creatureThing)
		leave()
	end, function(menuPosition, lookThing, useThing, creatureThing)
		return g_game.isInDuelMode() and creatureThing and creatureThing:isPlayer() and creatureThing:getId() == g_game.getLocalPlayer():getId() and not g_game.isAetherRiftChannel() and not g_game.isGuildWarsChannel()
	end)
end

function terminate()
	disconnect(g_game, {
		onDuelModeChange = onDuelModeChange,
		onHealCreature = onHealCreature,
		onAttackCreature = onAttackCreature,
		onSetupModalDialog = onSetupModalDialog,
		onDestroyModalDialog = onDestroyModalDialog
	})
	ProtocolGame.unregisterExtendedOpcode(ExtendedIds.Duel)
	modules.game_interface.removeMenuHook("duel", tr("Invite to Duel"))
	modules.game_interface.removeMenuHook("duel", tr("Leave Duel"))
end

function g_duel.invite(playerOrId)
	sendOpcode({
		action = "invite",
		playerId = type(playerOrId) == "number" and playerOrId or playerOrId:getId()
	})
end

function g_duel.leave()
	sendOpcode({
		action = "leave"
	})
end

function g_duel.kick(playerOrId)
	sendOpcode({
		action = "kick",
		playerId = type(playerOrId) == "number" and playerOrId or playerOrId:getId()
	})
end

function g_duel.accept(duelId)
	sendOpcode({
		autoStart = true,
		action = "invite_accept",
		duelId = duelId
	})
end

function onSetupModalDialog(modalDialog)
	if modalDialog.customId == MODAL_CUSTOMID_DUEL then
		duelModal = modalDialog
	end
end

function onDestroyModalDialog(modalDialog)
	if duelModal and modalDialog.id == duelModal.id then
		duelModal = nil
	end
end

function onDuelModeChange(mode)
	if testing then
		print("onDuelModeChange", mode)
	end

	modules.game_interface.hideArenaCountdown()

	if not mode then
		updateDuelInfo({})
		modules.game_interface.hideArenaCountdown()
		g_game.clearDuelDead()
	else
		g_game.heal(nil)
		g_game.attack(nil)

		if duelModal and not duelModal:isDestroyed() then
			duelModal:destroy()
		end
	end

	if modules.game_battle and modules.game_battle.BattleList then
		modules.game_battle.BattleList:fitFilters()
	end

	local player = g_game.getLocalPlayer()

	if player then
		player:updateNameColor()
	end
end

function onDuelDeath()
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	g_game.addDuelDead(player:getId())
	g_game.heal(nil)
	g_game.attack(nil)
	player:updateNameColor()
end

function onHealCreature(creature)
	if not creature then
		return true
	end

	if creature:isLocalPlayer() then
		return true
	end

	if not disableTargetChecks and creature:isPlayer() and g_game.isInDuelMode() then
		local player = g_game.getLocalPlayer()

		if g_game.isDuelDead(creature:getId()) or g_game.isDuelDead(player:getId()) then
			return false
		end

		return g_game.isDuelFriend(creature:getId())
	end

	return true
end

function onAttackCreature(creature)
	if not creature then
		return true
	end

	if creature:isLocalPlayer() then
		return true
	end

	if not disableTargetChecks and creature:isPlayer() and g_game.isInDuelMode() then
		local player = g_game.getLocalPlayer()

		if g_game.isDuelDead(creature:getId()) or g_game.isDuelDead(player:getId()) then
			return false
		end

		return g_game.isDuelEnemy(creature:getId())
	end

	return true
end

function sendOpcode(data)
	local protocolGame = g_game.getProtocolGame()

	if testing then
		print("sendOpcode", protocolGame, ExtendedIds.Duel)
	end

	if protocolGame then
		protocolGame:sendExtendedOpcode(ExtendedIds.Duel, g_game.serializeTable(data))
	end
end

function onExtendedOpcode(protocol, opcode, buffer)
	if opcode ~= ExtendedIds.Duel or buffer == "" then
		return
	end

	if testing then
		print("onExtendedOpcode", buffer)
	end

	local data = g_game.unserializeTable(buffer)

	if type(data) ~= "table" then
		return
	end

	if testing then
		print("action", data.action)
	end

	local unloadDuel = false

	if data.action == "prepared" then
		disableTargetChecks = data.disableTargetChecks
	elseif data.action == "starting" then
		g_game.setDuelMode(true)
		modules.game_interface.showArenaCountdown(data.countdown / 1000 or 10, nil, CONST_SE_DUEL_COUNTDOWN_TICK)
	elseif data.action == "started" then
		g_sound.play(CONST_SE_DUEL_START)
	elseif data.action == "finished" then
		unloadDuel = true
	elseif data.action == "canceled" then
		unloadDuel = true
	elseif data.action == "reset" then
		-- block empty
	elseif data.action == "kicked" then
		unloadDuel = true
	elseif data.action == "participant_kicked" then
		g_game.removeDuelFriend(data.playerId)
		g_game.removeDuelEnemy(data.playerId)
		g_game.removeDuelDead(data.playerId)

		local creature = g_map.getCreatureById(data.playerId)

		if creature then
			creature:updateNameColor()
		end
	elseif data.action == "invite" then
		invited = data.inviter
	elseif data.action == "invite_accepted" then
		invited = nil
	elseif data.action == "invite_declined" then
		invited = nil
	elseif data.action == "invite_revoked" then
		invited = nil
	elseif data.action == "dead" then
		onDuelDeath()
	elseif data.action == "participant_dead" then
		-- block empty
	elseif data.action == "info" then
		-- block empty
	elseif data.action == "win" then
		scheduleEvent(function()
			g_sound.play(CONST_SE_DUEL_VICTORY, g_sound.localEmitterId, nil, nil, nil, 100)
		end, 1000)
	elseif data.action == "lose" then
		scheduleEvent(function()
			g_sound.play(CONST_SE_DUEL_DEFEAT, g_sound.localEmitterId, nil, nil, nil, 400)
		end, 1000)
	else
		g_logger.error("Unknown duel action: " .. data.action)
	end

	if data.info then
		updateDuelInfo(data.info or {})
	end

	if unloadDuel then
		g_game.setDuelMode(false)
	end

	if isDueling() and modules.game_battle and modules.game_battle.BattleList then
		modules.game_battle.BattleList:fitFilters()
	end
end

function updateDuelInfo(info)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local prevFriends = g_game.getDuelFriends() or {}
	local prevEnemies = g_game.getDuelEnemies() or {}

	if testing then
		table.print(info)
	end

	g_game.setDuelFriends(info.friends or {})
	g_game.setDuelEnemies(info.enemies or {})
	player:updateNameColor()

	if info.friends then
		updateParticipation(info.friends)
	end

	if info.enemies then
		updateParticipation(info.enemies)
	end

	updateParticipation(prevFriends)
	updateParticipation(prevEnemies)

	if info.dead then
		local dead = {}

		table.insertall(dead, table.keys(info.dead.enemies or {}))
		table.insertall(dead, table.keys(info.dead.friends or {}))
		g_game.setDuelDead(dead)
		updateParticipation(dead)
	end
end

function updateParticipation(participants, callback)
	for _, participant in pairs(participants) do
		local creature = g_map.getCreatureById(participant)

		if creature then
			creature:updateNameColor()

			if callback then
				callback(creature)
			end
		end
	end
end

function isDueling()
	return g_game.isInDuelMode()
end
