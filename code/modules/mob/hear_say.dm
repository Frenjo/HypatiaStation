// At minimum every mob has a hear_say proc.
/mob/proc/hear_say(message, verbage = "says", datum/language/language = null, alt_name = "", italics = 0, mob/speaker = null)
	if(!client)
		return

	if(sleeping || stat == UNCONSCIOUS)
		hear_sleep(message)
		return

	var/style = "body"
	if(!say_understands(speaker, language))
		if(isanimal(speaker))
			var/mob/living/simple_animal/S = speaker
			message = pick(S.speak)
		else
			message = stars(message)

	if(language)
		verbage = language.speech_verb
		style = language.colour

	var/speaker_name = speaker.name
	if(ishuman(speaker))
		var/mob/living/carbon/human/H = speaker
		speaker_name = H.GetVoice()

	if(italics)
		message = "<i>[message]</i>"

	var/track = null
	if(isobserver(src))
		if(italics && client.prefs.toggles & CHAT_GHOSTRADIO)
			return
		if(speaker_name != speaker.real_name && speaker.real_name)
			speaker_name = "[speaker.real_name] ([speaker_name])"
		track = "(<a href='byond://?src=\ref[src];track=\ref[speaker]'>follow</a>) "
		if(client.prefs.toggles & CHAT_GHOSTEARS && speaker in view(src))
			message = "<b>[message]</b>"

	if(sdisabilities & DEAF || ear_deaf)
		if(speaker == src)
			to_chat(src, SPAN_WARNING("You cannot hear yourself speak!"))
		else
			src << "<span class='name'>[speaker_name]</span>[alt_name] talks but you cannot hear \him."
	else
		src << "<span class='game say'><span class='name'>[speaker_name]</span>[alt_name] [track][verbage], <span class='message'><span class='[style]'>\"[message]\"</span></span></span>"


/mob/proc/hear_radio(message, verbage = "says", datum/language/language = null, part_a, part_b, mob/speaker = null, hard_to_hear = 0, vname = "")
	if(!client)
		return

	if(sleeping || stat == UNCONSCIOUS)
		hear_sleep(message)
		return

	var/track = null

	var/style = "body"
	if(!say_understands(speaker, language))
		if(isanimal(speaker))
			var/mob/living/simple_animal/S = speaker
			message = pick(S.speak)
		else
			message = stars(message)

	if(language)
		verbage = language.speech_verb
		style = language.colour

	if(hard_to_hear)
		message = stars(message)

	var/speaker_name = vname ? vname : speaker.name

	if(ishuman(speaker))
		var/mob/living/carbon/human/H = speaker
		if(H.voice)
			speaker_name = H.voice

	if(hard_to_hear)
		speaker_name = "unknown"

	if(isAI(src) && !hard_to_hear)
		var/jobname // the mob's "job"
		if(ishuman(speaker))
			var/mob/living/carbon/human/H = speaker
			jobname = H.get_assignment()
		else if(iscarbon(speaker)) // Nonhuman carbon mob
			jobname = "No id"
		else if(isAI(speaker))
			jobname = "AI"
		else if(isrobot(speaker))
			jobname = "Cyborg"
		else if(ispAI(speaker))
			jobname = "Personal AI"
		else
			jobname = "Unknown"

		track = "<a href='byond://?src=\ref[src];track=\ref[speaker]'>[speaker_name] ([jobname])</a>"

	if(isobserver(src))
		if(speaker_name != speaker.real_name && !isAI(speaker)) //Announce computer and various stuff that broadcasts doesn't use it's real name but AI's can't pretend to be other mobs.
			speaker_name = "[speaker.real_name] ([speaker_name])"
		track = "[speaker_name] (<a href='byond://?src=\ref[src];track=\ref[speaker]'>follow</a>)"

	if(sdisabilities & DEAF || ear_deaf)
		if(prob(20))
			to_chat(src, SPAN_WARNING("You feel your headset vibrate but can hear nothing from it!"))
	else if(track)
		src << "[part_a][track][part_b][verbage], <span class=\"[style]\">\"[message]\"</span></span></span>"
	else
		src << "[part_a][speaker_name][part_b][verbage], <span class=\"[style]\">\"[message]\"</span></span></span>"

/mob/proc/hear_sleep(message)
	var/heard = ""

	if(prob(15))
		var/list/punctuation = list(",", "!", ".", ";", "?")
		var/list/messages = text2list(message, " ")
		var/R = rand(1, messages.len)
		var/heardword = messages[R]
		if(copytext(heardword, 1, 1) in punctuation)
			heardword = copytext(heardword, 2)
		if(copytext(heardword, -1) in punctuation)
			heardword = copytext(heardword, 1, length(heardword))
		heard = "<span class = 'game_say'>...You hear something about...[heardword]</span>"

	else
		heard = "<span class = 'game_say'>...<i>You almost hear someone talking</i>...</span>"

	to_chat(src, heard)