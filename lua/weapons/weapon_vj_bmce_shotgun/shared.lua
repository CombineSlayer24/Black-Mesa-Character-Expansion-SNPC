if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName 					= "Standard Shotgun"
SWEP.Author 					= "Pyri"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose 					= "This weapon is made for Players and NPCs"
SWEP.Instructions 				= "Controls are like a regular weapon."
SWEP.Category 					= "VJ BMCE"
	-- Client Settings 
if (CLIENT) then
	SWEP.Slot 					= 3 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
	SWEP.SlotPos 				= 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
	SWEP.UseHands 				= false
end
	-- NPC Settings 
SWEP.NPC_NextPrimaryFire 		= 1.5 -- Next time it can use primary fire
SWEP.NPC_CustomSpread 			= 1.5 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
--SWEP.NPC_ExtraFireSound			= {"vj_bmce/weapons/bms_shotgun/pump.mp3"} -- Plays an extra sound after it fires (Example: Bolt action sound)
SWEP.NPC_FiringDistanceScale 	= 0.5 -- Changes how far the NPC can fire | 1 = No change, x < 1 = closer, x > 1 = farther
	-- Main Settings 
SWEP.ViewModel 					= "models/weapons/viewmodels/bms/v_shotgun.mdl"
SWEP.WorldModel					= "models/weapons/black_mesa_src/w_shotgun.mdl"
SWEP.ViewModelFOV				= 74 -- Player FOV for the view model
SWEP.HoldType 					= "shotgun"
SWEP.Spawnable 					= true
SWEP.AdminSpawnable 			= false
	-- Primary Fire 
SWEP.Primary.Damage 			= 6 -- Damage
SWEP.Primary.PlayerDamage 		= 10 -- Only applies for players | "Same" = Same as self.Primary.Damage, "Double" = Double the self.Primary.Damage OR put a number to be different from self.Primary.Damage
SWEP.Primary.Force 				= 1 -- Force applied on the object the bullet hits
SWEP.Primary.NumberOfShots 		= 7 -- How many shots per attack?
SWEP.Primary.ClipSize			= 8 -- Max amount of bullets per clip
SWEP.Primary.Cone 				= 24 -- How accurate is the bullet? (Players)
SWEP.Primary.Delay 				= 0.9 -- Time until it can shoot again
SWEP.Primary.Automatic 			= false -- Is it automatic?
SWEP.Primary.Ammo 				= "Buckshot" -- Ammo type
SWEP.Primary.Sound				= {"vj_bmce/weapons/bms_shotgun/close1.mp3"}
SWEP.Primary.HasDistantSound	= true -- Does it have a distant sound when the gun is shot?
SWEP.Primary.DistantSound		= {"vj_bmce/weapons/bms_shotgun/distant1.mp3"}
SWEP.Primary.DistantSoundLevel 	= 140 -- Distant sound level
SWEP.Primary.DistantSoundPitch1	= 90 -- Distant sound pitch 1
SWEP.Primary.DistantSoundPitch2	= 110 -- Distant sound pitch 2
SWEP.Primary.DistantSoundVolume	= 0.5 -- Distant sound volume
	-- ====== Effect Variables ====== --
SWEP.PrimaryEffects_MuzzleFlash = true
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_ShellAttachment = 2
SWEP.PrimaryEffects_ShellType = "VJ_Weapon_ShotgunShell1"
	-- Reload Settings 
SWEP.Reload_TimeUntilAmmoIsSet 	= 0.35 -- Time until ammo is set to the weapon
SWEP.Reload_TimeUntilFinished	= 0.5 -- How much time until the player can play idle animation, shoot, etc.
	-- Idle Settings 
SWEP.HasIdleAnimation			= true -- Does it have a idle animation?
SWEP.AnimTbl_Idle 				= {ACT_VM_IDLE}
SWEP.NextIdle_Deploy 			= 0.5 -- How much time until it plays the idle animation after the weapon gets deployed
SWEP.NextIdle_PrimaryAttack 	= 0.8 -- How much time until it plays the idle animation after attacking(Primary)
-- ====== Secondary Fire Variables ====== --
	SWEP.Secondary.Automatic = true -- Is it automatic?
	SWEP.Secondary.Ammo = "Buckshot" -- Ammo type
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_AfterShoot()
	timer.Simple(0.32, function()
		if IsValid(self) && IsValid(self:GetOwner()) && self:GetOwner():IsNPC() then
			self:EmitSound(Sound("vj_bmce/weapons/bms_shotgun/pump.mp3"), 80, 100)
			self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
		end
		if IsValid(self) && IsValid(self:GetOwner()) && self:GetOwner():IsPlayer() then
			self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
		end
	end)
end

if CLIENT then
	-- Make the gun move to the center when aiming
	local aimPos = Vector(-2, 0, 0)
	local aimAng = Angle(0, -3, 0)
	---------------------------------------------------------------------------------------------------------------------------------------------
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
		self.Primary.Delay = 1
		self.Primary.Cone = 32
		self.Primary.NumberOfShots = 16
		self.Primary.TakeAmmo = 2
		self.NextIdle_PrimaryAttack = 1
		self.AnimTbl_PrimaryFire = {ACT_VM_SECONDARYATTACK}
		owner:ViewPunch(Angle(-self.Primary.Recoil *24, 6, 0))
		VJ_EmitSound(self, "vj_bmce/weapons/bms_shotgun/close1.mp3", 85, math.random(65,90))
	end
	self:PrimaryAttack()
	self.Primary.Delay = 0.9
	self.Primary.Cone = 24
	self.Primary.NumberOfShots = 7
	self.Primary.TakeAmmo = 1
	self.NextIdle_PrimaryAttack = 0.8
	self.AnimTbl_PrimaryFire = {ACT_VM_PRIMARYATTACK}
	
	self:SetNextSecondaryFire(CurTime() + 1)
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