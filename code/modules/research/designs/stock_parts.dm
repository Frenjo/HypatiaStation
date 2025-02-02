/////////////////////////////////
////////// Stock Parts //////////
/////////////////////////////////
/datum/design/basic_capacitor
	name = "Basic Capacitor"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/decl/tech/power_storage = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/stock_part/capacitor

/datum/design/basic_scanning_module
	name = "Basic Scanning Module"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/decl/tech/magnets = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 20)
	build_path = /obj/item/stock_part/scanning_module

/datum/design/micro_mani
	name = "Micro Manipulator"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/decl/tech/materials = 1, /decl/tech/programming = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE
	materials = list(MATERIAL_METAL = 30)
	build_path = /obj/item/stock_part/manipulator

/datum/design/basic_micro_laser
	name = "Basic Micro-Laser"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/decl/tech/magnets = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE
	materials = list(MATERIAL_METAL = 10, /decl/material/glass = 20)
	build_path = /obj/item/stock_part/micro_laser

/datum/design/basic_matter_bin
	name = "Basic Matter Bin"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/decl/tech/materials = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE
	materials = list(MATERIAL_METAL = 80)
	build_path = /obj/item/stock_part/matter_bin

/datum/design/adv_capacitor
	name = "Advanced Capacitor"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/decl/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/stock_part/capacitor/adv

/datum/design/adv_scanning_module
	name = "Advanced Scanning Module"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/decl/tech/magnets = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 20)
	build_path = /obj/item/stock_part/scanning_module/adv

/datum/design/nano_mani
	name = "Nano Manipulator"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/decl/tech/materials = 3, /decl/tech/programming = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 30)
	build_path = /obj/item/stock_part/manipulator/nano

/datum/design/high_micro_laser
	name = "High-Power Micro-Laser"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/decl/tech/magnets = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 10, /decl/material/glass = 20)
	build_path = /obj/item/stock_part/micro_laser/high

/datum/design/adv_matter_bin
	name = "Advanced Matter Bin"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/decl/tech/materials = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 80)
	build_path = /obj/item/stock_part/matter_bin/adv

/datum/design/super_capacitor
	name = "Super Capacitor"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/power_storage = 5)
	build_type = DESIGN_TYPE_PROTOLATHE
	reliability_base = 71
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50, /decl/material/gold = 20)
	build_path = /obj/item/stock_part/capacitor/super

/datum/design/phasic_scanning_module
	name = "Phasic Scanning Module"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/decl/tech/materials = 3, /decl/tech/magnets = 5)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 20, /decl/material/silver = 10)
	reliability_base = 72
	build_path = /obj/item/stock_part/scanning_module/phasic

/datum/design/pico_mani
	name = "Pico Manipulator"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/decl/tech/materials = 5, /decl/tech/programming = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 30)
	reliability_base = 73
	build_path = /obj/item/stock_part/manipulator/pico

/datum/design/ultra_micro_laser
	name = "Ultra-High-Power Micro-Laser"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/decl/tech/materials = 5, /decl/tech/magnets = 5)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 10, /decl/material/glass = 20, /decl/material/uranium = 10)
	reliability_base = 70
	build_path = /obj/item/stock_part/micro_laser/ultra

/datum/design/super_matter_bin
	name = "Super Matter Bin"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/decl/tech/materials = 5)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 80)
	reliability_base = 75
	build_path = /obj/item/stock_part/matter_bin/super

// Rating 4 -Frenjo.
/datum/design/hyper_capacitor
	name = "Hyper Capacitor"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/power_storage = 7)
	build_type = DESIGN_TYPE_PROTOLATHE
	reliability_base = 71
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50, /decl/material/silver = 20, /decl/material/gold = 20)
	build_path = /obj/item/stock_part/capacitor/hyper

/datum/design/hyperphasic_scanning_module
	name = "Hyper-Phasic Scanning Module"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/decl/tech/materials = 3, /decl/tech/magnets = 7)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 20, /decl/material/silver = 10, /decl/material/gold = 10)
	reliability_base = 72
	build_path = /obj/item/stock_part/scanning_module/hyperphasic

/datum/design/femto_mani
	name = "Femto Manipulator"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/decl/tech/materials = 7, /decl/tech/programming = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 30)
	reliability_base = 73
	build_path = /obj/item/stock_part/manipulator/femto

/datum/design/hyper_ultra_micro_laser
	name = "Hyper-Ultra-High-Power Micro-Laser"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/decl/tech/materials = 5, /decl/tech/magnets = 7)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 10, /decl/material/glass = 20, /decl/material/uranium = 10, /decl/material/plasma = 10)
	reliability_base = 70
	build_path = /obj/item/stock_part/micro_laser/hyperultra

/datum/design/hyper_matter_bin
	name = "Hyper Matter Bin"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/decl/tech/materials = 7)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 80)
	reliability_base = 75
	build_path = /obj/item/stock_part/matter_bin/hyper

//////////////////////////////
////////// Subspace //////////
//////////////////////////////
/datum/design/subspace_ansible
	name = "Subspace Ansible"
	desc = "A compact module capable of sensing extradimensional activity."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/magnets = 4, /decl/tech/programming = 3, /decl/tech/bluespace = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 80, /decl/material/silver = 20)
	build_path = /obj/item/stock_part/subspace/ansible

/datum/design/hyperwave_filter
	name = "Hyperwave Filter"
	desc = "A tiny device capable of filtering and converting super-intense radiowaves."
	req_tech = list(/decl/tech/magnets = 3, /decl/tech/programming = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 40, /decl/material/silver = 10)
	build_path = /obj/item/stock_part/subspace/filter

/datum/design/subspace_amplifier
	name = "Subspace Amplifier"
	desc = "A compact micro-machine capable of amplifying weak subspace transmissions."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/magnets = 4, /decl/tech/programming = 3, /decl/tech/bluespace = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 10, /decl/material/gold = 30, /decl/material/uranium = 15)
	build_path = /obj/item/stock_part/subspace/amplifier

/datum/design/subspace_treatment
	name = "Subspace Treatment Disk"
	desc = "A compact micro-machine capable of stretching out hyper-compressed radio waves."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/magnets = 2, /decl/tech/programming = 3, /decl/tech/bluespace = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 10, /decl/material/silver = 20)
	build_path = /obj/item/stock_part/subspace/treatment

/datum/design/subspace_analyser
	name = "Subspace Analyser"
	desc = "A sophisticated analyser capable of analyzing cryptic subspace wavelengths."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/magnets = 4, /decl/tech/programming = 3, /decl/tech/bluespace = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 10, /decl/material/gold = 15)
	build_path = /obj/item/stock_part/subspace/analyser

/datum/design/subspace_crystal
	name = "Ansible Crystal"
	desc = "A sophisticated analyser capable of analyzing cryptic subspace wavelengths."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/magnets = 4, /decl/tech/bluespace = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(/decl/material/glass = 1000, /decl/material/silver = 20, /decl/material/gold = 20)
	build_path = /obj/item/stock_part/subspace/crystal

/datum/design/subspace_transmitter
	name = "Subspace Transmitter"
	desc = "A large piece of equipment used to open a window into the subspace dimension."
	req_tech = list(/decl/tech/materials = 5, /decl/tech/magnets = 5, /decl/tech/bluespace = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(/decl/material/glass = 100, /decl/material/silver = 10, /decl/material/uranium = 15)
	build_path = /obj/item/stock_part/subspace/transmitter

///////////////////////////
////////// Power //////////
///////////////////////////
/datum/design/basic_cell
	name = "Basic Power Cell"
	desc = "A basic power cell that holds 1000 units of energy"
	req_tech = list(/decl/tech/power_storage = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE | DESIGN_TYPE_ROBOFAB | DESIGN_TYPE_MECHFAB
	materials = list(MATERIAL_METAL = 750, /decl/material/glass = 50)
	build_path = /obj/item/cell
	categories = list("Power Cells")

/datum/design/high_cell
	name = "High-Capacity Power Cell"
	desc = "A power cell that holds 10000 units of energy"
	req_tech = list(/decl/tech/power_storage = 2)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE | DESIGN_TYPE_ROBOFAB | DESIGN_TYPE_MECHFAB
	materials = list(MATERIAL_METAL = 750, /decl/material/glass = 60)
	build_path = /obj/item/cell/high
	categories = list("Power Cells")

/datum/design/super_cell
	name = "Super-Capacity Power Cell"
	desc = "A power cell that holds 20000 units of energy"
	req_tech = list(/decl/tech/materials = 2, /decl/tech/power_storage = 3)
	reliability_base = 75
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_ROBOFAB | DESIGN_TYPE_MECHFAB
	materials = list(MATERIAL_METAL = 750, /decl/material/glass = 70, /decl/material/silver = 100)
	build_path = /obj/item/cell/super
	categories = list("Power Cells")

/datum/design/hyper_cell
	name = "Hyper-Capacity Power Cell"
	desc = "A power cell that holds 30000 units of energy"
	req_tech = list(/decl/tech/materials = 4, /decl/tech/power_storage = 5)
	reliability_base = 70
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_ROBOFAB | DESIGN_TYPE_MECHFAB
	materials = list(MATERIAL_METAL = 750, /decl/material/glass = 80, /decl/material/silver = 200, /decl/material/gold = 200)
	build_path = /obj/item/cell/hyper
	categories = list("Power Cells")