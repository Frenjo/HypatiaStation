/obj/item/gun/projectile/automatic //Hopefully someone will find a way to make these fire in bursts or something. --Superxpdude
	name = "submachine gun"
	desc = "A lightweight, fast firing gun. Uses 9mm rounds."
	icon_state = "saber"	//ugly

	origin_tech = list(/datum/tech/materials = 2, /datum/tech/combat = 4)

	fire_delay = 0 SECONDS

	automatic = TRUE

	caliber = "9mm"

	ammo_type = /obj/item/ammo_casing/c9mm
	max_shells = 18

/obj/item/gun/projectile/automatic/isHandgun()
	return FALSE

/obj/item/gun/projectile/automatic/mini_uzi
	name = "\improper Uzi"
	desc = "A lightweight, fast firing gun, for when you want someone dead. Uses .45 rounds."
	icon_state = "mini-uzi"

	origin_tech = list(/datum/tech/materials = 2, /datum/tech/combat = 5, /datum/tech/syndicate = 8)

	caliber = ".45"

	ammo_type = /obj/item/ammo_casing/c45
	max_shells = 16

/obj/item/gun/projectile/automatic/mini_uzi/isHandgun()
	return TRUE

/obj/item/gun/projectile/automatic/c20r
	name = "\improper C-20r SMG"
	desc = "A lightweight, fast firing gun, for when you REALLY need someone dead. Uses 12mm rounds. Has a 'Scarborough Arms - Per falcis, per pravitas' buttstamp"
	icon_state = "c20r"
	item_state = "c20r"

	origin_tech = list(/datum/tech/materials = 2, /datum/tech/combat = 5, /datum/tech/syndicate = 8)

	fire_sound = 'sound/weapons/Gunshot_smg.ogg'

	caliber = "12mm"

	ammo_type = /obj/item/ammo_casing/a12mm
	max_shells = 20
	load_method = MAGAZINE

/obj/item/gun/projectile/automatic/c20r/New()
	. = ..()
	empty_mag = new /obj/item/ammo_magazine/a12mm/empty(src)
	update_icon()

/obj/item/gun/projectile/automatic/c20r/afterattack(atom/target, mob/living/user, flag)
	. = ..()
	if(!length(loaded) && empty_mag)
		empty_mag.loc = get_turf(loc)
		empty_mag = null
		playsound(user, 'sound/weapons/smg_empty_alarm.ogg', 40, 1)
		update_icon()

/obj/item/gun/projectile/automatic/c20r/update_icon()
	. = ..()
	if(empty_mag)
		icon_state = "c20r-[round(length(loaded), 4)]"
	else
		icon_state = "c20r"

/obj/item/gun/projectile/automatic/l6_saw
	name = "\improper L6 SAW"
	desc = "A rather traditionally made light machine gun with a pleasantly lacquered wooden pistol grip. Has 'Aussec Armoury- 2531' engraved on the reciever"
	icon_state = "l6closed100"
	item_state = "l6closedmag"

	w_class = 4
	slot_flags = null
	origin_tech = list(/datum/tech/materials = 1, /datum/tech/combat = 5, /datum/tech/syndicate = 2)

	fire_sound = 'sound/weapons/Gunshot_smg.ogg'

	caliber = "a762"

	ammo_type = /obj/item/ammo_casing/a762
	max_shells = 50
	load_method = MAGAZINE

	var/cover_open = FALSE
	var/mag_inserted = TRUE

/obj/item/gun/projectile/automatic/l6_saw/attack_self(mob/user)
	cover_open = !cover_open
	to_chat(user, SPAN_NOTICE("You [cover_open ? "open" : "close"] [src]'s cover."))
	update_icon()

/obj/item/gun/projectile/automatic/l6_saw/update_icon()
	icon_state = "l6[cover_open ? "open" : "closed"][mag_inserted ? round(length(loaded), 25) : "-empty"]"

/obj/item/gun/projectile/automatic/l6_saw/afterattack(atom/target, mob/living/user, flag, params) //what I tried to do here is just add a check to see if the cover is open or not and add an icon_state change because I can't figure out how c-20rs do it with overlays
	if(cover_open)
		to_chat(user, SPAN_NOTICE("[src]'s cover is open! Close it before firing!"))
	else
		. = ..()
		update_icon()

/obj/item/gun/projectile/automatic/l6_saw/attack_hand(mob/user)
	if(loc != user)
		return ..() //let them pick it up
	if(!cover_open || (cover_open && !mag_inserted))
		. = ..()
	else if(cover_open && mag_inserted)
		//drop the mag
		empty_mag = new /obj/item/ammo_magazine/a762(src)
		empty_mag.stored_ammo = loaded
		empty_mag.icon_state = "a762-[round(length(loaded), 10)]"
		empty_mag.desc = "There are [length(loaded)] shells left!"
		empty_mag.loc = get_turf(loc)
		user.put_in_hands(empty_mag)
		empty_mag = null
		mag_inserted = FALSE
		loaded = list()
		update_icon()
		to_chat(user, SPAN_NOTICE("You remove the magazine from [src]."))

/obj/item/gun/projectile/automatic/l6_saw/attackby(obj/item/A, mob/user)
	if(!cover_open)
		to_chat(user, SPAN_NOTICE("[src]'s cover is closed! You can't insert a new mag!"))
		return
	else if(cover_open && mag_inserted)
		to_chat(user, SPAN_NOTICE("[src] already has a magazine inserted!"))
		return
	else if(cover_open && !mag_inserted)
		mag_inserted = TRUE
		to_chat(user, SPAN_NOTICE("You insert the magazine!"))
		update_icon()
	. = ..()

/* The thing I found with guns in ss13 is that they don't seem to simulate the rounds in the magazine in the gun.
   Afaik, since projectile.dm features a revolver, this would make sense since the magazine is part of the gun.
   However, it looks like subsequent guns that use removable magazines don't take that into account and just get
   around simulating a removable magazine by adding the casings into the loaded list and spawning an empty magazine
   when the gun is out of rounds. Which means you can't eject magazines with rounds in them. The below is a very
   rough and poor attempt at making that happen. -Ausops */