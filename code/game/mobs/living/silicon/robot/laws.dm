/mob/living/silicon/robot/show_laws(everyone = 0)
	laws_sanity_check()
	var/who
	if(everyone)
		who = world
	else
		who = src

	if(lawupdate)
		if(isnotnull(connected_ai))
			if(connected_ai.stat || connected_ai.control_disabled)
				to_chat(src, "<b>AI signal lost, unable to sync laws.</b>")
			else
				lawsync()
				to_chat(src, "<b>Laws synced with AI, be sure to note any changes.</b>")
				if(isnotnull(mind) && mind.special_role == "traitor" && mind.original == src)
					to_chat(src, "<b>Remember, your AI does NOT share or know about your law 0.")
		else
			to_chat(src, "<b>No AI selected to sync laws with, disabling lawsync protocol.</b>")
			lawupdate = 0

	to_chat(who, "<b>Obey these laws:</b>")
	laws.show_laws(who)
	if(isnotnull(mind) && (mind.special_role == "traitor" && mind.original == src) && isnotnull(connected_ai))
		to_chat(who, "<b>Remember, [connected_ai.name] is technically your master, but your objective comes first.</b>")
	else if(isnotnull(connected_ai))
		to_chat(who, "<b>Remember, [connected_ai.name] is your master, other AIs can be ignored.</b>")
	else if(emagged)
		to_chat(who, "<b>Remember, you are not required to listen to the AI.</b>")
	else
		to_chat(who, "<b>Remember, you are not bound to any AI, you are not required to listen to them.</b>")

/mob/living/silicon/robot/proc/lawsync()
	laws_sanity_check()
	var/datum/ai_laws/master = connected_ai ? connected_ai.laws : null
	var/temp
	if(isnotnull(master))
		laws.ion.len = length(master.ion)
		for(var/index = 1, index <= length(master.ion), index++)
			temp = master.ion[index]
			if(length(temp) > 0)
				laws.ion[index] = temp

		if(!is_special_character(src) || mind.original != src)
			if(isnotnull(master.zeroth_borg)) // If the AI has a defined law zero specifically for its borgs, give it that one, otherwise give it the same one. --NEO
				temp = master.zeroth_borg
			else
				temp = master.zeroth
			laws.zeroth = temp

		laws.inherent.len = length(master.inherent)
		for(var/index = 1, index <= length(master.inherent), index++)
			temp = master.inherent[index]
			if(length(temp) > 0)
				laws.inherent[index] = temp

		laws.supplied.len = length(master.supplied)
		for(var/index = 1, index <= length(master.supplied), index++)
			temp = master.supplied[index]
			if(length(temp) > 0)
				laws.supplied[index] = temp

/mob/living/silicon/robot/proc/laws_sanity_check()
	if(isnull(laws))
		laws = new BASE_LAW_TYPE()

/mob/living/silicon/robot/proc/set_zeroth_law(law)
	laws_sanity_check()
	laws.set_zeroth_law(law)

/mob/living/silicon/robot/proc/add_inherent_law(law)
	laws_sanity_check()
	laws.add_inherent_law(law)

/mob/living/silicon/robot/proc/clear_inherent_laws()
	laws_sanity_check()
	laws.clear_inherent_laws()

/mob/living/silicon/robot/proc/add_supplied_law(number, law)
	laws_sanity_check()
	laws.add_supplied_law(number, law)

/mob/living/silicon/robot/proc/clear_supplied_laws()
	laws_sanity_check()
	laws.clear_supplied_laws()

/mob/living/silicon/robot/proc/add_ion_law(law)
	laws_sanity_check()
	laws.add_ion_law(law)

/mob/living/silicon/robot/proc/clear_ion_laws()
	laws_sanity_check()
	laws.clear_ion_laws()