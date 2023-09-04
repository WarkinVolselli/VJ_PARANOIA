/* Note: All credits go to Cpt. Hazama. I take no credit for this. */
AddCSLuaFile("shared.lua")
include('shared.lua')

local table_insert = table.insert
local table_remove = table.remove

ENT.Zombie = {
	{class="npc_vj_paranoia_zombie_citizen",chance=1},
	{class="npc_vj_paranoia_zombie",chance=2},
	{class="npc_vj_paranoia_zombie_clone",chance=2},
	{class="npc_vj_paranoia_zombie_hazmat",chance=4},
	{class="npc_vj_paranoia_zombie_alpha",chance=6},
	{class="npc_vj_paranoia_zombie_mutant",chance=4},
	{class="npc_vj_paranoia_zombie_heavy",chance=6},
}

ENT.SpecialZombie = {
	{class="npc_vj_paranoia_spider_mutant",max=2},
--	{class="npc_vj_paranoia_beast_mutant",max=1},
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	local i = 0
	for k, v in ipairs(ents.GetAll()) do
		if v:GetClass() == "sent_vj_paranoia_mapspawner" then
			i = i + 1
			if i > 1 then PrintMessage(HUD_PRINTTALK, "Only one Map Spawner is allowed on the map.") self.SkipOnRemove = true self:Remove() return end
		end
	end
	
	self.nodePositions = {}
	self.navAreas = {}
	
	for _,pos in pairs(VJ_Paranoia_NODEPOS) do
		if pos then table_insert(self.nodePositions,{Position = pos, Time = 0}) end
	end

	for _,nav in pairs(navmesh.GetAllNavAreas()) do
		if nav then table_insert(self.navAreas,nav) end
	end

	local count = #self.nodePositions +#self.navAreas
	if count <= 50 then
		local msg = "Low node/nav-area count detected! The Map Spawner may find it difficult to process with such low nodes/nav-areas...removing..."
		if count <= 0 then
			msg = "No nodes or nav-mesh detected! The Map Spawner relies on nodes/nav-areas for many things. Without any, the Map Spawner will not work! The Map Spawner will now remove itself..."
		end
		MsgN(msg)
		if IsValid(self:GetCreator()) then
			self:GetCreator():ChatPrint(msg)
		end
		SafeRemoveEntity(self)
		return
	end

	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:SetPos(Vector(0, 0, 0))
	self:SetNoDraw(true)
	self:DrawShadow(false)
	
	self.IsActivated = tobool(GetConVarNumber("VJ_Paranoia_MapSpawner_Enabled"))
	self.Paranoia_SpawnDistance = GetConVarNumber("VJ_Paranoia_MapSpawner_SpawnMax")
	self.Paranoia_SpawnDistanceClose = GetConVarNumber("VJ_Paranoia_MapSpawner_SpawnMin")
	self.Paranoia_HordeChance = GetConVarNumber("VJ_Paranoia_MapSpawner_HordeChance")
	self.Paranoia_HordeCooldownMin = GetConVarNumber("VJ_Paranoia_MapSpawner_HordeCooldownMin")
	self.Paranoia_HordeCooldownMax = GetConVarNumber("VJ_Paranoia_MapSpawner_HordeCooldownMax")
	self.Paranoia_MaxZombie = GetConVarNumber("VJ_Paranoia_MapSpawner_MaxZom")
	self.Paranoia_MaxHordeSpawn = GetConVarNumber("VJ_Paranoia_MapSpawner_HordeCount")
	self.tbl_SpawnedNPCs = {}
	self.tbl_NPCsWithEnemies = {}
	self.tbl_SpawnedSpecialZombie = {}
	self.NextAICheckTime = CurTime() +5
	self.NextZombieSpawnTime = CurTime() +1
	self.NextSpecialZombieSpawnTime = CurTime() +math.random(4,20)
	self.NextHordeSpawnTime = CurTime() +math.Rand(self.Paranoia_HordeCooldownMin,self.Paranoia_HordeCooldownMax)
	self.NextAIBossCheckTime = CurTime() +5
	self.HordeSpawnRate = 0.19
	self.MaxSpecialZombie = 15
	self.CanSpawnSpecialZombie = true 

 local Ambience = {"vj_Paranoia/npc/misc/distant_horde_loop.wav"}
 local Music = {"vj_paranoia/music/track03.mp3","vj_paranoia/music/track04.mp3","vj_paranoia/music/track08.mp3","vj_paranoia/music/track10.mp3","vj_paranoia/music/track14.mp3","vj_paranoia/music/track21.mp3","vj_paranoia/music/track23.mp3","vj_paranoia/music/track24.mp3","vj_paranoia/music/track25.mp3"}
	for _,v in ipairs(player.GetAll()) do
     if GetConVarNumber("VJ_Paranoia_MapSpawner_Ambient") == 1 then 	 			
             self.Paranoia_Ambience = VJ_CreateSound(v,Ambience,GetConVarNumber("VJ_Paranoia_MapSpawner_AmbienceVolume"), 100)
end			 
     if GetConVarNumber("VJ_Paranoia_MapSpawner_Music") == 1 then
             self.Paranoia_Music = VJ_CreateSound(v,Music,GetConVarNumber("VJ_Paranoia_MapSpawner_MusicVolume"), 100)    			 
		end	
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CheckVisibility(pos,ent,mdl)
	local check = ents.Create("prop_vj_animatable")
	check:SetModel(mdl or "models/barney.mdl")
	check:SetPos(pos)
	check:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	check:Spawn()
	check:SetNoDraw(true)
	check:DrawShadow(false)
	self:DeleteOnRemove(check)
	timer.Simple(0,function()
		SafeRemoveEntity(check)
	end)

	return ent:Visible(check)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindCenterNavPoint(ent)
	for _,v in RandomPairs(self.navAreas) do
		local testPos = v:GetCenter()
		local dist = testPos:Distance(ent:GetPos())
		if dist <= self.Paranoia_SpawnDistance && dist >= self.Paranoia_SpawnDistanceClose && !self:CheckVisibility(testPos,ent) then
			return testPos
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindHiddenNavPoint(ent)
	for _,v in RandomPairs(self.navAreas) do
		local hidingSpots = v:GetHidingSpots()
		if !hidingSpots then continue end
		if #hidingSpots <= 0 then continue end
		local testPos = VJ_PICK(hidingSpots)
		local dist = testPos:Distance(ent:GetPos())
		if dist <= self.Paranoia_SpawnDistance && dist >= self.Paranoia_SpawnDistanceClose && !self:CheckVisibility(testPos,ent) then
			return testPos
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindRandomNavPoint(ent)
	for _,v in RandomPairs(self.navAreas) do
		local testPos = v:GetRandomPoint()
		local dist = testPos:Distance(ent:GetPos())
		if dist <= self.Paranoia_SpawnDistance && dist >= self.Paranoia_SpawnDistanceClose && !self:CheckVisibility(testPos,ent) then
			return testPos
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetClosestNavPosition(ent,getHidden)
	local pos = false
	local closestDist = 999999999
	for i,v in pairs(self.navAreas) do
		local hidingSpots = getHidden && v:GetHidingSpots() or true
		if !hidingSpots then continue end
		if istable(hidingSpots) && #hidingSpots <= 0 then continue end
		local testPos = getHidden && VJ_PICK(v:GetHidingSpots()) or v:GetRandomPoint()
		local dist = ent:GetPos():Distance(testPos)
		if dist < closestDist && (dist <= self.Paranoia_SpawnDistance && dist >= self.Paranoia_SpawnDistanceClose && !self:CheckVisibility(testPos,ent)) then
			closestDist = dist
			pos = testPos
		end
	end
	return pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetClosestNodePosition(ent)
	local pos = false
	local closestDist = 999999999
	for i,v in pairs(self.nodePositions) do
		if !self:IsNodeUsable(i) then continue end
		local testPos = self:GetNodePosition(i)
		local dist = ent:GetPos():Distance(testPos)
		if dist < closestDist && (dist <= self.Paranoia_SpawnDistance && dist >= self.Paranoia_SpawnDistanceClose && !self:CheckVisibility(testPos,ent)) then
			closestDist = dist
			pos = testPos
		end
	end
	return pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindRandomNodePosition(ent)
	for i,v in RandomPairs(self.nodePositions) do
		if !self:IsNodeUsable(i) then continue end
		local testPos = self:GetNodePosition(i)
		local dist = ent && testPos:Distance(ent:GetPos()) or 0
		if ent then
			return testPos
		else
			if dist <= self.Paranoia_SpawnDistance && dist >= self.Paranoia_SpawnDistanceClose && !self:CheckVisibility(testPos,ent) then
				return testPos
			end
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindSpawnPosition(getClosest,findHidden)
	local nodes = self.nodePositions
	local navareas = self.navAreas
	local useNav = (#nodes <= 0 && #navareas > 0) or (#navareas > 0 && #nodes > 0 && math.random(1,2) == 1) or false
	local pos = false
	
	if useNav then
		local getHidden = findHidden or math.random(1,3) == 1
		local testEnt = self:GetRandomEnemy()
		pos = getClosest && self:GetClosestNavPosition(testEnt,getHidden) or getHidden && self:FindHiddenNavPoint(testEnt) or self:FindRandomNavPoint(testEnt)
	else
		local testEnt = self:GetRandomEnemy()
		pos = getClosest && self:GetClosestNodePosition(testEnt) or self:FindRandomNodePosition(testEnt)
	end
	return pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetNodePosition(i)
	return self.nodePositions[i].Position
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsNodeUsable(i)
	return self.nodePositions[i].Time < CurTime()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindEnemy()
	local tbl = {}
	for _,v in pairs(ents.GetAll()) do
		if (v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0 || v:IsNPC()) && v:Health() > 0 && !v:IsFlagSet(65536) && (v.VJ_NPC_Class && !VJ_HasValue(v.VJ_NPC_Class,"CLASS_ZOMBIE") or true) then
			table_insert(tbl,v)
		end
	end
	return tbl
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetRandomEnemy()
	return VJ_PICK(self:FindEnemy())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetClosestEnemy(pos)
	local ent = NULL
	local closestDist = 999999999
	for _,v in pairs(self:FindEnemy()) do
		local dist = v:GetPos():Distance(pos)
		if dist < closestDist then
			closestDist = dist
			ent = v
		end
	end
	return ent
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CheckEnemyDistance(ent,remove)
	local remove = remove or true
	local closestDist = 999999999
	local visible = false
	for _,v in pairs(self:FindEnemy()) do
		local dist = v:GetPos():Distance(ent:GetPos())
		if dist < closestDist then
			closestDist = dist
		end
		if v:Visible(ent) then
			visible = true -- Visible to someone, don't bother removing
		end
	end
	if closestDist >= GetConVarNumber("VJ_Paranoia_MapSpawner_SpawnMax") +1000 && !visible && !remove then
		SafeRemoveEntity(ent)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	self.IsActivated = GetConVar("VJ_Paranoia_MapSpawner_Enabled")
	if self.IsActivated then 
		-- Manage ConVar data
	    self.Paranoia_SpawnDistance = GetConVarNumber("VJ_Paranoia_MapSpawner_SpawnMax")
	    self.Paranoia_SpawnDistanceClose = GetConVarNumber("VJ_Paranoia_MapSpawner_SpawnMin")
	    self.Paranoia_HordeChance = GetConVarNumber("VJ_Paranoia_MapSpawner_HordeChance")
	    self.Paranoia_HordeCooldownMin = GetConVarNumber("VJ_Paranoia_MapSpawner_HordeCooldownMin")
	    self.Paranoia_HordeCooldownMax = GetConVarNumber("VJ_Paranoia_MapSpawner_HordeCooldownMax")
	    self.Paranoia_MaxZombie = GetConVarNumber("VJ_Paranoia_MapSpawner_MaxZom")
	    self.Paranoia_MaxHordeSpawn = GetConVarNumber("VJ_Paranoia_MapSpawner_HordeCount")
		self.AI_RefreshTime = GetConVarNumber("VJ_Paranoia_MapSpawner_RefreshRate") 
		
		-- Checks for inactive AI, this code is quite bulky and might be able to be optimized better
		if CurTime() > self.NextAICheckTime then
			if #self.tbl_SpawnedNPCs > 0 then
				for i,v in ipairs(self.tbl_SpawnedNPCs) do
					if IsValid(v) then
						local enemy = v:GetEnemy()
						self:CheckEnemyDistance(v)
						if IsValid(enemy) && !VJ_HasValue(self.tbl_NPCsWithEnemies,v) then
							table_insert(self.tbl_NPCsWithEnemies,v)
						elseif !IsValid(enemy) then
							if VJ_HasValue(self.tbl_NPCsWithEnemies,v) then
								table_remove(self.tbl_NPCsWithEnemies,i)
							end
						end
					else
						table_remove(self.tbl_SpawnedNPCs,i)
					end
				end
			end
			if #self.tbl_SpawnedSpecialZombie > 0 then
				for i,v in ipairs(self.tbl_SpawnedSpecialZombie) do
					if IsValid(v) then
						local enemy = v:GetEnemy()
						self:CheckEnemyDistance(v)
						if IsValid(enemy) && !VJ_HasValue(self.tbl_NPCsWithEnemies,v) then
							table_insert(self.tbl_NPCsWithEnemies,v)
						elseif !IsValid(enemy) then
							if VJ_HasValue(self.tbl_NPCsWithEnemies,v) then
								table_remove(self.tbl_NPCsWithEnemies,i)
							end	
						end
					else
						table_remove(self.tbl_SpawnedSpecialZombie,i)
					end
				end
			end
			self.NextAICheckTime = CurTime() +5
		end

		-- Spawns AI		
		if CurTime() > self.NextZombieSpawnTime then
			if #self.tbl_SpawnedNPCs >= self.Paranoia_MaxZombie -self.Paranoia_MaxHordeSpawn then return end -- Makes sure that we can at least spawn a mob when it's time
			self:SpawnZombie(self:PickZombie(self.Zombie),self:FindSpawnPosition(false))				
			self.NextZombieSpawnTime = CurTime() +math.Rand(GetConVarNumber("VJ_Paranoia_MapSpawner_DelayMin"),GetConVarNumber("VJ_Paranoia_MapSpawner_DelayMax"))	
end

			if CurTime() > self.NextSpecialZombieSpawnTime then
				self:SpawnSpecialZombie(self:PickZombie(self.SpecialZombie),self:FindSpawnPosition(true))
				self.NextSpecialZombieSpawnTime = CurTime() +math.Rand(4,20)			
end		
		-- Spawns Hordes
		if CurTime() > self.NextHordeSpawnTime && math.random(1,self.Paranoia_HordeChance) == 1 then
			for i = 1,self.Paranoia_MaxHordeSpawn do
				timer.Simple(self.HordeSpawnRate *i,function() -- Help with lag when spawning
					if IsValid(self) then
						self:SpawnZombie(self:PickZombie(self.Zombie),self:FindSpawnPosition(true,true),true)						
					end
				end)
			end
			self.NextHordeSpawnTime = CurTime() +math.Rand(self.Paranoia_HordeCooldownMin,self.Paranoia_HordeCooldownMax)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetBossCount(class)
	local count = 0
	for _,v in pairs(self.tbl_SpawnedSpecialZombie) do
		if IsValid(v) && v:GetClass() == class then
			count = count +1
		end
	end
	return count
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PickZombie(tbl)
	local useMax = tbl == self.SpecialZombie
	local ent = false
	for _,v in RandomPairs(tbl) do
		if !useMax then
			if math.random(1,v.chance) == 1 then
				ent = v.class
				break
			end
		else
			if self:GetBossCount(v.class) < v.max then
				ent = v.class
				break
			end
		end
	end
	return ent
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnZombie(ent,pos,isMob)
	if ent == false then return end
	if pos == nil or pos == false then return end
	if #self.tbl_SpawnedNPCs >= self.Paranoia_MaxZombie then return end
	local Zombie = ents.Create(ent)
	Zombie:SetPos(pos)
	Zombie:SetAngles(Angle(0,math.random(0,360),0))
	Zombie:Spawn()
	table_insert(self.tbl_SpawnedNPCs,Zombie)
	if isMob then
		Zombie.FindEnemy_UseSphere = true
		Zombie.FindEnemy_CanSeeThroughWalls = true
		Zombie:DrawShadow(false)
		timer.Simple(0,function()
			if IsValid(Zombie) then
				Zombie:DrawShadow(false)
			end
		end)
	end
	Zombie.MapSpawner = self
	Zombie.EntitiesToNoCollide = {}
	for _,v in pairs(self.Zombie) do
		table_insert(Zombie.EntitiesToNoCollide,v.class)
end		
	for _,v in pairs(self.SpecialZombie) do
		table_insert(Zombie.EntitiesToNoCollide,v.class)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnHL1Zombie(ent,pos,isMob)
    if GetConVarNumber("VJ_Paranoia_MapSpawner_HL1") then return end
	if ent == false then return end
	if pos == nil or pos == false then return end
	if #self.tbl_SpawnedNPCs >= self.Paranoia_MaxZombie then return end
	local HL1_Zombie = ents.Create(ent)
	HL1_Zombie:SetPos(pos)
	HL1_Zombie:SetAngles(Angle(0,math.random(0,360),0))
	HL1_Zombie:Spawn()
	table_insert(self.tbl_SpawnedNPCs,HL1_Zombie)
	if isMob then
		HL1_Zombie.FindEnemy_UseSphere = true
		HL1_Zombie.FindEnemy_CanSeeThroughWalls = true
		HL1_Zombie:DrawShadow(false)
		timer.Simple(0,function()
			if IsValid(HL1_Zombie) then
				HL1_Zombie:DrawShadow(false)
			end
		end)
	end
	HL1_Zombie.MapSpawner = self
	HL1_Zombie.EntitiesToNoCollide = {}
	for _,v in pairs(self.HL1Zombie) do
		table_insert(HL1_Zombie.EntitiesToNoCollide,v.class)
   end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnCSSZombie(ent,pos,isMob)
    if GetConVarNumber("VJ_Paranoia_MapSpawner_CSS") == 0 then return end
	if ent == false then return end
	if pos == nil or pos == false then return end
	if #self.tbl_SpawnedNPCs >= self.Paranoia_MaxZombie then return end
	local CSSZombie = ents.Create(ent)
	CSSZombie:SetPos(pos)
	CSSZombie:SetAngles(Angle(0,math.random(0,360),0))
	CSSZombie:Spawn()
	table_insert(self.tbl_SpawnedNPCs,CSSZombie)
	if isMob then
		CSSZombie.FindEnemy_UseSphere = true
		CSSZombie.FindEnemy_CanSeeThroughWalls = true
		CSSZombie:DrawShadow(false)
		timer.Simple(0,function()
			if IsValid(CSSZombie) then
				CSSZombie:DrawShadow(false)
			end
		end)
	end
	CSSZombie.MapSpawner = self
	CSSZombie.EntitiesToNoCollide = {}
	for _,v in pairs(self.CSSZombie) do
		table_insert(CSSZombie.EntitiesToNoCollide,v.class)
   end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnTF2Zombie(ent,pos,isMob)
    if GetConVarNumber("VJ_Paranoia_MapSpawner_TF2") == 0 then return end
	if ent == false then return end
	if pos == nil or pos == false then return end
	if #self.tbl_SpawnedNPCs >= self.Paranoia_MaxZombie then return end
	local TF2Zombie = ents.Create(ent)
	TF2Zombie:SetPos(pos)
	TF2Zombie:SetAngles(Angle(0,math.random(0,360),0))
	TF2Zombie:Spawn()
	table_insert(self.tbl_SpawnedNPCs,TF2Zombie)
	if isMob then
		TF2Zombie.FindEnemy_UseSphere = true
		TF2Zombie.FindEnemy_CanSeeThroughWalls = true
		TF2Zombie:DrawShadow(false)
		timer.Simple(0,function()
			if IsValid(TF2Zombie) then
				TF2Zombie:DrawShadow(false)
			end
		end)
	end
	TF2Zombie.MapSpawner = self
	TF2Zombie.EntitiesToNoCollide = {}
	for _,v in pairs(self.TF2Zombie) do
		table_insert(TF2Zombie.EntitiesToNoCollide,v.class)
   end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnL4DZombie(ent,pos,isMob)
    if GetConVarNumber("VJ_Paranoia_MapSpawner_L4D") == 0 then return end
	if ent == false then return end
	if pos == nil or pos == false then return end
	if #self.tbl_SpawnedNPCs >= self.Paranoia_MaxZombie then return end
	local L4D_Zombie = ents.Create(ent)
	L4D_Zombie:SetPos(pos)
	L4D_Zombie:SetAngles(Angle(0,math.random(0,360),0))
	L4D_Zombie:Spawn()
	table_insert(self.tbl_SpawnedNPCs,L4D_Zombie)
	if isMob then
		L4D_Zombie.FindEnemy_UseSphere = true
		L4D_Zombie.FindEnemy_CanSeeThroughWalls = true
		L4D_Zombie:DrawShadow(false)
		timer.Simple(0,function()
			if IsValid(L4D_Zombie) then
				L4D_Zombie:DrawShadow(false)
			end
		end)
	end
	L4D_Zombie.MapSpawner = self
	L4D_Zombie.EntitiesToNoCollide = {}
	for _,v in pairs(self.L4DZombie) do
		table_insert(L4D_Zombie.EntitiesToNoCollide,v.class)
   end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnExtraZombie(ent,pos,isMob)
    if GetConVarNumber("VJ_Paranoia_MapSpawner_Extras") == 0 then return end
	if ent == false then return end
	if pos == nil or pos == false then return end
	if #self.tbl_SpawnedNPCs >= self.Paranoia_MaxZombie then return end
	local Extra_Zombie = ents.Create(ent)
	Extra_Zombie:SetPos(pos)
	Extra_Zombie:SetAngles(Angle(0,math.random(0,360),0))
	Extra_Zombie:Spawn()
	table_insert(self.tbl_SpawnedNPCs,Extra_Zombie)
	if isMob then
		Extra_Zombie.FindEnemy_UseSphere = true
		Extra_Zombie.FindEnemy_CanSeeThroughWalls = true
		Extra_Zombie:DrawShadow(false)
		timer.Simple(0,function()
			if IsValid(Extra_Zombie) then
				Extra_Zombie:DrawShadow(false)
			end
		end)
	end
	Extra_Zombie.MapSpawner = self
	Extra_Zombie.EntitiesToNoCollide = {}
	for _,v in pairs(self.ExtraZombie) do
		table_insert(Extra_Zombie.EntitiesToNoCollide,v.class)
   end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnMiscZombie(ent,pos,isMob)
    if GetConVarNumber("VJ_Paranoia_MapSpawner_Misc") == 0 then return end
	if ent == false then return end
	if pos == nil or pos == false then return end
	if #self.tbl_SpawnedNPCs >= self.Paranoia_MaxZombie then return end
	local Misc_Zombie = ents.Create(ent)
	Misc_Zombie:SetPos(pos)
	Misc_Zombie:SetAngles(Angle(0,math.random(0,360),0))
	Misc_Zombie:Spawn()
	table_insert(self.tbl_SpawnedNPCs,Misc_Zombie)
	if isMob then
		Misc_Zombie.FindEnemy_UseSphere = true
		Misc_Zombie.FindEnemy_CanSeeThroughWalls = true
		Misc_Zombie:DrawShadow(false)
		timer.Simple(0,function()
			if IsValid(Misc_Zombie) then
				Misc_Zombie:DrawShadow(false)
			end
		end)
	end
	Misc_Zombie.MapSpawner = self
	Misc_Zombie.EntitiesToNoCollide = {}
	for _,v in pairs(self.HL1Zombie) do
		table_insert(Misc_Zombie.EntitiesToNoCollide,v.class)
   end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnSpecialZombie(ent,pos)
	if GetConVarNumber("VJ_Paranoia_MapSpawner_Specials") == 0 then return end 
	if ent == false then return end
	if pos == nil or pos == false then return end
	if #self.tbl_SpawnedSpecialZombie >= self.MaxSpecialZombie then return end

	local Boss = ents.Create(ent)
	Boss:SetPos(pos)
	Boss:SetAngles(Angle(0,math.random(0,360),0))
	Boss:Spawn()
	Boss.FindEnemy_UseSphere = true
	Boss.FindEnemy_CanSeeThroughWalls = true
	table_insert(self.tbl_SpawnedSpecialZombie,Boss)
	Boss.MapSpawner = self
	Boss.EntitiesToNoCollide = {}
	for _,v in pairs(self.SpecialZombie) do
		table_insert(Boss.EntitiesToNoCollide,v.class)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
    VJ_STOPSOUND(self.Paranoia_Ambience)
	VJ_STOPSOUND(self.Paranoia_Music)
	for index,object in ipairs(self.tbl_SpawnedNPCs) do
		if IsValid(object) then
			object:Remove()
		end
	end
	for index,object in ipairs(self.tbl_SpawnedSpecialZombie) do
		if IsValid(object) then
			object:Remove()
		end
	end
end