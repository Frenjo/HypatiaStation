/*
 * Engineering
 */
/decl/hierarchy/outfit/job/engineering
	belt = /obj/item/weapon/storage/belt/utility/full

	pda_slot = SLOT_ID_L_STORE

	l_ear = /obj/item/device/radio/headset/engi

	flags = OUTFIT_HIDE_IF_CATEGORY

	backpack = /obj/item/weapon/storage/backpack/industrial
	satchel_one = /obj/item/weapon/storage/satchel/eng

/*
 * Chief Engineer
 */
/decl/hierarchy/outfit/job/engineering/chief
	name = "Chief Engineer"

	uniform = /obj/item/clothing/under/rank/chief_engineer

	head = /obj/item/clothing/head/hardhat/white
	gloves = /obj/item/clothing/gloves/black
	shoes = /obj/item/clothing/shoes/brown

	l_ear = /obj/item/device/radio/headset/heads/ce

	id_type = /obj/item/weapon/card/id/silver
	pda_type = /obj/item/device/pda/heads/ce

/*
 * Station Engineer
 */
/decl/hierarchy/outfit/job/engineering/engineer
	name = "Station Engineer"

	uniform = /obj/item/clothing/under/rank/engineer

	head = /obj/item/clothing/head/hardhat
	shoes = /obj/item/clothing/shoes/orange

	r_pocket = /obj/item/device/t_scanner

	pda_type = /obj/item/device/pda/engineering

/*
 * Atmospheric Technician
 */
/decl/hierarchy/outfit/job/engineering/atmospherics
	name = "Atmospheric Technician"

	uniform = /obj/item/clothing/under/rank/atmospheric_technician
	belt = /obj/item/weapon/storage/belt/utility/atmostech

	shoes = /obj/item/clothing/shoes/black

	pda_type = /obj/item/device/pda/atmos

	backpack = /obj/item/weapon/storage/backpack
	satchel_one = /obj/item/weapon/storage/satchel/norm