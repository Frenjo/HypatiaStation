/*
 * Chief Medical Officer
 */
/datum/job/cmo
	title = "Chief Medical Officer"
	flag = JOB_CMO
	department_flag = DEPARTMENT_MEDSCI
	faction = "Station"

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Captain"
	selection_color = "#ffddf0"

	idtype = /obj/item/weapon/card/id/silver
	req_admin_notify = TRUE
	minimal_player_age = 10

	access = list(
		ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_GENETICS, ACCESS_HEADS,
		ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_CMO, ACCESS_SURGERY, ACCESS_RC_ANNOUNCE,
		ACCESS_KEYCARD_AUTH, ACCESS_SEC_DOORS, ACCESS_PSYCHIATRIST
	)
	minimal_access = list(
		ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_GENETICS, ACCESS_HEADS,
		ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_CMO, ACCESS_SURGERY, ACCESS_RC_ANNOUNCE,
		ACCESS_KEYCARD_AUTH, ACCESS_SEC_DOORS, ACCESS_PSYCHIATRIST
	)

	alt_titles = list("Medical Director")

/datum/job/cmo/equip(mob/living/carbon/human/H)
	if(isnull(H))
		return 0

	switch(H.backbag)
		if(2)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/medic(H), SLOT_ID_BACK)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/med(H), SLOT_ID_BACK)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel(H), SLOT_ID_BACK)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/cmo(H), SLOT_ID_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chief_medical_officer(H), SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/device/pda/heads/cmo(H), SLOT_ID_BELT)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/cmo(H), SLOT_ID_WEAR_SUIT)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/adv(H), SLOT_ID_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen(H), SLOT_ID_S_STORE)

	return 1

/*
 * Medical Doctor
 */
/datum/job/doctor
	title = "Medical Doctor"
	flag = JOB_DOCTOR
	department_flag = DEPARTMENT_MEDSCI
	faction = "Station"

	total_positions = 5
	spawn_positions = 3

	supervisors = "the Chief Medical Officer"
	selection_color = "#ffeef0"

	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_GENETICS)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_VIROLOGY)

	alt_titles = list("Surgeon", "Emergency Physician", "Nurse")

/datum/job/doctor/equip(mob/living/carbon/human/H)
	if(isnull(H))
		return 0

	switch(H.backbag)
		if(2)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/medic(H), SLOT_ID_BACK)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/med(H), SLOT_ID_BACK)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel(H), SLOT_ID_BACK)

	if(!isnull(H.mind.role_alt_title))
		switch(H.mind.role_alt_title)
			if("Emergency Physician")
				H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(H), SLOT_ID_W_UNIFORM)
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/fr_jacket(H), SLOT_ID_WEAR_SUIT)
			if("Surgeon")
				H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/blue(H), SLOT_ID_W_UNIFORM)
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(H), SLOT_ID_WEAR_SUIT)
				H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/blue(H), SLOT_ID_HEAD)
			if("Medical Doctor")
				H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(H), SLOT_ID_W_UNIFORM)
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(H), SLOT_ID_WEAR_SUIT)
			if("Nurse")
				if(H.gender == FEMALE)
					if(prob(50))
						H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/nursesuit(H), SLOT_ID_W_UNIFORM)
					else
						H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/nurse(H), SLOT_ID_W_UNIFORM)
					H.equip_to_slot_or_del(new /obj/item/clothing/head/nursehat(H), SLOT_ID_HEAD)
				else
					H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/purple(H), SLOT_ID_W_UNIFORM)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(H), SLOT_ID_W_UNIFORM)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(H), SLOT_ID_WEAR_SUIT)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_med(H), SLOT_ID_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/device/pda/medical(H), SLOT_ID_BELT)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/adv(H), SLOT_ID_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen(H), SLOT_ID_S_STORE)

	return 1

/*
 * Chemist
 */
// Chemist is a medical job damnit.	//YEAH FUCK YOU SCIENCE	-Pete	//Guys, behave -Erro
/datum/job/chemist
	title = "Chemist"
	flag = JOB_CHEMIST
	department_flag = DEPARTMENT_MEDSCI
	faction = "Station"

	total_positions = 2
	spawn_positions = 2

	supervisors = "the Chief Medical Officer"
	selection_color = "#ffeef0"

	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_GENETICS)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_CHEMISTRY)

	alt_titles = list("Pharmacist")

/datum/job/chemist/equip(mob/living/carbon/human/H)
	if(isnull(H))
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_med(H), SLOT_ID_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chemist(H), SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/device/pda/chemist(H), SLOT_ID_BELT)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/chemist(H), SLOT_ID_WEAR_SUIT)

	if(H.backbag == 3)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/chem(H), SLOT_ID_BACK)

	return 1

/*
 * Geneticist
 */
/datum/job/geneticist
	title = "Geneticist"
	flag = JOB_GENETICIST
	department_flag = DEPARTMENT_MEDSCI
	faction = "Station"

	total_positions = 2
	spawn_positions = 2

	supervisors = "the Chief Medical Officer and the Research Director"
	selection_color = "#ffeef0"

	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_GENETICS, ACCESS_RESEARCH)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_GENETICS, ACCESS_RESEARCH)

/datum/job/geneticist/equip(mob/living/carbon/human/H)
	if(isnull(H))
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_medsci(H), SLOT_ID_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/geneticist(H), SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/device/pda/geneticist(H), SLOT_ID_BELT)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/genetics(H), SLOT_ID_WEAR_SUIT)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen(H), SLOT_ID_S_STORE)

	if(H.backbag == 3)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/gen(H), SLOT_ID_BACK)

	return 1

/*
 * Virologist
 */
/datum/job/virologist
	title = "Virologist"
	flag = JOB_VIROLOGIST
	department_flag = DEPARTMENT_MEDSCI
	faction = "Station"

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Chief Medical Officer"
	selection_color = "#ffeef0"

	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_GENETICS)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_VIROLOGY)

	alt_titles = list("Pathologist", "Microbiologist")

/datum/job/virologist/equip(mob/living/carbon/human/H)
	if(isnull(H))
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_med(H), SLOT_ID_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/virologist(H), SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/device/pda/viro(H), SLOT_ID_BELT)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(H), SLOT_ID_WEAR_MASK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/virologist(H), SLOT_ID_WEAR_SUIT)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen(H), SLOT_ID_S_STORE)

	if(H.backbag == 3)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/vir(H), SLOT_ID_BACK)

	return 1

/*
 * Psychiatrist
 */
/datum/job/psychiatrist
	title = "Psychiatrist"
	flag = JOB_PSYCHIATRIST
	department_flag = DEPARTMENT_MEDSCI
	faction = "Station"

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Chief Medical Officer"
	selection_color = "#ffeef0"

	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_GENETICS, ACCESS_PSYCHIATRIST)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_PSYCHIATRIST)

	alt_titles = list("Psychologist")

/datum/job/psychiatrist/equip(mob/living/carbon/human/H)
	if(isnull(H))
		return 0

	switch(H.backbag)
		if(2)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/medic(H), SLOT_ID_BACK)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/med(H), SLOT_ID_BACK)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel(H), SLOT_ID_BACK)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_med(H), SLOT_ID_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(H), SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/device/pda/medical(H), SLOT_ID_BELT)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(H), SLOT_ID_WEAR_SUIT)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen(H), SLOT_ID_S_STORE)

	return 1