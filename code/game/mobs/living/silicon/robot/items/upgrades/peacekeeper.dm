// Shield Projector Module
/obj/item/robot_upgrade/shield_projector
	name = "peacekeeper robot shield projector module"
	desc = "A small omnidirectional shield projector designed for a peacekeeper robot."
	icon_state = "shield_projector"

	matter_amounts = /datum/design/robofab/robot_upgrade/shield_projector::materials
	origin_tech = /datum/design/robofab/robot_upgrade/shield_projector::req_tech

	require_model = TRUE
	model_types = list(/obj/item/robot_model/peacekeeper)

/obj/item/robot_upgrade/shield_projector/action(mob/living/silicon/robot/robby, mob/living/user)
	if(!..())
		return FALSE
	var/obj/item/robot_model/peacekeeper/model = robby.model
	if(locate(/obj/item/shield_projector/rectangle/peacekeeper) in model.modules)
		to_chat(user, SPAN_WARNING("\The [robby] already has a shield projector installed!")) // Can only have one!
		return FALSE

	model.modules.Add(new /obj/item/shield_projector/rectangle/peacekeeper(src)) // Adds the shield projector.
	model.rebuild()
	return TRUE