/*
 * AI
 */
/datum/job/ai
	title = "AI"
	flag = JOB_AI
	department_flag = DEPARTMENT_ENGSEC
	faction = "Station"

	total_positions = 0
	spawn_positions = 1

	supervisors = "your laws"
	selection_color = "#ccffcc"

	req_admin_notify = TRUE
	minimal_player_age = 7

/*
 * Cyborg
 */
/datum/job/cyborg
	title = "Cyborg"
	flag = JOB_CYBORG
	department_flag = DEPARTMENT_ENGSEC
	faction = "Station"

	total_positions = 0
	spawn_positions = 2

	supervisors = "your laws and the AI"	//Nodrak
	selection_color = "#ddffdd"

	minimal_player_age = 1

	alt_titles = list("Android", "Robot", "Drone")