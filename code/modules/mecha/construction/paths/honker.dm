// Honker Chassis
/datum/construction/mecha/chassis/honker
	steps = list(
		list("key" = /obj/item/mecha_part/part/honker_torso),		//1
		list("key" = /obj/item/mecha_part/part/honker_left_arm),	//2
		list("key" = /obj/item/mecha_part/part/honker_right_arm),	//3
		list("key" = /obj/item/mecha_part/part/honker_left_leg),	//4
		list("key" = /obj/item/mecha_part/part/honker_right_leg),	//5
		list("key" = /obj/item/mecha_part/part/honker_head)
	)

/datum/construction/mecha/chassis/honker/spawn_result()
	var/obj/item/mecha_part/chassis/const_holder = holder
	const_holder.construct = new /datum/construction/mecha/honker(const_holder)
	const_holder.density = TRUE
	spawn()
		qdel(src)

// Honker
/datum/construction/mecha/honker
	result = /obj/mecha/combat/honker
	steps = list(
		list("key" = /obj/item/bikehorn),								//1
		list("key" = /obj/item/clothing/shoes/clown_shoes),						//2
		list("key" = /obj/item/bikehorn),								//3
		list("key" = /obj/item/clothing/mask/gas/clown_hat),					//4
		list("key" = /obj/item/bikehorn),								//5
		list("key" = /obj/item/circuitboard/mecha/honker/targeting),		//6
		list("key" = /obj/item/bikehorn),								//7
		list("key" = /obj/item/circuitboard/mecha/honker/peripherals),	//8
		list("key" = /obj/item/bikehorn),								//9
		list("key" = /obj/item/circuitboard/mecha/honker/main),			//10
		list("key" = /obj/item/bikehorn),								//11
	)

/datum/construction/mecha/honker/custom_action(step, atom/used_atom, mob/user)
	if(!..())
		return FALSE

	if(istype(used_atom, /obj/item/bikehorn))
		playsound(holder, 'sound/items/bikehorn.ogg', 50, 1)
		user.visible_message("HONK!")

	//TODO: better messages.
	switch(step)
		if(10)
			user.visible_message(
				SPAN_NOTICE("[user] installs the central control module into \the [holder]."),
				SPAN_NOTICE("You install the central control module into \the [holder].")
			)
			qdel(used_atom)
		if(8)
			user.visible_message(
				SPAN_NOTICE("[user] installs the peripherals control module into \the [holder]."),
				SPAN_NOTICE("You install the peripherals control module into \the [holder].")
			)
			qdel(used_atom)
		if(6)
			user.visible_message(
				SPAN_NOTICE("[user] installs the weapon control module into \the [holder]."),
				SPAN_NOTICE("You install the weapon control module into \the [holder].")
			)
			qdel(used_atom)
		if(4)
			user.visible_message(
				SPAN_NOTICE("[user] puts a clown wig and mask on \the [holder]."),
				SPAN_NOTICE("You put a clown wig and mask on \the [holder].")
			)
			qdel(used_atom)
		if(2)
			user.visible_message(
				SPAN_NOTICE("[user] puts clown boots on \the [holder]."),
				SPAN_NOTICE("You put clown boots on \the [holder].")
			)
			qdel(used_atom)
	return TRUE

/datum/construction/mecha/honker/spawn_result()
	. = ..()
	feedback_inc("mecha_honker_created", 1)