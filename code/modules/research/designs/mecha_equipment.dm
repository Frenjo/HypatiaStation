/////////////////////////////////////
////////// Mecha Equipment //////////
/////////////////////////////////////
// General
/datum/design/mech_wormhole_gen
	name = "Exosuit Module Design (Localized Wormhole Generator)"
	desc = "An exosuit module that allows generating of small quasi-stable wormholes."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/magnets = 2, /datum/tech/bluespace = 3)
	build_path = /obj/item/mecha_part/equipment/wormhole_generator
	categories = list("General Exosuit Equipment")

/datum/design/mech_teleporter
	name = "Exosuit Module Design (Teleporter Module)"
	desc = "An exosuit module that allows exosuits to teleport to any position in view."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/magnets = 5, /datum/tech/bluespace = 10)
	build_path = /obj/item/mecha_part/equipment/teleporter
	categories = list("General Exosuit Equipment")

/datum/design/mech_gravcatapult
	name = "Exosuit Module Design (Gravitational Catapult Module)"
	desc = "An exosuit mounted Gravitational Catapult."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/magnets = 3, /datum/tech/engineering = 3, /datum/tech/bluespace = 2)
	build_path = /obj/item/mecha_part/equipment/gravcatapult
	categories = list("General Exosuit Equipment")

/datum/design/mech_repair_droid
	name = "Exosuit Module Design (Repair Droid Module)"
	desc = "Automated Repair Droid. BEEP BOOP"
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/magnets = 3, /datum/tech/engineering = 3, /datum/tech/programming = 3)
	build_path = /obj/item/mecha_part/equipment/repair_droid
	categories = list("General Exosuit Equipment")

/datum/design/mech_plasma_generator
	name = "Exosuit Module Design (Plasma Converter Module)"
	desc = "Exosuit-mounted plasma converter."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/power_storage = 2, /datum/tech/plasma = 2)
	build_path = /obj/item/mecha_part/equipment/generator
	categories = list("General Exosuit Equipment")

/datum/design/mech_energy_relay
	name = "Exosuit Module Design (Tesla Energy Relay)"
	desc = "Tesla Energy Relay"
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/magnets = 4, /datum/tech/power_storage = 3)
	build_path = /obj/item/mecha_part/equipment/tesla_energy_relay
	categories = list("General Exosuit Equipment")

/datum/design/mech_generator_nuclear
	name = "Exosuit Module Design (ExoNuclear Reactor)"
	desc = "Compact nuclear reactor module"
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 3, /datum/tech/engineering = 3, /datum/tech/power_storage = 3)
	build_path = /obj/item/mecha_part/equipment/generator/nuclear
	categories = list("General Exosuit Equipment")

// Working
/datum/design/mech_rcd
	name = "Exosuit Module Design (RCD Module)"
	desc = "An exosuit-mounted Rapid Construction Device."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(
		/datum/tech/materials = 4, /datum/tech/magnets = 4, /datum/tech/engineering = 4,
		/datum/tech/power_storage = 4, /datum/tech/bluespace = 3
	)
	build_path = /obj/item/mecha_part/equipment/tool/rcd
	categories = list("Working Exosuit Equipment")

/datum/design/mech_diamond_drill
	name = "Exosuit Module Design (Diamond Mining Drill)"
	desc = "An upgraded version of the standard drill"
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 4, /datum/tech/engineering = 3)
	build_path = /obj/item/mecha_part/equipment/tool/drill/diamond
	categories = list("Working Exosuit Equipment")

// Medical
/datum/design/mech_syringe_gun
	name = "Exosuit Module Design (Syringe Gun)"
	desc = "Exosuit-mounted syringe gun and chemical synthesizer."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(
		/datum/tech/materials = 3, /datum/tech/magnets = 4, /datum/tech/biotech = 4,
		/datum/tech/programming = 3
	)
	build_path = /obj/item/mecha_part/equipment/tool/syringe_gun
	categories = list("Medical Exosuit Equipment")

// Combat
/datum/design/mech_ccw_armor
	name = "Exosuit Module Design (Reactive Armor Booster Module)"
	desc = "Exosuit-mounted armor booster."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 5, /datum/tech/combat = 4)
	build_path = /obj/item/mecha_part/equipment/anticcw_armor_booster
	categories = list("Combat Exosuit Equipment")

/datum/design/mech_proj_armor
	name = "Exosuit Module Design (Reflective Armor Booster Module)"
	desc = "Exosuit-mounted armor booster."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 5, /datum/tech/combat = 5, /datum/tech/engineering = 3)
	build_path = /obj/item/mecha_part/equipment/antiproj_armor_booster
	categories = list("Combat Exosuit Equipment")

// Weapons
/datum/design/mech_scattershot
	name = "Exosuit Weapon Design (LBX AC 10 \"Scattershot\")"
	desc = "Allows for the construction of LBX AC 10."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/combat = 4)
	build_path = /obj/item/mecha_part/equipment/weapon/ballistic/scattershot
	categories = list("Exosuit Weapons")

/datum/design/mech_laser
	name = "Exosuit Weapon Design (CH-PS \"Immolator\" Laser)"
	desc = "Allows for the construction of CH-PS Laser."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/magnets = 3, /datum/tech/combat = 3)
	build_path = /obj/item/mecha_part/equipment/weapon/energy/laser
	categories = list("Exosuit Weapons")

/datum/design/mech_laser_heavy
	name = "Exosuit Weapon Design (CH-LC \"Solaris\" Laser Cannon)"
	desc = "Allows for the construction of CH-LC Laser Cannon."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/magnets = 4, /datum/tech/combat = 4)
	build_path = /obj/item/mecha_part/equipment/weapon/energy/laser/heavy
	categories = list("Exosuit Weapons")

/datum/design/mech_grenade_launcher
	name = "Exosuit Weapon Design (SGL-6 Grenade Launcher)"
	desc = "Allows for the construction of SGL-6 Grenade Launcher."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/combat = 3)
	build_path = /obj/item/mecha_part/equipment/weapon/ballistic/missile_rack/flashbang
	categories = list("Exosuit Weapons")

/datum/design/clusterbang_launcher
	name = "Exosuit Module Design (SOP-6 Clusterbang Launcher)"
	desc = "A weapon that violates the Geneva Convention at 6 rounds per minute"
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 5, /datum/tech/combat = 5, /datum/tech/syndicate = 3)
	build_path = /obj/item/mecha_part/equipment/weapon/ballistic/missile_rack/flashbang/clusterbang/limited
	categories = list("Exosuit Weapons")