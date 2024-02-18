/*
 * Unloading Unit
 */
/obj/machinery/mineral/unloading_machine
	name = "unloading machine"
	icon_state = "unloader"

	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null

/obj/machinery/mineral/unloading_machine/initialise()
	. = ..()
	for(var/dir in GLOBL.cardinal)
		input = locate(/obj/machinery/mineral/input, get_step(src, dir))
		if(isnotnull(input))
			break
	for(var/dir in GLOBL.cardinal)
		output = locate(/obj/machinery/mineral/output, get_step(src, dir))
		if(isnotnull(output))
			break

/obj/machinery/mineral/unloading_machine/process()
	if(isnotnull(input) && isnotnull(output))
		if(locate(/obj/structure/ore_box, input.loc))
			var/obj/structure/ore_box/BOX = locate(/obj/structure/ore_box, input.loc)
			var/i = 0
			for(var/obj/item/ore/O in BOX.contents)
				BOX.contents -= O
				O.loc = output.loc
				i++
				if(i >= 10)
					return
		if(locate(/obj/item, input.loc))
			var/obj/item/O
			for(var/i = 0; i < 10; i++)
				O = locate(/obj/item, input.loc)
				O?.loc = output.loc