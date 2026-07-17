/decl/special_role/traitor
	name = "Traitor"

	role_type = SPECIAL_ROLE_TRAITOR
	role_flag = BE_TRAITOR

	restricted_jobs = list(/datum/job/robot) // They are part of the AI if he is traitor so are they, they use to get double chances
	protected_jobs = list(
		/datum/job/officer, /datum/job/warden, /datum/job/detective,
		/datum/job/hos, /datum/job/captain
	) // AI is currently out of the list as malf does not work for shit.