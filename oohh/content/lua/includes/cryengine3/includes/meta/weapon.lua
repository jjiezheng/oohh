local META = util.FindMetaTable("weapon")

function META:GetTrace()
	local owner = self:GetOwner()
	return owner:IsValid() and owner:GetEyeTrace() or {}
end