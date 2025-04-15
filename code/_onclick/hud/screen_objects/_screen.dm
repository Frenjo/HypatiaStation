/*
	Screen objects
	Todo: improve/re-implement

	Screen objects are only used for the hud and should not appear anywhere "in-game".
	They are used with the client/screen list and the screen_loc var.
	For more information, see the byond documentation on the screen_loc and screen vars.
*/
/atom/movable/screen
	icon = 'icons/hud/screen1.dmi'
	plane = HUD_PLANE
	layer = HUD_BASE_LAYER

	var/obj/master = null // A reference to the object in the slot. Grabs or items, generally.

/atom/movable/screen/Destroy()
	master = null
	return ..()

/atom/movable/screen/Click(location, control, params)
	if(isnull(usr))
		return 1

	switch(name)
		if("equip")
			if(ismecha(usr.loc)) // stops inventory actions in a mech
				return 1
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				H.quick_equip()

		if("internal")
			if(isliving(usr))
				var/mob/living/L = usr
				L.ui_toggle_internals()
		if("act_intent")
			usr.a_intent_change("right")

		else
			return 0
	return 1