/*
 * Job Preferences
 * (Job-related preference procs.)
 */
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
		CLOSE_BROWSER(user, "window=mob_occupation")
		return

	if(role == "Assistant")
		if(job_by_department_low[/decl/department/civilian] & job.flag)
			job_by_department_low[/decl/department/civilian] &= ~job.flag
		else
			job_by_department_low[/decl/department/civilian] |= job.flag
		occupation_choices_panel(user)
		return

	if(GetJobDepartment(job, 1) & job.flag)
		SetJobDepartment(job, 1)
	else if(GetJobDepartment(job, 2) & job.flag)
		SetJobDepartment(job, 2)
	else if(GetJobDepartment(job, 3) & job.flag)
		SetJobDepartment(job, 3)
	else//job = Never
		SetJobDepartment(job, 4)

	occupation_choices_panel(user)

/datum/preferences/proc/ResetJobs()
	for(var/path in SUBTYPESOF(/decl/department))
		job_by_department_high[path] = 0
		job_by_department_med[path] = 0
		job_by_department_low[path] = 0

/datum/preferences/proc/GetJobDepartment(datum/job/job, level)
	if(isnull(job) || !level)
		return 0

	switch(level)
		if(1)
			return job_by_department_high[job.department]
		if(2)
			return job_by_department_med[job.department]
		if(3)
			return job_by_department_low[job.department]

	return 0

/datum/preferences/proc/SetJobDepartment(datum/job/job, level)
	if(isnull(job) || !level)
		return

	switch(level)
		if(1) // Only one of these should ever be active at once so clear them all here.
			for(var/path in SUBTYPESOF(/decl/department))
				job_by_department_high[path] = 0
			return
		if(2) // Set current highs to med, then reset them.
			for(var/path in SUBTYPESOF(/decl/department))
				job_by_department_med[path] = job_by_department_high[path]
				job_by_department_high[path] = 0

	var/department = job.department
	var/flag = job.flag
	switch(level)
		if(2)
			job_by_department_high[department] = flag
			job_by_department_med[department] &= ~flag
		if(3)
			job_by_department_med[department] |= flag
			job_by_department_low[department] &= ~flag
		else
			job_by_department_low[department] |= flag