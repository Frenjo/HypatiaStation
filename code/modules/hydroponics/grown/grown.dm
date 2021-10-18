// ***********************************************************
// Foods that are produced from hydroponics ~~~~~~~~~~
// Data from the seeds carry over to these grown foods
// ***********************************************************

//Grown foods
//Subclass so we can pass on values
/obj/item/weapon/reagent_containers/food/snacks/grown
	var/seed
	var/plantname = ""
	var/productname
	var/species = ""
	var/lifespan = 0
	var/endurance = 0
	var/maturation = 0
	var/production = 0
	var/yield = 0
	var/potency = -1
	var/plant_type = 0
	icon = 'icons/obj/harvest.dmi'
	
/obj/item/weapon/reagent_containers/food/snacks/grown/New(newloc, newpotency)
	if(!isnull(newpotency))
		potency = newpotency
	..()
	src.pixel_x = rand(-5.0, 5)
	src.pixel_y = rand(-5.0, 5)

/obj/item/weapon/reagent_containers/food/snacks/grown/attackby(obj/item/O as obj, mob/user as mob)
	..()
	if(istype(O, /obj/item/device/analyzer/plant_analyzer))
		var/msg
		msg = "*---------*\n This is \a <span class='name'>[src]</span>\n"
		switch(plant_type)
			if(0)
				msg += "- Plant type: <i>Normal plant</i>\n"
			if(1)
				msg += "- Plant type: <i>Weed</i>\n"
			if(2)
				msg += "- Plant type: <i>Mushroom</i>\n"
		msg += "- Potency: <i>[potency]</i>\n"
		msg += "- Yield: <i>[yield]</i>\n"
		msg += "- Maturation speed: <i>[maturation]</i>\n"
		msg += "- Production speed: <i>[production]</i>\n"
		msg += "- Endurance: <i>[endurance]</i>\n"
		msg += "- Healing properties: <i>[reagents.get_reagent_amount("nutriment")]</i>\n"
		msg += "*---------*"
		to_chat(usr, SPAN_INFO(msg))
		return

	/*if (istype(O, /obj/item/weapon/storage/bag/plants))
		var/obj/item/weapon/plantbag/S = O
		if (S.mode == 1)
			for(var/obj/item/G in get_turf(src))
				if(istype(G, /obj/item/seeds) || istype(G, /obj/item/weapon/reagent_containers/food/snacks/grown))
					if (S.contents.len < S.capacity)
						S.contents += G
					else
						user << "\blue The plant bag is full."
						return
			user << "\blue You pick up all the plants and seeds."
		else
			if (S.contents.len < S.capacity)
				S.contents += src;
			else
				user << "\blue The plant bag is full."*/
	return

/*/obj/item/seeds/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if (istype(O, /obj/item/weapon/storage/bag/plants))
		var/obj/item/weapon/plantbag/S = O
		if (S.mode == 1)
			for(var/obj/item/G in get_turf(src))
				if(istype(G, /obj/item/seeds) || istype(G, /obj/item/weapon/reagent_containers/food/snacks/grown))
					if (S.contents.len < S.capacity)
						S.contents += G
					else
						user << "\blue The plant bag is full."
						return
			user << "\blue You pick up all the plants and seeds."
		else
			if (S.contents.len < S.capacity)
				S.contents += src;
			else
				user << "\blue The plant bag is full."
	return*/

/obj/item/weapon/grown/attackby(obj/item/O as obj, mob/user as mob)
	..()
	if(istype(O, /obj/item/device/analyzer/plant_analyzer))
		var/msg
		msg = "*---------*\n This is \a <span class='name'>[src]</span>\n"
		switch(plant_type)
			if(0)
				msg += "- Plant type: <i>Normal plant</i>\n"
			if(1)
				msg += "- Plant type: <i>Weed</i>\n"
			if(2)
				msg += "- Plant type: <i>Mushroom</i>\n"
		msg += "- Acid strength: <i>[potency]</i>\n"
		msg += "- Yield: <i>[yield]</i>\n"
		msg += "- Maturation speed: <i>[maturation]</i>\n"
		msg += "- Production speed: <i>[production]</i>\n"
		msg += "- Endurance: <i>[endurance]</i>\n"
		msg += "*---------*"
		to_chat(usr, SPAN_INFO(msg))
		return
	return