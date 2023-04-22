AddCSLuaFile("shared.lua")
include('shared.lua')

local random = math.random
local rand = math.Rand
local behaviour = GetConVar( "vj_bmce_disaster_status" )
local enemy = GetConVar( "vj_bmce_hostile" )
local wpns = GetConVar( "vj_bmce_weapons" )
local follower = GetConVar( "vj_bmce_following" )
local Hat_Chance = random(1,3)
local Unique_Hat = random(1,1)
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
-- ====== Controller Data ====== --
ENT.VJC_Data = {
	CameraMode = 1,
	ThirdP_Offset = Vector(30, 25, -50),
	FirstP_Bone = "ValveBiped.Bip01_Head1",
	FirstP_Offset = Vector(0, 0, 5),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.FollowPlayer = true
ENT.BloodColor = "Red"
ENT.BecomeEnemyToPlayer = true
ENT.BecomeEnemyToPlayerLevel = 2
ENT.HasItemDropsOnDeath = true
ENT.ItemDropsOnDeathChance = 12
ENT.ItemDropsOnDeath_EntityList = {"item_healthvial","item_battery"}
ENT.HasOnPlayerSight = true
ENT.FootStepTimeRun = 0.3
ENT.FootStepTimeWalk = 0.5
ENT.HasGrenadeAttack = nil
ENT.AnimTbl_GrenadeAttack = {"GrenadeThrow"}
ENT.GrenadeAttackAttachment = "anim_attachment_LH"

	-- ====== Medic Variables ====== --
ENT.AnimTbl_Medic_GiveHealth = {"ThrowItem"}
ENT.Medic_SpawnPropOnHealModel = "models/weapons/zworld_health/bandages.mdl" 
ENT.Medic_CheckDistance = 600
ENT.Medic_HealDistance = 100
ENT.Medic_HealthAmount = 50
ENT.Medic_NextHealTime = VJ_Set(10, 15)
ENT.Medic_SpawnPropOnHeal = true

ENT.AllowPrintingInChat = false -- Usually, I keep this one, but with the custom no following deal, you get conflicting chat msgs, hide it!
ENT.IdleDialogueDistance = 300

	-- ====== Flinching Variables ====== --
ENT.CanFlinch = 1
ENT.FlinchChance = 8
ENT.HitGroupFlinching_Values = {
	{HitGroup={HITGROUP_LEFTARM}, Animation={ACT_FLINCH_LEFTARM}},
	{HitGroup={HITGROUP_LEFTLEG}, Animation={ACT_FLINCH_LEFTARM}},
	{HitGroup={HITGROUP_RIGHTARM}, Animation={ACT_FLINCH_RIGHTARM}},
	{HitGroup={HITGROUP_RIGHTLEG}, Animation={ACT_FLINCH_RIGHTARM}},
	{HitGroup={HITGROUP_STOMACH}, Animation={ACT_FLINCH_STOMACH}},
	{HitGroup={HITGROUP_CHEST}, Animation={ACT_FLINCH_CHEST}},
	{HitGroup={HITGROUP_HEAD}, Animation={ACT_FLINCH_HEAD}}
}

-- move to armed down bellow --
ENT.HasMeleeAttack = true 
ENT.AnimTbl_MeleeAttack = {"swing","pushplayer","thrust","barrelpush","melee_slice"}
ENT.MeleeAttackDamage = random( 4, 10)
ENT.NextMeleeAttackTime = 0
-- sound pitches
ENT.DeathSoundPitch = VJ_Set(100, 100)
ENT.OnPlayerSightSoundChance = 3
-- CUSTOM BELOW!
ENT.MeleeAttackDistance = 45
ENT.DisasterBehavior = nil -- 0 = Pre Disaster sounds, 1 = Post Disaster sounds
ENT.Agressive = false -- used for HECU, SEC Guards
ENT.PainVoice = 0 -- used for HECU custom pain voices
ENT.Otis = nil -- used for Otis Voiceset
ENT.Radio_ChatterTime = 0 -- used for radios, security / hecu.
ENT.BMCE_Staff = nil -- used for VJ_NPC_Class
ENT.BMCE_Hat = 0
-- 0 no hat
-- 1 beret (security)
-- 2 beret (hecu)
-- 3 boonie

--local SoundTbl_OnFire = {"vj_bmce/vocals/vj_bmce_hgrunt/die_long1.wav","vj_bmce/vocals/vj_bmce_hgrunt/die_long2.wav","vj_bmce/vocals/vj_bmce_hgrunt/die_long3.wav","vj_bmce/vocals/vj_bmce_hgrunt/die_long4.wav","vj_bmce/vocals/vj_bmce_hgrunt/die_long5.wav","vj_bmce/vocals/vj_bmce_hgrunt/die_long6.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize()
	self:SetNPCBodyGroups()	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UseMaleVoice()
	if self.DisasterBehavior == 0 then --Pre Disaster sounds
		self.SoundTbl_Pain = {"vj_bmce/vocals/vj_bmce_male/die1.wav","vj_bmce/vocals/vj_bmce_male/die2.wav","vj_bmce/vocals/vj_bmce_male/die3.wav","vj_bmce/vocals/vj_bmce_male/die4.wav","vj_bmce/vocals/vj_bmce_male/die5.wav","vj_bmce/vocals/vj_bmce_male/die6.wav","vj_bmce/vocals/vj_bmce_male/die7.wav"}
		self.SoundTbl_Death = {"vj_bmce/vocals/vj_bmce_male/die1.wav","vj_bmce/vocals/vj_bmce_male/die2.wav","vj_bmce/vocals/vj_bmce_male/die3.wav","vj_bmce/vocals/vj_bmce_male/die4.wav","vj_bmce/vocals/vj_bmce_male/die5.wav","vj_bmce/vocals/vj_bmce_male/die6.wav","vj_bmce/vocals/vj_bmce_male/die7.wav","vj_bmce/vocals/vj_bmce_hgrunt_us_waw/generic_death_german_10.mp3","vj_bmce/vocals/vj_bmce_hgrunt_us_waw/generic_death_german_11.mp3","vj_bmce/vocals/vj_bmce_hgrunt_us_waw/generic_death_german_12.mp3","vj_bmce/vocals/vj_bmce_hgrunt_us_waw/generic_death_german_13.mp3","vj_bmce/vocals/vj_bmce_hgrunt_us_waw/generic_death_german_14.mp3" }
		self.SoundTbl_Alert = {"vj_bmce/vocals/vj_bmce_male/alert1.wav","vj_bmce/vocals/vj_bmce_male/alert2.wav","vj_bmce/vocals/vj_bmce_male/alert3.wav","vj_bmce/vocals/vj_bmce_male/alert4.wav","vj_bmce/vocals/vj_bmce_male/alert5.wav","vj_bmce/vocals/vj_bmce_male/alert6.wav"}
		self.SoundTbl_CombatIdle = {"vj_bmce/vocals/vj_bmce_male/attack1.wav","vj_bmce/vocals/vj_bmce_male/attack2.wav","vj_bmce/vocals/vj_bmce_male/attack3.wav","vj_bmce/vocals/vj_bmce_male/attack4.wav","vj_bmce/vocals/vj_bmce_male/attack5.wav","vj_bmce/vocals/vj_bmce_male/attack6.wav","vj_bmce/vocals/vj_bmce_male/attack7.wav","vj_bmce/vocals/vj_bmce_male/attack8.wav","vj_bmce/vocals/vj_bmce_male/attack9.wav","vj_bmce/vocals/vj_bmce_male/attack10.wav","vj_bmce/vocals/vj_bmce_male/attack11.wav","vj_bmce/vocals/vj_bmce_male/attack12.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer1.wav","vj_bmce/vocals/vj_bmce_male/spotgreande2.wav"}
		self.SoundTbl_OnGrenadeSight = {"vj_bmce/vocals/vj_bmce_male/spotgreande1.wav","vj_bmce/vocals/vj_bmce_male/spotgreande2.wav","vj_bmce/vocals/vj_bmce_male/spotgreande3.wav","vj_bmce/vocals/vj_bmce_male/spotgreande4.wav","vj_bmce/vocals/vj_bmce_male/spotgreande5.wav","vj_bmce/vocals/vj_bmce_male/spotgreande6.wav","vj_bmce/vocals/vj_bmce_male/spotgreande7.wav","vj_bmce/vocals/vj_bmce_male/spotgreande8.wav"}
		self.SoundTbl_AllyDeath = {"vj_bmce/vocals/vj_bmce_male/ally_death1.wav","vj_bmce/vocals/vj_bmce_male/ally_death2.wav","vj_bmce/vocals/vj_bmce_male/spotgreande2.wav","vj_bmce/vocals/vj_bmce_male/spotgreande3.wav","vj_bmce/vocals/vj_bmce_male/spotgreande4.wav",}
		self.SoundTbl_BecomeEnemyToPlayer = {"vj_bmce/vocals/vj_bmce_male/hateplayer1.wav","vj_bmce/vocals/vj_bmce_male/hateplayer2.wav","vj_bmce/vocals/vj_bmce_male/hateplayer3.wav","vj_bmce/vocals/vj_bmce_male/hateplayer4.wav","vj_bmce/vocals/vj_bmce_male/hateplayer5.wav","vj_bmce/vocals/vj_bmce_male/hateplayer6.wav","vj_bmce/vocals/vj_bmce_male/hateplayer7.wav","vj_bmce/vocals/vj_bmce_male/hateplayer8.wav"}
		self.SoundTbl_MoveOutOfPlayersWay = {"vj_bmce/vocals/vj_bmce_male/move_out_of_ply_way1.wav","vj_bmce/vocals/vj_bmce_male/move_out_of_ply_way2.wav","vj_bmce/vocals/vj_bmce_male/move_out_of_ply_way3.wav","vj_bmce/vocals/vj_bmce_male/move_out_of_ply_way4.wav","vj_bmce/vocals/vj_bmce_male/move_out_of_ply_way5.wav","vj_bmce/vocals/vj_bmce_male/move_out_of_ply_way6.wav","vj_bmce/vocals/vj_bmce_male/move_out_of_ply_way7.wav","vj_bmce/vocals/vj_bmce_male/move_out_of_ply_way8.wav","vj_bmce/vocals/vj_bmce_male/move_out_of_ply_way9.wav","vj_bmce/vocals/vj_bmce_male/move_out_of_ply_way10.wav","vj_bmce/vocals/vj_bmce_male/move_out_of_ply_way11.wav","vj_bmce/vocals/vj_bmce_male/move_out_of_ply_way12.wav","vj_bmce/vocals/vj_bmce_male/move_out_of_ply_way13.wav","vj_bmce/vocals/vj_bmce_male/move_out_of_ply_way14.wav","vj_bmce/vocals/vj_bmce_male/move_out_of_ply_way15.wav","vj_bmce/vocals/vj_bmce_male/move_out_of_ply_way16.wav"}		
		self.SoundTbl_Idle = {"vj_bmce/vocals/vj_bmce_male/idlechatter1.wav","vj_bmce/vocals/vj_bmce_male/idlechatter2.wav","vj_bmce/vocals/vj_bmce_male/idlechatter3.wav","vj_bmce/vocals/vj_bmce_male/idlechatter4.wav","vj_bmce/vocals/vj_bmce_male/idlechatter5.wav","vj_bmce/vocals/vj_bmce_male/idlechatter6.wav","vj_bmce/vocals/vj_bmce_male/idlechatter7.wav","vj_bmce/vocals/vj_bmce_male/idlechatter8.wav","vj_bmce/vocals/vj_bmce_male/idlechatter9.wav","vj_bmce/vocals/vj_bmce_male/idlechatter10.wav","vj_bmce/vocals/vj_bmce_male/idlechatter12.wav","vj_bmce/vocals/vj_bmce_male/idlechatter13.wav","vj_bmce/vocals/vj_bmce_male/idlechatter14.wav","vj_bmce/vocals/vj_bmce_male/idlechatter15.wav","vj_bmce/vocals/vj_bmce_male/idlechatter16.wav","vj_bmce/vocals/vj_bmce_male/idlechatter17.wav","vj_bmce/vocals/vj_bmce_male/idlechatter18.wav"}
		self.SoundTbl_IdleDialogue = {"vj_bmce/vocals/vj_bmce_male/question1.wav","vj_bmce/vocals/vj_bmce_male/question2.wav","vj_bmce/vocals/vj_bmce_male/question3.wav","vj_bmce/vocals/vj_bmce_male/question4.wav","vj_bmce/vocals/vj_bmce_male/question5.wav","vj_bmce/vocals/vj_bmce_male/question6.wav","vj_bmce/vocals/vj_bmce_male/question7.wav","vj_bmce/vocals/vj_bmce_male/question8.wav","vj_bmce/vocals/vj_bmce_male/question9.wav","vj_bmce/vocals/vj_bmce_male/question10.wav","vj_bmce/vocals/vj_bmce_male/question11.wav","vj_bmce/vocals/vj_bmce_male/question12.wav","vj_bmce/vocals/vj_bmce_male/question13.wav","vj_bmce/vocals/vj_bmce_male/question14.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre01.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre02.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre03.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre04.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre05.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre06.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre07.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre08.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre09.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre10.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre11.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre12.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre13.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre14.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre15.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre16.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre17.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre18.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre19.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre20.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre21.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre22.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre23.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre24.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre25.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre26.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre27.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre28.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre29.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre30.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre31.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre32.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre33.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre34.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre35.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre36.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre37.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre38.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre39.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre40.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre41.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre42.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre43.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre44.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre45.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre46.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre47.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre48.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre49.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre50.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre51.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre52.wav","vj_bmce/vocals/vj_bmce_male_qna/question_pre53.wav"}
		self.SoundTbl_IdleDialogueAnswer = {"vj_bmce/vocals/vj_bmce_male/answer1.wav","vj_bmce/vocals/vj_bmce_male/answer2.wav","vj_bmce/vocals/vj_bmce_male/answer3.wav","vj_bmce/vocals/vj_bmce_male/answer4.wav","vj_bmce/vocals/vj_bmce_male/answer5.wav","vj_bmce/vocals/vj_bmce_male/answer6.wav","vj_bmce/vocals/vj_bmce_male/answer7.wav","vj_bmce/vocals/vj_bmce_male/answer8.wav","vj_bmce/vocals/vj_bmce_male/answer9.wav","vj_bmce/vocals/vj_bmce_male/answer10.wav","vj_bmce/vocals/vj_bmce_male/answer11.wav","vj_bmce/vocals/vj_bmce_male/answer12.wav","vj_bmce/vocals/vj_bmce_male/answer13.wav","vj_bmce/vocals/vj_bmce_male/answer14.wav","vj_bmce/vocals/vj_bmce_male/answer15.wav","vj_bmce/vocals/vj_bmce_male/answer16.wav","vj_bmce/vocals/vj_bmce_male/answer17.wav","vj_bmce/vocals/vj_bmce_male/answer18.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre01.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre02.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre03.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre04.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre05.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre06.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre07.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre08.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre09.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre10.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre11.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre12.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre13.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre14.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre15.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre16.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre17.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre18.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre19.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre20.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre21.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre22.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre23.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre24.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre25.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre26.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre27.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre28.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre29.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre30.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre31.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre32.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre33.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre34.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre35.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre36.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre37.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre38.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre39.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre40.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre41.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre42.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre43.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre44.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre45.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre46.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre47.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre48.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre49.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre50.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre51.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre52.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre53.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre54.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre55.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre56.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre57.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre58.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre59.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre60.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre61.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre62.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre63.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre64.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre65.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre66.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre67.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre68.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre69.wav","vj_bmce/vocals/vj_bmce_male_qna/answer_pre70.wav"}
		self.SoundTbl_FollowPlayer = {"vj_bmce/vocals/vj_bmce_male/startfollowing1.wav","vj_bmce/vocals/vj_bmce_male/startfollowing2.wav","vj_bmce/vocals/vj_bmce_male/startfollowing3.wav","vj_bmce/vocals/vj_bmce_male/startfollowing4.wav","vj_bmce/vocals/vj_bmce_male/startfollowing5.wav","vj_bmce/vocals/vj_bmce_male/startfollowing6.wav"}
		self.SoundTbl_UnFollowPlayer = {"vj_bmce/vocals/vj_bmce_male/stopfollowing1.wav","vj_bmce/vocals/vj_bmce_male/stopfollowing2.wav","vj_bmce/vocals/vj_bmce_male/stopfollowing3.wav","vj_bmce/vocals/vj_bmce_male/stopfollowing4.wav","vj_bmce/vocals/vj_bmce_male/stopfollowing5.wav","vj_bmce/vocals/vj_bmce_male/stopfollowing6.wav"}
		self.SoundTbl_OnPlayerSight = {"vj_bmce/vocals/vj_bmce_male/spot_player1.wav","vj_bmce/vocals/vj_bmce_male/spot_player2.wav","vj_bmce/vocals/vj_bmce_male/spot_player3.wav","vj_bmce/vocals/vj_bmce_male/spot_player4.wav","vj_bmce/vocals/vj_bmce_male/spot_player5.wav","vj_bmce/vocals/vj_bmce_male/spot_player6.wav","vj_bmce/vocals/vj_bmce_male/spot_player7.wav","vj_bmce/vocals/vj_bmce_male/spot_player8.wav"}
		self.SoundTbl_DamageByPlayer = {"vj_bmce/vocals/vj_bmce_male/stupidplayer1.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer2.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer3.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer4.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer5.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer6.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer7.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer8.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer9.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer10.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer11.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer12.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer13.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer14.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer15.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer16.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer17.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer18.wav"}
		self.SoundTbl_MedicBeforeHeal = {"vj_bmce/vocals/vj_bmce_male/heal_player1.wav","vj_bmce/vocals/vj_bmce_male/heal_player2.wav","vj_bmce/vocals/vj_bmce_male/heal_player3.wav","vj_bmce/vocals/vj_bmce_male/heal_player4.wav","vj_bmce/vocals/vj_bmce_male/heal_player5.wav","vj_bmce/vocals/vj_bmce_male/heal_player6.wav"}
		self.SoundTbl_Investigate = {"vj_bmce/vocals/vj_bmce_male/attack1.wav","vj_bmce/vocals/vj_bmce_male/attack2.wav","vj_bmce/vocals/vj_bmce_male/attack3.wav","vj_bmce/vocals/vj_bmce_male/attack7.wav",}
		-- custom
		self.SoundTbl_LeaveMeAlone = {}
		self.SoundTbl_OnFire = {}
	end
end

-- "vj_bmce/vocals/vj_bmce_hgrunt_us_waw/generic_death_german_00.mp3","vj_bmce/vocals/vj_bmce_hgrunt_us_waw/generic_death_german_01.mp3","vj_bmce/vocals/vj_bmce_hgrunt_us_waw/generic_death_german_02.mp3","vj_bmce/vocals/vj_bmce_hgrunt_us_waw/generic_death_german_03.mp3","vj_bmce/vocals/vj_bmce_hgrunt_us_waw/generic_death_german_04.mp3","vj_bmce/vocals/vj_bmce_hgrunt_us_waw/generic_death_german_05.mp3","vj_bmce/vocals/vj_bmce_hgrunt_us_waw/generic_death_german_06.mp3","vj_bmce/vocals/vj_bmce_hgrunt_us_waw/generic_death_german_07.mp3","vj_bmce/vocals/vj_bmce_hgrunt_us_waw/generic_death_german_08.mp3","vj_bmce/vocals/vj_bmce_hgrunt_us_waw/generic_death_german_09.mp3","vj_bmce/vocals/vj_bmce_hgrunt_us_waw/generic_death_german_10.mp3","vj_bmce/vocals/vj_bmce_hgrunt_us_waw/generic_death_german_11.mp3","vj_bmce/vocals/vj_bmce_hgrunt_us_waw/generic_death_german_12.mp3","vj_bmce/vocals/vj_bmce_hgrunt_us_waw/generic_death_german_13.mp3","vj_bmce/vocals/vj_bmce_hgrunt_us_waw/generic_death_german_14.mp3" }
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UseFemaleVoice()
	if self.DisasterBehavior == 0 then -- Pre Disaster sounds
		self.SoundTbl_Pain = {"vj_bmce/vocals/vj_bmce_female/die1.wav","vj_bmce/vocals/vj_bmce_female/die2.wav","vj_bmce/vocals/vj_bmce_female/die3.wav","vj_bmce/vocals/vj_bmce_female/die4.wav","vj_bmce/vocals/vj_bmce_female/die5.wav","vj_bmce/vocals/vj_bmce_female/die6.wav","vj_bmce/vocals/vj_bmce_female/die7.wav"}
		self.SoundTbl_Death = {"vj_bmce/vocals/vj_bmce_female/die1.wav","vj_bmce/vocals/vj_bmce_female/die2.wav","vj_bmce/vocals/vj_bmce_female/die3.wav","vj_bmce/vocals/vj_bmce_female/die4.wav","vj_bmce/vocals/vj_bmce_female/die5.wav","vj_bmce/vocals/vj_bmce_female/die6.wav","vj_bmce/vocals/vj_bmce_female/die7.wav"}
		self.SoundTbl_Idle = {"vj_bmce/vocals/vj_bmce_female/post_idlechatter2.wav","vj_bmce/vocals/vj_bmce_female/post_idlechatter4.wav","vj_bmce/vocals/vj_bmce_female/post_idlechatter6.wav","vj_bmce/vocals/vj_bmce_female/post_idlechatter7.wav","vj_bmce/vocals/vj_bmce_female/post_idlechatter8.wav","vj_bmce/vocals/vj_bmce_female/post_idlechatter9.wav","vj_bmce/vocals/vj_bmce_female_presci/idlechatter1.wav","vj_bmce/vocals/vj_bmce_female_presci/idlechatter2.wav","vj_bmce/vocals/vj_bmce_female_presci/idlechatter3.wav","vj_bmce/vocals/vj_bmce_female_presci/idlechatter4.wav","vj_bmce/vocals/vj_bmce_female_presci/idlechatter5.wav","vj_bmce/vocals/vj_bmce_female_presci/idlechatter6.wav","vj_bmce/vocals/vj_bmce_female_presci/idlechatter7.wav","vj_bmce/vocals/vj_bmce_female_presci/idlechatter8.wav","vj_bmce/vocals/vj_bmce_female_presci/idlechatter9.wav","vj_bmce/vocals/vj_bmce_female_presci/idlechatter10.wav","vj_bmce/vocals/vj_bmce_female_presci/idlechatter11.wav","vj_bmce/vocals/vj_bmce_female_presci/idlechatter12.wav","vj_bmce/vocals/vj_bmce_female_presci/idlechatter13.wav"}
		self.SoundTbl_IdleDialogue = {"vj_bmce/vocals/vj_bmce_female/question_pre01.wav","vj_bmce/vocals/vj_bmce_female/question_pre02.wav","vj_bmce/vocals/vj_bmce_female/question_pre03.wav","vj_bmce/vocals/vj_bmce_female/question_pre04.wav","vj_bmce/vocals/vj_bmce_female/question_pre05.wav","vj_bmce/vocals/vj_bmce_female_presci/question1.wav","vj_bmce/vocals/vj_bmce_female_presci/question2.wav","vj_bmce/vocals/vj_bmce_female_presci/question3.wav","vj_bmce/vocals/vj_bmce_female_presci/question4.wav","vj_bmce/vocals/vj_bmce_female_presci/question5.wav","vj_bmce/vocals/vj_bmce_female_presci/question6.wav","vj_bmce/vocals/vj_bmce_female_presci/question7.wav"}
		self.SoundTbl_IdleDialogueAnswer = {"vj_bmce/vocals/vj_bmce_female_presci/answer1.wav","vj_bmce/vocals/vj_bmce_female_presci/answer2.wav","vj_bmce/vocals/vj_bmce_female_presci/answer3.wav","vj_bmce/vocals/vj_bmce_female/answer_pre01.wav","vj_bmce/vocals/vj_bmce_female/answer_pre02.wav","vj_bmce/vocals/vj_bmce_female/answer_pre03.wav","vj_bmce/vocals/vj_bmce_female/answer_pre04.wav","vj_bmce/vocals/vj_bmce_female/answer_pre05.wav","vj_bmce/vocals/vj_bmce_female/answer_pre06.wav","vj_bmce/vocals/vj_bmce_female/answer_pre07.wav","vj_bmce/vocals/vj_bmce_female/answer_pre08.wav","vj_bmce/vocals/vj_bmce_female/answer_pre09.wav","vj_bmce/vocals/vj_bmce_female/answer_pre10.wav","vj_bmce/vocals/vj_bmce_female/answer_pre11.wav","vj_bmce/vocals/vj_bmce_female/answer_pre12.wav","vj_bmce/vocals/vj_bmce_female/answer_pre13.wav","vj_bmce/vocals/vj_bmce_female/answer_pre14.wav","vj_bmce/vocals/vj_bmce_female/answer_pre15.wav","vj_bmce/vocals/vj_bmce_female/answer_pre16.wav","vj_bmce/vocals/vj_bmce_female/answer_pre17.wav","vj_bmce/vocals/vj_bmce_female/answer_pre18.wav","vj_bmce/vocals/vj_bmce_female/answer_pre19.wav","vj_bmce/vocals/vj_bmce_female/answer_pre20.wav","vj_bmce/vocals/vj_bmce_female/answer_pre21.wav","vj_bmce/vocals/vj_bmce_female/answer_pre22.wav"}
		self.SoundTbl_Alert = {"vj_bmce/vocals/vj_bmce_female/alert1.wav","vj_bmce/vocals/vj_bmce_female/alert2.wav","vj_bmce/vocals/vj_bmce_female/alert3.wav","vj_bmce/vocals/vj_bmce_female/alert4.wav","vj_bmce/vocals/vj_bmce_female/alert5.wav","vj_bmce/vocals/vj_bmce_female/alert6.wav"}
		self.SoundTbl_AllyDeath = {"vj_bmce/vocals/vj_bmce_female/ally_death1.wav","vj_bmce/vocals/vj_bmce_female/ally_death2.wav","vj_bmce/vocals/vj_bmce_female/ally_death3.wav","vj_bmce/vocals/vj_bmce_female/ally_death4.wav","vj_bmce/vocals/vj_bmce_female/ally_death5.wav"}
		self.SoundTbl_CombatIdle = {"vj_bmce/vocals/vj_bmce_female/attack1.wav","vj_bmce/vocals/vj_bmce_female/attack2.wav","vj_bmce/vocals/vj_bmce_female/attack3.wav","vj_bmce/vocals/vj_bmce_female/attack4.wav","vj_bmce/vocals/vj_bmce_female/attack5.wav","vj_bmce/vocals/vj_bmce_female/attack6.wav","vj_bmce/vocals/vj_bmce_female/attack7.wav","vj_bmce/vocals/vj_bmce_female/attack8.wav","vj_bmce/vocals/vj_bmce_female/attack9.wav","vj_bmce/vocals/vj_bmce_female/attack10.wav","vj_bmce/vocals/vj_bmce_female/attack11.wav","vj_bmce/vocals/vj_bmce_female/attack12.wav"}
		self.SoundTbl_OnGrenadeSight = {"vj_bmce/vocals/vj_bmce_female/spot_grenade1.wav","vj_bmce/vocals/vj_bmce_female/spot_grenade2.wav"}
		self.SoundTbl_BecomeEnemyToPlayer = {"vj_bmce/vocals/vj_bmce_female/stupidplayer5.wav","vj_bmce/vocals/vj_bmce_female/stupidplayer6.wav"}
		self.SoundTbl_MoveOutOfPlayersWay = {"vj_bmce/vocals/vj_bmce_female/bump1.wav","vj_bmce/vocals/vj_bmce_female/bump2.wav","vj_bmce/vocals/vj_bmce_female/bump3.wav","vj_bmce/vocals/vj_bmce_female/bump4.wav","vj_bmce/vocals/vj_bmce_female/bump5.wav","vj_bmce/vocals/vj_bmce_female/bump6.wav","vj_bmce/vocals/vj_bmce_female/bump7.wav","vj_bmce/vocals/vj_bmce_female/bump8.wav"}
		self.SoundTbl_FollowPlayer = {"vj_bmce/vocals/vj_bmce_female/startfollowing1.wav","vj_bmce/vocals/vj_bmce_female/startfollowing2.wav","vj_bmce/vocals/vj_bmce_female/startfollowing3.wav","vj_bmce/vocals/vj_bmce_female/startfollowing4.wav"}
		self.SoundTbl_UnFollowPlayer = {"vj_bmce/vocals/vj_bmce_female/stopfollowing1.wav","vj_bmce/vocals/vj_bmce_female/stopfollowing2.wav","vj_bmce/vocals/vj_bmce_female/stopfollowing3.wav","vj_bmce/vocals/vj_bmce_female/stopfollowing4.wav","vj_bmce/vocals/vj_bmce_female/stopfollowing5.wav","vj_bmce/vocals/vj_bmce_female/stopfollowing6.wav"}
		self.SoundTbl_OnPlayerSight = {"vj_bmce/vocals/vj_bmce_female/seeplayer1.wav","vj_bmce/vocals/vj_bmce_female/seeplayer2.wav","vj_bmce/vocals/vj_bmce_female/seeplayer3.wav","vj_bmce/vocals/vj_bmce_female/seeplayer4.wav","vj_bmce/vocals/vj_bmce_female/seeplayer5.wav"}
		self.SoundTbl_DamageByPlayer = {"vj_bmce/vocals/vj_bmce_female/stupidplayer1.wav","vj_bmce/vocals/vj_bmce_female/stupidplayer2.wav","vj_bmce/vocals/vj_bmce_female/stupidplayer3.wav","vj_bmce/vocals/vj_bmce_female/stupidplayer4.wav","vj_bmce/vocals/vj_bmce_female/stupidplayer5.wav","vj_bmce/vocals/vj_bmce_female/stupidplayer6.wav"}
		self.SoundTbl_MedicBeforeHeal = {"vj_bmce/vocals/vj_bmce_female/health1.wav","vj_bmce/vocals/vj_bmce_female/health2.wav","vj_bmce/vocals/vj_bmce_female/health3.wav","vj_bmce/vocals/vj_bmce_female/health4.wav"}
		self.SoundTbl_Investigate = {"vj_bmce/vocals/vj_bmce_female/answer_pre21.wav","vj_bmce/vocals/vj_bmce_female/answer_pre09.wav"}
		-- custom
		self.SoundTbl_LeaveMeAlone = {}
		self.SoundTbl_OnFire = {}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UseMaleSecGuardVoice()
	if self.DisasterBehavior == 0 then -- Pre Disaster sounds
		self.SoundTbl_Idle = {"vj_bmce/vocals_revamp/secguard/idle/idle_01.wav","vj_bmce/vocals_revamp/secguard/idle/idle_02.wav","vj_bmce/vocals_revamp/secguard/idle/idle_03.wav","vj_bmce/vocals_revamp/secguard/idle/idle_04.wav","vj_bmce/vocals_revamp/secguard/idle/idle_05.wav","vj_bmce/vocals_revamp/secguard/idle/idle_06.wav","vj_bmce/vocals_revamp/secguard/idle/idle_07.wav","vj_bmce/vocals_revamp/secguard/idle/idle_08.wav","vj_bmce/vocals_revamp/secguard/idle/idle_09.wav","vj_bmce/vocals_revamp/secguard/idle/idle_10.wav","vj_bmce/vocals_revamp/secguard/idle/idle_11.wav","vj_bmce/vocals_revamp/secguard/idle/idle_12.wav","vj_bmce/vocals_revamp/secguard/idle/idle_13.wav","vj_bmce/vocals_revamp/secguard/idle/idle_14.wav","vj_bmce/vocals_revamp/secguard/idle/idle_15.wav","vj_bmce/vocals_revamp/secguard/idle/idle_16.wav","vj_bmce/vocals_revamp/secguard/idle/idle_17.wav","vj_bmce/vocals_revamp/secguard/idle/idle_18.wav","vj_bmce/vocals_revamp/secguard/idle/idle_19.wav","vj_bmce/vocals_revamp/secguard/idle/idle_20.wav","vj_bmce/vocals_revamp/secguard/idle/idle_21.wav","vj_bmce/vocals_revamp/secguard/idle/idle_22.wav","vj_bmce/vocals_revamp/secguard/idle/idle_23.wav","vj_bmce/vocals_revamp/secguard/idle/idle_24.wav","vj_bmce/vocals_revamp/secguard/idle/idle_25.wav","vj_bmce/vocals_revamp/secguard/idle/idle_26.wav","vj_bmce/vocals_revamp/secguard/idle/idle_27.wav","vj_bmce/vocals_revamp/secguard/idle/idle_28.wav","vj_bmce/vocals_revamp/secguard/idle/idle_29.wav","vj_bmce/vocals_revamp/secguard/idle/idle_30.wav","vj_bmce/vocals_revamp/secguard/idle/idle_31.wav","vj_bmce/vocals_revamp/secguard/idle/idle_32.wav"}
		self.SoundTbl_IdleDialogue = {"vj_bmce/vocals_revamp/secguard/idle/question_01.wav","vj_bmce/vocals_revamp/secguard/idle/question_02.wav","vj_bmce/vocals_revamp/secguard/idle/question_03.wav","vj_bmce/vocals_revamp/secguard/idle/question_04.wav","vj_bmce/vocals_revamp/secguard/idle/question_05.wav","vj_bmce/vocals_revamp/secguard/idle/question_06.wav","vj_bmce/vocals_revamp/secguard/idle/question_07.wav","vj_bmce/vocals_revamp/secguard/idle/question_08.wav","vj_bmce/vocals_revamp/secguard/idle/question_09.wav","vj_bmce/vocals_revamp/secguard/idle/question_10.wav","vj_bmce/vocals_revamp/secguard/idle/question_11.wav","vj_bmce/vocals_revamp/secguard/idle/question_12.wav","vj_bmce/vocals_revamp/secguard/idle/question_13.wav","vj_bmce/vocals_revamp/secguard/idle/question_14.wav","vj_bmce/vocals_revamp/secguard/idle/question_15.wav","vj_bmce/vocals_revamp/secguard/idle/question_16.wav","vj_bmce/vocals_revamp/secguard/idle/question_17.wav","vj_bmce/vocals_revamp/secguard/idle/question_18.wav","vj_bmce/vocals_revamp/secguard/idle/question_19.wav","vj_bmce/vocals_revamp/secguard/idle/question_20.wav","vj_bmce/vocals_revamp/secguard/idle/question_21.wav","vj_bmce/vocals_revamp/secguard/idle/question_22.wav","vj_bmce/vocals_revamp/secguard/idle/question_23.wav","vj_bmce/vocals_revamp/secguard/idle/question_24.wav","vj_bmce/vocals_revamp/secguard/idle/question_25.wav","vj_bmce/vocals_revamp/secguard/idle/question_26.wav"}
		self.SoundTbl_IdleDialogueAnswer = {"vj_bmce/vocals_revamp/secguard/idle/respond_01.wav","vj_bmce/vocals_revamp/secguard/idle/respond_02.wav","vj_bmce/vocals_revamp/secguard/idle/respond_03.wav","vj_bmce/vocals_revamp/secguard/idle/respond_04.wav","vj_bmce/vocals_revamp/secguard/idle/respond_05.wav","vj_bmce/vocals_revamp/secguard/idle/respond_06.wav","vj_bmce/vocals_revamp/secguard/idle/respond_07.wav","vj_bmce/vocals_revamp/secguard/idle/respond_08.wav","vj_bmce/vocals_revamp/secguard/idle/respond_09.wav","vj_bmce/vocals_revamp/secguard/idle/respond_10.wav","vj_bmce/vocals_revamp/secguard/idle/respond_11.wav","vj_bmce/vocals_revamp/secguard/idle/respond_12.wav","vj_bmce/vocals_revamp/secguard/idle/respond_13.wav","vj_bmce/vocals_revamp/secguard/idle/respond_14.wav","vj_bmce/vocals_revamp/secguard/idle/respond_15.wav","vj_bmce/vocals_revamp/secguard/idle/respond_16.wav","vj_bmce/vocals_revamp/secguard/idle/respond_17.wav","vj_bmce/vocals_revamp/secguard/idle/respond_18.wav","vj_bmce/vocals_revamp/secguard/idle/respond_19.wav","vj_bmce/vocals_revamp/secguard/idle/respond_20.wav","vj_bmce/vocals_revamp/secguard/idle/respond_21.wav","vj_bmce/vocals_revamp/secguard/idle/respond_22.wav","vj_bmce/vocals_revamp/secguard/idle/respond_23.wav","vj_bmce/vocals_revamp/secguard/idle/respond_24.wav","vj_bmce/vocals_revamp/secguard/idle/respond_25.wav","vj_bmce/vocals_revamp/secguard/idle/respond_26.wav","vj_bmce/vocals_revamp/secguard/idle/respond_27.wav","vj_bmce/vocals_revamp/secguard/idle/respond_28.wav","vj_bmce/vocals_revamp/secguard/idle/respond_29.wav","vj_bmce/vocals_revamp/secguard/idle/respond_30.wav","vj_bmce/vocals_revamp/secguard/idle/respond_31.wav","vj_bmce/vocals_revamp/secguard/idle/respond_32.wav","vj_bmce/vocals_revamp/secguard/idle/respond_33.wav","vj_bmce/vocals_revamp/secguard/idle/respond_34.wav","vj_bmce/vocals_revamp/secguard/idle/respond_35.wav","vj_bmce/vocals_revamp/secguard/idle/respond_36.wav","vj_bmce/vocals_revamp/secguard/idle/respond_37.wav","vj_bmce/vocals_revamp/secguard/idle/respond_38.wav","vj_bmce/vocals_revamp/secguard/idle/respond_39.wav","vj_bmce/vocals_revamp/secguard/idle/respond_41.wav","vj_bmce/vocals_revamp/secguard/idle/respond_42.wav","vj_bmce/vocals_revamp/secguard/idle/respond_43.wav","vj_bmce/vocals_revamp/secguard/idle/respond_44.wav","vj_bmce/vocals_revamp/secguard/idle/respond_45.wav","vj_bmce/vocals_revamp/secguard/idle/respond_46.wav","vj_bmce/vocals_revamp/secguard/idle/respond_47.wav","vj_bmce/vocals_revamp/secguard/idle/respond_48.wav","vj_bmce/vocals_revamp/secguard/idle/respond_49.wav","vj_bmce/vocals_revamp/secguard/idle/respond_50.wav","vj_bmce/vocals_revamp/secguard/idle/respond_51.wav","vj_bmce/vocals_revamp/secguard/idle/respond_52.wav","vj_bmce/vocals_revamp/secguard/idle/respond_53.wav","vj_bmce/vocals_revamp/secguard/idle/respond_54.wav","vj_bmce/vocals_revamp/secguard/idle/respond_55.wav","vj_bmce/vocals_revamp/secguard/idle/respond_56.wav","vj_bmce/vocals_revamp/secguard/idle/respond_57.wav","vj_bmce/vocals_revamp/secguard/idle/respond_58.wav","vj_bmce/vocals_revamp/secguard/idle/respond_59.wav","vj_bmce/vocals_revamp/secguard/idle/respond_60.wav","vj_bmce/vocals_revamp/secguard/idle/respond_61.wav","vj_bmce/vocals_revamp/secguard/idle/respond_61.wav","vj_bmce/vocals_revamp/secguard/idle/respond_62.wav","vj_bmce/vocals_revamp/secguard/idle/respond_63.wav","vj_bmce/vocals_revamp/secguard/idle/respond_64.wav","vj_bmce/vocals_revamp/secguard/idle/respond_65.wav","vj_bmce/vocals_revamp/secguard/idle/respond_66.wav"}
		self.SoundTbl_Alert = {"vj_bmce/vocals_revamp/secguard/combat/alert_01.wav","vj_bmce/vocals_revamp/secguard/combat/alert_02.wav","vj_bmce/vocals_revamp/secguard/combat/alert_03.wav","vj_bmce/vocals_revamp/secguard/combat/alert_04.wav","vj_bmce/vocals_revamp/secguard/combat/alert_05.wav","vj_bmce/vocals_revamp/secguard/combat/alert_06.wav","vj_bmce/vocals_revamp/secguard/combat/alert_07.wav","vj_bmce/vocals_revamp/secguard/combat/alert_08.wav","vj_bmce/vocals_revamp/secguard/combat/alert_09.wav","vj_bmce/vocals_revamp/secguard/combat/alert_10.wav","vj_bmce/vocals_revamp/secguard/combat/alert_11.wav","vj_bmce/vocals_revamp/secguard/combat/alert_12.wav","vj_bmce/vocals_revamp/secguard/combat/alert_13.wav"}
		self.SoundTbl_Investigate = {"vj_bmce/vocals_revamp/secguard/combat/invest_01.wav","vj_bmce/vocals_revamp/secguard/combat/invest_02.wav","vj_bmce/vocals_revamp/secguard/combat/invest_03.wav","vj_bmce/vocals_revamp/secguard/combat/invest_04.wav","vj_bmce/vocals_revamp/secguard/combat/invest_05.wav","vj_bmce/vocals_revamp/secguard/combat/invest_06.wav"}
		self.SoundTbl_CombatIdle = {"vj_bmce/vocals_revamp/secguard/combat/combat_01.wav","vj_bmce/vocals_revamp/secguard/combat/combat_02.wav","vj_bmce/vocals_revamp/secguard/combat/combat_03.wav","vj_bmce/vocals_revamp/secguard/combat/combat_04.wav","vj_bmce/vocals_revamp/secguard/combat/combat_05.wav","vj_bmce/vocals_revamp/secguard/combat/combat_06.wav","vj_bmce/vocals_revamp/secguard/combat/combat_07.wav","vj_bmce/vocals_revamp/secguard/combat/combat_08.wav","vj_bmce/vocals_revamp/secguard/combat/combat_09.wav","vj_bmce/vocals_revamp/secguard/combat/combat_10.wav","vj_bmce/vocals_revamp/secguard/combat/combat_11.wav","vj_bmce/vocals_revamp/secguard/combat/combat_12.wav","vj_bmce/vocals_revamp/secguard/combat/combat_13.wav"}
		self.SoundTbl_Suppressing = {"vj_bmce/vocals_revamp/secguard/combat/suppressing_01.wav","vj_bmce/vocals_revamp/secguard/combat/suppressing_02.wav","vj_bmce/vocals_revamp/secguard/combat/suppressing_03.wav","vj_bmce/vocals_revamp/secguard/combat/suppressing_04.wav","vj_bmce/vocals_revamp/secguard/combat/suppressing_05.wav","vj_bmce/vocals_revamp/secguard/combat/suppressing_06.wav","vj_bmce/vocals_revamp/secguard/combat/suppressing_07.wav","vj_bmce/vocals_revamp/secguard/combat/suppressing_08.wav","vj_bmce/vocals_revamp/secguard/combat/suppressing_09.wav","vj_bmce/vocals_revamp/secguard/combat/suppressing_10.wav","vj_bmce/vocals_revamp/secguard/combat/suppressing_11.wav","vj_bmce/vocals_revamp/secguard/combat/suppressing_12.wav","vj_bmce/vocals_revamp/secguard/combat/suppressing_13.wav","vj_bmce/vocals_revamp/secguard/combat/suppressing_14.wav"}
		self.SoundTbl_AllyDeath = {"vj_bmce/vocals_revamp/secguard/combat/ally_death_01.wav","vj_bmce/vocals_revamp/secguard/combat/ally_death_02.wav","vj_bmce/vocals_revamp/secguard/combat/ally_death_03.wav","vj_bmce/vocals_revamp/secguard/combat/ally_death_04.wav","vj_bmce/vocals_revamp/secguard/combat/ally_death_05.wav","vj_bmce/vocals_revamp/secguard/combat/ally_death_06.wav"}
		self.SoundTbl_OnKilledEnemy = {"vj_bmce/vocals_revamp/secguard/combat/kill_01.wav","vj_bmce/vocals_revamp/secguard/combat/kill_02.wav","vj_bmce/vocals_revamp/secguard/combat/kill_03.wav","vj_bmce/vocals_revamp/secguard/combat/kill_04.wav","vj_bmce/vocals_revamp/secguard/combat/kill_05.wav","vj_bmce/vocals_revamp/secguard/combat/kill_06.wav","vj_bmce/vocals_revamp/secguard/combat/kill_07.wav","vj_bmce/vocals_revamp/secguard/combat/kill_08.wav","vj_bmce/vocals_revamp/secguard/combat/kill_09.wav"}
		self.SoundTbl_WeaponReload = {"vj_bmce/vocals_revamp/secguard/combat/reloading_01.wav","vj_bmce/vocals_revamp/secguard/combat/reloading_02.wav","vj_bmce/vocals_revamp/secguard/combat/reloading_03.wav","vj_bmce/vocals_revamp/secguard/combat/reloading_04.wav","vj_bmce/vocals_revamp/secguard/combat/reloading_05.wav","vj_bmce/vocals_revamp/secguard/combat/reloading_06.wav","vj_bmce/vocals_revamp/secguard/combat/reloading_07.wav","vj_bmce/vocals_revamp/secguard/combat/reloading_08.wav","vj_bmce/vocals_revamp/secguard/combat/reloading_09.wav","vj_bmce/vocals_revamp/secguard/combat/reloading_10.wav"}
		self.SoundTbl_OnPlayerSight = {"vj_bmce/vocals_revamp/secguard/ply_interact/spotplayer_01.wav","vj_bmce/vocals_revamp/secguard/ply_interact/spotplayer_02.wav","vj_bmce/vocals_revamp/secguard/ply_interact/spotplayer_03.wav","vj_bmce/vocals_revamp/secguard/ply_interact/spotplayer_04.wav","vj_bmce/vocals_revamp/secguard/ply_interact/spotplayer_05.wav","vj_bmce/vocals_revamp/secguard/ply_interact/spotplayer_06.wav","vj_bmce/vocals_revamp/secguard/ply_interact/spotplayer_07.wav","vj_bmce/vocals_revamp/secguard/ply_interact/spotplayer_08.wav","vj_bmce/vocals_revamp/secguard/ply_interact/spotplayer_09.wav","vj_bmce/vocals_revamp/secguard/ply_interact/spotplayer_10.wav","vj_bmce/vocals_revamp/secguard/ply_interact/spotplayer_11.wav","vj_bmce/vocals_revamp/secguard/ply_interact/spotplayer_12.wav","vj_bmce/vocals_revamp/secguard/ply_interact/spotplayer_13.wav","vj_bmce/vocals_revamp/secguard/ply_interact/spotplayer_14.wav","vj_bmce/vocals_revamp/secguard/ply_interact/spotplayer_15.wav","vj_bmce/vocals_revamp/secguard/ply_interact/spotplayer_16.wav","vj_bmce/vocals_revamp/secguard/ply_interact/spotplayer_17.wav","vj_bmce/vocals_revamp/secguard/ply_interact/spotplayer_18.wav","vj_bmce/vocals_revamp/secguard/ply_interact/spotplayer_19.wav","vj_bmce/vocals_revamp/secguard/ply_interact/spotplayer_20.wav","vj_bmce/vocals_revamp/secguard/ply_interact/spotplayer_21.wav","vj_bmce/vocals_revamp/secguard/ply_interact/spotplayer_22.wav"}
		self.SoundTbl_BecomeEnemyToPlayer = {"vj_bmce/vocals_revamp/secguard/ply_interact/hateplayer_01.wav","vj_bmce/vocals_revamp/secguard/ply_interact/hateplayer_02.wav","vj_bmce/vocals_revamp/secguard/ply_interact/hateplayer_03.wav","vj_bmce/vocals_revamp/secguard/ply_interact/hateplayer_04.wav","vj_bmce/vocals_revamp/secguard/ply_interact/hateplayer_05.wav","vj_bmce/vocals_revamp/secguard/ply_interact/hateplayer_06.wav","vj_bmce/vocals_revamp/secguard/ply_interact/hateplayer_07.wav","vj_bmce/vocals_revamp/secguard/ply_interact/hateplayer_08.wav"}
		self.SoundTbl_MoveOutOfPlayersWay = {"vj_bmce/vocals_revamp/secguard/ply_interact/bump_01.wav","vj_bmce/vocals_revamp/secguard/ply_interact/bump_02.wav","vj_bmce/vocals_revamp/secguard/ply_interact/bump_03.wav","vj_bmce/vocals_revamp/secguard/ply_interact/bump_04.wav","vj_bmce/vocals_revamp/secguard/ply_interact/bump_05.wav","vj_bmce/vocals_revamp/secguard/ply_interact/bump_06.wav","vj_bmce/vocals_revamp/secguard/ply_interact/bump_07.wav","vj_bmce/vocals_revamp/secguard/ply_interact/bump_08.wav","vj_bmce/vocals_revamp/secguard/ply_interact/bump_09.wav","vj_bmce/vocals_revamp/secguard/ply_interact/bump_10.wav","vj_bmce/vocals_revamp/secguard/ply_interact/bump_11.wav","vj_bmce/vocals_revamp/secguard/ply_interact/bump_12.wav","vj_bmce/vocals_revamp/secguard/ply_interact/bump_13.wav","vj_bmce/vocals_revamp/secguard/ply_interact/bump_14.wav","vj_bmce/vocals_revamp/secguard/ply_interact/bump_15.wav","vj_bmce/vocals_revamp/secguard/ply_interact/bump_16.wav"}
		self.SoundTbl_DamageByPlayer = {"vj_bmce/vocals_revamp/secguard/ply_interact/stupidplayer_01.wav","vj_bmce/vocals_revamp/secguard/ply_interact/stupidplayer_02.wav","vj_bmce/vocals_revamp/secguard/ply_interact/stupidplayer_03.wav","vj_bmce/vocals_revamp/secguard/ply_interact/stupidplayer_04.wav","vj_bmce/vocals_revamp/secguard/ply_interact/stupidplayer_05.wav","vj_bmce/vocals_revamp/secguard/ply_interact/stupidplayer_06.wav","vj_bmce/vocals_revamp/secguard/ply_interact/stupidplayer_07.wav","vj_bmce/vocals_revamp/secguard/ply_interact/stupidplayer_08.wav","vj_bmce/vocals_revamp/secguard/ply_interact/stupidplayer_09.wav","vj_bmce/vocals_revamp/secguard/ply_interact/stupidplayer_10.wav","vj_bmce/vocals_revamp/secguard/ply_interact/stupidplayer_11.wav","vj_bmce/vocals_revamp/secguard/ply_interact/stupidplayer_12.wav"}
		self.SoundTbl_FollowPlayer = {"vj_bmce/vocals_revamp/secguard/ply_interact/follow_01.wav","vj_bmce/vocals_revamp/secguard/ply_interact/follow_02.wav","vj_bmce/vocals_revamp/secguard/ply_interact/follow_03.wav","vj_bmce/vocals_revamp/secguard/ply_interact/follow_04.wav","vj_bmce/vocals_revamp/secguard/ply_interact/follow_05.wav","vj_bmce/vocals_revamp/secguard/ply_interact/follow_06.wav","vj_bmce/vocals_revamp/secguard/ply_interact/follow_07.wav","vj_bmce/vocals_revamp/secguard/ply_interact/follow_08.wav","vj_bmce/vocals_revamp/secguard/ply_interact/follow_09.wav","vj_bmce/vocals_revamp/secguard/ply_interact/follow_10.wav","vj_bmce/vocals_revamp/secguard/ply_interact/follow_11.wav","vj_bmce/vocals_revamp/secguard/ply_interact/follow_12.wav","vj_bmce/vocals_revamp/secguard/ply_interact/follow_13.wav"}
		self.SoundTbl_UnFollowPlayer = {"vj_bmce/vocals_revamp/secguard/ply_interact/unfollow_01.wav","vj_bmce/vocals_revamp/secguard/ply_interact/unfollow_02.wav","vj_bmce/vocals_revamp/secguard/ply_interact/unfollow_03.wav","vj_bmce/vocals_revamp/secguard/ply_interact/unfollow_04.wav","vj_bmce/vocals_revamp/secguard/ply_interact/unfollow_05.wav","vj_bmce/vocals_revamp/secguard/ply_interact/unfollow_06.wav","vj_bmce/vocals_revamp/secguard/ply_interact/unfollow_07.wav","vj_bmce/vocals_revamp/secguard/ply_interact/unfollow_08.wav","vj_bmce/vocals_revamp/secguard/ply_interact/unfollow_09.wav","vj_bmce/vocals_revamp/secguard/ply_interact/unfollow_10.wav","vj_bmce/vocals_revamp/secguard/ply_interact/unfollow_11.wav","vj_bmce/vocals_revamp/secguard/ply_interact/unfollow_12.wav","vj_bmce/vocals_revamp/secguard/ply_interact/unfollow_13.wav","vj_bmce/vocals_revamp/secguard/ply_interact/unfollow_14.wav","vj_bmce/vocals_revamp/secguard/ply_interact/unfollow_15.wav","vj_bmce/vocals_revamp/secguard/ply_interact/unfollow_16.wav","vj_bmce/vocals_revamp/secguard/ply_interact/unfollow_17.wav"}
		self.SoundTbl_OnGrenadeSight = {"vj_bmce/vocals_revamp/secguard/danger_01.wav","vj_bmce/vocals_revamp/secguard/danger_02.wav","vj_bmce/vocals_revamp/secguard/danger_03.wav","vj_bmce/vocals_revamp/secguard/danger_04.wav","vj_bmce/vocals_revamp/secguard/danger_05.wav","vj_bmce/vocals_revamp/secguard/danger_06.wav","vj_bmce/vocals_revamp/secguard/danger_07.wav","vj_bmce/vocals_revamp/secguard/danger_08.wav"}
		self.SoundTbl_OnDangerSight = {"vj_bmce/vocals_revamp/secguard/danger_01.wav","vj_bmce/vocals_revamp/secguard/danger_02.wav","vj_bmce/vocals_revamp/secguard/danger_03.wav","vj_bmce/vocals_revamp/secguard/danger_04.wav","vj_bmce/vocals_revamp/secguard/danger_05.wav","vj_bmce/vocals_revamp/secguard/danger_06.wav","vj_bmce/vocals_revamp/secguard/danger_07.wav","vj_bmce/vocals_revamp/secguard/danger_08.wav"}
		self.SoundTbl_Pain = {"vj_bmce/vocals_revamp/secguard/pain_01.wav","vj_bmce/vocals_revamp/secguard/pain_02.wav","vj_bmce/vocals_revamp/secguard/pain_03.wav","vj_bmce/vocals_revamp/secguard/pain_04.wav","vj_bmce/vocals_revamp/secguard/pain_05.wav","vj_bmce/vocals_revamp/secguard/pain_06.wav","vj_bmce/vocals_revamp/secguard/pain_07.wav","vj_bmce/vocals_revamp/secguard/pain_08.wav","vj_bmce/vocals_revamp/secguard/pain_09.wav","vj_bmce/vocals_revamp/secguard/pain_10.wav"}
		self.SoundTbl_Death = {"vj_bmce/vocals_revamp/secguard/death_01.wav","vj_bmce/vocals_revamp/secguard/death_02.wav","vj_bmce/vocals_revamp/secguard/death_03.wav","vj_bmce/vocals_revamp/secguard/death_04.wav","vj_bmce/vocals_revamp/secguard/death_05.wav","vj_bmce/vocals_revamp/secguard/death_06.wav","vj_bmce/vocals_revamp/secguard/death_07.wav","vj_bmce/vocals_revamp/secguard/death_08.wav","vj_bmce/vocals_revamp/secguard/death_09.wav","vj_bmce/vocals_revamp/secguard/death_10.wav","vj_bmce/vocals_revamp/male/death_shared_01.mp3","vj_bmce/vocals_revamp/male/death_shared_02.mp3","vj_bmce/vocals_revamp/male/death_shared_03.mp3","vj_bmce/vocals_revamp/male/death_shared_04.mp3","vj_bmce/vocals_revamp/male/death_shared_05.mp3","vj_bmce/vocals_revamp/male/death_shared_06.mp3","vj_bmce/vocals_revamp/male/death_shared_07.mp3","vj_bmce/vocals_revamp/male/death_shared_08.mp3","vj_bmce/vocals_revamp/male/death_shared_09.mp3","vj_bmce/vocals_revamp/male/death_shared_10.mp3"}
		self.SoundTbl_LostEnemy = {"vj_bmce/vocals_revamp/secguard/danger_08.wav","vj_bmce/vocals_revamp/secguard/danger_03.wav","vj_bmce/vocals_revamp/secguard/idle/idle_31.wav","vj_bmce/vocals_revamp/secguard/disaster/idle/idle_16.wav","vj_bmce/vocals_revamp/secguard/combat/ally_death_03.wav"}		
		-- custom
		self.SoundTbl_LeaveMeAlone = {"vj_bmce/vocals_revamp/secguard/ply_interact/busy_01.wav","vj_bmce/vocals_revamp/secguard/ply_interact/busy_02.wav","vj_bmce/vocals_revamp/secguard/ply_interact/busy_03.wav","vj_bmce/vocals_revamp/secguard/ply_interact/busy_04.wav","vj_bmce/vocals_revamp/secguard/ply_interact/busy_05.wav","vj_bmce/vocals_revamp/secguard/ply_interact/busy_06.wav","vj_bmce/vocals_revamp/secguard/ply_interact/busy_07.wav","vj_bmce/vocals_revamp/secguard/ply_interact/busy_08.wav","vj_bmce/vocals_revamp/secguard/ply_interact/busy_09.wav","vj_bmce/vocals_revamp/secguard/ply_interact/busy_10.wav","vj_bmce/vocals_revamp/secguard/ply_interact/busy_11.wav","vj_bmce/vocals_revamp/secguard/ply_interact/busy_12.wav","vj_bmce/vocals_revamp/secguard/ply_interact/busy_13.wav","vj_bmce/vocals_revamp/secguard/ply_interact/busy_14.wav","vj_bmce/vocals_revamp/secguard/ply_interact/busy_15.wav","vj_bmce/vocals_revamp/secguard/ply_interact/busy_16.wav"}
		self.SoundTbl_OnFire = {"vj_bmce/vocals_revamp/male/burning_tough_01.mp3","vj_bmce/vocals_revamp/male/burning_tough_02.mp3","vj_bmce/vocals_revamp/male/burning_tough_03.mp3","vj_bmce/vocals_revamp/male/burning_tough_04.mp3","vj_bmce/vocals_revamp/male/burning_tough_05.mp3","vj_bmce/vocals_revamp/male/burning_tough_06.mp3","vj_bmce/vocals_revamp/male/burning_tough_07.mp3","vj_bmce/vocals_revamp/male/burning_tough_08.mp3"}
		self.SoundTbl_RadioChatter = {"vj_bmce/vocals_revamp/radio/gen_01.ogg","vj_bmce/vocals_revamp/radio/gen_02.ogg","vj_bmce/vocals_revamp/radio/gen_03.ogg","vj_bmce/vocals_revamp/radio/gen_04.ogg","vj_bmce/vocals_revamp/radio/grd_01.wav","vj_bmce/vocals_revamp/radio/grd_02.wav","vj_bmce/vocals_revamp/radio/grd_03.wav","vj_bmce/vocals_revamp/radio/grd_04.wav","vj_bmce/vocals_revamp/radio/grd_05.wav","vj_bmce/vocals_revamp/radio/grd_06.wav","vj_bmce/vocals_revamp/radio/grd_07.wav","vj_bmce/vocals_revamp/radio/grd_08.wav"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize()
	local NPC = self:GetClass()
	local MDL = self:GetModel()
	
	if behaviour:GetInt() == 0 then
		-- males
		if NPC == "npc_vj_bmce_scientist_m" then
			self.StartHealth = 75
			self.IsMedicSNPC = true
			self.BMCE_Staff = true
			self.Model = {"models/humans/scientist.mdl","models/humans/scientist_02.mdl","models/humans/scientist_03.mdl","models/humans/scientist_cl.mdl"}
			self:SetBehaviorAndWeapons()
			self:UseMaleVoice()
			self.ModelAnimationSet = VJ_MODEL_ANIMSET_BMSTAFF
		elseif NPC == "npc_vj_bmce_scientist_f" then
			self.StartHealth = 75
			self.IsMedicSNPC = true
			self.BMCE_Staff = true
			self.Model = {"models/humans/scientist_female.mdl"}
			self:SetBehaviorAndWeapons()
			self:UseFemaleVoice()
			self.ModelAnimationSet = VJ_MODEL_ANIMSET_BMSTAFF
		end

		if NPC == "npc_vj_bmce_hev_m" then
			self.StartHealth = 175
			self.IsMedicSNPC = true
			self.BMCE_Staff = true
			self.Model = {"models/humans/hev_male.mdl"}
			self:SetBehaviorAndWeapons()
			self:UseMaleVoice()
			self.ModelAnimationSet = VJ_MODEL_ANIMSET_BMSTAFF
		end

		if NPC == "npc_vj_bmce_scientist_casual_m" then
			self.StartHealth = 75
			self.IsMedicSNPC = true
			self.BMCE_Staff = true
			self.Model = {"models/humans/scientist_casual.mdl","models/humans/scientist_casual_02.mdl","models/humans/scientist_casual_02.mdl"}
			self:SetBehaviorAndWeapons()
			self:UseMaleVoice()
			self.ModelAnimationSet = VJ_MODEL_ANIMSET_BMSTAFF
		end

		if NPC == "npc_vj_bmce_cw_m" then
			self.StartHealth = 75
			self.BMCE_Staff = true
			self.Model = {"models/humans/cafeteria_male.mdl","models/humans/cafeteria_male_02.mdl"}
			self:SetBehaviorAndWeapons()
			self:UseMaleVoice()
			self.ModelAnimationSet = VJ_MODEL_ANIMSET_BMSTAFF
		elseif NPC == "npc_vj_bmce_cw_f" then
			self.StartHealth = 75
			self.BMCE_Staff = true
			self.Model = {"models/humans/cafeteria_female.mdl"}
			self:SetBehaviorAndWeapons()
			self:UseFemaleVoice()
			self.ModelAnimationSet = VJ_MODEL_ANIMSET_BMSTAFF
		end

		if NPC == "npc_vj_bmce_custodian_m" then
			self.StartHealth = 90
			self.BMCE_Staff = true
			self.Model = {"models/humans/custodian.mdl"}
			self:SetBehaviorAndWeapons()
			self:UseMaleVoice()
			self.ModelAnimationSet = VJ_MODEL_ANIMSET_BMSTAFF
		elseif NPC == "npc_vj_bmce_custodian_f" then
			self.StartHealth = 90
			self.BMCE_Staff = true
			self.Model = {"models/humans/custodian_female.mdl"}
			self:SetBehaviorAndWeapons()
			self:UseFemaleVoice()
			self.ModelAnimationSet = VJ_MODEL_ANIMSET_BMSTAFF
		end

		if NPC == "npc_vj_bmce_constructw_m" then
			self.StartHealth = 90
			self.BMCE_Staff = true
			self.Model = {"models/humans/construction_worker.mdl"}
			self:SetBehaviorAndWeapons()
			self:UseMaleVoice()
			self.ModelAnimationSet = VJ_MODEL_ANIMSET_BMSTAFF
		end

		if NPC == "npc_vj_bmce_engineer_m" then
			self.StartHealth = 90
			self.BMCE_Staff = true
			self.Model = {"models/humans/engineer.mdl"}
			self:SetBehaviorAndWeapons()
			self:UseMaleVoice()
			self.ModelAnimationSet = VJ_MODEL_ANIMSET_BMSTAFF
		end

		if NPC == "npc_vj_bmce_secguard_m" then
			self.StartHealth = 100
			self.BMCE_Staff = true
			self.Model = {"models/humans/guard.mdl","models/humans/guard_02.mdl","models/humans/guard_03.mdl","models/humans/guard_otis.mdl"}
			self.Agressive = true
			self:SetBehaviorAndWeapons()
			self:UseMaleSecGuardVoice()
			self.ModelAnimationSet = VJ_MODEL_ANIMSET_BMSTAFF
		elseif NPC == "npc_vj_bmce_secguard_capt" then
			self.StartHealth = 125
			self.BMCE_Staff = true
			self.Model = {"models/humans/guard.mdl","models/humans/guard_02.mdl","models/humans/guard_03.mdl","models/humans/guard_otis.mdl"}
			self.Agressive = true
			self.BMCE_Hat = 1
			self:SetBehaviorAndWeapons()
			self:UseMaleSecGuardVoice()
			self.ModelAnimationSet = VJ_MODEL_ANIMSET_BMSTAFF
		end
	else -- If Disaster is enabled
		-- males
		if NPC == "npc_vj_bmce_scientist_m" then
			self.StartHealth = 75
			self.IsMedicSNPC = true
			self.BMCE_Staff = true
			self.Model = {"models/humans/scientist.mdl","models/humans/scientist_02.mdl","models/humans/scientist_03.mdl","models/humans/scientist_cl.mdl"}
			self:SetBehaviorAndWeapons()
			self:UseMaleVoice()
			self.ModelAnimationSet = VJ_MODEL_ANIMSET_BMSTAFF
		end
	end

	if self.BMCE_Staff then
		if enemy:GetInt() == 0 then
			self.FriendsWithAllPlayerAllies = true
			self.VJ_NPC_Class = {"CLASS_BLACKMESA_PERSONNEL","CLASS_PLAYER_ALLY"}
		elseif enemy:GetInt() == 1 then
			self.VJ_NPC_Class = {"CLASS_BLACKMESA_PERSONNEL_HOSTILE"}
		elseif enemy:GetInt() == 2 then
			self.HasAllies = false
		end
	else
		self.VJ_NPC_Class = {"CLASS_BLACKMESA_HECU"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetBehaviorAndWeapons() -- Sets the Black Mesa Staff disaster behavior and weapons, this must be above setting the voice function
	local NPC = self:GetClass()
	local MDL = self:GetModel()
	local Weapon_Chance = random(1,3)
	local Staff_Wep = VJ_PICK( VJ_BMCE_WP_STAFF [random ( #VJ_BMCE_WP_STAFF ) ] )
	local Staff_Constu_Wep = VJ_PICK( VJ_BMCE_WP_STAFF_CONSTRU [ random( #VJ_BMCE_WP_STAFF_CONSTRU ) ] )
	local BMSF_Wep = VJ_PICK( VJ_BMCE_WP_BMSF [ random ( #VJ_BMCE_WP_BMSF ) ] )
	local BMSFADV_Wep = VJ_PICK( VJ_BMCE_WP_BMSF_ADVW [ random ( #VJ_BMCE_WP_BMSF_ADVW ) ] )

	-- Setting the disaster behavior
	if behaviour:GetInt() == 1 then
		self.DisasterBehavior = 1
	else
		self.DisasterBehavior = 0
	end

	if wpns:GetInt() == 1 or wpns:GetInt() == 2 then 
		self.Behavior = VJ_BEHAVIOR_AGRESSIVE
	end

	-- Setting the Custom Weapons
	if NPC == "npc_vj_bmce_scientist_m" or NPC == "npc_vj_bmce_scientist_casual_m" or NPC == "npc_vj_bmce_scientist_f" or NPC == "npc_vj_bmce_cw_f" or NPC == "npc_vj_bmce_cw_m" or NPC == "npc_vj_bmce_hev_m" then
		if wpns:GetInt() == 1 then 
			if Weapon_Chance == 1 then
				self:Give(Staff_Wep)
			else
				self.Behavior = VJ_BEHAVIOR_PASSIVE
			end
		end
		
		if wpns:GetInt() == 2 then
			if (Weapon_Chance >= 1 and Weapon_Chance <= 3) then
				self:Give(Staff_Wep)
			end
		end
	end

	if NPC == "npc_vj_bmce_constructw_m" or NPC == "npc_vj_bmce_custodian_m" or NPC == "npc_vj_bmce_custodian_f" or NPC == "npc_vj_bmce_engineer_m" then
		if wpns:GetInt() == 1 then 
			if Weapon_Chance == 1 then
				self:Give(Staff_Constu_Wep)
			else
				self.Behavior = VJ_BEHAVIOR_PASSIVE
			end
		end
		
		if wpns:GetInt() == 2 then
			if (Weapon_Chance >= 1 and Weapon_Chance <= 3) then
				self:Give(Staff_Constu_Wep)
			end
		end
	end

	if NPC == "npc_vj_bmce_secguard_m" or NPC == "npc_vj_bmce_secguard_capt" then
		self.Radio_ChatterTime = CurTime() + rand(1, 30)

		if (Weapon_Chance >= 1 and Weapon_Chance <= 2) then
			self:Give(BMSF_Wep)
		elseif Weapon_Chance == 3 then
			self:Give(BMSFADV_Wep)
		end

		self.WeaponInventory_Melee = true
		self.WeaponInventory_MeleeList = {"weapon_vj_crowbar"}
	end

	if wpns:GetInt() == 0 and !self.Agressive then
		self.Behavior = VJ_BEHAVIOR_PASSIVE
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetNPCBodyGroups() -- Sets the bodygroups for NPCS
	local NPC = self:GetClass()
	local MDL = self:GetModel()
	if (self.BMCE_Hat >= 1) then self:GiveUniqueHat() end

	--PrintMessage(HUD_PRINTTALK, self.BMCE_Hat)

	if behaviour:GetInt() == 0 then
		
		if NPC == "npc_vj_bmce_scientist_m" then
			local hats = random( 1, 5 )
			self:SetSkin( random( 0, 14 ))
			self:SetBodygroup( 2, random( 0, 7 )) -- Ties

			if hats == 1 then
				self:SetBodygroup( 4, 1 ) -- Hats
				self:SetBodygroup( 3, 7 ) -- Glasses
			elseif hats == 2 then
				self:SetBodygroup(3,random( 0, 6 )) -- Glasses
				if Hat_Chance == 1 then self:SetBodygroup( 4, random( 0, 2 )) end
			elseif hats == 3 then
				self:SetBodygroup(3,random( 7, 8 )) -- Glasses
			elseif hats == 4 then
				self:SetBodygroup(3,random( 9, 16 )) -- Glasses
				if Hat_Chance == 1 then self:SetBodygroup( 4, random( 0, 2 )) end
			elseif hats == 5 then
				self:SetBodygroup(3,random( 0, 6 )) -- Glasses
				if Hat_Chance == 1 then self:SetBodygroup( 4, random( 0, 2 )) end
			end
			
		elseif NPC == "npc_vj_bmce_scientist_f" then
			local body = random(1,3)
			self:SetSkin(random( 0, 9 ))
			if body == 1 then
				self:SetBodygroup(1,0)
			elseif body == 2 then
				self:SetBodygroup(1,2)
			elseif body == 2 then
				self:SetBodygroup(1,4)
			end
			self:SetBodygroup(2,random( 0, 5 )) -- Hair
			self:SetBodygroup(3,random( 0, 14 )) -- Glasses
		end

		if NPC == "npc_vj_bmce_hev_m" then
			self:SetSkin(random( 0, 14 ))
			self:SetBodygroup( 2, random( 0, 1 )) -- helmet
		end

		if NPC == "npc_vj_bmce_scientist_casual_m" then
			self:SetSkin(random( 0, 14 ))
			self:SetBodygroup( 4, random( 3, 6 )) -- Torso
			local torso = random( 1, 2)
			local hats = random( 1, 5 )

			if torso == 1 then
				self:SetBodygroup( 4,0 ) -- Torso
			elseif torso == 1 then
				self:SetBodygroup( 4, random( 3, 6 )) -- Torso
			end

			if hats == 1 then
				self:SetBodygroup( 2, 1 ) -- Hats
				self:SetBodygroup( 3, 7 ) -- Glasses
			elseif hats == 2 then
				self:SetBodygroup(3,random( 0, 6 )) -- Glasses
				if Hat_Chance == 1 then self:SetBodygroup( 2, random( 0, 2 )) end
			elseif hats == 3 then
				self:SetBodygroup(3,random( 7, 8 )) -- Glasses
			elseif hats == 4 then
				self:SetBodygroup(3,random( 9, 16 )) -- Glasses
				if Hat_Chance == 1 then self:SetBodygroup( 2, random( 0, 2 )) end
			elseif hats == 5 then
				self:SetBodygroup(3,random( 0, 6 )) -- Glasses
				if Hat_Chance == 1 then self:SetBodygroup( 2, random( 0, 2 )) end
			end
		end

		if NPC == "npc_vj_bmce_cw_f" then
			self:SetSkin(random( 0, 14 ))
			self:SetBodygroup(4,random( 0, 14 )) -- Glasses
			self:SetBodygroup(2,random( 0, 1 )) -- Apron
			self:SetBodygroup(3,random( 0, 8 )) -- Hair
		
		elseif NPC == "npc_vj_bmce_cw_m" then
			self:SetSkin(random( 0, 14 ))
			if MDL == "models/humans/cafeteria_male.mdl" then
			self:SetBodygroup(1,random( 0, 1 )) -- Body
			self:SetBodygroup(2,random( 0, 1 )) -- Apron
			self:SetBodygroup(3,random( 0, 8 )) -- Hair
			self:SetBodygroup(4,random( 0, 14 )) -- Glasses
			self:SetBodygroup(5,random( 0, 1 )) -- Flashlight
			elseif MDL == "models/humans/cafeteria_male_02.mdl" then
				self:SetBodygroup(2,random( 0, 3 )) -- helmet
				self:SetBodygroup(3,random( 0, 15 )) -- Glasses
				self:SetBodygroup(4,random( 0, 1 )) -- Apron
				self:SetBodygroup(5,random( 0, 1 )) -- Flashlight
			end
		end

		if NPC == "npc_vj_bmce_custodian_m" then
			self:SetSkin(random( 0, 14 ))
			self:SetBodygroup(1,random( 0, 1 )) -- body
			self:SetBodygroup(3,random( 0, 1 )) -- vest
			self:SetBodygroup(4,random( 3, 14 )) -- Glasses
			if Hat_Chance == 1 then self:SetBodygroup( 2, random( 0, 4 )) end

		elseif NPC == "npc_vj_bmce_custodian_f" then
			self:SetSkin(random( 0, 14 ))
			self:SetBodygroup(1,random( 0, 1 )) -- body
			self:SetBodygroup(2,random( 0, 1 )) -- vest
			self:SetBodygroup(3,random( 0, 10 )) -- Hair
			self:SetBodygroup(4,random( 0, 14 )) -- glasses
		end

		if NPC == "npc_vj_bmce_constructw_m" then
			self:SetSkin(random( 0, 16 ))
			self:SetBodygroup(1,random( 0, 3 )) -- t-shirts
			self:SetBodygroup(2,random( 0, 3 )) -- pants
			self:SetBodygroup(3,random( 0, 1 )) -- shows
			self:SetBodygroup(5,random( 3, 14 )) -- Glasses
			if Hat_Chance == 1 then self:SetBodygroup( 4, random( 0, 4 )) end
		end

		if NPC == "npc_vj_bmce_engineer_m" then
			local hats = random( 1, 5 )
			self:SetSkin( random( 0, 14 ))
			self:SetBodygroup( 1, random( 0, 1 )) -- Body
			self:SetBodygroup( 3, random( 0, 1 )) -- Vest

			if hats == 1 then
				self:SetBodygroup( 2, random( 0, 2 )) -- Hat
				self:SetBodygroup( 4, 1 ) -- Glasses
			elseif hats == 2 then
				self:SetBodygroup( 2, 1 ) -- Hat
				self:SetBodygroup( 4, 2 ) -- Glasses
			elseif hats == 3 then
				self:SetBodygroup( 4, random( 3, 16 )) -- Glasses
				if Hat_Chance == 1 then self:SetBodygroup( 2, 1) end
			elseif hats == 4 then
				self:SetBodygroup( 4, random( 3, 16 )) -- Glasses
				self:SetBodygroup( 2, 1)
			elseif hats == 5 then
				self:SetBodygroup( 2, random( 0, 2 )) -- Hat
			end
		end

		if NPC == "npc_vj_bmce_secguard_m" then
			if MDL == "models/humans/guard.mdl" then
				self:SetSkin(random(0,13))
			elseif MDL == "models/humans/guard_02.mdl" then
				self:SetSkin(random(0,12))
			elseif MDL == "models/humans/guard_03.mdl" then
				self:SetSkin(random(0,11))
			elseif MDL == "models/humans/guard_otis.mdl" then
				self:SetSkin(random(0,15))
			end

			self:SetBodygroup(1,random(0,1)) -- Body
			self:SetBodygroup(2,random(0,5)) --Helmet
			self:SetBodygroup(4,random(0,11)) -- Glasses
			self:SetBodygroup(6,random(0,1)) -- Flash
		
			local Chest = random(1,8)

			if Chest == 1 then
			self:SetBodygroup(3,0)
			self:SetBodygroup(5,0)
			elseif Chest == 2 then	
				self:SetBodygroup(3,1)
				self:SetBodygroup(5,0)
			elseif Chest == 3 then
				self:SetBodygroup(3,2)
				self:SetBodygroup(5,0)
			elseif Chest == 4 then
				self:SetBodygroup(3,1)
				self:SetBodygroup(5,1)
			elseif Chest == 5 then
				self:SetBodygroup(3,2)
				self:SetBodygroup(5,1)
			elseif Chest == 6 then
				self:SetBodygroup(3,1)
				self:SetBodygroup(5,2)
			elseif Chest == 7 then
				self:SetBodygroup(3,2)
				self:SetBodygroup(5,2)
			elseif Chest == 8 then
				self:SetBodygroup(3,2)
				self:SetBodygroup(2,4)
				self:SetBodygroup(4,11)
				self:SetBodygroup(5,0)
			end
		
		elseif NPC == "npc_vj_bmce_secguard_capt" then
			if MDL == "models/humans/guard.mdl" then
				self:SetSkin(random(0,13))
			elseif MDL == "models/humans/guard_02.mdl" then
				self:SetSkin(random(0,12))
			elseif MDL == "models/humans/guard_03.mdl" then
				self:SetSkin(random(0,11))
			elseif MDL == "models/humans/guard_otis.mdl" then
				self:SetSkin(random(0,15))
			end
			
			self:SetBodygroup(1,random(0,1)) -- Body
			self:SetBodygroup(4,random(0,11)) -- Glasses
			self:SetBodygroup(6,random(0,1)) -- Flash
		
			local Chest = random(1,8)

			if Chest == 1 then
			self:SetBodygroup(3,0)
			self:SetBodygroup(5,0)
			elseif Chest == 2 then	
				self:SetBodygroup(3,1)
				self:SetBodygroup(5,0)
			elseif Chest == 3 then
				self:SetBodygroup(3,2)
				self:SetBodygroup(5,0)
			elseif Chest == 4 then
				self:SetBodygroup(3,1)
				self:SetBodygroup(5,1)
			elseif Chest == 5 then
				self:SetBodygroup(3,2)
				self:SetBodygroup(5,1)
			elseif Chest == 6 then
				self:SetBodygroup(3,1)
				self:SetBodygroup(5,2)
			elseif Chest == 7 then
				self:SetBodygroup(3,2)
				self:SetBodygroup(5,2)
			elseif Chest == 8 then
				self:SetBodygroup(3,2)
				self:SetBodygroup(4,11)
				self:SetBodygroup(5,0)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GiveUniqueHat()
	if self.BMCE_Hat == 1 then -- SecGuard Beret
		self.BeretHat = ents.Create("prop_physics")
		self.BeretHat:SetModel("models/humans/props/guard_beret.mdl")
		self.BeretHat:SetLocalPos(self:GetPos())
		self.BeretHat:SetOwner(self)
		self.BeretHat:SetParent(self)
		self.BeretHat:Fire("SetParentAttachment","eyes")
		self.BeretHat:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		self.BeretHat:Spawn()
		self.BeretHat:Activate()
		self.BeretHat:SetSolid(SOLID_NONE)
		self.BeretHat:AddEffects(EF_BONEMERGE)
		self:SetBodygroup( 2, 1 ) -- Hats (no hat)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	-- Random background radio sounds
	if self.Radio_ChatterTime < CurTime() then
		if random(1, 2) == 1 then
			VJ_CreateSound(self, self.SoundTbl_RadioChatter, 50, 90)
		end
		self.Radio_ChatterTime = CurTime() + rand(1, 40)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	if self:Health() > 0 and dmginfo:IsDamageType(DMG_BURN) then
		self:PlaySoundSystem("Pain", self.SoundTbl_OnFire or self.SoundTbl_Pain)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	if self.HasGibDeathParticles == true then
		local bloodeffect = EffectData()
		bloodeffect:SetOrigin(self:GetPos() +self:OBBCenter())
		bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
		bloodeffect:SetScale(120)
		util.Effect("VJ_Blood1",bloodeffect)
		
		local bloodspray = EffectData()
		bloodspray:SetOrigin(self:GetPos())
		bloodspray:SetScale(8)
		bloodspray:SetFlags(3)
		bloodspray:SetColor(0)
		util.Effect("bloodspray",bloodspray)
		util.Effect("bloodspray",bloodspray)

		self:PlaySoundSystem("Death", {"vj_bmce/weapons/strike_head_shotoff.wav"})

		self:DoGibbing()
		return true
	end
end
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup) return false end 
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoGibbing()
	local NPC = self:GetClass()
	self:CreateGibEntity("obj_vj_gib","UseHuman_Small",{Pos=self:LocalToWorld(Vector(0,0,30))})
	self:CreateGibEntity("obj_vj_gib","UseHuman_Small",{Pos=self:LocalToWorld(Vector(0,0,30))})
	self:CreateGibEntity("obj_vj_gib","UseHuman_Small",{Pos=self:LocalToWorld(Vector(0,0,30))})
	self:CreateGibEntity("obj_vj_gib","UseHuman_Big",{Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","UseHuman_Big",{Pos=self:LocalToWorld(Vector(0,0,35))})
	self:CreateGibEntity("obj_vj_gib","models/gibs/humans/brain_gib.mdl",{Pos=self:LocalToWorld(Vector(0,0,68)),Ang=self:GetAngles()+Angle(0,-90,0)})
	self:CreateGibEntity("obj_vj_gib","models/gibs/humans/eye_gib.mdl",{Pos=self:LocalToWorld(Vector(0,0,65)),Ang=self:GetAngles()+Angle(0,-90,0),Vel=self:GetRight()*rand(150,250)+self:GetForward()*rand(-200,200)})
	self:CreateGibEntity("obj_vj_gib","models/gibs/humans/eye_gib.mdl",{Pos=self:LocalToWorld(Vector(0,3,65)),Ang=self:GetAngles()+Angle(0,-90,0),Vel=self:GetRight()*rand(-150,-250)+self:GetForward()*rand(-200,200)})

	if NPC == "npc_vj_bmce_scientist_m" or NPC == "npc_vj_bmce_scientist_m" then
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/scientists/torso.mdl",{Pos=self:LocalToWorld(Vector(0,0,0)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(-100,100)+self:GetForward()*rand(-100,100)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/scientists/right_leg.mdl",{Pos=self:LocalToWorld(Vector(0,7,2)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(-350,-550)+self:GetForward()*rand(-500,500)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/scientists/left_leg.mdl",{Pos=self:LocalToWorld(Vector(0,-7,2)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(350,550)+self:GetForward()*rand(-500,500)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/scientists/right_arm.mdl",{Pos=self:LocalToWorld(Vector(0,-3,2)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(150,250)+self:GetForward()*rand(-200,200)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/scientists/left_arm.mdl",{Pos=self:LocalToWorld(Vector(0,2,2)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(-150,-250)+self:GetForward()*rand(-200,200)})
	end

	if NPC == "npc_vj_bmce_scientist_casual_m" or NPC == "npc_vj_bmce_scientist_casual_m" then
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/scientists/right_leg.mdl",{Pos=self:LocalToWorld(Vector(0,7,2)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(-350,-550)+self:GetForward()*rand(-500,500)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/scientists/left_leg.mdl",{Pos=self:LocalToWorld(Vector(0,-7,2)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(350,550)+self:GetForward()*rand(-500,500)})
	end

	if NPC == "npc_vj_bmce_scientist_f" or NPC == "npc_vj_bmce_scientist_f" then
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/fem_sci/torso.mdl",{Pos=self:LocalToWorld(Vector(0,0,0)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(-100,100)+self:GetForward()*rand(-100,100)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/scientists/right_leg.mdl",{Pos=self:LocalToWorld(Vector(0,7,20)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(-350,-550)+self:GetForward()*rand(-500,500)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/scientists/left_leg.mdl",{Pos=self:LocalToWorld(Vector(0,-7,20)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(350,550)+self:GetForward()*rand(-500,500)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/scientists/right_arm.mdl",{Pos=self:LocalToWorld(Vector(0,-3,2)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(150,250)+self:GetForward()*rand(-200,200)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/scientists/left_arm.mdl",{Pos=self:LocalToWorld(Vector(0,2,2)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(-150,-250)+self:GetForward()*rand(-200,200)})
	end
	
	if NPC == "npc_vj_bmce_cw_f" or NPC == "npc_vj_bmce_cw_f" then
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/cafe/torso.mdl",{Pos=self:LocalToWorld(Vector(0,0,5)),Ang=self:GetAngles()+Angle(90,0,0)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/cafe/right_leg.mdl",{Pos=self:LocalToWorld(Vector(0,7,60)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(-350,-550)+self:GetForward()*rand(-500,500)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/cafe/left_leg.mdl",{Pos=self:LocalToWorld(Vector(0,-7,50)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(350,550)+self:GetForward()*rand(-500,500)})
	end

	if NPC == "npc_vj_bmce_secguard_m" or NPC == "npc_vj_bmce_secguard_capt" or NPC == "npc_vj_bmce_secguard_f" then
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/guard/torso.mdl",{Pos=self:LocalToWorld(Vector(0,0,0)),Ang=self:GetAngles(),Vel=self:GetRight()*math.Rand(-100,100)+self:GetForward()*rand(-100,100)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/guard/right_leg.mdl",{Pos=self:LocalToWorld(Vector(0,0,0)),Ang=self:GetAngles(),Vel=self:GetRight()*math.Rand(100,250)+self:GetForward()*rand(-300,300)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/guard/right_leg.mdl",{Pos=self:LocalToWorld(Vector(0,7,0)),Ang=self:GetAngles(),Vel=self:GetRight()*math.Rand(-100,-250)+self:GetForward()*rand(-300,300)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/guard/right_arm.mdl",{Pos=self:LocalToWorld(Vector(0,4,5)),Ang=self:GetAngles(),Vel=self:GetRight()*math.Rand(150,250)+self:GetForward()*rand(-200,200)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/guard/left_arm.mdl",{Pos=self:LocalToWorld(Vector(0,-5,7)),Ang=self:GetAngles(),Vel=self:GetRight()*math.Rand(-150,-250)+self:GetForward()*rand(-200,200)})
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.FootSteps = 
{
	[MAT_ANTLION] = {"vj_bmce/footsteps/flesh_step1.mp3","vj_bmce/footsteps/flesh_step2.mp3","vj_bmce/footsteps/flesh_step3.mp3","vj_bmce/footsteps/flesh_step4.mp3","vj_bmce/footsteps/flesh_step5.mp3","vj_bmce/footsteps/flesh_step6.mp3","vj_bmce/footsteps/flesh_step7.mp3","vj_bmce/footsteps/flesh_step8.mp3","vj_bmce/footsteps/flesh_step9.mp3","vj_bmce/footsteps/flesh_step10.mp3"},
	[MAT_BLOODYFLESH] = {"vj_bmce/footsteps/flesh_step1.mp3","vj_bmce/footsteps/flesh_step2.mp3","vj_bmce/footsteps/flesh_step3.mp3","vj_bmce/footsteps/flesh_step4.mp3","vj_bmce/footsteps/flesh_step5.mp3","vj_bmce/footsteps/flesh_step6.mp3","vj_bmce/footsteps/flesh_step7.mp3","vj_bmce/footsteps/flesh_step8.mp3","vj_bmce/footsteps/flesh_step9.mp3","vj_bmce/footsteps/flesh_step10.mp3"},
	[MAT_CONCRETE] = {"vj_bmce/footsteps/concrete_step1.mp3","vj_bmce/footsteps/concrete_step2.mp3","vj_bmce/footsteps/concrete_step3.mp3","vj_bmce/footsteps/concrete_step4.mp3","vj_bmce/footsteps/concrete_step5.mp3","vj_bmce/footsteps/concrete_step6.mp3","vj_bmce/footsteps/concrete_step7.mp3","vj_bmce/footsteps/concrete_step8.mp3","vj_bmce/footsteps/concrete_grit_step1.mp3","vj_bmce/footsteps/concrete_grit_step2.mp3","vj_bmce/footsteps/concrete_grit_step3.mp3","vj_bmce/footsteps/concrete_grit_step4.mp3","vj_bmce/footsteps/concrete_grit_step5.mp3","vj_bmce/footsteps/concrete_grit_step6.mp3","vj_bmce/footsteps/concrete_grit_step7.mp3","vj_bmce/footsteps/concrete_grit_step8.mp3"},
	[MAT_DIRT] = {"vj_bmce/footsteps/gravel_step1.mp3","vj_bmce/footsteps/gravel_step2.mp3","vj_bmce/footsteps/gravel_step3.mp3","vj_bmce/footsteps/gravel_step4.mp3","vj_bmce/footsteps/gravel_step5.mp3","vj_bmce/footsteps/gravel_step6.mp3","vj_bmce/footsteps/gravel_step7.mp3","vj_bmce/footsteps/gravel_step8.mp3"},
	[MAT_FLESH] = {"vj_bmce/footsteps/flesh_step1.mp3","vj_bmce/footsteps/flesh_step2.mp3","vj_bmce/footsteps/flesh_step3.mp3","vj_bmce/footsteps/flesh_step4.mp3","vj_bmce/footsteps/flesh_step5.mp3","vj_bmce/footsteps/flesh_step6.mp3","vj_bmce/footsteps/flesh_step7.mp3","vj_bmce/footsteps/flesh_step8.mp3","vj_bmce/footsteps/flesh_step9.mp3","vj_bmce/footsteps/flesh_step10.mp3"},
	[MAT_GRATE] = {"vj_bmce/footsteps/metalgrate_step1.mp3","vj_bmce/footsteps/metalgrate_step2.mp3","vj_bmce/footsteps/metalgrate_step3.mp3","vj_bmce/footsteps/metalgrate_step4.mp3","vj_bmce/footsteps/metalgrate_step5.mp3","vj_bmce/footsteps/metalgrate_step6.mp3","vj_bmce/footsteps/metalgrate_step7.mp3","vj_bmce/footsteps/metalgrate_step8.mp3"},
	[MAT_ALIENFLESH] = {"physics/flesh/flesh_impact_hard1.mp3","physics/flesh/flesh_impact_hard2.mp3","physics/flesh/flesh_impact_hard3.mp3","physics/flesh/flesh_impact_hard4.mp3","physics/flesh/flesh_impact_hard5.mp3","physics/flesh/flesh_impact_hard6.mp3"},
	-- 74 is Snow
	[74] = {"vj_bmce/footsteps/sand_step1.mp3","vj_bmce/footsteps/sand_step2.mp3","vj_bmce/footsteps/sand_step3.mp3","vj_bmce/footsteps/sand_step4.mp3","vj_bmce/footsteps/sand_step5.mp3","vj_bmce/footsteps/sand_step6.mp3","vj_bmce/footsteps/sand_step7.mp3","vj_bmce/footsteps/sand_step8.mp3"},
	[MAT_PLASTIC] = {"vj_bmce/footsteps/plaster_step1.mp3","vj_bmce/footsteps/plaster_step2.mp3","vj_bmce/footsteps/plaster_step3.mp3","vj_bmce/footsteps/plaster_step4.mp3","vj_bmce/footsteps/plaster_step5.mp3","vj_bmce/footsteps/plaster_step6.mp3","vj_bmce/footsteps/plaster_step7.mp3","vj_bmce/footsteps/plaster_step8.mp3"},
	[MAT_METAL] = {"vj_bmce/footsteps/metalsolid_step1.mp3","vj_bmce/footsteps/metalsolid_step2.mp3","vj_bmce/footsteps/metalsolid_step3.mp3","vj_bmce/footsteps/metalsolid_step4.mp3","vj_bmce/footsteps/metalsolid_step5.mp3","vj_bmce/footsteps/metalsolid_step6.mp3","vj_bmce/footsteps/metalsolid_step7.mp3","vj_bmce/footsteps/metalsolid_step8.mp3"},
	[MAT_SAND] = {"vj_bmce/footsteps/sand_step1.mp3","vj_bmce/footsteps/sand_step2.mp3","vj_bmce/footsteps/sand_step3.mp3","vj_bmce/footsteps/sand_step4.mp3","vj_bmce/footsteps/sand_step5.mp3","vj_bmce/footsteps/sand_step6.mp3","vj_bmce/footsteps/sand_step7.mp3","vj_bmce/footsteps/sand_step8.mp3"},
	[MAT_FOLIAGE] = {"vj_bmce/footsteps/gravel_step1.mp3","vj_bmce/footsteps/gravel_step2.mp3","vj_bmce/footsteps/gravel_step3.mp3","vj_bmce/footsteps/gravel_step4.mp3","vj_bmce/footsteps/gravel_step5.mp3","vj_bmce/footsteps/gravel_step6.mp3","vj_bmce/footsteps/gravel_step7.mp3","vj_bmce/footsteps/gravel_step8.mp3"},
	[MAT_COMPUTER] = {"vj_bmce/footsteps/plaster_step1.mp3","vj_bmce/footsteps/plaster_step2.mp3","vj_bmce/footsteps/plaster_step3.mp3","vj_bmce/footsteps/plaster_step4.mp3","vj_bmce/footsteps/plaster_step5.mp3","vj_bmce/footsteps/plaster_step6.mp3","vj_bmce/footsteps/plaster_step7.mp3","vj_bmce/footsteps/plaster_step8.mp3"},
	[MAT_SLOSH] = {"vj_bmce/footsteps/water_foot_step1.mp3","vj_bmce/footsteps/water_foot_step2.mp3","vj_bmce/footsteps/water_foot_step3.mp3","vj_bmce/footsteps/water_foot_step4.mp3","vj_bmce/footsteps/water_foot_step5.mp3"},
	[MAT_TILE] = {"vj_bmce/footsteps/plaster_step1.mp3","vj_bmce/footsteps/plaster_step2.mp3","vj_bmce/footsteps/plaster_step3.mp3","vj_bmce/footsteps/plaster_step4.mp3","vj_bmce/footsteps/plaster_step5.mp3","vj_bmce/footsteps/plaster_step6.mp3","vj_bmce/footsteps/plaster_step7.mp3","vj_bmce/footsteps/plaster_step8.mp3"},
	-- 85 is grass
	[85] = {"vj_bmce/footsteps/earth_step1.mp3","vj_bmce/footsteps/earth_step2.mp3","vj_bmce/footsteps/earth_step3.mp3","vj_bmce/footsteps/earth_step4.mp3","vj_bmce/footsteps/earth_step5.mp3","vj_bmce/footsteps/earth_step6.mp3","vj_bmce/footsteps/earth_step7.mp3","vj_bmce/footsteps/earth_step8.mp3"},
	[MAT_VENT] = {"vj_bmce/footsteps/metalsolid_step1.mp3","vj_bmce/footsteps/metalsolid_step2.mp3","vj_bmce/footsteps/metalsolid_step3.mp3","vj_bmce/footsteps/metalsolid_step4.mp3","vj_bmce/footsteps/metalsolid_step5.mp3","vj_bmce/footsteps/metalsolid_step6.mp3","vj_bmce/footsteps/metalsolid_step7.mp3","vj_bmce/footsteps/metalsolid_step8.mp3"},
	[MAT_WOOD] = {"vj_bmce/footsteps/wood_step1.mp3","vj_bmce/footsteps/wood_step2.mp3","vj_bmce/footsteps/wood_step3.mp3","vj_bmce/footsteps/wood_step4.mp3","vj_bmce/footsteps/wood_step5.mp3","vj_bmce/footsteps/wood_step6.mp3","vj_bmce/footsteps/wood_step7.mp3","vj_bmce/footsteps/wood_step8.mp3"},
	[MAT_GLASS] = {"vj_bmce/footsteps/glasssolid_step1.mp3","vj_bmce/footsteps/glasssolid_step2.mp3","vj_bmce/footsteps/glasssolid_step3.mp3","vj_bmce/footsteps/glasssolid_step4.mp3","vj_bmce/footsteps/glasssolid_step5.mp3","vj_bmce/footsteps/glasssolid_step6.mp3","vj_bmce/footsteps/glasssolid_step7.mp3","vj_bmce/footsteps/glasssolid_step8.mp3"}
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFootStepSound()
	if !self:IsOnGround() then return end
	local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() +Vector(0,0,-150),
		filter = {self}
	})
	if tr.Hit and self.FootSteps[tr.MatType] then
		VJ_EmitSound(self,VJ_PICK(self.FootSteps[tr.MatType]),self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
	end
	if self:WaterLevel() > 0 and self:WaterLevel() < 3 then
		VJ_EmitSound(self,"vj_bmce/footsteps/water_wade" .. random( 1, 4 ) .. ".mp3",self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FootStepSoundCode(CustomTbl)
	if self.HasSounds == false or self.HasFootStepSound == false or self.MovementType == VJ_MOVETYPE_STATIONARY then return end
	if self:IsOnGround() and self:GetGroundEntity() != NULL then
		if self.DisableFootStepSoundTimer == true then
			self:CustomOnFootStepSound()
			return
		elseif self:IsMoving() and CurTime() > self.FootStepT then
			self:CustomOnFootStepSound()
			local CurSched = self.CurrentSchedule
			if self.DisableFootStepOnRun == false and ((VJ_HasValue(self.AnimTbl_Run,self:GetMovementActivity())) or (CurSched != nil  and CurSched.IsMovingTask_Run == true)) /*(VJ_HasValue(VJ_RunActivites,self:GetMovementActivity()) or VJ_HasValue(self.CustomRunActivites,self:GetMovementActivity()))*/ then
				self:CustomOnFootStepSound_Run()
				self.FootStepT = CurTime() + self.FootStepTimeRun
				return
			elseif self.DisableFootStepOnWalk == false and (VJ_HasValue(self.AnimTbl_Walk,self:GetMovementActivity()) or (CurSched != nil  and CurSched.IsMovingTask_Walk == true)) /*(VJ_HasValue(VJ_WalkActivites,self:GetMovementActivity()) or VJ_HasValue(self.CustomWalkActivites,self:GetMovementActivity()))*/ then
				self:CustomOnFootStepSound_Walk()
				self.FootStepT = CurTime() + self.FootStepTimeWalk
				return
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "step" then
		self:FootStepSoundCode()
	end

	if key == "Use" then
		if follower:GetBool() then -- If the convar is enabled, we allow our SNPC to follow the player.
			if self.IsFollowing == false then
				activator:PrintMessage(HUD_PRINTTALK, self:GetName().. ": I'll follow you.")
			elseif self.IsFollowing == true then
				activator:PrintMessage(HUD_PRINTTALK, self:GetName().. ": I'll stay here.")
			end
		else -- If not, then we don't want to follow them
			if self.DisasterBehavior == 0 then -- Make sure that it's a pre-d npc
				self.IsFollowing = true -- Trick VJ base thinking that this NPC can't follow.
				self:PlaySoundSystem("GeneralSpeech", self.SoundTbl_LeaveMeAlone)
				activator:PrintMessage(HUD_PRINTTALK, self:GetName().. ": I'm busy " .. activator:GetName().. ", go bother someone else.")
			else
				if self.IsFollowing == false then
					activator:PrintMessage(HUD_PRINTTALK, self:GetName().. ": I'll follow you.")
				elseif self.IsFollowing == true then
					activator:PrintMessage(HUD_PRINTTALK, self:GetName().. ": I'll stay here.")
				end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,corpseEnt)
	if self.BMCE_Hat == 1 then
		self:CreateExtraDeathCorpse("prop_physics","models/humans/props/guard_beret.mdl",{Pos=self:LocalToWorld(Vector(0,0,-2))})
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupWeaponHoldTypeAnims(hType)
	self.WeaponAnimTranslations = {}
	self.NextIdleStandTime = 0
	if self:CustomOnSetupWeaponHoldTypeAnims(hType) == true then return end
	if self.ModelAnimationSet == VJ_MODEL_ANIMSET_BMSTAFF then -- Humans
		
		-- handguns use a different set!
		self.WeaponAnimTranslations[ACT_COVER_LOW] 							= {ACT_COVER_LOW_RPG, ACT_COVER_LOW, "vjseq_coverlow_l", "vjseq_coverlow_r"}
		
		if hType == "ar2" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_RANGE_ATTACK_AR2
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_GESTURE_RANGE_ATTACK_AR2
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_RANGE_ATTACK_AR2_LOW
			self.WeaponAnimTranslations[ACT_RELOAD] 						= VJ_SequenceToActivity(self, "reload_smg1")
			self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= ACT_RELOAD_SMG1_LOW
			self.WeaponAnimTranslations[ACT_IDLE] 							= VJ_PICK({VJ_SequenceToActivity(self, "idle_relaxed_ar2_1"), VJ_SequenceToActivity(self, "idle_alert_ar2_1"), VJ_SequenceToActivity(self, "idle_angry_ar2")})
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= VJ_SequenceToActivity(self, "idle_ar2_aim")
			self.WeaponAnimTranslations[ACT_WALK] 							= VJ_PICK({VJ_SequenceToActivity(self, "walk_ar2_relaxed_all"), VJ_SequenceToActivity(self, "walkalerthold_ar2_all1"), VJ_SequenceToActivity(self, "walkholdall1_ar2")})
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= VJ_PICK({VJ_SequenceToActivity(self, "walkaimall1_ar2"), VJ_SequenceToActivity(self, "walkalertaim_ar2_all1")})
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_WALK_CROUCH_RPG
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_WALK_CROUCH_AIM_RIFLE
			self.WeaponAnimTranslations[ACT_RUN] 							= VJ_PICK({VJ_SequenceToActivity(self, "run_alert_holding_ar2_all"), VJ_SequenceToActivity(self, "run_ar2_relaxed_all"), VJ_SequenceToActivity(self, "run_holding_ar2_all")})
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= VJ_PICK({ACT_RUN_AIM_RIFLE, VJ_SequenceToActivity(self, "run_alert_aiming_ar2_all")})
			self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_RUN_CROUCH_RPG
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
		elseif hType == "pistol" or hType == "revolver" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_RANGE_ATTACK_PISTOL
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_GESTURE_RANGE_ATTACK_PISTOL
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_RANGE_ATTACK_PISTOL_LOW
			self.WeaponAnimTranslations[ACT_COVER_LOW] 						= {"crouchidle_panicked4", "vjseq_crouchidlehide"}
			self.WeaponAnimTranslations[ACT_RELOAD] 						= ACT_RELOAD_PISTOL
			self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= ACT_RELOAD_SMG1_LOW
			
			self.WeaponAnimTranslations[ACT_IDLE] 							= ACT_IDLE_PISTOL
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_IDLE_ANGRY_PISTOL
			
			self.WeaponAnimTranslations[ACT_WALK] 							= ACT_WALK_PISTOL
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= VJ_SequenceToActivity(self, "walk_hold_pistol")
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_WALK_CROUCH_AIM_RIFLE
			
			self.WeaponAnimTranslations[ACT_RUN] 							= ACT_RUN_PISTOL
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= VJ_SequenceToActivity(self, "run_hold_pistol")
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
		elseif hType == "smg" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_RANGE_ATTACK_AR2
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_GESTURE_RANGE_ATTACK_SMG1
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_RANGE_ATTACK_AR2_LOW
			self.WeaponAnimTranslations[ACT_RELOAD] 						= ACT_RELOAD_SMG1
			self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= ACT_RELOAD_SMG1_LOW
			self.WeaponAnimTranslations[ACT_IDLE] 							= VJ_PICK({VJ_SequenceToActivity(self, "idle_smg1_relaxed"), VJ_SequenceToActivity(self, "idle_angry_shotgun")})
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= VJ_SequenceToActivity(self, "idle_ar2_aim")
			self.WeaponAnimTranslations[ACT_WALK] 							= VJ_PICK({VJ_SequenceToActivity(self, "walkalerthold_ar2_all1")})
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= VJ_PICK({ACT_WALK_AIM_RIFLE_STIMULATED})
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_WALK_CROUCH_RIFLE
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_WALK_CROUCH_AIM_RIFLE
			self.WeaponAnimTranslations[ACT_RUN] 							= VJ_PICK({ACT_RUN_RIFLE, ACT_RUN_RIFLE_STIMULATED, ACT_RUN_RIFLE_RELAXED})
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= VJ_PICK({ACT_RUN_AIM_RIFLE, VJ_SequenceToActivity(self, "run_alert_aiming_ar2_all")})
			self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_RUN_CROUCH_RIFLE
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
		elseif hType == "crossbow" or hType == "shotgun" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= VJ_SequenceToActivity(self, "shoot_shotgun")
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_GESTURE_RANGE_ATTACK_SMG1
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_RANGE_ATTACK_SMG1_LOW
			self.WeaponAnimTranslations[ACT_RELOAD] 						= ACT_RELOAD_SHOTGUN
			self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= ACT_RELOAD_SMG1_LOW //ACT_RELOAD_SHOTGUN_LOW
			self.WeaponAnimTranslations[ACT_IDLE] 							= VJ_PICK({ACT_IDLE_SHOTGUN_STIMULATED, ACT_IDLE_SHOTGUN_RELAXED})
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= VJ_SequenceToActivity(self, "idle_ar2_aim")
			self.WeaponAnimTranslations[ACT_WALK] 							= VJ_PICK({VJ_SequenceToActivity(self, "walkalerthold_ar2_all1")})
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= VJ_PICK({VJ_SequenceToActivity(self, "walkaimall1_ar2"), VJ_SequenceToActivity(self, "walkalertaim_ar2_all1")})
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_WALK_CROUCH_RPG
			self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_WALK_CROUCH_AIM_RIFLE
			self.WeaponAnimTranslations[ACT_RUN] 							= VJ_PICK({VJ_SequenceToActivity(self, "run_alert_holding_ar2_all"), VJ_SequenceToActivity(self, "run_ar2_relaxed_all"), VJ_SequenceToActivity(self, "run_holding_ar2_all")})
			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= VJ_PICK({ACT_RUN_AIM_RIFLE, VJ_SequenceToActivity(self, "run_alert_aiming_ar2_all")})
			self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_RUN_CROUCH_RPG
			self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
		elseif hType == "rpg" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_RANGE_ATTACK_RPG
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_GESTURE_RANGE_ATTACK_RPG
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 				= ACT_RANGE_ATTACK_SMG1_LOW
			self.WeaponAnimTranslations[ACT_RELOAD] 						= ACT_RELOAD_SMG1
			self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= ACT_RELOAD_SMG1_LOW
			self.WeaponAnimTranslations[ACT_IDLE] 							= VJ_PICK({ACT_IDLE_RPG, ACT_IDLE_RPG_RELAXED})
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_IDLE_ANGRY_RPG
			self.WeaponAnimTranslations[ACT_WALK] 							= VJ_PICK({ACT_WALK_RPG, ACT_WALK_RPG_RELAXED})
			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= VJ_PICK({VJ_SequenceToActivity(self, "walkaimall1_ar2"), VJ_SequenceToActivity(self, "walkalertaim_ar2_all1")})
			self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_WALK_CROUCH_RPG
		elseif hType == "melee" or hType == "melee2" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_MELEE_ATTACK_SWING
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= false
			self.WeaponAnimTranslations[ACT_COVER_LOW] 						= ACT_COWER
			self.WeaponAnimTranslations[ACT_IDLE] 							= VJ_PICK({ACT_IDLE, ACT_IDLE, VJ_SequenceToActivity(self, "plazathreat1")})
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_IDLE_ANGRY_MELEE
			self.WeaponAnimTranslations[ACT_WALK] 							= VJ_PICK({ACT_WALK, ACT_WALK_ANGRY})
			self.WeaponAnimTranslations[ACT_RUN] 							= VJ_PICK({VJ_SequenceToActivity(self, "run_melee2_1"), VJ_SequenceToActivity(self, "run_all"), VJ_SequenceToActivity(self, "run_all_panicked")})
		elseif hType == "knife" then
			self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 					= ACT_MELEE_ATTACK_SWING
			self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= false
			self.WeaponAnimTranslations[ACT_COVER_LOW] 						= ACT_COWER
			self.WeaponAnimTranslations[ACT_IDLE] 							= VJ_PICK({ACT_IDLE, ACT_IDLE, VJ_SequenceToActivity(self, "plazathreat1")})
			self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_IDLE_ANGRY_MELEE
			self.WeaponAnimTranslations[ACT_WALK] 							= VJ_PICK({ACT_WALK, ACT_WALK_ANGRY})
			self.WeaponAnimTranslations[ACT_RUN] 							= VJ_PICK({VJ_SequenceToActivity(self, "run_knife_1"), VJ_SequenceToActivity(self, "run_all"), VJ_SequenceToActivity(self, "run_all_panicked")})
		end
	end
end