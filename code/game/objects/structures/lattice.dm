/obj/structure/lattice
	desc = "A lightweight support lattice."
	name = "lattice"
	icon_state = "latticefull"
	density = FALSE
	anchored = TRUE
	layer = 2.3 //under pipes
	//	flags = CONDUCT

/obj/structure/lattice/initialize()
	. = ..()
///// Z-Level Stuff
	if(!(isspace(src.loc) || isopenspace(src.loc)))
///// Z-Level Stuff
		qdel(src)
	for(var/obj/structure/lattice/LAT in src.loc)
		if(LAT != src)
			qdel(LAT)
	icon = 'icons/obj/structures/smoothlattice.dmi'
	icon_state = "latticeblank"
	updateOverlays()
	for(var/dir in GLOBL.cardinal)
		var/obj/structure/lattice/L
		if(locate(/obj/structure/lattice, get_step(src, dir)))
			L = locate(/obj/structure/lattice, get_step(src, dir))
			L.updateOverlays()

/obj/structure/lattice/Destroy()
	for(var/dir in GLOBL.cardinal)
		var/obj/structure/lattice/L
		if(locate(/obj/structure/lattice, get_step(src, dir)))
			L = locate(/obj/structure/lattice, get_step(src, dir))
			L.updateOverlays(src.loc)
	return ..()

/obj/structure/lattice/blob_act()
	qdel(src)
	return

/obj/structure/lattice/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			return
		else
	return

/obj/structure/lattice/attackby(obj/item/C as obj, mob/user as mob)
	if(istype(C, /obj/item/stack/tile/plasteel))
		var/turf/T = get_turf(src)
		T.attackby(C, user) //BubbleWrap - hand this off to the underlying turf instead
		return
	if(istype(C, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = C
		if(WT.remove_fuel(0, user))
			to_chat(user, SPAN_INFO("Slicing lattice joints..."))
		new /obj/item/stack/rods(src.loc)
		qdel(src)

	return

/obj/structure/lattice/proc/updateOverlays()
	//if(!(isspace(src.loc)))
	//	del(src)
	spawn(1)
		overlays = list()

		var/dir_sum = 0

		for(var/direction in GLOBL.cardinal)
			if(locate(/obj/structure/lattice, get_step(src, direction)))
				dir_sum += direction
			else
				if(!isspace(get_step(src, direction)))
					dir_sum += direction

		icon_state = "lattice[dir_sum]"