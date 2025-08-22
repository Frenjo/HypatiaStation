/////////////////////////////////////
////////// Mecha Equipment //////////
/////////////////////////////////////
/datum/design/mechfab/equipment
	name_prefix = "Exosuit Module Design"

// General
/datum/design/mechfab/equipment/general
	categories = list("General Exosuit Equipment")

/datum/design/mechfab/equipment/general/tracking
	materials = alist(/decl/material/plastic = 2.5 MATERIAL_SHEETS)
	build_time = 5 SECONDS
	build_path = /obj/item/mecha_part/tracking

/datum/design/mechfab/equipment/general/passenger_compartment
	req_tech = alist(/decl/tech/materials = 1, /decl/tech/biotech = 1, /decl/tech/engineering = 1)
	materials = alist(
		/decl/material/steel = 3 MATERIAL_SHEETS, /decl/material/plastic = 3 MATERIAL_SHEETS,
		/decl/material/glass = 3 MATERIAL_SHEETS
	)
	build_path = /obj/item/mecha_equipment/passenger

/*
/datum/design/mechfab/equipment/general/jetpack
	build_path = /obj/item/mecha_equipment/jetpack
*/

/datum/design/mechfab/equipment/general/wormhole_gen
	name = "Wormhole Generator"
	desc = "An exosuit module that allows the generation of small quasi-stable wormholes."
	req_tech = alist(/decl/tech/magnets = 2, /decl/tech/bluespace = 3)
	materials = alist(/decl/material/steel = 5 MATERIAL_SHEETS, /decl/material/diamond = 3 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_equipment/wormhole_generator

/datum/design/mechfab/equipment/general/teleporter
	name = "Teleporter"
	desc = "An exosuit module that allows teleportation to any position in view."
	req_tech = alist(/decl/tech/magnets = 5, /decl/tech/bluespace = 10)
	materials = alist(/decl/material/steel = 5 MATERIAL_SHEETS, /decl/material/diamond = 5 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_equipment/teleporter

/datum/design/mechfab/equipment/general/gravcatapult
	name = "Gravitational Catapult"
	desc = "An exosuit mounted gravitational catapult."
	req_tech = alist(/decl/tech/magnets = 3, /decl/tech/engineering = 3, /decl/tech/bluespace = 2)
	materials = alist(/decl/material/steel = 5 MATERIAL_SHEETS, /decl/material/plasma = 3 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_equipment/gravcatapult

/datum/design/mechfab/equipment/general/repair_droid
	name = "Repair Droid"
	desc = "An automated exosuit repair droid. BEEP BOOP!"
	req_tech = alist(/decl/tech/magnets = 3, /decl/tech/engineering = 3, /decl/tech/programming = 3)
	materials = alist(
		/decl/material/steel = 5 MATERIAL_SHEETS, /decl/material/glass = 3 MATERIAL_SHEETS,
		/decl/material/silver = 2 MATERIAL_SHEETS, /decl/material/gold = 1 MATERIAL_SHEET
	)
	build_path = /obj/item/mecha_equipment/repair_droid

/datum/design/mechfab/equipment/general/linear_shield_droid
	name = "Linear Shield Droid"
	desc = "An automated exosuit shield droid. Deploys a large, familiar, and rectangular shield in one direction at a time. BEEP BOOP!"
	req_tech = alist(/decl/tech/magnets = 6, /decl/tech/plasma = 3, /decl/tech/syndicate = 4)
	materials = alist(
		/decl/material/steel = 5 MATERIAL_SHEETS, /decl/material/glass = 3 MATERIAL_SHEETS,
		/decl/material/silver = 2 MATERIAL_SHEETS, /decl/material/gold = 1 MATERIAL_SHEET,
		/decl/material/plasma = 3 MATERIAL_SHEETS
	)
	build_path = /obj/item/mecha_equipment/shield_droid/linear

/datum/design/mechfab/equipment/general/omnidirectional_shield_droid
	name = "Omnidirectional Shield Droid"
	desc = "An automated exosuit shield droid. Deploys a small, but familiar, and rectangular shield that surrounds an exosuit. BEEP BOOP!"
	req_tech = alist(/decl/tech/magnets = 6, /decl/tech/plasma = 6, /decl/tech/syndicate = 6)
	materials = alist(
		/decl/material/steel = 6 MATERIAL_SHEETS, /decl/material/glass = 4 MATERIAL_SHEETS,
		/decl/material/silver = 3 MATERIAL_SHEETS, /decl/material/gold = 2 MATERIAL_SHEETS,
		/decl/material/plasma = 4 MATERIAL_SHEETS
	)
	build_path = /obj/item/mecha_equipment/shield_droid/omnidirectional

/datum/design/mechfab/equipment/general/energy_relay
	name = "Tesla Energy Relay"
	desc = "An exosuit-mounted energy relay that allows wireless charging from nearby APCs. It isn't very good, though..."
	req_tech = alist(/decl/tech/magnets = 4, /decl/tech/power_storage = 3)
	materials = alist(
		/decl/material/steel = 5 MATERIAL_SHEETS, /decl/material/glass = 1 MATERIAL_SHEET,
		/decl/material/silver = 1.5 MATERIAL_SHEETS, /decl/material/gold = 1 MATERIAL_SHEET
	)
	build_path = /obj/item/mecha_equipment/tesla_energy_relay

/datum/design/mechfab/equipment/general/plasma_generator
	name = "Plasma Converter"
	desc = "An exosuit-mounted plasma converter module."
	req_tech = alist(/decl/tech/engineering = 2, /decl/tech/power_storage = 2, /decl/tech/plasma = 2)
	materials = alist(
		/decl/material/steel = 5 MATERIAL_SHEETS, /decl/material/glass = 1.5 MATERIAL_SHEETS,
		/decl/material/silver = 1.25 MATERIAL_SHEETS
	)
	build_path = /obj/item/mecha_equipment/generator

/datum/design/mechfab/equipment/general/nuclear_generator
	name = "ExoNuclear Reactor"
	desc = "An exosuit-mounted compact nuclear reactor module."
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/engineering = 3, /decl/tech/power_storage = 3)
	materials = alist(
		/decl/material/steel = 5 MATERIAL_SHEETS, /decl/material/glass = 1.5 MATERIAL_SHEETS,
		/decl/material/silver = 1.25 MATERIAL_SHEETS
	)
	build_path = /obj/item/mecha_equipment/generator/nuclear

// Working
/datum/design/mechfab/equipment/working
	categories = list("Working Exosuit Equipment")

/datum/design/mechfab/equipment/working/hydraulic_clamp
	materials = alist(/decl/material/steel = 5 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_equipment/tool/hydraulic_clamp

/datum/design/mechfab/equipment/working/drill
	materials = alist(/decl/material/steel = 5 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_equipment/tool/drill

/datum/design/mechfab/equipment/working/extinguisher
	materials = alist(/decl/material/steel = 5 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_equipment/tool/extinguisher

/datum/design/mechfab/equipment/working/cable_layer
	materials = alist(/decl/material/steel = 5 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_equipment/tool/cable_layer

/datum/design/mechfab/equipment/working/rcd
	name = "RCD Module"
	desc = "An exosuit-mounted rapid-construction-device."
	req_tech = alist(
		/decl/tech/materials = 4, /decl/tech/magnets = 4, /decl/tech/engineering = 4,
		/decl/tech/power_storage = 4, /decl/tech/bluespace = 3
	)
	materials = alist(
		/decl/material/steel = 15 MATERIAL_SHEETS, /decl/material/silver = 10 MATERIAL_SHEETS,
		/decl/material/gold = 10 MATERIAL_SHEETS, /decl/material/plasma = 12.5 MATERIAL_SHEETS
	)
	build_time = 2 MINUTES
	build_path = /obj/item/mecha_equipment/tool/rcd

/datum/design/mechfab/equipment/working/mrcd
	name = "MRCD"
	desc = "An exosuit-mounted mime-rapid-construction-device."
	req_tech = alist(
		/decl/tech/materials = 4, /decl/tech/magnets = 4, /decl/tech/engineering = 4,
		/decl/tech/power_storage = 4, /decl/tech/bluespace = 3
	)
	materials = alist(
		/decl/material/steel = 15 MATERIAL_SHEETS, /decl/material/silver = 10 MATERIAL_SHEETS,
		/decl/material/gold = 10 MATERIAL_SHEETS, /decl/material/plasma = 12.5 MATERIAL_SHEETS,
		/decl/material/tranquilite = 5 MATERIAL_SHEETS
	)
	build_time = 2 MINUTES
	build_path = /obj/item/mecha_equipment/tool/mimercd

/datum/design/mechfab/equipment/working/diamond_drill
	name = "Diamond Mining Drill"
	desc = "An upgraded version of the standard exosuit drill."
	req_tech = alist(/decl/tech/materials = 4, /decl/tech/engineering = 3)
	materials = alist(/decl/material/steel = 5 MATERIAL_SHEETS, /decl/material/diamond = 3.25 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_equipment/tool/drill/diamond

/datum/design/mechfab/equipment/working/cleaner_grenade_launcher
	name = "CCL-6 Grenade Launcher" // CCL-6 = Custodial Cleaner Launcher with a 6 shot magazine.
	desc = "Allows for the construction of CCL-6 grenade launchers."
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/combat = 2)
	materials = alist(
		/decl/material/steel = 9 MATERIAL_SHEETS, /decl/material/silver = 2 MATERIAL_SHEETS,
		/decl/material/gold = 1 MATERIAL_SHEET
	)
	build_path = /obj/item/mecha_equipment/weapon/ballistic/launcher/grenade/cleaner

// Medical
/datum/design/mechfab/equipment/syringe_gun
	name = "Syringe Gun"
	desc = "An exosuit-mounted syringe gun and chemical synthesizer."
	req_tech = alist(
		/decl/tech/materials = 3, /decl/tech/magnets = 4, /decl/tech/biotech = 4,
		/decl/tech/programming = 3
	)
	materials = alist(/decl/material/steel = 1.5 MATERIAL_SHEETS, /decl/material/glass = 1 MATERIAL_SHEET)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_equipment/medical/syringe_gun
	categories = list("Medical Exosuit Equipment")

/datum/design/mechfab/equipment/sleeper
	name = "Mounted Sleeper"
	desc = "An exosuit-mounted medical sleeper."
	req_tech = alist(/decl/tech/biotech = 3, /decl/tech/programming = 2)
	materials = alist(/decl/material/steel = 2.5 MATERIAL_SHEETS, /decl/material/glass = 5 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_equipment/medical/sleeper
	categories = list("Medical Exosuit Equipment")

/datum/design/mechfab/equipment/rescue_jaw
	name = "Rescue Jaw"
	desc = "An exosuit-mounted jaws of life used to extricate casualties from dangerous areas."
	materials = alist(/decl/material/steel = 2.5 MATERIAL_SHEETS, /decl/material/plastic = 2.5 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_equipment/tool/hydraulic_clamp/rescue
	categories = list("Medical Exosuit Equipment")