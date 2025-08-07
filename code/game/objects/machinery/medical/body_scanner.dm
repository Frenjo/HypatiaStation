// Pretty much everything here is stolen from the dna scanner FYI


/obj/machinery/bodyscanner
	var/mob/living/carbon/occupant
	var/locked
	name = "body scanner"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "body_scanner_0"
	density = TRUE
	anchored = TRUE

/*/obj/machinery/bodyscanner/allow_drop()
	return 0*/

/obj/machinery/bodyscanner/relaymove(mob/user)
	if(user.stat)
		return
	src.go_out()
	return

/obj/machinery/bodyscanner/verb/eject()
	set category = PANEL_OBJECT
	set src in oview(1)
	set name = "Eject Body Scanner"

	if(usr.stat != CONSCIOUS)
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/bodyscanner/verb/move_inside()
	set category = PANEL_OBJECT
	set src in oview(1)
	set name = "Enter Body Scanner"

	if(usr.stat != CONSCIOUS)
		return
	if(src.occupant)
		to_chat(usr, SPAN_INFO_B("The scanner is already occupied!"))
		return
	if(usr.abiotic())
		to_chat(usr, SPAN_INFO_B("Subject cannot have abiotic items on."))
		return

	usr.pulling = null
	usr.client.perspective = EYE_PERSPECTIVE
	usr.client.eye = src
	usr.forceMove(src)
	src.occupant = usr
	src.icon_state = "body_scanner_1"
	for(var/obj/O in src)
		//O = null
		qdel(O)
		//Foreach goto(124)
	src.add_fingerprint(usr)
	return

/obj/machinery/bodyscanner/proc/go_out()
	if((!(src.occupant) || src.locked))
		return
	for(var/obj/O in src)
		O.forceMove(loc)
		//Foreach goto(30)
	if(src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	occupant.forceMove(loc)
	src.occupant = null
	src.icon_state = "body_scanner_0"
	return

/obj/machinery/bodyscanner/attack_grab(obj/item/grab/grab, mob/user, mob/grabbed)
	if(isnotnull(occupant))
		to_chat(usr, SPAN_INFO_B("\The [src] is already occupied!"))
		return TRUE
	if(grabbed.abiotic())
		to_chat(usr, SPAN_INFO_B("Subject cannot have abiotic items on."))
		return TRUE

	if(isnotnull(grabbed.client))
		grabbed.client.perspective = EYE_PERSPECTIVE
		grabbed.client.eye = src
	grabbed.forceMove(src)
	occupant = grabbed
	icon_state = "body_scanner_1"
	for(var/obj/O in src)
		O.forceMove(loc)
	add_fingerprint(user)
	qdel(grab)
	return TRUE

/obj/machinery/bodyscanner/ex_act(severity)
	switch(severity)
		if(1.0)
			for_no_type_check(var/atom/movable/mover, src)
				mover.forceMove(loc)
				ex_act(severity)
				//Foreach goto(35)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				for_no_type_check(var/atom/movable/mover, src)
					mover.forceMove(loc)
					ex_act(severity)
					//Foreach goto(108)
				qdel(src)
				return
		if(3.0)
			if(prob(25))
				for_no_type_check(var/atom/movable/mover, src)
					mover.forceMove(loc)
					ex_act(severity)
					//Foreach goto(181)
				qdel(src)
				return
		else
	return

/obj/machinery/bodyscanner/blob_act()
	if(prob(50))
		for_no_type_check(var/atom/movable/mover, src)
			mover.forceMove(loc)
		qdel(src)

/obj/machinery/body_scanconsole/ex_act(severity)
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

/obj/machinery/body_scanconsole/blob_act()
	if(prob(50))
		qdel(src)

/obj/machinery/body_scanconsole/power_change()
	if(stat & BROKEN)
		icon_state = "body_scannerconsole-p"
	else if(powered())
		icon_state = initial(icon_state)
		stat &= ~NOPOWER
	else
		spawn(rand(0, 15))
			src.icon_state = "body_scannerconsole-p"
			stat |= NOPOWER

/obj/machinery/body_scanconsole
	var/obj/machinery/bodyscanner/connected
	var/list/known_implants = list(
		/obj/item/implant/chem, /obj/item/implant/death_alarm,
		/obj/item/implant/mindshield, /obj/item/implant/loyalty,
		/obj/item/implant/tracking
	)
	var/delete
	var/temphtml
	name = "body scanner console"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "body_scannerconsole"
	density = FALSE
	anchored = TRUE

/obj/machinery/body_scanconsole/initialise()
	. = ..()
	connected = locate(/obj/machinery/bodyscanner, get_step(src, WEST))

/*

/obj/machinery/body_scanconsole/process() //not really used right now
	if(stat & (NOPOWER|BROKEN))
		return
	//use_power(250) // power stuff

//	var/mob/M //occupant
//	if (!( src.status )) //remove this
//		return
//	if ((src.connected && src.connected.occupant)) //connected & occupant ok
//		M = src.connected.occupant
//	else
//		if(ismob(M))
//		//do stuff
//		else
///			src.temphtml = "Process terminated due to lack of occupant in scanning chamber."
//			src.status = null
//	src.updateDialog()
//	return

*/

/obj/machinery/body_scanconsole/attack_paw(mob/user)
	return src.attack_hand(user)

/obj/machinery/body_scanconsole/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/machinery/body_scanconsole/attack_hand(mob/user)
	if(..())
		return
	if(!ishuman(connected.occupant))
		to_chat(user, SPAN_WARNING("This device can only scan compatible lifeforms."))
		return
	var/dat
	if(src.delete && src.temphtml) //Window in buffer but its just simple message, so nothing
		src.delete = src.delete
	else if(!src.delete && src.temphtml) //Window in buffer - its a menu, dont add clear message
		dat = "[src.temphtml]<BR><BR><A href='byond://?src=\ref[src];clear=1'>Main Menu</A>"
	else
		if(src.connected) //Is something connected?
			var/mob/living/carbon/human/occupant = src.connected.occupant
			dat = "<font color='blue'><B>Occupant Statistics:</B></FONT><BR>" //Blah obvious
			if(istype(occupant)) //is there REALLY someone in there?
				var/t1
				switch(occupant.stat) // obvious, see what their status is
					if(0)
						t1 = "Conscious"
					if(1)
						t1 = "Unconscious"
					else
						t1 = "*dead*"
				if(!ishuman(occupant))
					dat += "<font color='red'>This device can only scan human occupants.</FONT>"
				else
					dat += "[(occupant.health > 50 ? "<font color='blue'>" : "<font color='red'>")]\tHealth %: [occupant.health] ([t1])</FONT><BR>"

					if(length(occupant.virus2))
						dat += "<font color='red'>Viral pathogen detected in blood stream.</font><BR>"

					dat += "[(occupant.getBruteLoss() < 60 ? "<font color='blue'>" : "<font color='red'>")]\t-Brute Damage %: [occupant.getBruteLoss()]</FONT><BR>"
					dat += "[(occupant.getOxyLoss() < 60 ? "<font color='blue'>" : "<font color='red'>")]\t-Respiratory Damage %: [occupant.getOxyLoss()]</FONT><BR>"
					dat += "[(occupant.getToxLoss() < 60 ? "<font color='blue'>" : "<font color='red'>")]\t-Toxin Content %: [occupant.getToxLoss()]</FONT><BR>"
					dat += "[(occupant.getFireLoss() < 60 ? "<font color='blue'>" : "<font color='red'>")]\t-Burn Severity %: [occupant.getFireLoss()]</FONT><BR><BR>"

					dat += "[(occupant.radiation < 10 ? "<font color='blue'>" : "<font color='red'>")]\tRadiation Level %: [occupant.radiation]</FONT><BR>"
					dat += "[(occupant.getCloneLoss() < 1 ?"<font color='blue'>" : "<font color='red'>")]\tGenetic Tissue Damage %: [occupant.getCloneLoss()]</FONT><BR>"
					dat += "[(occupant.getBrainLoss() < 1 ?"<font color='blue'>" : "<font color='red'>")]\tApprox. Brain Damage %: [occupant.getBrainLoss()]</FONT><BR>"
					dat += "Paralysis Summary %: [occupant.paralysis] ([round(occupant.paralysis / 4)] seconds left!)<BR>"
					dat += "Body Temperature: [occupant.bodytemperature-T0C]&deg;C ([occupant.bodytemperature*1.8-459.67]&deg;F)<BR><HR>"

					if(occupant.has_brain_worms())
						dat += "Large growth detected in frontal lobe, possibly cancerous. Surgical removal is recommended.<BR/>"

					if(occupant.vessel)
						var/blood_volume = round(occupant.vessel.get_reagent_amount("blood"))
						var/blood_percent =  blood_volume / 560
						blood_percent *= 100
						dat += "[(blood_volume > 448 ?"<font color='blue'>" : "<font color='red'>")]\tBlood Level %: [blood_percent] ([blood_volume] units)</FONT><BR>"
					if(occupant.reagents)
						dat += "Inaprovaline units: [occupant.reagents.get_reagent_amount("inaprovaline")] units<BR>"
						dat += "Soporific (Sleep Toxin): [occupant.reagents.get_reagent_amount("stoxin")] units<BR>"
						dat += "[(occupant.reagents.get_reagent_amount("dermaline") < 30 ? "<font color='black'>" : "<font color='red'>")]\tDermaline: [occupant.reagents.get_reagent_amount("dermaline")] units</FONT><BR>"
						dat += "[(occupant.reagents.get_reagent_amount("bicaridine") < 30 ? "<font color='black'>" : "<font color='red'>")]\tBicaridine: [occupant.reagents.get_reagent_amount("bicaridine")] units<BR>"
						dat += "[(occupant.reagents.get_reagent_amount("dexalin") < 30 ? "<font color='black'>" : "<font color='red'>")]\tDexalin: [occupant.reagents.get_reagent_amount("dexalin")] units<BR>"

					for(var/datum/disease/D in occupant.viruses)
						if(!D.hidden[DISEASE_INFO_SCANNER])
							dat += "<font color='red'><B>Warning: [D.form] Detected</B>\nName: [D.name].\nType: [D.spread].\nStage: [D.stage]/[D.max_stages].\nPossible Cure: [D.cure]</FONT><BR>"

					dat += "<HR><table border='1'>"
					dat += "<tr>"
					dat += "<th>Organ</th>"
					dat += "<th>Burn Damage</th>"
					dat += "<th>Brute Damage</th>"
					dat += "<th>Other Wounds</th>"
					dat += "</tr>"

					for(var/datum/organ/external/e in occupant.organs)
						dat += "<tr>"
						var/AN = ""
						var/open = ""
						var/infected = ""
						var/imp = ""
						var/bled = ""
						var/robot = ""
						var/splint = ""
						var/internal_bleeding = ""
						var/lung_ruptured = ""
						for(var/datum/wound/W in e.wounds)
							if(W.internal)
								internal_bleeding = "<br>Internal bleeding"
								break
						if(istype(e, /datum/organ/external/chest) && occupant.is_lung_ruptured())
							lung_ruptured = "Lung ruptured:"
						if(e.status & ORGAN_SPLINTED)
							splint = "Splinted:"
						if(e.status & ORGAN_BLEEDING)
							bled = "Bleeding:"
						if(e.status & ORGAN_BROKEN)
							AN = "[e.broken_description]:"
						if(e.status & ORGAN_ROBOT)
							robot = "Prosthetic:"
						if(e.open)
							open = "Open:"
						switch(e.germ_level)
							if(INFECTION_LEVEL_ONE + 50 to INFECTION_LEVEL_TWO)
								infected = "Mild Infection:"
							if(INFECTION_LEVEL_TWO to INFECTION_LEVEL_THREE)
								infected = "Acute Infection:"
							if(INFECTION_LEVEL_THREE to INFINITY)
								infected = "Septic:"

						var/unknown_body = 0
						for(var/I in e.implants)
							if(is_type_in_list(I, known_implants))
								imp += "[I] implanted:"
							else
								unknown_body++
						if(unknown_body)
							imp += "Unknown body present:"
						if(!AN && !open && !infected && !imp)
							AN = "None:"
						if(!(e.status & ORGAN_DESTROYED))
							dat += "<td>[e.display_name]</td><td>[e.burn_dam]</td><td>[e.brute_dam]</td><td>[robot][bled][AN][splint][open][infected][imp][internal_bleeding][lung_ruptured]</td>"
						else
							dat += "<td>[e.display_name]</td><td>-</td><td>-</td><td>Not Found</td>"
						dat += "</tr>"
					for(var/organ_name in occupant.internal_organs)
						var/datum/organ/internal/i = occupant.internal_organs[organ_name]
						var/mech = ""
						if(i.robotic == 1)
							mech = "Assisted:"
						if(i.robotic == 2)
							mech = "Mechanical:"

						var/infection = "None"
						switch(i.germ_level)
							if(1 to INFECTION_LEVEL_TWO)
								infection = "Mild Infection:"
							if(INFECTION_LEVEL_TWO to INFINITY)
								infection = "Acute Infection:"

						dat += "<tr>"
						dat += "<td>[i.name]</td><td>N/A</td><td>[i.damage]</td><td>[infection]:[mech]</td><td></td>"
						dat += "</tr>"
					dat += "</table>"
					if(occupant.sdisabilities & BLIND)
						dat += "<font color='red'>Cataracts detected.</font><BR>"
					if(occupant.sdisabilities & NEARSIGHTED)
						dat += "<font color='red'>Retinal misalignment detected.</font><BR>"
			else
				dat += "\The [src] is empty."
		else
			dat = "<font color='red'>Error: No Body Scanner connected.</font>"
	dat += "<BR><BR><A href='byond://?src=\ref[user];mach_close=scanconsole'>Close</A>"
	SHOW_BROWSER(user, dat, "window=scanconsole;size=430x600")
	return
