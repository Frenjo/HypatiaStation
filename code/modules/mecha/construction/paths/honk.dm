// H.O.N.K Chassis
/datum/construction/mecha_chassis/honk
	steps = list(
		list("key" = /obj/item/mecha_part/part/honk/torso),
		list("key" = /obj/item/mecha_part/part/honk/head),
		list("key" = /obj/item/mecha_part/part/honk/left_arm),
		list("key" = /obj/item/mecha_part/part/honk/right_arm),
		list("key" = /obj/item/mecha_part/part/honk/left_leg),
		list("key" = /obj/item/mecha_part/part/honk/right_leg)
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
		holder.balloon_alert_visible("HONK!")
		return TRUE

	switch(step)
		if(10)
			holder.balloon_alert_visible("installed central control module")
			qdel(used_item)
		if(9)
			holder.balloon_alert_visible("secured central control module")
		if(8)
			holder.balloon_alert_visible("installed peripherals control module")
			qdel(used_item)
		if(7)
			holder.balloon_alert_visible("secured peripherals control module")
		if(6)
			holder.balloon_alert_visible("installed targeting module")
			qdel(used_item)
		if(5)
			holder.balloon_alert_visible("secured targeting module")
		if(4)
			holder.balloon_alert_visible("added clown wig and mask")
			qdel(used_item)
		if(2)
			holder.balloon_alert_visible("added clown shoes")
			qdel(used_item)
	return TRUE

/datum/construction/mecha_honk/spawn_result()
	. = ..()
	feedback_inc("mecha_honk_created", 1)