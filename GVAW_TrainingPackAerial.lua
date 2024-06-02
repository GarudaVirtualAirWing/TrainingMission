-- AERIAL TRAINING
--[[]

PARAMETER THAT SHOULD AVAILABLE IN MISSION EDITOR
BASED ON GROUP NAME
RED UNIT
	- ADV_MIG21
	- ADV_MiG28
	- ADV_Su27
	- ADV_MiG23
	- ADV_F16
	- ADV_F18

ZONE POLYGON
- BFMACM
- ZONE_BFMACM


]]--

fox=FOX:New()
:SetEnableF10Menu()
:SetDefaultLaunchAlerts(false)
:SetDefaultLaunchMarks(false)
fox:Start()

------------------------------------------------
_SETTINGS:SetImperial()

local function AWACS(qty)
	local SpawnAWACS = SPAWN:New("AWACS" .. qty)
	SpawnAWACS:Spawn()
end

local function clearAWACS()
	local activeAWACS = SET_GROUP:New()
	activeAWACS:FilterPrefixes("AWACS")
		:FilterStart()
	
	activeAWACS:ForEachGroupAlive(function(group)
		group:Destroy()
	end)

end

MenuSpawnAWACS = MENU_COALITION:New(coalition.side.BLUE, "AWACS")
MenuAwacs = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "AWACS", MenuSpawnAWACS, AWACS, "1")
MenuRemoveAWACS = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Remove AWACS", MenuSpawnAWACS, clearAWACS)


BFMACM = {
	ClassName = "BFMACM",
	menuAdded = {},
	menuF10 = {},
	useSRS = true,
}

BFMACM.adversary = {
	menu = { -- Adversary menu
		{template = "ADV_MIG21", menuText = "Adversary MIG-21"},
		{template = "ADV_MiG28", menuText = "Adversary MiG-28"},
		{template = "ADV_Su27", menuText = "Adversary MiG-23"},
		{template = "ADV_MiG23", menuText = "Adversary Su-27"},
		{template = "ADV_F16", menuText = "Adversary F-16"},
		{template = "ADV_F18", menuText = "Adversary F-18"},
	},
	range = {5, 10, 20}, 
	spawn = {}, 
	defaultRadio = "377.8",
}

BFMACM = BASE:Inherit( BFMACM, BASE:New() )

BFMACM:HandleEvent(EVENTS.PlayerEnterAircraft)
BFMACM:HandleEvent(EVENTS.PlayerLeaveUnit)

local _msg
local useSRS

function BFMACM:Start() 
	_msg = string.format("[GVAW BFMACM] useSRS: %s", tostring(useSRS))

	self:T(_msg)

	if self.zoneBfmAcmName ~= nil then
		_zone = ZONE:FindByName(self.zoneBfmAcmName) or ZONE_POLYGON:FindByName(self.zoneBfmAcmName)
		if _zone == nil then
			_msg = string.format("[GVAW BFMACM] ERROR: BFM/ACM Zone: %s not found!", self.zoneBfmAcmName)
			self:E(_msg)
		else
			self.zoneBfmAcm = _zone
			_msg = string.format("[GVAW BFMACM] BFM/ACM Zone: %s added.", self.zoneBfmAcmName)
			self:T(_msg)
		end
	else
		
		_msg = "[GVAW BFMACM] No zone defined. Whole map is active."
		self:T(_msg)
		self.zoneBfmAcm = false

	end


	if self.zonesNoSpawnName then
		self.zonesNoSpawn = {}
		for i, zoneNoSpawnName in ipairs(self.zonesNoSpawnName) do
			_zone = (ZONE:FindByName(zoneNoSpawnName) and ZONE:FindByName(zoneNoSpawnName) or ZONE_POLYGON:FindByName(zoneNoSpawnName))
			if _zone == nil then
			_msg = "[GVAW BFMACM] ERROR: Exclusion zone: " .. tostring(zoneNoSpawnName) .. " not found!"
			self:E(_msg)
			else
				self.zonesNoSpawn[i] = _zone
			_msg = "[GVAW BFMACM] Exclusion zone: " .. tostring(zoneNoSpawnName) .. " added."
			self:T(_msg)
			end
		end
	else
		self:T("[GVAW BFMACM] No exclusion zones defined.")
	end


	for i, adversaryMenu in ipairs(BFMACM.adversary.menu) do
		_adv = GROUP:FindByName(adversaryMenu.template)
		if _adv then
			self.adversary.spawn[adversaryMenu.template] = SPAWN:New(adversaryMenu.template)
		else
			_msg = "[GVAW BFMACM] ERROR: spawn template: " .. tostring(adversaryMenu.template) .. " not found!" .. tostring(zoneNoSpawnName) .. " not found!"
			self:E(_msg)
		end
	end

end


function BFMACM:GetPlayerUnitAndName(unitname)
	if unitname ~= nil then
		local DCSunit = Unit.getByName(unitname)
		if DCSunit then
		local playername=DCSunit:getPlayerName()
		local unit = UNIT:Find(DCSunit)
		if DCSunit and unit and playername then
			return unit, playername
		end
		end
	end

	return nil,nil
end


function BFMACM:SpawnAdv(adv,qty,group,rng,unit)
	local playerName = (unit:GetPlayerName() and unit:GetPlayerName() or "Unknown") 
	local range = rng * 1852
	local hdg = unit:GetHeading()
	local pos = unit:GetPointVec2()
	local spawnPt = pos:Translate(range, hdg, true)
	local spawnVec3 = spawnPt:GetVec3()
	local spawnAllowed, msgNoSpawn


	if self.zoneBfmAcm then
		_msg = "[GVAW BFMACM] SpawnAdv(). Allowed Spawn Zone is defined."
		self:T(_msg)
		spawnAllowed = unit:IsInZone(self.zoneBfmAcm)
		msgNoSpawn = ", Cannot spawn adversary aircraft if you are outside the BFM/ACM zone!"
	else
		_msg = "[GVAW BFMACM] SpawnAdv(). No Allowed Spawn Zone defined."
		self:T(_msg)
				spawnAllowed = true
	end

	if spawnAllowed then
		if self.zonesNoSpawn then
		for i, zoneExclusion in ipairs(self.zonesNoSpawn) do
			spawnAllowed = not zoneExclusion:IsVec3InZone(spawnVec3)
		end
		msgNoSpawn = ", Cannot spawn adversary aircraft in an exclusion zone. Change course, or increase your range from the zone, and try again."
		end
	end

	if spawnAllowed and self.zoneBfmAcm then
		spawnAllowed = self.zoneBfmAcm:IsVec3InZone(spawnVec3)
		msgNoSpawn = ", Cannot spawn adversary aircraft outside the BFM/ACM zone. Change course and try again."
	end

	if spawnAllowed then
		self.adversary.spawn[adv]:InitGrouping(qty)
		:InitHeading(hdg + 180)
		:OnSpawnGroup(
		function ( SpawnGroup )
			local CheckAdversary = SCHEDULER:New( SpawnGroup, 
			function (CheckAdversary)
				if SpawnGroup and BFMACM.zoneBfmAcm then
					if SpawnGroup:IsNotInZone( BFMACM.zoneBfmAcm ) then
						local msg = "All players, BFM Adversary left BFM Zone and was removed!"
						if useSRS then 
							MISSIONSRS:SendRadio(msg,BFMACM.rangeRadio)
						else 
							MESSAGE:New(msg):ToAll()
						end
						SpawnGroup:Destroy()
						SpawnGroup = nil
					end
				end
			end,
			{}, 0, 5 )
		end
		)
		:SpawnFromVec3(spawnVec3)
		local msg = "All players, " .. playerName .. " has spawned BFM Adversary."
		if useSRS then 
			MISSIONSRS:SendRadio(msg,self.rangeRadio)
		else 
			MESSAGE:New(msg):ToAll()
		end
		
	else
		local msg = playerName .. msgNoSpawn
		if useSRS then 
			MISSIONSRS:SendRadio(msg,BFMACM.rangeRadio)
		else 
			MESSAGE:New(msg):ToAll()
		end
		end
end

function BFMACM:AddMenu(unitname)
	self:T("[GVAW BFMACM] AddMenu called.")
  local unit, playername = self:GetPlayerUnitAndName(unitname)
  if unit and playername then
    local group = unit:GetGroup()
    local gid = group:GetID()
    local uid = unit:GetID()
    if group and gid then
  
      if self.menuAdded[uid] == nil then
 
        if self.menuF10[gid] == nil then
			self:T("[GVAW BFMACM] Adding menu for group: " .. group:GetName())
			self.menuF10[gid] = MENU_GROUP:New(group, "AI BFM/ACM")
        end
        if self.menuF10[gid][uid] == nil then

          self:T("[GVAW BFMACM] Add submenu for player: " .. playername)
          self.menuF10[gid][uid] = MENU_GROUP:New(group, playername, BFMACM.menuF10[gid])
          
          self:T("[GVAW BFMACM] Add submenus and range selectors for player: " .. playername)
          for iMenu, adversary in ipairs(self.adversary.menu) do
            
            self.menuF10[gid][uid][iMenu] = MENU_GROUP:New(group, adversary.menuText, BFMACM.menuF10[gid][uid])
           
            self.menuF10[gid][uid][iMenu].single = MENU_GROUP:New(group, "Single", BFMACM.menuF10[gid][uid][iMenu])
            self.menuF10[gid][uid][iMenu].pair = MENU_GROUP:New(group, "Pair", BFMACM.menuF10[gid][uid][iMenu])
            
            for iCommand, range in ipairs(BFMACM.adversary.range) do
                MENU_GROUP_COMMAND:New(group, tostring(range) .. " nm", BFMACM.menuF10[gid][uid][iMenu].single, BFMACM.SpawnAdv, BFMACM, adversary.template, 1, group, range, unit)
                MENU_GROUP_COMMAND:New(group, tostring(range) .. " nm", BFMACM.menuF10[gid][uid][iMenu].pair, BFMACM.SpawnAdv, BFMACM, adversary.template, 2, group, range, unit)
            end
          end
        end
        BFMACM.menuAdded[uid] = true
      end
    else
		self:T(string.format("[GVAW BFMACM] ERROR: Could not find group or group ID in AddMenu() function. Unit name: %s.", unitname))
    end
  else
    self:T(string.format("[GVAW BFMACM] ERROR: Player unit does not exist in AddMenu() function. Unit name: %s.", unitname))
  end
end
  
function BFMACM:OnEventPlayerEnterAircraft(EventData)
	self:T("[GVAW BFMACM] PlayerEnterAircraft called.")
	local unitname = EventData.IniUnitName
	local unit, playername = BFMACM:GetPlayerUnitAndName(unitname)
	if unit and playername then
		self:T("[GVAW BFMACM] Player entered Aircraft: " .. playername)
		SCHEDULER:New(nil, BFMACM.AddMenu, {BFMACM, unitname},0.1)
	end
end

function BFMACM:OnEventPlayerLeaveUnit(EventData)
	local playername = EventData.IniPlayerName
	local unit = EventData.IniUnit
	local gid = EventData.IniGroup:GetID()
	local uid = EventData.IniUnit:GetID()
	self:T("[GVAW BFMACM] " .. playername .. " left unit:" .. unit:GetName() .. " UID: " .. uid)
	if gid and uid then
		if self.menuF10[gid] then
			self:T("[GVAW BFMACM] Removing menu for unit UID:" .. uid)
			self.menuF10[gid][uid]:Remove()
			self.menuF10[gid][uid] = nil
			self.menuAdded[uid] = nil
		end
	end
end

BFMACM.template = {

}

if not BFMACM then 
	_msg = "[GVAW BFMACM] CORE FILE NOT LOADED!"
	BASE:E(_msg)
	BFMACM = {}
end

BFMACM.zoneBfmAcmName = "ZONE_BFMACM" -- The BFM/ACM Zone
BFMACM.zonesNoSpawnName = { 
} 

BFMACM.adversary = {
    menu = { -- Adversary menu
		{template = "ADV_MIG21", menuText = "Adversary MIG-21"},
		{template = "ADV_MiG28", menuText = "Adversary MiG-28"},
		{template = "ADV_MiG23", menuText = "Adversary MiG-23"},
		{template = "ADV_Su27", menuText = "Adversary Su-27"},
		{template = "ADV_F16", menuText = "Adversary F-16"},
		{template = "ADV_F18", menuText = "Adversary F-18"},
    },
    range = {5, 10, 20}, 
    spawn = {}, 
    defaultRadio = "251",
}


if BFMACM.Start then
	BFMACM:Start()
end  
