/*
 * Experimental Welding Torch Module
 *
 * Replaces an engineering robot's industrial welding torch with the experimental version.
 * This reduces the capacity but adds passive fuel regeneration.
 */
/obj/item/robot_upgrade/experimental_welder
	name = "engineering robot experimental welding torch module"
	desc = "A modified experimental welding torch designed for an engineering robot."
	icon_state = "experimental_welder"

	matter_amounts = /datum/design/robofab/robot_upgrade/experimental_welder::materials
	origin_tech = /datum/design/robofab/robot_upgrade/experimental_welder::req_tech

	require_model = TRUE
	model_types = list(/obj/item/robot_model/engineering)

/obj/item/robot_upgrade/experimental_welder/action(mob/living/silicon/robot/robby, mob/living/user = usr)
	if(!..())
		return FALSE
	var/obj/item/robot_model/engineering/model = robby.model
	if(locate(/obj/item/welding_torch/experimental) in model.modules)
		to_chat(user, SPAN_WARNING("\The [robby] already has an experimental welding torch installed!")) // Can only have one!
		return FALSE

	// Removes the standard welding torch.
	var/obj/item/welding_torch/industrial/welder = locate() in model.modules
	qdel(welder)

	model.modules.Add(new /obj/item/welding_torch/experimental(src)) // Adds an experimental welding torch.
	model.rebuild()
	return TRUE