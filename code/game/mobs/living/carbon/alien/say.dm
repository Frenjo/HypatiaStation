/mob/living/carbon/alien/say(message)
	var/verb = "says"
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
		var/channel_prefix = copytext(message, 1 ,3)
		if(length(languages))
			for(var/datum/language/L in languages)
				if(lowertext(channel_prefix) == "[LANGUAGE_PREFIX_KEY][L.key]")
					verb = L.speech_verb
					speaking = L
					break

	if(speaking)
		message = trim(copytext(message, 3))

	message = capitalize(trim_left(message))

	if(!message || stat)
		return

	..(message, speaking, verb, null, null, message_range, null)