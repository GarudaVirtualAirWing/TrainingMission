-- Name of same groups.
local groupnames={"Damascus-SA2", "Duhur-SA2", "Khalkhalah-SA3", "Kuweires-SA15", "Minakh-SA3", "Taftanaz-SA3", "Tabqa-SA15", "Talah-SA3"}

--- Function to check ammo and respawn.
local function CheckAmmo()

  -- Loop over all group names.
  for _,groupname in pairs(groupnames) do
  
    -- Get the same group
    local sam=GROUP:FindByName(groupname)  
  
    -- Check if group is still alive.
    if sam and sam:IsAlive() then
  
      -- Get ammo of the whole groupo (we are interested in the number of missiles)
      local Ntot, Nshells, Nrockets, Nbombs, Nmissiles=sam:GetAmmunition()
      
      -- Debug message.
      --local text=string.format("Ammo state:\n")
      --text=text..string.format("Nmissiles=%d", Nmissiles)    
      --MESSAGE:New(text, 30):ToAll():ToLog()
      
      -- Respawn group if number of missiles is 0.
      if Nmissiles==0 then    
        sam:Respawn()    
      end
      
    end
  end
end

-- Start timer after 10 sec that checks the ammo state every 30 sec.
local timer=TIMER:New(CheckAmmo):Start(60, 300)