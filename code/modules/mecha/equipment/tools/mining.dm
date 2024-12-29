// Drill
/obj/item/mecha_part/equipment/tool/drill
	name = "drill"
	desc = "This is the drill that'll pierce the heavens! (Can be attached to: Working and Combat Exosuits)"
	icon_state = "mecha_drill"
	equip_cooldown = 30
	energy_drain = 10
	force = 15

/obj/item/mecha_part/equipment/tool/drill/action(atom/target)
	if(!action_checks(target))
		return
	if(isobj(target))
		var/obj/target_obj = target
		if(!target_obj.vars.Find("unacidable") || target_obj.unacidable)
			return
	set_ready_state(0)
	chassis.use_power(energy_drain)
	chassis.visible_message("<font color='red'><b>[chassis] starts to drill [target]</b></font>", "You hear the drill.")
	occupant_message("<font color='red'><b>You start to drill [target]</b></font>")
	var/T = chassis.loc
	var/C = target.loc	//why are these backwards? we may never know -Pete
	if(do_after_cooldown(target))
		if(T == chassis.loc && src == chassis.selected)
			if(istype(target, /turf/closed/wall/reinforced))
				occupant_message("<font color='red'>[target] is too durable to drill through.</font>")
			else if(istype(target, /turf/closed/rock))
				for(var/turf/closed/rock/M in range(chassis, 1))
					if(get_dir(chassis, M) & chassis.dir)
						M.get_drilled()
				log_message("Drilled through [target]")
				if(locate(/obj/item/mecha_part/equipment/tool/hydraulic_clamp) in chassis.equipment)
					var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis:cargo
					if(ore_box)
						for(var/obj/item/ore/ore in range(chassis, 1))
							if(get_dir(chassis,ore)&chassis.dir)
								ore.Move(ore_box)
			else if(istype(target, /turf/open/floor/plating/asteroid/airless))
				for(var/turf/open/floor/plating/asteroid/airless/M in range(chassis, 1))
					if(get_dir(chassis, M) & chassis.dir)
						M.gets_dug()
				log_message("Drilled through [target]")
				if(locate(/obj/item/mecha_part/equipment/tool/hydraulic_clamp) in chassis.equipment)
					var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis:cargo
					if(ore_box)
						for(var/obj/item/ore/ore in range(chassis, 1))
							if(get_dir(chassis, ore) & chassis.dir)
								ore.Move(ore_box)
			else if(target.loc == C)
				log_message("Drilled through [target]")
				target.ex_act(2)
	return 1

// Diamond Drill
/obj/item/mecha_part/equipment/tool/drill/diamond
	name = "diamond drill"
	desc = "This is an upgraded version of the drill that'll pierce the heavens! (Can be attached to: Working and Combat Exosuits)"
	icon_state = "mecha_diamond_drill"
	origin_tech = list(/datum/tech/materials = 4, /datum/tech/engineering = 3)
	construction_cost = list(MATERIAL_METAL = 10000, /decl/material/diamond = 6500)
	equip_cooldown = 20
	force = 15

/obj/item/mecha_part/equipment/tool/drill/diamond/action(atom/target)
	if(!action_checks(target))
		return
	if(isobj(target))
		var/obj/target_obj = target
		if(target_obj.unacidable)
			return
	set_ready_state(0)
	chassis.use_power(energy_drain)
	chassis.visible_message("<font color='red'><b>[chassis] starts to drill [target]</b></font>", "You hear the drill.")
	occupant_message("<font color='red'><b>You start to drill [target]</b></font>")
	var/T = chassis.loc
	var/C = target.loc	//why are these backwards? we may never know -Pete
	if(do_after_cooldown(target))
		if(T == chassis.loc && src == chassis.selected)
			if(istype(target, /turf/closed/wall/reinforced))
				if(do_after_cooldown(target))//To slow down how fast mechs can drill through the station
					log_message("Drilled through [target]")
					target.ex_act(3)
			else if(istype(target, /turf/closed/rock))
				for(var/turf/closed/rock/M in range(chassis, 1))
					if(get_dir(chassis, M) & chassis.dir)
						M.get_drilled()
				log_message("Drilled through [target]")
				if(locate(/obj/item/mecha_part/equipment/tool/hydraulic_clamp) in chassis.equipment)
					var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis:cargo
					if(ore_box)
						for(var/obj/item/ore/ore in range(chassis, 1))
							if(get_dir(chassis, ore) & chassis.dir)
								ore.Move(ore_box)
			else if(istype(target,/turf/open/floor/plating/asteroid/airless))
				for(var/turf/open/floor/plating/asteroid/airless/M in range(target, 1))
					M.gets_dug()
				log_message("Drilled through [target]")
				if(locate(/obj/item/mecha_part/equipment/tool/hydraulic_clamp) in chassis.equipment)
					var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis:cargo
					if(ore_box)
						for(var/obj/item/ore/ore in range(target, 1))
							ore.Move(ore_box)
			else if(target.loc == C)
				log_message("Drilled through [target]")
				target.ex_act(2)
	return 1