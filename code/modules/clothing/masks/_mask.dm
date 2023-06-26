/*
 * Mask
 */
/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/obj/clothing/masks.dmi'
	body_parts_covered = HEAD
	slot_flags = SLOT_MASK

/obj/item/clothing/mask/proc/filter_air(datum/gas_mixture/air)
	return