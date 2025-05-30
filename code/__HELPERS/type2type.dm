/*
 * Holds procs designed to change one type of value, into another.
 * Contains:
 *			hex2num & num2hex
 *			text2list & list2text
 *			file2list
 *			angle2dir
 *			angle2text
 *			worldtime2text
 */

//Returns an integer given a hex input
/proc/hex2num(hex)
	if(!(istext(hex)))
		return

	var/num = 0
	var/power = 0
	var/i = null
	i = length(hex)
	while(i > 0)
		var/char = copytext(hex, i, i + 1)
		switch(char)
			if("0")
				//Apparently, switch works with empty statements, yay! If that doesn't work, blame me, though. -- Urist
			if("9", "8", "7", "6", "5", "4", "3", "2", "1")
				num += text2num(char) * 16 ** power
			if("a", "A")
				num += 16 ** power * 10
			if("b", "B")
				num += 16 ** power * 11
			if("c", "C")
				num += 16 ** power * 12
			if("d", "D")
				num += 16 ** power * 13
			if("e", "E")
				num += 16 ** power * 14
			if("f", "F")
				num += 16 ** power * 15
			else
				return
		power++
		i--
	return num

//Returns the hex value of a number given a value assumed to be a base-ten value
/proc/num2hex(num, placeholder)
	if(isnull(placeholder))
		placeholder = 2
	if(!isnum(num))
		return
	if(!num)
		return "0"
	var/hex = ""
	var/i = 0
	while(16 ** i < num)
		i++
	var/power = null
	power = i - 1
	while(power >= 0)
		var/val = round(num / 16 ** power)
		num -= val * 16 ** power
		switch(val)
			if(9.0, 8.0, 7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0, 0.0)
				hex += "[val]"
			if(10.0)
				hex += "A"
			if(11.0)
				hex += "B"
			if(12.0)
				hex += "C"
			if(13.0)
				hex += "D"
			if(14.0)
				hex += "E"
			if(15.0)
				hex += "F"
			else
		power--
	while(length(hex) < placeholder)
		hex = "0[hex]"
	return hex

/proc/text2numlist(text, delimiter = "\n")
	. = list()
	for(var/x in splittext(text, delimiter))
		. += text2num(x)

//Splits the text of a file at seperator and returns them in a list.
/proc/file2list(filename, seperator = "\n")
	return splittext(return_file_text(filename), seperator)

//Turns a direction into text
/proc/num2dir(direction)
	switch(direction)
		if(1)
			return NORTH
		if(2)
			return SOUTH
		if(4)
			return EAST
		if(8)
			return WEST
		else
			world.log << "UNKNOWN DIRECTION: [direction]"

//Turns a direction into text
/proc/dir2text(direction)
	switch(direction)
		if(1)
			return "north"
		if(2)
			return "south"
		if(4)
			return "east"
		if(8)
			return "west"
		if(5)
			return "northeast"
		if(6)
			return "southeast"
		if(9)
			return "northwest"
		if(10)
			return "southwest"
	return

//Turns text into proper directions
/proc/text2dir(direction)
	switch(uppertext(direction))
		if("NORTH")
			return 1
		if("SOUTH")
			return 2
		if("EAST")
			return 4
		if("WEST")
			return 8
		if("NORTHEAST")
			return 5
		if("NORTHWEST")
			return 9
		if("SOUTHEAST")
			return 6
		if("SOUTHWEST")
			return 10
	return

// Converts an angle (degrees) into an ss13 direction.
/proc/angle2dir(degree)
	// Will filter out extra rotations and negative rotations
	// E.g: 540 becomes 180. -180 becomes 180.
	// Thanks to Flexicode for the formula.
	degree = ((degree % 360 + 22.5) + 360) % 365

	if(degree < 45)
		return NORTH
	if(degree < 90)
		return NORTHEAST
	if(degree < 135)
		return EAST
	if(degree < 180)
		return SOUTHEAST
	if(degree < 225)
		return SOUTH
	if(degree < 270)
		return SOUTHWEST
	if(degree < 315)
		return WEST
	return NORTH|WEST

//returns the north-zero clockwise angle in degrees, given a direction
/proc/dir2angle(D)
	switch(D)
		if(NORTH)
			return 0
		if(SOUTH)
			return 180
		if(EAST)
			return 90
		if(WEST)
			return 270
		if(NORTHEAST)
			return 45
		if(SOUTHEAST)
			return 135
		if(NORTHWEST)
			return 315
		if(SOUTHWEST)
			return 225
		else
			return null

//Returns the angle in english
/proc/angle2text(degree)
	return dir2text(angle2dir(degree))

//Converts a rights bitfield into a string
/proc/rights2text(rights, seperator = "")
	if(rights & R_BUILDMODE)
		. += "[seperator]+BUILDMODE"
	if(rights & R_ADMIN)
		. += "[seperator]+ADMIN"
	if(rights & R_BAN)
		. += "[seperator]+BAN"
	if(rights & R_FUN)
		. += "[seperator]+FUN"
	if(rights & R_SERVER)
		. += "[seperator]+SERVER"
	if(rights & R_DEBUG)
		. += "[seperator]+DEBUG"
	if(rights & R_POSSESS)
		. += "[seperator]+POSSESS"
	if(rights & R_PERMISSIONS)
		. += "[seperator]+PERMISSIONS"
	if(rights & R_STEALTH)
		. += "[seperator]+STEALTH"
	if(rights & R_REJUVENATE)
		. += "[seperator]+REJUVENATE"
	if(rights & R_VAREDIT)
		. += "[seperator]+VAREDIT"
	if(rights & R_SPAWN)
		. += "[seperator]+SPAWN"
	if(rights & R_MOD)
		. += "[seperator]+MODERATOR"

/proc/ui_style2icon(ui_style)
	switch(ui_style)
		if("old")
			return 'icons/hud/screen1_old.dmi'
		if("Orange")
			return 'icons/hud/screen1_Orange.dmi'
		if("Midnight")
			return 'icons/hud/screen1_Midnight.dmi'
		else
			return 'icons/hud/screen1_White.dmi'

// Ported from Baystation12 on 27/11/2019. -Frenjo
// heat2color functions. Adapted from: http://www.tannerhelland.com/4435/convert-temperature-rgb-algorithm-code/
/proc/heat2color(temp)
	return rgb(heat2color_r(temp), heat2color_g(temp), heat2color_b(temp))

/proc/heat2color_r(temp)
	temp /= 100
	if(temp <= 66)
		. = 255
	else
		. = max(0, min(255, 329.698727446 * (temp - 60) ** -0.1332047592))

/proc/heat2color_g(temp)
	temp /= 100
	if(temp <= 66)
		. = max(0, min(255, 99.4708025861 * log(temp) - 161.1195681661))
	else
		. = max(0, min(255, 288.1221695283 * ((temp - 60) ** -0.0755148492)))

/proc/heat2color_b(temp)
	temp /= 100
	if(temp >= 66)
		. = 255
	else
		if(temp <= 16)
			. = 0
		else
			. = max(0, min(255, 138.5177312231 * log(temp - 10) - 305.0447927307))