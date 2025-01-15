/obj/machinery/atmospherics/pipe/vent
	name = "pipe vent"
	desc = "A large passive air vent."
	icon = 'icons/obj/atmospherics/pipe_vent.dmi'
	icon_state = "intact"

	level = 1

	volume = 250

	dir = SOUTH
	initialize_directions = SOUTH

	var/build_killswitch = 1

	var/obj/machinery/atmospherics/node1

/obj/machinery/atmospherics/pipe/vent/high_volume
	name = "large pipe vent"
	desc = "A larger, high-volume passive air vent."
	volume = 1000

/obj/machinery/atmospherics/pipe/vent/New()
	initialize_directions = dir
	. = ..()

/obj/machinery/atmospherics/pipe/vent/atmos_initialise()
	var/connect_direction = dir

	for(var/obj/machinery/atmospherics/target in get_step(src, connect_direction))
		if(target.initialize_directions & get_dir(target, src))
			node1 = target
			break

	update_icon()

/obj/machinery/atmospherics/pipe/vent/Destroy()
	node1?.disconnect(src)
	return ..()

/obj/machinery/atmospherics/pipe/vent/process()
	if(isnull(parent))
		if(build_killswitch <= 0)
			. = PROCESS_KILL
		else
			build_killswitch--
		..()
		return
	else
		parent.mingle_with_turf(loc, volume)
/*
	if(!node1)
		if(!nodealert)
			//to_world("Missing node from [src] at [src.x],[src.y],[src.z]")
			nodealert = 1
	else if (nodealert)
		nodealert = 0
*/

/obj/machinery/atmospherics/pipe/vent/pipeline_expansion()
	return list(node1)

/obj/machinery/atmospherics/pipe/vent/update_icon()
	if(isnotnull(node1))
		icon_state = "intact"
		dir = get_dir(src, node1)
	else
		icon_state = "exposed"

/obj/machinery/atmospherics/pipe/vent/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node1)
		if(istype(node1, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node1 = null

	update_icon()
	return null

/obj/machinery/atmospherics/pipe/vent/hide(i) //to make the little pipe section invisible, the icon changes.
	if(isnotnull(node1))
		icon_state = "[i == 1 && isopenturf(loc) ? "h" : "" ]intact"
		dir = get_dir(src, node1)
	else
		icon_state = "exposed"