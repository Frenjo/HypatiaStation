/datum/round_event/storm/electrical
	start_when = 1
	end_when = 1

	var/lightsoutAmount = 1
	var/lightsoutRange = 25

	var/list/epicentres = list()
	var/list/possible_epicentres = list()

/datum/round_event/storm/electrical/setup()
	for_no_type_check(var/obj/effect/landmark/new_epicentre, GLOBL.landmark_list)
		if(new_epicentre.name == "lightsout" && !(new_epicentre in epicentres))
			possible_epicentres.Add(new_epicentre)

/datum/round_event/storm/electrical/announce()
	priority_announce("An electrical storm has been detected in your area, please repair potential electronic overloads.", "Electrical Storm Alert")

/datum/round_event/storm/electrical/start()
	if(!length(epicentres))
		return

	for_no_type_check(var/obj/effect/landmark/epicentre, epicentres)
		for(var/obj/machinery/power/apc/apc in range(epicentre, lightsoutRange))
			apc.overload_lighting()

// Large/severe variant
/datum/round_event/storm/electrical/large
	end_when = 6

	lightsoutRange = 20

/datum/round_event/storm/electrical/large/announce()
	priority_announce("A severe electrical storm has been detected in your area, please repair potential electronic overloads.", "Electrical Storm Alert")

/datum/round_event/storm/electrical/large/start()
	for(var/mob/living/carbon/human/H in GLOBL.living_mob_list)
		var/turf/T = GET_TURF(H)
		if(isnull(T))
			continue
		if(isnotstationlevel(T.z))
			continue
		var/area/A = GET_AREA(T)
		if(HAS_AREA_FLAGS(A, AREA_FLAG_IS_SHIELDED))
			H.client?.screen.Remove(GLOBL.global_hud.electrical_storm)
			continue

		if(ishuman(H))
			H.client?.screen |= GLOBL.global_hud.electrical_storm

/datum/round_event/storm/electrical/large/tick()
	if(length(possible_epicentres))
		var/obj/effect/landmark/epicentre = pick(possible_epicentres)
		possible_epicentres.Remove(epicentre)
		for(var/obj/machinery/power/apc/apc in range(epicentre, lightsoutRange))
			// If the area's shielded, then skip it.
			if(HAS_AREA_FLAGS(apc.area, AREA_FLAG_IS_SHIELDED))
				continue
			// Has a 2% chance to flat out detonate APCs instead of just blowing lights. -Frenjo
			// This won't blow certain APCs (IE AI and engine areas) because that would be very bad.
			if(prob(2) && !HAS_AREA_FLAGS(apc.area, AREA_FLAG_IS_SURGE_PROTECTED))
				make_sparks(5, TRUE, apc)
				explosion(apc.loc, -1, -1, 2)
				//make_smoke(2, FALSE, apc.loc)
				apc.overload_lighting()
				apc.set_broken()
			else
				apc.overload_lighting()
			sleep(4)

	for(var/mob/living/carbon/human/H in GLOBL.living_mob_list)
		var/turf/T = GET_TURF(H)
		if(isnull(T))
			continue
		if(isnotstationlevel(T.z))
			continue
		var/area/A = GET_AREA(T)
		if(HAS_AREA_FLAGS(A, AREA_FLAG_IS_SHIELDED))
			H.client?.screen.Remove(GLOBL.global_hud.electrical_storm)
			continue

		if(ishuman(H))
			H.client?.screen |= GLOBL.global_hud.electrical_storm

/datum/round_event/storm/electrical/large/end()
	priority_announce("The station has passed the electrical storm.", "Electrical Storm Alert")

	for(var/mob/living/carbon/human/H in GLOBL.living_mob_list)
		H.client?.screen.Remove(GLOBL.global_hud.electrical_storm)