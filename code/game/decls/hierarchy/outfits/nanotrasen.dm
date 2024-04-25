/*
 * NanoTrasen Outfits
 */
/decl/hierarchy/outfit/nanotrasen
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/white
	shoes = /obj/item/clothing/shoes/centcom

	id_slot = SLOT_ID_ID_STORE
	id_type = /obj/item/card/id/centcom/station
	pda_slot = SLOT_ID_R_POCKET
	pda_type = /obj/item/pda/heads

	flags = OUTFIT_HIDE_IF_CATEGORY

/*
 * Representative
 */
/decl/hierarchy/outfit/nanotrasen/representative
	name = "NanoTrasen Representative"

	uniform = /obj/item/clothing/under/rank/centcom/representative
	belt = /obj/item/clipboard

	l_ear = /obj/item/radio/headset/heads/hop

	id_pda_assignment = "NanoTrasen Navy Representative"

/*
 * Officer
 */
/decl/hierarchy/outfit/nanotrasen/officer
	name = "NanoTrasen Officer"

	uniform = /obj/item/clothing/under/rank/centcom/officer
	belt = /obj/item/gun/energy

	head = /obj/item/clothing/head/beret/centcom/officer

	l_ear = /obj/item/radio/headset/heads/captain

	id_pda_assignment = "NanoTrasen Navy Officer"

/*
 * Captain
 */
/decl/hierarchy/outfit/nanotrasen/captain
	name = "NanoTrasen Captain"

	uniform = /obj/item/clothing/under/rank/centcom/captain
	belt = /obj/item/gun/energy

	head = /obj/item/clothing/head/beret/centcom/captain

	l_ear = /obj/item/radio/headset/heads/captain

	id_pda_assignment = "NanoTrasen Navy Captain"