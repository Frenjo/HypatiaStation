/*
 * Head of Security
 */
/datum/job/hos
	title = "Head of Security"
	flag = JOB_HOS
	department_flag = DEPARTMENT_ENGSEC
	faction = "Station"

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Captain"
	selection_color = "#ffdddd"

	idtype = /obj/item/weapon/card/id/silver
	req_admin_notify = TRUE
	minimal_player_age = 14

	access = list(
		ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_ARMORY, ACCESS_COURT,
		ACCESS_FORENSICS_LOCKERS, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS, ACCESS_ALL_PERSONAL_LOCKERS,
		ACCESS_RESEARCH, ACCESS_ENGINE, ACCESS_MINING, ACCESS_MEDICAL, ACCESS_CONSTRUCTION, ACCESS_MAILSORTING,
		ACCESS_HEADS, ACCESS_HOS, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY
	)
	minimal_access = list(
		ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_ARMORY, ACCESS_COURT,
		ACCESS_FORENSICS_LOCKERS, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS, ACCESS_ALL_PERSONAL_LOCKERS,
		ACCESS_RESEARCH, ACCESS_ENGINE, ACCESS_MINING, ACCESS_MEDICAL, ACCESS_CONSTRUCTION, ACCESS_MAILSORTING,
		ACCESS_HEADS, ACCESS_HOS, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY
	)

	alt_titles = list("Security Commander")

/datum/job/hos/equip(mob/living/carbon/human/H)
	if(!H)
		return 0

	switch(H.backbag)
		if(2)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/security(H), SLOT_ID_BACK)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/sec(H), SLOT_ID_BACK)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel(H), SLOT_ID_BACK)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/hos(H), SLOT_ID_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/head_of_security(H), SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/device/pda/heads/hos(H), SLOT_ID_BELT)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), SLOT_ID_GLOVES)
//	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(H), SLOT_ID_WEAR_MASK) //Grab one from the armory you donk
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), SLOT_ID_GLASSES)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/gun(H), SLOT_ID_S_STORE)
	
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), SLOT_ID_R_HAND)
		H.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(H), SLOT_ID_L_STORE)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), SLOT_ID_IN_BACKPACK)
		H.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(H), SLOT_ID_IN_BACKPACK)

	var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(H)
	L.imp_in = H
	L.implanted = 1
	var/datum/organ/external/affected = H.organs_by_name["head"]
	affected.implants += L
	L.part = affected
	return 1

/*
 * Warden
 */
/datum/job/warden
	title = "Warden"
	flag = JOB_WARDEN
	department_flag = DEPARTMENT_ENGSEC
	faction = "Station"

	total_positions = 2
	spawn_positions = 2

	supervisors = "the Head of Security"
	selection_color = "#ffeeee"

	minimal_player_age = 5

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_ARMORY, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MORGUE)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_ARMORY, ACCESS_COURT, ACCESS_MAINT_TUNNELS)

/datum/job/warden/equip(mob/living/carbon/human/H)
	if(!H)
		return 0

	switch(H.backbag)
		if(2)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/security(H), SLOT_ID_BACK)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/sec(H), SLOT_ID_BACK)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel(H), SLOT_ID_BACK)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sec(H), SLOT_ID_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/warden(H), SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/device/pda/warden(H), SLOT_ID_BELT)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), SLOT_ID_GLOVES)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), SLOT_ID_GLASSES)
//	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(H), SLOT_ID_WEAR_MASK) //Grab one from the armory you donk
	H.equip_to_slot_or_del(new /obj/item/device/flash(H), SLOT_ID_L_STORE)
	
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), SLOT_ID_R_HAND)
		H.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(H), SLOT_ID_L_HAND)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), SLOT_ID_IN_BACKPACK)
		H.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(H), SLOT_ID_IN_BACKPACK)
	return 1

/*
 * Detective
 */
/datum/job/detective
	title = "Detective"
	flag = JOB_DETECTIVE
	department_flag = DEPARTMENT_ENGSEC
	faction = "Station"

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Head of Security"
	selection_color = "#ffeeee"

	minimal_player_age = 3

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_FORENSICS_LOCKERS, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS, ACCESS_COURT)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_FORENSICS_LOCKERS, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS, ACCESS_COURT)

	alt_titles = list("Forensic Technician")

/datum/job/detective/equip(mob/living/carbon/human/H)
	if(!H)
		return 0

	switch(H.backbag)
		if(2)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), SLOT_ID_BACK)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/norm(H), SLOT_ID_BACK)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel(H), SLOT_ID_BACK)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sec(H), SLOT_ID_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/det(H), SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/device/pda/detective(H), SLOT_ID_BELT)
/*	var/obj/item/clothing/mask/cigarette/CIG = new /obj/item/clothing/mask/cigarette(H)
	CIG.light("")
	H.equip_to_slot_or_del(CIG, SLOT_ID_WEAR_MASK)	*/
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), SLOT_ID_GLOVES)
	
	if(H.mind.role_alt_title && H.mind.role_alt_title == "Forensic Technician")
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/forensics/blue(H), SLOT_ID_WEAR_SUIT)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/det_suit(H), SLOT_ID_WEAR_SUIT)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/det_hat(H), SLOT_ID_HEAD)
	H.equip_to_slot_or_del(new /obj/item/weapon/lighter/zippo(H), SLOT_ID_L_STORE)

	if(H.backbag == 1)//Why cant some of these things spawn in his office?
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), SLOT_ID_R_HAND)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/evidence(H), SLOT_ID_L_HAND)
		H.equip_to_slot_or_del(new /obj/item/device/detective_scanner(H), SLOT_ID_R_STORE)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), SLOT_ID_IN_BACKPACK)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/evidence(H), SLOT_ID_IN_BACKPACK)
		H.equip_to_slot_or_del(new /obj/item/device/detective_scanner(H), SLOT_ID_IN_BACKPACK)
	return 1

/*
 * Security Officer
 */
/datum/job/officer
	title = "Security Officer"
	flag = JOB_OFFICER
	department_flag = DEPARTMENT_ENGSEC
	faction = "Station"

	total_positions = 5
	spawn_positions = 5

	supervisors = "the Head of Security"
	selection_color = "#ffeeee"

	minimal_player_age = 3

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MORGUE)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS)

/datum/job/officer/equip(mob/living/carbon/human/H)
	if(!H)
		return 0

	switch(H.backbag)
		if(2)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/security(H), SLOT_ID_BACK)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/sec(H), SLOT_ID_BACK)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel(H), SLOT_ID_BACK)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sec(H), SLOT_ID_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(H), SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/device/pda/security(H), SLOT_ID_BELT)
	H.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(H), SLOT_ID_S_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/flash(H), SLOT_ID_L_STORE)

	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), SLOT_ID_R_HAND)
		H.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(H), SLOT_ID_L_HAND)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), SLOT_ID_IN_BACKPACK)
		H.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(H), SLOT_ID_IN_BACKPACK)
	return 1

/*
 * Security Paramedic
 */
/datum/job/secpara
	title = "Security Paramedic"
	flag = JOB_SECPARA
	department_flag = DEPARTMENT_ENGSEC
	faction = "Station"

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Warden and the Head of Security"
	selection_color = "#ffeeee"

	minimal_player_age = 7

	access = list(ACCESS_MEDICAL, ACCESS_CHEMISTRY, ACCESS_SURGERY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MORGUE)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS)

/datum/job/secpara/equip(mob/living/carbon/human/H)
	if(!H)
		return 0

	switch(H.backbag)
		if(2)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/medic(H), SLOT_ID_BACK)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/med(H), SLOT_ID_BACK)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel(H), SLOT_ID_BACK)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_secpara(H), SLOT_ID_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security2(H), SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(H), SLOT_ID_WEAR_SUIT)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/device/pda/medical(H), SLOT_ID_BELT)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/regular(H), SLOT_ID_L_HAND)

	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), SLOT_ID_R_HAND)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), SLOT_ID_IN_BACKPACK)
	return 1