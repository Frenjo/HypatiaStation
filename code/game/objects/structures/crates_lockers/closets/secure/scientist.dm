/*
 * Research Director
 */
/obj/structure/closet/secure_closet/rd
	name = "Research Director's Locker"
	req_access = list(ACCESS_RD)
	icon_state = "rdsecure1"
	icon_closed = "rdsecure"
	icon_locked = "rdsecure1"
	icon_opened = "rdsecureopen"
	icon_broken = "rdsecurebroken"
	icon_off = "rdsecureoff"

	starts_with = list(
		/obj/item/clothing/suit/bio_suit/scientist,
		/obj/item/clothing/head/bio_hood/scientist,
		/obj/item/clothing/under/rank/research_director,
		/obj/item/clothing/under/rank/research_director/rdalt,
		/obj/item/clothing/under/rank/research_director/dress_rd,
		/obj/item/clothing/suit/storage/labcoat,
		/obj/item/cartridge/rd,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/shoes/leather,
		/obj/item/clothing/gloves/latex,
		/obj/item/device/radio/headset/heads/rd,
		/obj/item/tank/air,
		/obj/item/clothing/mask/gas,
		/obj/item/device/flash
	)

/*
 * Scientist
 */
/obj/structure/closet/secure_closet/scientist
	name = "Scientist's Locker"
	req_access = list(ACCESS_TOX_STORAGE)
	icon_state = "secureres1"
	icon_closed = "secureres"
	icon_locked = "secureres1"
	icon_opened = "secureresopen"
	icon_broken = "secureresbroken"
	icon_off = "secureresoff"

	starts_with = list(
		/obj/item/clothing/under/rank/scientist,
	//	/obj/item/clothing/suit/labcoat/science,
		/obj/item/clothing/suit/storage/labcoat,
		/obj/item/clothing/shoes/white,
	//	/obj/item/cartridge/signal/toxins,
		/obj/item/device/radio/headset/sci,
		/obj/item/tank/air,
		/obj/item/clothing/mask/gas
	)