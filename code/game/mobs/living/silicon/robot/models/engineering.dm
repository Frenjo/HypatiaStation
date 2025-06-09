/*
 * Engineering Model
 */
/obj/item/robot_model/engineering
	name = "engineering robot model"
	display_name = "Engineering"

	basic_modules = list(
		/obj/item/flash,
		/obj/item/extinguisher,
		/obj/item/robot_module/sight/meson,
		/obj/item/rcd/borg,
		/obj/item/weldingtool/largetank,
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/crowbar,
		/obj/item/wirecutters,
		/obj/item/multitool,
		/obj/item/t_scanner,
		/obj/item/gas_analyser,
		/obj/item/taperoll/engineering
	)
	emag_modules = list(/obj/item/robot_module/stun)

	channels = list(CHANNEL_ENGINEERING)
	camera_networks = list("Engineering")

	sprite_path = 'icons/mob/silicon/robot/engineering.dmi'
	sprites = list(
		"Basic" = "engineering",
		"Antique" = "engineerrobot",
		"Landmate" = "landmate",
		"Treadmate" = "treadmate"
	)
	model_select_sprite = "landmate"

/obj/item/robot_model/engineering/New()
	. = ..()
	modules.Add(new /obj/item/stack/sheet/steel/cyborg(src, 50))
	modules.Add(new /obj/item/stack/sheet/glass/reinforced/cyborg(src, 50))
	modules.Add(new /obj/item/stack/cable_coil(src, 50))

/obj/item/robot_model/engineering/respawn_consumable(mob/living/silicon/robot/robby)
	. = ..()
	var/list/stacks = list(
		/obj/item/stack/sheet/steel/cyborg,
		/obj/item/stack/sheet/glass/reinforced/cyborg,
		/obj/item/stack/cable_coil
	)
	for(var/path in stacks)
		var/obj/item/stack/stack = locate(path) in modules
		if(isnotnull(stack))
			if(stack.amount < 50)
				stack.amount++
		else
			modules.Remove(null)
			stack = new path(src, 1)
			modules.Add(stack)