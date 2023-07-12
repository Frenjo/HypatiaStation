
//////////////////////////////////////
// RUST Core Control computer

/obj/item/circuitboard/rust_core_control
	name = "circuit board (RUST core controller)"
	build_path = /obj/machinery/computer/rust_core_control
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_ENGINEERING = 4)

/datum/design/rust_core_control
	name = "Circuit Design (RUST core controller)"
	desc = "Allows for the construction of circuit boards used to build a core control console for the RUST fusion engine."
	id = "rust_core_control"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_ENGINEERING = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/rust_core_control

//////////////////////////////////////
// RUST Fuel Control computer

/obj/item/circuitboard/rust_fuel_control
	name = "circuit board (RUST fuel controller)"
	build_path = /obj/machinery/computer/rust_fuel_control
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_ENGINEERING = 4)

/datum/design/rust_fuel_control
	name = "Circuit Design (RUST fuel controller)"
	desc = "Allows for the construction of circuit boards used to build a fuel injector control console for the RUST fusion engine."
	id = "rust_fuel_control"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_ENGINEERING = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/rust_fuel_control

//////////////////////////////////////
// RUST Fuel Port board

/obj/item/module/rust_fuel_port
	name = "Internal circuitry (RUST fuel port)"
	icon_state = "card_mod"
	origin_tech = list(RESEARCH_TECH_ENGINEERING = 4, RESEARCH_TECH_MATERIALS = 5)

/datum/design/rust_fuel_port
	name = "Internal circuitry (RUST fuel port)"
	desc = "Allows for the construction of circuit boards used to build a fuel injection port for the RUST fusion engine."
	id = "rust_fuel_port"
	req_tech = list(RESEARCH_TECH_ENGINEERING = 4, RESEARCH_TECH_MATERIALS = 5)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20, MATERIAL_URANIUM = 3000)
	build_path = /obj/item/module/rust_fuel_port

//////////////////////////////////////
// RUST Fuel Compressor board

/obj/item/module/rust_fuel_compressor
	name = "Internal circuitry (RUST fuel compressor)"
	icon_state = "card_mod"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 6, RESEARCH_TECH_PLASMATECH = 4)

/datum/design/rust_fuel_compressor
	name = "Circuit Design (RUST fuel compressor)"
	desc = "Allows for the construction of circuit boards used to build a fuel compressor of the RUST fusion engine."
	id = "rust_fuel_compressor"
	req_tech = list(RESEARCH_TECH_MATERIALS = 6, RESEARCH_TECH_PLASMATECH = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20, MATERIAL_PLASMA = 3000, MATERIAL_DIAMOND = 1000)
	build_path = /obj/item/module/rust_fuel_compressor

//////////////////////////////////////
// RUST Tokamak Core board

/obj/item/circuitboard/rust_core
	name = "Internal circuitry (RUST tokamak core)"
	build_path = /obj/machinery/power/rust_core
	board_type = "machine"
	origin_tech = list(
		RESEARCH_TECH_BLUESPACE = 3, RESEARCH_TECH_PLASMATECH = 4, RESEARCH_TECH_MAGNETS = 5,
		RESEARCH_TECH_POWERSTORAGE = 6
	)
	frame_desc = "Requires 2 Pico Manipulators, 1 Ultra Micro-Laser, 5 Pieces of Cable, 1 Subspace Crystal and 1 Console Screen."
	req_components = list(
		/obj/item/stock_part/manipulator/pico = 2,
		/obj/item/stock_part/micro_laser/ultra = 1,
		/obj/item/stock_part/subspace/crystal = 1,
		/obj/item/stock_part/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

/datum/design/rust_core
	name = "Internal circuitry (RUST tokamak core)"
	desc = "The circuit board that for a RUST-pattern tokamak fusion core."
	id = "pacman"
	req_tech = list(
		RESEARCH_TECH_BLUESPACE = 3, RESEARCH_TECH_PLASMATECH = 4, RESEARCH_TECH_MAGNETS = 5,
		RESEARCH_TECH_POWERSTORAGE = 6
	)
	build_type = IMPRINTER
	reliability_base = 79
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20, MATERIAL_PLASMA = 3000, MATERIAL_DIAMOND = 2000)
	build_path = /obj/item/circuitboard/rust_core

//////////////////////////////////////
// RUST Fuel Injector board

/obj/item/circuitboard/rust_injector
	name = "Internal circuitry (RUST fuel injector)"
	build_path = /obj/machinery/power/rust_fuel_injector
	board_type = "machine"
	origin_tech = list(
		RESEARCH_TECH_POWERSTORAGE = 3, RESEARCH_TECH_ENGINEERING = 4, RESEARCH_TECH_PLASMATECH = 4,
		RESEARCH_TECH_MATERIAL = 6
	)
	frame_desc = "Requires 2 Pico Manipulators, 1 Phasic Scanning Module, 1 Super Matter Bin, 1 Console Screen and 5 Pieces of Cable."
	req_components = list(
		/obj/item/stock_part/manipulator/pico = 2,
		/obj/item/stock_part/scanning_module/phasic = 1,
		/obj/item/stock_part/matter_bin/super = 1,
		/obj/item/stock_part/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

/datum/design/rust_injector
	name = "Internal circuitry (RUST tokamak core)"
	desc = "The circuit board that for a RUST-pattern particle accelerator."
	id = "pacman"
	req_tech = list(
		RESEARCH_TECH_POWERSTORAGE = 3, RESEARCH_TECH_ENGINEERING = 4, RESEARCH_TECH_PLASMATECH = 4,
		RESEARCH_TECH_MATERIAL = 6
	)
	build_type = IMPRINTER
	reliability_base = 79
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20, MATERIAL_PLASMA = 3000, MATERIAL_URANIUM = 2000)
	build_path = /obj/item/circuitboard/rust_core