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

if VJExists == true then
	include('autorun/vj_controls.lua')
	local vCat = "Black Mesa | CE - Undead"

	VJ.AddCategoryInfo(vCat, {Icon = "vgui/bms_logo.png"})

	---------- Undead ----------------------
	VJ.AddNPC("Undead Scientist (Walker)","npc_vj_bmce_und_wlk_sci_male",vCat)
	VJ.AddNPC("Undead Scientist (Bolter)","npc_vj_bmce_und_run_sci_male",vCat)

	VJ.AddNPC("Undead Casual Scientist (Walker)","npc_vj_bmce_und_wlk_sci_cas_male",vCat)
	VJ.AddNPC("Undead Casual Scientist (Bolter)","npc_vj_bmce_und_run_sci_cas_male",vCat)

	VJ.AddNPC("Undead Guard (Walker)","npc_vj_bmce_und_wlk_guard",vCat)
	VJ.AddNPC("Undead Guard (Bolter)","npc_vj_bmce_und_run_guard",vCat)

	VJ.AddNPC("Undead Female Guard (Walker)","npc_vj_bmce_und_wlk_guardfem",vCat)
	VJ.AddNPC("Undead Female Guard (Bolter)","npc_vj_bmce_und_run_guardfem",vCat)

	VJ.AddNPC("Undead Female Office Worker (Walker)","npc_vj_bmce_und_wlk_femoffworker",vCat)
	VJ.AddNPC("Undead Female Office Worker (Bolter)","npc_vj_bmce_und_run_femoffworker",vCat)

	VJ.AddNPC("Undead Construction Worker (Walker)","npc_vj_bmce_und_wlk_constwrk",vCat)
	VJ.AddNPC("Undead Construction Worker (Bolter)","npc_vj_bmce_und_run_constwrk",vCat)

	VJ.AddNPC("(Undead Map Spawner)","sent_vj_bmce_undead_mapspawner",vCat)

	VJ.AddConVar("vj_bmce_zmb_eyeglow", 1, {FCVAR_ARCHIVE})
	VJ.AddConVar("vj_bmce_zmb_faster", 0, {FCVAR_ARCHIVE})
	VJ.AddConVar("vj_bmce_zmb_riser", 1, {FCVAR_ARCHIVE})
	VJ.AddConVar("vj_bmce_zmb_deathanim", 1, {FCVAR_ARCHIVE})
	VJ.AddConVar("vj_bmce_zmb_deathrandom", 1, {FCVAR_ARCHIVE})
	VJ.AddConVar("vj_bmce_zmb_deathtime_min", 45, {FCVAR_ARCHIVE})
	VJ.AddConVar("vj_bmce_zmb_deathtime_max", 90, {FCVAR_ARCHIVE})
	VJ.AddConVar("vj_bmce_zmb_map_music", 1, {FCVAR_ARCHIVE})
	VJ.AddConVar("vj_bmce_zmb_map_spooky_snds", 1, {FCVAR_ARCHIVE})
	VJ.AddConVar("vj_bmce_zmb_map_delete", 1, {FCVAR_ARCHIVE})
	VJ.AddConVar("vj_bmce_zmb_bruisers", 1, {FCVAR_ARCHIVE})
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

				Panel:AddControl("Checkbox", {Label = "Enable Undead Bruiser chance?", Command = "vj_bmce_zmb_bruisers"})
				Panel:ControlHelp("If enabled, Undead may have a chance to be a Brusier. Only applies to certain Undead.")

				Panel:AddControl("Header", {Description = "Undead Map Spawner Commands"})
				Panel:ControlHelp("Navigate to LNR (MapSp) to tinker settings for the Manhunt Undead Map Spawner.")
				
				Panel:AddControl("Checkbox", {Label = "Map Spawner: Enable starting music?", Command = "vj_bmce_zmb_map_music"})
				Panel:AddControl("Checkbox", {Label = "Map Spawner: Enable spooky sounds?", Command = "vj_bmce_zmb_map_spooky_snds"})
				Panel:AddControl("Checkbox", {Label = "Map Spawner: Remove all undead NPCs upon deleting Map Spawner?", Command = "vj_bmce_zmb_map_delete"})
			end)
		end)
	end
end

if CLIENT then
	net.Receive("vj_bmce_zombie_hud",function(len,pl)
		local delete = net.ReadBool()
		local ent = net.ReadEntity()
		if !IsValid(ent) then delete = true end

     if GetConVar("VJ_LNR_ZombieOverlay"):GetInt() == 1 then
		hook.Add("RenderScreenspaceEffects","VJ_BMCE_ZombieHUD_Overlay",function(zom)
            local threshold = 0.30
            DrawMaterialOverlay("lnr/overlay/infected_vision",threshold)
    end)
end
		if delete then hook.Remove("RenderScreenspaceEffects","VJ_BMCE_ZombieHUD_Overlay") end
end)
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