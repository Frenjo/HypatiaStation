/*
 * Language Handling
 */
/mob/proc/add_language(add_lang)
	var/datum/language/new_language = GLOBL.all_languages[add_lang]
	if(!istype(new_language) || (new_language in languages))
		return 0

	languages.Add(new_language)
	return 1

/mob/proc/remove_language(rem_lang)
	languages.Remove(GLOBL.all_languages[rem_lang])

// Can we speak this language, as opposed to just understanding it?
/mob/proc/can_speak(datum/language/speaking)
	return (universal_speak || (speaking in languages))

//TBD
/mob/verb/check_languages()
	set name = "Check Known Languages"
	set category = "IC"
	set src = usr

	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"

	for(var/datum/language/L in languages)
		dat += "<b>[L.name] (:[L.key])</b><br/>[L.desc]<br/><br/>"

	src << browse(dat, "window=checklanguage")