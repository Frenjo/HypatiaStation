/*
 * Backpack
 */
/obj/item/storage/backpack
	name = "backpack"
	desc = "You wear this on your back and put items into it."
	icon = 'icons/obj/storage/backpack.dmi'
	icon_state = "backpack"
	item_state = "backpack"
	w_class = 4.0
	slot_flags = SLOT_BACK	//ERROOOOO
	max_w_class = 3
	max_combined_w_class = 21

/obj/item/storage/backpack/attackby(obj/item/W as obj, mob/user as mob)
	if(isnotnull(use_sound))
		playsound(loc, use_sound, 50, 1, -5)
	..()

/obj/item/storage/backpack/equipped(mob/user, slot)
	if(slot == SLOT_ID_BACK && isnotnull(use_sound))
		playsound(loc, use_sound, 50, 1, -5)
	..(user, slot)

/*
/obj/item/storage/backpack/dropped(mob/user as mob)
	if (loc == user && use_sound)
		playsound(loc, use_sound, 50, 1, -5)
	..(user)
*/

/*
 * Backpack Types
 */
/obj/item/storage/backpack/holding
	name = "bag of holding"
	desc = "A backpack that opens into a localized pocket of Blue Space."
	origin_tech = list(RESEARCH_TECH_BLUESPACE = 4)
	icon_state = "holdingpack"
	max_w_class = 4
	max_combined_w_class = 28

/obj/item/storage/backpack/holding/attackby(obj/item/W as obj, mob/user as mob)
	if(crit_fail)
		to_chat(user, SPAN_WARNING("The Bluespace generator isn't working."))
		return
	if(istype(W, /obj/item/storage/backpack/holding) && !W.crit_fail)
		to_chat(user, SPAN_WARNING("The Bluespace interfaces of the two devices conflict and malfunction."))
		qdel(W)
		return
		/* //BoH+BoH=Singularity, commented out.
	if(istype(W, /obj/item/storage/backpack/holding) && !W.crit_fail)
		investigate_log("has become a singularity. Caused by [user.key]","singulo")
		user << "\red The Bluespace interfaces of the two devices catastrophically malfunction!"
		del(W)
		var/obj/machinery/singularity/singulo = new /obj/machinery/singularity (get_turf(src))
		singulo.energy = 300 //should make it a bit bigger~
		message_admins("[key_name_admin(user)] detonated a bag of holding")
		log_game("[key_name(user)] detonated a bag of holding")
		del(src)
		return
		*/
	..()

/obj/item/storage/backpack/holding/proc/failcheck(mob/user as mob)
	if(prob(reliability))
		return 1 //No failure
	if(prob(reliability))
		to_chat(user, SPAN_WARNING("The Bluespace portal resists your attempt to add another item.")) // Light failure.
	else
		to_chat(user, SPAN_WARNING("The Bluespace generator malfunctions!"))
		for(var/obj/O in contents) //it broke, delete what was in it
			qdel(O)
		crit_fail = 1
		icon_state = "brokenpack"

/obj/item/storage/backpack/santabag
	name = "Santa's Gift Bag"
	desc = "Space Santa uses this to deliver toys to all the nice children in space in Christmas! Wow, it's pretty big!"
	icon_state = "giftbag0"
	item_state = "giftbag"
	w_class = 4.0
	storage_slots = 20
	max_w_class = 3
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