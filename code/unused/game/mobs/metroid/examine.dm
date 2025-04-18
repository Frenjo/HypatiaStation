/mob/living/carbon/metroid/examine()
	set src in oview()

	if(!usr || !src)	return
	if((usr.sdisabilities & BLIND || usr.blinded || usr.stat) && !isghost(usr))
		to_chat(usr, SPAN_NOTICE("Something is there but you can't see it."))
		return

	var/msg = "<span class='info'>*---------*\nThis is \icon[src] \a <EM>[src]</EM>!\n"
	if(src.stat == DEAD)
		msg += "<span class='deadsay'>It is limp and unresponsive.</span>\n"
	else
		if(src.getBruteLoss())
			msg += "<span class='warning'>"
			if (src.getBruteLoss() < 40)
				msg += "It has some punctures in its flesh!"
			else
				msg += "<B>It has severe punctures and tears in its flesh!</B>"
			msg += "</span>\n"

		switch(powerlevel)

			if(2 to 3)
				msg += "It is flickering gently with a little electrical activity.\n"

			if(4 to 5)
				msg += "It is glowing gently with moderate levels of electrical activity.\n"

			if(6 to 9)
				msg += "[SPAN_WARNING("It is glowing brightly with high levels of electrical activity.")]\n"

			if(10)
				msg += "[SPAN_DANGER("It is radiating with massive levels of electrical activity!")]\n"

	msg += "*---------*</span>"
	usr << msg
	return