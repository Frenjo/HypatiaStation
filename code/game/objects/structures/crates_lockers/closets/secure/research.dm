/*
 * Scientist
 */
/obj/structure/closet/secure/scientist
	name = "scientist's locker"
	req_access = list(ACCESS_RESEARCH)
	icon_state = "secureres1"
	icon_closed = "secureres"
	icon_locked = "secureres1"
	icon_opened = "secureresopen"
	icon_broken = "secureresbroken"
	icon_off = "secureresoff"

	starts_with = list(
		/obj/item/wardrobe/scientist,
		/obj/item/pda/toxins,
		/obj/item/tank/oxygen,
		/obj/item/clothing/mask/gas,
		/obj/item/radio/headset/headset_sci
	)

/obj/structure/closet/secure/scientist/New()
	. = ..()
	var/obj/item/storage/backpack/BPK = new /obj/item/storage/backpack(src)
	var/obj/item/storage/box/B = new(BPK)
	new /obj/item/pen(B)

/*
 * Research Director
 */
/obj/structure/closet/secure/rd
	name = "research director's locker"
	req_access = list(ACCESS_RD)
	icon_state = "rdsecure1"
	icon_closed = "rdsecure"
	icon_locked = "rdsecure1"
	icon_opened = "rdsecureopen"
	icon_broken = "rdsecurebroken"
	icon_off = "rdsecureoff"

	starts_with = list(
		/obj/item/wardrobe/rd,
		/obj/item/clipboard,
		/obj/item/tank/air,
		/obj/item/clothing/mask/gas,
		/obj/item/flash,
		/obj/item/radio/headset/heads/rd
	)

/obj/structure/closet/secure/rd/New()
	. = ..()
	var/obj/item/storage/backpack/BPK = new /obj/item/storage/backpack(src)
	var/obj/item/storage/box/B = new(BPK)
	new /obj/item/pen(B)