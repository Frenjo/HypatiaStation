/*
 * Job Preferences
 * (Job-related preference procs.)
 */
/datum/preferences/proc/SetChoices(mob/user, limit = 17, list/splitJobs = list("Chief Medical Officer"), width = 550, height = 550)
	if(isnull(global.CTjobs))
		return

	//limit		- The amount of jobs allowed per column. Defaults to 17 to make it look nice.
	//splitJobs	- Allows you split the table by job. You can make different tables for each department by including their heads. Defaults to CE to make it look nice.
	//width		- Screen' width. Defaults to 550 to make it look nice.
	//height	- Screen's height. Defaults to 500 to make it look nice.

	var/dat = "<body>"
	dat += "<tt><center>"
	dat += "<b>Choose occupation chances</b><br>Unavailable occupations are crossed out.<br><br>"
	dat += "<center><a href='?_src_=prefs;preference=job;task=close'>\[Done\]</a></center><br>" // Easier to press up here.
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
					dat += "<tr bgcolor='[lastJob.selection_color]'><td width='60%' align='right'><a>&nbsp</a></td><td><a>&nbsp</a></td></tr>"
			dat += "</table></td><td width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
			index = 0

		dat += "<tr bgcolor='[job.selection_color]'><td width='60%' align='right'>"
		var/rank = job.title
		lastJob = job
		if(jobban_isbanned(user, rank))
			dat += "<del>[rank]</del></td><td><b> \[BANNED]</b></td></tr>"
			continue
		if(!job.player_old_enough(user.client))
			var/available_in_days = job.available_in_days(user.client)
			dat += "<del>[rank]</del></td><td> \[IN [(available_in_days)] DAYS]</td></tr>"
			continue
		if((job_civilian_low & JOB_ASSISTANT) && rank != "Assistant")
			dat += "<font color=orange>[rank]</font></td><td></td></tr>"
			continue
		if((rank in GLOBL.command_positions) || rank == "AI") // Bold head jobs and AI.
			dat += "<b>[rank]</b>"
		else
			dat += "[rank]"

		dat += "</td><td width='40%'>"

		dat += "<a href='?_src_=prefs;preference=job;task=input;text=[rank]'>"

		if(rank == "Assistant") // Assistant is special.
			if(job_civilian_low & JOB_ASSISTANT)
				dat += " <font color=green>\[Yes]</font>"
			else
				dat += " <font color=red>\[No]</font>"
			if(job.alt_titles)
				dat += "</a></td></tr><tr bgcolor='[lastJob.selection_color]'><td width='60%' align='center'><a>&nbsp</a></td><td><a href=\"byond://?src=\ref[user];preference=job;task=alt_title;job=\ref[job]\">\[[GetPlayerAltTitle(job)]\]</a></td></tr>"
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
		if(job.alt_titles)
			dat += "</a></td></tr><tr bgcolor='[lastJob.selection_color]'><td width='60%' align='center'><a>&nbsp</a></td><td><a href=\"byond://?src=\ref[user];preference=job;task=alt_title;job=\ref[job]\">\[[GetPlayerAltTitle(job)]\]</a></td></tr>"
		dat += "</a></td></tr>"

	dat += "</td'></tr></table>"

	dat += "</center></table>"

	switch(alternate_option)
		if(GET_RANDOM_JOB)
			dat += "<center><br><u><a href='?_src_=prefs;preference=job;task=random'><font color=green>Get random job if preferences unavailable</font></a></u></center><br>"
		if(BE_ASSISTANT)
			dat += "<center><br><u><a href='?_src_=prefs;preference=job;task=random'><font color=red>Be assistant if preference unavailable</font></a></u></center><br>"
		if(RETURN_TO_LOBBY)
			dat += "<center><br><u><a href='?_src_=prefs;preference=job;task=random'><font color=purple>Return to lobby if preference unavailable</font></a></u></center><br>"

	dat += "<center><a href='?_src_=prefs;preference=job;task=reset'>\[Reset\]</a></center>"
	dat += "</tt>"

	user << browse(null, "window=preferences")
	user << browse(dat, "window=mob_occupation;size=[width]x[height]")

/datum/preferences/proc/GetPlayerAltTitle(datum/job/job)
	return player_alt_titles.Find(job.title) > 0 ? player_alt_titles[job.title] : job.title

/datum/preferences/proc/SetPlayerAltTitle(datum/job/job, new_title)
	// Remove existing entry.
	if(player_alt_titles.Find(job.title))
		player_alt_titles.Remove(job.title)
	// Add one if it's not default.
	if(job.title != new_title)
		player_alt_titles[job.title] = new_title

/datum/preferences/proc/SetJob(mob/user, role)
	var/datum/job/job = global.CTjobs.get_job(role)
	if(isnull(job))
		user << browse(null, "window=mob_occupation")
		ShowChoices(user)
		return

	if(role == "Assistant")
		if(job_civilian_low & job.flag)
			job_civilian_low &= ~job.flag
		else
			job_civilian_low |= job.flag
		SetChoices(user)
		return

	if(GetJobDepartment(job, 1) & job.flag)
		SetJobDepartment(job, 1)
	else if(GetJobDepartment(job, 2) & job.flag)
		SetJobDepartment(job, 2)
	else if(GetJobDepartment(job, 3) & job.flag)
		SetJobDepartment(job, 3)
	else//job = Never
		SetJobDepartment(job, 4)

	SetChoices(user)

/datum/preferences/proc/ResetJobs()
	job_civilian_high = 0
	job_civilian_med = 0
	job_civilian_low = 0

	job_medsci_high = 0
	job_medsci_med = 0
	job_medsci_low = 0

	job_engsec_high = 0
	job_engsec_med = 0
	job_engsec_low = 0

/datum/preferences/proc/GetJobDepartment(datum/job/job, level)
	if(isnull(job) || !level)
		return 0

	switch(job.department_flag)
		if(DEPARTMENT_CIVILIAN)
			switch(level)
				if(1)
					return job_civilian_high
				if(2)
					return job_civilian_med
				if(3)
					return job_civilian_low
		if(DEPARTMENT_MEDSCI)
			switch(level)
				if(1)
					return job_medsci_high
				if(2)
					return job_medsci_med
				if(3)
					return job_medsci_low
		if(DEPARTMENT_ENGSEC)
			switch(level)
				if(1)
					return job_engsec_high
				if(2)
					return job_engsec_med
				if(3)
					return job_engsec_low
	return 0

/datum/preferences/proc/SetJobDepartment(datum/job/job, level)
	if(isnull(job) || !level)
		return

	switch(level)
		if(1) // Only one of these should ever be active at once so clear them all here.
			job_civilian_high = 0
			job_medsci_high = 0
			job_engsec_high = 0
			return
		if(2) // Set current highs to med, then reset them.
			job_civilian_med |= job_civilian_high
			job_medsci_med |= job_medsci_high
			job_engsec_med |= job_engsec_high
			job_civilian_high = 0
			job_medsci_high = 0
			job_engsec_high = 0

	switch(job.department_flag)
		if(DEPARTMENT_CIVILIAN)
			switch(level)
				if(2)
					job_civilian_high = job.flag
					job_civilian_med &= ~job.flag
				if(3)
					job_civilian_med |= job.flag
					job_civilian_low &= ~job.flag
				else
					job_civilian_low |= job.flag
		if(DEPARTMENT_MEDSCI)
			switch(level)
				if(2)
					job_medsci_high = job.flag
					job_medsci_med &= ~job.flag
				if(3)
					job_medsci_med |= job.flag
					job_medsci_low &= ~job.flag
				else
					job_medsci_low |= job.flag
		if(DEPARTMENT_ENGSEC)
			switch(level)
				if(2)
					job_engsec_high = job.flag
					job_engsec_med &= ~job.flag
				if(3)
					job_engsec_med |= job.flag
					job_engsec_low &= ~job.flag
				else
					job_engsec_low |= job.flag