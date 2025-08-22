/*
 * Scrambled Equipment Module
 *
 * Used to be called "illegal equipment module".
 * I stole "scrambled" from Polaris because it sounds cooler.
 */
/obj/item/robot_upgrade/scrambled
	name = "robot scrambled equipment module"
	desc = "Unlocks the hidden, deadlier functions of a robot."
	icon_state = "scrambled" //upgrade3

	matter_amounts = /datum/design/robofab/robot_upgrade/scrambled::materials
	origin_tech = /datum/design/robofab/robot_upgrade/scrambled::req_tech

	require_model = TRUE

/obj/item/robot_upgrade/scrambled/action(mob/living/silicon/robot/robby, mob/living/user = usr)
	if(!..())
		return FALSE
	if(robby.emagged)
		return FALSE

	robby.emagged = TRUE
	return TRUE

/*
 * Flash-Suppression Module
 *
 * Renders a robot immune to flashes when installed.
 */
/obj/item/robot_upgrade/flashproof
	name = "robot flash-suppression module"
	desc = "A highly advanced, complex system for supressing incoming flashes directed at a robot's optical processing system."
	icon_state = "flashproof" //upgrade4

	matter_amounts = /datum/design/robofab/robot_upgrade/flashproof::materials
	origin_tech = /datum/design/robofab/robot_upgrade/flashproof::req_tech

	require_model = TRUE

/obj/item/robot_upgrade/flashproof/action(mob/living/silicon/robot/robby, mob/living/user = usr)
	if(!..())
		return FALSE

	if(!(robby.status_flags & CANWEAKEN))
		to_chat(user, SPAN_WARNING("\The [robby]'s optical processing system is already shielded."))
		return FALSE

	robby.status_flags &= ~CANWEAKEN
	return TRUE