/*
 * Suit Storage Unit
 */
/obj/machinery/suit_storage_unit
	name = "suit storage unit"
	desc = "An industrial U-Stor-It Storage unit designed to accomodate all kinds of space suits. Its on-board equipment also allows the user to decontaminate the contents through a UV-ray purging cycle. There's a warning label dangling from the control pad, reading \"STRICTLY NO BIOLOGICALS IN THE CONFINES OF THE UNIT\"."
	icon = 'icons/obj/suitstorage.dmi'
	icon_state = "suitstorage000000100" //order is: [has helmet][has suit][has human][is open][is locked][is UV cycling][is powered][is dirty/broken] [is superUVcycling]
	anchored = TRUE
	density = TRUE

	var/mob/living/carbon/human/occupant = null

	//Erro's idea on standarising SSUs whle keeping creation of other SSU types easy: Make a child SSU, name it something then set the TYPE vars to your desired suit output. New() should take it from there by itself.
	var/helmet_type = null
	var/suit_type = null
	var/mask_type = null
	var/obj/item/clothing/head/helmet/space/helmet = null
	var/obj/item/clothing/suit/space/suit = null
	var/obj/item/clothing/mask/mask = null //All the stuff that's gonna be stored insiiiiiiiiiiiiiiiiiiide, nyoro~n

	var/isopen = FALSE
	var/islocked = FALSE
	var/isUV = FALSE
	var/ispowered = TRUE //starts powered
	var/isbroken = FALSE
	var/issuperUV = FALSE
	var/panelopen = FALSE
	var/safetieson = TRUE
	var/cycletime_left = 0

/obj/machinery/suit_storage_unit/New()
	. = ..()
	update_icon()
	if(isnotnull(helmet_type))
		helmet = new helmet_type(src)
	if(isnotnull(suit_type))
		suit = new suit_type(src)
	if(isnotnull(mask_type))
		mask = new mask_type(src)

/obj/machinery/suit_storage_unit/update_icon()
	var/hashelmet = FALSE
	var/hassuit = FALSE
	var/hashuman = FALSE
	if(isnotnull(helmet))
		hashelmet = TRUE
	if(isnotnull(suit))
		hassuit = TRUE
	if(isnotnull(occupant))
		hashuman = TRUE
	icon_state = "suitstorage[hashelmet][hassuit][hashuman][isopen][islocked][isUV][ispowered][isbroken][issuperUV]"

/obj/machinery/suit_storage_unit/power_change()
	if(powered())
		ispowered = TRUE
		stat &= ~NOPOWER
		update_icon()
	else
		spawn(rand(0, 15))
			ispowered = FALSE
			stat |= NOPOWER
			islocked = FALSE
			isopen = TRUE
			dump_everything()
			update_icon()

/obj/machinery/suit_storage_unit/ex_act(severity)
	switch(severity)
		if(1)
			if(prob(50))
				dump_everything() //So suits dont survive all the time
			qdel(src)
			return
		if(2)
			if(prob(50))
				dump_everything()
				qdel(src)
			return
		else
			return

/obj/machinery/suit_storage_unit/attack_hand(mob/user as mob)
	var/dat
	if(..())
		return
	if(stat & NOPOWER)
		return
	if(panelopen) //The maintenance panel is open. Time for some shady stuff
		dat += "<HEAD><TITLE>Suit storage unit: Maintenance panel</TITLE></HEAD>"
		dat += "<Font color ='black'><B>Maintenance panel controls</B></font><HR>"
		dat += "<font color ='grey'>The panel is ridden with controls, button and meters, labeled in strange signs and symbols that <BR>you cannot understand. Probably the manufactoring world's language.<BR> Among other things, a few controls catch your eye.<BR><BR>"
		dat += "<font color ='black'>A small dial with a \"�\" symbol embroidded on it. It's pointing towards a gauge that reads [(issuperUV ? "15nm" : "185nm")]</font>.<BR> <font color='blue'><A href='?src=\ref[src];toggleUV=1'> Turn towards [(issuperUV ? "185nm" : "15nm")]</A><BR>"
		dat += "<font color ='black'>A thick old-style button, with 2 grimy LED lights next to it. The [(safetieson ? "<font color='green'><B>GREEN</B></font>" : "<font color='red'><B>RED</B></font>")] LED is on.</font><BR><font color ='blue'><A href='?src=\ref[src];togglesafeties=1'>Press button</a></font>"
		dat += "<HR><BR><A href='?src=\ref[user];mach_close=suit_storage_unit'>Close panel</A>"
		//user << browse(dat, "window=ssu_m_panel;size=400x500")
		//onclose(user, "ssu_m_panel")
	else if(isUV) //The thing is running its cauterisation cycle. You have to wait.
		dat += "<HEAD><TITLE>Suit storage unit</TITLE></HEAD>"
		dat += "<font color ='red'><B>Unit is cauterising contents with selected UV ray intensity. Please wait.</font></B><BR>"
		//dat+= "<font colr='black'><B>Cycle end in: [cycletimeleft()] seconds. </font></B>"
		//user << browse(dat, "window=ssu_cycling_panel;size=400x500")
		//onclose(user, "ssu_cycling_panel")

	else
		if(!isbroken)
			dat += "<HEAD><TITLE>Suit storage unit</TITLE></HEAD>"
			dat += "<font color='blue'><font size = 4><B>U-Stor-It Suit Storage Unit, model DS1900</B></FONT><BR>"
			dat += "<B>Welcome to the Unit control panel.</B><HR>"
			dat += "<font color='black'>Helmet storage compartment: <B>[(helmet ? helmet.name : "</font><font color ='grey'>No helmet detected.")]</B></font><BR>"
			if(isnotnull(helmet) && isopen)
				dat += "<A href='?src=\ref[src];dispense_helmet=1'>Dispense helmet</A><BR>"
			dat += "<font color='black'>Suit storage compartment: <B>[(suit ? suit.name : "</font><font color ='grey'>No exosuit detected.")]</B></font><BR>"
			if(isnotnull(suit) && isopen)
				dat += "<A href='?src=\ref[src];dispense_suit=1'>Dispense suit</A><BR>"
			dat += "<font color='black'>Breathmask storage compartment: <B>[(mask ? mask.name : "</font><font color ='grey'>No breathmask detected.")]</B></font><BR>"
			if(isnotnull(mask) && isopen)
				dat += "<A href='?src=\ref[src];dispense_mask=1'>Dispense mask</A><BR>"
			if(isnotnull(occupant))
				dat += "<HR><B><font color ='red'>WARNING: Biological entity detected inside the Unit's storage. Please remove.</B></font><BR>"
				dat += "<A href='?src=\ref[src];eject_guy=1'>Eject extra load</A>"
			dat += "<HR><font color='black'>Unit is: [(isopen ? "Open" : "Closed")] - <A href='?src=\ref[src];toggle_open=1'>[(isopen ? "Close" : "Open")] Unit</A></font> "
			if(isopen)
				dat += "<HR>"
			else
				dat += " - <A href='?src=\ref[src];toggle_lock=1'><font color ='orange'>*[(islocked ? "Unlock" : "Lock")] Unit*</A></font><HR>"
			dat += "Unit status: [(islocked ? "<font color ='red'><B>**LOCKED**</B></font><BR>" : "<font color ='green'><B>**UNLOCKED**</B></font><BR>")]"
			dat += "<A href='?src=\ref[src];start_UV=1'>Start Disinfection cycle</A><BR>"
			dat += "<BR><BR><A href='?src=\ref[user];mach_close=suit_storage_unit'>Close control panel</A>"
			//user << browse(dat, "window=Suit Storage Unit;size=400x500")
			//onclose(user, "Suit Storage Unit")
		else //Ohhhh shit it's dirty or broken! Let's inform the guy.
			dat += "<HEAD><TITLE>Suit storage unit</TITLE></HEAD>"
			dat += "<font color='maroon'><B>Unit chamber is too contaminated to continue usage. Please call for a qualified individual to perform maintenance.</font></B><BR><BR>"
			dat += "<HR><A href='?src=\ref[user];mach_close=suit_storage_unit'>Close control panel</A>"
			//user << browse(dat, "window=suit_storage_unit;size=400x500")
			//onclose(user, "suit_storage_unit")

	user << browse(dat, "window=suit_storage_unit;size=400x500")
	onclose(user, "suit_storage_unit")

/obj/machinery/suit_storage_unit/Topic(href, href_list) //I fucking HATE this proc
	if(..())
		return
	if((usr.contents.Find(src) || (in_range(src, usr) && isturf(loc))) || issilicon(usr))
		usr.set_machine(src)
		if(href_list["toggleUV"])
			toggleUV(usr)
		if(href_list["togglesafeties"])
			togglesafeties(usr)
		if(href_list["dispense_helmet"])
			dispense_helmet(usr)
		if(href_list["dispense_suit"])
			dispense_suit(usr)
		if(href_list["dispense_mask"])
			dispense_mask(usr)
		if(href_list["toggle_open"])
			toggle_open(usr)
		if(href_list["toggle_lock"])
			toggle_lock(usr)
		if(href_list["start_UV"])
			start_UV(usr)
		if(href_list["eject_guy"])
			eject_occupant(usr)
	/*if (href_list["refresh"])
		updateUsrDialog()*/

	updateUsrDialog()
	update_icon()
	add_fingerprint(usr)

/obj/machinery/suit_storage_unit/proc/toggleUV(mob/user as mob)
//	var/protected = 0
//	var/mob/living/carbon/human/H = user
	if(!panelopen)
		return

	/*if(istype(H)) //Let's check if the guy's wearing electrically insulated gloves
		if(H.gloves)
			var/obj/item/clothing/gloves/G = H.gloves
			if(istype(G,/obj/item/clothing/gloves/yellow))
				protected = 1

	if(!protected)
		playsound(loc, "sparks", 75, 1, -1)
		user << "<font color='red'>You try to touch the controls but you get zapped. There must be a short circuit somewhere.</font>"
		return*/
	else //welp, the guy is protected, we can continue
		if(issuperUV)
			to_chat(user, "You slide the dial back towards \"185nm\".")
			issuperUV = FALSE
		else
			to_chat(user, "You crank the dial all the way up to \"15nm\".")
			issuperUV = TRUE
		return

/obj/machinery/suit_storage_unit/proc/togglesafeties(mob/user as mob)
//	var/protected = 0
//	var/mob/living/carbon/human/H = user
	if(!panelopen) //Needed check due to bugs
		return

	/*if(istype(H)) //Let's check if the guy's wearing electrically insulated gloves
		if(H.gloves)
			var/obj/item/clothing/gloves/G = H.gloves
			if(istype(G,/obj/item/clothing/gloves/yellow) )
				protected = 1

	if(!protected)
		playsound(loc, "sparks", 75, 1, -1)
		user << "<font color='red'>You try to touch the controls but you get zapped. There must be a short circuit somewhere.</font>"
		return*/
	else
		to_chat(user, "You push the button. The coloured LED next to it changes.")
		safetieson = !safetieson

/obj/machinery/suit_storage_unit/proc/dispense_helmet(mob/user as mob)
	if(isnull(helmet))
		return //Do I even need this sanity check? Nyoro~n

	helmet.loc = loc
	helmet = null

/obj/machinery/suit_storage_unit/proc/dispense_suit(mob/user as mob)
	if(isnull(suit))
		return

	suit.loc = loc
	suit = null

/obj/machinery/suit_storage_unit/proc/dispense_mask(mob/user as mob)
	if(isnull(mask))
		return

	mask.loc = loc
	mask = null

/obj/machinery/suit_storage_unit/proc/dump_everything()
	islocked = FALSE //locks go free
	if(isnotnull(suit))
		suit.loc = loc
		suit = null
	if(isnotnull(helmet))
		helmet.loc = loc
		helmet = null
	if(isnotnull(mask))
		mask.loc = loc
		mask = null
	if(isnotnull(occupant))
		eject_occupant(occupant)

/obj/machinery/suit_storage_unit/proc/toggle_open(mob/user as mob)
	if(islocked || isUV)
		to_chat(user, SPAN_WARNING("Unable to open unit."))
		return
	if(isnotnull(occupant))
		eject_occupant(user)
		return // eject_occupant opens the door, so we need to return
	isopen = !isopen

/obj/machinery/suit_storage_unit/proc/toggle_lock(mob/user as mob)
	if(isnotnull(occupant) && safetieson)
		to_chat(user, SPAN_WARNING("The Unit's safety protocols disallow locking when a biological form is detected inside its compartments."))
		return
	if(isopen)
		return
	islocked = !islocked

/obj/machinery/suit_storage_unit/proc/start_UV(mob/user as mob)
	if(isUV || isopen) //I'm bored of all these sanity checks
		return
	if(isnotnull(occupant) && safetieson)
		to_chat(user, SPAN_WARNING("<B>WARNING:</B> Biological entity detected in the confines of the Unit's storage. Cannot initiate cycle."))
		return
	if(isnull(helmet) && isnull(mask) && isnull(suit) && isnull(occupant)) //shit's empty yo
		to_chat(user, SPAN_WARNING("Unit storage bays empty. Nothing to disinfect -- Aborting."))
		return
	to_chat(user, "You start the Unit's cauterisation cycle.")
	cycletime_left = 20
	isUV = TRUE
	if(isnotnull(occupant) && !islocked)
		islocked = TRUE //Let's lock it for good measure
	update_icon()
	updateUsrDialog()

	var/i //our counter
	for(i = 0, i < 4, i++)
		sleep(50)
		if(isnotnull(occupant))
			if(issuperUV)
				var/burndamage = rand(28, 35)
				occupant.take_organ_damage(0, burndamage)
				occupant.emote("scream")
			else
				var/burndamage = rand(6, 10)
				occupant.take_organ_damage(0, burndamage)
				occupant.emote("scream")
		if(i == 3) //End of the cycle
			if(!issuperUV)
				helmet?.clean_blood()
				suit?.clean_blood()
				mask?.clean_blood()
			else //It was supercycling, destroy everything
				if(isnotnull(helmet))
					helmet = null
				if(isnotnull(suit))
					suit = null
				if(isnotnull(mask))
					mask = null
				visible_message(SPAN_WARNING("With a loud whining noise, the Suit Storage Unit's door grinds open. Puffs of ashen smoke come out of its chamber."), 3)
				isbroken = TRUE
				isopen = TRUE
				islocked = FALSE
				eject_occupant(occupant) //Mixing up these two lines causes bug. DO NOT DO IT.
			isUV = FALSE //Cycle ends
	update_icon()
	updateUsrDialog()

/*	spawn(200) //Let's clean dat shit after 20 secs  //Eh, this doesn't work
		if(helmet)
			helmet.clean_blood()
		if(suit)
			suit.clean_blood()
		if(mask)
			mask.clean_blood()
		isUV = FALSE //Cycle ends
		update_icon()
		updateUsrDialog()

	var/i
	for(i=0,i<4,i++) //Gradually give the guy inside some damaged based on the intensity
		spawn(50)
			if(occupant)
				if(issuperUV)
					occupant.take_organ_damage(0,40)
					user << "Test. You gave him 40 damage"
				else
					occupant.take_organ_damage(0,8)
					user << "Test. You gave him 8 damage"
	return*/

/obj/machinery/suit_storage_unit/proc/cycletimeleft()
	if(cycletime_left >= 1)
		cycletime_left--
	return cycletime_left

/obj/machinery/suit_storage_unit/proc/eject_occupant(mob/user as mob)
	if(islocked)
		return

	if(isnull(occupant))
		return
//	for(var/obj/O in src)
//		O.loc = loc

	if(isnotnull(occupant.client))
		if(user != occupant)
			to_chat(occupant, SPAN_INFO("The machine kicks you out!"))
		if(user.loc != loc)
			to_chat(occupant, SPAN_INFO("You leave the not-so-cozy confines of the SSU."))

		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.loc = loc
	occupant = null
	if(!isopen)
		isopen = TRUE
	update_icon()

/obj/machinery/suit_storage_unit/verb/get_out()
	set category = PANEL_OBJECT
	set name = "Eject Suit Storage Unit"
	set src in oview(1)

	if(usr.stat != CONSCIOUS)
		return
	eject_occupant(usr)
	add_fingerprint(usr)
	updateUsrDialog()
	update_icon()

/obj/machinery/suit_storage_unit/verb/move_inside()
	set category = PANEL_OBJECT
	set name = "Hide in Suit Storage Unit"
	set src in oview(1)

	if(usr.stat != 0)
		return
	if(!isopen)
		to_chat(usr, SPAN_WARNING("The unit's doors are shut."))
		return
	if(!ispowered || isbroken)
		to_chat(usr, SPAN_WARNING("The unit is not operational."))
		return
	if(isnotnull(occupant) || isnotnull(helmet) || isnotnull(suit))
		to_chat(usr, SPAN_WARNING("It's too cluttered inside for you to fit in!"))
		return
	visible_message("[usr] starts squeezing into the suit storage unit!", 3)
	if(do_after(usr, 10))
		usr.stop_pulling()
		usr.client.perspective = EYE_PERSPECTIVE
		usr.client.eye = src
		usr.loc = src
//		usr.metabslow = 1
		occupant = usr
		isopen = FALSE //Close the thing after the guy gets inside
		update_icon()

//		for(var/obj/O in src)
//			del(O)

		add_fingerprint(usr)
		updateUsrDialog()
		return
	else
		occupant = null //Testing this as a backup sanity test

/obj/machinery/suit_storage_unit/attackby(obj/item/I as obj, mob/user as mob)
	if(!ispowered)
		return
	if(istype(I, /obj/item/screwdriver))
		panelopen = !panelopen
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
		to_chat(user, SPAN_INFO("You [(panelopen ? "open up" : "close")] the unit's maintenance panel."))
		updateUsrDialog()
		return
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		if(!ismob(G.affecting))
			return
		if(!isopen)
			to_chat(usr, SPAN_WARNING("The unit's doors are shut."))
			return
		if(!ispowered || isbroken)
			to_chat(usr, SPAN_WARNING("The unit is not operational."))
			return
		if(occupant || helmet || suit) //Unit needs to be absolutely empty
			to_chat(usr, SPAN_WARNING("The unit's storage area is too cluttered."))
			return
		visible_message("[user] starts putting [G.affecting.name] into the Suit Storage Unit.", 3)
		if(do_after(user, 20))
			if(!G || !G.affecting)
				return //derpcheck
			var/mob/M = G.affecting
			if(M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src
			M.loc = src
			occupant = M
			isopen = FALSE //close ittt

			//for(var/obj/O in src)
			//	O.loc = loc
			add_fingerprint(user)
			qdel(G)
			updateUsrDialog()
			update_icon()
			return
		return
	if(istype(I, /obj/item/clothing/suit/space))
		if(!isopen)
			return
		var/obj/item/clothing/suit/space/S = I
		if(suit)
			to_chat(user, SPAN_INFO("The unit already contains a suit."))
			return
		to_chat(user, "You load the [S.name] into the storage compartment.")
		user.drop_item()
		S.loc = src
		suit = S
		update_icon()
		updateUsrDialog()
		return
	if(istype(I, /obj/item/clothing/head/helmet))
		if(!isopen)
			return
		var/obj/item/clothing/head/helmet/H = I
		if(helmet)
			to_chat(user, SPAN_INFO("The unit already contains a helmet."))
			return
		to_chat(user, "You load the [H.name] into the storage compartment.")
		user.drop_item()
		H.loc = src
		helmet = H
		update_icon()
		updateUsrDialog()
		return
	if(istype(I, /obj/item/clothing/mask))
		if(!isopen)
			return
		var/obj/item/clothing/mask/M = I
		if(mask)
			to_chat(user, SPAN_INFO("The unit already contains a mask."))
			return
		to_chat(user, "You load the [M.name] into the storage compartment.")
		user.drop_item()
		M.loc = src
		mask = M
		update_icon()
		updateUsrDialog()
		return
	update_icon()
	updateUsrDialog()

/obj/machinery/suit_storage_unit/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/suit_storage_unit/attack_paw(mob/user as mob)
	to_chat(user, SPAN_INFO("The console controls are far too complicated for your tiny brain!"))

//////////////////////////////REMINDER: Make it lock once you place some fucker inside.

//God this entire file is fucking awful