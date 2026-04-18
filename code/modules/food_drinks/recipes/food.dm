///////////////////////////////////////////////////////////////////////////////////
// Added recipe for stokaline here, basically nutriment and some carbon, salt and sugar.
// It's above lipozine because that's where the definition in Chemistry-Reagents is. -Frenjo
/datum/chemical_reaction/stokaline
	name = "Stokaline"
	result = /datum/reagent/stokaline
	required_reagents = alist(/datum/reagent/carbon = 1, /datum/reagent/nutriment = 3, /datum/reagent/sodiumchloride = 1, /datum/reagent/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/lipozine
	name = "Lipozine"
	result = /datum/reagent/lipozine
	required_reagents = alist(/datum/reagent/ethanol = 1, /datum/reagent/radium = 1, /datum/reagent/sodiumchloride = 1)
	result_amount = 3

/datum/chemical_reaction/soysauce
	name = "Soy Sauce"
	result = /datum/reagent/soysauce
	required_reagents = alist(/datum/reagent/drink/milk/soymilk = 4, /datum/reagent/toxin/acid = 1)
	result_amount = 5

/datum/chemical_reaction/condensedcapsaicin
	name = "Condensed Capsaicin"
	result = /datum/reagent/condensedcapsaicin
	required_reagents = alist(/datum/reagent/capsaicin = 2)
	required_catalysts = alist(/datum/reagent/plasma = 5)
	result_amount = 1

/datum/chemical_reaction/sodiumchloride
	name = "Sodium Chloride"
	result = /datum/reagent/sodiumchloride
	required_reagents = alist(/datum/reagent/chlorine = 1, /datum/reagent/sodium = 1)
	result_amount = 2

/datum/chemical_reaction/hot_ramen
	name = "Hot Ramen"
	result = /datum/reagent/hot_ramen
	required_reagents = alist(/datum/reagent/dry_ramen = 3, /datum/reagent/water = 1)
	result_amount = 3

/datum/chemical_reaction/hell_ramen
	name = "Hell Ramen"
	result = /datum/reagent/hell_ramen
	required_reagents = alist(/datum/reagent/capsaicin = 1, /datum/reagent/hot_ramen = 6)
	result_amount = 6

//////////////////////////////////////////FOOD MIXTURES////////////////////////////////////
/datum/chemical_reaction/tofu
	name = "Tofu"
	required_reagents = alist(/datum/reagent/drink/milk/soymilk = 10)
	required_catalysts = alist(/datum/reagent/enzyme = 5)
	result_amount = 1

/datum/chemical_reaction/tofu/on_reaction(datum/reagents/holder, created_volume)
	var/turf/location = GET_TURF(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/reagent_holder/food/snacks/tofu(location)

/datum/chemical_reaction/chocolate_bar
	name = "Chocolate Bar"
	required_reagents = alist(/datum/reagent/coco = 2, /datum/reagent/drink/milk/soymilk = 2, /datum/reagent/sugar = 2)
	result_amount = 1

/datum/chemical_reaction/chocolate_bar/on_reaction(datum/reagents/holder, created_volume)
	var/turf/location = GET_TURF(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/reagent_holder/food/snacks/chocolatebar(location)

/datum/chemical_reaction/chocolate_bar/secondary
	required_reagents = alist(/datum/reagent/coco = 2, /datum/reagent/drink/milk = 2, /datum/reagent/sugar = 2)

/datum/chemical_reaction/cheesewheel
	name = "Cheesewheel"
	required_reagents = alist(/datum/reagent/drink/milk = 40)
	required_catalysts = alist(/datum/reagent/enzyme = 5)
	result_amount = 1

/datum/chemical_reaction/cheesewheel/on_reaction(datum/reagents/holder, created_volume)
	new /obj/item/reagent_holder/food/snacks/sliceable/cheesewheel(GET_TURF(holder.my_atom))

/datum/chemical_reaction/syntiflesh
	name = "Syntiflesh"
	required_reagents = alist(/datum/reagent/blood = 5, /datum/reagent/clonexadone = 1)
	result_amount = 1

/datum/chemical_reaction/syntiflesh/on_reaction(datum/reagents/holder, created_volume)
	new /obj/item/reagent_holder/food/snacks/meat/slab/syntiflesh(GET_TURF(holder.my_atom))