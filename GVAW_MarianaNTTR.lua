_SETTINGS:SetPlayerMenuOff()

-- Create a new missile trainer object.
fox=FOX:New()
fox:SetDefaultLaunchAlerts(false)
fox:SetDefaultLaunchMarks(false)
fox:SetDisableF10Menu(true)
fox:SetExplosionDistance(100)
fox:SetExplosionDistanceBigMissiles(200)
fox:AddSafeZone(ZONE:New("ATCAA3NORTH"))
fox:AddSafeZone(ZONE:New("ATCAA3SOUTH"))
fox:AddSafeZone(ZONE:New("ATCAA1"))
fox:AddSafeZone(ZONE:New("ATCAA2"))
fox:AddSafeZone(ZONE:New("ATCAA5"))
fox:SetEnableF10Menu()
fox:Start()

-- NOTE
-- RANGE:AddStrafePit(targetnames, boxlength, boxwidth, heading, inverseheading, goodpass, foulline)

-- Surface Attack FDM
local FDMRange = {"R7201A", "R7201B", "R7201C", "R7201D"}
local StrafeFDM = {"R7201Strafe-1", "R7201Strafe-2", "R7201Strafe-3"}
FDMRangeZone = RANGE:New("Faralon de Medinilla")
    FDMRangeZone:SetRangeZone(ZONE:New("FDM"))
    FDMRangeZone:SetScoreBombDistance(200)
    FDMRangeZone:AddBombingTargets( FDMRange, 30)
    FDMRangeZone:AddStrafePit(StrafeFDM, 5000, 1000, nil, false, 20, 0)
    FDMRangeZone:SetDefaultPlayerSmokeBomb(false)
    FDMRangeZone:SetRangeControl(260)
    FDMRangeZone:SetInstructorRadio(270)
FDMRangeZone:Start()

function FDMRange:OnAfterImpact(From, Event, To, Result, Player)
    local player = Player
    local result = Result
end

function StrafeFDM:OnAfterStrafeResult(From, Event, To, Player, Result)
    local player = Player
    local result = Result
end


-- Surface Attack Aguijan Range
local AguijanRange = {"AguijanBC"}
local StrafeAguijan = {"AguijanStrafe-1", "AguijanStrafe-2", "AguijanStrafe-3"}
AguijanRangeZone = RANGE:New("Aguijan Range")
    AguijanRangeZone:SetRangeZone(ZONE:New("Aguijan"))
    AguijanRangeZone:SetScoreBombDistance(200)
    AguijanRangeZone:AddBombingTargets( AguijanRange, 30)
    AguijanRangeZone:AddStrafePit(StrafeAguijan, 5000, 1000, nil, false, 20, 0)
    AguijanRangeZone:SetDefaultPlayerSmokeBomb(false)
    AguijanRangeZone:SetRangeControl(260)
    AguijanRangeZone:SetInstructorRadio(270)
AguijanRangeZone:Start()

function AguijanRange:OnAfterImpact(From, Event, To, Result, Player)
    local player = Player
    local result = Result
end

function StrafeAguijan:OnAfterStrafeResult(From, Event, To, Player, Result)
    local player = Player
    local result = Result
end