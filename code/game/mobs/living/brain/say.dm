//TODO: Convert this over for languages.
/mob/living/brain/say(var/message)
	if (silent)
		return

	if(!(container && (istype(container, /obj/item/mmi) || istype(container, /obj/item/mmi/posibrain))))
		return //No MMI, can't speak, bucko./N
	else
		if(prob(emp_damage*4))
			if(prob(10))//10% chane to drop the message entirely
				return
			else
				message = Gibberish(message, (emp_damage*6))//scrambles the message, gets worse when emp_damage is higher
		if(istype(container, /obj/item/mmi/radio_enabled))
			var/obj/item/mmi/radio_enabled/R = container
			if(R.radio)
				spawn(0) R.radio.hear_talk(src, sanitize(message))
		..()