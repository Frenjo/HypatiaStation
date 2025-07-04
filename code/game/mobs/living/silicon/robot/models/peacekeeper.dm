/*
 * Peacekeeper Model
 */
/obj/item/robot_model/peacekeeper
	name = "peacekeeper robot model"
	display_name = "Peacekeeper"

	basic_modules = list(
		/obj/item/flash,
		/obj/item/fire_extinguisher/mini,
		/obj/item/reagent_holder/borghypo/peace,
		/obj/item/rsf/cookie,
		/obj/item/harm_alarm
	)
	emag_modules = list(/obj/item/reagent_holder/spray/polyacid)

	channels = list(CHANNEL_SECURITY)

	sprite_path = 'icons/mob/silicon/robot/peacekeeper.dmi'
	sprites = list(
		"Default" = "peaceborg",
		"Detective" = "peaceborg-noir",
		"Noir" = "peaceborg-noirbw",
		"Warden" = "peaceborg-warden",
		"Head of Peacekeeping" = "peaceborg-hos"
	)
	model_select_sprite = "peaceborg"

	can_be_pushed = FALSE

	advanced_huds = list(SILICON_HUD_SECURITY)

/obj/item/robot_model/peacekeeper/respawn_consumable(mob/living/silicon/robot/robby)
	. = ..()
	if(robby.emagged)
		var/obj/item/reagent_holder/spray/polyacid/spray = locate() in modules
		spray.reagents.add_reagent("pacid", 2)

/obj/item/robot_model/peacekeeper/get_playstyle_string()
	. = SPAN_DANGER("Remember: You are an enforcer of the PEACE and preventer of HARM. You are NOT a security officer and must follow your laws above all else.")