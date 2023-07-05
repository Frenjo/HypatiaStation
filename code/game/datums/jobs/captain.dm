/*
 * Captain
 */
/datum/job/captain
	title = "Captain"
	flag = JOB_CAPTAIN
	department_flag = DEPARTMENT_ENGSEC
	faction = "Station"

	total_positions = 1
	spawn_positions = 1

	supervisors = "NanoTrasen Officials and Space Law"
	selection_color = "#ccccff"

	idtype = /obj/item/weapon/card/id/gold
	req_admin_notify = TRUE
	minimal_player_age = 14

/datum/job/captain/equip(mob/living/carbon/human/H)
	switch(H.backbag)
		if(2)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/captain(H), SLOT_ID_BACK)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/cap(H), SLOT_ID_BACK)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel(H), SLOT_ID_BACK)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/captain(H), SLOT_ID_L_EAR)
	var/obj/item/clothing/under/U = new /obj/item/clothing/under/rank/captain(H)
	if(H.age > 49)
		U.hastie = new /obj/item/clothing/tie/medal/gold/captain(U)

	H.equip_to_slot_or_del(U, SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/device/pda/captain(H), SLOT_ID_BELT)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat(H), SLOT_ID_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), SLOT_ID_GLASSES)

	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/ids(H), SLOT_ID_R_HAND)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/ids(H.back), SLOT_ID_IN_BACKPACK)

	var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(H)
	L.imp_in = H
	L.implanted = 1
	to_world("<b>[H.real_name] is the captain!</b>")
	var/datum/organ/external/affected = H.organs_by_name["head"]
	affected.implants.Add(L)
	L.part = affected

	return 1

/datum/job/captain/get_access()
	return get_all_station_access()

/*
 * Head of Personnel
 */
/datum/job/hop
	title = "Head of Personnel"
	flag = JOB_HOP
	department_flag = DEPARTMENT_CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Captain"
	selection_color = "#ddddff"
	idtype = /obj/item/weapon/card/id/silver
	req_admin_notify = TRUE
	minimal_player_age = 10

	access = list(
		ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_FORENSICS_LOCKERS,
		ACCESS_MEDICAL, ACCESS_ENGINE, ACCESS_CHANGE_IDS, ACCESS_AI_UPLOAD, ACCESS_EVA, ACCESS_BRIDGE,
		ACCESS_ALL_PERSONAL_LOCKERS, ACCESS_MAINT_TUNNELS, ACCESS_BAR, ACCESS_JANITOR, ACCESS_CONSTRUCTION, ACCESS_MORGUE,
		ACCESS_CREMATORIUM, ACCESS_KITCHEN, ACCESS_CARGO, ACCESS_HYDROPONICS, ACCESS_LAWYER,
		ACCESS_THEATRE, ACCESS_CHAPEL_OFFICE, ACCESS_LIBRARY, ACCESS_RESEARCH, ACCESS_HEADS_VAULT, ACCESS_CLOWN, ACCESS_MIME,
		ACCESS_HOP, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY
	)
	minimal_access = list(
		ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_FORENSICS_LOCKERS,
		ACCESS_MEDICAL, ACCESS_ENGINE, ACCESS_CHANGE_IDS, ACCESS_AI_UPLOAD, ACCESS_EVA, ACCESS_BRIDGE,
		ACCESS_ALL_PERSONAL_LOCKERS, ACCESS_MAINT_TUNNELS, ACCESS_BAR, ACCESS_JANITOR, ACCESS_CONSTRUCTION, ACCESS_MORGUE,
		ACCESS_CREMATORIUM, ACCESS_KITCHEN, ACCESS_CARGO,  ACCESS_HYDROPONICS, ACCESS_LAWYER,
		ACCESS_THEATRE, ACCESS_CHAPEL_OFFICE, ACCESS_LIBRARY, ACCESS_RESEARCH, ACCESS_HEADS_VAULT, ACCESS_CLOWN, ACCESS_MIME,
		ACCESS_HOP, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY
	)

	alt_titles = list("Human Resources Director")

/datum/job/hop/equip(mob/living/carbon/human/H)
	switch(H.backbag)
		if(2)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), SLOT_ID_BACK)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/norm(H), SLOT_ID_BACK)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel(H), SLOT_ID_BACK)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/hop(H), SLOT_ID_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/head_of_personnel(H), SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/device/pda/heads/hop(H), SLOT_ID_BELT)

	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/ids(H), SLOT_ID_R_HAND)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/ids(H.back), SLOT_ID_IN_BACKPACK)

	return 1