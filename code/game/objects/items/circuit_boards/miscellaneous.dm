/*
 * Miscellaneous Circuit Boards
 */

/*
 * Computers
 */
/obj/item/circuitboard/pod
	name = "circuit board (Massdriver control)"
	build_path = /obj/machinery/computer/pod

/obj/item/circuitboard/arcade
	name = "circuit board (Arcade)"
	build_path = /obj/machinery/computer/arcade
	origin_tech = list(/datum/tech/programming = 1)

/obj/item/circuitboard/olddoor
	name = "circuit board (DoorMex)"
	build_path = /obj/machinery/computer/pod/old

/obj/item/circuitboard/syndicatedoor
	name = "circuit board (ProComp Executive)"
	build_path = /obj/machinery/computer/pod/old/syndicate

/obj/item/circuitboard/swfdoor
	name = "circuit board (Magix)"
	build_path = /obj/machinery/computer/pod/old/swf

/obj/item/circuitboard/HolodeckControl // Not going to let people get this, but it's just here for future
	name = "circuit board (Holodeck Control)"
	build_path = /obj/machinery/computer/holodeck_control
	origin_tech = list(/datum/tech/programming = 4)