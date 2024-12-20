/////////////////////////////////
////////// Mecha Parts //////////
/////////////////////////////////
// Phazon
/datum/design/phazon_chassis
	name = "Exosuit Design (\"Phazon\" chassis)"
	desc = "The chassis of a Phazon-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 7)
	build_path = /obj/item/mecha_part/chassis/phazon
	category = "Phazon"

/datum/design/phazon_torso
	name = "Exosuit Design (\"Phazon\" torso)"
	desc = "The torso of a Phazon-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(
		/datum/tech/materials = 7, /datum/tech/power_storage = 6, /datum/tech/programming = 5,
		/datum/tech/bluespace = 6
	)
	build_path = /obj/item/mecha_part/part/phazon_torso
	category = "Phazon"

/datum/design/phazon_head
	name = "Exosuit Design (\"Phazon\" head)"
	desc = "The head of a Phazon-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 6, /datum/tech/programming = 4)
	build_path = /obj/item/mecha_part/part/phazon_head
	category = "Phazon"

/datum/design/phazon_left_arm
	name = "Exosuit Design (\"Phazon\" left arm)"
	desc = "The left arm of a Phazon-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 2, /datum/tech/bluespace = 2)
	build_path = /obj/item/mecha_part/part/phazon_left_arm
	category = "Phazon"

/datum/design/phazon_right_arm
	name = "Exosuit Design (\"Phazon\" right arm)"
	desc = "The right arm of a Phazon-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 2, /datum/tech/bluespace = 2)
	build_path = /obj/item/mecha_part/part/phazon_right_arm
	category = "Phazon"

/datum/design/phazon_left_leg
	name = "Exosuit Design (\"Phazon\" left leg)"
	desc = "The left leg of a Phazon-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 3, /datum/tech/bluespace = 3)
	build_path = /obj/item/mecha_part/part/phazon_left_leg
	category = "Phazon"

/datum/design/phazon_right_leg
	name = "Exosuit Design (\"Phazon\" right leg)"
	desc = "The right leg of a Phazon-type exosuit."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 3, /datum/tech/bluespace = 3)
	build_path = /obj/item/mecha_part/part/phazon_right_leg
	category = "Phazon"

/datum/design/phazon_armour
	name = "Exosuit Design (\"Phazon\" armour)"
	desc = "A set of armour plates for a Phazon-type exosuit. They are layered with plasma to protect the pilot from the stress of phasing and have unusual properties."
	build_type = DESIGN_TYPE_MECHFAB
	req_tech = list(/datum/tech/materials = 7, /datum/tech/magnets = 6, /datum/tech/bluespace = 6)
	build_path = /obj/item/mecha_part/part/phazon_armour
	category = "Phazon"