
//////////////////////////////////////
// RUST Core Control computer

/obj/item/circuitboard/rust_core_control
	name = "circuit board (RUST core controller)"
	build_path = /obj/machinery/computer/rust_core_control
	origin_tech = list(/datum/tech/engineering = 4, /datum/tech/programming = 4)

/datum/design/circuit/rust_core_control
	name = "Circuit Design (RUST core controller)"
	desc = "Allows for the construction of circuit boards used to build a core control console for the RUST fusion engine."
	req_tech = list(/datum/tech/engineering = 4, /datum/tech/programming = 4)
	build_path = /obj/item/circuitboard/rust_core_control

//////////////////////////////////////
// RUST Fuel Control computer

/obj/item/circuitboard/rust_fuel_control
	name = "circuit board (RUST fuel controller)"
	build_path = /obj/machinery/computer/rust_fuel_control
	origin_tech = list(/datum/tech/engineering = 4, /datum/tech/programming = 4)

/datum/design/circuit/rust_fuel_control
	name = "Circuit Design (RUST fuel controller)"
	desc = "Allows for the construction of circuit boards used to build a fuel injector control console for the RUST fusion engine."
	req_tech = list(/datum/tech/engineering = 4, /datum/tech/programming = 4)
	build_path = /obj/item/circuitboard/rust_fuel_control

//////////////////////////////////////
// RUST Fuel Port board

/obj/item/module/rust_fuel_port
	name = "Internal circuitry (RUST fuel port)"
	icon_state = "card_mod"
	origin_tech = list(/datum/tech/materials = 5, /datum/tech/engineering = 4)

/datum/design/circuit/rust_fuel_port
	name = "Internal circuitry (RUST fuel port)"
	desc = "Allows for the construction of circuit boards used to build a fuel injection port for the RUST fusion engine."
	req_tech = list(/datum/tech/materials = 5, /datum/tech/engineering = 4)
	materials = list(/decl/material/glass = 2000, /decl/material/uranium = 3000, "sacid" = 20)
	build_path = /obj/item/module/rust_fuel_port

//////////////////////////////////////
// RUST Fuel Compressor board

/obj/item/module/rust_fuel_compressor
	name = "Internal circuitry (RUST fuel compressor)"
	icon_state = "card_mod"
	origin_tech = list(/datum/tech/materials = 6, /datum/tech/plasma = 4)

/datum/design/circuit/rust_fuel_compressor
	name = "Circuit Design (RUST fuel compressor)"
	desc = "Allows for the construction of circuit boards used to build a fuel compressor of the RUST fusion engine."
	req_tech = list(/datum/tech/materials = 6, /datum/tech/plasma = 4)
	materials = list(/decl/material/glass = 2000, /decl/material/diamond = 1000, /decl/material/plasma = 3000, "sacid" = 20)
	build_path = /obj/item/module/rust_fuel_compressor

//////////////////////////////////////
// RUST Tokamak Core board

/obj/item/circuitboard/rust_core
	name = "Internal circuitry (RUST tokamak core)"
	build_path = /obj/machinery/power/rust_core
	board_type = "machine"
	origin_tech = list(
		/datum/tech/magnets = 5, /datum/tech/power_storage = 6, /datum/tech/plasma = 4,
		/datum/tech/bluespace = 3
	)
	frame_desc = "Requires 2 Pico Manipulators, 1 Ultra Micro-Laser, 5 Pieces of Cable, 1 Subspace Crystal and 1 Console Screen."
	req_components = list(
		/obj/item/stock_part/manipulator/pico = 2,
		/obj/item/stock_part/micro_laser/ultra = 1,
		/obj/item/stock_part/subspace/crystal = 1,
		/obj/item/stock_part/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

/datum/design/circuit/rust_core
	name = "Internal circuitry (RUST tokamak core)"
	desc = "The circuit board that for a RUST-pattern tokamak fusion core."
	req_tech = list(
		/datum/tech/magnets = 5, /datum/tech/power_storage = 6, /datum/tech/plasma = 4,
		/datum/tech/bluespace = 3
	)
	reliability_base = 79
	materials = list(/decl/material/glass = 2000, /decl/material/diamond = 2000, /decl/material/plasma = 3000, "sacid" = 20)
	build_path = /obj/item/circuitboard/rust_core

//////////////////////////////////////
// RUST Fuel Injector board

/obj/item/circuitboard/rust_injector
	name = "Internal circuitry (RUST fuel injector)"
	build_path = /obj/machinery/power/rust_fuel_injector
	board_type = "machine"
	origin_tech = list(
		/datum/tech/materials = 6, /datum/tech/engineering = 4, /datum/tech/power_storage = 3, /datum/tech/plasma = 4
	)
	frame_desc = "Requires 2 Pico Manipulators, 1 Phasic Scanning Module, 1 Super Matter Bin, 1 Console Screen and 5 Pieces of Cable."
	req_components = list(
		/obj/item/stock_part/manipulator/pico = 2,
		/obj/item/stock_part/scanning_module/phasic = 1,
		/obj/item/stock_part/matter_bin/super = 1,
		/obj/item/stock_part/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

/datum/design/circuit/rust_injector
	name = "Internal circuitry (RUST tokamak core)"
	desc = "The circuit board that for a RUST-pattern particle accelerator."
	req_tech = list(
		/datum/tech/materials = 6, /datum/tech/engineering = 4, /datum/tech/power_storage = 3,
		/datum/tech/plasma = 4
	)
	reliability_base = 79
	materials = list(/decl/material/glass = 2000, /decl/material/uranium = 2000, /decl/material/plasma = 3000, "sacid" = 20)
	build_path = /obj/item/circuitboard/rust_core