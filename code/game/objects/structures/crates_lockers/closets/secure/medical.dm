/*
 * Medicine
 */
/obj/structure/closet/secure/medical/medicine
	name = "medicine closet"
	desc = "Filled with medical junk."
	req_access = list(ACCESS_MEDICAL)
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medicaloff"

	starts_with = list(
		/obj/item/storage/box/autoinjectors,
		/obj/item/storage/box/syringes,
		/obj/item/reagent_holder/dropper,
		/obj/item/reagent_holder/dropper,
		/obj/item/reagent_holder/glass/beaker,
		/obj/item/reagent_holder/glass/beaker,
		/obj/item/reagent_holder/glass/bottle/inaprovaline,
		/obj/item/reagent_holder/glass/bottle/inaprovaline,
		/obj/item/reagent_holder/glass/bottle/antitoxin,
		/obj/item/reagent_holder/glass/bottle/antitoxin
	)

/*
 * Anaesthetic
 */
/obj/structure/closet/secure/medical/anaesthetic
	name = "anaesthetic"
	desc = "Used to knock people out."
	req_access = list(ACCESS_SURGERY)
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medicaloff"

	starts_with = list(
		/obj/item/tank/anesthetic,
		/obj/item/tank/anesthetic,
		/obj/item/tank/anesthetic,
		/obj/item/clothing/mask/breath/medical,
		/obj/item/clothing/mask/breath/medical,
		/obj/item/clothing/mask/breath/medical
	)

/*
 * Medical Doctor
 */
/obj/structure/closet/secure/medical/doctor
	name = "medical doctor's locker"
	req_access = list(ACCESS_SURGERY)
	icon_state = "securemed1"
	icon_closed = "securemed"
	icon_locked = "securemed1"
	icon_opened = "securemedopen"
	icon_broken = "securemedbroken"
	icon_off = "securemedoff"

	starts_with = list(
		/obj/item/clothing/under/rank/nursesuit,
		/obj/item/clothing/head/nursehat,
		/obj/item/clothing/under/rank/medical,
		/obj/item/clothing/under/rank/nurse,
		/obj/item/clothing/under/rank/orderly,
		/obj/item/clothing/suit/storage/labcoat,
		/obj/item/clothing/suit/storage/fr_jacket,
		/obj/item/clothing/shoes/white,
	//	/obj/item/cartridge/medical,
		/obj/item/radio/headset/med,
		/obj/item/storage/belt/medical
	)

/obj/structure/closet/secure/medical/doctor/New()
	if(prob(50))
		starts_with.Add(/obj/item/storage/backpack/medic)
	else
		starts_with.Add(/obj/item/storage/satchel/med)

	switch(pick("blue", "green", "purple"))
		if("blue")
			starts_with.Add(/obj/item/clothing/under/rank/medical/blue)
			starts_with.Add(/obj/item/clothing/head/surgery/blue)
		if("green")
			starts_with.Add(/obj/item/clothing/under/rank/medical/green)
			starts_with.Add(/obj/item/clothing/head/surgery/green)
		if("purple")
			starts_with.Add(/obj/item/clothing/under/rank/medical/purple)
			starts_with.Add(/obj/item/clothing/head/surgery/purple)

	switch(pick("blue", "green", "purple"))
		if("blue")
			starts_with.Add(/obj/item/clothing/under/rank/medical/blue)
			starts_with.Add(/obj/item/clothing/head/surgery/blue)
		if("green")
			starts_with.Add(/obj/item/clothing/under/rank/medical/green)
			starts_with.Add(/obj/item/clothing/head/surgery/green)
		if("purple")
			starts_with.Add(/obj/item/clothing/under/rank/medical/purple)
			starts_with.Add(/obj/item/clothing/head/surgery/purple)
	. = ..()

/*
 * Chief Medical Officer
 */
/obj/structure/closet/secure/medical/cmo
	name = "chief medical officer's locker"
	req_access = list(ACCESS_CMO)
	icon_state = "cmosecure1"
	icon_closed = "cmosecure"
	icon_locked = "cmosecure1"
	icon_opened = "cmosecureopen"
	icon_broken = "cmosecurebroken"
	icon_off = "cmosecureoff"

	starts_with = list(
		/obj/item/clothing/suit/bio_suit/cmo,
		/obj/item/clothing/head/bio_hood/cmo,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/under/rank/chief_medical_officer,
		/obj/item/clothing/suit/storage/labcoat/cmo,
		/obj/item/cartridge/cmo,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/shoes/brown,
		/obj/item/radio/headset/heads/cmo,
		/obj/item/storage/belt/medical,
		/obj/item/flash,
		/obj/item/reagent_holder/hypospray
	)

/obj/structure/closet/secure/medical/cmo/New()
	if(prob(50))
		starts_with.Add(/obj/item/storage/backpack/medic)
	else
		starts_with.Add(/obj/item/storage/satchel/med)

	switch(pick("blue", "green", "purple"))
		if("blue")
			starts_with.Add(/obj/item/clothing/under/rank/medical/blue)
			starts_with.Add(/obj/item/clothing/head/surgery/blue)
		if("green")
			starts_with.Add(/obj/item/clothing/under/rank/medical/green)
			starts_with.Add(/obj/item/clothing/head/surgery/green)
		if("purple")
			starts_with.Add(/obj/item/clothing/under/rank/medical/purple)
			starts_with.Add(/obj/item/clothing/head/surgery/purple)
	. = ..()

/*
 * Animal Control
 */
/obj/structure/closet/secure/animal
	name = "animal control"
	req_access = list(ACCESS_SURGERY)

	starts_with = list(
		/obj/item/assembly/signaler,
		/obj/item/radio/electropack,
		/obj/item/radio/electropack,
		/obj/item/radio/electropack
	)

/*
 * Chemical
 */
/obj/structure/closet/secure/chemical
	name = "chemical closet"
	desc = "Store dangerous chemicals in here."
	req_access = list(ACCESS_CHEMISTRY)
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medicaloff"

	starts_with = list(
		/obj/item/storage/box/pillbottles,
		/obj/item/storage/box/pillbottles
	)

/*
 * First Aid
 */
/obj/structure/closet/secure/medical/wall
	name = "first aid closet"
	desc = "It's a secure wall-mounted storage unit for first aid supplies."
	req_access = list(ACCESS_MEDICAL)
	icon_state = "medical_wall_locked"
	icon_closed = "medical_wall_unlocked"
	icon_locked = "medical_wall_locked"
	icon_opened = "medical_wall_open"
	icon_broken = "medical_wall_spark"
	icon_off = "medical_wall_off"
	anchored = TRUE
	density = FALSE
	wall_mounted = TRUE

/obj/structure/closet/secure/medical/wall/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened