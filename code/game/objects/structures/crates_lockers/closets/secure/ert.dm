/*
 * ERT Commander
 */
/obj/structure/closet/secure_closet/ert/commander
	name = "\improper ERT commander locker"
	req_access = list(ACCESS_SECURITY)
	icon_state = "capsecure1"
	icon_closed = "capsecure"
	icon_locked = "capsecure1"
	icon_opened = "capsecureopen"
	icon_broken = "capsecurebroken"
	icon_off = "capsecureoff"

	starts_with = list(
		/obj/item/clothing/head/helmet/space/ert/commander,
		/obj/item/clothing/suit/space/ert/commander,
		/obj/item/plastique,
		/obj/item/storage/belt/security/full,
		/obj/item/gun/energy/ion,
		/obj/item/gun/energy/gun/nuclear,
		/obj/item/clothing/glasses/thermal,
		/obj/item/lighter/zippo,
		/obj/item/pinpointer
	)

/*
 * ERT Security
 */
/obj/structure/closet/secure_closet/ert/security
	name = "\improper ERT security locker"
	req_access = list(ACCESS_SECURITY)
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"

	starts_with = list(
		/obj/item/clothing/head/helmet/space/ert/security,
		/obj/item/clothing/suit/space/ert/security,
		/obj/item/plastique,
		/obj/item/storage/belt/security/full,
		/obj/item/gun/energy/ion,
		/obj/item/gun/energy/gun/nuclear,
		/obj/item/clothing/glasses/thermal
	)

/*
 * ERT Engineer
 */
/obj/structure/closet/secure_closet/ert/engineer
	name = "\improper ERT engineer locker"
	req_access = list(ACCESS_ENGINE)
	icon_state = "secureeng1"
	icon_closed = "secureeng"
	icon_locked = "secureeng1"
	icon_opened = "secureengopen"
	icon_broken = "secureengbroken"
	icon_off = "secureengoff"

	starts_with = list(
		/obj/item/clothing/head/helmet/space/ert/engineer,
		/obj/item/clothing/suit/space/ert/engineer,
		/obj/item/gun/energy/taser,
		/obj/item/storage/belt/utility/full,
		/obj/item/storage/backpack/industrial/full,
		/obj/item/device/t_scanner,
		/obj/item/clothing/glasses/meson
	)

/*
 * ERT Medical
 */
/obj/structure/closet/secure_closet/ert/medical
	name = "\improper ERT medical locker"
	req_access = list(ACCESS_MEDICAL)
	icon_state = "securemed1"
	icon_closed = "securemed"
	icon_locked = "securemed1"
	icon_opened = "securemedopen"
	icon_broken = "securemedbroken"
	icon_off = "securemedoff"

	starts_with = list(
		/obj/item/clothing/head/helmet/space/ert/medical,
		/obj/item/clothing/suit/space/ert/medical,
		/obj/item/gun/energy/taser,
		/obj/item/storage/backpack/medic/full,
		/obj/item/storage/belt/medical,
		/obj/item/clothing/glasses/hud/health
	)