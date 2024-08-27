/datum/reagent/antidepressant/methylphenidate
	name = "Methylphenidate"
	id = "methylphenidate"
	description = "Improves the ability to concentrate."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC"
	custom_metabolism = 0.01
	data = list("special" = 0)

/datum/reagent/antidepressant/methylphenidate/on_mob_life(mob/living/carbon/C)
	if(volume <= 0.1)
		if(data["special"] != -1)
			data["special"] = -1
			to_chat(C, SPAN_WARNING("You lose focus.."))
	else
		if(world.time > data["special"] + ANTIDEPRESSANT_MESSAGE_DELAY)
			data["special"] = world.time
			to_chat(C, SPAN_INFO("Your mind feels focused and undivided."))
	. = ..()

/datum/reagent/antidepressant/citalopram
	name = "Citalopram"
	id = "citalopram"
	description = "Stabilizes the mind a little."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC"
	custom_metabolism = 0.01
	data = list("special" = 0)

/datum/reagent/antidepressant/citalopram/on_mob_life(mob/living/carbon/C)
	if(volume <= 0.1)
		if(data["special"] != -1)
			data["special"] = -1
			to_chat(C, SPAN_WARNING("Your mind feels a little less stable.."))
	else
		if(world.time > data["special"] + ANTIDEPRESSANT_MESSAGE_DELAY)
			data["special"] = world.time
			to_chat(C, SPAN_INFO("Your mind feels stable.. a little stable."))
	. = ..()

/datum/reagent/antidepressant/paroxetine
	name = "Paroxetine"
	id = "paroxetine"
	description = "Stabilizes the mind greatly, but has a chance of adverse effects."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC"
	custom_metabolism = 0.01
	data = list("special" = 0)

/datum/reagent/antidepressant/paroxetine/on_mob_life(mob/living/carbon/C)
	if(volume <= 0.1)
		if(data["special"] != -1)
			data["special"] = -1
			to_chat(C, SPAN_WARNING("Your mind feels much less stable.."))
	else
		if(world.time > data["special"] + ANTIDEPRESSANT_MESSAGE_DELAY)
			data["special"] = world.time
			if(prob(90))
				to_chat(C, SPAN_INFO("Your mind feels much more stable."))
			else
				to_chat(C, SPAN_WARNING("Your mind breaks apart.."))
				C.hallucination += 200
	. = ..()