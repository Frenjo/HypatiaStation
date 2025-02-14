/*
 * Job Controller
 */
CONTROLLER_DEF(jobs)
	name = "Jobs"

	// List of all jobs
	var/list/datum/job/occupations = list()
	// Players who need jobs
	var/list/mob/dead/new_player/unassigned = list()
	// Debug info
	var/list/job_debug = list()

/datum/controller/jobs/proc/setup_occupations()
	occupations = list()
	var/list/all_jobs = SUBTYPESOF(/datum/job)
	if(!length(all_jobs))
		to_world(SPAN_DANGER("Error setting up jobs, no job datums found!"))
		return 0
	for(var/J in all_jobs)
		var/datum/job/job = new J()
		if(isnull(job))
			continue
		occupations.Add(job)
	return 1

/datum/controller/jobs/proc/debug(text)
	if(!GLOBL.debug2)
		return 0
	job_debug.Add(text)
	return 1

/datum/controller/jobs/proc/get_job(rank)
	if(isnull(rank))
		return null
	for_no_type_check(var/datum/job/J, occupations)
		if(isnull(J))
			continue
		if(J.title == rank)
			return J
	return null

/datum/controller/jobs/proc/get_player_alt_title(mob/dead/new_player/player, rank)
	return player.client.prefs.GetPlayerAltTitle(get_job(rank))

/datum/controller/jobs/proc/assign_role(mob/dead/new_player/player, rank, latejoin = 0)
	debug("Running AR, Player: [player], Rank: [rank], LJ: [latejoin]")
	if(isnotnull(player?.mind) && isnotnull(rank))
		var/datum/job/job = get_job(rank)
		if(isnull(job))
			return 0
		if(jobban_isbanned(player, rank))
			return 0
		if(!job.player_old_enough(player.client))
			return 0
		var/position_limit = job.total_positions
		if(!latejoin)
			position_limit = job.spawn_positions
		if((job.current_positions < position_limit) || position_limit == -1)
			debug("Player: [player] is now Rank: [rank], JCP:[job.current_positions], JPL:[position_limit]")
			player.mind.assigned_role = rank
			player.mind.role_alt_title = get_player_alt_title(player, rank)
			unassigned.Remove(player)
			job.current_positions++
			return 1
	debug("AR has failed, Player: [player], Rank: [rank]")
	return 0

/datum/controller/jobs/proc/free_role(rank)	//making additional slot on the fly
	var/datum/job/job = get_job(rank)
	if(isnotnull(job) && job.current_positions >= job.total_positions && job.total_positions != -1)
		job.total_positions++
		return 1
	return 0

/datum/controller/jobs/proc/find_occupation_candidates(datum/job/job, level, flag)
	debug("Running FOC, Job: [job], Level: [level], Flag: [flag]")
	. = list()
	for_no_type_check(var/mob/dead/new_player/player, unassigned)
		if(jobban_isbanned(player, job.title))
			debug("FOC isbanned failed, Player: [player]")
			continue
		if(!job.player_old_enough(player.client))
			debug("FOC player not old enough, Player: [player]")
			continue
		if(flag && !(player.client.prefs.be_special & flag))
			debug("FOC flag failed, Player: [player], Flag: [flag], ")
			continue
		if(player.client.prefs.GetJobDepartment(job, level) & job.flag)
			debug("FOC pass, Player: [player], Level:[level]")
			. += player

/datum/controller/jobs/proc/give_random_job(mob/dead/new_player/player)
	debug("GRJ Giving random job, Player: [player]")
	for(var/datum/job/job in shuffle(occupations))
		if(isnull(job))
			continue

		if(istype(job, get_job("Assistant"))) // We don't want to give him assistant, that's boring!
			continue

		if(job in GLOBL.command_positions) //If you want a command position, select it!
			continue

		if(jobban_isbanned(player, job.title))
			debug("GRJ isbanned failed, Player: [player], Job: [job.title]")
			continue

		if(!job.player_old_enough(player.client))
			debug("GRJ player not old enough, Player: [player]")
			continue

		if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
			debug("GRJ Random job given, Player: [player], Job: [job]")
			assign_role(player, job.title)
			unassigned.Remove(player)
			break

/datum/controller/jobs/proc/reset_occupations()
	for(var/mob/dead/new_player/player in GLOBL.dead_mob_list)
		if(isnotnull(player?.mind))
			player.mind.assigned_role = null
			player.mind.special_role = null
	setup_occupations()
	unassigned = list()

//This proc is called before the level loop of DivideOccupations() and will try to select a head, ignoring ALL non-head preferences for every level until it locates a head or runs out of levels to check
/datum/controller/jobs/proc/fill_head_position()
	for(var/level = 1 to 3)
		for(var/command_position in GLOBL.command_positions)
			var/datum/job/job = get_job(command_position)
			if(isnull(job))
				continue
			var/list/candidates = find_occupation_candidates(job, level)
			if(!length(candidates))
				continue

			// Build a weighted list, weight by age.
			var/list/weightedCandidates = list()

			// Different head positions have different good ages.
			var/good_age_minimal = 25
			var/good_age_maximal = 60
			if(command_position == "Captain")
				good_age_minimal = 30
				good_age_maximal = 70 // Old geezer captains ftw

			for(var/mob/V in candidates)
				// Log-out during round-start? What a bad boy, no head position for you!
				if(isnull(V.client))
					continue
				var/age = V.client.prefs.age
				// I absolutely hate that this is necessary for now but I just cannot think of a better logical path.
				if(age >= (good_age_minimal - 10) && age <= good_age_minimal)
					weightedCandidates[V] = 3 // Still a bit young.
				else if(age >= good_age_minimal && age <= (good_age_minimal + 10))
					weightedCandidates[V] = 6 // Better.
				else if(age >= (good_age_minimal + 10) && age <= (good_age_maximal - 10))
					weightedCandidates[V] = 10 // Great.
				else if(age >= (good_age_maximal - 10) && age <= good_age_maximal)
					weightedCandidates[V] = 6 // Still good.
				else if(age >= good_age_maximal && age <= (good_age_maximal + 10))
					weightedCandidates[V] = 6 // Bit old, don't you think?
				else if(age >= good_age_maximal && age <= (good_age_maximal + 50))
					weightedCandidates[V] = 3 // Geezer.
				else
					// If there's ABSOLUTELY NOBODY ELSE
					if(length(candidates) == 1)
						weightedCandidates[V] = 1

				var/mob/dead/new_player/candidate = pickweight(weightedCandidates)
				if(assign_role(candidate, command_position))
					return 1
		return 0

//This proc is called at the start of the level loop of DivideOccupations() and will cause head jobs to be checked before any other jobs of the same level
/datum/controller/jobs/proc/check_head_positions(level)
	for(var/command_position in GLOBL.command_positions)
		var/datum/job/job = get_job(command_position)
		if(isnull(job))
			continue
		var/list/candidates = find_occupation_candidates(job, level)
		if(!length(candidates))
			continue
		var/mob/dead/new_player/candidate = pick(candidates)
		assign_role(candidate, command_position)

/datum/controller/jobs/proc/fill_ai_position()
	var/ai_selected = 0
	var/datum/job/job = get_job("AI")
	if(isnull(job))
		return 0
	if(job.title == "AI" && !CONFIG_GET(/decl/configuration_entry/allow_ai))
		return 0

	for(var/i = job.total_positions, i > 0, i--)
		for(var/level = 1 to 3)
			var/list/candidates = list()
			if(IS_GAME_MODE(/datum/game_mode/malfunction)) // Make sure they want to malf if its malf.
				candidates = find_occupation_candidates(job, level, BE_MALF)
			else
				candidates = find_occupation_candidates(job, level)
			if(length(candidates))
				var/mob/dead/new_player/candidate = pick(candidates)
				if(assign_role(candidate, "AI"))
					ai_selected++
					break
		//Malf NEEDS an AI so force one if we didn't get a player who wanted it
		if(IS_GAME_MODE(/datum/game_mode/malfunction) && !ai_selected)
			unassigned = shuffle(unassigned)
			for_no_type_check(var/mob/dead/new_player/player, unassigned)
				if(jobban_isbanned(player, "AI"))
					continue
				if(assign_role(player, "AI"))
					ai_selected++
					break
		if(ai_selected)
			return 1
		return 0

/** Proc DivideOccupations
 *  fills var "assigned_role" for all ready players.
 *  This proc must not have any side effect besides of modifying "assigned_role".
 **/
/datum/controller/jobs/proc/divide_occupations()
	//Setup new player list and get the jobs list
	debug("Running DO")
	setup_occupations()

	// Holder for Triumvirate is stored in the ticker, this just processes it.
	if(global.PCticker?.triai)
		for(var/datum/job/ai/A in occupations)
			A.spawn_positions = 3

	//Get the players who are ready
	for(var/mob/dead/new_player/player in GLOBL.dead_mob_list)
		if(player.ready && isnotnull(player.mind) && !player.mind.assigned_role)
			unassigned.Add(player)

	debug("DO, Len: [length(unassigned)]")
	if(!length(unassigned))
		return 0

	//Shuffle players and jobs
	unassigned = shuffle(unassigned)

	handle_feedback_gathering()

	//People who wants to be assistants, sure, go on.
	debug("DO, Running Assistant Check 1")
	var/list/assistant_candidates = find_occupation_candidates(GLOBL.all_jobs["Assistant"], 3)
	debug("AC1, Candidates: [length(assistant_candidates)]")
	for(var/mob/dead/new_player/player in assistant_candidates)
		debug("AC1 pass, Player: [player]")
		assign_role(player, "Assistant")
		assistant_candidates.Remove(player)
	debug("DO, AC1 end")

	//Select one head
	debug("DO, Running Head Check")
	fill_head_position()
	debug("DO, Head Check end")

	//Check for an AI
	debug("DO, Running AI Check")
	fill_ai_position()
	debug("DO, AI Check end")

	//Other jobs are now checked
	debug("DO, Running Standard Check")

	// New job giving system by Donkie
	// This will cause lots of more loops, but since it's only done once it shouldn't really matter much at all.
	// Hopefully this will add more randomness and fairness to job giving.

	// Loop through all levels from high to low
	var/list/datum/job/shuffledoccupations = shuffle(occupations)
	for(var/level = 1 to 3)
		//Check the head jobs first each level
		check_head_positions(level)

		// Loop through all unassigned players
		for_no_type_check(var/mob/dead/new_player/player, unassigned)
			// Loop through all jobs
			for_no_type_check(var/datum/job/job, shuffledoccupations) // SHUFFLE ME BABY
				if(isnull(job))
					continue

				if(jobban_isbanned(player, job.title))
					debug("DO isbanned failed, Player: [player], Job:[job.title]")
					continue

				if(!job.player_old_enough(player.client))
					debug("DO player not old enough, Player: [player], Job:[job.title]")
					continue

				// If the player wants that job on this level, then try give it to him.
				if(player.client.prefs.GetJobDepartment(job, level) & job.flag)
					// If the job isn't filled
					if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
						debug("DO pass, Player: [player], Level:[level], Job:[job.title]")
						assign_role(player, job.title)
						unassigned.Remove(player)
						break

	// Hand out random jobs to the people who didn't get any in the last check
	// Also makes sure that they got their preference correct
	for_no_type_check(var/mob/dead/new_player/player, unassigned)
		if(player.client.prefs.alternate_option == GET_RANDOM_JOB)
			give_random_job(player)

	debug("DO, Standard Check end")

	debug("DO, Running AC2")

	// For those who wanted to be assistant if their preferences were filled, here you go.
	for_no_type_check(var/mob/dead/new_player/player, unassigned)
		if(player.client.prefs.alternate_option == BE_ASSISTANT)
			debug("AC2 Assistant located, Player: [player]")
			assign_role(player, "Assistant")

	//For ones returning to lobby
	for_no_type_check(var/mob/dead/new_player/player, unassigned)
		if(player.client.prefs.alternate_option == RETURN_TO_LOBBY)
			player.ready = FALSE
			unassigned.Remove(player)
	return 1

/datum/controller/jobs/proc/equip_rank(mob/living/carbon/human/H, rank, joined_late = FALSE)
	if(isnull(H))
		return 0

	var/datum/job/job = get_job(rank)
	if(!istype(job, /datum/job/ai) && !istype(job, /datum/job/cyborg)) // AI/Cyborg checking is a temporary fix.
		if(isnotnull(job))
			job.equip(H, H.mind.role_alt_title)
		else
			to_chat(H, "Your job is [rank] and the game just can't handle it! Please report this bug to an administrator.")

	if(istype(job, /datum/job/captain))
		to_world("<b>[H.real_name] is the captain!</b>")

	H.job = rank

	if(!joined_late)
		var/obj/S = null
		for(var/obj/effect/landmark/start/sloc in GLOBL.landmark_list)
			if(sloc.name != rank)
				continue
			if(locate(/mob/living) in sloc.loc)
				continue
			S = sloc
			break
		if(isnull(S))
			S = locate("start*[rank]") // use old stype
		if(istype(S, /obj/effect/landmark/start) && isturf(S.loc))
			H.forceMove(S.loc)

	//give them an account in the station database
	var/datum/money_account/M = create_money_account(H.real_name, rand(50, 500) * 10, null)
	if(isnotnull(H.mind))
		var/remembered_info = ""
		remembered_info += "<b>Your account number is:</b> #[M.account_number]<br>"
		remembered_info += "<b>Your account pin is:</b> [M.remote_access_pin]<br>"
		remembered_info += "<b>Your account funds are:</b> $[M.money]<br>"

		if(length(M.transaction_log))
			var/datum/transaction/T = M.transaction_log[1]
			remembered_info += "<b>Your account was created:</b> [T.time], [T.date] at [T.source_terminal]<br>"
		H.mind.store_memory(remembered_info)

		H.mind.initial_account = M

	// If they're a head, give them the account info for their department.
	if(isnotnull(H.mind) && job.head_position)
		var/remembered_info = ""
		var/decl/department/department = GET_DECL_INSTANCE(job.department)
		var/datum/money_account/department_account = department.account

		if(department_account)
			remembered_info += "<b>Your department's account number is:</b> #[department_account.account_number]<br>"
			remembered_info += "<b>Your department's account pin is:</b> [department_account.remote_access_pin]<br>"
			remembered_info += "<b>Your department's account funds are:</b> $[department_account.money]<br>"

		H.mind.store_memory(remembered_info)

	// Displays job-based and standard spawn information.
	to_chat(H, jointext(job.get_spawn_message_content(H.mind.role_alt_title), "\n"))
	to_chat(H, SPAN_INFO_B("Your account number is: [M.account_number], your account pin is: [M.remote_access_pin]."))

	if(rank == "Cyborg")
		H.Robotize()
		return

	if(isnotnull(H.mind))
		H.mind.assigned_role = rank
		var/obj/item/card/id/identification = locate(/obj/item/card/id) in H
		if(isnotnull(identification))
			identification.access = job.get_access()
			if(isnotnull(H.mind.initial_account))
				// Puts the player's account number onto their ID.
				identification.associated_account_number = H.mind.initial_account.account_number

	if(ispath(job.special_survival_kit) && H.species.survival_kit == /obj/item/storage/box/survival)
		if(isnotnull(H.back))
			H.equip_to_slot_or_del(new job.special_survival_kit(H.back), SLOT_ID_IN_BACKPACK)
		else
			H.equip_to_slot_or_del(new job.special_survival_kit(H), SLOT_ID_R_HAND)
	else
		if(isnotnull(H.back))
			H.equip_to_slot_or_del(new H.species.survival_kit(H.back), SLOT_ID_IN_BACKPACK)
		else
			H.equip_to_slot_or_del(new H.species.survival_kit(H), SLOT_ID_R_HAND)

	//Gives glasses to the vision impaired
	if(H.disabilities & NEARSIGHTED)
		var/equipped = H.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(H), SLOT_ID_GLASSES)
		if(equipped != 1)
			var/obj/item/clothing/glasses/G = H.glasses
			G.prescription = 1
//	H.update_icons()

	BITSET(H.hud_updateflag, ID_HUD)
	BITSET(H.hud_updateflag, IMPLOYAL_HUD)
	BITSET(H.hud_updateflag, SPECIALROLE_HUD)
	return 1

/datum/controller/jobs/proc/load_jobs(jobsfile) //ran during round setup, reads info from jobs.txt -- Urist
	if(!CONFIG_GET(/decl/configuration_entry/load_jobs_from_txt))
		return 0

	var/list/jobEntries = file2list(jobsfile)

	for(var/job in jobEntries)
		if(!job)
			continue

		job = trim(job)
		if(!length(job))
			continue

		var/pos = findtext(job, "=")
		var/name = null
		var/value = null

		if(pos)
			name = copytext(job, 1, pos)
			value = copytext(job, pos + 1)
		else
			continue

		if(name && value)
			var/datum/job/J = get_job(name)
			if(isnull(J))
				continue
			J.total_positions = text2num(value)
			J.spawn_positions = text2num(value)
			if(name == "AI" || name == "Cyborg")	//I dont like this here but it will do for now
				J.total_positions = 0
	return 1

/datum/controller/jobs/proc/handle_feedback_gathering()
	for_no_type_check(var/datum/job/job, occupations)
		var/tmp_str = "|[job.title]|"

		var/level1 = 0 //high
		var/level2 = 0 //medium
		var/level3 = 0 //low
		var/level4 = 0 //never
		var/level5 = 0 //banned
		var/level6 = 0 //account too young
		for(var/mob/dead/new_player/player in GLOBL.dead_mob_list)
			if(!player.ready || isnull(player.mind) || player.mind.assigned_role)
				continue //This player is not ready
			if(jobban_isbanned(player, job.title))
				level5++
				continue
			if(!job.player_old_enough(player.client))
				level6++
				continue
			if(player.client.prefs.GetJobDepartment(job, 1) & job.flag)
				level1++
			else if(player.client.prefs.GetJobDepartment(job, 2) & job.flag)
				level2++
			else if(player.client.prefs.GetJobDepartment(job, 3) & job.flag)
				level3++
			else level4++ //not selected

		tmp_str += "HIGH=[level1]|MEDIUM=[level2]|LOW=[level3]|NEVER=[level4]|BANNED=[level5]|YOUNG=[level6]|-"
		feedback_add_details("job_preferences", tmp_str)