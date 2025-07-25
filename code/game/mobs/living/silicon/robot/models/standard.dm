/*
 * Standard Model
 */
/obj/item/robot_model/standard
	name = "standard robot model"
	display_name = "Standard"

	basic_modules = list(
		/obj/item/flash,
		/obj/item/fire_extinguisher,
		/obj/item/melee/baton/loaded,
		/obj/item/wrench,
		/obj/item/crowbar,
		/obj/item/health_analyser
	)
	emag_modules = list(/obj/item/melee/energy/sword)

	sprite_path = 'icons/mob/silicon/robot/standard.dmi'
	sprites = list(
		"Default" = "robot",
		"Basic" = "robot-old",
		"Android" = "droid"
	)
	model_select_sprite = "robot"