/obj/mecha/working/ripley
	name = "\improper APLU \"Ripley\""
	desc = "Autonomous Power Loader Unit. The workhorse of the exosuit world."
	icon_state = "ripley"
	initial_icon = "ripley"

	step_in = 6
	max_temperature = 20000
	health = 200
	wreckage = /obj/effect/decal/mecha_wreckage/ripley
	cargo_capacity = 15

/obj/mecha/working/ripley/Destroy()
	for(var/mob/M in src)
		if(M == occupant)
			continue
		M.loc = GET_TURF(src)
		M.loc.Entered(M)
		step_rand(M)
	for(var/atom/movable/A in cargo)
		A.loc = GET_TURF(src)
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
			O.loc = GET_TURF(src)
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

	max_temperature = 65000
	health = 250
	damage_absorption = list("fire" = 0.5, "bullet" = 0.8, "bomb" = 0.5)
	wreckage = /obj/effect/decal/mecha_wreckage/ripley/firefighter

/obj/mecha/working/ripley/deathripley
	name = "\improper DEATH-RIPLEY"
	desc = "OH SHIT IT'S THE DEATHSQUAD WE'RE ALL GONNA DIE"
	icon_state = "deathripley"
	initial_icon = "deathripley"

	step_in = 2
	wreckage = /obj/effect/decal/mecha_wreckage/ripley/deathripley
	step_energy_drain = 0

/obj/mecha/working/ripley/deathripley/New()
	. = ..()
	var/obj/item/mecha_part/equipment/ME = new /obj/item/mecha_part/equipment/tool/safety_clamp(src)
	ME.attach(src)

/obj/mecha/working/ripley/mining
	name = "\improper APLU \"Miner\""
	desc = "An old, dusty mining ripley."

/obj/mecha/working/ripley/mining/New()
	. = ..()
	//Attach drill
	if(prob(25)) //Possible diamond drill... Feeling lucky?
		var/obj/item/mecha_part/equipment/tool/drill/diamond/D = new /obj/item/mecha_part/equipment/tool/drill/diamond(src)
		D.attach(src)
	else
		var/obj/item/mecha_part/equipment/tool/drill/D = new /obj/item/mecha_part/equipment/tool/drill(src)
		D.attach(src)

	//Attach hydrolic clamp
	var/obj/item/mecha_part/equipment/tool/hydraulic_clamp/HC = new /obj/item/mecha_part/equipment/tool/hydraulic_clamp(src)
	HC.attach(src)
	for(var/obj/item/mecha_part/tracking/B in contents)//Deletes the beacon so it can't be found easily
		qdel(B)