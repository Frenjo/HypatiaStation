/*
 * Transform Upgrades
 * (Model Pickers)
 */
// Standard
/obj/item/robot_upgrade/transform
	name = "robot model transformer (Standard)"
	desc = "Transforms a robot to the standard model."
	icon_state = "robot_upgrade1"

	var/new_model_type = /obj/item/robot_model/standard

/obj/item/robot_upgrade/transform/action(mob/living/silicon/robot/robby, mob/living/user = usr)
	if(!..())
		return FALSE
	if(isnull(new_model_type))
		return FALSE

	robby.transform_to_model(new_model_type)
	return TRUE

// Syndicate
/obj/item/robot_upgrade/transform/syndicate
	name = "robot model transformer (Syndicate)"
	desc = "Transforms a robot to the Syndicate model."
	icon_state = "robot_upgrade3"

	origin_tech = alist(/decl/tech/combat = 5, /decl/tech/syndicate = 6)

	new_model_type = /obj/item/robot_model/syndicate