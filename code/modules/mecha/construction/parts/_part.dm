/////////////////////////
////// Mecha Parts //////
/////////////////////////
/obj/item/mecha_part
	name = "mecha part"
	icon = 'icons/mecha/mech_construct.dmi'
	icon_state = "blank"
	obj_flags = OBJ_FLAG_CONDUCT
	w_class = 5
	origin_tech = list(/datum/tech/materials = 2, /datum/tech/programming = 2)

	var/construction_time = 100
	var/list/construction_cost = list(/decl/material/steel = 20000, /decl/material/glass = 5000)

/obj/item/mecha_part/chassis
	name = "mecha chassis"
	icon_state = "backbone"
	construction_cost = list(/decl/material/steel = 20000)

	var/datum/construction/construct

/obj/item/mecha_part/chassis/attackby(obj/item/W, mob/user)
	if(!construct || !construct.action(W, user))
		. = ..()

/obj/item/mecha_part/chassis/attack_hand()
	return

// Circuit Boards
/obj/item/circuitboard/mecha
	name = "circuit board (Exosuit)"
	icon_state = "std_mod"

	throw_speed = 3
	throw_range = 15

	obj_flags = OBJ_FLAG_CONDUCT
	throwforce = 5
	force = 5

	board_type = "other"