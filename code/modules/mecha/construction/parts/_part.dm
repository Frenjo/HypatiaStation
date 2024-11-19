/////////////////////////
////// Mecha Parts //////
/////////////////////////
/obj/item/mecha_part
	name = "mecha part"
	icon = 'icons/mecha/mech_construct.dmi'
	icon_state = "blank"
	w_class = 5
	obj_flags = OBJ_FLAG_CONDUCT
	origin_tech = list(/datum/tech/programming = 2, RESEARCH_MATERIAL = 2)
	var/construction_time = 100
	var/list/construction_cost = list(/decl/material/steel = 20000, /decl/material/glass = 5000)

/obj/item/mecha_part/chassis
	name = "mecha chassis"
	icon_state = "backbone"
	var/datum/construction/construct
	construction_cost = list(/decl/material/steel = 20000)

/obj/item/mecha_part/chassis/attackby(obj/item/W, mob/user)
	if(!construct || !construct.action(W, user))
		..()
	return

/obj/item/mecha_part/chassis/attack_hand()
	return

// Circuit Boards
/obj/item/circuitboard/mecha
	name = "circuit board (Exosuit)"
	icon = 'icons/obj/items/module.dmi'
	icon_state = "std_mod"
	item_state = "electronic"
	board_type = "other"
	obj_flags = OBJ_FLAG_CONDUCT
	force = 5.0
	w_class = 2.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 15