/*
 * Reset Module
 */
/obj/item/robot_upgrade/reset
	name = "robot model reset module"
	desc = "Used to reset a robot's model. Destroys any other upgrades applied to the robot."
	icon_state = "upgrade1"

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
	icon_state = "upgrade1"

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
	icon_state = "upgrade1"

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