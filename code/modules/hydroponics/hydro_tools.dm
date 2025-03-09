/*
 * Plant Analyser
 */
/obj/item/plant_analyser
	name = "plant analyser"
	icon = 'icons/obj/items/devices/scanner.dmi'
	icon_state = "hydro"
	item_state = "analyser"

/obj/item/plant_analyser/attack_self(mob/user)
	return 0

/*
 * Mini Hoe
 */
/obj/item/minihoe // -- Numbers
	name = "mini hoe"
	desc = "It's used for removing weeds or scratching your back."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "hoe"
	item_state = "hoe"
	obj_flags = OBJ_FLAG_CONDUCT
	item_flags = ITEM_FLAG_NO_BLUDGEON
	force = 5.0
	throwforce = 7.0
	w_class = 2.0
	matter_amounts = alist(/decl/material/steel = 50)
	attack_verb = list("slashed", "sliced", "cut", "clawed")

/*
 * Hatchet
 */
/obj/item/hatchet
	name = "hatchet"
	desc = "A very sharp axe blade upon a short fibremetal handle. It has a long history of chopping things, but now it is used for chopping wood."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "hatchet"
	obj_flags = OBJ_FLAG_CONDUCT
	force = 12.0
	sharp = 1
	edge = 1
	w_class = 2.0
	throwforce = 15.0
	throw_speed = 4
	throw_range = 4
	matter_amounts = alist(/decl/material/steel = 15000)
	origin_tech = alist(/decl/tech/materials = 2, /decl/tech/combat = 1)
	attack_verb = list("chopped", "torn", "cut")

/obj/item/hatchet/attack(mob/living/carbon/M, mob/living/carbon/user)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

/*
 * Scythe
 */
/obj/item/scythe
	name = "scythe"
	desc = "A sharp and curved blade on a long fibremetal handle, this tool makes it easy to reap what you sow."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "scythe0"
	force = 13.0
	throwforce = 5.0
	sharp = 1
	edge = 1
	throw_speed = 1
	throw_range = 3
	w_class = 4.0
	item_flags = ITEM_FLAG_NO_SHIELD
	slot_flags = SLOT_BACK
	origin_tech = alist(/decl/tech/materials = 2, /decl/tech/combat = 2)
	attack_verb = list("chopped", "sliced", "cut", "reaped")

/obj/item/scythe/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return
	if(istype(A, /obj/effect/spacevine))
		for(var/obj/effect/spacevine/B in orange(A,1))
			if(prob(80))
				qdel(B)
		qdel(A)

/*
 * Weed Spray
 */
/obj/item/weedspray // -- Skie
	desc = "It's a toxic mixture, in spray form, to kill small weeds."
	icon = 'icons/obj/flora/hydroponics.dmi'
	name = "weed-spray"
	icon_state = "weedspray"
	item_state = "spray"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	item_flags = ITEM_FLAG_NO_BLUDGEON
	slot_flags = SLOT_BELT
	throwforce = 4
	w_class = 2.0
	throw_speed = 2
	throw_range = 10

	var/toxicity = 4
	var/strength = 2

/obj/item/weedspray/suicide_act(mob/user)
	viewers(user) << "\red <b>[user] is huffing the [src.name]! It looks like \he's trying to commit suicide.</b>"
	return (TOXLOSS)

/*
 * Pest Spray
 */
/obj/item/pestspray // -- Skie
	desc = "It's some pest eliminator spray! <I>Do not inhale!</I>"
	icon = 'icons/obj/flora/hydroponics.dmi'
	name = "pest-spray"
	icon_state = "pestspray"
	item_state = "spray"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	item_flags = ITEM_FLAG_NO_BLUDGEON
	slot_flags = SLOT_BELT
	throwforce = 4
	w_class = 2.0
	throw_speed = 2
	throw_range = 10

	var/toxicity = 4
	var/strength = 2

/obj/item/pestspray/suicide_act(mob/user)
	viewers(user) << "\red <b>[user] is huffing the [src.name]! It looks like \he's trying to commit suicide.</b>"
	return (TOXLOSS)

/*
 * Pestkiller
 */
// Generic
/obj/item/pestkiller
	name = "bottle of pestkiller"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"

	var/toxicity = 0
	var/strength = 0

/obj/item/pestkiller/New()
	. = ..()
	pixel_x = rand(-5.0, 5)
	pixel_y = rand(-5.0, 5)

// Carbaryl
/obj/item/pestkiller/carbaryl
	name = "bottle of carbaryl"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"
	toxicity = 4
	strength = 2

// Lindane
/obj/item/pestkiller/lindane
	name = "bottle of lindane"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle18"
	toxicity = 6
	strength = 4

// Phosmet
/obj/item/pestkiller/phosmet
	name = "bottle of phosmet"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle15"
	toxicity = 8
	strength = 7

/*
 * Weedkiller
 */
// Generic
/obj/item/weedkiller
	name = "bottle of weedkiller"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"

	var/toxicity = 0
	var/strength = 0

// Triclopyr
/obj/item/weedkiller/triclopyr
	name = "bottle of glyphosate"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"
	toxicity = 4
	strength = 2

// Lindane
/obj/item/weedkiller/lindane
	name = "bottle of triclopyr"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle18"
	toxicity = 6
	strength = 4

// D24
/obj/item/weedkiller/D24
	name = "bottle of 2,4-D"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle15"
	toxicity = 8
	strength = 7

/*
 * Nutrient
 */
// Generic
/obj/item/nutrient
	name = "bottle of nutrient"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"
	w_class = 1.0

	var/mutmod = 0
	var/yieldmod = 0

/obj/item/nutrient/New()
	. = ..()
	pixel_x = rand(-5.0, 5)
	pixel_y = rand(-5.0, 5)

// E-Z-Nutrient
/obj/item/nutrient/ez
	name = "bottle of E-Z-Nutrient"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"
	mutmod = 1
	yieldmod = 1

// Left 4 Zed
/obj/item/nutrient/l4z
	name = "bottle of Left 4 Zed"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle18"
	mutmod = 2
	yieldmod = 0

// Robust Harvest
/obj/item/nutrient/rh
	name = "bottle of Robust Harvest"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle15"
	mutmod = 0
	yieldmod = 2

/*
 * Corn Cob
 */
/obj/item/corncob
	name = "corn cob"
	desc = "A reminder of meals gone by."
	icon = 'icons/obj/flora/harvest.dmi'
	icon_state = "corncob"
	item_state = "corncob"
	w_class = 1.0
	throwforce = 0
	throw_speed = 4
	throw_range = 20

/obj/item/corncob/attackby(obj/item/W, mob/user)
	..()
	if(istype(W, /obj/item/circular_saw) || istype(W, /obj/item/hatchet) \
	|| istype(W, /obj/item/kitchen/utensil/knife) || istype(W, /obj/item/kitchenknife) \
	|| istype(W, /obj/item/kitchenknife/ritual))
		to_chat(user, SPAN_NOTICE("You use [W] to fashion a pipe out of the corn cob!"))
		new /obj/item/clothing/mask/cigarette/pipe/cobpipe(user.loc)
		qdel(src)
		return

/*
 * SeedBag
 */
//uncomment when this is updated to match storage update
/*
/obj/item/seedbag
	icon = 'icons/obj/flora/hydroponics.dmi'
	icon_state = "seedbag"
	name = "Seed Bag"
	desc = "A small satchel made for organizing seeds."
	var/mode = 1;  //0 = pick one at a time, 1 = pick all on tile
	var/capacity = 500; //the number of seeds it can carry.
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT
	w_class = 1
	var/list/item_quants = list()

/obj/item/seedbag/attack_self(mob/user)
	user.machine = src
	interact(user)

/obj/item/seedbag/verb/toggle_mode()
	set category = PANEL_OBJECT
	set name = "Switch Bagging Method"

	mode = !mode
	switch (mode)
		if(1)
			usr << "The bag now picks up all seeds in a tile at once."
		if(0)
			usr << "The bag now picks up one seed pouch at a time."

/obj/item/seeds/attackby(obj/item/O, mob/user)
	..()
	if (istype(O, /obj/item/seedbag))
		var/obj/item/seedbag/S = O
		if (S.mode == 1)
			for (var/obj/item/seeds/G in locate(src.x,src.y,src.z))
				if(length(S.contents) < S.capacity)
					S.contents += G;
					if(S.item_quants[G.name])
						S.item_quants[G.name]++
					else
						S.item_quants[G.name] = 1
				else
					user << "\blue The seed bag is full."
					S.updateUsrDialog()
					return
			user << "\blue You pick up all the seeds."
		else
			if(length(S.contents) < S.capacity)
				S.contents += src;
				if(S.item_quants[name])
					S.item_quants[name]++
				else
					S.item_quants[name] = 1
			else
				user << "\blue The seed bag is full."
		S.updateUsrDialog()
	return

/obj/item/seedbag/interact(mob/user)

	var/dat = "<TT><b>Select an item:</b><br>"

	if(!length(contents))
		dat += "<font color = 'red'>No seeds loaded!</font>"
	else
		for (var/O in item_quants)
			if(item_quants[O] > 0)
				var/N = item_quants[O]
				dat += "<FONT color = 'blue'><B>[capitalize(O)]</B>:"
				dat += " [N] </font>"
				dat += "<a href='byond://?src=\ref[src];vend=[O]'>Vend</A>"
				dat += "<br>"

		dat += "<br><a href='byond://?src=\ref[src];unload=1'>Unload All</A>"
		dat += "</TT>"
	user << browse("<HEAD><TITLE>Seedbag Supplies</TITLE></HEAD><TT>[dat]</TT>", "window=seedbag")
	onclose(user, "seedbag")
	return

/obj/item/seedbag/Topic(href, href_list)
	if(..())
		return

	usr.machine = src
	if ( href_list["vend"] )
		var/N = href_list["vend"]

		if(item_quants[N] <= 0) // Sanity check, there are probably ways to press the button when it shouldn't be possible.
			return

		item_quants[N] -= 1
		for(var/obj/O in contents)
			if(O.name == N)
				O.forceMove(GET_TURF(src))
				usr.put_in_hands(O)
				break

	else if ( href_list["unload"] )
		item_quants.Cut()
		for(var/obj/O in contents )
			O.forceMove(GET_TURF(src))

	src.updateUsrDialog()
	return

/obj/item/seedbag/updateUsrDialog()
	var/list/nearby = range(1, src)
	for(var/mob/M in nearby)
		if ((M.client && M.machine == src))
			src.attack_self(M)
*/