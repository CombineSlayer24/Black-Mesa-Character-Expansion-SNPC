if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "9MM Machine Gun"
SWEP.Author 					= "Pyri"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ BMCE"
	-- Client Settings 
if (CLIENT) then
SWEP.Slot						= 2 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6)
SWEP.SlotPos					= 1 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.SwayScale 					= 1 -- Default is 1, The scale of the viewmodel sway
SWEP.UseHands					= false
end
	-- Main Settings 
SWEP.ViewModel					= "models/weapons/viewmodels/bms/v_mp5.mdl"
SWEP.WorldModel					= "models/weapons/black_mesa_src/w_mp5.mdl"
SWEP.HoldType 					= "smg"
SWEP.ViewModelFOV				= 85 -- Player FOV for the view model
SWEP.ViewModelFlip				= false -- Flip the model? Usally used for CS:S models
SWEP.Spawnable					= true
SWEP.AdminSpawnable				= false
	-- NPC Settings 
SWEP.NPC_NextPrimaryFire 		= 2 -- Next time it can use primary fire
SWEP.NPC_TimeUntilFire	 		= 0.1 -- How much time until the bullet/projectile is fired?
SWEP.NPC_CustomSpread	 		= 1.275 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
SWEP.NPC_TimeUntilFireExtraTimers = {0.12,0.24,0.36,0.48,0.6,0.72,0.84,0.96} -- Next time it can use primary fire
SWEP.NPC_ReloadSound			= {"vj_bmce/weapons/bms_mp5/npc_reload.mp3"} -- Sounds it plays when the base detects the SNPC playing a reload animation
	-- Primary Fire 
SWEP.Primary.Damage				= 6 -- Damage
SWEP.Primary.PlayerDamage		= 15 -- Only applies for players | "Same" = Same as self.Primary.Damage, "Double" = Double the self.Primary.Damage OR put a number to be different from self.Primary.Damage
SWEP.Primary.Force				= 5 -- Force applied on the object the bullet hits
SWEP.Primary.ClipSize			= 30 -- Max amount of bullets per clip
SWEP.Primary.Recoil				= 0.5 -- How much recoil does the player get?
SWEP.Primary.Delay				= 0.095 -- Time until it can shoot again
SWEP.Primary.Automatic			= true -- Is it automatic?
SWEP.Primary.Ammo				= "SMG1" -- Ammo type
SWEP.Primary.Sound				= {"vj_bmce/weapons/bms_mp5/single1.mp3","vj_bmce/weapons/bms_mp5/single2.mp3","vj_bmce/weapons/bms_mp5/single3.mp3"}
SWEP.Primary.HasDistantSound	= true -- Does it have a distant sound when the gun is shot?
SWEP.Primary.DistantSound		= {"vj_bmce/weapons/bms_mp5/distant1.mp3"}
SWEP.Primary.DistantSoundLevel = 140 -- Distant sound level
SWEP.Primary.DistantSoundPitch1	= 90 -- Distant sound pitch 1
SWEP.Primary.DistantSoundPitch2	= 110 -- Distant sound pitch 2
SWEP.Primary.DistantSoundVolume	= 0.5 -- Distant sound volume
	-- ====== Effect Variables ====== --
SWEP.PrimaryEffects_MuzzleFlash = true
SWEP.PrimaryEffects_ShellAttachment = "ejectbrass"
SWEP.PrimaryEffects_ShellType = "VJ_Weapon_PistolShell1"
	-- Deployment Settings 
SWEP.DelayOnDeploy 				= 1 -- Time until it can shoot again after deploying the weapon
	-- Reload Settings 
SWEP.HasReloadSound				= true -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.ReloadSound				= "vj_bmce/weapons/bms_mp5/player_reload.mp3"
SWEP.Reload_TimeUntilAmmoIsSet	= 1.5 -- Time until ammo is set to the weapon
SWEP.Reload_TimeUntilFinished	= 1.5 -- How much time until the player can play idle animation, shoot, etc.
	-- ====== Secondary Fire Variables ====== --
SWEP.NPC_SecondaryFireEnt = "obj_vj_grenade_bm"
SWEP.Secondary.Automatic = false -- Is it automatic?
SWEP.Secondary.Ammo = "SMG1_Grenade" -- Ammo type

-- NPC SETTINGS for SECONDARY ATTACK
SWEP.NPC_HasSecondaryFire = true -- Can the weapon have a secondary fire?
SWEP.NPC_SecondaryFireSound = {"vj_bmce/weapons/grenade_attack.wav"} -- The sound it plays when the secondary fire is used
SWEP.NPC_SecondaryFireDistance = 2000 -- How close does the owner's enemy have to be for it to fire?
SWEP.NPC_SecondaryFireChance = 4 -- Chance that the secondary fire is used | 1 = always
SWEP.NPC_SecondaryFireNext = VJ_Set(15, 20) -- How much time until the secondary fire can be used again?
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	-- Make the gun move to the center when aiming
	local aimPos = Vector(-1, 0, 5)
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
	owner:ViewPunch(Angle(-self.Primary.Recoil *6, 0, 0))
	VJ_EmitSound(self, "vj_bmce/weapons/grenade_attack.wav", 85)

	local proj = ents.Create(self.NPC_SecondaryFireEnt)
	proj:SetPos(owner:GetShootPos())
	proj:SetAngles(owner:GetAimVector():Angle())
	proj:SetOwner(owner)
	proj:Spawn()
	proj:Activate()
	local phys = proj:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetVelocity(owner:GetAimVector() * 1250)
	end
	return true
end