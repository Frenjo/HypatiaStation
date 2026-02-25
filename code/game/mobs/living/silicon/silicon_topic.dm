/mob/living/silicon/handle_topic(mob/user, datum/topic_input/topic, topic_result)
	. = ..()
	if(!.)
		return FALSE

	if(topic.has("lawc")) // Toggling whether or not a law gets stated by the State Laws verb --NeoFite
		var/L = topic.get_num("lawc")
		switch(lawcheck[L + 1])
			if("Yes")
				lawcheck[L + 1] = "No"
			if("No")
				lawcheck[L + 1] = "Yes"
		//to_chat(src, "Switching Law [L]'s report status to [lawcheck[L+1]]")
		state_laws_verb()
		return

	if(topic.has("lawi")) // Toggling whether or not a law gets stated by the State Laws verb --NeoFite
		var/L = topic.get_num("lawi")
		switch(ioncheck[L])
			if("Yes")
				ioncheck[L] = "No"
			if("No")
				ioncheck[L] = "Yes"
		//to_chat(src, "Switching Law [L]'s report status to []lawcheck[L+1]")
		state_laws_verb()
		return

	if(topic.has("laws")) // With how my law selection code works, I changed statelaws from a verb to a proc, and call it through my law selection panel. --NeoFite
		state_laws()
		return