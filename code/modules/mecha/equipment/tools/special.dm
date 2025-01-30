// Mime RCD
/obj/item/mecha_part/equipment/tool/mimercd
	name = "mounted MRCD"
	desc = "An exosuit-mounted mime-rapid-construction-device. (Can be attached to: Reticence)"
	icon_state = "rcd"
	origin_tech = list(
		/datum/tech/materials = 4, /datum/tech/magnets = 4, /datum/tech/engineering = 4,
		/datum/tech/power_storage = 4, /datum/tech/bluespace = 3
	)
	equip_cooldown = 1 SECOND
	energy_drain = 250
	range = MELEE | RANGED

	construction_time = 1200
	construction_cost = list(
		MATERIAL_METAL = 30000, /decl/material/silver = 20000,
		/decl/material/gold = 20000, /decl/material/plasma = 25000,
		/decl/material/bananium = 10000 // This is a placeholder for tranquilite.
	)

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