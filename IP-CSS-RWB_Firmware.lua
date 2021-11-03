--[[
------------------------------------------
		ADVANCED NETWORK DEVICES
			MAIN CLOCK SCRIPT
		   SCRIPT VERSION 1.9.0
		  WRITTEN BY YELLOWBOY111
__________________________________________
]]

gui = script.Parent.SurfaceGui
clock = script.Parent.Parent
currentFrame = 'LARGE_CLOCK'
MAC_ADDRESS_CHARS = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'}
settngs = require(script.Parent.Settings)
--INITIALIZE
function initialize()
	--Generate Random MAC Address
	local mac = settngs.STARTINGMACADDR
	for i = 1, 6 do
		mac = mac .. MAC_ADDRESS_CHARS[math.random(1, #MAC_ADDRESS_CHARS)]
	end
	gui.MAC_ADDR.MAC_ADDR.Text = mac
	gui.IP_ADDR.CLOCK_ID.Text = tostring(clock.ClockID.Value)
	changeScreen("ANET_DEVICE_LOGO") --Splash Screen
	wait(4)
	for _, i in pairs(workspace:GetDescendants()) do --Check if there are clock ID conflicts.
		if i.Name == "ClockID" and i:IsA("IntValue") then
			if i.Parent ~= clock then --Make sure the clock does not mark itself as an ID conflict.
				if i.Value == clock.ClockID.Value then 
					clock.ClockID.Value += 1
					break
				end
			end
		end 
	end
	gui.NET_INIT.SPINNING_SLASH.Spin.Disabled = false
	changeScreen("NET_INIT")
	wait(2)
	gui.NET_INIT.SPINNING_SLASH.Spin.Disabled = true
	changeScreen("IP_ADDR")
	wait(2)
	changeScreen("MAC_ADDR")
	wait(2)
	gui.FIRMWARE.CLOCK_ID.Text = settngs.FIRMWARE_VER
	changeScreen("FIRMWARE")
	wait(2)
	gui.SMALL_CLOCK.HourMinute.TextColor3 = settngs.HMCOLOR
	gui.SMALL_CLOCK.Seconds.TextColor3 = settngs.SECCOLOR
	gui.SMALL_CLOCK.Date.TextColor3 = settngs.DATECOLOR
	gui.LARGE_CLOCK.HourMinute.TextColor3 = settngs.HMCOLOR
	gui.LARGE_CLOCK.Seconds.TextColor3 = settngs.SECCOLOR
	changeScreen("SMALL_CLOCK")
end
--Screen Changer
function changeScreen(frameName)
	gui[currentFrame].Visible = false
	gui[string.upper(frameName)].Visible = true
	currentFrame = frameName
end

--Show custom scrolling message on the display.
function showMessage(player, msg)
	changeScreen('CUSTOMMESSAGE')
	gui.CUSTOMMESSAGE.Position = UDim2.new(2.5,0,0,0)
	gui.CUSTOMMESSAGE.Message.Text = msg
	gui.CUSTOMMESSAGE:TweenPosition(UDim2.new(-2.5,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 5, false)
	game.ReplicatedStorage.FireCommand:FireClient(player, 'Message from Clock #' .. clock.ClockID.Value .. ': [OK] Sent custom message to display. CONTENTS: ' .. msg)
	wait(6)
	changeScreen('SMALL_CLOCK')
end

--Command interpreter

function onCommandReceived(player, clockID, command, param)
	print(clockID)
	print(command)
	print(param)
	--print('Command Inbound from player ' .. player.Name .. ' for clock #' .. clockID .. '. Command: ' .. command .. ' Parameters: ' .. param)
	print(tonumber(clockID))
	if tonumber(clockID) == clock.ClockID.Value or clockID == 'all' then

		if string.match(string.lower(command), 'clock') then
			if string.lower(param) == 'small' then
				changeScreen('SMALL_CLOCK')
				game.ReplicatedStorage.FireCommand:FireClient(player, 'Message from Clock #' .. clock.ClockID.Value .. ': [OK] Changed to small clock overlay with date.')
			elseif string.lower(param) == 'large' then
				changeScreen('LARGE_CLOCK')
				game.ReplicatedStorage.FireCommand:FireClient(player, 'Message from Clock #' .. clock.ClockID.Value .. ': [OK] Changed to large clock overlay.')
			else
				game.ReplicatedStorage.FireCommand:FireClient(player, 'ERROR from Clock #' .. clock.ClockID.Value .. ': There is no valid clock mode associated with this parameter.')
				error('There is no valid clock mode associated with this parameter.')
			end
		elseif string.match(string.lower(command), 'alarm') then

			if string.lower(param) == 'lockdown' then
				gui.ALARMS.FIRE.Visible = false
				gui.ALARMS.LOCKDOWN.Visible = true
				gui.ALARMS.EVAC.Visible = false
				gui.ALARMS.HOLD.Visible = false
				gui.ALARMS.TEST.Visible = false
				gui.ALARMS.TORNADO.Visible = false
				gui.ALARMS.LOCKDOWN.Cycle.Disabled = false
				changeScreen("ALARMS")
				clock.Screen.BlinkBlueLight.Disabled = false
				game.ReplicatedStorage.FireCommand:FireClient(player, 'Message from Clock #' .. clock.ClockID.Value .. ': [OK] Set lockdown message, turned blue LED on.')
				for i = 1, 3 do
					clock.Speaker.LockdownAnnouncement:Play()
					wait(clock.Speaker.LockdownAnnouncement.TimeLength)
				end
			elseif string.lower(param) == 'tornado' then
				gui.ALARMS.FIRE.Visible = false
				gui.ALARMS.LOCKDOWN.Visible = false
				gui.ALARMS.EVAC.Visible = false
				gui.ALARMS.HOLD.Visible = false
				gui.ALARMS.TEST.Visible = false
				gui.ALARMS.TORNADO.Visible = true
				gui.ALARMS.LOCKDOWN.Cycle.Disabled = true
				gui.ALARMS.TORNADO.Cycle.Disabled = false
				changeScreen("ALARMS")
				clock.RedLight.Material = Enum.Material.Neon
				clock.RedLight.SpotLight.Enabled = true
				clock.Speaker.TornadoWarning:Play()
			elseif string.lower(param) == 'fire' then
				gui.ALARMS.FIRE.Visible = true
				gui.ALARMS.LOCKDOWN.Visible = false
				gui.ALARMS.EVAC.Visible = false
				gui.ALARMS.HOLD.Visible = false
				gui.ALARMS.TEST.Visible = false
				gui.ALARMS.TORNADO.Visible = false
				changeScreen("ALARMS")
				clock.WhiteLight.SlowBlink.Disabled = false
				clock.Speaker.FireAlarm:Play()
			elseif string.lower(param) == 'evac' or string.lower(param) == 'evacuate' then
				gui.ALARMS.FIRE.Visible = false
				gui.ALARMS.LOCKDOWN.Visible = false
				gui.ALARMS.EVAC.Visible = true
				gui.ALARMS.HOLD.Visible = false
				gui.ALARMS.TEST.Visible = false
				gui.ALARMS.TORNADO.Visible = false
				changeScreen("ALARMS")
				clock.WhiteLight.SlowBlink.Disabled = false
				clock.Speaker.EvacuationMessage:Play()
			elseif string.lower(param) == 'hold' then
				gui.ALARMS.FIRE.Visible = false
				gui.ALARMS.LOCKDOWN.Visible = false
				gui.ALARMS.EVAC.Visible = false
				gui.ALARMS.HOLD.Visible = true
				gui.ALARMS.TEST.Visible = false
				gui.ALARMS.TORNADO.Visible = false
				changeScreen("ALARMS")
				clock.WhiteLight.SlowBlink.Disabled = false
				clock.BlueLight.SpotLight.Enabled = true
				clock.BlueLight.Material = Enum.Material.Neon
			elseif string.lower(param) == 'test' then
				gui.ALARMS.FIRE.Visible = false
				gui.ALARMS.LOCKDOWN.Visible = false
				gui.ALARMS.EVAC.Visible = false
				gui.ALARMS.HOLD.Visible = false
				gui.ALARMS.TEST.Visible = true
				gui.ALARMS.TORNADO.Visible = false
				changeScreen("ALARMS")
				clock.RedLight.SlowBlink.Disabled = false
				clock.WhiteLight.SlowBlink.Disabled = false
				clock.Screen.BlinkBlueLight.Disabled = false
			elseif string.lower(param) == 'clear' then
				clock.RedLight.SlowBlink.Disabled = true
				clock.WhiteLight.SlowBlink.Disabled = true
				clock.Screen.BlinkBlueLight.Disabled = true
				clock.RedLight.Material = Enum.Material.SmoothPlastic
				clock.WhiteLight.Material = Enum.Material.SmoothPlastic
				clock.BlueLight.Material = Enum.Material.SmoothPlastic
				clock.RedLight.SpotLight.Enabled = false
				clock.WhiteLight.SpotLight.Enabled = false
				clock.BlueLight.SpotLight.Enabled = false

				gui.ALARMS.FIRE.Visible = false
				gui.ALARMS.LOCKDOWN.Visible = false
				gui.ALARMS.EVAC.Visible = false
				gui.ALARMS.HOLD.Visible = false
				gui.ALARMS.TEST.Visible = false
				gui.ALARMS.TORNADO.Visible = false
				gui.ALARMS.TORNADO.Cycle.Disabled = true
				gui.ALARMS.LOCKDOWN.Cycle.Disabled = true

				game.ReplicatedStorage.FireCommand:FireClient(player, 'Message from Clock #' .. clock.ClockID.Value .. ': [OK] Cleared LEDs, switching to all clear message.')
				clock.Speaker.FireAlarm:Stop()
				clock.Speaker.EvacuationMessage:Stop()
				clock.Speaker.AllClear:Play()
				showMessage(player, '<i>All clear. Please resume normal activities.</i>')
				clock.Speaker.AllClear:Play()
				showMessage(player, '<i>All clear. Please resume normal activities.</i>')
			end
		elseif string.match(string.lower(command), 'message') or string.match(string.lower(command), 'msg') then
			showMessage(player, param)
		elseif string.match(string.lower(command), 'setclockname') then
			if param == nil or param == "" then
				game.ReplicatedStorage.FireCommand:FireClient(player, "Message from Clock #" .. clock.ClockID.Value .. ": [ERROR] Name specified is empty. Please enter a string. (Example Usage: setclockname 'John Does IP Clock')")
			else
				settngs:ChangeClockName(param)
				game.ReplicatedStorage.FireCommand:FireClient(player, "Message from Clock #" .. clock.ClockID.Value .. ": [OK] Set name of clock to " .. param)

			end
		elseif string.match(string.lower(command), 'getclockname') then
			game.ReplicatedStorage.FireCommand:FireClient(player, "Message from Clock #" .. clock.ClockID.Value .. ': [OK] Clock name is set to ' .. settngs.CLOCKNAME)
		elseif string.match(string.lower(command), "help") then
			local help_list = {
				[1] = "ADVANCED NETWORK DEVICES",
				[2] = "HELP GUIDE",
				[3] = "every command is structured like this, with single quotes around parameters; <command> '<parameter>'",
				[4] = "The commands won't work without a parameter, wrapped in single quotes.",
				[5] = "Command List:",
				[6] = "clock - Changes the clock size. Accepted parameters are 'small' and 'large'.",
				[7] = "datecolor - Changes the text color of the TextLabel showing the date. Valid parameters are 'red', 'yellow', gold, and 'green'.",
				[8] = "hourminutecolor/hmcolor - Changes the text color of the TextLabel showing the current hour and minute. Valid parameters are 'red', 'yellow', 'gold', and 'green'.",
				[9] = "secondscolor/seccolor - Changes the text color of the TextLabel showing the seconds. Valid parameters are 'red', 'yellow', 'gold', and 'green'.",
				[10] = "playsound - Plays a custom sound with the specified sound ID. Usage: playsound '(Sound Id goes here)' To stop sound, send command playsound '0', or don't specify an ID.",
				[11] = "alarm - Turns on the corresponding LED, and plays the corresponding pixel image and sounds for a certain emergency situation.",
				[12] = "Accepted parameters for the alarm command are 'tornado', 'lockdown', and 'clear'.",
				[13] = "Passing 'clear' as your parameter will turn off all LEDs, and play a sound combined with a scrolling all clear message.",
				[14] = "message/msg - typing in either of these commands, followed by a relatively short message wrapped in single quotes will scroll that message across the clock ID specified.",
				[15] = "Rich text is allowed for custom messages, see the Roblox Devforum for more information on how to use Rich Text in Roblox.",
				[16] = "help - Displays this help menu."
			}

			for helpLine = 1, #help_list do
				game.ReplicatedStorage.FireCommand:FireClient(player, help_list[helpLine])
				wait(0.1)
			end

		elseif string.match(string.lower(command), "bell") then
			clock.Speaker.Bell:Play()
		elseif string.match(string.lower(command), "datecolor") then
			if string.match(string.lower(param), "red") then
				gui.SMALL_CLOCK.Date.TextColor3 = Color3.new(1,0,0)
				game.ReplicatedStorage.FireCommand:FireClient(player, "Set date text color to red.")
			elseif string.match(string.lower(param), "yellow") or string.match(string.lower(param), "gold") then
				gui.SMALL_CLOCK.Date.TextColor3 = Color3.fromRGB(255, 170, 0)
				game.ReplicatedStorage.FireCommand:FireClient(player, "Set date text color to yellow/gold.")
			elseif string.match(string.lower(param), "green") then
				gui.SMALL_CLOCK.Date.TextColor3 = Color3.fromRGB(153, 255, 0)
				game.ReplicatedStorage.FireCommand:FireClient(player, "Set date text color to green.")
			end
		elseif string.match(string.lower(command), "hourminutecolor") or string.match(string.lower(command), "hmcolor") then
			if string.match(string.lower(param), "red") then
				gui.SMALL_CLOCK.HourMinute.TextColor3 = Color3.new(1,0,0)
				gui.LARGE_CLOCK.HourMinute.TextColor3 = Color3.new(1,0,0)
				game.ReplicatedStorage.FireCommand:FireClient(player, "Set hour/minute color text to red.")
			elseif string.match(string.lower(param), "yellow") or string.match(string.lower(param), "gold") then
				gui.SMALL_CLOCK.HourMinute.TextColor3 = Color3.fromRGB(255, 170, 0)
				gui.LARGE_CLOCK.HourMinute.TextColor3 = Color3.fromRGB(255, 170, 0)
				game.ReplicatedStorage.FireCommand:FireClient(player, "Set hour/minute text color to yellow/gold.")
			elseif string.match(string.lower(param), "green") then
				gui.SMALL_CLOCK.HourMinute.TextColor3 = Color3.fromRGB(153, 255, 0)
				gui.LARGE_CLOCK.HourMinute.TextColor3 = Color3.fromRGB(153, 255, 0)
				game.ReplicatedStorage.FireCommand:FireClient(player, "Set hour/minute text color to green.")
			end
		elseif string.match(string.lower(command), "secondscolor") or string.match(string.lower(command), "seccolor") then
			if string.match(string.lower(param), "red") then
				gui.SMALL_CLOCK.Seconds.TextColor3 = Color3.new(1,0,0)
				gui.LARGE_CLOCK.Seconds.TextColor3 = Color3.new(1,0,0)
				game.ReplicatedStorage.FireCommand:FireClient(player, "Set seconds text color to red.")
			elseif string.match(string.lower(param), "yellow") or string.match(string.lower(param), "gold") then
				gui.SMALL_CLOCK.Seconds.TextColor3 = Color3.fromRGB(255, 170, 0)
				gui.LARGE_CLOCK.Seconds.TextColor3 = Color3.fromRGB(255, 170, 0)
				game.ReplicatedStorage.FireCommand:FireClient(player, "Set seconds text color to yellow/gold.")
			elseif string.match(string.lower(param), "green") then
				gui.SMALL_CLOCK.Seconds.TextColor3 = Color3.fromRGB(153, 255, 0)
				gui.LARGE_CLOCK.Seconds.TextColor3 = Color3.fromRGB(153, 255, 0)
				game.ReplicatedStorage.FireCommand:FireClient(player, "Set seconds text color to green.")
			end
		elseif string.match(string.lower(command), "playsound") then
			if param == nil or param == "" or param == "0" then
				clock.Speaker.CustomSound:Stop()
				game.ReplicatedStorage.FireCommand:FireClient(player, 'Message from Clock #' .. clock.ClockID.Value .. ": [OK] Stopping sound.")
			else
				local songInfo = game:GetService("MarketplaceService"):GetProductInfo(tonumber(param))
				if songInfo.AssetTypeId == 3 then
					clock.Speaker.CustomSound.SoundId = "rbxassetid://" .. param				
					game.ReplicatedStorage.FireCommand:FireClient(player, 'Message from Clock #' .. clock.ClockID.Value .. ": [OK] Now playing " .. songInfo.Name .. " (ID: " .. param .. ")...")
					clock.Speaker.CustomSound:Play()
				else
					game.ReplicatedStorage.FireCommand:FireClient(player,'Message from Clock #' .. clock.ClockID.Value .. ": [ERROR] Cannot play item ID " .. param .. ", because it isn't a sound. It is of type '" .. Enum.AssetType:GetEnumItems()[songInfo.AssetTypeId].Name .. "'.")
				end

			end

		else
			game.ReplicatedStorage.FireCommand:FireClient(player, "Invalid command. Type help to list all commands.")
		end

	end
end



game.ReplicatedStorage.FireCommand.OnServerEvent:Connect(onCommandReceived)
clock.ClockID.Changed:Connect(function()
	gui.IP_ADDR.CLOCK_ID.Text = tonumber(clock.ClockID.Value)
end)
initialize()
