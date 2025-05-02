///////////////////////////////////////////////////////////////////////////////////
/datum/chemical_reaction
	var/name = null
	var/result = null
	var/alist/required_reagents = alist()
	var/list/required_catalysts = list()

	// Both of these variables are mostly going to be used with slime cores - but if you want to, you can use them for other things
	var/atom/required_container = null // the container required for the reaction to happen
	var/required_other = 0 // an integer required for the reaction to happen

	var/result_amount = 0 //I recommend you set the result amount to the total volume of all components.
	var/secondary = 0 // set to nonzero if secondary reaction
	var/alist/secondary_results = alist() //additional reagents produced by the reaction
	var/requires_heating = 0

/datum/chemical_reaction/proc/on_reaction(datum/reagents/holder, created_volume)
	return

/*
// Drinks that required improved sprites according to someone called Agouri. //
Sbiten, Red Mead, Mead, Iced Beer, Grog, Soy Latte, Cafe Latte, Acid Spit,
Amasec, Changeling Sting, Aloe, Andalusia, Neurotoxin, Snow White,
Irish Car Bomb, Syndicate Bomb, Erika Surprise, Devil's Kiss, Hippie's Delight,
Banana Honk, Silencer, Driest Martini, Lemonade, Kira Special, Brown Star,
Milkshake, Rewriter, Sui Dream.
*/