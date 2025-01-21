/*
 * Cyborg/Robot Upgrades
 *
 * Contains various borg upgrades.
 */
/*
 * Base Upgrade
 */
/obj/item/borg/upgrade
	name = "borg upgrade module"
	desc = "Protected by FRM."
	icon = 'icons/obj/items/module.dmi'
	icon_state = "cyborg_upgrade"

	var/construction_time = 120
	var/construction_cost = list(MATERIAL_METAL = 10000)

	var/locked = FALSE
	var/installed = FALSE

	var/require_model = FALSE
	var/list/model_types = null

/obj/item/borg/upgrade/proc/action(mob/living/silicon/robot/borg, mob/living/user = usr)
	if(borg.stat == DEAD)
		to_chat(user, SPAN_WARNING("The [src] will not function on a deceased robot."))
		return FALSE
	if(isnotnull(model_types) && !is_type_in_list(borg.module, model_types))
		to_chat(borg, SPAN_WARNING("Upgrade mounting error! No suitable hardpoint detected!"))
		to_chat(user, SPAN_WARNING("There's no mounting point for the module!"))
		return FALSE
	return TRUE

/*
 * Reset Module
 */
/obj/item/borg/upgrade/reset
	name = "robot model reset module"
	desc = "Used to reset a robot's model. Destroys any other upgrades applied to the robot."
	icon_state = "cyborg_upgrade1"

	require_model = TRUE

/obj/item/borg/upgrade/reset/action(mob/living/silicon/robot/borg, mob/living/user = usr)
	if(!..())
		return FALSE

	borg.uneq_all()
	borg.hands.icon_state = "nomod"
	borg.icon_state = "robot"
	for(var/camera_network in borg.module.camera_networks)
		borg.camera.network.Remove(camera_network)
	QDEL_NULL(borg.module)
	borg.updatename("Default")
	borg.status_flags |= CANPUSH
	borg.updateicon()
	return TRUE

/*
 * Rename Module
 */
/obj/item/borg/upgrade/rename
	name = "robot reclassification module"
	desc = "Used to rename a robot."
	icon_state = "cyborg_upgrade1"

	construction_cost = list(MATERIAL_METAL = MATERIAL_AMOUNT_PER_SHEET * 11)

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

	construction_cost = list(MATERIAL_METAL = MATERIAL_AMOUNT_PER_SHEET * 18, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 3)

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

	construction_cost = list(
		MATERIAL_METAL = MATERIAL_AMOUNT_PER_SHEET * 24,
		/decl/material/glass = 6000,
		/decl/material/gold = MATERIAL_AMOUNT_PER_SHEET * 3
	)

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
 * Rapid Taser Cooling Module
 *
 * This actually reduces the recharge time, not the fire delay.
 */
/obj/item/borg/upgrade/tasercooler
	name = "security robot rapid taser cooling module"
	desc = "Used to cool a mounted taser, increasing the potential current in it and thus its recharge rate."
	icon_state = "cyborg_upgrade3"

	construction_cost = list(
		MATERIAL_METAL = MATERIAL_AMOUNT_PER_SHEET * 24, /decl/material/glass = 6000,
		/decl/material/gold = 2000, /decl/material/diamond = MATERIAL_AMOUNT_PER_SHEET
	)

	require_model = TRUE
	model_types = list(/obj/item/robot_model/security)

/obj/item/borg/upgrade/tasercooler/action(mob/living/silicon/robot/borg, mob/living/user = usr)
	if(!..())
		return FALSE

	var/obj/item/gun/energy/taser/cyborg/taser = locate() in borg.module
	if(isnull(taser))
		taser = locate() in borg.module.contents
	if(isnull(taser))
		taser = locate() in borg.module.modules
	if(isnull(taser))
		to_chat(user, SPAN_WARNING("This robot has had its taser removed!"))
		return FALSE

	if(taser.recharge_time <= 2)
		to_chat(borg, SPAN_WARNING("Maximum cooling achieved for this hardpoint!"))
		to_chat(user, SPAN_WARNING("There's no room for another cooling unit!"))
		return FALSE

	taser.recharge_time = max(2 , taser.recharge_time - 4)
	return TRUE

/*
 * Jetpack Module
 */
/obj/item/borg/upgrade/jetpack
	name = "mining robot jetpack module"
	desc = "A carbon dioxide jetpack suitable for low-gravity mining operations."
	icon_state = "cyborg_upgrade3"

	construction_cost = list(MATERIAL_METAL = 10000, /decl/material/uranium = 20000, /decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 8)

	require_model = TRUE
	model_types = list(/obj/item/robot_model/miner)

/obj/item/borg/upgrade/jetpack/action(mob/living/silicon/robot/borg, mob/living/user = usr)
	if(!..())
		return FALSE
	if(isnotnull(borg.internals))
		return FALSE

	var/obj/item/robot_model/miner/module = borg.module
	module.modules.Add(new /obj/item/tank/jetpack/carbon_dioxide(src))
	for(var/obj/item/tank/jetpack/carbon_dioxide/jetpack in module.modules)
		borg.internals = jetpack
	//borg.icon_state="Miner+j"
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

	construction_cost = list(MATERIAL_METAL = 10000, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 8, /decl/material/diamond = 10000)

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
 * This doesn't actually work and isn't available but it's here for posterity.
 */
/obj/item/borg/upgrade/flashproof
	name = "robot flash-suppression module"
	desc = "A highly advanced, complex system for supressing incoming flashes directed at a robot's optical processing system."
	icon_state = "cyborg_upgrade4"

	construction_cost = list(
		MATERIAL_METAL = 10000, /decl/material/glass = 2000, /decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 2,
		/decl/material/gold = 2000, /decl/material/diamond = MATERIAL_AMOUNT_PER_SHEET * 3
	)

	require_model = TRUE

/obj/item/borg/upgrade/flashproof/action(mob/living/silicon/robot/borg, mob/living/user = usr)
	if(!..())
		return FALSE

	borg.module += src
	return TRUE