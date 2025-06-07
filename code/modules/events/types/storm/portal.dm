/datum/round_event/storm/portal
	start_when = 7
	end_when = 999

	// Associative list of mob typepaths and their weights.
	var/alist/hostile_types = alist()
	var/max_hostiles = 50
	var/total_hostiles = 0

/datum/round_event/storm/portal/announce()
	priority_announce("Subspace disruption detected around the station.", "Anomaly Alert")

/datum/round_event/storm/portal/tick()
	if(IsMultiple(active_for, 2))
		var/hostile_type = pickweight(hostile_types) // Picks a mob type by weight.
		var/turf/open/floor/safe_turf = find_safe_turf(1) // Finds a safe turf on the main station level.
		// Creates the new hostile mob and teleports it in.
		var/mob/new_hostile = new hostile_type(safe_turf)
		make_sparks(4, FALSE, safe_turf)
		playsound(new_hostile, 'sound/effects/sparks4.ogg', 50, TRUE)
		do_teleport(new_hostile, safe_turf)

		// Increments the total hostiles list and checks for event completion.
		if(total_hostiles++ == max_hostiles)
			end_when = active_for

// Syndicate variant
/datum/round_event/storm/portal/syndicate
	hostile_types = alist(
		/mob/living/simple/hostile/syndicate/melee/space = 8,
		/mob/living/simple/hostile/syndicate/ranged/space = 2
	)

// Nar'sie variant
/datum/round_event/storm/portal/narsie
	hostile_types = alist(
		/mob/living/simple/construct/behemoth = 8,
		/mob/living/simple/construct/wraith = 6
	)