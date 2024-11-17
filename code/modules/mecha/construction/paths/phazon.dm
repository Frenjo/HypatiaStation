// Phazon Chassis
/datum/construction/mecha/phazon_chassis
	result = /obj/mecha/combat/phazon
	steps = list(
		list("key" = /obj/item/mecha_part/part/phazon_torso),		//1
		list("key" = /obj/item/mecha_part/part/phazon_left_arm),	//2
		list("key" = /obj/item/mecha_part/part/phazon_right_arm),	//3
		list("key" = /obj/item/mecha_part/part/phazon_left_leg),	//4
		list("key" = /obj/item/mecha_part/part/phazon_right_leg),	//5
		list("key" = /obj/item/mecha_part/part/phazon_head)
	)

/datum/construction/mecha/phazon_chassis/custom_action(step, atom/used_atom, mob/user)
	user.visible_message(
		SPAN_NOTICE("[user] connects \the [used_atom] to \the [holder]."),
		SPAN_NOTICE("You connect \the [used_atom] to \the [holder].")
	)
	holder.overlays.Add(used_atom.icon_state + "+o")
	qdel(used_atom)
	return TRUE

/datum/construction/mecha/phazon_chassis/action(atom/used_atom, mob/user)
	return check_all_steps(used_atom, user)