/obj/machinery/computer/aifixer
	name = "\improper AI system integrity restorer"
	icon_state = "ai-fixer"
	circuit = /obj/item/circuitboard/aifixer
	req_access = list(ACCESS_CAPTAIN, ACCESS_ROBOTICS, ACCESS_BRIDGE)

	var/mob/living/silicon/ai/occupant = null
	var/active = 0

	light_color = "#a97faa"

/obj/machinery/computer/aifixer/New()
	. = ..()
	overlays.Add(image('icons/obj/machines/computer.dmi', "ai-fixer-empty"))

/obj/machinery/computer/aifixer/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/aicard))
		var/obj/item/aicard/card = I
		if(stat & (NOPOWER | BROKEN))
			to_chat(user, SPAN_WARNING("This terminal isn't functioning right now, get it working!"))
			return TRUE
		card.transfer_ai("AIFIXER", "AICARD", src, user)
		return TRUE
	return ..()

/obj/machinery/computer/aifixer/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/computer/aifixer/attack_paw(mob/user)
	return attack_hand(user)

/obj/machinery/computer/aifixer/attack_hand(mob/user)
	if(..())
		return

	user.set_machine(src)
	var/dat = "<h3>AI System Integrity Restorer</h3><br><br>"

	if(src.occupant)
		var/laws
		dat += "Stored AI: [src.occupant.name]<br>System integrity: [(src.occupant.health+100)/2]%<br>"

		if(src.occupant.laws.zeroth)
			laws += "0: [src.occupant.laws.zeroth]<BR>"

		var/number = 1
		for(var/index = 1, index <= length(occupant.laws.inherent), index++)
			var/law = src.occupant.laws.inherent[index]
			if(length(law) > 0)
				laws += "[number]: [law]<BR>"
				number++

		for(var/index = 1, index <= length(occupant.laws.supplied), index++)
			var/law = src.occupant.laws.supplied[index]
			if(length(law) > 0)
				laws += "[number]: [law]<BR>"
				number++

		dat += "Laws:<br>[laws]<br>"

		if(src.occupant.stat == DEAD)
			dat += "<b>AI nonfunctional</b>"
		else
			dat += "<b>AI functional</b>"
		if(!src.active)
			dat += {"<br><br><A href='byond://?src=\ref[src];fix=1'>Begin Reconstruction</A>"}
		else
			dat += "<br><br>Reconstruction in process, please wait.<br>"
	dat += {" <A href='byond://?src=\ref[user];mach_close=computer'>Close</A>"}

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/computer/aifixer/process()
	if(..())
		src.updateDialog()
		return

/obj/machinery/computer/aifixer/Topic(href, href_list)
	if(..())
		return
	if(href_list["fix"])
		src.active = 1
		src.overlays += image('icons/obj/machines/computer.dmi', "ai-fixer-on")
		while(src.occupant.health < 100)
			src.occupant.adjustOxyLoss(-1)
			src.occupant.adjustFireLoss(-1)
			src.occupant.adjustToxLoss(-1)
			src.occupant.adjustBruteLoss(-1)
			src.occupant.updatehealth()
			if(src.occupant.health >= 0 && src.occupant.stat == DEAD)
				src.occupant.stat = 0
				src.occupant.lying = 0
				GLOBL.dead_mob_list.Remove(src.occupant)
				GLOBL.living_mob_list.Add(src.occupant)
				src.overlays -= image('icons/obj/machines/computer.dmi', "ai-fixer-404")
				src.overlays += image('icons/obj/machines/computer.dmi', "ai-fixer-full")
			src.updateUsrDialog()
			sleep(10)
		src.active = 0
		src.overlays -= image('icons/obj/machines/computer.dmi', "ai-fixer-on")

		src.add_fingerprint(usr)
	src.updateUsrDialog()
	return


/obj/machinery/computer/aifixer/update_icon()
	..()
	// Broken / Unpowered
	if((stat & BROKEN) || (stat & NOPOWER))
		overlays.Cut()

	// Working / Powered
	else
		if(occupant)
			switch(occupant.stat)
				if(0)
					overlays += image('icons/obj/machines/computer.dmi', "ai-fixer-full")
				if(2)
					overlays += image('icons/obj/machines/computer.dmi', "ai-fixer-404")
		else
			overlays += image('icons/obj/machines/computer.dmi', "ai-fixer-empty")