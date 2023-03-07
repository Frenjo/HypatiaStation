/*
 * Research Director
 */
/datum/job/rd
	title = "Research Director"
	flag = JOB_RD
	department_flag = DEPARTMENT_MEDSCI
	faction = "Station"

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Captain"
	selection_color = "#ffddff"

	idtype = /obj/item/weapon/card/id/silver
	req_admin_notify = TRUE
	minimal_player_age = 7

	access = list(
		ACCESS_RD, ACCESS_HEADS, ACCESS_TOX, ACCESS_GENETICS, ACCESS_MORGUE,
		ACCESS_TOX_STORAGE, ACCESS_TELEPORTER, ACCESS_SEC_DOORS,
		ACCESS_RESEARCH, ACCESS_ROBOTICS, ACCESS_XENOBIOLOGY, ACCESS_AI_UPLOAD,
		ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_TCOMSAT, ACCESS_GATEWAY, ACCESS_XENOARCH
	)
	minimal_access = list(
		ACCESS_RD, ACCESS_HEADS, ACCESS_TOX, ACCESS_GENETICS, ACCESS_MORGUE,
		ACCESS_TOX_STORAGE, ACCESS_TELEPORTER, ACCESS_SEC_DOORS,
		ACCESS_RESEARCH, ACCESS_ROBOTICS, ACCESS_XENOBIOLOGY, ACCESS_AI_UPLOAD,
		ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_TCOMSAT, ACCESS_GATEWAY, ACCESS_XENOARCH
	)

/datum/job/rd/equip(mob/living/carbon/human/H)
	if(isnull(H))
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/rd(H), SLOT_ID_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/research_director(H), SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/device/pda/heads/rd(H), SLOT_ID_BELT)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(H), SLOT_ID_WEAR_SUIT)
	H.equip_to_slot_or_del(new /obj/item/weapon/clipboard(H), SLOT_ID_L_HAND)

	if(H.backbag == 3)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/tox(H), SLOT_ID_BACK)
	else if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), SLOT_ID_R_HAND)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), SLOT_ID_IN_BACKPACK)

	return 1

/*
 * Scientist
 */
/datum/job/scientist
	title = "Scientist"
	flag = JOB_SCIENTIST
	department_flag = DEPARTMENT_MEDSCI
	faction = "Station"

	total_positions = 5
	spawn_positions = 3

	supervisors = "the Research Director"
	selection_color = "#ffeeff"

	access = list(ACCESS_ROBOTICS, ACCESS_TOX, ACCESS_TOX_STORAGE, ACCESS_RESEARCH, ACCESS_XENOBIOLOGY, ACCESS_XENOARCH)
	minimal_access = list(ACCESS_TOX, ACCESS_TOX_STORAGE, ACCESS_RESEARCH, ACCESS_XENOARCH)

	alt_titles = list("Researcher", "Xenoarcheologist", "Anomalist", "Plasma Researcher")

/datum/job/scientist/equip(mob/living/carbon/human/H)
	if(isnull(H))
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sci(H), SLOT_ID_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist(H), SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/device/pda/toxins(H), SLOT_ID_BELT)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/science(H), SLOT_ID_WEAR_SUIT)

	if(H.backbag == 3)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/tox(H), SLOT_ID_BACK)
	else if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), SLOT_ID_R_HAND)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), SLOT_ID_IN_BACKPACK)

	return 1

/*
 * Xenobiologist
 */
/datum/job/xenobiologist
	title = "Xenobiologist"
	flag = JOB_XENOBIOLOGIST
	department_flag = DEPARTMENT_MEDSCI
	faction = "Station"

	total_positions = 2
	spawn_positions = 2

	supervisors = "the Research Director"
	selection_color = "#ffeeff"

	access = list(ACCESS_ROBOTICS, ACCESS_TOX, ACCESS_TOX_STORAGE, ACCESS_RESEARCH, ACCESS_XENOBIOLOGY)
	minimal_access = list(ACCESS_RESEARCH, ACCESS_XENOBIOLOGY)

/datum/job/xenobiologist/equip(mob/living/carbon/human/H)
	if(isnull(H))
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sci(H), SLOT_ID_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist(H), SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/device/pda/toxins(H), SLOT_ID_BELT)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/science(H), SLOT_ID_WEAR_SUIT)

	if(H.backbag == 3)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/tox(H), SLOT_ID_BACK)
	else if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), SLOT_ID_R_HAND)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), SLOT_ID_IN_BACKPACK)

	return 1

/*
 * Roboticist
 */
/datum/job/roboticist
	title = "Roboticist"
	flag = JOB_ROBOTICIST
	department_flag = DEPARTMENT_MEDSCI
	faction = "Station"

	total_positions = 2
	spawn_positions = 2

	supervisors = "the Research Director"
	selection_color = "#ffeeff"

	// As a job that handles so many corpses, it makes sense for them to have morgue access.
	access = list(ACCESS_ROBOTICS, ACCESS_TOX, ACCESS_TOX_STORAGE, ACCESS_TECH_STORAGE, ACCESS_MORGUE, ACCESS_RESEARCH)
	minimal_access = list(ACCESS_ROBOTICS, ACCESS_TECH_STORAGE, ACCESS_MORGUE, ACCESS_RESEARCH)

	alt_titles = list("Biomechanical Engineer", "Mechatronic Engineer")

/datum/job/roboticist/equip(mob/living/carbon/human/H)
	if(isnull(H))
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_rob(H), SLOT_ID_L_EAR)
	if(H.backbag == 2)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), SLOT_ID_BACK)
	if(H.backbag == 3)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/norm(H), SLOT_ID_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/roboticist(H), SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/device/pda/roboticist(H), SLOT_ID_BELT)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(H), SLOT_ID_WEAR_SUIT)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), SLOT_ID_GLOVES)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/toolbox/mechanical(H), SLOT_ID_L_HAND)

	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), SLOT_ID_R_HAND)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), SLOT_ID_IN_BACKPACK)

	return 1