
buf = "HTTP/1.1 200 OK\r\n".. 
              "Content-Type: text/html\r\n"..
              "Accept: */*\r\n"..
              "\r\n"
buf = buf.."<html>\r\n<head>\r\n<META http-equiv=\"Content-Type\" content=\"text/html; charset=windows-1251\">\r\n<title>Home Automation</title>\r\n";
buf = buf.."<meta name=\"viewport\" content=\"width=device-width, height=device-height, target-densitydpi=high-dpi, initial-scale=1.0\">\r\n";
buf = buf.."</head><body>";
buf = buf.."<h1>Config</h1>";
          
buf = buf.."<form method=\"GET\" name=\"SETUP\">";
buf = buf.."<p><input type=\"hidden\" name=\"configuration\" value=\"1\"></p>";
buf = buf.."<table><tr><td>Параметър</td><td>Стойност</td></tr>";  
buf = buf.."<tr><td>T Буфер горе</td><td><input type=\"text\" name=\"temphigh\" value=\""..temphigh.."\"></td></tr>";
buf = buf.."<tr><td>T Буфер долу</td><td><input type=\"text\" name=\"templow\" value=\""..templow.."\"></td></tr>";
buf = buf.."<tr><td>Упр. Трипътен</td><td><input type=\"text\" name=\"confdev\" value=\""..confdev.."\"></td></tr>";
buf = buf.."<tr><td>Мин. позиция</td><td><input type=\"text\" name=\"valvepos\" value=\""..valvepos.."\"></td></tr>";
buf = buf.."<tr><td>Cube IP</td><td><input type=\"text\" name=\"cubeIP\" value=\""..cubeIP.."\"></td></tr>";
buf = buf.."<tr><td>Cube Res</td><td><input type=\"text\" name=\"cubeResString\" value=\""..cubeResString.."\"></td></tr>";

buf = buf.."</table><p><input type=\"submit\" value=\"SEND\"></form><a href=\".\"><button>Cancel</button></a></p>";
buf = buf.."</body></html>";
--print(buf)
             
