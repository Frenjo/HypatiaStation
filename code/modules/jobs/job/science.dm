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
	minimal_player_age = 7

/datum/job/rd/equip(mob/living/carbon/human/H)
	if(!H)
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/rd(H), slot_l_ear)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/research_director(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/device/pda/heads/rd(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/weapon/clipboard(H), slot_l_hand)

	if(H.backbag == 3)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/tox(H), slot_back)
	else if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)

	return 1


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
	if(!H)
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sci(H), slot_l_ear)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/device/pda/toxins(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/science(H), slot_wear_suit)

	if(H.backbag == 3)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/tox(H), slot_back)
	else if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)

	return 1


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
	if(!H)
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sci(H), slot_l_ear)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/device/pda/toxins(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/science(H), slot_wear_suit)

	if(H.backbag == 3)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/tox(H), slot_back)
	else if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)

	return 1


/datum/job/roboticist
	title = "Roboticist"
	flag = JOB_ROBOTICIST
	department_flag = DEPARTMENT_MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Research Director"
	selection_color = "#ffeeff"
	access = list(ACCESS_ROBOTICS, ACCESS_TOX, ACCESS_TOX_STORAGE, ACCESS_TECH_STORAGE, ACCESS_MORGUE, ACCESS_RESEARCH) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	minimal_access = list(ACCESS_ROBOTICS, ACCESS_TECH_STORAGE, ACCESS_MORGUE, ACCESS_RESEARCH) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	alt_titles = list("Biomechanical Engineer", "Mechatronic Engineer")

/datum/job/roboticist/equip(mob/living/carbon/human/H)
	if(!H)
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_rob(H), slot_l_ear)
	if(H.backbag == 2)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
	if(H.backbag == 3)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/norm(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/roboticist(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/device/pda/roboticist(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/toolbox/mechanical(H), slot_l_hand)

	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)

	return 1