env.info( '*** GVAW AWACS and BVR Spawn ***' )

_SETTINGS:SetPlayerMenuOff()

local function AWACSSouth(qty)
	local SpawnAWACSSouth = SPAWN:New("AWACSSOUTH" .. qty)
	SpawnAWACSSouth:Spawn()
end

local function AWACSNorth(qty)
	local SpawnAWACSNorth = SPAWN:New("AWACSNorth" .. qty)
	SpawnAWACSNorth:Spawn()
end

local function AWACSRed(qty)
	local SpawnAWACSRed = SPAWN:New("AWACSRed" .. qty)
	SpawnAWACSRed:Spawn()
end

----

local function clearAWACSSsouth()
	local activeSouthAWACS = SET_GROUP:New()
	activeSouthAWACS:FilterPrefixes("AWACSSOUTH")
		:FilterStart()
	
	activeSouthAWACS:ForEachGroupAlive(function(group)
		group:Destroy()
	end)

end

local function clearAWACSSNorth()
	local activeNorthAWACS = SET_GROUP:New()
	activeNorthAWACS:FilterPrefixes("AWACSNorth")
		:FilterStart()
	
	activeNorthAWACS:ForEachGroupAlive(function(group)
		group:Destroy()
	end)

end

local function clearAWACSSRed()
	local activeRedAWACS = SET_GROUP:New()
	activeRedAWACS:FilterPrefixes("AWACSRed")
		:FilterStart()
	
	activeRedAWACS:ForEachGroupAlive(function(group)
		group:Destroy()
	end)

end


local function restartMission()
	trigger.action.setUserFlag("999", true)
end

local function spawnBvr(qty)
	local SpawnBvrAdversary = SPAWN:New("ADV_FLIGHT" .. qty)
	SpawnBvrAdversary:Spawn()
end

local function clearSpawns()
	local activeSpawns = SET_GROUP:New()
	activeSpawns:FilterPrefixes("ADV")
		:FilterStart()
	
	activeSpawns:ForEachGroupAlive(function(group)
		group:Destroy()
	end)

end
---

-- ADMIN SECTION

local MenuSpawnAWACS = MENU_COALITION:New(coalition.side.BLUE, "AWACS")
local MenuAwacsSouth = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "AWACS South", MenuSpawnAWACS, AWACSSouth, "1")
local MenuAwacsNorth = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "AWACS North", MenuSpawnAWACS, AWACSNorth, "1")
local MenuRemoveSouth = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Remove AWACS South", MenuSpawnAWACS, clearAWACSSsouth)
local MenuRemoveNorth = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Remove AWACS North", MenuSpawnAWACS, clearAWACSSNorth)
local MenuSpawnAdversary = MENU_COALITION:New(coalition.side.BLUE, "Adversaries")
local MenuSpawn1x = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Spawn 1x Adversary", MenuSpawnAdversary, spawnBvr, "1")
local MenuSpawn2x = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Spawn 2x Adversary", MenuSpawnAdversary, spawnBvr, "2")
local MenuSpawn4x = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Spawn 4x Adversary", MenuSpawnAdversary, spawnBvr, "4")
local MenuClearAdversary = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Remove Adversaries", MenuSpawnAdversary, clearSpawns)
--
local MenuSpawnRedAwacs = MENU_COALITION:New(coalition.side.RED, "Red AWACS")
local MenuAwacsRed = MENU_COALITION_COMMAND:New(coalition.side.RED, "Spawn AWACS Red", MenuSpawnRedAwacs, AWACSRed, "1")
local MenuRemoveRed = MENU_COALITION_COMMAND:New(coalition.side.RED, "Remove AWACS Red", MenuSpawnRedAwacs, clearAWACSSRed)
--END ADMIN SECTION

env.info( '*** GVAW AWACS Spawn ***' )
