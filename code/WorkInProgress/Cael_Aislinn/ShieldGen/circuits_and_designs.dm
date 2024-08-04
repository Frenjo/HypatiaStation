
////////////////////////////////////////
// External Shield Generator

/obj/item/circuitboard/shield_gen_ex
	name = "circuit board (Experimental hull shield generator)"
	board_type = "machine"
	build_path = /obj/machinery/shield_gen/external
	origin_tech = list(/datum/tech/plasma = 3, /datum/tech/bluespace = 4)
	frame_desc = "Requires 2 Pico Manipulators, 1 Subspace Transmitter, 5 Pieces of cable, 1 Subspace Crystal, 1 Subspace Amplifier and 1 Console Screen."
	req_components = list(
		/obj/item/stock_part/manipulator/pico = 2,
		/obj/item/stock_part/subspace/transmitter = 1,
		/obj/item/stock_part/subspace/crystal = 1,
		/obj/item/stock_part/subspace/amplifier = 1,
		/obj/item/stock_part/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

/datum/design/shield_gen_ex
	name = "Circuit Design (Experimental hull shield generator)"
	desc = "Allows for the construction of circuit boards used to build an experimental hull shield generator."
	req_tech = list(/datum/tech/plasma = 3, /datum/tech/bluespace = 4)
	build_type = IMPRINTER
	materials = list(
		/decl/material/glass = 2000, /decl/material/gold = 10000, /decl/material/diamond = 5000,
		/decl/material/plasma = 10000, "sacid" = 20
	)
	build_path = /obj/machinery/shield_gen/external

////////////////////////////////////////
// Shield Generator

/obj/item/circuitboard/shield_gen
	name = "circuit board (Experimental bubble shield generator)"
	board_type = "machine"
	build_path = /obj/machinery/shield_gen/external
	origin_tech = list(/datum/tech/plasma = 3, /datum/tech/bluespace = 4)
	frame_desc = "Requires 2 Pico Manipulators, 1 Subspace Transmitter, 5 Pieces of cable, 1 Subspace Crystal, 1 Subspace Amplifier and 1 Console Screen."
	req_components = list(
		/obj/item/stock_part/manipulator/pico = 2,
		/obj/item/stock_part/subspace/transmitter = 1,
		/obj/item/stock_part/subspace/crystal = 1,
		/obj/item/stock_part/subspace/amplifier = 1,
		/obj/item/stock_part/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

/datum/design/shield_gen
	name = "Circuit Design (Experimental bubble shield generator)"
	desc = "Allows for the construction of circuit boards used to build an experimental shield generator."
	req_tech = list(/datum/tech/plasma = 3, /datum/tech/bluespace = 4)
	build_type = IMPRINTER
	materials = list(
		/decl/material/glass = 2000, /decl/material/gold = 10000, /decl/material/diamond = 5000,
		/decl/material/plasma = 10000, "sacid" = 20
	)
	build_path = /obj/machinery/shield_gen/external

////////////////////////////////////////
// Shield Capacitor

/obj/item/circuitboard/shield_cap
	name = "circuit board (Experimental shield capacitor)"
	board_type = "machine"
	build_path = /obj/machinery/shield_capacitor
	origin_tech = list(/datum/tech/magnets = 3, /datum/tech/power_storage = 4)
	frame_desc = "Requires 2 Pico Manipulators, 1 Subspace Filter, 5 Pieces of cable, 1 Subspace Treatment disk, 1 Subspace Analyser and 1 Console Screen."
	req_components = list(
		/obj/item/stock_part/manipulator/pico = 2,
		/obj/item/stock_part/subspace/filter = 1,
		/obj/item/stock_part/subspace/treatment = 1,
		/obj/item/stock_part/subspace/analyser = 1,
		/obj/item/stock_part/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

/datum/design/shield_cap
	name = "Circuit Design (Experimental shield capacitor)"
	desc = "Allows for the construction of circuit boards used to build an experimental shielding capacitor."
	req_tech = list(/datum/tech/magnets = 3, /datum/tech/power_storage = 4)
	build_type = IMPRINTER
	materials = list(
		/decl/material/glass = 2000, /decl/material/silver = 10000, /decl/material/diamond = 5000,
		/decl/material/plasma = 10000, "sacid" = 20
	)
	build_path = /obj/machinery/shield_gen/external