valvepos = 1
templow = 1
temphigh = 1
value = {}
confdev = "0ac28d"
connSucc = 0
cubeIP = "0.0.0.0"
manoff = 0
temprtbl = {0,0,0,0}


enduser_setup.start(
  function()
   tmr.alarm(1, 1000, 1, function()
     if wifi.sta.getip()== nil then
        print("IP unavaiable, Waiting...")
     else
        sntp.sync()
        wifi.sta.sleeptype(wifi.NONE_SLEEP)
        tmr.stop(1)
        enduser_setup.stop()
        print("Connected to wifi as:" .. wifi.sta.getip())
        print("ESP8266 mode is: " .. wifi.getmode())
        print("The module MAC address is: " .. wifi.ap.getmac())	  
  -- Start the WEB server
       print("Ready: "..rtctime.get())
       dofile("config.lua")
       dofile("www.lua")
    end
    end)
          end,
      function(err, str)
        print("enduser_setup: Err #" .. err .. ": " .. str)
        dofile("LCDlib.lua") 
        lcd_print()
      end,
    
  -- Lua print function can serve as the debug callback
    tmr.alarm(3, 60000, 0, function()
      if wifi.sta.getip()== nil then
         node.restart()
      end
    end)
  );

tmr.alarm(4, 3600000, 1, function()
    sntp.sync()
end)
