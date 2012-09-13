$title = "[TITLE:CryDev Login - Free CryENGINE SDK [non-commercial use]]";

$found = 0;

while 1
	if WinExists($title) then
		if WinActive($title) = 0 then
			WinActivate($title);
		endif
		
		$found = 1;
		
		local $pos = WinGetPos($title);
		MouseClick("left", $pos[0] + 420, $pos[1] + 290, 1);
	Elseif $found Then
		Exit
	Endif
	
	Sleep(100);
wend