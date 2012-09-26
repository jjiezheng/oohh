local META = util.FindMetaTable("player")

function META:GetNickname()
	return self.nv and self.nv.nick or self:GetName()
end

function META:SetNickname(str)
	self.nv.nick = tostring(str)
end

console.AddCommand("setnick", function(ply, nick)
	if SERVER then
		ply.nv.nick = nick
	end
end, true)

console.CreateVariable("nick", os.getenv("USERNAME") or "dongbag", function(val)
	console.RunCommand("setnick", val)
end)

hook.Add("GameInitialized", "nick", function()
	if CLIENT then
		console.RunCommand("setnick", console.GetVariable("nick"))
	end
	
	if SERVER then
		entities.GetLocalPlayer().nv.nick = "server"
	end
end)