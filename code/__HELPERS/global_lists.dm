//////////////////////////
/////Initial Building/////
//////////////////////////

/hook/global_init/proc/makeDatumRefLists()
	var/list/paths

	// Hair - Initialise all /datum/sprite_accessory/hair into an list indexed by hair-style name
	paths = SUBTYPESOF(/datum/sprite_accessory/hair)
	for(var/path in paths)
		var/datum/sprite_accessory/hair/H = new path()
		GLOBL.hair_styles_list[H.name] = H
		switch(H.gender)
			if(MALE)
				GLOBL.hair_styles_male_list += H.name
			if(FEMALE)
				GLOBL.hair_styles_female_list += H.name
			else
				GLOBL.hair_styles_male_list += H.name
				GLOBL.hair_styles_female_list += H.name

	// Facial Hair - Initialise all /datum/sprite_accessory/facial_hair into an list indexed by facialhair-style name
	paths = SUBTYPESOF(/datum/sprite_accessory/facial_hair)
	for(var/path in paths)
		var/datum/sprite_accessory/facial_hair/H = new path()
		GLOBL.facial_hair_styles_list[H.name] = H
		switch(H.gender)
			if(MALE)
				GLOBL.facial_hair_styles_male_list += H.name
			if(FEMALE)
				GLOBL.facial_hair_styles_female_list += H.name
			else
				GLOBL.facial_hair_styles_male_list += H.name
				GLOBL.facial_hair_styles_female_list += H.name

	// Surgery Steps - Initialize all /datum/surgery_step into a list
	paths = SUBTYPESOF(/datum/surgery_step)
	for(var/T in paths)
		var/datum/surgery_step/S = new T()
		GLOBL.surgery_steps += S
	sort_surgeries()

	// Chemical Reagents - Initialises all /datum/reagent into a list indexed by reagent id.
	paths = SUBTYPESOF(/datum/reagent)
	for(var/path in paths)
		var/datum/reagent/D = new path()
		GLOBL.chemical_reagents_list[D.id] = D
	
	// Chemical Reactions - Initialises all /datum/chemical_reaction into a list.
	// It is filtered into multiple lists within a list.
	// For example:
	// chemical_reaction_list["plasma"] is a list of all reactions relating to plasma
	paths = SUBTYPESOF(/datum/chemical_reaction)
	for(var/path in paths)
		var/datum/chemical_reaction/D = new path()
		var/list/reaction_ids = list()

		if(D.required_reagents && D.required_reagents.len)
			for(var/reaction in D.required_reagents)
				reaction_ids += reaction

		// Create filters based on each reagent id in the required reagents list
		for(var/id in reaction_ids)
			if(!GLOBL.chemical_reactions_list[id])
				GLOBL.chemical_reactions_list[id] = list()
			GLOBL.chemical_reactions_list[id] += D
			break // Don't bother adding ourselves to other reagent ids, it is redundant.

	// Medical side effects. List all effects by their names
	paths = SUBTYPESOF(/datum/medical_effect)
	for(var/T in paths)
		var/datum/medical_effect/M = new T()
		GLOBL.side_effects[M.name] = T

	//List of job. I can't believe this was calculated multiple times per tick!
	paths = typesof(/datum/job) - list(/datum/job, /datum/job/ai, /datum/job/cyborg)
	for(var/T in paths)
		var/datum/job/J = new T()
		GLOBL.joblist[J.title] = J

	// Languages - Initialise all /datum/language and language keys into lists.
	paths = SUBTYPESOF(/datum/language)
	for(var/T in paths)
		var/datum/language/L = new T()
		GLOBL.all_languages[L.name] = L

	for(var/language_name in GLOBL.all_languages)
		var/datum/language/L = GLOBL.all_languages[language_name]
		GLOBL.language_keys[":[lowertext(L.key)]"] = L

	// Species - Initialise all /datum/species into a list.
	var/rkey = 0
	paths = SUBTYPESOF(/datum/species)
	for(var/T in paths)
		rkey++
		var/datum/species/S = new T()
		S.race_key = rkey //Used in mob icon caching.
		GLOBL.all_species[S.name] = S

		if(S.flags & IS_WHITELISTED)
			GLOBL.whitelisted_species += S.name
	
	// Skills - Initialise all /datum/skill into a list, indexed by field.
	paths = SUBTYPESOF(/datum/skill)
	for(var/T in paths)
		var/datum/skill/S = new T()
		if(S.id != "none")
			if(!GLOBL.all_skills.Find(S.field))
				GLOBL.all_skills[S.field] = list()
			var/list/field_list = GLOBL.all_skills[S.field]
			field_list += S

	return 1

/* // Uncomment to debug chemical reaction list.
/client/verb/debug_chemical_list()

	for (var/reaction in chemical_reactions_list)
		. += "chemical_reactions_list\[\"[reaction]\"\] = \"[chemical_reactions_list[reaction]]\"\n"
		if(islist(chemical_reactions_list[reaction]))
			var/list/L = chemical_reactions_list[reaction]
			for(var/t in L)
				. += "    has: [t]\n"
	world << .
*/