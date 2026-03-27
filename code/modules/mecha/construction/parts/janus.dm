// Janus
/obj/item/mecha_part/chassis/janus
	name = "\improper Janus chassis"
	desc = "The chassis of a Janus-type exosuit."

	matter_amounts = /datum/design/mechfab/part/janus_chassis::materials
	origin_tech = /datum/design/mechfab/part/janus_chassis::req_tech

	construct_type = /datum/component/construction/mecha_chassis/janus
	target_icon = 'icons/obj/mecha/construction/janus.dmi'

/obj/item/mecha_part/part/janus
	icon = 'icons/obj/mecha/parts/janus.dmi'

/obj/item/mecha_part/part/janus/torso
	name = "\improper prototype Imperion torso"
	desc = "The torso of a prototype Imperion-type exosuit."
	icon_state = "harness"
	matter_amounts = /datum/design/mechfab/part/janus_torso::materials
	origin_tech = /datum/design/mechfab/part/janus_torso::req_tech

/obj/item/mecha_part/part/janus/head
	name = "\improper prototype Imperion head"
	desc = "The head of a prototype Imperion-type exosuit."
	icon_state = "head"
	matter_amounts = /datum/design/mechfab/part/janus_head::materials
	origin_tech = /datum/design/mechfab/part/janus_head::req_tech

/obj/item/mecha_part/part/janus/left_arm
	name = "\improper prototype Gygax left arm"
	desc = "The left arm of a prototype Gygax-type exosuit."
	icon_state = "l_arm"
	matter_amounts = /datum/design/mechfab/part/janus_left_arm::materials
	origin_tech = /datum/design/mechfab/part/janus_left_arm::req_tech

/obj/item/mecha_part/part/janus/right_arm
	name = "\improper prototype Gygax right arm"
	desc = "The right arm of a prototype Gygax-type exosuit."
	icon_state = "r_arm"
	matter_amounts = /datum/design/mechfab/part/janus_right_arm::materials
	origin_tech = /datum/design/mechfab/part/janus_right_arm::req_tech

/obj/item/mecha_part/part/janus/left_leg
	name = "\improper prototype Durand left leg"
	desc = "The left leg of a prototype Durand-type exosuit."
	icon_state = "l_leg"
	matter_amounts = /datum/design/mechfab/part/janus_left_leg::materials
	origin_tech = /datum/design/mechfab/part/janus_left_leg::req_tech

/obj/item/mecha_part/part/janus/right_leg
	name = "\improper prototype Durand right leg"
	desc = "The right leg of a prototype Durand-type exosuit."
	icon_state = "r_leg"
	matter_amounts = /datum/design/mechfab/part/janus_right_leg::materials
	origin_tech = /datum/design/mechfab/part/janus_right_leg::req_tech

// Circuit Boards
/obj/item/circuitboard/mecha/imperion
	name = "alien circuit"
	icon = 'icons/obj/mecha/parts/janus.dmi'
	icon_state = "circuit"
	matter_amounts = alist(/decl/material/morphium = 1 MATERIAL_SHEET)
	origin_tech = alist(/decl/tech/programming = 5, /decl/tech/bluespace = 3)

/obj/item/circuitboard/mecha/imperion/main
	desc = "It is marked with a <span class='alien'>strange glyph</span>."

/obj/item/circuitboard/mecha/imperion/peripherals
	desc = "It is marked with a <span class='alien'>pulsing glyph</span>."

/obj/item/circuitboard/mecha/imperion/targeting
	desc = "It is marked with an <span class='alien'>ominous glyph</span>."

/obj/item/circuitboard/mecha/imperion/phasing
	desc = "It is marked with a <span class='alien'>disturbing glyph</span>."

// Miscellaneous
/obj/item/prop/alien/phase_coil
	name = "reverberating device"
	desc = "A device pulsing with an ominous energy."
	icon = 'icons/obj/mecha/parts/janus.dmi'
	icon_state = "circuit_phase"
	origin_tech = alist(
		/decl/tech/materials = 5, /decl/tech/magnets = 5, /decl/tech/engineering = 6,
		/decl/tech/power_storage = 5, /decl/tech/programming = 5, /decl/tech/plasma = 3,
		/decl/tech/arcane = 1
	)