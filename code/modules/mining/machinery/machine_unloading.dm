/*
 * Unloading Unit
 */
/obj/machinery/unloading_machine
	name = "unloading machine"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "unloader"
	density = TRUE
	anchored = TRUE

	var/input_dir = null
	var/output_dir = null

	var/turf/input_turf = null
	var/turf/output_turf = null

/obj/machinery/unloading_machine/initialise()
	. = ..()
	input_turf = get_step(src, input_dir)
	output_turf = get_step(src, output_dir)
	START_PROCESSING(PCobj, src)

/obj/machinery/unloading_machine/Destroy()
	STOP_PROCESSING(PCobj, src)
	return ..()

/obj/machinery/unloading_machine/process()
	if(isnotnull(input_turf) && isnotnull(output_turf))
		if(locate(/obj/structure/ore_box, input_turf))
			var/obj/structure/ore_box/BOX = locate(/obj/structure/ore_box, input_turf)
			var/i = 0
			for(var/obj/item/ore/O in BOX.contents)
				BOX.contents -= O
				O.forceMove(output_turf)
				i++
				if(i >= 10)
					return
		if(locate(/obj/item, input_turf))
			var/obj/item/O
			for(var/i = 0; i < 10; i++)
				O = locate(/obj/item, input_turf)
				O?.forceMove(output_turf)

/obj/machinery/unloading_machine/north_south
	input_dir = NORTH
	output_dir = SOUTH

/obj/machinery/unloading_machine/west_east
	input_dir = WEST
	output_dir = EAST

/obj/machinery/unloading_machine/corner
	icon_state = "unloader-corner"
	input_dir = EAST
	output_dir = SOUTH