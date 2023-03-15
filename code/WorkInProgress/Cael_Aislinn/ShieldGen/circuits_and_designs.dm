
////////////////////////////////////////
// External Shield Generator

/obj/item/weapon/circuitboard/shield_gen_ex
	name = "circuit board (Experimental hull shield generator)"
	board_type = "machine"
	build_path = /obj/machinery/shield_gen/external
	origin_tech = list(RESEARCH_TECH_BLUESPACE = 4, RESEARCH_TECH_PLASMATECH = 3)
	frame_desc = "Requires 2 Pico Manipulators, 1 Subspace Transmitter, 5 Pieces of cable, 1 Subspace Crystal, 1 Subspace Amplifier and 1 Console Screen."
	req_components = list(
		/obj/item/weapon/stock_part/manipulator/pico = 2,
		/obj/item/weapon/stock_part/subspace/transmitter = 1,
		/obj/item/weapon/stock_part/subspace/crystal = 1,
		/obj/item/weapon/stock_part/subspace/amplifier = 1,
		/obj/item/weapon/stock_part/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

/datum/design/shield_gen_ex
	name = "Circuit Design (Experimental hull shield generator)"
	desc = "Allows for the construction of circuit boards used to build an experimental hull shield generator."
	id = "shield_gen"
	req_tech = list(RESEARCH_TECH_BLUESPACE = 4, RESEARCH_TECH_PLASMATECH = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20, MATERIAL_PLASMA = 10000, MATERIAL_DIAMOND = 5000, MATERIAL_GOLD = 10000)
	build_path = /obj/machinery/shield_gen/external

////////////////////////////////////////
// Shield Generator

/obj/item/weapon/circuitboard/shield_gen
	name = "circuit board (Experimental bubble shield generator)"
	board_type = "machine"
	build_path = /obj/machinery/shield_gen/external
	origin_tech = list(RESEARCH_TECH_BLUESPACE = 4, RESEARCH_TECH_PLASMATECH = 3)
	frame_desc = "Requires 2 Pico Manipulators, 1 Subspace Transmitter, 5 Pieces of cable, 1 Subspace Crystal, 1 Subspace Amplifier and 1 Console Screen."
	req_components = list(
		/obj/item/weapon/stock_part/manipulator/pico = 2,
		/obj/item/weapon/stock_part/subspace/transmitter = 1,
		/obj/item/weapon/stock_part/subspace/crystal = 1,
		/obj/item/weapon/stock_part/subspace/amplifier = 1,
		/obj/item/weapon/stock_part/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

/datum/design/shield_gen
	name = "Circuit Design (Experimental bubble shield generator)"
	desc = "Allows for the construction of circuit boards used to build an experimental shield generator."
	id = "shield_gen"
	req_tech = list(RESEARCH_TECH_BLUESPACE = 4, RESEARCH_TECH_PLASMATECH = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20, MATERIAL_PLASMA = 10000, MATERIAL_DIAMOND = 5000, MATERIAL_GOLD = 10000)
	build_path = /obj/machinery/shield_gen/external

////////////////////////////////////////
// Shield Capacitor

/obj/item/weapon/circuitboard/shield_cap
	name = "circuit board (Experimental shield capacitor)"
	board_type = "machine"
	build_path = /obj/machinery/shield_capacitor
	origin_tech = list(RESEARCH_TECH_MAGNETS = 3, RESEARCH_TECH_POWERSTORAGE = 4)
	frame_desc = "Requires 2 Pico Manipulators, 1 Subspace Filter, 5 Pieces of cable, 1 Subspace Treatment disk, 1 Subspace Analyzer and 1 Console Screen."
	req_components = list(
		/obj/item/weapon/stock_part/manipulator/pico = 2,
		/obj/item/weapon/stock_part/subspace/filter = 1,
		/obj/item/weapon/stock_part/subspace/treatment = 1,
		/obj/item/weapon/stock_part/subspace/analyzer = 1,
		/obj/item/weapon/stock_part/console_screen = 1,
		/obj/item/stack/cable_coil = 5
	)

/datum/design/shield_cap
	name = "Circuit Design (Experimental shield capacitor)"
	desc = "Allows for the construction of circuit boards used to build an experimental shielding capacitor."
	id = "shield_cap"
	req_tech = list(RESEARCH_TECH_MAGNETS = 3, RESEARCH_TECH_POWERSTORAGE = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20, MATERIAL_PLASMA = 10000, MATERIAL_DIAMOND = 5000, MATERIAL_SILVER = 10000)
	build_path = /obj/machinery/shield_gen/external