/*
 * Combat Model
 */
/obj/item/robot_model/combat
	name = "combat robot model"
	display_name = "Combat"

	model_icon = "security"

	basic_modules = list(
		/obj/item/flash,
		/obj/item/extinguisher/mini,
		/obj/item/robot_module/sight/thermal,
		/obj/item/gun/energy/laser/cyborg,
		/obj/item/pickaxe/plasmacutter,
		/obj/item/robot_module/combat_shield,
		/obj/item/robot_module/combat_mobility,
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