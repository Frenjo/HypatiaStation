/atom/movable/screen/gun
	name = "gun"
	icon = 'icons/hud/screen1.dmi'
	dir = 2

	var/gun_click_time = -100 //I'm lazy.

/atom/movable/screen/gun/Click(location, control, params)
	if(isnull(usr))
		return FALSE
	return TRUE

/atom/movable/screen/gun/mode
	name = "Toggle Gun Mode"
	icon_state = "gun0"
	screen_loc = UI_GUN_SELECT
	//dir = 1

/atom/movable/screen/gun/mode/Click(location, control, params)
	. = ..()
	if(!.)
		return
	usr.client.ToggleGunMode()

/atom/movable/screen/gun/move
	name = "Allow Walking"
	icon_state = "no_walk0"
	screen_loc = UI_GUN2

/atom/movable/screen/gun/move/Click(location, control, params)
	. = ..()
	if(!.)
		return
	if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
		return FALSE
	if(!istype(usr.get_active_hand(), /obj/item/gun))
		FEEDBACK_GUN_NOT_ACTIVE_HAND(usr)
		return FALSE

	usr.client.AllowTargetMove()
	gun_click_time = world.time

/atom/movable/screen/gun/run
	name = "Allow Running"
	icon_state = "no_run0"
	screen_loc = UI_GUN3

/atom/movable/screen/gun/run/Click(location, control, params)
	. = ..()
	if(!.)
		return
	if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
		return FALSE
	if(!istype(usr.get_active_hand(), /obj/item/gun))
		FEEDBACK_GUN_NOT_ACTIVE_HAND(usr)
		return FALSE

	usr.client.AllowTargetRun()
	gun_click_time = world.time

/atom/movable/screen/gun/item
	name = "Allow Item Use"
	icon_state = "no_item0"
	screen_loc = UI_GUN1

/atom/movable/screen/gun/item/Click(location, control, params)
	. = ..()
	if(!.)
		return
	if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
		return FALSE
	if(!istype(usr.get_active_hand(), /obj/item/gun))
		FEEDBACK_GUN_NOT_ACTIVE_HAND(usr)
		return FALSE

	usr.client.AllowTargetClick()
	gun_click_time = world.time