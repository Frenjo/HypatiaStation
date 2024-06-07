/*
 * Cyborg/Robot Upgrades
 *
 * Contains various borg upgrades.
 */
/*
 * Base Upgrade
 */
/obj/item/borg/upgrade
	name = "borg upgrade module."
	desc = "Protected by FRM."
	icon = 'icons/obj/items/module.dmi'
	icon_state = "cyborg_upgrade"

	var/construction_time = 120
	var/construction_cost = list(MATERIAL_METAL = 10000)
	var/locked = FALSE
	var/require_module = FALSE
	var/installed = FALSE

/obj/item/borg/upgrade/proc/action(mob/living/silicon/robot/R)
	if(R.stat == DEAD)
		to_chat(usr, SPAN_WARNING("The [src] will not function on a deceased robot."))
		return FALSE
	return TRUE

/*
 * Reset Module
 */
/obj/item/borg/upgrade/reset
	name = "robot module reset board"
	desc = "Used to reset a robot's module. Destroys any other upgrades applied to the robot."
	icon_state = "cyborg_upgrade1"

	require_module = TRUE

/obj/item/borg/upgrade/reset/action(mob/living/silicon/robot/R)
	if(!..())
		return FALSE

	R.uneq_all()
	R.hands.icon_state = "nomod"
	R.icon_state = "robot"
	qdel(R.module)
	R.module = null
	R.camera.network.Remove(list("Engineering", "Medical", "MINE"))
	R.updatename("Default")
	R.status_flags |= CANPUSH
	R.updateicon()
	R.languages = list()
	R.speech_synthesizer_langs = list()
	return TRUE

/*
 * Rename Module
 */
/obj/item/borg/upgrade/rename
	name = "robot reclassification board"
	desc = "Used to rename a robot."
	icon_state = "cyborg_upgrade1"

	construction_cost = list(MATERIAL_METAL = 35000)

	var/heldname = "default name"

/obj/item/borg/upgrade/rename/attack_self(mob/user)
	heldname = stripped_input(user, "Enter new robot name", "Robot Reclassification", heldname, MAX_NAME_LEN)

/obj/item/borg/upgrade/rename/action(mob/living/silicon/robot/R)
	if(!..())
		return FALSE

	R.name = heldname
	R.custom_name = heldname
	R.real_name = heldname
	return TRUE

/*
 * Restart Module
 */
/obj/item/borg/upgrade/restart
	name = "robot emergency restart module"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	icon_state = "cyborg_upgrade1"

	construction_cost = list(MATERIAL_METAL = 60000, MATERIAL_GLASS = 5000)

/obj/item/borg/upgrade/restart/action(mob/living/silicon/robot/R)
	if(R.health < 0)
		to_chat(usr, "You have to repair the robot before using this module!")
		return 0

	if(isnull(R.key))
		for(var/mob/dead/observer/ghost in GLOBL.player_list)
			if(ghost.mind?.current == R)
				R.key = ghost.key
	R.stat = CONSCIOUS
	return TRUE

/*
 * VTEC Module
 */
#define VTEC_MOVE_DELAY_REDUCTION 0.5
/obj/item/borg/upgrade/vtec
	name = "robotic VTEC Module"
	desc = "Used to kick in a robot's VTEC systems, increasing their speed."
	icon_state = "cyborg_upgrade2"

	construction_cost = list(MATERIAL_METAL = 80000, MATERIAL_GLASS = 6000, MATERIAL_GOLD = 5000)
	require_module = TRUE

/obj/item/borg/upgrade/vtec/action(mob/living/silicon/robot/R)
	if(!..())
		return FALSE

	if(R.speed == (initial(R.speed) - VTEC_MOVE_DELAY_REDUCTION))
		return FALSE

	R.speed -= VTEC_MOVE_DELAY_REDUCTION
	return TRUE
#undef VTEC_MOVE_DELAY_REDUCTION

/*
 * Rapid Taser Cooling Module
 *
 * This actually reduces the recharge time, not the fire delay.
 */
/obj/item/borg/upgrade/tasercooler
	name = "robot rapid taser cooling module"
	desc = "Used to cool a mounted taser, increasing the potential current in it and thus its recharge rate."
	icon_state = "cyborg_upgrade3"

	construction_cost = list(MATERIAL_METAL = 80000, MATERIAL_GLASS = 6000, MATERIAL_GOLD = 2000, MATERIAL_DIAMOND = 500)
	require_module = TRUE

/obj/item/borg/upgrade/tasercooler/action(mob/living/silicon/robot/R)
	if(!..())
		return FALSE

	if(!istype(R.module, /obj/item/robot_module/security))
		to_chat(R, "Upgrade mounting error! No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return FALSE

	var/obj/item/gun/energy/taser/cyborg/T = locate() in R.module
	if(isnull(T))
		T = locate() in R.module.contents
	if(isnull(T))
		T = locate() in R.module.modules
	if(isnull(T))
		to_chat(usr, "This robot has had its taser removed!")
		return FALSE

	if(T.recharge_time <= 2)
		to_chat(R, "Maximum cooling achieved for this hardpoint!")
		to_chat(usr, "There's no room for another cooling unit!")
		return FALSE

	T.recharge_time = max(2 , T.recharge_time - 4)
	return TRUE

/*
 * Jetpack Module
 */
/obj/item/borg/upgrade/jetpack
	name = "mining robot jetpack"
	desc = "A carbon dioxide jetpack suitable for low-gravity mining operations."
	icon_state = "cyborg_upgrade3"

	construction_cost = list(MATERIAL_METAL = 10000, MATERIAL_PLASMA = 15000, MATERIAL_URANIUM = 20000)
	require_module = TRUE

/obj/item/borg/upgrade/jetpack/action(mob/living/silicon/robot/R)
	if(!..())
		return FALSE

	if(!istype(R.module, /obj/item/robot_module/miner))
		to_chat(R, "Upgrade mounting error! No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return FALSE

	R.module.modules.Add(new /obj/item/tank/jetpack/carbon_dioxide(src))
	for(var/obj/item/tank/jetpack/carbondioxide in R.module.modules)
		R.internals = src
	//R.icon_state="Miner+j"
	return TRUE

/*
 * Scrambled Equipment Module
 *
 * Used to be called "illegal equipment module".
 * I stole "scrambled" from Polaris because it sounds cooler.
 */
/obj/item/borg/upgrade/syndicate
	name = "scrambled equipment module"
	desc = "Unlocks the hidden, deadlier functions of a robot."
	icon_state = "cyborg_upgrade3"

	construction_cost = list(MATERIAL_METAL = 10000, MATERIAL_GLASS = 15000, MATERIAL_DIAMOND = 10000)
	require_module = TRUE

/obj/item/borg/upgrade/syndicate/action(mob/living/silicon/robot/R)
	if(!..())
		return FALSE

	if(R.emagged)
		return FALSE

	R.emagged = TRUE
	return TRUE

/*
 * Flash-Suppression Module
 *
 * This doesn't actually work and isn't available but it's here for posterity.
 */
/obj/item/borg/upgrade/flashproof
	name = "robot flash-suppression module"
	desc = "A highly advanced, complex system for supressing incoming flashes directed at the borg's optical processing system."
	icon_state = "cyborg_upgrade4"

	construction_cost = list(MATERIAL_METAL = 10000, MATERIAL_GLASS = 2000, MATERIAL_GOLD = 2000, MATERIAL_SILVER = 3000, MATERIAL_DIAMOND = 5000)
	require_module = TRUE

/obj/item/borg/upgrade/flashproof/action(mob/living/silicon/robot/R)
	if(!..())
		return FALSE

	R.module += src
	return TRUE