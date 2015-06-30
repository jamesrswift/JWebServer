--[[
	webserver/mime.lua
]]

webserver.MIME = webserver.MIME or {};
local MIME = {};

MIME.Types = {};

function MIME.AddType( Extensions, ContentType )
	table.insert( MIME.Types, {Extensions = Extensions, ContentType = ContentType} );
end

function MIME.SelectType( URI )

	local extension = string.match( string.lower(URI), ".(%a+)$" );

	for k, mime in pairs( MIME.Types ) do
		if table.HasValue( v.Extensions, extension ) then
			return v.ContentType
		end
	end
	
	return "application/octet-stream";
end

-- Default Types

MIME.AddType( {"lua"}, "text/html" );
MIME.AddType( {"htm", "html"}, "text/html" );
MIME.AddType( {"css"}, "text/css" );