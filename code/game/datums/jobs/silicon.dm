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

	selection_color = "#ccffcc"
	supervisors = "your laws"

	req_admin_notify = TRUE
	minimal_player_age = 7

/datum/job/ai/equip(mob/living/carbon/human/H)
	if(!H)
		return 0
	return 1

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

/datum/job/cyborg/equip(mob/living/carbon/human/H)
	if(!H)
		return 0
	return 1