if SERVER then
	AddCSLuaFile("cscript/client/cl_interface.lua")
	AddCSLuaFile("cscript/client/vgui_elements/CC_Button.lua")
	AddCSLuaFile("cscript/client/vgui_elements/CC_DModelPanel.lua")
	AddCSLuaFile("cscript/client/vgui_elements/CC_Arrow.lua")
	AddCSLuaFile("cscript/sh_config.lua")
	include("cscript/sh_config.lua")
	include("cscript/server/sv_messages.lua")
	include("cscript/server/sv_query.lua")
	include("cscript/server/sv_commands.lua")
	include("cscript/server/sv_pocket.lua")
		
end

if CLIENT then
	include("cscript/sh_config.lua")
	include("cscript/client/cl_interface.lua")
	include("cscript/client/vgui_elements/CC_Arrow.lua")
	include("cscript/client/vgui_elements/CC_Button.lua")
	include("cscript/client/vgui_elements/CC_DModelPanel.lua")
end