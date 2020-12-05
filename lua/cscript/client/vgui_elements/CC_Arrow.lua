local PANEL = {}

function PANEL:Init()
	self:SetPos(0, 0)
	self:SetSize(0, 0)
	self:SetFont("CC_Button_Font")
	self:SetText("")
	--self:SetTextColor( Color(255,255,255,255) )
	self:SetMouseInputEnabled(true)
	self.SoundQueue = false
end

function PANEL:OnCursorEntered()
	if !self.SoundQueue then
		surface.PlaySound("ui/buttonrollover.wav")
		self.SoundQueue = true
	end
end

function PANEL:OnCursorExited()
	self.SoundQueue = false
end

function PANEL:Paint(w, h)

	local arrow = {
		{ x = 100, y = h + 200 },
		{ x = 100, y = 100 },
		{ x = w + 200, y = 150}
	}
	
	
	surface.SetDrawColor(52,73,94, 255)
	draw.NoTexture()
	surface.DrawPoly(arrow)

	
	--[[
	draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(52,73,94))
	draw.RoundedBox(0, 2, 2, self:GetWide() - 4, self:GetTall() - 4, Color(42, 63, 74))
	if self:IsHovered() then
		self:SetTextColor( Color(155,155,155,255) )
	else
		self:SetTextColor( Color(255,255,255,255) )
	end]]
end
vgui.Register("CC_Arrow", PANEL, "DButton")