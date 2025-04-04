/*
 * Jetpack Module
 */
/obj/item/borg/upgrade/jetpack
	name = "mining robot jetpack module"
	desc = "A carbon dioxide jetpack suitable for low-gravity mining operations."
	icon_state = "cyborg_upgrade3"

	matter_amounts = /datum/design/robofab/robot_upgrade/jetpack::materials

	require_model = TRUE
	model_types = list(/obj/item/robot_model/miner)

/obj/item/borg/upgrade/jetpack/action(mob/living/silicon/robot/borg, mob/living/user = usr)
	if(!..())
		return FALSE
	if(isnotnull(borg.internals))
		return FALSE

	var/obj/item/robot_model/miner/model = borg.model
	model.modules.Add(new /obj/item/tank/jetpack/carbon_dioxide(src))
	for(var/obj/item/tank/jetpack/carbon_dioxide/jetpack in model.modules)
		borg.internals = jetpack
	//borg.icon_state="Miner+j"
	return TRUE