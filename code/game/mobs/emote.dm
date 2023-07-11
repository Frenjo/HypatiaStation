// All mobs should have custom emote, really..
/mob/proc/custom_emote(m_type = 1, message = null)
	if(stat || !use_me && usr == src)
		to_chat(usr, "You are unable to emote.")
		return

	var/muzzled = istype(src.wear_mask, /obj/item/clothing/mask/muzzle)
	if(m_type == 2 && muzzled)
		return

	var/input
	if(!message)
		input = copytext(sanitize(input(src, "Choose an emote to display.") as text | null), 1, MAX_MESSAGE_LEN)
	else
		input = message
	if(input)
		message = "<B>[src]</B> [input]"
	else
		return

	if(message)
		log_emote("[name]/[key] : [message]")

 //Hearing gasp and such every five seconds is not good emotes were not global for a reason.
 // Maybe some people are okay with that.

		for(var/mob/M in GLOBL.player_list)
			if(!M.client)
				continue //skip monkeys and leavers
			if(isnewplayer(M))
				continue
			if(findtext(message," snores.")) //Because we have so many sleeping people.
				break
			if(M.stat == DEAD && (M.client.prefs.toggles & CHAT_GHOSTSIGHT) && !(M in viewers(src, null)))
				M.show_message(message)


		// Type 1 (Visual) emotes are sent to anyone in view of the item
		if(m_type & 1)
			var/list/can_see = get_mobs_in_view(1, src)  //Allows silicon & mmi mobs carried around to see the emotes of the person carrying them around.
			can_see |= viewers(src,null)
			for(var/mob/O in can_see)
				O.show_message(message, m_type)

		// Type 2 (Audible) emotes are sent to anyone in hear range
		// of the *LOCATION* -- this is important for pAIs to be heard
		else if(m_type & 2)
			for(var/mob/O in get_mobs_in_view(7, src))
				O.show_message(message, m_type)

/mob/proc/emote_dead(message)
	if(client.prefs.muted & MUTE_DEADCHAT)
		to_chat(src, SPAN_WARNING("You cannot send deadchat emotes (muted)."))
		return

	if(!(client.prefs.toggles & CHAT_DEAD))
		to_chat(src, SPAN_WARNING("You have deadchat muted."))
		return

	if(!src.client.holder)
		if(!CONFIG_GET(dsay_allowed))
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

		for(var/mob/M in GLOBL.player_list)
			if(isnewplayer(M))
				continue

			if(M.client && M.client.holder && (M.client.holder.rights & R_ADMIN | R_MOD) && (M.client.prefs.toggles & CHAT_DEAD)) // Show the emote to admins/mods
				to_chat(M, message)

			else if(M.stat == DEAD && (M.client.prefs.toggles & CHAT_DEAD)) // Show the emote to regular ghosts with deadchat toggled on
				M.show_message(message, 2)