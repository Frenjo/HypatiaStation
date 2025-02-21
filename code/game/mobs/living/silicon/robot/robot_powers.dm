/mob/living/silicon/robot/proc/toggle_lights()
	if(luminosity)
		set_light(0)
		luminosity = FALSE
		return

	set_light(module.integrated_light_power)
	luminosity = TRUE