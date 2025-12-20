/mob/living/silicon/robot/usable_emotes = list(
	/decl/emote/synthetic/beep, /decl/emote/synthetic/buzz, /decl/emote/synthetic/buzz2,
	/decl/emote/synthetic/chime, /decl/emote/synthetic/honk, /decl/emote/synthetic/halt,
	/decl/emote/synthetic/law, /decl/emote/synthetic/ping, /decl/emote/synthetic/sad,
	/decl/emote/synthetic/warn
)

/mob/living/silicon/robot/emote(act, m_type = 1, message = null)
	var/param = null
	if(findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act, "s", -1) && !findtext(act, "_", -2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act, 1, length(act))

	if(act == "me")
		if(isnotnull(client))
			if(client.prefs.muted & MUTE_IC)
				FEEDBACK_IC_MUTED(src)
				return
			if(client.handle_spam_prevention(message, MUTE_IC))
				return
		if(stat)
			return
		if(!(message))
			return
		else
			return custom_emote(m_type, message)
	else if(act == "custom")
		return custom_emote(m_type, message)

	for(var/emote_path in usable_emotes)
		var/decl/emote/emote = GET_DECL_INSTANCE(emote_path)
		if(act == emote.key)
			emote.do_emote(src, param)
			return

	switch(act)
		if("salute")
			if(!src.buckled)
				var/M = null
				if(param)
					for(var/mob/A in view(null, null))
						if(param == A.name)
							M = A
							break
				if(!M)
					param = null

				if(param)
					message = "<B>[src]</B> salutes to [param]."
				else
					message = "<B>[src]</b> salutes."
			m_type = 1
		if("bow")
			if(!src.buckled)
				var/M = null
				if(param)
					for(var/mob/A in view(null, null))
						if(param == A.name)
							M = A
							break
				if(!M)
					param = null

				if(param)
					message = "<B>[src]</B> bows to [param]."
				else
					message = "<B>[src]</B> bows."
			m_type = 1

		if("clap")
			if (!src.restrained())
				message = "<B>[src]</B> claps."
				m_type = 2
		if("flap")
			if (!src.restrained())
				message = "<B>[src]</B> flaps his wings."
				m_type = 2

		if("aflap")
			if (!src.restrained())
				message = "<B>[src]</B> flaps his wings ANGRILY!"
				m_type = 2

		if("twitch")
			message = "<B>[src]</B> twitches violently."
			m_type = 1

		if("twitch_s")
			message = "<B>[src]</B> twitches."
			m_type = 1

		if("nod")
			message = "<B>[src]</B> nods."
			m_type = 1

		if("deathgasp")
			message = "<B>[src]</B> shudders violently for a moment, then becomes motionless, its eyes slowly darkening."
			m_type = 1

		if("glare")
			var/M = null
			if(param)
				for(var/mob/A in view(null, null))
					if(param == A.name)
						M = A
						break
			if(!M)
				param = null

			if(param)
				message = "<B>[src]</B> glares at [param]."
			else
				message = "<B>[src]</B> glares."

		if("stare")
			var/M = null
			if(param)
				for(var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if(!M)
				param = null

			if(param)
				message = "<B>[src]</B> stares at [param]."
			else
				message = "<B>[src]</B> stares."

		if("look")
			var/M = null
			if(param)
				for(var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break

			if(!M)
				param = null

			if (param)
				message = "<B>[src]</B> looks at [param]."
			else
				message = "<B>[src]</B> looks."
			m_type = 1

		if("help")
			to_chat(src, "salute, bow-(none)/mob, clap, flap, aflap, twitch, twitch_s, nod, deathgasp, glare-(none)/mob, stare-(none)/mob, look, beep, ping,<br>buzz, law, halt")
		else
			to_chat(src, SPAN_INFO("Unusable emote '[act]'. Say *help for a list."))

	if((message && src.stat == CONSCIOUS))
		if (m_type & 1)
			for(var/mob/O in viewers(src, null))
				O.show_message(message, m_type)
		else
			for(var/mob/O in hearers(src, null))
				O.show_message(message, m_type)
	return