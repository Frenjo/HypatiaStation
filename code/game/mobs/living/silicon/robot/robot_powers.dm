/mob/living/silicon/robot/proc/toggle_lights()
	if(luminosity)
		set_light(0)
		luminosity = FALSE
		return

	set_light(model.integrated_light_range, l_color = model.integrated_light_colour)
	luminosity = TRUE