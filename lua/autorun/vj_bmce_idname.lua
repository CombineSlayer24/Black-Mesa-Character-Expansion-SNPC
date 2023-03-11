if CLIENT then -- this is needed
	surface.CreateFont("id_main", {
		font = "ChatFont",
		size = 32,
		extended = true,
		shadow = true,
		--outline = true,
	})

	surface.CreateFont("id_blur", {
		font = "ChatFont",
		size = 32,
		extended = true,
		blursize = 4,
		scanlines = 2,
		shadow = true,
		--outline = true,
	})
end

local VJ_BMCE_VALIDNPCS = {
	[ "npc_vj_bmce_scientist_m" ] = true,
	[ "npc_vj_bmce_scientist_f" ] = true,
	[ "npc_vj_bmce_cw_f" ] = true,
	[ "npc_vj_bmce_cw_m" ] = true,
	[ "npc_vj_bmce_scientist_casual_m" ] = true,
	[ "npc_vj_bmce_constructw_m" ] = true,
	[ "npc_vj_bmce_custodian_m" ] = true,
	[ "npc_vj_bmce_secguard_m" ] = true,
	[ "npc_vj_bmce_secguard_f" ] = true,
	[ "npc_vj_bmce_secguard_capt" ] = true,
}

CreateConVar("vj_bmce_shownames", 1, {FCVAR_ARCHIVE}, "Should names pop up?", 0, 1)
local FriendBlurColor = Color(50, 205, 50)
local FriendColor = Color(150, 255, 150)
local EnemyBlurColor = Color(180, 25, 25)
local EnemyColor = Color(255, 50, 50)
local lambda_color_blur = Color(255, 150, 0)
local lambda_color = Color(255, 100, 0)
local name_enable = GetConVar( "vj_bmce_shownames" )


local EnemyStat = false -- Check for the NPC's state with the player
-- true = enemy to ply, false = friend to ply

function NPC_Text() -- show some names
	if not name_enable:GetBool() then return end

	local ply = LocalPlayer()
	local tr = util.GetPlayerTrace( ply, ply:GetAimVector() )
	local trace = util.TraceLine( tr )
	local _GetClass = trace.Entity:GetClass()
	local _PrintName = trace.Entity.PrintName

	if !trace.Entity:IsValid() or trace.Entity:IsWorld() then return end

	if IsValid(trace.Entity) then -- if a valid BMCE NPC is in the crosshair, show us their name
		if VJ_BMCE_VALIDNPCS[ _GetClass ] then

			draw.SimpleText( _PrintName , "id_blur", ScrW() * 0.5 + 40, ScrH() * 0.5, FriendBlurColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( _PrintName , "id_main", ScrW() * 0.5 + 40, ScrH() * 0.5, FriendColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
	end
end

hook.Add("HUDPaint", "NPC_HUD_MAIN", NPC_Text)
