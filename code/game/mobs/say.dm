/mob/proc/say()
	return

/mob/verb/whisper()
	set category = PANEL_IC
	set name = "Whisper"
	return

/mob/verb/say_verb(message as text)
	set category = PANEL_IC
	set name = "Say"

	if(say_disabled)
		FEEDBACK_SPEECH_ADMIN_DISABLED(usr) // This is here to try to identify lag problems.
		return
	usr.say(message)

/mob/verb/me_verb(message as text)
	set category = PANEL_IC
	set name = "Me"

	if(say_disabled)
		FEEDBACK_SPEECH_ADMIN_DISABLED(usr) // This is here to try to identify lag problems.
		return

	message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))

	if(use_me)
		usr.emote("me", usr.emote_type, message)
	else
		usr.emote(message)

/mob/proc/say_dead(message)
	var/name = src.real_name
	var/alt_name = ""

	if(say_disabled)
		FEEDBACK_SPEECH_ADMIN_DISABLED(usr) // This is here to try to identify lag problems.
		return

	if(isnull(client.holder))
		if(!CONFIG_GET(dsay_allowed))
			to_chat(src, SPAN_WARNING("Deadchat is globally muted."))
			return

	if(isnotnull(client) && !(client.prefs.toggles & CHAT_DEAD))
		to_chat(usr, SPAN_WARNING("You have deadchat muted."))
		return

	if(mind?.name)
		name = "[mind.name]"
	else
		name = real_name
	if(name != real_name)
		alt_name = " (died as [real_name])"

	message = src.say_quote(message)
	var/rendered = "<span class='game deadsay'><span class='prefix'>DEAD:</span> <span class='name'>[name]</span>[alt_name] <span class='message'>[message]</span></span>"

	for(var/mob/M in GLOBL.player_list)
		if(isnewplayer(M))
			continue
		if((M.client?.holder.rights & R_ADMIN|R_MOD) && (M.client?.prefs.toggles & CHAT_DEAD)) // Show the message to admins/mods with deadchat toggled on
			to_chat(M, rendered)	//Admins can hear deadchat, if they choose to, no matter if they're blind/deaf or not.

		else if(M.stat == DEAD && (M.client?.prefs.toggles & CHAT_DEAD)) // Show the message to regular ghosts with deadchat toggled on.
			M.show_message(rendered, 2) //Takes into account blindness and such.
	return

/mob/proc/say_understands_language(mob/other, datum/language/speaking = null)
	if(isnotnull(speaking)) // Language check.
		var/understood = FALSE
		for(var/datum/language/L in languages)
			if(speaking.name == L.name)
				understood = TRUE
				break
		if(understood || universal_speak)
			return TRUE
		else
			return FALSE

/mob/proc/say_understands(mob/other, datum/language/speaking = null)
	if(stat == DEAD) //Dead
		return TRUE

	//Universal speak makes everything understandable, for obvious reasons.
	else if(src.universal_speak || src.universal_understand)
		return TRUE

	//Languages are handled after.
	if(!speaking)
		if(!other)
			return TRUE
		if(other.universal_speak)
			return TRUE
		if(isAI(src) && ispAI(other))
			return TRUE
		if(istype(other, type) || istype(src, other.type))
			return TRUE
		return FALSE

	//Language check.
	for(var/datum/language/L in src.languages)
		if(speaking.name == L.name)
			if(L.flags & NONVERBAL)
				if((sdisabilities & BLIND || blinded || stat) || !(other in view(src)))
					return FALSE

			return TRUE

	return FALSE

/mob/proc/say_quote(text, datum/language/speaking)
	if(!text)
		return "says, \"...\"";	//not the best solution, but it will stop a large number of runtimes. The cause is somewhere in the Tcomms code
		//tcomms code is still runtiming somewhere here
	var/ending = copytext(text, length(text))

	var/speech_verb = "says"
	var/speech_style = "body"

	if(isnotnull(speaking))
		speech_verb = speaking.speech_verb
		speech_style = speaking.colour
	else if(length(speak_emote))
		speech_verb = pick(speak_emote)
	else if(src.stuttering)
		speech_verb = "stammers"
	else if(src.slurring)
		speech_verb = "slurrs"
	else if(ending == "?")
		speech_verb = "asks"
	else if(ending == "!")
		speech_verb = "exclaims"
	else if(isliving(src))
		var/mob/living/L = src
		if(L.getBrainLoss() >= 60)
			speech_verb = "gibbers"

	return "<span class='say_quote'>[speech_verb],</span> \"<span class='[speech_style]'>[text]</span>\""

/mob/proc/emote(act, type, message)
	if(act == "me")
		return custom_emote(type, message)

/mob/proc/get_ear()
	// returns an atom representing a location on the map from which this
	// mob can hear things

	// should be overloaded for all mobs whose "ear" is separate from their "mob"

	return get_turf(src)

/mob/proc/say_test(text)
	var/ending = copytext(text, length(text))
	if(ending == "?")
		return "1"
	else if(ending == "!")
		return "2"
	return "0"

//parses the message mode code (e.g. :h, :w) from text, such as that supplied to say.
//returns the message mode string or null for no message mode.
//standard mode is the mode returned for the special ';' radio code.
/mob/proc/parse_message_mode(message, standard_mode = "headset")
	if(length(message) >= 1 && copytext(message, 1, 2) == ";")
		return standard_mode

	if(length(message) >= 2)
		var/channel_prefix = copytext(message, 1, 3)
		return GLOBL.department_radio_keys[channel_prefix]

	return null

//parses the language code (e.g. :j) from text, such as that supplied to say.
//returns the language object only if the code corresponds to a language that src can speak, otherwise null.
/mob/proc/parse_language(message)
	if(length(message) >= 2)
		var/language_prefix = lowertext(copytext(message, 1, 3))
		var/datum/language/L = GLOBL.language_keys[language_prefix]
		if(can_speak(L))
			return L
	return null