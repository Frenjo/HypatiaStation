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

/obj/item/storage/lockbox/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/card/id))
		if(src.broken)
			user << "\red It appears to be broken."
			return
		if(src.allowed(user))
			src.locked = !( src.locked )
			if(src.locked)
				src.icon_state = src.icon_locked
				user << "\red You lock the [src.name]!"
				return
			else
				src.icon_state = src.icon_closed
				user << "\red You unlock the [src.name]!"
				return
		else
			FEEDBACK_ACCESS_DENIED(user)
	else if((istype(W, /obj/item/card/emag)||istype(W, /obj/item/melee/energy/blade)) && !src.broken)
		broken = 1
		locked = 0
		desc = "It appears to be broken."
		icon_state = src.icon_broken
		if(istype(W, /obj/item/melee/energy/blade))
			var/datum/effect/system/spark_spread/spark_system = new /datum/effect/system/spark_spread()
			spark_system.set_up(5, 0, src.loc)
			spark_system.start()
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

/obj/item/storage/lockbox/show_to(mob/user as mob)
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