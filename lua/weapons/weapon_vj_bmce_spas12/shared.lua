if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

SWEP.Base = "weapon_vj_base"
SWEP.PrintName 					= "SPAS-12 Auto-Shotgun"
SWEP.Author 					= "DrVrej"
SWEP.Contact 					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose 					= "This weapon is made for Players and NPCs"
SWEP.Instructions 				= "Controls are like a regular weapon."
SWEP.Category 					= "VJ BMCE"
	-- Client Settings 
if (CLIENT) then
	SWEP.Slot 					= 3 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
	SWEP.SlotPos				= 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
	SWEP.UseHands 				= false
end
	-- NPC Settings 
SWEP.NPC_NextPrimaryFire 		= 0.9 -- Next time it can use primary fire
SWEP.NPC_CustomSpread 			= 2.5 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
SWEP.NPC_BulletSpawnAttachment 	= 1
--SWEP.NPC_ExtraFireSound			= {"vj_bmce/weapons/bmce_shotgun_spas12/pump.mp3"} -- Plays an extra sound after it fires (Example: Bolt action sound)
SWEP.NPC_ReloadSound			= {"vj_bmce/weapons/bmce_shotgun_spas12/npc_reload.mp3"} -- Sounds it plays when the base detects the SNPC playing a reload animation
SWEP.NPC_FiringDistanceScale 	= 0.5 -- Changes how far the NPC can fire | 1 = No change, x < 1 = closer, x > 1 = farther
	-- Main Settings 
SWEP.ViewModel					= "models/weapons/viewmodels/bmce/v_shotgun.mdl"
SWEP.WorldModel					= "models/weapons/bmce_weapons/bmce_shotgun/w_shotgun.mdl"
SWEP.ViewModelFOV				= 65 -- Player FOV for the view model
SWEP.HoldType 					= "shotgun"
SWEP.Spawnable 					= true
SWEP.AdminSpawnable 			= false
	-- Primary Fire 
SWEP.Primary.Damage 			= 6 -- Damage
SWEP.Primary.PlayerDamage 		= 10 -- Only applies for players | "Same" = Same as self.Primary.Damage, "Double" = Double the self.Primary.Damage OR put a number to be different from self.Primary.Damage
SWEP.Primary.Force 				= 1 -- Force applied on the object the bullet hits
SWEP.Primary.NumberOfShots 		= 8 -- How many shots per attack?
SWEP.Primary.ClipSize 			= 8 -- Max amount of bullets per clip
SWEP.Primary.Cone 				= 30 -- How accurate is the bullet? (Players)
SWEP.Primary.Delay 				= 0.3 -- Time until it can shoot again
SWEP.Primary.Automatic 			= true -- Is it automatic?
SWEP.Primary.Ammo 				= "Buckshot" -- Ammo type
SWEP.Primary.Sound 				= {"vj_bmce/weapons/bmce_shotgun_spas12/close1.mp3"}
SWEP.Primary.HasDistantSound 	= true -- Does it have a distant sound when the gun is shot?
SWEP.Primary.DistantSound 		= {"vj_bmce/weapons/bmce_shotgun_spas12/distant1.mp3"}
SWEP.Primary.DistantSoundLevel 	= 140 -- Distant sound level
SWEP.Primary.DistantSoundPitch1	= 90 -- Distant sound pitch 1
SWEP.Primary.DistantSoundPitch2	= 110 -- Distant sound pitch 2
SWEP.Primary.DistantSoundVolume	= 0.5 -- Distant sound volume
	-- ====== Effect Variables ====== --
SWEP.PrimaryEffects_MuzzleFlash = true
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_ShellAttachment = 2
SWEP.PrimaryEffects_ShellType 	= "VJ_Weapon_ShotgunShell1"
	-- Reload Settings 
SWEP.HasReloadSound 			= false -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.Reload_TimeUntilAmmoIsSet 	= 0.35 -- Time until ammo is set to the weapon
SWEP.Reload_TimeUntilFinished 	= 0.5 -- How much time until the player can play idle animation, shoot, etc.
	-- Idle Settings 
SWEP.HasIdleAnimation 			= true -- Does it have a idle animation?
SWEP.AnimTbl_Idle 				= {ACT_VM_IDLE}
SWEP.NextIdle_Deploy			= 0.5 -- How much time until it plays the idle animation after the weapon gets deployed
SWEP.NextIdle_PrimaryAttack 	= 0.8 -- How much time until it plays the idle animation after attacking(Primary)
-- ====== Secondary Fire Variables ====== --
SWEP.Secondary.Automatic = true -- Is it automatic?
SWEP.Secondary.Ammo = "Buckshot" -- Ammo type
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	-- Make the gun move to the center when aiming
	local aimPos = Vector(-1, 0, 0)
	local aimAng = Angle(0, 0, 0)

	function SWEP:GetViewModelPosition(pos, ang)

		ang:RotateAroundAxis(ang:Right(),aimAng.x)
		ang:RotateAroundAxis(ang:Up(),aimAng.y)
		ang:RotateAroundAxis(ang:Forward(),aimAng.z)

		pos = pos +aimPos.x *ang:Right()
		pos = pos +aimPos.y *ang:Up()
		pos = pos +aimPos.z *ang:Forward()
		
		return pos, ang
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnSecondaryAttack()
	local owner = self:GetOwner()
	if self:Clip1() > 1 then
		self.Primary.Delay = 1.2
		self.Primary.Cone = 40
		self.Primary.NumberOfShots = 16
		self.Primary.TakeAmmo = 2
		self.NextIdle_PrimaryAttack = 1
		self.AnimTbl_PrimaryFire = {ACT_VM_SECONDARYATTACK}
		owner:ViewPunch(Angle(-self.Primary.Recoil *24, 6, 0))
		VJ_EmitSound(self, "vj_bmce/weapons/bmce_shotgun_spas12/close1.mp3", 85, math.random(65,90))
	end
	self:PrimaryAttack()
	self.Primary.Delay = 0.3
	self.Primary.Cone = 30
	self.Primary.NumberOfShots = 8
	self.Primary.TakeAmmo = 1
	self.NextIdle_PrimaryAttack = 0.8
	self.AnimTbl_PrimaryFire = {ACT_VM_PRIMARYATTACK}
	
	self:SetNextSecondaryFire(CurTime() + 1.2)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnReload_Finish()
	local owner = self:GetOwner()
	if !owner:IsPlayer() then return true end
	self:GetOwner():RemoveAmmo(1, self.Primary.Ammo)
	self:SetClip1(self:Clip1() + 1)
	if self.Primary.ClipSize > self:Clip1() then
		timer.Simple(0.1, function()
			if IsValid(self) && IsValid(self:GetOwner()) then
				self.Reloading = false
				self:Reload()
			end
		end)
	end
	return false
end