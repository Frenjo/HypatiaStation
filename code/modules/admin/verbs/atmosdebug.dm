/client/proc/atmosscan()
	set category = PANEL_MAPPING
	set name = "Check Plumbing"

	if(!src.holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return

	feedback_add_details("admin_verb", "CP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	//all plumbing - yes, some things might get stated twice, doesn't matter.
	for(var/obj/machinery/atmospherics/plumbing in GLOBL.machines)
		if(plumbing.nodealert)
			to_chat(usr, "Unconnected [plumbing.name] located at [plumbing.x], [plumbing.y], [plumbing.z] ([GET_AREA(plumbing)])")

	//Manifolds
	for(var/obj/machinery/atmospherics/pipe/manifold/pipe in GLOBL.machines)
		if(!pipe.node1 || !pipe.node2 || !pipe.node3)
			to_chat(usr, "Unconnected [pipe.name] located at [pipe.x], [pipe.y], [pipe.z] ([GET_AREA(pipe)])")

	//Pipes
	for(var/obj/machinery/atmospherics/pipe/simple/pipe in GLOBL.machines)
		if(!pipe.node1 || !pipe.node2)
			to_chat(usr, "Unconnected [pipe.name] located at [pipe.x], [pipe.y], [pipe.z] ([GET_AREA(pipe)])")

/client/proc/powerdebug()
	set category = PANEL_MAPPING
	set name = "Check Power"

	if(!src.holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return

	feedback_add_details("admin_verb", "CPOW") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	for_no_type_check(var/datum/powernet/PN, GLOBL.powernets)
		if(!length(PN.nodes))
			if(length(PN.cables) > 1)
				var/obj/structure/cable/C = PN.cables[1]
				to_chat(usr, "Powernet with no nodes! (number [PN.number]) - example cable at [C.x], [C.y], [C.z] in area [GET_AREA(C)]")

		if(!PN.cables || length(PN.cables) < 10)
			if(length(PN.cables) > 1)
				var/obj/structure/cable/C = PN.cables[1]
				to_chat(usr, "Powernet with fewer than 10 cables! (number [PN.number]) - example cable at [C.x], [C.y], [C.z] in area [GET_AREA(C)]")