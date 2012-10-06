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
		if (my->IsBoolean(3) && my->ToBoolean(3))
		{
			if(my->ToBoolean(4))
			{
				self = gEnv->pRenderer->EF_GetTextureByID( 
					gEnv->pRenderer->SF_CreateTexture(my->ToNumber(1), my->ToNumber(2), 1, nullptr, eTF_A8R8G8B8, FT_USAGE_RENDERTARGET)
				);
			}
			else
			{
				self = gEnv->pRenderer->EF_GetTextureByID( 
					gEnv->pRenderer->CreateRenderTarget(my->ToNumber(1), my->ToNumber(2), eTF_A8R8G8B8)
				);
			}
		}
		else
		{
			self = gEnv->pRenderer->EF_GetTextureByID( 
				gEnv->pRenderer->DownLoadToVideoMemory(nullptr,  my->ToNumber(1),  my->ToNumber(2), eTF_A8R8G8B8, eTF_A8R8G8B8, 1, true, 2, 0, nullptr, my->ToNumber(3, 0))
			);
		}
	}
	else if (my->IsNumber(1))
	{
		auto id = my->ToNumber(1);
		self = gEnv->pRenderer->EF_GetTextureByID(id);
	}
	my->Push(self);

	return 1;
}

unsigned char* copyPlane( unsigned int cols, unsigned int lines, unsigned char* dst, unsigned int dstStride, unsigned char* src, unsigned int srcStride ) 
{ 
    if ( srcStride == dstStride ) 
    { 
        // source and destination paddings equal 
        memcpy( dst, src, srcStride * lines ); 
        dst += srcStride * lines; 
    } 
 
    else 
    { 
        // source and destination paddings need to be converted 
        ++lines; 
 
        while ( --lines ) 
        { 
            memcpy( dst, src, cols ); 
            src += srcStride; 
            dst += dstStride; 
        } 
    } 
 
    return dst; 
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

	bool OK = false;
	auto id = self->GetTextureID();
	auto rect = my->ToRect(3, Rect(0, 0, self->GetWidth(), self->GetHeight()));
	auto type = my->ToNumber(4, 0);

	if (type == 0)
	{
		gEnv->pRenderer->UpdateTextureInVideoMemory(
			id, 
			buffer, 
			rect.x, 
			rect.y, 
			rect.w,
			rect.h, 
			eTF_A8R8G8B8
		);
		
		OK = true;
	}
	else if (type == 1)
	{
		uint32 nDestPitch = 0; 
		uint32 nSourcePitch = 0; 
		void* pData = nullptr; 
		OK = gEnv->pRenderer->SF_MapTexture(id, 0, pData, nDestPitch); 

		if (pData)
		{
			nSourcePitch = (unsigned int)rect.w << 2; 
			copyPlane( nSourcePitch, rect.w, (unsigned char *)pData, nDestPitch, buffer, nSourcePitch ); 
		}

		OK = gEnv->pRenderer->SF_UnmapTexture(id, 0); 
	}
	else if (type == 2)
	{
		IRenderer::SUpdateRect rects;
		rects.Set(rect.x, rect.y, rect.x, rect.y, rect.w, rect.h);

		OK = gEnv->pRenderer->SF_UpdateTexture(
			id,
			0,
			1,
			&rects,
			buffer, 
			0,
			eTF_A8R8G8B8
		);
	}
			
	my->Push(OK);

	return 1;
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

LUAMTA_FUNCTION(texture, GetFormat)
{
	auto self = my->ToTexture(1);

	my->Push((uint8)self->GetTextureSrcFormat());

	return 1;
}

LUAMTA_FUNCTION(texture, GetTypeName)
{
	auto self = my->ToTexture(1);

	my->Push(self->GetTypeName());

	return 1;
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

LUAMTA_FUNCTION(texture, SaveJPG)
{
	auto self = my->ToTexture(1);

	my->Push(self->SaveJPG(my->ToString(2)));

	return 1;
}

LUAMTA_FUNCTION(texture, SaveTGA)
{
	auto self = my->ToTexture(1);

	my->Push(self->SaveTGA(my->ToString(2)));

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