/*
General Explination:
The research datum is the "folder" where all the research information is stored in a R&D console. It's also a holder for all the
various procs used to manipulate it. It has four variables and seven procs:

Variables:
- possible_tech is a list of all the /datum/tech that can potentially be researched by the player. The RefreshResearch() proc
(explained later) only goes through those when refreshing what you know. Generally, possible_tech contains ALL of the existing tech
but it is possible to add tech to the game that DON'T start in it (example: Xeno tech). Generally speaking, you don't want to mess
with these since they should be the default version of the datums. They're actually stored in a list rather then using typesof to
refer to them since it makes it a bit easier to search through them for specific information.
- know_tech is the companion list to possible_tech. It's the tech you can actually research and improve. Until it's added to this
list, it can't be improved. All the tech in this list are visible to the player.
- possible_designs is functionally identical to possbile_tech except it's for /datum/design.
- known_designs is functionally identical to known_tech except it's for /datum/design

Procs:
- TechHasReqs: Used by other procs (specifically RefreshResearch) to see whether all of a tech's requirements are currently in
known_tech and at a high enough level.
- DesignHasReqs: Same as TechHasReqs but for /datum/design and known_design.
- AddTech2Known: Adds a /datum/tech to known_tech. It checks to see whether it already has that tech (if so, it just replaces it). If
it doesn't have it, it adds it. Note: It does NOT check possible_tech at all. So if you want to add something strange to it (like
a player made tech?) you can.
- AddDesign2Known: Same as AddTech2Known except for /datum/design and known_designs.
- RefreshResearch: This is the workhorse of the R&D system. It updates the /datum/research holder and adds any unlocked tech paths
and designs you have reached the requirements for. It only checks through possible_tech and possible_designs, however, so it won't
accidentally add "secret" tech to it.
- UpdateTech is used as part of the actual researching process. It takes an ID and finds techs with that same ID in known_tech. When
it finds it, it checks to see whether it can improve it at all. If the known_tech's level is less then or equal to
the inputted level, it increases the known tech's level to the inputted level -1 or know tech's level +1 (whichever is higher).

The tech datums are the actual "tech trees" that you improve through researching. Each one has five variables:
- Name:		Pretty obvious. This is often viewable to the players.
- Desc:		Pretty obvious. Also player viewable.
- ID:		This is the unique ID of the tech that is used by the various procs to find and/or maniuplate it.
- Level:	This is the current level of the tech. All techs start at 1 and have a max of 20. Devices and some techs require a certain
level in specific techs before you can produce them.
- Req_tech:	This is a list of the techs required to unlock this tech path. If left blank, it'll automatically be loaded into the
research holder datum.

*/
/***************************************************************
**						Master Types						  **
**	Includes all the helper procs and basic tech processing.  **
***************************************************************/
/datum/research	// Holder for all the existing, archived, and known tech. Individual to console.
	// Datum/tech go here.
	var/list/possible_tech = list()		// List of all tech in the game that players have access to (barring special events).
	var/list/known_tech = list()		// List of locally known tech.
	var/list/possible_designs = list()	// List of all designs (at base reliability).
	var/list/known_designs = list()		// List of available designs (at base reliability).

/datum/research/New()	// Insert techs into possible_tech here. Known_tech automatically updated.
	for(var/T in GLOBL.all_techs)
		possible_tech += GLOBL.all_techs[T]
	for(var/D in GLOBL.all_designs)
		possible_designs += GLOBL.all_designs[D]
	RefreshResearch()

// Checks to see if tech has all the required pre-reqs.
// Input: datum/tech; Output: TRUE/FALSE
/datum/research/proc/TechHasReqs(datum/tech/T)
	if(!length(T.req_tech))
		return TRUE
	var/matches = 0
	for(var/req in T.req_tech)
		for(var/datum/tech/known in known_tech)
			if(req == known.type && known.level >= T.req_tech[req])
				matches++
				break
	if(matches == length(T.req_tech))
		return TRUE
	else
		return FALSE

// Checks to see if design has all the required pre-reqs.
// Input: datum/design; Output: TRUE/FALSE
/datum/research/proc/DesignHasReqs(datum/design/D)
	if(!length(D.req_tech))
		return TRUE
	var/matches = 0
	var/list/k_tech = list()
	for(var/datum/tech/known in known_tech)
		k_tech[known.type] = known.level
	for(var/req in D.req_tech)
		if(isnotnull(k_tech[req]) && k_tech[req] >= D.req_tech[req])
			matches++
	if(matches == length(D.req_tech))
		return TRUE
	else
		return FALSE
/*
// Checks to see if design has all the required pre-reqs.
// Input: datum/design; Output: TRUE/FALSE
/datum/research/proc/DesignHasReqs(var/datum/design/D)
	if(!length(D.req_tech))
		return TRUE
	var/matches = 0
	for(var/req in D.req_tech)
		for(var/datum/tech/known in known_tech)
			if((req == known.id) && (known.level >= D.req_tech[req]))
				matches++
				break
	if(matches == length(D.req_tech))
		return TRUE
	else
		return FALSE
*/

// Adds a tech to known_tech list. Checks to make sure there aren't duplicates and updates existing tech's levels if needed.
// Input: datum/tech; Output: Null
/datum/research/proc/AddTech2Known(datum/tech/T)
	for(var/datum/tech/known in known_tech)
		if(T.type == known.type)
			if(T.level > known.level)
				known.level = T.level
			return
	known_tech += T
	return

/datum/research/proc/AddDesign2Known(datum/design/D)
	for(var/datum/design/known in known_designs)
		if(D.type == known.type)
			if(D.reliability_mod > known.reliability_mod)
				known.reliability_mod = D.reliability_mod
			return
	known_designs += D
	return

// Refreshes known_tech and known_designs list. Then updates the reliability vars of the designs in the known_designs list.
// Input/Output: n/a
/datum/research/proc/RefreshResearch()
	for(var/datum/tech/PT in possible_tech)
		if(TechHasReqs(PT))
			AddTech2Known(PT)
	for(var/datum/design/PD in possible_designs)
		if(DesignHasReqs(PD))
			AddDesign2Known(PD)
	for(var/datum/tech/T in known_tech)
		T = clamp(T.level, 1, 20)
	for(var/datum/design/D in known_designs)
		D.CalcReliability(known_tech)
	return

// Refreshes the levels of a given tech.
// Input: Tech's typepath and Level; Output: null
/datum/research/proc/UpdateTech(typepath, level)
	for(var/datum/tech/KT in known_tech)
		if(KT.type == typepath)
			if(KT.level <= level)
				KT.level = max((KT.level + 1), (level - 1))
	return

/datum/research/proc/UpdateDesign(path)
	for(var/datum/design/KD in known_designs)
		if(KD.build_path == path)
			KD.reliability_mod += rand(1, 2)
			break
	return

/***************************************************************
**						Technology Datums					  **
**	Includes all the various technoliges and what they make.  **
***************************************************************/
/datum/tech	//Datum of individual technologies.
	var/name = "name"			// Name of the technology.
	var/desc = "description"	// General description of what it does and what it makes.
	var/level = 1				// A simple number scale of the research level. Level 0 = Secret tech.
	var/list/req_tech = list()	// List of ids associated values of techs required to research this tech. "id" = #

// Trunk Technologies (don't require any other techs and you start knowing them).
/datum/tech/materials
	name = "Materials Research"
	desc = "Development of new and improved materials."

/datum/tech/magnets
	name = "Electromagnetic Spectrum Research"
	desc = "Research into the electromagnetic spectrum. No clue how they actually work, though."

/datum/tech/biotech
	name = "Biological Technology"
	desc = "Research into the deeper mysteries of life and organic substances."

/datum/tech/combat
	name = "Combat Systems Research"
	desc = "The development of offensive and defensive systems."

/datum/tech/engineering
	name = "Engineering Research"
	desc = "Development of new and improved engineering parts and technologies."

/datum/tech/power_storage
	name = "Power Manipulation Technology"
	desc = "The various technologies behind the storage and generation of electicity."

/datum/tech/programming
	name = "Data Theory Research"
	desc = "The development of new computer, artificial intelligence and data storage systems."

/datum/tech/plasma
	name = "Plasma Research"
	desc = "Research into the mysterious substance colloqually known as 'plasma'."

/datum/tech/bluespace
	name = "'Blue-space' Research"
	desc = "Research into the sub-reality known as 'blue-space'."

// Secret Techs
/datum/tech/syndicate
	name = "Illegal Technologies Research"
	desc = "The study of technologies that violate standard NanoTrasen regulations."
	level = 0

// Added this, hopefully it's fixed. -Frenjo
/datum/tech/arcane
	name = "Arcane Research"
	desc = "Research into the occult and arcane fields for use in practical science."
	level = 0

/*
// Branch Techs
/datum/tech/explosives
	name = "Explosives Research"
	desc = "The creation and application of explosive materials."
	req_tech = list(/datum/tech/materials = 3)

/datum/tech/power_generation
	name = "Power Generation Technology"
	desc = "Research into more powerful and more reliable sources."
	req_tech = list(/datum/tech/power_storage = 2)

/datum/tech/robotics
	name = "Robotics Technology"
	desc = "The development of advanced automated, autonomous machines."
	req_tech = list(/datum/tech/materials = 3, /datum/tech/programming = 3)
*/