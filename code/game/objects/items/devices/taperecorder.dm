/obj/item/taperecorder
	desc = "A device that can record up to an hour of dialogue and play it back. It automatically translates the content in playback."
	name = "universal recorder"
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "taperecorderidle"
	item_state = "analyser"
	w_class = 1.0
	matter_amounts = list(MATERIAL_METAL = 60, MATERIAL_GLASS = 30)

	flags = CONDUCT
	throwforce = 2
	throw_speed = 4
	throw_range = 20

	var/emagged = 0.0
	var/recording = 0.0
	var/playing = 0.0
	var/timerecorded = 0.0
	var/playsleepseconds = 0.0
	var/list/storedinfo = list()
	var/list/timestamp = list()
	var/canprint = 1

/obj/item/taperecorder/hear_talk(mob/living/M as mob, msg, verbage = "says")
	if(recording)
		//var/ending = copytext(msg, length(msg))
		timestamp+= timerecorded
		/*
		if(M.stuttering)
			storedinfo += "\[[time2text(timerecorded*10,"mm:ss")]\] [M.name] stammers, \"[msg]\""
			return
		if(M.getBrainLoss() >= 60)
			storedinfo += "\[[time2text(timerecorded*10,"mm:ss")]\] [M.name] gibbers, \"[msg]\""
			return
		if(ending == "?")
			storedinfo += "\[[time2text(timerecorded*10,"mm:ss")]\] [M.name] asks, \"[msg]\""
			return
		else if(ending == "!")
			storedinfo += "\[[time2text(timerecorded*10,"mm:ss")]\] [M.name] exclaims, \"[msg]\""
			return
		storedinfo += "\[[time2text(timerecorded*10,"mm:ss")]\] [M.name] says, \"[msg]\""
		*/
		storedinfo += "\[[time2text(timerecorded*10,"mm:ss")]\] [M.name] [verbage], \"[msg]\""

		return

/obj/item/taperecorder/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/card/emag))
		if(emagged == 0)
			emagged = 1
			recording = 0
			to_chat(user, SPAN_WARNING("PZZTTPFFFT"))
			icon_state = "taperecorderidle"
		else
			to_chat(user, SPAN_WARNING("It is already emagged!"))

/obj/item/taperecorder/proc/explode()
	var/turf/T = get_turf(loc)
	if(ismob(loc))
		var/mob/M = loc
		to_chat(M, SPAN_DANGER("\The [src] explodes!"))
	if(T)
		T.hotspot_expose(700, 125)
		explosion(T, -1, -1, 0, 4)
	qdel(src)
	return

/obj/item/taperecorder/verb/record()
	set category = PANEL_OBJECT
	set name = "Start Recording"

	if(usr.stat)
		return
	if(emagged == 1)
		to_chat(usr, SPAN_WARNING("The tape recorder makes a scratchy noise."))
		return
	icon_state = "taperecorderrecording"
	if(timerecorded < 3600 && playing == 0)
		to_chat(usr, SPAN_NOTICE("Recording started."))
		recording = 1
		timestamp += timerecorded
		storedinfo += "\[[time2text(timerecorded*10,"mm:ss")]\] Recording started."
		for(timerecorded, timerecorded < 3600)
			if(recording == 0)
				break
			timerecorded++
			sleep(10)
		recording = 0
		icon_state = "taperecorderidle"
		return
	else
		to_chat(usr, SPAN_NOTICE("Either your tape recorder's memory is full, or it is currently playing back its memory."))

/obj/item/taperecorder/verb/stop()
	set category = PANEL_OBJECT
	set name = "Stop"

	if(usr.stat)
		return
	if(emagged == 1)
		to_chat(usr, SPAN_WARNING("The tape recorder makes a scratchy noise."))
		return
	if(recording == 1)
		recording = 0
		timestamp += timerecorded
		storedinfo += "\[[time2text(timerecorded*10,"mm:ss")]\] Recording stopped."
		to_chat(usr, SPAN_NOTICE("Recording stopped."))
		icon_state = "taperecorderidle"
		return
	else if(playing == 1)
		playing = 0
		var/turf/T = get_turf(src)
		T.visible_message("<font color=Maroon><B>Tape Recorder</B>: Playback stopped.</font>")
		icon_state = "taperecorderidle"
		return

/obj/item/taperecorder/verb/clear_memory()
	set category = PANEL_OBJECT
	set name = "Clear Memory"

	if(usr.stat)
		return
	if(emagged == 1)
		to_chat(usr, SPAN_WARNING("The tape recorder makes a scratchy noise."))
		return
	if(recording == 1 || playing == 1)
		to_chat(usr, SPAN_NOTICE("You can't clear the memory while playing or recording!"))
		return
	else
		if(storedinfo)
			storedinfo.Cut()
		if(timestamp)
			timestamp.Cut()
		timerecorded = 0
		to_chat(usr, SPAN_NOTICE("Memory cleared."))
		return

/obj/item/taperecorder/verb/playback_memory()
	set category = PANEL_OBJECT
	set name = "Playback Memory"

	if(usr.stat)
		return
	if(emagged == 1)
		to_chat(usr, SPAN_WARNING("The tape recorder makes a scratchy noise."))
		return
	if(recording == 1)
		to_chat(usr, SPAN_NOTICE("You can't playback when recording!"))
		return
	if(playing == 1)
		to_chat(usr, SPAN_NOTICE("You're already playing!"))
		return
	playing = 1
	icon_state = "taperecorderplaying"
	to_chat(usr, SPAN_NOTICE("Playing started."))
	for(var/i = 1, timerecorded < 3600, sleep(10 * (playsleepseconds)))
		if(playing == 0)
			break
		if(length(storedinfo) < i)
			break
		var/turf/T = get_turf(src)
		T.visible_message("<font color=Maroon><B>Tape Recorder</B>: [storedinfo[i]]</font>")
		if(length(storedinfo) < i + 1)
			playsleepseconds = 1
			sleep(10)
			T = get_turf(src)
			T.visible_message("<font color=Maroon><B>Tape Recorder</B>: End of recording.</font>")
		else
			playsleepseconds = timestamp[i + 1] - timestamp[i]
		if(playsleepseconds > 14)
			sleep(10)
			T = get_turf(src)
			T.visible_message("<font color=Maroon><B>Tape Recorder</B>: Skipping [playsleepseconds] seconds of silence</font>")
			playsleepseconds = 1
		i++
	icon_state = "taperecorderidle"
	playing = 0
	if(emagged == 1.0)
		var/turf/T = get_turf(src)
		T.visible_message("<font color=Maroon><B>Tape Recorder</B>: This tape recorder will self-destruct in... Five.</font>")
		sleep(10)
		T = get_turf(src)
		T.visible_message("<font color=Maroon><B>Tape Recorder</B>: Four.</font>")
		sleep(10)
		T = get_turf(src)
		T.visible_message("<font color=Maroon><B>Tape Recorder</B>: Three.</font>")
		sleep(10)
		T = get_turf(src)
		T.visible_message("<font color=Maroon><B>Tape Recorder</B>: Two.</font>")
		sleep(10)
		T = get_turf(src)
		T.visible_message("<font color=Maroon><B>Tape Recorder</B>: One.</font>")
		sleep(10)
		explode()

/obj/item/taperecorder/verb/print_transcript()
	set category = PANEL_OBJECT
	set name = "Print Transcript"

	if(usr.stat)
		return
	if(emagged == 1)
		to_chat(usr, SPAN_WARNING("The tape recorder makes a scratchy noise."))
		return
	if(!canprint)
		to_chat(usr, SPAN_NOTICE("The recorder can't print that fast!"))
		return
	if(recording == 1 || playing == 1)
		to_chat(usr, SPAN_NOTICE("You can't print the transcript while playing or recording!"))
		return
	to_chat(usr, SPAN_NOTICE("Transcript printed."))
	var/obj/item/paper/P = new /obj/item/paper(get_turf(src))
	var/t1 = "<B>Transcript:</B><BR><BR>"
	for(var/i = 1, length(storedinfo) >= i, i++)
		t1 += "[storedinfo[i]]<BR>"
	P.info = t1
	P.name = "Transcript"
	canprint = 0
	sleep(300)
	canprint = 1

/obj/item/taperecorder/attack_self(mob/user)
	if(recording == 0 && playing == 0)
		if(usr.stat)
			return
		if(emagged == 1)
			to_chat(usr, SPAN_WARNING("The tape recorder makes a scratchy noise."))
			return
		icon_state = "taperecorderrecording"
		if(timerecorded < 3600 && playing == 0)
			to_chat(usr, SPAN_INFO("Recording started."))
			recording = 1
			timestamp+= timerecorded
			storedinfo += "\[[time2text(timerecorded*10,"mm:ss")]\] Recording started."
			for(timerecorded, timerecorded < 3600)
				if(recording == 0)
					break
				timerecorded++
				sleep(10)
			recording = 0
			icon_state = "taperecorderidle"
			return
		else
			to_chat(usr, SPAN_WARNING("Either your tape recorder's memory is full, or it is currently playing back its memory."))
	else
		if(usr.stat)
			to_chat(usr, "Not when you're incapacitated.")
			return
		if(recording == 1)
			recording = 0
			timestamp+= timerecorded
			storedinfo += "\[[time2text(timerecorded*10,"mm:ss")]\] Recording stopped."
			to_chat(usr, SPAN_INFO("Recording stopped."))
			icon_state = "taperecorderidle"
			return
		else if(playing == 1)
			playing = 0
			var/turf/T = get_turf(src)
			for(var/mob/O in hearers(world.view - 1, T))
				O.show_message("<font color=Maroon><B>Tape Recorder</B>: Playback stopped.</font>",2)
			icon_state = "taperecorderidle"
			return
		else
			to_chat(usr, SPAN_WARNING("Stop what?"))
			return