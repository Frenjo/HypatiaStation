/datum/preferences/proc/set_skills_panel(mob/user)
	if(!length(skills))
		ZeroSkills()

	var/html = "<b>Select your Skills</b><br>"
	html += "Current skill level: <b>[calculate_skill_class(used_skillpoints, age)]</b> ([used_skillpoints])<br>"
	html += "<a href=\"byond://?src=\ref[user];preference=skills;preconfigured=1;\">Use preconfigured skillset</a><br>"
	html += "<hr>"

	html += "<table>"
	for(var/field in GLOBL.all_skills)
		html += "<tr><th colspan = 5><b>[field]</b>"
		html += "</th></tr>"
		for(var/path in GLOBL.all_skills[field])
			var/decl/hierarchy/skill/S = GET_DECL_INSTANCE(path)
			var/level = skills[S.type]
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

	var/datum/browser/panel = new /datum/browser(user, "show_skills", "", 640, 780)
	panel.set_content(html)
	panel.open()

/datum/preferences/proc/process_set_skills_panel(mob/user, list/href_list)
	if(href_list["cancel"])
		CLOSE_BROWSER(user, "window=show_skills")
		character_setup_panel(user)
		return

	if(href_list["skillinfo"])
		var/decl/hierarchy/skill/S = locate(href_list["skillinfo"])
		var/HTML = "<b>[S.name]</b><br>[S.desc]"
		SHOW_BROWSER(user, HTML, "window=\ref[user]skillinfo")

	else if(href_list["setskill"])
		var/decl/hierarchy/skill/S = locate(href_list["setskill"])
		var/value = text2num(href_list["newvalue"])
		skills[S.type] = value
		CalculateSkillPoints()

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

	else if(href_list["setspecialization"])
		skill_specialization = href_list["setspecialization"]
		CalculateSkillPoints()

	set_skills_panel(user)

	return 1