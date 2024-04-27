/atom/movable/screen/robot
	icon = 'icons/mob/screen/screen1_robot.dmi'

/atom/movable/screen/robot/New(loc, name, icon_state, screen_loc)
	. = ..(loc)
	src.name = name
	src.icon_state = icon_state
	src.screen_loc = screen_loc

/atom/movable/screen/robot/Click(location, control, params)
	if(!isrobot(usr))
		return FALSE
	var/mob/living/silicon/robot/R = usr

	switch(name)
		if("module")
			if(isnotnull(R.module))
				return FALSE
			R.pick_module()
		if("radio")
			R.radio_menu()
		if("panel")
			R.installed_modules()
		if("store")
			R.uneq_active()
		else
			return FALSE

	return TRUE

/atom/movable/screen/robot/active_module
	dir = SOUTHWEST
	
	var/module_number

/atom/movable/screen/robot/active_module/New(loc, module_number, screen_loc)
	. = ..(loc, "module[module_number]", "inv[module_number]", screen_loc)
	src.module_number = module_number

/atom/movable/screen/robot/active_module/Click(location, control, params)
	if(!isrobot(usr))
		return FALSE
	var/mob/living/silicon/robot/R = usr
	R.toggle_module(module_number)
	return TRUE