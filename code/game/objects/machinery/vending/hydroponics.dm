/*
 * Vending Machine Types
 *
 * These are hydroponics vendors.
 */
/obj/machinery/vending/hydronutrients
	name = "NutriMax"
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
	name = "MegaSeed Servitor"
	desc = "When you need seeds fast!"
	icon_state = "seeds"

	products = list(
		/obj/item/seeds/bananaseed = 3, /obj/item/seeds/berryseed = 3, /obj/item/seeds/carrotseed = 3, /obj/item/seeds/chantermycelium = 3,
		/obj/item/seeds/chiliseed = 3, /obj/item/seeds/cornseed = 3, /obj/item/seeds/eggplantseed = 3, /obj/item/seeds/potatoseed = 3,
		/obj/item/seeds/replicapod = 3, /obj/item/seeds/soyaseed = 3, /obj/item/seeds/sunflowerseed = 3, /obj/item/seeds/tomatoseed = 3,
		/obj/item/seeds/towermycelium = 3, /obj/item/seeds/wheatseed = 3, /obj/item/seeds/appleseed = 3, /obj/item/seeds/poppyseed = 3,
		/obj/item/seeds/sugarcaneseed = 3, /obj/item/seeds/ambrosiavulgarisseed = 3, /obj/item/seeds/peanutseed = 3, /obj/item/seeds/whitebeetseed = 3,
		/obj/item/seeds/watermelonseed = 3, /obj/item/seeds/limeseed = 3, /obj/item/seeds/lemonseed = 3, /obj/item/seeds/orangeseed = 3,
		/obj/item/seeds/grassseed = 3, /obj/item/seeds/cocoapodseed = 3, /obj/item/seeds/plumpmycelium = 2, /obj/item/seeds/cabbageseed = 3,
		/obj/item/seeds/grapeseed = 3, /obj/item/seeds/pumpkinseed = 3, /obj/item/seeds/cherryseed = 3, /obj/item/seeds/plastiseed = 3,
		/obj/item/seeds/riceseed = 3
	)
	contraband = list(
		/obj/item/seeds/amanitamycelium = 2, /obj/item/seeds/glowshroom = 2, /obj/item/seeds/libertymycelium = 2, /obj/item/seeds/mtearseed = 2,
		/obj/item/seeds/nettleseed = 2, /obj/item/seeds/reishimycelium = 2, /obj/item/seeds/reishimycelium = 2, /obj/item/seeds/shandseed = 2
	)
	premium = list(/obj/item/toy/waterflower = 1)

	slogan_list = list(
		"THIS'S WHERE TH' SEEDS LIVE! GIT YOU SOME!", "Hands down the best seed selection on the station!",
		"Also certain mushroom varieties available, more for experts! Get certified today!"
	)
	ad_list = list(
		"We like plants!", "Grow some crops!", "Grow, baby, growww!", "Aw h'yeah son!"
	)