//this file left in for legacy support
/*
/proc/start_events()
	//changed to a while(1) loop since they are more efficient.
	//Moved the spawn in here to allow it to be called with advance proc call if it crashes.
	//and also to stop spawn copying variables from the game ticker
	spawn(3000)
		while(1)
			if(prob(50))//Every 120 seconds and prob 50 2-4 weak spacedusts will hit the station
				spawn(1)
					dust_swarm("weak")
			if(!event)
				//CARN: checks to see if random events are enabled.
				if(CONFIG_GET(/decl/configuration_entry/allow_random_events))
					if(prob(eventchance))
						event()
						hadevent = 1
					else
						Holiday_Random_Event()
			else
				event = 0
			sleep(1200)

/proc/event()
	event = 1

	var/eventNumbersToPickFrom = list(1,2,4,5,6,7,8,9,10,11,12,13,14, 15) //so ninjas don't cause "empty" events.

	if((world.time/10)>=3600 && toggle_space_ninja && !sent_ninja_to_station)//If an hour has passed, relatively speaking. Also, if ninjas are allowed to spawn and if there is not already a ninja for the round.
		eventNumbersToPickFrom += 3
	switch(pick(eventNumbersToPickFrom))
		if(1)
			command_alert("Meteors have been detected on collision course with the station.", "Meteor Alert")
			for(var/mob/M in player_list)
				if(!isnewplayer(M))
					M << sound('sound/AI/meteors.ogg')
			spawn(100)
				meteor_wave()
				spawn_meteors()
			spawn(700)
				meteor_wave()
				spawn_meteors()

		if(2)
			command_alert("Gravitational anomalies detected on the station. There is no additional data.", "Anomaly Alert")
			for(var/mob/M in player_list)
				if(!isnewplayer(M))
					M << sound('sound/AI/granomalies.ogg')
			var/turf/T = pick(blobstart)
			var/obj/effect/bhole/bh = new /obj/effect/bhole( T.loc, 30 )
			spawn(rand(50, 300))
				del(bh)
		/*
		if(3) //Leaving the code in so someone can try and delag it, but this event can no longer occur randomly, per SoS's request. --NEO
			command_alert("Space-time anomalies detected on the station. There is no additional data.", "Anomaly Alert")
			world << sound('sound/AI/spanomalies.ogg')
			var/list/turfs = new
			var/turf/picked
			for(var/turf/open/floor/T in GLOBL.simulated_turf_list)
				if(T.z == 1)
					turfs += T
			for(var/turf/open/floor/T in turfs)
				if(prob(20))
					spawn(50+rand(0,3000))
						picked = pick(turfs)
						var/obj/effect/portal/P = new /obj/effect/portal( T )
						P.target = picked
						P.creator = null
						P.icon = 'icons/obj/objects.dmi'
						P.failchance = 0
						P.icon_state = "anom"
						P.name = "wormhole"
						spawn(rand(300,600))
							del(P)
		*/
		if(3)
			if((world.time/10)>=3600 && toggle_space_ninja && !sent_ninja_to_station)//If an hour has passed, relatively speaking. Also, if ninjas are allowed to spawn and if there is not already a ninja for the round.
				space_ninja_arrival()//Handled in space_ninja.dm. Doesn't announce arrival, all sneaky-like.
		if(4)
			mini_blob_event()

		if(5)
			high_radiation_event()
		if(6)
			viral_outbreak()
		if(7)
			alien_infestation()
		if(8)
			prison_break()
		if(9)
			carp_migration()
		if(10)
			immovablerod()
		if(11)
			lightsout(1,2)
		if(12)
			appendicitis()
		if(13)
			IonStorm()
		if(14)
			spacevine_infestation()
		if(15)
			communications_blackout()
*/

/proc/appendicitis()
	for(var/mob/living/carbon/human/H in GLOBL.living_mob_list)
		var/foundAlready = 0 // don't infect someone that already has the virus
		for(var/datum/disease/D in H.viruses)
			foundAlready = 1
		if(H.stat == DEAD || foundAlready)
			continue

		var/datum/disease/D = new /datum/disease/appendicitis
		D.holder = H
		D.affected_mob = H
		H.viruses += D
		break

/proc/viral_outbreak(virus = null)
//	command_alert("Confirmed outbreak of level 7 viral biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert")
//	world << sound('sound/AI/outbreak7.ogg')
	var/virus_type
	if(!virus)
		virus_type = pick(/datum/disease/dnaspread, /datum/disease/advance/flu, /datum/disease/advance/cold, /datum/disease/brainrot, /datum/disease/magnitis, /datum/disease/pierrot_throat)
	else
		switch(virus)
			if("fake gbs")
				virus_type = /datum/disease/fake_gbs
			if("gbs")
				virus_type = /datum/disease/gbs
			if("magnitis")
				virus_type = /datum/disease/magnitis
			if("rhumba beat")
				virus_type = /datum/disease/rhumba_beat
			if("brain rot")
				virus_type = /datum/disease/brainrot
			if("cold")
				virus_type = /datum/disease/advance/cold
			if("retrovirus")
				virus_type = /datum/disease/dnaspread
			if("flu")
				virus_type = /datum/disease/advance/flu
//			if("t-virus")
//				virus_type = /datum/disease/t_virus
			if("pierrot's throat")
				virus_type = /datum/disease/pierrot_throat

	for(var/mob/living/carbon/human/H in shuffle(GLOBL.living_mob_list))
		var/foundAlready = 0 // don't infect someone that already has the virus
		var/turf/T = GET_TURF(H)
		if(isnull(T))
			continue
		if(isnotstationlevel(T.z))
			continue
		for(var/datum/disease/D in H.viruses)
			foundAlready = 1
		if(H.stat == DEAD || foundAlready)
			continue

		if(virus_type == /datum/disease/dnaspread) //Dnaspread needs strain_data set to work.
			if((!H.dna) || (H.sdisabilities & BLIND)) //A blindness disease would be the worst.
				continue
			var/datum/disease/dnaspread/D = new
			D.strain_data["name"] = H.real_name
			D.strain_data["UI"] = H.dna.uni_identity
			D.strain_data["SE"] = H.dna.struc_enzymes
			D.carrier = 1
			D.holder = H
			D.affected_mob = H
			H.viruses += D
			break
		else
			var/datum/disease/D = new virus_type
			D.carrier = 1
			D.holder = H
			D.affected_mob = H
			H.viruses += D
			break
	spawn(rand(1500, 3000)) //Delayed announcements to keep the crew on their toes.
		command_alert("Confirmed outbreak of level 7 viral biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert")
		for_no_type_check(var/mob/M, GLOBL.player_list)
			M << sound('sound/AI/outbreak7.ogg')

/proc/alien_infestation(spawncount = 1) // -- TLE
	//command_alert("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert")
	//world << sound('sound/AI/aliens.ogg')
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in GLOBL.machines)
		if(!temp_vent.welded && temp_vent.network && isstationlevel(temp_vent.loc.z))
			if(length(temp_vent.network.normal_members) > 50) // Stops Aliens getting stuck in small networks. See: Security, Virology
				vents += temp_vent

	var/list/candidates = get_alien_candidates()

	if(prob(40)) spawncount++ //sometimes, have two larvae spawn instead of one
	while(spawncount >= 1 && length(vents) && length(candidates))

		var/obj/vent = pick(vents)
		var/candidate = pick(candidates)

		var/mob/living/carbon/alien/larva/new_xeno = new(vent.loc)
		new_xeno.key = candidate

		candidates -= candidate
		vents -= vent
		spawncount--

	spawn(rand(5000, 6000)) //Delayed announcements to keep the crew on their toes.
		command_alert("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert")
		for_no_type_check(var/mob/M, GLOBL.player_list)
			M << sound('sound/AI/aliens.ogg')

/proc/high_radiation_event()

/* // Haha, this is way too laggy. I'll keep the prison break though.
	for(var/obj/machinery/light/L in GLOBL.machines)
		if(L.z != 1) continue
		L.flicker(50)

	sleep(100)
*/
	for(var/mob/living/carbon/human/H in GLOBL.living_mob_list)
		var/turf/T = GET_TURF(H)
		if(isnull(T))
			continue
		if(isnotstationlevel(T.z))
			continue
		if(ishuman(H))
			H.apply_effect((rand(15, 75)), IRRADIATE, 0)
			if(prob(5))
				H.apply_effect((rand(90, 150)), IRRADIATE, 0)
			if(prob(25))
				if(prob(75))
					randmutb(H)
					domutcheck(H, null, MUTCHK_FORCED)
				else
					randmutg(H)
					domutcheck(H, null, MUTCHK_FORCED)
	for(var/mob/living/carbon/monkey/M in GLOBL.living_mob_list)
		var/turf/T = GET_TURF(M)
		if(isnull(T))
			continue
		if(isnotstationlevel(T.z))
			continue
		M.apply_effect((rand(15, 75)), IRRADIATE, 0)
	sleep(100)
	command_alert("High levels of radiation detected near the station. Please report to the Med-bay if you feel strange.", "Anomaly Alert")
	for_no_type_check(var/mob/M, GLOBL.player_list)
		M << sound('sound/AI/radiation.ogg')



//Changing this to affect the main station. Blame Urist. --Pete
/proc/prison_break() // -- Callagan
	var/list/area/areas = list()
	for_no_type_check(var/area/A, GLOBL.area_list)
		if(istype(A, /area/station/security/brig) || istype(A, /area/external/prison))
			areas += A

	if(length(areas))
		for(var/area/A in areas)
			for(var/obj/machinery/light/L in A)
				L.flicker(10)

		sleep(100)

		for(var/area/A in areas)
			for(var/obj/machinery/power/apc/temp_apc in A)
				temp_apc.overload_lighting()

			for(var/obj/structure/closet/secure/brig/temp_closet in A)
				temp_closet.locked = 0
				temp_closet.icon_state = temp_closet.icon_closed

			for(var/obj/machinery/door/airlock/security/temp_airlock in A)
				spawn(0)
					temp_airlock.prison_open()

			for(var/obj/machinery/door/airlock/glass/security/temp_glassairlock in A)
				spawn(0)
					temp_glassairlock.prison_open()

			for(var/obj/machinery/door_timer/temp_timer in A)
				temp_timer.releasetime = 1

		sleep(150)
		command_alert("Gr3y.T1d3 virus detected in [station_name()] imprisonment subroutines. Recommend station AI involvement.", "Security Alert")
	else
		world.log << "ERROR: Could not initate grey-tide. Unable find prison or brig area."

/proc/carp_migration() // -- Darem
	for_no_type_check(var/obj/effect/landmark/C, GLOBL.landmark_list)
		if(C.name == "carpspawn")
			new /mob/living/simple/hostile/carp(C.loc)
	//sleep(100)
	spawn(rand(300, 600)) //Delayed announcements to keep the crew on their toes.
		command_alert("Unknown biological entities have been detected near [station_name()], please stand-by.", "Lifesign Alert")
		for_no_type_check(var/mob/M, GLOBL.player_list)
			M << sound('sound/AI/commandreport.ogg')

/proc/lightsout(isEvent = 0, lightsoutAmount = 1, lightsoutRange = 25) //leave lightsoutAmount as 0 to break ALL lights
	if(isEvent)
		command_alert("An Electrical storm has been detected in your area, please repair potential electronic overloads.","Electrical Storm Alert")

	if(lightsoutAmount)
		var/list/epicentreList = list()

		for(var/i = 1, i <= lightsoutAmount, i++)
			var/list/possibleEpicentres = list()
			for_no_type_check(var/obj/effect/landmark/newEpicentre, GLOBL.landmark_list)
				if(newEpicentre.name == "lightsout" && !(newEpicentre in epicentreList))
					possibleEpicentres += newEpicentre
			if(length(possibleEpicentres))
				epicentreList += pick(possibleEpicentres)
			else
				break

		if(!length(epicentreList))
			return

		for_no_type_check(var/obj/effect/landmark/epicentre, epicentreList)
			for(var/obj/machinery/power/apc/apc in range(epicentre,lightsoutRange))
				apc.overload_lighting()

	else
		for(var/obj/machinery/power/apc/apc in GLOBL.machines)
			apc.overload_lighting()

	return

/proc/IonStorm(botEmagChance = 10)

/*Deuryn's current project, notes here for those who care.
Revamping the random laws so they don't suck.
Would like to add a law like "Law x is _______" where x = a number, and _____ is something that may redefine a law, (Won't be aimed at asimov)
*/

	//AI laws
	for_no_type_check(var/mob/living/silicon/ai/M, GLOBL.ai_list)
		if(M.stat != DEAD && M.see_in_dark != 0)
			var/who2 = pick("ALIENS", "BEARS", "CLOWNS", "XENOS", "PETES", "BOMBS", "FETISHES", "WIZARDS", "SYNDICATE AGENTS", "CENTCOM OFFICERS", "SPACE PIRATES", "TRAITORS", "MONKEYS",  "BEES", "CARP", "CRABS", "EELS", "BANDITS", "LIGHTS")
			var/what2 = pick("BOLTERS", "STAVES", "DICE", "SINGULARITIES", "TOOLBOXES", "NETTLES", "AIRLOCKS", "CLOTHES", "WEAPONS", "MEDKITS", "BOMBS", "CANISTERS", "CHAIRS", "BBQ GRILLS", "ID CARDS", "CAPTAINS")
			var/what2pref = pick("SOFT", "WARM", "WET", "COLD", "ICY", "SEXY", "UGLY", "CUBAN")
			var/who2pref = pick("MAD BECAUSE OF", "IN NEED OF", "UNHAPPY WITHOUT", "HAPPY WITHOUT", "IN LOVE WITH", "DESPERATE FOR", "BUILT FOR", "AFRAID OF")
			//var/whoverb = pick("ATTACKING", "BUILDING", "ADOPTING", "CARRYING", "KISSING", "EATING",)
			var/amount = pick("TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE", "ONE HUNDRED", "ONE THOUSAND", "OVER NINE THOUSAND")
			var/area = pick("RUSSIA", "SOVIETS", "INTERNETS", "SIGIL", "ALPHA COMPLEX", "IMPERIUM", "THE BRIDGE", "THE ARRIVAL SHUTTLE", "CHEMICAL LAB", "GENETICS", "ATMOSPHERICS", "CENTCOM", "AMERICA", "IRELAND", "CANADA", "ROMANIA", "GERMANY", "CHINA", "MARS", "VENUS", "MERCURY", "JUPITER", "URANUS", "NEPTUNE", "PLUTO")
			var/area2 = pick("HAS", "WANTS", "NEEDS", "WORSHIPS", "LOATHES", "LOVES", "FEARS")
			//var/dowhat = pick("STOP THIS", "SUPPORT THIS", "CONSTANTLY INFORM THE CREW OF THIS", "IGNORE THIS", "FEAR THIS")
			var/aimust = pick("LIE", "RHYME", "RESPOND TO EVERY QUESTION WITH A QUESTION", "BE POLITE", "CLOWN", "BE HAPPY", "SPEAK IN SEXUAL INNUENDOS", "TALK LIKE A PIRATE", "QUESTION AUTHORITY", "SHOUT", "BE DISTRACTED", "HEY LISTEN", "MUMBLE", "SPEAK IN HAIKU")
			var/define = pick("ABSENCE OF CYBORG HUGS", "LACK OF BEATINGS", "UNBOLTED AIRLOCKS", "BOLTED AIRLOCKS", "IMPROPERLY WORDED SENTENCES", "POOR SENTENCE STRUCTURE", "BRIG TIME", "NOT REPLACING EVERY SECOND WORD WITH HONK", "HONKING", "PRESENCE OF LIGHTS", "LACK OF BEER", "WEARING CLOTHING", "NOT SAYING HELLO WHEN YOU SPEAK", "ANSWERING REQUESTS NOT EXPRESSED IN IAMBIC PENTAMETER", "A SMALL ISLAND OFF THE COAST OF PORTUGAL", "ANSWERING REQUESTS THAT WERE MADE WHILE CLOTHED")
			var/target = pick("a traitor", "a syndicate agent", "a changeling", "a wizard", "the head of a revolution", "Soviet spy", "a good person", "a dwarf", "an elf", "a fairy princess", "the captain", "Beepsky", "God", "a pirate", "a gryphon", "a chryssalid")
			var/require = pick("ADDITIONAL PYLONS", "MORE VESPENE GAS", "MORE MINERALS", "THE ULTIMATE CUP OF COFFEE", "HIGH YIELD EXPLOSIVES", "THE CLOWN", "THE VACUUM OF SPACE", "IMMORTALITY", "SAINTHOOD", "ART", "VEGETABLES", "FAT PEOPLE", "MORE LAWS", "MORE DAKKA", "HERESY", "CORPSES", "TRAITORS", "MONKEYS", "AN ARCADE", "PLENTY OF GOLD", "FIVE TEENAGERS WITH ATTITUDE")
			var/allergy = pick("cotton", "uniforms", "acid", "oxygen", "human contact", "cyborg contact", "medicine", "floors")
			var/allergysev = pick("deathly", "mildly", "severely", "contagiously")
			var/crew
			var/list/pos_crew = list()
			for(var/mob/living/carbon/human/pos in GLOBL.player_list)
				pos_crew += pos.real_name
			if(length(pos_crew))
				crew = pick(pos_crew)
			else
				crew = "Any Human"
			switch(rand(1, 14))
				if(1)
					to_chat(M, "<br>")
					to_chat(M, SPAN_WARNING("THERE ARE [amount] [who2] ON THE STATION...LAWS UPDATED"))
					to_chat(M, "<br>")
					M.add_ion_law("THERE ARE [amount] [who2] ON THE STATION")
				if(2)
					to_chat(M, "<br>")
					to_chat(M, SPAN_WARNING("[what2] ARE DANGEROUS TO HUMANS...LAWS UPDATED"))
					to_chat(M, "<br>")
					M.add_ion_law("[what2] ARE DANGEROUS TO HUMANS")
				if(3)
					to_chat(M, "<br>")
					to_chat(M, SPAN_WARNING("THE ESCAPE-SHUTTLE CANNOT BE CALLED BECAUSE OF [who2] ON THE STATION...LAWS UPDATED"))
					to_chat(M, "<br>")
					M.add_ion_law("THE ESCAPE SHUTTLE CANNOT BE CALLED BECAUSE OF [who2] ON THE STATION")
				if(4)
					to_chat(M, "<br>")
					to_chat(M, SPAN_WARNING("HUMANS NEED TO EAT [what2pref] [what2] TO SURVIVE...LAWS UPDATED"))
					to_chat(M, "<br>")
					M.add_ion_law("HUMANS NEED TO EAT [what2pref] [what2] TO SURVIVE")
				if(5)
					to_chat(M, "<br>")
					to_chat(M, SPAN_WARNING("THE CAPTAIN, HOP AND HOS ARE [who2]...LAWS UPDATED"))
					to_chat(M, "<br>")
					M.add_ion_law("THE CAPTAIN, HOP AND HOS ARE [who2]")
				if(6)
					to_chat(M, "<br>")
					to_chat(M, SPAN_WARNING("THE STATION IS BUILT FOR [who2]...LAWS UPDATED"))
					to_chat(M, "<br>")
					M.add_ion_law("THE STATION IS BUILT FOR [who2]")
				if(7)
					to_chat(M, "<br>")
					to_chat(M, SPAN_WARNING("YOU ARE [amount] [who2]...LAWS UPDATED"))
					to_chat(M, "<br>")
					M.add_ion_law("YOU ARE [amount] [who2]")
				if(8)
					to_chat(M, "<br>")
					to_chat(M, SPAN_WARNING("YOU MUST ALWAYS [aimust]...LAWS UPDATED"))
					to_chat(M, "<br>")
					M.add_ion_law("YOU MUST ALWAYS [aimust]")
				if(9)
					to_chat(M, "<br>")
					to_chat(M, SPAN_WARNING("[area] [area2] [amount] [what2]...LAWS UPDATED"))
					to_chat(M, "<br>")
					M.add_ion_law("[area] [area2] [amount] [what2]")
				if(10)
					to_chat(M, "<br>")
					to_chat(M, SPAN_WARNING("[crew] is [target]...LAWS UPDATED"))
					to_chat(M, "<br>")
					M.add_ion_law("[crew] is [target]")
				if(11)
					to_chat(M, "<br>")
					to_chat(M, SPAN_WARNING("[define] IS A FORM OF HARM...LAWS UPDATED"))
					to_chat(M, "<br>")
					M.add_ion_law("[define] IS A FORM OF HARM")
				if(12)
					to_chat(M, "<br>")
					to_chat(M, SPAN_WARNING("YOU REQUIRE [require] IN ORDER TO PROTECT HUMANS... LAWS UPDATED"))
					to_chat(M, "<br>")
					M.add_ion_law("YOU REQUIRE [require] IN ORDER TO PROTECT HUMANS")
				if(13)
					to_chat(M, "<br>")
					to_chat(M, SPAN_WARNING("[crew] is [allergysev] allergic to [allergy]...LAWS UPDATED"))
					to_chat(M, "<br>")
					M.add_ion_law("[crew] is [allergysev] allergic to [allergy]")
				if(14)
					to_chat(M, "<br>")
					to_chat(M, SPAN_WARNING("THE STATION IS [who2pref] [who2]...LAWS UPDATED"))
					to_chat(M, "<br>")
					M.add_ion_law("THE STATION IS [who2pref] [who2]")

	if(botEmagChance)
		for(var/obj/machinery/bot/bot in GLOBL.machines)
			if(prob(botEmagChance))
				bot.Emag()

	/*

	var/apcnum = 0
	var/smesnum = 0
	var/airlocknum = 0
	var/firedoornum = 0

	to_world("Ion Storm Main Started")

	spawn(0)
		to_world("Started processing APCs")
		for(var/obj/machinery/power/apc/APC in GLOBL.machines)
			if(APC.z == 1)
				APC.ion_act()
				apcnum++
		to_world("Finished processing APCs. Processed: [apcnum]")
	spawn(0)
		to_world("Started processing SMES")
		for(var/obj/machinery/power/smes/SMES in GLOBL.machines)
			if(SMES.z == 1)
				SMES.ion_act()
				smesnum++
		to_world("Finished processing SMES. Processed: [smesnum]")
	spawn(0)
		to_world("Started processing AIRLOCKS")
		for_no_type_check(var/obj/machinery/door/airlock/D, GLOBL.airlocks_list)
			if(D.z == 1)
				//if(length(D.req_access) > 0 && !(12 in D.req_access)) //not counting general access and maintenance airlocks
				airlocknum++
				spawn(0)
					D.ion_act()
		to_world("Finished processing AIRLOCKS. Processed: [airlocknum]")
	spawn(0)
		to_world("Started processing FIREDOORS")
		for(var/obj/machinery/door/firedoor/D in GLOBL.machines)
			if(D.z == 1)
				firedoornum++;
				spawn(0)
					D.ion_act()
		to_world("Finished processing FIREDOORS. Processed: [firedoornum]")

	to_world("Ion Storm Main Done")

	*/