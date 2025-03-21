/*
 * Booze Cabinet
 */
/obj/structure/closet/secure/bar
	name = "Booze"
	req_access = list(ACCESS_BAR)
	icon_state = "cabinetdetective_locked"
	icon_closed = "cabinetdetective"
	icon_locked = "cabinetdetective_locked"
	icon_opened = "cabinetdetective_open"
	icon_broken = "cabinetdetective_broken"
	icon_off = "cabinetdetective_broken"

	starts_with = list(
		/obj/item/reagent_holder/food/drinks/cans/beer,
		/obj/item/reagent_holder/food/drinks/cans/beer,
		/obj/item/reagent_holder/food/drinks/cans/beer,
		/obj/item/reagent_holder/food/drinks/cans/beer,
		/obj/item/reagent_holder/food/drinks/cans/beer,
		/obj/item/reagent_holder/food/drinks/cans/beer,
		/obj/item/reagent_holder/food/drinks/cans/beer,
		/obj/item/reagent_holder/food/drinks/cans/beer,
		/obj/item/reagent_holder/food/drinks/cans/beer,
		/obj/item/reagent_holder/food/drinks/cans/beer
	)

/obj/structure/closet/secure/bar/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened