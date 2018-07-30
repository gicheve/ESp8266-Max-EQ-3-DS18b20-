file.remove("config.lua")
if file.open("config.lua", "a+") then
    file.writeline('valvepos = '..valvepos)
    file.writeline('templow = '..templow)
    file.writeline('temphigh = '..temphigh)
    file.writeline('confdev = "'..confdev..'"')
    file.writeline('cubeIP = "'..cubeIP..'"')
    file.writeline('cubeResString = "'..cubeResString..'"')
	file.writeline('manoff = '..manoff)
    file.close()
end
