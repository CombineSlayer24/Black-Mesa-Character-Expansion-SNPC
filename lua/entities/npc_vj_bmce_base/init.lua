AddCSLuaFile("shared.lua")
include('shared.lua')
local random = math.random
local rand = math.Rand
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.HullType = HULL_HUMAN
//ENT.VJ_NPC_Class = {"CLASS_BLACK_MESA_PERSONNEL","CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
---------------------------------------------------------------------------------------------------------------------------------------------
-- ====== Controller Data ====== --
ENT.VJC_Data = {
	CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
	ThirdP_Offset = Vector(30, 25, -50), -- The offset for the controller when the camera is in third person
	FirstP_Bone = "ValveBiped.Bip01_Head1", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(0, 0, 5), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.FollowPlayer = true -- Should the SNPC follow the player when the player presses a certain key?
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.FriendsWithAllPlayerAllies = true -- Should this SNPC be friends with all other player allies that are running on VJ Base?
ENT.BecomeEnemyToPlayer = true -- Should the friendly SNPC become enemy towards the player if it's damaged by a player?
ENT.BecomeEnemyToPlayerLevel = 2 -- How many times does the player have to hit the SNPC for it to become enemy? (Three hits)
ENT.HasItemDropsOnDeath = true -- Should it drop items on death?
ENT.ItemDropsOnDeathChance = 10
ENT.ItemDropsOnDeath_EntityList = {"item_healthvial","item_battery"}
ENT.HasOnPlayerSight = true -- Should do something when it sees the enemy? Example: Play a sound
ENT.FootStepTimeRun = 0.3 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.5 -- Next foot step sound when it is walking
ENT.HasGrenadeAttack = nil -- Should the SNPC have a grenade attack?
ENT.AnimTbl_GrenadeAttack = {"GrenadeThrow"}
ENT.GrenadeAttackAttachment = "anim_attachment_LH" -- The attachment that the grenade will spawn at | false = Custom position

	-- ====== Medic Variables ====== --
ENT.AnimTbl_Medic_GiveHealth = {"ThrowItem"}
ENT.Medic_SpawnPropOnHealModel = "models/weapons/zworld_health/bandages.mdl" 
ENT.Medic_CheckDistance = 600 -- How far does it check for allies that are hurt? | World units
ENT.Medic_HealDistance = 100 -- How close does it have to be until it stops moving and heals its ally?
ENT.Medic_HealthAmount = 50 -- How health does it give?
ENT.Medic_NextHealTime = VJ_Set(10, 15) -- How much time until it can give health to an ally again
ENT.Medic_SpawnPropOnHeal = true -- Should it spawn a prop, such as small health vial at a attachment when healing an ally?

	-- ====== Flinching Variables ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchChance = 8 -- Chance of it flinching from 1 to x | 1 will make it always flinch
ENT.HitGroupFlinching_Values = {
	{HitGroup={HITGROUP_LEFTARM}, Animation={ACT_FLINCH_LEFTARM}},
	{HitGroup={HITGROUP_LEFTLEG}, Animation={ACT_FLINCH_LEFTARM}},
	{HitGroup={HITGROUP_RIGHTARM}, Animation={ACT_FLINCH_RIGHTARM}},
	{HitGroup={HITGROUP_RIGHTLEG}, Animation={ACT_FLINCH_RIGHTARM}},
	{HitGroup={HITGROUP_STOMACH}, Animation={ACT_FLINCH_STOMACH}},
	{HitGroup={HITGROUP_CHEST}, Animation={ACT_FLINCH_CHEST}},
	{HitGroup={HITGROUP_HEAD}, Animation={ACT_FLINCH_HEAD}}
}
-- ====== Death Animation Variables ====== --
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {"Ranen_Idle1","Ranen_Idle1","Ranen_Idle1","Ranen3_Idle1","Ranen3_Idle1","Ranen3_Idle1"/*,"vjseq_nz_death_1","vjseq_nz_death_2","vjseq_nz_death_3","vjseq_nz_death_expl_f_2","vjseq_nz_death_expl_f_3"*/} -- Death Animations
	-- To let the base automatically detect the animation duration, set this to false:
ENT.DeathAnimationTime = false
ENT.DeathAnimationChance = 4
ENT.DeathAnimationDecreaseLengthAmount = 0 -- This will decrease the time until it turns into a corpse
-- Sound chances and what not
ENT.OnPlayerSightSoundChance = 3
-- move to armed down bellow --
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {"swing","pushplayer","thrust","barrelpush","melee_slice"} -- Melee Attack Animations
ENT.MeleeAttackDamage = random( 4, 10)
ENT.MeleeAttackDistance = 45 -- How close does it have to be until it attacks?
ENT.DisasterBehavior = nil // 0 = Pre Disaster sounds, 1 = Post Disaster sounds

local behaviour = GetConVar( "vj_bmce_disaster_status" )
local enemy = GetConVar( "vj_bmce_hostile" )
local wpns = GetConVar( "vj_bmce_weapons" )
local staffwep = {
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

local staffwep_constu = {
	"weapon_vj_bmce_glock17",
	"weapon_vj_bmce_glock17",
	"weapon_vj_bmce_glock17",
	"weapon_vj_bmce_glock17",
	"weapon_vj_crowbar",
	"weapon_vj_crowbar",
	"weapon_vj_crowbar",
	"weapon_vj_crowbar",
	"weapon_vj_bmce_m9",
	"weapon_vj_bmce_m9",
	"weapon_vj_bmce_mp5"
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize()
	self:SetNPCBodyGroups()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UseMaleVoice()
	if self.DisasterBehavior == 0 then //Pre Disaster sounds
		self.SoundTbl_Pain = {"vj_bmce/vocals/vj_bmce_male/die1.wav","vj_bmce/vocals/vj_bmce_male/die2.wav","vj_bmce/vocals/vj_bmce_male/die3.wav","vj_bmce/vocals/vj_bmce_male/die4.wav","vj_bmce/vocals/vj_bmce_male/die5.wav","vj_bmce/vocals/vj_bmce_male/die6.wav","vj_bmce/vocals/vj_bmce_male/die7.wav"}
		self.SoundTbl_Death = {"vj_bmce/vocals/vj_bmce_male/die1.wav","vj_bmce/vocals/vj_bmce_male/die2.wav","vj_bmce/vocals/vj_bmce_male/die3.wav","vj_bmce/vocals/vj_bmce_male/die4.wav","vj_bmce/vocals/vj_bmce_male/die5.wav","vj_bmce/vocals/vj_bmce_male/die6.wav","vj_bmce/vocals/vj_bmce_male/die7.wav"}
		self.SoundTbl_Alert = {"vj_bmce/vocals/vj_bmce_male/alert1.wav","vj_bmce/vocals/vj_bmce_male/alert2.wav","vj_bmce/vocals/vj_bmce_male/alert3.wav","vj_bmce/vocals/vj_bmce_male/alert4.wav","vj_bmce/vocals/vj_bmce_male/alert5.wav","vj_bmce/vocals/vj_bmce_male/alert6.wav"}
		self.SoundTbl_CombatIdle = {"vj_bmce/vocals/vj_bmce_male/attack1.wav","vj_bmce/vocals/vj_bmce_male/attack2.wav","vj_bmce/vocals/vj_bmce_male/attack3.wav","vj_bmce/vocals/vj_bmce_male/attack4.wav","vj_bmce/vocals/vj_bmce_male/attack5.wav","vj_bmce/vocals/vj_bmce_male/attack6.wav","vj_bmce/vocals/vj_bmce_male/attack7.wav","vj_bmce/vocals/vj_bmce_male/attack8.wav","vj_bmce/vocals/vj_bmce_male/attack9.wav","vj_bmce/vocals/vj_bmce_male/attack10.wav","vj_bmce/vocals/vj_bmce_male/attack11.wav","vj_bmce/vocals/vj_bmce_male/attack12.wav"}
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
		self.SoundTbl_DamageByPlayer = {"vj_bmce/vocals/vj_bmce_male/stupidplayer1.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer2.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer3.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer4.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer5.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer6.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer7.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer8.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer9.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer10.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer11.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer12.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer13.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer14.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer15.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer16.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer17.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer18.wav","vj_bmce/vocals/vj_bmce_male/stupidplayer19.wav"}
		self.SoundTbl_MedicBeforeHeal = {"vj_bmce/vocals/vj_bmce_male/heal_player1.wav","vj_bmce/vocals/vj_bmce_male/heal_player2.wav","vj_bmce/vocals/vj_bmce_male/heal_player3.wav","vj_bmce/vocals/vj_bmce_male/heal_player4.wav","vj_bmce/vocals/vj_bmce_male/heal_player5.wav","vj_bmce/vocals/vj_bmce_male/heal_player6.wav"}
		self.SoundTbl_Investigate = {"vj_bmce/vocals/vj_bmce_male/attack1.wav","vj_bmce/vocals/vj_bmce_male/attack2.wav","vj_bmce/vocals/vj_bmce_male/attack3.wav","vj_bmce/vocals/vj_bmce_male/attack7.wav",}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UseFemaleVoice()
	if self.DisasterBehavior == 0 then // Pre Disaster sounds
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
		self.SoundTbl_Investigate = {"vj_bmce/vocals/vj_bmce_female/answer_pre21.wav","vj_bmce/vocals/vj_bmce_female/answer_pre09.wav","vj_bmce/vocals/vj_bmce_secguard/sf_alert3.wav"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize() -- rework this crap later!!!!!!
	local NPC = self:GetClass()

	if behaviour:GetInt() == 0 then
		-- males
		if NPC == "npc_vj_bmce_scientist_m" then
			if enemy:GetInt() == 0 then
				self.VJ_NPC_Class = {"CLASS_BLACK_MESA_PERSONNEL","CLASS_PLAYER_ALLY"}
			elseif enemy:GetInt() == 1 then
				self.VJ_NPC_Class = {"CLASS_BLACK_MESA_PERSONNEL_HOSTILE"}
			end
			self.StartHealth = 75
			self.IsMedicSNPC = true
			self.Model = {"models/humans/scientist.mdl","models/humans/scientist_02.mdl","models/humans/scientist_03.mdl","models/humans/scientist_cl.mdl"}
			self:SetBehaviorAndWeapons()
			self:UseMaleVoice()
		end

		if NPC == "npc_vj_bmce_scientist_casual_m" then
			if enemy:GetInt() == 0 then
				self.VJ_NPC_Class = {"CLASS_BLACK_MESA_PERSONNEL","CLASS_PLAYER_ALLY"}
			elseif enemy:GetInt() == 1 then
				self.VJ_NPC_Class = {"CLASS_BLACK_MESA_PERSONNEL_HOSTILE"}
			end
			self.StartHealth = 75
			self.IsMedicSNPC = true
			self.Model = {"models/humans/scientist_casual.mdl","models/humans/scientist_casual_02.mdl","models/humans/scientist_casual_02.mdl"}
			self:SetBehaviorAndWeapons()
			self:UseMaleVoice()
		end

		if NPC == "npc_vj_bmce_cw_m" then
			if enemy:GetInt() == 0 then
				self.VJ_NPC_Class = {"CLASS_BLACK_MESA_PERSONNEL","CLASS_PLAYER_ALLY"}
			elseif enemy:GetInt() == 1 then
				self.VJ_NPC_Class = {"CLASS_BLACK_MESA_PERSONNEL_HOSTILE"}
			end
			self.StartHealth = 75
			self.Model = {"models/humans/cafeteria_male.mdl"}
			self:SetBehaviorAndWeapons()
			self:UseMaleVoice()
		end

		if NPC == "npc_vj_bmce_custodian_m" then
			if enemy:GetInt() == 0 then
				self.VJ_NPC_Class = {"CLASS_BLACK_MESA_PERSONNEL","CLASS_PLAYER_ALLY"}
			elseif enemy:GetInt() == 1 then
				self.VJ_NPC_Class = {"CLASS_BLACK_MESA_PERSONNEL_HOSTILE"}
			end
			self.StartHealth = 90
			self.Model = {"models/humans/custodian.mdl"}
			self:SetBehaviorAndWeapons()
			self:UseMaleVoice()
		end

		if NPC == "npc_vj_bmce_constructw_m" then
			if enemy:GetInt() == 0 then
				self.VJ_NPC_Class = {"CLASS_BLACK_MESA_PERSONNEL","CLASS_PLAYER_ALLY"}
			elseif enemy:GetInt() == 1 then
				self.VJ_NPC_Class = {"CLASS_BLACK_MESA_PERSONNEL_HOSTILE"}
			end
			self.StartHealth = 90
			self.Model = {"models/humans/construction_worker.mdl"}
			self:SetBehaviorAndWeapons()
			self:UseMaleVoice()
		end

		-- Females
		if NPC == "npc_vj_bmce_scientist_f" then
			if enemy:GetInt() == 0 then
				self.VJ_NPC_Class = {"CLASS_BLACK_MESA_PERSONNEL","CLASS_PLAYER_ALLY"}
			elseif enemy:GetInt() == 1 then
				self.VJ_NPC_Class = {"CLASS_BLACK_MESA_PERSONNEL_HOSTILE"}
			elseif enemy:GetInt() == 2 then
				self.HasAllies = false
			end
			self.StartHealth = 75
			self.IsMedicSNPC = true
			self.Model = {"models/humans/scientist_female.mdl"}
			self:SetBehaviorAndWeapons()
			self:UseFemaleVoice()
		end

		if NPC == "npc_vj_bmce_cw_f" then
			if enemy:GetInt() == 0 then
				self.VJ_NPC_Class = {"CLASS_BLACK_MESA_PERSONNEL","CLASS_PLAYER_ALLY"}
			elseif enemy:GetInt() == 1 then
				self.VJ_NPC_Class = {"CLASS_BLACK_MESA_PERSONNEL_HOSTILE"}
			elseif enemy:GetInt() == 2 then
				self.HasAllies = false
			end
			self.StartHealth = 75
			self.Model = {"models/humans/cafeteria_female.mdl"}
			self:SetBehaviorAndWeapons()
			self:UseFemaleVoice()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetBehaviorAndWeapons() -- Sets the Black Mesa Staff disaster behavior and weapons, this must be above setting the voice function
	local NPC = self:GetClass()
	local Weapon_Chance = random(1,3)
	local Staff_Wep = VJ_PICK(staffwep[random(#staffwep)])
	local Staff_Constu_Weapons = VJ_PICK(staffwep_constu[random(#staffwep_constu)])

	-- Setting the disaster behavior
	if behaviour:GetInt() == 0 then
		self.DisasterBehavior = 0
	elseif behaviour:GetInt() == 1 then
		self.DisasterBehavior = 1
	end

	if wpns:GetInt() == 1 or wpns:GetInt() == 2 then 
		self.Behavior = VJ_BEHAVIOR_AGRESSIVE
	end

	-- Setting the Custom Weapons
	if NPC == "npc_vj_bmce_scientist_m" or "npc_vj_bmce_scientist_casual_m" or "npc_vj_bmce_scientist_f" or "npc_vj_bmce_cw_f" or "npc_vj_bmce_cw_m" then
		if wpns:GetInt() == 1 then 
			if Weapon_Chance == 1 then
				self:Give(Staff_Wep)
			elseif Weapon_Chance == 2 or Weapon_Chance == 3 then -- maybe a better way to do this????
				self.Behavior = VJ_BEHAVIOR_PASSIVE
			end
		end
		
		if wpns:GetInt() == 2 then
			if Weapon_Chance == 1 or Weapon_Chance == 2 or Weapon_Chance == 3 then
				self:Give(Staff_Wep)
			end
		end
	end

	if NPC == "npc_vj_bmce_constructw_m" or "npc_vj_bmce_custodian_m" then
		if wpns:GetInt() == 1 then 
			if Weapon_Chance == 1 then
				self:Give(Staff_Constu_Weapons)
			elseif Weapon_Chance == 2 or Weapon_Chance == 3 then
				self.Behavior = VJ_BEHAVIOR_PASSIVE
			end
		end
		
		if wpns:GetInt() == 2 then
			if Weapon_Chance == 1 or Weapon_Chance == 2 or Weapon_Chance == 3 then
				self:Give(Staff_Constu_Weapons)
			end
		end
	end

	if wpns:GetInt() == 0 then
		self.Behavior = VJ_BEHAVIOR_PASSIVE
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetNPCBodyGroups() -- Sets the bodygroups for NPCS
	local NPC = self:GetClass()
	local Hat_Chance = random(1,3)
	
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
		end
		
		if NPC == "npc_vj_bmce_cw_m" then
			self:SetSkin(random( 0, 14 ))
			self:SetBodygroup(4,random( 0, 14 )) -- Glasses
			self:SetBodygroup(2,random( 0, 1 )) -- Apron
			self:SetBodygroup(3,random( 0, 8 )) -- Hair
		end

		if NPC == "npc_vj_bmce_custodian_m" then
			self:SetSkin(random( 0, 14 ))
			self:SetBodygroup(1,random( 0, 1 )) -- body
			self:SetBodygroup(3,random( 0, 1 )) -- vest
			self:SetBodygroup(4,random( 3, 14 )) -- Glasses
			if Hat_Chance == 1 then self:SetBodygroup( 2, random( 0, 4 )) end
		end

		if NPC == "npc_vj_bmce_constructw_m" then
			self:SetSkin(random( 0, 16 ))
			self:SetBodygroup(1,random( 0, 3 )) -- t-shirts
			self:SetBodygroup(2,random( 0, 3 )) -- pants
			self:SetBodygroup(3,random( 0, 1 )) -- shows
			self:SetBodygroup(5,random( 3, 14 )) -- Glasses
			if Hat_Chance == 1 then self:SetBodygroup( 4, random( 0, 4 )) end
		end

		if NPC == "npc_vj_bmce_scientist_f" then
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

	if NPC == "npc_vj_bmce_scientist_m" || NPC == "npc_vj_bmce_scientist_m" then
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/scientists/torso.mdl",{Pos=self:LocalToWorld(Vector(0,0,0)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(-100,100)+self:GetForward()*rand(-100,100)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/scientists/right_leg.mdl",{Pos=self:LocalToWorld(Vector(0,7,2)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(-350,-550)+self:GetForward()*rand(-500,500)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/scientists/left_leg.mdl",{Pos=self:LocalToWorld(Vector(0,-7,2)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(350,550)+self:GetForward()*rand(-500,500)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/scientists/right_arm.mdl",{Pos=self:LocalToWorld(Vector(0,-3,2)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(150,250)+self:GetForward()*rand(-200,200)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/scientists/left_arm.mdl",{Pos=self:LocalToWorld(Vector(0,2,2)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(-150,-250)+self:GetForward()*rand(-200,200)})
	end

	if NPC == "npc_vj_bmce_scientist_casual_m" || NPC == "npc_vj_bmce_scientist_casual_m" then
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/scientists/right_leg.mdl",{Pos=self:LocalToWorld(Vector(0,7,2)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(-350,-550)+self:GetForward()*rand(-500,500)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/scientists/left_leg.mdl",{Pos=self:LocalToWorld(Vector(0,-7,2)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(350,550)+self:GetForward()*rand(-500,500)})
	end

	if NPC == "npc_vj_bmce_scientist_f" || NPC == "npc_vj_bmce_scientist_f" then
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/fem_sci/torso.mdl",{Pos=self:LocalToWorld(Vector(0,0,0)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(-100,100)+self:GetForward()*rand(-100,100)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/scientists/right_leg.mdl",{Pos=self:LocalToWorld(Vector(0,7,20)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(-350,-550)+self:GetForward()*rand(-500,500)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/scientists/left_leg.mdl",{Pos=self:LocalToWorld(Vector(0,-7,20)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(350,550)+self:GetForward()*rand(-500,500)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/scientists/right_arm.mdl",{Pos=self:LocalToWorld(Vector(0,-3,2)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(150,250)+self:GetForward()*rand(-200,200)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/scientists/left_arm.mdl",{Pos=self:LocalToWorld(Vector(0,2,2)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(-150,-250)+self:GetForward()*rand(-200,200)})
	end
	
	if NPC == "npc_vj_bmce_cw_f" || NPC == "npc_vj_bmce_cw_f" then
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/cafe/torso.mdl",{Pos=self:LocalToWorld(Vector(0,0,5)),Ang=self:GetAngles()+Angle(90,0,0)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/cafe/right_leg.mdl",{Pos=self:LocalToWorld(Vector(0,7,60)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(-350,-550)+self:GetForward()*rand(-500,500)})
		self:CreateGibEntity("prop_ragdoll","models/gibs/humans/cafe/left_leg.mdl",{Pos=self:LocalToWorld(Vector(0,-7,50)),Ang=self:GetAngles(),Vel=self:GetRight()*rand(350,550)+self:GetForward()*rand(-500,500)})
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
	if tr.Hit && self.FootSteps[tr.MatType] then
		VJ_EmitSound(self,VJ_PICK(self.FootSteps[tr.MatType]),self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
	end
	if self:WaterLevel() > 0 && self:WaterLevel() < 3 then
		VJ_EmitSound(self,"vj_bmce/footsteps/water_wade" .. random( 1, 4 ) .. ".mp3",self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FootStepSoundCode(CustomTbl)
	if self.HasSounds == false or self.HasFootStepSound == false or self.MovementType == VJ_MOVETYPE_STATIONARY then return end
	if self:IsOnGround() && self:GetGroundEntity() != NULL then
		if self.DisableFootStepSoundTimer == true then
			self:CustomOnFootStepSound()
			return
		elseif self:IsMoving() && CurTime() > self.FootStepT then
			self:CustomOnFootStepSound()
			local CurSched = self.CurrentSchedule
			if self.DisableFootStepOnRun == false && ((VJ_HasValue(self.AnimTbl_Run,self:GetMovementActivity())) or (CurSched != nil  && CurSched.IsMovingTask_Run == true)) /*(VJ_HasValue(VJ_RunActivites,self:GetMovementActivity()) or VJ_HasValue(self.CustomRunActivites,self:GetMovementActivity()))*/ then
				self:CustomOnFootStepSound_Run()
				self.FootStepT = CurTime() + self.FootStepTimeRun
				return
			elseif self.DisableFootStepOnWalk == false && (VJ_HasValue(self.AnimTbl_Walk,self:GetMovementActivity()) or (CurSched != nil  && CurSched.IsMovingTask_Walk == true)) /*(VJ_HasValue(VJ_WalkActivites,self:GetMovementActivity()) or VJ_HasValue(self.CustomWalkActivites,self:GetMovementActivity()))*/ then
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
end
---------------------------------------------------------------------------------------------------------------------------------------------