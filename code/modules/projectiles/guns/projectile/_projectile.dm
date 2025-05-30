/obj/item/gun/projectile
	desc = "A classic revolver. Uses 357 ammo"
	name = "revolver"
	icon_state = "revolver"

	matter_amounts = alist(/decl/material/steel = 1000)
	origin_tech = alist(/decl/tech/materials = 2, /decl/tech/combat = 2)

	recoil = TRUE

	var/calibre = "357"

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
		return TRUE //{R}

	if(!length(loaded))
		return FALSE

	var/obj/item/ammo_casing/case = loaded[1] //load next casing.
	if(isnull(case) || !istype(case))
		return FALSE
	if(isnotnull(case.loaded_bullet))
		case.desc += " This one is spent." //descriptions are magic - only when there's a projectile in the casing
		in_chamber = case.loaded_bullet //Load projectile into chamber.
		case.loaded_bullet.forceMove(src) //Set projectile loc to gun.
		return TRUE
	return FALSE

/obj/item/gun/projectile/handle_post_fire()
	. = ..()
	if(length(loaded))
		var/obj/item/ammo_casing/AC = loaded[1]
		loaded.Remove(AC) // Remove casing from loaded list.
		AC.forceMove(GET_TURF(src)) // Ejects a casing onto the ground.

/obj/item/gun/projectile/attack_by(obj/item/I, mob/user)
	var/num_loaded = 0
	if(istype(I, /obj/item/ammo_magazine))
		if(load_method == MAGAZINE && length(loaded))
			return TRUE
		var/obj/item/ammo_magazine/mag = I
		if(!length(mag.stored_ammo))
			to_chat(user, SPAN_WARNING("The magazine is empty!"))
			return TRUE

		for_no_type_check(var/obj/item/ammo_casing/case, mag.stored_ammo)
			if(length(loaded) >= max_shells)
				break
			if(case.caliber == calibre && length(loaded) < max_shells)
				case.forceMove(src)
				mag.stored_ammo.Remove(case)
				loaded.Add(case)
				num_loaded++

		if(load_method == MAGAZINE)
			user.remove_from_mob(mag)
			empty_mag = mag
			empty_mag.forceMove(src)

	else if(istype(I, /obj/item/ammo_casing) && load_method == SPEEDLOADER)
		var/obj/item/ammo_casing/case = I
		if(case.caliber == calibre && length(loaded) < max_shells)
			user.drop_item()
			case.forceMove(src)
			loaded.Add(case)
			num_loaded++

	if(num_loaded)
		to_chat(user, SPAN_INFO("You load [num_loaded] shell\s into the gun!"))
		I.update_icon()
		update_icon()
		return TRUE

	return ..()

/obj/item/gun/projectile/attack_self(mob/user)
	if(target)
		return ..()
	if(!length(loaded))
		to_chat(user, SPAN_WARNING("There is nothing loaded in \the [src]!"))
		return

	if(load_method == SPEEDLOADER)
		var/obj/item/ammo_casing/case = loaded[1]
		loaded.Remove(case)
		case.forceMove(GET_TURF(src)) // Ejects the casing onto the ground.
		to_chat(user, SPAN_INFO("You unload a shell from \the [src]!"))

	else if(load_method == MAGAZINE)
		var/obj/item/ammo_magazine/mag = empty_mag
		for(var/obj/item/ammo_casing/case in loaded)
			mag.stored_ammo.Add(case)
			loaded.Remove(case)
		mag.forceMove(GET_TURF(src))
		empty_mag = null
		update_icon()
		mag.update_icon()
		to_chat(user, SPAN_INFO("You unload the magazine from \the [src]!"))

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