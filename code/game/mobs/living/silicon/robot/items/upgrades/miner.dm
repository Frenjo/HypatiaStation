// Jetpack Module
/obj/item/robot_upgrade/jetpack
	name = "miner robot jetpack module"
	desc = "A carbon dioxide jetpack suitable for low-gravity mining operations."
	icon_state = "jetpack" //upgrade3

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

// Holding Satchel Module
/obj/item/robot_upgrade/holding_satchel
	name = "miner robot holding satchel module"
	desc = "A modified holding satchel designed for a miner robot."
	icon_state = "holding_satchel" //upgrade3

	matter_amounts = /datum/design/robofab/robot_upgrade/holding_satchel::materials
	origin_tech = /datum/design/robofab/robot_upgrade/holding_satchel::req_tech

	require_model = TRUE
	model_types = list(/obj/item/robot_model/miner)

/obj/item/robot_upgrade/holding_satchel/action(mob/living/silicon/robot/robby, mob/living/user = usr)
	if(!..())
		return FALSE
	var/obj/item/robot_model/miner/model = robby.model
	if(locate(/obj/item/storage/bag/ore/holding) in model.modules)
		to_chat(user, SPAN_WARNING("\The [robby] already has a holding satchel installed!")) // Can only have one!
		return FALSE

	// Removes the standard satchel.
	var/obj/item/storage/bag/ore/satchel = locate() in model.modules
	qdel(satchel)

	model.modules.Add(new /obj/item/storage/bag/ore/holding(src)) // Adds a holding satchel.
	model.rebuild()
	return TRUE