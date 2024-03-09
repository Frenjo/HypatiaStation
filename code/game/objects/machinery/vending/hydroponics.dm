/*
 * Vending Machine Types
 *
 * These are hydroponics vendors.
 */
/obj/machinery/vending/hydronutrients
	name = "\improper NutriMax"
	desc = "A plant nutrients vendor."
	icon_state = "nutri"
	icon_deny = "nutri-deny"

	products = list(
		/obj/item/beezeez = 45, /obj/item/nutrient/ez = 35, /obj/item/nutrient/l4z = 25, /obj/item/nutrient/rh = 15, /obj/item/pestspray = 20,
		/obj/item/reagent_containers/syringe = 5, /obj/item/storage/bag/plants = 5
	)
	premium = list(/obj/item/reagent_containers/glass/bottle/ammonia = 10, /obj/item/reagent_containers/glass/bottle/diethylamine = 5)

	slogan_list = list(
		"Aren't you glad you don't have to fertilize the natural way?", "Now with 50% less stink!",
		"Plants are people too!"
	)
	ad_list = list(
		"We like plants!", "Don't you want some?", "The greenest thumbs ever.",
		"We like big plants.", "Soft soil..."
	)

/obj/machinery/vending/hydroseeds
	name = "\improper MegaSeed Servitor"
	desc = "When you need seeds fast!"
	icon_state = "seeds"

	products = list(
		/obj/item/seeds/banana = 3, /obj/item/seeds/berry = 3, /obj/item/seeds/carrot = 3, /obj/item/seeds/chanterelle = 3,
		/obj/item/seeds/chili = 3, /obj/item/seeds/corn = 3, /obj/item/seeds/eggplant = 3, /obj/item/seeds/potato = 3,
		/obj/item/seeds/replicapod = 3, /obj/item/seeds/soya = 3, /obj/item/seeds/sunflower = 3, /obj/item/seeds/tomato = 3,
		/obj/item/seeds/towercap = 3, /obj/item/seeds/wheat = 3, /obj/item/seeds/apple = 3, /obj/item/seeds/poppy = 3,
		/obj/item/seeds/sugarcaneseed = 3, /obj/item/seeds/ambrosiavulgaris = 3, /obj/item/seeds/peanut = 3, /obj/item/seeds/whitebeet = 3,
		/obj/item/seeds/watermelon = 3, /obj/item/seeds/lime = 3, /obj/item/seeds/lemon = 3, /obj/item/seeds/orange = 3,
		/obj/item/seeds/grass = 3, /obj/item/seeds/cocoapod = 3, /obj/item/seeds/plumphelmet = 2, /obj/item/seeds/cabbage = 3,
		/obj/item/seeds/grape = 3, /obj/item/seeds/pumpkin = 3, /obj/item/seeds/cherry = 3, /obj/item/seeds/plastellium = 3,
		/obj/item/seeds/rice = 3
	)
	contraband = list(
		/obj/item/seeds/amanita = 2, /obj/item/seeds/glowshroom = 2, /obj/item/seeds/libertycap = 2, /obj/item/seeds/mtear = 2,
		/obj/item/seeds/nettle = 2, /obj/item/seeds/reishi = 2, /obj/item/seeds/reishi = 2, /obj/item/seeds/shand = 2
	)
	premium = list(/obj/item/toy/waterflower = 1)

	slogan_list = list(
		"THIS'S WHERE TH' SEEDS LIVE! GIT YOU SOME!", "Hands down the best seed selection on the station!",
		"Also certain mushroom varieties available, more for experts! Get certified today!"
	)
	ad_list = list(
		"We like plants!", "Grow some crops!", "Grow, baby, growww!", "Aw h'yeah son!"
	)