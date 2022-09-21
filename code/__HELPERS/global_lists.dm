//////////////////////////
/////Initial Building/////
//////////////////////////

/hook/global_init/proc/makeDatumRefLists()
	var/list/paths

	// Hair - Initialise all /datum/sprite_accessory/hair into an list indexed by hair-style name
	paths = SUBTYPESOF(/datum/sprite_accessory/hair)
	for(var/path in paths)
		var/datum/sprite_accessory/hair/H = new path()
		hair_styles_list[H.name] = H
		switch(H.gender)
			if(MALE)
				hair_styles_male_list += H.name
			if(FEMALE)
				hair_styles_female_list += H.name
			else
				hair_styles_male_list += H.name
				hair_styles_female_list += H.name

	// Facial Hair - Initialise all /datum/sprite_accessory/facial_hair into an list indexed by facialhair-style name
	paths = SUBTYPESOF(/datum/sprite_accessory/facial_hair)
	for(var/path in paths)
		var/datum/sprite_accessory/facial_hair/H = new path()
		facial_hair_styles_list[H.name] = H
		switch(H.gender)
			if(MALE)
				facial_hair_styles_male_list += H.name
			if(FEMALE)
				facial_hair_styles_female_list += H.name
			else
				facial_hair_styles_male_list += H.name
				facial_hair_styles_female_list += H.name

	// Surgery Steps - Initialize all /datum/surgery_step into a list
	paths = SUBTYPESOF(/datum/surgery_step)
	for(var/T in paths)
		var/datum/surgery_step/S = new T()
		global.surgery_steps += S
	sort_surgeries()

	// Medical side effects. List all effects by their names
	paths = SUBTYPESOF(/datum/medical_effect)
	for(var/T in paths)
		var/datum/medical_effect/M = new T()
		global.side_effects[M.name] = T

	//List of job. I can't believe this was calculated multiple times per tick!
	paths = typesof(/datum/job) - list(/datum/job, /datum/job/ai, /datum/job/cyborg)
	for(var/T in paths)
		var/datum/job/J = new T()
		global.joblist[J.title] = J

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