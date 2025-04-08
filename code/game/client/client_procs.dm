// BYOND seemingly calls Stat() each tick.
// Calling things each tick can get expensive real quick.
// So we slow this down a little.
// See https://www.byond.com/docs/ref/#/client/proc/Stat
/client/Stat()
	. = ..()
	if(isnotnull(holder))
		sleep(1)
	else
		sleep(5)
		stoplag()

/client/proc/set_zoom_mode(new_mode)
	if(new_mode == chosen_scaling_mode)
		return FALSE
	if(!(new_mode in scaling_modes))
		return FALSE

	chosen_scaling_mode = new_mode
	winset(src, "mapwindow.map", "zoom-mode=[new_mode]")
	return TRUE