/obj/structure/lattice
	desc = "A lightweight support lattice."
	name = "lattice"
	icon_state = "latticefull"
	density = FALSE
	anchored = TRUE
	layer = 2.3 //under pipes
	//	flags = CONDUCT

/obj/structure/lattice/initialise()
	. = ..()
///// Z-Level Stuff
	if(!isspace(loc) && !isopenspace(loc))
		qdel(src)
///// Z-Level Stuff

	for(var/obj/structure/lattice/other in loc)
		if(other != src)
			qdel(other)

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
			L.updateOverlays(loc)
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

/obj/structure/lattice/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/stack/tile/metal/grey))
		var/turf/T = GET_TURF(src)
		T.attackby(C, user) //BubbleWrap - hand this off to the underlying turf instead
		return
	if(iswelder(C))
		var/obj/item/welding_torch/WT = C
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