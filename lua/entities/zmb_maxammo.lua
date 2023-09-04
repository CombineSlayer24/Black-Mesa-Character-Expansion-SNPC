AddCSLuaFile()

ENT.Base            = "base_anim"
ENT.PrintName 		= "Max Ammo"
ENT.Author 			= "StarFrost"

local Rand = math.Rand
local random = math.random
local ents_FindInSphere = ents.FindInSphere
local ents_FindByClass = ents.FindByClass
local ScreenShake = util.ScreenShake
local SimpleTimer = timer.Simple

local color_green  = Color( 25, 180, 25 )

hook.Add( "PreDrawHalos", "MaxAmmoHalo", function()
	halo.Add( ents.FindByClass( "zmb_maxammo*" ), color_green, 8, 8, 5 )
end )

function ENT:Initialize()
    self:SetModel( "models/Items/BoxSRounds.mdl" )
    self:SetMaterial("models/player/shared/gold_player")

    self:SetModelScale( 1.25, 0 )
    self:EmitSound( "vj_bmce_zmb/powerups/pwrup_spawn.mp3", 100)
    self:EmitSound( "vj_bmce_zmb/powerups/pwrup_loop.wav", 70 )
    self.RemoveTime = CurTime() + 20
    self.NextParticle = CurTime()

    if CLIENT then
        self.NextAngleLerp = AngleRand( -180, 180)
        self.NextAngleSys = SysTime() + Rand( 1, 3)
    end
end

function ENT:OnRemove()
    self:StopSound( "vj_bmce_zmb/powerups/pwrup_loop.wav" )
end

function ENT:OnGrab()
    if self.Grabbed then return end
    
    SimpleTimer( 0.3, function()
        sound.Play( "vj_bmce_zmb/powerups/pwrup_maxammo_grab.mp3", Vector(), 0, 100, 1 )
    end )

    --SimpleTimer( 0.8, function()
      --  sound.Play( "vj_bmce_zmb/powerups/ann_maxammo.SN65.pc.snd.mp3", Vector(), 0, 100, 1 )
    --end )

    self:EmitSound( "vj_bmce_zmb/powerups/pwrup_grab.mp3", 0 )

    for _, ply in pairs(player.GetAll()) do
        for _, weapon in pairs(ply:GetWeapons()) do
            local clipSize = weapon:GetMaxClip1()
            local ammoType = weapon:GetPrimaryAmmoType()
            if ammoType != -1 then
                local ammoToAdd = math.floor(clipSize * 3)
                ply:GiveAmmo(ammoToAdd, ammoType)
            end
        end
    end

    PrintMessage(HUD_PRINTCENTER, "Ammo grabbed!")
end

function ENT:Think()
    if SERVER then
        if CurTime() > self.RemoveTime then
            self:EmitSound( "vj_bmce_zmb/powerups/pwrup_despawn.mp3", 70 )
            PrintMessage(HUD_PRINTTALK, "Too slow! Max Ammo despawned.")
            self:Remove()
        end

        local nearby = ents_FindInSphere( self:GetPos(), 50 )

        for k, v in ipairs( nearby ) do
            if IsValid( v ) and v:IsPlayer() then
                self.GrabbedBy = v
                self:OnGrab()
                self.Grabbed = true
                self:Remove()
                break
            end
        end
    end
end

function ENT:Draw()
    self:DrawModel()

    if SysTime() > self.NextAngleSys then
        self.NextAngleLerp = AngleRand( -180, 180)

        self.NextAngleSys = SysTime() + Rand( 1, 3)
    end

    self:SetAngles( LerpAngle( 1 * FrameTime(), self:GetAngles(), self.NextAngleLerp ) )

    if CurTime() > self.NextParticle then
        local effectdata = EffectData()
        effectdata:SetOrigin( self:GetPos() )
        util.Effect( "powerup_glow", effectdata )
        self.NextParticle = CurTime() + 0.1
    end
    self:DrawModel()
end


