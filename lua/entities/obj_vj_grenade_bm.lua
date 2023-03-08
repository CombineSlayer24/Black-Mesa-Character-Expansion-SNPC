AddCSLuaFile()
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Black Mesa Launcher Grenade"
ENT.Category		= "VJ Base"

ENT.Spawnable = false
ENT.AdminOnly = false

ENT.VJ_IsDetectableDanger = true

if CLIENT then
	local Name = "BM Launcher Grenade"
	local LangName = "obj_vj_grenade_bm"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = {"models/weapons/ar2_grenade.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesRadiusDamage = true -- Should it do a blast damage when it hits something?
ENT.RadiusDamageRadius = 150 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = 125 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the enemy is from the position that the projectile hit?
ENT.RadiusDamageType = DMG_BLAST -- Damage type
ENT.RadiusDamageForce = 90 -- Put the force amount it should apply | false = Don't apply any force
ENT.DecalTbl_DeathDecals = {"Scorch"} -- Decals that paint when the projectile dies | It picks a random one from this table
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitializeBeforePhys()
	self:PhysicsInitSphere(5, "metal_bouncy")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	ParticleEffectAttach("smoke_gib_01", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	ParticleEffectAttach("Rocket_Smoke_Trail", PATTACH_ABSORIGIN_FOLLOW, self, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:Wake()
	phys:SetMass(1)
	phys:EnableGravity(true)
	phys:EnableDrag(false)
	phys:SetBuoyancyRatio(0)
	phys:AddAngleVelocity(Vector(0,math.random(300,400),0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects()
	local effectData = EffectData()

    local SoundTbl_Boom =
	{
        "vj_bmce/weapons/bm_explode1.wav",
        "vj_bmce/weapons/bm_explode2.wav",
        "vj_bmce/weapons/bm_explode3.wav"
	}

	effectData:SetOrigin(self:GetPos())
	//effectData:SetScale( 500 )
	util.Effect( "HelicopterMegaBomb", effectData )
	util.Effect( "ThumperDust", effectData )
	util.Effect( "VJ_Small_Explosion1", effectData )
    VJ_EmitSound(self, SoundTbl_Boom, 100, math.random(85,110))

	local ExplosionLight1 = ents.Create("light_dynamic")
	ExplosionLight1:SetKeyValue("brightness", "4")
	ExplosionLight1:SetKeyValue("distance", "300")
	ExplosionLight1:SetLocalPos(self:GetPos())
	ExplosionLight1:SetLocalAngles( self:GetAngles() )
	ExplosionLight1:Fire("Color", "255 150 0")
	ExplosionLight1:SetParent(self)
	ExplosionLight1:Spawn()
	ExplosionLight1:Activate()
	ExplosionLight1:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(ExplosionLight1)
	util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)
end