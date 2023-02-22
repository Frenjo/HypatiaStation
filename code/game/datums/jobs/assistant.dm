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
	if(!H)
		return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/under/color/grey(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)

	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
	return 1

/datum/job/assistant/get_access()
	if(CONFIG_GET(assistant_maint))
		return list(ACCESS_MAINT_TUNNELS)
	else
		return list()