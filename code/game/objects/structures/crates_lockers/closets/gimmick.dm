/*
 * Cabinet
 */
/obj/structure/closet/cabinet
	name = "cabinet"
	desc = "Old will forever be in fashion."
	icon_state = "cabinet_closed"
	icon_closed = "cabinet_closed"
	icon_opened = "cabinet_open"

/obj/structure/closet/cabinet/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened

/*
 * Alien
 */
/obj/structure/closet/acloset
	name = "strange closet"
	desc = "It looks alien!"
	icon_state = "acloset"
	icon_closed = "acloset"
	icon_opened = "aclosetopen"

/*
 * Administrative
 */
/obj/structure/closet/gimmick
	name = "administrative supply closet"
	desc = "It's a storage unit for things that have no right being here."
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"
	anchored = FALSE

/*
 * Russian
 */
/obj/structure/closet/gimmick/russian
	name = "russian surplus closet"
	desc = "It's a storage unit for Russian standard-issue surplus."
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"

	starts_with = list(
		/obj/item/clothing/head/ushanka,
		/obj/item/clothing/head/ushanka,
		/obj/item/clothing/head/ushanka,
		/obj/item/clothing/head/ushanka,
		/obj/item/clothing/head/ushanka,
		/obj/item/clothing/under/soviet,
		/obj/item/clothing/under/soviet,
		/obj/item/clothing/under/soviet,
		/obj/item/clothing/under/soviet,
		/obj/item/clothing/under/soviet
	)

/*
 * Tacticool
 */
/obj/structure/closet/gimmick/tacticool
	name = "tacticool gear closet"
	desc = "It's a storage unit for Tacticool gear."
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"

	starts_with = list(
		/obj/item/clothing/glasses/eyepatch,
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/gloves/swat,
		/obj/item/clothing/gloves/swat,
		/obj/item/clothing/head/helmet/swat,
		/obj/item/clothing/head/helmet/swat,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/shoes/swat,
		/obj/item/clothing/shoes/swat,
		/obj/item/clothing/suit/armor/swat,
		/obj/item/clothing/suit/armor/swat,
		/obj/item/clothing/under/syndicate/tacticool,
		/obj/item/clothing/under/syndicate/tacticool
	)

/*
 * Thunderdome
 */
/obj/structure/closet/thunderdome
	name = "\improper Thunderdome closet"
	desc = "Everything you need!"
	icon_state = "syndicate"
	icon_closed = "syndicate"
	icon_opened = "syndicateopen"
	anchored = TRUE

/obj/structure/closet/thunderdome/tdred
	name = "red-team Thunderdome closet"

	starts_with = list(
		/obj/item/clothing/suit/armor/tdome/red,
		/obj/item/clothing/suit/armor/tdome/red,
		/obj/item/clothing/suit/armor/tdome/red,
		/obj/item/weapon/melee/energy/sword,
		/obj/item/weapon/melee/energy/sword,
		/obj/item/weapon/melee/energy/sword,
		/obj/item/weapon/gun/energy/laser,
		/obj/item/weapon/gun/energy/laser,
		/obj/item/weapon/gun/energy/laser,
		/obj/item/weapon/melee/baton,
		/obj/item/weapon/melee/baton,
		/obj/item/weapon/melee/baton,
		/obj/item/weapon/storage/box/flashbangs,
		/obj/item/weapon/storage/box/flashbangs,
		/obj/item/weapon/storage/box/flashbangs,
		/obj/item/clothing/head/helmet/thunderdome,
		/obj/item/clothing/head/helmet/thunderdome,
		/obj/item/clothing/head/helmet/thunderdome
	)

/obj/structure/closet/thunderdome/tdgreen
	name = "green-team Thunderdome closet"
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"

	starts_with = list(
		/obj/item/clothing/suit/armor/tdome/green,
		/obj/item/clothing/suit/armor/tdome/green,
		/obj/item/clothing/suit/armor/tdome/green,
		/obj/item/weapon/melee/energy/sword,
		/obj/item/weapon/melee/energy/sword,
		/obj/item/weapon/melee/energy/sword,
		/obj/item/weapon/gun/energy/laser,
		/obj/item/weapon/gun/energy/laser,
		/obj/item/weapon/gun/energy/laser,
		/obj/item/weapon/melee/baton,
		/obj/item/weapon/melee/baton,
		/obj/item/weapon/melee/baton,
		/obj/item/weapon/storage/box/flashbangs,
		/obj/item/weapon/storage/box/flashbangs,
		/obj/item/weapon/storage/box/flashbangs,
		/obj/item/clothing/head/helmet/thunderdome,
		/obj/item/clothing/head/helmet/thunderdome,
		/obj/item/clothing/head/helmet/thunderdome
	)