///////////////////////////////////////////////////////////////////////////////////
/datum/chemical_reaction/grapesoda
	name = "Grape Soda"
	result = /datum/reagent/drink/grapesoda
	required_reagents = alist(/datum/reagent/drink/cold/space_cola = 1, /datum/reagent/drink/grapejuice = 2)
	result_amount = 3

/datum/chemical_reaction/grenadine
	name = "Grenadine Syrup"
	result = /datum/reagent/drink/grenadine
	required_reagents = alist(/datum/reagent/drink/berryjuice = 10)
	required_catalysts = alist(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/hot_coco
	name = "Hot Coco"
	result = /datum/reagent/drink/hot_coco
	required_reagents = alist(/datum/reagent/coco = 1, /datum/reagent/water = 5)
	result_amount = 5

/datum/chemical_reaction/icecoffee
	name = "Iced Coffee"
	result = /datum/reagent/drink/coffee/icecoffee
	required_reagents = alist(/datum/reagent/drink/coffee = 3, /datum/reagent/drink/cold/ice = 1)
	result_amount = 4

/datum/chemical_reaction/soy_latte
	name = "Soy Latte"
	result = /datum/reagent/drink/coffee/soy_latte
	required_reagents = alist(/datum/reagent/drink/coffee = 1, /datum/reagent/drink/milk/soymilk = 1)
	result_amount = 2

/datum/chemical_reaction/cafe_latte
	name = "Cafe Latte"
	result = /datum/reagent/drink/coffee/cafe_latte
	required_reagents = alist(/datum/reagent/drink/coffee = 1, /datum/reagent/drink/milk = 1)
	result_amount = 2

/datum/chemical_reaction/icetea
	name = "Iced Tea"
	result = /datum/reagent/drink/tea/icetea
	required_reagents = alist(/datum/reagent/drink/cold/ice = 1, /datum/reagent/drink/tea = 3)
	result_amount = 4

/datum/chemical_reaction/nuka_cola
	name = "Nuka Cola"
	result = /datum/reagent/drink/cold/nuka_cola
	required_reagents = alist(/datum/reagent/drink/cold/space_cola = 6, /datum/reagent/uranium = 1)
	result_amount = 6

/datum/chemical_reaction/lemonade
	name = "Lemonade"
	result = /datum/reagent/drink/cold/lemonade
	required_reagents = alist(/datum/reagent/drink/lemonjuice = 1, /datum/reagent/sugar = 1, /datum/reagent/water = 1)
	result_amount = 3

/datum/chemical_reaction/kiraspecial
	name = "Kira Special"
	result = /datum/reagent/drink/cold/kiraspecial
	required_reagents = alist(/datum/reagent/drink/limejuice = 1, /datum/reagent/drink/orangejuice = 1, /datum/reagent/drink/cold/sodawater = 1)
	result_amount = 2

/datum/chemical_reaction/brownstar
	name = "Brown Star"
	result = /datum/reagent/drink/cold/brownstar
	required_reagents = alist(/datum/reagent/drink/cold/space_cola = 1, /datum/reagent/drink/orangejuice = 1)
	result_amount = 2

/datum/chemical_reaction/milkshake
	name = "Milkshake"
	result = /datum/reagent/drink/cold/milkshake
	required_reagents = alist(/datum/reagent/drink/milk/cream = 1, /datum/reagent/drink/cold/ice = 2, /datum/reagent/drink/milk = 2)
	result_amount = 5

/datum/chemical_reaction/rewriter
	name = "Rewriter"
	result = /datum/reagent/drink/cold/rewriter
	required_reagents = alist(/datum/reagent/drink/coffee = 1, /datum/reagent/drink/cold/spacemountainwind = 1)
	result_amount = 2

/datum/chemical_reaction/doctor_delight
	name = "The Doctor's Delight"
	result = /datum/reagent/doctor_delight
	required_reagents = alist(
		/datum/reagent/drink/milk/cream = 1, /datum/reagent/drink/limejuice = 1, /datum/reagent/drink/orangejuice = 1,
		/datum/reagent/drink/tomatojuice = 1, /datum/reagent/tricordrazine = 1
	)
	result_amount = 5