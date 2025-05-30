/obj/structure/closet/secure/freezer/update_icon()
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

/*
 * Kitchen
 */
/obj/structure/closet/secure/freezer/kitchen
	name = "kitchen cabinet"
	req_access = list(ACCESS_KITCHEN)

	starts_with = list(
		/obj/item/reagent_holder/food/condiment/sugar,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/meat/monkey,
		/obj/item/reagent_holder/food/snacks/meat/monkey,
		/obj/item/reagent_holder/food/snacks/meat/monkey
	)

/obj/structure/closet/secure/freezer/kitchen/mining
	req_access = list()

/*
 * Meat
 */
/obj/structure/closet/secure/freezer/meat
	name = "meat fridge"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridge1"

	starts_with = list(
		/obj/item/reagent_holder/food/snacks/meat/monkey,
		/obj/item/reagent_holder/food/snacks/meat/monkey,
		/obj/item/reagent_holder/food/snacks/meat/monkey,
		/obj/item/reagent_holder/food/snacks/meat/monkey
	)

/*
 * Fridge
 */
/obj/structure/closet/secure/freezer/fridge
	name = "refrigerator"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridge1"

	starts_with = list(
		/obj/item/reagent_holder/food/drinks/milk,
		/obj/item/reagent_holder/food/drinks/milk,
		/obj/item/reagent_holder/food/drinks/milk,
		/obj/item/reagent_holder/food/drinks/milk,
		/obj/item/reagent_holder/food/drinks/milk,
		/obj/item/reagent_holder/food/drinks/soymilk,
		/obj/item/reagent_holder/food/drinks/soymilk,
		/obj/item/reagent_holder/food/drinks/soymilk,
		/obj/item/storage/fancy/egg_box,
		/obj/item/storage/fancy/egg_box
	)

/*
 * Money
 */
/obj/structure/closet/secure/freezer/money
	name = "freezer"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridge1"
	req_access = list(ACCESS_HEADS_VAULT)

	starts_with = list(
		/obj/item/cash/c1000,
		/obj/item/cash/c1000,
		/obj/item/cash/c1000,
		/obj/item/cash/c500,
		/obj/item/cash/c500,
		/obj/item/cash/c500,
		/obj/item/cash/c500,
		/obj/item/cash/c500,
		/obj/item/cash/c200,
		/obj/item/cash/c200,
		/obj/item/cash/c200,
		/obj/item/cash/c200,
		/obj/item/cash/c200,
		/obj/item/cash/c200
	)