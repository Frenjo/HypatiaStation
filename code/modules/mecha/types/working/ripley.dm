/obj/mecha/working/ripley
	name = "\improper APLU \"Ripley\""
	desc = "Autonomous Power Loader Unit. The workhorse of the exosuit world."
	icon_state = "ripley"
	initial_icon = "ripley"

	health = 200
	step_in = 6
	max_temperature = 20000

	wreckage = /obj/structure/mecha_wreckage/ripley

	mecha_flag = MECHA_FLAG_RIPLEY

	cargo_capacity = 15

/obj/mecha/working/ripley/Destroy()
	var/turf/source_turf = GET_TURF(src)
	for(var/mob/M in src)
		if(M == occupant)
			continue
		M.forceMove(source_turf)
		M.loc.Entered(M)
		step_rand(M)
	for(var/atom/movable/A in cargo)
		A.forceMove(source_turf)
		var/turf/T = GET_TURF(A)
		T?.Entered(A)
		step_rand(A)
	return ..()

/obj/mecha/working/ripley/Exit(atom/movable/O)
	if(isnotnull(O) && (O in cargo))
		return 0
	return ..()

/obj/mecha/working/ripley/Topic(href, href_list)
	. = ..()
	if(href_list["drop_from_cargo"])
		var/obj/O = locate(href_list["drop_from_cargo"])
		if(isnotnull(O) && (O in cargo))
			occupant_message(SPAN_INFO("You unload [O]."))
			O.forceMove(GET_TURF(src))
			cargo.Remove(O)
			var/turf/T = GET_TURF(O)
			T?.Entered(O)
			log_message("Unloaded [O]. Cargo compartment capacity: [cargo_capacity - length(cargo)]")

/obj/mecha/working/ripley/get_stats_part()
	. = ..()
	. += "<b>Cargo Compartment Contents:</b><div style=\"margin-left: 15px;\">"
	if(length(cargo))
		for(var/obj/O in cargo)
			. += "<a href='byond://?src=\ref[src];drop_from_cargo=\ref[O]'>Unload</a> : [O]<br>"
	else
		. += "Nothing"
	. += "</div>"

/obj/mecha/working/ripley/firefighter
	name = "\improper APLU \"Firefighter\""
	desc = "Standard APLU chassis refitted with additional thermal protection and cistern."
	icon_state = "firefighter"
	initial_icon = "firefighter"

	health = 250
	max_temperature = 65000
	damage_absorption = list("fire" = 0.5, "bullet" = 0.8, "bomb" = 0.5)

	wreckage = /obj/structure/mecha_wreckage/ripley/firefighter

/obj/mecha/working/ripley/death
	name = "\improper DEATH-RIPLEY"
	desc = "OH SHIT IT'S THE DEATHSQUAD WE'RE ALL GONNA DIE"
	icon_state = "deathripley"
	initial_icon = "deathripley"

	step_in = 2
	step_energy_drain = 0

	wreckage = /obj/structure/mecha_wreckage/ripley/deathripley

	mecha_flag = MECHA_FLAG_DEATH_RIPLEY

/obj/mecha/working/ripley/death/New()
	. = ..()
	var/obj/item/mecha_equipment/ME = new /obj/item/mecha_equipment/tool/hydraulic_clamp/safety(src)
	ME.attach(src)

/obj/mecha/working/ripley/mining
	name = "\improper APLU \"Miner\""
	desc = "An old, dusty mining ripley."

/obj/mecha/working/ripley/mining/New()
	. = ..()
	//Attach drill
	if(prob(25)) //Possible diamond drill... Feeling lucky?
		var/obj/item/mecha_equipment/tool/drill/diamond/D = new /obj/item/mecha_equipment/tool/drill/diamond(src)
		D.attach(src)
	else
		var/obj/item/mecha_equipment/tool/drill/D = new /obj/item/mecha_equipment/tool/drill(src)
		D.attach(src)

	//Attach hydrolic clamp
	var/obj/item/mecha_equipment/tool/hydraulic_clamp/HC = new /obj/item/mecha_equipment/tool/hydraulic_clamp(src)
	HC.attach(src)
	for(var/obj/item/mecha_part/tracking/B in contents)//Deletes the beacon so it can't be found easily
		qdel(B)

/obj/mecha/working/ripley/rescue_ranger
	name = "\improper APLU \"Rescue Ranger\""
	desc = "A standard APLU chassis fitted with mounting hardpoints for basic medical equipment. It is painted in the Vey-Med(&copy; all rights reserved) livery."
	icon_state = "rescue_ranger"
	initial_icon = "rescue_ranger"

	health = 175
	step_in = 5

	wreckage = /obj/structure/mecha_wreckage/ripley/rescue_ranger

	mecha_flag = MECHA_FLAG_RESCUE_RANGER

	cargo_capacity = 10

// Sindy
/obj/mecha/working/ripley/sindy
	name = "\improper APLU \"Sindy\""
	desc = "A sinister variant of the standard APLU chassis fitted with rudimentary targeting systems and mounting hardpoints for basic weaponry."
	icon_state = "sindy"
	initial_icon = "sindy"

	health = 225
	step_in = 5
	max_temperature = 42500
	damage_absorption = list("brute" = 0.8, "fire" = 0.85, "bullet" = 0.85, "laser" = 1, "energy" = 1, "bomb" = 0.75)

	operation_req_access = list(ACCESS_SYNDICATE)
	add_req_access = FALSE

	wreckage = /obj/structure/mecha_wreckage/ripley/sindy

	mecha_flag = MECHA_FLAG_SINDY

	cargo_capacity = 10

/obj/mecha/working/ripley/sindy/add_cell(obj/item/cell/C = null)
	if(isnotnull(C))
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/cell/hyper(src)

// Equipped variant
/obj/mecha/working/ripley/sindy/equipped/New()
	. = ..()
	var/obj/item/mecha_equipment/equip = new /obj/item/mecha_equipment/weapon/energy/laser/heavy(src)
	equip.attach(src)
	equip = new /obj/item/mecha_equipment/tool/hydraulic_clamp(src)
	equip.attach(src)
	equip = new /obj/item/mecha_equipment/melee_armour_booster(src)
	equip.attach(src)