/*
 * Base Module
 */
/obj/item/robot_module
	name = "robot module"
	icon = 'icons/obj/items/module.dmi'
	icon_state = "std_module"
	w_class = 100.0
	item_state = "electronic"
	obj_flags = OBJ_FLAG_CONDUCT

	var/channels = list()
	var/list/modules = list()
	var/obj/item/emag = null
	var/obj/item/borg/upgrade/jetpack = null

/obj/item/robot_module/emp_act(severity)
	if(modules)
		for(var/obj/O in modules)
			O.emp_act(severity)
	if(emag)
		emag.emp_act(severity)
	. = ..()

/obj/item/robot_module/New()
	. = ..()
	modules.Add(new /obj/item/flashlight(src))
	modules.Add(new /obj/item/flash(src))
	emag = new /obj/item/toy/sword(src)
	emag.name = "Placeholder Emag Item"
//	jetpack = new /obj/item/toy/sword(src)
//	jetpack.name = "Placeholder Upgrade Item"

/obj/item/robot_module/Destroy()
	qdel(modules)
	qdel(emag)
	qdel(jetpack)
	modules = null
	emag = null
	jetpack = null
	return ..()

/obj/item/robot_module/proc/respawn_consumable(mob/living/silicon/robot/R)
	return

/obj/item/robot_module/proc/rebuild() // Rebuilds the list so it's possible to add/remove items from the module.
	var/list/temp_list = modules
	modules = list()
	for(var/obj/O in temp_list)
		if(isnotnull(O))
			modules.Add(O)

/obj/item/robot_module/proc/add_languages(mob/living/silicon/robot/R)
	R.add_language("Binary Audio Language", FALSE)