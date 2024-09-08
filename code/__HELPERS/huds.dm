/* Using the HUD procs is simple. Call these procs in the life.dm of the intended mob.
Use the regular_hud_updates() proc before process_med_hud(mob) or process_sec_hud(mob) so
the HUD updates properly! */

//Medical HUD outputs. Called by the Life() proc of the mob using it, usually.
/proc/process_med_hud(mob/M, local_scanner, mob/Alt)
	if(!can_process_hud(M))
		return

	var/datum/arranged_hud_process/P = arrange_hud_process(M, Alt, GLOBL.med_hud_users)
	for(var/mob/living/carbon/human/patient in P.mob.in_view(P.turf))
		if(P.mob.see_invisible < patient.invisibility)
			continue

		if(!local_scanner)
			if(istype(patient.wear_uniform, /obj/item/clothing/under))
				var/obj/item/clothing/under/U = patient.wear_uniform
				if(U.sensor_mode < 2)
					continue
			else
				continue

		P.client.images.Add(patient.hud_list[HEALTH_HUD])
		if(local_scanner)
			P.client.images.Add(patient.hud_list[STATUS_HUD])

//Security HUDs. Pass a value for the second argument to enable implant viewing or other special features.
/proc/process_sec_hud(mob/M, advanced_mode, mob/Alt)
	if(!can_process_hud(M))
		return
	var/datum/arranged_hud_process/P = arrange_hud_process(M, Alt, GLOBL.sec_hud_users)
	for(var/mob/living/carbon/human/perp in P.mob.in_view(P.turf))
		if(P.mob.see_invisible < perp.invisibility)
			continue

		P.client.images.Add(perp.hud_list[ID_HUD])
		if(advanced_mode)
			P.client.images.Add(perp.hud_list[WANTED_HUD])
			P.client.images.Add(perp.hud_list[IMPTRACK_HUD])
			P.client.images.Add(perp.hud_list[IMPLOYAL_HUD])
			P.client.images.Add(perp.hud_list[IMPCHEM_HUD])

/datum/arranged_hud_process
	var/client/client
	var/mob/mob
	var/turf/turf

/proc/arrange_hud_process(mob/M, mob/Alt, list/hud_list)
	RETURN_TYPE(/datum/arranged_hud_process)

	hud_list |= M
	var/datum/arranged_hud_process/P = new /datum/arranged_hud_process()
	P.client = M.client
	P.mob = Alt ? Alt : M
	P.turf = GET_TURF(P.mob)
	return P

/proc/can_process_hud(mob/M)
	if(isnull(M))
		return FALSE
	if(isnull(M.client))
		return FALSE
	if(M.stat != CONSCIOUS)
		return FALSE
	return TRUE

//Deletes the current HUD images so they can be refreshed with new ones.
/mob/proc/regular_hud_updates() //Used in the life.dm of mobs that can use HUDs.
	if(isnotnull(client))
		for_no_type_check(var/image/hud, client.images)
			if(copytext(hud.icon_state, 1, 4) == "hud")
				client.images.Remove(hud)
	GLOBL.med_hud_users.Remove(src)
	GLOBL.sec_hud_users.Remove(src)

/mob/proc/in_view(turf/T)
	RETURN_TYPE(/list)

	return view(T)

/mob/ai_eye/in_view(turf/T)
	RETURN_TYPE(/list)

	var/list/viewed = list()
	for(var/mob/living/carbon/human/H in GLOBL.mob_list)
		if(get_dist(H, T) <= 7)
			viewed.Add(H)
	return viewed