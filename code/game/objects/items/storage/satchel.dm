/*
 * Satchel Types
 */
/obj/item/storage/satchel
	name = "leather satchel"
	desc = "It's a very fancy satchel made with fine leather."
	icon = 'icons/obj/storage/satchel.dmi'
	icon_state = "satchel"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = SLOT_BACK
	max_w_class = WEIGHT_CLASS_NORMAL
	max_combined_w_class = 21

/obj/item/storage/satchel/withwallet
	starts_with = list(
		/obj/item/storage/wallet/random
	)

/obj/item/storage/satchel/norm
	name = "satchel"
	desc = "A trendy looking satchel."
	icon_state = "satchel-norm"

/obj/item/storage/satchel/eng
	name = "industrial satchel"
	desc = "A tough satchel with extra pockets."
	icon_state = "satchel-eng"
	item_state = "engiepack"

/obj/item/storage/satchel/med
	name = "medical satchel"
	desc = "A sterile satchel used in medical departments."
	icon_state = "satchel-med"
	item_state = "medicalpack"

/obj/item/storage/satchel/vir
	name = "virology satchel"
	desc = "A sterile satchel in virology colours."
	icon_state = "satchel-vir"

/obj/item/storage/satchel/chem
	name = "chemistry satchel"
	desc = "A sterile satchel in chemistry colours."
	icon_state = "satchel-chem"

/obj/item/storage/satchel/gen
	name = "genetics satchel"
	desc = "A sterile satchel in genetics colours."
	icon_state = "satchel-gen"

/obj/item/storage/satchel/tox
	name = "science satchel"
	desc = "Useful for holding research materials."
	icon_state = "satchel-tox"

/obj/item/storage/satchel/sec
	name = "security satchel"
	desc = "A robust satchel for security related needs."
	icon_state = "satchel-sec"
	item_state = "securitypack"

/obj/item/storage/satchel/hyd
	name = "hydroponics satchel"
	desc = "A green satchel for plant related work."
	icon_state = "satchel_hyd"

/obj/item/storage/satchel/cap
	name = "captain's satchel"
	desc = "An exclusive satchel for NanoTrasen officers."
	icon_state = "satchel-cap"
	item_state = "captainpack"