/////////////////////////////////////
////////// Mecha Equipment //////////
/////////////////////////////////////
/datum/design/mechfab/equipment
	name_prefix = "Exosuit Module Design"

// General
/datum/design/mechfab/equipment/general
	categories = list("General Exosuit Equipment")

/datum/design/mechfab/equipment/general/tracking
	materials = list(/decl/material/plastic = 500)
	build_time = 5 SECONDS
	build_path = /obj/item/mecha_part/tracking

/datum/design/mechfab/equipment/general/passenger_compartment
	req_tech = list(/decl/tech/materials = 1, /decl/tech/biotech = 1, /decl/tech/engineering = 1)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 3, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 3)
	build_path = /obj/item/mecha_part/equipment/passenger

/*
/datum/design/mechfab/equipment/general/jetpack
	build_path = /obj/item/mecha_part/equipment/jetpack
*/

/datum/design/mechfab/equipment/general/wormhole_gen
	name = "Wormhole Generator"
	desc = "An exosuit module that allows the generation of small quasi-stable wormholes."
	req_tech = list(/decl/tech/magnets = 2, /decl/tech/bluespace = 3)
	materials = list(/decl/material/steel = 10000)
	build_path = /obj/item/mecha_part/equipment/wormhole_generator

/datum/design/mechfab/equipment/general/teleporter
	name = "Teleporter"
	desc = "An exosuit module that allows teleportation to any position in view."
	req_tech = list(/decl/tech/magnets = 5, /decl/tech/bluespace = 10)
	materials = list(/decl/material/steel = 10000)
	build_path = /obj/item/mecha_part/equipment/teleporter

/datum/design/mechfab/equipment/general/gravcatapult
	name = "Gravitational Catapult"
	desc = "An exosuit mounted gravitational catapult."
	req_tech = list(/decl/tech/magnets = 3, /decl/tech/engineering = 3, /decl/tech/bluespace = 2)
	materials = list(/decl/material/steel = 10000)
	build_path = /obj/item/mecha_part/equipment/gravcatapult

/datum/design/mechfab/equipment/general/repair_droid
	name = "Repair Droid"
	desc = "An automated exosuit repair droid. BEEP BOOP!"
	req_tech = list(/decl/tech/magnets = 3, /decl/tech/engineering = 3, /decl/tech/programming = 3)
	materials = list(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 3,
		/decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 2, /decl/material/gold = MATERIAL_AMOUNT_PER_SHEET
	)
	build_path = /obj/item/mecha_part/equipment/repair_droid

/datum/design/mechfab/equipment/general/linear_shield_droid
	name = "Linear Shield Droid"
	desc = "An automated exosuit shield droid. Deploys a large, familiar, and rectangular shield in one direction at a time. BEEP BOOP!"
	req_tech = list(/decl/tech/magnets = 6, /decl/tech/plasma = 3, /decl/tech/syndicate = 4)
	materials = list(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 3,
		/decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 2, /decl/material/gold = MATERIAL_AMOUNT_PER_SHEET,
		/decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 3
	)
	build_path = /obj/item/mecha_part/equipment/shield_droid/linear

/datum/design/mechfab/equipment/general/omnidirectional_shield_droid
	name = "Omnidirectional Shield Droid"
	desc = "An automated exosuit shield droid. Deploys a small, but familiar, and rectangular shield that surrounds an exosuit. BEEP BOOP!"
	req_tech = list(/decl/tech/magnets = 6, /decl/tech/plasma = 6, /decl/tech/syndicate = 6)
	materials = list(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 4,
		/decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 3, /decl/material/gold = MATERIAL_AMOUNT_PER_SHEET * 2,
		/decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 4
	)
	build_path = /obj/item/mecha_part/equipment/shield_droid/omnidirectional

/datum/design/mechfab/equipment/general/energy_relay
	name = "Tesla Energy Relay"
	desc = "An exosuit-mounted energy relay that allows wireless charging from nearby APCs. It isn't very good, though..."
	req_tech = list(/decl/tech/magnets = 4, /decl/tech/power_storage = 3)
	materials = list(/decl/material/steel = 10000, /decl/material/glass = 2000, /decl/material/silver = 3000, /decl/material/gold = 2000)
	build_path = /obj/item/mecha_part/equipment/tesla_energy_relay

/datum/design/mechfab/equipment/general/plasma_generator
	name = "Plasma Converter"
	desc = "An exosuit-mounted plasma converter module."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/power_storage = 2, /decl/tech/plasma = 2)
	materials = list(/decl/material/steel = 10000, /decl/material/glass = 1000, /decl/material/silver = 500)
	build_path = /obj/item/mecha_part/equipment/generator

/datum/design/mechfab/equipment/general/nuclear_generator
	name = "ExoNuclear Reactor"
	desc = "An exosuit-mounted compact nuclear reactor module."
	req_tech = list(/decl/tech/materials = 3, /decl/tech/engineering = 3, /decl/tech/power_storage = 3)
	materials = list(/decl/material/steel = 10000, /decl/material/glass = 1000, /decl/material/silver = 500)
	build_path = /obj/item/mecha_part/equipment/generator/nuclear

// Working
/datum/design/mechfab/equipment/working
	categories = list("Working Exosuit Equipment")

/datum/design/mechfab/equipment/working/hydraulic_clamp
	materials = list(/decl/material/steel = 10000)
	build_path = /obj/item/mecha_part/equipment/tool/hydraulic_clamp

/datum/design/mechfab/equipment/working/drill
	materials = list(/decl/material/steel = 10000)
	build_path = /obj/item/mecha_part/equipment/tool/drill

/datum/design/mechfab/equipment/working/extinguisher
	materials = list(/decl/material/steel = 10000)
	build_path = /obj/item/mecha_part/equipment/tool/extinguisher

/datum/design/mechfab/equipment/working/cable_layer
	materials = list(/decl/material/steel = 10000)
	build_path = /obj/item/mecha_part/equipment/tool/cable_layer

/datum/design/mechfab/equipment/working/rcd
	name = "RCD Module"
	desc = "An exosuit-mounted rapid-construction-device."
	req_tech = list(
		/decl/tech/materials = 4, /decl/tech/magnets = 4, /decl/tech/engineering = 4,
		/decl/tech/power_storage = 4, /decl/tech/bluespace = 3
	)
	materials = list(
		MATERIAL_METAL = 30000, /decl/material/silver = 20000,
		/decl/material/gold = 20000, /decl/material/plasma = 25000
	)
	build_time = 2 MINUTES
	build_path = /obj/item/mecha_part/equipment/tool/rcd

/datum/design/mechfab/equipment/working/mrcd
	name = "MRCD"
	desc = "An exosuit-mounted mime-rapid-construction-device."
	req_tech = list(
		/decl/tech/materials = 4, /decl/tech/magnets = 4, /decl/tech/engineering = 4,
		/decl/tech/power_storage = 4, /decl/tech/bluespace = 3
	)
	materials = list(
		MATERIAL_METAL = 30000, /decl/material/silver = 20000,
		/decl/material/gold = 20000, /decl/material/plasma = 25000,
		/decl/material/tranquilite = 10000
	)
	build_time = 2 MINUTES
	build_path = /obj/item/mecha_part/equipment/tool/mimercd

/datum/design/mechfab/equipment/working/diamond_drill
	name = "Diamond Mining Drill"
	desc = "An upgraded version of the standard exosuit drill."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/engineering = 3)
	materials = list(/decl/material/steel = 10000, /decl/material/diamond = 6500)
	build_path = /obj/item/mecha_part/equipment/tool/drill/diamond

// Medical
/datum/design/mechfab/equipment/syringe_gun
	name = "Syringe Gun"
	desc = "An exosuit-mounted syringe gun and chemical synthesizer."
	req_tech = list(
		/decl/tech/materials = 3, /decl/tech/magnets = 4, /decl/tech/biotech = 4,
		/decl/tech/programming = 3
	)
	materials = list(/decl/material/steel = 3000, /decl/material/glass = 2000)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/equipment/medical/syringe_gun
	categories = list("Medical Exosuit Equipment")

/datum/design/mechfab/equipment/sleeper
	name = "Mounted Sleeper"
	desc = "An exosuit-mounted medical sleeper."
	req_tech = list(/decl/tech/biotech = 3, /decl/tech/programming = 2)
	materials = list(MATERIAL_METAL = 5000, /decl/material/glass = 10000)
	build_path = /obj/item/mecha_part/equipment/medical/sleeper
	categories = list("Medical Exosuit Equipment")

// Combat
/datum/design/mechfab/equipment/melee_armour_booster
	name = "Reactive Armour Booster"
	desc = "An exosuit-mounted armour booster designed to defend against melee attacks."
	req_tech = list(/decl/tech/materials = 5, /decl/tech/combat = 4)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 10, /decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 3)
	build_path = /obj/item/mecha_part/equipment/melee_armour_booster
	categories = list("Combat Exosuit Equipment")

/datum/design/mechfab/equipment/melee_defence_shocker
	name = "Melee Defence Shocker"
	desc = "An exosuit module that electrifies the external armour to discourge melee attackers."
	req_tech = list(/decl/tech/materials = 5, /decl/tech/combat = 4, /decl/tech/engineering = 2, /decl/tech/plasma = 2)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 10, /decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 3)
	build_path = /obj/item/mecha_part/equipment/melee_defence_shocker
	categories = list("Combat Exosuit Equipment")

/datum/design/mechfab/equipment/ranged_armour_booster
	name = "Reflective Armour Booster"
	desc = "An exosuit-mounted armor booster designed to deflect projectile attacks."
	req_tech = list(/decl/tech/materials = 5, /decl/tech/combat = 5, /decl/tech/engineering = 3)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 10, /decl/material/gold = MATERIAL_AMOUNT_PER_SHEET * 3)
	build_path = /obj/item/mecha_part/equipment/ranged_armour_booster
	categories = list("Combat Exosuit Equipment")

// Weapons
/datum/design/mechfab/equipment/weapon
	categories = list("Exosuit Weapons")
	name_prefix = "Exosuit Weapon Design"

/datum/design/mechfab/equipment/weapon/taser
	materials = list(/decl/material/steel = 10000)
	build_path = /obj/item/mecha_part/equipment/weapon/energy/taser

/datum/design/mechfab/equipment/weapon/disabler
	materials = list(/decl/material/steel = 10000)
	build_path = /obj/item/mecha_part/equipment/weapon/energy/disabler

/datum/design/mechfab/equipment/weapon/lmg
	materials = list(/decl/material/steel = 10000)
	build_path = /obj/item/mecha_part/equipment/weapon/ballistic/lmg

/datum/design/mechfab/equipment/weapon/honker
	materials = list(/decl/material/steel = 20000, /decl/material/bananium = 10000)
	build_time = 50 SECONDS
	build_path = /obj/item/mecha_part/equipment/weapon/honker

/datum/design/mechfab/equipment/weapon/banana_mortar
	materials = list(/decl/material/steel = 20000, /decl/material/bananium = 5000)
	build_time = 30 SECONDS
	build_path = /obj/item/mecha_part/equipment/weapon/ballistic/launcher/banana_mortar

/datum/design/mechfab/equipment/weapon/mousetrap_mortar
	materials = list(/decl/material/steel = 20000, /decl/material/bananium = 5000)
	build_time = 30 SECONDS
	build_path = /obj/item/mecha_part/equipment/weapon/ballistic/launcher/banana_mortar/mousetrap_mortar

/datum/design/mechfab/equipment/weapon/scattershot
	name = "LBX AC 10 \"Scattershot\""
	desc = "Allows for the construction of LBX AC 10 scattershots."
	req_tech = list(/decl/tech/materials = 3, /decl/tech/combat = 4)
	materials = list(/decl/material/steel = 10000)
	build_path = /obj/item/mecha_part/equipment/weapon/ballistic/scattershot

/datum/design/mechfab/equipment/weapon/laser
	name = "CH-PS \"Immolator\" Laser"
	desc = "Allows for the construction of CH-PS lasers."
	req_tech = list(/decl/tech/magnets = 3, /decl/tech/combat = 3)
	materials = list(/decl/material/steel = 10000)
	build_path = /obj/item/mecha_part/equipment/weapon/energy/laser

/datum/design/mechfab/equipment/weapon/heavy_laser
	name = "CH-LC \"Solaris\" Laser Cannon"
	desc = "Allows for the construction of CH-LC laser cannons."
	req_tech = list(/decl/tech/magnets = 4, /decl/tech/combat = 4)
	materials = list(/decl/material/steel = 10000)
	build_path = /obj/item/mecha_part/equipment/weapon/energy/laser/heavy

/datum/design/mechfab/equipment/weapon/grenade_launcher
	name = "SGL-6 Grenade Launcher"
	desc = "Allows for the construction of SGL-6 grenade launchers."
	req_tech = list(/decl/tech/materials = 3, /decl/tech/combat = 3)
	materials = list(/decl/material/steel = 10000)
	build_path = /obj/item/mecha_part/equipment/weapon/ballistic/launcher/flashbang

/datum/design/mechfab/equipment/weapon/clusterbang_launcher
	name = "SOP-6 Clusterbang Launcher"
	desc = "Allows for the construction of SOP-6 clusterbang launchers, weapons that violate the Geneva Convention at 6 rounds per minute."
	req_tech = list(/decl/tech/materials = 5, /decl/tech/combat = 5, /decl/tech/syndicate = 3)
	materials = list(/decl/material/steel = 20000, /decl/material/gold = 6000, /decl/material/uranium = 6000)
	build_path = /obj/item/mecha_part/equipment/weapon/ballistic/launcher/flashbang/clusterbang/limited