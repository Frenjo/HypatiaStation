// the power cell
// charge from 0 to 100%
// fits in APC to provide backup power

/obj/item/cell/initialise()
	. = ..()
	charge = maxcharge
	updateicon()

/obj/item/cell/proc/updateicon()
	cut_overlays()

	if(charge < 0.01)
		return
	else if(charge / maxcharge >= 0.995)
		add_overlay("cell-o2")
	else
		add_overlay("cell-o1")

/obj/item/cell/proc/percent()		// return % charge of cell
	return 100.0 * charge / maxcharge

/obj/item/cell/proc/fully_charged()
	return (charge == maxcharge)

// use power from a cell
/obj/item/cell/proc/use(amount)
	if(rigged && amount > 0)
		explode()
		return 0

	if(charge < amount)
		return 0
	charge = (charge - amount)
	return 1

// recharge the cell
/obj/item/cell/proc/give(amount)
	if(rigged && amount > 0)
		explode()
		return 0

	if(maxcharge < amount)
		return 0
	//var/power_used = min(maxcharge-charge,amount)
	var/amount_used = min(maxcharge - charge, amount)
	if(crit_fail)
		return 0
	if(!prob(reliability))
		minor_fault++
		if(prob(minor_fault))
			crit_fail = TRUE
			return 0
	//charge += power_used
	//return power_used
	charge += amount_used
	return amount_used


/obj/item/cell/examine()
	set src in view(1)
	if(usr /*&& !usr.stat*/)
		if(maxcharge <= 2500)
			to_chat(usr, desc)
			to_chat(usr, "The manufacturer's label states this cell has a power rating of [maxcharge], and that you should not swallow it.")
			to_chat(usr, "The charge meter reads [round(src.percent())]%.")
		else
			to_chat(usr, "This power cell has an exciting chrome finish, as it is an uber-capacity cell type! It has a power rating of [maxcharge]!")
			to_chat(usr, "The charge meter reads [round(src.percent())]%.")
	if(crit_fail)
		to_chat(usr, SPAN_WARNING("This power cell seems to be faulty."))

/obj/item/cell/attack_self(mob/user)
	src.add_fingerprint(user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/clothing/gloves/space_ninja/SNG = H.gloves
		if(!istype(SNG) || !SNG.candrain || !SNG.draining)
			return

		SNG.drain("CELL", src, H.wear_suit)
	return

/obj/item/cell/attackby(obj/item/W, mob/user)
	..()
	if(istype(W, /obj/item/reagent_holder/syringe))
		var/obj/item/reagent_holder/syringe/S = W
		to_chat(user, "You inject the solution into the power cell.")
		if(S.reagents.has_reagent("plasma", 5))
			rigged = 1

			log_admin("LOG: [user.name] ([user.ckey]) injected a power cell with plasma, rigging it to explode.")
			message_admins("LOG: [user.name] ([user.ckey]) injected a power cell with plasma, rigging it to explode.")

		S.reagents.clear_reagents()

/obj/item/cell/proc/explode()
	var/turf/T = GET_TURF(src)
/*
 * 1000-cell	explosion(T, -1, 0, 1, 1)
 * 2500-cell	explosion(T, -1, 0, 1, 1)
 * 10000-cell	explosion(T, -1, 1, 3, 3)
 * 15000-cell	explosion(T, -1, 2, 4, 4)
 * */
	if(charge == 0)
		return
	var/devastation_range = -1 //round(charge/11000)
	var/heavy_impact_range = round(sqrt(charge) / 60)
	var/light_impact_range = round(sqrt(charge) / 30)
	var/flash_range = light_impact_range
	if(light_impact_range == 0)
		rigged = 0
		corrupt()
		return
	//explosion(T, 0, 1, 2, 2)

	log_admin("LOG: Rigged power cell explosion, last touched by [last_fingerprints]")
	message_admins("LOG: Rigged power cell explosion, last touched by [last_fingerprints]")

	explosion(T, devastation_range, heavy_impact_range, light_impact_range, flash_range)

	spawn(1)
		qdel(src)

/obj/item/cell/proc/corrupt()
	charge /= 2
	maxcharge /= 2
	if(prob(10))
		rigged = 1 //broken batterys are dangerous

/obj/item/cell/emp_act(severity)
	charge -= 1000 / severity
	if(charge < 0)
		charge = 0
	if(reliability != 100 && prob(50 / severity))
		reliability -= 10 / severity
	..()

/obj/item/cell/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
			if(prob(50))
				corrupt()
		if(3.0)
			if(prob(25))
				qdel(src)
				return
			if(prob(25))
				corrupt()
	return

/obj/item/cell/blob_act()
	if(prob(75))
		explode()

/obj/item/cell/proc/get_electrocute_damage()
	switch (charge)
/*		if (9000 to INFINITY)
			return min(rand(90,150),rand(90,150))
		if (2500 to 9000-1)
			return min(rand(70,145),rand(70,145))
		if (1750 to 2500-1)
			return min(rand(35,110),rand(35,110))
		if (1500 to 1750-1)
			return min(rand(30,100),rand(30,100))
		if (750 to 1500-1)
			return min(rand(25,90),rand(25,90))
		if (250 to 750-1)
			return min(rand(20,80),rand(20,80))
		if (100 to 250-1)
			return min(rand(20,65),rand(20,65))*/
		if(1000000 to INFINITY)
			return min(rand(50, 160), rand(50, 160))
		if(200000 to 1000000 - 1)
			return min(rand(25, 80), rand(25, 80))
		if(100000 to 200000 - 1)//Ave powernet
			return min(rand(20, 60), rand(20, 60))
		if(50000 to 100000 - 1)
			return min(rand(15, 40), rand(15, 40))
		if(1000 to 50000 - 1)
			return min(rand(10, 20), rand(10, 20))
		else
			return 0