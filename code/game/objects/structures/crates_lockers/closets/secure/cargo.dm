/obj/structure/closet/secure_closet/cargotech
	name = "Cargo Technician's Locker"
	req_access = list(access_cargo)
	icon_state = "securecargo1"
	icon_closed = "securecargo"
	icon_locked = "securecargo1"
	icon_opened = "securecargoopen"
	icon_broken = "securecargobroken"
	icon_off = "securecargooff"

/obj/structure/closet/secure_closet/cargotech/New()
	..()
	new /obj/item/clothing/under/rank/cargotech(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/device/radio/headset/headset_cargo(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/clothing/head/soft(src)


/obj/structure/closet/secure_closet/mailman
	name = "Mailman's Locker"
	req_access = list(access_cargo)
	icon_state = "securemailman1"
	icon_closed = "securemailman"
	icon_locked = "securemailman1"
	icon_opened = "securemailmanopen"
	icon_broken = "securemailmanbroken"
	icon_off = "securemailmanoff"

/obj/structure/closet/secure_closet/mailman/New()
	..()
	new /obj/item/clothing/under/rank/mailman(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/device/radio/headset/headset_cargo(src)
	new /obj/item/clothing/gloves/blue(src)
	new /obj/item/clothing/head/mailman(src)
	new /obj/item/weapon/tank/air(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/device/flashlight(src)
	new /obj/item/clothing/suit/space/mailmanvoid(src)
	new /obj/item/clothing/head/helmet/space/mailmanvoid(src)
	new /obj/item/clothing/glasses/science(src)


/obj/structure/closet/secure_closet/quartermaster
	name = "Quartermaster's Locker"
	req_access = list(access_qm)
	icon_state = "secureqm1"
	icon_closed = "secureqm"
	icon_locked = "secureqm1"
	icon_opened = "secureqmopen"
	icon_broken = "secureqmbroken"
	icon_off = "secureqmoff"

/obj/structure/closet/secure_closet/quartermaster/New()
	..()
	new /obj/item/clothing/under/rank/cargo(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/device/radio/headset/headset_cargo(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/device/radio/headset/headset_qm(src)
	new /obj/item/weapon/cartridge/quartermaster(src)
	new /obj/item/clothing/suit/fire/firefighter(src)
	new /obj/item/weapon/tank/emergency_oxygen(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/clothing/head/soft(src)