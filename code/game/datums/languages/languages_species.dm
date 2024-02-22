/*
 * Species languages.
 */
/datum/language/human
	name = "Sol Common"
	desc = "A bastardized hybrid of informal English and elements of Mandarin Chinese; the common language of the Sol system."
	colour = "rough"
	key = "1"
	flags = LANGUAGE_FLAG_RESTRICTED

/datum/language/soghun
	name = "Sinta'unathi"
	desc = "The common language of Moghes, composed of sibilant hisses and rattles. Spoken natively by Soghun."
	speech_verb = "hisses"
	colour = "soghun"
	key = "o"
	flags = LANGUAGE_FLAG_RESTRICTED

/datum/language/tajaran
	name = "Siik'maas"
	desc = "The traditionally employed tongue of Ahdomai, composed of expressive yowls and chirps. Native to the Tajaran."
	speech_verb = "mrowls"
	colour = "tajaran"
	key = "j"
	flags = LANGUAGE_FLAG_RESTRICTED

/datum/language/tajaran_sign
	name = "Siik'tajr"
	desc = "An expressive language that combines yowls and chirps with posture, tail and ears. Native to the Tajaran."
	speech_verb = "mrowls"
	colour = "tajaran_signlang"
	key = "y"
	flags = LANGUAGE_FLAG_RESTRICTED | LANGUAGE_FLAG_NONVERBAL

/datum/language/skrell
	name = "Skrellian"
	desc = "A melodic and complex language spoken by the Skrell of Qerrbalak. Some of the notes are inaudible to humans."
	speech_verb = "warbles"
	colour = "skrell"
	key = "k"
	flags = LANGUAGE_FLAG_RESTRICTED

/datum/language/vox
	name = "Vox-Pidgin"
	desc = "The common tongue of the various Vox ships making up the Shoal. It sounds like chaotic shrieking to everyone else."
	speech_verb = "shrieks"
	colour = "vox"
	key = "v"
	flags = LANGUAGE_FLAG_RESTRICTED

/datum/language/diona
	name = "Rootspeak"
	desc = "A creaking, subvocal language spoken instinctively by the Dionaea. Due to the unique makeup of the average Diona, a phrase of Rootspeak can be a combination of anywhere from one to twelve individual voices and notes."
	speech_verb = "creaks and rustles"
	colour = "soghun"
	key = "q"
	flags = LANGUAGE_FLAG_RESTRICTED

/datum/language/obsedai
	name = "Obsedaian"
	desc = "The common tongue of the Obsedai. It sounds like deep rumbling and resonant notes to everyone else."
	speech_verb = "rumbles"
	colour = "vox"
	key = "r"
	flags = LANGUAGE_FLAG_RESTRICTED

/datum/language/plasmalin
	name = "Plasmalin"
	desc = "A rattling, clunky 'language' spoken natively by Plasmalins."
	speech_verb = "rattles"
	colour = "vox"
	key = "p"
	flags = LANGUAGE_FLAG_RESTRICTED

/datum/language/machine
	name = "Binary Audio Language"
	desc = "Series of beeps, boops, blips and blops representing encoded binary data, frequently used for efficient Machine-Machine communication."
	speech_verb = "emits"
	colour = "vox"
	key = "l"
	flags = LANGUAGE_FLAG_RESTRICTED