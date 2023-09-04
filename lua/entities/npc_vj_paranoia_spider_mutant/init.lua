AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_paranoia/mutant/spider.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 750
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
--ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.AnimTbl_IdleStand = {ACT_IDLE} -- The idle animation when AI is enabled
ENT.AnimTbl_Walk = {ACT_WALK} -- Set the walking animations | Put multiple to let the base pick a random animation when it moves
ENT.AnimTbl_Run = {ACT_RUN} -- Set the running animations | Put multiple to let the base pick a random animation when it moves
--ENT.MeleeAttackDistance = 32 -- How close does it have to be until it attacks?
--ENT.MeleeAttackDamageDistance = 60 -- How far does the damage go?
--ENT.MeleeAttackDamage = GetConVarNumber("vj_hme_zombie_dmg")
--ENT.TimeUntilMeleeAttackDamage = 1

ENT.DisableFootStepSoundTimer = false 

ENT.FootStepTimeRun = 0.2 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.2 -- Next foot step sound when it is walking

ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.HasDeathRagdoll = false -- If set to false, it will not spawn the regular ragdoll of the SNPC
ENT.WaitBeforeDeathTime = 60 -- Time until the SNPC spawns its corpse and gets removed

ENT.HasExtraMeleeAttackSounds = false -- Set to true to use the extra melee attack sounds
ENT.GeneralSoundPitch1 = 120
ENT.GeneralSoundPitch2 = 110
ENT.MeleeAttackMissSoundPitch = VJ_Set(false, false)
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchChance = 6 -- Chance of it flinching from 1 to x | 1 will make it always flinch
ENT.AnimTbl_Flinch = {"ACT_BIG_FLINCH","ACT_SMALL_FLINCH"} -- If it uses normal based animation, use this
ENT.HitGroupFlinching_Values = {
	{HitGroup={HITGROUP_LEFTARM}, Animation={ACT_FLINCH_LEFTARM}},
	{HitGroup={HITGROUP_RIGHTARM}, Animation={ACT_FLINCH_RIGHTARM}}
}
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_paranoia/npc/spider/step_hand1.wav","vj_paranoia/npc/spider/step_hand2.wav","vj_paranoia/npc/spider/step_hand3.wav","vj_paranoia/npc/spider/step_hand4.wav"}

ENT.SoundTbl_Idle = {""}
ENT.SoundTbl_Alert = {"vj_paranoia/npc/spider/alert1.wav","vj_paranoia/npc/spider/alert2.wav","vj_paranoia/npc/spider/alert3.wav","vj_paranoia/npc/spider/alert4.wav"}
ENT.SoundTbl_CombatIdle = {"vj_paranoia/npc/spider/alert1.wav","vj_paranoia/npc/spider/alert2.wav","vj_paranoia/npc/spider/alert3.wav","vj_paranoia/npc/spider/alert4.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {""}
ENT.SoundTbl_Pain = {"vj_paranoia/npc/spider/pain1.wav","vj_paranoia/npc/spider/pain2.wav"}
ENT.SoundTbl_Death = {"vj_paranoia/npc/spider/alert1.wav","vj_paranoia/npc/spider/alert2.wav","vj_paranoia/npc/spider/alert3.wav","vj_paranoia/npc/spider/alert4.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_paranoia/npc/zombie/claw_strike1.wav","vj_paranoia/npc/zombie/claw_strike2.wav","vj_paranoia/npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_paranoia/npc/zombie/claw_miss1.wav","vj_paranoia/npc/zombie/claw_miss2.wav"}


---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFootStepSound()
	if !self:IsOnGround() then return end
	local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() +Vector(0,0,-150),
		filter = {self}
	})
	if self:WaterLevel() > 0 && self:WaterLevel() < 3 then
		VJ_EmitSound(self,"player/footsteps/wade" .. math.random(1,8) .. ".wav",self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetSkin(math.random(0,10))
	-- self:SetCollisionBounds(Vector(13,13,60), Vector(-13,-13,0))|
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "step" then
		self:FootStepSoundCode()
	end
	if key == "bodyfall" then
		VJ_EmitSound(self, "vj_paranoia/npc/shared/bodydrop"..math.random(1, 4)..".wav", 75, 100)
	end
    if key == "bodyknee" then
		VJ_EmitSound(self, "vj_paranoia/npc/shared/body_knee.wav", 75, 100)
	end
	if key == "bodyroll" then
		VJ_EmitSound(self, "vj_paranoia/npc/shared/body_roll.wav", 75, 100)
	end
	if key == "scuff" then
		VJ_EmitSound(self, "vj_contamination/universal/scuff"..math.random(1,6)..".wav", 70, 100)
    end	
    if key == "bodyfall" && self:WaterLevel() > 0 && self:WaterLevel() < 3 then
       VJ_EmitSound(self,"player/footsteps/slosh" .. math.random(1,4) .. ".wav",self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnIsJumpLegal(startPos,apex,endPos) 
return false
end -- Return nothing to let base decide, return true to make it jump, return false to disallow jumping
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleMeleeAttacks()
    local randattack = math.random(1,2)
	if randattack == 1 then
	    self.MeleeAttackDistance = 42 -- How close does it have to be until it attacks?
        self.MeleeAttackDamageDistance = 72 -- How far does the damage go?
        self.MeleeAttackDamage = 20
        self.TimeUntilMeleeAttackDamage = 0.5
		self.MeleeAttackReps = 1
		self.AnimTbl_MeleeAttack = {"vjseq_Attack1"}
	    self.SoundTbl_MeleeAttack = {"vj_paranoia/npc/spider/hit1.wav","vj_paranoia/npc/spider/hit2.wav","vj_paranoia/npc/spider/hit3.wav"}
        self.SoundTbl_MeleeAttackMiss = {"vj_paranoia/npc/spider/miss1.wav","vj_paranoia/npc/spider/miss2.wav"}
	
	elseif randattack == 2 then
	    self.MeleeAttackDistance = 70 -- How close does it have to be until it attacks?
        self.MeleeAttackDamageDistance = 90 -- How far does the damage go?
        self.MeleeAttackDamage = 30
        self.TimeUntilMeleeAttackDamage = 0.5
		self.MeleeAttackReps = 1
		self.AnimTbl_MeleeAttack = {"vjseq_Attack2","vjseq_Attack3"}
		self.SoundTbl_MeleeAttack = {"ambient/machines/slicer1.wav","ambient/machines/slicer2.wav","ambient/machines/slicer3.wav","ambient/machines/slicer4.wav"}
        self.SoundTbl_MeleeAttackMiss = {"vj_paranoia/npc/zombie/claw_miss1.wav","vj_paranoia/npc/zombie/claw_miss2.wav"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomDeathAnimationCode(dmginfo, hitgroup)
	if hitgroup == HITGROUP_HEAD then
		self.AnimTbl_Death = {ACT_DIE_GUTSHOT, ACT_DIE_HEADSHOT}
	else
		self.AnimTbl_Death = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIESIMPLE}
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/