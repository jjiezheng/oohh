#include "StdAfx.h"
#include "oohh.hpp"

#include "ID3DSystem.h"

#include "d3d9.h"
#include "D3dx9core.h"

class CMyD3D : private ID3DEventListener
{
protected:
	bool bDX9;

	union device    // Declare union type
	{
		void* ptr;
		IDirect3DDevice9*	dx9;
		//ID3D11Device*		dx11;
	} m_pDevice;

	IDirect3DStateBlock9*	m_pStateBlock;

	void OnPrePresent() 
	{
		if(bDX9)
		{
		  if(!m_pStateBlock) 
			m_pDevice.dx9->CreateStateBlock(D3DSBT_ALL, &m_pStateBlock); 

			m_pStateBlock->Capture();
				my->CallHook("PostDirectDraw");
			m_pStateBlock->Apply();
		}
	};

	void OnPostPresent() {};
	void OnPreReset() {
		SAFE_RELEASE(m_pStateBlock);
	};
	void OnPostReset() {};
	void OnPostBeginScene() {};

public:
	CMyD3D() 
	{
		m_pDevice.ptr	= NULL;
		m_pStateBlock	= NULL;

		if(gD3DSystem)
		{
			// Initialize the device
			m_pDevice.ptr = gD3DSystem->GetDevice();
			bDX9 = true;


			// the listeners will be called renderer thread.
			gD3DSystem->RegisterListener(this);
		}
	}

	~CMyD3D() 
	{
		if(gD3DSystem)
			gD3DSystem->UnregisterListener(this);

		SAFE_RELEASE(m_pStateBlock);
	}
};

#define D3DFVF_VERTEXFORMAT2D (D3DFVF_XYZRHW | D3DFVF_DIFFUSE | D3DFVF_TEX1)

struct VertexFormat
{
    FLOAT x, y, z, rhw;
    DWORD color;
    float u, v;
};

static CMyD3D *m_listener;
static IDirect3DDevice9 *m_device;
static int m_vertnum = 0;
static const int max_verts = 1024;
VertexFormat m_verts[max_verts];
static D3DCOLOR m_color;

//DirectX9::DirectX9(IDirect3DDevice9* pDevice)
LUALIB_FUNCTION(directx, Open)
{
	m_device = (IDirect3DDevice9 *)gD3DSystem->GetDevice();
	//m_device = static_cast<IDirect3DDevice9 *>(gEnv->pRenderer->EF_Query(EFQ_D3DDevice));

	m_vertnum = 0;

	for (int i = 0; i < max_verts; i++)
	{
		m_verts[i].z = 0.5f;
		m_verts[i].rhw = 1.0f;
	}

	if (m_listener)
	{
		delete m_listener;
		m_listener = nullptr;
	}
	
	m_listener = new CMyD3D();

	return 0;
}


LUALIB_FUNCTION(directx, SetTransform)
{
	m_device->SetTransform(my->ToEnum<D3DTRANSFORMSTATETYPE>(1),  (D3DMATRIX *)&my->ToMatrix44(2));

	return 0;
}

LUALIB_FUNCTION(directx, GetTransform)
{
	auto out = Matrix44();

	m_device->GetTransform(my->ToEnum<D3DTRANSFORMSTATETYPE>(1),  (D3DMATRIX *)&out);

	my->Push(out);

	return 1;
}

void Flush()
{
	if (m_vertnum > 0)
	{
		//DWORD old = 0;
		//m_device->GetFVF(&old);
		m_device->SetFVF(D3DFVF_VERTEXFORMAT2D);
		m_device->DrawPrimitiveUP(D3DPT_TRIANGLELIST, m_vertnum/3, &m_verts[0], sizeof(VertexFormat));
		//m_device->SetFVF(old);

		m_vertnum = 0;
	}
}

LUALIB_FUNCTION(directx, Begin)
{
	m_device->SetRenderState(D3DRS_ALPHABLENDENABLE, TRUE); 
	m_device->SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
	m_device->SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);

	m_device->SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
	m_device->SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
	m_device->SetSamplerState(0, D3DSAMP_MIPFILTER, D3DTEXF_NONE);

	m_device->SetSamplerState(0, D3DSAMP_ADDRESSU, D3DTADDRESS_CLAMP);
	m_device->SetSamplerState(0, D3DSAMP_ADDRESSV, D3DTADDRESS_CLAMP);

	m_device->SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
	m_device->SetTextureStageState(0, D3DTSS_COLORARG1,	D3DTA_TEXTURE);
	m_device->SetTextureStageState(0, D3DTSS_COLORARG2,	D3DTA_CURRENT);

	m_device->SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
	m_device->SetTextureStageState(0, D3DTSS_ALPHAARG1,	D3DTA_TEXTURE);
	m_device->SetTextureStageState(0, D3DTSS_ALPHAARG2,	D3DTA_CURRENT);

	m_device->SetTextureStageState(1, D3DTSS_ALPHAOP, D3DTOP_DISABLE);
	m_device->SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_DISABLE);
	
	return 0;
}

LUALIB_FUNCTION(directx, End)
{
	Flush();
	
	return 0;
}

void AddVert(int x, int y)
{
	if (m_vertnum >= max_verts - 1)
	{
		Flush();
	}

	m_verts[m_vertnum].x = (float)x;
	m_verts[m_vertnum].y = (float)y;
	m_verts[m_vertnum].color = m_color;

	m_vertnum++;
}



void AddVert(int x, int y, float u, float v)
{
    if ( m_vertnum >= max_verts - 1 )
    {
       Flush();
    }

    m_verts[m_vertnum].x = -0.5f + (float)x;
    m_verts[m_vertnum].y = -0.5f + (float)y;
    m_verts[m_vertnum].u = u;
    m_verts[m_vertnum].v = v;

    m_verts[m_vertnum].color = m_color;

    m_vertnum++;
}

LUALIB_FUNCTION(directx, AddVert)
{
	auto x = my->ToNumber(1);
	auto y = my->ToNumber(2);

	AddVert(x, y);

	return 0;
}

LUALIB_FUNCTION(directx, AddVertUV)
{
	auto x = my->ToNumber(1);
	auto y = my->ToNumber(2);
	
	auto u = my->ToNumber(3);
	auto v = my->ToNumber(4);

	AddVert(x,y,u,v);
	
	return 0;
}

LUALIB_FUNCTION(directx, DrawFilledRect)
{
	auto x = my->ToNumber(1);
	auto y = my->ToNumber(2);
	auto w = my->ToNumber(3);
	auto h = my->ToNumber(4);
	
	m_device->SetTexture(0, NULL);

	AddVert(x, y);
	AddVert(x + w, y);
	AddVert(x, y + h);

	AddVert(x + w, y);
	AddVert(x + w, y + h);
	AddVert(x, y + h);
	
	return 0;
}

LUALIB_FUNCTION(directx, SetDrawColor)
{
	auto r = my->ToNumber(1);
	auto g = my->ToNumber(2);
	auto b = my->ToNumber(3);
	auto a = my->ToNumber(4);

	m_color = D3DCOLOR_ARGB((char)(a*255), (char)(r*255), (char)(g*255), (char)(b*255));
	
	return 0;
}

LUAMTA_FUNCTION(dxtexture, Remove)
{
	auto tex = my->ToPointer<IDirect3DTexture9>(1, "dxtexture");

	tex->Release();

	my->MakeNull(tex);

	return 0;
}

LUAMTA_FUNCTION(dxfont, Remove)
{
	auto font = (LPD3DXFONT)my->ToPointer<void *>(1, "dxfont");

	font->Release();

	my->MakeNull(font);

	return 0;
}

LUALIB_FUNCTION(directx, LoadFont)
{
	auto face_name = my->ToString(1);
	auto bold = my->ToBoolean(2);
	auto size = my->ToNumber(3);

	D3DXFONT_DESC fd;

	strcpy_s( fd.FaceName, LF_FACESIZE, face_name);

	fd.Width = 0;
	fd.MipLevels = 1;
	fd.CharSet = DEFAULT_CHARSET;
	fd.Height = size;
	fd.OutputPrecision = OUT_DEFAULT_PRECIS;
	fd.Italic = 0;
	fd.Weight = bold ? FW_BOLD : FW_NORMAL;
	fd.Quality = PROOF_QUALITY;
	fd.PitchAndFamily = DEFAULT_PITCH | FF_DONTCARE;

	LPD3DXFONT font;
	D3DXCreateFontIndirect(m_device, &fd, &font);
	
	RECT rctA = {0,0,0,0};
	font->DrawText(NULL, "A", -1, &rctA, DT_CALCRECT | DT_LEFT | DT_TOP | DT_SINGLELINE, 0);

	RECT rctSpc = {0,0,0,0};
	font->DrawText(NULL, "A A", -1, &rctSpc, DT_CALCRECT | DT_LEFT | DT_TOP | DT_SINGLELINE, 0);

	my->Push(font, "dxfont");
	my->Push(rctSpc.right - rctA.right * 2);
	
	return 2;
}

LUALIB_FUNCTION(directx, RenderText)
{
	auto font = (LPD3DXFONT)my->ToPointer<void *>(1, "dxfont");
	auto x = my->ToNumber(2);
	auto y = my->ToNumber(3);
	auto str = my->ToString(4);

	Flush();
	
	RECT ClipRect = { x, y, 0, 0 };
	font->DrawText(NULL, str, -1, &ClipRect, DT_LEFT | DT_TOP | DT_NOCLIP | DT_SINGLELINE, m_color);
	
	return 0;
}

LUALIB_FUNCTION(directx, MeasureText)
{
	auto font = (LPD3DXFONT)my->ToPointer<void *>(1, "dxfont");
	auto str = my->ToString(2);
	auto space_width = my->ToNumber(3, 0);

	if (strcmp(str, "") == 0)
	{
		RECT rct = {0,0,0,0};
		font->DrawText(NULL, "W", -1, &rct, DT_CALCRECT, 0);

		my->Push(0);
		my->Push(rct.bottom);
		
		return 2;
	}

	RECT rct = {0,0,0,0};
	font->DrawText(NULL, str, -1, &rct, DT_CALCRECT | DT_LEFT | DT_TOP | DT_SINGLELINE, 0);

	// 32 == space
	for (int i = strlen(str); i >= 0 && str[i] == 32; i--)
	{
		rct.right += space_width;
	}

	my->Push(rct.right);
	my->Push(rct.bottom);
	
	return 2;
}

LUALIB_FUNCTION(directx, StartClip)
{
	auto x = my->ToNumber(1);
	auto y = my->ToNumber(2);
	auto w = my->ToNumber(3);
	auto h = my->ToNumber(4);

	Flush();

	m_device->SetRenderState(D3DRS_SCISSORTESTENABLE, TRUE);

	RECT r;

	r.left = ceil((float)x);
	r.right = ceil((float)x + w);
	r.top = ceil((float)y);
	r.bottom = ceil((float)y + h);

	m_device->SetScissorRect(&r);
	
	return 0;
}

LUALIB_FUNCTION(directx, EndClip)
{
	Flush();
	m_device->SetRenderState(D3DRS_SCISSORTESTENABLE, FALSE);
	
	return 0;
}

LUALIB_FUNCTION(directx, LoadTexture)
{
	IDirect3DTexture9 *ptr = NULL;
	D3DXIMAGE_INFO params;
	
	HRESULT hr = D3DXCreateTextureFromFileEx(
		m_device, 
		my->ToString(1), 
		0, 
		0, 
		D3DX_DEFAULT, 
		0, 
		D3DFMT_UNKNOWN, 
		D3DPOOL_MANAGED, 
		D3DX_DEFAULT, 
		D3DX_DEFAULT, 
		0, &params, 
		NULL, 
		&ptr 
	);

	if ( hr != S_OK )
	{
		return 0;
	}

	my->Push(ptr, "dxtexture");

	return 1;
}

LUALIB_FUNCTION(directx, DrawTexturedRect)
{
	auto tex = my->ToPointer<IDirect3DTexture9>(1, "dxtexture");
	
	auto x = my->ToNumber(2);
	auto y = my->ToNumber(3);
	auto w = my->ToNumber(4);
	auto h = my->ToNumber(5);
	
	auto u1 = my->ToNumber(6);
	auto v1 = my->ToNumber(7);
	auto u2 = my->ToNumber(8);
	auto v2 = my->ToNumber(9);
	
	m_device->SetTexture(0, tex);

	AddVert(x, y, u1, v1);
	AddVert(x + w, y, u2, v1);
	AddVert(x, y + h, u1, v2);

	AddVert(x + w, y, u2, v1);
	AddVert(x + w, y + h, u2, v2);
	AddVert(x, y + h, u1, v2);
	
	return 0;
}

LUALIB_FUNCTION(directx, BeginContext)
{
	m_device->BeginScene();
	m_device->Clear(0, NULL, D3DCLEAR_TARGET | D3DCLEAR_ZBUFFER | D3DCLEAR_STENCIL, D3DCOLOR_XRGB(128, 128, 128), 1, 0);

	return 0;
}

LUALIB_FUNCTION(directx, EndContext)
{
	m_device->EndScene();
	
	return 0;
}

LUALIB_FUNCTION(directx, Clear)
{
	m_device->Clear(0, NULL, my->ToNumber(4, 0), D3DCOLOR_XRGB((char)my->ToNumber(1, 255), (char)my->ToNumber(2, 255), (char)my->ToNumber(3, 255)), my->ToNumber(5, 0), 0);

	return 0;
}