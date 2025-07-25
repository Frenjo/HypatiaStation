/obj/effect/proc_holder/spell/targeted/turf_teleport
	name = "Turf Teleport"
	desc = "This spell teleports the target to the turf in range."

	var/inner_tele_radius = 1
	var/outer_tele_radius = 2

	var/include_space = 0 //whether it includes space tiles in possible teleport locations
	var/include_dense = 0 //whether it includes dense tiles in possible teleport locations

/obj/effect/proc_holder/spell/targeted/turf_teleport/cast(list/targets)
	for(var/mob/living/target in targets)
		var/list/turfs = list()
		for_no_type_check(var/turf/T, RANGE_TURFS(target, outer_tele_radius))
			if(T in RANGE_TURFS(target, inner_tele_radius))
				continue
			if(isspace(T) && !include_space)
				continue
			if(T.density && !include_dense)
				continue
			if(T.x > world.maxx - outer_tele_radius || T.x < outer_tele_radius)
				continue	//putting them at the edge is dumb
			if(T.y > world.maxy - outer_tele_radius || T.y < outer_tele_radius)
				continue
			turfs += T

		if(!length(turfs))
			var/list/turfs_to_pick_from = list()
			for_no_type_check(var/turf/T, RANGE_TURFS(target, outer_tele_radius))
				if(!(T in RANGE_TURFS(target, inner_tele_radius)))
					turfs_to_pick_from += T
			turfs += pick(/turf in turfs_to_pick_from)

		var/turf/picked = pick(turfs)

		if(!picked || !isturf(picked))
			return

		target.forceMove(picked)