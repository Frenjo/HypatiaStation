// Durand Chassis
/datum/construction/mecha/durand_chassis
	steps = list(
		list("key" = /obj/item/mecha_part/part/durand_torso),		//1
		list("key" = /obj/item/mecha_part/part/durand_left_arm),	//2
		list("key" = /obj/item/mecha_part/part/durand_right_arm),	//3
		list("key" = /obj/item/mecha_part/part/durand_left_leg),	//4
		list("key" = /obj/item/mecha_part/part/durand_right_leg),	//5
		list("key" = /obj/item/mecha_part/part/durand_head)
	)

/datum/construction/mecha/durand_chassis/custom_action(step, atom/used_atom, mob/user)
	user.visible_message(
		SPAN_NOTICE("[user] connects \the [used_atom] to \the [holder]."),
		SPAN_NOTICE("You connect \the [used_atom] to \the [holder].")
	)
	holder.overlays.Add(used_atom.icon_state + "+o")
	qdel(used_atom)
	return TRUE

/datum/construction/mecha/durand_chassis/action(atom/used_atom, mob/user)
	return check_all_steps(used_atom, user)

/datum/construction/mecha/durand_chassis/spawn_result()
	var/obj/item/mecha_part/chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/durand(const_holder)
	const_holder.icon = 'icons/mecha/mech_construction.dmi'
	const_holder.icon_state = "durand0"
	const_holder.density = TRUE
	spawn()
		qdel(src)