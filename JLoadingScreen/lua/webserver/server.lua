--[[
	webserver/server.lua
]]

require( "bromsock");

webserver.server = webserver.server or {};
local server = webserver.server;

function server.New( )
	if ( server.server ) then server.server:Close() end
	server.server = BromSock();
	
	if (not server.server:Listen(80)) then
		print("[BS:S] Failed to listen!")
	else
		print("[BS:S] Server listening...")
	end

	
	server.server:SetCallbackAccept( server.Accept )
	server.server:Accept()

end

function server.Accept( serversock, clientsock )
	serversock:Accept()
	
	clientsock:SetCallbackReceive( function(s, p)
		webserver.HTTP.HandleRequest( clientsock, p:ReadStringAll() )
	end	)
	
	clientsock:SetCallbackSend(function()
		print("we sent something")
		clientsock:Close()
	end)
	
	clientsock:SetTimeout(5000) -- timeout send/recv commands in 1 second. This will generate a Disconnect event if you're using callbacks
	
	clientsock:ReceiveUntil("\r\n\r\n")
end

function server.IP() return server.server:GetIP() end
function server.Port() return server.server:GetPort() end

server.New( )