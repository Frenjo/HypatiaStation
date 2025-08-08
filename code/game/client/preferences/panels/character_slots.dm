/datum/preferences/proc/character_slots_panel(mob/user)
	var/html = "<div align='center'>"

	var/savefile/S = new /savefile(path)
	if(isnotnull(S))
		html += "<b>Select a character slot to load</b>"
		html += "<hr>"
		var/name
		for(var/i = 1, i <= MAX_SAVE_SLOTS, i++)
			S.cd = "/character[i]"
			FROM_SAVEFILE(S, "real_name", name)
			if(!name)
				name = "Character[i]"
			if(i == default_slot)
				name = "<b>[name]</b>"
			html += "<a href='byond://?_src_=prefs;preference=saves;task=change_slot;num=[i];'>[name]</a><br>"

	html += "<hr>"
	html += "<a href='byond://?src=\ref[user];preference=saves;task=close'>Close</a><br>"
	html += "</div>"

	var/datum/browser/panel = new /datum/browser(user, "saves", "", 300, 500)
	panel.set_content(html)
	panel.open()

/datum/preferences/proc/process_character_slots_panel(mob/user, list/href_list)
	switch(href_list["task"])
		if("close")
			CLOSE_BROWSER(user, "window=saves")
			return
		if("change_slot")
			load_character(text2num(href_list["num"]))

	// Triggers both relevant panels to update after clicking an option.
	character_setup_panel(user)
	character_slots_panel(user)
	return TRUE