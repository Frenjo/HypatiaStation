/obj/structure/closet/secure_closet/freezer/update_icon()
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
/obj/structure/closet/secure_closet/freezer/kitchen
	name = "Kitchen Cabinet"
	req_access = list(ACCESS_KITCHEN)

	starts_with = list(
		/obj/item/weapon/reagent_containers/food/condiment/sugar,
		/obj/item/weapon/reagent_containers/food/snacks/flour,
		/obj/item/weapon/reagent_containers/food/snacks/flour,
		/obj/item/weapon/reagent_containers/food/snacks/flour,
		/obj/item/weapon/reagent_containers/food/snacks/flour,
		/obj/item/weapon/reagent_containers/food/snacks/flour,
		/obj/item/weapon/reagent_containers/food/snacks/flour,
		/obj/item/weapon/reagent_containers/food/snacks/meat/monkey,
		/obj/item/weapon/reagent_containers/food/snacks/meat/monkey,
		/obj/item/weapon/reagent_containers/food/snacks/meat/monkey
	)

/obj/structure/closet/secure_closet/freezer/kitchen/mining
	req_access = list()

/*
 * Meat
 */
/obj/structure/closet/secure_closet/freezer/meat
	name = "Meat Fridge"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridge1"

	starts_with = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/monkey,
		/obj/item/weapon/reagent_containers/food/snacks/meat/monkey,
		/obj/item/weapon/reagent_containers/food/snacks/meat/monkey,
		/obj/item/weapon/reagent_containers/food/snacks/meat/monkey
	)

/*
 * Fridge
 */
/obj/structure/closet/secure_closet/freezer/fridge
	name = "Refrigerator"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridge1"

	starts_with = list(
		/obj/item/weapon/reagent_containers/food/drinks/milk,
		/obj/item/weapon/reagent_containers/food/drinks/milk,
		/obj/item/weapon/reagent_containers/food/drinks/milk,
		/obj/item/weapon/reagent_containers/food/drinks/milk,
		/obj/item/weapon/reagent_containers/food/drinks/milk,
		/obj/item/weapon/reagent_containers/food/drinks/soymilk,
		/obj/item/weapon/reagent_containers/food/drinks/soymilk,
		/obj/item/weapon/reagent_containers/food/drinks/soymilk,
		/obj/item/weapon/storage/fancy/egg_box,
		/obj/item/weapon/storage/fancy/egg_box
	)

/*
 * Money
 */
/obj/structure/closet/secure_closet/freezer/money
	name = "Freezer"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridge1"
	req_access = list(ACCESS_HEADS_VAULT)

	starts_with = list(
		/obj/item/weapon/spacecash/c1000,
		/obj/item/weapon/spacecash/c1000,
		/obj/item/weapon/spacecash/c1000,
		/obj/item/weapon/spacecash/c500,
		/obj/item/weapon/spacecash/c500,
		/obj/item/weapon/spacecash/c500,
		/obj/item/weapon/spacecash/c500,
		/obj/item/weapon/spacecash/c500,
		/obj/item/weapon/spacecash/c200,
		/obj/item/weapon/spacecash/c200,
		/obj/item/weapon/spacecash/c200,
		/obj/item/weapon/spacecash/c200,
		/obj/item/weapon/spacecash/c200,
		/obj/item/weapon/spacecash/c200
	)