/*
 * Security
 */
/decl/hierarchy/outfit/job/security
	shoes = /obj/item/clothing/shoes/jackboots

	l_ear = /obj/item/device/radio/headset/headset_sec

	flags = OUTFIT_HIDE_IF_CATEGORY

	backpack = /obj/item/weapon/storage/backpack/security
	satchel_one = /obj/item/weapon/storage/satchel/sec

/*
 * Head of Security
 */
/decl/hierarchy/outfit/job/security/hos
	name = "Head of Security"

	uniform = /obj/item/clothing/under/rank/head_of_security

	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	gloves = /obj/item/clothing/gloves/black

	l_ear = /obj/item/device/radio/headset/heads/hos

	suit_store = /obj/item/weapon/gun/energy/gun

	backpack_contents = list(
		/obj/item/weapon/handcuffs = 1
	)

	id_type = /obj/item/weapon/card/id/silver
	pda_type = /obj/item/device/pda/heads/hos

/*
 * Warden
 */
/decl/hierarchy/outfit/job/security/warden
	name = "Warden"

	uniform = /obj/item/clothing/under/rank/warden

	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	gloves = /obj/item/clothing/gloves/black

	l_pocket = /obj/item/device/flash

	backpack_contents = list(
		/obj/item/weapon/handcuffs = 1
	)

	pda_type = /obj/item/device/pda/warden

/*
 * Detective
 */
/decl/hierarchy/outfit/job/security/detective
	name = "Detective"

	uniform = /obj/item/clothing/under/det
	suit = /obj/item/clothing/suit/storage/det_suit

	head = /obj/item/clothing/head/det_hat

	gloves = /obj/item/clothing/gloves/black
	shoes = /obj/item/clothing/shoes/brown

	l_pocket = /obj/item/weapon/lighter/zippo

	backpack_contents = list(
		/obj/item/weapon/storage/box/evidence = 1,
		/obj/item/device/detective_scanner = 1
	)

	pda_type = /obj/item/device/pda/detective

	backpack = /obj/item/weapon/storage/backpack
	satchel_one = /obj/item/weapon/storage/satchel/norm

// Forensic Technician
/decl/hierarchy/outfit/job/security/detective/forensics
	name = "Forensic Technician"

	suit = /obj/item/clothing/suit/storage/forensics/blue

	head = null

/*
 * Security Officer
 */
/decl/hierarchy/outfit/job/security/officer
	name = "Security Officer"

	uniform = /obj/item/clothing/under/rank/security

	l_pocket = /obj/item/device/flash
	r_pocket = /obj/item/weapon/handcuffs

	backpack_contents = list(
		/obj/item/weapon/handcuffs = 1
	)

	pda_type = /obj/item/device/pda/security

/*
 * Security Paramedic
 */
/decl/hierarchy/outfit/job/security/paramedic
	name = "Security Paramedic"

	uniform = /obj/item/clothing/under/rank/security2
	suit = /obj/item/clothing/suit/storage/labcoat

	l_ear = /obj/item/device/radio/headset/headset_secpara

	l_hand = /obj/item/weapon/storage/firstaid/regular

	pda_type = /obj/item/device/pda/medical

	backpack = /obj/item/weapon/storage/backpack/medic
	satchel_one = /obj/item/weapon/storage/satchel/med