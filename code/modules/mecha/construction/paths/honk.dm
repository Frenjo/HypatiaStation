// H.O.N.K Chassis
/datum/construction/mecha_chassis/honk
	steps = list(
		list("key" = /obj/item/mecha_part/part/honk_torso),
		list("key" = /obj/item/mecha_part/part/honk_left_arm),
		list("key" = /obj/item/mecha_part/part/honk_right_arm),
		list("key" = /obj/item/mecha_part/part/honk_left_leg),
		list("key" = /obj/item/mecha_part/part/honk_right_leg),
		list("key" = /obj/item/mecha_part/part/honk_head)
	)

/datum/construction/mecha_chassis/honk/spawn_result()
	var/obj/item/mecha_part/chassis/const_holder = holder
	const_holder.construct = new /datum/construction/mecha_honk(const_holder)
	const_holder.density = TRUE
	qdel(src)

// H.O.N.K
/datum/construction/mecha_honk
	result = /obj/mecha/combat/honk
	steps = list(
		list("key" = /obj/item/bikehorn),								//1
		list("key" = /obj/item/clothing/shoes/clown_shoes),				//2
		list("key" = /obj/item/bikehorn),								//3
		list("key" = /obj/item/clothing/mask/gas/clown_hat),			//4
		list("key" = /obj/item/screwdriver),							//5
		list("key" = /obj/item/circuitboard/mecha/honk/targeting),		//6
		list("key" = /obj/item/screwdriver),							//7
		list("key" = /obj/item/circuitboard/mecha/honk/peripherals),	//8
		list("key" = /obj/item/screwdriver),							//9
		list("key" = /obj/item/circuitboard/mecha/honk/main),			//10
		list("key" = /obj/item/bikehorn)								//11
	)

/datum/construction/mecha_honk/custom_action(step, obj/item/used_item, mob/living/user)
	if(!..())
		return FALSE

	if(istype(used_item, /obj/item/bikehorn))
		playsound(holder, 'sound/items/bikehorn.ogg', 50, 1)
		user.visible_message("HONK!")
		return TRUE

	switch(step)
		if(10)
			user.visible_message(
					SPAN_NOTICE("[user] installs the central control module into \the [holder]."),
					SPAN_NOTICE("You install the central control module into \the [holder].")
				)
			qdel(used_item)
		if(9)
			user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]' mainboard."),
					SPAN_NOTICE("You secure \the [holder]' mainboard.")
				)
		if(8)
			user.visible_message(
					SPAN_NOTICE("[user] installs the peripherals control module into \the [holder]."),
					SPAN_NOTICE("You install the peripherals control module into \the [holder].")
				)
			qdel(used_item)
		if(7)
			user.visible_message(
					SPAN_NOTICE("[user] secures \the [holder]' peripherals control module."),
					SPAN_NOTICE("You secure \the [holder]' peripherals control module.")
				)
		if(6)
			MECHA_INSTALL_TARGETING_MODULE
			qdel(used_item)
		if(5)
			MECHA_SECURE_TARGETING_MODULE
		if(4)
			user.visible_message(
				SPAN_NOTICE("[user] puts a clown wig and mask on \the [holder]."),
				SPAN_NOTICE("You put a clown wig and mask on \the [holder].")
			)
			qdel(used_item)
		if(2)
			user.visible_message(
				SPAN_NOTICE("[user] puts clown shoes on \the [holder]."),
				SPAN_NOTICE("You put clown shoes on \the [holder].")
			)
			qdel(used_item)
	return TRUE

/datum/construction/mecha_honk/spawn_result()
	. = ..()
	feedback_inc("mecha_honk_created", 1)