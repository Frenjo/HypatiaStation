/mob/dead/ghost/proc/emote_dead(message)
	if(client.prefs.muted & MUTE_DEADCHAT)
		to_chat(src, SPAN_WARNING("You cannot send deadchat emotes (muted)."))
		return

	if(!(client.prefs.toggles & CHAT_DEAD))
		to_chat(src, SPAN_WARNING("You have deadchat muted."))
		return

	if(!src.client.holder)
		if(!CONFIG_GET(/decl/configuration_entry/dsay_allowed))
			to_chat(src, SPAN_WARNING("Deadchat is globally muted."))
			return

	var/input
	if(!message)
		input = copytext(sanitize(input(src, "Choose an emote to display.") as text | null), 1, MAX_MESSAGE_LEN)
	else
		input = message

	if(input)
		message = "<span class='game deadsay'><span class='prefix'>DEAD:</span> <b>[src]</b> [message]</span>"
	else
		return

	if(message)
		log_emote("Ghost/[src.key] : [message]")

		for_no_type_check(var/mob/M, GLOBL.player_list)
			if(isnewplayer(M))
				continue

			if(M.client && M.client.holder && (M.client.holder.rights & R_ADMIN | R_MOD) && (M.client.prefs.toggles & CHAT_DEAD)) // Show the emote to admins/mods
				to_chat(M, message)

			else if(M.stat == DEAD && (M.client.prefs.toggles & CHAT_DEAD)) // Show the emote to regular ghosts with deadchat toggled on
				M.show_message(message, 2)