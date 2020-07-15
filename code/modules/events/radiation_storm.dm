/datum/event/radiation_storm


/datum/event/radiation_storm/setup()
	startWhen 		= 25
	announceWhen	= 1
	endWhen 		= 50
	oneShot			= 0

/datum/event/radiation_storm/announce()
	world << sound('sound/AI/radiation.ogg')
	command_alert("High levels of radiation detected near the station. Please evacuate into one of the shielded maintenance tunnels.", "Anomaly Alert")
	make_maint_all_access()

/datum/event/radiation_storm/start()
	command_alert("The station has entered the radiation belt. Please remain in a sheltered area until we have passed the radiation belt.", "Anomaly Alert")

/datum/event/radiation_storm/tick()
	for(var/mob/living/carbon/human/H in living_mob_list)
		var/turf/T = get_turf(H)
		if(!T)
			continue
		if(T.z != 1)
			continue
		if(istype(T.loc, /area/maintenance) || istype(T.loc, /area/crew_quarters))
			H.client.screen.Remove(global_hud.radstorm)
			continue

		if(istype(H,/mob/living/carbon/human))
			H.client.screen.Remove(global_hud.radstorm)
			H.client.screen += global_hud.radstorm
			H.apply_effect((rand(15,35)),IRRADIATE,0)
			if(prob(5))
				H.apply_effect((rand(40,70)),IRRADIATE,0)
				if (prob(75))
					randmutb(H) // Applies bad mutation
					domutcheck(H,null,MUTCHK_FORCED)
				else
					randmutg(H) // Applies good mutation
					domutcheck(H,null,MUTCHK_FORCED)

	for(var/mob/living/carbon/monkey/M in living_mob_list)
		var/turf/T = get_turf(M)
		if(!T)
			continue
		if(T.z != 1)
			continue
		M.apply_effect((rand(5,25)),IRRADIATE,0)

	//sleep(10)

/datum/event/radiation_storm/end()
	command_alert("The station has passed the radiation belt. Please report to medbay if you experience any unusual symptoms. Maintenance will lose all access again shortly.", "Anomaly Alert")

	for(var/mob/living/carbon/human/H in living_mob_list)
		H.client.screen.Remove(global_hud.radstorm)

	spawn(150)
	revoke_maint_all_access()