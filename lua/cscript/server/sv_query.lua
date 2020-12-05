local meta = FindMetaTable("Player")

function CS_GetAllBanned()
	local query = sql.Query("SELECT `firstname`, `lastname`, `unique_id` FROM `character_list` WHERE `banned` = 'true'")
	return query
end

function CS_CheckBan( id )
	local query = sql.QueryValue("SELECT `banned` FROM `character_list` WHERE `unique_id` = '".. id .."'")
	return query
end

function CS_GetAllPlayers()
	local query = sql.Query("SELECT `firstname`, `lastname`, `unique_id` FROM `character_list`")
	return query
end

function meta:CS_Create( slot, firstname, lastname, model )
	local query = sql.Query("INSERT INTO `character_list` ( `slot`, `steamid`, `firstname`, `lastname`, `money`, `model`, `job`, `banned`, `pocket` ) VALUES ( '".. slot .."', '".. self:SteamID() .."', '".. firstname .."', '".. lastname .."', '".. GAMEMODE.Config.startingmoney .."', '".. model .."', 'citizen', 'false', NULL)")
	return query
end

function meta:CS_List()
	local query = sql.Query("SELECT * FROM `character_list` where `steamid` = '".. self:SteamID() .."'")
	if ( query == false ) then return false end
	return query
end

function meta:CS_ListID( id )
	local query = sql.Query("SELECT * FROM `character_list` WHERE `steamid` = '".. id .."'")
	if ( query == false ) then return false end
	return query
end

function meta:CS_Model()
	local unique_id = self:GetNWString("unique_id")
	local query = sql.QueryValue("SELECT `model` FROM `character_list` WHERE `unique_id` = '".. unique_id .."'")
	return query
end

function meta:CS_FirstName()
	local unique_id = self:GetNWString("unique_id")
	local query = sql.QueryValue("SELECT `firstname` FROM `character_list` WHERE `unique_id` = '" .. unique_id .."'")
	return query or "new"
end

function meta:CS_Money()
	local unique_id = self:GetNWString("unique_id")
	local query = sql.QueryValue("SELECT `money` FROM `character_list` WHERE `unique_id` = '".. unique_id .."'")
	return query
end

function meta:CS_LastName()
	local unique_id = self:GetNWString("unique_id")
	local query = sql.QueryValue("SELECT `lastname` FROM `character_list` WHERE `unique_id` = '".. unique_id .."'")
	return query or "player"
end

function meta:CS_Job()
	local unique_id = self:GetNWString("unique_id") 
	local query = sql.QueryValue("SELECT `job` FROM `character_list` WHERE `unique_id` = '"..unique_id.."'")
	return query
end

function CS_Ban( id )
	local query = sql.Query("UPDATE `character_list` SET `banned` = 'true' WHERE `unique_id` = '".. id .."'")
	return query
end

function CS_Delete( id )
	local query = sql.Query("DELETE FROM `character_list` WHERE `unique_id` = '" .. id .. "'")
	file.Delete("cscript/"..id..".txt") -- remove pocket file
	return query
end

function CS_Unban( id )
	local query = sql.Query("UPDATE `character_list` SET `banned` = 'false' WHERE `unique_id` = '".. id .."'")
	return query
end

function meta:CS_IsValid()
	local unique_id = self:GetNWString("unique_id")
	if !self:CS_List() or unique_id == "none" then
		return false
	end
	return true
end

--[[
net.Start("cc_throwError")
			net.WriteString("No character selected, redirecting to Main Menu")
			net.WriteBool(true)
		net.Send(self)
]]

function meta:CS_Save()
	if self:CS_IsValid() then
		local unique_id = self:GetNWString("unique_id")
		local firstname = string.gsub(string.Explode(" ", self:Nick())[1], "^.", string.upper) or "NULL"
		local lastname = string.gsub(string.Explode(" ", self:Nick())[2], "^.", string.upper) or "NULL"
		local money = self:getDarkRPVar("money") or 0
		local model = self:GetModel()
		local job = self:getJobTable().command
		
		CS_PocketSave( self )
		local query = sql.Query("UPDATE `character_list` SET `firstname` = '" .. firstname .. "', `lastname` = '" .. lastname .. "', `money` = '".. money .."', `job` = '".. job .."', `model` = '" .. model .. "' WHERE `unique_id` = '".. unique_id .."'")
		return query
	end
end

function meta:CS_Load()
	if self:CS_IsValid() then
		self.darkRPPocket = {}
		
		local unique_id = self:GetNWString("unique_id")
		local model = self:CS_Model()
		
		self:setDarkRPVar("rpname", self:CS_FirstName() .. " " .. self:CS_LastName())
		self:setDarkRPVar("money", self:CS_Money())
		self:changeTeam(DarkRP.getJobByCommand(self:CS_Job()).team, true, true)
		self:SetModel(model)
		DarkRP.storeRPName(self, self:CS_FirstName() .. " " .. self:CS_LastName())
		
		CS_PocketLoad( self )
	end
end