/mob
	var/list/usable_emotes = list()

/mob/proc/emote(act, type, message)
	if(act == "me")
		return custom_emote(type, message)

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

		for_no_type_check(var/mob/M, GLOBL.player_list)
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