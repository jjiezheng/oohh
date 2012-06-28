do return end

function ShowMainMenu()
	local test = aahh.Create("frame")
	test:SetTitle("THE HOTELS")
	test:SetSize(300, 100)
	test:Center()

	local btn = aahh.Create("image", test)
	btn:SetSize(Vec2()+200)
	btn:SetTexture(Texture("game/objects/characters/animals/birds/seagull/seagull_diff.dds"))
	btn:DockCenter()
end

--

hook.Add("PostAahhInit", "main_menu", ShowMainMenu)