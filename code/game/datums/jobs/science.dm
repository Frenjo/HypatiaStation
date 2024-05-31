/*
 * Research Director
 */
/datum/job/rd
	title = "Research Director"
	flag = JOB_RD
	department_flag = DEPARTMENT_MEDSCI

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Captain"
	selection_color = "#ffddff"

	req_admin_notify = TRUE
	minimal_player_age = 7

	access = list(
		ACCESS_RD, ACCESS_BRIDGE, ACCESS_TOX, ACCESS_GENETICS,
		ACCESS_MORGUE, ACCESS_TOX_STORAGE, ACCESS_TELEPORTER, ACCESS_SEC_DOORS,
		ACCESS_RESEARCH, ACCESS_ROBOTICS, ACCESS_XENOBIOLOGY, ACCESS_AI_UPLOAD,
		ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_TCOMSAT, ACCESS_GATEWAY,
		ACCESS_XENOARCH
	)

	outfit = /decl/hierarchy/outfit/job/science/rd

/*
 * Scientist
 */
/datum/job/scientist
	title = "Scientist"
	flag = JOB_SCIENTIST
	department_flag = DEPARTMENT_MEDSCI

	total_positions = 5
	spawn_positions = 3

	supervisors = "the Research Director"
	selection_color = "#ffeeff"

	access = list(
		ACCESS_ROBOTICS, ACCESS_TOX, ACCESS_TOX_STORAGE, ACCESS_RESEARCH,
		ACCESS_XENOBIOLOGY, ACCESS_XENOARCH
	)
	minimal_access = list(ACCESS_TOX, ACCESS_TOX_STORAGE, ACCESS_RESEARCH, ACCESS_XENOARCH)

	outfit = /decl/hierarchy/outfit/job/science/scientist
	alt_titles = list("Researcher", "Xenoarcheologist", "Anomalist", "Plasma Researcher")

/*
 * Xenobiologist
 */
/datum/job/xenobiologist
	title = "Xenobiologist"
	flag = JOB_XENOBIOLOGIST
	department_flag = DEPARTMENT_MEDSCI

	total_positions = 2
	spawn_positions = 2

	supervisors = "the Research Director"
	selection_color = "#ffeeff"

	access = list(
		ACCESS_ROBOTICS, ACCESS_TOX, ACCESS_TOX_STORAGE, ACCESS_RESEARCH,
		ACCESS_XENOBIOLOGY
	)
	minimal_access = list(ACCESS_RESEARCH, ACCESS_XENOBIOLOGY)

	outfit = /decl/hierarchy/outfit/job/science/xenobiologist

/*
 * Roboticist
 */
/datum/job/roboticist
	title = "Roboticist"
	flag = JOB_ROBOTICIST
	department_flag = DEPARTMENT_MEDSCI

	total_positions = 2
	spawn_positions = 2

	supervisors = "the Research Director"
	selection_color = "#ffeeff"

	// As a job that handles so many corpses, it makes sense for them to have morgue access.
	access = list(
		ACCESS_ROBOTICS, ACCESS_TOX, ACCESS_TOX_STORAGE, ACCESS_TECH_STORAGE,
		ACCESS_MORGUE, ACCESS_RESEARCH
	)
	minimal_access = list(ACCESS_ROBOTICS, ACCESS_TECH_STORAGE, ACCESS_MORGUE, ACCESS_RESEARCH)

	outfit = /decl/hierarchy/outfit/job/science/roboticist
	alt_titles = list("Biomechanical Engineer", "Mechatronic Engineer")