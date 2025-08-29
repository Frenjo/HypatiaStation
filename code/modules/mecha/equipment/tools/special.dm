// Mime RCD
/obj/item/mecha_equipment/tool/mimercd
	name = "mounted MRCD"
	desc = "An exosuit-mounted mime-rapid-construction-device."
	icon_state = "mrcd"
	matter_amounts = /datum/design/mechfab/equipment/working/mrcd::materials
	origin_tech = /datum/design/mechfab/equipment/working/mrcd::req_tech

	mecha_types = MECHA_TYPE_RETICENCE

	equip_cooldown = 1 SECOND
	energy_drain = 250
	equip_range = MECHA_EQUIP_MELEE | MECHA_EQUIP_RANGED

	attaches_to_string = "the <em><i>Reticence</i></em> exosuit"

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