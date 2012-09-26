sents = {}

class.SetupLib(sents, "sent")

local META = util.FindMetaTable("entity")

function META:LoadSent(name)
	local meta = class.Create("sent", name, nil, self)
	
	if meta then	
		for k,v in pairs(self) do
			self[k] = nil
		end
		
		for k,v in pairs(meta) do	
			if k ~= "__index" then
				self[k] = v
			end
		end
		
		local old = getmetatable(self).__index
		local val
		function self:__index(key)
			val = old(self, key)
			
			if not val then
				val = meta.__index(self, key)
			end
			
			return val
		end
	end

	if self.Initialize then
		self:Initialize()
	end
end