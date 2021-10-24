/obj/item/weapon/gun/projectile/silenced
	name = "silenced pistol"
	desc = "A small, quiet,  easily concealable gun. Uses .45 rounds."
	icon_state = "silenced_pistol"
	w_class = 3.0
	max_shells = 12
	caliber = ".45"
	silenced = 1
	origin_tech = list(RESEARCH_TECH_COMBAT = 2, RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_SYNDICATE = 8)
	ammo_type = /obj/item/ammo_casing/c45

/obj/item/weapon/gun/projectile/deagle
	name = "desert eagle"
	desc = "A robust handgun that uses .50 AE ammo"
	icon_state = "deagle"
	force = 14.0
	max_shells = 7
	caliber = ".50"
	ammo_type = /obj/item/ammo_casing/a50
	load_method = 2

/obj/item/weapon/gun/projectile/deagle/New()
	..()
	empty_mag = new /obj/item/ammo_magazine/a50/empty(src)
	update_icon()
	return

/obj/item/weapon/gun/projectile/deagle/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
	..()
	if(!loaded.len && empty_mag)
		empty_mag.loc = get_turf(src.loc)
		empty_mag = null
		playsound(user, 'sound/weapons/smg_empty_alarm.ogg', 40, 1)
		update_icon()
	return

/obj/item/weapon/gun/projectile/deagle/gold
	desc = "A gold plated gun folded over a million times by superior martian gunsmiths. Uses .50 AE ammo."
	icon_state = "deagleg"
	item_state = "deagleg"

/obj/item/weapon/gun/projectile/deagle/camo
	desc = "A Deagle brand Deagle for operators operating operationally. Uses .50 AE ammo."
	icon_state = "deaglecamo"
	item_state = "deagleg"

/obj/item/weapon/gun/projectile/gyropistol
	name = "gyrojet pistol"
	desc = "A bulky pistol designed to fire self propelled rounds"
	icon_state = "gyropistol"
	max_shells = 8
	caliber = "75"
	fire_sound = 'sound/effects/Explosion1.ogg'
	origin_tech = list(RESEARCH_TECH_COMBAT = 3)
	ammo_type = /obj/item/ammo_casing/a75
	load_method = 2

/obj/item/weapon/gun/projectile/gyropistol/New()
	..()
	empty_mag = new /obj/item/ammo_magazine/a75/empty(src)
	update_icon()
	return

/obj/item/weapon/gun/projectile/gyropistol/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
	..()
	if(!loaded.len && empty_mag)
		empty_mag.loc = get_turf(src.loc)
		empty_mag = null
		playsound(user, 'sound/weapons/smg_empty_alarm.ogg', 40, 1)
		update_icon()
	return

/obj/item/weapon/gun/projectile/gyropistol/update_icon()
	..()
	if(empty_mag)
		icon_state = "gyropistolloaded"
	else
		icon_state = "gyropistol"
	return

/obj/item/weapon/gun/projectile/pistol
	name = "\improper Stechtkin pistol"
	desc = "A small, easily concealable gun. Uses 9mm rounds."
	icon_state = "pistol"
	w_class = 2
	max_shells = 8
	caliber = "9mm"
	silenced = 0
	origin_tech = list(RESEARCH_TECH_COMBAT = 2, RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_SYNDICATE = 2)
	ammo_type = /obj/item/ammo_casing/c9mm
	load_method = 2

/obj/item/weapon/gun/projectile/pistol/New()
	..()
	empty_mag = new /obj/item/ammo_magazine/mc9mm/empty(src)
	return

/obj/item/weapon/gun/projectile/pistol/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
	..()
	if(!loaded.len && empty_mag)
		empty_mag.loc = get_turf(src.loc)
		empty_mag = null
	return

/obj/item/weapon/gun/projectile/pistol/attack_hand(mob/user as mob)
	if(loc == user)
		if(silenced)
			if(user.l_hand != src && user.r_hand != src)
				..()
				return
			to_chat(user, SPAN_NOTICE("You unscrew [silenced] from [src]."))
			user.put_in_hands(silenced)
			silenced = 0
			w_class = 2
			update_icon()
			return
	..()

/obj/item/weapon/gun/projectile/pistol/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/silencer))
		if(user.l_hand != src && user.r_hand != src)	//if we're not in his hands
			to_chat(user, SPAN_NOTICE("You'll need [src] in your hands to do that."))
			return
		user.drop_item()
		to_chat(user, SPAN_NOTICE("You screw [I] onto [src]."))
		silenced = I	//dodgy?
		w_class = 3
		I.loc = src		//put the silencer into the gun
		update_icon()
		return
	..()

/obj/item/weapon/gun/projectile/pistol/update_icon()
	..()
	if(silenced)
		icon_state = "pistol-silencer"
	else
		icon_state = "pistol"

/obj/item/weapon/silencer
	name = "silencer"
	desc = "a silencer"
	icon = 'icons/obj/gun.dmi'
	icon_state = "silencer"
	w_class = 2