/datum/preferences/proc/character_records_panel(mob/user)
	var/html = "<div align='center'><b>Set Character Records</b>"
	html += "<hr>"

	html += "<a href='byond://?src=\ref[user];preference=records;task=med_record'>Medical Records</a>"
	html += "<br>"
	if(length(med_record) <= 40)
		html += "[med_record]"
	else
		html += "[copytext(med_record, 1, 37)]..."

	html += "<br>"
	html += "<br>"
	html += "<a href='byond://?src=\ref[user];preference=records;task=gen_record'>Employment Records</a>"
	html += "<br>"
	if(length(gen_record) <= 40)
		html += "[gen_record]"
	else
		html += "[copytext(gen_record, 1, 37)]..."

	html += "<br>"
	html += "<br>"
	html += "<a href='byond://?src=\ref[user];preference=records;task=sec_record'>Security Records</a>"
	html += "<br>"
	if(length(sec_record) <= 40)
		html += "[sec_record]<br>"
	else
		html += "[copytext(sec_record, 1, 37)]...<br>"

	html += "<br>"
	html += "<hr>"
	html += "<a href='byond://?src=\ref[user];preference=records;task=close'>\[Done\]</a>"
	html += "</div>"

	var/datum/browser/panel = new /datum/browser(user, "records", "", 360, 280)
	panel.set_content(html)
	panel.open()

/datum/preferences/proc/process_character_records_panel(mob/user, datum/topic_input/topic)
	switch(topic.get("task"))
		if("close")
			CLOSE_BROWSER(user, "window=records")
			return

		if("med_record")
			var/medmsg = input(usr,"Set your medical notes here.", "Medical Records", html_decode(med_record)) as message
			if(medmsg != null)
				medmsg = copytext(medmsg, 1, MAX_PAPER_MESSAGE_LEN)
				medmsg = html_encode(medmsg)

				med_record = medmsg

		if("sec_record")
			var/secmsg = input(usr, "Set your security notes here.", "Security Records", html_decode(sec_record)) as message
			if(secmsg != null)
				secmsg = copytext(secmsg, 1, MAX_PAPER_MESSAGE_LEN)
				secmsg = html_encode(secmsg)

				sec_record = secmsg

		if("gen_record")
			var/genmsg = input(usr, "Set your employment notes here.", "Employment Records", html_decode(gen_record)) as message
			if(genmsg != null)
				genmsg = copytext(genmsg, 1, MAX_PAPER_MESSAGE_LEN)
				genmsg = html_encode(genmsg)

				gen_record = genmsg

	character_records_panel(user) // Refreshes the panel so things update.
	return 1