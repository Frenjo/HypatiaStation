//By Carnwennan

//This system was made as an alternative to all the in-game lists and variables used to log stuff in-game.
//lists and variables are great. However, they have several major flaws:
//Firstly, they use memory. TGstation has one of the highest memory usage of all the ss13 branches.
//Secondly, they are usually stored in an object. This means that they aren't centralised. It also means that
//the data is lost when the object is deleted! This is especially annoying for things like the singulo engine!
#define INVESTIGATE_DIR "data/investigate/"

//SYSTEM
/proc/investigate_subject2file(var/subject)
	return file("[INVESTIGATE_DIR][subject].html")

/hook/startup/proc/reset_investigate()
	. = TRUE
	if(!fdel(INVESTIGATE_DIR))
		. = FALSE

/atom/proc/investigate_log(var/message, var/subject)
	if(!message)	return
	var/F = investigate_subject2file(subject)
	if(!F)	return
	F << "<small>[time2text(world.timeofday,"hh:mm")] \ref[src] ([x],[y],[z])</small> || [src] [message]<br>"

//ADMINVERBS
/client/proc/investigate_show( subject in list("hrefs","notes","singulo","telesci") )
	set category = PANEL_ADMIN
	set name = "Investigate"

	if(!holder)	return
	switch(subject)
		if("singulo", "telesci")			//general one-round-only stuff
			var/F = investigate_subject2file(subject)
			if(!F)
				to_chat(src, SPAN_WARNING("Error: admin_investigate: [INVESTIGATE_DIR][subject] is an invalid path or cannot be accessed."))
				return
			SHOW_BROWSER(src, F, "window=investigate[subject];size=800x300")

		if("hrefs")				//persistant logs and stuff
			if(CONFIG_GET(/decl/configuration_entry/log_hrefs))
				if(isnotnull(GLOBL.href_logfile))
					SHOW_BROWSER(src, GLOBL.href_logfile, "window=investigate[subject];size=800x300")
				else
					to_chat(src, SPAN_WARNING("Error: admin_investigate: No href logfile found."))
					return
			else
				to_chat(src, SPAN_WARNING("Error: admin_investigate: Href Logging is not on."))
				return

#undef INVESTIGATE_DIR