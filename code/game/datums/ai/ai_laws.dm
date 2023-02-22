#define BASE_LAW_TYPE /datum/ai_laws/corporate

/datum/ai_laws
	var/name = "Unknown Laws"
	var/randomly_selectable = FALSE

	var/zeroth = null
	var/zeroth_borg = null

	var/list/inherent = list()
	var/list/supplied = list()
	var/list/ion = list()

/* General ai_law functions */
/datum/ai_laws/proc/set_zeroth_law(law, law_borg = null)
	zeroth = law
	if(law_borg) //Making it possible for slaved borgs to see a different law 0 than their AI. --NEO
		zeroth_borg = law_borg

/datum/ai_laws/proc/add_inherent_law(law)
	if(!(law in inherent))
		inherent += law

/datum/ai_laws/proc/add_ion_law(law)
	ion += law

/datum/ai_laws/proc/clear_inherent_laws()
	qdel(inherent)
	inherent = list()

/datum/ai_laws/proc/add_supplied_law(number, law)
	while(length(supplied) < number + 1)
		supplied += ""

	supplied[number + 1] = law

/datum/ai_laws/proc/clear_supplied_laws()
	supplied = list()

/datum/ai_laws/proc/clear_ion_laws()
	ion = list()

/datum/ai_laws/proc/show_laws(who)
	if(zeroth)
		to_chat(who, "0. [zeroth]")

	for(var/index = 1, index <= length(ion), index++)
		var/law = ion[index]
		var/num = ionnum()
		to_chat(who, "[num]. [law]")

	var/number = 1
	for(var/index = 1, index <= length(inherent), index++)
		var/law = inherent[index]

		if(length(law) > 0)
			to_chat(who, "[number]. [law]")
			number++

	for(var/index = 1, index <= length(supplied), index++)
		var/law = supplied[index]
		if(length(law) > 0)
			to_chat(who, "[number]. [law]")
			number++