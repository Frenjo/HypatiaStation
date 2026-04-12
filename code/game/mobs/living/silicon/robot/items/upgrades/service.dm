/*
 * Floral Somatoray Module
 *
 * Upgrades a service robot with a floral somatoray for advanced botanical duties.
 */
/obj/item/robot_upgrade/floral_somatoray
	name = "service robot floral somatoray module"
	desc = "A modified floral somatoray designed for a service robot."
	icon_state = "floral_somatoray"

	matter_amounts = /datum/design/robofab/robot_upgrade/floral_somatoray::materials
	origin_tech = /datum/design/robofab/robot_upgrade/floral_somatoray::req_tech

	require_model = TRUE
	model_types = list(/obj/item/robot_model/service)

/obj/item/robot_upgrade/floral_somatoray/action(mob/living/silicon/robot/robby, mob/living/user)
	if(!..())
		return FALSE
	var/obj/item/robot_model/service/model = robby.model
	if(locate(/obj/item/gun/energy/floragun) in model.modules)
		to_chat(user, SPAN_WARNING("\The [robby] already has a floral somatoray installed!")) // Can only have one!
		return FALSE

	model.modules.Add(new /obj/item/gun/energy/floragun(src)) // Adds a floral somatoray.
	model.rebuild()
	return TRUE