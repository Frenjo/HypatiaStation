/mob/living/silicon/robot/Login()
	..()
	regenerate_icons()
	show_laws(0)
	if(mind)
		global.CTticker.mode.remove_revolutionary(mind)
	return