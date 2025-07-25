/obj/item/ano_scanner
	name = "\improper Alden-Saraspova counter"
	desc = "Aids in triangulation of exotic particles."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "flashgun"
	item_state = "lampgreen"
	w_class = 1.0
	slot_flags = SLOT_BELT

	var/nearest_artifact_id = "unknown"
	var/nearest_artifact_distance = -1
	var/last_scan_time = 0
	var/scan_delay = 25

/obj/item/ano_scanner/initialise()
	. = ..()
	scan()

/obj/item/ano_scanner/attack_self(mob/user)
	return src.interact(user)

/obj/item/ano_scanner/interact(mob/user)
	var/message = "Background radiation levels detected."
	if(nearest_artifact_distance >= 0)
		message = "Exotic energy detected on wavelength '[nearest_artifact_id]' in a radius of [nearest_artifact_distance]m"
	to_chat(user, SPAN_INFO("[message]"))
	if(world.time - last_scan_time >= scan_delay)
		scan()

/obj/item/ano_scanner/proc/scan()
	set background = BACKGROUND_ENABLED
	set waitfor = FALSE

	last_scan_time = world.time
	nearest_artifact_distance = -1
	var/turf/cur_turf = GET_TURF(src)
	for_no_type_check(var/turf/closed/rock/T, GLOBL.artifact_spawning_turfs)
		if(T.artifact_find)
			if(T.z == cur_turf.z)
				var/cur_dist = get_dist(cur_turf, T) * 2
				if((nearest_artifact_distance < 0 || cur_dist < nearest_artifact_distance) && cur_dist <= T.artifact_find.artifact_detect_range)
					nearest_artifact_distance = cur_dist + rand() * 2 - 1
					nearest_artifact_id = T.artifact_find.artifact_id
		else
			GLOBL.artifact_spawning_turfs.Remove(T)
	cur_turf.visible_message(SPAN_INFO("[src] clicks."))