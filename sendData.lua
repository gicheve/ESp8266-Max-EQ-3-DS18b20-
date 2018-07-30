tmr.alarm(3, 15000, 1, function()
  local Sconn = nil
  Sconn = net.createConnection(net.TCP, 0)  
  Sconn:on("receive", function(Sconn, Spayload)
	if (string.find(Spayload, "Status: 200 OK")) ~= nil then
		if tonumber (string.match(Spayload, "-Length: (%d)")) > 1 then
				print("Posted OK");
				tmr.stop(3)
				Sconn:close()
				collectgarbage();
		end
    end
  end) 
  Sconn:on("connection", function(Sconn, Spayload)
	print ("Posting...");
	Sconn:send("GET /update?api_key=YOUR_KEY&&field1="..Conv(temphall).."&field2="..Conv(temprtbl[5]).."&field3="..valveb..
				"&field4="..Conv(temprtbl[3]).."&field5="..Conv(temprtbl[1]).."&field6="..Conv(temprtbl[2]).."&field7="..Conv(temprtbl[4])..
				"&field8="..gpio.read(1).." HTTP/1.1\r\n"..
				"Host: api.thingspeak.com\r\n"..
				"Connection: close\r\n"..
				"Accept: */*\r\n"..
				"User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n"..
				"\r\n") 
		end)
-- api.thingspeak.com 184.106.153.149 
  Sconn:connect(80,'184.106.153.149')
 end)
