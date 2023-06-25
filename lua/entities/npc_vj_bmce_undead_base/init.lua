AddCSLuaFile("shared.lua")
include('shared.lua')

-- for those that are looking here; code that's easy to read, with good indents helps out in the long run

-- VJ Base
ENT.HasItemDropsOnDeath = true
ENT.HasBloodDecal = true
ENT.BloodDecalUseGMod = false
ENT.SuppressingSoundChance = 1
ENT.NextSoundTime_Pain = VJ_Set(2, 2.3)
ENT.NextSoundTime_Idle = VJ_Set( 4, 6 )
ENT.NextSoundTime_Suppressing = VJ_Set( 0, 1.6 )
ENT.FootStepSoundLevel = 77
ENT.IdleSoundLevel = 77
ENT.CombatIdleSoundLevel = 77
ENT.SuppressingSoundLevel = 77
ENT.BeforeMeleeAttackSoundLevel = 77
ENT.AlertSoundLevel = 77
ENT.TurningSpeed = 75
-- LNR stuff
ENT.LNR_AllowedToStumble = true
ENT.LNR_Gib = false
ENT.LNR_Dismember = false
ENT.LNR_Biter = false
ENT.LNR_CanBeHeadshot = true 
ENT.LNR_VirusInfection = false
ENT.LNR_Infected = false
ENT.LNR_SuperSprinter = false
ENT.LNR_Crawler = false
ENT.LNR_Gibbed = false
-- CUSTOM
ENT.Zombie_Walker = false
ENT.Zombie_Runner = false
ENT.Zombie_Bruiser = 0
ENT.Zombie_Fire = 0
ENT.HasEyeGlow = 0
ENT.BMCE_Hat = 0
-- 0 no hat
-- 1 beret (security)
-- 2 beret (hecu)
-- 3 boonie
-- 4 8point
-- 5 cap

ENT.RDR_VoiceType = nil 
-- 1 Male
-- 2 Female
---------------------------------------------------------------------------------------------------------------------------------------------
-- Locals, tables and other crap, yadada
local random = math.random
local rand = math.Rand
local voiceset = GetConVar( "vj_bmce_zmb_voiceset" )
local zombie_Speed = GetConVar( "vj_bmce_zmb_speed" )
local spriteTexture = GetConVar( "vj_bmce_zmb_eyeglow_lighter" )

local colorTable = {
	orange = { color = Color(240, 96, 0, 255), c_string = "240 96 0 255" },
	lightblue = { color = Color(0, 199, 255, 255), c_string = "0 199 255 255" },
	red = { color = Color(255, 0, 0, 255), c_string = "255 0 0 255" },
	green = { color = Color(22, 189, 58, 255), c_string = "22 189 58 255" },
	darkblue = { color = Color(0, 120, 255, 255), c_string = "0 120 255 255" },
	bruiser = { color = Color(195, 66, 255), c_string = "195 66 255 255" } -- old clr, 136 22 189 255
}

local ANIM_WALK = {ACT_WALK}
local ANIM_RUN = {ACT_RUN}
local ANIM_SPRINT = {ACT_SPRINT}
local ANIM_RUN_AIM = {ACT_RUN_AIM}

-- World At War - Black Ops 2 local tables
local Tbl_Classic_Alert = {"vj_bmce_zmb/vocals/world_at_war/attack/attack1.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack2.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack6.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack7.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack14.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack20.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack22.mp3","vj_bmce_zmb/vocals/world_at_war/behind/behind1.mp3","vj_bmce_zmb/vocals/world_at_war/behind/behind2.mp3","vj_bmce_zmb/vocals/world_at_war/behind/behind3.mp3","vj_bmce_zmb/vocals/world_at_war/behind/behind4.mp3","vj_bmce_zmb/vocals/world_at_war/behind/behind5.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl1.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl2.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl3.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl4.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl5.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt1.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt2.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt3.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt4.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt5.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt6.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt7.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt1.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt2.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt3.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt4.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt5.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt6.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt7.mp3"}
local Tbl_Classic_Idle = {"vj_bmce_zmb/vocals/world_at_war/amb/ambient1.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient2.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient3.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient4.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient5.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient6.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient7.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient8.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient9.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient10.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient11.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient12.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient13.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient14.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient15.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient16.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient17.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient18.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient19.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient20.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient21.mp3"}
local Tbl_Classic_Attack = {"vj_bmce_zmb/vocals/world_at_war/attack/attack1.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack2.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack3.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack4.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack5.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack6.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack7.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack8.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack9.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack10.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack11.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack12.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack13.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack14.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack15.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack16.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack17.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack18.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack19.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack20.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack21.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack22.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack23.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack24.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack25.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack26.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack27.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack28.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack29.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack30.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack31.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack32.mp3"}
local Tbl_Classic_Death = {"vj_bmce_zmb/vocals/world_at_war/death/death1.mp3","vj_bmce_zmb/vocals/world_at_war/death/death2.mp3","vj_bmce_zmb/vocals/world_at_war/death/death3.mp3","vj_bmce_zmb/vocals/world_at_war/death/death4.mp3","vj_bmce_zmb/vocals/world_at_war/death/death5.mp3","vj_bmce_zmb/vocals/world_at_war/death/death6.mp3","vj_bmce_zmb/vocals/world_at_war/death/death7.mp3","vj_bmce_zmb/vocals/world_at_war/death/death8.mp3","vj_bmce_zmb/vocals/world_at_war/death/death9.mp3","vj_bmce_zmb/vocals/world_at_war/death/death10.mp3"}
local Tbl_Classic_AttackStrike = { "vj_bmce_zmb/vocals/world_at_war/attack_strike1.mp3","vj_bmce_zmb/vocals/world_at_war/attack_strike2.mp3","vj_bmce_zmb/vocals/world_at_war/attack_strike3.mp3"}
local Tbl_Classic_Death_Elec = {"vj_bmce_zmb/vocals/world_at_war/elec/elec1.mp3","vj_bmce_zmb/vocals/world_at_war/elec/elec2.mp3","vj_bmce_zmb/vocals/world_at_war/elec/elec3.mp3","vj_bmce_zmb/vocals/world_at_war/elec/elec4.mp3","vj_bmce_zmb/vocals/world_at_war/elec/elec5.mp3","vj_bmce_zmb/vocals/world_at_war/elec/elec6.mp3"}
local Tbl_Classic_Running = {"vj_bmce_zmb/vocals/world_at_war/sprint/sprint1.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint2.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint3.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint4.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint5.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint6.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint7.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint8.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint9.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint10.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint11.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint12.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint13.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint14.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint15.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint16.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint17.mp3"}

-- Black Ops 3 tables
local Tbl_ZC_Alert = {"vj_bmce_zmb/vocals/blackops3/taunt/taunt1.mp3","vj_bmce_zmb/vocals/blackops3/taunt/taunt2.mp3","vj_bmce_zmb/vocals/blackops3/taunt/taunt3.mp3","vj_bmce_zmb/vocals/blackops3/taunt/taunt4.mp3","vj_bmce_zmb/vocals/blackops3/taunt/taunt5.mp3","vj_bmce_zmb/vocals/blackops3/taunt/taunt6.mp3","vj_bmce_zmb/vocals/blackops3/taunt/taunt7.mp3","vj_bmce_zmb/vocals/blackops3/taunt/zm_mod.all_62.mp3","vj_bmce_zmb/vocals/blackops3/taunt/zm_mod.all_63.mp3","vj_bmce_zmb/vocals/blackops3/taunt/zm_mod.all_64.mp3","vj_bmce_zmb/vocals/blackops3/taunt/zm_mod.all_65.mp3","vj_bmce_zmb/vocals/blackops3/taunt/zm_mod.all_66.mp3","vj_bmce_zmb/vocals/blackops3/taunt/zm_mod.all_67.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_89.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_93.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_97.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_1.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_2.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_3.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_4.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_5.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_6.mp3"}
local Tbl_ZC_Idle = {"vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_26.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_27.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_28.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_29.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_30.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_31.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_32.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_33.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_34.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_35.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_36.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_37.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_38.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_39.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_40.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_41.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_42.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_43.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_44.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_45.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_46.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_47.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_48.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_49.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_50.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_51.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_52.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_53.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_54.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_55.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_56.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_57.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_58.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_59.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_60.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_61.mp3"}
local Tbl_ZC_Attack = {"vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_1.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_2.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_3.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_4.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_5.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_6.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_7.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_8.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_9.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_10.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_11.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_12.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_13.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_14.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_15.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_16.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_17.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_18.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_19.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_20.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_21.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_22.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_23.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_24.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_25.mp3"}
local Tbl_ZC_Death = {"vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_68.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_69.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_70.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_71.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_72.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_73.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_74.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_75.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_76.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_77.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_78.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_79.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_80.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_81.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_82.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_83.mp3"}
local Tbl_ZC_AttackStrike = {"vj_bmce_zmb/vocals/blackops3/zm_mod.all_112.mp3","vj_bmce_zmb/vocals/blackops3/zm_mod.all_113.mp3","vj_bmce_zmb/vocals/blackops3/zm_mod.all_114.mp3","vj_bmce_zmb/vocals/blackops3/zm_mod.all_115.mp3","vj_bmce_zmb/vocals/blackops3/zm_mod.all_116.mp3","vj_bmce_zmb/vocals/blackops3/zm_mod.all_117.mp3"}
local Tbl_ZC_Death_Elec = {}
local Tbl_ZC_Running = {"vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_84.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_85.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_86.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_87.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_88.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_89.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_90.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_91.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_92.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_93.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_94.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_95.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_96.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_97.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_98.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_99.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_100.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_101.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_102.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_103.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_104.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_105.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_106.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_107.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_108.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_109.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_110.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_111.mp3"}

-- Cold War
local Tbl_CW_Alert = {"vj_bmce_zmb/vocals/cold_war/taunt/taunt1.mp3","vj_bmce_zmb/vocals/cold_war/taunt/taunt2.mp3","vj_bmce_zmb/vocals/cold_war/taunt/taunt3.mp3","vj_bmce_zmb/vocals/cold_war/taunt/taunt4.mp3","vj_bmce_zmb/vocals/cold_war/taunt/taunt5.mp3","vj_bmce_zmb/vocals/cold_war/taunt/taunt6.mp3","vj_bmce_zmb/vocals/cold_war/taunt/taunt7.mp3","vj_bmce_zmb/vocals/cold_war/taunt/taunt8.mp3"}
local Tbl_CW_Idle = {"vj_bmce_zmb/vocals/cold_war/amb/ambient1.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient2.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient3.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient4.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient5.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient6.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient7.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient8.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient9.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient1.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient11.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient12.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient13.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient14.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient15.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient16.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient17.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient18.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient19.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient2.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient21.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient22.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient23.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient24.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient25.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient26.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient27.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient28.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient29.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient3.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient31.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient32.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient33.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient34.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient35.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient36.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient37.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient38.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient39.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient4.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient41.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient42.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient43.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient44.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient45.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient46.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient47.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient48.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient49.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient5.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient51.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient52.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient53.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient54.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient55.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient56.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient57.mp3"}
local Tbl_CW_Attack = {"vj_bmce_zmb/vocals/cold_war/attack/attack1.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack2.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack3.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack4.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack5.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack6.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack7.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack8.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack9.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack1.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack11.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack12.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack13.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack14.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack15.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack16.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack17.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack18.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack19.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack2.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack21.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack22.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack23.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack24.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack25.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack26.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack27.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack28.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack29.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack3.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack31.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack32.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack33.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack34.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack35.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack36.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack37.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack38.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack39.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack4.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack41.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack42.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack43.mp3"}
local Tbl_CW_Death = {"vj_bmce_zmb/vocals/cold_war/death/death1.mp3","vj_bmce_zmb/vocals/cold_war/death/death2.mp3","vj_bmce_zmb/vocals/cold_war/death/death3.mp3","vj_bmce_zmb/vocals/cold_war/death/death4.mp3","vj_bmce_zmb/vocals/cold_war/death/death5.mp3","vj_bmce_zmb/vocals/cold_war/death/death6.mp3","vj_bmce_zmb/vocals/cold_war/death/death7.mp3","vj_bmce_zmb/vocals/cold_war/death/death8.mp3","vj_bmce_zmb/vocals/cold_war/death/death9.mp3","vj_bmce_zmb/vocals/cold_war/death/death10.mp3","vj_bmce_zmb/vocals/cold_war/death/death11.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_72.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_73.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_74.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_75.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_76.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_77.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_78.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_79.mp3"}
local Tbl_CW_Death_Elec = {"vj_bmce_zmb/vocals/cold_war/elec/elec1.mp3","vj_bmce_zmb/vocals/cold_war/elec/elec2.mp3","vj_bmce_zmb/vocals/cold_war/elec/elec3.mp3","vj_bmce_zmb/vocals/cold_war/elec/elec4.mp3","vj_bmce_zmb/vocals/cold_war/elec/elec5.mp3","vj_bmce_zmb/vocals/cold_war/elec/elec6.mp3","vj_bmce_zmb/vocals/cold_war/elec/elec7.mp3","vj_bmce_zmb/vocals/cold_war/elec/elec8.mp3","vj_bmce_zmb/vocals/cold_war/elec/elec9.mp3","vj_bmce_zmb/vocals/cold_war/elec/elec10.mp3"}
local Tbl_CW_Running = {"vj_bmce_zmb/vocals/cold_war/sprint/sprint1.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint2.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint3.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint4.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint5.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint6.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint7.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint8.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint9.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint1.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint11.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint12.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint13.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint14.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint15.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint16.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint17.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint18.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint19.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint2.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint21.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint22.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint23.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint24.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint25.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint26.mp3"}

-- Red Dead Redemption: Undead Nightmare
local Tbl_UN_Shared_Death_Male = {"vj_bmce_zmb/vocals/rdr_un/zombie_male/death_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_16.mp3"}
local Tbl_UN_Shared_Death_Female = {"vj_bmce_zmb/vocals/rdr_un/zombie_female/death_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/death_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/death_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/death_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/death_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/death_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/death_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/death_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/death_09.mp3"}
local Tbl_UN_Shared_Pain_Male = {"vj_bmce_zmb/vocals/rdr_un/zombie_male/pain_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/pain_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/pain_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/pain_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/pain_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/pain_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/pain_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/pain_08.mp3"}
local Tbl_UN_Shared_Pain_Female = {"vj_bmce_zmb/vocals/rdr_un/zombie_female/pain_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/pain_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/pain_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/pain_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/pain_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/pain_06.mp3"}

-- Male 01
local Tbl_UN_Alert_Male_01 = {"vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_20.mp3"}
local Tbl_UN_Idle_Male_01 = {"vj_bmce_zmb/vocals/rdr_un/weird_01.mp3","vj_bmce_zmb/vocals/rdr_un/weird_02.mp3","vj_bmce_zmb/vocals/rdr_un/weird_03.mp3","vj_bmce_zmb/vocals/rdr_un/weird_04.mp3","vj_bmce_zmb/vocals/rdr_un/weird_05.mp3","vj_bmce_zmb/vocals/rdr_un/weird_06.mp3","vj_bmce_zmb/vocals/rdr_un/weird_07.mp3","vj_bmce_zmb/vocals/rdr_un/weird_08.mp3","vj_bmce_zmb/vocals/rdr_un/weird_09.mp3","vj_bmce_zmb/vocals/rdr_un/weird_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_32.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_33.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_34.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_35.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_36.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_37.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_38.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_39.mp3"}
local Tbl_UN_Attacking_Male_01 = {"vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_32.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_33.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_34.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_35.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_36.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_37.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_38.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_39.mp3"}
local Tbl_UN_Running_Male_01 = {"vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_32.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_33.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_34.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_35.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_36.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_37.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_38.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_39.mp3"}
-- Male 02
local Tbl_UN_Alert_Male_02 = {"vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_37.mp3"}
local Tbl_UN_Idle_Male_02 = {"vj_bmce_zmb/vocals/rdr_un/weird_01.mp3","vj_bmce_zmb/vocals/rdr_un/weird_02.mp3","vj_bmce_zmb/vocals/rdr_un/weird_03.mp3","vj_bmce_zmb/vocals/rdr_un/weird_04.mp3","vj_bmce_zmb/vocals/rdr_un/weird_05.mp3","vj_bmce_zmb/vocals/rdr_un/weird_06.mp3","vj_bmce_zmb/vocals/rdr_un/weird_07.mp3","vj_bmce_zmb/vocals/rdr_un/weird_08.mp3","vj_bmce_zmb/vocals/rdr_un/weird_09.mp3","vj_bmce_zmb/vocals/rdr_un/weird_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_32.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_33.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_34.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_35.mp3"}
local Tbl_UN_Attacking_Male_02 = {"vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_32.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_33.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_34.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_35.mp3"}
local Tbl_UN_Running_Male_02 = {"vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_32.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_33.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_34.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_35.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_36.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_37.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_38.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_39.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_40.mp3"}
-- Male 03
local Tbl_UN_Alert_Male_03 = {"vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attack_noise_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attack_noise_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attack_noise_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attack_noise_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attack_noise_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attack_noise_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attack_noise_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attack_noise_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attack_noise_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attack_noise_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attack_noise_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attack_noise_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attack_noise_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attack_noise_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attack_noise_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attack_noise_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attack_noise_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attack_noise_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attack_noise_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attack_noise_20.mp3"}
local Tbl_UN_Idle_Male_03 = {"vj_bmce_zmb/vocals/rdr_un/weird_01.mp3","vj_bmce_zmb/vocals/rdr_un/weird_02.mp3","vj_bmce_zmb/vocals/rdr_un/weird_03.mp3","vj_bmce_zmb/vocals/rdr_un/weird_04.mp3","vj_bmce_zmb/vocals/rdr_un/weird_05.mp3","vj_bmce_zmb/vocals/rdr_un/weird_06.mp3","vj_bmce_zmb/vocals/rdr_un/weird_07.mp3","vj_bmce_zmb/vocals/rdr_un/weird_08.mp3","vj_bmce_zmb/vocals/rdr_un/weird_09.mp3","vj_bmce_zmb/vocals/rdr_un/weird_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_32.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_33.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_34.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_35.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_36.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_37.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_38.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_39.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_40.mp3"}
local Tbl_UN_Attacking_Male_03 = {"vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_32.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_33.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_34.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_35.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_36.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_37.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_38.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_39.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/idle_40.mp3"}
local Tbl_UN_Running_Male_03 = {"vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_32.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_33.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_34.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_35.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_36.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_37.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_38.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_39.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_40.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_41.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_03/attacking_42.mp3"}
-- Female 01
local Tbl_UN_Alert_Female_01 = {"vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attack_noise_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attack_noise_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attack_noise_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attack_noise_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attack_noise_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attack_noise_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attack_noise_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attack_noise_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attack_noise_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attack_noise_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attack_noise_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attack_noise_12.mp3"}
local Tbl_UN_Idle_Female_01 = {"vj_bmce_zmb/vocals/rdr_un/weird_01.mp3","vj_bmce_zmb/vocals/rdr_un/weird_02.mp3","vj_bmce_zmb/vocals/rdr_un/weird_03.mp3","vj_bmce_zmb/vocals/rdr_un/weird_04.mp3","vj_bmce_zmb/vocals/rdr_un/weird_05.mp3","vj_bmce_zmb/vocals/rdr_un/weird_06.mp3","vj_bmce_zmb/vocals/rdr_un/weird_07.mp3","vj_bmce_zmb/vocals/rdr_un/weird_08.mp3","vj_bmce_zmb/vocals/rdr_un/weird_09.mp3","vj_bmce_zmb/vocals/rdr_un/weird_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/roar_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/roar_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/roar_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/roar_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/roar_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/roar_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/roar_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/roar_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/roar_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_32.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_33.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_34.mp3"}
local Tbl_UN_Attacking_Female_01 = {"vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_32.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_33.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_34.mp3"}
local Tbl_UN_Running_Female_01 = {"vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_32.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_33.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_34.mp3"}

-- Eye glow
local orangeEyeMdls = {
	"models/undead/scientist_burned.mdl",
	"models/undead/guard_burned.mdl",
	"models/undead/marine_burned.mdl"
}

local greenEyeMdls = {
	"models/undead/marine.mdl",
	"models/undead/marine_02.mdl",
}

local blueEyeMdls = {
	"models/undead/guard.mdl",
	"models/undead/guard_02.mdl",
	"models/undead/guard_03.mdl",
	"models/undead/guard_female.mdl",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.Zombie_EnergyTime = CurTime() + rand(GetConVar("vj_bmce_zmb_deathtime_min"):GetInt(), GetConVar("vj_bmce_zmb_deathtime_max"):GetInt() )

	local randomSpeed = random(1, 165)
	local randomTotalSpeed = random(1, 4)
	-- Choose the appropriate animation tables based on the speed convar
	if zombie_Speed:GetInt() == 0 then
		self.Zombie_Walker = 1
		self.AnimTbl_Walk = ANIM_WALK
		self.AnimTbl_Run = ANIM_WALK
	elseif zombie_Speed:GetInt() == 1 then
		self.Zombie_Runner = 1
		self.AnimTbl_Walk = ANIM_WALK
		self.AnimTbl_Run = ANIM_RUN
	elseif zombie_Speed:GetInt() == 2 then
		self.Zombie_Runner = 1
		self.AnimTbl_Walk = ANIM_RUN
		self.AnimTbl_Run = ANIM_SPRINT
	elseif zombie_Speed:GetInt() == 3 then
		self.Zombie_Runner = 1
		self.AnimTbl_Walk = ANIM_SPRINT
		self.AnimTbl_Run = ANIM_RUN_AIM
	elseif zombie_Speed:GetInt() == 4 then -- Random speed chooser
		if randomSpeed <= 107 then -- Walker (65% chance)
			self.Zombie_Walker = 1
			self.AnimTbl_Walk = ANIM_WALK
			self.AnimTbl_Run = ANIM_WALK
		elseif randomSpeed <= 132 then -- Runner (50% chance)
			self.Zombie_Runner = 1
			self.AnimTbl_Walk = ANIM_WALK
			self.AnimTbl_Run = ANIM_RUN
		elseif randomSpeed <= 149 then -- Sprinter (30% chance)
			self.Zombie_Runner = 1
			self.AnimTbl_Walk = ANIM_RUN
			self.AnimTbl_Run = ANIM_SPRINT
		else -- Super Sprinter (20% chance)
			self.Zombie_Runner = 1
			self.AnimTbl_Walk = ANIM_SPRINT
			self.AnimTbl_Run = ANIM_RUN_AIM
		end

	elseif zombie_Speed:GetInt() == 5 then -- Completly random
		if randomTotalSpeed == 1 then
			self.Zombie_Walker = 1
			self.AnimTbl_Walk = ANIM_WALK
			self.AnimTbl_Run = ANIM_WALK
		elseif randomTotalSpeed == 2 then
			self.Zombie_Runner = 1
			self.AnimTbl_Walk = ANIM_WALK
			self.AnimTbl_Run = ANIM_RUN
		elseif randomTotalSpeed == 3 then
			self.Zombie_Runner = 1
			self.AnimTbl_Walk = ANIM_RUN
			self.AnimTbl_Run = ANIM_SPRINT
		elseif randomTotalSpeed == 4 then
			self.Zombie_Runner = 1
			self.AnimTbl_Walk = ANIM_SPRINT
			self.AnimTbl_Run = ANIM_RUN_AIM
		end
	end

	if GetConVarNumber("vj_bmce_zmb_powerups") == 1 then
		self.ItemDropsOnDeathChance = 15
		self.ItemDropsOnDeath_EntityList = { "zmb_maxammo", "zmb_nuke" }
	end

	if GetConVar( "VJ_LNR_DeathAnimations" ):GetInt() == 0 then 
		self.HasDeathAnimation = false	
	end

	if GetConVar( "VJ_LNR_Alert" ):GetInt() == 0 then 
		self.CallForHelp = false
	end

	if GetConVar( "VJ_LNR_BreakDoors" ):GetInt() == 1 then
		self.LNR_CanBreakDoors = true	 
		self.CanOpenDoors = false
	end

	self:SetupZombie()
	self:Zombie_Difficulty()
	self:EyeGlow()
	self:RandomFaceFlexes()
	
	if GetConVar( "vj_bmce_zmb_riser" ):GetInt() == 1 then
		if self.Zombie_Fire == 1 and GetConVar( "vj_bmce_zmb_burnparticles" ):GetInt() == 1 then return end
		local random_riser = random(1,4)

		if ( random_riser >= 1 and random_riser <= 3 ) then
			self:DirtSpawn( "slow" )
		elseif ( random_riser == 4 ) then
			self:DirtSpawn( "fast" )
		end
	end
end

function ENT:CustomOnAlert(ent)
	-- Disables the custom HLR taunt on alert
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupCrawler()
	self.LNR_Crawler = true
	self.LNR_Crippled = true
	if self.Zombie_Walker then	 
		self.AnimTbl_IdleStand = {ACT_IDLE_STIMULATED}
		self.AnimTbl_Walk = {ACT_WALK_STIMULATED}
		self.AnimTbl_Run = {ACT_WALK_STIMULATED}
	elseif self.Zombie_Runner then
		self.AnimTbl_IdleStand = {ACT_IDLE_AGITATED}
		self.AnimTbl_Walk = {ACT_WALK_AGITATED}
		self.AnimTbl_Run = {ACT_WALK_AGITATED}
	end

	self:SetCollisionBounds(Vector( 13, 13, 25 ), Vector( -13, -13, 0 ) )	
	self.VJC_Data = {
	CameraMode = 1, 
	ThirdP_Offset = Vector( 30, 25, -10 ), 
	FirstP_Bone = "ValveBiped.Bip01_Head1", 
	FirstP_Offset = Vector( 5, 0, -1 ), }
	self:CapabilitiesRemove( bit.bor( CAP_MOVE_JUMP ) )
	self:CapabilitiesRemove( bit.bor( CAP_MOVE_CLIMB ) )
end		
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetEyeColor( eyecolor )
	local colorData = colorTable[ eyecolor ]
	if !colorData then return end

	--local color = colorData.color // UNUSED, used for the trail effects
	local c_string = colorData.c_string

	if !GetConVar("vj_bmce_zmb_eyeglow"):GetBool() then return end

	for i = 1, 2 do
		local eyeglow = ents.Create( "env_sprite" )

		if !spriteTexture:GetBool() then
			eyeglow:SetKeyValue( "model", "models/sprites/eyeglow_sprite.vmt" )
			eyeglow:SetKeyValue( "scale", "0.005" )
		elseif spriteTexture:GetBool() then
			eyeglow:SetKeyValue( "model", "models/sprites/eyeglow_sprite2.vmt" )
			eyeglow:SetKeyValue( "scale", "0.038")
		end

		eyeglow:SetKeyValue( "rendermode", "5" )
		eyeglow:SetKeyValue( "rendercolor", c_string )
		eyeglow:SetKeyValue( "spawnflags", "1" )
		eyeglow:SetParent( self )
		eyeglow:Fire( "SetParentAttachment", i == 1 and "LeftEye" or "RightEye", 0 )
		eyeglow:Spawn()
		eyeglow:Activate()

		-- Too laggy
		--[[ if GetConVar( "vj_bmce_zmb_glowtrail" ):GetInt() == 1 then
			local trailLifetime = 0.125
			local trailStartWidth = 2
			local trailEndWidth = 1.5
			local trailLength = 3
			local texturePath = "VJ_Base/sprites/vj_trial1.vmt"
			util.SpriteTrail( self, i, color, true, trailStartWidth, trailEndWidth, trailLifetime, 1 / trailLength * 0.5, texturePath )
		end ]]

		self:DeleteOnRemove( eyeglow )
	end	

	self.HasEyeGlow = ( eyecolor == "green" or eyecolor == "darkblue" or eyecolor == "bruiser" ) and 1 or 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:EyeGlow()
    local MDL = self:GetModel()
    local color_rnd = random( 1, 2 )
    
    if GetConVar( "vj_bmce_zmb_specialeyecolors" ):GetInt() == 1 then
        if self.Zombie_Bruiser == 1 then 
            self:SetEyeColor( "bruiser" )
        elseif table.HasValue( orangeEyeMdls, MDL ) then
            self:SetEyeColor( "orange" )
		elseif table.HasValue( greenEyeMdls, MDL ) then
            self:SetEyeColor( "green" )
        elseif table.HasValue( blueEyeMdls, MDL ) then
            self:SetEyeColor( "darkblue" )
        else -- If not Bruiser or special model 

            if self.HasEyeGlow == 0 and self.Zombie_Walker then
				if color_rnd == 1 then
					self:SetEyeColor( "orange" )
				elseif color_rnd == 2 then
					self:SetEyeColor( "lightblue" )
				end
			elseif self.Zombie_Runner then
				self:SetEyeColor( "red" )
            end
        end
    else -- If convar is 0, use default
        if table.HasValue( orangeEyeMdls, MDL ) then
            self:SetEyeColor( "orange" )
        else
            if self.Zombie_Walker then

                if color_rnd == 1 then
                    self:SetEyeColor( "orange" )
                elseif color_rnd == 2 then
                    self:SetEyeColor( "lightblue" )
                end

            elseif self.Zombie_Runner then
                self:SetEyeColor( "red" )
            end
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DirtSpawn(spawnType)
	--if self:IsDirt(self:GetPos() ) then
	self:SetNoDraw(true)

	if spawnType == "slow" then
		timer.Simple(0.01,function()
			self:VJ_ACT_PLAYACTIVITY( "vjseq_nz_spawn_climbout_fast", true, 4.55, true, 0, { SequenceDuration= 4.55 } )
			self.MovementType = VJ_MOVETYPE_STATIONARY
			self.HasPoseParameterLooking = false
			--self.DisableFindEnemy = true

			timer.Simple(0.2,function()
				if self:IsValid() then
					self:SetNoDraw( false )
					self:EmitSound( "vj_bmce_zmb/vocals/spawn_dirt_" .. random( 0, 6 ) .. ".mp3" )
					self:PlaySoundSystem( "Alert" )
					local effectdata = EffectData()
					effectdata:SetOrigin( self:GetPos() )
					effectdata:SetScale( 25 )
					util.Effect( "zombie_spawn_dirt", effectdata )
				end
			end)

			timer.Simple(4.25,function()
				self.MovementType = VJ_MOVETYPE_GROUND
				self.HasPoseParameterLooking = true
				--self.DisableFindEnemy = false
			end)
		end)

	elseif spawnType == "fast" then
		timer.Simple( 0.01, function()
			self:VJ_ACT_PLAYACTIVITY( "vjseq_nz_spawn_jump", true, 1.25, true, 0, { SequenceDuration=1.25 } )
			self.HasMeleeAttack = false

			timer.Simple( 0.2, function()
				if self:IsValid() then
					self:SetNoDraw( false )
					self:EmitSound( "vj_bmce_zmb/vocals/spawn_dirt_" .. random( 0, 6 ) .. ".mp3" )
					self:PlaySoundSystem( "Alert" )
					local effectdata = EffectData()
					effectdata:SetOrigin( self:GetPos() )
					effectdata:SetScale( 25 )
					util.Effect( "zombie_spawn_dirt", effectdata )
					self.HasMeleeAttack = true
				end
			end)
		end)
	end
--end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[ function ENT:IsDirt(pos)
	local tr = util.TraceLine({
		start = pos,
		endpos = pos -Vector(0,0,40),
		filter = self,
		mask = MASK_NPCWORLDSTATIC
	})
	local mat = tr.MatType
	return tr.HitWorld && (mat == MAT_SAND || mat == MAT_DIRT || mat == MAT_FOLIAGE || mat == MAT_SLOSH || mat == MAT_GRASS || mat == 74)
end ]]
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "step" then
		self:FootStepSoundCode()
	end

	if key == "infection_step" && self:IsOnGround() then
		local tr = util.TraceLine({
			start = self:GetPos(),
			endpos = self:GetPos() + Vector( 0, 0, -150 ),
			filter = { self }
		})

		if tr.Hit && self.FootSteps[tr.MatType] then
			VJ_EmitSound( self, VJ_PICK( self.FootSteps[tr.MatType] ), self.FootStepSoundLevel, self:VJ_DecideSoundPitch( self.FootStepPitch1, self.FootStepPitch2 ) )
		end
	end

	if key == "slide" then
		VJ_EmitSound( self, "vj_bmce_zmb/vocals/extras/foot_Slide_0" .. random( 0, 2 ) .. ".mp3", self.FootStepSoundLevel, self:VJ_DecideSoundPitch( self.FootStepPitch.a, self.FootStepPitch.b ) )
	end

	if key == "crawl" then
		VJ_EmitSound( self, "vj_bmce_zmb/vocals/extras/crawl_0" .. random( 1, 3 ) .. ".wav", self.FootStepSoundLevel, self:VJ_DecideSoundPitch( self.FootStepPitch.a, self.FootStepPitch.b ) )
	end

	if key == "crawl" && self:WaterLevel() > 0 && self:WaterLevel() < 3 then
		VJ_EmitSound( self, "player/footsteps/wade" .. random( 1, 8 ) .. ".wav", self.FootStepSoundLevel, self:VJ_DecideSoundPitch( self.FootStepPitch.a, self.FootStepPitch.b ) )
	end

	if key == "climb" then
		VJ_EmitSound( self, "player/footsteps/ladder".. random( 1, 4 ) .. ".wav", self.FootStepSoundLevel, self:VJ_DecideSoundPitch( self.FootStepPitch.a, self.FootStepPitch.b ) )
	end

	if key == "attack" then
		self:MeleeAttackCode()		
	end

	if key == "death" then
		VJ_EmitSound( self, "vj_bmce_zmb/vocals/zmb_death_bodyfall_0" .. random( 1, 7 ) .. ".mp3", 75, 100 )
	end

	if key == "death" && self:WaterLevel() > 0 && self:WaterLevel() < 3 then
		VJ_EmitSound( self, "ambient/water/water_splash" .. random( 1, 3 ) .. ".wav", 75, 100 )
	end

	if key == "break_door" then
		if IsValid(self.LNR_DoorToBreak) then
		VJ_EmitSound(self,"vj_bmce_zmb/vocals/extras/snap_0"..random( 5 ) .. ".mp3", 85, 100 )
		
		local doorDmg = self.MeleeAttackDamage
		local door = self.LNR_DoorToBreak
		if door.DoorHealth == nil then
			door.DoorHealth = 200 - doorDmg
		else
			door.DoorHealth = door.DoorHealth - doorDmg
		end

		if door.DoorHealth <= 0 then
			door:EmitSound( "vj_bmce_zmb/vocals/extras/slam_0" .. random( 5 ) .. ".mp3", 90, 100 )
			ParticleEffect( "door_pound_core", door:GetPos(), door:GetAngles(), nil )
			ParticleEffect( "door_explosion_chunks", door:GetPos(), door:GetAngles(), nil )
			door:Remove()
			local doorgibs = ents.Create( "prop_dynamic" )
			doorgibs:SetPos( door:GetPos() )
			doorgibs:SetModel( "models/props_c17/FurnitureDresser001a.mdl" )
			doorgibs:Spawn()
			doorgibs:TakeDamage( 9999 )
			doorgibs:Fire( "break" )
			end
		end
	end	
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.FootSteps = 
{
	-- 74 is Snow, 85 is grass
	[MAT_ANTLION] = {"vj_bmce/footsteps/flesh_step1.mp3","vj_bmce/footsteps/flesh_step2.mp3","vj_bmce/footsteps/flesh_step3.mp3","vj_bmce/footsteps/flesh_step4.mp3","vj_bmce/footsteps/flesh_step5.mp3","vj_bmce/footsteps/flesh_step6.mp3","vj_bmce/footsteps/flesh_step7.mp3","vj_bmce/footsteps/flesh_step8.mp3","vj_bmce/footsteps/flesh_step9.mp3","vj_bmce/footsteps/flesh_step10.mp3"},
	[MAT_BLOODYFLESH] = {"vj_bmce/footsteps/flesh_step1.mp3","vj_bmce/footsteps/flesh_step2.mp3","vj_bmce/footsteps/flesh_step3.mp3","vj_bmce/footsteps/flesh_step4.mp3","vj_bmce/footsteps/flesh_step5.mp3","vj_bmce/footsteps/flesh_step6.mp3","vj_bmce/footsteps/flesh_step7.mp3","vj_bmce/footsteps/flesh_step8.mp3","vj_bmce/footsteps/flesh_step9.mp3","vj_bmce/footsteps/flesh_step10.mp3"},
	[MAT_CONCRETE] = {"vj_bmce_zmb/vocals/extras/foot_Slide_00.mp3","vj_bmce_zmb/vocals/extras/foot_Slide_01.mp3","vj_bmce_zmb/vocals/extras/foot_Slide_02.mp3","vj_bmce/footsteps/concrete_step1.mp3","vj_bmce/footsteps/concrete_step2.mp3","vj_bmce/footsteps/concrete_step3.mp3","vj_bmce/footsteps/concrete_step4.mp3","vj_bmce/footsteps/concrete_step5.mp3","vj_bmce/footsteps/concrete_step6.mp3","vj_bmce/footsteps/concrete_step7.mp3","vj_bmce/footsteps/concrete_step8.mp3","vj_bmce/footsteps/concrete_grit_step1.mp3","vj_bmce/footsteps/concrete_grit_step2.mp3","vj_bmce/footsteps/concrete_grit_step3.mp3","vj_bmce/footsteps/concrete_grit_step4.mp3","vj_bmce/footsteps/concrete_grit_step5.mp3","vj_bmce/footsteps/concrete_grit_step6.mp3","vj_bmce/footsteps/concrete_grit_step7.mp3","vj_bmce/footsteps/concrete_grit_step8.mp3"},
	[MAT_TILE] = {"vj_bmce/footsteps/concrete_step1.mp3","vj_bmce/footsteps/concrete_step2.mp3","vj_bmce/footsteps/concrete_step3.mp3","vj_bmce/footsteps/concrete_step4.mp3","vj_bmce/footsteps/concrete_step5.mp3","vj_bmce/footsteps/concrete_step6.mp3","vj_bmce/footsteps/concrete_step7.mp3","vj_bmce/footsteps/concrete_step8.mp3","vj_bmce/footsteps/concrete_grit_step1.mp3","vj_bmce/footsteps/concrete_grit_step2.mp3","vj_bmce/footsteps/concrete_grit_step3.mp3","vj_bmce/footsteps/concrete_grit_step4.mp3","vj_bmce/footsteps/concrete_grit_step5.mp3","vj_bmce/footsteps/concrete_grit_step6.mp3","vj_bmce/footsteps/concrete_grit_step7.mp3","vj_bmce/footsteps/concrete_grit_step8.mp3"},
	[MAT_DIRT] = {"vj_bmce/footsteps/gravel_step1.mp3","vj_bmce/footsteps/gravel_step2.mp3","vj_bmce/footsteps/gravel_step3.mp3","vj_bmce/footsteps/gravel_step4.mp3","vj_bmce/footsteps/gravel_step5.mp3","vj_bmce/footsteps/gravel_step6.mp3","vj_bmce/footsteps/gravel_step7.mp3","vj_bmce/footsteps/gravel_step8.mp3"},
	[MAT_FLESH] = {"vj_bmce/footsteps/flesh_step1.mp3","vj_bmce/footsteps/flesh_step2.mp3","vj_bmce/footsteps/flesh_step3.mp3","vj_bmce/footsteps/flesh_step4.mp3","vj_bmce/footsteps/flesh_step5.mp3","vj_bmce/footsteps/flesh_step6.mp3","vj_bmce/footsteps/flesh_step7.mp3","vj_bmce/footsteps/flesh_step8.mp3","vj_bmce/footsteps/flesh_step9.mp3","vj_bmce/footsteps/flesh_step10.mp3"},
	[MAT_GRATE] = {"vj_bmce/footsteps/metalgrate_step1.mp3","vj_bmce/footsteps/metalgrate_step2.mp3","vj_bmce/footsteps/metalgrate_step3.mp3","vj_bmce/footsteps/metalgrate_step4.mp3","vj_bmce/footsteps/metalgrate_step5.mp3","vj_bmce/footsteps/metalgrate_step6.mp3","vj_bmce/footsteps/metalgrate_step7.mp3","vj_bmce/footsteps/metalgrate_step8.mp3"},
	[MAT_ALIENFLESH] = {"physics/flesh/flesh_impact_hard1.mp3","physics/flesh/flesh_impact_hard2.mp3","physics/flesh/flesh_impact_hard3.mp3","physics/flesh/flesh_impact_hard4.mp3","physics/flesh/flesh_impact_hard5.mp3","physics/flesh/flesh_impact_hard6.mp3"},
	[74] = {"vj_bmce/footsteps/sand_step1.mp3","vj_bmce/footsteps/sand_step2.mp3","vj_bmce/footsteps/sand_step3.mp3","vj_bmce/footsteps/sand_step4.mp3","vj_bmce/footsteps/sand_step5.mp3","vj_bmce/footsteps/sand_step6.mp3","vj_bmce/footsteps/sand_step7.mp3","vj_bmce/footsteps/sand_step8.mp3"},
	[MAT_PLASTIC] = {"vj_bmce/footsteps/plaster_step1.mp3","vj_bmce/footsteps/plaster_step2.mp3","vj_bmce/footsteps/plaster_step3.mp3","vj_bmce/footsteps/plaster_step4.mp3","vj_bmce/footsteps/plaster_step5.mp3","vj_bmce/footsteps/plaster_step6.mp3","vj_bmce/footsteps/plaster_step7.mp3","vj_bmce/footsteps/plaster_step8.mp3"},
	[MAT_METAL] = {"vj_bmce/footsteps/metalsolid_step1.mp3","vj_bmce/footsteps/metalsolid_step2.mp3","vj_bmce/footsteps/metalsolid_step3.mp3","vj_bmce/footsteps/metalsolid_step4.mp3","vj_bmce/footsteps/metalsolid_step5.mp3","vj_bmce/footsteps/metalsolid_step6.mp3","vj_bmce/footsteps/metalsolid_step7.mp3","vj_bmce/footsteps/metalsolid_step8.mp3"},
	[MAT_SAND] = {"vj_bmce/footsteps/sand_step1.mp3","vj_bmce/footsteps/sand_step2.mp3","vj_bmce/footsteps/sand_step3.mp3","vj_bmce/footsteps/sand_step4.mp3","vj_bmce/footsteps/sand_step5.mp3","vj_bmce/footsteps/sand_step6.mp3","vj_bmce/footsteps/sand_step7.mp3","vj_bmce/footsteps/sand_step8.mp3"},
	[MAT_FOLIAGE] = {"vj_bmce/footsteps/gravel_step1.mp3","vj_bmce/footsteps/gravel_step2.mp3","vj_bmce/footsteps/gravel_step3.mp3","vj_bmce/footsteps/gravel_step4.mp3","vj_bmce/footsteps/gravel_step5.mp3","vj_bmce/footsteps/gravel_step6.mp3","vj_bmce/footsteps/gravel_step7.mp3","vj_bmce/footsteps/gravel_step8.mp3"},
	[MAT_COMPUTER] = {"vj_bmce/footsteps/plaster_step1.mp3","vj_bmce/footsteps/plaster_step2.mp3","vj_bmce/footsteps/plaster_step3.mp3","vj_bmce/footsteps/plaster_step4.mp3","vj_bmce/footsteps/plaster_step5.mp3","vj_bmce/footsteps/plaster_step6.mp3","vj_bmce/footsteps/plaster_step7.mp3","vj_bmce/footsteps/plaster_step8.mp3"},
	[MAT_SLOSH] = {"vj_bmce/footsteps/water_foot_step1.mp3","vj_bmce/footsteps/water_foot_step2.mp3","vj_bmce/footsteps/water_foot_step3.mp3","vj_bmce/footsteps/water_foot_step4.mp3","vj_bmce/footsteps/water_foot_step5.mp3"},
	--[MAT_TILE] = {"vj_bmce/footsteps/plaster_step1.mp3","vj_bmce/footsteps/plaster_step2.mp3","vj_bmce/footsteps/plaster_step3.mp3","vj_bmce/footsteps/plaster_step4.mp3","vj_bmce/footsteps/plaster_step5.mp3","vj_bmce/footsteps/plaster_step6.mp3","vj_bmce/footsteps/plaster_step7.mp3","vj_bmce/footsteps/plaster_step8.mp3"},
	[85] = {"vj_bmce/footsteps/earth_step1.mp3","vj_bmce/footsteps/earth_step2.mp3","vj_bmce/footsteps/earth_step3.mp3","vj_bmce/footsteps/earth_step4.mp3","vj_bmce/footsteps/earth_step5.mp3","vj_bmce/footsteps/earth_step6.mp3","vj_bmce/footsteps/earth_step7.mp3","vj_bmce/footsteps/earth_step8.mp3"},
	[MAT_VENT] = {"vj_bmce/footsteps/metalsolid_step1.mp3","vj_bmce/footsteps/metalsolid_step2.mp3","vj_bmce/footsteps/metalsolid_step3.mp3","vj_bmce/footsteps/metalsolid_step4.mp3","vj_bmce/footsteps/metalsolid_step5.mp3","vj_bmce/footsteps/metalsolid_step6.mp3","vj_bmce/footsteps/metalsolid_step7.mp3","vj_bmce/footsteps/metalsolid_step8.mp3"},
	[MAT_WOOD] = {"vj_bmce/footsteps/wood_step1.mp3","vj_bmce/footsteps/wood_step2.mp3","vj_bmce/footsteps/wood_step3.mp3","vj_bmce/footsteps/wood_step4.mp3","vj_bmce/footsteps/wood_step5.mp3","vj_bmce/footsteps/wood_step6.mp3","vj_bmce/footsteps/wood_step7.mp3","vj_bmce/footsteps/wood_step8.mp3"},
	[MAT_GLASS] = {"vj_bmce/footsteps/glasssolid_step1.mp3","vj_bmce/footsteps/glasssolid_step2.mp3","vj_bmce/footsteps/glasssolid_step3.mp3","vj_bmce/footsteps/glasssolid_step4.mp3","vj_bmce/footsteps/glasssolid_step5.mp3","vj_bmce/footsteps/glasssolid_step6.mp3","vj_bmce/footsteps/glasssolid_step7.mp3","vj_bmce/footsteps/glasssolid_step8.mp3"}
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetSoundPitch()
	self.IdleSoundPitch = VJ_Set( 82, 106 )
	self.CombatIdleSoundPitch = VJ_Set( 82, 106 )
	self.SuppressingPitch = VJ_Set( 82, 106 )
	self.AlertSoundPitch = VJ_Set( 82, 106 )
	self.BeforeMeleeAttackSoundPitch = VJ_Set( 82, 106 )
	self.DeathSoundPitch = VJ_Set( 82, 106 )
	self.InvestigateSoundPitch = VJ_Set( 82, 106 )
	self.LostEnemySoundPitch = VJ_Set( 82, 106 )
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetFireZombie()
	self:EmitSound( "vj_bmce_zmb/vocals/fire_spawn.mp3", 70, random( 82, 110 ) )

	if GetConVar( "vj_bmce_zmb_burnparticles" ):GetInt() == 1 then	
		ParticleEffectAttach( "smoke_exhaust_01a", PATTACH_POINT_FOLLOW, self, 10 )
		ParticleEffectAttach( "fire_small_01", PATTACH_POINT_FOLLOW, self, 14 )
		self.SoundTbl_Breath = { "vj_bmce_zmb/vocals/fire_idle.mp3" }
		self.Zombie_Fire = 1
		self.BreathSoundLevel = 65
	elseif GetConVar( "vj_bmce_zmb_burnparticles" ):GetInt() == 2 then
		ParticleEffectAttach( "smoke_exhaust_01a", PATTACH_POINT_FOLLOW, self, 10 )
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupZombie()
	local MDL = self:GetModel()
	local Bruiser_Chance = random( 1, 3 )
	local Hat_Chance = random( 1, 3 )
	local Unique_Hat = random( 1, 3 )

	self.EntitiesToNoCollide = {
		"npc_vj_bmce_und_constwrk",
		"npc_vj_bmce_und_custodian_male",
		"npc_vj_bmce_und_cw_fem",
		"npc_vj_bmce_und_cw_male",
		"npc_vj_bmce_und_fireman",
		"npc_vj_bmce_und_guard_fem",
		"npc_vj_bmce_und_guard_male",
		"npc_vj_bmce_und_hgrunt_male",
		"npc_vj_bmce_und_offworker_fem",
		"npc_vj_bmce_und_sci_cas_male",
		"npc_vj_bmce_und_sci_male",
		"npc_vj_bmce_und_cwork_male"
	}

	if MDL == "models/undead/scientist.mdl" or MDL == "models/undead/scientist_02.mdl" then
		self:ZombieVoice( "male" )
		self:SetSkin( random( 0, 14 ) )
		self:SetBodygroup( 1, random( 0, 2 ) ) -- Body
		self:SetBodygroup( 2, random( 0, 7 ) ) -- Ties
		if Hat_Chance == 1 then self:SetBodygroup( 2, random( 0, 2 ) ) end

	elseif MDL == "models/undead/scientist_burned.mdl" then
		self:SetFireZombie()
		self:ZombieVoice( "male" )
		self:SetSkin( random( 0, 15 ) )
	end

	if MDL == "models/undead/scientist_casual.mdl" or MDL == "models/undead/scientist_casual_02.mdl" or MDL == "models/undead/scientist_casual_03.mdl" then
		self:ZombieVoice( "male" )
		self:SetSkin( random( 0, 14 ) )
		self:SetBodygroup( 1, random( 0, 5 ) ) -- Body
		self:SetBodygroup( 3, random( 0, 8 ) ) -- Torso
		if Hat_Chance == 1 then self:SetBodygroup( 2, random( 0, 3 ) ) end
	end

	if MDL == "models/undead/guard.mdl" or MDL == "models/undead/guard_02.mdl" or MDL == "models/undead/guard_03.mdl" then
		self:SetSkin( random( 0, 14 ) )
		self:SetBodygroup( 1, random( 0, 3 ) ) -- Body
		self:SetBodygroup( 3, random( 0, 3 ) ) -- Chest
		self:SetBodygroup( 4, random( 0, 2 ) ) -- holster

		if Unique_Hat == 1 then
			self.BMCE_Hat = 1
		else
			self:SetBodygroup( 2, random( 0, 5 ) )
		end
		
		if GetConVar("vj_bmce_zmb_bruisers"):GetInt() == 1 then
			if (Bruiser_Chance >= 1 and Bruiser_Chance <= 2) then
				self:ZombieVoice( "male" )
			elseif Bruiser_Chance == 3 then
				self:ZombieVoice( "bruiser" )
			end
		else
			self:ZombieVoice( "male" )
		end

	elseif MDL == "models/undead/guard_burned.mdl" then
		self:SetFireZombie()
		self:SetSkin( random( 0, 15 ) )
		self:SetBodygroup( 1, random( 0, 3 ) ) -- Body
		self:SetBodygroup( 2, random( 0, 5 ) ) -- hat
		self:SetBodygroup( 3, random( 0, 3 ) ) -- Chest
		self:SetBodygroup( 4, random( 0, 2 ) ) -- holster
		self:ZombieVoice( "male" )
	end

	if MDL == "models/undead/guard_female.mdl" then
		self:ZombieVoice( "female" )
		self:SetSkin( random( 0, 9 ) )
		self:SetBodygroup( 1, random( 0, 1 ) ) -- Body
		self:SetBodygroup( 3, random( 0, 10 ) ) -- Hats
		self:SetBodygroup( 4, random( 0, 2 ) ) -- Chest
		self:SetBodygroup( 5, random( 0, 2 ) ) -- holster
		
	end

	if MDL == "models/undead/fem_office_worker.mdl" then
		self:ZombieVoice( "female" )
		self:SetSkin( random( 0, 35 ) )
		self:SetBodygroup( 1, random( 0, 1 ) ) -- Body
		self:SetBodygroup( 2, random( 0, 5 ) ) -- Hair
	end

	if MDL == "models/undead/cafeteria_female.mdl" then
		self:ZombieVoice( "female" )
		self:SetSkin( random( 0, 9 ) )
		self:SetBodygroup( 1, random( 0, 3 ) ) -- Body
		self:SetBodygroup( 2, random( 0, 1 ) ) -- Apron
		self:SetBodygroup( 3, random( 0, 7 ) ) -- Hair
	end

	if MDL == "models/undead/custodian.mdl" then
		self:ZombieVoice( "male" )
		self:SetSkin( random( 0, 17 ) )
		self:SetBodygroup( 1, random( 0, 7 ) ) -- Body
		self:SetBodygroup( 2, random( 0, 4 ) ) -- Hat
		self:SetBodygroup( 3, random( 0, 1 ) ) -- Vest
	end

	if MDL == "models/undead/construction_worker.mdl" then
		self:SetSkin(random( 0, 19 ) )
		self:SetBodygroup(1,random( 0, 3 ) ) -- t-shirts
		self:SetBodygroup(2,random( 0, 3 ) ) -- pants
		self:SetBodygroup(3,random( 0, 1 ) ) -- shows
		self:SetBodygroup(5,random( 3, 14 ) ) -- Glasses
		if Hat_Chance == 1 then self:SetBodygroup( 4, random( 0, 4 ) ) end

		if GetConVar( "vj_bmce_zmb_bruisers" ):GetInt() == 1 then
			if ( Bruiser_Chance >= 1 and Bruiser_Chance <= 2 ) then
				self:ZombieVoice( "male" )
			elseif Bruiser_Chance == 3 then
				self:ZombieVoice( "bruiser" )
			end
		else
			self:ZombieVoice( "male" )
		end
	end

	if MDL == "models/undead/fireman.mdl" then
		self:SetSkin( random( 0, 30 ) )
		self:SetBodygroup( 1, random( 0, 3 ) ) -- Body
		self:SetBodygroup( 2, random( 0, 1 ) ) -- gloves
		self:SetBodygroup( 3, random( 0, 3 ) ) -- face
		self:SetBodygroup( 4, random( 0, 3 ) ) -- helmet
		self:SetBodygroup( 5, random( 0, 1 ) ) -- tank rig

		if GetConVar( "vj_bmce_zmb_bruisers" ):GetInt() == 1 then
			if ( Bruiser_Chance >= 1 and Bruiser_Chance <= 2 ) then
				self:ZombieVoice( "male" )
			elseif Bruiser_Chance == 3 then
				self:ZombieVoice( "bruiser" )
			end
		else
			self:ZombieVoice( "male" )
		end
	end

	if MDL == "models/undead/marine.mdl" or MDL == "models/undead/marine_02.mdl" then
		local hat = random( 1, 1 )
		self:SetSkin( random( 0, 19 ) )

		if Unique_Hat == 1 then
			if hat == 1 then
				self.BMCE_Hat = 2
				self:GiveUniqueHat()
			end
--[[ 			elseif hat == 2 then
				self.BMCE_Hat = 3
				self:GiveUniqueHat()
			elseif hat == 3 then
				self.BMCE_Hat = 4
				self:GiveUniqueHat()
			elseif hat == 4 then
				self.BMCE_Hat = 5
				self:GiveUniqueHat()
			end ]]
		end

		if (Unique_Hat >= 2 and Unique_Hat <= 3) then
			if Hat_Chance == 1 then 
				self:SetBodygroup( 3, random( 1, 3 ) ) -- NV
				self:SetBodygroup( 5, random( 1, 2 ) ) -- helmet
			elseif Hat_Chance == 2 then 
				self:SetBodygroup( 5, 3 ) -- helmet
			end
		end

		self:SetBodygroup( 1, random( 0, 1 ) ) -- Body
		self:SetBodygroup( 2, random( 0, 1 ) ) -- gloves
		self:SetBodygroup( 4, random( 0, 1 ) ) -- headset
		self:SetBodygroup( 6, random( 0, 1 ) ) -- pack chest
		self:SetBodygroup( 7, random( 0, 1 ) ) -- pack hips
		self:SetBodygroup( 8, random( 0, 1 ) ) -- pack thigh

		if GetConVar("vj_bmce_zmb_bruisers"):GetBool() and Bruiser_Chance >= 1 and Bruiser_Chance <= 2 then
			self:ZombieVoice("male")
		elseif GetConVar("vj_bmce_zmb_bruisers"):GetBool() and Bruiser_Chance == 3 then
			self:ZombieVoice("bruiser")
		else
			self:ZombieVoice("male")
		end
		
	elseif MDL == "models/undead/marine_burned.mdl" then
		self:SetFireZombie()
		self:SetSkin( random( 0, 15 ) )
		self:SetBodygroup( 1, random( 0, 1 ) ) -- Body
		self:SetBodygroup( 2, random( 0, 1 ) ) -- gloves
		self:SetBodygroup( 5, random( 0, 2 ) ) -- helmet
		self:SetBodygroup( 6, random( 0, 1 ) ) -- pack chest
		self:SetBodygroup( 7, random( 0, 1 ) ) -- pack hips
		self:SetBodygroup( 8, random( 0, 1 ) ) -- pack thigh
		self:ZombieVoice( "male" )
	end

	if MDL == "models/undead/cafeteria_male.mdl" then
		self:ZombieVoice( "male" )
		self:SetSkin( random( 0, 14 ) )
		self:SetBodygroup( 1, random( 0, 7 ) ) -- Body
		self:SetBodygroup( 2, random( 0, 3 ) ) -- helmet
		self:SetBodygroup( 3, random( 0, 4 ) ) -- chest
	end

	if MDL == "models/undead/cafeteria_male_02.mdl" then
		self:ZombieVoice( "male" )
		self:SetSkin( random( 0, 15 ) )
		self:SetBodygroup( 1, random( 0, 3 ) ) -- Body
		self:SetBodygroup( 2, random( 0, 3 ) ) -- helmet
		self:SetBodygroup( 3, random( 0, 1 ) ) -- chest
		self:SetBodygroup( 4, random( 0, 1 ) ) -- flashlight
	end

	if MDL == "models/undead/cwork.mdl" then
		self:SetSkin( random( 0, 16 ) )
		self:SetBodygroup( 1, random( 0, 11 ) ) -- Body
		self:SetBodygroup( 2, random( 0, 3 ) ) -- helmet
		self:SetBodygroup( 3, random( 0, 1 ) ) -- vest

		if GetConVar( "vj_bmce_zmb_bruisers" ):GetInt() == 1 then
			if ( Bruiser_Chance >= 1 and Bruiser_Chance <= 2 ) then
				self:ZombieVoice( "male" )
			elseif Bruiser_Chance == 3 then
				self:ZombieVoice( "bruiser" )
			end
		else
			self:ZombieVoice( "male" )
		end
	end

	if (self.BMCE_Hat >= 1) then self:GiveUniqueHat() end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GiveUniqueHat()
	self.HasDeathAnimation = false

	if self.BMCE_Hat == 1 then -- SecGuard Beret
		self.Hat = ents.Create( "prop_physics" )
		self.Hat:SetModel( "models/humans/props/guard_beret.mdl" )
		self.Hat:SetLocalPos( self:GetPos() )
		self.Hat:SetOwner( self )
		self.Hat:SetParent( self )
		self.Hat:Fire( "SetParentAttachment", "eyes" )
		self.Hat:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE )
		self.Hat:Spawn()
		self.Hat:Activate()
		self.Hat:SetSolid( SOLID_NONE )
		self.Hat:AddEffects( EF_BONEMERGE )
		self:SetBodygroup( 2, 1 ) -- Hats (no hat)
	end

	if self.BMCE_Hat == 2 then -- HECU Beret
		self.Hat = ents.Create( "prop_physics" )
		self.Hat:SetModel( "models/humans/props/marine_beret.mdl" )
		self.Hat:SetLocalPos( self:GetPos() )
		self.Hat:SetOwner( self )
		self.Hat:SetParent( self )
		self.Hat:Fire( "SetParentAttachment", "eyes" )
		self.Hat:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE )
		self.Hat:Spawn()
		self.Hat:Activate()
		self.Hat:SetSolid( SOLID_NONE )
		self.Hat:AddEffects( EF_BONEMERGE )
		self:SetBodygroup( 3, 0 ) -- NV
		self:SetBodygroup( 4, 0 ) -- headset
		self:SetBodygroup( 5, 0 ) -- helmet
	end

	if self.BMCE_Hat == 3 then -- HECU Bonnie
		self.Hat = ents.Create( "prop_physics" )
		self.Hat:SetModel( "models/humans/props/marine_boonie.mdl" )
		self.Hat:SetLocalPos( self:GetPos() )
		self.Hat:SetOwner( self )
		self.Hat:SetParent( self )
		self.Hat:Fire( "SetParentAttachment", "eyes" )
		self.Hat:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE )
		self.Hat:Spawn()
		self.Hat:Activate()
		self.Hat:SetSolid( SOLID_NONE )
		self.Hat:AddEffects( EF_BONEMERGE )
		self:SetBodygroup( 3, 0 ) -- NV
		self:SetBodygroup( 4, 0 ) -- headset
		self:SetBodygroup( 5, 0 ) -- helmet
	end

	if self.BMCE_Hat == 4 then -- HECU 8point
		self.Hat = ents.Create( "prop_physics" )
		self.Hat:SetModel( "models/humans/props/marine_8point.mdl" )
		self.Hat:SetLocalPos( self:GetPos() )
		self.Hat:SetOwner( self )
		self.Hat:SetParent( self )
		self.Hat:Fire( "SetParentAttachment", "eyes" )
		self.Hat:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE )
		self.Hat:Spawn()
		self.Hat:Activate()
		self.Hat:SetSolid( SOLID_NONE )
		self.Hat:AddEffects( EF_BONEMERGE )
		self:SetBodygroup( 3, 0 ) -- NV
		self:SetBodygroup( 4, 0 ) -- headset
		self:SetBodygroup( 5, 0 ) -- helmet
	end

	if self.BMCE_Hat == 5 then -- HECU Cap
		self.Hat = ents.Create( "prop_physics" )
		self.Hat:SetModel( "models/humans/props/marine_grenadier_cap2.mdl" )
		self.Hat:SetLocalPos( self:GetPos() )
		self.Hat:SetOwner( self )
		self.Hat:SetParent( self )
		self.Hat:Fire( "SetParentAttachment", "eyes" )
		self.Hat:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE )
		self.Hat:Spawn()
		self.Hat:Activate()
		self.Hat:SetSolid( SOLID_NONE )
		self.Hat:AddEffects( EF_BONEMERGE )
		self:SetBodygroup( 3, 0 ) -- NV
		self:SetBodygroup( 4, 0 ) -- headset
		self:SetBodygroup( 5, 0 ) -- helmet
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZombieWeapons()
	if GetConVar( "VJ_LNR_MeleeWeapons" ):GetInt() == 0 or self.LNR_Crawler then self.LNR_CanUseWeapon = false return end
	if self.LNR_CanUseWeapon then
		local Weapon = random( 1, 1 )
		self.WeaponModel = ents.Create( "prop_physics" )
		if Weapon == 1 then
			self.WeaponModel:SetModel( "models/weapons/bmce_weapons/bmce_shotgun/w_shotgun.mdl" )
		end
		self.WeaponModel:SetLocalPos( self:GetPos() )
		self.WeaponModel:SetLocalAngles( self:GetAngles() )			
		self.WeaponModel:SetOwner( self )
		self.WeaponModel:SetParent( self )
		self.WeaponModel:Fire( "SetParentAttachmentMaintainOffset", "anim_attachment_LH" )
		self.WeaponModel:Fire( "SetParentAttachment", "anim_attachment_RH" )
		self.WeaponModel:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
		self.WeaponModel:Spawn()
		self.WeaponModel:Activate()
		self.WeaponModel:SetSolid( SOLID_NONE )
		self.WeaponModel:AddEffects( EF_BONEMERGE )
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local difficulties = {
    { -- Easy
        normal = {
            startHealth = 150,
            meleeAttackDamage = {min = 5, max = 10, withWeapon = {min = 10, max = 15}}
        },
        bruiser = {
            startHealth = 250,
            meleeAttackDamage = {min = 8, max = 12, withWeapon = {min = 10, max = 15}}
        }
    },
    { -- Normal
        normal = {
            startHealth = 225,
            meleeAttackDamage = {min = 10, max = 15, withWeapon = {min = 15, max = 20}}
        },
        bruiser = {
            startHealth = 325,
            meleeAttackDamage = {min = 12, max = 16, withWeapon = {min = 15, max = 20}}
        }
    },
    { -- Hard
        normal = {
            startHealth = 250,
            meleeAttackDamage = {min = 15, max = 20, withWeapon = {min = 20, max = 25}}
        },
        bruiser = {
            startHealth = 400,
            meleeAttackDamage = {min = 16, max = 22, withWeapon = {min = 20, max = 25}}
        }
    },
    { -- Nightmare
        normal = {
            startHealth = 300,
            meleeAttackDamage = {min = 20, max = 25, withWeapon = {min = 25, max = 30}}
        },
        bruiser = {
            startHealth = 450,
            meleeAttackDamage = {min = 22, max = 26, withWeapon = {min = 25, max = 30}}
        }
    },
    { -- Apocalypse
        normal = {
            startHealth = 400,
            meleeAttackDamage = {min = 25, max = 30, withWeapon = {min = 30, max = 35}}
        },
        bruiser = {
            startHealth = 500,
            meleeAttackDamage = {min = 26, max = 30, withWeapon = {min = 30, max = 35}}
        }
    }
}

function ENT:Zombie_Difficulty()
    local difficultyConvar = GetConVar("VJ_LNR_Difficulty"):GetInt()
    local difficulty = difficulties[difficultyConvar]

    if self.Zombie_Bruiser == 1 then
        difficulty = difficulty.bruiser
    else
        difficulty = difficulty.normal
    end

    self.StartHealth = difficulty.startHealth
    self.MeleeAttackDamage = rand(difficulty.meleeAttackDamage.min, difficulty.meleeAttackDamage.max)

    if self.LNR_CanUseWeapon then
        self.MeleeAttackDamage = rand(difficulty.meleeAttackDamage.withWeapon.min, difficulty.meleeAttackDamage.withWeapon.max)
    end

    self:SetHealth(self.StartHealth)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo,hitgroup)		
	if self:GetActivity() == ACT_GLIDE or self.LNR_Crawler or self.LNR_Crippled or self.Flinching or self:GetSequence() == self:LookupSequence( "nz_spawn_climbout_fast" ) or self:GetSequence() == self:LookupSequence( "nz_spawn_jump" ) or self:GetSequence() == self:LookupSequence( "shove_forward_01" ) or self:GetSequence() == self:LookupSequence( "infectionrise" ) or self:GetSequence() == self:LookupSequence( "infectionrise2" ) or self:GetSequence() == self:LookupSequence( "slumprise_a" ) or self:GetSequence() == self:LookupSequence( "slumprise_a2" ) then self.HasDeathAnimation = false end
	if IsValid( self.WeaponModel ) && self.LNR_CanUseWeapon then
	   self:CreateGibEntity( "prop_physics", self.WeaponModel:GetModel(), { Pos=self:GetAttachment( self:LookupAttachment( "anim_attachment_RH" ) ) .Pos, Ang = self:GetAngles(), Vel = "UseDamageForce" } )
	   self.WeaponModel:SetMaterial( "lnr/bonemerge" ) 
	   self.WeaponModel:DrawShadow( false )
	end

	if self.Zombie_Fire == 1 then
		VJ_EmitSound( self, "vj_bmce_zmb/vocals/fire_death_" .. random( 0, 1 ) .. ".mp3", 80)
		local effectExp = EffectData()
		effectExp:SetOrigin( self:GetPos() )
		ParticleEffect( "explosionTrail_seeds_mvm", self:GetPos(), self:GetAngles() )
		util.Effect( "HelicopterMegaBomb", effectExp )

		local explo_dmg = random(1,5)
		if GetConVar( "vj_bmce_zmb_explode" ):GetInt() == 1 and ( explo_dmg >= 1 and explo_dmg <= 2 ) then
			--util.BlastDamage( self, self, self:GetPos(), 175, 50 )
			util.BlastDamage( self, self, self:GetPos(), 250, 200 )
		end
	end

	if dmginfo:IsDamageType(DMG_SHOCK) then -- When killed by shock damage
		self.DeathAnimationChance = 1
		VJ_CreateSound(self, self.SoundTbl_DeathElec, 100, 90)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	if hitgroup == HITGROUP_HEAD then
		if GetConVar( "VJ_LNR_Headshot" ):GetInt() == 0 then
			dmginfo:ScaleDamage( 2 )
		elseif GetConVar( "VJ_LNR_Headshot" ):GetInt() == 1 then
			dmginfo:ScaleDamage( 200 )
		end

		self:EmitSound( "vj_bmce_zmb/vocals/headshot_" .. random( 0, 6 ) .. ".mp3" )
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	if self:IsDefaultGibDamageType( dmginfo:GetDamageType() ) then end

--[[ 	local bloodeffect_headshot = EffectData()
	bloodeffect_headshot:SetOrigin( self:LocalToWorld(Vector( 0, 0, 50 ) ) )
	bloodeffect_headshot:SetColor( VJ_Color2Byte( Color( 130, 19, 10 ) ) )
	bloodeffect_headshot:SetScale( 32 )
	util.Effect( "VJ_Blood1",bloodeffect_headshot )
		
	local bloodspray_headshot = EffectData()
	bloodspray_headshot:SetOrigin( self:LocalToWorld( Vector( 0, 0, 50 ) ) )
	bloodspray_headshot:SetScale( 5 )
	bloodspray_headshot:SetFlags( 3 )
	bloodspray_headshot:SetColor( 0 )
	util.Effect( "bloodspray", bloodspray_headshot ) ]]

	if hitgroup == HITGROUP_HEAD then
		if random( 1, 4 ) == 1 then
			self:EmitSound( "vj_bmce_zmb/vocals/headshot_" .. random( 0, 6 ) .. ".mp3" )
		end
	end

--[[ 	if self.LNR_Crawler then
		local bloodeffect = EffectData()
		bloodeffect:SetOrigin( self:LocalToWorld( Vector( 0, 0, 25 ) ) )
		bloodeffect:SetColor( VJ_Color2Byte( Color( 130, 19, 10 ) ) )
		bloodeffect:SetScale( 32 )
		util.Effect( "VJ_Blood1", bloodeffect )
			
		local bloodspray = EffectData()
		bloodspray:SetOrigin( self:LocalToWorld( Vector( 0, 0, 25 ) ) )
		bloodspray:SetScale( 5 )
		bloodspray:SetFlags( 3 )
		bloodspray:SetColor( 0 )
		util.Effect( "bloodspray", bloodspray )
	else -- IF NOT CRAWLER
		local bloodeffect = EffectData()
		bloodeffect:SetOrigin( self:LocalToWorld(Vector( 0, 0, 50 ) ) )
		bloodeffect:SetColor( VJ_Color2Byte( Color( 130, 19, 10 ) ) )
		bloodeffect:SetScale( 32 )
		util.Effect( "VJ_Blood1", bloodeffect )
			
		local bloodspray = EffectData()
		bloodspray:SetOrigin( self:LocalToWorld( Vector( 0, 0, 50 ) ) )
		bloodspray:SetScale( 5 )
		bloodspray:SetFlags( 3 )
		bloodspray:SetColor( 0 )
		util.Effect( "bloodspray", bloodspray )
	end ]]

--[[ 	if hitgroup == HITGROUP_HEAD && !self.LNR_Crawler then
		if random( 1, 10 ) == 1 then
			
			self:CreateGibEntity( "obj_vj_gib", "models/gibs/humans/sgib_01.mdl", {BloodDecal = "VJ_LNR_Blood_Red", Pos = self:GetAttachment( self:LookupAttachment( "head_gib" ) ) .Pos } )
			self:CreateGibEntity( "obj_vj_gib", "models/gibs/humans/sgib_02.mdl", {BloodDecal = "VJ_LNR_Blood_Red", Pos = self:GetAttachment( self:LookupAttachment( "head_gib" ) ) .Pos } )
			self:CreateGibEntity( "obj_vj_gib", "models/gibs/humans/sgib_01.mdl", {BloodDecal = "VJ_LNR_Blood_Red", Pos = self:GetAttachment( self:LookupAttachment( "head_gib" ) ) .Pos } )
			self:CreateGibEntity( "obj_vj_gib", "models/gibs/humans/sgib_02.mdl", {BloodDecal = "VJ_LNR_Blood_Red", Pos = self:GetAttachment( self:LookupAttachment( "head_gib" ) ) .Pos } )
			self:CreateGibEntity( "obj_vj_gib", "models/gibs/humans/sgib_02.mdl", {BloodDecal = "VJ_LNR_Blood_Red", Pos = self:GetAttachment( self:LookupAttachment( "head_gib" ) ) .Pos } )
		--end
		
			self:EmitSound( "vj_bmce_zmb/vocals/headshot_" .. random( 0, 6 ) .. ".mp3" )
			self.HasDeathAnimation = false

			self.LNR_Gibbed = true
			ParticleEffect( "lnr_blood_impact_boom", self:GetAttachment( self:LookupAttachment( "eyes" ) ) .Pos, self:GetAngles() )
			VJ_EmitSound( self, "vj_lnrhl2/shared/zombie_neck_drain_0" .. random( 1, 3 ) .. ".wav", 60, 100 )
			local BleedOut = ents.Create( "info_particle_system" )
			BleedOut:SetKeyValue( "effect_name", "lnr_headshot_blood_splats" )
			BleedOut:SetPos( self:GetAttachment( self:LookupAttachment( "forward" ) ) .Pos )
			BleedOut:SetAngles(self:GetAttachment( self:LookupAttachment( "forward" ) ) .Ang )
			BleedOut:SetParent( self )
			BleedOut:Fire( "SetParentAttachment", "forward" )
			BleedOut:Spawn()
			BleedOut:Activate()
			BleedOut:Fire( "Start", "", 0 )
			BleedOut:Fire( "Kill", "", 8 )
		end
	end ]]
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,corpseEnt)
	VJ_LNR_ApplyCorpseEffects(self,corpseEnt)

	if GetConVar( "VJ_LNR_Gib" ):GetInt() == 1 then
		if self.LNR_Gibbed then
			VJ_EmitSound( corpseEnt, "vj_lnrhl2/shared/zombie_neck_drain_0" .. random( 1, 3 ) .. ".wav", 60, 100 )
			local BleedOut = ents.Create( "info_particle_system" )	
			if hitgroup == HITGROUP_HEAD then
				BleedOut:SetPos( corpseEnt:GetAttachment( corpseEnt:LookupAttachment( "forward" ) ) .Pos )
				BleedOut:SetAngles( corpseEnt:GetAttachment( corpseEnt:LookupAttachment( "forward" ) ) .Ang )
				BleedOut:Fire( "SetParentAttachment", "forward" )
				BleedOut:SetKeyValue( "effect_name", "lnr_head_s" )
				BleedOut:SetParent( corpseEnt )
				BleedOut:Spawn()
				BleedOut:Activate()
				BleedOut:Fire( "Start", "", 0 )
				BleedOut:Fire( "Kill", "", 8 )
			end	
		end
	end

	if self.BMCE_Hat == 1 then
		self:CreateExtraDeathCorpse( "prop_physics", "models/humans/props/guard_beret.mdl", { Pos = self:LocalToWorld( Vector( 0, 0, -2 ) ) } )
	elseif self.BMCE_Hat == 2 then
		self:CreateExtraDeathCorpse( "prop_physics", "models/humans/props/marine_beret.mdl", { Pos = self:LocalToWorld( Vector( 0, 0, -2 ) ) } )
	elseif self.BMCE_Hat == 3 then
		self:CreateExtraDeathCorpse( "prop_physics", "models/humans/props/marine_boonie.mdl", { Pos = self:LocalToWorld(Vector(0,0,-2) ) } )
	elseif self.BMCE_Hat == 4 then
		self:CreateExtraDeathCorpse( "prop_physics","models/humans/props/marine_8point.mdl", { Pos = self:LocalToWorld( Vector( 0, 0, -2 ) ) } )
	elseif self.BMCE_Hat == 5 then
		self:CreateExtraDeathCorpse( "prop_physics","models/humans/props/marine_grenadier_cap2.mdl", { Pos = self:LocalToWorld( Vector( 0, 0, -2 ) ) } )
	end

	if self.Zombie_Fire == 1 then
		if GetConVar( "vj_bmce_zmb_burnparticles" ):GetInt() == 1 then	
			ParticleEffectAttach( "smoke_exhaust_01a", PATTACH_POINT_FOLLOW, corpseEnt, 10 )
		end
	end
	
	local faceFlexWeights = {
		{ -- Blink, Lower Lip, Cigar
			{index = 9, weight = 1},
			{index = 43, weight = 1},
			{index = 79, weight = 0.25}
		},
		{ -- Blink, Lower Lip
			{index = 9, weight = 0.25},
			{index = 43, weight = 0.25}
		},
		{ -- Blink, Lower Lip
			{index = 9, weight = 0.6},
			{index = 43, weight = 0.18}
		},
		{ -- Blink, Lower Lip, Cigar
			{index = 9, weight = 0.75},
			{index = 43, weight = 0.35},
			{index = 79, weight = 0.5}
		},
		{ -- Blink, Lower Lip, Cigar
			{index = 9, weight = 0.4},
			{index = 43, weight = 0.6},
			{index = 79, weight = 0.8}
		},
		{ -- Blink
			{index = 9, weight = 0.2}
		},
		{ -- Blink
			{index = 9, weight = 0.4}
		},
		{ -- Blink
			{index = 9, weight = 0.6}
		},
		{ -- left lid closer, left cheek raiser
			{index = 7, weight = 0.75},
			{index = 18, weight = 0.9}
		},
		{ -- No forward open (more angry)
			{index = 7, weight = 0.41},
			{index = 9, weight = 0.18},
			{index = 18, weight = 0.34},
			{index = 35, weight = 0.24},
			{index = 36, weight = 0.30},
			{index = 37, weight = 1.0},
			{index = 43, weight = 1.0},
			{index = 44, weight = 1.0},
			{index = 79, weight = 0.53},
			{index = 80, weight = 0.2}
		}
	}

    local faceFlexRand = random( 1, 10 )
    local hairPuffRand = rand( 0.0, 0.2 )

    corpseEnt:SetFlexWeight( 80, hairPuffRand ) -- Hairline puff

    if faceFlexRand > #faceFlexWeights then
        faceFlexRand = #faceFlexWeights
    end

    for _, weight in ipairs( faceFlexWeights[faceFlexRand] ) do
        corpseEnt:SetFlexWeight( weight.index, weight.weight )
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RandomFaceFlexes()
	local flexWeights = 
	{
		{
			{80, 0.0}, -- Hairline puff
			{43, 0.5}, -- Lower Lip
			{44, 1.25}, -- Brow H
			{35, 0.62}, -- Bite
		},
		{
			{80, 0.0}, -- Hairline puff
			{43, 0.2}, -- Lower Lip
			{44, 1.25}, -- Brow H
			{35, 1.6}, -- Bite
		},
		{
			{80, 0.0}, -- Hairline puff
			{9, -3.5}, -- Blink
			{25, 1.0}, -- Left corner depressor
			{43, 3.0}, -- Lower Lip
			{35, 0.62}, -- Bite
			{44, 1.0}, -- Brow H
		},
		{
			{80, 0.0}, -- Hairline puff
			{44, 1.0}, -- Brow H
		},
		{
			{80, 0.0}, -- Hairline puff
			{44, 1.6}, -- Brow H
		},
		{
			{7, 0.41}, -- Left Lid Closer
			{9, 0.18}, -- Blink
			{18, 0.34}, -- Wrinkler
			{35, 0.24}, -- Bite
			{36, 0.30}, -- Presser
			{37, 1.0}, -- Tightener
			{43, 1.0}, -- Lower Lip
			{44, 1.0}, -- Brow H
			{79, 0.53}, -- Cigar
			{80, 0.2}, -- Hairline puff
		},
		{
			{0, 1.0}, -- Right Lid Raiser
			{1, 1.0}, -- Left Lid Raiser
			{6, 0.28}, -- Right Lid Closer
			{7, 0.09}, -- Left Lid Closer
			{12, 1.0}, -- Right Outer Raiser
			{13, 0.84}, -- Left Outer Raiser
			{20, 0.01}, -- Right Upper Raiser
			{35, 0.51}, -- Bite
			{42, 0.47}, -- Smile
			{43, 1.0}, -- Lower Lip
			{44, 0.4}, -- Brow H
			{79, 0.56}, -- Cigar
		},
		{
			{13, 0.42}, -- Left Outer Raiser
			{14, 1.0}, -- Right Lowerer 
			{14, 0.47}, -- Left Lowerer
			{15, 0.22}, -- Right Cheek Raiser
			{16, 0.31}, -- Left Cheek Raiser
			{35, 0.72}, -- Bite
			{36, 0.46}, -- Presser
			{42, 2.0}, -- Smile
			{44, 0.47}, -- Brow H
			{79, 0.1}, -- Cigar
		},
	}

	local weights = flexWeights[ random( #flexWeights ) ]

	for _, weight in ipairs( weights ) do
		self:SetFlexWeight( weight[1], weight[2] )
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if GetConVar( "vj_bmce_zmb_deathrandom" ):GetInt() == 1 then
		if CurTime() > self.Zombie_EnergyTime then
			self:EmitSound( "vj_bmce_zmb/vocals/headshot_" .. random( 0, 6 ) .. ".mp3" )
			self:PlaySoundSystem( "Death" )
			self.HasDeathSounds = false
			self.DeathAnimationTime = 0.3
			self.DeathAnimationChance = 1

			if IsValid( self ) then
				self:TakeDamage( self:Health(), self, self )
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZombieVoice(voicetype) -- Used to determine gender
	-- Nill is used on 4, which randomizes the voiceset
	-- RDR_VoiceType assigns what gender to use 
	if voicetype == "male" then
		self.RDR_VoiceType = 1
		if voiceset:GetInt() == 0 then
			self:ZombieVoiceSet( "undeadnightmares" )
		elseif voiceset:GetInt() == 1 then
			self:ZombieVoiceSet( "classic" )
		elseif voiceset:GetInt() == 2 then
			self:ZombieVoiceSet( "blackops3" )
		elseif voiceset:GetInt() == 3 then
			self:ZombieVoiceSet( "coldwar" )
		elseif voiceset:GetInt() == 4 then
			self.RDR_VoiceType = 1
			self:ZombieVoiceSet( "nil", true )
		end
		
	elseif voicetype == "female" then
		self.RDR_VoiceType = 2
		if voiceset:GetInt() == 0 then
			self:ZombieVoiceSet( "undeadnightmares" )
		elseif voiceset:GetInt() == 1 then
			self:ZombieVoiceSet( "classic" )
		elseif voiceset:GetInt() == 2 then
			self:ZombieVoiceSet( "blackops3" )
		elseif voiceset:GetInt() == 3 then
			self:ZombieVoiceSet( "coldwar" )
		elseif voiceset:GetInt() == 4 then
			self:ZombieVoiceSet( "nil", true )
		end
		
	elseif voicetype == "bruiser" then
		self.Zombie_Bruiser = 1
		self:ZombieVoiceSet( "bruiser" )
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZombieVoiceSet(voiceSet, randomVoice)
	-- Allows Random voiceset to be choosen
	-- used for the random voiceset convar.
	if randomVoice == true then
        local allVoiceSets = {
            "classic",
            "blackops3",
			"coldwar",
			"undeadnightmares"
        }

        voiceSet = allVoiceSets[ random( #allVoiceSets ) ]
    end

	local RDR_VoiceSet = random( 1, 2 )
	local RDR_VoiceSet_Fem = random( 1, 1 )

	if voiceSet == "classic" and self.Zombie_Walker then
		self.SoundTbl_Alert = Tbl_Classic_Alert
		self.SoundTbl_Idle = Tbl_Classic_Idle
		self.SoundTbl_CombatIdle = Tbl_Classic_Idle
		self.SoundTbl_Suppressing = Tbl_Classic_Idle
		self.SoundTbl_BeforeMeleeAttack = Tbl_Classic_Attack
		self.SoundTbl_Death = Tbl_Classic_Death
		self.SoundTbl_MeleeAttack = Tbl_Classic_AttackStrike
		self.SoundTbl_MeleeAttackMiss = Tbl_Classic_AttackStrike
		self.SoundTbl_Investigate = Tbl_Classic_Attack
		self.SoundTbl_LostEnemy = Tbl_Classic_Death_Elec
		self.SoundTbl_DeathElec = Tbl_Classic_Death_Elec
		self:SetSoundPitch()

	elseif voiceSet == "classic" and self.Zombie_Runner then
		self.SoundTbl_Alert = Tbl_Classic_Alert
		self.SoundTbl_Idle = Tbl_Classic_Idle
		self.SoundTbl_CombatIdle = Tbl_Classic_Running
		self.SoundTbl_Suppressing = Tbl_Classic_Running
		self.SoundTbl_BeforeMeleeAttack = Tbl_Classic_Attack
		self.SoundTbl_Death = Tbl_Classic_Death
		self.SoundTbl_MeleeAttack = Tbl_Classic_AttackStrike
		self.SoundTbl_MeleeAttackMiss = Tbl_Classic_AttackStrike
		self.SoundTbl_Investigate = Tbl_Classic_Attack
		self.SoundTbl_LostEnemy = Tbl_Classic_Death_Elec
		self.SoundTbl_DeathElec = Tbl_Classic_Death_Elec
		self:SetSoundPitch()

	elseif voiceSet == "blackops3" and self.Zombie_Walker then
		self.SoundTbl_Alert = Tbl_ZC_Alert
		self.SoundTbl_Idle = Tbl_ZC_Idle
		self.SoundTbl_CombatIdle = Tbl_ZC_Idle
		self.SoundTbl_Suppressing = Tbl_ZC_Idle
		self.SoundTbl_BeforeMeleeAttack = Tbl_ZC_Attack
		self.SoundTbl_Death = Tbl_ZC_Death
		self.SoundTbl_MeleeAttack = Tbl_ZC_AttackStrike
		self.SoundTbl_MeleeAttackMiss = Tbl_Classic_AttackStrike
		self.SoundTbl_Investigate = Tbl_ZC_Alert
		self.SoundTbl_LostEnemy = Tbl_ZC_Idle
		self.SoundTbl_DeathElec = Tbl_Classic_Death_Elec
		self:SetSoundPitch()

	elseif voiceSet == "blackops3" and self.Zombie_Runner then
		self.SoundTbl_Alert = Tbl_ZC_Alert
		self.SoundTbl_Idle = Tbl_ZC_Idle
		self.SoundTbl_CombatIdle = Tbl_ZC_Running
		self.SoundTbl_Suppressing = Tbl_ZC_Running
		self.SoundTbl_BeforeMeleeAttack = Tbl_ZC_Attack
		self.SoundTbl_Death = Tbl_ZC_Death
		self.SoundTbl_MeleeAttack = Tbl_ZC_AttackStrike
		self.SoundTbl_MeleeAttackMiss = Tbl_Classic_AttackStrike
		self.SoundTbl_Investigate = Tbl_ZC_Alert
		self.SoundTbl_LostEnemy = Tbl_ZC_Idle
		self.SoundTbl_DeathElec = Tbl_Classic_Death_Elec
		self:SetSoundPitch()

	elseif voiceSet == "coldwar" and self.Zombie_Walker then
		self.SoundTbl_Alert = Tbl_CW_Alert
		self.SoundTbl_Idle = Tbl_CW_Idle
		self.SoundTbl_CombatIdle = Tbl_CW_Idle
		self.SoundTbl_Suppressing = Tbl_CW_Idle
		self.SoundTbl_BeforeMeleeAttack = Tbl_CW_Attack
		self.SoundTbl_Death = Tbl_CW_Death
		self.SoundTbl_MeleeAttack = Tbl_CW_AttackStrike
		self.SoundTbl_MeleeAttackMiss = Tbl_Classic_AttackStrike
		self.SoundTbl_Investigate = Tbl_CW_Alert
		self.SoundTbl_LostEnemy = Tbl_CW_Idle
		self.SoundTbl_DeathElec = Tbl_CW_Death_Elec

	elseif voiceSet == "coldwar" and self.Zombie_Runner then
		self.SoundTbl_Alert = Tbl_CW_Alert
		self.SoundTbl_Idle = Tbl_CW_Idle
		self.SoundTbl_CombatIdle = Tbl_CW_Running
		self.SoundTbl_Suppressing = Tbl_CW_Running
		self.SoundTbl_BeforeMeleeAttack = Tbl_CW_Attack
		self.SoundTbl_Death = Tbl_CW_Death
		self.SoundTbl_MeleeAttack = Tbl_CW_AttackStrike
		self.SoundTbl_MeleeAttackMiss = Tbl_Classic_AttackStrike
		self.SoundTbl_Investigate = Tbl_CW_Alert
		self.SoundTbl_LostEnemy = Tbl_CW_Idle
		self.SoundTbl_DeathElec = Tbl_CW_Death_Elec

	elseif voiceSet == "undeadnightmares" and self.RDR_VoiceType == 1 and self.Zombie_Walker then
		if RDR_VoiceSet == 1 then
			self.SoundTbl_Alert = Tbl_UN_Alert_Male_01
			self.SoundTbl_Idle = Tbl_UN_Idle_Male_01
			self.SoundTbl_CombatIdle = Tbl_UN_Attacking_Male_01
			self.SoundTbl_Suppressing = Tbl_UN_Attacking_Male_01
			self.SoundTbl_BeforeMeleeAttack = Tbl_UN_Alert_Male_01
			self.SoundTbl_Death = Tbl_UN_Shared_Death_Male
			self.SoundTbl_Pain = Tbl_UN_Shared_Pain_Male
			self.SoundTbl_MeleeAttack = Tbl_Classic_AttackStrike
			self.SoundTbl_MeleeAttackMiss = Tbl_Classic_AttackStrike
			self.SoundTbl_Investigate = Tbl_UN_Alert_Male_01
			self.SoundTbl_LostEnemy = Tbl_UN_Alert_Male_01
		elseif RDR_VoiceSet == 2 then
			self.SoundTbl_Alert = Tbl_UN_Alert_Male_02
			self.SoundTbl_Idle = Tbl_UN_Idle_Male_02
			self.SoundTbl_CombatIdle = Tbl_UN_Attacking_Male_02
			self.SoundTbl_Suppressing = Tbl_UN_Attacking_Male_02
			self.SoundTbl_BeforeMeleeAttack = Tbl_UN_Alert_Male_02
			self.SoundTbl_Death = Tbl_UN_Shared_Death_Male
			self.SoundTbl_Pain = Tbl_UN_Shared_Pain_Male
			self.SoundTbl_MeleeAttack = Tbl_Classic_AttackStrike
			self.SoundTbl_MeleeAttackMiss = Tbl_Classic_AttackStrike
			self.SoundTbl_Investigate = Tbl_UN_Alert_Male_02
			self.SoundTbl_LostEnemy = Tbl_UN_Alert_Male_02
		elseif RDR_VoiceSet == 3 then
			self.SoundTbl_Alert = Tbl_UN_Alert_Male_03
			self.SoundTbl_Idle = Tbl_UN_Idle_Male_03
			self.SoundTbl_CombatIdle = Tbl_UN_Attacking_Male_03
			self.SoundTbl_Suppressing = Tbl_UN_Attacking_Male_03
			self.SoundTbl_BeforeMeleeAttack = Tbl_UN_Alert_Male_03
			self.SoundTbl_Death = Tbl_UN_Shared_Death_Male
			self.SoundTbl_Pain = Tbl_UN_Shared_Pain_Male
			self.SoundTbl_MeleeAttack = Tbl_Classic_AttackStrike
			self.SoundTbl_MeleeAttackMiss = Tbl_Classic_AttackStrike
			self.SoundTbl_Investigate = Tbl_UN_Alert_Male_03
			self.SoundTbl_LostEnemy = Tbl_UN_Alert_Male_03
		end

	elseif voiceSet == "undeadnightmares" and self.RDR_VoiceType == 1 and self.Zombie_Runner then
		if RDR_VoiceSet == 1 then
			self.SoundTbl_Alert = Tbl_UN_Alert_Male_01
			self.SoundTbl_Idle = Tbl_UN_Idle_Male_01
			self.SoundTbl_CombatIdle = Tbl_UN_Running_Male_01
			self.SoundTbl_Suppressing = Tbl_UN_Running_Male_01
			self.SoundTbl_BeforeMeleeAttack = Tbl_UN_Alert_Male_01
			self.SoundTbl_Death = Tbl_UN_Shared_Death_Male
			self.SoundTbl_Pain = Tbl_UN_Shared_Pain_Male
			self.SoundTbl_MeleeAttack = Tbl_Classic_AttackStrike
			self.SoundTbl_MeleeAttackMiss = Tbl_Classic_AttackStrike
			self.SoundTbl_Investigate = Tbl_UN_Alert_Male_01
			self.SoundTbl_LostEnemy = Tbl_UN_Alert_Male_01
		elseif RDR_VoiceSet == 2 then
			self.SoundTbl_Alert = Tbl_UN_Alert_Male_02
			self.SoundTbl_Idle = Tbl_UN_Idle_Male_02
			self.SoundTbl_CombatIdle = Tbl_UN_Running_Male_02
			self.SoundTbl_Suppressing = Tbl_UN_Running_Male_02
			self.SoundTbl_BeforeMeleeAttack = Tbl_UN_Alert_Male_02
			self.SoundTbl_Death = Tbl_UN_Shared_Death_Male
			self.SoundTbl_Pain = Tbl_UN_Shared_Pain_Male
			self.SoundTbl_MeleeAttack = Tbl_Classic_AttackStrike
			self.SoundTbl_MeleeAttackMiss = Tbl_Classic_AttackStrike
			self.SoundTbl_Investigate = Tbl_UN_Alert_Male_02
			self.SoundTbl_LostEnemy = Tbl_UN_Alert_Male_02
		elseif RDR_VoiceSet == 3 then
			self.SoundTbl_Alert = Tbl_UN_Alert_Male_03
			self.SoundTbl_Idle = Tbl_UN_Idle_Male_03
			self.SoundTbl_CombatIdle = Tbl_UN_Running_Male_03
			self.SoundTbl_Suppressing = Tbl_UN_Running_Male_03
			self.SoundTbl_BeforeMeleeAttack = Tbl_UN_Alert_Male_03
			self.SoundTbl_Death = Tbl_UN_Shared_Death_Male
			self.SoundTbl_Pain = Tbl_UN_Shared_Pain_Male
			self.SoundTbl_MeleeAttack = Tbl_Classic_AttackStrike
			self.SoundTbl_MeleeAttackMiss = Tbl_Classic_AttackStrike
			self.SoundTbl_Investigate = Tbl_UN_Alert_Male_03
			self.SoundTbl_LostEnemy = Tbl_UN_Alert_Male_03
		end

	elseif voiceSet == "undeadnightmares" and self.RDR_VoiceType == 2 and self.Zombie_Walker then
		if RDR_VoiceSet_Fem == 1 then
			self.SoundTbl_Alert = Tbl_UN_Alert_Female_01
			self.SoundTbl_Idle = Tbl_UN_Idle_Female_01
			self.SoundTbl_CombatIdle = Tbl_UN_Attacking_Female_01
			self.SoundTbl_Suppressing = Tbl_UN_Attacking_Female_01
			self.SoundTbl_BeforeMeleeAttack = Tbl_UN_Alert_Female_01
			self.SoundTbl_Death = Tbl_UN_Shared_Death_Female
			self.SoundTbl_Pain = Tbl_UN_Shared_Pain_Female
			self.SoundTbl_MeleeAttack = Tbl_Classic_AttackStrike
			self.SoundTbl_MeleeAttackMiss = Tbl_Classic_AttackStrike
			self.SoundTbl_Investigate = Tbl_UN_Alert_Female_01
			self.SoundTbl_LostEnemy = Tbl_UN_Alert_Female_01
		end
		
	elseif voiceSet == "undeadnightmares" and self.RDR_VoiceType == 2 and self.Zombie_Runner then
		if RDR_VoiceSet_Fem == 1 then
			self.SoundTbl_Alert = Tbl_UN_Alert_Female_01
			self.SoundTbl_Idle = Tbl_UN_Idle_Female_01
			self.SoundTbl_CombatIdle = Tbl_UN_Running_Female_01
			self.SoundTbl_Suppressing = Tbl_UN_Running_Female_01
			self.SoundTbl_BeforeMeleeAttack = Tbl_UN_Alert_Female_01
			self.SoundTbl_Death = Tbl_UN_Shared_Death_Female
			self.SoundTbl_Pain = Tbl_UN_Shared_Pain_Female
			self.SoundTbl_MeleeAttack = Tbl_Classic_AttackStrike
			self.SoundTbl_MeleeAttackMiss = Tbl_Classic_AttackStrike
			self.SoundTbl_Investigate = Tbl_UN_Alert_Female_01
			self.SoundTbl_LostEnemy = Tbl_UN_Alert_Female_01
		end

	elseif voiceSet == "bruiser" and self.Zombie_Walker then
		self.SoundTbl_Alert = {"vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_17.mp3"}
		self.SoundTbl_Idle = {"vj_bmce_zmb/vocals/rdr_un/bruiser/roar_01.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/roar_02.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/roar_03.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/roar_04.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/roar_05.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/roar_06.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/roar_07.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/roar_08.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/roar_09.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/roar_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_32.mp3"}
		self.SoundTbl_CombatIdle = {"vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_32.mp3"}
		self.SoundTbl_Suppressing = {"vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_32.mp3"}
		self.SoundTbl_BeforeMeleeAttack = {"vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_17.mp3"}
		self.SoundTbl_Death = {"vj_bmce_zmb/vocals/rdr_un/bruiser/death_01.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/death_02.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/death_03.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/death_04.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/death_05.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/death_06.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/death_07.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/death_08.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/death_09.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/death_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/death_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/death_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/death_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/death_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/death_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/death_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/death_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/death_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/death_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/death_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/death_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/death_12.mp3"}
		self.SoundTbl_MeleeAttack = Tbl_Classic_AttackStrike
		self.SoundTbl_MeleeAttackMiss = Tbl_Classic_AttackStrike
		self.SoundTbl_Investigate = {"vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_17.mp3"}
		self.SoundTbl_LostEnemy = {"vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_17.mp3"}
	elseif voiceSet == "bruiser" and self.Zombie_Runner then
		self.SoundTbl_Alert = {"vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_17.mp3"}
		self.SoundTbl_Idle = {"vj_bmce_zmb/vocals/rdr_un/bruiser/roar_01.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/roar_02.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/roar_03.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/roar_04.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/roar_05.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/roar_06.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/roar_07.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/roar_08.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/roar_09.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/roar_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/idle_32.mp3"}
		self.SoundTbl_CombatIdle = {"vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_32.mp3"}
		self.SoundTbl_Suppressing = {"vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attacking_32.mp3"}
		self.SoundTbl_BeforeMeleeAttack = {"vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_17.mp3"}
		self.SoundTbl_Death = {"vj_bmce_zmb/vocals/rdr_un/bruiser/death_01.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/death_02.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/death_03.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/death_04.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/death_05.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/death_06.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/death_07.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/death_08.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/death_09.mp3","vj_bmce_zmb/vocals/rdr_un/bruiser/death_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/death_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/death_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/death_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/death_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/death_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/death_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/death_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/death_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/death_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/death_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/death_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/death_12.mp3"}
		self.SoundTbl_MeleeAttack = Tbl_Classic_AttackStrike
		self.SoundTbl_MeleeAttackMiss = Tbl_Classic_AttackStrike
		self.SoundTbl_Investigate = {"vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_17.mp3"}
		self.SoundTbl_LostEnemy = {"vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_bruiser_male_01/attack_noise_17.mp3"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------