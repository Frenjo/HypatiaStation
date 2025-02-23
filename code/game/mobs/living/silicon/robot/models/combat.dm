/*
 * Combat Model
 */
/obj/item/robot_model/combat
	name = "combat robot model"
	display_name = "Combat"

	basic_modules = list(
		/obj/item/flash,
		/obj/item/borg/sight/thermal,
		/obj/item/gun/energy/laser/cyborg,
		/obj/item/pickaxe/plasmacutter,
		/obj/item/borg/combat/shield,
		/obj/item/borg/combat/mobility,
		/obj/item/wrench // Is a combat android really going to be stopped by a chair?
	)
	emag_type = /obj/item/gun/energy/lasercannon/cyborg

	channels = list(CHANNEL_SECURITY)

	sprite_path = 'icons/mob/silicon/robot/combat.dmi'
	sprites = list(
		"Combat Android" = "droid-combat"
	)
	model_select_sprite = "droid-combat"

	can_be_pushed = FALSE