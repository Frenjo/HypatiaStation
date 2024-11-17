// Durand Chassis
/datum/construction/mecha/chassis/durand
	steps = list(
		list("key" = /obj/item/mecha_part/part/durand_torso),		//1
		list("key" = /obj/item/mecha_part/part/durand_left_arm),	//2
		list("key" = /obj/item/mecha_part/part/durand_right_arm),	//3
		list("key" = /obj/item/mecha_part/part/durand_left_leg),	//4
		list("key" = /obj/item/mecha_part/part/durand_right_leg),	//5
		list("key" = /obj/item/mecha_part/part/durand_head)
	)

/datum/construction/mecha/chassis/durand/spawn_result()
	var/obj/item/mecha_part/chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/durand(const_holder)
	const_holder.icon = 'icons/mecha/mech_construction.dmi'
	const_holder.icon_state = "durand0"
	const_holder.density = TRUE
	spawn()
		qdel(src)