AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.AnimTbl_Walk = {ACT_RUN}
ENT.AnimTbl_Run = {ACT_RUN}
ENT.LNR_AllowedToStumble = true
ENT.LNR_Gib = false
ENT.LNR_Dismember = false
ENT.LNR_CanBeHeadshot = true 
ENT.LNR_VirusInfection = true
ENT.LNR_Infected = true
ENT.LNR_SuperSprinter = false
ENT.LNR_Crawler = false
ENT.HasBloodDecal = true -- Does it spawn a decal when damaged?
//ENT.CustomBlood_Decal = {"VJ_Manhunt_Blood_DarkRed"} -- Decals to spawn when it's damaged
ENT.BloodDecalUseGMod = false -- Should use the current default decals defined by Garry's Mod? (This only applies for certain blood types only!)
ENT.LNR_Gibbed = false

function ENT:CustomOnInitialize()

	self.Zombie_EnergyTime = CurTime() + math.Rand(GetConVar("vj_bmce_zmb_deathtime_min"):GetInt(), GetConVar("vj_bmce_zmb_deathtime_max"):GetInt()) 

	self:Zombie_Difficulty()

	self:SetNPCBodyGroups()

	if GetConVarNumber("vj_bmce_zmb_eyeglow") == 1 then
        local color
        local c_string
        local cmd_enable = GetConVarNumber("vj_bmce_zmb_eyeglow") // sets eye color

		if cmd_enable == 1 then // light blue
			color = Color(240,96,0,255)
			c_string = "240 96 0 255"
		end

		eyeglow1 = ents.Create("env_sprite")
		eyeglow1:SetKeyValue("model","models/sprites/eyeglow_sprite.vmt")
		eyeglow1:SetKeyValue("scale","0.005")
		eyeglow1:SetKeyValue("rendermode","5")
		eyeglow1:SetKeyValue("rendercolor",c_string)
		eyeglow1:SetKeyValue("spawnflags","1") -- If animated
		eyeglow1:SetParent(self)
		eyeglow1:Fire("SetParentAttachment","RightEye",0)
		eyeglow1:Spawn()
		eyeglow1:Activate()
		util.SpriteTrail(self,2,color,true,6,6,0.125,1/(6+12)*0.5,"VJ_Base/sprites/vj_trial1.vmt")
		self:DeleteOnRemove(eyeglow1)

		eyeglow2 = ents.Create("env_sprite")
		eyeglow2:SetKeyValue("model","models/sprites/eyeglow_sprite.vmt")
		eyeglow2:SetKeyValue("scale","0.005")
		eyeglow2:SetKeyValue("rendermode","5")
		eyeglow2:SetKeyValue("rendercolor",c_string)
		eyeglow2:SetKeyValue("spawnflags","1") -- If animated
		eyeglow2:SetParent(self)
		eyeglow2:Fire("SetParentAttachment","LeftEye",0)
		eyeglow2:Spawn()
		eyeglow2:Activate()
		util.SpriteTrail(self,1,color,true,6,6,0.125,1/(6+12)*0.5,"VJ_Base/sprites/vj_trial1.vmt")
		self:DeleteOnRemove(eyeglow2)
    end
--[[ 
	if GetConVar("VJ_LNR_Crawl"):GetInt() == 1 then
		if math.random(1,5) == 1 then 
		   self.LNR_Crawler = true
		   self:SetCrawler()
	   end
	end ]]

	if GetConVar("VJ_LNR_MeleeWeapons"):GetInt() == 1 then
		if math.random(1,5) == 1 && !self.LNR_Crawler then 
		   self.LNR_CanUseWeapon = true
		   self:ZombieWeapons()
	   end
	end

	if GetConVar("VJ_LNR_DeathAnimations"):GetInt() == 0 then 
		self.HasDeathAnimation = false	
	end
	if GetConVar("VJ_LNR_Alert"):GetInt() == 0 then 
		self.CallForHelp = false
	end
	if GetConVar("VJ_LNR_BreakDoors"):GetInt() == 1 then
		self.LNR_CanBreakDoors = true	 
		self.CanOpenDoors = false
	end

	if GetConVarNumber("vj_bmce_zmb_faster") == 0 then 
		local random_supersprint = math.random(0,24)
		if random_supersprint == 0 && !self.LNR_Crawler then // Random super sprinter
			self.AnimTbl_Run = {ACT_RUN}
		elseif random_supersprint == 8 && !self.LNR_Crawler then // supe sprint
			self.AnimTbl_Run = {ACT_SPRINT}
		elseif random_supersprint == 24 && !self.LNR_Crawler then // super sonic sprint
			self.LNR_SuperSprinter = true
			self.AnimTbl_Run = {ACT_RUN_AIM}
		end
	end	

	if GetConVarNumber("vj_bmce_zmb_faster") == 1 then 
		local sprint_anim = math.random(1,8)
		if sprint_anim == 1 && !self.LNR_Crawler then
			self.AnimTbl_Run = {ACT_SPRINT}
		elseif sprint_anim == 2 && !self.LNR_Crawler then
			self.AnimTbl_Run = {ACT_SPRINT}
		elseif sprint_anim == 3 && !self.LNR_Crawler then
			self.AnimTbl_Run = {ACT_SPRINT}
		elseif sprint_anim == 4 && !self.LNR_Crawler then
			self.AnimTbl_Run = {ACT_SPRINT}
		elseif sprint_anim == 5 && !self.LNR_Crawler then
			self.AnimTbl_Run = {ACT_SPRINT}
		elseif sprint_anim == 6 && !self.LNR_Crawler then
			self.AnimTbl_Run = {ACT_SPRINT}
		elseif sprint_anim == 7 && !self.LNR_Crawler then
			self.LNR_SuperSprinter = true
			self.AnimTbl_Run = {ACT_RUN_AIM}
		elseif sprint_anim == 8 && !self.LNR_Crawler then // super sonic sprint
			self.LNR_SuperSprinter = true
			self.AnimTbl_Run = {ACT_RUN_AIM}
		end
	end
	
	if GetConVarNumber("vj_bmce_zmb_riser") == 1 then // If ZMB Riser cmd is on, undead will use the Rising out of dirt animation
		local random_riser = math.random(1,5)
		if random_riser == 1 then
			if self:IsDirt(self:GetPos()) then
				self:SetNoDraw(true)
				timer.Simple(0.01,function()
					self:VJ_ACT_PLAYACTIVITY("vjseq_nz_spawn_climbout_fast",true,4.55,true,0,{SequenceDuration=4.55})
					self.HasMeleeAttack = false
					timer.Simple(0.2,function()
						if self:IsValid() then
							self:SetNoDraw(false)
							self:EmitSound("vj_bmce_zmb/vocals/spawn_dirt_0" .. math.random(0,1) .. ".wav")
							local effectdata = EffectData()
							effectdata:SetOrigin(self:GetPos())
							effectdata:SetScale(25)
							util.Effect("zombie_spawn_dirt",effectdata)
							self.HasMeleeAttack = true
						end
					end)
				end)
			end

		elseif random_riser == 2 then
			if self:IsDirt(self:GetPos()) then
				self:SetNoDraw(true)
				timer.Simple(0.01,function()
					self:VJ_ACT_PLAYACTIVITY("vjseq_nz_spawn_climbout_fast",true,4.55,true,0,{SequenceDuration=4.55})
					self.HasMeleeAttack = false
					timer.Simple(0.2,function()
						if self:IsValid() then
							self:SetNoDraw(false)
							self:EmitSound("vj_bmce_zmb/vocals/spawn_dirt_0" .. math.random(0,1) .. ".wav")
							local effectdata = EffectData()
							effectdata:SetOrigin(self:GetPos())
							effectdata:SetScale(25)
							util.Effect("zombie_spawn_dirt",effectdata)
							self.HasMeleeAttack = true
						end
					end)
				end)
			end

		elseif random_riser == 3 then
			if self:IsDirt(self:GetPos()) then
				self:SetNoDraw(true)
				timer.Simple(0.01,function()
					self:VJ_ACT_PLAYACTIVITY("vjseq_nz_spawn_climbout_fast",true,4.55,true,0,{SequenceDuration=4.55})
					self.HasMeleeAttack = false
					timer.Simple(0.2,function()
						if self:IsValid() then
							self:SetNoDraw(false)
							self:EmitSound("vj_bmce_zmb/vocals/spawn_dirt_0" .. math.random(0,1) .. ".wav")
							local effectdata = EffectData()
							effectdata:SetOrigin(self:GetPos())
							effectdata:SetScale(25)
							util.Effect("zombie_spawn_dirt",effectdata)
							self.HasMeleeAttack = true
						end
					end)
				end)
			end

		elseif random_riser == 4 then
			if self:IsDirt(self:GetPos()) then
				self:SetNoDraw(true)
				timer.Simple(0.01,function()
					self:VJ_ACT_PLAYACTIVITY("vjseq_nz_spawn_jump",true,1.25,true,0,{SequenceDuration=1.25})
					self.HasMeleeAttack = false
					timer.Simple(0.2,function()
						if self:IsValid() then
							self:SetNoDraw(false)
							self:EmitSound("vj_bmce_zmb/vocals/spawn_dirt_0" .. math.random(0,1) .. ".wav")
							local effectdata = EffectData()
							effectdata:SetOrigin(self:GetPos())
							effectdata:SetScale(25)
							util.Effect("zombie_spawn_dirt",effectdata)
							self.HasMeleeAttack = true
						end
					end)
				end)
			end

		elseif random_riser == 5 then
			if self:IsDirt(self:GetPos()) then
				self:SetNoDraw(true)
				timer.Simple(0.01,function()
					self:VJ_ACT_PLAYACTIVITY("vjseq_nz_spawn_jump",true,1.25,true,0,{SequenceDuration=1.25})
					self.HasMeleeAttack = false
					timer.Simple(0.2,function()
						if self:IsValid() then
							self:SetNoDraw(false)
							self:EmitSound("vj_bmce_zmb/vocals/spawn_dirt_0" .. math.random(0,1) .. ".wav")
							local effectdata = EffectData()
							effectdata:SetOrigin(self:GetPos())
							effectdata:SetScale(25)
							util.Effect("zombie_spawn_dirt",effectdata)
							self.HasMeleeAttack = true
						end
					end)
				end)
			end
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "step" then
		self:FootStepSoundCode()
	end
	if key == "infection_step" && self:IsOnGround() then
	local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() +Vector(0,0,-150),
		filter = {self}
	})
	if tr.Hit && self.FootSteps[tr.MatType] then
		VJ_EmitSound(self,VJ_PICK(self.FootSteps[tr.MatType]),self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
	end
	end
    if key == "step" then
		VJ_EmitSound(self,"npc/zombie/foot"..math.random(1,3)..".wav",self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch.a,self.FootStepPitch.b))			
	end	
	if key == "slide" then
		VJ_EmitSound(self,"vj_bmce_zmb/vocals/extras/foot_Slide_00.wav",self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch.a,self.FootStepPitch.b))
	end
	if key == "crawl" then
		VJ_EmitSound(self,"vj_bmce_zmb/vocals/extras/crawl_0"..math.random(3)..".wav",self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch.a,self.FootStepPitch.b))
	end
	if key == "crawl" && self:WaterLevel() > 0 && self:WaterLevel() < 3 then
		VJ_EmitSound(self,"player/footsteps/wade" .. math.random(1,8) .. ".wav",self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch.a,self.FootStepPitch.b))
	end
	if key == "climb" then
		VJ_EmitSound(self,"player/footsteps/ladder"..math.random(1,4)..".wav",self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch.a,self.FootStepPitch.b))
	end		
	if key == "attack" then
		self:MeleeAttackCode()		
	end		
	if key == "death" then
		VJ_EmitSound(self,"physics/body/body_medium_impact_soft"..math.random(1,7)..".wav",75,100)
	end
    if key == "death" && self:WaterLevel() > 0 && self:WaterLevel() < 3 then
        VJ_EmitSound(self,"ambient/water/water_splash"..math.random(1,3)..".wav",75,100)
	end	
	if key == "break_door" then
		if IsValid(self.LNR_DoorToBreak) then
		//VJ_CreateSound(self,self.SoundTbl_BeforeMeleeAttack,self.BeforeMeleeAttackSoundLevel,self:VJ_DecideSoundPitch(self.BeforeMeleeAttackSoundPitch.a, self.BeforeMeleeAttackSoundPitch.b))
		VJ_EmitSound(self,"vj_bmce_zmb/vocals/extras/snap_0"..math.random(5)..".wav",85,100)
		local doorDmg = self.MeleeAttackDamage
		local door = self.LNR_DoorToBreak
		if door.DoorHealth == nil then
			door.DoorHealth = 200 - doorDmg
		else
			door.DoorHealth = door.DoorHealth - doorDmg
		end
		if door.DoorHealth <= 0 then
			//door:EmitSound("physics/wood/wood_furniture_break"..math.random(1,2)..".wav",75,100)
			door:EmitSound("vj_bmce_zmb/vocals/extras/slam_0"..math.random(5)..".wav",90,100)
			ParticleEffect("door_pound_core",door:GetPos(),door:GetAngles(),nil)
			ParticleEffect("door_explosion_chunks",door:GetPos(),door:GetAngles(),nil)
			door:Remove()
            local doorgibs = ents.Create("prop_dynamic")
            doorgibs:SetPos(door:GetPos())
            doorgibs:SetModel("models/props_c17/FurnitureDresser001a.mdl")
            doorgibs:Spawn()
            doorgibs:TakeDamage(9999)
            doorgibs:Fire("break")
			end
		end
	end	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsDirt(pos)
	local tr = util.TraceLine({
		start = pos,
		endpos = pos -Vector(0,0,40),
		filter = self,
		mask = MASK_NPCWORLDSTATIC
	})
	local mat = tr.MatType
	return tr.HitWorld && (mat == MAT_SAND || mat == MAT_DIRT || mat == MAT_FOLIAGE || mat == MAT_SLOSH || mat == MAT_GRASS || mat == 74)
end

ENT.FootSteps = {
	[MAT_ANTLION] = {
		"vj_bmce/footsteps/flesh_step1.mp3",
		"vj_bmce/footsteps/flesh_step2.mp3",
		"vj_bmce/footsteps/flesh_step3.mp3",
		"vj_bmce/footsteps/flesh_step4.mp3",
		"vj_bmce/footsteps/flesh_step5.mp3",
		"vj_bmce/footsteps/flesh_step6.mp3",
		"vj_bmce/footsteps/flesh_step7.mp3",
		"vj_bmce/footsteps/flesh_step8.mp3",
		"vj_bmce/footsteps/flesh_step9.mp3",
		"vj_bmce/footsteps/flesh_step10.mp3"
	},
	[MAT_BLOODYFLESH] = {
		"vj_bmce/footsteps/flesh_step1.mp3",
		"vj_bmce/footsteps/flesh_step2.mp3",
		"vj_bmce/footsteps/flesh_step3.mp3",
		"vj_bmce/footsteps/flesh_step4.mp3",
		"vj_bmce/footsteps/flesh_step5.mp3",
		"vj_bmce/footsteps/flesh_step6.mp3",
		"vj_bmce/footsteps/flesh_step7.mp3",
		"vj_bmce/footsteps/flesh_step8.mp3",
		"vj_bmce/footsteps/flesh_step9.mp3",
		"vj_bmce/footsteps/flesh_step10.mp3"
	},
	[MAT_CONCRETE] = {
		"vj_bmce/footsteps/concrete_step1.mp3",
		"vj_bmce/footsteps/concrete_step2.mp3",
		"vj_bmce/footsteps/concrete_step3.mp3",
		"vj_bmce/footsteps/concrete_step4.mp3",
		"vj_bmce/footsteps/concrete_step5.mp3",
		"vj_bmce/footsteps/concrete_step6.mp3",
		"vj_bmce/footsteps/concrete_step7.mp3",
		"vj_bmce/footsteps/concrete_step8.mp3",
		"vj_bmce/footsteps/concrete_grit_step1.mp3",
		"vj_bmce/footsteps/concrete_grit_step2.mp3",
		"vj_bmce/footsteps/concrete_grit_step3.mp3",
		"vj_bmce/footsteps/concrete_grit_step4.mp3",
		"vj_bmce/footsteps/concrete_grit_step5.mp3",
		"vj_bmce/footsteps/concrete_grit_step6.mp3",
		"vj_bmce/footsteps/concrete_grit_step7.mp3",
		"vj_bmce/footsteps/concrete_grit_step8.mp3"
	},
	[MAT_DIRT] = {
		"vj_bmce/footsteps/gravel_step1.mp3",
		"vj_bmce/footsteps/gravel_step2.mp3",
		"vj_bmce/footsteps/gravel_step3.mp3",
		"vj_bmce/footsteps/gravel_step4.mp3",
		"vj_bmce/footsteps/gravel_step5.mp3",
		"vj_bmce/footsteps/gravel_step6.mp3",
		"vj_bmce/footsteps/gravel_step7.mp3",
		"vj_bmce/footsteps/gravel_step8.mp3"
	},
	[MAT_FLESH] = {
		"vj_bmce/footsteps/flesh_step1.mp3",
		"vj_bmce/footsteps/flesh_step2.mp3",
		"vj_bmce/footsteps/flesh_step3.mp3",
		"vj_bmce/footsteps/flesh_step4.mp3",
		"vj_bmce/footsteps/flesh_step5.mp3",
		"vj_bmce/footsteps/flesh_step6.mp3",
		"vj_bmce/footsteps/flesh_step7.mp3",
		"vj_bmce/footsteps/flesh_step8.mp3",
		"vj_bmce/footsteps/flesh_step9.mp3",
		"vj_bmce/footsteps/flesh_step10.mp3"
	},
	[MAT_GRATE] = {
		"vj_bmce/footsteps/metalgrate_step1.mp3",
		"vj_bmce/footsteps/metalgrate_step2.mp3",
		"vj_bmce/footsteps/metalgrate_step3.mp3",
		"vj_bmce/footsteps/metalgrate_step4.mp3",
		"vj_bmce/footsteps/metalgrate_step5.mp3",
		"vj_bmce/footsteps/metalgrate_step6.mp3",
		"vj_bmce/footsteps/metalgrate_step7.mp3",
		"vj_bmce/footsteps/metalgrate_step8.mp3"
	},
	[MAT_ALIENFLESH] = {
		"physics/flesh/flesh_impact_hard1.mp3",
		"physics/flesh/flesh_impact_hard2.mp3",
		"physics/flesh/flesh_impact_hard3.mp3",
		"physics/flesh/flesh_impact_hard4.mp3",
		"physics/flesh/flesh_impact_hard5.mp3",
		"physics/flesh/flesh_impact_hard6.mp3"
	},
	[74] = { -- Snow
		"vj_bmce/footsteps/sand_step1.mp3",
		"vj_bmce/footsteps/sand_step2.mp3",
		"vj_bmce/footsteps/sand_step3.mp3",
		"vj_bmce/footsteps/sand_step4.mp3",
		"vj_bmce/footsteps/sand_step5.mp3",
		"vj_bmce/footsteps/sand_step6.mp3",
		"vj_bmce/footsteps/sand_step7.mp3",
		"vj_bmce/footsteps/sand_step8.mp3"
	},
	[MAT_PLASTIC] = {
		"vj_bmce/footsteps/plaster_step1.mp3",
		"vj_bmce/footsteps/plaster_step2.mp3",
		"vj_bmce/footsteps/plaster_step3.mp3",
		"vj_bmce/footsteps/plaster_step4.mp3",
		"vj_bmce/footsteps/plaster_step5.mp3",
		"vj_bmce/footsteps/plaster_step6.mp3",
		"vj_bmce/footsteps/plaster_step7.mp3",
		"vj_bmce/footsteps/plaster_step8.mp3"
	},
	[MAT_METAL] = {
		"vj_bmce/footsteps/metalsolid_step1.mp3",
		"vj_bmce/footsteps/metalsolid_step2.mp3",
		"vj_bmce/footsteps/metalsolid_step3.mp3",
		"vj_bmce/footsteps/metalsolid_step4.mp3",
		"vj_bmce/footsteps/metalsolid_step5.mp3",
		"vj_bmce/footsteps/metalsolid_step6.mp3",
		"vj_bmce/footsteps/metalsolid_step7.mp3",
		"vj_bmce/footsteps/metalsolid_step8.mp3"
	},
	[MAT_SAND] = {
		"vj_bmce/footsteps/sand_step1.mp3",
		"vj_bmce/footsteps/sand_step2.mp3",
		"vj_bmce/footsteps/sand_step3.mp3",
		"vj_bmce/footsteps/sand_step4.mp3",
		"vj_bmce/footsteps/sand_step5.mp3",
		"vj_bmce/footsteps/sand_step6.mp3",
		"vj_bmce/footsteps/sand_step7.mp3",
		"vj_bmce/footsteps/sand_step8.mp3"
	},
	[MAT_FOLIAGE] = {
		"vj_bmce/footsteps/gravel_step1.mp3",
		"vj_bmce/footsteps/gravel_step2.mp3",
		"vj_bmce/footsteps/gravel_step3.mp3",
		"vj_bmce/footsteps/gravel_step4.mp3",
		"vj_bmce/footsteps/gravel_step5.mp3",
		"vj_bmce/footsteps/gravel_step6.mp3",
		"vj_bmce/footsteps/gravel_step7.mp3",
		"vj_bmce/footsteps/gravel_step8.mp3"
	},
	[MAT_COMPUTER] = {
		"vj_bmce/footsteps/plaster_step1.mp3",
		"vj_bmce/footsteps/plaster_step2.mp3",
		"vj_bmce/footsteps/plaster_step3.mp3",
		"vj_bmce/footsteps/plaster_step4.mp3",
		"vj_bmce/footsteps/plaster_step5.mp3",
		"vj_bmce/footsteps/plaster_step6.mp3",
		"vj_bmce/footsteps/plaster_step7.mp3",
		"vj_bmce/footsteps/plaster_step8.mp3"
	},
	[MAT_SLOSH] = {
		"vj_bmce/footsteps/water_foot_step1.mp3",
		"vj_bmce/footsteps/water_foot_step2.mp3",
		"vj_bmce/footsteps/water_foot_step3.mp3",
		"vj_bmce/footsteps/water_foot_step4.mp3",
		"vj_bmce/footsteps/water_foot_step5.mp3"
	},
	[MAT_TILE] = {
		"vj_bmce/footsteps/plaster_step1.mp3",
		"vj_bmce/footsteps/plaster_step2.mp3",
		"vj_bmce/footsteps/plaster_step3.mp3",
		"vj_bmce/footsteps/plaster_step4.mp3",
		"vj_bmce/footsteps/plaster_step5.mp3",
		"vj_bmce/footsteps/plaster_step6.mp3",
		"vj_bmce/footsteps/plaster_step7.mp3",
		"vj_bmce/footsteps/plaster_step8.mp3"
	},
	[85] = { -- Grass
		"vj_bmce/footsteps/earth_step1.mp3",
		"vj_bmce/footsteps/earth_step2.mp3",
		"vj_bmce/footsteps/earth_step3.mp3",
		"vj_bmce/footsteps/earth_step4.mp3",
		"vj_bmce/footsteps/earth_step5.mp3",
		"vj_bmce/footsteps/earth_step6.mp3",
		"vj_bmce/footsteps/earth_step7.mp3",
		"vj_bmce/footsteps/earth_step8.mp3"
	},
	[MAT_VENT] = {
		"vj_bmce/footsteps/metalsolid_step1.mp3",
		"vj_bmce/footsteps/metalsolid_step2.mp3",
		"vj_bmce/footsteps/metalsolid_step3.mp3",
		"vj_bmce/footsteps/metalsolid_step4.mp3",
		"vj_bmce/footsteps/metalsolid_step5.mp3",
		"vj_bmce/footsteps/metalsolid_step6.mp3",
		"vj_bmce/footsteps/metalsolid_step7.mp3",
		"vj_bmce/footsteps/metalsolid_step8.mp3"
	},
	[MAT_WOOD] = {
		"vj_bmce/footsteps/wood_step1.mp3",
		"vj_bmce/footsteps/wood_step2.mp3",
		"vj_bmce/footsteps/wood_step3.mp3",
		"vj_bmce/footsteps/wood_step4.mp3",
		"vj_bmce/footsteps/wood_step5.mp3",
		"vj_bmce/footsteps/wood_step6.mp3",
		"vj_bmce/footsteps/wood_step7.mp3",
		"vj_bmce/footsteps/wood_step8.mp3"
	},
	[MAT_GLASS] = {
		"vj_bmce/footsteps/glasssolid_step1.mp3",
		"vj_bmce/footsteps/glasssolid_step2.mp3",
		"vj_bmce/footsteps/glasssolid_step3.mp3",
		"vj_bmce/footsteps/glasssolid_step4.mp3",
		"vj_bmce/footsteps/glasssolid_step5.mp3",
		"vj_bmce/footsteps/glasssolid_step6.mp3",
		"vj_bmce/footsteps/glasssolid_step7.mp3",
		"vj_bmce/footsteps/glasssolid_step8.mp3"
	}
}

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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetNPCBodyGroups()
	if self:GetClass() == "npc_vj_bmce_und_run_sci_male" then
		self:SetSkin(math.random(0,10))
		self:SetBodygroup(1,math.random(0,1)) -- Body
		self:SetBodygroup(2,math.random(0,7)) -- Ties
		if math.random(1,3) == 1 then // (less chance for hat)
			self:SetBodygroup(3,math.random(0,2)) -- Hats 
		end
	end

	if self:GetClass() == "npc_vj_bmce_und_run_sci_cas_male" then
		self:SetSkin(math.random(0,10))
		self:SetBodygroup(1,math.random(0,1)) -- Arms

		if math.random(1,3) == 1 then // (less chance for hat)
			self:SetBodygroup(2,math.random(0,3)) -- Hats 
		end
		
		self:SetBodygroup(3,math.random(0,8)) -- Torso
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Zombie_Difficulty()
	if GetConVar("VJ_LNR_Difficulty"):GetInt() == 1 then // Easy
	   self.StartHealth = 150
	   self.MeleeAttackDamage = math.Rand(5,10) 
	if self.LNR_CanUseWeapon then self.MeleeAttackDamage = math.Rand(10,15) end		
end
	if GetConVar("VJ_LNR_Difficulty"):GetInt() == 2 then // Normal
	   self.StartHealth = 225		
	   self.MeleeAttackDamage = math.Rand(10,15)
	if self.LNR_CanUseWeapon then self.MeleeAttackDamage = math.Rand(15,20) end
end		
	if GetConVar("VJ_LNR_Difficulty"):GetInt() == 3 then // Hard
	   self.StartHealth = 250	
	   self.MeleeAttackDamage = math.Rand(15,20)
	if self.LNR_CanUseWeapon then self.MeleeAttackDamage = math.Rand(20,25) end
end
	if GetConVar("VJ_LNR_Difficulty"):GetInt() == 4 then // Nightmare
	   self.StartHealth = 300
	   self.MeleeAttackDamage = math.Rand(20,25)
	if self.LNR_CanUseWeapon then self.MeleeAttackDamage = math.Rand(25,30) end
end
	if GetConVar("VJ_LNR_Difficulty"):GetInt() == 5 then // Apocalypse
	   self.StartHealth = 400
	   self.MeleeAttackDamage = math.Rand(25,30) 
	if self.LNR_CanUseWeapon then self.MeleeAttackDamage = math.Rand(30,35) end		
end	
	   self:SetHealth(self.StartHealth)	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetCrawler()
	self.AnimTbl_IdleStand = {ACT_IDLE_AGITATED}
	self.AnimTbl_Walk = {ACT_WALK_AGITATED}
	self.AnimTbl_Run = {ACT_WALK_AGITATED}
	self.NextSoundTime_Suppressing = VJ_Set(7, 9)
	self.SuppressingSoundChance = 1
	self.LNR_Crawler = true
	self.SoundTbl_Alert = 
	{
		"vj_bmce_zmb/vocals/classic/crawl/crawl1.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl2.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl3.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl4.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl5.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl6.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl7.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl8.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl9.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl10.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl11.wav"
	}
	self.SoundTbl_BeforeMeleeAttack = 
	{
		//"vj_bmce_zmb/vocals/classic/attack/attack1.wav",
		"vj_bmce_zmb/vocals/classic/attack/attack2.wav",
		"vj_bmce_zmb/vocals/classic/attack/attack4.wav",
		"vj_bmce_zmb/vocals/classic/attack/attack7.wav",
		"vj_bmce_zmb/vocals/classic/attack/attack13.wav",
		"vj_bmce_zmb/vocals/classic/attack/attack14.wav",
		"vj_bmce_zmb/vocals/classic/attack/attack15.wav",
		"vj_bmce_zmb/vocals/classic/attack/attack16.wav",
		"vj_bmce_zmb/vocals/classic/attack/attack20.wav",
		"vj_bmce_zmb/vocals/classic/attack/attack21.wav",
		"vj_bmce_zmb/vocals/classic/attack/attack22.wav"
	}
	self.SoundTbl_Idle = 
	{
		"vj_bmce_zmb/vocals/classic/crawl/crawl1.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl2.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl3.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl4.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl5.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl6.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl7.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl8.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl9.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl10.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl11.wav"
	}
	self.SoundTbl_CombatIdle = 
	{
		"vj_bmce_zmb/vocals/classic/crawl/crawl1.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl2.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl3.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl4.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl5.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl6.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl7.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl8.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl9.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl10.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl11.wav"
	}
	self.SoundTbl_Suppressing = 
	{
		"vj_bmce_zmb/vocals/classic/crawl/crawl1.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl2.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl3.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl4.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl5.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl6.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl7.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl8.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl9.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl10.wav",
		"vj_bmce_zmb/vocals/classic/crawl/crawl11.wav"
	}
    self:SetCollisionBounds(Vector(13,13,25),Vector(-13,-13,0))	
    self.VJC_Data = {
	CameraMode = 1, 
	ThirdP_Offset = Vector(30, 25, -10), 
	FirstP_Bone = "ValveBiped.Bip01_Head1", 
	FirstP_Offset = Vector(5, 0, -1), 
}
    self:CapabilitiesRemove(bit.bor(CAP_MOVE_JUMP))
	self:CapabilitiesRemove(bit.bor(CAP_MOVE_CLIMB))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply)
    net.Start("vj_lnr_walker_hud")
		net.WriteBool(false)
		net.WriteEntity(self)
    net.Send(ply)

	function self.VJ_TheControllerEntity:CustomOnStopControlling()
		net.Start("vj_lnr_walker_hud")
			net.WriteBool(true)
			net.WriteEntity(self)
		net.Send(ply)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize() -- Picks random voices once a SNPC is spawned.
	local zmb_voices = math.random(3,4)
	local faceflex_rnd = math.random(1,5)
	
	if faceflex_rnd == 1 then //  Default Open Face
		self:SetFlexWeight(43,0.5) -- Lower Lip
		self:SetFlexWeight(44,1.25) -- Brow H
		self:SetFlexWeight(35,0.62) -- Bite
	
	elseif faceflex_rnd == 2 then //  Less exaggerated default face
		self:SetFlexWeight(43,0.2) -- Lower Lip
		self:SetFlexWeight(44,1.25) -- Brow H
		self:SetFlexWeight(35,1.6) -- Bite
	
	elseif faceflex_rnd == 3 then //  Really exaggerated Open mouth 
		self:SetFlexWeight(9,-3.5) -- Blink
		self:SetFlexWeight(25,1.0) -- left corner depressor
		self:SetFlexWeight(35,0.62) -- Bite
		self:SetFlexWeight(44,1.0) -- Brow H
		self:SetFlexWeight(43,3.0) -- Lower Lip
	
	elseif faceflex_rnd == 4 then //  No mouth open
		self:SetFlexWeight(44,1.0) -- Brow H
	
	elseif faceflex_rnd == 5 then //  No mouth open (more angry)
		self:SetFlexWeight(44,1.6) -- Brow H
	end

	if zmb_voices == 1 then --  Classic Call Of Duty Zombie sounds
		self.SoundTbl_Alert = 
		{
			"vj_bmce_zmb/vocals/classic/attack/attack1.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack2.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack6.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack7.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack14.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack20.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack22.wav",
			"vj_bmce_zmb/vocals/classic/behind/behind1.wav",
			"vj_bmce_zmb/vocals/classic/behind/behind2.wav",
			"vj_bmce_zmb/vocals/classic/behind/behind3.wav",
			"vj_bmce_zmb/vocals/classic/behind/behind4.wav",
			"vj_bmce_zmb/vocals/classic/behind/behind5.wav",
			"vj_bmce_zmb/vocals/classic/crawl/crawl1.wav",
			"vj_bmce_zmb/vocals/classic/crawl/crawl2.wav",
			"vj_bmce_zmb/vocals/classic/crawl/crawl3.wav",
			"vj_bmce_zmb/vocals/classic/crawl/crawl4.wav",
			"vj_bmce_zmb/vocals/classic/crawl/crawl5.wav",
			"vj_bmce_zmb/vocals/classic/taunt/taunt1.wav",
			"vj_bmce_zmb/vocals/classic/taunt/taunt2.wav",
			"vj_bmce_zmb/vocals/classic/taunt/taunt3.wav",
			"vj_bmce_zmb/vocals/classic/taunt/taunt4.wav",
			"vj_bmce_zmb/vocals/classic/taunt/taunt5.wav",
			"vj_bmce_zmb/vocals/classic/taunt/taunt6.wav",
			"vj_bmce_zmb/vocals/classic/taunt/taunt7.wav",
			"vj_bmce_zmb/vocals/classic/taunt/taunt1.wav",
			"vj_bmce_zmb/vocals/classic/taunt/taunt2.wav",
			"vj_bmce_zmb/vocals/classic/taunt/taunt3.wav",
			"vj_bmce_zmb/vocals/classic/taunt/taunt4.wav",
			"vj_bmce_zmb/vocals/classic/taunt/taunt5.wav",
			"vj_bmce_zmb/vocals/classic/taunt/taunt6.wav",
			"vj_bmce_zmb/vocals/classic/taunt/taunt7.wav"
		}
		self.SoundTbl_Idle = 
		{
			"vj_bmce_zmb/vocals/classic/amb/ambient1.wav",
			"vj_bmce_zmb/vocals/classic/amb/ambient2.wav",
			"vj_bmce_zmb/vocals/classic/amb/ambient3.wav",
			"vj_bmce_zmb/vocals/classic/amb/ambient4.wav",
			"vj_bmce_zmb/vocals/classic/amb/ambient5.wav",
			"vj_bmce_zmb/vocals/classic/amb/ambient6.wav",
			"vj_bmce_zmb/vocals/classic/amb/ambient7.wav",
			"vj_bmce_zmb/vocals/classic/amb/ambient8.wav",
			"vj_bmce_zmb/vocals/classic/amb/ambient9.wav",
			"vj_bmce_zmb/vocals/classic/amb/ambient10.wav",
			"vj_bmce_zmb/vocals/classic/amb/ambient11.wav",
			"vj_bmce_zmb/vocals/classic/amb/ambient12.wav",
			"vj_bmce_zmb/vocals/classic/amb/ambient13.wav",
			"vj_bmce_zmb/vocals/classic/amb/ambient14.wav",
			"vj_bmce_zmb/vocals/classic/amb/ambient15.wav",
			"vj_bmce_zmb/vocals/classic/amb/ambient16.wav",
			"vj_bmce_zmb/vocals/classic/amb/ambient17.wav",
			"vj_bmce_zmb/vocals/classic/amb/ambient18.wav",
			"vj_bmce_zmb/vocals/classic/amb/ambient19.wav",
			"vj_bmce_zmb/vocals/classic/amb/ambient20.wav",
			"vj_bmce_zmb/vocals/classic/amb/ambient21.wav"
		}
		self.SoundTbl_CombatIdle = 
		{
			"vj_bmce_zmb/vocals/classic/sprint/sprint1.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint2.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint3.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint4.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint5.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint6.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint7.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint8.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint9.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint10.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint11.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint12.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint13.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint14.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint15.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint16.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint17.wav"
		}
		self.SoundTbl_Suppressing = 
		{
			"vj_bmce_zmb/vocals/classic/sprint/sprint1.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint2.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint3.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint4.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint5.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint6.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint7.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint8.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint9.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint10.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint11.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint12.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint13.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint14.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint15.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint16.wav",
			"vj_bmce_zmb/vocals/classic/sprint/sprint17.wav"
		}
		self.SoundTbl_BeforeMeleeAttack = 
		{
			"vj_bmce_zmb/vocals/classic/attack/attack1.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack2.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack3.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack4.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack5.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack6.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack7.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack8.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack9.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack10.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack11.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack12.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack13.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack14.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack15.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack16.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack17.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack18.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack19.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack20.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack21.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack22.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack23.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack24.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack25.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack26.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack27.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack28.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack29.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack30.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack31.wav",
			"vj_bmce_zmb/vocals/classic/attack/attack32.wav"
		}
		self.SoundTbl_Death =
		{
			"vj_bmce_zmb/vocals/classic/death/death1.wav",
			"vj_bmce_zmb/vocals/classic/death/death2.wav",
			"vj_bmce_zmb/vocals/classic/death/death3.wav",
			"vj_bmce_zmb/vocals/classic/death/death4.wav",
			"vj_bmce_zmb/vocals/classic/death/death5.wav",
			"vj_bmce_zmb/vocals/classic/death/death6.wav",
			"vj_bmce_zmb/vocals/classic/death/death7.wav",
			"vj_bmce_zmb/vocals/classic/death/death8.wav",
			"vj_bmce_zmb/vocals/classic/death/death9.wav",
			"vj_bmce_zmb/vocals/classic/death/death10.wav",
			"vj_bmce_zmb/vocals/classic/death/death1.wav",
			"vj_bmce_zmb/vocals/classic/death/death2.wav",
			"vj_bmce_zmb/vocals/classic/death/death3.wav",
			"vj_bmce_zmb/vocals/classic/death/death4.wav",
			"vj_bmce_zmb/vocals/classic/death/death5.wav",
			"vj_bmce_zmb/vocals/classic/death/death6.wav",
			"vj_bmce_zmb/vocals/classic/death/death7.wav",
			"vj_bmce_zmb/vocals/classic/death/death8.wav",
			"vj_bmce_zmb/vocals/classic/death/death9.wav",
			"vj_bmce_zmb/vocals/classic/death/death10.wav",
			"vj_bmce_zmb/vocals/classic/elec/elec1.wav",
			"vj_bmce_zmb/vocals/classic/elec/elec2.wav",
			"vj_bmce_zmb/vocals/classic/elec/elec3.wav",
			"vj_bmce_zmb/vocals/classic/elec/elec4.wav",
			"vj_bmce_zmb/vocals/classic/elec/elec5.wav",
			"vj_bmce_zmb/vocals/classic/elec/elec6.wav"
		}
		self.SoundTbl_MeleeAttack =
		{
			"vj_bmce_zmb/vocals/classic/attack1.wav",
			"vj_bmce_zmb/vocals/classic/attack2.wav",
			"vj_bmce_zmb/vocals/classic/attack3.wav"
		}
		self.SoundTbl_MeleeAttackMiss =
		{
			"vj_bmce_zmb/vocals/classic/attack1.wav",
			"vj_bmce_zmb/vocals/classic/attack2.wav",
			"vj_bmce_zmb/vocals/classic/attack3.wav"
		}
	elseif zmb_voices == 2 then --  Modern Call Of Duty Zombie sounds
		self.SoundTbl_Alert = 
		{
			"vj_bmce_zmb/vocals/modern/taunt/zm_mod.all_62.mp3",
			"vj_bmce_zmb/vocals/modern/taunt/zm_mod.all_63.mp3",
			"vj_bmce_zmb/vocals/modern/taunt/zm_mod.all_64.mp3",
			"vj_bmce_zmb/vocals/modern/taunt/zm_mod.all_65.mp3",
			"vj_bmce_zmb/vocals/modern/taunt/zm_mod.all_66.mp3",
			"vj_bmce_zmb/vocals/modern/taunt/zm_mod.all_67.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_89.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_93.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_97.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_1.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_2.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_3.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_4.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_5.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_6.mp3"
		}
		self.SoundTbl_Idle = 
		{
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_26.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_27.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_28.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_29.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_30.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_31.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_32.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_33.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_34.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_35.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_36.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_37.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_38.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_39.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_40.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_41.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_42.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_43.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_44.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_45.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_46.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_47.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_48.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_49.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_50.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_51.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_52.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_53.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_54.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_55.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_56.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_57.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_58.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_59.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_60.mp3",
			"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_61.mp3"
		}
		self.SoundTbl_CombatIdle = 
		{
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_84.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_85.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_86.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_87.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_88.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_89.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_90.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_91.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_92.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_93.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_94.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_95.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_96.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_97.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_98.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_99.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_100.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_101.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_102.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_103.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_104.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_105.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_106.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_107.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_108.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_109.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_110.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_111.mp3"
		}
		self.SoundTbl_Suppressing = 
		{
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_84.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_85.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_86.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_87.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_88.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_89.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_90.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_91.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_92.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_93.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_94.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_95.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_96.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_97.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_98.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_99.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_100.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_101.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_102.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_103.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_104.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_105.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_106.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_107.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_108.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_109.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_110.mp3",
			"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_111.mp3"
		}
		self.SoundTbl_BeforeMeleeAttack = 
		{
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_1.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_2.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_3.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_4.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_5.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_6.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_7.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_8.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_9.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_10.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_11.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_12.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_13.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_14.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_15.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_16.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_17.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_18.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_19.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_20.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_21.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_22.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_23.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_24.mp3",
			"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_25.mp3"
		}
		self.SoundTbl_Death =
		{
			"vj_bmce_zmb/vocals/modern/death/zm_mod.all_68.mp3",
			"vj_bmce_zmb/vocals/modern/death/zm_mod.all_69.mp3",
			"vj_bmce_zmb/vocals/modern/death/zm_mod.all_70.mp3",
			"vj_bmce_zmb/vocals/modern/death/zm_mod.all_71.mp3",
			"vj_bmce_zmb/vocals/modern/death/zm_mod.all_72.mp3",
			"vj_bmce_zmb/vocals/modern/death/zm_mod.all_73.mp3",
			"vj_bmce_zmb/vocals/modern/death/zm_mod.all_74.mp3",
			"vj_bmce_zmb/vocals/modern/death/zm_mod.all_75.mp3",
			"vj_bmce_zmb/vocals/modern/death/zm_mod.all_76.mp3",
			"vj_bmce_zmb/vocals/modern/death/zm_mod.all_77.mp3",
			"vj_bmce_zmb/vocals/modern/death/zm_mod.all_78.mp3",
			"vj_bmce_zmb/vocals/modern/death/zm_mod.all_79.mp3",
			"vj_bmce_zmb/vocals/modern/death/zm_mod.all_80.mp3",
			"vj_bmce_zmb/vocals/modern/death/zm_mod.all_81.mp3",
			"vj_bmce_zmb/vocals/modern/death/zm_mod.all_82.mp3",
			"vj_bmce_zmb/vocals/modern/death/zm_mod.all_83.mp3"
		}
		self.SoundTbl_MeleeAttack =
		{
			"vj_bmce_zmb/vocals/zm_mod.all_112.wav",
			"vj_bmce_zmb/vocals/zm_mod.all_113.wav",
			"vj_bmce_zmb/vocals/zm_mod.all_114.wav",
			"vj_bmce_zmb/vocals/zm_mod.all_115.wav",
			"vj_bmce_zmb/vocals/zm_mod.all_116.wav",
			"vj_bmce_zmb/vocals/zm_mod.all_117.wav"
		}
		self.SoundTbl_MeleeAttackMiss =
		{
			"vj_bmce_zmb/vocals/classic/attack1.wav",
			"vj_bmce_zmb/vocals/classic/attack2.wav",
			"vj_bmce_zmb/vocals/classic/attack3.wav"
		}
	elseif zmb_voices == 3 then -- RDR Undead (DLC6) Zombie Male 01
		self.SoundTbl_Alert = 
		{
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_01.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_02.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_03.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_04.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_05.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_06.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_07.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_08.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_09.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_10.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_11.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_12.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_13.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_14.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_15.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_16.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_17.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_18.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_19.wav"
		}
		self.SoundTbl_Idle = 
		{
			"vj_bmce_zmb/vocals/dlc6/zombie_male/roar_01.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/roar_02.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/roar_03.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/roar_04.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/roar_05.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/roar_06.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/roar_07.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/roar_08.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/roar_09.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_01.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_02.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_03.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_04.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_05.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_06.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_07.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_08.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_09.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_10.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_11.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_12.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_13.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_14.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_15.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_16.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_17.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_18.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_19.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_20.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_21.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_22.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_23.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_24.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_25.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_26.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_27.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_28.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_29.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_30.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_31.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_32.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_33.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_34.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_35.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_36.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_37.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_38.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_39.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_40.wav"
		}
		self.SoundTbl_CombatIdle = 
		{
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_01.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_02.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_03.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_04.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_05.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_06.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_07.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_08.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_09.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_10.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_11.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_12.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_13.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_14.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_15.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_16.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_17.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_18.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_19.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_20.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_21.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_22.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_23.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_24.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_25.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_26.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_27.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_28.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_29.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_30.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_31.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_32.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_33.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_34.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_35.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_36.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_37.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_38.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_39.wav"
		}
		self.SoundTbl_Suppressing = 
		{
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_01.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_02.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_03.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_04.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_05.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_06.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_07.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_08.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_09.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_10.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_11.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_12.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_13.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_14.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_15.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_16.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_17.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_18.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_19.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_20.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_21.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_22.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_23.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_24.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_25.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_26.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_27.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_28.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_29.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_30.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_31.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_32.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_33.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_34.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_35.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_36.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_37.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_38.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_39.wav"
		}
		self.SoundTbl_BeforeMeleeAttack = 
		{
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_01.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_02.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_03.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_04.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_05.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_06.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_07.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_08.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_09.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_10.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_11.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_12.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_13.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_14.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_15.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_16.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_17.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_18.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_19.wav"
		}
		self.SoundTbl_Death =
		{
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_01.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_02.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_03.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_04.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_05.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_06.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_07.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_08.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_09.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_10.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_11.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_12.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_far_01.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_far_02.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_far_03.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_far_04.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_far_05.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_far_06.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_far_07.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_far_08.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_far_09.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_far_10.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_far_11.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_far_12.wav"
		}
		self.SoundTbl_MeleeAttack =
		{
			"vj_bmce_zmb/vocals/classic/attack1.wav",
			"vj_bmce_zmb/vocals/classic/attack2.wav",
			"vj_bmce_zmb/vocals/classic/attack3.wav"
		}
		self.SoundTbl_MeleeAttackMiss =
		{
			"vj_bmce_zmb/vocals/classic/attack1.wav",
			"vj_bmce_zmb/vocals/classic/attack2.wav",
			"vj_bmce_zmb/vocals/classic/attack3.wav"
		}
	elseif zmb_voices == 4 then -- RDR Undead (DLC6) Zombie Male 02
		self.SoundTbl_Alert = 
		{
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_01.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_02.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_03.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_04.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_05.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_06.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_07.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_08.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_09.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_10.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_11.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_12.wav"
		}
		self.SoundTbl_Idle = 
		{
			"vj_bmce_zmb/vocals/dlc6/zombie_male/roar_01.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/roar_02.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/roar_03.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/roar_04.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/roar_05.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/roar_06.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/roar_07.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/roar_08.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/roar_09.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_01.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_02.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_03.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_04.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_05.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_06.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_07.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_08.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_09.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_10.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_11.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_12.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_13.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_14.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_15.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_16.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_17.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_18.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_19.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_20.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_21.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_22.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_23.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_24.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_25.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_26.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_27.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_28.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_29.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_30.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_31.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_32.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_33.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_34.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_35.wav"
		}
		self.SoundTbl_CombatIdle = 
		{
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_01.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_02.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_03.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_04.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_05.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_06.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_07.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_08.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_09.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_10.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_11.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_12.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_13.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_14.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_15.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_16.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_17.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_18.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_19.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_20.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_21.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_22.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_23.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_24.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_25.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_26.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_27.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_28.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_29.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_30.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_31.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_32.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_33.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_34.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_35.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_36.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_37.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_38.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_39.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_40.wav"
		}
		self.SoundTbl_Suppressing = 
		{
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_01.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_02.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_03.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_04.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_05.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_06.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_07.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_08.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_09.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_10.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_11.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_12.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_13.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_14.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_15.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_16.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_17.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_18.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_19.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_20.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_21.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_22.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_23.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_24.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_25.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_26.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_27.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_28.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_29.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_30.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_31.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_32.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_33.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_34.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_35.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_36.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_37.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_38.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_39.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_40.wav"
		}
		self.SoundTbl_BeforeMeleeAttack = 
		{
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_01.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_02.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_03.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_04.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_05.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_06.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_07.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_08.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_09.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_10.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_11.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_12.wav"
		}
		self.SoundTbl_Death =
		{
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_01.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_02.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_03.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_04.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_05.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_06.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_07.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_08.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_09.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_10.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_11.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_12.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_far_01.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_far_02.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_far_03.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_far_04.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_far_05.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_far_06.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_far_07.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_far_08.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_far_09.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_far_10.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_far_11.wav",
			"vj_bmce_zmb/vocals/dlc6/zombie_male/death_far_12.wav"
		}
		self.SoundTbl_MeleeAttack =
		{
			"vj_bmce_zmb/vocals/classic/attack1.wav",
			"vj_bmce_zmb/vocals/classic/attack2.wav",
			"vj_bmce_zmb/vocals/classic/attack3.wav"
		}
		self.SoundTbl_MeleeAttackMiss =
		{
			"vj_bmce_zmb/vocals/classic/attack1.wav",
			"vj_bmce_zmb/vocals/classic/attack2.wav",
			"vj_bmce_zmb/vocals/classic/attack3.wav"
		}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZombieWeapons()
    if GetConVar("VJ_LNR_MeleeWeapons"):GetInt() == 0 or self.LNR_Crawler then self.LNR_CanUseWeapon = false return end
    if self.LNR_CanUseWeapon then
		local Weapon = math.random(1,1)
		self.WeaponModel = ents.Create("prop_physics")	
		if Weapon == 1 then
			self.WeaponModel:SetModel("models/weapons/bmce_weapons/bmce_m9/w_glock.mdl")
		end
		self.WeaponModel:SetLocalPos(self:GetPos())
		self.WeaponModel:SetLocalAngles(self:GetAngles())			
		self.WeaponModel:SetOwner(self)
		self.WeaponModel:SetParent(self)
		self.WeaponModel:Fire("SetParentAttachmentMaintainOffset","anim_attachment_LH")
		self.WeaponModel:Fire("SetParentAttachment","anim_attachment_RH")
		self.WeaponModel:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		self.WeaponModel:Spawn()
		self.WeaponModel:Activate()
		self.WeaponModel:SetSolid(SOLID_NONE)
		self.WeaponModel:AddEffects(EF_BONEMERGE)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo,hitgroup)		
	if self:GetActivity() == ACT_GLIDE or self.LNR_Crawler or self.LNR_Crippled or self.Flinching or self:GetSequence() == self:LookupSequence("nz_spawn_climbout_fast") or self:GetSequence() == self:LookupSequence("nz_spawn_jump") or self:GetSequence() == self:LookupSequence("shove_forward_01") or self:GetSequence() == self:LookupSequence("infectionrise") or self:GetSequence() == self:LookupSequence("infectionrise2") or self:GetSequence() == self:LookupSequence("slumprise_a") or self:GetSequence() == self:LookupSequence("slumprise_a2") then self.HasDeathAnimation = false end
	if IsValid(self.WeaponModel) && self.LNR_CanUseWeapon then
	   self:CreateGibEntity("prop_physics",self.WeaponModel:GetModel(),{Pos=self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos,Ang=self:GetAngles(),Vel="UseDamageForce"})
	   self.WeaponModel:SetMaterial("lnr/bonemerge") 
	   self.WeaponModel:DrawShadow(false)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	-- Reduce head damage
	if hitgroup == HITGROUP_HEAD then // If the head is damaged, increase dmg by 100%
		if self.HasSounds == true && self.HasImpactSounds == true then VJ_EmitSound(self, "vj_bmce_zmb/vocals/headshot_"..math.random(0,6)..".wav", 70) end
		dmginfo:ScaleDamage(2)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt) 
	local faceflex_rnd = math.random(1,9)

	if faceflex_rnd == 1 then
		corpseEnt:SetFlexWeight(9,1) -- Blink
		corpseEnt:SetFlexWeight(43,1) -- Lower Lip
		corpseEnt:SetFlexWeight(79,0,0.25) -- Cigar
	elseif faceflex_rnd == 2 then
		corpseEnt:SetFlexWeight(9,0.25) -- Blink
		corpseEnt:SetFlexWeight(43,0.25) -- Lower Lip
	elseif faceflex_rnd == 3 then
		corpseEnt:SetFlexWeight(9,0.6) -- Blink
		corpseEnt:SetFlexWeight(43,0.18) -- Lower Lip
	elseif faceflex_rnd == 4 then
		corpseEnt:SetFlexWeight(9,0.75) -- Blink
		corpseEnt:SetFlexWeight(43,0.35) -- Lower Lip
		corpseEnt:SetFlexWeight(79,0.5) -- Cigar
	elseif faceflex_rnd == 5 then
		corpseEnt:SetFlexWeight(9,0.4) -- Blink
		corpseEnt:SetFlexWeight(43,0.6) -- Lower Lip
		corpseEnt:SetFlexWeight(79,0.8) -- Cigar
	elseif faceflex_rnd == 6 then
		corpseEnt:SetFlexWeight(9,0.2) -- Blink
	elseif faceflex_rnd == 7 then
		corpseEnt:SetFlexWeight(9,0.4) -- Blink
	elseif faceflex_rnd == 8 then
		corpseEnt:SetFlexWeight(9,0.6) -- Blink
	elseif faceflex_rnd == 9 then
		corpseEnt:SetFlexWeight(7,0.75) -- left lid closer
		corpseEnt:SetFlexWeight(18,0.9) -- left cheek raiser
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	if GetConVar("VJ_LNR_Crawl"):GetInt() == 0 then return end

	local crawlerchance = math.random(1,15)

	if hitgroup == HITGROUP_LEFTLEG && !self.LNR_Crawler then
		if crawlerchance == 1 then
			self:VJ_ACT_PLAYACTIVITY({"vjseq_nz_death_f_12","vjseq_nz_death_f_11"},true,false,false)
			self.LNR_Crawler = true
			self:SetCrawler()
			self:PlaySoundSystem("Alert")
			self:EmitSound("vj_bmce/weapons/strike_head_shotoff.wav", 90, math.random(85,110), 1, CHAN_AUTO)
			self:CreateGibEntity("obj_vj_gib","models/gibs/humans/sgib_01.mdl",{BloodDecal="VJ_LNR_Blood_Red",{Pos=self:LocalToWorld(Vector(0,0,-5))}})
			self:CreateGibEntity("obj_vj_gib","models/gibs/humans/sgib_01.mdl",{BloodDecal="VJ_LNR_Blood_Red",{Pos=self:LocalToWorld(Vector(0,0,-3))}})
			self:CreateGibEntity("obj_vj_gib","models/gibs/humans/sgib_01.mdl",{BloodDecal="VJ_LNR_Blood_Red",{Pos=self:LocalToWorld(Vector(0,0,-6))}})
			self:CreateGibEntity("obj_vj_gib","models/gibs/humans/sgib_02.mdl",{BloodDecal="VJ_LNR_Blood_Red",{Pos=self:LocalToWorld(Vector(0,0,-5))}})
			self:CreateGibEntity("obj_vj_gib","models/gibs/humans/sgib_02.mdl",{BloodDecal="VJ_LNR_Blood_Red",{Pos=self:LocalToWorld(Vector(0,0,-3))}})
			self:CreateGibEntity("obj_vj_gib","models/gibs/humans/sgib_02.mdl",{BloodDecal="VJ_LNR_Blood_Red",{Pos=self:LocalToWorld(Vector(0,0,-6))}})
			
			local bloodeffect = EffectData()
			bloodeffect:SetOrigin(self:LocalToWorld(Vector(0,0,25)))
			bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
			bloodeffect:SetScale(32)
			util.Effect("VJ_Blood1",bloodeffect)
				
			local bloodspray = EffectData()
			bloodspray:SetOrigin(self:LocalToWorld(Vector(0,0,25)))
			bloodspray:SetScale(5)
			bloodspray:SetFlags(3)
			bloodspray:SetColor(0)
			util.Effect("bloodspray",bloodspray)
		end
	end

	if hitgroup == HITGROUP_RIGHTLEG && !self.LNR_Crawler then
		if crawlerchance == 1 then
			self:VJ_ACT_PLAYACTIVITY({"vjseq_nz_death_f_12","vjseq_nz_death_f_11"},true,false,false)
			self.LNR_Crawler = true
			self:SetCrawler()
			self:PlaySoundSystem("Alert")
			self:EmitSound("vj_bmce/weapons/strike_head_shotoff.wav", 90, math.random(85,110), 1, CHAN_AUTO)
			self:CreateGibEntity("obj_vj_gib","models/gibs/humans/sgib_01.mdl",{BloodDecal="VJ_LNR_Blood_Red",{Pos=self:LocalToWorld(Vector(0,0,-5))}})
			self:CreateGibEntity("obj_vj_gib","models/gibs/humans/sgib_01.mdl",{BloodDecal="VJ_LNR_Blood_Red",{Pos=self:LocalToWorld(Vector(0,0,-3))}})
			self:CreateGibEntity("obj_vj_gib","models/gibs/humans/sgib_01.mdl",{BloodDecal="VJ_LNR_Blood_Red",{Pos=self:LocalToWorld(Vector(0,0,-6))}})
			self:CreateGibEntity("obj_vj_gib","models/gibs/humans/sgib_02.mdl",{BloodDecal="VJ_LNR_Blood_Red",{Pos=self:LocalToWorld(Vector(0,0,-5))}})
			self:CreateGibEntity("obj_vj_gib","models/gibs/humans/sgib_02.mdl",{BloodDecal="VJ_LNR_Blood_Red",{Pos=self:LocalToWorld(Vector(0,0,-3))}})
			self:CreateGibEntity("obj_vj_gib","models/gibs/humans/sgib_02.mdl",{BloodDecal="VJ_LNR_Blood_Red",{Pos=self:LocalToWorld(Vector(0,0,-6))}})
			
			local bloodeffect = EffectData()
			bloodeffect:SetOrigin(self:LocalToWorld(Vector(0,0,25)))
			bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
			bloodeffect:SetScale(32)
			util.Effect("VJ_Blood1",bloodeffect)
				
			local bloodspray = EffectData()
			bloodspray:SetOrigin(self:LocalToWorld(Vector(0,0,25)))
			bloodspray:SetScale(5)
			bloodspray:SetFlags(3)
			bloodspray:SetColor(0)
			util.Effect("bloodspray",bloodspray)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	if self:IsDefaultGibDamageType(dmginfo:GetDamageType()) then end

	local bloodeffect_headshot = EffectData()
	bloodeffect_headshot:SetOrigin(self:LocalToWorld(Vector(0,0,50)))
	bloodeffect_headshot:SetColor(VJ_Color2Byte(Color(130,19,10)))
	bloodeffect_headshot:SetScale(32)
	util.Effect("VJ_Blood1",bloodeffect_headshot)
		
	local bloodspray_headshot = EffectData()
	bloodspray_headshot:SetOrigin(self:LocalToWorld(Vector(0,0,50)))
	bloodspray_headshot:SetScale(5)
	bloodspray_headshot:SetFlags(3)
	bloodspray_headshot:SetColor(0)
	util.Effect("bloodspray",bloodspray_headshot)
	
	if self.LNR_Crawler then
		local bloodeffect = EffectData()
		bloodeffect:SetOrigin(self:LocalToWorld(Vector(0,0,25)))
		bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
		bloodeffect:SetScale(32)
		util.Effect("VJ_Blood1",bloodeffect)
			
		local bloodspray = EffectData()
		bloodspray:SetOrigin(self:LocalToWorld(Vector(0,0,25)))
		bloodspray:SetScale(5)
		bloodspray:SetFlags(3)
		bloodspray:SetColor(0)
		util.Effect("bloodspray",bloodspray)
	else -- IF NOT CRAWLER
		local bloodeffect = EffectData()
		bloodeffect:SetOrigin(self:LocalToWorld(Vector(0,0,50)))
		bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
		bloodeffect:SetScale(32)
		util.Effect("VJ_Blood1",bloodeffect)
		
		local bloodspray = EffectData()
		bloodspray:SetOrigin(self:LocalToWorld(Vector(0,0,50)))
		bloodspray:SetScale(5)
		bloodspray:SetFlags(3)
		bloodspray:SetColor(0)
		util.Effect("bloodspray",bloodspray)
	end

	local gibchance = math.random(1,3)

	if hitgroup == HITGROUP_HEAD && !self.LNR_Crawler then
		if gibchance == 1 then
			self:CreateGibEntity("obj_vj_gib","models/gibs/humans/sgib_01.mdl",{BloodDecal="VJ_LNR_Blood_Red",Pos=self:GetAttachment(self:LookupAttachment("head_gib")).Pos})
			self:CreateGibEntity("obj_vj_gib","models/gibs/humans/sgib_02.mdl",{BloodDecal="VJ_LNR_Blood_Red",Pos=self:GetAttachment(self:LookupAttachment("head_gib")).Pos})
			self:CreateGibEntity("obj_vj_gib","models/gibs/humans/sgib_01.mdl",{BloodDecal="VJ_LNR_Blood_Red",Pos=self:GetAttachment(self:LookupAttachment("head_gib")).Pos})
			self:CreateGibEntity("obj_vj_gib","models/gibs/humans/sgib_02.mdl",{BloodDecal="VJ_LNR_Blood_Red",Pos=self:GetAttachment(self:LookupAttachment("head_gib")).Pos})
			self:CreateGibEntity("obj_vj_gib","models/gibs/humans/sgib_02.mdl",{BloodDecal="VJ_LNR_Blood_Red",Pos=self:GetAttachment(self:LookupAttachment("head_gib")).Pos})
		end

		self:PlaySoundSystem("Death", SoundTbl_DeathGib)
		self.HasDeathAnimation = false

		self.LNR_Gibbed = true
		ParticleEffect("lnr_blood_impact_boom",self:GetAttachment(self:LookupAttachment("eyes")).Pos,self:GetAngles())
		VJ_EmitSound(self,"vj_lnrhl2/shared/zombie_neck_drain_0"..math.random(1,3)..".wav",60,100)	
		local BleedOut = ents.Create("info_particle_system")
		BleedOut:SetKeyValue("effect_name","lnr_headshot_blood_splats")
		BleedOut:SetPos(self:GetAttachment(self:LookupAttachment("forward")).Pos)
		BleedOut:SetAngles(self:GetAttachment(self:LookupAttachment("forward")).Ang)
		BleedOut:SetParent(self)
		BleedOut:Fire("SetParentAttachment","forward")
		BleedOut:Spawn()
		BleedOut:Activate()
		BleedOut:Fire("Start","",0)
		BleedOut:Fire("Kill","",8)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,corpseEnt)
    VJ_LNR_ApplyCorpseEffects(self,corpseEnt)	
    if GetConVar("VJ_LNR_Gib"):GetInt() == 1 then
		if self.LNR_Gibbed then
			VJ_EmitSound(corpseEnt,"vj_lnrhl2/shared/zombie_neck_drain_0"..math.random(1,3)..".wav",60,100)
			local BleedOut = ents.Create("info_particle_system")	
			if hitgroup == HITGROUP_HEAD then
				BleedOut:SetPos(corpseEnt:GetAttachment(corpseEnt:LookupAttachment("forward")).Pos)
				BleedOut:SetAngles(corpseEnt:GetAttachment(corpseEnt:LookupAttachment("forward")).Ang)
				BleedOut:Fire("SetParentAttachment","forward")
				BleedOut:SetKeyValue("effect_name","lnr_head_s")
				BleedOut:SetParent(corpseEnt)
				BleedOut:Spawn()
				BleedOut:Activate()
				BleedOut:Fire("Start","",0)
				BleedOut:Fire("Kill","",8)
			end	
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()

	if GetConVar("vj_bmce_zmb_deathrandom"):GetInt() == 1 then
		if CurTime() > self.Zombie_EnergyTime then
			self:PlaySoundSystem("Death", SoundTbl_DeathGib)
			self:PlaySoundSystem("Death")
			self.HasDeathSounds = false
			self.DeathAnimationTime = 0.3
			self.DeathAnimationChance = 1

			if IsValid(self) then
				self:TakeDamage(self:Health(), self, self)
			end
		end
	end
end