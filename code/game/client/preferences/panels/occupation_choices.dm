/*
 * occupation_choices_panel()
 *
 * mob/user - The user to display the panel to.
 * limit - The amount of jobs allowed per column. Defaults to 20 to make it look nice.
 * list/splitJobs - Allows you split the table by job. You can make different tables for each department by including their heads. Defaults to CE to make it look nice.
 */
/datum/preferences/proc/occupation_choices_panel(mob/user, limit = 20, list/splitJobs = list("Chief Engineer"))
	if(isnull(global.CTjobs))
		return

	var/dat = occupation_choices_header(user)

	dat += "<div align='center'>"
	dat += "<table width='100%' cellpadding='1' cellspacing='0'><tr><td width='20%'>" // Table within a table for alignment, also allows you to easily add more colomns.
	dat += "<table width='100%' cellpadding='1' cellspacing='0'>"
	var/index = -1

	// The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.
	var/datum/job/lastJob
	for_no_type_check(var/datum/job/job, global.CTjobs.occupations)
		index += 1
		if(index >= limit || (job.title in splitJobs))
			if(index < limit && isnotnull(lastJob))
				//If the cells were broken up by a job in the splitJob list then it will fill in the rest of the cells with
				// the last job's selection color. Creating a rather nice effect.
				for(var/i = 0, i < (limit - index), i += 1)
					dat += "<tr bgcolor='[lastJob.selection_color]'><td width='60%' align='right'>&nbsp</td><td>&nbsp</td></tr>"
			dat += "</table></td><td width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
			index = 0

		dat += "<tr bgcolor='[job.selection_color]'><td width='60%' align='right'>"
		lastJob = job
		if(jobban_isbanned(user, job.title))
			dat += "<font color='black'><s>[job.title]</s></font></td><td><b> \[BANNED]</b></td></tr>"
			continue
		if(!job.player_old_enough(user.client))
			dat += "<font color='black'><s>[job.title]</s></font></td><td> \[IN [job.available_in_days(user.client)] DAYS]</td></tr>"
			continue
		if((job_by_department_low[/decl/department/civilian] & JOB_ASSISTANT) && job.title != "Assistant")
			dat += "<font color='orange'>[job.title]</font></td><td></td></tr>"
			continue

		var/should_be_bold = (job.head_position || job.title == "AI") // Bold head jobs and AI.
		if(job.alt_titles)
			var/formatted_title = should_be_bold ? "<b>[GetPlayerAltTitle(job)]</b>" : GetPlayerAltTitle(job)
			dat += "<a href='byond://?src=\ref[user];preference=job;task=alt_title;job=\ref[job]'>[formatted_title]</a>"
		else
			dat += should_be_bold ? "<font color='black'><b>[job.title]</b></font>" : "<font color='black'>[job.title]</font>"
		dat += "</td><td width='40%'>"

		dat += "<a href='byond://?_src_=prefs;preference=job;task=input;text=[job.title]'>"
		if(job.title == "Assistant") // Assistant is special.
			if(job_by_department_low[/decl/department/civilian] & JOB_ASSISTANT)
				dat += " <font color=green>\[Yes]</font>"
			else
				dat += " <font color=red>\[No]</font>"
			dat += "</a></td></tr>"
			continue

		if(GetJobDepartment(job, 1) & job.flag)
			dat += " <font color=blue>\[High]</font>"
		else if(GetJobDepartment(job, 2) & job.flag)
			dat += " <font color=green>\[Medium]</font>"
		else if(GetJobDepartment(job, 3) & job.flag)
			dat += " <font color=orange>\[Low]</font>"
		else
			dat += " <font color=red>\[NEVER]</font>"
		dat += "</a></td></tr>"

	dat += "</td'></tr></table>"

	dat += "</table>"
	dat += "</div>"

	dat += occupation_choices_footer(user)

	var/datum/browser/panel = new /datum/browser(user, "mob_occupation", "", 680, 600)
	panel.set_content(dat)
	panel.open()

/datum/preferences/proc/occupation_choices_header(mob/user)
	. += "<div align='center'>"

	. += "<b>Choose occupation chances</b>"
	. += "<br>"
	. += "Unavailable occupations are crossed out."
	. += "<hr>"

	. += "</div>"

/datum/preferences/proc/occupation_choices_footer(mob/user)
	. += "<div align='center'>"

	. += "<hr>"
	. += "<b>If Preference Unavailable:</b> "
	switch(alternate_option)
		if(GET_RANDOM_JOB)
			. += "<a href='byond://?_src_=prefs;preference=job;task=random'><font color=green>Get Random Job</font></a>"
		if(BE_ASSISTANT)
			. += "<a href='byond://?_src_=prefs;preference=job;task=random'><font color=red>Be Assistant</font></a>"
		if(RETURN_TO_LOBBY)
			. += "<a href='byond://?_src_=prefs;preference=job;task=random'><font color=purple>Return To Lobby</font></a>"
	. += "<br>"

	. += "<a href='byond://?_src_=prefs;preference=job;task=reset'>\[Reset\]</a> - "
	. += "<a href='byond://?_src_=prefs;preference=job;task=close'>\[Done\]</a>"

	. += "</div>"

/datum/preferences/proc/process_occupation_choices_panel(mob/user, datum/topic_input/topic)
	switch(topic.get("task"))
		if("close")
			CLOSE_BROWSER(user, "window=mob_occupation")
			return

		if("reset")
			ResetJobs()
		if("input")
			SetJob(user, topic.get("text"))
		if("random")
			if(alternate_option == GET_RANDOM_JOB || alternate_option == BE_ASSISTANT)
				alternate_option += 1
			else if(alternate_option == RETURN_TO_LOBBY)
				alternate_option = 0
		if("alt_title")
			var/datum/job/job = topic.get_and_locate("job")
			if(isnotnull(job))
				var/choices = list(job.title) + job.alt_titles
				var/choice = input("Pick a title for [job.title].", "Character Generation", GetPlayerAltTitle(job)) as anything in choices | null
				if(choice)
					SetPlayerAltTitle(job, choice)

	occupation_choices_panel(user) // Refreshes the panel so things update.
	return 1