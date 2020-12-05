surface.CreateFont("CC_Title_Font", {
	font = "Oswald",
	size = 200,
	weight = 500,
	antialias = true,
})

surface.CreateFont("CC_Button_Font", {
	font = "Oswald",
	size = 25,
	weight = 500,
	antialias = true,
})

surface.CreateFont("CC_Select_Font", {
	font = "Oswald",
	size = 35,
	weight = 500,
	antialias = true
})

surface.CreateFont("CC_Create_Font", {
	font = "Oswald",
	size = 45,
	weight = 500,
	antialias = true
})

local cTable = {}
local is_visible = false

net.Receive("cc_menu", function()
	if is_visible == false then
		mainMenu()
	end
end)

net.Receive("cc_updateCharactersReturn", function()
	cTable = net.ReadTable()
end)

net.Receive("cc_throwError", function()
	local _error 	= net.ReadString()
	local _sendMenu = net.ReadBool()
		
	local bg = vgui.Create("DFrame")
	bg:SetSize(350, 100)
	bg:SetTitle("")
	bg:Center()
	bg:SetMouseInputEnabled(true)
	bg:ShowCloseButton(false)
	bg:MakePopup()
	local length = surface.GetTextSize(_error)
	bg:SetSize(length + 15, 100)
	bg.Paint = function(self)
		Derma_DrawBackgroundBlur(bg, 0)
	
		draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(52,73,94))
		draw.RoundedBox(0, 2, 2, self:GetWide() - 4, self:GetTall() - 4, Color(42, 63, 74))
		
		draw.DrawText("ERROR", "DebugFixed", self:GetWide()/2, self:GetTall()/5, Color(255,55,55), TEXT_ALIGN_CENTER)
		draw.DrawText(_error, "DebugFixedSmall", self:GetWide()/2, self:GetTall()/3, Color(255,255,255), TEXT_ALIGN_CENTER)
	end

	local bClose = vgui.Create("DButton", bg)
	bClose:SetSize(50, 25)
	bClose:Dock( BOTTOM )
	bClose:DockMargin(25, 0, 25, 5)
	bClose:SetFont("Default")
	bClose:SetTextColor(Color(255,255,255,255))
	bClose:SetText("Dismiss")
	bClose.Paint = function(self)
		draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(255,100,100,255))
		draw.RoundedBox(0, 2, 2, self:GetWide()-4, self:GetTall()-4, Color(255,25,25,255))
	end
	bClose.DoClick = function(self)
		surface.PlaySound("ui/buttonclick.wav")
		bg:SetMouseInputEnabled(false)
		bg:Close()
		if _sendMenu  and not is_visible then
			mainMenu()
		end
	end
	
end)

function mainMenu()
	local parsed = markup.Parse( "<font=CC_Title_Font>" .. CS_Config.Title .. "</font>")
	is_visible = true
	
	local w = ScrW()
	local h = ScrH()
	
	local bg = vgui.Create("DFrame")
	bg:SetSize(w, h)
	bg:SetPos(0, 0)
	bg:SetVisible(true)
	bg:ShowCloseButton(false)
	bg:SetTitle("")
	bg:SetDraggable(false)
	bg:MakePopup()
	bg.Paint = function()
		Derma_DrawBackgroundBlur(bg, 0)
		Derma_DrawBackgroundBlur(bg, 0)
		Derma_DrawBackgroundBlur(bg, 0)
	end
	bg.OnClose = function()
		visible = false
	end
	
	local title = vgui.Create("DLabel", bg)
	title:SetPos(0, 0)
	title:SetSize(ScrW(), ScrH())
	title:SetText("")
	title.Paint = function()
		parsed:Draw( ScrW()/2, 150, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	local bList = vgui.Create("CC_Button", bg)
	bList:SetPos(w/2 - (200/2), h/2)
	bList:SetSize(200, 50)
	bList:SetText("Characters")
	bList.DoClick = function()
		surface.PlaySound("ui/buttonclick.wav")
		net.Start("cc_updateCharacters")
		net.SendToServer()
		timer.Simple(0.1, function()
			selectCharacter( cTable )
			bg:Close()
		end)
	end
	
	local bCreate = vgui.Create("CC_Button", bg)
	bCreate:SetPos(w/2 - (200/2), h/1.75)
	bCreate:SetSize(200, 50)
	bCreate:SetText("Create")
	bCreate.DoClick = function()
		surface.PlaySound("ui/buttonclick.wav")
		bg:Close()
		createCharacter()
	end
	
	local bQuit = vgui.Create("CC_Button", bg)
	bQuit:SetPos(w/2 - (200/2), h/1.55)
	bQuit:SetSize(200, 50)
	bQuit:SetText("Disconnect")
	bQuit:SetTextColor(Color(255,55,55,255))
	bQuit.DoClick = function()
		surface.PlaySound("ui/buttonclick.wav")
		RunConsoleCommand("disconnect")
	end
end

function selectCharacter( t )
	is_visible = true
	
	local w = ScrW()
	local h = ScrH()
	
	local parsed = markup.Parse( "<font=CC_Title_Font>".. CS_Config.Title .."</font>")

	local bg = vgui.Create("DFrame")
	bg:SetSize(w, h)
	bg:SetPos(0, 0)
	bg:ShowCloseButton(false)
	bg:SetTitle("")
	bg:SetDraggable(false)
	bg:SetVisible(true)
	bg:MakePopup()
	bg.Paint = function(self)
		Derma_DrawBackgroundBlur(bg, 0)
		Derma_DrawBackgroundBlur(bg, 0)
		Derma_DrawBackgroundBlur(bg, 0)
		
		parsed:Draw( self:GetWide()/2, 150, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	bg.OnClose = function()
		is_visible = false
	end
	
	for i = 1, 3 do
		local bgPanel = vgui.Create("Panel", bg)
		bgPanel:SetSize(bg:GetWide()/6, bg:GetTall()/2.25)
		bgPanel:SetPos(i * (bgPanel:GetWide()*1.25), bg:GetTall()/3.25)
		bgPanel:SetVisible(true)
		bgPanel.Paint = function(self)
			draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(52,73,94))
			draw.RoundedBox(0, 2, 2, self:GetWide()-4, self:GetTall()-4, Color(12,23,34))
		end
		
		if t[i] then
			local mPrev = vgui.Create("DModelPanel", bg)
			mPrev:SetSize(bg:GetWide()/6, bg:GetTall()/2.25)
			mPrev:SetModel(""..t[i].model)
			mPrev:SetPos(i * (mPrev:GetWide()*1.25), bg:GetTall()/3.25)
			mPrev:SetCamPos(Vector(120,0,65))
			mPrev:SetFOV(30)
			
			local bSelect = vgui.Create("DButton", bg)
			bSelect:SetSize(mPrev:GetWide(), mPrev:GetTall())
			bSelect:SetPos(mPrev:GetPos())
			bSelect:SetText("")
			bSelect.unique_id = false
			bSelect.Highlight = false
			bSelect.Paint = function(self)
				draw.DrawText( string.Implode(" ", { t[i].firstname, t[i].lastname }), "CC_Select_Font", self:GetWide()/2, 10, Color(255,255,255,255), TEXT_ALIGN_CENTER)
				draw.DrawText( string.gsub(t[i].job, "^.", string.upper), "CC_Select_Font", self:GetWide()/2, 35, Color(155, 155, 155), TEXT_ALIGN_CENTER)
				
				if t[i].banned == 'true' then
					draw.DrawText( "Banned", "CC_Create_Font", self:GetWide()/2, self:GetTall() - 50, Color(255, 155, 155, 55), TEXT_ALIGN_CENTER)				
				elseif t[i].unique_id == LocalPlayer():GetNWString("unique_id") then
					draw.DrawText( "Playing", "CC_Create_Font", self:GetWide()/2, self:GetTall() - 50, Color(255, 153, 51, 55), TEXT_ALIGN_CENTER)
				elseif t[i].banned == 'false' then
					draw.DrawText( "Play Now", "CC_Create_Font", self:GetWide()/2, self:GetTall() - 50, Color(155, 255, 155, 55), TEXT_ALIGN_CENTER)
				end
					
				if self.Highlight then
					draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(152,173,222, 5))
				end
				
				if unique_id == t[i].unique_id then
					draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(152,222,173, 3))
				end
			end
			bSelect.OnCursorEntered = function(self)
				self.Highlight = true
			end
			bSelect.OnCursorExited = function(self)
				self.Highlight = false
			end
			bSelect.DoClick = function(self)
				prev_selection = LocalPlayer():GetNWString("unique_id")
				unique_id = t[i].unique_id
				new_job = t[i].job
			end
		else
			local bCreate = vgui.Create("DButton", bg)
			bCreate:SetSize(bgPanel:GetWide(), bgPanel:GetTall())
			bCreate:SetPos(bgPanel:GetPos())
			bCreate:SetText("")
			bCreate.Highlight = false
			bCreate.Paint = function(self)
				draw.DrawText( "Create New Character", "CC_Create_Font", self:GetWide()/2, self:GetTall()/2 - 20, Color(155, 155, 155), TEXT_ALIGN_CENTER)
				if self.Highlight then
					draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(152,173,222, 22))
				end
			end
			bCreate.OnCursorEntered = function(self)
				self.Highlight = true
			end
			bCreate.OnCursorExited = function(self)
				self.Highlight = false
			end
			bCreate.DoClick = function()
				surface.PlaySound("ui/buttonclick.wav")
				bg:Close()
				createCharacter()
			end
		end
			
		--draw.DrawText( "John Doh", "TargetID", self:GetWide()/2, 50, Color(255,255,255,255), TEXT_ALIGN_CENTER)
	end
	
	
	local bBack = vgui.Create("CC_Button", bg)
	bBack:SetPos(bg:GetWide()/2 - (300), h/1.25)
	bBack:SetSize(150, 50)
	bBack:SetText("Back")
	bBack:SetTextColor(Color(255,55,55,255))
	bBack.DoClick = function()
		surface.PlaySound("ui/buttonclick.wav")
		bg:Close()
		mainMenu()
	end
	
	local bDelete = vgui.Create("CC_Button", bg)
	bDelete:SetPos(bg:GetWide()/2 - 75, h/1.25)
	bDelete:SetSize(150, 50)
	bDelete.ColorSecondary = Color(255,0,0, 88)
	bDelete:SetText("Delete")
	bDelete.DoClick = function()

		bg:SetMouseInputEnabled(false)
		
		local bg_err = vgui.Create("DFrame", bg)
		bg_err:SetSize(300, 150)
		bg_err:SetTitle("")
		bg_err:Center()
		bg_err:ShowCloseButton(false)
		bg_err:MakePopup()
		bg_err.Paint = function(self)
			Derma_DrawBackgroundBlur(bg_err, 0)

			draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(52,73,94))
			draw.RoundedBox(0, 2, 2, self:GetWide() - 4, self:GetTall() - 4, Color(42, 63, 74))

			draw.DrawText("Delete Character?", "CC_Select_Font", self:GetWide()/2, self:GetTall()/5, Color(255,55,55), TEXT_ALIGN_CENTER)
			--draw.DrawText(, "DebugFixedSmall", self:GetWide()/2, self:GetTall()/3, Color(255,255,255), TEXT_ALIGN_CENTER)
		end
		
		local bDismiss = vgui.Create("CC_Button", bg_err)
		bDismiss:SetSize(100, 15)
		bDismiss:Dock( LEFT )
		bDismiss:DockMargin(25, 50, 25, 25)
		bDismiss:SetFont("CC_Button_Font")
		bDismiss:SetText("No")
		bDismiss.ColorSecondary = Color(15,15,15)

		bDismiss.DoClick = function(self)
			surface.PlaySound("ui/buttonclick.wav")
			bg:SetMouseInputEnabled(true)
			bg_err:Close()
		end
	
		local bAccept = vgui.Create("CC_Button", bg_err)
		bAccept:SetSize(100, 15)
		bAccept:Dock( RIGHT )
		bAccept:DockMargin(25, 50, 25, 25)
		bAccept:SetFont("CC_Button_Font")
		bAccept:SetText("Yes")
		bAccept.ColorSecondary = Color(15,15,15)
		
		bAccept.DoClick = function(self)
			surface.PlaySound("ui/buttonclick.wav")
			bg:SetMouseInputEnabled(true)
			bg:Close()
		
			net.Start("cc_deleteCharacter")
				net.WriteString(unique_id)
			net.SendToServer()
		
			mainMenu()
		end
		
	end
	
	local bPlay = vgui.Create("CC_Button", bg)
	bPlay:SetPos(bg:GetWide()/2 + (300-150), h/1.25)
	bPlay:SetSize(150, 50)
	bPlay.DoClick = function()
		if unique_id ~= nil then
			net.Start("cc_loadCharacter")
				net.WriteString(unique_id)
				net.WriteString(prev_selection)
				net.WriteString(new_job)
			net.SendToServer()
		end
	end
	bPlay.Think = function()
		if CS_Config.AllowRespawn then
			if unique_id == LocalPlayer():GetNWString("unique_id") then
				bPlay:SetText("Continue")
			else
				bPlay:SetText("Play")
			end
		end
	end
	
	net.Receive("cc_characterBanned", function()
		local banned = net.ReadBool()

		if banned == true then
			bg:SetMouseInputEnabled(false)
				
			local bg_err = vgui.Create("DFrame", bg)
			bg_err:SetSize(200, 100)
			bg_err:SetTitle("")
			bg_err:Center()
			bg_err:ShowCloseButton(false)
			bg_err:MakePopup()
			bg_err.Paint = function(self)
				Derma_DrawBackgroundBlur(bg_err, 0)
			
				draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(52,73,94))
				draw.RoundedBox(0, 2, 2, self:GetWide() - 4, self:GetTall() - 4, Color(42, 63, 74))
				
				draw.DrawText("ERROR", "DebugFixed", self:GetWide()/2, self:GetTall()/5, Color(255,55,55), TEXT_ALIGN_CENTER)
				draw.DrawText("Character Banned", "DebugFixedSmall", self:GetWide()/2, self:GetTall()/3, Color(255,255,255), TEXT_ALIGN_CENTER)
			end
			
			local err_close = vgui.Create("DButton", bg_err)
			err_close:SetSize(50, 25)
			err_close:Dock( BOTTOM )
			err_close:DockMargin(25, 0, 25, 5)
			err_close:SetFont("Default")
			err_close:SetTextColor(Color(255,255,255,255))
			err_close:SetText("Dismiss")
			err_close.Paint = function(self)
				draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(255,100,100,255))
				draw.RoundedBox(0, 2, 2, self:GetWide()-4, self:GetTall()-4, Color(255,25,25,255))
			end
			err_close.DoClick = function(self)
				surface.PlaySound("ui/buttonclick.wav")
				bg:SetMouseInputEnabled(true)
				bg_err:Close()
			end
		elseif banned == false then
			bg:SetMouseInputEnabled(false)
			bg:Close()
		end

	end)
	
end

function createCharacter()
	is_visible = true
	
	local w = ScrW()
	local h = ScrH()
	local padding = 5
	
	local bg = vgui.Create("DFrame")
	bg:SetSize(w, h)
	bg:SetPos(0, 0)
	bg:ShowCloseButton(false)
	bg:SetTitle("")
	bg:SetDraggable(false)
	bg:SetVisible(true)
	bg:MakePopup()
	bg.Paint = function()
		Derma_DrawBackgroundBlur(bg, 0)
		Derma_DrawBackgroundBlur(bg, 0)
		Derma_DrawBackgroundBlur(bg, 0)
		
		draw.DrawText( "Fist name", "TargetID", ScrW()/2, ScrH()/5 - 25, Color(255,255,255,255), TEXT_ALIGN_LEFT)
		draw.DrawText( "Last name", "TargetID", ScrW()/2, ScrH()/4 - 25, Color(255,255,255,255), TEXT_ALIGN_LEFT)
	end
	bg.OnClose = function()
		visible = false
	end
	
	local mPreview = vgui.Create("DModelPanel", bg)
	mPreview:SetSize(bg:GetWide()/2, bg:GetTall())
	mPreview:SetModel(LocalPlayer():GetModel())
	mPreview:SetPos(0, 0)
	mPreview:SetCamPos( Vector(55,-35,55) )
	function mPreview:LayoutEntity( ent )
		ent:SetSequence( ent:LookupSequence( "menu_gman" ) )
		mPreview:RunAnimation()
		return
	end
	
	local tFirst = vgui.Create("DTextEntry", bg)
	tFirst:SetPos(ScrW()/2, ScrH()/5)
	tFirst:SetSize(ScrW()/4, 25)
	tFirst:SetText("")
	tFirst:SetUpdateOnType(true)

	tFirst.Paint = function(self)
		draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(52,73,94))
		draw.RoundedBox(0, 2, 2, self:GetWide() - 4 , self:GetTall() - 4, Color(32, 53, 64))
		self:DrawTextEntryText(Color(255,255,255), Color(30,130,255), Color(255,255,255))
	end

	local tLast = vgui.Create("DTextEntry", bg)
	tLast:SetPos(ScrW()/2, ScrH()/4)
	tLast:SetSize(ScrW()/4, 25)
	tLast:SetText("")
	tLast:SetUpdateOnType(true)
	tLast.Paint = function(self)
		draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(52,73,94))
		draw.RoundedBox(0, 2, 2, self:GetWide() - 4 , self:GetTall() - 4, Color(32, 53, 64))
		self:DrawTextEntryText(Color(255,255,255), Color(30,130,255), Color(255,255,255))
	end
	
	local scroll = vgui.Create("DScrollPanel", bg)
	scroll:SetSize(ScrW()/4, ScrH()/2.5)
	scroll:SetPos(ScrW()/2, ScrH()/3.5)
	local vbar = scroll:GetVBar()
	function vbar:Paint(w, h) return end
	function vbar.btnUp:Paint(w, h) return end
	function vbar.btnDown:Paint(w, h) return end
	function vbar.btnGrip:Paint(w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color( 52,73,94 ) )
		draw.RoundedBox( 0, 2, 2, w-4, h-4, Color(32, 53, 64))
		
	end

	local iconList = vgui.Create("DIconLayout", scroll)
	iconList:Dock(FILL)
	iconList:SetSpaceY(0)
	iconList:SetSpaceX(0)
	
	for i = 1, #CS_Config.Playermodels do
		local listItem = iconList:Add( "CC_DModelPanel" )
		listItem:SetSize(110, 110)
		listItem:SetModel(CS_Config.Playermodels[i].model)
		listItem.DoClick = function(self)
			surface.PlaySound("ui/buttonclick.wav")
			mPreview:SetModel(CS_Config.Playermodels[i].model)
		end
	end
	
	local bBack = vgui.Create("CC_Button", bg)
	bBack:SetPos(w/2, h/1.4)
	bBack:SetSize(150, 50)
	bBack:SetText("Back")
	bBack:SetTextColor(Color(255,55,55,255))
	bBack.DoClick = function()
		surface.PlaySound("ui/buttonclick.wav")
		bg:Close()
		mainMenu()
	end
	
	local bCreate = vgui.Create("CC_Button", bg)
	bCreate:SetPos(w/1.5 + 10, h/1.4)
	bCreate:SetSize(150, 50)
	bCreate:SetText("Create")
	bCreate:SetTextColor(Color(255,55,55,255))
	bCreate.DoClick = function()
		surface.PlaySound("ui/buttonclick.wav")
		net.Start("cc_nameFilter")
			net.WriteTable( {tFirst:GetValue(), tLast:GetValue()} ) --mPreview:GetModel()} )
		net.SendToServer()
	end
	
	net.Receive("cc_nameFilterReturn", function()
		local filter = net.ReadString()
		
		print("Name filter return")
		
		if !(string.find("Pass", filter)) then
			bg:SetMouseInputEnabled(false)
		
			local bg_err = vgui.Create("DFrame", bg)
			bg_err:SetSize(200, 100)
			bg_err:SetTitle("")
			bg_err:Center()
			bg_err:ShowCloseButton(false)
			bg_err:MakePopup()
			bg_err.Paint = function(self)
				Derma_DrawBackgroundBlur(bg_err, 0)
			
				draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(52,73,94))
				draw.RoundedBox(0, 2, 2, self:GetWide() - 4, self:GetTall() - 4, Color(42, 63, 74))
				
				draw.DrawText("Invalid Name", "DebugFixed", self:GetWide()/2, self:GetTall()/5, Color(255,55,55), TEXT_ALIGN_CENTER)
				draw.DrawText(filter, "DebugFixedSmall", self:GetWide()/2, self:GetTall()/3, Color(255,255,255), TEXT_ALIGN_CENTER)
			end
			
			local err_close = vgui.Create("DButton", bg_err)
			err_close:SetSize(50, 25)
			err_close:Dock( BOTTOM )
			err_close:DockMargin(25, 0, 25, 5)
			err_close:SetFont("Default")
			err_close:SetTextColor(Color(255,255,255,255))
			err_close:SetText("Dismiss")
			err_close.Paint = function(self)
				draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(255,100,100,255))
				draw.RoundedBox(0, 2, 2, self:GetWide()-4, self:GetTall()-4, Color(255,25,25,255))
			end
			err_close.DoClick = function(self)
				surface.PlaySound("ui/buttonclick.wav")
				bg:SetMouseInputEnabled(true)
				bg_err:Close()
			end
			
		else
			net.Start("cc_createCharacter")
				net.WriteTable( {string.gsub(tFirst:GetValue(), "^.", string.upper), string.gsub(tLast:GetValue(), "^.", string.upper), mPreview:GetModel()} )
			net.SendToServer()
			
			bg:Close()
			mainMenu()
		end
		
	end)
	
end

