/mob/living/carbon/movement_delay()
	. = ..()
	if(IS_RUNNING(src))
		if(drowsyness > 0)
			. += 6