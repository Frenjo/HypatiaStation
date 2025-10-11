/*
 * Rapid Taser Cooling Module
 *
 * This actually reduces the recharge time, not the fire delay.
 */
/obj/item/robot_upgrade/tasercooler
	name = "security robot rapid taser cooling module"
	desc = "Used to cool a mounted taser, increasing the potential current in it and thus its recharge rate."
	icon_state = "taser_cooler" //upgrade3

	matter_amounts = /datum/design/robofab/robot_upgrade/taser_cooler::materials

	require_model = TRUE
	model_types = list(/obj/item/robot_model/security)

/obj/item/robot_upgrade/tasercooler/action(mob/living/silicon/robot/robby, mob/living/user)
	if(!..())
		return FALSE

	var/obj/item/gun/energy/taser/cyborg/taser = locate() in robby.model
	if(isnull(taser))
		taser = locate() in robby.model.contents
	if(isnull(taser))
		taser = locate() in robby.model.modules
	if(isnull(taser))
		to_chat(user, SPAN_WARNING("\The [robby] has had its taser removed!"))
		return FALSE

	if(taser.recharge_time <= 2)
		to_chat(robby, SPAN_WARNING("Maximum cooling achieved for this hardpoint!"))
		to_chat(user, SPAN_WARNING("There's no room for another cooling unit!"))
		return FALSE

	taser.recharge_time = max(2 , taser.recharge_time - 4)
	return TRUE