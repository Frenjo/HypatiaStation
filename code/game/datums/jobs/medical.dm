/*
 * Chief Medical Officer
 */
/datum/job/cmo
	title = "Chief Medical Officer"
	flag = JOB_CMO
	department_flag = DEPARTMENT_MEDSCI

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Captain"
	selection_color = "#ffddf0"

	req_admin_notify = TRUE
	minimal_player_age = 10

	access = list(
		ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_GENETICS, ACCESS_BRIDGE,
		ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_CMO, ACCESS_SURGERY,
		ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_SEC_DOORS, ACCESS_PSYCHIATRIST
	)

	outfit = /decl/hierarchy/outfit/job/medical/cmo
	alt_titles = list("Medical Director")

/*
 * Medical Doctor
 */
/datum/job/doctor
	title = "Medical Doctor"
	flag = JOB_DOCTOR
	department_flag = DEPARTMENT_MEDSCI

	total_positions = 5
	spawn_positions = 3

	supervisors = "the Chief Medical Officer"
	selection_color = "#ffeef0"

	access = list(
		ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_CHEMISTRY,
		ACCESS_VIROLOGY, ACCESS_GENETICS
	)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_VIROLOGY)

	outfit = /decl/hierarchy/outfit/job/medical/doctor
	alt_titles = list(
		"Surgeon" = /decl/hierarchy/outfit/job/medical/doctor/surgeon,
		"Emergency Physician" = /decl/hierarchy/outfit/job/medical/doctor/physician,
		"Nurse" = /decl/hierarchy/outfit/job/medical/doctor/nurse
	)

/*
 * Chemist
 */
// Chemist is a medical job damnit.	//YEAH FUCK YOU SCIENCE	-Pete	//Guys, behave -Erro
/datum/job/chemist
	title = "Chemist"
	flag = JOB_CHEMIST
	department_flag = DEPARTMENT_MEDSCI

	total_positions = 2
	spawn_positions = 2

	supervisors = "the Chief Medical Officer"
	selection_color = "#ffeef0"

	access = list(
		ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_CHEMISTRY,
		ACCESS_VIROLOGY, ACCESS_GENETICS
	)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_CHEMISTRY)

	outfit = /decl/hierarchy/outfit/job/medical/chemist
	alt_titles = list("Pharmacist")

/*
 * Geneticist
 */
/datum/job/geneticist
	title = "Geneticist"
	flag = JOB_GENETICIST
	department_flag = DEPARTMENT_MEDSCI

	total_positions = 2
	spawn_positions = 2

	supervisors = "the Chief Medical Officer and the Research Director"
	selection_color = "#ffeef0"

	access = list(
		ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_CHEMISTRY,
		ACCESS_VIROLOGY, ACCESS_GENETICS, ACCESS_RESEARCH
	)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_GENETICS, ACCESS_RESEARCH)

	outfit = /decl/hierarchy/outfit/job/medsci/geneticist

/*
 * Virologist
 */
/datum/job/virologist
	title = "Virologist"
	flag = JOB_VIROLOGIST
	department_flag = DEPARTMENT_MEDSCI

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Chief Medical Officer"
	selection_color = "#ffeef0"

	access = list(
		ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_CHEMISTRY,
		ACCESS_VIROLOGY, ACCESS_GENETICS
	)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_VIROLOGY)

	outfit = /decl/hierarchy/outfit/job/medical/virologist
	alt_titles = list("Pathologist", "Microbiologist")

/*
 * Psychiatrist
 */
/datum/job/psychiatrist
	title = "Psychiatrist"
	flag = JOB_PSYCHIATRIST
	department_flag = DEPARTMENT_MEDSCI

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Chief Medical Officer"
	selection_color = "#ffeef0"

	access = list(
		ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_CHEMISTRY,
		ACCESS_VIROLOGY, ACCESS_GENETICS, ACCESS_PSYCHIATRIST
	)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_PSYCHIATRIST)

	outfit = /decl/hierarchy/outfit/job/medical/psychiatrist
	alt_titles = list("Psychologist")