AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_paranoia/zombie/zombie_c.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 200
ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How does the SNPC move?
ENT.CanTurnWhileStationary = false -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
ENT.HullType = HULL_SMALL_CENTERED
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
--ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.AnimTbl_IdleStand = {ACT_IDLE} -- The idle animation when AI is enabled
ENT.AnimTbl_Walk = {ACT_WALK} -- Set the walking animations | Put multiple to let the base pick a random animation when it moves
ENT.AnimTbl_Run = {ACT_WALK} -- Set the running animations | Put multiple to let the base pick a random animation when it moves
--ENT.MeleeAttackDistance = 32 -- How close does it have to be until it attacks?
--ENT.MeleeAttackDamageDistance = 60 -- How far does the damage go?
--ENT.MeleeAttackDamage = GetConVarNumber("vj_hme_zombie_dmg")
--ENT.TimeUntilMeleeAttackDamage = 1

ENT.DisableFootStepSoundTimer = true 

ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.HasDeathRagdoll = false -- If set to false, it will not spawn the regular ragdoll of the SNPC
ENT.WaitBeforeDeathTime = 60 -- Time until the SNPC spawns its corpse and gets removed

ENT.FootStepTimeRun = 1 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 1 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = false -- Set to true to use the extra melee attack sounds

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.RangeUseAttachmentForPos = false -- Should the projectile spawn on a attachment?
ENT.AnimTbl_RangeAttack = {"vjseq_attack1","vjseq_attack2"} -- Range Attack Animations
ENT.RangeAttackEntityToSpawn = "obj_vj_projectinfection_spit" -- The entity that is spawned when range attacking
ENT.RangeDistance = 2000 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 60 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = 0.5 -- How much time until the projectile code is ran?
ENT.NextRangeAttackTime = 2.5 -- How much time until it can use a range attack?
ENT.Immune_AcidPoisonRadiation = true -- Makes the SNPC not get damage from Acid, posion, radiation
ENT.RangeAttackPos_Up = 45 -- Up/Down spawning position for range attack
ENT.RangeAttackPos_Forward = 32 -- Forward/Backward spawning position for range attack
ENT.RangeAttackPos_Right = 0 -- Right/Left spawning position for range attack
ENT.RangeAttackExtraTimers = {0.55, 0.6} -- Extra range attack timers | it will run the projectile code after the given amount of seconds

ENT.GeneralSoundPitch1 = 100
ENT.GeneralSoundPitch2 = 90
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchChance = 4 -- Chance of it flinching from 1 to x | 1 will make it always flinch
ENT.AnimTbl_Flinch = {"ACT_BIG_FLINCH","ACT_SMALL_FLINCH"} -- If it uses normal based animation, use this
ENT.HitGroupFlinching_Values = {
	{HitGroup={HITGROUP_LEFTARM}, Animation={ACT_FLINCH_LEFTARM}},
	{HitGroup={HITGROUP_LEFTLEG}, Animation={ACT_FLINCH_LEFTLEG}},
	{HitGroup={HITGROUP_RIGHTARM}, Animation={ACT_FLINCH_RIGHTARM}},
	{HitGroup={HITGROUP_RIGHTLEG}, Animation={ACT_FLINCH_RIGHTLEG}}

}
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"npc/zombie/foot1.wav","npc/zombie/foot2.wav","npc/zombie/foot3.wav"}

ENT.SoundTbl_Idle = {"vj_paranoia/npc/creeper/idle1.mp3","vj_paranoia/npc/creeper/idle2.mp3","vj_paranoia/npc/creeper/idle3.mp3","vj_paranoia/npc/creeper/idle4.mp3","vj_paranoia/npc/creeper/idle5.mp3","vj_paranoia/npc/creeper/idle6.mp3"}
ENT.SoundTbl_Alert = {"vj_paranoia/npc/creeper/super_puker_70.wav","vj_paranoia/npc/creeper/super_puker_71.wav","vj_paranoia/npc/creeper/super_puker_72.wav","vj_paranoia/npc/creeper/super_puker_73.wav"}
ENT.SoundTbl_CombatIdle = {"vj_paranoia/npc/creeper/alert1.mp3","vj_paranoia/npc/creeper/alert2.mp3","vj_paranoia/npc/creeper/alert3.mp3","vj_paranoia/npc/creeper/alert4.mp3"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_paranoia/npc/creeper/pain1.mp3","vj_paranoia/npc/creeper/pain2.mp3","vj_paranoia/npc/creeper/pain3.mp3","vj_paranoia/npc/creeper/pain4.mp3","vj_paranoia/npc/creeper/pain5.mp3"}
ENT.SoundTbl_RangeAttack = {"vj_paranoia/npc/creeper/rangeattack1.mp3"}
ENT.SoundTbl_Pain = {"vj_paranoia/npc/creeper/pain1.mp3","vj_paranoia/npc/creeper/pain2.mp3","vj_paranoia/npc/creeper/pain3.mp3","vj_paranoia/npc/creeper/pain4.mp3","vj_paranoia/npc/creeper/pain5.mp3"}
ENT.SoundTbl_Death = {"vj_paranoia/npc/creeper/death1.mp3","vj_paranoia/npc/creeper/death2.mp3","vj_paranoia/npc/creeper/death3.mp3","vj_paranoia/npc/creeper/death4.mp3","vj_paranoia/npc/creeper/death5.mp3"}
ENT.SoundTbl_MeleeAttack = {"ambient/machines/slicer1.wav","ambient/machines/slicer2.wav","ambient/machines/slicer3.wav","ambient/machines/slicer4.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_paranoia/npc/creeper/attack1.mp3","vj_paranoia/npc/creeper/attack2.mp3","vj_paranoia/npc/creeper/attack3.mp3"}

function ENT:CustomOnInitialize()
    self:SetCollisionBounds(Vector(20,20,125), Vector(-10,-10,0))
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
    local randattack = math.random(1,1)
	if randattack == 1 then
	    self.MeleeAttackDistance = 32 -- How close does it have to be until it attacks?
        self.MeleeAttackDamageDistance = 60 -- How far does the damage go?
        self.MeleeAttackDamage = 40
        self.TimeUntilMeleeAttackDamage = 0.8
		self.MeleeAttackReps = 1
		self.AnimTbl_MeleeAttack = {"vjseq_attack3"}
	end
end
-------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(argent)
	if math.random(1,3) == 1 then
		local tbl = VJ_PICK({"bigflinch"})
		self:VJ_ACT_PLAYACTIVITY(tbl,true,VJ_GetSequenceDuration(self,tbl),false)
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialKilled(dmginfo, hitgroup) 
	timer.Simple(0.5,function()
    self:DoChangeMovementType(VJ_MOVETYPE_GROUND)
	self:SetCollisionBounds(Vector(0,0,0), Vector(0,0,0))
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(projectile)
	local enemy = self:GetEnemy()
	return self:CalculateProjectile("Curve", projectile:GetPos(), enemy:GetPos() + enemy:OBBCenter(), 1500)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/