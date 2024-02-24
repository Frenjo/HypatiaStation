/obj/structure/closet/secure/hydroponics
	name = "Botanist's locker"
	req_access = list(ACCESS_HYDROPONICS)
	icon_state = "hydrosecure1"
	icon_closed = "hydrosecure"
	icon_locked = "hydrosecure1"
	icon_opened = "hydrosecureopen"
	icon_broken = "hydrosecurebroken"
	icon_off = "hydrosecureoff"

	starts_with = list(
		/obj/item/storage/bag/plants,
		/obj/item/clothing/under/rank/hydroponics,
		/obj/item/plant_analyser,
		/obj/item/clothing/head/greenbandana,
		/obj/item/minihoe,
		/obj/item/hatchet,
		/obj/item/bee_net
	)

/obj/structure/closet/secure/hydroponics/New()
	if(prob(50))
		starts_with.Add(/obj/item/clothing/suit/apron)
	else
		starts_with.Add(/obj/item/clothing/suit/apron/overalls)
	. = ..()