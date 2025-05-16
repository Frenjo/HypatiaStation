/*
 * Base Upgrade
 */
/obj/item/robot_upgrade
	name = "robot upgrade module"
	desc = "Protected by FRM."
	icon = 'icons/obj/items/module.dmi'
	icon_state = "cyborg_upgrade"

	var/locked = FALSE
	var/installed = FALSE

	var/require_model = FALSE
	var/list/model_types = null

/obj/item/robot_upgrade/proc/action(mob/living/silicon/robot/borg, mob/living/user = usr)
	if(borg.stat == DEAD)
		to_chat(user, SPAN_WARNING("The [src] will not function on a deceased robot."))
		return FALSE
	if(isnotnull(model_types) && !is_type_in_list(borg.model, model_types))
		to_chat(borg, SPAN_WARNING("Upgrade mounting error! No suitable hardpoint detected!"))
		to_chat(user, SPAN_WARNING("There's no mounting point for the module!"))
		return FALSE
	return TRUE