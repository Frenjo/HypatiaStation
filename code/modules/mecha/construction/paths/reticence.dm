// Chassis
/datum/construction/mecha/chassis/reticence
	steps = list(
		list("key" = /obj/item/mecha_part/part/reticence_torso),		//1
		list("key" = /obj/item/mecha_part/part/reticence_left_arm),		//2
		list("key" = /obj/item/mecha_part/part/reticence_right_arm),	//3
		list("key" = /obj/item/mecha_part/part/reticence_left_leg),		//4
		list("key" = /obj/item/mecha_part/part/reticence_right_leg),	//5
		list("key" = /obj/item/mecha_part/part/reticence_head)
	)

/datum/construction/mecha/chassis/honk/spawn_result()
	var/obj/item/mecha_part/chassis/const_holder = holder
	const_holder.construct = new /datum/construction/mecha/reticence(const_holder)
	const_holder.density = TRUE
	spawn()
		qdel(src)

// Reticence
/datum/construction/mecha/reticence
	result = /obj/mecha/combat/reticence
	steps = list(
		list("key" = /obj/item/toy/crayon/mime),							//1
		list("key" = /obj/item/clothing/head/beret),						//2
		list("key" = /obj/item/toy/crayon/mime),							//3
		list("key" = /obj/item/clothing/mask/gas/mime),						//4
		list("key" = /obj/item/toy/crayon/mime),							//5
		list("key" = /obj/item/clothing/suit/suspenders),					//6
		list("key" = /obj/item/screwdriver),								//7
		list("key" = /obj/item/circuitboard/mecha/reticence/targeting),		//8
		list("key" = /obj/item/screwdriver),								//9
		list("key" = /obj/item/circuitboard/mecha/reticence/peripherals),	//10
		list("key" = /obj/item/screwdriver),								//11
		list("key" = /obj/item/circuitboard/mecha/reticence/main),			//12
		list("key" = /obj/item/toy/crayon/mime)								//13
	)

/datum/construction/mecha/reticence/custom_action(step, atom/used_atom, mob/user)
	if(!..())
		return FALSE

	if(istype(used_atom, /obj/item/toy/crayon/mime))
		user.visible_message("...")
		return TRUE

	switch(step)
		if(12)
			MECHA_INSTALL_CENTRAL_MODULE
			qdel(used_atom)
		if(11)
			MECHA_SECURE_CENTRAL_MODULE
		if(10)
			MECHA_INSTALL_PERIPHERAL_MODULE
			qdel(used_atom)
		if(9)
			MECHA_SECURE_PERIPHERAL_MODULE
		if(8)
			MECHA_INSTALL_WEAPON_MODULE
			qdel(used_atom)
		if(7)
			MECHA_SECURE_WEAPON_MODULE
		if(6)
			user.visible_message(
				SPAN_NOTICE("[user] puts some suspenders on \the [holder]."),
				SPAN_NOTICE("You put some suspenders on \the [holder].")
			)
			qdel(used_atom)
		if(4)
			user.visible_message(
				SPAN_NOTICE("[user] puts a mime mask on \the [holder]."),
				SPAN_NOTICE("You put a mime mask on \the [holder].")
			)
			qdel(used_atom)
		if(2)
			user.visible_message(
				SPAN_NOTICE("[user] puts a beret on \the [holder]."),
				SPAN_NOTICE("You put a beret on \the [holder].")
			)
			qdel(used_atom)
	return TRUE

/datum/construction/mecha/reticence/spawn_result()
	. = ..()
	feedback_inc("mecha_reticence_created", 1)