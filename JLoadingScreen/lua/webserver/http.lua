--[[
	webserver/http.lua
]]

webserver.HTTP = webserver.HTTP or {};
local HTTP = webserver.HTTP;

function HTTP.HandleRequest( socket, sPacketContents )

	local header = string.Explode( "\r\n", sPacketContents );
	
	local request_line = header[1];
	table.remove( header, 1 ); -- Request Line
	table.remove( header, #header ); -- Empty
	
	local request = HTTP.HandleRequestLine( request_line );
	local headers = HTTP.ManageHeaders( HTTP.HandleRequestHeaders( header ) );
	
	HTTP.HandleResponse( socket, request, headers );
	
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

	local r_tHeaders = {};

	for header, value in pairs( tHeaders ) do
		local x = string.Explode( ",", value );
		r_tHeaders[ header ] = x;
		
		for k,v in pairs( r_tHeaders[ header ] ) do
			local value, q = string.match ( v, "(.*);q=(%d*%.?%d?)" );
			if ( value ) then
				r_tHeaders[ header ][ k ] = { value = value, q = tonumber(q) }
			end
		end
		if (#r_tHeaders[ header ] == 1) then r_tHeaders[ header ] = value; end
	end
	
	return r_tHeaders;

end

function HTTP.HandleResponse( socket, request, headers )

	HTTP.ReturnCode = "200 OK"
	HTTP.Headers = {}
	HTTP.HeaderPacket = BromPacket();
	HTTP.ResponsePacket = BromPacket();
	
	local URI = HTTP.ManageGetVariables( request );
	if( string.EndsWith( URI, "/" ) ) then URI = URI .. "index.lua"; end
	
	if ( /*file.Exists( "webserver/www"..request, "LUA" )*/ false ) then
		
		
	else
		include( "webserver/www-private/404.lua" );
	end

	HTTP.BuildHeaders();
	HTTP.Respond( socket )
end

function HTTP.BuildHeaders()

	HTTP.HeaderPacket:WriteLine( "HTTP/1.1 " .. HTTP.ReturnCode );

	for header, value in pairs( HTTP.Headers ) do
		HTTP.HeaderPacket:WriteLine( header .. ": " .. value );
	end
	
	HTTP.HeaderPacket:WriteLine( "server: JWebServer 1.00/" .. jit.os );
	HTTP.HeaderPacket:WriteLine( "Content-Length: " .. HTTP.ResponsePacket:OutPos() );
	HTTP.HeaderPacket:WriteLine( "Connection: close");
	HTTP.HeaderPacket:WriteLine( "" );
	
end

function HTTP.WriteHeader( Header, value )
	HTTP.Headers[ Header ] = value;
end

function HTTP.Write( ... )
	for k,v in ipairs( {...} ) do
		HTTP.ResponsePacket:WriteStringRaw( v );
	end
end

function HTTP.SetReturnCode( Code ) HTTP.ReturnCode = Code end

function HTTP.ManageGetVariables( URI )

	HTTP.GET = {}
	local x = string.Explode( "?", URI )
	if ( x[2] ) then
		for k,v in pairs( string.Explode( "&", x[2] ) ) do
			local y = string.Explode( "=", v )
			for y1_safe in string.gmatch( y[1], "%%(%x%x)" ) do
				y[1] = string.gsub( y[1], "%%" .. y1_safe, string.char( tonumber(y1_safe,16) ) );
			end
			
			for y2_safe in string.gmatch( y[2], "%%(%x%x)" ) do
				y[2] = string.gsub( y[2] or "", "%%" .. y2_safe, string.char( tonumber(y2_safe,16) ) );
			end
			HTTP.GET[ y[1] ] = y[2];
		end
	end
	
	return x[1]
	
end

function HTTP.Respond( socket )
	local p = BromPacket();
	p:WritePacket(HTTP.HeaderPacket);
	p:WritePacket(HTTP.ResponsePacket);
	
	socket:Send(p, true);
end