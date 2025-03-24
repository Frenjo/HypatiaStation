/*
 * Swarmer Model
 */
/obj/item/robot_model/swarmer
	name = "swarmer robot model"
	display_name = "Swarmer"

	basic_modules = list(
		/obj/item/flash,
		/obj/item/extinguisher,
		/obj/item/gun/energy/disabler/cyborg,
		/obj/item/swarmer_teleporter
	)
	emag_type = /obj/item/borg/stun

	sprite_path = 'icons/mob/silicon/robot/swarmer.dmi'
	sprites = list(
		"Swarmmate" = "swarmmate"
	)

	can_be_pushed = FALSE