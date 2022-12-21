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
local LNRExists = file.Exists("lua/autorun/vj_lnrhl2_autorun.lua","GAME")

if LNRExists == true then		
	if GetConVarNumber("vj_bmce_lnr_alert") == 1 then
		if CLIENT then
			hook.Add("Initialize","LNRTRUE",function()
				local vjorange = Color(255,100,0)
				local lightblue = Color(0,199,255)
				local white = Color(255,255,255)
				timer.Simple(8.0,function()
					chat.AddText(vjorange,"---------- BMCE ----------")
					chat.AddText(lightblue,"• LNR Detected!")
					chat.AddText(white,"• To disable this message, set vj_bmce_lnr_alert to 0")
					chat.AddText(vjorange,"-----------------------------")
					local dingaling_sound = CreateSound(game.GetWorld(), "vj_bmce_zmb/musicalex1.mp3")
					dingaling_sound:SetSoundLevel(0)
					dingaling_sound:Play()
				end)
			end)
		end
	end
end

// If Lethal Necrotics Reanimated: Half-Life 2 is not installed and not detected, pester the player with a message
if LNRExists == false then
	if GetConVarNumber("vj_bmce_lnr_alert") == 1 then
		if CLIENT then
			hook.Add("Initialize","LNRFALSE",function()
				local vjorange = Color(255,100,0)
				local yellow = Color(255,255,0)
				local red = Color(255,0,0)
				local white = Color(255,255,255)
				local lightblue = Color(0,199,255)
				timer.Simple(10,function()
					chat.AddText(vjorange,"---------- BMCE ----------")
					chat.AddText(yellow,"• LNR isn't Detected!")
					chat.AddText(red,"• You cannot use Undead NPCs.")
					chat.AddText(red,"• Install LNR to use Undead NPCs")
					chat.AddText(white,"• To disable this message, set vj_bmce_lnr_alert to 0")
					chat.AddText(vjorange,"-----------------------------")
					local dingaling_sound = CreateSound(game.GetWorld(), "vj_bmce_zmb/barney_wetrustedyou07.wav")
					dingaling_sound:SetSoundLevel(0)
					dingaling_sound:Play()
				end)
				timer.Simple(15,function()
					chat.AddText(vjorange,"---------- BMCE ----------")
					chat.AddText(lightblue,"•       LNR Download:")
					chat.AddText(white,"• https://steamcommunity.com/sharedfiles/filedetails/?id=1879776316")
					chat.AddText(vjorange,"-----------------------------")
					local dingaling_sound = CreateSound(game.GetWorld(), "vj_bmce_zmb/vocals/extra/slam_04.wav")
					dingaling_sound:SetSoundLevel(0)
					dingaling_sound:Play()
				end)
			end)
		end
	end
end

if VJExists == true then
	include('autorun/vj_controls.lua')

	local vCat = "BMCE - Undead"

	VJ.AddCategoryInfo(vCat, {Icon = "vgui/bms_logo.png"})

	---------- Undead ----------------------
	VJ.AddNPC("Undead Scientist (Walker)","npc_vj_bmce_und_wlk_sci_male",vCat)
	VJ.AddNPC("Undead Scientist (Bolter)","npc_vj_bmce_und_run_sci_male",vCat)

	VJ.AddNPC("Undead Casual Scientist (Walker)","npc_vj_bmce_und_wlk_sci_cas_male",vCat)
	VJ.AddNPC("Undead Casual Scientist (Bolter)","npc_vj_bmce_und_run_sci_cas_male",vCat)

	VJ.AddNPC("(Undead Map Spawner)","sent_vj_bmce_undead_mapspawner",vCat)

	VJ.AddConVar("vj_bmce_zmb_eyeglow", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
	VJ.AddConVar("vj_bmce_zmb_faster", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
	VJ.AddConVar("vj_bmce_zmb_riser", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
	VJ.AddConVar("vj_bmce_zmb_deathanim", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
	VJ.AddConVar("vj_bmce_zmb_deathrandom", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
	VJ.AddConVar("vj_bmce_zmb_deathtime_min", 45, {FCVAR_ARCHIVE})
	VJ.AddConVar("vj_bmce_zmb_deathtime_max", 90, {FCVAR_ARCHIVE})
	VJ.AddConVar("vj_bmce_lnr_alert", 1, {FCVAR_ARCHIVE})
	VJ.AddConVar("vj_bmce_zmb_map_music", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
	VJ.AddConVar("vj_bmce_zmb_map_spooky_snds", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
	VJ.AddConVar("vj_bmce_zmb_map_delete", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
------------------------------------------------------------------------------------------------------------------------------------------------------
	if CLIENT then
		hook.Add("PopulateToolMenu", "VJ_ADDTOMENU_BMCE_UNDEAD", function()
			spawnmenu.AddToolMenuOption("DrVrej", "SNPC Configures", "BMCE (Undead)", "BMCE (Undead)", "", "", function(Panel)
				if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
					Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
					Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
					return
				end
				Panel:AddControl("Header", {Description = "NOTICE!: Newly spawned SNPC's will take affect to the changes you made!"})
				Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
				Panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = ""})
				
				Panel:AddControl("Checkbox", {Label = "Eneble eyeglow for the Undead?", Command = "vj_bmce_zmb_eyeglow"})
				Panel:ControlHelp("NOTE: Having too many Undead SNPCs may lag your computer with eyeglow on.")
				
				Panel:AddControl("Checkbox", {Label = "Eneble death animations for the Undead?", Command = "vj_bmce_zmb_deathanim"})
				
				Panel:AddControl("Checkbox", {Label = "Eneble dirt spawns for the Undead?", Command = "vj_bmce_zmb_riser"})
				Panel:ControlHelp("If enabled, Undead can use the rise sapwn animation.\n\nAim at the ground of the available materials to have the zombie do the rising animation.\n\nWorks only on 'soft' materials such as Grass, Snow, Dirt, Sand and Foliage")
					
				Panel:AddControl("Checkbox", {Label = "Undead Hunters move faster", Command = "vj_bmce_zmb_faster"})
				Panel:ControlHelp("If enabled, Walkers will move at 'running' speed & Bolters will super sprint.")

				Panel:AddControl("Checkbox", {Label = "Undead Die Randomly", Command = "vj_bmce_zmb_deathrandom"})

				Panel:ControlHelp("How long an Undead will live until they'll die.")
				Panel:AddControl("Slider", {Label ="Undead Death Rand Min",Command ="vj_bmce_zmb_deathtime_min", Min = "5", Max = "120"})
				Panel:AddControl("Slider", {Label ="Undead Death Rand Max",Command ="vj_bmce_zmb_deathtime_max", Min = "5", Max = "120"})
				Panel:ControlHelp("Note: Max must be higher than Min.")

				Panel:AddControl("Header", {Description = "Undead Map Spawner Commands"})
				Panel:ControlHelp("Navigate to LNR (MapSp) to tinker settings for the Manhunt Undead Map Spawner.")
				
				Panel:AddControl("Checkbox", {Label = "Map Spawner: Enable starting music?", Command = "vj_bmce_zmb_map_music"})
				Panel:AddControl("Checkbox", {Label = "Map Spawner: Enable spooky sounds?", Command = "vj_bmce_zmb_map_spooky_snds"})
				Panel:AddControl("Checkbox", {Label = "Map Spawner: Remove all undead NPCs upon deleting Map Spawner?", Command = "vj_bmce_zmb_map_delete"})
			end)
		end)
	end

-- !!!!!! DON'T TOUCH ANYTHING BELOW THIS !!!!!! -------------------------------------------------------------------------------------------------------------------------
	AddCSLuaFile(AutorunFile)
	VJ.AddAddonProperty(AddonName,AddonType)
else
	if (CLIENT) then
		chat.AddText(Color(0,200,200),PublicAddonName,
		Color(0,255,0)," was unable to install, you are missing ",
		Color(255,100,0),"VJ Base!")
	end
	timer.Simple(1,function()
		if not VJF then
			if (CLIENT) then
				VJF = vgui.Create("DFrame")
				VJF:SetTitle("ERROR!")
				VJF:SetSize(790,560)
				VJF:SetPos((ScrW()-VJF:GetWide())/2,(ScrH()-VJF:GetTall())/2)
				VJF:MakePopup()
				VJF.Paint = function()
					draw.RoundedBox(8,0,0,VJF:GetWide(),VJF:GetTall(),Color(200,0,0,150))
				end
				
				local VJURL = vgui.Create("DHTML",VJF)
				VJURL:SetPos(VJF:GetWide()*0.005, VJF:GetTall()*0.03)
				VJURL:Dock(FILL)
				VJURL:SetAllowLua(true)
				VJURL:OpenURL("https://sites.google.com/site/vrejgaming/vjbasemissing")
			elseif (SERVER) then
				timer.Create("VJBASEMissing",5,0,function() print("VJ Base is Missing! Download it from the workshop!") end)
			end
		end
	end)
end