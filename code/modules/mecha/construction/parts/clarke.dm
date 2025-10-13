// Clarke
/obj/item/mecha_part/chassis/clarke
	name = "\improper Clarke chassis"

	construct_type = /datum/construction/mecha_chassis/clarke
	target_icon = 'icons/obj/mecha/construction/clarke.dmi'

/obj/item/mecha_part/part/clarke
	icon = 'icons/obj/mecha/parts/clarke.dmi'

/obj/item/mecha_part/part/clarke/torso
	name = "\improper Clarke torso"
	desc = "The torso of a Clarke-type exosuit. Contains a power unit, processing core and life support systems."
	icon_state = "harness"
	matter_amounts = /datum/design/mechfab/part/clarke_torso::materials
	origin_tech = alist(
		/decl/tech/materials = 2, /decl/tech/biotech = 2, /decl/tech/engineering = 2,
		/decl/tech/programming = 2
	)

/obj/item/mecha_part/part/clarke/head
	name = "\improper Clarke head"
	desc = "The head of a Clarke-type exosuit."
	icon_state = "head"
	matter_amounts = /datum/design/mechfab/part/clarke_head::materials
	origin_tech = /datum/design/mechfab/part/clarke_head::req_tech

/obj/item/mecha_part/part/clarke/left_arm
	name = "\improper Clarke left arm"
	desc = "The left arm of a Clarke-type exosuit. Its data and power sockets are compatible with most exosuit tools."
	icon_state = "l_arm"
	matter_amounts = /datum/design/mechfab/part/clarke_left_arm::materials
	origin_tech = alist(/decl/tech/materials = 2, /decl/tech/engineering = 2, /decl/tech/programming = 2)

/obj/item/mecha_part/part/clarke/right_arm
	name = "\improper Clarke right arm"
	desc = "The right arm of a Clarke-type exosuit. Its data and power sockets are compatible with most exosuit tools."
	icon_state = "r_arm"
	matter_amounts = /datum/design/mechfab/part/clarke_right_arm::materials
	origin_tech = alist(/decl/tech/materials = 2, /decl/tech/engineering = 2, /decl/tech/programming = 2)

/obj/item/mecha_part/part/clarke/treads
	name = "\improper Clarke treads"
	desc = "A set of treads for a Clarke-type exosuit. Finally, one that has caterpillar tracks instead of legs!"
	icon_state = "treads"
	matter_amounts = /datum/design/mechfab/part/clarke_treads::materials
	origin_tech = /datum/design/mechfab/part/clarke_treads::req_tech

// Circuit Boards
/obj/item/circuitboard/mecha/clarke
	matter_amounts = /datum/design/circuit/mecha/clarke::materials
	origin_tech = /datum/design/circuit/mecha/clarke::req_tech

/obj/item/circuitboard/mecha/clarke/main
	name = "circuit board (\"Clarke\" central control module)"

/obj/item/circuitboard/mecha/clarke/peripherals
	name = "circuit board (\"Clarke\" peripherals control module)"
	icon_state = "mcontroller"