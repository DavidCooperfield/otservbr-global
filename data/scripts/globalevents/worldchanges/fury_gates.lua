local gates = {
	-- Ab'dendriel
	[1] = {
		city = "Ab'dendriel",
		mapName = "abdendriel",
		exitPosition = Position(32680, 31720, 7)
	},
	-- Ankrahmun
	[2] = {
		city = "Ankrahmun",
		mapName = "ankrahmun",
		exitPosition = Position(33267, 32841, 7)
	},
	-- Carlin
	[3] = {
		city = "Carlin",
		mapName = "carlin",
		exitPosition = Position(32263, 31847, 7)
	},
	-- Darashia
	[4] = {
		city = "Darashia",
		mapName = "darashia",
		exitPosition = Position(33302, 32371, 7)
	},
	-- Edron
	[5] = {
		city = "Edron",
		mapName = "edron",
		exitPosition = Position(33221, 31921, 7)
	},
	-- Kazordoon
	[6] = {
		city = "Kazordoon",
		mapName = "kazordoon",
		exitPosition = Position(32574, 31981, 7)
	},
	-- Liberty Bay
	[7] = {
		city = "Liberty Bay",
		mapName = "libertybay",
		exitPosition = Position(32348, 32693, 7)
	},
	-- Port Hope
	[8] = {
		city = "Port Hope",
		mapName = "porthope",
		exitPosition = Position(32530, 32713, 7)
	},
	-- Thais
	[9] = {
		city = "Thais",
		mapName = "thais",
		exitPosition = Position(32265, 32164, 7)
	},
	-- Venore
	[10] = {
		city = "Venore",
		mapName = "venore",
		exitPosition = Position(32834, 32082, 7),
		burntItems = {
			{position = Position(32836, 32079, 7), itemId = 6218},
			{position = Position(32835, 32080, 7), itemId = 2779},
			{position = Position(32837, 32080, 7), itemId = 6219},
			{position = Position(32828, 32081, 7), itemId = 6217},
			{position = Position(32836, 32081, 7), itemId = 2772},
			{position = Position(32837, 32081, 7), itemId = 6218},
			{position = Position(32827, 32082, 7), itemId = 6219},
			{position = Position(32836, 32082, 7), itemId = 6219},
			{position = Position(32834, 32084, 7), itemId = 2779},
			{position = Position(32830, 32086, 7), itemId = 2780},
			{position = Position(32836, 32086, 7), itemId = 2769},
			{position = Position(32836, 32087, 7), itemId = 2772},
			{position = Position(32838, 32087, 7), itemId = 2782},
			{position = Position(32835, 32089, 7), itemId = 6218},
			{position = Position(32836, 32091, 7), itemId = 2775}
		}
	}
}


-- FURY GATES MAP LOAD

local furygates = GlobalEvent("furygates")

function furygates.onStartup(interval)
	local gateId = math.random(1, 10)
	--local gateId = 10
	
	-- Remove burnt items
	if gates[gateId].burntItems then
		local item
		for i = 1, #gates[gateId].burntItems do
			item = Tile(gates[gateId].burntItems[i].position):getItemById(gates[gateId].burntItems[i].itemId)
			if item then
				item:remove()
			end
		end
	end
	
	Game.loadMap('data/world/furygates/' .. gates[gateId].mapName .. '.otbm')
	
	setGlobalStorageValue(GlobalStorage.FuryGates, gateId)
	
	print('>> Fury Gate will be active in ' .. gates[gateId].city .. ' today')
	
	return true
end

furygates:register()


-- FURY GATE TELEPORTS

local teleport = MoveEvent()

function teleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	
	local gateId = Game.getStorageValue(GlobalStorage.FuryGates)
	
	if not gates[gateId] then
		return true
	end
	
	position:sendMagicEffect(CONST_ME_TELEPORT)

	-- Enter gates
	if item.actionid == 9710 then
		-- Check requeriments
		if player:getLevel() < 60 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to be at least level 60 to enter this gate.")
			player:teleportTo(gates[gateId].exitPosition)
			gates[gateId].exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end

		local destination = Position(33290, 31786, 13)
		player:teleportTo(destination)
		destination:sendMagicEffect(CONST_ME_FIREAREA)
	-- Exit gate
	elseif item.actionid == 9715 then
		player:teleportTo(gates[gateId].exitPosition)
		gates[gateId].exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end
	
	return true
end

teleport:type("stepin")
teleport:aid(9710, 9715)

teleport:register()