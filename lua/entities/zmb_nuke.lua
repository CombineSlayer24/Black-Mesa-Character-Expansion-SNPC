AddCSLuaFile()

ENT.Base            = "base_anim"
ENT.PrintName 		= "Nuke"
ENT.Author 			= "StarFrost"

local Rand = math.Rand
local random = math.random
local ents_FindInSphere = ents.FindInSphere
local ents_FindByClass = ents.FindByClass
local ScreenShake = util.ScreenShake
local SimpleTimer = timer.Simple

local color_green  = Color( 25, 180, 25 )

game.AddParticles("particles/bigboom.pcf")

hook.Add( "PreDrawHalos", "NukeHalo", function()
	halo.Add( ents.FindByClass( "zmb_nuke*" ), color_green, 8, 8, 5 )
end )

function ENT:Initialize()
    self:SetModel( "models/props_phx/ww2bomb.mdl" )
    self:SetMaterial("models/player/shared/gold_player")
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
    
    SimpleTimer( Rand( 0.75, 1.25 ), function()
        sound.Play( "vj_bmce_zmb/powerups/ann_nuke.SN65.pc.snd.mp3", Vector(), 0, 100, 1 )
    end )

    for k, v in ipairs( ents_FindByClass( "npc_vj_bmce_und_*" ) ) do
        SimpleTimer( Rand( 1, 4 ), function()
            if IsValid( v ) then
                v:Ignite( 5 ) 
                v:TakeDamage( v:Health(), self.GrabbedBy, self.GrabbedBy )
                v:EmitSound( "vj_bmce_zmb/powerups/pwrup_nuke_flash.mp3", 85 )
            end
        end )
    end

    for k, v in ipairs( player.GetAll() ) do
        v:ScreenFade( SCREENFADE.IN, color_white, 0.6, 0.4 )
    end
    self:EmitSound( "vj_bmce_zmb/powerups/pwrup_grab.mp3", 0 )
    self:EmitSound( "vj_bmce_zmb/powerups/pwrup_nuke_grab.mp3", 0 )
    ScreenShake( self:GetPos(), 6, 200, 6, 3000 )

    ParticleEffect("fluidSmokeExpl_ring_mvm", self:GetPos(), self:GetAngles())
    ParticleEffect("explosionTrail_seeds_mvm", self:GetPos(), self:GetAngles())
end

function ENT:Think()
    if SERVER then

        if CurTime() > self.RemoveTime then
            self:EmitSound( "vj_bmce_zmb/powerups/pwrup_despawn.mp3", 70 )
            PrintMessage(HUD_PRINTTALK, "Too slow! Nuke despawned.")
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