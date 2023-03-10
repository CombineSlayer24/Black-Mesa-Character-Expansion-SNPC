/* Note: All credits go to Cpt. Hazama. I take no credit for this. */
AddCSLuaFile("shared.lua")
include('shared.lua')

local table_insert = table.insert
local table_remove = table.remove


ENT.Zombie = {
	{class="npc_vj_bmce_und_wlk_sci_male",chance=1},
	{class="npc_vj_bmce_und_run_sci_male",chance=1},
	{class="npc_vj_bmce_und_wlk_sci_cas_male",chance=1},
	{class="npc_vj_bmce_und_run_sci_cas_male",chance=1},
	{class="npc_vj_bmce_und_wlk_guard",chance=1},
	{class="npc_vj_bmce_und_run_guard",chance=1},
	{class="npc_vj_bmce_und_wlk_guardfem",chance=1},
	{class="npc_vj_bmce_und_run_guardfem",chance=1},
}

ENT.SpecialZombie = {
	{class="npc_vj_bmce_und_wlk_guardfem",max=5},
}
-- i'll add the main characters as special zmbs
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	local i = 0
	for k, v in ipairs(ents.GetAll()) do
		if v:GetClass() == "sent_vj_bmce_undead_mapspawner" then
			i = i + 1
			if i > 1 then PrintMessage(HUD_PRINTTALK, "ALERT: Only one Map Spawner can exist on the map.") self.SkipOnRemove = true self:Remove() v:EmitSound("plats/elevbell1.wav",100) return end
		end
	end

	self.nodePositions = {}
	self.navAreas = {}
	
	for _,pos in pairs(VJ_LNR_NODEPOS) do
		if pos then table_insert(self.nodePositions,{Position = pos, Time = 0}) end
	end

	for _,nav in pairs(navmesh.GetAllNavAreas()) do
		if nav then table_insert(self.navAreas,nav) end
	end

	local count = #self.nodePositions +#self.navAreas
	if count <= 50 then
		local msg = "Low node/nav-area count detected! The Map Spawner may find it difficult to process with such low nodes/nav-areas...removing..."
		if count <= 0 then
			msg = "No nodes or nav-mesh detected! The Map Spawner relies on nodes/nav-areas for many things. Without any, the Map Spawner will not work! The Map Spawner will now remove itself..."
		end
		MsgN(msg)
		if IsValid(self:GetCreator()) then
			self:GetCreator():ChatPrint(msg)
		end
		SafeRemoveEntity(self)
		return
	end

	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:SetPos(Vector(0, 0, 0))
	self:SetNoDraw(true)
	self:DrawShadow(false)
	
	self.IsActivated = tobool(GetConVarNumber("VJ_LNR_MapSpawner_Enabled"))
	self.LNR_SpawnDistance = GetConVarNumber("VJ_LNR_MapSpawner_SpawnMax")
	self.LNR_SpawnDistanceClose = GetConVarNumber("VJ_LNR_MapSpawner_SpawnMin")
	self.LNR_HordeChance = GetConVarNumber("VJ_LNR_MapSpawner_HordeChance")
	self.LNR_HordeCooldownMin = GetConVarNumber("VJ_LNR_MapSpawner_HordeCooldownMin")
	self.LNR_HordeCooldownMax = GetConVarNumber("VJ_LNR_MapSpawner_HordeCooldownMax")
	self.LNR_MaxZombie = GetConVarNumber("VJ_LNR_MapSpawner_MaxZom")
	self.LNR_MaxHordeSpawn = GetConVarNumber("VJ_LNR_MapSpawner_HordeCount")
	self.tbl_SpawnedNPCs = {}
	self.tbl_NPCsWithEnemies = {}
	self.tbl_SpawnedSpecialZombie = {}
	self.NextAICheckTime = CurTime() + 5
	self.NextZombieSpawnTime = CurTime() + 1
	self.NextSpecialZombieSpawnTime = CurTime() + 9999
	self.NextHordeSpawnTime = CurTime() +math.Rand(self.LNR_HordeCooldownMin,self.LNR_HordeCooldownMax)
	self.NextAISpecialCheckTime = CurTime() + 5
	self.HordeSpawnRate = 0.19
	self.MaxSpecialZombie = 0
	--self.CanSpawnSpecialZombie = true 

	for _,v in ipairs(player.GetAll()) do

		if GetConVarNumber("vj_bmce_zmb_map_spooky_snds") == 1 then
			
			timer.Create("vj_bmce_undead_mapspawn_amb_snds",math.random(8,26),0,function()
				v:EmitSound("vj_bmce_zmb/map_spawner/nz_zmb_amb_sfx/nz_zombie_protoype/amb_spooky_"..math.random(0,21)..".mp3", 45)
			end)
			
			timer.Create("vj_bmce_undead_mapspawn_amb_music",math.random(35,75),0,function()
				v:EmitSound("vj_bmce_zmb/map_spawner/nz_zmb_amb_sfx/nz_zmb_proto_amb_spooky_"..math.random(1,4)..".mp3", 45)
			end)
		
		end

		if GetConVarNumber("vj_bmce_zmb_map_music") == 1 then
			v:EmitSound("vj_bmce_zmb/map_spawner/map_tune"..math.random(1,8)..".mp3", 51)
		end

		v:ChatPrint("Warning: Undead are nearby.")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CheckVisibility(pos,ent,mdl)
	local check = ents.Create("prop_vj_animatable")
	check:SetModel(mdl or "models/vj_lnrhl2/barney.mdl")
	check:SetPos(pos)
	check:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	check:Spawn()
	check:SetNoDraw(true)
	check:DrawShadow(false)
	self:DeleteOnRemove(check)
	timer.Simple(0,function()
		SafeRemoveEntity(check)
	end)

	return ent:Visible(check)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindCenterNavPoint(ent)
	for _,v in RandomPairs(self.navAreas) do
		local testPos = v:GetCenter()
		local dist = testPos:Distance(ent:GetPos())
		if dist <= self.LNR_SpawnDistance && dist >= self.LNR_SpawnDistanceClose && !self:CheckVisibility(testPos,ent) then
			return testPos
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindHiddenNavPoint(ent)
	for _,v in RandomPairs(self.navAreas) do
		local hidingSpots = v:GetHidingSpots()
		if !hidingSpots then continue end
		if #hidingSpots <= 0 then continue end
		local testPos = VJ_PICK(hidingSpots)
		local dist = testPos:Distance(ent:GetPos())
		if dist <= self.LNR_SpawnDistance && dist >= self.LNR_SpawnDistanceClose && !self:CheckVisibility(testPos,ent) then
			return testPos
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindRandomNavPoint(ent)
	for _,v in RandomPairs(self.navAreas) do
		local testPos = v:GetRandomPoint()
		local dist = testPos:Distance(ent:GetPos())
		if dist <= self.LNR_SpawnDistance && dist >= self.LNR_SpawnDistanceClose && !self:CheckVisibility(testPos,ent) then
			return testPos
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetClosestNavPosition(ent,getHidden)
	local pos = false
	local closestDist = 999999999
	for i,v in pairs(self.navAreas) do
		local hidingSpots = getHidden && v:GetHidingSpots() or true
		if !hidingSpots then continue end
		if istable(hidingSpots) && #hidingSpots <= 0 then continue end
		local testPos = getHidden && VJ_PICK(v:GetHidingSpots()) or v:GetRandomPoint()
		local dist = ent:GetPos():Distance(testPos)
		if dist < closestDist && (dist <= self.LNR_SpawnDistance && dist >= self.LNR_SpawnDistanceClose && !self:CheckVisibility(testPos,ent)) then
			closestDist = dist
			pos = testPos
		end
	end
	return pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetClosestNodePosition(ent)
	local pos = false
	local closestDist = 999999999
	for i,v in pairs(self.nodePositions) do
		if !self:IsNodeUsable(i) then continue end
		local testPos = self:GetNodePosition(i)
		local dist = ent:GetPos():Distance(testPos)
		if dist < closestDist && (dist <= self.LNR_SpawnDistance && dist >= self.LNR_SpawnDistanceClose && !self:CheckVisibility(testPos,ent)) then
			closestDist = dist
			pos = testPos
		end
	end
	return pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindRandomNodePosition(ent)
	for i,v in RandomPairs(self.nodePositions) do
		if !self:IsNodeUsable(i) then continue end
		local testPos = self:GetNodePosition(i)
		local dist = ent && testPos:Distance(ent:GetPos()) or 0
		if ent then
			return testPos
		else
			if dist <= self.LNR_SpawnDistance && dist >= self.LNR_SpawnDistanceClose && !self:CheckVisibility(testPos,ent) then
				return testPos
			end
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindSpawnPosition(getClosest,findHidden)
	local nodes = self.nodePositions
	local navareas = self.navAreas
	local useNav = (#nodes <= 0 && #navareas > 0) or (#navareas > 0 && #nodes > 0 && math.random(1,2) == 1) or false
	local pos = false
	
	if useNav then
		local getHidden = findHidden or math.random(1,3) == 1
		local testEnt = self:GetRandomEnemy()
		pos = getClosest && self:GetClosestNavPosition(testEnt,getHidden) or getHidden && self:FindHiddenNavPoint(testEnt) or self:FindRandomNavPoint(testEnt)
	else
		local testEnt = self:GetRandomEnemy()
		pos = getClosest && self:GetClosestNodePosition(testEnt) or self:FindRandomNodePosition(testEnt)
	end
	return pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetNodePosition(i)
	return self.nodePositions[i].Position
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsNodeUsable(i)
	return self.nodePositions[i].Time < CurTime()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindEnemy()
	local tbl = {}
	for _,v in pairs(ents.GetAll()) do
		if (v:IsPlayer() || v:IsNPC()) && v:Health() > 0 && !v:IsFlagSet(65536) && (v.VJ_NPC_Class && !VJ_HasValue(v.VJ_NPC_Class,"CLASS_ZOMBIE") or true) then
			table_insert(tbl,v)
		end
	end
	return tbl
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetRandomEnemy()
	return VJ_PICK(self:FindEnemy())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetClosestEnemy(pos)
	local ent = NULL
	local closestDist = 999999999
	for _,v in pairs(self:FindEnemy()) do
		local dist = v:GetPos():Distance(pos)
		if dist < closestDist then
			closestDist = dist
			ent = v
		end
	end
	return ent
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CheckEnemyDistance(ent,remove)
	local remove = remove or true
	local closestDist = 999999999
	local visible = false
	for _,v in pairs(self:FindEnemy()) do
		local dist = v:GetPos():Distance(ent:GetPos())
		if dist < closestDist then
			closestDist = dist
		end
		if v:Visible(ent) then
			visible = true -- Visible to someone, don't bother removing
		end
	end
	if closestDist >= GetConVarNumber("VJ_LNR_MapSpawner_SpawnMax") +1000 && !visible && !remove then
		SafeRemoveEntity(ent)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	self.IsActivated = GetConVar("VJ_LNR_MapSpawner_Enabled")
	if self.IsActivated then 
		-- Manage ConVar data
	    self.LNR_SpawnDistance = GetConVarNumber("VJ_LNR_MapSpawner_SpawnMax")
	    self.LNR_SpawnDistanceClose = GetConVarNumber("VJ_LNR_MapSpawner_SpawnMin")
	    self.LNR_HordeChance = GetConVarNumber("VJ_LNR_MapSpawner_HordeChance")
	    self.LNR_HordeCooldownMin = GetConVarNumber("VJ_LNR_MapSpawner_HordeCooldownMin")
	    self.LNR_HordeCooldownMax = GetConVarNumber("VJ_LNR_MapSpawner_HordeCooldownMax")
	    self.LNR_MaxZombie = GetConVarNumber("VJ_LNR_MapSpawner_MaxZom")
	    self.LNR_MaxHordeSpawn = GetConVarNumber("VJ_LNR_MapSpawner_HordeCount")
		self.AI_RefreshTime = GetConVarNumber("VJ_LNR_MapSpawner_RefreshRate") 
		
		-- Checks for inactive AI, this code is quite bulky and might be able to be optimized better
		if CurTime() > self.NextAICheckTime then
			if #self.tbl_SpawnedNPCs > 0 then
				for i,v in ipairs(self.tbl_SpawnedNPCs) do
					if IsValid(v) then
						local enemy = v:GetEnemy()
						self:CheckEnemyDistance(v)
						if IsValid(enemy) && !VJ_HasValue(self.tbl_NPCsWithEnemies,v) then
							table_insert(self.tbl_NPCsWithEnemies,v)
						elseif !IsValid(enemy) then
							if VJ_HasValue(self.tbl_NPCsWithEnemies,v) then
								table_remove(self.tbl_NPCsWithEnemies,i)
							end
						end
					else
						table_remove(self.tbl_SpawnedNPCs,i)
					end
				end
			end

			if #self.tbl_SpawnedSpecialZombie > 0 then
				for i,v in ipairs(self.tbl_SpawnedSpecialZombie) do
					if IsValid(v) then
						local enemy = v:GetEnemy()
						self:CheckEnemyDistance(v)
						if IsValid(enemy) && !VJ_HasValue(self.tbl_NPCsWithEnemies,v) then
							table_insert(self.tbl_NPCsWithEnemies,v)
						elseif !IsValid(enemy) then
							if VJ_HasValue(self.tbl_NPCsWithEnemies,v) then
								table_remove(self.tbl_NPCsWithEnemies,i)
							end	
						end
					else
						table_remove(self.tbl_SpawnedSpecialZombie,i)
					end
				end
			end
			self.NextAICheckTime = CurTime() +5
		end

		-- Spawns AI		
		if CurTime() > self.NextZombieSpawnTime then
			if #self.tbl_SpawnedNPCs >= self.LNR_MaxZombie -self.LNR_MaxHordeSpawn then return end -- Makes sure that we can at least spawn a mob when it's time
			self:SpawnZombie(self:PickZombie(self.Zombie),self:FindSpawnPosition(false))				
			self.NextZombieSpawnTime = CurTime() +math.Rand(GetConVarNumber("VJ_LNR_MapSpawner_DelayMin"),GetConVarNumber("VJ_LNR_MapSpawner_DelayMax"))
			
		end

		if CurTime() > self.NextSpecialZombieSpawnTime then
			self:SpawnSpecialZombie(self:PickZombie(self.SpecialZombie),self:FindSpawnPosition(true))
			self.NextSpecialZombieSpawnTime = CurTime() +math.Rand(4,20)			
		end	

		-- Spawns Hordes
		if CurTime() > self.NextHordeSpawnTime && math.random(1,self.LNR_HordeChance) == 1 then
			for i = 1,self.LNR_MaxHordeSpawn do
				timer.Simple(self.HordeSpawnRate *i,function() -- Help with lag when spawning
					if IsValid(self) then
						self:SpawnZombie(self:PickZombie(self.Zombie),self:FindSpawnPosition(true,true),true)					
					end
				end)
			end

			for _,v in ipairs(player.GetAll()) do
				v:ChatPrint("Incoming horde!")
				v:EmitSound("vj_bmce_zmb/map_spawner/map_tune"..math.random(1,6)..".mp3", 51)
			end			
			self.NextHordeSpawnTime = CurTime() +math.Rand(self.LNR_HordeCooldownMin,self.LNR_HordeCooldownMax)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpecialCount(class)
	local count = 0
	for _,v in pairs(self.tbl_SpawnedSpecialZombie) do
		if IsValid(v) && v:GetClass() == class then
			count = count +1
		end
	end
	return count
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PickZombie(tbl)
	local useMax = tbl == self.SpecialZombie
	local ent = false
	for _,v in RandomPairs(tbl) do
		if !useMax then
			if math.random(1,v.chance) == 1 then
				ent = v.class
				break
			end
		else
			if self:GetSpecialCount(v.class) < v.max then
				ent = v.class
				break
			end
		end
	end
	return ent
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnZombie(ent,pos,isMob)
    if GetConVar("VJ_LNR_MapSpawner_HL2"):GetInt() == 0 then return end
	if ent == false then return end
	if pos == nil or pos == false then return end
	if #self.tbl_SpawnedNPCs >= self.LNR_MaxZombie then return end
	local Zombie = ents.Create(ent)
	Zombie:SetPos(pos)
	Zombie:SetAngles(Angle(0,math.random(0,360),0))
	Zombie:Spawn()
	table_insert(self.tbl_SpawnedNPCs,Zombie)
	Zombie.MapSpawner = self
	Zombie.EntitiesToNoCollide = {}
	for _,v in pairs(self.Zombie) do
		table_insert(Zombie.EntitiesToNoCollide,v.class)
	end
	for _,v in pairs(self.SpecialZombie) do
		table_insert(Zombie.EntitiesToNoCollide,v.class)
    end			
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnSpecialZombie(ent,pos)
	if GetConVar("VJ_LNR_MapSpawner_Specials"):GetInt() == 0 then return end 
	if ent == false then return end
	if pos == nil or pos == false then return end
	if #self.tbl_SpawnedSpecialZombie >= self.MaxSpecialZombie then return end

	local Special_Zombie = ents.Create(ent)
	Special_Zombie:SetPos(pos)
	Special_Zombie:SetAngles(Angle(0,math.random(0,360),0))
	Special_Zombie:Spawn()
	table_insert(self.tbl_SpawnedSpecialZombie,Special_Zombie)
	Special_Zombie.MapSpawner = self
	Special_Zombie.EntitiesToNoCollide = {}
	for _,v in pairs(self.Zombie) do
		table_insert(Special_Zombie.EntitiesToNoCollide,v.class)
	end	
	for _,v in pairs(self.SpecialZombie) do
		table_insert(Special_Zombie.EntitiesToNoCollide,v.class)
    end			
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	local SoundTbl_DeathGib =
	{
		"vj_bmce_zmb/vocals/headshot_0.wav",
		"vj_bmce_zmb/vocals/headshot_1.wav",
		"vj_bmce_zmb/vocals/headshot_2.wav",
		"vj_bmce_zmb/vocals/headshot_3.wav",
		"vj_bmce_zmb/vocals/headshot_4.wav",
		"vj_bmce_zmb/vocals/headshot_5.wav",
		"vj_bmce_zmb/vocals/headshot_6.wav"
	}

	if GetConVarNumber("vj_bmce_zmb_map_spooky_snds") == 1 then
		timer.Remove("vj_bmce_undead_mapspawn_amb_snds")
		timer.Remove("vj_bmce_undead_mapspawn_amb_music")
	end

	if GetConVarNumber("vj_bmce_zmb_map_delete") == 1 then
		for index,object in ipairs(self.tbl_SpawnedNPCs) do
			if IsValid(object) then
				object:PlaySoundSystem("Death", SoundTbl_DeathGib)
				//object:PlaySoundSystem("Death")
				object:TakeDamage(object:Health(), object, object)
				local fire = math.random(1,2)
	
				if fire == 1 then
					object:Ignite(10)
				end
			end
		end
		
		for index,object in ipairs(self.tbl_SpawnedSpecialZombie) do
			if IsValid(object) then
				object:Remove()
			end
		end

		for _,v in ipairs(player.GetAll()) do
			v:EmitSound("vj_bmce_zmb/map_spawner/nz_zmb_amb_sfx/nz_zombie_protoype/amb_spooky_20.mp3",45)
			v:EmitSound("vj_bmce_zmb/map_spawner/removed.mp3", 51)

			timer.Create("vj_bmce_undead_mapspawn_secondlaugh",12,1,function() v:EmitSound("vj_bmce_zmb/map_spawner/removed_laugh.mp3", 51) end)
		end
	end
end