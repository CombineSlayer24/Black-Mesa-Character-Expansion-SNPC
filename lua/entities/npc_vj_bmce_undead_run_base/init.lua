AddCSLuaFile("shared.lua")
include('shared.lua')

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
ENT.HasBloodDecal = true
ENT.BloodDecalUseGMod = false
ENT.LNR_Gibbed = false
ENT.Zombie_Bruiser = 0
ENT.NextSoundTime_Idle = VJ_Set(4, 8)
ENT.NextSoundTime_Suppressing = VJ_Set(4, 6)
ENT.NextSoundTime_Pain = VJ_Set(2, 2.3)
util.AddNetworkString("vj_bmce_zombie_hud")
ENT.BMCE_Hat = 0
-- 0 no hat
-- 1 beret (security)
-- 2 beret (hecu)
-- 3 boonie

local random = math.random
local rand = math.Rand
local Zombie_Voice_Female = random(1,2)

function ENT:CustomOnInitialize()

	self.Zombie_EnergyTime = CurTime() + rand(GetConVar("vj_bmce_zmb_deathtime_min"):GetInt(), GetConVar("vj_bmce_zmb_deathtime_max"):GetInt())

	self:SetupZombie()
	self:Zombie_Difficulty()

	if GetConVarNumber("vj_bmce_zmb_eyeglow") == 1 then
		local color
		local c_string
		local cmd_enable = GetConVarNumber("vj_bmce_zmb_eyeglow") // sets eye color
		local eyecolor_mat = random(2,2)

 		if cmd_enable == 1 then
			if eyecolor_mat == 1 then // orange
				color = Color(240,96,0,255)
				c_string = "240 96 0 255"
			elseif eyecolor_mat == 2 then // red (190 dark red)
				color = Color(255,0,0,255)
				c_string = "255 0 0 255"
			elseif eyecolor_mat == 3 then // light blue
				color = Color(0,199,255,255)
				c_string = "0 199 255 255"
			elseif eyecolor_mat == 4 then // forest green
				color = Color(22,189,58)
				c_string = "22 189 58 255"
			elseif eyecolor_mat == 5 then // XEN purple
				color = Color(136,22,189)
				c_string = "136 22 189 255"
			elseif eyecolor_mat == 6 then // Security blue
				color = Color(0,120,255)
				c_string = "0 120 255 255"
			end
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

--[[ 	if GetConVar("VJ_LNR_MeleeWeapons"):GetInt() == 1 then
		if random( 1,5 ) == 1 && !self.LNR_Crawler then 
		   self.LNR_CanUseWeapon = true
		   self:ZombieWeapons()
	   end
	end ]]

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

	local random_supersprint = random(0,24)
	local sprint_anim = random(1,8)
	local random_riser = random(1,5)


	if GetConVarNumber("vj_bmce_zmb_faster") == 0 then 
		if (random_supersprint >= 0 and random_supersprint <= 7) then
			self.AnimTbl_Run = {ACT_RUN}
		elseif (random_supersprint >= 8 and random_supersprint <= 15) then // super sprint
			self.AnimTbl_Run = {ACT_SPRINT}
		elseif (random_supersprint >= 16 and random_supersprint <= 24) then // super sonic sprint
			self.LNR_SuperSprinter = true
			self.AnimTbl_Run = {ACT_RUN_AIM}
		end
	end	

	if GetConVarNumber("vj_bmce_zmb_faster") == 1 then 
		if (sprint_anim >= 1 and sprint_anim <= 6) then
			self.AnimTbl_Run = {ACT_SPRINT}
		elseif (sprint_anim >= 7 and sprint_anim <= 8) then -- Super Sprinter
			self.LNR_SuperSprinter = true
			self.AnimTbl_Run = {ACT_RUN_AIM}
		end
	end
	
	if GetConVarNumber("vj_bmce_zmb_riser") == 1 then
		if (random_riser >= 1 and random_riser <= 3) then
			self:SlowDirtSpawn()
		elseif (random_riser >= 4 and random_riser <= 5) then
			self:FastDirtSpawn()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FastDirtSpawn()
	if self:IsDirt(self:GetPos()) then
		self:SetNoDraw(true)
		timer.Simple(0.01,function()
			self:VJ_ACT_PLAYACTIVITY("vjseq_nz_spawn_jump",true,1.25,true,0,{SequenceDuration=1.25})
			self.HasMeleeAttack = false
			timer.Simple(0.2,function()
				if self:IsValid() then
					self:SetNoDraw(false)
					self:EmitSound("vj_bmce_zmb/vocals/spawn_dirt_0" .. random(0,1) .. ".wav")
					self:PlaySoundSystem("Alert")
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SlowDirtSpawn()
	if self:IsDirt(self:GetPos()) then
		self:SetNoDraw(true)
		timer.Simple(0.01,function()
			self:VJ_ACT_PLAYACTIVITY("vjseq_nz_spawn_climbout_fast",true,4.55,true,0,{SequenceDuration=4.55})
			self.HasMeleeAttack = false
			timer.Simple(0.2,function()
				if self:IsValid() then
					self:SetNoDraw(false)
					self:EmitSound("vj_bmce_zmb/vocals/spawn_dirt_0" .. random(0,1) .. ".wav")
					self:PlaySoundSystem("Alert")
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
		VJ_EmitSound(self,"npc/zombie/foot"..random(1,3)..".wav",self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch.a,self.FootStepPitch.b))			
	end	
	if key == "slide" then
		VJ_EmitSound(self,"vj_bmce_zmb/vocals/extras/foot_Slide_0"..random(0, 2)..".wav",self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch.a,self.FootStepPitch.b))
	end
	if key == "crawl" then
		VJ_EmitSound(self,"vj_bmce_zmb/vocals/extras/crawl_0"..random(3)..".wav",self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch.a,self.FootStepPitch.b))
	end
	if key == "crawl" && self:WaterLevel() > 0 && self:WaterLevel() < 3 then
		VJ_EmitSound(self,"player/footsteps/wade" .. random(1,8) .. ".wav",self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch.a,self.FootStepPitch.b))
	end
	if key == "climb" then
		VJ_EmitSound(self,"player/footsteps/ladder"..random(1,4)..".wav",self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch.a,self.FootStepPitch.b))
	end		
	if key == "attack" then
		self:MeleeAttackCode()		
	end		
	if key == "death" then
		VJ_EmitSound(self,"physics/body/body_medium_impact_soft"..random(1,7)..".wav",75,100)
	end
	if key == "death" && self:WaterLevel() > 0 && self:WaterLevel() < 3 then
		VJ_EmitSound(self,"ambient/water/water_splash"..random(1,3)..".wav",75,100)
	end	
	if key == "break_door" then
		if IsValid(self.LNR_DoorToBreak) then
		//VJ_CreateSound(self,self.SoundTbl_BeforeMeleeAttack,self.BeforeMeleeAttackSoundLevel,self:VJ_DecideSoundPitch(self.BeforeMeleeAttackSoundPitch.a, self.BeforeMeleeAttackSoundPitch.b))
		VJ_EmitSound(self,"vj_bmce_zmb/vocals/extras/snap_0"..random(5)..".wav",85,100)
		local doorDmg = self.MeleeAttackDamage
		local door = self.LNR_DoorToBreak
		if door.DoorHealth == nil then
			door.DoorHealth = 200 - doorDmg
		else
			door.DoorHealth = door.DoorHealth - doorDmg
		end
		if door.DoorHealth <= 0 then
			//door:EmitSound("physics/wood/wood_furniture_break"..random(1,2)..".wav",75,100)
			door:EmitSound("vj_bmce_zmb/vocals/extras/slam_0"..random(5)..".wav",90,100)
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

ENT.FootSteps = 
{
	[MAT_ANTLION] = {"vj_bmce/footsteps/flesh_step1.mp3","vj_bmce/footsteps/flesh_step2.mp3","vj_bmce/footsteps/flesh_step3.mp3","vj_bmce/footsteps/flesh_step4.mp3","vj_bmce/footsteps/flesh_step5.mp3","vj_bmce/footsteps/flesh_step6.mp3","vj_bmce/footsteps/flesh_step7.mp3","vj_bmce/footsteps/flesh_step8.mp3","vj_bmce/footsteps/flesh_step9.mp3","vj_bmce/footsteps/flesh_step10.mp3"},
	[MAT_BLOODYFLESH] = {"vj_bmce/footsteps/flesh_step1.mp3","vj_bmce/footsteps/flesh_step2.mp3","vj_bmce/footsteps/flesh_step3.mp3","vj_bmce/footsteps/flesh_step4.mp3","vj_bmce/footsteps/flesh_step5.mp3","vj_bmce/footsteps/flesh_step6.mp3","vj_bmce/footsteps/flesh_step7.mp3","vj_bmce/footsteps/flesh_step8.mp3","vj_bmce/footsteps/flesh_step9.mp3","vj_bmce/footsteps/flesh_step10.mp3"},
	[MAT_CONCRETE] = {"vj_bmce/footsteps/concrete_step1.mp3","vj_bmce/footsteps/concrete_step2.mp3","vj_bmce/footsteps/concrete_step3.mp3","vj_bmce/footsteps/concrete_step4.mp3","vj_bmce/footsteps/concrete_step5.mp3","vj_bmce/footsteps/concrete_step6.mp3","vj_bmce/footsteps/concrete_step7.mp3","vj_bmce/footsteps/concrete_step8.mp3","vj_bmce/footsteps/concrete_grit_step1.mp3","vj_bmce/footsteps/concrete_grit_step2.mp3","vj_bmce/footsteps/concrete_grit_step3.mp3","vj_bmce/footsteps/concrete_grit_step4.mp3","vj_bmce/footsteps/concrete_grit_step5.mp3","vj_bmce/footsteps/concrete_grit_step6.mp3","vj_bmce/footsteps/concrete_grit_step7.mp3","vj_bmce/footsteps/concrete_grit_step8.mp3"},
	[MAT_DIRT] = {"vj_bmce/footsteps/gravel_step1.mp3","vj_bmce/footsteps/gravel_step2.mp3","vj_bmce/footsteps/gravel_step3.mp3","vj_bmce/footsteps/gravel_step4.mp3","vj_bmce/footsteps/gravel_step5.mp3","vj_bmce/footsteps/gravel_step6.mp3","vj_bmce/footsteps/gravel_step7.mp3","vj_bmce/footsteps/gravel_step8.mp3"},
	[MAT_FLESH] = {"vj_bmce/footsteps/flesh_step1.mp3","vj_bmce/footsteps/flesh_step2.mp3","vj_bmce/footsteps/flesh_step3.mp3","vj_bmce/footsteps/flesh_step4.mp3","vj_bmce/footsteps/flesh_step5.mp3","vj_bmce/footsteps/flesh_step6.mp3","vj_bmce/footsteps/flesh_step7.mp3","vj_bmce/footsteps/flesh_step8.mp3","vj_bmce/footsteps/flesh_step9.mp3","vj_bmce/footsteps/flesh_step10.mp3"},
	[MAT_GRATE] = {"vj_bmce/footsteps/metalgrate_step1.mp3","vj_bmce/footsteps/metalgrate_step2.mp3","vj_bmce/footsteps/metalgrate_step3.mp3","vj_bmce/footsteps/metalgrate_step4.mp3","vj_bmce/footsteps/metalgrate_step5.mp3","vj_bmce/footsteps/metalgrate_step6.mp3","vj_bmce/footsteps/metalgrate_step7.mp3","vj_bmce/footsteps/metalgrate_step8.mp3"},
	[MAT_ALIENFLESH] = {"physics/flesh/flesh_impact_hard1.mp3","physics/flesh/flesh_impact_hard2.mp3","physics/flesh/flesh_impact_hard3.mp3","physics/flesh/flesh_impact_hard4.mp3","physics/flesh/flesh_impact_hard5.mp3","physics/flesh/flesh_impact_hard6.mp3"},
	-- 74 is Snow
	[74] = {"vj_bmce/footsteps/sand_step1.mp3","vj_bmce/footsteps/sand_step2.mp3","vj_bmce/footsteps/sand_step3.mp3","vj_bmce/footsteps/sand_step4.mp3","vj_bmce/footsteps/sand_step5.mp3","vj_bmce/footsteps/sand_step6.mp3","vj_bmce/footsteps/sand_step7.mp3","vj_bmce/footsteps/sand_step8.mp3"},
	[MAT_PLASTIC] = {"vj_bmce/footsteps/plaster_step1.mp3","vj_bmce/footsteps/plaster_step2.mp3","vj_bmce/footsteps/plaster_step3.mp3","vj_bmce/footsteps/plaster_step4.mp3","vj_bmce/footsteps/plaster_step5.mp3","vj_bmce/footsteps/plaster_step6.mp3","vj_bmce/footsteps/plaster_step7.mp3","vj_bmce/footsteps/plaster_step8.mp3"},
	[MAT_METAL] = {"vj_bmce/footsteps/metalsolid_step1.mp3","vj_bmce/footsteps/metalsolid_step2.mp3","vj_bmce/footsteps/metalsolid_step3.mp3","vj_bmce/footsteps/metalsolid_step4.mp3","vj_bmce/footsteps/metalsolid_step5.mp3","vj_bmce/footsteps/metalsolid_step6.mp3","vj_bmce/footsteps/metalsolid_step7.mp3","vj_bmce/footsteps/metalsolid_step8.mp3"},
	[MAT_SAND] = {"vj_bmce/footsteps/sand_step1.mp3","vj_bmce/footsteps/sand_step2.mp3","vj_bmce/footsteps/sand_step3.mp3","vj_bmce/footsteps/sand_step4.mp3","vj_bmce/footsteps/sand_step5.mp3","vj_bmce/footsteps/sand_step6.mp3","vj_bmce/footsteps/sand_step7.mp3","vj_bmce/footsteps/sand_step8.mp3"},
	[MAT_FOLIAGE] = {"vj_bmce/footsteps/gravel_step1.mp3","vj_bmce/footsteps/gravel_step2.mp3","vj_bmce/footsteps/gravel_step3.mp3","vj_bmce/footsteps/gravel_step4.mp3","vj_bmce/footsteps/gravel_step5.mp3","vj_bmce/footsteps/gravel_step6.mp3","vj_bmce/footsteps/gravel_step7.mp3","vj_bmce/footsteps/gravel_step8.mp3"},
	[MAT_COMPUTER] = {"vj_bmce/footsteps/plaster_step1.mp3","vj_bmce/footsteps/plaster_step2.mp3","vj_bmce/footsteps/plaster_step3.mp3","vj_bmce/footsteps/plaster_step4.mp3","vj_bmce/footsteps/plaster_step5.mp3","vj_bmce/footsteps/plaster_step6.mp3","vj_bmce/footsteps/plaster_step7.mp3","vj_bmce/footsteps/plaster_step8.mp3"},
	[MAT_SLOSH] = {"vj_bmce/footsteps/water_foot_step1.mp3","vj_bmce/footsteps/water_foot_step2.mp3","vj_bmce/footsteps/water_foot_step3.mp3","vj_bmce/footsteps/water_foot_step4.mp3","vj_bmce/footsteps/water_foot_step5.mp3"},
	[MAT_TILE] = {"vj_bmce/footsteps/plaster_step1.mp3","vj_bmce/footsteps/plaster_step2.mp3","vj_bmce/footsteps/plaster_step3.mp3","vj_bmce/footsteps/plaster_step4.mp3","vj_bmce/footsteps/plaster_step5.mp3","vj_bmce/footsteps/plaster_step6.mp3","vj_bmce/footsteps/plaster_step7.mp3","vj_bmce/footsteps/plaster_step8.mp3"},
	-- 85 is grass
	[85] = {"vj_bmce/footsteps/earth_step1.mp3","vj_bmce/footsteps/earth_step2.mp3","vj_bmce/footsteps/earth_step3.mp3","vj_bmce/footsteps/earth_step4.mp3","vj_bmce/footsteps/earth_step5.mp3","vj_bmce/footsteps/earth_step6.mp3","vj_bmce/footsteps/earth_step7.mp3","vj_bmce/footsteps/earth_step8.mp3"},
	[MAT_VENT] = {"vj_bmce/footsteps/metalsolid_step1.mp3","vj_bmce/footsteps/metalsolid_step2.mp3","vj_bmce/footsteps/metalsolid_step3.mp3","vj_bmce/footsteps/metalsolid_step4.mp3","vj_bmce/footsteps/metalsolid_step5.mp3","vj_bmce/footsteps/metalsolid_step6.mp3","vj_bmce/footsteps/metalsolid_step7.mp3","vj_bmce/footsteps/metalsolid_step8.mp3"},
	[MAT_WOOD] = {"vj_bmce/footsteps/wood_step1.mp3","vj_bmce/footsteps/wood_step2.mp3","vj_bmce/footsteps/wood_step3.mp3","vj_bmce/footsteps/wood_step4.mp3","vj_bmce/footsteps/wood_step5.mp3","vj_bmce/footsteps/wood_step6.mp3","vj_bmce/footsteps/wood_step7.mp3","vj_bmce/footsteps/wood_step8.mp3"},
	[MAT_GLASS] = {"vj_bmce/footsteps/glasssolid_step1.mp3","vj_bmce/footsteps/glasssolid_step2.mp3","vj_bmce/footsteps/glasssolid_step3.mp3","vj_bmce/footsteps/glasssolid_step4.mp3","vj_bmce/footsteps/glasssolid_step5.mp3","vj_bmce/footsteps/glasssolid_step6.mp3","vj_bmce/footsteps/glasssolid_step7.mp3","vj_bmce/footsteps/glasssolid_step8.mp3"}
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
function ENT:UseMaleZombieVoice()
	local Zombie_Voice_Male = random(1,5)
	
	if Zombie_Voice_Male == 1 then --  Classic Call Of Duty Zombie sounds
		self.SoundTbl_Alert = {"vj_bmce_zmb/vocals/classic/attack/attack1.wav","vj_bmce_zmb/vocals/classic/attack/attack2.wav","vj_bmce_zmb/vocals/classic/attack/attack6.wav","vj_bmce_zmb/vocals/classic/attack/attack7.wav","vj_bmce_zmb/vocals/classic/attack/attack14.wav","vj_bmce_zmb/vocals/classic/attack/attack20.wav","vj_bmce_zmb/vocals/classic/attack/attack22.wav","vj_bmce_zmb/vocals/classic/behind/behind1.wav","vj_bmce_zmb/vocals/classic/behind/behind2.wav","vj_bmce_zmb/vocals/classic/behind/behind3.wav","vj_bmce_zmb/vocals/classic/behind/behind4.wav","vj_bmce_zmb/vocals/classic/behind/behind5.wav","vj_bmce_zmb/vocals/classic/crawl/crawl1.wav","vj_bmce_zmb/vocals/classic/crawl/crawl2.wav","vj_bmce_zmb/vocals/classic/crawl/crawl3.wav","vj_bmce_zmb/vocals/classic/crawl/crawl4.wav","vj_bmce_zmb/vocals/classic/crawl/crawl5.wav","vj_bmce_zmb/vocals/classic/taunt/taunt1.wav","vj_bmce_zmb/vocals/classic/taunt/taunt2.wav","vj_bmce_zmb/vocals/classic/taunt/taunt3.wav","vj_bmce_zmb/vocals/classic/taunt/taunt4.wav","vj_bmce_zmb/vocals/classic/taunt/taunt5.wav","vj_bmce_zmb/vocals/classic/taunt/taunt6.wav","vj_bmce_zmb/vocals/classic/taunt/taunt7.wav","vj_bmce_zmb/vocals/classic/taunt/taunt1.wav","vj_bmce_zmb/vocals/classic/taunt/taunt2.wav","vj_bmce_zmb/vocals/classic/taunt/taunt3.wav","vj_bmce_zmb/vocals/classic/taunt/taunt4.wav","vj_bmce_zmb/vocals/classic/taunt/taunt5.wav","vj_bmce_zmb/vocals/classic/taunt/taunt6.wav","vj_bmce_zmb/vocals/classic/taunt/taunt7.wav"}
		self.SoundTbl_Idle = {"vj_bmce_zmb/vocals/classic/amb/ambient1.wav","vj_bmce_zmb/vocals/classic/amb/ambient2.wav","vj_bmce_zmb/vocals/classic/amb/ambient3.wav","vj_bmce_zmb/vocals/classic/amb/ambient4.wav","vj_bmce_zmb/vocals/classic/amb/ambient5.wav","vj_bmce_zmb/vocals/classic/amb/ambient6.wav","vj_bmce_zmb/vocals/classic/amb/ambient7.wav","vj_bmce_zmb/vocals/classic/amb/ambient8.wav","vj_bmce_zmb/vocals/classic/amb/ambient9.wav","vj_bmce_zmb/vocals/classic/amb/ambient10.wav","vj_bmce_zmb/vocals/classic/amb/ambient11.wav","vj_bmce_zmb/vocals/classic/amb/ambient12.wav","vj_bmce_zmb/vocals/classic/amb/ambient13.wav","vj_bmce_zmb/vocals/classic/amb/ambient14.wav","vj_bmce_zmb/vocals/classic/amb/ambient15.wav","vj_bmce_zmb/vocals/classic/amb/ambient16.wav","vj_bmce_zmb/vocals/classic/amb/ambient17.wav","vj_bmce_zmb/vocals/classic/amb/ambient18.wav","vj_bmce_zmb/vocals/classic/amb/ambient19.wav","vj_bmce_zmb/vocals/classic/amb/ambient20.wav","vj_bmce_zmb/vocals/classic/amb/ambient21.wav"}
		self.SoundTbl_CombatIdle = {"vj_bmce_zmb/vocals/classic/sprint/sprint1.wav","vj_bmce_zmb/vocals/classic/sprint/sprint2.wav","vj_bmce_zmb/vocals/classic/sprint/sprint3.wav","vj_bmce_zmb/vocals/classic/sprint/sprint4.wav","vj_bmce_zmb/vocals/classic/sprint/sprint5.wav","vj_bmce_zmb/vocals/classic/sprint/sprint6.wav","vj_bmce_zmb/vocals/classic/sprint/sprint7.wav","vj_bmce_zmb/vocals/classic/sprint/sprint8.wav","vj_bmce_zmb/vocals/classic/sprint/sprint9.wav","vj_bmce_zmb/vocals/classic/sprint/sprint10.wav","vj_bmce_zmb/vocals/classic/sprint/sprint11.wav","vj_bmce_zmb/vocals/classic/sprint/sprint12.wav","vj_bmce_zmb/vocals/classic/sprint/sprint13.wav","vj_bmce_zmb/vocals/classic/sprint/sprint14.wav","vj_bmce_zmb/vocals/classic/sprint/sprint15.wav","vj_bmce_zmb/vocals/classic/sprint/sprint16.wav","vj_bmce_zmb/vocals/classic/sprint/sprint17.wav"}
		self.SoundTbl_Suppressing = {"vj_bmce_zmb/vocals/classic/sprint/sprint1.wav","vj_bmce_zmb/vocals/classic/sprint/sprint2.wav","vj_bmce_zmb/vocals/classic/sprint/sprint3.wav","vj_bmce_zmb/vocals/classic/sprint/sprint4.wav","vj_bmce_zmb/vocals/classic/sprint/sprint5.wav","vj_bmce_zmb/vocals/classic/sprint/sprint6.wav","vj_bmce_zmb/vocals/classic/sprint/sprint7.wav","vj_bmce_zmb/vocals/classic/sprint/sprint8.wav","vj_bmce_zmb/vocals/classic/sprint/sprint9.wav","vj_bmce_zmb/vocals/classic/sprint/sprint10.wav","vj_bmce_zmb/vocals/classic/sprint/sprint11.wav","vj_bmce_zmb/vocals/classic/sprint/sprint12.wav","vj_bmce_zmb/vocals/classic/sprint/sprint13.wav","vj_bmce_zmb/vocals/classic/sprint/sprint14.wav","vj_bmce_zmb/vocals/classic/sprint/sprint15.wav","vj_bmce_zmb/vocals/classic/sprint/sprint16.wav","vj_bmce_zmb/vocals/classic/sprint/sprint17.wav"}
		self.SoundTbl_BeforeMeleeAttack = {"vj_bmce_zmb/vocals/classic/attack/attack1.wav","vj_bmce_zmb/vocals/classic/attack/attack2.wav","vj_bmce_zmb/vocals/classic/attack/attack3.wav","vj_bmce_zmb/vocals/classic/attack/attack4.wav","vj_bmce_zmb/vocals/classic/attack/attack5.wav","vj_bmce_zmb/vocals/classic/attack/attack6.wav","vj_bmce_zmb/vocals/classic/attack/attack7.wav","vj_bmce_zmb/vocals/classic/attack/attack8.wav","vj_bmce_zmb/vocals/classic/attack/attack9.wav","vj_bmce_zmb/vocals/classic/attack/attack10.wav","vj_bmce_zmb/vocals/classic/attack/attack11.wav","vj_bmce_zmb/vocals/classic/attack/attack12.wav","vj_bmce_zmb/vocals/classic/attack/attack13.wav","vj_bmce_zmb/vocals/classic/attack/attack14.wav","vj_bmce_zmb/vocals/classic/attack/attack15.wav","vj_bmce_zmb/vocals/classic/attack/attack16.wav","vj_bmce_zmb/vocals/classic/attack/attack17.wav","vj_bmce_zmb/vocals/classic/attack/attack18.wav","vj_bmce_zmb/vocals/classic/attack/attack19.wav","vj_bmce_zmb/vocals/classic/attack/attack20.wav","vj_bmce_zmb/vocals/classic/attack/attack21.wav","vj_bmce_zmb/vocals/classic/attack/attack22.wav","vj_bmce_zmb/vocals/classic/attack/attack23.wav","vj_bmce_zmb/vocals/classic/attack/attack24.wav","vj_bmce_zmb/vocals/classic/attack/attack25.wav","vj_bmce_zmb/vocals/classic/attack/attack26.wav","vj_bmce_zmb/vocals/classic/attack/attack27.wav","vj_bmce_zmb/vocals/classic/attack/attack28.wav","vj_bmce_zmb/vocals/classic/attack/attack29.wav","vj_bmce_zmb/vocals/classic/attack/attack30.wav","vj_bmce_zmb/vocals/classic/attack/attack31.wav","vj_bmce_zmb/vocals/classic/attack/attack32.wav"}
		self.SoundTbl_Death = {"vj_bmce_zmb/vocals/classic/death/death1.wav","vj_bmce_zmb/vocals/classic/death/death2.wav","vj_bmce_zmb/vocals/classic/death/death3.wav","vj_bmce_zmb/vocals/classic/death/death4.wav","vj_bmce_zmb/vocals/classic/death/death5.wav","vj_bmce_zmb/vocals/classic/death/death6.wav","vj_bmce_zmb/vocals/classic/death/death7.wav","vj_bmce_zmb/vocals/classic/death/death8.wav","vj_bmce_zmb/vocals/classic/death/death9.wav","vj_bmce_zmb/vocals/classic/death/death10.wav","vj_bmce_zmb/vocals/classic/death/death1.wav","vj_bmce_zmb/vocals/classic/death/death2.wav","vj_bmce_zmb/vocals/classic/death/death3.wav","vj_bmce_zmb/vocals/classic/death/death4.wav","vj_bmce_zmb/vocals/classic/death/death5.wav","vj_bmce_zmb/vocals/classic/death/death6.wav","vj_bmce_zmb/vocals/classic/death/death7.wav","vj_bmce_zmb/vocals/classic/death/death8.wav","vj_bmce_zmb/vocals/classic/death/death9.wav","vj_bmce_zmb/vocals/classic/death/death10.wav","vj_bmce_zmb/vocals/classic/elec/elec1.wav","vj_bmce_zmb/vocals/classic/elec/elec2.wav","vj_bmce_zmb/vocals/classic/elec/elec3.wav","vj_bmce_zmb/vocals/classic/elec/elec4.wav","vj_bmce_zmb/vocals/classic/elec/elec5.wav","vj_bmce_zmb/vocals/classic/elec/elec6.wav"}
		self.SoundTbl_MeleeAttack = { "vj_bmce_zmb/vocals/classic/attack1.wav","vj_bmce_zmb/vocals/classic/attack2.wav","vj_bmce_zmb/vocals/classic/attack3.wav"}
		self.SoundTbl_MeleeAttackMiss = {"vj_bmce_zmb/vocals/classic/attack1.wav","vj_bmce_zmb/vocals/classic/attack2.wav","vj_bmce_zmb/vocals/classic/attack3.wav"}
	elseif Zombie_Voice_Male == 2 then --  Modern Call Of Duty Zombie sounds
		self.SoundTbl_Alert = {"vj_bmce_zmb/vocals/modern/taunt/zm_mod.all_62.mp3","vj_bmce_zmb/vocals/modern/taunt/zm_mod.all_63.mp3","vj_bmce_zmb/vocals/modern/taunt/zm_mod.all_64.mp3","vj_bmce_zmb/vocals/modern/taunt/zm_mod.all_65.mp3","vj_bmce_zmb/vocals/modern/taunt/zm_mod.all_66.mp3","vj_bmce_zmb/vocals/modern/taunt/zm_mod.all_67.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_89.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_93.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_97.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_1.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_2.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_3.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_4.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_5.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_6.mp3"}
		self.SoundTbl_Idle = {"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_26.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_27.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_28.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_29.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_30.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_31.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_32.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_33.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_34.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_35.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_36.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_37.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_38.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_39.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_40.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_41.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_42.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_43.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_44.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_45.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_46.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_47.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_48.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_49.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_50.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_51.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_52.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_53.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_54.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_55.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_56.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_57.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_58.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_59.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_60.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_61.mp3"}
		self.SoundTbl_CombatIdle = {"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_84.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_85.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_86.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_87.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_88.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_89.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_90.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_91.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_92.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_93.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_94.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_95.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_96.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_97.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_98.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_99.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_100.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_101.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_102.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_103.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_104.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_105.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_106.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_107.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_108.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_109.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_110.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_111.mp3"}
		self.SoundTbl_Suppressing = {"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_84.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_85.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_86.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_87.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_88.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_89.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_90.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_91.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_92.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_93.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_94.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_95.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_96.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_97.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_98.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_99.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_100.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_101.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_102.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_103.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_104.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_105.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_106.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_107.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_108.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_109.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_110.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_111.mp3"}
		self.SoundTbl_BeforeMeleeAttack = {"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_1.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_2.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_3.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_4.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_5.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_6.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_7.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_8.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_9.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_10.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_11.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_12.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_13.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_14.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_15.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_16.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_17.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_18.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_19.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_20.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_21.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_22.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_23.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_24.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_25.mp3"}
		self.SoundTbl_Death = {"vj_bmce_zmb/vocals/modern/death/zm_mod.all_68.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_69.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_70.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_71.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_72.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_73.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_74.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_75.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_76.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_77.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_78.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_79.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_80.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_81.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_82.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_83.mp3"}
		self.SoundTbl_MeleeAttack = {"vj_bmce_zmb/vocals/zm_mod.all_112.wav","vj_bmce_zmb/vocals/zm_mod.all_113.wav","vj_bmce_zmb/vocals/zm_mod.all_114.wav","vj_bmce_zmb/vocals/zm_mod.all_115.wav","vj_bmce_zmb/vocals/zm_mod.all_116.wav","vj_bmce_zmb/vocals/zm_mod.all_117.wav"}
		self.SoundTbl_MeleeAttackMiss = {"vj_bmce_zmb/vocals/classic/attack1.wav","vj_bmce_zmb/vocals/classic/attack2.wav","vj_bmce_zmb/vocals/classic/attack3.wav"}
	elseif Zombie_Voice_Male == 3 then -- RDR Undead (DLC6) Zombie Male 01
		self.SoundTbl_Alert = {"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_12.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_13.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_14.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_15.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_16.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_17.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_18.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_19.mp3"}
		self.SoundTbl_Idle = {"vj_bmce_zmb/vocals/dlc6/zombie_male/roar_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/roar_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/roar_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/roar_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/roar_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/roar_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/roar_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/roar_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/roar_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_12.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_13.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_14.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_15.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_16.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_17.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_18.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_19.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_20.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_21.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_22.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_23.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_24.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_25.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_26.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_27.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_28.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_29.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_30.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_31.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_32.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_33.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_34.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_35.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_36.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_37.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_38.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/idle_39.mp3"}
		self.SoundTbl_CombatIdle = {"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_12.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_13.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_14.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_15.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_16.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_17.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_18.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_19.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_20.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_21.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_22.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_23.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_24.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_25.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_26.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_27.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_28.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_29.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_30.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_31.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_32.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_33.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_34.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_35.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_36.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_37.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_38.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_39.mp3"}
		self.SoundTbl_Suppressing = {"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_12.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_13.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_14.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_15.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_16.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_17.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_18.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_19.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_20.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_21.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_22.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_23.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_24.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_25.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_26.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_27.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_28.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_29.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_30.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_31.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_32.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_33.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_34.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_35.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_36.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_37.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_38.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attacking_39.mp3"}
		self.SoundTbl_BeforeMeleeAttack = {"vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_12.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_13.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_14.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_15.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_16.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_17.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_18.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_01/attack_noise_19.mp3"}
		self.SoundTbl_Death = {"vj_bmce_zmb/vocals/dlc6/zombie_male/death_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_12.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_13.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_14.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_15.mp3"}
		self.SoundTbl_Pain = {"vj_bmce_zmb/vocals/dlc6/zombie_male/pain_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/pain_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/pain_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/pain_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/pain_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/pain_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/pain_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/pain_08.mp3"}
		self.SoundTbl_MeleeAttack = { "vj_bmce_zmb/vocals/classic/attack1.wav","vj_bmce_zmb/vocals/classic/attack2.wav","vj_bmce_zmb/vocals/classic/attack3.wav"}
		self.SoundTbl_MeleeAttackMiss = {"vj_bmce_zmb/vocals/classic/attack1.wav","vj_bmce_zmb/vocals/classic/attack2.wav","vj_bmce_zmb/vocals/classic/attack3.wav"}
	elseif Zombie_Voice_Male == 4 then -- RDR Undead (DLC6) Zombie Male 02
		self.SoundTbl_Alert = {"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_12.mp3"}
		self.SoundTbl_Idle = {"vj_bmce_zmb/vocals/dlc6/zombie_male/roar_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/roar_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/roar_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/roar_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/roar_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/roar_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/roar_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/roar_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/roar_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_12.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_13.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_14.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_15.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_16.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_17.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_18.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_19.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_20.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_21.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_22.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_23.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_24.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_25.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_26.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_27.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_28.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_29.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_30.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_31.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_32.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_33.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_34.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/idle_35.mp3"}
		self.SoundTbl_CombatIdle = {"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_12.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_13.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_14.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_15.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_16.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_17.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_18.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_19.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_20.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_21.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_22.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_23.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_24.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_25.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_26.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_27.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_28.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_29.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_30.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_31.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_32.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_33.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_34.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_35.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_36.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_37.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_38.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_39.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_40.mp3"}
		self.SoundTbl_Suppressing = {"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_12.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_13.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_14.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_15.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_16.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_17.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_18.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_19.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_20.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_21.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_22.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_23.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_24.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_25.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_26.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_27.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_28.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_29.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_30.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_31.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_32.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_33.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_34.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_35.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_36.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_37.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_38.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_39.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attacking_40.mp3"}
		self.SoundTbl_BeforeMeleeAttack = {"vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_02/attack_noise_12.mp3"}
		self.SoundTbl_Death = {"vj_bmce_zmb/vocals/dlc6/zombie_male/death_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_12.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_13.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_14.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_15.mp3"}
		self.SoundTbl_Pain = {"vj_bmce_zmb/vocals/dlc6/zombie_male/pain_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/pain_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/pain_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/pain_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/pain_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/pain_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/pain_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/pain_08.mp3"}
		self.SoundTbl_MeleeAttack = { "vj_bmce_zmb/vocals/classic/attack1.wav","vj_bmce_zmb/vocals/classic/attack2.wav","vj_bmce_zmb/vocals/classic/attack3.wav"}
		self.SoundTbl_MeleeAttackMiss = {"vj_bmce_zmb/vocals/classic/attack1.wav","vj_bmce_zmb/vocals/classic/attack2.wav","vj_bmce_zmb/vocals/classic/attack3.wav"}
	elseif Zombie_Voice_Male == 5 then -- RDR Undead (DLC6) Zombie Male 03
		self.SoundTbl_Alert = {"vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_12.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_13.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_14.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_15.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_16.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_17.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_18.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_19.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_20.mp3"}
		self.SoundTbl_Idle = {"vj_bmce_zmb/vocals/dlc6/zombie_male/roar_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/roar_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/roar_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/roar_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/roar_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/roar_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/roar_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/roar_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/roar_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_12.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_13.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_14.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_15.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_16.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_17.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_18.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_19.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_20.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_21.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_22.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_23.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_24.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_25.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_26.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_27.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_28.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_29.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_30.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_31.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_32.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_33.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_34.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_35.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_36.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_37.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_38.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_39.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/idle_40.mp3"}
		self.SoundTbl_CombatIdle = {"vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_12.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_13.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_14.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_15.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_16.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_17.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_18.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_19.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_20.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_21.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_22.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_23.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_24.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_25.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_26.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_27.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_28.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_29.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_30.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_31.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_32.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_33.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_34.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_35.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_36.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_37.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_38.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_39.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_40.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_41.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_42.mp3"}
		self.SoundTbl_Suppressing = {"vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_12.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_13.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_14.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_15.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_16.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_17.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_18.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_19.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_20.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_21.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_22.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_23.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_24.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_25.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_26.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_27.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_28.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_29.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_30.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_31.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_32.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_33.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_34.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_35.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_36.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_37.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_38.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_39.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_40.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_41.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attacking_42.mp3"}
		self.SoundTbl_BeforeMeleeAttack = {"vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_12.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_13.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_14.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_15.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_16.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_17.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_18.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_19.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male_03/attack_noise_20.mp3"}
		self.SoundTbl_Death = {"vj_bmce_zmb/vocals/dlc6/zombie_male/death_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_12.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_13.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_14.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/death_15.mp3"}
		self.SoundTbl_Pain = {"vj_bmce_zmb/vocals/dlc6/zombie_male/pain_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/pain_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/pain_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/pain_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/pain_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/pain_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/pain_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_male/pain_08.mp3"}
		self.SoundTbl_MeleeAttack = { "vj_bmce_zmb/vocals/classic/attack1.wav","vj_bmce_zmb/vocals/classic/attack2.wav","vj_bmce_zmb/vocals/classic/attack3.wav"}
		self.SoundTbl_MeleeAttackMiss = {"vj_bmce_zmb/vocals/classic/attack1.wav","vj_bmce_zmb/vocals/classic/attack2.wav","vj_bmce_zmb/vocals/classic/attack3.wav"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UseFemaleZombieVoice()
	local Zombie_Voice_Female = random(3,3)

	if Zombie_Voice_Female == 1 then --  Classic Call Of Duty Zombie sounds
		self.SoundTbl_Alert = {"vj_bmce_zmb/vocals/classic/attack/attack1.wav","vj_bmce_zmb/vocals/classic/attack/attack2.wav","vj_bmce_zmb/vocals/classic/attack/attack6.wav","vj_bmce_zmb/vocals/classic/attack/attack7.wav","vj_bmce_zmb/vocals/classic/attack/attack14.wav","vj_bmce_zmb/vocals/classic/attack/attack20.wav","vj_bmce_zmb/vocals/classic/attack/attack22.wav","vj_bmce_zmb/vocals/classic/behind/behind1.wav","vj_bmce_zmb/vocals/classic/behind/behind2.wav","vj_bmce_zmb/vocals/classic/behind/behind3.wav","vj_bmce_zmb/vocals/classic/behind/behind4.wav","vj_bmce_zmb/vocals/classic/behind/behind5.wav","vj_bmce_zmb/vocals/classic/crawl/crawl1.wav","vj_bmce_zmb/vocals/classic/crawl/crawl2.wav","vj_bmce_zmb/vocals/classic/crawl/crawl3.wav","vj_bmce_zmb/vocals/classic/crawl/crawl4.wav","vj_bmce_zmb/vocals/classic/crawl/crawl5.wav","vj_bmce_zmb/vocals/classic/taunt/taunt1.wav","vj_bmce_zmb/vocals/classic/taunt/taunt2.wav","vj_bmce_zmb/vocals/classic/taunt/taunt3.wav","vj_bmce_zmb/vocals/classic/taunt/taunt4.wav","vj_bmce_zmb/vocals/classic/taunt/taunt5.wav","vj_bmce_zmb/vocals/classic/taunt/taunt6.wav","vj_bmce_zmb/vocals/classic/taunt/taunt7.wav","vj_bmce_zmb/vocals/classic/taunt/taunt1.wav","vj_bmce_zmb/vocals/classic/taunt/taunt2.wav","vj_bmce_zmb/vocals/classic/taunt/taunt3.wav","vj_bmce_zmb/vocals/classic/taunt/taunt4.wav","vj_bmce_zmb/vocals/classic/taunt/taunt5.wav","vj_bmce_zmb/vocals/classic/taunt/taunt6.wav","vj_bmce_zmb/vocals/classic/taunt/taunt7.wav"}
		self.SoundTbl_Idle = {"vj_bmce_zmb/vocals/classic/amb/ambient1.wav","vj_bmce_zmb/vocals/classic/amb/ambient2.wav","vj_bmce_zmb/vocals/classic/amb/ambient3.wav","vj_bmce_zmb/vocals/classic/amb/ambient4.wav","vj_bmce_zmb/vocals/classic/amb/ambient5.wav","vj_bmce_zmb/vocals/classic/amb/ambient6.wav","vj_bmce_zmb/vocals/classic/amb/ambient7.wav","vj_bmce_zmb/vocals/classic/amb/ambient8.wav","vj_bmce_zmb/vocals/classic/amb/ambient9.wav","vj_bmce_zmb/vocals/classic/amb/ambient10.wav","vj_bmce_zmb/vocals/classic/amb/ambient11.wav","vj_bmce_zmb/vocals/classic/amb/ambient12.wav","vj_bmce_zmb/vocals/classic/amb/ambient13.wav","vj_bmce_zmb/vocals/classic/amb/ambient14.wav","vj_bmce_zmb/vocals/classic/amb/ambient15.wav","vj_bmce_zmb/vocals/classic/amb/ambient16.wav","vj_bmce_zmb/vocals/classic/amb/ambient17.wav","vj_bmce_zmb/vocals/classic/amb/ambient18.wav","vj_bmce_zmb/vocals/classic/amb/ambient19.wav","vj_bmce_zmb/vocals/classic/amb/ambient20.wav","vj_bmce_zmb/vocals/classic/amb/ambient21.wav"}
		self.SoundTbl_CombatIdle = {"vj_bmce_zmb/vocals/classic/sprint/sprint1.wav","vj_bmce_zmb/vocals/classic/sprint/sprint2.wav","vj_bmce_zmb/vocals/classic/sprint/sprint3.wav","vj_bmce_zmb/vocals/classic/sprint/sprint4.wav","vj_bmce_zmb/vocals/classic/sprint/sprint5.wav","vj_bmce_zmb/vocals/classic/sprint/sprint6.wav","vj_bmce_zmb/vocals/classic/sprint/sprint7.wav","vj_bmce_zmb/vocals/classic/sprint/sprint8.wav","vj_bmce_zmb/vocals/classic/sprint/sprint9.wav","vj_bmce_zmb/vocals/classic/sprint/sprint10.wav","vj_bmce_zmb/vocals/classic/sprint/sprint11.wav","vj_bmce_zmb/vocals/classic/sprint/sprint12.wav","vj_bmce_zmb/vocals/classic/sprint/sprint13.wav","vj_bmce_zmb/vocals/classic/sprint/sprint14.wav","vj_bmce_zmb/vocals/classic/sprint/sprint15.wav","vj_bmce_zmb/vocals/classic/sprint/sprint16.wav","vj_bmce_zmb/vocals/classic/sprint/sprint17.wav"}
		self.SoundTbl_Suppressing = {"vj_bmce_zmb/vocals/classic/sprint/sprint1.wav","vj_bmce_zmb/vocals/classic/sprint/sprint2.wav","vj_bmce_zmb/vocals/classic/sprint/sprint3.wav","vj_bmce_zmb/vocals/classic/sprint/sprint4.wav","vj_bmce_zmb/vocals/classic/sprint/sprint5.wav","vj_bmce_zmb/vocals/classic/sprint/sprint6.wav","vj_bmce_zmb/vocals/classic/sprint/sprint7.wav","vj_bmce_zmb/vocals/classic/sprint/sprint8.wav","vj_bmce_zmb/vocals/classic/sprint/sprint9.wav","vj_bmce_zmb/vocals/classic/sprint/sprint10.wav","vj_bmce_zmb/vocals/classic/sprint/sprint11.wav","vj_bmce_zmb/vocals/classic/sprint/sprint12.wav","vj_bmce_zmb/vocals/classic/sprint/sprint13.wav","vj_bmce_zmb/vocals/classic/sprint/sprint14.wav","vj_bmce_zmb/vocals/classic/sprint/sprint15.wav","vj_bmce_zmb/vocals/classic/sprint/sprint16.wav","vj_bmce_zmb/vocals/classic/sprint/sprint17.wav"}
		self.SoundTbl_BeforeMeleeAttack = {"vj_bmce_zmb/vocals/classic/attack/attack1.wav","vj_bmce_zmb/vocals/classic/attack/attack2.wav","vj_bmce_zmb/vocals/classic/attack/attack3.wav","vj_bmce_zmb/vocals/classic/attack/attack4.wav","vj_bmce_zmb/vocals/classic/attack/attack5.wav","vj_bmce_zmb/vocals/classic/attack/attack6.wav","vj_bmce_zmb/vocals/classic/attack/attack7.wav","vj_bmce_zmb/vocals/classic/attack/attack8.wav","vj_bmce_zmb/vocals/classic/attack/attack9.wav","vj_bmce_zmb/vocals/classic/attack/attack10.wav","vj_bmce_zmb/vocals/classic/attack/attack11.wav","vj_bmce_zmb/vocals/classic/attack/attack12.wav","vj_bmce_zmb/vocals/classic/attack/attack13.wav","vj_bmce_zmb/vocals/classic/attack/attack14.wav","vj_bmce_zmb/vocals/classic/attack/attack15.wav","vj_bmce_zmb/vocals/classic/attack/attack16.wav","vj_bmce_zmb/vocals/classic/attack/attack17.wav","vj_bmce_zmb/vocals/classic/attack/attack18.wav","vj_bmce_zmb/vocals/classic/attack/attack19.wav","vj_bmce_zmb/vocals/classic/attack/attack20.wav","vj_bmce_zmb/vocals/classic/attack/attack21.wav","vj_bmce_zmb/vocals/classic/attack/attack22.wav","vj_bmce_zmb/vocals/classic/attack/attack23.wav","vj_bmce_zmb/vocals/classic/attack/attack24.wav","vj_bmce_zmb/vocals/classic/attack/attack25.wav","vj_bmce_zmb/vocals/classic/attack/attack26.wav","vj_bmce_zmb/vocals/classic/attack/attack27.wav","vj_bmce_zmb/vocals/classic/attack/attack28.wav","vj_bmce_zmb/vocals/classic/attack/attack29.wav","vj_bmce_zmb/vocals/classic/attack/attack30.wav","vj_bmce_zmb/vocals/classic/attack/attack31.wav","vj_bmce_zmb/vocals/classic/attack/attack32.wav"}
		self.SoundTbl_Death = {"vj_bmce_zmb/vocals/classic/death/death1.wav","vj_bmce_zmb/vocals/classic/death/death2.wav","vj_bmce_zmb/vocals/classic/death/death3.wav","vj_bmce_zmb/vocals/classic/death/death4.wav","vj_bmce_zmb/vocals/classic/death/death5.wav","vj_bmce_zmb/vocals/classic/death/death6.wav","vj_bmce_zmb/vocals/classic/death/death7.wav","vj_bmce_zmb/vocals/classic/death/death8.wav","vj_bmce_zmb/vocals/classic/death/death9.wav","vj_bmce_zmb/vocals/classic/death/death10.wav","vj_bmce_zmb/vocals/classic/death/death1.wav","vj_bmce_zmb/vocals/classic/death/death2.wav","vj_bmce_zmb/vocals/classic/death/death3.wav","vj_bmce_zmb/vocals/classic/death/death4.wav","vj_bmce_zmb/vocals/classic/death/death5.wav","vj_bmce_zmb/vocals/classic/death/death6.wav","vj_bmce_zmb/vocals/classic/death/death7.wav","vj_bmce_zmb/vocals/classic/death/death8.wav","vj_bmce_zmb/vocals/classic/death/death9.wav","vj_bmce_zmb/vocals/classic/death/death10.wav","vj_bmce_zmb/vocals/classic/elec/elec1.wav","vj_bmce_zmb/vocals/classic/elec/elec2.wav","vj_bmce_zmb/vocals/classic/elec/elec3.wav","vj_bmce_zmb/vocals/classic/elec/elec4.wav","vj_bmce_zmb/vocals/classic/elec/elec5.wav","vj_bmce_zmb/vocals/classic/elec/elec6.wav"}
		self.SoundTbl_MeleeAttack = { "vj_bmce_zmb/vocals/classic/attack1.wav","vj_bmce_zmb/vocals/classic/attack2.wav","vj_bmce_zmb/vocals/classic/attack3.wav"}
		self.SoundTbl_MeleeAttackMiss = {"vj_bmce_zmb/vocals/classic/attack1.wav","vj_bmce_zmb/vocals/classic/attack2.wav","vj_bmce_zmb/vocals/classic/attack3.wav"}
	elseif Zombie_Voice_Female == 2 then --  Modern Call Of Duty Zombie sounds
		self.SoundTbl_Alert = {"vj_bmce_zmb/vocals/modern/taunt/zm_mod.all_62.mp3","vj_bmce_zmb/vocals/modern/taunt/zm_mod.all_63.mp3","vj_bmce_zmb/vocals/modern/taunt/zm_mod.all_64.mp3","vj_bmce_zmb/vocals/modern/taunt/zm_mod.all_65.mp3","vj_bmce_zmb/vocals/modern/taunt/zm_mod.all_66.mp3","vj_bmce_zmb/vocals/modern/taunt/zm_mod.all_67.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_89.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_93.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_97.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_1.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_2.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_3.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_4.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_5.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_6.mp3"}
		self.SoundTbl_Idle = {"vj_bmce_zmb/vocals/modern/amb/zm_mod.all_26.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_27.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_28.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_29.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_30.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_31.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_32.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_33.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_34.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_35.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_36.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_37.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_38.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_39.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_40.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_41.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_42.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_43.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_44.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_45.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_46.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_47.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_48.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_49.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_50.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_51.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_52.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_53.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_54.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_55.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_56.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_57.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_58.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_59.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_60.mp3","vj_bmce_zmb/vocals/modern/amb/zm_mod.all_61.mp3"}
		self.SoundTbl_CombatIdle = {"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_84.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_85.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_86.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_87.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_88.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_89.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_90.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_91.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_92.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_93.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_94.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_95.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_96.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_97.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_98.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_99.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_100.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_101.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_102.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_103.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_104.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_105.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_106.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_107.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_108.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_109.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_110.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_111.mp3"}
		self.SoundTbl_Suppressing = {"vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_84.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_85.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_86.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_87.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_88.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_89.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_90.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_91.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_92.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_93.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_94.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_95.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_96.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_97.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_98.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_99.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_100.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_101.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_102.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_103.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_104.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_105.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_106.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_107.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_108.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_109.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_110.mp3","vj_bmce_zmb/vocals/modern/sprint/zm_mod.all_111.mp3"}
		self.SoundTbl_BeforeMeleeAttack = {"vj_bmce_zmb/vocals/modern/attack/zm_mod.all_1.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_2.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_3.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_4.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_5.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_6.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_7.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_8.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_9.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_10.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_11.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_12.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_13.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_14.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_15.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_16.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_17.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_18.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_19.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_20.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_21.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_22.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_23.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_24.mp3","vj_bmce_zmb/vocals/modern/attack/zm_mod.all_25.mp3"}
		self.SoundTbl_Death = {"vj_bmce_zmb/vocals/modern/death/zm_mod.all_68.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_69.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_70.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_71.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_72.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_73.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_74.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_75.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_76.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_77.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_78.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_79.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_80.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_81.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_82.mp3","vj_bmce_zmb/vocals/modern/death/zm_mod.all_83.mp3"}
		self.SoundTbl_MeleeAttack = {"vj_bmce_zmb/vocals/zm_mod.all_112.wav","vj_bmce_zmb/vocals/zm_mod.all_113.wav","vj_bmce_zmb/vocals/zm_mod.all_114.wav","vj_bmce_zmb/vocals/zm_mod.all_115.wav","vj_bmce_zmb/vocals/zm_mod.all_116.wav","vj_bmce_zmb/vocals/zm_mod.all_117.wav"}
		self.SoundTbl_MeleeAttackMiss = {"vj_bmce_zmb/vocals/classic/attack1.wav","vj_bmce_zmb/vocals/classic/attack2.wav","vj_bmce_zmb/vocals/classic/attack3.wav"}
	elseif Zombie_Voice_Female == 3 then --   RDR Undead (DLC6) Zombie Female 01
		self.SoundTbl_Alert = {"vj_bmce_zmb/vocals/dlc6/zombie_female_01/attack_noise_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attack_noise_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attack_noise_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attack_noise_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attack_noise_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attack_noise_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attack_noise_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attack_noise_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attack_noise_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attack_noise_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attack_noise_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attack_noise_12.mp3"}
		self.SoundTbl_Idle = {"vj_bmce_zmb/vocals/dlc6/zombie_female/roar_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female/roar_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female/roar_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female/roar_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female/roar_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female/roar_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female/roar_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female/roar_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female/roar_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_12.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_13.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_14.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_15.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_16.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_17.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_18.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_19.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_20.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_21.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_22.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_23.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_24.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_25.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_26.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_27.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_28.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_29.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_30.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_31.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_32.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_33.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/idle_34.mp3"}
		self.SoundTbl_CombatIdle = {"vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_12.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_13.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_14.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_15.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_16.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_17.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_18.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_19.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_20.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_21.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_22.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_23.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_24.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_25.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_26.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_27.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_28.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_29.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_30.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_31.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_32.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_33.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_34.mp3"}
		self.SoundTbl_Suppressing = {"vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_12.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_13.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_14.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_15.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_16.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_17.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_18.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_19.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_20.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_21.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_22.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_23.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_24.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_25.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_26.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_27.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_28.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_29.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_30.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_31.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_32.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_33.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attacking_34.mp3"}
		self.SoundTbl_BeforeMeleeAttack = {"vj_bmce_zmb/vocals/dlc6/zombie_female_01/attack_noise_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attack_noise_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attack_noise_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attack_noise_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attack_noise_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attack_noise_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attack_noise_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attack_noise_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attack_noise_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attack_noise_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attack_noise_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female_01/attack_noise_12.mp3"}
		self.SoundTbl_Death = {"vj_bmce_zmb/vocals/dlc6/zombie_female/death_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female/death_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female/death_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female/death_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female/death_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female/death_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female/death_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female/death_08.mp3"}
		self.SoundTbl_Pain = {"vj_bmce_zmb/vocals/dlc6/zombie_female/pain_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female/pain_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female/pain_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female/pain_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female/pain_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_female/pain_06.mp3"}
		self.SoundTbl_MeleeAttack = { "vj_bmce_zmb/vocals/classic/attack1.wav","vj_bmce_zmb/vocals/classic/attack2.wav","vj_bmce_zmb/vocals/classic/attack3.wav"}
		self.SoundTbl_MeleeAttackMiss = {"vj_bmce_zmb/vocals/classic/attack1.wav","vj_bmce_zmb/vocals/classic/attack2.wav","vj_bmce_zmb/vocals/classic/attack3.wav"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UseBruiserZombieMale()
	local Bruiser_zmb_voice = random(1,1)
	self.Zombie_Bruiser = 1
	
	if Bruiser_zmb_voice == 1 then
		self.SoundTbl_Alert = {"vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_12.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_13.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_14.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_15.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_16.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_17.mp3"}
		self.SoundTbl_Idle = {"vj_bmce_zmb/vocals/dlc6/bruiser/roar_01.mp3","vj_bmce_zmb/vocals/dlc6/bruiser/roar_02.mp3","vj_bmce_zmb/vocals/dlc6/bruiser/roar_03.mp3","vj_bmce_zmb/vocals/dlc6/bruiser/roar_04.mp3","vj_bmce_zmb/vocals/dlc6/bruiser/roar_05.mp3","vj_bmce_zmb/vocals/dlc6/bruiser/roar_06.mp3","vj_bmce_zmb/vocals/dlc6/bruiser/roar_07.mp3","vj_bmce_zmb/vocals/dlc6/bruiser/roar_08.mp3","vj_bmce_zmb/vocals/dlc6/bruiser/roar_09.mp3","vj_bmce_zmb/vocals/dlc6/bruiser/roar_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_12.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_13.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_14.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_15.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_16.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_17.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_18.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_19.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_20.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_21.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_22.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_23.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_24.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_25.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_26.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_27.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_28.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_29.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_30.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_31.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/idle_32.mp3"}
		self.SoundTbl_CombatIdle = {"vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_12.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_13.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_14.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_15.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_16.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_17.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_18.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_19.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_20.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_21.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_22.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_23.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_24.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_25.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_26.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_27.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_28.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_29.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_30.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_31.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_32.mp3"}
		self.SoundTbl_Suppressing = {"vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_12.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_13.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_14.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_15.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_16.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_17.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_18.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_19.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_20.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_21.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_22.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_23.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_24.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_25.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_26.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_27.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_28.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_29.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_30.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_31.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attacking_32.mp3"}
		self.SoundTbl_BeforeMeleeAttack = {"vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_12.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_13.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_14.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_15.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_16.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/attack_noise_17.mp3"}
		self.SoundTbl_Death = {"vj_bmce_zmb/vocals/dlc6/bruiser/death_01.mp3","vj_bmce_zmb/vocals/dlc6/bruiser/death_02.mp3","vj_bmce_zmb/vocals/dlc6/bruiser/death_03.mp3","vj_bmce_zmb/vocals/dlc6/bruiser/death_04.mp3","vj_bmce_zmb/vocals/dlc6/bruiser/death_05.mp3","vj_bmce_zmb/vocals/dlc6/bruiser/death_06.mp3","vj_bmce_zmb/vocals/dlc6/bruiser/death_07.mp3","vj_bmce_zmb/vocals/dlc6/bruiser/death_08.mp3","vj_bmce_zmb/vocals/dlc6/bruiser/death_09.mp3","vj_bmce_zmb/vocals/dlc6/bruiser/death_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/death_01.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/death_02.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/death_03.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/death_04.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/death_05.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/death_06.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/death_07.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/death_08.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/death_09.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/death_10.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/death_11.mp3","vj_bmce_zmb/vocals/dlc6/zombie_bruiser_male_01/death_12.mp3"}
		self.SoundTbl_MeleeAttack = { "vj_bmce_zmb/vocals/classic/attack1.wav","vj_bmce_zmb/vocals/classic/attack2.wav","vj_bmce_zmb/vocals/classic/attack3.wav"}
		self.SoundTbl_MeleeAttackMiss = {"vj_bmce_zmb/vocals/classic/attack1.wav","vj_bmce_zmb/vocals/classic/attack2.wav","vj_bmce_zmb/vocals/classic/attack3.wav"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupZombie()
	local MDL = self:GetModel()
	local Bruiser_Chance = random(1,3)
	local Hat_Chance = random(1,3)
	local Unique_Hat = random(1,3)

	if MDL == "models/undead/scientist.mdl" or MDL == "models/undead/scientist_02.mdl" then
		self:UseMaleZombieVoice()
		self:SetSkin( random( 0, 14 ))
		self:SetBodygroup( 1, random( 0, 2 )) -- Body
		self:SetBodygroup( 2, random( 0, 7 )) -- Ties
		if Hat_Chance == 1 then self:SetBodygroup( 2, random( 0, 2 )) end
	end

	if MDL == "models/undead/scientist_casual.mdl" or MDL == "models/undead/scientist_casual_02.mdl" then
		self:UseMaleZombieVoice()
		self:SetSkin( random( 0, 14 ))
		self:SetBodygroup( 1, random( 0, 5 )) -- Body
		self:SetBodygroup( 3, random( 0, 8 )) -- Torso
		if Hat_Chance == 1 then self:SetBodygroup( 2, random( 0, 3 )) end
	end

	if MDL == "models/undead/guard.mdl" or MDL == "models/undead/guard_02.mdl" or MDL == "models/undead/guard_03.mdl" then
		self:SetSkin( random( 0, 14 ))
		self:SetBodygroup( 1, random( 0, 3 )) -- Body
		self:SetBodygroup( 3, random( 0, 3 )) -- Chest
		self:SetBodygroup( 4, random( 0, 2 )) -- holster

		if Unique_Hat == 1 then
			self.BMCE_Hat = 1
			self:GiveUniqueHat()
		else
			self:SetBodygroup( 2, random( 0, 5 ))
		end

		if GetConVar("vj_bmce_zmb_bruisers"):GetInt() == 1 then
			if (Bruiser_Chance >= 1 and Bruiser_Chance <= 2) then
				self:UseMaleZombieVoice()
			elseif Bruiser_Chance == 3 then
				self:UseBruiserZombieMale()
			end
		else
			self:UseMaleZombieVoice()
		end
	end

	if MDL == "models/undead/guard_female.mdl" then
		self:UseFemaleZombieVoice()
		self:SetSkin( random( 0, 9 ))
		self:SetBodygroup( 1, random( 0, 1 )) -- Body
		self:SetBodygroup( 3, random( 0, 10 )) -- Hats
		self:SetBodygroup( 4, random( 0, 2 )) -- Chest
		self:SetBodygroup( 5, random( 0, 2 )) -- holster
	end

	if MDL == "models/undead/fem_office_worker.mdl" then
		self:UseFemaleZombieVoice()
		self:SetSkin( random( 0, 35 ))
		self:SetBodygroup( 1, random( 0, 1 )) -- Body
		self:SetBodygroup( 2, random( 0, 5 )) -- Hair
	end

	if MDL == "models/undead/construction_worker.mdl" then
		self:SetSkin(random( 0, 16 ))
		self:SetBodygroup(1,random( 0, 3 )) -- t-shirts
		self:SetBodygroup(2,random( 0, 3 )) -- pants
		self:SetBodygroup(3,random( 0, 1 )) -- shows
		self:SetBodygroup(5,random( 3, 14 )) -- Glasses
		if Hat_Chance == 1 then self:SetBodygroup( 4, random( 0, 4 )) end

		if GetConVar("vj_bmce_zmb_bruisers"):GetInt() == 1 then
			if (Bruiser_Chance >= 1 and Bruiser_Chance <= 2) then
				self:UseMaleZombieVoice()
			elseif Bruiser_Chance == 3 then
				self:UseBruiserZombieMale()
			end
		else
			self:UseMaleZombieVoice()
		end
	end
	if (self.BMCE_Hat >= 1) then self:GiveUniqueHat() end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GiveUniqueHat()
	if self.BMCE_Hat == 1 then -- SecGuard Beret
		self.BeretHat = ents.Create("prop_physics")
		self.BeretHat:SetModel("models/humans/props/guard_beret.mdl")
		self.BeretHat:SetLocalPos(self:GetPos())
		self.BeretHat:SetOwner(self)
		self.BeretHat:SetParent(self)
		self.BeretHat:Fire("SetParentAttachment","eyes")
		self.BeretHat:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		self.BeretHat:Spawn()
		self.BeretHat:Activate()
		self.BeretHat:SetSolid(SOLID_NONE)
		self.BeretHat:AddEffects(EF_BONEMERGE)
		self:SetBodygroup( 2, 1 ) -- Hats (no hat)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZombieWeapons()
    if GetConVar("VJ_LNR_MeleeWeapons"):GetInt() == 0 or self.LNR_Crawler then self.LNR_CanUseWeapon = false return end
    if self.LNR_CanUseWeapon then
		local Weapon = random(1,1)
		self.WeaponModel = ents.Create("prop_physics")	
		if Weapon == 1 then
			self.WeaponModel:SetModel("models/weapons/black_mesa_src/w_357b.mdl")
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
function ENT:Zombie_Difficulty()
	if GetConVar("VJ_LNR_Difficulty"):GetInt() == 1 then // Easy
		self.StartHealth = 150
		self.MeleeAttackDamage = rand(5,10) 
		if self.LNR_CanUseWeapon then self.MeleeAttackDamage = rand(10,15) end 
	end

	if GetConVar("VJ_LNR_Difficulty"):GetInt() == 2 then // Normal
		self.StartHealth = 225		
		self.MeleeAttackDamage = rand(10,15)
		if self.LNR_CanUseWeapon then self.MeleeAttackDamage = rand(15,20) end
	end	

	if GetConVar("VJ_LNR_Difficulty"):GetInt() == 3 then // Hard
		self.StartHealth = 250	
		self.MeleeAttackDamage = rand(15,20)
		if self.LNR_CanUseWeapon then self.MeleeAttackDamage = rand(20,25) end
	end
	
	if GetConVar("VJ_LNR_Difficulty"):GetInt() == 4 then // Nightmare
		self.StartHealth = 300
		self.MeleeAttackDamage = rand(20,25)
		if self.LNR_CanUseWeapon then self.MeleeAttackDamage = rand(25,30) end
	end

	if GetConVar("VJ_LNR_Difficulty"):GetInt() == 5 then // Apocalypse
		self.StartHealth = 400
		self.MeleeAttackDamage = rand(25,30) 
		if self.LNR_CanUseWeapon then self.MeleeAttackDamage = rand(30,35) end		
	end

	if self.Zombie_Bruiser == 1 then
		if GetConVar("VJ_LNR_Difficulty"):GetInt() == 1 then // Easy
			self.StartHealth = 250
			self.MeleeAttackDamage = rand(8,12) 
			if self.LNR_CanUseWeapon then self.MeleeAttackDamage = rand(10,15) end 
		end
	
		if GetConVar("VJ_LNR_Difficulty"):GetInt() == 2 then // Normal
			self.StartHealth = 325		
			self.MeleeAttackDamage = rand(12,16)
			if self.LNR_CanUseWeapon then self.MeleeAttackDamage = rand(15,20) end
		end	
	
		if GetConVar("VJ_LNR_Difficulty"):GetInt() == 3 then // Hard
			self.StartHealth = 400	
			self.MeleeAttackDamage = rand(16,22)
			if self.LNR_CanUseWeapon then self.MeleeAttackDamage = rand(20,25) end
		end
		
		if GetConVar("VJ_LNR_Difficulty"):GetInt() == 4 then // Nightmare
			self.StartHealth = 450
			self.MeleeAttackDamage = rand(22,26)
			if self.LNR_CanUseWeapon then self.MeleeAttackDamage = rand(25,30) end
		end
	
		if GetConVar("VJ_LNR_Difficulty"):GetInt() == 5 then // Apocalypse
			self.StartHealth = 500
			self.MeleeAttackDamage = rand(26,30) 
			if self.LNR_CanUseWeapon then self.MeleeAttackDamage = rand(30,35) end		
		end
	end

	self:SetHealth(self.StartHealth)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply)
	net.Start("vj_bmce_zombie_hud")
		net.WriteBool(false)
		net.WriteEntity(self)
	net.Send(ply)

	function self.VJ_TheControllerEntity:CustomOnStopControlling()
		net.Start("vj_bmce_zombie_hud")
			net.WriteBool(true)
			net.WriteEntity(self)
		net.Send(ply)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize() -- Picks random voices once a SNPC is spawned.
	local faceflex_rnd = random( 1,8 )
	local hairpuff_rnd = rand( 0.0,0.2 )

	self:SetFlexWeight(80,hairpuff_rnd) -- Hairline puff
	
	if faceflex_rnd == 1 then //  Default Open Face
		self:SetFlexWeight(43,0.5) -- Lower Lip
		self:SetFlexWeight(44,1.25) -- Brow H
		self:SetFlexWeight(35,0.62) -- Bite
	elseif faceflex_rnd == 2 then //  Less exaggerated default face
		self:SetFlexWeight(43,0.2) -- Lower Lip
		self:SetFlexWeight(44,1.25) -- Brow H
		self:SetFlexWeight(35,1.6) -- Bite	
	elseif faceflex_rnd == 3 then //  Really exaggerated Open forward 
		self:SetFlexWeight(9,-3.5) -- Blink
		self:SetFlexWeight(25,1.0) -- left corner depressor
		self:SetFlexWeight(35,0.62) -- Bite
		self:SetFlexWeight(44,1.0) -- Brow H
		self:SetFlexWeight(43,3.0) -- Lower Lip
	elseif faceflex_rnd == 4 then //  No forward open
		self:SetFlexWeight(44,1.0) -- Brow H
	elseif faceflex_rnd == 5 then //  No forward open (more angry)
		self:SetFlexWeight(44,1.6) -- Brow H
	elseif faceflex_rnd == 6 then
		self:SetFlexWeight(7,0.41) -- Left Lid Closer
		self:SetFlexWeight(9,0.18) -- Blink
		self:SetFlexWeight(18,0.34) -- Wrinkler
		self:SetFlexWeight(35,0.24) -- Bite
		self:SetFlexWeight(36,0.30) -- Presser
		self:SetFlexWeight(37,1.0) -- Tightener
		self:SetFlexWeight(43,1.0) -- Lower Lip
		self:SetFlexWeight(44,1.0) -- Brow H
		self:SetFlexWeight(79,0.53) -- Cigar
		self:SetFlexWeight(80,0.2) -- Hairline puff
	elseif faceflex_rnd == 7 then
		self:SetFlexWeight(0,1.0) -- Right Lid Raiser
		self:SetFlexWeight(1,1.0) -- Left Lid Raiser
		self:SetFlexWeight(6,0.28) -- Right Lid Closer
		self:SetFlexWeight(7,0.09) -- Left Lid Closer
		self:SetFlexWeight(12,1.0) -- Right Outer Raiser
		self:SetFlexWeight(13,0.84) -- Left Outer Raiser
		self:SetFlexWeight(20,0.01) -- Right Upper Raiser
		self:SetFlexWeight(35,0.51) -- Bite
		self:SetFlexWeight(42,0.47) -- Smile
		self:SetFlexWeight(43,1.0) -- Lower Lip
		self:SetFlexWeight(44,0.4) -- Brow h
		self:SetFlexWeight(79,0.56) -- Cigar
	elseif faceflex_rnd == 8 then
		self:SetFlexWeight(13,0.42) -- Left Outer Raiser
		self:SetFlexWeight(14,1.0) -- Right Lowerer
		self:SetFlexWeight(14,0.47) -- Left Lowerer
		self:SetFlexWeight(15,0.22) -- Right Cheek Raiser
		self:SetFlexWeight(16,0.31) -- Left Cheek Raiser
		self:SetFlexWeight(35,0.72) -- Bite
		self:SetFlexWeight(36,0.46) -- Presser
		self:SetFlexWeight(42,2.0) -- Smile
		self:SetFlexWeight(44,0.47) -- Brow h
		self:SetFlexWeight(79,0.1) -- Cigar
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
	if hitgroup == HITGROUP_HEAD then
		if GetConVar("VJ_LNR_Headshot"):GetInt() == 0 then
			VJ_EmitSound(self, "vj_bmce_zmb/vocals/headshot_"..random(0,6)..".wav", 70)
			dmginfo:ScaleDamage(2)
		elseif GetConVar("VJ_LNR_Headshot"):GetInt() == 1 then
			VJ_EmitSound(self, "vj_bmce_zmb/vocals/headshot_"..random(0,6)..".wav", 70)
			dmginfo:ScaleDamage(200)
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

	local gibchance = random(1,3)

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
		VJ_EmitSound(self,"vj_lnrhl2/shared/zombie_neck_drain_0"..random(1,3)..".wav",60,100)	
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
	local faceflex_rnd = random(1,10)
	local hairpuff_rnd = rand(0.0,0.2)
	VJ_LNR_ApplyCorpseEffects(self,corpseEnt)

	if GetConVar("VJ_LNR_Gib"):GetInt() == 1 then
		if self.LNR_Gibbed then
			VJ_EmitSound(corpseEnt,"vj_lnrhl2/shared/zombie_neck_drain_0"..random(1,3)..".wav",60,100)
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

	if self.BMCE_Hat == 1 then
		self:CreateExtraDeathCorpse("prop_physics","models/humans/props/guard_beret.mdl",{Pos=self:LocalToWorld(Vector(0,0,-2))})
	end

	corpseEnt:SetFlexWeight(80,hairpuff_rnd) -- Hairline puff

	if faceflex_rnd == 1 then
		corpseEnt:SetFlexWeight(9,1) -- Blink
		corpseEnt:SetFlexWeight(43,1) -- Lower Lip
		corpseEnt:SetFlexWeight(79,0.25) -- Cigar
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
	elseif faceflex_rnd == 10 then
		corpseEnt:SetFlexWeight(7,0.41) -- Left Lid Closer
		corpseEnt:SetFlexWeight(9,0.18) -- Blink
		corpseEnt:SetFlexWeight(18,0.34) -- Wrinkler
		corpseEnt:SetFlexWeight(35,0.24) -- Bite
		corpseEnt:SetFlexWeight(36,0.30) -- Presser
		corpseEnt:SetFlexWeight(37,1.0) -- Tightener
		corpseEnt:SetFlexWeight(43,1.0) -- Lower Lip
		corpseEnt:SetFlexWeight(44,1.0) -- Brow H
		corpseEnt:SetFlexWeight(79,0.53) -- Cigar
		corpseEnt:SetFlexWeight(80,0.2) -- Hairline puff
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