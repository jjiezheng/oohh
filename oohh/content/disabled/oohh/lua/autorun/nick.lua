local META = util.FindMetaTable("player")

concommand.Add("setnick", function(ply, nick)
	if CLIENT then
		cvar.Set("nick", nick)
	end

	if SERVER then
		ply.nv.nick = nick
	end
end, "shared")

function META:GetNickname()
	return self.nv and self.nv.nick or "nomad"
end

if CLIENT then
	cvar.Create("nick", os.getenv("USERNAME") or "nomad" .. math.random(1000))

	message.Hook("plynick", function(ply, nick)
		ply.nv.nick = nick
	end)

	concommand.Run("setnick", cvar.Get("nick"))
end

if SERVER then
	function META:SetNickname(str)
		self.nv.nick = tostring(str)
	end
end