/client/proc/one_click_antag()
	set category = PANEL_ADMIN
	set name = "Create Antagonist"
	set desc = "Auto-create an antagonist of your choice"

	if(isnotnull(holder))
		holder.one_click_antag()

/datum/admins/proc/one_click_antag()
	var/dat = {"<B>One-click Antagonist</B><br>
		<a href='byond://?src=\ref[src];makeAntag=1'>Make Traitors</a><br>
		<a href='byond://?src=\ref[src];makeAntag=2'>Make Changlings</a><br>
		<a href='byond://?src=\ref[src];makeAntag=3'>Make Revs</a><br>
		<a href='byond://?src=\ref[src];makeAntag=4'>Make Cult</a><br>
		<a href='byond://?src=\ref[src];makeAntag=5'>Make Malf AI</a><br>
		<a href='byond://?src=\ref[src];makeAntag=6'>Make Wizard (Requires Ghosts)</a><br>
		<a href='byond://?src=\ref[src];makeAntag=11'>Make Vox Raiders (Requires Ghosts)</a><br>
		"}
/* These dont work just yet
	Ninja, aliens and deathsquad I have not looked into yet
	Nuke team is getting a null mob returned from makebody() (runtime error: null.mind. Line 272)

		<a href='byond://?src=\ref[src];makeAntag=7'>Make Nuke Team (Requires Ghosts)</a><br>
		<a href='byond://?src=\ref[src];makeAntag=8'>Make Space Ninja (Requires Ghosts)</a><br>
		<a href='byond://?src=\ref[src];makeAntag=9'>Make Aliens (Requires Ghosts)</a><br>
		<a href='byond://?src=\ref[src];makeAntag=10'>Make Deathsquad (Syndicate) (Requires Ghosts)</a><br>
		"}
*/
	usr << browse(dat, "window=oneclickantag;size=400x400")

/datum/admins/proc/return_antagonist_candidates(role_flag, antagonist_type, restricted_jobs)
	var/list/candidates = list()
	for(var/mob/living/carbon/human/applicant in GLOBL.player_list)
		if(!(applicant.client.prefs.be_special & role_flag))
			continue
		if(!applicant.stat || isnull(applicant.mind))
			continue
		if(isnotnull(applicant.mind.special_role))
			continue
		if(jobban_isbanned(applicant, antagonist_type) || jobban_isbanned(applicant, "Syndicate"))
			continue
		if(applicant.job in restricted_jobs)
			continue
		candidates.Add(applicant)
	return candidates

/datum/admins/proc/make_ai_malfunction()
	var/list/mob/living/silicon/AIs = list()
	var/mob/living/silicon/malfAI = null

	for(var/mob/living/silicon/ai/ai in GLOBL.player_list)
		if(isnotnull(ai.client))
			AIs.Add(ai)

	if(length(AIs))
		malfAI = pick(AIs)

	if(isnotnull(malfAI))
		malfAI.mind.make_ai_malfunction()
		return 1
	return 0

/datum/admins/proc/make_traitors()
	var/datum/game_mode/traitor/temp = new /datum/game_mode/traitor()
	if(CONFIG_GET(protect_roles_from_antagonist))
		temp.restricted_jobs.Add(temp.protected_jobs)

	var/list/mob/living/carbon/human/candidates = return_antagonist_candidates(BE_TRAITOR, "traitor", temp.restricted_jobs)
	if(length(candidates))
		var/num_traitors = min(length(candidates), 3)
		for(var/i = 0, i < num_traitors, i++)
			var/mob/living/carbon/human/H = pick(candidates)
			H.mind.make_traitor()
			candidates.Remove(H)
		return 1
	return 0

/datum/admins/proc/make_changelings()
	var/datum/game_mode/changeling/temp = new /datum/game_mode/changeling()
	if(CONFIG_GET(protect_roles_from_antagonist))
		temp.restricted_jobs.Add(temp.protected_jobs)

	var/list/mob/living/carbon/human/candidates = return_antagonist_candidates(BE_CHANGELING, "changeling", temp.restricted_jobs)
	if(length(candidates))
		var/num_changelings = min(length(candidates), 3)
		for(var/i = 0, i < num_changelings, i++)
			var/mob/living/carbon/human/H = pick(candidates)
			H.mind.make_changeling()
			candidates.Remove(H)
		return 1
	return 0

/datum/admins/proc/make_revolutionaries()
	var/datum/game_mode/revolution/temp = new
	if(CONFIG_GET(protect_roles_from_antagonist))
		temp.restricted_jobs.Add(temp.protected_jobs)

	var/list/mob/living/carbon/human/candidates = return_antagonist_candidates(BE_REV, "revolutionary", temp.restricted_jobs)
	if(length(candidates))
		var/num_revs = min(length(candidates), 3)
		for(var/i = 0, i < num_revs, i++)
			var/mob/living/carbon/human/H = pick(candidates)
			H.mind.make_revolutionary()
			candidates.Remove(H)
		return 1
	return 0

/datum/admins/proc/make_wizard()
	var/list/mob/dead/observer/candidates = list()
	var/mob/dead/observer/theghost = null
	var/time_passed = world.time

	for(var/mob/dead/observer/G in GLOBL.player_list)
		if(jobban_isbanned(G, "wizard") || jobban_isbanned(G, "Syndicate"))
			continue
		spawn(0)
			switch(alert(G, "Do you wish to be considered for the position of Space Wizard Foundation 'diplomat'?", "Please answer in 30 seconds!", "Yes", "No"))
				if("Yes")
					if((world.time - time_passed) > 300) // If more than 30 game seconds passed.
						return
					candidates.Add(G)
				if("No")
					return
				else
					return

	sleep(300)

	if(length(candidates))
		shuffle(candidates)
		for(var/mob/i in candidates)
			if(isnull(i?.client))
				continue // Don't bother removing them from the list since we only grab one wizard

			theghost = i
			break

	if(isnotnull(theghost))
		var/mob/living/carbon/human/new_character = make_body(theghost)
		new_character.mind.make_wizard()
		return 1
	return 0

/datum/admins/proc/make_cult()
	var/datum/game_mode/cult/temp = new /datum/game_mode/cult()
	if(CONFIG_GET(protect_roles_from_antagonist))
		temp.restricted_jobs.Add(temp.protected_jobs)

	var/list/mob/living/carbon/human/candidates = return_antagonist_candidates(BE_CULTIST, "cultist", temp.restricted_jobs)
	if(length(candidates))
		var/num_cultists = min(length(candidates), 4)

		for(var/i = 0, i < num_cultists, i++)
			var/mob/living/carbon/human/H = pick(candidates)
			H.mind.make_cultist()
			candidates.Remove(H)
			temp.grant_runeword(H)
		return 1
	return 0

/datum/admins/proc/make_nuclear_operatives()
	var/list/mob/dead/observer/candidates = list()
	var/mob/dead/observer/theghost = null
	var/time_passed = world.time

	for(var/mob/dead/observer/G in GLOBL.player_list)
		if(jobban_isbanned(G, "operative") || jobban_isbanned(G, "Syndicate"))
			continue
		spawn(0)
			switch(alert(G,"Do you wish to be considered for a nuke team being sent in?", "Please answer in 30 seconds!", "Yes", "No"))
				if("Yes")
					if((world.time - time_passed) > 300) // If more than 30 game seconds passed.
						return
					candidates.Add(G)
				if("No")
					return
				else
					return

	sleep(300)

	if(length(candidates))
		var/num_agents = 5
		var/agentcount = 0

		for(var/i = 0, i < num_agents, i++)
			shuffle(candidates) // More shuffles means more randoms.
			for(var/mob/j in candidates)
				if(isnull(j?.client))
					candidates.Remove(j)
					continue

				theghost = candidates
				candidates.Remove(theghost)

				var/mob/living/carbon/human/new_character = make_body(theghost)
				new_character.mind.make_nuclear_operative()

				agentcount++

		if(agentcount < 1)
			return 0

		var/obj/effect/landmark/nuke_spawn = locate("landmark*Nuclear-Bomb")
		var/obj/effect/landmark/closet_spawn = locate("landmark*Nuclear-Closet")

		var/nuke_code = "[rand(10000, 99999)]"

		if(isnotnull(nuke_spawn))
			var/obj/item/paper/P = new /obj/item/paper()
			P.info = "Sadly, the Syndicate could not get you a nuclear bomb. We have, however, acquired the arming code for the station's onboard nuke. The nuclear authorisation code is: <b>[nuke_code]</b>"
			P.name = "nuclear bomb code and instructions"
			P.loc = nuke_spawn.loc

		if(isnotnull(closet_spawn))
			new /obj/structure/closet/syndicate/nuclear(closet_spawn.loc)

		for(var/obj/effect/landmark/A in /area/syndicate_station/start) // Because that's the only place it can BE -Sieve
			if(A.name == "Syndicate-Gear-Closet")
				new /obj/structure/closet/syndicate/personal(A.loc)
				qdel(A)
				continue

			if(A.name == "Syndicate-Bomb")
				new /obj/effect/spawner/newbomb/timer/syndicate(A.loc)
				qdel(A)
				continue

		for_no_type_check(var/datum/mind/synd_mind, global.PCticker.mode.syndicates)
			if(isnotnull(synd_mind.current?.client))
				for(var/image/I in synd_mind.current.client.images)
					if(I.icon_state == "synd")
						qdel(I)

		for_no_type_check(var/datum/mind/synd_mind, global.PCticker.mode.syndicates)
			if(isnotnull(synd_mind.current?.client))
				for_no_type_check(var/datum/mind/synd_mind_1, global.PCticker.mode.syndicates)
					if(isnotnull(synd_mind_1.current))
						var/I = image('icons/mob/mob.dmi', loc = synd_mind_1.current, icon_state = "synd")
						synd_mind.current.client.images.Add(I)

		for(var/obj/machinery/nuclearbomb/bomb in world)
			bomb.r_code = nuke_code // All the nukes are set to this code.

	return 1


/datum/admins/proc/make_aliens()
	alien_infestation(3)
	return 1

/datum/admins/proc/make_space_ninja()
	space_ninja_arrival()
	return 1

/datum/admins/proc/make_deathsquad()
	var/list/mob/dead/observer/candidates = list()
	var/mob/dead/observer/theghost = null
	var/time_passed = world.time
	var/input = "Purify the station."
	if(prob(10))
		input = "Save Runtime and any other cute things on the station."

	var/syndicate_leader_selected = 0 //when the leader is chosen. The last person spawned.

	//Generates a list of commandos from active ghosts. Then the user picks which characters to respawn as the commandos.
	for(var/mob/dead/observer/G in GLOBL.player_list)
		spawn(0)
			switch(alert(G,"Do you wish to be considered for an elite syndicate strike team being sent in?", "Please answer in 30 seconds!", "Yes", "No"))
				if("Yes")
					if((world.time - time_passed) > 300)//If more than 30 game seconds passed.
						return
					candidates.Add(G)
				if("No")
					return
				else
					return
	sleep(300)

	for(var/mob/dead/observer/G in candidates)
		if(isnull(G.key))
			candidates.Remove(G)

	if(length(candidates))
		var/num_agents = 6
		//Spawns commandos and equips them.
		for(var/obj/effect/landmark/L in /area/syndicate_mothership/elite_squad)
			if(num_agents <= 0)
				break
			if(L.name == "Syndicate-Commando")
				syndicate_leader_selected = num_agents == 1 ? TRUE : FALSE

				var/mob/living/carbon/human/new_syndicate_commando = create_syndicate_death_commando(L, syndicate_leader_selected)

				while((isnull(theghost) || isnull(theghost.client)) && length(candidates))
					theghost = pick(candidates)
					candidates.Remove(theghost)

				if(isnull(theghost))
					qdel(new_syndicate_commando)
					break

				new_syndicate_commando.key = theghost.key
				new_syndicate_commando.internal = new_syndicate_commando.suit_store
				new_syndicate_commando.internals.icon_state = "internal1"

				//So they don't forget their code or mission.

				to_chat(new_syndicate_commando, SPAN_INFO("You are an Elite Syndicate [!syndicate_leader_selected ? "commando" : "<B>LEADER</B>"] in the service of the Syndicate."))
				to_chat(new_syndicate_commando, "Your current mission is: [SPAN_DANGER(input)]")

				num_agents--
		if(num_agents >= 6)
			return 0

		for(var/obj/effect/landmark/L in /area/shuttle/syndicate_elite)
			if(L.name == "Syndicate-Commando-Bomb")
				new /obj/effect/spawner/newbomb/timer/syndicate(L.loc)

	return 1

/datum/admins/proc/make_body(mob/dead/observer/G_found) // Uses stripped down and bastardized code from respawn character
	if(isnull(G_found) || isnull(G_found.key))
		return

	//First we spawn a dude.
	var/mob/living/carbon/human/new_character = new(pick(GLOBL.latejoin)) // The mob being spawned.

	new_character.gender = pick(MALE, FEMALE)

	var/datum/preferences/A = new /datum/preferences()
	A.randomize_appearance_for(new_character)
	if(new_character.gender == MALE)
		new_character.real_name = "[pick(GLOBL.first_names_male)] [pick(GLOBL.last_names)]"
	else
		new_character.real_name = "[pick(GLOBL.first_names_female)] [pick(GLOBL.last_names)]"
	new_character.name = new_character.real_name
	new_character.age = rand(17, 45)

	new_character.dna.ready_dna(new_character)
	new_character.key = G_found.key

	return new_character

/datum/admins/proc/create_syndicate_death_commando(obj/spawn_location, syndicate_leader_selected = 0)
	var/mob/living/carbon/human/new_syndicate_commando = new(spawn_location.loc)
	var/syndicate_commando_leader_rank = pick("Lieutenant", "Captain", "Major")
	var/syndicate_commando_rank = pick("Corporal", "Sergeant", "Staff Sergeant", "Sergeant 1st Class", "Master Sergeant", "Sergeant Major")
	var/syndicate_commando_name = pick(GLOBL.last_names)

	new_syndicate_commando.gender = pick(MALE, FEMALE)

	var/datum/preferences/A = new /datum/preferences() // Randomizes appearance for the commando.
	A.randomize_appearance_for(new_syndicate_commando)

	new_syndicate_commando.real_name = "[!syndicate_leader_selected ? syndicate_commando_rank : syndicate_commando_leader_rank] [syndicate_commando_name]"
	new_syndicate_commando.name = new_syndicate_commando.real_name
	new_syndicate_commando.age = !syndicate_leader_selected ? rand(23, 35) : rand(35, 45)

	new_syndicate_commando.dna.ready_dna(new_syndicate_commando)//Creates DNA.

	//Creates mind stuff.
	new_syndicate_commando.mind_initialize()
	new_syndicate_commando.mind.assigned_role = "MODE"
	new_syndicate_commando.mind.special_role = "Syndicate Commando"

	//Adds them to current traitor list. Which is really the extra antagonist list.
	global.PCticker.mode.traitors.Add(new_syndicate_commando.mind)
	new_syndicate_commando.equip_outfit(syndicate_leader_selected ? /decl/hierarchy/outfit/syndicate_commando/leader : /decl/hierarchy/outfit/syndicate_commando/standard)

	return new_syndicate_commando

/datum/admins/proc/make_vox_raiders()
	var/list/mob/dead/observer/candidates = list()
	var/mob/dead/observer/theghost = null
	var/time_passed = world.time
	var/input = "Disregard shinies, acquire hardware."

	var/leader_chosen = 0 //when the leader is chosen. The last person spawned.

	//Generates a list of candidates from active ghosts.
	for(var/mob/dead/observer/G in GLOBL.player_list)
		spawn(0)
			switch(alert(G,"Do you wish to be considered for a vox raiding party arriving on the station?", "Please answer in 30 seconds!", "Yes", "No"))
				if("Yes")
					if((world.time - time_passed) > 300)//If more than 30 game seconds passed.
						return
					candidates.Add(G)
				if("No")
					return
				else
					return

	sleep(300) //Debug.

	for(var/mob/dead/observer/G in candidates)
		if(isnull(G.key))
			candidates.Remove(G)

	if(length(candidates))
		var/max_raiders = 1
		var/raiders = max_raiders
		//Spawns vox raiders and equips them.
		for_no_type_check(var/obj/effect/landmark/L, GLOBL.landmark_list)
			if(L.name == "voxstart")
				if(raiders <= 0)
					break

				var/mob/living/carbon/human/new_vox = create_vox_raider(L, leader_chosen)

				while((isnull(theghost) || isnull(theghost.client)) && length(candidates))
					theghost = pick(candidates)
					candidates.Remove(theghost)

				if(isnull(theghost))
					qdel(new_vox)
					break

				new_vox.key = theghost.key
				to_chat(new_vox, SPAN_INFO("You are a Vox Primalis, fresh out of the Shoal. Your ship has arrived at the Tau Ceti system hosting the NSV Exodus... or was it the Luna? NSS? Utopia? Nobody is really sure, but everyone is raring to start pillaging!"))
				to_chat(new_vox, "Your current goal is: [SPAN_DANGER(input)]")
				to_chat(new_vox, SPAN_WARNING("Don't forget to turn on your nitrogen internals!"))

				raiders--
			if(raiders > max_raiders)
				return 0
	else
		return 0
	return 1

/datum/admins/proc/create_vox_raider(obj/spawn_location, leader_chosen = 0)
	var/mob/living/carbon/human/new_vox = new(spawn_location.loc, SPECIES_VOX)

	new_vox.gender = pick(MALE, FEMALE)
	new_vox.h_style = "Short Vox Quills"
	new_vox.regenerate_icons()

	var/sounds = rand(2, 10)
	var/i = 0
	var/newname = ""

	while(i <= sounds)
		i++
		newname += pick(list("ti","hi","ki","ya","ta","ha","ka","ya","chi","cha","kah"))

	new_vox.real_name = capitalize(newname)
	new_vox.name = new_vox.real_name
	new_vox.age = rand(12, 20)

	new_vox.dna.ready_dna(new_vox) // Creates DNA.
	new_vox.dna.mutantrace = "vox"
	new_vox.mind_initialize()
	new_vox.mind.assigned_role = "MODE"
	new_vox.mind.special_role = "Vox Raider"
	new_vox.mutations |= NOCLONE //Stops the station crew from messing around with their DNA.

	global.PCticker.mode.traitors.Add(new_vox.mind)
	new_vox.equip_vox_raider()

	return new_vox