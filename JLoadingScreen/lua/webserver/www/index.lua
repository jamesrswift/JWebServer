--[[
	www/index.lua
]]

webserver.HTTP.Write( [[
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
<title>OMG IT WORKS</title>
<style type="text/css">
    body { color: #000000; background-color: #FFFFFF; }
    a:link { color: #0000CC; }
    p, address {margin-left: 3em;}
    span {font-size: smaller;}
</style>
</head>

<body>
<h1>OMG IT WORKS</h1>
<p>


    Do I get a cookie?
  

</p>

<h2>200 OK</h2>
<address>
  <span>]])
  
webserver.HTTP.Write( "JWebServer 1.00/" .. jit.os .. [[/Lua ]] .. " on port " .. webserver.server.Port() .. [[</span>
</address>
</body>
</html>]] );