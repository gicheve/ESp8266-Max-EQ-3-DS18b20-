# ESp8266-Max-EQ-3-DS18b20-
Here is my WiFi temperature controller based on ESP8266.

What it actually does:
1.	Connects to WiFi network
2.	Creates a TCP connection to MAX! EQ-3 cube and reads status
3.	Reads 5 temperature sensors DS18B20 for:
    a.	buffer UP
    b.	buffer Down
    c.	radiators Loop
    d.	Boiler
    e.	Outside
4.	Sends monitoring data to ThingSpeak
5.	Displays data on LCD screen
6.	Hosts a small HTTP server for configuration, data monitoring and control
7.	Triggers two relay outputs for starting boiler (heater) and pump depending on data and desired logic

Used parts:

-	WEMOS D1 mini
-	LCD display PCB 84x48 (Nokia 5110) 
-	DS18B20
-	Relay Shield
