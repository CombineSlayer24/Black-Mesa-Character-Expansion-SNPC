/*--------------------------------------------------
	=============== Autorun File ===============
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
------------------ Addon Information ------------------
local PublicAddonName = "Black Mesa BMCE SNPCs"
local AddonName = "Black Mesa BMCE - 2023"
local AddonType = "SNPC"
local AutorunFile = "autorun/vj_bmce_autorun.lua"
-------------------------------------------------------
local VJExists = file.Exists("lua/autorun/vj_base_autorun.lua","GAME")
if VJExists == true then
	include('autorun/vj_controls.lua')

	if !VJ then VJ = {} end -- If VJ isn't initialized, initialize it!

	local vPDCat = "Black Mesa | CE" -- NPCs in Pre-Disaster will act chill, friendly towards the H.E.C.U.

	VJ.AddCategoryInfo(vPDCat, {Icon = "vgui/bm_bmcelogo.png"})


	VJ.AddNPC("Male Scientist","npc_vj_bmce_scientist_m",vPDCat)
	VJ.AddNPC("Female Scientist","npc_vj_bmce_scientist_f",vPDCat)
	VJ.AddNPC("Male H.E.V Scientist","npc_vj_bmce_hev_m",vPDCat)
	VJ.AddNPC("Female Canteen Worker","npc_vj_bmce_cw_f",vPDCat)
	VJ.AddNPC("Male Canteen Worker","npc_vj_bmce_cw_m",vPDCat)
	VJ.AddNPC("Male Casual Scientist","npc_vj_bmce_scientist_casual_m",vPDCat)
	VJ.AddNPC("Male Construction Worker","npc_vj_bmce_constructw_m",vPDCat)
	VJ.AddNPC("Male Custodian Worker","npc_vj_bmce_custodian_m",vPDCat)
	VJ.AddNPC("Male Security Guard","npc_vj_bmce_secguard_m",vPDCat)
	VJ.AddNPC("Security Guard Captain","npc_vj_bmce_secguard_capt",vPDCat)
	VJ.AddNPC("Male Custodian","npc_vj_bmce_custodian_m",vPDCat)
	VJ.AddNPC("Female Custodian","npc_vj_bmce_custodian_f",vPDCat)
	VJ.AddNPC("Male Engineer","npc_vj_bmce_engineer_m",vPDCat)

	-- Weapons
	VJ.AddNPCWeapon("VJ_BMCE_M4_GRENADIER", "weapon_vj_bmce_m4")
	VJ.AddNPCWeapon("VJ_BMCE_M9", "weapon_vj_bmce_m9")
	VJ.AddNPCWeapon("VJ_BMCE_GLOCK17", "weapon_vj_bmce_glock17")
	VJ.AddNPCWeapon("VJ_BMCE_DESERT_EAGLE", "weapon_vj_bmce_degal")
	VJ.AddNPCWeapon("VJ_BMCE_BMCE_357_REVOLVER", "weapon_vj_bmce_357")
	VJ.AddNPCWeapon("VJ_BMCE_MP5", "weapon_vj_bmce_mp5")
	VJ.AddNPCWeapon("VJ_BMCE_SHOTGUN", "weapon_vj_bmce_shotgun")
	VJ.AddNPCWeapon("VJ_BMCE_SPAS12", "weapon_vj_bmce_spas12")

	-- Spawnmenu weapons
	vCat = "Black Mesa Character Expansion Weapons"
	VJ.AddCategoryInfo(vCat, {Icon = "vgui/bm_bmcelogo.png"})
	VJ.AddWeapon("Glock 17","weapon_vj_bmce_glock17",false,vCat)
	VJ.AddWeapon("Beretta M9","weapon_vj_bmce_m9",false,vCat)
	VJ.AddWeapon("Standard Shotgun","weapon_vj_bmce_shotgun",false,vCat)
	VJ.AddWeapon("MP5","weapon_vj_bmce_mp5",false,vCat)
	VJ.AddWeapon("M4 Grenadier","weapon_vj_bmce_m4",false,vCat)
	VJ.AddWeapon(".357 Revolver","weapon_vj_bmce_357",false,vCat)
	VJ.AddWeapon("Desert Eagle","weapon_vj_bmce_degal",false,vCat)
	VJ.AddWeapon("SPAS-12 Auto","weapon_vj_bmce_spas12",false,vCat)

	-- ConVars --
	VJ.AddConVar("vj_bmce_disaster_status", 0, {FCVAR_ARCHIVE})
	VJ.AddConVar("vj_bmce_weapons", 0, {FCVAR_ARCHIVE})
	VJ.AddConVar("vj_bmce_hostile", 0, {FCVAR_ARCHIVE})
	VJ.AddConVar("vj_bmce_following", 0, {FCVAR_ARCHIVE})

	-- Globals --

	VJ_BMCE_WP_STAFF = {
		"weapon_vj_bmce_glock17",
		"weapon_vj_bmce_glock17",
		"weapon_vj_bmce_glock17",
		"weapon_vj_bmce_glock17",
		"weapon_vj_bmce_m9",
		"weapon_vj_bmce_m9",
		"weapon_vj_bmce_m9",
		"weapon_vj_bmce_m9",
		"weapon_vj_bmce_357",
		"weapon_vj_bmce_357",
		"weapon_vj_bmce_degal",
		"weapon_vj_bmce_degal",
		"weapon_vj_bmce_mp5",
		"weapon_vj_bmce_m4",
		"weapon_vj_crowbar"
	}
	
	VJ_BMCE_WP_STAFF_CONSTRU = {
		"weapon_vj_bmce_glock17",
		"weapon_vj_bmce_glock17",
		"weapon_vj_bmce_glock17",
		"weapon_vj_bmce_glock17",
		"weapon_vj_crowbar",
		"weapon_vj_crowbar",
		"weapon_vj_crowbar",
		"weapon_vj_bmce_m9",
		"weapon_vj_bmce_m9",
		"weapon_vj_bmce_mp5"
	}

	VJ_BMCE_WP_BMSF = {
		"weapon_vj_bmce_glock17",
		"weapon_vj_bmce_glock17",
		"weapon_vj_bmce_glock17",
		"weapon_vj_bmce_m9",
		"weapon_vj_bmce_m9",
		"weapon_vj_bmce_m9"
	}

	VJ_BMCE_WP_BMSF_ADVW = {
		"weapon_vj_bmce_glock17",
		"weapon_vj_bmce_m9",
		"weapon_vj_bmce_shotgun",
		"weapon_vj_bmce_degal",
		"weapon_vj_bmce_degal",
		"weapon_vj_bmce_357",
		"weapon_vj_bmce_357"
	}

	VJ_MODEL_ANIMSET_BMSTAFF = 0
	VJ_MODEL_ANIMSET_BMSTAFF_FEMALE = 1
	VJ_MODEL_ANIMSET_HECU = 2
	
	------------------------------------------------------------------------------------------------------------------------------------------------------
	if CLIENT then
		hook.Add("PopulateToolMenu", "VJ_ADDTOMENU_BMCE", function()
			spawnmenu.AddToolMenuOption("DrVrej", "SNPC Configures", "BMCE", "BMCE", "", "", function(Panel)
				if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
					Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
					Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
					return
				end
				Panel:AddControl("Header", {Description = "Note: Newly spawned SNPC's will take affect to the changes you made!"})
				Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
				Panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = ""})
				
				Panel:AddControl("Checkbox", {Label = "Should SNPCs use Disaster behaviour?", Command = "vj_bmce_disaster_status"})
				Panel:ControlHelp("if checked, SNPCs will be in Disaster status. If unchecked, SNPCs will be in Pre-Disaster status. \n\nH.E.C.U Soldiers will attack Staff Members if enabled.")

				Panel:AddControl("Checkbox", {Label = "Enable following?", Command = "vj_bmce_following"})
				Panel:ControlHelp("if checked, SNPCs in Pre-Disaster status will follow you. If unchecked, SNPCs in Pre-Disaster status won't follow you. Post-Disaster SNPCS will still follow you regardless. \n\nH.E.C.U Soldiers will attack Staff Members if enabled.")

				Panel:AddControl("Checkbox", {Label = "Should SNPCs names draw to the hud?", Command = "vj_bmce_shownames"})
				Panel:ControlHelp("if checked, SNPCs on croshair will show their name.")

				Panel:AddControl("Slider", { Label 	= "Should SNPCs health draw to the hud?", Command = "vj_bmce_showhealthinfo", Type = "0", Min = "0", Max = "3"})
				Panel:ControlHelp("0 = Disable \n1 = Healthbar \n2 = Precise \n 3 = Both")
				
				Panel:AddControl("Slider", { Label 	= "Hostility", Command = "vj_bmce_hostile", Type = "0", Min = "0", Max = "2"})
				Panel:ControlHelp("0 = Friendly \n1 = Hostile \n2 = Hates everyone")
				
				Panel:AddControl("Slider", { Label 	= "Staff use Firearms", Command = "vj_bmce_weapons", Type = "0", Min = "0", Max = "2"})
				Panel:ControlHelp("0 = No weapons \n1 = 33% chance \n2 = 100%")
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