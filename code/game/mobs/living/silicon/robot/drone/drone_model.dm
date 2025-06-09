/*
 * Drone Model
 *
 * There's not much ROM to spare in that tiny microprocessor!
 */
/obj/item/robot_model/drone
	name = "drone robot model"
	display_name = "Drone"

	model_icon = "engineering"

	basic_modules = list(
		/obj/item/extinguisher/mini,
		/obj/item/weldingtool,
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/crowbar,
		/obj/item/wirecutters,
		/obj/item/multitool,
		/obj/item/lightreplacer,
		/obj/item/reagent_holder/spray/cleaner,
		/obj/item/gripper,
		/obj/item/matter_decompiler
	)
	emag_modules = list(/obj/item/card/emag)

	sprite_path = 'icons/mob/silicon/robot/drone.dmi'
	sprites = list(
		"Repairbot" = "repairbot",
		"Cogscarab" = "cogscarab"
	)

	integrated_light_range = 3

/obj/item/robot_model/drone/New()
	. = ..()
	var/list/stack_types = list(
		/obj/item/stack/rods = 10,
		/obj/item/stack/tile/metal/grey = 10,
		/obj/item/stack/sheet/steel/cyborg = 10,
		/obj/item/stack/sheet/wood/cyborg = 1,
		/obj/item/stack/cable_coil = 30,
		/obj/item/stack/sheet/glass/cyborg = 10,
		/obj/item/stack/sheet/plastic/cyborg = 1
	)

	for(var/path in stack_types)
		modules.Add(new path(src, stack_types[path]))

/obj/item/robot_model/drone/respawn_consumable(mob/living/silicon/robot/R)
	. = ..()
	var/obj/item/reagent_holder/spray/cleaner/spray = locate() in modules
	spray?.reagents.add_reagent("cleaner", 10)

	var/list/stack_types = list(
		/obj/item/stack/sheet/steel,
		/obj/item/stack/cable_coil,
		/obj/item/stack/sheet/glass/cyborg,
		/obj/item/stack/rods,
		/obj/item/stack/tile/metal/grey
	)

	for(var/path in stack_types)
		var/obj/item/stack/S = locate(path) in modules
		if(isnull(S))
			modules.Remove(null)
			S = new path(src, 0)
			modules.Add(S)

		if(S?.amount < 15)
			S.amount++

	var/obj/item/lightreplacer/replacer = locate() in modules
	replacer?.Charge(R)

/obj/item/robot_model/drone/add_languages(mob/living/silicon/robot/robby)
	. = ..()
	robby.remove_language("Robot Talk")
	robby.add_language("Robot Talk", FALSE)
	robby.remove_language("Drone Talk")
	robby.add_language("Drone Talk")