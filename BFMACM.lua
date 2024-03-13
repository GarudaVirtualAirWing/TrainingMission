-- GVAW BFM SCRIPT --
-- BEGIN ACM/BFM SECTION

--local SpawnBfm.groupName = nil

-- BFM/ACM Zones
BoxZone = ZONE_POLYGON:New( "Polygon_Box", GROUP:FindByName("TheBox") )
BfmAcmZoneMenu = ZONE_POLYGON:New( "Polygon_BFM_ACM", GROUP:FindByName("LTAAZone") )
BfmAcmZone = ZONE:FindByName("LTAA")

-- Spawn Objects
AdvA4 = SPAWN:New( "ADV_A4" )		
Adv28 = SPAWN:New( "ADV_MiG28" )	
Adv27 = SPAWN:New( "ADV_Su27" )
Adv23 = SPAWN:New( "ADV_MiG23" )
Adv16 = SPAWN:New( "ADV_F16" )
Adv18 = SPAWN:New( "ADV_F18" )

-- will need to pass function caller (from menu) to each of these spawn functions.  
-- Then calculate spawn position/velocity relative to caller
function SpawnAdv(adv,qty,group,rng)
	range = rng * 1852
	hdg = group:GetHeading()
	pos = group:GetPointVec2()
	spawnPt = pos:Translate(range, hdg, true)
	spawnVec3 = spawnPt:GetVec3()
	if BoxZone:IsVec3InZone(spawnVec3) then
		MESSAGE:New("Cannot spawn adversary aircraft in The Box.\nChange course or increase your range from The Box, and try again."):ToGroup(group)
	else
		adv:InitGrouping(qty):InitHeading(hdg + 180):SpawnFromVec3(spawnVec3)
		MESSAGE:New("Adversary spawned in your 12 o'clock!"):ToGroup(group)
	end
end

function BuildMenuCommands (AdvMenu, MenuGroup, MenuName, BfmMenu, AdvType, AdvQty)

	_G[AdvMenu] = MENU_GROUP:New( MenuGroup, MenuName, BfmMenu)
		_G[AdvMenu .. "_rng5"] = MENU_GROUP_COMMAND:New( MenuGroup, "5 nmi", _G[AdvMenu], SpawnAdv, AdvType, AdvQty, MenuGroup, 5)
		_G[AdvMenu .. "_rng10"] = MENU_GROUP_COMMAND:New( MenuGroup, "10 nmi", _G[AdvMenu], SpawnAdv, AdvType, AdvQty, MenuGroup, 10)
		_G[AdvMenu .. "_rng20"] = MENU_GROUP_COMMAND:New( MenuGroup, "20 nmi", _G[AdvMenu], SpawnAdv, AdvType, AdvQty, MenuGroup, 20)

end

function BuildMenus(AdvQty, MenuGroup, MenuName, SpawnBfmGroup)

	local AdvSuffix = "_" .. tostring(AdvQty)
	--local BfmMenu = "SpawnBfm" .. AdvSuffix

	BfmMenu = MENU_GROUP:New(MenuGroup, MenuName, SpawnBfmGroup)
	
		BuildMenuCommands("SpawnBfmA4menu" .. AdvSuffix, MenuGroup, "Adversary A-4", BfmMenu, AdvA4, AdvQty)
		BuildMenuCommands("SpawnBfm28menu" .. AdvSuffix, MenuGroup, "Adversary MiG-28", BfmMenu, Adv28, AdvQty)
		BuildMenuCommands("SpawnBfm23menu" .. AdvSuffix, MenuGroup, "Adversary MiG-23", BfmMenu, Adv23, AdvQty)
		BuildMenuCommands("SpawnBfm27menu" .. AdvSuffix, MenuGroup, "Adversary Su-27", BfmMenu, Adv27, AdvQty)
		BuildMenuCommands("SpawnBfm16menu" .. AdvSuffix, MenuGroup, "Adversary F-16", BfmMenu, Adv16, AdvQty)
		BuildMenuCommands("SpawnBfm18menu" .. AdvSuffix, MenuGroup, "Adversary F-18", BfmMenu, Adv18, AdvQty)		
			
end
-- CLIENTS
BLUFOR = SET_GROUP:New():FilterCoalitions( "blue" ):FilterStart()

-- SPAWN AIR MENU
local SetClient = SET_CLIENT:New():FilterCoalitions("blue"):FilterStart() -- create a list of all clients

local function MENU()
	SetClient:ForEachClient(function(client)
		if (client ~= nil) and (client:IsAlive()) then 
 
			local group = client:GetGroup()
			local groupName = group:GetName()
			
			if group:IsPartlyOrCompletelyInZone(BfmAcmZoneMenu) then
				if _G["SpawnBfm" .. groupName] == nil then
					MenuGroup = group
					--MenuGroupName = MenuGroup:GetName()

					_G["SpawnBfm" .. groupName] = MENU_GROUP:New( MenuGroup, "Spawn BFM/ACM Adversary" )
						BuildMenus(1, MenuGroup, "Single", _G["SpawnBfm" .. groupName])
						BuildMenus(2, MenuGroup, "Pair", _G["SpawnBfm" .. groupName])

					MESSAGE:New("You have entered the BFM/ACM zone.\nUse F10 menu to spawn adversaries."):ToGroup(group)
					env.info("BFM/ACM entry Player name: " ..client:GetPlayerName())
					env.info("BFM/ACM entry Group Name: " ..group:GetName())
					--SetClient:Remove(client:GetName(), true)
				end
			elseif _G["SpawnBfm" .. groupName] ~= nil then
				if group:IsNotInZone(BfmAcmZone) then
					_G["SpawnBfm" .. groupName]:Remove()
					_G["SpawnBfm" .. groupName] = nil
					MESSAGE:New("You are outside the ACM/BFM zone."):ToGroup(group)
					env.info("BFM/ACM exit Group Name: " ..group:GetName())
				end
			end
		end
	end)
timer.scheduleFunction(MENU,nil,timer.getTime() + 5)
end

MENU()

-- END ACM/BFM SECTION