/client/verb/ooc(msg as text)
	set category = null
	set name = "OOC" //Gave this shit a shorter name so you only have to time out "ooc" rather than "ooc message" to use it --NeoFite

	if(say_disabled)
		FEEDBACK_SPEECH_ADMIN_DISABLED(usr) // This is here to try to identify lag problems.
		return

	if(isnull(mob))
		return
	if(IsGuestKey(key))
		to_chat(src, "Guests may not use OOC.")
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(isnull(msg))
		return

	if(!(prefs.toggles & CHAT_OOC))
		to_chat(src, SPAN_WARNING("You have OOC muted."))
		return

	if(isnull(holder) || holder.rank == "Donor") // This is ugly, but I Can't figure out any easy way without duplicating code to confirm the user is not a donor while being a holder using rights.
		if(!CONFIG_GET(/decl/configuration_entry/ooc_allowed))
			to_chat(src, SPAN_WARNING("OOC is globally muted."))
			return
		if(!CONFIG_GET(/decl/configuration_entry/dead_ooc_allowed) && mob.stat == DEAD)
			to_chat(usr, SPAN_WARNING("OOC for dead mobs has been turned off."))
			return
		if(prefs.muted & MUTE_OOC)
			to_chat(src, SPAN_WARNING("You cannot use OOC (muted)."))
			return
		if(handle_spam_prevention(msg, MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			log_admin("[key_name(src)] has attempted to advertise in OOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
			return

	log_ooc("[mob.name]/[key] : [msg]")

	var/display_colour = GLOBL.normal_ooc_colour
	if(isnotnull(holder) && isnull(holder.fakekey))
		display_colour = "#0099cc"	//light blue
		if(holder.rights & R_MOD && !(holder.rights & R_ADMIN))
			display_colour = "#184880"	//dark blue
		if(holder.rights & R_DEBUG && !(holder.rights & R_ADMIN))
			display_colour = "#1b521f"	//dark green
		else if(holder.rights & R_ADMIN)
			if(CONFIG_GET(/decl/configuration_entry/allow_admin_ooccolor))
				display_colour = prefs.ooccolor
			else
				display_colour = "#b82e00"	//orange

	for_no_type_check(var/client/C, GLOBL.clients)
		if(C.prefs.toggles & CHAT_OOC)
			var/display_name = key
			if(isnotnull(holder?.fakekey))
				if(isnotnull(C.holder))
					display_name = "[holder.fakekey]/([key])"
				else
					display_name = holder.fakekey
			// Formatted OOC chat so it looks a bit better, the double : was eye cancer. -Frenjo
			to_chat(C, "<font color='[display_colour]'><span class='ooc'><span class='prefix'>(OOC)</span> <EM>[display_name]:</EM> <span class='message'>[msg]</span></span></font>")

			/*
			if(holder)
				if(!holder.fakekey || C.holder)
					if(holder.rights & R_ADMIN)
						to_chat(C, "<font color=[CONFIG_GET(/decl/configuration_entry/allow_admin_ooccolor) ? prefs.ooccolor :"#b82e00" ]><b><span class='prefix'>OOC:</span> <EM>[key][holder.fakekey ? "/([holder.fakekey])" : ""]:</EM> <span class='message'>[msg]</span></b></font>")
					else if(holder.rights & R_MOD)
						to_chat(C, "<font color=#184880><b><span class='prefix'>OOC:</span> <EM>[key][holder.fakekey ? "/([holder.fakekey])" : ""]:</EM> <span class='message'>[msg]</span></b></font>")
					else
						to_chat(C, "<font color='[normal_ooc_colour]'><span class='ooc'><span class='prefix'>OOC:</span> <EM>[key]:</EM> <span class='message'>[msg]</span></span></font>")

				else
					to_chat(C, "<font color='[normal_ooc_colour]'><span class='ooc'><span class='prefix'>OOC:</span> <EM>[holder.fakekey ? holder.fakekey : key]:</EM> <span class='message'>[msg]</span></span></font>")
			else
				to_chat(C, "<font color='[normal_ooc_colour]'><span class='ooc'><span class='prefix'>OOC:</span> <EM>[key]:</EM> <span class='message'>[msg]</span></span></font>")
			*/

/client/proc/set_ooc(new_colour)
	set category = PANEL_FUN
	set name = "Set Player OOC Colour"
	set desc = "Set to yellow for eye burning goodness."

	GLOBL.normal_ooc_colour = new_colour

/client/verb/looc(msg as text)
	set category = null
	set name = "LOOC" //Gave this shit a shorter name so you only have to time out "ooc" rather than "ooc message" to use it --NeoFite
	set desc = "Local OOC, seen only by those in view."

	if(say_disabled)
		FEEDBACK_SPEECH_ADMIN_DISABLED(usr) // This is here to try to identify lag problems.
		return

	if(isnull(mob))
		return
	if(IsGuestKey(key))
		to_chat(src, "Guests may not use OOC.")
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(isnull(msg))
		return

	if(!(prefs.toggles & CHAT_LOOC))
		to_chat(src, SPAN_WARNING("You have LOOC muted."))
		return

	if(isnull(holder))
		if(!CONFIG_GET(/decl/configuration_entry/ooc_allowed))
			to_chat(src, SPAN_WARNING("OOC is globally muted."))
			return
		if(!CONFIG_GET(/decl/configuration_entry/dead_ooc_allowed) && mob.stat == DEAD)
			to_chat(usr, SPAN_WARNING("OOC for dead mobs has been turned off."))
			return
		if(prefs.muted & MUTE_OOC)
			to_chat(src, SPAN_WARNING("You cannot use OOC (muted)."))
			return
		if(handle_spam_prevention(msg, MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			log_admin("[key_name(src)] has attempted to advertise in OOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
			return

	log_ooc("(LOCAL) [mob.name]/[key] : [msg]")

	var/list/heard = get_mobs_in_view(7, mob)
	for(var/mob/M in heard)
		if(isnull(M.client))
			continue
		var/client/C = M.client
		if(C in GLOBL.admins)
			continue //they are handled after that

		if(C.prefs.toggles & CHAT_LOOC)
			var/display_name = key
			if(isnotnull(holder?.fakekey))
				if(isnotnull(C.holder))
					display_name = "[holder.fakekey]/([key])"
				else
					display_name = holder.fakekey
			to_chat(C, "<font color='#6699CC'><span class='ooc'><span class='prefix'>(LOOC)</span> <EM>[display_name]:</EM> <span class='message'>[msg]</span></span></font>")
	for_no_type_check(var/client/C, GLOBL.admins)
		if(C.prefs.toggles & CHAT_LOOC)
			var/prefix = "(R)LOOC"
			if(C.mob in heard)
				prefix = "LOOC"
			to_chat(C, "<font color='#6699CC'><span class='ooc'><span class='prefix'>[prefix]:</span> <EM>[key]:</EM> <span class='message'>[msg]</span></span></font>")