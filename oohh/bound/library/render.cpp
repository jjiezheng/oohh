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

LUALIB_FUNCTION(render, Render)
{
	gEnv->pSystem->Render();

	return 0;
}

LUALIB_FUNCTION(render, RenderBegin)
{
	gEnv->pSystem->RenderBegin();

	return 0;
}

LUALIB_FUNCTION(render, RenderEnd)
{
	gEnv->pSystem->RenderEnd();

	return 0;
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

LUALIB_FUNCTION(render, SetRenderTarget)
{
	my->Push(rend->SetRenderTarget(my->IsTexture(1) ? my->ToTexture(1)->GetTextureID() : 0, my->ToNumber(2, 0)));

	return 1;
}

LUALIB_FUNCTION(render, ClearBuffer)
{
	rend->ClearBuffer(my->ToNumber(2, 0), my->ToColorPtr(1), my->ToNumber(3, 1.0f));

	return 0;
}

LUALIB_FUNCTION(render, SetClearColor)
{
	rend->SetClearColor(my->ToVec3(1));

	return 0;
}

LUALIB_FUNCTION(render, Set2DMode)
{
	rend->Set2DMode(my->ToBoolean(1), my->ToNumber(2), my->ToNumber(3), my->ToNumber(4, -1e10f), my->ToNumber(5, 1e10f));

	return 0;
}

LUALIB_FUNCTION(render, SetCullMode)
{
	rend->SetCullMode(my->ToNumber(1, 2));

	return 0;
}

LUALIB_FUNCTION(render, GetCurrentNumberOfDrawCalls)
{
	my->Push(rend->GetCurrentNumberOfDrawCalls());

	return 1;
}

LUALIB_FUNCTION(render, SetRenderTile)
{
	rend->SetRenderTile(my->ToNumber(1, 0), my->ToNumber(2, 0), my->ToNumber(3, 0),my->ToNumber(4, 0));

	return 0;
}

LUALIB_FUNCTION(render, GetViewport)
{
	int x,y,w,h = 0;

	rend->GetViewport(&x, &y, &w, &h);

	my->Push(x);
	my->Push(y);
	my->Push(w);
	my->Push(h);

	return 4;
}

LUALIB_FUNCTION(render, SetViewport)
{
	rend->SetViewport(my->ToNumber(1, 0), my->ToNumber(2, 0), my->ToNumber(3, 0),my->ToNumber(4, 0));

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

LUALIB_FUNCTION(render, MakeMatrix)
{
	rend->MakeMatrix(my->ToVec3(1), my->ToVec3(2), my->ToVec3(3, Vec3(1,1,1)), my->ToMatrix34Ptr(4));

	return 0;
}


LUALIB_FUNCTION(render, PushMatrix)
{
	rend->PushMatrix();

	return 0;
}

LUALIB_FUNCTION(render, PopMatrix)
{
	rend->PopMatrix();

	return 0;
}

LUALIB_FUNCTION(render, SetCamera)
{
	rend->SetCamera(my->ToCamera(1));

	return 0;
}

LUALIB_FUNCTION(render, SetColor)
{
	auto c = my->ToColor(1);

	rend->SetMaterialColor(c.r, c.g, c.b, c.a);

	return 0;
}

LUALIB_FUNCTION(render, GetModelViewMatrix)
{
	static auto temp = new float[11];

	rend->GetModelViewMatrix(temp);

	auto m = Matrix34();
	m.m00 = temp[0];
	m.m01 = temp[1];
	m.m02 = temp[2];
	m.m03 = temp[3];

	m.m10 = temp[4];
	m.m11 = temp[5];
	m.m12 = temp[6];
	m.m13 = temp[7];

	m.m20 = temp[8];
	m.m21 = temp[9];
	m.m22 = temp[10];
	m.m23 = temp[11];

	my->Push(m);

	return 1;
}

LUALIB_FUNCTION(render, UnProjectFromScreen)
{
	auto in = my->ToVec3(1);
	auto out = Vec3();

	rend->UnProjectFromScreen(in.x, in.y, in.z, &out.x, &out.y, &out.z);

	my->Push(out);

	return 1;
}

LUALIB_FUNCTION(render, ProjectToScreen)
{
	auto in = my->ToVec3(1);
	auto out = Vec3();

	rend->ProjectToScreen(in.x, in.y, in.z, &out.x, &out.y, &out.z);

	my->Push(out);

	return 1;
}