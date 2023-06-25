/*--------------------------------------------------
	=============== Autorun File ===============
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
------------------ Addon Information ------------------
local PublicAddonName = "Black Mesa Character Expansion SNPCs"
local AddonName = "Black Mesa Character Expansion - Undead (ADDON)"
local AddonType = "SNPC"
local AutorunFile = "autorun/vj_bmce_autorun.lua"
-------------------------------------------------------
local VJExists = file.Exists("lua/autorun/vj_base_autorun.lua","GAME")
include("autorun/music.lua")

local speedOptions = {
	["[0] Walking Speed"] = {vj_bmce_zmb_speed = "0"},
	["[1] Running Speed"] = {vj_bmce_zmb_speed = "1"},
	["[2] Sprinting Speed"] = {vj_bmce_zmb_speed = "2"},
	["[3] Super Sprinting Speed"] = {vj_bmce_zmb_speed = "3"},
	["[4] Random Speed (Fair)"] = {vj_bmce_zmb_speed = "4"},
	["[5] Random Speed (Unfair)"] = {vj_bmce_zmb_speed = "5"}
}

local voiceSet = {
	["[0] RDR: Undead Nightmares"] = {vj_bmce_zmb_voiceset = "0"},
	["[1] World At War"] = {vj_bmce_zmb_voiceset = "1"},
	["[2] Black Ops 3"] = {vj_bmce_zmb_voiceset = "2"},
	["[3] Cold War"] = {vj_bmce_zmb_voiceset = "3"},
	["[4] Random"] = {vj_bmce_zmb_voiceset = "4"},
	--["[4] WWII Zombies"] = {vj_bmce_zmb_voiceset = "4"},
	--["[5] Random"] = {vj_bmce_zmb_voiceset = "5"}
}

if VJExists == true then
	include('autorun/vj_controls.lua')
	local vCat = "Black Mesa | CE - Undead"

	VJ.AddCategoryInfo(vCat, {Icon = "vgui/bms_logo.png"})

	VJ.BMCER_UNDEAD_INSTALLED = file.Exists("lua/autorun/vj_bmcer_undead_autorun.lua","GAME")

	---------- Undead ----------------------
	VJ.AddNPC( "Undead Scientist", "npc_vj_bmce_und_sci_male", vCat )
	VJ.AddNPC( "Undead Casual Scientist", "npc_vj_bmce_und_sci_cas_male", vCat )
	VJ.AddNPC( "Undead Office Worker Female", "npc_vj_bmce_und_offworker_fem", vCat )
	VJ.AddNPC( "Undead Construction Worker", "npc_vj_bmce_und_constwrk", vCat )
	VJ.AddNPC( "Undead Custodian Male", "npc_vj_bmce_und_custodian_male", vCat )

	VJ.AddNPC( "Undead Canteen Worker Female", "npc_vj_bmce_und_cw_fem", vCat )
	VJ.AddNPC( "Undead Canteen Worker Male", "npc_vj_bmce_und_cw_male", vCat )
	
	VJ.AddNPC( "Undead FireFighter", "npc_vj_bmce_und_fireman", vCat )
	VJ.AddNPC( "Undead Guard Male", "npc_vj_bmce_und_guard_male", vCat )
	VJ.AddNPC( "Undead Guard Female", "npc_vj_bmce_und_guard_fem", vCat )
	VJ.AddNPC( "Undead Marine", "npc_vj_bmce_und_hgrunt_male", vCat )
	VJ.AddNPC( "Undead Maintenance Worker", "npc_vj_bmce_und_cwork_male", vCat )

	VJ.AddNPC( "(Undead Map Spawner)", "sent_vj_bmce_undead_mapspawner", vCat )
	VJ.AddNPC( "(Ambient Music SFX)", "sent_vj_bmce_undead_ambmusic", vCat )
	VJ.AddNPC( "Random Undead", "sent_vj_random_zombie", vCat )

	VJ.AddConVar( "vj_bmce_zmb_eyeglow", 1, {FCVAR_ARCHIVE} )
	VJ.AddConVar( "vj_bmce_zmb_specialeyecolors", 1, {FCVAR_ARCHIVE} )
	VJ.AddConVar( "vj_bmce_zmb_eyeglow_lighter", 0, {FCVAR_ARCHIVE} )
	--VJ.AddConVar( "vj_bmce_zmb_glowtrail", 0, {FCVAR_ARCHIVE} )
	VJ.AddConVar( "vj_bmce_zmb_noisy", 0, {FCVAR_ARCHIVE} )
	VJ.AddConVar( "vj_bmce_zmb_speed", 4, {FCVAR_ARCHIVE} )
	VJ.AddConVar( "vj_bmce_zmb_riser", 1, {FCVAR_ARCHIVE} )
	VJ.AddConVar( "vj_bmce_zmb_deathrandom", 1, {FCVAR_ARCHIVE} )
	VJ.AddConVar( "vj_bmce_zmb_deathtime_min", 45, {FCVAR_ARCHIVE} )
	VJ.AddConVar( "vj_bmce_zmb_deathtime_max", 90, {FCVAR_ARCHIVE} )
	VJ.AddConVar( "vj_bmce_zmb_map_music", 1, {FCVAR_ARCHIVE} )
	VJ.AddConVar( "vj_bmce_zmb_map_spooky_snds", 1, {FCVAR_ARCHIVE} )
	VJ.AddConVar( "vj_bmce_zmb_map_delete", 1, {FCVAR_ARCHIVE} )
	VJ.AddConVar( "vj_bmce_zmb_bruisers", 1, {FCVAR_ARCHIVE} )
	VJ.AddConVar( "vj_bmce_zmb_powerups", 1, {FCVAR_ARCHIVE} )
	VJ.AddConVar( "vj_bmce_zmb_burnparticles", 0, {FCVAR_ARCHIVE} )
	VJ.AddConVar( "vj_bmce_zmb_explode", 1, {FCVAR_ARCHIVE} )
	VJ.AddConVar( "vj_bmce_zmb_voiceset", 0, {FCVAR_ARCHIVE} )
	VJ.AddConVar( "vj_bmce_zmb_spawnamount", 1, {FCVAR_ARCHIVE} )
	VJ.AddConVar( "vj_bmce_zmb_spawnradius", 1000, {FCVAR_ARCHIVE} )

	util.PrecacheModel("models/undead/scientist.mdl")
	util.PrecacheModel("models/undead/scientist_02.mdl")
	util.PrecacheModel("models/undead/scientist_burned.mdl")
	util.PrecacheModel("models/undead/scientist_casual.mdl")
	util.PrecacheModel("models/undead/scientist_casual_02.mdl")
	util.PrecacheModel("models/undead/guard.mdl")
	util.PrecacheModel("models/undead/guard_02.mdl")
	util.PrecacheModel("models/undead/guard_03.mdl")
	util.PrecacheModel("models/undead/guard_burned.mdl")
	util.PrecacheModel("models/undead/guard_female.mdl")
	util.PrecacheModel("models/undead/fem_office_worker.mdl")
	util.PrecacheModel("models/undead/cafeteria_female.mdl")
	util.PrecacheModel("models/undead/cafeteria_male_02.mdl")
	util.PrecacheModel("models/undead/custodian.mdl")
	util.PrecacheModel("models/undead/construction_worker.mdl")
	util.PrecacheModel("models/undead/fireman.mdl")
	util.PrecacheModel("models/undead/marine.mdl")
	util.PrecacheModel("models/undead/marine_02.mdl")
------------------------------------------------------------------------------------------------------------------------------------------------------
	if CLIENT then
		hook.Add("PopulateToolMenu", "VJ_ADDTOMENU_BMCE_UNDEAD", function()
			spawnmenu.AddToolMenuOption("DrVrej", "SNPC Configures", "BMCE (Undead)", "BMCE (Undead)", "", "", function(Panel)
				if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
					Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
					Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
					return
				end

				Panel:AddControl("Header", {Description = "Note: Newly spawned SNPC's will take affect to the changes you made!"})
				Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
				Panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = ""})

				Panel:AddControl("Checkbox", {Label = "Enable eyeglow for Undead?", Command = "vj_bmce_zmb_eyeglow"})
				Panel:AddControl("Checkbox", {Label = "Enable different eye colors for Undead?", Command = "vj_bmce_zmb_specialeyecolors"})

				--Panel:AddControl("Checkbox", {Label = "Enable eye glow trail for Undead?", Command = "vj_bmce_zmb_glowtrail"})
				--Panel:ControlHelp("Please be aware that having too many Undead SNPCs with glow trails enabled may cause performance issues.")

				Panel:AddControl("Checkbox", {Label = "Different Eyeglow texture", Command = "vj_bmce_zmb_eyeglow_lighter"})
				Panel:ControlHelp("IF checked, use a lighter eye glow texture.")

				Panel:AddControl("Slider", {Label = "Undead Burning Particles", Command ="vj_bmce_zmb_burnparticles", Min = "0", Max = "2"})
				Panel:ControlHelp("If enabled, burnt undead will have particles following them. NOTE: Having too many will lag your computer.\n\n0 = Disabled\n1 = Fire + Smoke\n2 = Smoke only")
				
				Panel:AddControl("Checkbox", {Label = "Burning undead explode on death?", Command = "vj_bmce_zmb_explode"})

				Panel:AddControl("Checkbox", {Label = "Enable ground spawn animation?", Command = "vj_bmce_zmb_riser"})
				Panel:ControlHelp("If enabled, Undead will play a spawning animation when they rise from the ground, only applies to 'soft surfaces' like grass, gravel. This feature can add a new layer of 'immersion'.")
					
				Panel:AddControl("ComboBox", {Label = "Movement Speed", Options = speedOptions, Command = "vj_bmce_zmb_speed"})
				Panel:AddControl("ComboBox", {Label = "Voice Set", Options = voiceSet, Command = "vj_bmce_zmb_voiceset"})

				Panel:AddControl("Checkbox", {Label = "Undead Die Randomly", Command = "vj_bmce_zmb_deathrandom"})

				Panel:ControlHelp( "How long an Undead will live until they die." )
				Panel:AddControl( "Slider", { Label ="Undead Death Rand Min", Command = "vj_bmce_zmb_deathtime_min", Min = "5", Max = "120" } )
				Panel:AddControl( "Slider", { Label ="Undead Death Rand Max", Command = "vj_bmce_zmb_deathtime_max", Min = "5", Max = "120" } )
				Panel:ControlHelp( "Note: Max must be higher than Min." )

				Panel:AddControl( "Checkbox", { Label = "Enable Undead Bruiser chance?", Command = "vj_bmce_zmb_bruisers" } )
				Panel:ControlHelp( "If enabled, Undead may have a chance to be a Brusier. Only applies to certain Undead." )

				Panel:AddControl("Header", {Description = "Undead Map Spawner Commands"})
				Panel:ControlHelp("Navigate to LNR (MapSp) to tinker settings for the Manhunt Undead Map Spawner.")

				Panel:AddControl("Checkbox", {Label = "Map Spawner: Enable starting music?", Command = "vj_bmce_zmb_map_music"})
				Panel:AddControl("Checkbox", {Label = "Map Spawner: Enable spooky sounds?", Command = "vj_bmce_zmb_map_spooky_snds"})
				Panel:AddControl("Checkbox", {Label = "Map Spawner: Remove all undead NPCs upon deleting Map Spawner?", Command = "vj_bmce_zmb_map_delete"})

				Panel:AddControl( "Checkbox", { Label = "Enable Powerups?", Command = "vj_bmce_zmb_powerups" } )
				Panel:ControlHelp( "If enabled, Undead may have a chance to drop powerups." )
			end)
		end)
	end
-- !!!!!! DON'T TOUCH ANYTHING BELOW THIS !!!!!! -------------------------------------------------------------------------------------------------------------------------
	AddCSLuaFile(AutorunFile)
	VJ.AddAddonProperty(AddonName,AddonType)
else
	if CLIENT then
		chat.AddText(Color(0, 200, 200), PublicAddonName,
		Color(0, 255, 0), " was unable to install, you are missing ",
		Color(255, 100, 0), "VJ Base!")
	end
	
	timer.Simple(1, function()
		if not VJBASE_ERROR_MISSING then
			VJBASE_ERROR_MISSING = true
			if CLIENT then
				// Get rid of old error messages from addons running on older code...
				if VJF && type(VJF) == "Panel" then
					VJF:Close()
				end
				VJF = true
				
				local frame = vgui.Create("DFrame")
				frame:SetSize(600, 160)
				frame:SetPos((ScrW() - frame:GetWide()) / 2, (ScrH() - frame:GetTall()) / 2)
				frame:SetTitle("Error: VJ Base is missing!")
				frame:SetBackgroundBlur(true)
				frame:MakePopup()
	
				local labelTitle = vgui.Create("DLabel", frame)
				labelTitle:SetPos(250, 30)
				labelTitle:SetText("VJ BASE IS MISSING!")
				labelTitle:SetTextColor(Color(255,128,128))
				labelTitle:SizeToContents()
				
				local label1 = vgui.Create("DLabel", frame)
				label1:SetPos(170, 50)
				label1:SetText("Garry's Mod was unable to find VJ Base in your files!")
				label1:SizeToContents()
				
				local label2 = vgui.Create("DLabel", frame)
				label2:SetPos(10, 70)
				label2:SetText("You have an addon installed that requires VJ Base but VJ Base is missing. To install VJ Base, click on the link below. Once\n                                                   installed, make sure it is enabled and then restart your game.")
				label2:SizeToContents()
				
				local link = vgui.Create("DLabelURL", frame)
				link:SetSize(300, 20)
				link:SetPos(195, 100)
				link:SetText("VJ_Base_Download_Link_(Steam_Workshop)")
				link:SetURL("https://steamcommunity.com/sharedfiles/filedetails/?id=131759821")
				
				local buttonClose = vgui.Create("DButton", frame)
				buttonClose:SetText("CLOSE")
				buttonClose:SetPos(260, 120)
				buttonClose:SetSize(80, 35)
				buttonClose.DoClick = function()
					frame:Close()
				end
			elseif (SERVER) then
				VJF = true
				timer.Remove("VJBASEMissing")
				timer.Create("VJBASE_ERROR_CONFLICT", 5, 0, function()
					print("VJ Base is missing! Download it from the Steam Workshop! Link: https://steamcommunity.com/sharedfiles/filedetails/?id=131759821")
				end)
			end
		end
	end)
end

local entsList = {
	"npc_vj_bmce_und_cw_fem",
	"npc_vj_bmce_und_cw_male",
	"npc_vj_bmce_und_sci_cas_male",
	"npc_vj_bmce_und_constwrk",
	"npc_vj_bmce_und_custodian_male",
	"npc_vj_bmce_und_fireman",
	"npc_vj_bmce_und_guard_fem",
	"npc_vj_bmce_und_guard_male",
	"npc_vj_bmce_und_hgrunt_male",
	"npc_vj_bmce_und_offworker_fem",
	"npc_vj_bmce_und_sci_male",
	"npc_vj_bmce_und_cwork_male",
}
local function GetNavAreasNear(pos, radius)
    local navareas = navmesh.GetAllNavAreas()
    local foundareas = {}

    local playerZ = pos.z

    for i = 1, #navareas do
        local nav = navareas[i]
        if IsValid(nav) and nav:GetSizeX() > 40 and nav:GetSizeY() > 40 and not nav:IsUnderwater() and
           (pos:DistToSqr(nav:GetClosestPointOnArea(pos)) < (radius * radius) and
           pos:DistToSqr(nav:GetClosestPointOnArea(pos)) > ((radius / 3) * (radius / 3)) and
           nav:GetCenter().z >= playerZ - 40 and nav:GetCenter().z <= playerZ + 40) then
            foundareas[#foundareas + 1] = nav
        end
    end

    return foundareas
end

--[[ local function GetNavAreasNear( pos, radius )
	local navareas = navmesh.GetAllNavAreas()
	local foundareas = {}

	for i = 1, #navareas do
		local nav = navareas[ i ]
		if IsValid( nav ) and nav:GetSizeX() > 100 and nav:GetSizeY() > 100 and !nav:IsUnderwater() and ( pos:DistToSqr( nav:GetClosestPointOnArea( pos ) ) < ( radius * radius ) and pos:DistToSqr( nav:GetClosestPointOnArea( pos ) ) > ( ( radius / 3 ) * ( radius / 3 ) ) )  then 
			foundareas[ #foundareas + 1 ] = nav 
		end
	end

	return foundareas
end ]]


local function SpawnNPC(pos, class, caller)
    local plyradius = GetConVar("vj_bmce_zmb_spawnradius")
    if not IsValid(caller) then return end
    
    if not pos then
        local areas = GetNavAreasNear(caller:GetPos(), plyradius:GetInt())
        local area = areas[math.random(#areas)]
        if not IsValid(area) then return end
        
        -- Calculate the center of the navmesh area
        local center = area:GetCenter()
        
        -- Calculate the width and height of the navmesh area
        local width = area:GetSizeX()
        local height = area:GetSizeY()
        
        -- Set the max offset based on the size of the navmesh area
        local maxOffset = width <= 40 and height <= 40 and 1 or 15
        
        -- Randomize X and Y components, keep Z at 0
        local xyOffset = VectorRand() * maxOffset
        xyOffset.z = 25
        pos = center + xyOffset
    end

    local npc = ents.Create(class)
    npc:SetPos(pos)
    npc:SetAngles(Angle(0, math.random(-180, 180), 0))
    npc:Spawn()

   -- local entIndex = npc:EntIndex()
    local effect = EffectData()
    effect:SetEntity(npc)
    util.Effect("propspawn", effect)

    undo.Create("NPC (" .. class .. ")")
    undo.SetPlayer(caller)
    undo.SetCustomUndoText("Undone " .. "NPC (" .. class .. ")")
    undo.AddEntity(npc)
    undo.Finish("NPC (" .. class .. ")")

    return npc
end

local function SpawnRandomZombie(caller)
    local npcs = entsList

    local numSpawns = GetConVar( "vj_bmce_zmb_spawnamount" ):GetInt()
    for i = 1, numSpawns do
        SpawnNPC( nil, npcs[ math.random( #npcs ) ], caller )
    end
end

concommand.Add( "vj_bmce_spawnzmb", SpawnRandomZombie, nil, "Spawn a Zombie at a random Navmesh area")

local function DrawZombieCount()
	local count = 0
	local color = Color(0, 255, 0) -- Placeholder "default" local color

	for _, ent in pairs(ents.FindByClass("npc_vj_bmce_und_*")) do
		if ent:IsNPC() and ent:GetMoveType() == MOVETYPE_STEP then
			count = count + 1
		end
	end

	if count >= 1 and count <= 6 then
		color = Color(0, 255, 0) -- Green
	elseif count >= 7 and count <= 11 then
		color = Color(255, 255, 0) -- Yellow
	elseif count >= 12 and count <= 15 then
		color = Color(255, 0, 0) -- Red
	elseif count >= 16 then
		color = Color(128, 0, 0) -- Darker red
	else
		color = Color(255, 255, 255)
	end
	
	if count > 0 then
		draw.SimpleTextOutlined("Total Zombies Alive: " .. count, "DermaLarge", ScrW() / 2, 42, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
	else
		draw.SimpleTextOutlined("Total Zombies Alive:", "DermaLarge", ScrW() / 2, 42, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
	end
end

--hook.Add("HUDPaint", "DrawZombieCount", DrawZombieCount)