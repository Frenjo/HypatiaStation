/*
 * Miscellaneous Circuit Boards
 */

/*
 * Computers
 */
/obj/item/circuitboard/pod
	name = "circuit board (mass driver control)"
	build_path = /obj/machinery/computer/pod

/obj/item/circuitboard/arcade
	name = "circuit board (arcade machine)"
	build_path = /obj/machinery/computer/arcade
	origin_tech = alist(/decl/tech/programming = 1)

/obj/item/circuitboard/olddoor
	name = "circuit board (DoorMex)"
	build_path = /obj/machinery/computer/pod/old

/obj/item/circuitboard/syndicatedoor
	name = "circuit board (ProComp Executive)"
	build_path = /obj/machinery/computer/pod/old/syndicate

/obj/item/circuitboard/swfdoor
	name = "circuit board (Magix)"
	build_path = /obj/machinery/computer/pod/old/swf

/obj/item/circuitboard/holodeck_control // Not going to let people get this, but it's just here for future
	name = "circuit board (holodeck control computer)"
	build_path = /obj/machinery/computer/holodeck_control
	origin_tech = alist(/decl/tech/programming = 4)