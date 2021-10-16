/*
 * SeedBag
 */
//uncomment when this is updated to match storage update
/*
/obj/item/weapon/seedbag
	icon = 'icons/obj/hydroponics.dmi'
	icon_state = "seedbag"
	name = "Seed Bag"
	desc = "A small satchel made for organizing seeds."
	var/mode = 1;  //0 = pick one at a time, 1 = pick all on tile
	var/capacity = 500; //the number of seeds it can carry.
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT
	w_class = 1
	var/list/item_quants = list()

/obj/item/weapon/seedbag/attack_self(mob/user as mob)
	user.machine = src
	interact(user)

/obj/item/weapon/seedbag/verb/toggle_mode()
	set name = "Switch Bagging Method"
	set category = "Object"

	mode = !mode
	switch (mode)
		if(1)
			usr << "The bag now picks up all seeds in a tile at once."
		if(0)
			usr << "The bag now picks up one seed pouch at a time."

/obj/item/seeds/attackby(var/obj/item/O as obj, var/mob/user as mob)
	..()
	if (istype(O, /obj/item/weapon/seedbag))
		var/obj/item/weapon/seedbag/S = O
		if (S.mode == 1)
			for (var/obj/item/seeds/G in locate(src.x,src.y,src.z))
				if (S.contents.len < S.capacity)
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
			if (S.contents.len < S.capacity)
				S.contents += src;
				if(S.item_quants[name])
					S.item_quants[name]++
				else
					S.item_quants[name] = 1
			else
				user << "\blue The seed bag is full."
		S.updateUsrDialog()
	return

/obj/item/weapon/seedbag/interact(mob/user as mob)

	var/dat = "<TT><b>Select an item:</b><br>"

	if (contents.len == 0)
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

/obj/item/weapon/seedbag/Topic(href, href_list)
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
				O.loc = get_turf(src)
				usr.put_in_hands(O)
				break

	else if ( href_list["unload"] )
		item_quants.Cut()
		for(var/obj/O in contents )
			O.loc = get_turf(src)

	src.updateUsrDialog()
	return

/obj/item/weapon/seedbag/updateUsrDialog()
	var/list/nearby = range(1, src)
	for(var/mob/M in nearby)
		if ((M.client && M.machine == src))
			src.attack_self(M)
*/

// **********************
// Other harvested materials from plants (that are not food)
// **********************

/obj/item/weapon/grown // Grown weapons
	name = "grown_weapon"
	icon = 'icons/obj/weapons.dmi'
	var/seed
	var/plantname = ""
	var/productname
	var/species = ""
	var/lifespan = 20
	var/endurance = 15
	var/maturation = 7
	var/production = 7
	var/yield = 2
	var/potency = 1
	var/plant_type = 0
	
/obj/item/weapon/grown/New()
	var/datum/reagents/R = new/datum/reagents(50)
	reagents = R
	R.my_atom = src

/obj/item/weapon/grown/proc/changePotency(newValue) //-QualityVan
	potency = newValue

/*
 * Log
 */
/obj/item/weapon/grown/log
	name = "tower-cap log"
	desc = "It's better than bad, it's good!"
	icon = 'icons/obj/harvest.dmi'
	icon_state = "logs"
	force = 5
	throwforce = 5
	w_class = 3.0
	throw_speed = 3
	throw_range = 3
	plant_type = 2
	origin_tech = "materials=1"
	seed = /obj/item/seeds/towermycelium
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")

/obj/item/weapon/grown/log/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/circular_saw) || istype(W, /obj/item/weapon/hatchet) \
	|| (istype(W, /obj/item/weapon/twohanded/fireaxe) && W:wielded) \
	|| istype(W, /obj/item/weapon/melee/energy))
		user.show_message(SPAN_NOTICE("You make planks out of \the [src]!"), 1)
		for(var/i = 0, i < 2, i++)
			var/obj/item/stack/sheet/wood/NG = new(user.loc)
			for(var/obj/item/stack/sheet/wood/G in user.loc)
				if(G == NG)
					continue
				if(G.amount >= G.max_amount)
					continue
				G.attackby(NG, user)
				to_chat(usr, "You add the newly-formed wood to the stack. It now contains [NG.amount] planks.")
		qdel(src)
		return

/*
 * Sunflower
 */
/obj/item/weapon/grown/sunflower // FLOWER POWER!
	name = "sunflower"
	desc = "It's beautiful! A certain person might beat you to death if you trample these."
	icon = 'icons/obj/harvest.dmi'
	icon_state = "sunflower"
	damtype = "fire"
	force = 0
	throwforce = 1
	w_class = 1.0
	throw_speed = 1
	throw_range = 3
	plant_type = 1
	seed = /obj/item/seeds/sunflowerseed

/obj/item/weapon/grown/sunflower/attack(mob/M as mob, mob/user as mob)
	to_chat(M, "<font color='green'><b>[user] smacks you with a sunflower!</font><font color='yellow'><b>FLOWER POWER<b></font>")
	to_chat(user, "<font color='green'>Your sunflower's </font><font color='yellow'><b>FLOWER POWER</b></font><font color='green'> strikes [M]</font>")

/*
 * Gib Tomato
 */
/*
/obj/item/weapon/grown/gibtomato
	desc = "A plump tomato."
	icon = 'icons/obj/harvest.dmi'
	name = "Gib Tomato"
	icon_state = "gibtomato"
	damtype = "fire"
	force = 0
	flags = TABLEPASS
	throwforce = 1
	w_class = 1.0
	throw_speed = 1
	throw_range = 3
	plant_type = 1
	seed = /obj/item/seeds/gibtomato
	New()
		..()

/obj/item/weapon/grown/gibtomato/New()
	..()
	src.gibs = new /obj/effect/gibspawner/human(get_turf(src))
	src.gibs.attach(src)
	src.smoke.set_up(10, 0, usr.loc)
*/

/*
 * Nettle
 */
/obj/item/weapon/grown/nettle // -- Skie
	desc = "It's probably <B>not</B> wise to touch it with bare hands..."
	icon = 'icons/obj/weapons.dmi'
	name = "nettle"
	icon_state = "nettle"
	damtype = "fire"
	force = 15
	throwforce = 1
	w_class = 1.0
	throw_speed = 1
	throw_range = 3
	plant_type = 1
	origin_tech = "combat=1"
	seed = /obj/item/seeds/nettleseed

//So potency can be set in the proc that creates these crops
/obj/item/weapon/grown/nettle/initialize()
	..()
	reagents.add_reagent("nutriment", 1 + round((potency / 50), 1))
	reagents.add_reagent("sacid", round(potency, 1))
	force = round((5 + potency / 5), 1)

/obj/item/weapon/grown/nettle/pickup(mob/living/carbon/human/user as mob)
	if(!user.gloves)
		to_chat(user, SPAN_WARNING("The nettle burns your bare hand!"))
		if(ishuman(user))
			var/organ = ((user.hand ? "l_":"r_") + "arm")
			var/datum/organ/external/affecting = user.get_organ(organ)
			if(affecting.take_damage(0, force))
				user.UpdateDamageIcon()
		else
			user.take_organ_damage(0, force)

/obj/item/weapon/grown/nettle/afterattack(atom/A as mob|obj, mob/user as mob, proximity)
	if(!proximity)
		return
	if(force > 0)
		force -= rand(1, (force / 3) + 1) // When you whack someone with it, leaves fall off
		playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	else
		to_chat(user, "All the leaves have fallen off the nettle from violent whacking.")
		qdel(src)

/obj/item/weapon/grown/nettle/changePotency(newValue) //-QualityVan
	potency = newValue
	force = round((5 + potency / 5), 1)

/*
 * Deathnettle
 */
/obj/item/weapon/grown/deathnettle // -- Skie
	desc = "The \red glowing \black nettle incites \red<B>rage</B>\black in you just from looking at it!"
	icon = 'icons/obj/weapons.dmi'
	name = "deathnettle"
	icon_state = "deathnettle"
	damtype = "fire"
	force = 30
	throwforce = 1
	w_class = 1.0
	throw_speed = 1
	throw_range = 3
	plant_type = 1
	seed = /obj/item/seeds/deathnettleseed
	origin_tech = "combat=3"
	attack_verb = list("stung")

//So potency can be set in the proc that creates these crops
/obj/item/weapon/grown/deathnettle/initialize()
	..()
	reagents.add_reagent("nutriment", 1 + round((potency / 50), 1))
	reagents.add_reagent("pacid", round(potency, 1))
	force = round((5 + potency / 2.5), 1)

/obj/item/weapon/grown/deathnettle/suicide_act(mob/user)
	to_chat(viewers(user), SPAN_DANGER("[user] is eating some of the [src.name]! It looks like \he's trying to commit suicide."))
	return (BRUTELOSS|TOXLOSS)

/obj/item/weapon/grown/deathnettle/pickup(mob/living/carbon/human/user as mob)
	if(!user.gloves)
		if(ishuman(user))
			var/organ = ((user.hand ? "l_":"r_") + "arm")
			var/datum/organ/external/affecting = user.get_organ(organ)
			if(affecting.take_damage(0, force))
				user.UpdateDamageIcon()
		else
			user.take_organ_damage(0, force)
		if(prob(50))
			user.Paralyse(5)
			to_chat(user, SPAN_WARNING("You are stunned by the Deathnettle when you try picking it up!"))

/obj/item/weapon/grown/deathnettle/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(!..())
		return
	if(isliving(M))
		to_chat(M, SPAN_WARNING("You are stunned by the powerful acid of the Deathnettle!"))

		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Had the [src.name] used on them by [user.name] ([user.ckey])</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] on [M.name] ([M.ckey])</font>")
		msg_admin_attack("[user.name] ([user.ckey]) used the [src.name] on [M.name] ([M.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

		playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)

		M.eye_blurry += force / 7
		if(prob(20))
			M.Paralyse(force / 6)
			M.Weaken(force / 15)
		M.drop_item()

/obj/item/weapon/grown/deathnettle/afterattack(atom/A as mob|obj, mob/user as mob, proximity)
	if(!proximity)
		return
	if(force > 0)
		force -= rand(1, (force / 3) + 1) // When you whack someone with it, leaves fall off

	else
		to_chat(user, "All the leaves have fallen off the deathnettle from violent whacking.")
		qdel(src)

/obj/item/weapon/grown/deathnettle/changePotency(newValue) //-QualityVan
	potency = newValue
	force = round((5 + potency / 2.5), 1)

/*
 * Corncob
 */
/obj/item/weapon/corncob/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/circular_saw) || istype(W, /obj/item/weapon/hatchet) \
	|| istype(W, /obj/item/weapon/kitchen/utensil/knife) || istype(W, /obj/item/weapon/kitchenknife) \
	|| istype(W, /obj/item/weapon/kitchenknife/ritual))
		to_chat(user, SPAN_NOTICE("You use [W] to fashion a pipe out of the corn cob!"))
		new /obj/item/clothing/mask/cigarette/pipe/cobpipe(user.loc)
		qdel(src)
		return