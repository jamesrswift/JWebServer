--[[
	webserver/filesystem.lua
]]

webserver.filesystem = webserver.filesystem or {}
local filesystem = webserver.filesystem

function filesystem.HandleRequest( URI )

	if( string.EndsWith( URI, "/" ) ) then URI = URI .. "index.lua"; end
	
	if ( file.Exists( "webserver/www"..URI, "LUA" ) ) then
		
		local ext, mime = webserver.MIME.SelectType( URI )
		
		webserver.HTTP.SetReturnCode( "200 OK" );
		webserver.HTTP.WriteHeader( "Content-Type", mime );
		
		if ( ext == "lua" ) then
			include( "webserver/www"..URI )
		else
			webserver.HTTP.Write( file.Read( "webserver/www"..URI, "LUA" ) )
		end

	else
		webserver.HTTP.SetReturnCode( "404 Not Found" );
		include( "webserver/www-private/404.lua" );
	end


end