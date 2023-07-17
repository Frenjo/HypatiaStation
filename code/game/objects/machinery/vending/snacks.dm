/*
 * Vending Machine Types
 *
 * These have lots of yummy(?) snacks.
 */
/obj/machinery/vending/snack
	name = "Getmore Chocolate Corp"
	desc = "A snack machine courtesy of the Getmore Chocolate Corporation, based out of Mars."
	icon_state = "snack"

	products = list(
		/obj/item/reagent_containers/food/snacks/candy = 6, /obj/item/reagent_containers/food/drinks/dry_ramen = 6,
		/obj/item/reagent_containers/food/snacks/chips = 6, /obj/item/reagent_containers/food/snacks/sosjerky = 6,
		/obj/item/reagent_containers/food/snacks/no_raisin = 6, /obj/item/reagent_containers/food/snacks/spacetwinkie = 6,
		/obj/item/reagent_containers/food/snacks/cheesiehonkers = 6
	)
	contraband = list(/obj/item/reagent_containers/food/snacks/syndicake = 6)
	prices = list(
		/obj/item/reagent_containers/food/snacks/candy = 1, /obj/item/reagent_containers/food/drinks/dry_ramen = 5,
		/obj/item/reagent_containers/food/snacks/chips = 1, /obj/item/reagent_containers/food/snacks/sosjerky = 2,
		/obj/item/reagent_containers/food/snacks/no_raisin = 1, /obj/item/reagent_containers/food/snacks/spacetwinkie = 1,
		/obj/item/reagent_containers/food/snacks/cheesiehonkers = 1
	)

	slogan_list = list(
		"Try our new nougat bar!",
		"Twice the calories for half the price!"
	)
	ad_list = list(
		"The healthiest!", "Award-winning chocolate bars!", "Mmm! So good!",
		"Oh my god it's so juicy!", "Have a snack.", "Snacks are good for you!",
		"Have some more Getmore!", "Best quality snacks straight from Mars.",
		"We love chocolate!", "Try our new jerky!"
	)

// A prefab empty version which contains just the hidden contraband items.
/obj/machinery/vending/snack/empty
	products = list(
		/obj/item/reagent_containers/food/snacks/candy = 0, /obj/item/reagent_containers/food/drinks/dry_ramen = 0,
		/obj/item/reagent_containers/food/snacks/chips = 0, /obj/item/reagent_containers/food/snacks/sosjerky = 0,
		/obj/item/reagent_containers/food/snacks/no_raisin = 0, /obj/item/reagent_containers/food/snacks/spacetwinkie = 0,
		/obj/item/reagent_containers/food/snacks/cheesiehonkers = 0
	)
	contraband = list(/obj/item/reagent_containers/food/snacks/syndicake = 6)
	prices = list(
		/obj/item/reagent_containers/food/snacks/candy = 1, /obj/item/reagent_containers/food/drinks/dry_ramen = 5,
		/obj/item/reagent_containers/food/snacks/chips = 1, /obj/item/reagent_containers/food/snacks/sosjerky = 2,
		/obj/item/reagent_containers/food/snacks/no_raisin = 1, /obj/item/reagent_containers/food/snacks/spacetwinkie = 1,
		/obj/item/reagent_containers/food/snacks/cheesiehonkers = 1
	)