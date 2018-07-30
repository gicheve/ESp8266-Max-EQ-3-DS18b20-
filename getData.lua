--value = {}
devcount = 0

if connSucc > 0 then
    connSucc = connSucc - 1
    tm = nil
end
if connSucc ==0 and not tm then
  tm = rtctime.epoch2cal(rtctime.get()+10800)
  tm = string.format("%02d-%02d-%02d %02d:%02d", tm["day"], tm["mon"], tm["year"], tm["hour"], tm["min"])
end

local gconn = net.createConnection(net.TCP,0)
 
gconn:on("connection",function(gconn, payload)
    print("Connected")
    connSucc = 4
    tm = nil
    gconn:send("\r\n")
end)

gconn:on("receive",function(gconn, payload)
--  print(payload)
    if (payload:match("L:")) then
--       print(payload)
       local LLoad = payload:sub(3,-3)
--       print(LLoad)
       LLoad = encoder.toHex(encoder.fromBase64(LLoad))
--       print(LLoad)

       temphall = 0
       errorv = 0
       valveb = 0
       
       while LLoad:len() > 0 do
           -- check len and trim
           devcount = devcount + 1
           local tempdata = LLoad:sub(1,(tonumber(LLoad:sub(1,2),16)+1)*2)
--           print(tempdata)
--           print(tempdata:len())
           LLoad = LLoad:sub(((tonumber(LLoad:sub(1,2),16)+1)*2)+1)
           if not (value["name"..devcount]) then
                value["name"..devcount] = "name"..devcount
           end 
--           print (tempdata:sub(3,8))
		   value["addr"..devcount] = tempdata:sub(3,8)
           if (tempdata:len() == 24) then              
                value["valve"..devcount] = tonumber(tempdata:sub(15,16),16)
                value["temp"..devcount] = tonumber(tempdata:sub(17,18),16)*50
                value["flag"..devcount] = tonumber(tempdata:sub(12,12),16)
                value["error"..devcount] = ((bit.isset(value["flag"..devcount],3)) and 1 or 0)
                if ((tempdata:sub(3,8) == confdev)) then
                    valveb = tonumber(tempdata:sub(15,16),16)
                    if value["error"..devcount] > 0 then 
                       errorv = 1
                    end   
--                    print ("addr2 "..confdev)
--                    print ("valve "..valveb)
 --                   print ("errorv "..errorv)
                end    
           end
           if (tempdata:len() == 26) then
                value["valve"..devcount] = 0
                value["temp"..devcount] = tonumber(tempdata:sub(25,26),16)
                value["flag"..devcount] = tonumber(tempdata:sub(13,13),16)
                
                if (tonumber(tempdata:sub(17,18),16) >= 128) then
                     value["temp"..devcount] = (value["temp"..devcount] + 256)
                end
                
                value["temp"..devcount] = value["temp"..devcount] *10
                value["error"..devcount] = ((bit.isset(value["flag"..devcount],2)) and 1 or 0)
                temphall = value["temp"..devcount]
                if value["error"..devcount] > 0 then 
                   errorv = 1
                end

           end
       end     
    end
end)
gconn:on("sent", function(gconn) gconn:close() print ( "Disconnected") collectgarbage() end)
gconn:connect(62910, cubeIP)


