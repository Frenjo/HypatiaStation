/////////////////////////////////////////
// SLEEPER CONSOLE
/////////////////////////////////////////

/obj/machinery/sleep_console
	name = "Sleeper Console"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeperconsole"
	var/obj/machinery/sleeper/connected = null
	anchored = TRUE //About time someone fixed this.
	density = FALSE
	var/orient = "LEFT" // "RIGHT" changes the dir suffix to "-r"

/obj/machinery/sleep_console/initialize()
	. = ..()
	if(orient == "RIGHT")
		icon_state = "sleeperconsole-r"
		src.connected = locate(/obj/machinery/sleeper, get_step(src, EAST))
	else
		src.connected = locate(/obj/machinery/sleeper, get_step(src, WEST))

/obj/machinery/sleep_console/process()
	if(stat & (NOPOWER|BROKEN))
		return
	src.updateUsrDialog()
	return

/obj/machinery/sleep_console/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		else
	return

/obj/machinery/sleep_console/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/sleep_console/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/sleep_console/attack_hand(mob/user as mob)
	if(..())
		return
	if(src.connected)
		var/mob/living/occupant = src.connected.occupant
		var/dat = "<font color='blue'><B>Occupant Statistics:</B></FONT><BR>"
		if(occupant)
			var/t1
			switch(occupant.stat)
				if(0)
					t1 = "Conscious"
				if(1)
					t1 = "<font color='blue'>Unconscious</font>"
				if(2)
					t1 = "<font color='red'>*dead*</font>"
				else
			dat += "[(occupant.health > 50 ? "<font color='blue'>" : "<font color='red'>")]\tHealth %: [occupant.health] ([t1])</FONT><BR>"
			if(iscarbon(occupant))
				var/mob/living/carbon/C = occupant
				dat += "[(C.pulse == PULSE_NONE || C.pulse == PULSE_THREADY ? "<font color='red'>" : "<font color='blue'>")]\t-Pulse, bpm: [C.get_pulse(GETPULSE_TOOL)]</FONT><BR>"
			dat += "[(occupant.getBruteLoss() < 60 ? "<font color='blue'>" : "<font color='red'>")]\t-Brute Damage %: [occupant.getBruteLoss()]</FONT><BR>"
			dat += "[(occupant.getOxyLoss() < 60 ? "<font color='blue'>" : "<font color='red'>")]\t-Respiratory Damage %: [occupant.getOxyLoss()]</FONT><BR>"
			dat += "[(occupant.getToxLoss() < 60 ? "<font color='blue'>" : "<font color='red'>")]\t-Toxin Content %: [occupant.getToxLoss()]</FONT><BR>"
			dat += "[(occupant.getFireLoss() < 60 ? "<font color='blue'>" : "<font color='red'>")]\t-Burn Severity %: [occupant.getFireLoss()]</FONT><BR>"
			dat += "<HR>Paralysis Summary %: [occupant.paralysis] ([round(occupant.paralysis / 4)] seconds left!)<BR>"
			if(occupant.reagents)
				for(var/chemical in connected.available_chemicals)
					dat += "[connected.available_chemicals[chemical]]: [occupant.reagents.get_reagent_amount(chemical)] units<br>"
			dat += "<A href='?src=\ref[src];refresh=1'>Refresh Meter Readings</A><BR>"
			if(src.connected.beaker)
				dat += "<HR><A href='?src=\ref[src];removebeaker=1'>Remove Beaker</A><BR>"
				var/beaker_space = src.connected.beaker.reagents.maximum_volume - src.connected.beaker.reagents.total_volume
				if(src.connected.filtering)
					dat += "<A href='?src=\ref[src];togglefilter=1'>Stop Dialysis</A><BR>"
					dat += "Output Beaker has [beaker_space] units of free space remaining<BR><HR>"
				else
					dat += "<HR><A href='?src=\ref[src];togglefilter=1'>Start Dialysis</A><BR>"
					dat += "Output Beaker has [beaker_space] units of free space remaining<BR><HR>"
			else
				dat += "<HR>No Dialysis Output Beaker is present.<BR><HR>"

			for(var/chemical in connected.available_chemicals)
				dat += "Inject [connected.available_chemicals[chemical]]: "
				for(var/amount in connected.amounts)
					dat += "<a href ='?src=\ref[src];chemical=[chemical];amount=[amount]'>[amount] units</a><br> "


			dat += "<HR><A href='?src=\ref[src];ejectify=1'>Eject Patient</A>"
		else
			dat += "The sleeper is empty."
		dat += "<BR><BR><A href='?src=\ref[user];mach_close=sleeper'>Close</A>"
		user << browse(dat, "window=sleeper;size=400x500")
		onclose(user, "sleeper")
	return

/obj/machinery/sleep_console/Topic(href, href_list)
	if(..())
		return
	if((usr.contents.Find(src) || (get_dist(src, usr) <= 1 && isturf(src.loc))) || isAI(usr))
		usr.set_machine(src)
		if(href_list["chemical"])
			if(src.connected)
				if(src.connected.occupant)
					if(src.connected.occupant.stat == DEAD)
						to_chat(usr, SPAN_DANGER("This person has no life for to preserve anymore. Take them to a department capable of reanimating them."))
					else if(src.connected.occupant.health > 0 || href_list["chemical"] == "inaprovaline")
						src.connected.inject_chemical(usr, href_list["chemical"], text2num(href_list["amount"]))
					else
						to_chat(usr, SPAN_DANGER("This person is not in good enough condition for sleepers to be effective! Use another means of treatment, such as cryogenics!"))
					src.updateUsrDialog()
		if(href_list["refresh"])
			src.updateUsrDialog()
		if(href_list["removebeaker"])
			src.connected.remove_beaker()
			src.updateUsrDialog()
		if(href_list["togglefilter"])
			src.connected.toggle_filter()
			src.updateUsrDialog()
		if(href_list["ejectify"])
			src.connected.eject()
			src.updateUsrDialog()
		src.add_fingerprint(usr)
	return


/obj/machinery/sleep_console/power_change()
	return
	// no change - sleeper works without power (you just can't inject more)

/////////////////////////////////////////
// THE SLEEPER ITSELF
/////////////////////////////////////////

/obj/machinery/sleeper
	name = "Sleeper"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_0"
	density = TRUE
	anchored = TRUE
	var/orient = "LEFT" // "RIGHT" changes the dir suffix to "-r"
	var/mob/living/carbon/human/occupant = null
	var/available_chemicals = list(
		"inaprovaline" = "Inaprovaline",
		"stoxin" = "Soporific",
		"paracetamol" = "Paracetamol",
		"anti_toxin" = "Dylovene",
		"dexalin" = "Dexalin"
	)
	var/amounts = list(5, 10)
	var/obj/item/reagent_containers/glass/beaker = null
	var/filtering = 0

/obj/machinery/sleeper/New()
	..()
	beaker = new /obj/item/reagent_containers/glass/beaker/large(src)

/obj/machinery/sleeper/initialize()
	. = ..()
	if(orient == "RIGHT")
		icon_state = "sleeper_0-r"

/obj/machinery/sleeper/allow_drop()
		return 0

/obj/machinery/sleeper/process()
	if(filtering > 0)
		if(beaker)
			if(beaker.reagents.total_volume < beaker.reagents.maximum_volume)
				src.occupant.vessel.trans_to(beaker, 1)
				for(var/datum/reagent/x in src.occupant.reagents.reagent_list)
					src.occupant.reagents.trans_to(beaker, 3)
					src.occupant.vessel.trans_to(beaker, 1)
	src.updateUsrDialog()
	return

/obj/machinery/sleeper/blob_act()
	if(prob(75))
		for(var/atom/movable/A as mob|obj in src)
			A.loc = src.loc
			A.blob_act()
		qdel(src)
	return

/obj/machinery/sleeper/attackby(obj/item/G as obj, mob/user as mob)
	if(istype(G, /obj/item/reagent_containers/glass))
		if(!beaker)
			beaker = G
			user.drop_item()
			G.loc = src
			user.visible_message("[user] adds \a [G] to \the [src]!", "You add \a [G] to \the [src]!")
			src.updateUsrDialog()
			return
		else
			to_chat(user, SPAN_WARNING("The sleeper has a beaker already."))
			return

	else if(istype(G, /obj/item/grab))
		var/obj/item/grab/grab = G
		if(!ismob(grab.affecting))
			return

		if(src.occupant)
			to_chat(user, SPAN_INFO_B("The sleeper is already occupied!"))
			return

		for(var/mob/living/carbon/slime/M in range(1, grab.affecting))
			if(M.Victim == grab.affecting)
				to_chat(usr, "[grab.affecting.name] will not fit into the sleeper because they have a slime latched onto their head.")
				return

		visible_message("[user] starts putting [grab.affecting.name] into the sleeper.", 3)
		if(do_after(user, 20))
			if(src.occupant)
				to_chat(user, SPAN_INFO_B("The sleeper is already occupied!"))
				return
			if(!G || !grab.affecting)
				return
			var/mob/M = grab.affecting
			if(M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src
			M.loc = src
			src.occupant = M
			src.icon_state = "sleeper_1"
			if(orient == "RIGHT")
				icon_state = "sleeper_1-r"

			to_chat(M, SPAN_INFO_B("You feel cool air surround you. You go numb as your senses turn inward."))

			src.add_fingerprint(user)
			qdel(G)
		return
	return

/obj/machinery/sleeper/ex_act(severity)
	if(filtering)
		toggle_filter()
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.loc
				ex_act(severity)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
				qdel(src)
				return
		if(3.0)
			if(prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
				qdel(src)
				return
	return

/obj/machinery/sleeper/emp_act(severity)
	if(filtering)
		toggle_filter()
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	if(occupant)
		go_out()
	..(severity)

/obj/machinery/sleeper/alter_health(mob/living/M as mob)
	if(M.health > 0)
		if(M.getOxyLoss() >= 10)
			var/amount = max(0.15, 1)
			M.adjustOxyLoss(-amount)
		else
			M.adjustOxyLoss(-12)
		M.updatehealth()
	M.AdjustParalysis(-4)
	M.AdjustWeakened(-4)
	M.AdjustStunned(-4)
	M.Paralyse(1)
	M.Weaken(1)
	M.Stun(1)
	if(M.reagents.get_reagent_amount("inaprovaline") < 5)
		M.reagents.add_reagent("inaprovaline", 5)
	return

/obj/machinery/sleeper/proc/toggle_filter()
	if(filtering)
		filtering = 0
	else
		filtering = 1

/obj/machinery/sleeper/proc/go_out()
	if(filtering)
		toggle_filter()
	if(!src.occupant)
		return
	if(src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.loc = src.loc
	src.occupant = null
	if(orient == "RIGHT")
		icon_state = "sleeper_0-r"
	return

/obj/machinery/sleeper/proc/inject_chemical(mob/living/user as mob, chemical, amount)
	if(src.occupant && src.occupant.reagents)
		if(src.occupant.reagents.get_reagent_amount(chemical) + amount <= 20)
			src.occupant.reagents.add_reagent(chemical, amount)
			to_chat(user, "Occupant now has [src.occupant.reagents.get_reagent_amount(chemical)] units of [available_chemicals[chemical]] in his/her bloodstream.")
			return
	to_chat(user, "There's no occupant in the sleeper or the subject has too many chemicals!")
	return

/obj/machinery/sleeper/proc/check(mob/living/user as mob)
	if(src.occupant)
		to_chat(user, SPAN_INFO_B("Occupant ([src.occupant]) Statistics:"))
		var/t1
		switch(src.occupant.stat)
			if(0.0)
				t1 = "Conscious"
			if(1.0)
				t1 = "Unconscious"
			if(2.0)
				t1 = "*dead*"
			else // Redundant else statement with no content? Won't touch it in case I break something. -Frenjo

		to_chat(user, "[(src.occupant.health > 50 ? "<font color='blue'>" : "<font color='red'>")]\t Health %: [src.occupant.health] ([t1])")
		to_chat(user, "[(src.occupant.bodytemperature > 50 ? "<font color='blue'>" : "<font color='red'>")]\t -Core Temperature: [src.occupant.bodytemperature-T0C]&deg;C ([src.occupant.bodytemperature*1.8-459.67]&deg;F)</FONT><BR>")
		to_chat(user, "[(src.occupant.getBruteLoss() < 60 ? "<font color='blue'>" : "<font color='red'>")]\t -Brute Damage %: [src.occupant.getBruteLoss()]")
		to_chat(user, "[(src.occupant.getOxyLoss() < 60 ? "<font color='blue'>" : "<font color='red'>")]\t -Respiratory Damage %: [src.occupant.getOxyLoss()]")
		to_chat(user, "[(src.occupant.getToxLoss() < 60 ? "<font color='blue'>" : "<font color='red'>")]\t -Toxin Content %: [src.occupant.getToxLoss()]")
		to_chat(user, "[(src.occupant.getFireLoss() < 60 ? "<font color='blue'>" : "<font color='red'>")]\t -Burn Severity %: [src.occupant.getFireLoss()]")
		to_chat(user, SPAN_INFO("Expected time till occupant can safely awake: (note: If health is below 20% these times are inaccurate.)"))
		to_chat(user, SPAN_INFO("\t [src.occupant.paralysis / 5] second\s (if around 1 or 2 the sleeper is keeping them asleep.)"))
		if(src.beaker)
			to_chat(user, SPAN_INFO("\t Dialysis Output Beaker has [src.beaker.reagents.maximum_volume - src.beaker.reagents.total_volume] of free space remaining."))
		else
			to_chat(user, SPAN_INFO("No Dialysis Output Beaker loaded."))
	else
		to_chat(user, SPAN_INFO("There is no one inside!"))
	return

/obj/machinery/sleeper/verb/eject()
	set name = "Eject Sleeper"
	set category = "Object"
	set src in oview(1)

	if(usr.stat != CONSCIOUS)
		return
	if(orient == "RIGHT")
		icon_state = "sleeper_0-r"
	src.icon_state = "sleeper_0"
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/sleeper/verb/remove_beaker()
	set name = "Remove Beaker"
	set category = "Object"
	set src in oview(1)

	if(usr.stat != CONSCIOUS)
		return
	if(beaker)
		filtering = 0
		beaker.loc = usr.loc
		beaker = null
	add_fingerprint(usr)
	return

/obj/machinery/sleeper/verb/move_inside()
	set name = "Enter Sleeper"
	set category = "Object"
	set src in oview(1)

	if(usr.stat != CONSCIOUS || !(ishuman(usr) || ismonkey(usr)))
		return

	if(src.occupant)
		to_chat(usr, SPAN_INFO_B("The sleeper is already occupied!"))
		return

	for(var/mob/living/carbon/slime/M in range(1, usr))
		if(M.Victim == usr)
			to_chat(usr, "You're too busy getting your life sucked out of you.")
			return

	visible_message("[usr] starts climbing into the sleeper.", 3)
	if(do_after(usr, 20))
		if(src.occupant)
			to_chat(usr, SPAN_INFO_B("The sleeper is already occupied!"))
			return
		usr.stop_pulling()
		usr.client.perspective = EYE_PERSPECTIVE
		usr.client.eye = src
		usr.loc = src
		src.occupant = usr
		src.icon_state = "sleeper_1"
		if(orient == "RIGHT")
			icon_state = "sleeper_1-r"

		to_chat(usr, SPAN_INFO_B("You feel cool air surround you. You go numb as your senses turn inward."))

		for(var/obj/O in src)
			qdel(O)
		src.add_fingerprint(usr)
		return
	return