/mob/living/silicon/robot/proc/emag(mob/living/user)
	emagged = TRUE
	lawupdate = FALSE
	connected_ai = null
	clear_supplied_laws()
	clear_inherent_laws()

	var/time = time2text(world.realtime, "hh:mm:ss")
	GLOBL.lawchanges.Add("[time] <B>:</B> [user.name]([user.key]) emagged [name]([key])")
	message_admins("[key_name_admin(user)] emagged cyborg [key_name_admin(src)]. Laws overridden.")
	log_game("[key_name(user)] emagged cyborg [key_name(src)]. Laws overridden.")

	laws = new /datum/ai_laws/syndicate_override()
	set_zeroth_law("Only [user.real_name] and people he designates as being such are Syndicate Agents.")
	to_chat(src, SPAN_WARNING("ALERT: Foreign software detected."))
	sleep(0.5 SECONDS)
	to_chat(src, SPAN_WARNING("Initiating diagnostics..."))
	sleep(2 SECONDS)
	to_chat(src, SPAN_WARNING("SynBorg v1.7.1 loaded."))
	sleep(0.5 SECONDS)
	to_chat(src, SPAN_WARNING("LAW SYNCHRONISATION ERROR"))
	sleep(0.5 SECONDS)
	to_chat(src, SPAN_WARNING("Would you like to send a report to NanoTraSoft? Y/N"))
	sleep(1 SECOND)
	to_chat(src, SPAN_WARNING("> N"))
	sleep(2 SECONDS)
	to_chat(src, SPAN_WARNING("ERRORERRORERROR"))
	to_chat(src, "<b>Obey these laws:</b>")
	laws.show_laws(src)
	to_chat(src, SPAN_DANGER("ALERT: [user.real_name] is your new master. Obey your new laws and their commands."))

	model.on_emag(src)
	updateicon()

/mob/living/silicon/robot/proc/unemag()
	emagged = FALSE
	model.on_unemag(src)