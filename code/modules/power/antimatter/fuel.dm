/obj/item/fuel
	name = "Magnetic Storage Ring"
	desc = "A magnetic storage ring."
	icon = 'icons/obj/items.dmi'
	icon_state = "rcdammo"
	opacity = FALSE
	density = FALSE
	anchored = FALSE
	var/fuel = 0
	var/s_time = 1.0
	var/content = null

/obj/item/fuel/H
	name = "Hydrogen storage ring"
	content = "Hydrogen"
	fuel = 1e-12		//pico-kilogram

/obj/item/fuel/antiH
	name = "Anti-Hydrogen storage ring"
	content = "Anti-Hydrogen"
	fuel = 1e-12		//pico-kilogram

/obj/item/fuel/attackby(obj/item/fuel/F, mob/user)
	..()
	if(istype(src, /obj/item/fuel/antiH))
		if(istype(F, /obj/item/fuel/antiH))
			src.fuel += F.fuel
			F.fuel = 0
			user << "You have added the anti-Hydrogen to the storage ring, it now contains [src.fuel]kg"
		if(istype(F, /obj/item/fuel/H))
			src.fuel += F.fuel
			del(F)
			src:annihilation(src.fuel)
	if(istype(src, /obj/item/fuel/H))
		if(istype(F, /obj/item/fuel/H))
			src.fuel += F.fuel
			F.fuel = 0
			user << "You have added the Hydrogen to the storage ring, it now contains [src.fuel]kg"
		if(istype(F, /obj/item/fuel/antiH))
			src.fuel += F.fuel
			del(src)
			F:annihilation(F.fuel)

/obj/item/fuel/antiH/proc/annihilation(var/mass)

	var/strength = convert2energy(mass)

	if (strength < 773.0)
		var/turf/T = GET_TURF(src)

		if (strength > (450+T0C))
			explosion(T, 0, 1, 2, 4)
		else
			if (strength > (300+T0C))
				explosion(T, 0, 0, 2, 3)

		del(src)
		return

	var/turf/ground_zero = GET_TURF(src)

	var/ground_zero_range = round(strength / 387)
	explosion(ground_zero, ground_zero_range, ground_zero_range*2, ground_zero_range*3, ground_zero_range*4)

	//SN src = null
	del(src)
	return


/obj/item/fuel/examine()
	set src in view(1)
	if(usr && !usr.stat)
		usr << "A magnetic storage ring, it contains [fuel]kg of [content ? content : "nothing"]."

/obj/item/fuel/proc/injest(mob/M)
	switch(content)
		if("Anti-Hydrogen")
			M.gib()
		if("Hydrogen")
			M << "\blue You feel very light, as if you might just float away..."
	del(src)
	return

/obj/item/fuel/attack(mob/M, mob/user)
	if (user != M)
		var/obj/effect/equip_e/human/O = new /obj/effect/equip_e/human(  )
		O.source = user
		O.target = M
		O.item = src
		O.s_loc = user.loc
		O.t_loc = M.loc
		O.place = "fuel"
		M.requests += O
		spawn( 0 )
			O.process()
			return
	else
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red [M] ate the [content ? content : "empty canister"]!"), 1)
		src.injest(M)
