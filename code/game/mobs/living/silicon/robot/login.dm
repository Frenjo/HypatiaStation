/mob/living/silicon/robot/Login()
	..()
	regenerate_icons()
	show_laws(0)
	if(mind)
		global.CTgame_ticker.mode.remove_revolutionary(mind)
	return