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
		return FALSE
	if(name == "act_intent")
		usr.a_intent_change("right")
		return FALSE
	return TRUE

// Internals
/atom/movable/screen/internals
	name = "internals"
	icon_state = "internal0"
	screen_loc = UI_INTERNAL
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/internals/New(_ico)
	. = ..()
	icon = _ico

/atom/movable/screen/internals/Click(location, control, params)
	. = ..()
	if(!.)
		return FALSE
	if(!isliving(usr))
		return FALSE

	var/mob/living/L = usr
	L.ui_toggle_internals()
	return TRUE

// Equip
/atom/movable/screen/equip
	name = "equip"
	icon_state = "act_equip"
	screen_loc = UI_EQUIP
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/equip/New(_ico)
	. = ..()
	icon = _ico

/atom/movable/screen/equip/Click(location, control, params)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(usr))
		return FALSE
	if(ismecha(usr.loc)) // stops inventory actions in a mech
		return FALSE

	var/mob/living/carbon/human/H = usr
	H.quick_equip()
	return TRUE

// Swap Hands
/atom/movable/screen/swap_hands
	name = "swap hands"
	dir = SOUTH
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/swap_hands/New(_ico, _icon_state, _screen_loc)
	. = ..()
	icon = _ico
	icon_state = _icon_state
	screen_loc = _screen_loc

/atom/movable/screen/swap_hands/Click(location, control, params)
	. = ..()
	if(!.)
		return FALSE
	if(!iscarbon(usr))
		return FALSE
	var/mob/living/carbon/user = usr
	if(world.time <= user.next_move)
		return FALSE
	if(user.stat || user.paralysis || user.stunned || user.weakened)
		return FALSE
	if(ismecha(user.loc)) // stops inventory actions in a mech
		return FALSE

	user.swap_hand()
	return TRUE