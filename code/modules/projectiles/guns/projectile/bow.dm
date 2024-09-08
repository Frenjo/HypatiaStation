/obj/item/arrow
	name = "bolt"
	desc = "It's got a tip for you - get the point?"
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "bolt"
	item_state = "bolt"

	throwforce = 8
	sharp = TRUE
	edge = FALSE

/obj/item/arrow/proc/removed() //Helper for metal rods falling apart.
	return

/obj/item/arrow/quill
	name = "vox quill"
	desc = "A wickedly barbed quill from some bizarre animal."
	icon_state = "quill"
	item_state = "quill"

	throwforce = 5

/obj/item/arrow/rod
	name = "metal rod"
	desc = "Don't cry for me, Orithena."
	icon_state = "metal-rod"

/obj/item/arrow/rod/removed(mob/user)
	if(throwforce == 15) // The rod has been superheated - we don't want it to be useable when removed from the bow.
		to_chat(user, "[src] shatters into a scattering of overstressed metal shards as it leaves the crossbow.")
		var/obj/item/shard/shrapnel/S = new /obj/item/shard/shrapnel()
		S.loc = GET_TURF(src)
		qdel(src)

/obj/item/crossbow
	name = "powered crossbow"
	desc = "A 2557AD twist on an old classic. Pick up that can."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "crossbow"
	item_state = "crossbow-solid"

	// w_class is here twice, which one should this be?
	w_class = 5
	w_class = 3
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT | SLOT_BACK

	var/tension = 0						// Current draw on the bow.
	var/max_tension = 5					// Highest possible tension.
	var/release_speed = 5				// Speed per unit of tension.
	var/mob/living/current_user = null	// Used to see if the person drawing the bow started drawing it.
	var/obj/item/arrow = null			// Nocked arrow.
	var/obj/item/cell/cell = null		// Used for firing special projectiles like rods.

/obj/item/crossbow/attackby(obj/item/W, mob/user)
	if(isnull(arrow))
		if(istype(W, /obj/item/arrow))
			user.drop_item()
			arrow = W
			arrow.loc = src
			user.visible_message(
				"[user] slides [arrow] into [src].",
				"You slide [arrow] into [src]."
			)
			icon_state = "crossbow-nocked"
			return
		else if(istype(W, /obj/item/stack/rods))
			var/obj/item/stack/rods/R = W
			R.use(1)
			arrow = new /obj/item/arrow/rod(src)
			arrow.last_fingerprints = last_fingerprints
			arrow.loc = src
			icon_state = "crossbow-nocked"
			user.visible_message("[user] haphazardly jams [arrow] into [src].", "You jam [arrow] into [src].")
			if(isnotnull(cell))
				if(cell.charge >= 500)
					to_chat(user, SPAN_NOTICE("[arrow] plinks and crackles as it begins to glow red-hot."))
					arrow.throwforce = 15
					arrow.icon_state = "metal-rod-superheated"
					cell.use(500)
			return

	if(istype(W, /obj/item/cell))
		if(isnull(cell))
			user.drop_item()
			W.loc = src
			cell = W
			to_chat(user, SPAN_NOTICE("You jam [cell] into [src] and wire it to the firing coil."))
			if(isnotnull(arrow))
				if(istype(arrow, /obj/item/arrow/rod) && arrow.throwforce < 15 && cell.charge >= 500)
					to_chat(user, SPAN_NOTICE("[arrow] plinks and crackles as it begins to glow red-hot."))
					arrow.throwforce = 15
					arrow.icon_state = "metal-rod-superheated"
					cell.use(500)
		else
			to_chat(user, SPAN_NOTICE("[src] already has a cell installed."))

	else if(isscrewdriver(W))
		if(isnotnull(cell))
			var/obj/item/C = cell
			C.loc = GET_TURF(user)
			cell = null
			to_chat(user, SPAN_NOTICE("You jimmy [cell] out of [src] with [W]."))
		else
			to_chat(user, SPAN_NOTICE("[src] doesn't have a cell installed."))

	else
		. = ..()

/obj/item/crossbow/attack_self(mob/living/user)
	if(tension)
		if(isnotnull(arrow))
			user.visible_message(
				"[user] relaxes the tension on [src]'s string and removes [arrow].",
				"You relax the tension on [src]'s string and remove [arrow]."
			)
			var/obj/item/arrow/A = arrow
			A.loc = GET_TURF(src)
			A.removed(user)
			arrow = null
		else
			user.visible_message(
				"[user] relaxes the tension on [src]'s string.",
				"You relax the tension on [src]'s string."
			)
		tension = 0
		icon_state = "crossbow"
	else
		draw(user)

/obj/item/crossbow/proc/draw(mob/user)
	if(isnull(arrow))
		to_chat(user, "You don't have anything nocked to [src].")
		return

	if(user.restrained())
		return

	current_user = user

	user.visible_message(
		"[user] begins to draw back the string of [src].",
		"You begin to draw back the string of [src]."
	)
	tension = 1
	spawn(25)
		increase_tension(user)

/obj/item/crossbow/proc/increase_tension(mob/user)
	if(isnull(arrow) || !tension || current_user != user) //Arrow has been fired, bow has been relaxed or user has changed.
		return

	tension++
	icon_state = "crossbow-drawn"

	if(tension >= max_tension)
		tension = max_tension
		to_chat(usr, "[src] clunks as you draw the string to its maximum tension!")
	else
		user.visible_message(
			"[usr] draws back the string of [src]!",
			"You continue drawing back the string of [src]!"
		)
		spawn(25)
			increase_tension(user)

/obj/item/crossbow/afterattack(atom/target, mob/living/user, flag, params)
	if(istype(target, /obj/item/storage/backpack))
		dropped()
		return

	else if(target.loc == user.loc)
		return

	else if(locate(/obj/structure/table, loc))
		return

	else if(target == user)
		return

	if(!tension)
		to_chat(user, "You haven't drawn back the bolt!")
		return 0

	if(isnull(arrow))
		to_chat(user, "You have no arrow nocked to [src]!")
		return 0
	else
		spawn(0)
			Fire(target, user, params)

/obj/item/crossbow/proc/Fire(atom/target, mob/living/user, params, reflex = 0)
	add_fingerprint(user)

	var/turf/curloc = GET_TURF(user)
	var/turf/targloc = GET_TURF(target)
	if(!istype(targloc) || !istype(curloc))
		return

	user.visible_message(
		SPAN_DANGER("[user] releases [src] and sends [arrow] streaking toward [target]!"),
		SPAN_DANGER("You release [src] and send [arrow] streaking toward [target]!")
	)

	var/obj/item/arrow/A = arrow
	A.loc = GET_TURF(user)
	A.throw_at(target, 10, tension * release_speed)
	arrow = null
	tension = 0
	icon_state = "crossbow"

/obj/item/crossbow/dropped(mob/user)
	if(isnotnull(arrow))
		var/obj/item/arrow/A = arrow
		A.loc = GET_TURF(src)
		A.removed(user)
		arrow = null
		tension = 0
		icon_state = "crossbow"