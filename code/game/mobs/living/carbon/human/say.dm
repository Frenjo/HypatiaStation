/mob/living/carbon/human/say(message)
	//TODO: Add checks for species who do not speak common.

	var/verbage = "says"
	var/alt_name = ""
	var/message_range = world.view
	var/italics = 0

	if(client)
		if(client.prefs.muted & MUTE_IC)
			FEEDBACK_IC_MUTED(src)
			return

	message =  trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))

	if(stat == DEAD)
		return say_dead(message)

	if(istype(wear_mask, /obj/item/clothing/mask/muzzle))  //Todo:  Add this to speech_problem_flag checks.
		return

	if(copytext(message, 1, 2) == "*")
		return emote(copytext(message, 2))

	if(name != GetVoice())
		alt_name = "(as [get_id_name("Unknown")])"

	//parse the radio code and consume it
	var/message_mode = parse_message_mode(message, "headset")
	if(message_mode)
		if(message_mode == "headset")
			message = copytext(message, 2)	//it would be really nice if the parse procs could do this for us.
		else
			message = copytext(message, 3)

	//parse the language code and consume it
	var/datum/language/speaking = parse_language(message)
	if(speaking)
		verbage = speaking.speech_verb
		message = copytext(message,3)

		// This is broadcast to all mobs with the language,
		// irrespective of distance or anything else.
		if(speaking.flags & HIVEMIND)
			speaking.broadcast(src,trim(message))
			return

	message = capitalize(trim(message))

	if(speech_problem_flag)
		var/list/handle_r = handle_speech_problems(message)
		message = handle_r[1]
		verbage = handle_r[2]
		speech_problem_flag = handle_r[3]

	if(!message || stat)
		return

	if(!speaking)
		var/ending = copytext(message, length(message))
		if(ending == "!")
			verbage = pick("exclaims", "shouts", "yells")
		if(ending == "?")
			verbage = "asks"

	var/list/obj/item/used_radios = new

	switch(message_mode)
		if("headset")
			if(l_ear && isradio(l_ear))
				var/obj/item/device/radio/R = l_ear
				R.talk_into(src,message,null, verbage, speaking)
				used_radios += l_ear
			else if(r_ear && isradio(r_ear))
				var/obj/item/device/radio/R = r_ear
				R.talk_into(src,message,null, verbage, speaking)
				used_radios += r_ear

		if("right ear")
			var/obj/item/device/radio/R
			var/has_radio = 0
			if(r_ear && isradio(r_ear))
				R = r_ear
				has_radio = 1
			if(r_hand && isradio(r_hand))
				R = r_hand
				has_radio = 1
			if(has_radio)
				R.talk_into(src,message, null, verbage, speaking)
				used_radios += R

		if("left ear")
			var/obj/item/device/radio/R
			var/has_radio = 0
			if(l_ear && isradio(l_ear))
				R = l_ear
				has_radio = 1
			if(l_hand && isradio(l_hand))
				R = l_hand
				has_radio = 1
			if(has_radio)
				R.talk_into(src,message, null, verbage, speaking)
				used_radios += R

		if("intercom")
			for(var/obj/item/device/radio/intercom/I in view(1, null))
				I.talk_into(src, message, verbage, speaking)
				used_radios += I
		if("whisper")
			whisper_say(message, speaking, alt_name)
			return
		else
			if(message_mode)
				if(message_mode in (GLOBL.radio_channels | "department"))
					if(l_ear && isradio(l_ear))
						l_ear.talk_into(src,message, message_mode, verbage, speaking)
						used_radios += l_ear
					else if(r_ear && isradio(r_ear))
						r_ear.talk_into(src,message, message_mode, verbage, speaking)
						used_radios += r_ear

	if(length(used_radios))
		italics = 1
		message_range = 1

	var/datum/gas_mixture/environment = loc.return_air()
	if(environment)
		var/pressure = environment.return_pressure()
		if(pressure < SOUND_MINIMUM_PRESSURE)
			italics = 1
			message_range = 1

	if((species.name == SPECIES_VOX || species.name == SPECIES_VOX_ARMALIS) && prob(20))
		playsound(src.loc, 'sound/voice/shriek1.ogg', 50, 1)

	..(message, speaking, verbage, alt_name, italics, message_range, used_radios)

/mob/living/carbon/human/say_understands(mob/other, datum/language/speaking = null)
	if(has_brain_worms()) // Brain worms translate everything. Even mice and alien speak.
		return TRUE

	//These only pertain to common. Languages are handled by mob/say_understands()
	if(!speaking)
		if(istype(other, /mob/living/carbon/monkey/diona))
			if(length(other.languages) >= 2) // They've sucked down some blood and can speak common now.
				return TRUE
		if(issilicon(other))
			return TRUE
		if(isbrain(other))
			return TRUE
		if(isslime(other))
			return TRUE

	//This is already covered by mob/say_understands()
	//if (istype(other, /mob/living/simple_animal))
	//	if((other.universal_speak && !speaking) || src.universal_speak || src.universal_understand)
	//		return 1
	//	return 0

	return ..()

/mob/living/carbon/human/GetVoice()
	if(istype(src.wear_mask, /obj/item/clothing/mask/gas/voice))
		var/obj/item/clothing/mask/gas/voice/V = src.wear_mask
		if(V.vchange)
			return V.voice
		else
			return name
	if(mind && mind.changeling && mind.changeling.mimicing)
		return mind.changeling.mimicing
	if(GetSpecialVoice())
		return GetSpecialVoice()
	return real_name

/mob/living/carbon/human/proc/SetSpecialVoice(new_voice)
	if(new_voice)
		special_voice = new_voice
	return

/mob/living/carbon/human/proc/UnsetSpecialVoice()
	special_voice = ""
	return

/mob/living/carbon/human/proc/GetSpecialVoice()
	return special_voice

/mob/living/carbon/human/proc/handle_speech_problems(message)
	var/list/returns[3]
	var/verbage = "says"
	var/handled = 0
	if(silent)
		message = ""
		handled = 1
	if(sdisabilities & MUTE)
		message = ""
		handled = 1
	if(wear_mask)
		if(istype(wear_mask, /obj/item/clothing/mask/horsehead))
			var/obj/item/clothing/mask/horsehead/hoers = wear_mask
			if(hoers.voicechange)
				if(mind?.changeling && GLOBL.department_radio_keys[copytext(message, 1, 3)] != "changeling")
					message = pick("NEEIIGGGHHHH!", "NEEEIIIIGHH!", "NEIIIGGHH!", "HAAWWWWW!", "HAAAWWW!")
					verbage = pick("whinnies","neighs", "says")
					handled = 1

	if((HULK in mutations) && health >= 25 && length(message))
		message = "[uppertext(message)]!!!"
		verbage = pick("yells","roars","hollers")
		handled = 1
	if(slurring)
		message = slur(message)
		verbage = pick("stammers","stutters")
		handled = 1

	var/braindam = getBrainLoss()
	if(braindam >= 60)
		handled = 1
		if(prob(braindam/4))
			message = stutter(message)
			verbage = pick("stammers", "stutters")
		if(prob(braindam))
			message = uppertext(message)
			verbage = pick("yells like an idiot","says rather loudly")

	returns[1] = message
	returns[2] = verbage
	returns[3] = handled

	return returns