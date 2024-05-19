env.info( '*** GVAW TRAINING PACK SCRIPT LOADING ***' )
-------------------------------------------------------
---- Thanks to MOOSE Community & Hairdo/Samjonson  ----
----        Modified for GVAW by EagleEye          ----
----              gvaw.web.id                      ----
-------------------------------------------------------
----                FEATURE                        ----
-------------------------------------------------------
---   * MISSILE TRAINER
---   * AIR WEAPON RANGES
---   * AWACS SPAWN & DESPAWN
---   * SPAWNING BVR, ACM UNITS
---   * SURFACE MISSION FOR TRAINING
---   *** AND MANY MORE
-------------------------------------------------------



-------------------------------------------------------------------------
---------------------------MISSLE TRAINER--------------------------------
-------------------------------------------------------------------------

fox=FOX:New()
:SetEnableF10Menu()
:SetDefaultLaunchAlerts(false)
:SetDefaultLaunchMarks(false)
fox:Start()

------------------------------------------------
_SETTINGS:SetImperial()



-------------------------------------------------------------------------
-----------------------GET THE PLAYER AIRCRAFT---------------------------
-------------------------------------------------------------------------

local PlayerAircraft = SET_GROUP:New():FilterStart()

      PlayerAircraft:HandleEvent(EVENTS.PlayerEnterAircraft)

function PlayerAircraft:OnEventPlayerEnterAircraft(EventData)
PlayerGroup = EventData.IniGroup
PlayerUnit = EventData.IniUnit
PlayerCoord = PlayerUnit:GetCoordinate()

local spawnBASE = PlayerCoord:GetClosestAirbase()
MESSAGE:New("Welcome to DCS Indonesia! You are deployed at " .. spawnBASE:GetName() .. ",  A2A and A2G Training Available via the Radio Menu / F10 MAP", 15):ToAll()
end


local REDGROUND_SET = SET_GROUP:New():FilterPrefixes( "REDGROUND" ):FilterOnce()
local BLUEGROUND_SET = SET_GROUP:New():FilterPrefixes( "BLUEGROUND" ):FilterOnce()

-------------------------------------------------------------------------
-----------------------AIR WEAPON RANGE SCRIPT---------------------------
-------------------------------------------------------------------------
-- PULUNGAN
local PLGAWR = {"PLGTGT"}
PLGAWRZone = RANGE:New("Pulungan AWR")
:SetRangeZone(ZONE:New("Pulungan AWR"))
:SetFunkManOn()
:SetScoreBombDistance(200)
:AddBombingTargets( PLGAWR, 30)
:SetDefaultPlayerSmokeBomb(false)
:SetRangeControl(260)
:SetInstructorRadio(305)
PLGAWRZone:Start()

function PLGAWR:OnAfterImpact(From, Event, To, Result, Player)
      local player = Player
      local result = Result
end

-- PANDANWANGI
local PDWAWR = {"PDWTGT"}
PDWAWRZone = RANGE:New("Pandanwangi AWR")
:SetRangeZone(ZONE:New("Pandanwangi AWR"))
:SetFunkManOn()
:SetScoreBombDistance(200)
:AddBombingTargets( PDWAWR, 30)
:SetDefaultPlayerSmokeBomb(false)
:SetRangeControl(260)
:SetInstructorRadio(305)
PDWAWRZone:Start()

function PDWAWR:OnAfterImpact(From, Event, To, Result, Player)
      local player = Player
      local result = Result
end

-------------------------------------------------------------------------
-----------------------       AEW&C / GCI     ---------------------------
-------------------------------------------------------------------------

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

-------------------------------------------------------------------------
-------------------------------BAI TRAINING------------------------------
-------------------------------------------------------------------------

local BAI_TRAIN = MARKEROPS_BASE:New("BAI", {"SpawnHere"}, false) 


function BAI_TRAIN:OnAfterMarkChanged(From, Event, To, Text, Keywords, Coord)
local Spawn_OnRoad = Coord:GetClosestPointToRoad()

local CLOSEST_BASE = Coord:GetClosestAirbase()
local BaseCoord = CLOSEST_BASE:GetCoord()


local BAISPAWN = SPAWN:NewWithAlias("GROUND TARGET TEMPLATE", "BAI"..math.random(1,10000))
:OnSpawnGroup(
function ( SpawnGroup )
SpawnGroup:RouteGroundOnRoad(BaseCoord, 25)
local redsupression = SUPPRESSION:New(SpawnGroup)
redsupression:Fallback(true)
redsupression:Takecover(true)
redsupression:SetFallbackWait(120)
redsupression:SetRetreatWait(120)
redsupression:Start(1)
end)
:InitRandomizeTemplateSet(REDGROUND_SET)
:SpawnFromCoordinate(Spawn_OnRoad)
MESSAGE:New("CONVOY LAST KNOWN LOCATION...   " .. Coord:ToStringMGRS() .. "  ...ENROUTE TO....   " .. CLOSEST_BASE:GetName(), 60):ToAll()
end


-------------------------------------------------------------------------
-------------------------------SEAD TRAINING-----------------------------
-------------------------------------------------------------------------

local SEAD_TRAIN = MARKEROPS_BASE:New("SEAD", {"SpawnHere"}, false) 
local SAM_SET = SET_GROUP:New():FilterPrefixes( "SA-" ):FilterOnce()

function SEAD_TRAIN:OnAfterMarkChanged(From, Event, To, Text, Keywords, Coord)
SEADSPAWN = SPAWN:NewWithAlias("SEAD TARGET", "SEAD"..math.random(1,10000))
:OnSpawnGroup( 
function( SpawnGroup )
MESSAGE:New( SpawnGroup:GetTypeName() .. " AT COORDINATE  " .. Coord:ToStringMGRS(), 60):ToAll()
end)
:InitRandomizeTemplateSet(SAM_SET)
:SpawnFromCoordinate(Coord)
end


-------------------------------------------------------------------------
-------------------------------STRIKE TRAINING---------------------------
-------------------------------------------------------------------------

local STRIKE_TRAIN = MARKEROPS_BASE:New("STRIKE", {"SpawnHere"}, false) 
local SHORAD_SET = SET_GROUP:New():FilterPrefixes( "SHORAD" ):FilterOnce()

function STRIKE_TRAIN:OnAfterMarkChanged(From, Event, To, Text, Keywords, Coord)

local striketarget = Coord:FindClosestScenery(10)
MESSAGE:New("STRIKE COORDINATE  " .. Coord:ToStringMGRS() .. " TARGET IS " .. striketarget:GetTypeName(), 60):ToAll()
Coord:CircleToAll(100, nil, Color, nil, nil, nil, 6, nil, "TARGET")


local pointdefense = SPAWN:NewWithAlias("SEAD TARGET", "SEAD"..math.random(1,10000))
:InitRandomizeTemplateSet(SHORAD_SET)
:InitPositionCoordinate(Coord)
:InitRandomizePosition(true, 200, 100)
:InitLimit(3, 3)
:SpawnScheduled(5)
end

-------------------------------------------------------------------------
-------------------------------CAS TRAINING-----------------------------
-------------------------------------------------------------------------

local CAS_TRAIN = MARKEROPS_BASE:New("CAS", {"SpawnHere"}, false) 


function CAS_TRAIN:OnAfterMarkChanged(From, Event, To, Text, Keywords, Coord)

local RedSpawnPoint = Coord:Translate(10000, 315, true, false)
local BlueSpawnPoint = Coord:Translate(10000, 135, true, false)

local RedInfantrySpawnPoint = Coord:Translate(500, 315, true, false)
local BlueInfantrySpawnPoint = Coord:Translate(500, 135, true, false)


local CoordVec2 = Coord:GetVec2()

local CoordVec2North = Coord:Translate(1000, 360, true, false):GetVec2()
local CoordVec2South = Coord:Translate(1000, 180, true, false):GetVec2()
local CoordVec2East = Coord:Translate(1000, 90, true, false):GetVec2()
local CoordVec2West = Coord:Translate(1000, 270, true, false):GetVec2()

local EngagementZone = ZONE_RADIUS:New("Engagment Zone", CoordVec2, 2000):DrawZone()

local ZONE_NORTH = ZONE_RADIUS:New("Zone North", CoordVec2North, 2000):DrawZone()
local ZONE_SOUTH = ZONE_RADIUS:New("Zone South", CoordVec2South, 2000):DrawZone()
local ZONE_EAST = ZONE_RADIUS:New("Zone EAST", CoordVec2East, 2000):DrawZone()
local ZONE_WEST = ZONE_RADIUS:New("Zone WEST", CoordVec2West, 2000):DrawZone()

local PatrolZoneTable = {ZONE_NORTH, ZONE_SOUTH, ZONE_EAST, ZONE_WEST}


-------------------------------------------------------------------------
                       --SPAWN BLUE UNITS--
-------------------------------------------------------------------------

CAS_SPAWN_BLUE = SPAWN:NewWithAlias("GROUND TARGET TEMPLATE", "CAS"..math.random(1,10000))
:OnSpawnGroup(
function ( SpawnGroup )
local bluesupression = SUPPRESSION:New(SpawnGroup)
bluesupression:SetSuppressionTime(3, 1, 5)
bluesupression:Fallback(true)
bluesupression:Takecover(true)
bluesupression:SetFallbackWait(120)
bluesupression:SetFallbackDistance(500)
bluesupression:SetRetreatWait(120)
bluesupression:Start(1)

SpawnGroup:PatrolZones(PatrolZoneTable, 35)
end)
:InitRandomizeTemplateSet(BLUEGROUND_SET)
:InitCoalition(coalition.side.BLUE)
:InitPositionCoordinate(BlueSpawnPoint)
:InitRandomizePosition(true, 2000, 1000)
:InitRandomizeRoute(0, 1, 1000)
:InitLimit(20, 10)
:SpawnScheduled(5)


INFANTRY_SPAWN_BLUE = SPAWN:NewWithAlias("BLUE INFANTRY", "CAS"..math.random(1,10000))
:OnSpawnGroup(
function ( SpawnGroup )
local bluesupression = SUPPRESSION:New(SpawnGroup)
bluesupression:SetSuppressionTime(3, 1, 5)
bluesupression:Fallback(true)
bluesupression:Takecover(true)
bluesupression:SetFallbackWait(120)
bluesupression:SetFallbackDistance(500)
bluesupression:SetRetreatWait(120)
bluesupression:Start(1)
SpawnGroup:PatrolZones({EngagementZone}, 35)
end)
:InitCoalition(coalition.side.BLUE)
:InitPositionCoordinate(BlueInfantrySpawnPoint)
:InitRandomizePosition(true, 100, 50)
:InitRandomizeRoute(0, 1, 1000)
:InitLimit(20, 10)
:SpawnScheduled(5)





-------------------------------------------------------------------------
                          --SPAWN RED UNITS--
-------------------------------------------------------------------------						  					  

CAS_SPAWN_RED = SPAWN:NewWithAlias("GROUND TARGET TEMPLATE", "CAS"..math.random(1,10000))
:OnSpawnGroup(
function ( SpawnGroup )
local bluesupression = SUPPRESSION:New(SpawnGroup)
bluesupression:SetSuppressionTime(3, 1, 5)
bluesupression:Fallback(true)
bluesupression:Takecover(true)
bluesupression:SetFallbackWait(120)
bluesupression:SetFallbackDistance(500)
bluesupression:SetRetreatWait(120)
bluesupression:Start(1)
SpawnGroup:PatrolZones(PatrolZoneTable, 35)
end)
:InitRandomizeTemplateSet(REDGROUND_SET)
:InitCoalition(coalition.side.RED)
:InitPositionCoordinate(RedSpawnPoint)
:InitRandomizePosition(true, 2000, 1000)
:InitRandomizeRoute(0, 1, 1000)
:InitLimit(20, 10)
:SpawnScheduled(5)

INFANTRY_SPAWN_RED = SPAWN:NewWithAlias("RED INFANTRY", "CAS"..math.random(1,10000))
:OnSpawnGroup(
function ( SpawnGroup )
local redsupression = SUPPRESSION:New(SpawnGroup)
redsupression:SetSuppressionTime(3, 1, 5)
redsupression:Fallback(true)
redsupression:Takecover(true)
redsupression:SetFallbackWait(120)
redsupression:SetFallbackDistance(500)
redsupression:SetRetreatWait(120)
redsupression:Start(1)
SpawnGroup:PatrolZones({EngagementZone}, 35)
end)
:InitCoalition(coalition.side.RED)
:InitPositionCoordinate(RedInfantrySpawnPoint)
:InitRandomizePosition(true, 100, 50)
:InitLimit(15, 10)
:SpawnScheduled(5)



ARTY_SPAWN_RED = SPAWN:NewWithAlias("ARTILLERY", "ARTY"..math.random(1,10000))
:OnSpawnGroup(
function ( SpawnGroup )
ArtyGroup = ARMYGROUP:New(SpawnGroup)
ArtyGroup:AddWeaponRange(3,10)
end)
:InitPositionCoordinate(RedSpawnPoint )
:InitLimit(6, 1)
:SpawnScheduled(1)




local RedAgents=SET_GROUP:New():FilterCoalitions("red"):FilterStart()

RedIntel = INTEL:New(RedAgents, "red", "RedTeam")
RedIntel:__Start(2)

function RedIntel:OnAfterNewContact(From, Event, To, Contact)
local trgt =  GROUP:FindByName(Contact.groupname)
local ArtyMiz = AUFTRAG:NewARTY(trgt, 10, 100)
ArtyGroup:AddMission(ArtyMiz)
end
MESSAGE:New("AIR SUPPORT REQUEST AT " .. Coord:ToStringMGRS(), 60):ToAll()
end


-------------------------------------------------------------------------
-------------------------------PATROL TRAINING---------------------------
-------------------------------------------------------------------------

local PATROL_TRAIN = MARKEROPS_BASE:New("PATROL", {"SpawnHere"}, false) 

local PATROL_SEA_SET = SET_GROUP:New():FilterPrefixes( "REDNAVY" ):FilterOnce()

function PATROL_TRAIN:OnAfterMarkChanged(From, Event, To, Text, Keywords, Coord)
local PATROLZONE_Vec2 = Coord:GetVec2()
local PATROL_ZONE = ZONE_RADIUS:New("Patrol Zone", PATROLZONE_Vec2, 75000):DrawZone()

if Coord:GetSurfaceType()== land.SurfaceType.LAND then

local LANDPATROLSPAWN = SPAWN:NewWithAlias("GROUND TARGET TEMPLATE", "PATROL"..math.random(1,10000))
:OnSpawnGroup(
function ( grp )
local RedPatrol = ARMYGROUP:New(grp)
local RedPatrolMiz = AUFTRAG:NewPATROLZONE(PATROL_ZONE)
RedPatrol:AddMission(RedPatrolMiz)
end)
:InitRandomizeTemplateSet(REDGROUND_SET)
:InitLimit(10, 3)
:InitPositionCoordinate(Coord)
:InitRandomizePosition(true, 50000, 35000)
:SpawnScheduled(1)
MESSAGE:New("ENEMY GROUND UNITS IN AREA, BEGIN PATROL AT " .. Coord:ToStringMGRS(), 60):ToAll()

else
local WATERPATROLSPAWN = SPAWN:NewWithAlias("NAVAL TEMPLATE", "PATROL"..math.random(1,10000))
:OnSpawnGroup(
function ( grp )
local RedPatrol = NAVYGROUP:New(grp)
local RedPatrolMiz = AUFTRAG:NewPATROLZONE(PATROL_ZONE)
RedPatrol:AddMission(RedPatrolMiz)
end)
:InitRandomizeTemplateSet(PATROL_SEA_SET)
:InitLimit(10, 3)
:InitPositionCoordinate(Coord)
:InitRandomizePosition(true, 50000, 35000)
:SpawnScheduled(1)
MESSAGE:New("ENEMY NAVAL UNITS IN AREA, BEGIN PATROL AT  " .. Coord:ToStringMGRS(), 10):ToAll()

end
end


--------------------------------------------------------------------------
-------------------------------A2A TRAINING-------------------------------
--------------------------------------------------------------------------

-------------------------------------------------------------------------
------------------------------ACM SPAWN----------------------------------
-------------------------------------------------------------------------

local BanditGroupSet = SET_GROUP:New():FilterPrefixes("BANDIT"):FilterCategoryAirplane():FilterStart()

function StartABEAMDogFight ()
local PlayerCoord = PlayerUnit:GetCoordinate()
local PlayerHeading = PlayerUnit:GetHeading()
local spawncoordACM = PlayerCoord:Translate(1600, (PlayerHeading - 90), true, false)

local RandomACRMBandit = BanditGroupSet:GetRandom():GetName()
BanditGroupSet:RemoveGroupsByName(RandomACRMBandit)
BanditSpawn = SPAWN:NewWithAlias(RandomACRMBandit, "enemytarget"..math.random(1,10000))
:InitHeading(PlayerHeading)
:OnSpawnGroup( 
function( SpawnGroup )
ACMBandits = FLIGHTGROUP:New(SpawnGroup)
:SetDetection(true)

FightsOn = AUFTRAG:NewINTERCEPT(PlayerUnit)
ACMBandits:AddMission(FightsOn)

BanditGroupSet:HandleEvent( EVENTS.UnitLost )
function BanditGroupSet:OnEventUnitLost( EventData )

if EventData.IniGroup == SpawnGroup then

MESSAGE:New("SPLASH!!  " .. EventData.IniTypeName, 5):ToAll()
end
end

MESSAGE:New("FIGHTS ON! ENEMY AIRCRAFT " .. spawncoordACM:ToStringBRAANATO(PlayerCoord, true, false, false, true, false), 25):ToAll()
end)
:SpawnFromVec3(spawncoordACM)
end


function StartH2HDogFight ()
local PlayerCoord = PlayerUnit:GetCoordinate()
local PlayerHeading = PlayerUnit:GetHeading()
local spawncoordACM = PlayerCoord:Translate(4000, (PlayerHeading), true, false)
local spawnheading = spawncoordACM:HeadingTo(PlayerCoord)

local RandomACRMBandit = BanditGroupSet:GetRandom():GetName()
BanditGroupSet:RemoveGroupsByName(RandomACRMBandit)
BanditSpawn = SPAWN:NewWithAlias(RandomACRMBandit, "enemytarget"..math.random(1,10000))
:InitHeading(spawnheading)
:OnSpawnGroup( 
function( SpawnGroup )
ACMBandits = FLIGHTGROUP:New(SpawnGroup)
:SetDetection(true)

FightsOn = AUFTRAG:NewINTERCEPT(PlayerUnit)
ACMBandits:AddMission(FightsOn)

BanditGroupSet:HandleEvent( EVENTS.UnitLost )
function BanditGroupSet:OnEventUnitLost( EventData )

if EventData.IniGroup == SpawnGroup then

MESSAGE:New("SPLASH!!  " .. EventData.IniTypeName, 5):ToAll()
end
end

MESSAGE:New("FIGHTS ON! ENEMY AIRCRAFT " .. spawncoordACM:ToStringBRAANATO(PlayerCoord, true, false, false, true, false), 25):ToAll()
end)
:SpawnFromVec3(spawncoordACM)
end

function StartDefensiveDogFight ()
local PlayerCoord = PlayerUnit:GetCoordinate()
local PlayerHeading = PlayerUnit:GetHeading()
local spawncoordACM = PlayerCoord:Translate(1600, (PlayerHeading - 180), true, false)
local spawnheading = spawncoordACM:HeadingTo(PlayerCoord)

local RandomACRMBandit = BanditGroupSet:GetRandom():GetName()
BanditGroupSet:RemoveGroupsByName(RandomACRMBandit)
BanditSpawn = SPAWN:NewWithAlias(RandomACRMBandit, "enemytarget"..math.random(1,10000))
:InitHeading(spawnheading)
:OnSpawnGroup( 
function( SpawnGroup )
ACMBandits = FLIGHTGROUP:New(SpawnGroup)
:SetDetection(true)

FightsOn = AUFTRAG:NewINTERCEPT(PlayerUnit)
ACMBandits:AddMission(FightsOn)

BanditGroupSet:HandleEvent( EVENTS.UnitLost )
function BanditGroupSet:OnEventUnitLost( EventData )

if EventData.IniGroup == SpawnGroup then

MESSAGE:New("SPLASH!!  " .. EventData.IniTypeName, 5):ToAll()
end
end

MESSAGE:New("FIGHTS ON! ENEMY AIRCRAFT " .. spawncoordACM:ToStringBRAANATO(PlayerCoord, true, false, false, true, false), 25):ToAll()
end)
:SpawnFromVec3(spawncoordACM)
end


-------------------------------------------------------------------------
-------------------------BVR SPAWN---------------------------------------
-------------------------------------------------------------------------

function StartBVR ()
local PlayerCoord = PlayerUnit:GetCoordinate()
local PlayerHeading = PlayerUnit:GetHeading()
local spawncoordBVR = PlayerCoord:Translate(150000, (PlayerHeading + math.random(-35, 35)), true, false)
local spawnheading = spawncoordBVR:HeadingTo(PlayerCoord)
      
local BVRBanditGroupSet = SET_GROUP:New():FilterPrefixes("BANDITBVR"):FilterCategoryAirplane():FilterStart()
local BanditBVRRandom = BVRBanditGroupSet:GetRandom():GetName()
BVRBanditGroupSet:RemoveGroupsByName(BanditBVRRandom)
      
BanditBVRSpawn = SPAWN:NewWithAlias(BanditBVRRandom, "enemytarget"..math.random(1,10000))
:InitHeading( PlayerHeading - 180 )
:OnSpawnGroup(
function( SpawnGroup )
BVRBandits = FLIGHTGROUP:New(SpawnGroup)
:SetDetection(true)
      
FightsOn = AUFTRAG:NewINTERCEPT(PlayerUnit)
BVRBandits:AddMission(FightsOn)
      
BVRBanditGroupSet:HandleEvent( EVENTS.UnitLost )
function BVRBanditGroupSet:OnEventUnitLost( EventData )
      
if EventData.IniGroup == SpawnGroup then
     
MESSAGE:New("SPLASH!!  " .. EventData.IniTypeName, 5):ToAll()
end
end
      
      
MESSAGE:New("FIGHTS ON! ENEMY AIRCRAFT " .. spawncoordBVR:ToStringBRAANATO(PlayerCoord, true, false, false, true, false) , 25):ToAll()
end)
:SpawnFromVec3(spawncoordBVR)
end


-----------------------------------------------------------------------------
-----------------------------CREATE MENUS------------------------------------
-----------------------------------------------------------------------------

function A2GInstructions ()
MESSAGE:New("USE MARKERS ON F10 MAP FOR A2G TRAINING. THE FOLLOWING OPTIONS ARE AVAILABLE: SEAD, BAI, CAS, STRIKE, PATROL", 10):ToAll()
end

A2Amenu = MENU_COALITION:New(coalition.side.BLUE, "AERIAL TRAINING")
ACMOptions = MENU_COALITION:New(coalition.side.BLUE, "ACM TRAINING", A2Amenu )

StartDogFight = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Abeam", ACMOptions, StartABEAMDogFight)
StartDogFight = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Defensive", ACMOptions, StartDefensiveDogFight)
StartDogFight = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Head to Head", ACMOptions, StartH2HDogFight)
StartDogFight = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "BEYOND VISUAL RANGE", A2Amenu, StartBVR)

A2GMENU = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SURFACE TRAINING",nil, A2GInstructions) 

--------------------------
-------- AWACS MENU
MenuSpawnAWACS = MENU_COALITION:New(coalition.side.BLUE, "AWACS")
MenuAwacs = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "AWACS", MenuSpawnAWACS, AWACS, "1")
MenuRemoveAWACS = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Remove AWACS", MenuSpawnAWACS, clearAWACS)


--------------------------

env.info( '*** GVAW TRAINING PACK SCRIPT LOADED - END ***' )