/datum/round_event/storm/radiation
	startWhen = 15
	endWhen = 35

/datum/round_event/storm/radiation/announce()
	world << sound('sound/AI/radiation.ogg')
	command_alert("High levels of radiation detected near the station. Please evacuate into one of the shielded maintenance tunnels.", "Anomaly Alert")
	make_maint_all_access()

/datum/round_event/storm/radiation/start()
	command_alert("The station has entered the radiation belt. Please remain in a sheltered area until we have passed the radiation belt.", "Anomaly Alert")

/datum/round_event/storm/radiation/tick()
	for(var/mob/living/carbon/human/H in GLOBL.living_mob_list)
		var/turf/T = GET_TURF(H)
		if(isnull(T))
			continue
		if(isnotstationlevel(T.z))
			continue
		var/area/A = GET_AREA(T)
		if(HAS_AREA_FLAGS(A, AREA_FLAG_IS_SHIELDED))
			H.client?.screen.Remove(GLOBL.global_hud.rad_storm)
			continue

		if(ishuman(H))
			H.client?.screen |= GLOBL.global_hud.rad_storm
			H.apply_effect(rand(15, 35), IRRADIATE, 0)
			if(prob(5))
				H.apply_effect(rand(40, 70), IRRADIATE, 0)
				if(prob(75))
					randmutb(H) // Applies bad mutation
					domutcheck(H, null, MUTCHK_FORCED)
				else
					randmutg(H) // Applies good mutation
					domutcheck(H, null, MUTCHK_FORCED)

	for(var/mob/living/carbon/monkey/M in GLOBL.living_mob_list)
		var/turf/T = GET_TURF(M)
		if(isnull(T))
			continue
		if(isnotstationlevel(T.z))
			continue
		M.apply_effect((rand(5, 25)), IRRADIATE, 0)

	//sleep(10)

/datum/round_event/storm/radiation/end()
	command_alert("The station has passed the radiation belt. Please report to medbay if you experience any unusual symptoms. Maintenance will lose all access again shortly.", "Anomaly Alert")

	for(var/mob/living/carbon/human/H in GLOBL.living_mob_list)
		H.client?.screen.Remove(GLOBL.global_hud.rad_storm)

	spawn(150)
	revoke_maint_all_access()