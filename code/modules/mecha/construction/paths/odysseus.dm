// Odysseus Chassis
/datum/construction/mecha/chassis/odysseus
	steps = list(
		list("key" = /obj/item/mecha_part/part/odysseus_torso),	//1
		list("key" = /obj/item/mecha_part/part/odysseus_head),		//2
		list("key" = /obj/item/mecha_part/part/odysseus_left_arm),	//3
		list("key" = /obj/item/mecha_part/part/odysseus_right_arm),//4
		list("key" = /obj/item/mecha_part/part/odysseus_left_leg),	//5
		list("key" = /obj/item/mecha_part/part/odysseus_right_leg)	//6
	)

/datum/construction/mecha/chassis/odysseus/spawn_result()
	var/obj/item/mecha_part/chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/odysseus(const_holder)
	const_holder.icon = 'icons/mecha/mech_construction.dmi'
	const_holder.icon_state = "odysseus0"
	const_holder.density = TRUE
	spawn()
		qdel(src)