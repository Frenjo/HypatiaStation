//Suit painter for Bay's special snowflake aliums.

/obj/machinery/suit_cycler
	name = "suit cycler"
	desc = "An industrial machine for repairing, painting and equipping hardsuits."
	anchored = TRUE
	density = TRUE

	icon = 'icons/obj/suitstorage.dmi'
	icon_state = "suitstorage000000100"

	req_access = list(ACCESS_CAPTAIN, ACCESS_BRIDGE)

	var/active = 0			// PLEASE HOLD.
	var/safeties = 1		// The cycler won't start with a living thing inside it unless safeties are off.
	var/irradiating = 0		// If this is > 0, the cycler is decontaminating whatever is inside it.
	var/radiation_level = 2	// 1 is removing germs, 2 is removing blood, 3 is removing phoron.
	var/model_text = ""		// Some flavour text for the topic box.
	var/locked = 1			// If locked, nothing can be taken from or added to the cycler.
	var/panel_open = 0		// Hacking!

	// Wiring bollocks.
	var/wires = 15
	var/electrified = 0
	var/const/WIRE_EXTEND = 1	// Safeties
	var/const/WIRE_SCANID = 2	// Locked status
	var/const/WIRE_SHOCK = 3	// What it says on the tin.

	//Departments that the cycler can paint suits to look like.
	var/list/departments = list("Engineering", "Mining", "Medical", "Security", "Atmos")
	//Species that the suits can be configured to fit.
	var/list/species = list(SPECIES_HUMAN, SPECIES_TAJARAN)

	var/target_department = "Engineering"
	var/target_species = SPECIES_HUMAN

	var/mob/living/carbon/human/occupant = null
	var/obj/item/clothing/suit/space/rig/suit = null
	var/obj/item/clothing/head/helmet/space/helmet = null

/obj/machinery/suit_cycler/engineering
	name = "suit cycler (Engineering)"
	model_text = "Engineering"
	req_access = list(ACCESS_CONSTRUCTION)
	departments = list("Engineering", "Atmos")
	species = list(SPECIES_HUMAN, SPECIES_TAJARAN)

/obj/machinery/suit_cycler/mining
	name = "suit cycler (Mining)"
	model_text = "Mining"
	req_access = list(ACCESS_MINING)
	departments = list("Mining")
	species = list(SPECIES_HUMAN, SPECIES_TAJARAN)
	target_department = "Mining"

/obj/machinery/suit_cycler/security
	name = "suit cycler (Security)"
	model_text = "Security"
	req_access = list(ACCESS_SECURITY)
	departments = list("Security")
	species = list(SPECIES_HUMAN, SPECIES_SOGHUN, SPECIES_TAJARAN)
	target_department = "Security"

/obj/machinery/suit_cycler/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/machinery/suit_cycler/attack_paw(mob/user)
	to_chat(user, SPAN_INFO("The console controls are far too complicated for your tiny brain!"))
	return

/obj/machinery/suit_cycler/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(emagged)
		FEEDBACK_ALREADY_EMAGGED(user)
		return FALSE

	updateUsrDialog()
	// Clears the access reqs, disables the safeties, and opens up all paintjobs.
	to_chat(user, SPAN_WARNING("You run the sequencer across the interface, corrupting the operating protocols."))
	departments = list("Engineering", "Mining", "Medical", "Security", "Atmos", "^%###^%$")
	emagged = TRUE
	safeties = FALSE
	req_access.Cut()
	return TRUE

/obj/machinery/suit_cycler/attackby(obj/item/I, mob/user)
	if(electrified != 0)
		if(src.shock(user, 100))
			return

	//Hacking init.
	if(ismultitool(I) || iswirecutter(I))
		if(panel_open)
			attack_hand(user)
		return
	//Other interface stuff.
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I

		if(!ismob(G.affecting))
			return

		if(locked)
			to_chat(user, SPAN_WARNING("The suit cycler is locked."))
			return

		if(length(contents))
			to_chat(user, SPAN_WARNING("There is no room inside the cycler for [G.affecting.name]."))
			return

		visible_message("[user] starts putting [G.affecting.name] into the suit cycler.", 3)

		if(do_after(user, 20))
			if(!G || !G.affecting)
				return
			var/mob/M = G.affecting
			if(isnotnull(M.client))
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src
			M.loc = src
			occupant = M

			add_fingerprint(user)
			qdel(G)

			updateUsrDialog()
			return

	else if(isscrewdriver(I))
		panel_open = !panel_open
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
		FEEDBACK_TOGGLE_MAINTENANCE_PANEL(user, panel_open)
		updateUsrDialog()
		return

	else if(istype(I, /obj/item/clothing/head/helmet/space))
		if(locked)
			to_chat(user, SPAN_WARNING("The suit cycler is locked."))
			return

		if(helmet)
			to_chat(user, SPAN_WARNING("The cycler already contains a helmet."))
			return

		to_chat(user, SPAN_INFO("You fit \the [I] into the suit cycler."))
		user.drop_item()
		I.loc = src
		helmet = I

		update_icon()
		updateUsrDialog()
		return

	else if(istype(I, /obj/item/clothing/suit/space/rig))
		if(locked)
			to_chat(user, SPAN_WARNING("The suit cycler is locked."))
			return

		if(suit)
			to_chat(user, SPAN_WARNING("The cycler already contains a hardsuit."))
			return

		var/obj/item/clothing/suit/space/rig/S = I

		if(S.helmet)
			to_chat(user, SPAN_WARNING("\The [S] will not fit into the cycler with a helmet attached."))
			return

		if(S.boots)
			to_chat(user, SPAN_WARNING("\The [S] will not fit into the cycler with boots attached."))
			return

		to_chat(user, SPAN_INFO("You fit \the [I] into the suit cycler."))
		user.drop_item()
		I.loc = src
		suit = I

		update_icon()
		updateUsrDialog()
		return

	..()

/obj/machinery/suit_cycler/attack_hand(mob/user)
	add_fingerprint(user)

	if(..() || stat & (BROKEN|NOPOWER))
		return

	if(electrified != 0)
		if(src.shock(user, 100))
			return

	usr.set_machine(src)

	var/dat = "<HEAD><TITLE>Suit Cycler Interface</TITLE></HEAD>"

	if(src.active)
		dat+= "<br><font color='red'><B>The [model_text ? "[model_text] " : ""]suit cycler is currently in use. Please wait...</b></font>"

	else if(locked)
		dat += "<br><font color='red'><B>The [model_text ? "[model_text] " : ""]suit cycler is currently locked. Please contact your system administrator.</b></font>"
		if(src.allowed(usr))
			dat += "<br><a href='byond://?src=\ref[src];toggle_lock=1'>\[unlock unit\]</a>"
	else
		dat += "<h1>Suit cycler</h1>"
		dat += "<B>Welcome to the [model_text ? "[model_text] " : ""]suit cycler control panel. <a href='byond://?src=\ref[src];toggle_lock=1'>\[lock unit\]</a></B><HR>"

		dat += "<h2>Maintenance</h2>"
		dat += "<b>Helmet: </b> [helmet ? "\the [helmet]" : "no helmet stored" ]. <A href='byond://?src=\ref[src];eject_helmet=1'>\[eject\]</a><br/>"
		dat += "<b>Suit: </b> [suit ? "\the [suit]" : "no suit stored" ]. <A href='byond://?src=\ref[src];eject_suit=1'>\[eject\]</a>"

		if(suit && istype(suit))
			dat += "[(suit.damage ? " <A href='byond://?src=\ref[src];repair_suit=1'>\[repair\]</a>" : "")]"

		dat += "<br/><b>UV decontamination systems:</b> <font color = '[emagged ? "red'>SYSTEM ERROR" : "green'>READY"]</font><br>"
		dat += "Output level: [radiation_level]<br>"
		dat += "<A href='byond://?src=\ref[src];select_rad_level=1'>\[select power level\]</a> <A href='byond://?src=\ref[src];begin_decontamination=1'>\[begin decontamination cycle\]</a><br><hr>"

		dat += "<h2>Customisation</h2>"
		dat += "<b>Target product: <A href='byond://?src=\ref[src];select_department=1'>[target_department]</a>, <A href='byond://?src=\ref[src];select_species=1'>[target_species]</a>."
		dat += "<A href='byond://?src=\ref[src];apply_paintjob=1'><br>\[apply customisation routine\]</a><br><hr>"

	if(panel_open)
		var/list/vendwires = list(
			"Violet" = 1,
			"Orange" = 2,
			"Goldenrod" = 3,
		)
		dat += "<h2><B>Access Panel</B></h2>"
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
		dat += "The orange light is [(electrified == 0) ? "off" : "on"].<BR>"
		dat += "The red light is [safeties ? "blinking" : "off"].<BR>"
		dat += "The yellow light is [locked ? "on" : "off"].<BR>"

	user << browse(dat, "window=suit_cycler")
	onclose(user, "suit_cycler")

/obj/machinery/suit_cycler/Topic(href, href_list)
	if(href_list["eject_suit"])
		if(!suit)
			return
		suit.loc = get_turf(src)
		suit = null
	else if(href_list["eject_helmet"])
		if(!helmet)
			return
		helmet.loc = get_turf(src)
		helmet = null
	else if(href_list["select_department"])
		target_department = input("Please select the target department paintjob.", "Suit cycler", null) as null|anything in departments
	else if(href_list["select_species"])
		target_species = input("Please select the target species configuration.", "Suit cycler", null) as null|anything in species
	else if(href_list["select_rad_level"])
		var/choices = list(1, 2, 3)
		if(emagged)
			choices = list(1, 2, 3, 4, 5)
		radiation_level = input("Please select the desired radiation level.", "Suit cycler", null) as null|anything in choices
	else if(href_list["repair_suit"])
		if(!suit)
			return
		active = 1
		spawn(100)
			repair_suit()
			finished_job()

	else if(href_list["apply_paintjob"])
		if(!suit && !helmet)
			return
		active = 1
		spawn(100)
			apply_paintjob()
			finished_job()

	else if(href_list["toggle_safties"])
		safeties = !safeties

	else if(href_list["toggle_lock"])
		if(src.allowed(usr))
			locked = !locked
			to_chat(usr, "You [locked ? "" : "un"]lock \the [src].")
		else
			FEEDBACK_ACCESS_DENIED(usr)

	else if(href_list["begin_decontamination"])
		if(safeties && occupant)
			to_chat(usr, SPAN_WARNING("The cycler has detected an occupant. Please remove the occupant before commencing the decontamination cycle."))
			return

		active = 1
		irradiating = 10
		src.updateUsrDialog()

		sleep(10)

		if(helmet)
			if(radiation_level > 2)
				helmet.decontaminate()
			if(radiation_level > 1)
				helmet.clean_blood()

		if(suit)
			if(radiation_level > 2)
				suit.decontaminate()
			if(radiation_level > 1)
				suit.clean_blood()

	else if((href_list["cutwire"]) && (src.panel_open))
		var/twire = text2num(href_list["cutwire"])
		if(!iswirecutter(usr.get_active_hand()))
			to_chat(usr, "You need wirecutters!")
			return
		if(src.isWireColorCut(twire))
			src.mend(twire)
		else
			src.cut(twire)

	else if((href_list["pulsewire"]) && (src.panel_open))
		var/twire = text2num(href_list["pulsewire"])
		if(!ismultitool(usr.get_active_hand()))
			to_chat(usr, "You need a multitool!")
			return
		if(src.isWireColorCut(twire))
			to_chat(usr, "You can't pulse a cut wire.")
			return
		else
			src.pulse(twire)

	src.updateUsrDialog()

/obj/machinery/suit_cycler/process()
	if(electrified > 0)
		electrified--

	if(!active)
		return

	if(active && stat & (BROKEN|NOPOWER))
		active = 0
		irradiating = 0
		electrified = 0
		return

	if(irradiating == 1)
		finished_job()
		irradiating = 0
		return

	irradiating--

	if(occupant)
		if(prob(radiation_level * 2))
			occupant.emote("scream")
		if(radiation_level > 2)
			occupant.take_organ_damage(0, radiation_level * 2 + rand(1, 3))
		if(radiation_level > 1)
			occupant.take_organ_damage(0, radiation_level + rand(1, 3))
		occupant.radiation += radiation_level * 10

/obj/machinery/suit_cycler/proc/finished_job()
	var/turf/T = get_turf(src)
	T.visible_message("\The [src] pings loudly.")
	icon_state = initial(icon_state)
	active = 0
	src.updateUsrDialog()

/obj/machinery/suit_cycler/proc/repair_suit()
	if(!suit || !suit.damage || !suit.can_breach)
		return

	suit.breaches = list()
	suit.calc_breach_damage()

/obj/machinery/suit_cycler/verb/leave()
	set category = PANEL_OBJECT
	set name = "Eject Cycler"
	set src in oview(1)

	if(usr.stat != CONSCIOUS)
		return

	eject_occupant(usr)

/obj/machinery/suit_cycler/proc/eject_occupant(mob/user)
	if(locked || active)
		to_chat(usr, SPAN_WARNING("The cycler is locked."))
		return

	if(!occupant)
		return

	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE

	occupant.loc = get_turf(occupant)
	occupant = null

	add_fingerprint(usr)
	src.updateUsrDialog()
	src.update_icon()

//HACKING PROCS, MOSTLY COPIED FROM VENDING MACHINES
/obj/machinery/suit_cycler/proc/isWireColorCut(wireColor)
	var/wireFlag = APCWireColorToFlag[wireColor]
	return ((src.wires & wireFlag) == 0)

/obj/machinery/suit_cycler/proc/isWireCut(wireIndex)
	var/wireFlag = APCIndexToFlag[wireIndex]
	return ((src.wires & wireFlag) == 0)

/obj/machinery/suit_cycler/proc/cut(wireColor)
	var/wireFlag = APCWireColorToFlag[wireColor]
	var/wireIndex = APCWireColorToIndex[wireColor]
	src.wires &= ~wireFlag
	switch(wireIndex)

		if(WIRE_EXTEND)
			safeties = 0
		if(WIRE_SHOCK)
			electrified = -1
		if(WIRE_SCANID)
			locked = 0

/obj/machinery/suit_cycler/proc/mend(wireColor)
	var/wireFlag = APCWireColorToFlag[wireColor]
	var/wireIndex = APCWireColorToIndex[wireColor] //not used in this function
	src.wires |= wireFlag
	switch(wireIndex)
		if(WIRE_SHOCK)
			src.electrified = 0

/obj/machinery/suit_cycler/proc/pulse(wireColor)
	var/wireIndex = APCWireColorToIndex[wireColor]
	switch(wireIndex)
		if(WIRE_EXTEND)
			safeties = !locked
		if(WIRE_SHOCK)
			electrified = 30
		if(WIRE_SCANID)
			locked = !locked

/obj/machinery/suit_cycler/proc/shock(mob/user, prb)
	if(stat & (BROKEN|NOPOWER))		// unpowered, no shock
		return 0
	if(!prob(prb))
		return 0
	make_sparks(5, TRUE, src)
	if(electrocute_mob(user, get_area(src), src, 0.7))
		return 1
	else
		return 0

//There HAS to be a less bloated way to do this. TODO: some kind of table/icon name coding? ~Z
/obj/machinery/suit_cycler/proc/apply_paintjob()
	if(!target_species || !target_department)
		return

	switch(target_species)
		if(SPECIES_HUMAN, SPECIES_SKRELL)
			if(helmet)
				helmet.species_restricted = list("exclude", SPECIES_SOGHUN, SPECIES_TAJARAN, SPECIES_DIONA, SPECIES_VOX)
			if(suit)
				suit.species_restricted = list("exclude", SPECIES_SOGHUN, SPECIES_TAJARAN, SPECIES_DIONA, SPECIES_VOX)
		if(SPECIES_SOGHUN)
			if(helmet)
				helmet.species_restricted = list(SPECIES_SOGHUN)
			if(suit)
				suit.species_restricted = list(SPECIES_SOGHUN)
		if(SPECIES_TAJARAN)
			if(helmet)
				helmet.species_restricted = list(SPECIES_TAJARAN)
			if(suit)
				suit.species_restricted = list(SPECIES_TAJARAN)

	switch(target_department)
		if("Engineering")
			if(helmet)
				helmet.name = "engineering hardsuit helmet"
				helmet.icon_state = "rig0-engineering"
				helmet.item_state = "eng_helm"
				helmet.item_color = "engineering"
			if(suit)
				suit.name = "engineering hardsuit"
				suit.icon_state = "rig-engineering"
				suit.item_state = "eng_hardsuit"
		if("Mining")
			if(helmet)
				helmet.name = "mining hardsuit helmet"
				helmet.icon_state = "rig0-mining"
				helmet.item_state = "mining_helm"
				helmet.item_color = "mining"
			if(suit)
				suit.name = "mining hardsuit"
				suit.icon_state = "rig-mining"
				suit.item_state = "mining_hardsuit"
		if("Medical")
			if(helmet)
				helmet.name = "medical hardsuit helmet"
				helmet.icon_state = "rig0-medical"
				helmet.item_state = "medical_helm"
				helmet.item_color = "medical"
			if(suit)
				suit.name = "medical hardsuit"
				suit.icon_state = "rig-medical"
				suit.item_state = "medical_hardsuit"
		if("Security")
			if(helmet)
				helmet.name = "security hardsuit helmet"
				helmet.icon_state = "rig0-sec"
				helmet.item_state = "sec_helm"
				helmet.item_color = "sec"
			if(suit)
				suit.name = "security hardsuit"
				suit.icon_state = "rig-sec"
				suit.item_state = "sec_hardsuit"
		if("Atmos")
			if(helmet)
				helmet.name = "atmospherics hardsuit helmet"
				helmet.icon_state = "rig0-atmos"
				helmet.item_state = "atmos_helm"
				helmet.item_color = "atmos"
			if(suit)
				suit.name = "atmospherics hardsuit"
				suit.icon_state = "rig-atmos"
				suit.item_state = "atmos_hardsuit"
		if("^%###^%$")
			if(helmet)
				helmet.name = "blood-red hardsuit helmet"
				helmet.icon_state = "rig0-syndie"
				helmet.item_state = "syndie_helm"
				helmet.item_color = "syndie"
			if(suit)
				suit.name = "blood-red hardsuit"
				suit.item_state = "syndie_hardsuit"
				suit.icon_state = "rig-syndie"