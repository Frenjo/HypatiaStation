/////////////////////////
////// Mecha Parts //////
/////////////////////////
/obj/item/mecha_part
	name = "mecha part"
	icon = 'icons/obj/mecha/parts/common.dmi'
	icon_state = "blank"
	obj_flags = OBJ_FLAG_CONDUCT
	w_class = 5
	origin_tech = list(/datum/tech/materials = 2, /datum/tech/programming = 2)

/obj/item/mecha_part/chassis
	name = "mecha chassis"
	icon_state = "backbone"
	density = TRUE

	var/datum/construction/construct
	var/construct_type
	var/target_icon = null

/obj/item/mecha_part/chassis/New()
	. = ..()
	if(isnotnull(construct_type))
		construct = new construct_type(src)

/obj/item/mecha_part/chassis/Destroy()
	if(isnotnull(construct))
		QDEL_NULL(construct)
	return ..()

/obj/item/mecha_part/chassis/attackby(obj/item/W, mob/user)
	if(!construct || !construct.action(W, user))
		. = ..()

/obj/item/mecha_part/chassis/attack_hand()
	return

// Circuit Boards
/obj/item/circuitboard/mecha
	name = "circuit board (Exosuit)"
	icon_state = "mainboard"

	throw_speed = 3
	throw_range = 15

	obj_flags = OBJ_FLAG_CONDUCT
	throwforce = 5
	force = 5

	board_type = "other"