/turf/closed/wall/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	if(adj_temp > max_temperature)
		take_damage(log(rand(5, 10) * (adj_temp - max_temperature)))
	return ..()

/turf/closed/wall/ex_act(severity)
	switch(severity)
		if(1)
			ChangeTurf(get_base_turf_by_area(get_area(loc)))
			return
		if(2)
			if(prob(75))
				take_damage(rand(150, 250))
			else
				dismantle_wall(1, 1)
		if(3)
			take_damage(rand(0, 250))

/turf/closed/wall/blob_act()
	take_damage(rand(75, 125))

/turf/closed/wall/meteorhit(obj/M)
	if(prob(15) && !rotting)
		dismantle_wall()
	else if(prob(70) && !rotting)
		ChangeTurf(/turf/simulated/floor/plating/metal)
	else
		ReplaceWithLattice()
	return 0