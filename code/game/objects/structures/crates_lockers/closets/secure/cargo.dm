/*
 * Cargo Technician
 */
/obj/structure/closet/secure/cargotech
	name = "cargo technician's locker"
	req_access = list(ACCESS_CARGO)
	icon_state = "securecargo1"
	icon_closed = "securecargo"
	icon_locked = "securecargo1"
	icon_opened = "securecargoopen"
	icon_broken = "securecargobroken"
	icon_off = "securecargooff"

	starts_with = list(
		/obj/item/clothing/under/rank/cargotech,
		/obj/item/clothing/shoes/black,
		/obj/item/radio/headset/cargo,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/head/soft
	)

/*
 * Mailman
 */
/obj/structure/closet/secure/mailman
	name = "mailman's locker"
	req_access = list(ACCESS_CARGO)
	icon_state = "securemailman1"
	icon_closed = "securemailman"
	icon_locked = "securemailman1"
	icon_opened = "securemailmanopen"
	icon_broken = "securemailmanbroken"
	icon_off = "securemailmanoff"

	starts_with = list(
		/obj/item/clothing/under/rank/mailman,
		/obj/item/clothing/shoes/black,
		/obj/item/radio/headset/cargo,
		/obj/item/clothing/gloves/blue,
		/obj/item/clothing/head/mailman,
		/obj/item/tank/air,
		/obj/item/clothing/mask/gas,
		/obj/item/flashlight,
		/obj/item/clothing/suit/space/mailmanvoid,
		/obj/item/clothing/head/helmet/space/mailmanvoid,
		/obj/item/clothing/glasses/science
	)

/*
 * Quartermaster
 */
/obj/structure/closet/secure/quartermaster
	name = "quartermaster's locker"
	req_access = list(ACCESS_QM)
	icon_state = "secureqm1"
	icon_closed = "secureqm"
	icon_locked = "secureqm1"
	icon_opened = "secureqmopen"
	icon_broken = "secureqmbroken"
	icon_off = "secureqmoff"

	starts_with = list(
		/obj/item/clothing/under/rank/cargo,
		/obj/item/clothing/shoes/brown,
		/obj/item/radio/headset/cargo,
		/obj/item/clothing/gloves/black,
		/obj/item/radio/headset/qm,
		/obj/item/cartridge/quartermaster,
		/obj/item/clothing/suit/fire/firefighter,
		/obj/item/tank/emergency/oxygen,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/glasses/meson,
		/obj/item/clothing/head/soft
	)