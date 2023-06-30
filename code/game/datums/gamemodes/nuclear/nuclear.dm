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
	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800 //upper bound on time before intercept arrives (in tenths of seconds)

	var/nukes_left = 1 // Call 3714-PRAY right now and order more nukes! Limited offer!
	var/nuke_off_station = 0 //Used for tracking if the syndies actually haul the nuke to the station
	var/syndies_didnt_escape = 0 //Used for tracking if the syndies got the shuttle off of the z-level

/datum/game_mode/nuclear/announce()
	to_world("<B>The current game mode is - Nuclear Emergency!</B>")
	to_world("<B>A [syndicate_name()] Strike Force is approaching [station_name()]!</B>")
	to_world("A nuclear explosive was being transported by NanoTrasen to a military base. The transport ship mysteriously lost contact with Space Traffic Control (STC). About that time a strange disk was discovered around [station_name()]. It was identified by NanoTrasen as a nuclear auth. disk and now Syndicate Operatives have arrived to retake the disk and detonate SS13! Also, most likely Syndicate star ships are in the vicinity so take care not to lose the disk!")
	to_world("<B>Syndicate</B>: Reclaim the disk and detonate the nuclear bomb anywhere on SS13.")
	to_world("<B>Personnel</B>: Hold the disk and <B>escape with the disk</B> on the shuttle!")

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

	for(var/datum/mind/synd_mind in syndicates)
		synd_mind.assigned_role = "MODE" //So they aren't chosen for other jobs.
		synd_mind.special_role = "Syndicate"//So they actually have a special role/N
	return 1


/datum/game_mode/nuclear/pre_setup()
	return 1

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
/datum/game_mode/proc/update_all_synd_icons()
	spawn(0)
		for(var/datum/mind/synd_mind in syndicates)
			if(synd_mind.current)
				if(synd_mind.current.client)
					for(var/image/I in synd_mind.current.client.images)
						if(I.icon_state == "synd")
							qdel(I)

		for(var/datum/mind/synd_mind in syndicates)
			if(synd_mind.current)
				if(synd_mind.current.client)
					for(var/datum/mind/synd_mind_1 in syndicates)
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
		for(var/datum/mind/synd in syndicates)
			if(synd.current)
				if(synd.current.client)
					for(var/image/I in synd.current.client.images)
						if(I.icon_state == "synd" && I.loc == synd_mind.current)
							qdel(I)

		if(synd_mind.current)
			if(synd_mind.current.client)
				for(var/image/I in synd_mind.current.client.images)
					if(I.icon_state == "synd")
						qdel(I)

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

/datum/game_mode/nuclear/post_setup()
	var/list/turf/synd_spawn = list()

	for(var/obj/effect/landmark/A in GLOBL.landmarks_list)
		if(A.name == "Syndicate-Spawn")
			synd_spawn += get_turf(A)
			qdel(A)
			continue

	var/obj/effect/landmark/uplinklocker = locate("landmark*Syndicate-Uplink")	//i will be rewriting this shortly
	var/obj/effect/landmark/nuke_spawn = locate("landmark*Nuclear-Bomb")

	var/nuke_code = "[rand(10000, 99999)]"
	var/leader_selected = 0
	var/spawnpos = 1

	for(var/datum/mind/synd_mind in syndicates)
		if(spawnpos > length(synd_spawn))
			spawnpos = 1
		synd_mind.current.loc = synd_spawn[spawnpos]

		synd_mind.current.real_name = "[syndicate_name()] Operative" // placeholder while we get their actual name
		spawn(0)
			NukeNameAssign(synd_mind)
		if(!CONFIG_GET(objectives_disabled))
			forge_syndicate_objectives(synd_mind)
		greet_syndicate(synd_mind)
		equip_syndicate(synd_mind.current)

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

	spawn (rand(waittime_l, waittime_h))
		send_intercept()

	return ..()


/datum/game_mode/proc/prepare_syndicate_leader(datum/mind/synd_mind, nuke_code)
	if(nuke_code)
		synd_mind.store_memory("<B>Syndicate Nuclear Bomb Code</B>: [nuke_code]", 0, 0)
		synd_mind.current << "The nuclear authorization code is: <B>[nuke_code]</B>"
		var/obj/item/weapon/paper/P = new
		P.info = "The nuclear authorization code is: <b>[nuke_code]</b>"
		P.name = "nuclear bomb code"
		if(IS_GAME_MODE(/datum/game_mode/nuclear))
			P.loc = synd_mind.current.loc
		else
			var/mob/living/carbon/human/H = synd_mind.current
			P.loc = H.loc
			H.equip_to_slot_or_del(P, SLOT_ID_R_STORE, 0)
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
		syndicate.current << "\blue You are a [syndicate_name()] agent!"
	var/obj_count = 1
	if(!CONFIG_GET(objectives_disabled))
		for(var/datum/objective/objective in syndicate.objectives)
			syndicate.current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
			obj_count++
	else
		syndicate.current << "<font color=blue>Within the rules,</font> try to act as an opposing force to the crew. Further RP and try to make sure other players have </i>fun<i>! If you are confused or at a loss, always adminhelp, and before taking extreme actions, please try to also contact the administration! Think through your actions and make the roleplay immersive! <b>Please remember all rules aside from those without explicit exceptions apply to antagonists.</i></b>"
	return


/datum/game_mode/proc/random_radio_frequency()
	return 1337 // WHY??? -- Doohl


/datum/game_mode/proc/equip_syndicate(mob/living/carbon/human/synd_mob)
	var/radio_freq = FREQUENCY_SYNDICATE

	var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate(synd_mob)
	R.radio_connection = register_radio(R, null, radio_freq, RADIO_CHAT)
	synd_mob.equip_to_slot_or_del(R, SLOT_ID_L_EAR)

	synd_mob.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(synd_mob), SLOT_ID_W_UNIFORM)
	synd_mob.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(synd_mob), SLOT_ID_SHOES)
	synd_mob.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(synd_mob), SLOT_ID_GLOVES)
	synd_mob.equip_to_slot_or_del(new /obj/item/weapon/card/id/syndicate(synd_mob), SLOT_ID_WEAR_ID)
	if(synd_mob.backbag == 2)
		synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(synd_mob), SLOT_ID_BACK)
	if(synd_mob.backbag == 3)
		synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/norm(synd_mob), SLOT_ID_BACK)
	if(synd_mob.backbag == 4)
		synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel(synd_mob), SLOT_ID_BACK)
	synd_mob.equip_to_slot_or_del(new /obj/item/ammo_magazine/a12mm(synd_mob), SLOT_ID_IN_BACKPACK)
	synd_mob.equip_to_slot_or_del(new /obj/item/ammo_magazine/a12mm(synd_mob), SLOT_ID_IN_BACKPACK)
	synd_mob.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/pill/cyanide(synd_mob), SLOT_ID_IN_BACKPACK)
	synd_mob.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/c20r(synd_mob), SLOT_ID_BELT)
	synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival/engineer(synd_mob.back), SLOT_ID_IN_BACKPACK)

	var/obj/item/clothing/suit/space/rig/syndi/new_suit = new(synd_mob)
	var/obj/item/clothing/head/helmet/space/rig/syndi/new_helmet = new(synd_mob)

	if(synd_mob.species)
		var/race = synd_mob.species.name

		switch(race)
			if(SPECIES_SOGHUN)
				new_suit.species_restricted = list(SPECIES_SOGHUN)
			if(SPECIES_TAJARAN)
				new_suit.species_restricted = list(SPECIES_TAJARAN)
			if(SPECIES_SKRELL)
				new_suit.species_restricted = list(SPECIES_SKRELL)

	synd_mob.equip_to_slot_or_del(new_suit, SLOT_ID_WEAR_SUIT)
	synd_mob.equip_to_slot_or_del(new_helmet, SLOT_ID_HEAD)

	var/obj/item/weapon/implant/explosive/E = new/obj/item/weapon/implant/explosive(synd_mob)
	E.imp_in = synd_mob
	E.implanted = 1
	synd_mob.update_icons()
	return 1


/datum/game_mode/nuclear/check_win()
	if(nukes_left == 0)
		return 1
	return ..()


/datum/game_mode/proc/is_operatives_are_dead()
	for(var/datum/mind/operative_mind in syndicates)
		if(!ishuman(operative_mind.current))
			if(operative_mind.current)
				if(operative_mind.current.stat != DEAD)
					return 0
	return 1


/datum/game_mode/nuclear/declare_completion()
	if(CONFIG_GET(objectives_disabled))
		return
	var/disk_rescued = 1
	for(var/obj/item/weapon/disk/nuclear/D in world)
		var/disk_area = get_area(D)
		if(!is_type_in_list(disk_area, GLOBL.centcom_areas))
			disk_rescued = 0
			break
	var/crew_evacuated = global.CTemergency.returned()
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

	var/text = "<FONT size = 2><B>The syndicate operatives were:</B></FONT>"
	for(var/datum/mind/syndicate in syndicates)
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
			M << "That name is reserved."
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