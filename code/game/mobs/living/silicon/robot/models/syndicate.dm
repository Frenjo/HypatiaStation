/*
 * Syndicate Model
 */
/obj/item/robot_model/syndicate
	name = "syndicate robot model"
	display_name = "Syndicate"

	basic_modules = list(
		/obj/item/flashlight,
		/obj/item/flash,
		/obj/item/melee/energy/sword,
		/obj/item/gun/energy/pulse_rifle/destroyer,
		/obj/item/card/emag
	)

	sprite_path = 'icons/mob/silicon/robot/syndicate.dmi'
	sprites = list(
		"Default" = "syndie_bloodhound"
	)

	can_be_pushed = FALSE