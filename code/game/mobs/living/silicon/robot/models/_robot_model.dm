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

	// A list of typepaths for the basic modules this model has.
	var/list/basic_modules = list()

	// The module this model receives when emagged and the associated instance.
	var/emag_type = /obj/item/toy/sword
	var/obj/item/emag = null

	// A list containing all currently useable modules.
	var/list/modules = list()

	var/list/channels = list()
	var/list/camera_networks = list()

	var/sprite_path = null
	var/list/sprites = list() // Used to store the associations between sprite names and sprite index.

	var/can_be_pushed = TRUE // Whether this model can be pushed around.
	var/integrated_light_power = 4

/obj/item/robot_model/New()
	. = ..()
	for(var/path in basic_modules)
		modules.Add(new path(src))
	emag = new emag_type(src)

/obj/item/robot_model/Destroy()
	QDEL_NULL(emag)
	QDEL_NULL(modules)
	return ..()

/obj/item/robot_model/emp_act(severity)
	if(modules)
		for(var/obj/O in modules)
			O.emp_act(severity)
	if(emag)
		emag.emp_act(severity)
	. = ..()

/obj/item/robot_model/proc/respawn_consumable(mob/living/silicon/robot/R)
	return

/obj/item/robot_model/proc/rebuild() // Rebuilds the list so it's possible to add/remove items from the module.
	var/list/temp_list = modules
	modules = list()
	for(var/obj/O in temp_list)
		if(isnotnull(O))
			modules.Add(O)

/obj/item/robot_model/proc/add_languages(mob/living/silicon/robot/R)
	SHOULD_CALL_PARENT(TRUE)

	R.add_language("Binary Audio Language", FALSE)