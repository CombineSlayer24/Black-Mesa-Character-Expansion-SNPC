AddCSLuaFile("shared.lua")
include('shared.lua')

-- for those that are looking here; 
-- code that's easy to read, with good indents helps out in the long run
-- VJ Base
ENT.HullType = HULL_HUMAN
ENT.PoseParameterLooking_Names = {pitch={}, yaw={"spine_yaw"}, roll={}}
ENT.ImmuneDamagesTable = {DMG_RADIATION,DMG_NERVEGAS}
ENT.CanFlinch = 1
ENT.FlinchChance = 12
ENT.AnimTbl_Flinch = {"vjseq_shove_backwards_01","vjseq_shove_backwards_02","vjseq_shove_backwards_03","vjseq_shove_backwards_04","vjseq_shove_backwards_05","vjseq_shove_backwards_06"} 
ENT.HasHitGroupFlinching = true 
ENT.HitGroupFlinching_DefaultWhenNotHit = true
ENT.HitGroupFlinching_Values = {
	{HitGroup = {HITGROUP_HEAD}, Animation = {"vjges_flinch_head_1","vjges_flinch_head_2","vjges_flinch_head_3"}},
	{HitGroup = {HITGROUP_LEFTARM}, Animation = {"vjges_flinch_leftarm_1","vjges_flinch_leftarm_2","vjges_flinch_leftarm_3"}}, 
	{HitGroup = {HITGROUP_RIGHTARM}, Animation = {"vjges_flinch_rightarm_1","vjges_flinch_rightarm_2","vjges_flinch_rightarm_3"}},
	{HitGroup = {HITGROUP_LEFTLEG}, Animation = {"vjseq_flinch_leftleg"}}, 
	{HitGroup = {HITGROUP_RIGHTLEG}, Animation = {"vjseq_flinch_rightleg"}}
}

ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} 
ENT.BloodColor = "Red" 
ENT.CustomBlood_Particle = {"lnr_bullet_impact_01","lnr_bullet_impact_02","lnr_bullet_impact_02_w_squirt","lnr_bullet_impact_03","lnr_bullet_impact_04","lnr_melee_hit_01","lnr_melee_hit_01_w_squirt"}
ENT.CustomBlood_Decal = {"VJ_LNR_Blood_Red"}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true 
ENT.MeleeAttackDistance = 30
ENT.MeleeAttackDamageDistance = 60
ENT.TimeUntilMeleeAttackDamage = false
ENT.HasExtraMeleeAttackSounds = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.DisableFootStepSoundTimer = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasDeathAnimation = true
ENT.DeathAnimationTime = false
ENT.DeathAnimationChance = 4
ENT.AnimTbl_Death = {"vjseq_nz_death_1","vjseq_nz_death_2","vjseq_nz_death_3"} 
ENT.GibOnDeathDamagesTable = {"All"}
---------------------------------------------------------------------------------------------------------------------------------------------

ENT.HasItemDropsOnDeath = true
ENT.HasBloodDecal = true
ENT.BloodDecalUseGMod = false
ENT.SuppressingSoundChance = 1
ENT.NextSoundTime_Pain = VJ_Set(2, 2.3)
ENT.NextSoundTime_Idle = VJ_Set( 4, 6 )
ENT.NextSoundTime_Suppressing = VJ_Set( 0, 1.6 )
ENT.FootStepSoundLevel = 73
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
ENT.Zombie_SuperCrawler = false
ENT.Zombie_Walker = false
ENT.Zombie_Runner = false
ENT.Zombie_Bruiser = 0
--ENT.Zombie_Fire = 0
ENT.HasEyeGlow = 0

ENT.RDR_VoiceType = nil 
-- 1 Male
-- 2 Female
---------------------------------------------------------------------------------------------------------------------------------------------
-- Locals, tables and other crap, yadada
local random = math.random
local rand = math.Rand

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
local ANIM_RUN_STEALTH = {ACT_RUN_STEALTH}

-- World At War - Black Ops 2 local tables
local Tbl_Classic_Alert = {"vj_bmce_zmb/vocals/world_at_war/attack/attack1.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack2.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack6.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack7.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack14.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack20.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack22.mp3","vj_bmce_zmb/vocals/world_at_war/behind/behind1.mp3","vj_bmce_zmb/vocals/world_at_war/behind/behind2.mp3","vj_bmce_zmb/vocals/world_at_war/behind/behind3.mp3","vj_bmce_zmb/vocals/world_at_war/behind/behind4.mp3","vj_bmce_zmb/vocals/world_at_war/behind/behind5.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl1.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl2.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl3.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl4.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl5.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt1.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt2.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt3.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt4.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt5.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt6.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt7.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt1.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt2.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt3.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt4.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt5.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt6.mp3","vj_bmce_zmb/vocals/world_at_war/taunt/taunt7.mp3"}
local Tbl_Classic_Idle = {"vj_bmce_zmb/vocals/world_at_war/amb/ambient1.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient2.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient3.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient4.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient5.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient6.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient7.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient8.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient9.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient10.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient11.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient12.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient13.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient14.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient15.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient16.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient17.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient18.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient19.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient20.mp3","vj_bmce_zmb/vocals/world_at_war/amb/ambient21.mp3"}
local Tbl_Classic_Attack = {"vj_bmce_zmb/vocals/world_at_war/attack/attack1.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack2.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack3.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack4.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack5.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack6.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack7.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack8.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack9.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack10.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack11.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack12.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack13.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack14.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack15.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack16.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack17.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack18.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack19.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack20.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack21.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack22.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack23.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack24.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack25.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack26.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack27.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack28.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack29.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack30.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack31.mp3","vj_bmce_zmb/vocals/world_at_war/attack/attack32.mp3"}
local Tbl_Classic_Death = {"vj_bmce_zmb/vocals/world_at_war/death/death1.mp3","vj_bmce_zmb/vocals/world_at_war/death/death2.mp3","vj_bmce_zmb/vocals/world_at_war/death/death3.mp3","vj_bmce_zmb/vocals/world_at_war/death/death4.mp3","vj_bmce_zmb/vocals/world_at_war/death/death5.mp3","vj_bmce_zmb/vocals/world_at_war/death/death6.mp3","vj_bmce_zmb/vocals/world_at_war/death/death7.mp3","vj_bmce_zmb/vocals/world_at_war/death/death8.mp3","vj_bmce_zmb/vocals/world_at_war/death/death9.mp3","vj_bmce_zmb/vocals/world_at_war/death/death10.mp3"}
local Tbl_Classic_AttackStrike = { "vj_bmce_zmb/vocals/world_at_war/attack_strike1.mp3","vj_bmce_zmb/vocals/world_at_war/attack_strike2.mp3","vj_bmce_zmb/vocals/world_at_war/attack_strike3.mp3"}
local Tbl_Classic_Death_Elec = {"vj_bmce_zmb/vocals/world_at_war/elec/elec1.mp3","vj_bmce_zmb/vocals/world_at_war/elec/elec2.mp3","vj_bmce_zmb/vocals/world_at_war/elec/elec3.mp3","vj_bmce_zmb/vocals/world_at_war/elec/elec4.mp3","vj_bmce_zmb/vocals/world_at_war/elec/elec5.mp3","vj_bmce_zmb/vocals/world_at_war/elec/elec6.mp3"}
local Tbl_Classic_Running = {"vj_bmce_zmb/vocals/world_at_war/sprint/sprint1.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint2.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint3.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint4.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint5.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint6.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint7.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint8.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint9.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint10.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint11.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint12.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint13.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint14.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint15.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint16.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint17.mp3"}
local Tbl_Classic_Crawling = {"vj_bmce_zmb/vocals/world_at_war/crawl/crawl1.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl2.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl3.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl4.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl5.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl6.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl7.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl8.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl9.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl10.mp3"}
local Tbl_Classic_Crawling_Super = {"vj_bmce_zmb/vocals/world_at_war/crawl/crawl1.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl2.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl3.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl4.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl5.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl6.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl7.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl8.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl9.mp3","vj_bmce_zmb/vocals/world_at_war/crawl/crawl10.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint1.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint2.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint3.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint4.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint5.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint6.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint7.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint8.mp3","vj_bmce_zmb/vocals/world_at_war/sprint/sprint9.mp3"}

-- Black Ops 3 tables
local Tbl_ZC_Alert = {"vj_bmce_zmb/vocals/blackops3/taunt/taunt1.mp3","vj_bmce_zmb/vocals/blackops3/taunt/taunt2.mp3","vj_bmce_zmb/vocals/blackops3/taunt/taunt3.mp3","vj_bmce_zmb/vocals/blackops3/taunt/taunt4.mp3","vj_bmce_zmb/vocals/blackops3/taunt/taunt5.mp3","vj_bmce_zmb/vocals/blackops3/taunt/taunt6.mp3","vj_bmce_zmb/vocals/blackops3/taunt/taunt7.mp3","vj_bmce_zmb/vocals/blackops3/taunt/zm_mod.all_62.mp3","vj_bmce_zmb/vocals/blackops3/taunt/zm_mod.all_63.mp3","vj_bmce_zmb/vocals/blackops3/taunt/zm_mod.all_64.mp3","vj_bmce_zmb/vocals/blackops3/taunt/zm_mod.all_65.mp3","vj_bmce_zmb/vocals/blackops3/taunt/zm_mod.all_66.mp3","vj_bmce_zmb/vocals/blackops3/taunt/zm_mod.all_67.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_89.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_93.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_97.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_1.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_2.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_3.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_4.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_5.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_6.mp3"}
local Tbl_ZC_Idle = {"vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_26.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_27.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_28.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_29.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_30.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_31.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_32.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_33.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_34.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_35.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_36.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_37.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_38.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_39.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_40.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_41.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_42.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_43.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_44.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_45.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_46.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_47.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_48.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_49.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_50.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_51.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_52.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_53.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_54.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_55.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_56.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_57.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_58.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_59.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_60.mp3","vj_bmce_zmb/vocals/blackops3/amb/zm_mod.all_61.mp3"}
local Tbl_ZC_Attack = {"vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_1.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_2.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_3.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_4.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_5.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_6.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_7.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_8.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_9.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_10.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_11.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_12.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_13.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_14.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_15.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_16.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_17.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_18.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_19.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_20.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_21.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_22.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_23.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_24.mp3","vj_bmce_zmb/vocals/blackops3/attack/zm_mod.all_25.mp3"}
local Tbl_ZC_Death = {"vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_68.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_69.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_70.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_71.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_72.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_73.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_74.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_75.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_76.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_77.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_78.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_79.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_80.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_81.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_82.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_83.mp3"}
local Tbl_ZC_AttackStrike = {"vj_bmce_zmb/vocals/blackops3/zm_mod.all_112.mp3","vj_bmce_zmb/vocals/blackops3/zm_mod.all_113.mp3","vj_bmce_zmb/vocals/blackops3/zm_mod.all_114.mp3","vj_bmce_zmb/vocals/blackops3/zm_mod.all_115.mp3","vj_bmce_zmb/vocals/blackops3/zm_mod.all_116.mp3","vj_bmce_zmb/vocals/blackops3/zm_mod.all_117.mp3"}
--local Tbl_ZC_Death_Elec = {}
local Tbl_ZC_Running = {"vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_84.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_85.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_86.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_87.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_88.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_89.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_90.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_91.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_92.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_93.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_94.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_95.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_96.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_97.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_98.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_99.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_100.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_101.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_102.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_103.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_104.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_105.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_106.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_107.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_108.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_109.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_110.mp3","vj_bmce_zmb/vocals/blackops3/sprint/zm_mod.all_111.mp3"}

-- Cold War
local Tbl_CW_Alert = {"vj_bmce_zmb/vocals/cold_war/taunt/taunt1.mp3","vj_bmce_zmb/vocals/cold_war/taunt/taunt2.mp3","vj_bmce_zmb/vocals/cold_war/taunt/taunt3.mp3","vj_bmce_zmb/vocals/cold_war/taunt/taunt4.mp3","vj_bmce_zmb/vocals/cold_war/taunt/taunt5.mp3","vj_bmce_zmb/vocals/cold_war/taunt/taunt6.mp3","vj_bmce_zmb/vocals/cold_war/taunt/taunt7.mp3","vj_bmce_zmb/vocals/cold_war/taunt/taunt8.mp3"}
local Tbl_CW_Idle = {"vj_bmce_zmb/vocals/cold_war/amb/ambient1.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient2.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient3.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient4.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient5.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient6.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient7.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient8.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient9.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient1.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient11.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient12.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient13.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient14.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient15.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient16.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient17.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient18.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient19.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient2.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient21.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient22.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient23.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient24.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient25.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient26.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient27.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient28.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient29.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient3.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient31.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient32.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient33.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient34.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient35.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient36.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient37.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient38.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient39.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient4.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient41.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient42.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient43.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient44.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient45.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient46.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient47.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient48.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient49.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient5.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient51.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient52.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient53.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient54.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient55.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient56.mp3","vj_bmce_zmb/vocals/cold_war/amb/ambient57.mp3"}
local Tbl_CW_Attack = {"vj_bmce_zmb/vocals/cold_war/attack/attack1.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack2.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack3.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack4.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack5.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack6.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack7.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack8.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack9.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack1.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack11.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack12.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack13.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack14.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack15.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack16.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack17.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack18.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack19.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack2.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack21.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack22.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack23.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack24.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack25.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack26.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack27.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack28.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack29.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack3.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack31.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack32.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack33.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack34.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack35.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack36.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack37.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack38.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack39.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack4.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack41.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack42.mp3","vj_bmce_zmb/vocals/cold_war/attack/attack43.mp3"}
local Tbl_CW_Death = {"vj_bmce_zmb/vocals/cold_war/death/death1.mp3","vj_bmce_zmb/vocals/cold_war/death/death2.mp3","vj_bmce_zmb/vocals/cold_war/death/death3.mp3","vj_bmce_zmb/vocals/cold_war/death/death4.mp3","vj_bmce_zmb/vocals/cold_war/death/death5.mp3","vj_bmce_zmb/vocals/cold_war/death/death6.mp3","vj_bmce_zmb/vocals/cold_war/death/death7.mp3","vj_bmce_zmb/vocals/cold_war/death/death8.mp3","vj_bmce_zmb/vocals/cold_war/death/death9.mp3","vj_bmce_zmb/vocals/cold_war/death/death10.mp3","vj_bmce_zmb/vocals/cold_war/death/death11.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_72.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_73.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_74.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_75.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_76.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_77.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_78.mp3","vj_bmce_zmb/vocals/blackops3/death/zm_mod.all_79.mp3"}
local Tbl_CW_Death_Elec = {"vj_bmce_zmb/vocals/cold_war/elec/elec1.mp3","vj_bmce_zmb/vocals/cold_war/elec/elec2.mp3","vj_bmce_zmb/vocals/cold_war/elec/elec3.mp3","vj_bmce_zmb/vocals/cold_war/elec/elec4.mp3","vj_bmce_zmb/vocals/cold_war/elec/elec5.mp3","vj_bmce_zmb/vocals/cold_war/elec/elec6.mp3","vj_bmce_zmb/vocals/cold_war/elec/elec7.mp3","vj_bmce_zmb/vocals/cold_war/elec/elec8.mp3","vj_bmce_zmb/vocals/cold_war/elec/elec9.mp3","vj_bmce_zmb/vocals/cold_war/elec/elec10.mp3"}
local Tbl_CW_Running = {"vj_bmce_zmb/vocals/cold_war/sprint/sprint1.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint2.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint3.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint4.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint5.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint6.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint7.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint8.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint9.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint1.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint11.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint12.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint13.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint14.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint15.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint16.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint17.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint18.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint19.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint20.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint21.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint22.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint23.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint24.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint25.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint26.mp3"}
local Tbl_CW_Crawling = {"vj_bmce_zmb/vocals/cold_war/crawl/crawl1.mp3","vj_bmce_zmb/vocals/cold_war/crawl/crawl2.mp3","vj_bmce_zmb/vocals/cold_war/crawl/crawl3.mp3","vj_bmce_zmb/vocals/cold_war/crawl/crawl4.mp3","vj_bmce_zmb/vocals/cold_war/crawl/crawl5.mp3","vj_bmce_zmb/vocals/cold_war/crawl/crawl6.mp3","vj_bmce_zmb/vocals/cold_war/crawl/crawl7.mp3","vj_bmce_zmb/vocals/cold_war/crawl/crawl8.mp3","vj_bmce_zmb/vocals/cold_war/crawl/crawl9.mp3","vj_bmce_zmb/vocals/cold_war/crawl/crawl1.mp3","vj_bmce_zmb/vocals/cold_war/crawl/crawl11.mp3","vj_bmce_zmb/vocals/cold_war/crawl/crawl12.mp3","vj_bmce_zmb/vocals/cold_war/crawl/crawl13.mp3"}
local Tbl_CW_Crawling_Super = {"vj_bmce_zmb/vocals/cold_war/crawl/crawl1.mp3","vj_bmce_zmb/vocals/cold_war/crawl/crawl2.mp3","vj_bmce_zmb/vocals/cold_war/crawl/crawl3.mp3","vj_bmce_zmb/vocals/cold_war/crawl/crawl4.mp3","vj_bmce_zmb/vocals/cold_war/crawl/crawl5.mp3","vj_bmce_zmb/vocals/cold_war/crawl/crawl6.mp3","vj_bmce_zmb/vocals/cold_war/crawl/crawl7.mp3","vj_bmce_zmb/vocals/cold_war/crawl/crawl8.mp3","vj_bmce_zmb/vocals/cold_war/crawl/crawl9.mp3","vj_bmce_zmb/vocals/cold_war/crawl/crawl1.mp3","vj_bmce_zmb/vocals/cold_war/crawl/crawl11.mp3","vj_bmce_zmb/vocals/cold_war/crawl/crawl12.mp3","vj_bmce_zmb/vocals/cold_war/crawl/crawl13.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint19.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint20.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint21.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint22.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint23.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint24.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint25.mp3","vj_bmce_zmb/vocals/cold_war/sprint/sprint26.mp3"}

-- Red Dead Redemption: Undead Nightmare
local Tbl_UN_Shared_Death_Male = {"vj_bmce_zmb/vocals/rdr_un/zombie_male/death_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/death_16.mp3"}
local Tbl_UN_Shared_Death_Female = {"vj_bmce_zmb/vocals/rdr_un/zombie_female/death_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/death_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/death_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/death_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/death_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/death_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/death_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/death_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/death_09.mp3"}
local Tbl_UN_Shared_Pain_Male = {"vj_bmce_zmb/vocals/rdr_un/zombie_male/pain_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/pain_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/pain_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/pain_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/pain_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/pain_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/pain_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/pain_08.mp3"}
local Tbl_UN_Shared_Pain_Female = {"vj_bmce_zmb/vocals/rdr_un/zombie_female/pain_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/pain_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/pain_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/pain_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/pain_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/pain_06.mp3"}

local Tbl_UN_Shared_Attack_Male = {}

-- Male 01
local Tbl_UN_Attack_Male_01 = {"vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/attack_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/attack_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/attack_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/attack_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/attack_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/attack_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/attack_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/attack_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/attack_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/attack_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/attack_11.mp3"}
local Tbl_UN_Alert_Male_01 = {"vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attack_noise_19.mp3"}
local Tbl_UN_Idle_Male_01 = {"vj_bmce_zmb/vocals/rdr_un/weird_01.mp3","vj_bmce_zmb/vocals/rdr_un/weird_02.mp3","vj_bmce_zmb/vocals/rdr_un/weird_03.mp3","vj_bmce_zmb/vocals/rdr_un/weird_04.mp3","vj_bmce_zmb/vocals/rdr_un/weird_05.mp3","vj_bmce_zmb/vocals/rdr_un/weird_06.mp3","vj_bmce_zmb/vocals/rdr_un/weird_07.mp3","vj_bmce_zmb/vocals/rdr_un/weird_08.mp3","vj_bmce_zmb/vocals/rdr_un/weird_09.mp3","vj_bmce_zmb/vocals/rdr_un/weird_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_32.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_33.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_34.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_35.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_36.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_37.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_38.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_39.mp3"}
local Tbl_UN_Attacking_Male_01 = {"vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_32.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_33.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_34.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_35.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_36.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_37.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_38.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_39.mp3"}
local Tbl_UN_Running_Male_01 = {"vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_32.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_33.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_34.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_35.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_36.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_37.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_38.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_39.mp3"}
local Tbl_UN_Crawling_Male_01 = {"vj_bmce_zmb/vocals/rdr_un/weird_01.mp3","vj_bmce_zmb/vocals/rdr_un/weird_02.mp3","vj_bmce_zmb/vocals/rdr_un/weird_03.mp3","vj_bmce_zmb/vocals/rdr_un/weird_04.mp3","vj_bmce_zmb/vocals/rdr_un/weird_05.mp3","vj_bmce_zmb/vocals/rdr_un/weird_06.mp3","vj_bmce_zmb/vocals/rdr_un/weird_07.mp3","vj_bmce_zmb/vocals/rdr_un/weird_08.mp3","vj_bmce_zmb/vocals/rdr_un/weird_09.mp3","vj_bmce_zmb/vocals/rdr_un/weird_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/idle_29.mp3"}
local Tbl_UN_Crawling_Super_Male_01 = {"vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_01/attacking_19.mp3"}

-- Male 02
local Tbl_UN_Attack_Male_02 = {"vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attack_noise_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attack_noise_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attack_noise_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attack_noise_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attack_noise_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attack_noise_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attack_noise_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attack_noise_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attack_noise_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attack_noise_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attack_noise_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attack_noise_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/attack_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/attack_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/attack_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/attack_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/attack_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/attack_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/attack_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/attack_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/attack_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/attack_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/attack_11.mp3"}
local Tbl_UN_Alert_Male_02 = {"vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attack_noise_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attack_noise_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attack_noise_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attack_noise_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attack_noise_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attack_noise_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attack_noise_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attack_noise_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attack_noise_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attack_noise_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attack_noise_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attack_noise_12.mp3"}
local Tbl_UN_Idle_Male_02 = {"vj_bmce_zmb/vocals/rdr_un/weird_01.mp3","vj_bmce_zmb/vocals/rdr_un/weird_02.mp3","vj_bmce_zmb/vocals/rdr_un/weird_03.mp3","vj_bmce_zmb/vocals/rdr_un/weird_04.mp3","vj_bmce_zmb/vocals/rdr_un/weird_05.mp3","vj_bmce_zmb/vocals/rdr_un/weird_06.mp3","vj_bmce_zmb/vocals/rdr_un/weird_07.mp3","vj_bmce_zmb/vocals/rdr_un/weird_08.mp3","vj_bmce_zmb/vocals/rdr_un/weird_09.mp3","vj_bmce_zmb/vocals/rdr_un/weird_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_32.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_33.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_34.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_35.mp3"}
local Tbl_UN_Attacking_Male_02 = {"vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_32.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_33.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_34.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_35.mp3"}
local Tbl_UN_Running_Male_02 = {"vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_32.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_33.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_34.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_35.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_36.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_37.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_38.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_39.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_40.mp3"}
local Tbl_UN_Crawling_Male_02 = {"vj_bmce_zmb/vocals/rdr_un/weird_01.mp3","vj_bmce_zmb/vocals/rdr_un/weird_02.mp3","vj_bmce_zmb/vocals/rdr_un/weird_03.mp3","vj_bmce_zmb/vocals/rdr_un/weird_04.mp3","vj_bmce_zmb/vocals/rdr_un/weird_05.mp3","vj_bmce_zmb/vocals/rdr_un/weird_06.mp3","vj_bmce_zmb/vocals/rdr_un/weird_07.mp3","vj_bmce_zmb/vocals/rdr_un/weird_08.mp3","vj_bmce_zmb/vocals/rdr_un/weird_09.mp3","vj_bmce_zmb/vocals/rdr_un/weird_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male/roar_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/idle_25.mp3"}
local Tbl_UN_Crawling_Super_Male_02 = {"vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_36.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_37.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_male_02/attacking_38.mp3"}

-- Female 01
local Tbl_UN_Alert_Female_01 = {"vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attack_noise_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attack_noise_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attack_noise_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attack_noise_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attack_noise_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attack_noise_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attack_noise_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attack_noise_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attack_noise_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attack_noise_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attack_noise_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attack_noise_12.mp3"}
local Tbl_UN_Idle_Female_01 = {"vj_bmce_zmb/vocals/rdr_un/weird_01.mp3","vj_bmce_zmb/vocals/rdr_un/weird_02.mp3","vj_bmce_zmb/vocals/rdr_un/weird_03.mp3","vj_bmce_zmb/vocals/rdr_un/weird_04.mp3","vj_bmce_zmb/vocals/rdr_un/weird_05.mp3","vj_bmce_zmb/vocals/rdr_un/weird_06.mp3","vj_bmce_zmb/vocals/rdr_un/weird_07.mp3","vj_bmce_zmb/vocals/rdr_un/weird_08.mp3","vj_bmce_zmb/vocals/rdr_un/weird_09.mp3","vj_bmce_zmb/vocals/rdr_un/weird_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/roar_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/roar_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/roar_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/roar_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/roar_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/roar_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/roar_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/roar_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female/roar_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_32.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_33.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_34.mp3"}
local Tbl_UN_Attacking_Female_01 = {"vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_32.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_33.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/idle_34.mp3"}
local Tbl_UN_Running_Female_01 = {"vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_01.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_02.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_03.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_04.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_05.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_06.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_07.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_08.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_09.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_10.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_11.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_12.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_13.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_14.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_15.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_16.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_17.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_18.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_19.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_20.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_21.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_22.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_23.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_24.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_25.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_26.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_27.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_28.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_29.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_30.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_31.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_32.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_33.mp3","vj_bmce_zmb/vocals/rdr_un/zombie_female_01/attacking_34.mp3"}

-- Eye glow
--[[ local orangeEyeMdls = {
	"models/undead/scientist_burned.mdl",
	"models/undead/guard_burned.mdl",
	"models/undead/marine_burned.mdl"
} ]]

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

local bruiserChance = GetConVar( "vj_bmce_zmb_bruiserchance" )
local crawlerChance = GetConVar( "vj_bmce_zmb_crawlerchance" )
local superCrawlerChance = GetConVar( "vj_bmce_zmb_supercrawlerchance" )
local specialEyeColors =  GetConVar( "vj_bmce_zmb_specialeyecolors" )
--local burnParticles = GetConVar( "vj_bmce_zmb_burnparticles" )
local voiceset = GetConVar( "vj_bmce_zmb_voiceset" )
local zombie_Speed = GetConVar( "vj_bmce_zmb_speed" )

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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.Zombie_EnergyTime = CurTime() + rand(GetConVar("vj_bmce_zmb_deathtime_min"):GetInt(), GetConVar("vj_bmce_zmb_deathtime_max"):GetInt() )

	local randomSpeed = random(1, 165)
	local randomTotalSpeed = random(1, 4)
	local crawler_chance = crawlerChance:GetInt()
	local supercrawler_chance = superCrawlerChance:GetInt()
	
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
		if randomSpeed <= 107 then
			self.Zombie_Walker = 1
			self.AnimTbl_Walk = ANIM_WALK
			self.AnimTbl_Run = ANIM_WALK
		elseif randomSpeed <= 132 then
			self.Zombie_Runner = 1
			self.AnimTbl_Walk = ANIM_WALK
			self.AnimTbl_Run = ANIM_RUN
		elseif randomSpeed <= 149 then
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

	if self.Zombie_Runner and supercrawler_chance > 0 and random( 1, 100 ) <= supercrawler_chance then 
		self.Zombie_SuperCrawler = true
		self.AnimTbl_Walk = ANIM_SPRINT
		self.AnimTbl_Run = ANIM_RUN_STEALTH
		--self.MeleeAttackDistance = 15
		--self.MeleeAttackDamageDistance = 45	

	elseif self.Zombie_Walker and crawler_chance > 0 and random( 1, 100 ) <= crawler_chance then 
		self:SetupCrawler() 
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
		--if self.Zombie_Fire == 1 and burnParticles:GetInt() == 1 then return end
		local random_riser = random(1,4)

		if random_riser <= 3 then
			self:DirtSpawn("slow")
		else
			self:DirtSpawn("fast")
		end
	end
end

function ENT:CustomOnAlert(ent)
	-- Disables the custom HLR taunt on alert
end

function ENT:CustomOnMeleeAttack_BeforeStartTimer(seed) 

	-- When Crawling or Crippled --
	if self.LNR_Crawler or self.LNR_Crippled then
		self.AnimTbl_MeleeAttack = {"vjseq_crawl_attack2"}
		self.MeleeAttackDistance = 15
		self.MeleeAttackDamageDistance = 45	
		self.MeleeAttackAnimationAllowOtherTasks = false
	end	

	-- When Standing
	if self.LNR_Crawler or self.LNR_Crippled then return end

	if !self:IsMoving() then
		self.MeleeAttackAnimationAllowOtherTasks = false
		self.AnimTbl_MeleeAttack = {"vjseq_nz_attack_stand_ad_1","vjseq_nz_attack_stand_ad_2-2","vjseq_nz_attack_stand_ad_2-3","vjseq_nz_attack_stand_ad_2-4","vjseq_nz_attack_stand_au_1","vjseq_nz_attack_stand_au_2-2","vjseq_nz_attack_stand_au_2-3","vjseq_nz_attack_stand_au_2-4"}	
	end	

	-- While Moving and Walking
	if self:IsMoving() then
		if self:GetActivity() == ACT_WALK or self:GetActivity() == ACT_WALK_AIM	then
			self.AnimTbl_MeleeAttack = {"vjges_nz_attack_walk_ad_1","vjges_nz_attack_walk_ad_2","vjges_nz_attack_walk_ad_3","vjges_nz_attack_walk_ad_4","vjges_nz_attack_walk_au_1","vjges_nz_attack_walk_au_2","vjges_nz_attack_walk_au_3","vjges_nz_attack_walk_au_4"}	
		end	

	-- When Running/Sprinting	
	if self:GetActivity() == ACT_RUN or self:GetActivity() == ACT_RUN_AIM or self:GetActivity() == ACT_SPRINT or self:GetActivity() == ACT_RUN_STEALTH then
		self.AnimTbl_MeleeAttack = {"vjges_nz_attack_run_ad_1","vjges_nz_attack_run_ad_2","vjges_nz_attack_run_ad_3","vjges_nz_attack_run_ad_4","vjges_nz_attack_run_au_1","vjges_nz_attack_run_au_2","vjges_nz_attack_run_au_3","vjges_nz_attack_run_au_4"}
	end
		self.MeleeAttackAnimationAllowOtherTasks = true
	end		
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
	if !GetConVar("vj_bmce_zmb_eyeglow"):GetBool() then return end

	for i = 1, 2 do
		local eyeglow = ents.Create( "env_sprite" )
		eyeglow:SetKeyValue( "model", "models/sprites/eyeglow_sprite.vmt" )
		eyeglow:SetKeyValue( "scale", "0.032")
		eyeglow:SetKeyValue( "rendermode", "5" )
		eyeglow:SetKeyValue( "rendercolor", colorData.c_string )
		eyeglow:SetKeyValue( "spawnflags", "1" )
		eyeglow:SetParent( self )
		eyeglow:Fire( "SetParentAttachment", i == 1 and "LeftEye" or "RightEye", 0 )
		eyeglow:Spawn()
		eyeglow:Activate()
		self:DeleteOnRemove( eyeglow )
	end	

	self.HasEyeGlow = ( eyecolor == "green" or eyecolor == "darkblue" or eyecolor == "bruiser" ) and 1 or 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:EyeGlow()
	local MDL = self:GetModel()
	local color_rnd = random(1, 2)
	local eyeColor = "orange"

	if specialEyeColors:GetBool() /* and random(0, 1) == 1*/ then
		if self.Zombie_Bruiser == 1 then
			eyeColor = "bruiser"
--		elseif table.HasValue(orangeEyeMdls, MDL) then
--			eyeColor = "orange"
		elseif table.HasValue(greenEyeMdls, MDL) then
			eyeColor = "green"
		elseif table.HasValue(blueEyeMdls, MDL) then
			eyeColor = "darkblue"
		else
			if self.HasEyeGlow == 0 and self.Zombie_Walker then
				eyeColor = color_rnd == 1 and "orange" or "lightblue"
			elseif self.Zombie_Runner then
				eyeColor = "red"
			end
		end
	else
--		if table.HasValue(orangeEyeMdls, MDL) then
--			eyeColor = "orange"
--		else
		if self.Zombie_Walker then
			eyeColor = color_rnd == 1 and "orange" or "lightblue"
		elseif self.Zombie_Runner then
			eyeColor = "red"
		end
	end

	self:SetEyeColor(eyeColor)

	if random(1, 3) == 1 and self.Zombie_Runner and !specialEyeColors:GetBool() and eyeColor == "red" then
		for k, v in ipairs(self:GetMaterials()) do
			if v == "models/undead/eyeball_zombie" then
				self.DeathCorpseSubMaterials = {k - 1}
				self:SetSubMaterial(k - 1, "models/undead/eyeball_zombie_red")
				break
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DirtSpawn(spawnType)
	self:SetNoDraw(true)

	local function spawnDirt()
		if self:IsValid() then
			self:SetNoDraw( false )
			self:EmitSound( "vj_bmce_zmb/vocals/spawn_dirt_" .. random( 0, 6 ) .. ".mp3", 80, random( 90, 110 ) )
			self:PlaySoundSystem( "Alert" )
			local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() )
			effectdata:SetScale( 25 )
			if random( 1, 2 ) == 1 then util.Effect( "zombie_spawn_dirt", effectdata ) end
			
			ParticleEffect( "bo3_zombie_spawn", self:GetPos(), self:GetAngles(), self )
			self.HasMeleeAttack = true
		end
	end

	if spawnType == "slow" then
		timer.Simple(0.01,function()
			self:VJ_ACT_PLAYACTIVITY( "vjseq_nz_spawn_climbout_fast", true, 4.55, true, 0, { SequenceDuration= 4.55 } )
			spawnDirt()
		end)

	elseif spawnType == "fast" then
		timer.Simple( 0.01, function()
			self:VJ_ACT_PLAYACTIVITY( "vjseq_nz_spawn_jump", true, 1.25, true, 0, { SequenceDuration= 1.25 } )
			self.HasMeleeAttack = false
			spawnDirt()
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "step" then
		self:FootStepSoundCode()
	end

	if key == "infection_step" and self:IsOnGround() then
		local tr = util.TraceLine({
			start = self:GetPos(),
			endpos = self:GetPos() + Vector( 0, 0, -150 ),
			filter = { self }
		})

		if tr.Hit and self.FootSteps[tr.MatType] then
			VJ_EmitSound( self, VJ_PICK( self.FootSteps[tr.MatType] ), self.FootStepSoundLevel, self:VJ_DecideSoundPitch( self.FootStepPitch1, self.FootStepPitch2 ) )
		end
	end

	if key == "slide" then
		VJ_EmitSound( self, "vj_bmce_zmb/vocals/extras/foot_Slide_0" .. random( 0, 2 ) .. ".mp3", self.FootStepSoundLevel, self:VJ_DecideSoundPitch( self.FootStepPitch.a, self.FootStepPitch.b ) )
	end

	if key == "crawl" then
		VJ_EmitSound( self, "vj_bmce_zmb/vocals/extras/crawl_0" .. random( 1, 3 ) .. ".mp3", self.FootStepSoundLevel, self:VJ_DecideSoundPitch( self.FootStepPitch.a, self.FootStepPitch.b ) )
	end

	if key == "crawl" and self:WaterLevel() > 0 and self:WaterLevel() < 3 then
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

	if key == "death" and self:WaterLevel() > 0 and self:WaterLevel() < 3 then
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
--[[ function ENT:SetFireZombie()
	self:EmitSound( "vj_bmce_zmb/vocals/fire_spawn.mp3", 74, random( 82, 110 ) )

	if burnParticles:GetInt() == 1 then	
		ParticleEffectAttach( "smoke_exhaust_01a", PATTACH_POINT_FOLLOW, self, 10 )
		ParticleEffectAttach( "fire_small_01", PATTACH_POINT_FOLLOW, self, 14 )
		self.SoundTbl_Breath = { "vj_bmce_zmb/vocals/fire_idle.mp3" }
		self.Zombie_Fire = 1
		self.BreathSoundLevel = 65
	elseif burnParticles:GetInt() == 2 then
		ParticleEffectAttach( "smoke_exhaust_01a", PATTACH_POINT_FOLLOW, self, 10 )
	end
end ]]
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupZombie()
	local MDL = self:GetModel()
	local Hat_Chance = random( 1, 3 )
	local Unique_Hat = random( 1, 3 )
	local bruiser_Chance = bruiserChance:GetInt()

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
		"npc_vj_bmce_und_sci_female",
		"npc_vj_bmce_und_cwork_male"
	}

	if MDL == "models/undead/scientist.mdl" then
		self:ZombieVoice( "male" )
		self:SetSkin( random( 0, 14 ) )
		self:SetBodygroup( 1, random( 0, 2 ) ) -- Body
		self:SetBodygroup( 2, random( 0, 7 ) ) -- Ties

		if Hat_Chance == 1 then self:SetBodygroup( 2, random( 0, 2 ) ) end
	end

	--[[ if MDL == "models/undead/scientist_burned.mdl" then
		self:SetFireZombie()
		self:ZombieVoice( "male" )
		self:SetSkin( random( 0, 15 ) )
	end ]]

	if MDL == "models/undead/scientist_female.mdl" then
		self:ZombieVoice( "female" )
		self:SetSkin( random( 0, 9 ) )
		self:SetBodygroup( 1, random( 0, 5 ) ) -- Body
		self:SetBodygroup( 2, random( 0, 5 ) ) -- Hair
	end

	if MDL == "models/undead/scientist_casual.mdl" then
		self:ZombieVoice( "male" )
		self:SetSkin( random( 0, 14 ) )
		self:SetBodygroup( 1, random( 0, 5 ) ) -- Body
		self:SetBodygroup( 3, random( 0, 8 ) ) -- Torso

		if Hat_Chance == 1 then self:SetBodygroup( 2, random( 0, 3 ) ) end
	end

	if MDL == "models/undead/guard.mdl"then
		self:SetSkin( random( 0, 14 ) )
		self:SetBodygroup( 1, random( 0, 3 ) ) -- Body
		self:SetBodygroup( 3, random( 0, 3 ) ) -- Chest
		self:SetBodygroup( 4, random( 0, 2 ) ) -- holster
		self:SetBodygroup( 2, random( 0, 5 ) ) -- Hat
		
		self:ZombieVoice( bruiser_Chance > 0 and random( 1, 100 ) <= bruiser_Chance and "bruiser" or "male" )
	end

	--[[ if MDL == "models/undead/guard_burned.mdl" then
		self:SetFireZombie()
		self:SetSkin( random( 0, 15 ) )
		self:SetBodygroup( 1, random( 0, 3 ) ) -- Body
		self:SetBodygroup( 2, random( 0, 5 ) ) -- hat
		self:SetBodygroup( 3, random( 0, 3 ) ) -- Chest
		self:SetBodygroup( 4, random( 0, 2 ) ) -- holster
		self:ZombieVoice( "male" )
	end ]]

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
		self:SetBodygroup( 3, random( 1, 7 ) ) -- Hair
	end

	if MDL == "models/undead/custodian.mdl" then
		self:ZombieVoice( "male" )
		self:SetSkin( random( 0, 17 ) )
		self:SetBodygroup( 1, random( 0, 7 ) ) -- Body
		self:SetBodygroup( 3, random( 0, 1 ) ) -- Vest
		if Hat_Chance == 1 then self:SetBodygroup( 2, random( 0, 4 ) ) end
	end

	if MDL == "models/undead/construction_worker.mdl" then
		self:SetSkin(random( 0, 19 ) )
		self:SetBodygroup(1,random( 0, 3 ) ) -- t-shirts
		self:SetBodygroup(2,random( 0, 3 ) ) -- pants
		self:SetBodygroup(3,random( 0, 1 ) ) -- shows
		self:SetBodygroup(5,random( 3, 14 ) ) -- Glasses
		if Hat_Chance == 1 then self:SetBodygroup( 4, random( 0, 4 ) ) end

		self:ZombieVoice( bruiser_Chance > 0 and random( 1, 100 ) <= bruiser_Chance and "bruiser" or "male" )
	end

	if MDL == "models/undead/fireman.mdl" then
		self:SetSkin( random( 0, 30 ) )
		self:SetBodygroup( 1, random( 0, 3 ) ) -- Body
		self:SetBodygroup( 2, random( 0, 1 ) ) -- gloves
		self:SetBodygroup( 3, random( 0, 3 ) ) -- face
		self:SetBodygroup( 4, random( 0, 3 ) ) -- helmet
		self:SetBodygroup( 5, random( 0, 1 ) ) -- tank rig

		self.ImmuneDamagesTable = {DMG_RADIATION,DMG_NERVEGAS,DMG_BURN,DMG_SLOWBURN}

		self:ZombieVoice( bruiser_Chance > 0 and random( 1, 100 ) <= bruiser_Chance and "bruiser" or "male" )

	end

	if MDL == "models/undead/marine.mdl" then
		self:SetSkin( random( 0, 19 ) )

		if Hat_Chance == 1 then 
			self:SetBodygroup( 3, random( 1, 3 ) ) -- NV
			self:SetBodygroup( 5, random( 1, 2 ) ) -- helmet
		elseif Hat_Chance == 2 then 
			self:SetBodygroup( 5, 3 ) -- helmet
		end

		self:SetBodygroup( 1, random( 0, 1 ) ) -- Body
		self:SetBodygroup( 2, random( 0, 1 ) ) -- gloves
		self:SetBodygroup( 4, random( 0, 1 ) ) -- headset
		self:SetBodygroup( 6, random( 0, 1 ) ) -- pack chest
		self:SetBodygroup( 7, random( 0, 1 ) ) -- pack hips
		self:SetBodygroup( 8, random( 0, 1 ) ) -- pack thigh

		self:ZombieVoice( bruiser_Chance > 0 and random( 1, 100 ) <= bruiser_Chance and "bruiser" or "male" )
	end

	--[[ if MDL == "models/undead/marine_burned.mdl" then
		self:SetFireZombie()
		self:SetSkin( random( 0, 15 ) )
		self:SetBodygroup( 1, random( 0, 1 ) ) -- Body
		self:SetBodygroup( 2, random( 0, 1 ) ) -- gloves
		self:SetBodygroup( 5, random( 0, 2 ) ) -- helmet
		self:SetBodygroup( 6, random( 0, 1 ) ) -- pack chest
		self:SetBodygroup( 7, random( 0, 1 ) ) -- pack hips
		self:SetBodygroup( 8, random( 0, 1 ) ) -- pack thigh
		self:ZombieVoice( "male" )
	end ]]

	if MDL == "models/undead/cafeteria_male.mdl" then
		self:ZombieVoice( "male" )
		self:SetSkin( random( 0, 14 ) )
		self:SetBodygroup( 1, random( 0, 7 ) ) -- Body
		self:SetBodygroup( 2, random( 1, 3 ) ) -- helmet
		self:SetBodygroup( 3, random( 0, 4 ) ) -- chest
	end

	if MDL == "models/undead/cafeteria_male_02.mdl" then
		self:ZombieVoice( "male" )
		self:SetSkin( random( 0, 15 ) )
		self:SetBodygroup( 1, random( 0, 3 ) ) -- Body
		self:SetBodygroup( 2, random( 1, 3 ) ) -- helmet
		self:SetBodygroup( 3, random( 0, 1 ) ) -- chest
		self:SetBodygroup( 4, random( 0, 1 ) ) -- flashlight
	end

	if MDL == "models/undead/cwork.mdl" then
		self:SetSkin( random( 0, 16 ) )
		self:SetBodygroup( 1, random( 0, 11 ) ) -- Body
		self:SetBodygroup( 2, random( 0, 3 ) ) -- helmet
		self:SetBodygroup( 3, random( 0, 1 ) ) -- vest

		self:ZombieVoice( bruiser_Chance > 0 and random( 1, 100 ) <= bruiser_Chance and "bruiser" or "male" )
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
	if self:GetActivity() == ACT_GLIDE or self.LNR_Crawler or self.Flinching or self:GetSequence() == self:LookupSequence( "nz_spawn_climbout_fast" ) or self:GetSequence() == self:LookupSequence( "nz_spawn_jump" ) or self:GetSequence() == self:LookupSequence( "shove_forward_01" ) or self:GetSequence() == self:LookupSequence( "infectionrise" ) or self:GetSequence() == self:LookupSequence( "infectionrise2" ) or self:GetSequence() == self:LookupSequence( "slumprise_a" ) or self:GetSequence() == self:LookupSequence( "slumprise_a2" ) then self.HasDeathAnimation = false end
	if IsValid( self.WeaponModel ) and self.LNR_CanUseWeapon then
	   self:CreateGibEntity( "prop_physics", self.WeaponModel:GetModel(), { Pos=self:GetAttachment( self:LookupAttachment( "anim_attachment_RH" ) ) .Pos, Ang = self:GetAngles(), Vel = "UseDamageForce" } )
	   self.WeaponModel:SetMaterial( "lnr/bonemerge" ) 
	   self.WeaponModel:DrawShadow( false )
	end

	--[[ if self.Zombie_Fire == 1 then
		VJ_EmitSound( self, "vj_bmce_zmb/vocals/fire_death_" .. random( 0, 1 ) .. ".mp3", 80)
		local effectExp = EffectData()
		effectExp:SetOrigin( self:GetPos() )
		ParticleEffect( "explosionTrail_seeds_mvm", self:GetPos(), self:GetAngles() )
		util.Effect( "HelicopterMegaBomb", effectExp )

		local explo_dmg = random(1,5)
		if GetConVar( "vj_bmce_zmb_explode" ):GetInt() == 1 and ( explo_dmg >= 1 and explo_dmg <= 2 ) then
			--util.BlastDamage( self, self, self:GetPos(), 175, 50 )
			util.BlastDamage( self, self, self:GetPos(), 75, 125 )
		end
	end ]]

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

	if hitgroup == HITGROUP_HEAD then
		if random( 1, 4 ) == 1 then
			self:EmitSound( "vj_bmce_zmb/vocals/headshot_" .. random( 0, 6 ) .. ".mp3" )
		end
	end

--[[ 	if hitgroup == HITGROUP_HEAD and !self.LNR_Crawler then
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

	--[[ if self.Zombie_Fire == 1 then
		if burnParticles:GetInt() == 1 then	
			ParticleEffectAttach( "smoke_exhaust_01a", PATTACH_POINT_FOLLOW, corpseEnt, 10 )
		end
	end ]]
	
	local flexWeights = 
	{
		{
			{ 9, 1 }, -- Blink
			{ 43, 1 }, -- Lower Lip
			{ 79, 0.25 } -- Cigar
		},
		{
			{ 9, 0.25 }, -- Blink
			{ 43, 0.25 } -- Lower Lip
		},
		{
			{ 9, 0.6 }, -- Blink
			{ 43, 0.18 } -- Lower Lip
		},
		{
			{ 9, 0.75 }, -- Blink
			{ 43, 0.35 }, -- Lower Lip
			{ 79, 0.5 } -- Cigar
		},
		{
			{ 9, 0.4 }, -- Blink
			{ 43, 0.6 }, -- Lower Lip
			{ 79, 0.8 } -- Cigar
		},
		{
			{ 9, 0.2 } -- Blink
		},
		{
			{ 9, 0.4 } -- Blink
		},
		{
			{ 9, 0.6 } -- Blink
		},
		{
			{ 7, 0.75 }, -- Left Lid Closer
			{ 18, 0.9 } -- Left cheek raiser
		},
		{ -- No forward open (more angry)
			{ 7, 0.41 }, -- Left Lid Closer
			{ 9, 0.18 }, -- Blink
			{ 18, 0.34 }, -- Wrinkler
			{ 35, 0.24 }, -- Bite
			{ 36, 0.30 }, -- Presser
			{ 37, 1.0 },  -- Tightener
			{ 43, 1.0 }, -- Lower Lip
			{ 44, 1.0 }, -- Brow H
			{ 79, 0.53 },  -- Cigar
			{ 80, 0.2 } -- Hairline puff
		}
	}

	local weights = flexWeights[ random( #flexWeights ) ]
	local hairPuffRand = rand( 0.0, 0.2 )

	for _, weight in ipairs( weights ) do
		corpseEnt:SetFlexWeight( weight[1], weight[2] )
		corpseEnt:SetFlexWeight( 80, hairPuffRand )
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
		{
			{4, 0.76}, -- left_lid_tightener
			{13, 0.17}, -- right_outer_raiser
			{15, 0.55}, -- right_lowerer
			{16, 1.39}, -- left_lowerer
			{22, 1.25}, -- left_upper_raiser
			{27, 1.32}, -- chin_raiser
			{28, 1.18}, -- right_part
			{29, 1.46}, -- left_part
			{31, 0.52}, -- left_puckerer
			{32, 0.41}, -- right_funneler
			{35, 1.04}, -- left_stretcher
			{36, 1.46}, -- bite
			{43, 0.06}, -- smile
			{64, 0.41}, -- lowlip_size
			{65, 0.73}, -- uplip_size
			{71, 0.55}, -- nose_w_min
			{77, 0.05}, -- nost_height
			{79, 0.5}, -- nose_tip
			{80, 0.5}, -- cigar_mouth
		},
	}

	local weights = flexWeights[ random( #flexWeights ) ]
	local hairPuffRand = rand( 0.0, 0.2 )

	for _, weight in ipairs( weights ) do
		self:SetFlexWeight( weight[1], weight[2] )
		self:SetFlexWeight( 80, hairPuffRand )
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
local voiceSets = {
	classic_walker = {
		Alert = Tbl_Classic_Alert,
		Idle = Tbl_Classic_Idle,
		CombatIdle = Tbl_Classic_Idle,
		Suppressing = Tbl_Classic_Idle,
		BeforeMeleeAttack = Tbl_Classic_Attack,
		Death = Tbl_Classic_Death,
		MeleeAttack = Tbl_Classic_AttackStrike,
		MeleeAttackMiss = Tbl_Classic_AttackStrike,
		Investigate = Tbl_Classic_Attack,
		LostEnemy = Tbl_Classic_Death_Elec,
		DeathElec = Tbl_Classic_Death_Elec
	},

	classic_runner = {
		Alert = Tbl_Classic_Alert,
		Idle = Tbl_Classic_Idle,
		CombatIdle = Tbl_Classic_Running,
		Suppressing = Tbl_Classic_Running,
		BeforeMeleeAttack = Tbl_Classic_Attack,
		Death = Tbl_Classic_Death,
		MeleeAttack = Tbl_Classic_AttackStrike,
		MeleeAttackMiss = Tbl_Classic_AttackStrike,
		Investigate = Tbl_Classic_Attack,
		LostEnemy = Tbl_Classic_Death_Elec,
		DeathElec = Tbl_Classic_Death_Elec
	},

	classic_crawler = {
		Alert = Tbl_Classic_Alert,
		Idle = Tbl_Classic_Crawling,
		CombatIdle = Tbl_Classic_Crawling,
		Suppressing = Tbl_Classic_Crawling,
		BeforeMeleeAttack = Tbl_Classic_Attack,
		Death = Tbl_Classic_Death,
		MeleeAttack = Tbl_Classic_AttackStrike,
		MeleeAttackMiss = Tbl_Classic_AttackStrike,
		Investigate = Tbl_Classic_Attack,
		LostEnemy = Tbl_Classic_Death_Elec,
		DeathElec = Tbl_Classic_Death_Elec
	},

	bo3_walker = {
		Alert = Tbl_ZC_Alert,
		Idle = Tbl_ZC_Idle,
		CombatIdle = Tbl_ZC_Idle,
		Suppressing = Tbl_ZC_Idle,
		BeforeMeleeAttack = Tbl_ZC_Attack,
		Death = Tbl_ZC_Death,
		MeleeAttack = Tbl_ZC_AttackStrike,
		MeleeAttackMiss = Tbl_Classic_AttackStrike,
		Investigate = Tbl_ZC_Alert,
		LostEnemy = Tbl_ZC_Idle,
		DeathElec = Tbl_Classic_Death_Elec
	},

	bo3_runner = {
		Alert = Tbl_ZC_Alert,
		Idle = Tbl_ZC_Idle,
		CombatIdle = Tbl_ZC_Running,
		Suppressing = Tbl_ZC_Running,
		BeforeMeleeAttack = Tbl_ZC_Attack,
		Death = Tbl_ZC_Death,
		MeleeAttack = Tbl_ZC_AttackStrike,
		MeleeAttackMiss = Tbl_Classic_AttackStrike,
		Investigate = Tbl_ZC_Alert,
		LostEnemy = Tbl_ZC_Idle,
		DeathElec = Tbl_Classic_Death_Elec
	},

	coldwar_walker = {
		Alert = Tbl_CW_Alert,
		Idle = Tbl_CW_Idle,
		CombatIdle = Tbl_CW_Idle,
		Suppressing = Tbl_CW_Idle,
		BeforeMeleeAttack = Tbl_CW_Attack,
		Death = Tbl_CW_Death,
		MeleeAttack = Tbl_CW_AttackStrike,
		MeleeAttackMiss = Tbl_Classic_AttackStrike,
		Investigate = Tbl_CW_Alert,
		LostEnemy = Tbl_CW_Idle,
		DeathElec = Tbl_CW_Death_Elec,
	},

	coldwar_runner = {
		Alert = Tbl_CW_Alert,
		Idle = Tbl_CW_Idle,
		CombatIdle = Tbl_CW_Running,
		Suppressing = Tbl_CW_Running,
		BeforeMeleeAttack = Tbl_CW_Attack,
		Death = Tbl_CW_Death,
		MeleeAttack = Tbl_CW_AttackStrike,
		MeleeAttackMiss = Tbl_Classic_AttackStrike,
		Investigate = Tbl_CW_Alert,
		LostEnemy = Tbl_CW_Idle,
		DeathElec = Tbl_CW_Death_Elec
	},

	coldwar_crawler = {
		Alert = Tbl_CW_Alert,
		Idle = Tbl_CW_Crawling,
		CombatIdle = Tbl_CW_Crawling,
		Suppressing = Tbl_CW_Crawling,
		BeforeMeleeAttack = Tbl_CW_Attack,
		Death = Tbl_CW_Death,
		MeleeAttack = Tbl_CW_AttackStrike,
		MeleeAttackMiss = Tbl_Classic_AttackStrike,
		Investigate = Tbl_CW_Alert,
		LostEnemy = Tbl_CW_Idle,
		DeathElec = Tbl_CW_Death_Elec
	},

	rdr_un_male01_walker = {
		Alert = Tbl_UN_Alert_Male_01,
		Idle = Tbl_UN_Idle_Male_01,
		CombatIdle = Tbl_UN_Attacking_Male_01,
		Suppressing = Tbl_UN_Attacking_Male_01,
		BeforeMeleeAttack = Tbl_UN_Attack_Male_01,
		Death = Tbl_UN_Shared_Death_Male,
		Pain = Tbl_UN_Shared_Pain_Male,
		MeleeAttack = Tbl_Classic_AttackStrike,
		MeleeAttackMiss = Tbl_Classic_AttackStrike,
		Investigate = Tbl_UN_Alert_Male_01,
		LostEnemy = Tbl_UN_Alert_Male_01
	},
	
	rdr_un_male01_runner = {
		Alert = Tbl_UN_Alert_Male_01,
		Idle = Tbl_UN_Idle_Male_01,
		CombatIdle = Tbl_UN_Running_Male_01,
		Suppressing = Tbl_UN_Running_Male_01,
		BeforeMeleeAttack = Tbl_UN_Attack_Male_01,
		Death = Tbl_UN_Shared_Death_Male,
		Pain = Tbl_UN_Shared_Pain_Male,
		MeleeAttack = Tbl_Classic_AttackStrike,
		MeleeAttackMiss = Tbl_Classic_AttackStrike,
		Investigate = Tbl_UN_Alert_Male_01,
		LostEnemy = Tbl_UN_Alert_Male_01
	},

	rdr_un_male02_walker = {
		Alert = Tbl_UN_Alert_Male_02,
		Idle = Tbl_UN_Idle_Male_02,
		CombatIdle = Tbl_UN_Attacking_Male_02,
		Suppressing = Tbl_UN_Attacking_Male_02,
		BeforeMeleeAttack = Tbl_UN_Attack_Male_02,
		Death = Tbl_UN_Shared_Death_Male,
		Pain = Tbl_UN_Shared_Pain_Male,
		MeleeAttack = Tbl_Classic_AttackStrike,
		MeleeAttackMiss = Tbl_Classic_AttackStrike,
		Investigate = Tbl_UN_Alert_Male_02,
		LostEnemy = Tbl_UN_Alert_Male_02
	},

	rdr_un_male02_runner = {
		Alert = Tbl_UN_Alert_Male_02,
		Idle = Tbl_UN_Idle_Male_02,
		CombatIdle = Tbl_UN_Running_Male_02,
		Suppressing = Tbl_UN_Running_Male_02,
		BeforeMeleeAttack = Tbl_UN_Attack_Male_02,
		Death = Tbl_UN_Shared_Death_Male,
		Pain = Tbl_UN_Shared_Pain_Male,
		MeleeAttack = Tbl_Classic_AttackStrike,
		MeleeAttackMiss = Tbl_Classic_AttackStrike,
		Investigate = Tbl_UN_Alert_Male_02,
		LostEnemy = Tbl_UN_Alert_Male_02,
	},

	rdr_un_female01_walker = {
		Alert = Tbl_UN_Alert_Female_01,
		Idle = Tbl_UN_Idle_Female_01,
		CombatIdle = Tbl_UN_Attacking_Female_01,
		Suppressing = Tbl_UN_Attacking_Female_01,
		BeforeMeleeAttack = Tbl_UN_Alert_Female_01,
		Death = Tbl_UN_Shared_Death_Female,
		Pain = Tbl_UN_Shared_Pain_Female,
		MeleeAttack = Tbl_Classic_AttackStrike,
		MeleeAttackMiss = Tbl_Classic_AttackStrike,
		Investigate = Tbl_UN_Alert_Female_01,
		LostEnemy = Tbl_UN_Alert_Female_01
	},

	rdr_un_female01_runner = {
		Alert = Tbl_UN_Alert_Female_01,
		Idle = Tbl_UN_Idle_Female_01,
		CombatIdle = Tbl_UN_Running_Female_01,
		Suppressing = Tbl_UN_Running_Female_01,
		BeforeMeleeAttack = Tbl_UN_Alert_Female_01,
		Death = Tbl_UN_Shared_Death_Female,
		Pain = Tbl_UN_Shared_Pain_Female,
		MeleeAttack = Tbl_Classic_AttackStrike,
		MeleeAttackMiss = Tbl_Classic_AttackStrike,
		Investigate = Tbl_UN_Alert_Female_01,
		LostEnemy = Tbl_UN_Alert_Female_01
	},
}
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

	if self.Zombie_Walker then
		if voiceSet == "classic" then
        	for k, v in pairs( voiceSets.classic_walker ) do
            	self[ "SoundTbl_" .. k ] = v
			end

			self:SetSoundPitch()

		elseif voiceSet == "blackops3" then
			for k, v in pairs( voiceSets.bo3_walker ) do
				self[ "SoundTbl_" .. k ] = v
			end

			self:SetSoundPitch()
		
		elseif voiceSet == "coldwar"  then
			for k, v in pairs( voiceSets.coldwar_walker ) do
				self[ "SoundTbl_" .. k ] = v
			end

		elseif voiceSet == "undeadnightmares" and self.RDR_VoiceType == 1 then
			if RDR_VoiceSet == 1 then
				for k, v in pairs( voiceSets.rdr_un_male01_walker ) do
					self[ "SoundTbl_" .. k ] = v
				end

			elseif RDR_VoiceSet == 2 then
				for k, v in pairs( voiceSets.rdr_un_male02_walker ) do
					self[ "SoundTbl_" .. k ] = v
				end
			end

		elseif voiceSet == "undeadnightmares" and self.RDR_VoiceType == 2 then
			if RDR_VoiceSet_Fem == 1 then
				for k, v in pairs( voiceSets.rdr_un_female01_walker ) do
					self[ "SoundTbl_" .. k ] = v
				end
			end

		elseif voiceSet == "bruiser" then
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
		end
	end

	if self.Zombie_Runner then
		if voiceSet == "classic" then
        	for k, v in pairs( voiceSets.classic_runner ) do
            	self[ "SoundTbl_" .. k ] = v
			end

			self:SetSoundPitch()

		elseif voiceSet == "blackops3" then
			for k, v in pairs( voiceSets.bo3_runner ) do
				self[ "SoundTbl_" .. k ] = v
			end

			self:SetSoundPitch()
		
		elseif voiceSet == "coldwar"  then
			for k, v in pairs( voiceSets.coldwar_runner ) do
				self[ "SoundTbl_" .. k ] = v
			end

		elseif voiceSet == "undeadnightmares" and self.RDR_VoiceType == 1 then
			if RDR_VoiceSet == 1 then
				for k, v in pairs( voiceSets.rdr_un_male01_runner ) do
					self[ "SoundTbl_" .. k ] = v
				end

			elseif RDR_VoiceSet == 2 then
				for k, v in pairs( voiceSets.rdr_un_male02_runner ) do
					self[ "SoundTbl_" .. k ] = v
				end
			end

		elseif voiceSet == "undeadnightmares" and self.RDR_VoiceType == 2 then
			if RDR_VoiceSet_Fem == 1 then
				for k, v in pairs( voiceSets.rdr_un_female01_runner ) do
					self[ "SoundTbl_" .. k ] = v
				end
			end

		elseif voiceSet == "bruiser" then
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

	-- If Super Crawler
	if self.Zombie_SuperCrawler then	
		self.NextSoundTime_Suppressing = VJ_Set( 0, 0.9 )
		if voiceSet == "classic" then
			self.SoundTbl_Alert = Tbl_Classic_Alert
			self.SoundTbl_Idle = Tbl_Classic_Crawling
			self.SoundTbl_CombatIdle = Tbl_Classic_Crawling_Super
			self.SoundTbl_Suppressing = Tbl_Classic_Crawling_Super
			self.SoundTbl_BeforeMeleeAttack = Tbl_Classic_Attack
			self.SoundTbl_Death = Tbl_Classic_Death
			self.SoundTbl_MeleeAttack = Tbl_Classic_AttackStrike
			self.SoundTbl_MeleeAttackMiss = Tbl_Classic_AttackStrike
			self.SoundTbl_Investigate = Tbl_Classic_Attack
			self.SoundTbl_LostEnemy = Tbl_Classic_Death_Elec
			self.SoundTbl_DeathElec = Tbl_Classic_Death_Elec
			self:SetSoundPitch()

		elseif voiceSet == "coldwar" then
			self.SoundTbl_Alert = Tbl_CW_Alert
			self.SoundTbl_Idle = Tbl_CW_Crawling
			self.SoundTbl_CombatIdle = Tbl_CW_Crawling_Super
			self.SoundTbl_Suppressing = Tbl_CW_Crawling_Super
			self.SoundTbl_BeforeMeleeAttack = Tbl_CW_Attack
			self.SoundTbl_Death = Tbl_CW_Death
			self.SoundTbl_MeleeAttack = Tbl_CW_AttackStrike
			self.SoundTbl_MeleeAttackMiss = Tbl_Classic_AttackStrike
			self.SoundTbl_Investigate = Tbl_CW_Alert
			self.SoundTbl_LostEnemy = Tbl_CW_Idle
			self.SoundTbl_DeathElec = Tbl_CW_Death_Elec

		elseif voiceSet == "undeadnightmares" and self.RDR_VoiceType == 1 then
			if RDR_VoiceSet == 1 then
				self.SoundTbl_Alert = Tbl_UN_Alert_Male_01
				self.SoundTbl_Idle = Tbl_UN_Crawling_Male_01
				self.SoundTbl_CombatIdle = Tbl_UN_Crawling_Super_Male_01
				self.SoundTbl_Suppressing = Tbl_UN_Crawling_Super_Male_01
				self.SoundTbl_BeforeMeleeAttack = Tbl_UN_Attack_Male_02
				self.SoundTbl_Death = Tbl_UN_Shared_Death_Male
				self.SoundTbl_Pain = Tbl_UN_Shared_Pain_Male
				self.SoundTbl_MeleeAttack = Tbl_Classic_AttackStrike
				self.SoundTbl_MeleeAttackMiss = Tbl_Classic_AttackStrike
				self.SoundTbl_Investigate = Tbl_UN_Alert_Male_01
				self.SoundTbl_LostEnemy = Tbl_UN_Alert_Male_01
			elseif RDR_VoiceSet == 2 then
				self.SoundTbl_Alert = Tbl_UN_Alert_Male_02
				self.SoundTbl_Idle = Tbl_UN_Crawling_Male_02
				self.SoundTbl_CombatIdle = Tbl_UN_Crawling_Super_Male_02
				self.SoundTbl_Suppressing = Tbl_UN_Crawling_Super_Male_02
				self.SoundTbl_BeforeMeleeAttack = Tbl_UN_Attack_Male_02
				self.SoundTbl_Death = Tbl_UN_Shared_Death_Male
				self.SoundTbl_Pain = Tbl_UN_Shared_Pain_Male
				self.SoundTbl_MeleeAttack = Tbl_Classic_AttackStrike
				self.SoundTbl_MeleeAttackMiss = Tbl_Classic_AttackStrike
				self.SoundTbl_Investigate = Tbl_UN_Alert_Male_02
				self.SoundTbl_LostEnemy = Tbl_UN_Alert_Male_02
			end
		elseif voiceSet == "undeadnightmares" and self.RDR_VoiceType == 2 then
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
		end
	end

	-- If Crawling
	if self.LNR_Crawler then
		self.NextSoundTime_Suppressing = VJ_Set( 0, 0.9 )
		if voiceSet == "classic" then
        	for k, v in pairs( voiceSets.classic_crawler ) do
            	self[ "SoundTbl_" .. k ] = v
			end

			self:SetSoundPitch()

		elseif voiceSet == "coldwar" then
        	for k, v in pairs( voiceSets.coldwar_crawler ) do
            	self[ "SoundTbl_" .. k ] = v
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------