/* SmartFridge.  Much todo
*/
/obj/machinery/smartfridge
	name = "\improper SmartFridge"
	icon = 'icons/obj/vending.dmi'
	icon_state = "smartfridge"
	layer = 2.9
	density = TRUE
	anchored = TRUE
	atom_flags = ATOM_FLAG_NO_REACT

	power_usage = alist(
		USE_POWER_IDLE = 5,
		USE_POWER_ACTIVE = 100
	)

	var/global/max_n_of_items = 999 // Sorry but the BYOND infinite loop detector doesn't look things over 1000.
	var/icon_on = "smartfridge"
	var/icon_off = "smartfridge-off"
	var/icon_panel = "smartfridge-panel"
	var/item_quants = list()
	var/ispowered = 1 //starts powered
	var/isbroken = 0
	var/seconds_electrified = 0;
	var/shoot_inventory = 0
	var/locked = 0
	var/panel_open = 0 //Hacking a smartfridge
	var/wires = 7
	var/const/WIRE_SHOCK = 1
	var/const/WIRE_SHOOTINV = 2
	var/const/WIRE_SCANID = 3 //Only used by the secure smartfridge, but required by the cut, mend and pulse procs.


/obj/machinery/smartfridge/proc/accept_check(obj/item/O)
	return istype(O, /obj/item/reagent_holder/food/snacks/grown) || istype(O, /obj/item/seeds)

/obj/machinery/smartfridge/seeds
	name = "\improper MegaSeed Servitor"
	desc = "When you need seeds fast!"
	icon = 'icons/obj/vending.dmi'
	icon_state = "seeds"
	icon_on = "seeds"
	icon_off = "seeds-off"

/obj/machinery/smartfridge/seeds/accept_check(obj/item/O)
	return istype(O, /obj/item/seeds)

/obj/machinery/smartfridge/secure/extract
	name = "slime extract storage"
	desc = "A refrigerated storage unit for slime extracts."
	req_access = list(ACCESS_RESEARCH)

/obj/machinery/smartfridge/secure/extract/accept_check(obj/item/O)
	if(istype(O,/obj/item/slime_extract))
		return 1
	return 0

/obj/machinery/smartfridge/secure/medbay
	name = "refrigerated medicine storage"
	desc = "A refrigerated storage unit for storing medicine and chemicals."
	icon_state = "smartfridge" //To fix the icon in the map editor.
	icon_on = "smartfridge_chem"
	req_one_access = list(ACCESS_MEDICAL, ACCESS_CHEMISTRY)

/obj/machinery/smartfridge/secure/medbay/accept_check(obj/item/O)
	return istype(O, /obj/item/reagent_holder/glass) || istype(O, /obj/item/storage/pill_bottle) || istype(O, /obj/item/reagent_holder/pill)

/obj/machinery/smartfridge/secure/virology
	name = "refrigerated virus storage"
	desc = "A refrigerated storage unit for storing viral material."
	req_access = list(ACCESS_VIROLOGY)
	icon_state = "smartfridge_virology"
	icon_on = "smartfridge_virology"
	icon_off = "smartfridge_virology-off"

/obj/machinery/smartfridge/secure/virology/accept_check(obj/item/O)
	return istype(O, /obj/item/reagent_holder/glass/beaker/vial) || istype(O, /obj/item/virusdish)

/obj/machinery/smartfridge/chemistry
	name = "smart chemical storage"
	desc = "A refrigerated storage unit for medicine and chemical storage."

/obj/machinery/smartfridge/chemistry/accept_check(obj/item/O)
	return istype(O, /obj/item/storage/pill_bottle) || istype(O, /obj/item/reagent_holder)

/obj/machinery/smartfridge/chemistry/virology
	name = "smart virus storage"
	desc = "A refrigerated storage unit for volatile sample storage."

/obj/machinery/smartfridge/drinks
	name = "drink showcase"
	desc = "A refrigerated storage unit for tasty tasty alcohol."

/obj/machinery/smartfridge/drinks/accept_check(obj/item/O)
	return istype(O, /obj/item/reagent_holder/glass) || istype(O, /obj/item/reagent_holder/food/drinks) || istype(O, /obj/item/reagent_holder/food/condiment)

/obj/machinery/smartfridge/process()
	if(!src.ispowered)
		return
	if(src.seconds_electrified > 0)
		src.seconds_electrified--
	if(src.shoot_inventory && prob(2))
		src.throw_item()

/obj/machinery/smartfridge/power_change()
	if( powered() )
		src.ispowered = 1
		stat &= ~NOPOWER
		if(!isbroken)
			icon_state = icon_on
	else
		spawn(rand(0, 15))
		src.ispowered = 0
		stat |= NOPOWER
		if(!isbroken)
			icon_state = icon_off


/*******************
*   Item Adding
********************/

/obj/machinery/smartfridge/attackby(obj/item/O, mob/user)
	if(!src.ispowered)
		to_chat(user, SPAN_NOTICE("\The [src] is unpowered and useless."))
		return

	if(accept_check(O))
		if(length(contents) >= max_n_of_items)
			to_chat(user, SPAN_NOTICE("\The [src] is full."))
			return 1
		else
			user.before_take_item(O)
			O.forceMove(src)
			if(item_quants[O.name])
				item_quants[O.name]++
			else
				item_quants[O.name] = 1
			user.visible_message(
				SPAN_NOTICE("[user] has added \the [O] to \the [src]."),
				SPAN_NOTICE("You add \the [O] to \the [src].")
			)

	else if(istype(O, /obj/item/storage/bag/plants))
		var/obj/item/storage/bag/plants/P = O
		var/plants_loaded = 0
		for(var/obj/G in P.contents)
			if(accept_check(G))
				if(length(contents) >= max_n_of_items)
					to_chat(user, SPAN_NOTICE("\The [src] is full."))
					return 1
				else
					P.remove_from_storage(G,src)
					if(item_quants[G.name])
						item_quants[G.name]++
					else
						item_quants[G.name] = 1
					plants_loaded++
		if(plants_loaded)

			user.visible_message(
				SPAN_NOTICE("[user] loads \the [src] with \the [P]."),
				SPAN_NOTICE("You load \the [src] with \the [P].")
			)
			if(length(P.contents))
				to_chat(user, SPAN_NOTICE("Some items are refused."))

	else
		to_chat(user, SPAN_NOTICE("\The [src] smartly refuses [O]."))
		return 1

	updateUsrDialog()

/obj/machinery/smartfridge/secure/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(emagged)
		FEEDBACK_ALREADY_EMAGGED(user)
		return FALSE

	emagged = TRUE
	to_chat(user, SPAN_WARNING("You short out the product lock on \the [src]."))
	return TRUE

/obj/machinery/smartfridge/secure/attackby(obj/item/O, mob/user)
	if(isscrewdriver(O))
		panel_open = !panel_open
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
		FEEDBACK_TOGGLE_MAINTENANCE_PANEL(user, panel_open)
		cut_overlays()
		if(panel_open)
			add_overlay(icon_panel)
		updateUsrDialog()
		return
	else if(ismultitool(O) || iswirecutter(O))
		if(src.panel_open)
			attack_hand(user)
		return
	..()
	return

/obj/machinery/smartfridge/attack_paw(mob/user)
	return src.attack_hand(user)

/obj/machinery/smartfridge/attack_ai(mob/user)
	return 0

/obj/machinery/smartfridge/attack_hand(mob/user)
	user.set_machine(src)
	if(src.seconds_electrified != 0)
		if(src.shock(user, 100))
			return
	interact(user)

/*******************
*   SmartFridge Menu
********************/

/obj/machinery/smartfridge/interact(mob/user)
	if(!src.ispowered)
		return

	var/dat = "<TT><b>Select an item:</b><br>"

	if(!length(contents))
		dat += "<font color = 'red'>No product loaded!</font>"
	else
		for (var/O in item_quants)
			if(item_quants[O] > 0)
				var/N = item_quants[O]
				dat += "<FONT color = 'blue'><B>[capitalize(O)]</B>:"
				dat += " [N] </font>"
				dat += "<a href='byond://?src=\ref[src];vend=[O];amount=1'>Vend</A> "
				if(N > 5)
					dat += "(<a href='byond://?src=\ref[src];vend=[O];amount=5'>x5</A>)"
					if(N > 10)
						dat += "(<a href='byond://?src=\ref[src];vend=[O];amount=10'>x10</A>)"
						if(N > 25)
							dat += "(<a href='byond://?src=\ref[src];vend=[O];amount=25'>x25</A>)"
				if(N > 1)
					dat += "(<a href='byond://?src=\ref[src];vend=[O];amount=[N]'>All</A>)"
				dat += "<br>"

		dat += "</TT>"
	if(panel_open)
		//One of the wires does absolutely nothing.
		var/list/vendwires = list(
			"Blue" = 1,
			"Red" = 2,
			"Black" = 3
		)
		dat += "<br><hr><br><B>Access Panel</B><br>"
		for(var/wiredesc in vendwires)
			var/is_uncut = src.wires & APCWireColorToFlag[vendwires[wiredesc]]
			dat += "[wiredesc] wire: "
			if(!is_uncut)
				dat += "<a href='byond://?src=\ref[src];cutwire=[vendwires[wiredesc]]'>Mend</a>"
			else
				dat += "<a href='byond://?src=\ref[src];cutwire=[vendwires[wiredesc]]'>Cut</a> "
				dat += "<a href='byond://?src=\ref[src];pulsewire=[vendwires[wiredesc]]'>Pulse</a> "
			dat += "<br>"

		dat += "<br>"
		dat += "The orange light is [(src.seconds_electrified == 0) ? "off" : "on"].<BR>"
		dat += "The red light is [src.shoot_inventory ? "off" : "blinking"].<BR>"
	user << browse("<HEAD><TITLE>[src] Supplies</TITLE></HEAD><TT>[dat]</TT>", "window=smartfridge")
	return

/obj/machinery/smartfridge/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)

	if ((href_list["cutwire"]) && (src.panel_open))
		var/twire = text2num(href_list["cutwire"])
		if(!iswirecutter(usr.get_active_hand()))
			usr << "You need wirecutters!"
			return
		if (src.isWireColorCut(twire))
			src.mend(twire)
		else
			src.cut(twire)
	else if ((href_list["pulsewire"]) && (src.panel_open))
		var/twire = text2num(href_list["pulsewire"])
		if(!ismultitool(usr.get_active_hand()))
			usr << "You need a multitool!"
			return
		if (src.isWireColorCut(twire))
			usr << "You can't pulse a cut wire."
			return
		else
			src.pulse(twire)
	else if (href_list["vend"])
		var/N = href_list["vend"]
		var/amount = text2num(href_list["amount"])

		if(item_quants[N] <= 0) // Sanity check, there are probably ways to press the button when it shouldn't be possible.
			return

		item_quants[N] = max(item_quants[N] - amount, 0)

		var/i = amount
		for(var/obj/O in contents)
			if(O.name == N)
				O.forceMove(loc)
				i--
				if(i <= 0)
					break
	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return

/*************
*	Hacking
**************/

/obj/machinery/smartfridge/proc/cut(var/wireColor)
	var/wireFlag = APCWireColorToFlag[wireColor]
	var/wireIndex = APCWireColorToIndex[wireColor]
	src.wires &= ~wireFlag
	switch(wireIndex)
		if(WIRE_SHOCK)
			src.seconds_electrified = -1
		if (WIRE_SHOOTINV)
			if(!src.shoot_inventory)
				src.shoot_inventory = 1
		if(WIRE_SCANID)
			src.locked = 1

/obj/machinery/smartfridge/proc/mend(var/wireColor)
	var/wireFlag = APCWireColorToFlag[wireColor]
	var/wireIndex = APCWireColorToIndex[wireColor] //not used in this function
	src.wires |= wireFlag
	switch(wireIndex)
		if(WIRE_SHOCK)
			src.seconds_electrified = 0
		if (WIRE_SHOOTINV)
			src.shoot_inventory = 0
		if(WIRE_SCANID)
			src.locked = 0

/obj/machinery/smartfridge/proc/pulse(var/wireColor)
	var/wireIndex = APCWireColorToIndex[wireColor]
	switch(wireIndex)
		if(WIRE_SHOCK)
			src.seconds_electrified = 30
		if (WIRE_SHOOTINV)
			src.shoot_inventory = !src.shoot_inventory
		if(WIRE_SCANID)
			src.locked = -1

/obj/machinery/smartfridge/proc/isWireColorCut(var/wireColor)
	var/wireFlag = APCWireColorToFlag[wireColor]
	return ((src.wires & wireFlag) == 0)

/obj/machinery/smartfridge/proc/isWireCut(var/wireIndex)
	var/wireFlag = APCIndexToFlag[wireIndex]
	return ((src.wires & wireFlag) == 0)

/obj/machinery/smartfridge/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return 0

	for (var/O in item_quants)
		if(item_quants[O] <= 0) //Try to use a record that actually has something to dump.
			continue

		item_quants[O]--
		for(var/obj/T in contents)
			if(T.name == O)
				T.forceMove(loc)
				throw_item = T
				break
		break
	if(!throw_item)
		return 0
	spawn(0)
		throw_item.throw_at(target,16,3)
	src.visible_message("\red <b>[src] launches [throw_item.name] at [target.name]!</b>")
	return 1

/obj/machinery/smartfridge/proc/shock(mob/user, prb)
	if(!src.ispowered)		// unpowered, no shock
		return 0
	if(!prob(prb))
		return 0
	make_sparks(5, TRUE, src)
	if(electrocute_mob(user, GET_AREA(src), src, 0.7))
		return 1
	else
		return 0

/************************
*   Secure SmartFridges
*************************/

/obj/machinery/smartfridge/secure/Topic(href, href_list)
	usr.set_machine(src)
	if((usr.contents.Find(src) || (in_range(src, usr) && isturf(src.loc))))
		if ((!src.allowed(usr)) && (!src.emagged) && (src.locked != -1) && href_list["vend"]) //For SECURE VENDING MACHINES YEAH
			FEEDBACK_ACCESS_DENIED(usr) // Unless emagged of course.
			return
	..()
	return

/obj/machinery/smartfridge/secure/interact(mob/user )

	if(!src.ispowered)
		return

	var/dat = "<TT><b>Select an item:</b><br>"

	if(length(contents))
		dat += "<font color = 'red'>No product loaded!</font>"
	else
		for (var/O in item_quants)
			if(item_quants[O] > 0)
				var/N = item_quants[O]
				dat += "<FONT color = 'blue'><B>[capitalize(O)]</B>:"
				dat += " [N] </font>"
				dat += "<a href='byond://?src=\ref[src];vend=[O];amount=1'>Vend</A> "
				if(N > 5)
					dat += "(<a href='byond://?src=\ref[src];vend=[O];amount=5'>x5</A>)"
					if(N > 10)
						dat += "(<a href='byond://?src=\ref[src];vend=[O];amount=10'>x10</A>)"
						if(N > 25)
							dat += "(<a href='byond://?src=\ref[src];vend=[O];amount=25'>x25</A>)"
				if(N > 1)
					dat += "(<a href='byond://?src=\ref[src];vend=[O];amount=[N]'>All</A>)"
				dat += "<br>"

		dat += "</TT>"
	if(panel_open)
		var/list/vendwires = list(
			"Violet" = 1,
			"Orange" = 2,
			"Green" = 3
		)
		dat += "<br><hr><br><B>Access Panel</B><br>"
		for(var/wiredesc in vendwires)
			var/is_uncut = src.wires & APCWireColorToFlag[vendwires[wiredesc]]
			dat += "[wiredesc] wire: "
			if(!is_uncut)
				dat += "<a href='byond://?src=\ref[src];cutwire=[vendwires[wiredesc]]'>Mend</a>"
			else
				dat += "<a href='byond://?src=\ref[src];cutwire=[vendwires[wiredesc]]'>Cut</a> "
				dat += "<a href='byond://?src=\ref[src];pulsewire=[vendwires[wiredesc]]'>Pulse</a> "
			dat += "<br>"

		dat += "<br>"
		dat += "The orange light is [(src.seconds_electrified == 0) ? "off" : "on"].<BR>"
		//dat += "The red light is [src.shoot_inventory ? "off" : "blinking"].<BR>"
		dat += "The green light is [src.locked == 1 ? "off" : "[src.locked == -1 ? "blinking" : "on"]"].<BR>"
	user << browse("<HEAD><TITLE>[src] Supplies</TITLE></HEAD><TT>[dat]</TT>", "window=smartfridge")
	return

//TODO: Make smartfridges hackable. - JoeyJo0
