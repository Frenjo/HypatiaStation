/mob/living/silicon/useable_emotes = list(
	/decl/emote/synthetic/beep, /decl/emote/synthetic/buzz, /decl/emote/synthetic/buzz2,
	/decl/emote/synthetic/chime, /decl/emote/synthetic/honk, /decl/emote/synthetic/ping, /decl/emote/synthetic/sad,
	/decl/emote/synthetic/warn
)

/mob/living/silicon/emote(act, message_type = 1, message = null)
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
				return TRUE
			if(client.handle_spam_prevention(message, MUTE_IC))
				return TRUE
		if(stat)
			return TRUE
		if(!message)
			return TRUE
		else
			custom_emote(message_type, message)
			return TRUE
	else if(act == "custom")
		custom_emote(message_type, message)
		return TRUE

	for(var/emote_path in useable_emotes)
		var/decl/emote/emote = GET_DECL_INSTANCE(emote_path)
		if(act == emote.key)
			emote.do_emote(src, param)
			return TRUE

	return FALSE