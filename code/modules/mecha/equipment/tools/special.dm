// Mime RCD
/obj/item/mecha_equipment/tool/mimercd
	name = "mounted MRCD"
	desc = "An exosuit-mounted mime-rapid-construction-device. (Can be attached to: Reticence)"
	icon_state = "mrcd"
	matter_amounts = /datum/design/mechfab/equipment/working/mrcd::materials
	origin_tech = /datum/design/mechfab/equipment/working/mrcd::req_tech

	mecha_flags = MECHA_FLAG_RETICENCE

	equip_cooldown = 1 SECOND
	energy_drain = 250
	range = MELEE | RANGED

/obj/item/mecha_equipment/tool/mimercd/action(atom/target)
	if(!..())
		return FALSE
	if(istype(target, /turf/space/transit)) //>implying these are ever made -Sieve
		return FALSE
	if(get_dist(chassis, target) > 3)
		return FALSE
	if(!isturf(target))
		target = GET_TURF(target)
	if(!isfloorturf(target))
		return FALSE
	occupant_message("Miming Wall...")
	if(!do_after_cooldown(target))
		return FALSE
	new /obj/effect/forcefield/mime(target)
	chassis.visible_message(
		SPAN_INFO("[chassis] looks as if a wall is in front of it.")
	)
	chassis.spark_system.start()
	return TRUE