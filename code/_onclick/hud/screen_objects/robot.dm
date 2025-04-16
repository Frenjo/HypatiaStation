/atom/movable/screen/robot
	icon = 'icons/hud/robot/robot.dmi'

/atom/movable/screen/robot/New(_loc, _name, _icon_state, _screen_loc)
	. = ..(_loc)
	name = _name
	icon_state = _icon_state
	screen_loc = _screen_loc

/atom/movable/screen/robot/Click(location, control, params)
	if(!isrobot(usr))
		return FALSE
	var/mob/living/silicon/robot/R = usr

	switch(name)
		if("model")
			if(!istype(R.model, /obj/item/robot_model/default))
				return FALSE
			R.pick_model()
		if("radio")
			R.radio_menu()
		if("panel")
			R.installed_modules()
		if("store")
			R.uneq_active()
		else
			return FALSE

	return TRUE

// Lights
/atom/movable/screen/robot/lights/New()
	. = ..(loc, "lights", "lights0", UI_BORG_LIGHTS)

/atom/movable/screen/robot/lights/Click(location, control, params)
	if(!isrobot(usr))
		return FALSE
	var/mob/living/silicon/robot/robby = usr
	robby.toggle_lights()
	icon_state = "lights[robby.luminosity]"
	return TRUE

// Active modules
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

// Model icon
/atom/movable/screen/robot/installed_model
	icon = 'icons/hud/robot/model_icons.dmi'