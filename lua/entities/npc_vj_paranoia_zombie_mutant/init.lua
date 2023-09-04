AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_paranoia/zombie/zombie_fast.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 100
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
--ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.AnimTbl_IdleStand = {ACT_IDLE} -- The idle animation when AI is enabled
ENT.AnimTbl_Walk = {ACT_WALK} -- Set the walking animations | Put multiple to let the base pick a random animation when it moves
ENT.AnimTbl_Walk = {ACT_WALK} -- Set the walking animations | Put multiple to let the base pick a random animation when it moves
--ENT.MeleeAttackDistance = 32 -- How close does it have to be until it attacks?
--ENT.MeleeAttackDamageDistance = 60 -- How far does the damage go?
--ENT.MeleeAttackDamage = GetConVarNumber("vj_hme_zombie_dmg")
--ENT.TimeUntilMeleeAttackDamage = 1

ENT.DisableFootStepSoundTimer = true 

ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.HasDeathRagdoll = false -- If set to false, it will not spawn the regular ragdoll of the SNPC
ENT.WaitBeforeDeathTime = 60 -- Time until the SNPC spawns its corpse and gets removed
ENT.AnimTbl_Death = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIESIMPLE}

ENT.FootStepTimeRun = 1 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 1 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = false -- Set to true to use the extra melee attack sounds

ENT.AnimTbl_LeapAttack = {"leapstrike"} -- Melee Attack Animations
ENT.LeapDistance = 500 -- The distance of the leap, for example if it is set to 500, when the SNPC is 500 Unit away, it will jump
ENT.LeapToMeleeDistance = 100 -- How close does it have to be until it uses melee?
ENT.TimeUntilLeapAttackDamage = 0.2 -- How much time until it runs the leap damage code?
ENT.NextLeapAttackTime = 5 -- How much time until it can use a leap attack?
ENT.NextAnyAttackTime_Leap = 0.4 -- How much time until it can use any attack again? | Counted in Seconds
ENT.LeapAttackExtraTimers = {0.4,0.6,0.8,1,1.2,1.4,1.6,1.8,2} -- Extra leap attack timers | it will run the damage code after the given amount of seconds
ENT.TimeUntilLeapAttackVelocity = 0.2 -- How much time until it runs the velocity code?
ENT.LeapAttackVelocityForward = 500 -- How much forward force should it apply?
ENT.LeapAttackVelocityUp = 200 -- How much upward force should it apply?
ENT.LeapAttackDamage = 30
ENT.LeapAttackDamageDistance = 125 -- How far does the damage go?

ENT.GeneralSoundPitch1 = 120
ENT.GeneralSoundPitch2 = 110
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

ENT.SoundTbl_Idle = {""}
ENT.SoundTbl_Alert = {"vj_paranoia/npc/zombie/zo_alert10.wav","vj_paranoia/npc/zombie/zo_alert20.wav","vj_paranoia/npc/zombie/zo_alert30.wav"}
ENT.SoundTbl_CombatIdle = {"vj_paranoia/npc/zombie/zo_alert10.wav","vj_paranoia/npc/zombie/zo_alert20.wav","vj_paranoia/npc/zombie/zo_alert30.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_paranoia/npc/zombie/zo_attack1.wav","vj_paranoia/npc/zombie/zo_attack2.wav"}
ENT.SoundTbl_Pain = {"vj_paranoia/npc/zombie/zo_pain1.wav","vj_paranoia/npc/zombie/zo_pain2.wav"}
ENT.SoundTbl_Death = {"vj_paranoia/npc/zombie/zo_pain1.wav","vj_paranoia/npc/zombie/zo_pain2.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_paranoia/npc/zombie/claw_strike1.wav","vj_paranoia/npc/zombie/claw_strike2.wav","vj_paranoia/npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_paranoia/npc/zombie/claw_miss1.wav","vj_paranoia/npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_LeapAttackJump = {"vj_paranoia/npc/zombie/zo_attack1.wav","vj_paranoia/npc/zombie/zo_attack2.wav"}
ENT.SoundTbl_LeapAttackDamage = {"vj_paranoia/npc/zombie/claw_strike1.wav","vj_paranoia/npc/zombie/claw_strike2.wav","vj_paranoia/npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_LeapAttackDamageMiss = {"vj_paranoia/npc/zombie/claw_miss1.wav","vj_paranoia/npc/zombie/claw_miss2.wav"}

ENT.FootSteps = {
	[MAT_ANTLION] = {
		"physics/flesh/flesh_impact_hard1.wav",
		"physics/flesh/flesh_impact_hard2.wav",
		"physics/flesh/flesh_impact_hard3.wav",
		"physics/flesh/flesh_impact_hard4.wav",
		"physics/flesh/flesh_impact_hard5.wav",
		"physics/flesh/flesh_impact_hard6.wav",
	},
	[MAT_BLOODYFLESH] = {
		"physics/flesh/flesh_impact_hard1.wav",
		"physics/flesh/flesh_impact_hard2.wav",
		"physics/flesh/flesh_impact_hard3.wav",
		"physics/flesh/flesh_impact_hard4.wav",
		"physics/flesh/flesh_impact_hard5.wav",
		"physics/flesh/flesh_impact_hard6.wav",
	},
	[MAT_CONCRETE] = {
		"player/footsteps/concrete1.wav",
		"player/footsteps/concrete2.wav",
		"player/footsteps/concrete3.wav",
		"player/footsteps/concrete4.wav",
	},
	[MAT_DIRT] = {
		"player/footsteps/dirt1.wav",
		"player/footsteps/dirt2.wav",
		"player/footsteps/dirt3.wav",
		"player/footsteps/dirt4.wav",
	},
	[MAT_FLESH] = {
		"physics/flesh/flesh_impact_hard1.wav",
		"physics/flesh/flesh_impact_hard2.wav",
		"physics/flesh/flesh_impact_hard3.wav",
		"physics/flesh/flesh_impact_hard4.wav",
		"physics/flesh/flesh_impact_hard5.wav",
		"physics/flesh/flesh_impact_hard6.wav",
	},
	[MAT_GRATE] = {
		"player/footsteps/metalgrate1.wav",
		"player/footsteps/metalgrate2.wav",
		"player/footsteps/metalgrate3.wav",
		"player/footsteps/metalgrate4.wav",
	},
	[MAT_ALIENFLESH] = {
		"physics/flesh/flesh_impact_hard1.wav",
		"physics/flesh/flesh_impact_hard2.wav",
		"physics/flesh/flesh_impact_hard3.wav",
		"physics/flesh/flesh_impact_hard4.wav",
		"physics/flesh/flesh_impact_hard5.wav",
		"physics/flesh/flesh_impact_hard6.wav",
	},
	[74] = { -- Snow
		"player/footsteps/sand1.wav",
		"player/footsteps/sand2.wav",
		"player/footsteps/sand3.wav",
		"player/footsteps/sand4.wav",
	},
	[MAT_PLASTIC] = {
		"physics/plaster/drywall_footstep1.wav",
		"physics/plaster/drywall_footstep2.wav",
		"physics/plaster/drywall_footstep3.wav",
		"physics/plaster/drywall_footstep4.wav",
	},
	[MAT_METAL] = {
		"player/footsteps/metal1.wav",
		"player/footsteps/metal2.wav",
		"player/footsteps/metal3.wav",
		"player/footsteps/metal4.wav",
	},
	[MAT_SAND] = {
		"player/footsteps/sand1.wav",
		"player/footsteps/sand2.wav",
		"player/footsteps/sand3.wav",
		"player/footsteps/sand4.wav",
	},
	[MAT_FOLIAGE] = {
		"player/footsteps/grass1.wav",
		"player/footsteps/grass2.wav",
		"player/footsteps/grass3.wav",
		"player/footsteps/grass4.wav",
	},
	[MAT_COMPUTER] = {
		"physics/plaster/drywall_footstep1.wav",
		"physics/plaster/drywall_footstep2.wav",
		"physics/plaster/drywall_footstep3.wav",
		"physics/plaster/drywall_footstep4.wav",
	},
	[MAT_SLOSH] = {
		"player/footsteps/slosh1.wav",
		"player/footsteps/slosh2.wav",
		"player/footsteps/slosh3.wav",
		"player/footsteps/slosh4.wav",
	},
	[MAT_TILE] = {
		"player/footsteps/tile1.wav",
		"player/footsteps/tile2.wav",
		"player/footsteps/tile3.wav",
		"player/footsteps/tile4.wav",
	},
	[85] = { -- Grass
		"player/footsteps/grass1.wav",
		"player/footsteps/grass2.wav",
		"player/footsteps/grass3.wav",
		"player/footsteps/grass4.wav",
	},
	[MAT_VENT] = {
		"player/footsteps/duct1.wav",
		"player/footsteps/duct2.wav",
		"player/footsteps/duct3.wav",
		"player/footsteps/duct4.wav",
	},
	[MAT_WOOD] = {
		"player/footsteps/wood1.wav",
		"player/footsteps/wood2.wav",
		"player/footsteps/wood3.wav",
		"player/footsteps/wood4.wav",
		"player/footsteps/woodpanel1.wav",
		"player/footsteps/woodpanel2.wav",
		"player/footsteps/woodpanel3.wav",
		"player/footsteps/woodpanel4.wav",
	},
	[MAT_GLASS] = {
		"physics/glass/glass_sheet_step1.wav",
		"physics/glass/glass_sheet_step2.wav",
		"physics/glass/glass_sheet_step3.wav",
		"physics/glass/glass_sheet_step4.wav",
	}
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
		VJ_EmitSound(self,"player/footsteps/wade" .. math.random(1,8) .. ".wav",self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
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
function ENT:CustomOnInitialize()
	self:SetBodygroup(1,math.random(0,2))
	if GetConVar("vj_paranoia_mutzom_leap"):GetInt() == 1 then
       self.HasLeapAttack = true
	else
       self.HasLeapAttack = false
	end

	if GetConVar("vj_paranoia_mutzom_betarun"):GetInt() == 1 then
       self.AnimTbl_Run = {ACT_RUN_ANGRY}
	else
       self.AnimTbl_Run = {ACT_RUN}
	end

end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "step" then
		self:FootStepSoundCode()
	end
	if key == "hand" then
		VJ_EmitSound(self, "npc/fast_zombie/foot"..math.random(1, 4)..".wav", 70, 100)
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

if GetConVar("vj_paranoia_mutzom_frenzy"):GetInt() == 0 then

    local randattack = math.random(1,3)
	
	if randattack == 1 then
	    self.MeleeAttackDistance = 32 -- How close does it have to be until it attacks?
        self.MeleeAttackDamageDistance = 60 -- How far does the damage go?
        self.MeleeAttackDamage = 30
        self.TimeUntilMeleeAttackDamage = 0.5
		self.MeleeAttackReps = 1
		self.AnimTbl_MeleeAttack = {"vjseq_Attack_1"}
	
	elseif randattack == 2 then
	    self.MeleeAttackDistance = 32 -- How close does it have to be until it attacks?
        self.MeleeAttackDamageDistance = 60 -- How far does the damage go?
        self.MeleeAttackDamage = 30
        self.TimeUntilMeleeAttackDamage = 0.5
		self.MeleeAttackReps = 1
		self.AnimTbl_MeleeAttack = {"vjseq_Attack_2"}
		
	elseif randattack == 3 then
	    self.MeleeAttackDistance = 32 -- How close does it have to be until it attacks?
        self.MeleeAttackDamageDistance = 60 -- How far does the damage go?
        self.MeleeAttackDamage = 50
        self.TimeUntilMeleeAttackDamage = 0.5
		self.MeleeAttackReps = 0
		self.AnimTbl_MeleeAttack = {"vjseq_Attack_3"}
	end
else 

    local randattack = math.random(1,1)
	
	if randattack == 1 then
	    self.MeleeAttackDistance = 32 -- How close does it have to be until it attacks?
        self.MeleeAttackDamageDistance = 60 -- How far does the damage go?
        self.MeleeAttackDamage = 5
        self.TimeUntilMeleeAttackDamage = 0.1
		self.MeleeAttackReps = 2
		self.AnimTbl_MeleeAttack = {"vjseq_Attack"}
	end
end

end
-------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(argent)
	if math.random(1,3) == 1 then
		local tbl = VJ_PICK({"tantrum"})
		self:VJ_ACT_PLAYACTIVITY(tbl,true,VJ_GetSequenceDuration(self,tbl),false)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomDeathAnimationCode(dmginfo, hitgroup)
	if hitgroup == HITGROUP_HEAD then
		self.AnimTbl_Death = {ACT_DIE_HEADSHOT}
	else
		self.AnimTbl_Death = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIESIMPLE}
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/