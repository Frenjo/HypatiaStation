/*
 * Mining Model
 */
/obj/item/robot_model/miner
	name = "miner robot model"
	display_name = "Miner"

	// The shovel was removed due to the buffed drill.
	basic_modules = list(
		/obj/item/flash,
		/obj/item/fire_extinguisher/mini,
		/obj/item/robot_module/sight/meson,
		/obj/item/storage/bag/ore,
		/obj/item/pickaxe/drill/cyborg,
		/obj/item/storage/bag/sheetsnatcher/borg,
		/obj/item/weldingtool,
		/obj/item/crowbar
	)
	emag_modules = list(/obj/item/robot_module/stun, /obj/item/pickaxe/drill/diamond)

	channels = list(CHANNEL_MINING)
	camera_networks = list("MINE")

	sprite_path = 'icons/mob/silicon/robot/miner.dmi'
	sprites = list(
		"Basic" = "miner-old",
		"Advanced Droid" = "droid-miner",
		"Treadhead" = "miner"
	)
	model_select_sprite = "miner"

	integrated_light_range = 6 // Equivalent to a mining lantern.

/obj/item/robot_model/miner/on_move(mob/living/silicon/robot/robby)
	. = ..()
	var/turf/open/floor/plating/asteroid/new_loc = robby.loc
	if(!istype(new_loc))
		return
	if(istype(robby.module_state_1, /obj/item/storage/bag/ore))
		new_loc.attack_by(robby.module_state_1, robby)
	else if(istype(robby.module_state_2, /obj/item/storage/bag/ore))
		new_loc.attack_by(robby.module_state_2, robby)
	else if(istype(robby.module_state_3, /obj/item/storage/bag/ore))
		new_loc.attack_by(robby.module_state_3, robby)

/obj/item/robot_model/miner/on_emag(mob/living/silicon/robot/robby)
	var/obj/item/pickaxe/drill/cyborg/drill = locate() in modules // Removes the regular drill.
	qdel(drill)
	. = ..()

/obj/item/robot_model/miner/on_unemag(mob/living/silicon/robot/robby)
	modules.Add(new /obj/item/pickaxe/drill/cyborg(src)) // Re-adds the regular drill.
	. = ..()