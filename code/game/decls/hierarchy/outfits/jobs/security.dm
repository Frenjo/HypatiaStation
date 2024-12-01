/*
 * Security
 */
/decl/hierarchy/outfit/job/security
	shoes = /obj/item/clothing/shoes/jackboots

	l_ear = /obj/item/radio/headset/sec

	backpack = /obj/item/storage/backpack/security
	satchel_one = /obj/item/storage/satchel/sec

/*
 * Head of Security
 */
/decl/hierarchy/outfit/job/security/hos
	name = "Head of Security"

	uniform = /obj/item/clothing/under/rank/head_of_security

	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	gloves = /obj/item/clothing/gloves/black

	l_ear = /obj/item/radio/headset/heads/hos

	suit_store = /obj/item/gun/energy/gun

	backpack_contents = list(
		/obj/item/handcuffs
	)

	id_type = /obj/item/card/id/silver
	pda_type = /obj/item/pda/heads/hos

/*
 * Warden
 */
/decl/hierarchy/outfit/job/security/warden
	name = "Warden"

	uniform = /obj/item/clothing/under/rank/warden

	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	gloves = /obj/item/clothing/gloves/black

	l_pocket = /obj/item/flash

	backpack_contents = list(
		/obj/item/handcuffs
	)

	pda_type = /obj/item/pda/warden

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

	l_pocket = /obj/item/lighter/zippo

	backpack_contents = list(
		/obj/item/storage/box/evidence,
		/obj/item/detective_scanner
	)

	pda_type = /obj/item/pda/detective

	backpack = /obj/item/storage/backpack
	satchel_one = /obj/item/storage/satchel/norm

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

	l_pocket = /obj/item/flash
	r_pocket = /obj/item/handcuffs

	backpack_contents = list(
		/obj/item/handcuffs
	)

	pda_type = /obj/item/pda/security

/*
 * Security Paramedic
 */
/decl/hierarchy/outfit/job/security/paramedic
	name = "Security Paramedic"

	uniform = /obj/item/clothing/under/rank/security2
	suit = /obj/item/clothing/suit/storage/labcoat

	l_ear = /obj/item/radio/headset/sec_para

	l_hand = /obj/item/storage/firstaid/regular

	pda_type = /obj/item/pda/medical

	backpack = /obj/item/storage/backpack/medic
	satchel_one = /obj/item/storage/satchel/med