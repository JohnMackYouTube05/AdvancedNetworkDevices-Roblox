local module = {}
module.CLOCKNAME = "Hallway LED Clock"
module.FIRMWARE_VER = "1.8.5"
module.STARTINGMACADDR = "20496F"
module.DATECOLOR = Color3.fromRGB(255,0,0)
module.HMCOLOR = Color3.fromRGB(153,255,0)
module.SECCOLOR = Color3.fromRGB(153,255,0)

function module:ChangeClockName(name)
	module.CLOCKNAME = name
end

return module
--This is the universal settings module that can work for both clocks. No need to upload 2 seperate files when both of the clock types have the same settings module code.
