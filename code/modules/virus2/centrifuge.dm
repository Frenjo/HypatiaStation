/obj/machinery/computer/disease_centrifuge
	name = "isolation centrifuge"
	desc = "Used to separate things with different weight. Spin 'em round, round, right round."
	icon = 'icons/obj/machines/virology.dmi'
	icon_state = "centrifuge"

	var/curing
	var/isolating

	var/obj/item/reagent_holder/glass/beaker/vial/sample = null
	var/datum/disease2/disease/virus2 = null

/obj/machinery/computer/disease_centrifuge/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/reagent_holder/glass/beaker/vial))
		if(isnull(sample))
			sample = I
			user.drop_item()
			I.forceMove(src)
		return TRUE
	return ..()

/obj/machinery/computer/disease_centrifuge/update_icon()
	..()
	if(! (stat & (BROKEN|NOPOWER)) && (isolating || curing))
		icon_state = "centrifuge_moving"

/obj/machinery/computer/disease_centrifuge/attack_hand(mob/user)
	if(..())
		return
	user.set_machine(src)
	var/dat= ""
	if(curing)
		dat = "Antibody isolation in progress"
	else if(isolating)
		dat = "Pathogen isolation in progress"
	else
		dat += "<BR>Blood sample:"
		dat += "<br><table cellpadding='10'><tr><td>"
		if(sample)
			var/datum/reagent/blood/B = locate(/datum/reagent/blood) in sample.reagents.reagent_list
			if(B)
				dat += "Sample inserted."
				if (B.data["antibodies"])
					dat += "</td></tr><tr><td>"
					dat += "Antibodies: [antigens2string(B.data["antibodies"])]"
					dat += "</td><td><A href='byond://?src=\ref[src];action=antibody'>Isolate</a>"

				var/list/virus = B.data["virus2"]
				for (var/ID in virus)
					var/datum/disease2/disease/V = virus[ID]
					dat += " </td></tr><tr><td> pathogen [V.name()]"
					dat += "</td><td><A href='byond://?src=\ref[src];action=isolate;isolate=[V.uniqueID]'>Isolate</a>"
			else
				dat += "Please check container contents."
			dat += "</td></tr><tr><td><A href='byond://?src=\ref[src];action=sample'>Eject container</a>"
		else
			dat = "Please insert a container."
		dat += "</td></tr></table><br>"

		dat += "<hr>"

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/computer/disease_centrifuge/process()
	..()

	if(stat & (NOPOWER|BROKEN))
		return
	//use_power(500)

	if(curing)
		curing -= 1
		if(curing == 0)
			if(sample)
				cure()
			update_icon()
	if(isolating)
		isolating -= 1
		if(isolating == 0)
			if(sample)
				isolate()
			update_icon()

	src.updateUsrDialog()
	return

/obj/machinery/computer/disease_centrifuge/Topic(href, href_list)
	if(..())
		return

	if(usr) usr.set_machine(src)

	switch(href_list["action"])
		if("antibody")
			var/delay = 20
			var/datum/reagent/blood/B = locate(/datum/reagent/blood) in sample.reagents.reagent_list
			if (!B)
				state("\The [src.name] buzzes, \"No antibody carrier detected.\"", "blue")

			else if(sample.reagents.has_reagent("toxins"))
				state("\The [src.name] beeps, \"Pathogen purging speed above nominal.\"", "blue")
				delay = delay/2

			else
				curing = delay
				playsound(src, 'sound/machines/juicer.ogg', 50, 1)
				update_icon()

		if("isolate")
			var/datum/reagent/blood/B = locate(/datum/reagent/blood) in sample.reagents.reagent_list
			if (B)
				var/list/virus = virus_copylist(B.data["virus2"])
				var/choice = href_list["isolate"]
				if (choice in virus)
					virus2 = virus[choice]
					isolating = 40
					update_icon()
				else
					state("\The [src.name] buzzes, \"No such pathogen detected.\"", "blue")

		if("sample")
			if(sample)
				sample.forceMove(loc)
				sample = null

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	attack_hand(usr)
	return


/obj/machinery/computer/disease_centrifuge/proc/cure()
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in sample.reagents.reagent_list
	if (!B)
		return

	var/list/data = list("antibodies" = B.data["antibodies"])
	var/amt= sample.reagents.get_reagent_amount("blood")
	sample.reagents.remove_reagent("blood",amt)
	sample.reagents.add_reagent("antibodies",amt,data)

	state("\The [src.name] pings", "blue")

/obj/machinery/computer/disease_centrifuge/proc/isolate()
	var/obj/item/virusdish/dish = new/obj/item/virusdish(src.loc)
	dish.virus2 = virus2

	state("\The [src.name] pings", "blue")
