/datum/preferences/proc/special_roles_panel(mob/user)
	var/html = "<div align='center'>"
	html += "<b>Special Roles</b>"
	html += "<hr>"

	// Once this is fixed, remove the <s> and </s> to un-strikethrough it.
	html += "<s><b>Uplink Type:</b> <a href='byond://?src=\ref[user];preference=specialroles;antagtask=uplinktype;active=1'><b>[uplinklocation]</b></a></s>"
	html += "<br>"
	html += "<br>"

	if(jobban_isbanned(user, "Syndicate"))
		html += "<b>You are banned from antagonist roles.</b>"
		be_special = 0
	else
		var/n = 0
		for(var/i in GLOBL.special_roles)
			if(GLOBL.special_roles[i]) //if mode is available on the server
				if(jobban_isbanned(user, i))
					html += "<b>Be [i]:</b> <font color=red><b> \[BANNED]</b></font><br>"
				else if(i == "pai candidate")
					if(jobban_isbanned(user, "pAI"))
						html += "<b>Be [i]:</b> <font color=red><b> \[BANNED]</b></font><br>"
				else
					html += "<b>Be [i]:</b> <a href='byond://?_src_=prefs;preference=be_special;num=[n]'><b>[be_special & (1 << n) ? "Yes" : "No"]</b></a><br>"
			n++

	html += "<hr>"
	html += "<a href='byond://?src=\ref[user];preference=specialroles;antagtask=done;active=1'>\[Done\]</a>"
	html += "</div>"

	var/datum/browser/panel = new /datum/browser(user, "specialroles", "", 300, 380)
	panel.set_content(html)
	panel.open()

/datum/preferences/proc/process_special_roles_panel(mob/user, list/href_list)
	if(text2num(href_list["active"]) == 0)
		special_roles_panel(user)
		return

	if(href_list["antagtask"] == "uplinktype")
		if(uplinklocation == "PDA")
			uplinklocation = "Headset"
		else if(uplinklocation == "Headset")
			uplinklocation = "None"
		else
			uplinklocation = "PDA"
		special_roles_panel(user)

	else if(href_list["antagtask"] == "done")
		user << browse(null, "window=specialroles")
		character_setup_panel(user)

	return 1