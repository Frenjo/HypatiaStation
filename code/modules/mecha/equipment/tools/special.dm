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

// Clarke Ore Compartment
/obj/item/mecha_equipment/tool/ore_compartment
	name = "ore compartment"
	desc = "An automated ore compartment. It's basically a fancy exosuit-mounted ore box."
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel_bspace"

	mecha_types = MECHA_TYPE_CLARKE

	equip_range = MECHA_EQUIP_MELEE
	selectable = FALSE

	allow_duplicates = FALSE
	allow_detach = FALSE

	attaches_to_string = "the <em><i>Clarke</i></em>"

	var/obj/structure/ore_box/ore_box = null

/obj/item/mecha_equipment/tool/ore_compartment/initialise()
	. = ..()
	ore_box = new /obj/structure/ore_box(src)

/obj/item/mecha_equipment/tool/ore_compartment/handle_movement_action()
	for(var/obj/item/ore/ore in range(chassis, 1))
		if((get_dir(chassis, ore) & chassis.dir) || ore.loc == chassis.loc) // If it's in range and in front of us, collect it.
			ore.forceMove(ore_box)
	return TRUE

/obj/item/mecha_equipment/tool/ore_compartment/get_equip_info()
	. = "[..()] - <a href='byond://?src=\ref[src];dump_ore=1'>Dump All Ore</a>"

/obj/item/mecha_equipment/tool/ore_compartment/handle_topic(mob/user, datum/topic_input/topic)
	. = ..()
	if(!.)
		return FALSE

	if(topic.has("dump_ore"))
		if(length(ore_box.contents))
			for_no_type_check(var/obj/item/ore/O, ore_box)
				contents.Remove(O)
				O.forceMove(chassis.loc)
			occupant_message(SPAN_INFO("Ejected all stored ore."))
			log_message("Ejected stored ore.")
		else
			occupant_message(SPAN_WARNING("No stored ore to eject."))
			log_message("Attempted storage ejection with no ore stored.")