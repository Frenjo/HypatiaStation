/client/verb/who()
	set category = PANEL_OOC
	set name = "Who"

	var/msg = "<b>Current Players:</b>\n"

	var/list/lines = list()

	if(isnotnull(holder))
		for_no_type_check(var/client/C, GLOBL.clients)
			var/entry = "\t[C.key]"
			if(isnotnull(C.holder?.fakekey))
				entry += " <i>(as [C.holder.fakekey])</i>"
			entry += " - Playing as [C.mob.real_name]"
			switch(C.mob.stat)
				if(UNCONSCIOUS)
					entry += " - <font color='darkgray'><b>Unconscious</b></font>"
				if(DEAD)
					if(isobserver(C.mob))
						var/mob/dead/observer/O = C.mob
						if(O.started_as_observer)
							entry += " - <font color='gray'>Observing</font>"
						else
							entry += " - <font color='black'><b>DEAD</b></font>"
					else
						entry += " - <font color='black'><b>DEAD</b></font>"
			if(is_special_character(C.mob))
				entry += " - <b><font color='red'>Antagonist</font></b>"
			entry += " (<A HREF='?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</A>)"
			lines.Add(entry)
	else
		for_no_type_check(var/client/C, GLOBL.clients)
			if(isnotnull(C.holder?.fakekey))
				lines.Add(C.holder.fakekey)
			else
				lines.Add(C.key)

	for(var/line in sortList(lines))
		msg += "[line]\n"

	msg += "<b>Total Players: [length(lines)]</b>"
	to_chat(src, msg)

/client/verb/staffwho()
	set category = PANEL_ADMIN
	set name = "Staffwho"

	var/msg = ""
	var/modmsg = ""
	var/num_mods_online = 0
	var/num_admins_online = 0
	if(isnotnull(holder))
		for_no_type_check(var/client/C, GLOBL.admins)
			if(R_ADMIN & C.holder.rights || !(R_MOD & C.holder.rights))
				msg += "\t[C] is a [C.holder.rank]"

				if(isnotnull(C.holder.fakekey))
					msg += " <i>(as [C.holder.fakekey])</i>"

				if(isobserver(C.mob))
					msg += " - Observing"
				else if(isnewplayer(C.mob))
					msg += " - Lobby"
				else
					msg += " - Playing"

				if(C.is_afk())
					msg += " (AFK)"
				msg += "\n"

				num_admins_online++
			else
				modmsg += "\t[C] is a [C.holder.rank]"

				if(isobserver(C.mob))
					modmsg += " - Observing"
				else if(isnewplayer(C.mob))
					modmsg += " - Lobby"
				else
					modmsg += " - Playing"

				if(C.is_afk())
					modmsg += " (AFK)"
				modmsg += "\n"
				num_mods_online++
	else
		for_no_type_check(var/client/C, GLOBL.admins)
			if(R_ADMIN & C.holder.rights || !(R_MOD & C.holder.rights))
				if(isnull(C.holder.fakekey))
					msg += "\t[C] is a [C.holder.rank]\n"
					num_admins_online++
			else
				modmsg += "\t[C] is a [C.holder.rank]\n"
				num_mods_online++

	msg = "<b>Current Admins ([num_admins_online]):</b>\n" + msg + "\n<b> Current Moderators([num_mods_online]):</b>\n" + modmsg
	to_chat(src, msg)