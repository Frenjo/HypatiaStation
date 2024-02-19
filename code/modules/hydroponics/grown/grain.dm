/*
 * Corn
 */
/obj/item/reagent_containers/food/snacks/grown/corn
	seed = /obj/item/seeds/corn
	name = "ear of corn"
	desc = "Needs some butter!"
	icon_state = "corn"
	potency = 40
	filling_color = "#FFEE00"
	trash = /obj/item/corncob

//So potency can be set in the proc that creates these crops
/obj/item/reagent_containers/food/snacks/grown/corn/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 10), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/*
 * Wheat
 */
/obj/item/reagent_containers/food/snacks/grown/wheat
	seed = /obj/item/seeds/wheat
	name = "wheat"
	desc = "Sigh... wheat... a-grain?"
	gender = PLURAL
	icon_state = "wheat"
	filling_color = "#F7E186"

/obj/item/reagent_containers/food/snacks/grown/wheat/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 25), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/*
 * Rice
 */
/obj/item/reagent_containers/food/snacks/grown/ricestalk
	seed = /obj/item/seeds/rice
	name = "rice stalk"
	desc = "Rice to see you."
	gender = PLURAL
	icon_state = "rice"
	filling_color = "#FFF8DB"

/obj/item/reagent_containers/food/snacks/grown/ricestalk/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 25), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)