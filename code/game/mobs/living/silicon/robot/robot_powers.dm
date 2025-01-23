/mob/living/silicon/robot/verb/light()
	set category = "Robot Commands"
	set name = "Toggle Lights"
	set desc = "Toggles your inbuilt lights on or off."

	if(luminosity)
		set_light(0)
		luminosity = FALSE
		return

	set_light(integrated_light_power)
	luminosity = TRUE