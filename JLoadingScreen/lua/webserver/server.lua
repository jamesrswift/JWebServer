--[[
	webserver/server.lua
]]

require( "bromsock");

webserver.server = {};
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
	clientsock:SetCallbackReceive( server.Receive )
	clientsock:SetCallbackSend( function() print("we sent something") end )
	clientsock:SetCallbackDisconnect( server.Disconnect )
	
	clientsock:SetTimeout(5000) -- timeout send/recv commands in 1 second. This will generate a Disconnect event if you're using callbacks
	
	clientsock:ReceiveUntil("\r\n\r\n")
	serversock:SetCallbackSend( function() print("we sent something") end )
	serversock:Accept()
end

function server.Receive( sock, packet )
	webserver.HTTP.HandleRequest( sock, packet:ReadStringAll() )
end

function server.Disconnect( sock )
	sock:Accept()
end

function server.IP() return server.server:GetIP() end
function server.Port() return server.server:GetPort() end

server.New( )