/atom/movable/screen/action/New(ico, s_loc)
	. = ..()
	icon = ico
	screen_loc = s_loc

// Dropping
/atom/movable/screen/action/drop
	name = "drop"
	icon_state = "act_drop"

/atom/movable/screen/action/drop/Click(location, control, params)
	usr.drop_item_v()

// Resisting
/atom/movable/screen/action/resist
	name = "resist"
	icon_state = "act_resist"

/atom/movable/screen/action/resist/Click(location, control, params)
	var/mob/living/L = usr
	L.resist()

// Throwing
// Named /throw_icon because throw is a keyword.
/atom/movable/screen/action/throw_icon
	name = "throw"
	icon_state = "act_throw_off"

/atom/movable/screen/action/throw_icon/Click(location, control, params)
	var/mob/living/carbon/C = usr
	if(!C.stat && isturf(C.loc) && !C.restrained())
		C.toggle_throw_mode()

// Pulling
/atom/movable/screen/action/pull
	name = "pull"
	icon_state = "pull0"

/atom/movable/screen/action/pull/Click(location, control, params)
	usr.stop_pulling()