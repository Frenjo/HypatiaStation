/////////////////////////////////////
////////// Mecha Equipment //////////
/////////////////////////////////////
/datum/design/mecha_equipment
	build_type = DESIGN_TYPE_MECHFAB

// General
/datum/design/mecha_equipment/general
	categories = list("General Exosuit Equipment")

/datum/design/mecha_equipment/general/wormhole_gen
	name = "Exosuit Module Design (Localized Wormhole Generator)"
	desc = "An exosuit module that allows generating of small quasi-stable wormholes."
	req_tech = list(/datum/tech/magnets = 2, /datum/tech/bluespace = 3)
	build_path = /obj/item/mecha_part/equipment/wormhole_generator

/datum/design/mecha_equipment/general/teleporter
	name = "Exosuit Module Design (Teleporter Module)"
	desc = "An exosuit module that allows exosuits to teleport to any position in view."
	req_tech = list(/datum/tech/magnets = 5, /datum/tech/bluespace = 10)
	build_path = /obj/item/mecha_part/equipment/teleporter

/datum/design/mecha_equipment/general/gravcatapult
	name = "Exosuit Module Design (Gravitational Catapult Module)"
	desc = "An exosuit mounted Gravitational Catapult."
	req_tech = list(/datum/tech/magnets = 3, /datum/tech/engineering = 3, /datum/tech/bluespace = 2)
	build_path = /obj/item/mecha_part/equipment/gravcatapult

/datum/design/mecha_equipment/general/repair_droid
	name = "Exosuit Module Design (Repair Droid)"
	desc = "Automated repair droid. BEEP BOOP!"
	req_tech = list(/datum/tech/magnets = 3, /datum/tech/engineering = 3, /datum/tech/programming = 3)
	build_path = /obj/item/mecha_part/equipment/repair_droid

/datum/design/mecha_equipment/general/linear_shield_droid
	name = "Exosuit Module Design (Linear Shield Droid)"
	desc = "Automated shield droid. Deploys a large, familiar, and rectangular shield in one direction at a time. BEEP BOOP!"
	req_tech = list(/datum/tech/magnets = 6, /datum/tech/plasma = 3, /datum/tech/syndicate = 4)
	build_path = /obj/item/mecha_part/equipment/shield_droid/linear

/datum/design/mecha_equipment/general/omnidirectional_shield_droid
	name = "Exosuit Module Design (Omnidirectional Shield Droid)"
	desc = "Automated shield droid. Deploys a small, but familiar, and rectangular shield that surrounds an exosuit. BEEP BOOP!"
	req_tech = list(/datum/tech/magnets = 6, /datum/tech/plasma = 6, /datum/tech/syndicate = 6)
	build_path = /obj/item/mecha_part/equipment/shield_droid/omnidirectional

/datum/design/mecha_equipment/general/energy_relay
	name = "Exosuit Module Design (Tesla Energy Relay)"
	desc = "Tesla Energy Relay"
	req_tech = list(/datum/tech/magnets = 4, /datum/tech/power_storage = 3)
	build_path = /obj/item/mecha_part/equipment/tesla_energy_relay

/datum/design/mecha_equipment/general/plasma_generator
	name = "Exosuit Module Design (Plasma Converter Module)"
	desc = "Exosuit-mounted plasma converter."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/power_storage = 2, /datum/tech/plasma = 2)
	build_path = /obj/item/mecha_part/equipment/generator

/datum/design/mecha_equipment/general/nuclear_generator
	name = "Exosuit Module Design (ExoNuclear Reactor)"
	desc = "Compact nuclear reactor module"
	req_tech = list(/datum/tech/materials = 3, /datum/tech/engineering = 3, /datum/tech/power_storage = 3)
	build_path = /obj/item/mecha_part/equipment/generator/nuclear

// Working
/datum/design/mecha_equipment/working
	categories = list("Working Exosuit Equipment")

/datum/design/mecha_equipment/working/rcd
	name = "Exosuit Module Design (RCD Module)"
	desc = "An exosuit-mounted rapid-construction-device."
	req_tech = list(
		/datum/tech/materials = 4, /datum/tech/magnets = 4, /datum/tech/engineering = 4,
		/datum/tech/power_storage = 4, /datum/tech/bluespace = 3
	)
	build_path = /obj/item/mecha_part/equipment/tool/rcd

/datum/design/mecha_equipment/working/mrcd
	name = "Exosuit Module Design (MRCD Module)"
	desc = "An exosuit-mounted mime-rapid-construction-device."
	req_tech = list(
		/datum/tech/materials = 4, /datum/tech/magnets = 4, /datum/tech/engineering = 4,
		/datum/tech/power_storage = 4, /datum/tech/bluespace = 3
	)
	build_path = /obj/item/mecha_part/equipment/tool/mimercd

/datum/design/mecha_equipment/working/diamond_drill
	name = "Exosuit Module Design (Diamond Mining Drill)"
	desc = "An upgraded version of the standard drill"
	req_tech = list(/datum/tech/materials = 4, /datum/tech/engineering = 3)
	build_path = /obj/item/mecha_part/equipment/tool/drill/diamond

// Medical
/datum/design/mecha_equipment/syringe_gun
	name = "Exosuit Module Design (Syringe Gun)"
	desc = "Exosuit-mounted syringe gun and chemical synthesizer."
	req_tech = list(
		/datum/tech/materials = 3, /datum/tech/magnets = 4, /datum/tech/biotech = 4,
		/datum/tech/programming = 3
	)
	build_path = /obj/item/mecha_part/equipment/medical/syringe_gun
	categories = list("Medical Exosuit Equipment")

// Combat
/datum/design/mecha_equipment/melee_armour_booster
	name = "Exosuit Module Design (Reactive Armor Booster Module)"
	desc = "Exosuit-mounted armor booster."
	req_tech = list(/datum/tech/materials = 5, /datum/tech/combat = 4)
	build_path = /obj/item/mecha_part/equipment/melee_armour_booster
	categories = list("Combat Exosuit Equipment")

/datum/design/mecha_equipment/ranged_armour_booster
	name = "Exosuit Module Design (Reflective Armor Booster Module)"
	desc = "Exosuit-mounted armor booster."
	req_tech = list(/datum/tech/materials = 5, /datum/tech/combat = 5, /datum/tech/engineering = 3)
	build_path = /obj/item/mecha_part/equipment/ranged_armour_booster
	categories = list("Combat Exosuit Equipment")

// Weapons
/datum/design/mecha_equipment/weapon
	categories = list("Exosuit Weapons")

/datum/design/mecha_equipment/weapon/scattershot
	name = "Exosuit Weapon Design (LBX AC 10 \"Scattershot\")"
	desc = "Allows for the construction of LBX AC 10."
	req_tech = list(/datum/tech/combat = 4)
	build_path = /obj/item/mecha_part/equipment/weapon/ballistic/scattershot

/datum/design/mecha_equipment/weapon/laser
	name = "Exosuit Weapon Design (CH-PS \"Immolator\" Laser)"
	desc = "Allows for the construction of CH-PS Laser."
	req_tech = list(/datum/tech/magnets = 3, /datum/tech/combat = 3)
	build_path = /obj/item/mecha_part/equipment/weapon/energy/laser

/datum/design/mecha_equipment/weapon/heavy_laser
	name = "Exosuit Weapon Design (CH-LC \"Solaris\" Laser Cannon)"
	desc = "Allows for the construction of CH-LC Laser Cannon."
	req_tech = list(/datum/tech/magnets = 4, /datum/tech/combat = 4)
	build_path = /obj/item/mecha_part/equipment/weapon/energy/laser/heavy

/datum/design/mecha_equipment/weapon/grenade_launcher
	name = "Exosuit Weapon Design (SGL-6 Grenade Launcher)"
	desc = "Allows for the construction of SGL-6 Grenade Launcher."
	req_tech = list(/datum/tech/combat = 3)
	build_path = /obj/item/mecha_part/equipment/weapon/ballistic/launcher/flashbang

/datum/design/mecha_equipment/weapon/clusterbang_launcher
	name = "Exosuit Module Design (SOP-6 Clusterbang Launcher)"
	desc = "A weapon that violates the Geneva Convention at 6 rounds per minute"
	req_tech = list(/datum/tech/materials = 5, /datum/tech/combat = 5, /datum/tech/syndicate = 3)
	build_path = /obj/item/mecha_part/equipment/weapon/ballistic/launcher/flashbang/clusterbang/limited