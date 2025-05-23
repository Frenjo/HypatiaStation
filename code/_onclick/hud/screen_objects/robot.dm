/atom/movable/screen/robot
	icon = 'icons/hud/robot/robot.dmi'

/atom/movable/screen/robot/New(_name = null, _icon_state = null, _screen_loc = null)
	. = ..()
	if(isnotnull(_name))
		name = _name
	if(isnotnull(_icon_state))
		icon_state = _icon_state
	if(isnotnull(_screen_loc))
		screen_loc = _screen_loc

/atom/movable/screen/robot/Click(location, control, params)
	if(!isrobot(usr))
		return FALSE
	return TRUE

// Lights
/atom/movable/screen/robot/lights
	name = "lights"
	icon_state = "lights0"
	screen_loc = UI_BORG_LIGHTS
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/robot/lights/Click(location, control, params)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/silicon/robot/robby = usr
	robby.toggle_lights()
	icon_state = "lights[robby.luminosity]"
	return TRUE

// Active modules
/atom/movable/screen/robot/active_module
	dir = SOUTHWEST
	mouse_over_pointer = MOUSE_HAND_POINTER

	var/module_number

/atom/movable/screen/robot/active_module/New(_module_number, _screen_loc)
	. = ..("module[_module_number]", "inv[_module_number]", _screen_loc)
	module_number = _module_number

/atom/movable/screen/robot/active_module/Click(location, control, params)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/silicon/robot/robby = usr
	robby.toggle_module(module_number)
	return TRUE

// Store module
/atom/movable/screen/robot/store_module
	name = "store"
	icon_state = "store"
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/robot/store_module/Click(location, control, params)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/silicon/robot/robby = usr
	robby.uneq_active()
	return TRUE

// Model icon
/atom/movable/screen/robot/installed_model
	name = "model"
	icon = 'icons/hud/robot/model_icons.dmi'
	icon_state = "nomod"
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/robot/installed_model/Click(location, control, params)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/silicon/robot/robby = usr
	if(!istype(robby.model, /obj/item/robot_model/default))
		return FALSE

	robby.pick_model()
	return TRUE

// Radio
/atom/movable/screen/robot/radio
	name = "radio"
	icon_state = "radio"
	dir = SOUTHWEST
	screen_loc = UI_MOVI
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/robot/radio/Click(location, control, params)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/silicon/robot/robby = usr
	robby.radio_menu()
	return TRUE

// Panel
/atom/movable/screen/robot/panel
	name = "panel"
	icon_state = "panel"
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/robot/panel/Click(location, control, params)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/silicon/robot/robby = usr
	robby.installed_modules()
	return TRUE

// Action intent
/atom/movable/screen/robot/action_intent
	name = "action intent"
	icon_state = "help"
	dir = SOUTHWEST
	screen_loc = UI_ACTI
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/robot/action_intent/Click(location, control, params)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/silicon/robot/robby = usr
	robby.a_intent_change("right")
	return TRUE