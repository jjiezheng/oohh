do
	local META = {}

	META.Type = "weapon"
	META.ClassName = "umno"

	function META:OnAction(action, mode, value)
		print(self, action, mode, value)
	end

	class.Register(META)
end

local wep = me:Give("oohh_scripted_weapon")
wep:SetTable(class.Create("weapon", "umno"))