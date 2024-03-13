env.info( '*** GVAW BVR Training MOOSE script ***' )
env.info( '*** GVAW MOOSE MISSION SCRIPT START ***' )

_SETTINGS:SetPlayerMenuOff()

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
-- ADMIN SECTION

MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Spawn 1x Adversary", nil, spawnBvr, "1")
MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Spawn 2x Adversary", nil, spawnBvr, "2")
MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Spawn 4x Adversary", nil, spawnBvr, "4")
MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Remove Adversaries", nil, clearSpawns)
--MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Restart Mission", nil, restartMission )
--END ADMIN SECTION

env.info( '*** GVAW MOOSE MISSION SCRIPT END ***' )
