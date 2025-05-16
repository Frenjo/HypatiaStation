/*
 * Reset Module
 */
/obj/item/borg/upgrade/reset
	name = "robot model reset module"
	desc = "Used to reset a robot's model. Destroys any other upgrades applied to the robot."
	icon_state = "cyborg_upgrade1"

	matter_amounts = /datum/design/robofab/robot_upgrade/reset::materials

	require_model = TRUE

/obj/item/borg/upgrade/reset/action(mob/living/silicon/robot/borg, mob/living/user = usr)
	if(!..())
		return FALSE

	borg.uneq_all()
	for(var/camera_network in borg.model.camera_networks)
		borg.camera.network.Remove(camera_network)
	QDEL_NULL(borg.model)
	borg.status_flags &= CANPUSH
	borg.transform_to_model(/obj/item/robot_model/default)
	return TRUE

/*
 * Rename Module
 */
/obj/item/borg/upgrade/rename
	name = "robot reclassification module"
	desc = "Used to rename a robot."
	icon_state = "cyborg_upgrade1"

	matter_amounts = /datum/design/robofab/robot_upgrade/rename::materials

	var/heldname = "default name"

/obj/item/borg/upgrade/rename/attack_self(mob/user)
	heldname = stripped_input(user, "Enter new robot name", "Robot Reclassification", heldname, MAX_NAME_LEN)

/obj/item/borg/upgrade/rename/action(mob/living/silicon/robot/borg, mob/living/user = usr)
	if(!..())
		return FALSE

	borg.name = heldname
	borg.custom_name = heldname
	borg.real_name = heldname
	return TRUE

/*
 * Restart Module
 */
/obj/item/borg/upgrade/restart
	name = "robot emergency restart module"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	icon_state = "cyborg_upgrade1"

	matter_amounts = /datum/design/robofab/robot_upgrade/restart::materials

/obj/item/borg/upgrade/restart/action(mob/living/silicon/robot/borg, mob/living/user = usr)
	if(borg.health < 0)
		to_chat(user, SPAN_WARNING("You have to repair the robot before using this module!"))
		return FALSE

	if(isnull(borg.key))
		for(var/mob/dead/ghost/ghost in GLOBL.player_list)
			if(ghost.mind?.current == borg)
				borg.key = ghost.key
	borg.stat = CONSCIOUS
	return TRUE

/*
 * VTEC Module
 */
/obj/item/borg/upgrade/vtec
	name = "robot VTEC module"
	desc = "Used to kick in a robot's VTEC systems, increasing its speed."
	icon_state = "cyborg_upgrade2"

	matter_amounts = /datum/design/robofab/robot_upgrade/vtec::materials

	require_model = TRUE

	var/move_delay_reduction = 0.5

/obj/item/borg/upgrade/vtec/action(mob/living/silicon/robot/borg, mob/living/user = usr)
	if(!..())
		return FALSE
	if(borg.speed == (initial(borg.speed) - move_delay_reduction))
		return FALSE

	borg.speed -= move_delay_reduction
	return TRUE

/*
 * Scrambled Equipment Module
 *
 * Used to be called "illegal equipment module".
 * I stole "scrambled" from Polaris because it sounds cooler.
 */
/obj/item/borg/upgrade/syndicate
	name = "robot scrambled equipment module"
	desc = "Unlocks the hidden, deadlier functions of a robot."
	icon_state = "cyborg_upgrade3"

	matter_amounts = /datum/design/robofab/robot_upgrade/syndicate::materials
	origin_tech = /datum/design/robofab/robot_upgrade/syndicate::req_tech

	require_model = TRUE

/obj/item/borg/upgrade/syndicate/action(mob/living/silicon/robot/borg, mob/living/user = usr)
	if(!..())
		return FALSE
	if(borg.emagged)
		return FALSE

	borg.emagged = TRUE
	return TRUE

/*
 * Flash-Suppression Module
 *
 * Renders a robot immune to flashes when installed.
 */
/obj/item/borg/upgrade/flashproof
	name = "robot flash-suppression module"
	desc = "A highly advanced, complex system for supressing incoming flashes directed at a robot's optical processing system."
	icon_state = "cyborg_upgrade4"

	matter_amounts = /datum/design/robofab/robot_upgrade/flashproof::materials
	origin_tech = /datum/design/robofab/robot_upgrade/flashproof::req_tech

	require_model = TRUE

/obj/item/borg/upgrade/flashproof/action(mob/living/silicon/robot/borg, mob/living/user = usr)
	if(!..())
		return FALSE

	if(!(borg.status_flags & CANWEAKEN))
		to_chat(user, SPAN_WARNING("\The [borg]'s optical processing system is already shielded."))
		return FALSE

	borg.status_flags &= ~CANWEAKEN
	return TRUE

/*
 * Expander Module
 *
 * Does exactly what it says on the tin.
 */
/obj/item/borg/upgrade/expander
	name = "robot expander module"
	desc = "A robot resizer, it makes a robot huge."
	icon_state = "cyborg_upgrade3"

/obj/item/borg/upgrade/expander/action(mob/living/silicon/robot/robby, mob/living/user = usr)
	if(!..())
		return FALSE

	if(robby.is_expanded)
		to_chat(user, SPAN_WARNING("This unit already has an expander module installed!"))
		return FALSE
	robby.is_expanded = TRUE

	robby.anchored = TRUE
	make_smoke(5, FALSE, robby.loc, robby)
	sleep(0.2 SECONDS)
	for(var/i in 1 to 4)
		playsound(robby, pick('sound/items/welder.ogg', 'sound/items/ratchet.ogg'), 80, 1, -1)
		sleep(1.2 SECONDS)
	robby.update_transform(2)
	robby.anchored = FALSE
	return TRUE