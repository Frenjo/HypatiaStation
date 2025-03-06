/obj/item/gun/projectile
	desc = "A classic revolver. Uses 357 ammo"
	name = "revolver"
	icon_state = "revolver"

	matter_amounts = alist(/decl/material/steel = 1000)
	origin_tech = list(/decl/tech/materials = 2, /decl/tech/combat = 2)

	recoil = TRUE

	caliber = "357"

	var/ammo_type = /obj/item/ammo_casing/a357
	var/list/loaded = list()
	var/max_shells = 7
	var/load_method = SPEEDLOADER //0 = Single shells or quick loader, 1 = box, 2 = magazine
	var/obj/item/ammo_magazine/empty_mag = null

/obj/item/gun/projectile/New()
	. = ..()
	for(var/i = 1, i <= max_shells, i++)
		loaded.Add(new ammo_type(src))
	update_icon()

/obj/item/gun/projectile/load_into_chamber()
	if(isnotnull(in_chamber))
		return 1 //{R}

	if(!length(loaded))
		return 0

	var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
	loaded.Add(AC) // Remove casing from loaded list.
	if(isnull(AC) || !istype(AC))
		return 0

	AC.forceMove(GET_TURF(src)) //Eject casing onto ground.
	if(isnotnull(AC.loaded_bullet))
		AC.desc += " This one is spent."	//descriptions are magic - only when there's a projectile in the casing
		in_chamber = AC.loaded_bullet //Load projectile into chamber.
		AC.loaded_bullet.forceMove(src) //Set projectile loc to gun.
		return 1
	return 0

/obj/item/gun/projectile/attackby(obj/item/A, mob/user)
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
				AC.forceMove(src)
				AM.stored_ammo.Remove(AC)
				loaded.Add(AC)
				num_loaded++
		if(load_method == MAGAZINE)
			user.remove_from_mob(AM)
			empty_mag = AM
			empty_mag.forceMove(src)
	if(istype(A, /obj/item/ammo_casing) && load_method == SPEEDLOADER)
		var/obj/item/ammo_casing/AC = A
		if(AC.caliber == caliber && length(loaded) < max_shells)
			user.drop_item()
			AC.forceMove(src)
			loaded.Add(AC)
			num_loaded++
	if(num_loaded)
		to_chat(user, SPAN_INFO("You load [num_loaded] shell\s into the gun!"))
	A.update_icon()
	update_icon()

/obj/item/gun/projectile/attack_self(mob/user)
	if(target)
		return ..()
	if(length(loaded))
		if(load_method == SPEEDLOADER)
			var/obj/item/ammo_casing/AC = loaded[1]
			loaded.Remove(AC)
			AC.forceMove(GET_TURF(src)) //Eject casing onto ground.
			to_chat(user, SPAN_INFO("You unload the shells from \the [src]!"))
		if(load_method == MAGAZINE)
			var/obj/item/ammo_magazine/AM = empty_mag
			for(var/obj/item/ammo_casing/AC in loaded)
				AM.stored_ammo.Add(AC)
				loaded.Remove(AC)
			AM.forceMove(GET_TURF(src))
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

/obj/item/gun/projectile/proc/getAmmo()
	var/bullets = 0
	for(var/obj/item/ammo_casing/AC in loaded)
		if(istype(AC))
			bullets += 1
	return bullets