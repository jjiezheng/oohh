local PANEL = {}

PANEL.ClassName = "tree"
PANEL.Base = "grid"

local TREE = PANEL

do -- tree node
	local PANEL = {}

	PANEL.ClassName = "tree_node"
	PANEL.Base = "button"
	
	class.GetSet(PANEL, "Expand", true)

	function PANEL:Initialize()
		--self:SetIgnoreMouse(true)
		self.BaseClass.Initialize(self)
				
		local expand = self:CreatePanel("textbutton")
		local label = self:CreatePanel("label")
		
		self.expand = expand
		self.label = label
		
		expand:SetVisible(false)
		
		expand.OnPress = function() printf("pressed %s", self.label:GetText()) self:OnExpand() end
	end
	
	function PANEL:OnExpand()
		self:SetExpand(not self.Expand)
	end
	
	function PANEL:SetText(...)
		self.label:SetText(...)
	end

	function PANEL:OnRequestLayout()
		self.expand:SetSize(Vec2() + self.tree.ItemSize.h)
		self.expand:SetPos(Vec2(self.offset or 0,0))
		
		self.label:SizeToText()		
		self.label:SetPos(self.expand:GetPos() + Vec2(self.expand:GetWidth() + 2, 0))
	end

	function PANEL:AddNode(str, id)
		local pnl = TREE.AddNode(self.tree, str, id, self.pos + 1)
		pnl.offset = self.offset + 8
		pnl.node_parent = self
		
		self.expand:SetVisible(true)
		self:SetExpand(true)
		
		return pnl
	end
	
	function PANEL:SetExpand(b)
		::again::
		for pos, pnl in pairs(self.tree.CustomList) do
			if pnl.node_parent == self and pnl:GetExpand() ~= b then
				pnl:SetExpand(b)
				pnl:SetVisible(b) 
				goto again
			end
		end
		
		self.Expand = b
 
		self.expand:SetText(b and "-" or "+")
		self.tree:RequestLayout()
	end
	
	function PANEL:OnDraw(size)
		graphics.DrawRect(Rect(0,0,size), self:IsMouseOver() and self:GetSkinColor("highlight2") or self:GetSkinColor("light2"))
		if self:IsDown() then
			graphics.DrawRect(Rect(0,0,size), self:GetSkinColor("highlight1"))
		end
	end
	
	aahh.RegisterPanel(PANEL)
end


function PANEL:Initialize()
	self:SetItemSize(Vec2(0, 8))
	self.CustomList = {}

end

function PANEL:AddNode(str, id, pos)
	if id and self.nodes[id] and self.nodes[id]:IsValid() then self.nodes[id]:Remove() end
	
	local pnl, pos = self:CreatePanel("tree_node", pos)
	pnl:SetText(str) 
	pnl.offset = 0
	pnl.pos = pos
	pnl.tree = self
	
	self:RequestLayout()
	
	table.insert(self.CustomList, pnl)
	
	if id then
		self.nodes[id] = pnl 
	end
	
	return pnl
end

local function remove_from_list(self, pnl)

end

function PANEL:RemovePanel(pnl)	
	for k,v in pairs(self.CustomList) do
		if v == pnl then
			table.remove(self.CustomList, k)
		end
	end

	::again::	
	for k,v in pairs(self.CustomList) do
		if v.node_parent == pnl then
			self:RemovePanel(v)
			goto again
		end
	end	
	pnl:Remove()
	self:RequestLayout()
end

aahh.RegisterPanel(PANEL)

timer.Simple(0.1, function() 
	console.AddCommand("test_tree", function()
		local frame = util.RemoveOldObject((aahh.Create("frame")))
		frame:SetTitle("_G")
		frame:SetSize(Vec2(200, 500))
		frame:Center() 
		
		local pnl = aahh.Create("tree", frame)
		pnl:Dock("fill")
		
		local i = 0
		local done = {}
		local function fill(tbl, node)
			node.OnPress = function(s, k) if k == "mouse2" then pnl:RemovePanel(s) end end
			if i > 200 then error("ENOUGH") end
			for key, val in pairs(tbl) do
				if key ~= "_R" and not done[val] then
					if type(val) == "table"  then
						i = i + 1
						done[val] = true
						fill(val, node:AddNode(key))
					end
				end
			end
		end
		
		fill(_G, pnl)
			
		pnl:Stack()
		util.MonitorFileInclude()
	end)
end)