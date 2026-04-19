///////////////////////////////////////////////////////////////////////////////////
/datum/chemical_reaction/water //I can't believe we never had this.
	name = "Water"
	result = /datum/reagent/water
	required_reagents = alist(/datum/reagent/hydrogen = 1, /datum/reagent/oxygen = 2)
	result_amount = 1

/datum/chemical_reaction/lube
	name = "Space Lube"
	result = /datum/reagent/lube
	required_reagents = alist(/datum/reagent/oxygen = 1, /datum/reagent/silicon = 1, /datum/reagent/water = 1)
	result_amount = 4

/*
/datum/chemical_reaction/silicate
	name = "Silicate"
	result = /datum/reagent/silicate
	required_reagents = alist(/datum/reagent/aluminum = 1, /datum/reagent/oxygen = 1, /datum/reagent/silicon = 1)
	result_amount = 3
*/

/datum/chemical_reaction/thermite
	name = "Thermite"
	result = /datum/reagent/thermite
	required_reagents = alist(/datum/reagent/aluminium = 1, /datum/reagent/iron = 1, /datum/reagent/oxygen = 1)
	result_amount = 3

/datum/chemical_reaction/virus_food
	name = "Virus Food"
	result = /datum/reagent/virus_food
	required_reagents = alist(/datum/reagent/drink/milk = 1, /datum/reagent/water = 1)
	result_amount = 5

/*
/datum/chemical_reaction/mix_virus
	name = "Mix Virus"
	result = /datum/reagent/blood
	required_reagents = alist(/datum/reagent/virus_food = 5)
	required_catalysts = list(/datum/reagent/blood = 1)
	var/level = 2

/datum/chemical_reaction/mix_virus/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	if(B && B.data)
		var/datum/disease/advance/D = locate(/datum/disease/advance) in B.data["viruses"]
		if(D)
			D.Evolve(level - rand(0, 1))

/datum/chemical_reaction/mix_virus/mix_virus_2
	name = "Mix Virus 2"
	required_reagents = alist(/datum/reagent/toxin/mutagen = 5)
	level = 4

/datum/chemical_reaction/mix_virus/rem_virus
	name = "Devolve Virus"
	required_reagents = alist(/datum/reagent/synaptizine = 5)

/datum/chemical_reaction/mix_virus/rem_virus/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	if(B && B.data)
		var/datum/disease/advance/D = locate(/datum/disease/advance) in B.data["viruses"]
		if(D)
			D.Devolve()
*/

/datum/chemical_reaction/space_cleaner
	name = "Space cleaner"
	result = /datum/reagent/space_cleaner
	required_reagents = alist(/datum/reagent/ammonia = 1, /datum/reagent/water = 1)
	result_amount = 2