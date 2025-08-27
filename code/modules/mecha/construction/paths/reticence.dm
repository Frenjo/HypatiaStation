// Chassis
/datum/component/construction/mecha_chassis/reticence
	steps = list(
		list("key" = /obj/item/mecha_part/part/reticence/torso),
		list("key" = /obj/item/mecha_part/part/reticence/head),
		list("key" = /obj/item/mecha_part/part/reticence/left_arm),
		list("key" = /obj/item/mecha_part/part/reticence/right_arm),
		list("key" = /obj/item/mecha_part/part/reticence/left_leg),
		list("key" = /obj/item/mecha_part/part/reticence/right_leg)
	)

/datum/component/construction/mecha_chassis/reticence/spawn_result()
	var/obj/item/mecha_part/chassis/const_holder = parent_datum
	const_holder.RemoveComponent(src)
	const_holder.AddComponent(/datum/component/construction/mecha_reticence)
	const_holder.density = TRUE

// Reticence
/datum/component/construction/mecha_reticence
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

/datum/component/construction/mecha_reticence/custom_action(step, obj/item/used_item, mob/living/user)
	if(!..())
		return FALSE

	var/atom/holder = parent_datum

	if(istype(used_item, /obj/item/toy/crayon/mime))
		holder.balloon_alert_visible("...")
		return TRUE

	switch(step)
		if(12)
			holder.balloon_alert_visible("installed central control module")
			qdel(used_item)
		if(11)
			holder.balloon_alert_visible("secured central control module")
		if(10)
			holder.balloon_alert_visible("installed peripherals control module")
			qdel(used_item)
		if(9)
			holder.balloon_alert_visible("secured peripherals control module")
		if(8)
			holder.balloon_alert_visible("installed targeting module")
			qdel(used_item)
		if(7)
			holder.balloon_alert_visible("secured targeting module")
		if(6)
			holder.balloon_alert_visible("added suspenders")
			qdel(used_item)
		if(4)
			holder.balloon_alert_visible("added mime mask")
			qdel(used_item)
		if(2)
			holder.balloon_alert_visible("added beret")
			qdel(used_item)
	return TRUE

/datum/component/construction/mecha_reticence/spawn_result()
	. = ..()
	feedback_inc("mecha_reticence_created", 1)