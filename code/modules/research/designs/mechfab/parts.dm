/////////////////////////////////
////////// Mecha Parts //////////
/////////////////////////////////
/datum/design/mechfab/part
	name_prefix = "Exosuit Part Design"

// Ripley (and friends) Chassis
/datum/design/mechfab/part/ripley_chassis
	materials = alist(/decl/material/steel = 10 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_part/chassis/ripley
	categories = list("Ripley")

/datum/design/mechfab/part/firefighter_chassis
	materials = alist(/decl/material/steel = 10 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_part/chassis/firefighter
	categories = list("Firefighter")

/datum/design/mechfab/part/rescue_ranger_chassis
	materials = alist(/decl/material/steel = 10 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_part/chassis/rescue_ranger
	categories = list("Rescue Ranger")

/datum/design/mechfab/part/dreadnought_chassis
	materials = alist(/decl/material/steel = 10 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_part/chassis/dreadnought
	categories = list("Dreadnought")

/datum/design/mechfab/part/bulwark_chassis
	materials = alist(/decl/material/steel = 12.5 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_part/chassis/bulwark
	categories = list("Bulwark")

// Ripley
/datum/design/mechfab/part/ripley_torso
	materials = alist(/decl/material/steel = 12 MATERIAL_SHEETS, /decl/material/glass = 8 MATERIAL_SHEETS)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/ripley/torso
	categories = list("Ripley", "Firefighter", "Rescue Ranger", "Dreadnought", "Bulwark")

/datum/design/mechfab/part/ripley_left_arm
	materials = alist(/decl/material/steel = 8 MATERIAL_SHEETS)
	build_time = 15 SECONDS
	build_path = /obj/item/mecha_part/part/ripley/left_arm
	categories = list("Ripley", "Firefighter", "Rescue Ranger", "Dreadnought", "Bulwark")

/datum/design/mechfab/part/ripley_right_arm
	materials = alist(/decl/material/steel = 8 MATERIAL_SHEETS)
	build_time = 15 SECONDS
	build_path = /obj/item/mecha_part/part/ripley/right_arm
	categories = list("Ripley", "Firefighter", "Rescue Ranger", "Dreadnought", "Bulwark")

/datum/design/mechfab/part/ripley_left_leg
	materials = alist(/decl/material/steel = 9 MATERIAL_SHEETS)
	build_time = 15 SECONDS
	build_path = /obj/item/mecha_part/part/ripley/left_leg
	categories = list("Ripley", "Firefighter", "Rescue Ranger", "Dreadnought", "Bulwark")

/datum/design/mechfab/part/ripley_right_leg
	materials = alist(/decl/material/steel = 9 MATERIAL_SHEETS)
	build_time = 15 SECONDS
	build_path = /obj/item/mecha_part/part/ripley/right_leg
	categories = list("Ripley", "Firefighter", "Rescue Ranger", "Dreadnought", "Bulwark")

// Clarke
/datum/design/mechfab/part/clarke_chassis
	materials = alist(/decl/material/steel = 10 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_part/chassis/clarke
	categories = list("Clarke")

/datum/design/mechfab/part/clarke_torso
	name = "\"Clarke\" Torso"
	desc = "The torso of a Clarke-type exosuit."
	materials = alist(/decl/material/steel = 12 MATERIAL_SHEETS, /decl/material/glass = 8 MATERIAL_SHEETS)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/clarke/torso
	categories = list("Clarke")

/datum/design/mechfab/part/clarke_head
	name = "\"Clarke\" Head"
	desc = "The head of a Clarke-type exosuit."
	req_tech = alist(/decl/tech/materials = 2, /decl/tech/engineering = 3, /decl/tech/programming = 2) // Slightly more engineering than a Ripley.
	materials = alist(/decl/material/steel = 6 MATERIAL_SHEETS, /decl/material/glass = 5 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_part/part/clarke/head
	categories = list("Clarke")

/datum/design/mechfab/part/clarke_left_arm
	name = "\"Clarke\" Left Arm"
	desc = "The left arm of a Clarke-type exosuit."
	materials = alist(/decl/material/steel = 8 MATERIAL_SHEETS)
	build_time = 15 SECONDS
	build_path = /obj/item/mecha_part/part/clarke/left_arm
	categories = list("Clarke")

/datum/design/mechfab/part/clarke_right_arm
	name = "\"Clarke\" Right Arm"
	desc = "The right arm of a Clarke-type exosuit."
	materials = alist(/decl/material/steel = 8 MATERIAL_SHEETS)
	build_time = 15 SECONDS
	build_path = /obj/item/mecha_part/part/clarke/right_arm
	categories = list("Clarke")

/datum/design/mechfab/part/clarke_treads
	name = "\"Clarke\" Treads"
	desc = "The treads of a Clarke-type exosuit."
	req_tech = alist(/decl/tech/materials = 2, /decl/tech/engineering = 3, /decl/tech/programming = 2) // Slightly more engineering than a Ripley.
	materials = alist(/decl/material/steel = 18 MATERIAL_SHEETS)
	build_time = 30 SECONDS
	build_path = /obj/item/mecha_part/part/clarke/treads
	categories = list("Clarke")

// Odysseus
/datum/design/mechfab/part/odysseus_chassis
	materials = alist(/decl/material/steel = 10 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_part/chassis/odysseus
	categories = list("Odysseus")

/datum/design/mechfab/part/odysseus_torso
	name = "\"Odysseus\" Torso"
	desc = "The torso of an Odysseus-type exosuit."
	req_tech = alist(
		/decl/tech/materials = 2, /decl/tech/biotech = 2, /decl/tech/engineering = 2,
		/decl/tech/programming = 2
	)
	materials = alist(/decl/material/steel = 8 MATERIAL_SHEETS)
	build_time = 18 SECONDS
	build_path = /obj/item/mecha_part/part/odysseus/torso
	categories = list("Odysseus")

/datum/design/mechfab/part/odysseus_head
	name = "\"Odysseus\" Head"
	desc = "The head of an Odysseus-type exosuit."
	req_tech = alist(/decl/tech/materials = 2, /decl/tech/programming = 3)
	materials = alist(/decl/material/steel = 3 MATERIAL_SHEETS, /decl/material/glass = 5 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_part/part/odysseus/head
	categories = list("Odysseus")

/datum/design/mechfab/part/odysseus_left_arm
	name = "\"Odysseus\" Left Arm"
	desc = "The left arm of an Odysseus-type exosuit."
	req_tech = alist(/decl/tech/materials = 2, /decl/tech/engineering = 2, /decl/tech/programming = 2)
	materials = alist(/decl/material/steel = 3 MATERIAL_SHEETS)
	build_time = 12 SECONDS
	build_path = /obj/item/mecha_part/part/odysseus/left_arm
	categories = list("Odysseus")

/datum/design/mechfab/part/odysseus_right_arm
	name = "\"Odysseus\" Right Arm"
	desc = "The right arm of an Odysseus-type exosuit."
	req_tech = alist(/decl/tech/materials = 2, /decl/tech/engineering = 2, /decl/tech/programming = 2)
	materials = alist(/decl/material/steel = 3 MATERIAL_SHEETS)
	build_time = 12 SECONDS
	build_path = /obj/item/mecha_part/part/odysseus/right_arm
	categories = list("Odysseus")

/datum/design/mechfab/part/odysseus_left_leg
	name = "\"Odysseus\" Left Leg"
	desc = "The left leg of an Odysseus-type exosuit."
	req_tech = alist(/decl/tech/materials = 2, /decl/tech/engineering = 2, /decl/tech/programming = 2)
	materials = alist(/decl/material/steel = 5 MATERIAL_SHEETS)
	build_time = 13 SECONDS
	build_path = /obj/item/mecha_part/part/odysseus/left_leg
	categories = list("Odysseus")

/datum/design/mechfab/part/odysseus_right_leg
	name = "\"Odysseus\" Right Leg"
	desc = "The right leg of an Odysseus-type exosuit."
	req_tech = alist(/decl/tech/materials = 2, /decl/tech/engineering = 2, /decl/tech/programming = 2)
	materials = alist(/decl/material/steel = 5 MATERIAL_SHEETS)
	build_time = 13 SECONDS
	build_path = /obj/item/mecha_part/part/odysseus/right_leg
	categories = list("Odysseus")

/datum/design/mechfab/part/odysseus_carapace
	name = "\"Odysseus\" Carapace"
	desc = "The external carapace of an Odysseus-type exosuit."
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/engineering = 3)
	materials = alist(/decl/material/steel = 5 MATERIAL_SHEETS, /decl/material/plasma = 3 MATERIAL_SHEETS)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/odysseus/carapace
	categories = list("Odysseus")

// Gygax
/datum/design/mechfab/part/gygax_chassis
	materials = alist(/decl/material/steel = 10 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_part/chassis/gygax
	categories = list("Gygax")

/datum/design/mechfab/part/gygax_torso
	name = "\"Gygax\" Torso"
	desc = "The torso of a Gygax-type exosuit."
	req_tech = alist(
		/decl/tech/materials = 2, /decl/tech/biotech = 3, /decl/tech/engineering = 3,
		/decl/tech/programming = 2
	)
	materials = alist(/decl/material/steel = 15 MATERIAL_SHEETS, /decl/material/glass = 10 MATERIAL_SHEETS)
	build_time = 30 SECONDS
	build_path = /obj/item/mecha_part/part/gygax/torso
	categories = list("Gygax", "Serenity")

/datum/design/mechfab/part/gygax_head
	name = "\"Gygax\" Head"
	desc = "The head of a Gygax-type exosuit."
	req_tech = alist(
		/decl/tech/materials = 2, /decl/tech/magnets = 3, /decl/tech/engineering = 3,
		/decl/tech/programming = 2
	)
	materials = alist(/decl/material/steel = 6 MATERIAL_SHEETS, /decl/material/glass = 5 MATERIAL_SHEETS)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/gygax/head
	categories = list("Gygax", "Serenity")

/datum/design/mechfab/part/gygax_left_arm
	name = "\"Gygax\" Left Arm"
	desc = "The left arm of a Gygax-type exosuit."
	req_tech = alist(/decl/tech/materials = 2, /decl/tech/engineering = 3, /decl/tech/programming = 2)
	materials = alist(/decl/material/steel = 9 MATERIAL_SHEETS)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/gygax/left_arm
	categories = list("Gygax", "Serenity")

/datum/design/mechfab/part/gygax_right_arm
	name = "\"Gygax\" Right Arm"
	desc = "The right arm of a Gygax-type exosuit."
	req_tech = alist(/decl/tech/materials = 2, /decl/tech/engineering = 3, /decl/tech/programming = 2)
	materials = alist(/decl/material/steel = 9 MATERIAL_SHEETS)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/gygax/right_arm
	categories = list("Gygax", "Serenity")

/datum/design/mechfab/part/gygax_left_leg
	name = "\"Gygax\" Left Leg"
	desc = "The left leg of a Gygax-type exosuit."
	req_tech = alist(/decl/tech/materials = 2, /decl/tech/engineering = 3, /decl/tech/programming = 2)
	materials = alist(/decl/material/steel = 11 MATERIAL_SHEETS)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/gygax/left_leg
	categories = list("Gygax", "Serenity")

/datum/design/mechfab/part/gygax_right_leg
	name = "\"Gygax\" Right Leg"
	desc = "The right leg of a Gygax-type exosuit."
	req_tech = alist(/decl/tech/materials = 2, /decl/tech/engineering = 3, /decl/tech/programming = 2)
	materials = alist(/decl/material/steel = 11 MATERIAL_SHEETS)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/gygax/right_leg
	categories = list("Gygax", "Serenity")

/datum/design/mechfab/part/gygax_armour
	name = "\"Gygax\" Armour"
	desc = "A set of armour plates for a Gygax-type exosuit."
	req_tech = alist(/decl/tech/materials = 6, /decl/tech/combat = 4, /decl/tech/engineering = 5)
	materials = alist(/decl/material/steel = 8 MATERIAL_SHEETS, /decl/material/diamond = 5 MATERIAL_SHEETS)
	build_time = 60 SECONDS
	build_path = /obj/item/mecha_part/part/gygax/armour
	categories = list("Gygax")

// Serenity
/datum/design/mechfab/part/serenity_chassis
	materials = alist(/decl/material/steel = 10 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_part/chassis/serenity
	categories = list("Serenity")

/datum/design/mechfab/part/serenity_carapace
	name = "\"Serenity\" Carapace"
	desc = "The external carapace of a Serenity-type exosuit."
	req_tech = alist(/decl/tech/materials = 4, /decl/tech/engineering = 4)
	materials = alist(/decl/material/steel = 5 MATERIAL_SHEETS, /decl/material/plasma = 3 MATERIAL_SHEETS)
	build_time = 40 SECONDS
	build_path = /obj/item/mecha_part/part/gygax/armour/serenity
	categories = list("Serenity")

// Durand
/datum/design/mechfab/part/durand_chassis
	materials = alist(/decl/material/steel = 12.5 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_part/chassis/durand
	categories = list("Durand")

/datum/design/mechfab/part/durand_torso
	name = "\"Durand\" Torso"
	desc = "The torso of a Durand-type exosuit."
	req_tech = alist(
		/decl/tech/materials = 3, /decl/tech/biotech = 3, /decl/tech/engineering = 3,
		/decl/tech/programming = 2
	)
	materials = alist(
		/decl/material/steel = 17 MATERIAL_SHEETS, /decl/material/glass = 10 MATERIAL_SHEETS,
		/decl/material/silver = 5 MATERIAL_SHEETS
	)
	build_time = 30 SECONDS
	build_path = /obj/item/mecha_part/part/durand/torso
	categories = list("Durand", "Archambeau", "Brigand")

/datum/design/mechfab/part/durand_head
	name = "\"Durand\" Head"
	desc = "The head of a Durand-type exosuit."
	req_tech = alist(
		/decl/tech/materials = 3, /decl/tech/magnets = 3, /decl/tech/engineering = 3,
		/decl/tech/programming = 2
	)
	materials = alist(
		/decl/material/steel = 8 MATERIAL_SHEETS, /decl/material/glass = 5 MATERIAL_SHEETS,
		/decl/material/silver = 2 MATERIAL_SHEETS
	)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/durand/head
	categories = list("Durand", "Archambeau", "Brigand")

/datum/design/mechfab/part/durand_left_arm
	name = "\"Durand\" Left Arm"
	desc = "The left arm of a Durand-type exosuit."
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/engineering = 3, /decl/tech/programming = 2)
	materials = alist(/decl/material/steel = 11 MATERIAL_SHEETS, /decl/material/silver = 2 MATERIAL_SHEETS)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/durand/left_arm
	categories = list("Durand", "Archambeau", "Brigand")

/datum/design/mechfab/part/durand_right_arm
	name = "\"Durand\" Right Arm"
	desc = "The right arm of a Durand-type exosuit."
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/engineering = 3, /decl/tech/programming = 2)
	materials = alist(/decl/material/steel = 11 MATERIAL_SHEETS, /decl/material/silver = 2 MATERIAL_SHEETS)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/durand/right_arm
	categories = list("Durand", "Archambeau", "Brigand")

/datum/design/mechfab/part/durand_left_leg
	name = "\"Durand\" Left Leg"
	desc = "The left leg of a Durand-type exosuit."
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/engineering = 3, /decl/tech/programming = 2)
	materials = alist(/decl/material/steel = 12 MATERIAL_SHEETS, /decl/material/silver = 2 MATERIAL_SHEETS)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/durand/left_leg
	categories = list("Durand", "Archambeau", "Brigand")

/datum/design/mechfab/part/durand_right_leg
	name = "\"Durand\" Right Leg"
	desc = "The right leg of a Durand-type exosuit."
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/engineering = 3, /decl/tech/programming = 2)
	materials = alist(/decl/material/steel = 12 MATERIAL_SHEETS, /decl/material/silver = 2 MATERIAL_SHEETS)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/durand/right_leg
	categories = list("Durand", "Archambeau", "Brigand")

/datum/design/mechfab/part/durand_armour
	name = "\"Durand\" Armour"
	desc = "A set of armour plates for a Durand-type exosuit."
	req_tech = alist(/decl/tech/materials = 5, /decl/tech/combat = 4, /decl/tech/engineering = 5)
	materials = alist(/decl/material/steel = 15 MATERIAL_SHEETS, /decl/material/uranium = 5 MATERIAL_SHEETS)
	build_time = 60 SECONDS
	build_path = /obj/item/mecha_part/part/durand/armour
	categories = list("Bulwark", "Durand")

// Archambeau
/datum/design/mechfab/part/archambeau_chassis
	name = "\"Archambeau\" Chassis"
	desc = "The chassis of an Archambeau-type exosuit."
	req_tech = alist(/decl/tech/materials = 7, /decl/tech/combat = 4, /decl/tech/engineering = 6)
	materials = alist(/decl/material/steel = 12.5 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_part/chassis/archambeau
	categories = list("Archambeau")

/datum/design/mechfab/part/archambeau_armour
	name = "\"Archambeau\" Armour"
	desc = "A set of armour plates for an Archambeau-type exosuit."
	req_tech = alist(/decl/tech/materials = 7, /decl/tech/combat = 4, /decl/tech/engineering = 6)
	materials = alist(
		/decl/material/steel = 15 MATERIAL_SHEETS, /decl/material/uranium = 9 MATERIAL_SHEETS,
		/decl/material/plasma = 9 MATERIAL_SHEETS
	)
	build_time = 60 SECONDS
	build_path = /obj/item/mecha_part/part/durand/armour/archambeau
	categories = list("Archambeau")

// Brigand
/datum/design/mechfab/part/brigand_chassis
	name = "\"Brigand\" Chassis"
	desc = "The chassis of a Brigand-type exosuit."
	req_tech = alist(/decl/tech/materials = 6, /decl/tech/combat = 5, /decl/tech/engineering = 6)
	materials = alist(/decl/material/steel = 12.5 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_part/chassis/brigand
	categories = list("Brigand")

/datum/design/mechfab/part/brigand_armour
	name = "\"Brigand\" Armour"
	desc = "A set of armour plates for a Brigand-type exosuit."
	req_tech = alist(/decl/tech/materials = 6, /decl/tech/combat = 5, /decl/tech/engineering = 6)
	materials = alist(
		/decl/material/steel = 15 MATERIAL_SHEETS, /decl/material/diamond = 9 MATERIAL_SHEETS,
		/decl/material/uranium = 9 MATERIAL_SHEETS, /decl/material/plasma = 15 MATERIAL_SHEETS
	)
	build_time = 60 SECONDS
	build_path = /obj/item/mecha_part/part/durand/armour/brigand
	categories = list("Brigand")

// Phazon
/datum/design/mechfab/part/phazon_chassis
	name = "\"Phazon\" Chassis"
	desc = "The chassis of a Phazon-type exosuit."
	req_tech = alist(/decl/tech/materials = 7)
	materials = alist(/decl/material/steel = 10 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_part/chassis/phazon
	categories = list("Phazon")

/datum/design/mechfab/part/phazon_torso
	name = "\"Phazon\" Torso"
	desc = "The torso of a Phazon-type exosuit."
	req_tech = alist(
		/decl/tech/materials = 7, /decl/tech/power_storage = 6, /decl/tech/programming = 5,
		/decl/tech/bluespace = 6
	)
	materials = alist(
		/decl/material/steel = 11 MATERIAL_SHEETS, /decl/material/glass = 5 MATERIAL_SHEETS,
		/decl/material/plasma = 10 MATERIAL_SHEETS
	)
	build_time = 30 SECONDS
	build_path = /obj/item/mecha_part/part/phazon/torso
	categories = list("Phazon")

/datum/design/mechfab/part/phazon_head
	name = "\"Phazon\" Head"
	desc = "The head of a Phazon-type exosuit."
	req_tech = alist(/decl/tech/materials = 5, /decl/tech/magnets = 6, /decl/tech/programming = 4)
	materials = alist(
		/decl/material/steel = 5 MATERIAL_SHEETS, /decl/material/glass = 3 MATERIAL_SHEETS,
		/decl/material/plasma = 10000
	)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/phazon/head
	categories = list("Phazon")

/datum/design/mechfab/part/phazon_left_arm
	name = "\"Phazon\" Left Arm"
	desc = "The left arm of a Phazon-type exosuit."
	req_tech = alist(/decl/tech/materials = 5, /decl/tech/magnets = 2, /decl/tech/bluespace = 2)
	materials = alist(/decl/material/steel = 6 MATERIAL_SHEETS, /decl/material/plasma = 5 MATERIAL_SHEETS)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/phazon/left_arm
	categories = list("Phazon")

/datum/design/mechfab/part/phazon_right_arm
	name = "\"Phazon\" Right Arm"
	desc = "The right arm of a Phazon-type exosuit."
	req_tech = alist(/decl/tech/materials = 5, /decl/tech/magnets = 2, /decl/tech/bluespace = 2)
	materials = alist(/decl/material/steel = 6 MATERIAL_SHEETS, /decl/material/plasma = 5 MATERIAL_SHEETS)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/phazon/right_arm
	categories = list("Phazon")

/datum/design/mechfab/part/phazon_left_leg
	name = "\"Phazon\" Left Leg"
	desc = "The left leg of a Phazon-type exosuit."
	req_tech = alist(/decl/tech/materials = 5, /decl/tech/magnets = 3, /decl/tech/bluespace = 3)
	materials = alist(/decl/material/steel = 6 MATERIAL_SHEETS, /decl/material/plasma = 5 MATERIAL_SHEETS)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/phazon/left_leg
	categories = list("Phazon")

/datum/design/mechfab/part/phazon_right_leg
	name = "\"Phazon\" Right Leg"
	desc = "The right leg of a Phazon-type exosuit."
	req_tech = alist(/decl/tech/materials = 5, /decl/tech/magnets = 3, /decl/tech/bluespace = 3)
	materials = alist(/decl/material/steel = 6 MATERIAL_SHEETS, /decl/material/plasma = 5 MATERIAL_SHEETS)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/phazon/right_leg
	categories = list("Phazon")

/datum/design/mechfab/part/phazon_armour
	name = "\"Phazon\" Armour"
	desc = "A set of armour plates for a Phazon-type exosuit. They are layered with plasma to protect the pilot from the stress of phasing and have unusual properties."
	req_tech = alist(/decl/tech/materials = 7, /decl/tech/magnets = 6, /decl/tech/bluespace = 6)
	materials = alist(/decl/material/steel = 14 MATERIAL_SHEETS, /decl/material/plasma = 9 MATERIAL_SHEETS)
	build_time = 30 SECONDS
	build_path = /obj/item/mecha_part/part/phazon/armour
	categories = list("Phazon")

// H.O.N.K
/datum/design/mechfab/part/honk_chassis
	materials = alist(/decl/material/steel = 10 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_part/chassis/honk
	categories = list("H.O.N.K")

/datum/design/mechfab/part/honk_torso
	materials = alist(
		/decl/material/steel = 11 MATERIAL_SHEETS, /decl/material/glass = 5 MATERIAL_SHEETS,
		/decl/material/bananium = 5 MATERIAL_SHEETS
	)
	build_time = 30 SECONDS
	build_path = /obj/item/mecha_part/part/honk/torso
	categories = list("H.O.N.K")

/datum/design/mechfab/part/honk_head
	materials = alist(
		/decl/material/steel = 5 MATERIAL_SHEETS, /decl/material/glass = 3 MATERIAL_SHEETS,
		/decl/material/bananium = 3 MATERIAL_SHEETS
	)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/honk/head
	categories = list("H.O.N.K")

/datum/design/mechfab/part/honk_left_arm
	materials = alist(/decl/material/steel = 6 MATERIAL_SHEETS, /decl/material/bananium = 3 MATERIAL_SHEETS)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/honk/left_arm
	categories = list("H.O.N.K")

/datum/design/mechfab/part/honk_right_arm
	materials = alist(/decl/material/steel = 6 MATERIAL_SHEETS, /decl/material/bananium = 3 MATERIAL_SHEETS)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/honk/right_arm
	categories = list("H.O.N.K")

/datum/design/mechfab/part/honk_left_leg
	materials = alist(/decl/material/steel = 6 MATERIAL_SHEETS, /decl/material/bananium = 3 MATERIAL_SHEETS)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/honk/left_leg
	categories = list("H.O.N.K")

/datum/design/mechfab/part/honk_right_leg
	materials = alist(/decl/material/steel = 6 MATERIAL_SHEETS, /decl/material/bananium = 3 MATERIAL_SHEETS)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/honk/right_leg
	categories = list("H.O.N.K")

// Reticence
/datum/design/mechfab/part/reticence_chassis
	materials = alist(/decl/material/steel = 10 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_part/chassis/reticence
	categories = list("Reticence")

/datum/design/mechfab/part/reticence_torso
	materials = alist(
		/decl/material/steel = 11 MATERIAL_SHEETS, /decl/material/glass = 5 MATERIAL_SHEETS,
		/decl/material/tranquilite = 5 MATERIAL_SHEETS
	)
	build_time = 30 SECONDS
	build_path = /obj/item/mecha_part/part/reticence/torso
	categories = list("Reticence")

/datum/design/mechfab/part/reticence_head
	materials = alist(
		/decl/material/steel = 5 MATERIAL_SHEETS, /decl/material/glass = 3 MATERIAL_SHEETS,
		/decl/material/tranquilite = 3 MATERIAL_SHEETS
	)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/reticence/head
	categories = list("Reticence")

/datum/design/mechfab/part/reticence_left_arm
	materials = alist(/decl/material/steel = 6 MATERIAL_SHEETS, /decl/material/tranquilite = 3 MATERIAL_SHEETS)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/reticence/left_arm
	categories = list("Reticence")

/datum/design/mechfab/part/reticence_right_arm
	materials = alist(/decl/material/steel = 6 MATERIAL_SHEETS, /decl/material/tranquilite = 3 MATERIAL_SHEETS)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/reticence/right_arm
	categories = list("Reticence")

/datum/design/mechfab/part/reticence_left_leg
	materials = alist(/decl/material/steel = 6 MATERIAL_SHEETS, /decl/material/tranquilite = 3 MATERIAL_SHEETS)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/reticence/left_leg
	categories = list("Reticence")

/datum/design/mechfab/part/reticence_right_leg
	materials = alist(/decl/material/steel = 6 MATERIAL_SHEETS, /decl/material/tranquilite = 3 MATERIAL_SHEETS)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/reticence/right_leg
	categories = list("Reticence")

// Justice (emagged only)
/datum/design/mechfab/part/justice_chassis
	name = "\"Justice\" Chassis"
	materials = alist(/decl/material/steel = 10 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_part/chassis/justice
	categories = list("Justice")
	hidden = TRUE

/datum/design/mechfab/part/justice_torso
	name = "\"Justice\" Torso"
	materials = alist(/decl/material/steel = 11 MATERIAL_SHEETS, /decl/material/silver = 5 MATERIAL_SHEETS)
	build_time = 30 SECONDS
	build_path = /obj/item/mecha_part/part/justice/torso
	categories = list("Justice")
	hidden = TRUE

/datum/design/mechfab/part/justice_left_arm
	name = "\"Justice\" Left Arm"
	materials = alist(/decl/material/steel = 5 MATERIAL_SHEETS, /decl/material/silver = 2 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_part/part/justice/left_arm
	categories = list("Justice")
	hidden = TRUE

/datum/design/mechfab/part/justice_right_arm
	name = "\"Justice\" Right Arm"
	materials = alist(/decl/material/steel = 5 MATERIAL_SHEETS, /decl/material/silver = 2 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_part/part/justice/right_arm
	categories = list("Justice")
	hidden = TRUE

/datum/design/mechfab/part/justice_left_leg
	name = "\"Justice\" Left Leg"
	materials = alist(/decl/material/steel = 5 MATERIAL_SHEETS, /decl/material/silver = 2 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_part/part/justice/left_leg
	categories = list("Justice")
	hidden = TRUE

/datum/design/mechfab/part/justice_right_leg
	name = "\"Justice\" Right Leg"
	materials = alist(/decl/material/steel = 5 MATERIAL_SHEETS, /decl/material/silver = 2 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_part/part/justice/right_leg
	categories = list("Justice")
	hidden = TRUE

/datum/design/mechfab/part/justice_armour
	name = "\"Justice\" Armour"
	materials = alist(
		/decl/material/steel = 10 MATERIAL_SHEETS, /decl/material/plastic = 5 MATERIAL_SHEETS,
		/decl/material/silver = 10 MATERIAL_SHEETS, /decl/material/diamond = 3 MATERIAL_SHEETS
	)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/justice/armour
	categories = list("Justice")
	hidden = TRUE