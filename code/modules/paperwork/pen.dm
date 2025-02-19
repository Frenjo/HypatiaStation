/* Pens!
 * Contains:
 *		Pens
 *		Sleepy Pens
 *		Parapens
 */


/*
 * Pens
 */
/obj/item/pen
	desc = "It's a normal black ink pen."
	name = "pen"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"
	slot_flags = SLOT_BELT | SLOT_EARS
	throwforce = 0
	w_class = 1.0
	throw_speed = 7
	throw_range = 15
	matter_amounts = list(/decl/material/plastic = 10)

	pressure_resistance = 2

	var/colour = "black"	//what colour the ink is!

/obj/item/pen/blue
	desc = "It's a normal blue ink pen."
	icon_state = "pen_blue"
	colour = "blue"

/obj/item/pen/red
	desc = "It's a normal red ink pen."
	icon_state = "pen_red"
	colour = "red"

/obj/item/pen/invisible
	desc = "It's an invisble pen marker."
	icon_state = "pen"
	colour = "white"


/obj/item/pen/attack(mob/M, mob/user)
	if(!ismob(M))
		return
	to_chat(user, SPAN_WARNING("You stab [M] with the pen."))
//	M << "\red You feel a tiny prick!" //That's a whole lot of meta!
	M.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been stabbed with [name]  by [user.name] ([user.ckey])</font>"
	user.attack_log += "\[[time_stamp()]\] <font color='red'>Used the [name] to stab [M.name] ([M.ckey])</font>"
	msg_admin_attack("[user.name] ([user.ckey]) Used the [name] to stab [M.name] ([M.ckey]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
	return


/*
 * Sleepy Pens
 */
/obj/item/pen/sleepypen
	desc = "It's a black ink pen with a sharp point and a carefully engraved \"Waffle Co.\""
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	slot_flags = SLOT_BELT
	origin_tech = list(/decl/tech/materials = 2, /decl/tech/syndicate = 5)


/obj/item/pen/sleepypen/New()
	create_reagents(30) // Used to be 300.
	reagents.add_reagent("chloralhydrate", 22)	//Used to be 100 sleep toxin//30 Chloral seems to be fatal, reducing it to 22./N
	. = ..()


/obj/item/pen/sleepypen/attack(mob/M, mob/user)
	if(!(ismob(M)))
		return
	..()
	if(reagents.total_volume)
		if(M.reagents) reagents.trans_to(M, 50) //used to be 150
	return


/*
 * Parapens
 */
/obj/item/pen/paralysis
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	slot_flags = SLOT_BELT
	origin_tech = list(/decl/tech/materials = 2, /decl/tech/syndicate = 5)


/obj/item/pen/paralysis/attack(mob/M, mob/user)
	if(!(ismob(M)))
		return
	..()
	if(reagents.total_volume)
		if(M.reagents) reagents.trans_to(M, 50)
	return


/obj/item/pen/paralysis/New()
	create_reagents(50)
	reagents.add_reagent("zombiepowder", 10)
	reagents.add_reagent("impedrezene", 25)
	reagents.add_reagent("cryptobiolin", 15)
	. = ..()