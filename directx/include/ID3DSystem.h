/* 
* Copyright (c) 2012, Hendrik Polczynski
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
* 1. Redistributions of source code must retain the above copyright
*    notice, this list of conditions and the following disclaimer.
* 2. Redistributions in binary form must reproduce the above copyright
*    notice, this list of conditions and the following disclaimer in the
*    documentation and/or other materials provided with the distribution.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF THIRD PARTY RIGHTS. IN
* NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
* DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
* OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
* OR OTHER DEALINGS IN THE SOFTWARE.
*
* This work is licensed under a Creative Commons Attribution 3.0 Unported License.
* http://creativecommons.org/licenses/by/3.0/
*
* You are free:
*   to Share — to copy, distribute and transmit the work
*   to Remix — to adapt the work
*   to make commercial use of the work 
*
* Under the following conditions:
*   Attribution — You must attribute the work in the manner specified by the author or licensor
*   (but not in any way that suggests that they endorse you or your use of the work)
*/

#pragma once

#include <CryExtension/CryCreateClassInstance.h>
#include <CryExtension/ICryUnknown.h>
#include <IEngineModule.h>

#define EXTENSION_D3D_SYSTEM_FILE TEXT("Plugin_D3DSystem.dll")

#define EXTENSION_D3D_SYSTEM "D3DSystem"
#define EXTENSION_D3D_SYSTEM_MODULE EXTENSION_D3D_SYSTEM "Module"

enum eD3DType {
	D3D_NONE,
	D3D_DX9,
	D3D_DX11,
};

struct ID3DEventListener
{
	virtual void OnPrePresent() = 0;
	virtual void OnPostPresent() = 0;
	virtual void OnPreReset() = 0;
	virtual void OnPostReset() = 0;
	virtual void OnPostBeginScene() = 0;
};

struct ID3DSystemC
{
	virtual void ActivateEventDispatcher(bool bActivate = true) = 0;
	virtual void RegisterListener(ID3DEventListener* item) = 0;
	virtual void UnregisterListener(ID3DEventListener* item) = 0;

	virtual void* GetSwapChain() = 0; // DX11 only
	virtual void* GetDeviceContext() = 0; // DX11 only
	virtual void* GetDevice() = 0;

	virtual eD3DType GetType() = 0;

	virtual ITexture* CreateTexture(void** pD3DTextureDst, int width, int height, int numMips, ETEX_Format eTF, int flags) = 0;
	virtual ITexture* InjectTexture(void* pD3DTextureSrc, int nWidth, int nHeight, ETEX_Format eTF, int flags) = 0;
};

struct ID3DSystem : public ICryUnknown
{
	CRYINTERFACE_DECLARE(ID3DSystem, 0xB1C4DC106CBB48E4, 0xB9A2115A07011487)

	virtual void ActivateEventDispatcher(bool bActivate = true) = 0;
	virtual void RegisterListener(ID3DEventListener* item) = 0;
	virtual void UnregisterListener(ID3DEventListener* item) = 0;

	virtual void* GetSwapChain() = 0; // DX11 only
	virtual void* GetDeviceContext() = 0; // DX11 only
	virtual void* GetDevice() = 0;

	virtual eD3DType GetType() = 0;

	virtual ITexture* CreateTexture(void** pD3DTextureDst, int width, int height, int numMips, ETEX_Format eTF, int flags) = 0;
	virtual ITexture* InjectTexture(void* pD3DTextureSrc, int nWidth, int nHeight, ETEX_Format eTF, int flags) = 0;
};

typedef boost::shared_ptr<ID3DSystem> ID3DSystemPtr;

// Forces you to declare global D3DSystem when including ID3DSystem
#ifndef D3DSYSTEM_EXPORTS
extern ID3DSystemPtr gD3DSystem;
#endif