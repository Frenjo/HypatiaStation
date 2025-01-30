/////////////////////////////////
////////// Mecha Parts //////////
/////////////////////////////////
// Ripley (and friends) Chassis
/datum/design/mechfab/ripley_chassis
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6)
	build_path = /obj/item/mecha_part/chassis/ripley
	categories = list("Ripley")

/datum/design/mechfab/firefighter_chassis
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6)
	build_path = /obj/item/mecha_part/chassis/firefighter
	categories = list("Firefighter")

/datum/design/mechfab/rescue_ranger_chassis
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6)
	build_path = /obj/item/mecha_part/chassis/rescue_ranger
	categories = list("Rescue Ranger")

/datum/design/mechfab/dreadnought_chassis
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6)
	build_path = /obj/item/mecha_part/chassis/dreadnought
	categories = list("Dreadnought")

/datum/design/mechfab/bulwark_chassis
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6)
	build_path = /obj/item/mecha_part/chassis/bulwark
	categories = list("Bulwark")

// Ripley
/datum/design/mechfab/ripley_torso
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 12, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 8)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/ripley/torso
	categories = list("Ripley", "Firefighter", "Rescue Ranger", "Dreadnought", "Bulwark")

/datum/design/mechfab/ripley_left_arm
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 8)
	build_time = 15 SECONDS
	build_path = /obj/item/mecha_part/part/ripley/left_arm
	categories = list("Ripley", "Firefighter", "Rescue Ranger", "Dreadnought", "Bulwark")

/datum/design/mechfab/ripley_right_arm
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 8)
	build_time = 15 SECONDS
	build_path = /obj/item/mecha_part/part/ripley/right_arm
	categories = list("Ripley", "Firefighter", "Rescue Ranger", "Dreadnought", "Bulwark")

/datum/design/mechfab/ripley_left_leg
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 9)
	build_time = 15 SECONDS
	build_path = /obj/item/mecha_part/part/ripley/left_leg
	categories = list("Ripley", "Firefighter", "Rescue Ranger", "Dreadnought", "Bulwark")

/datum/design/mechfab/ripley_right_leg
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 9)
	build_time = 15 SECONDS
	build_path = /obj/item/mecha_part/part/ripley/right_leg
	categories = list("Ripley", "Firefighter", "Rescue Ranger", "Dreadnought", "Bulwark")

// Odysseus
/datum/design/mechfab/odysseus_chassis
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6)
	build_path = /obj/item/mecha_part/chassis/odysseus
	categories = list("Odysseus")

/datum/design/mechfab/odysseus_torso
	name = "Exosuit Design (\"Odysseus\" torso)"
	desc = "The torso of an Odysseus-type exosuit."
	req_tech = list(
		/datum/tech/materials = 2, /datum/tech/biotech = 2, /datum/tech/engineering = 2,
		/datum/tech/programming = 2
	)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 8)
	build_time = 18 SECONDS
	build_path = /obj/item/mecha_part/part/odysseus/torso
	categories = list("Odysseus")

/datum/design/mechfab/odysseus_head
	name = "Exosuit Design (\"Odysseus\" head)"
	desc = "The head of an Odysseus-type exosuit."
	req_tech = list(/datum/tech/materials = 2, /datum/tech/programming = 3)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 3, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 5)
	build_path = /obj/item/mecha_part/part/odysseus/head
	categories = list("Odysseus")

/datum/design/mechfab/odysseus_left_arm
	name = "Exosuit Design (\"Odysseus\" left arm)"
	desc = "The left arm of an Odysseus-type exosuit."
	req_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 2, /datum/tech/programming = 2)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 3)
	build_time = 12 SECONDS
	build_path = /obj/item/mecha_part/part/odysseus/left_arm
	categories = list("Odysseus")

/datum/design/mechfab/odysseus_right_arm
	name = "Exosuit Design (\"Odysseus\" right arm)"
	desc = "The right arm of an Odysseus-type exosuit."
	req_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 2, /datum/tech/programming = 2)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 3)
	build_time = 12 SECONDS
	build_path = /obj/item/mecha_part/part/odysseus/right_arm
	categories = list("Odysseus")

/datum/design/mechfab/odysseus_left_leg
	name = "Exosuit Design (\"Odysseus\" left leg)"
	desc = "The left leg of an Odysseus-type exosuit."
	req_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 2, /datum/tech/programming = 2)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5)
	build_time = 13 SECONDS
	build_path = /obj/item/mecha_part/part/odysseus/left_leg
	categories = list("Odysseus")

/datum/design/mechfab/odysseus_right_leg
	name = "Exosuit Design (\"Odysseus\" right leg)"
	desc = "The right leg of an Odysseus-type exosuit."
	req_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 2, /datum/tech/programming = 2)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5)
	build_time = 13 SECONDS
	build_path = /obj/item/mecha_part/part/odysseus/right_leg
	categories = list("Odysseus")

/datum/design/mechfab/odysseus_carapace
	name = "Exosuit Design (\"Odysseus\" carapace)"
	desc = "The external carapace of an Odysseus-type exosuit."
	req_tech = list(/datum/tech/materials = 3, /datum/tech/engineering = 3)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5, /decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 3)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/odysseus/carapace
	categories = list("Odysseus")

// Gygax
/datum/design/mechfab/gygax_chassis
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 8)
	build_path = /obj/item/mecha_part/chassis/gygax
	categories = list("Gygax")

/datum/design/mechfab/gygax_torso
	name = "Exosuit Design (\"Gygax\" torso)"
	desc = "The torso of a Gygax-type exosuit."
	req_tech = list(
		/datum/tech/materials = 2, /datum/tech/biotech = 3, /datum/tech/engineering = 3,
		/datum/tech/programming = 2
	)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 15, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 10)
	build_time = 30 SECONDS
	build_path = /obj/item/mecha_part/part/gygax/torso
	categories = list("Gygax", "Serenity")

/datum/design/mechfab/gygax_head
	name = "Exosuit Design (\"Gygax\" head)"
	desc = "The head of a Gygax-type exosuit."
	req_tech = list(
		/datum/tech/materials = 2, /datum/tech/magnets = 3, /datum/tech/engineering = 3,
		/datum/tech/programming = 2
	)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 5)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/gygax/head
	categories = list("Gygax", "Serenity")

/datum/design/mechfab/gygax_left_arm
	name = "Exosuit Design (\"Gygax\" left arm)"
	desc = "The left arm of a Gygax-type exosuit."
	req_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 3, /datum/tech/programming = 2)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 9)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/gygax/left_arm
	categories = list("Gygax", "Serenity")

/datum/design/mechfab/gygax_right_arm
	name = "Exosuit Design (\"Gygax\" right arm)"
	desc = "The right arm of a Gygax-type exosuit."
	req_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 3, /datum/tech/programming = 2)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 9)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/gygax/right_arm
	categories = list("Gygax", "Serenity")

/datum/design/mechfab/gygax_left_leg
	name = "Exosuit Design (\"Gygax\" left leg)"
	desc = "The left leg of a Gygax-type exosuit."
	req_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 3, /datum/tech/programming = 2)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 11)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/gygax/left_leg
	categories = list("Gygax", "Serenity")

/datum/design/mechfab/gygax_right_leg
	name = "Exosuit Design (\"Gygax\" right leg)"
	desc = "The right leg of a Gygax-type exosuit."
	req_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 3, /datum/tech/programming = 2)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 11)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/gygax/right_leg
	categories = list("Gygax", "Serenity")

/datum/design/mechfab/gygax_armour
	name = "Exosuit Design (\"Gygax\" armour)"
	desc = "A set of armour plates for a Gygax-type exosuit."
	req_tech = list(/datum/tech/materials = 6, /datum/tech/combat = 4, /datum/tech/engineering = 5)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 8, /decl/material/diamond = MATERIAL_AMOUNT_PER_SHEET * 5)
	build_time = 60 SECONDS
	build_path = /obj/item/mecha_part/part/gygax/armour
	categories = list("Gygax")

// Serenity
/datum/design/mechfab/serenity_chassis
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 8)
	build_path = /obj/item/mecha_part/chassis/serenity
	categories = list("Serenity")

/datum/design/mechfab/serenity_carapace
	name = "Exosuit Design (\"Serenity\" carapace)"
	desc = "The external carapace of a Serenity-type exosuit."
	req_tech = list(/datum/tech/materials = 4, /datum/tech/engineering = 4)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5, /decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 3)
	build_time = 40 SECONDS
	build_path = /obj/item/mecha_part/part/gygax/armour/serenity
	categories = list("Serenity")

// Durand
/datum/design/mechfab/durand_chassis
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 8)
	build_path = /obj/item/mecha_part/chassis/durand
	categories = list("Durand")

/datum/design/mechfab/durand_torso
	name = "Exosuit Design (\"Durand\" torso)"
	desc = "The torso of a Durand-type exosuit."
	req_tech = list(
		/datum/tech/materials = 3, /datum/tech/biotech = 3, /datum/tech/engineering = 3,
		/datum/tech/programming = 2
	)
	materials = list(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 17, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 10,
		/decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 5
	)
	build_time = 30 SECONDS
	build_path = /obj/item/mecha_part/part/durand/torso
	categories = list("Durand", "Archambeau")

/datum/design/mechfab/durand_head
	name = "Exosuit Design (\"Durand\" head)"
	desc = "The head of a Durand-type exosuit."
	req_tech = list(
		/datum/tech/materials = 3, /datum/tech/magnets = 3, /datum/tech/engineering = 3,
		/datum/tech/programming = 2
	)
	materials = list(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 8, MATERIAL_AMOUNT_PER_SHEET * 5,
		/decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 2
	)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/durand/head
	categories = list("Durand", "Archambeau")

/datum/design/mechfab/durand_left_arm
	name = "Exosuit Design (\"Durand\" left arm)"
	desc = "The left arm of a Durand-type exosuit."
	req_tech = list(/datum/tech/materials = 3, /datum/tech/engineering = 3, /datum/tech/programming = 2)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 11, /decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 2)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/durand/left_arm
	categories = list("Durand", "Archambeau")

/datum/design/mechfab/durand_right_arm
	name = "Exosuit Design (\"Durand\" right arm)"
	desc = "The right arm of a Durand-type exosuit."
	req_tech = list(/datum/tech/materials = 3, /datum/tech/engineering = 3, /datum/tech/programming = 2)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 11, /decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 2)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/durand/right_arm
	categories = list("Durand", "Archambeau")

/datum/design/mechfab/durand_left_leg
	name = "Exosuit Design (\"Durand\" left leg)"
	desc = "The left leg of a Durand-type exosuit."
	req_tech = list(/datum/tech/materials = 3, /datum/tech/engineering = 3, /datum/tech/programming = 2)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 12, /decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 2)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/durand/left_leg
	categories = list("Durand", "Archambeau")

/datum/design/mechfab/durand_right_leg
	name = "Exosuit Design (\"Durand\" right leg)"
	desc = "The right leg of a Durand-type exosuit."
	req_tech = list(/datum/tech/materials = 3, /datum/tech/engineering = 3, /datum/tech/programming = 2)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 12, /decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 2)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/durand/right_leg
	categories = list("Durand", "Archambeau")

/datum/design/mechfab/durand_armour
	name = "Exosuit Design (\"Durand\" armour)"
	desc = "A set of armour plates for a Durand-type exosuit."
	req_tech = list(/datum/tech/materials = 5, /datum/tech/combat = 4, /datum/tech/engineering = 5)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 15, /decl/material/uranium = MATERIAL_AMOUNT_PER_SHEET * 5)
	build_time = 60 SECONDS
	build_path = /obj/item/mecha_part/part/durand/armour
	categories = list("Bulwark", "Durand")

// Archambeau
/datum/design/mechfab/archambeau_chassis
	name = "Exosuit Design (\"Archambeau\" chassis)"
	desc = "The chassis of an Archambeau-type exosuit."
	req_tech = list(/datum/tech/materials = 7)
	build_path = /obj/item/mecha_part/chassis/archambeau
	categories = list("Archambeau")

/datum/design/mechfab/archambeau_armour
	name = "Exosuit Design (\"Archambeau\" armour)"
	desc = "A set of armour plates for an Archambeau-type exosuit."
	req_tech = list(/datum/tech/materials = 7, /datum/tech/combat = 4, /datum/tech/engineering = 6)
	materials = list(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 15, /decl/material/uranium = MATERIAL_AMOUNT_PER_SHEET * 9,
		/decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 9
	)
	build_time = 60 SECONDS
	build_path = /obj/item/mecha_part/part/durand/armour/archambeau
	categories = list("Archambeau")

// Phazon
/datum/design/mechfab/phazon_chassis
	name = "Exosuit Design (\"Phazon\" chassis)"
	desc = "The chassis of a Phazon-type exosuit."
	req_tech = list(/datum/tech/materials = 7)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6)
	build_path = /obj/item/mecha_part/chassis/phazon
	categories = list("Phazon")

/datum/design/mechfab/phazon_torso
	name = "Exosuit Design (\"Phazon\" torso)"
	desc = "The torso of a Phazon-type exosuit."
	req_tech = list(
		/datum/tech/materials = 7, /datum/tech/power_storage = 6, /datum/tech/programming = 5,
		/datum/tech/bluespace = 6
	)
	materials = list(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 11, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 5,
		/decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 10
	)
	build_time = 30 SECONDS
	build_path = /obj/item/mecha_part/part/phazon/torso
	categories = list("Phazon")

/datum/design/mechfab/phazon_head
	name = "Exosuit Design (\"Phazon\" head)"
	desc = "The head of a Phazon-type exosuit."
	req_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 6, /datum/tech/programming = 4)
	materials = list(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 3,
		/decl/material/plasma = 10000
	)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/phazon/head
	categories = list("Phazon")

/datum/design/mechfab/phazon_left_arm
	name = "Exosuit Design (\"Phazon\" left arm)"
	desc = "The left arm of a Phazon-type exosuit."
	req_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 2, /datum/tech/bluespace = 2)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6, /decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 5)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/phazon/left_arm
	categories = list("Phazon")

/datum/design/mechfab/phazon_right_arm
	name = "Exosuit Design (\"Phazon\" right arm)"
	desc = "The right arm of a Phazon-type exosuit."
	req_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 2, /datum/tech/bluespace = 2)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6, /decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 5)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/phazon/right_arm
	categories = list("Phazon")

/datum/design/mechfab/phazon_left_leg
	name = "Exosuit Design (\"Phazon\" left leg)"
	desc = "The left leg of a Phazon-type exosuit."
	req_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 3, /datum/tech/bluespace = 3)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6, /decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 5)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/phazon/left_leg
	categories = list("Phazon")

/datum/design/mechfab/phazon_right_leg
	name = "Exosuit Design (\"Phazon\" right leg)"
	desc = "The right leg of a Phazon-type exosuit."
	req_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 3, /datum/tech/bluespace = 3)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6, /decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 5)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/phazon/right_leg
	categories = list("Phazon")

/datum/design/mechfab/phazon_armour
	name = "Exosuit Design (\"Phazon\" armour)"
	desc = "A set of armour plates for a Phazon-type exosuit. They are layered with plasma to protect the pilot from the stress of phasing and have unusual properties."
	req_tech = list(/datum/tech/materials = 7, /datum/tech/magnets = 6, /datum/tech/bluespace = 6)
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 14, /decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 9)
	build_time = 30 SECONDS
	build_path = /obj/item/mecha_part/part/phazon/armour
	categories = list("Phazon")

// H.O.N.K
/datum/design/mechfab/honk_chassis
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6)
	build_path = /obj/item/mecha_part/chassis/honk
	categories = list("H.O.N.K")

/datum/design/mechfab/honk_torso
	materials = list(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 11, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 5,
		/decl/material/bananium = MATERIAL_AMOUNT_PER_SHEET * 5
	)
	build_time = 30 SECONDS
	build_path = /obj/item/mecha_part/part/honk/torso
	categories = list("H.O.N.K")

/datum/design/mechfab/honk_head
	materials = list(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 3,
		/decl/material/bananium = MATERIAL_AMOUNT_PER_SHEET * 3
	)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/honk/head
	categories = list("H.O.N.K")

/datum/design/mechfab/honk_left_arm
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6, /decl/material/bananium = MATERIAL_AMOUNT_PER_SHEET * 3)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/honk/left_arm
	categories = list("H.O.N.K")

/datum/design/mechfab/honk_right_arm
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6, /decl/material/bananium = MATERIAL_AMOUNT_PER_SHEET * 3)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/honk/right_arm
	categories = list("H.O.N.K")

/datum/design/mechfab/honk_left_leg
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6, /decl/material/bananium = MATERIAL_AMOUNT_PER_SHEET * 3)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/honk/left_leg
	categories = list("H.O.N.K")

/datum/design/mechfab/honk_right_leg
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6, /decl/material/bananium = MATERIAL_AMOUNT_PER_SHEET * 3)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/honk/right_leg
	categories = list("H.O.N.K")

// Reticence
/datum/design/mechfab/reticence_chassis
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6)
	build_path = /obj/item/mecha_part/chassis/reticence
	categories = list("Reticence")

/datum/design/mechfab/reticence_torso
	materials = list(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 11, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 5,
		/decl/material/bananium = MATERIAL_AMOUNT_PER_SHEET * 5
	) // Bananium is a placeholder for tranquilite.
	build_time = 30 SECONDS
	build_path = /obj/item/mecha_part/part/reticence/torso
	categories = list("Reticence")

/datum/design/mechfab/reticence_head
	materials = list(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 3,
		/decl/material/bananium = MATERIAL_AMOUNT_PER_SHEET * 3
	)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/reticence/head
	categories = list("Reticence")

/datum/design/mechfab/reticence_left_arm
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6, /decl/material/bananium = MATERIAL_AMOUNT_PER_SHEET * 3)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/reticence/left_arm
	categories = list("Reticence")

/datum/design/mechfab/reticence_right_arm
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6, /decl/material/bananium = MATERIAL_AMOUNT_PER_SHEET * 3)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/reticence/right_arm
	categories = list("Reticence")

/datum/design/mechfab/reticence_left_leg
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6, /decl/material/bananium = MATERIAL_AMOUNT_PER_SHEET * 3)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/reticence/left_leg
	categories = list("Reticence")

/datum/design/mechfab/reticence_right_leg
	materials = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6, /decl/material/bananium = MATERIAL_AMOUNT_PER_SHEET * 3)
	build_time = 20 SECONDS
	build_path = /obj/item/mecha_part/part/reticence/right_leg
	categories = list("Reticence")