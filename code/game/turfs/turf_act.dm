/turf/ex_act(severity)
	return 0

/turf/bullet_act(obj/item/projectile/proj)
	if(istype(proj, /obj/item/projectile/energy/beam/pulse))
		ex_act(2)
	else if(istype(proj, /obj/item/projectile/bullet/gyro))
		explosion(src, -1, 0, 2)
	. = ..()

/turf/proc/adjacent_fire_act(turf/open/floor/source, temperature, volume)
	return