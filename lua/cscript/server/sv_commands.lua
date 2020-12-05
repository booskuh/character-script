include("sh_config.lua")

concommand.Add(CS_Config.CMD_Menu, function(ply, cmd, args)
	if CS_Config.DebugConsole then
		Msg("[CSCRIPT] Player attempted to open menu")
	end
	
	if ply:CS_List() and ply:GetNWString("unique_id") ~= "none" then
		ply:CS_Save() -- updates character selection screen
	end
	
	net.Start("cc_menu")
	net.Send(ply)
	
end)

concommand.Add(CS_Config.CMD_BanCharacter.cmd, function(ply, cmd, args)
	if ply:IsUserGroup(CS_Config.CMD_BanCharacter.permission) then
		local _charList = {}
		local _all = CS_GetAllPlayers()
		
		if #args != 2 then return DarkRP.notify(ply, 1, 5, "[CSCRIPT] Incorrect Argument") end
		
		for _, v in pairs(_all) do
			if #args == 2 then
				if string.find(string.lower(v.firstname), string.lower(args[1])) then
					if string.find(string.lower(v.lastname), string.lower(args[2])) then
						table.insert(_charList, v.unique_id)
						table.insert(_charList, v.firstname)
						table.insert(_charList, v.lastname)
					end
				end
			else
				return DarkRP.notify(ply, 1, 5, "[CSCRIPT] Incorrect Argument")
			end
		end
		
		if #_charList == 3 then
			CS_Ban(_charList[1])
			
			for _, v in pairs(player.GetAll()) do
				if string.find(string.lower(v:CS_FirstName()), string.lower(args[1])) then
					if string.find(string.lower(v:CS_LastName()), string.lower(args[2])) then
						v:Kill()
						v:ConCommand(CS_Config.CMD_Menu)
						DarkRP.notify(v, 2, 5, "[CSCRIPT] Banned player")
					end
				end
			end
			
			return DarkRP.notify(ply, 2, 5, "[CSCRIPT] Banned player " .. args[1] .. args[2])
		else
			return DarkRP.notify(ply, 1, 5, "[CSCRIPT] No player found: " .. args[1] .. " " .. args[2])
		end
	end
end)

concommand.Add(CS_Config.CMD_UnbanCharacter.cmd, function(ply, cmd, args)
	if ply:IsUserGroup(CS_Config.CMD_UnbanCharacter.permission) then
		if ply:IsAdmin() and ply:IsValid() then
			local _charList = {}
			local banned_list = CS_GetAllBanned()

			for _, v in pairs(banned_list) do
				if #args == 2 then
					if string.find(string.lower(v.firstname), string.lower(args[1])) then
						if string.find(string.lower(v.lastname), string.lower(args[2])) then
							table.insert(_charList, v.unique_id)
						end
					end
				else
					return DarkRP.notify(ply, 1, 5, "[CSCRIPT] Incorrect Argument")
				end
			end

			if #_charList == 1 then
				CS_Unban( _charList[1] )
				DarkRP.notify(ply, 2, 5, "[CSCRIPT] Unbanned player" .. args[1])
			elseif #_char > 1 then
				DarkRP.notify(ply, 1, 5, "[CSCRIPT] Duplicate Names Found")
			else
				DarkRP.notify(ply, 1, 5, "[CSCRIPT] No player found with name: " .. args[1])
			end
		else
			DarkRP.notify(ply, 1, 5, "[CSCRIPT] You must be an Admin to run this command" .. args[1])
		end
	end
end)

concommand.Add(CS_Config.CMD_DeleteCharacter.cmd, function(ply, cmd, args)
	if ply:IsUserGroup(CS_Config.CMD_DeleteCharacter.permission) then
		local _charList = {}
		local _all = CS_GetAllPlayers()
		
		if #args != 2 then return DarkRP.notify(ply, 1, 5, "[CSCRIPT] Incorrect Argument") end
		
		for _, v in pairs(_all) do
			if #args == 2 then
				if (string.lower(v.firstname) == string.lower(args[1])) then
					if (string.lower(v.lastname) == string.lower(args[2])) then
						table.insert(_charList, v.unique_id)
						table.insert(_charList, v.firstname)
						table.insert(_charList, v.lastname)
					end
				end
			else
				return DarkRP.notify(ply, 1, 5, "[CSCRIPT] Incorrect Argument")
			end
		end
		
		PrintTable(_charList)
		if #_charList == 3 then

			for _, v in pairs(player.GetAll()) do
				if (string.lower(v:CS_FirstName()) == string.lower(args[1])) then
					if (string.lower(v:CS_LastName()) == string.lower(args[2])) then
						v:Kill()
						net.Start("cc_throwError")
							net.WriteString("Your character has been DELETED")
							net.WriteBool(true)
						net.Send(ply)
					end
				end
			end
			
			CS_Delete(_charList[1])
			
			return DarkRP.notify(ply, 2, 5, "[CSCRIPT] Banned player " .. args[1] .. args[2])
		else
			return DarkRP.notify(ply, 1, 5, "[CSCRIPT] No player found: " .. args[1] .. " " .. args[2])
		end
	end
end)

concommand.Add(CS_Config.CMD_KickFromJob.cmd, function(ply, cmd, args)
	if ply:IsUserGroup(CS_Config.CMD_KickFromJob.permission) then
		local _charList = getCharFromName(ply, args, 1, 2)
		
		if _charList and _charList != true then
			_charList[1]:changeTeam( TEAM_CITIZEN, true )
			DarkRP.notify(ply, 2, 5, "[CSCRIPT] Job Changed")
		end
	end
end)

concommand.Add(CS_Config.CMD_ChangePlayerModel.cmd, function(ply, cmd, args)
	if ply:IsUserGroup(CS_Config.CMD_ChangePlayerModel.permission) then
		local _charList = getCharFromName(ply, args, 2, 3)
		local _playermodels = { }
		table.Add(CS_Config.Playermodels, CS_Config.PlayermodelWhitelist)
		
		if _charList and _charList != true then
			for k, v in pairs(CS_Config.Playermodels) do
				if #args == 2 then
					if args[2] == v.name then
						_charList[1]:SetModel(v.model)
					end
				elseif #args == 3 then
					if args[3] == v.name then
						_charList[1]:SetModel(v.model)
					end
				end
			end
			timer.Simple(2, function()
				_charList[1]:CS_Save()
			end)
			DarkRP.notify(ply, 2, 10, "[CSCRIPT] Changed " .. args[1] .. "'s playermodel to ".. args[2])
		end
	end
end)

concommand.Add(CS_Config.CMD_ChangeRPName.cmd, function(ply, cmd, args)
	if ply:IsUserGroup(CS_Config.CMD_ChangeRPName.permission) then
		local _charList = getCharFromName(ply, args, 3, 4)
		
		if _charList and _charList != true then
			if #args == 4 then
				_charList[1]:setDarkRPVar("rpname", string.gsub(args[3], "^.", string.upper ) .. " " .. string.gsub(args[4], "^.", string.upper ))
				DarkRP.notify(ply, 2, 10, "[CSCRIPT] Set players: '"..args[1] .. " " .. args[2] .. "' name to: '" .. args[3] .. " " .. args[4] .. "'")
				DarkRP.notify(_charList, 2, 10, "[CSCRIPT] Your name has been changed to, " .. args[3] .. " " .. args[4])

			end
		end
	end
end)

function getCharFromName(ply, _args, _min, _max)
	local _charList = {}
	for _, v in pairs(player.GetAll()) do
		local fullname = string.Split(v:Nick(), " ")
		if #_args == _min then
			if string.find(string.lower(fullname[1]), string.lower(_args[1])) then
				table.insert(_charList, v)
			end
		
		elseif #_args == _max then
			if string.find(string.lower(fullname[1]), string.lower(_args[1])) then
				if string.find(string.lower(fullname[2]), string.lower(_args[2])) then
					table.insert(_charList, v)
				end
			end
		elseif #_args < _min then
			return DarkRP.notify(v, 1, 10, "[CSCRIPT] Not enough arguments")
		elseif #_args > _max then
			return DarkRP.notify(v, 1, 10, "[CSCRIPT] Too many arguments")
		end
	end

	
	if #_charList == 1 then
		return _charList
	elseif #_charList > 1 then
		DarkRP.notify(ply, 1, 10, "[CSCRIPT] Duplicate Names Found")
	else
		DarkRP.notify(ply, 1, 10, "[CSCRIPT] No player found with name: " .. _args[1] .. " " .. _args[2])
	end
end