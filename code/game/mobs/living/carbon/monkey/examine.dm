/mob/living/carbon/monkey/examine()
	set src in oview()

	var/msg = "<span class='info'>*---------*\nThis is \icon[src] \a <EM>[src]</EM>!\n"

	if(handcuffed)
		msg += "It is \icon[handcuffed] handcuffed!\n"
	if(wear_mask)
		msg += "It has \icon[wear_mask] \a [wear_mask] on its head.\n"
	if(l_hand)
		msg += "It has \icon[l_hand] \a [l_hand] in its left hand.\n"
	if(r_hand)
		msg += "It has \icon[r_hand] \a [r_hand] in its right hand.\n"
	if(back)
		msg += "It has \icon[back] \a [back] on its back.\n"
	if(stat == DEAD)
		msg += "<span class='deadsay'>It is limp and unresponsive, with no signs of life.</span>\n"
	else
		msg += "<span class='warning'>"
		if(getBruteLoss())
			if(getBruteLoss() < 30)
				msg += "It has minor bruising.\n"
			else
				msg += "<B>It has severe bruising!</B>\n"
		if(getFireLoss())
			if(getFireLoss() < 30)
				msg += "It has minor burns.\n"
			else
				msg += "<B>It has severe burns!</B>\n"
		if(stat == UNCONSCIOUS)
			msg += "It isn't responding to anything around it; it seems to be asleep.\n"
		msg += "</span>"

	if(digitalcamo)
		msg += "It is repulsively uncanny!\n"

	msg += "*---------*</span>"

	to_chat(usr, msg)