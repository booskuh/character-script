local PANEL = {}

function PANEL:Init()
	self:SetModel("models/player/alyx.mdl")
	
	local eyepos = self.Entity:GetBonePosition( self.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
	eyepos:Add( Vector( 0, 0, 2 ) )	-- Move up slightly
	self:SetLookAt( eyepos )
	self:SetCamPos( eyepos-Vector( -18,5, 0 ) )	-- Move cam in front of eyes
	self.Entity:SetEyeTarget( eyepos-Vector( -18, 0, 0 ) )
end

function PANEL:Paint(w, h)
	if ( !IsValid( self.Entity ) ) then return end

	local x, y = self:LocalToScreen( 0, 0 )

	self:LayoutEntity( self.Entity )

	local ang = self.aLookAngle
	if ( !ang ) then
		ang = ( self.vLookatPos - self.vCamPos ):Angle()
	end
	
	if self:IsHovered() then
		draw.RoundedBox(155, 0, 15, self:GetWide(), self:GetTall(), Color(52,73,94,50))
	end

	cam.Start3D( self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ )

	render.SuppressEngineLighting( true )
	render.SetLightingOrigin( self.Entity:GetPos() )
	render.ResetModelLighting( self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255 )
	render.SetColorModulation( self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255 )
	render.SetBlend( ( self:GetAlpha() / 255 ) * ( self.colColor.a / 255 ) )

	for i = 0, 6 do
		local col = self.DirectionalLight[ i ]
		if ( col ) then
			render.SetModelLighting( i, col.r / 255, col.g / 255, col.b / 255 )
		end
	end

	self:DrawModel()

	render.SuppressEngineLighting( false )
	cam.End3D()
	

	self.LastPaint = RealTime()
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


function PANEL:LayoutEntity()
	return
end
derma.DefineControl("CC_DModelPanel", "Custom DModelPanel", PANEL, "DModelPanel")