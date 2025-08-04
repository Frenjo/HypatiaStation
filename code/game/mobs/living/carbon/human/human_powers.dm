// These should all be procs, you can add them to humans/subspecies by
// species.dm's inherent_verbs ~ Z

/mob/living/carbon/human/proc/tackle()
	set category = "Abilities"
	set name = "Tackle"
	set desc = "Tackle someone down."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, SPAN_WARNING("You cannot tackle someone in your current state."))
		return

	var/list/choices = list()
	for(var/mob/living/M in view(6,src))
		if(!issilicon(M))
			choices += M
	choices -= src

	var/mob/living/T = input(src,"Who do you wish to tackle?") as null|anything in choices

	if(!T || !src || src.stat) return

	if(get_dist(GET_TURF(T), GET_TURF(src)) > 6)
		return

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, SPAN_WARNING("You cannot leap in your current state."))
		return

	last_special = world.time + 50

	var/failed
	if(prob(75))
		T.Weaken(rand(0.5,3))
	else
		src.Weaken(rand(2,4))
		failed = 1

	playsound(loc, 'sound/weapons/melee/pierce.ogg', 25, 1, -1)
	if(failed)
		src.Weaken(rand(2,4))

	visible_message(SPAN_DANGER("[src] [failed ? "tried to tackle" : "has tackled"] down [T]!"))

/mob/living/carbon/human/proc/leap()
	set category = "Abilities"
	set name = "Leap"
	set desc = "Leap at a target and grab them aggressively."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying)
		to_chat(src, SPAN_WARNING("You cannot leap in your current state."))
		return

	var/list/choices = list()
	for(var/mob/living/M in view(6, src))
		if(!issilicon(M))
			choices += M
	choices -= src

	var/mob/living/T = input(src,"Who do you wish to leap at?") in null|choices

	if(!T || !src || src.stat)
		return

	if(get_dist(GET_TURF(T), GET_TURF(src)) > 6)
		return

	last_special = world.time + 100
	status_flags |= LEAPING

	visible_message(SPAN_WARNING("<b>\The [src]</b> leaps at [T]!"))
	src.throw_at(get_step(GET_TURF(T), GET_TURF(src)), 5, 1)
	playsound(src.loc, 'sound/voice/shriek1.ogg', 50, 1)

	sleep(5)

	if(status_flags & LEAPING)
		status_flags &= ~LEAPING

	if(!src.Adjacent(T))
		to_chat(src, SPAN_WARNING("You miss!"))
		return

	T.Weaken(5)

	var/use_hand = "left"
	if(l_hand)
		if(r_hand)
			to_chat(src, SPAN_WARNING("You need to have one hand free to grab someone."))
			return
		else
			use_hand = "right"

	visible_message(SPAN_WARNING("<b>\The [src]</b> seizes [T] aggressively!"))

	var/obj/item/grab/G = new(src, T)
	if(use_hand == "left")
		l_hand = G
	else
		r_hand = G

	G.state = GRAB_AGGRESSIVE
	G.icon_state = "grabbed1"
	G.synch()

/mob/living/carbon/human/proc/gut()
	set category = "Abilities"
	set name = "Gut"
	set desc = "While grabbing someone aggressively, rip their guts out or tear them apart."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying)
		to_chat(src, SPAN_WARNING("You cannot do that in your current state."))
		return

	var/obj/item/grab/G = locate() in src
	if(!G || !istype(G))
		to_chat(src, SPAN_WARNING("You are not grabbing anyone."))
		return

	if(G.state < GRAB_AGGRESSIVE)
		to_chat(src, SPAN_WARNING("You must have an aggressive grab to gut your prey!"))
		return

	last_special = world.time + 50

	visible_message(SPAN_WARNING("<b>\The [src]</b> rips viciously at \the [G.affecting]'s body with its claws!"))

	if(ishuman(G.affecting))
		var/mob/living/carbon/human/H = G.affecting
		H.apply_damage(50, BRUTE)
		if(H.stat == DEAD)
			H.gib()
	else
		var/mob/living/M = G.affecting
		if(!istype(M))
			return //wut
		M.apply_damage(50, BRUTE)
		if(M.stat == DEAD)
			M.gib()

/mob/living/carbon/human/proc/commune()
	set category = "Abilities"
	set name = "Commune with creature"
	set desc = "Send a telepathic message to an unlucky recipient."

	var/list/targets = list()
	var/target = null
	var/text = null

	targets += getmobs() //Fill list, prompt user with list
	target = input("Select a creature!", "Speak to creature", null, null) as null|anything in targets

	if(!target) return

	text = input("What would you like to say?", "Speak to creature", null, null)

	text = trim(copytext(sanitize(text), 1, MAX_MESSAGE_LEN))

	if(!text) return

	var/mob/M = targets[target]

	if(isghost(M) || M.stat == DEAD)
		to_chat(src, SPAN_WARNING("Not even a [species.name] can speak to the dead."))
		return

	log_say("[key_name(src)] communed to [key_name(M)]: [text]")

	M << "\blue Like lead slabs crashing into the ocean, alien thoughts drop into your mind: [text]"
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.name == src.species.name)
			return
		H << "\red Your nose begins to bleed..."
		H.drip(1)

/mob/living/carbon/human/proc/regurgitate()
	set name = "Regurgitate"
	set desc = "Empties the contents of your stomach"
	set category = "Abilities"

	if(length(stomach_contents))
		for(var/mob/M in src)
			if(M in stomach_contents)
				stomach_contents.Remove(M)
				M.forceMove(loc)
		src.visible_message(SPAN_DANGER("[src] hurls out the contents of their stomach!"))
	return

/mob/living/carbon/human/proc/psychic_whisper(mob/M as mob in oview())
	set name = "Psychic Whisper"
	set desc = "Whisper silently to someone over a distance."
	set category = "Abilities"

	var/msg = sanitize(input("Message:", "Psychic Whisper") as text | null)
	if(msg)
		log_say("PsychicWhisper: [key_name(src)]->[M.key] : [msg]")
		to_chat(M, SPAN_ALIUM("You hear a strange, alien voice in your head... \italic [msg]"))
		to_chat(src, SPAN_ALIUM("You said: \"[msg]\" to [M]."))
	return