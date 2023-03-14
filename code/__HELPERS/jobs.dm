/proc/guest_jobbans(job)
	return ((job in GLOBL.command_positions) || (job in GLOBL.nonhuman_positions) || (job in GLOBL.security_positions))

/proc/get_job_datums()
	var/list/occupations = list()

	for(var/job_name in GLOBL.all_jobs)
		var/datum/job/job = GLOBL.all_jobs[job_name]
		if(isnull(job))
			continue
		occupations.Add(job)

	return occupations

/proc/get_alternate_titles(job)
	var/list/jobs = get_job_datums()
	var/list/titles = list()

	for(var/datum/job/J in jobs)
		if(isnull(J))
			continue
		if(J.title == job)
			titles = J.alt_titles

	return titles

/proc/get_all_job_icons() //For all existing HUD icons
	return GLOBL.all_jobs + list("Prisoner")