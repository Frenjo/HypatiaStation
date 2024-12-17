/*
 * AI
 */
/datum/job/ai
	title = "AI"
	flag = JOB_AI

	department = /decl/department/engsec

	total_positions = 0
	spawn_positions = 1

	supervisors = "your laws"
	selection_color = "#ccffcc"

	req_admin_notify = TRUE
	minimal_player_age = 7

/datum/job/ai/equip_preview(mob/living/carbon/human/H, alt_title)
	H.set_species(SPECIES_HUMAN)
	H.equip_outfit(/decl/hierarchy/outfit/job/assistant)
	H.equip_to_slot(new /obj/item/clothing/head/cardborg(H), SLOT_ID_HEAD)
	H.equip_to_slot(new /obj/item/clothing/suit/straight_jacket(H), SLOT_ID_WEAR_SUIT)
	return TRUE

/*
 * Cyborg
 */
/datum/job/cyborg
	title = "Cyborg"
	flag = JOB_CYBORG

	department = /decl/department/engsec

	total_positions = 0
	spawn_positions = 2

	supervisors = "your laws and the AI"	//Nodrak
	selection_color = "#ddffdd"

	minimal_player_age = 1

	alt_titles = list("Android", "Robot", "Drone")

/datum/job/cyborg/equip_preview(mob/living/carbon/human/H, alt_title)
	H.set_species(SPECIES_HUMAN)
	H.equip_outfit(/decl/hierarchy/outfit/job/assistant)
	H.equip_to_slot(new /obj/item/clothing/head/cardborg(H), SLOT_ID_HEAD)
	H.equip_to_slot(new /obj/item/clothing/suit/cardborg(H), SLOT_ID_WEAR_SUIT)
	return TRUE