local META = util.FindMetaTable("player")

if CLIENT then
	input.Bind("g", "flashlight")
	
	function META:SetFlashlight(b)
		local ent = self.flashlight_ent or NULL
		
		if ent:IsValid() then ent:Remove() end
		
		if b then			
			ent = entities.Create("light")
			ent:Spawn()
			
			ent.OnUpdate = function()
				if not self:IsValid() then
					self:Remove()
					return
				end
				
				local data = self:GetEyeTrace()
				if data.Length < 8 then
					local r,g,b = HSVToColor(CurTime()*30, 1, 1):Unpack()
				
					ent:SetKeyValue("Color.clrDiffuse", Vec3(r,g,b)*5 * (-(data.Length/8)+1))
					ent:SetPos(data.HitPos + Vec3(0,0,1))
				end
			end
					
			self.flashlight_ent = ent
		end
	end
end

console.AddCommand("flashlight", function(ply, line, bool)
	if SERVER then
		ply.flashlight = not ply.flashlight
		ply:CallOnClient("SetFlashlight", ply.flashlight)
	end
end, true)