/datum/game_mode
	var/list/datum/mind/syndicates = list()

/datum/game_mode/nuclear
	name = "nuclear emergency"
	config_tag = "nuclear"
	required_players = 15
	required_players_secret = 25 // 25 players - 5 players to be the nuke ops = 20 players remaining
	required_enemies = 1
	recommended_enemies = 5

	uplink_welcome = "Corporate Backed Uplink Console:"
	uplink_uses = 40

	var/const/agents_possible = 5 //If we ever need more syndicate agents.

	var/nukes_left = 1 // Call 3714-PRAY right now and order more nukes! Limited offer!
	var/nuke_off_station = 0 //Used for tracking if the syndies actually haul the nuke to the station
	var/syndies_didnt_escape = 0 //Used for tracking if the syndies got the shuttle off of the z-level

/datum/game_mode/nuclear/get_announce_content()
	. = list()
	. += "<B>The current game mode is - Nuclear Emergency!</B>"
	. += "<B>A [syndicate_name()] Strike Force is approaching [station_name()]!</B>"
	. += "A nuclear explosive was being transported by NanoTrasen to a military base. The transport ship mysteriously lost contact with Space Traffic Control (STC). About that time a strange disk was discovered around [station_name()]. It was identified by NanoTrasen as a nuclear auth. disk and now Syndicate Operatives have arrived to retake the disk and detonate SS13! Also, most likely Syndicate star ships are in the vicinity so take care not to lose the disk!"
	. += "<B>Syndicate</B>: Reclaim the disk and detonate the nuclear bomb anywhere on SS13."
	. += "<B>Personnel</B>: Hold the disk and <B>escape with the disk</B> on the shuttle!"

/datum/game_mode/nuclear/can_start()//This could be better, will likely have to recode it later
	if(!..())
		return 0

	var/list/possible_syndicates = get_players_for_role(BE_OPERATIVE)
	var/agent_number = 0

    /*
	 * if(length(possible_syndicates) > agents_possible)
	 * 	agent_number = agents_possible
	 * else
	 * 	agent_number = length(possible_syndicates)
	 *
	 * if(agent_number > n_players)
	 *	agent_number = n_players/2
	 */

	if(length(possible_syndicates) < 1)
		return 0

	//Antag number should scale to active crew.
	var/n_players = num_players()
	agent_number = clamp((n_players / 5), 2, 6)

	if(length(possible_syndicates) < agent_number)
		agent_number = length(possible_syndicates)

	while(agent_number > 0)
		var/datum/mind/new_syndicate = pick(possible_syndicates)
		syndicates += new_syndicate
		possible_syndicates -= new_syndicate //So it doesn't pick the same guy each time.
		agent_number--

	for_no_type_check(var/datum/mind/synd_mind, syndicates)
		synd_mind.assigned_role = "MODE" //So they aren't chosen for other jobs.
		synd_mind.special_role = "Syndicate"//So they actually have a special role/N
	return 1

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
/datum/game_mode/proc/update_all_synd_icons()
	spawn(0)
		for_no_type_check(var/datum/mind/synd_mind, syndicates)
			if(synd_mind.current)
				if(synd_mind.current.client)
					for_no_type_check(var/image/I, synd_mind.current.client.images)
						if(I.icon_state == "synd")
							qdel(I)

		for_no_type_check(var/datum/mind/synd_mind, syndicates)
			if(synd_mind.current)
				if(synd_mind.current.client)
					for_no_type_check(var/datum/mind/synd_mind_1, syndicates)
						if(synd_mind_1.current)
							var/I = image('icons/mob/mob.dmi', loc = synd_mind_1.current, icon_state = "synd")
							synd_mind.current.client.images += I

/datum/game_mode/proc/update_synd_icons_added(datum/mind/synd_mind)
	spawn(0)
		if(synd_mind.current)
			if(synd_mind.current.client)
				var/I = image('icons/mob/mob.dmi', loc = synd_mind.current, icon_state = "synd")
				synd_mind.current.client.images += I

/datum/game_mode/proc/update_synd_icons_removed(datum/mind/synd_mind)
	spawn(0)
		for_no_type_check(var/datum/mind/synd, syndicates)
			if(synd.current)
				if(synd.current.client)
					for_no_type_check(var/image/I, synd.current.client.images)
						if(I.icon_state == "synd" && I.loc == synd_mind.current)
							qdel(I)

		if(synd_mind.current)
			if(synd_mind.current.client)
				for_no_type_check(var/image/I, synd_mind.current.client.images)
					if(I.icon_state == "synd")
						qdel(I)

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

/datum/game_mode/nuclear/post_setup()
	. = ..()
	var/list/turf/synd_spawn = list()

	for_no_type_check(var/obj/effect/landmark/A, GLOBL.landmark_list)
		if(A.name == "Syndicate-Spawn")
			synd_spawn += GET_TURF(A)
			qdel(A)
			continue

	var/obj/effect/landmark/uplinklocker = locate("landmark*Syndicate-Uplink")	//i will be rewriting this shortly
	var/obj/effect/landmark/nuke_spawn = locate("landmark*Nuclear-Bomb")

	var/nuke_code = "[rand(10000, 99999)]"
	var/leader_selected = 0
	var/spawnpos = 1

	for_no_type_check(var/datum/mind/synd_mind, syndicates)
		var/mob/living/carbon/human/synd_mob = synd_mind.current
		if(spawnpos > length(synd_spawn))
			spawnpos = 1
		synd_mob.forceMove(synd_spawn[spawnpos])

		synd_mob.real_name = "[syndicate_name()] Operative" // placeholder while we get their actual name
		spawn(0)
			NukeNameAssign(synd_mind)
		if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
			forge_syndicate_objectives(synd_mind)
		greet_syndicate(synd_mind)
		synd_mob.equip_outfit(/decl/hierarchy/outfit/syndicate/nuclear)

		if(!leader_selected)
			prepare_syndicate_leader(synd_mind, nuke_code)
			leader_selected = 1

		spawnpos++
		update_synd_icons_added(synd_mind)

	update_all_synd_icons()

	if(uplinklocker)
		new /obj/structure/closet/syndicate/nuclear(uplinklocker.loc)
	if(nuke_spawn && length(synd_spawn))
		var/obj/machinery/nuclearbomb/the_bomb = new /obj/machinery/nuclearbomb(nuke_spawn.loc)
		the_bomb.r_code = nuke_code

/datum/game_mode/proc/prepare_syndicate_leader(datum/mind/synd_mind, nuke_code)
	if(nuke_code)
		synd_mind.store_memory("<B>Syndicate Nuclear Bomb Code</B>: [nuke_code]", 0, 0)
		to_chat(synd_mind.current, "The nuclear authorisation code is: <B>[nuke_code]</B>")
		var/obj/item/paper/P = new
		P.info = "The nuclear authorisation code is: <b>[nuke_code]</b>"
		P.name = "nuclear bomb code"
		if(IS_GAME_MODE(/datum/game_mode/nuclear))
			P.forceMove(synd_mind.current.loc)
		else
			var/mob/living/carbon/human/H = synd_mind.current
			P.forceMove(H.loc)
			H.equip_to_slot_or_del(P, SLOT_ID_R_POCKET, 0)
			H.update_icons()

	else
		nuke_code = "code will be provided later"
	return


/datum/game_mode/proc/forge_syndicate_objectives(datum/mind/syndicate)
	var/datum/objective/nuclear/syndobj = new
	syndobj.owner = syndicate
	syndicate.objectives += syndobj


/datum/game_mode/proc/greet_syndicate(datum/mind/syndicate, you_are = 1)
	if(you_are)
		to_chat(syndicate.current, SPAN_INFO("You are a [syndicate_name()] agent!"))
	var/obj_count = 1
	if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
		for_no_type_check(var/datum/objective/objective, syndicate.objectives)
			to_chat(syndicate.current, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
			obj_count++
	else
		FEEDBACK_ANTAGONIST_GREETING_GUIDE(syndicate.current)
	return


/datum/game_mode/proc/random_radio_frequency()
	return 1337 // WHY??? -- Doohl


/datum/game_mode/nuclear/check_win()
	if(nukes_left == 0)
		return 1
	return ..()


/datum/game_mode/proc/is_operatives_are_dead()
	for_no_type_check(var/datum/mind/operative_mind, syndicates)
		if(!ishuman(operative_mind.current))
			if(operative_mind.current)
				if(operative_mind.current.stat != DEAD)
					return 0
	return 1


/datum/game_mode/nuclear/declare_completion()
	if(CONFIG_GET(/decl/configuration_entry/objectives_disabled))
		return
	var/disk_rescued = 1
	for(var/obj/item/disk/nuclear/D in GLOBL.movable_atom_list)
		var/area/disk_area = GET_AREA(D)
		if(!HAS_AREA_FLAGS(disk_area, AREA_FLAG_IS_CENTCOM))
			disk_rescued = 0
			break
	var/crew_evacuated = global.PCemergency.returned()
	//var/operatives_are_dead = is_operatives_are_dead()


	//nukes_left
	//station_was_nuked
	//derp //Used for tracking if the syndies actually haul the nuke to the station	//no
	//herp //Used for tracking if the syndies got the shuttle off of the z-level	//NO, DON'T FUCKING NAME VARS LIKE THIS

	if(!disk_rescued && station_was_nuked && !syndies_didnt_escape)
		feedback_set_details("round_end_result", "win - syndicate nuke")
		to_world("<FONT size = 3><B>Syndicate Major Victory!</B></FONT>")
		to_world("<B>[syndicate_name()] operatives have destroyed [station_name()]!</B>")

	else if(!disk_rescued && station_was_nuked && syndies_didnt_escape)
		feedback_set_details("round_end_result", "halfwin - syndicate nuke - did not evacuate in time")
		to_world("<FONT size = 3><B>Total Annihilation</B></FONT>")
		to_world("<B>[syndicate_name()] operatives destroyed [station_name()] but did not leave the area in time and got caught in the explosion.</B> Next time, don't lose the disk!")

	else if(!disk_rescued && !station_was_nuked && nuke_off_station && !syndies_didnt_escape)
		feedback_set_details("round_end_result", "halfwin - blew wrong station")
		to_world("<FONT size = 3><B>Crew Minor Victory</B></FONT>")
		to_world("<B>[syndicate_name()] operatives secured the authentication disk but blew up something that wasn't [station_name()].</B> Next time, don't lose the disk!")

	else if(!disk_rescued && !station_was_nuked && nuke_off_station && syndies_didnt_escape)
		feedback_set_details("round_end_result", "halfwin - blew wrong station - did not evacuate in time")
		to_world("<FONT size = 3><B>[syndicate_name()] operatives have earned a Darwin Award!</B></FONT>")
		to_world("<B>[syndicate_name()] operatives blew up something that wasn't [station_name()] and got caught in the explosion.</B> Next time, don't lose the disk!")

	else if(disk_rescued && is_operatives_are_dead())
		feedback_set_details("round_end_result", "loss - evacuation - disk secured - syndi team dead")
		to_world("<FONT size = 3><B>Crew Major Victory!</B></FONT>")
		to_world("<B>The Research Staff have saved the disk and killed the [syndicate_name()] Operatives</B>")

	else if(disk_rescued)
		feedback_set_details("round_end_result", "loss - evacuation - disk secured")
		to_world("<FONT size = 3><B>Crew Major Victory</B></FONT>")
		to_world("<B>The Research Staff have saved the disk and stopped the [syndicate_name()] Operatives!</B>")

	else if(!disk_rescued && is_operatives_are_dead())
		feedback_set_details("round_end_result", "loss - evacuation - disk not secured")
		to_world("<FONT size = 3><B>Syndicate Minor Victory!</B></FONT>")
		to_world("<B>The Research Staff failed to secure the authentication disk but did manage to kill most of the [syndicate_name()] Operatives!</B>")

	else if(!disk_rescued && crew_evacuated)
		feedback_set_details("round_end_result", "halfwin - detonation averted")
		to_world("<FONT size = 3><B>Syndicate Minor Victory!</B></FONT>")
		to_world("<B>[syndicate_name()] operatives recovered the abandoned authentication disk but detonation of [station_name()] was averted.</B> Next time, don't lose the disk!")

	else if(!disk_rescued && !crew_evacuated)
		feedback_set_details("round_end_result","halfwin - interrupted")
		to_world("<FONT size = 3><B>Neutral Victory</B></FONT>")
		to_world("<B>The round was mysteriously interrupted!</B>")

	..()
	return


/datum/game_mode/proc/auto_declare_completion_nuclear()
	if(!length(syndicates) && !IS_GAME_MODE(/datum/game_mode/nuclear))
		return

	var/text = "<FONT size = 2><B>The Syndicate operatives were:</B></FONT>"
	for_no_type_check(var/datum/mind/syndicate, syndicates)
		text += "<br>[syndicate.key] was [syndicate.name] ("
		if(isnotnull(syndicate.current))
			if(syndicate.current.stat == DEAD)
				text += "died"
			else
				text += "survived"
			if(syndicate.current.real_name != syndicate.name)
				text += " as [syndicate.current.real_name]"
		else
			text += "body destroyed"
		text += ")"
	to_world(text)


/*/proc/nukelastname(var/mob/M as mob) //--All praise goes to NEO|Phyte, all blame goes to DH, and it was Cindi-Kate's idea. Also praise Urist for copypasta ho.
	var/randomname = pick(last_names)
	var/newname = copytext(sanitize(input(M,"You are the nuke operative [pick("Czar", "Boss", "Commander", "Chief", "Kingpin", "Director", "Overlord")]. Please choose a last name for your family.", "Name change",randomname)),1,MAX_NAME_LEN)

	if (!newname)
		newname = randomname

	else
		if (newname == "Unknown" || newname == "floor" || newname == "wall" || newname == "rwall" || newname == "_")
			to_chat(M, "That name is reserved.")
			return nukelastname(M)

	return newname
*/

/proc/NukeNameAssign(datum/mind/synd_mind)
	var/choose_name = input(synd_mind.current, "You are a [syndicate_name()] agent! What is your name?", "Choose a name") as text

	if(!choose_name)
		return

	else
		synd_mind.current.name = choose_name
		synd_mind.current.real_name = choose_name
		return