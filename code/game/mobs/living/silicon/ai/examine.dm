/mob/living/silicon/ai/get_examine_header()
	. = list()
	. += SPAN_INFO_B("*---------*")
	. += SPAN_INFO("This is [html_icon(src)] <em>[src]</em>, an <em>AI</em>!")
	if(desc)
		. += SPAN_INFO(desc)

/mob/living/silicon/ai/get_examine_text()
	. = ..()
	if(getBruteLoss())
		if(getBruteLoss() < 30)
			. += SPAN_WARNING("It looks slightly dented.")
		else
			. += SPAN_DANGER("It looks severely dented!")
	if(getFireLoss())
		if(getFireLoss() < 30)
			. += SPAN_WARNING("It looks slightly charred.")
		else
			. += SPAN_DANGER("Its casing is melted and heat-warped!")

	if(stat == DEAD)
		. += SPAN("deadsay", "It appears to be powered-down.")
	else if(stat == UNCONSCIOUS)
		. += SPAN_WARNING("It is non-responsive and displaying the text: \"RUNTIME: Sensory Overload, stack 26/3\".")

	. += SPAN_INFO_B("*---------*")