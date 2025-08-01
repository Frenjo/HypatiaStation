/mob/living/carbon/slime/get_examine_header()
	. = list()
	. += SPAN_INFO_B("*---------*")
	. += SPAN_INFO("This is \icon[src] \a <em>[src]</em>!")

/mob/living/carbon/slime/get_examine_text()
	. = ..()
	switch(powerlevel)
		if(2 to 3)
			. += "It is flickering gently with a little electrical activity."
		if(4 to 5)
			. += "It is glowing gently with moderate levels of electrical activity."
		if(6 to 9)
			. += SPAN_WARNING("It is glowing brightly with high levels of electrical activity.")
		if(10)
			. += SPAN_DANGER("It is radiating with massive levels of electrical activity!")

	if(getBruteLoss())
		if(getBruteLoss() < 40)
			. += SPAN_WARNING("It has some punctures in its flesh!")
		else
			. += SPAN_DANGER("It has severe punctures and tears in its flesh!")

	if(stat == DEAD)
		. += SPAN("deadsay", "It is limp and unresponsive.")

	. += SPAN_INFO_B("*---------*")