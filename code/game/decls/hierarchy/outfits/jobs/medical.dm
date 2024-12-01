/*
 * Medical
 */
/decl/hierarchy/outfit/job/medical
	shoes = /obj/item/clothing/shoes/white

	suit_store = /obj/item/flashlight/pen

	pda_type = /obj/item/pda/medical

	backpack = /obj/item/storage/backpack/medic
	satchel_one = /obj/item/storage/satchel/med

/*
 * Chief Medical Officer
 */
/decl/hierarchy/outfit/job/medical/cmo
	name = "Chief Medical Officer"

	uniform = /obj/item/clothing/under/rank/chief_medical_officer
	suit = /obj/item/clothing/suit/storage/labcoat/cmo

	shoes = /obj/item/clothing/shoes/brown

	l_ear = /obj/item/radio/headset/heads/cmo

	l_hand = /obj/item/storage/firstaid/adv

	id_type = /obj/item/card/id/silver
	pda_type = /obj/item/pda/heads/cmo

/*
 * Medical Doctor
 */
/decl/hierarchy/outfit/job/medical/doctor
	name = "Medical Doctor"

	uniform = /obj/item/clothing/under/rank/medical
	suit = /obj/item/clothing/suit/storage/labcoat

	l_ear = /obj/item/radio/headset/med

	l_hand = /obj/item/storage/firstaid/adv

// Emergency Physician
/decl/hierarchy/outfit/job/medical/doctor/physician
	name = "Emergency Physician"

	suit = /obj/item/clothing/suit/storage/fr_jacket

// Surgeon
/decl/hierarchy/outfit/job/medical/doctor/surgeon
	name = "Surgeon"

	uniform = /obj/item/clothing/under/rank/medical/blue

	head = /obj/item/clothing/head/surgery/blue

// Nurse
/decl/hierarchy/outfit/job/medical/doctor/nurse
	name = "Nurse"

	suit = null

/decl/hierarchy/outfit/job/medical/doctor/nurse/pre_equip(mob/living/carbon/human/user)
	. = ..()
	if(user.gender == FEMALE)
		if(prob(50))
			uniform = /obj/item/clothing/under/rank/nursesuit
		else
			uniform = /obj/item/clothing/under/rank/nurse
		head = /obj/item/clothing/head/nursehat
	else
		uniform = /obj/item/clothing/under/rank/medical/purple

/*
 * Chemist
 */
/decl/hierarchy/outfit/job/medical/chemist
	name = "Chemist"

	uniform = /obj/item/clothing/under/rank/chemist
	suit = /obj/item/clothing/suit/storage/labcoat/chemist

	l_ear = /obj/item/radio/headset/med

	suit_store = null

	pda_type = /obj/item/pda/chemist

	satchel_one = /obj/item/storage/satchel/chem

/*
 * Virologist
 */
/decl/hierarchy/outfit/job/medical/virologist
	name = "Virologist"

	uniform = /obj/item/clothing/under/rank/virologist
	suit = /obj/item/clothing/suit/storage/labcoat/virologist

	mask = /obj/item/clothing/mask/surgical

	l_ear = /obj/item/radio/headset/med

	pda_type = /obj/item/pda/viro

	satchel_one = /obj/item/storage/satchel/vir

/*
 * Psychiatrist
 */
/decl/hierarchy/outfit/job/medical/psychiatrist
	name = "Psychiatrist"

	uniform = /obj/item/clothing/under/rank/medical
	suit = /obj/item/clothing/suit/storage/labcoat

	l_ear = /obj/item/radio/headset/med