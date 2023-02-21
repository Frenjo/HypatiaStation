// Cargo. Note that this is in a separate file to prevent it loading in the preferences screen in the middle of the civilian jobs.
// Jobs are loaded in the preferences in order by file from beginning to end.
/*
 * Quartermaster
 */
/datum/job/qm
	title = "Quartermaster"
	flag = JOB_QUARTERMASTER
	department_flag = DEPARTMENT_CIVILIAN
	faction = "Station"

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Head of Personnel and the Captain"
	selection_color = "#8c7846"

	access = list(
		ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_CARGO_BOT,
		ACCESS_QM, ACCESS_MINT, ACCESS_MINING, ACCESS_MINING_STATION,
		ACCESS_RC_ANNOUNCE
	)
	minimal_access = list(
		ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_CARGO_BOT,
		ACCESS_QM, ACCESS_MINT, ACCESS_MINING, ACCESS_MINING_STATION,
		ACCESS_RC_ANNOUNCE
	)

/datum/job/qm/equip(mob/living/carbon/human/H)
	if(!H)
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_qm(H), slot_l_ear)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/cargo(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/device/pda/cargo/quartermaster(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), slot_glasses)
	H.equip_to_slot_or_del(new /obj/item/weapon/clipboard(H), slot_l_hand)
	
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
	return 1

/*
 * Cargo Technician
 */
/datum/job/cargo_tech
	title = "Cargo Technician"
	flag = JOB_CARGOTECH
	department_flag = DEPARTMENT_CIVILIAN
	faction = "Station"

	total_positions = 2
	spawn_positions = 2

	supervisors = "the Quartermaster"
	selection_color = "#aa9682"

	access = list(
		ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_CARGO_BOT, ACCESS_QM,
		ACCESS_MINT, ACCESS_MINING, ACCESS_MINING_STATION
	)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_CARGO, ACCESS_CARGO_BOT, ACCESS_MAILSORTING)

/datum/job/cargo_tech/equip(mob/living/carbon/human/H)
	if(!H)
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_cargo(H), slot_l_ear)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/cargotech(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/device/pda/cargo(H), slot_belt)
//	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)
	
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
	return 1

/*
 * Mining Foreman
 */
/datum/job/miningforeman
	title = "Mining Foreman"
	flag = JOB_MININGFOREMAN
	department_flag = DEPARTMENT_CIVILIAN
	faction = "Station"

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Quartermaster"
	selection_color = "#aa9682"

	access = list(
		ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_CARGO_BOT, ACCESS_QM,
		ACCESS_MINT, ACCESS_MINING, ACCESS_MINING_STATION
	)
	minimal_access = list(ACCESS_MINING, ACCESS_MINT, ACCESS_MINING_STATION, ACCESS_MAILSORTING)

	alt_titles = list("Head Miner")

/datum/job/miningforeman/equip(mob/living/carbon/human/H)
	if(!H)
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_mineforeman(H), slot_l_ear)
	switch(H.backbag)
		if(2)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/industrial(H), slot_back)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/eng(H), slot_back)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/miner/foreman(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/device/pda/shaftminer(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)

	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival_engineer(H), slot_r_hand)
		H.equip_to_slot_or_del(new /obj/item/weapon/crowbar(H), slot_l_hand)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/bag/ore(H), slot_l_store)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival_engineer(H.back), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/crowbar(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/bag/ore(H), slot_in_backpack)
	return 1

/*
 * Shaft Miner
 */
/datum/job/mining
	title = "Shaft Miner"
	flag = JOB_MINER
	department_flag = DEPARTMENT_CIVILIAN
	faction = "Station"

	total_positions = 3
	spawn_positions = 3

	supervisors = "the Mining Foreman and the Quartermaster"
	selection_color = "#aa9682"

	access = list(
		ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_CARGO_BOT, ACCESS_QM,
		ACCESS_MINT, ACCESS_MINING, ACCESS_MINING_STATION
	)
	minimal_access = list(ACCESS_MINING, ACCESS_MINT, ACCESS_MINING_STATION, ACCESS_MAILSORTING)

	alt_titles = list("Prospector")

/datum/job/mining/equip(mob/living/carbon/human/H)
	if(!H)
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_mine(H), slot_l_ear)
	switch(H.backbag)
		if(2)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/industrial(H), slot_back)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/eng(H), slot_back)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/miner(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/device/pda/shaftminer(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
//	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)

	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival_engineer(H), slot_r_hand)
		H.equip_to_slot_or_del(new /obj/item/weapon/crowbar(H), slot_l_hand)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/bag/ore(H), slot_l_store)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival_engineer(H.back), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/crowbar(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/bag/ore(H), slot_in_backpack)
	return 1

/*
 * Mailman
 */
// Re-adds mailman, how retro!
// Ported this from cargo tech code.
// Technically, the mailman isn't a part of cargo, but is grouped there...
// For convenience, since he should be coordinating deliveries with cargo techs. -Frenjo
/datum/job/mailman
	title = "Mailman"
	flag = JOB_MAILMAN
	department_flag = DEPARTMENT_CIVILIAN
	faction = "Station"

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Head of Personnel and the Quartermaster"
	selection_color = "#aa9682"

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_CARGO, ACCESS_MAILSORTING)

	alt_titles = list("Postman", "Delivery Technician") // Should probably change this to "Delivery Specialist", but "Cargo Technician" exists. -Frenjo

/datum/job/mailman/equip(mob/living/carbon/human/H)
	if(!H)
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_cargo(H), slot_l_ear)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/mailman(H), slot_w_uniform) // Mailman needs the distinctive uniform! -Frenjo
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/device/pda/cargo/mailman(H), slot_belt) // Mailman gets his own PDA now too! -Frenjo
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/blue(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/mailman(H), slot_head) // And the distinctive hat too! -Frenjo
	
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
	return 1