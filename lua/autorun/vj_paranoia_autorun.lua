------------------ Addon Information ------------------
local PublicAddonName = "[VJ] PARANOIA SNPCS"
local AddonName = "[VJ] PARANOIA SNPCS"
local AddonType = "SNPC"
local AutorunFile = "autorun/vj_paranoia_autorun.lua"
-------------------------------------------------------
local VJExists = file.Exists("lua/autorun/vj_base_autorun.lua","GAME")
if VJExists == true then
	include('autorun/vj_controls.lua')

	local vCat = "PARANOIA" -- Category, you can also set a category individually by replacing the vCat with a string value
	
	/* -- Comment box start
	NOTE: The following code is commented out so the game doesn't run it! When copying one of the options below, make sure to put it outside of the comment box!
	
	VJ.AddNPC("Dummy SNPC", "npc_vj_dum_dummy", vCat) -- Adds a NPC to the spawnmenu
		-- Parameters:
			-- First is the name, second is the class name
			-- Third is the category that it should be in
			-- Fourth is optional, which is a boolean that defines whether or not it's an admin-only entity
	VJ.AddNPC_HUMAN("Dummy Human SNPC", "npc_vj_dum_dummy", {"weapon_vj_dummy"}, vCat) -- Adds a NPC to the spawnmenu but with a list of weapons it spawns with
		-- Parameters:
			-- First is the name, second is the class name
			-- Third is a table of weapon, the base will pick a random one from the table and give it to the SNPC when "Default Weapon" is selected
			-- Fourth is the category that it should be in
			-- Fifth is optional, which is a boolean that defines whether or not it's an admin-only entity
	VJ.AddWeapon("Dummy Weapon", "weapon_vj_dummy", false, vCat) -- Adds a weapon to the spawnmenu
		-- Parameters:
			-- First is the name, second is the class name
			-- Third is a boolean that defines whether or not it's an admin-only entity
			-- And the last parameter is the category that it should be in
	VJ.AddNPCWeapon("VJ_Dummy", "weapon_vj_dummy") -- Adds a weapon to the NPC weapon list
		-- Parameters:
			-- First is the name, second is the class name
	VJ.AddEntity("Dummy Kit", "sent_vj_dummykit", "Author Name", false, 0, true, vCat) -- Adds an entity to the spawnmenu
		-- Parameters: 
			-- First is the name, second is the class name and the third is its class name	
			-- Fourth is a boolean that defines whether or not it's an admin-only entity
			-- Fifth is an integer that defines the offset of the entity (When it spawns)
			-- Sixth is a boolean that defines whether or not it should drop to the floor when it spawns
			-- And the last parameter is the category that it should be in

	-- Particles --
	VJ.AddParticle("particles/example_particle.pcf",{
		"example_particle_name1",
		"example_particle_name2",
	})
	
	-- Precache Models --
	util.PrecacheModel("models/example_model.mdl")
	
	-- ConVars --
	VJ.AddConVar("vj_dum_dummy_h",100) -- Example 1
	VJ.AddConVar("vj_dum_dummy_d",20) -- Example 2
	
	*/  -- Comment box end
	
    VJ.AddNPC("Zombie (Citizen)", "npc_vj_paranoia_zombie_citizen", vCat)
    VJ.AddNPC("Zombie (Soldier)", "npc_vj_paranoia_zombie", vCat)
    VJ.AddNPC("Zombie (Clone)", "npc_vj_paranoia_zombie_clone", vCat)
    VJ.AddNPC("Heavy Zombie", "npc_vj_paranoia_zombie_heavy", vCat)
    VJ.AddNPC("Mutant Zombie", "npc_vj_paranoia_zombie_mutant", vCat)
    VJ.AddNPC("Bio-Mutant Spider", "npc_vj_paranoia_spider_mutant", vCat)
    VJ.AddNPC("Bio-Mutant Creeper", "npc_vj_paranoia_creeper_mutant", vCat)
    VJ.AddNPC("Zombie (Spetsnaz)", "npc_vj_paranoia_zombie_alpha", vCat)
    VJ.AddNPC("Zombie (Hazmat)", "npc_vj_paranoia_zombie_hazmat", vCat)
	VJ.AddNPC("Map Spawner","sent_vj_paranoia_mapspawner",vCat)

 VJ.AddConVar("vj_paranoia_mutzom_betarun",0)
	VJ.AddConVar("vj_paranoia_mutzom_leap",1)
	VJ.AddConVar("vj_paranoia_mutzom_frenzy",0)
	
    -- Map Spawner ConVars --
    VJ.AddClientConVar("VJ_Paranoia_MapSpawner_Music", 1)
    VJ.AddClientConVar("VJ_Paranoia_MapSpawner_Ambient", 1)		
	VJ.AddClientConVar("VJ_Paranoia_MapSpawner_MusicVolume",50)
	VJ.AddClientConVar("VJ_Paranoia_MapSpawner_AmbienceVolume",30)		
	VJ.AddConVar("VJ_Paranoia_MapSpawner_Enabled", 1, {FCVAR_ARCHIVE})
	VJ.AddConVar("VJ_Paranoia_MapSpawner_MaxZom", 100)
	VJ.AddConVar("VJ_Paranoia_MapSpawner_HordeCount", 30)
	VJ.AddConVar("VJ_Paranoia_MapSpawner_SpawnMax", 2000)
	VJ.AddConVar("VJ_Paranoia_MapSpawner_SpawnMin", 650)
	VJ.AddConVar("VJ_Paranoia_MapSpawner_HordeChance", 50)
	VJ.AddConVar("VJ_Paranoia_MapSpawner_HordeCooldownMin", 90)
	VJ.AddConVar("VJ_Paranoia_MapSpawner_HordeCooldownMax", 180)
	VJ.AddConVar("VJ_Paranoia_MapSpawner_DelayMin", 0.85)
	VJ.AddConVar("VJ_Paranoia_MapSpawner_DelayMax", 3)

	if CLIENT then
	hook.Add("PopulateToolMenu", "VJ_ADDTOMENU_PARANOIA", function()
		spawnmenu.AddToolMenuOption("DrVrej", "SNPC Configures", "PARANOIA", "PARANOIA", "", "", function(Panel)
			Panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = "vj_paranoia_mutzom_betarun 0; vj_paranoia_mutzom_leap 1; vj_paranoia_mutzom_frenzy 0"})
			Panel:AddControl("Checkbox", {Label = "Mutant Zombie uses alternate run animation", Command = "vj_paranoia_mutzom_betarun"})
		    Panel:ControlHelp("Makes the Mutant Zombie use the Fast Zombie running animation.")
			Panel:AddControl("Checkbox", {Label = "Mutant Zombie has leap attack", Command = "vj_paranoia_mutzom_leap"})
		    Panel:ControlHelp("Makes the Mutant Zombie use a leap attack.")
			Panel:AddControl("Checkbox", {Label = "Mutant Zombie has frenzy attack", Command = "vj_paranoia_mutzom_frenzy"})
			Panel:ControlHelp("Makes the Mutant Zombie use a frenzy attack like the Fast Zombie.")
		end)
	end)
end

-------------------------------------------------------------------------------------------------------------------------
VJ_Paranoia_NODEPOS = {}
	hook.Add("EntityRemoved","VJ_Paranoia_AddNodes",function(ent)
		if ent:GetClass() == "info_node" then
			table.insert(VJ_Paranoia_NODEPOS,ent:GetPos())	
	end
end)
-- !!!!!! DON'T TOUCH ANYTHING BELOW THIS !!!!!! -------------------------------------------------------------------------------------------------------------------------
	AddCSLuaFile(AutorunFile)
	VJ.AddAddonProperty(AddonName,AddonType)
else
	if CLIENT then
		chat.AddText(Color(0, 200, 200), PublicAddonName,
		Color(0, 255, 0), " was unable to install, you are missing ",
		Color(255, 100, 0), "VJ Base!")
	end
	
	timer.Simple(1, function()
		if not VJBASE_ERROR_MISSING then
			VJBASE_ERROR_MISSING = true
			if CLIENT then
				// Get rid of old error messages from addons running on older code...
				if VJF && type(VJF) == "Panel" then
					VJF:Close()
				end
				VJF = true
				
				local frame = vgui.Create("DFrame")
				frame:SetSize(600, 160)
				frame:SetPos((ScrW() - frame:GetWide()) / 2, (ScrH() - frame:GetTall()) / 2)
				frame:SetTitle("Error: VJ Base is missing!")
				frame:SetBackgroundBlur(true)
				frame:MakePopup()
	
				local labelTitle = vgui.Create("DLabel", frame)
				labelTitle:SetPos(250, 30)
				labelTitle:SetText("VJ BASE IS MISSING!")
				labelTitle:SetTextColor(Color(255,128,128))
				labelTitle:SizeToContents()
				
				local label1 = vgui.Create("DLabel", frame)
				label1:SetPos(170, 50)
				label1:SetText("Garry's Mod was unable to find VJ Base in your files!")
				label1:SizeToContents()
				
				local label2 = vgui.Create("DLabel", frame)
				label2:SetPos(10, 70)
				label2:SetText("You have an addon installed that requires VJ Base but VJ Base is missing. To install VJ Base, click on the link below. Once\n                                                   installed, make sure it is enabled and then restart your game.")
				label2:SizeToContents()
				
				local link = vgui.Create("DLabelURL", frame)
				link:SetSize(300, 20)
				link:SetPos(195, 100)
				link:SetText("VJ_Base_Download_Link_(Steam_Workshop)")
				link:SetURL("https://steamcommunity.com/sharedfiles/filedetails/?id=131759821")
				
				local buttonClose = vgui.Create("DButton", frame)
				buttonClose:SetText("CLOSE")
				buttonClose:SetPos(260, 120)
				buttonClose:SetSize(80, 35)
				buttonClose.DoClick = function()
					frame:Close()
				end
			elseif (SERVER) then
				VJF = true
				timer.Remove("VJBASEMissing")
				timer.Create("VJBASE_ERROR_CONFLICT", 5, 0, function()
					print("VJ Base is missing! Download it from the Steam Workshop! Link: https://steamcommunity.com/sharedfiles/filedetails/?id=131759821")
				end)
			end
		end
	end)
end