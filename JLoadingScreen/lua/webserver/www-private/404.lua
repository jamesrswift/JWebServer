--[[
	404.lua
]]

webserver.HTTP.WriteHeader( "HTTP/1.1 404 Not Found" );
webserver.HTTP.WriteHeader( "Content-Type: text/html" );
webserver.HTTP.WriteHeader( "server: JWebServer 1.00/" .. jit.os );

webserver.HTTP.Write( [[
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
<title>Object not found!</title>
<style type="text/css">
    body { color: #000000; background-color: #FFFFFF; }
    a:link { color: #0000CC; }
    p, address {margin-left: 3em;}
    span {font-size: smaller;}
</style>
</head>

<body>
<h1>Object not found!</h1>
<p>


    The requested URL was not found on this server.

  

    If you entered the URL manually please check your
    spelling and try again.

  

</p>

<h2>Error 404</h2>
<address>
  <span>]])
  
webserver.HTTP.Write( "JWebServer 1.00/" .. jit.os .. [[</span>
</address>
</body>
</html>]] );