
////////////////////////////////////////
// External Shield Generator

/obj/item/circuitboard/shield_gen_ex
	name = "circuit board (experimental hull shield generator)"
	board_type = "machine"
	build_path = /obj/machinery/shield_gen/external
	origin_tech = list(/decl/tech/plasma = 3, /decl/tech/bluespace = 4)
	frame_desc = "Requires 2 Pico Manipulators, 1 Subspace Transmitter, 5 Pieces of cable, 1 Subspace Crystal, 1 Subspace Amplifier and 1 Console Screen."
	req_components = list(
		/obj/item/stock_part/manipulator/pico = 2,
		/obj/item/stock_part/subspace/transmitter = 1,
		/obj/item/stock_part/subspace/crystal = 1,
		/obj/item/stock_part/subspace/amplifier = 1,
		/obj/item/stock_part/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

/datum/design/circuit/shield_gen_ex
	name = "Circuit Design (experimental hull shield generator)"
	desc = "Allows for the construction of circuit boards used to build an experimental hull shield generator."
	req_tech = list(/decl/tech/plasma = 3, /decl/tech/bluespace = 4)
	materials = list(
		/decl/material/glass = 2000, /decl/material/gold = 10000, /decl/material/diamond = 5000,
		/decl/material/plasma = 10000, "sacid" = 20
	)
	build_path = /obj/machinery/shield_gen/external

////////////////////////////////////////
// Shield Generator

/obj/item/circuitboard/shield_gen
	name = "circuit board (experimental bubble shield generator)"
	board_type = "machine"
	build_path = /obj/machinery/shield_gen/external
	origin_tech = list(/decl/tech/plasma = 3, /decl/tech/bluespace = 4)
	frame_desc = "Requires 2 Pico Manipulators, 1 Subspace Transmitter, 5 Pieces of cable, 1 Subspace Crystal, 1 Subspace Amplifier and 1 Console Screen."
	req_components = list(
		/obj/item/stock_part/manipulator/pico = 2,
		/obj/item/stock_part/subspace/transmitter = 1,
		/obj/item/stock_part/subspace/crystal = 1,
		/obj/item/stock_part/subspace/amplifier = 1,
		/obj/item/stock_part/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

/datum/design/circuit/shield_gen
	name = "Circuit Design (experimental bubble shield generator)"
	desc = "Allows for the construction of circuit boards used to build an experimental shield generator."
	req_tech = list(/decl/tech/plasma = 3, /decl/tech/bluespace = 4)
	materials = list(
		/decl/material/glass = 2000, /decl/material/gold = 10000, /decl/material/diamond = 5000,
		/decl/material/plasma = 10000, "sacid" = 20
	)
	build_path = /obj/machinery/shield_gen/external

////////////////////////////////////////
// Shield Capacitor

/obj/item/circuitboard/shield_cap
	name = "circuit board (experimental shield capacitor)"
	board_type = "machine"
	build_path = /obj/machinery/shield_capacitor
	origin_tech = list(/decl/tech/magnets = 3, /decl/tech/power_storage = 4)
	frame_desc = "Requires 2 Pico Manipulators, 1 Subspace Filter, 5 Pieces of cable, 1 Subspace Treatment disk, 1 Subspace Analyser and 1 Console Screen."
	req_components = list(
		/obj/item/stock_part/manipulator/pico = 2,
		/obj/item/stock_part/subspace/filter = 1,
		/obj/item/stock_part/subspace/treatment = 1,
		/obj/item/stock_part/subspace/analyser = 1,
		/obj/item/stock_part/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

/datum/design/circuit/shield_cap
	name = "Circuit Design (experimental shield capacitor)"
	desc = "Allows for the construction of circuit boards used to build an experimental shielding capacitor."
	req_tech = list(/decl/tech/magnets = 3, /decl/tech/power_storage = 4)
	materials = list(
		/decl/material/glass = 2000, /decl/material/silver = 10000, /decl/material/diamond = 5000,
		/decl/material/plasma = 10000, "sacid" = 20
	)
	build_path = /obj/machinery/shield_gen/external