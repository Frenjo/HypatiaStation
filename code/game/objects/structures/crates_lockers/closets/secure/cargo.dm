/*
 * Cargo Technician
 */
/obj/structure/closet/secure_closet/cargotech
	name = "Cargo Technician's Locker"
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
		/obj/item/device/radio/headset/headset_cargo,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/head/soft
	)

/*
 * Mailman
 */
/obj/structure/closet/secure_closet/mailman
	name = "Mailman's Locker"
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
		/obj/item/device/radio/headset/headset_cargo,
		/obj/item/clothing/gloves/blue,
		/obj/item/clothing/head/mailman,
		/obj/item/weapon/tank/air,
		/obj/item/clothing/mask/gas,
		/obj/item/device/flashlight,
		/obj/item/clothing/suit/space/mailmanvoid,
		/obj/item/clothing/head/helmet/space/mailmanvoid,
		/obj/item/clothing/glasses/science
	)

/*
 * Quartermaster
 */
/obj/structure/closet/secure_closet/quartermaster
	name = "Quartermaster's Locker"
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
		/obj/item/device/radio/headset/headset_cargo,
		/obj/item/clothing/gloves/black,
		/obj/item/device/radio/headset/headset_qm,
		/obj/item/weapon/cartridge/quartermaster,
		/obj/item/clothing/suit/fire/firefighter,
		/obj/item/weapon/tank/emergency_oxygen,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/glasses/meson,
		/obj/item/clothing/head/soft
	)