/mob/living/silicon/robot/verb/light()
	set name = "Light On/Off"
	set desc = "Activate your inbuilt light. Toggled on or off."
	set category = "Robot Commands"

	if(luminosity)
		set_light(0)
		return
	set_light(integrated_light_power)