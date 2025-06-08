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

/obj/item/solar_assembly/attack_tool(obj/item/tool, mob/user)
	if(iswrench(tool) && isturf(loc))
		anchored = !anchored
		user.visible_message(
			SPAN_NOTICE("[user] [anchored ? "wrenches" : "unwrenches"] \the [src] [anchored ? "into" : "from its"] place."),
			SPAN_NOTICE("You [anchored ? "wrench" : "unwrench"] \the [src] [anchored ? "into" : "from its"] place."),
			SPAN_INFO("You hear a ratchet.")
		)
		playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
		return TRUE

	if(tracker && iscrowbar(tool))
		tracker = FALSE
		user.visible_message(
			SPAN_NOTICE("[user] takes the tracker electronics out of \the [src]."),
			SPAN_NOTICE("You take the tracker electronics out of \the [src].")
		)
		new /obj/item/tracker_electronics(GET_TURF(src))
		return TRUE

	return ..()

/obj/item/solar_assembly/attack_by(obj/item/I, mob/user)
	if(!anchored)
		return ..()

	if(!tracker && istype(I, /obj/item/tracker_electronics))
		tracker = TRUE
		user.visible_message(
			SPAN_NOTICE("[user] inserts \the [I] into \the [src]."),
			SPAN_NOTICE("You insert \the [I] into \the [src].")
		)
		user.drop_item()
		qdel(I)
		return TRUE

	if(istype(I, /obj/item/stack/sheet/glass))
		var/obj/item/stack/sheet/glass/sheet = I
		if(!sheet.use(2))
			to_chat(user, SPAN_WARNING("You need two sheets of [I] to put them into \a [src]."))
			return TRUE
		glass_type = I.type
		playsound(src, 'sound/machines/click.ogg', 50, 1)
		user.visible_message(
			SPAN_NOTICE("[user] places \the [I] on \the [src]."),
			SPAN_NOTICE("You place \the [I] on \the [src].")
		)
		if(tracker)
			new /obj/machinery/power/tracker(GET_TURF(src), src)
		else
			new /obj/machinery/power/solar(GET_TURF(src), src)
		return TRUE

	return ..()

// Gives back the glass type we were supplied with.
/obj/item/solar_assembly/proc/give_glass()
	if(isnotnull(glass_type))
		new glass_type(GET_TURF(src), 2)
		glass_type = null