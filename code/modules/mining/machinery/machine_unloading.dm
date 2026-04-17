/*
 * Unloading Unit
 */
/obj/machinery/unloading_machine
	name = "unloading machine"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "unloader"
	density = TRUE
	anchored = TRUE

	var/turf/input_turf = null
	var/turf/output_turf = null

/obj/machinery/unloading_machine/initialise()
	. = ..()
	for(var/dir in GLOBL.cardinal)
		var/obj/machinery/input_plate/in_plate = locate(/obj/machinery/input_plate, get_step(src, dir))
		if(isnotnull(in_plate))
			input_turf = GET_TURF(in_plate)
			break
	for(var/dir in GLOBL.cardinal)
		var/obj/machinery/output_plate/out_plate = locate(/obj/machinery/output_plate, get_step(src, dir))
		if(isnotnull(out_plate))
			output_turf = GET_TURF(out_plate)
			break

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