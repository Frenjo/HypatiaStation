/datum/data/vending_product
	var/product_name = "generic"
	var/product_path = null
	var/amount = 0
	var/price = 0
	var/display_color = "blue"

/obj/machinery/vending
	name = "\improper Vendomat"
	desc = "A generic vending machine."
	icon = 'icons/obj/vending.dmi'
	icon_state = "generic"
	var/icon_vend	// Icon_state when vending!
	var/icon_deny	// Icon_state when refusing to vend!

	layer = 2.9
	anchored = TRUE
	density = TRUE

	// If emagged, it ignores if somebody doesn't have card access to the machine.

	// To be filled out at compile time.
	var/list/products	= list() // For each, use the following pattern:
	var/list/contraband	= list() // list(/type/path = amount, /type/path2 = amount2).
	var/list/premium 	= list() // No specified amount = only one in stock.
	var/list/prices		= list() // Prices for each item, list(/type/path = price), items not in the list don't have a price.

	var/list/slogan_list = list()	// Slogans, optional.
	var/list/ad_list = list()		// Small ad messages in the vending screen with a random chance of popping up whenever you open it.
	var/list/product_records = list()
	var/list/hidden_records = list()
	var/list/coin_records = list()

	var/datum/data/vending_product/currently_vending = null // A /datum/data/vending_product instance of what we're paying for right now.

	var/active = TRUE		// No sales pitches if off!
	var/vend_ready = TRUE	// Are we ready to vend?? Is it time??
	var/vend_delay = 10 	// How long does it take to vend?
	var/vend_reply			// Thank you for shopping!
	var/last_reply = 0
	var/last_slogan = 0		// When did we last pitch?
	var/slogan_delay = 6000	// How long until we can pitch again?

	var/seconds_electrified = 0		// Shock customers like an airlock.
	var/shoot_inventory = FALSE		// Fire items at customers! We're broken!
	var/shut_up = TRUE				// Stop spouting those godawful pitches!
	var/extended_inventory = FALSE	// Can we access the hidden inventory?
	var/panel_open = FALSE			// Hacking that vending machine. Gonna get a free candy bar.
	var/obj/item/coin/coin

	var/check_accounts = 0	// 1 = requires PIN and checks accounts. 0 = You slide an ID, it vends, SPACE COMMUNISM!
	var/obj/item/spacecash/ewallet/ewallet

	var/wires = 15
	var/const/WIRE_EXTEND = 1
	var/const/WIRE_SCANID = 2
	var/const/WIRE_SHOCK = 3
	var/const/WIRE_SHOOTINV = 4

/obj/machinery/vending/initialise()
	. = ..()
	// So not all machines speak at the exact same time.
	// The first time this machine says something will be at slogantime + this random value,
	// so if slogantime is 10 minutes, it will say it at somewhere between 10 and 20 minutes after the machine is crated.
	last_slogan = world.time + rand(0, slogan_delay)

	build_inventory(products)
	 //Add hidden inventory
	build_inventory(contraband, 1)
	build_inventory(premium, 0, 1)
	power_change()

/obj/machinery/vending/Destroy()
	QDEL_NULL(coin)
	return ..()

/obj/machinery/vending/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		if(3.0)
			if(prob(25))
				spawn(0)
					malfunction()
					return
				return
		else

/obj/machinery/vending/blob_act()
	if(prob(50))
		spawn(0)
			malfunction()
			qdel(src)
		return

/obj/machinery/vending/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(stat & (BROKEN | NOPOWER))
		FEEDBACK_MACHINE_UNRESPONSIVE(user)
		return FALSE

	if(emagged)
		to_chat(user, SPAN_WARNING("[src]'s product lock is already shorted!"))
		return FALSE
	to_chat(user, SPAN_WARNING("You short out the product lock on [src]."))
	emagged = TRUE
	return TRUE

/obj/machinery/vending/attackby(obj/item/W, mob/user)
	if(isscrewdriver(W))
		panel_open = !panel_open
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
		FEEDBACK_TOGGLE_MAINTENANCE_PANEL(user, panel_open)
		overlays.Cut()
		if(panel_open)
			overlays.Add(image(icon, "[initial(icon_state)]-panel"))
		updateUsrDialog()
		return
	else if(ismultitool(W) || iswirecutter(W))
		if(panel_open)
			attack_hand(user)
		return
	else if(istype(W, /obj/item/coin) && length(premium))
		user.drop_item()
		W.loc = src
		coin = W
		to_chat(user, SPAN_INFO("You insert the [W] into the [src]"))
		return
	else if(istype(W, /obj/item/card) && currently_vending)
		var/obj/item/card/I = W
		scan_card(I)
	else if(istype(W, /obj/item/spacecash/ewallet))
		user.drop_item()
		W.loc = src
		ewallet = W
		to_chat(user, SPAN_INFO("You insert the [W] into the [src]"))
	else if(panel_open)
		for(var/datum/data/vending_product/R in product_records)
			if(istype(W, R.product_path))
				stock(R, user)
				qdel(W)
	else
		..()

/obj/machinery/vending/attack_paw(mob/user)
	return attack_hand(user)

/obj/machinery/vending/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/vending/attack_hand(mob/user)
	if(stat & (BROKEN | NOPOWER))
		return

	user.set_machine(src)

	if(seconds_electrified != 0)
		if(shock(user, 100))
			return

	if(isnotnull(currently_vending))
		var/dat = "<TT><center><b>[name]</b></center><hr /><br>" //display the name, and added a horizontal rule
		dat += "<b>You have selected [currently_vending.product_name].<br>Please swipe your ID to pay for the article.</b><br>"
		dat += "<a href='byond://?src=\ref[src];cancel_buying=1'>Cancel</a>"
		user << browse(dat, "window=vending")
		onclose(user, "")
		return

	var/dat = "<TT><center><b>[name]</b></center><hr /><br>" //display the name, and added a horizontal rule
	dat += "<b>Select an item: </b><br><br>" //the rest is just general spacing and bolding

	if(length(premium))
		dat += "<b>Coin slot:</b> [coin ? coin : "No coin inserted"] (<a href='byond://?src=\ref[src];remove_coin=1'>Remove</A>)<br>"

	if(isnotnull(ewallet))
		dat += "<b>Charge card's credits:</b> [ewallet ? ewallet.worth : "No charge card inserted"] (<a href='byond://?src=\ref[src];remove_ewallet=1'>Remove</A>)<br><br>"

	if(!length(product_records))
		dat += SPAN_WARNING("No product loaded!")
	else
		var/list/display_records = product_records
		if(extended_inventory)
			display_records = product_records + hidden_records
		if(isnotnull(coin))
			display_records = product_records + coin_records
		if(isnotnull(coin) && extended_inventory)
			display_records = product_records + hidden_records + coin_records

		for(var/datum/data/vending_product/R in display_records)
			dat += "<FONT color = '[R.display_color]'><B>[R.product_name]</B>:"
			dat += " <b>[R.amount]</b> </font>"
			if(R.price)
				dat += " <b>(Price: [R.price])</b>"
			if(R.amount > 0)
				dat += " <a href='byond://?src=\ref[src];vend=\ref[R]'>(Vend)</A>"
			else
				dat += " <font color = 'red'>SOLD OUT</font>"
			dat += "<br>"

		dat += "</TT>"

	if(panel_open)
		var/list/vendwires = list(
			"Violet" = 1,
			"Orange" = 2,
			"Goldenrod" = 3,
			"Green" = 4,
		)
		dat += "<br><hr><br><B>Access Panel</B><br>"
		for(var/wiredesc in vendwires)
			var/is_uncut = wires & APCWireColorToFlag[vendwires[wiredesc]]
			dat += "[wiredesc] wire: "
			if(!is_uncut)
				dat += "<a href='byond://?src=\ref[src];cutwire=[vendwires[wiredesc]]'>Mend</a>"
			else
				dat += "<a href='byond://?src=\ref[src];cutwire=[vendwires[wiredesc]]'>Cut</a> "
				dat += "<a href='byond://?src=\ref[src];pulsewire=[vendwires[wiredesc]]'>Pulse</a> "
			dat += "<br>"

		dat += "<br>"
		dat += "The orange light is [seconds_electrified == 0 ? "off" : "on"].<BR>"
		dat += "The red light is [shoot_inventory ? "off" : "blinking"].<BR>"
		dat += "The green light is [extended_inventory ? "on" : "off"].<BR>"
		dat += "The [(wires & WIRE_SCANID) ? "purple" : "yellow"] light is on.<BR>"

		if(length(slogan_list))
			dat += "The speaker switch is [shut_up ? "off" : "on"]. <a href='byond://?src=\ref[src];togglevoice=[1]'>Toggle</a>"

	user << browse(dat, "window=vending")
	onclose(user, "")

/obj/machinery/vending/Topic(href, href_list)
	if(stat & (BROKEN | NOPOWER))
		return
	if(usr.stat || usr.restrained())
		return

	if(href_list["remove_coin"] && !issilicon(usr))
		if(isnull(coin))
			to_chat(usr, "There is no coin in this machine.")
			return

		coin.loc = loc
		if(!usr.get_active_hand())
			usr.put_in_hands(coin)
		to_chat(usr, SPAN_INFO("You remove the [coin] from the [src]"))
		coin = null

	if(href_list["remove_ewallet"] && !issilicon(usr))
		if(isnull(ewallet))
			to_chat(usr, "There is no charge card in this machine.")
			return
		ewallet.loc = loc
		if(!usr.get_active_hand())
			usr.put_in_hands(ewallet)
		to_chat(usr, SPAN_INFO("You remove the [ewallet] from the [src]"))
		ewallet = null

	if(usr.contents.Find(src) || (in_range(src, usr) && isturf(loc)))
		usr.set_machine(src)
		if(href_list["vend"] && vend_ready && !currently_vending)
			if(issilicon(usr))
				if(isrobot(usr))
					var/mob/living/silicon/robot/R = usr
					if(isnull(R.module) || !istype(R.module, /obj/item/robot_model/service))
						to_chat(usr, SPAN_WARNING("The vending machine refuses to interface with you, as you are not in its target demographic!"))
						return
				else
					to_chat(usr, SPAN_WARNING("The vending machine refuses to interface with you, as you are not in its target demographic!"))
					return

			if(!allowed(usr) && !emagged && (wires & WIRE_SCANID)) //For SECURE VENDING MACHINES YEAH
				FEEDBACK_ACCESS_DENIED(usr) // Unless emagged of course.
				flick(icon_deny, src)
				return

			var/datum/data/vending_product/R = locate(href_list["vend"])
			if(isnull(R) || !istype(R) || !R.product_path || R.amount <= 0)
				return

			if(isnull(R.price))
				vend(R, usr)
			else
				if(isnotnull(ewallet))
					if(R.price <= ewallet.worth)
						ewallet.worth -= R.price
						vend(R, usr)
					else
						to_chat(usr, SPAN_WARNING("The ewallet doesn't have enough money to pay for that."))
						currently_vending = R
						updateUsrDialog()
				else
					currently_vending = R
					updateUsrDialog()
			return

		else if(href_list["cancel_buying"])
			currently_vending = null
			updateUsrDialog()
			return

		else if((href_list["cutwire"]) && (panel_open))
			var/twire = text2num(href_list["cutwire"])
			if(!iswirecutter(usr.get_active_hand()))
				to_chat(usr, "You need wirecutters!")
				return
			if(isWireColorCut(twire))
				mend(twire)
			else
				cut(twire)

		else if((href_list["pulsewire"]) && (panel_open))
			var/twire = text2num(href_list["pulsewire"])
			if(!ismultitool(usr.get_active_hand()))
				to_chat(usr, "You need a multitool!")
				return
			if(isWireColorCut(twire))
				to_chat(usr, "You can't pulse a cut wire.")
				return
			else
				pulse(twire)

		else if((href_list["togglevoice"]) && (panel_open))
			shut_up = !shut_up

		add_fingerprint(usr)
		updateUsrDialog()
	else
		usr << browse(null, "window=vending")
		return

/obj/machinery/vending/process()
	if(stat & (BROKEN|NOPOWER))
		return

	if(!active)
		return

	if(seconds_electrified > 0)
		seconds_electrified--

	//Pitch to the people!  Really sell it!
	if((last_slogan + slogan_delay) <= world.time && length(slogan_list) && !shut_up && prob(5))
		var/slogan = pick(slogan_list)
		speak(slogan)
		last_slogan = world.time

	if(shoot_inventory && prob(2))
		throw_item()

/obj/machinery/vending/power_change()
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
		return
	else
		if(powered())
			icon_state = initial(icon_state)
			stat &= ~NOPOWER
		else
			spawn(rand(0, 15))
				icon_state = "[initial(icon_state)]-off"
				stat |= NOPOWER

/obj/machinery/vending/proc/build_inventory(list/productlist, hidden = 0, req_coin = 0)
	for(var/typepath in productlist)
		var/amount = productlist[typepath]
		var/price = prices[typepath]
		if(isnull(amount))
			amount = 1

		var/datum/data/vending_product/R = new /datum/data/vending_product()
		var/atom/temp = typepath
		R.product_name = initial(temp.name)
		R.product_path = typepath
		R.amount = amount
		R.price = price
		R.display_color = pick("red", "blue", "green")

		if(hidden)
			hidden_records.Add(R)
		else if(req_coin)
			coin_records.Add(R)
		else
			product_records.Add(R)
		//to_world("Added: [R.product_name]] - [R.amount] - [R.product_path]")

/obj/machinery/vending/proc/scan_card(obj/item/card/I)
	if(!currently_vending)
		return
	if(istype(I, /obj/item/card/id))
		var/obj/item/card/id/C = I
		visible_message(SPAN_INFO("[usr] swipes a card through [src]."))
		if(check_accounts)
			if(isnotnull(global.CTeconomy.vendor_account))
				var/attempt_pin = input("Enter pin code", "Vendor transaction") as num
				var/datum/money_account/D = attempt_account_access(C.associated_account_number, attempt_pin, 2)
				if(isnotnull(D))
					var/transaction_amount = currently_vending.price
					if(transaction_amount <= D.money)
						//transfer the money
						D.money -= transaction_amount
						global.CTeconomy.vendor_account.money += transaction_amount

						//create entries in the two account transaction logs
						var/datum/transaction/T = new /datum/transaction()
						T.target_name = "[global.CTeconomy.vendor_account.owner_name] (via [name])"
						T.purpose = "Purchase of [currently_vending.product_name]"
						if(transaction_amount > 0)
							T.amount = "([transaction_amount])"
						else
							T.amount = "[transaction_amount]"
						T.source_terminal = name
						T.date = global.CTeconomy.current_date_string
						T.time = worldtime2text()
						D.transaction_log.Add(T)
						//
						T = new /datum/transaction()
						T.target_name = D.owner_name
						T.purpose = "Purchase of [currently_vending.product_name]"
						T.amount = "[transaction_amount]"
						T.source_terminal = name
						T.date = global.CTeconomy.current_date_string
						T.time = worldtime2text()
						global.CTeconomy.vendor_account.transaction_log.Add(T)

						// Vend the item
						vend(currently_vending, usr)
						currently_vending = null
				else
					to_chat(usr, SPAN_WARNING("\icon[src]You don't have that much money!"))
			else
				to_chat(usr, SPAN_WARNING("\icon[src]Unable to access account. Check security settings and try again."))
		else
			//Just Vend it.
			vend(currently_vending, usr)
			currently_vending = null
	else
		to_chat(usr, SPAN_WARNING("\icon[src]Unable to access vendor account. Please record the machine ID and call CentCom Support."))

/obj/machinery/vending/proc/vend(datum/data/vending_product/R, mob/user)
	if(!allowed(user) && !emagged && (wires & WIRE_SCANID)) //For SECURE VENDING MACHINES YEAH
		FEEDBACK_ACCESS_DENIED(user) // Unless emagged of course.
		flick(icon_deny, src)
		return

	vend_ready = FALSE //One thing at a time!!

	if(R in coin_records)
		if(isnull(coin))
			to_chat(user, SPAN_INFO("You need to insert a coin to get this item."))
			return
		if(coin.string_attached)
			if(prob(50))
				to_chat(user, SPAN_INFO("You successfully pull the coin out before the [src] could swallow it."))
			else
				to_chat(user, SPAN_INFO("You weren't able to pull the coin out fast enough, the machine ate it, string and all."))
				qdel(coin)
		else
			qdel(coin)

	R.amount--

	if(((last_reply + (vend_delay + 200)) <= world.time) && vend_reply)
		spawn(0)
			speak(vend_reply)
			last_reply = world.time

	use_power(5)
	if(icon_vend) //Show the vending animation if needed
		flick(icon_vend, src)
	spawn(vend_delay)
		new R.product_path(GET_TURF(src))
		vend_ready = TRUE
		return

	updateUsrDialog()

/obj/machinery/vending/proc/stock(datum/data/vending_product/R, mob/user)
	if(panel_open)
		to_chat(usr, SPAN_INFO("You stock the [src] with \a [R.product_name]"))
		R.amount++

	updateUsrDialog()

/obj/machinery/vending/proc/speak(message)
	if(stat & NOPOWER)
		return

	if(isnotnull(message))
		return

	visible_message("<span class='game say'><span class='name'>[src]</span> beeps, \"[message]\"")

//Oh no we're malfunctioning! Dump out some product and break.
/obj/machinery/vending/proc/malfunction()
	for(var/datum/data/vending_product/R in product_records)
		if(R.amount <= 0) //Try to use a record that actually has something to dump.
			continue
		var/dump_path = R.product_path
		if(isnull(dump_path))
			continue

		while(R.amount > 0)
			new dump_path(loc)
			R.amount--
		break

	stat |= BROKEN
	icon_state = "[initial(icon_state)]-broken"

//Somebody cut an important wire and now we're following a new definition of "pitch."
/obj/machinery/vending/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7, src)
	if(isnull(target))
		return 0

	for(var/datum/data/vending_product/R in product_records)
		if(R.amount <= 0) //Try to use a record that actually has something to dump.
			continue
		var/dump_path = R.product_path
		if(isnull(dump_path))
			continue

		R.amount--
		throw_item = new dump_path(loc)
		break

	if(isnull(throw_item))
		return 0
	spawn(0)
		throw_item.throw_at(target, 16, 3)
	visible_message(SPAN_DANGER("[src] launches [throw_item.name] at [target.name]!"))
	return 1

/obj/machinery/vending/proc/isWireColorCut(wireColor)
	var/wireFlag = APCWireColorToFlag[wireColor]
	return ((wires & wireFlag) == 0)

/obj/machinery/vending/proc/isWireCut(wireIndex)
	var/wireFlag = APCIndexToFlag[wireIndex]
	return ((wires & wireFlag) == 0)

/obj/machinery/vending/proc/cut(wireColor)
	var/wireFlag = APCWireColorToFlag[wireColor]
	var/wireIndex = APCWireColorToIndex[wireColor]
	wires &= ~wireFlag
	switch(wireIndex)
		if(WIRE_EXTEND)
			extended_inventory = FALSE
		if(WIRE_SHOCK)
			seconds_electrified = -1
		if(WIRE_SHOOTINV)
			if(!shoot_inventory)
				shoot_inventory = TRUE

/obj/machinery/vending/proc/mend(wireColor)
	var/wireFlag = APCWireColorToFlag[wireColor]
	var/wireIndex = APCWireColorToIndex[wireColor] //not used in this function
	wires |= wireFlag
	switch(wireIndex)
//		if(WIRE_SCANID)
		if(WIRE_SHOCK)
			seconds_electrified = 0
		if(WIRE_SHOOTINV)
			shoot_inventory = FALSE

/obj/machinery/vending/proc/pulse(wireColor)
	var/wireIndex = APCWireColorToIndex[wireColor]
	switch(wireIndex)
		if(WIRE_EXTEND)
			extended_inventory = !extended_inventory
//		if(WIRE_SCANID)
		if(WIRE_SHOCK)
			seconds_electrified = 30
		if(WIRE_SHOOTINV)
			shoot_inventory = !shoot_inventory

/obj/machinery/vending/proc/shock(mob/user, prb)
	if(stat & (BROKEN | NOPOWER))	// unpowered, no shock
		return 0
	if(!prob(prb))
		return 0

	make_sparks(5, TRUE, src)
	if(electrocute_mob(user, GET_AREA(src), src, 0.7))
		return 1
	else
		return 0

/*
/obj/machinery/vending/[vendors name here]   // --vending machine template   :)
	name = ""
	desc = ""
	icon = ''
	icon_state = ""

	products = list()
	contraband = list()
	premium = list()

	vend_delay = 15
*/