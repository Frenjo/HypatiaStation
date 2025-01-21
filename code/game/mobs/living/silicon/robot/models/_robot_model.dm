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

	var/list/module_types = list()
	var/list/modules = list()

	var/emag_type = /obj/item/toy/sword
	var/obj/item/emag = null

	var/list/channels = list()
	var/list/camera_networks = list()

	var/sprite_path = null
	var/list/sprites = list() // Used to store the associations between sprite names and sprite index.

/obj/item/robot_model/New()
	. = ..()
	for(var/path in module_types)
		modules.Add(new path(src))
	emag = new emag_type(src)

/obj/item/robot_model/Destroy()
	QDEL_NULL(modules)
	QDEL_NULL(emag)
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