#define SPEEDLOADER 0
#define FROM_BOX 1
#define MAGAZINE 2

/obj/item/gun/projectile
	desc = "A classic revolver. Uses 357 ammo"
	name = "revolver"
	icon_state = "revolver"
	caliber = "357"
	origin_tech = list(RESEARCH_TECH_COMBAT = 2, RESEARCH_TECH_MATERIALS = 2)
	w_class = 3.0
	matter_amounts = list(MATERIAL_METAL = 1000)
	recoil = 1

	var/ammo_type = /obj/item/ammo_casing/a357
	var/list/loaded = list()
	var/max_shells = 7
	var/load_method = SPEEDLOADER //0 = Single shells or quick loader, 1 = box, 2 = magazine
	var/obj/item/ammo_magazine/empty_mag = null

/obj/item/gun/projectile/New()
	. = ..()
	for(var/i = 1, i <= max_shells, i++)
		loaded += new ammo_type(src)
	update_icon()

/obj/item/gun/projectile/load_into_chamber()
	if(in_chamber)
		return 1 //{R}

	if(!length(loaded))
		return 0

	var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
	loaded -= AC //Remove casing from loaded list.
	if(isnull(AC) || !istype(AC))
		return 0

	AC.loc = get_turf(src) //Eject casing onto ground.
	if(AC.BB)
		AC.desc += " This one is spent."	//descriptions are magic - only when there's a projectile in the casing
		in_chamber = AC.BB //Load projectile into chamber.
		AC.BB.loc = src //Set projectile loc to gun.
		return 1
	return 0

/obj/item/gun/projectile/attackby(obj/item/A as obj, mob/user as mob)
	var/num_loaded = 0
	if(istype(A, /obj/item/ammo_magazine))
		if(load_method == MAGAZINE && length(loaded))
			return
		var/obj/item/ammo_magazine/AM = A
		if(!length(AM.stored_ammo))
			to_chat(user, SPAN_WARNING("The magazine is empty!"))
			return
		for(var/obj/item/ammo_casing/AC in AM.stored_ammo)
			if(length(loaded) >= max_shells)
				break
			if(AC.caliber == caliber && length(loaded) < max_shells)
				AC.loc = src
				AM.stored_ammo -= AC
				loaded += AC
				num_loaded++
		if(load_method == MAGAZINE)
			user.remove_from_mob(AM)
			empty_mag = AM
			empty_mag.loc = src
	if(istype(A, /obj/item/ammo_casing) && load_method == SPEEDLOADER)
		var/obj/item/ammo_casing/AC = A
		if(AC.caliber == caliber && length(loaded) < max_shells)
			user.drop_item()
			AC.loc = src
			loaded += AC
			num_loaded++
	if(num_loaded)
		to_chat(user, SPAN_INFO("You load [num_loaded] shell\s into the gun!"))
	A.update_icon()
	update_icon()
	return

/obj/item/gun/projectile/attack_self(mob/user as mob)
	if(target)
		return ..()
	if(length(loaded))
		if(load_method == SPEEDLOADER)
			var/obj/item/ammo_casing/AC = loaded[1]
			loaded -= AC
			AC.loc = get_turf(src) //Eject casing onto ground.
			to_chat(user, SPAN_INFO("You unload the shells from \the [src]!"))
		if(load_method == MAGAZINE)
			var/obj/item/ammo_magazine/AM = empty_mag
			for (var/obj/item/ammo_casing/AC in loaded)
				AM.stored_ammo += AC
				loaded -= AC
			AM.loc = get_turf(src)
			empty_mag = null
			update_icon()
			AM.update_icon()
			to_chat(user, SPAN_INFO("You unload the magazine from \the [src]!"))
	else
		to_chat(user, SPAN_WARNING("There is nothing loaded in \the [src]!"))

/obj/item/gun/projectile/examine()
	..()
	to_chat(usr, "Has [getAmmo()] round\s remaining.")
//		if(in_chamber && !length(loaded))
//			usr << "However, it has a chambered round."
//		if(in_chamber && length(loaded))
//			usr << "It also has a chambered round." {R}
	return

/obj/item/gun/projectile/proc/getAmmo()
	var/bullets = 0
	for(var/obj/item/ammo_casing/AC in loaded)
		if(istype(AC))
			bullets += 1
	return bullets

#undef SPEEDLOADER
#undef FROM_BOX
#undef MAGAZINE