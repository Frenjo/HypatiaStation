/obj/item/gun/projectile/silenced
	name = "silenced pistol"
	desc = "A small, quiet,  easily concealable gun. Uses .45 rounds."
	icon_state = "silenced_pistol"

	origin_tech = alist(/decl/tech/materials = 2, /decl/tech/combat = 2, /decl/tech/syndicate = 8)

	silenced = TRUE

	ammo_type = /obj/item/ammo_casing/c45
	calibre = ".45"
	max_shells = 12

/obj/item/gun/projectile/deagle
	name = "desert eagle"
	desc = "A robust handgun that uses .50 AE ammo"
	icon_state = "deagle"

	force = 14

	ammo_type = /obj/item/ammo_casing/a50
	calibre = ".50"
	max_shells = 7
	load_method = MAGAZINE
	mag_type = /obj/item/ammo_magazine/a50/empty

/obj/item/gun/projectile/deagle/afterattack(atom/target, mob/living/user, flag)
	. = ..()
	if(!length(loaded) && empty_mag)
		empty_mag.forceMove(GET_TURF(src))
		empty_mag = null
		playsound(user, 'sound/weapons/gun/smg_empty_alarm.ogg', 40, 1)
		update_icon()

/obj/item/gun/projectile/deagle/gold
	desc = "A gold plated gun folded over a million times by superior martian gunsmiths. Uses .50 AE ammo."
	icon_state = "deagleg"
	item_state = "deagleg"

/obj/item/gun/projectile/deagle/camo
	desc = "A Deagle brand Deagle for operators operating operationally. Uses .50 AE ammo."
	icon_state = "deaglecamo"
	item_state = "deagleg"

/obj/item/gun/projectile/gyropistol
	name = "gyrojet pistol"
	desc = "A bulky pistol designed to fire self propelled rounds"
	icon_state = "gyropistol"

	origin_tech = alist(/decl/tech/combat = 3)

	fire_sound = 'sound/effects/explosion/explosion1.ogg'

	ammo_type = /obj/item/ammo_casing/a75
	calibre = "75"
	max_shells = 8
	load_method = MAGAZINE
	mag_type = /obj/item/ammo_magazine/a75/empty

/obj/item/gun/projectile/gyropistol/afterattack(atom/target, mob/living/user, flag)
	. = ..()
	if(!length(loaded) && empty_mag)
		empty_mag.forceMove(GET_TURF(src))
		empty_mag = null
		playsound(user, 'sound/weapons/gun/smg_empty_alarm.ogg', 40, 1)
		update_icon()

/obj/item/gun/projectile/gyropistol/update_icon()
	. = ..()
	if(empty_mag)
		icon_state = "gyropistolloaded"
	else
		icon_state = "gyropistol"

/obj/item/gun/projectile/pistol
	name = "\improper Stechtkin pistol"
	desc = "A small, easily concealable gun. Uses 9mm rounds."
	icon_state = "pistol"

	w_class = 2
	origin_tech = alist(/decl/tech/materials = 2, /decl/tech/combat = 2, /decl/tech/syndicate = 2)

	silenced = FALSE

	ammo_type = /obj/item/ammo_casing/c9mm
	calibre = "9mm"
	max_shells = 8
	load_method = MAGAZINE
	mag_type = /obj/item/ammo_magazine/mc9mm/empty

/obj/item/gun/projectile/pistol/afterattack(atom/target, mob/living/user, flag)
	. = ..()
	if(!length(loaded) && empty_mag)
		empty_mag.forceMove(GET_TURF(src))
		empty_mag = null

/obj/item/gun/projectile/pistol/attack_hand(mob/user)
	if(loc == user)
		if(silenced)
			if(user.l_hand != src && user.r_hand != src)
				return ..()
			to_chat(user, SPAN_NOTICE("You unscrew [silenced] from [src]."))
			user.put_in_hands(silenced)
			silenced = 0
			w_class = 2
			update_icon()
			return
	. = ..()

/obj/item/gun/projectile/pistol/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/silencer))
		if(user.l_hand != src && user.r_hand != src)	//if we're not in his hands
			to_chat(user, SPAN_NOTICE("You'll need [src] in your hands to do that."))
			return
		user.drop_item()
		to_chat(user, SPAN_NOTICE("You screw [I] onto [src]."))
		silenced = I	//dodgy?
		w_class = 3
		I.forceMove(src)		//put the silencer into the gun
		update_icon()
		return
	. = ..()

/obj/item/gun/projectile/pistol/update_icon()
	. = ..()
	if(silenced)
		icon_state = "pistol-silencer"
	else
		icon_state = "pistol"

/obj/item/silencer
	name = "silencer"
	desc = "a silencer"
	icon = 'icons/obj/weapons/gun.dmi'
	icon_state = "silencer"

	w_class = 2