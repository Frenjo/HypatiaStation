/mob/living/captive_brain
	name = "host brain"
	real_name = "host brain"

/mob/living/captive_brain/say(message)
	if(src.client)
		if(client.prefs.muted & MUTE_IC)
			FEEDBACK_IC_MUTED(src)
			return
		if(src.client.handle_spam_prevention(message,MUTE_IC))
			return

	if(istype(src.loc, /mob/living/simple/borer))
		var/mob/living/simple/borer/B = src.loc
		src << "You whisper silently, \"[message]\""
		B.host << "The captive mind of [src] whispers, \"[message]\""

		for_no_type_check(var/mob/M, GLOBL.player_list)
			if(isnewplayer(M))
				continue
			else if(M.stat == DEAD &&  M.client.prefs.toggles & CHAT_GHOSTEARS)
				M << "The captive mind of [src] whispers, \"[message]\""

/mob/living/captive_brain/emote(message)
	return

/mob/living/simple/borer
	name = "cortical borer"
	real_name = "cortical borer"
	desc = "A small, quivering sluglike creature."
	speak_emote = list("chirrups")
	emote_hear = list("chirrups")
	response_help = "pokes the"
	response_disarm = "prods the"
	response_harm = "stomps on the"
	icon_state = "brainslug"
	icon_living = "brainslug"
	icon_dead = "brainslug_dead"
	pass_flags = PASS_FLAG_TABLE
	speed = 5
	a_intent = "harm"
	stop_automated_movement = TRUE
	status_flags = CANPUSH
	attacktext = "nips"
	friendly = "prods"
	wander = FALSE

	var/used_dominate
	var/chemicals = 10						// Chemicals used for reproduction and spitting neurotoxin.
	var/mob/living/carbon/human/host		// Human host for the brain worm.
	var/truename							// Name used for brainworm-speak.
	var/mob/living/captive_brain/host_brain // Used for swapping control of the body back and forth.
	var/controlling = FALSE					// Used in human death check.
	var/docile = 0							// Sugar can stop borers from acting.

/mob/living/simple/borer/Life()
	..()

	if(host)
		if(!stat && !host.stat)
			if(host.reagents.has_reagent("sugar"))
				if(!docile)
					if(controlling)
						host << "\blue You feel the soporific flow of sugar in your host's blood, lulling you into docility."
					else
						src << "\blue You feel the soporific flow of sugar in your host's blood, lulling you into docility."
					docile = 1
			else
				if(docile)
					if(controlling)
						host << "\blue You shake off your lethargy as the sugar leaves your host's blood."
					else
						src << "\blue You shake off your lethargy as the sugar leaves your host's blood."
					docile = 0

			if(chemicals < 250)
				chemicals++
			if(controlling)
				if(docile)
					host << "\blue You are feeling far too docile to continue controlling your host..."
					host.release_control()
					return

				if(prob(5))
					host.adjustBrainLoss(rand(1, 2))

				if(prob(host.brainloss/20))
					host.say("*[pick(list("blink", "blink_r", "choke", "aflap", "drool", "twitch", "twitch_s", "gasp"))]")

/mob/living/simple/borer/New()
	..()
	truename = "[pick("Primary", "Secondary", "Tertiary", "Quaternary")] [rand(1000, 9999)]"
	host_brain = new/mob/living/captive_brain(src)

	request_player()


/mob/living/simple/borer/say(message)
	message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))
	message = capitalize(message)

	if(!message)
		return

	if(stat == DEAD)
		return say_dead(message)

	if(stat)
		return

	if(src.client)
		if(client.prefs.muted & MUTE_IC)
			FEEDBACK_IC_MUTED(src)
			return
		if(src.client.handle_spam_prevention(message,MUTE_IC))
			return

	if(copytext(message, 1, 2) == "*")
		return emote(copytext(message, 2))

	if(copytext(message, 1, 2) == ";") //Brain borer hivemind.
		return borer_speak(message)

	if(!host)
		src << "You have no host to speak to."
		return //No host, no audible speech.

	src << "You drop words into [host]'s mind: \"[message]\""
	host << "Your own thoughts speak: \"[message]\""

	for_no_type_check(var/mob/M, GLOBL.player_list)
		if(isnewplayer(M))
			continue
		else if(M.stat == DEAD &&  M.client.prefs.toggles & CHAT_GHOSTEARS)
			M << "[src.truename] whispers to [host], \"[message]\""


/mob/living/simple/borer/Stat()
	..()
	statpanel(PANEL_STATUS)

	if(global.PCemergency)
		if(global.PCemergency.online() && !global.PCemergency.returned())
			var/timeleft = global.PCemergency.estimate_arrival_time()
			if(timeleft)
				stat(null, "ETA-[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")

	if(client.statpanel == PANEL_STATUS)
		stat("Chemicals", chemicals)

// VERBS!

/mob/living/simple/borer/proc/borer_speak(message)
	if(!message)
		return

	for(var/mob/M in GLOBL.mob_list)
		if(M.mind && (istype(M, /mob/living/simple/borer) || isghost(M)))
			M << "<i>Cortical link, <b>[truename]:</b> [copytext(message, 2)]</i>"


/mob/living/simple/borer/verb/dominate_victim()
	set category = "Alien"
	set name = "Dominate Victim"
	set desc = "Freeze the limbs of a potential host with supernatural fear."

	if(world.time - used_dominate < 300)
		src << "You cannot use that ability again so soon."
		return

	if(host)
		src << "You cannot do that from within a host body."
		return

	if(src.stat)
		src << "You cannot do that in your current state."
		return

	var/list/choices = list()
	for(var/mob/living/carbon/C in view(3, src))
		if(C.stat != DEAD)
			choices += C

	if(world.time - used_dominate < 300)
		src << "You cannot use that ability again so soon."
		return

	var/mob/living/carbon/M = input(src,"Who do you wish to dominate?") in null|choices

	if(!M || !src)
		return

	if(M.has_brain_worms())
		src << "You cannot infest someone who is already infested!"
		return

	src << "\red You focus your psychic lance on [M] and freeze their limbs with a wave of terrible dread."
	M << "\red You feel a creeping, horrible sense of dread come over you, freezing your limbs and setting your heart racing."
	M.Weaken(3)

	used_dominate = world.time


/mob/living/simple/borer/verb/bond_brain()
	set category = "Alien"
	set name = "Assume Control"
	set desc = "Fully connect to the brain of your host."

	if(isnull(host))
		to_chat(src, "You are not inside a host body.")
		return

	if(stat)
		to_chat(src, "You cannot do that in your current state.")
		return

	if(isnull(host.internal_organs_by_name["brain"])) //this should only run in admin-weirdness situations, but it's here non the less - RR
		to_chat(src, SPAN_WARNING("There is no brain here for us to command!"))
		return

	if(docile)
		to_chat(src, SPAN_INFO("You are feeling far too docile to do that."))
		return

	to_chat(src, "You begin delicately adjusting your connection to the host brain...")

	spawn(300 + (host.brainloss * 5))
		if(isnull(host) || isnull(src) || controlling)
			return
		else
			to_chat(src, SPAN_DANGER("You plunge your probosci deep into the cortex of the host brain, interfacing directly with their nervous system."))
			to_chat(host, SPAN_DANGER("You feel a strange shifting sensation behind your eyes as an alien consciousness displaces yours."))

			host_brain.ckey = host.ckey
			host.ckey = src.ckey
			controlling = TRUE

			host.verbs += /mob/living/carbon/proc/release_control
			host.verbs += /mob/living/carbon/proc/punish_host
			host.verbs += /mob/living/carbon/proc/spawn_larvae


/mob/living/simple/borer/verb/secrete_chemicals()
	set category = "Alien"
	set name = "Secrete Chemicals"
	set desc = "Push some chemicals into your host's bloodstream."

	if(!host)
		src << "You are not inside a host body."
		return

	if(stat)
		src << "You cannot secrete chemicals in your current state."

	if(docile)
		src << "\blue You are feeling far too docile to do that."
		return

	if(chemicals < 50)
		src << "You don't have enough chemicals!"

	var/chem = input("Select a chemical to secrete.", "Chemicals") in list("bicaridine","tramadol","hyperzine","alkysine")

	if(chemicals < 50 || !host || controlling || !src || stat) //Sanity check.
		return

	src << "\red <B>You squirt a measure of [chem] from your reservoirs into [host]'s bloodstream.</B>"
	host.reagents.add_reagent(chem, 15)
	chemicals -= 50


/mob/living/simple/borer/verb/release_host()
	set category = "Alien"
	set name = "Release Host"
	set desc = "Slither out of your host."

	if(!host)
		src << "You are not inside a host body."
		return

	if(stat)
		src << "You cannot leave your host in your current state."

	if(docile)
		src << "\blue You are feeling far too docile to do that."
		return

	if(!host || !src)
		return

	src << "You begin disconnecting from [host]'s synapses and prodding at their internal ear canal."

	if(!host.stat)
		host << "An odd, uncomfortable pressure begins to build inside your skull, behind your ear..."

	spawn(200)
		if(!host || !src)
			return

		if(src.stat)
			src << "You cannot infest a target in your current state."
			return

		src << "You wiggle out of [host]'s ear and plop to the ground."
		if(!host.stat)
			host << "Something slimy wiggles out of your ear and plops to the ground!"

		detatch()

/mob/living/simple/borer/proc/detatch()
	if(!host)
		return

	if(ishuman(host))
		var/mob/living/carbon/human/H = host
		var/datum/organ/external/head = H.get_organ("head")
		head.implants -= src

	forceMove(GET_TURF(host))
	controlling = 0

	reset_view(null)
	machine = null

	host.reset_view(null)
	host.machine = null

	host.verbs -= /mob/living/carbon/proc/release_control
	host.verbs -= /mob/living/carbon/proc/punish_host
	host.verbs -= /mob/living/carbon/proc/spawn_larvae

	if(host_brain.ckey)
		src.ckey = host.ckey
		host.ckey = host_brain.ckey
		host_brain.ckey = null
		host_brain.name = "host brain"
		host_brain.real_name = "host brain"

	host = null


/mob/living/simple/borer/verb/infest()
	set category = "Alien"
	set name = "Infest"
	set desc = "Infest a suitable humanoid host."

	if(host)
		src << "You are already within a host."
		return

	if(stat)
		src << "You cannot infest a target in your current state."
		return

	var/list/choices = list()
	for(var/mob/living/carbon/C in view(1,src))
		if(C.stat != DEAD && src.Adjacent(C))
			choices += C

	var/mob/living/carbon/M = input(src, "Who do you wish to infest?") in null|choices

	if(!M || !src)
		return

	if(!(src.Adjacent(M)))
		return

	if(M.has_brain_worms())
		src << "You cannot infest someone who is already infested!"
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.check_head_coverage())
			src << "You cannot get through that host's protective gear."
			return

	M << "Something slimy begins probing at the opening of your ear canal..."
	src << "You slither up [M] and begin probing at their ear canal..."

	if(!do_after(src, 50))
		src << "As [M] moves away, you are dislodged and fall to the ground."
		return

	if(!M || !src)
		return

	if(src.stat)
		src << "You cannot infest a target in your current state."
		return

	if(M.stat == DEAD)
		src << "That is not an appropriate target."
		return

	if(M in view(1, src))
		src << "You wiggle into [M]'s ear."
		if(!M.stat)
			M << "Something disgusting and slimy wiggles into your ear!"

		src.host = M
		forceMove(M)

		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/datum/organ/external/head = H.get_organ("head")
			head.implants += src

		host_brain.name = M.name
		host_brain.real_name = M.real_name

		return
	else
		src << "They are no longer in range!"
		return

//Procs for grabbing players.
/mob/living/simple/borer/proc/request_player()
	for(var/mob/dead/ghost/O in GLOBL.player_list)
		if(jobban_isbanned(O, "Syndicate"))
			continue
		if(O.client)
			if(O.client.prefs.be_special & BE_ALIEN)
				question(O.client)


/mob/living/simple/borer/proc/question(client/C)
	spawn(0)
		if(!C)
			return
		var/response = alert(C, "A cortical borer needs a player. Are you interested?", "Cortical borer request", "Yes", "No", "Never for this round")
		if(!C || ckey)
			return
		if(response == "Yes")
			transfer_personality(C)
		else if(response == "Never for this round")
			C.prefs.be_special ^= BE_ALIEN


/mob/living/simple/borer/proc/transfer_personality(client/candidate)
	if(!candidate)
		return

	src.mind = candidate.mob.mind
	src.ckey = candidate.ckey
	if(src.mind)
		src.mind.assigned_role = "Cortical Borer"