/*
	Screen objects
	Todo: improve/re-implement

	Screen objects are only used for the hud and should not appear anywhere "in-game".
	They are used with the client/screen list and the screen_loc var.
	For more information, see the byond documentation on the screen_loc and screen vars.
*/
/obj/screen
	name = ""
	icon = 'icons/mob/screen/screen1.dmi'
	plane = HUD_PLANE
	layer = HUD_BASE_LAYER
	unacidable = 1

	var/obj/master = null	//A reference to the object in the slot. Grabs or items, generally.

/obj/screen/Destroy()
	master = null
	return ..()

/obj/screen/Click(location, control, params)
	if(isnull(usr))
		return 1

	switch(name)
		if("equip")
			if(ismecha(usr.loc)) // stops inventory actions in a mech
				return 1
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				H.quick_equip()

		if("resist")
			if(isliving(usr))
				var/mob/living/L = usr
				L.resist()

		if("mov_intent")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				if(isnotnull(C.legcuffed))
					to_chat(C, SPAN_NOTICE("You are legcuffed! You cannot run until you get [C.legcuffed] removed!"))
					C.set_move_intent(/decl/move_intent/walk) // Just in case.
					return 1
				else
					var/next_move_intent = next_in_list(C.move_intent.type, C.move_intents)
					C.set_move_intent(next_move_intent)
		if("Reset Machine")
			usr.unset_machine()
		if("internal")
			if(isliving(usr))
				var/mob/living/L = usr
				L.ui_toggle_internals()
		if("act_intent")
			usr.a_intent_change("right")
		if("help")
			usr.a_intent = "help"
			usr.hud_used.action_intent.icon_state = "intent_help"
		if("harm")
			usr.a_intent = "hurt"
			usr.hud_used.action_intent.icon_state = "intent_hurt"
		if("grab")
			usr.a_intent = "grab"
			usr.hud_used.action_intent.icon_state = "intent_grab"
		if("disarm")
			usr.a_intent = "disarm"
			usr.hud_used.action_intent.icon_state = "intent_disarm"

		if("pull")
			usr.stop_pulling()
		if("throw")
			if(iscarbon(usr) && !usr.stat && isturf(usr.loc) && !usr.restrained())
				var/mob/living/carbon/C = usr
				C.toggle_throw_mode()
		if("drop")
			usr.drop_item_v()

		if("module")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				if(isnotnull(R.module))
					return 1
				R.pick_module()

		if("radio")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				R.radio_menu()
		if("panel")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				R.installed_modules()

		if("store")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				R.uneq_active()

		if("module1")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				R.toggle_module(1)

		if("module2")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				R.toggle_module(2)

		if("module3")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				R.toggle_module(3)

		else
			return 0
	return 1