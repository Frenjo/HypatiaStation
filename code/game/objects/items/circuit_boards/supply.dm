/*
 * Supply Circuit Boards
 */

/*
 * Computers
 */
/obj/item/circuitboard/supplycomp
	name = "circuit board (supply shuttle console)"
	build_path = /obj/machinery/computer/supplycomp
	origin_tech = alist(/decl/tech/programming = 3)

	var/contraband_enabled = FALSE

/obj/item/circuitboard/supplycomp/attack_tool(obj/item/tool, mob/user)
	if(ismultitool(tool))
		var/catastasis = contraband_enabled
		var/opposite_catastasis
		if(catastasis)
			opposite_catastasis = "STANDARD"
			catastasis = "BROAD"
		else
			opposite_catastasis = "BROAD"
			catastasis = "STANDARD"

		var/result = alert("Current receiver spectrum is set to: [catastasis]", "Multitool-Circuitboard Interface", "Switch to [opposite_catastasis]", "Cancel")
		if(isnotnull(result))
			switch(result)
				if("Switch to STANDARD", "Switch to BROAD")
					contraband_enabled = !contraband_enabled
		return TRUE

	return ..()

/obj/item/circuitboard/ordercomp
	name = "circuit board (supply ordering console)"
	build_path = /obj/machinery/computer/ordercomp

/obj/item/circuitboard/mining_shuttle
	name = "circuit board (mining shuttle control console)"
	build_path = /obj/machinery/computer/shuttle_control/mining