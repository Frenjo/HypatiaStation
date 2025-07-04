/*
 * Swarmer Model
 */
/obj/item/robot_model/swarmer
	name = "swarmer robot model"
	display_name = "Swarmer"

	basic_modules = list(
		/obj/item/flash,
		/obj/item/fire_extinguisher,
		/obj/item/storage/bag/sheetsnatcher/borg,
		/obj/item/gun/energy/disabler/cyborg,
		/obj/item/robot_module/swarmer_disperser,
		/obj/item/robot_module/swarmer_disintegrator
	)
	emag_modules = list(/obj/item/robot_module/stun)

	sprite_path = 'icons/mob/silicon/robot/swarmer.dmi'
	sprites = list(
		"Swarmmate" = "swarmmate"
	)

	can_be_pushed = FALSE

	integrated_light_colour = "#0066FF"

/obj/item/robot_model/swarmer/on_transform_to(mob/living/silicon/robot/robby)
	. = ..()
	robby.pass_flags |= PASS_FLAG_SWARMER