/*

	Advance Disease is a system for Virologist to Engineer their own disease with symptoms that have effects and properties
	which add onto the overall disease.

	If you need help with creating new symptoms or expanding the advance disease, ask for Giacom on #coderbus.

*/
#define RANDOM_STARTING_LEVEL 2

/var/list/archive_diseases = list()

// The order goes from easy to cure to hard to cure.
var/list/advance_cures = list(
	"nutriment", "sugar", "orangejuice",
	"spaceacillin", "kelotane", "ethanol",
	"leporazine", "synaptizine", "lipozine",
	"silver", "gold", "plasma"
)

/*

	PROPERTIES

 */
/datum/disease/advance
	name = "Unknown" // We will always let our Virologist name our disease.
	desc = "An engineered disease which can contain a multitude of symptoms."
	form = "Advance Disease" // Will let med-scanners know that this disease was engineered.
	agent = "advance microbes"
	max_stages = 5
	spread = "Unknown"
	affected_species = list(SPECIES_HUMAN, "Monkey")

	// NEW VARS

	var/list/datum/symptom/symptoms = list() // The symptoms of the disease.
	var/id = ""
	var/processing = 0


/*

	OLD PROCS

 */
/datum/disease/advance/New(process = 1, datum/disease/advance/D)
	// Setup our dictionary if it hasn't already.
	if(!length(GLOBL.dictionary_symptoms))
		for(var/symp in GLOBL.list_symptoms)
			var/datum/symptom/S = new symp
			GLOBL.dictionary_symptoms[S.id] = symp

	if(!istype(D))
		D = null
	// Generate symptoms if we weren't given any.

	if(!length(symptoms))

		if(!D || !length(D.symptoms))
			symptoms = GenerateSymptoms()
		else
			for_no_type_check(var/datum/symptom/S, D.symptoms)
				symptoms += new S.type

	Refresh()
	..(process, D)
	return

/datum/disease/advance/Destroy()
	if(processing)
		for_no_type_check(var/datum/symptom/S, symptoms)
			S.End(src)
	return ..()

// Randomly pick a symptom to activate.
/datum/disease/advance/stage_act()
	..()
	if(length(symptoms))

		if(!processing)
			processing = 1
			for_no_type_check(var/datum/symptom/S, symptoms)
				S.Start(src)

		for_no_type_check(var/datum/symptom/S, symptoms)
			S.Activate(src)
	else
		CRASH("We do not have any symptoms during stage_act()!")

// Compares type then ID.
/datum/disease/advance/IsSame(datum/disease/advance/D)
	if(!(istype(D, /datum/disease/advance)))
		return 0

	if(src.GetDiseaseID() != D.GetDiseaseID())
		return 0
	return 1

// To add special resistances.
/datum/disease/advance/cure(resistance = 1)
	if(affected_mob)
		var/id = "[GetDiseaseID()]"
		if(resistance && !(id in affected_mob.resistances))
			affected_mob.resistances[id] = id
		affected_mob.viruses -= src		//remove the datum from the list
	qdel(src)	//delete the datum to stop it processing
	return

// Returns the advance disease with a different reference memory.
/datum/disease/advance/Copy(process = 0)
	return new /datum/disease/advance(process, src, 1)


/*

	NEW PROCS

 */
// Mix the symptoms of two diseases (the src and the argument)
/datum/disease/advance/proc/Mix(datum/disease/advance/D)
	if(!src.IsSame(D))
		var/list/datum/symptom/possible_symptoms = shuffle(D.symptoms)
		for_no_type_check(var/datum/symptom/S, possible_symptoms)
			AddSymptom(new S.type)

/datum/disease/advance/proc/HasSymptom(datum/symptom/S)
	for_no_type_check(var/datum/symptom/symp, symptoms)
		if(symp.id == S.id)
			return 1
	return 0

// Will generate new unique symptoms, use this if there are none. Returns a list of symptoms that were generated.
/datum/disease/advance/proc/GenerateSymptoms(type_level_limit = RANDOM_STARTING_LEVEL, amount_get = 0)
	. = list() // Symptoms we generated.

	// Generate symptoms. By default, we only choose non-deadly symptoms.
	var/list/possible_symptoms = list()
	for(var/symp in GLOBL.list_symptoms)
		var/datum/symptom/S = new symp
		if(S.level <= type_level_limit)
			if(!HasSymptom(S))
				possible_symptoms += S

	if(!length(possible_symptoms))
		return
		//error("Advance Disease - We weren't able to get any possible symptoms in GenerateSymptoms([type_level_limit], [amount_get])")

	// Random chance to get more than one symptom
	var/number_of = amount_get
	if(!amount_get)
		number_of = 1
		while(prob(20))
			number_of += 1

	for(var/i = 1; number_of >= i; i++)
		var/datum/symptom/S = pick(possible_symptoms)
		. += S
		possible_symptoms -= S

/datum/disease/advance/proc/Refresh(new_name = 0)
	//to_world("[src.name] \ref[src] - REFRESH!")
	var/list/properties = GenerateProperties()
	AssignProperties(properties)

	if(!archive_diseases[GetDiseaseID()])
		if(new_name)
			AssignName()
		archive_diseases[GetDiseaseID()] = src // So we don't infinite loop
		archive_diseases[GetDiseaseID()] = new /datum/disease/advance(0, src, 1)

	var/datum/disease/advance/A = archive_diseases[GetDiseaseID()]
	AssignName(A.name)

//Generate disease properties based on the effects. Returns an associated list.
/datum/disease/advance/proc/GenerateProperties()
	if(!length(symptoms))
		CRASH("We did not have any symptoms before generating properties.")

	var/list/properties = list("resistance" = 1, "stealth" = 1, "stage_rate" = 1, "transmittable" = 1, "severity" = 1)

	for_no_type_check(var/datum/symptom/S, symptoms)

		properties["resistance"] += S.resistance
		properties["stealth"] += S.stealth
		properties["stage_rate"] += S.stage_speed
		properties["transmittable"] += S.transmittable
		properties["severity"] = max(properties["severity"], S.level) // severity is based on the highest level symptom

	return properties

// Assign the properties that are in the list.
/datum/disease/advance/proc/AssignProperties(list/properties = list())
	if(length(properties))
		hidden = list((properties["stealth"] > 2), (properties["stealth"] > 3))
		// The more symptoms we have, the less transmittable it is but some symptoms can make up for it.
		SetSpread(clamp(properties["transmittable"] - length(symptoms), BLOOD, AIRBORNE))
		permeability_mod = max(ceil(0.4 * properties["transmittable"]), 1)
		cure_chance = 15 - clamp(properties["resistance"], -5, 5) // can be between 10 and 20
		stage_prob = max(properties["stage_rate"], 2)
		SetSeverity(properties["severity"])
		GenerateCure(properties)
	else
		CRASH("Our properties were empty or null!")

// Assign the spread type and give it the correct description.
/datum/disease/advance/proc/SetSpread(spread_id)
	switch(spread_id)
		if(NON_CONTAGIOUS)
			spread = "None"
		if(SPECIAL)
			spread = "None"
		if(CONTACT_GENERAL, CONTACT_HANDS, CONTACT_FEET)
			spread = "On contact"
		if(AIRBORNE)
			spread = "Airborne"
		if(BLOOD)
			spread = "Blood"

	spread_type = spread_id
	//to_world("Setting spread type to [spread_id]/[spread]")

/datum/disease/advance/proc/SetSeverity(level_sev)
	switch(level_sev)
		if(-INFINITY to 0)
			severity = "Non-Threat"
		if(1)
			severity = "Minor"
		if(2)
			severity = "Medium"
		if(3)
			severity = "Harmful"
		if(4)
			severity = "Dangerous!"
		if(5 to INFINITY)
			severity = "BIOHAZARD THREAT!"
		else
			severity = "Unknown"

// Will generate a random cure, the less resistance the symptoms have, the harder the cure.
/datum/disease/advance/proc/GenerateCure(list/properties = list())
	if(length(properties))
		var/res = clamp(properties["resistance"] - (length(symptoms) / 2), 1, length(advance_cures))
		//to_world("Res = [res]")
		cure_id = advance_cures[res]

		// Get the cure name from the cure_id
		var/datum/reagent/D = GLOBL.chemical_reagents_list[cure_id]
		cure = D.name

	return

// Randomly generate a symptom, has a chance to lose or gain a symptom.
/datum/disease/advance/proc/Evolve(level = 2)
	var/s = safepick(GenerateSymptoms(level, 1))
	if(s)
		AddSymptom(s)
		Refresh(1)
	return

// Randomly remove a symptom.
/datum/disease/advance/proc/Devolve()
	if(length(symptoms) > 1)
		var/s = safepick(symptoms)
		if(s)
			RemoveSymptom(s)
			Refresh(1)
	return

// Name the disease.
/datum/disease/advance/proc/AssignName(name = "Unknown")
	src.name = name
	return

// Return a unique ID of the disease.
/datum/disease/advance/proc/GetDiseaseID()
	var/list/L = list()
	for_no_type_check(var/datum/symptom/S, symptoms)
		L += S.id
	L = sortList(L) // Sort the list so it doesn't matter which order the symptoms are in.
	. = jointext(L, ":")
	id = .

// Add a symptom, if it is over the limit (with a small chance to be able to go over)
// we take a random symptom away and add the new one.
/datum/disease/advance/proc/AddSymptom(datum/symptom/S)
	if(HasSymptom(S))
		return

	if(length(symptoms) < 5 + rand(-1, 1))
		symptoms += S
	else
		RemoveSymptom(pick(symptoms))
		symptoms += S
	return

// Simply removes the symptom.
/datum/disease/advance/proc/RemoveSymptom(datum/symptom/S)
	symptoms -= S
	return


/*

	Static Procs

*/
// Mix a list of advance diseases and return the mixed result.
/proc/Advance_Mix(list/D_list)
	//to_world("Mixing!!!!")

	var/list/diseases = list()

	for(var/datum/disease/advance/A in D_list)
		diseases += A.Copy()

	if(!length(diseases))
		return null
	if(length(diseases) <= 1)
		return pick(diseases) // Just return the only entry.

	var/i = 0
	// Mix our diseases until we are left with only one result.
	while(i < 20 && length(diseases) > 1)

		i++

		var/datum/disease/advance/D1 = pick(diseases)
		diseases -= D1

		var/datum/disease/advance/D2 = pick(diseases)
		D2.Mix(D1)

	 // Should be only 1 entry left, but if not let's only return a single entry
	//to_world("END MIXING!!!!!")
	var/datum/disease/advance/to_return = pick(diseases)
	to_return.Refresh(1)
	return to_return

/proc/SetViruses(datum/reagent/R, list/data)
	if(data)
		var/list/preserve = list()
		if(istype(data) && data["viruses"])
			for(var/datum/disease/A in data["viruses"])
				preserve += A.Copy()
			R.data = data.Copy()
		else
			R.data = data
		if(length(preserve))
			R.data["viruses"] = preserve

/proc/AdminCreateVirus(mob/user)
	var/i = 5

	var/datum/disease/advance/D = new(0, null)
	D.symptoms = list()

	var/list/symptoms = list()
	symptoms += "Done"
	symptoms += GLOBL.list_symptoms.Copy()
	do
		var/symptom = input(user, "Choose a symptom to add ([i] remaining)", "Choose a Symptom") in symptoms
		if(istext(symptom))
			i = 0
		else if(ispath(symptom))
			var/datum/symptom/S = new symptom
			if(!D.HasSymptom(S))
				D.symptoms += S
				i -= 1
	while(i > 0)

	if(length(D.symptoms))
		var/new_name = input(user, "Name your new disease.", "New Name")
		D.AssignName(new_name)
		D.Refresh()

		for(var/datum/disease/advance/AD in global.PCdisease.processing_list)
			AD.Refresh()

		for(var/mob/living/carbon/human/H in shuffle(GLOBL.living_mob_list))
			if(H.z != 1)
				continue
			if(!H.has_disease(D))
				H.contract_disease(D, 1)
				break

		var/list/name_symptoms = list()
		for_no_type_check(var/datum/symptom/S, D.symptoms)
			name_symptoms += S.name
		message_admins("[key_name_admin(user)] has triggered a custom virus outbreak of [D.name]! It has these symptoms: [english_list(name_symptoms)]")

/*
/mob/verb/test()

	for(var/datum/disease/D in active_diseases)
		to_chat(src, "<a href='byond://?_src_=vars;Vars=\ref[D]'>[D.name] - [D.holder]</a>")
*/

#undef RANDOM_STARTING_LEVEL