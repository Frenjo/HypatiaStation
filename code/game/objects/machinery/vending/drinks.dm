/*
 * Vending Machine Types
 *
 * These contain drinks.
 */
/obj/machinery/vending/boozeomat
	name = "Booze-O-Mat"
	desc = "A technological marvel, supposedly able to mix just the mixture you'd like to drink the moment you ask for one."
	icon_state = "boozeomat"		//////////////18 drink entities below, plus the glasses, in case someone wants to edit the number of bottles
	icon_deny = "boozeomat-deny"

	req_access = list(ACCESS_BAR)

	products = list(
		/obj/item/reagent_containers/food/drinks/bottle/gin = 5, /obj/item/reagent_containers/food/drinks/bottle/whiskey = 5,
		/obj/item/reagent_containers/food/drinks/bottle/tequilla = 5, /obj/item/reagent_containers/food/drinks/bottle/vodka = 5,
		/obj/item/reagent_containers/food/drinks/bottle/vermouth = 5, /obj/item/reagent_containers/food/drinks/bottle/rum = 5,
		/obj/item/reagent_containers/food/drinks/bottle/wine = 5, /obj/item/reagent_containers/food/drinks/bottle/cognac = 5,
		/obj/item/reagent_containers/food/drinks/bottle/kahlua = 5, /obj/item/reagent_containers/food/drinks/cans/beer = 6,
		/obj/item/reagent_containers/food/drinks/cans/ale = 6, /obj/item/reagent_containers/food/drinks/bottle/orangejuice = 4,
		/obj/item/reagent_containers/food/drinks/bottle/tomatojuice = 4, /obj/item/reagent_containers/food/drinks/bottle/limejuice = 4,
		/obj/item/reagent_containers/food/drinks/bottle/cream = 4, /obj/item/reagent_containers/food/drinks/cans/tonic = 8,
		/obj/item/reagent_containers/food/drinks/cans/cola = 8, /obj/item/reagent_containers/food/drinks/cans/sodawater = 15,
		/obj/item/reagent_containers/food/drinks/flask/barflask = 2, /obj/item/reagent_containers/food/drinks/flask/vacuumflask = 2,
		/obj/item/reagent_containers/food/drinks/drinkingglass = 30, /obj/item/reagent_containers/food/drinks/ice = 9,
		/obj/item/reagent_containers/food/drinks/bottle/melonliquor = 2, /obj/item/reagent_containers/food/drinks/bottle/bluecuracao = 2,
		/obj/item/reagent_containers/food/drinks/bottle/absinthe = 2, /obj/item/reagent_containers/food/drinks/bottle/grenadine = 5
	)
	contraband = list(/obj/item/reagent_containers/food/drinks/tea = 10)

	slogan_list = list(
		"I hope nobody asks me for a bloody cup o' tea...",
		"Alcohol is humanity's friend. Would you abandon a friend?",
		"Quite delighted to serve you!",
		"Is nobody thirsty on this station?"
	)
	ad_list = list(
		"Drink up!",
		"Booze is good for you!",
		"Alcohol is humanity's best friend.",
		"Quite delighted to serve you!",
		"Care for a nice, cold beer?",
		"Nothing cures you like booze!",
		"Have a sip!", "Have a drink!", "Have a beer!",
		"Beer is good for you!",
		"Only the finest alcohol!",
		"Best quality booze since 2053!",
		"Award-winning wine!",
		"Maximum alcohol!",
		"Man loves beer.",
		"A toast for progress!"
	)

	vend_delay = 15

/obj/machinery/vending/coffee
	name = "Hot Drinks machine"
	desc = "A vending machine which dispenses hot drinks."
	icon_state = "coffee"
	icon_vend = "coffee-vend"

	products = list(
		/obj/item/reagent_containers/food/drinks/coffee = 25, /obj/item/reagent_containers/food/drinks/tea = 25,
		/obj/item/reagent_containers/food/drinks/h_chocolate = 25
	)
	contraband = list(/obj/item/reagent_containers/food/drinks/ice = 10)
	prices = list(
		/obj/item/reagent_containers/food/drinks/coffee = 25, /obj/item/reagent_containers/food/drinks/tea = 25,
		/obj/item/reagent_containers/food/drinks/h_chocolate = 25
	)

	ad_list = list(
		"Have a drink!", "Drink up!", "It's good for you!", "Would you like a hot joe?",
		"I'd kill for some coffee!", "The best beans in the galaxy.", "Only the finest brew for you.",
		"I like coffee, don't you?", "Coffee helps you work!", "Try some tea.",
		"We hope you like the best!", "Try our new chocolate!", "Admin conspiracies" // I left this last one in because it's hilarious.
	)

	vend_delay = 34

/obj/machinery/vending/cola
	name = "Robust Softdrinks"
	desc = "A softdrink vendor provided by Robust Industries, LLC."
	icon_state = "Cola_Machine"

	products = list(
		/obj/item/reagent_containers/food/drinks/cans/cola = 10, /obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 10,
		/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 10, /obj/item/reagent_containers/food/drinks/cans/starkist = 10,
		/obj/item/reagent_containers/food/drinks/cans/waterbottle = 10, /obj/item/reagent_containers/food/drinks/cans/space_up = 10,
		/obj/item/reagent_containers/food/drinks/cans/iced_tea = 10, /obj/item/reagent_containers/food/drinks/cans/grape_juice = 10
	)
	contraband = list(/obj/item/reagent_containers/food/drinks/cans/thirteenloko = 5)
	prices = list(
		/obj/item/reagent_containers/food/drinks/cans/cola = 1, /obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 1,
		/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 1, /obj/item/reagent_containers/food/drinks/cans/starkist = 1,
		/obj/item/reagent_containers/food/drinks/cans/waterbottle = 2, /obj/item/reagent_containers/food/drinks/cans/space_up = 1,
		/obj/item/reagent_containers/food/drinks/cans/iced_tea = 1, /obj/item/reagent_containers/food/drinks/cans/grape_juice = 1
	)

	slogan_list = list("Robust Softdrinks: More robust than a toolbox to the head!")
	ad_list = list(
		"Refreshing!", "Hope you're thirsty!", "Over 1 million drinks sold!",
		"Thirsty? Why not cola?", "Please, have a drink!", "Drink up!",
		"The best drinks in space."
	)

// A prefab empty version which contains just the hidden contraband items.
/obj/machinery/vending/cola/empty
	products = list(
		/obj/item/reagent_containers/food/drinks/cans/cola = 0, /obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 0,
		/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 0, /obj/item/reagent_containers/food/drinks/cans/starkist = 0,
		/obj/item/reagent_containers/food/drinks/cans/waterbottle = 0, /obj/item/reagent_containers/food/drinks/cans/space_up = 0,
		/obj/item/reagent_containers/food/drinks/cans/iced_tea = 0, /obj/item/reagent_containers/food/drinks/cans/grape_juice = 0
	)
	contraband = list(/obj/item/reagent_containers/food/drinks/cans/thirteenloko = 5)
	prices = list(
		/obj/item/reagent_containers/food/drinks/cans/cola = 1, /obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 1,
		/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 1, /obj/item/reagent_containers/food/drinks/cans/starkist = 1,
		/obj/item/reagent_containers/food/drinks/cans/waterbottle = 2, /obj/item/reagent_containers/food/drinks/cans/space_up = 1,
		/obj/item/reagent_containers/food/drinks/cans/iced_tea = 1, /obj/item/reagent_containers/food/drinks/cans/grape_juice = 1
	)

/obj/machinery/vending/sovietsoda
	name = "BODA"
	desc = "An old sweet water vending machine, how did this end up here?"
	icon_state = "sovietsoda"

	products = list(/obj/item/reagent_containers/food/drinks/drinkingglass/soda = 30)
	contraband = list(/obj/item/reagent_containers/food/drinks/drinkingglass/cola = 20)

	ad_list = list(
		"For Tsar and Country.", "Have you fulfilled your nutrition quota today?", "Very nice!",
		"We are simple people, for this is all we eat.", "If there is a person, there is a problem. If there is no person, then there is no problem."
	)