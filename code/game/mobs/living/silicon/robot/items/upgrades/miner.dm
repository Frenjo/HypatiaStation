/*
 * Jetpack Module
 */
/obj/item/robot_upgrade/jetpack
	name = "mining robot jetpack module"
	desc = "A carbon dioxide jetpack suitable for low-gravity mining operations."
	icon_state = "robot_upgrade3"

	matter_amounts = /datum/design/robofab/robot_upgrade/jetpack::materials

	require_model = TRUE
	model_types = list(/obj/item/robot_model/miner)

/obj/item/robot_upgrade/jetpack/action(mob/living/silicon/robot/robby, mob/living/user = usr)
	if(!..())
		return FALSE
	if(isnotnull(robby.internals))
		to_chat(user, SPAN_WARNING("\The [robby] already has a jetpack installed!"))
		return FALSE

	var/obj/item/robot_model/miner/model = robby.model
	model.modules.Add(new /obj/item/tank/jetpack/carbon_dioxide(src))
	for(var/obj/item/tank/jetpack/carbon_dioxide/jetpack in model.modules)
		robby.internals = jetpack
	robby.updateicon()
	return TRUE