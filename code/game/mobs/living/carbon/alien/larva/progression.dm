/mob/living/carbon/alien/larva/update_progression()
	if(amount_grown < max_grown)
		amount_grown++
	return

/mob/living/carbon/alien/larva/confirm_evolution()
	var/list/message = list(
		SPAN_INFO_B("You are growing into a beautiful alien! It is time to choose a caste."),
		SPAN_INFO("There are three to choose from:"),
		SPAN_INFO("<b>Hunters</b> are strong and agile, able to hunt away from the hive and rapidly move through ventilation shafts. Hunters generate plasma slowly and have low reserves."),
		SPAN_INFO("<b>Sentinels</b> are tasked with protecting the hive and are deadly up close and at a range. They are not as physically imposing nor fast as the hunters."),
		SPAN_INFO("<b>Drones</b> are the working class, offering the largest plasma storage and generation. They are the only caste which may evolve again, turning into the dreaded alien queen.")
	)
	to_chat(src, jointext(message, "<br>"))
	var/alien_caste = alert(src, "Please choose which alien caste you shall belong to.", , "Hunter", "Sentinel", "Drone")
	return alien_caste ? "Xenomorph [alien_caste]" : null

/mob/living/carbon/alien/larva/show_evolution_blurb()
	return