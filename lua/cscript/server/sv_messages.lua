include("sv_ccquery.lua")
include("sv_commands.lua")

util.AddNetworkString("cc_menu")
util.AddNetworkString("cc_createCharacter")
util.AddNetworkString("cc_deleteCharacter")
util.AddNetworkString("cc_selectCharacter")
util.AddNetworkString("cc_nameFilter")
util.AddNetworkString("cc_nameFilterReturn")
util.AddNetworkString("cc_getCharacters")
util.AddNetworkString("cc_getCharactersReturn")
util.AddNetworkString("cc_loadCharacter")
util.AddNetworkString("cc_updateCharactersReturn")
util.AddNetworkString("cc_updateCharacters")
util.AddNetworkString("cc_characterBanned")
util.AddNetworkString("cc_throwError")


hook.Add("PlayerSay", "CS_ChatCommands.Hook", function(ply, _str)
	if string.StartWith(_str, CS_Config.CMD_Modifier) then
		local cmd = string.SetChar(_str, 1, "")
		ply:ConCommand(cmd)
	end
	
	if CS_Config.CMD_HideCommand then
		return ""
	end
end)

hook.Add("Initialize", "CS_Initialize.Hook", function()
	if sql.TableExists("character_list") then
		Msg("[CSCRIPT] Customer Character Tables Exist\n")
	else
		if (!sql.TableExists("character_list")) then
			Msg("[CSCRIPT] Table character_list created successfully\n")
			local query = sql.Query("CREATE TABLE `character_list` (`unique_id` INTEGER PRIMARY KEY AUTOINCREMENT, `slot` INTEGER, `steamid` TEXT, `firstname` TEXT, `lastname` TEXT, `money` TEXT, `model` TEXT, `job` INT, `banned` TEXT, `pocket` NVARCHAR);")
		else
			Msg( sql.LastError(query) .. "\n" )
		end
	end 
	
	if CS_Config.DebugConsole then
		Msg("[CSCRIPT] Loading up Character Script during Initialization\n")
	end
	
	if CS_Config.CMD_NameChangeRemove then
		concommand.Remove("rp_setname")
		DarkRP.removeChatCommand( "rpname" )
		DarkRP.removeChatCommand( "nick" )
		DarkRP.removeChatCommand( "name" )
		if CS_Config.DebugConsole then
			Msg("[CSCRIPT] Removed defualt DarkRP RP name commands\n")
		end
	end
end)

hook.Add("PlayerTick", "CS_PlayerTick.Hook", function(ply, _)
	if ply:GetNWString("unique_id") != "none" then
		if !ply:CS_List() then
			if CS_Config.DebugConsole then
				Msg("[CSCRIPT] Set .. " .. ply:Nick() .. " to unique_id NONE")
			end
			ply:SetNWString("unique_id", "none")
		end
	end
end)

hook.Add("OnPlayerChangedTeam", "CS_OnPlayerChangedTeam.Hook", function(ply, _, _)
	if ply:CS_IsValid() then
		for _, v in pairs(CS_Config.PlayermodelWhitelist) do
			if ply:GetModel() == v.model then
				timer.Simple(0.1, function()
					
					ply:SetModel(v.model)
				end)
			end
		end
	end
end)

hook.Add("playerCanChangeTeam", "CS_playerCanChangeTeam.Hook", function(ply)
	if ply:CS_IsValid() then
		return true
	else
		net.Start("cc_throwError")
			net.WriteString("No character selected, redirecting to Main Menu\n")
			net.WriteBool(true)
		net.Send(ply)
		return false
	end
end)

hook.Add("PlayerDisconnected", "CS_PlayerDisconnected.Hook", function(ply)
	if CS_Config.DebugConsole then
		Msg("[CSCRIPT] Player " .. ply:Nick() .. " disconnected. Saved!\n")
	end
	
	ply:CS_Save()
	ply:SetNWString("unique_id", "none")
end)

hook.Add("PlayerDeath", "CS_PlayerDeath.Hook", function(ply)
	ply:CS_Save()
end)

hook.Add("PlayerSpawn", "CS_PlayerSpawn.Hook", function(ply)
	timer.Simple(1, function()
		ply:CS_Load()
	end)
end)


hook.Add("PlayerInitialSpawn", "CS_PlayerInitialSpawn.Hook", function(ply)
	if CS_Config.DebugConsole then
		Msg("[CSCRIPT] Player " .. ply:Nick() .. " just joined. Sending to MENU\n")
	end

	ply:SetNWString("unique_id", "none")
	ply:ConCommand(CS_Config.CMD_Menu)
end)

hook.Add("playerGetSalary", "CS_playerGetSalary.Hook", function(ply)
	if CS_Config.DebugConsole then
		Msg("[CSCRIPT] Saved all players money")
	end
	ply:CS_Save()
end)

//////////////////////////////////////////////////
//			   Network Library					//
//////////////////////////////////////////////////

net.Receive("cc_deleteCharacter", function(_, ply)
	local _id = net.ReadString()
	CS_Delete(_id)
end)


net.Receive("cc_updateCharacters", function(_, ply)
	local _table = ply:CS_List()
	net.Start("cc_updateCharactersReturn")
		if _table then
			net.WriteTable( _table )
		end
	net.Send(ply)
end)

net.Receive("cc_createCharacter", function(_, ply)
	local _table = net.ReadTable()
	
	if ply:CS_List() and #ply:CS_List() != 3 then
		ply:CS_Create(#ply:CS_List() + 1, _table[1], _table[2], _table[3])
	else
		ply:CS_Create(0, _table[1], _table[2], _table[3])
	end
	
end)

net.Receive("cc_loadCharacter", function(len, ply)
	if CS_Config.DebugConsole then
		Msg("[CSCRIPT] Server recieved 'cc_loadCharacter' for " .. ply:Nick() .. "\n")
	end
	
	local new_unique_id = net.ReadString()
	local prev_unique_id = net.ReadString()
	local job = DarkRP.getJobByCommand(net.ReadString())
	local jobOccupancy = {}
	
	for _, v in pairs(player.GetAll()) do
		local _table = v:getJobTable()
	
		if job.command == _table.command then
			table.insert(jobOccupancy, v)
		end
	end
		
	if !CS_Config.AllowRespawn then
		if ply:GetNWString("unique_id") == new_unique_id then return end
	end
	
	net.Start("cc_characterBanned")
		if (CS_CheckBan(new_unique_id)) == "true" then
			net.WriteBool(true)
		elseif (CS_CheckBan(new_unique_id)) == "false" then
			net.WriteBool(false)
			timer.Simple(0.2, function()
				if CS_Config.KillOnChange then
					if new_unique_id ~= prev_unique_id then
						ply:Kill()
					else
						ply:Spawn()
					end
				end
				
				ply:SetNWString("unique_id", new_unique_id)
				print(ply:CS_Job(), job.command)
				if ply:CS_Job() ~= job.command then
					if job.max ~= 0 then
						if (#jobOccupancy + 1) > job.max then 
							timer.Simple(1, function()
								net.Start("cc_throwError")
									net.WriteString("Job has hit max limit")
									net.WriteBool(false)
								net.Send(ply)
								ply:changeTeam(1, true, true)
							end)
						end
					end
				end
				
				ply:CS_Load()
			end)
		else
			net.Start("cc_throwError")
				net.WriteString("No character selected")
				net.WriteBool(false)
			net.Send(ply)
		end
	net.Send(ply)
	

end)

net.Receive("cc_nameFilter", function(len, ply)
	local name = net.ReadTable()
	local list_of_names = sql.Query("SELECT `firstname`, `lastname` FROM `character_list`")
	local filter = "Pass"

	net.Start("cc_nameFilterReturn")
	
	-- Check if spaces
	if (#string.Split(name[1], " ") != 1) or (#string.Split(name[2], " ") != 1) then
		net.WriteString("Contains Spaces")
		net.Send(ply)
		return
	end
	
	-- Check if symbols
	if (name[1]:find( "%W" )) or (name[2]:find( "%W" )) then
		net.WriteString("Invalid Letters")
		net.Send(ply)
		return
	end
	
	if (name[1]:find( "%d" )) or (name[2]:find( "%d" )) then
		net.WriteString("Contains Numbers")
		net.Send(ply)
		return
	end
	
	if #name[1] < 3 or #name[2] < 3 then
		net.WriteString("Name too short")
		net.Send(ply)
		return
	end

	-- Check if bad words
	for _, badWords in pairs(CS_Config.BannedWords) do
		if string.find( string.lower(name[1]), badWords ) or string.find( string.lower(name[2]), badWords ) then
			net.WriteString("Bad Words")
			net.Send(ply)
			return
		end
	end

	if list_of_names then
		for _, v in pairs(list_of_names) do
			if string.lower(v.firstname) == string.lower(name[1]) and string.lower(v.lastname) == string.lower(name[2]) then
				net.WriteString("Name Taken")
				net.Send(ply)
				return
			end
		end
	end
	
	if #name[1] > 12 then
		net.WriteString("Firstname too long")
		net.Send(ply)
	elseif #name[2] > 12 then
		net.WriteString("Lastname too long")
		net.Send(ply)
	end
	
	if ply:CS_List() then
		if #ply:CS_List() == 3 then
			net.WriteString("No available slots")
			net.Send(ply)
		end
	end
	
	net.WriteString("Pass")
	net.Send(ply)

end)
