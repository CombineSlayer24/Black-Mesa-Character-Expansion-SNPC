if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= ".40 Beretta"
SWEP.Author 					= "Pyri"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ BMCE"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
SWEP.Slot						= 1 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos					= 1 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.SwayScale 					= 2 -- Default is 1, The scale of the viewmodel sway
SWEP.UseHands 				= false
end
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire 		= 3.2 -- Next time it can use primary fire
SWEP.NPC_TimeUntilFire	 		= 0.1 -- How much time until the bullet/projectile is fired?
SWEP.NPC_TimeUntilFireExtraTimers = {0.4,0.8,1.2,1.6} -- Next time it can use primary fire
SWEP.NPC_CustomSpread	 		= 0.75 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
SWEP.NPC_ReloadSound			= {"vj_weapons/bmce_m9/reload.mp3"} -- Sounds it plays when the base detects the SNPC playing a reload animation
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel					= "models/weapons/viewmodels/bmce/v_glock.mdl"
SWEP.WorldModel					= "models/weapons/bmce_weapons/bmce_m9/w_glock.mdl"
SWEP.HoldType 					= "pistol"
SWEP.ViewModelFOV				= 85 -- Player FOV for the view model
SWEP.Spawnable					= true
SWEP.AdminSpawnable				= false
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.AllowFireInWater	= true -- If true, you will be able to use primary fire in water
SWEP.Primary.Damage				= 14 -- Damage
SWEP.Primary.PlayerDamage		= 14 -- Only applies for players | "Same" = Same as self.Primary.Damage, "Double" = Double the self.Primary.Damage OR put a number to be different from self.Primary.Damage
SWEP.Primary.Force				= 5 -- Force applied on the object the bullet hits
SWEP.Primary.ClipSize			= 15 -- Max amount of bullets per clip
SWEP.Primary.Recoil				= 0.3 -- How much recoil does the player get?
SWEP.Primary.Cone				= 5 -- How accurate is the bullet? (Players)
SWEP.Primary.Delay				= 0.28 -- Time until it can shoot again
SWEP.Primary.Automatic			= true -- Is it automatic?
SWEP.Primary.Ammo				= "Pistol" -- Ammo type
SWEP.Primary.Sound				= {"vj_bmce/weapons/bmce_m9/close.mp3"}
SWEP.Primary.HasDistantSound	= true -- Does it have a distant sound when the gun is shot?
SWEP.Primary.DistantSound		= {"vj_bmce/weapons/bmce_m9/distant.mp3"}
SWEP.Primary.DistantSoundLevel = 140 -- Distant sound level
SWEP.Primary.DistantSoundPitch1	= 90 -- Distant sound pitch 1
SWEP.Primary.DistantSoundPitch2	= 110 -- Distant sound pitch 2
SWEP.Primary.DistantSoundVolume	= 0.75 -- Distant sound volume
	-- ====== Effect Variables ====== --
SWEP.PrimaryEffects_MuzzleFlash = true
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_ShellAttachment = "ejectbrass"
SWEP.PrimaryEffects_ShellType = "VJ_Weapon_PistolShell1"
	-- Deployment Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.DelayOnDeploy 				= 0.4 -- Time until it can shoot again after deploying the weapon
SWEP.AnimTbl_Deploy				= {ACT_VM_IDLE_TO_LOWERED}
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound				= true -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.ReloadSound				= "vj_bmce/weapons/bmce_m9/reload_player.mp3"
SWEP.Reload_TimeUntilAmmoIsSet	= 1.5 -- Time until ammo is set to the weapon
SWEP.Reload_TimeUntilFinished	= 2 -- How much time until the player can play idle animation, shoot, etc.
	-- Idle Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasIdleAnimation			= true -- Does it have a idle animation?
SWEP.AnimTbl_Idle				= {ACT_VM_IDLE}
SWEP.NextIdle_Deploy			= 0.5 -- How much time until it plays the idle animation after the weapon gets deployed
SWEP.NextIdle_PrimaryAttack		= 0.1 -- How much time until it plays the idle animation after attacking(Primary)


SWEP.Secondary.Automatic = true -- Is it automatic?
SWEP.Secondary.Ammo = "Pistol" -- Ammo type

function SWEP:CustomOnSecondaryAttack()
	self.Primary.Delay = 0.22
	self.Primary.Cone = 20
	self:PrimaryAttack()
	self.Primary.Delay = 0.28
	self.Primary.Cone = 5
	
	self:SetNextSecondaryFire(CurTime() + 0.22)
	return false
end