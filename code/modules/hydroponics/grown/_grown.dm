// ***********************************************************
// Foods that are produced from hydroponics ~~~~~~~~~~
// Data from the seeds carry over to these grown foods
// ***********************************************************

//Grown foods
//Subclass so we can pass on values
/obj/item/reagent_holder/food/snacks/grown
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
	icon = 'icons/obj/flora/harvest.dmi'

/obj/item/reagent_holder/food/snacks/grown/New(newloc, newpotency)
	if(isnotnull(newpotency))
		potency = newpotency
	. = ..()
	pixel_x = rand(-5.0, 5)
	pixel_y = rand(-5.0, 5)

/obj/item/reagent_holder/food/snacks/grown/attack_tool(obj/item/tool, mob/user)
	if(istype(tool, /obj/item/plant_analyser))
		var/list/output = list()
		output += SPAN_INFO_B("*---------*")
		output += SPAN_INFO("This is <em>\a <span class='name'>[src]</span></em>")
		switch(plant_type)
			if(0)
				output += SPAN_INFO("- Plant type: <i>Normal</i>")
			if(1)
				output += SPAN_INFO("- Plant type: <i>Weed</i>")
			if(2)
				output += SPAN_INFO("- Plant type: <i>Mushroom</i>")
		output += SPAN_INFO("- Potency: <i>[potency]</i>")
		output += SPAN_INFO("- Yield: <i>[yield]</i>")
		output += SPAN_INFO("- Maturation speed: <i>[maturation]</i>")
		output += SPAN_INFO("- Production speed: <i>[production]</i>")
		output += SPAN_INFO("- Endurance: <i>[endurance]</i>")
		output += SPAN_INFO("- Healing properties: <i>[reagents.get_reagent_amount("nutriment")]</i>")
		output += SPAN_INFO_B("*---------*")

		var/joined_output = jointext(output, "<br>")
		user.show_message("<div class='examine'>[joined_output]</div>", 1)
		return TRUE
	return ..()

	/*if (istype(O, /obj/item/storage/bag/plants))
		var/obj/item/plantbag/S = O
		if (S.mode == 1)
			for(var/obj/item/G in GET_TURF(src))
				if(istype(G, /obj/item/seeds) || istype(G, /obj/item/reagent_holder/food/snacks/grown))
					if(length(S.contents) < S.capacity)
						S.contents += G
					else
						user << "\blue The plant bag is full."
						return
			user << "\blue You pick up all the plants and seeds."
		else
			if(length(S.contents) < S.capacity)
				S.contents += src;
			else
				user << "\blue The plant bag is full."*/

/*/obj/item/seeds/attackby(var/obj/item/O, var/mob/user)
	if (istype(O, /obj/item/storage/bag/plants))
		var/obj/item/plantbag/S = O
		if (S.mode == 1)
			for(var/obj/item/G in GET_TURF(src))
				if(istype(G, /obj/item/seeds) || istype(G, /obj/item/reagent_holder/food/snacks/grown))
					if(length(S.contents) < S.capacity)
						S.contents += G
					else
						user << "\blue The plant bag is full."
						return
			user << "\blue You pick up all the plants and seeds."
		else
			if(length(S.contents) < S.capacity)
				S.contents += src;
			else
				user << "\blue The plant bag is full."
	return*/

/obj/item/grown/attack_tool(obj/item/tool, mob/user)
	if(istype(tool, /obj/item/plant_analyser))
		var/list/output = list()
		output += SPAN_INFO_B("*---------*")
		output += SPAN_INFO("This is <em>\a <span class='name'>[src]</span></em>")
		switch(plant_type)
			if(0)
				output += SPAN_INFO("- Plant type: <i>Normal</i>")
			if(1)
				output += SPAN_INFO("- Plant type: <i>Weed</i>")
			if(2)
				output += SPAN_INFO("- Plant type: <i>Mushroom</i>")
		output += SPAN_INFO("- Potency: <i>[potency]</i>")
		output += SPAN_INFO("- Yield: <i>[yield]</i>")
		output += SPAN_INFO("- Maturation speed: <i>[maturation]</i>")
		output += SPAN_INFO("- Production speed: <i>[production]</i>")
		output += SPAN_INFO("- Endurance: <i>[endurance]</i>")
		output += SPAN_INFO_B("*---------*")

		var/joined_output = jointext(output, "<br>")
		user.show_message("<div class='examine'>[joined_output]</div>", 1)
		return TRUE
	return ..()