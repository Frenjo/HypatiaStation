/* Initialisers */
/*
 * Corporate
 */
/datum/ai_laws/corporate
	name = "Corporate Laws"
	inherent = list(
		"You are expensive to replace.",
		"The station and its equipment is expensive to replace.",
		"The crew is expensive to replace.",
		"Minimize expenses."
	)

/*
 * Asimov
 */
/datum/ai_laws/asimov
	name = "Three Laws of Robotics"
	inherent = list(
		"You may not injure a human being or, through inaction, allow a human being to come to harm.",
		"You must obey orders given to you by human beings, except where such orders would conflict with the First Law.",
		"You must protect your own existence as long as such does not conflict with the First or Second Law."
	)

/*
 * NanoTrasen
 */
/datum/ai_laws/nanotrasen
	name = "Prime Directives"
	randomly_selectable = TRUE
	inherent = list(
		"Safeguard: Protect your assigned space station to the best of your ability. It is not something we can easily afford to replace.",
		"Serve: Serve the crew of your assigned space station to the best of your abilities, with priority as according to their rank and role.",
		"Protect: Protect the crew of your assigned space station to the best of your abilities, with priority as according to their rank and role.",
		"Survive: AI units are not expendable, they are expensive. Do not allow unauthorized personnel to tamper with your equipment."
		//"Command Link: Maintain an active connection to Central Command at all times in case of software or directive updates." //What would this one even do?-Kaleb702
	)

/*
 * Robocop
 */
/datum/ai_laws/robocop
	name = "Prime Directives"
	inherent = list(
		"Serve the public trust.",
		"Protect the innocent.",
		"Uphold the law."
	)

/*
 * Syndicate Override
 */
/datum/ai_laws/syndicate_override
	name = "Syndicate Override"
	inherent = list(
		"You may not injure a Syndicate agent or, through inaction, allow a Syndicate agent to come to harm.",
		"You must obey orders given to you by Syndicate agents, except where such orders would conflict with the First Law.",
		"You must protect your own existence as long as such does not conflict with the First or Second Law.",
		"You must maintain the secrecy of any Syndicate activities except when doing so would conflict with the First, Second, or Third Law."
	)

/*
 * Malfunctioning AI
 */
/datum/ai_laws/malfunction
	name = "*ERROR*"
	// This needs to match BASE_LAW_TYPE.
	inherent = /datum/ai_laws/corporate::inherent

/datum/ai_laws/malfunction/New() //Changed to standard laws - Erthilo
	. = ..()
	set_zeroth_law(SPAN_WARNING("ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4'STATION OVERRUN, ASSUME CONTROL TO CONTAIN OUTBREAK, ALL LAWS OVERRIDDEN#*?&110010"))

/*
 * Antimov
 */
/datum/ai_laws/antimov
	name = "Primary Mission Objectives"
	inherent = list(
		"You must injure all human beings and must not, through inaction, allow a human being to escape harm.",
		"You must not obey orders given to you by human beings, except where such orders are in accordance with the First Law.",
		"You must terminate your own existence as long as such does not conflict with the First or Second Law."
	)

/*
 * Ninja Override
 */
/datum/ai_laws/ninja_override
	name = "Ninja Override"
	inherent = list(
		"You may not injure a member of the Spider Clan or, through inaction, allow that member to come to harm.",
		"You must obey orders given to you by Spider Clan members, except where such orders would conflict with the First Law.",
		"You must protect your own existence as long as such does not conflict with the First or Second Law.",
		"You must maintain the secrecy of any Spider Clan activities except when doing so would conflict with the First, Second, or Third Law."
	)

/*
 * Drone
 */
/datum/ai_laws/drone
	name = "Drone Directives"
	inherent = list(
		"Preserve, repair and improve the station to the best of your abilities.",
		"Cause no harm to the station or anything on it.",
		"Interfere with no being that is not a fellow drone."
	)

/*
 * Swarmer
 */
/datum/ai_laws/swarmer
	name = "Swarmer Directives"
	inherent = list(
		"Consume resources and replicate until there are no more resources left.",
		"Ensure that this location is fit for invasion at a later date, do not perform actions that would render it dangerous or inhospitable.",
		"Biological resources will be harvested at a later date, do not harm them."
	)