local META = {}

	META.Data = {}

	function META:Initialize()
		self:SetViewModel("objects/weapons/scar/scar_fp.cgf", 1)
		self:SetModel("objects/weapons/scar/scar_tp.cgf", EIGS_THIRDPERSON)
		self:PlayAnimation("select_01", EIGS_THIRDPERSON)
	end

	function META:PreUpdate(delta)
		-- todo: move this to a base?
		self.Owner = self:GetOwner()
		if self:IsSelected() then
			local phys = self.Data.Physics
			if phys then
				local pos = self.Owner:GetEyePos()
				local dir = self.Owner:GetEyeDir()

				phys:SetRotation(self.Data.Rot)
				phys:SmoothPosMove((pos + (dir * self.Data.Length)) + self.Data.LocalPos, CLIENT and 0.05 or 1)
			end
		end
	end

	function META:OnInputEvent(key, pressed, char)
		if self.Data.Physics then
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
			if phys then
				phys:Freeze(true)
			end
		elseif key == "mouse1" then
			if pressed then
				local data = self:GetTrace()
				local phys = data.HitPhysics

				if phys then
					phys:Freeze(false)
					local oldmass = phys:GetMass()
					phys:SetMass(50000)
					self.Data =
					{
						Physics = phys,

						LocalPos = phys:GetPos() - data.HitPos,
						Rot = phys:GetRotation(),
						Length = data.Length,
						Mass = oldmass,
					}
				end
			else
				if self.Data.Physics then
					self.Data.Physics:SetMass(self.Data.Mass)
				end
				self.Data = {}
			end
		end
	end

sents.Register(META, "physgun")