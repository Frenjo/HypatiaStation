/proc/guest_jobbans(job)
	return ((job in GLOBL.command_positions) || (job in GLOBL.nonhuman_positions) || (job in GLOBL.security_positions))

/proc/get_job_datums()
	RETURN_TYPE(/list/datum/job)

	var/list/occupations = list()

	for(var/job_name in GLOBL.all_jobs)
		var/datum/job/job = GLOBL.all_jobs[job_name]
		if(isnull(job))
			continue
		occupations.Add(job)

	return occupations

/proc/get_alternate_titles(job)
	RETURN_TYPE(/list)

	var/list/titles = list()

	for_no_type_check(var/datum/job/J, get_job_datums())
		if(isnull(J))
			continue
		if(J.title == job)
			titles = J.alt_titles

	return titles

/proc/get_all_job_icons() //For all existing HUD icons
	RETURN_TYPE(/list)

	return GLOBL.all_jobs + list("Prisoner")