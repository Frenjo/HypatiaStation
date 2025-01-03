// Chassis
/datum/construction/mecha_chassis/custom_action(step, obj/item/used_item, mob/living/user)
	holder.balloon_alert_visible("connected [used_item.name]")
	holder.overlays.Add(used_item.icon_state + "+o")
	user.drop_item()
	qdel(used_item)
	return TRUE

/datum/construction/mecha_chassis/action(obj/item/used_item, mob/living/user)
	return check_all_steps(used_item, user)

/datum/construction/mecha_chassis/spawn_result()
	holder.icon = 'icons/obj/mecha/mech_construction.dmi'
	holder.overlays.len = 0

	var/obj/item/mecha_part/chassis/chassis = holder
	chassis.construct = new result(holder)
	qdel(src)