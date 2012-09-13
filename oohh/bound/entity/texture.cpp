#include "StdAfx.h"

#include "oohh.hpp"

LUALIB_FUNCTION(_G, Texture)
{
	ITexture *self = nullptr;

	if (my->IsString(1))
	{
		auto path = my->ToPath(1, "textures");
		self = gEnv->pRenderer->EF_LoadTexture(path);
	}
	else if (my->IsNumber(1) && my->IsNumber(2))
	{
		auto flag = my->ToEnum<ETEX_Format>(3, eTF_A8R8G8B8);
		auto id = gEnv->pRenderer->DownLoadToVideoMemory(nullptr,  my->ToNumber(1),  my->ToNumber(2), flag, flag, 1); 
		self = gEnv->pRenderer->EF_GetTextureByID(id);
	}
	else if (my->IsNumber(1))
	{
		auto id = my->ToNumber(1);
		self = gEnv->pRenderer->EF_GetTextureByID(id);
	}
	my->Push(self);

	return 1;
}

LUAMTA_FUNCTION(texture, SetData)
{
	auto self = my->ToTexture(1);
	unsigned char *buffer;

	if (lua_type(L, 2) == 10)
	{
		buffer = (unsigned char *)lua_topointer(L, 2);
	}
	else
	{
		// this won't really work that well since char is only 0-127
		buffer = (unsigned char *)my->ToString(2);
	}

	auto rect = my->ToRect(3, Rect(0, 0, self->GetWidth(), self->GetHeight()));

	if (buffer[2])
	{
		gEnv->pRenderer->UpdateTextureInVideoMemory(
			self->GetTextureID(), 
			buffer, 
			rect.x, 
			rect.y, 
			rect.w,
			rect.h, 
			my->ToEnum<ETEX_Format>(4, eTF_A8R8G8B8)
		);
		
		my->Push(true);

		return 1;
	}

	return 0;
}

LUAMTA_FUNCTION(texture, GetData)
{
	auto self = my->ToTexture(1);

	lua_pushlightuserdata(L, self->GetSystemCopy());

	return 1;
}


LUAMTA_FUNCTION(texture, GetSize)
{
	auto self = my->ToTexture(1);

	my->Push(self->GetWidth());
	my->Push(self->GetHeight());

	return 2;
}

LUAMTA_FUNCTION(texture, GetId)
{
	auto self = my->ToTexture(1);

	my->Push(self->GetTextureID());

	return 1;
}

LUAMTA_FUNCTION(texture, GetName)
{
	auto self = my->ToTexture(1);

	my->Push(self->GetName());

	return 1;
}

/*

#include <d3dx9.h>
#include <d3d9.h>

#pragma comment(lib, "d3dx9d.lib")

ColorF GetDXTextureColor(const char *path, int x, int y)
{
	if( render->GetRenderType() == eRT_DX9 )
	{
		auto device = static_cast<IDirect3DDevice9 *>(render->EF_Query(EFQ_D3DDevice));

		if( device )
		{
			D3DXIMAGE_INFO params;
			IDirect3DTexture9* dxtex = NULL;

			auto handle = D3DXCreateTextureFromFileEx(
				device,
				path,
				0,
				0,
				D3DX_DEFAULT,
				0,
				D3DFMT_UNKNOWN,
				D3DPOOL_MANAGED,
				D3DX_DEFAULT,
				D3DX_DEFAULT,
				0,
				&params,
				NULL,
				&dxtex
			);

			if( handle == S_OK )
			{
				if( dxtex )
				{
					IDirect3DSurface9 *surface = NULL;

					if( dxtex->GetSurfaceLevel( 0, &surface ) == S_OK )
					{
						D3DLOCKED_RECT rect;

						surface->LockRect( &rect, NULL, D3DLOCK_READONLY );
							DWORD *pixels = (DWORD*)rect.pBits;
							D3DXCOLOR color = pixels[rect.Pitch / sizeof(DWORD) * y + x];
						surface->UnlockRect();

						return ColorF( color.r, color.g, color.b, color.a );
					}
				}
			}
		}
	}

	return ColorF(0,0,0,0);
}

// this is not meant to be used in real time drawing
LUALIB_FUNCTION(surface, GetTextureColor)
{
	auto self = my->ToTexture(1);
	auto pos = my->ToVec2(2);

	auto path = (string)"!/" + self->GetName();

	my->Push(GetDXTextureColor(path.c_str(), (int)pos->x, (int)pos->y));

	return 1;
}
*/