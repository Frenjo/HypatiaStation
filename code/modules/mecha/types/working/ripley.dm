/obj/mecha/working/ripley
	name = "\improper APLU \"Ripley\""
	desc = "Autonomous Power Loader Unit. The workhorse of the exosuit world."
	icon_state = "ripley"
	initial_icon = "ripley"

	health = 200
	step_in = 6
	max_temperature = 20000

	mecha_flag = MECHA_FLAG_RIPLEY

	wreckage = /obj/structure/mecha_wreckage/ripley

	cargo_capacity = 15

	var/goliath_overlay = "ripley"

	var/static/hide_absorption_bonus = 0.1
	var/static/max_goliath_hides = 3
	var/static/initial_damage_absorption = 0.8

/obj/mecha/working/ripley/Destroy()
	var/turf/source_turf = GET_TURF(src)
	for(var/mob/M in src)
		if(M == occupant)
			continue
		M.forceMove(source_turf)
		M.loc.Entered(M)
		step_rand(M)
	while(damage_absorption["brute"] < initial_damage_absorption)
		new /obj/item/stack/goliath_hide(source_turf)
		damage_absorption["brute"] += hide_absorption_bonus
	for_no_type_check(var/atom/movable/A, cargo)
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

/obj/mecha/working/ripley/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/goliath_hide))
		if(isnotnull(occupant))
			to_chat(user, SPAN_WARNING("You can't add armour onto \the [src] while someone is inside!"))
			return TRUE
		var/max_damage_absorption = initial_damage_absorption - (hide_absorption_bonus * max_goliath_hides)
		if(damage_absorption["brute"] > max_damage_absorption)
			var/obj/item/stack/goliath_hide/hide = I
			if(!hide.use(1))
				return TRUE

			damage_absorption["brute"] -= hide_absorption_bonus
			to_chat(user, SPAN_INFO("You strengthen the armour on \the [src], improving its resistance against melee attacks."))

			if(damage_absorption["brute"] <= max_damage_absorption)
				desc = initial(desc) + " It is wearing a fearsome carapace entirely composed of goliath hide plates - the pilot must be an experienced monster hunter."
			else
				desc = initial(desc) + " Its armour is enhanced with some goliath hide plates."
			update_overlays(FALSE)
		else
			to_chat(user, SPAN_WARNING("You can't improve the armour on \the [src] any further."))
		return TRUE
	return ..()

/obj/mecha/working/ripley/moved_inside(mob/living/carbon/human/H)
	. = ..()
	if(!.)
		return FALSE
	update_overlays(TRUE)

/obj/mecha/working/ripley/mmi_moved_inside(obj/item/mmi/mmi_as_oc, mob/user)
	. = ..()
	if(!.)
		return FALSE
	update_overlays(TRUE)

/obj/mecha/working/ripley/go_out()
	. = ..()
	if(!.)
		return FALSE
	update_overlays(FALSE)

/obj/mecha/working/ripley/proc/update_overlays(has_occupant)
	overlays.Cut()
	var/max_damage_absorption = initial_damage_absorption - (hide_absorption_bonus * max_goliath_hides)
	var/image/new_overlay = null
	if(has_occupant)
		if(damage_absorption["brute"] < initial_damage_absorption && damage_absorption["brute"] > max_damage_absorption)
			new_overlay = image('icons/obj/mecha/mecha_overlays.dmi', "[goliath_overlay]-g")
		else if(damage_absorption["brute"] <= max_damage_absorption)
			new_overlay = image('icons/obj/mecha/mecha_overlays.dmi', "[goliath_overlay]-g-full")
	else
		if(damage_absorption["brute"] < initial_damage_absorption && damage_absorption["brute"] > max_damage_absorption)
			new_overlay = image('icons/obj/mecha/mecha_overlays.dmi', "[goliath_overlay]-g-open")
		else if(damage_absorption["brute"] <= max_damage_absorption)
			new_overlay = image('icons/obj/mecha/mecha_overlays.dmi', "[goliath_overlay]-g-full-open")

	if(isnull(new_overlay))
		return

	new_overlay.plane = plane
	overlays.Add(new_overlay)

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

	mecha_flag = MECHA_FLAG_DEATH_RIPLEY
	starts_with = list(
		/obj/item/mecha_equipment/tool/hydraulic_clamp/safety
	)

	wreckage = /obj/structure/mecha_wreckage/ripley/deathripley

/obj/mecha/working/ripley/mining
	name = "\improper APLU \"Miner\""
	desc = "An old, dusty mining ripley."

	starts_with = list(/obj/item/mecha_equipment/tool/hydraulic_clamp)

/obj/mecha/working/ripley/mining/New()
	// Chance for different drill types.
	if(prob(25)) // Possible diamond drill... Feeling lucky?
		starts_with.Add(/obj/item/mecha_equipment/tool/drill/diamond)
	else
		starts_with.Add(/obj/item/mecha_equipment/tool/drill)

	. = ..()
	for(var/obj/item/mecha_part/tracking/B in contents) // Deletes the beacon so it can't be found easily.
		qdel(B)

/obj/mecha/working/ripley/rescue_ranger
	name = "\improper APLU \"Rescue Ranger\""
	desc = "A standard APLU chassis fitted with mounting hardpoints for basic medical equipment. It is painted in the Vey-Med(&copy; all rights reserved) livery."
	icon_state = "rescue_ranger"
	initial_icon = "rescue_ranger"

	health = 175
	step_in = 5

	mecha_flag = MECHA_FLAG_RESCUE_RANGER

	wreckage = /obj/structure/mecha_wreckage/ripley/rescue_ranger

	cargo_capacity = 10

	goliath_overlay = "rescue_ranger"

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

	mecha_flag = MECHA_FLAG_SINDY

	wreckage = /obj/structure/mecha_wreckage/ripley/sindy

	cargo_capacity = 10

	goliath_overlay = "sindy"

/obj/mecha/working/ripley/sindy/add_cell(obj/item/cell/C = null)
	if(isnotnull(C))
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/cell/hyper(src)

// Equipped variant
/obj/mecha/working/ripley/sindy/equipped
	starts_with = list(
		/obj/item/mecha_equipment/weapon/energy/laser/heavy, /obj/item/mecha_equipment/tool/hydraulic_clamp,
		/obj/item/mecha_equipment/melee_armour_booster
	)