/*
 * Syndicate Model
 */
/obj/item/robot_model/syndicate
	name = "syndicate robot model"
	display_name = "Syndicate"

	model_icon = "malf"

	basic_modules = list(
		/obj/item/flash,
		/obj/item/fire_extinguisher/mini,
		/obj/item/health_analyser,
		/obj/item/melee/energy/sword,
		/obj/item/gun/energy/pulse_rifle/destroyer,
		/obj/item/card/emag,
		/obj/item/crowbar,
		/obj/item/reagent_holder/borghypo/emagged
	)

	channels = list(CHANNEL_SYNDICATE)

	sprite_path = 'icons/mob/silicon/robot/syndicate.dmi'
	sprites = list(
		"Syndefault" = "syndefault",
		"Syndiehound" = "syndiehound",
		"Syndiehound - Treaded" = "syndiehound+tread",
		"Syndiemate" = "syndiemate",
		"Syndiemate - Treaded" = "syndiemate+tread",
		"Qualified Syndoctor" = "qualified-syndoctor"
	)
	model_select_sprite = "syndefault"

	can_be_pushed = FALSE

	integrated_light_colour = "#F03333"

	advanced_huds = list(SILICON_HUD_SECURITY)