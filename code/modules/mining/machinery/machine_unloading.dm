/*
 * Unloading Unit
 */
/obj/machinery/mineral/unloading_machine
	name = "unloading machine"
	icon_state = "unloader"

	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null

/obj/machinery/mineral/unloading_machine/initialize()
	..()
	for(var/dir in GLOBL.cardinal)
		input = locate(/obj/machinery/mineral/input, get_step(src, dir))
		if(input)
			break
	for(var/dir in GLOBL.cardinal)
		output = locate(/obj/machinery/mineral/output, get_step(src, dir))
		if(output)
			break

/obj/machinery/mineral/unloading_machine/process()
	if(output && input)
		if(locate(/obj/structure/ore_box, input.loc))
			var/obj/structure/ore_box/BOX = locate(/obj/structure/ore_box, input.loc)
			var/i = 0
			for(var/obj/item/weapon/ore/O in BOX.contents)
				BOX.contents -= O
				O.loc = output.loc
				i++
				if(i >= 10)
					return
		if(locate(/obj/item, input.loc))
			var/obj/item/O
			for(var/i = 0; i < 10; i++)
				O = locate(/obj/item, input.loc)
				if(O)
					O.loc = src.output.loc
				else
					return
	return