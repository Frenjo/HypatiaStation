/*
 * Reset Module
 */
/obj/item/robot_upgrade/reset
	name = "robot model reset module"
	desc = "Used to reset a robot's model. Destroys any other upgrades applied to the robot."
	icon_state = "robot_upgrade1"

	matter_amounts = /datum/design/robofab/robot_upgrade/reset::materials

	require_model = TRUE

/obj/item/robot_upgrade/reset/action(mob/living/silicon/robot/robby, mob/living/user = usr)
	if(!..())
		return FALSE

	robby.uneq_all()
	for(var/camera_network in robby.model.camera_networks)
		robby.camera.network.Remove(camera_network)
	QDEL_NULL(robby.model)
	robby.status_flags &= CANPUSH
	robby.transform_to_model(/obj/item/robot_model/default)
	return TRUE

/*
 * Rename Module
 */
/obj/item/robot_upgrade/rename
	name = "robot reclassification module"
	desc = "Used to rename a robot."
	icon_state = "robot_upgrade1"

	matter_amounts = /datum/design/robofab/robot_upgrade/rename::materials

	var/heldname = "default name"

/obj/item/robot_upgrade/rename/attack_self(mob/user)
	heldname = stripped_input(user, "Enter new robot name", "Robot Reclassification", heldname, MAX_NAME_LEN)

/obj/item/robot_upgrade/rename/action(mob/living/silicon/robot/robby, mob/living/user = usr)
	if(!..())
		return FALSE

	robby.name = heldname
	robby.custom_name = heldname
	robby.real_name = heldname
	return TRUE

/*
 * Restart Module
 */
/obj/item/robot_upgrade/restart
	name = "robot emergency restart module"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	icon_state = "robot_upgrade1"

	matter_amounts = /datum/design/robofab/robot_upgrade/restart::materials

/obj/item/robot_upgrade/restart/action(mob/living/silicon/robot/robby, mob/living/user = usr)
	if(robby.health < 0)
		to_chat(user, SPAN_WARNING("You have to repair \the [robby] before using \the [src]!"))
		return FALSE

	if(isnull(robby.key))
		for(var/mob/dead/ghost/ghost in GLOBL.player_list)
			if(ghost.mind?.current == robby)
				robby.key = ghost.key
	robby.stat = CONSCIOUS
	return TRUE

/*
 * VTEC Module
 */
/obj/item/robot_upgrade/vtec
	name = "robot VTEC module"
	desc = "Used to kick in a robot's VTEC systems, increasing its speed."
	icon_state = "robot_upgrade2"

	matter_amounts = /datum/design/robofab/robot_upgrade/vtec::materials

	require_model = TRUE

	var/move_delay_reduction = 0.5

/obj/item/robot_upgrade/vtec/action(mob/living/silicon/robot/robby, mob/living/user = usr)
	if(!..())
		return FALSE
	if(robby.speed == (initial(robby.speed) - move_delay_reduction))
		return FALSE

	robby.speed -= move_delay_reduction
	return TRUE

/*
 * Scrambled Equipment Module
 *
 * Used to be called "illegal equipment module".
 * I stole "scrambled" from Polaris because it sounds cooler.
 */
/obj/item/robot_upgrade/syndicate
	name = "robot scrambled equipment module"
	desc = "Unlocks the hidden, deadlier functions of a robot."
	icon_state = "robot_upgrade3"

	matter_amounts = /datum/design/robofab/robot_upgrade/syndicate::materials
	origin_tech = /datum/design/robofab/robot_upgrade/syndicate::req_tech

	require_model = TRUE

/obj/item/robot_upgrade/syndicate/action(mob/living/silicon/robot/robby, mob/living/user = usr)
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
	icon_state = "robot_upgrade4"

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

/*
 * Expander Module
 *
 * Does exactly what it says on the tin.
 */
/obj/item/robot_upgrade/expander
	name = "robot expander module"
	desc = "A robot resizer, it makes a robot huge."
	icon_state = "robot_upgrade3"

/obj/item/robot_upgrade/expander/action(mob/living/silicon/robot/robby, mob/living/user = usr)
	if(!..())
		return FALSE

	if(robby.is_expanded)
		to_chat(user, SPAN_WARNING("\The [robby] already has an expander module installed!"))
		return FALSE
	robby.is_expanded = TRUE

	robby.anchored = TRUE
	make_smoke(5, FALSE, robby.loc, robby)
	sleep(0.2 SECONDS)
	for(var/i in 1 to 4)
		playsound(robby, pick('sound/items/welder.ogg', 'sound/items/ratchet.ogg'), 80, 1, -1)
		sleep(1.2 SECONDS)
	robby.update_transform(RESIZE_DOUBLE_SIZE)
	robby.anchored = FALSE
	return TRUE