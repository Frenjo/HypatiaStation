///////////////////////////////////////////////////////////////////////////////////
/datum/chemical_reaction/water //I can't believe we never had this.
	name = "Water"
	result = null
	required_reagents = list("oxygen" = 2, "hydrogen" = 1)
	result_amount = 1

/datum/chemical_reaction/lube
	name = "Space Lube"
	result = "lube"
	required_reagents = list("water" = 1, "silicon" = 1, "oxygen" = 1)
	result_amount = 4

/datum/chemical_reaction/space_drugs
	name = "Space Drugs"
	result = "space_drugs"
	required_reagents = list("mercury" = 1, "sugar" = 1, "lithium" = 1)
	result_amount = 3

/*
/datum/chemical_reaction/silicate
	name = "Silicate"
	result = "silicate"
	required_reagents = list("aluminum" = 1, "silicon" = 1, "oxygen" = 1)
	result_amount = 3
*/

/datum/chemical_reaction/glycerol
	name = "Glycerol"
	result = "glycerol"
	required_reagents = list("cornoil" = 3, "sacid" = 1)
	result_amount = 1

/datum/chemical_reaction/nitroglycerin
	name = "Nitroglycerin"
	result = "nitroglycerin"
	required_reagents = list("glycerol" = 1, "pacid" = 1, "sacid" = 1)
	result_amount = 2

/datum/chemical_reaction/nitroglycerin/on_reaction(datum/reagents/holder, created_volume)
	var/datum/effect/system/reagents_explosion/e = new /datum/effect/system/reagents_explosion()
	e.set_up(round (created_volume/2, 1), holder.my_atom, 0, 0)
	e.holder_damage(holder.my_atom)
	if(isliving(holder.my_atom))
		e.amount *= 0.5
		var/mob/living/L = holder.my_atom
		if(L.stat != DEAD)
			e.amount *= 0.5
	e.start()

	holder.clear_reagents()

/datum/chemical_reaction/thermite
	name = "Thermite"
	result = "thermite"
	required_reagents = list("aluminum" = 1, "iron" = 1, "oxygen" = 1)
	result_amount = 3

/datum/chemical_reaction/virus_food
	name = "Virus Food"
	result = "virusfood"
	required_reagents = list("water" = 1, "milk" = 1)
	result_amount = 5

/*
/datum/chemical_reaction/mix_virus
	name = "Mix Virus"
	result = "blood"
	required_reagents = list("virusfood" = 5)
	required_catalysts = list("blood")
	var/level = 2

/datum/chemical_reaction/mix_virus/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	if(B && B.data)
		var/datum/disease/advance/D = locate(/datum/disease/advance) in B.data["viruses"]
		if(D)
			D.Evolve(level - rand(0, 1))

/datum/chemical_reaction/mix_virus/mix_virus_2
	name = "Mix Virus 2"
	required_reagents = list("mutagen" = 5)
	level = 4

/datum/chemical_reaction/mix_virus/rem_virus
	name = "Devolve Virus"
	required_reagents = list("synaptizine" = 5)

/datum/chemical_reaction/mix_virus/rem_virus/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	if(B && B.data)
		var/datum/disease/advance/D = locate(/datum/disease/advance) in B.data["viruses"]
		if(D)
			D.Devolve()
*/

/datum/chemical_reaction/space_cleaner
	name = "Space cleaner"
	result = "cleaner"
	required_reagents = list("ammonia" = 1, "water" = 1)
	result_amount = 2

/datum/chemical_reaction/impedrezene
	name = "Impedrezene"
	result = "impedrezene"
	required_reagents = list("mercury" = 1, "oxygen" = 1, "sugar" = 1)
	result_amount = 2

// foam and foam precursor
/datum/chemical_reaction/surfactant
	name = "Foam surfactant"
	result = "fluorosurfactant"
	required_reagents = list("fluorine" = 2, "carbon" = 2, "sacid" = 1)
	result_amount = 5

/datum/chemical_reaction/foam
	name = "Foam"
	result = null
	required_reagents = list("fluorosurfactant" = 1, "water" = 1)
	result_amount = 2

/datum/chemical_reaction/foam/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/mob/M in viewers(5, location))
		to_chat(M, SPAN_WARNING("The solution violently bubbles!"))

	location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, SPAN_WARNING("The solution spews out foam!"))

	//to_world("Holder volume is [holder.total_volume]")
	//for(var/datum/reagent/R in holder.reagent_list)
		//to_world("[R.name] = [R.volume]")

	var/datum/effect/system/foam_spread/s = new /datum/effect/system/foam_spread()
	s.set_up(created_volume, location, holder, 0)
	s.start()
	holder.clear_reagents()

/datum/chemical_reaction/metalfoam
	name = "Metal Foam"
	result = null
	required_reagents = list("aluminum" = 3, "foaming_agent" = 1, "pacid" = 1)
	result_amount = 5

/datum/chemical_reaction/metalfoam/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, SPAN_WARNING("The solution spews out a metalic foam!"))

	var/datum/effect/system/foam_spread/s = new /datum/effect/system/foam_spread()
	s.set_up(created_volume, location, holder, 1)
	s.start()

/datum/chemical_reaction/ironfoam
	name = "Iron Foam"
	result = null
	required_reagents = list("iron" = 3, "foaming_agent" = 1, "pacid" = 1)
	result_amount = 5

/datum/chemical_reaction/ironfoam/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, SPAN_WARNING("The solution spews out a metalic foam!"))

	var/datum/effect/system/foam_spread/s = new /datum/effect/system/foam_spread()
	s.set_up(created_volume, location, holder, 2)
	s.start()

/datum/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	result = "foaming_agent"
	required_reagents = list("lithium" = 1, "hydrogen" = 1)
	result_amount = 1

// Synthesizing these two chemicals is pretty complex in real life, but fuck it, it's just a game!
/datum/chemical_reaction/ammonia
	name = "Ammonia"
	result = "ammonia"
	required_reagents = list("hydrogen" = 3, "nitrogen" = 1)
	result_amount = 3

/datum/chemical_reaction/diethylamine
	name = "Diethylamine"
	result = "diethylamine"
	required_reagents = list ("ammonia" = 1, "ethanol" = 1)
	result_amount = 2