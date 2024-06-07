//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32
/obj/item/storage/lockbox
	name = "lockbox"
	desc = "A locked box."
	icon = 'icons/obj/storage/lockbox.dmi'
	icon_state = "lockbox+l"
	item_state = "syringe_kit"
	w_class = 4
	max_w_class = 3
	max_combined_w_class = 14 //The sum of the w_classes of all the items in this storage item.
	storage_slots = 4
	req_access = list(ACCESS_ARMOURY)

	var/locked = 1
	var/broken = 0
	var/icon_locked = "lockbox+l"
	var/icon_closed = "lockbox"
	var/icon_broken = "lockbox+b"

/obj/item/storage/lockbox/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/card/id))
		if(broken)
			user << "\red It appears to be broken."
			return
		if(allowed(user))
			locked = !( locked )
			if(locked)
				icon_state = icon_locked
				user << "\red You lock the [name]!"
				return
			else
				icon_state = icon_closed
				user << "\red You unlock the [name]!"
				return
		else
			FEEDBACK_ACCESS_DENIED(user)
	else if((istype(W, /obj/item/card/emag)||istype(W, /obj/item/melee/energy/blade)) && !broken)
		broken = 1
		locked = 0
		desc = "It appears to be broken."
		icon_state = icon_broken
		if(istype(W, /obj/item/melee/energy/blade))
			make_sparks(5, FALSE, loc)
			playsound(src, 'sound/weapons/blade1.ogg', 50, 1)
			playsound(src, "sparks", 50, 1)
			for(var/mob/O in viewers(user, 3))
				O.show_message(text("\blue The locker has been sliced open by [] with an energy blade!", user), 1, text("\red You hear metal being sliced and sparks flying."), 2)
		else
			for(var/mob/O in viewers(user, 3))
				O.show_message(text("\blue The locker has been broken by [] with an electromagnetic card!", user), 1, text("You hear a faint electrical spark."), 2)

	if(!locked)
		..()
	else
		user << "\red Its locked!"
	return

/obj/item/storage/lockbox/show_to(mob/user)
	if(locked)
		user << "\red Its locked!"
	else
		..()
	return

/obj/item/storage/lockbox/loyalty
	name = "lockbox of loyalty implants"
	req_access = list(ACCESS_SECURITY)

/obj/item/storage/lockbox/loyalty/New()
	..()
	new /obj/item/implantcase/loyalty(src)
	new /obj/item/implantcase/loyalty(src)
	new /obj/item/implantcase/loyalty(src)
	new /obj/item/implanter/loyalty(src)

/obj/item/storage/lockbox/clusterbang
	name = "lockbox of clusterbangs"
	desc = "You have a bad feeling about opening this."
	req_access = list(ACCESS_SECURITY)

/obj/item/storage/lockbox/clusterbang/New()
	..()
	new /obj/item/grenade/flashbang/clusterbang(src)