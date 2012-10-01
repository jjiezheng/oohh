#include "StdAfx.h"
#include "oohh.hpp"
#include "ICryPak.h"

string base = "../";


LUALIB_FUNCTION(file, GetFullPath)
{
	TCHAR buffer[MAX_PATH] = TEXT(""); 
	GetFullPathName(my->ToString(1), MAX_PATH, buffer, NULL);
		
	my->Push(buffer);

    return 1;
}

LUALIB_FUNCTION(file, OpenPacks)
{
	my->Push(gEnv->pCryPak->OpenPacks(my->ToString(1), ICryPak::FLAGS_PATH_REAL));

    return 1;
}


LUALIB_FUNCTION(file, SetAlias)
{
	gEnv->pCryPak->SetAlias(my->ToString(1), my->ToString(2), true);

    return 0;
}

LUALIB_FUNCTION(file, RemoveAlias)
{
	gEnv->pCryPak->SetAlias(my->ToString(1), my->ToString(2), false);

    return 0;
}

LUALIB_FUNCTION(file, OpenPak)
{
    my->Push(gEnv->pCryPak->OpenPack(my->ToString(1)));

    return 1;
}
LUALIB_FUNCTION(file, ClosePak)
{
    my->Push(gEnv->pCryPak->ClosePack(my->ToString(1)));

    return 1;
}

LUALIB_FUNCTION(file, ExistsInPak)
{
    my->Push(gEnv->pCryPak->IsFileExist(my->ToString(1)));

    return 1;
}
    
LUALIB_FUNCTION(file, FindInPak)
{
    _finddata_t fd;
    intptr_t handle = gEnv->pCryPak->FindFirst(my->ToString(1), &fd);

    my->NewTable();

    if (handle > -1)
    {
        int index = 0;

        do
        {
            index ++;

            string name = fd.name;

            if (name == (string)"." || name == (string)"..") continue;

            my->Push((const char *)name);

            my->NewTable();
				my->SetMember(-1, "attribute", (int)fd.attrib);
				my->SetMember(-1, "name", name);
				my->SetMember(-1, "size", (int)fd.size);
				my->SetMember(-1, "accessed", (int)fd.time_access);
				my->SetMember(-1, "created", (int)fd.time_create);
				my->SetMember(-1, "modified", (int)fd.time_write);
            my->SetTable(-3);

        } while (gEnv->pCryPak->FindNext(handle, &fd) >= 0);
    }

    return 1;
}