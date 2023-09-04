AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_paranoia/zombie/zombie_alpha.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 150

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnBloodParticles(dmginfo,hitgroup)
	if hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM or hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
		local p_name = VJ_PICK(self.CustomBlood_Particle)
		if p_name == false then return end
		
		local dmg_pos = dmginfo:GetDamagePosition()
		if dmg_pos == Vector(0,0,0) then dmg_pos = self:GetPos() + self:OBBCenter() end
		
		local spawnparticle = ents.Create("info_particle_system")
		spawnparticle:SetKeyValue("effect_name",p_name)
		spawnparticle:SetPos(dmg_pos)
		spawnparticle:Spawn()
		spawnparticle:Activate()
		spawnparticle:Fire("Start","",0)
		spawnparticle:Fire("Kill","",0.1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	if hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM or hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then return end
	if (dmginfo:IsBulletDamage()) then
		local attacker = dmginfo:GetAttacker()
		self.DamageSpark1 = ents.Create("env_spark")
		self.DamageSpark1:SetKeyValue("Magnitude","1")
		self.DamageSpark1:SetKeyValue("Spark Trail Length","1")
		self.DamageSpark1:SetPos(dmginfo:GetDamagePosition())
		self.DamageSpark1:SetAngles(self:GetAngles())
		//self.DamageSpark1:Fire("LightColor", "255 255 255")
		self.DamageSpark1:SetParent(self)
		self.DamageSpark1:Spawn()
		self.DamageSpark1:Activate()
		self.DamageSpark1:Fire("StartSpark", "", 0)
		self.DamageSpark1:Fire("StopSpark", "", 0.001)
		self:DeleteOnRemove(self.DamageSpark1)
	end
	if self.HasSounds == true && self.HasImpactSounds == true then VJ_EmitSound(self,"vj_impact_metal/bullet_metal/metalsolid"..math.random(1,10)..".wav",70) end
	dmginfo:ScaleDamage(0.25)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/