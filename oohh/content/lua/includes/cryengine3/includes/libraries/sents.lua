sents = {}

class.SetupLib(sents, "sent")

local META = util.FindMetaTable("entity")

function META:LoadSent(name)
	local meta = class.Create("sent", name, nil, self:GetTable())
	
	if meta then	
		self:SetTable(meta)
	end

	if self.Initialize then
		self:Initialize()
	end
end