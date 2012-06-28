local META = util.FindMetaTable("player")

function META:GetNickname()
	return self.nv and self.nv.nick or "dongbag"
end

function META:SetNickname(str)
	self.nv.nick = tostring(str)
end

console.AddCommand("setnick", function(ply, nick)
	console.SetVariable("nick", nick or os.getenv("USERNAME"))
	if SERVER then
		ply.nv.nick = nick
	end
end, true)

console.CreateVariable("nick", os.getenv("USERNAME") or "dongbag")

hook.Add("LocalPlayerEntered", "nick", function()
	console.RunCommand("setnick", console.GetVariable("nick"))
	
	if SERVER then
		entities.GetLocalPlayer().nv.nick = "server"
	end
end)