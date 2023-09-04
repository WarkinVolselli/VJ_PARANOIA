AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_paranoia/zombie/zombie_hazmat.mdl","models/vj_paranoia/zombie/zombie_hazmat.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want

ENT.SoundTbl_Breath = {"vj_paranoia/npc/hazmat/rebreather_01.wav","vj_paranoia/npc/hazmat/rebreather_02.wav","vj_paranoia/npc/hazmat/rebreather_03.wav","vj_paranoia/npc/hazmat/rebreather_04.wav","vj_paranoia/npc/hazmat/rebreather_05.wav"}
ENT.SoundTbl_Idle = {"vj_paranoia/npc/hazmat/chatter_01.wav","vj_paranoia/npc/hazmat/chatter_02.wav","vj_paranoia/npc/hazmat/chatter_03.wav"}
ENT.SoundTbl_Alert = {"vj_paranoia/npc/hazmat/sight_01.wav","vj_paranoia/npc/hazmat/sight_02.wav","vj_paranoia/npc/hazmat/sight_03.wav","vj_paranoia/npc/hazmat/sight_04.wav"}
ENT.SoundTbl_CombatIdle = {"vj_paranoia/npc/hazmat/chatter_combat_01.wav","vj_paranoia/npc/hazmat/chatter_combat_02.wav","vj_paranoia/npc/hazmat/chatter_combat_03.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_paranoia/npc/hazmat/attack_01.wav","vj_paranoia/npc/hazmat/attack_02.wav","vj_paranoia/npc/hazmat/attack_03.wav","vj_paranoia/npc/hazmat/attack_04.wav"}
ENT.SoundTbl_Pain = {"vj_paranoia/npc/hazmat/pain_01.wav","vj_paranoia/npc/hazmat/pain_02.wav","vj_paranoia/npc/hazmat/pain_03.wav","vj_paranoia/npc/hazmat/pain_04.wav","vj_paranoia/npc/hazmat/pain_05.wav"}
ENT.SoundTbl_Death = {"vj_paranoia/npc/hazmat/death_01.wav","vj_paranoia/npc/hazmat/death_03.wav","vj_paranoia/npc/hazmat/death_04.wav"}

/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/