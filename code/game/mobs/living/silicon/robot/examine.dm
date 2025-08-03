/mob/living/silicon/robot/get_examine_header()
	. = list()
	. += SPAN_INFO_B("*---------*")
	. += SPAN_INFO("This is [html_icon(src)] <em>[src]</em>, a <em>[model.display_name] [braintype]</em>!")
	if(desc)
		. += SPAN_INFO(desc)

/mob/living/silicon/robot/get_examine_text()
	. = ..()
	if(getBruteLoss())
		if(getBruteLoss() < 75)
			. += SPAN_WARNING("It looks slightly dented.")
		else
			. += SPAN_DANGER("It looks severely dented!")

	if(getFireLoss())
		if(getFireLoss() < 75)
			. += SPAN_WARNING("It looks slightly charred.")
		else
			. += SPAN_DANGER("It looks severely burnt and heat-warped!")

	if(health < CONFIG_GET(/decl/configuration_entry/health_threshold_crit)) // If it's in the "critically damaged" state.
		. += SPAN_WARNING("It looks barely operational.")

	if(opened)
		. += SPAN_WARNING("Its cover is open and the power cell is [cell ? "installed" : "missing"].")
	else
		. += SPAN_INFO("Its cover is closed.")

	if(!has_power)
		. += SPAN_WARNING("It appears to be running on backup power.")

	switch(stat)
		if(CONSCIOUS)
			if(isnull(client))
				. += "It appears to be in stand-by mode." // AFK
		if(UNCONSCIOUS)
			. += SPAN_WARNING("It doesn't seem to be responding.")
		if(DEAD)
			. += SPAN("deadsay", "It looks completely unsalvageable.")

	. += SPAN_INFO_B("*---------*")

	var/flavour_text = print_flavor_text()
	if(flavour_text)
		. += SPAN_INFO(flavour_text)

	if(isnotnull(pose))
		if(findtext(pose, ".", length(pose)) == 0 && findtext(pose, "!", length(pose)) == 0 && findtext(pose, "?", length(pose)) == 0)
			pose = addtext(pose, ".") // Makes sure all emotes end with a period.
		. += SPAN_INFO("It is [pose]")