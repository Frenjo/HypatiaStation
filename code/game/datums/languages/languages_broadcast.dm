/*
 * Broadcast languages.
 */
/datum/language/xenos
	name = "Hivemind"
	desc = "Xenomorphs have the strange ability to commune over a psychic hivemind."
	speech_verb = "hisses"
	colour = "alien"
	key = "a"
	flags = LANGUAGE_FLAG_RESTRICTED | LANGUAGE_FLAG_HIVEMIND

/datum/language/ling
	name = "Changeling"
	desc = "Although they are normally wary and suspicious of each other, changelings can commune over a distance."
	speech_verb = "says"
	colour = "changeling"
	key = "g"
	flags = LANGUAGE_FLAG_RESTRICTED | LANGUAGE_FLAG_HIVEMIND

/datum/language/ling/broadcast(mob/living/speaker, message, speaker_mask)
	if(speaker.mind?.changeling)
		..(speaker, message, speaker.mind.changeling.changelingID)
	else
		..(speaker, message)

/datum/language/binary
	name = "Robot Talk"
	desc = "Most human stations support free-use communications protocols and routing hubs for synthetic use."
	speech_verb = "transmits"
	colour = "say_quote"
	key = "b"
	flags = LANGUAGE_FLAG_RESTRICTED | LANGUAGE_FLAG_HIVEMIND

	var/drone_only

/datum/language/binary/broadcast(mob/living/speaker, message, speaker_mask)
	if(!speaker.binarycheck())
		return
	if(isnull(message))
		return

	var/message_start = "<i><span class='game say'>[name], <span class='name'>[speaker.name]</span>"
	var/message_body = "<span class='message'>[speaker.say_quote(message)], \"[message]\"</span></span></i>"

	for_no_type_check(var/mob/M, GLOBL.dead_mob_list)
		if(!isnewplayer(M) && !isbrain(M)) //No meta-evesdropping
			M.show_message("[message_start] [message_body]", 2)

	for(var/mob/living/S in GLOBL.living_mob_list)
		if(drone_only && !isdrone(S))
			continue
		if(isAI(S))
			message_start = "<i><span class='game say'>[name], <a href='byond://?src=\ref[S];track2=\ref[S];track=\ref[src];trackname=[html_encode(speaker.name)]'><span class='name'>[speaker.name]</span></a>"
		else if(!S.binarycheck())
			continue

		S.show_message("[message_start] [message_body]", 2)

	var/list/listening = hearers(1, src)
	listening.Remove(src)

	for(var/mob/living/M in listening)
		if(issilicon(M) || M.binarycheck())
			continue
		M.show_message("<i><span class='game say'><span class='name'>synthesised voice</span> <span class='message'>beeps, \"beep beep beep\"</span></span></i>",2)

/datum/language/binary/drone
	name = "Drone Talk"
	desc = "A heavily encoded damage control coordination stream."
	key = "d"

	drone_only = TRUE