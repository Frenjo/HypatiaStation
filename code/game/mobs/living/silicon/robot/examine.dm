/mob/living/silicon/robot/examine()
	set src in oview()

	if(isnull(usr) || isnull(src))
		return
	if((usr.sdisabilities & BLIND || usr.blinded || usr.stat) && !isghost(usr))
		to_chat(usr, SPAN_NOTICE("Something is there but you can't see it."))
		return

	var/msg = "<span class='info'>*---------*\nThis is \icon[src] \a <EM>[src]</EM>[custom_name ? ", [model.display_name] [braintype]" : ""]!\n"
	msg += "<span class='warning'>"
	if(getBruteLoss())
		if(getBruteLoss() < 75)
			msg += "It looks slightly dented.\n"
		else
			msg += "<B>It looks severely dented!</B>\n"
	if(getFireLoss())
		if(getFireLoss() < 75)
			msg += "It looks slightly charred.\n"
		else
			msg += "<B>It looks severely burnt and heat-warped!</B>\n"
	msg += "</span>"

	if(opened)
		msg += "[SPAN_WARNING("Its cover is open and the power cell is [cell ? "installed" : "missing"].")]\n"
	else
		msg += "Its cover is closed.\n"

	if(!has_power)
		msg += "[SPAN_WARNING("It appears to be running on backup power.")]\n"

	switch(stat)
		if(CONSCIOUS)
			if(isnull(client))
				msg += "It appears to be in stand-by mode.\n" //afk
		if(UNCONSCIOUS)
			msg += "[SPAN_WARNING("It doesn't seem to be responding.")]\n"
		if(DEAD)
			msg += "<span class='deadsay'>It looks completely unsalvageable.</span>\n"
	msg += "*---------*</span>"

	if(print_flavor_text())
		msg += "\n[print_flavor_text()]\n"

	if(isnotnull(pose))
		if(findtext(pose, ".", length(pose)) == 0 && findtext(pose, "!", length(pose)) == 0 && findtext(pose, "?", length(pose)) == 0)
			pose = addtext(pose, ".") //Makes sure all emotes end with a period.
		msg += "\nIt is [pose]"

	to_chat(usr, msg)