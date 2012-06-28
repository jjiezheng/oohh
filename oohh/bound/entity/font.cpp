#include "StdAfx.h"

#include "oohh.hpp"

LUALIB_FUNCTION(_G, Font)
{
	auto w = my->ToNumber(2, 288);
	auto h = my->ToNumber(3, 416);
	auto flags = my->ToNumber(4, TTFFLAG_CREATE(4, 2));

	auto path = (string)my->ToPath(1, "fonts");

	if (path == "default")
	{
		my->Push(gEnv->pCryFont->GetFont("default"));

		return 1;
	}

	auto font = gEnv->pSystem->GetICryFont()->NewFont(path);
	auto success = false;

	if (font)
	{
		if (!font->Load(path, w, h, flags))
		{
			CryWarning(VALIDATOR_MODULE_SYSTEM, VALIDATOR_WARNING, "oohh cannot load the font called '%s', reverting to default", path);

			my->Push(gEnv->pCryFont->GetFont("default"));

			return 1;
		}

		my->Push(font);

		return 1;
	}

	return 0;
}

LUALIB_FUNCTION(_G, GetLoadedFonts)
{
	my->NewTable();

#ifdef CE3
	auto str = gEnv->pSystem->GetICryFont()->GetLoadedFontNames();
	auto found = 0;
	auto i = 0;
    found = str.find_first_of(",");
    while (found != string::npos)
	{
        if(found > 0)
		{
			i++;
			auto name = str.substr(0, found);
			my->SetMember(-1, name, gEnv->pCryFont->GetFont(name));
        }
        
		str = str.substr(found + 1);
        found = str.find_first_of(",");
    }
    if(str.length() > 0)
	{
		my->SetMember(-1, str, gEnv->pCryFont->GetFont(str));
    }
#endif

	return 1;
}

LUAMTA_FUNCTION(font, Remove)
{
	auto self = my->ToFont(1);
	self->Free();

	return 0;
}

LUAMTA_FUNCTION(font, GetScale)
{
	auto self = my->ToFont(1);
	auto str = my->ToString(2);
	
	if (str[0] != 0)
	{	
#ifdef CE3
		STextDrawContext params;
		params.SetSize(Vec2(1, 1));
		auto scale = self->GetTextSize(str, false, params);
#else
		self->SetSize(Vec2(1, 1));
		auto scale = self->GetTextSize(str, false);
#endif

		auto _scale = Vec2(scale.x / scale.y, scale.y / scale.x);
		_scale *= 2;

		my->Push(_scale.x);
		my->Push(_scale.y);

		return 2;
	}															
	
	my->Push(1);
	my->Push(1);

	return 2;
}