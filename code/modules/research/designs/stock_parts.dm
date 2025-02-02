/////////////////////////////////
////////// Stock Parts //////////
/////////////////////////////////
/datum/design/stock_part
	desc = "A stock part used in the construction of various devices."
	build_type = DESIGN_TYPE_PROTOLATHE
	name_prefix = "Stock Part Design"

/datum/design/stock_part/basic_capacitor
	name = "Basic Capacitor"
	req_tech = list(/decl/tech/power_storage = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/stock_part/capacitor

/datum/design/stock_part/basic_scanning_module
	name = "Basic Scanning Module"
	req_tech = list(/decl/tech/magnets = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 20)
	build_path = /obj/item/stock_part/scanning_module

/datum/design/stock_part/micro_mani
	name = "Micro-Manipulator"
	req_tech = list(/decl/tech/materials = 1, /decl/tech/programming = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE
	materials = list(MATERIAL_METAL = 30)
	build_path = /obj/item/stock_part/manipulator

/datum/design/stock_part/basic_micro_laser
	name = "Basic Micro-Laser"
	req_tech = list(/decl/tech/magnets = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE
	materials = list(MATERIAL_METAL = 10, /decl/material/glass = 20)
	build_path = /obj/item/stock_part/micro_laser

/datum/design/stock_part/basic_matter_bin
	name = "Basic Matter Bin"
	req_tech = list(/decl/tech/materials = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE
	materials = list(MATERIAL_METAL = 80)
	build_path = /obj/item/stock_part/matter_bin

/datum/design/stock_part/adv_capacitor
	name = "Advanced Capacitor"
	req_tech = list(/decl/tech/power_storage = 3)
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/stock_part/capacitor/adv

/datum/design/stock_part/adv_scanning_module
	name = "Advanced Scanning Module"
	req_tech = list(/decl/tech/magnets = 3)
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 20)
	build_path = /obj/item/stock_part/scanning_module/adv

/datum/design/stock_part/nano_mani
	name = "Nano-Manipulator"
	req_tech = list(/decl/tech/materials = 3, /decl/tech/programming = 2)
	materials = list(MATERIAL_METAL = 30)
	build_path = /obj/item/stock_part/manipulator/nano

/datum/design/stock_part/high_micro_laser
	name = "High-Power Micro-Laser"
	req_tech = list(/decl/tech/magnets = 3)
	materials = list(MATERIAL_METAL = 10, /decl/material/glass = 20)
	build_path = /obj/item/stock_part/micro_laser/high

/datum/design/stock_part/adv_matter_bin
	name = "Advanced Matter Bin"
	req_tech = list(/decl/tech/materials = 3)
	materials = list(MATERIAL_METAL = 80)
	build_path = /obj/item/stock_part/matter_bin/adv

/datum/design/stock_part/super_capacitor
	name = "Super Capacitor"
	req_tech = list(/decl/tech/materials = 4, /decl/tech/power_storage = 5)
	reliability_base = 71
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50, /decl/material/gold = 20)
	build_path = /obj/item/stock_part/capacitor/super

/datum/design/stock_part/phasic_scanning_module
	name = "Phasic Scanning Module"
	req_tech = list(/decl/tech/materials = 3, /decl/tech/magnets = 5)
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 20, /decl/material/silver = 10)
	reliability_base = 72
	build_path = /obj/item/stock_part/scanning_module/phasic

/datum/design/stock_part/pico_mani
	name = "Pico-Manipulator"
	req_tech = list(/decl/tech/materials = 5, /decl/tech/programming = 2)
	materials = list(MATERIAL_METAL = 30)
	reliability_base = 73
	build_path = /obj/item/stock_part/manipulator/pico

/datum/design/stock_part/ultra_micro_laser
	name = "Ultra-High-Power Micro-Laser"
	req_tech = list(/decl/tech/materials = 5, /decl/tech/magnets = 5)
	materials = list(MATERIAL_METAL = 10, /decl/material/glass = 20, /decl/material/uranium = 10)
	reliability_base = 70
	build_path = /obj/item/stock_part/micro_laser/ultra

/datum/design/stock_part/super_matter_bin
	name = "Super Matter Bin"
	req_tech = list(/decl/tech/materials = 5)
	materials = list(MATERIAL_METAL = 80)
	reliability_base = 75
	build_path = /obj/item/stock_part/matter_bin/super

// Rating 4 -Frenjo.
/datum/design/stock_part/hyper_capacitor
	name = "Hyper Capacitor"
	req_tech = list(/decl/tech/materials = 4, /decl/tech/power_storage = 7)
	reliability_base = 71
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50, /decl/material/silver = 20, /decl/material/gold = 20)
	build_path = /obj/item/stock_part/capacitor/hyper

/datum/design/stock_part/hyperphasic_scanning_module
	name = "Hyper-Phasic Scanning Module"
	req_tech = list(/decl/tech/materials = 3, /decl/tech/magnets = 7)
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 20, /decl/material/silver = 10, /decl/material/gold = 10)
	reliability_base = 72
	build_path = /obj/item/stock_part/scanning_module/hyperphasic

/datum/design/stock_part/femto_mani
	name = "Femto-Manipulator"
	req_tech = list(/decl/tech/materials = 7, /decl/tech/programming = 2)
	materials = list(MATERIAL_METAL = 30)
	reliability_base = 73
	build_path = /obj/item/stock_part/manipulator/femto

/datum/design/stock_part/hyper_ultra_micro_laser
	name = "Hyper-Ultra-High-Power Micro-Laser"
	req_tech = list(/decl/tech/materials = 5, /decl/tech/magnets = 7)
	materials = list(MATERIAL_METAL = 10, /decl/material/glass = 20, /decl/material/uranium = 10, /decl/material/plasma = 10)
	reliability_base = 70
	build_path = /obj/item/stock_part/micro_laser/hyperultra

/datum/design/stock_part/hyper_matter_bin
	name = "Hyper Matter Bin"
	req_tech = list(/decl/tech/materials = 7)
	materials = list(MATERIAL_METAL = 80)
	reliability_base = 75
	build_path = /obj/item/stock_part/matter_bin/hyper

//////////////////////////////
////////// Subspace //////////
//////////////////////////////
/datum/design/stock_part/subspace_ansible
	name = "Subspace Ansible"
	desc = "A compact module capable of sensing extradimensional activity."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/magnets = 4, /decl/tech/programming = 3, /decl/tech/bluespace = 2)
	materials = list(MATERIAL_METAL = 80, /decl/material/silver = 20)
	build_path = /obj/item/stock_part/subspace/ansible

/datum/design/stock_part/hyperwave_filter
	name = "Hyperwave Filter"
	desc = "A tiny device capable of filtering and converting super-intense radiowaves."
	req_tech = list(/decl/tech/magnets = 3, /decl/tech/programming = 3)
	materials = list(MATERIAL_METAL = 40, /decl/material/silver = 10)
	build_path = /obj/item/stock_part/subspace/filter

/datum/design/stock_part/subspace_amplifier
	name = "Subspace Amplifier"
	desc = "A compact micro-machine capable of amplifying weak subspace transmissions."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/magnets = 4, /decl/tech/programming = 3, /decl/tech/bluespace = 2)
	materials = list(MATERIAL_METAL = 10, /decl/material/gold = 30, /decl/material/uranium = 15)
	build_path = /obj/item/stock_part/subspace/amplifier

/datum/design/stock_part/subspace_treatment
	name = "Subspace Treatment Disk"
	desc = "A compact micro-machine capable of stretching out hyper-compressed radio waves."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/magnets = 2, /decl/tech/programming = 3, /decl/tech/bluespace = 2)
	materials = list(MATERIAL_METAL = 10, /decl/material/silver = 20)
	build_path = /obj/item/stock_part/subspace/treatment

/datum/design/stock_part/subspace_analyser
	name = "Subspace Analyser"
	desc = "A sophisticated analyser capable of analyzing cryptic subspace wavelengths."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/magnets = 4, /decl/tech/programming = 3, /decl/tech/bluespace = 2)
	materials = list(MATERIAL_METAL = 10, /decl/material/gold = 15)
	build_path = /obj/item/stock_part/subspace/analyser

/datum/design/stock_part/ansible_crystal
	name = "Ansible Crystal"
	desc = "A sophisticated analyser capable of analyzing cryptic subspace wavelengths."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/magnets = 4, /decl/tech/bluespace = 2)
	materials = list(/decl/material/glass = 1000, /decl/material/silver = 20, /decl/material/gold = 20)
	build_path = /obj/item/stock_part/subspace/crystal

/datum/design/stock_part/subspace_transmitter
	name = "Subspace Transmitter"
	desc = "A large piece of equipment used to open a window into the subspace dimension."
	req_tech = list(/decl/tech/materials = 5, /decl/tech/magnets = 5, /decl/tech/bluespace = 3)
	materials = list(/decl/material/glass = 100, /decl/material/silver = 10, /decl/material/uranium = 15)
	build_path = /obj/item/stock_part/subspace/transmitter

///////////////////////////
////////// Power //////////
///////////////////////////
/datum/design/power_cell
	name_prefix = "Power Cell Design"

/datum/design/power_cell/basic_cell
	name = "Basic"
	desc = "A power cell that holds 1000 units of energy."
	req_tech = list(/decl/tech/power_storage = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE | DESIGN_TYPE_ROBOFAB | DESIGN_TYPE_MECHFAB
	materials = list(MATERIAL_METAL = 750, /decl/material/glass = 50)
	build_path = /obj/item/cell
	categories = list("Power Cells")

/datum/design/power_cell/high_cell
	name = "High-Capacity"
	desc = "A power cell that holds 10000 units of energy."
	req_tech = list(/decl/tech/power_storage = 2)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE | DESIGN_TYPE_ROBOFAB | DESIGN_TYPE_MECHFAB
	materials = list(MATERIAL_METAL = 750, /decl/material/glass = 60)
	build_path = /obj/item/cell/high
	categories = list("Power Cells")

/datum/design/power_cell/super_cell
	name = "Super-Capacity"
	desc = "A power cell that holds 20000 units of energy."
	req_tech = list(/decl/tech/materials = 2, /decl/tech/power_storage = 3)
	reliability_base = 75
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_ROBOFAB | DESIGN_TYPE_MECHFAB
	materials = list(MATERIAL_METAL = 750, /decl/material/glass = 70, /decl/material/silver = 100)
	build_path = /obj/item/cell/super
	categories = list("Power Cells")

/datum/design/power_cell/hyper_cell
	name = "Hyper-Capacity"
	desc = "A power cell that holds 30000 units of energy."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/power_storage = 5)
	reliability_base = 70
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_ROBOFAB | DESIGN_TYPE_MECHFAB
	materials = list(MATERIAL_METAL = 750, /decl/material/glass = 80, /decl/material/silver = 200, /decl/material/gold = 200)
	build_path = /obj/item/cell/hyper
	categories = list("Power Cells")