// H.O.N.K Chassis
/datum/construction/mecha/chassis/honk
	steps = list(
		list("key" = /obj/item/mecha_part/part/honk_torso),		//1
		list("key" = /obj/item/mecha_part/part/honk_left_arm),	//2
		list("key" = /obj/item/mecha_part/part/honk_right_arm),	//3
		list("key" = /obj/item/mecha_part/part/honk_left_leg),	//4
		list("key" = /obj/item/mecha_part/part/honk_right_leg),	//5
		list("key" = /obj/item/mecha_part/part/honk_head)
	)

/datum/construction/mecha/chassis/honk/spawn_result()
	var/obj/item/mecha_part/chassis/const_holder = holder
	const_holder.construct = new /datum/construction/mecha/honk(const_holder)
	const_holder.density = TRUE
	spawn()
		qdel(src)

// H.O.N.K
/datum/construction/mecha/honk
	result = /obj/mecha/combat/honk
	steps = list(
		list("key" = /obj/item/bikehorn),								//1
		list("key" = /obj/item/clothing/shoes/clown_shoes),				//2
		list("key" = /obj/item/bikehorn),								//3
		list("key" = /obj/item/clothing/mask/gas/clown_hat),			//4
		list("key" = /obj/item/bikehorn),								//5
		list("key" = /obj/item/circuitboard/mecha/honk/targeting),	//6
		list("key" = /obj/item/bikehorn),								//7
		list("key" = /obj/item/circuitboard/mecha/honk/peripherals),	//8
		list("key" = /obj/item/bikehorn),								//9
		list("key" = /obj/item/circuitboard/mecha/honk/main),			//10
		list("key" = /obj/item/bikehorn),								//11
	)

/datum/construction/mecha/honk/custom_action(step, atom/used_atom, mob/user)
	if(!..())
		return FALSE

	if(istype(used_atom, /obj/item/bikehorn))
		playsound(holder, 'sound/items/bikehorn.ogg', 50, 1)
		user.visible_message("HONK!")

	switch(step)
		if(10)
			MECHA_INSTALL_CENTRAL_MODULE
			qdel(used_atom)
		if(8)
			MECHA_INSTALL_PERIPHERAL_MODULE
			qdel(used_atom)
		if(6)
			MECHA_INSTALL_WEAPON_MODULE
			qdel(used_atom)
		if(4)
			user.visible_message(
				SPAN_NOTICE("[user] puts a clown wig and mask on \the [holder]."),
				SPAN_NOTICE("You put a clown wig and mask on \the [holder].")
			)
			qdel(used_atom)
		if(2)
			user.visible_message(
				SPAN_NOTICE("[user] puts clown shoes on \the [holder]."),
				SPAN_NOTICE("You put clown shoes on \the [holder].")
			)
			qdel(used_atom)
	return TRUE

/datum/construction/mecha/honk/spawn_result()
	. = ..()
	feedback_inc("mecha_honk_created", 1)