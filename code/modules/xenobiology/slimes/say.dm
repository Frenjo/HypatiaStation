/mob/living/simple/slime/say(message)
	if(silent)
		return
	else
		return ..()

/mob/living/simple/slime/say_quote(text)
	var/ending = copytext(text, length(text))

	if(ending == "?")
		return "telepathically asks"
	else if(ending == "!")
		return "telepathically cries"

	return "telepathically chirps"

/mob/living/simple/slime/say_understands(other)
	if(isslime(other))
		return TRUE
	return ..()