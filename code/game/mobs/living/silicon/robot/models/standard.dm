/*
 * Standard Model
 */
/obj/item/robot_model/standard
	name = "standard robot model"

	module_types = list(
		/obj/item/flashlight,
		/obj/item/flash,
		/obj/item/melee/baton/loaded,
		/obj/item/extinguisher,
		/obj/item/wrench,
		/obj/item/crowbar,
		/obj/item/health_analyser
	)
	emag_type = /obj/item/melee/energy/sword

	sprites = list(
		"Basic" = "robot_old",
		"Android" = "droid",
		"Default" = "robot"
	)