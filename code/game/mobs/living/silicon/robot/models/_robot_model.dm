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
	var/model_select_sprite = null
	var/list/sprites = list() // Used to store the associations between sprite names and sprite index.

	var/can_be_pushed = TRUE // Whether this model can be pushed around.
	var/integrated_light_range = 4 // The range of this model's integrated light.

/obj/item/robot_model/New()
	. = ..()
	for(var/path in basic_modules)
		modules.Add(new path(src))
	emag = new emag_type(src)

	if(isnull(model_select_sprite) && length(sprites))
		model_select_sprite = sprites[sprites[1]]

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