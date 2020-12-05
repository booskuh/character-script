local PANEL = {}

function PANEL:Init()
	self:SetPos(0, 0)
	self:SetSize(0, 0)
	self:SetFont("CC_Button_Font")
	self:SetMouseInputEnabled(true)
	self.SoundQueue = false
	
	self.ColorPrimary = Color(52,73,94)
	self.ColorSecondary = Color(42, 63, 74)
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

function PANEL:Paint()
	draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), self.ColorPrimary)
	draw.RoundedBox(0, 2, 2, self:GetWide() - 4, self:GetTall() - 4, self.ColorSecondary)
	if self:IsHovered() then
		self:SetTextColor( Color(155,155,155,255) )
	else
		self:SetTextColor( Color(255,255,255,255) )
	end
end
vgui.Register("CC_Button", PANEL, "DButton")