/var/security_level = 0
//0 = code green
//1 = code yellow
//2 = code blue
//3 = code red
//4 = code delta

/proc/set_security_level(level)
	switch(level)
		if("green")
			level = SEC_LEVEL_GREEN
		if("yellow")
			level = SEC_LEVEL_YELLOW
		if("blue")
			level = SEC_LEVEL_BLUE
		if("red")
			level = SEC_LEVEL_RED
		if("delta")
			level = SEC_LEVEL_DELTA

	//Will not be announced if you try to set to the same level as it already is
	if(level >= SEC_LEVEL_GREEN && level <= SEC_LEVEL_DELTA && level != security_level)
		switch(level)
			if(SEC_LEVEL_GREEN)
				to_chat(world, "<font size=4 color='red'>Attention! Security level lowered to green</font>")
				to_chat(world, "<font color='red'>[config.alert_desc_green]</font>")
				world << sound('sound/vox/doop.wav', volume = 37) // Play a sound whenever the level changes downwards. -Frenjo
				security_level = SEC_LEVEL_GREEN

				// Stole this code from below, again. -Frenjo
				var/obj/machinery/computer/communications/CC = locate(/obj/machinery/computer/communications, world)
				if(CC)
					CC.post_status("alert", "default")

				for(var/obj/machinery/firealarm/FA in machines)
					if(FA.z in config.contact_levels)
						FA.overlays = list()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_green")

				// Hopefully this works. -Frenjo
				for(var/turf/simulated/floor/bluegrid/BG in world)
					if(BG.z in config.contact_levels)
						BG.icon_state = "bcircuit"
				for(var/area/A in world)
					if(istype(A, /area/hallway))
						A.destructreset()

			if(SEC_LEVEL_YELLOW)
				if(security_level < SEC_LEVEL_YELLOW)
					to_chat(world, "<font size=4 color='red'>Attention! Security level elevated to yellow</font>")
					to_chat(world, "<font color='red'>[config.alert_desc_yellow_upto]</font>")
					world << sound('sound/vox/dadeda.wav', volume = 34) // Play a sound whenever the level changes upwards. -Frenjo
				else
					to_chat(world, "<font size=4 color='red'>Attention! Security level lowered to yellow</font>")
					to_chat(world, "<font color='red'>[config.alert_desc_yellow_downto]</font>")
					world << sound('sound/vox/doop.wav', volume = 37) // Play a sound whenever the level changes downwards. -Frenjo
				security_level = SEC_LEVEL_YELLOW

				// Stole this code from below, made the blue alert sprite to go with it too! -Frenjo
				var/obj/machinery/computer/communications/CC = locate(/obj/machinery/computer/communications, world)
				if(CC)
					CC.post_status("alert", "yellowalert")

				for(var/obj/machinery/firealarm/FA in machines)
					if(FA.z in config.contact_levels)
						FA.overlays = list()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_yellow")

				// Hopefully this works. -Frenjo
				for(var/turf/simulated/floor/bluegrid/BG in world)
					if(BG.z in config.contact_levels)
						BG.icon_state = "bcircuit"

				for(var/area/A in world)
					if(istype(A, /area/hallway))
						A.destructreset()

			if(SEC_LEVEL_BLUE)
				if(security_level < SEC_LEVEL_BLUE)
					to_chat(world, "<font size=4 color='red'>Attention! Security level elevated to blue</font>")
					to_chat(world, "<font color='red'>[config.alert_desc_blue_upto]</font>")
					world << sound('sound/vox/dadeda.wav', volume = 34) // Play a sound whenever the level changes upwards. -Frenjo
					world << sound('sound/AI/securityblue.ogg') // Play a sound when we elevate to blue. -Frenjo
				else
					to_chat(world, "<font size=4 color='red'>Attention! Security level lowered to blue</font>")
					to_chat(world, "<font color='red'>[config.alert_desc_blue_downto]</font>")
					world << sound('sound/vox/doop.wav', volume = 37) // Play a sound whenever the level changes downwards. -Frenjo
				security_level = SEC_LEVEL_BLUE

				// Stole this code from below, made the blue alert sprite to go with it too! -Frenjo
				var/obj/machinery/computer/communications/CC = locate(/obj/machinery/computer/communications, world)
				if(CC)
					CC.post_status("alert", "bluealert")

				for(var/obj/machinery/firealarm/FA in machines)
					if(FA.z in config.contact_levels)
						FA.overlays = list()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_blue")

				// Hopefully this works. -Frenjo
				for(var/turf/simulated/floor/bluegrid/BG in world)
					if(BG.z in config.contact_levels)
						BG.icon_state = "bcircuit"
				for(var/area/A in world)
					if(istype(A, /area/hallway))
						A.destructreset()

			if(SEC_LEVEL_RED)
				if(security_level < SEC_LEVEL_RED)
					to_chat(world, "<font size=4 color='red'>Attention! Code red!</font>")
					to_chat(world, "<font color='red'>[config.alert_desc_red_upto]</font>")
					world << sound('sound/vox/dadeda.wav', volume = 34) // Play a sound whenever the level changes upwards. -Frenjo
				else
					to_chat(world, "<font size=4 color='red'>Attention! Code red!</font>")
					to_chat(world, "<font color='red'>[config.alert_desc_red_downto]</font>")
					world << sound('sound/vox/doop.wav', volume = 37) // Play a sound whenever the level changes downwards. -Frenjo
				security_level = SEC_LEVEL_RED

				//	- At the time of commit, setting status displays didn't work properly
				// Uncommented 06/10/2019 and it works now! -Frenjo
				var/obj/machinery/computer/communications/CC = locate(/obj/machinery/computer/communications, world)
				if(CC)
					CC.post_status("alert", "redalert")

				for(var/obj/machinery/firealarm/FA in machines)
					if(FA.z in config.contact_levels)
						FA.overlays = list()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_red")

				// Hopefully this works. -Frenjo
				for(var/turf/simulated/floor/bluegrid/BG in world)
					if(BG.z in config.contact_levels)
						BG.icon_state = "rcircuit"
				for(var/area/A in world)
					if(istype(A, /area/hallway))
						A.destructreset()

			if(SEC_LEVEL_DELTA)
				to_chat(world, "<font size=4 color='red'>Attention! Delta security level reached!</font>")
				to_chat(world, "<font color='red'>[config.alert_desc_delta]</font>")
				world << sound('sound/vox/dadeda.wav', volume = 34) // Play a sound whenever the level changes upwards. -Frenjo
				world << sound('sound/misc/bloblarm.ogg', volume = 70) // Self destruction needs dramatic noises. -Frenjo
				security_level = SEC_LEVEL_DELTA

				// Stole this code from above, again again, made the alien-esque sprite to go with it! -Frenjo
				var/obj/machinery/computer/communications/CC = locate(/obj/machinery/computer/communications,world)
				if(CC)
					CC.post_status("alert", "delta")

				for(var/obj/machinery/firealarm/FA in machines)
					if(FA.z in config.contact_levels)
						FA.overlays = list()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_delta")

				// Hopefully this works. -Frenjo
				for(var/turf/simulated/floor/bluegrid/BG in world)
					if(BG.z in config.contact_levels)
						BG.icon_state = "rcircuit_flash"
				for(var/area/A in world)
					if(istype(A, /area/hallway))
						A.destructalert()
	else
		return

/proc/get_security_level()
	switch(security_level)
		if(SEC_LEVEL_GREEN)
			return "green"
		if(SEC_LEVEL_YELLOW)
			return "yellow"
		if(SEC_LEVEL_BLUE)
			return "blue"
		if(SEC_LEVEL_RED)
			return "red"
		if(SEC_LEVEL_DELTA)
			return "delta"

/proc/num2seclevel(num)
	switch(num)
		if(SEC_LEVEL_GREEN)
			return "green"
		if(SEC_LEVEL_YELLOW)
			return "yellow"
		if(SEC_LEVEL_BLUE)
			return "blue"
		if(SEC_LEVEL_RED)
			return "red"
		if(SEC_LEVEL_DELTA)
			return "delta"

/proc/seclevel2num(seclevel)
	switch(lowertext(seclevel))
		if("green")
			return SEC_LEVEL_GREEN
		if("yellow")
			return SEC_LEVEL_YELLOW
		if("blue")
			return SEC_LEVEL_BLUE
		if("red")
			return SEC_LEVEL_RED
		if("delta")
			return SEC_LEVEL_DELTA


/*DEBUG
/mob/verb/set_thing0()
	set_security_level(0)
/mob/verb/set_thing1()
	set_security_level(1)
/mob/verb/set_thing2()
	set_security_level(2)
/mob/verb/set_thing3()
	set_security_level(3)
*/