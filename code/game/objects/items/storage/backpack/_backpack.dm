/*
 * Backpack
 */
/obj/item/storage/backpack
	name = "backpack"
	desc = "You wear this on your back and put items into it."
	icon = 'icons/obj/storage/backpack.dmi'
	icon_state = "backpack"
	item_state = "backpack"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = SLOT_BACK	//ERROOOOO
	max_w_class = WEIGHT_CLASS_NORMAL
	max_combined_w_class = 21

/obj/item/storage/backpack/attackby(obj/item/W, mob/user)
	if(isnotnull(use_sound))
		playsound(loc, use_sound, 50, 1, -5)
	..()

/obj/item/storage/backpack/equipped(mob/user, slot)
	if(slot == SLOT_ID_BACK && isnotnull(use_sound))
		playsound(loc, use_sound, 50, 1, -5)
	..(user, slot)

/*
/obj/item/storage/backpack/dropped(mob/user)
	if (loc == user && use_sound)
		playsound(loc, use_sound, 50, 1, -5)
	..(user)
*/

/*
 * Backpack Types
 */
/obj/item/storage/backpack/santabag
	name = "santa's gift bag"
	desc = "Space Santa uses this to deliver toys to all the nice children in space in Christmas! Wow, it's pretty big!"
	icon_state = "giftbag0"
	item_state = "giftbag"
	storage_slots = 20
	max_combined_w_class = 400 // can store a ton of shit!

/obj/item/storage/backpack/cultpack
	name = "trophy rack"
	desc = "It's useful for both carrying extra gear and proudly declaring your insanity."
	icon_state = "cultpack"

/obj/item/storage/backpack/clown
	name = "Giggles von Honkerton"
	desc = "It's a backpack made by Honk! Co."
	icon_state = "clownpack"
	item_state = "clownpack"

/obj/item/storage/backpack/medic
	name = "medical backpack"
	desc = "It's a backpack especially designed for use in a sterile environment."
	icon_state = "medicalpack"
	item_state = "medicalpack"

/obj/item/storage/backpack/security
	name = "security backpack"
	desc = "It's a very robust backpack."
	icon_state = "securitypack"
	item_state = "securitypack"

/obj/item/storage/backpack/captain
	name = "captain's backpack"
	desc = "It's a special backpack made exclusively for NanoTrasen officers."
	icon_state = "captainpack"
	item_state = "captainpack"

/obj/item/storage/backpack/industrial
	name = "industrial backpack"
	desc = "It's a tough backpack for the daily grind of station life."
	icon_state = "engiepack"
	item_state = "engiepack"