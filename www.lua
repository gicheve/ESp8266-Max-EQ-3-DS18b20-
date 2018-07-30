function Conv(conv)
    local conv = tostring(conv)
	local tempstr = (conv):sub(1,-3) ..".".. (conv):sub(-2,-1)
    return tempstr
end

local tSpeakTmr = 0
PumpTest = 0
dofile("getData.lua")
dofile("LCDlib.lua") 
dofile("ds1820.lua")                    
tmr.alarm(2, 2000, 0, function()
    dofile("mainFunc.lua")
	lcd_print()
end)

tmr.alarm(1, 60000, 1, function()
  if wifi.sta.getip() ~= nil  then
    dofile("getData.lua")
    dofile("ds1820.lua")
    tmr.alarm(2, 2000, 0, function()
      if (temphall > 0) then
        dofile("mainFunc.lua")
        if (tSpeakTmr >= 5) and (connSucc > 0) then
            dofile("sendData.lua")
            tSpeakTmr = 0
        end
      end
    end)
    tSpeakTmr = tSpeakTmr + 1
  end
end)

tmr.alarm(5, 10000, 1, function()
    lcd_print()
end)


srv=net.createServer(net.TCP,10)
wifi.sta.sleeptype(wifi.NONE_SLEEP)
srv:listen(80,function(conn)
    conn:on("receive", function(conn,request)
        print("In conn")
        buf = "";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
		local _, _, auth = string.find(request, "%cAuthorization: Basic ([%w=\+\/]+)");--Authorization:
		  if (auth == nil or auth ~= "dXNlcjoxMjM0")then --user:1234
               conn:send("HTTP/1.1 401 Authorization Required\r\nWWW-Authenticate: Basic realm=\"NodeMCU\"\r\n\r\n<h1>Access DENIED</h1>");
               return;
          end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=([%w.]+)&*") do
                _GET[k] = v
            end
        end
      
        if(_GET.config == "SET")then
            print("Setup")
            dofile("setup.lua")
        else
			if(_GET.configuration)then
				valvepos = tonumber(_GET.valvepos)
				templow = tonumber(_GET.templow)
				temphigh = tonumber(_GET.temphigh)
				confdev = _GET.confdev
				cubeIP = _GET.cubeIP
				cubeResString = _GET.cubeResString
				dofile("writeconfig.lua")
			elseif (_GET.CUBERESET)then
				local rSocket = net.createUDPSocket()
				rSocket:send(23272,cubeIP,cubeResString.."\r\n")      
				print("Cube reset")  
			elseif(_GET.PUMPON)then
				gpio.write(2, gpio.HIGH)  
				PumpTest=1
			elseif(_GET.PUMPOFF)then
				gpio.write(2, gpio.LOW)
				PumpTest=0
			elseif(_GET.MANOFF)then
				manoff = tonumber(_GET.MANOFF)
				if manoff == 1 then
					gpio.write(1, gpio.LOW)
				end
				dofile("writeconfig.lua")
			end
			dofile("mainPage.lua")
--        print(buf)
		  end
		conn:send(buf);
    end)
	conn:on("sent", function(conn) conn:close() print("Out conn") end)
    collectgarbage();
    buf = "";
end)
