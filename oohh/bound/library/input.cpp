#include "oohh.hpp"

LUALIB_FUNCTION(input, GetModifiers)
{
	my->Push(gEnv->pInput->GetModifiers());
    
    return 1;
}

LUALIB_FUNCTION(input, GetSymbolByName)
{
	auto symbol = gEnv->pInput->GetSymbolByName(my->ToString(1));
	my->Push((unsigned int)symbol->keyId);
    
    return 1;
}