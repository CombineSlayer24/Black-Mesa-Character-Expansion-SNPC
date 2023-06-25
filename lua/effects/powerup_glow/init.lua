-- Credit goes to Zet0r (NZombies) for the powerup effect.
function EFFECT:Init( data )
	
	local vOffset = data:GetOrigin()
	
	local NumParticles = 1
	
	local emitter = ParticleEmitter( vOffset )
	
		for i=0, NumParticles do
		
			local particle = emitter:Add( "sprites/physg_glow1", vOffset )
			if (particle) then
				
				particle:SetVelocity( Vector(0,0,0) )
				particle:SetColor(25, 180, 25)
				
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 0.3 )
				
				particle:SetStartAlpha( 100 )
				particle:SetEndAlpha( 0 )
				
				particle:SetStartSize( 50 )
				particle:SetEndSize( 50 )
				
				particle:SetRoll( math.Rand(0, 36)*10 )
				
				particle:SetAirResistance( 400 )
				
				particle:SetGravity( Vector( 0, 0, 0 ) )
			end
		end
	emitter:Finish()
end


--[[---------------------------------------------------------
   THINK
-----------------------------------------------------------]]
function EFFECT:Think( )
	return false
end

--[[---------------------------------------------------------
   Draw the effect
-----------------------------------------------------------]]
function EFFECT:Render()
end