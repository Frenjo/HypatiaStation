//////////////////////////
/////Initial Building/////
//////////////////////////

// Formerly the home of the monolithic /hook/global_init/proc/make_datum_ref_lists().
// It's now split into many smaller individual hooks for the sake of sanity. -Frenjo

/hook/global_init/proc/init_hair_and_facial_hair()
	. = TRUE
	// Hair - Initialises all /datum/sprite_accessory/hair into a list, indexed by name.
	for(var/path in subtypesof(/datum/sprite_accessory/hair))
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
	for(var/path in subtypesof(/datum/sprite_accessory/facial_hair))
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

/hook/global_init/proc/init_chemistry()
	. = TRUE
	// Chemical Reagents - Initialises all /datum/reagent into a list, indexed by reagent id.
	for(var/path in subtypesof(/datum/reagent))
		var/datum/reagent/D = new path()
		GLOBL.chemical_reagents_list[D.id] = D

	// Chemical Reactions - Initialises all /datum/chemical_reaction into a list.
	// It is filtered into multiple lists within a list.
	// For example:
	// chemical_reaction_list["plasma"] is a list of all reactions relating to plasma
	for(var/path in subtypesof(/datum/chemical_reaction))
		var/datum/chemical_reaction/D = new path()
		var/list/reaction_ids = list()

		if(length(D.required_reagents))
			for(var/reaction in D.required_reagents)
				reaction_ids.Add(reaction)

		// Create filters based on each reagent id in the required reagents list.
		for(var/id in reaction_ids)
			LAZYADD(GLOBL.chemical_reactions_list[id], D)
			break // Don't bother adding ourselves to other reagent ids, it is redundant.

// Medical side effects - Initialises all /datum/medical_effect into a list, indexed by name.
/hook/global_init/proc/init_medical_side_effects()
	. = TRUE
	for(var/path in subtypesof(/datum/medical_effect))
		var/datum/medical_effect/M = new path()
		GLOBL.side_effects[M.name] = M

// Jobs - Initialises all /datum/job (except the base, /datum/job/ai and /datum/job/robot) into a list, indexed by name.
/hook/global_init/proc/init_jobs()
	. = TRUE
	for(var/path in typesof(/datum/job) - list(/datum/job, /datum/job/ai, /datum/job/robot))
		var/datum/job/J = new path()
		GLOBL.all_jobs[J.title] = J

// Languages - Initialises all /datum/language and language keys into lists.
/hook/global_init/proc/init_languages()
	. = TRUE
	for(var/path in subtypesof(/datum/language))
		var/datum/language/L = new path()
		GLOBL.all_languages[L.name] = L
		GLOBL.language_keys["[LANGUAGE_PREFIX_KEY][lowertext(L.key)]"] = L.name

// Species - Initialises all /datum/species into a list.
/hook/global_init/proc/init_species()
	. = TRUE
	var/rkey = 0
	for(var/path in subtypesof(/datum/species))
		rkey++
		var/datum/species/S = new path()
		S.race_key = rkey //Used in mob icon caching.
		GLOBL.all_species[S.name] = S

		if(HAS_SPECIES_FLAGS(S, SPECIES_FLAG_IS_WHITELISTED))
			GLOBL.whitelisted_species.Add(S.name)

// Skills - Initialises all /decl/hierarchy/skill and adds their typepaths into a list, indexed by field.
/hook/global_init/proc/init_skills()
	. = TRUE
	for_no_type_check(var/decl/hierarchy/skill/S, GET_DECL_SUBTYPE_INSTANCES(/decl/hierarchy/skill))
		if(S.is_category())
			continue
		LAZYADD(GLOBL.all_skills[S.field], S.type)

/hook/global_init/proc/init_research()
	. = TRUE
	// Designs - Initialises all /datum/design into a list, indexed by typepath.
	for(var/path in subtypesof(/datum/design))
		var/datum/design/D = new path()
		if(isnull(D.build_path))
			continue
		GLOBL.all_designs[path] = D

// Outfits - Initialises all /decl/outfit typepaths into a list, indexed by name.
/hook/global_init/proc/init_outfits()
	. = TRUE
	for_no_type_check(var/decl/hierarchy/outfit/O, GET_DECL_SUBTYPE_INSTANCES(/decl/hierarchy/outfit))
		if(O.is_category())
			continue
		GLOBL.all_outfits[O.name] = O.type

/* // Uncomment to debug chemical reaction list.
/client/verb/debug_chemical_list()

	for (var/reaction in chemical_reactions_list)
		. += "chemical_reactions_list\[\"[reaction]\"\] = \"[chemical_reactions_list[reaction]]\"\n"
		if(islist(chemical_reactions_list[reaction]))
			var/list/L = chemical_reactions_list[reaction]
			for(var/t in L)
				. += "    has: [t]\n"
	to_world(.)
*/

// Dreams - Initialises various categories of dream text into the GLOBL.all_dreams list.
// This is really just for organisational purposes so things are categorised and can be changed easily.
/hook/global_init/proc/init_dreams()
	. = TRUE
	var/list/things = list(
		"an ID card", "a bottle", "a familiar face", "a toolbox", "voices from all around",
		"a traitor", "an ally", "darkness", "light", "a catastrophe", "a loved one", "a gun",
		"warmth", "freezing", "a hat", "plasma", "air", "blinking lights", "a blue light",
		"NanoTrasen", "The Syndicate", "blood", "healing", "power", "respect", "riches",
		"a crash", "happiness", "pride", "a fall", "water", "flames", "ice", "melons",
		"flying", "the eggs", "money", "a voice", "the cold", "an operating table",
		"the rain", "a beaker of strange liquid"
	)
	var/list/jobs = list(
		"a crewmember", "a security officer", "the captain", "a doctor", "a scientist",
		"the head of personnel", "the head of security", "a chief engineer", "a research director",
		"a chief medical officer", "the detective", "the warden", "a member of the internal affairs",
		"a station engineer", "the janitor", "an atmospheric technician", "the quartermaster",
		"a cargo technician", "the botanist", "a shaft miner", "the psychologist", "the chemist",
		"the geneticist", "the virologist", "the roboticist", "the chef", "the bartender", "the chaplain",
		"the librarian", "an ert member"
	)
	var/list/locations = list(
		"deep space", "the engine", "the sun", "the Luna", "a ruined station", "a planet", "the medical bay",
		"the bridge", "an abandoned laboratory", "space", "a beach", "the holodeck", "a smokey room", "the bar",
		"the ai core", "the mining station", "the research station"
	)
	var/list/species = list(
		"a monkey", "a mouse", "a skrell", "a soghun", "a tajaran"
	)
	GLOBL.all_dreams.Add(things, jobs, locations, species)