env.info( '*** GVAW AWACS Spawn ***' )

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

---

-- ADMIN SECTION
MENU_COALITION_COMMAND:New(coalition.side.BLUE, "AWACS South", nil, AWACSSouth, "1")
MENU_COALITION_COMMAND:New(coalition.side.BLUE, "AWACS North", nil, AWACSNorth, "1")
MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Remove AWACS South", nil, clearAWACSSsouth)
MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Remove AWACS North", nil, clearAWACSSNorth)
--
MENU_COALITION_COMMAND:New(coalition.side.RED, "AWACS Red", nil, AWACSRed, "1")
MENU_COALITION_COMMAND:New(coalition.side.RED, "Remove AWACS Red", nil, clearAWACSSRed)
--END ADMIN SECTION

env.info( '*** GVAW AWACS Spawn ***' )
