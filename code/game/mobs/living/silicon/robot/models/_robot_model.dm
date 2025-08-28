/*
 * Base Model
 */
/obj/item/robot_model
	name = "robot model"
	icon = 'icons/obj/items/module.dmi'
	icon_state = "std_module"
	w_class = 100
	item_state = "electronic"
	obj_flags = OBJ_FLAG_CONDUCT

	// The visible display name of the model.
	var/display_name = "Unformatted"

	// The icon displayed on the "installed model" UI element.
	// This defaults to lowertext(display_name) if unset.
	var/model_icon = null

	// A list of typepaths for the basic modules this model has.
	var/list/basic_modules = list()
	// A list of typepaths for the modules this model gets when emagged.
	var/list/emag_modules = list(/obj/item/toy/sword)

	// A list containing all currently useable modules.
	var/list/modules = list()

	var/list/channels = list()
	var/list/camera_networks = list()

	var/sprite_path = null
	var/model_select_sprite = null
	var/list/sprites = list() // Used to store the associations between sprite names and sprite index.

	var/can_be_pushed = TRUE // Whether this model can be pushed around.

	var/integrated_light_range = 4 // The range of this model's integrated light.
	var/integrated_light_colour = null // The colour of this model's integrated light. If null, it uses the default.

	var/list/advanced_huds = null // A list of SILICON_HUD_* types that this model will use the advanced version of.

/obj/item/robot_model/New()
	. = ..()
	for(var/path in basic_modules)
		modules.Add(new path(src))

	if(isnull(model_select_sprite) && length(sprites))
		model_select_sprite = sprites[sprites[1]]

/obj/item/robot_model/Destroy()
	QDEL_LIST(modules)
	return ..()

/obj/item/robot_model/emp_act(severity)
	if(modules)
		for(var/obj/O in modules)
			O.emp_act(severity)
	. = ..()

/obj/item/robot_model/proc/on_transform_to(mob/living/silicon/robot/robby)
	return

/obj/item/robot_model/proc/on_move(mob/living/silicon/robot/robby)
	return

/obj/item/robot_model/proc/respawn_consumable(mob/living/silicon/robot/robby)
	SHOULD_CALL_PARENT(TRUE)

	var/obj/item/flash/flasher = locate() in modules
	if(isnotnull(flasher))
		if(flasher.broken)
			flasher.broken = 0
			flasher.times_used = 0
			flasher.icon_state = "flash"
		else if(flasher.times_used)
			flasher.times_used--

/obj/item/robot_model/proc/rebuild() // Rebuilds the list so it's possible to add/remove items from the module.
	var/list/temp_list = modules
	modules = list()
	for(var/obj/O in temp_list)
		if(isnotnull(O))
			modules.Add(O)

/obj/item/robot_model/proc/add_languages(mob/living/silicon/robot/robby)
	SHOULD_CALL_PARENT(TRUE)

	robby.add_language("Robot Talk")
	robby.add_language("Drone Talk", FALSE)
	robby.add_language("Binary Audio Language")

/obj/item/robot_model/proc/get_playstyle_string()
	SHOULD_CALL_PARENT(FALSE)

	return null

// Any model-specific behaviour to be performed when getting emagged.
/obj/item/robot_model/proc/on_emag(mob/living/silicon/robot/robby)
	SHOULD_CALL_PARENT(TRUE)

	for(var/path in emag_modules)
		modules.Add(new path(src))
	rebuild()

// Any model-specific behaviour to be performed when getting un-emagged.
/obj/item/robot_model/proc/on_unemag(mob/living/silicon/robot/robby)
	SHOULD_CALL_PARENT(TRUE)

	for(var/obj/module in modules)
		if(!(module.type in emag_modules))
			continue
		if(robby.activated(module))
			robby.module_active = null
		if(robby.module_state_1 == module)
			robby.module_state_1 = null
		else if(robby.module_state_2 == module)
			robby.module_state_2 = null
		else if(robby.module_state_3 == module)
			robby.module_state_3 = null
		modules.Remove(module)
		qdel(module)
	rebuild()