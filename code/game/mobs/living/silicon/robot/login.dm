/mob/living/silicon/robot/Login()
	. = ..()
	regenerate_icons()
	show_laws(0)
	if(mind)
		global.PCticker.mode.remove_revolutionary(mind)
	hands?.icon_state = model.model_icon // Temporary fix for model icons being funky on the UI.