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
	VJ.AddNPC("Female Canteen Worker","npc_vj_bmce_cw_f",vPDCat)
	VJ.AddNPC("Male Canteen Worker","npc_vj_bmce_cw_m",vPDCat)
	VJ.AddNPC("Male Casual Scientist","npc_vj_bmce_scientist_casual_m",vPDCat)
	VJ.AddNPC("Male Construction Worker","npc_vj_bmce_constructw_m",vPDCat)
	VJ.AddNPC("Male Custodian Worker","npc_vj_bmce_custodian_m",vPDCat)



	-- Pre Disaster Unarmed Humans
--[[	 VJ.AddNPC("(PD) Male Scientist","npc_vj_bmce_pre_scientist_male",vPDCat)
	 VJ.AddNPC("(PD) Female Scientist","npc_vj_bmce_pre_scientist_female",vPDCat)
	 VJ.AddNPC("(PD) Male Office Worker","npc_vj_bmce_pre_officeworker_male",vPDCat)
	 VJ.AddNPC("(PD) Male Casual Scientist","npc_vj_bmce_pre_scientist_casual_male",vPDCat)
	 VJ.AddNPC("(PD) Male Hazmat","npc_vj_bmce_pre_hazmat_male",vPDCat)
	 VJ.AddNPC("(PD) Male Maintenance Worker","npc_vj_bmce_pre_mw_male",vPDCat)
	 VJ.AddNPC("(PD) Male Engineer","npc_vj_bmce_pre_engineer_male",vPDCat)
	 VJ.AddNPC("(PD) Female Canteen Worker","npc_vj_bmce_pre_canteenworker_female",vPDCat)
	 VJ.AddNPC("(PD) Male Custodian Worker","npc_vj_bmce_pre_custodian_male",vPDCat)
	 VJ.AddNPC("(PD) Male Canteen Worker","npc_vj_bmce_pre_canteenworker_male",vPDCat)

	 --Pre Disaster Friendly Humans
	 VJ.AddNPC_HUMAN("(PD) HECU Marine","npc_vj_bmce_pre_hgrunt",vHGeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) HECU Gasmask","npc_vj_bmce_pre_hgrunt_gasmask",vHGeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) HECU Sergeant","npc_vj_bmce_pre_hgrunt_sgt",vHGeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Male Security Guard","npc_vj_bmce_pre_secguard_male",vSeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Male Security Guard Captaian","npc_vj_bmce_pre_secguard_cpt",vSHPeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Female Security Guard","npc_vj_bmce_pre_secguard_female",vSeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Male Fat Security Guard","npc_vj_bmce_pre_secguard_fat_male",vSHPeapons,vPDCat)

	 VJ.AddNPC_HUMAN("(PD) Armed Male Scientist","npc_vj_bmce_pre_scientist_male_armed",vASeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Armed Male Office Worker","npc_vj_bmce_pre_officeworker_male_armed",vASeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Armed Male Casual Scientist","npc_vj_bmce_pre_scientist_casual_male_armed",vASeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Armed Male Hazmat","npc_vj_bmce_pre_hazmat_male_armed",vASeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Armed Male Maintenance Worker","npc_vj_bmce_pre_mw_male_armed",vASeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Armed Male Engineer","npc_vj_bmce_pre_engineer_male_armed",vASeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Armed Female Canteen Worker","npc_vj_bmce_pre_canteenworker_female_armed",vASeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Armed Female Scientist","npc_vj_bmce_pre_scientist_female_armed",vASeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Armed Male Custodian Worker","npc_vj_bmce_pre_custodian_male_armed",vASeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Armed Male Canteen Worker","npc_vj_bmce_pre_canteenworker_male_armed",vASeapons,vPDCat)
 	
 	--Pre Disaster Hostile Humans
	 VJ.AddNPC_HUMAN("(PD) HECU Marine (Hostile)","npc_vj_bmce_pre_hgrunt_hostile",vHGeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) HECU Gasmask (Hostile)","npc_vj_bmce_pre_hgrunt_gasmask_hostile",vHGeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) HECU Sergeant (Hostile)","npc_vj_bmce_pre_hgrunt_sgt_hostile",vHGeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Male Security Guard (Hostile)","npc_vj_bmce_pre_secguard_male_hostile",vSeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Male Security Guard Captaian (Hosttile)","npc_vj_bmce_pre_secguard_cpt_hostile",vSHPeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Female Security Guard (Hostile)","npc_vj_bmce_pre_secguard_female_hostile",vSeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Male Fat Security Guard (Hostile)","npc_vj_bmce_pre_secguard_fat_male_hostile",vSHPeapons,vPDCat)

	 VJ.AddNPC_HUMAN("(PD) Armed Male Scientist (Hostile)","npc_vj_bmce_pre_scientist_male_armed_hostile",vASeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Armed Male Office Worker (Hostile)","npc_vj_bmce_pre_officeworker_male_armed_hostile",vASeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Armed Male Casual (Hostile)","npc_vj_bmce_pre_scientist_casual_male_armed_hostile",vASeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Armed Male Hazmat (Hostile)","npc_vj_bmce_pre_hazmat_male_armed_hostile",vASeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Armed Male Maintenance Worker (Hostile)","npc_vj_bmce_pre_mw_male_armed_hostile",vASeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Armed Male Engineer (Hostile)","npc_vj_bmce_pre_engineer_male_armed_hostile",vASeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Armed Female Canteen Worker (Hostile)","npc_vj_bmce_pre_canteenworker_female_armed_hostile",vASeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Armed Female Scientist (Hostile)","npc_vj_bmce_pre_scientist_female_armed_hostile",vASeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Armed Male Custodian Worker (Hostile)","npc_vj_bmce_pre_custodian_male_armed_hostile",vASeapons,vPDCat)
	 VJ.AddNPC_HUMAN("(PD) Armed Male Canteen Worker","npc_vj_bmce_pre_canteenworker_male_armed_hostile",vASeapons,vPDCat)

	 -- Post Disaster Unarmed Humans
	 VJ.AddNPC("(D) Male Scientist","npc_vj_bmce_scientist_male",vDCat)
	 VJ.AddNPC("(D) Female Scientist","npc_vj_bmce_scientist_female",vDCat)
	 VJ.AddNPC("(D) Male Office Worker","npc_vj_bmce_officeworker_male",vDCat)
	 VJ.AddNPC("(D) Male Casual Scientist","npc_vj_bmce_scientist_casual_male",vDCat)
	 VJ.AddNPC("(D) Male Hazmat","npc_vj_bmce_hazmat_male",vDCat)
	 VJ.AddNPC("(D) Male Maintenance Worker","npc_vj_bmce_mw_male",vDCat)
	 VJ.AddNPC("(D) Male Engineer","npc_vj_bmce_engineer_male",vDCat)
	 VJ.AddNPC("(D) Female Canteen Worker","npc_vj_bmce_canteenworker_female",vDCat)
	 VJ.AddNPC("(D) Male Custodian Worker","npc_vj_bmce_custodian_male",vDCat)
	 VJ.AddNPC("(D) Male Canteen Worker","npc_vj_bmce_canteenworker_male",vDCat)

     -- Post Disaster Friendly Humans
	 VJ.AddNPC_HUMAN("(D) HECU Marine","npc_vj_bmce_hgrunt",vHGeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) HECU Gasmask","npc_vj_bmce_hgrunt_gasmask",vHGeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) HECU Sergeant","npc_vj_bmce_hgrunt_sgt",vHGeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Male Security Guard","npc_vj_bmce_secguard_male",vSHPeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Male Security Guard Captaian","npc_vj_bmce_secguard_cpt",vSHPeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Female Security Guard","npc_vj_bmce_secguard_female",vSHPeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Male Fat Security Guard","npc_vj_bmce_secguard_fat_male",vSHPeapons,vDCat)

	 VJ.AddNPC_HUMAN("(D) Armed Male Scientist","npc_vj_bmce_scientist_male_armed",vASeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Armed Male Office Worker","npc_vj_bmce_officeworker_male_armed",vASeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Armed Male Casual Scientist","npc_vj_bmce_scientist_casual_male_armed",vASeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Armed Male Hazmat","npc_vj_bmce_hazmat_male_armed",vASeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Armed Male Maintenance Worker","npc_vj_bmce_mw_male_armed",vASeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Armed Male Engineer","npc_vj_bmce_engineer_male_armed",vASeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Armed Female Canteen Worker","npc_vj_bmce_canteenworker_female_armed",vASeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Armed Female Scientist","npc_vj_bmce_scientist_female_armed",vASeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Armed Male Custodian Worker","npc_vj_bmce_custodian_male_armed",vASeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Armed Male Canteen Worker","npc_vj_bmce_canteenworker_male_armed",vASeapons,vDCat)

	 -- Post Disaster Hostile Humans
	 VJ.AddNPC_HUMAN("(D) HECU Marine (Hostile)","npc_vj_bmce_hgrunt_hostile",vHGeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) HECU Gasmask (Hostile)","npc_vj_bmce_hgrunt_gasmask_hostile",vHGeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) HECU Sergeant (Hostile)","npc_vj_bmce_hgrunt_sgt_hostile",vHGeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Male Security Guard (Hostile)","npc_vj_bmce_secguard_male_hostile",vSHPeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Male Security Guard Captaian (Hostile)","npc_vj_bmce_secguard_cpt_hostile",vSHPeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Female Security Guard (Hostile)","npc_vj_bmce_secguard_female_hostile",vSHPeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Male Fat Security Guard (Hostile)","npc_vj_bmce_secguard_fat_male_hostile",vSHPeapons,vDCat)

	 VJ.AddNPC_HUMAN("(D) Armed Male Scientist (Hostile)","npc_vj_bmce_scientist_male_armed_hostile",vASeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Armed Male Office Worker (Hostile)","npc_vj_bmce_officeworker_male_armed_hostile",vASeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Armed Male Casual (Hostile)","npc_vj_bmce_scientist_casual_male_armed_hostile",vASeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Armed Male Hazmat (Hostile)","npc_vj_bmce_hazmat_male_armed_hostile",vASeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Armed Male Maintenance Worker (Hostile)","npc_vj_bmce_mw_male_armed_hostile",vASeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Armed Male Engineer (Hostile)","npc_vj_bmce_engineer_male_armed_hostile",vASeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Armed Female Canteen Worker (Hostile)","npc_vj_bmce_canteenworker_female_armed_hostile",vASeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Armed Female Scientist (Hostile)","npc_vj_bmce_scientist_female_armed_hostile",vASeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Armed Male Custodian Worker (Hostile)","npc_vj_bmce_custodian_male_armed_hostile",vASeapons,vDCat)
	 VJ.AddNPC_HUMAN("(D) Armed Male Canteen Worker (Hostile)","npc_vj_bmce_canteenworker_male_armed_hostile",vASeapons,vDCat)

	-- Spawners and Groups
	VJ.AddNPC("(PD) Random BM Staff","sent_vj_bmce_pre_random_staff",vPDCat)
	VJ.AddNPC("(PD) Random BM Staff Armed","sent_vj_bmce_pre_random_staff_armed",vPDCat)
	VJ.AddNPC("(PD) Random BM Security","sent_vj_bmce_pre_random_security",vPDCat)
	VJ.AddNPC("(PD) Random HECU","sent_vj_bmce_pre_random_hecu",vPDCat)

	VJ.AddNPC("(PD) Random BM Staff Armed (Hostile)","sent_vj_bmce_pre_random_staff_armed_hostile",vPDCat)
	VJ.AddNPC("(PD) Random BM Security (Hostile)","sent_vj_bmce_pre_random_security_hostile",vPDCat)
	VJ.AddNPC("(PD) Random HECU (Hostile)","sent_vj_bmce_pre_random_hecu_hostile",vPDCat)

	VJ.AddNPC("(D) Random BM Staff","sent_vj_bmce_random_staff",vDCat)
	VJ.AddNPC("(D) Random BM Staff Armed","sent_vj_bmce_random_staff_armed",vDCat)
	VJ.AddNPC("(D) Random BM Security","sent_vj_bmce_random_security",vDCat)
	VJ.AddNPC("(D) Random HECU","sent_vj_bmce_random_hecu",vDCat)

	VJ.AddNPC("(D) Random BM Staff Armed (Hostile)","sent_vj_bmce_random_staff_armed_hostile",vDCat)
	VJ.AddNPC("(D) Random BM Security (Hostile)","sent_vj_bmce_random_security_hostile",vDCat)
	VJ.AddNPC("(D) Random HECU (Hostile)","sent_vj_bmce_random_hecu_hostile",vDCat)

	VJ.AddNPC("Headcrab Zombie","npc_vj_bmce_zombie",vDCat)
	VJ.AddNPC("Headcrab ZECU","npc_vj_bmce_zecu",vDCat)
	VJ.AddNPC("Headcrab Security Guard","npc_vj_bmce_secguard_zombie",vDCat)--]]

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

	VJ_BMCE_NAMES_FIRST_F = {
		" Jannet",
		" Edith",
		" Lena",
		" Margaret",
		" Mary",
		" Ada",
		" Wendy",
		" Hana",
		" Jessica",
		" Alice",
		" June",
		" Mckenzie",
		" Kiara",
		" Amanda",
		" Tiffany",
		" Alexandria",
		" Jency",
		" Aylin",
		" Lauren",
		" Anita",
		" Barbara",
		" Beatrice",
		" Bonnie",
		" Courtney",
		" Clauna",
		" Georgia",
		" Helen",
		" Helena",
		" Judith",
		" Mallie",
		" Marcia",
		" Molly",
		" Salenna",
		" Sarah",
		" Serena",
		" Victoria",
		" Violet"
	}
	VJ_BMCE_NAMES_FIRST_M = {
		" Carson",
		" Ed",
		" Lance",
		" Adam",
		" John",
		" Sebastian",
		" Derek",
		" Leo",
		" Zach",
		" Francis",
		" James",
		" Alex",
		" Dave",
		" David",
		" Carl",
		" Kevin",
		" Edward",
		" Seth",
		" Frank",
		" Walter",
		" Ben",
		" Isaiah",
		" Daniel",
		" Christian",
		" Senald",
		" Lan",
		" Henry",
		" Paul",
		" Hector",
		" Alan",
		" Arnold",
		" Bob",
		" Cassier",
		" Cesar",
		" Donald",
		" Elwand",
		" George",
		" Keith",
		" Krute",
		" Mark",
		" Marson",
		" Nick",
		" Raggel",
		" Victor",
		" Marchello",
		" Max",
		" Ellis",
		" Elias",
		" Jesse",
		" Tuco"
	}
	VJ_BMCE_NAMES_LAST = {
		" Foreman",
		" Greene",
		" Hubai",
		" Young",
		" Anderson",
		" Kemp",
		" Wilkins",
		" Horn",
		" Simmons",
		" Casper",
		" Newton",
		" Sisk",
		" Freemont",
		" Laren",
		" Clancy",
		" Jackson",
		" Thomas",
		" Bishop",
		" Scott",
		" Haris",
		" Hookgard",
		" Cranley",
		" McWell",
		" Lowen",
		" Toffly",
		" Vinstock",
		" Tannessel",
		" Chuckmen",
		" Cho",
		" Good",
		" Gorald",
		" Guyrald",
		" Lightteller",
		" Liu",
		" Mallon",
		" Manne",
		" Louiman",
		" Sausa",
		" Schmann",
		" Steller",
		" Stern",
		" Tollia",
		" Wallyson",
		" Weaver",
		" Wickler",
		" Marston",
		" Bronco",
		" Payne",
		" DeMarco",
		" Reyes",
		" Eidenson",
		" Robinson"
	}
	VJ_BMCE_RANKS = {"Pvt.","Pfc.","Cpl."}
	VJ_BMCE_RANKS_OFFICER = {"Sgt.","SSgt.","Lt.","Capt.","Col."}
	VJ_BMCE_RANKS_SCI = {"Intern.","Intern.","Intern.","R&D.","R&D.","R&D.","R&D.","Research Associate.","Research Associate.","Research Associate.","Research Associate.","Supervisor.","Supervisor.","Instructor."}
	VJ_BMCE_RANKS_SCI_HEV = {"Survey Team.","Survey Team.","Survey Team.","Survey Team.","Supervisor.","Supervisor.","Instructor."}
	VJ_BMCE_RANKS_ENGINEER = {"Architect.","Architect.","Architect.","Foreman.","Foreman.","Foreman.","Supervisor.","Supervisor."}
	VJ_BMCE_RANKS_ADMIN = {"Accountant.","Accountant.","Accountant.","Office Manager.","Office Manager.", "IT."}

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

				Panel:AddControl("Checkbox", {Label = "Should SNPCs names draw to the hud?", Command = "vj_bmce_shownames"})
				Panel:ControlHelp("if checked, SNPCs on croshair will show their name.")
				
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