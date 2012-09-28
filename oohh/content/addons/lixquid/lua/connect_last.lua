console.AddCommand( "connect_last", function()
	console.RunString( "connect " .. cookies.Get( "lastip", "localhost" ) )
end )