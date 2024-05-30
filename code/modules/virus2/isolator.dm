/obj/machinery/disease_isolator
	name = "pathogenic isolator"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/machines/virology.dmi'
	icon_state = "isolator"

	var/datum/disease2/disease/virus2 = null
	var/isolating = 0
	var/beaker = null

/obj/machinery/disease_isolator/attack_by(obj/item/I, mob/user)
	if(!istype(I, /obj/item/reagent_containers/syringe))
		return ..()
	if(isnotnull(beaker))
		to_chat(user, SPAN_WARNING("A syringe is already loaded into the machine."))
		return TRUE
	beaker = I
	user.drop_item()
	I.loc = src
	user.visible_message(
		SPAN_INFO("[user] adds the syringe to the machine."),
		SPAN_INFO("You add the syringe to the machine.")
	)
	icon_state = "isolator_in"
	updateUsrDialog()
	return TRUE

/obj/machinery/disease_isolator/Topic(href, href_list)
	if(..()) return

	usr.machine = src
	if(!beaker) return
	var/datum/reagents/R = beaker:reagents

	if (href_list["isolate"])
		var/datum/reagent/blood/Blood
		for(var/datum/reagent/blood/B in R.reagent_list)
			if(B)
				Blood = B
				break
		var/list/virus = virus_copylist(Blood.data["virus2"])
		var/choice = text2num(href_list["isolate"]);
		for (var/datum/disease2/disease/V in virus)
			if (V.uniqueID == choice)
				virus2 = virus
				isolating = 40
				icon_state = "isolator_processing"
		src.updateUsrDialog()
		return

	else if (href_list["main"])
		attack_hand(usr)
		return
	else if (href_list["eject"])
		beaker:loc = src.loc
		beaker = null
		icon_state = "isolator"
		src.updateUsrDialog()
		return

/obj/machinery/disease_isolator/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		return
	user.machine = src
	var/dat = ""
	if(!beaker)
		dat = "Please insert sample into the isolator.<BR>"
		dat += "<A href='byond:://?src=\ref[src];close=1'>Close</A>"
	else if(isolating)
		dat = "Isolating"
	else
		var/datum/reagents/R = beaker:reagents
		dat += "<A href='byond:://?src=\ref[src];eject=1'>Eject</A><BR><BR>"
		if(!R.total_volume)
			dat += "[beaker] is empty."
		else
			dat += "Contained reagents:<BR>"
			for(var/datum/reagent/blood/G in R.reagent_list)
				if(G.data["virus2"])
					var/list/virus = G.data["virus2"]
					for (var/datum/disease2/disease/V in virus)
						dat += " <br>  [G.name]: <A href='byond:://?src=\ref[src];isolate=[V.uniqueID]'>Isolate pathogen #[V.uniqueID]</a>"
				else
					dat += "    <b>No pathogen</b>"
	user << browse("<TITLE>Pathogenic Isolator</TITLE>Isolator menu:<BR><BR>[dat]", "window=isolator;size=575x400")
	onclose(user, "isolator")
	return

/obj/machinery/disease_isolator/process()
	if(isolating > 0)
		isolating -= 1
		if(isolating == 0)
			var/obj/item/virusdish/d = new /obj/item/virusdish(src.loc)
			d.virus2 = virus2.getcopy()
			virus2 = null
			icon_state = "isolator_in"
