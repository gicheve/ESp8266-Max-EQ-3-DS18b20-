-- LCD text switching
tHu = 1

-- setup SPI and connect display
function init_spi_display()
    -- Hardware SPI CLK  = GPIO14
    -- Hardware SPI MOSI = GPIO13
    -- Hardware SPI MISO = GPIO12 (not used)
    -- Hardware SPI /CS  = GPIO15 (not used)
    -- CS, D/C, and RES can be assigned freely to available GPIOs
    local cs  = 8 -- GPIO15, pull-down 10k to GND
    local dc  = 4 -- GPIO2
    local res = 0 -- GPIO16

    spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, 8, 8)
    -- we won't be using the HSPI /CS line, so disable it again
    gpio.mode(8, gpio.INPUT, gpio.PULLUP)

    disp = u8g.pcd8544_84x48_hw_spi(cs, dc, res)
end


-- graphic test components
function prepare()
    disp:setFont(u8g.font_6x12)
    disp:setFontRefHeightExtendedText()
    disp:setDefaultForegroundColor()
    disp:setFontPosTop()
end

init_spi_display()

function lcd_print()
--    lcdtemp = value["temp1"]..""
--    print(lcdtemp.."*")
    disp:firstPage()
    prepare()
    if connSucc > 0 then
        if (tHu == 1) then
            repeat
                disp:drawStr(0,0,"   SETTINGS")
				if wifi.sta.getip() ~= nil  then        
				   disp:drawStr(0,9,wifi.sta.getip())
				else
					disp:drawStr(0,9,"  WiFi ERROR")
          if connSucc > 0 then
            tm = rtctime.epoch2cal(rtctime.get()+10800)
            tm = string.format("%02d-%02d-%02d %02d:%02d", tm["day"], tm["mon"], tm["year"], tm["hour"], tm["min"])
          end
          connSucc = 0          
				end
                
                disp:drawStr(0,18,"Buff.UP  "..Conv(temphigh- temprtbl[5]/4))
                disp:drawStr(0,27,"Buff.DN  "..Conv(templow- temprtbl[5]/3))
                if string.len(valvepos.."") == 2 then
                    disp:drawStr(0,36,"Valve %     "..valvepos)
                elseif string.len(valvepos.."") == 1 then
                    disp:drawStr(0,36,"Valve %      "..valvepos)
                end                
            until disp:nextPage() == false
            tHu = tHu + 1
        elseif (tHu % 2 == 0) then
            repeat
                disp:drawStr(0,0,"TBuf.UP "..Conv(temprtbl[1]))
                disp:drawStr(0,9,"TBuf.DN "..Conv(temprtbl[2]))
                disp:drawStr(0,18,"TLoop   "..Conv(temprtbl[3]))
                disp:drawStr(0,27,"TBoiler "..Conv(temprtbl[4]))
                if (gpio.read(1) == 1) then
                    disp:drawStr(0,36,"Boiler      ON")
                else
                    disp:drawStr(0,36,"Boiler     OFF")
                end
            until disp:nextPage() == false
            tHu = tHu + 1
        elseif (tHu % 2 ~= 0) then
            repeat
                disp:drawStr(0,0,"THall    "..Conv(temphall))
                disp:drawStr(0,9,"TOut    "..Conv(temprtbl[5]))
                if string.len(valveb.."") == 3 then
                    disp:drawStr(0,18,"Valve %    "..valveb)
                elseif string.len(valveb.."") == 2 then
                    disp:drawStr(0,18,"Valve %     "..valveb)
                elseif string.len(valveb.."") == 1 then
                    disp:drawStr(0,18,"Valve %      "..valveb)
                end                
--                disp:drawStr(0,27,"Valve ERR    "..errorv)
				disp:drawStr(0,27,"Mode "..((errorv == 1 and "    ERROR") or (manoff == 1 and errorv == 0 and "      OFF") or (manoff == 0 and errorv == 0 and "     AUTO") or ""))
                if (gpio.read(2) == 1) then
                    disp:drawStr(0,36,"Pump        ON")
                else
                    disp:drawStr(0,36,"Pump       OFF")
                end
            until disp:nextPage() == false
			tHu = tHu + 1
            if tHu == 8 then
                tHu = 1
			end
--            print ("TLCD "..temphall)
        end    
    else
        repeat
            if wifi.sta.getip() ~= nil  then        
               disp:drawStr(0,0,wifi.sta.getip())
            else
              disp:drawStr(0,0,"  WiFi ERROR")
            end
            disp:drawStr(0,9,"  CONN ERROR")
            disp:drawStr(0,27,"  "..tm:sub(1,10))
            disp:drawStr(0,36,"    "..tm:sub(12,-1))
        until disp:nextPage() == false
    end
end

--lcd_print()
