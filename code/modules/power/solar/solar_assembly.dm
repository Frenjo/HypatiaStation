//
// Solar Assembly - For construction of solar arrays.
//

/obj/item/solar_assembly
	name = "solar panel assembly"
	desc = "A solar panel assembly kit, allows constructions of a solar panel, or with a tracking circuit board, a solar tracker"
	icon = 'icons/obj/power.dmi'
	icon_state = "sp_base"
	item_state = "electropack"
	w_class = 4 // Pretty big!
	anchored = FALSE

	var/tracker = FALSE
	var/glass_type = null

/obj/item/solar_assembly/attack_hand(mob/user)
	if(!anchored && isturf(loc)) // You can't pick it up
		..()

/obj/item/solar_assembly/attackby(obj/item/W, mob/user)
	if(!anchored && isturf(loc))
		if(iswrench(W))
			anchored = TRUE
			user.visible_message(SPAN_NOTICE("[user] wrenches the solar assembly into place."))
			playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
			return 1
	else
		if(iswrench(W))
			anchored = FALSE
			user.visible_message(SPAN_NOTICE("[user] unwrenches the solar assembly from it's place."))
			playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
			return 1

		if(istype(W, /obj/item/stack/sheet/glass) || istype(W, /obj/item/stack/sheet/rglass))
			var/obj/item/stack/sheet/S = W
			if(S.amount >= 2)
				glass_type = W.type
				S.use(2)
				playsound(src, 'sound/machines/click.ogg', 50, 1)
				user.visible_message(SPAN_NOTICE("[user] places the glass on the solar assembly."))
				if(tracker)
					new /obj/machinery/power/tracker(get_turf(src), src)
				else
					new /obj/machinery/power/solar(get_turf(src), src)
			else
				to_chat(user, SPAN_WARNING("You need two sheets of glass to put them into a solar panel."))
				return
			return 1

	if(!tracker)
		if(istype(W, /obj/item/tracker_electronics))
			tracker = TRUE
			user.drop_item()
			qdel(W)
			user.visible_message(SPAN_NOTICE("[user] inserts the electronics into the solar assembly."))
			return 1
	else
		if(iscrowbar(W))
			new /obj/item/tracker_electronics(src.loc)
			tracker = FALSE
			user.visible_message(SPAN_NOTICE("[user] takes out the electronics from the solar assembly."))
			return 1
	..()

// Give back the glass type we were supplied with
/obj/item/solar_assembly/proc/give_glass()
	if(glass_type)
		var/obj/item/stack/sheet/S = new glass_type(src.loc)
		S.amount = 2
		glass_type = null