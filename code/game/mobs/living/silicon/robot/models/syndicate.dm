/*
 * Syndicate Model
 */
/obj/item/robot_model/syndicate
	name = "syndicate robot model"
	display_name = "Syndicate"

	basic_modules = list(
		/obj/item/flash,
		/obj/item/melee/energy/sword,
		/obj/item/gun/energy/pulse_rifle/destroyer,
		/obj/item/card/emag
	)

	channels = list(CHANNEL_SYNDICATE)

	sprite_path = 'icons/mob/silicon/robot/syndicate.dmi'
	sprites = list(
		"Syndefault" = "syndefault",
		"Syndiehound" = "syndiehound",
		"Syndiemate" = "syndiemate",
		"Qualified Syndoctor" = "qualified-syndoctor"
	)
	model_select_sprite = "syndefault"

	can_be_pushed = FALSE