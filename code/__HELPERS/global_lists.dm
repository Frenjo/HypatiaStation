//////////////////////////
/////Initial Building/////
//////////////////////////

/hook/global_init/proc/make_datum_ref_lists()
	var/list/paths = list()

	// Hair - Initialises all /datum/sprite_accessory/hair into a list, indexed by name.
	paths = SUBTYPESOF(/datum/sprite_accessory/hair)
	for(var/path in paths)
		var/datum/sprite_accessory/hair/H = new path()
		GLOBL.hair_styles_list[H.name] = H
		switch(H.gender)
			if(MALE)
				GLOBL.hair_styles_male_list.Add(H.name)
			if(FEMALE)
				GLOBL.hair_styles_female_list.Add(H.name)
			else
				GLOBL.hair_styles_male_list.Add(H.name)
				GLOBL.hair_styles_female_list.Add(H.name)

	// Facial Hair - Initialises all /datum/sprite_accessory/facial_hair into a list, indexed by name.
	paths = SUBTYPESOF(/datum/sprite_accessory/facial_hair)
	for(var/path in paths)
		var/datum/sprite_accessory/facial_hair/H = new path()
		GLOBL.facial_hair_styles_list[H.name] = H
		switch(H.gender)
			if(MALE)
				GLOBL.facial_hair_styles_male_list.Add(H.name)
			if(FEMALE)
				GLOBL.facial_hair_styles_female_list.Add(H.name)
			else
				GLOBL.facial_hair_styles_male_list.Add(H.name)
				GLOBL.facial_hair_styles_female_list.Add(H.name)

	// Surgery Steps - Initialises all /datum/surgery_step into a list.
	paths = SUBTYPESOF(/datum/surgery_step)
	for(var/path in paths)
		var/datum/surgery_step/S = new path()
		GLOBL.surgery_steps.Add(S)
	sort_surgeries()

	// Chemical Reagents - Initialises all /datum/reagent into a list, indexed by reagent id.
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

		if(length(D.required_reagents))
			for(var/reaction in D.required_reagents)
				reaction_ids.Add(reaction)

		// Create filters based on each reagent id in the required reagents list.
		for(var/id in reaction_ids)
			if(isnull(GLOBL.chemical_reactions_list[id]))
				GLOBL.chemical_reactions_list[id] = list()
			var/list/id_list = GLOBL.chemical_reactions_list[id]
			id_list.Add(D)
			break // Don't bother adding ourselves to other reagent ids, it is redundant.

	// Medical side effects - Initialises all /datum/medical_side_effect into a list, indexed by name.
	paths = SUBTYPESOF(/datum/medical_effect)
	for(var/path in paths)
		var/datum/medical_effect/M = new path()
		GLOBL.side_effects[M.name] = M

	// Jobs - Initialises all /datum/job (except the base, /datum/job/ai and /datum/job/cyborg) into a list, indexed by name.
	paths = typesof(/datum/job) - list(/datum/job, /datum/job/ai, /datum/job/cyborg)
	for(var/path in paths)
		var/datum/job/J = new path()
		GLOBL.all_jobs[J.title] = J

	// Languages - Initialises all /datum/language and language keys into lists.
	paths = SUBTYPESOF(/datum/language)
	for(var/path in paths)
		var/datum/language/L = new path()
		GLOBL.all_languages[L.name] = L

	for(var/language_name in GLOBL.all_languages)
		var/datum/language/L = GLOBL.all_languages[language_name]
		GLOBL.language_keys[":[lowertext(L.key)]"] = L

	// Species - Initialises all /datum/species into a list.
	var/rkey = 0
	paths = SUBTYPESOF(/datum/species)
	for(var/path in paths)
		rkey++
		var/datum/species/S = new path()
		S.race_key = rkey //Used in mob icon caching.
		GLOBL.all_species[S.name] = S

		if(S.flags & IS_WHITELISTED)
			GLOBL.whitelisted_species.Add(S.name)
	
	// Skills - Initialises all /datum/skill into a list, indexed by field.
	paths = SUBTYPESOF(/datum/skill)
	for(var/path in paths)
		var/datum/skill/S = new path()
		if(S.id == "none")
			continue
		if(isnull(GLOBL.all_skills[S.field]))
			GLOBL.all_skills[S.field] = list()
		var/list/field_list = GLOBL.all_skills[S.field]
		field_list.Add(S)
	
	// Techs - Initialises all /datum/tech into a list, indexed by id.
	paths = SUBTYPESOF(/datum/tech)
	for(var/path in paths)
		var/datum/tech/T = new path()
		GLOBL.all_techs[T.id] = T
	
	// Designs - Initialises all /datum/design into a list, indexed by id.
	paths = SUBTYPESOF(/datum/design)
	for(var/path in paths)
		var/datum/design/D = new path()
		GLOBL.all_designs[D.id] = D
	
	// Artifact effects - Adds the typepaths of all /datum/artifact_effect to a list.
	paths = SUBTYPESOF(/datum/artifact_effect)
	for(var/path in paths)
		GLOBL.all_artifact_effect_types.Add(path)

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