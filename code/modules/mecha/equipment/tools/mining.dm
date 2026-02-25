// Drill
/obj/item/mecha_equipment/tool/drill
	name = "mounted drill"
	desc = "This is the drill that'll pierce the heavens!"
	icon_state = "drill"

	matter_amounts = /datum/design/mechfab/equipment/working/drill::materials

	force = 15

	mecha_types = MECHA_TYPE_WORKING | MECHA_TYPE_COMBAT

	equip_cooldown = 3 SECONDS
	energy_drain = 10
	equip_range = MECHA_EQUIP_MELEE

	attaches_to_string = "<em><i>working</i></em> and <em><i>combat</i></em> exosuits"

	var/can_drill_reinforced = FALSE

/obj/item/mecha_equipment/tool/drill/action(atom/target)
	if(!..())
		return FALSE
	if(isobj(target))
		var/obj/target_obj = target
		if(HAS_OBJ_FLAGS(target_obj, OBJ_FLAG_UNACIDABLE))
			return FALSE

	chassis.visible_message("<font color='red'><b>[chassis] starts to drill [target]</b></font>", "You hear the drill.")
	occupant_message("<font color='red'><b>You start to drill [target]</b></font>")
	var/T = chassis.loc
	var/C = target.loc	//why are these backwards? we may never know -Pete
	if(do_after_cooldown(target))
		if(T == chassis.loc && src == chassis.selected)
			if(istype(target, /turf/closed/wall/reinforced))
				if(!can_drill_reinforced)
					occupant_message("<font color='red'>[target] is too durable to drill through.</font>")
				else
					if(do_after_cooldown(target))//To slow down how fast mechs can drill through the station
						log_message("Drilled through [target]")
						target.ex_act(3)
			else if(istype(target, /turf/closed/rock))
				for(var/turf/closed/rock/M in RANGE_TURFS(chassis, 1))
					if(get_dir(chassis, M) & chassis.dir)
						M.get_drilled()
				log_message("Drilled through [target]")
			else if(istype(target, /turf/open/floor/plating/asteroid/airless))
				for(var/turf/open/floor/plating/asteroid/airless/M in RANGE_TURFS(chassis, 1))
					if(get_dir(chassis, M) & chassis.dir)
						M.get_dug()
				log_message("Drilled through [target]")
			else if(target.loc == C)
				log_message("Drilled through [target]")
				target.ex_act(2)
	return TRUE

// Diamond Drill
/obj/item/mecha_equipment/tool/drill/diamond
	name = "mounted diamond drill"
	desc = "This is an upgraded version of the drill that'll pierce the heavens!"
	icon_state = "diamond_drill"
	matter_amounts = /datum/design/mechfab/equipment/working/diamond_drill::materials
	origin_tech = /datum/design/mechfab/equipment/working/diamond_drill::req_tech
	equip_cooldown = 2 SECONDS
	force = 15

	can_drill_reinforced = TRUE