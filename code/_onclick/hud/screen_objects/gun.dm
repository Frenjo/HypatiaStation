/obj/screen/gun
	name = "gun"
	icon = 'icons/mob/screen/screen1.dmi'
	master = null
	dir = 2

	var/gun_click_time = -100 //I'm lazy.

/obj/screen/gun/Click(location, control, params)
	if(isnull(usr))
		return FALSE
	return TRUE

/obj/screen/gun/mode
	name = "Toggle Gun Mode"
	icon_state = "gun0"
	screen_loc = UI_GUN_SELECT
	//dir = 1

/obj/screen/gun/mode/Click(location, control, params)
	. = ..()
	if(!.)
		return .
	usr.client.ToggleGunMode()

/obj/screen/gun/move
	name = "Allow Walking"
	icon_state = "no_walk0"
	screen_loc = UI_GUN2

/obj/screen/gun/move/Click(location, control, params)
	. = ..()
	if(!.)
		return .
	if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
		return FALSE
	if(!istype(usr.get_active_hand(), /obj/item/gun))
		FEEDBACK_GUN_NOT_ACTIVE_HAND(usr)
		return FALSE

	usr.client.AllowTargetMove()
	gun_click_time = world.time

/obj/screen/gun/run
	name = "Allow Running"
	icon_state = "no_run0"
	screen_loc = UI_GUN3

/obj/screen/gun/run/Click(location, control, params)
	. = ..()
	if(!.)
		return .
	if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
		return FALSE
	if(!istype(usr.get_active_hand(), /obj/item/gun))
		FEEDBACK_GUN_NOT_ACTIVE_HAND(usr)
		return FALSE

	usr.client.AllowTargetRun()
	gun_click_time = world.time

/obj/screen/gun/item
	name = "Allow Item Use"
	icon_state = "no_item0"
	screen_loc = UI_GUN1

/obj/screen/gun/item/Click(location, control, params)
	. = ..()
	if(!.)
		return .
	if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
		return FALSE
	if(!istype(usr.get_active_hand(), /obj/item/gun))
		FEEDBACK_GUN_NOT_ACTIVE_HAND(usr)
		return FALSE

	usr.client.AllowTargetClick()
	gun_click_time = world.time