/decl/special_role/changeling
	name = "Changeling"

	role_type = SPECIAL_ROLE_CHANGELING
	role_flag = BE_CHANGELING

	restricted_jobs = list(/datum/job/ai, /datum/job/robot)
	protected_jobs = list(
		/datum/job/officer, /datum/job/warden, /datum/job/detective,
		/datum/job/hos, /datum/job/captain
	)