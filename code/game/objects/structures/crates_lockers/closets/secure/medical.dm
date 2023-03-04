/*
 * Medicine
 */
/obj/structure/closet/secure_closet/medical1
	name = "Medicine Closet"
	desc = "Filled with medical junk."
	req_access = list(ACCESS_MEDICAL)
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medicaloff"

	starts_with = list(
		/obj/item/weapon/storage/box/autoinjectors,
		/obj/item/weapon/storage/box/syringes,
		/obj/item/weapon/reagent_containers/dropper,
		/obj/item/weapon/reagent_containers/dropper,
		/obj/item/weapon/reagent_containers/glass/beaker,
		/obj/item/weapon/reagent_containers/glass/beaker,
		/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline,
		/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline,
		/obj/item/weapon/reagent_containers/glass/bottle/antitoxin,
		/obj/item/weapon/reagent_containers/glass/bottle/antitoxin
	)

/*
 * Anaesthetic
 */
/obj/structure/closet/secure_closet/medical2
	name = "Anesthetic"
	desc = "Used to knock people out."
	req_access = list(ACCESS_SURGERY)
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medicaloff"

	starts_with = list(
		/obj/item/weapon/tank/anesthetic,
		/obj/item/weapon/tank/anesthetic,
		/obj/item/weapon/tank/anesthetic,
		/obj/item/clothing/mask/breath/medical,
		/obj/item/clothing/mask/breath/medical,
		/obj/item/clothing/mask/breath/medical
	)

/*
 * Medical Doctor
 */
/obj/structure/closet/secure_closet/medical3
	name = "Medical Doctor's Locker"
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
	//	/obj/item/weapon/cartridge/medical,
		/obj/item/device/radio/headset/headset_med,
		/obj/item/weapon/storage/belt/medical
	)

/obj/structure/closet/secure_closet/medical3/New()
	if(prob(50))
		starts_with.Add(/obj/item/weapon/storage/backpack/medic)
	else
		starts_with.Add(/obj/item/weapon/storage/satchel/med)

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
/obj/structure/closet/secure_closet/cmo
	name = "Chief Medical Officer's Locker"
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
		/obj/item/weapon/cartridge/cmo,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/shoes/brown,
		/obj/item/device/radio/headset/heads/cmo,
		/obj/item/weapon/storage/belt/medical,
		/obj/item/device/flash,
		/obj/item/weapon/reagent_containers/hypospray
	)

/obj/structure/closet/secure_closet/cmo/New()
	if(prob(50))
		starts_with.Add(/obj/item/weapon/storage/backpack/medic)
	else
		starts_with.Add(/obj/item/weapon/storage/satchel/med)

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
/obj/structure/closet/secure_closet/animal
	name = "Animal Control"
	req_access = list(ACCESS_SURGERY)

	starts_with = list(
		/obj/item/device/assembly/signaler,
		/obj/item/device/radio/electropack,
		/obj/item/device/radio/electropack,
		/obj/item/device/radio/electropack
	)

/*
 * Chemical
 */
/obj/structure/closet/secure_closet/chemical
	name = "Chemical Closet"
	desc = "Store dangerous chemicals in here."
	req_access = list(ACCESS_CHEMISTRY)
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medicaloff"

	starts_with = list(
		/obj/item/weapon/storage/box/pillbottles,
		/obj/item/weapon/storage/box/pillbottles
	)

/*
 * First Aid
 */
/obj/structure/closet/secure_closet/medical_wall
	name = "First Aid Closet"
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

/obj/structure/closet/secure_closet/medical_wall/update_icon()
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