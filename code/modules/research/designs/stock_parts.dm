/////////////////////////////////
////////// Stock Parts //////////
/////////////////////////////////
/datum/design/stock_part
	desc = "A stock part used in the construction of various devices."
	build_type = DESIGN_TYPE_PROTOLATHE
	name_prefix = "Stock Part Design"

/datum/design/stock_part/basic_capacitor
	name = "Basic Capacitor"
	req_tech = alist(/decl/tech/power_storage = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE
	materials = alist(/decl/material/plastic = 0.25 MATERIAL_SHEETS, /decl/material/glass = 0.25 MATERIAL_SHEETS)
	build_path = /obj/item/stock_part/capacitor

/datum/design/stock_part/basic_scanning_module
	name = "Basic Scanning Module"
	req_tech = alist(/decl/tech/magnets = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE
	materials = alist(/decl/material/plastic = 0.25 MATERIAL_SHEETS, /decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 0.5)
	build_path = /obj/item/stock_part/scanning_module

/datum/design/stock_part/micro_mani
	name = "Micro-Manipulator"
	req_tech = alist(/decl/tech/materials = 1, /decl/tech/programming = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE
	materials = alist(/decl/material/plastic = 0.25 MATERIAL_SHEETS)
	build_path = /obj/item/stock_part/manipulator

/datum/design/stock_part/basic_micro_laser
	name = "Basic Micro-Laser"
	req_tech = alist(/decl/tech/magnets = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE
	materials = alist(/decl/material/plastic = 0.25 MATERIAL_SHEETS, /decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 0.5)
	build_path = /obj/item/stock_part/micro_laser

/datum/design/stock_part/basic_matter_bin
	name = "Basic Matter Bin"
	req_tech = alist(/decl/tech/materials = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE
	materials = alist(/decl/material/plastic = 0.25 MATERIAL_SHEETS)
	build_path = /obj/item/stock_part/matter_bin

/datum/design/stock_part/console_screen
	name = "Console Screen"
	req_tech = alist(/decl/tech/materials = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE
	materials = alist(/decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 0.5)
	build_path = /obj/item/stock_part/console_screen

// Rating 2.
/datum/design/stock_part/adv_capacitor
	name = "Advanced Capacitor"
	req_tech = alist(/decl/tech/power_storage = 3)
	materials = alist(/decl/material/plastic = QUARTER_SHEET_MATERIAL_AMOUNT * 1.5, /decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 1.5)
	build_path = /obj/item/stock_part/capacitor/adv

/datum/design/stock_part/adv_scanning_module
	name = "Advanced Scanning Module"
	req_tech = alist(/decl/tech/magnets = 3)
	materials = alist(/decl/material/plastic = QUARTER_SHEET_MATERIAL_AMOUNT * 1.5, /decl/material/glass = 0.25 MATERIAL_SHEETS)
	build_path = /obj/item/stock_part/scanning_module/adv

/datum/design/stock_part/nano_mani
	name = "Nano-Manipulator"
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/programming = 2)
	materials = alist(/decl/material/plastic = QUARTER_SHEET_MATERIAL_AMOUNT * 1.5)
	build_path = /obj/item/stock_part/manipulator/nano

/datum/design/stock_part/high_micro_laser
	name = "High-Power Micro-Laser"
	req_tech = alist(/decl/tech/magnets = 3)
	materials = alist(/decl/material/plastic = QUARTER_SHEET_MATERIAL_AMOUNT * 1.5, /decl/material/glass = 0.25 MATERIAL_SHEETS)
	build_path = /obj/item/stock_part/micro_laser/high

/datum/design/stock_part/adv_matter_bin
	name = "Advanced Matter Bin"
	req_tech = alist(/decl/tech/materials = 3)
	materials = alist(/decl/material/plastic = QUARTER_SHEET_MATERIAL_AMOUNT * 1.5)
	build_path = /obj/item/stock_part/matter_bin/adv

// Rating 3.
/datum/design/stock_part/super_capacitor
	name = "Super Capacitor"
	req_tech = alist(/decl/tech/materials = 4, /decl/tech/power_storage = 5)
	reliability_base = 71
	materials = alist(/decl/material/plastic = 0.5 MATERIAL_SHEETS, /decl/material/glass = 0.5 MATERIAL_SHEETS, /decl/material/gold = 0.25 MATERIAL_SHEETS)
	build_path = /obj/item/stock_part/capacitor/super

/datum/design/stock_part/phasic_scanning_module
	name = "Phasic Scanning Module"
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/magnets = 5)
	materials = alist(
		/decl/material/plastic = 0.5 MATERIAL_SHEETS, /decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 1.5,
		/decl/material/silver = QUARTER_SHEET_MATERIAL_AMOUNT * 0.6
	)
	reliability_base = 72
	build_path = /obj/item/stock_part/scanning_module/phasic

/datum/design/stock_part/pico_mani
	name = "Pico-Manipulator"
	req_tech = alist(/decl/tech/materials = 5, /decl/tech/programming = 2)
	materials = alist(/decl/material/plastic = 0.5 MATERIAL_SHEETS)
	reliability_base = 73
	build_path = /obj/item/stock_part/manipulator/pico

/datum/design/stock_part/ultra_micro_laser
	name = "Ultra-High-Power Micro-Laser"
	req_tech = alist(/decl/tech/materials = 5, /decl/tech/magnets = 5)
	materials = alist(
		/decl/material/plastic = 0.5 MATERIAL_SHEETS, /decl/material/glass = 0.5 MATERIAL_SHEETS,
		/decl/material/uranium = QUARTER_SHEET_MATERIAL_AMOUNT * 0.6
	)
	reliability_base = 70
	build_path = /obj/item/stock_part/micro_laser/ultra

/datum/design/stock_part/super_matter_bin
	name = "Super Matter Bin"
	req_tech = alist(/decl/tech/materials = 5)
	materials = alist(/decl/material/plastic = 0.5 MATERIAL_SHEETS)
	reliability_base = 75
	build_path = /obj/item/stock_part/matter_bin/super

// Rating 4 -Frenjo.
// Sprited/added unique icons for upgraded capacitors and scanning modules, along with rating 4 parts.
/datum/design/stock_part/hyper_capacitor
	name = "Hyper Capacitor"
	req_tech = alist(/decl/tech/materials = 4, /decl/tech/power_storage = 7)
	reliability_base = 71
	materials = alist(
		/decl/material/plastic = 0.5 MATERIAL_SHEETS, /decl/material/glass = 0.5 MATERIAL_SHEETS,
		/decl/material/silver = 0.25 MATERIAL_SHEETS, /decl/material/gold = 0.25 MATERIAL_SHEETS
	)
	build_path = /obj/item/stock_part/capacitor/hyper

/datum/design/stock_part/hyperphasic_scanning_module
	name = "Hyper-Phasic Scanning Module"
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/magnets = 7)
	materials = alist(
		/decl/material/plastic = 0.5 MATERIAL_SHEETS, /decl/material/glass = 0.5 MATERIAL_SHEETS,
		/decl/material/silver = QUARTER_SHEET_MATERIAL_AMOUNT * 0.3, /decl/material/gold = QUARTER_SHEET_MATERIAL_AMOUNT * 0.5
	)
	reliability_base = 72
	build_path = /obj/item/stock_part/scanning_module/hyperphasic

/datum/design/stock_part/femto_mani
	name = "Femto-Manipulator"
	req_tech = alist(/decl/tech/materials = 7, /decl/tech/programming = 2)
	materials = alist(
		/decl/material/plastic = 0.5 MATERIAL_SHEETS, /decl/material/silver = QUARTER_SHEET_MATERIAL_AMOUNT * 0.3,
		/decl/material/gold = QUARTER_SHEET_MATERIAL_AMOUNT * 0.3
	)
	reliability_base = 73
	build_path = /obj/item/stock_part/manipulator/femto

/datum/design/stock_part/hyper_ultra_micro_laser
	name = "Hyper-Ultra-High-Power Micro-Laser"
	req_tech = alist(/decl/tech/materials = 5, /decl/tech/magnets = 7)
	materials = alist(
		/decl/material/plastic = 0.5 MATERIAL_SHEETS, /decl/material/glass = 0.5 MATERIAL_SHEETS,
		/decl/material/uranium = 0.25 MATERIAL_SHEETS, /decl/material/plasma = QUARTER_SHEET_MATERIAL_AMOUNT * 0.6
	)
	reliability_base = 70
	build_path = /obj/item/stock_part/micro_laser/hyperultra

/datum/design/stock_part/hyper_matter_bin
	name = "Hyper Matter Bin"
	req_tech = alist(/decl/tech/materials = 7)
	materials = alist(/decl/material/plastic = HALF_SHEET_MATERIAL_AMOUNT * 1.5)
	reliability_base = 75
	build_path = /obj/item/stock_part/matter_bin/hyper

//////////////////////////////
////////// Subspace //////////
//////////////////////////////
/datum/design/stock_part/subspace_ansible
	name = "Subspace Ansible"
	desc = "A compact module capable of sensing extradimensional activity."
	req_tech = alist(/decl/tech/materials = 4, /decl/tech/magnets = 5, /decl/tech/programming = 3, /decl/tech/bluespace = 2)
	materials = alist(/decl/material/plastic = QUARTER_SHEET_MATERIAL_AMOUNT * 0.8, /decl/material/silver = QUARTER_SHEET_MATERIAL_AMOUNT * 0.2)
	build_path = /obj/item/stock_part/subspace_ansible

/datum/design/stock_part/hyperwave_filter
	name = "Hyperwave Filter"
	desc = "A tiny device capable of filtering and converting super-intense radiowaves."
	req_tech = alist(/decl/tech/magnets = 3, /decl/tech/programming = 3)
	materials = alist(/decl/material/plastic = QUARTER_SHEET_MATERIAL_AMOUNT * 0.4, /decl/material/silver = QUARTER_SHEET_MATERIAL_AMOUNT * 0.1)
	build_path = /obj/item/stock_part/subspace_filter

/datum/design/stock_part/subspace_amplifier
	name = "Subspace Amplifier"
	desc = "A compact micro-machine capable of amplifying weak subspace transmissions."
	req_tech = alist(/decl/tech/materials = 4, /decl/tech/magnets = 4, /decl/tech/programming = 3, /decl/tech/bluespace = 2)
	materials = alist(
		/decl/material/plastic = QUARTER_SHEET_MATERIAL_AMOUNT * 0.1, /decl/material/gold = QUARTER_SHEET_MATERIAL_AMOUNT * 0.3,
		/decl/material/uranium = QUARTER_SHEET_MATERIAL_AMOUNT * 0.15
	)
	build_path = /obj/item/stock_part/subspace_amplifier

/datum/design/stock_part/subspace_treatment
	name = "Subspace Treatment Disk"
	desc = "A compact micro-machine capable of stretching out hyper-compressed radio waves."
	req_tech = alist(/decl/tech/materials = 4, /decl/tech/magnets = 2, /decl/tech/programming = 3, /decl/tech/bluespace = 2)
	materials = alist(/decl/material/plastic = QUARTER_SHEET_MATERIAL_AMOUNT * 0.1, /decl/material/silver = QUARTER_SHEET_MATERIAL_AMOUNT * 0.2)
	build_path = /obj/item/stock_part/subspace_treatment

/datum/design/stock_part/subspace_analyser
	name = "Subspace Analyser"
	desc = "A sophisticated analyser capable of analyzing cryptic subspace wavelengths."
	req_tech = alist(/decl/tech/materials = 4, /decl/tech/magnets = 4, /decl/tech/programming = 3, /decl/tech/bluespace = 2)
	materials = alist(/decl/material/plastic = QUARTER_SHEET_MATERIAL_AMOUNT * 0.1, /decl/material/gold = QUARTER_SHEET_MATERIAL_AMOUNT * 0.15)
	build_path = /obj/item/stock_part/subspace_analyser

/datum/design/stock_part/ansible_crystal
	name = "Ansible Crystal"
	desc = "A crystal made from pure glass used to transmit laser databursts to subspace."
	req_tech = alist(/decl/tech/materials = 4, /decl/tech/magnets = 4, /decl/tech/bluespace = 2)
	materials = alist(
		/decl/material/glass = HALF_SHEET_MATERIAL_AMOUNT * 0.5, /decl/material/silver = HALF_SHEET_MATERIAL_AMOUNT * 0.25,
		/decl/material/gold = HALF_SHEET_MATERIAL_AMOUNT * 0.25
	)
	build_path = /obj/item/stock_part/subspace_crystal

/datum/design/stock_part/subspace_transmitter
	name = "Subspace Transmitter"
	desc = "A large piece of equipment used to open a window into the subspace dimension."
	req_tech = alist(/decl/tech/materials = 5, /decl/tech/magnets = 5, /decl/tech/bluespace = 3)
	materials = alist(
		/decl/material/glass = HALF_SHEET_MATERIAL_AMOUNT * 0.1, /decl/material/silver = QUARTER_SHEET_MATERIAL_AMOUNT * 0.1,
		/decl/material/uranium = QUARTER_SHEET_MATERIAL_AMOUNT * 0.15
	)
	build_path = /obj/item/stock_part/subspace_transmitter

///////////////////////////
////////// Power //////////
///////////////////////////
/datum/design/power_cell
	name_prefix = "Power Cell Design"

/datum/design/power_cell/basic
	name = "Basic"
	desc = "A power cell that holds 1000 units of energy."
	req_tech = alist(/decl/tech/power_storage = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE | DESIGN_TYPE_ROBOFAB | DESIGN_TYPE_MECHFAB
	materials = alist(/decl/material/steel = 1.75 MATERIAL_SHEETS, /decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 0.5)
	build_path = /obj/item/cell
	categories = list("Power Cells")

/datum/design/power_cell/high
	name = "High-Capacity"
	desc = "A power cell that holds 10000 units of energy."
	req_tech = alist(/decl/tech/power_storage = 2)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE | DESIGN_TYPE_ROBOFAB | DESIGN_TYPE_MECHFAB
	materials = alist(/decl/material/steel = 1.75 MATERIAL_SHEETS, /decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 0.6)
	build_path = /obj/item/cell/high
	categories = list("Power Cells")

/datum/design/power_cell/super
	name = "Super-Capacity"
	desc = "A power cell that holds 20000 units of energy."
	req_tech = alist(/decl/tech/materials = 2, /decl/tech/power_storage = 3)
	reliability_base = 75
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_ROBOFAB | DESIGN_TYPE_MECHFAB
	materials = alist(
		/decl/material/steel = 1.75 MATERIAL_SHEETS, /decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 0.7,
		/decl/material/silver = 0.25 MATERIAL_SHEETS
	)
	build_path = /obj/item/cell/super
	categories = list("Power Cells")

/datum/design/power_cell/hyper
	name = "Hyper-Capacity"
	desc = "A power cell that holds 30000 units of energy."
	req_tech = alist(/decl/tech/materials = 4, /decl/tech/power_storage = 5)
	reliability_base = 70
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_ROBOFAB | DESIGN_TYPE_MECHFAB
	materials = alist(
		/decl/material/steel = 1.75 MATERIAL_SHEETS, /decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 0.8,
		/decl/material/silver = QUARTER_SHEET_MATERIAL_AMOUNT * 1.5, /decl/material/gold = QUARTER_SHEET_MATERIAL_AMOUNT * 1.5
	)
	build_path = /obj/item/cell/hyper
	categories = list("Power Cells")