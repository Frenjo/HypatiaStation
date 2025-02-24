/*
 * Peacekeeper Model
 */
/obj/item/robot_model/peacekeeper
	name = "peacekeeper robot model"
	display_name = "Peacekeeper"

	basic_modules = list(
		/obj/item/flash,
		/obj/item/extinguisher,
		/obj/item/reagent_holder/borghypo/peace,
		/obj/item/rsf/cookie,
		/obj/item/harm_alarm
	)
	emag_type = /obj/item/reagent_holder/spray/polyacid

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

/obj/item/robot_model/peacekeeper/respawn_consumable(mob/living/silicon/robot/robby)
	if(isnotnull(emag))
		var/obj/item/reagent_holder/spray/polyacid/spray = emag
		spray.reagents.add_reagent("pacid", 2)

/obj/item/robot_model/peacekeeper/get_playstyle_string()
	. = SPAN_DANGER("Remember: You are an enforcer of the PEACE and preventer of HARM. You are NOT a security officer and must follow your laws above all else.")