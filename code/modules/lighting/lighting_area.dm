/area
	luminosity = TRUE
	var/dynamic_lighting = TRUE

/area/New()
	. = ..()
	if(dynamic_lighting)
		luminosity = FALSE

/area/proc/set_lightswitch(new_switch)
	if(lightswitch != new_switch)
		lightswitch = new_switch
		updateicon()
		power_change()

/area/proc/set_emergency_lighting(enable)
	for(var/obj/machinery/light/M in src)
		M.set_emergency_lighting(enable)
		CHECK_TICK