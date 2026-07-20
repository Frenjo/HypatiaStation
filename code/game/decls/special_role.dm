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

/decl/special_role/proc/setup(mob/living/specialist)
	SHOULD_CALL_PARENT(TRUE)

	specialist.mind_initialize()
	specialist.mind.assign_special_role(role_type)
	BITSET(specialist.hud_updateflag, SPECIALROLE_HUD)
	return TRUE

/decl/special_role/proc/show_objectives(mob/living/specialist)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(CONFIG_GET(/decl/configuration_entry/objectives_disabled))
		FEEDBACK_ANTAGONIST_GREETING_GUIDE(specialist)
		return

	var/obj_count = 1
	for_no_type_check(var/datum/objective/objective, specialist.mind.objectives)
		to_chat(specialist, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
		obj_count++