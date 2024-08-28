/datum/preferences/proc/set_skills_panel(mob/user)
	if(!length(skills))
		ZeroSkills()

	var/html = "<b>Select your Skills</b><br>"
	html += "Current skill level: <b>[GetSkillClass(used_skillpoints)]</b> ([used_skillpoints])<br>"
	html += "<a href=\"byond://?src=\ref[user];preference=skills;preconfigured=1;\">Use preconfigured skillset</a><br>"
	html += "<hr>"

	html += "<table>"
	for(var/V in GLOBL.all_skills)
		html += "<tr><th colspan = 5><b>[V]</b>"
		html += "</th></tr>"
		for(var/datum/skill/S in GLOBL.all_skills[V])
			var/level = skills[S.id]
			html += "<tr style='text-align:left;'>"
			html += "<th><a href='byond://?src=\ref[user];preference=skills;skillinfo=\ref[S]'>[S.name]</a></th>"
			html += "<th><a href='byond://?src=\ref[user];preference=skills;setskill=\ref[S];newvalue=[SKILL_NONE]'><font color=[(level == SKILL_NONE) ? "red" : "white"]>\[Untrained\]</font></a></th>"
			// secondary skills don't have an amateur level
			if(S.secondary)
				html += "<th></th>"
			else
				html += "<th><a href='byond://?src=\ref[user];preference=skills;setskill=\ref[S];newvalue=[SKILL_BASIC]'><font color=[(level == SKILL_BASIC) ? "red" : "white"]>\[Amateur\]</font></a></th>"
			html += "<th><a href='byond://?src=\ref[user];preference=skills;setskill=\ref[S];newvalue=[SKILL_ADEPT]'><font color=[(level == SKILL_ADEPT) ? "red" : "white"]>\[Trained\]</font></a></th>"
			html += "<th><a href='byond://?src=\ref[user];preference=skills;setskill=\ref[S];newvalue=[SKILL_EXPERT]'><font color=[(level == SKILL_EXPERT) ? "red" : "white"]>\[Professional\]</font></a></th>"
			html += "</tr>"
	html += "</table>"

	html += "<hr>"
	html += "<a href=\"byond://?src=\ref[user];preference=skills;cancel=1;\">\[Done\]</a>"

	var/datum/browser/panel = new /datum/browser(user, "show_skills", "", 600, 760)
	panel.set_content(html)
	panel.open()

/datum/preferences/proc/process_set_skills_panel(mob/user, list/href_list)
	if(href_list["cancel"])
		user << browse(null, "window=show_skills")
		character_setup_panel(user)

	else if(href_list["skillinfo"])
		var/datum/skill/S = locate(href_list["skillinfo"])
		var/HTML = "<b>[S.name]</b><br>[S.desc]"
		user << browse(HTML, "window=\ref[user]skillinfo")

	else if(href_list["setskill"])
		var/datum/skill/S = locate(href_list["setskill"])
		var/value = text2num(href_list["newvalue"])
		skills[S.id] = value
		CalculateSkillPoints()
		set_skills_panel(user)

	else if(href_list["preconfigured"])
		var/selected = input(user, "Select a skillset", "Skillset") as null | anything in GLOBL.skill_presets
		if(!selected)
			return
		ZeroSkills(1)
		for(var/V in GLOBL.skill_presets[selected])
			if(V == "field")
				skill_specialization = GLOBL.skill_presets[selected]["field"]
				continue
			skills[V] = GLOBL.skill_presets[selected][V]
		CalculateSkillPoints()

		set_skills_panel(user)

	else if(href_list["setspecialization"])
		skill_specialization = href_list["setspecialization"]
		CalculateSkillPoints()
		set_skills_panel(user)
	else
		set_skills_panel(user)

	return 1