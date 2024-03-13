env.info( '*** GVAW TRAINING MUNITION MISSION SCRIPT END ***' )

_SETTINGS:SetPlayerMenuOff()

-- Create a new missile trainer object.
fox=FOX:New()
fox:SetDefaultLaunchAlerts(false)
fox:SetDefaultLaunchMarks(false)
fox:SetDisableF10Menu(true)
fox:SetExplosionDistance(150)
fox:SetExplosionDistanceBigMissiles(305)
fox:AddSafeZone(ZONE:New("LTD13"))
fox:AddSafeZone(ZONE:New("LTD8"))
fox:AddSafeZone(ZONE:New("LCR13"))
fox:AddSafeZone(ZONE:New("LCD03"))
fox:AddSafeZone(ZONE:New("LLR01"))
fox:AddSafeZone(ZONE:New("OSR26"))
fox:AddSafeZone(ZONE:New("OSR29"))
fox:AddSafeZone(ZONE:New("OSR30"))
fox:SetEnableF10Menu()
fox:Start()

-- NOTE
-- RANGE:AddStrafePit(targetnames, boxlength, boxwidth, heading, inverseheading, goodpass, foulline)

-- Surface Attack LTD19
local LTD19Range = {"Box-1", "Box-2"}
local StrafeLTD19 = {"ltd19s-1", "ltd19s-2", "ltd19s-3"}
LTD19RangeZone = RANGE:New("LTD19 Range")
    LTD19RangeZone:SetRangeZone(ZONE:New("LTD19"))
    LTD19RangeZone:SetFunkManOn()
    LTD19RangeZone:SetScoreBombDistance(200)
    LTD19RangeZone:AddBombingTargets( LTD19Range, 30)
    LTD19RangeZone:AddStrafePit(StrafeLTD19, 5000, 1000, nil, false, 20, 0)
    LTD19RangeZone:SetDefaultPlayerSmokeBomb(false)
    LTD19RangeZone:SetRangeControl(260)
    LTD19RangeZone:SetInstructorRadio(305)
    LTD19RangeZone:SetSoundfilesPath("Range Soundfiles/")
LTD19RangeZone:Start()

function LTD19Range:OnAfterImpact(From, Event, To, Result, Player)
    local player = Player
    local result = Result
end

function StrafeLTD19:OnAfterStrafeResult(From, Event, To, Player, Result)
    local player = Player
    local result = Result
end

-- Surface Attack LLR20
local LLR20Range = {"Box-3", "Box-4"}
local StrafeLLR20 = {"llr20s-1", "llr20s-2", "llr20s-3"}
LLR20RangeZone = RANGE:New("LLR20 Range")
    LLR20RangeZone:SetRangeZone(ZONE:New("LLR20"))
    LLR20RangeZone:SetFunkManOn()
    LLR20RangeZone:SetScoreBombDistance(200)
    LLR20RangeZone:AddBombingTargets( LLR20Range, 30)
    LLR20RangeZone:AddStrafePit(StrafeLLR20, 5000, 1000, nil, false, 20, 0)
    LLR20RangeZone:SetDefaultPlayerSmokeBomb(false)
    LLR20RangeZone:SetRangeControl(261)
    LLR20RangeZone:SetInstructorRadio(305)
    LLR20RangeZone:SetSoundfilesPath("Range Soundfiles/")
LLR20RangeZone:Start()

function LLR20Range:OnAfterImpact(From, Event, To, Result, Player)
    local player = Player
    local result = Result
end

function StrafeLLR20:OnAfterStrafeResult(From, Event, To, Player, Result)
    local player = Player
    local result = Result
end

-- Surface Attack LLP20
local LLP20Range = {"Box-5", "Box-6"}
local StrafeLLP20 = {"llp20s-1", "llp20s-2", "llp20s-3"}
LLP20RangeZone = RANGE:New("LLP20 Range")
    LLP20RangeZone:SetRangeZone(ZONE:New("LLP20"))
    LLP20RangeZone:SetFunkManOn()
    LLP20RangeZone:SetScoreBombDistance(200)
    LLP20RangeZone:AddBombingTargets( LLP20Range, 30)
    LLP20RangeZone:AddStrafePit(StrafeLLP20, 5000, 1000, nil, false, 20, 0)
    LLP20RangeZone:SetDefaultPlayerSmokeBomb(false)
    LLP20RangeZone:SetRangeControl(262)
    LLP20RangeZone:SetInstructorRadio(305)
    LLP20RangeZone:SetSoundfilesPath("Range Soundfiles/")
LLP20RangeZone:Start()

function LLP20Range:OnAfterImpact(From, Event, To, Result, Player)
    local player = Player
    local result = Result
end

function StrafeLLP20:OnAfterStrafeResult(From, Event, To, Player, Result)
    local player = Player
    local result = Result
end

-- Surface Attack LCD38
local LCD38Range = {"Box-7"}
local StrafeLCD38 = {"lcd38s-1", "lcd38s-2", "lcd38s-3"}
LCD38RangeZone = RANGE:New("LCD38 Range")
    LCD38RangeZone:SetRangeZone(ZONE:New("LCD38"))
    LCD38RangeZone:SetFunkManOn()
    LCD38RangeZone:SetScoreBombDistance(200)
    LCD38RangeZone:AddBombingTargets( LCD38Range, 30)
    LCD38RangeZone:AddStrafePit(StrafeLCD38, 5000, 1000, nil, false, 20, 0)
    LCD38RangeZone:SetDefaultPlayerSmokeBomb(false)
    LCD38RangeZone:SetRangeControl(263)
    LCD38RangeZone:SetInstructorRadio(305)
    LCD38RangeZone:SetSoundfilesPath("Range Soundfiles/")
LCD38RangeZone:Start()

function LCD38Range:OnAfterImpact(From, Event, To, Result, Player)
    local player = Player
    local result = Result
end

function StrafeLCD38:OnAfterStrafeResult(From, Event, To, Player, Result)
    local player = Player
    local result = Result
end

-- Surface Attack LCD27A
local LCD27ARange = {"Box-8", "Box-9"}
local StrafeLCD27A = {"lcd27as-1", "lcd27as-2", "lcd27as-3"}
LCD27ARangeZone = RANGE:New("LCD27A Range")
    LCD27ARangeZone:SetRangeZone(ZONE:New("LCD27A"))
    LCD27ARangeZone:SetFunkManOn()
    LCD27ARangeZone:SetScoreBombDistance(200)
    LCD27ARangeZone:AddBombingTargets( LCD27ARange, 30)
    LCD27ARangeZone:AddStrafePit(StrafeLCD27A, 5000, 1000, nil, false, 20, 0)
    LCD27ARangeZone:SetDefaultPlayerSmokeBomb(false)
    LCD27ARangeZone:SetRangeControl(264)
    LCD27ARangeZone:SetInstructorRadio(305)
    LCD27ARangeZone:SetSoundfilesPath("Range Soundfiles/")
LCD27ARangeZone:Start()

function LCD27ARange:OnAfterImpact(From, Event, To, Result, Player)
    local player = Player
    local result = Result
end

function StrafeLCD27A:OnAfterStrafeResult(From, Event, To, Player, Result)
    local player = Player
    local result = Result
end

-- Surface Attack OSD21
local OSD21Range = {"Box-10"}
local StrafeOSD21 = {"osd21s-1", "osd21s-2", "osd21s-3"}
OSD21RangeZone = RANGE:New("OSD21 Range")
    OSD21RangeZone:SetRangeZone(ZONE:New("OSD21"))
    OSD21RangeZone:SetFunkManOn()
    OSD21RangeZone:SetScoreBombDistance(200)
    OSD21RangeZone:AddBombingTargets( OSD21Range, 30)
    OSD21RangeZone:AddStrafePit(StrafeOSD21, 5000, 1000, nil, false, 20, 0)
    OSD21RangeZone:SetDefaultPlayerSmokeBomb(false)
    OSD21RangeZone:SetRangeControl(265)
    OSD21RangeZone:SetInstructorRadio(305)
    OSD21RangeZone:SetSoundfilesPath("Range Soundfiles/")
OSD21RangeZone:Start()

function OSD21Range:OnAfterImpact(From, Event, To, Result, Player)
    local player = Player
    local result = Result
end

function StrafeOSD21:OnAfterStrafeResult(From, Event, To, Player, Result)
    local player = Player
    local result = Result
end

-- Create AIRBOSS object for GVAW GCVW 74
local AirbossGVAW=AIRBOSS:New("GCVW 74")
AirbossGVAW:Load()
AirbossGVAW:SetTACAN(74, "X", "STN")
AirbossGVAW:SetICLS(11)
-- AirbossGVAW:_ActivateBeacons()
AirbossGVAW:SetBeaconRefresh(300)
AirbossGVAW:SetLSORadio(132.250)
AirbossGVAW:SetMarshalRadio(131.250)
AirbossGVAW:SetAirbossRadio(130.250)
AirbossGVAW:SetMPWireCorrection(12)
AirbossGVAW:SetDefaultPlayerSkill("TOPGUN Graduate")
AirbossGVAW:SetAutoSave()
AirbossGVAW:Load()
AirbossGVAW:SetTrapSheet()
AirbossGVAW:SetRadioRelayLSO("CVN74-132.25")
AirbossGVAW:SetRadioRelayMarshal("CVN74-131.25")
AirbossGVAW:SetFunkManOn()
AirbossGVAW:SetMaxSectionSize(4)
AirbossGVAW:SetPatrolAdInfinitum(true)

-- Add recovery windows: 
AirbossGVAW:AddRecoveryWindow( "07:00", "17:30", 1, nil, true, 25)
AirbossGVAW:AddRecoveryWindow( "17:31", "23:59", 3, nil, true, 25)
AirbossGVAW:AddRecoveryWindow( "00:00", "06:00", 3, nil, true, 25)

-- Set folder of airboss sound files within miz file.
AirbossGVAW:SetSoundfilesFolder("Airboss Soundfiles/")
AirbossGVAW:SetVoiceOversMarshalByGabriella("Airboss Soundpack Marshal Gabriella/")


-- Skipper menu.
AirbossGVAW:SetMenuSingleCarrier(true)
AirbossGVAW:SetMenuRecovery(30, 25, false)


-- Start airboss class.
AirbossGVAW:Start()

function AirbossGVAW:OnAfterLSOGrade(From, Event, To, playerData, grade)
    local PlayerData = playerData
    local Grade = grade
    local score = tonumber(Grade.points)
    local name = tostring(PlayerData.name)
end

-- Create AIRBOSS LHA object for GVAW LHA
local AirbossLHA=AIRBOSS:New("LHA 1")
AirbossLHA:Load()
AirbossLHA:SetTACAN(75, "X", "LHA")
AirbossLHA:SetICLS(12)
-- AirbossLHA:_ActivateBeacons()
AirbossLHA:SetBeaconRefresh(300)
AirbossLHA:SetLSORadio(130.520)
AirbossLHA:SetMarshalRadio(125.200)
AirbossLHA:SetAirbossRadio(126.500)
AirbossLHA:SetMPWireCorrection(12)
AirbossLHA:SetDefaultPlayerSkill("TOPGUN Graduate")
AirbossLHA:SetAutoSave()
AirbossLHA:Load()
AirbossLHA:SetTrapSheet()
AirbossLHA:SetRadioRelayLSO("LHA-Static-1-1")
AirbossLHA:SetRadioRelayMarshal("LHA-Static-2-1")
AirbossLHA:SetFunkManOn()
AirbossLHA:SetMaxSectionSize(4)
AirbossLHA:SetPatrolAdInfinitum(true)

-- Add recovery windows:
AirbossLHA:AddRecoveryWindow( "07:00", "17:30", 1, nil, true, 25)
AirbossLHA:AddRecoveryWindow( "17:31", "23:59", 3, nil, true, 25)
AirbossLHA:AddRecoveryWindow( "00:00", "06:00", 3, nil, true, 25)

-- Set folder of airboss sound files within miz file. LHA
AirbossLHA:SetSoundfilesFolder("Airboss Soundfiles/")
AirbossLHA:SetVoiceOversMarshalByGabriella("Airboss Soundpack Marshal Gabriella/")


-- Skipper menu.
AirbossLHA:SetMenuSingleCarrier(true)
AirbossLHA:SetMenuRecovery(30, 25, false)


-- Start airboss class.
AirbossLHA:Start()

function AirbossLHA:OnAfterLSOGrade(From, Event, To, playerData, grade)
    local PlayerData = playerData
    local Grade = grade
    local score = tonumber(Grade.points)
    local name = tostring(PlayerData.name)
end


env.info( '*** GVAW TRAINING MUNITION MISSION SCRIPT END ***' )