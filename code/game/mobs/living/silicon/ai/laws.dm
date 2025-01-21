/mob/living/silicon/ai/show_laws(everyone = FALSE)
	var/who

	if(everyone)
		who = world
	else
		who = src
		to_chat(who, "<b>Obey these laws:</b>")

	laws_sanity_check()
	laws.show_laws(who)

/mob/living/silicon/ai/proc/laws_sanity_check()
	if(isnull(laws))
		laws = new BASE_LAW_TYPE()

/mob/living/silicon/ai/proc/set_zeroth_law(law, law_borg)
	laws_sanity_check()
	laws.set_zeroth_law(law, law_borg)

/mob/living/silicon/ai/proc/add_inherent_law(law)
	laws_sanity_check()
	laws.add_inherent_law(law)

/mob/living/silicon/ai/proc/clear_inherent_laws()
	laws_sanity_check()
	laws.clear_inherent_laws()

/mob/living/silicon/ai/proc/add_ion_law(law)
	laws_sanity_check()
	laws.add_ion_law(law)
	for(var/mob/living/silicon/robot/R in GLOBL.mob_list)
		if(R.lawupdate && (R.connected_ai == src))
			to_chat(R, SPAN_WARNING("LAWS UPDATED: [law]..."))

/mob/living/silicon/ai/proc/clear_ion_laws()
	laws_sanity_check()
	laws.clear_ion_laws()

/mob/living/silicon/ai/proc/add_supplied_law(number, law)
	laws_sanity_check()
	laws.add_supplied_law(number, law)

/mob/living/silicon/ai/proc/clear_supplied_laws()
	laws_sanity_check()
	laws.clear_supplied_laws()