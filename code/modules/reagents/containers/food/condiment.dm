
///////////////////////////////////////////////Condiments
//Notes by Darem: The condiments food-subtype is for stuff you don't actually eat but you use to modify existing food. They all
//	leave empty containers when used up and can be filled/re-filled with other items. Formatting for first section is identical
//	to mixed-drinks code. If you want an object that starts pre-loaded, you need to make it in addition to the other code.

//Food items that aren't eaten normally and leave an empty container behind.
/obj/item/reagent_holder/food/condiment
	name = "Condiment Container"
	desc = "Just your average condiment container."
	icon = 'icons/obj/items/food.dmi'
	icon_state = "emptycondiment"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	possible_transfer_amounts = list(1, 5, 10)
	volume = 50

/obj/item/reagent_holder/food/condiment/attackby(obj/item/W, mob/user)
	return

/obj/item/reagent_holder/food/condiment/attack_self(mob/user)
	return

/obj/item/reagent_holder/food/condiment/attack(mob/M, mob/user, def_zone)
	var/datum/reagents/R = src.reagents

	if(!R || !R.total_volume)
		to_chat(user, SPAN_WARNING("None of [src] left, oh no!"))
		return 0

	if(M == user)
		to_chat(M, SPAN_INFO("You swallow some of contents of the [src]."))
		if(reagents.total_volume)
			reagents.trans_to_ingest(M, 10)

		playsound(M.loc, 'sound/items/drink.ogg', rand(10, 50), 1)
		return 1

	else if(ishuman(M))
		for(var/mob/O in viewers(world.view, user))
			O.show_message(SPAN_WARNING("[user] attempts to feed [M] [src]."), 1)
		if(!do_mob(user, M))
			return
		for(var/mob/O in viewers(world.view, user))
			O.show_message(SPAN_WARNING("[user] feeds [M] [src]."), 1)

		M.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [user.name] ([user.ckey]) Reagents: [reagentlist(src)]</font>"
		user.attack_log += "\[[time_stamp()]\] <font color='red'>Fed [src.name] by [M.name] ([M.ckey]) Reagents: [reagentlist(src)]</font>"
		msg_admin_attack("[user.name] ([user.ckey]) fed [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

		if(reagents.total_volume)
			reagents.trans_to_ingest(M, 10)

		playsound(M.loc, 'sound/items/drink.ogg', rand(10, 50), 1)
		return 1
	return 0

/obj/item/reagent_holder/food/condiment/attackby(obj/item/I, mob/user)
		return

/obj/item/reagent_holder/food/condiment/afterattack(obj/target, mob/user, flag)
	if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.
		if(!target.reagents.total_volume)
			to_chat(user, SPAN_WARNING("[target] is empty."))
			return

		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, SPAN_WARNING("[src] is full."))
			return

		var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
		to_chat(user, SPAN_INFO("You fill [src] with [trans] units of the contents of [target]."))

	//Something like a glass or a food item. Player probably wants to transfer TO it.
	else if(target.is_open_container() || istype(target, /obj/item/reagent_holder/food/snacks))
		if(!reagents.total_volume)
			to_chat(user, SPAN_WARNING("[src] is empty."))
			return
		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, SPAN_WARNING("You can't add any more to [target]."))
			return
		var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, SPAN_INFO("You transfer [trans] units of the condiment to [target]."))

/obj/item/reagent_holder/food/condiment/on_reagent_change()
	if(icon_state == "saltshakersmall" || icon_state == "peppermillsmall")
		return
	if(length(reagents.reagent_list))
		switch(reagents.get_master_reagent_id())
			if("ketchup")
				name = "Ketchup"
				desc = "You feel more American already."
				icon_state = "ketchup"
			if("capsaicin")
				name = "Hotsauce"
				desc = "You can almost TASTE the stomach ulcers now!"
				icon_state = "hotsauce"
			if("enzyme")
				name = "Universal Enzyme"
				desc = "Used in cooking various dishes."
				icon_state = "enzyme"
			if("soysauce")
				name = "Soy Sauce"
				desc = "A salty soy-based flavoring."
				icon_state = "soysauce"
			if("frostoil")
				name = "Coldsauce"
				desc = "Leaves the tongue numb in its passage."
				icon_state = "coldsauce"
			if("sodiumchloride")
				name = "Salt Shaker"
				desc = "Salt. From space oceans, presumably."
				icon_state = "saltshaker"
			if("blackpepper")
				name = "Pepper Mill"
				desc = "Often used to flavor food or make people sneeze."
				icon_state = "peppermillsmall"
			if("cornoil")
				name = "Corn Oil"
				desc = "A delicious oil used in cooking. Made from corn."
				icon_state = "oliveoil"
			if("sugar")
				name = "Sugar"
				desc = "Tastey space sugar!"
			else
				name = "Misc Condiment Bottle"
				if(length(reagents.reagent_list) == 1)
					desc = "Looks like it is [reagents.get_master_reagent_name()], but you are not sure."
				else
					desc = "A mixture of various condiments. [reagents.get_master_reagent_name()] is one of them."
				icon_state = "mixedcondiments"
	else
		icon_state = "emptycondiment"
		name = "Condiment Bottle"
		desc = "An empty condiment bottle."
		return


/obj/item/reagent_holder/food/condiment/enzyme
	name = "Universal Enzyme"
	desc = "Used in cooking various dishes."
	icon_state = "enzyme"
	starting_reagents = alist("enzyme" = 50)

/obj/item/reagent_holder/food/condiment/sugar
	starting_reagents = alist("sugar" = 50)

/obj/item/reagent_holder/food/condiment/saltshaker		//Seperate from above since it's a small shaker rather then
	name = "Salt Shaker"											//	a large one.
	desc = "Salt. From space oceans, presumably."
	icon_state = "saltshakersmall"
	possible_transfer_amounts = list(1, 20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20
	starting_reagents = alist("sodiumchloride" = 20)

/obj/item/reagent_holder/food/condiment/peppermill
	name = "Pepper Mill"
	desc = "Often used to flavor food or make people sneeze."
	icon_state = "peppermillsmall"
	possible_transfer_amounts = list(1, 20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20
	starting_reagents = alist("blackpepper" = 20)