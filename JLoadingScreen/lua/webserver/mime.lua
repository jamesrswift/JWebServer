--[[
	webserver/mime.lua
]]

webserver.MIME = webserver.MIME or {};
local MIME = webserver.MIME;

MIME.Types = {};

function MIME.AddType( Extensions, ContentType )
	if ( type(Extensions) == "string" ) then
		MIME.Types[Extensions] = ContentType;
	else
		for k,v in pairs( Extensions ) do
			MIME.Types[v] = ContentType;
		end
	end
end

function MIME.SelectType( URI )

	local extension = string.match( string.lower(URI), "%.(%a+)$" );

	if ( MIME.Types[extension] ) then
		return extension, MIME.Types[extension];
	end
	
	return extension, "application/octet-stream";
end

-- Default Types

MIME.AddType( "lua", "text/html" );
MIME.AddType( {"htm", "html"}, "text/html" );
MIME.AddType( "css", "text/css" );