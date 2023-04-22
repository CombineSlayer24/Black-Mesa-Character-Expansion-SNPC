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

surface.CreateFont("id_main_small", {
    font = "ChatFont",
    size = 24,
    extended = true,
    shadow = true,
    --outline = true,
})

surface.CreateFont("id_blur_small", {
    font = "ChatFont",
    size = 24,
    extended = true,
    blursize = 4,
    scanlines = 2,
    shadow = true,
    --outline = true,
})

local VJ_BMCE_VALIDNPCS = {
	[ "npc_vj_bmce_scientist_m" ] = true,
	[ "npc_vj_bmce_scientist_f" ] = true,
	[ "npc_vj_bmce_cw_f" ] = true,
	[ "npc_vj_bmce_cw_m" ] = true,
	[ "npc_vj_bmce_scientist_casual_m" ] = true,
	[ "npc_vj_bmce_constructw_m" ] = true,
	[ "npc_vj_bmce_custodian_m" ] = true,
	[ "npc_vj_bmce_custodian_f" ] = true,
	[ "npc_vj_bmce_secguard_m" ] = true,
	[ "npc_vj_bmce_secguard_f" ] = true,
	[ "npc_vj_bmce_secguard_capt" ] = true,
}

CreateClientConVar("vj_bmce_shownames", 1, {FCVAR_ARCHIVE}, "Should names pop up?", 0, 1)
CreateClientConVar("vj_bmce_showhealthinfo", 1, {FCVAR_ARCHIVE}, "Should NPC health info show?", 0, 3)
local FriendBlurColor = Color(50, 205, 50)
local FriendColor = Color(150, 255, 150)

local name_enable = GetConVar( "vj_bmce_shownames" )
local healthbar_cvar = GetConVar( "vj_bmce_showhealthinfo" )


local EnemyStat = false -- Check for the NPC's state with the player
-- true = enemy to ply, false = friend to ply

function NPC_Text() -- show some names
    if !name_enable:GetBool() then return end

    local tr = LocalPlayer():GetEyeTrace()
    local ent = tr.Entity

    if IsValid(ent) and ent:GetClass() then -- if a valid BMCE NPC is in the crosshair, show us their name
        local _GetClass = ent:GetClass()
		
        if VJ_BMCE_VALIDNPCS[_GetClass] then
            local nameColor, nameBlurColor
            local healthPercent = ent:Health() / ent:GetMaxHealth()
            if healthPercent >= 1 then
                nameColor, nameBlurColor = FriendColor, FriendBlurColor
            elseif healthPercent >= 0.8 then
				nameColor, nameBlurColor = FriendColor, FriendBlurColor
            elseif healthPercent >= 0.55 then
                nameColor, nameBlurColor = Color(255, 255, 0), Color(255, 255, 0, 143)
            elseif healthPercent >= 0.26 then
                nameColor, nameBlurColor = Color(255, 165, 0), Color(255, 165, 0, 143)
            else
                nameColor, nameBlurColor = Color(255, 0, 0), Color(255, 0, 0, 143)
            end
            
            draw.SimpleText(ent.PrintName, "id_blur", ScrW() * 0.5 + 40, ScrH() * 0.5, nameBlurColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(ent.PrintName, "id_main", ScrW() * 0.5 + 40, ScrH() * 0.5, nameColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			local text = string.format("Health: %d / %d", ent:Health(), ent:GetMaxHealth())
			local maxBarWidth = 175
			local minBarWidth = 100
			local barWidth = math.max(math.min(ent:GetMaxHealth() / 5, maxBarWidth), minBarWidth)
			local barHeight = 10
			local barX = ScrW() * 0.5 + 50
			local barY = ScrH() * 0.5 + 24
			local bgOffset = 2

			if healthbar_cvar:GetInt() > 0 then
				if healthbar_cvar:GetInt() == 1 or healthbar_cvar:GetInt() == 3 then
					draw.SimpleText(text, "id_blur_small", ScrW() * 0.5 + 52, ScrH() * 0.5 + 48, nameBlurColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					draw.SimpleText(text, "id_main_small", ScrW() * 0.5 + 52, ScrH() * 0.5 + 48, nameColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
				
				if healthbar_cvar:GetInt() == 2 or healthbar_cvar:GetInt() == 3 then
					draw.RoundedBox(4, barX - bgOffset, barY - bgOffset, barWidth + bgOffset * 2, barHeight + bgOffset * 2, Color(0, 0, 0, 50))
					draw.RoundedBox(4, barX, barY, barWidth * healthPercent, barHeight, nameColor)
					draw.RoundedBox(4, barX - bgOffset, barY - bgOffset, barWidth + bgOffset * 2, barHeight + bgOffset * 2, Color(0, 0, 0, 128))
				end
			end
        end
    end
end

hook.Add("HUDPaint", "NPC_HUD_MAIN", NPC_Text)