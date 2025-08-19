//CONTAINS: Evidence bags and fingerprint cards

/obj/item/evidencebag
	name = "evidence bag"
	desc = "An empty evidence bag."
	icon = 'icons/obj/storage/storage.dmi'
	icon_state = "evidenceobj"
	item_state = ""
	w_class = WEIGHT_CLASS_TINY

/obj/item/evidencebag/afterattack(obj/item/I, mob/user, proximity)
	if(!proximity)
		return
	if(!in_range(I, user))
		return

	if(!istype(I) || I.anchored == 1)
		return ..()

	if(istype(I, /obj/item/evidencebag))
		to_chat(user, SPAN_NOTICE("You find putting an evidence bag in another evidence bag to be slightly absurd."))
		return

	if(I.w_class > 3)
		to_chat(user, SPAN_NOTICE("[I] won't fit in [src]."))
		return

	if(length(contents))
		to_chat(user, SPAN_NOTICE("[src] already has something inside it."))
		return ..()

	if(!isturf(I.loc)) //If it isn't on the floor. Do some checks to see if it's in our hands or a box. Otherwise give up.
		if(istype(I.loc,/obj/item/storage))	//in a container.
			var/obj/item/storage/U = I.loc
			user.client.screen -= I
			U.contents.Remove(I)
		else if(user.l_hand == I)					//in a hand
			user.drop_l_hand()
		else if(user.r_hand == I)					//in a hand
			user.drop_r_hand()
		else
			return

	user.visible_message(
		"[user] puts [I] into [src]",
		"You put [I] inside [src].",
		"You hear a rustle as someone puts something into a plastic bag."
	)

	icon_state = "evidence"

	var/mutable_appearance/in_evidence = new /mutable_appearance(I)
	in_evidence.plane = FLOAT_PLANE
	in_evidence.layer = FLOAT_LAYER
	in_evidence.pixel_x = 0
	in_evidence.pixel_y = 0
	add_overlay(in_evidence)
	add_overlay("evidence")	//should look nicer for transparent stuff. not really that important, but hey.

	desc = "An evidence bag containing [I]. [I.desc]"
	I.forceMove(src)
	w_class = I.w_class
	return

/obj/item/evidencebag/attack_self(mob/user)
	if(length(contents))
		var/obj/item/I = contents[1]
		user.visible_message(
			"[user] takes [I] out of [src]",
			"You take [I] out of [src].",
			"You hear someone rustle around in a plastic bag, and remove something."
		)
		cut_overlays()	//remove the overlays
		user.put_in_hands(I)
		w_class = 1
		icon_state = "evidenceobj"
		desc = "An empty evidence bag."

	else
		to_chat(user, "[src] is empty.")
		icon_state = "evidenceobj"
	return


/obj/item/storage/box/evidence
	name = "evidence bag box"
	desc = "A box claiming to contain evidence bags."

	starts_with = list(
		/obj/item/evidencebag = 6
	)

/obj/item/f_card
	name = "finger print card"
	desc = "Used to take fingerprints."
	icon = 'icons/obj/items/card.dmi'
	icon_state = "fingerprint0"
	var/amount = 10.0
	item_state = "paper"
	throwforce = 1
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 5


/obj/item/fcardholder
	name = "fingerprint card case"
	desc = "Apply finger print card."
	icon = 'icons/obj/items.dmi'
	icon_state = "fcardholder0"
	item_state = "clipboard"
