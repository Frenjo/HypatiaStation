/mob/living/silicon/say_quote(text)
	var/ending = copytext(text, length(text))

	if(ending == "?")
		return "queries"
	else if(ending == "!")
		return "declares"

	return "states"

#define IS_AI 1
#define IS_ROBOT 2
#define IS_PAI 3

/mob/living/silicon/say_understands(other, datum/language/speaking = null)
	// These only pertain to common. Languages are handled by mob/say_understands()
	if(isnull(speaking))
		if(ishuman(other))
			return TRUE
		if(issilicon(other))
			return TRUE
		if(isbrain(other))
			return TRUE
	return ..()

/mob/living/silicon/say(message)
	if(!message)
		return

	if(isnotnull(client))
		if(client.prefs.muted & MUTE_IC)
			FEEDBACK_IC_MUTED(src)
			return
		if(client.handle_spam_prevention(message, MUTE_IC))
			return

	message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))

	if(stat == DEAD)
		return say_dead(message)

	if(copytext(message, 1, 2) == "*")
		return emote(copytext(message, 2))

	var/bot_type = 0			//Let's not do a fuck ton of type checks, thanks.
								// This is slightly more acceptable now given it's just tiny macro checks. -Frenjo
	if(isAI(src))
		bot_type = IS_AI
	else if(isrobot(src))
		bot_type = IS_ROBOT
	else if(ispAI(src))
		bot_type = IS_PAI

	var/mob/living/silicon/ai/AI = src		//and let's not declare vars over and over and over for these guys.
	var/mob/living/silicon/robot/R = src
	var/mob/living/silicon/pai/P = src

	//Must be concious to speak
	if(stat)
		return

	var/verbage = say_quote(message)

	//parse radio key and consume it
	var/message_mode = parse_message_mode(message, "general")
	if(message_mode)
		if(message_mode == "general")
			message = trim(copytext(message, 2))
		else
			message = trim(copytext(message, 3))

	//parse language key and consume it
	var/datum/language/speaking = parse_language(message)
	if(isnotnull(speaking))
		verbage = speaking.speech_verb
		message = copytext(message, 3)
		if(speaking.flags & HIVEMIND)
			speaking.broadcast(src, trim(message))
			return

	// Currently used by drones.
	if(local_transmit)
		var/list/listeners = hearers(5, src)
		listeners |= src

		for(var/mob/living/silicon/D in listeners)
			if(isnotnull(D.client) && istype(D, type))
				to_chat(D, "<b>[src]</b> transmits, \"[message]\"")

		for(var/mob/M in GLOBL.player_list)
			if(isnewplayer(M))
				continue
			else if(M.stat == DEAD && M.client.prefs.toggles & CHAT_GHOSTEARS)
				if(isnotnull(M.client))
					to_chat(M, "<b>[src]</b> transmits, \"[message]\"")
		return

	if(message_mode && bot_type == IS_ROBOT && !R.is_component_functioning("radio"))
		to_chat(src, SPAN_WARNING("Your radio isn't functional at this time."))
		return

	switch(message_mode)
		if("department")
			switch(bot_type)
				if(IS_AI)
					AI.holopad_talk(message)
				if(IS_ROBOT)
					log_say("[key_name(src)] : [message]")
					R.radio.talk_into(src, message, message_mode, verbage, speaking)
				if(IS_PAI)
					log_say("[key_name(src)] : [message]")
					P.radio.talk_into(src, message, message_mode, verbage, speaking)
			return
		if("general")
			switch(bot_type)
				if(IS_AI)
					src << "Yeah, not yet, sorry"
				if(IS_ROBOT)
					log_say("[key_name(src)] : [message]")
					R.radio.talk_into(src, message, null, verbage, speaking)
				if(IS_PAI)
					log_say("[key_name(src)] : [message]")
					P.radio.talk_into(src, message, null, verbage, speaking)
			return

		else
			if(message_mode && (message_mode in GLOBL.radio_channels))
				switch(bot_type)
					if(IS_AI)
						src << "You don't have this function yet, I'm working on it"
						return
					if(IS_ROBOT)
						log_say("[key_name(src)] : [message]")
						R.radio.talk_into(src, message, message_mode, verbage, speaking)
					if(IS_PAI)
						log_say("[key_name(src)] : [message]")
						P.radio.talk_into(src, message, message_mode, verbage, speaking)
				return

	return ..(message, null, verbage)

//For holopads only. Usable by AI.
/mob/living/silicon/ai/proc/holopad_talk(message)
	log_say("[key_name(src)] : [message]")

	message = trim(message)

	if(!message)
		return

	var/obj/machinery/hologram/holopad/T = current
	if(istype(T) && T.hologram && T.master == src)//If there is a hologram and its master is the user.
		var/verbage = say_quote(message)

		//Human-like, sorta, heard by those who understand humans.
		var/rendered_a = "<span class='game say'><span class='name'>[verbage]</span> <span class='message'>[message]</span></span>"

		//Speach distorted, heard by those who do not understand AIs.
		var/message_stars = stars(message)
		var/rendered_b = "<span class='game say'><span class='name'>[voice_name]</span> [verbage], <span class='message'>\"[message_stars]\"</span></span>"

		to_chat(src, "<i><span class='game say'>Holopad transmitted, <span class='name'>[real_name]</span> [verbage], <span class='message'>[message]</span></span></i>") // The AI can "hear" its own message.

		for(var/mob/M in hearers(T.loc))//The location is the object, default distance.
			if(M.say_understands(src))//If they understand AI speak. Humans and the like will be able to.
				M.show_message(rendered_a, 2)
			else//If they do not.
				M.show_message(rendered_b, 2)
		/*Radios "filter out" this conversation channel so we don't need to account for them.
		This is another way of saying that we won't bother dealing with them.*/
	else
		to_chat(src, "No holopad connected.")

#undef IS_AI
#undef IS_ROBOT
#undef IS_PAI