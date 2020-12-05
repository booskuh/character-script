function CS_Filesystem()
	if !file.Exists("cscript", "DATA") then
		file.CreateDir("cscript")
	end
	
	if !file.IsDir("cscript", "DATA") then
		file.Delete("cscript")
		file.CreateDir("cscript")
	end
end

function CS_PocketUpdate( ply, tbl )
	if ply:CS_IsValid() then
		CS_Filesystem()
		
		local items = util.Compress(util.TableToJSON(tbl or {})) -- Compress the items' JSON
		local fname = string.lower("cscript/" .. ply:GetNWString("unique_id") .. "_pocket") -- Get the file name which the pocket will be saved to
		
		file.Write("cscript/"..fname..".txt", items) -- Save the pocket 
	end
end

function CS_PocketSave( ply )
	if ply:CS_IsValid() then
		CS_Filesystem()
		
		if ply:CS_IsValid() then
			local items = util.Compress(util.TableToJSON(ply.darkRPPocket or {})) 
			local fname = string.lower(ply:GetNWString("unique_id") .. "_pocket") 
			
			file.Write("cscript/"..fname..".txt", items) 
		end
	end
end

function CS_PocketLoad( ply )
	if ply:CS_IsValid() then
		timer.Simple(1, function()
			local unique_id = ply:GetNWString("unique_id") -- SteamID since everything is SteamID based
			
			if unique_id != "none" then
				if (!file.Exists("cscript/" .. unique_id .. "_pocket.txt", "DATA")) then return end -- The player doesn't has anything on his/her pocket
			else
				return false
			end
			
			local ptbl = util.JSONToTable( -- Convert from JSON
				util.Decompress( -- Decompress file
					file.Read( -- Read file
						"cscript/" .. unique_id .. "_pocket.txt", -- File name
						"DATA"
					) or ""
				) or {}
			)
			
			ply.darkRPPocket = ptbl
			net.Start("DarkRP_Pocket") net.WriteTable(ptbl) net.Send(ply)
		end)
	end
end

hook.Add("onPocketItemAdded", "CS_PocketItemAdd.Hook", function( ply, _, serial )
	local _t = {}
	_t = table.insert(_t, serial)
	CS_PocketUpdate(ply, _t)
	--return nil
end)

hook.Add("onPocketItemRemoved", "CS_PocketItemRemoved.Hook", function( ply, item )
	local _t = ply.darkRPPocket
	_t[item] = nil
	CS_PocketUpdate(ply, _t)
end)

--hook.Add("PlayerSpawn", "CS_PocketSpawn.Hook", function(ply) timer.Simple(2, function() CS_PocketLoad(ply) end) end)
hook.Add("onPocketItemAdded", "CS_PocketSaveHook.Hook", CS_PocketSave)
hook.Add("PlayerDisconnected", "CS_PlayerDisco.Hook", CS_PocketSave)
