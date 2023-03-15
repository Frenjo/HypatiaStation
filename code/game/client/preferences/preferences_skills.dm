/*
 * Skill Preferences
 * (Skill-related preference procs.)
 */
/datum/preferences/proc/ZeroSkills(forced = 0)
	for(var/V in GLOBL.all_skills)
		for(var/datum/skill/S in GLOBL.all_skills[V])
			if(!skills.Find(S.id) || forced)
				skills[S.id] = SKILL_NONE

/datum/preferences/proc/CalculateSkillPoints()
	used_skillpoints = 0
	for(var/V in GLOBL.all_skills)
		for(var/datum/skill/S in GLOBL.all_skills[V])
			var/multiplier = 1
			switch(skills[S.id])
				if(SKILL_NONE)
					used_skillpoints += 0 * multiplier
				if(SKILL_BASIC)
					used_skillpoints += 1 * multiplier
				if(SKILL_ADEPT)
					// secondary skills cost less
					if(S.secondary)
						used_skillpoints += 1 * multiplier
					else
						used_skillpoints += 3 * multiplier
				if(SKILL_EXPERT)
					// secondary skills cost less
					if(S.secondary)
						used_skillpoints += 3 * multiplier
					else
						used_skillpoints += 6 * multiplier

/datum/preferences/proc/GetSkillClass(points)
	// skill classes describe how your character compares in total points
	var/original_points = points
	points -= min(round((age - 20) / 2.5), 4) // every 2.5 years after 20, one extra skillpoint
	if(age > 30)
		points -= round((age - 30) / 5) // every 5 years after 30, one extra skillpoint
	if(original_points > 0 && points <= 0)
		points = 1
	switch(points)
		if(0)
			return "Unconfigured"
		if(1 to 3)
			return "Terrifying"
		if(4 to 6)
			return "Below Average"
		if(7 to 10)
			return "Average"
		if(11 to 14)
			return "Above Average"
		if(15 to 18)
			return "Exceptional"
		if(19 to 24)
			return "Genius"
		if(24 to 1000)
			return "God"

/datum/preferences/proc/SetSkills(mob/user)
	if(!length(skills))
		ZeroSkills()

	var/dat = "<body>"
	dat += "<b>Select your Skills</b><br>"
	dat += "Current skill level: <b>[GetSkillClass(used_skillpoints)]</b> ([used_skillpoints])<br>"
	dat += "<a href=\"byond://?src=\ref[user];preference=skills;preconfigured=1;\">Use preconfigured skillset</a><br>"
	dat += "<table>"
	for(var/V in GLOBL.all_skills)
		dat += "<tr><th colspan = 5><b>[V]</b>"
		dat += "</th></tr>"
		for(var/datum/skill/S in GLOBL.all_skills[V])
			var/level = skills[S.id]
			dat += "<tr style='text-align:left;'>"
			dat += "<th><a href='byond://?src=\ref[user];preference=skills;skillinfo=\ref[S]'>[S.name]</a></th>"
			dat += "<th><a href='byond://?src=\ref[user];preference=skills;setskill=\ref[S];newvalue=[SKILL_NONE]'><font color=[(level == SKILL_NONE) ? "red" : "black"]>\[Untrained\]</font></a></th>"
			// secondary skills don't have an amateur level
			if(S.secondary)
				dat += "<th></th>"
			else
				dat += "<th><a href='byond://?src=\ref[user];preference=skills;setskill=\ref[S];newvalue=[SKILL_BASIC]'><font color=[(level == SKILL_BASIC) ? "red" : "black"]>\[Amateur\]</font></a></th>"
			dat += "<th><a href='byond://?src=\ref[user];preference=skills;setskill=\ref[S];newvalue=[SKILL_ADEPT]'><font color=[(level == SKILL_ADEPT) ? "red" : "black"]>\[Trained\]</font></a></th>"
			dat += "<th><a href='byond://?src=\ref[user];preference=skills;setskill=\ref[S];newvalue=[SKILL_EXPERT]'><font color=[(level == SKILL_EXPERT) ? "red" : "black"]>\[Professional\]</font></a></th>"
			dat += "</tr>"
	dat += "</table>"
	dat += "<a href=\"byond://?src=\ref[user];preference=skills;cancel=1;\">\[Done\]</a>"

	user << browse(null, "window=preferences")
	user << browse(dat, "window=show_skills;size=600x800")