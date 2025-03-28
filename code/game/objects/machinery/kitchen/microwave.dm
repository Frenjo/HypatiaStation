/obj/machinery/microwave
	name = "microwave"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "mw"
	layer = 2.9
	density = TRUE
	anchored = TRUE
	atom_flags = ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_NO_REACT

	power_usage = alist(
		USE_POWER_IDLE = 5,
		USE_POWER_ACTIVE = 100
	)

	var/operating = 0 // Is it on?
	var/dirty = 0 // = {0..100} Does it need cleaning?
	var/broken = 0 // ={0,1,2} How broken is it???
	var/global/list/datum/recipe/available_recipes // List of the recipes you can use
	var/global/list/acceptable_items // List of the items you can put in
	var/global/list/acceptable_reagents // List of the reagents you can put in
	var/global/max_n_of_items = 0

// see code/modules/food/recipes_microwave.dm for recipes

/*******************
*   Initialising
********************/
/obj/machinery/microwave/New()
	. = ..()
	create_reagents(100)
	if(!available_recipes)
		available_recipes = new
		for(var/type in SUBTYPESOF(/datum/recipe))
			available_recipes += new type
		acceptable_items = new
		acceptable_reagents = new
		for(var/datum/recipe/recipe in available_recipes)
			for(var/item in recipe.items)
				acceptable_items |= item
			for(var/reagent in recipe.reagents)
				acceptable_reagents |= reagent
			if(recipe.items)
				max_n_of_items = max(max_n_of_items, length(recipe.items))

		// This will do until I can think of a fun recipe to use dionaea in -
		// will also allow anything using the holder item to be microwaved into
		// impure carbon. ~Z
		acceptable_items |= /obj/item/holder

/*******************
*   Item Adding
********************/
/obj/machinery/microwave/attack_grab(obj/item/grab/grab, mob/user, mob/grabbed)
	to_chat(user, SPAN_WARNING("This is ridiculous. You can not fit \the [grabbed] inside \the [src]."))
	return TRUE

/obj/machinery/microwave/attackby(obj/item/O, mob/user)
	if(src.broken > 0)
		if(src.broken == 2 && isscrewdriver(O)) // If it's broken and they're using a screwdriver
			user.visible_message(SPAN_INFO("[user] starts to fix part of the microwave."), SPAN_INFO("You start to fix part of the microwave."))
			if(do_after(user, 20))
				user.visible_message(SPAN_INFO("[user] fixes part of the microwave."), SPAN_INFO("You have fixed part of the microwave."))
				src.broken = 1 // Fix it a bit
		else if(src.broken == 1 && iswrench(O)) // If it's broken and they're doing the wrench
			user.visible_message(SPAN_INFO("[user] starts to fix part of the microwave."), SPAN_INFO("You start to fix part of the microwave."))
			if(do_after(user, 20))
				user.visible_message(SPAN_INFO("[user] fixes the microwave."), SPAN_INFO("You have fixed the microwave."))
				src.icon_state = "mw"
				src.broken = 0 // Fix it!
				src.dirty = 0 // just to be sure
				SET_ATOM_FLAGS(src, ATOM_FLAG_OPEN_CONTAINER)
		else
			to_chat(user, SPAN_WARNING("It's broken!"))
			return 1
	else if(src.dirty == 100) // The microwave is all dirty so can't be used!
		if(istype(O, /obj/item/reagent_holder/spray/cleaner)) // If they're trying to clean it then let them
			user.visible_message(SPAN_INFO("[user] starts to clean the microwave."), SPAN_INFO("You start to clean the microwave."))
			if(do_after(user, 20))
				user.visible_message(SPAN_INFO("[user]  has cleaned  the microwave."), SPAN_INFO("You have cleaned the microwave."))
				src.dirty = 0 // It's clean!
				src.broken = 0 // just to be sure
				src.icon_state = "mw"
				SET_ATOM_FLAGS(src, ATOM_FLAG_OPEN_CONTAINER)
		else //Otherwise bad luck!!
			to_chat(user, SPAN_WARNING("It's dirty!"))
			return 1
	else if(is_type_in_list(O,acceptable_items))
		if(length(contents) >= max_n_of_items)
			to_chat(user, SPAN_WARNING("This [src] is full of ingredients, you cannot put more."))
			return 1
		if(istype(O, /obj/item/stack) && O:amount > 1)
			new O.type(src)
			O:use(1)
			user.visible_message(SPAN_INFO("[user] has added one of [O] to \the [src]."), SPAN_INFO("You add one of [O] to \the [src]."))
		else
		//	user.before_take_item(O)	//This just causes problems so far as I can tell. -Pete
			user.drop_item()
			O.forceMove(src)
			user.visible_message(SPAN_INFO("[user] has added \the [O] to \the [src]."), SPAN_INFO("You add \the [O] to \the [src]."))

	else if(istype(O, /obj/item/reagent_holder/glass) || istype(O, /obj/item/reagent_holder/food/drinks) || istype(O, /obj/item/reagent_holder/food/condiment))
		if(!O.reagents)
			return 1
		for(var/datum/reagent/R in O.reagents.reagent_list)
			if(!(R.id in acceptable_reagents))
				to_chat(user, SPAN_WARNING("Your [O] contains components unsuitable for cookery."))
				return 1
		//G.reagents.trans_to(src,G.amount_per_transfer_from_this)
	else
		to_chat(user, SPAN_WARNING("You have no idea what you can cook with this [O]."))
		return 1
	src.updateUsrDialog()

/obj/machinery/microwave/attack_paw(mob/user)
	return src.attack_hand(user)

/obj/machinery/microwave/attack_ai(mob/user)
	return 0

/obj/machinery/microwave/attack_hand(mob/user)
	user.set_machine(src)
	interact(user)

/*******************
*   Microwave Menu
********************/
/obj/machinery/microwave/interact(mob/user) // The microwave Menu
	var/dat = ""
	if(src.broken > 0)
		dat = {"<TT>Bzzzzttttt</TT>"}
	else if(src.operating)
		dat = {"<TT>Microwaving in progress!<BR>Please wait...!</TT>"}
	else if(src.dirty == 100)
		dat = {"<TT>This microwave is dirty!<BR>Please clean it before use!</TT>"}
	else
		var/list/items_counts = new
		var/list/items_measures = new
		var/list/items_measures_p = new
		for(var/obj/O in contents)
			var/display_name = O.name
			if(istype(O, /obj/item/reagent_holder/food/snacks/egg))
				items_measures[display_name] = "egg"
				items_measures_p[display_name] = "eggs"
			if(istype(O, /obj/item/reagent_holder/food/snacks/tofu))
				items_measures[display_name] = "tofu chunk"
				items_measures_p[display_name] = "tofu chunks"
			if(istype(O, /obj/item/reagent_holder/food/snacks/meat)) //any meat
				items_measures[display_name] = "slab of meat"
				items_measures_p[display_name] = "slabs of meat"
			if(istype(O, /obj/item/reagent_holder/food/snacks/donkpocket))
				display_name = "Turnovers"
				items_measures[display_name] = "turnover"
				items_measures_p[display_name] = "turnovers"
			if(istype(O, /obj/item/reagent_holder/food/snacks/carpmeat))
				items_measures[display_name] = "fillet of meat"
				items_measures_p[display_name] = "fillets of meat"
			items_counts[display_name]++
		for(var/O in items_counts)
			var/N = items_counts[O]
			if(!(O in items_measures))
				dat += {"<B>[capitalize(O)]:</B> [N] [lowertext(O)]\s<BR>"}
			else
				if(N == 1)
					dat += {"<B>[capitalize(O)]:</B> [N] [items_measures[O]]<BR>"}
				else
					dat += {"<B>[capitalize(O)]:</B> [N] [items_measures_p[O]]<BR>"}

		for(var/datum/reagent/R in reagents.reagent_list)
			var/display_name = R.name
			if(istype(R, /datum/reagent/capsaicin))
				display_name = "Hotsauce"
			if(istype(R, /datum/reagent/frostoil))
				display_name = "Coldsauce"
			dat += {"<B>[display_name]:</B> [R.volume] unit\s<BR>"}

		if(!length(items_counts) && !length(reagents.reagent_list))
			dat = {"<B>The microwave is empty</B><BR>"}
		else
			dat = {"<b>Ingredients:</b><br>[dat]"}
		dat += {"<HR><BR>\
<A href='byond://?src=\ref[src];action=cook'>Turn on!<BR>\
<A href='byond://?src=\ref[src];action=dispose'>Eject ingredients!<BR>\
"}

	user << browse("<HEAD><TITLE>Microwave Controls</TITLE></HEAD><TT>[dat]</TT>", "window=microwave")
	onclose(user, "microwave")
	return

/***********************************
*   Microwave Menu Handling/Cooking
************************************/
/obj/machinery/microwave/proc/cook()
	if(stat & (NOPOWER|BROKEN))
		return
	start()
	if(reagents.total_volume == 0 && !(locate(/obj) in contents)) //dry run
		if(!wzhzhzh(10))
			abort()
			return
		stop()
		return

	var/datum/recipe/recipe = select_recipe(available_recipes,src)
	var/obj/cooked
	if(!recipe)
		dirty += 1
		if(prob(max(10, dirty * 5)))
			if(!wzhzhzh(4))
				abort()
				return
			muck_start()
			wzhzhzh(4)
			muck_finish()
			cooked = fail()
			cooked.forceMove(loc)
			return
		else if(has_extra_item())
			if(!wzhzhzh(4))
				abort()
				return
			broke()
			cooked = fail()
			cooked.forceMove(loc)
			return
		else
			if(!wzhzhzh(10))
				abort()
				return
			stop()
			cooked = fail()
			cooked.forceMove(loc)
			return
	else
		var/halftime = round(recipe.time / 10 / 2)
		if(!wzhzhzh(halftime))
			abort()
			return
		if(!wzhzhzh(halftime))
			abort()
			cooked = fail()
			cooked.forceMove(loc)
			return
		cooked = recipe.make_food(src)
		stop()
		if(cooked)
			cooked.forceMove(loc)
		return

/obj/machinery/microwave/proc/wzhzhzh(seconds as num)
	for(var/i = 1 to seconds)
		if(stat & (NOPOWER | BROKEN))
			return 0
		use_power(500)
		sleep(10)
	return 1

/obj/machinery/microwave/proc/has_extra_item()
	for(var/obj/O in contents)
		if(!istype(O, /obj/item/reagent_holder/food) && !istype(O, /obj/item/grown))
			return 1
	return 0

/obj/machinery/microwave/proc/start()
	src.visible_message(SPAN_INFO("The microwave turns on."), SPAN_INFO("You hear a microwave."))
	src.operating = 1
	src.icon_state = "mw1"
	src.updateUsrDialog()

/obj/machinery/microwave/proc/abort()
	src.operating = 0 // Turn it off again aferwards
	src.icon_state = "mw"
	src.updateUsrDialog()

/obj/machinery/microwave/proc/stop()
	playsound(src, 'sound/machines/ding.ogg', 50, 1)
	src.operating = 0 // Turn it off again aferwards
	src.icon_state = "mw"
	src.updateUsrDialog()

/obj/machinery/microwave/proc/dispose()
	for(var/obj/O in contents)
		O.forceMove(loc)
	if(src.reagents.total_volume)
		src.dirty++
	src.reagents.clear_reagents()
	to_chat(usr, SPAN_INFO("You dispose of the microwave contents."))
	src.updateUsrDialog()

/obj/machinery/microwave/proc/muck_start()
	playsound(src, 'sound/effects/splat.ogg', 50, 1) // Play a splat sound
	src.icon_state = "mwbloody1" // Make it look dirty!!

/obj/machinery/microwave/proc/muck_finish()
	playsound(src, 'sound/machines/ding.ogg', 50, 1)
	src.visible_message(SPAN_WARNING("The microwave gets covered in muck!"))
	src.dirty = 100 // Make it dirty so it can't be used util cleaned
	atom_flags = null //So you can't add condiments
	src.icon_state = "mwbloody" // Make it look dirty too
	src.operating = 0 // Turn it off again aferwards
	src.updateUsrDialog()

/obj/machinery/microwave/proc/broke()
	make_sparks(2, TRUE, src)
	src.icon_state = "mwb" // Make it look all busted up and shit
	src.visible_message(SPAN_WARNING("The microwave breaks!")) //Let them know they're stupid
	src.broken = 2 // Make it broken so it can't be used util fixed
	atom_flags = null //So you can't add condiments
	src.operating = 0 // Turn it off again aferwards
	src.updateUsrDialog()

/obj/machinery/microwave/proc/fail()
	var/obj/item/reagent_holder/food/snacks/badrecipe/ffuu = new(src)
	var/amount = 0
	for(var/obj/O in contents-ffuu)
		amount++
		if(O.reagents)
			var/id = O.reagents.get_master_reagent_id()
			if(id)
				amount += O.reagents.get_reagent_amount(id)
		qdel(O)
	src.reagents.clear_reagents()
	ffuu.reagents.add_reagent("carbon", amount)
	ffuu.reagents.add_reagent("toxin", amount / 10)
	return ffuu

/obj/machinery/microwave/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	if(src.operating)
		src.updateUsrDialog()
		return

	switch(href_list["action"])
		if("cook")
			cook()

		if("dispose")
			dispose()
	return