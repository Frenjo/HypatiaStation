/*
 * Ears
 *
 * Headsets, earmuffs and tiny objects.
 */
/obj/item/clothing/ears
	name = "ears"
	w_class = 1.0
	throwforce = 2
	slot_flags = SLOT_EARS

/obj/item/clothing/ears/attack_hand(mob/user as mob)
	if(isnull(user))
		return

	if(loc != user || !ishuman(user))
		return ..()

	var/mob/living/carbon/human/H = user
	if(H.l_ear != src && H.r_ear != src)
		return ..()

	if(!canremove)
		return

	var/obj/item/clothing/ears/O
	if(slot_flags & SLOT_TWOEARS)
		O = (H.l_ear == src ? H.r_ear : H.l_ear)
		user.u_equip(O)
		if(!istype(src, /obj/item/clothing/ears/offear))
			qdel(O)
			O = src
	else
		O = src

	user.u_equip(src)

	if(isnotnull(O))
		user.put_in_hands(O)
		O.add_fingerprint(user)

	if(istype(src, /obj/item/clothing/ears/offear))
		qdel(src)

/obj/item/clothing/ears/offear
	name = "other ear"
	w_class = 5.0
	icon = 'icons/mob/screen/screen1_Midnight.dmi'
	icon_state = "block"
	slot_flags = SLOT_EARS | SLOT_TWOEARS

/obj/item/clothing/ears/offear/New(obj/O)
	. = ..()
	name = O.name
	desc = O.desc
	icon = O.icon
	icon_state = O.icon_state
	dir = O.dir

/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	desc = "Protects your hearing from loud noises, and quiet ones as well."
	icon_state = "earmuffs"
	item_state = "earmuffs"
	slot_flags = SLOT_EARS | SLOT_TWOEARS