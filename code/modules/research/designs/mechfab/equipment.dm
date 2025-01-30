/////////////////////////////////////
////////// Mecha Equipment //////////
/////////////////////////////////////
// General
/datum/design/mechfab/general
	categories = list("General Exosuit Equipment")

/datum/design/mechfab/general/tracking
	materials = list(MATERIAL_METAL = 500)
	build_time = 5 SECONDS
	build_path = /obj/item/mecha_part/tracking

/datum/design/mechfab/general/passenger_compartment
	materials = list(MATERIAL_METAL = MATERIAL_AMOUNT_PER_SHEET * 3, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 3)
	build_path = /obj/item/mecha_part/equipment/passenger

/*
/datum/design/mechfab/general/jetpack
	build_path = /obj/item/mecha_part/equipment/jetpack
*/

/datum/design/mechfab/general/wormhole_gen
	name = "Exosuit Module Design (Localized Wormhole Generator)"
	desc = "An exosuit module that allows generating of small quasi-stable wormholes."
	req_tech = list(/datum/tech/magnets = 2, /datum/tech/bluespace = 3)
	materials = list(MATERIAL_METAL = 10000)
	build_path = /obj/item/mecha_part/equipment/wormhole_generator

/datum/design/mechfab/general/teleporter
	name = "Exosuit Module Design (Teleporter Module)"
	desc = "An exosuit module that allows exosuits to teleport to any position in view."
	req_tech = list(/datum/tech/magnets = 5, /datum/tech/bluespace = 10)
	materials = list(MATERIAL_METAL = 10000)
	build_path = /obj/item/mecha_part/equipment/teleporter

/datum/design/mechfab/general/gravcatapult
	name = "Exosuit Module Design (Gravitational Catapult Module)"
	desc = "An exosuit mounted Gravitational Catapult."
	req_tech = list(/datum/tech/magnets = 3, /datum/tech/engineering = 3, /datum/tech/bluespace = 2)
	materials = list(MATERIAL_METAL = 10000)
	build_path = /obj/item/mecha_part/equipment/gravcatapult

/datum/design/mechfab/general/repair_droid
	name = "Exosuit Module Design (Repair Droid)"
	desc = "Automated repair droid. BEEP BOOP!"
	req_tech = list(/datum/tech/magnets = 3, /datum/tech/engineering = 3, /datum/tech/programming = 3)
	materials = list(
		MATERIAL_METAL = MATERIAL_AMOUNT_PER_SHEET * 5, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 3,
		/decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 2, /decl/material/gold = MATERIAL_AMOUNT_PER_SHEET
	)
	build_path = /obj/item/mecha_part/equipment/repair_droid

/datum/design/mechfab/general/linear_shield_droid
	name = "Exosuit Module Design (Linear Shield Droid)"
	desc = "Automated shield droid. Deploys a large, familiar, and rectangular shield in one direction at a time. BEEP BOOP!"
	req_tech = list(/datum/tech/magnets = 6, /datum/tech/plasma = 3, /datum/tech/syndicate = 4)
	materials = list(
		MATERIAL_METAL = MATERIAL_AMOUNT_PER_SHEET * 5, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 3,
		/decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 2, /decl/material/gold = MATERIAL_AMOUNT_PER_SHEET,
		/decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 3
	)
	build_path = /obj/item/mecha_part/equipment/shield_droid/linear

/datum/design/mechfab/general/omnidirectional_shield_droid
	name = "Exosuit Module Design (Omnidirectional Shield Droid)"
	desc = "Automated shield droid. Deploys a small, but familiar, and rectangular shield that surrounds an exosuit. BEEP BOOP!"
	req_tech = list(/datum/tech/magnets = 6, /datum/tech/plasma = 6, /datum/tech/syndicate = 6)
	materials = list(
		MATERIAL_METAL = MATERIAL_AMOUNT_PER_SHEET * 6, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 4,
		/decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 3, /decl/material/gold = MATERIAL_AMOUNT_PER_SHEET * 2,
		/decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 4
	)
	build_path = /obj/item/mecha_part/equipment/shield_droid/omnidirectional

/datum/design/mechfab/general/energy_relay
	name = "Exosuit Module Design (Tesla Energy Relay)"
	desc = "Tesla Energy Relay"
	req_tech = list(/datum/tech/magnets = 4, /datum/tech/power_storage = 3)
	materials = list(MATERIAL_METAL = 10000, /decl/material/glass = 2000, /decl/material/silver = 3000, /decl/material/gold = 2000)
	build_path = /obj/item/mecha_part/equipment/tesla_energy_relay

/datum/design/mechfab/general/plasma_generator
	name = "Exosuit Module Design (Plasma Converter Module)"
	desc = "Exosuit-mounted plasma converter."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/power_storage = 2, /datum/tech/plasma = 2)
	materials = list(MATERIAL_METAL = 10000, /decl/material/glass = 1000, /decl/material/silver = 500)
	build_path = /obj/item/mecha_part/equipment/generator

/datum/design/mechfab/general/nuclear_generator
	name = "Exosuit Module Design (ExoNuclear Reactor)"
	desc = "Compact nuclear reactor module"
	req_tech = list(/datum/tech/materials = 3, /datum/tech/engineering = 3, /datum/tech/power_storage = 3)
	materials = list(MATERIAL_METAL = 10000, /decl/material/glass = 1000, /decl/material/silver = 500)
	build_path = /obj/item/mecha_part/equipment/generator/nuclear

// Working
/datum/design/mechfab/working
	categories = list("Working Exosuit Equipment")

/datum/design/mechfab/working/hydraulic_clamp
	materials = list(MATERIAL_METAL = 10000)
	build_path = /obj/item/mecha_part/equipment/tool/hydraulic_clamp

/datum/design/mechfab/working/drill
	materials = list(MATERIAL_METAL = 10000)
	build_path = /obj/item/mecha_part/equipment/tool/drill

/datum/design/mechfab/working/extinguisher
	materials = list(MATERIAL_METAL = 10000)
	build_path = /obj/item/mecha_part/equipment/tool/extinguisher

/datum/design/mechfab/working/cable_layer
	materials = list(MATERIAL_METAL = 10000)
	build_path = /obj/item/mecha_part/equipment/tool/cable_layer

/datum/design/mechfab/working/rcd
	name = "Exosuit Module Design (RCD Module)"
	desc = "An exosuit-mounted rapid-construction-device."
	req_tech = list(
		/datum/tech/materials = 4, /datum/tech/magnets = 4, /datum/tech/engineering = 4,
		/datum/tech/power_storage = 4, /datum/tech/bluespace = 3
	)
	materials = list(
		MATERIAL_METAL = 30000, /decl/material/silver = 20000,
		/decl/material/gold = 20000, /decl/material/plasma = 25000
	)
	build_time = 2 MINUTES
	build_path = /obj/item/mecha_part/equipment/tool/rcd

/datum/design/mechfab/working/mrcd
	name = "Exosuit Module Design (MRCD Module)"
	desc = "An exosuit-mounted mime-rapid-construction-device."
	req_tech = list(
		/datum/tech/materials = 4, /datum/tech/magnets = 4, /datum/tech/engineering = 4,
		/datum/tech/power_storage = 4, /datum/tech/bluespace = 3
	)
	materials = list(
		MATERIAL_METAL = 30000, /decl/material/silver = 20000,
		/decl/material/gold = 20000, /decl/material/plasma = 25000,
		/decl/material/bananium = 10000 // This is a placeholder for tranquilite.
	)
	build_time = 2 MINUTES
	build_path = /obj/item/mecha_part/equipment/tool/mimercd

/datum/design/mechfab/working/diamond_drill
	name = "Exosuit Module Design (Diamond Mining Drill)"
	desc = "An upgraded version of the standard drill"
	req_tech = list(/datum/tech/materials = 4, /datum/tech/engineering = 3)
	materials = list(MATERIAL_METAL = 10000, /decl/material/diamond = 6500)
	build_path = /obj/item/mecha_part/equipment/tool/drill/diamond

// Medical
/datum/design/mechfab/syringe_gun
	name = "Exosuit Module Design (Syringe Gun)"
	desc = "Exosuit-mounted syringe gun and chemical synthesizer."
	req_tech = list(
		/datum/tech/materials = 3, /datum/tech/magnets = 4, /datum/tech/biotech = 4,
		/datum/tech/programming = 3
	)
	materials = list(MATERIAL_METAL = 3000, /decl/material/glass = 2000)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/equipment/medical/syringe_gun
	categories = list("Medical Exosuit Equipment")

/datum/design/mechfab/sleeper
	name = "Exosuit Module Design (Mounted Sleeper)"
	desc = "An exosuit-mounted sleeper."
	req_tech = list(/datum/tech/biotech = 3, /datum/tech/programming = 2)
	materials = list(MATERIAL_METAL = 5000, /decl/material/glass = 10000)
	build_path = /obj/item/mecha_part/equipment/medical/sleeper
	categories = list("Medical Exosuit Equipment")

// Combat
/datum/design/mechfab/melee_armour_booster
	name = "Exosuit Module Design (Reactive Armor Booster Module)"
	desc = "Exosuit-mounted armor booster."
	req_tech = list(/datum/tech/materials = 5, /datum/tech/combat = 4)
	materials = list(MATERIAL_METAL = MATERIAL_AMOUNT_PER_SHEET * 10, /decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 3)
	build_path = /obj/item/mecha_part/equipment/melee_armour_booster
	categories = list("Combat Exosuit Equipment")

/datum/design/mechfab/melee_defence_shocker
	name = "Exosuit Module Design (Melee Defence Shocker Module)"
	desc = "An exosuit module that electrifies the external armour to discourge melee attackers."
	req_tech = list(/datum/tech/materials = 5, /datum/tech/combat = 4, /datum/tech/engineering = 2, /datum/tech/plasma = 2)
	materials = list(MATERIAL_METAL = MATERIAL_AMOUNT_PER_SHEET * 10, /decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 3)
	build_path = /obj/item/mecha_part/equipment/melee_defence_shocker
	categories = list("Combat Exosuit Equipment")

/datum/design/mechfab/ranged_armour_booster
	name = "Exosuit Module Design (Reflective Armor Booster Module)"
	desc = "Exosuit-mounted armor booster."
	req_tech = list(/datum/tech/materials = 5, /datum/tech/combat = 5, /datum/tech/engineering = 3)
	materials = list(MATERIAL_METAL = MATERIAL_AMOUNT_PER_SHEET * 10, /decl/material/gold = MATERIAL_AMOUNT_PER_SHEET * 3)
	build_path = /obj/item/mecha_part/equipment/ranged_armour_booster
	categories = list("Combat Exosuit Equipment")

// Weapons
/datum/design/mechfab/weapon
	categories = list("Exosuit Weapons")

/datum/design/mechfab/weapon/taser
	materials = list(MATERIAL_METAL = 10000)
	build_path = /obj/item/mecha_part/equipment/weapon/energy/taser

/datum/design/mechfab/weapon/lmg
	materials = list(MATERIAL_METAL = 10000)
	build_path = /obj/item/mecha_part/equipment/weapon/ballistic/lmg

/datum/design/mechfab/weapon/honker
	materials = list(MATERIAL_METAL = 20000, /decl/material/bananium = 10000)
	build_time = 50 SECONDS
	build_path = /obj/item/mecha_part/equipment/weapon/honker

/datum/design/mechfab/weapon/banana_mortar
	materials = list(MATERIAL_METAL = 20000, /decl/material/bananium = 5000)
	build_time = 30 SECONDS
	build_path = /obj/item/mecha_part/equipment/weapon/ballistic/launcher/banana_mortar

/datum/design/mechfab/weapon/mousetrap_mortar
	materials = list(MATERIAL_METAL = 20000, /decl/material/bananium = 5000)
	build_time = 30 SECONDS
	build_path = /obj/item/mecha_part/equipment/weapon/ballistic/launcher/banana_mortar/mousetrap_mortar

/datum/design/mechfab/weapon/scattershot
	name = "Exosuit Weapon Design (LBX AC 10 \"Scattershot\")"
	desc = "Allows for the construction of LBX AC 10."
	req_tech = list(/datum/tech/combat = 4)
	materials = list(MATERIAL_METAL = 10000)
	build_path = /obj/item/mecha_part/equipment/weapon/ballistic/scattershot

/datum/design/mechfab/weapon/laser
	name = "Exosuit Weapon Design (CH-PS \"Immolator\" Laser)"
	desc = "Allows for the construction of CH-PS Laser."
	req_tech = list(/datum/tech/magnets = 3, /datum/tech/combat = 3)
	materials = list(MATERIAL_METAL = 10000)
	build_path = /obj/item/mecha_part/equipment/weapon/energy/laser

/datum/design/mechfab/weapon/heavy_laser
	name = "Exosuit Weapon Design (CH-LC \"Solaris\" Laser Cannon)"
	desc = "Allows for the construction of CH-LC Laser Cannon."
	req_tech = list(/datum/tech/magnets = 4, /datum/tech/combat = 4)
	materials = list(MATERIAL_METAL = 10000)
	build_path = /obj/item/mecha_part/equipment/weapon/energy/laser/heavy

/datum/design/mechfab/weapon/grenade_launcher
	name = "Exosuit Weapon Design (SGL-6 Grenade Launcher)"
	desc = "Allows for the construction of SGL-6 Grenade Launcher."
	req_tech = list(/datum/tech/combat = 3)
	materials = list(MATERIAL_METAL = 10000)
	build_path = /obj/item/mecha_part/equipment/weapon/ballistic/launcher/flashbang

/datum/design/mechfab/weapon/clusterbang_launcher
	name = "Exosuit Module Design (SOP-6 Clusterbang Launcher)"
	desc = "A weapon that violates the Geneva Convention at 6 rounds per minute"
	req_tech = list(/datum/tech/materials = 5, /datum/tech/combat = 5, /datum/tech/syndicate = 3)
	materials = list(MATERIAL_METAL = 20000, /decl/material/gold = 6000, /decl/material/uranium = 6000)
	build_path = /obj/item/mecha_part/equipment/weapon/ballistic/launcher/flashbang/clusterbang/limited