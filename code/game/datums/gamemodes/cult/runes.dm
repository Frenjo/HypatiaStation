var/list/sacrificed = list()

/obj/effect/rune
/////////////////////////////////////////FIRST RUNE
/obj/effect/rune/proc/teleport(key)
	var/mob/living/user = usr
	var/list/allrunesloc = list()
	var/index = 0
//	var/tempnum = 0
	for(var/obj/effect/rune/R in GLOBL.movable_atom_list)
		if(R == src)
			continue
		if(R.word1 == cultwords["travel"] && R.word2 == cultwords["self"] && R.word3 == key && isplayerlevel(R.z))
			index++
			allrunesloc.len = index
			allrunesloc[index] = R.loc
	if(index >= 5)
		to_chat(user, SPAN_WARNING("You feel pain, as rune disappears in reality shift caused by too much wear of space-time fabric."))
		if(isliving(user))
			user.take_overall_damage(5, 0)
		qdel(src)
	if(allrunesloc && index != 0)
		if(isrune(src))
			user.say("Sas[pick("'", "`")]so c'arta forbici!")//Only you can stop auto-muting
		else
			user.whisper("Sas[pick("'", "`")]so c'arta forbici!")
		user.visible_message(SPAN_WARNING("[user] disappears in a flash of red light!"), \
							SPAN_WARNING("You feel as your body gets dragged through the dimension of Nar-Sie!"), \
							SPAN_WARNING("You hear a sickening crunch and sloshing of viscera."))
		user.loc = allrunesloc[rand(1, index)]
		return
	if(isrune(src))
		return fizzle() //Use friggin manuals, Dorf, your list was of zero length.
	else
		call(/obj/effect/rune/proc/fizzle)()
		return


/obj/effect/rune/proc/itemport(key)
//	var/list/allrunesloc = list()
//	var/index = 0
//	var/tempnum = 0
	var/culcount = 0
	var/runecount = 0
	var/obj/effect/rune/IP = null
	var/mob/living/user = usr
	for(var/obj/effect/rune/R in GLOBL.movable_atom_list)
		if(R == src)
			continue
		if(R.word1 == cultwords["travel"] && R.word2 == cultwords["other"] && R.word3 == key)
			IP = R
			runecount++
	if(runecount >= 2)
		to_chat(user, SPAN_WARNING("You feel pain, as rune disappears in reality shift caused by too much wear of space-time fabric."))
		if(isliving(user))
			user.take_overall_damage(5, 0)
		qdel(src)
	for(var/mob/living/carbon/C in orange(1, src))
		if(iscultist(C) && !C.stat)
			culcount++
	if(culcount >= 3)
		user.say("Sas[pick("'", "`")]so c'arta forbici tarem!")
		user.visible_message(
			SPAN_WARNING("You feel air moving from the rune - like as it was swapped with somewhere else."),
			SPAN_WARNING("You feel air moving from the rune - like as it was swapped with somewhere else."),
			SPAN_WARNING("You smell ozone.")
		)
		for(var/obj/O in src.loc)
			if(!O.anchored)
				O.loc = IP.loc
		for(var/mob/M in src.loc)
			M.loc = IP.loc
		return

	return fizzle()


/////////////////////////////////////////SECOND RUNE
/obj/effect/rune/proc/tomesummon()
	if(isrune(src))
		usr.say("N[pick("'", "`")]ath reth sh'yro eth d'raggathnor!")
	else
		usr.whisper("N[pick("'", "`")]ath reth sh'yro eth d'raggathnor!")
	usr.visible_message(
		SPAN_WARNING("Rune disappears with a flash of red light, and in its place now a book lies."),
		SPAN_WARNING("You are blinded by the flash of red light! After you're able to see again, you see that now instead of the rune there's a book."),
		SPAN_WARNING("You hear a pop and smell ozone.")
	)
	if(isrune(src))
		new /obj/item/tome(src.loc)
	else
		new /obj/item/tome(usr.loc)
	qdel(src)
	return


/////////////////////////////////////////THIRD RUNE
/obj/effect/rune/proc/convert()
	for(var/mob/living/carbon/M in src.loc)
		if(iscultist(M))
			continue
		if(M.stat == DEAD)
			continue
		usr.say("Mah[pick("'", "`")]weyh pleggh at e'ntrath!")
		M.visible_message(
			SPAN_WARNING("[M] writhes in pain as the markings below him glow a bloody red."),
			SPAN_WARNING("AAAAAAHHHH!."),
			SPAN_WARNING("You hear an anguished scream.")
		)
		if(is_convertable_to_cult(M.mind) && !jobban_isbanned(M, "cultist"))//putting jobban check here because is_convertable uses mind as argument
			global.PCticker.mode.add_cultist(M.mind)
			M.mind.special_role = "Cultist"
			to_chat(M, "<font color=\"purple\"><b><i>Your blood pulses. Your head throbs. The world goes red. All at once you are aware of a horrible, horrible truth. The veil of reality has been ripped away and in the festering wound left behind something sinister takes root.</b></i></font>")
			to_chat(M, "<font color=\"purple\"><b><i>Assist your new compatriots in their dark dealings. Their goal is yours, and yours is theirs. You serve the Dark One above all else. Bring It back.</b></i></font>")
			return 1
		else
			to_chat(M, "<font color=\"purple\"><b><i>Your blood pulses. Your head throbs. The world goes red. All at once you are aware of a horrible, horrible truth. The veil of reality has been ripped away and in the festering wound left behind something sinister takes root.</b></i></font>")
			to_chat(M, "<font color=\"red\"><b>And you were able to force it out of your mind. You now know the truth, there's something horrible out there, stop it and its minions at all costs.</b></font>")
			return 0

	return fizzle()


/////////////////////////////////////////FOURTH RUNE
/obj/effect/rune/proc/tearreality()
	var/cultist_count = 0
	for(var/mob/M in range(1, src))
		if(iscultist(M) && !M.stat)
			M.say("Tok-lyr rqa'nap g[pick("'", "`")]lt-ulotf!")
			cultist_count += 1
	if(cultist_count >= 9)
		new /obj/singularity/narsie/large(src.loc)
		if(IS_GAME_MODE(/datum/game_mode/cult))
			var/datum/game_mode/cult/cult = global.PCticker.mode
			cult.eldergod = 0
		return
	else
		return fizzle()


/////////////////////////////////////////FIFTH RUNE
/obj/effect/rune/proc/emp(U, range_red) //range_red - var which determines by which number to reduce the default emp range, U is the source loc, needed because of talisman emps which are held in hand at the moment of using and that apparently messes things up -- Urist
	if(isrune(src))
		usr.say("Ta'gh fara[pick("'", "`")]qha fel d'amar det!")
	else
		usr.whisper("Ta'gh fara[pick("'", "`")]qha fel d'amar det!")
	playsound(U, 'sound/items/Welder2.ogg', 25, 1)
	var/turf/T = GET_TURF(U)
	T?.hotspot_expose(700, 125)
	var/rune = src // detaching the proc - in theory
	empulse(U, (range_red - 2), range_red)
	qdel(rune)
	return


/////////////////////////////////////////SIXTH RUNE
/obj/effect/rune/proc/drain()
	if(!iscarbon(usr))
		return fizzle()
	var/mob/living/carbon/user = usr
	var/drain = 0
	for(var/obj/effect/rune/R in GLOBL.movable_atom_list)
		if(R.word1 == cultwords["travel"] && R.word2 == cultwords["blood"] && R.word3 == cultwords["self"])
			for(var/mob/living/carbon/D in R.loc)
				if(D.stat != DEAD)
					var/bdrain = rand(1, 25)
					to_chat(D, SPAN_WARNING("You feel weakened."))
					D.take_overall_damage(bdrain, 0)
					drain += bdrain
	if(!drain)
		return fizzle()
	user.say ("Yu[pick("'", "`")]gular faras desdae. Havas mithum javara. Umathar uf'kal thenar!")
	user.visible_message(
		SPAN_WARNING("Blood flows from the rune into [user]!"),
		SPAN_WARNING("The blood starts flowing from the rune and into your frail mortal body. You feel... empowered."),
		SPAN_WARNING("You hear a liquid flowing.")
	)
	if(user.bhunger)
		user.bhunger = max(user.bhunger - 2 * drain, 0)
	if(drain >= 50)
		user.visible_message(
			SPAN_WARNING("[user]'s eyes give off eerie red glow!"),
			SPAN_WARNING("...but it wasn't nearly enough. You crave, crave for more. The hunger consumes you from within."),
			SPAN_WARNING("You hear a heartbeat.")
		)
		user.bhunger += drain
		src = user
		spawn()
			for(, user.bhunger > 0, user.bhunger--)
				sleep(50)
				user.take_overall_damage(3, 0)
		return
	user.heal_organ_damage(drain % 5, 0)
	drain -= drain % 5
	for(, drain > 0, drain -= 5)
		sleep(2)
		user.heal_organ_damage(5, 0)

/////////////////////////////////////////SEVENTH RUNE
/obj/effect/rune/proc/seer()
	if(!iscarbon(usr) || usr.loc != src.loc)
		return fizzle()
	var/mob/living/carbon/user = usr
	if(user.seer)
		user.say("Rash'tla sektath mal[pick("'", "`")]zua. Zasan therium viortia.")
		to_chat(user, SPAN_WARNING("The world beyond fades from your vision."))
		user.see_invisible = SEE_INVISIBLE_LIVING
		user.seer = FALSE
	else if(user.see_invisible != SEE_INVISIBLE_LIVING)
		to_chat(user, SPAN_WARNING("The world beyond flashes your eyes but disappears quickly, as if something is disrupting your vision."))
		user.see_invisible = SEE_INVISIBLE_OBSERVER
		user.seer = FALSE
	else
		user.say("Rash'tla sektath mal[pick("'", "`")]zua. Zasan therium vivira. Itonis al'ra matum!")
		to_chat(user, SPAN_WARNING("The world beyond opens to your eyes."))
		user.see_invisible = SEE_INVISIBLE_OBSERVER
		user.seer = TRUE


/////////////////////////////////////////EIGHTH RUNE
/obj/effect/rune/proc/raise()
	var/mob/living/carbon/human/corpse_to_raise
	var/mob/living/carbon/human/body_to_sacrifice

	var/is_sacrifice_target = 0
	for(var/mob/living/carbon/human/M in src.loc)
		if(M.stat == DEAD)
			if(IS_GAME_MODE(/datum/game_mode/cult))
				var/datum/game_mode/cult/cult = global.PCticker.mode
				if(M.mind == cult.sacrifice_target)
					is_sacrifice_target = 1
			else
				corpse_to_raise = M
				if(M.key)
					M.ghostize(1)	//kick them out of their body
				break
	if(!corpse_to_raise)
		if(is_sacrifice_target)
			to_chat(usr, SPAN_WARNING("The Geometer of blood wants this mortal for himself."))
		return fizzle()

	is_sacrifice_target = 0
	find_sacrifice:
		for(var/obj/effect/rune/R in GLOBL.movable_atom_list)
			if(R.word1 == cultwords["blood"] && R.word2 == cultwords["join"] && R.word3 == cultwords["hell"])
				for(var/mob/living/carbon/human/N in R.loc)
					if(IS_GAME_MODE(/datum/game_mode/cult))
						var/datum/game_mode/cult/cult = global.PCticker.mode
						if(N.mind == cult.sacrifice_target)
							is_sacrifice_target = 1
					else
						if(N.stat != DEAD)
							body_to_sacrifice = N
							break find_sacrifice

	if(!body_to_sacrifice)
		if(is_sacrifice_target)
			to_chat(usr, SPAN_WARNING("The Geometer of blood wants that corpse for himself."))
		else
			to_chat(usr, SPAN_WARNING("The sacrifical corpse is not dead. You must free it from this world of illusions before it may be used."))
		return fizzle()

	var/mob/dead/observer/ghost
	for(var/mob/dead/observer/O in loc)
		if(!O.client)
			continue
		if(O.mind && O.mind.current && O.mind.current.stat != DEAD)
			continue
		ghost = O
		break

	if(!ghost)
		to_chat(usr, SPAN_WARNING("You require a restless spirit which clings to this world. Beckon their prescence with the sacred chants of Nar-Sie."))
		return fizzle()

	corpse_to_raise.revive()

	corpse_to_raise.key = ghost.key	//the corpse will keep its old mind! but a new player takes ownership of it (they are essentially possessed)
									//This means, should that player leave the body, the original may re-enter
	usr.say("Pasnar val'keriam usinar. Savrae ines amutan. Yam'toth remium il'tarat!")
	corpse_to_raise.visible_message(
		SPAN_WARNING("[corpse_to_raise]'s eyes glow with a faint red as he stands up, slowly starting to breathe again."),
		SPAN_WARNING("Life... I'm alive again..."),
		SPAN_WARNING("You hear a faint, slightly familiar whisper.")
	)
	body_to_sacrifice.visible_message(
		SPAN_WARNING("[body_to_sacrifice] is torn apart, a black smoke swiftly dissipating from his remains!"),
		SPAN_WARNING("You feel as your blood boils, tearing you apart."),
		SPAN_WARNING("You hear a thousand voices, all crying in pain.")
	)
	body_to_sacrifice.gib()

/*
	if(IS_GAME_MODE(/datum/game_mode/cult))
		var/datum/game_mode/cult/cult = global.PCticker.mode
		cult.add_cultist(corpse_to_raise.mind)
	else
		ticker.mode.cult |= corpse_to_raise.mind
*/

	to_chat(corpse_to_raise, "<font color=\"purple\"><b><i>Your blood pulses. Your head throbs. The world goes red. All at once you are aware of a horrible, horrible truth. The veil of reality has been ripped away and in the festering wound left behind something sinister takes root.</b></i></font>")
	to_chat(corpse_to_raise, "<font color=\"purple\"><b><i>Assist your new compatriots in their dark dealings. Their goal is yours, and yours is theirs. You serve the Dark One above all else. Bring It back.</b></i></font>")
	return


/////////////////////////////////////////NINETH RUNE
/obj/effect/rune/proc/obscure(rad)
	var/S = 0
	for(var/obj/effect/rune/R in orange(rad, src))
		if(R != src)
			R.invisibility = INVISIBILITY_OBSERVER
		S = 1
	if(S)
		if(isrune(src))
			usr.say("Kla[pick("'", "`")]atu barada nikt'o!")
			visible_message(SPAN_WARNING("The rune turns into gray dust, veiling the surrounding runes."))
			qdel(src)
		else
			usr.whisper("Kla[pick("'", "`")]atu barada nikt'o!")
			to_chat(usr, SPAN_WARNING("Your talisman turns into gray dust, veiling the surrounding runes."))
			for(var/mob/V in orange(1, src))
				if(V != usr)
					V.show_message(SPAN_WARNING("Dust emanates from [usr]'s hands for a moment."), 3)

		return
	if(isrune(src))
		return fizzle()
	else
		call(/obj/effect/rune/proc/fizzle)()
		return


/////////////////////////////////////////TENTH RUNE
/obj/effect/rune/proc/ajourney() //some bits copypastaed from admin tools - Urist
	if(!ishuman(usr) || usr.loc != src.loc)
		return fizzle()
	var/mob/living/carbon/human/L = usr
	L.say("Fwe[pick("'", "`")]sh mah erl nyag r'ya!")
	L.visible_message(
		SPAN_WARNING("[L]'s eyes glow blue as \he freezes in place, absolutely motionless."),
		SPAN_WARNING("The shadow that is your spirit separates itself from your body. You are now in the realm beyond. While this is a great sight, being here strains your mind and body. Hurry..."),
		SPAN_WARNING("You hear only complete silence for a moment.")
	)
	L.ghostize(1)
	L.ajourn = TRUE
	while(L)
		if(isnotnull(L.key))
			L.ajourn = FALSE
			return
		else
			L.take_organ_damage(10, 0)
		sleep(100)

/////////////////////////////////////////ELEVENTH RUNE
/obj/effect/rune/proc/manifest()
	var/obj/effect/rune/this_rune = src
	qdel(src)
	if(usr.loc != this_rune.loc)
		return this_rune.fizzle()
	var/mob/dead/observer/ghost
	for(var/mob/dead/observer/O in this_rune.loc)
		if(!O.client)
			continue
		if(O.mind && O.mind.current && O.mind.current.stat != DEAD)
			continue
		ghost = O
		break
	if(!ghost)
		return this_rune.fizzle()
	if(jobban_isbanned(ghost, "cultist"))
		return this_rune.fizzle()

	usr.say("Gal'h'rfikk harfrandid mud[pick("'", "`")]gib!")
	var/mob/living/carbon/human/dummy/D = new(this_rune.loc)
	usr.visible_message(
		SPAN_WARNING("A shape forms in the center of the rune. A shape of... a man."),
		SPAN_WARNING("A shape forms in the center of the rune. A shape of... a man."),
		SPAN_WARNING("You hear liquid flowing.")
	)
	D.real_name = "Unknown"
	var/chose_name = 0
	for(var/obj/item/paper/P in this_rune.loc)
		if(P.info)
			D.real_name = copytext(P.info, findtext(P.info,">") + 1, findtext(P.info, "<", 2) )
			chose_name = 1
			break
	if(!chose_name)
		D.real_name = "[pick(GLOBL.first_names_male)] [pick(GLOBL.last_names)]"
	D.universal_speak = 1
	D.status_flags &= ~GODMODE
	D.s_tone = 35
	D.b_eyes = 200
	D.r_eyes = 200
	D.g_eyes = 200
	D.underwear = 0

	D.key = ghost.key

	if(IS_GAME_MODE(/datum/game_mode/cult))
		var/datum/game_mode/cult/cult = global.PCticker.mode
		cult.add_cultist(D.mind)
	else
		global.PCticker.mode.cult.Add(D.mind)

	D.mind.special_role = "Cultist"
	to_chat(D, "<font color=\"purple\"><b><i>Your blood pulses. Your head throbs. The world goes red. All at once you are aware of a horrible, horrible truth. The veil of reality has been ripped away and in the festering wound left behind something sinister takes root.</b></i></font>")
	to_chat(D, "<font color=\"purple\"><b><i>Assist your new compatriots in their dark dealings. Their goal is yours, and yours is theirs. You serve the Dark One above all else. Bring It back.</b></i></font>")

	var/mob/living/user = usr
	while(this_rune && user && user.stat == CONSCIOUS && user.client && user.loc == this_rune.loc)
		user.take_organ_damage(1, 0)
		sleep(30)
	if(D)
		D.visible_message(
			SPAN_WARNING("[D] slowly dissipates into dust and bones."),
			SPAN_WARNING("You feel pain, as bonds formed between your soul and this homunculus break."),
			SPAN_WARNING("You hear a faint rustle.")
		)
		D.dust()
	return


/////////////////////////////////////////TWELFTH RUNE
/obj/effect/rune/proc/talisman()//only hide, emp, teleport, deafen, blind and tome runes can be imbued atm
	var/obj/item/paper/newtalisman
	var/unsuitable_newtalisman = 0
	for(var/obj/item/paper/P in src.loc)
		if(!P.info)
			newtalisman = P
			break
		else
			unsuitable_newtalisman = 1
	if(!newtalisman)
		if(unsuitable_newtalisman)
			to_chat(usr, SPAN_WARNING("The blank is tainted. It is unsuitable."))
		return fizzle()

	var/obj/effect/rune/imbued_from
	var/obj/item/paper/talisman/T
	for(var/obj/effect/rune/R in orange(1, src))
		if(R == src)
			continue
		if(R.word1==cultwords["travel"] && R.word2 == cultwords["self"])  //teleport
			T = new(src.loc)
			T.imbue = "[R.word3]"
			T.info = "[R.word3]"
			imbued_from = R
			break
		if(R.word1 == cultwords["see"] && R.word2 == cultwords["blood"] && R.word3 == cultwords["hell"]) //tome
			T = new(src.loc)
			T.imbue = "newtome"
			imbued_from = R
			break
		if(R.word1 == cultwords["destroy"] && R.word2 == cultwords["see"] && R.word3 == cultwords["technology"]) //emp
			T = new(src.loc)
			T.imbue = "emp"
			imbued_from = R
			break
		if(R.word1 == cultwords["blood"] && R.word2 == cultwords["see"] && R.word3 == cultwords["destroy"]) //conceal
			T = new(src.loc)
			T.imbue = "conceal"
			imbued_from = R
			break
		if(R.word1 == cultwords["hell"] && R.word2 == cultwords["destroy"] && R.word3 == cultwords["other"]) //armor
			T = new(src.loc)
			T.imbue = "armor"
			imbued_from = R
			break
		if(R.word1 == cultwords["blood"] && R.word2 == cultwords["see"] && R.word3 == cultwords["hide"]) //reveal
			T = new(src.loc)
			T.imbue = "revealrunes"
			imbued_from = R
			break
		if(R.word1 == cultwords["hide"] && R.word2 == cultwords["other"] && R.word3 == cultwords["see"]) //deafen
			T = new(src.loc)
			T.imbue = "deafen"
			imbued_from = R
			break
		if(R.word1 == cultwords["destroy"] && R.word2 == cultwords["see"] && R.word3 == cultwords["other"]) //blind
			T = new(src.loc)
			T.imbue = "blind"
			imbued_from = R
			break
		if(R.word1 == cultwords["self"] && R.word2 == cultwords["other"] && R.word3 == cultwords["technology"]) //communicat
			T = new(src.loc)
			T.imbue = "communicate"
			imbued_from = R
			break
		if(R.word1 == cultwords["join"] && R.word2 == cultwords["hide"] && R.word3 == cultwords["technology"]) //communicat
			T = new(src.loc)
			T.imbue = "runestun"
			imbued_from = R
			break
	if(imbued_from)
		visible_message(SPAN_WARNING("The runes turn into dust, which then forms into an arcane image on the paper."))
		usr.say("H'drak v[pick("'", "`")]loso, mir'kanas verbot!")
		qdel(imbued_from)
		qdel(newtalisman)
	else
		return fizzle()


/////////////////////////////////////////THIRTEENTH RUNE
/obj/effect/rune/proc/mend()
	var/mob/living/user = usr
	qdel(src)
	user.say("Uhrast ka'hfa heldsagen ver[pick("'", "`")]lot!")
	user.take_overall_damage(200, 0)
	runedec += 10
	user.visible_message(
		SPAN_WARNING("[user] keels over dead, his blood glowing blue as it escapes his body and dissipates into thin air."),
		SPAN_WARNING("In the last moment of your humble life, you feel an immense pain as fabric of reality mends... with your blood."),
		SPAN_WARNING("You hear faint rustle.")
	)
	for(, user.stat == DEAD)
		sleep(600)
		if(!user)
			return
	runedec -= 10
	return

/////////////////////////////////////////FOURTEETH RUNE
// returns 0 if the rune is not used. returns 1 if the rune is used.
/obj/effect/rune/proc/communicate()
	. = 1 // Default output is 1. If the rune is deleted it will return 1
	var/input = stripped_input(usr, "Please choose a message to tell to the other acolytes.", "Voice of Blood", "")
	if(!input)
		if(istype(src))
			fizzle()
			return 0
		else
			return 0
	if(isrune(src))
		usr.say("O bidai nabora se[pick("'", "`")]sma!")
	else
		usr.whisper("O bidai nabora se[pick("'", "`")]sma!")

	if(isrune(src))
		usr.say("[input]")
	else
		usr.whisper("[input]")
	for_no_type_check(var/datum/mind/H, global.PCticker.mode.cult)
		if(H.current)
			to_chat(H.current, SPAN_WARNING("\b [input]"))
	qdel(src)
	return 1


/////////////////////////////////////////FIFTEENTH RUNE
/obj/effect/rune/proc/sacrifice()
	var/list/mob/living/carbon/human/cultsinrange = list()
	var/list/mob/living/carbon/human/victims = list()
	for(var/mob/living/carbon/human/V in src.loc)	//Checks for non-cultist humans to sacrifice
		if(ishuman(V))
			if(!iscultist(V))
				victims += V		//Checks for cult status and mob type
	for(var/obj/item/I in src.loc)	//Checks for MMIs/brains/Intellicards
		if(istype(I, /obj/item/brain))
			var/obj/item/brain/B = I
			victims += B.brainmob
		else if(istype(I, /obj/item/mmi))
			var/obj/item/mmi/B = I
			victims += B.brainmob
		else if(istype(I, /obj/item/aicard))
			for(var/mob/living/silicon/ai/A in I)
				victims += A
	for(var/mob/living/carbon/C in orange(1, src))
		if(iscultist(C) && !C.stat)
			cultsinrange += C
			C.say("Barhah hra zar[pick("'", "`")]garis!")
	for(var/mob/H in victims)
		if(IS_GAME_MODE(/datum/game_mode/cult))
			var/datum/game_mode/cult/cult = global.PCticker.mode
			if(H.mind == cult.sacrifice_target)
				if(length(cultsinrange) >= 3)
					sacrificed += H.mind
					if(isrobot(H))
						H.dust()	//To prevent the MMI from remaining
					else
						H.gib()
					to_chat(usr, SPAN_WARNING("The Geometer of Blood accepts this sacrifice, your objective is now complete."))
				else
					to_chat(usr, SPAN_WARNING("Your target's earthly bonds are too strong. You need more cultists to succeed in this ritual."))
			else
				if(length(cultsinrange) >= 3)
					if(H.stat !=2)
						if(prob(80))
							FEEDBACK_CULT_SACRIFICE_ACCEPTED(usr)
							cult.grant_runeword(usr)
						else
							FEEDBACK_CULT_SACRIFICE_ACCEPTED(usr)
							to_chat(usr, SPAN_WARNING("However, this soul was not enough to gain His favor."))
						if(isrobot(H))
							H.dust()	//To prevent the MMI from remaining
						else
							H.gib()
					else
						if(prob(40))
							FEEDBACK_CULT_SACRIFICE_ACCEPTED(usr)
							cult.grant_runeword(usr)
						else
							FEEDBACK_CULT_SACRIFICE_ACCEPTED(usr)
							to_chat(usr, SPAN_WARNING("However, a mere dead body is not enough to satisfy Him."))
						if(isrobot(H))
							H.dust()	//To prevent the MMI from remaining
						else
							H.gib()
				else
					if(H.stat != DEAD)
						to_chat(usr, SPAN_WARNING("The victim is still alive, you will need more cultists chanting for the sacrifice to succeed."))
					else
						if(prob(40))
							FEEDBACK_CULT_SACRIFICE_ACCEPTED(usr)
							cult.grant_runeword(usr)
						else
							FEEDBACK_CULT_SACRIFICE_ACCEPTED(usr)
							to_chat(usr, SPAN_WARNING("However, a mere dead body is not enough to satisfy Him."))
						if(isrobot(H))
							H.dust()//To prevent the MMI from remaining
						else
							H.gib()
		else
			if(length(cultsinrange) >= 3)
				if(H.stat !=2)
					if(prob(80))
						FEEDBACK_CULT_SACRIFICE_ACCEPTED(usr)
						global.PCticker.mode.grant_runeword(usr)
					else
						FEEDBACK_CULT_SACRIFICE_ACCEPTED(usr)
						to_chat(usr, SPAN_WARNING("However, this soul was not enough to gain His favor."))
					if(isrobot(H))
						H.dust()//To prevent the MMI from remaining
					else
						H.gib()
				else
					if(prob(40))
						FEEDBACK_CULT_SACRIFICE_ACCEPTED(usr)
						global.PCticker.mode.grant_runeword(usr)
					else
						FEEDBACK_CULT_SACRIFICE_ACCEPTED(usr)
						to_chat(usr, SPAN_WARNING("However, a mere dead body is not enough to satisfy Him."))
					if(isrobot(H))
						H.dust()//To prevent the MMI from remaining
					else
						H.gib()
			else
				if(H.stat != DEAD)
					to_chat(usr, SPAN_WARNING("The victim is still alive, you will need more cultists chanting for the sacrifice to succeed."))
				else
					if(prob(40))
						FEEDBACK_CULT_SACRIFICE_ACCEPTED(usr)
						global.PCticker.mode.grant_runeword(usr)
					else
						FEEDBACK_CULT_SACRIFICE_ACCEPTED(usr)
						to_chat(usr, SPAN_WARNING("However, a mere dead body is not enough to satisfy Him."))
					if(isrobot(H))
						H.dust()//To prevent the MMI from remaining
					else
						H.gib()

	for(var/mob/living/carbon/monkey/M in src.loc)
		if(IS_GAME_MODE(/datum/game_mode/cult))
			var/datum/game_mode/cult/cult = global.PCticker.mode
			if(M.mind == cult.sacrifice_target)
				if(length(cultsinrange) >= 3)
					sacrificed += M.mind
					to_chat(usr, SPAN_WARNING("The Geometer of Blood accepts this sacrifice, your objective is now complete."))
				else
					to_chat(usr, SPAN_WARNING("Your target's earthly bonds are too strong. You need more cultists to succeed in this ritual."))
					continue
			else
				if(prob(20))
					to_chat(usr, SPAN_WARNING("The Geometer of Blood accepts your meager sacrifice."))
					cult.grant_runeword(usr)
				else
					to_chat(usr, SPAN_WARNING("The Geometer of blood accepts this sacrifice."))
					to_chat(usr, SPAN_WARNING("However, a mere monkey is not enough to satisfy Him."))
		else
			to_chat(usr, SPAN_WARNING("The Geometer of Blood accepts your meager sacrifice."))
			if(prob(20))
				global.PCticker.mode.grant_runeword(usr)
		M.gib()
/*
	for(var/mob/living/carbon/alien/A)
		for(var/mob/K in cultsinrange)
			K.say("Barhah hra zar'garis!")
		A.dust() /// A.gib() doesnt work for some reason, and dust() leaves that skull and bones thingy which we dont really need.
		if(IS_GAME_MODE(/datum/game_mode/cult))
			var/datum/game_mode/cult/cult = global.PCticker.mode
			if(prob(75))
				to_chat(usr, SPAN_WARNING("The Geometer of Blood accepts your exotic sacrifice."))
				cult.grant_runeword(usr)
			else
				to_chat(usr, SPAN_WARNING("The Geometer of Blood accepts your exotic sacrifice."))
				to_chat(usr, SPAN_WARNING("However, this alien is not enough to gain His favor."))
		else
			to_chat(usr, SPAN_WARNING("The Geometer of Blood accepts your exotic sacrifice."))
		return
	return fizzle()
*/


/////////////////////////////////////////SIXTEENTH RUNE
/obj/effect/rune/proc/revealrunes(obj/W)
	var/go = 0
	var/rad
	var/S = 0
	if(isrune(W))
		rad = 6
		go = 1
	if(istype(W, /obj/item/paper/talisman))
		rad = 4
		go = 1
	if(istype(W, /obj/item/nullrod))
		rad = 1
		go = 1
	if(go)
		for(var/obj/effect/rune/R in orange(rad, src))
			if(R != src)
				R:visibility = 15
			S = 1
	if(S)
		if(istype(W, /obj/item/nullrod))
			to_chat(usr, SPAN_WARNING("Arcane markings suddenly glow from underneath a thin layer of dust!"))
			return
		if(isrune(W))
			usr.say("Nikt[pick("'", "`")]o barada kla'atu!")
			visible_message(SPAN_WARNING("The rune turns into red dust, reveaing the surrounding runes."))
			qdel(src)
			return
		if(istype(W, /obj/item/paper/talisman))
			usr.whisper("Nikt[pick("'", "`")]o barada kla'atu!")
			to_chat(usr, SPAN_WARNING("Your talisman turns into red dust, revealing the surrounding runes."))
			for(var/mob/V in orange(1, usr.loc))
				if(V != usr)
					V.show_message(SPAN_WARNING("Red dust emanates from [usr]'s hands for a moment."), 3)
			return
		return
	if(isrune(W))
		return fizzle()
	if(istype(W, /obj/item/paper/talisman))
		call(/obj/effect/rune/proc/fizzle)()
		return


/////////////////////////////////////////SEVENTEENTH RUNE
/obj/effect/rune/proc/wall()
	usr.say("Khari[pick("'", "`")]d! Eske'te tannin!")
	src.density = !src.density
	var/mob/living/user = usr
	user.take_organ_damage(2, 0)
	if(src.density)
		to_chat(usr, SPAN_WARNING("Your blood flows into the rune, and you feel that the very space over the rune thickens."))
	else
		to_chat(usr, SPAN_WARNING("Your blood flows into the rune, and you feel as the rune releases its grasp on space."))
	return


/////////////////////////////////////////EIGHTTEENTH RUNE
/obj/effect/rune/proc/freedom()
	var/mob/living/user = usr
	var/list/mob/living/carbon/cultists = new
	for_no_type_check(var/datum/mind/H, global.PCticker.mode.cult)
		if(iscarbon(H.current))
			cultists += H.current
	var/list/mob/living/carbon/users = new
	for(var/mob/living/carbon/C in orange(1, src))
		if(iscultist(C) && !C.stat)
			users += C
	if(length(users) >= 3)
		var/mob/living/carbon/cultist = input("Choose the one who you want to free", "Followers of Geometer") as null|anything in (cultists - users)
		if(!cultist)
			return fizzle()
		if(cultist == user) //just to be sure.
			return
		if(!(cultist.buckled || \
			cultist.handcuffed || \
			istype(cultist.wear_mask, /obj/item/clothing/mask/muzzle) || \
			(istype(cultist.loc, /obj/structure/closet)&&cultist.loc:welded) || \
			(istype(cultist.loc, /obj/structure/closet/secure)&&cultist.loc:locked) || \
			(istype(cultist.loc, /obj/machinery/dna_scannernew)&&cultist.loc:locked) \
		))
			to_chat(user, SPAN_WARNING("The [cultist] is already free."))
			return
		cultist.buckled = null
		if(cultist.handcuffed)
			cultist.drop_from_inventory(cultist.handcuffed)
		if(cultist.legcuffed)
			cultist.drop_from_inventory(cultist.legcuffed)
		if(istype(cultist.wear_mask, /obj/item/clothing/mask/muzzle))
			cultist.u_equip(cultist.wear_mask)
		if(istype(cultist.loc, /obj/structure/closet) && cultist.loc:welded)
			cultist.loc:welded = 0
		if(istype(cultist.loc, /obj/structure/closet/secure) && cultist.loc:locked)
			cultist.loc:locked = 0
		if(istype(cultist.loc, /obj/machinery/dna_scannernew) && cultist.loc:locked)
			cultist.loc:locked = 0
		for(var/mob/living/carbon/C in users)
			user.take_overall_damage(15, 0)
			C.say("Khari[pick("'", "`")]d! Gual'te nikka!")
		qdel(src)
	return fizzle()


/////////////////////////////////////////NINETEENTH RUNE
/obj/effect/rune/proc/cultsummon()
	var/mob/living/user = usr
	var/list/mob/living/carbon/cultists = new
	for_no_type_check(var/datum/mind/H, global.PCticker.mode.cult)
		if(iscarbon(H.current))
			cultists += H.current
	var/list/mob/living/carbon/users = new
	for(var/mob/living/carbon/C in orange(1, src))
		if(iscultist(C) && !C.stat)
			users += C
	if(length(users) >= 3)
		var/mob/living/carbon/cultist = input("Choose the one who you want to summon", "Followers of Geometer") as null|anything in (cultists - user)
		if(!cultist)
			return fizzle()
		if(cultist == user) //just to be sure.
			return
		if(cultist.buckled || cultist.handcuffed || (!isturf(cultist.loc) && !istype(cultist.loc, /obj/structure/closet)))
			to_chat(user, SPAN_WARNING("You cannot summon \the [cultist], for his shackles of blood are strong."))
			return fizzle()
		cultist.loc = src.loc
		cultist.lying = 1
		cultist.regenerate_icons()
		for(var/mob/living/carbon/human/C in orange(1, src))
			if(iscultist(C) && !C.stat)
				C.say("N'ath reth sh'yro eth d[pick("'", "`")]rekkathnor!")
				C.take_overall_damage(25, 0)
		user.visible_message(
			SPAN_WARNING("Rune disappears with a flash of red light, and in its place now a body lies."),
			SPAN_WARNING("You are blinded by the flash of red light! After you're able to see again, you see that now instead of the rune there's a body."),
			SPAN_WARNING("You hear a pop and smell ozone.")
		)
		qdel(src)
	return fizzle()


/////////////////////////////////////////TWENTIETH RUNE
/obj/effect/rune/proc/deafen()
	if(isrune(src))
		var/affected = 0
		for(var/mob/living/carbon/C in range(7, src))
			if(iscultist(C))
				continue
			var/obj/item/nullrod/N = locate() in C
			if(N)
				continue
			C.ear_deaf += 50
			C.show_message(SPAN_WARNING("The world around you suddenly becomes quiet."), 3)
			affected++
			if(prob(1))
				C.sdisabilities |= DEAF
		if(affected)
			usr.say("Sti[pick("'","`")] kaliedir!")
			to_chat(usr, SPAN_WARNING("The world becomes quiet as the deafening rune dissipates into fine dust."))
			qdel(src)
		else
			return fizzle()
	else
		var/affected = 0
		for(var/mob/living/carbon/C in range(7, usr))
			if(iscultist(C))
				continue
			var/obj/item/nullrod/N = locate() in C
			if(N)
				continue
			C.ear_deaf += 30
			//talismans is weaker.
			C.show_message(SPAN_WARNING("The world around you suddenly becomes quiet."), 3)
			affected++
		if(affected)
			usr.whisper("Sti[pick("'","`")] kaliedir!")
			to_chat(usr, SPAN_WARNING("Your talisman turns into gray dust, deafening everyone around."))
			for(var/mob/V in orange(1, src))
				if(!iscultist(V))
					V.show_message(SPAN_WARNING("Dust flows from [usr]'s hands for a moment, and the world suddenly becomes quiet.."), 3)
	return


/////////////////////////////////////////TWENTY-FIRST RUNE
/obj/effect/rune/proc/blind()
	if(isrune(src))
		var/affected = 0
		for(var/mob/living/carbon/C in viewers(src))
			if(iscultist(C))
				continue
			var/obj/item/nullrod/N = locate() in C
			if(N)
				continue
			C.eye_blurry += 50
			C.eye_blind += 20
			if(prob(5))
				C.disabilities |= NEARSIGHTED
				if(prob(10))
					C.sdisabilities |= BLIND
			C.show_message(SPAN_WARNING("Suddenly you see red flash that blinds you."), 3)
			affected++
		if(affected)
			usr.say("Sti[pick("'","`")] kaliesin!")
			to_chat(usr, SPAN_WARNING("The rune flashes, blinding those who not follow the Nar-Sie, and dissipates into fine dust."))
			qdel(src)
		else
			return fizzle()
	else
		var/affected = 0
		for(var/mob/living/carbon/C in view(2, usr))
			if(iscultist(C))
				continue
			var/obj/item/nullrod/N = locate() in C
			if(N)
				continue
			C.eye_blurry += 30
			C.eye_blind += 10
			//talismans is weaker.
			affected++
			C.show_message(SPAN_WARNING("You feel a sharp pain in your eyes, and the world disappears into darkness.."), 3)
		if(affected)
			usr.whisper("Sti[pick("'","`")] kaliesin!")
			to_chat(usr, SPAN_WARNING("Your talisman turns into gray dust, blinding those who not follow the Nar-Sie."))
	return


/////////////////////////////////////////TWENTY-SECOND RUNE
/obj/effect/rune/proc/bloodboil() //cultists need at least one DANGEROUS rune. Even if they're all stealthy.
/*
	var/list/mob/living/carbon/cultists = new
	for_no_type_check(var/datum/mind/H, global.PCticker.mode.cult)
		if(iscarbon(H.current))
			cultists+=H.current
*/
	var/culcount = 0 //also, wording for it is old wording for obscure rune, which is now hide-see-blood.
//	var/list/cultboil = list(cultists-usr) //and for this words are destroy-see-blood.
	for(var/mob/living/carbon/C in orange(1, src))
		if(iscultist(C) && !C.stat)
			culcount++
	if(culcount >= 3)
		for(var/mob/living/carbon/M in viewers(usr))
			if(iscultist(M))
				continue
			var/obj/item/nullrod/N = locate() in M
			if(N)
				continue
			M.take_overall_damage(51, 51)
			to_chat(M, SPAN_WARNING("Your blood boils!"))
			if(prob(5))
				spawn(5)
					M.gib()
		for(var/obj/effect/rune/R in view(src))
			if(prob(10))
				explosion(R.loc, -1, 0, 1, 5)
		for(var/mob/living/carbon/human/C in orange(1, src))
			if(iscultist(C) && !C.stat)
				C.say("Dedo ol[pick("'","`")]btoh!")
				C.take_overall_damage(15, 0)
		qdel(src)
	else
		return fizzle()
	return


/////////////////////////////////////////TWENTY-THIRD RUNE
// WIP rune, I'll wait for Rastaf0 to add limited blood.
/obj/effect/rune/proc/burningblood()
	var/culcount = 0
	for(var/mob/living/carbon/C in orange(1, src))
		if(iscultist(C) && !C.stat)
			culcount++
	if(culcount >= 5)
		for(var/obj/effect/rune/R in GLOBL.movable_atom_list)
			if(R.blood_DNA == src.blood_DNA)
				for(var/mob/living/M in orange(2, R))
					M.take_overall_damage(0, 15)
					if(R.invisibility > M.see_invisible)
						to_chat(M, SPAN_WARNING("Aargh it burns!"))
					else
						to_chat(M, SPAN_WARNING("Rune suddenly ignites, burning you!"))
					var/turf/T = GET_TURF(R)
					T?.hotspot_expose(700, 125)
		for(var/obj/effect/decal/cleanable/blood/B in GLOBL.movable_atom_list)
			if(B.blood_DNA == src.blood_DNA)
				for(var/mob/living/M in orange(1, B))
					M.take_overall_damage(0, 5)
					to_chat(M, SPAN_WARNING("Blood suddenly ignites, burning you!"))
					var/turf/T = GET_TURF(B)
					T?.hotspot_expose(700, 125)
					qdel(B)
		qdel(src)


//////////				Rune 24 (counting burningblood, which kinda doesnt work yet.)
/obj/effect/rune/proc/runestun(mob/living/T)
	if(isrune(src))	///When invoked as rune, flash and stun everyone around.
		usr.say("Fuu ma[pick("'","`")]jin!")

		for(var/mob/living/L in viewers(src))
			if(iscarbon(L))
				var/mob/living/carbon/C = L
				flick("e_flash", C.flash)
				if(C.stuttering < 1 && !(MUTATION_HULK in C.mutations))
					C.stuttering = 1
				C.Weaken(1)
				C.Stun(1)
				C.show_message(SPAN_WARNING("The rune explodes in a bright flash."), 3)
			else if(issilicon(L))
				var/mob/living/silicon/S = L
				S.Weaken(5)
				S.show_message(SPAN_WARNING("BZZZT... The rune has exploded in a bright flash."), 3)
		qdel(src)
	else						///When invoked as talisman, stun and mute the target mob.
		usr.say("Dream sign ''Evil sealing talisman'[pick("'","`")]!")
		var/obj/item/nullrod/N = locate() in T
		if(N)
			T.visible_message(SPAN_DANGER("[usr] invokes a talisman at [T], but they are unaffected!"))
		else
			T.visible_message(SPAN_DANGER("[usr] invokes a talisman at [T]!"))

			if(issilicon(T))
				T.Weaken(15)

			else if(iscarbon(T))
				var/mob/living/carbon/C = T
				flick("e_flash", C.flash)
				if(!(MUTATION_HULK in C.mutations))
					C.silent += 15
				C.Weaken(25)
				C.Stun(25)
		return


/////////////////////////////////////////TWENTY-FIFTH RUNE
/obj/effect/rune/proc/armor()
	var/mob/living/carbon/human/user = usr
	if(isrune(src))
		usr.say("N'ath reth sh'yro eth d[pick("'","`")]raggathnor!")
	else
		usr.whisper("N'ath reth sh'yro eth d[pick("'","`")]raggathnor!")
	usr.visible_message(
		SPAN_WARNING("The rune disappears with a flash of red light, and a set of armor appears on [usr]..."),
		SPAN_WARNING("You are blinded by the flash of red light! After you're able to see again, you see that you are now wearing a set of armor.")
	)

	user.equip_to_slot_or_del(new /obj/item/clothing/head/culthood/alt(user), SLOT_ID_HEAD)
	user.equip_to_slot_or_del(new /obj/item/clothing/suit/cultrobes/alt(user), SLOT_ID_WEAR_SUIT)
	user.equip_to_slot_or_del(new /obj/item/clothing/shoes/cult(user), SLOT_ID_SHOES)
	user.equip_to_slot_or_del(new /obj/item/storage/backpack/cultpack(user), SLOT_ID_BACK)
	//the above update their overlay icons cache but do not call update_icons()
	//the below calls update_icons() at the end, which will update overlay icons by using the (now updated) cache
	user.put_in_hands(new /obj/item/melee/cultblade(user))	//put in hands or on floor

	qdel(src)
	return