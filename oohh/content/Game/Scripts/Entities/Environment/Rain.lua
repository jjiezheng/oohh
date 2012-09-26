Rain = {
	type = "Rain",
	Properties = {
		bEnabled = 1,
		fRadius = 50.0,
		fAmount = 1.0,
		fReflectionAmount = 1.0,
		fFakeGlossiness = 1.0,
		fPuddlesAmount = 3.0,
		bRainDrops = 1,
		clrColor = {x=1,y=1,z=1},
		fUmbrellaRadius = 0.0,
	},
	Editor={
		Icon="shake.bmp",
	},
}


function Rain:OnInit()
	self:OnReset();
end

function Rain:OnPropertyChange()
	self:OnReset();
end

function Rain:OnReset()
end

function Rain:OnSave(tbl)
end

function Rain:OnLoad(tbl)
end

function Rain:OnShutDown()
end

function Rain:Event_Enable( sender )
	self.Properties.bEnabled = 1;
end

function Rain:Event_Disable( sender )
	self.Properties.bEnabled = 0;
end

function Rain:Event_SetUmbrella( i, val )
	self.Properties.fUmbrellaRadius = val;
end

Rain.FlowEvents =
{
	Inputs =
	{
		Disable = { Rain.Event_Disable, "bool" },
		Enable = { Rain.Event_Enable, "bool" },
		UmbrellaRadius = { Rain.Event_SetUmbrella, "float" },
	},
	Outputs =
	{
		Disable = "bool",
		Enable = "bool",
	},
}
