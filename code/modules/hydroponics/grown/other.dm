/*
 * Ambrosia Vulgaris
 */
/obj/item/reagent_holder/food/snacks/grown/ambrosiavulgaris
	seed = /obj/item/seeds/ambrosiavulgaris
	name = "ambrosia vulgaris branch"
	desc = "This is a plant containing various healing chemicals."
	icon_state = "ambrosiavulgaris"
	potency = 10
	filling_color = "#125709"

/obj/item/reagent_holder/food/snacks/grown/ambrosiavulgaris/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1)
	reagents.add_reagent("space_drugs", 1 + round(potency / 8, 1))
	reagents.add_reagent("kelotane", 1 + round(potency / 8, 1))
	reagents.add_reagent("bicaridine", 1 + round(potency / 10, 1))
	reagents.add_reagent("toxin", 1 + round(potency / 10, 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/*
 * Ambrosia Deus
 */
/obj/item/reagent_holder/food/snacks/grown/ambrosiadeus
	seed = /obj/item/seeds/ambrosiadeus
	name = "ambrosia deus branch"
	desc = "Eating this makes you feel immortal!"
	icon_state = "ambrosiadeus"
	potency = 10
	filling_color = "#229E11"

/obj/item/reagent_holder/food/snacks/grown/ambrosiadeus/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1)
	reagents.add_reagent("bicaridine", 1 + round(potency / 8, 1))
	reagents.add_reagent("synaptizine", 1 + round(potency / 8, 1))
	reagents.add_reagent("hyperzine", 1 + round(potency / 10, 1))
	reagents.add_reagent("space_drugs", 1 + round(potency / 10, 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/*
 * Peanut
 */
/obj/item/reagent_holder/food/snacks/grown/peanut
	seed = /obj/item/seeds/peanut
	name = "peanut"
	desc = "Nuts!"
	icon_state = "peanut"
	filling_color = "857e27"
	potency = 25

/obj/item/reagent_holder/food/snacks/grown/peanut/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 10), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)