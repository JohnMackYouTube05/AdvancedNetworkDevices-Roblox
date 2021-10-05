--This file is what grabs the time from game.Lighting, and updates both clock configurations once per second.
lighting = game.Lighting
large = script.Parent.SurfaceGui.LARGE_CLOCK
small = script.Parent.SurfaceGui.SMALL_CLOCK
TWELVE_HOUR_ENABLED = true
weekdays = {
	[1] = "SUN",
	[2] = "MON",
	[3] = "TUE",
	[4] = "WED",
	[5] = "THU",
	[6] = "FRI",
	[7] = "SAT"
}
while wait() do
	hms = string.split(lighting.TimeOfDay, ":")
	hour = hms[1]
	minute = hms[2]
	second = hms[3]
	if TWELVE_HOUR_ENABLED == true and tonumber(hour) > 12 then hour -= 12 end
	large.HourMinute.Text = (hour .. ":" .. minute)
	large.Seconds.Text = second
	small.HourMinute.Text = (hour .. ":" .. minute)
	small.Seconds.Text = second
	date = DateTime.now():ToLocalTime()
	WEEKDAY = weekdays[os.date("*t").wday]
	small.Date.Text = WEEKDAY .. " " .. date['Month'] .. "-" .. date['Day'] .. "-" .. date['Year']
	wait(1)

end
