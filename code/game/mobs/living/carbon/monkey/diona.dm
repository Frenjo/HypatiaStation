/*
  Tiny babby plant critter plus procs.
*/

//Helper object for picking dionaea (and other creatures) up.
/obj/item/holder
	name = "holder"
	desc = "You shouldn't ever see this."

/obj/item/holder/diona
	name = "diona nymph"
	desc = "It's a tiny plant critter."
	icon = 'icons/obj/objects.dmi'
	icon_state = "nymph"
	slot_flags = SLOT_HEAD
	origin_tech = list(/datum/tech/magnets = 3, /datum/tech/biotech = 5)

/obj/item/holder/New()
	..()
	GLOBL.processing_objects.Add(src)

/obj/item/holder/Destroy()
	//Hopefully this will stop the icon from remaining on human mobs.
	if(isliving(loc))
		var/mob/living/A = src.loc
		src.loc = null
		A.update_icons()
	GLOBL.processing_objects.Remove(src)
	return ..()

/obj/item/holder/process()
	if(!loc)
		qdel(src)

	if(isturf(loc) || !length(contents))
		for(var/mob/M in contents)
			M.forceMove(GET_TURF(src))
		qdel(src)

/obj/item/holder/attackby(obj/item/W, mob/user)
	for(var/mob/M in src.contents)
		M.attackby(W, user)

//Mob defines.
/mob/living/carbon/monkey/diona
	name = "diona nymph"
	voice_name = "diona nymph"
	speak_emote = list("chirrups")
	icon_state = "nymph1"
	var/list/donors = list()
	var/ready_evolve = 0

/mob/living/carbon/monkey/diona/attack_hand(mob/living/carbon/human/M)
	//Let people pick the little buggers up.
	if(M.a_intent == "help")
		if(M.species && istype(M.species, /datum/species/diona))
			M << "You feel your being twine with that of [src] as it merges with your biomass."
			src << "You feel your being twine with that of [M] as you merge with its biomass."
			src.verbs += /mob/living/carbon/monkey/diona/proc/split
			src.verbs -= /mob/living/carbon/monkey/diona/proc/merge
			forceMove(M)
		else
			var/obj/item/holder/diona/D = new(loc)
			forceMove(D)
			D.name = loc.name
			D.attack_hand(M)
			M << "You scoop up [src]."
			src << "[M] scoops you up."
		return

	..()

/mob/living/carbon/monkey/diona/New()
	..()
	gender = NEUTER
	dna.mutantrace = "plant"
	greaterform = SPECIES_DIONA
	add_language("Rootspeak")
	src.verbs += /mob/living/carbon/monkey/diona/proc/merge

//Verbs after this point.
/mob/living/carbon/monkey/diona/proc/merge()
	set category = "Diona"
	set name = "Merge with gestalt"
	set desc = "Merge with another diona."

	if(iscarbon(src.loc))
		src.verbs -= /mob/living/carbon/monkey/diona/proc/merge
		return

	var/list/choices = list()
	for(var/mob/living/carbon/C in view(1, src))

		if(!src.Adjacent(C) || !C.client)
			continue

		if(ishuman(C))
			var/mob/living/carbon/human/D = C
			if(D.species && D.species.name == "Diona")
				choices += C

	var/mob/living/M = input(src, "Who do you wish to merge with?") in null|choices

	if(!M || !src || !(src.Adjacent(M)))
		return

	if(ishuman(M))
		M << "You feel your being twine with that of [src] as it merges with your biomass."
		src << "You feel your being twine with that of [M] as you merge with its biomass."
		forceMove(M)
		src.verbs += /mob/living/carbon/monkey/diona/proc/split
		src.verbs -= /mob/living/carbon/monkey/diona/proc/merge
	else
		return

/mob/living/carbon/monkey/diona/proc/split()
	set category = "Diona"
	set name = "Split from gestalt"
	set desc = "Split away from your gestalt as a lone nymph."

	if(!iscarbon(src.loc))
		src.verbs -= /mob/living/carbon/monkey/diona/proc/split
		return

	src.loc << "You feel a pang of loss as [src] splits away from your biomass."
	src << "You wiggle out of the depths of [src.loc]'s biomass and plop to the ground."
	forceMove(GET_TURF(src))
	src.verbs -= /mob/living/carbon/monkey/diona/proc/split
	src.verbs += /mob/living/carbon/monkey/diona/proc/merge

/mob/living/carbon/monkey/diona/verb/evolve()
	set category = "Diona"
	set name = "Evolve"
	set desc = "Grow to a more complex form."

	if(!is_alien_whitelisted(src, SPECIES_DIONA) && CONFIG_GET(/decl/configuration_entry/usealienwhitelist))
		src << alert("You are currently not whitelisted to play as a full diona.")
		return 0

	if(length(donors) < 5)
		src << "You are not yet ready for your growth..."
		return

	if(nutrition < 400)
		src << "You have not yet consumed enough to grow..."
		return

	src.split()
	src.visible_message("\red [src] begins to shift and quiver, and erupts in a shower of shed bark and twigs!","\red You begin to shift and quiver, then erupt in a shower of shed bark and twigs, attaining your adult form!")

	var/mob/living/carbon/human/adult = new /mob/living/carbon/human(GET_TURF(src))
	adult.set_species(SPECIES_DIONA)

	if(istype(loc, /obj/item/holder/diona))
		var/obj/item/holder/diona/L = loc
		forceMove(L.loc)
		qdel(L)

	for(var/datum/language/L in languages)
		adult.add_language(L.name)
	adult.regenerate_icons()

	adult.name = "diona ([rand(100,999)])"
	adult.real_name = adult.name
	adult.ckey = src.ckey

	for(var/obj/item/W in src.contents)
		src.drop_from_inventory(W)
	qdel(src)

/mob/living/carbon/monkey/diona/verb/steal_blood()
	set category = "Diona"
	set name = "Steal Blood"
	set desc = "Take a blood sample from a suitable donor."

	var/list/choices = list()
	for(var/mob/living/carbon/human/H in oview(1,src))
		choices += H

	var/mob/living/carbon/human/M = input(src, "Who do you wish to take a sample from?") in null|choices

	if(!M || !src)
		return

	if(HAS_SPECIES_FLAGS(M.species, SPECIES_FLAG_NO_BLOOD))
		src << "\red That donor has no blood to take."
		return

	if(donors.Find(M.real_name))
		src << "\red That donor offers you nothing new."
		return

	src.visible_message("\red [src] flicks out a feeler and neatly steals a sample of [M]'s blood.","\red You flick out a feeler and neatly steal a sample of [M]'s blood.")
	donors += M.real_name
	for(var/datum/language/L in M.languages)
		languages += L

	spawn(25)
		update_progression()

/mob/living/carbon/monkey/diona/proc/update_progression()
	if(!length(donors))
		return

	if(length(donors) == 5)
		ready_evolve = 1
		to_chat(src, SPAN_ALIUM("You feel ready to move on to your next stage of growth."))
	else if(length(donors) == 3)
		universal_understand = 1
		to_chat(src, SPAN_ALIUM("You feel your awareness expand, and realize you know how to understand the creatures around you."))
	else
		to_chat(src, SPAN_ALIUM("The blood seeps into your small form, and you draw out the echoes of memories and personality from it, working them into your budding mind."))

/mob/living/carbon/monkey/diona/say_understands(mob/other, datum/language/speaking = null)
	if(ishuman(other) && !speaking)
		if(length(languages) >= 2) // They have sucked down some blood.
			return TRUE
	return ..()

/mob/living/carbon/monkey/diona/say(message)
	var/verbage = "says"
	var/message_range = world.view

	if(client)
		if(client.prefs.muted & MUTE_IC)
			FEEDBACK_IC_MUTED(src)
			return

	message =  trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))

	if(stat == DEAD)
		return say_dead(message)

	var/datum/language/speaking = null

	if(length(message) >= 2)
		var/channel_prefix = copytext(message, 1, 3)
		if(length(languages))
			for(var/datum/language/L in languages)
				if(lowertext(channel_prefix) == "[LANGUAGE_PREFIX_KEY][L.key]")
					verbage = L.speech_verb
					speaking = L
					break

	if(speaking)
		message = trim(copytext(message,3))

	message = capitalize(trim_left(message))

	if(!message || stat)
		return

	..(message, speaking, verbage, null, null, message_range, null)