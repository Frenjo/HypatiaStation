/*
 * Assistant
 */
/datum/job/assistant
	title = "Assistant"
	flag = JOB_ASSISTANT
	department = /decl/department/civilian

	total_positions = -1
	spawn_positions = -1

	supervisors = "absolutely everyone"
	selection_color = "#dddddd"

	outfit = /decl/hierarchy/outfit/job/assistant
	// Added Visitor as alt title for assistant. -Frenjo
	alt_titles = list("Technical Assistant", "Medical Intern", "Research Assistant", "Security Cadet", "Visitor")

/datum/job/assistant/get_access()
	return CONFIG_GET(/decl/configuration_entry/assistant_maint) ? list(ACCESS_MAINT_TUNNELS) : list()