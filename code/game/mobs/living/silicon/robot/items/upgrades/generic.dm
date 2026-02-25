/*
 * VTEC Module
 */
/obj/item/robot_upgrade/vtec
	name = "robot VTEC module"
	desc = "Used to kick in a robot's VTEC systems, increasing its speed."
	icon_state = "vtec" //upgrade2

	matter_amounts = /datum/design/robofab/robot_upgrade/vtec::materials

	require_model = TRUE

	var/move_delay_reduction = 0.5

/obj/item/robot_upgrade/vtec/action(mob/living/silicon/robot/robby, mob/living/user)
	if(!..())
		return FALSE
	if(robby.speed == (initial(robby.speed) - move_delay_reduction))
		return FALSE

	robby.speed -= move_delay_reduction
	return TRUE

/*
 * Expander Module
 *
 * Does exactly what it says on the tin.
 */
/obj/item/robot_upgrade/expander
	name = "robot expander module"
	desc = "A robot resizer, it makes a robot huge."
	icon_state = "expander" //upgrade3

/obj/item/robot_upgrade/expander/action(mob/living/silicon/robot/robby, mob/living/user)
	if(!..())
		return FALSE

	if(robby.is_expanded)
		to_chat(user, SPAN_WARNING("\The [robby] already has an expander module installed!"))
		return FALSE
	robby.is_expanded = TRUE

	robby.anchored = TRUE
	make_smoke(5, FALSE, robby.loc, robby)
	spawn(0.2 SECONDS)
		for(var/i in 1 to 4)
			playsound(robby, pick('sound/items/welder.ogg', 'sound/items/ratchet.ogg'), 80, 1, -1)
			sleep(1.2 SECONDS)
		robby.update_transform(RESIZE_DOUBLE_SIZE)
		robby.anchored = FALSE
	return TRUE