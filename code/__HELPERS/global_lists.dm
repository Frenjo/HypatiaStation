//////////////////////////
/////Initial Building/////
//////////////////////////

// Formerly the home of the monolithic /hook/global_init/proc/make_datum_ref_lists().
// It's now split into many smaller individual hooks for the sake of sanity. -Frenjo

/hook/global_init/proc/init_hair_and_facial_hair()
	. = TRUE
	// Hair - Initialises all /datum/sprite_accessory/hair into a list, indexed by name.
	for(var/path in SUBTYPESOF(/datum/sprite_accessory/hair))
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
	for(var/path in SUBTYPESOF(/datum/sprite_accessory/facial_hair))
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
/hook/global_init/proc/init_surgery_steps()
	. = TRUE
	for(var/path in SUBTYPESOF(/datum/surgery_step))
		var/datum/surgery_step/S = new path()
		GLOBL.surgery_steps.Add(S)
	sort_surgeries()

/hook/global_init/proc/init_chemistry()
	. = TRUE
	// Chemical Reagents - Initialises all /datum/reagent into a list, indexed by reagent id.
	for(var/path in SUBTYPESOF(/datum/reagent))
		var/datum/reagent/D = new path()
		GLOBL.chemical_reagents_list[D.id] = D

	// Chemical Reactions - Initialises all /datum/chemical_reaction into a list.
	// It is filtered into multiple lists within a list.
	// For example:
	// chemical_reaction_list["plasma"] is a list of all reactions relating to plasma
	for(var/path in SUBTYPESOF(/datum/chemical_reaction))
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

// Medical side effects - Initialises all /datum/medical_effect into a list, indexed by name.
/hook/global_init/proc/init_medical_side_effects()
	. = TRUE
	for(var/path in SUBTYPESOF(/datum/medical_effect))
		var/datum/medical_effect/M = new path()
		GLOBL.side_effects[M.name] = M

// Jobs - Initialises all /datum/job (except the base, /datum/job/ai and /datum/job/cyborg) into a list, indexed by name.
/hook/global_init/proc/init_jobs()
	. = TRUE
	for(var/path in typesof(/datum/job) - list(/datum/job, /datum/job/ai, /datum/job/cyborg))
		var/datum/job/J = new path()
		GLOBL.all_jobs[J.title] = J

// Languages - Initialises all /datum/language and language keys into lists.
/hook/global_init/proc/init_languages()
	. = TRUE
	for(var/path in SUBTYPESOF(/datum/language))
		var/datum/language/L = new path()
		GLOBL.all_languages[L.name] = L

	for(var/language_name in GLOBL.all_languages)
		var/datum/language/L = GLOBL.all_languages[language_name]
		GLOBL.language_keys[":[lowertext(L.key)]"] = L

// Species - Initialises all /datum/species into a list.
/hook/global_init/proc/init_species()
	. = TRUE
	var/rkey = 0
	for(var/path in SUBTYPESOF(/datum/species))
		rkey++
		var/datum/species/S = new path()
		S.race_key = rkey //Used in mob icon caching.
		GLOBL.all_species[S.name] = S

		if(HAS_SPECIES_FLAGS(S, SPECIES_FLAG_IS_WHITELISTED))
			GLOBL.whitelisted_species.Add(S.name)

// Skills - Initialises all /decl/hierarchy/skill into a list, indexed by field.
/hook/global_init/proc/init_skills()
	. = TRUE
	for(var/path in SUBTYPESOF(/decl/hierarchy/skill))
		var/decl/hierarchy/skill/S = GET_DECL_INSTANCE(path)
		if(S.is_category())
			continue
		if(isnull(GLOBL.all_skills[S.field]))
			GLOBL.all_skills[S.field] = list()
		var/list/field_list = GLOBL.all_skills[S.field]
		field_list.Add(S)

/hook/global_init/proc/init_research()
	. = TRUE
	// Techs - Initialises all /datum/tech into a list, indexed by typepath.
	for(var/path in SUBTYPESOF(/datum/tech))
		var/datum/tech/T = new path()
		GLOBL.all_techs[path] = T

	// Designs - Initialises all /datum/design into a list, indexed by typepath.
	for(var/path in SUBTYPESOF(/datum/design))
		var/datum/design/D = new path()
		GLOBL.all_designs[path] = D

	// Artifact effects - Adds the typepaths of all /datum/artifact_effect to a list.
	for(var/path in SUBTYPESOF(/datum/artifact_effect))
		GLOBL.all_artifact_effect_types.Add(path)

// Outfits - Initialises all /decl/outfit into a list, indexed by name.
/hook/global_init/proc/init_outfits()
	. = TRUE
	for(var/path in SUBTYPESOF(/decl/hierarchy/outfit))
		var/decl/hierarchy/outfit/O = GET_DECL_INSTANCE(path)
		if(O.is_hidden())
			continue
		GLOBL.all_outfits[O.name] = path

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

// Genes - Initialises all /decl/gene into a list, indexed by typepath.
/hook/global_init/proc/init_genes()
	. = TRUE
	for(var/path in SUBTYPESOF(/decl/gene))
		var/decl/gene/gene = GET_DECL_INSTANCE(path)
		GLOBL.all_dna_genes[path] = gene

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

// Posters - Initialises all /decl/poster_design into a list.
/hook/global_init/proc/init_poster_designs()
	. = TRUE
	for(var/path in SUBTYPESOF(/decl/poster_design))
		var/decl/poster_design/design = GET_DECL_INSTANCE(path)
		GLOBL.all_poster_designs.Add(design)