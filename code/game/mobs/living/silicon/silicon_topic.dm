/mob/living/silicon/Topic(href, list/href_list)
	. = ..()
	if(href_list["lawc"]) // Toggling whether or not a law gets stated by the State Laws verb --NeoFite
		var/L = text2num(href_list["lawc"])
		switch(lawcheck[L + 1])
			if("Yes")
				lawcheck[L + 1] = "No"
			if("No")
				lawcheck[L + 1] = "Yes"
		//to_chat(src, "Switching Law [L]'s report status to [lawcheck[L+1]]")
		state_laws_verb()
		return

	if(href_list["lawi"]) // Toggling whether or not a law gets stated by the State Laws verb --NeoFite
		var/L = text2num(href_list["lawi"])
		switch(ioncheck[L])
			if("Yes")
				ioncheck[L] = "No"
			if("No")
				ioncheck[L] = "Yes"
		//to_chat(src, "Switching Law [L]'s report status to []lawcheck[L+1]")
		state_laws_verb()
		return

	if(href_list["laws"]) // With how my law selection code works, I changed statelaws from a verb to a proc, and call it through my law selection panel. --NeoFite
		state_laws()
		return