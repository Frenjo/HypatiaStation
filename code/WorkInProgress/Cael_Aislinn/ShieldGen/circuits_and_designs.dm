
////////////////////////////////////////
// External Shield Generator

/obj/item/circuitboard/shield_gen_ex
	name = "circuit board (experimental hull shield generator)"
	board_type = "machine"
	build_path = /obj/machinery/shield_gen/external
	origin_tech = alist(/decl/tech/plasma = 3, /decl/tech/bluespace = 4)
	frame_desc = "Requires 2 pico-manipulators, 1 subspace transmitter, 5 pieces of cable, 1 ansible crystal, 1 subspace amplifier and 1 console screen."
	req_components = list(
		/obj/item/stock_part/manipulator/pico = 2,
		/obj/item/stock_part/subspace_transmitter = 1,
		/obj/item/stock_part/subspace_crystal = 1,
		/obj/item/stock_part/subspace_amplifier = 1,
		/obj/item/stock_part/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

/datum/design/circuit/shield_gen_ex
	name = "Experimental Hull Shield Generator"
	desc = "Allows for the construction of circuit boards used to build an experimental hull shield generator."
	req_tech = alist(/decl/tech/plasma = 3, /decl/tech/bluespace = 4)
	materials = alist(
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
	origin_tech = alist(/decl/tech/plasma = 3, /decl/tech/bluespace = 4)
	frame_desc = "Requires 2 pico-manipulators, 1 subspace transmitter, 5 pieces of cable, 1 ansible crystal, 1 subspace amplifier and 1 console screen."
	req_components = list(
		/obj/item/stock_part/manipulator/pico = 2,
		/obj/item/stock_part/subspace_transmitter = 1,
		/obj/item/stock_part/subspace_crystal = 1,
		/obj/item/stock_part/subspace_amplifier = 1,
		/obj/item/stock_part/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

/datum/design/circuit/shield_gen
	name = "Experimental Bubble Shield Generator"
	desc = "Allows for the construction of circuit boards used to build an experimental bubble shield generator."
	req_tech = alist(/decl/tech/plasma = 3, /decl/tech/bluespace = 4)
	materials = alist(
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
	origin_tech = alist(/decl/tech/magnets = 3, /decl/tech/power_storage = 4)
	frame_desc = "Requires 2 pico-manipulators, 1 subspace filter, 5 pieces of cable, 1 subspace treatment disk, 1 subspace analyser and 1 console screen."
	req_components = list(
		/obj/item/stock_part/manipulator/pico = 2,
		/obj/item/stock_part/subspace_filter = 1,
		/obj/item/stock_part/subspace_treatment = 1,
		/obj/item/stock_part/subspace_analyser = 1,
		/obj/item/stock_part/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

/datum/design/circuit/shield_cap
	name = "Experimental Shield Capacitor"
	desc = "Allows for the construction of circuit boards used to build an experimental shield capacitor."
	req_tech = alist(/decl/tech/magnets = 3, /decl/tech/power_storage = 4)
	materials = alist(
		/decl/material/glass = 2000, /decl/material/silver = 10000, /decl/material/diamond = 5000,
		/decl/material/plasma = 10000, "sacid" = 20
	)
	build_path = /obj/machinery/shield_gen/external