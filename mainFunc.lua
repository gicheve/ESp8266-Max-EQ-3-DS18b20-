
local boiler = gpio.read(1)
local pump = gpio.read(2)

if connSucc > 0 then   
	if tonumber(temprtbl[1]) < (temphigh-tonumber(temprtbl[5]/4)) and (valveb >25) then
		boiler = 1
	end    
	if (tonumber(temprtbl[2]) > (templow-tonumber(temprtbl[5]/3))) then 
		boiler = 0
	end	   
 	if (valveb >= valvepos) and (errorv == 0 ) then
 			pump = 1
 	else
 			pump = 0
	end
	if temphigh == 0 then 	-- Buffer OFF; start burner from valve position
		boiler = pump
		if 	(tonumber(temprtbl[4]) > 6000) then
			pump = 1
		else
			pump = 0    
		end 
    end
else 
pump=0
boiler = 0
end
if manoff == 1 then
	boiler = 0
end
if ( PumpTest == 1) then
	pump = 1
end
gpio.write(1,boiler)
gpio.write(2,pump)


