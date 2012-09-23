#include "StdAfx.h"
#include "oohh.hpp"

#include "Game.h"

#include "IUIDraw.h"
#include "IRenderer.h"

#define rend gEnv->pRenderer
#define uirend gEnv->pGame->GetIGameFramework()->GetIUIDraw()

LUALIB_FUNCTION(render, GetScreenSize)
{
	my->Push(rend->GetWidth());
	my->Push(rend->GetHeight());

	return 2;
}


LUALIB_FUNCTION(render, GetScreenScale)
{
	my->Push(rend->ScaleCoordX(1));
	my->Push(rend->ScaleCoordY(1));

	return 2;
}

LUALIB_FUNCTION(render, BeginFrame)
{
	rend->BeginFrame();

	return 0;
}

LUALIB_FUNCTION(render, EndFrame)
{
	rend->EndFrame();

	return 0;
}

LUALIB_FUNCTION(render, SetState)
{
	rend->SetState(my->ToNumber(1), my->ToNumber(2, -1));

	return 0;
}

LUALIB_FUNCTION(render, EnableFog)
{
	rend->EnableFog(my->ToBoolean(1));

	return 0;
}

LUALIB_FUNCTION(render, SetFog)
{
	auto c = my->ToColor(4, ColorF(1,1,1,0));

	float color[] = {c.r, c.g, c.b};

	rend->SetFog(my->ToNumber(1), my->ToNumber(2), my->ToNumber(3), color, my->ToNumber(5));

	return 0;
}

LUALIB_FUNCTION(render, ScreenToWorld)
{
	auto spos = my->ToVec2(1);

	Vec3 vPos0(0,0,0);
	rend->UnProjectFromScreen(spos.x, spos.y, 0, &vPos0.x, &vPos0.y, &vPos0.z);

	Vec3 vPos1(0,0,0);
	rend->UnProjectFromScreen(spos.x, spos.y, 1, &vPos1.x, &vPos1.y, &vPos1.z);

	my->Push((vPos1-vPos0).GetNormalized());
	
	return 1;
}

LUALIB_FUNCTION(render, WorldToScreen)
{
	auto wpos = my->ToVec3(1);
	auto spos = Vec3(0,0,0);

	if (!rend->ProjectToScreen(wpos.x, wpos.y, wpos.z, &spos.x, &spos.y, &spos.z))
	{
		my->Push(false);

		return 1;
	}

	//scale projected values to the actual screen resolution
	spos.x *= 0.01f * (float)gEnv->pRenderer->GetWidth();
	spos.y *= 0.01f * (float)gEnv->pRenderer->GetHeight();;
	
	my->Push(Vec2(spos.x, spos.y));
	my->Push(spos.z); // i'm guessing this is always 0?

	return 2;
}

LUALIB_FUNCTION(render, CreateRenderTarget)
{
	my->Push(rend->EF_GetTextureByID(rend->CreateRenderTarget(my->ToNumber(1), my->ToNumber(2), my->ToEnum<ETEX_Format>(3, eTF_A8R8G8B8))));

	return 1;
}

LUALIB_FUNCTION(render, DestroyRenderTarget)
{
	my->Push(rend->DestroyRenderTarget(my->ToTexture(1)->GetTextureID()));

	return 1;
}

LUALIB_FUNCTION(render, SetTexture)
{
	rend->SetTexture(my->ToTexture(1)->GetTextureID());
	
	return 0;
}

LUALIB_FUNCTION(render, DrawQuad)
{
	rend->DrawQuad(my->ToVec3(2), my->ToVec3(3), my->ToVec3(1), my->ToNumber(4, 0));

	return 0;
}

LUALIB_FUNCTION(render, SetRenderTarget)
{
	my->Push(rend->SetRenderTarget(my->IsNoneOrNil(1) ? 0 : my->ToTexture(1)->GetTextureID(), my->ToNumber(2, 0)));

	return 1;
}

LUALIB_FUNCTION(render, Set2DMode)
{
	rend->Set2DMode(my->ToBoolean(1), my->ToNumber(2), my->ToNumber(3), my->ToNumber(4, -1e10f), my->ToNumber(5, 1e10f));

	return 0;
}

LUALIB_FUNCTION(render, ScreenToTexture)
{
	my->Push(rend->EF_GetTextureByID(gEnv->pRenderer->ScreenToTexture(my->ToNumber(1, 0))));

	return 1;
}

LUALIB_FUNCTION(render, EnableSwapBuffers)
{
	rend->EnableSwapBuffers(my->ToBoolean(1));

	return 0;
}

LUALIB_FUNCTION(render, Clear)
{
	rend->ClearBuffer(FRT_CLEAR | FRT_CLEAR_IMMEDIATE, my->ToColorPtr(1));

	return 0;
}