///////////////////////////////////////////////////////////////////////////////////
/datum/chemical_reaction/grapesoda
	name = "Grape Soda"
	result = /datum/reagent/drink/grapesoda
	required_reagents = list("grapejuice" = 2, "cola" = 1)
	result_amount = 3

/datum/chemical_reaction/grenadine
	name = "Grenadine Syrup"
	result = /datum/reagent/drink/grenadine
	required_reagents = list("berryjuice" = 10)
	required_catalysts = list("enzyme" = 5)
	result_amount = 10

/datum/chemical_reaction/hot_coco
	name = "Hot Coco"
	result = /datum/reagent/drink/hot_coco
	required_reagents = list("water" = 5, "coco" = 1)
	result_amount = 5

/datum/chemical_reaction/icecoffee
	name = "Iced Coffee"
	result = /datum/reagent/drink/coffee/icecoffee
	required_reagents = list("ice" = 1, "coffee" = 3)
	result_amount = 4

/datum/chemical_reaction/soy_latte
	name = "Soy Latte"
	result = /datum/reagent/drink/coffee/soy_latte
	required_reagents = list("coffee" = 1, "soymilk" = 1)
	result_amount = 2

/datum/chemical_reaction/cafe_latte
	name = "Cafe Latte"
	result = /datum/reagent/drink/coffee/cafe_latte
	required_reagents = list("coffee" = 1, "milk" = 1)
	result_amount = 2

/datum/chemical_reaction/icetea
	name = "Iced Tea"
	result = /datum/reagent/drink/tea/icetea
	required_reagents = list("ice" = 1, "tea" = 3)
	result_amount = 4

/datum/chemical_reaction/nuka_cola
	name = "Nuka Cola"
	result = /datum/reagent/drink/cold/nuka_cola
	required_reagents = list("uranium" = 1, "cola" = 6)
	result_amount = 6

/datum/chemical_reaction/lemonade
	name = "Lemonade"
	result = /datum/reagent/drink/cold/lemonade
	required_reagents = list("lemonjuice" = 1, "sugar" = 1, "water" = 1)
	result_amount = 3

/datum/chemical_reaction/kiraspecial
	name = "Kira Special"
	result = /datum/reagent/drink/cold/kiraspecial
	required_reagents = list("orangejuice" = 1, "limejuice" = 1, "sodawater" = 1)
	result_amount = 2

/datum/chemical_reaction/brownstar
	name = "Brown Star"
	result = /datum/reagent/drink/cold/brownstar
	required_reagents = list("orangejuice" = 2, "cola" = 1)
	result_amount = 2

/datum/chemical_reaction/milkshake
	name = "Milkshake"
	result = /datum/reagent/drink/cold/milkshake
	required_reagents = list("cream" = 1, "ice" = 2, "milk" = 2)
	result_amount = 5

/datum/chemical_reaction/rewriter
	name = "Rewriter"
	result = /datum/reagent/drink/cold/rewriter
	required_reagents = list("spacemountainwind" = 1, "coffee" = 1)
	result_amount = 2

/datum/chemical_reaction/doctor_delight
	name = "The Doctor's Delight"
	result = /datum/reagent/doctor_delight
	required_reagents = list("limejuice" = 1, "tomatojuice" = 1, "orangejuice" = 1, "cream" = 1, "tricordrazine" = 1)
	result_amount = 5
