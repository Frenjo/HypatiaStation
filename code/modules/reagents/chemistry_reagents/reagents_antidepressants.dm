/datum/reagent/antidepressant/methylphenidate
	name = "Methylphenidate"
	id = "methylphenidate"
	description = "Improves the ability to concentrate."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC"
	custom_metabolism = 0.01
	data = 0

/datum/reagent/antidepressant/methylphenidate/on_mob_life(mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	if(src.volume <= 0.1)
		if(data != -1)
			data = -1
			to_chat(M, SPAN_WARNING("You lose focus.."))
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(M, SPAN_INFO("Your mind feels focused and undivided."))
	..()
	return


/datum/reagent/antidepressant/citalopram
	name = "Citalopram"
	id = "citalopram"
	description = "Stabilizes the mind a little."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC"
	custom_metabolism = 0.01
	data = 0

/datum/reagent/antidepressant/citalopram/on_mob_life(mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	if(src.volume <= 0.1)
		if(data != -1)
			data = -1
			to_chat(M, SPAN_WARNING("Your mind feels a little less stable.."))
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(M, SPAN_INFO("Your mind feels stable.. a little stable."))
	..()
	return


/datum/reagent/antidepressant/paroxetine
	name = "Paroxetine"
	id = "paroxetine"
	description = "Stabilizes the mind greatly, but has a chance of adverse effects."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC"
	custom_metabolism = 0.01
	data = 0

/datum/reagent/antidepressant/paroxetine/on_mob_life(mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	if(src.volume <= 0.1)
		if(data != -1)
			data = -1
			to_chat(M, SPAN_WARNING("Your mind feels much less stable.."))
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			if(prob(90))
				to_chat(M, SPAN_INFO("Your mind feels much more stable."))
			else
				to_chat(M, SPAN_WARNING("Your mind breaks apart.."))
				M.hallucination += 200
	..()
	return