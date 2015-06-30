--[[
	webserver/http.lua
]]

webserver.HTTP = {}
local HTTP = webserver.HTTP;

function HTTP.HandleRequest( socket, sPacketContents )

	local header = string.Explode( "\r\n", sPacketContents );
	
	local request_line = header[1];
	table.remove( header, 1 ); -- Request Line
	table.remove( header, #header ); -- Empty
	
	local request = HTTP.HandleRequestLine( request_line );
	local headers = HTTP.ManageHeaders( HTTP.HandleRequestHeaders( header ) );
	
	HTTP.HandleResponse( socket, request, headers )
	
end

function HTTP.HandleRequestLine( sRequestLine )

	local method, request, version = unpack( string.Explode( " ", sRequestLine ) );
	
	-- I can't be bothered supporting more
	if ( method == "GET" and version == "HTTP/1.1" ) then
		return request;
	end

	return false;
	
end

function HTTP.HandleRequestHeaders( tHeaders )

	local r_tHeaders = {};

	for k,v in pairs( tHeaders ) do
		local x = string.Explode( ": ", v );
		r_tHeaders[ x[1] ] = x[2];
	end
	
	return r_tHeaders;
end

function HTTP.ManageHeaders( tHeaders )

	local r_tHeaders = {}

	for header, value in pairs( tHeaders ) do
		local x = string.Explode( ",", value )
		r_tHeaders[ header ] = x;
		
		for k,v in pairs( r_tHeaders[ header ] ) do
			local value, q = string.match ( v, "(.*);q=(%d*%.?%d?)" );
			if ( value ) then
				r_tHeaders[ header ][ k ] = { value = value, q = tonumber(q) }
			end
		end
		if (#r_tHeaders[ header ] == 1) then r_tHeaders[ header ] = value end
	end
	
	return r_tHeaders

end

function HTTP.HandleResponse( socket, request, headers )

	HTTP.HeaderPacket = BromPacket();
	HTTP.ResponsePacket = BromPacket();
	
	if( string.EndsWith( request, "/" ) ) then request = request .. "index.lua" end
	
	if ( /*file.Exists( "webserver/www"..request, "LUA" )*/ false ) then
		
		
	else
		include( "webserver/www-private/404.lua" );
	end

	HTTP.WriteHeader( "Content-Length: " .. HTTP.ResponsePacket:OutSize() )
	HTTP.HeaderPacket:WriteLine( "" )
	
	print( HTTP.HeaderPacket:OutSize() )
	print( HTTP.ResponsePacket:OutSize() )
	
	
	print( HTTP.HeaderPacket:Copy():InSize() )
	
	socket:Send(HTTP.HeaderPacket, true)
	socket:Send(HTTP.ResponsePacket, true)
	socket:Disconnect()
end

function HTTP.WriteHeader( Header )
	HTTP.HeaderPacket:WriteLine( Header )
end

function HTTP.Write( ... )
	for k,v in pairs( {...} ) do
		HTTP.ResponsePacket:WriteStringRaw( v )
	end
end
