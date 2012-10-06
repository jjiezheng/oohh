local ent = util.RemoveOldObject(entities.Create("ScriptedEntity"))
ent:SetPos(here)
ent:Spawn()

function ent:OnUpdate(delta, cam, frameid)
	print(pcall(function()
		--graphics.DisableFlags(true)
			render.SetState(bit.bor(GS_BLSRC_SRCALPHA, GS_BLDST_ONEMINUSSRCALPHA, GS_DEPTHWRITE))
			graphics.Set2DFlags()
			surface.StartDraw()
			--render.SetCamera(cam)
				graphics.DrawRect(Rect(0,0,1000,1000))
			--surface.EndDraw()
		--graphics.DisableFlags(false)
	end))
end

util.MonitorFileInclude()