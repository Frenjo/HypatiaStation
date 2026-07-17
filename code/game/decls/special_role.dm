/decl/special_role
	var/name

	var/role_type
	var/role_flag

	// Jobs that can't be this special role at roundstart.
	var/list/restricted_jobs = list()
	var/list/protected_jobs = list()

/decl/special_role/New()
	. = ..()
	if(CONFIG_GET(/decl/configuration_entry/protect_roles_from_antagonist))
		restricted_jobs |= protected_jobs

// Removes candidates who want to be antagonist but have a job that precludes it.
/decl/special_role/proc/get_candidates(list/datum/mind/candidates)
	RETURN_TYPE(/list/datum/mind)

	. = list()
	if(isemptylist(restricted_jobs))
		return .

	for_no_type_check(var/datum/mind/candidate, candidates)
		for(var/datum/job/job_type in restricted_jobs)
			if(!istype(candidate.assigned_job, job_type))
				. += candidate