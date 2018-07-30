buf = "HTTP/1.1 200 OK\r\n".. 
              "Content-Type: text/html\r\n"..
              "Accept: */*\r\n"..
              "\r\n"
buf = buf.."<html>\r\n<head>\r\n<META http-equiv=\"Content-Type\" content=\"text/html; charset=windows-1251\">\r\n<title>Home Automation</title>\r\n";
buf = buf.."<meta name=\"viewport\" content=\"width=device-width, height=device-height, target-densitydpi=high-dpi, initial-scale=1.0\">\r\n";
buf = buf.."</head><body>";
buf = buf.."<h3>Nedevci</h3>";
buf = buf.."Cube is set on: "..cubeIP;

if (value["addr"..1]) then
   buf = buf.."<table border=1 cellspacing=0 cellpadding=5>";
   buf = buf.."<tr align=\"center\" bgcolor=\"#BBBBBB\"><td>Sensor ID</td><td>Valve %</td><td>Temp.</td><td>Error</td></tr>";
   i = 1
   while i <= devcount do
       buf = buf.."<tr align=\"center\"><td>"..value["addr"..i].."</td>";
       buf = buf.."<td>"..value["valve"..i].."</td>";
       buf = buf.."<td>"..Conv(value["temp"..i]).."</td>";
       buf = buf.."<td>"..value["error"..i].."</td></tr>";
       i = i + 1
   end
else
   buf = buf.."<tr align=\"center\"><td>No data</td></tr>"
end
buf = buf.."</table>"
buf = buf.."&nbsp"
buf = buf.."<table border=1 cellspacing=0 cellpadding=5>";
buf = buf.."<tr align=\"center\"><td bgcolor=\"#BBBBBB\">Set On</td>";
buf = buf.."<td bgcolor=\"#FACC2E\">"..(Conv(temphigh - temprtbl[5]/4)).."</td>";
buf = buf.."<td bgcolor=\"#BBBBBB\">Set Off</td>";
buf = buf.."<td bgcolor=\"#99ccff\">"..(Conv(templow - temprtbl[5]/3)) .."</td>";
buf = buf.."<tr align=\"center\"><td bgcolor=\"#BBBBBB\">Buff Up</td>";
buf = buf.."<td>"..Conv(temprtbl[1]).."</td>";
buf = buf.."<td bgcolor=\"#BBBBBB\">Buff Dn</td>";
buf = buf.."<td>"..Conv(temprtbl[2]).."</td>";
buf = buf.."</tr>";
buf = buf.."<tr align=\"center\"><td bgcolor=\"#BBBBBB\">T Loop</td>";
buf = buf.."<td>"..Conv(temprtbl[3]).."</td>";
buf = buf.."<td bgcolor=\"#BBBBBB\">T Boil</td>";
buf = buf.."<td>"..Conv(temprtbl[4]).."</td>";
buf = buf.."</tr>";
buf = buf.."<tr align=\"center\"><td bgcolor=\"#BBBBBB\">T Hall</td>";
buf = buf.."<td>"..Conv(temphall).."</td>";
buf = buf.."<td bgcolor=\"#BBBBBB\">T Out</td>";
buf = buf.."<td>"..Conv(temprtbl[5]).."</td>";
buf = buf.."</tr>";
buf = buf.."<tr align=\"center\"><td bgcolor=\"#BBBBBB\">Boiler</td>";
if (gpio.read(1) == 1) then
	buf = buf.."<td align=\"center\"bgcolor=\"#ff5050\"><b>  ON</b></td>";
else
    buf = buf.."<td align=\"center\"bgcolor=\"#99ccff\"><b>OFF</b></td>";
end
buf = buf.."<td bgcolor=\"#BBBBBB\">Pump</td>";
if (gpio.read(2) == 1) then
    buf = buf.."<td align=\"center\"bgcolor=\"#ff5050\"><b>  ON</b></td>";
else
    buf = buf.."<td align=\"center\"bgcolor=\"#99ccff\"><b>OFF</b></td>";
end

buf = buf.."</tr></table>";
buf = buf.."<p><a href=\"?config=SET\"><button>Config</button></a>&nbsp";
buf = buf.."<a href=\"?CUBERESET=1\"><button>Cube Reset</button></a>&nbsp";
if manoff == 0 then 
	buf = buf.."<a href=\"?MANOFF=1\"><button>AUTO-->OFF</button></a></p>";
else
	buf = buf.."<a href=\"?MANOFF=0\"><button>OFF-->AUTO</button></a></p>";
end
buf = buf.."<a href=\"?PUMPON=1\"><button>Pump ON</button></a>&nbsp";
buf = buf.."<a href=\"?PUMPOFF=1\"><button>Pump OFF</button></a>&nbsp";
buf = buf.."<a href=\".\"><button>Refresh</button></a>";
buf = buf.."</body></html>";
