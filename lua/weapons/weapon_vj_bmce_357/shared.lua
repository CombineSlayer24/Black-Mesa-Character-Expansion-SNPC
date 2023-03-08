if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= ".357 Revolver"
SWEP.Author 					= "Pyri"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ BMCE"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
SWEP.Slot						= 1 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6)
SWEP.SlotPos					= 2 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.SwayScale 					= 1 -- Default is 1, The scale of the viewmodel sway
SWEP.UseHands					= true
end
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel					= "models/weapons/viewmodels/bms/v_357.mdl"
SWEP.WorldModel					= "models/weapons/black_mesa_src/w_357b.mdl"
SWEP.WorldModel_UseCustomPosition = true -- Should the gun use custom position? This can be used to fix guns that are in the crotch
SWEP.WorldModel_CustomPositionAngle = Vector(-8, 90, 180)
SWEP.WorldModel_CustomPositionOrigin = Vector(-3.4, -1, -0.5)
SWEP.HoldType 					= "pistol"
SWEP.ViewModelFOV				= 74 -- Player FOV for the view model
SWEP.ViewModelFlip				= false -- Flip the model? Usally used for CS:S models
SWEP.Spawnable					= true
SWEP.AdminSpawnable				= false
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire 		= 5 -- Next time it can use primary fire
SWEP.NPC_TimeUntilFire	 		= 0.1 -- How much time until the bullet/projectile is fired?
SWEP.NPC_TimeUntilFireExtraTimers = {1.25,2.5} -- Next time it can use primary fire
SWEP.NPC_CustomSpread	 		= 1.25 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
SWEP.NPC_ReloadSound			= {"vj_bmce/weapons/bmce_357/reload_npc.mp3"} -- Sounds it plays when the base detects the SNPC playing a reload animation
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 24 -- Damage
SWEP.Primary.PlayerDamage		= 32 -- Only applies for players | "Same" = Same as self.Primary.Damage, "Double" = Double the self.Primary.Damage OR put a number to be different from self.Primary.Damage
SWEP.Primary.Force				= 2 -- Force applied on the object the bullet hits
SWEP.Primary.ClipSize			= 6 -- Max amount of bullets per clip
SWEP.Primary.Recoil				= 0.8 -- How much recoil does the player get?
SWEP.Primary.Delay				= 0.75 -- Time until it can shoot again
SWEP.Primary.Automatic			= true -- Is it automatic?
SWEP.Primary.Ammo				= "357" -- Ammo type
SWEP.Primary.Sound				= {"vj_bmce/weapons/bmce_357/single.mp3"}
SWEP.Primary.HasDistantSound	= true -- Does it have a distant sound when the gun is shot?
SWEP.Primary.DistantSound		= {"vj_bmce/weapons/bmce_357/single_npc.mp3"}
SWEP.Primary.DistantSoundLevel = 140 -- Distant sound level
SWEP.Primary.DistantSoundPitch1	= 90 -- Distant sound pitch 1
SWEP.Primary.DistantSoundPitch2	= 110 -- Distant sound pitch 2
SWEP.Primary.DistantSoundVolume	= 0.6 -- Distant sound volume

	-- ====== Effect Variables ====== --
SWEP.PrimaryEffects_MuzzleFlash = true
SWEP.PrimaryEffects_ShellAttachment = "ejectbrass"
SWEP.PrimaryEffects_ShellType = "VJ_Weapon_PistolShell1"
	-- Deployment Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.DelayOnDeploy 				= 1 -- Time until it can shoot again after deploying the weapon
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound				= true -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.ReloadSound				= "vj_bmce/weapons/bmce_357/reload.mp3"
SWEP.Reload_TimeUntilAmmoIsSet	= 3.35 -- Time until ammo is set to the weapon
SWEP.Reload_TimeUntilFinished	= 3.75 -- How much time until the player can play idle animation, shoot, etc.
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	-- Make the gun move to the center when aiming
	local aimPos = Vector(0, 1, 0)
	local aimAng = Angle(0, 0, 0)
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