/datum/disease2/disease
	var/infectionchance = 70
	var/speed = 1
	var/spreadtype = "Contact" // Can also be "Airborne"
	var/stage = 1
	var/stageprob = 10
	var/dead = 0
	var/clicks = 0
	var/uniqueID = 0
	var/list/datum/disease2/effectholder/effects = list()
	var/antigen = 0 // 16 bits describing the antigens, when one bit is set, a cure with that bit can dock here
	var/max_stage = 4
	var/list/affected_species = list(SPECIES_HUMAN, SPECIES_SOGHUN, SPECIES_SKRELL, SPECIES_TAJARAN)

/datum/disease2/disease/New()
	uniqueID = rand(0, 10000)
	. = ..()

/datum/disease2/disease/proc/makerandom(greater = 0)
	for(var/i = 1 ; i <= max_stage ; i++)
		var/datum/disease2/effectholder/holder = new /datum/disease2/effectholder
		holder.stage = i
		if(greater)
			holder.getrandomeffect(2)
		else
			holder.getrandomeffect()
		effects += holder
	uniqueID = rand(0, 10000)
	infectionchance = rand(60, 90)
	antigen |= text2num(pick(GLOBL.antigen_list))
	antigen |= text2num(pick(GLOBL.antigen_list))
	spreadtype = prob(70) ? "Airborne" : "Contact"

	if(length(GLOBL.all_species))
		affected_species = get_infectable_species()

/proc/get_infectable_species()
	var/list/meat = list()
	var/list/res = list()
	for (var/specie in GLOBL.all_species)
		var/datum/species/S = GLOBL.all_species[specie]
		if(!HAS_SPECIES_FLAGS(S, SPECIES_FLAG_IS_SYNTHETIC))
			meat += S.name
	if(length(meat))
		var/num = rand(1, length(meat))
		for(var/i = 0, i < num, i++)
			var/picked = pick(meat)
			meat -= picked
			res += picked
	return res

/datum/disease2/disease/proc/activate(mob/living/carbon/mob)
	if(dead)
		cure(mob)
		return

	if(mob.stat == DEAD)
		return
	if(stage <= 1 && clicks == 0) 	// with a certain chance, the mob may become immune to the disease before it starts properly
		if(prob(5))
			mob.antibodies |= antigen // 20% immunity is a good chance IMO, because it allows finding an immune person easily

	if(mob.radiation > 50)
		if(prob(1))
			majormutate()

	//Space antibiotics stop disease completely
	if(mob.reagents.has_reagent("spaceacillin"))
		if(stage == 1 && prob(20))
			src.cure(mob)
		return

	//Virus food speeds up disease progress
	if(mob.reagents.has_reagent("virusfood"))
		mob.reagents.remove_reagent("virusfood", 0.1)
		clicks += 10

	//Moving to the next stage
	if(clicks > stage*100 && prob(10))
		if(stage == max_stage)
			src.cure(mob)
			mob.antibodies |= src.antigen
		stage++
		clicks = 0
	//Do nasty effects
	for(var/datum/disease2/effectholder/e in effects)
		e.runeffect(mob,stage)

	//Short airborne spread
	if(src.spreadtype == "Airborne")
		for(var/mob/living/carbon/M in oview(1,mob))
			if(airborne_can_reach(GET_TURF(mob), GET_TURF(M)))
				infect_virus2(M, src)

	//fever
	mob.bodytemperature = max(mob.bodytemperature, min(310 + 5 * stage, mob.bodytemperature + 5 * stage))
	clicks += speed

/datum/disease2/disease/proc/cure(mob/living/carbon/mob)
	for(var/datum/disease2/effectholder/e in effects)
		e.effect.deactivate(mob)
	mob.virus2.Remove("[uniqueID]")
	BITSET(mob.hud_updateflag, STATUS_HUD)

/datum/disease2/disease/proc/minormutate()
	//uniqueID = rand(0,10000)
	var/datum/disease2/effectholder/holder = pick(effects)
	holder.minormutate()
	infectionchance = min(50, infectionchance + rand(0, 10))

/datum/disease2/disease/proc/majormutate()
	uniqueID = rand(0, 10000)
	var/datum/disease2/effectholder/holder = pick(effects)
	holder.majormutate()
	if(prob(5))
		antigen = text2num(pick(GLOBL.antigen_list))
		antigen |= text2num(pick(GLOBL.antigen_list))
	if(prob(5) && length(GLOBL.all_species))
		affected_species = get_infectable_species()

/datum/disease2/disease/proc/getcopy()
	var/datum/disease2/disease/disease = new /datum/disease2/disease
	disease.infectionchance = infectionchance
	disease.spreadtype = spreadtype
	disease.stageprob = stageprob
	disease.antigen   = antigen
	disease.uniqueID = uniqueID
	disease.affected_species = affected_species.Copy()
	for(var/datum/disease2/effectholder/holder in effects)
		var/datum/disease2/effectholder/newholder = new /datum/disease2/effectholder
		newholder.effect = new holder.effect.type
		newholder.chance = holder.chance
		newholder.cure = holder.cure
		newholder.multiplier = holder.multiplier
		newholder.happensonce = holder.happensonce
		newholder.stage = holder.stage
		disease.effects += newholder
	return disease

/datum/disease2/disease/proc/issame(datum/disease2/disease/disease)
	var/list/types = list()
	var/list/types2 = list()
	for(var/datum/disease2/effectholder/d in effects)
		types += d.effect.type
	var/equal = 1

	for(var/datum/disease2/effectholder/d in disease.effects)
		types2 += d.effect.type

	for(var/type in types)
		if(!(type in types2))
			equal = 0

	if(antigen != disease.antigen)
		equal = 0
	return equal

/proc/virus_copylist(list/datum/disease2/disease/viruses)
	var/list/res = list()
	for(var/ID in viruses)
		var/datum/disease2/disease/V = viruses[ID]
		res["[V.uniqueID]"] = V.getcopy()
	return res


var/global/list/virusDB = list()

/datum/disease2/disease/proc/name()
	.= "stamm #[add_zero("[uniqueID]", 4)]"
	if ("[uniqueID]" in virusDB)
		var/datum/data/record/V = virusDB["[uniqueID]"]
		.= V.fields["name"]

/datum/disease2/disease/proc/get_info()
	var/r = "GNAv2 based virus lifeform - [name()], #[add_zero("[uniqueID]", 4)]"
	r += "<BR>Infection rate : [infectionchance * 10]"
	r += "<BR>Spread form : [spreadtype]"
	r += "<BR>Progress Speed : [stageprob * 10]"
	r += "<BR>Affected species:"
	for(var/S in affected_species)
		r += "<BR>[S]"
	for(var/datum/disease2/effectholder/E in effects)
		r += "<BR>Effect:[E.effect.name]. Strength : [E.multiplier * 8]. Verosity : [E.chance * 15]. Type : [5-E.stage]."

	r += "<BR>Antigen pattern: [antigens2string(antigen)]"
	return r

/datum/disease2/disease/proc/addToDB()
	if ("[uniqueID]" in virusDB)
		return 0
	var/datum/data/record/v = new()
	v.fields["id"] = uniqueID
	v.fields["name"] = name()
	v.fields["description"] = get_info()
	v.fields["antigen"] = antigens2string(antigen)
	v.fields["spread type"] = spreadtype
	virusDB["[uniqueID]"] = v
	return 1

/proc/virus2_lesser_infection()
	var/list/candidates = list()	//list of candidate keys

	for(var/mob/living/carbon/human/G in GLOBL.player_list)
		if(G.client && G.stat != DEAD)
			candidates += G

	if(!length(candidates))
		return

	candidates = shuffle(candidates)

	infect_mob_random_lesser(candidates[1])

/proc/virus2_greater_infection()
	var/list/candidates = list()	//list of candidate keys

	for(var/mob/living/carbon/human/G in GLOBL.player_list)
		if(G.client && G.stat != DEAD)
			candidates += G
	if(!length(candidates))
		return

	candidates = shuffle(candidates)

	infect_mob_random_greater(candidates[1])