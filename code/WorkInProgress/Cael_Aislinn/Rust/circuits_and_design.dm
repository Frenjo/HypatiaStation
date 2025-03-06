
//////////////////////////////////////
// RUST Core Control computer

/obj/item/circuitboard/rust_core_control
	name = "circuit board (RUST core control)"
	build_path = /obj/machinery/computer/rust_core_control
	origin_tech = list(/decl/tech/engineering = 4, /decl/tech/programming = 4)

/datum/design/circuit/rust_core_control
	name = "RUST Core Control"
	desc = "Allows for the construction of circuit boards used to build a core control console for the RUST fusion engine."
	req_tech = list(/decl/tech/engineering = 4, /decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/rust_core_control

//////////////////////////////////////
// RUST Fuel Control computer

/obj/item/circuitboard/rust_fuel_control
	name = "circuit board (RUST fuel injection control)"
	build_path = /obj/machinery/computer/rust_fuel_control
	origin_tech = list(/decl/tech/engineering = 4, /decl/tech/programming = 4)

/datum/design/circuit/rust_fuel_control
	name = "RUST Fuel Injection Control"
	desc = "Allows for the construction of circuit boards used to build a fuel injection control console for the RUST fusion engine."
	req_tech = list(/decl/tech/engineering = 4, /decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/rust_fuel_control

//////////////////////////////////////
// RUST Fuel Port board

/obj/item/module/rust_fuel_port
	name = "circuit module (RUST fuel port)"
	icon_state = "card_mod"
	origin_tech = list(/decl/tech/materials = 5, /decl/tech/engineering = 4)

/datum/design/circuit/rust_fuel_port
	name = "RUST fuel port"
	desc = "Allows for the construction of circuit modules used to build a fuel injection port for the RUST fusion engine."
	req_tech = list(/decl/tech/materials = 5, /decl/tech/engineering = 4)
	materials = alist(/decl/material/glass = 2000, /decl/material/uranium = 3000, "sacid" = 20)
	build_path = /obj/item/module/rust_fuel_port

//////////////////////////////////////
// RUST Fuel Compressor board

/obj/item/module/rust_fuel_compressor
	name = "circuit module (RUST fuel compressor)"
	icon_state = "card_mod"
	origin_tech = list(/decl/tech/materials = 6, /decl/tech/plasma = 4)

/datum/design/circuit/rust_fuel_compressor
	name = "RUST Fuel Compressor"
	desc = "Allows for the construction of circuit modules used to build a fuel compressor for the RUST fusion engine."
	req_tech = list(/decl/tech/materials = 6, /decl/tech/plasma = 4)
	materials = alist(/decl/material/glass = 2000, /decl/material/diamond = 1000, /decl/material/plasma = 3000, "sacid" = 20)
	build_path = /obj/item/module/rust_fuel_compressor

//////////////////////////////////////
// RUST Tokamak Core board

/obj/item/circuitboard/rust_core
	name = "circuit board (RUST tokamak core)"
	build_path = /obj/machinery/power/rust_core
	board_type = "machine"
	origin_tech = list(
		/decl/tech/magnets = 5, /decl/tech/power_storage = 6, /decl/tech/plasma = 4,
		/decl/tech/bluespace = 3
	)
	frame_desc = "Requires 2 pico-manipulators, 1 ultra-high-power micro-laser, 5 pieces of cable, 1 ansible crystal and 1 console screen."
	req_components = list(
		/obj/item/stock_part/manipulator/pico = 2,
		/obj/item/stock_part/micro_laser/ultra = 1,
		/obj/item/stock_part/subspace/crystal = 1,
		/obj/item/stock_part/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

/datum/design/circuit/rust_core
	name = "RUST Tokamak Core"
	desc = "Allows for the construction of circuit boards used to build a RUST-pattern tokamak fusion core."
	req_tech = list(
		/decl/tech/magnets = 5, /decl/tech/power_storage = 6, /decl/tech/plasma = 4,
		/decl/tech/bluespace = 3
	)
	reliability_base = 79
	materials = alist(/decl/material/glass = 2000, /decl/material/diamond = 2000, /decl/material/plasma = 3000, "sacid" = 20)
	build_path = /obj/item/circuitboard/rust_core

//////////////////////////////////////
// RUST Fuel Injector board

/obj/item/circuitboard/rust_injector
	name = "circuit board (RUST fuel injector)"
	build_path = /obj/machinery/power/rust_fuel_injector
	board_type = "machine"
	origin_tech = list(
		/decl/tech/materials = 6, /decl/tech/engineering = 4, /decl/tech/power_storage = 3, /decl/tech/plasma = 4
	)
	frame_desc = "Requires 2 pico-manipulators, 1 phasic scanning module, 1 super matter bin, 1 console screen and 5 pieces of cable."
	req_components = list(
		/obj/item/stock_part/manipulator/pico = 2,
		/obj/item/stock_part/scanning_module/phasic = 1,
		/obj/item/stock_part/matter_bin/super = 1,
		/obj/item/stock_part/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

/datum/design/circuit/rust_injector
	name = "RUST Fuel Injector"
	desc = "Allows for the construction of circuit boards used to build a RUST-pattern fuel injection particle accelerator."
	req_tech = list(
		/decl/tech/materials = 6, /decl/tech/engineering = 4, /decl/tech/power_storage = 3,
		/decl/tech/plasma = 4
	)
	reliability_base = 79
	materials = alist(/decl/material/glass = 2000, /decl/material/uranium = 2000, /decl/material/plasma = 3000, "sacid" = 20)
	build_path = /obj/item/circuitboard/rust_injector