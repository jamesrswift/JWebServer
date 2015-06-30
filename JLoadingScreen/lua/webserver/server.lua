--[[
	webserver/server.lua
]]

require( "bromsock");

webserver.server = webserver.server or {};
local server = webserver.server;

function server.New( )
	if ( server.server ) then server.server:Close(); end
	server.server = BromSock();
	
	if (not server.server:Listen(80)) then
		print("[JWebServer] Failed to listen!");
	else
		print("[JWebServer] Server listening...");
	end

	
	server.server:SetCallbackAccept( server.Accept );
	server.server:Accept();

end

function server.Accept( serversock, clientsock )
	serversock:Accept();
	
	clientsock:SetCallbackReceive( function(s, p)
		webserver.HTTP.HandleRequest( clientsock, p:ReadStringAll() );
	end	);
	
	clientsock:SetCallbackSend(function()
		clientsock:Close();
	end);
	
	clientsock:SetTimeout(5000);
	clientsock:ReceiveUntil("\r\n\r\n");
end

function server.IP() return server.server:GetIP(); end
function server.Port() return server.server:GetPort(); end

server.New();