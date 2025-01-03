/////////////////////////////////
////////// Mecha Parts //////////
/////////////////////////////////
// Odysseus
/datum/design/odysseus_torso
	name = "Exosuit Design (\"Odysseus\" torso)"
	desc = "The torso of an Odysseus-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(
		/datum/tech/materials = 2, /datum/tech/biotech = 2, /datum/tech/engineering = 2,
		/datum/tech/programming = 2
	)
	build_path = /obj/item/mecha_part/part/odysseus_torso
	categories = list("Odysseus")

/datum/design/odysseus_head
	name = "Exosuit Design (\"Odysseus\" head)"
	desc = "The head of an Odysseus-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 2, /datum/tech/programming = 3)
	build_path = /obj/item/mecha_part/part/odysseus_head
	categories = list("Odysseus")

/datum/design/odysseus_left_arm
	name = "Exosuit Design (\"Odysseus\" left arm)"
	desc = "The left arm of an Odysseus-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 2, /datum/tech/programming = 2)
	build_path = /obj/item/mecha_part/part/odysseus_left_arm
	categories = list("Odysseus")

/datum/design/odysseus_right_arm
	name = "Exosuit Design (\"Odysseus\" right arm)"
	desc = "The right arm of an Odysseus-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 2, /datum/tech/programming = 2)
	build_path = /obj/item/mecha_part/part/odysseus_right_arm
	categories = list("Odysseus")

/datum/design/odysseus_left_leg
	name = "Exosuit Design (\"Odysseus\" left leg)"
	desc = "The left leg of an Odysseus-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 2, /datum/tech/programming = 2)
	build_path = /obj/item/mecha_part/part/odysseus_left_leg
	categories = list("Odysseus")

/datum/design/odysseus_right_leg
	name = "Exosuit Design (\"Odysseus\" right leg)"
	desc = "The right leg of an Odysseus-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 2, /datum/tech/programming = 2)
	build_path = /obj/item/mecha_part/part/odysseus_right_leg
	categories = list("Odysseus")

/datum/design/odysseus_carapace
	name = "Exosuit Design (\"Odysseus\" carapace)"
	desc = "The external carapace of an Odysseus-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 3, /datum/tech/engineering = 3)
	build_path = /obj/item/mecha_part/part/odysseus_carapace
	categories = list("Odysseus")

// Gygax
/datum/design/gygax_torso
	name = "Exosuit Design (\"Gygax\" torso)"
	desc = "The torso of a Gygax-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(
		/datum/tech/materials = 2, /datum/tech/biotech = 3, /datum/tech/engineering = 3,
		/datum/tech/programming = 2
	)
	build_path = /obj/item/mecha_part/part/gygax_torso
	categories = list("Serenity", "Gygax")

/datum/design/gygax_head
	name = "Exosuit Design (\"Gygax\" head)"
	desc = "The head of a Gygax-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(
		/datum/tech/materials = 2, /datum/tech/magnets = 3, /datum/tech/engineering = 3,
		/datum/tech/programming = 2
	)
	build_path = /obj/item/mecha_part/part/gygax_head
	categories = list("Serenity", "Gygax")

/datum/design/gygax_left_arm
	name = "Exosuit Design (\"Gygax\" left arm)"
	desc = "The left arm of a Gygax-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 3, /datum/tech/programming = 2)
	build_path = /obj/item/mecha_part/part/gygax_left_arm
	categories = list("Serenity", "Gygax")

/datum/design/gygax_right_arm
	name = "Exosuit Design (\"Gygax\" right arm)"
	desc = "The right arm of a Gygax-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 3, /datum/tech/programming = 2)
	build_path = /obj/item/mecha_part/part/gygax_right_arm
	categories = list("Serenity", "Gygax")

/datum/design/gygax_left_leg
	name = "Exosuit Design (\"Gygax\" left leg)"
	desc = "The left leg of a Gygax-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 3, /datum/tech/programming = 2)
	build_path = /obj/item/mecha_part/part/gygax_left_leg
	categories = list("Serenity", "Gygax")

/datum/design/gygax_right_leg
	name = "Exosuit Design (\"Gygax\" right leg)"
	desc = "The right leg of a Gygax-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 3, /datum/tech/programming = 2)
	build_path = /obj/item/mecha_part/part/gygax_right_leg
	categories = list("Serenity", "Gygax")

/datum/design/gygax_armour
	name = "Exosuit Design (\"Gygax\" armour)"
	desc = "A set of armour plates for a Gygax-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 6, /datum/tech/combat = 4, /datum/tech/engineering = 5)
	build_path = /obj/item/mecha_part/part/gygax_armour
	categories = list("Gygax")

// Serenity
/datum/design/serenity_carapace
	name = "Exosuit Design (\"Serenity\" carapace)"
	desc = "The external carapace of a Serenity-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 4, /datum/tech/engineering = 4)
	build_path = /obj/item/mecha_part/part/serenity_carapace
	categories = list("Serenity")

// Durand
/datum/design/durand_torso
	name = "Exosuit Design (\"Durand\" torso)"
	desc = "The torso of a Durand-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(
		/datum/tech/materials = 3, /datum/tech/biotech = 3, /datum/tech/engineering = 3,
		/datum/tech/programming = 2
	)
	build_path = /obj/item/mecha_part/part/durand_torso
	categories = list("Durand", "Archambeau")

/datum/design/durand_head
	name = "Exosuit Design (\"Durand\" head)"
	desc = "The head of a Durand-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(
		/datum/tech/materials = 3, /datum/tech/magnets = 3, /datum/tech/engineering = 3,
		/datum/tech/programming = 2
	)
	build_path = /obj/item/mecha_part/part/durand_head
	categories = list("Durand", "Archambeau")

/datum/design/durand_left_arm
	name = "Exosuit Design (\"Durand\" left arm)"
	desc = "The left arm of a Durand-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 3, /datum/tech/engineering = 3, /datum/tech/programming = 2)
	build_path = /obj/item/mecha_part/part/durand_left_arm
	categories = list("Durand", "Archambeau")

/datum/design/durand_right_arm
	name = "Exosuit Design (\"Durand\" right arm)"
	desc = "The right arm of a Durand-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 3, /datum/tech/engineering = 3, /datum/tech/programming = 2)
	build_path = /obj/item/mecha_part/part/durand_right_arm
	categories = list("Durand", "Archambeau")

/datum/design/durand_left_leg
	name = "Exosuit Design (\"Durand\" left leg)"
	desc = "The left leg of a Durand-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 3, /datum/tech/engineering = 3, /datum/tech/programming = 2)
	build_path = /obj/item/mecha_part/part/durand_left_leg
	categories = list("Durand", "Archambeau")

/datum/design/durand_right_leg
	name = "Exosuit Design (\"Durand\" right leg)"
	desc = "The right leg of a Durand-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 3, /datum/tech/engineering = 3, /datum/tech/programming = 2)
	build_path = /obj/item/mecha_part/part/durand_right_leg
	categories = list("Durand", "Archambeau")

/datum/design/durand_armour
	name = "Exosuit Design (\"Durand\" armour)"
	desc = "A set of armour plates for a Durand-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 5, /datum/tech/combat = 4, /datum/tech/engineering = 5)
	build_path = /obj/item/mecha_part/part/durand_armour
	categories = list("Bulwark", "Durand")

// Archambeau
/datum/design/archambeau_chassis
	name = "Exosuit Design (\"Archambeau\" chassis)"
	desc = "The chassis of an Archambeau-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 7)
	build_path = /obj/item/mecha_part/chassis/archambeau
	categories = list("Archambeau")

/datum/design/archambeau_armour
	name = "Exosuit Design (\"Archambeau\" armour)"
	desc = "A set of armour plates for an Archambeau-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 7, /datum/tech/combat = 4, /datum/tech/engineering = 6)
	build_path = /obj/item/mecha_part/part/archambeau_armour
	categories = list("Archambeau")

// Phazon
/datum/design/phazon_chassis
	name = "Exosuit Design (\"Phazon\" chassis)"
	desc = "The chassis of a Phazon-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 7)
	build_path = /obj/item/mecha_part/chassis/phazon
	categories = list("Phazon")

/datum/design/phazon_torso
	name = "Exosuit Design (\"Phazon\" torso)"
	desc = "The torso of a Phazon-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(
		/datum/tech/materials = 7, /datum/tech/power_storage = 6, /datum/tech/programming = 5,
		/datum/tech/bluespace = 6
	)
	build_path = /obj/item/mecha_part/part/phazon_torso
	categories = list("Phazon")

/datum/design/phazon_head
	name = "Exosuit Design (\"Phazon\" head)"
	desc = "The head of a Phazon-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 6, /datum/tech/programming = 4)
	build_path = /obj/item/mecha_part/part/phazon_head
	categories = list("Phazon")

/datum/design/phazon_left_arm
	name = "Exosuit Design (\"Phazon\" left arm)"
	desc = "The left arm of a Phazon-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 2, /datum/tech/bluespace = 2)
	build_path = /obj/item/mecha_part/part/phazon_left_arm
	categories = list("Phazon")

/datum/design/phazon_right_arm
	name = "Exosuit Design (\"Phazon\" right arm)"
	desc = "The right arm of a Phazon-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 2, /datum/tech/bluespace = 2)
	build_path = /obj/item/mecha_part/part/phazon_right_arm
	categories = list("Phazon")

/datum/design/phazon_left_leg
	name = "Exosuit Design (\"Phazon\" left leg)"
	desc = "The left leg of a Phazon-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 3, /datum/tech/bluespace = 3)
	build_path = /obj/item/mecha_part/part/phazon_left_leg
	categories = list("Phazon")

/datum/design/phazon_right_leg
	name = "Exosuit Design (\"Phazon\" right leg)"
	desc = "The right leg of a Phazon-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 3, /datum/tech/bluespace = 3)
	build_path = /obj/item/mecha_part/part/phazon_right_leg
	categories = list("Phazon")

/datum/design/phazon_armour
	name = "Exosuit Design (\"Phazon\" armour)"
	desc = "A set of armour plates for a Phazon-type exosuit. They are layered with plasma to protect the pilot from the stress of phasing and have unusual properties."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 7, /datum/tech/magnets = 6, /datum/tech/bluespace = 6)
	build_path = /obj/item/mecha_part/part/phazon_armour
	categories = list("Phazon")