
//---------- external shield generator
//generates an energy field that loops around any built up area in space (is useless inside) halts movement and airflow, is blocked by walls, windows, airlocks etc

/obj/machinery/shield_gen/external/get_shielded_turfs()
	var/list/open = list(GET_TURF(src))
	var/list/closed = list()

	while(open.len)
		for_no_type_check(var/turf/T, open)
			for_no_type_check(var/turf/O, RANGE_TURFS(T, 1))
				if(get_dist(O, src) > field_radius)
					continue
				var/add_this_turf = 0
				if(isspace(O))
					for(var/turf/open/G in RANGE_TURFS(O, 1))
						add_this_turf = 1
						break

					//uncomment this for structures (but not lattices) to be surrounded by shield as well
					/*if(!add_this_turf)
						for(var/obj/structure/S in orange(1, O))
							if(!istype(S, /obj/structure/lattice))
								add_this_turf = 1
								break
					if(add_this_turf)
						for(var/obj/structure/S in O)
							if(!istype(S, /obj/structure/lattice))
								add_this_turf = 0
								break*/

					if(add_this_turf && !(O in open) && !(O in closed))
						open += O
			open -= T
			closed += T

	return closed
