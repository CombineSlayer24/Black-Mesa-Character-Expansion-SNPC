/* Note: All credits go to Cpt. Hazama. I take no credit for this. */
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	local i = 0
	for k, v in ipairs(ents.GetAll()) do
		if v:GetClass() == "sent_vj_bmce_undead_ambmusic" then
			i = i + 1
			if i > 1 then PrintMessage(HUD_PRINTTALK, "ALERT: Only one Map Spawner can exist on the map.") self.SkipOnRemove = true self:Remove() v:EmitSound("plats/elevbell1.wav",100) return end
		end
	end

	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:SetPos(Vector(0, 0, 0))
	self:SetNoDraw(true)
	self:DrawShadow(false)

	for _,v in ipairs(player.GetAll()) do

		if GetConVarNumber("vj_bmce_zmb_map_spooky_snds") == 1 then
			
			timer.Create("vj_bmce_undead_mapspawn_amb_snds",math.random(8,26),0,function()
				v:EmitSound("vj_bmce_zmb/map_spawner/nz_zmb_amb_sfx/nz_zombie_protoype/amb_spooky_"..math.random(0,21)..".mp3", 45)
			end)
			
			timer.Create("vj_bmce_undead_mapspawn_amb_music",math.random(35,75),0,function()
				v:EmitSound("vj_bmce_zmb/map_spawner/nz_zmb_amb_sfx/nz_zmb_proto_amb_spooky_"..math.random(1,4)..".mp3", 45)
			end)
		
		end

		if GetConVarNumber("vj_bmce_zmb_map_music") == 1 then
			v:EmitSound("vj_bmce_zmb/map_spawner/map_tune"..math.random(1,8)..".mp3", 51)
		end

		v:ChatPrint("Something spooky is lurking about")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	timer.Remove("vj_bmce_undead_mapspawn_amb_snds")
	timer.Remove("vj_bmce_undead_mapspawn_amb_music")
end