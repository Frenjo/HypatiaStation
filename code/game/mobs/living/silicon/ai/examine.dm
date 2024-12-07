/mob/living/silicon/ai/examine()
	set src in oview()

	if(isnull(usr) || isnull(src))
		return
	if((usr.sdisabilities & BLIND || usr.blinded || usr.stat) && !isghost(usr))
		to_chat(usr, SPAN_NOTICE("Something is there but you can't see it."))
		return

	var/msg = "<span class='info'>*---------*\nThis is \icon[src] <EM>[src]</EM>!\n"
	if(stat == DEAD)
		msg += "<span class='deadsay'>It appears to be powered-down.</span>\n"
	else
		msg += "<span class='warning'>"
		if(getBruteLoss())
			if(getBruteLoss() < 30)
				msg += "It looks slightly dented.\n"
			else
				msg += "<B>It looks severely dented!</B>\n"
		if(getFireLoss())
			if(getFireLoss() < 30)
				msg += "It looks slightly charred.\n"
			else
				msg += "<B>Its casing is melted and heat-warped!</B>\n"

		if(stat == UNCONSCIOUS)
			msg += "It is non-responsive and displaying the text: \"RUNTIME: Sensory Overload, stack 26/3\".\n"
		msg += "</span>"
	msg += "*---------*</span>"

	to_chat(usr, msg)