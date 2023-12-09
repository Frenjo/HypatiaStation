/*
 * Supply Circuit Boards
 */

/*
 * Computers
 */
/obj/item/circuitboard/ordercomp
	name = "circuit board (Supply ordering console)"
	build_path = /obj/machinery/computer/ordercomp
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2)

/obj/item/circuitboard/supplycomp
	name = "circuit board (Supply shuttle console)"
	build_path = /obj/machinery/computer/supplycomp
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3)

	var/contraband_enabled = FALSE

/obj/item/circuitboard/supplycomp/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/multitool))
		var/catastasis = contraband_enabled
		var/opposite_catastasis
		if(catastasis)
			opposite_catastasis = "STANDARD"
			catastasis = "BROAD"
		else
			opposite_catastasis = "BROAD"
			catastasis = "STANDARD"

		switch(alert("Current receiver spectrum is set to: [catastasis]", "Multitool-Circuitboard interface", "Switch to [opposite_catastasis]", "Cancel"))
		//switch( alert("Current receiver spectrum is set to: " {(src.contraband_enabled) ? ("BROAD") : ("STANDARD")} , "Multitool-Circuitboard interface" , "Switch to " {(src.contraband_enabled) ? ("STANDARD") : ("BROAD")}, "Cancel") )
			if("Switch to STANDARD", "Switch to BROAD")
				contraband_enabled = !contraband_enabled

			if("Cancel")
				return
			else
				to_chat(user, "DERP! BUG! Report this (And what you were doing to cause it) to Agouri")

/obj/item/circuitboard/mining_shuttle
	name = "circuit board (Mining Shuttle)"
	build_path = /obj/machinery/computer/shuttle_control/mining
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2)