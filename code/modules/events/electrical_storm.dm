/datum/event/electrical_storm
	startWhen = 1
	announceWhen = 1
	endWhen = 6
	oneShot = FALSE

	var/lightsoutAmount	= 1
	var/lightsoutRange	= 20

	var/list/epicentreList = list()
	var/list/possibleEpicentres = list()

/datum/event/electrical_storm/setup()
	for(var/obj/effect/landmark/newEpicentre in GLOBL.landmarks_list)
		if(newEpicentre.name == "lightsout" && !(newEpicentre in epicentreList))
			possibleEpicentres += newEpicentre

/datum/event/electrical_storm/announce()
	command_alert("An electrical storm has been detected in your area, please repair potential electronic overloads.", "Electrical Storm Alert")

/datum/event/electrical_storm/start()
	for(var/mob/living/carbon/human/H in GLOBL.living_mob_list)
		if(!H)
			continue

		var/turf/T = get_turf(H)
		if(!T)
			continue
		if(isNotStationLevel(T.z))
			continue
		if(istype(T.loc, /area/maintenance) || istype(T.loc, /area/crew))
			if(H.client)
				H.client.screen.Remove(GLOBL.global_hud.electrical_storm)
			continue

		if(ishuman(H))
			if(H.client)
				H.client.screen |= GLOBL.global_hud.electrical_storm

/datum/event/electrical_storm/tick()
	/*var/list/epicentreList = list()

	//for(var/i=1, i <= lightsoutAmount, i++)
	var/list/possibleEpicentres = list()
	for(var/obj/effect/landmark/newEpicentre in landmarks_list)
		if(newEpicentre.name == "lightsout" && !(newEpicentre in epicentreList))
			possibleEpicentres += newEpicentre
	if(length(possibleEpicentres))
		epicentreList += pick(possibleEpicentres)
	else
		//break
		return

	if(!length(epicentreList))
		return*/

	//for(var/obj/effect/landmark/epicentre in epicentreList)
	if(length(possibleEpicentres))
		var/obj/effect/landmark/epicentre = pick(possibleEpicentres)
		possibleEpicentres -= epicentre
		for(var/obj/machinery/power/apc/apc in range(epicentre, lightsoutRange))
			// Has a 2% chance to flat out detonate APCs instead of just blowing lights. -Frenjo
			if(prob(2))
				// Exploding APCs in AI areas could be REALLY bad, so let's not do that. -Frenjo
				if(!istype(apc.area, /area/turret_protected/ai) && !istype(apc.area, /area/turret_protected/ai_upload) && !istype(apc.area, /area/turret_protected/ai_upload_foyer))
					if(!istype(apc.area, /area/engineering/engine/supermatter) && !istype(apc.area, /area/engineering/engine/singularity) && !istype(apc.area, /area/engineering/engine/thermoelectric))
						var/datum/effect/system/spark_spread/spark = new
						spark.set_up(5, 1, apc)
						spark.start()
						explosion(apc.loc, -1, -1, 2)
						//var/datum/effect/system/smoke_spread/smoke = new
						//smoke.set_up(2, 0, apc.loc, null)
						//smoke.start()
						apc.overload_lighting()
						apc.set_broken()
			else
				apc.overload_lighting()
			sleep(4)

	for(var/mob/living/carbon/human/H in GLOBL.living_mob_list)
		if(!H)
			continue

		var/turf/T = get_turf(H)
		if(!T)
			continue
		if(isNotStationLevel(T.z))
			continue
		if(istype(T.loc, /area/maintenance) || istype(T.loc, /area/crew))
			if(H.client)
				H.client.screen.Remove(GLOBL.global_hud.electrical_storm)
			continue

		if(ishuman(H))
			if(H.client)
				H.client.screen |= GLOBL.global_hud.electrical_storm

/datum/event/electrical_storm/end()
	command_alert("The station has passed the electrical storm.", "Electrical Storm Alert")

	for(var/mob/living/carbon/human/H in GLOBL.living_mob_list)
		if(!H)
			continue

		if(H.client)
			H.client.screen.Remove(GLOBL.global_hud.electrical_storm)