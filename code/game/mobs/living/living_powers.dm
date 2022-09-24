/mob/living/proc/ventcrawl()
	set name = "Crawl through Vent"
	set desc = "Enter an air vent and crawl through the pipe system."
	set category = "Abilities"
	handle_ventcrawl()
	return

/mob/living/proc/hide()
	set name = "Hide"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Abilities"

	if(layer != TURF_LAYER + 0.2)
		layer = TURF_LAYER + 0.2
		to_chat(src, SPAN_INFO("You are now hiding."))
	else
		layer = MOB_LAYER
		to_chat(src, SPAN_INFO("You have stopped hiding."))