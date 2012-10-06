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

ID3DSystemPtr gD3DSystem;
bool InitD3DSystem(SSystemInitParams &startupParams)
{
	typedef boost::shared_ptr<IEngineModule> IEngineModulePtr;
	IEngineModulePtr	pModule;

	HINSTANCE hModule = CryLoadLibrary(EXTENSION_D3D_SYSTEM_FILE);

	if(hModule)
	{
		// Initialize use of CryExtension in module
		typedef void (*fInitSystem)(ISystem *, const char *);
		fInitSystem InitModuleFunc = (fInitSystem)CryGetProcAddress(hModule, "ModuleInitISystem");
		if(InitModuleFunc)
			InitModuleFunc(gEnv->pSystem, EXTENSION_D3D_SYSTEM_MODULE);

		// Create/Initialize Module
		if(CryCreateClassInstance(EXTENSION_D3D_SYSTEM_MODULE, pModule))
		{
			pModule->Initialize(*gEnv, startupParams);

			// Create/Initialize Module 
			if(CryCreateClassInstance(EXTENSION_D3D_SYSTEM, gD3DSystem))
				return true; // Success
		}
	}

	return false; // Failure
}