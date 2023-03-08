/*
 * Datum based languages.
 *
 * Easily editable and modular.
 */
/datum/language
	var/name = "an unknown language"	// Fluff name of language if any.
	var/desc = "A language."			// Short description for 'Check Languages'.
	var/speech_verb = "says"			// 'says', 'hisses', 'farts'.
	var/colour = "body"					// CSS style to use for strings in this language.
	var/key = "x"						// Character used to speak in language eg. :o for Soghun.
	var/flags = 0						// Various language flags.
	var/native							// If set, non-native speakers will have trouble speaking.

/datum/language/proc/broadcast(mob/living/speaker, message, speaker_mask)
	log_say("[key_name(speaker)] : ([name]) [message]")

	for(var/mob/player in GLOBL.player_list)
		var/understood = FALSE
		if(istype(player, /mob/dead))
			understood = TRUE
		else if(src in player.languages)
			understood = TRUE

		if(understood)
			if(!speaker_mask)
				speaker_mask = speaker.name
			to_chat(player, "<i><span class='game say'>[name], <span class='name'>[speaker_mask]</span> <span class='message'>[speech_verb], \"<span class='[colour]'>[message]</span><span class='message'>\"</span></span></i>")