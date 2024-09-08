GLOBAL_GLOBL_LIST_INIT(department_radio_keys, list(
	// Lowercase variants.
	":w" = "whisper",			"#w" = "whisper",			".w" = "whisper",
	":g" = "changeling",		"#g" = "changeling",		".g" = "changeling",

	":r" = "right ear",			"#r" = "right ear",			".r" = "right ear",
	":l" = "left ear",			"#l" = "left ear",			".l" = "left ear",
	":i" = "intercom",			"#i" = "intercom",			".i" = "intercom",
	":h" = "department",		"#h" = "department",		".h" = "department",

	":t" = CHANNEL_SYNDICATE,	"#t" = CHANNEL_SYNDICATE,	".t" = CHANNEL_SYNDICATE,
	":u" = CHANNEL_SUPPLY,		"#u" = CHANNEL_SUPPLY,		".u" = CHANNEL_SUPPLY,
	":v" = CHANNEL_SERVICE,		"#v" = CHANNEL_SERVICE,		".v" = CHANNEL_SERVICE,
	":n" = CHANNEL_SCIENCE,		"#n" = CHANNEL_SCIENCE,		".n" = CHANNEL_SCIENCE,
	":c" = CHANNEL_COMMAND,		"#c" = CHANNEL_COMMAND,		".c" = CHANNEL_COMMAND,
	":m" = CHANNEL_MEDICAL,		"#m" = CHANNEL_MEDICAL,		".m" = CHANNEL_MEDICAL,
	":e" = CHANNEL_ENGINEERING,	"#e" = CHANNEL_ENGINEERING,	".e" = CHANNEL_ENGINEERING,
	":s" = CHANNEL_SECURITY,	"#s" = CHANNEL_SECURITY,	".s" = CHANNEL_SECURITY,
	":x" = CHANNEL_MINING,		"#x" = CHANNEL_MINING,		".x" = CHANNEL_MINING,

	// Uppercase variants.
	":W" = "whisper",			"#W" = "whisper",			".W" = "whisper",
	":G" = "changeling",		"#G" = "changeling",		".G" = "changeling",

	":R" = "right ear",			"#R" = "right ear",			".R" = "right ear",
	":L" = "left ear",			"#L" = "left ear",			".L" = "left ear",
	":I" = "intercom",			"#I" = "intercom",			".I" = "intercom",
	":H" = "department",		"#H" = "department",		".H" = "department",

	":T" = CHANNEL_SYNDICATE,	"#T" = CHANNEL_SYNDICATE,	".T" = CHANNEL_SYNDICATE,
	":U" = CHANNEL_SUPPLY,		"#U" = CHANNEL_SUPPLY,		".U" = CHANNEL_SUPPLY,
	":V" = CHANNEL_SERVICE,		"#V" = CHANNEL_SERVICE,		".V" = CHANNEL_SERVICE,
	":N" = CHANNEL_SCIENCE,		"#N" = CHANNEL_SCIENCE,		".N" = CHANNEL_SCIENCE,
	":C" = CHANNEL_COMMAND,		"#C" = CHANNEL_COMMAND,		".C" = CHANNEL_COMMAND,
	":M" = CHANNEL_MEDICAL,		"#M" = CHANNEL_MEDICAL,		".M" = CHANNEL_MEDICAL,
	":E" = CHANNEL_ENGINEERING,	"#E" = CHANNEL_ENGINEERING,	".E" = CHANNEL_ENGINEERING,
	":S" = CHANNEL_SECURITY,	"#S" = CHANNEL_SECURITY,	".S" = CHANNEL_SECURITY,
	":X" = CHANNEL_MINING,		"#X" = CHANNEL_MINING,		".X" = CHANNEL_MINING,

	// TODO: Fix this because I don't know russian keyboards. -Frenjo
	//kinda localization -- rastaf0
	//same keys as above, but on russian keyboard layout. This file uses cp1251 as encoding.
	":�" = "whisper",			"#�" = "whisper",			".�" = "whisper",
	":�" = "changeling",		"#�" = "changeling",		".�" = "changeling",

	":�" = "right ear",			"#�" = "right ear",			".�" = "right ear",
	":�" = "left ear",			"#�" = "left ear",			".�" = "left ear",
	":�" = "intercom",			"#�" = "intercom",			".�" = "intercom",
	":�" = "department",		"#�" = "department",		".�" = "department",

	":�" = CHANNEL_SYNDICATE,	"#�" = CHANNEL_SYNDICATE,	".�" = CHANNEL_SYNDICATE,
	":�" = CHANNEL_SUPPLY,		"#�" = CHANNEL_SUPPLY,		".�" = CHANNEL_SUPPLY,
	":�" = CHANNEL_SCIENCE,		"#�" = CHANNEL_SCIENCE,		".�" = CHANNEL_SCIENCE,
	":�" = CHANNEL_COMMAND,		"#�" = CHANNEL_COMMAND,		".�" = CHANNEL_COMMAND,
	":�" = CHANNEL_MEDICAL,		"#�" = CHANNEL_MEDICAL,		".�" = CHANNEL_MEDICAL,
	":�" = CHANNEL_ENGINEERING,	"#�" = CHANNEL_ENGINEERING,	".�" = CHANNEL_ENGINEERING,
	":�" = CHANNEL_SECURITY,	"#�" = CHANNEL_SECURITY,	".�" = CHANNEL_SECURITY
))

/mob/living/proc/binarycheck()
	if(ispAI(src))
		return

	if(!ishuman(src))
		return

	var/mob/living/carbon/human/H = src
	if(isnotnull(H.l_ear) || isnotnull(H.r_ear))
		var/obj/item/radio/headset/dongle
		if(istype(H.l_ear, /obj/item/radio/headset))
			dongle = H.l_ear
		else
			dongle = H.r_ear
		if(!istype(dongle))
			return
		if(dongle.translate_binary)
			return 1

/mob/living/say(message, datum/language/speaking = null, verbage = "says", alt_name = "", italics = 0, message_range = world.view, list/used_radios = list())
	if(stat)
		return

	if(!message)
		return

	var/turf/T = GET_TURF(src)

	var/list/listening = list()
	if(isnotnull(T))
		var/list/objects = list()
		var/list/hear = hear(message_range, T)
		var/list/hearturfs = list()

		for(var/I in hear)
			if(ismob(I))
				var/mob/M = I
				listening.Add(M)
				hearturfs.Add(M.locs[1])
				for(var/obj/O in M.contents)
					objects |= O

			else if(isobj(I))
				var/obj/O = I
				hearturfs.Add(O.locs[1])
				objects |= O

		for_no_type_check(var/mob/M, GLOBL.player_list)
			if(M.stat == DEAD && (M.client?.prefs.toggles & CHAT_GHOSTEARS))
				listening |= M
				continue
			if(M.loc && (M.locs[1] in hearturfs))
				listening |= M

		for(var/obj/O in objects)
			spawn(0)
				O.hear_talk(src, message, verbage, speaking)

	var/speech_bubble_test = say_test(message)
	var/image/speech_bubble = image('icons/mob/talk.dmi', src, "h[speech_bubble_test]")
	spawn(30)
		qdel(speech_bubble)

	if(length(used_radios))
		for(var/mob/living/M in hearers(5, src))
			if(M != src)
				M.show_message(SPAN_NOTICE("[src] talks into [length(used_radios) ? used_radios[1] : "radio"]."))

	for(var/mob/M in listening)
		if(isnotnull(M.client))
			M << speech_bubble
			M.hear_say(message, verbage, speaking, alt_name, italics, src)

	log_say("[name]/[key] : [message]")

/obj/effect/speech_bubble
	var/mob/parent

/mob/living/proc/GetVoice()
	return name