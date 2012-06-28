local META = {}
	META.ClassName = "physgun"
	
	function META:Initialize() 
		--self:SetViewModel("objects/weapons/scar/scar_fp.cgf", 1)
		--self:SetModel("objects/weapons/scar/scar_tp.cgf")
		--self:PlayAnimation("select_01", EIGS_THIRDPERSON)
		print("hiiii")
		self.Data = {Physics = NULL}
	end
	 
	if SERVER then
		function META:OnUpdate(delta)
			-- todo: move this to a base?
			self.Owner = self:GetOwner()
			if self:IsSelected() then
				local phys = self.Data.Physics
				if phys:IsValid() then
					local pos = self.Owner:GetEyePos()
					local dir = self.Owner:GetEyeDir()

					phys:SetRotation(self.Data.Rot)
					phys:SmoothPosMove((pos + (dir * self.Data.Length)) + self.Data.LocalPos)
				end
			end
		end
	end

	function META:OnKeyEvent(key, pressed)
		if self.Data.Physics:IsValid() then
			if key == "mwheel_up" then
				self.Data.Length = self.Data.Length + 1
				return false
			elseif key == "mwheel_down" then
				self.Data.Length = self.Data.Length - 1
				return false
			end
		end

		if key == "mouse2" and not pressed then
			local phys = self.Data.Physics
			if phys:IsValid() then
				phys:Freeze(true)
			end
			return false 
		elseif key == "mouse1" then
			if pressed then
				local data = self:GetTrace() 
				local phys = data.HitPhysics or NULL

				if phys:IsValid() and phys:GetEntity() and phys:GetEntity():IsValid() then
					self.Data =
					{
						Physics = phys,

						LocalPos = phys:GetPos() - data.HitPos,
						Rot = phys:GetRotation(),
						Length = data.Length,
						Mass = phys:GetMass(),
					}
					
					phys:Freeze(false)
					phys:SetMass(50000)
				end
			else
				if self.Data.Physics:IsValid() then
					self.Data.Physics:SetMass(self.Data.Mass)
				end
				self.Data = {Physics = NULL} 
			end
			return false
		end
	end
sents.Register(META) 