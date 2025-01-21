/*
 * Combat Model
 */
/obj/item/robot_model/combat
	name = "combat robot model"

	module_types = list(
		/obj/item/flashlight,
		/obj/item/flash,
		/obj/item/borg/sight/thermal,
		/obj/item/gun/energy/laser/cyborg,
		/obj/item/pickaxe/plasmacutter,
		/obj/item/borg/combat/shield,
		/obj/item/borg/combat/mobility,
		/obj/item/wrench // Is a combat android really going to be stopped by a chair?
	)
	emag_type = /obj/item/gun/energy/lasercannon/cyborg

	channels = list(CHANNEL_SECURITY = TRUE)

	sprite_path = 'icons/mob/silicon/robot/combat.dmi'
	sprites = list(
		"Combat Android" = "droid_combat"
	)