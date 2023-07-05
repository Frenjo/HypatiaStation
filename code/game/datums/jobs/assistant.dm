/*
 * Assistant
 */
/datum/job/assistant
	title = "Assistant"
	flag = JOB_ASSISTANT
	department_flag = DEPARTMENT_CIVILIAN
	faction = "Station"

	total_positions = -1
	spawn_positions = -1

	supervisors = "absolutely everyone"
	selection_color = "#dddddd"

	// Added Visitor as alt title for assistant. -Frenjo
	alt_titles = list("Technical Assistant", "Medical Intern", "Research Assistant", "Security Cadet", "Visitor")

/datum/job/assistant/equip(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/color/grey(H), SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), SLOT_ID_SHOES)

	return 1

/datum/job/assistant/get_access()
	return CONFIG_GET(assistant_maint) ? list(ACCESS_MAINT_TUNNELS) : list()