/datum/species/proc/hug(mob/living/carbon/human/H, mob/living/target)
	var/t_him = "them"
	switch(target.gender)
		if(MALE)
			t_him = "him"
		if(FEMALE)
			t_him = "her"

	H.visible_message(
		SPAN_NOTICE("[H] hugs [target] to make [t_him] feel better!"),
		SPAN_NOTICE("You hug [target] to make [t_him] feel better!")
	)