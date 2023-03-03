#define XENOARCH_SPAWN_CHANCE 0.5
#define XENOARCH_SPREAD_CHANCE 15
#define ARTIFACT_SPAWN_CHANCE 20
/proc/setup_xenoarch()
	for(var/turf/simulated/mineral/M in block(locate(1, 1, 1), locate(world.maxx, world.maxy, world.maxz)))
		if(!M.geologic_data)
			M.geologic_data = new/datum/geosample(M)

		if(!prob(XENOARCH_SPAWN_CHANCE))
			continue

		var/digsite = get_random_digsite_type()
		var/list/processed_turfs = list()
		var/list/turfs_to_process = list(M)
		for(var/turf/simulated/mineral/archeo_turf in turfs_to_process)
			for(var/turf/simulated/mineral/T in orange(1, archeo_turf))
				if(T.finds)
					continue
				if(T in processed_turfs)
					continue
				if(prob(XENOARCH_SPREAD_CHANCE))
					turfs_to_process.Add(T)

			processed_turfs.Add(archeo_turf)
			if(!archeo_turf.finds)
				archeo_turf.finds = list()
				if(prob(50))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(5, 95)))
				else if(prob(75))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(5, 45)))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(55, 95)))
				else
					archeo_turf.finds.Add(new /datum/find(digsite, rand(5, 30)))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(35, 75)))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(75, 95)))

				//sometimes a find will be close enough to the surface to show
				var/datum/find/F = archeo_turf.finds[1]
				if(F.excavation_required <= F.view_range)
					archeo_turf.archaeo_overlay = "overlay_archaeo[rand(1, 3)]"
					archeo_turf.overlays += archeo_turf.archaeo_overlay

		//dont create artifact machinery in animal or plant digsites, or if we already have one
		if(!M.artifact_find && digsite != 1 && digsite != 2 && prob(ARTIFACT_SPAWN_CHANCE))
			M.artifact_find = new /datum/artifact_find()
#undef XENOARCH_SPAWN_CHANCE
#undef XENOARCH_SPREAD_CHANCE
#undef ARTIFACT_SPAWN_CHANCE