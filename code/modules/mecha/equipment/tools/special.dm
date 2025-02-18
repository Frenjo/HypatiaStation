// Mime RCD
/obj/item/mecha_part/equipment/tool/mimercd
	name = "mounted MRCD"
	desc = "An exosuit-mounted mime-rapid-construction-device. (Can be attached to: Reticence)"
	icon_state = "rcd"
	matter_amounts = /datum/design/mechfab/equipment/working/mrcd::materials
	origin_tech = /datum/design/mechfab/equipment/working/mrcd::req_tech
	equip_cooldown = 1 SECOND
	energy_drain = 250
	range = MELEE | RANGED

/obj/item/mecha_part/equipment/tool/mimercd/can_attach(obj/mecha/combat/reticence/M)
	if(!istype(M))
		return FALSE
	return ..()

/obj/item/mecha_part/equipment/tool/mimercd/action(atom/target)
	if(istype(target, /turf/space/transit)) //>implying these are ever made -Sieve
		return
	if(!action_checks(target) || get_dist(chassis, target) > 3)
		return
	if(!isturf(target))
		target = GET_TURF(target)

	if(isfloorturf(target))
		occupant_message("Miming Wall...")
		if(do_after_cooldown(target))
			new /obj/effect/forcefield/mime(target)
			chassis.visible_message(
				SPAN_INFO("[chassis] looks as if a wall is in front of it.")
			)
			chassis.spark_system.start()