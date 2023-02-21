/*
 * Chief Engineer
 */
/datum/job/chief_engineer
	title = "Chief Engineer"
	flag = JOB_CHIEF
	department_flag = DEPARTMENT_ENGSEC
	faction = "Station"

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Captain"
	selection_color = "#ffeeaa"

	idtype = /obj/item/weapon/card/id/silver
	req_admin_notify = TRUE
	minimal_player_age = 7

	access = list(
		ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS,
		ACCESS_TELEPORTER, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_ATMOSPHERICS, ACCESS_EMERGENCY_STORAGE, ACCESS_EVA,
		ACCESS_HEADS, ACCESS_CONSTRUCTION, ACCESS_SEC_DOORS,
		ACCESS_CE, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_TCOMSAT, ACCESS_AI_UPLOAD
	)
	minimal_access = list(
		ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS,
		ACCESS_TELEPORTER, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_ATMOSPHERICS, ACCESS_EMERGENCY_STORAGE, ACCESS_EVA,
		ACCESS_HEADS, ACCESS_CONSTRUCTION, ACCESS_SEC_DOORS,
		ACCESS_CE, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_TCOMSAT, ACCESS_AI_UPLOAD
	)

/datum/job/chief_engineer/equip(mob/living/carbon/human/H)
	if(!H)
		return 0

	switch(H.backbag)
		if(2)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/industrial(H), slot_back)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/eng(H), slot_back)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel(H), slot_back)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/ce(H), slot_l_ear)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chief_engineer(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/device/pda/heads/ce(H), slot_l_store)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/white(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)

	if(istype(H.species.survival_kit, /obj/item/weapon/storage/box/survival))
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival_engineer(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival_engineer(H.back), slot_in_backpack)
	return 1

/*
 * Station Engineer
 */
/datum/job/engineer
	title = "Station Engineer"
	flag = JOB_ENGINEER
	department_flag = DEPARTMENT_ENGSEC
	faction = "Station"

	total_positions = 5
	spawn_positions = 5

	supervisors = "the Chief Engineer"
	selection_color = "#fff5cc"

	access = list(
		ACCESS_EVA, ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE,
		ACCESS_MAINT_TUNNELS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION, ACCESS_ATMOSPHERICS
	)
	minimal_access = list(
		ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS,
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION
	)

	alt_titles = list("Maintenance Technician", "Engine Technician", "Electrician")

/datum/job/engineer/equip(mob/living/carbon/human/H)
	if(!H)
		return 0

	switch(H.backbag)
		if(2)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/industrial(H), slot_back)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/eng(H), slot_back)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel(H), slot_back)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_eng(H), slot_l_ear)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/engineer(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/device/t_scanner(H), slot_r_store)
	H.equip_to_slot_or_del(new /obj/item/device/pda/engineering(H), slot_l_store)

	if(istype(H.species.survival_kit, /obj/item/weapon/storage/box/survival))
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival_engineer(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival_engineer(H.back), slot_in_backpack)
	return 1

/*
 * Atmospheric Technician
 */
/datum/job/atmos
	title = "Atmospheric Technician"
	flag = JOB_ATMOSTECH
	department_flag = DEPARTMENT_ENGSEC
	faction = "Station"

	total_positions = 3
	spawn_positions = 2

	supervisors = "the Chief Engineer"
	selection_color = "#fff5cc"

	access = list(
		ACCESS_EVA, ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE,
		ACCESS_MAINT_TUNNELS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION,
		ACCESS_ATMOSPHERICS, ACCESS_EXTERNAL_AIRLOCKS
	)
	minimal_access = list(
		ACCESS_ATMOSPHERICS, ACCESS_MAINT_TUNNELS, ACCESS_EMERGENCY_STORAGE, ACCESS_CONSTRUCTION,
		ACCESS_EXTERNAL_AIRLOCKS
	)

/datum/job/atmos/equip(mob/living/carbon/human/H)
	if(!H)
		return 0

	switch(H.backbag)
		if(2)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/norm(H), slot_back)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel(H), slot_back)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_eng(H), slot_l_ear)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/atmospheric_technician(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/device/pda/atmos(H), slot_l_store)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/atmostech/(H), slot_belt)

	if(!istype(H.species.survival_kit, /obj/item/weapon/storage/box/survival))
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival_engineer(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival_engineer(H.back), slot_in_backpack)
	return 1