/obj/structure/closet/secure_closet/hydroponics
	name = "Botanist's locker"
	req_access = list(ACCESS_HYDROPONICS)
	icon_state = "hydrosecure1"
	icon_closed = "hydrosecure"
	icon_locked = "hydrosecure1"
	icon_opened = "hydrosecureopen"
	icon_broken = "hydrosecurebroken"
	icon_off = "hydrosecureoff"

	starts_with = list(
		/obj/item/weapon/storage/bag/plants,
		/obj/item/clothing/under/rank/hydroponics,
		/obj/item/device/analyzer/plant_analyzer,
		/obj/item/clothing/head/greenbandana,
		/obj/item/weapon/minihoe,
		/obj/item/weapon/hatchet,
		/obj/item/weapon/bee_net
	)

/obj/structure/closet/secure_closet/hydroponics/New()
	if(prob(50))
		starts_with.Add(/obj/item/clothing/suit/apron)
	else
		starts_with.Add(/obj/item/clothing/suit/apron/overalls)
	. = ..()